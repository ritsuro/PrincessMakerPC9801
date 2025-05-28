; "R_KEISAN.ASM" PC-9801UV11 make by R.H 1990/11/9
;
;
;	「子育て」
;
;	計算処理
;
;
; (C) 1990 ritsurou hashimoto.

;	・体力とＨＰ
;		ＨＰ＝体力値
;		ＨＰが上昇すると体力値が上昇
;		ＨＰが下降すると体力値が下降
;		ＨＰは体力最大値を越えられない
;
;	・知力とＭＰ
;		ＭＰ＝知力値
;		但し技が無いときは０
;		ＭＰが上昇すると知力値が上昇
;		ＭＰが下降すると知力値が下降
;		ＭＰは知力最大値を越えられない
;
;	・生き返らせる
;		キャラは何度でも生き返えられる

INCLUDE	TSTSET.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO\WINDOW.INC

OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


SUBZ	MACRO	DEST,SOUR
	LOCAL	L1
	MOV	AX,SOUR
	SUB	DEST,AX
	JNB	L1
	MOV	DEST,WORD PTR 0
L1:
	ENDM


;	符号無しオーバフロー防止

ADDOV	MACRO	DEST,SOUR
	LOCAL	L1
	MOV	AX,SOUR
	ADD	DEST,AX
	JNB	L1
	MOV	DEST,WORD PTR 0FFFFH
L1:
	ENDM

;	符号付きオーバフロー防止

ADDS	MACRO	DEST,SOUR
	LOCAL	L1,L2
	MOV	AX,SOUR
	CMP	AX,0
	JL	L1
	ADD	DEST,AX
	CMP	DEST,07FFFH
	JBE	L2
	MOV	DEST,07FFFH
	JMP	L2
L1:
	NEG	AX
	SUB	DEST,AX
	JNB	L2
	MOV	DEST,WORD PTR 0
L2:
	ENDM

SUBS	MACRO	DEST,SOUR
	LOCAL	L1,L2
	MOV	AX,SOUR
	CMP	AX,0
	JL	L1
	SUB	DEST,AX
	JNB	L2
	MOV	DEST,WORD PTR 0
	JMP	L2
L1:
	NEG	AX
	ADD	DEST,AX
	CMP	DEST,07FFFH
	JBE	L2
	MOV	DEST,07FFFH
L2:
	ENDM


FLOAT_IN	MACRO	AAA
	SHL	AAA,1			;2
	SHL	AAA,1			;4
	SHL	AAA,1			;8
	SHL	AAA,1			;16
	SHL	AAA,1			;32
	SHL	AAA,1			;64
	SHL	AAA,1			;128
	SHL	AAA,1			;256
	ENDM

FLOAT_OUT	MACRO	AAA
	SHR	AAA,1			;256
	SHR	AAA,1			;128
	SHR	AAA,1			;64
	SHR	AAA,1			;32
	SHR	AAA,1			;16
	SHR	AAA,1			;8
	SHR	AAA,1			;4
	SHR	AAA,1			;2
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

DIVX	MACRO	RRR
	LOCAL	LL
	CMP	RRR,0
	JE	LL
	DIV	RRR
LL:
	ENDM


MAXCUT	MACRO	DT,MN,MX
	LOCAL	L1,L2
	CMP	DT,MN
	JNB	L1
	MOV	DT,MN
	JMP	L2
L1:
	CMP	DT,MX
	JBE	L2
	MOV	DT,MX
L2:
	ENDM

;	Ｒ＿ＳＥＧセグメントからＣＯＤＥセグメントへ

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

;	ＣＯＤＥセグメントからＲ＿ＳＥＧセグメントへ

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:R_SEG,DS:DATA
L1:
	ENDM


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_KEISAN		; 各計算処理

EXTRN	RANDAM_CX:NEAR		; 乱数範囲指定

EXTRN	WIDHBR:NEAR		; WINDOWS/横グラフ表示
EXTRN	WIDHBRN:NEAR		; WINDOWS/横グラフ表示（ブリンクなし）
EXTRN	WIDHBRS:NEAR		; WINDOWS/横グラフ再表示
;;EXTRN	WIDHBR_MAX:NEAR		; WINDOWS/横グラフ最大表示


; ****************************************************
;	各計算処理
;	-I- S_FUNC : 計算ファンクション
;	    =0  : 無効
;	    =1  : 買物計算
;	    =2  : 2=アルバイト成功率計算
;	    =3  : 3=アルバイトパラメータ計算
;	    =4  : 4=休息最高予算
;	    =5  : 5=休息パラメータ計算
;	    =6  : 6=学問成功率計算
;	    =7  : 7=学問パラメータ計算
;	    =8  : 8=支払い
;	    =9  : 9=礼法成功率計算
;	    =10 :10=礼法パラメータ計算
;	    =11 :11=武芸成功率計算
;	    =12 :12=武芸パラメータ計算
;	    =13 :13=道具使用
;	    =14 :14=ヘッダー整合
;	    =15 :15=装備・つける
;	    =16 :16=装備・はずす
;	    =17 :17=先手計算
;	    =18 :18=命中率計算
;	    =19 :19=ダメージ計算
;	    =20 :20=会心確率
;	    =21 :21=逃げる成功率計算
;	    =22 :22=勝手に逃げる確率計算
;	    =23 :23=ダメージ判定
;	    =24 :24=グラフ整合
;	    =25 :25=内容表示整合
;	    =26 :26=レベルＵＰ
;	    =27 :27=キャラクタの全整合チェック
;	    =28 :28=ＨＰセット
;	    =29 :29=ＭＰセット
;	    =30 :30=生き返る
;	    =31 :31=年齢、身長、体重、評価をみる
;	    =32 :32=マッハモード
;	    =33 :33=ミスコン予想
;	    =34 :34=お金見る
;	    =35 :35=お金払う
;	    =36 :36=お金貰う
;	    =37 :37=ミスコン投票ソーティング
;	    =38 :38=ミスコン投票合計計算
;	    =39 :39=バトル即効計算
;	    =40 :40=町の評判
;	    =41 :41=ヘッダーフラグのＩ／Ｏ
;	    =42 :42=評価処理
;	    =43 :43=会見チェック
;	    =44 :44=誕生日と年齢
;	    =45 :45=回復
;	    =46 :46=身長・体重の成長
;	    =47 :47=ポイントの成長
;	    =48 :48=バカンスパラメータ計算
;	    =49 :49=服は何を着ているか
;	    =50 :50=服の着替え
;	    =51 :51=ＭＰの消費チェック
;	    =52 :52=ＭＰの消費
;	    =53 :53=装甲強度の一時ＵＰ
;	    =54 :54=装甲強度の通常値
;	    =55 :55=ＨＰの回復
;	    =56 :56=話しかける成功率
;	    =57 :57=モラル計算
;	    =58 :58=娘と話す計算
;	    =59 :59=体力、腕力・・・で一番は
;	    =60 :60=体力、腕力・・・で苦手は
;	    =61 :61=疲労の度合
;	    =62 :62=気品段階
;	    =63 :63=経験値の処理
;	    =64 :64=根性の処理
;	    =65 :65=非行化・病気化
;	    =66 :66=運命の決定
;	    =67 :67=売りたし
;	    =68 :68=買取り価格
;	    =69 :69=敵から金と経験値を貰う
;	    =70 :70=病気の日次処理
;	    =71 :71=とにかく疲労回復
;	    =72 :72=収穫祭等の評価
;	    =73 :73=装備・ＧＥＴ
;	    =74 :74=武者修行の日次処理
; ****************************************************

R_KEISAN	PROC	NEAR
;*DBG*;	PRV	"R_KEISAN -I- S_FUNC=",S_FUNC

	CMP	S_FUNC,74			; ７４の計算式
	JG	R_KEISAN_EXIT			;

	MOV	BP,S_FUNC			; 計算ファンクション
	CALL	FAR PTR R_FUNTION		; 各ファンクション

R_KEISAN_EXIT:
;*DBG*;	PRF	"R_KEISAN -O-"
	RET
R_KEISAN	ENDP


; ****************************************************
;	グラフ表示フック
;	-I- AX : 横グラフ番号
;	    DX : 表示値
;	    BX : 表示停止スイッチ=1
; ****************************************************

HOOK_CODE	PROC	FAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	MOV	WDGNO,AX		; 横グラフ番号
	MOV	WDVAL,DX		; 表示値

	CMP	BX,1			; 表示停止スイッチ=1
	JE	HOOK_CODE_5		;

	CALL	WIDHBRS			; WINDOWS/横グラフ再表示
;*;	CALL	WIDHBR			; WINDOWS/横グラフ表示
	JMP	HOOK_CODE_8		;
HOOK_CODE_5:
	CALL	WIDHBRN			; WINDOWS/横グラフ（ブリンクなし）
HOOK_CODE_8:
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
HOOK_CODE	ENDP


; ****************************************************
;	乱数範囲指定フック
;	-I- CX : 範囲（２００以内）
;	-O- AX : １からＣＸの数字
; ****************************************************

HOOK_CODE_RANDAM	PROC	FAR
	PUSH	ES
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	BP
;*;	PRV	"RANDAM_CX -I- CX=",CX
	CALL	RANDAM_CX		; 乱数範囲指定
;*;	PRV	"RANDAM_CX -O- AX=",AX
	POP	BP
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	ES
	RET
HOOK_CODE_RANDAM	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

R_FUNTION_TABLE		LABEL	WORD
	DW	R_FUNTION_RETN			; 0=何もしない
	DW	CALC_KAIMONO			; 1=買物
	DW	CALC_ARBEIT			; 2=アルバイト成功率計算
	DW	CALC_A_PARAM			; 3=アルバイトパラメータ計算
	DW	CALC_KYUYOSAN			; 4=休息最高予算
	DW	CALC_KYU_PAR			; 5=休息パラメータ計算
	DW	CALC_GAKUMON			; 6=学問成功率計算
	DW	CALC_GAK_PAR			; 7=学問パラメータ計算
	DW	CALC_PAY			; 8=支払い
	DW	CALC_REIHOU			; 9=礼法成功率計算
	DW	CALC_REI_PAR			; 10=礼法パラメータ計算
	DW	CALC_BUGEI			; 11=武芸成功率計算
	DW	CALC_BUG_PAR			; 12=武芸パラメータ計算
	DW	CALC_DOUGU			; 13=道具使用
	DW	CALC_HEAD_GO			; 14=ヘッダー整合
	DW	CALC_S_CHAKU			; 15=装備・つける
	DW	CALC_S_DATSU			; 16=装備・はずす
	DW	CALC_SENTE			; 17=先手計算
	DW	CALC_HIT			; 18=命中率計算
	DW	CALC_DAMEGE			; 19=ダメージ計算
	DW	CALC_KAISIN			; 20=会心確率
	DW	CALC_NIGERU			; 21=逃げる成功率計算
	DW	CALC_NIGETA			; 22=勝手に逃げる確率計算
	DW	CALC_DAM_CHK			; 23=ダメージ判定
	DW	CALC_GRAP_GO			; 24=グラフ整合
	DW	CALC_VAL_GO			; 25=内容表示整合
	DW	CALC_LEVEL_UP			; 26=レベルＵＰ
	DW	CALC_CHR_ALL_CHK		; 27=キャラクタの全整合チェック
	DW	CALC_HP_FUKKATU			; 28=ＨＰセット
	DW	CALC_MP_FUKKATU			; 29=ＭＰセット
	DW	CALC_IKIKAERU			; 30=生き返る
	DW	CALC_SHOW_PROPR			; 31=年齢、身長、体重、評価
	DW	CALC_MACH_MODE			; 32=マッハモード
	DW	CALC_MISS_YOSOH			; 33=ミスコン予想
	DW	CALC_MONEY_SHOW			; 34=お金見る
	DW	CALC_MONEY_PAY			; 35=お金払う
	DW	CALC_MONEY_GIVE			; 36=お金貰う
	DW	CALC_MISS_SORT			; 37=ミスコン投票ソーティング
	DW	CALC_MISS_GOUKEI		; 38=ミスコン投票合計計算
	DW	CALC_BATLE_KETSU		; 39=バトル即効決着
	DW	CALC_HYOHBAN			; 40=町の評判
	DW	CALC_H_FLAGS			; 41=ヘッダーフラグのＩ／Ｏ
	DW	CALC_H_HYOUKA			; 42=評価処理
	DW	CALC_KAIKEN_CHK			; 43=会見チェック
	DW	CALC_TANJYO_CHK			; 44=誕生日と年齢
	DW	CALC_KAIFUKU_CHK		; 45=回復
	DW	CALC_SEICHO_VAL			; 46=身長・体重の成長
	DW	CALC_SEICHO_GRP			; 47=ポイントの成長
	DW	CALC_BACANCE_PAR		; 48=バカンスパラメータ計算
	DW	CALC_FUKU_NANI			; 49=服は何を着ているか
	DW	CALC_FUKU_KIGAE			; 50=服の着替え
	DW	CALC_MP_CHECK			; 51=ＭＰの消費チェック
	DW	CALC_MP_SHOHI			; 52=ＭＰの消費
	DW	CALC_SOUKOU_1UP			; 53=装甲強度の一時ＵＰ
	DW	CALC_SOUKOU_NORMAL		; 54=装甲強度の通常値
	DW	CALC_HP_KAIFUKU			; 55=ＨＰの回復
	DW	CALC_TALK_SC			; 56=話しかける成功率
	DW	CALC_MORAL			; 57=モラル計算
	DW	CALC_MUSUME			; 58=娘と話す計算
	DW	CALC_ICHIBAN			; 59=体力、腕力・・・で一番は
	DW	CALC_NIGATE			; 60=体力、腕力・・・で苦手は
	DW	CALC_HIROU			; 61=疲労の度合
	DW	CALC_KIHIN			; 62=気品段階
	DW	CALC_KEIKEN			; 63=経験値の処理
	DW	CALC_KONJYO			; 64=根性の処理
	DW	CALC_HIKOU_BYO			; 65=非行化・病気化
	DW	CALC_UNMEI			; 66=運命の決定
	DW	CALC_URITASHI			; 67=売りたし
	DW	CALC_KAITORI			; 68=買取り価格
	DW	CALC_TK_UBAU			; 69=敵から金と経験値を貰う
	DW	CALC_BYOUKI			; 70=病気の日次処理
	DW	CALC_KAIFUKU			; 71=とにかく疲労回復
	DW	CALC_S_HYOUKA			; 72=収穫祭等の評価
	DW	CALC_SOUBI_GET			; 73=装備・ＧＥＴ
	DW	CALC_MUSYA_UP			; 74=武者修行の日次処理
DATA	ENDS


;	セグメント	Ｒ＿ＳＥＧ


R_SEG	SEGMENT	PUBLIC	'R_SEG'

	ASSUME	CS:R_SEG,DS:DATA

; ****************************************************
;	各ファンクション
;	-I- BP  : 計算ファンクション
;		R_KEISAN と同様
; ****************************************************

R_FUNTION	PROC	FAR
	SHL	BP,1				; word pointer.
	CALL	WORD PTR DS:R_FUNTION_TABLE[BP]	;
R_FUNTION_EXIT:
	RET
R_FUNTION	ENDP

; ****************************************************
;	何もしない
; ****************************************************

R_FUNTION_RETN	PROC	NEAR
	RET
R_FUNTION_RETN	ENDP


; ****************************************************
;	グラフ表示フック
;	-I- AX : 横グラフ番号
;	    DX : 表示値
;	    BX : 表示停止スイッチ=1
; ****************************************************

HOOK_WIDHBR	PROC	NEAR
	CMP	MODE_SW,1		; モードスイッチ 0=ノーマル,1=マッハ
	JE	HOOK_WIDHBR_EXIT	;

	CALL	FAR PTR HOOK_CODE	; グラフ表示フック

HOOK_WIDHBR_EXIT:			;
	RET
HOOK_WIDHBR	ENDP


; ****************************************************
;	乱数範囲指定フック
;	-I- CX : 範囲（２００以内）
;	-O- AX : １からＣＸの数字
; ****************************************************

HOOK_RANDAM	PROC	NEAR
	CALL	FAR PTR HOOK_CODE_RANDAM	; 乱数範囲指定フック
	RET
HOOK_RANDAM	ENDP



; ****************************************************
;	買物
;	-I- AX : 誰が買うか（アドレス）
;	    BX : 何を買うか（アドレス）
;	    CX : 買う物のアイテム種別
;		0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾,4=道具,5=資格
;	    DX : 買う物のアイテムレコードＮＯ
;	-O- AX : 0=買いました,1=お金が足りません,2=いっぱいで持てません
; ****************************************************

CALC_KAIMONO	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	ADRS_ITEM,BX		; アイテム
	MOV	VAL_ATTR,CX		; 種別
	MOV	VAL_RECNO,DX		; レコードＮＯ

CALC_KAIMONO_MAX_CHK:

	; 持物リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	MOV	SI,ES:[BX][HED_LST_MT]	; SI=持物リスト

	; 持物数

	MOV	AX,ES:[SI][TKE_MAX]	; AX=数
	MOV	BX,ES:[SI][TKE_DIM]	; BX=最大
	CMP	AX,BX			;
	JB	CALC_KAIMONO_MY_MONEY	;
	JMP	CALC_KAIMONO_UPP	;


CALC_KAIMONO_MY_MONEY:

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 内容表示テーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_VA_OFS]	; 内容表示テーブルオフセット
					; SI=内容表示テーブル
	; お金

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	AX,ES:[SI][VTB_OKANE][VAL_VALUE] ; お金
	MOV	MY_MONEY,AX		; 私のお金

CALC_KAIMONO_PRICE:

	; アイテム

	MOV	BX,ADRS_ITEM		; アイテム

	; お値段

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	AX,ES:[BX][ITM_PRICE]	; 1.値段
	MOV	PRICE,AX		; お値段


CALC_KAIMONO_CHK:
	CMPX	PRICE,MY_MONEY		; お値段と私のお金（高い？）
	JNBE	CALC_KAIMONO_ERROR	;


CALC_KAIMONO_BUY:
	SUBZ	MY_MONEY,PRICE		; 私のお金－お値段

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 内容表示テーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_VA_OFS]	; 内容表示テーブルオフセット
					; SI=内容表示テーブル
	; お金

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOVX	ES:[SI][VTB_OKANE][VAL_VALUE],MY_MONEY	; 私のお金




	; 持物リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	MOV	SI,ES:[BX][HED_LST_MT]	; SI=持物リスト

	; 持物数

	MOV	DI,ES:[SI][TKE_MAX]	; DI=数
	SHL	DI,1			;
	SHL	DI,1			; * 4
	ADD	DI,TKE_TABLE		;
	ADD	DI,SI			; DI=テーブル
	INC	WORD PTR ES:[SI][TKE_MAX] ; 数＋１

	; 持物リスト

	MOVX	ES:[DI],VAL_ATTR	; 種別
	MOVX	ES:[DI][2],VAL_RECNO	; レコードＮＯ

CALC_KAIMONO_EXIT:
	MOV	AX,0		; 0=買いました
	RET
CALC_KAIMONO_ERROR:
	MOV	AX,1		; 1=お金が足りません
	RET
CALC_KAIMONO_UPP:
	MOV	AX,2		; 2=いっぱいで持てません
	RET
CALC_KAIMONO	ENDP



; ****************************************************
;	アルバイト成功率計算
;	-I- AX : 誰か
;	    BX : 行いパラメータのアドレス
;	    SI : グラフテーブルアドレス
;	-O- AX : 成功率
; ****************************************************

CALC_ARBEIT	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	ADRS_WORKS,BX		; 行いパラメータのアドレス
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_WORKS		; 行いパラメータのアドレス
	CALL	LOAD_WORKS		; 行いパラメータＬＯＡＤ
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	; 成功率＝１００÷（根性＋疲労度＋修正能力）×（根性＋修正能力）


	; 修正能力は？

	MOV	DX,U_KIND		; 2.修正能力
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索

	CMP	AX,0			; 0=正常
	JE	CALC_ARBEIT_21		;
	MOV	KIND_VAL,0		; 修正能力値
	JMP	CALC_ARBEIT_22		;
CALC_ARBEIT_21:
	MOVX	KIND_VAL,DS:[BX][GRP_VALUE]	; 修正能力値
CALC_ARBEIT_22:

	; ＡＸ＝根性＋疲労度＋修正能力

	MOV	AX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	AX,G_HIROU[GRP_VALUE]	; 5. 疲労
	ADD	AX,KIND_VAL		; 修正能力値

	; ＢＸ＝根性＋修正能力

	MOV	BX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	BX,KIND_VAL		; 修正能力値


	; 成功率＝１００÷ＡＸ×ＢＸ

	MOV	CX,AX			;
	MOV	AX,60000		;
	MOV	DX,0			;
	DIVX	CX			;

	MUL	BX			; ＡＸ×ＢＸ

	MOV	BX,600			;
	DIVX	BX			;

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	TEST	WORD PTR ES:[BX][HED_FLAGS],FLAGS_BYOUKI ; bit12 : 病気化
	JZ	CALC_ARBEIT_9

	MOV	DX,0			;
	MOV	BX,3			;
	DIV	BX			; 病気時は成功率１／３
CALC_ARBEIT_9:
	RET
CALC_ARBEIT	ENDP


; ****************************************************
;	アルバイトパラメータ計算
;	-I- AX : 誰か（アドレス）
;	    BX : 行いパラメータのアドレス
;	    SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	-O- SI : 変動グラフテーブル
;	    AX : 収入額
; ****************************************************

CALC_A_PARAM	PROC	NEAR
	MOV	ADRS_HOW,AX		; 誰か（アドレス）
	MOV	ADRS_WORKS,BX		; 行いパラメータのアドレス
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス

	MOV	BX,ADRS_WORKS		; 行いパラメータのアドレス
	CALL	LOAD_WORKS		; 行いパラメータＬＯＡＤ
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ


	ADDX	V_OKANE[VAL_VALUE],U_PAY ; バイト料

	MOV	STG_WRTF1,OFFF		; 変動グラフ１
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	MOV	DX,U_KKA1		; 効果１
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JMPEQ	CALC_A_PARAM_SET	;

	ADDX	DS:[BX][GRP_VALMAX],U_VAL1 ; 加減値
	ADDX	DS:[BX][GRP_VALUE] ,U_VAL1 ; 加減値
	MOVX	STG_WRTF1,RECNO		; 変動グラフ１
	MOV 	STG_AD_WRTF1,BX		; 変動グラフ１


	MOV	DX,U_KKA2		; 効果２
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JMPEQ	CALC_A_PARAM_SET	;

	ADDX	DS:[BX][GRP_VALUE] ,U_VAL2 ; 加減値
	ADDX	DS:[BX][GRP_VALMAX],U_VAL2 ; 加減値
	MOVX	STG_WRTF2,RECNO		; 変動グラフ２
	MOV 	STG_AD_WRTF2,BX		; 変動グラフ２


	MOV	DX,U_KKA3		; 効果３
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JE	CALC_A_PARAM_SET	;

	ADDX	DS:[BX][GRP_VALUE] ,U_VAL3 ; 加減値
	ADDX	DS:[BX][GRP_VALMAX],U_VAL3 ; 加減値
	MOVX	STG_WRTF3,RECNO		; 変動グラフ３
	MOV 	STG_AD_WRTF3,BX		; 変動グラフ３


	MOV	DX,U_KKA4		; 効果４
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JE	CALC_A_PARAM_SET	;

	ADDX	DS:[BX][GRP_VALUE] ,U_VAL4 ; 加減値
	ADDX	DS:[BX][GRP_VALMAX],U_VAL4 ; 加減値
	MOVX	STG_WRTF4,RECNO		; 変動グラフ４
	MOV 	STG_AD_WRTF4,BX		; 変動グラフ４


	MOV	DX,U_KKA5		; 効果５
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JE	CALC_A_PARAM_SET	;

	ADDX	DS:[BX][GRP_VALUE] ,U_VAL5 ; 加減値
	ADDX	DS:[BX][GRP_VALMAX],U_VAL5 ; 加減値
	MOVX	STG_WRTF5,RECNO		; 変動グラフ５
	MOV 	STG_AD_WRTF5,BX		; 変動グラフ５


CALC_A_PARAM_SET:
	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	MOV	AX,ADRS_HOW		; 誰か（アドレス）
	MOV	DX,0			; 復活するポイント
	CALL	CALC_HP_FUKKATU		; ＨＰセット

	MOV	AX,ADRS_HOW		; 誰か（アドレス）
	MOV	DX,0			; 復活するポイント
	CALL	CALC_MP_FUKKATU		; ＭＰセット

	CALL	CHK_GRP_DISP		; グラフ表示

	MOV	SI,OFFSET STG_TABLE	; 変動グラフテーブル
	RET
CALC_A_PARAM	ENDP



; ****************************************************
;	グラフ表示
;	-I- STG_TABLE[]    : 変動グラフテーブル
;	    STG_AD_TABLE[] : 変動グラフアドレステーブル
;	    VIEW_STOP      : 表示停止スイッチ=1
; ****************************************************

CHK_GRP_DISP	PROC	NEAR
	MOV	SI,0				; word pointer.
	MOV	CX,5
CHK_GRP_DISP_LOOP:
	MOV	AX,DS:STG_TABLE[SI]		; 変動グラフテーブル
	CMP	AX,OFFF				;
	JE	CHK_GRP_DISP_EXIT		;

	MOV	BX,DS:STG_AD_TABLE[SI]		; 変動グラフアドレステーブル
	MOV	DX,DS:[BX][GRP_VALUE]		; 表示値
	MOV	BX,VIEW_STOP			; 表示停止スイッチ=1
	CALL	HOOK_WIDHBR			; グラフ表示フック

	INC	SI				;
	INC	SI				; word pointer.
	LOOP	CHK_GRP_DISP_LOOP
CHK_GRP_DISP_EXIT:
	RET
CHK_GRP_DISP	ENDP


; ****************************************************
;	グラフ表示２
;	-I- STG_TABLE[]    : 変動グラフテーブル
;	    STG_AD_TABLE[] : 変動グラフアドレステーブル
;	    VIEW_STOP      : 表示停止スイッチ=1
; ****************************************************

CHK_GRP_2DSP	PROC	NEAR
	MOV	SI,0				; word pointer.
	MOV	CX,5
CHK_GRP_2DSP_LOOP:
	MOV	AX,DS:STG_TABLE[SI]		; 変動グラフテーブル
	CMP	AX,OFFF				;
	JE	CHK_GRP_2DSP_EXIT		;

	MOV	BX,DS:STG_AD_TABLE[SI]		; 変動グラフアドレステーブル
	MOV	DX,DS:[BX][GRP_VALUE]		; 表示値
	MOV	BX,VIEW_STOP			; 表示停止スイッチ=1
	CALL	HOOK_WIDHBR			; グラフ表示フック

	INC	SI				;
	INC	SI				; word pointer.
	LOOP	CHK_GRP_2DSP_LOOP
