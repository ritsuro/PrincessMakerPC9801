; "R_SYUKAKU.ASM" PC-9801UV11 make by R.H 1991/01/07
;
;
;	「子育て」
;
;	収穫祭
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

TITLE_SYUKAKU_X	EQU	7		; タイトルＸ座標
TITLE_SYUKAKU_Y	EQU	176-12		; タイトルＹ座標
TITLE_CENTER_X	EQU	25		; タイトルＸ座標
TITLE_CENTER_Y	EQU	176-12		; タイトルＹ座標

FK_OPEN_NUM	EQU	9		; ふきだし収穫祭ＯＰＥＮ

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

PUBLIC	R_SYUKAK_RUN		; 収穫祭実行

EXTRN	R_BUTOH:NEAR		; 武闘会
EXTRN	R_BUTO_S:NEAR		; そのころ武闘会では

EXTRN	R_CONTST:NEAR		; ミス･×××･コンテスト
EXTRN	R_CTST_S:NEAR		; そのころミス･コンテストでは

EXTRN	R_SCHO_DAYS:NEAR	; 成長の日次処理
EXTRN	R_BORTH_DAY:NEAR	; 誕生日の処理

EXTRN	R_SCHO_SYUKAKU:NEAR	; 娘チェック(収穫祭用)

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	WIDALLOC_MY_GIRL:NEAR	; WINDOWS/私の娘・データ結合

EXTRN	WIDCLEN_INIT:NEAR	; WINDOWS/カレンダー・初期処理
EXTRN	WIDCLEN_SET:NEAR	; WINDOWS/カレンダー・時間設定
EXTRN	WIDCLEN_SHOW:NEAR	; WINDOWS/カレンダー・再表示
EXTRN	WIDCLEN_UDATE:NEAR	; WINDOWS/カレンダー・更新処理
EXTRN	WIDCLEN_UD_FF:NEAR	; WINDOWS/カレンダー・早送り
EXTRN	WIDCLEN_GET:NEAR	; WINDOWS/カレンダー・読み取り処理
EXTRN	WIDCLEN_U_AD:NEAR	; WINDOWS/カレンダー・日付加算計算

EXTRN	WIDFRM_MAIN_RET:NEAR	; WINDOWS/フレーム・復帰
;;EXTRN	WIDFRM_MAIN_SRT:NEAR	; WINDOWS/フレーム・メインスタート時
EXTRN	WIDDSP_ALG:NEAR		; WINDOWS/季節アナログ設定

EXTRN	WIDFUKI:NEAR		; WINDOWS/ふきだしウインドウ
EXTRN	WIDFUKI_OPEN:NEAR	; WINDOWS/ふきだしウインドウＯＰＥＮ
EXTRN	WIDFUKI_CLOSE:NEAR	; WINDOWS/ふきだしウインドウＣＬＯＳＥ

EXTRN	WIDTXT2:NEAR		; WINDOWS/テキストウインドウ２

EXTRN	WIDPROP_INIT:NEAR	; WINDOWS/プロポ・ウインドウ初期処理
EXTRN	WIDPROP_ALL:NEAR	; WINDOWS/プロポ・ウインドウ全表示
EXTRN	WIDPROP_OPEN:NEAR	; WINDOWS/プロポ・ウインドウＯＰＥＮ
EXTRN	WIDPROP_CLOSE:NEAR	; WINDOWS/プロポ・ウインドウＣＬＯＳＥ

EXTRN	WIDFRM_MAIN_HED:NEAR	; WINDOWS/フレーム・メイン・ヘッダ再表示

EXTRN	R_MS_KUCHIPAKU:NEAR	; 口パクモード
EXTRN	R_MS_KUCHISTOP:NEAR	; 口パクモード終り

EXTRN	R_SR_YOIDESUKA:NEAR	; よいですか

EXTRN	PT_SYUKAK_LD:NEAR	; 収穫祭パターンロード
EXTRN	PT_SYUKAK_PUT:NEAR	; 収穫祭パターンＰＵＴ
EXTRN	PT_SYUKAK_MPT:NEAR	; 収穫祭マスクパターンＰＵＴ

EXTRN	PT_PALET_ST:NEAR	; パレットのセット

; ****************************************************
;	収穫祭実行
; ****************************************************

R_SYUKAK_RUN	PROC	NEAR
	PR_CLS
	CALL	R_MS_KUCHIPAKU		; 口パクモード

	CMPX	VAL_YEAR,ST_VAL_YEAR	; 環境開始・年
	JNE	R_SYUKAK_RUN_22		; ＊２年目以降
