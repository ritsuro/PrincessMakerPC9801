; "OPENING.ASM" PC-9801UV11 make by R.H 1990/12/10
;
;
;	「子育て」
;
;	オープニング
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	KOSO3.INC
INCLUDE	..\KOSO6\KYOKU.INC

MUSIC_OPNING	EQU	2		; 曲データ・オープニング
MUSIC_GAME	EQU	1		; 曲データ・ゲーム面
MUSIC_BATLE	EQU	3		; 曲データ・バトル

OP_OFS_XX	EQU	10		; オープニング位置Ｘ
OP_OFS_YY	EQU	80-30		; オープニング位置Ｙ


MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


SERIFU	MACRO	NUM,SSS
	LOCAL	L1
DATA	SEGMENT	PUBLIC	'DATA'
L1	DB	SSS,0,0
DATA	ENDS
	MOV	TEXT_HI_POSI,NUM	; text hight position.
	MOV	SI,OFFSET L1		; 表示文字列アドレス
	CALL	TEXT_PRINT		; ＴＥＸＴ　ＰＲＩＮＴ
	ENDM

S_START	MACRO
	CALL	TEXT_CLEAR		; ＴＥＸＴ　ＣＬＥＡＲ
	ENDM

S_END	MACRO
	CALL	TEXT_WAIT_S		; ＴＥＸＴ　ＷＡＩＴ　ＳＴＡＲＴ
	CALL	TEXT_WAIT_E		; ＴＥＸＴ　ＷＡＩＴ　ＥＮＤ
	ENDM

S_END_L	MACRO
	CALL	TEXT_WAIT_S		; ＴＥＸＴ　ＷＡＩＴ　ＳＴＡＲＴ
	ADD	TEXT_WAIT_ADD,60*3	; テキスト待ち時間合計
	TIME_SET	TEXT_WAIT_ADD		; テキスト待ち時間合計
	CALL	TEXT_WAIT_E		; ＴＥＸＴ　ＷＡＩＴ　ＥＮＤ
	ENDM

EXIT_CHK	MACRO	LBL_EXIT
	LOCAL	L1
	EXTRN	KEYTEN:NEAR	; キーボード・読み込み
	CALL	KEYTEN		; キーボード・読み込み
				; AX : 番号(-1:押していない)
	CMP	BX,3		; BX : 1=HELP,2=HOME,3=PLUS(-1:押していない)
	JNE	L1		;
	JMP	LBL_EXIT	;
L1:
	ENDM


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	OPENING			; オープニング
PUBLIC	OPENNAME		; オープニング・名前入力
PUBLIC	OPENTEXTPR		; オープニング・テキスト表示
PUBLIC	OPENTEXTMODE		; オープニング・テキストモード
PUBLIC	OPEN_NAME_LOAD		; オープニング・名前ロード

EXTRN	PT_PALET_LD:NEAR	; パレットのロード
EXTRN	PT_PALET_ST:NEAR	; パレットのセット
EXTRN	PT_PALET_PLD:NEAR	; パレットのテーブルのみセット
EXTRN	PT_PALET_PLDP:NEAR	; パレットのテーブルのみセット（テーブル指定）

EXTRN	P_RED:NEAR		; 赤
EXTRN	P_WHITE:NEAR		; 白

;*;EXTRN PT_C0_LD:NEAR		; Ｃ０（ＧＩＮＡＸ）のロード
;*;EXTRN PT_C0_ST:NEAR		; Ｃ０（ＧＩＮＡＸ）

EXTRN	PT_C1_LD:NEAR		; Ｃ１のロード
EXTRN	PT_C1P:NEAR		; Ｃ１

EXTRN	PT_C2_LD:NEAR		; Ｃ２のロード
EXTRN	PT_C2P:NEAR		; Ｃ２

EXTRN	PT_C3_LD:NEAR		; Ｃ３のロード
EXTRN	PT_C3P:NEAR		; Ｃ３

EXTRN	PT_C4_LD:NEAR		; Ｃ４のロード
EXTRN	PT_C4P:NEAR		; Ｃ４

EXTRN	PT_C5_LD:NEAR		; Ｃ５のロード
EXTRN	PT_C5P:NEAR		; Ｃ５

;*;EXTRN PT_C12P:NEAR		; Ｃ１２

EXTRN	PT_OPEN_ALL_LD:NEAR		; オープニング全ロード

EXTRN	PT_OPEN_NAME:NEAR		; 名前入力フレーム
EXTRN	PT_OPEN_CUTF:NEAR		; オープニングフレーム

EXTRN	R_SR_GIRL_NAMEGET:NEAR		; キャラクタ名ＧＥＴ
EXTRN	R_SR_GIRL_F_NAMEGET:NEAR	; キャラクタ姓ＧＥＴ

