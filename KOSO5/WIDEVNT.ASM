; "WIDEVNT.ASM" PC-9801UV11 make by R.H 1990/11/20
;
;
;	ＷＩＮＤＯＷＳ／イベントウインドウ
;
;
;	WIDEVNT_INIT		; WINDOWS/イベントウインドウ初期処理
;	WIDEVNT_OPEN		; WINDOWS/イベントウインドウＯＰＥＮ
;	WIDEVNT_CLOSE		; WINDOWS/イベントウインドウＣＬＯＳＥ
;	WIDEVNTS_OPEN	;WINDOWS/イベントウインドウＯＰＥＮ(バンク退避)
;	WIDEVNTS_CLOSE	;WINDOWS/イベントウインドウＣＬＯＳＥ(バンク退避)
;	WIDEVNT_U_OPEN		; WINDOWS/うわさウインドウＯＰＥＮ
;	WIDEVNT_U_CLOSE		; WINDOWS/うわさウインドウＣＬＯＳＥ
;	WIDEVNT_OPEN_W		; WINDOWS/行いイベントＯＰＥＮ
;	WIDEVNT_CLOSE_W		; WINDOWS/行いイベントＣＬＯＳＥ
;	WIDEVNT_STOP_W		; WINDOWS/行いイベントＳＴＯＰ
;	WIDEVNT_CONT_W		; WINDOWS/行いイベントＣＯＮＴ
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

NORMAL_BANK	EQU	0	; 通常のパーツバンク番号
BACKSAVE_BANK	EQU	1	; 背景退避用パーツバンク番号

IVENT_LOC_X	EQU	2	; イベントウインドウＸ位置
IVENT_LOC_Y	EQU	224 ;160 ;26*8; イベントウインドウＹ位置
IVENT_SIZ_X	EQU	26+2	; イベントウインドウＸサイズ
IVENT_SIZ_Y	EQU	144+15	; イベントウインドウＹサイズ


;	ＷＩＮＤＯＷ　から　ＣＯＤＥ　へ　ＣＡＬＬ

CALLC	MACRO	SUB1
	LOCAL	L1,L2
;*;	JMP	L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:	CALL	L2
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチン

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS

	ASSUME	CS:WINDOW,DS:DATA

SUBLL	PROC	FAR
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチンの終り

FEND	MACRO	SUBLL
SUBLL	ENDP
	ENDM

;	ＷＩＮＤＯＷセグメントからＣＯＤＥセグメントへ

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

;	ＣＯＤＥセグメントからＷＩＮＤＯＷセグメントへ

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:
	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/イベントウインドウ初期処理
; ****************************************************

FUNC	WWIDEVNT_INIT,WIDEVNT_INIT
	RET
FEND	WWIDEVNT_INIT


; ****************************************************
;	WINDOWS/イベントウインドウＯＰＥＮ
;	-I- DX : イベント絵の番号
;		1=王様との会見
;		2=町の評判
;		3=ステータス
;		4=娘と話す
;		5=買物
;		6=武芸道場
;		7=学問場
;		8=礼法の道場
;		9=休息
; ****************************************************

FUNC	WWIDEVNT_OPEN,WIDEVNT_OPEN
	MOV	IVENT_NUMBER,DX		; イベント絵の番号

	MOVX	WDX1,IVE_BACK_X1	; イベント・退避左上Ｘ
	MOVX	WDY1,IVE_BACK_Y1	; イベント・退避左上Ｙ
	MOVX	WDX2,IVE_BACK_X2	; イベント・退避サイズＸ
	MOVX	WDY2,IVE_BACK_Y2	; イベント・退避サイズＹ
	CALLC	WIDDSP_SV_H		; WINDOWS/画面範囲退避

	MOVX	WDX1,IVE_FREM_X		; イベントウインドウフレームＸ座標
	MOVX	WDY1,IVE_FREM_Y		; イベントウインドウフレームＹ座標
	MOVX	WDX2,IVE_FREM_XL	; イベントウインドウフレームサイズＸ
	MOVX	WDY2,IVE_FREM_YL	; イベントウインドウフレームサイズＹ
	CALLC	WID_4_FLAME		; WINDOWS/フレーム４

	MOV	DX,IVENT_NUMBER		; イベント絵の番号
	MOV	AX,IVE_POINT_X1		; イベントウインドウＸ位置
	MOV	BX,IVE_POINT_Y1		; イベントウインドウＹ位置
	CALLC	PT_EVENT_VIEW		; イベントビュー

	MOV	DX,IVENT_NUMBER		; イベント絵の番号
	ADD	DX,100			;＋１００
	MOV	LOCAL_IVENT_NUMBER,DX	; 現在表示イベント絵の番号
	RET
