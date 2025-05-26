
; 作者注：開発初期の残骸と思われる。KOSO4に同じ名前のソースコードあり.

; "R_KAIMON.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	買物
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	KOSO2.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	R_KAIMON		; 買物


; ****************************************************
;	買物
; ****************************************************

R_KAIMON	PROC	NEAR
	PR_TXT	"いらっしゃいませ！"
R_KAIMON_SEL:
	S_CALL	"武器がみたい,防具がみたい,道具がみたい,帰ります",R_KAIMON_EE
	DW	SHOW_BUKI			; 武器
	DW	SHOW_BOUGU			; 防具
	DW	SHOW_DOUGU			; 道具
	DW	NONE_NONE
R_KAIMON_EE:
	CMP	WIDSNM,3			; ユーザ選択番号
	JE	R_KAIMON_EXIT
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JE	R_KAIMON_EXIT

	PR_TXT	"ほかには？"
	JMP	R_KAIMON_SEL

R_KAIMON_EXIT:
	PR_TXT	"ありがとうございました"
	RET
R_KAIMON	ENDP


;	武器

SHOW_BUKI	PROC	NEAR
	PR_TXT	"武器はこのようなものがあります"
	RET
SHOW_BUKI	ENDP


;	防具

SHOW_BOUGU	PROC	NEAR
	PR_TXT	"防具はこんなかんじですが"
	RET
SHOW_BOUGU	ENDP


;	道具

SHOW_DOUGU	PROC	NEAR
	PR_TXT	"道具はいろいろございます"
	RET
SHOW_DOUGU	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS

	END
;
;	end of "R_KAIMON.ASM"
;
