; "WIDCLEN.ASM" PC-9801UV11 make by R.H 1990/11/02
;
;
;	ＷＩＮＤＯＷＳ／カレンダー
;
;
;	WIDCLEN_INIT		; WINDOWS/カレンダー・初期処理
;	WIDCLEN_SET		; WINDOWS/カレンダー・設定処理
;	WIDCLEN_SHOW		; WINDOWS/カレンダー・再表示
;	WIDCLEN_UDATE		; WINDOWS/カレンダー・更新処理
;	WIDCLEN_UDATE_BC	; WINDOWS/カレンダー・更新処理/BACANCE
;	WIDCLEN_UDATE_ONLY	; WINDOWS/カレンダー・更新のみ処理（表示無）
;	WIDCLEN_UD_FF		; WINDOWS/カレンダー・早送り
;	WIDCLEN_GET		; WINDOWS/カレンダー・読み取り処理
;	WIDCLEN_U_AD		; WINDOWS/カレンダー・日付加算計算
;	WIDCLEN_NXT_E		; WINDOWS/カレンダー・翌月の末日
;	WIDCLEN_AGE		; WINDOWS/カレンダー・年齢の計算
;	WIDCLEN_LINK		; WINDOWS/カレンダー・データ結合処理
;	WIDCLEN_MONTH_C		; WINDOWS/カレンダー・月データ
;
;	＊環境開始時間
;	ST_VAL_YEAR			: 環境開始・年
;	ST_VAL_MONTH			: 環境開始・月
;	ST_VAL_WEEK			: 環境開始・曜日
;	ST_VAL_DATE			: 環境開始・日
;
;	＊現在時間
;	public	NOW_DATE		: (now)現在時間
;	public	VAL_YEAR		: (now)年
;	public	VAL_MONTH		: (now)月
;	public	VAL_WEEK		: (now)曜日
;	public	VAL_DATE		: (now)日
;	public	VAL_A_DATE		: (now)年内合計日付
;	public	VAL_M_END		: (now)月末の日
;	public	TM_SEASON		: (now)季節（1:春,2:夏,3:秋,4:冬）
;	public	FLG_SHOGATSU		: (now)フラグ・正月
;	public	FLG_URUBI		: (now)フラグ・うるう日
;	public	FLG_CHRISTMAS_EVE 	: (now)フラグ・クリスマスイブ
;	public	FLG_BORTH		: (now)フラグ・誕生日
;	public	FLG_HOLIDAY		: (now)フラグ・休日
;	public	FLG_SYUKAKU		; (now)フラグ・収穫祭の準備
;
;	＊計算用時間
;	public	USR_DATE		: (user)現在時間退避
;	public	UCK_YEAR		: (user)年
;	public	UCK_MONTH		: (user)月
;	public	UCK_WEEK		: (user)曜日
;	public	UCK_DATE		: (user)日
;	public	UCK_A_DATE		: (user)年内合計日付
;	public	UCK_M_END		: (user)月末の日
;	public	UCK_SEASON		: (user)季節（1:春,2:夏,3:秋,4:冬）
;	public	UCK_SHOGATSU		: (user)フラグ・正月
;	public	UCK_URUBI		: (user)フラグ・うるう日
;	public	UCK_CHRISTMAS_EVE	: (user)フラグ・クリスマスイブ
;	public	UCK_BORTH		: (user)フラグ・誕生日
;	public	UCK_HOLIDAY		: (user)フラグ・休日
;	public	UCK_SYUKAKU		; (user)フラグ・収穫祭の準備
;
;	public	MY_BORTH_MONTH		; 娘の誕生日の月
;	public	MY_BORTH_DATE		; 娘の誕生日の日
;
;	0=（日）Sunday
;	1=（月）Monday
;	2=（火）Tuesday
;	3=（水）Wednesday
;	4=（木）Thursday
;	5=（金）Friday
;	6=（土）Saturday
;
;
;	1=おひつじ座
;	2=おうし座
;	3=ふたご座
;	4=かに座
;	5=しし座
;	6=おとめ座
;	7=てんびん座
;	8=さそり座
;	9=いて座
;	10=やぎ座
;	11=みずがめ座
;	12=うお座
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC

EOS		EQU	0	; end of string.

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

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

WSWAP	MACRO	SSSS,DDDD
	MOV	AX,SSSS
	MOV	BX,DDDD
	MOV	SSSS,BX
	MOV	DDDD,AX
	ENDM

WSWAPB	MACRO	SSSS,DDDD,CCCC
	LOCAL	L1
	MOV	SI,OFFSET SSSS
	MOV	DI,OFFSET DDDD
	MOV	CX,CCCC
L1:
	MOV	AH,DS:[SI]
	MOV	AL,DS:[DI]
	MOV	DS:[SI],AL
	MOV	DS:[DI],AH
	INC	SI
	INC	DI
	LOOP	L1
	ENDM


WLOAD_ES	MACRO	SSSS,CCCC
	LOCAL	L1
	MOV	SI,OFFSET SSSS
	MOV	CX,CCCC
L1:
	MOV	AL,ES:[DI]
	MOV	DS:[SI],AL
	INC	SI
	INC	DI
	LOOP	L1
	ENDM

WSAVE_ES	MACRO	SSSS,CCCC
	LOCAL	L1
	MOV	SI,OFFSET SSSS
	MOV	CX,CCCC
	REP	MOVSB
	ENDM

WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/カレンダー・初期処理
; ****************************************************

FUNC	WWIDCLEN_INIT,WIDCLEN_INIT
;**;	CALLC	PT_LD_CLEND		; カレンダＬＯＡＤ
	RET
FEND	WWIDCLEN_INIT


; ****************************************************
;	WINDOWS/カレンダー・設定処理
; ****************************************************

FUNC	WWIDCLEN_SET,WIDCLEN_SET
	CALL	WIDCLEN_OPEN		; カレンダー・ＯＰＥＮ
	CALL	WIDCLEN_DISP		; カレンダー表示
	RET
FEND	WWIDCLEN_SET


; ****************************************************
;	WINDOWS/カレンダー・再表示
; ****************************************************

FUNC	WWIDCLEN_SHOW,WIDCLEN_SHOW
	CALL	WID_DATE_GET		; 環境時間ＧＥＴ

	CALL	CHK_SEASON		; 季節のチェック

	CALL	WIDCLEN_DISP		; カレンダー表示

;*NON*;	CALLC	WIDDSP_ALG		; WINDOWS/季節アナログ設定
	RET
FEND	WWIDCLEN_SHOW



; ****************************************************
;	WINDOWS/カレンダー・更新処理
; ****************************************************

FUNC	WWIDCLEN_UDATE,WIDCLEN_UDATE
	CALL	WID_DATE_GET		; 環境時間ＧＥＴ

	CALL	UPDATE_SET		; 日付の更新

	CALL	CHK_SEASON		; 季節のチェック

	CALL	WIDCLEN_DISP		; カレンダー表示

	CALL	WID_DATE_PUT		; 環境時間ＰＵＴ

;*NON*;	CALLC	WIDDSP_ALG		; WINDOWS/季節アナログ設定
	RET
FEND	WWIDCLEN_UDATE


; ****************************************************
;	WINDOWS/カレンダー・更新処理/BACANCE
; ****************************************************

