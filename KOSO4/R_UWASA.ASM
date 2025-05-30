; "R_UWASA.ASM" PC-9801UV11 make by R.H 1991/01/24
;
;
;	「子育て」
;
;	町の人がうわさする
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

SUBX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	SUB	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_UWASA			; 町の人がうわさする
PUBLIC	R_UWA_HYOUKA		; 評価処理

EXTRN	R_MS_MACHINOKOE_MN:NEAR	; 街の声メイン
EXTRN	R_MS_MACHINOKOE:NEAR	; 街の声

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_SR_GIRL_NAME:NEAR	; キャラクタ名

EXTRN	WIDALLOC_MY_GIRL:NEAR	; WINDOWS/私の娘・データ結合

EXTRN	WIDSLC2:NEAR		; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）

EXTRN	WIDEVNT_U_OPEN:NEAR	; WINDOWS/うわさウインドウＯＰＥＮ
EXTRN	WIDEVNT_U_CLOSE:NEAR	; WINDOWS/うわさウインドウＣＬＯＳＥ

EXTRN	WIDPROP_INIT:NEAR	; WINDOWS/プロポ・ウインドウ初期処理
EXTRN	WIDPROP_ALL:NEAR	; WINDOWS/プロポ・ウインドウ全表示
EXTRN	WIDPROP_OPEN:NEAR	; WINDOWS/プロポ・ウインドウＯＰＥＮ
EXTRN	WIDPROP_CLOSE:NEAR	; WINDOWS/プロポ・ウインドウＣＬＯＳＥ

EXTRN	TKRSET:NEAR		; 台詞改行のカウンタリセット
EXTRN	WIDTXT:NEAR		; テキストウインドウ
EXTRN	STRSETZ:NEAR		; 文字列バッファセット

; ****************************************************
;	町の人がうわさする
; ****************************************************

R_UWASA		PROC	NEAR
	MOV	DX,WIDCHAR_NUMBER_MUSUME ; 自分の娘のキャラ番号（＝Ｎｏ．０）
	CALL	WIDALLOC_MY_GIRL	; WINDOWS/私の娘・データ結合

	CALL	R_MS_MACHINOKOE_MN	; 街の声メイン
;*;	CALL	R_MS_MACHINOKOE		; 街の声

R_UWASA_EXIT:
	RET
R_UWASA		ENDP



;*;; ****************************************************
;*;;	うわさウインドウＯＰＥＮ
;*;; ****************************************************
;*;
;*;UWASA_OPEN	PROC	NEAR
;*;	PR_CLS
;*;	PR_TXT	"@町の人々に"
;*;	CALL	R_SR_GIRL_NAME		; キャラクタ名
;*;	PR_TXT	"の評判を聞いてみよう‥‥‥"
;*;
;*;	CALL	WIDEVNT_U_OPEN	; WINDOWS/うわさウインドウＯＰＥＮ
;*;	RET
;*;UWASA_OPEN	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	うわさウインドウＣＬＯＳＥ
;*;; ****************************************************
;*;
;*;UWASA_CLOSE	PROC	NEAR
;*;	CALL	WIDEVNT_U_CLOSE	; WINDOWS/うわさウインドウＣＬＯＳＥ
;*;	RET
;*;UWASA_CLOSE	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	うわさウインドウＭＡＩＮ
;*;; ****************************************************
;*;
;*;UWASA_MAIN	PROC	NEAR
;*;	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
;*;	MOV	S_FUNC,40		; 40=町の評判
;*;	CALL	R_KEISAN		; 各計算処理
;*;	MOV	UWASA_LEVEL,DX		; うわさレベル
;*;	CALL	UWASA_EDIT		; 町のうわさ編集
;*;	MOV	WDTXTADR,OFFSET STR_BUFF ; うわさ文字列バッファ
;*;	MOV	WDTXTSEG,DS		; 表示文字列セグメント
;*;	CALL	TKRSET			; 台詞改行のカウンタリセット
;*;	CALL	WIDTXT			; テキストウインドウ
;*;	MOVX	ES,DS			; テキストバッファセグメント
;*;	MOV	BX,UWSLC_MENU_ARDS	; うわさ選択メニューアドレス
;*;	CALL	WIDSLC2		; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
;*;	RET
;*;UWASA_MAIN	ENDP


