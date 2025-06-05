; "WINDOW4.ASM" PC-9801UV11 make by R.H 1991/03/20
;
;
;	ＷＩＮＤＯＷＳ／テストデータ(KASM)
;
;	・台詞
;
; (C) 1990 ritsurou hashimoto.

;	このソースは独立してＣＯＭ形式のファイルと
;	することも可能です。
;	そのときは "KOSODATE_HEADER"（ヘッダーであることを示す）と
;	いう、文字列を検索してヘッダー情報を捜します。

;
;	KASM WINDOW1.ASM WINDOW1.W
;	KASM WINDOW2.ASM WINDOW2.W ; 内容表示テーブル（静的パラメータ系）
;	KASM WINDOW3.ASM WINDOW3.W ; グラフテーブル（動的パラメータ系）
;	KASM WINDOW4.ASM WINDOW4.W ; 台詞
;	MASM WINDOW1.W;
;	LINK WINDOW1;
;	EXE2BIN WINDOW1.EXE WINDOW1.COM
;

マリア・MESS	LABEL	WORD
	DW	マリア01,マリア02
 マリア01	DB "＊＊＊",0
 マリア02	DB "＊＊＊＊＊＊",0

シーラ・MESS	LABEL	WORD
	DW	シーラ01,シーラ02
 シーラ01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 シーラ02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

キング・MESS	LABEL	WORD
	DW	キング01,キング02
 キング01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 キング02	DB "＊＊＊＊＊＊＊",0

キラー・MESS	LABEL	WORD
	DW	キラー01,キラー02
 キラー01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 キラー02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

ゴリラ・MESS	LABEL	WORD
	DW	ゴリラ01,ゴリラ02
 ゴリラ01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 ゴリラ02	DB "＊＊＊＊",0

サ・MESS	LABEL	WORD
	DW	サ01,サ02
 サ01	DB "＊＊＊＊＊＊＊＊",0
 サ02	DB "＊＊＊＊＊＊＊＊＊＊＊",0

フォン・MESS	LABEL	WORD
	DW	フォン01,フォン02
 フォン01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 フォン02	DB "＊＊＊＊＊＊＊＊＊＊＊＊…",0

リー・MESS	LABEL	WORD
	DW	リー01,リー02
 リー01	DB "＊＊",0
 リー02	DB "＊＊",0

クルト・MESS	LABEL	WORD
	DW	クルト01,クルト02
 クルト01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 クルト02	DB "＊＊＊＊＊＊＊＊＊＊",0

マーク・MESS	LABEL	WORD
	DW	マーク01,マーク02
 マーク01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 マーク02	DB "＊＊＊＊＊＊＊＊＊＊＊",0

キム・MESS	LABEL	WORD
	DW	キム01,キム02
 キム01	DB "＊＊＊＊＊＊＊＊＊",0
 キム02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊",0

ヨヘン・MESS	LABEL	WORD
	DW	ヨヘン01,ヨヘン02
 ヨヘン01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 ヨヘン02	DB "＊＊＊＊＊＊＊＊＊",0

ハリセン・MESS	LABEL	WORD
	DW	ハリセン01,ハリセン02
 ハリセン01	DB "＊＊＊＊＊＊",0
 ハリセン02	DB "＊＊＊＊",0

ジャネット・MESS	LABEL	WORD
	DW	ジャネット01,ジャネット02
 ジャネット01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 ジャネット02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

スプリング・MESS	LABEL	WORD
	DW	スプリング01,スプリング02
 スプリング01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 スプリング02	DB "＊＊＊＊＊＊＊＊＊＊",0

バラン・MESS	LABEL	WORD
	DW	バラン01,バラン02
 バラン01	DB "＊＊＊＊",0
 バラン02	DB "＊＊＊＊＊＊…＊＊＊",0

シルビー・MESS	LABEL	WORD
	DW	シルビー01,シルビー02
 シルビー01	DB "＊＊＊＊",0
 シルビー02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

キティ・MESS	LABEL	WORD
	DW	キティ01,キティ02
 キティ01	DB "＊＊＊＊＊＊",0
 キティ02	DB "＊＊＊＊",0

カタリナ・MESS	LABEL	WORD
	DW	カタリナ01,カタリナ02
 カタリナ01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 カタリナ02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

イワン・MESS	LABEL	WORD
	DW	イワン01,イワン02
 イワン01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 イワン02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 
バアトル・MESS	LABEL	WORD
	DW	バアトル01,バアトル02
 バアトル01	DB "＊＊＊＊＊＊",0
 バアトル02	DB "＊＊＊＊",0

ウルフ・MESS	LABEL	WORD
	DW	ウルフ01,ウルフ02
 ウルフ01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 ウルフ02	DB "＊＊＊＊",0

ケン・MESS	LABEL	WORD
	DW	ケン01,ケン02
 ケン01	DB "＊＊＊＊＊＊＊＊＊",0
 ケン02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

オットー・MESS	LABEL	WORD
	DW	オットー01,オットー02
 オットー01	DB "＊＊＊＊＊＊＊",0
 オットー02	DB "＊＊＊＊",0

人さらい・MESS	LABEL	WORD
	DW	人さらい01,人さらい02
 人さらい01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 人さらい02	DB "＊＊＊＊＊＊＊＊＊＊＊＊",0

