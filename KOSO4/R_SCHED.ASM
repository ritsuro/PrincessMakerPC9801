; "R_SCHED.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	スケジュール
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
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

PUBLIC	R_SCHED			; スケジュール
PUBLIC	R_WEEKDAY		; 平日が何日あるかの計算

EXTRN	R_SCHED2:NEAR		; 娘を教育する
EXTRN	R_ARBEIT_SET:NEAR	; アルバイトセット
EXTRN	R_KYUSOK_SET:NEAR	; 休息セット
EXTRN	R_BACANS_SET:NEAR	; バカンスセット

EXTRN	R_MS_SCHED_TXT:NEAR	; スケジュール選択時のメッセージ

EXTRN	WIDMTRX_INIT:NEAR	; WINDOWS/マトリックス初期処理
EXTRN	WIDMTRX_FORMAT:NEAR	; WINDOWS/マトリックステーブルフォーマット
EXTRN	WIDMTRX_ASSIGN:NEAR	; WINDOWS/マトリックステーブルアサイン
EXTRN	WIDMTRX_OPEN:NEAR	; WINDOWS/マトリックスＯＰＥＮ
EXTRN	WIDMTRX_SET:NEAR	; WINDOWS/マトリックスセット
EXTRN	WIDMTRX_CLOSE:NEAR	; WINDOWS/マトリックスＣＬＯＳＥ
EXTRN	WIDMTRX_ROLL:NEAR	; WINDOWS/マトリックスＲＯＬＬ

EXTRN	WIDCLEN_INIT:NEAR	; WINDOWS/カレンダー・初期処理
EXTRN	WIDCLEN_SET:NEAR	; WINDOWS/カレンダー・時間設定
EXTRN	WIDCLEN_SHOW:NEAR	; WINDOWS/カレンダー・再表示
EXTRN	WIDCLEN_UDATE:NEAR	; WINDOWS/カレンダー・更新処理
EXTRN	WIDCLEN_GET:NEAR	; WINDOWS/カレンダー・読み取り処理
EXTRN	WIDCLEN_U_AD:NEAR	; WINDOWS/カレンダー・日付加算計算
EXTRN	WIDCLEN_NXT_E:NEAR	; WINDOWS/カレンダー・翌月の末日

EXTRN	US_WAIT:NEAR		; ユーザ待ち


; ****************************************************
;	スケジュール
;	-O- SCD_WEEK_CNT : スケジュールカウンタ
;	    SCD_NOW_LINE : 現在の行
;	    AX           : 0=正常,1=取り消し
; ****************************************************

R_SCHED		PROC	NEAR
;*STP*;	PR_CLS
	PR_TXT	"@スケジュｰルをきめるか"

	CALL	WIDCLEN_NXT_E		; WINDOWS/カレンダー・翌月の末日
	SUB	DX,SCD_TBL_NISSU[0*2]	;
	SUB	DX,SCD_TBL_NISSU[1*2]	;
	MOV	SCD_TBL_NISSU[2*2],DX	; 翌月の末日

	MOV	SCD_NOW_LINE,0		; 現在の行
	MOV	SCD_WEEK_CNT,0		; スケジュールカウンタ

	MOV	AX,SCD_TBL_SFT_DAY[0]	; 日数分割テーブル
	MOV	SCD_DATE_CNT,AX		; 日付シフトカウンタ（加算日数）

	CALL	SCHED_OPEN		; スケジュールＯＰＥＮ

	CALL	SCHED_CLEAR		; スケジュール・オールクリア

	CALL	SCHED_CLEAR_NOW		; スケジュール現在ラインクリア

R_SCHED_LOOP:				;
	MOV	SI,SCD_WEEK_CNT		; スケジュールカウンタ
	SHL	SI,1			; word pointer.
	MOVX	SCD_DATE_CNT,DS:SCD_TBL_SFT_DAY[SI]	; 日数分割テーブル
	MOVX	R_NISSU,DS:SCD_TBL_NISSU[SI]		; 日数テーブル
	CALL	SCHED_DATE_NOW		; スケジュール現在日付セット

	CALL	SCHED_SELECT_NW		; 現在スケジュール選択

	CMP	KETTEI,1		; 1=考え直す
	JNE	R_SCHED_LOOP_NEXT	;

	CMP	SCD_WEEK_CNT,0		;
