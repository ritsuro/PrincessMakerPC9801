; "WIDTBL.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	ＷＩＮＤＯＷＳ／テーブル
;
;
; (C) 1990 ritsurou hashimoto.

DATA	SEGMENT	PUBLIC	'DATA'


PUBLIC	WIDOFS_HEAD			; ヘッダーテーブルオフセット
PUBLIC	WIDMAX_HEAD			; ヘッダーテーブルレコード数

PUBLIC	WIDOFS_GRP			; グラフテーブルオフセット
PUBLIC	WIDMAX_GRP			; グラフテーブルレコード数

PUBLIC	WIDOFS_VAL			; 内容表示テーブルオフセット
PUBLIC	WIDMAX_VAL			; 内容表示テーブルレコード数


PUBLIC	WIDOFS_GP_TK			; 敵・グラフテーブルオフセット
PUBLIC	WIDMAX_GP_TK			; 敵・グラフテーブルレコード数

PUBLIC	WIDOFS_VL_TK			; 敵・内容表示テーブルオフセット
PUBLIC	WIDMAX_VL_TK			; 敵・内容表示テーブルレコード数


PUBLIC	WIDOFS_ITEM			; アイテムテーブル
PUBLIC	WIDOFS_WAZA			; 技テーブル
PUBLIC	WIDOFS_WORKS			; 行いテーブル
PUBLIC	WIDOFS_ENVIR			; 環境テーブル
PUBLIC	WIDOFS_SCHED			; スケジュールテーブル

PUBLIC	WIDOFS_ENVSTR			; 環境文字テーブル
PUBLIC	WIDOFS_ENVTIM			; 環境時間テーブル
PUBLIC	WIDOFS_ENVTSR			; 環境開始時間テーブル

PUBLIC	WIDNAMELEN			; グラフ名前最大長さ
PUBLIC	WIDHELPLEN			; グラフ説明最大長さ

PUBLIC	WIDVIEW_MIN			; グラフ表示エリア下限
PUBLIC	WIDVIEW_MAX			; グラフ表示エリア上限

PUBLIC	WIDPRNMLEN			; 内容表示パラメータ名最大長さ
PUBLIC	WIDPRHLLEN			; 内容表示説明最大長さ
PUBLIC	WIDTYP_NM_LEN			; 内容表示ＮＡＭＥ型最大長さ

PUBLIC	WIDHDFNAM_LEN			; ヘッダー 姓の最大長さ
PUBLIC	WIDHDNAME_LEN			; ヘッダー 名の最大長さ
PUBLIC	WIDHDSHOGO_LEN			; ヘッダー 称号の最大長さ
PUBLIC	WIDHDHELP_LEN			; ヘッダー 説明最大長さ

PUBLIC	WIDHED_VIW_MIN			; ヘッダー 表示エリア下限
PUBLIC	WIDHED_VIW_MAX			; ヘッダー 表示エリア上限

PUBLIC	WIDMY_GIRL_NO			; 私の娘Ｎｏ．
PUBLIC	WIDMY_GIRL_OF			; 私の娘アドレス

PUBLIC	WIDTK_CHAR_NO			; 敵キャラクタＮｏ．
PUBLIC	WIDTK_CHAR_OF			; 敵キャラクタアドレス

PUBLIC	WIDCHAR_NUMBER_MUSUME		; 自分の娘のキャラ番号（＝Ｎｏ．０）

PUBLIC	WIDCHAR_DRESS			; 自分の娘の着ている服

PUBLIC	WID_BUTOH_MAX			; 武闘会キャラ数
PUBLIC	WID_BUTOH_TBL			; (byte)武闘会テーブル

PUBLIC	WID_MONSTER_MAX			; モンスターキャラ数
PUBLIC	WID_MONSTER_TBL			; (byte)モンスターテーブル

PUBLIC	WID_MISCON_MAX			; ミスコンキャラ数
PUBLIC	WID_MISCON_TBL			; (byte)ミスコンテーブル

PUBLIC	WID_SHIHAN_MAX			; 師範キャラ数
PUBLIC	WID_SHIHAN_TBL			; (byte)師範テーブル


WIDOFS_HEAD	DW	0		; ヘッダーテーブルオフセット
WIDMAX_HEAD	DW	6		; ヘッダーテーブルレコード数