FUNC	WWIDCLEN_UDATE_BC,WIDCLEN_UDATE_BC
	CALL	WID_DATE_GET		; 環境時間ＧＥＴ

	CALL	UPDATE_SET		; 日付の更新

	CALL	CHK_SEASON		; 季節のチェック

;*;	CALL	WIDCLEN_DISP		; カレンダー表示

	CALL	WID_DATE_PUT		; 環境時間ＰＵＴ

;*;	MOV	XX1,3			; Ｘ座標
;*;	MOV	YY1,16			; Ｙ座標
;*;	MOV	SI,OFFSET NOW_DATE	; 現在時間
;*;	CALL	STRING_PUT		; 文字列表示

;*;	MOV	AX,12			; 曜日・表示位置Ｘ
;*;	MOV	BX,16			; 曜日・表示位置Ｙ
;*;	MOV	DX,VAL_WEEK		; 曜日
;*;	CALLC	PT_PUT_WEEK		; ｗｅｅｋ　ＰＵＴ

	RET
FEND	WWIDCLEN_UDATE_BC


; ****************************************************
;	WINDOWS/カレンダー・更新のみ処理（表示無）
; ****************************************************

FUNC	WWIDCLEN_UDATE_ONLY,WIDCLEN_UDATE_ONLY
	CALL	WID_DATE_GET		; 環境時間ＧＥＴ
	CALL	UPDATE_SET		; 日付の更新
	CALL	CHK_SEASON		; 季節のチェック
	CALL	WID_DATE_PUT		; 環境時間ＰＵＴ
	RET
FEND	WWIDCLEN_UDATE_ONLY

; ****************************************************
;	WINDOWS/カレンダー・早送り
;	-I- CX : 早送り日数
; ****************************************************

FUNC	WWIDCLEN_UD_FF,WIDCLEN_UD_FF
	JCXZ	WWIDCLEN_UD_FF_EXIT
WWIDCLEN_UD_FF_LOOP:
	PUSH	CX			;
	CALL	WID_DATE_GET		; 環境時間ＧＥＴ

	CALL	UPDATE_SET		; 日付の更新

	CALL	CHK_SEASON		; 季節のチェック

	CALL	WID_DATE_PUT		; 環境時間ＰＵＴ

;*NON*;	CALLC	WIDDSP_ALG		; WINDOWS/季節アナログ設定

	POP	CX			;
	LOOP	WWIDCLEN_UD_FF_LOOP	;
WWIDCLEN_UD_FF_EXIT:
	RET
FEND	WWIDCLEN_UD_FF


; ****************************************************
;	WINDOWS/カレンダー・読み取り処理
;	-I- ES:DI   : バッファ
;	-O- ES:[DI] : 日付
; ****************************************************

FUNC	WWIDCLEN_GET,WIDCLEN_GET
	PUSH	ES
	PUSH	DI

	MOV	SI,OFFSET NOW_DATE	; 現在時間
	MOV	CX,10			;
	REP	MOVSB			;

	POP	DI
	POP	ES
	RET
FEND	WWIDCLEN_GET


; ****************************************************
;	WINDOWS/カレンダー・日付加算計算
;	-I/O- ES:[DI] : 被加算日付
;	-I-   AX      : 加算日数
; ****************************************************

FUNC	WWIDCLEN_U_AD,WIDCLEN_U_AD
	PUSH	ES
	PUSH	DI

	PUSH	ES
	PUSH	DI

	PUSH	AX
	WLOAD_ES	USR_DATE,10
	CALL	DATE_SWAP			; 日付の交換（退避）
	MOV	SI,OFFSET NOW_DATE		; 現在時間
	CALL	DATE_STR_TO_VAL			; 日付文字列から数値へ
	POP	AX

	MOV	CX,AX				; 加算日数
	JCXZ	WIDCLEN_U_AD_LP_E		;
WIDCLEN_U_AD_LOOP:				;
	PUSH	CX				;
	CALL	UPDATE_SET			; 日付の更新
	POP	CX				;
	LOOP	WIDCLEN_U_AD_LOOP		;
WIDCLEN_U_AD_LP_E:				;

	CALL	CHK_SEASON			; 季節のチェック

	MOV	DI,OFFSET NOW_DATE		; 現在時間
	CALL	DATE_VAL_TO_STR			; 数値から日付文字列へ
	CALL	DATE_SWAP			; 日付の交換（退避）

	POP	DI
	POP	ES
	WSAVE_ES	USR_DATE,10

	POP	DI
	POP	ES
	RET
FEND	WWIDCLEN_U_AD


; ****************************************************
;	WINDOWS/カレンダー・翌月の末日
;	-O-   DX : 翌月の末日
; ****************************************************

FUNC	WWIDCLEN_NXT_E,WIDCLEN_NXT_E

	MOV	BX,VAL_MONTH			; (now)月

	INC	BX				; BX=翌月
	CMP	BX,12				;
	JLE	WIDCLEN_NXT_E_3			;
	MOV	BX,1				;
WIDCLEN_NXT_E_3:				; BX=月

	MOV	CX,VAL_YEAR			; 年
	CALL	MATSUJITSU			; 末日計算

	RET
FEND	WWIDCLEN_NXT_E


; ****************************************************
;	WINDOWS/カレンダー・年齢の計算
;	-I- ES:[DI] : 誕生日 "1870/03/03"
;	-O- DX : 年齢
;	    BX : 星座
; ****************************************************

FUNC	WWIDCLEN_AGE,WIDCLEN_AGE
	CALL	YOURAGE			; 年齢の計算

	PUSH	DX			;
	MOV	DX,BORTH_MONTH		; 誕生日の月
	MOV	AX,BORTH_DATE		; 誕生日の日
	CALL	WID_CONSTELLATION	; 星座チェック
	MOV	BX,DX			; 星座
	POP	DX			; 年齢
	RET
FEND	WWIDCLEN_AGE


; ****************************************************
;	WINDOWS/カレンダー・データ結合処理
; ****************************************************

FUNC	WWIDCLEN_LINK,WIDCLEN_LINK
	CALL	WID_ST_DATE_GET		; 環境開始時間

	CALL	WID_DATE_GET		; 環境時間ＧＥＴ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	DI,ES:[BX][VTB_TANJOBI][VAL_VALUE] ; 3. 誕生日

	CALL	YOURAGE			; 年齢の計算
	MOVX	MY_BORTH_MONTH,BORTH_MONTH ; 娘の誕生日の月
	MOVX	MY_BORTH_DATE,BORTH_DATE   ; 娘の誕生日の日

	CALL	CHK_SEASON		; 季節のチェック

	RET
FEND	WWIDCLEN_LINK


; ****************************************************
;	WINDOWS/カレンダー・月データ
;	-I- UCK_YEAR   : (user)年
;	    UCK_MONTH  : (user)月
;	-O- UCK_WEEK   : (user)曜日
;	    UCK_M_END  : (user)月末の日
; ****************************************************

FUNC	WWIDCLEN_MONTH_C,WIDCLEN_MONTH_C
	MOV	UCK_DATE,1		; (user)日=1

	CALL	DATE_SWAP		; 日付の交換

	CALL	WEEK_CHK		; 曜日の計算

	MOV	CX,VAL_YEAR		; 年
	MOV	BX,VAL_MONTH		; 月
	CALL	MATSUJITSU		; 末日計算
	MOV	VAL_M_END,DX		; 月末の日

	CALL	DATE_SWAP		; 日付の交換
	RET
FEND	WWIDCLEN_MONTH_C



;	カレンダー・ＯＰＥＮ