EXTRN	MSCSRT:NEAR			; カーソルスタート
EXTRN	MSCMOV:NEAR			; カーソル移動
EXTRN	MSCWAT:NEAR			; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR			; カーソルストップ
EXTRN	MSCSTS:NEAR			; マウスカーソルステータス
EXTRN	MSCPNT:NEAR			; カーソル表示位置

EXTRN	RANDAM_STR:NEAR			; 乱数スタート
EXTRN	RANDAM:NEAR			; 乱数
EXTRN	RANDAM_100:NEAR			; 乱数１００
EXTRN	RANDAM_200:NEAR			; 乱数２００

EXTRN	STRLENGTH:NEAR			; 文字列長さ

EXTRN	WIDNAME_INIT:NEAR		; WINDOWS/名前ウインドウ初期処理
EXTRN	WIDNAME_SET:NEAR		; WINDOWS/名前ウインドウ全表示

EXTRN	WIDBORTH_INIT:NEAR		; WINDOWS/誕生日ウインドウ初期処理
EXTRN	WIDBORTH_SET:NEAR		; WINDOWS/誕生日ウインドウ実行

EXTRN	WIDDSP_SV_F:NEAR		; WINDOWS/画面フル退避 vram0 -> vram1

EXTRN	PLTINTSW:NEAR			; パレット・割込み処理スイッチ
EXTRN	PLTINTSPD:NEAR			; パレット・割込み処理スピード
EXTRN	PLTINTWT:NEAR		; パレット・割込み処理終了待ち


; ****************************************************
;	オープニング
;	PT_OPEN_ALL_LD（オープニング全ロード）をロードしておくこと
;	ＶＲＡＭ１にタイトルを残して終わる
;
; ****************************************************

OPENING	PROC	NEAR
	PUSH	IPLMSW
	MOV	IPLMSW,2		; パレットエフェクト単位時間(VSYNC)

	CALL	OPEN_NAME_LOAD		; オープニング・名前ロード

	EXIT_CHK	OPNING_BREAK

	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避 vram0 -> vram1
	CALL	VRMDP1			; ＶＲＡＭ１表示

	CALL	DEMOPROC		; デモ実行

	MOV	BX,0
	MOV	CX,16
OPNING_SET1:
	MOV	CRTSKP[BX],0	; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)
	INC	BX
	INC	BX
	LOOP	OPNING_SET1

	JMP	OPNING_NORMAL_EXIT	;

OPNING_BREAK:
	CALL	BREAK_SET		; ＢＲＥＡＫ時処理
OPNING_NORMAL_EXIT:
	POP	IPLMSW
	RET
OPENING	ENDP


; ****************************************************
;	オープニング・名前入力
;	-I- AX : 0=最初,1=キャンセルで戻ってきた
;	-O- AX : 0=通常,1=スキップ
; ****************************************************

OPENNAME	PROC	NEAR
	MOV	FLAG_CANCEL,AX		; キャンセルフラグ
	
	PUSH	IPLMSW
	MOV	IPLMSW,2		; パレットエフェクト単位時間(VSYNC)

	CMP	FLAG_CANCEL,1		; 1=キャンセルで戻ってきた
	JE	OPENNAME_002		;

	CALL	BLACK			;
OPENNAME_002:				;
	CALL	VRMWT1			; ＶＲＡＭ０アクセス
	CALL	PT_OPEN_NAME		; 名前入力フレーム

	CALL	VRMDP0			; ＶＲＡＭ０表示
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	CALL	PT_OPEN_NAME		; 名前入力フレーム

	MOV	DX,11			; 11=名前入力
	MOV	AX,0			;
	CALL	PT_PALET_PLDP		; パレットのテーブルのみ/テーブル指定

	MOV	DX,12			; 12=名前入力／娘
	MOV	AX,2			;
	CALL	PT_PALET_PLDP		; パレットのテーブルのみ/テーブル指定

	MOV	AX,FLAG_CANCEL		; キャンセルフラグ
	CALL	WIDNAME_SET		; WINDOWS/名前ウインドウ全表示
	CMP	AX,1			; 0=通常,1=スキップ
	JE	OPENNAME_BREAK		;

;*;	MOV	DX,12			; 12=名前入力／娘
;*;	MOV	AX,0			;
;*;	CALL	PT_PALET_PLDP		; パレットのテーブルのみ/テーブル指定
;*;	CALL	FEDOUT			; Ｆ．Ｏ

	CALL	VRMDP0			; ＶＲＡＭ０表示
	CALL	VRMWT0			; ＶＲＡＭ０アクセス

