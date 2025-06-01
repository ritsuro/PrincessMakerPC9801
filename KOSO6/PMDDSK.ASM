; "PMDDSK.ASM" PC-9801UV11 make by R.H 1990/06/04
;		modify 1991/02/02 R.H
;
;	音楽データロード
;
;	ＰＭＤ　Ｆｏｒ　ＰＣ－９８０１　Ｖ２．６専用
;
;	本ルーチンはＰ．Ｍ．Ｄの
;	GET_MUSDAT_ADR	AH=06H		DS:DX=MDAT_ADR	曲データを読み込む場所
;	GET_TONDAT_ADR	AH=07H		DS:DX=TDAT_ADR	音色データの場所
;	を利用して、音楽データと音色データを読み込みセットします。
;	従って実行のときはＰＭＤ動作中に行って下さい。
;
;	ＰＭＤ用の割り込みベクトルは、４０Ｈとしています。
;
;	必ず初期処理(PMDDIN)をすること。
;
;
; GAME subroutine.

INCLUDE	TSTSET.INC

PMDVECTOR	EQU	40H		; PMD用の割り込みベクトル
LENGTH_KYOKU	EQU	1024*5		; 曲データの長さ

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	PMDDIN			; 音楽ロード初期処理
PUBLIC	PMDLDK			; 曲データのロード
PUBLIC	PMDLDX			; 曲データの曲バッファ転送

EXTRN	DSKLDX:NEAR		; load data DTA.
EXTRN	DSKDTL:NEAR		; load DTA to user memory.


;	音楽ロード初期処理

PMDDIN	PROC	NEAR
	CALL	GETPMD_SEG	; ＰＭＤの常駐しているセグメントを取得する
	CALL	GET_ADRS	; ＰＭＤアドレスを取得する
	RET
PMDDIN	ENDP


;	曲データのロード
;	-I- PMDKYK : 曲データ番号

PMDLDK	PROC	NEAR
	CALL	CHK_KYOKU_NO		; 曲番号チェック
	CMP	AX,1			; 1=エラー
	JE	PMDLDK_EXIT		;

	MOV	BX,PMDKYK		; 曲データのロード
	SHL	BX,1			;
	MOV	SI,DS:FLNAME_KYOKU[BX]	; 曲ファイル名

	MOV	CX,LENGTH_KYOKU		; 曲データの長さ
	CALL	DSKLDX			; load data DTA.
PMDLDK_EXIT:
	RET
PMDLDK	ENDP


;	曲データの曲バッファ転送

PMDLDX	PROC	NEAR
	MOV	DX,PMDSEG		; ＰＭＤの常駐しているセグメント
	MOV	DI,ADRS_KYOKU		; 曲データアドレス
	MOV	CX,LENGTH_KYOKU		; 曲データの長さ
	CALL	DSKDTL			; load DTA to user memory.
	RET
PMDLDX	ENDP


;	ＰＭＤアドレスを取得する
;	-O- ADRS_KYOKU : 曲データアドレス
;	    ADRS_NEIRO : 音色データアドレス

GET_ADRS	PROC	NEAR
	MOV	AH,06H		; GET_MUSDAT_ADR 曲データを読み込む場所
	PUSH	DS		;
	INT	40H		; PMD.
	POP	DS		;
	MOV	ADRS_KYOKU,DX	; 曲データアドレス

	MOV	AH,07H		; GET_TONDAT_ADR 音色データの場所
	PUSH	DS		;
	INT	40H		; PMD.
	POP	DS		;
	MOV	ADRS_NEIRO,DX	; 音色データアドレス

	RET
GET_ADRS	ENDP


;	ＰＭＤの常駐しているセグメントを取得する
;	-O- PMDSEG : ＰＭＤの常駐しているセグメント

GETPMD_SEG	PROC	NEAR
	MOV	AX,0
	MOV	ES,AX
	MOV	AX,ES:[PMDVECTOR*4][2]	; PMD用の割り込みベクトル
	MOV	PMDSEG,AX
  	RET
GETPMD_SEG	ENDP


;	曲番号チェック
;	-I- PMDKYK : 曲データ番号
;	-O- AX     : 0=通常,1=エラー

