; "KOSO2.INC" PC-9801UV11 make by R.H 1990/11/6
;
;
;	拡張セットその２
;


OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味



;	ＰＲ＿ＴＸＴ	＜文字列＞
;	文字列データのウインドウ表示

PR_TXT	MACRO	STRING
	LOCAL	L1,L2
;*;	JMP	L2
DATA	SEGMENT WORD	PUBLIC	'DATA'
L1	DB	STRING,0
DATA	ENDS
L2:
	MOV	WDTXTADR,OFFSET L1	; 表示文字列アドレス
	EXTRN	WIDTXT2:NEAR		; WINDOWS/テキストウインドウ２
	CALL	WIDTXT2			; WINDOWS/テキストウインドウ２
	ENDM


;	ＰＲ＿ＴＸＴＲ	＜文字列＞
;	ＰＲ＿ＴＸＴに続く文字列ウインドウ表示

PR_TXTR	MACRO	STRING
	LOCAL	L1,L2
;*;	JMP	L2
DATA	SEGMENT WORD	PUBLIC	'DATA'
L1	DB	STRING,0
DATA	ENDS
	MOV	WDTXTADR,OFFSET L1	; 表示文字列アドレス
	EXTRN	WIDTXT3:NEAR		; WINDOWS/テキストウインドウ３
	CALL	WIDTXT3			; WINDOWS/テキストウインドウ３
	ENDM


;	ＰＲ＿ＣＬＳ
;	文字列データのウインドウクリア

PR_CLS	MACRO
	EXTRN	TKRHME:NEAR		; 台詞ホームポジション
	CALL	TKRHME			; 台詞ホームポジション
	ENDM


;	ＰＲ＿ＬＦ
;	改行

PR_LF	MACRO
	EXTRN	R_SR_SR_LF:NEAR		; 改行
	CALL	R_SR_SR_LF		; 改行
	ENDM


;	ＰＲ＿ＷＡＩＴ
;	ユーザ待ち

PR_WAIT	MACRO
	EXTRN	TKWAIT:NEAR		; 台詞改行のプレイヤー待ち
	CALL	TKWAIT			; 台詞改行のプレイヤー待ち
	ENDM



;	ＳＥＬＥＣＴ	＜指定文字列＞
;	SELECT	"話す,渡す,行く"
;	結果は WIDSNM （ユーザ選択番号）に反映される
;	             : =FFFFH : 指定なし

SELECT	MACRO	SSSS
	LOCAL	L1,L2
;*;	JMP	L2
DATA	SEGMENT WORD	PUBLIC	'DATA'
	EXTRN	WIDSNM:WORD		; セレクト・ウインドウ／ユーザ選択番号
L1	DB	SSSS,0
DATA	ENDS
L2:
	MOV	AX,DS			; テキストバッファセグメント
	MOV	ES,AX			;
	MOV	BX,OFFSET L1		; 表示単語アドレス
	EXTRN	WIDSLC2:NEAR		;
	CALL	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	ENDM


;	ＳＥＬＥＣＴ＿ＣＡＬＬ	＜指定文字列＞
;	SELECT_CALL	"話す,渡す,行く"
;	DW	SUB1
;	DW	SUB2
;	DW	SUB3
;	選択後、サブルーチンへジャンプする

S_CALL	MACRO	SSSS,EXIT_LBL
	LOCAL	L1,L2,L3,L4
;*;	JMP	L2
DATA	SEGMENT WORD	PUBLIC	'DATA'
	EXTRN	WIDSNM:WORD		; セレクト・ウインドウ／ユーザ選択番号
L1	DB	SSSS,0
DATA	ENDS
L2:
	MOV	AX,DS			; テキストバッファセグメント
	MOV	ES,AX			;
	MOV	BX,OFFSET L1		; 表示単語アドレス
	EXTRN	WIDSLC2:NEAR		;
	CALL	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）

	CMP	WIDSNM,OFFF		; とりあえずＯＦＦという意味
	JE	L3			;

	MOV	BX,WIDSNM		; ユーザ選択番号
	SHL	BX,1			; word pointer.
	PUSH	WIDSNM			;
	CALL	WORD PTR CS:L4[BX]	;
	POP	WIDSNM			;
L3:
	JMP	EXIT_LBL

L4	LABEL	WORD
	ENDM

	
;	ＴＡＢＬＥ＿ＣＯＰＹ	＜転送元＞，＜転送先＞
;					，＜転送ワード数＞，＜転送先ワード数＞

TABLE_COPY	MACRO		SOU,DEST,WCNT,WDIM
	LOCAL	L1
	MOV	AX,DS
	MOV	ES,AX
	MOV	SI,OFFSET SOU
	MOV	DI,OFFSET DEST
	MOV	CX,WCNT
	CMP	CX,WDIM
	JBE	L1
	MOV	CX,WDIM
L1:
	REP	MOVSW
	ENDM


CODE	SEGMENT WORD	PUBLIC	'CODE'

	ASSUME	CS:CODE

	EXTRN	TKRSET:NEAR		; 台詞改行のカウンタリセット

NONE_NONE	PROC	NEAR
	RET
NONE_NONE	ENDP

CODE	ENDS

DATA	SEGMENT WORD	PUBLIC	'DATA'
	EXTRN	WDXX:WORD		; WINDOWS/point x.
	EXTRN	WDYY:WORD		; WINDOWS/point y.
	EXTRN	WDX1:WORD		; WINDOWS/ point x1.
	EXTRN	WDY1:WORD		; WINDOWS/ point y1.
	EXTRN	WDX2:WORD		; WINDOWS/ point x2.
	EXTRN	WDY2:WORD		; WINDOWS/ point y2.
	EXTRN	WDHNO:WORD		; WINDOWS/ヘッダー番号
	EXTRN	WDGNO:WORD		; WINDOWS/横グラフ番号
	EXTRN	WDVNO:WORD		; WINDOWS/内容表示番号
	EXTRN	WDSTR:WORD		; WINDOWS/表示パラメータ名
	EXTRN	WDVAL:WORD		; WINDOWS/表示値
	EXTRN	WDBLNC:WORD		; WINDOWS/表示バランス値
	EXTRN	WDNAME:WORD		; WINDOWS/表示名前
	EXTRN	WDTIME:WORD		; WINDOWS/表示時間値
	EXTRN	WDINO:WORD		; WINDOWS/アイテムオフセット
	EXTRN	WDILIST:WORD		; WINDOWS/スタイルリストオフセット
	EXTRN	WDP_VAL:WORD		; WINDOWS/内容表示値
	EXTRN	WDP_UNIT:WORD		; WINDOWS/内容表示単位系
	EXTRN	WD_NONE_CHR:BYTE	; WINDOWS/無効キャラクタ
	EXTRN	WDTXTSEG:WORD		; WINDOWS/表示文字列セグメント
	EXTRN	WDTXTADR:WORD		; WINDOWS/表示文字列アドレス
	EXTRN	WDBTNNUM:WORD		; WINDOWS/選択ボタン番号
	EXTRN	WDBTNPUSH:WORD		; WINDOWS/ボタン押した
	EXTRN	WDMSX:WORD		; WINDOWS/マウスＸ
	EXTRN	WDMSY:WORD		; WINDOWS/マウスＹ
	EXTRN	WDMSL:WORD		; WINDOWS/マウス左ボタン
	EXTRN	WDMSR:WORD		; WINDOWS/マウス右ボタン

	EXTRN	MSG_TKR_CLS:BYTE	; テキストウインドウ・クリア用
DATA	ENDS

;
;	end of "KOSO2.INC"
;