;*;	CALL	VRMCLR			; VRAM clear


	MOV	AX,0			; 0=通常
	POP	IPLMSW
	RET
OPENNAME_BREAK:
	CALL	BREAK_SET		; ＢＲＥＡＫ時処理

	MOV	AX,1			; 1=スキップ
	POP	IPLMSW
	RET
OPENNAME	ENDP


; ****************************************************
;	オープニング・テキスト表示
;	-i-   DS:SI   : string. (null=end of string)
;	      AX      : text hight position.
; ****************************************************

OPENTEXTPR	PROC	NEAR
	MOV	TEXT_HI_POSI,AX		; text hight position.
	CALL	TEXT_PRINT		; ＴＥＸＴ　ＰＲＩＮＴ
	MOV	TEXT_WAIT_ADD,0		; テキスト待ち時間合計
	RET
OPENTEXTPR	ENDP


; ****************************************************
;	オープニング・テキストモード
;	-I- DX : 1=オープニング,2=エンデイング,3=エンデイング２
; ****************************************************

OPENTEXTMODE	PROC	NEAR
	CMP	DX,1			; 1=オープニング,2=エンデイング
	JE	OPENTEXTMODE_2		;
OPENTEXTMODE_1:				;
	MOV	AX,OFFSET TEXT_HIGHT2	;
	JMP	OPENTEXTMODE_8		;
OPENTEXTMODE_2:				;
	MOV	AX,OFFSET TEXT_HIGHT	;
	JMP	OPENTEXTMODE_8		;
OPENTEXTMODE_3:				;
	MOV	AX,OFFSET TEXT_HIGHT3	;

OPENTEXTMODE_8:				;
	MOV	TEXT_HIGHT_ADRS,AX	; text hight address.
	RET
OPENTEXTMODE	ENDP


; ****************************************************
;	オープニング・名前ロード
; ****************************************************

OPEN_NAME_LOAD	PROC	NEAR

	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス

	MOVX	ES,DS			;

	MOV	DI,OFFSET NAME_FIRST	; ファーストネーム
	MOV	CX,LEN_NAME_FIRST	; ファーストネーム長さ
	MOV	AL,0			;
	REP	STOSB			;

	MOV	DI,OFFSET NAME_SECOND	; ファミリーネーム
	MOV	CX,LEN_NAME_SECOND	; ファミリーネーム長さ
	MOV	AL,0			;
	REP	STOSB			;

	MOV	DI,OFFSET NAME_FIRST	; ファーストネーム
	MOV	CX,LEN_NAME_FIRST	; ファーストネーム長さ
	CALL	R_SR_GIRL_NAMEGET	; キャラクタ名ＧＥＴ

	MOV	DI,OFFSET NAME_SECOND	; ファミリーネーム
	MOV	CX,LEN_NAME_SECOND	; ファミリーネーム長さ
	CALL	R_SR_GIRL_F_NAMEGET	; キャラクタ姓ＧＥＴ


	MOVX	ES,DS			;
	MOV	DI,OFFSET NAME_FIRST	; ファーストネーム
	CALL	STRLENGTH		; 文字列長さ
	MOV	LEN_NAME_FIRST,CX	; ファーストネーム長さ

	MOV	DI,OFFSET NAME_SECOND	; ファミリーネーム
	CALL	STRLENGTH		; 文字列長さ
	MOV	LEN_NAME_SECOND,CX	; ファミリーネーム長さ


	RET
OPEN_NAME_LOAD	ENDP


; ****************************************************
;	ＢＲＥＡＫ時処理
; ****************************************************

BREAK_SET	PROC	NEAR
	CALL	BLACK
	CALL	VRMDP1			; ＶＲＡＭ１表示
	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	VRMCLR
	MOV	AX,0			; wait timer count.
	CALL	TMVST2			; V-SYNC timer2 set.
	RET
BREAK_SET	ENDP


; ****************************************************
;	デモ実行
; ****************************************************

DEMOPROC	PROC	NEAR

	EXIT_CHK	DEMOPROC_BREAK

	CALL	C1			; Ｃ－１／「黒い月が太陽を・・・
	CMP	AX,1			; 1=break
	JE	DEMOPROC_BREAK		;

	EXIT_CHK	DEMOPROC_BREAK

	CALL	C2			; Ｃ－２／その名は＠＠＠！

	EXIT_CHK	DEMOPROC_BREAK

	CALL	C3			; Ｃ－３／王「見事な働きであったぞ、」

	EXIT_CHK	DEMOPROC_BREAK

	CALL	C4			; Ｃ－４／＄＄＄満１０才の春で・・

	EXIT_CHK	DEMOPROC_BREAK

	CALL	C5			; Ｃ－５／タイトル「プリンセス」

	RET