;*NON*;	JE	R_SCHED_LOOP		;
	JE	R_SCHED_BREAK		; 取り消し

	DEC	SCD_WEEK_CNT		; スケジュールカウンタ
	DEC	SCD_NOW_LINE		; 現在の行
	CALL	SCHED_CLEAR_NOW		; スケジュール現在ラインクリア

	MOV	SI,SCD_WEEK_CNT		; スケジュールカウンタ
	SHL	SI,1			; word pointer.
	MOV	BX,DS:SCD_TBL_KOMOKU[SI] ; 決定項目テーブル
	MOV	AX,2			; 2=中止
	CALL	R_MS_SCHED_TXT		; スケジュール選択時のメッセージ
	JMP	R_SCHED_LOOP		;

R_SCHED_LOOP_NEXT:			;
	INC	SCD_WEEK_CNT		; スケジュールカウンタ
	INC	SCD_NOW_LINE		; 現在の行

	CMP	SCD_WEEK_CNT,3		;＝３
	JB	R_SCHED_LOOP		; ループエンド

	MOV	SCD_NOW_LINE,0		; 現在の行
	MOV	SCD_WEEK_CNT,3		;＝３

	SELECT	"スケジュｰルが組み込まれました,やりなおし"
	CMP	WIDSNM,0		; スケジュｰルが組み込まれました
	JE	R_SCHED_OK		;
	MOV	SCD_NOW_LINE,2		; 現在の行
	MOV	SCD_WEEK_CNT,2		; スケジュールカウンタ
	CALL	SCHED_CLEAR_NOW		; スケジュール現在ラインクリア
	MOV	SI,SCD_WEEK_CNT		; スケジュールカウンタ
	SHL	SI,1			; word pointer.
	MOV	BX,DS:SCD_TBL_KOMOKU[SI] ; 決定項目テーブル
	MOV	AX,2			; 2=中止
	CALL	R_MS_SCHED_TXT		; スケジュール選択時のメッセージ
	JMP	R_SCHED_LOOP		;
R_SCHED_OK:


	CALL	WIDMTRX_CLOSE		; WINDOWS/マトリックスＣＬＯＳＥ
	MOV	AX,0			; 0=正常
	RET
R_SCHED_BREAK:
	CALL	WIDMTRX_CLOSE		; WINDOWS/マトリックスＣＬＯＳＥ
	MOV	AX,1			; 1=取り消し
	RET
R_SCHED		ENDP


; ****************************************************
;	スケジュールＯＰＥＮ
; ****************************************************

SCHED_OPEN	PROC	NEAR
;*NON*;	CMPX	SCHED_CNT_Y,SCHED_MAX_Y	; マトリックス最大行数
;*NON*;	JGE	SCHED_OPEN_2		;
;*NON*;
;*NON*;	INC	SCHED_CNT_Y		; マトリックス行数
;*NON*;SCHED_OPEN_2:

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

	CALL	WIDMTRX_OPEN		; マトリックスＯＰＥＮ

	RET
SCHED_OPEN	ENDP


; ****************************************************
;	スケジュール現在ラインクリア
;	-I- SCD_NOW_LINE : 現在の行
; ****************************************************

SCHED_CLEAR_NOW	PROC	NEAR
;*NON*;	MOV	AX,SCHED_CNT_Y			; マトリックス行数
;*NON*;	DEC	AX				;
;*NON*;	CMP	SCD_NOW_LINE,AX			; 現在の行
;*NON*;	JL	SCHED_CLEAR_NOW_ADD		;
;*NON*;	JMP	SCHED_CLEAR_NOW_ROLL		;
;*NON*;SCHED_CLEAR_NOW_ADD:
;*NON*;	INC	SCD_NOW_LINE			; 現在の行

	MOVX	WDPLIN,SCD_NOW_LINE		;
	CALL	SCHED_CLEAR_1LINE		; スケジュール・１ラインクリア