CHK_GRP_2DSP_EXIT:
	RET
CHK_GRP_2DSP	ENDP



; ****************************************************
;	休息最高予算
;	-I- SI : グラフテーブルアドレス
;	    AX : 日数
;	-O- AX : お金
;	    DX : 疲労ポイント
; ****************************************************

CALC_KYUYOSAN	PROC	NEAR
	CMP	AX,0			; 日数
	JG	CALC_KYUYOSAN_START	;
	MOV	AX,0			;
	RET

CALC_KYUYOSAN_START:
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	NISSU,AX		; 日数

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	MOV	AX,G_HIROU[GRP_VALUE]	; 5. 疲労
	MOV	DX,G_HIROU[GRP_VALUE]	; 5. 疲労

	RET
CALC_KYUYOSAN	ENDP



; ****************************************************
;	休息パラメータ計算
;	-I- SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    AX : 使用するお金
;	-O- AX : 0=休息しました,2=お金が足りません,1=全快しました
; ****************************************************

CALC_KYU_PAR	PROC	NEAR
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	VAL_GOLD,AX		; お金

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

	CMPX	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金
	JNB	CALC_KYU_PAR_OK			;
	JMP	CALC_KYU_PAR_NON		;

CALC_KYU_PAR_OK:
	SUBZ	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金

	SUBZ	G_HIROU[GRP_VALUE],VAL_GOLD	; 5. 疲労
	SUBZ	G_HIROU[GRP_VALMAX],VAL_GOLD	; 5. 疲労

	MOVX	NUM,VAL_GOLD			; 7. モラル
	SHR	NUM,1				; / 2
	SUBZ	G_MORAL[GRP_VALUE],NUM		; 7. モラル
	SUBZ	G_MORAL[GRP_VALMAX],NUM		; 7. モラル

	MOVX	STG_WRTF1,5			; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_HIROU	; 5. 疲労
	MOVX	STG_WRTF2,7			; 変動グラフ２
	MOV 	STG_AD_WRTF2,OFFSET G_MORAL	; 7. モラル
	MOV	STG_WRTF3,OFFF			; 変動グラフ３(OFF)
CALC_KYU_PAR_SET:
	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	CALL	CHK_GRP_DISP		; グラフ表示

	CMP	G_HIROU[GRP_VALUE],0	; 5. 疲労
	JE	CALC_KYU_PAR_ZEN	; 全快？

	MOV	AX,0			; 0=休息しました
	RET
CALC_KYU_PAR_ZEN:
	MOV	AX,1			; 1=全快しました
	RET
CALC_KYU_PAR_NON:
	MOV	AX,2			; 2=お金が足りません
	RET
CALC_KYU_PAR	ENDP


; ****************************************************
;	学問成功率計算
;	-I- SI : グラフテーブルアドレス
;	-O- AX : 成功率
; ****************************************************

CALC_GAKUMON	PROC	NEAR
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	; 成功率＝１００÷（根性＋疲労度＋知力）×（根性＋知力）


	; 知力は？

	MOVX	KIND_VAL,G_TIRYOKU[GRP_VALUE] ; 2. 知力

	; ＡＸ＝根性＋疲労度＋知力

	MOV	AX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	AX,G_HIROU[GRP_VALUE]	; 5. 疲労
	ADD	AX,KIND_VAL		; 知力

	; ＢＸ＝根性＋知力

	MOV	BX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	BX,KIND_VAL		; 知力


	; 成功率＝１００÷ＡＸ×ＢＸ

	MOV	CX,AX			;
	MOV	AX,10000		;
	MOV	DX,0			;
	DIVX	CX			;

	MUL	BX			; ＡＸ×ＢＸ

	MOV	BX,100			;
	DIVX	BX			;

	RET
CALC_GAKUMON	ENDP


; ****************************************************
;	学問パラメータ計算
;	-I- BX : 誰か（アドレス）
;	    SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    DX : 上昇する知力
;	    CX : 上昇する疲労
;	    AX : 使用するお金
;	-O- AX : 0=学問しました,2=お金が足りません
; ****************************************************

CALC_GAK_PAR	PROC	NEAR
	MOV	ADRS_HOW,BX		; 誰か（アドレス）
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	VAL_GOLD,AX		; お金
	MOV	KIND_VAL,DX		; 上昇する知力
	MOV	PAR_HIROU,CX		; 上昇する疲労

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

	CMPX	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金
	JNB	CALC_GAK_PAR_OK			;
	JMP	CALC_GAK_PAR_NON		;

CALC_GAK_PAR_OK:
	SUBZ	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金

	ADDX	G_TIRYOKU[GRP_VALUE],KIND_VAL	; 2. 知力
	ADDX	G_TIRYOKU[GRP_VALMAX],KIND_VAL	; 2. 知力

	ADDX	G_HIROU[GRP_VALUE],PAR_HIROU	; 5. 疲労
	ADDX	G_HIROU[GRP_VALMAX],KIND_VAL	; 5. 疲労

	MOV	PAR_HIROU,CX			; 上昇する疲労

	MOVX	STG_WRTF1,2			; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_TIRYOKU	; 2. 知力
	MOVX	STG_WRTF2,5			; 変動グラフ２
	MOV 	STG_AD_WRTF2,OFFSET G_HIROU	; 5. 疲労
	MOVX	STG_WRTF3,OFFF			; 変動グラフ３
CALC_GAK_PAR_SET:
	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	MOV	AX,ADRS_HOW		; 誰か（アドレス）
	MOV	DX,0			; 復活するポイント
	CALL	CALC_MP_FUKKATU		; ＭＰセット

	CALL	CHK_GRP_DISP		; グラフ表示

	MOV	AX,0			; 0=学問しました
	RET
CALC_GAK_PAR_NON:
	MOV	AX,2			; 2=お金が足りません
	RET
CALC_GAK_PAR	ENDP


; ****************************************************
;	支払い
;	-I- DI : 内容表示テーブルアドレス
;	    AX : 使用するお金
;	-O- AX : 0=支払いしました,2=お金が足りません
; ****************************************************

CALC_PAY	PROC	NEAR
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	VAL_GOLD,AX		; お金

	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

	CMPX	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金
	JNB	CALC_PAY_OK			;
	JMP	CALC_PAY_NON			;

CALC_PAY_OK:
	SUBZ	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金

	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	MOV	AX,0			; 0=支払いしました
	RET
CALC_PAY_NON:
	MOV	AX,2			; 2=お金が足りません
	RET
CALC_PAY	ENDP



; ****************************************************
;	礼法成功率計算
;	-I- SI : グラフテーブルアドレス
;	-O- AX : 成功率
; ****************************************************

CALC_REIHOU	PROC	NEAR
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	; 成功率＝１００÷（根性＋疲労度＋気品）×（根性＋気品）


	; 気品は？

	MOVX	KIND_VAL,G_KIHIN[GRP_VALUE] ; 3. 気品

	; ＡＸ＝根性＋疲労度＋気品

	MOV	AX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	AX,G_HIROU[GRP_VALUE]	; 5. 疲労
	ADD	AX,KIND_VAL		; 気品

	; ＢＸ＝根性＋気品

	MOV	BX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	BX,KIND_VAL		; 気品


	; 成功率＝１００÷ＡＸ×ＢＸ

	MOV	CX,AX			;
	MOV	AX,10000		;
	MOV	DX,0			;
	DIVX	CX			;

	MUL	BX			; ＡＸ×ＢＸ

	MOV	BX,100			;
	DIVX	BX			;

	RET
CALC_REIHOU	ENDP



; ****************************************************
;	礼法パラメータ計算
;	-I- SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    DX : 上昇する気品
;	    CX : 上昇する疲労
;	    AX : 使用するお金
;	-O- AX : 0=礼法しました,2=お金が足りません
; ****************************************************

CALC_REI_PAR	PROC	NEAR
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	VAL_GOLD,AX		; お金
	MOV	KIND_VAL,DX		; 上昇する気品
	MOV	PAR_HIROU,CX		; 上昇する疲労

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

	CMPX	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金
	JNB	CALC_REI_PAR_OK			;
	JMP	CALC_REI_PAR_NON		;

CALC_REI_PAR_OK:
	SUBZ	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金

	ADDX	G_KIHIN[GRP_VALUE],KIND_VAL	; 3. 気品
	ADDX	G_KIHIN[GRP_VALMAX],KIND_VAL	; 3. 気品

	ADDX	G_HIROU[GRP_VALUE],PAR_HIROU	; 5. 疲労
	ADDX	G_HIROU[GRP_VALMAX],KIND_VAL	; 5. 疲労

	MOVX	STG_WRTF1,3			; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_KIHIN	; 3. 気品
	MOVX	STG_WRTF2,5			; 変動グラフ２
	MOV 	STG_AD_WRTF2,OFFSET G_HIROU	; 5. 疲労
	MOVX	STG_WRTF3,OFFF			; 変動グラフ３
CALC_REI_PAR_SET:
	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	CALL	CHK_GRP_DISP		; グラフ表示

	MOV	AX,0			; 0=礼法しました
	RET
CALC_REI_PAR_NON:
	MOV	AX,2			; 2=お金が足りません
	RET
CALC_REI_PAR	ENDP



; ****************************************************
;	武芸成功率計算
;	-I- SI : グラフテーブルアドレス
;	-O- AX : 成功率
; ****************************************************

CALC_BUGEI	PROC	NEAR
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	; 成功率＝１００÷（根性＋疲労度＋体力）×（根性＋体力）


	; 体力は？

	MOVX	KIND_VAL,G_TAIRYOK[GRP_VALUE] ; 0. 体力

	; ＡＸ＝根性＋疲労度＋体力

	MOV	AX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	AX,G_HIROU[GRP_VALUE]	; 5. 疲労
	ADD	AX,KIND_VAL		; 体力

	; ＢＸ＝根性＋体力

	MOV	BX,G_KONJYO[GRP_VALUE]	; 4. 根性
	ADD	BX,KIND_VAL		; 体力


	; 成功率＝１００÷ＡＸ×ＢＸ

	MOV	CX,AX			;
	MOV	AX,10000		;
	MOV	DX,0			;
	DIVX	CX			;

	MUL	BX			; ＡＸ×ＢＸ

	MOV	BX,100			;
	DIVX	BX			;

	RET
CALC_BUGEI	ENDP



; ****************************************************
;	武芸パラメータ計算
;	-I- BX : 誰か（アドレス）
;	    SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    DX : 上昇する経験値
;	    CX : 上昇する疲労
;	    AX : 使用するお金
;	-O- AX : 0=礼法しました,2=お金が足りません
; ****************************************************

CALC_BUG_PAR	PROC	NEAR
	MOV	ADRS_HOW,BX		; 誰か（アドレス）
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	VAL_GOLD,AX		; お金
	MOV	KIND_VAL,DX		; 上昇する経験値
	MOV	PAR_HIROU,CX		; 上昇する疲労

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

	CMPX	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金
	JNB	CALC_BUG_PAR_OK			;
	JMP	CALC_BUG_PAR_NON		;

CALC_BUG_PAR_OK:
	SUBZ	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金

	ADDX	G_KEIKEN[GRP_VALUE],KIND_VAL	; 9. 経験値
	ADDX	G_KEIKEN[GRP_VALMAX],KIND_VAL	; 9. 経験値

	ADDX	G_HIROU[GRP_VALUE],PAR_HIROU	; 5. 疲労
	ADDX	G_HIROU[GRP_VALMAX],KIND_VAL	; 5. 疲労

	MOVX	STG_WRTF1,9			; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_KEIKEN	; 9. 経験値
	MOVX	STG_WRTF2,5			; 変動グラフ２
	MOV 	STG_AD_WRTF2,OFFSET G_HIROU	; 5. 疲労
	MOVX	STG_WRTF3,OFFF			; 変動グラフ３
CALC_BUG_PAR_SET:
	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	MOV	AX,ADRS_HOW		; 誰か（アドレス）
	MOV	DX,0			; 復活するポイント
	CALL	CALC_HP_FUKKATU		; ＨＰセット

	CALL	CHK_GRP_DISP		; グラフ表示

	MOV	AX,0			; 0=礼法しました
	RET
CALC_BUG_PAR_NON:
	MOV	AX,2			; 2=お金が足りません
	RET
CALC_BUG_PAR	ENDP


; ****************************************************
;	道具使用
;	-I- AX : 誰か（アドレス）
;	    SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    DX : アイテム（道具）アドレス
; ****************************************************

CALC_DOUGU	PROC	NEAR
	MOV	ADRS_HOW,AX		; 誰か（アドレス）
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	ADRS_ITEM,DX		; アイテムアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ
;*;	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
;*;	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ
	MOV	BX,ADRS_ITEM		; アイテムアドレス
	CALL	LOAD_ITEM		; アイテムパラメータＬＯＡＤ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	MOV	STG_WRTF1,OFFF		; 変動グラフ１
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	MOV	DX,I_KKA1		; 効果１
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JMPEQ	CALC_DOUGU_SET		;

	ADDS	DS:[BX][GRP_VALUE] ,I_VAL1 ; 加減値
	ADDS	DS:[BX][GRP_VALMAX],I_VAL1 ; 加減値
	MOVX	STG_WRTF1,RECNO		; 変動グラフ１
	MOV 	STG_AD_WRTF1,BX		; 変動グラフ１


	MOV	DX,I_KKA2		; 効果２
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JMPEQ	CALC_DOUGU_SET		;

	ADDS	DS:[BX][GRP_VALUE] ,I_VAL2 ; 加減値
	ADDS	DS:[BX][GRP_VALMAX],I_VAL2 ; 加減値
	MOVX	STG_WRTF2,RECNO		; 変動グラフ２
	MOV 	STG_AD_WRTF2,BX		; 変動グラフ２


	MOV	DX,I_KKA3		; 効果３
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JE	CALC_DOUGU_SET		;

	ADDS	DS:[BX][GRP_VALUE] ,I_VAL3 ; 加減値
	ADDS	DS:[BX][GRP_VALMAX],I_VAL3 ; 加減値
	MOVX	STG_WRTF3,RECNO		; 変動グラフ３
	MOV 	STG_AD_WRTF3,BX		; 変動グラフ３

CALC_DOUGU_SET:
	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
;*;	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
;*;	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	MOV	AX,ADRS_HOW		; 誰か（アドレス）
	MOV	DX,0			; 復活するポイント
	CALL	CALC_HP_FUKKATU		; ＨＰセット

	MOV	AX,ADRS_HOW		; 誰か（アドレス）
	MOV	DX,0			; 復活するポイント
	CALL	CALC_MP_FUKKATU		; ＭＰセット

	CALL	CHK_GRP_DISP		; グラフ表示

	RET
CALC_DOUGU	ENDP


; ****************************************************
;	道具はずす
;	-I- SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    DX : アイテム（道具）アドレス
; ****************************************************

CALC_DOUGU_H	PROC	NEAR
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	ADRS_ITEM,DX		; アイテムアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ
;*;	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
;*;	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ
	MOV	BX,ADRS_ITEM		; アイテムアドレス
	CALL	LOAD_ITEM		; アイテムパラメータＬＯＡＤ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	MOV	STG_WRTF1,OFFF		; 変動グラフ１
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	MOV	DX,I_KKA1		; 効果１
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JMPEQ	CALC_DOUGU_H_SET	;

	SUBS	DS:[BX][GRP_VALUE] ,I_VAL1 ; 加減値
	SUBS	DS:[BX][GRP_VALMAX],I_VAL1 ; 加減値
	MOVX	STG_WRTF1,RECNO		; 変動グラフ１
	MOV 	STG_AD_WRTF1,BX		; 変動グラフ１

	MOV	DX,I_KKA2		; 効果２
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JMPEQ	CALC_DOUGU_H_SET	;

	SUBS	DS:[BX][GRP_VALUE] ,I_VAL2 ; 加減値
	SUBS	DS:[BX][GRP_VALMAX],I_VAL2 ; 加減値
	MOVX	STG_WRTF2,RECNO		; 変動グラフ２
	MOV 	STG_AD_WRTF2,BX		; 変動グラフ２


	MOV	DX,I_KKA3		; 効果３
	CALL	KIND_CHK_GRP		; グラフパラメータからグラフ名前検索
	CMP	AX,1			; 1=該当なし
	JE	CALC_DOUGU_H_SET	;

	SUBS	DS:[BX][GRP_VALUE] ,I_VAL3 ; 加減値
	SUBS	DS:[BX][GRP_VALMAX],I_VAL3 ; 加減値
	MOVX	STG_WRTF3,RECNO		; 変動グラフ３
	MOV 	STG_AD_WRTF3,BX		; 変動グラフ３

CALC_DOUGU_H_SET:
	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
;*;	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
;*;	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	CALL	CHK_GRP_DISP		; グラフ表示

	RET
CALC_DOUGU_H	ENDP



; ****************************************************
;	ヘッダー整合
;	-I- AX : 誰か（アドレス）
; ****************************************************

CALC_HEAD_GO	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; グラフテーブルの体力

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフセット

	MOV	DI,GTB_TAIRYOK+GRP_VALUE ; 0. 体力の数値アドレス
	MOV	DX,ES:[BX][DI]		; DX=体力（＝ＨＰ）

	; ＨＰ

	MOV	BX,ADRS_HOW		; 人物
	MOV	ES:[BX][HED_HP],DX	; ＨＰ=DX

	RET
CALC_HEAD_GO	ENDP


; ****************************************************
;	装備・つける
;	-I- AX : 誰か（アドレス）
;	    BX : 装備種別 0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾
;	    CX : アイテムレコードＮＯ
;	    DX : アイテムアドレス
;	    SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	-O- AX : 0=正常,1=装備を外せ
; ****************************************************

CALC_S_CHAKU	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	SOUBI_ATR,BX		; 装備種別
	MOV	VAL_RECNO,CX		; レコードＮＯ
	MOV	ADRS_ITEM,DX		; アイテムアドレス
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス

	; 装備リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_LST_SB]	; BX=装備リスト

	MOV	SI,SOUBI_ATR		; 装備種別
	SHL	SI,1			;
	SHL	SI,1			; * 4

	CMP	ES:[BX][SI],WORD PTR OFFF ; アイテム種別＝無し？
	JNE	CALC_S_CHAKU_ERROR	;

	MOVX	ES:[BX][SI],SOUBI_ATR	; 装備種別
	MOVX	ES:[BX][SI][2],VAL_RECNO; レコードＮＯ

	MOV	AX,ADRS_HOW		; 誰か（アドレス）
	MOV	DX,ADRS_ITEM		; アイテムアドレス
	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	DI,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	CALC_DOUGU		; 道具使用

	MOV	AX,0			; 0=正常
	RET
CALC_S_CHAKU_ERROR:
	MOV	AX,1			; 1=装備を外せ
	RET
CALC_S_CHAKU	ENDP



; ****************************************************
;	装備・はずす
;	-I- AX : 誰か（アドレス）
;	    BX : 装備種別 0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾
;	    CX : アイテムテーブルアドレス
;	    DX : 表示停止スイッチ 0=OFF 1=ON
;	    SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	-O- AX : 0=正常,1=装備していない
; ****************************************************

CALC_S_DATSU	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	SOUBI_ATR,BX		; 装備
	MOV	ADRS_ITEM,CX		; アイテムテーブルアドレス
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	VIEW_STOP,DX		; 表示停止スイッチ=1


	; 装備リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_LST_SB]	; BX=装備リスト

	MOV	SI,SOUBI_ATR		; 装備
	SHL	SI,1			;
	SHL	SI,1			; * 4

	MOV	DX,ES:[BX][SI]		; アイテム種別
	MOV	AX,ES:[BX][SI][2]	; レコード番号
	CMP	DX,OFFF			; 無し
	JE	CALC_S_DATSU_ERROR	;

	MOV	ES:[BX][SI],OFFF	; 装備種別
	MOV	ES:[BX][SI][2],OFFF	; レコードＮＯ

	MOV	BX,DX			; アイテム種別
	CALL	ITEM_ADRS_CLC		; アイテムアドレス
					; DX=アイテムアドレス
	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	DI,ADRS_VALUE		; 内容表示テーブルアドレス

	CALL	CALC_DOUGU_H		; 道具はずす

	MOV	VIEW_STOP,0		; 表示停止スイッチ=1
	MOV	AX,0			; 0=正常
	RET
CALC_S_DATSU_ERROR:
	MOV	VIEW_STOP,0		; 表示停止スイッチ=1
	MOV	AX,1			; 1=装備していない
	RET
CALC_S_DATSU	ENDP


; ****************************************************
;	先手計算
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : 私の先手確率
; ****************************************************

CALC_SENTE	PROC	NEAR
	CALL	TEKIMIKATA_GET		; 敵味方ＧＥＴ

	; 先手を取れる確率
	; ＝１００÷（自分の素早さ＋敵の素早さ）×自分の素早さ

	MOV	BX,G_SUBAYA[GRP_VALUE]	;11. 素早さ 自分
	ADD	BX,GS_SUBAYA[GRP_VALUE]	;11. 素早さ 敵
	MOV	DX,0			;
	MOV	AX,100			;
	FLOAT_IN	AX		;
	DIVX	BX			; AX=100/BX

	MOV	BX,G_SUBAYA[GRP_VALUE]	;11. 素早さ 自分
	MUL	BX			;
	FLOAT_OUT	AX		;

;*;	PRV	"先手=",AX

	RET
CALC_SENTE	ENDP


; ****************************************************
;	敵味方ＧＥＴ
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- ADRS_HOW    : 人物 (=AX)
;	    ADRS_TK_HOW : 敵   (=BX)
;	    ADRS_GRAPH  : グラフテーブルアドレス
;	    ADRS_VALUE  : 内容表示テーブルアドレス
;	    ADRS_TK_GRP : 敵・グラフテーブルアドレス
;	    ADRS_TK_VAL : 敵・内容表示テーブルアドレス
; ****************************************************

TEKIMIKATA_GET	PROC	NEAR

	MOV	ADRS_HOW,AX		; 人物
	MOV	ADRS_TK_HOW,BX		; 敵

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス

	MOV	BX,ADRS_TK_HOW		; 敵
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_TK_GRP,SI		; 敵・グラフテーブルアドレス
	MOV	ADRS_TK_VAL,DI		; 敵・内容表示テーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	MOV	BX,ADRS_TK_GRP		; 敵・グラフテーブルアドレス
	CALL	LOAD_T_GRAPH		; 敵・グラフパラメータＬＯＡＤ

	RET
TEKIMIKATA_GET	ENDP


; ****************************************************
;	命中率計算
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : 命中率
;	    BX : 敵命中率
; ****************************************************

CALC_HIT	PROC	NEAR
	CALL	TEKIMIKATA_GET		; 敵味方ＧＥＴ

	; 命中率
	; ＝１００÷（自分の戦闘技術＋敵の戦闘技術）×自分の戦闘技術＋４０％

	; 敵の命中率
	; ＝１００÷（自分の戦闘技術＋敵の戦闘技術）×敵の戦闘技術＋４０％

	MOV	BX,G_SENTOH[GRP_VALUE]	;10. 戦闘技術 自分
	ADD	BX,GS_SENTOH[GRP_VALUE]	;10. 戦闘技術 敵
	MOV	DX,0			;
	MOV	AX,100			;
	FLOAT_IN	AX		;
	DIVX	BX			; AX=100/BX
	MOV	CX,AX			;

	MOV	BX,G_SENTOH[GRP_VALUE]	;10. 戦闘技術 自分
	MUL	BX			;
	FLOAT_OUT	AX		;
	ADD	AX,40			; +40%

	PUSH	AX

	MOV	AX,CX			;
	MOV	BX,GS_SENTOH[GRP_VALUE]	;10. 戦闘技術 敵
	MUL	BX			;
	FLOAT_OUT	AX		;
	ADD	AX,40			; +40%
	MOV	BX,AX

	POP	AX
;*;CODE_IN
;*;	LC	0,10
;*;	PRV	"命中率=",AX
;*;	PRV	"敵命中率=",BX
;*;CODE_OUT
	RET
CALC_HIT	ENDP


; ****************************************************
;	ダメージ計算
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : 私のダメージ
;	    BX : 敵のダメージ
;	    CX : 私の魔法ダメージ
;	    DX : 敵の魔法ダメージ
;	    SI : 私の痛恨ダメージ
;	    DI : 敵の会心ダメージ
; ****************************************************

CALC_DAMEGE	PROC	NEAR
	CALL	TEKIMIKATA_GET			; 敵味方ＧＥＴ

	MOV	BX,ADRS_HOW		; 人物
	CALL	LOAD_HED_PAR		; ヘッダーパラメータＬＯＡＤ

	MOV	BX,ADRS_TK_HOW		; 敵
	CALL	LOAD_T_HED_PAR		; 敵・ヘッダーパラメータＬＯＡＤ

	; 私のダメージ＝敵の攻撃力－私の装甲強度

	MOV	BX,GS_WANRYOK[GRP_VALUE]	; 1. 腕力	敵
	ADD	BX,GS_KOUGEK[GRP_VALUE]		;13. 攻撃増強	敵
	SUBZ	BX,G_SOKOH[GRP_VALUE]		;12. 装甲強度	自分
	MOV	DMG_MY,BX			; 私のダメージ

	; 敵のダメージ＝私の攻撃力－敵の装甲強度

	MOV	BX,G_WANRYOK[GRP_VALUE]		; 1. 腕力	自分
	ADD	BX,G_KOUGEK[GRP_VALUE]		;13. 攻撃増強	自分
	SUBZ	BX,GS_SOKOH[GRP_VALUE]		;12. 装甲強度	敵
	MOV	DMG_TK,BX			; 敵のダメージ

	; 私の魔法ダメージ＝敵の知力÷２－私の装甲強度

	MOV	BX,GS_TIRYOKU[GRP_VALUE]	; 2. 知力	敵
	SHR	BX,1				;
	SUBZ	BX,G_SOKOH[GRP_VALUE]		;12. 装甲強度	自分
	MOV	DMG_MY_MP,BX			; 私の魔法ダメージ

	; 敵の魔法ダメージ＝私の知力÷２－敵の装甲強度

	MOV	BX,G_TIRYOKU[GRP_VALUE]		; 2. 知力	自分
	SHR	BX,1				;
	SUBZ	BX,GS_SOKOH[GRP_VALUE]		;12. 装甲強度	敵
	MOV	DMG_TK_MP,BX			; 敵の魔法ダメージ

	; ダメージ拡散

	CALL	DAMEG_KAKUSAN			; ダメージ拡散

	; 私の痛恨ダメージ＝敵の攻撃力×２

	MOV	SI,GS_WANRYOK[GRP_VALUE]	; 1. 腕力	敵
	ADD	SI,GS_KOUGEK[GRP_VALUE]		;13. 攻撃増強	敵
	SHL	SI,1				; 私の痛恨ダメージ

	; 敵の会心ダメージ＝私の攻撃力×２

	MOV	DI,G_WANRYOK[GRP_VALUE]		; 1. 腕力	自分
	ADD	DI,G_KOUGEK[GRP_VALUE]		;13. 攻撃増強	自分
	SHL	DI,1				; 敵の会心ダメージ

	MOV	AX,DMG_MY			; 私のダメージ
	MOV	BX,DMG_TK			; 敵のダメージ
	MOV	CX,DMG_MY_MP			; 私の魔法ダメージ
	MOV	DX,DMG_TK_MP			; 敵の魔法ダメージ

	CMP	AX,0				; 私のダメージ
	JNE	CALC_DAMEGE_81			;
	INC	AX				;
