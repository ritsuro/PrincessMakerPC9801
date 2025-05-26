; "KOSOMAIN.ASM" PC-9801UV11 make by R.H 1991/01/08
;
;
;	ゲームの大まかな流れ
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	KOSO.INC
INCLUDE	KOSO2.INC
INCLUDE	WINDOW.INC
INCLUDE	..\KOSO6\KYOKU.INC

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

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	KOSOMAIN		; ゲームの大まかな流れ

EXTRN	DBG_INTER:NEAR		; デバックメニュー

EXTRN	TBLSEGRET:NEAR		; 各セグメント指定を初期状態にする

EXTRN	R_MAIN_WINDOW_DSP:NEAR	; メインウインドウ復帰

EXTRN	R_SCHO_MONTH:NEAR	; 成長の月次処理

EXTRN	WIDBTN_INIT:NEAR	; WINDOWS/ボタン初期処理
EXTRN	WIDBTN_OPEN:NEAR	; WINDOWS/ボタンオープン
EXTRN	WIDBTN_CLOSE:NEAR	; WINDOWS/ボタンクローズ
EXTRN	WIDBTN_TOUCH:NEAR	; WINDOWS/ボタンタッチチェック

EXTRN	WIDFRM_MAIN_LDA:NEAR	; WINDOWS/フレーム・ロード後
;*;EXTRN WIDFRM_MAIN_RET:NEAR	; WINDOWS/フレーム・復帰

EXTRN	AUTO_DEMO_STOP:NEAR	; オート実行ストップ

EXTRN	WIDPROP_INIT:NEAR		; WINDOWS/プロポ・ウインドウ初期処理
EXTRN	WIDPROP_ALL:NEAR		; WINDOWS/プロポ・ウインドウ全表示
EXTRN	WIDPROP_OPEN:NEAR		; WINDOWS/プロポ・ウインドウＯＰＥＮ
EXTRN	WIDPROP_CLOSE:NEAR		; WINDOWS/プロポ・ウインドウＣＬＯＳＥ

EXTRN	R_SOUBI:NEAR		; 装備
EXTRN	R_KAIWA:NEAR		; 娘との会話
EXTRN	R_KAIMON:NEAR		; 買物
EXTRN	R_SCHED:NEAR		; スケジュール
EXTRN	R_PROG:NEAR		; スケジュール実行
EXTRN	R_SYUKAK_RUN:NEAR	; 収穫祭実行
EXTRN	R_UWASA:NEAR		; 町の人がうわさする
EXTRN	R_OHSAMA:NEAR		; 王様との会見
EXTRN	R_ENDING:NEAR		; エンディング

EXTRN	R_SR_POINT:NEAR		; ポイント表示

EXTRN	MUSIC_KOSODATE:NEAR	; 子育てのテーマ

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス

EXTRN	MSWWAT:NEAR		; カーソルボタン待ち

EXTRN	MUSINI:NEAR		; マウスの初期化
EXTRN	MUSSTP:NEAR		; マウスの終了

EXTRN	KYBSRT:NEAR		; keybord start.
EXTRN	KYBEND:NEAR		; keybord end.

EXTRN	US_WAIT:NEAR		; ユーザ待ち


; ****************************************************
;	ゲームの大まかな流れ
; ****************************************************

KOSOMAIN	PROC	NEAR
;*;	CALL	VRMCLR
;*;	EXTRN	FAR_CONTEST_MAIN:FAR
;*;	CALL	FAR_CONTEST_MAIN
;*;	RET
KOSOMAIN_LOOP_INIT:			;

KOSOMAIN_LOOP:				;
	CALL	TBLSEGRET		; 各セグメント指定を初期状態にする

	CALL	MUSIC_KOSODATE		; 子育てのテーマ

	CMP	DEMO_MODE_SYU,66	; デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ
	JE	KOSOMAIN_1		;

	JMP	KOSOMAIN_2		;