WIDCLEN_OPEN	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	CALLC	PT_PUT_CLEND			; カレンダＰＵＴ
	RET
WIDCLEN_OPEN	ENDP


;	カレンダー・ＣＬＯＳＥ

WIDCLEN_CLOSE	PROC	NEAR
	RET
WIDCLEN_CLOSE	ENDP



; ****************************************************
;	年齢の計算
;	-I- ES:[DI] : 誕生日 "1870/03/03"
;	-O- DX      : 年齢
;	    BORTH_YEAR : 誕生日の年
;	    BORTH_MONTH: 誕生日の月
;	    BORTH_DATE : 誕生日の日
; ****************************************************

YOURAGE		PROC	NEAR
	WLOAD_ES	USR_DATE,10	; 誕生日を USR_DATE へセット

	CALL	DATE_SWAP		; 日付の交換
	MOV	SI,OFFSET NOW_DATE	; 現在時間
	CALL	DATE_STR_TO_VAL		; 日付文字列から数値へ
	CALL	DATE_SWAP		; 日付の交換

	MOVX	BORTH_YEAR,UCK_YEAR	; 誕生日の年
	MOVX	BORTH_MONTH,UCK_MONTH	; 誕生日の月
	MOVX	BORTH_DATE,UCK_DATE	; 誕生日の日


	CMPX	BORTH_YEAR,VAL_YEAR	; 誕生日の年が今年ならば０才
	JE	YOURAGE_ZERO		;
	JNB	YOURAGE_ZERO		; 未来人ならば０才


	MOV	DX,VAL_YEAR		; 何年＝今年－誕生日の年－１
	SUB	DX,BORTH_YEAR		;
	DEC	DX			;
	MOV	HOW_LONG_YEAR,DX	;

	CMPX	VAL_MONTH,BORTH_MONTH	; 今月が誕生日の月の
	JB	YOURAGE_SET		; 前ならばそのまま
	JNBE	YOURAGE_INC		; 後ならば１才歳上

	CMPX	VAL_DATE,BORTH_DATE	: 今日が誕生日の
	JB	YOURAGE_SET		; 前ならばそのまま
YOURAGE_INC:
	INC	HOW_LONG_YEAR		;
YOURAGE_SET:
	MOV	DX,HOW_LONG_YEAR	;
	RET
YOURAGE_ZERO:
	MOV	DX,0			; ０才
	RET
YOURAGE		ENDP




;*;;	イベントメッセージ
;*;
;*;IVENT_MSG	PROC	NEAR
;*;	CMP	FLG_SHOGATSU,1		; フラグ・正月
;*;	JMPEQ	IVENT_MSG_1		;
;*;	CMP	FLG_URUBI,1		; フラグ・うるう日
;*;	JMPEQ	IVENT_MSG_2		;
;*;	CMP	FLG_BORTH,1		; フラグ・誕生日
;*;	JMPEQ	IVENT_MSG_3		;
;*;	CMP	FLG_CHRISTMAS_EVE,1	; フラグ・クリスマスイブ
;*;	JMPEQ	IVENT_MSG_4		;
;*;	RET
;*;IVENT_MSG_1:
;*;	PR_TXT	"正月がきました"
;*;	RET
;*;IVENT_MSG_2:
;*;	PR_TXT	"うるう日がきました"
;*;	RET
;*;IVENT_MSG_3:
;*;	PR_TXT	"誕生日がきました"
;*;	RET
;*;IVENT_MSG_4:
;*;	PR_TXT	"クリスマス・イブがきました"
;*;	RET
;*;IVENT_MSG	ENDP
;*;
;*;
;*;;	マウスＷＡＩＴ
;*;
;*;WAIT_MS	PROC	NEAR
;*;	EXTRN	MSCMOV:NEAR	; カーソル移動
;*;	CALL	MSCMOV		; カーソル移動
;*;	CMP	DX,0101H	;
;*;	JE	WAIT_MS		;
;*;	RET
;*;WAIT_MS	ENDP



;	日付の更新
;	-I/O- VAL_YEAR     : 年
;	      VAL_MONTH    : 月
;	      VAL_WEEK     : 曜日
;	      VAL_DATE     : 日
;	-O-   VAL_M_END    : 月末の日

UPDATE_SET	PROC	NEAR
	CALL	URUU_CHK		; うるう年チェック
	CMP	AX,1			; 1=うるう年
	JNE	UPDATE_SET_NORMAL	;

	CMP	VAL_MONTH,2		; ２月？
	JNE	UPDATE_SET_NORMAL	;
	CMP	VAL_DATE,28		; ２８日？
	JNE	UPDATE_SET_NORMAL	;

	INC	VAL_DATE		; 日の更新

	JMP	UPDATE_SET_M

UPDATE_SET_NORMAL:
	INC	VAL_DATE			; 日の更新

	MOV	BX,VAL_MONTH			; 月
	DEC	BX				;
	MOV	AH,0				;
	MOV	AL,DS:MONTH_CNT[BX]		; 月毎の最高日付
	CMP	VAL_DATE,AX			; 日は最高日付を越えてない？
	JLE	UPDATE_SET_M			;

	MOV	VAL_DATE,1			; １日
	INC	VAL_MONTH			; 月の更新
	CMP	VAL_MONTH,12			; 月
	JLE	UPDATE_SET_M			;

	MOV	VAL_MONTH,1			; 正月

	INC	VAL_YEAR			; 年の更新

UPDATE_SET_M:
	CALL	WEEK_CHK			; 曜日の計算

	MOV	CX,VAL_YEAR			; 年
	MOV	BX,VAL_MONTH			; 月
	CALL	MATSUJITSU			; 末日計算
	MOV	VAL_M_END,DX			; 月末の日

	RET
UPDATE_SET	ENDP



;	末日計算
;	-I- BX : (now)月
;	    CX : 年
;	-O- DX : 末日

MATSUJITSU	PROC	NEAR
	MOV	DH,0				;
	MOV	DL,DS:MONTH_CNT[BX][-1]		; 月毎の最高日付

	CMP	BX,2				; 月
	JNE	MATSUJITSU_5			;

	MOV	AX,CX				; 年
	CALL	URUU_CHK_AX			; うるう年チェック(AX)
	CMP	AX,1				; 0=普通の年,1=うるう年
	JNE	MATSUJITSU_4			;
	MOV	DX,29				;
	JMP	MATSUJITSU_5			;
MATSUJITSU_4:					;
	MOV	DX,28				;
MATSUJITSU_5:					;
	RET
MATSUJITSU	ENDP



;	季節のチェック
;	-I- VAL_YEAR     : 年
;	    VAL_MONTH    : 月
;	    VAL_WEEK     : 曜日
;	    VAL_DATE     : 日
;	-O- TM_SEASON    : 季節
;	    FLG_SHOGATSU : フラグ・正月
;	    FLG_URUBI    : フラグ・うるう日
;	    FLG_BORTH    : フラグ・誕生日
;	    FLG_CHRISTMAS_EVE : フラグ・クリスマスイブ
;	    FLG_HOLIDAY  : フラグ・休日
;	    FLG_SYUKAKU  : フラグ・収穫祭の準備