;*NON*;	JMP	SCHED_CLEAR_NOW_EXIT		;
;*NON*;SCHED_CLEAR_NOW_ROLL:
;*NON*;	CALL	SCD_ROLL			; スケジュールＲＯＬＬ
;*NON*;
;*NON*;	MOVX	WDPLIN,SCD_NOW_LINE		; 現在の行
;*NON*;	CALL	SCHED_CLEAR_1LINE		; スケジュール・１ラインクリア
;*NON*;SCHED_CLEAR_NOW_EXIT:
	RET
SCHED_CLEAR_NOW	ENDP


; ****************************************************
;	スケジュールＲＯＬＬ
; ****************************************************

SCD_ROLL	PROC	NEAR
	CMP	SCHED_CNT_Y,1		; マトリックス行数
	JLE	SCD_ROLL_EXIT		;

	CALL	WIDMTRX_ROLL		; WINDOWS/マトリックスＲＯＬＬ

SCD_ROLL_EXIT:
	RET
SCD_ROLL	ENDP


; ****************************************************
;	スケジュール・オールクリア
; ****************************************************

SCHED_CLEAR	PROC	NEAR
	PUSH	SCD_NOW_LINE		; 現在の行
	PUSH	SCD_WEEK_CNT		; スケジュールカウンタ

	MOV	WDPLIN,0		; マトリックス行数
	MOV	SCD_NOW_LINE,0		; 現在の行

	MOV	SI,0			; word pointer.
	MOV	CX,SCHED_CNT_Y		; マトリックス行数
SCHED_CLEAR_LOOP:			;
	PUSH	CX			;
	PUSH	SI

	PUSH	SI
	CALL	SCHED_CLEAR_1LINE	; スケジュール・１ラインクリア
	POP	SI

	MOVX	R_NISSU,DS:SCD_TBL_NISSU[SI]		; 日数テーブル
	MOVX	SCD_DATE_CNT,DS:SCD_TBL_SFT_DAY[SI]	; 日数分割テーブル

	CALL	SCHED_DATE_NOW		; スケジュール現在日付セット

	INC	SCD_NOW_LINE		; 現在の行
	INC	WDPLIN			; マトリックス行数

	POP	SI			;
	INC	SI			;
	INC	SI			; word pointer.
	POP	CX			;
	LOOP	SCHED_CLEAR_LOOP	;

	POP	SCD_WEEK_CNT		; スケジュールカウンタ
	POP	SCD_NOW_LINE		; 現在の行
	RET
SCHED_CLEAR	ENDP



; ****************************************************
;	スケジュール・１ラインクリア
;	-I- WDPLIN : マトリックス行数
; ****************************************************

SCHED_CLEAR_1LINE	PROC	NEAR
	MOV	WDVAL,0			;
	MOV	WDPCLM,2		; マトリックス横数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDVAL,0			;
	MOV	WDPCLM,3		; マトリックス横数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDVAL,ID_00		; 無効
	MOV	WDPCLM,4		; マトリックス横数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	WD_ADRS	ID_00,WDVAL		; 無効
	MOV	WDPCLM,5		; マトリックス横数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDVAL,0			;
	MOV	WDPCLM,6		; マトリックス横数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDVAL,0			;
	MOV	WDPCLM,7		; マトリックス横数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	WDVAL,0			;
	MOV	WDPCLM,8		; マトリックス横数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	RET
SCHED_CLEAR_1LINE	ENDP


; ****************************************************
;	スケジュール現在日付セット
;	-I- SCD_NOW_LINE : 現在の行
;	    SCD_DATE_CNT : 日付シフトカウンタ
;	    R_NISSU      : 日数
; ****************************************************

