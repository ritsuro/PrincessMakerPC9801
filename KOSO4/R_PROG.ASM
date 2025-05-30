; "R_PROG.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	スケジュール実行
;
;	ID_65	; 武芸
;	ID_66	; 学問		
;	ID_67	; 礼法
;	ID_68	; 武者修行	
;	ID_69	; 休息		
;	ID_71	; バカンス	
;	ID_70	; アルバイト
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

CCT_OPEN_TYPE	EQU	4	; オープンタイプ
CCT_OPEN_TYPEB	EQU	10	; オープンタイプ・病気

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


S_MTRX_NOP	EQU	0	; 何もない
S_MTRX_STR	EQU	1	; 文字列
S_MTRX_VAL	EQU	2	; 数値
S_MTRX_GOLD	EQU	3	; 通貨
S_MTRX_DATE	EQU	4	; 日付
S_MTRX_IDSTR	EQU	5	; ＩＤ文字列


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_PROG			; スケジュール実行

PUBLIC	R_BORTH_DAY_AREA	; 誕生日の会場

PUBLIC	R_MAIN_WINDOW_DSP	; メインウインドウ復帰

PUBLIC	BAD_WINDOW_OPEN		; 病気ステータスウインドウＯＰＥＮ
PUBLIC	BAD_WINDOW_CLOSE	; 病気ステータスウインドウＣＬＯＳＥ

PUBLIC	BAD_WIND02_OPEN		; 病気ステータス無表示ＯＰＥＮ
PUBLIC	BAD_WIND02_CLOSE	; 病気ステータス無表示ＣＬＯＳＥ

PUBLIC	BAD_WIND03_OPEN		; ステータス無表示ＯＰＥＮ
PUBLIC	BAD_WIND03_CLOSE	; ステータス無表示ＣＬＯＳＥ

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_MUSYA_MAIN:NEAR	; 武者修行メイン
EXTRN	KEIKEN_PRINT:NEAR	; "経験値を得た。"

EXTRN	R_SCHO_DAYS:NEAR	; 成長の日次処理
EXTRN	R_BORTH_DAY:NEAR	; 誕生日の処理
EXTRN	R_BORTH_DAY_DR:NEAR	; 日数遅れの誕生日

EXTRN	R_ARBEIT_RUN:NEAR	; アルバイト実行
EXTRN	R_ARBEIT_SRT:NEAR	; アルバイトスタート
EXTRN	R_ARBEIT_UPD:NEAR	; アルバイト決算

EXTRN	R_KYUSOK_SRT:NEAR	; 休息スタート
EXTRN	R_KYUSOK_RUN:NEAR	; 休息実行
EXTRN	R_KYUSOK_UPD:NEAR	; 休息決算

EXTRN	R_GAKUMO_RUN:NEAR	; 学問実行
EXTRN	R_GAKUMO_SRT:NEAR	; 学問スタート
EXTRN	R_GAKUMO_UPD:NEAR	; 学問決算

EXTRN	R_BUGEI_RUN:NEAR	; 武芸実行
EXTRN	R_BUGEI_SRT:NEAR	; 武芸スタート
EXTRN	R_BUGEI_UPD:NEAR	; 武芸決算

EXTRN	R_REIHOU_RUN:NEAR	; 礼法実行
EXTRN	R_REIHOU_SRT:NEAR	; 礼法スタート
EXTRN	R_REIHOU_UPD:NEAR	; 礼法決算

EXTRN	R_BACANS_MAIN:NEAR	; バカンス実行
EXTRN	R_MS_BACANCE:NEAR	; バカンス時メッセージ

EXTRN	WIDMTRX_INIT:NEAR	; WINDOWS/マトリックス初期処理
EXTRN	WIDMTRX_FORMAT:NEAR	; WINDOWS/マトリックステーブルフォーマット
EXTRN	WIDMTRX_ASSIGN:NEAR	; WINDOWS/マトリックステーブルアサイン
EXTRN	WIDMTRX_OPEN:NEAR	; WINDOWS/マトリックスＯＰＥＮ
EXTRN	WIDMTRX_SET:NEAR	; WINDOWS/マトリックスセット
EXTRN	WIDMTRX_GET:NEAR	; WINDOWS/マトリックスＧＥＴ
EXTRN	WIDMTRX_CLOSE:NEAR	; WINDOWS/マトリックスＣＬＯＳＥ

EXTRN	WIDCLEN_INIT:NEAR	; WINDOWS/カレンダー・初期処理
EXTRN	WIDCLEN_SET:NEAR	; WINDOWS/カレンダー・時間設定
EXTRN	WIDCLEN_SHOW:NEAR	; WINDOWS/カレンダー・再表示
EXTRN	WIDCLEN_UDATE:NEAR	; WINDOWS/カレンダー・更新処理
EXTRN	WIDCLEN_GET:NEAR	; WINDOWS/カレンダー・読み取り処理
EXTRN	WIDCLEN_U_AD:NEAR	; WINDOWS/カレンダー・日付加算計算

EXTRN	WIDPROP_INIT:NEAR	; WINDOWS/プロポ・ウインドウ初期処理
EXTRN	WIDPROP_ALL:NEAR	; WINDOWS/プロポ・ウインドウ全表示
EXTRN	WIDPROP_OPEN:NEAR	; WINDOWS/プロポ・ウインドウＯＰＥＮ
EXTRN	WIDPROP_CLOSE:NEAR	; WINDOWS/プロポ・ウインドウＣＬＯＳＥ