CHK_SEASON	PROC	NEAR
	MOV	FLG_SHOGATSU,0		; フラグ・正月
	MOV	FLG_URUBI,0		; フラグ・うるう日
	MOV	FLG_BORTH,0		; フラグ・誕生日
	MOV	FLG_CHRISTMAS_EVE,0	; フラグ・クリスマスイブ
	MOV	FLG_HOLIDAY,0		; フラグ・休日
	MOV	FLG_SYUKAKU,0		; フラグ・収穫祭の準備

	CMP	VAL_WEEK,0		; （日）Sunday
	JNE	CHK_SEASON_SUN		;
	MOV	FLG_HOLIDAY,1		; フラグ・休日
CHK_SEASON_SUN:

	CALL	ALL_DAY			; 年内合計日付

	CALL	URUU_CHK		; うるう年チェック
	CMP	AX,1			; 1=うるう年
	JMPEQ	CHK_SEASON_URU		;

	CMPX	VAL_A_DATE,STEP_SEASON[0] ; 冬 1-2
	JG	CHK_SEASON_11		;
	MOV	TM_SEASON,4		; 季節 4:冬
	JMP	CHK_SEASON_15		;
CHK_SEASON_11:				;
	CMPX	VAL_A_DATE,STEP_SEASON[2] ; 春 3-5
	JG	CHK_SEASON_12		;
	MOV	TM_SEASON,1		; 季節 1:春
	JMP	CHK_SEASON_15		;
CHK_SEASON_12:				;
	CMPX	VAL_A_DATE,STEP_SEASON[4] ; 夏 6-8
	JG	CHK_SEASON_13		;
	MOV	TM_SEASON,2		; 季節 2:夏
	JMP	CHK_SEASON_15		;
CHK_SEASON_13:				;
	CMPX	VAL_A_DATE,STEP_SEASON[6] ; 秋 9-10
	JG	CHK_SEASON_14		;
	MOV	TM_SEASON,3		; 季節 3:秋
	JMP	CHK_SEASON_15		;
CHK_SEASON_14:				;
	MOV	TM_SEASON,4		; 季節 4:冬
CHK_SEASON_15:				;

	JMP	CHK_SEASON_SKIP		;

CHK_SEASON_URU:
	CMPX	VAL_A_DATE,STEP_SEASON_URU[0] ; 冬 1-2
	JG	CHK_SEASON_21		;
	MOV	TM_SEASON,4		; 季節 4:冬
	JMP	CHK_SEASON_25		;
CHK_SEASON_21:				;
	CMPX	VAL_A_DATE,STEP_SEASON_URU[2] ; 春 3-5
	JG	CHK_SEASON_22		;
	MOV	TM_SEASON,1		; 季節 1:春
	JMP	CHK_SEASON_25		;
CHK_SEASON_22:				;
	CMPX	VAL_A_DATE,STEP_SEASON_URU[4] ; 夏 6-8
	JG	CHK_SEASON_23		;
	MOV	TM_SEASON,2		; 季節 2:夏
	JMP	CHK_SEASON_25		;
CHK_SEASON_23:				;
	CMPX	VAL_A_DATE,STEP_SEASON_URU[6] ; 秋 9-10
	JG	CHK_SEASON_24		;
	MOV	TM_SEASON,3		; 季節 3:秋
	JMP	CHK_SEASON_25		;
CHK_SEASON_24:				;
	MOV	TM_SEASON,4		; 季節 4:冬
CHK_SEASON_25:				;

CHK_SEASON_SKIP:			;

	CMPX	MY_BORTH_MONTH,VAL_MONTH ; 娘の誕生日の月
	JNE	CHK_SEASON_B		;
	CMPX	MY_BORTH_DATE,VAL_DATE	; 娘の誕生日
	JNE	CHK_SEASON_B		;
	MOV	FLG_BORTH,1		; フラグ・誕生日
CHK_SEASON_B:				;

	CMP	VAL_MONTH,2		; 月
	JNE	CHK_SEASON_U		;

	CMP	VAL_DATE,29		; 日
	JNE	CHK_SEASON_U		;

	MOV	FLG_URUBI,1		; フラグ・うるう日
CHK_SEASON_U:				;

	CMP	VAL_MONTH,12		; 月
	JNE	CHK_SEASON_C		;
	CMP	VAL_DATE,24		; 日
	JNE	CHK_SEASON_C		;
	MOV	FLG_CHRISTMAS_EVE,1	; フラグ・クリスマスイブ
	MOV	FLG_HOLIDAY,1		; フラグ・休日
CHK_SEASON_C:				;

	CMP	VAL_MONTH,1		; 月
	JNE	CHK_SEASON_S		;
	CMP	VAL_DATE,1		; 日
	JNE	CHK_SEASON_S		;
	MOV	FLG_SHOGATSU,1		; フラグ・正月
	MOV	FLG_HOLIDAY,1		; フラグ・休日
CHK_SEASON_S:				;

	CMP	VAL_MONTH,10-1		; 月（収穫祭は１０月）
	JNE	CHK_SEASON_41		;
	CMP	VAL_DATE,21		; 日（収穫祭１０日前）
	JL	CHK_SEASON_41		;

	MOV	FLG_SYUKAKU,1		; フラグ・収穫祭の準備

CHK_SEASON_41:				;

	RET
CHK_SEASON	ENDP




;	曜日の計算
;	-I- VAL_YEAR   : 年
;	    VAL_MONTH  : 月
;	    VAL_DATE   : 日
;	-O- VAL_WEEK   : 曜日

WEEK_CHK	PROC	NEAR
	CALL	ALL_DAY			; 年内合計日付

					; １年毎に１つ曜日が進む
					; うるう年には２つ曜日が進む
					; ４００年に１度、うるう年が無い

	MOV	AX,VAL_YEAR		; 年を４で割る
	DEC	AX			; (今年は抜き)
	MOV	DX,0			;
	MOV	BX,4			;
	DIV	BX			; AX = AX / BX : DX = AX mod BX
	MOV	URU_COUNT,AX		; うるう年の進む曜日

;*;	CODE_IN
;*;
;*;	PRV	"1. URU_COUNT=",URU_COUNT
;*;
;*;	MOV	AX,VAL_YEAR		; 年を４００で割る
;*;	DEC	AX			; (今年は抜き)
;*;	MOV	DX,0			;
;*;	MOV	BX,400			;
;*;	DIV	BX			; AX = AX / BX : DX = AX mod BX
;*;	SUB	URU_COUNT,AX		; ４００年に１度、うるう年が無い
;*;
;*;	PRV	"2. URU_COUNT=",URU_COUNT
;*;
;*;	CODE_OUT

	MOV	AX,URU_COUNT		; うるう年の進む曜日
	ADD	AX,VAL_YEAR		; 年を加算（１年毎に１つ曜日が進む）
	DEC	AX			; (今年は抜き)
	ADD	AX,VAL_A_DATE		; 年内合計日付
	ADD	AX,SHIFT_DAY		; シフト日数

	MOV	BX,7			; 何曜日か？
	MOV	DX,0			;
	DIV	BX			; AX = AX / BX : DX = AX mod BX

	MOV	VAL_WEEK,DX		; 曜日

	RET
WEEK_CHK	ENDP


;	年内合計日付
;	-I- VAL_YEAR   : 年
;	    VAL_MONTH  : 月
;	    VAL_DATE   : 日
;	-O- VAL_A_DATE : 年内合計日付

ALL_DAY	PROC	NEAR
	MOVX	VAL_A_DATE,VAL_DATE	; 年内合計日付
	MOV	BX,0			; byte pointer.
	MOV	CX,VAL_MONTH		; 月
	DEC	CX
	JCXZ	ALL_DAY_LOOP_END	;