;*NON*;; ****************************************************
;*NON*;;	町のうわさ編集
;*NON*;;	-I/O- UWASA_LEVEL : うわさレベル
;*NON*;;	-O-   STR_BUFF	  : うわさ文字列バッファ
;*NON*;;	      UWSLC_MENU_ARDS : うわさ選択メニューアドレス
;*NON*;; ****************************************************
;*NON*;
;*NON*;UWASA_EDIT	PROC	NEAR
;*NON*;	CMP	UWASA_LEVEL,0		; うわさレベル
;*NON*;	JNE	UWASA_EDIT_1		;
;*NON*;	MOV	UWASA_LEVEL,1		; うわさレベル
;*NON*;UWASA_EDIT_1:				;
;*NON*;	CMPX	UWASA_LEVEL,UWASA_TABLE[0] ; テーブルサイズ
;*NON*;	JBE	UWASA_EDIT_2		;
;*NON*;	MOVX	UWASA_LEVEL,UWASA_TABLE[0] ; うわさレベル
;*NON*;UWASA_EDIT_2:
;*NON*;	MOV	BX,UWASA_LEVEL		; うわさレベル
;*NON*;	SHL	BX,1			; word pointer.
;*NON*;	MOV	SI,DS:UWASA_TABLE[BX]	; うわさテーブル
;*NON*;
;*NON*;	MOVX	ES,DS			;
;*NON*;	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
;*NON*;	MOV	CX,STRING_LEN		; string length.
;*NON*;
;*NON*;	CALL	STRSETZ			; 文字列バッファセット
;*NON*;
;*NON*;	MOV	BX,UWASA_LEVEL		; うわさレベル
;*NON*;	SHL	BX,1			; word pointer.
;*NON*;	MOV	AX,DS:UWSLC_TABLE[BX]	; うわさ選択メニューテーブル
;*NON*;	MOV	UWSLC_MENU_ARDS,AX	; うわさ選択メニューアドレス
;*NON*;
;*NON*;	RET
;*NON*;UWASA_EDIT	ENDP



; ****************************************************
;	評価処理
;	-I- DX : 加算される評価
; ****************************************************

R_UWA_HYOUKA	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,42		; 42=評価処理
	CALL	R_KEISAN		; 各計算処理
	MOV	HYOUKA_SHIN,CX		; 新評価ポイント
	MOV	HYOUKA_KYU,DX		; 旧評価ポイント

	CMPX	HYOUKA_SHIN,HYOUKA_KYU	; 新旧評価の差
	JE	R_UWA_HYOUKA_EXIT	;

	PR_LF				; 改行
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF ; 私の娘アドレス
	CALL	R_SR_GIRL_NAME		; キャラクタ名
	PR_TXT	"の評価が"		;

	CMPX	HYOUKA_SHIN,HYOUKA_KYU	; 新旧評価の差
	JB	R_UWA_HYOUKA_3		;
	PR_TXT	"あがりました。"	;

	JMP	R_UWA_HYOUKA_5		;
R_UWA_HYOUKA_3:				;
	PR_TXT	"さがりました。"	;
R_UWA_HYOUKA_5:				;
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示

R_UWA_HYOUKA_EXIT:
	RET
R_UWA_HYOUKA	ENDP

CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	S_FUNC:WORD			; 計算ファンクション
EXTRN	WIDSNM:WORD			; セレクト・ウインドウ／ユーザ選択番号
EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

HYOUKA_SHIN	DW	0		; 新評価ポイント
HYOUKA_KYU	DW	0		; 旧評価ポイント

;*NON*;UWASA_LEVEL	DW	0			; うわさレベル
;*NON*;UWASA_TABLE	LABEL	WORD			; うわさテーブル
;*NON*;		DW	5			; テーブルサイズ
;*NON*;		DW	OFFSET UWS_MS01		; Ａ
;*NON*;		DW	OFFSET UWS_MS02		; Ｂ
;*NON*;		DW	OFFSET UWS_MS03		; Ｃ
;*NON*;		DW	OFFSET UWS_MS04		; Ｄ
;*NON*;		DW	OFFSET UWS_MS05		; Ｅ
;*NON*;UWS_MS01	DB	"「うわさＡＡＡＡＡＡＡＡＡＡＡＡＡＡＡＡ」@",0
;*NON*;UWS_MS02	DB	"「うわさＢＢＢＢＢＢＢＢＢＢＢＢＢＢＢＢ」@",0
;*NON*;UWS_MS03	DB	"「うわさＣＣＣＣＣＣＣＣＣＣＣＣＣＣＣＣ」@",0
;*NON*;UWS_MS04	DB	"「うわさＤＤＤＤＤＤＤＤＤＤＤＤＤＤＤＤ」@",0
;*NON*;UWS_MS05	DB	"「うわさＥＥＥＥＥＥＥＥＥＥＥＥＥＥＥＥ」@",0
;*NON*;
;*NON*;UWSLC_MENU_ARDS	DW	0		; うわさ選択メニューアドレス
;*NON*;UWSLC_TABLE	LABEL	WORD		; うわさ選択メニューテーブル
;*NON*;		DW	5		; テーブルサイズ
;*NON*;		DW	OFFSET UWSM_MS1	; Ａ
;*NON*;		DW	OFFSET UWSM_MS2	; Ｂ
;*NON*;		DW	OFFSET UWSM_MS3	; Ｃ
;*NON*;		DW	OFFSET UWSM_MS4	; Ｄ
;*NON*;		DW	OFFSET UWSM_MS5	; Ｅ
;*NON*;UWSM_MS1	DB	"Ａうふふふ",0,0		; Ａ
;*NON*;UWSM_MS2	DB	"Ｂわくわく",0,0		; Ｂ
;*NON*;UWSM_MS3	DB	"Ｃふーん・・・",0,0		; Ｃ
;*NON*;UWSM_MS4	DB	"Ｄ・・・・・うーん",0,0	; Ｄ
;*NON*;UWSM_MS5	DB	"Ｅがんばらねば！",0,0		; Ｅ

DATA	ENDS

	END
;
;	end of "R_UWASA.ASM"
;