KOSOMAIN_1:				;
;*;	PRF	"収穫祭"
	CALL	R_SYUKAK_RUN		; 収穫祭実行
	CALL	R_SCHO_MONTH		; 成長の月次処理

	CMP	DEMO_MODE_SYU,66	; デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ
	JE	KOSOMAIN_1		;

	JMP	KOSOMAIN_NEXT		;

KOSOMAIN_2:				;
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
	CALL	IKKAGETU		; １ヶ月の最初
	CMP	CMND_NUM,2		; 2=データロード直後
	JE	KOSOMAIN_LOAD		;

	CMP	UNNMEI_DAYS_FLG,1	; 1=１ヶ月前
	JNE	KOSOMAIN_222		;
	CALL	AUTO_DEMO_STOP		; オート実行ストップ
KOSOMAIN_222:				;

	CMP	CMND_NUM,98		; 98=運命の日
	JE	KOSOMAIN_UNMEI		;

	CMP	CMND_NUM,99		; 99=強制終了
	JE	KOSOMAIN_LOOP_END	;

	CMP	CMND_NUM,1		; 1=スケジュール
	JNE	KOSOMAIN_3		;

	CMP	FLG_SYUKAKU,1		; フラグ・収穫祭の準備
	JMPEQ	KOSOMAIN_1		;

	CALL	SCHEDULE		; スケジュール
	JMP	KOSOMAIN_NEXT		;
KOSOMAIN_3:				;

KOSOMAIN_NEXT:
	JMP	KOSOMAIN_LOOP		;

KOSOMAIN_LOOP_END:
	CALL	DBG_INTER		; デバックメニュー
	CMP	EXIT_FLAG,1		; １＝強制終了
	JE	KOSOMAIN_EXIT		;
	JMP	KOSOMAIN_LOOP_INIT	;

KOSOMAIN_LOAD:				;
	CALL	WIDFRM_MAIN_LDA		; WINDOWS/フレーム・ロード後
;*;	CALL	WIDFRM_MAIN_RET		; WINDOWS/フレーム・復帰
;*;	CALL	WIDFRM_MAIN_SRT		; WINDOWS/フレーム・メインスタート時
;*;	CALL	R_MAIN_WINDOW_DSP	; メインウインドウ復帰
	JMP	KOSOMAIN_LOOP_INIT	;

KOSOMAIN_UNMEI:				;
	CALL	AUTO_DEMO_STOP		; オート実行ストップ
	CALL	UNMEI_NO_HI		; 運命の日
	JMP	$	;KOSOMAIN_EXIT		;

KOSOMAIN_EXIT:				;
	RET
KOSOMAIN	ENDP


; ****************************************************
;	１ヶ月の最初
;	-O- CMND_NUM  : コマンド番号 1=スケジュール,2=データロード直後
;			98=運命の日,99=強制終了
; ****************************************************

IKKAGETU	PROC	NEAR
	MOV	EXIT_FLAG,0

	CALL	UNMEI_DIALY		; 運命の日までどのくらいあるか

	CALL	SAISHO_MSG		; １ヶ月の最初のメッセージ

	CALL	MSCSRT			; カーソルスタート
IKKAGETU_LOOP:
	CALL	MSCSTP			; カーソルストップ
	CALL	SAISHO_MSG		; １ヶ月の最初のメッセージ
	CALL	MSCSRT			; カーソルスタート
IKKAGETU_LOOP_2:			;
	CALL	MSCMOV			; カーソル移動
	MOV	WDMSX,AX		; マウスＸ
	MOV	WDMSY,BX		; マウスＹ
	MOV	BYTE PTR WDMSL,DH	; マウス左ボタン
	MOV	BYTE PTR WDMSR,DL	; マウス右ボタン
	CALL	WIDBTN_TOUCH		; WINDOWS/ボタンタッチチェック
	CMP	WDBTNPUSH,2		; 2=ボタンを押した
	JE	IKKAGETU_BOTTAN_ON	;

	CALL	KAKUSHI_COMMAND		; 隠しコマンド
	CMP	AX,1			; 1=コマンド
	JMPEQ	IKKAGETU_BREAK		;

	MOV	OLD_WDBTNNUM,0		; ひとつ前の選択ボタン番号
	JMP	IKKAGETU_LOOP_2		;