DEMOPROC_BREAK:
	CALL	BREAK_SET		; ＢＲＥＡＫ時処理
	RET
DEMOPROC	ENDP

;*;; ****************************************************
;*;;	Ｃ－０／ＧＡＩＮＡＸ
;*;; ****************************************************
;*;
;*;C0	PROC	NEAR
;*;	CALL	BLACK
;*;	CALL	VRMCLR
;*;	CALL	VRMDP0			; ＶＲＡＭ０表示
;*;	CALL	PT_C0_ST		; Ｃ０（ＧＩＮＡＸ）
;*;
;*;	MOV	DX,0			; normal.
;*;	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
;*;	CALL	FEDIN			; Ｆ・Ｉ（フェードイン）
;*;
;*;	TIME_SET	60
;*;
;*;	RET
;*;C0	ENDP


; ****************************************************
;	Ｃ－１／「黒い月が太陽を・・・
;	-O- AX : 1=break,0=normal
; ****************************************************

C1	PROC	NEAR
	CALL	TEXT_INIT		; ＴＥＸＴ　ＩＮＩＴ

	CALL	PT_OPEN_CUTF		; オープニングフレーム

	CALL	PT_C1_LD		; Ｃ１のロード

	TIME_WAIT			;
	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）

	EXIT_CHK	C1_BREAK	;
	CALL	VRMDP0			; ＶＲＡＭ０表示

	MUSIC	KYOKU_PROLOG		; プﾛﾛｰグ

;*;	CALL	VRMCLR

	MOV	DX,7			; 7=ＯＰ－１
	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
;*;	CALL	PT_PALET_ST		; パレットのセット

	CALL	FEDIN			; Ｆ．Ｉ

	S_START
	SERIFU	0,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	CALL	PT_C1P			; Ｃ１
	SHR	TEXT_WAIT_ADD,1		; テキスト待ち時間合計
	S_END

	S_START
	SERIFU	0,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	CALL	TEXT_WAIT_S		; ＴＥＸＴ　ＷＡＩＴ　ＳＴＡＲＴ

	MOV	AX,0			; 0=normal
	RET
C1_BREAK:
	MOV	AX,1			; 1=break
	RET
C1	ENDP


; ****************************************************
;	Ｃ－２／その名は＠＠＠！
; ****************************************************

C2	PROC	NEAR
	CALL	PT_C2_LD		; Ｃ２のロード

	CALL	TEXT_WAIT_E		; ＴＥＸＴ　ＷＡＩＴ　ＥＮＤ

	S_START
;*;	CALL	VRMCLR

	; カラーＯＬ

	MOV	DX,7			; 7=ＯＰ－１
	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
	MOV	DX,8			; 8=ＯＰ－２
	MOV	AX,2			;
	CALL	PT_PALET_PLDP		; パレットのテーブル（テーブル指定）

	MOV	AX,0			; オーバラップ開始パレットテーブル番号
	MOV	BX,2			; オーバラップ終了パレットテーブル番号
	CALL	PLTOLS			; パレット・オーバラップ／時分割初期

	MOV	AX,3			; Ｖ割込み処理の指定インターバル
	CALL	PLTINTSPD		; パレット・割込み処理スピード

;*;	S_START
	SERIFU	0,"＊＊＊＊＠＠＠＊"
	CALL	PLTINTSW		; パレット・割込み処理スイッチ
	CALL	PT_C2P			; Ｃ２
	MOV	DX,8			; 8=ＯＰ－２
	CALL	PT_PALET_ST		; パレットのセット
	S_END

	CALL	PLTINTWT	; パレット・割込み処理終了待ち

	S_START
	SERIFU	0,"＠＠＠＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	CALL	TEXT_WAIT_S		; ＴＥＸＴ　ＷＡＩＴ　ＳＴＡＲＴ

	RET
C2	ENDP


; ****************************************************
;	Ｃ－３／王「見事な働きであったぞ、」
; ****************************************************

C3	PROC	NEAR
	CALL	PT_C3_LD		; Ｃ３のロード

	CALL	TEXT_WAIT_E		; ＴＥＸＴ　ＷＡＩＴ　ＥＮＤ

	S_START
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）

