; "WIDALLOC.ASM" PC-9801UV11 make by R.H 1990/10/22
;
;
;	ＷＩＮＤＯＷＳ／データ結合処理
;
;
; (C) 1990 ritsurou hashimoto.


INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	WORDID.INC
INCLUDE	TSTSET.INC

;		WINDOW1  COM    27251  91-05-04   11:25

DATA_AREA_LENGTH	EQU	29690	; データエリア長さ

TOP_HEAD_OFS_OFS	EQU	0	; ヘッダーテーブル
TOP_HEAD_MAX_OFS	EQU	2	; ヘッダーレコード数
TOP_ITEM_OFS_OFS	EQU	4	; アイテムテーブル
TOP_ITEM_MAX_OFS	EQU	6	; アイテムレコード数
TOP_WAZA_OFS_OFS	EQU	8	; 技テーブル
TOP_WAZA_MAX_OFS	EQU	10	; 技レコード数
TOP_WORK_OFS_OFS	EQU	12	; 行いテーブル
TOP_WORK_MAX_OFS	EQU	14	; 行いレコード数
TOP_ENVIR_OFS_OFS	EQU	16	; 環境テーブル
TOP_ENVIR_MAX_OFS	EQU	18	; 環境レコード数
TOP_SCHED_OFS_OFS	EQU	20	; スケジュールテーブル
TOP_SCHED_MAX_OFS	EQU	22	; スケジュールレコード数


MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	WIDALLOC			; WINDOWS/データ結合
PUBLIC	WIDALLOC_MEM			; WINDOWS/データ結合・メモリ上のみ
PUBLIC	WIDALC_LOAD			; WINDOWS/データロード
PUBLIC	WIDALC_SAVE			; WINDOWS/データセーブ
PUBLIC	WIDALLOC_MY_GIRL		; WINDOWS/キャラクタ・データ結合
PUBLIC	WIDALLOC_TEKICHR		; WINDOWS/敵キャラクタ・データ結合
;*;PUBLIC WIDALLOC_CHR_COPY		; WINDOWS/キャラクタ・コピー

EXTRN	DSKLD:NEAR			; load data.
EXTRN	DSKLDT:NEAR			; temp load data.
EXTRN	DSKSVT:NEAR			; temp save data.

EXTRN	WIDALLOC_CHRADRS:NEAR		; WINDOWS/キャラクタ・ヘッダアドレス
EXTRN	WIDCLEN_AGE:NEAR		; WINDOWS/カレンダー・年齢の計算
EXTRN	WIDCLEN_LINK:NEAR		; WINDOWS/カレンダー・データ結合処理
EXTRN	R_SCHO_MUSUME:NEAR		; 娘チェック(ロード用)


EXTRN	R_KEISAN:NEAR			; 各計算処理


; ****************************************************
;	WINDOWS/データ結合
;	-O- AX : 0=正常
;	       : 1=ヘッダが見つかりません
;	       : 2=ディスクエラー
; ****************************************************

WIDALLOC	PROC	NEAR
	CALL	LOAD_AREA_CLEAR			; データロードエリア・クリア
	CALL	MESS_FLAG_DATA_LINK		; メッセージ・フラグデータ結合

	MOV	FILE_NAME_ADRS,OFFSET FLNAME	; データファイル名アドレス
	CALL	DAT_INIT_LOAD			; 初期データロード
	CMP	AX,0				; 0=正常,1=ディスクエラー
	JNE	WIDALLOC_DISK_ERROR		;

	CALL	LOADALLOC			; データ全結合

	CALL	ORIGINAL_EDIT			; オリジナルデータの編集

;*;	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
;*;	MOV	S_FUNC,65			; 65=非行化・病気化
;*;	CALL	R_KEISAN			; 各計算処理

	RET
WIDALLOC_DISK_ERROR:
	MOV	AX,2				; 2=ディスクエラー
	RET
WIDALLOC	ENDP


; ****************************************************
;	WINDOWS/データ結合・メモリ上のみ
; ****************************************************

WIDALLOC_MEM	PROC	NEAR
	CALL	LOADALLOC			; データ全結合
	RET
WIDALLOC_MEM	ENDP


; ****************************************************
;	WINDOWS/データロード
;	-I- ES:SI : ファイル名
;	-O- AX    : 0=正常
;	          : 1=ヘッダが見つかりません
;	          : 2=ディスクエラー
; ****************************************************

