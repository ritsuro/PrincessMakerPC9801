; "R_BACANS.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	バカンス
;
;	WIDGIRL.ASM より W_GIRL_GROW 少女（成長１,成長２,成長３,成長４）
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

CCT_OPEN_TYPE	EQU	9		; オープンタイプ
;*;NISSU_BACANS	EQU	10		; 日数・バカンス

CLASS_SPRING	EQU	1		; 春
CLASS_SUMMER	EQU	2		; 夏
CLASS_AUTUMN	EQU	3		; 秋
CLASS_WINTER	EQU	4		; 冬

PRICE_SPRING	EQU	100 ;10		; 春・値段
PRICE_SUMMER	EQU	100 ;20		; 夏・値段
PRICE_AUTUMN	EQU	100 ;150	; 秋・値段
PRICE_WINTER	EQU	100 ;8		; 冬・値段


MOVX	MACRO	DEST,SOUR
	MOV	AX,WORD PTR SOUR
	MOV	WORD PTR DEST,AX
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

DIVX	MACRO	RRR
	LOCAL	LL
	CMP	RRR,0
	JE	LL
	DIV	RRR
LL:
	ENDM


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_BACANS_SET			; バカンスセット
PUBLIC	R_BACANS_MAIN			; バカンス実行

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	TM_WAIT:NEAR			; タイマ待ち
EXTRN	TM_WAIT_H:NEAR			; タイマハーフ待ち

EXTRN	R_WORK_SCH:NEAR			; 行い条件検索
EXTRN	R_GET_SELECT:NEAR		; ｱｲﾃﾑレコード内から選択単語を取り出す

EXTRN	R_SCHO_MONTH:NEAR		; 成長の月次処理
EXTRN	R_SCHO_DAYS:NEAR		; 成長の日次処理

EXTRN	WIDFRM_BACALD:NEAR		; WINDOWS/バカンス部分復元
EXTRN	WIDFRM_BACASV:NEAR		; WINDOWS/バカンス部分退避

EXTRN	WIDSLC_INIT:NEAR		; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR			; WINDOWS/セレクト・ウインドウ

EXTRN	WIDDSP_SV_F:NEAR		; WINDOWS/画面フル退避
EXTRN	WIDDSP_LD_F:NEAR		; WINDOWS/画面フル復元

EXTRN	WIDCCT_INIT:NEAR		; WINDOWS/キャラクタ初期処理
EXTRN	WIDCCT_OPEN:NEAR		; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR		; WINDOWS/キャラクタクローズ
;*;EXTRN WIDCCT_CHANGE:NEAR		; WINDOWS/キャラクタチェンジ

EXTRN	WIDCLEN_INIT:NEAR		; WINDOWS/カレンダー・初期処理
EXTRN	WIDCLEN_SET:NEAR		; WINDOWS/カレンダー・時間設定
EXTRN	WIDCLEN_SHOW:NEAR		; WINDOWS/カレンダー・再表示
EXTRN	WIDCLEN_UDATE:NEAR		; WINDOWS/カレンダー・更新処理
EXTRN	WIDCLEN_GET:NEAR		; WINDOWS/カレンダー・読み取り処理
EXTRN	WIDCLEN_U_AD:NEAR		; WINDOWS/カレンダー・日付加算計算
EXTRN	WIDCLEN_UDATE_BC:NEAR		; WINDOWS/カレンダー・更新処理/BACANCE
EXTRN	WIDCLEN_UDATE_ONLY:NEAR		; WINDOWS/カレンダー・更新のみ処理

EXTRN	WIDDSP_ALG:NEAR			; WINDOWS/季節アナログ設定

EXTRN	PT_PALET_ST:NEAR		; パレットのセット
EXTRN	BLACK:NEAR			; ブラックアウト

EXTRN	PT_BACA_LD:NEAR			; バカンスの絵ロード
EXTRN	PT_BACA_PUT:NEAR		; バカンスの絵ＰＵＴ

EXTRN	R_SR_DATE_NOW:NEAR		; 本日の日付
EXTRN	R_SR_SR_LF:NEAR			; 改行
EXTRN	R_SR_SR_DESU:NEAR		; "です"
EXTRN	R_SR_SR_POTU:NEAR		; "・"
EXTRN	R_SR_SR_KAKO:NEAR		; "「"
EXTRN	R_SR_SR_KOKA:NEAR		; "」"
EXTRN	TKRSET:NEAR			; 台詞改行のカウンタリセット
EXTRN	R_SR_YOIDESUKA:NEAR		; よいですか