;*;	CALL	VRMCLR
;*;	MOV	DX,9			; 9=ＯＰ－３
;*;	CALL	PT_PALET_ST		; パレットのセット

	MOV	DX,9			; 9=ＯＰ－３
	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
	CALL	PT_C3P			; Ｃ３
	CALL	FEDIN			; Ｆ・Ｉ（フェードイン）

	MUSIC	KYOKU_MAINTHEMA		; ﾒｲﾝﾃｰﾏ

	S_START
	SERIFU	0,"＊＊＊＊＠＠＠＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＠＠＠＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END_L

	S_START
	SERIFU	0,"＠＠＠＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	3,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END_L

	S_START
	SERIFU	0,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＠＠＠＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＠＠＠＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＠＠＠＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	3,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END_L

	S_START
	SERIFU	0,"＠＠＠＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＊＊＊＊＊＊＠＠＠＊＊＊＊＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＊＊＊＊＊＊＊"
	SERIFU	2,"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	CALL	TEXT_WAIT_S		; ＴＥＸＴ　ＷＡＩＴ　ＳＴＡＲＴ
	RET
C3	ENDP


; ****************************************************
;	Ｃ－４／＄＄＄満１０才の春であった・・・・
; ****************************************************

C4	PROC	NEAR
	CALL	PT_C4_LD		; Ｃ４のロード
	CALL	TEXT_WAIT_E		; ＴＥＸＴ　ＷＡＩＴ　ＥＮＤ

	S_START
	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）

;*;	CALL	VRMCLR
;*;	MOV	DX,10			; 10=ＯＰ－４
;*;	CALL	PT_PALET_ST		; パレットのセット

	MOV	DX,10			; 10=ＯＰ－４
	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
	CALL	PT_C4P			; Ｃ４
	CALL	FEDIN			; Ｆ・Ｉ（フェードイン）

	S_START
	SERIFU	0,"＊＊＊＊"
	SERIFU	1,"＊＊＊＊＊＊＠＠＠＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	S_START
	SERIFU	0,"＄＄＄＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	S_END

	RET
C4	ENDP


; ****************************************************
;	Ｃ－５／タイトル「プリンセスメーカー」
; ****************************************************

C5	PROC	NEAR
	TIME_SET	60*2
	CALL	PT_C5_LD		; Ｃ５のロード
	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	PT_C5P			; Ｃ５
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	TIME_WAIT
	S_START
	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）
	CALL	VRMDP1			; ＶＲＡＭ１表示

;*;	; カラーＯＬ
;*;
;*;	MOV	DX,13			; 13=ＯＰ－５－２
;*;	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
;*;	MOV	DX,14			; 14=ＯＰ－５－３
;*;	MOV	AX,2			;
;*;	CALL	PT_PALET_PLDP		; パレットのテーブル（テーブル指定）
;*;	MOV	AX,0			; オーバラップ開始パレットテーブル番号
;*;	MOV	BX,2			; オーバラップ終了パレットテーブル番号
;*;	CALL	PLTOLS			; パレット・オーバラップ／時分割初期
;*;	MOV	CX,22			;
;*;C5_LOOP1:				;
;*;	PUSH	CX			;
;*;	TIME_SET	2		;
;*;	CALL	PLTOLT			; パレット・オーバラップ／時分割処理
;*;	TIME_WAIT			;
;*;	POP	CX			;
;*;	LOOP	C5_LOOP1		;

	MOV	DX,6			; 6=タイトル「プリンセス」
;*;	MOV	DX,14			; 13=ＯＰ－５－２
	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
	CALL	FEDIN			; Ｆ・Ｉ（フェードイン）


	; カラーＯＬ

	MOV	CX,2			;
C5_LOOP_ALL:				;
	PUSH	CX			;

	MOV	DX,6			; 6=タイトル「プリンセス」
	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
	MOV	DX,14			; 13=ＯＰ－５－２
	MOV	AX,2			;
	CALL	PT_PALET_PLDP		; パレットのテーブル（テーブル指定）
	MOV	AX,0			; オーバラップ開始パレットテーブル番号
	MOV	BX,2			; オーバラップ終了パレットテーブル番号
	CALL	PLTOLS			; パレット・オーバラップ／時分割初期
	MOV	CX,22			;
C5_LOOP2:				;
	PUSH	CX			;
	TIME_SET	1		;
	CALL	PLTOLT			; パレット・オーバラップ／時分割処理
	TIME_WAIT			;
	POP	CX			;
	LOOP	C5_LOOP2		;

	MOV	DX,14			; 13=ＯＰ－５－２
	CALL	PT_PALET_PLD		; パレットのテーブルのみセット
	MOV	DX,6			; 6=タイトル「プリンセス」
	MOV	AX,2			;
	CALL	PT_PALET_PLDP		; パレットのテーブル（テーブル指定）
	MOV	AX,0			; オーバラップ開始パレットテーブル番号
	MOV	BX,2			; オーバラップ終了パレットテーブル番号
	CALL	PLTOLS			; パレット・オーバラップ／時分割初期
	MOV	CX,22			;