SCHED_DATE_NOW	PROC	NEAR
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET SCD_DATE	; スケジュール時間
	CALL	WIDCLEN_GET		; WINDOWS/カレンダー・読み取り処理
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET SCD_DATE	; スケジュール時間
	MOV	AX,SCD_DATE_CNT		; 日付シフトカウンタ（加算日数）
	CALL	WIDCLEN_U_AD		; WINDOWS/カレンダー・日付加算計算

	CALL	R_WEEKDAY		; 平日が何日あるかの計算

	MOVX	WDPLIN,SCD_NOW_LINE	; 現在の行
	MOV	WDPCLM,0		; マトリックス横数
	MOV	WDVAL,OFFSET SCD_DATE	; スケジュール時間
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOVX	WDPLIN,SCD_NOW_LINE	; 現在の行
	MOV	WDPCLM,8		; マトリックス横数
	MOVX	WDVAL,SCD_WEEKDAY	; 平日カウンタ
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOVX	WDPLIN,SCD_NOW_LINE	; 現在の行
	MOV	WDPCLM,7		; マトリックス横数
	MOVX	WDVAL,R_NISSU		; 日数
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET SCD_DATE	; スケジュール時間
	MOV	AX,R_NISSU		; 日数
	DEC	AX			;
	CMP	AX,0			;
	JGE	SCHED_DATE_NOW_6	;
	MOV	AX,0
SCHED_DATE_NOW_6:

	CALL	WIDCLEN_U_AD		; WINDOWS/カレンダー・日付加算計算

	MOVX	WDPLIN,SCD_NOW_LINE	; 現在の行
	MOV	WDPCLM,1		; マトリックス横数
	MOV	WDVAL,OFFSET SCD_DATE	; スケジュール時間
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET SCD_DATE	; スケジュール時間
	CALL	WIDCLEN_GET		; WINDOWS/カレンダー・読み取り処理
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET SCD_DATE	; スケジュール時間
	MOV	AX,SCD_DATE_CNT		; 日付シフトカウンタ（加算日数）
	CALL	WIDCLEN_U_AD		; WINDOWS/カレンダー・日付加算計算

	RET
SCHED_DATE_NOW	ENDP



; ****************************************************
;	平日が何日あるかの計算
;	-I- SCD_DATE_CNT: 日付シフトカウンタ（何日からスタートするか）
;	    R_NISSU     : 明日からの日数
;	-O- SCD_WEEKDAY : 平日カウンタ
; ****************************************************

R_WEEKDAY	PROC	NEAR
	MOV	SCD_WEEKDAY,0		; 平日カウンタ

	CMP	R_NISSU,0		; 明日からの日数
	JG	R_WEEKDAY_START		;
	RET

R_WEEKDAY_START:
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET WRK_DATE	; 時間
	CALL	WIDCLEN_GET		; WINDOWS/カレンダー・読み取り処理

	MOVX	ES,DS			;
	MOV	DI,OFFSET WRK_DATE	; 時間
	MOV	AX,SCD_DATE_CNT		; 日付シフトカウンタ
	CALL	WIDCLEN_U_AD		; WINDOWS/カレンダー・日付加算計算

	MOV	CX,R_NISSU		; 明日からの日数
R_WEEKDAY_LOOP:
	PUSH	CX			;

	CMP	UCK_HOLIDAY,0		; (user)フラグ・休日
	JNE	R_WEEKDAY_SKIP		;
	INC	SCD_WEEKDAY		; 平日カウンタ
R_WEEKDAY_SKIP:

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET WRK_DATE	; 時間
	MOV	AX,1			; 加算日数
	CALL	WIDCLEN_U_AD		; WINDOWS/カレンダー・日付加算計算

	POP	CX			;
	LOOP	R_WEEKDAY_LOOP		;
R_WEEKDAY_LOOP_END:
	RET
R_WEEKDAY	ENDP



; ****************************************************
;	現在スケジュール選択
;	-I-   SCD_NOW_LINE   : 現在の行
;	      SCD_DATE_CNT   : 日付シフトカウンタ（何日からスタートするか）
;	-I/O- R_KOUMKU       : 項目
;	-O-   KETTEI         : 0=決定,1=考え直す
;	      SCD_TBL_KOMOKU : 決定項目テーブル
; ****************************************************