CALC_DAMEGE_81:					;

	CMP	BX,0				; 敵のダメージ
	JNE	CALC_DAMEGE_82			;
	INC	BX				;
CALC_DAMEGE_82:					;

CALC_DAMEGE_EXIT:
	RET
CALC_DAMEGE	ENDP


; ****************************************************
;	ダメージ拡散
;	-I-   ADRS_VALUE  : 内容表示テーブルアドレス
;	      ADRS_TK_VAL : 敵・内容表示テーブルアドレス
;	-I/O- DMG_MY    : 私のダメージ
;	      DMG_TK    : 敵のダメージ
;	      DMG_MY_MP : 私の魔法ダメージ
;	      DMG_TK_MP : 敵の魔法ダメージ
; ****************************************************

DAMEG_KAKUSAN	PROC	NEAR

	MOV	BX,ADRS_TK_VAL			; 敵・内容表示テーブルアドレス
	CALL	C_BLOOD_TYPE			; 血液型
	MOV	UK_BLOOD,AX			; 1=Ａ,2=Ｂ,3=ＡＢ,4=Ｏ
;*;CODE_IN
;*;	CALL	CLS
;*;	LC	0,3
;*;	PRV	"UK_BLOOD=",UK_BLOOD
;*;	PRV	"DMG_MY=",DMG_MY
;*;	PRV	"DMG_TK=",DMG_TK
;*;	PRV	"DMG_MY_MP=",DMG_MY_MP
;*;	PRV	"DMG_TK_MP=",DMG_TK_MP
;*;CODE_OUT

	MOVX	UK_TAI,G_TAIRYOK[GRP_VALUE]	; 0. 体力	自分
	MOVX	UK_HP,G_HP[GRP_VALUE]		;14. ＨＰ	自分
	MOVX	UK_DMG,DMG_MY			; 私のダメージ
	CALL	DMG_BLOOD			; 血液型別攻撃
	MOV	DMG_MY,CX			; 私のダメージ

	MOVX	UK_TAI,G_TAIRYOK[GRP_VALUE]	; 0. 体力	自分
	MOVX	UK_HP,G_HP[GRP_VALUE]		;14. ＨＰ	自分
	MOVX	UK_DMG,DMG_MY_MP		; 私の魔法ダメージ
	CALL	DMG_BLOOD			; 血液型別攻撃
	MOV	DMG_MY_MP,CX			; 私の魔法ダメージ


	MOV	BX,ADRS_VALUE			; 内容表示テーブルアドレス
	CALL	C_BLOOD_TYPE			; 血液型
	MOV	UK_BLOOD,AX			; 1=Ａ,2=Ｂ,3=ＡＢ,4=Ｏ

	MOVX	UK_TAI,GS_TAIRYOK[GRP_VALUE]	; 0. 体力	敵
	MOVX	UK_HP,GS_HP[GRP_VALUE]		;14. ＨＰ	敵
	MOVX	UK_DMG,DMG_TK			; 敵のダメージ
	CALL	DMG_BLOOD			; 血液型別攻撃
	MOV	DMG_TK,CX			; 敵のダメージ

	MOVX	UK_TAI,GS_TAIRYOK[GRP_VALUE]	; 0. 体力	敵
	MOVX	UK_HP,GS_HP[GRP_VALUE]		;14. ＨＰ	敵
	MOVX	UK_DMG,DMG_TK_MP		; 敵の魔法ダメージ
	CALL	DMG_BLOOD			; 血液型別攻撃
	MOV	DMG_TK_MP,CX			; 敵の魔法ダメージ

;*;CODE_IN
;*;	PRV	"UK_BLOOD=",UK_BLOOD
;*;	PRV	"DMG_MY=",DMG_MY
;*;	PRV	"DMG_TK=",DMG_TK
;*;	PRV	"DMG_MY_MP=",DMG_MY_MP
;*;	PRV	"DMG_TK_MP=",DMG_TK_MP
;*;CODE_OUT

DAMEG_KAKUSAN_EXIT:
	RET
DAMEG_KAKUSAN	ENDP


; ****************************************************
;	血液型
;	-I- BX : 内容表示テーブルアドレス
;	-O- AX : 1=Ａ,2=Ｂ,3=ＡＢ,4=Ｏ
; ****************************************************

C_BLOOD_TYPE	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,ES:[BX][VTB_KETUEKI][VAL_VALUE]	; 2. 血液型
	WD_CMP	ID_104,DX		; Ａ型
	JE	C_BLOOD_TYPE_E1		;
	WD_CMP	ID_106,DX		; Ｂ型
	JE	C_BLOOD_TYPE_E2		;
	WD_CMP	ID_105,DX		; ＡＢ型
	JE	C_BLOOD_TYPE_E3		;
	WD_CMP	ID_107,DX		; Ｏ型
	JE	C_BLOOD_TYPE_E4		;

C_BLOOD_TYPE_E1:
	MOV	AX,1			; 1=Ａ
	RET
C_BLOOD_TYPE_E2:
	MOV	AX,2			; 2=Ｂ
	RET
C_BLOOD_TYPE_E3:
	MOV	AX,3			; 3=ＡＢ
	RET
C_BLOOD_TYPE_E4:
	MOV	AX,4			; 4=Ｏ
	RET
C_BLOOD_TYPE	ENDP


; ****************************************************
;	血液型別攻撃
;	-I-   UK_BLOOD : 攻撃側 1=Ａ,2=Ｂ,3=ＡＢ,4=Ｏ
;	      UK_DMG : 受け側　ダメージ
;	      UK_TAI : 受け側　体力
;	      UK_HP  : 受け側　ＨＰ
;	-O-   CX     : ダメージ
; ****************************************************

DMG_BLOOD	PROC	NEAR
	CMP	UK_BLOOD,1			; 攻撃側 1=Ａ
	JE	DMG_BLOOD_TYPE_A		;
	CMP	UK_BLOOD,2			; 攻撃側 2=Ｂ
	JE	DMG_BLOOD_TYPE_B		;
	CMP	UK_BLOOD,3			; 攻撃側 3=ＡＢ
	JE	DMG_BLOOD_TYPE_AB		;
	CMP	UK_BLOOD,4			; 攻撃側 4=Ｏ
	JE	DMG_BLOOD_TYPE_O		;
DMG_BLOOD_TYPE_A:
	CALL	TYPE_A_GEKI			; Ａ型・攻撃
	JMP	DMG_BLOOD_EXIT			;
DMG_BLOOD_TYPE_B:
	CALL	TYPE_B_GEKI			; Ｂ型・攻撃
	JMP	DMG_BLOOD_EXIT			;
DMG_BLOOD_TYPE_AB:
	CALL	TYPE_AB_GEKI			; ＡＢ型・攻撃
	JMP	DMG_BLOOD_EXIT			;
DMG_BLOOD_TYPE_O:
	CALL	TYPE_O_GEKI			; Ｏ型・攻撃
	JMP	DMG_BLOOD_EXIT			;
DMG_BLOOD_EXIT:
	RET
DMG_BLOOD	ENDP


; ****************************************************
;	Ａ型・攻撃
;	下降型ダメージ
;	-I-   UK_DMG : 受け側　ダメージ
;	      UK_TAI : 受け側　体力
;	      UK_HP  : 受け側　ＨＰ
;	-O-   CX     : ダメージ
; ****************************************************

TYPE_A_GEKI	PROC	NEAR
	MOV	AX,UK_HP			; 受け側　ＨＰ
	MOV	DX,0				;
	MOV	BX,5				; AX = AX / 5
	DIV	BX				;
	MOV	DX,AX				; DX=体力 / 5

	MOV	CX,DX				; 体力 / 5  を乱数化
	CALL	SENTO_GEKI_RND			; 戦闘型乱数

	MOV	DX,UK_TAI			; 受け側　体力
	SHR	DX,1				;
	SHR	DX,1				; 体力 / 4
	ADD	DX,AX				; + rnd

	MOV	CX,UK_DMG			; CX=受け側　ダメージ

	CMP	CX,DX				; if CX > DX then
	JBE	TYPE_A_GEKI_2			;
	MOV	CX,DX				;    CX = DX
TYPE_A_GEKI_2:					; endif
	RET
TYPE_A_GEKI	ENDP


; ****************************************************
;	Ｂ型・攻撃
;	戦闘乱数＋相性乱数
;	-I-   UK_DMG : 受け側　ダメージ
;	      UK_TAI : 受け側　体力
;	      UK_HP  : 受け側　ＨＰ
;	-O-   CX     : ダメージ
; ****************************************************

TYPE_B_GEKI	PROC	NEAR
	MOV	AX,UK_TAI			; DX=受け側　体力
	MOV	DX,0				;
	MOV	BX,4				; AX = AX / 4
	DIV	BX				;
	MOV	DX,AX				; DX=体力 / 4

	MOV	CX,DX				; 体力 / 4  を乱数化
	CALL	SENTO_GEKI_RND			; 戦闘型乱数
	MOV	DX,AX				;
	CALL	AISYO_GEKI_RND			; 相性別乱数を加える
	ADD	DX,AX				;

	MOV	CX,UK_DMG			; CX=受け側　ダメージ

	CMP	CX,DX				; if CX > DX then
	JBE	TYPE_B_GEKI_2			;
	MOV	CX,DX				;    CX = DX
TYPE_B_GEKI_2:					; endif
	RET
TYPE_B_GEKI	ENDP


; ****************************************************
;	ＡＢ型・攻撃
;	下降型ダメージ＋戦闘乱数＋相性乱数
;	-I-   UK_DMG : 受け側　ダメージ
;	      UK_TAI : 受け側　体力
;	      UK_HP  : 受け側　ＨＰ
;	-O-   CX     : ダメージ
; ****************************************************

TYPE_AB_GEKI	PROC	NEAR
	MOV	AX,UK_HP			; DX=受け側　ＨＰ
	MOV	DX,0				;
	MOV	BX,4				; AX = AX / 4
	DIV	BX				;
	MOV	DX,AX				; DX=体力 / 4

	CMP	UK_HP,40			; DX=受け側　ＨＰ
	JNB	TYPE_AB_GEKI_1			;
	MOV	AX,UK_TAI			; 受け側　体力
	MOV	DX,0				;
	MOV	BX,4				; AX = AX / 4
	DIV	BX				;
	MOV	DX,AX				; DX=体力 / 4
TYPE_AB_GEKI_1:					;

	MOV	CX,DX				; 体力 / 4  を乱数化
	CALL	SENTO_GEKI_RND			; 戦闘型乱数
	ADD	DX,AX				; 体力 / 4 ＋ 乱数化
	CALL	AISYO_GEKI_RND			; 相性別乱数を加える
	ADD	DX,AX				;

	MOV	CX,UK_DMG			; CX=受け側　ダメージ

	CMP	CX,DX				; if CX > DX then
	JBE	TYPE_AB_GEKI_2			;
	MOV	CX,DX				;    CX = DX
TYPE_AB_GEKI_2:					; endif
	RET
TYPE_AB_GEKI	ENDP


; ****************************************************
;	Ｏ型・攻撃
;	下降型ダメージ＋相性乱数
;	-I-   UK_DMG : 受け側　ダメージ
;	      UK_TAI : 受け側　体力
;	      UK_HP  : 受け側　ＨＰ
;	-O-   CX     : ダメージ
; ****************************************************

TYPE_O_GEKI	PROC	NEAR
	MOV	AX,UK_TAI			; AX=受け側　体力
	MOV	DX,0				;
	MOV	BX,4				; AX = AX / 4
	DIV	BX				;
	MOV	DX,AX				; DX=体力 / 4

	MOV	CX,DX				; 体力 / 4  を乱数化
	CALL	AISYO_GEKI_RND			; 相性別乱数
	ADD	DX,AX				;

	MOV	CX,UK_DMG			; CX=受け側　ダメージ

	CMP	CX,DX				; if CX > DX then
	JBE	TYPE_O_GEKI_2			;
	MOV	CX,DX				;    CX = DX
TYPE_O_GEKI_2:					; endif
	RET
TYPE_O_GEKI	ENDP


; ****************************************************
;	戦闘型乱数
;	-I- CX : 加減
;	-O- AX : 乱数
; ****************************************************

SENTO_GEKI_RND	PROC	NEAR
	PUSH	CX
	PUSH	DX
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	POP	DX
	POP	CX
	RET
SENTO_GEKI_RND	ENDP


; ****************************************************
;	相性別乱数
;	-O- AX : 乱数
; ****************************************************

AISYO_GEKI_RND	PROC	NEAR
	PUSH	CX
	PUSH	DX
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	POP	DX
	POP	CX
	RET
AISYO_GEKI_RND	ENDP



; ****************************************************
;	会心確率
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : 私の会心確率
;	    BX : 敵の痛恨確率
; ****************************************************

CALC_KAISIN	PROC	NEAR
	MOV	AX,3			; 私の会心確率＝３％
	MOV	BX,3			; 敵の痛恨確率＝３％
;;	MOV	AX,20			; 私の会心確率＝２０％
;;	MOV	BX,10			; 敵の痛恨確率＝１０％
	RET
CALC_KAISIN	ENDP


; ****************************************************
;	逃げる成功率計算
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : 逃げる成功率
; ****************************************************

CALC_NIGERU	PROC	NEAR
	CALL	TEKIMIKATA_GET		; 敵味方ＧＥＴ

	MOV	BX,ADRS_HOW		; 人物
	CALL	LOAD_HED_PAR		; ヘッダーパラメータＬＯＡＤ

	MOV	BX,ADRS_TK_HOW		; 敵
	CALL	LOAD_T_HED_PAR		; 敵・ヘッダーパラメータＬＯＡＤ


	; 逃げる成功率計算＝１００
	; ÷（（自分の素早さ×自分のレベル）＋（敵の素早さ×敵のレベル））
	; ×（自分の素早さ×自分のレベル）


	; （自分の素早さ×自分のレベル）

	MOV	AX,G_SUBAYA[GRP_VALUE]	;11. 素早さ	自分
	MOV	BX,H_LVL		; レベル	自分
	MUL	BX			;
	MOV	P_MY,AX			; 私

	; （敵の素早さ×敵のレベル）

	MOV	AX,GS_SUBAYA[GRP_VALUE]	;11. 素早さ	敵
	MOV	BX,HS_LVL		; レベル	敵
	MUL	BX			;
	MOV	P_TK,AX			; 敵

	; １００
	; ÷（（自分の素早さ×自分のレベル）＋（敵の素早さ×敵のレベル））

	MOV	BX,P_MY			; 私
	ADD	BX,P_TK			; 敵
	MOV	DX,0			;
	MOV	AX,100			; １００
	FLOAT_IN	AX		;
	DIVX	BX			; AX=AX/BX

	; ×（自分の素早さ×自分のレベル）

	MOV	BX,P_MY			; 私
	MUL	BX			; AX=AX*BX
	FLOAT_OUT	AX		;

;*;	CODE_IN
;*;	PRV	"逃げる成功率=",AX
;*;	CODE_OUT
	RET
CALC_NIGERU	ENDP


; ****************************************************
;	勝手に逃げる確率計算
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : 私、逃げる確率
;	    BX : 敵、逃げる確率
; ****************************************************

CALC_NIGETA	PROC	NEAR
	CALL	TEKIMIKATA_GET		; 敵味方ＧＥＴ

	MOV	BX,ADRS_HOW		; 人物
	CALL	LOAD_HED_PAR		; ヘッダーパラメータＬＯＡＤ

	MOV	BX,ADRS_TK_HOW		; 敵
	CALL	LOAD_T_HED_PAR		; 敵・ヘッダーパラメータＬＯＡＤ

	; 私、逃げる確率＝１００
	; ÷（（自分のレベル×１０）＋（敵のレベル×１０）＋自分の根性）
	; ×（敵のレベル×１０）

	; 敵、逃げる確率＝１００
	; ÷（（自分のレベル×１０）＋（敵のレベル×１０）＋敵の根性）
	; ×（自分のレベル×１０）


	; （自分のレベル×１０）

	MOV	AX,H_LVL		; レベル	自分
	MOV	BX,10			; １０
	MUL	BX			;
	MOV	P_MY,AX			; 私

	; （敵のレベル×１０）

	MOV	AX,HS_LVL		; レベル	敵
	MOV	BX,10			; １０
	MUL	BX			;
	MOV	P_TK,AX			; 敵

	; １００
	; ÷（（自分のレベル×１０）＋（敵のレベル×１０）＋自分の根性）

	MOV	BX,P_MY			; 私
	ADD	BX,P_TK			; 敵
	ADD	BX,DS:G_KONJYO[GRP_VALUE] ; 4. 根性	自分
	MOV	DX,0			;
	MOV	AX,100			; １００
	FLOAT_IN	AX		;
	DIVX	BX			; AX=AX/BX

	; ×（敵のレベル×１０）

	MOV	BX,P_TK			; 敵
	MUL	BX			; AX=AX*BX
	FLOAT_OUT	AX		;
	MOV	P_MY2,AX		; 私、逃げる確率

	; １００
	; ÷（（自分のレベル×１０）＋（敵のレベル×１０）＋敵の根性）

	MOV	BX,P_MY			; 私
	ADD	BX,P_TK			; 敵
	ADD	BX,DS:GS_KONJYO[GRP_VALUE] ; 4. 根性	敵
	MOV	DX,0			;
	MOV	AX,100			; １００
	FLOAT_IN	AX		;
	DIVX	BX			; AX=AX/BX

	; ×（自分のレベル×１０）

	MOV	BX,P_MY			; 私
	MUL	BX			; AX=AX*BX
	FLOAT_OUT	AX		;
	MOV	P_TK2,AX		; 敵、逃げる確率


	MOV	AX,P_MY2		; 私、逃げる確率
	MOV	BX,P_TK2		; 敵、逃げる確率、更に１／４
	SHR	BX,1			;
	SHR	BX,1			;

;*;CODE_IN
;*;	PRV	"AX=",AX
;*;	PRV	"BX=",BX
;*;CODE_OUT

	RET
CALC_NIGETA	ENDP


; ****************************************************
;	ダメージ判定
;	-I- AX : 誰か（アドレス）
;	    DX : ダメージ
;	-O- DX : 0=大丈夫,1=死にました
;	    AX : ＨＰ
; ****************************************************

CALC_DAM_CHK	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	DMG_MY,DX		; ダメージ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス

;*;	SUBZ	ES:[BX][GTB_TAIRYOK][GRP_VALUE],DMG_MY		; 0. 体力
;*;	MOVX	G_TAIRYOK[GRP_VALUE],ES:[BX][GTB_TAIRYOK][GRP_VALUE] ; 0. 体力

	SUBZ	ES:[BX][GTB_HP][GRP_VALUE],DMG_MY		;14. ＨＰ
	SUBZ	ES:[BX][GTB_HP][GRP_VALMAX],DMG_MY		;14. ＨＰ
	MOVX	G_HP[GRP_VALUE],ES:[BX][GTB_HP][GRP_VALUE]	;14. ＨＰ

	MOV	STG_WRTF1,14		; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_HP ; 14. ＨＰ
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	CALL	CHK_GRP_2DSP		; グラフ表示２

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
;*;	CMP	ES:[BX][GTB_TAIRYOK][GRP_VALUE],WORD PTR 0 ; 体力＝０？
	CMP	ES:[BX][GTB_HP][GRP_VALUE],WORD PTR 0	; ＨＰ＝０？
	JE	CALC_DAM_CHK_DED	;

	MOV	AX,ES:[BX][GTB_HP][GRP_VALUE] ; ＨＰ
	MOV	DX,0			; 0=大丈夫
	RET
CALC_DAM_CHK_DED:
	MOV	AX,0			; ＨＰ
	MOV	DX,1			; 1=死にました
	RET
CALC_DAM_CHK	ENDP


; ****************************************************
;	グラフ整合
;	-I- AX : 誰か（アドレス）
; ****************************************************

CALC_GRAP_GO	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; グラフテーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフセット

	;・体力とＨＰ
	;	ＨＰ＝体力値
	;	ＨＰが上昇すると体力値が上昇
	;	ＨＰが下降すると体力値が下降
	;	ＨＰは体力最大値を越えられない

	MOV	AX,ES:[BX][GTB_TAIRYOK][GRP_VALUE]	; 0. 体力
	MOV	ES:[BX][GTB_HP][GRP_VALUE],AX		;14. ＨＰ
	MOV	ES:[BX][GTB_HP][GRP_VALMAX],AX		;14. ＨＰ（最大値）

	;・知力とＭＰ
	;	ＭＰ＝知力値
	;	ＭＰが上昇すると知力値が上昇
	;	ＭＰが下降すると知力値が下降
	;	ＭＰは体力最大値を越えられない

	PUSH	ES
	PUSH	BX
	CALL	R_MAGIC_ARU		; 所有魔法ある？
	POP	BX
	POP	ES
	MOV	AX,0
	CMP	CX,0			; 技数が無しならば
	JE	CALC_GRAP_GO_NASHI	;

	MOV	AX,ES:[BX][GTB_TIRYOKU][GRP_VALUE]	; 2. 知力
CALC_GRAP_GO_NASHI:
	MOV	ES:[BX][GTB_MP][GRP_VALUE],AX		;15. ＭＰ
	MOV	ES:[BX][GTB_MP][GRP_VALMAX],AX		;15. ＭＰ（最大値）

	RET
CALC_GRAP_GO	ENDP


; ****************************************************
;	内容表示整合
;	-I- AX : 誰か（アドレス）
; ****************************************************

CALC_VAL_GO	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; 内容表示テーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	MOV	DI,ES:[BX][HED_VA_OFS]	; BX=内容表示テーブルオフセット

	; プロポーションの整合
	;
	; １００＋（１１０－（身長－体重））

	MOV	AX,ES:[DI][VTB_SINCHO][VAL_VALUE]	; 5. 身長(mm)
	MOV	BX,ES:[DI][VTB_TAIJU][VAL_VALUE]	; 6. 体重(100g)

	SUB	AX,BX				; AX=身長－体重
	MOV	DX,110*10				;
	SUB	DX,AX				; DX=１１０－ＡＸ
	ADD	DX,100*10			; DX=ＤＸ＋１００
	CMP	DX,0				;
	JGE	CALC_VAL_GO_3			; ０以下は取り消し
	MOV	DX,0				;
CALC_VAL_GO_3:					;
	MOV	AX,DX				;
	MOV	DX,0				;
	MOV	BX,10				;
	DIVX	BX				;
	MOV	ES:[DI][VTB_PROPRT][VAL_VALUE],AX ; 7. プロポー
	RET
CALC_VAL_GO	ENDP


; ****************************************************
;	レベルＵＰ
;	-I- AX : 誰か（アドレス）
;	-O- AX : 0=前と変わらず,1=レベルＵＰ
; ****************************************************

CALC_LEVEL_UP	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; グラフテーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ADRS_HOW		; 人物
	MOV	BX,ES:[SI][HED_GR_OFS]	; BX=グラフテーブルオフセット
	MOV	ADRS_GRAPH,BX		; グラフテーブルアドレス

	; 経験値

	MOVX	KEIKEN,ES:[BX][GTB_KEIKEN][GRP_VALUE] ; 経験値

	MOV	LEV,0			; レベル
	MOV	DI,0			; DI=前のレベルぶんの経験値
CALC_LEVEL_UP_LOOP:
	INC	LEV			; レベル
	MOV	AX,LEV			;
	MOV	BX,20			;
	MUL	BX			; 次のレベル×２０
	ADD	DI,AX			; ＋前のレベルぶんの経験値=必要な経験値
	CMP	KEIKEN,DI		; 今の経験値はレベルを満たしているか？
	JB	CALC_LEVEL_UP_LOOP_END	; だめだ
	JMP	CALC_LEVEL_UP_LOOP
CALC_LEVEL_UP_LOOP_END:

	DEC	LEV			; 新レベル

	; レベル

	MOV	SI,ADRS_HOW		; 人物
	CMPX	LEV,ES:[SI][HED_LVL]	; 現行レベルと新レベルの比較
	JBE	CALC_LEVEL_UP_EXIT	;

	MOVX	ES:[SI][HED_LVL],LEV	; 現行レベルと新レベルの比較

	CALL	UP_SENTOU_GIJUTSU	; ＵＰ・すばやさ＆先頭技術

	JMP	CALC_LEVEL_UP_UP	;

CALC_LEVEL_UP_EXIT:
	MOV	AX,0			; 0=前と変わらず
	RET
CALC_LEVEL_UP_UP:
	MOV	AX,1			; 1=レベルＵＰ
	RET
CALC_LEVEL_UP	ENDP


; ****************************************************
;	ＵＰ・すばやさ＆先頭技術
;	素早さ　・５から１０
;	戦闘技術・５から１０
;	-I-    ADRS_GRAPH : グラフテーブルアドレス
; ****************************************************

UP_SENTOU_GIJUTSU	PROC	NEAR
	MOV	CX,5			; 範囲（２００以内）
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	ADD	AX,5			; ５から１０
	MOV	RAND,AX			;
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	ADDOV	ES:[BX][GTB_SUBAYA][GRP_VALUE],RAND ; 11. 素早さ
	ADDOV	ES:[BX][GTB_SUBAYA][GRP_VALMAX],RAND ; 11. 素早さ

	MOV	CX,5			; 範囲（２００以内）
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	ADD	AX,5			; ５から１０
	MOV	RAND,AX			;
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	ADDOV	ES:[BX][GTB_SENTOH][GRP_VALUE],RAND ; 10. 戦闘技術
	ADDOV	ES:[BX][GTB_SENTOH][GRP_VALMAX],RAND ; 10. 戦闘技術

	RET
UP_SENTOU_GIJUTSU	ENDP


; ****************************************************
;	キャラクタの全整合チェック
;	-I- AX : 誰か（アドレス）
; ****************************************************

CALC_CHR_ALL_CHK	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_GRAP_GO		; 24=グラフ整合

	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_VAL_GO		; 25=内容表示整合

	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_HEAD_GO		; 14=ヘッダー整合

	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_LEVEL_UP		; 26=レベルＵＰ

	RET
CALC_CHR_ALL_CHK	ENDP


; ****************************************************
;	ＨＰセット
;	-I- AX : 誰か（アドレス）
;	    DX : 復活するポイント
; ****************************************************