EXTRN	WIDHED_D_HP:NEAR	; WINDOWS/ヘッダ・ＨＰ表示

EXTRN	WIDTXT_INIT:NEAR	; WINDOWS/テキストウインドウ初期処理
EXTRN	WIDTXT:NEAR		; WINDOWS/テキストウインドウ
EXTRN	WIDTXT_OPEN:NEAR	; WINDOWS/テキストウインドウＯＰＥＮ
EXTRN	WIDTXT_CLOSE:NEAR	; WINDOWS/テキストウインドウＣＬＯＳＥ
EXTRN	WIDTXT_RELOC:NEAR	; WINDOWS/テキストウインドウ位置変更

EXTRN	WIDDSP_SV_MN:NEAR	; WINDOWS/ｍｉｎｉステータス退避
EXTRN	WIDDSP_LD_MN:NEAR	; WINDOWS/ｍｉｎｉステータス復元

EXTRN	WIDDSP_SV_F:NEAR	; WINDOWS/画面フル退避
EXTRN	WIDDSP_LD_F:NEAR	; WINDOWS/画面フル復元

EXTRN	WIDFRM_BACALD:NEAR	; WINDOWS/バカンス部分復元
EXTRN	WIDFRM_BACASV:NEAR	; WINDOWS/バカンス部分退避

EXTRN	WIDCCT_INIT:NEAR	; WINDOWS/キャラクタ初期処理
EXTRN	WIDCCT_OPEN:NEAR	; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR	; WINDOWS/キャラクタクローズ
EXTRN	WIDCCT_CHANGE:NEAR	; WINDOWS/キャラクタチェンジ

EXTRN	WIDFRM_MAIN_HED:NEAR	; WINDOWS/フレーム・メイン・ヘッダ再表示

EXTRN	WID_GIRL_INIT:NEAR	; WINDOWS/ＧＩＲＬウインドウ初期処理
EXTRN	WID_GIRL:NEAR		; WINDOWS/ＧＩＲＬウインドウ
EXTRN	WID_GIRL_BORTH:NEAR	; WINDOWS/ＧＩＲＬウインドウ成長
EXTRN	WID_GIRL_KIGAE:NEAR	; WINDOWS/ＧＩＲＬウインドウ着替え

EXTRN	WIDDSP_ALG:NEAR		; WINDOWS/季節アナログ設定
EXTRN	WIDFRM_MAIN:NEAR	; WINDOWS/フレーム・メイン

EXTRN	PT_FREAM:NEAR		; メインフレーム
EXTRN	WID_MBG_DISP:NEAR	; WINDOWS/メインＢＧウインドウ表示
EXTRN	WIDBTN_OPEN:NEAR	; WINDOWS/ボタンオープン

EXTRN	WIDEVNT_STOP_W:NEAR	; WINDOWS/行いイベントＳＴＯＰ
EXTRN	WIDEVNT_CONT_W:NEAR	; WINDOWS/行いイベントＣＯＮＴ

EXTRN	WIDFACE_OPEN_G:NEAR	; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＯＰＥＮ
EXTRN	WIDFACE_CLOSE_G:NEAR	; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＣＬＯＳＥ
EXTRN	WIDFACE_PUT_G:NEAR	; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

EXTRN	R_SR_SR_KAKO:NEAR	; "「"
EXTRN	R_SR_SR_KOKA:NEAR	; "」"

EXTRN	R_SR_PRICE:NEAR		; 通貨表示
EXTRN	R_SR_IDSTR:NEAR		; ＩＤ文字列表示
EXTRN	R_SR_POINT:NEAR		; ポイント表示
EXTRN	R_SR_WIDSTR:NEAR	; 文字列表示

EXTRN	R_SR_DATE_NOW:NEAR	; 本日の日付
EXTRN	R_SR_SR_LF:NEAR		; 改行
EXTRN	R_SR_SR_DESU:NEAR	; "です"
EXTRN	R_SR_SR_POTU:NEAR	; "・"
EXTRN	R_SR_YOIDESUKA:NEAR	; よいですか

EXTRN	MUSIC_KOSODATE:NEAR	; 子育てのテーマ

;*;EXTRN DKCWID:NEAR		; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;EXTRN DKCMMD:NEAR		; メッセージ突入モード

EXTRN	TKRSET:NEAR		; 台詞改行のカウンタリセット
EXTRN	US_WAIT:NEAR		; ユーザ待ち


; ****************************************************
;	スケジュール実行
; ****************************************************

R_PROG	PROC	NEAR
	MOV	OLD_ID_SET,ID_00	; 前回のスケジュール項目(ｸﾘｱ)
	MOV	CX,SCD_WEEK_CNT		; スケジュールカウンタ
R_PROG_LOOP:				;
	PUSH	CX			;
	CALL	R_PROG_INIT		; 初期処理

	CALL	R_PROG_MAIN		; スケジュールメイン

	INC	SCD_NOW_LINE		; 現在の行
	POP	CX			;
	LOOP	R_PROG_LOOP		;

	CMP	OLD_ID_SET,ID_68	; 項目 武者修行
	JNE	R_PROG_32		;

	CALL	MYSYA_END		; 武者修行は終わった
