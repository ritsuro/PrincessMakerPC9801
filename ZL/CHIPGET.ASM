; "CHIPGET.ASM" 1991/03/26 R.H PC-9801UV11 make by R.H 1989
;
;	チップＧＥＴ
;
; public subroutine.

INCLUDE	TSTSET.INC

CHIP_DATA_SIZE	EQU	4*32*4	; カーソルデータサイズ


MOVX	MACRO	DEST,SOU
	MOV	AX,SOU
	MOV	DEST,AX
	ENDM


GETCHIP	MACRO	XXX,YYY,NUM
	MOV	CURX,XXX	; カーソルＸ
	MOV	CURY,YYY	; カーソルＹ
	MOV	FL_NUMBER,NUM	; ファイル番号
	CALL	CHIP_GET_SAVE	; チップをＧＥＴしてＳＡＶＥする。
	ENDM

GETCHAR	MACRO	XXX,YYY,NUM
	MOV	CURX,XXX	; カーソルＸ
	MOV	CURY,YYY	; カーソルＹ
	MOV	FL_NUMBER,NUM	; ファイル番号
	CALL	CHAR_GET_SAVE	; キャラをＧＥＴしてＳＡＶＥする。
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	CHIPGET			; チップＧＥＴ

EXTRN	LODBET:NEAR		; ベタファイルロード

EXTRN	DSKLD:NEAR		; データロード
EXTRN	DSKSV:NEAR		; データセーブ

EXTRN	BOXPAL:NEAR		; ＢＯＸペイント
EXTRN	BOXMSS:NEAR		; ＢＯＸメッシュ

EXTRN	MCURMAKER:NEAR		; 直接カーソルデータファイル作成


;	チップＧＥＴ

CHIPGET	PROC	NEAR
	INP	"1=マップ,2=キャラ:"
	CALL	STRDEC
	CMP	DX,1
	JE	CHIPGET_MAP
	CMP	DX,2
	JE	CHIPGET_CHR
	RET
CHIPGET_MAP:
	CALL	MAPGET			; マップチップＧＥＴ
	RET
CHIPGET_CHR:
	CALL	CHARGET			; キャラＧＥＴ
	RET
CHIPGET	ENDP


;	マップチップＧＥＴ

MAPGET	PROC	NEAR
	INP	"ベタファイル読み込み="
	CALL	LODBET			; ベタファイルロード
	INP	"チップＧＥＴ stanby ?['Q':EXIT]:"

	MOV	FLNM_TOP[0],'C'		; "CIP"
	MOV	FLNM_TOP[1],'I'		;
	MOV	FLNM_TOP[2],'P'		;

	GETCHIP	0,40*0		,1
	GETCHIP	0,40*1		,2
	GETCHIP	0,40*2		,3
	GETCHIP	0,40*3		,4
	GETCHIP	0,40*4		,5
	GETCHIP	0,40*5		,6

	GETCHIP	5,40*0		,7
	GETCHIP	5,40*1		,8
	GETCHIP	5,40*2		,9
	GETCHIP	5,40*3		,10
	GETCHIP	5,40*4		,11
	GETCHIP	5,40*5		,12

	GETCHIP	10,40*0		,13
	GETCHIP	10,40*1		,14
	GETCHIP	10,40*2		,15
	GETCHIP	10,40*3		,16
	GETCHIP	10,40*4		,17
	GETCHIP	10,40*5		,18

	GETCHIP	15,40*0		,19
	GETCHIP	15,40*1		,20
	GETCHIP	15,40*2		,21
	GETCHIP	15,40*3		,22
	GETCHIP	15,40*4		,23
	GETCHIP	15,40*5		,24

	GETCHIP	20,40*0		,25
	GETCHIP	20,40*1		,26
	GETCHIP	20,40*2		,27
	GETCHIP	20,40*3		,28
	GETCHIP	20,40*4		,29
	GETCHIP	20,40*5		,30

	GETCHIP	25,40*0		,31
	GETCHIP	25,40*1		,32
	GETCHIP	25,40*2		,33
	GETCHIP	25,40*3		,34
	GETCHIP	25,40*4		,35
	GETCHIP	25,40*5		,36

	GETCHIP	30,40*0		,37
	GETCHIP	30,40*1		,38
	GETCHIP	30,40*2		,39
	GETCHIP	30,40*3		,40
	GETCHIP	30,40*4		,41
	GETCHIP	30,40*5		,42

	GETCHIP	35,40*0		,43
	GETCHIP	35,40*1		,44
	GETCHIP	35,40*2		,45
	GETCHIP	35,40*3		,46
	GETCHIP	35,40*4		,47
	GETCHIP	35,40*5		,48

	GETCHIP	40,40*0		,49
	GETCHIP	40,40*1		,50
	GETCHIP	40,40*2		,51
	GETCHIP	40,40*3		,52
	GETCHIP	40,40*4		,53

	RET
MAPGET	ENDP


;	キャラＧＥＴ

CHARGET	PROC	NEAR
	INP	"ベタファイル読み込み="
	CALL	LODBET			; ベタファイルロード
	INP	"キャラＧＥＴ stanby ?['Q':EXIT]:"

	MOV	FLNM_TOP[0],'C'		; "CHR"
	MOV	FLNM_TOP[1],'H'		;
	MOV	FLNM_TOP[2],'R'		;

	GETCHAR	51,00		,1
	GETCHAR	51,32		,2
	GETCHAR	51,72		,3
	GETCHAR	51,104		,4

	GETCHAR	56,00		,5
	GETCHAR	56,32		,6
	GETCHAR	56,72		,7
	GETCHAR	56,104		,8

	GETCHAR	61,00		,9
	GETCHAR	61,32		,10
	GETCHAR	61,72		,11
	GETCHAR	61,104		,12

	GETCHAR	66,00		,13
	GETCHAR	66,32		,14
	GETCHAR	66,72		,15
	GETCHAR	66,104		,16

	RET
