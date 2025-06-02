; "ENDING.ASM" PC-9801UV11 make by R.H 1991/04/22
;
;
;	「子育て」
;
;	エンディング
;
;	ENDING			; エンディング
;	ENDING_ROLL_TEST	; エンディング・ロールテスト
;
;	1☆特別職☆
;
;	2☆特級職☆
;
;	3☆上級職☆
;
;	4☆中級職☆
;
;	5☆下級職☆
;
;
;	 ☆特別職☆
;		 1＊女王の場合＊
;		 2＊姫の場合＊
;	 ☆特級職☆
;		 3＊長寿の場合＊
;		 4＊将軍＊
;		 5＊王立アカデミー総裁＊
;		 6＊王宮魔術師＊
;		 7＊貴族の妻１＊
;		 8＊王の側室＊
;		 9＊司祭＊
;	 ☆上級職☆
;		 10＊近衛の騎士＊
;		 11＊近衛隊長＊
;		 12＊練金術師＊
;		 13＊魔導士＊
;		 14＊貴族の妻２＊
;		 15＊貴族の側室＊
;		 16＊上級尼僧＊
;	 ☆中級職☆
;		 17＊百姓の妻＊
;		 18＊木コリ＊
;		 19＊文士＊
;		 20＊魔法使い＊
;		 21＊商家の妻＊
;		 22＊酒場の女の子＊
;		 23＊尼僧＊
;	 ☆下級職☆
;		 24＊傭兵＊
;		 25＊賞金稼ぎ＊
;		 26＊詐欺師＊
;		 27＊旅の魔法使い＊
;		 28＊高級娼婦＊
;		 29＊売春婦＊
;		 30＊出戻り＊
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	KOSO3.INC
INCLUDE	..\KOSO6\KYOKU.INC

DTA		EQU	0	; SEGDOS で示される
				; ＤＯＳインターフェースセグメント内の
				; ＤＴＡ領域のオフセットアドレス
				; 詳細は'DISKRD.ASM'を参照してください

TEXT_LENGTH	EQU	33000	; テキスト長さ

ROLL_1_LEN	EQU	400+70-30+2;-60	; ロール１長さ
ROLL_2_LEN	EQU	600-110+32+25	; ロール２長さ

TM_OVLP_TIME	EQU	11	; オーバラップタイム
TM_BBOVTM	EQU	17	; パターンＰＵＴオーバラップタイム
TM_PIC_PUT	EQU	60*3+40	; 絵のＰＵＴ時間
TM_PIC_PUT2	EQU	60*4+30	; 絵のＰＵＴ時間２
TM_PIC_PUT3	EQU	60*2+30	; 絵のＰＵＴ時間３
TM_ROLL_SET	EQU	30	; ロールセット時間

FREAM_XX	EQU	20-1	; 表示位置Ｘ
FREAM_YY	EQU	60-8	; 表示位置Ｙ
FREAM_XL	EQU	40+2	; 大きさＸ
FREAM_YL	EQU	180+16	; 大きさＹ

FRM_ARA_XX	EQU	20-2	; フレーム外周表示位置Ｘ
FRM_ARA_YY	EQU	60-16	; フレーム外周表示位置Ｙ
FRM_ARA_XL	EQU	40+4	; フレーム外周大きさＸ
FRM_ARA_YL	EQU	200	;180+32	; フレーム外周大きさＹ
FRM_ARA_YY2	EQU	60-16+200	; フレーム外周表示位置Ｙ2
FRM_ARA_YL2	EQU	12		; フレーム外周大きさＹ2

PUT_XX		EQU	20	; イベントウインドウＸ位置
PUT_YY		EQU	60	; イベントウインドウＹ位置
PUT_XXL		EQU	40	; イベントウインドウＸサイズ
PUT_YYL		EQU	180	; イベントウインドウＹサイズ

SER_XX1		EQU	5	; オーバラップＸ位置
SER_YY1		EQU	272	; オーバラップＹ位置
SER_XX2		EQU	70	; オーバラップＸサイズ
SER_YY2		EQU	116	; オーバラップＹサイズ

WAIT_XX		EQU	74	; カーソルＸ座標
WAIT_YY		EQU	368	; カーソルＹ座標

TIME_S_MAAI	EQU	30	; 台詞間合い

OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味


; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチン
; ****************************************************

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
SUBLL	PROC	FAR
	ENDM

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチンの終り
; ****************************************************

FEND	MACRO	SUBLL

SUBLL	ENDP
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２セグメントからＣＯＤＥセグメントへ
; ****************************************************

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

; ****************************************************
;	ＣＯＤＥセグメントからＲ＿ＳＥＧ２セグメントへ
; ****************************************************

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２　から　ＣＯＤＥ　へ　ＣＡＬＬ
; ****************************************************

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
	ASSUME	CS:R_SEG2,DS:DATA
L1:	CALL	L2	
	ENDM


TTIME_SET	MACRO	TTT
	MOV	AX,TTT		; wait timer count.
	CALL	TTMVST2		; V-SYNC timer2 set.
	ENDM

TTIME_SET2	MACRO	TTT
	MOV	AX,TTT		; wait timer count.
	CALL	TTMVST3		; V-SYNC timer3 set.
	ENDM


TTIME_WAIT	MACRO
	LOCAL	L1,L2
L1:
	TEST	BYTE PTR KYTBLS[0],1B		; key code「ESC」
	JNZ	L2		; skip
	CALL	TTMVCK2		; V-SYNC timer2 check.
	CMP	AX,0		; 0=timer now, 1=timer end.
	JE	L1		;
L2:
	ENDM

TTIME_WAIT2	MACRO
	LOCAL	L1,L2
L1:
	TEST	BYTE PTR KYTBLS[0],1B		; key code「ESC」
	JNZ	L2		; skip
	CALL	TTMVCK3		; V-SYNC timer3 check.
	CMP	AX,0		; 0=timer now, 1=timer end.
	JE	L1		;
L2:
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

MOVXBW	MACRO	DEST,SOUR_BYTE
	MOV	AH,0
	MOV	AL,SOUR_BYTE
	MOV	DEST,AX
	ENDM



R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA


; ****************************************************
;	エンディング
;	-I- SLCT_CLASS : 階級選択
;	    SLCT_WORKS : 仕事選択
; ****************************************************