WIDALC_LOAD	PROC	NEAR
	MOV	DI,OFFSET FLWORK		;"d:12345678.123"
	MOV	CX,14				; バッファ最大長さ
	CALL	STRSETZ				; 文字列バッファセット
	MOV	FILE_NAME_ADRS,OFFSET FLWORK	; データファイル名

	MOV	FILE_NAME_ADRS,OFFSET FLWORK	; データファイル名
	CALL	DAT_LOAD			; データロード
	CMP	AX,0				; 0=正常,1=ディスクエラー
	JNE	WIDALC_LOAD_DISK_ERR		;

	CALL	LOADALLOC			; データ全結合
	RET
WIDALC_LOAD_DISK_ERR:
	MOV	AX,2				; 2=ディスクエラー
	RET
WIDALC_LOAD	ENDP


; ****************************************************
;	WINDOWS/データセーブ
;	-I- ES:SI : ファイル名
;	-O- AX    : 0=正常
;	          : 2=ディスクエラー
; ****************************************************

WIDALC_SAVE	PROC	NEAR
	MOV	DI,OFFSET FLWORK		;"d:12345678.123"
	MOV	CX,14				; バッファ最大長さ
	CALL	STRSETZ				; 文字列バッファセット
	MOV	FILE_NAME_ADRS,OFFSET FLWORK	; データファイル名

	MOV	FILE_NAME_ADRS,OFFSET FLWORK	; データファイル名
	CALL	DAT_SAVE			; データセーブ
	CMP	AX,0				; 0=正常,1=ディスクエラー
	JNE	WIDALC_SAVE_DISK_ERR		;

	RET
WIDALC_SAVE_DISK_ERR:
	MOV	AX,2				; 2=ディスクエラー
	RET
WIDALC_SAVE	ENDP


; ****************************************************
;	オリジナルデータの編集
; ****************************************************

ORIGINAL_EDIT	PROC	NEAR
	MOV	CHAR_NUMBER,0		; キャラクター番号

	MOV	CX,WIDMAX_HEAD		; ヘッダーテーブルレコード数
ORIGINAL_EDIT_LOOP:
	PUSH	CX

	MOV	DX,CHAR_NUMBER		; キャラクター番号
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	CHAR_HEAD_ADRS,BX	; ヘッダ・アドレス

	;	根性の初期値を＋αへコピーする

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	SI,ES:[BX][HED_GR_OFS]	; グラフテーブルオフセット

	MOV	AX,ES:[SI][GTB_KONJYO][GRP_VALMAX]	; 4. 根性
	MOV	ES:[SI][GTB_ALPHA][GRP_VALUE],AX	;16. ＋α
	MOV	ES:[SI][GTB_ALPHA][GRP_VALMAX],AX	;16. ＋α

	INC	CHAR_NUMBER		; キャラクター番号

	POP	CX
	LOOP	ORIGINAL_EDIT_LOOP

	RET
ORIGINAL_EDIT	ENDP


; ****************************************************
;	データ全結合
;	-O- AX : 0=正常
;	       : 1=ヘッダが見つかりません
; ****************************************************

LOADALLOC	PROC	NEAR
	CALL	WIDSCH_HEAD		; データ先頭検索
	CMP	AX,1			; 1=ヘッダが見つかりません
	JE	LOADALLOC_HEAD_ERROR	;

	CALL	WID_HEAD_ALLOC		; データヘッド結合

	MOV	DX,0			; 先頭のヘッダーを、私の娘とします
	CALL	WIDALLOC_MY_GIRL	; WINDOWS/私の娘・データ結合

	CALL	WIDCLEN_LINK		; WINDOWS/カレンダー・データ結合処理

	CALL	WID_HEAD_CALC		; 初期データの整合処理

	CALL	R_SCHO_MUSUME		; 娘チェック(ロード用)

LOADALLOC_EXIT:
	MOV	AX,0			; 0=正常
	RET
LOADALLOC_HEAD_ERROR:
	MOV	AX,1			; 1=ヘッダが見つかりません
	RET
LOADALLOC	ENDP



; ****************************************************
;	WINDOWS/キャラクタ・データ結合
;	-I- DX : 娘の番号
; ****************************************************