R_SYUKAK_RUN_21:			; ＊１年目
	MOV	WDTXTADR,OFFSET MSG_START_1	; １０月は天地の神々の...
	CALL	WIDTXT2			; WINDOWS/テキストウインドウ２

	PR_WAIT
	
	MOV	WDTXTADR,OFFSET MSG_START_12	;
	CALL	WIDTXT2			; WINDOWS/テキストウインドウ２
	JMP	R_SYUKAK_RUN_23
R_SYUKAK_RUN_22:				; ＊２年目以降
	MOV	WDTXTADR,OFFSET MSG_START_2	; １０月は収穫祭です。
	CALL	WIDTXT2			; WINDOWS/テキストウインドウ２
R_SYUKAK_RUN_23:
	CALL	R_MS_KUCHISTOP		; 口パクモード終り

	CALL	R_SR_YOIDESUKA		; よいですか


	MUSIC	KYOKU_SYUKAKUSAI	; 収穫祭

	CALL	WIDCLEN_UDATE		; WINDOWS/カレンダー・更新処理

	MOV	DX,1			; 1=収穫祭
	CALL	PT_SYUKAK_LD		; 収穫祭パターンロード

	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）

	MOV	AX,10			; 10/60秒
	CALL	TMVSET			; V-SYNC timer set.

	CALL	VRMCLR			; vram clear.

	MOV	AX,TITLE_SYUKAKU_X	; タイトルＸ座標
	MOV	BX,TITLE_SYUKAKU_Y	; タイトルＹ座標
	MOV	DX,0			; 0=収穫祭
	CALL	PT_SYUKAK_PUT		; 収穫祭パターンＰＵＴ

	CALL	TMVEWT			; V-SYNC timer end wait.
	MOV	DX,16			; 夏のパレットのパターン番号
	CALL	PT_PALET_ST		; パレットのセット

	MOV	AX,60*1			;
	CALL	TMVWAT			; V-SYNC timer wait.

R_SYUKAK_RUN_LOOP:

	SELECT	"　　武　闘　会,ミス王国･コンテスト,　　休　　　息"
;*;	SELECT	"武闘会"
	CMP	WIDSNM,0			; 武闘会
	JMPEQ	R_SYUKAK_RUN_BUTOU		;
	CMP	WIDSNM,1			; ミス･×××･コンテスト
	JMPEQ	R_SYUKAK_RUN_CONTEST		;
	CMP	WIDSNM,2			; 休息
	JMPEQ	R_SYUKAK_RUN_REST		;

	JMP	R_SYUKAK_RUN_LOOP

R_SYUKAK_RUN_BUTOU:
	CALL	RUN_BUTOU			; 武闘会
	CALL	OKURI_DATE			; 時は流れて・・・
	JMP	R_SYUKAK_RUN_KEKKA

R_SYUKAK_RUN_CONTEST:
	CALL	RUN_CONTEST			; ミス･×××･コンテスト
	CALL	OKURI_DATE			; 時は流れて・・・
	JMP	R_SYUKAK_RUN_KEKKA

R_SYUKAK_RUN_REST:
	CALL	RUN_KENGAKU			; 見学
	CALL	OKURI_DATE			; 時は流れて・・・
	JMP	R_SYUKAK_RUN_KEKKA

R_SYUKAK_RUN_KEKKA:

R_SYUKAK_RUN_EXIT:
	RET
R_SYUKAK_RUN	ENDP


; ****************************************************
;	武闘会
; ****************************************************

RUN_BUTOU	PROC	NEAR
	MUSIC	KYOKU_BUTOHKAI		; 武闘会

	CALL	R_BUTOH			; 武闘会

	MUSIC	KYOKU_MISSCON		; ﾐｽｺﾝ

	SELECT	"そのころミス王国･コンテストでは"

	CALL	ANTHER_CONTEST		; そのころミス･コンテストでは

	SELECT	"収穫祭はおわった"

	MUSIC	KYOKU_F_O		; 音楽フェードアウト

	RET
RUN_BUTOU	ENDP


; ****************************************************
;	ミス･×××･コンテスト
; ****************************************************

RUN_CONTEST	PROC	NEAR
	MUSIC	KYOKU_MISSCON		; ﾐｽｺﾝ

	CALL	R_CONTST		; ミス･×××･コンテスト

	MUSIC	KYOKU_BUTOHKAI		; 武闘会

	SELECT	"そのころ武闘会では"

	CALL	ANTHER_BUTOU		; そのころ武闘会では

	SELECT	"収穫祭はおわった"

	MUSIC	KYOKU_F_O		; 音楽フェードアウト

	RET