CALC_HP_FUKKATU		PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	P_MY,DX			; 復活するポイント

	; グラフテーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフセット

	;・体力とＨＰ
	;	ＨＰ＝体力値
	;	ＨＰが上昇すると体力値が上昇
	;	ＨＰが下降すると体力値が下降
	;	ＨＰは体力最大値を越えられない


	; (1) 復活するポイントをＨＰに加算する。

	MOV	DX,P_MY					; 私
	ADDS	ES:[BX][GTB_HP][GRP_VALUE],DX		;14. ＨＰ
	ADDS	ES:[BX][GTB_HP][GRP_VALMAX],DX		;14. ＨＰ（最大値）


	; (2) ＨＰが体力最大値を越えていれば、体力最大値に合わせる。

	MOV	DX,ES:[BX][GTB_TAIRYOK][GRP_VALMAX]	; 0. 体力（最大値）
	CMP	ES:[BX][GTB_HP][GRP_VALUE],DX		;14. ＨＰ
	JBE	CALC_HP_FUKKATU_3			;
	MOV	ES:[BX][GTB_HP][GRP_VALUE],DX		;14. ＨＰ
	MOV	ES:[BX][GTB_HP][GRP_VALMAX],DX		;14. ＨＰ（最大値）
CALC_HP_FUKKATU_3:

;*;
;*;	; (3) ＨＰを体力値へセットする。
;*;
;*;	MOV	DX,ES:[BX][GTB_HP][GRP_VALUE]		;14. ＨＰ
;*;	MOV	ES:[BX][GTB_TAIRYOK][GRP_VALUE],DX	; 0. 体力
;*;
	RET
CALC_HP_FUKKATU		ENDP


; ****************************************************
;	ＭＰセット
;	-I- AX : 誰か（アドレス）
;	    DX : 復活するポイント
; ****************************************************

CALC_MP_FUKKATU		PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	P_MY,DX			; 私

	CALL	R_MAGIC_ARU		; 所有魔法ある？
	CMP	CX,0			; 技数が無しならば
	JMPEQ	CALC_MP_FUKKATU_NASHI	;

	; グラフテーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフセット

	;・知力とＭＰ
	;	ＭＰ＝知力値
	;	ＭＰが上昇すると知力値が上昇
	;	ＭＰが下降すると知力値が下降
	;	ＭＰは知力最大値を越えられない

	; (1) 復活するポイントをＭＰに加算する。

	MOV	DX,P_MY					; 私
	ADDS	ES:[BX][GTB_MP][GRP_VALUE],DX		;15. ＭＰ
	ADDS	ES:[BX][GTB_MP][GRP_VALMAX],DX		;15. ＭＰ（最大値）


	; (2) ＭＰが知力最大値を越えていれば、知力最大値に合わせる。

	MOV	DX,ES:[BX][GTB_TIRYOKU][GRP_VALMAX]	; 2. 知力（最大値）
	CMP	ES:[BX][GTB_MP][GRP_VALUE],DX		;15. ＭＰ
	JBE	CALC_MP_FUKKATU_3			;
	MOV	ES:[BX][GTB_MP][GRP_VALUE],DX		;15. ＭＰ
	MOV	ES:[BX][GTB_MP][GRP_VALMAX],DX		;15. ＭＰ（最大値）
CALC_MP_FUKKATU_3:

;*;
;*;	; (3) ＭＰを知力値へセットする。
;*;
;*;	MOV	DX,ES:[BX][GTB_MP][GRP_VALUE]		;15. ＭＰ
;*;	MOV	ES:[BX][GTB_TIRYOKU][GRP_VALUE],DX	; 2. 知力
;*;
	RET
CALC_MP_FUKKATU_NASHI:
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW			; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]		; BX=グラフテーブルオフセット
	MOV	WORD PTR ES:[BX][GTB_MP][GRP_VALUE],0	;15. ＭＰ
	MOV	WORD PTR ES:[BX][GTB_MP][GRP_VALMAX],0	;15. ＭＰ（最大値）
	RET
CALC_MP_FUKKATU		ENDP


; ****************************************************
;	生き返る
;	-I- AX : 誰か（アドレス）
; ****************************************************

CALC_IKIKAERU	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; グラフテーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフセット

	; (1) 知力を最大値まで復活する。

	MOV	AX,ES:[BX][GTB_TIRYOKU][GRP_VALMAX]	; 2. 知力（最大値）
	MOV	ES:[BX][GTB_TIRYOKU][GRP_VALUE],AX	; 2. 知力

	; (2) 体力を最大値まで復活する。

	MOV	AX,ES:[BX][GTB_TAIRYOK][GRP_VALMAX]	; 0. 体力（最大値）
	MOV	ES:[BX][GTB_TAIRYOK][GRP_VALUE],AX	; 0. 体力

	; (3) 知力をＭＰへコピーする。

	MOV	DX,ES:[BX][GTB_TIRYOKU][GRP_VALMAX]	; 2. 知力（最大値）
	MOV	ES:[BX][GTB_MP][GRP_VALUE],DX		;15. ＭＰ
	MOV	ES:[BX][GTB_MP][GRP_VALMAX],DX		;15. ＭＰ（最大値）

	; (4) 体力をＨＰへコピーする。

	MOV	DX,ES:[BX][GTB_TAIRYOK][GRP_VALMAX]	; 0. 体力（最大値）
	MOV	ES:[BX][GTB_HP][GRP_VALUE],DX		;14. ＨＰ
	MOV	ES:[BX][GTB_HP][GRP_VALMAX],DX		;14. ＨＰ（最大値）

	; (5) 体力をヘッダーのＨＰへコピーする。

	MOV	DX,ES:[BX][GTB_TAIRYOK][GRP_VALMAX]	; 0. 体力（最大値）
	MOV	DI,ADRS_HOW				; 人物
	MOV	ES:[DI][HED_HP],DX			; ＨＰ

	RET
CALC_IKIKAERU	ENDP


; ****************************************************
;	年齢、身長、体重、評価をみる
;	-I- AX : 誰か（アドレス）
;	-O- AX : 年齢
;	    BX : 身長
;	    CX : 体重
;	    DX : 評価
; ****************************************************

CALC_SHOW_PROPR		PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算

	; DI : 内容表示テーブルアドレス

	MOV	AX,ES:[DI][VTB_NENREI][VAL_VALUE]	; 4. 年齢
	MOV	BX,ES:[DI][VTB_SINCHO][VAL_VALUE]	; 5. 身長
	MOV	CX,ES:[DI][VTB_TAIJU][VAL_VALUE]	; 6. 体重

	; SI : グラフテーブルアドレス

	MOV	DX,ES:[SI][GTB_HYOKA][GRP_VALUE]	; 8. 評価

	RET
CALC_SHOW_PROPR		ENDP


; ****************************************************
;	マッハモード
;	-I- AX : モードスイッチ 0=ノーマル,1=マッハ
; ****************************************************

CALC_MACH_MODE	PROC	NEAR
	MOV	MODE_SW,AX		; モードスイッチ
	RET
CALC_MACH_MODE	ENDP


; ****************************************************
;	ミスコン予想
;	-I- DS:[BX] : １０人のアドレステーブル（出場者）
;	    DX      : 1=気品部門,2=プロポーション部門,3=色気部門
;	-O- DS:[DI] : (YOSOU_TBL) : 予想テーブル
;	              DS:[DI][0]:本命,DS:[DI][2]:対抗,DS:[DI][4]:穴
; ****************************************************

CALC_MISS_YOSOH		PROC	NEAR
	MOV	BUMON_NUM,DX		; 1=気品部門,2=プロポー部門,3=色気部門
	MOV	TOHJO_HOW_TBL,BX	; 登場人物テーブル

	CMP	BUMON_NUM,2		; 2=プロポー部門
	JE	CALC_MISS_YOSOH_5	;

	CALL	YOSO_CLR		; 予想テーブルクリア
	CALL	GET_MISS_YOSOH		; 予想テーブルＧＥＴ１０人前
	CALL	YOSO_SORT		; 予想テーブルソート
	JMP	CALC_MISS_YOSOH_6	;
CALC_MISS_YOSOH_5:

	CALL	YOSO_CLR		; 予想テーブルクリア
	CALL	GET_MISS_YOSOH		; 予想テーブルＧＥＴ１０人前
	CALL	YOSO_BRNC_SORT		; 予想テーブルバランスソート１０人前
CALC_MISS_YOSOH_6:

	MOV	DI,OFFSET YOSOU_TBL	; 予想テーブル

	RET
CALC_MISS_YOSOH		ENDP


; ****************************************************
;	予想テーブルＧＥＴ１０人前
;	-I- BUMON_NUM     : 1=気品部門,2=プロポー部門,3=色気部門
;	    TOHJO_HOW_TBL : 登場人物テーブル
;	-O- YOSOU_TBL     : 予想テーブル
;	    YOSOU_TBL_VAL : 予想テーブル/値
; ****************************************************

GET_MISS_YOSOH	PROC	NEAR

	MOV	TOHJO_HOW_PNT,0		; 登場人物テーブルポインタ
GET_MISS_YOSOH_LOOP:
	CMP	TOHJO_HOW_PNT,10	; 登場人物テーブルポインタ
	JMPEQ	GET_MISS_YOSOH_LOOP_E	;

	MOV	BX,TOHJO_HOW_TBL	; 登場人物テーブル
	MOV	SI,TOHJO_HOW_PNT	; 登場人物テーブルポインタ
	SHL	SI,1			;
	MOVX	ADRS_HOW,DS:[BX][SI]	; 登場人物テーブル

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算

	; DI : 内容表示テーブルアドレス
	; SI : グラフテーブルアドレス

	CMP	BUMON_NUM,1		; 1=気品部門
	JE	GET_MISS_YOSOH_KIHIN
	CMP	BUMON_NUM,2		; 2=プロポー部門
	JE	GET_MISS_YOSOH_PROPR
	CMP	BUMON_NUM,3		; 3=色気部門
	JE	GET_MISS_YOSOH_IROKE

GET_MISS_YOSOH_KIHIN:			; 気品部門
	MOV	DX,ES:[SI][GTB_KIHIN][GRP_VALUE] ;DX=気品／グラフテーブル
	JMP	GET_MISS_YOSOH_SET	;
GET_MISS_YOSOH_PROPR:			; プロポーション部門
	MOV	DX,ES:[DI][VTB_PROPRT][VAL_VALUE];DX=プロポー
	JMP	GET_MISS_YOSOH_SET	;
GET_MISS_YOSOH_IROKE:			; 色気部門
	MOV	DX,ES:[SI][GTB_IROKE][GRP_VALUE] ;DX=色気／グラフテーブル
	JMP	GET_MISS_YOSOH_SET	;

GET_MISS_YOSOH_SET:			;
	MOV	SI,TOHJO_HOW_PNT	; 登場人物テーブルポインタ
	SHL	SI,1			;
	MOVX	DS:YOSOU_TBL[SI],TOHJO_HOW_PNT ; 予想テーブルポインタ
	MOV	DS:YOSOU_TBL_VAL[SI],DX	; 予想テーブル/値

GET_MISS_YOSOH_NEXT:			;
	INC	TOHJO_HOW_PNT		; 登場人物テーブルポインタ
	JMP	GET_MISS_YOSOH_LOOP	;

GET_MISS_YOSOH_LOOP_E:			;

	RET
GET_MISS_YOSOH	ENDP


; ****************************************************
;	予想テーブルクリア１０人前
;	-O- YOSOU_TBL     : 予想テーブル
;	    YOSOU_TBL_VAL : 予想テーブル/値
; ****************************************************

YOSO_CLR	PROC	NEAR
	MOV	BX,0			;
	MOV	CX,10			;
YOSO_CLR_LOOP:				;
	MOV	DS:YOSOU_TBL[BX],0	; 予想テーブル
	MOV	DS:YOSOU_TBL_VAL[BX],0	; 予想テーブル/値
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	YOSO_CLR_LOOP		;
	RET
YOSO_CLR	ENDP


; ****************************************************
;	予想テーブルソート１０人前
;	（バブルソートで充分でしょ）
;	-I/O- YOSOU_TBL     : 予想テーブル
;	      YOSOU_TBL_VAL : 予想テーブル/値
; ****************************************************

YOSO_SORT	PROC	NEAR
	MOV	SI,0			;
	MOV	DI,0			;
	MOV	CX,10-1			;
YOSO_SORT_LOOP1:			;
	PUSH	CX			;
YOSO_SORT_LOOP2:			;
	INC	DI			;
	INC	DI			; word pointer.
	MOV	AX,DS:YOSOU_TBL_VAL[SI]	; 予想テーブル/値
	MOV	BX,DS:YOSOU_TBL_VAL[DI]	; 予想テーブル/値
	CMP	AX,BX			; if AX < BX then
	JNB	YOSO_SORT_ENDIF		;   swap AX,BX
	MOV	DS:YOSOU_TBL_VAL[SI],BX	;
	MOV	DS:YOSOU_TBL_VAL[DI],AX	;
	MOV	AX,DS:YOSOU_TBL[SI]	; 予想テーブル
	MOV	BX,DS:YOSOU_TBL[DI]	; 予想テーブル
	MOV	DS:YOSOU_TBL[SI],BX	; 予想テーブル
	MOV	DS:YOSOU_TBL[DI],AX	; 予想テーブル
YOSO_SORT_ENDIF:			;
YOSO_SORT_NEXT2:			;
	LOOP	YOSO_SORT_LOOP2		;
	INC	SI			;
	INC	SI			; word pointer.
	MOV	DI,SI			;
	POP	CX			;
	LOOP	YOSO_SORT_LOOP1		;
	RET
YOSO_SORT	ENDP


; ****************************************************
;	予想テーブルバランスソート１０人前
;	（バブルソートで充分でしょ）
;	-I/O- YOSOU_TBL     : 予想テーブル
;	      YOSOU_TBL_VAL : 予想テーブル/バランス値
; ****************************************************

YOSO_BRNC_SORT	PROC	NEAR
	MOV	SI,0			;
	MOV	DI,0			;
	MOV	CX,10-1			;
YOSO_BRNC_SORT_LOOP1:			;
	PUSH	CX			;
YOSO_BRNC_SORT_LOOP2:			;
	INC	DI			;
	INC	DI			; word pointer.

	MOV	AX,DS:YOSOU_TBL_VAL[SI]	; 予想テーブル/バランス値
	SUB	AX,100			; １００％を理想とする
	JGE	YOSO_BRNC_SORT_4	;
	NEG	AX			;
YOSO_BRNC_SORT_4:			;
	MOV	BX,DS:YOSOU_TBL_VAL[DI]	; 予想テーブル/バランス値
	SUB	BX,100			; １００％を理想とする
	JGE	YOSO_BRNC_SORT_5	;
	NEG	BX			;
YOSO_BRNC_SORT_5:			;

	CMP	AX,BX			; if AX > BX then
	JBE	YOSO_BRNC_SORT_ENDIF	;   swap AX,BX
	MOV	AX,DS:YOSOU_TBL_VAL[SI]	; 予想テーブル/バランス値
	MOV	BX,DS:YOSOU_TBL_VAL[DI]	; 予想テーブル/バランス値
	MOV	DS:YOSOU_TBL_VAL[SI],BX	;
	MOV	DS:YOSOU_TBL_VAL[DI],AX	;
	MOV	AX,DS:YOSOU_TBL[SI]	; 予想テーブル
	MOV	BX,DS:YOSOU_TBL[DI]	; 予想テーブル
	MOV	DS:YOSOU_TBL[SI],BX	; 予想テーブル
	MOV	DS:YOSOU_TBL[DI],AX	; 予想テーブル
YOSO_BRNC_SORT_ENDIF:			;
YOSO_BRNC_SORT_NEXT2:			;
	LOOP	YOSO_BRNC_SORT_LOOP2	;
	INC	SI			;
	INC	SI			; word pointer.
	MOV	DI,SI			;
	POP	CX			;
	LOOP	YOSO_BRNC_SORT_LOOP1	;
	RET
YOSO_BRNC_SORT	ENDP


; ****************************************************
;	お金見る
;	-I- AX : 誰か（アドレス）
;	-O- DX : 所持金
; ****************************************************

CALC_MONEY_SHOW		PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 内容表示テーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_VA_OFS]	; 内容表示テーブルオフセット
					; SI=内容表示テーブル
	; お金

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,ES:[SI][VTB_OKANE][VAL_VALUE] ; お金

	RET
CALC_MONEY_SHOW		ENDP


; ****************************************************
;	お金払う
;	-I- AX : 誰か（アドレス）
;	    DX : お金
; ****************************************************

CALC_MONEY_PAY		PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	VAL_GOLD,DX		; お金

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 内容表示テーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_VA_OFS]	; 内容表示テーブルオフセット
					; SI=内容表示テーブル
	; お金

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,VAL_GOLD		; お金
	SUBZ	ES:[SI][VTB_OKANE][VAL_VALUE],DX

	RET
CALC_MONEY_PAY		ENDP


; ****************************************************
;	お金貰う
;	-I- AX : 誰か（アドレス）
;	    DX : お金
; ****************************************************

CALC_MONEY_GIVE		PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	VAL_GOLD,DX		; お金

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 内容表示テーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_VA_OFS]	; 内容表示テーブルオフセット
					; SI=内容表示テーブル
	; お金

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,VAL_GOLD		; お金
	ADDOV	ES:[SI][VTB_OKANE][VAL_VALUE],DX

	RET
CALC_MONEY_GIVE		ENDP


; ****************************************************
;	ミスコン投票ソーティング
;	-I- DS:[SI] : 得票テーブル／１０人前
;	    DX      : 1=気品部門,2=プロポーション部門,3=色気部門,4=合計
;	-O- DS:[DI] : (YOSOU_TBL) : テーブル
;	              DS:[DI][0]:１位,DS:[DI][2]:２位,DS:[DI][4]:３位
; ****************************************************

CALC_MISS_SORT	PROC	NEAR
	MOV	NUM,0			; 番号
	MOV	BX,0			;
	MOV	CX,10			;
CALC_MISS_SORT_LOOP:			;
	LODSW				; 数値テーブル／１０人前
	MOV	YOSOU_TBL_VAL[BX],AX	; 予想テーブル/値
	MOVX	YOSOU_TBL[BX],NUM	; 予想テーブル
	INC	NUM			;
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	CALC_MISS_SORT_LOOP	;

	CALL	YOSO_SORT		; 予想テーブルソート


CALC_MISS_SORT_EXIT:
	MOV	DI,OFFSET YOSOU_TBL	; 予想テーブル

	RET
CALC_MISS_SORT	ENDP


; ****************************************************
;	ミスコン投票合計計算
;	-I- DS:[SI] : ライン１
;	    DS:[DI] : ライン２
;	    DS:[BX] : ライン３
;	    DS:[CX] : ライン合計
;	-O- DS:[CX] : ライン合計
; ****************************************************

CALC_MISS_GOUKEI	PROC	NEAR

	MOV	BP,CX
	MOV	CX,10
CALC_MISS_GOUKEI_LOOP:
	MOV	AX,DS:[SI]		; ライン１
	ADD	AX,DS:[DI]		; ライン２
	ADD	AX,DS:[BX]		; ライン３
	MOV	DS:[BP],AX		; ライン合計

	INC	SI			; ライン１
	INC	SI			; word pointer.
	INC	DI			; ライン２
	INC	DI			; word pointer.
	INC	BX			; ライン３
	INC	BX			; word pointer.
	INC	BP			; ライン合計
	INC	BP			; word pointer.
	LOOP	CALC_MISS_GOUKEI_LOOP

	RET
CALC_MISS_GOUKEI	ENDP


; ****************************************************
;	バトル即効決着
;	-I- AX : キャラクタアドレス・甲
;	    BX : キャラクタアドレス・乙
;	-O- AX : 甲の勝つ確率（％）
; ****************************************************

CALC_BATLE_KETSU	PROC	NEAR
	CALL	TEKIMIKATA_GET		; 敵味方ＧＥＴ

	; 私の勝つ確率
	; ＝１００÷（自分の経験値＋敵の経験値）×自分の経験値

	MOV	BX,G_KEIKEN[GRP_VALUE]	; 9. 経験値
	ADD	BX,GS_KEIKEN[GRP_VALUE]	; 9. 経験値
	MOV	DX,0			;
	MOV	AX,100			;
	FLOAT_IN	AX		;
	DIVX	BX			; AX=100/BX

	MOV	BX,G_SUBAYA[GRP_VALUE]	; 9. 経験値
	MUL	BX			;
	FLOAT_OUT	AX		;
	RET
CALC_BATLE_KETSU	ENDP


; ****************************************************
;	町の評判
;	-I- AX : 誰か（アドレス）
;	-O- DX : メッセージレベル 1=A, 2=B, 3=C, 4=D, 5=E, 6=F, 7=G
; ****************************************************

CALC_HYOHBAN	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフ
	MOV	DX,ES:[BX][GTB_HYOKA][GRP_VALUE] ; 評価

	CMP	DX,10			;
	JB	CALC_HYOHBAN_1		;
	CMP	DX,20			;
	JB	CALC_HYOHBAN_2		;
	CMP	DX,40			;
	JB	CALC_HYOHBAN_3		;
	CMP	DX,60			;
	JB	CALC_HYOHBAN_4		;
	CMP	DX,80			;
	JB	CALC_HYOHBAN_5		;
	CMP	DX,100			;
	JB	CALC_HYOHBAN_6		;
	JMP	CALC_HYOHBAN_7		;

CALC_HYOHBAN_1:
	MOV	DX,1			;
	RET
CALC_HYOHBAN_2:
	MOV	DX,2			;
	RET
CALC_HYOHBAN_3:
	MOV	DX,3			;
	RET
CALC_HYOHBAN_4:
	MOV	DX,4			;
	RET
CALC_HYOHBAN_5:
	MOV	DX,5			;
	RET
CALC_HYOHBAN_6:
	MOV	DX,6			;
	RET
CALC_HYOHBAN_7:
	MOV	DX,7			;
	RET

;*NON*;	MOV	ADRS_HOW,AX		; 人物
;*NON*;
;*NON*;	; 内容表示テーブルの年齢
;*NON*;
;*NON*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*NON*;	MOV	DI,ADRS_HOW		; 人物
;*NON*;
;*NON*;	MOV	BX,ES:[DI][HED_GR_OFS]		; BX=グラフテーブルオフセット
;*NON*;	MOVX	HYOHKA,ES:[BX][GTB_HYOKA+GRP_VALUE]; 評価
;*NON*;
;*NON*;	MOV	BX,ES:[DI][HED_VA_OFS]		; BX=内容表示テーブルオフセット
;*NON*;	MOV	DX,ES:[BX][VTB_NENREI+VAL_VALUE]; DX=年齢
;*NON*;
;*NON*;	; 年齢範囲チェック
;*NON*;
;*NON*;	CMP	DX,HYOUKA_BORDER_H	; 最上位年齢
;*NON*;	JBE	CALC_HYOHBAN_5		; 以上ならば
;*NON*;	MOV	DX,HYOUKA_BORDER_H	; 最上位年齢
;*NON*;CALC_HYOHBAN_5:				;
;*NON*;	CMP	DX,HYOUKA_BORDER_L	; 最下位年齢
;*NON*;	JNB	CALC_HYOHBAN_6		; 以下ならば
;*NON*;	MOV	DX,HYOUKA_BORDER_L	; 最下位年齢
;*NON*;CALC_HYOHBAN_6:				;
;*NON*;
;*NON*;	; ボーダーラインの取り出し
;*NON*;
;*NON*;	MOV	BX,DX			; DX=年齢
;*NON*;	SUB	BX,HYOUKA_BORDER_L	; 最下位年齢
;*NON*;	SHL	BX,1			; word pointer.
;*NON*;	MOV	AX,DS:HYOUKA_BORDER[BX]	; AX=評価ボーダーライン・テーブル
;*NON*;	MOV	HYOUKA_BDR_LINE,AX	; 評価ボーダーライン（１０で割った値）
;*NON*;
;*NON*;	; ボーダーラインから評判を計算する
;*NON*;
;*NON*;	;	評価がボーターライン＋５０％以上	１５割		Ａ
;*NON*;	;	評価がボーターライン＋２０％以上	１２割		Ｂ
;*NON*;	;	評価がボーターライン－２０％以上	８割		Ｃ
;*NON*;	;	評価がボーターライン－５０％以上	５割		Ｄ
;*NON*;	;	評価がボーターライン－５０％未満	５割以下	Ｅ
;*NON*;
;*NON*;	MOV	DX,0			;
;*NON*;	MOV	AX,HYOHKA		; AX=評価÷（評価ボーダーライン÷１０）
;*NON*;	MOV	BX,HYOUKA_BDR_LINE	;
;*NON*;	DIVX	BX			;
;*NON*;
;*NON*;	CMP	AX,15			; １５割	Ａ
;*NON*;	JNB	CALC_HYOHBAN_A		;
;*NON*;	CMP	AX,12			; １２割	Ｂ
;*NON*;	JNB	CALC_HYOHBAN_B		;
;*NON*;	CMP	AX,8			; ８割		Ｃ
;*NON*;	JNB	CALC_HYOHBAN_C		;
;*NON*;	CMP	AX,5			; ５割		Ｄ
;*NON*;	JNB	CALC_HYOHBAN_D		;
;*NON*;	JMP	CALC_HYOHBAN_E		; ５割以下	Ｅ
;*NON*;
;*NON*;CALC_HYOHBAN_A:
;*NON*;	MOV	DX,1			; メッセージレベル Ａ
;*NON*;	RET
;*NON*;CALC_HYOHBAN_B:
;*NON*;	MOV	DX,2			; メッセージレベル Ｂ
;*NON*;	RET
;*NON*;CALC_HYOHBAN_C:
;*NON*;	MOV	DX,3			; メッセージレベル Ｃ
;*NON*;	RET
;*NON*;CALC_HYOHBAN_D:
;*NON*;	MOV	DX,4			; メッセージレベル Ｄ
;*NON*;	RET
;*NON*;CALC_HYOHBAN_E:
;*NON*;	MOV	DX,5			; メッセージレベル Ｅ
;*NON*;	RET
CALC_HYOHBAN	ENDP


; ****************************************************
;	ヘッダーフラグのＩ／Ｏ
;	-I-   AX : 誰か（アドレス）
;	      BX : Ｉ／Ｏ 0:読み出し,1:書き込み
;	-I/O- DX : ヘッドフラグ
; ****************************************************

CALC_H_FLAGS	PROC	NEAR
	MOV	ADRS_HOW,AX			; 人物

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW			; 人物

	CMP	BX,1				; 0:読み出し,1:書き込み
	JE	CALC_H_FLAGS_O			;

	MOV	DX,ES:[DI][HED_FLAGS]		; フラグを読み出し
	RET
CALC_H_FLAGS_O:
	MOV	ES:[DI][HED_FLAGS],DX		; フラグをセット
	RET
CALC_H_FLAGS	ENDP


; ****************************************************
;	評価処理
;	-I- AX : 誰か（アドレス）
;	    DX : 加算される評価
;	-O- DX : 旧評価ポイント
;	    CX : 新評価ポイント
; ****************************************************

