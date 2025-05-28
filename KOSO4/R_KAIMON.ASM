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
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC

CCT_OPEN_TYPE	EQU	9	; オープンタイプ タイプ９（バカンス用１つ）

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



CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	R_KAIMON		; 買物
PUBLIC	R_DISP_ITEM_M		; 持物アイテム表示

EXTRN	R_ITM_OFFSET:NEAR	; 持物アイテムのアイテムオフセット計算

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_ITEM_SCH:NEAR		; アイテム条件検索
EXTRN	R_GET_SELECT:NEAR	; ｱｲﾃﾑレコード内から選択単語を取り出す
EXTRN	R_ITM_MOCHIMON:NEAR	; 持物アイテム検索
EXTRN	R_ITM_MOCH_DEL:NEAR	; 持物アイテム削除
EXTRN	R_ITM_DOUBLE:NEAR	; 持物アイテム重複チェック
EXTRN	R_ITM_SOUBI_OUT:NEAR	; 装備外されチェック

EXTRN	R_SR_GIRL_NAME:NEAR	; キャラクタ名
EXTRN	R_SR_GIRL_FNAME:NEAR	; キャラクタ姓
EXTRN	R_SR_GIRL_SHOGO:NEAR	; キャラクタの称号
EXTRN	R_SR_GIRL_HELP:NEAR	; キャラクタに対する説明

EXTRN	R_SR_ITEM_NAME:NEAR	; アイテム名
EXTRN	R_SR_ITEM_HELP:NEAR	; アイテムに対する説明
EXTRN	R_SR_ITEM_PRICE:NEAR	; アイテムに対する値段
EXTRN	R_SR_ITEM_BUY:NEAR	; アイテムに対する買取り値段

EXTRN	WIDSLC_INIT:NEAR	; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR		; WINDOWS/セレクト・ウインドウ

EXTRN	WIDBAR_SOUBI_OPEN:NEAR	; WINDOWS/バー・装備ＯＰＥＮ
EXTRN	WIDBAR_SOUBI_CLOSE:NEAR	; WINDOWS/バー・装備ＣＬＯＳＥ
EXTRN	WIDBAR_SOUBI:NEAR	; WINDOWS/バー・装備ＰＵＴ

EXTRN	WIDITEM_CLEAR:NEAR	; WINDOWS/アイテム表示設定クリア
EXTRN	WIDITEM_INIT:NEAR	; WINDOWS/アイテム管理初期処理
EXTRN	WIDITEM_OPEN:NEAR	; WINDOWS/アイテムオープン
EXTRN	WIDITEM_CLOSE:NEAR	; WINDOWS/アイテムクローズ

EXTRN	WIDCCT_OPEN:NEAR	; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR	; WINDOWS/キャラクタクローズ
EXTRN	WIDCCT_CHANGE:NEAR	; WINDOWS/キャラクタチェンジ

EXTRN	WIDWAZA_OPEN:NEAR	; WINDOWS/技（わざ）オープン
EXTRN	WIDWAZA_CLOSE:NEAR	; WINDOWS/技（わざ）クローズ

EXTRN	WIDWORKS_OPEN:NEAR	; WINDOWS/行い（おこない）オープン
EXTRN	WIDWORKS_CLOSE:NEAR	; WINDOWS/行い（おこない）クローズ

EXTRN	WIDDSP_SAVE:NEAR	; WINDOWS/画面退避
EXTRN	WIDDSP_LOAD:NEAR	; WINDOWS/画面復元

EXTRN	WIDEVNTS_OPEN:NEAR  ;WINDOWS/イベントウインドウＯＰＥＮ(バンク退避)
EXTRN	WIDEVNTS_CLOSE:NEAR ;WINDOWS/イベントウインドウＣＬＯＳＥ(バンク退避)

EXTRN	WIDTXT_MODE:NEAR	; WINDOWS/テキストウインドウモード設定

EXTRN	WIDHED_D_HP:NEAR	; WINDOWS/ヘッダ・ＨＰ表示

EXTRN	TM_WAIT:NEAR		; タイマ待ち
EXTRN	TMVWAT:NEAR		; V-SYNC timer wait.

;*NON*;EXTRN	MSCSRT:NEAR		; カーソルスタート
;*NON*;EXTRN	MSCMOV:NEAR		; カーソル移動
;*NON*;EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
;*NON*;EXTRN	MSCSTP:NEAR		; カーソルストップ
;*NON*;EXTRN	MSCSTS:NEAR		; マウスカーソルステータス


