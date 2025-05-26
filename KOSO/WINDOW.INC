; "WINDOW.INC" PC-9801UV11 make by R.H 1990/10/15
;
;
;	ＷＩＮＤＯＷＳ／外部参照
;
;	HED_FLAGS :（フラグ）の説明
;		bit 15,14,13,12,11,10,09,08,07,06,05,04,03,02,01,00
;		bit00 : 表示ＯＮ	王様との会見	(R_OHSAMA.ASM)
;		bit01 : 衛兵ＯＫ		同上
;		bit02 : 近衛隊長ＯＫ		同上
;		bit03 : 侍従ＯＫ		同上
;		bit04 : 侍従長ＯＫ		同上
;		bit05 : 王妃ＯＫ		同上
;		bit06 : 王様ＯＫ		同上
;		bit12 : 病気化		表情替え、娘の会話等
;		bit13 : 非行化			同上
;		bit14 : モンスタ	成長の度合・体重(R_KEISAN.ASM)
;		bit15 : ヒロイン		同上
;
;	HED_FUKU : 着ている服の説明
;		0=何も着ない,1=春服,2=夏服,3=秋,4=冬
;		(WIDCHAR_DRESSも同様)
; (C) 1990 ritsurou hashimoto.


;	環境テーブル

KAN_ENVIR_STR	EQU	0		; 環境文字
KAN_ENVIR_TIME	EQU	2		; 環境時間
KAN_ENVIR_TSRT	EQU	4		; 環境開始時間


;	ヘッダー

HED_FNAME	EQU	0		; 姓
HED_NAME	EQU	0+2		; 名
HED_SHOGO	EQU	0+2+2		; 称号
HED_HP		EQU	0+2+2+2		; ＨＰ
HED_LVL		EQU	0+2+2+2+2	; レベル
HED_HELP	EQU	0+2+2+2+2+2	; 説明
HED_FLAGS	EQU	0+2+2+2+2+2+2	; フラグ
HED_GR_OFS	EQU	0+2+2+2+2+2+2+2		; グラフテーブルオフセット
HED_GR_MAX	EQU	0+2+2+2+2+2+2+2+2	; グラフテーブルレコード数
HED_VA_OFS	EQU	0+2+2+2+2+2+2+2+2+2	; 内容表示テーブルオフセット
HED_VA_MAX	EQU	0+2+2+2+2+2+2+2+2+2+2	; 内容表示テーブルレコード数
HED_LST_MT	EQU	0+2+2+2+2+2+2+2+2+2+2+2		; 持物リスト
HED_LST_WZ	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2	; 技リスト
HED_LST_SB	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2+2	; 装備リスト
HED_LST_MS	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2+2+2	; メッセージリスト
HED_FUKU	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2+2+2+2	; 着ている服
HED_NEXT	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2+2+2+2+2	; 次のヘッダー

;	グラフ

GRP_NAME	EQU	0		; グラフ名前
GRP_VALUE	EQU	0+2		; グラフ数値
GRP_VALMAX	EQU	0+2+2		; グラフ最大
GRP_ATR		EQU	0+2+2+2		; グラフ属性
GRP_HELP	EQU	0+2+2+2+2	; グラフ説明
GRP_FLAGS	EQU	0+2+2+2+2+2	; グラフフラグ
GRP_NEXT	EQU	0+2+2+2+2+2+2	; 次のグラフ

;	内容値

VAL_TORKN	EQU	0		; 内容表示 パラメータ名
VAL_TYPE	EQU	0+2		; 内容表示 内容の型
VAL_UNIT	EQU	0+2+2		; 内容表示 内容の単位系
VAL_VALUE	EQU	0+2+2+2		; 内容表示 内容値
VAL_VALUE_OLD	EQU	0+2+2+2+2	; 内容表示 前回の内容値
VAL_HELP	EQU	0+2+2+2+2+2	; 内容表示 内容説明
VAL_FLAGS	EQU	0+2+2+2+2+2+2	; 内容表示 フラグ
VAL_NEXT	EQU	0+2+2+2+2+2+2+2	; 次の内容表示

;	アイテム