R_PROG_32:				;

	CMP	OLD_ID_SET,ID_71	; 項目 バカンス
	JNE	R_PROG_33		;
	CALL	BACANCE_END		; バカンスは終わった
R_PROG_33:				;

	MOV	OLD_ID_SET,ID_00	; 前回のスケジュール項目(ｸﾘｱ)

R_PROG_ALL_END:
	RET
R_PROG	ENDP


; ****************************************************
;	初期処理
; ****************************************************

R_PROG_INIT	PROC	NEAR
	MOVX	WDPCLM,SCHED_CNT_X	; マトリックス横数
	MOVX	WDPLIN,SCHED_CNT_Y	; マトリックス行数

	MOV	SI,OFFSET HED_MSG	; 項目
	MOV	DX,OFFSET SCHED_FORM_LINE ; 表示フォーマット・長さ
	MOV	BX,OFFSET SCHED_FORM_LTYP ; 表示フォーマット・タイプ
	CALL	WIDMTRX_FORMAT		; マトリックステーブルフォーマット

	MOV	DX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,WIDOFS_SCHED		; スケジュールテーブル
	MOV	BX,ES:[DI]		; スケジュール０
	CALL	WIDMTRX_ASSIGN		; マトリックステーブルアサイン

	RET
R_PROG_INIT	ENDP


; ****************************************************
;	スケジュールメイン
; ****************************************************

R_PROG_MAIN	PROC	NEAR
	MOVX	TODAY_LINE,SCD_NOW_LINE	; 今日のスケジュール欄

	CALL	TODAY_GET		; 本日の予定

	CMP	R_KOUMKU,ID_68		; 項目 武者修行	
	JNE	R_PROG_MAIN_12		;

	CMP	OLD_ID_SET,ID_68	; 前回は武者修行？
	JNE	R_PROG_MAIN_03		;
	MOV	DX,1			; 継続か？ 1=継続
	JMP	R_PROG_MAIN_04		;
R_PROG_MAIN_03:				;
	CMP	OLD_ID_SET,ID_71	; 前回はバカンス？
	JNE	R_PROG_MAIN_033		;
	CALL	BACANCE_END		; バカンスは終わった
R_PROG_MAIN_033:			;
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
	MOV	DX,0			; 継続か？ 0=通常
R_PROG_MAIN_04:				;
	CALL	R_MUSYA_MAIN		; 武者修行メイン
	CMP	DX,1			; 1=武者修行中に誕生日があった
	JNE	R_PROG_MAIN_11		;
	CMP	AX,1			; 冒険の成功フラグ 1=成功している
	JNE	R_PROG_MAIN_10		;
	CALL	MYSYA_END		; 武者修行は終わった
R_PROG_MAIN_10:				;
	CALL	R_BORTH_DAY_DR		; 日数遅れの誕生日
	MOV	OLD_ID_SET,ID_00	; 前回のスケジュール項目(ｸﾘｱ)
	JMP	R_PROG_MAIN_EXIT	;
R_PROG_MAIN_11:				;
	CMP	AX,1			; 冒険の成功フラグ 1=成功している
	JNE	R_PROG_MAIN_111		;
	MOV	OLD_ID_SET,ID_68	; 項目 武者修行	
	JMP	R_PROG_MAIN_EXIT	;
R_PROG_MAIN_111:			;
	MOV	OLD_ID_SET,ID_00	; 前回のスケジュール項目(ｸﾘｱ)
	JMP	R_PROG_MAIN_EXIT	;



R_PROG_MAIN_12:				;
	CMP	R_KOUMKU,ID_71		; 項目 バカンス	
	JNE	R_PROG_MAIN_22		;

	CMP	OLD_ID_SET,ID_71	; 前回はバカンス？
	JNE	R_PROG_MAIN_13		;
	MOV	DX,1			; 1=継続
	JMP	R_PROG_MAIN_14		;
R_PROG_MAIN_13:				;
	CMP	OLD_ID_SET,ID_68	; 前回は武者修行？
	JNE	R_PROG_MAIN_133		;
	CALL	MYSYA_END		; 武者修行は終わった
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
R_PROG_MAIN_133:			;
	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避
	CALL	BACANCE_START		; バカンス・スタート
	MOV	CX,TM_SEASON		; 季節(1:春,2:夏,3:秋,4:冬)
	MOV	DX,0			; 0=通常
R_PROG_MAIN_14:				;

	CALL	R_BACANS_MAIN		; バカンス実行
	MOV	BACAN_OLD_SEASON,CX	; バカンスだった季節

	CMP	AX,1			; 1=金無しバカンス中止
	JE	R_PROG_MAIN_20		;
	CMP	DX,1			; 1=バカンス中に誕生日があった
	JNE	R_PROG_MAIN_21		;

	CALL	BACANCE_END		; バカンスは終わった
	CALL	R_BORTH_DAY_DR		; 日数遅れの誕生日
	MOV	OLD_ID_SET,ID_00	; 前回のスケジュール項目(ｸﾘｱ)
	JMP	R_PROG_MAIN_EXIT	;

R_PROG_MAIN_20:				;
	CALL	NO_MONEY_BACA		; 金無しバカンス中止
	MOV	OLD_ID_SET,ID_00	; 前回のスケジュール項目(ｸﾘｱ)
	JMP	R_PROG_MAIN_EXIT	;

R_PROG_MAIN_21:				;
	MOV	OLD_ID_SET,ID_71	; 項目 バカンス	
	JMP	R_PROG_MAIN_EXIT	;