EXTRN	R_SR_PRICE:NEAR			; 通貨表示
EXTRN	R_SR_IDSTR:NEAR			; ＩＤ文字列表示
EXTRN	R_SR_POINT:NEAR			; ポイント表示
EXTRN	R_SR_WIDSTR:NEAR		; 文字列表示

EXTRN	MITPRN:NEAR			; mini string. (null=end of string)
EXTRN	MITCOL:NEAR			; mini string color.

EXTRN	MGXPRNP:NEAR			; GAINAX mini string.(put)


; ****************************************************
;	バカンス
;	-I- R_NISSU  : 日数
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    KETTEI   : 0=決定,1=考え直す
; ****************************************************

R_BACANS_SET	PROC	NEAR
	MOV	R_KOUMKU,ID_71		; バカンス

	CMP	UCK_SEASON,1		; (user)季節1:春
	JE	R_BACANS_SET_SPRING	;
	CMP	UCK_SEASON,2		; (user)季節2:夏
	JE	R_BACANS_SET_SUMMER	;
	CMP	UCK_SEASON,3		; (user)季節3:秋
	JE	R_BACANS_SET_AUTUMN	;
	CMP	UCK_SEASON,4		; (user)季節4:冬
	JE	R_BACANS_SET_WINTER	;

R_BACANS_SET_SPRING:
	WD_ADRS	ID_75,R_NAISTR		; 春のバカンス
	MOV	R_NAIYOU,CLASS_SPRING	; 春
	MOV	R_SYUTSU,PRICE_SPRING	; 春・値段
	JMP	R_BACANS_SET_SET
R_BACANS_SET_SUMMER:
	WD_ADRS	ID_76,R_NAISTR		; 夏のバカンス
	MOV	R_NAIYOU,CLASS_SUMMER	; 夏
	MOV	R_SYUTSU,PRICE_SUMMER	; 夏・値段
	JMP	R_BACANS_SET_SET
R_BACANS_SET_AUTUMN:
	WD_ADRS	ID_77,R_NAISTR		; 秋のバカンス
	MOV	R_NAIYOU,CLASS_AUTUMN	; 秋
	MOV	R_SYUTSU,PRICE_AUTUMN	; 秋・値段
	JMP	R_BACANS_SET_SET
R_BACANS_SET_WINTER:
	WD_ADRS	ID_78,R_NAISTR		; 冬のバカンス
	MOV	R_NAIYOU,CLASS_WINTER	; 冬
	MOV	R_SYUTSU,PRICE_WINTER	; 冬・値段
	JMP	R_BACANS_SET_SET

R_BACANS_SET_SET:
	MOV	R_NYUKIN,0		; 入金

;*;	PR_CLS

	PR_LF				;
	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_NAISTR		; 内容文字列
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"
	PR_TXT	"、料金は"

	MOV	DX,R_SYUTSU		; 出金
	CALL	R_SR_PRICE		; 通貨表示

;*;	MOV	R_NISSU,NISSU_BACANS	; 日数・バカンス


;*NON*;	SELECT	"決めた,べつのにしよう"
;*NON*;	CMP	WIDSNM,1		; ユーザ選択番号
;*NON*;	JE	R_BACANS_SET_YAMERU	;

	MOV	KETTEI,0		; 0=決定
	RET
;*NON*;R_BACANS_SET_YAMERU:
;*NON*;	PR_CLS
;*NON*;	PR_TXT	"いらないかな・・・@@@"
;*NON*;	MOV	KETTEI,1		; 1=考え直す
;*NON*;	RET
R_BACANS_SET	ENDP


; ****************************************************
;	バカンススタート
;	-I- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列（アドレス）
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    R_NISSU  : 日数
;	    KETTEI   : 0=決定,1=考え直す
;	    KEIZOKU_FLG : 継続か？0=通常,1=継続
;	-O- BACA_CHUSHI : バカンス 1=決行,0=中止
;	    UP_MORAL_VAL: モラルアップ予定ポイント
; ****************************************************

R_BACANS_SRT	PROC	NEAR
	CMP	KEIZOKU_FLG,1		; 継続か？0=通常,1=継続
	JE	R_BACANS_SRT_2		;

;*;	PR_LF
;*;	CALL	R_SR_SR_KAKO		; "「"
;*;	MOV	DX,R_NAISTR		;
;*;	CALL	R_SR_WIDSTR		; 文字列表示
;*;	CALL	R_SR_SR_KOKA		; "」"
;*;	MOV	DX,R_SYUTSU		; 出金
;*;	CALL	R_SR_PRICE		; 通貨表示