C5_LOOP3:				;
	PUSH	CX			;
	TIME_SET	1		;
	CALL	PLTOLT			; パレット・オーバラップ／時分割処理
	TIME_WAIT			;
	POP	CX			;
	LOOP	C5_LOOP3		;

	POP	CX			;
	DEC	CX			;
	JZ	C5_LOOP_ALL_END		;
	JMP	C5_LOOP_ALL		;
C5_LOOP_ALL_END:			;

	MOV	DX,6			; 6=タイトル「プリンセス」
	CALL	PT_PALET_ST		; パレットのセット

	MOV	AX,60*10		; wait timer count.
	CALL	TMVST2			; V-SYNC timer2 set.
	RET
C5	ENDP



;*;; ****************************************************
;*;;	Ｃ－１２／ＧＡＩＮＡＸ ＆ ＧＥＮＥＲＡＬ
;*;; ****************************************************
;*;
;*;C12	PROC	NEAR
;*;	TIME_SET	60*3
;*;
;*;	CALL	PT_C12P		; Ｃ１２
;*;
;*;	TIME_WAIT
;*;
;*;	CALL	VRMDP0		; ＶＲＡＭ０表示
;*;	MOV	DX,1		;
;*;	CALL	PT_PALET_ST	; パレットのセット
;*;
;*;	CALL	VRMWT1			; ＶＲＡＭ１アクセス
;*;	CALL	VRMCLR
;*;	CALL	VRMWT0			; ＶＲＡＭ０アクセス
;*;
;*;	TIME_SET	60*2
;*;	TIME_WAIT
;*;
;*;	CALL	M_FDOT			; 音楽フェードアウト
;*;	CALL	FEDOUT			; Ｆ．Ｏ
;*;	RET
;*;C12	ENDP


; ****************************************************
;	ＴＥＸＴ　ＩＮＩＴ
; ****************************************************

TEXT_INIT	PROC	NEAR
	MOV	AX,0			; 0=16x16  1=32x32  2=16x24  3=16x32
	CALL	VTXSIZ			; character size set.

	MOV	AX,0			; character color 0-15
	CALL	VTXCOL			; character color set.

	MOV	AX,0			; font color.
	CALL	MITCOL			; mini string color.
	RET
TEXT_INIT	ENDP


; ****************************************************
;	ＴＥＸＴ　ＰＲＩＮＴ
;	-I- DS:SI        : 文字列
;	    TEXT_HI_POSI : text hight position.
; ****************************************************

TEXT_PRINT	PROC	NEAR
	PUSH	SI
	CALL	STRXLEN				; string length.
	MOV	STR_LEN,CX			; 文字列長さ

	MOV	DI,TEXT_HI_POSI			; text hight position.
	SHL	DI,1				; word pointer.
	MOV	BX,TEXT_HIGHT_ADRS		; text hight address.
	MOV	AX,DS:[BX][DI]			;
	MOV	TEXT_CEN_Y,AX			; text center y.

	MOVX	STR_WIDE,STR_LEN		; 文字列表示長さ

	MOV	AX,"＠"				; 名字あるか？
	MOV	CX,STR_LEN			; string length.
	CALL	K_INSTR				; KANJI search string.
	CMP	AX,1				; 1=find,0=undefind.
	JNE	TEXT_PRINT_1			;
	SUB	STR_WIDE,6			; "＠＠＠"
	ADDX	STR_WIDE,LEN_NAME_SECOND	; ファミリーネーム長さ
TEXT_PRINT_1:
	MOV	AX,"＄"				; 名前あるか？
	MOV	CX,STR_LEN			; string length.
	CALL	K_INSTR				; KANJI search string.
	CMP	AX,1				; 1=find,0=undefind.
	JNE	TEXT_PRINT_2			;
	SUB	STR_WIDE,6			; "＄＄＄"
	ADDX	STR_WIDE,LEN_NAME_FIRST		; ファーストネーム長さ
TEXT_PRINT_2:

	PUSH	SI

	MOV	DX,STR_WIDE			; 文字列表示長さ
	SHL	DX,1				;
	SHL	DX,1				;*4
	ADD	TEXT_WAIT_ADD,DX		; テキスト待ち時間合計

	POP	SI

	MOV	AX,TEXT_CEN_X			; text center x.
	MOV	CX,STR_WIDE			; 文字列表示長さ
	SHR	CX,1				; / 2
	SUB	AX,CX				; Ｘのセンタリング
	MOV	BX,TEXT_CEN_Y			; text center y.
	CALL	STRING_PUT			; 文字列ＰＵＴ

	POP	SI
	RET
TEXT_PRINT	ENDP


; ****************************************************
;	ＴＥＸＴ　ＣＬＥＡＲ
;	-O- TEXT_WAIT_ADD : テキスト待ち時間合計
; ****************************************************