SCHED_SELECT_NW	PROC	NEAR
	MOVX	WDPLIN,SCD_NOW_LINE		; 現在の行

SCHED_SELECT_NW_RETRY:
;*;	SELECT	"武芸,学問,礼法,武者修行,アルバイト,休息,バカンス,やりなおし"

SELECT	"娘を教育する,お金を稼がせる,休ませてあげる,バカンスへ行く,やりなおし"
	CMP	WIDSNM,OFFF
	JMPEQ	SCHED_SELECT_NW_BACK

	CMP	WIDSNM,4			; やりなおし
	JE	SCHED_SELECT_NW_07		;

	CMP	WIDSNM,0			; 娘を教育する
	JE	SCHED_SELECT_NW_00		;

	;		4=アルバイト
	;		5=休息
	;		6=バカンス

	MOV	SI,SCD_WEEK_CNT			; スケジュールカウンタ
	SHL	SI,1				; word pointer.
	MOV	BX,WIDSNM			;
	ADD	BX,3				;
	MOV	DS:SCD_TBL_KOMOKU[SI],BX	; 決定項目テーブル

	MOV	BX,WIDSNM			;
	ADD	BX,3				;
	MOV	AX,1				; 1=決定
	CALL	R_MS_SCHED_TXT		; スケジュール選択時のメッセージ


	CMP	WIDSNM,1			; お金を稼がせる
	JE	SCHED_SELECT_NW_01		;
	CMP	WIDSNM,2			; 休ませてあげる
	JE	SCHED_SELECT_NW_02		;
	CMP	WIDSNM,3			; バカンスへ行く
	JE	SCHED_SELECT_NW_03		;

	JMP	SCHED_SELECT_NW_BACK

SCHED_SELECT_NW_00:
	CALL	R_SCHED2			; 娘を教育する
	MOV	SI,SCD_WEEK_CNT			; スケジュールカウンタ
	SHL	SI,1				; word pointer.
	MOV	DS:SCD_TBL_KOMOKU[SI],DX	; 決定項目テーブル
	JMP	SCHED_SELECT_NW_EE		;
SCHED_SELECT_NW_01:
	CALL	R_ARBEIT_SET			; アルバイト
	JMP	SCHED_SELECT_NW_EE		;
SCHED_SELECT_NW_02:
	CALL	R_KYUSOK_SET			; 休息
	JMP	SCHED_SELECT_NW_EE		;
SCHED_SELECT_NW_03:
	CALL	R_BACANS_SET			; バカンス
	JMP	SCHED_SELECT_NW_EE		;
SCHED_SELECT_NW_07:
	JMP	SCHED_SELECT_NW_BACK
SCHED_SELECT_NW_EE:
	CMP	KETTEI,1			; 1=考え直す
	JMPEQ	SCHED_SELECT_NW_RETRY		;

	CALL	MTR_SET				; マトリックスへセット
SCHED_SELECT_NW_EXIT:
	MOV	KETTEI,0			; 0=決定
	RET
SCHED_SELECT_NW_BACK:
	MOV	KETTEI,1			; 1=考え直す
	RET
SCHED_SELECT_NW	ENDP


; ****************************************************
;	マトリックスへセット
;	-I- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    R_NISSU  : 日数
;	    WDPLIN   : マトリックス行数
;	    SCD_NOW_LINE: 現在の行
;	    SCD_DATE_CNT: 日付シフトカウンタ（何日からスタートするか）
; ****************************************************

MTR_SET	PROC	NEAR
	CALL	SCHED_DATE_NOW		; スケジュール現在日付セット
	CALL	R_WEEKDAY		; 平日が何日あるかの計算

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

	MOV	WDPCLM,8		; マトリックス横数
	MOVX	WDVAL,SCD_WEEKDAY	; 平日カウンタ
	CALL	WIDMTRX_SET		; WINDOWS/マトリックスセット

	RET
MTR_SET	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	SCD_NOW_LINE		; 現在の行
PUBLIC	SCD_WEEK_CNT		; スケジュールカウンタ