R_BACANS_SRT_2:
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;
;*;	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,R_SYUTSU		; 出金
	MOV	S_FUNC,48		; 48=バカンスパラメータ計算
	CALL	R_KEISAN		; 各計算処理
	MOV	UP_MORAL_VAL,DX		; モラルアップ予定ポイント
	MOV	UP_KAIFUK_HIRO,CX	; 疲労回復予定ポイント

	CMP	AX,2			; 2=お金が足りません
	JE	R_BACANS_SRT_52		;
R_BACANS_SRT_51:
	MOV	BACA_CHUSHI,1		; バカンス 1=決行
;*NON*;	PR_TXT	"@わーいわーい"
	JMP	R_BACANS_SRT_53
R_BACANS_SRT_52:
	MOV	BACA_CHUSHI,0		; バカンス 0=中止
R_BACANS_SRT_53:
;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*;
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*NON*;
;*NON*;	CALL	TM_WAIT			; タイマ待ち＊＊＊＊＊＊＊
;*NON*;
R_BACANS_SRT_EXIT:
	RET
R_BACANS_SRT	ENDP


; ****************************************************
;	バカンス実行
;	-I- DX   : 継続か？0=通常,1=継続
;	    R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列（アドレス）
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    R_NISSU  : 日数
;	-O- DX   : バカンス中誕生日フラグ
;	           1=バカンス中に誕生日があった
;	    AX   : 0=バカンス成功,1=金無しバカンス中止
;	    CX   : 季節（1:春,2:夏,3:秋,4:冬）
; ****************************************************

R_BACANS_MAIN	PROC	NEAR
	MOV	KEIZOKU_FLG,DX		; 継続か？0=通常,1=継続
	MOV	BACA_BORTH_F,0		; バカンス中誕生日フラグ

	CALL	R_BACANS_SRT		; バカンススタート
	CMP	BACA_CHUSHI,0		; 0=中止
	JMPEQ	R_BACANS_MAIN_CHUSHI	;

	MOV	DX,0			;
	MOV	AX,UP_MORAL_VAL		; モラルアップ予定ポイント
	MOV	BX,R_NISSU		; 日数
	DIVX	BX			;
	MOV	UP_MORAL_DAYS,AX	; モラルアップ予定ポイント日割
	MOV	UP_MORAL_MOD,DX		; モラルアップ予定ポイント余り

	MOV	DX,0			;
	MOV	AX,UP_KAIFUK_HIRO	; 疲労回復予定ポイント
	MOV	BX,R_NISSU		; 日数
	DIVX	BX			;
	MOV	UP_KAIFUK_DAYS,AX	; 疲労回復予定ポイント日割
	MOV	UP_KAIFUK_MOD,DX	; 疲労回復予定ポイント余り

	MOV	DAY_COUNTER,0		; 日数カウンタ
R_BACANS_MAIN_LOOP:
	CMPX	DAY_COUNTER,R_NISSU	; 日数カウンタ
	JGE	R_BACANS_MAIN_LOOP_END	;

	INC	DAY_COUNTER		; 日数カウンタ

	CMP	DAY_COUNTER,1		; 日数カウンタ
	JE	R_BACANS_MAIN_31	;

	CALL	WIDCLEN_UDATE_BC	; WINDOWS/カレンダー・更新処理/BACANCE

	JMP	R_BACANS_MAIN_33	;
R_BACANS_MAIN_31:
	CALL	WIDCLEN_UDATE_BC	; WINDOWS/カレンダー・更新処理/BACANCE
	CALL	BACA_OPEN		; バカンスへ！
R_BACANS_MAIN_33:
	MOV	XX1,3			; Ｘ座標
	MOV	YY1,16			; Ｙ座標
	MOV	SI,OFFSET NOW_DATE	; 現在時間
	CALL	STRING_PUT		; 文字列表示

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,UP_MORAL_DAYS	; モラルアップ予定ポイント日割
	MOV	S_FUNC,57		; 57=モラル計算
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,UP_KAIFUK_DAYS	; 疲労回復予定ポイント日割
	MOV	S_FUNC,71		; 71=とにかく疲労回復
	CALL	R_KEISAN		; 各計算処理

	CALL	R_SCHO_DAYS		; 成長の日次処理

	CMP	MY_GIRL_BORTH_F,1	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	JNE	R_BACANS_MAIN_NEXT	;

	MOV	BACA_BORTH_F,1		; 1=バカンス中に誕生日があった