WIDALLOC_MY_GIRL	PROC	NEAR
	MOV	WIDMY_GIRL_NO,DX		; 私の娘Ｎｏ．

	MOV	BX,DX				;
	MOV	AX,HED_NEXT			; 次のヘッダー
	MUL	BX				;
	ADD	AX,WIDOFS_HEAD			; ヘッダーテーブル
	MOV	WIDMY_GIRL_OF,AX		; 私の娘アドレス

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOVX	WIDOFS_GRP,ES:[BX][HED_GR_OFS]	; グラフテーブルオフセット
	MOVX	WIDMAX_GRP,ES:[BX][HED_GR_MAX]	; グラフテーブルレコード数
	MOVX	WIDOFS_VAL,ES:[BX][HED_VA_OFS]	; 内容表示テーブルオフセット
	MOVX	WIDMAX_VAL,ES:[BX][HED_VA_MAX]	; 内容表示テーブルレコード数

	MOVX	WIDCHAR_DRESS,ES:[BX][HED_FUKU]	; 自分の娘の着ている服

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,27			; 27=キャラクタの全整合チェック
	CALL	R_KEISAN			; 各計算処理

	RET
WIDALLOC_MY_GIRL	ENDP



; ****************************************************
;	WINDOWS/敵キャラクタ・データ結合
;	-I- DX : 敵キャラクタＮｏ．
; ****************************************************

WIDALLOC_TEKICHR	PROC	NEAR
	MOV	WIDTK_CHAR_NO,DX		; 敵キャラクタＮｏ．

	MOV	BX,DX				;
	MOV	AX,HED_NEXT			; 次のヘッダー
	MUL	BX				;
	ADD	AX,WIDOFS_HEAD			; ヘッダーテーブル
	MOV	WIDTK_CHAR_OF,AX		; 敵キャラクタアドレス

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOVX	WIDOFS_GP_TK,ES:[BX][HED_GR_OFS] ; 敵・グラフテーブルオフセット
	MOVX	WIDMAX_GP_TK,ES:[BX][HED_GR_MAX] ; 敵・グラフテーブルレコード数
	MOVX	WIDOFS_VL_TK,ES:[BX][HED_VA_OFS] ; 敵・内容表示オフセット
	MOVX	WIDMAX_VL_TK,ES:[BX][HED_VA_MAX] ; 敵・内容表示レコード数

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,27			; 27=キャラクタの全整合チェック
	CALL	R_KEISAN			; 各計算処理

	RET
WIDALLOC_TEKICHR	ENDP


; ****************************************************
;	データヘッド結合
;	-I- TOP_ADDRESS : データ先頭オフセット
; ****************************************************

WID_HEAD_ALLOC	PROC	NEAR

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,TOP_ADDRESS		; データ先頭オフセット

	MOVX	WIDOFS_HEAD,ES:[BX][TOP_HEAD_OFS_OFS]	; ヘッダーテーブル
	MOVX	WIDMAX_HEAD,ES:[BX][TOP_HEAD_MAX_OFS]	; レコード数

	MOVX	WIDOFS_ITEM,ES:[BX][TOP_ITEM_OFS_OFS]	; アイテムテーブル
	MOVX	WIDOFS_WAZA,ES:[BX][TOP_WAZA_OFS_OFS]	; 技テーブル
	MOVX	WIDOFS_WORKS,ES:[BX][TOP_WORK_OFS_OFS]	; 行いテーブル

	MOVX	WIDOFS_ENVIR,ES:[BX][TOP_ENVIR_OFS_OFS]	; 環境テーブル
	MOVX	WIDOFS_SCHED,ES:[BX][TOP_SCHED_OFS_OFS]	; スケジュールテーブル

	MOV	BX,WIDOFS_ENVIR				; 環境テーブル
	MOVX	WIDOFS_ENVSTR,ES:[BX][KAN_ENVIR_STR]	; 環境文字テーブル
	MOVX	WIDOFS_ENVTIM,ES:[BX][KAN_ENVIR_TIME]	; 環境時間テーブル
	MOVX	WIDOFS_ENVTSR,ES:[BX][KAN_ENVIR_TSRT]	; 環境開始時間テーブル

	RET
WID_HEAD_ALLOC	ENDP



; ****************************************************
;	初期データの整合処理
;	-I- WIDMAX_HEAD : ヘッダーテーブルレコード数
; ****************************************************

WID_HEAD_CALC	PROC	NEAR
	MOV	CHAR_NUMBER,0		; キャラクター番号

	MOV	CX,WIDMAX_HEAD		; ヘッダーテーブルレコード数