WIDOFS_GRP	DW	0		; グラフテーブルオフセット
WIDMAX_GRP	DW	0		; グラフテーブルレコード数

WIDOFS_VAL	DW	0		; 内容表示テーブルオフセット
WIDMAX_VAL	DW	0		; 内容表示テーブルレコード数

WIDOFS_GP_TK	DW	0		; 敵・グラフテーブルオフセット
WIDMAX_GP_TK	DW	0		; 敵・グラフテーブルレコード数

WIDOFS_VL_TK	DW	0		; 敵・内容表示テーブルオフセット
WIDMAX_VL_TK	DW	0		; 敵・内容表示テーブルレコード数


WIDOFS_ITEM	DW	0		; アイテムテーブル
WIDOFS_WAZA	DW	0		; 技テーブル
WIDOFS_WORKS	DW	0		; 行いテーブル
WIDOFS_ENVIR	DW	0		; 環境テーブル
WIDOFS_SCHED	DW	0		; スケジュールテーブル

WIDOFS_ENVSTR	DW	0		; 環境文字テーブル
WIDOFS_ENVTIM	DW	0		; 環境時間テーブル
WIDOFS_ENVTSR	DW	0		; 環境開始時間テーブル

WIDNAMELEN	DW	5*2		; グラフ名前最大長さ
WIDHELPLEN	DW	20*2		; グラフ説明最大長さ

WIDVIEW_MIN	DW	0		; グラフ表示エリア下限
WIDVIEW_MAX	DW	24*2		; グラフ表示エリア上限

WIDPRNMLEN	DW	5*2		; 内容表示パラメータ名最大長さ
WIDPRHLLEN	DW	20*2		; 内容表示説明最大長さ
WIDTYP_NM_LEN	DW	7*2		; 内容表示ＮＡＭＥ型最大長さ

WIDHDFNAM_LEN	DW	8*2		; ヘッダー 姓の最大長さ
WIDHDNAME_LEN	DW	8*2		; ヘッダー 名の最大長さ
WIDHDSHOGO_LEN	DW	5*2		; ヘッダー 称号の最大長さ
WIDHDHELP_LEN	DW	20*2		; ヘッダー 説明最大長さ

WIDHED_VIW_MIN	DW	0		; ヘッダー 表示エリア下限
WIDHED_VIW_MAX	DW	24*2		; ヘッダー 表示エリア上限

WIDMY_GIRL_NO	DW	0		; 私の娘Ｎｏ．
WIDMY_GIRL_OF	DW	0		; 私の娘アドレス

WIDTK_CHAR_NO	DW	0		; 敵キャラクタＮｏ．
WIDTK_CHAR_OF	DW	0		; 敵キャラクタアドレス

WIDCHAR_NUMBER_MUSUME	DW	0	; 自分の娘のキャラ番号（＝Ｎｏ．０）

WIDCHAR_DRESS	DW	0		; 自分の娘の着ている服
					; 0=＊＊＊＊＊,1=春服,2=夏服,3=秋,4=冬


WID_BUTOH_MAX	DW	24				; 武闘会キャラ数
WID_BUTOH_TBL	DB	25;24				;max
		DB	 0, 1, 2, 3, 4, 5, 6, 7, 8, 9	; 武闘会テーブル
		DB	10,11,12,13,14,15,16,17,18,19
		DB	20,21,22,23,51	; 51=ｱｰﾈｽﾄ
		;	 1  2  3  4  5  6  7  8  9 10	１番目の０は自分の娘

WID_MONSTER_MAX	DW	10				; モンスターキャラ数
WID_MONSTER_TBL	DB	10				;max
		DB	24,25,26,27,28,29,30,31,32,33	; モンスターテーブル
		;	 1  2  3  4  5  6  7  8  9 10

WID_MISCON_MAX	DW	18				; ミスコンキャラ数
WID_MISCON_TBL	DB	18				;max
		DB	 0,34,35,36,37,38,39,40,41,42	; ミスコンテーブル
		DB	43,44,45,46,47,48,49,50
		;	 1  2  3  4  5  6  7  8  9 10	１番目の０は自分の娘

WID_SHIHAN_MAX	DW	3				; 師範キャラ数
WID_SHIHAN_TBL	DB	3				;max
		DB	51,52,53			; 師範テーブル
		;	 1  2  3  4  5  6  7  8  9 10

DATA	ENDS

	END
;
;	end of "WIDTBL.ASM"
;