FEND	WWIDEVNT_OPEN


; ****************************************************
;	WINDOWS/イベントウインドウＣＬＯＳＥ
; ****************************************************

FUNC	WWIDEVNT_CLOSE,WIDEVNT_CLOSE
	MOVX	WDX1,IVE_BACK_X1	; イベント・退避左上Ｘ
	MOVX	WDY1,IVE_BACK_Y1	; イベント・退避左上Ｙ
	MOVX	WDX2,IVE_BACK_X2	; イベント・退避サイズＸ
	MOVX	WDY2,IVE_BACK_Y2	; イベント・退避サイズＹ
	CALLC	WIDDSP_LD_H		; WINDOWS/画面範囲復元

	MOV	LOCAL_IVENT_NUMBER,0	; 現在表示イベント絵の番号
	RET
FEND	WWIDEVNT_CLOSE


; ****************************************************
;	WINDOWS/イベントウインドウＯＰＥＮ(バンク退避)
;	-I- DX : イベント絵の番号
;		1=王様との会見
;		2=町の評判
;		3=ステータス
;		4=娘と話す
;		5=買物
;		6=武芸道場
;		7=学問場
;		8=礼法の道場
;		9=休息
; ****************************************************

FUNC	WWIDEVNTS_OPEN,WIDEVNTS_OPEN
	MOV	IVENT_NUMBER,DX		; イベント絵の番号

	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	MOVX	WDX1,IVE_BACK_X1	; イベント・退避左上Ｘ
	MOVX	WDY1,IVE_BACK_Y1	; イベント・退避左上Ｙ
	MOVX	WDX2,IVE_BACK_X2	; イベント・退避サイズＸ
	MOVX	WDY2,IVE_BACK_Y2	; イベント・退避サイズＹ
	CALLC	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ

	MOVX	WDX1,IVE_FREM_X		; イベントウインドウフレームＸ座標
	MOVX	WDY1,IVE_FREM_Y		; イベントウインドウフレームＹ座標
	MOVX	WDX2,IVE_FREM_XL	; イベントウインドウフレームサイズＸ
	MOVX	WDY2,IVE_FREM_YL	; イベントウインドウフレームサイズＹ
	CALLC	WID_4_FLAME		; WINDOWS/フレーム４

	MOV	DX,IVENT_NUMBER		; イベント絵の番号
	MOV	AX,IVE_POINT_X1		; イベントウインドウＸ位置
	MOV	BX,IVE_POINT_Y1		; イベントウインドウＹ位置
	CALLC	PT_EVENT_VIEW		; イベントビュー

	RET
FEND	WWIDEVNTS_OPEN


; ****************************************************
;	WINDOWS/イベントウインドウＣＬＯＳＥ(バンク退避)
; ****************************************************

FUNC	WWIDEVNTS_CLOSE,WIDEVNTS_CLOSE
	CALLC	WIDFRM_BACKLOAD		; WINDOWS/背景をロード
	RET
FEND	WWIDEVNTS_CLOSE


; ****************************************************
;	WINDOWS/行いイベントＯＰＥＮ
;	-I- DX : イベント絵の番号
;		1=宿屋
;		2=メイド
;		3=代筆屋
;		4=酒場１
;		5=医者
;		6=狩人
;		7=武器屋
;		8=宿屋２
;		9=木コリ
;		10=教会
;		11=酒場２
;		12=人足
; ****************************************************

FUNC	WWIDEVNT_OPEN_W,WIDEVNT_OPEN_W
	MOV	IVENT_NUMBER,DX		; イベント絵の番号

	MOVX	WDX1,IVE_BACK_X1	; イベント・退避左上Ｘ
	MOVX	WDY1,IVE_BACK_Y1	; イベント・退避左上Ｙ
	MOVX	WDX2,IVE_BACK_X2	; イベント・退避サイズＸ
	MOVX	WDY2,IVE_BACK_Y2	; イベント・退避サイズＹ
	CALLC	WIDDSP_SV_H		; WINDOWS/画面範囲退避

	MOVX	WDX1,IVE_FREM_X		; イベントウインドウフレームＸ座標
	MOVX	WDY1,IVE_FREM_Y		; イベントウインドウフレームＹ座標
	MOVX	WDX2,IVE_FREM_XL	; イベントウインドウフレームサイズＸ
	MOVX	WDY2,IVE_FREM_YL	; イベントウインドウフレームサイズＹ
	CALLC	WID_4_FLAME		; WINDOWS/フレーム４

	MOV	DX,IVENT_NUMBER		; イベント絵の番号
	MOV	AX,IVE_POINT_X1		; イベントウインドウＸ位置
	MOV	BX,IVE_POINT_Y1		; イベントウインドウＹ位置
	CALLC	PT_EVENT_VWWK		; 行いイベントビュー

	MOV	DX,IVENT_NUMBER		; イベント絵の番号
	MOV	LOCAL_IVENT_NUMBER,DX	; 現在表示イベント絵の番号
	RET