WID_HEAD_CALC_LOOP:
	PUSH	CX
	MOV	DX,CHAR_NUMBER		; キャラクター番号
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	CHAR_HEAD_ADRS,BX	; ヘッダ・アドレス

	;	グラフ値の全てを最大値まで回復する。

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,45		; 45=回復
	CALL	R_KEISAN		; 各計算処理

	;	体力・知力をＨＰ・ＭＰへセット

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	;	身長・体重からプロポーションを求める

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,25		; 25=内容表示整合
	CALL	R_KEISAN		; 各計算処理

	;	誕生日から年齢・星座

	CALL	WID_TIME_SET		; 誕生日と年齢・星座の整合処理

	;	経験値からレベルの設定

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,26		; 26=レベルＵＰ
	CALL	R_KEISAN		; 各計算処理


	INC	CHAR_NUMBER		; キャラクター番号

	POP	CX
	LOOP	WID_HEAD_CALC_LOOP

	RET
WID_HEAD_CALC	ENDP


; ****************************************************
;	誕生日と年齢・星座の整合処理
;	-I- CHAR_HEAD_ADRS : ヘッダ・アドレス
;
;	優先されるのは、誕生日で環境時間から
;	年齢と星座が導き出される。
;
; ****************************************************

WID_TIME_SET	PROC	NEAR

	; 内容表示テーブル

	MOV	BX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_VA_OFS]	; SI=内容表示テーブルオフセット
	MOV	VALUE_ADRS,SI		; 内容表示テーブルアドレス

	; 誕生日

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ES:[SI][VTB_TANJOBI][VAL_VALUE] ; 誕生日 "1870/03/03"

	CALL	WIDCLEN_AGE		; WINDOWS/カレンダー・年齢の計算

	; 年齢

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,VALUE_ADRS		; 内容表示テーブルアドレス
	MOV	ES:[SI][VTB_NENREI][VAL_VALUE],DX ; 4.年齢

	; 星座

	SHL	BX,1			; BX=星座番号から
	MOV	SI,DS:SEIZA_ID_TABLE[BX]; SI=星座名のＩＤを取り出し
	SHL	SI,1			; word pointer.

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,WIDOFS_ENVIR		; 環境テーブル
	MOV	BX,ES:[DI]		; ＷＩＮＤＯＷＳセグメント中の
	MOV	AX,ES:[BX][SI]		; 星座名のアドレスを取り出す

	MOV	SI,VALUE_ADRS		; 内容表示テーブルアドレス
	MOV	ES:[SI][VTB_SEIZA][VAL_VALUE],AX ; 1.星座

	RET
WID_TIME_SET	ENDP


;*;; ****************************************************
;*;;	WINDOWS/キャラクタ・コピー
;*;; ****************************************************
;*;
;*;WIDALLOC_CHR_COPY	PROC	NEAR
;*;	RET
;*;WIDALLOC_CHR_COPY	ENDP


; ****************************************************
;	初期データロード
;	-I- FILE_NAME_ADRS : データファイル名アドレス
;	-O- AX             : 0=正常,1=ディスクエラー
; ****************************************************

DAT_INIT_LOAD	PROC	NEAR
	MOV	SI,FILE_NAME_ADRS	; データファイル名アドレス
	MOV	DX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,100H			; dest offset  address.
	MOV	CX,DATA_AREA_LENGTH	; データエリア長さ
	CALL	DSKLD			; file load.
	RET
DAT_INIT_LOAD	ENDP


; ****************************************************
;	データロード
;	-I- FILE_NAME_ADRS : データファイル名アドレス
;	-O- AX             : 0=正常,1=ディスクエラー
; ****************************************************

DAT_LOAD	PROC	NEAR
	MOV	SI,FILE_NAME_ADRS	; データファイル名アドレス
	MOV	DX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,100H			; dest offset  address.
	MOV	CX,DATA_AREA_LENGTH	; データエリア長さ
	CALL	DSKLDT			; temp load data.
	RET
DAT_LOAD	ENDP


; ****************************************************
;	データセーブ
;	-I- FILE_NAME_ADRS : データファイル名アドレス
;	-O- AX             : 0=正常,1=ディスクエラー
; ****************************************************

DAT_SAVE	PROC	NEAR
	MOV	SI,FILE_NAME_ADRS	; データファイル名アドレス
	MOV	DX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,100H			; dest offset  address.
	MOV	CX,DATA_AREA_LENGTH	; データエリア長さ
	CALL	DSKSVT			; temp save data.
	RET
DAT_SAVE	ENDP


; ****************************************************
;	データロードエリア・クリア
; ****************************************************

LOAD_AREA_CLEAR	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,0			; dest offset  address.
	MOV	CX,DATA_AREA_LENGTH	; データエリア長さ
	MOV	AL,0			;
	REP	STOSB			;
	RET
LOAD_AREA_CLEAR	ENDP


; ****************************************************
;	メッセージ・フラグデータ結合
; ****************************************************