CHARGET	ENDP


;	チップをＧＥＴしてＳＡＶＥする。
;	-I- CURX : カーソルＸ
;	    CURY : カーソルＹ
;	    FL_NUMBER : ファイル番号

CHIP_GET_SAVE	PROC	NEAR
	CALL	VRAM_SAVE		; ＶＲＡＭ退避
	CALL	CHIP_NUM_SAVE		; chip number save.

	MOVX	VX1,CURX		; start point.
	MOVX	VY1,CURY		; start point.
	MOVX	VX2,CURX		; start point.
	MOVX	VY2,CURY		; start point.
	ADD	VX2,3			;
	ADD	VY2,3;31		;
	MOV	CX,15			; color palet number.
	CALL	BOXPAL			; ＢＯＸペイント
;*;	MOV	CX,0			; color palet number.
;*;	CALL	BOXMSS			; ＢＯＸメッシュ
	RET
CHIP_GET_SAVE	ENDP


;	キャラをＧＥＴしてＳＡＶＥする。
;	-I- CURX : カーソルＸ
;	    CURY : カーソルＹ
;	    FL_NUMBER : ファイル番号

CHAR_GET_SAVE	PROC	NEAR
	CALL	FLNM_MAKER		; ファイル名作成
	MOV	SI,OFFSET FLNM		; ファイル名
	MOVX	VRX,CURX		; カーソルＸ
	MOVX	VRY,CURY		; カーソルＹ
	MOV	VRLENX,4		; Ｘ方向長さ
	MOV	VRLENY,32		; Ｙ方向長さ
	CALL	MCURMAKER		; 直接カーソルデータファイル作成
	RET
CHAR_GET_SAVE	ENDP


ADDWIDTH_SV	EQU	80-4		; エリア退避用計算
CUSLINE_SV	EQU	32		; エリア退避ライン数

;	ＶＲＡＭ退避
;	-I- CURX : カーソルＸ
;	    CURY : カーソルＹ
;	-O- MSCDAT : データ

VRAM_SAVE	PROC	NEAR
	PUSH	DS

	MOV	BX,CURY		; カーソルＹ
	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURX		; カーソルＸ

	MOV	SI,BX		; 先頭オフセット

;*;	MOV	DI,OFFSET VRMSAV0	; ＶＲＡＭ退避エリア
	MOV	DI,OFFSET MSCDAT	; カーソルデータ

	MOV	AX,DS		; データセグメント
	MOV	ES,AX		;

	MOV	DX,DS

	MOV	AX,ARAVRM[0]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE2:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE2

	MOV	SI,BX		; 先頭オフセット

	MOV	DS,DX		;

	MOV	AX,ARAVRM[2]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE3:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE3

	MOV	SI,BX		; 先頭オフセット

	MOV	DS,DX		;

	MOV	AX,ARAVRM[4]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE4:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE4

	MOV	SI,BX		; 先頭オフセット

	MOV	DS,DX		;

	MOV	AX,ARAVRM[6]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE5:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE5

	POP	DS
	RET
VRAM_SAVE	ENDP

;	chip number save.
;	-I- FL_NUMBER : ファイル番号
;	    MSCDAT    : データ

CHIP_NUM_SAVE	PROC	NEAR
	CALL	FLNM_MAKER		; ファイル名作成
	MOV	FLNM_ADRS,OFFSET FLNM	; ファイル名
	CALL	CHIP_SAVE		; chip save.
	RET
CHIP_NUM_SAVE	ENDP


;	chip save.
;	-I- FLNM_ADRS : ファイル名アドレス
;	    MSCDAT    : データ

CHIP_SAVE	PROC	NEAR
	MOV	SI,FLNM_ADRS		; ファイル名アドレス
	MOV	DI,OFFSET MSCDAT	; カーソルデータ
	MOV	DX,SEG DATA		;
	MOV	CX,CHIP_DATA_SIZE	; カーソルデータサイズ
	CALL	DSKSV			; データセーブ
	RET
CHIP_SAVE	ENDP

;	ファイル名作成
;	-I- FL_NUMBER : ファイル番号
;	-O- FLNM      : ファイル名

FLNM_MAKER	PROC	NEAR
	MOV	DX,FL_NUMBER			; ファイル番号
	CALL	DECSTR				; dec -> sting.
	INC	SI				;
	SETS	FLNM_NUM			; 番号
	RET
FLNM_MAKER	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	ARAVRM:WORD			; vram area.
EXTRN	MSCDAT:BYTE				; カーソルデータ

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

EXTRN	VRX:WORD	; x point.
EXTRN	VRY:WORD	; y point.
EXTRN	VRLENX:WORD	; x length.
EXTRN	VRLENY:WORD	; y length.

CURX	DW	0				; カーソルＸ
CURY	DW	0				; カーソルＹ

FLNM_ADRS	DW	FLNM			; ファイル名アドレス

FLNM		LABEL	BYTE			; ファイル名
FLNM_TOP	DB	"xxx"			; 先頭
FLNM_NUM	DB	"0000"			; 番号
FLNM_ATR	DB	0			;

FL_NUMBER	DW	0			; ファイル番号

DATA	ENDS

	END
;
;	end of "CHIPGET.ASM"
;