FEND	WWIDEVNT_OPEN_W


; ****************************************************
;	WINDOWS/行いイベントＣＬＯＳＥ
; ****************************************************

FUNC	WWIDEVNT_CLOSE_W,WIDEVNT_CLOSE_W
	MOVX	WDX1,IVE_BACK_X1	; イベント・退避左上Ｘ
	MOVX	WDY1,IVE_BACK_Y1	; イベント・退避左上Ｙ
	MOVX	WDX2,IVE_BACK_X2	; イベント・退避サイズＸ
	MOVX	WDY2,IVE_BACK_Y2	; イベント・退避サイズＹ
	CALLC	WIDDSP_LD_H		; WINDOWS/画面範囲復元

	MOV	LOCAL_IVENT_NUMBER,0	; 現在表示イベント絵の番号
	RET
FEND	WWIDEVNT_CLOSE_W


; ****************************************************
;	WINDOWS/行いイベントＳＴＯＰ
; ****************************************************

FUNC	WWIDEVNT_STOP_W,WIDEVNT_STOP_W
	CMP	LOCAL_IVENT_NUMBER,0	; 現在表示イベント絵の番号
	JNE	WIDEVNT_STOP_W_START	;
	RET
WIDEVNT_STOP_W_START:
	MOVX	WDX1,IVE_BACK_X1	; イベント・退避左上Ｘ
	MOVX	WDY1,IVE_BACK_Y1	; イベント・退避左上Ｙ
	MOVX	WDX2,IVE_BACK_X2	; イベント・退避サイズＸ
	MOVX	WDY2,IVE_BACK_Y2	; イベント・退避サイズＹ
	CALLC	WIDDSP_LD_H		; WINDOWS/画面範囲復元
	RET
FEND	WWIDEVNT_STOP_W


; ****************************************************
;	WINDOWS/行いイベントＣＯＮＴ
; ****************************************************

FUNC	WWIDEVNT_CONT_W,WIDEVNT_CONT_W
	CMP	LOCAL_IVENT_NUMBER,0	; 現在表示イベント絵の番号
	JNE	WIDEVNT_CONT_W_START	;
	RET
WIDEVNT_CONT_W_START:
	MOVX	WDX1,IVE_BACK_X1	; イベント・退避左上Ｘ
	MOVX	WDY1,IVE_BACK_Y1	; イベント・退避左上Ｙ
	MOVX	WDX2,IVE_BACK_X2	; イベント・退避サイズＸ
	MOVX	WDY2,IVE_BACK_Y2	; イベント・退避サイズＹ
	CALLC	WIDDSP_SV_H		; WINDOWS/画面範囲退避

	MOVX	WDX1,IVE_FREM_X		; イベントウインドウフレームＸ座標
	MOVX	WDY1,IVE_FREM_Y		; イベントウインドウフレームＹ座標
	MOVX	WDX2,IVE_FREM_XL	; イベントウインドウフレームサイズＸ
	MOVX	WDY2,IVE_FREM_YL	; イベントウインドウフレームサイズＹ
	CALLC	WID_4_FLAME		; WINDOWS/フレーム４

	CMP	LOCAL_IVENT_NUMBER,100	; 現在表示イベント絵の番号
	JG	WIDEVNT_CONT_W_EVE	;

WIDEVNT_CONT_W_WK:
	MOV	DX,LOCAL_IVENT_NUMBER	; 現在表示イベント絵の番号
	MOV	AX,IVE_POINT_X1		; イベントウインドウＸ位置
	MOV	BX,IVE_POINT_Y1		; イベントウインドウＹ位置
	CALLC	PT_EVENT_VWWK		; 行いイベントビュー
	RET
WIDEVNT_CONT_W_EVE:
	MOV	DX,LOCAL_IVENT_NUMBER	; 現在表示イベント絵の番号
	SUB	DX,100			; 現在表示イベント絵の番号
	MOV	AX,IVE_POINT_X1		; イベントウインドウＸ位置
	MOV	BX,IVE_POINT_Y1		; イベントウインドウＹ位置
	CALLC	PT_EVENT_VIEW		; イベントビュー
	RET