R_PROG_MAIN_22:				;
	CMP	OLD_ID_SET,ID_68	; 項目 武者修行
	JNE	R_PROG_MAIN_32		;
	CALL	MYSYA_END		; 武者修行は終わった
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
R_PROG_MAIN_32:				;
	CMP	OLD_ID_SET,ID_71	; 項目 バカンス
	JNE	R_PROG_MAIN_33		;
	CALL	BACANCE_END		; バカンスは終わった
R_PROG_MAIN_33:				;

	CALL	PROG_SRT		; スケジュール開始に当たって

	CALL	WIDDSP_SV_MN		; WINDOWS/ｍｉｎｉステータス退避
	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	MOV	SCED_FREE_FLAG,0	; スケジュール割愛フラグ

;*;	CALL	WIDFACE_OPEN_G		; ＧＩＲＬｳｲﾝドｳ成功失敗ＯＰＥＮ

	MOV	DAY_COUNTER,0		; 日数カウンタ
R_PROG_MAIN_LOOP:
	CMPX	DAY_COUNTER,R_NISSU	; 日数カウンタ
	JGE	R_PROG_MAIN_LOOP_END	;

	INC	DAY_COUNTER		; 日数カウンタ
	CALL	TIME_UPDATE		; 日付更新

	CALL	TODAY_WORK_MSG		; 本日の予定の発表

	CALL	PROG_RUN		; 予定の実行

	CALL	R_SCHO_DAYS		; 成長の日次処理

	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
	CALL	WIDFRM_MAIN_HED		; WINDOWS/フレーム・メイン・ヘッダ再表

	CMP	MY_GIRL_BORTH_F,1	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	JNE	R_PROG_MAIN_NEXT	;

;*;	CALL	WIDFACE_CLOSE_G		; ＧＩＲＬｳｲﾝドｳ成功失敗ＣＬＯＳＥ
	CALL	EVWID_CLOSE		; イベントウインドウＣＬＯＳＥ
	CALL	R_BORTH_DAY_AREA	; 誕生日の会場
	CALL	EVWID_OPEN		; イベントウインドウＯＰＥＮ
;*;	CALL	WIDFACE_OPEN_G		; ＧＩＲＬｳｲﾝドｳ成功失敗ＯＰＥＮ

R_PROG_MAIN_NEXT:
	JMP	R_PROG_MAIN_LOOP

R_PROG_MAIN_LOOP_END:
;*;	CALL	WIDFACE_CLOSE_G		; ＧＩＲＬｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
	CALL	WIDDSP_LD_MN		; WINDOWS/ｍｉｎｉステータス復元

	CALL	SHOW_KESSAN		; １０日分の決算

	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
	CALL	WIDFRM_MAIN_HED		; WINDOWS/フレーム・メイン・ヘッダ再表

	MOVX	OLD_ID_SET,R_KOUMKU	; 前回のスケジュール項目
R_PROG_MAIN_EXIT:
	RET
R_PROG_MAIN	ENDP


; ****************************************************
;	誕生日の会場
; ****************************************************

R_BORTH_DAY_AREA	PROC	NEAR
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
	CALL	WIDDSP_LD_MN		; WINDOWS/ｍｉｎｉステータス復元

	CALL	R_BORTH_DAY		; 誕生日の処理

	CALL	WIDDSP_SV_MN		; WINDOWS/ｍｉｎｉステータス退避
	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	RET
R_BORTH_DAY_AREA	ENDP


; ****************************************************
;	イベントウインドウＯＰＥＮ
; ****************************************************

EVWID_OPEN	PROC	NEAR
	CALL	WIDEVNT_CONT_W		; WINDOWS/行いイベントＣＯＮＴ
	RET
EVWID_OPEN	ENDP


; ****************************************************
;	イベントウインドウＣＬＯＳＥ
; ****************************************************

EVWID_CLOSE	PROC	NEAR
	CALL	WIDEVNT_STOP_W		; WINDOWS/行いイベントＳＴＯＰ
	RET
EVWID_CLOSE	ENDP


; ****************************************************
;	スケジュール開始に当たって
; ****************************************************

PROG_SRT	PROC	NEAR
	PR_CLS

	MOV	AX,R_KOUMKU		; 項目

	CMP	AX,ID_65		; 武芸
	JE	PROG_SRT_BUGE		;
	CMP	AX,ID_66		; 学問		
	JE	PROG_SRT_GAKU		;
	CMP	AX,ID_67		; 礼法
	JE	PROG_SRT_REIH		;
	CMP	AX,ID_68		; 武者修行	
	JE	PROG_SRT_MUSY		;
	CMP	AX,ID_69		; 休息		
	JE	PROG_SRT_KYUS		;
	CMP	AX,ID_71		; バカンス	
	JE	PROG_SRT_BACA		;
	CMP	AX,ID_70		; アルバイト
	JE	PROG_SRT_ARBA		;

;*STP*;	PR_CLS
	PR_TXT	"シゴトガナイヨー"
	RET
PROG_SRT_BUGE:				; 武芸
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
	CALL	R_BUGEI_SRT		; 武芸スタート
	MUSIC	KYOKU_SYUGYO		; 修行
	RET
PROG_SRT_GAKU:				; 学問
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
	CALL	R_GAKUMO_SRT		; 学問スタート
	MUSIC	KYOKU_SYUGYO		; 修行
	RET
