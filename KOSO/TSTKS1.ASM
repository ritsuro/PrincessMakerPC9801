; "TSTKS1.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	「子育て」
;
;	テスト	その１
;
;
STOP_KEY_DISABLE	EQU	1		; ストップキーを殺す
PROTECT_ENABLE		EQU	1		; プロテクト
EMS_ENABLE		EQU	1		; ＥＭＳ
;
;
;	デモモード一覧
;
;	EXTRN	WIDSDEMO:WORD		; (WIDSLCT.ASM)デモフラグ
;					; 0=通常,55=ランダムセレクト
;	EXTRN	WIDBDEMO:WORD		; (WIDBTN.ASM)デモフラグ
;					; 0=通常,33=ランダムセレクト
;	EXTRN	TALKDEMO:WORD		; (TALKER.ASM)デモフラグ
;					; 0=通常,55=ランダムセレクト
;
;	"KOSODATE.ASM"のローカルなデモフラグ
;		DEMO_MODE:WORD		: デモモード 0=通常,22=デモモード
;	"KOSODATE.ASM","KOSOMAIN.ASMのデモフラグ
;		DEMO_MODE_SYU:WORD	: デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ
;
;
; (C) 1990 ritsurou hashimoto.

DATA		SEGMENT	PUBLIC	'DATA'
DATA		ENDS
KYICOD		SEGMENT	PUBLIC	'KYICOD'
KYICOD		ENDS
MOUSE_CODE	SEGMENT	PUBLIC	'MOUSE_CODE'
MOUSE_CODE	ENDS
TMCODE		SEGMENT	PUBLIC	'TMCODE'
TMCODE		ENDS
IOPORT		SEGMENT	PUBLIC	'IOPORT'
IOPORT		ENDS
BIOSPORT	SEGMENT	PUBLIC	'BIOSPORT'
BIOSPORT	ENDS
PMD_CODE	SEGMENT	PUBLIC	'PMD_CODE'
PMD_CODE	ENDS
EMMCOD		SEGMENT	PUBLIC	'EMMCOD'
EMMCOD		ENDS
EMMDAT		SEGMENT	PUBLIC	'EMMDAT'
EMMDAT		ENDS
PALET		SEGMENT	PUBLIC	'PALET'
PALET		ENDS
WINDOW		SEGMENT	PUBLIC	'WINDOW'
WINDOW		ENDS
CODE		SEGMENT	PUBLIC	'CODE'
CODE		ENDS
SCCCODE		SEGMENT	PUBLIC	'SCCCODE'
SCCCODE		ENDS
R_SEG		SEGMENT	PUBLIC	'R_SEG'
R_SEG		ENDS
R_SEG2		SEGMENT	PUBLIC	'R_SEG2'
R_SEG2		ENDS
R_SEG3		SEGMENT	PUBLIC	'R_SEG3'
R_SEG3		ENDS



INCLUDE	TSTSET.INC
INCLUDE	KOSO.INC
INCLUDE	KOSO2.INC

;	ＰＲＧＲ	”表示文字列”

PRGR	MACRO	XXX,YYY,STRING
	LOCAL	L1
DATA	SEGMENT	PUBLIC	'DATA'
	EVEN
L1	DB	STRING,0
	EVEN
DATA	ENDS
	MOV	AX,XXX		; location x point.
	MOV	BX,YYY		; location y point.
	MOV	SI,OFFSET L1	;
	CALL	VTXPRN		; vram text print.
	ENDM



;	ＭＵＳＩＣ　Ｄｒｉｖｅｒ　“ＰＭＤ”

PMD_CODE	SEGMENT	PUBLIC	'PMD_CODE'
	ASSUME	CS:PMD_CODE
EXTRN	PMDSRT:FAR		; ＰＭＤの組み込み
PMD_CODE	ENDS

EXTRN	EMEMCHECK:FAR		; (far)Expanded memory check.
EXTRN	EMEMALLOC:FAR		; (far)Expanded memory allocate.
EXTRN	EMEMDEALLOC:FAR		; (far)Expanded memory deallocate.
EXTRN	EMEMQUICK:FAR		; (far)Expanded memory data name search.
EXTRN	EMEMLOAD:FAR		; (far)Expanded memory data load.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA,SS:STACK,ES:DATA