ITM_NAME	EQU	0		; 0.ｱｲﾃﾑ名
ITM_PRICE	EQU	0+2		; 1.値段
ITM_AT_NM1	EQU	0+2+2		; 2.効果１
ITM_AT_VL1	EQU	0+2+2+2		; 3.加減値
ITM_AT_NM2	EQU	0+2+2+2+2	; 4.効果２
ITM_AT_VL2	EQU	0+2+2+2+2+2	; 5.加減値
ITM_AT_NM3	EQU	0+2+2+2+2+2+2	; 6.効果３
ITM_AT_VL3	EQU	0+2+2+2+2+2+2+2		; 7.加減値
ITM_HELP	EQU	0+2+2+2+2+2+2+2+2	; 8.説明
ITM_NEXT	EQU	0+2+2+2+2+2+2+2+2+2	; 次のアイテム

;	行い

GYO_NAME	EQU	0		; 0.技の名
GYO_PRICE	EQU	0+2		; 1.値段
GYO_AT_NM1	EQU	0+2+2		; 2.効果１
GYO_AT_VL1	EQU	0+2+2+2		; 3.加減値
GYO_AT_NM2	EQU	0+2+2+2+2	; 4.効果２
GYO_AT_VL2	EQU	0+2+2+2+2+2	; 5.加減値
GYO_AT_NM3	EQU	0+2+2+2+2+2+2	; 6.効果３
GYO_AT_VL3	EQU	0+2+2+2+2+2+2+2		; 7.加減値
GYO_HELP	EQU	0+2+2+2+2+2+2+2+2	; 8.説明
GYO_NEXT	EQU	0+2+2+2+2+2+2+2+2+2	; 次の行い

;	仕事

WRK_NAME	EQU	0		; 0.仕事名
WRK_PAY		EQU	0+2		; 1.バイト料
WRK_NATUR	EQU	0+2+2		; 2.修正能力
WRK_AT_NM1	EQU	0+2+2+2		; 3.効果１
WRK_AT_VL1	EQU	0+2+2+2+2	; 4.加減値
WRK_AT_NM2	EQU	0+2+2+2+2+2	; 5.効果２
WRK_AT_VL2	EQU	0+2+2+2+2+2+2	; 6.加減値
WRK_AT_NM3	EQU	0+2+2+2+2+2+2+2		; 7.効果３
WRK_AT_VL3	EQU	0+2+2+2+2+2+2+2+2	; 8.加減値
WRK_AT_NM4	EQU	0+2+2+2+2+2+2+2+2+2	; 9.効果４
WRK_AT_VL4	EQU	0+2+2+2+2+2+2+2+2+2+2	; 10.加減値
WRK_AT_NM5	EQU	0+2+2+2+2+2+2+2+2+2+2+2		; 11.効果５
WRK_AT_VL5	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2	; 12.加減値
WRK_ARGE	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2+2	; 13.年齢制限
WRK_HELP	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2+2+2	; 14.説明
WRK_NEXT	EQU	0+2+2+2+2+2+2+2+2+2+2+2+2+2+2+2	; 次の仕事

;	所有

TKE_DIM		EQU	0		; 0.最大
TKE_MAX		EQU	2		; 1.数
TKE_TABLE	EQU	2+2		; 2.テーブル

;	装備

SOB_BUKI	EQU	0		; 0.武器
SOB_KABUTO	EQU	4		; 1.防具・兜
SOB_YOROI	EQU	4*2		; 2.防具・鎧
SOB_TATE	EQU	4*3		; 3.防具・盾

;	内容表示テーブル

VTB_SEIBETU	EQU	0		; 0. 性別
VTB_SEIZA	EQU	VAL_NEXT	; 1. 星座
VTB_KETUEKI	EQU	VAL_NEXT*2	; 2. 血液型
VTB_TANJOBI	EQU	VAL_NEXT*3	; 3. 誕生日
VTB_NENREI	EQU	VAL_NEXT*4	; 4. 年齢
VTB_SINCHO	EQU	VAL_NEXT*5	; 5. 身長
VTB_TAIJU	EQU	VAL_NEXT*6	; 6. 体重
VTB_PROPRT	EQU	VAL_NEXT*7	; 7. プロポー
VTB_OKANE	EQU	VAL_NEXT*8	; 8. お金