PROG_SRT_REIH:				; 礼法
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
	CALL	R_REIHOU_SRT		; 礼法スタート
	MUSIC	KYOKU_SYUGYO		; 修行
	RET
PROG_SRT_MUSY:				; 武者修行
	RET
PROG_SRT_KYUS:				; 休息
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
	CALL	R_KYUSOK_SRT		; 休息スタート
	RET
PROG_SRT_BACA:				; バカンス
	RET
PROG_SRT_ARBA:				; アルバイト
	CALL	R_ARBEIT_SRT		; アルバイトスタート
	RET
PROG_SRT	ENDP


; ****************************************************
;	予定の実行
;	-I- R_KOUMKU : 項目
; ****************************************************

PROG_RUN	PROC	NEAR
	MOV	AX,R_KOUMKU		; 項目

	CMP	AX,ID_65		; 武芸
	JE	PROG_RUN_BUGE		;
	CMP	AX,ID_66		; 学問		
	JE	PROG_RUN_GAKU		;
	CMP	AX,ID_67		; 礼法
	JE	PROG_RUN_REIH		;
	CMP	AX,ID_68		; 武者修行	
	JE	PROG_RUN_MUSY		;
	CMP	AX,ID_69		; 休息		
	JE	PROG_RUN_KYUS		;
	CMP	AX,ID_71		; バカンス	
	JE	PROG_RUN_BACA		;
	CMP	AX,ID_70		; アルバイト
	JE	PROG_RUN_ARBA		;

;*STP*;	PR_CLS
	PR_TXT	"シゴトガナイヨー"
	RET
PROG_RUN_BUGE:				; 武芸
	CALL	R_BUGEI_RUN		; 武芸実行
	RET
PROG_RUN_GAKU:				; 学問
	CALL	R_GAKUMO_RUN		; 学問実行
	RET
PROG_RUN_REIH:				; 礼法
	CALL	R_REIHOU_RUN		; 礼法実行
	RET
PROG_RUN_MUSY:				; 武者修行
	RET
PROG_RUN_KYUS:				; 休息
	CALL	R_KYUSOK_RUN		; 休息実行
	RET
PROG_RUN_BACA:				; バカンス
	RET
PROG_RUN_ARBA:				; アルバイト
	CALL	R_ARBEIT_RUN		; アルバイト実行
	RET
PROG_RUN	ENDP


; ****************************************************
;	１０日分の決算
;	-I- R_KOUMKU   : 項目
;	    R_NAISTR   : 内容文字列
;	    R_NAIYOU   : 内容値
;	    R_NYUKIN   : 入金
;	    R_SYUTSU   : 出金
; ****************************************************

SHOW_KESSAN	PROC	NEAR
	CALL	WEEK_SET		; 予定表・書き換え

	MOV	AX,R_KOUMKU		; 項目

	CMP	AX,ID_65		; 武芸
	JE	SHOW_KESSAN_BUGE	;
	CMP	AX,ID_66		; 学問		
	JE	SHOW_KESSAN_GAKU	;
	CMP	AX,ID_67		; 礼法
	JE	SHOW_KESSAN_REIH	;
	CMP	AX,ID_68		; 武者修行	
	JE	SHOW_KESSAN_MUSY	;
	CMP	AX,ID_69		; 休息		
	JE	SHOW_KESSAN_KYUS	;
	CMP	AX,ID_71		; バカンス	
	JE	SHOW_KESSAN_BACA	;
	CMP	AX,ID_70		; アルバイト
	JE	SHOW_KESSAN_ARBA	;

	PR_TXT	"シゴトー！"
	RET
SHOW_KESSAN_BUGE:				; 武芸
	CALL	R_BUGEI_UPD			; 武芸決算
	RET
SHOW_KESSAN_GAKU:				; 学問		
	CALL	R_GAKUMO_UPD			; 学問決算
	RET
SHOW_KESSAN_REIH:				; 礼法
	CALL	R_REIHOU_UPD			; 礼法決算
	RET
SHOW_KESSAN_MUSY:				; 武者修行	
	RET
SHOW_KESSAN_KYUS:				; 休息		
	CALL	R_KYUSOK_UPD			; 休息決算
	RET
SHOW_KESSAN_BACA:				; バカンス	
	RET
SHOW_KESSAN_ARBA:				; アルバイト
	CALL	R_ARBEIT_UPD			; アルバイト決算
	RET
SHOW_KESSAN	ENDP



; ****************************************************
;	予定表・書き換え
;	-I- TODAY_LINE : 今日のスケジュール欄
;	    R_KOUMKU   : 項目
;	    R_NAISTR   : 内容文字列
;	    R_NAIYOU   : 内容値
;	    R_NYUKIN   : 入金
;	    R_SYUTSU   : 出金
;	    R_NISSU    : 日数
; ****************************************************

WEEK_SET	PROC	NEAR
	MOVX	WDPLIN,TODAY_LINE	; 今日のスケジュール欄

	MOV	WDPCLM,2		; マトリックス横数
	MOVX	WDVAL,R_NYUKIN		; 入金
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDPCLM,3		; マトリックス横数
	MOVX	WDVAL,R_SYUTSU		; 出金
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDPCLM,4		; マトリックス横数
	MOVX	WDVAL,R_KOUMKU		; 項目
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDPCLM,5		; マトリックス横数
	MOVX	WDVAL,R_NAISTR		; 内容文字列
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDPCLM,6		; マトリックス横数
	MOVX	WDVAL,R_NAIYOU		; 内容値
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDPCLM,7		; マトリックス横数
	MOVX	WDVAL,R_NISSU		; 日数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	RET