ALL_DAY_LOOP:
	MOV	AL,DS:MONTH_CNT[BX]	; 月毎の最高日付
	MOV	AH,0			;
	ADD	VAL_A_DATE,AX		; 年内合計日付
	INC	BX			; byte pointer.
	LOOP	ALL_DAY_LOOP		;
ALL_DAY_LOOP_END:

	CALL	URUU_CHK		; うるう年チェック
	CMP	AX,1			; 1=うるう年
	JNE	ALL_DAY_URU		;

	CMP	VAL_MONTH,2		; 月
	JLE	ALL_DAY_URU		;

	INC	VAL_A_DATE		; 年内合計日付＋１
ALL_DAY_URU:				;
;*;	PRV	"VAL_A_DATE=",VAL_A_DATE
	RET
ALL_DAY	ENDP


;	うるう年チェック
;	-I- VAL_YEAR : 年
;	-O- AX : 0=普通の年,1=うるう年

URUU_CHK	PROC	NEAR
	MOV	AX,VAL_YEAR		; 年を４で割る
	CALL	URUU_CHK_AX		; うるう年チェック(AX)
	RET
URUU_CHK	ENDP


;	うるう年チェック(AX)
;	-I- AX : 年
;	-O- AX : 0=普通の年,1=うるう年

URUU_CHK_AX	PROC	NEAR
;*;	CODE_IN
;*;	PRV	"AX : 年",AX : 年
;*;	CODE_OUT


;*;	PUSH	AX			; ４００年に１度、うるう年が無い
;*;	MOV	DX,0			;
;*;	MOV	BX,400			;
;*;	DIV	BX			; AX = AX / BX : DX = AX mod BX
;*;	POP	AX			;
;*;	CMP	DX,0			; ４００年に一度のうるう年？
;*;	JE	URUU_CHK_AX_STD		;

	MOV	DX,0			;
	MOV	BX,4			;
	DIV	BX			; AX = AX / BX : DX = AX mod BX
	CMP	DX,0			;
	JE	URUU_CHK_AX_URU		; あまり３ならば、うるう年

URUU_CHK_AX_STD:
	MOV	AX,0			; 0=普通の年

;*;	CODE_IN
;*;	PRF	"0=普通の年"
;*;	CODE_OUT

	RET
URUU_CHK_AX_URU:
	MOV	AX,1			; 1=うるう年

;*;	CODE_IN
;*;	PRF	"1=うるう年"
;*;	CODE_OUT

	RET
URUU_CHK_AX	ENDP


;	星座チェック
;	-I- DX : うまれ月
;	    AX : うまれ日
;	-O- DX : 星座
;		1=おひつじ座
;		2=おうし座
;		3=ふたご座
;		4=かに座
;		5=しし座
;		6=おとめ座
;		7=てんびん座
;		8=さそり座
;		9=いて座
;		10=やぎ座
;		11=みずがめ座
;		12=うお座

WID_CONSTELLATION	PROC	NEAR
	CMP	DX,1
	JE	WID_CONSTE_JANUARY
	CMP	DX,2
	JE	WID_CONSTE_FEBRUARY
	CMP	DX,3
	JE	WID_CONSTE_MARCH
	CMP	DX,4
	JE	WID_CONSTE_APRIL
	CMP	DX,5
	JE	WID_CONSTE_MAY
	CMP	DX,6
	JE	WID_CONSTE_JUNE
	CMP	DX,7
	JE	WID_CONSTE_JULY
	CMP	DX,8
	JE	WID_CONSTE_AUGUST
	CMP	DX,9
	JE	WID_CONSTE_SEPTEMBER
	CMP	DX,10
	JE	WID_CONSTE_OCTOBER
	CMP	DX,11
	JE	WID_CONSTE_NOVEMBER
	CMP	DX,12
	JE	WID_CONSTE_DECEMBER
WID_CONSTE_JANUARY:
	CMP	AX,20
	JLE	WID_CONSTE_YAGI
	JMP	WID_CONSTE_MIZUGAME
WID_CONSTE_FEBRUARY:
	CMP	AX,19
	JLE	WID_CONSTE_MIZUGAME
	JMP	WID_CONSTE_UO
WID_CONSTE_MARCH:
	CMP	AX,20
	JLE	WID_CONSTE_UO
	JMP	WID_CONSTE_OHITSUJI
WID_CONSTE_APRIL:
	CMP	AX,20
	JLE	WID_CONSTE_OHITSUJI
	JMP	WID_CONSTE_OUSHI
WID_CONSTE_MAY:
	CMP	AX,21
	JLE	WID_CONSTE_OUSHI
	JMP	WID_CONSTE_FUTAGO
WID_CONSTE_JUNE:
	CMP	AX,21
	JLE	WID_CONSTE_FUTAGO
	JMP	WID_CONSTE_KANI
WID_CONSTE_JULY:
	CMP	AX,23
	JLE	WID_CONSTE_KANI
	JMP	WID_CONSTE_SHISHI
WID_CONSTE_AUGUST:
	CMP	AX,23
	JLE	WID_CONSTE_SHISHI
	JMP	WID_CONSTE_OTOME
WID_CONSTE_SEPTEMBER:
	CMP	AX,23
	JLE	WID_CONSTE_OTOME
	JMP	WID_CONSTE_TENBIN
WID_CONSTE_OCTOBER:
	CMP	AX,23
	JLE	WID_CONSTE_TENBIN
	JMP	WID_CONSTE_SASORI
WID_CONSTE_NOVEMBER:
	CMP	AX,22
	JLE	WID_CONSTE_SASORI
	JMP	WID_CONSTE_ITE
WID_CONSTE_DECEMBER:
	CMP	AX,22
	JLE	WID_CONSTE_ITE
	JMP	WID_CONSTE_YAGI

WID_CONSTE_OHITSUJI:
	MOV	DX,1		; 1=おひつじ座
	RET
WID_CONSTE_OUSHI:
	MOV	DX,2		; 2=おうし座
	RET
WID_CONSTE_FUTAGO:
	MOV	DX,3		; 3=ふたご座
	RET
WID_CONSTE_KANI:
	MOV	DX,4		; 4=かに座
	RET
WID_CONSTE_SHISHI:
	MOV	DX,5		; 5=しし座
	RET
WID_CONSTE_OTOME:
	MOV	DX,6		; 6=おとめ座
	RET
WID_CONSTE_TENBIN:
	MOV	DX,7		; 7=てんびん座
	RET
WID_CONSTE_SASORI:
	MOV	DX,8		; 8=さそり座
	RET
WID_CONSTE_ITE:
	MOV	DX,9		; 9=いて座
	RET
WID_CONSTE_YAGI:
	MOV	DX,10		; 10=やぎ座
	RET
WID_CONSTE_MIZUGAME:
	MOV	DX,11		; 11=みずがめ座
	RET
WID_CONSTE_UO:
	MOV	DX,12		; 12=うお座
	RET
WID_CONSTELLATION	ENDP



;	カレンダー表示
;	-I- VAL_YEAR   : 年
;	    VAL_MONTH  : 月
;	    VAL_WEEK   : 曜日
;	    VAL_DATE   : 日