IKKAGETU_BOTTAN_ON:			;
	CMP	WDBTNNUM,1		; 1=スケジュール
	JMPEQ	IKKAGETU_SCH		;

;*;	CMP	WDBTNNUM,2		; 2=ＮＯ
;*;	JMPEQ	IKKAGETU_BREAK		;

IKKAGETU_MENU:				;
	CALL	RUN_MENU		; 実行メニュー
	CMP	FLAG_NEW_LOAD,1		; フラグ・データをロードした
	JE	IKKAGETU_LOAD_GO	;

IKKAGETU_NEXT:				;
	JMP	IKKAGETU_LOOP		;

IKKAGETU_SCH:
	CMP	UNNMEI_DAYS_FLG,0	; 0=運命の日
	JE	IKKAGETU_UNMEI		;

	CALL	MSCSTP			; カーソルストップ
	MOV	CMND_NUM,1		;  1=スケジュール
	RET
IKKAGETU_BREAK:
	CALL	MSCSTP			; カーソルストップ
	MOV	CMND_NUM,99		; 99=強制終了
	RET
IKKAGETU_LOAD_GO:
	CALL	MSCSTP			; カーソルストップ
	MOV	CMND_NUM,2		; 2=データロード直後
	RET
IKKAGETU_UNMEI:
	CALL	MSCSTP			; カーソルストップ
	MOV	CMND_NUM,98		; 98=運命の日
	RET
IKKAGETU	ENDP


; ****************************************************
;	隠しコマンド
;	-O- AX : 0=通常,1=コマンド
; ****************************************************

KAKUSHI_COMMAND	PROC	NEAR
	CMP	KYTBLS[14],00000100B	; key code「N」
	JNE	KAKUSHI_COMMAND_NORMAL	;
	CMP	KYTBLS[8], 00000010B	; key code「O」
	JNE	KAKUSHI_COMMAND_NORMAL	;
	CMP	KYTBLS[3], 00000010B	; key code「R」
	JNE	KAKUSHI_COMMAND_NORMAL	;
	CMP	KYTBLS[7], 00000010B	; key code「I」
	JNE	KAKUSHI_COMMAND_NORMAL	;
	CMP	KYTBLS[15],00000010B	; key code「D」
	JNE	KAKUSHI_COMMAND_NORMAL	;
	CMP	KYTBLS[13],00000010B	; key code「A」
	JNE	KAKUSHI_COMMAND_NORMAL	;
KAKUSHI_COMMAND_CM:
	MOV	AX,1			; 1=コマンド
	RET
KAKUSHI_COMMAND_NORMAL:
	MOV	AX,0			; 0=通常
	RET
KAKUSHI_COMMAND	ENDP


; ****************************************************
;	１ヶ月の最初のメッセージ
;	-I- UNNMEI_DAYS_FLG : 4以上=当分ない,3=３ヶ月前,2=２ヶ月前,1=１ヶ月前
;				0=運命の日
;	    FLG_SYUKAKU     : フラグ・収穫祭の準備
; ****************************************************

SAISHO_MSG	PROC	NEAR
	PR_CLS

	CMP	FLG_SYUKAKU,1		; フラグ・収穫祭の準備
	JE	SAISHO_MSG_D01		;

	CMP	UNNMEI_DAYS_FLG,5	; 5=開始当日
	JE	SAISHO_MSG_D5		;
	CMP	UNNMEI_DAYS_FLG,4	; 4以上=当分ない
	JE	SAISHO_MSG_D4		;
	CMP	UNNMEI_DAYS_FLG,3	; 3=３ヶ月前
	JE	SAISHO_MSG_D3		;
	CMP	UNNMEI_DAYS_FLG,2	; 2=２ヶ月前
	JE	SAISHO_MSG_D2		;
	CMP	UNNMEI_DAYS_FLG,1	; 1=１ヶ月前
	JE	SAISHO_MSG_D1		;
	CMP	UNNMEI_DAYS_FLG,0	; 0=運命の日
	JE	SAISHO_MSG_D0		;
	JMP	SAISHO_MSG_D5		;