WEEK_SET	ENDP


; ****************************************************
;	本日の予定
;	-I- TODAY_LINE : 今日のスケジュール欄
;	-O- R_KOUMKU   : 項目
;	    R_NAISTR   : 内容文字列
;	    R_NAIYOU   : 内容値
;	    R_NYUKIN   : 入金
;	    R_SYUTSU   : 出金
;	    R_NISSU    : 日数
; ****************************************************

TODAY_GET	PROC	NEAR
	MOVX	WDPLIN,TODAY_LINE	; 今日のスケジュール欄

	MOV	WDPCLM,2		; マトリックス横数
	CALL	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
	MOVX	R_NYUKIN,WDVAL		; 入金

	MOV	WDPCLM,3		; マトリックス横数
	CALL	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
	MOVX	R_SYUTSU,WDVAL		; 出金

	MOV	WDPCLM,4		; マトリックス横数
	CALL	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
	MOVX	R_KOUMKU,WDVAL		; 項目

	MOV	WDPCLM,5		; マトリックス横数
	CALL	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
	MOVX	R_NAISTR,WDVAL		; 内容文字列

	MOV	WDPCLM,6		; マトリックス横数
	CALL	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
	MOVX	R_NAIYOU,WDVAL		; 内容値

	MOV	WDPCLM,7		; マトリックス横数
	CALL	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
	MOVX	R_NISSU,WDVAL		; 日数

	MOV	WDPCLM,8		; マトリックス横数
	CALL	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
	MOVX	R_HEIJITSU,WDVAL	; 平日

	RET
TODAY_GET	ENDP


; ****************************************************
;	本日の予定の発表
;	-I- R_KOUMKU   : 項目
;	    R_NAISTR   : 内容文字列
;	    R_NAIYOU   : 内容値
;	    R_NYUKIN   : 入金
;	    R_SYUTSU   : 出金
;	    SCED_FREE_FLAG : スケジュール流れたフラグ 1=スケジュール流れた
; ****************************************************

TODAY_WORK_MSG	PROC	NEAR
	CALL	TKRSET			; 台詞改行のカウンタリセット
	PR_CLS
	CALL	R_SR_DATE_NOW		; 本日の日付
;*;	CMP	SCED_FREE_FLAG,1	; 1=スケジュール流れた
;*;	JE	TODAY_WORK_MSG_EXIT	;
;*;	PR_LF
;*;	MOV	DX,R_KOUMKU		; 項目
;*;	CALL	R_SR_IDSTR		; ＩＤ文字列表示
TODAY_WORK_MSG_EXIT:
	RET
TODAY_WORK_MSG	ENDP


; ****************************************************
;	メインウインドウ復帰
; ****************************************************

R_MAIN_WINDOW_DSP	PROC	NEAR
	CALL	MAIN_WINDOW_DSP		; メインウインドウ復帰
	RET
R_MAIN_WINDOW_DSP	ENDP


; ****************************************************
;	メインウインドウ復帰
; ****************************************************

MAIN_WINDOW_DSP	PROC	NEAR

	; 裏でフレーム描いて

;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALL	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択

	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	PT_FREAM		; メインフレーム
	CALL	WID_MBG_DISP		; WINDOWS/メインＢＧウインドウ表示
	CALL	WIDCLEN_SET		; WINDOWS/カレンダー・時間設定
	CALL	WID_GIRL		; WINDOWS/ＧＩＲＬウインドウ

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALL	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択

	; 表へ転送

	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	CALL	BLACK			;
	CALL	WIDDSP_LD_F		; WINDOWS/復元 ＶＲＡＭ１－＞ＶＲＡＭ０
	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定

	; 小物の表示

	CALL	WIDBTN_OPEN		; WINDOWS/ボタンオープン
	MOV	AX,0			; ヘッダー番号
	MOV	DX,3			; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン
	CALL	WIDPROP_OPEN		; WINDOWS/プロポ・ウインドウＯＰＥＮ

	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更

	; 娘の表示

	RET
MAIN_WINDOW_DSP	ENDP


; ****************************************************
;	金無しバカンス中止
; ****************************************************

NO_MONEY_BACA	PROC	NEAR
	PUSH	AX			;
	MOV	BACA_BORTH_F,0		; 1=バカンス中に誕生日があった

	CMP	OLD_ID_SET,ID_71	; 前回はバカンス？
	JNE	NO_MONEY_BACA_77	;
	CALL	BLACK			; 黒
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定
	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
	CALL	WIDCLEN_SHOW		; WINDOWS/カレンダー・再表示
	CALL	WIDHED_D_HP		; WINDOWS/ヘッダ・ＨＰ表示
	PR_LF
	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_NAISTR		;
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"
NO_MONEY_BACA_77:
	PR_TXT	"@お金が足りません@しくしく・・・"
	CALL	R_SR_YOIDESUKA		; よいですか

	CALL	BAD_WINDOW_OPEN		; 病気ステータスウインドウＯＰＥＮ

	MOV	DAY_COUNTER,0		; 日数カウンタ
