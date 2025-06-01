; "DMUSIC.ASM" PC-9801UV11 make by R.H 1990/06/04
;
;
;	音楽セット
;
;	ＰＭＤ　Ｆｏｒ　ＰＣ－９８０１　Ｖ２．６専用
;
;	ＰＭＤ用の割り込みベクトルは、４０Ｈとしています。
;
;	M_INIT		; 音楽システム初期処理
;	M_EXIT		; 音楽システム終了処理
;	M_PLAY		; 音楽演奏 ( AX : 曲データ番号 )
;	M_STOP		; 音楽停止
;	M_FDOT		; 音楽フェードアウト
;	M_SHOU		; 音楽小節ウエイト
;
;
;	ＰＭＤ組み込み時の注意
;
;	PMDSRT（ＰＭＤの組み込み）をＣＡＬＬしてから
;	PMDVRT（ＶＲＴＣ割込み）をＶＲＴＣのタイミングで
;	ＨＯＯＫさせて下さい。
;	そのあと M_INIT（音楽システム初期処理）をＣＡＬＬします。
;
;	終了時は M_STOP（音楽停止）をＣＡＬＬして終了させます。
;
;
;
; GAME subroutine.


INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	M_INIT			; 音楽システム初期処理
PUBLIC	M_EXIT			; 音楽システム終了処理
PUBLIC	M_PLAY			; 音楽演奏
PUBLIC	M_STOP			; 音楽停止
PUBLIC	M_FDOT			; 音楽フェードアウト
PUBLIC	M_SHOU			; 音楽小節ウエイト

EXTRN	PMDDIN:NEAR		; 音楽ロード初期処理
EXTRN	PMDLDK:NEAR		; 曲データのロード
EXTRN	PMDLDX:NEAR		; 曲データの曲バッファ転送

;	ＰＭＤ関連

MUSIC_START	EQU	00H	;		演奏の開始
MUSIC_STOP	EQU	01H	;		演奏の停止
FADEOUT		EQU	02H	;AL=speed	フェードアウトspped=1で最低速
EFFECT_ON	EQU	03H	;AL=efcnum	効果音の発音
EFFECT_OFF	EQU	04H	;		効果音の消音
GET_SYOUSETU	EQU	05H	;AL=syousetu	演奏開始して何小節目か
GET_MUSDAT_ADR	EQU	06H	;DS:DX=MDAT_ADR	曲データを読み込む場所
GET_TONDAT_ADR	EQU	07H	;DS:DX=TDAT_ADR	音色データの場所
GET_FOUT_VOL	EQU	08H	;AL=FOUT_VOL	255でFADEOUT終了
BOARD_CHECK	EQU	09H	;AL=BOARD_CHK	0であり/255でなし

PMD	MACRO	QQQQ		; ＰＭＤファンクション
	PUSH	DS		;
	MOV	AH,QQQQ		;
	INT	40H		;
	POP	DS		;
	ENDM			;

FO_SPEED	EQU	1	; フェードアウトスピード　（1で最低速）



;	音楽システム初期処理

M_INIT	PROC	NEAR
	MOV	MUSIC_ONOFF,1	; 音楽機能のＯＮ／ＯＦＦ
	CALL	M_STOP		; 音楽停止
	CALL	PMDDIN		; 音楽ロード初期処理
	RET
M_INIT	ENDP


;	音楽システム終了処理

M_EXIT	PROC	NEAR
	MOV	MUSIC_ONOFF,0	; 音楽機能のＯＮ／ＯＦＦ
	PMD	MUSIC_STOP	; 演奏の停止
	RET
M_EXIT	ENDP


;	音楽演奏
;	-I- AX : 曲データ番号

M_PLAY	PROC	NEAR
	CMP	MUSIC_ONOFF,0	; 音楽機能のＯＮ／ＯＦＦ
	JNE	M_PLAY_START	;
	RET
M_PLAY_START:
	MOV	NOW_MUSIC,AX	; 現在演奏中の音楽
	MOV	PMDKYK,AX	; 曲データ番号

	CMP	PMDKYK,0	; 曲データ番号
	JE	M_PLAY_EXIT	;

	CALL	PMDLDK		; 曲データのロード

	PMD	MUSIC_STOP	; 演奏の停止

	CALL	PMDLDX		; 曲データの曲バッファ転送

	PMD	MUSIC_START	; 演奏の開始
M_PLAY_EXIT:
	RET
M_PLAY	ENDP


;	音楽停止

M_STOP	PROC	NEAR
	CMP	MUSIC_ONOFF,0	; 音楽機能のＯＮ／ＯＦＦ
	JNE	M_STOP_START	;
	RET
M_STOP_START:
	MOV	NOW_MUSIC,-1	; 現在演奏中の音楽　－１＝音楽無し
	PMD	MUSIC_STOP	; 演奏の停止
	RET
M_STOP	ENDP


;	音楽フェードアウト

M_FDOT	PROC	NEAR
	CMP	MUSIC_ONOFF,0		; 音楽機能のＯＮ／ＯＦＦ
	JNE	M_FDOT_START		;
	RET
M_FDOT_START:
	MOV	NOW_MUSIC,-1		; 現在演奏中の音楽　－１＝音楽無し
	MOV	AL,FO_SPEED		; フェードアウトスピード
	PMD	FADEOUT			; フェードアウト
	RET
M_FDOT	ENDP


;	音楽小節ウエイト
;	-I- DX : 待つ小節数

M_SHOU	PROC	NEAR
	CMP	MUSIC_ONOFF,0		; 音楽機能のＯＮ／ＯＦＦ
	JNE	M_SHOU_START		;
	RET
M_SHOU_START:
	PUSH	DX			;
	PUSH	DS			;
	PMD	BOARD_CHECK		; AL=BOARD_CHK	0であり/255でなし
	POP	DS			;
	POP	DX			;
	CMP	AL,0			;
	JNE	M_SHOU_EXIT		;
M_SHOU_LOOP:
	PUSH	DX
	PUSH	DS
	PMD	GET_SYOUSETU		; AL=syousetu	演奏開始して何小節目か
	POP	DS
	POP	DX
	CMP	AL,DL
	JB	M_SHOU_LOOP
M_SHOU_EXIT:
	RET
M_SHOU	ENDP


CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	PMDKYK:WORD		; 曲データ番号
EXTRN	PMDNIR:WORD		; 音色データ番号

NOW_MUSIC	DW	-1	; 現在演奏中の音楽　－１＝音楽無し
MUSIC_ONOFF	DW	1	; 音楽機能のＯＮ／ＯＦＦ

DATA	ENDS

	END
;
;	end of "DMUSIC.ASM"
;