;	グラフテーブル

GTB_TAIRYOK	EQU	0		; 0. 体力
GTB_WANRYOK	EQU	GRP_NEXT	; 1. 腕力
GTB_TIRYOKU	EQU	GRP_NEXT*2	; 2. 知力
GTB_KIHIN	EQU	GRP_NEXT*3	; 3. 気品
GTB_KONJYO	EQU	GRP_NEXT*4	; 4. 根性
GTB_HIROU	EQU	GRP_NEXT*5	; 5. 疲労
GTB_IROKE	EQU	GRP_NEXT*6	; 6. 色気
GTB_MORAL	EQU	GRP_NEXT*7	; 7. モラル
GTB_HYOKA	EQU	GRP_NEXT*8	; 8. 評価
GTB_KEIKEN	EQU	GRP_NEXT*9	; 9. 経験値
GTB_SENTOH	EQU	GRP_NEXT*10	;10. 戦闘技術
GTB_SUBAYA	EQU	GRP_NEXT*11	;11. 素早さ
GTB_SOKOH	EQU	GRP_NEXT*12	;12. 装甲強度
GTB_KOUGEK	EQU	GRP_NEXT*13	;13. 攻撃増強
GTB_HP		EQU	GRP_NEXT*14	;14. ＨＰ
GTB_MP		EQU	GRP_NEXT*15	;15. ＭＰ
GTB_ALPHA	EQU	GRP_NEXT*16	;16. ＋α
GTB_WAR		EQU	GRP_NEXT*17	;17.好戦度

ADD_ARBEIT_TBL	EQU	29500		; アルバイトテーブル
ADD_BUGARE_TBL	EQU	29500+30	; 武・学・礼テーブル
ADD_KAIKEN_TBL	EQU	29500+60	; 王様会見テーブル
ADD_KAIWA_TBL	EQU	29500+90	; 会話テーブル

FLAGS_DISP	EQU  0000000000000001B	;bit00 : フラグ／表示ＯＮ
FLAGS_EIHEI	EQU  0000000000000010B	;bit01 : 衛兵ＯＫ
FLAGS_KONOE	EQU  0000000000000100B	;bit02 : 近衛隊長ＯＫ
FLAGS_JIJYU	EQU  0000000000001000B	;bit03 : 侍従ＯＫ
FLAGS_JIJYUCHO	EQU  0000000000010000B	;bit04 : 侍従長ＯＫ
FLAGS_OUHI	EQU  0000000000100000B	;bit05 : 王妃ＯＫ
FLAGS_KING	EQU  0000000001000000B	;bit06 : 王様ＯＫ
FLAGS_BYOUKI	EQU  0001000000000000B	;bit12 : 病気化
FLAGS_HIKOU	EQU  0010000000000000B	;bit13 : 非行化
FLAGS_MONSTER	EQU  0100000000000000B	;bit14 : モンスタ
FLAGS_HEROINE	EQU  1000000000000000B	;bit15 : ヒロイン


TYPE_VALUE	EQU	0		; 内容表示 ＶＡＬＵＥ型
TYPE_BLANCE	EQU	1		; 内容表示 ＢＡＬＡＮＣＥ型
TYPE_NAME	EQU	2		; 内容表示 ＮＡＭＥ型
TYPE_TIME	EQU	3		; 内容表示 ＴＩＭＥ型
TYPE_GOLD	EQU	4		; 内容表示 ＧＯＬＤ型

UNIT_NONE	EQU	0		; 単位系 無し
UNIT_ARGE	EQU	1		; 単位系 年齢
UNIT_CM		EQU	2		; 単位系 ｃｍ
UNIT_KG		EQU	3		; 単位系 ｋｇ
UNIT_PAR	EQU	4		; 単位系 ％
UNIT_GOLD	EQU	5		; 単位系 通貨

DATA	SEGMENT WORD	PUBLIC	'DATA'

EXTRN	SEGWID:WORD		; ＷＩＮＤＯＷＳセグメント

EXTRN	WIDOFS_HEAD:WORD	; ヘッダーテーブルオフセット
EXTRN	WIDMAX_HEAD:WORD	; ヘッダーテーブルレコード数