FEND	WWIDEVNT_CONT_W


; ****************************************************
;	WINDOWS/うわさウインドウＯＰＥＮ
; ****************************************************

FUNC	WWIDEVNT_U_OPEN,WIDEVNT_U_OPEN
	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	MOVX	WDX1,UWA_BACK_X1	; うわさ・退避左上Ｘ
	MOVX	WDY1,UWA_BACK_Y1	; うわさ・退避左上Ｙ
	MOVX	WDX2,UWA_BACK_X2	; うわさ・退避サイズＸ
	MOVX	WDY2,UWA_BACK_Y2	; うわさ・退避サイズＹ
	CALLC	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ

	MOVX	WDX1,IVE_FREM_X		; イベントウインドウフレームＸ座標
	MOVX	WDY1,IVE_FREM_Y		; イベントウインドウフレームＹ座標
	MOVX	WDX2,IVE_FREM_XL	; イベントウインドウフレームサイズＸ
	MOVX	WDY2,IVE_FREM_YL	; イベントウインドウフレームサイズＹ

	MOVX	WDX1,UWA_FREM_X		; うわさウインドウフレームＸ座標
	MOVX	WDY1,UWA_FREM_Y		; うわさウインドウフレームＹ座標
	MOVX	WDX2,UWA_FREM_XL	; うわさウインドウフレームサイズＸ
	MOVX	WDY2,UWA_FREM_YL	; うわさウインドウフレームサイズＹ
	CALLC	WID_4_FLAME		; WINDOWS/フレーム４

	MOV	AX,UWA_POINT_X1		; うわさウインドウＸ位置
	MOV	BX,UWA_POINT_Y1		; うわさウインドウＹ位置
	CALLC	PT_MACHINOUWASA		; 街の評判
	RET
FEND	WWIDEVNT_U_OPEN


; ****************************************************
;	WINDOWS/うわさウインドウＣＬＯＳＥ
; ****************************************************

FUNC	WWIDEVNT_U_CLOSE,WIDEVNT_U_CLOSE
	CALLC	WIDFRM_BACKLOAD		; WINDOWS/背景をロード
	RET
FEND	WWIDEVNT_U_CLOSE

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

IVENT_NUMBER	DW	0		; イベント絵の番号
LOCAL_IVENT_NUMBER DW	0		; 現在表示イベント絵の番号

UWA_POINT_X1	DW	IVENT_LOC_X+1	; うわさウインドウＸ位置
UWA_POINT_Y1	DW	IVENT_LOC_Y+7	; うわさウインドウＹ位置
UWA_FREM_X	DW	IVENT_LOC_X	; うわさウインドウフレームＸ座標
UWA_FREM_Y	DW	IVENT_LOC_Y	; うわさウインドウフレームＹ座標
UWA_FREM_XL	DW	IVENT_SIZ_X	; うわさウインドウフレームサイズＸ
UWA_FREM_YL	DW	IVENT_SIZ_Y	; うわさウインドウフレームサイズＹ
UWA_BACK_X1	DW	IVENT_LOC_X-1	; うわさ・退避左上Ｘ
UWA_BACK_Y1	DW	IVENT_LOC_Y-8	; うわさ・退避左上Ｙ
UWA_BACK_X2	DW	IVENT_SIZ_X+2	; うわさ・退避サイズＸ
UWA_BACK_Y2	DW	IVENT_SIZ_Y+16	; うわさ・退避サイズＹ

IVE_POINT_X1	DW	IVENT_LOC_X+1	; イベントウインドウＸ位置
IVE_POINT_Y1	DW	IVENT_LOC_Y+7	; イベントウインドウＹ位置
IVE_FREM_X	DW	IVENT_LOC_X	; イベントウインドウフレームＸ座標
IVE_FREM_Y	DW	IVENT_LOC_Y	; イベントウインドウフレームＹ座標
IVE_FREM_XL	DW	IVENT_SIZ_X	; イベントウインドウフレームサイズＸ
IVE_FREM_YL	DW	IVENT_SIZ_Y	; イベントウインドウフレームサイズＹ
IVE_BACK_X1	DW	IVENT_LOC_X-1	; イベント・退避左上Ｘ
IVE_BACK_Y1	DW	IVENT_LOC_Y-8	; イベント・退避左上Ｙ
IVE_BACK_X2	DW	IVENT_SIZ_X+2	; イベント・退避サイズＸ
IVE_BACK_Y2	DW	IVENT_SIZ_Y+16	; イベント・退避サイズＹ

DATA	ENDS

	END
;
;	end of "WIDEVNT.ASM"
;