; ****************************************************
;	買物
; ****************************************************

R_KAIMON	PROC	NEAR
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス

	PR_CLS
	PR_TXT	"町に買い出しに行くか。"
	MOV	DX,5			; イベント絵の番号 5=買物
	CALL	WIDEVNTS_OPEN		;WINDOWS/イベントウインドウＯＰＥＮ
	PR_TXT	"@いらっしゃいませ"
	SELECT	"品物をみせて,こんにちは,まちがえちゃった"

	CMP	WIDSNM,0			; ユーザ選択番号
	JMPEQ	R_KAIMON_SEL			;
	CMP	WIDSNM,2			; ユーザ選択番号
	JMPEQ	R_KAIMON_MACHIGAE		;
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JMPEQ	R_KAIMON_BREAK			;

	; これは△△△(family name）さん、娘さんためにのお買物ですかい？

	PR_CLS
	PR_TXT	"これは、"
	CALL	R_SR_GIRL_FNAME			; キャラクタ姓
;*;	CALL	R_SR_GIRL_NAME			; キャラクタ名
;*;	CALL	R_SR_GIRL_SHOGO			; キャラクタの称号
	PR_TXT	"さん@娘さんためにのお買物ですかい？"

R_KAIMON_SEL:
S_CALL	"武器がみたい,道具がみたい,兜がみたい,鎧がみたい,持物は？,売りたし,帰ります",R_KAIMON_EE
	DW	SHOW_BUKI			; 0.武器
	DW	SHOW_DOUGU			; 1.道具
	DW	SHOW_BOUGU_KABUTO		; 2.防具・兜
	DW	SHOW_BOUGU_YOROI		; 3.防具・鎧
	DW	SHOW_MOCHIMONO			; 4.持物は？
	DW	SHOW_URITASHI			; 5.売りたし
	DW	NONE_NONE			; 6.帰ります
R_KAIMON_EE:
	CMP	WIDSNM,6			; ユーザ選択番号
	JE	R_KAIMON_EXIT
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JE	R_KAIMON_EXIT
	JMP	R_KAIMON_SEL

R_KAIMON_EXIT:
	PR_CLS
	CALL	PAC_IN			; 口パクＩＮ
	PR_TXT	"またのお越しを！       "
	CALL	PAC_OUT			; 口パクＯＵＴ

;*;	PR_TXT	"よ！、"
;*;	CALL	R_SR_GIRL_NAME			; キャラクタ名
;*;	CALL	R_SR_GIRL_SHOGO			; キャラクタの称号
;*;	PR_TXT	"@またきてね"
	CALL	WIDEVNTS_CLOSE		;WINDOWS/イベントウインドウＣＬＯＳＥ
	RET
R_KAIMON_BREAK:
	PR_CLS
	CALL	WIDEVNTS_CLOSE		;WINDOWS/イベントウインドウＣＬＯＳＥ
	RET
R_KAIMON_MACHIGAE:
	PR_CLS
	CALL	PAC_IN			; 口パクＩＮ
	PR_TXT	"あれれ、お帰りですかい     "
	CALL	PAC_OUT			; 口パクＯＵＴ

;*;	CALL	R_SR_GIRL_NAME			; キャラクタ名
;*;	PR_TXT	"！@まちがいは、だれにでもある！"
	CALL	WIDEVNTS_CLOSE		;WINDOWS/イベントウインドウＣＬＯＳＥ
	RET
R_KAIMON	ENDP


; ****************************************************
;	武器
; ****************************************************

SHOW_BUKI	PROC	NEAR
	PR_CLS
	PR_TXT	"武器はこんなのがあるね"
	MOV	ITEM_ATTR,0		; アイテム種別 0=武器
	CALL	SHOW_BUY		; 商売
	RET
SHOW_BUKI	ENDP


;*NON*;; ****************************************************
;*NON*;;	防具
;*NON*;; ****************************************************
;*NON*;
;*NON*;SHOW_BOUGU	PROC	NEAR
;*NON*;	PR_TXT	"防具はどの種類のものを？"
;*NON*;	S_CALL	"兜がみたい,鎧がみたい,ほかのものにする",SHOW_BOUGU_EXIT
;*NON*;	DW	SHOW_BOUGU_KABUTO		; 防具・兜
;*NON*;	DW	SHOW_BOUGU_YOROI		; 防具・鎧
;*NON*;	DW	NONE_NONE
;*NON*;SHOW_BOUGU_EXIT:
;*NON*;	RET
;*NON*;SHOW_BOUGU	ENDP


; ****************************************************
;	防具・兜
; ****************************************************

SHOW_BOUGU_KABUTO	PROC	NEAR
	PR_CLS
	PR_TXT	"兜はこれだけだよ"
	MOV	ITEM_ATTR,1		; アイテム種別 1=防具・兜
	CALL	SHOW_BUY		; 商売
	RET
SHOW_BOUGU_KABUTO	ENDP


; ****************************************************
;	防具・鎧
; ****************************************************

SHOW_BOUGU_YOROI	PROC	NEAR
	PR_CLS
	PR_TXT	"鎧はいい物がそろってるよ"
	MOV	ITEM_ATTR,2		; アイテム種別 2=防具・鎧
	CALL	SHOW_BUY		; 商売
	RET
SHOW_BOUGU_YOROI	ENDP


;*NON*;SHOW_BOUGU_TATE		PROC	NEAR
;*NON*;	MOV	ITEM_ATTR,3		; アイテム種別 3=防具・盾
;*NON*;	CALL	SHOW_BUY		; 商売
;*NON*;	RET
;*NON*;SHOW_BOUGU_TATE		ENDP


; ****************************************************
;	持物は？
; ****************************************************

SHOW_MOCHIMONO	PROC	NEAR
	CALL	WIDDSP_SAVE		; WINDOWS/画面退避

	PR_CLS

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_ITM_MOCHIMON		; 持物アイテム検索

	CALL	R_DISP_ITEM_M		; 持物アイテム表示

	SELECT	"よいですか？"

	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
	RET
SHOW_MOCHIMONO	ENDP


; ****************************************************
;	売りたし
; ****************************************************

SHOW_URITASHI	PROC	NEAR
	PR_CLS
	MOV	FLAG_URIMON,0		; フラグ・売物
SHOW_URITASHI_LOOP:
	CALL	WIDDSP_SAVE		; WINDOWS/画面退避

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_ITM_MOCHIMON		; 持物アイテム検索

	CALL	R_DISP_ITEM_S		; 持物アイテム黙って表示

	CMP	K_TBL_MAX,0		; 検索レコード数
	JMPEQ	SHOW_URITASHI_NO	;

	MOV	FLAG_URIMON,1		; フラグ・売物

	PR_TXT	"どれを、売ってくれる？"

SHOW_URITASHI_LOOP_2:

	CALL	R_ITM_OFFSET		; 持物アイテムのアイテムオフセット計算

	MOV	BX,0			; 何ワード目か
	CALL	R_GET_SELECT		; ｱｲﾃﾑレコード内から選択単語を取り出す

	CALL	WIDSLC			; WINDOWS/セレクト・ウインドウ
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	SHOW_URITASHI_YAME	;

	MOVX	ITEM_NUM,WIDSNM		; アイテム通し番号

	MOV	SI,ITEM_NUM		; アイテム通し番号
	SHL	SI,1			; word pointer.
	MOVX	R_SR_ITM_ADRS,DS:K_TBL_OFSET[SI] ; 何を買うか（アドレス）

	MOV	DI,R_SR_ITM_ADRS	; アイテムアドレス
	MOV	S_FUNC,68		; 68=買取り価格
	CALL	R_KEISAN		; 各計算処理
	CMP	DX,0			; 価値なし
	JMPEQ	SHOW_URITASHI_KACHINASHI

	PR_CLS
	CALL	R_SR_ITEM_NAME		; アイテム名
	PR_TXT	"なら、@"
	CALL	R_SR_ITEM_BUY		; アイテムに対する買取り値段
	MOV	VAL_PRICE,DX		; 買取り値段
	PR_TXT	"でならば買うけどね‥‥"

SHOW_URITASHI_55:
	SELECT	"売る,やめる"
	CMP	WIDSNM,OFFF		; 売る
	JE	SHOW_URITASHI_YAME	;
	CMP	WIDSNM,1		; やめる
	JE	SHOW_URITASHI_YAMEKA	;

	PR_CLS
	CALL	R_SR_ITEM_NAME		; アイテム名
	PR_TXT	"、買取りました。"


	CALL	MOCHIMONO_KILL		; 持物を削除する。


	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	DX,VAL_PRICE		; 買取り値段
	MOV	S_FUNC,67		; 67=売りたし
	CALL	R_KEISAN		; 各計算処理

	CALL	WIDHED_D_HP		; WINDOWS/ヘッダ・ＨＰ表示

	CALL	WIDDSP_LOAD		; WINDOWS/画面復元

	JMP	SHOW_URITASHI_LOOP

SHOW_URITASHI_YAMEKA:			;
	PR_CLS
	PR_TXT	"別のものは‥‥"
	JMP	SHOW_URITASHI_LOOP_2	;

SHOW_URITASHI_KACHINASHI:
	PR_CLS
	PR_TXT	"わしには、そいつの価値は@わからんよ。"
	JMP	SHOW_URITASHI_LOOP_2

SHOW_URITASHI_YAME:
	JMP	SHOW_URITASHI_EXIT

SHOW_URITASHI_NO:
	CMP	FLAG_URIMON,1		; フラグ・売物
	JNE	SHOW_URITASHI_NO2	;
	PR_TXT	"@これで持物は無くなりました。"
	JMP	SHOW_URITASHI_NO3	;
SHOW_URITASHI_NO2:
	CALL	PR_MSG_MOTTENAI		; "なにも持っていない。"
SHOW_URITASHI_NO3:
	SELECT	"よいですか？"

SHOW_URITASHI_EXIT:
	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
	RET
SHOW_URITASHI	ENDP


; ****************************************************
;	持物を削除する。
;	そのとき装備しているものがあれば、外してしまう。
;	装備品が重複している時は、大丈夫。
;	-I- ITEM_NUM : アイテム通し番号
; ****************************************************

MOCHIMONO_KILL	PROC	NEAR

MOCHIMONO_KILL_SOUBI:
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,ITEM_NUM		; アイテム通し番号
	CALL	R_ITM_DOUBLE		; 持物アイテム重複チェック
	CMP	AX,1			; 1=重複する
	JE	MOCHIMONO_KILL_KILL	;

	MOV	ITEM_ATTR,BX		; アイテム種別

					; BX : アイテム種別
					; CX : レコード番号

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_ITM_SOUBI_OUT		; 装備外されチェック
	CMP	AX,1			; 1=外されるべき装備がある
	JNE	MOCHIMONO_KILL_KILL	;

	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	;   BX : 装備種別 0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,ITEM_ATTR		; アイテム種別
	MOV	CX,WIDOFS_ITEM		; アイテムテーブル
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	DX,0			; 表示停止スイッチ0=OFF 1=ON
	MOV	S_FUNC,16		; 16=装備・はずす
	CALL	R_KEISAN		; 各計算処理

	CALL	WIDBAR_SOUBI		; WINDOWS/バー・装備ＰＵＴ


MOCHIMONO_KILL_KILL:
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,ITEM_NUM		; アイテム通し番号
	CALL	R_ITM_MOCH_DEL		; 持物アイテム削除
	RET
MOCHIMONO_KILL	ENDP


; ****************************************************
;	道具
; ****************************************************

SHOW_DOUGU	PROC	NEAR
	PR_CLS
	PR_TXT	"道具はこんな感じだけどね‥‥‥"
	MOV	ITEM_ATTR,4		; アイテム種別 4=道具
	CALL	SHOW_BUY		; 商売
	RET
SHOW_DOUGU	ENDP



; ****************************************************
;	商売
;	-I- ITEM_ATTR : アイテム種別
; ****************************************************

SHOW_BUY	PROC	NEAR
	CALL	WIDDSP_SAVE		; WINDOWS/画面退避

	CALL	ITEM_SELECT		; アイテム選択
	CALL	DISP_ITEM_B		; アイテム表示
	JMP	SHOW_BUY_LOOP		;

SHOW_BUY_LOOP_RE:
	CALL	ITEM_SELECT		; アイテム選択
SHOW_BUY_LOOP:
	CALL	WIDSLC			; WINDOWS/セレクト・ウインドウ
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	SHOW_BUY_YAMERU		;

	PUSH	WIDSNM			; ユーザ選択番号
	CALL	BUY_REACTION		; 買いのリアクション
	POP	WIDSNM			;
	CMP	AX,1			; 1=買うのやめた
	JMPEQ	SHOW_BUY_LOOP_RE	;

	MOV	SI,WIDSNM		; ユーザ選択番号
	SHL	SI,1			; word pointer.
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,DS:K_TBL_OFSET[SI]	; 何を買うか（アドレス）
	MOV	CX,ITEM_ATTR		; アイテム種別
	MOV	DX,DS:K_TBL_REC[SI]	; アイテムレコードＮＯ

	MOV	S_FUNC,1		; 買物計算
	CALL	R_KEISAN		; 各計算処理

	CMP	AX,0			; 0=買いました
	JE	SHOW_BUY_KAIAGE		;
	CMP	AX,1			; 1=お金が足りません
	JE	SHOW_BUY_KAENAI		;
	CMP	AX,2			; 2=いっぱいで持てません
	JE	SHOW_BUY_IPPAI		;

	PR_TXT	"＠"
	JMP	SHOW_BUY_LOOP
SHOW_BUY_KAENAI:
	PR_TXT	"@お金が足りないようですね"
	JMP	SHOW_BUY_LOOP_RE
SHOW_BUY_IPPAI:
	PR_TXT	"@いっぱいで持てません"
	JMP	SHOW_BUY_LOOP_RE
SHOW_BUY_KAIAGE:
	CALL	WIDHED_D_HP		; WINDOWS/ヘッダ・ＨＰ表示
	PR_TXT	"@ありがとうございます@ほかには？"
	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
	RET
SHOW_BUY_YAMERU:
	PR_TXT	"@ほかにしますか？"
	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
	RET
SHOW_BUY	ENDP



; ****************************************************
;	買いのリアクション
;	-I- WIDSNM        ; ユーザ選択番号
;	    K_TBL_OFSET[] ; 何を買うかテーブル
;	-O- AX : 0=買った,1=買うのやめた
; ****************************************************

BUY_REACTION	PROC	NEAR
	PR_CLS
	PR_TXT	"どれどれ・・・@「"
	MOV	SI,WIDSNM		; ユーザ選択番号
	SHL	SI,1			; word pointer.
	MOVX	R_SR_ITM_ADRS,DS:K_TBL_OFSET[SI] ; 何を買うか（アドレス）
	CALL	R_SR_ITEM_HELP		; アイテムに対する説明
	PR_TXT	"」か・・・"

	MOV	FLAG_1,0			; 0=まだ値段きいていない
BUY_REACTION_LOOP:
	SELECT	"気に入った,いらない,いくらですか？"
	CMP	WIDSNM,0			; ユーザ選択番号
	JE	BUY_REACTION_KATTA		;
	CMP	WIDSNM,2			; ユーザ選択番号
	JE	BUY_REACTION_IKURA		;
	JMP	BUY_REACTION_YAMETA		;

BUY_REACTION_IKURA:
	PR_CLS
	CMP	FLAG_1,1			;
	JE	BUY_REACTION_IKURA2		;
	CALL	R_SR_ITEM_PRICE			; アイテムに対する値段
	PR_TXT	"になります。"
	MOV	FLAG_1,1			;
	JMP	BUY_REACTION_LOOP		;
BUY_REACTION_IKURA2:
	PR_CLS
	PR_TXT	"ひやかしはこまりますよ・・・"
	JMP	BUY_REACTION_LOOP		;
BUY_REACTION_KATTA:
	MOV	AX,0			; 0=買った
	RET
BUY_REACTION_YAMETA:
	PR_CLS
	PR_TXT	"なぁーんだやめるんですか@ほかには？"
	MOV	AX,1			; 1=買うのやめた
	RET
BUY_REACTION	ENDP



; ****************************************************
;	アイテム表示
;	-I- ITEM_ATTR : アイテム種別
;			0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾, 4=道具
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

DISP_ITEM_B	PROC	NEAR
;*;	CALL	MSCSTP			; カーソルストップ
	CALL	WIDITEM_CLEAR		; WINDOWS/アイテム表示設定クリア
	MOV	REC_NO,0
DISP_ITEM_B_LOOP:
	CMPX	REC_NO,K_TBL_MAX	; 検索レコード数
	JGE	DISP_ITEM_B_LOOP_E	;
	MOV	DX,ITEM_ATTR		; アイテム種別
	MOV	BX,REC_NO		; レコード番号
	SHL	BX,1			; word pointer.
	MOV	CX,DS:K_TBL_REC[BX]	; 検索レコードテーブル
	CALL	WIDITEM_OPEN		; WINDOWS/アイテムオープン
	CMP	AX,0			; 0=正常
	JNE	DISP_ITEM_B_LOOP_E	;

	INC	REC_NO			; レコード番号
	JMP	DISP_ITEM_B_LOOP
DISP_ITEM_B_LOOP_E:
;*;	CALL	MSCSRT			; カーソルスタート
	RET
DISP_ITEM_B	ENDP



; ****************************************************
;	持物アイテム表示
;	-I- K_TBL_ATR[]   : 検索レコード種別テーブル
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_DISP_ITEM_M	PROC	NEAR
	CMP	K_TBL_MAX,0		; 検索レコード数
	JNE	DISP_ITEM_M_START	;
	CALL	PR_MSG_MOTTENAI		; "なにも持っていない。"
	RET
DISP_ITEM_M_START:
	CALL	R_DISP_ITEM_S		; 持物アイテム黙って表示

	PR_TXT	"持物は………"
	RET
R_DISP_ITEM_M	ENDP


; ****************************************************
;	"なにも持っていない。"
; ****************************************************

PR_MSG_MOTTENAI	PROC	NEAR
	PR_TXT	"なにも持っていない。"
	RET
PR_MSG_MOTTENAI	ENDP


; ****************************************************
;	口パクＩＮ
; ****************************************************

PAC_IN	PROC	NEAR
	MOV	AX,1			; 口ぱくモード 1=口ぱくあり
	CALL	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	RET
PAC_IN	ENDP


; ****************************************************
;	口パクＯＵＴ
; ****************************************************

PAC_OUT	PROC	NEAR
	MOV	AX,0			; 口ぱくモード 0=口ぱくなし
	CALL	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	RET
PAC_OUT	ENDP


; ****************************************************
;	持物アイテム黙って表示
;	-I- K_TBL_ATR[]   : 検索レコード種別テーブル
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_DISP_ITEM_S	PROC	NEAR
	CALL	WIDITEM_CLEAR		; WINDOWS/アイテム表示設定クリア

	MOV	BX,0			; word pointer.
	MOV	CX,K_TBL_MAX		; 検索レコード数
	JCXZ	R_DISP_ITEM_S_E		;
R_DISP_ITEM_S_LOOP:
	PUSH	BX
	PUSH	CX
	MOV	DX,DS:K_TBL_ATR[BX]	; 検索レコード種別テーブル
	MOV	CX,DS:K_TBL_REC[BX]	; 検索レコードテーブル
	CALL	WIDITEM_OPEN		; WINDOWS/アイテムオープン
	POP	CX
	POP	BX
	CMP	AX,0			; 0=正常
	JNE	R_DISP_ITEM_S_E		;
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	R_DISP_ITEM_S_LOOP	;

R_DISP_ITEM_S_E:
	RET
R_DISP_ITEM_S	ENDP



; ****************************************************
;	アイテム選択
;	-I- ITEM_ATTR : アイテム種別
;			0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾, 4=道具
;	-O- ATMSEG   : テキストバッファセグメント
;	    ATMMAX   : 表示単語の数
;	    ATMTBL[] : 表示単語アドレス
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

ITEM_SELECT	PROC	NEAR
	MOV	DX,ITEM_ATTR		; アイテム種別

	CALL	R_ITEM_SCH		; アイテム条件検索

	MOV	BX,0			; 何ワード目か
	CALL	R_GET_SELECT	; ｱｲﾃﾑレコード内から選択文字アドレスを取り出す

	RET
ITEM_SELECT	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

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

ITEM_ATTR	DW	0	; アイテム種別 0=武器,1=防具・兜,2=防具・鎧
				;              3=防具・盾, 4=道具

FLAG_1		DW	0	; ワーク用フラグ

REC_NO		DW	0	; レコード番号

ITEM_NUM	DW	0	; アイテム通し番号

VAL_PRICE	DW	0	; お金

FLAG_URIMON	DW	0	; フラグ・売物

DATA	ENDS

	END
;
;	end of "R_KAIMON.ASM"
;