TEXT_CLEAR	PROC	NEAR
	TIME_SET	30
	MOV		DX,TEXT_HIGHT[4*2]	;
	BOXPAA		0,TEXT_HIGHT[0],78,DX,6
	MOV	TEXT_WAIT_ADD,0			; テキスト待ち時間合計
	TIME_WAIT
	RET
TEXT_CLEAR	ENDP


; ****************************************************
;	ＴＥＸＴ　ＷＡＩＴ　ＳＴＡＲＴ
; ****************************************************

TEXT_WAIT_S	PROC	NEAR
	ADD	TEXT_WAIT_ADD,100	; テキスト待ち時間合計

	CMP	TEXT_WAIT_ADD,500	; テキスト待ち時間合計
	JLE	TEXT_WAIT_S_2
	MOV	TEXT_WAIT_ADD,500	; テキスト待ち時間合計
TEXT_WAIT_S_2:
	TIME_SET	TEXT_WAIT_ADD		; テキスト待ち時間合計
	RET
TEXT_WAIT_S	ENDP


; ****************************************************
;	ＴＥＸＴ　ＷＡＩＴ　ＥＮＤ
; ****************************************************

TEXT_WAIT_E	PROC	NEAR
	TIME_WAIT
	RET
TEXT_WAIT_E	ENDP


; ****************************************************
;	文字列ＰＵＴ
;	-i-   DS:SI   : string. (null=end of string)
;	      AX      : location x point.
;	      BX      : location y point.
;	      STR_LEN : 文字列長さ
;	-I/O- TEXT_WAIT_ADD : テキスト待ち時間合計
; ****************************************************

STRING_PUT	PROC	NEAR
	MOV	STRING_PNT,SI			; 文字列ポインタ
	MOV	TEXT_PNT_X,AX			; location x point.
	MOV	TEXT_PNT_Y,BX			; location y point.

	MOV	CX,STR_LEN			; 文字列長さ
	SHR	CX,1				; /2（漢字数）
STRING_PUT_LOOP:				;
	MOV	SI,STRING_PNT			; 文字列ポインタ
	MOV	AH,DS:[SI]			;
	MOV	AL,DS:[SI][1]			;
	CMP	AH,0				; end of string.
	JMPEQ	STRING_PUT_EXIT			;

	PUSH	CX				;

	MOV	STRING_WBUF,AH			; 文字列ワードバッファ
	MOV	STRING_WBUF[1],AL		;

	CMP	AX,"＠"				; 私の名字
	JMPEQ	STRING_PUT_SECOND_NAME		;

	CMP	AX,"＄"				; 娘の名前
	JE	STRING_PUT_FIRST_NAME		;

	CMP	AX,"０"				;
	JB	STRING_PUT_NORMAL		;
	CMP	AX,"９"				;
	JNBE	STRING_PUT_NORMAL		;

	JMP	STRING_PUT_ANK			;

STRING_PUT_NORMAL:				;
	MOV	SI,OFFSET STRING_WBUF		; 文字列ワードバッファ
	MOV	AX,TEXT_PNT_X			; location x point.
	MOV	BX,TEXT_PNT_Y			; location y point.
	CALL	VTXPOR				; vram text print OR.
;*;	CALL	VTXPFC				; vram text print fuchi.
	ADD	TEXT_PNT_X,2			; location x point.
	JMP	STRING_PUT_NEXT			;

STRING_PUT_ANK:					;
	MOV	SI,OFFSET STRING_WBUF		; 文字列ワードバッファ
	MOV	AX,DS:[SI]			;
	XCHG	AH,AL				;
	SUB	AX,"０"-'0'			;
	MOV	DS:[SI],AX			;
	MOV	AX,TEXT_PNT_X			; location x point.
	MOV	BX,TEXT_PNT_Y			; location y point.
	CALL	MBTPRN				; BIG string. 
	ADD	TEXT_PNT_X,2			; location x point.
	JMP	STRING_PUT_NEXT			;

STRING_PUT_SECOND_NAME:				;
	MOV	SI,OFFSET NAME_SECOND		; ファミリーネーム
	MOV	AX,TEXT_PNT_X			; location x point.
	MOV	BX,TEXT_PNT_Y			; location y point.
	CALL	VTXPOR				; vram text print OR.
;*;	CALL	VTXPFC				; vram text print fuchi.
	ADDX	TEXT_PNT_X,LEN_NAME_SECOND	; ファミリーネーム長さ
	ADD	STRING_PNT,4			; 文字列ポインタ
	JMP	STRING_PUT_NEXT			;