アミーバ・MESS	LABEL	WORD
	DW	アミーバ01,アミーバ02
 アミーバ01	DB "＊＊＊＊＊＊＊",0
 アミーバ02	DB "＊＊＊＊＊＊",0

山猫・MESS	LABEL	WORD
	DW	山猫01,山猫02
 山猫01	DB "＊＊＊＊＊",0
 山猫02	DB "＊＊＊＊＊＊＊",0

おいはぎ・MESS	LABEL	WORD
	DW	おいはぎ01,おいはぎ02
 おいはぎ01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 おいはぎ02	DB "＊＊＊＊＊＊＊＊＊＊",0

オーク・MESS	LABEL	WORD
	DW	オーク01,オーク02
 オーク01	DB "＊＊＊＊＊",0
 オーク02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

オオカミ・MESS	LABEL	WORD
	DW	オオカミ01,オオカミ02
 オオカミ01	DB "＊＊＊＊＊＊",0
 オオカミ02	DB "＊＊＊＊＊＊＊",0

蛮族・MESS	LABEL	WORD
	DW	蛮族01,蛮族02
 蛮族01	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
 蛮族02	DB "＊＊＊",0

ハーピー・MESS	LABEL	WORD
	DW	ハーピー01,ハーピー02
 ハーピー01	DB "＊＊＊＊＊＊",0
 ハーピー02	DB "＊＊＊",0

トラ・MESS	LABEL	WORD
	DW	トラ01,トラ02
 トラ01	DB "＊＊＊＊＊＊＊＊＊",0
 トラ02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

ドラゴン・MESS	LABEL	WORD
	DW	ドラゴン01,ドラゴン02
 ドラゴン01	DB "＊＊＊＊＊＊＊",0
 ドラゴン02	DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

リリザ・MESS	LABEL	WORD
	DW	リリザ01,リリザ02
 リリザ01	DB 0 ;"",0
 リリザ02	DB 0 ;"",0

シルビア・MESS	LABEL	WORD
	DW	シルビア01,シルビア02
 シルビア01	DB 0 ;"",0
 シルビア02	DB 0 ;"",0

エヴァ・MESS	LABEL	WORD
	DW	エヴァ01,エヴァ02
 エヴァ01	DB 0 ;"",0
 エヴァ02	DB 0 ;"",0

リンダ・MESS	LABEL	WORD
	DW	リンダ01,リンダ02
 リンダ01	DB 0 ;"",0
 リンダ02	DB 0 ;"",0

カルナ・MESS	LABEL	WORD
	DW	カルナ01,カルナ02
 カルナ01	DB 0 ;"",0
 カルナ02	DB 0 ;"",0

アシッド・MESS	LABEL	WORD
	DW	アシッド01,アシッド02
 アシッド01	DB 0 ;"",0
 アシッド02	DB 0 ;"",0

リリス・MESS	LABEL	WORD
	DW	リリス01,リリス02
 リリス01	DB 0 ;"",0
 リリス02	DB 0 ;"",0

ロナ・MESS	LABEL	WORD
	DW	ロナ01,ロナ02
 ロナ01	DB 0 ;"",0
 ロナ02	DB 0 ;"",0

クラリーノ・MESS	LABEL	WORD
	DW	クラリーノ01,クラリーノ02
 クラリーノ01	DB 0 ;"",0
 クラリーノ02	DB 0 ;"",0

アキ・MESS	LABEL	WORD
	DW	アキ01,アキ02
 アキ01	DB 0 ;"",0
 アキ02	DB 0 ;"",0

ノーラ・MESS	LABEL	WORD
	DW	ノーラ01,ノーラ02
 ノーラ01	DB 0 ;"",0
 ノーラ02	DB 0 ;"",0

カル・MESS	LABEL	WORD
	DW	カル01,カル02
 カル01	DB 0 ;"",0
 カル02	DB 0 ;"",0

ナスタナーラ・MESS	LABEL	WORD
	DW	ナスタナーラ01,ナスタナーラ02
 ナスタナーラ01	DB 0 ;"",0
 ナスタナーラ02	DB 0 ;"",0

ドミノ・MESS	LABEL	WORD
	DW	ドミノ01,ドミノ02
 ドミノ01	DB 0 ;"",0
 ドミノ02	DB 0 ;"",0

ユー・MESS	LABEL	WORD
	DW	ユー01,ユー02
 ユー01	DB 0 ;"",0
 ユー02	DB 0 ;"",0

リベ・MESS	LABEL	WORD
	DW	リベ01,リベ02
 リベ01	DB 0 ;"",0
 リベ02	DB 0 ;"",0

ノコレア・MESS	LABEL	WORD
	DW	ノコレア01,ノコレア02
 ノコレア01	DB 0 ;"",0
 ノコレア02	DB 0 ;"",0

アーネスト・MESS	LABEL	WORD
エレミス・MESS		LABEL	WORD
ラトス・MESS		LABEL	WORD
	DW	ラトス01,ラトス02
 ラトス01	DB 0 ;"",0
 ラトス02	DB 0 ;"",0

;
;	end of "WINDOW4.ASM"
;
