; "DKYOKU.ASM" PC-9801UV11 make by R.H 1990/06/04
;
;	プリンセス・メーカー曲セット
;
;	DKYOKU		: 曲の演奏
;	DKYOKU_FAR	: (FAR)曲の演奏
;	MUSIC_KOSODATE	: 子育てのテーマ
;
;	曲番号は KYOKU.INC を参照せよ。
;
;		1001=音楽フェードアウト
;		1002=音楽カット
;		1プﾛﾛｰグ
;		2ﾒｲﾝﾃｰﾏ
;		3子育て
;		4非行化
;		5病気
;		6お城
;		7修行
;		8ｱﾙバｲﾄ
;		9バｶﾝｽ
;		10城外
;		11収穫祭
;		12武闘会
;		13ﾐｽｺﾝ
;		14バﾄﾙ
;		15ｴﾝデｨﾝグ
;
; GAME subroutine.

INCLUDE	..\KOSO\WINDOW.INC

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチン
; ****************************************************

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
SUBLL	PROC	FAR
	ENDM

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチンの終り
; ****************************************************

FEND	MACRO	SUBLL

SUBLL	ENDP
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２セグメントからＣＯＤＥセグメントへ
; ****************************************************

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

; ****************************************************
;	ＣＯＤＥセグメントからＲ＿ＳＥＧ２セグメントへ
; ****************************************************

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２　から　ＣＯＤＥ　へ　ＣＡＬＬ
; ****************************************************

CALLC	MACRO	SUB1
	LOCAL	L1,L2
	JMP	L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:	CALL	L2	
	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM
CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM


R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

; ****************************************************
;	子育てのテーマ
; ****************************************************

FUNC	MMUSIC_KOSODATE,MUSIC_KOSODATE
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,0				; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41			; 41=ヘッダーフラグのＩ／Ｏ
	CALLC	R_KEISAN			; 各計算処理
	MOV	MY_FLAGS,DX			; ヘッダフラグ

	TEST	MY_FLAGS,FLAGS_BYOUKI		;bit12 : 病気化
	JNZ	MUSIC_KOSODATE_BYOUKI		;
	TEST	MY_FLAGS,FLAGS_HIKOU		;bit13 : 非行化
	JNZ	MUSIC_KOSODATE_HIKOU		;

	MOV	KYOKU_NUM,3			;3=子育て
	CALL	FAR PTR DKYOKU_FAR		; 曲の演奏
	RET
MUSIC_KOSODATE_HIKOU:
MUSIC_KOSODATE_BYOUKI:
	MOV	KYOKU_NUM,5			;5=病気
	CALL	FAR PTR DKYOKU_FAR		; 曲の演奏
	RET
FEND	MMUSIC_KOSODATE


; ****************************************************
;	曲の演奏
;	-I- KYOKU_NUM : 曲番号
;			1001=音楽フェードアウト
;			1002=音楽カット
;			1=プﾛﾛｰグ
;			2=ﾒｲﾝﾃｰﾏ
;			3=子育て
;			4=非行化
;			5=病気
;			6=お城
;			7=修行
;			8=ｱﾙバｲﾄ
;			9=バｶﾝｽ
;			10=城外
;			11=収穫祭
;			12=武闘会
;			13=ﾐｽｺﾝ
;			14=バﾄﾙ
;			15=ｴﾝデｨﾝグ
; ****************************************************

PUBLIC	DKYOKU_FAR
FUNC	DKYOKU_FAR,DKYOKU
	CMP	KYOKU_NUM,1001		; 1001=音楽フェードアウト
	JE	DKYOKU_F_O		;
	CMP	KYOKU_NUM,1002		; 1002=音楽カット
	JE	DKYOKU_CUT		;

	CMPX	KYOKU_NUM,KYOKU_NUM_OLD	; 現在の曲番号
	JE	DKYOKU_EXIT		;

	MOV	AX,KYOKU_NUM		; 曲番号
	MOV	KYOKU_NUM_OLD,AX	; 現在の曲番号
	CALLC	M_PLAY			; 音楽演奏
DKYOKU_EXIT:				;
	RET
DKYOKU_CUT:				;
	MOV	AX,KYOKU_NUM		; 曲番号
	MOV	KYOKU_NUM_OLD,AX	; 現在の曲番号
	CALLC	M_STOP			; 音楽停止
	RET
DKYOKU_F_O:				;
	MOV	AX,KYOKU_NUM		; 曲番号
	MOV	KYOKU_NUM_OLD,AX	; 現在の曲番号
	CALLC	M_FDOT			; 音楽フェードアウト
	RET
FEND	DKYOKU_FAR

R_SEG2	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	KYOKU_NUM		; 曲番号
EXTRN	S_FUNC:WORD		; 41=ヘッダーフラグのＩ／Ｏ

KYOKU_NUM	DW	0	; 曲番号
KYOKU_NUM_OLD	DW	0	; 現在の曲番号

MY_FLAGS	DW	0	; ヘッダフラグ

DATA	ENDS

	END
;
;	end of "DKYOKU.ASM"
;