CALC_H_HYOUKA	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	HYOHKA,DX		; 加算される評価

	; ヘッダ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	; 評価計算
	;		ADDOV 符号無しオーバフロー防止

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	DX,ES:[BX][GTB_HYOKA][GRP_VALUE]	; DX=旧評価

	ADDOV	ES:[BX][GTB_HYOKA][GRP_VALUE],HYOHKA	; 評価
	ADDOV	ES:[BX][GTB_HYOKA][GRP_VALMAX],HYOHKA	; 評価

	MOV	CX,ES:[BX][GTB_HYOKA][GRP_VALUE]	; CX=新評価

	RET
CALC_H_HYOUKA	ENDP


; ****************************************************
;	会見チェック
;	-I- AX : 誰か（アドレス）
;	-O- AX : 会見が許されるレベル
;		0=全滅！
;		1=衛兵までＯＫ
;		2=近衛隊長までＯＫ
;		3=侍従までＯＫ
;		4=侍従長までＯＫ
;		5=王妃までＯＫ
;		6=王様までＯＫ
; ****************************************************

CALC_KAIKEN_CHK		PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; ヘッダ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	; パラメータ

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	DX,ES:[BX][GTB_KIHIN][GRP_VALUE] ; DX=気品

	; チェック

	MOV	NUM,0				; 会見が許されるレベル
	MOV	BX,0				;
	MOV	CX,OH_KAIKEN_MAX		; 王様会見の段階数
CALC_KAIKEN_CHK_LOOP:
	CMP	DX,DS:OH_KAIKEN_KIHIN_LVL[BX]	; 王様会見の気品基準レベル
	JL	CALC_KAIKEN_CHK_LOOP_END	;
	INC	NUM				;
	INC	BX				;
	INC	BX				; word pointer.
	LOOP	CALC_KAIKEN_CHK_LOOP
CALC_KAIKEN_CHK_LOOP_END:
	MOV	AX,NUM				; 会見が許されるレベル
	RET
CALC_KAIKEN_CHK		ENDP


; ****************************************************
;	誕生日と年齢／日次処理
;	-I- AX : 誰か（アドレス）
;	    BX : 環境テーブル（アドレス）
;	-O- AX : 誕生日フラグ 0=誕生日じゃない,1=ｂｏｒｔｈｄａｙ！
;	    DX : いくつになったか
;	環境時間と誕生日を較べて、誕生日ならば年齢を
;	インクリメントする。
;
; ****************************************************

CALC_TANJYO_CHK	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	ADRS_ENVIR,BX		; 環境テーブル

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス

	; 環境時間

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_ENVIR		; 環境テーブル
	MOV	DI,ES:[BX][KAN_ENVIR_TIME] ; DI=環境時間

	; 誕生日

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	MOV	SI,ES:[BX][VTB_TANJOBI][VAL_VALUE]	; SI=誕生日

	ADD	DI,5			; 年代をスキップ"1990/03/31"
	ADD	SI,5			; 年代をスキップ"1990/03/31"

	PUSH	DS			; 誕生日か？
	MOVX	DS,ES			;
	MOV	CX,5			; "03/31" "03/31"
	REPE	CMPSB			;
	POP	DS			;
	JNE	CALC_TANJYO_CHK_NONE	;

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	INC	WORD PTR ES:[BX][VTB_NENREI][VAL_VALUE] ; 年齢

CALC_TANJYO_CHK_EXIT:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	MOV	DX,ES:[BX][VTB_NENREI][VAL_VALUE] ; 年齢
	MOV	AX,1			; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	RET
CALC_TANJYO_CHK_NONE:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	MOV	DX,ES:[BX][VTB_NENREI][VAL_VALUE] ; 年齢
	MOV	AX,0			; 誕生日フラグ 0=誕生日じゃない
	RET
CALC_TANJYO_CHK	ENDP


; ****************************************************
;	回復／日次処理
;	-I- AX : 誰か（アドレス）
;
;	グラフ値の全てを最大値まで回復する。
;
; ****************************************************

CALC_KAIFUKU_CHK	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	CX,G_TABLE_CNT		; グラフパラメータ数
CALC_KAIFUKU_CHK_LOOP:
	MOVX	ES:[SI][GRP_VALUE],ES:[SI][GRP_VALMAX] ; グラフ数値＝グラフ最大
	ADD	SI,GRP_NEXT		; 次のグラフ
	LOOP	CALC_KAIFUKU_CHK_LOOP

	RET
CALC_KAIFUKU_CHK	ENDP


; ****************************************************
;	身長・体重の成長／月次処理
;	-I- AX : 誰か（アドレス）
;
;	乱数に従い、年齢毎の成長を計算する。
;
;	身長は毎月ごとに
;	１５才未満		０から５ミリ
;	１５才から２０才	０から２ミリ
;	２１才以上		全くのびない。
;
;	体重は毎月ごとに
;	自キャラは		０から３００グラム（４００グラム）
;	その他キャラは		０から２００グラム
;
; ****************************************************

CALC_SEICHO_VAL	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	CHAR_FLAG,DX		; キャラクターフラグ

	; 年齢

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_VALUE		; 内容表示テーブルアドレス
	MOVX	NENREY,ES:[DI][VTB_NENREI][VAL_VALUE]	; 4. 年齢

	; 成長の度合・身長

	CMP	NENREY,15		; １５才未満
	JGE	CALC_SEICHO_VAL_21	;
;;;;	MOV	CX,8			; 範囲／０から８ミリ
	MOV	CX,5			; 範囲／０から５ミリ
	JMP	CALC_SEICHO_VAL_25	;
CALC_SEICHO_VAL_21:
	CMP	NENREY,21		; ２１才未満
	JGE	CALC_SEICHO_VAL_22	;
	MOV	CX,2			; 範囲／０から２ミリ
	JMP	CALC_SEICHO_VAL_25	;
CALC_SEICHO_VAL_22:
	MOV	CX,0			; 範囲／無し
	JMP	CALC_SEICHO_VAL_25	;
CALC_SEICHO_VAL_25:
	INC	CX			;
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	DEC	AX			;
	MOV	RAND,AX			; １からＣＸの数字

	; 身長

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_VALUE		; 内容表示テーブルアドレス
	ADDOV	ES:[DI][VTB_SINCHO][VAL_VALUE],RAND	; 5. 身長

	; 成長の度合・体重

	TEST	CHAR_FLAG,FLAGS_HEROINE	;bit15 : ヒロイン
	JZ	CALC_SEICHO_VAL_51	;
;;;;	MOV	CX,3			; 範囲／０から３００グラム
;;;	MOV	CX,4			; 範囲／０から４００グラム
	CALL	TAIJYU_HEROINE		; ヒロイン成長の度合・体重
	JMP	CALC_SEICHO_VAL_54	;
CALC_SEICHO_VAL_51:
	TEST	CHAR_FLAG,FLAGS_MONSTER	;bit14 : モンスタ
	JZ	CALC_SEICHO_VAL_52	;
	MOV	CX,4			; 範囲／０から４００グラム
	JMP	CALC_SEICHO_VAL_53	;
CALC_SEICHO_VAL_52:
	MOV	CX,4			; 範囲／０から４００グラム
	JMP	CALC_SEICHO_VAL_53	;
CALC_SEICHO_VAL_53:
	INC	CX			;
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	DEC	AX			;
	MOV	RAND,AX			; １からＣＸの数字
CALC_SEICHO_VAL_54:

	; 体重

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_VALUE		; 内容表示テーブルアドレス
	ADDOV	ES:[DI][VTB_TAIJU][VAL_VALUE],RAND	; 6. 体重

	; プロポーションを揃える

	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_VAL_GO		; 内容表示整合

	RET
CALC_SEICHO_VAL	ENDP


; ****************************************************
;	ヒロイン成長の度合・体重
;	-I- ADRS_GRAPH : グラフテーブルアドレス
;	-O- RAND       : 増える重さ
; ****************************************************

TAIJYU_HEROINE	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ADRS_GRAPH			; グラフテーブルアドレス

	MOV	DX,ES:[SI][GTB_HIROU][GRP_VALUE]	; 5. 疲労
	CMP	DX,70					;７０以上は痩せる
	JNB	TAIJYU_HEROINE_YASE			;


	MOV	DX,ES:[SI][GTB_TAIRYOK][GRP_VALUE]	; 0. 体力
	CMP	DX,200					;２００以上はもっと太る
	JNB	TAIJYU_HEROINE_DEBU			;
	CMP	DX,100					;１００以上は太る
	JNB	TAIJYU_HEROINE_NORMAL3			;
	CMP	DX,50					;５０以上はチト太る
	JNB	TAIJYU_HEROINE_NORMAL2			;

TAIJYU_HEROINE_NORMAL:
	MOV	CX,5				; 範囲／１００から５００グラム
	JMP	TAIJYU_HEROINE_EXIT
TAIJYU_HEROINE_NORMAL2:
	MOV	CX,6 ;7				; 範囲／１００から６００グラム
	JMP	TAIJYU_HEROINE_EXIT
TAIJYU_HEROINE_NORMAL3:
	MOV	DX,ES:[SI][GTB_HIROU][GRP_VALUE] ; 5. 疲労
	CMP	DX,30				;３０以上は痩せる
	JNB	TAIJYU_HEROINE_NORMAL2		;
	MOV	CX,8				; 範囲／１００から８００グラム
	JMP	TAIJYU_HEROINE_EXIT
TAIJYU_HEROINE_DEBU:
	MOV	DX,ES:[SI][GTB_HIROU][GRP_VALUE] ; 5. 疲労
	CMP	DX,30				;３０以上は痩せる
	JNB	TAIJYU_HEROINE_NORMAL2		;
	MOV	CX,10				; 範囲／１００から１０００
	JMP	TAIJYU_HEROINE_EXIT
TAIJYU_HEROINE_YASE:
	MOV	CX,2				; 範囲／１００から２００グラム
TAIJYU_HEROINE_EXIT:
	CALL	HOOK_RANDAM			; 乱数範囲指定フック
	MOV	RAND,AX				; １からＣＸの数字

;*;	CODE_IN
;*;	PRV	"体重RAND=",RAND
;*;	CODE_OUT
	RET
TAIJYU_HEROINE	ENDP


; ****************************************************
;	ポイントの成長／月次処理
;	-I- AX : 誰か（アドレス）
;
;	ヒロイン以外の自動的成長を計算する
;
; ****************************************************

CALC_SEICHO_GRP	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; ヘッダ計算

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	CHAR_FLAG,DX		; キャラクターフラグ

	TEST	CHAR_FLAG,FLAGS_HEROINE	;bit15 : ヒロインは無し
	JZ	CALC_SEICHO_GRP_POWER_UP;
	JMP	CALC_SEICHO_GRP_EXIT	;

	; パワーアップ！

CALC_SEICHO_GRP_POWER_UP:

	MOV	BX,GTB_TAIRYOK		; 0. 体力
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_WANRYOK		; 1. 腕力
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_TIRYOKU		; 2. 知力
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_KIHIN		; 3. 気品
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_KONJYO		; 4. 根性
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_IROKE		; 6. 色気
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_MORAL		; 7. モラル
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_KEIKEN		; 9. 経験値
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_SENTOH		;10. 戦闘技術
	CALL	SEICHO_GRP_ONE		; 成長ポイント

	MOV	BX,GTB_SUBAYA		;11. 素早さ
	CALL	SEICHO_GRP_ONE		; 成長ポイント



;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_TAIRYOK][GRP_VALUE] ; 0. 体力
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_TAIRYOK][GRP_VALUE],AX ; 0. 体力
;*;	ADD	ES:[SI][GTB_TAIRYOK][GRP_VALMAX],AX ; 0. 体力
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_WANRYOK][GRP_VALUE] ; 1. 腕力
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_WANRYOK][GRP_VALUE],AX ; 1. 腕力
;*;	ADD	ES:[SI][GTB_WANRYOK][GRP_VALMAX],AX ; 1. 腕力
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_TIRYOKU][GRP_VALUE] ; 2. 知力
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_TIRYOKU][GRP_VALUE],AX ; 2. 知力
;*;	ADD	ES:[SI][GTB_TIRYOKU][GRP_VALMAX],AX ; 2. 知力
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_KIHIN][GRP_VALUE] ; 3. 気品
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_KIHIN][GRP_VALUE],AX ; 3. 気品
;*;	ADD	ES:[SI][GTB_KIHIN][GRP_VALMAX],AX ; 3. 気品
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_KONJYO][GRP_VALUE] ; 4. 根性
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_KONJYO][GRP_VALUE],AX ; 4. 根性
;*;	ADD	ES:[SI][GTB_KONJYO][GRP_VALMAX],AX ; 4. 根性
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_IROKE][GRP_VALUE] ; 6. 色気
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_IROKE][GRP_VALUE],AX ; 6. 色気
;*;	ADD	ES:[SI][GTB_IROKE][GRP_VALMAX],AX ; 6. 色気
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_MORAL][GRP_VALUE] ; 7. モラル
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_MORAL][GRP_VALUE],AX ; 7. モラル
;*;	ADD	ES:[SI][GTB_MORAL][GRP_VALMAX],AX ; 7. モラル
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_KEIKEN][GRP_VALUE] ; 9. 経験値
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_KEIKEN][GRP_VALUE],AX ; 9. 経験値
;*;	ADD	ES:[SI][GTB_KEIKEN][GRP_VALMAX],AX ; 9. 経験値
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_SENTOH][GRP_VALUE] ;10. 戦闘技術
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_SENTOH][GRP_VALUE],AX ;10. 戦闘技術
;*;	ADD	ES:[SI][GTB_SENTOH][GRP_VALMAX],AX ;10. 戦闘技術
;*;
;*;	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
;*;	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
;*;;*NON*;	MOV	AX,ES:[SI][GTB_SUBAYA][GRP_VALUE] ;11. 素早さ
;*;	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
;*;;*NON*;	CALL	MUL_PARCENT		; ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;	ADD	ES:[SI][GTB_SUBAYA][GRP_VALUE],AX ;11. 素早さ
;*;	ADD	ES:[SI][GTB_SUBAYA][GRP_VALMAX],AX ;11. 素早さ

CALC_SEICHO_GRP_EXIT:
	RET
CALC_SEICHO_GRP	ENDP

; ****************************************************
;	成長ポイント
;	-I- ADRS_GRAPH : グラフテーブルアドレス
;	    BX         : ポイントオフセット
; ****************************************************

SEICHO_GRP_ONE	PROC	NEAR
	PUSH	BX
	CALL	KONJYO_UP_POINT		; 根性からＵＰの度合（乱数）計算
	POP	BX
	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,RAND			; ＡＸ＝ＡＸ＋ＲＡＮＤ
	ADDS	ES:[SI][BX][GRP_VALMAX],AX

	MOV	AX,ES:[SI][BX][GRP_VALMAX]
	MOV	ES:[SI][BX][GRP_VALUE],AX
	RET
SEICHO_GRP_ONE	ENDP


; ****************************************************
;	根性からポイントＵＰの度合（乱数）計算
;	-I- ADRS_GRAPH : グラフテーブルアドレス
;	-O- RAND : ％
;	    ES   : ＷＩＮＤＯＷＳセグメント
;
;	エリアがないので
;	＋αを根性の初期値とします
;
; ****************************************************

KONJYO_UP_POINT	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,ES:[SI][GTB_ALPHA][GRP_VALUE] ; 16. ＋α
	MAXCUT	AX,20,80		; ２０以上８０以下に補正する

	MOV	DX,0			;
	MOV	BX,3			; ÷３
	DIV	BX			;
	MOV	CX,AX			; ＣＸ＝６から２６

	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	MOV	RAND,AX			; １からＣＸの数字

	MOV	CX,6			;
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	CMP	AX,4			;
	JLE	KONJYO_UP_POINT_8	;
	NEG	RAND			;
KONJYO_UP_POINT_8:			;

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	RET
KONJYO_UP_POINT	ENDP


;*;; ****************************************************
;*;;	ＡＸ＝ＡＸ×（ＲＡＮＤ％）
;*;;	-I- AX   : もとの数
;*;;	    RAND : ％
;*;;	-O- AX   : ％数
;*;; ****************************************************
;*;
;*;MUL_PARCENT	PROC	NEAR
;*;	MOV	BX,RAND			;
;*;	MUL	BX			; DX:AX = AX * RAND
;*;
;*;	MOV	BX,100			;
;*;	DIVX	BX			; AX = DX:AX / 100
;*;
;*;					; すなわち AX = ( AX * RND ) / 100
;*;	RET
;*;MUL_PARCENT	ENDP


; ****************************************************
;	バカンスパラメータ計算
;	-I- SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    AX : 使用するお金
;	-O- AX : 0=バカンスしました,2=お金が足りません
;	    DX : モラルアップ予定ポイント
;	    CX : 疲労回復予定ポイント
; ****************************************************

CALC_BACANCE_PAR	PROC	NEAR
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	VAL_GOLD,AX		; お金

	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

;*;	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
;*;	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	CMPX	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金
	JNB	CALC_BACANCE_PAR_OK		;
	JMP	CALC_BACANCE_PAR_NON		;

CALC_BACANCE_PAR_OK:
	SUBZ	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金

;*;	MOV	AX,G_MORAL[GRP_VALUE]		; 7. モラル
;*;	MOV	BX,12				;
;*;	MUL	BX				;
;*;	MOV	BX,10				; モラル１２０％
;*;	DIVX	BX				;
;*;	MOV	G_MORAL[GRP_VALUE],AX		; 7. モラル
;*;	MOV	G_MORAL[GRP_VALMAX],AX		; 7. モラル
;*;
;*;	MOVX	STG_WRTF1,7			; 変動グラフ１
;*;	MOV 	STG_AD_WRTF1,OFFSET G_MORAL	; 7. モラル
;*;	MOV	STG_WRTF2,OFFF			; 変動グラフ２(OFF)
;*;CALC_BACANCE_PAR_SET:
;*;	CALL	CHK_GRAPH		; グラフパラメータ整合チェック
;*;
;*;	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
;*;	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ

	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

;*;	CALL	CHK_GRP_DISP		; グラフ表示

	; モラルアップ予定ポイント

	MOV	AX,G_MORAL[GRP_VALUE]	; 7. モラル
	MOV	BX,2			;
	MUL	BX			;
	MOV	BX,10			; モラル２０％
	DIVX	BX			;
	MOV	DX,AX			;

	MAXCUT	DX,2,30			; ２から３０まで

	MOV	CX,20			; 疲労回復予定ポイント＝２０
	MOV	AX,0			; 0=バカンスしました
	RET
CALC_BACANCE_PAR_NON:
	MOV	DX,0			;
	MOV	CX,0			;
	MOV	AX,2			; 2=お金が足りません
	RET
CALC_BACANCE_PAR	ENDP


; ****************************************************
;	服は何を着ているか
;	-I- AX : 誰か（アドレス）
;	-O- DX : 着ている服
; ****************************************************

CALC_FUKU_NANI	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; ヘッダ計算

	MOV	BX,ADRS_HOW		; 人物
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,ES:[BX][HED_FUKU]	; 着ている服

	RET
CALC_FUKU_NANI	ENDP


; ****************************************************
;	服の着替え
;	-I- AX : 誰か（アドレス）
;	    DX : 着替える服
; ****************************************************

CALC_FUKU_KIGAE	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; ヘッダ計算

	MOV	BX,ADRS_HOW		; 人物
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	ES:[BX][HED_FUKU],DX	; 着ている服
	RET
CALC_FUKU_KIGAE	ENDP


; ****************************************************
;	ＭＰの消費チェック
;	-I- AX : 誰か（アドレス）
;	    DX : 消費ＭＰ
;	-O- AX : 0=ＯＫ,1=ＭＰが足りません
; ****************************************************

CALC_MP_CHECK	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	MP_SHOUHI,DX		; 消費ＭＰ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	; ＭＰ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス

	MOV	AX,MP_SHOUHI		; 消費ＭＰ
	CMP	AX,ES:[SI][GTB_MP][GRP_VALUE]		;15. ＭＰ
	JNBE	CALC_MP_CHECK_NONE			;

CALC_MP_CHECK_EXIT:
	MOV	AX,0			; 0=ＯＫ
	RET
CALC_MP_CHECK_NONE:
	MOV	AX,1			; 1=ＭＰが足りません
	RET
CALC_MP_CHECK	ENDP


; ****************************************************
;	ＭＰの消費
;	-I- AX : 誰か（アドレス）
;	    DX : 消費ＭＰ
; ****************************************************

CALC_MP_SHOHI	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	MP_SHOUHI,DX		; 消費ＭＰ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	; ＭＰ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ADRS_GRAPH		; グラフテーブルアドレス

	SUBZ	ES:[SI][GTB_MP][GRP_VALUE],MP_SHOUHI	;15. ＭＰ
	SUBZ	ES:[SI][GTB_MP][GRP_VALMAX],MP_SHOUHI	;15. ＭＰ
	MOVX	G_MP[GRP_VALUE],ES:[SI][GTB_MP][GRP_VALUE] ;15. ＭＰ

	MOV	STG_WRTF1,15		; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_MP ; 15. ＭＰ
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	CALL	CHK_GRP_2DSP		; グラフ表示２

	RET
CALC_MP_SHOHI	ENDP


; ****************************************************
;	装甲強度の一時ＵＰ
;	-I- AX : 誰か（アドレス）
; ****************************************************

CALC_SOUKOU_1UP	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	AX,ES:[SI][GTB_SOKOH][GRP_VALUE] ; 12. 装甲強度
	MOV	BX,13				;
	MUL	BX				;
	MOV	BX,10				; １３０％ＵＰ
	DIVX	BX				;
	MOV	ES:[SI][GTB_SOKOH][GRP_VALUE],AX ; 12. 装甲強度

	CMP	AX,30				; 装甲強度、３０まではサービス
	JNB	CALC_SOUKOU_1UP_UNDER		;
	MOV	AX,30				;
	MOV	ES:[SI][GTB_SOKOH][GRP_VALUE],AX; 12. 装甲強度
CALC_SOUKOU_1UP_UNDER:
	MOV	G_SOKOH[GRP_VALUE],AX		; 装甲強度

	MOV	STG_WRTF1,12		; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_SOKOH ;12. 装甲強度
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	CALL	CHK_GRP_2DSP		; グラフ表示２

	RET
CALC_SOUKOU_1UP	ENDP


; ****************************************************
;	装甲強度の通常値
;	-I- AX : 誰か（アドレス）
; ****************************************************

CALC_SOUKOU_NORMAL	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	AX,ES:[SI][GTB_SOKOH][GRP_VALMAX] ; 12. 装甲強度
	MOV	ES:[SI][GTB_SOKOH][GRP_VALUE],AX ; 12. 装甲強度

	RET
CALC_SOUKOU_NORMAL	ENDP


; ****************************************************
;	ＨＰの回復
;	-I- AX : 誰か（アドレス）
;	    DX : 復活するポイント
; ****************************************************

CALC_HP_KAIFUKU		PROC	NEAR
	CALL	CALC_HP_FUKKATU		; ＨＰセット

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOVX	G_HP[GRP_VALUE],ES:[SI][GTB_HP][GRP_VALUE] ; 14. ＨＰ

	MOV	STG_WRTF1,14		; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_HP ; 14. ＨＰ
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	CALL	CHK_GRP_2DSP		; グラフ表示２

	RET
CALC_HP_KAIFUKU		ENDP


; ****************************************************
;	話しかける成功率
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : 成功率
; ****************************************************

CALC_TALK_SC	PROC	NEAR
	CALL	TEKIMIKATA_GET		; 敵味方ＧＥＴ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	; 成功率＝１００÷（気品/8＋敵の好戦度）×気品/8

	MOV	BX,G_KIHIN[GRP_VALUE]	; 3. 気品	自分
	SHR	BX,1			;
	SHR	BX,1			;
	SHR	BX,1			; / 8
	ADD	BX,GS_WAR[GRP_VALUE]	;17. 好戦度	敵
	MOV	DX,0			;
	MOV	AX,100			;
	FLOAT_IN	AX		;
	DIVX	BX			; AX=100/BX

	MOV	BX,G_KIHIN[GRP_VALUE]	; 3. 気品	自分
	SHR	BX,1			;
	SHR	BX,1			;
	SHR	BX,1			; / 8
	MUL	BX			;
	FLOAT_OUT	AX		;

	RET
CALC_TALK_SC	ENDP


; ****************************************************
;	モラル計算
;	-I- AX : 誰か（アドレス）
;	    DX : 変動するモラル
; ****************************************************

CALC_MORAL	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	P_MY,DX			; 復活するポイント

	; グラフテーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフセット

	; モラルに加算する。

	MOV	DX,P_MY					; 私
	ADDS	ES:[BX][GTB_MORAL][GRP_VALUE],DX	; 7. モラル
	ADDS	ES:[BX][GTB_MORAL][GRP_VALMAX],DX	; 7. モラル（最大値）

	MOVX	G_MORAL[GRP_VALUE],ES:[BX][GTB_MORAL][GRP_VALUE] ; 7. モラル

	MOV	STG_WRTF1,7		; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_MORAL ; 7. モラル
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	CALL	CHK_GRP_2DSP		; グラフ表示２

	RET
CALC_MORAL	ENDP


; ****************************************************
;	娘と話す計算
;	-I- AX : 娘（アドレス）
;	    DX : モード 1=やさしく話す,2=きびしく話す,3=説教
;			4=さらに説教,5=せっかん,6=さらにせっかん
;	    CX : 乱数
;	-O- DX : 結果 1=良い,2=悪い
; ****************************************************

CALC_MUSUME	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	WMODE,DX		; モード
	MOV	RAND,CX			; 乱数

	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	CHAR_FLAG,DX		; キャラクターフラグ

	CMP	WMODE,1			; 1=やさしく話す
	JMPEQ	CALC_MUSUME_YASASHIKU	; やさしく話す

	CMP	WMODE,2			; 2=きびしく話す
	JMPEQ	CALC_MUSUME_KIBISHIKU	; きびしく話す

	CMP	WMODE,3			; 3=説教
	JMPEQ	CALC_MUSUME_SEKKYOU	; 説教

	CMP	WMODE,4			; 4=さらに説教
	JMPEQ	CALC_MUSUME_SARA_SEKKYO	; さらに説教

	CMP	WMODE,5			; 5=せっかん
	JMPEQ	CALC_MUSUME_SEKKAN	; せっかん

	CMP	WMODE,6			; 6=さらにせっかん
	JMPEQ	CALC_MUSUME_SARA_SEKKAN	; さらにせっかん


	; やさしく話す

CALC_MUSUME_YASASHIKU:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; AX= 4. 根性
	MOV	DX,ES:[BX][GTB_HIROU][GRP_VALUE]	; DX= 5. 疲労

	TEST	CHAR_FLAG,FLAGS_HIKOU	; 非行化？
	JNZ	CALC_MUSUME_YA_HIKOU	;

	CMP	AX,DX			; 根性と疲労のどちらが高い？
	JNBE	CALC_MUSUME_YA_KONJYO	;

	JMP	CALC_MUSUME_YA_HIROU	;