STRING_PUT_FIRST_NAME:				;
	MOV	SI,OFFSET NAME_FIRST		; ファーストネーム
	MOV	AX,TEXT_PNT_X			; location x point.
	MOV	BX,TEXT_PNT_Y			; location y point.
	CALL	VTXPOR				; vram text print OR.
;*;	CALL	VTXPFC				; vram text print fuchi.
	ADDX	TEXT_PNT_X,LEN_NAME_FIRST	; ファーストネーム長さ
	ADD	STRING_PNT,4			; 文字列ポインタ
	JMP	STRING_PUT_NEXT			;
STRING_PUT_NEXT:				;
	ADD	STRING_PNT,2			; 文字列ポインタ

	POP	CX				;
	LOOP	STRING_PUT_REPERT		;
	JMP	STRING_PUT_EXIT			;
STRING_PUT_REPERT:				;
	JMP	STRING_PUT_LOOP			;

STRING_PUT_EXIT:
	RET
STRING_PUT	ENDP


; ****************************************************
;	string length.
;	-i- SI : source string.
;	-o- CX : string length.
; ****************************************************

STRXLEN	PROC	NEAR
	PUSH	ES
	PUSH	AX
	PUSH	DI

	MOV	AX,DS
	MOV	ES,AX
	MOV	CX,256
	MOV	DI,SI
	MOV	AL,0
	REPNE	SCASB
	DEC	DI
	MOV	CX,DI
	SUB	CX,SI

	POP	DI
	POP	AX
	POP	ES
	RET
STRXLEN	ENDP

; ****************************************************
;	KANJI search string.
;	-i- SI : source string.
;	    CX : string length.
;	    AX : search word.
;	-o- DI : point.
;	    AX : 1=find,0=undefind.
; ****************************************************

K_INSTR	PROC	NEAR
	XCHG	AH,AL		; hi<>low
	SHR	CX,1		; word counter.

	MOV	BX,DS
	MOV	ES,BX
	MOV	DI,SI
	REPNE	SCASW
	JNE	K_INSTR_UNDEF
	DEC	DI
	DEC	DI

K_INSTR_FIND:
	MOV	AX,1			; 1=find
	RET
K_INSTR_UNDEF:
	MOV	AX,0			; 0=undefind.
	RET
K_INSTR	ENDP


CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	NAME_FIRST:BYTE		; ファーストネーム
EXTRN	NAME_SECOND:BYTE	; ファミリーネーム
EXTRN	LEN_NAME_FIRST:WORD	; ファーストネーム長さ
EXTRN	LEN_NAME_SECOND:WORD	; ファミリーネーム長さ

EXTRN	R_SR_CHR_ADRS:WORD	; 台詞・キャラクタアドレス

EXTRN	IPLMSW:WORD		; パレットエフェクト単位時間(VSYNC)

EXTRN	CRTSKP:WORD		; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)

FLAG_CANCEL	DW	0		; キャンセルフラグ

STR_LEN		DW	0		; 文字列長さ
STR_WIDE	DW	0		; 文字列表示長さ
STRING_PNT	DW	0		; 文字列ポインタ
STRING_WBUF	DB	"  ",0,0	; 文字列ワードバッファ
TEXT_PNT_X	DW	0		; location x point.
TEXT_PNT_Y	DW	0		; location y point.

TEXT_WAIT_ADD	DW	0		; テキスト待ち時間合計

TEXT_CEN_X	DW	40		; text center x.
TEXT_CEN_Y	DW	332-30		; text center y.
TEXT_HI_POSI	DW	0		; text hight position.
TEXT_HIGHT_ADRS	DW	TEXT_HIGHT	; text hight address.

TEXT_HIGHT	LABEL	WORD		;
		DW	324		;0
		DW	324+18		;1
		DW	324+18*2	;2
		DW	324+18*3	;3
		DW	324+18*4	;4

TEXT_HIGHT2	LABEL	WORD		;
		DW	276		;0
		DW	276+24		;1
		DW	276+24*2	;2
		DW	276+24*3	;3
		DW	276+24*4	;4
		DW	276+24*5	;5
		DW	276+24*6	;6
		DW	276+24*7	;7
		DW	276+24*8	;8
		DW	276+24*9	;9

TEXT_HIGHT3	LABEL	WORD		;
		DW	178		;0
		DW	178+24		;1
		DW	178+24*2	;2
		DW	178+24*3	;3
		DW	178+24*4	;4
		DW	178+24*5	;5

;*;		DW	328-30		;0
;*;		DW	328-30+18	;1
;*;		DW	328-30+18*2	;2
;*;		DW	328-30+18*3	;3
;*;		DW	328-30+18*4	;4

DATA	ENDS

	END
;
;	end of "OPENING.ASM"
;