PUBLIC	XSTOPX		; ＳＴＯＰキー終了処理
			; デバック時にＳＴＯＰキーを押すとここに飛び込んでくる

EXTRN	PROTECT_CHECK:NEAR	; プロテクトチェック

EXTRN	TBLOPEN:NEAR		; 各セグメントの割り当て
EXTRN	TBLCLOSE:NEAR		; 各セグメントの開放

EXTRN	KOSODATE:NEAR		; 「子育て」

EXTRN	DKCINI:NEAR		; ディスクチェンジ初期処理

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス

EXTRN	KYBONS:NEAR		; keybord STOP key on.
EXTRN	KYBOFS:NEAR		; keybord STOP key off.

EXTRN	MUSINI:NEAR		; マウスの初期化
EXTRN	MUSSTP:NEAR		; マウスの終了

EXTRN	KYBSRT:NEAR		; keybord start.
EXTRN	KYBEND:NEAR		; keybord end.

EXTRN	M_INIT:NEAR		; 音楽システム初期処理
EXTRN	M_EXIT:NEAR		; 音楽システム終了処理
EXTRN	M_PLAY:NEAR		; 音楽演奏
EXTRN	M_STOP:NEAR		; 音楽停止
EXTRN	M_FDOT:NEAR		; 音楽フェードアウト
EXTRN	M_SHOU:NEAR		; 音楽小節ウエイト

EXTRN	PT_LD_KAZARI:NEAR	; 飾りＬＯＡＤ

; ****************************************************
;	ＳＴＡＲＴ
; ****************************************************

START:
	PUSH	DS			; save DS.

	MOV	AX,SEG DATA		; DS = DATA segment.
	MOV	DS,AX			;

	MOV	AX,SS			; stack segment.
	MOV	SAVE_SS,AX		;
	MOV	SAVE_SP,SP		; stack pointer.

	MOV	AX,SEG STACK		; stack segment.
	MOV	SS,AX			;
	MOV	SP,OFFSET TOP_OF_STACK	; stack pointer.

	CALL	TBLOPEN			; 各セグメントの割り当て

	CALL	MAIN			; main proc.

	CALL	TBLCLOSE		; 各セグメントの開放

	MOV	AX,SAVE_SS		;
	MOV	SS,AX			; stack segment.
	MOV	SP,SAVE_SP		; stack pointer.

	POP	DS			;
FINALE:	MOV	AH,4CH			; return to DOS.
	MOV	AL,0			;
	INT	21H			; end.
MUGEN:					;
	JMP	MUGEN			;


; ****************************************************
;	メイン処理
; ****************************************************

MAIN	PROC	NEAR
	MOV	AX,1			; 0=16x16  1=32x32  2=16x24  3=16x32
	CALL	VTXSIZ			; character size set.
	MOV	AX,2			; character color 0-15
	CALL	VTXCOL			; character color set.
	CALL	VRMCLR			; ＶＲＡＭクリア
	CALL	DSP16M			; １６色モードセット

	MOV	AX,SEGFRE		; フリー領域の先頭セグメント
	DEC	AX			;
	MOV	ES,AX			;
	MOV	WORD PTR ES:[14],0FFFFH	; フリーエリアの直前
	CMP	WORD PTR ES:[14],0FFFFH	;
	JNE	MAIN_NON_MEMORY		;
	MOV	WORD PTR ES:[14],0	; フリーエリアの直前
	CMP	WORD PTR ES:[14],0	;
	JNE	MAIN_NON_MEMORY		;

	CMP	SEGFRE,0A000H		; フリー領域の先頭セグメント
	JBE	MAIN_START		;
	CALL	CLS			;
	PRGR	10,10,"ドライバーが邪魔だよーん"
	RET
MAIN_NON_MEMORY:
	CALL	CLS			;
	PRGR	10,10,"６４０Ｋバイトメモリーを"
	PRGR	10,45,"増設してからあそんでね"
	RET
MAIN_START:

IF	STOP_KEY_DISABLE		; ストップキーを殺す
	CALL	KYBOFS			; keybord STOP key off.