R_BACANS_MAIN_NEXT:
	JMP	R_BACANS_MAIN_LOOP

R_BACANS_MAIN_LOOP_END:
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,UP_MORAL_MOD		; モラルアップ予定ポイント余り
	MOV	S_FUNC,57		; 57=モラル計算
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,UP_KAIFUK_MOD	; 疲労回復予定ポイント余り
	MOV	S_FUNC,71		; 71=とにかく疲労回復
	CALL	R_KEISAN		; 各計算処理

	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ

	CALL	BACA_CLOSE		; バカンス終り！

	JMP	R_BACANS_MAIN_EXIT	;
R_BACANS_MAIN_CHUSHI:
	MOV	CX,0			;
	MOV	AX,1			; 1=金無しバカンス中止
	RET
R_BACANS_MAIN_EXIT:
	MOV	CX,OLD_SEASON		; 前回の季節
	MOV	DX,BACA_BORTH_F		; 1=バカンス中に誕生日があった
	MOV	AX,0			; 0=バカンス成功
	RET
R_BACANS_MAIN	ENDP


; ****************************************************
;	バカンスへ！
;	-I- KEIZOKU_FLG : 継続か？0=通常,1=継続
; ****************************************************

BACA_OPEN	PROC	NEAR
	CMP	KEIZOKU_FLG,0		; 継続か？0=通常,1=継続
	JE	BACA_OPEN_2		;

	CMPX	OLD_GR_GROW,W_GIRL_GROW	; 前回の少女
	JNE	BACA_OPEN_2		;
	CMPX	OLD_SEASON,TM_SEASON	; 前回の季節
	JNE	BACA_OPEN_2		;

	JE	BACA_OPEN_8		;
BACA_OPEN_2:				;
	MOV	DX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
	MOV	CX,TM_SEASON		; (now)季節（1:春,2:夏,3:秋,4:冬）
	CALL	PT_BACA_LD		; バカンスの絵ロード
	CALL	BLACK			; 黒
	CALL	PT_BACA_PUT		; バカンスの絵ＰＵＴ
	MOVX	OLD_GR_GROW,W_GIRL_GROW	; 前回の少女
	MOVX	OLD_SEASON,TM_SEASON	; 前回の季節

	MOV	AX,0			; 数値表示色
	CALL	MITCOL			; mini string color.
	MOV	AX,1			; 文字列Ｘ位置
	MOV	BX,400-10		; 文字列Ｙ位置
	MOV	SI,OFFSET MSG_VACANCE	; "vacances"
	CALL	MITPRN			; mini string. (null=end of string)

	CALL	WIDFRM_BACASV		; WINDOWS/バカンス部分退避

	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン
;*;	CALL	WIDCLEN_SET		; WINDOWS/カレンダー・時間設定

	BOXPAA	2,15,13,32,15
	BOXPAA	3,29,12,30,10


BACA_OPEN_8:				;
	RET
BACA_OPEN	ENDP


; ****************************************************
;	バカンス終り！
; ****************************************************

BACA_CLOSE	PROC	NEAR
	RET
BACA_CLOSE	ENDP


; ****************************************************
;	文字列表示
;	-I- DS:[SI]   : 文字列バッファ
;	    XX1       : Ｘ座標
;	    YY1       : Ｙ座標
;	    CL_DSPCLR : 文字表示色
;	    CL_DSPCSZ : 文字表示サイズ
; ****************************************************

STRING_PUT	PROC	NEAR
	PUSH	SI

	MOV	AX,CL_DSPCLR2		; 日付文字表示色
	CALL	MITCOL			; mini string color.

	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	CALL	MGXPRNP			; GAINAX mini string.(put)

	POP	SI
	RET
STRING_PUT	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	WIDSNM:WORD			; ユーザ選択番号

EXTRN	R_KOUMKU:WORD			; 項目
EXTRN	R_NAISTR:WORD			; 内容文字列
EXTRN	R_NAIYOU:WORD			; 内容値
EXTRN	R_NYUKIN:WORD			; 入金
EXTRN	R_SYUTSU:WORD			; 出金
EXTRN	R_NISSU:WORD			; 日数

EXTRN	KETTEI:WORD			; 決定フラグ

EXTRN	MY_GIRL_BORTH_F:WORD	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ(R_SEICHO.ASM)