CHK_KYOKU_NO	PROC	NEAR
	CMP	PMDKYK,1			; 曲データ番号
	JL	CHK_KYOKU_NO_ERROR		;
	MOV	AX,MAX_KYOKU			; 最大曲番号
	CMP	PMDKYK,AX			; 曲データ番号
	JG	CHK_KYOKU_NO_ERROR		;
	JMP	CHK_KYOKU_NO_EXIT		;
CHK_KYOKU_NO_ERROR:
	PRV	"PMDDSK.ASM 指定の曲がありません　PMDKYK=",PMDKYK
	MOV	AX,1				; エラー
	RET
CHK_KYOKU_NO_EXIT:
	MOV	AX,0				; 通常
	RET
CHK_KYOKU_NO	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	PMDKYK			; 曲データ番号
PUBLIC	PMDNIR			; 音色データ番号

PMDKYK		DW	1	; 曲データ番号
PMDNIR		DW	1	; 音色データ番号

PMDSEG		DW	0	; ＰＭＤの常駐しているセグメント
ADRS_KYOKU	DW	0	; 曲データアドレス
ADRS_NEIRO	DW	0	; 音色データアドレス

MAX_KYOKU	DW	15	; 最大曲番号
FLNAME_KYOKU	LABEL	WORD
		DW	0
		DW	OFFSET FLNAME_KYOKU1	;1
		DW	OFFSET FLNAME_KYOKU2	;2
		DW	OFFSET FLNAME_KYOKU3	;3
		DW	OFFSET FLNAME_KYOKU4	;4
		DW	OFFSET FLNAME_KYOKU5	;5
		DW	OFFSET FLNAME_KYOKU6	;6
		DW	OFFSET FLNAME_KYOKU7	;7
		DW	OFFSET FLNAME_KYOKU8	;8
		DW	OFFSET FLNAME_KYOKU9	;9
		DW	OFFSET FLNAME_KYOKU10	;10
		DW	OFFSET FLNAME_KYOKU11	;11
		DW	OFFSET FLNAME_KYOKU12	;12
		DW	OFFSET FLNAME_KYOKU13	;13
		DW	OFFSET FLNAME_KYOKU14	;14
		DW	OFFSET FLNAME_KYOKU15	;15
FLNAME_KYOKU1	DB	"PM1.M",0		;
FLNAME_KYOKU2	DB	"PM2.M",0		;
FLNAME_KYOKU3	DB	"PM3.M",0		;
FLNAME_KYOKU4	DB	"PM4.M",0		;
FLNAME_KYOKU5	DB	"PM5.M",0		;
FLNAME_KYOKU6	DB	"PM6.M",0		;
FLNAME_KYOKU7	DB	"PM7.M",0		;
FLNAME_KYOKU8	DB	"PM8.M",0		;
FLNAME_KYOKU9	DB	"PM9.M",0		;
FLNAME_KYOKU10	DB	"PM10.M",0		;
FLNAME_KYOKU11	DB	"PM11.M",0		;
FLNAME_KYOKU12	DB	"PM12.M",0		;
FLNAME_KYOKU13	DB	"PM13.M",0		;
FLNAME_KYOKU14	DB	"PM14.M",0		;
FLNAME_KYOKU15	DB	"PM15.M",0		;

;	「プリンセスメーカー」
;
;	PM1      M       1132  91-01-28   16:54
;	PM2      M       1296  91-01-28   16:54
;	PM3      M       1555  91-01-28   16:52
;	PM4      M       4128  91-01-28   16:52
;	PM5      M       1334  91-01-28   16:52
;	PM6      M        899  91-01-28   16:52
;	PM7      M       1140  91-01-28   16:52
;	PM8      M       1776  91-01-28   16:52
;	PM9      M       1642  91-01-28   16:52
;	PM10     M        624  91-01-28   16:52
;	PM11     M       2245  91-01-28   16:52
;	PM12     M       2031  91-01-28   16:52
;	PM13     M       1246  91-01-28   16:52
;	PM14     M       2183  91-01-28   16:52
;	PM15     M       3126  91-01-28   16:52

DATA	ENDS

	END
;
;	end of "PMDDSK.ASM"
;