NO_MONEY_BACA_LOOP2:			;
	CMPX	DAY_COUNTER,R_NISSU	; 日数カウンタ
	JGE	NO_MONEY_BACA_LOOP2_END	;
	INC	DAY_COUNTER		; 日数カウンタ
	CALL	WIDCLEN_UDATE		; WINDOWS/カレンダー・更新処理
	PR_LF
	CALL	TKRSET			; 台詞改行のカウンタリセット
	CALL	R_SR_DATE_NOW		; 本日の日付
	CALL	R_SCHO_DAYS		; 成長の日次処理
	CMP	MY_GIRL_BORTH_F,1	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	JNE	NO_MONEY_BACA_NEXT2	;

	CALL	BAD_WINDOW_CLOSE	; 病気ステータスウインドウＣＬＯＳＥ

	CALL	R_BORTH_DAY		; 誕生日の処理

	CALL	BAD_WINDOW_OPEN		; 病気ステータスウインドウＯＰＥＮ

NO_MONEY_BACA_NEXT2:			;
	JMP	NO_MONEY_BACA_LOOP2	;
NO_MONEY_BACA_LOOP2_END:

	CALL	BAD_WINDOW_CLOSE	; 病気ステータスウインドウＣＬＯＳＥ

	MOV	DX,0			;
	POP	AX			;
	RET
NO_MONEY_BACA	ENDP


; ****************************************************
;	バカンス・スタート
; ****************************************************

BACANCE_START	PROC	NEAR
	WD_CMP	ID_75,R_NAISTR		; 春のバカンス
	JE	BACANCE_START_1		;
	WD_CMP	ID_76,R_NAISTR		; 夏のバカンス
	JE	BACANCE_START_2		;
	WD_CMP	ID_77,R_NAISTR		; 秋のバカンス
	JE	BACANCE_START_3		;

	MOV	CX,4			; 季節(1:春,2:夏,3:秋,4:冬)
	JMP	BACANCE_START_SET	;
BACANCE_START_1:
	MOV	CX,1			; 季節(1:春,2:夏,3:秋,4:冬)
	JMP	BACANCE_START_SET	;
BACANCE_START_2:
	MOV	CX,2			; 季節(1:春,2:夏,3:秋,4:冬)
	JMP	BACANCE_START_SET	;
BACANCE_START_3:
	MOV	CX,3			; 季節(1:春,2:夏,3:秋,4:冬)
	JMP	BACANCE_START_SET	;
BACANCE_START_SET:
	MOV	AX,1			; 1=開始
	CALL	R_MS_BACANCE		; バカンス時メッセージ
	RET
BACANCE_START	ENDP


; ****************************************************
;	バカンスは終わった
; ****************************************************

BACANCE_END	PROC	NEAR
	CALL	WIDFRM_BACALD		; WINDOWS/バカンス部分復元

	CALL	R_SR_YOIDESUKA		; よいですか

	MUSIC	KYOKU_F_O		; 音楽フェードアウト

	MOV	AX,40			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.

	CALL	BLACK			; 黒
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定
	CALL	WIDCLEN_SHOW		; WINDOWS/カレンダー・再表示
	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
	MOV	AX,0			; ヘッダー番号
	MOV	DX,3			; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン
	CALL	WIDPROP_OPEN		; WINDOWS/プロポ・ウインドウＯＰＥＮ
	CALL	WIDHED_D_HP		; WINDOWS/ヘッダ・ＨＰ表示

	CALL	TMVEWT			; V-SYNC timer end wait.

	CALL	MUSIC_KOSODATE		; 子育てのテーマ

	MOV	CX,BACAN_OLD_SEASON	; バカンスだった季節
	MOV	AX,2			; 2=終了
	CALL	R_MS_BACANCE		; バカンス時メッセージ

	RET
BACANCE_END	ENDP


; ****************************************************
;	武者修行は終わった
; ****************************************************

MYSYA_END	PROC	NEAR
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	KEIKEN_PRINT		; "経験値を得た。"
	CALL	R_SR_YOIDESUKA		; よいですか

	CALL	MAIN_WINDOW_DSP		; メインウインドウ復帰

	CALL	MUSIC_KOSODATE		; 子育てのテーマ
	RET
MYSYA_END	ENDP


; ****************************************************
;	日付更新
; ****************************************************

TIME_UPDATE	PROC	NEAR
	CALL	WIDCLEN_UDATE		; WINDOWS/カレンダー・更新処理
	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定
	RET
TIME_UPDATE	ENDP


; ****************************************************
;	病気ステータス無表示ＯＰＥＮ
; ****************************************************

BAD_WIND02_OPEN	PROC	NEAR
	CALL	HEDFLAG_READ		; ヘッダフラグ読み取り
	TEST	DX,FLAGS_BYOUKI		;bit12 : 病気化
	JZ	BAD_WIND02_OPEN_EXIT	;

	MOV	FLAG_BAD_WINDOW,1	; 病気ウインドウＯＰＥＮフラグ

	MOV	AX,1			; モードスイッチ 1=マッハ
	MOV	S_FUNC,32		; 32=マッハモード
	CALL	R_KEISAN		; 各計算処理
BAD_WIND02_OPEN_EXIT:
	RET
BAD_WIND02_OPEN	ENDP


; ****************************************************
;	病気ステータス無表示ＣＬＯＳＥ
; ****************************************************