EXTRN	W_GIRL_SEASON:WORD	; 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
EXTRN	W_GIRL_GROW:WORD	; 少女（成長１,成長２,成長３,成長４）
EXTRN	W_GIRL_FACE:WORD	; 顔（１－３）

EXTRN	R_SR_CHR_ADRS:WORD	; 台詞・キャラクタアドレス
EXTRN	R_SR_ITM_ADRS:WORD	; 台詞・アイテムアドレス

EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	K_TBL_REC:WORD		; 検索レコードテーブル
EXTRN	K_TBL_OFSET:WORD	; 検索レコードｵﾌｾｯﾄテーブル
EXTRN	K_TBL_ATR:WORD		; 検索レコード種別テーブル
EXTRN	K_TBL_MAX:WORD		; 検索レコード数
EXTRN	K_TBL_DIM:WORD		; 検索レコードテーブルサイズ

EXTRN	ATMSEG:WORD		; WINDOWS/テキストバッファセグメント
EXTRN	ATMTBL:WORD		; WINDOWS/表示単語アドレス
EXTRN	ATMMAX:WORD		; WINDOWS/表示単語の数
EXTRN	ATMDIM:WORD	 	; WINDOWS/表示単語のテーブルサイズ

EXTRN	NOW_DATE:BYTE		; (now)現在時間
EXTRN	VAL_YEAR:WORD		; (now)年
EXTRN	VAL_MONTH:WORD		; (now)月
EXTRN	VAL_WEEK:WORD		; (now)曜日
EXTRN	VAL_DATE:WORD		; (now)日
EXTRN	VAL_A_DATE:WORD		; (now)年内合計日付
EXTRN	VAL_M_END:WORD		; (now)月末の日
EXTRN	TM_SEASON:WORD		; (now)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	FLG_SHOGATSU:WORD	; (now)フラグ・正月
EXTRN	FLG_URUBI:WORD		; (now)フラグ・うるう日
EXTRN	FLG_CHRISTMAS_EVE:WORD	; (now)フラグ・クリスマスイブ
EXTRN	FLG_BORTH:WORD		; (now)フラグ・誕生日
EXTRN	FLG_HOLIDAY:WORD	; (now)フラグ・休日
EXTRN	FLG_SYUKAKU:WORD	; (now)フラグ・収穫祭の準備

EXTRN	USR_DATE:BYTE		; (user)現在時間退避
EXTRN	UCK_YEAR:WORD		; (user)年
EXTRN	UCK_MONTH:WORD		; (user)月
EXTRN	UCK_WEEK:WORD		; (user)曜日
EXTRN	UCK_DATE:WORD		; (user)日
EXTRN	UCK_A_DATE:WORD		; (user)年内合計日付
EXTRN	UCK_SEASON:WORD		; (user)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	UCK_SHOGATSU:WORD	; (user)フラグ・正月
EXTRN	UCK_URUBI:WORD		; (user)フラグ・うるう日
EXTRN	UCK_CHRISTMAS_EVE:WORD	; (user)フラグ・クリスマスイブ
EXTRN	UCK_BORTH:WORD		; (user)フラグ・誕生日

BACA_CHUSHI	DW	0	; バカンス 1=決行,0=中止
DAY_COUNTER	DW	0	; 日数カウンタ
BACA_BORTH_F	DW	0	; バカンス中誕生日フラグ
				; 1=バカンス中に誕生日があった
KEIZOKU_FLG	DW	0	; 継続か？0=通常,1=継続

OLD_GR_GROW	DW	0	; 前回の少女
OLD_SEASON	DW	0	; 前回の季節

UP_MORAL_VAL	DW	0	; モラルアップ予定ポイント
UP_MORAL_DAYS	DW	0	; モラルアップ予定ポイント日割
UP_MORAL_MOD	DW	0	; モラルアップ予定ポイント余り

UP_KAIFUK_HIRO	DW	0	; 疲労回復予定ポイント
UP_KAIFUK_DAYS	DW	0	; 疲労回復予定ポイント日割
UP_KAIFUK_MOD	DW	0	; 疲労回復予定ポイント余り

CL_DSPCLR2	DW	0		; 文字表示色
CL_DSPCSZ	DW	0		; 文字表示サイズ

XX1		DW	0		; Ｘ座標
YY1		DW	0		; Ｙ座標

MSG_VACANCE	DB	"vacances",0,0

DATA	ENDS

	END
;
;	end of "R_BACANS.ASM"
;