MESS_FLAG_DATA_LINK	PROC	NEAR
	MOV	AX,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	ARBEIT_FLG_OFS,ADD_ARBEIT_TBL	; アルバイトフラグオフセット
	MOV	ARBEIT_FLG_SEG,AX		; アルバイトフラグセグメント
	MOV	BUGARE_FLG_OFS,ADD_BUGARE_TBL	; 武・学・礼テーブル
	MOV	BUGARE_FLG_SEG,AX		; 武・学・礼フラグセグメント
	MOV	KAIKEN_FLG_OFS,ADD_KAIKEN_TBL	; 会見フラグオフセット
	MOV	KAIKEN_FLG_SEG,AX		; 会見フラグセグメント
	RET
MESS_FLAG_DATA_LINK	ENDP


; ****************************************************
;	データ先頭検索
;		"KOSODATE_HEADER"	; ヘッダーであることを示す。
;
;	-O- AX          : 0=通常,1=ヘッダが見つかりません
;	    TOP_ADDRESS : データ先頭オフセット
; ****************************************************

WIDSCH_HEAD	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,0			;
	MOV	AL,KOSODATE_HEADER	; ヘッダーであることを示す
	MOV	CX,0FFFFH		;
WIDSCH_HEAD_LOOP:
	REPNE	SCASB			;
	JNE	WIDSCH_HEAD_NONE	;

	PUSH	DI			;
	PUSH	CX			;

	DEC	DI			;

	MOV	CX,15	; 123456789012345
	MOV	SI,OFFSET KOSODATE_HEADER
	REPE	CMPSB			;

	POP	CX			;
	POP	DI			;

	JNE	WIDSCH_HEAD_LOOP	;

	ADD	DI,15-1			;＝１５－１
	MOV	TOP_ADDRESS,DI		; データ先頭オフセット

	MOV	AX,0			; 0=通常
	RET
WIDSCH_HEAD_NONE:
	MOV	AX,1			; 1=ヘッダが見つかりません
	RET
WIDSCH_HEAD	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	S_FUNC:WORD			; 計算ファンクション

PUBLIC	KAIKEN_FLG_OFS			; 会見フラグオフセット
PUBLIC	KAIKEN_FLG_SEG			; 会見フラグセグメント
PUBLIC	BUGARE_FLG_OFS			; 武・学・礼フラグオフセット
PUBLIC	BUGARE_FLG_SEG			; 武・学・礼フラグセグメント
PUBLIC	ARBEIT_FLG_OFS			; アルバイトフラグオフセット
PUBLIC	ARBEIT_FLG_SEG			; アルバイトフラグセグメント

KAIKEN_FLG_OFS	DW	0		; 会見フラグオフセット
KAIKEN_FLG_SEG	DW	0		; 会見フラグセグメント
BUGARE_FLG_OFS	DW	0		; 武・学・礼フラグオフセット
BUGARE_FLG_SEG	DW	0		; 武・学・礼フラグセグメント
ARBEIT_FLG_OFS	DW	0		; アルバイトフラグオフセット
ARBEIT_FLG_SEG	DW	0		; アルバイトフラグセグメント

TOP_ADDRESS	DW	0			; データ先頭オフセット
FILE_NAME_ADRS	DW	OFFSET FLNAME		; データファイル名アドレス

FLNAME		DB	"WINDOW1.COM",0		; データファイル名
KOSODATE_HEADER	DB	"KOSODATE_HEADER",0	; ヘッダーであることを示す
FLWORK		DB	"d:12345678.123",0,0	; データファイル名

CHAR_NUMBER	DW	0			; キャラクター番号
CHAR_HEAD_ADRS	DW	0			; ヘッダ・アドレス

VALUE_ADRS	DW	0			; 内容表示テーブルアドレス

;	星座は"WIDCLEN.ASM"（ＷＩＮＤＯＷＳ／カレンダー）
;	の並び順です。
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

SEIZA_ID_TABLE	LABEL	WORD
		DW	0		;base.
		DW	ID_88		; おひつじ座
		DW	ID_89		; おうし座
		DW	ID_90		; ふたご座
		DW	ID_91		; かに座	
		DW	ID_92		; しし座	
		DW	ID_93		; おとめ座
		DW	ID_94		; てんびん座
		DW	ID_95		; さそり座
		DW	ID_96		; いて座	
		DW	ID_97		; やぎ座	
		DW	ID_98		; みずがめ座
		DW	ID_99		; うお座	

DATA	ENDS

	END
;
;	end of "WIDALLOC.ASM"
;