FUNC	EENDING,ENDING
	PUSH	OVLP_TIME		; オーバラップタイム
	PUSH	BBOVTM			; パターンＰＵＴオーバラップタイム

	MOV	OVLP_TIME,TM_OVLP_TIME	; オーバラップタイム
	MOV	BBOVTM,TM_BBOVTM	; パターンＰＵＴオーバラップタイム

	CALL	TEXT_OPEN		; テキストＯＰＥＮ

	MOVX	OCHI_KIND,SLCT_WORKS	; 仕事選択
	CALL	PUT_END_LOAD		; オチのロード
CODE_IN
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	FEDOUT			; Ｆ．Ｏ
	CALL	VRMCLR			; ＶＲＡＭクリア

	MOV	DX,16			; 夏のパレットのパターン番号
	CALL	PT_PALET_ST		; パレットのセット
	CALL	NORMIN			; ノーマルカラー
CODE_OUT
	CALL	SERIFU_SRT		; 台詞ＰＵＴスタート
CODE_IN
	MUSIC	KYOKU_ENDING		; ｴﾝデｨﾝグ
CODE_OUT
	CALL	MAIN_ENDING		; エンディングメイン

	TTIME_SET2	TM_ROLL_SET	; ロールセット時間
	MOV	ES,SEGTXT		; テキストセグメント
	MOV	BX,TXTTOP		; テキストの先頭
	CALLC	DATAROLL		; データ・ロール作成
	TTIME_WAIT2			;

	MOV	AX,10			; Ｖ割込み処理の指定インターバル
	CALLC	PLTINTSPD		; パレット・割込み処理スピード
	CALLC	PLTFOS			; Ｆ・Ｏ（フェードアウト）／時分割初期
	CALLC	PLTINTSW		; パレット・割込み処理スイッチ
;*;	CALLC	PLTINTWT		; パレット・割込み処理終了待ち

;*;	CALLC	FEDOUT			; F.O.


	MOV	ES,SEGTXT		; テキストセグメント
	MOV	BX,TXTTOP		; テキストの先頭
	MOV	CX,ROLL_1_LEN		; ロール１長さ
	CALLC	STFROLL			; スタッフ・ロール

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	BX,ADRS_CM_TBL[11*2]	; 共通文関係アドレステーブル
	MOV	CX,ROLL_2_LEN		; ロール２長さ
	CALLC	STFROLL			; スタッフ・ロール

	CALL	TEXT_CLOSE		; テキストＣＬＯＳＥ

	POP	BBOVTM			; パターンＰＵＴオーバラップタイム
	POP	OVLP_TIME		; オーバラップタイム

	JMP	$
	RET
FEND	EENDING


; ****************************************************
;	エンディング・ロールテスト
; ****************************************************

FUNC	EENDING_ROLL_TEST,ENDING_ROLL_TEST
	MOV	DX,16			; 夏のパレットのパターン番号
	CALLC	PT_PALET_ST		; パレットのセット
	CALLC	NORMIN			; ノーマルカラー

	CALL	TEXT_OPEN		; テキストＯＰＥＮ

	CALL	SERIFU_SRT		; 台詞ＰＵＴスタート

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	BX,TXTTOP		; テキストの先頭
	CALLC	DATAROLL		; データ・ロール作成

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	BX,TXTTOP		; テキストの先頭
	MOV	CX,ROLL_1_LEN		; ロール１長さ
	CALLC	STFROLL			; スタッフ・ロール

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	BX,ADRS_CM_TBL[11*2]	; 共通文関係アドレステーブル
	MOV	CX,ROLL_2_LEN		; ロール２長さ
	CALLC	STFROLL			; スタッフ・ロール
	RET
FEND	EENDING_ROLL_TEST


; ****************************************************
;	テキストＯＰＥＮ
; ****************************************************