PUBLIC	SCD_DATE		; スケジュール時間
PUBLIC	SCD_WEEKDAY		; 平日カウンタ

PUBLIC	SCHED_CNT_X		; マトリックス横数
PUBLIC	SCHED_CNT_Y		; マトリックス行数

PUBLIC	SCHED_FORM_LINE		; 表示フォーマット・長さ
PUBLIC	SCHED_FORM_LTYP		; 表示フォーマット・タイプ


EXTRN	WDPCLM:WORD		; WINDOWS/順序
EXTRN	WDPLIN:WORD		; WINDOWS/行

EXTRN	R_KOUMKU:WORD		; 項目
EXTRN	R_NAISTR:WORD		; 内容文字列
EXTRN	R_NAIYOU:WORD		; 内容値
EXTRN	R_NYUKIN:WORD		; 入金
EXTRN	R_SYUTSU:WORD		; 出金
EXTRN	R_NISSU:WORD		; 日数

EXTRN	KETTEI:WORD		; 決定フラグ

EXTRN	USR_DATE:WORD		; (user)現在時間退避
EXTRN	UCK_YEAR:WORD		; (user)年
EXTRN	UCK_MONTH:WORD		; (user)月
EXTRN	UCK_WEEK:WORD		; (user)曜日
EXTRN	UCK_DATE:WORD		; (user)日
EXTRN	UCK_A_DATE:WORD		; (user)年内合計日付
EXTRN	UCK_M_END:WORD		; (user)月末の日
EXTRN	UCK_SEASON:WORD		; (user)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	UCK_SHOGATSU:WORD	; (user)フラグ・正月
EXTRN	UCK_URUBI:WORD		; (user)フラグ・うるう日
EXTRN	UCK_CHRISTMAS_EVE:WORD	; (user)フラグ・クリスマスイブ
EXTRN	UCK_BORTH:WORD		; (user)フラグ・誕生日
EXTRN	UCK_HOLIDAY:WORD	; (user)フラグ・休日


SCD_NOW_LINE	DW	-1		; 現在の行
SCD_DATE_CNT	DW	0		; 日付シフトカウンタ

SCD_WEEK_CNT	DW	0		; スケジュールカウンタ
SCD_TBL_SFT_DAY	LABEL	WORD		; 日数分割テーブル
		DW	1
		DW	11
		DW	21
SCD_TBL_NISSU	LABEL	WORD		; 日数テーブル
		DW	10
		DW	10
		DW	10
SCD_TBL_KOMOKU	LABEL	WORD		; 決定項目テーブル
		DW	0
		DW	0
		DW	0

SCD_DATE	DB	"1880/10/18",0,0 ; スケジュール時間
SCD_WEEKDAY	DW	0		; 平日カウンタ

SCHED_CNT_X	DW	9 ;8		; マトリックス横数
SCHED_CNT_Y	DW	3		; マトリックス行数

SCHED_MAX_X	DW	9 ;8		; マトリックス最大横数
SCHED_MAX_Y	DW	3		; マトリックス最大行数

SCHED_FORM_LINE	DW 5, 5, 6, 6,10,12,0,3,3	; 表示フォーマット・長さ
SCHED_FORM_LTYP	DW S_MTRX_DATE,S_MTRX_DATE,S_MTRX_GOLD,S_MTRX_GOLD,S_MTRX_IDSTR,S_MTRX_STR,S_MTRX_NOP,S_MTRX_VAL,S_MTRX_VAL	; 表示フォーマット・タイプ

WRK_DATE	DB	"1999/01/01",0,0	; 時間

		; 項目
HED_MSG	DB	" 始め  終り もうけ 使う金 やること　　　中身は    日数平日",0
;*;HED_MSG DB	" 始め  終り もうけ 使う金 やること　　　中身は    DBG days",0
;*;HED_MSG DB	" 始め  終り もうけ 使う金 やること　　　中身は    DBG",0

DATA	ENDS

	END
;
;	end of "R_SCHED.ASM"
;