SAISHO_MSG_D01:
	PR_TXT	"あしたから収穫祭だ。"
	JMP	SAISHO_MSG_EXIT
SAISHO_MSG_D0:
	PR_TXT	"運命の日の前日"
	JMP	SAISHO_MSG_EXIT
SAISHO_MSG_D1:
	PR_TXT	"運命の日まであと１ヶ月"
	JMP	SAISHO_MSG_EXIT
SAISHO_MSG_D2:
	PR_TXT	"運命の日まであと２ヶ月"
	JMP	SAISHO_MSG_EXIT
SAISHO_MSG_D3:
	PR_TXT	"運命の日まであと３ヶ月"
	JMP	SAISHO_MSG_EXIT
SAISHO_MSG_D4:

SAISHO_MSG_D5:
	PR_TXT	"さて、明日から"

	MOV	DX,VAL_MONTH		; (now)月
	INC	DX			;
	CMP	DX,13			;
	JL	SAISHO_MSG_D5_1		;
	MOV	DX,1			; DX = 翌月
SAISHO_MSG_D5_1:
	CALL	R_SR_POINT		; ポイント表示
	PR_TXT	"月か"
	JMP	SAISHO_MSG_EXIT
SAISHO_MSG_EXIT:
	RET
SAISHO_MSG	ENDP


; ****************************************************
;	運命の日までどのくらいあるか
;	-O- UNNMEI_DAYS_FLG : 4以上=当分ない,3=３ヶ月前,2=２ヶ月前,1=１ヶ月前
;			  0=運命の日,5=開始当日
; ****************************************************

UNMEI_DIALY	PROC	NEAR
	MOV	DX,ST_VAL_YEAR		; 環境開始・年
	MOV	YEAR_START,DX		; 開始時の年代

	MOV	DX,VAL_YEAR		; 現在の年代
	SUB	DX,YEAR_START		; 開始時の年代
	CMP	DX,8			; ８年目
	JGE	UNMEI_DIALY_55		;
	CMP	DX,7			; ７年目
	JE	UNMEI_DIALY_66		;
	CMP	DX,0			; 始め
	JE	UNMEI_DIALY_44		;
	JMP	UNMEI_DIALY_D4		;
UNMEI_DIALY_44:				;
	CMP	VAL_MONTH,3		; (now)月
	JE	UNMEI_DIALY_D5		;

	JMP	UNMEI_DIALY_D4		;

UNMEI_DIALY_55:				; ８年目
	CMP	VAL_MONTH,3		; (now)月
	JE	UNMEI_DIALY_D0		; 0=運命の日
	CMP	VAL_MONTH,2		; (now)月
	JE	UNMEI_DIALY_D1		; 1=１ヶ月前
	CMP	VAL_MONTH,1		; (now)月
	JE	UNMEI_DIALY_D2		; 2=２ヶ月前

	JMP	UNMEI_DIALY_D4		;

UNMEI_DIALY_66:				; ７年目
	CMP	VAL_MONTH,12		; (now)月
	JE	UNMEI_DIALY_D3		; 3=３ヶ月前

	JMP	UNMEI_DIALY_D4		;


UNMEI_DIALY_D0:
	MOV	UNNMEI_DAYS_FLG,0		; 0=運命の日
	JMP	UNMEI_DIALY_EXIT
UNMEI_DIALY_D1:
	MOV	UNNMEI_DAYS_FLG,1		; 1=１ヶ月前
	JMP	UNMEI_DIALY_EXIT