TEXT_OPEN	PROC	NEAR
	TTIME_SET	0		; タイミング・タイマ
	TTIME_SET2	0		; タイミング・タイマ

	CALLC	PT_END_TXT_LD		; エンディング・テキスト・ロード

	MOVX	SEGTXT,SEGPAT1		; (パーツバッファ＃１)へロード
	MOVX	TXTTOP,TOPPAT1		; (パーツバッファ＃１)へロード
	ADD	TXTTOP,31000		; (パーツバッファ＃１後半）
	MOVX	TXTLEN,TEXT_LENGTH	; テキスト長さ
	CALL	TUNLCK			; unlock edit.

	CALLC	STRZEROC		; 文字列バッファ０クリア
	MOV	ES,SEGPAT1		; パーツバッファ＃１セグメント
	MOV	SI,TOPPAT1		; 先頭オフセット／テキストの先頭
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; string length.
	CALLC	STRSET			; 文字列バッファセット

	CALL	TEXT_LINKS		; テキストの結合処理

	MOV	DX,2			; 2=エンデイング
	CALLC	OPENTEXTMODE		; オープニング・テキストモード
	RET
TEXT_OPEN	ENDP


; ****************************************************
;	テキストＣＬＯＳＥ
; ****************************************************

TEXT_CLOSE	PROC	NEAR
	MOV	DX,1			; 1=オープニング
	CALLC	OPENTEXTMODE		; オープニング・テキストモード
	RET
TEXT_CLOSE	ENDP


; ****************************************************
;	エンディングメイン
; ****************************************************

MAIN_ENDING	PROC	NEAR
	CALL	SELECT_CLASS		; 階級選択
	CALL	SELECT_WORKS		; 仕事選択
	CALL	ENDING_SEQ		; エンディング・シーケンス
	RET
MAIN_ENDING	ENDP


; ****************************************************
;	エンディング・シーケンス
; ****************************************************

ENDING_SEQ	PROC	NEAR
	MOVX	SEGTXT,SEGPAT1		; (パーツバッファ＃１)へロード

	MOV	SERIFU_MODE,1		; 台詞モード 1=ＰＵＴ,2=ＯＬ

	MOVX	PR_STRING,POINT_SAISYO	; 最初の決まり文句
	CALL	SERIFU_LOOP		; 台詞ループ

	CMP	SLCT_CLASS,5		; 階級選択 ☆下級職☆
	JE	ENDING_SEQ_5		;
	MOVX	PR_STRING,POINT_DEDASI	; 共通文１の先頭
	CALL	SERIFU_LOOP		; 台詞ループ
ENDING_SEQ_5:				;

	MOVX	PR_STRING,POINT_HONBUN	; 本文の先頭
	CALL	SERIFU_LOOP		; 台詞ループ

	MOVX	PR_STRING,POINT_KETSU	; 共通文２の先頭
	CALL	SERIFU_LOOP		; 台詞ループ

	MOV	TIMING_TIME,60*2	; タイミング・タイマ
	CALL	WAIT_TIMER		; 時間待ち

	TTIME_SET2	TM_PIC_PUT3	; 絵のＰＵＴ時間３
	MOV	SERIFU_MODE,2		; 台詞モード 1=ＰＵＴ,2=ＯＬ
	CALL	SERIFU_SHOW		; 台詞表示
	TTIME_WAIT2			;

	MOV	TIMING_TIME,0		; タイミング・タイマ
	CALL	WAIT_TIMER		; 時間待ち
	RET
ENDING_SEQ	ENDP


; ****************************************************
;	階級選択
;	-I- SLCT_CLASS   : 階級選択
;	-O- POINT_SAISYO : 最初の決まり文句
;	    POINT_DEDASI : 共通文１の先頭
;	    POINT_KETSU  : 共通文２の先頭
; ****************************************************

SELECT_CLASS	PROC	NEAR
	MOV	BX,SLCT_CLASS			; 階級選択
	SHL	BX,1				;
	SHL	BX,1				; * 4
	MOVX	POINT_DEDASI,DS:ADRS_CM_TBL[BX]	; 共通文
	MOVX	POINT_KETSU, DS:ADRS_CM_TBL[BX][2] ; 共通文

	CMP	SLCT_CLASS,5			; 階級選択 ☆下級職☆
	JNE	SELECT_CLASS_22			;
	MOV	POINT_DEDASI,0			; 共通文
	MOVX	POINT_KETSU,DS:ADRS_CM_TBL[10*2] ;
SELECT_CLASS_22:

	MOVX	POINT_SAISYO,ADRS_CM_TBL[2]	; 最初の決まり文句

SELECT_CLASS_EXIT:
	RET
SELECT_CLASS	ENDP


; ****************************************************
;	仕事選択
;	-I- SLCT_WORKS   : 仕事選択
;	-O- POINT_HONBUN : 本文の先頭
; ****************************************************

SELECT_WORKS	PROC	NEAR
	MOV	BX,SLCT_WORKS			; 仕事選択
	SHL	BX,1				; * 2
	MOVX	POINT_HONBUN,DS:ADRS_ZZ_TBL[BX]	; 本文関係アドレステーブル
	RET
SELECT_WORKS	ENDP



; ****************************************************
;	テキストの結合処理
;	-I- SEGTXT        : テキストセグメント
;	    TXTTOP        : テキストの先頭
;	    TXTLEN        : テキストデータ長さ
; ****************************************************

TEXT_LINKS	PROC	NEAR
	MOV	ID_SCH_POINTER,OFFSET ADRS_CM_TBL ; 共通文関係アドレステーブル
	MOV	ID_NAME_TOP,   OFFSET STR_TXTID_CM	; "CM"  共通文関係
	MOV	ID_NUMBER_TOP, OFFSET STR_TXTID_CM_N	; "012" 共通文番号
	CALL	TEXT_ID_SCH			; テキストＩＤ・検索

	MOV	ID_SCH_POINTER,OFFSET ADRS_ZZ_TBL ; 本文関係アドレステーブル
	MOV	ID_NAME_TOP,   OFFSET STR_TXTID_ZZ	; 本文関係
	MOV	ID_NUMBER_TOP, OFFSET STR_TXTID_ZZ_N	; 本文関係
	CALL	TEXT_ID_SCH			; テキストＩＤ・検索

;*;	CALL	DBG_DMP				; デバック・ダンプ
	RET
TEXT_LINKS	ENDP



; ****************************************************
;	テキストＩＤ・検索
;	-I- ID_NAME_TOP   : ＩＤ文字列の先頭	 "CM012"
;	    ID_NUMBER_TOP : ＩＤ文字列番号の先頭   "012"
;	    ID_SCH_POINTER: ＩＤ検索ポインタ	=ADRS_CM_TBL
;	    SEGTXT        : テキストセグメント
;	    TXTTOP        : テキストの先頭
;	    TXTLEN        : テキストデータ長さ
; ****************************************************

TEXT_ID_SCH	PROC	NEAR
	MOV	ID_SEQ_NUMBER,0			; ＩＤ順次番号

	MOVX	TXT_POINTER,TXTTOP		; テキストの先頭

	MOV	BX,ID_SCH_POINTER		; ＩＤ検索ポインタ
	MOV	CX,DS:[BX]			;
TEXT_ID_SCH_LOOP:
	PUSH	CX				;
	ADD	ID_SCH_POINTER,2		; ＩＤ検索ポインタ
	INC	ID_SEQ_NUMBER			; ＩＤ順次番号

	MOV	DX,ID_SEQ_NUMBER		; ＩＤ順次番号
	CALLC	DECSTR				; "00012"
	MOV	AH,DS:[SI][2]			;
	MOV	AL,DS:[SI][3]			;
	MOV	BH,DS:[SI][4]			;
	MOV	DI,ID_NUMBER_TOP		; ＩＤ文字列番号の先頭
	MOV	DS:[DI][0],AH			;
	MOV	DS:[DI][1],AL			;
	MOV	DS:[DI][2],BH			;

	MOV	SI,ID_NAME_TOP			; ＩＤ文字列の先頭
	MOV	ES,SEGTXT			; テキストセグメント
	MOV	DI,TXT_POINTER			; テキストの先頭
	MOV	CX,TXTLEN			; テキストデータ長さ
	CALL	SCH_STRING			; 文字列の検索
	CMP	AX,0				; 0=なし,1=あり
	JE	TEXT_ID_SCH_NEXT		;

	ADD	DI,5				; +5
	MOV	BX,ID_SCH_POINTER		; ＩＤ検索ポインタ
	MOV	DS:[BX],DI			; 検索位置

TEXT_ID_SCH_NEXT:
	POP	CX				;
	LOOP	TEXT_ID_SCH_LOOP


	RET
TEXT_ID_SCH	ENDP


; ****************************************************
;	文字列の検索
;	-I- DS:[SI]  : 検索文字列 ５文字
;	    ES:[DI]  : 検索対象文字列
;	    CX       : 長さ
;	-O- AX       : 0=なし,1=あり
;	    ES:[DI]  : 検索位置
; ****************************************************

SCH_STRING	PROC	NEAR
;*;	CODE_IN
;*;	CALL	PRINT
;*;	CODE_OUT
SCH_STRING_RETRY:
	MOV	AL,DS:[SI]		; 検索文字列
	REPNE	SCASB			; ES:[DI++] から AL を検索する
	JNE	SCH_STRING_NONE		;

	DEC	DI			;

	PUSH	CX			;
	PUSH	SI			;
	PUSH	DI			;
	MOV	CX,5			;
	REPE	CMPSB			;
	POP	DI			;
	POP	SI			;
	POP	CX			;
	JE	SCH_STRING_SCH		;

	INC	DI			;
	JMP	SCH_STRING_RETRY	;

SCH_STRING_SCH:
	MOV	AX,1			; 1=あり
	RET
SCH_STRING_NONE:
	MOV	AX,0			; 0=なし
	RET
SCH_STRING	ENDP


; ****************************************************
;	台詞ＰＵＴスタート
; ****************************************************

SERIFU_SRT	PROC	NEAR
	CODE_IN
	EXTRN	OPEN_NAME_LOAD:NEAR	; オープニング・名前ロード
	CALL	OPEN_NAME_LOAD		; オープニング・名前ロード
	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	VRMCLR			;
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	CALL	VRMCLR			;
	CODE_OUT
	RET
SERIFU_SRT	ENDP


; ****************************************************
;	台詞ループ
;	-I- SEGTXT : テキストセグメント
;	    PR_STRING : 表示文字列アドレス
; ****************************************************

SERIFU_LOOP	PROC	NEAR
	CALL	SERIFU_HOME		; 台詞ホームポジション

SERIFU_LOOP_LOOP:
	CALL	SERIFU_GET		; 台詞ＧＥＴ
	CMP	PICTUER_N,OFFF		; ロード絵の番号（OFFF:無し）
	JNE	SERIFU_LOOP_PICTUER	;
	CMP	FLAG_LAST,0		; 最後の台詞フラグ
	JNE	SERIFU_LOOP_LAST_PRINT	;
	CMP	FLAG_KUGIRI,0		; 台詞の区切りフラグ
	JNE	SERIFU_LOOP_KUGIRI	;

SERIFU_LOOP_PRINT:
	CALL	SERIFU_PRINT		; 台詞ＰＲＩＮＴ
	JMP	SERIFU_LOOP_LOOP_NEXT	;

SERIFU_LOOP_PICTUER:
	CMP	PICTUER_N,0		; ロード絵の番号
	JE	SERIFU_LOOP_LOOP_NEXT	;
	CMP	PICTUER_N,1		; ロード絵の番号
	JE	SERIFU_LOOP_PICTUER2	;
	TTIME_SET2	TM_PIC_PUT	; 絵のＰＵＴ時間
	JMP	SERIFU_LOOP_PICTUER3	;
SERIFU_LOOP_PICTUER2:
	TTIME_SET2	TM_PIC_PUT2	; 絵のＰＵＴ時間２
SERIFU_LOOP_PICTUER3:
	CALL	SERIFU_CLEAR2		; 台詞クリア２
	CALL	PICTUER_SHOW		; 絵の表示
	TTIME_WAIT2			;
	JMP	SERIFU_LOOP_LOOP_NEXT	;

SERIFU_LOOP_KUGIRI:
	CALL	SERIFU_PRINT		; 台詞ＰＲＩＮＴ
	CALL	SERIFU_SHOW		; 台詞表示
	CALL	WAIT_TIMER		; 時間待ち
	CALL	SERIFU_HOME		; 台詞ホームポジション
	JMP	SERIFU_LOOP_LOOP_NEXT	;

SERIFU_LOOP_LAST_PRINT:
;;	CALL	SERIFU_PRINT		; 台詞ＰＲＩＮＴ
;;	CALL	SERIFU_SHOW		; 台詞表示
;;	CALL	SERIFU_HOME		; 台詞ホームポジション
	JMP	SERIFU_LOOP_LOOP_E	;

SERIFU_LOOP_LOOP_NEXT:
	JMP	SERIFU_LOOP_LOOP	;

SERIFU_LOOP_LOOP_E:
	RET
SERIFU_LOOP	ENDP


; ****************************************************
;	台詞ＧＥＴ
;	-I-   SEGTXT    : テキストセグメント
;	-I/O- PR_STRING : 表示文字列アドレス
;	-O-   STR_BUFF  : 文字列バッファ
;	      PICTUER_N : ロード絵の番号（OFFF:無し）
;	      FLAG_LAST : 最後の台詞フラグ
;	      FLAG_KUGIRI: 台詞の区切りフラグ
; ****************************************************

SERIFU_GET	PROC	NEAR
	CALLC	STRZEROC		; 文字列バッファ０クリア

	MOV	FLAG_LAST,0		; 最後の台詞フラグ
	MOV	FLAG_KUGIRI,0		; 台詞の区切りフラグ
	MOV	PICTUER_N,OFFF		; ロード絵の番号（無し）

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	SI,PR_STRING		; 表示文字列アドレス
SERIFU_GET_LOOP_00:
	MOV	AL,ES:[SI]		; get.
	INC	SI			;
	CMP	AL,0			;
	JE	SERIFU_GET_LAST		;
	CMP	AL,' '			;
	JB	SERIFU_GET_LOOP_00	;
	DEC	SI			;

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; string length.
SERIFU_GET_LOOP:
	MOV	AL,ES:[SI]		; get.
	INC	SI			;
	CMP	AL,'&'			; 絵のロード
	JE	SERIFU_GET_PICTUER	;
	CMP	AL,'$'			; 台詞終り
	JE	SERIFU_GET_LAST		;
	CMP	AL,'/'			; 台詞区切り
	JE	SERIFU_GET_KUGIRI	;
	CMP	AL,0DH			; CR/LF
	JE	SERIFU_GET_LOOP_E	;
	CMP	AL,' '			;
	JB	SERIFU_GET_NEXT		;

	MOV	DS:[DI],AL		; put.
	INC	DI			;

SERIFU_GET_NEXT:
	LOOP	SERIFU_GET_LOOP		;
SERIFU_GET_LOOP_E:

	MOV	PR_STRING,SI		; 表示文字列アドレス
	RET

SERIFU_GET_KUGIRI:			;
	MOV	PR_STRING,SI		; 表示文字列アドレス
	MOV	FLAG_KUGIRI,1		; 台詞の区切りフラグ
	CALL	TIMING_GET		; タイミングＧＥＴ
	RET

SERIFU_GET_LAST:			;
	MOV	PR_STRING,SI		; 表示文字列アドレス
	MOV	FLAG_LAST,1		; 最後の台詞フラグ
	RET

SERIFU_GET_PICTUER:			;
	MOV	AL,ES:[SI]		;
	SUB	AL,'0'			; "&1"等
	MOV	AH,0			;
	MOV	PICTUER_N,AX		; ロード絵の番号（無し）

	INC	SI			;
	MOV	PR_STRING,SI		; 表示文字列アドレス
	RET
SERIFU_GET	ENDP


; ****************************************************
;	タイミングＧＥＴ
;	-I/O- PR_STRING   : 表示文字列アドレス
;	-O-   TIMING_TIME : タイミング・タイマ
; ****************************************************

TIMING_GET	PROC	NEAR
	MOV	ES,SEGTXT		; テキストセグメント
	MOV	SI,PR_STRING		; 表示文字列アドレス
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	MOV	CX,STR_VAL_LEN		; string length.（数値表示用）
	CALLC	STRSETZ			; 文字列バッファセット

	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRDEC			; dec string to DX reg.
	MOV	TIMING_TIME,DX		; タイミング・タイマ

	MOVX	ES,DS			;
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRLENSPZ		; 文字列長さスペースまで
	ADD	PR_STRING,CX		; 表示文字列アドレス
	RET
TIMING_GET	ENDP


; ****************************************************
;	台詞ホームポジション
; ****************************************************

SERIFU_HOME	PROC	NEAR
	MOV	TEXT_HIGHT,0		; テキスト段
	RET
SERIFU_HOME	ENDP

; ****************************************************
;	台詞クリア２
; ****************************************************

SERIFU_CLEAR2	PROC	NEAR
	CODE_IN
	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	VRMCLR			;
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	CODE_OUT
	CALL	SERIFU_SHOW		; 台詞表示
	CALL	SERIFU_HOME		; 台詞ホームポジション
	RET
SERIFU_CLEAR2	ENDP


; ****************************************************
;	台詞ＰＲＩＮＴ
;	-I-   STR_BUFF  : 文字列バッファ
; ****************************************************

SERIFU_PRINT	PROC	NEAR
	CALLC	VRMWT1			; ＶＲＡＭ１アクセス

	MOV	AX,0			; 0=16x16  1=32x32  2=16x24  3=16x32
	CALLC	VTXSIZ			; character size set.
	MOV	AX,15			; character color 0-15
	CALLC	VTXCOL			; character color set.
	MOV	AX,15			; font color.
	CALLC	MITCOL			; mini string color.

	MOV	AX,TEXT_HIGHT		; テキスト段
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALL	STRING_PUT		; 文字列ＰＵＴ

	INC	TEXT_HIGHT		; テキスト段

	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	RET
SERIFU_PRINT	ENDP


; ****************************************************
;	台詞表示
; ****************************************************

SERIFU_SHOW	PROC	NEAR
	MOV	OL_XX1,SER_XX1		; オーバラップＸ位置
	MOV	OL_YY1,SER_YY1		; オーバラップＹ位置
	MOV	OL_XX2,SER_XX2		; オーバラップＸサイズ
	MOV	OL_YY2,SER_YY2		; オーバラップＹサイズ

	CMP	SERIFU_MODE,1		; 台詞モード 1=ＰＵＴ,2=ＯＬ
	JE	SERIFU_SHOW_8		;
	CALL	VRAM_OL			; ＶＲＡＭオーバラップ
	RET
SERIFU_SHOW_8:
	TTIME_SET	TIME_S_MAAI	; 台詞間合い
	CALL	VRAM_CLEAR		; ＶＲＡＭクリア
	TTIME_WAIT
	CALL	VRAM_COPY		; ＶＲＡＭＣＯＰＹ
	RET

;*;	CODE_IN
;*;	CALL	VRMWT1			; ＶＲＡＭ１アクセス
;*;	MOVE_IMG	ARAVRM,ARA003,5,284,70,116,5,284
;*;	CALL	VRMCLR			;
;*;	CALL	VRMWT0			; ＶＲＡＭ０アクセス
;*;	OL_IMG		ARA003,ARAVRM,5,284,70,116,5,284
;*;	CODE_OUT
;*;	RET
SERIFU_SHOW	ENDP


; ****************************************************
;	文字列ＰＵＴ
;	-I-   DS:SI   : string. (null=end of string)
;	      AX      : text hight position.
; ****************************************************

STRING_PUT	PROC	NEAR
	CALLC	OPENTEXTPR		; オープニング・テキスト表示
	RET
STRING_PUT	ENDP


; ****************************************************
;	絵の表示
;	-I- PICTUER_N : ロード絵の番号（OFFF:無し）
;	    SLCT_WORKS: 仕事選択
; ****************************************************

PICTUER_SHOW	PROC	NEAR
	CMP	PICTUER_N,OFFF		; OFFF:無し
	JE	PICTUER_SHOW_EXIT	;
	CMP	PICTUER_N,0		; ロード絵の番号
	JE	PICTUER_SHOW_EXIT	;

	CMP	PICTUER_N,1		; ロード絵の番号
	JNE	PICTUER_SHOW_2		;
	MOV	OCHI_F_MODE,1		; オチフレームモード 1=ＰＵＴ
	CALL	PUT_END_FREAM		; オチフレームの表示
	JMP	PICTUER_SHOW_4		;
PICTUER_SHOW_2:
	CMP	PICTUER_N,3		; ロード絵の番号
	JNE	PICTUER_SHOW_3		;
	CALL	WHITE_IN		; ＷＨＩＴＥ・ＩＮ
	JMP	PICTUER_SHOW_4		;
PICTUER_SHOW_3:				;
PICTUER_SHOW_4:
	MOVX	OCHI_CUT,PICTUER_N	; ロード絵の番号（OFFF:無し）
	MOVX	OCHI_KIND,SLCT_WORKS	; 仕事選択
	CALL	PUT_END_VIEW		; オチの表示
PICTUER_SHOW_EXIT:
	RET
PICTUER_SHOW	ENDP


; ****************************************************
;	オチフレームの表示
;	-I- OCHI_F_MODE : オチフレームモード 1=ＰＵＴ,2=ＯＬ
; ****************************************************

PUT_END_FREAM	PROC	NEAR
	CALLC	VRMWT1			; ＶＲＡＭ１アクセス
	MOV	WDX1,FREAM_XX		; 表示位置Ｘ
	MOV	WDY1,FREAM_YY		; 表示位置Ｙ
	MOV	WDX2,FREAM_XL		; 大きさＸ
	MOV	WDY2,FREAM_YL		; 大きさＹ
	CALLC	WID_9_FLAME		; WINDOWS/フレーム９（オチ）
	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	MOV	OL_XX1,FRM_ARA_XX	; オーバラップＸ位置
	MOV	OL_YY1,FRM_ARA_YY	; オーバラップＹ位置
	MOV	OL_XX2,FRM_ARA_XL	; オーバラップＸサイズ
	MOV	OL_YY2,FRM_ARA_YL	; オーバラップＹサイズ

	CMP	OCHI_F_MODE,1		; オチフレームモード 1=ＰＵＴ,2=ＯＬ
	JNE	PUT_END_FREAM_5		;

	CALL	VRAM_COPY2		; ＶＲＡＭＣＯＰＹ２

	MOV	OL_YY1,FRM_ARA_YY2	; フレーム外周表示位置Ｙ2
	MOV	OL_YY2,FRM_ARA_YL2	; フレーム外周大きさＹ2
	CALL	VRAM_COPY2		; ＶＲＡＭＣＯＰＹ２

	RET
PUT_END_FREAM_5:
	CALL	VRAM_OL			; ＶＲＡＭオーバラップ
	RET
PUT_END_FREAM	ENDP


; ****************************************************
;	ＷＨＩＴＥ・ＩＮ
; ****************************************************

WHITE_IN	PROC	NEAR
	CODE_IN
	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	BOXPAA	FREAM_XX,FREAM_YY,FREAM_XX+FREAM_XL,FREAM_YY+FREAM_YL,15
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	CODE_OUT
	MOV	OL_XX1,PUT_XX		; イベントウインドウＸ位置
	MOV	OL_YY1,PUT_YY		; イベントウインドウＹ位置
	MOV	OL_XX2,PUT_XXL		; イベントウインドウＸサイズ
	MOV	OL_YY2,PUT_YYL		; イベントウインドウＹサイズ
	CALL	VRAM_OL			; ＶＲＡＭオーバラップ
	RET
WHITE_IN	ENDP


; ****************************************************
;	オチのロード
;	-I- OCHI_KIND : 落ちの種類
; ****************************************************

PUT_END_LOAD	PROC	NEAR
	MOV	DX,OCHI_KIND		; 落ちの種類
	CALLC	PT_OCHI_LD		; オチの絵ロード
	RET
PUT_END_LOAD	ENDP



; ****************************************************
;	オチの表示
;	-I- OCHI_CUT  : 落ちのカット番号
; ****************************************************

PUT_END_VIEW	PROC	NEAR
	MOV	DX,OCHI_CUT		; 落ちのカット番号
	MOV	AX,PUT_XX		; イベントウインドウＸ位置
	MOV	BX,PUT_YY		; イベントウインドウＹ位置
	CALLC	PT_OCHI_PUT		; オチの絵ＰＵＴ
	RET
PUT_END_VIEW	ENDP


; ****************************************************
;	ＶＲＡＭオーバラップ
;	-I- OL_XX1 : オーバラップＸ位置
;	    OL_YY1 : オーバラップＹ位置
;	    OL_XX2 : オーバラップＸサイズ
;	    OL_YY2 : オーバラップＹサイズ
; ****************************************************

VRAM_OL	PROC	NEAR
	CALLC	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	IMG_VRM_TO_03		; ＶＲＡＭ－＞仮想ＶＲＡＭ

	CODE_IN
	CALL	VRMCLR			;
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	OL_IMG		ARA003,ARAVRM,0,0,OL_XX2,OL_YY2,OL_XX1,OL_YY1
	CODE_OUT
	RET
VRAM_OL	ENDP


; ****************************************************
;	ＶＲＡＭＣＯＰＹ
;	-I- OL_XX1 : オーバラップＸ位置
;	    OL_YY1 : オーバラップＹ位置
;	    OL_XX2 : オーバラップＸサイズ
;	    OL_YY2 : オーバラップＹサイズ
; ****************************************************

VRAM_COPY	PROC	NEAR
	CALLC	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	IMG_VRM_TO_03		; ＶＲＡＭ－＞仮想ＶＲＡＭ
	CALLC	VRMCLR			;
	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	CALL	IMG_03_TO_VRM		; 仮想ＶＲＡＭ－＞ＶＲＡＭ
	RET
VRAM_COPY	ENDP


; ****************************************************
;	ＶＲＡＭＣＯＰＹ２
;	-I- OL_XX1 : オーバラップＸ位置
;	    OL_YY1 : オーバラップＹ位置
;	    OL_XX2 : オーバラップＸサイズ
;	    OL_YY2 : オーバラップＹサイズ
; ****************************************************

VRAM_COPY2	PROC	NEAR
	CALLC	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	IMG_VRM_TO_03		; ＶＲＡＭ－＞仮想ＶＲＡＭ
	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	CALL	IMG_03_TO_VRM		; 仮想ＶＲＡＭ－＞ＶＲＡＭ
	RET
VRAM_COPY2	ENDP


; ****************************************************
;	ＶＲＡＭ－＞仮想ＶＲＡＭ
; ****************************************************

IMG_VRM_TO_03	PROC	NEAR
	CODE_IN
	MOVE_IMG	ARAVRM,ARA003,OL_XX1,OL_YY1,OL_XX2,OL_YY2,0,0
	CODE_OUT
	RET
IMG_VRM_TO_03	ENDP


; ****************************************************
;	仮想ＶＲＡＭ－＞ＶＲＡＭ
; ****************************************************

IMG_03_TO_VRM	PROC	NEAR
	CODE_IN
	MOVE_IMG	ARA003,ARAVRM,0,0,OL_XX2,OL_YY2,OL_XX1,OL_YY1
	CODE_OUT
	RET
IMG_03_TO_VRM	ENDP

; ****************************************************
;	ＶＲＡＭクリア
;	-I- OL_XX1 : オーバラップＸ位置
;	    OL_YY1 : オーバラップＹ位置
;	    OL_XX2 : オーバラップＸサイズ
;	    OL_YY2 : オーバラップＹサイズ
; ****************************************************

VRAM_CLEAR	PROC	NEAR
	MOV	AX,OL_XX1		; オーバラップＸ位置
	MOV	BX,OL_YY1		; オーバラップＹ位置
	MOV	CX,OL_XX1		; オーバラップＸ位置
	MOV	DX,OL_YY1		; オーバラップＹ位置
	ADD	CX,OL_XX2		; オーバラップＸサイズ
	ADD	DX,OL_YY2		; オーバラップＹサイズ
	DEC	CX			; -1
	DEC	DX			; -1
	MOV	VX1,AX			; start point.
	MOV	VY1,BX			; start point.
	MOV	VX2,CX			; end point.
	MOV	VY2,DX			; end point.
	MOV	CX,0			; color palet number.
	CALLC	BOXPAL			; ＢＯＸペイント
	RET
VRAM_CLEAR	ENDP


; ****************************************************
;	ユーザＷＡＩＴ
; ****************************************************

USER_WAIT	PROC	NEAR
	MOV	AX,WAIT_XX		; カーソルＸ座標
	MOV	BX,WAIT_YY		; カーソルＹ座標
	CALLC	MSWWAT			; カーソルボタン待ち
	CALLC	MSCWATTM		; カーソルボタンＯＦＦ待ちタイマ付き
	RET
USER_WAIT	ENDP


; ****************************************************
;	暗号化処理
; ****************************************************

;	unlock edit.
;	-I- SEGTXT : dest segment address.
;	    TXTTOP : dest offset  address.テキストの先頭
;	    TXTLEN : data length. テキストデータ長さ

TUNLCK	PROC	NEAR
	MOV	AX,SEGTXT		; dest segment address.
	MOV	ES,AX			; dest segment address.
	MOV	BX,TXTTOP		; dest offset  address.テキストの先頭

	MOV	AL,BYTE PTR ES:[BX]	; １バイト目
	CMP	AL,LOCKID		; 暗号ＩＤ
	JNE	TUNLCK1			;
	MOV	AL,BYTE PTR ES:[BX][1]	; ２バイト目
	CMP	AL,LOCKID[1]		; 暗号ＩＤ
	JNE	TUNLCK1			;
	JMP	TUNLCK12		;
TUNLCK1:				;
	RET				; EXIT.
TUNLCK12:				;
	CALL	IDGET			; ID get.

	MOV	CX,TXTLEN		; data length. テキストデータ長さ
	MOV	SI,0			; code table pointer.
TUNLCK2:				;
	PUSH	CX			;
	MOV	AL,DS:LOCKCD[SI]	; lock code.
	SUB	BYTE PTR ES:[BX],AL	;
	INC	BX			; buffer pointer.
	INC	SI			; code table pointer.
	CMP	SI,6			;
	JL	TUNLCK6			;
	MOV	SI,0			; code table pointer.
TUNLCK6:				;
	POP	CX			;
	LOOP	TUNLCK2			;
TUNLCK9:
	CALL	TUNPLS			; テキスト圧縮フォーマットデータ復元

	RET
TUNLCK	ENDP


;	ID get.

IDGET	PROC	NEAR
	PUSH	DS		;
	MOV	CX,TXTLEN	; data length. テキストデータ長さ
	MOV	DI,TXTTOP	; dest offset  address.テキストの先頭
	MOV	SI,TXTTOP	; dest offset  address.テキストの先頭
	ADD	SI,2		; ID area.
	MOV	AX,SEGTXT	; dest segment address.
	MOV	ES,AX		; dest segment address.
	MOV	DS,AX		;
	REP	MOVSB		;
	POP	DS

	RET
IDGET	ENDP



;	テキスト圧縮フォーマットデータ復元

TUNPLS	PROC	NEAR
	MOV	AX,SEGTXT	; テキストバッファ／シナリオを置くところ
	MOV	BX,TXTTOP	; テキストバッファの先頭
	MOV	BPNTSG,AX	; ＦＣＢ／ＤＴＡ領域
	MOV	BPNTOF,BX	; string. DX:[SI]: バイナリデータ

	MOV	AX,SEGDOS	; ＤＯＳインターフェースセグメント
	MOV	ES,AX		;
	MOV	DI,DTA		; ＤＴＡ
	CALLC	BUNPLE		; 圧縮フォーマットデータ復元

	PUSH	DS		;
	MOV	CX,TXTLEN	; data length. テキストデータ長さ
	MOV	AX,SEGTXT	; テキストバッファ／シナリオを置くところ
	MOV	ES,AX		;
	MOV	DI,TXTTOP	; テキストバッファの先頭
	MOV	SI,DTA		; ＤＴＡ
	MOV	AX,SEGDOS	; ＤＯＳインターフェースセグメント
	MOV	DS,AX		;
	REP	MOVSB		;
	POP	DS

	RET
TUNPLS	ENDP


;	時間待ち
;	-I- TIMING_TIME : タイミング・タイマ

WAIT_TIMER	PROC	NEAR
;*;CODE_IN
;*;	PRV	"TIMING_TIME=",TIMING_TIME
;*;CODE_OUT
	TTIME_WAIT2
	TTIME_SET2	TIMING_TIME		; タイミング・タイマ
	RET
WAIT_TIMER	ENDP


;*;;	デバック・ダンプ
;*;
;*;DBG_DMP	PROC	NEAR
;*;	CODE_IN
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	CLS
;*;	PRF	"ADRS_CM_TBL[11]    /    ADRS_ZZ_TBL[30]"
;*;	MOV	BX,0
;*;	MOV	CX,10
;*;DBG_DMP_LOOP:
;*;	PUSH	CX
;*;
;*;	PUSH	BX
;*;	MOV	CX,3
;*;DBG_DMP_LOOP2:
;*;	MOV	DX,DS:ADRS_CM_TBL[BX]
;*;	INC	BX
;*;	INC	BX
;*;	CALL	HEXSTR
;*;	CALL	PRINT
;*;	PR	" "
;*;	LOOP	DBG_DMP_LOOP2
;*;	POP	BX
;*;
;*;	MOV	CX,3
;*;DBG_DMP_LOOP3:
;*;	MOV	DX,DS:ADRS_ZZ_TBL[BX]
;*;	INC	BX
;*;	INC	BX
;*;	CALL	HEXSTR
;*;	CALL	PRINT
;*;	PR	" "
;*;	LOOP	DBG_DMP_LOOP3
;*;	LF
;*;	POP	CX
;*;	LOOP	DBG_DMP_LOOP
;*;
;*;	CODE_OUT
;*;	RET
;*;DBG_DMP	ENDP

;*;;	デバック処理
;*;
;*;DBG2_PROC	PROC	NEAR
;*;	MOV	BX,2
;*;	MOV	CX,ADRS_CM_TBL[0] ; 共通文関係アドレステーブル
;*;DBG2_PROC1:
;*;	PUSH	CX
;*;	PUSH	BX
;*;	MOVX	PR_STRING,ADRS_CM_TBL[BX] ; 共通文関係アドレステーブル
;*;	CALL	SERIFU_LOOP		; 台詞ループ
;*;	POP	BX
;*;	POP	CX
;*;	ADD	BX,2
;*;	LOOP	DBG2_PROC1
;*;
;*;	MOV	BX,2
;*;	MOV	CX,ADRS_ZZ_TBL[0] ; 本文関係アドレステーブル
;*;DBG2_PROC2:
;*;	PUSH	CX
;*;	PUSH	BX
;*;	MOVX	PR_STRING,ADRS_ZZ_TBL[BX] ; 本文関係アドレステーブル
;*;	CALL	SERIFU_LOOP		; 台詞ループ
;*;	POP	BX
;*;	POP	CX
;*;	ADD	BX,2
;*;	LOOP	DBG2_PROC2
;*;
;*;	RET
;*;DBG2_PROC	ENDP


;	V-SYNC timer2 set.

TTMVST2	PROC	NEAR
	CALLC	TMVST2		; V-SYNC timer2 set.
	RET
TTMVST2	ENDP

;	V-SYNC timer2 check.

TTMVCK2	PROC	NEAR
	CALLC	TMVCK2		; V-SYNC timer2 check.
	RET
TTMVCK2	ENDP

;	V-SYNC timer2 set.

TTMVST3	PROC	NEAR
	CALLC	TMVST3		; V-SYNC timer3 set.
	RET
TTMVST3	ENDP

;	V-SYNC timer2 check.

TTMVCK3	PROC	NEAR
	CALLC	TMVCK3		; V-SYNC timer3 check.
	RET
TTMVCK3	ENDP


R_SEG2	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	SLCT_CLASS		; 階級選択
PUBLIC	SLCT_WORKS		; 仕事選択

EXTRN	OVLP_TIME:WORD		; オーバラップタイム
EXTRN	BBOVTM:WORD		; パターンＰＵＴオーバラップタイム

EXTRN	SEGPAT1:WORD		; パーツバッファ＃１セグメント
EXTRN	TOPPAT1:WORD		; 先頭オフセット
EXTRN	ENDPAT1:WORD		; 終了オフセット

EXTRN	SEGDOS:WORD		; ＤＯＳインターフェースセグメント

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ

EXTRN	OCHI_CUT:WORD		; 落ちのカット番号
EXTRN	OCHI_KIND:WORD		; 落ちの種類

SEGTXT		DW	0	; テキストセグメント
TXTTOP		DW	0	; テキストの先頭
TXTLEN		DW	0	; テキストデータ長さ

TXT_POINTER	DW	0	; テキストポインタ


;voidvoidvoid
;voidvoidvoid
LOCKID	DB	00H,00H		; code ID.
LOCKCD	LABEL	BYTE		; lock code.
	DB	00H	;0
	DB	00H	;1
	DB	00H	;2
	DB	00H	;3
	DB	00H	;4
	DB	00H	;5


STR_TXTID_CM	DB	"CM"		; 共通文関係
STR_TXTID_CM_N	DB	"???",0		; 共通文番号

STR_TXTID_ZZ	DB	"HN"		; 本文関係
STR_TXTID_ZZ_N	DB	"???",0		; 本文関係

ADRS_CM_TBL	LABEL	WORD		; 共通文関係アドレステーブル
		DW	11		; max.
		DW	11 DUP (0)	;

ADRS_ZZ_TBL	LABEL	WORD		; 本文関係アドレステーブル
		DW	30		; max.
		DW	30 DUP (0)	;

POINT_SAISYO	DW	0		; 最初の決まり文句
POINT_DEDASI	DW	0		; 共通文１の先頭
POINT_HONBUN	DW	0		; 本文の先頭
POINT_KETSU	DW	0		; 共通文２の先頭

ID_NAME_TOP	DW	0		; ＩＤ文字列の先頭
ID_NUMBER_TOP	DW	0		; ＩＤ文字列番号の先頭
ID_SCH_POINTER	DW	0		; ＩＤ検索ポインタ
ID_SEQ_NUMBER	DW	0		; ＩＤ順次番号

PR_STRING	DW	0		; 表示文字列アドレス

PICTUER_N	DW	0		; ロード絵の番号（-1:無し）

FLAG_LAST	DW	0		; 最後の台詞フラグ
FLAG_KUGIRI	DW	0		; 台詞の区切りフラグ

TEXT_HIGHT	DW	0		; テキスト段

SLCT_CLASS	DW	1		; 階級選択
SLCT_WORKS	DW	20		; 仕事選択

OL_XX1		DW	0		; オーバラップＸ位置
OL_YY1		DW	0		; オーバラップＹ位置
OL_XX2		DW	0		; オーバラップＸサイズ
OL_YY2		DW	0		; オーバラップＹサイズ

OCHI_F_MODE	DW	0		; オチフレームモード 1=ＰＵＴ,2=ＯＬ

SERIFU_MODE	DW	1		; 台詞モード 1=ＰＵＴ,2=ＯＬ

TIMING_TIME	DW	0		; タイミング・タイマ

;	決まり文句
;
;	CM001		＠最初の決まり文句
;
;	☆特別職☆
;
;	CM002		＊共通文１＊
;	HN001		＊女王の場合＊
;	HN002		＊姫の場合＊
;	CM003		＊共通文２＊
;
;	☆特級職☆
;
;	CM004		＊共通文１＊
;	HN003		＊長寿の場合＊
;	HN004		＊将軍＊
;	HN005		＊王立アカデミー総裁＊
;	HN006		＊王宮魔術師＊
;	HN007		＊貴族の妻１＊
;	HN008		＊王の側室＊
;	HN009		＊司祭＊
;	CM005		＊共通文２＊
;
;	☆上級職☆
;
;	CM006		＊共通文＊
;	HN010		＊近衛の騎士＊
;	HN011		＊近衛隊長＊
;	HN012		＊練金術師＊
;	HN013		＊魔導士＊
;	HN014		＊貴族の妻２＊
;	HN015		＊貴族の側室＊
;	HN016		＊上級尼僧＊
;	CM007		＊共通文２＊
;
;	☆中級職☆
;
;	CM008		＊共通文１＊
;	HN017		＊百姓の妻＊
;	HN018		＊木コリ＊
;	HN019		＊文士＊
;	HN020		＊魔法使い＊
;	HN021		＊商家の妻＊
;	HN022		＊酒場の女の子＊
;	HN023		＊尼僧＊
;	CM009		＊共通文２＊
;
;	☆下級職☆
;
;	HN024		＊傭兵＊
;	HN025		＊賞金稼ぎ＊
;	HN026		＊詐欺師＊
;	HN027		＊旅の魔法使い＊
;	HN028		＊高級娼婦＊
;	HN029		＊売春婦＊
;	HN030		＊出戻り＊
;	CM010		＊共通文＊
;
;	スタッフ・クレジット
;
;	CM011		スタッフ


DATA	ENDS

	END
;
;	end of "ENDING.ASM"
;