CALC_MUSUME_YA_HIROU:			; やさしく:疲労が高いと疲労が減る
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	SHR	WORD PTR ES:[BX][GTB_HIROU][GRP_VALUE],1  ; 5. 疲労
	SHR	WORD PTR ES:[BX][GTB_HIROU][GRP_VALMAX],1 ; 5. 疲労
	MOV	DX,1			; 結果 1=良い
	JMP	CALC_MUSUME_EXIT	;

CALC_MUSUME_YA_HIKOU:			; やさしく:非行化だと根性が倍減る
	ADD	RAND,10			; 非行化だと根性がさらに１０減る
CALC_MUSUME_YA_KONJYO:			; やさしく:根性が高いと根性が減る
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	SUBZ	ES:[BX][GTB_KONJYO][GRP_VALUE],RAND	; 4. 根性
	SUBZ	ES:[BX][GTB_KONJYO][GRP_VALMAX],RAND	; 4. 根性
	MOV	DX,2			; 結果 2=悪い
	JMP	CALC_MUSUME_EXIT	;


	; きびしく話す

CALC_MUSUME_KIBISHIKU:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; AX= 4. 根性
	MOV	DX,ES:[BX][GTB_HIROU][GRP_VALUE]	; DX= 5. 疲労

	TEST	CHAR_FLAG,FLAGS_HIKOU	; 非行化？
	JNZ	CALC_MUSUME_KI_HIKOU	;

	CMP	AX,DX			; 根性と疲労のどちらが高い？
	JNB	CALC_MUSUME_KI_KONJYO	;

	JMP	CALC_MUSUME_KI_HIROU	;

CALC_MUSUME_KI_HIKOU:			; きびしく:非行化だとそのまま
	MOV	DX,2			; 結果 2=悪い
	JMP	CALC_MUSUME_EXIT	;
CALC_MUSUME_KI_HIROU:			; きびしく:疲労が高いと疲労ＵＰ
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	ADDOV	ES:[BX][GTB_HIROU][GRP_VALUE],RAND	; 5. 疲労
	ADDOV	ES:[BX][GTB_HIROU][GRP_VALMAX],RAND	; 5. 疲労
	MOV	DX,2			; 結果 2=悪い
	JMP	CALC_MUSUME_EXIT	;

CALC_MUSUME_KI_KONJYO:			; きびしく:根性が高いと根性ＵＰ
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	ADDOV	ES:[BX][GTB_KONJYO][GRP_VALUE],RAND	; 4. 根性
	ADDOV	ES:[BX][GTB_KONJYO][GRP_VALMAX],RAND	; 4. 根性
	MOV	DX,1			; 結果 1=良い
	JMP	CALC_MUSUME_EXIT	;


	; 説教

CALC_MUSUME_SEKKYOU:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,ES:[BX][GTB_MORAL][GRP_VALUE]	; AX= 7. モラル
	MOV	DX,ES:[BX][GTB_HIROU][GRP_VALUE]	; DX= 5. 疲労

	TEST	CHAR_FLAG,FLAGS_HIKOU	; 非行化？
	JNZ	CALC_MUSUME_SE_HIKOU	;

	CMP	AX,DX			; モラルと疲労のどちらが高い？
	JNB	CALC_MUSUME_SE_MORAL	;

	JMP	CALC_MUSUME_SE_HIROU	; 説教:疲労が高いとモラルが減る

CALC_MUSUME_SE_HIKOU:			; 説教:非行化だとそのまま
	MOV	DX,2			; 結果 2=悪い
	JMP	CALC_MUSUME_EXIT	;

CALC_MUSUME_SE_HIROU:			; 説教:疲労が高いとモラルが減る
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALUE],RAND	; 7. モラル
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALMAX],RAND	; 7. モラル
	MOV	DX,2			; 結果 2=悪い
	JMP	CALC_MUSUME_EXIT	;

CALC_MUSUME_SE_MORAL:			; 説教:モラルが高いとモラルＵＰ
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	ADDOV	ES:[BX][GTB_MORAL][GRP_VALUE],RAND	; 7. モラル
	ADDOV	ES:[BX][GTB_MORAL][GRP_VALMAX],RAND	; 7. モラル
	MOV	DX,1			; 結果 1=良い
	JMP	CALC_MUSUME_EXIT	;


	; さらに説教

CALC_MUSUME_SARA_SEKKYO:		; さらに説教
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	ADDOV	ES:[BX][GTB_MORAL][GRP_VALUE],RAND	; 7. モラル
	ADDOV	ES:[BX][GTB_MORAL][GRP_VALMAX],RAND	; 7. モラル
	MOV	DX,1			; 結果 1=良い
	JMP	CALC_MUSUME_EXIT	;


	; せっかん

CALC_MUSUME_SEKKAN:			; せっかん
	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_ICHIBAN		; 体力、腕力・・・で一番は
	CMP	BX,5			; 5=色気
	JE	CALC_MUSUME_SEKKAN_IRO	;

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALUE],RAND	; 7. モラル
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALMAX],RAND	; 7. モラル
	MOV	DX,2			; 結果 2=悪い
	JMP	CALC_MUSUME_EXIT	;
CALC_MUSUME_SEKKAN_IRO:			; 色気せっかん
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	ADDOV	ES:[BX][GTB_IROKE][GRP_VALUE],RAND	; 6. 色気
	ADDOV	ES:[BX][GTB_IROKE][GRP_VALMAX],RAND	; 6. 色気
	ADD	RAND,10			; ＋１０
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALUE],RAND	; 7. モラル
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALMAX],RAND	; 7. モラル
	MOV	DX,1			; 結果 1=良い
	JMP	CALC_MUSUME_EXIT	;


	; さらにせっかん

CALC_MUSUME_SARA_SEKKAN:		; さらにせっかん
	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_ICHIBAN		; 体力、腕力・・・で一番は
	CMP	BX,5			; 5=色気
	JE	CALC_MUSUME_SARA_SEK_IRO

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALUE],RAND	; 7. モラル
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALMAX],RAND	; 7. モラル
	ADD	RAND,10			; ＋１０
	SUBZ	ES:[BX][GTB_KONJYO][GRP_VALUE],RAND	; 4. 根性
	SUBZ	ES:[BX][GTB_KONJYO][GRP_VALMAX],RAND	; 4. 根性
	MOV	DX,2			; 結果 2=悪い
	JMP	CALC_MUSUME_EXIT	;
CALC_MUSUME_SARA_SEK_IRO:		; さらに色気せっかん
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	ADD	RAND,10			; ＋１０
	ADDOV	ES:[BX][GTB_IROKE][GRP_VALUE],RAND	; 6. 色気
	ADDOV	ES:[BX][GTB_IROKE][GRP_VALMAX],RAND	; 6. 色気
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALUE],RAND	; 7. モラル
	SUBZ	ES:[BX][GTB_MORAL][GRP_VALMAX],RAND	; 7. モラル
	MOV	DX,1			; 結果 1=良い
	JMP	CALC_MUSUME_EXIT	;

CALC_MUSUME_EXIT:
	RET
CALC_MUSUME	ENDP


; ****************************************************
;	体力、腕力・・・で一番は
;	-I- AX : 娘（アドレス）
;	    DX : 根性を除くフラグ=1
;	-O- BX : 0=体力、1=腕力、2=知力、3=気品、4=根性、5=色気、6=モラル
;		（根性はカット）
; ****************************************************

CALC_ICHIBAN	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	FLAG_KONJO,DX		; 根性を除くフラグ=1

	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス

	MOV	DX,ES:[BX][GTB_MORAL][GRP_VALUE]	; 7. モラル
	CALL	ICHIBAN_HIKAKU				; 一番比較
	CMP	AX,1					; 1=一番
	JE	CALC_ICHIBAN_MORARU			; モラル

	MOV	DX,ES:[BX][GTB_IROKE][GRP_VALUE]	; 6. 色気
	CALL	ICHIBAN_HIKAKU				; 一番比較
	CMP	AX,1					; 1=一番
	JE	CALC_ICHIBAN_IROKE			; 色気

	MOV	DX,ES:[BX][GTB_KIHIN][GRP_VALUE]	; 3. 気品
	CALL	ICHIBAN_HIKAKU				; 一番比較
	CMP	AX,1					; 1=一番
	JE	CALC_ICHIBAN_KIHIN			; 気品

	MOV	DX,ES:[BX][GTB_TAIRYOK][GRP_VALUE]	; 0. 体力
	CALL	ICHIBAN_HIKAKU				; 一番比較
	CMP	AX,1					; 1=一番
	JE	CALC_ICHIBAN_TAIRYOKU			; 体力

	MOV	DX,ES:[BX][GTB_WANRYOK][GRP_VALUE]	; 1. 腕力
	CALL	ICHIBAN_HIKAKU				; 一番比較
	CMP	AX,1					; 1=一番
	JE	CALC_ICHIBAN_WANRYOKU			; 腕力

	MOV	DX,ES:[BX][GTB_TIRYOKU][GRP_VALUE]	; 2. 知力
	CALL	ICHIBAN_HIKAKU				; 一番比較
	CMP	AX,1					; 1=一番
	JE	CALC_ICHIBAN_CHIRYOKU			; 知力


	CMP	FLAG_KONJO,1				; 根性を除くフラグ=1
	JE	CALC_ICHIBAN_4				;
	MOV	DX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; 4. 根性
	CALL	ICHIBAN_HIKAKU				; 一番比較
	CMP	AX,1					; 1=一番
	JE	CALC_ICHIBAN_KONJYO			; 根性
CALC_ICHIBAN_4:


CALC_ICHIBAN_TAIRYOKU:			; 体力
	MOV	BX,0			; 0=体力
	RET
CALC_ICHIBAN_WANRYOKU:			; 腕力
	MOV	BX,1			; 1=腕力
	RET
CALC_ICHIBAN_CHIRYOKU:			; 知力
	MOV	BX,2			; 2=知力
	RET
CALC_ICHIBAN_KIHIN:			; 気品
	MOV	BX,3			; 3=気品
	RET
CALC_ICHIBAN_KONJYO:			; 根性
	MOV	BX,4			; 4=根性
	RET
CALC_ICHIBAN_IROKE:			; 色気
	MOV	BX,5			; 5=色気
	RET
CALC_ICHIBAN_MORARU:			; モラル
	MOV	BX,6			; 6=モラル
	RET
CALC_ICHIBAN	ENDP


; ****************************************************
;	一番比較
;	-I- ADRS_GRAPH : グラフテーブルアドレス
;	    DX         : 比較ポイント
;	    FLAG_KONJO : 根性を除くフラグ=1
;	-O- AX         : 比較結果 0=だめ,1=一番
; ****************************************************

ICHIBAN_HIKAKU	PROC	NEAR
	MOV	BX,ADRS_GRAPH			; グラフテーブルアドレス
	CMP	DX,ES:[BX][GTB_TAIRYOK][GRP_VALUE]	; 0. 体力
	JB	ICHIBAN_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_WANRYOK][GRP_VALUE]	; 1. 腕力
	JB	ICHIBAN_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_TIRYOKU][GRP_VALUE]	; 2. 知力
	JB	ICHIBAN_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_KIHIN][GRP_VALUE]	; 3. 気品
	JB	ICHIBAN_HIKAKU_DAME			;

	CMP	FLAG_KONJO,1				; 根性を除くフラグ=1
	JE	ICHIBAN_HIKAKU_4			;
	CMP	DX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; 4. 根性
	JB	ICHIBAN_HIKAKU_DAME			;
ICHIBAN_HIKAKU_4:
	CMP	DX,ES:[BX][GTB_IROKE][GRP_VALUE]	; 6. 色気
	JB	ICHIBAN_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_MORAL][GRP_VALUE]	; 7. モラル
	JB	ICHIBAN_HIKAKU_DAME			;
ICHIBAN_HIKAKU_OK:
	MOV	AX,1				; 比較結果 1=一番
	RET
ICHIBAN_HIKAKU_DAME:
	MOV	AX,0				; 比較結果 0=だめ
	RET
ICHIBAN_HIKAKU	ENDP


; ****************************************************
;	体力、腕力・・・で苦手は
;	-I- AX : 娘（アドレス）
;	    DX : 根性を除くフラグ=1
;	-O- BX : 0=体力、1=腕力、2=知力、3=気品、4=根性、5=色気、6=モラル
;		（根性はカット）
; ****************************************************

CALC_NIGATE	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	FLAG_KONJO,DX		; 根性を除くフラグ=1

	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス

	MOV	DX,ES:[BX][GTB_TAIRYOK][GRP_VALUE]	; 0. 体力
	CALL	NIGATE_HIKAKU				; 一番ダメ
	CMP	AX,1					; 1=一番
	JE	CALC_NIGATE_TAIRYOKU			; 体力

	MOV	DX,ES:[BX][GTB_WANRYOK][GRP_VALUE]	; 1. 腕力
	CALL	NIGATE_HIKAKU				; 一番ダメ
	CMP	AX,1					; 1=一番
	JE	CALC_NIGATE_WANRYOKU			; 腕力

	MOV	DX,ES:[BX][GTB_TIRYOKU][GRP_VALUE]	; 2. 知力
	CALL	NIGATE_HIKAKU				; 一番ダメ
	CMP	AX,1					; 1=一番
	JE	CALC_NIGATE_CHIRYOKU			; 知力

	MOV	DX,ES:[BX][GTB_KIHIN][GRP_VALUE]	; 3. 気品
	CALL	NIGATE_HIKAKU				; 一番ダメ
	CMP	AX,1					; 1=一番
	JE	CALC_NIGATE_KIHIN			; 気品

	CMP	FLAG_KONJO,1				; 根性を除くフラグ=1
	JE	CALC_NIGATE_4				;
	MOV	DX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; 4. 根性
	CALL	NIGATE_HIKAKU				; 一番ダメ
	CMP	AX,1					; 1=一番
	JE	CALC_NIGATE_KONJYO			; 根性
CALC_NIGATE_4:

	MOV	DX,ES:[BX][GTB_IROKE][GRP_VALUE]	; 6. 色気
	CALL	NIGATE_HIKAKU				; 一番ダメ
	CMP	AX,1					; 1=一番
	JE	CALC_NIGATE_IROKE			; 色気

	MOV	DX,ES:[BX][GTB_MORAL][GRP_VALUE]	; 7. モラル
	CALL	NIGATE_HIKAKU				; 一番ダメ
	CMP	AX,1					; 1=一番
	JE	CALC_NIGATE_MORARU			; モラル

CALC_NIGATE_TAIRYOKU:			; 体力
	MOV	BX,0			; 0=体力
	RET
CALC_NIGATE_WANRYOKU:			; 腕力
	MOV	BX,1			; 1=腕力
	RET
CALC_NIGATE_CHIRYOKU:			; 知力
	MOV	BX,2			; 2=知力
	RET
CALC_NIGATE_KIHIN:			; 気品
	MOV	BX,3			; 3=気品
	RET
CALC_NIGATE_KONJYO:			; 根性
	MOV	BX,4			; 4=根性
	RET
CALC_NIGATE_IROKE:			; 色気
	MOV	BX,5			; 5=色気
	RET
CALC_NIGATE_MORARU:			; モラル
	MOV	BX,6			; 6=モラル
	RET
CALC_NIGATE	ENDP


; ****************************************************
;	疲労の度合
;	-I- AX : 娘（アドレス）
;	-O- DX : 疲労加減 1=疲れ無し,2=ちょっと,3=かなり,4=重傷
; ****************************************************

CALC_HIROU	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,ES:[BX][GTB_HIROU][GRP_VALUE]	; AX= 5. 疲労

	MOV	BX,0			; word pointer.
	MOV	DX,0			; 疲労加減
	MOV	CX,HIROU_LEVEL_MAX	; 疲労レベル数
CALC_HIROU_LOOP:
	INC	DX			; 疲労加減
	CMP	AX,DS:HIROU_LEVEL[BX]	; 疲労＜＝疲労レベル
	JBE	CALC_HIROU_LOOP_E	;
	INC	BX			; word pointer.
	INC	BX			;
	LOOP	CALC_HIROU_LOOP		;
CALC_HIROU_LOOP_E:
	RET
CALC_HIROU	ENDP


; ****************************************************
;	気品段階
;	-I- AX : 娘（アドレス）
;	-O- DX : 気品加減（１から６）
;	    AX : 気品加減（１から３）
; ****************************************************

CALC_KIHIN	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,ES:[BX][GTB_KIHIN][GRP_VALUE] ; 3. 気品

	MOV	BX,0			; word pointer.
	MOV	KIHIN_LEV1,0		; 気品レベル１
	MOV	CX,KIHIN_LEVEL_MAX	; 気品レベル数
CALC_KIHIN_LOOP:
	INC	KIHIN_LEV1		; 気品レベル１
	CMP	AX,DS:KIHIN_LEVEL[BX]	; 気品＜＝気品レベル
	JBE	CALC_KIHIN_LOOP_E	;
	INC	BX			; word pointer.
	INC	BX			;
	LOOP	CALC_KIHIN_LOOP		;
CALC_KIHIN_LOOP_E:

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	AX,ES:[BX][GTB_KIHIN][GRP_VALUE] ; 3. 気品

	MOV	BX,0			; word pointer.
	MOV	KIHIN_LEV2,0		; 気品レベル２
	MOV	CX,KIHIN_LVL2_MAX	; 気品レベル２数
CALC_KIHIN_LOOP2:
	INC	KIHIN_LEV2		; 気品レベル２
	CMP	AX,DS:KIHIN_LVL2[BX]	; 気品＜＝気品レベル２
	JBE	CALC_KIHIN_LOOP2_E	;
	INC	BX			; word pointer.
	INC	BX			;
	LOOP	CALC_KIHIN_LOOP2	;
CALC_KIHIN_LOOP2_E:

	MOV	DX,KIHIN_LEV1		; 気品レベル１
	MOV	AX,KIHIN_LEV2		; 気品レベル２

	RET
CALC_KIHIN	ENDP


; ****************************************************
;	経験値の処理
;	-I- AX : 誰か（アドレス）
;	    DX : 加算される経験値
;	-O- DX : 旧経験値ポイント
;	    CX : 新経験値ポイント
; ****************************************************

CALC_KEIKEN	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	KEIKEN,DX		; 加算される経験値

	; ヘッダ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	; 経験値計算
	;		ADDOV 符号無しオーバフロー防止

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	DX,ES:[BX][GTB_KEIKEN][GRP_VALUE]	; DX=旧経験値

	ADDOV	ES:[BX][GTB_KEIKEN][GRP_VALUE],KEIKEN	; 経験値
	ADDOV	ES:[BX][GTB_KEIKEN][GRP_VALMAX],KEIKEN	; 経験値

	MOV	CX,ES:[BX][GTB_KEIKEN][GRP_VALUE]	; CX=新経験値

	RET
CALC_KEIKEN	ENDP


; ****************************************************
;	根性の処理
;	-I- AX : 誰か（アドレス）
;	    DX : 加算される根性
;	-O- DX : 旧根性ポイント
;	    CX : 新根性ポイント
; ****************************************************

CALC_KONJYO	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	KONJYO,DX		; 根性

	; ヘッダ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	; 根性計算
	;		ADDOV 符号無しオーバフロー防止

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	DX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; DX=旧経験値

	ADDOV	ES:[BX][GTB_KONJYO][GRP_VALUE],KONJYO	; 根性
	ADDOV	ES:[BX][GTB_KONJYO][GRP_VALMAX],KONJYO	; 根性

	MOV	CX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; CX=新経験値

	RET
CALC_KONJYO	ENDP


; ****************************************************
;	非行化・病気化
;	-I- AX : 誰か（アドレス）
;	-O- AX : 0=通常,1=変化あり
;	    DX : ありの場合 0=戻った,1=非行化,2=病気
; ****************************************************

CALC_HIKOU_BYO	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; ヘッダ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス

	; 病気発生率％＝疲労－（（体力÷８）＋５０）

	MOV	CX,ES:[BX][GTB_HIROU][GRP_VALUE]	; 5. 疲労
	MOV	DX,ES:[BX][GTB_TAIRYOK][GRP_VALUE]	; 0. 体力
	SHR	DX,1			;
	SHR	DX,1			;
	SHR	DX,1			; / 8
	ADD	DX,50			;
	SUBZ	CX,DX			;
	MAXCUT	CX,0,100		; 範囲

	MOV	V_SEIKOU,CX		; 病気率
;*;CODE_IN
;*;	PRV	"V_SEIKOU=",V_SEIKOU
;*;CODE_OUT
	MOV	CX,100			;
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	CMP	AX,V_SEIKOU		; 病気率
	JBE	CALC_HIKOU_BYO_BYOUKI	;


	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	MOV	SI,ADRS_HOW		; 人物
	TEST	WORD PTR ES:[SI][HED_FLAGS],FLAGS_HIKOU ; bit13 : 非行化
	JZ	CALC_HIKOU_BYO_2	;

	MOV	DX,ES:[BX][GTB_MORAL][GRP_VALUE]	; 7. モラル
	CMP	DX,30			; 非行化しているならば３０まで治らない
	JBE	CALC_HIKOU_BYO_HIKOU	;
	JMP	CALC_HIKOU_BYO_3
CALC_HIKOU_BYO_2:
	MOV	DX,ES:[BX][GTB_MORAL][GRP_VALUE]	; 7. モラル
	CMP	DX,2			; ２以下は非行化
	JBE	CALC_HIKOU_BYO_HIKOU	;
CALC_HIKOU_BYO_3:

	; フラグクリア

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物

	MOV	DX,ES:[BX][HED_FLAGS]	; フラグ

	AND	WORD PTR ES:[BX][HED_FLAGS],NOT FLAGS_BYOUKI ; bit12 : 病気化
	AND	WORD PTR ES:[BX][HED_FLAGS],NOT FLAGS_HIKOU  ; bit13 : 非行化

	CMP	DX,ES:[BX][HED_FLAGS]	; フラグ
	JMPEQ	CALC_HIKOU_BYO_EXIT	;
	MOV	DX,0			; ありの場合 0=戻った
	JMP	CALC_HIKOU_BYO_HENKA	;
CALC_HIKOU_BYO_BYOUKI:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	TEST	WORD PTR ES:[BX][HED_FLAGS],FLAGS_BYOUKI ; bit12 : 病気化
	JNZ	CALC_HIKOU_BYO_EXIT	;

	MOV	CX,100			; 範囲（２００以内）
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	CMP	AX,90;40			; １からＣＸの数字
	JNBE	CALC_HIKOU_BYO_EXIT	;

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	AND	WORD PTR ES:[BX][HED_FLAGS],NOT FLAGS_HIKOU  ; bit13 : 非行化
	MOV	DX,ES:[BX][HED_FLAGS]	; フラグ
	OR	WORD PTR ES:[BX][HED_FLAGS],FLAGS_BYOUKI ; bit12 : 病気化
	CMP	DX,ES:[BX][HED_FLAGS]	; フラグ
	JE	CALC_HIKOU_BYO_EXIT	;
	MOV	DX,2			; ありの場合 2=病気
	JMP	CALC_HIKOU_BYO_HENKA	;
CALC_HIKOU_BYO_HIKOU:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	TEST	WORD PTR ES:[BX][HED_FLAGS],FLAGS_HIKOU	; bit13 : 非行化
	JNZ	CALC_HIKOU_BYO_EXIT	;

	MOV	CX,100			; 範囲（２００以内）
	CALL	HOOK_RANDAM		; 乱数範囲指定フック
	CMP	AX,90;40			; １からＣＸの数字
	JNBE	CALC_HIKOU_BYO_EXIT	;

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 人物
	AND	WORD PTR ES:[BX][HED_FLAGS],NOT FLAGS_BYOUKI ; bit12 : 病気化
	MOV	DX,ES:[BX][HED_FLAGS]	; フラグ
	OR	WORD PTR ES:[BX][HED_FLAGS],FLAGS_HIKOU	; bit13 : 非行化
	CMP	DX,ES:[BX][HED_FLAGS]	; フラグ
	JE	CALC_HIKOU_BYO_EXIT	;
	MOV	DX,1			; ありの場合 1=非行化
	JMP	CALC_HIKOU_BYO_HENKA	;
CALC_HIKOU_BYO_EXIT:
	MOV	DX,0			;
	MOV	AX,0			; 0=通常
	RET
CALC_HIKOU_BYO_HENKA:
	MOV	AX,1			; 1=変化あり
	RET
CALC_HIKOU_BYO	ENDP


; ****************************************************
;	運命の決定
;	-I- AX : 誰か（アドレス）
;	-O- CX : 仕事のランク
;		1=特別職
;		2=特級職
;		3=上級職
;		4=中級職
;		5=下級職
;	    DX : 職業
;
;	☆特別職☆
;		1=女王
;		2=姫
;	☆特級職☆
;		3=長寿
;		4=将軍
;		5=王立アカデミー総裁
;		6=王宮魔術師
;		7=貴族の妻１
;		8=王の側室
;		9=司祭
;	☆上級職☆
;		10＊近衛の騎士＊
;		11＊近衛隊長＊
;		12=＊練金術師＊
;		13=＊魔導士＊
;		14=＊貴族の妻２＊
;		15=＊貴族の側室＊
;		16=＊上級尼僧＊
;	☆中級職☆
;		17=＊百姓の妻＊
;		18=＊木コリ＊
;		19=＊文士＊
;		20=＊魔法使い＊
;		21=＊商家の妻＊
;		22=＊酒場の女の子＊
;		23=＊尼僧＊
;	☆下級職☆
;		24=＊傭兵＊
;		25=＊賞金稼ぎ＊
;		26=＊詐欺師＊
;		27=＊旅の魔法使い＊
;		28=＊高級娼婦＊
;		29=＊売春婦＊
;		30=＊出戻り＊
; ****************************************************

CALC_UNMEI	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	; ヘッダ

	MOV	BX,ADRS_HOW		; 人物
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
	JNB	CALC_UNMEI_11		;1=特別職
;voidvoidvoid
	JNB	CALC_UNMEI_12		;2=特級職
;voidvoidvoid
	JNB	CALC_UNMEI_13		;3=上級職
;voidvoidvoid
	JNB	CALC_UNMEI_14		;4=中級職

	JMP	CALC_UNMEI_15		;5=下級職

CALC_UNMEI_11:				;1=特別職
	CALL	CALC_UNMEI_TOP		; 特別職
	JMP	CALC_UNMEI_20		;
CALC_UNMEI_12:				;2=特級職
	CALL	CALC_UNMEI_EXPART	; 特級職
	JMP	CALC_UNMEI_20		;
CALC_UNMEI_13:				;3=上級職
	CALL	CALC_UNMEI_GOLD		; 上級職
	JMP	CALC_UNMEI_20		;