BAD_WIND02_CLOSE	PROC	NEAR
	CMP	FLAG_BAD_WINDOW,1	; 病気ウインドウＯＰＥＮフラグ
	JNE	BAD_WIND02_CLOSE_EXIT	;

	MOV	AX,0			; モードスイッチ 0=ノーマル
	MOV	S_FUNC,32		; 32=マッハモード
	CALL	R_KEISAN		; 各計算処理
BAD_WIND02_CLOSE_EXIT:
	MOV	FLAG_BAD_WINDOW,0	; 病気ウインドウＯＰＥＮフラグ
	RET
BAD_WIND02_CLOSE	ENDP


; ****************************************************
;	ステータス無表示ＯＰＥＮ
; ****************************************************

BAD_WIND03_OPEN	PROC	NEAR
	MOV	AX,1			; モードスイッチ 1=マッハ
	MOV	S_FUNC,32		; 32=マッハモード
	CALL	R_KEISAN		; 各計算処理
	RET
BAD_WIND03_OPEN	ENDP


; ****************************************************
;	ステータス無表示ＣＬＯＳＥ
; ****************************************************

BAD_WIND03_CLOSE	PROC	NEAR
	MOV	AX,0			; モードスイッチ 0=ノーマル
	MOV	S_FUNC,32		; 32=マッハモード
	CALL	R_KEISAN		; 各計算処理
	RET
BAD_WIND03_CLOSE	ENDP


; ****************************************************
;	病気ステータスウインドウＯＰＥＮ
; ****************************************************

BAD_WINDOW_OPEN	PROC	NEAR
	CALL	HEDFLAG_READ		; ヘッダフラグ読み取り
	TEST	DX,FLAGS_BYOUKI		;bit12 : 病気化
	JZ	BAD_WINDOW_OPEN_EXIT	;

	MOV	FLAG_BAD_WINDOW,1	; 病気ウインドウＯＰＥＮフラグ

	CALL	WIDDSP_SV_MN		; WINDOWS/ｍｉｎｉステータス退避

	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYPEB	; オープンタイプ・病気
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

BAD_WINDOW_OPEN_EXIT:
	RET
BAD_WINDOW_OPEN	ENDP


; ****************************************************
;	病気ステータスウインドウＣＬＯＳＥ
; ****************************************************

BAD_WINDOW_CLOSE	PROC	NEAR
	CMP	FLAG_BAD_WINDOW,1	; 病気ウインドウＯＰＥＮフラグ
	JNE	BAD_WINDOW_CLOSE_EXIT	

	MOV	DX,CCT_OPEN_TYPEB	; オープンタイプ・病気
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ

	CALL	WIDDSP_LD_MN		; WINDOWS/ｍｉｎｉステータス復元
BAD_WINDOW_CLOSE_EXIT:
	MOV	FLAG_BAD_WINDOW,0	; 病気ウインドウＯＰＥＮフラグ
	RET
BAD_WINDOW_CLOSE	ENDP


; ****************************************************
;	ヘッダフラグ読み取り
;	-O- DX : フラグ
; ****************************************************

HEDFLAG_READ	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,0			; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41		; 41=ヘッダーフラグのＩ／Ｏ
	CALL	R_KEISAN		; 各計算処理
	RET
HEDFLAG_READ	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	SCED_FREE_FLAG		; スケジュール流れたフラグ

EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	SCD_NOW_LINE:WORD	; 現在の行
EXTRN	SCD_WEEK_CNT:WORD	; スケジュールカウンタ

EXTRN	SCD_DATE:BYTE		; スケジュール時間

EXTRN	SCHED_CNT_X:WORD	; マトリックス横数
EXTRN	SCHED_CNT_Y:WORD	; マトリックス行数

EXTRN	SCHED_FORM_LINE:WORD	; 表示フォーマット・長さ
EXTRN	SCHED_FORM_LTYP:WORD	; 表示フォーマット・タイプ

EXTRN	WDPCLM:WORD		; WINDOWS/順序
EXTRN	WDPLIN:WORD		; WINDOWS/行

EXTRN	TM_SEASON:WORD		; (now)季節（1:春,2:夏,3:秋,4:冬）

EXTRN	R_KOUMKU:WORD		; 項目
EXTRN	R_NAISTR:WORD		; 内容文字列
EXTRN	R_NAIYOU:WORD		; 内容値
EXTRN	R_NYUKIN:WORD		; 入金
EXTRN	R_SYUTSU:WORD		; 出金
EXTRN	R_NISSU:WORD		; 日数
EXTRN	R_HEIJITSU:WORD		; 平日

EXTRN	MY_GIRL_BORTH_F:WORD	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ(R_SEICHO.ASM)

TODAY_LINE	DW	0		; 今日のスケジュール欄

DAY_COUNTER	DW	0		; 日数カウンタ

OLD_ID_SET	DW	0		; 前回のスケジュール項目

BACA_BORTH_F	DW	0		; バカンス中誕生日フラグ
					; 1=バカンス中に誕生日があった

SCED_FREE_FLAG	DW	0		; スケジュール流れたフラグ
					; 1=スケジュール流れた

BACAN_OLD_SEASON DW	0		; バカンスだった季節

HED_MSG		DB	0,0		; 項目（ダミー）

FLAG_BAD_WINDOW	DW	0		; 病気ウインドウＯＰＥＮフラグ

DATA	ENDS

	END
;
;	end of "R_PROG.ASM"
;