EXTRN	WIDOFS_GRP:WORD		; グラフテーブルオフセット
EXTRN	WIDMAX_GRP:WORD		; グラフテーブルレコード数

EXTRN	WIDOFS_VAL:WORD		; 内容表示テーブルオフセット
EXTRN	WIDMAX_VAL:WORD		; 内容表示テーブルレコード数

EXTRN	WIDOFS_GP_TK:WORD	; 敵・グラフテーブルオフセット
EXTRN	WIDMAX_GP_TK:WORD	; 敵・グラフテーブルレコード数

EXTRN	WIDOFS_VL_TK:WORD	; 敵・内容表示オフセット
EXTRN	WIDMAX_VL_TK:WORD	; 敵・内容表示レコード数

EXTRN	WIDOFS_ITEM:WORD	; アイテムテーブル
EXTRN	WIDOFS_WAZA:WORD	; 技テーブル
EXTRN	WIDOFS_WORKS:WORD	; 行いテーブル
EXTRN	WIDOFS_ENVIR:WORD	; 環境テーブル
EXTRN	WIDOFS_SCHED:WORD	; スケジュールテーブル

EXTRN	WIDOFS_ENVSTR:WORD	; 環境文字テーブル
EXTRN	WIDOFS_ENVTIM:WORD	; 環境時間テーブル
EXTRN	WIDOFS_ENVTSR:WORD	; 環境開始時間テーブル

EXTRN	WIDNAMELEN:WORD		; グラフ名前最大長さ
EXTRN	WIDHELPLEN:WORD		; グラフ説明最大長さ

EXTRN	WIDVIEW_MIN:WORD	; グラフ表示エリア下限
EXTRN	WIDVIEW_MAX:WORD	; グラフ表示エリア上限

EXTRN	WIDPRNMLEN:WORD		; 内容表示パラメータ名最大長さ
EXTRN	WIDPRHLLEN:WORD		; 内容表示説明最大長さ
EXTRN	WIDTYP_NM_LEN:WORD	; 内容表示ＮＡＭＥ型最大長さ

EXTRN	WIDHDFNAM_LEN:WORD	; ヘッダー 姓の最大長さ
EXTRN	WIDHDNAME_LEN:WORD	; ヘッダー 名の最大長さ
EXTRN	WIDHDSHOGO_LEN:WORD	; ヘッダー 称号の最大長さ
EXTRN	WIDHDHELP_LEN:WORD	; ヘッダー 説明最大長さ

EXTRN	WIDHED_VIW_MIN:WORD	; ヘッダー 表示エリア下限
EXTRN	WIDHED_VIW_MAX:WORD	; ヘッダー 表示エリア上限

EXTRN	WIDMY_GIRL_NO:WORD	; 私の娘Ｎｏ．
EXTRN	WIDMY_GIRL_OF:WORD	; 私の娘アドレス

EXTRN	WIDTK_CHAR_NO:WORD	; 敵キャラクタＮｏ．
EXTRN	WIDTK_CHAR_OF:WORD	; 敵キャラクタアドレス

EXTRN	WIDCHAR_NUMBER_MUSUME:WORD ; 自分の娘のキャラ番号（＝Ｎｏ．０）

EXTRN	WIDCHAR_DRESS:WORD	; 自分の娘の着ている服

EXTRN	WID_BUTOH_MAX:WORD	; 武闘会キャラ数
EXTRN	WID_BUTOH_TBL:BYTE	; (byte)武闘会テーブル

EXTRN	WID_MONSTER_MAX:WORD	; モンスターキャラ数
EXTRN	WID_MONSTER_TBL:BYTE	; (byte)モンスターテーブル

EXTRN	WID_MISCON_MAX:WORD	; ミスコンキャラ数
EXTRN	WID_MISCON_TBL:BYTE	; (byte)ミスコンテーブル

EXTRN	WID_SHIHAN_MAX:WORD	; 師範キャラ数
EXTRN	WID_SHIHAN_TBL:BYTE	; (byte)師範テーブル

DATA	ENDS

;
;	end of "WINDOW.INC"
;