UNMEI_DIALY_D2:
	MOV	UNNMEI_DAYS_FLG,2		; 2=２ヶ月前
	JMP	UNMEI_DIALY_EXIT
UNMEI_DIALY_D3:
	MOV	UNNMEI_DAYS_FLG,3		; 3=３ヶ月前
	JMP	UNMEI_DIALY_EXIT
UNMEI_DIALY_D4:
	MOV	UNNMEI_DAYS_FLG,4		; 4以上=当分ない
	JMP	UNMEI_DIALY_EXIT
UNMEI_DIALY_D5:
	MOV	UNNMEI_DAYS_FLG,5		; 5=開始当日
	JMP	UNMEI_DIALY_EXIT
UNMEI_DIALY_EXIT:
	RET
UNMEI_DIALY	ENDP


; ****************************************************
;	運命の日
; ****************************************************

UNMEI_NO_HI	PROC	NEAR
	CALL	R_ENDING			; エンディング
	RET
UNMEI_NO_HI	ENDP


; ****************************************************
;	実行メニュー
;	-I- WDBTNPUSH: ボタン押したフラグ 0=ボタンに触れてない
;	               1=ボタンに触れた,  2=ボタンを押した
;	    WDBTNNUM : 選択ボタン番号  0=ボタンに触れてない
;			1=スケジュール
;			2=王様,3=町の評判
;			4=ステータス,5=娘と話す,6=買物
;	-I/O- OLD_WDBTNNUM  : ひとつ前の選択ボタン番号
;	-O-   FLAG_NEW_LOAD : フラグ・データをロードした
; ****************************************************

RUN_MENU	PROC	NEAR
	MOV	FLAG_NEW_LOAD,0		; フラグ・データをロードした

	CMP	WDBTNPUSH,2		; 2=ボタンを押した
	JE	RUN_MENU_START		;
	MOV	OLD_WDBTNNUM,0		; ひとつ前の選択ボタン番号
	RET

RUN_MENU_START:
	CMPX	OLD_WDBTNNUM,WDBTNNUM	; ひとつ前の選択ボタン番号
	JMPEQ	RUN_MENU_SKIP		;

	BANDCHK	WDBTNNUM,1,6,RUN_MENU_ERROR	; 選択ボタン番号チェック

;*;	PR_TXT	"ボタンが押された　"

	JMPTBL	WDBTNNUM		; 選択ボタン番号
	DW	OFFSET RUN_MENU_ERROR	;
	DW	OFFSET RUN_MENU_SCHEDULE ;1=スケジュール
	DW	OFFSET RUN_MENU_KING	; 2=王様
	DW	OFFSET RUN_MENU_TOWNS	; 3=町の評判
	DW	OFFSET RUN_MENU_STATUS	; 4=ステータス
	DW	OFFSET RUN_MENU_TALK	; 5=娘と話す
	DW	OFFSET RUN_MENU_SHOP	; 6=買物

RUN_MENU_KING:				; 2=王様
	CALL	MSCSTP			; カーソルストップ
	CALL	R_OHSAMA		; 王様との会見
	CALL	MSCSRT			; カーソルスタート
	JMP	RUN_MENU_EXIT

RUN_MENU_TOWNS:				; 3=町の評判
	CALL	MSCSTP			; カーソルストップ
	CALL	R_UWASA			; 町の人がうわさする
	CALL	MSCSRT			; カーソルスタート
	JMP	RUN_MENU_EXIT

RUN_MENU_STATUS:			; 4=ステータス
	CALL	MSCSTP			; カーソルストップ
	CALL	CMND_STATUS		; コマンド／ステータス
	CALL	MSCSRT			; カーソルスタート
	JMP	RUN_MENU_EXIT

RUN_MENU_TALK:				; 5=娘と話す
	CALL	MSCSTP			; カーソルストップ
	CALL	R_KAIWA			; 娘との会話
	CALL	MSCSRT			; カーソルスタート
	JMP	RUN_MENU_EXIT