WIDCLEN_DISP	PROC	NEAR
	CALL	WID_DSP_CLEAR		; 文字の消去
	CALL	WID_DSP_YEAR		; 年の表示
	CALL	WID_DSP_MONTH		; 月の表示
	CALL	WID_DSP_WEEK		; 曜日の表示
	CALL	WID_DSP_DATE		; 日の表示
	RET
WIDCLEN_DISP	ENDP



;	文字の消去

WID_DSP_CLEAR	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ

	ADD	AX,1			; 曜日・表示位置Ｘ
	ADD	BX,8*3+6		; 曜日・表示位置Ｙ

	MOV 	VX1,AX			; 表示位置Ｘ
	MOV 	VY1,BX			; 表示位置Ｙ
	MOV 	VX2,AX			; 表示位置Ｘ
	MOV 	VY2,BX			; 表示位置Ｙ
	ADD 	VX2,17			; 大きさＸ
	ADD 	VY2,8*4			; 大きさＹ

	MOV	CX,W_COL1		; WINDOWS/カラー・ハイライト
;*;	CALLC	BOXPAL			; ＢＯＸペイント
;*;	MOV	CX,W_COL4		; カラー・黒
;*;	CALLC	BOXMSS			; ＢＯＸメッシュ

	RET
WID_DSP_CLEAR	ENDP


;	年の表示
;	-I- VAL_YEAR : 年

WID_DSP_YEAR	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,D_YEAR_X		; 年・表示位置Ｘ
	ADD	BX,D_YEAR_Y		; 年・表示位置Ｙ
	MOV	XX1,AX			; Ｘ座標
	MOV	YY1,BX			; Ｙ座標

	MOV	DX,VAL_YEAR		; 年
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	INC	SI			; " 1670" -> "1670"
	CALL	STRING_PUT		; 文字列表示

	RET
WID_DSP_YEAR	ENDP


;	月の表示
;	-I- VAL_MONTH : 月

WID_DSP_MONTH	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,D_MONTH_X		; 月・表示位置Ｘ
	ADD	BX,D_MONTH_Y		; 月・表示位置Ｙ
	MOV	DX,VAL_MONTH		; 月
	CALLC	PT_PUT_MONTH		; ｍｏｎｔｈ　ＰＵＴ
	RET
WID_DSP_MONTH	ENDP


;	曜日の表示
;	-I- VAL_WEEK : 曜日

WID_DSP_WEEK	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,D_WEEK_X		; 曜日・表示位置Ｘ
	ADD	BX,D_WEEK_Y		; 曜日・表示位置Ｙ
	MOV	DX,VAL_WEEK		; 曜日
	CALLC	PT_PUT_WEEK		; ｗｅｅｋ　ＰＵＴ
	RET
WID_DSP_WEEK	ENDP


;	日の表示
;	-I- VAL_DATE : 日

WID_DSP_DATE	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,D_DATE_X		; 日・表示位置Ｘ
	ADD	BX,D_DATE_Y		; 日・表示位置Ｙ
	MOV	DX,VAL_DATE		; 日
	CALLC	PT_PUT_DAYS		; ｄａｙｓ　ＰＵＴ
	RET
WID_DSP_DATE	ENDP


;	文字列表示
;	-I- DS:[SI]   : 文字列バッファ
;	    XX1       : Ｘ座標
;	    YY1       : Ｙ座標
;	    CL_DSPCLR : 文字表示色
;	    CL_DSPCSZ : 文字表示サイズ

STRING_PUT	PROC	NEAR
	PUSH	SI

	MOV	AX,CL_DSPCLR2		; 日付文字表示色
	CALLC	MITCOL			; mini string color.

	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
;*;	CALLC	MGXPRN			; GAINAX mini string.
	CALLC	MGXPRNP			; GAINAX mini string.(put)

;*;	MOV	AX,CL_DSPCSZ		; 文字表示サイズ
;*;	CALLC	VTXSIZ			; character size set.
;*;
;*;	MOV	AX,CL_DSPCLR		; 文字表示色
;*;	CALLC	VTXCOL			; character color set.
;*;
;*;	MOV	AX,XX1			; Ｘ座標
;*;	MOV	BX,YY1			; Ｙ座標
;*;	MOV	CX,3			;
;*;STRING_PUT_LOOP:
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	CX
;*;	PUSH	SI
;*;	CALLC	VTXPOR			; vram text print OR.
;*;	POP	SI
;*;	POP	CX
;*;	POP	BX
;*;	POP	AX
;*;	INC	BX
;*;	LOOP	STRING_PUT_LOOP

	POP	SI
	RET
STRING_PUT	ENDP



;	表示値ワイド表示
;	-I- DSPVAL : 表示値
;	    XX1    : Ｘ座標
;	    YY1    : Ｙ座標

WIDVAL_WIDE	PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ

	MOV	DX,DSPVAL		; 表示値
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"

	MOV	AX,DS:[SI][3]		; "00012"->"12"
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BYTE PTR 0	; 2ｹﾀ

	MOV	AX,CL_DSPCLR2		; 日付文字表示色
	CALLC	MITCOL			; mini string color.

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MBTPRN			; BIG string. (null=end of string)
	RET
WIDVAL_WIDE	ENDP


;	環境開始時間
;	-O- ST_VAL_YEAR  : 環境開始・年
;	    ST_VAL_MONTH : 環境開始・月
;	    ST_VAL_WEEK  : 環境開始・曜日
;	    ST_VAL_DATE  : 環境開始・日
;
;		環境開始時間  DB "1880/10/16"

WID_ST_DATE_GET	PROC	NEAR
	CALL	DATE_SWAP			; 日付の交換

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_ENVIR			; 環境テーブル
	MOV	SI,ES:[BX][KAN_ENVIR_TSRT]	; 環境開始時間

	MOV	DI,OFFSET NOW_DATE		; 現在時間
	PUSH	DS				;
	MOV	AX,SEG DATA			;
	MOV	ES,AX				;
	MOV	AX,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	DS,AX				;
	MOV	CX,10				;
	REP	MOVSB				;
	POP	DS

	MOV	SI,OFFSET NOW_DATE		; 現在時間
	CALL	DATE_STR_TO_VAL			; 日付文字列から数値へ

	MOVX	ST_VAL_YEAR,VAL_YEAR		; 環境開始・年
	MOVX	ST_VAL_MONTH,VAL_MONTH		; 環境開始・月
	MOVX	ST_VAL_WEEK,VAL_WEEK		; 環境開始・曜日
	MOVX	ST_VAL_DATE,VAL_DATE		; 環境開始・日

	CALL	DATE_SWAP			; 日付の交換
	RET
WID_ST_DATE_GET	ENDP


;	環境時間ＧＥＴ
;	-O- NOW_DATE  : 現在時間
;	    VAL_YEAR  : 年
;	    VAL_MONTH : 月
;	    VAL_WEEK  : 曜日
;	    VAL_DATE  : 日
;
;		環境時間 DB "1880/10/16"

WID_DATE_GET	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_ENVIR			; 環境テーブル
	MOV	SI,ES:[BX][KAN_ENVIR_TIME]	; 環境時間

	MOV	DI,OFFSET NOW_DATE		; 現在時間
	PUSH	DS				;
	MOV	AX,SEG DATA			;
	MOV	ES,AX				;
	MOV	AX,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	DS,AX				;
	MOV	CX,10				;
	REP	MOVSB				;
	POP	DS

	MOV	SI,OFFSET NOW_DATE		; 現在時間
	CALL	DATE_STR_TO_VAL			; 日付文字列から数値へ

	RET