CALC_UNMEI_14:				;4=中級職
	CALL	CALC_UNMEI_SILVER	; 中級職
	JMP	CALC_UNMEI_20		;
CALC_UNMEI_15:				;5=下級職
	CALL	CALC_UNMEI_COPPER	; 下級職
	JMP	CALC_UNMEI_20		;
CALC_UNMEI_20:				;

	MOV	CX,WORKING_RANK		; 仕事のランク
	MOV	DX,WORKING_KIND		; 職業
	RET
CALC_UNMEI	ENDP


; ****************************************************
;	運命の決定
;	特別職
;	-I- ADRS_GRAPH   : グラフテーブルアドレス
;	-O- WORKING_RANK : 仕事のランク
;	    WORKING_KIND : 職業
; ****************************************************

CALC_UNMEI_TOP	PROC	NEAR
	MOV	WORKING_RANK,1			; 1=特別職

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
	JNB	CALC_UNMEI_TOP_QUEEN		; 1=女王
	JMP	CALC_UNMEI_TOP_PRINCESS		; 2=姫

CALC_UNMEI_TOP_QUEEN:				; 1=女王
	MOV	WORKING_KIND,1			;
	RET
CALC_UNMEI_TOP_PRINCESS:			; 2=姫
	MOV	WORKING_KIND,2			;
	RET
CALC_UNMEI_TOP	ENDP


; ****************************************************
;	運命の決定
;	特級職
;	-I- ADRS_HOW     : 人物
;	    ADRS_GRAPH   : グラフテーブルアドレス
;	-O- WORKING_RANK : 仕事のランク
;	    WORKING_KIND : 職業
; ****************************************************

CALC_UNMEI_EXPART	PROC	NEAR
	MOV	WORKING_RANK,2			; 2=特級職

	MOV	AX,ADRS_HOW			; 人物
	MOV	DX,1				; 根性を除くフラグ=1
	PUSH	ADRS_HOW			; 人物
	PUSH	ADRS_GRAPH			; グラフテーブルアドレス
	CALL	CALC_ICHIBAN			; 体力、腕力・・・で一番は
	POP	ADRS_GRAPH			; グラフテーブルアドレス
	POP	ADRS_HOW			; 人物

;*;	CODE_IN
;*;	PRV	"BX=",BX
;*;	CODE_OUT

;voidvoidvoid
	JE	CALC_UNMEI_EXPART_W0		;	長寿
;voidvoidvoid
	JE	CALC_UNMEI_EXPART_W1		;	将軍
;voidvoidvoid
	JE	CALC_UNMEI_EXPART_W2		;	王立アカデミー総裁
;voidvoidvoid
	JE	CALC_UNMEI_EXPART_W4		;	貴族の妻１
;voidvoidvoid
	JE	CALC_UNMEI_EXPART_W5		;	王の側室
;voidvoidvoid
	JE	CALC_UNMEI_EXPART_W6		;	司祭

CALC_UNMEI_EXPART_W0:
	MOV	WORKING_KIND,3			; 3=長寿
	RET
CALC_UNMEI_EXPART_W1:
	MOV	WORKING_KIND,4			; 4=将軍
	RET
CALC_UNMEI_EXPART_W2:
	CALL	CALC_MAHO			; 魔法使いの判定
	CMP	AX,1				; 1=魔法使いになる
	JE	CALC_UNMEI_EXPART_W3		;
	MOV	WORKING_KIND,5			; 5=王立アカデミー総裁
	RET
CALC_UNMEI_EXPART_W3:
	MOV	WORKING_KIND,6			; 6=王宮魔術師
	RET
CALC_UNMEI_EXPART_W4:
	MOV	WORKING_KIND,7			; 7=貴族の妻１
	RET
CALC_UNMEI_EXPART_W5:
	MOV	WORKING_KIND,8			; 8=王の側室
	RET
CALC_UNMEI_EXPART_W6:
	MOV	WORKING_KIND,9			; 9=司祭
	RET
CALC_UNMEI_EXPART	ENDP


; ****************************************************
;	運命の決定
;	上級職
;	-I- ADRS_HOW     : 人物
;	    ADRS_GRAPH   : グラフテーブルアドレス
;	-O- WORKING_RANK : 仕事のランク
;	    WORKING_KIND : 職業
; ****************************************************

CALC_UNMEI_GOLD	PROC	NEAR
	MOV	WORKING_RANK,3			; 3=上級職

	MOV	AX,ADRS_HOW			; 人物
	MOV	DX,1				; 根性を除くフラグ=1
	PUSH	ADRS_HOW			; 人物
	PUSH	ADRS_GRAPH			; グラフテーブルアドレス
	CALL	CALC_ICHIBAN			; 体力、腕力・・・で一番は
	POP	ADRS_GRAPH			; グラフテーブルアドレス
	POP	ADRS_HOW			; 人物

;voidvoidvoid
	JE	CALC_UNMEI_GOLD_W0		; 	＊近衛の騎士＊
;voidvoidvoid
	JE	CALC_UNMEI_GOLD_W1		;	＊近衛隊長＊
;voidvoidvoid
	JE	CALC_UNMEI_GOLD_W2		;	＊練金術師＊
;voidvoidvoid
	JE	CALC_UNMEI_GOLD_W4		;	＊貴族の妻２＊
;voidvoidvoid
	JE	CALC_UNMEI_GOLD_W5		;	＊貴族の側室＊
;voidvoidvoid
	JE	CALC_UNMEI_GOLD_W6		;	＊上級尼僧＊

CALC_UNMEI_GOLD_W0:
	MOV	WORKING_KIND,10			; 10=＊近衛の騎士＊
	RET
CALC_UNMEI_GOLD_W1:
	MOV	WORKING_KIND,11			; 11=＊近衛隊長＊
	RET
CALC_UNMEI_GOLD_W2:
	CALL	CALC_MAHO			; 魔法使いの判定
	CMP	AX,1				; 1=魔法使いになる
	JE	CALC_UNMEI_GOLD_W3		;
	MOV	WORKING_KIND,12			; 12=＊練金術師＊
	RET
CALC_UNMEI_GOLD_W3:
	MOV	WORKING_KIND,13			; 13=＊魔導士＊
	RET
CALC_UNMEI_GOLD_W4:
	MOV	WORKING_KIND,14			; 14=＊貴族の妻２＊
	RET
CALC_UNMEI_GOLD_W5:
	MOV	WORKING_KIND,15			; 15=＊貴族の側室＊
	RET
CALC_UNMEI_GOLD_W6:
	MOV	WORKING_KIND,16			; 16=＊上級尼僧＊
	RET
CALC_UNMEI_GOLD	ENDP


; ****************************************************
;	運命の決定
;	中級職
;	-I- ADRS_HOW     : 人物
;	    ADRS_GRAPH   : グラフテーブルアドレス
;	-O- WORKING_RANK : 仕事のランク
;	    WORKING_KIND : 職業
; ****************************************************

CALC_UNMEI_SILVER	PROC	NEAR
	MOV	WORKING_RANK,4			; 4=中級職

	MOV	AX,ADRS_HOW			; 人物
	MOV	DX,1				; 根性を除くフラグ=1
	PUSH	ADRS_HOW			; 人物
	PUSH	ADRS_GRAPH			; グラフテーブルアドレス
	CALL	CALC_ICHIBAN			; 体力、腕力・・・で一番は
	POP	ADRS_GRAPH			; グラフテーブルアドレス
	POP	ADRS_HOW			; 人物

;voidvoidvoid
	JE	CALC_UNMEI_SILVER_W0		;	＊百姓の妻＊
;voidvoidvoid
	JE	CALC_UNMEI_SILVER_W1		;	＊木コリ＊
;voidvoidvoid
	JE	CALC_UNMEI_SILVER_W2		;	＊文士＊
;voidvoidvoid
	JE	CALC_UNMEI_SILVER_W4		;	＊商家の妻＊
;voidvoidvoid
	JE	CALC_UNMEI_SILVER_W5		;	＊酒場の女の子＊
;voidvoidvoid
	JE	CALC_UNMEI_SILVER_W6		;	＊尼僧＊

CALC_UNMEI_SILVER_W0:
	MOV	WORKING_KIND,17			; 17=＊百姓の妻＊
	RET
CALC_UNMEI_SILVER_W1:
	MOV	WORKING_KIND,18			; 18=＊木コリ＊
	RET
CALC_UNMEI_SILVER_W2:
	CALL	CALC_MAHO			; 魔法使いの判定
	CMP	AX,1				; 1=魔法使いになる
	JE	CALC_UNMEI_SILVER_W3		;
	MOV	WORKING_KIND,19			; 19=＊文士＊
	RET
CALC_UNMEI_SILVER_W3:
	MOV	WORKING_KIND,20			; 20=＊魔法使い＊
	RET
CALC_UNMEI_SILVER_W4:
	MOV	WORKING_KIND,21			; 21=＊商家の妻＊
	RET
CALC_UNMEI_SILVER_W5:
	MOV	WORKING_KIND,22			; 22=＊酒場の女の子＊
	RET
CALC_UNMEI_SILVER_W6:
	MOV	WORKING_KIND,23			; 23=＊尼僧＊
	RET
CALC_UNMEI_SILVER	ENDP


; ****************************************************
;	運命の決定
;	下級職
;	-I- ADRS_HOW     : 人物
;	    ADRS_GRAPH   : グラフテーブルアドレス
;	-O- WORKING_RANK : 仕事のランク
;	    WORKING_KIND : 職業
; ****************************************************

CALC_UNMEI_COPPER	PROC	NEAR
	MOV	WORKING_RANK,5			; 5=下級職

	MOV	AX,ADRS_HOW			; 人物
	MOV	DX,1				; 根性を除くフラグ=1
	PUSH	ADRS_HOW			; 人物
	PUSH	ADRS_GRAPH			; グラフテーブルアドレス
	CALL	CALC_ICHIBAN			; 体力、腕力・・・で一番は
	POP	ADRS_GRAPH			; グラフテーブルアドレス
	POP	ADRS_HOW			; 人物

;voidvoidvoid
	JE	CALC_UNMEI_COPPER_W0		;	＊傭兵＊
;voidvoidvoid
	JE	CALC_UNMEI_COPPER_W1		;	＊賞金稼ぎ＊
;voidvoidvoid
	JE	CALC_UNMEI_COPPER_W2		;	＊詐欺師＊
;voidvoidvoid
	JE	CALC_UNMEI_COPPER_W4		;	＊高級娼婦＊
;voidvoidvoid
	JE	CALC_UNMEI_COPPER_W5		;	＊売春婦＊
;voidvoidvoid
	JE	CALC_UNMEI_COPPER_W6		;	＊出戻り＊

CALC_UNMEI_COPPER_W0:
	MOV	WORKING_KIND,24			; 24=＊傭兵＊
	RET
CALC_UNMEI_COPPER_W1:
	MOV	WORKING_KIND,25			; 25=＊賞金稼ぎ＊
	RET
CALC_UNMEI_COPPER_W2:
	CALL	CALC_MAHO			; 魔法使いの判定
	CMP	AX,1				; 1=魔法使いになる
	JE	CALC_UNMEI_COPPER_W3		;
	MOV	WORKING_KIND,26			; 26=＊詐欺師＊
	RET
CALC_UNMEI_COPPER_W3:
	MOV	WORKING_KIND,27			; 27=＊旅の魔法使い＊
	RET
CALC_UNMEI_COPPER_W4:
	MOV	WORKING_KIND,28			; 28=＊高級娼婦＊
	RET
CALC_UNMEI_COPPER_W5:
	MOV	WORKING_KIND,29			; 29=＊売春婦＊
	RET
CALC_UNMEI_COPPER_W6:
	MOV	WORKING_KIND,30			; 30=＊出戻り＊
	RET
CALC_UNMEI_COPPER	ENDP


; ****************************************************
;	魔法使いの判定
;	-I- ADRS_HOW   : 人物
;	    ADRS_GRAPH : グラフテーブルアドレス
;	-O- AX         : 0=なれない,1=魔法使いになる
; ****************************************************

CALC_MAHO	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_GRAPH			; グラフテーブルアドレス
	MOV	AX,ES:[BX][GTB_TIRYOKU][GRP_VALUE] ; 2. 知力
	MOV	DX,ES:[BX][GTB_KEIKEN][GRP_VALUE]  ; 9. 経験値
	SHR	DX,1				; 経験値／２
	CMP	DX,AX				; 以上なければならない
	JB	CALC_MAHO_NORMAL		;

	CALL	R_MAGIC_ARU			; 所有魔法ある？
	CMP	CX,3				; 技数３より少ないのは無し
	JB	CALC_MAHO_NORMAL		;

CALC_MAHO_MAHO:
	MOV	AX,1				; 1=魔法使いになる
	RET
CALC_MAHO_NORMAL:
	MOV	AX,0				; 0=なれない
	RET
CALC_MAHO	ENDP


; ****************************************************
;	所有魔法ある？
;	-I- ADRS_HOW : 人物
;	-O- CX       : 技数
; ****************************************************

R_MAGIC_ARU	PROC	NEAR

	; 技リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	MOV	SI,ES:[BX][HED_LST_WZ]	; SI=技リスト

	; ＧＥＴ

	MOV	CX,ES:[SI][2]		; 技数: WINDOWS/表示単語の数
	RET
R_MAGIC_ARU	ENDP


; ****************************************************
;	一番ダメ
;	-I- ADRS_GRAPH : グラフテーブルアドレス
;	    DX         : 比較ポイント
;	    FLAG_KONJO : 根性を除くフラグ=1
;	-O- AX         : 比較結果 0=ふつう,1=一番ダメ
; ****************************************************

NIGATE_HIKAKU	PROC	NEAR
	MOV	BX,ADRS_GRAPH			; グラフテーブルアドレス
	CMP	DX,ES:[BX][GTB_TAIRYOK][GRP_VALUE]	; 0. 体力
	JNBE	NIGATE_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_WANRYOK][GRP_VALUE]	; 1. 腕力
	JNBE	NIGATE_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_TIRYOKU][GRP_VALUE]	; 2. 知力
	JNBE	NIGATE_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_KIHIN][GRP_VALUE]	; 3. 気品
	JNBE	NIGATE_HIKAKU_DAME			;

	CMP	FLAG_KONJO,1				; 根性を除くフラグ=1
	JE	NIGATE_HIKAKU_4				;
	CMP	DX,ES:[BX][GTB_KONJYO][GRP_VALUE]	; 4. 根性
	JNBE	NIGATE_HIKAKU_DAME			;
NIGATE_HIKAKU_4:					;

	CMP	DX,ES:[BX][GTB_IROKE][GRP_VALUE]	; 6. 色気
	JNBE	NIGATE_HIKAKU_DAME			;
	CMP	DX,ES:[BX][GTB_MORAL][GRP_VALUE]	; 7. モラル
	JNBE	NIGATE_HIKAKU_DAME			;
NIGATE_HIKAKU_OK:
	MOV	AX,1				; 比較結果 1=一番ダメ
	RET
NIGATE_HIKAKU_DAME:
	MOV	AX,0				; 比較結果 0=ふつう
	RET
NIGATE_HIKAKU	ENDP


; ****************************************************
;	売りたし
;	-I- DI : 内容表示テーブルアドレス
;	    DX : 売値
; ****************************************************

CALC_URITASHI	PROC	NEAR
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	U_PAY,DX		; 売値

	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

	ADDOV	V_OKANE[VAL_VALUE],U_PAY ; 売値

	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ
	RET
CALC_URITASHI	ENDP


; ****************************************************
;	買取り価格
;	-I- DI : アイテムアドレス
;	-O- DX : 売値
; ****************************************************

CALC_KAITORI	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,ES:[DI][ITM_PRICE]	; DX=値段
	SHR	DX,1			; ５０％
	RET
CALC_KAITORI	ENDP


; ****************************************************
;	敵から金と経験値を貰う
;
;	経験値 <- 経験値
;	お金   <- お金
;
;	-I- AX : 私（アドレス）
;	    BX : 敵（アドレス）
;	-O- AX : お金
;	    DX : 経験値
; ****************************************************

CALC_TK_UBAU	PROC	NEAR
	CALL	TEKIMIKATA_GET		; 敵味方ＧＥＴ

	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	LOAD_VALUE		; 内容表示パラメータＬＯＡＤ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_TK_GRP		; 敵・グラフテーブルアドレス
	MOV	SI,ADRS_TK_VAL		; 敵・内容表示テーブルアドレス
	MOV	BX,ADRS_TK_HOW		; 敵

	MOVX	KEIKEN,  ES:[BX][HED_LVL]		; レベル
	MOVX	VAL_GOLD,ES:[SI][VTB_OKANE][VAL_VALUE]	; 8. お金

	ADDOV	G_KEIKEN[GRP_VALMAX],KEIKEN	; 9. 経験値
	ADDOV	V_OKANE[VAL_VALUE],VAL_GOLD	; 8. お金

	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ
	MOV	BX,ADRS_VALUE		; 内容表示テーブルアドレス
	CALL	SAVE_VALUE		; 内容表示パラメータＳＡＶＥ

	MOV	AX,VAL_GOLD		; お金
	MOV	DX,KEIKEN		; 経験値
	RET
CALC_TK_UBAU	ENDP


; ****************************************************
;	病気の日次処理
;	病気ではないときの処理もしている
;	-I- AX : 私（アドレス）
; ****************************************************

CALC_BYOUKI	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス
	MOV	ADRS_VALUE,DI		; 内容表示テーブルアドレス
	MOV	CHAR_FLAG,DX		; キャラクターフラグ

	TEST	CHAR_FLAG,FLAGS_BYOUKI	;bit12 : 病気化
	JNZ	CALC_BYOUKI_BYOUKI	;
	JMP	CALC_BYOUKI_EXIT	;
CALC_BYOUKI_BYOUKI:

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	LOAD_GRAPH		; グラフパラメータＬＯＡＤ

	MOV	DMG_TAIRYOK,1		; 体力ダメージ
	MOV	DMG_WANRYOK,1		; 腕力ダメージ
	MOV	DMG_KONJYO,1		; 根性ダメージ
	MOV	DMG_HIROU,0		; 疲労ダメージ
	MOV	DMG_ANTHER,1		; その他ダメージ

	CMP	G_HIROU[GRP_VALUE],600	; 5. 疲労
	JB	CALC_BYOUKI_3		;	６００から根性と腕力と体力
	MOV	DMG_TAIRYOK,3		; 体力ダメージ
	MOV	DMG_WANRYOK,3		; 腕力ダメージ
	MOV	DMG_KONJYO,3		; 根性ダメージ
	MOV	DMG_ANTHER,3		; その他ダメージ
CALC_BYOUKI_3:

	SUBZ	G_TAIRYOK[GRP_VALUE],DMG_TAIRYOK		; 0. 体力
	MOVX	G_TAIRYOK[GRP_VALMAX],G_TAIRYOK[GRP_VALUE]	; 0. 体力
	SUBZ	G_WANRYOK[GRP_VALUE],DMG_WANRYOK		; 1. 腕力
	MOVX	G_WANRYOK[GRP_VALMAX],G_WANRYOK[GRP_VALUE]	; 1. 腕力
	SUBZ	G_KONJYO[GRP_VALUE],DMG_KONJYO			; 4. 根性
	MOVX	G_KONJYO[GRP_VALMAX],G_KONJYO[GRP_VALUE]	; 4. 根性
;*;	ADDS	G_HIROU[GRP_VALUE],DMG_HIROU			; 5. 疲労
;*;	MOVX	G_HIROU[GRP_VALMAX],G_HIROU[GRP_VALUE]		; 5. 疲労

	SUBZ	G_TIRYOKU[GRP_VALUE],DMG_ANTHER			; 2. 知力
	MOVX	G_TIRYOKU[GRP_VALMAX],G_TIRYOKU[GRP_VALUE]	; 2. 知力
	SUBZ	G_KIHIN[GRP_VALUE],DMG_ANTHER			; 3. 気品
	MOVX	G_KIHIN[GRP_VALMAX],G_KIHIN[GRP_VALUE]		; 3. 気品
	SUBZ	G_IROKE[GRP_VALUE],DMG_ANTHER			; 6. 色気
	MOVX	G_IROKE[GRP_VALMAX],G_IROKE[GRP_VALUE]		; 6. 色気

	CALL	CHK_GRAPH		; グラフパラメータ整合チェック

	MOV	BX,ADRS_GRAPH		; グラフテーブルアドレス
	CALL	SAVE_GRAPH		; グラフパラメータＳＡＶＥ

	MOV	STG_WRTF1,0			; 変動グラフ
	MOV 	STG_AD_WRTF1,OFFSET G_TAIRYOK	; 0. 体力
	MOV	STG_WRTF2,1			; 変動グラフ
	MOV	STG_AD_WRTF2,OFFSET G_WANRYOK	; 1. 腕力
	MOV	STG_WRTF3,2			; 変動グラフ
	MOV	STG_AD_WRTF3,OFFSET G_TIRYOKU	; 2. 知力
	MOV	STG_WRTF4,3			; 変動グラフ
	MOV	STG_AD_WRTF4,OFFSET G_KIHIN	; 3. 気品
	MOV	STG_WRTF5,4			; 変動グラフ
	MOV	STG_AD_WRTF3,OFFSET G_KONJYO	; 4. 根性

	CALL	CHK_GRP_DISP		; グラフ表示

	MOV	STG_WRTF1,5			; 変動グラフ
	MOV 	STG_AD_WRTF1,OFFSET G_HIROU	; 5. 疲労
	MOV	STG_WRTF2,6			; 変動グラフ
	MOV	STG_AD_WRTF2,OFFSET G_IROKE	; 6. 色気
	MOV	STG_WRTF3,OFFF			; 変動グラフ

	CALL	CHK_GRP_DISP		; グラフ表示

	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_GRAP_GO		; 24=グラフ整合
	MOV	AX,ADRS_HOW		; 人物
	CALL	CALC_HEAD_GO		; 14=ヘッダー整合

CALC_BYOUKI_EXIT:
	RET
CALC_BYOUKI	ENDP


; ****************************************************
;	とにかく疲労回復
;	-I- AX : 誰か（アドレス）
;	    DX : 疲労回復ポイント
; ****************************************************

CALC_KAIFUKU	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	P_MY,DX			; 疲労回復ポイント

	; グラフテーブル

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_GR_OFS]	; BX=グラフテーブルオフセット

	; 疲労から減算する。

	MOV	DX,P_MY					; 私
	SUBZ	ES:[BX][GTB_HIROU][GRP_VALUE],DX	; 5. 疲労
	SUBZ	ES:[BX][GTB_HIROU][GRP_VALMAX],DX	; 5. 疲労（最大値）

	MOVX	G_HIROU[GRP_VALUE],ES:[BX][GTB_HIROU][GRP_VALUE] ; 5. 疲労

	MOV	STG_WRTF1,5			; 変動グラフ１
	MOV 	STG_AD_WRTF1,OFFSET G_HIROU	; 5. 疲労
	MOV	STG_WRTF2,OFFF		; 変動グラフ２
	MOV	STG_WRTF3,OFFF		; 変動グラフ３
	MOV	STG_WRTF4,OFFF		; 変動グラフ４
	MOV	STG_WRTF5,OFFF		; 変動グラフ５

	CALL	CHK_GRP_2DSP		; グラフ表示２

	RET
CALC_KAIFUKU	ENDP


; ****************************************************
;	収穫祭等の評価
;	-I- AX : 誰か（アドレス）
;	    DX : 賞の種類
;		1=「太陽の神賞」
;		2=「月の神賞」
;		3=「星の神賞」
;		4=「ミス王国」
;		5=武闘会・優勝
;		6=武闘会・準優勝
;		7=アルバイトパーフェクト賞
;		8=称号をもらうとき
;	    CX : 賞のポイント
; ****************************************************

CALC_S_HYOUKA	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	SHOWR_ATTR,DX		; 賞の種類
	MOV	SHOWR_POINT,CX		; 賞のポイント

	MOV	DX,SHOWR_ATTR		; 賞の種類
	CMP	DX,4
	JLE	CALC_S_HYOUKA_S01
	CMP	DX,5
	JE	CALC_S_HYOUKA_S05
	CMP	DX,6
	JE	CALC_S_HYOUKA_S06

	CMP	DX,7
	JE	CALC_S_HYOUKA_S07
	CMP	DX,8
	JE	CALC_S_HYOUKA_S08

	JMP	CALC_S_HYOUKA_EXIT
CALC_S_HYOUKA_S01:			;
	CALL	MISS_S_DEV		; ミスコン評価ポイント
	JMP	CALC_S_HYOUKA_SET	;
CALC_S_HYOUKA_S05:			; 5=武闘会・優勝
	MOV	P_MY,80			; 加算される評価＝８０
	JMP	CALC_S_HYOUKA_SET	;
CALC_S_HYOUKA_S06:			; 6=武闘会・準優勝
	MOV	P_MY,50			; 加算される評価＝５０
	JMP	CALC_S_HYOUKA_SET	;

CALC_S_HYOUKA_S07:
	MOV	P_MY,1			; 7=アルバイトパーフェクト賞
	JMP	CALC_S_HYOUKA_SET	;
CALC_S_HYOUKA_S08:
	MOV	P_MY,10			; 8=称号をもらうとき
	JMP	CALC_S_HYOUKA_SET	;

CALC_S_HYOUKA_SET:
	MOV	AX,ADRS_HOW		; 人物
	MOV	DX,P_MY			; 加算される評価
	CALL	CALC_H_HYOUKA		; 評価処理
CALC_S_HYOUKA_EXIT:
	RET
CALC_S_HYOUKA	ENDP


; ****************************************************
;	装備・ＧＥＴ
;	-I- AX : 誰か（アドレス）
;	    BX : 装備種別 0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾
;	    CX : アイテムテーブルアドレス
;	-O- AX : 0=正常,1=装備していない
;	    DX : アイテムアドレス(0FFFFH=無し)
; ****************************************************

CALC_SOUBI_GET	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	SOUBI_ATR,BX		; 装備
	MOV	ADRS_ITEM,CX		; アイテムテーブルアドレス

	; 装備リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	BX,ES:[DI][HED_LST_SB]	; BX=装備リスト

	MOV	SI,SOUBI_ATR		; 装備
	SHL	SI,1			;
	SHL	SI,1			; * 4
	MOV	DX,ES:[BX][SI]		; アイテム種別
	MOV	AX,ES:[BX][SI][2]	; レコード番号
	CMP	DX,OFFF			; 無し
	JE	CALC_SOUBI_GET_NONE	;

	MOV	BX,DX			; アイテム種別
	CALL	ITEM_ADRS_CLC		; アイテムアドレス
					; DX=アイテムアドレス
	MOV	AX,0			; 0=正常
	RET
CALC_SOUBI_GET_NONE:
	MOV	DX,OFFF			; アイテムアドレス(0FFFFH=無し)
	MOV	AX,1			; 1=装備していない
	RET