RUN_CONTEST	ENDP


; ****************************************************
;	見学
; ****************************************************

RUN_KENGAKU	PROC	NEAR
	MUSIC	KYOKU_BUTOHKAI		; 武闘会

	CALL	ANTHER_BUTOU		; そのころ武闘会では

	MUSIC	KYOKU_MISSCON		; ﾐｽｺﾝ

	CALL	ANTHER_CONTEST		; そのころミス･コンテストでは

	SELECT	"収穫祭はおわった"

	MUSIC	KYOKU_F_O		; 音楽フェードアウト

	RET
RUN_KENGAKU	ENDP


; ****************************************************
;	そのころ武闘会では
; ****************************************************

ANTHER_BUTOU	PROC	NEAR
	CALL	R_BUTO_S		; そのころ武闘会では
	RET
ANTHER_BUTOU	ENDP


; ****************************************************
;	そのころミス･コンテストでは
; ****************************************************

ANTHER_CONTEST	PROC	NEAR
	CALL	R_CTST_S		; そのころミス･コンテストでは
	RET
ANTHER_CONTEST	ENDP


; ****************************************************
;	時は流れて・・・
; ****************************************************

OKURI_DATE	PROC	NEAR
;*;	MOV	CX,VAL_M_END		; 月末の日（早送り日数）
;*;	SUB	CX,2			;
;*;	CALL	WIDCLEN_UD_FF		; WINDOWS/カレンダー・早送り

	MOV	DX,0			; 先頭のヘッダーを、私の娘とします
	CALL	WIDALLOC_MY_GIRL	; WINDOWS/私の娘・データ結合

	CALL	R_SCHO_SYUKAKU		; 娘チェック(収穫祭用)

	CALL	WIDFRM_MAIN_RET		; WINDOWS/フレーム・復帰
	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定

	MOV	AX,1			; モードスイッチ 0=ノーマル,1=マッハ
	MOV	S_FUNC,32		; 32=マッハモード
	CALL	R_KEISAN		; 各計算処理


	CALL	R_SCHO_DAYS		; 成長の日次処理
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
	CALL	WIDFRM_MAIN_HED		; WINDOWS/フレーム・メイン・ヘッダ再表

	CMP	MY_GIRL_BORTH_F,1	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	JNE	OKURI_DATE_2		;
	CALL	R_BORTH_DAY		; 誕生日の処理
OKURI_DATE_2:

	MOV	CX,VAL_M_END		; 月末の日（早送り日数）
	SUB	CX,1			;
OKURI_DATE_LOOP:
	PUSH	CX			;

	CALL	WIDCLEN_UDATE		; WINDOWS/カレンダー・更新処理

	CALL	R_SCHO_DAYS		; 成長の日次処理
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
	CALL	WIDFRM_MAIN_HED		; WINDOWS/フレーム・メイン・ヘッダ再表

	CMP	MY_GIRL_BORTH_F,1	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	JNE	OKURI_DATE_NEXT		;
	CALL	R_BORTH_DAY		; 誕生日の処理
OKURI_DATE_NEXT:
	POP	CX			;
	LOOP	OKURI_DATE_LOOP		;

	MOV	AX,0			; モードスイッチ 0=ノーマル,1=マッハ
	MOV	S_FUNC,32		; 32=マッハモード
	CALL	R_KEISAN		; 各計算処理

	RET
OKURI_DATE	ENDP


CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	ST_VAL_YEAR:WORD		; 環境開始・年
EXTRN	ST_VAL_MONTH:WORD		; 環境開始・月
EXTRN	ST_VAL_WEEK:WORD		; 環境開始・曜日
EXTRN	ST_VAL_DATE:WORD		; 環境開始・日

EXTRN	W_GIRL_SEASON:WORD	; 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
EXTRN	W_GIRL_GROW:WORD	; 少女（成長１,成長２,成長３,成長４）
EXTRN	W_GIRL_FACE:WORD	; 顔（１－３）

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

EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	MY_GIRL_BORTH_F:WORD	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ(R_SEICHO.ASM)

MSG_START_1	LABEL	BYTE
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@",0
MSG_START_12	LABEL	BYTE
DB	"国一番の勇士を決める@『武闘会』と一番の美人を決める@『ミス王国コンテスト』の二大イベントが開かれますよ。@",0
	DB	"参加費は無料です。",0

MSG_START_2	DB	"１０月は収穫祭です。",0

DATA	ENDS

	END
;
;	end of "R_SYUKAKU.ASM"
;