RUN_MENU_SHOP:				; 6=買物
	CALL	MSCSTP			; カーソルストップ
	CALL	R_KAIMON		; 買物
	CALL	MSCSRT			; カーソルスタート
	JMP	RUN_MENU_EXIT
RUN_MENU_SCHEDULE:			; 1=スケジュール
;;	CALL	MSCSTP			; カーソルストップ
;;	CALL	MSCSRT			; カーソルスタート
	JMP	RUN_MENU_EXIT
RUN_MENU_EXIT:
	MOVX	OLD_WDBTNNUM,WDBTNNUM	; ひとつ前の選択ボタン番号
	RET
RUN_MENU_SKIP:
	RET
RUN_MENU_ERROR:
	PR_TXT	"選択ボタン番号エラー WDBTNNUM=",WDBTNNUM
	RET
RUN_MENU	ENDP


; ***********************************************
;	コマンド／ステータス
;	-I- MAN_NUM       : 娘番号
;	-O- FLAG_NEW_LOAD : フラグ・データをロードした
; ***********************************************

CMND_STATUS	PROC	NEAR
	CALL	R_SOUBI			; 装備
	MOV	FLAG_NEW_LOAD,AX	;0=通常,1=データをロードした。
	RET
CMND_STATUS	ENDP


; ****************************************************
;	スケジュール
; ****************************************************

SCHEDULE	PROC	NEAR
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
	CALL	R_SCHED			; スケジュール
	CMP	AX,1			; 0=正常,1=取り消し
	JE	SCHEDULE_EXIT		;
	CALL	R_PROG			; スケジュール実行

	CALL	R_SCHO_MONTH		; 成長の月次処理
SCHEDULE_EXIT:
	RET
SCHEDULE	ENDP




CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	KYTBLS:BYTE			; key code table top.

EXTRN	EXIT_FLAG:WORD			; １＝強制終了
EXTRN	DEMO_MODE_SYU:WORD		; デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ

EXTRN	ST_VAL_YEAR:WORD		; 環境開始・年
EXTRN	ST_VAL_MONTH:WORD		; 環境開始・月
EXTRN	ST_VAL_WEEK:WORD		; 環境開始・曜日
EXTRN	ST_VAL_DATE:WORD		; 環境開始・日

EXTRN	NOW_DATE:BYTE			; (now)現在時間
EXTRN	VAL_YEAR:WORD			; (now)年
EXTRN	VAL_MONTH:WORD			; (now)月
EXTRN	VAL_WEEK:WORD			; (now)曜日
EXTRN	VAL_DATE:WORD			; (now)日
EXTRN	VAL_A_DATE:WORD			; (now)年内合計日付
EXTRN	VAL_M_END:WORD			; (now)月末の日
EXTRN	TM_SEASON:WORD			; (now)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	FLG_SHOGATSU:WORD		; (now)フラグ・正月
EXTRN	FLG_URUBI:WORD			; (now)フラグ・うるう日
EXTRN	FLG_CHRISTMAS_EVE:WORD 		; (now)フラグ・クリスマスイブ
EXTRN	FLG_BORTH:WORD			; (now)フラグ・誕生日
EXTRN	FLG_HOLIDAY:WORD		; (now)フラグ・休日
EXTRN	FLG_SYUKAKU:WORD		; (now)フラグ・収穫祭の準備

CMND_NUM	DW	0		; コマンド番号

OLD_WDBTNNUM	DW	0		; ひとつ前の選択ボタン番号

UNNMEI_DAYS_FLG	DW	0		; 運命の日フラグ　4以上=当分ない
					; 3=３ヶ月前,2=２ヶ月前,1=１ヶ月前
					; 0=運命の日

YEAR_START	DW	0		; 開始時の年代

FLAG_NEW_LOAD	DW	0		; フラグ・データをロードした

DATA	ENDS

	END
;
;	end of "KOSOMAIN.ASM"
;