WID_DATE_GET	ENDP


;	環境時間ＰＵＴ
;	-I- VAL_YEAR  : 年
;	    VAL_MONTH : 月
;	    VAL_WEEK  : 曜日
;	    VAL_DATE  : 日
;
;		環境時間 DB "1880/10/16"

WID_DATE_PUT	PROC	NEAR
	MOV	DI,OFFSET NOW_DATE		; 現在時間
	CALL	DATE_VAL_TO_STR			; 数値から日付文字列へ

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_ENVIR			; 環境テーブル
	MOV	DI,ES:[BX][KAN_ENVIR_TIME]	; 環境時間

	MOV	SI,OFFSET NOW_DATE		; 現在時間
	MOV	CX,10				;
	REP	MOVSB				;

	RET
WID_DATE_PUT	ENDP


;	日付文字列から数値へ
;	-I- DS:[SI]   : 時間 DB "1880/10/16"
;	-O- VAL_YEAR  : 年
;	    VAL_MONTH : 月
;	    VAL_WEEK  : 曜日
;	    VAL_DATE  : 日
;	    VAL_A_DATE : 年内合計日付
;	    VAL_M_END  : 月末の日

DATE_STR_TO_VAL		PROC	NEAR
	MOV	AX,DS				;
	MOV	ES,AX				;
	MOV	DI,OFFSET STR_BUFF		; 文字列バッファ
	MOV	CX,10				;
	REP	MOVSB				;

	MOV	DS:STR_BUFF[4],BYTE PTR EOS	;
	MOV	DS:STR_BUFF[7],BYTE PTR EOS	;
	MOV	DS:STR_BUFF[10],BYTE PTR EOS	;

	MOV	SI,OFFSET STR_BUFF		; 1880
	CALLC	STRDEC				; string -> dec
	MOV	VAL_YEAR,DX			; 年

	MOV	SI,OFFSET STR_BUFF + 5		; 10
	CALLC	STRDEC				; string -> dec
	MOV	VAL_MONTH,DX			; 月

	MOV	SI,OFFSET STR_BUFF + 8		; 16
	CALLC	STRDEC				; string -> dec
	MOV	VAL_DATE,DX			; 日

	CALL	WEEK_CHK			; 曜日の計算

	CALL	ALL_DAY				; 年内合計日付

	MOV	CX,VAL_YEAR			; 年
	MOV	BX,VAL_MONTH			; 月
	CALL	MATSUJITSU			; 末日計算
	MOV	VAL_M_END,DX			; 月末の日
	RET
DATE_STR_TO_VAL		ENDP



;	数値から日付文字列へ
;	-I- VAL_YEAR  : 年
;	    VAL_MONTH : 月
;	    VAL_WEEK  : 曜日
;	    VAL_DATE  : 日
;	    DS:DI     : バッファ
;	-O- DS:[DI]   : 時間 DB "1880/10/16"

DATE_VAL_TO_STR		PROC	NEAR
	PUSH	DI

	MOV	DS:STR_BUFF[4], BYTE PTR '/'	;
	MOV	DS:STR_BUFF[7], BYTE PTR '/'	;

	MOV	DX,VAL_YEAR			; 年
	CALLC	DECSTR				; dec -> string
	MOVX	<WORD PTR STR_BUFF[0]>,DS:[SI][1] ; 01880
	MOVX	<WORD PTR STR_BUFF[2]>,DS:[SI][3] ;

	MOV	DX,VAL_MONTH			; 月
	CALLC	DECSTR				; dec -> string
	MOVX	<WORD PTR STR_BUFF[5]>,DS:[SI][3] ; 10

	MOV	DX,VAL_DATE			; 日
	CALLC	DECSTR				; dec -> string
	MOVX	<WORD PTR STR_BUFF[8]>,DS:[SI][3] ; 10

	POP	DI

	MOV	AX,DS				;
	MOV	ES,AX				;
	MOV	SI,OFFSET STR_BUFF		; 文字列バッファ
	MOV	CX,10				;
	REP	MOVSB				;
	RET
DATE_VAL_TO_STR		ENDP



;	日付の交換（退避）

DATE_SWAP	PROC	NEAR
	WSWAP	UCK_YEAR,VAL_YEAR	; 年
	WSWAP	UCK_MONTH,VAL_MONTH	; 月
	WSWAP	UCK_WEEK,VAL_WEEK	; 曜日
	WSWAP	UCK_DATE,VAL_DATE	; 日

	WSWAP	UCK_A_DATE,VAL_A_DATE	; 年内合計日付
	WSWAP	UCK_M_END,VAL_M_END	; 月末の日
	WSWAP	UCK_SEASON,TM_SEASON	; 季節（1:春,2:夏,3:秋,4:冬）

	WSWAP	UCK_SHOGATSU,FLG_SHOGATSU	; フラグ・正月
	WSWAP	UCK_URUBI,FLG_URUBI		; フラグ・うるう日
	WSWAP	UCK_CHRISTMAS_EVE,FLG_CHRISTMAS_EVE ; フラグ・クリスマスイブ
	WSWAP	UCK_BORTH,FLG_BORTH		; フラグ・誕生日
	WSWAP	UCK_HOLIDAY,FLG_HOLIDAY		; フラグ・休日
	WSWAP	UCK_SYUKAKU,FLG_SYUKAKU		; フラグ・収穫祭の準備

	WSWAPB	USR_DATE,NOW_DATE,10		; 現在時間退避

	RET
DATE_SWAP	ENDP


WINDOW	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	ST_VAL_YEAR			; 環境開始・年
PUBLIC	ST_VAL_MONTH			; 環境開始・月
PUBLIC	ST_VAL_WEEK			; 環境開始・曜日
PUBLIC	ST_VAL_DATE			; 環境開始・日

PUBLIC	NOW_DATE			; (now)現在時間
PUBLIC	VAL_YEAR			; (now)年
PUBLIC	VAL_MONTH			; (now)月
PUBLIC	VAL_WEEK			; (now)曜日
PUBLIC	VAL_DATE			; (now)日
PUBLIC	VAL_A_DATE			; (now)年内合計日付
PUBLIC	VAL_M_END			; (now)月末の日
PUBLIC	TM_SEASON			; (now)季節（1:春,2:夏,3:秋,4:冬）
PUBLIC	FLG_SHOGATSU			; (now)フラグ・正月
PUBLIC	FLG_URUBI			; (now)フラグ・うるう日
PUBLIC	FLG_CHRISTMAS_EVE 		; (now)フラグ・クリスマスイブ
PUBLIC	FLG_BORTH			; (now)フラグ・誕生日
PUBLIC	FLG_HOLIDAY			; (now)フラグ・休日
PUBLIC	FLG_SYUKAKU			; (now)フラグ・収穫祭の準備

PUBLIC	USR_DATE			; (user)現在時間退避
PUBLIC	UCK_YEAR			; (user)年
PUBLIC	UCK_MONTH			; (user)月
PUBLIC	UCK_WEEK			; (user)曜日
PUBLIC	UCK_DATE			; (user)日
PUBLIC	UCK_A_DATE			; (user)年内合計日付
PUBLIC	UCK_M_END			; (user)月末の日
PUBLIC	UCK_SEASON			; (user)季節（1:春,2:夏,3:秋,4:冬）
PUBLIC	UCK_SHOGATSU			; (user)フラグ・正月
PUBLIC	UCK_URUBI			; (user)フラグ・うるう日
PUBLIC	UCK_CHRISTMAS_EVE		; (user)フラグ・クリスマスイブ
PUBLIC	UCK_BORTH			; (user)フラグ・誕生日
PUBLIC	UCK_HOLIDAY			; (user)フラグ・休日
PUBLIC	UCK_SYUKAKU			; (user)フラグ・収穫祭の準備