CALC_SOUBI_GET	ENDP


; ****************************************************
;	武者修行の日次処理
;	-I- AX : 私の娘アドレス
; ****************************************************

CALC_MUSYA_UP	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物

	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	CALL	HED_ADRS_P		; ヘッダーからテーブルアドレス計算
	MOV	ADRS_GRAPH,SI		; グラフテーブルアドレス

	ADDS	ES:[SI][GTB_TAIRYOK][GRP_VALUE],1	; 0. 体力
	MOVX ES:[SI][GTB_TAIRYOK][GRP_VALMAX],ES:[SI][GTB_TAIRYOK][GRP_VALUE]
	ADDS	ES:[SI][GTB_HIROU][GRP_VALUE],1		; 5. 疲労
	MOVX ES:[SI][GTB_HIROU][GRP_VALMAX],ES:[SI][GTB_HIROU][GRP_VALUE]

	CALL	CALC_HP_FUKKATU		; ＨＰセット
	CALL	CALC_HEAD_GO		; ヘッダー整合
	RET
CALC_MUSYA_UP	ENDP



; ****************************************************
;	ミスコン評価ポイント
;	-I- SHOWR_POINT : 賞のポイント
;	-O- P_MY        : 加算される評価
; ****************************************************

MISS_S_DEV	PROC	NEAR
	MOV	DX,0			;
	MOV	AX,SHOWR_POINT		; 賞のポイント
	MOV	BX,10			;
	DIV	BX			; ÷１０
	MOV	P_MY,AX			; 加算される評価
	RET
MISS_S_DEV	ENDP


; ****************************************************
;	ヘッダーパラメータＬＯＡＤ
;	-I- BX : パラメータのアドレス
; ****************************************************

LOAD_HED_PAR	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOVX	H_SHOGO,ES:[BX][HED_SHOGO]	; 称号
	MOVX	H_HP,ES:[BX][HED_HP]		; ＨＰ
	MOVX	H_LVL,ES:[BX][HED_LVL]		; レベル
	MOVX	H_FLAGS,ES:[BX][HED_FLAGS]	; フラグ
	RET
LOAD_HED_PAR	ENDP


; ****************************************************
;	敵・ヘッダーパラメータＬＯＡＤ
;	-I- BX : パラメータのアドレス
; ****************************************************

LOAD_T_HED_PAR	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOVX	HS_SHOGO,ES:[BX][HED_SHOGO]	; 称号
	MOVX	HS_HP,ES:[BX][HED_HP]		; ＨＰ
	MOVX	HS_LVL,ES:[BX][HED_LVL]		; レベル
	MOVX	HS_FLAGS,ES:[BX][HED_FLAGS]	; フラグ
	RET
LOAD_T_HED_PAR	ENDP


; ****************************************************
;	ヘッダーパラメータＳＡＶＥ
;	-I- BX : パラメータのアドレス
; ****************************************************

SAVE_HED_PAR	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOVX	ES:[BX][HED_SHOGO],H_SHOGO	; 称号
	MOVX	ES:[BX][HED_HP],H_HP		; ＨＰ
	MOVX	ES:[BX][HED_LVL],H_LVL		; レベル
	MOVX	ES:[BX][HED_FLAGS],H_FLAGS	; フラグ
	RET
SAVE_HED_PAR	ENDP


; ****************************************************
;	ヘッダーからテーブルアドレス計算
;	-I- BX : 誰か（アドレス）
;	-O- ES : ＷＩＮＤＯＷＳセグメント
;	    SI : グラフテーブルアドレス
;	    DI : 内容表示テーブルアドレス
;	    DX : フラグ
; ****************************************************

HED_ADRS_P	PROC	NEAR
	PUSH	AX
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ES:[BX][HED_VA_OFS]	; DI=内容表示テーブル
	MOV	SI,ES:[BX][HED_GR_OFS]	; SI=グラフテーブル
	MOV	DX,ES:[BX][HED_FLAGS]	; フラグ
	POP	AX
	RET
HED_ADRS_P	ENDP


; ****************************************************
;	種別とレコード番号からアイテムアドレス
;	-I- BX : 種別
;	    AX : レコード番号
;	    ADRS_ITEM : アイテムテーブルアドレス
;	-O- DX : アイテムアドレス
; ****************************************************

ITEM_ADRS_CLC	PROC	NEAR
	SHL	BX,1				;
	SHL	BX,1				; 4 byte pointer.
	ADD	BX,ADRS_ITEM			; アイテムテーブルアドレス
	MOV	SI,ES:[BX]			; CX=種別のアイテムテーブル先頭

	MOV	BX,ITM_NEXT			; 次のアイテム
	MUL	BX				; AX = AX * BX
	ADD	AX,SI				;
	MOV	DX,AX				; アイテムアドレス
	RET
ITEM_ADRS_CLC	ENDP


; ****************************************************
;	グラフパラメータからグラフ名前検索
;	-I- DX      : グラフ名前
;	-O- RECADRS : レコードアドレス
;	    BX      : レコードアドレス(=RECADRS)
;	    RECNO   : レコードＮＯ
;	    AX      : 0=正常,1=該当なし
; ****************************************************

KIND_CHK_GRP	PROC	NEAR
	MOV	RECNO,0			; レコードＮＯ
	MOV	BX,OFFSET G_TABLE_TOP	; グラフパラメータ
	MOV	CX,G_TABLE_CNT		; グラフパラメータ数
KIND_CHK_GRP_LOOP:
	CMP	DX,DS:[BX][GRP_NAME]	; グラフ名前
	JE	KIND_CHK_GRP_SCH	;

	INC	RECNO			; レコードＮＯ
	ADD	BX,GRP_NEXT		; 次のグラフ
	LOOP	KIND_CHK_GRP_LOOP	;

	JMP	KIND_CHK_GRP_NONE	;

KIND_CHK_GRP_SCH:
	MOV	RECADRS,BX		; レコードアドレス
	MOV	AX,0			; 0=正常
	RET
KIND_CHK_GRP_NONE:
	MOV	RECADRS,BX		; レコードアドレス
	MOV	AX,1			; 1=該当なし
	RET
KIND_CHK_GRP	ENDP



; ****************************************************
;	グラフパラメータ整合チェック
; ****************************************************

CHK_GRAPH	PROC	NEAR
	MOV	BX,OFFSET G_TABLE_TOP	; グラフパラメータ
	MOV	CX,2			;
CHK_GRAPH_LOOP0:
	PUSH	CX			;
	MOV	CX,G_TABLE_CNT		; グラフパラメータ数
CHK_GRAPH_LOOP:
	MOV	AX,8000H+4000H		;
	CMP	DS:[BX][GRP_VALUE],AX	; グラフ数値
	JB	CHK_GRAPH_21		;
	MOV	DS:[BX][GRP_VALUE],WORD PTR 0	; グラフ数値
CHK_GRAPH_21:
	MOV	AX,8000H		;
	CMP	DS:[BX][GRP_VALUE],AX	; グラフ数値
	JB	CHK_GRAPH_2		;
	MOV	DS:[BX][GRP_VALUE],32767 ; グラフ数値
CHK_GRAPH_2:

	MOV	AX,8000H+4000H		;
	CMP	DS:[BX][GRP_VALMAX],AX	; グラフ最大
	JB	CHK_GRAPH_31		;
	MOV	DS:[BX][GRP_VALMAX],WORD PTR 0	; グラフ最大
CHK_GRAPH_31:
	MOV	AX,8000H		;
	CMP	DS:[BX][GRP_VALMAX],AX	; グラフ最大
	JB	CHK_GRAPH_3		;
	MOV	DS:[BX][GRP_VALMAX],32767 ; グラフ最大
CHK_GRAPH_3:
	MOV	AX,DS:[BX][GRP_VALMAX]	; グラフ最大
	CMP	DS:[BX][GRP_VALUE],AX	; グラフ数値
	JE	CHK_GRAPH_4		;
	MOV	DS:[BX][GRP_VALUE],AX	; グラフ数値
CHK_GRAPH_4:
	ADD	BX,GRP_NEXT		; 次のグラフ
	LOOP	CHK_GRAPH_LOOP
	POP	CX

	MOV	BX,OFFSET GS_TABLE_TOP	; グラフパラメータ
	LOOP	CHK_GRAPH_LOOP0

	RET
CHK_GRAPH	ENDP


; ****************************************************
;	内容表示パラメータＬＯＡＤ
;	-I- BX : パラメータのアドレス
; ****************************************************

LOAD_VALUE	PROC	NEAR
	MOV	CX,V_TABLE_BYTE		; 内容表示パラメータバイト数

	PUSH	DS			;
	MOV	SI,BX			; データテーブルアドレス
	MOV	DI,OFFSET V_TABLE_TOP	; 内容表示パラメータ
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	AX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DS,AX			;
	REP	MOVSB			;
	POP	DS			;

	RET
LOAD_VALUE	ENDP


; ****************************************************
;	内容表示パラメータＳＡＶＥ
;	-I- BX : パラメータのアドレス
; ****************************************************

SAVE_VALUE	PROC	NEAR
	MOV	CX,V_TABLE_BYTE		; 内容表示パラメータバイト数

	MOV	SI,OFFSET V_TABLE_TOP	; 内容表示パラメータ
	MOV	DI,BX			; データテーブルアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	REP	MOVSB			;

	RET
SAVE_VALUE	ENDP


; ****************************************************
;	グラフパラメータＬＯＡＤ
;	-I- BX : パラメータのアドレス
; ****************************************************

LOAD_GRAPH	PROC	NEAR
	MOV	CX,G_TABLE_BYTE		; グラフパラメータバイト数

	PUSH	DS			;
	MOV	SI,BX			; データテーブルアドレス
	MOV	DI,OFFSET G_TABLE_TOP	; グラフパラメータ
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	AX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DS,AX			;
	REP	MOVSB			;
	POP	DS			;

	RET
LOAD_GRAPH	ENDP


; ****************************************************
;	グラフパラメータＳＡＶＥ
;	-I- BX : パラメータのアドレス
; ****************************************************

SAVE_GRAPH	PROC	NEAR
	MOV	CX,G_TABLE_BYTE		; グラフパラメータバイト数

	MOV	SI,OFFSET G_TABLE_TOP	; グラフパラメータ
	MOV	DI,BX			; データテーブルアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	REP	MOVSB			;

	RET
SAVE_GRAPH	ENDP


; ****************************************************
;	敵・グラフパラメータＬＯＡＤ
;	-I- BX : パラメータのアドレス
; ****************************************************

LOAD_T_GRAPH	PROC	NEAR
	MOV	CX,GS_TABLE_BYTE	; グラフパラメータバイト数

	PUSH	DS			;
	MOV	SI,BX			; データテーブルアドレス
	MOV	DI,OFFSET GS_TABLE_TOP	; グラフパラメータ
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	AX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DS,AX			;
	REP	MOVSB			;
	POP	DS			;

	RET
LOAD_T_GRAPH	ENDP


; ****************************************************
;	敵・グラフパラメータＳＡＶＥ
;	-I- BX : パラメータのアドレス
; ****************************************************

SAVE_T_GRAPH	PROC	NEAR
	MOV	CX,GS_TABLE_BYTE	; グラフパラメータバイト数

	MOV	SI,OFFSET GS_TABLE_TOP	; グラフパラメータ
	MOV	DI,BX			; データテーブルアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	REP	MOVSB			;

	RET
SAVE_T_GRAPH	ENDP


; ****************************************************
;	行いパラメータＬＯＡＤ
;	-I- BX : パラメータのアドレス
; ****************************************************

LOAD_WORKS	PROC	NEAR
	MOV	CX,U_TABLE_BYTE		; 行いパラメータバイト数

	PUSH	DS			;
	MOV	SI,BX			; データテーブルアドレス
	MOV	DI,OFFSET U_TABLE_TOP	; 行いパラメータ
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	AX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DS,AX			;
	REP	MOVSB			;
	POP	DS			;

	RET
LOAD_WORKS	ENDP


; ****************************************************
;	アイテムパラメータＬＯＡＤ
;	-I- BX : アイテムパラメータのアドレス
; ****************************************************

LOAD_ITEM	PROC	NEAR
	MOV	CX,I_TABLE_BYTE		; アイテムパラメータバイト数

	PUSH	DS			;
	MOV	SI,BX			; データテーブルアドレス
	MOV	DI,OFFSET I_TABLE_TOP	; アイテムパラメータ
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	AX,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DS,AX			;
	REP	MOVSB			;
	POP	DS			;

	RET
LOAD_ITEM	ENDP


R_SEG	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	S_FUNC			; 計算ファンクション
S_FUNC	DW	0		; 計算ファンクション

EXTRN	WDGNO:WORD		; 横グラフ番号
EXTRN	WDVAL:WORD		; 表示値

VIEW_STOP	DW	0	; 表示停止スイッチ=1
MODE_SW		DW	0	; モードスイッチ 0=ノーマル,1=マッハ

ADRS_ENVIR	DW	0	; 環境テーブル
ADRS_HOW	DW	0	; 人物
ADRS_ITEM	DW	0	; アイテム

ADRS_TK_HOW	DW	0	; 敵

VAL_ATTR	DW	0	; 種別
VAL_RECNO	DW	0	; レコードＮＯ

MY_MONEY	DW	0	; 私のお金
PRICE		DW	0	; お値段
HYOHKA		DW	0	; 評価

ADRS_WORKS	DW	0	; 行いパラメータのアドレス

ADRS_GRAPH	DW	0	; グラフテーブルアドレス
ADRS_VALUE	DW	0	; 内容表示テーブルアドレス

ADRS_TK_GRP	DW	0	; 敵・グラフテーブルアドレス
ADRS_TK_VAL	DW	0	; 敵・内容表示テーブルアドレス

CHAR_FLAG	DW	0	; キャラクターフラグ

VAL_GOLD	DW	0	; お金
NISSU		DW	0	; 日数

RECNO		DW	0	; レコードＮＯ
RECADRS		DW	0	; レコードアドレス

KIND_VAL	DW	0	; 修正能力値
PAR_HIROU	DW	0	; 疲労

WORKING_RANK	DW	0	; 仕事のランク
WORKING_KIND	DW	0	; 職業


DMG_MY		DW	0	; 私のダメージ
DMG_TK		DW	0	; 敵のダメージ
DMG_MY_MP	DW	0	; 私の魔法ダメージ
DMG_TK_MP	DW	0	; 敵の魔法ダメージ

P_MY		DW	0	; 私
P_TK		DW	0	; 敵
P_MY2		DW	0	; 私
P_TK2		DW	0	; 敵

SOUBI_ATR	DW	0	; 装備　0=武器, 1=兜, 2=鎧, 3=盾


OH_KAIKEN_MAX	DW	6		; 王様会見の段階数
OH_KAIKEN_KIHIN_LVL	LABEL	WORD	; 王様会見の気品基準レベル
		DW	40  ;20		; 1:衛兵までＯＫ
		DW	60  ;40		; 2:近衛隊長までＯＫ
		DW	120 ;60		; 3:侍従までＯＫ
		DW	240 ;80		; 4:侍従長までＯＫ
		DW	400 ;150	; 5:王妃までＯＫ
		DW	600 ;220	; 6:王様までＯＫ


HYOUKA_BORDER_L	DW	10	; 最下位年齢
HYOUKA_BORDER_H	DW	17	; 最上位年齢
HYOUKA_BDR_LINE	DW	0	; 評価ボーダーライン
HYOUKA_BORDER	LABEL	WORD	; 評価ボーダーライン・テーブル
		DW	300/10	; １年目　１０才
		DW	600/10	; ２年目　１１才
		DW	900/10	; ３年目　１２才
		DW	1200/10	; ４年目　１３才
		DW	1500/10	; ５年目　１４才
		DW	1800/10	; ６年目　１５才
		DW	2100/10	; ７年目　１６才
		DW	2400/10	; ８年目　１７才

HIROU_LEVEL_MAX	DW	4	; 疲労レベル数
HIROU_LEVEL	LABEL	WORD	; 疲労レベル
		DW	30	; 1=疲れ無し
		DW	60	; 2=ちょっと
		DW	120	; 3=かなり
		DW	150	; 4=重傷

KIHIN_LEVEL_MAX	DW	6	; 気品レベル数
KIHIN_LEVEL	LABEL	WORD	; 気品レベル
		DW	30	; 1=
		DW	60	; 2=
		DW	120	; 3=
		DW	150	; 4=
		DW	180	; 5=
		DW	210	; 6=

KIHIN_LVL2_MAX	DW	3	; 気品レベル２数
KIHIN_LVL2	LABEL	WORD	; 気品レベル２
		DW	30	; 1=
		DW	69	; 2=
		DW	99	; 3=

TOHJO_HOW_TBL	DW	0	; 登場人物テーブル
TOHJO_HOW_PNT	DW	0	; 登場人物テーブルポインタ
BUMON_NUM	DW	0	; ミスコン1=気品部門,2=プロポー部門,3=色気部門

YOSOU_TBL	LABEL	WORD	; 予想テーブル
YOSOU_HONME	DW	0	; 0:本命
YOSOU_TAIKO	DW	0	; 1:対抗
YOSOU_ANA	DW	0	; 2:穴
		DW	0	; 3
		DW	0	; 4
		DW	0	; 5
		DW	0	; 6
		DW	0	; 7
		DW	0	; 8
		DW	0	; 9

YOSOU_TBL_VAL	LABEL	WORD	; 予想テーブル/値
YOSOU_HONME_V	DW	0	; 0:本命
YOSOU_TAIKO_V	DW	0	; 1:対抗
YOSOU_ANA_V	DW	0	; 2:穴
		DW	0	; 3
		DW	0	; 4
		DW	0	; 5
		DW	0	; 6
		DW	0	; 7
		DW	0	; 8
		DW	0	; 9

STG_TABLE	LABEL	WORD	; 変動グラフテーブル
STG_WRTF1	DW	0	; 変動グラフ１
STG_WRTF2	DW	0	; 変動グラフ２
STG_WRTF3	DW	0	; 変動グラフ３
STG_WRTF4	DW	0	; 変動グラフ４
STG_WRTF5	DW	0	; 変動グラフ５

STG_AD_TABLE	LABEL	WORD	; 変動グラフアドレステーブル
STG_AD_WRTF1	DW	0	; 変動グラフアドレス１
STG_AD_WRTF2	DW	0	; 変動グラフアドレス２
STG_AD_WRTF3	DW	0	; 変動グラフアドレス３
STG_AD_WRTF4	DW	0	; 変動グラフアドレス４
STG_AD_WRTF5	DW	0	; 変動グラフアドレス５


;	ヘッダーパラメータ

H_SHOGO		DW	0		; 称号
H_HP		DW	0		; ＨＰ
H_LVL		DW	0		; レベル
H_FLAGS		DW	0		; フラグ

;	敵ヘッダーパラメータ

HS_SHOGO	DW	0		; 称号
HS_HP		DW	0		; ＨＰ
HS_LVL		DW	0		; レベル
HS_FLAGS	DW	0		; フラグ

;	内容表示パラメータ・テーブル

V_TABLE_CNT	DW	9			; 内容表示パラメータ数
V_TABLE_BYTE	DW	VAL_NEXT*9		; 内容表示パラメータバイト数
V_TABLE_TOP	LABEL	BYTE			; 内容表示パラメータ
V_SEIBETU	DW	VAL_NEXT/2 DUP (0)	; 0. 性別
V_SEIZA		DW	VAL_NEXT/2 DUP (0)	; 1. 星座
V_KETUEKI	DW	VAL_NEXT/2 DUP (0)	; 2. 血液型
V_TANJOBI	DW	VAL_NEXT/2 DUP (0)	; 3. 誕生日
V_NENREI	DW	VAL_NEXT/2 DUP (0)	; 4. 年齢
V_SINCHO	DW	VAL_NEXT/2 DUP (0)	; 5. 身長
V_TAIJU		DW	VAL_NEXT/2 DUP (0)	; 6. 体重
V_PROPRT	DW	VAL_NEXT/2 DUP (0)	; 7. プロポー
V_OKANE		DW	VAL_NEXT/2 DUP (0)	; 8. お金


;	グラフパラメータ・テーブル

G_TABLE_CNT	DW	18			; グラフパラメータ数
G_TABLE_BYTE	DW	GRP_NEXT*18		; グラフパラメータバイト数
G_TABLE_TOP	LABEL	BYTE			; グラフパラメータ
G_TAIRYOK	DW	GRP_NEXT/2 DUP (0)	; 0. 体力
G_WANRYOK	DW	GRP_NEXT/2 DUP (0)	; 1. 腕力
G_TIRYOKU	DW	GRP_NEXT/2 DUP (0)	; 2. 知力
G_KIHIN		DW	GRP_NEXT/2 DUP (0)	; 3. 気品
G_KONJYO	DW	GRP_NEXT/2 DUP (0)	; 4. 根性
G_HIROU		DW	GRP_NEXT/2 DUP (0)	; 5. 疲労
G_IROKE		DW	GRP_NEXT/2 DUP (0)	; 6. 色気
G_MORAL		DW	GRP_NEXT/2 DUP (0)	; 7. モラル
G_HYOKA		DW	GRP_NEXT/2 DUP (0)	; 8. 評価
G_KEIKEN	DW	GRP_NEXT/2 DUP (0)	; 9. 経験値
G_SENTOH	DW	GRP_NEXT/2 DUP (0)	;10. 戦闘技術
G_SUBAYA	DW	GRP_NEXT/2 DUP (0)	;11. 素早さ
G_SOKOH		DW	GRP_NEXT/2 DUP (0)	;12. 装甲強度
G_KOUGEK	DW	GRP_NEXT/2 DUP (0)	;13. 攻撃増強
G_HP		DW	GRP_NEXT/2 DUP (0)	;14. ＨＰ
G_MP		DW	GRP_NEXT/2 DUP (0)	;15. ＭＰ
G_ALPHA		DW	GRP_NEXT/2 DUP (0)	;16. ＋α
G_WAR		DW	GRP_NEXT/2 DUP (0)	;17. 好戦度


;	敵グラフパラメータ・テーブル

GS_TABLE_CNT	DW	18			; グラフパラメータ数
GS_TABLE_BYTE	DW	GRP_NEXT*18		; グラフパラメータバイト数
GS_TABLE_TOP	LABEL	BYTE			; グラフパラメータ
GS_TAIRYOK	DW	GRP_NEXT/2 DUP (0)	; 0. 体力
GS_WANRYOK	DW	GRP_NEXT/2 DUP (0)	; 1. 腕力
GS_TIRYOKU	DW	GRP_NEXT/2 DUP (0)	; 2. 知力
GS_KIHIN	DW	GRP_NEXT/2 DUP (0)	; 3. 気品
GS_KONJYO	DW	GRP_NEXT/2 DUP (0)	; 4. 根性
GS_HIROU	DW	GRP_NEXT/2 DUP (0)	; 5. 疲労
GS_IROKE	DW	GRP_NEXT/2 DUP (0)	; 6. 色気
GS_MORAL	DW	GRP_NEXT/2 DUP (0)	; 7. モラル
GS_HYOKA	DW	GRP_NEXT/2 DUP (0)	; 8. 評価
GS_KEIKEN	DW	GRP_NEXT/2 DUP (0)	; 9. 経験値
GS_SENTOH	DW	GRP_NEXT/2 DUP (0)	;10. 戦闘技術
GS_SUBAYA	DW	GRP_NEXT/2 DUP (0)	;11. 素早さ
GS_SOKOH	DW	GRP_NEXT/2 DUP (0)	;12. 装甲強度
GS_KOUGEK	DW	GRP_NEXT/2 DUP (0)	;13. 攻撃増強
GS_HP		DW	GRP_NEXT/2 DUP (0)	;14. ＨＰ
GS_MP		DW	GRP_NEXT/2 DUP (0)	;15. ＭＰ
GS_ALPHA	DW	GRP_NEXT/2 DUP (0)	;16. ＋α
GS_WAR		DW	GRP_NEXT/2 DUP (0)	;17. 好戦度


;	行いパラメータ・テーブル

U_TABLE_BYTE	DW	15*2	; 行いパラメータバイト数
U_TABLE_TOP	LABEL	WORD	; 行いパラメータ
U_NAME		DW	0	; 0.仕事名
U_PAY		DW	0	; 1.バイト料
U_KIND		DW	0	; 2.修正能力
U_KKA1		DW	0	; 3.効果１
U_VAL1		DW	0	; 4.加減値
U_KKA2		DW	0	; 5.効果２
U_VAL2		DW	0	; 6.加減値
U_KKA3		DW	0	; 7.効果３
U_VAL3		DW	0	; 8.加減値
U_KKA4		DW	0	; 9.効果４
U_VAL4		DW	0	; 10.加減値
U_KKA5		DW	0	; 11.効果５
U_VAL5		DW	0	; 12.加減値
U_AGE		DW	0	; 13.年齢制限
U_HELP		DW	0	; 14.説明


;	アイテムパラメータ・テーブル

I_TABLE_BYTE	DW	9*2	; アイテムパラメータバイト数
I_TABLE_TOP	LABEL	WORD	; アイテムパラメータ
I_NAME		DW	0	; 0.ｱｲﾃﾑ名
I_PRICE		DW	0	; 1.値段
I_KKA1		DW	0	; 2.効果１
I_VAL1		DW	0	; 3.加減値
I_KKA2		DW	0	; 4.効果２
I_VAL2		DW	0	; 5.加減値
I_KKA3		DW	0	; 6.効果３
I_VAL3		DW	0	; 7.加減値
I_HELP		DW	0	; 8.説明

NUM		DW	0	; 番号
NENREY		DW	0	; 年齢
RAND		DW	0	; 乱数
KEIKEN		DW	0	; 経験値
LEV		DW	0	; レベル
WMODE		DW	0	; モード
MP_SHOUHI	DW	0	; 消費ＭＰ
W_POINT		DW	0	; 比較ポイント
FLAG_KONJO	DW	0	; 根性を除くフラグ=1
KONJYO		DW	0	; 根性

KIHIN_LEV1	DW	0	; 気品レベル１
KIHIN_LEV2	DW	0	; 気品レベル２

SHOWR_ATTR	DW	0	; 賞の種類
SHOWR_POINT	DW	0	; 賞のポイント

V_SEIKOU	DW	0	; 成功率

DMG_TAIRYOK	DW	0	; 体力ダメージ
DMG_WANRYOK	DW	0	; 腕力ダメージ
DMG_KONJYO	DW	0	; 根性ダメージ
DMG_HIROU	DW	0	; 疲労ダメージ
DMG_ANTHER	DW	0	; その他ダメージ

LVL_SA		DW	0	; レベル差

UK_BLOOD	DW	0	; 血液型
UK_DMG		DW	0	; 受け側　ダメージ
UK_TAI		DW	0	; 受け側　体力
UK_HP		DW	0	; 受け側　ＨＰ

DATA	ENDS

	END
;
;	end of "R_KAIMON.ASM"
;