ENDIF
	MOV	AX,SS			;
	MOV	MAIN_STACK_LEVEL_SS,AX	; ＳＴＯＰキー終了時に戻すスタック
	MOV	MAIN_STACK_LEVEL_SP,SP	; （XSTOPXを見よ）

	CALL	CLS			; cls.
	CALL	CSLOFF			; cursole off.

	CALL	VRMCLR			; ＶＲＡＭクリア
	CALL	DSP16M			; １６色モードセット

	CALL	PMDSRT			; ＰＭＤの組み込み

	CALL	KYBSRT			; keybord start.
	CALL	MUSINI			; マウスの初期化
	CALL	TMVSRT			; V-SYNC timer start.

;*;	CALL	MSCSRT			; カーソルスタート

	CALL	PATINI			; パーツセット初期処理

	CALL	VRMDP0			; ＶＲＡＭ０表示
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
;*;	CALL	VRMDP1			; ＶＲＡＭ１表示
;*;	CALL	VRMWT1			; ＶＲＡＭ１アクセス

	CALL	DKCINI			; ディスクチェンジ初期処理

	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	CALL	M_INIT			; 音楽システム初期処理

IF	PROTECT_ENABLE			; プロテクト
	CALL	PROTECT_CHECK		; プロテクトチェック
ENDIF
	CALL	EMEMCHECK		; (far)Expanded memory check.
	CMP	AX,1			; 1=ok,0=Expanded memory none.
	JNE	MAIN_MAIN		;

	CALL	PT_LD_KAZARI		; 飾りＬＯＡＤ

IF	EMS_ENABLE			; ＥＭＳ
	SELECT	"ＥＭＳを利用する,必要ない"
	CMP	WIDSNM,0		; ユーザ選択番号
	JNE	MAIN_MAIN		;

	CALL	EMEMALLOC		; (far)Expanded memory allocate.
	CALL	CLS			;
ENDIF

MAIN_MAIN:

	CALL	KOSODATE		; 「子育て」

MAIN_XSTOPX_EXIT:
	CALL	EMEMDEALLOC		; (far)Expanded memory deallocate.

	CALL	M_EXIT			; 音楽システム終了処理

;*;	CALL	MSCSTP			; カーソルストップ

	CALL	TMVEND			; V-SYNC timer end.
	CALL	MUSSTP			; マウスの終了
	CALL	KYBEND			; keybord end.

	CALL	CSLON			; cursole on.
	RET
MAIN	ENDP


; ****************************************************
;	ＳＴＯＰキー終了処理
;	デバック時にＳＴＯＰキーを押すとここに飛び込んでくる
; ****************************************************

XSTOPX	PROC	FAR
	MOV	AX,SEG DATA		;
	MOV	DS,AX			;
XSTOPX_2:
	TEST	BYTE PTR DS:KYTBLS[0],1000000B	; [STOP] key on?
	JNZ	XSTOPX_2			;
	MOV	CX,4000
XSTOPX_3:
	PUSH	AX
	POP	AX
	LOOP	XSTOPX_3
	TEST	BYTE PTR DS:KYTBLS[0],1000000B	; [STOP] key on?
	JNZ	XSTOPX_2			;

	CLI
	MOV	SP,MAIN_STACK_LEVEL_SP	;
	MOV	AX,MAIN_STACK_LEVEL_SS	; ＳＴＯＰキー終了時に戻すスタック
	MOV	SS,AX			;
	STI
	JMP	MAIN_XSTOPX_EXIT
XSTOPX	ENDP


CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SEGFRE:WORD			; フリー領域の先頭セグメント
EXTRN	KYTBLS:BYTE			; key code table top.
			EVEN
SAVE_SS			DW	0	; stack segment.
SAVE_SP			DW	0	; stack pointer.

MAIN_STACK_LEVEL_SS	DW	0	; ＳＴＯＰキー終了時に戻すスタック
MAIN_STACK_LEVEL_SP	DW	0	;

DATA	ENDS

STACK	SEGMENT	STACK
		EVEN
		DW	2000 DUP (0)
TOP_OF_STACK	LABEL	WORD
STACK	ENDS

	END	START
;
;	end of "TSTKS1.ASM"
;