PUBLIC	MY_BORTH_MONTH			; 娘の誕生日の月
PUBLIC	MY_BORTH_DATE			; 娘の誕生日の日

DSP_WID_X	DW	0 ;1		; ウインドウ表示位置Ｘ
DSP_WID_Y	DW	0 ;3		; ウインドウ表示位置Ｙ


D_YEAR_X	DW	9		; 年・表示位置Ｘ
D_YEAR_Y	DW	2*8+2		; 年・表示位置Ｙ
D_MONTH_X	DW	1		; 月・表示位置Ｘ
D_MONTH_Y	DW	5*8-3		; 月・表示位置Ｙ
D_WEEK_X	DW	1		; 曜日・表示位置Ｘ
D_WEEK_Y	DW	7*8-2		; 曜日・表示位置Ｙ
D_DATE_X	DW	9		; 日・表示位置Ｘ
D_DATE_Y	DW	4*8		; 日・表示位置Ｙ

CL_DSPCLR	DW	4;10		; 文字表示色
CL_DSPCLR2	DW	0;4		; 日付文字表示色
CL_DSPCSZ	DW	0		; 文字表示サイズ

XX1		DW	0		; Ｘ座標
YY1		DW	0		; Ｙ座標
DSPVAL		DW	0		; 内容表示値

;	環境開始時間
;	年	: １から６００００まで
;	月	: １から１２まで
;	日	: １から３１まで

ST_VAL_YEAR	DW	0		; 環境開始・年
ST_VAL_MONTH	DW	0		; 環境開始・月
ST_VAL_WEEK	DW	0		; 環境開始・曜日
ST_VAL_DATE	DW	0		; 環境開始・日

;	計算用時間
;	年	: １から６００００まで
;	月	: １から１２まで
;	日	: １から３１まで
;	曜日	: 
;	時	: 
;	分	: 
;	秒	: 

USR_DATE	DB	10 DUP (0),0,0	; 現在時間退避

UCK_YEAR	DW	1889		; 年
UCK_MONTH	DW	8		; 月
UCK_WEEK	DW	2		; 曜日
UCK_DATE	DW	15		; 日
UCK_A_DATE	DW	0		; 年内合計日付
UCK_M_END	DW	0		; 月末の日

UCK_SEASON	DW	1		; 季節（1:春,2:夏,3:秋,4:冬）

UCK_SHOGATSU	DW	0		; フラグ・正月
UCK_URUBI	DW	0		; フラグ・うるう日
UCK_CHRISTMAS_EVE DW	0		; フラグ・クリスマスイブ
UCK_BORTH	DW	0		; フラグ・誕生日
UCK_HOLIDAY	DW	0		; フラグ・休日
UCK_SYUKAKU	DW	0		; フラグ・収穫祭の準備

;	現在時間
;	年	: １から６００００まで
;	月	: １から１２まで
;	日	: １から３１まで
;	曜日	: 
;	時	: 
;	分	: 
;	秒	: 

;	うるう年
;	１年から４年ごとに２月２９日がある

NOW_DATE	DB	10 DUP (0),0,0	; 現在時間
VAL_YEAR	DW	1990		; 年
VAL_MONTH	DW	11		; 月
VAL_WEEK	DW	2		; 曜日
VAL_DATE	DW	15		; 日
VAL_A_DATE	DW	0		; 年内合計日付
VAL_M_END	DW	30		; (now)月末の日

TM_SEASON	DW	1		; 季節（1:春,2:夏,3:秋,4:冬）

FLG_SHOGATSU	DW	0		; フラグ・正月
FLG_URUBI	DW	0		; フラグ・うるう日
FLG_CHRISTMAS_EVE DW	0		; フラグ・クリスマスイブ
FLG_BORTH	DW	0		; フラグ・誕生日
FLG_HOLIDAY	DW	0		; フラグ・休日
FLG_SYUKAKU	DW	0		; フラグ・収穫祭の準備

MY_BORTH_MONTH	DW	8		; 娘の誕生日の月
MY_BORTH_DATE	DW	15		; 娘の誕生日の日

BORTH_YEAR	DW	0		; 誕生日の年
BORTH_MONTH	DW	8		; 誕生日の月
BORTH_DATE	DW	15		; 誕生日の日

HOW_LONG_YEAR	DW	15		; 何年

SHIFT_DAY	DW	3+3		; シフト日数

URU_COUNT	DW	0		; うるうカウンタ

MONTH_CNT	LABEL	BYTE		; 月毎の最高日付
	DB	31	;1
	DB	28	;2
	DB	31	;3
	DB	30	;4
	DB	31	;5
	DB	30	;6
	DB	31	;7
	DB	31	;8
	DB	30	;9
	DB	31	;10
	DB	30	;11
	DB	31	;12


STEP_SEASON	LABEL	WORD
	DW	31+28	+6	;(１週間ずらす)	; 冬 1-2
	DW	31+28+31+30+31	-6		; 春 3-5
	DW	31+28+31+30+31+30+31+31		; 夏 6-8
	DW	31+28+31+30+31+30+31+31+30+31	; 秋 9-10

STEP_SEASON_URU	LABEL	WORD
	DW	31+29				; 冬 1-2
	DW	31+29+31+30+31			; 春 3-5
	DW	31+29+31+30+31+30+31+31 	; 夏 6-8
	DW	31+29+31+30+31+30+31+31+30+31	; 秋 9-10


NAME_MONTH	LABEL	WORD
	DW	NAME_M_1
	DW	NAME_M_2
	DW	NAME_M_3
	DW	NAME_M_4
	DW	NAME_M_5
	DW	NAME_M_6
	DW	NAME_M_7
	DW	NAME_M_8
	DW	NAME_M_9
	DW	NAME_M_10
	DW	NAME_M_11
	DW	NAME_M_12
NAME_M_1	DB	"JANUARY",0
NAME_M_2	DB	"FEBRUARY",0
NAME_M_3	DB	"MARCH",0
NAME_M_4	DB	"APRIL",0
NAME_M_5	DB	"MAY",0
NAME_M_6	DB	"JUNE",0
NAME_M_7	DB	"JULY",0
NAME_M_8	DB	"AUGUST",0
NAME_M_9	DB	"SEPTEMBER",0
NAME_M_10	DB	"OCTOBER",0
NAME_M_11	DB	"NOVEMBER",0
NAME_M_12	DB	"DECEMBER",0

NAME_WEEK	LABEL	WORD
	DW	NAME_W_1
	DW	NAME_W_2
	DW	NAME_W_3
	DW	NAME_W_4
	DW	NAME_W_5
	DW	NAME_W_6
	DW	NAME_W_7
NAME_W_1	DB	"Sunday",0
NAME_W_2	DB	"Monday",0
NAME_W_3	DB	"Tuesday",0
NAME_W_4	DB	"Wednesday",0
NAME_W_5	DB	"Thursday",0
NAME_W_6	DB	"Friday",0
NAME_W_7	DB	"Saturday",0

DATA	ENDS

	END
;
;	end of "WIDCLEN.ASM"
;
