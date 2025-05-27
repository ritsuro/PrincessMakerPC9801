; "PICTUER.ASM" PC_9801UV11 make by R.H 1990/05/28
;
;	「子育て」
;
;	絵の表示
;
;	フレーム関係
;
;PUBLIC	PT_FREAM		; メインフレーム
;PUBLIC	PT_FREAM_LEFT		; メインフレーム左
;PUBLIC	PT_FREAM_BATL		; バトルフレーム
;PUBLIC	PT_FREAM_BUGEI		; 武芸フレーム
;PUBLIC	PT_FREAM_MISCON		; ミスコンフレーム
;PUBLIC	PT_FREAM_BT_HYO		; 武闘会対戦表フレーム
;
;	バンク
;
;PUBLIC	PT_BANK29_LOAD		; バンク＃２から＃９までロード
;
;	バンク＃２
;
;PUBLIC	PT_LD_BTN		; ボタンＬＯＡＤ
;PUBLIC	PT_PUT_BTN_WK		; ボタン枠/ＰＵＴ
;PUBLIC	PT_PUT_BTN_ON		; ボタンＯＮ/ＰＵＴ
;PUBLIC	PT_PUT_BTN_OFF		; ボタンＯＦＦ/ＰＵＴ
;PUBLIC	PT_PUT_SBI_WK		; 装備枠/ＰＵＴ
;PUBLIC	PT_PUT_SBI_FT		; 装備蓋/ＰＵＴ
;
;	バンク＃３
;
;PUBLIC	PT_LD_KAZARI		; 飾りＬＯＡＤ
;PUBLIC	PT_K11			; 縁飾り１
;PUBLIC	PT_K12			; 縁飾り２
;PUBLIC	PT_K13			; 縁飾り３
;PUBLIC	PT_K14			; 縁飾り４
;PUBLIC	PT_KA1			; 縁飾りＡ１
;PUBLIC	PT_KA2			; 縁飾りＡ２
;PUBLIC	PT_KA3			; 縁飾りＡ３
;PUBLIC	PT_KA4			; 縁飾りＡ４
;PUBLIC	PT_KS1			; プチボタンＳ１
;PUBLIC	PT_KS2			; プチボタンＳ２
;
;	バンク＃４
;
;PUBLIC	PT_LD_CLEND		; カレンダＬＯＡＤ
;PUBLIC	PT_PUT_CLEND		; カレンダＰＵＴ
;PUBLIC	PT_PUT_PROPR		; プロポＰＵＴ
;PUBLIC	PT_PUT_PROP2		; プロポ高速ＰＵＴ
;PUBLIC	PT_PUT_GRAPH		; グラフＰＵＴ
;PUBLIC	PT_PUT_VALUE		; 数値表示ＰＵＴ
;PUBLIC	PT_PUT_VALBALANCE	; 数値バランス表示ＰＵＴ
;PUBLIC	PT_PUT_MONTH		; ｍｏｎｔｈ　ＰＵＴ
;PUBLIC	PT_PUT_WEEK		; ｗｅｅｋ　ＰＵＴ
;PUBLIC	PT_PUT_DAYS		; ｄａｙｓ　ＰＵＴ
;
;	バンク＃５
;
;PUBLIC	PT_PALET_LD		; パレットのロード
;PUBLIC	PT_PALET_ST		; パレットのセット
;PUBLIC	PT_PALET_PLD		; パレットのテーブルのみセット
;PUBLIC	PT_PALET_PLDP		; パレットのテーブルのみセット（テーブル指定）
;PUBLIC	PT_PALET_S_GM		; パレットのセット・ゲーム面
;
;	バンク＃６
;
;PUBLIC	PT_LD_SHOCK		; ショックＬＯＡＤ
;PUBLIC	PT_PUT_SHOCK		; ショックＰＵＴ
;
;	バンク＃７
;
;PUBLIC	PT_LD_ITEM		; アイテムＬＯＡＤ
;PUBLIC	PT_PUT_ITEM		; アイテムＰＵＴ
;
;	バンク＃８
;
;PUBLIC	PT_LD_SEIZA		; 星座ＬＯＡＤ
;PUBLIC	PT_PUT_SEIZA		; 星座ＰＵＴ
;PUBLIC	PT_PUT_BLOOD		; 血液型ＰＵＴ
;
;	バンク＃１０
;
;PUBLIC	PT_LD_MYGIRL_FACE	; 娘フェイスＬＯＡＤ
;PUBLIC	PT_PUT_MYGIRL_FACE	; 娘フェイスＰＵＴ
;
;	収穫祭関係
;
;PUBLIC	PT_SYUKAK_LD		; 収穫祭パターンロード
;PUBLIC	PT_SYUKAK_PUT		; 収穫祭パターンＰＵＴ
;PUBLIC	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
;
;	キャラクタ
;
;PUBLIC	PT_CHR_BASE		; キャラクタ・ベース
;PUBLIC	PT_CHR_DRESS		; 服変化（４シーズン）
;PUBLIC	PT_CHR_FACE		; 顔変化
;
;	ＢＧ（背景）
;
;PUBLIC	PT_CHR_BG_MAIN		; メインＢＧ－ＰＵＴ
;PUBLIC	PT_CHR_BG_BATLE		; バトルＢＧ－ＰＵＴ
;
;	相手関係
;
;PUBLIC	PT_TOHSHI		; 闘士ＰＵＴ
;PUBLIC	PT_SHIHAN		; 師範ＰＵＴ
;PUBLIC	PT_MNSTER		; モンスターＰＵＴ
;PUBLIC	PT_MISSCON		; ミスコンＰＵＴ
;PUBLIC	PT_MISSCON_LD		; ミスコンＬＯＡＤ ＯＮＬＹ
;PUBLIC	PT_MISSCON_PUT		; ミスコンＰＵＴ ＯＮＬＹ
;PUBLIC	PT_FACE			; フェイスＰＵＴ
;
;	武芸ＢＧ－ＰＵＴ
;
;PUBLIC	PT_CHR_BG_BUGEI		; 武芸ＢＧ－ＰＵＴ
;
;	武闘会ＢＧ－ＰＵＴ
;
;PUBLIC	PT_BUTOH_ALL_LOAD	; 武闘会関係全ロード
;PUBLIC	PT_CHR_BG_BUTOH		; 武闘会ＢＧ－ＰＵＴ
;PUBLIC	PT_FREAM_BUTOH		; 武闘会フレーム
;
;	武者修行ＢＧ－ＰＵＴ
;
;PUBLIC	PT_MUSYA_ALL_LOAD	; 武者修行関係全ロード
;PUBLIC	PT_FREAM_MUSYA		; 武者修行フレーム
;**PUBLIC PT_CHR_BG_MUSYA_LD	; 武者修行ＢＧ－ロード
;**PUBLIC PT_CHR_BG_MUSYA_PT	; 武者修行ＢＧ－ＰＵＴ
;
;	イベント関係
;
;PUBLIC	PT_MACHINOUWASA		; 町の評判
;PUBLIC	PT_EVENT_VIEW		; イベントビュー
;PUBLIC	PT_EVENT_VWWK		; 行いイベントビュー
;
;	落ち関係
;
;PUBLIC	PT_OCHI_LD		; オチの絵ロード
;PUBLIC	PT_OCHI_PUT		; オチの絵ＰＵＴ
;
;	バカンス関係
;
;PUBLIC	PT_BACA_LD		; バカンスの絵ロード
;PUBLIC	PT_BACA_PUT		; バカンスの絵ＰＵＴ
;
;	マウスの退避
;
;PUBLIC	MS_STOP			; マウスカーソル退避
;PUBLIC	MS_STOP_S		; マウスカーソル退避（強制ＯＦＦ）
;PUBLIC	MS_START		; マウスカーソル復帰
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC

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
	LOCAL	L2
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
	CALL	L2	
	ENDM

; ****************************************************
;	ＦＩＬＥ＿ＣＡＬＬ	＜ファイル名＞
;	ファイル名をコールすればロードするよ
; ****************************************************

FILE_CALL	MACRO	FNAME
	LOCAL	L1
DATA	SEGMENT	WORD PUBLIC	'DATA'
L1	DB	"&FNAME",0
DATA	ENDS
FNAME	PROC	NEAR
	MOV	SI,OFFSET L1
	CALL	RSEG_PATLDA
	RET
FNAME	ENDP
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
FAR_PATLDA	PROC	FAR
	EXTRN	PATLDA:NEAR
	CALL	PATLDA		; パーツ追加ロード
	RET
FAR_PATLDA	ENDP
FAR_PATBNK	PROC	FAR
	EXTRN	PATBNK:NEAR
	CALL	PATBNK			; バンクチェンジ
	RET
FAR_PATBNK	ENDP
CODE	ENDS
R_SEG2	SEGMENT	PUBLIC	'R_SEG2'
	ASSUME	CS:R_SEG2,DS:DATA
RSEG_PATLDA	PROC	NEAR
	CALL	FAR_PATLDA
	RET
RSEG_PATLDA	ENDP
RSEG_PATBNK	PROC	NEAR
	CALL	FAR_PATBNK
	RET
RSEG_PATBNK	ENDP
R_SEG2	ENDS

; ****************************************************
;	ＰＡＴ＿ＢＡＮＫ	＜バンク番号＞
;	パーツバンク切り替え
; ****************************************************

PAT_BANK	MACRO	NUM
	PUSH	DX
	MOV	DX,NUM			; バンク番号（０ー１）
	CALL	RSEG_PATBNK
	POP	DX
	ENDM

; ****************************************************
;	ＰＬＳＭＤ	＜圧縮モード＞
;	圧縮モード切り替え(0:通常,1:縦方向)
; ****************************************************

PLSMD	MACRO	MODES
	LOCAL	L2
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	PUSH	DX
	MOV	DX,MODES	; 圧縮モード(0:通常,1:縦方向)
	EXTRN	PLSMOD:NEAR
	CALL	PLSMOD		; 圧縮モード切り替え
	POP	DX
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
	CALL	L2
	ENDM

; ****************************************************
;	ＰＡＬＥＴ＿ＬＯＡＤ	＜パレットテーブル番号＞，＜パーツ番号＞
;	パレットロード
; ****************************************************

PALET_LOAD	MACRO	TBL,NUM
	LOCAL	L2
	MOV	CX,NUM		; パーツ番号
	MOV	BX,TBL		; パレットテーブル番号
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	PLTPAT:NEAR
	CALL	PLTPAT		; パーツバッファからパレットを取り出す
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
	CALL	L2
	ENDM

; ****************************************************
;	ＰＡＬＥＴ＿ＳＥＴ	＜パーツ番号＞
;	パレットセット
; ****************************************************

PALET_SET	MACRO	NUM
	LOCAL	L2
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	MOV	CX,NUM		; パーツ番号
	MOV	BX,0		; パレットテーブル番号
	EXTRN	PLTPAT:NEAR
	CALL	PLTPAT		; パーツバッファからパレットを取り出す
	MOV	BX,0		; パレットテーブル番号
	EXTRN	PLSET:NEAR
	CALL	PLSET		; パレットセット
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
	CALL	L2
	ENDM


; ****************************************************
;	ＰＡＴ＿ＰＵＴ		＜パーツ番号＞，Ｘ，Ｙ
;	パーツＰＵＴ
; ****************************************************

PAT_PUT		MACRO	NUM,XX,YY
	LOCAL	L2
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	MOV	AX,XX		;
	MOV	VRX,AX		; ＰＵＴＸ
	MOV	AX,YY		;
	MOV	VRY,AX		; ＰＵＴＹ
	MOV	CX,NUM		; パーツ番号
	EXTRN	PATPTF:NEAR
	CALL	PATPTF		; パーツＰＵＴオフセット指定
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
	CALL	L2
	ENDM


; ****************************************************
;	ＰＡＴ＿ＰＴＸ		＜パーツ番号＞，Ｘ，Ｙ
;	パーツＰＵＴ／パーツＰＵＴ座標指定
; ****************************************************

PAT_PTX		MACRO	NUM,XX,YY
	LOCAL	L2
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	MOV	AX,XX		;
	MOV	VRX,AX		; ＰＵＴＸ
	MOV	AX,YY		;
	MOV	VRY,AX		; ＰＵＴＹ
	MOV	CX,NUM		; パーツ番号
	EXTRN	PATPTX:NEAR
	CALL	PATPTX		; パーツＰＵＴ座標指定
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
	CALL	L2
	ENDM


JMPEQ	MACRO	LBL
	LOCAL	L1
	JNE	L1
	JMP	LBL
L1:
	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

MOVXB	MACRO	DEST,SOUR
	MOV	AL,SOUR
	MOV	DEST,AL
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


;	ＡＲＡＣＨＫ	＜Ｘmin＞，＜Ｙmin＞，
;				＜Ｘmax＞，＜Ｙmax＞，＜当たりラベル＞
;	入力	ＡＸ：Ｘ座標　，ＢＸ：Ｙ座標

ARACHK	MACRO	X1,Y1,X2,Y2,LBL
	LOCAL	L1
	CMP	AX,X1
	JB	L1
	CMP	AX,X2
	JNBE	L1
	CMP	BX,Y1
	JB	L1
	CMP	BX,Y2
	JNBE	L1
	JMP	LBL
L1:
	ENDM


;	ＡＲＡＣＨＫ２	＜Ｘ＞，＜Ｙ＞，＜当たりラベル＞
;	入力	ＡＸ：Ｘmin，ＢＸ：Ｙmin，ＣＸ：Ｘmax，ＤＸ：Ｙmax

ARACHK2	MACRO	XX,YY,LBL
	LOCAL	L1
	CMP	XX,AX
	JB	L1
	CMP	XX,CX
	JNBE	L1
	CMP	YY,BX
	JB	L1
	CMP	YY,DX
	JNBE	L1
	JMP	LBL
L1:
	ENDM

; ***********************************************
;	パーツファイルロード
; ***********************************************

R_SEG2	SEGMENT	PUBLIC	'R_SEG2'
	ASSUME	CS:R_SEG2,DS:DATA

FILE_CALL	FREAMU1			; 通常フレーム・左側
FILE_CALL	FREAMU2			; 通常フレーム・真中
FILE_CALL	FREAMD			; 通常フレーム・右側
FILE_CALL	FREAMB1			; バトルフレーム・左側
FILE_CALL	FREAMB2			; バトルフレーム・真中
FILE_CALL	FREAMB3			; バトルフレーム・右側
FILE_CALL	FREAMC1			; コンテストフレーム１
FILE_CALL	FREAMC2			; コンテストフレーム２
FILE_CALL	FREAMBT1		; 対戦表フレーム１
FILE_CALL	FREAMBT2		; 対戦表フレーム２
FILE_CALL	FREAMM1			; 武者修行フレーム・左側
FILE_CALL	FREAMM2			; 武者修行フレーム・真中
FILE_CALL	FREAMM3			; 武者修行フレーム・右側

FILE_CALL	PALET			; パレットデータ
FILE_CALL	BTN			; ボタン
FILE_CALL	BTNWK			; ボタン枠
FILE_CALL	BTNSCD			; スケジュールボタン
FILE_CALL	BTNSCW			; スケジュールボタン枠
FILE_CALL	KAZARI			; 飾りセット
FILE_CALL	CLEND			; カレンダ
FILE_CALL	PROPR			; プロポーション
FILE_CALL	PROP2			; プロポーション（横圧縮）
FILE_CALL	GRAPH			; グラフ
FILE_CALL	VALUE			; 数値表示
FILE_CALL	PAT6			; ショック
FILE_CALL	PAT7			; アイテム
FILE_CALL	PAT7WK			; 仕事アイテム
FILE_CALL	PAT8			; 星座
FILE_CALL	BLOOD			; 血液型
FILE_CALL	MONTH    		; 月
FILE_CALL	WEEK     		; 週
FILE_CALL	BIGNUM   		; 大きい数字

FILE_CALL	CB1			; キャラクタベース１
FILE_CALL	CB2			; キャラクタベース２
FILE_CALL	CB3			; キャラクタベース３
FILE_CALL	CB4			; キャラクタベース４
FILE_CALL	CB1D1			; 服１・春
FILE_CALL	CB1D2			; 服１・夏
FILE_CALL	CB1D3			; 服１・秋
FILE_CALL	CB1D4			; 服１・冬
FILE_CALL	CB2D1			; 服２・春
FILE_CALL	CB2D2			; 服２・夏
FILE_CALL	CB2D3			; 服２・秋
FILE_CALL	CB2D4			; 服２・冬
FILE_CALL	CB3D1			; 服３・春
FILE_CALL	CB3D2			; 服３・夏
FILE_CALL	CB3D3			; 服３・秋
FILE_CALL	CB3D4			; 服３・冬
FILE_CALL	CB4D1			; 服４・春
FILE_CALL	CB4D2			; 服４・夏
FILE_CALL	CB4D3			; 服４・秋
FILE_CALL	CB4D4			; 服４・冬
FILE_CALL	CB1F1			; 顔１－１
FILE_CALL	CB1F2			; 顔１－２
FILE_CALL	CB1F3			; 顔１－３
FILE_CALL	CB2F1			; 顔２－１
FILE_CALL	CB2F2			; 顔２－２
FILE_CALL	CB2F3			; 顔２－３
FILE_CALL	CB3F1			; 顔３－１
FILE_CALL	CB3F2			; 顔３－２
FILE_CALL	CB3F3			; 顔３－３
FILE_CALL	CB4F1			; 顔４－１
FILE_CALL	CB4F2			; 顔４－２
FILE_CALL	CB4F3			; 顔４－３

FILE_CALL	I4_01			; 王様との会見
FILE_CALL	I4_02			; 町の評判
FILE_CALL	I4_03			; ステータス確認
FILE_CALL	I4_04			; 娘と話す
FILE_CALL	I4_05			; 買物

; ***********************************************
;	フレーム関係
; ***********************************************

;	メインフレーム

FUNC	PPT_FREAM,PT_FREAM
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1

	CALL	FAR PTR PPT_FREAM_LEFT	; メインフレーム左

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMD			; 通常フレーム・右
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
FEND	PPT_FREAM

;	メインフレーム左

FUNC	PPT_FREAM_LEFT,PT_FREAM_LEFT
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMU1			; 通常フレーム・左側
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMU2			; 通常フレーム・真中
	CALL	PATTAN_PUT		; パターンＰＵＴ

	RET
FEND	PPT_FREAM_LEFT


;	バトルフレーム

FUNC	PPT_FREAM_BATL,PT_FREAM_BATL
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMB1			; バトルフレーム・左側
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMB2			; バトルフレーム・真中
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMB3			; バトルフレーム・右側
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
FEND	PPT_FREAM_BATL


;	武芸フレーム

FUNC	PPT_FREAM_BUGEI,PT_FREAM_BUGEI
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMB1			; バトルフレーム・左側
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMB2			; バトルフレーム・真中
	CALL	PATTAN_PUT		; パターンＰＵＴ

	RET
FEND	PPT_FREAM_BUGEI


;	ミスコンフレーム

FUNC	PPT_FREAM_MISCON,PT_FREAM_MISCON
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMC1			; コンテストフレーム１
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMC2			; コンテストフレーム２
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
FEND	PPT_FREAM_MISCON


;	武闘会対戦表フレーム

FUNC	PPT_FREAM_BT_HYO,PT_FREAM_BT_HYO
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMBT1		; 対戦表フレーム１
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMBT2		; 対戦表フレーム２
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
FEND	PPT_FREAM_BT_HYO


; ***********************************************
;	バンク
; ***********************************************

;	バンク＃２から＃９までロード

FUNC	PPT_BANK29_LOAD,PT_BANK29_LOAD
	CALL	FAR PTR PPT_LD_BTN	; ボタンＬＯＡＤ／バンク＃２
	CALL	FAR PTR PPT_LD_KAZARI	; 飾りＬＯＡＤ／バンク＃３
	CALL	FAR PTR PPT_LD_CLEND	; カレンダＬＯＡＤ／バンク＃４
	CALL	FAR PTR PPT_PALET_LD	; パレットのロード／バンク＃５
	CALL	FAR PTR PPT_LD_SHOCK	; ショックＬＯＡＤ／バンク＃６
	CALL	FAR PTR PPT_LD_ITEM	; アイテムＬＯＡＤ／バンク＃７
	CALL	FAR PTR PPT_LD_SEIZA	; 星座ＬＯＡＤ／バンク＃８
	RET
FEND	PPT_BANK29_LOAD



; ***********************************************
;	バンク＃２
;	ボタン
; ***********************************************

;	ボタンＬＯＡＤ

FUNC	PPT_LD_BTN,PT_LD_BTN
;*;	PRF	"LOAD #2"
	PAT_BANK	2		; ２＝ボタン
	CALL	FILE_INIT		; ロード初期化
	CALL	BTN			; ボタン	;BTN.PT1     8002
	CALL	BTNSCD			; スケジュール	;BTNSCD.PT1  1192
	RET				;			     9194
FEND	PPT_LD_BTN


;	ボタン枠/ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_BTN_WK,PT_PUT_BTN_WK
	PUSH	AX
	PUSH	BX
	PLSMD	1
	PAT_BANK	0	; ＢＡＮＫ＃０
	CALL	FILE_INIT	; ロード初期化
	CALL	BTNWK		; ボタン枠
	POP	BX
	POP	AX

	MOV	XX1,AX		; オフセットＸ座標
	MOV	YY1,BX		; オフセットＹ座標
	ADD	YY1,3		; ＋３
	ADD	YY1,40		; オフセットＹ座標
	MOV	NUM,0		; ボタン枠のパターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ
	RET
FEND	PPT_PUT_BTN_WK


;	ボタンＯＮ/ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    CX : ボタン番号（０－５）

FUNC	PPT_PUT_BTN_ON,PT_PUT_BTN_ON
	CMP	CX,5		; ボタン番号（０－５）
	JG	PT_PUT_BTN_ON_EXIT

	ADD	CX,6		; ＯＮボタン

	PLSMD	0		;
	PAT_BANK	2	; ２＝ボタン

	MOV	VRX,AX		; ＰＵＴＸ
	MOV	VRY,BX		; ＰＵＴＹ
	CALL	MOUSE_STOP	; マウスカーソル退避
	CALLC	PATPTX		; パーツＰＵＴ座標指定
	CALL	MOUSE_START	; マウスカーソル復帰
PT_PUT_BTN_ON_EXIT:
	RET
FEND	PPT_PUT_BTN_ON



;	ボタンＯＦＦ/ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    CX : ボタン番号（０－５）

FUNC	PPT_PUT_BTN_OFF,PT_PUT_BTN_OFF
	CMP	CX,5		; ボタン番号（０－５）
	JG	PT_PUT_BTN_OFF_EXIT

	PLSMD	0		;
	PAT_BANK	2	; ２＝ボタン

	MOV	VRX,AX		; ＰＵＴＸ
	MOV	VRY,BX		; ＰＵＴＹ
	CALL	MOUSE_STOP	; マウスカーソル退避
	CALLC	PATPTX		; パーツＰＵＴ座標指定
	CALL	MOUSE_START	; マウスカーソル復帰
PT_PUT_BTN_OFF_EXIT:
	RET
FEND	PPT_PUT_BTN_OFF


;	装備枠/ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_SBI_WK,PT_PUT_SBI_WK
	PUSH	AX
	PUSH	BX
	PLSMD	1
	PAT_BANK	0	; ＢＡＮＫ＃０
	CALL	FILE_INIT	; ロード初期化
	CALL	BTNSCW		; スケジュールボタン枠
	POP	BX
	POP	AX

	MOV	XX1,AX		; オフセットＸ座標
	MOV	YY1,BX		; オフセットＹ座標
	ADD	YY1,3		; ＋３
	MOV	NUM,0		;
	CALL	MASK_PUT	; マスクパターンＰＵＴ
	RET
FEND	PPT_PUT_SBI_WK


;	装備蓋/ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    CX : フタ番号（０－１）

FUNC	PPT_PUT_SBI_FT,PT_PUT_SBI_FT
	CMP	CX,1		; ボタン番号（０－１）
	JG	PPT_PUT_SBI_FT_EXIT

	ADD	CX,6*2		; フタ

	PLSMD	0		;
	PAT_BANK	2	; ２＝ボタン

	MOV	VRX,AX		; ＰＵＴＸ
	MOV	VRY,BX		; ＰＵＴＹ
	CALL	MOUSE_STOP	; マウスカーソル退避
	CALLC	PATPTX		; パーツＰＵＴ座標指定
	CALL	MOUSE_START	; マウスカーソル復帰
PPT_PUT_SBI_FT_EXIT:
	RET
FEND	PPT_PUT_SBI_FT


; ***********************************************
;	バンク＃３
;	ウインドウ飾り
; ***********************************************

;	飾りＬＯＡＤ

FUNC	PPT_LD_KAZARI,PT_LD_KAZARI
;*;	PRF	"LOAD #3"
	PAT_BANK	3	; ３＝飾り
	CALL	FILE_INIT	; ロード初期化
	CALL	KAZARI		; 飾りセット
	RET
FEND	PPT_LD_KAZARI


;	縁飾り１
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_K11,PT_K11
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,0		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_K11


;	縁飾り２
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_K12,PT_K12
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,2		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_K12


;	縁飾り３
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_K13,PT_K13
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,4		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_K13


;	縁飾り４
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_K14,PT_K14
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,6		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_K14


;	縁飾りＡ１
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_KA1,PT_KA1
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,4*2		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_KA1


;	縁飾りＡ２
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_KA2,PT_KA2
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,5*2		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_KA2


;	縁飾りＡ３
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_KA3,PT_KA3
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,6*2		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_KA3


;	縁飾りＡ４
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_KA4,PT_KA4
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0		;

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,7*2		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_KA4


;	プチボタンＳ１
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_KS1,PT_KS1
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,16		; パターン番号
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_KS1


;	プチボタンＳ２
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_KS2,PT_KS2
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	PAT_BANK	3	; ３＝飾り
	PLSMD	0

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	MOV	NUM,17		; パターン番号
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定

	POP	NUM
	POP	YY1
	POP	XX1
	RET
FEND	PPT_KS2


; ***********************************************
;	バンク＃４
;	カレンダ
; ***********************************************


;	カレンダＬＯＡＤ

FUNC	PPT_LD_CLEND,PT_LD_CLEND
;*;	PRF	"LOAD #4"
	PAT_BANK	4	; ４＝カレンダ
	CALL	FILE_INIT	; ロード初期化
	CALL	CLEND		; 0,1 カレンダ（マスク１）
	CALL	PROPR		; 2,3 プロポーション（マスク１）
	CALL	GRAPH		; 4   グラフ（横圧縮）
	CALL	VALUE		; 5,6 数値表示
	CALL	PROP2		; 7 プロポーション（横圧縮）

			;  1  2  3  4  5  6  7  8  9 10 11 12
	CALL	MONTH	;  8/ 9/10/11/12/13/14/15/16/17/18/19 月
			;  1  2  3  4  5  6  7
	CALL	WEEK	; 20/21/22/23/24/25/26 週
			;  0  1  2  3  4  5  6  7  8  9
	CALL	BIGNUM	; 27/29/31/33/35/37/39/41/43/45 大きい数字

	RET
FEND	PPT_LD_CLEND


;	カレンダＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_CLEND,PT_PUT_CLEND
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	PAT_BANK	4	; ４＝カレンダ
	PLSMD	1		;

	MOV	NUM,0		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ
	RET
FEND	PPT_PUT_CLEND


;	プロポーションＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_PROPR,PT_PUT_PROPR
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	PAT_BANK	4	; ４＝カレンダ
	PLSMD	1		;

	MOV	NUM,2		; パターン番号
	CALL	MASK_PUT	; マスクパターンＰＵＴ
	RET
FEND	PPT_PUT_PROPR


;	プロポ高速ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_PROP2,PT_PUT_PROP2
	ADD	AX,1
	ADD	BX,9	;10
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	PAT_BANK	4	; ４＝カレンダ
	PLSMD	1		;

	MOV	NUM,7		; パターン番号
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定
	RET
FEND	PPT_PUT_PROP2


;	グラフＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_GRAPH,PT_PUT_GRAPH
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標

	PAT_BANK	4	; ４＝カレンダ
	PLSMD	0		;

	MOV	NUM,4		; パターン番号
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定
	RET
FEND	PPT_PUT_GRAPH


;	数値表示ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_VALUE,PT_PUT_VALUE
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	PAT_BANK	4	; ４＝カレンダ
	PLSMD	0		;
	MOV	NUM,5		; 数値表示ＰＵＴ
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定
	RET
FEND	PPT_PUT_VALUE


;	数値バランス表示ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_VALBALANCE,PT_PUT_VALBALANCE
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	PAT_BANK	4	; ４＝カレンダ
	PLSMD	0		;
	MOV	NUM,6		; 数値バランス表示ＰＵＴ
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定
	RET
FEND	PPT_PUT_VALBALANCE


;	ｍｏｎｔｈ　ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : ｍｏｎｔｈ

FUNC	PPT_PUT_MONTH,PT_PUT_MONTH
	CMP	DX,1
	JL	PT_PUT_MONTH_EXIT
	CMP	DX,12
	JG	PT_PUT_MONTH_EXIT

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	MOV	NUM_MONTH,DX	; ｍｏｎｔｈ

	PAT_BANK	4	; ４＝カレンダ
	PLSMD	1		;

	MOV	AX,NUM_MONTH	; ｍｏｎｔｈ
	ADD	AX,7		;  8/ 9/10/11/12/13/14/15/16/17/18/19 月
	MOV	NUM,AX		; 数値バランス表示ＰＵＴ
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定

PT_PUT_MONTH_EXIT:
	RET
FEND	PPT_PUT_MONTH


;	ｗｅｅｋ　ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : ｗｅｅｋ

FUNC	PPT_PUT_WEEK,PT_PUT_WEEK
	CMP	DX,0
	JL	PT_PUT_WEEK_EXIT
	CMP	DX,6
	JG	PT_PUT_WEEK_EXIT

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	MOV	NUM_WEEK,DX	; ｗｅｅｋ

	PAT_BANK	4	; ４＝カレンダ
	PLSMD	1		;

	MOV	AX,NUM_WEEK	; ｗｅｅｋ
	ADD	AX,20		; 20/21/22/23/24/25/26 週
	MOV	NUM,AX		; 数値バランス表示ＰＵＴ
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定

PT_PUT_WEEK_EXIT:
	RET
FEND	PPT_PUT_WEEK


;	ｄａｙｓ　ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : ｄａｙｓ

FUNC	PPT_PUT_DAYS,PT_PUT_DAYS
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	MOV	NUM_DAYS,DX	; ｄａｙｓ

	MOV	VX1,AX		; ＰＵＴ　Ｘ座標
	MOV	VY1,BX		; ＰＵＴ　Ｙ座標
	ADD	AX,7		;
	ADD	BX,40		;
	MOV	VX2,AX		; end point.
	MOV	VY2,BX		; end point.
	MOV	CX,1111B	; color palet number.
	MOVX	SSEFC0,ARAVRM[0] ; efect data segment.
	MOVX	SSEFC1,ARAVRM[2] ; efect data segment.
	MOVX	SSEFC2,ARAVRM[4] ; efect data segment.
	MOVX	SSEFC3,ARAVRM[6] ; efect data segment.
	CALLC	BOXPAL		; ＢＯＸペイント

	MOVX	VX1,VX2		; ＰＵＴ　Ｘ座標
	ADD	VX2,1		; end point.
	SUB	VY2,2		; end point.
	CALLC	BOXPAL		; ＢＯＸペイント

	PAT_BANK	4	; ４＝カレンダ
	PLSMD	1		;

	MOV	DX,NUM_DAYS	; ｄａｙｓ
	CALLC	DECSTR		; dec -> string.
	CALLC	STRZTS		; zero to space. "00123" - > "  123"
	CALLC	STRSPL		; space pless. "  123" - > "123  "

	MOV	DH,0		;
	MOV	DL,DS:[SI]	; char.
	MOV	AH,0		;
	MOV	AL,DS:[SI][1]	; char.

	CMP	AL,' '		; space.
	JNBE	PT_PUT_DAYS_2KETA
PT_PUT_DAYS_1KETA:
	ADD	XX1,2		; ＰＵＴ　Ｘ座標
	CALL	BIGNUM_PUT	; 大きい数字
	JMP	PT_PUT_DAYS_EXIT
PT_PUT_DAYS_2KETA:
	PUSH	AX		;
	CALL	BIGNUM_PUT	; 大きい数字
	POP	DX		;
	ADD	XX1,4		; ＰＵＴ　Ｘ座標
	CALL	BIGNUM_PUT	; 大きい数字
PT_PUT_DAYS_EXIT:
	RET
FEND	PPT_PUT_DAYS


;	大きい数字
;	-I- XX1 : ＰＵＴ　Ｘ座標
;	    YY1 : ＰＵＴ　Ｙ座標
;	    DX  : 数字キャラ

BIGNUM_PUT	PROC	NEAR
	SUB	DX,'0'	
	SHL	DX,1		; 2 byte pointer.
	ADD	DX,27		; 27/29/31/33/35/37/39/41/43/45 大きい数字
	MOV	NUM,DX		; 数値バランス表示ＰＵＴ
	CALL	MASK_PUT	; マスクパターンＰＵＴ
	RET
BIGNUM_PUT	ENDP


; ***********************************************
;	バンク＃５
;	パレット
; ***********************************************

;	パレットのロード

FUNC	PPT_PALET_LD,PT_PALET_LD
;*;	PRF	"LOAD #5"
	PAT_BANK	5		; ５=パレット
	CALL	FILE_INIT		; ロード初期化
	CALL	PALET			; パレットデータ
	RET
FEND	PPT_PALET_LD


;	パレットのセット
;	-I- DX : パレットのパターン番号

FUNC	PPT_PALET_ST,PT_PALET_ST
	PAT_BANK	5	; ５=パレット
	PALET_SET	DX
	MOV	DX,1		; 0=何もしない, 1=５０％ダウン
	CALLC	DKCMMD		; メッセージ突入モード
	RET
FEND	PPT_PALET_ST


;	パレットのテーブルのみセット
;	-I- DX : パレットのパターン番号

FUNC	PPT_PALET_PLD,PT_PALET_PLD
	PAT_BANK	5	; ５=パレット
	PALET_LOAD	0,DX
	RET
FEND	PPT_PALET_PLD


;	パレットのテーブルのみセット（テーブル指定）
;	-I- DX : パレットのパターン番号
;	    AX : パレットテーブル番号

FUNC	PPT_PALET_PLDP,PT_PALET_PLDP
	PUSH	AX
	PAT_BANK	5	; ５=パレット
	POP	AX
	PALET_LOAD	AX,DX
	RET
FEND	PPT_PALET_PLDP


;	パレットのセット・ゲーム面

FUNC	PPT_PALET_S_GM,PT_PALET_S_GM
	MOV	DX,15			; パレットのパターン番号
	MOV	AX,4			; パレットテーブル番号
	MOV	CX,6			; 春，夏，９，１０，１１，１２
PT_PALET_S_GM_LOOP:
	PUSH	AX
	PUSH	CX
	PUSH	DX
	CALL	FAR PTR PPT_PALET_PLDP	; パレットのテーブルのみセット
	POP	DX
	POP	CX
	POP	AX
	INC	DX
	INC	AX
	LOOP	PT_PALET_S_GM_LOOP
	RET
FEND	PPT_PALET_S_GM


; ***********************************************
;	バンク＃６
;	ショック
; ***********************************************

;	ショックＬＯＡＤ

FUNC	PPT_LD_SHOCK,PT_LD_SHOCK
;*;	PRF	"LOAD #6"
	PAT_BANK	6	; ６＝ショック
	CALL	FILE_INIT	; ロード初期化
	CALL	PAT6		; ショック
	RET
FEND	PPT_LD_SHOCK


;	ショックＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : ショック番号

FUNC	PPT_PUT_SHOCK,PT_PUT_SHOCK
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	MOV	NUM,DX		; パターン番号

	PAT_BANK	6	; ６＝ショック
	PLSMD	0		;

	CALL	MASK_PUT	; マスクパターンＰＵＴ
	RET
FEND	PPT_PUT_SHOCK


; ***********************************************
;	バンク＃７
;	アイテム
; ***********************************************

;	アイテムＬＯＡＤ

FUNC	PPT_LD_ITEM,PT_LD_ITEM
;*;	PRF	"LOAD #7"
	PAT_BANK	7	; ７＝アイテム
	CALL	FILE_INIT	; ロード初期化
	CALL	PAT7		; アイテム
	CALL	PAT7WK		; 仕事アイテム
	RET
FEND	PPT_LD_ITEM


;	アイテムＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : アイテム番号

FUNC	PPT_PUT_ITEM,PT_PUT_ITEM
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	MOV	NUM,DX		; パターン番号

	PLSMD	1

	PAT_BANK	7	; ７＝アイテム

	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定
	RET
FEND	PPT_PUT_ITEM


; ***********************************************
;	バンク＃８
;	星座
; ***********************************************

;	星座ＬＯＡＤ

FUNC	PPT_LD_SEIZA,PT_LD_SEIZA
;*;	PRF	"LOAD #8"
	PAT_BANK	8	; ８＝星座
	CALL	FILE_INIT	; ロード初期化
	CALL	PAT8		; 星座
	CALL	BLOOD		; 血液型
	RET
FEND	PPT_LD_SEIZA


;	星座ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : 星座番号
;		1=おひつじ座
;		2=おうし座
;		3=ふたご座
;		4=かに座
;		5=しし座
;		6=おとめ座
;		7=てんびん座
;		8=さそり座
;		9=いて座
;		10=やぎ座
;		11=みずがめ座
;		12=うお座

FUNC	PPT_PUT_SEIZA,PT_PUT_SEIZA
	CMP	DX,1
	JL	PT_PUT_SEIZA_EXIT
	CMP	DX,12
	JG	PT_PUT_SEIZA_EXIT

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	DEC	DX		; 
	MOV	NUM,DX		; パターン番号

	PLSMD	1

	PAT_BANK	8	; ８＝星座

PT_PUT_SEIZA_EXIT:
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定
	RET
FEND	PPT_PUT_SEIZA


;	血液型ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : 血液型
;		1=Ａ型
;		2=Ｂ型
;		3=ＡＢ型
;		4=Ｏ型

FUNC	PPT_PUT_BLOOD,PT_PUT_BLOOD
	CMP	DX,1
	JL	PT_PUT_BLOOD_EXIT
	CMP	DX,4
	JG	PT_PUT_BLOOD_EXIT

	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	DEC	DX		; 
	MOV	NUM,DX		; パターン番号

	SHL	NUM,1		; 2 byte pointer.
	ADD	NUM,12		; 先頭の星座をスキップ

	PLSMD	1
	PAT_BANK	8	; ８＝星座

	CALL	MASK_PUT	; マスクパターンＰＵＴ

PT_PUT_BLOOD_EXIT:
	RET
FEND	PPT_PUT_BLOOD



; ***********************************************
;	バンク＃１０
; ***********************************************

;	娘フェイスＬＯＡＤ
;	-I- DX : 少女（成長１,成長２,成長３....）

FUNC	PPT_LD_MYGIRL_FACE,PT_LD_MYGIRL_FACE
	CMP	DX,1			; 少女（成長１,成長２,成長３....）
	JGE	PT_LD_MYGIRL_FACE_01	;
	MOV	DX,1			;
PT_LD_MYGIRL_FACE_01:
	CMP	DX,8			;
	JLE	PT_LD_MYGIRL_FACE_02	;
	MOV	DX,8			;
PT_LD_MYGIRL_FACE_02:

	INC	DX			; + 1
	SHR	DX,1			; / 2		1 -> 1 , 8 -> 4

PT_LD_MYGIRL_FACE_START:		;
	CALLC	DECSTR			; decimal -> string.
	MOVXB	FL_MYGL_F_SCC_N[0],DS:[SI][4]	; "09"<-"00009"
	MOVXB	FL_MYGL_F_SPP_N[0],DS:[SI][4]	;

	PAT_BANK	10		; 娘フェイスＬＯＡＤ
	CALL	FILE_INIT		; ロード初期化

	MOV	SI,OFFSET FL_MYGL_F_SCC	; フェイス・成功 "F4_01"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	SI,OFFSET FL_MYGL_F_SPP	; フェイス・失敗 "F5_01"
	CALLC	PATLDA			; パーツ追加ロード

	RET
FEND	PPT_LD_MYGIRL_FACE


;	娘フェイスＰＵＴ
;	-I- DX : 顔 1=成功,2=失敗
;	    AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_PUT_MYGIRL_FACE,PT_PUT_MYGIRL_FACE
	DEC	DX
	CMP	DX,1
	JBE	PT_PUT_MYGIRL_FACE_1
	MOV	DX,1
PT_PUT_MYGIRL_FACE_1:

	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
	MOV	NUM,DX			; パターン番号

	PLSMD	1			;
	PAT_BANK	10		; 娘フェイスＬＯＡＤ

	CALL	PATTAN_PTX		; パターンＰＵＴ座標指定

	RET
FEND	PPT_PUT_MYGIRL_FACE



; ***********************************************
;	収穫祭関係
; ***********************************************

;	収穫祭パターンロード
;	-I- DX : ファイル番号  PAT10S1,PAT10S2...PAT10S5
;
;		1=収穫祭,2=武闘会,3=ミス国王,4=表彰式,5=各賞

FUNC	PPT_SYUKAK_LD,PT_SYUKAK_LD
	MOV	NUM,DX			;

	PAT_BANK	1		; ＢＡＮＫ＃１
	CALL	FILE_INIT		; ロード初期化

	MOV	DX,NUM			; パターン番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	FL_PAT10SX_NUM,DS:[SI][4] ;"9"<-"00009"
	MOV	SI,OFFSET FL_PAT10SX	; 収穫祭
	CALLC	PATLDA			; パーツ追加ロード

	RET
FEND	PPT_SYUKAK_LD


;	収穫祭パターンＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : 番号

FUNC	PPT_SYUKAK_PUT,PT_SYUKAK_PUT
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	MOV	NUM,DX		; パターン番号

	PAT_BANK	1	; ＢＡＮＫ＃１
	PLSMD	1		;
	CALL	PATTAN_PTX	; パターンＰＵＴ座標指定
	RET
FEND	PPT_SYUKAK_PUT


;	収穫祭マスクパターンＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : 番号

FUNC	PPT_SYUKAK_MPT,PT_SYUKAK_MPT
	MOV	XX1,AX		; ＰＵＴ　Ｘ座標
	MOV	YY1,BX		; ＰＵＴ　Ｙ座標
	MOV	NUM,DX		; パターン番号

	PAT_BANK	1	; ＢＡＮＫ＃１
	PLSMD	1		;

	CALL	MASK_PUT	; マスクパターンＰＵＴ
	RET
FEND	PPT_SYUKAK_MPT


;*;;	ミスコンパターンセットロード
;*;
;*;FUNC	PPT_LD_MISS,PT_LD_MISS
;*;	PAT_BANK	10	; １０＝ＢＩＧバッファ
;*;	CALL	FILE_INIT	; ロード初期化
;*;	CALL	PAT10MS		; ミスコン
;*;	RET
;*;FEND	PPT_LD_MISS
;*;
;*;
;*;;	ミスコン各パターン
;*;;	-I- DX : パターン番号
;*;;	    0=「各賞発表」
;*;;	    1=「ミス・コンテスト」
;*;;	    2=「総合優勝」
;*;;	    3=「気品部門」
;*;;	    4=「プロポーション部門」
;*;;	    5=「セクシー部門」
;*;
;*;FUNC	PPT_PUT_MISS_SHO,PT_PUT_MISS_SHO
;*;	MOV	NUM,DX			; パターン番号
;*;
;*;	PAT_BANK	10		; １０＝ＢＩＧバッファ
;*;
;*;	PLSMD	1
;*;	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
;*;	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
;*;	CALL	PATTAN_PUT		; パターンＰＵＴ
;*;
;*;	RET
;*;FEND	PPT_PUT_MISS_SHO
;*;
;*;
;*;;	武闘会パターンセットロード
;*;
;*;FUNC	PPT_LD_BUTOH,PT_LD_BUTOH
;*;	PAT_BANK	10	; １０＝ＢＩＧバッファ
;*;	CALL	FILE_INIT	; ロード初期化
;*;	CALL	PAT10BT		; 武闘会
;*;	RET
;*;FEND	PPT_LD_BUTOH
;*;
;*;
;*;;	武闘会各パターン
;*;;	-I- DX : パターン番号
;*;;	    0=「表彰式」
;*;;	    1=「武闘会！」
;*;
;*;FUNC	PPT_PUT_BUTOH,PT_PUT_BUTOH
;*;	MOV	NUM,DX			; パターン番号
;*;
;*;	PAT_BANK	10		; １０＝ＢＩＧバッファ
;*;
;*;	PLSMD	1
;*;	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
;*;	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
;*;	CALL	PATTAN_PUT		; パターンＰＵＴ
;*;
;*;	RET
;*;FEND	PPT_PUT_BUTOH


; ***********************************************
;	キャラクタ
; ***********************************************


;	キャラクタ・ベース
;	-I- DX : 少女（成長１,成長２,成長３,成長４）
;	    AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_CHR_BASE,PT_CHR_BASE
	CMP	DX,CBASE_MAX		; キャラ成長数
	JNBE	PT_CHR_BASE_EXIT	;

	MOV	NUM,DX			; パターン番号
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標

	CALL	GIRL_AJST		; 娘の表示位置調整

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;

	CALL	FILE_INIT		; ロード初期化

	MOV	DX,NUM			; パターン番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	CBASE_BDSC,DS:[SI][4]	; "9"<-"00009"
	MOV	SI,OFFSET CBASE_BD	; キャラ体ファイル名 "CB1.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	NUM,0			; パターン番号
	CALL	MASK_PTF		; マスクパターンオフセットＰＵＴ
PT_CHR_BASE_EXIT:
	RET
FEND	PPT_CHR_BASE


;	服変化（４シーズン）
;	-I- DX : 少女（成長１,成長２,成長３,成長４）
;	    CX : 季節（1:春，2:夏，3:秋，4:冬）
;	    AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_CHR_DRESS,PT_CHR_DRESS
	CMP	DX,CBASE_MAX		; キャラ成長数
	JNBE	PT_CHR_DRESS_EXIT	;
	CMP	CX,CBASE_DMAX		; キャラ服パターン数
	JNBE	PT_CHR_DRESS_EXIT	;

	MOV	NUM,DX			; パターン番号
	MOV	NUM2,CX			;
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標

	CALL	GIRL_AJST		; 娘の表示位置調整

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;

	CALL	FILE_INIT		; ロード初期化

	MOV	DX,NUM			; パターン番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	CBASE_DSC,DS:[SI][4]	; "9"<-"00009"
	MOV	DX,NUM2			; パターン番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	CBASE_DSEE,DS:[SI][4]	; "9"<-"00009" 服季節

	MOV	SI,OFFSET CBASE_DRESS	; キャラ服ファイル名
	CALLC	PATLDA			; パーツ追加ロード

	MOV	NUM,0			; パターン番号
	CALL	MASK_PTF		; マスクパターンオフセットＰＵＴ
PT_CHR_DRESS_EXIT:			;
	RET
FEND	PPT_CHR_DRESS



;	顔変化
;	-I- DX : 少女（成長１,成長２,成長３,成長４）
;	    CX : 顔（１－３）
;	    AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_CHR_FACE,PT_CHR_FACE
	CMP	DX,CBASE_MAX		; キャラ成長数
	JNBE	PT_CHR_FACE_EXIT	;
	CMP	CX,CBASE_FMAX		; キャラ顔パターン数
	JNBE	PT_CHR_FACE_EXIT	;

	MOV	NUM,DX			; パターン番号
	MOV	NUM2,CX			;
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標

	CALL	GIRL_AJST		; 娘の表示位置調整

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;

	CALL	FILE_INIT		; ロード初期化

	MOV	DX,NUM			; パターン番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	CBASE_FSC,DS:[SI][4]	; "9"<-"00009"
	MOV	DX,NUM2			; パターン番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	CBASE_FSEE,DS:[SI][4]	; "9"<-"00009" キャラ顔季節

	MOV	SI,OFFSET CBASE_FACE	; キャラ顔ファイル名
	CALLC	PATLDA			; パーツ追加ロード

	MOV	NUM,0			; パターン番号
	CALL	MASK_PTF		; マスクパターンオフセットＰＵＴ
PT_CHR_FACE_EXIT:
	RET
FEND	PPT_CHR_FACE


;	娘の表示位置調整
;	-I-   NUM : パターン番号
;	-I/O- XX1 : ＰＵＴ　Ｘ座標
;	      YY1 : ＰＵＴ　Ｙ座標

GIRL_AJST	PROC	NEAR
	MOV	BX,NUM			; パターン番号
	MOV	AL,DS:GIRL_OFS_TBL[BX]	; 娘の表示位置オフセット
	CBW				; 符号拡張
	ADD	XX1,AX			; ＰＵＴ　Ｘ座標
	RET
GIRL_AJST	ENDP


; ***********************************************
;	ＢＧ（背景）
; ***********************************************


;	メインＢＧ－ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_CHR_BG_MAIN,PT_CHR_BG_MAIN
	MOV	DX,1			; ＢＧ番号
	CALL	PT_CHR_BG		; ＢＧ－ＰＵＴ
	RET
FEND	PPT_CHR_BG_MAIN


;	バトルＢＧ－ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : ＢＧ番号
;	・ＢＧ番号
;	1=メインＢＧ
;	2=寺院の丘（武闘会）
;	3=

FUNC	PPT_CHR_BG_BATLE,PT_CHR_BG_BATLE
	ADD	AX,1			; Ｘオフセット
	ADD	BX,32			; Ｙオフセット
	CALL	PT_CHR_BG		; ＢＧ－ＰＵＴ
	RET
FEND	PPT_CHR_BG_BATLE


;	ＢＧ－ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : ＢＧ番号

PT_CHR_BG	PROC	NEAR
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
	MOV	BGNUM,DX		; ＢＧ番号

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1			;
	CALL	FILE_INIT		; ロード初期化

	MOV	DX,BGNUM		; ＢＧ番号
	CALL	PT_CHR_BG_LDA		; ＢＧ－ＬＯＡＤ（追加）

	MOV	DX,0			; パターン番号（２個連続）
	CALL	PT_CHR_BG_PUT		; ＢＧ－ＰＵＴのみ

	RET
PT_CHR_BG	ENDP




;	ＢＧ－ＰＵＴのみ
;	-I- XX1 : ＰＵＴオフセット　Ｘ座標
;	    YY1 : ＰＵＴオフセット　Ｙ座標
;	    DX : パターン番号（２個連続）

PT_CHR_BG_PUT	PROC	NEAR
	MOV	NUM,DX			; パターン番号（２個連続）
	CALL	PATTAN_PUT		; パターンＰＵＴ
	INC	NUM			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
PT_CHR_BG_PUT	ENDP


;	ＢＧ－ＬＯＡＤ（追加）
;	-I-  DX : ＢＧ番号

PT_CHR_BG_LDA	PROC	NEAR
	MOV	BGNUM,DX		; ＢＧ番号

	CMP	DX,FL_BG_MAX		; ＢＧＭＡＸ
	JLE	PT_CHR_BG_LDA_2		;
	MOVX	BGNUM,FL_BG_MAX		;
PT_CHR_BG_LDA_2:

	MOV	BX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
	INC	BX			;+1
	SHR	BX,1			; / 2 （成長１から８まで２ステップ）
	SHL	BX,1			; word pointer.
	MOV	DI,DS:FL_BG_LEFT[BX]	;
	MOV	BX,BGNUM		; ＢＧ番号
	SHL	BX,1			; word pointer.
	MOV	SI,DS:[DI][BX]		;
	CALLC	PATLDA			; パーツ追加ロード

	MOV	BX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
	INC	BX			;+1
	SHR	BX,1			; / 2 （成長１から８まで２ステップ）
	SHL	BX,1			; word pointer.
	MOV	DI,DS:FL_BG_RIGHT[BX]	;
	MOV	BX,BGNUM		; ＢＧ番号
	SHL	BX,1			; word pointer.
	MOV	SI,DS:[DI][BX]		;
	CALLC	PATLDA			; パーツ追加ロード

	RET
PT_CHR_BG_LDA	ENDP


;*;;	ＢＧ－ＰＵＴ
;*;;	-I- AX : ＰＵＴ　Ｘ座標
;*;;	    BX : ＰＵＴ　Ｙ座標
;*;;	    DX : ＢＧ番号
;*;
;*;PT_CHR_BG	PROC	NEAR
;*;	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
;*;	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
;*;	MOV	BGNUM,DX		; ＢＧ番号
;*;
;*;	CMP	DX,FL_BG_MAX		; ＢＧＭＡＸ
;*;	JLE	PT_CHR_BG_2		;
;*;	MOVX	BGNUM,FL_BG_MAX		;
;*;PT_CHR_BG_2:
;*;
;*;	PAT_BANK	0		; ＢＡＮＫ＃０
;*;	PLSMD	1			;
;*;
;*;	CALL	FILE_INIT		; ロード初期化
;*;
;*;	MOV	BX,BGNUM		; ＢＧ番号
;*;	SHL	BX,1			; word pointer.
;*;	MOV	SI,DS:FL_BG_LEFT[BX]	;
;*;	CALL	PATLDA			; パーツ追加ロード
;*;
;*;	MOV	BX,BGNUM		; ＢＧ番号
;*;	SHL	BX,1			; word pointer.
;*;	MOV	SI,DS:FL_BG_RIGHT[BX]	;
;*;	CALL	PATLDA			; パーツ追加ロード
;*;
;*;	MOV	NUM,0			; パターン番号
;*;	CALL	PATTAN_PUT		; パターンＰＵＴ
;*;	MOV	NUM,1			; パターン番号
;*;	CALL	PATTAN_PUT		; パターンＰＵＴ
;*;	RET
;*;PT_CHR_BG	ENDP



; ***********************************************
;	相手関係
; ***********************************************


;	闘士ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : 闘士番号
;	・闘士番号
;		1-23

FUNC	PPT_TOHSHI,PT_TOHSHI
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

	ADD	AX,1+7+2		; Ｘオフセット
	ADD	BX,32+48+12		; Ｙオフセット
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
	MOV	TONUM,DX		; 闘士番号

	CMP	DX,FL_TOHS_MAX		; 闘士ＭＡＸ
	JLE	PT_TOHSHI_2		;
	MOVX	TONUM,FL_TOHS_MAX	;
PT_TOHSHI_2:				;

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1			;
	CALL	FILE_INIT		; ロード初期化

	MOV	DX,TONUM		; 闘士番号
	DEC	DX			; －１
	CALLC	DECSTR			; decimal -> string.
	MOVXB	FL_TOHS_NUM[0],DS:[SI][3] ; "9"<-"00009" 闘士番号番号
	MOVXB	FL_TOHS_NUM[1],DS:[SI][4] ; "9"<-"00009" 闘士番号番号
	MOV	SI,OFFSET FL_TOHS	; フェイス "E1_00.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	NUM,0			; パターン番号
	CALL	MASK_PUT		; マスクパターンＰＵＴ

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	PPT_TOHSHI


;	師範ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : 師範番号
;	・師範番号
;		1-3

FUNC	PPT_SHIHAN,PT_SHIHAN
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

	ADD	AX,1+7+2		; Ｘオフセット
	ADD	BX,32+48+12		; Ｙオフセット
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
	MOV	SHNUM,DX		; 闘士番号

	CMP	DX,FL_SHIHAN_MAX	; 師範ＭＡＸ
	JLE	PT_SHIHAN_2		;
	MOVX	SHNUM,FL_SHIHAN_MAX	; 師範ＭＡＸ
PT_SHIHAN_2:				;

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1			;
	CALL	FILE_INIT		; ロード初期化

	MOV	DX,SHNUM		; 師範番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	FL_SHIHAN_NUM[0],DS:[SI][3] ; "9"<-"00009" 師範番号
	MOVXB	FL_SHIHAN_NUM[1],DS:[SI][4] ; "9"<-"00009" 師範番号
	MOV	SI,OFFSET FL_SHIHAN	; フェイス "E3_00.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	NUM,0			; パターン番号
	CALL	MASK_PUT		; マスクパターンＰＵＴ

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	PPT_SHIHAN


;	モンスター ＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : モンスター番号
;	・モンスター番号
;		1-10

FUNC	PPT_MNSTER,PT_MNSTER
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

	ADD	AX,1+7			; Ｘオフセット
	ADD	BX,32+48		; Ｙオフセット
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
	MOV	MNNUM,DX		; モンスター番号

	CMP	DX,FL_TK_MAX		; モンスターＭＡＸ
	JLE	PT_MNSTER_2		;
	MOVX	MNNUM,FL_TK_MAX		;
PT_MNSTER_2:				;

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;
	CALL	FILE_INIT		; ロード初期化

	MOV	DX,MNNUM		; モンスター番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	FL_TK_NUM[0],DS:[SI][3]	; "09"<-"00009"
	MOVXB	FL_TK_NUM[1],DS:[SI][4]	; "09"<-"00009"
	MOV	SI,OFFSET FL_TK		; モンスター "E2_01.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	NUM,0			; パターン番号
	CALL	MASK_PUT		; マスクパターンＰＵＴ

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	PPT_MNSTER


;	ミスコンＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : ムスメ番号
;	・ムスメ番号
;		1-17

FUNC	PPT_MISSCON,PT_MISSCON
	PUSH	AX
	PUSH	BX
	CALL	FAR PTR PPT_MISSCON_LD		; ミスコンＬＯＡＤ ＯＮＬＹ
	POP	BX
	POP	AX
	CALL	FAR PTR PPT_MISSCON_PUT		; ミスコンＰＵＴ ＯＮＬＹ
	RET
FEND	PPT_MISSCON


;	ミスコンＬＯＡＤ ＯＮＬＹ
;	-I- DX : ムスメ番号
;	・ムスメ番号
;		1-17

FUNC	PPT_MISSCON_LD,PT_MISSCON_LD
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

	MOV	GLNUM,DX		; ムスメ番号

	CMP	DX,FL_MISSCON_MAX	; ミスコンＭＡＸ
	JLE	PT_MISSCON_2		;
	MOVX	GLNUM,FL_MISSCON_MAX	;
PT_MISSCON_2:

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1			;
	CALL	FILE_INIT		; ロード初期化

					; ミスコン "MC_nn_x.PT1"
	CMP	GLNUM,1			; ムスメ番号 １は自分の娘
	JNE	PT_MISSCON_ANTHER	;
PT_MISSCON_MY:
	MOV	DX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
	ADD	DX,17			;
	MOV	GLNUM,DX		; ムスメ番号
	JMP	PT_MISSCON_4		;
PT_MISSCON_ANTHER:
	MOV	DX,GLNUM		; ムスメ番号
	DEC	DX			;
PT_MISSCON_4:
	CMP	DX,25			;
	JLE	PT_MISSCON_44		;
	MOV	DX,25			;
PT_MISSCON_44:
	CALLC	DECSTR			; decimal -> string.
	MOVXB	FL_MISC_NUM[0],DS:[SI][3] ; "9"<-"00009" ミスコン メンバ
	MOVXB	FL_MISC_NUM[1],DS:[SI][4] ; "9"<-"00009" ミスコン メンバ
PT_MISSCON_5:
;*;	MOV	BX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
;*;	DEC	BX			; 0 base.
;*;	MOV	AL,DS:FL_MISS_DISK_F[BX] ;ﾌｧｲﾙ末尾(成長１,成長２,成長３,成長４)
;*;	MOV	FL_MISC_AGE,AL		; ミスコン P,2,3,4(成長)

	MOV	SI,OFFSET FL_MISC	; ミスコン "MC_nn_x.PT1"
	CALLC	PATLDA			; パーツ追加ロード

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	PPT_MISSCON_LD


;	ミスコンＰＵＴ ＯＮＬＹ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標

FUNC	PPT_MISSCON_PUT,PT_MISSCON_PUT
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1			;
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
FEND	PPT_MISSCON_PUT


;	フェイスＰＵＴ
;	-I- AX : ＰＵＴ　Ｘ座標
;	    BX : ＰＵＴ　Ｙ座標
;	    DX : フェイス番号
;	・フェイス番号
;		01 : 衛兵
;		02 : 近衛隊長
;		03 : 侍従
;		04 : 侍従長
;		05 : 王妃様
;		06 : 王様
;		*
;		07 : 武芸師範１
;		08 : 武芸師範２
;		09 : 武芸師範３
;		10 : 学問場の先生
;		11 : 礼法の先生
;		*
;		12 : 宿屋
;		13 : メイド
;		14 : 代筆屋
;		15 : 酒場１
;		16 : 医者
;		17 : 狩人
;		18 : 武器屋
;		19 : 宿屋２
;		20 : 木コリ
;		21 : 教会
;		22 : 酒場２
;		23 : 人足
;		*
;		24 : 主人公１０－１２成功
;		25 : 主人公１２－１４成功
;		26 : 主人公１４－１６成功
;		27 : 主人公１６－１８成功
;		*
;		28 : 主人公１０－１２失敗
;		29 : 主人公１２－１４失敗
;		30 : 主人公１４－１６失敗
;		31 : 主人公１６－１８失敗

FUNC	PPT_FACE,PT_FACE
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

;*;	ADD	AX,1+7			; Ｘオフセット
;*;	ADD	BX,32+48		; Ｙオフセット
	MOV	XX1,AX			; ＰＵＴ　Ｘ座標
	MOV	YY1,BX			; ＰＵＴ　Ｙ座標
	MOV	FCNUM,DX		; フェイス番号

	CMP	DX,FL_FACE_MAX		; フェイスＭＡＸ
	JLE	PT_FACE_2		;
	MOVX	FCNUM,FL_FACE_MAX	;
PT_FACE_2:				;


	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD	1			;
	CALL	FILE_INIT		; ロード初期化

	MOV	DX,FCNUM		; フェイス番号
	CMP	DX,1			;  1-6  衛兵
	JGE	PT_FACE_3		;
	JMP	PT_FACE_EXIT		;
PT_FACE_3:
	CMP	DX,7			;  7-11 武芸師範１
	JL	PT_FACE_41		;
	CMP	DX,12			; 12-23 宿屋
	JL	PT_FACE_42		;
	CMP	DX,24			; 24-27 主人公１０－１２成功
	JL	PT_FACE_43		;
	CMP	DX,28			; 28-31 主人公１０－１２失敗
	JL	PT_FACE_44		;
	JMP	PT_FACE_45		;

PT_FACE_41:
	MOV	FL_FACE_CUT,'1'		;  1-6  衛兵
	MOV	DX,FCNUM		; フェイス番号
	JMP	PT_FACE_46		;
PT_FACE_42:
	MOV	FL_FACE_CUT,'2'		;  7-11 武芸師範１
	MOV	DX,FCNUM		; フェイス番号
	SUB	DX,7-1			;
	JMP	PT_FACE_46		;
PT_FACE_43:
	MOV	FL_FACE_CUT,'3'		; 12-23 宿屋
	MOV	DX,FCNUM		; フェイス番号
	SUB	DX,12-1			;
	JMP	PT_FACE_46		;
PT_FACE_44:
	MOV	FL_FACE_CUT,'4'		; 24-27 主人公１０－１２成功
	MOV	DX,FCNUM		; フェイス番号
	SUB	DX,24-1			;
	JMP	PT_FACE_46		;
PT_FACE_45:
	MOV	FL_FACE_CUT,'5'		; 28-31 主人公１０－１２失敗
	MOV	DX,FCNUM		; フェイス番号
	SUB	DX,28-1			;
	JMP	PT_FACE_46		;
PT_FACE_46:
	CALLC	DECSTR			; decimal -> string.
	MOVXB	FL_FACE_NUM[0],DS:[SI][3]	; "09"<-"00009"
	MOVXB	FL_FACE_NUM[1],DS:[SI][4]	; "09"<-"00009"

	MOV	SI,OFFSET FL_FACE	; フェイス "F1_01.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PTX		; パターンＰＵＴ座標指定
;*;	CALL	PATTAN_PUT		; パターンＰＵＴ

PT_FACE_EXIT:
;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	PPT_FACE


; ***********************************************
;	武芸ＢＧ－ＰＵＴ
; ***********************************************

;	武芸ＢＧ－ＰＵＴ

FUNC	PPT_CHR_BG_BUGEI,PT_CHR_BG_BUGEI
	PAT_BANK	0		; ＢＡＮＫ＃０
	CALL	FILE_INIT		; ロード初期化
	MOV	DX,6			; ＢＧ番号 6=武芸
	CALL	PT_CHR_BG_LDA		; ＢＧ－ＬＯＡＤ（追加）
	PLSMD	1			;
	MOV	DX,0			; パターン番号（２個連続）
	MOV	XX1,1			; ＰＵＴ　Ｘ座標
	MOV	YY1,32			; ＰＵＴ　Ｙ座標
	CALL	PT_CHR_BG_PUT		; ＢＧ－ＰＵＴのみ
	RET
	RET
FEND	PPT_CHR_BG_BUGEI


; ***********************************************
;	武闘会ＢＧ－ＰＵＴ
; ***********************************************

;	武闘会関係全ロード

FUNC	PPT_BUTOH_ALL_LOAD,PT_BUTOH_ALL_LOAD
	PAT_BANK	1		; ＢＡＮＫ＃１
	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMB1			; #0 バトルフレーム・左側
	CALL	FREAMB2			; #1 バトルフレーム・真中
	CALL	FREAMB3			; #2 バトルフレーム・右側
	RET
FEND	PPT_BUTOH_ALL_LOAD


;	武闘会ＢＧ－ＰＵＴ

FUNC	PPT_CHR_BG_BUTOH,PT_CHR_BG_BUTOH
	PAT_BANK	0		; ＢＡＮＫ＃０
	CALL	FILE_INIT		; ロード初期化
	MOV	DX,2			; ＢＧ番号 2=寺院の丘（武闘会）
	CALL	PT_CHR_BG_LDA		; ＢＧ－ＬＯＡＤ（追加）
	PLSMD	1			;
	MOV	DX,0			; パターン番号（２個連続）
	MOV	XX1,1			; ＰＵＴ　Ｘ座標
	MOV	YY1,32			; ＰＵＴ　Ｙ座標
	CALL	PT_CHR_BG_PUT		; ＢＧ－ＰＵＴのみ
	RET
FEND	PPT_CHR_BG_BUTOH


;	武闘会フレーム

FUNC	PPT_FREAM_BUTOH,PT_FREAM_BUTOH
	PAT_BANK	1		; ＢＡＮＫ＃１
	PLSMD	1
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOV	NUM,0			; #0 パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	MOV	NUM,1			; #1 パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	MOV	NUM,2			; #2 通常フレーム・右
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
FEND	PPT_FREAM_BUTOH


; ***********************************************
;	武者修行ＢＧ－ＰＵＴ
; ***********************************************

;	武者修行関係全ロード

FUNC	PPT_MUSYA_ALL_LOAD,PT_MUSYA_ALL_LOAD
;*;	PAT_BANK	1		; ＢＡＮＫ＃１
;*;	CALL	FILE_INIT		; ロード初期化
;*;	CALL	FREAMM1			; #0 武者修行フレーム・左側
;*;	CALL	FREAMM2			; #1 武者修行フレーム・真中
;*;	CALL	FREAMM3			; #2 武者修行フレーム・右側
	RET
FEND	PPT_MUSYA_ALL_LOAD


;	武者修行フレーム

FUNC	PPT_FREAM_MUSYA,PT_FREAM_MUSYA
	PAT_BANK	1		; ＢＡＮＫ＃１
	PLSMD	1

	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMM1			; #0 武者修行フレーム・左側
	MOV	NUM,0			; #0 パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMM2			; #0 武者修行フレーム・真中
	MOV	NUM,0			; #0 パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	CALL	FILE_INIT		; ロード初期化
	CALL	FREAMM3			; #0 武者修行フレーム・右側
	MOV	NUM,0			; #0 通常フレーム・右
	CALL	PATTAN_PUT		; パターンＰＵＴ
	RET
FEND	PPT_FREAM_MUSYA


;*;;	武者修行ＢＧ－ロード（ＢＡＮＫ＃１）
;*;;	-I- AX : 場所=1 近郊
;*;;	             =2 辺境
;*;;	             =3 蛮地
;*;
;*;FUNC	PPT_CHR_BG_MUSYA_LD,PT_CHR_BG_MUSYA_LD
;*;	MOV	NUM,AX
;*;	PAT_BANK	1		; ＢＡＮＫ＃１
;*;	PLSMD		1		;
;*;	CALL	FILE_INIT		; ロード初期化
;*;	MOV	DX,NUM			;
;*;	ADD	DX,2			; ＢＧ番号３=近郊,４辺境,５蛮地
;*;	CALL	PT_CHR_BG_LDA		; ＢＧ－ＬＯＡＤ（追加）
;*;	RET
;*;FEND	PPT_CHR_BG_MUSYA_LD
;*;
;*;
;*;;	武者修行ＢＧ－ＰＵＴ
;*;
;*;FUNC	PPT_CHR_BG_MUSYA_PT,PT_CHR_BG_MUSYA_PT
;*;	PAT_BANK	1		; ＢＡＮＫ＃１
;*;	PLSMD		1		;
;*;	MOV	DX,0			; パターン番号（２個連続）
;*;	MOV	XX1,1			; ＰＵＴ　Ｘ座標
;*;	MOV	YY1,32			; ＰＵＴ　Ｙ座標
;*;	CALL	PT_CHR_BG_PUT		; ＢＧ－ＰＵＴのみ
;*;	RET
;*;FEND	PPT_CHR_BG_MUSYA_PT


; ***********************************************
;	イベント関係
; ***********************************************

;	町の評判
;	-I- AX : イベントウインドウＸ位置
;	    BX : イベントウインドウＹ位置

FUNC	PPT_MACHINOUWASA,PT_MACHINOUWASA
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

	MOV	XX1,AX			; イベントウインドウＸ位置
	MOV	YY1,BX			; イベントウインドウＹ位置

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;
	CALL	FILE_INIT		; ロード初期化
	CALL	I4_02			; 町の評判

	MOV	AX,1			; 1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	MOV	NUM,0			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	MOV	AX,0			; 0=通常
	CALLC	PATEFC			; パーツＰＵＴエフェクト

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	PPT_MACHINOUWASA


;	イベントビュー
;	-I- AX : イベントウインドウＸ位置
;	    BX : イベントウインドウＹ位置
;	    DX : パターン番号
;		1=王様との会見
;		2=町の評判
;		3=ステータス
;		4=娘と話す
;		5=買物
;		6=武芸道場
;		7=学問場
;		8=礼法の道場
;		9=休息

FUNC	PPT_EVENT_VIEW,PT_EVENT_VIEW
	CMP	DX,IVENT_VIEW_MAX	; イベントパターン数
	JNBE	PT_EVENT_VIEW_EXIT	;

;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

	MOV	NUM,DX			; パターン番号
	MOV	XX1,AX			; イベントウインドウＸ位置
	MOV	YY1,BX			; イベントウインドウＹ位置

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;
	CALL	FILE_INIT		; ロード初期化

	MOV	BX,NUM			; パターン番号
	SHL	BX,1			; word pointer.
	MOV	SI,DS:IVENT_VIEW[BX]	; イベントパターン
	CALLC	PATLDA			; パーツ追加ロード

	MOV	AX,1			; 1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	MOV	NUM,0			;
	CALL	PATTAN_PUT		; パターンＰＵＴ
	MOV	AX,0			; 0=通常
	CALLC	PATEFC			; パーツＰＵＴエフェクト

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
PT_EVENT_VIEW_EXIT:
	RET
FEND	PPT_EVENT_VIEW


;	行いイベントビュー
;	-I- AX : イベントウインドウＸ位置
;	    BX : イベントウインドウＹ位置
;	    DX : パターン番号
;		1=宿屋
;		2=メイド
;		3=代筆屋
;		4=酒場１
;		5=医者
;		6=狩人
;		7=武器屋
;		8=宿屋２
;		9=木コリ
;		10=教会
;		11=酒場２
;		12=人足

FUNC	PPT_EVENT_VWWK,PT_EVENT_VWWK
	CMP	DX,IVENT_VWWK_MAX	; 行いイベントパターン数
	JNBE	PT_EVENT_VWWK_EXIT	;

;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	DX
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
;*;	POP	DX
;*;	POP	BX
;*;	POP	AX

	MOV	NUM,DX			; パターン番号
	MOV	XX1,AX			; イベントウインドウＸ位置
	MOV	YY1,BX			; イベントウインドウＹ位置

	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;
	CALL	FILE_INIT		; ロード初期化

	MOV	DX,NUM			; パターン番号
	CALLC	DECSTR			; decimal -> string.
	MOVXB	IVENT_VWWK_NUM[0],DS:[SI][3]	; "09"<-"00009"
	MOVXB	IVENT_VWWK_NUM[1],DS:[SI][4]	; "09"<-"00009"
	MOV	SI,OFFSET IVENT_VWWK	; 行いイベントパターン "I1_01.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	AX,1			; 1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	MOV	NUM,0			;
	CALL	PATTAN_PUT		; パターンＰＵＴ
	MOV	AX,0			; 0=通常
	CALLC	PATEFC			; パーツＰＵＴエフェクト

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
PT_EVENT_VWWK_EXIT:
	RET
FEND	PPT_EVENT_VWWK


; ***********************************************
;	落ち関係
; ***********************************************

;	オチの絵ロード
;	-I- DX : 落ちの種類
;		1=女王
;		2=姫
;		3=長寿
;		4=将軍
;		5=王立アカデミー総裁
;		6=王宮魔法師
;		7=貴族の妻１
;		8=王の側室
;		9=司祭
;		10=騎士
;		11=近衛隊長
;		12=練金術師
;		13=魔道師
;		14=貴族の妻２
;		15=貴族の側室
;		16=上級尼僧
;		17=百姓の妻
;		18=木コリ
;		19=文士
;		20=魔法使い
;		21=商家の妻
;		22=酒場の女の子
;		23=尼僧
;		24=傭兵
;		25=賞金かせぎ
;		26=サギ師
;		27=旅の魔法使い
;		28=高級娼婦
;		29=売春婦
;		30=出戻り

FUNC	PPT_OCHI_LD,PT_OCHI_LD

;;CODE_IN
;;	PRV	"落ちの種類=",DX
;;CODE_OUT

	CALLC	DECSTR			; decimal -> string.
	MOVXB	OCHI_VIEW_FL_NM[0],DS:[SI][3]	; "09" <- "00009"
	MOVXB	OCHI_VIEW_FL_NM[1],DS:[SI][4]	;

	PAT_BANK	0		; ＢＡＮＫ＃０
	CALL	FILE_INIT		; ロード初期化

	MOV	OCHI_VIEW_FL_CT,'2'
	MOV	SI,OFFSET OCHI_VIEW_FL	; オチパターンファイル名 "L1_01.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	MOV	OCHI_VIEW_FL_CT,'3'
	MOV	SI,OFFSET OCHI_VIEW_FL	; オチパターンファイル名 "L1_01.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	PAT_BANK	12		; ＢＡＮＫ＃１２(＃１前半)
	CALL	FILE_INIT		; ロード初期化

	MOV	OCHI_VIEW_FL_CT,'1'
	MOV	SI,OFFSET OCHI_VIEW_FL	; オチパターンファイル名 "L1_01.PT1"
	CALLC	PATLDA			; パーツ追加ロード

	RET
FEND	PPT_OCHI_LD


;	オチの絵ＰＵＴ
;	-I- DX : 何番目か
;	    AX : イベントウインドウＸ位置
;	    BX : イベントウインドウＹ位置

FUNC	PPT_OCHI_PUT,PT_OCHI_PUT
	MOV	XX1,AX			; イベントウインドウＸ位置
	MOV	YY1,BX			; イベントウインドウＹ位置

;;CODE_IN
;;	PRV	"何番目=",DX
;;CODE_OUT

	CMP	DX,1			;
	JE	PT_OCHI_PUT_CUT1	;
	CMP	DX,2			;
	JE	PT_OCHI_PUT_CUT2	;
	CMP	DX,3			;
	JE	PT_OCHI_PUT_CUT3	;

PT_OCHI_PUT_CUT1:
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;
	MOV	NUM,0			;
	JMP	PT_OCHI_PUT_PUT		;
PT_OCHI_PUT_CUT2:
	PAT_BANK	0		; ＢＡＮＫ＃０
	PLSMD		1		;
	MOV	NUM,1			;
	JMP	PT_OCHI_PUT_PUT		;
PT_OCHI_PUT_CUT3:
	PAT_BANK	12		; ＢＡＮＫ＃１２(＃１前半)
	PLSMD		1		;
	MOV	NUM,0			;
PT_OCHI_PUT_PUT:
	MOV	AX,1			; 0=通常,1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	CALL	PATTAN_PUT		; パターンＰＵＴ
	MOV	AX,0			; 0=通常,1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	RET
FEND	PPT_OCHI_PUT


; ***********************************************
;	バカンス関係
; ***********************************************

;	バカンスの絵ロード
;	-I- DX : 少女（成長１,成長２,成長３,成長４）
;	    CX : 季節（1:春，2:夏，3:秋，4:冬）

FUNC	PPT_BACA_LD,PT_BACA_LD
	PUSH	CX
	INC	DX			;+1
	SHR	DX,1			; / 2 （成長１から８まで２ステップ）
	CALLC	DECSTR				; 1,2,3,4 (成長)
	MOVXB	FL_BACA_L_AGE,DS:[SI][4]	; "9"<-"00009"
	MOVXB	FL_BACA_R_AGE,DS:[SI][4]	; "9"<-"00009"
	POP	DX
	CALLC	DECSTR				; 1,2,3,4 (季節)
	MOVXB	FL_BACA_L_SEA,DS:[SI][4]	; "9"<-"00009"
	MOVXB	FL_BACA_R_SEA,DS:[SI][4]	; "9"<-"00009"

	PAT_BANK	0		; ＢＡＮＫ＃０
	CALL	FILE_INIT		; ロード初期化
	MOV	SI,OFFSET FL_BACA_L	; バカンス左 "XC1-01.PT1"
	CALLC	PATLDA			; パーツ追加ロード
	PAT_BANK	1		; ＢＡＮＫ＃１
	CALL	FILE_INIT		; ロード初期化
	MOV	SI,OFFSET FL_BACA_R	; バカンス右 "XC1-01.PT1"
	CALLC	PATLDA			; パーツ追加ロード
	RET
FEND	PPT_BACA_LD

;	バカンスの絵ＰＵＴ

FUNC	PPT_BACA_PUT,PT_BACA_PUT
	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	PLSMD		1		;
	PAT_BANK	0		; ＢＡＮＫ＃０
	MOV	NUM,1			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	PAT_BANK	1		; ＢＡＮＫ＃１
	MOV	NUM,1			; パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ
	PALET_SET	0		;
	RET
FEND	PPT_BACA_PUT


; ***********************************************
;	パターンＰＵＴ
;	-I- XX1 : ＰＵＴオフセット　Ｘ座標
;	    YY1 : ＰＵＴオフセット　Ｙ座標
;	    NUM : パターン番号
; ***********************************************

PATTAN_PUT	PROC	NEAR
	MOV	CX,NUM		; パターン番号
	CALLC	PATSIZ		; パーツサイズのＧＥＴ
	MOV	AX,VRX		; Ｘ座標
	MOV	BX,VRY		; Ｙ座標
	ADD	AX,XX1		; ＰＵＴ　Ｘ座標
	ADD	BX,YY1		; ＰＵＴ　Ｙ座標
	MOV	CX,NUM		; パターン番号
	CALL	MOUSE_STOP	; マウスカーソル退避

	PAT_PUT	NUM,XX1,YY1		; パターンＰＵＴ

	CALL	MOUSE_START	; マウスカーソル復帰
	RET
PATTAN_PUT	ENDP


; ***********************************************
;	パターンＰＵＴ座標指定
;	-I- XX1 : ＰＵＴＸ座標
;	    YY1 : ＰＵＴＹ座標
;	    NUM : パターン番号
; ***********************************************

PATTAN_PTX	PROC	NEAR
	MOV	CX,NUM		; パターン番号
	CALLC	PATSIZ		; パーツサイズのＧＥＴ
	MOV	AX,VRX		; Ｘ座標
	MOV	BX,VRY		; Ｙ座標
	ADD	AX,XX1		; ＰＵＴ　Ｘ座標
	ADD	BX,YY1		; ＰＵＴ　Ｙ座標
	MOV	CX,NUM		; パターン番号
	CALL	MOUSE_STOP	; マウスカーソル退避

	PAT_PTX	NUM,XX1,YY1		; パターンＰＵＴ

	CALL	MOUSE_START	; マウスカーソル復帰
	RET
PATTAN_PTX	ENDP


; ***********************************************
;	マスクパターンＰＵＴ
;	-I- XX1 : ＰＵＴ　Ｘ座標
;	    YY1 : ＰＵＴ　Ｙ座標
;	    NUM : パターン番号
; ***********************************************

MASK_PUT	PROC	NEAR
	MOV	AX,XX1		; ＰＵＴ　Ｘ座標
	MOV	BX,YY1		; ＰＵＴ　Ｙ座標
	MOV	CX,NUM		; パターン番号
	CALL	MOUSE_STOP	; マウスカーソル退避

	MOV	DX,1		;
	CALLC	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	MOVX	VRX,XX1		; Ｘ座標
	MOVX	VRY,YY1		; Ｙ座標
	MOV	CX,NUM		; マスク
	CALLC	PATPXM		; マスクパーツＰＵＴ座標指定

	MOVX	VRX,XX1		; Ｘ座標
	MOVX	VRY,YY1		; Ｙ座標
	MOV	CX,NUM		; 本体
	INC	CX		;
	CALLC	PATPTX		; パターンＰＵＴ

	MOV	DX,0		;
	CALLC	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	CALL	MOUSE_START	; マウスカーソル復帰
	RET
MASK_PUT	ENDP



; ***********************************************
;	マスクパターンオフセットＰＵＴ
;	-I- XX1 : オフセットＸ座標
;	    YY1 : オフセットＹ座標
;	    NUM : パターン番号
; ***********************************************

MASK_PTF	PROC	NEAR
	MOV	CX,NUM		; パターン番号
	CALLC	PATSIZ		; パーツサイズのＧＥＴ
	MOV	AX,VRX		; Ｘ座標
	MOV	BX,VRY		; Ｙ座標
	ADD	AX,XX1		; ＰＵＴ　Ｘ座標
	ADD	BX,YY1		; ＰＵＴ　Ｙ座標
	MOV	CX,NUM		; パターン番号
	CALL	MOUSE_STOP	; マウスカーソル退避

	MOV	DX,1		;
	CALLC	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	MOVX	VRX,XX1		; Ｘ座標
	MOVX	VRY,YY1		; Ｙ座標
	MOV	CX,NUM		; マスク
	CALLC	PATPFM		; マスクパーツＰＵＴオフセット指定

	MOVX	VRX,XX1		; Ｘ座標
	MOVX	VRY,YY1		; Ｙ座標
	MOV	CX,NUM		; 本体
	INC	CX		;
	CALLC	PATPTF		; パーツＰＵＴオフセット指定

	MOV	DX,0		;
	CALLC	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	CALL	MOUSE_START	; マウスカーソル復帰
	RET
MASK_PTF	ENDP



; ***********************************************
;	マウスカーソル退避
;	-I- AX         : ＰＵＴ　Ｘ座標
;	    BX         : ＰＵＴ　Ｙ座標
;	    CX         : パターン番号
;	-O- FLAG_MOUSE : 0=通常,1=マウス退避あり
; ***********************************************

MOUSE_STOP	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	VRX
	PUSH	VRY
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	CMP	FLAG_MOUSE2,1		; 0=通常,1=マウス退避あり
	JMPEQ	MOUSE_STOP_SKIP		;

	PUSH	AX			;
	PUSH	BX			;
	PUSH	CX			;
	CALLC	MSCSTS			; マウスカーソルステータス
	CMP	AX,0			; 0=マウスＯＦＦ
	POP	CX			;
	POP	BX			;
	POP	AX			;
	JMPEQ	MOUSE_STOP_SKIP		;


	MOV	NUM,CX			; パターン番号

	MOV	XX1,AX			; ＰＵＴＸ
	MOV	YY1,BX			; ＰＵＴＹ

	MOV	VRX,AX			; Ｘ座標
	MOV	VRY,BX			; Ｙ座標
	MOV	CX,NUM			; パターン番号
	CALLC	PATSIZ			; パーツサイズのＧＥＴ

	MOV	AX,XX1			; Ｘ１
	MOV	BX,YY1			; Ｙ１
	ADD	AX,VRLENX		;
	ADD	BX,VRLENY		;
	DEC	AX			;
	DEC	BX			;
	MOV	XX2,AX			; Ｘ２
	MOV	YY2,BX			; Ｙ２

	CALLC	MSCPNT			; カーソル表示位置
	ARACHK	XX1,YY1,XX2,YY2,MOUSE_STOP_EXIT
	XCHG	BX,DX			; Ｙ座標
	ARACHK	XX1,YY1,XX2,YY2,MOUSE_STOP_EXIT
	XCHG	AX,CX			; Ｘ座標
	ARACHK	XX1,YY1,XX2,YY2,MOUSE_STOP_EXIT
	XCHG	BX,DX			; Ｙ座標
	ARACHK	XX1,YY1,XX2,YY2,MOUSE_STOP_EXIT
	XCHG	AX,CX			; Ｘ座標
	ARACHK2	XX1,YY1,MOUSE_STOP_EXIT
	ARACHK2	XX2,YY1,MOUSE_STOP_EXIT
	ARACHK2	XX1,YY2,MOUSE_STOP_EXIT
	ARACHK2	XX2,YY2,MOUSE_STOP_EXIT

	ADD	AX,CX			; マウスの中心がパターンに乗る
	SHR	AX,1			; / 2
	ADD	BX,DX			; マウスの中心がパターンに乗る
	SHR	BX,1			; / 2
	ARACHK	XX1,YY1,XX2,YY2,MOUSE_STOP_EXIT

	JMP	MOUSE_STOP_SKIP		;

MOUSE_STOP_EXIT:

	CALLC	MSCSTP			; カーソルストップ

	MOV	FLAG_MOUSE,1		; 1=マウス退避あり

	JMP	MOUSE_STOP_FIN		;

MOUSE_STOP_SKIP:
	MOV	FLAG_MOUSE,0		; 0=通常

MOUSE_STOP_FIN:
	POP	NUM			;
	POP	YY1			;
	POP	XX1			;
	POP	VRY			;
	POP	VRX			;
	POP	DX			;
	POP	CX			;
	POP	BX			;
	POP	AX			;
	RET				;
MOUSE_STOP	ENDP



; ***********************************************
;	マウスカーソル復帰
;	-I/O- FLAG_MOUSE : 0=通常,1=マウス退避あり
; ***********************************************

MOUSE_START	PROC	NEAR
	CMP	FLAG_MOUSE2,1		; 0=通常,1=マウス退避あり
	JE	MOUSE_START_EXIT	;

	CMP	FLAG_MOUSE,0		; 0=通常,1=マウス退避あり
	JE	MOUSE_START_EXIT	;

	CALLC	MSCSRT			; カーソルスタート

	MOV	FLAG_MOUSE,0		; 0=通常
MOUSE_START_EXIT:
	RET
MOUSE_START	ENDP



; ***********************************************
;	マウスカーソル退避
;	-I- AX         : 左上Ｘ座標
;	    BX         : 左上Ｙ座標
;	    CX         : Ｘサイズ
;	    DX         : Ｙサイズ
; ***********************************************

FUNC	MMS_STOP,MS_STOP
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	VRX
	PUSH	VRY
	PUSH	XX1
	PUSH	YY1
	PUSH	NUM

	MOV	XX1,AX			; ＰＵＴＸ
	MOV	YY1,BX			; ＰＵＴＹ
	MOV	XX2,AX			; Ｘ２
	MOV	YY2,BX			; Ｙ２
	ADD	XX2,CX			; Ｘ２
	ADD	YY2,DX			; Ｙ２

	CALLC	MSCSTS			; マウスカーソルステータス
	CMP	AX,0			; 0=マウスＯＦＦ
	JMPEQ	MS_STOP_SKIP		;

	CALLC	MSCPNT			; カーソル表示位置

	ARACHK	XX1,YY1,XX2,YY2,MS_STOP_EXIT
	XCHG	BX,DX			; Ｙ座標
	ARACHK	XX1,YY1,XX2,YY2,MS_STOP_EXIT
	XCHG	AX,CX			; Ｘ座標
	ARACHK	XX1,YY1,XX2,YY2,MS_STOP_EXIT
	XCHG	BX,DX			; Ｙ座標
	ARACHK	XX1,YY1,XX2,YY2,MS_STOP_EXIT
	XCHG	AX,CX			; Ｘ座標
	ARACHK2	XX1,YY1,MS_STOP_EXIT
	ARACHK2	XX2,YY1,MS_STOP_EXIT
	ARACHK2	XX1,YY2,MS_STOP_EXIT
	ARACHK2	XX2,YY2,MS_STOP_EXIT

	JMP	MS_STOP_SKIP		;

MS_STOP_EXIT:
	CALLC	MSCSTP			; カーソルストップ

	MOV	FLAG_MOUSE2,1		; 1=マウス退避あり

	JMP	MS_STOP_FIN		;

MS_STOP_SKIP:
	MOV	FLAG_MOUSE2,0		; 0=通常

MS_STOP_FIN:
	POP	NUM			;
	POP	YY1			;
	POP	XX1			;
	POP	VRY			;
	POP	VRX			;
	POP	DX			;
	POP	CX			;
	POP	BX			;
	POP	AX			;
	RET				;
FEND	MMS_STOP


; ***********************************************
;	マウスカーソル退避（強制ＯＦＦ）
;	-I- AX         : 左上Ｘ座標
;	    BX         : 左上Ｙ座標
;	    CX         : Ｘサイズ
;	    DX         : Ｙサイズ
; ***********************************************

FUNC	MMS_STOP_S,MS_STOP_S
	CALLC	MSCSTP			; カーソルストップ
	MOV	FLAG_MOUSE2,1		; 1=マウス退避あり
	RET
FEND	MMS_STOP_S



; ***********************************************
;	マウスカーソル復帰
;	-I/O- FLAG_MOUSE2 : 0=通常,1=マウス退避あり
; ***********************************************

FUNC	MMS_START,MS_START
	CMP	FLAG_MOUSE2,0		; 0=通常,1=マウス退避あり
	JE	MS_START_EXIT		;

	CALLC	MSCSRT			; カーソルスタート

	MOV	FLAG_MOUSE2,0		; 0=通常
MS_START_EXIT:
	RET
FEND	MMS_START



; ***********************************************
;	ロード初期化
; ***********************************************

FILE_INIT	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	CALLC	PATCLR		; パーツセットクリア
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
FILE_INIT	ENDP

R_SEG2	ENDS


DATA	SEGMENT	WORD PUBLIC	'DATA'

EXTRN	ARA005:WORD		; 仮想ＶＲＡＭプレーン５（パーツ＃１/200）

EXTRN	W_GIRL_GROW:WORD	; 少女（成長１,成長２,成長３,成長４）

	EXTRN	GX1:WORD		; ＧＤＣ関係 ('GRBIO.ASM')
	EXTRN	GY1:WORD		;
	EXTRN	GX2:WORD		;
	EXTRN	GY2:WORD		;
	EXTRN	GMODE:WORD		;
	EXTRN	GCODE:WORD		;
	EXTRN	GCLR:WORD		;
	EXTRN	GRD:WORD		;

	EXTRN	SSGR0:WORD		; visual data segment plean 0
	EXTRN	SSGR1:WORD		; visual data segment plean 1
	EXTRN	SSGR2:WORD		; visual data segment plean 2
	EXTRN	SSGR3:WORD		; visual data segment plean 3

	EXTRN	SSDEST:WORD		; visual data segment plean.
	EXTRN	SSDES0:WORD		; visual data segment plean 0
	EXTRN	SSDES1:WORD		; visual data segment plean 1
	EXTRN	SSDES2:WORD		; visual data segment plean 2
	EXTRN	SSDES3:WORD		; visual data segment plean 3

	EXTRN	SSSOUR:WORD		; visual data segment plean.
	EXTRN	SSSOU0:WORD		; visual data segment plean 0
	EXTRN	SSSOU1:WORD		; visual data segment plean 1
	EXTRN	SSSOU2:WORD		; visual data segment plean 2
	EXTRN	SSSOU3:WORD		; visual data segment plean 3

	EXTRN	SSEFCT:WORD		; visual data segment plean.
	EXTRN	SSEFC0:WORD		; visual data segment plean 0
	EXTRN	SSEFC1:WORD		; visual data segment plean 1
	EXTRN	SSEFC2:WORD		; visual data segment plean 2
	EXTRN	SSEFC3:WORD		; visual data segment plean 3

	EXTRN	VX1:WORD		; source point x1.
	EXTRN	VY1:WORD		; source point y1.
	EXTRN	VX2:WORD		; length x2.
	EXTRN	VY2:WORD		; length y2.
	EXTRN	VX3:WORD		; destination point x3.
	EXTRN	VY3:WORD		; destination point y3.

	EXTRN	VCOL:WORD		; color.

	EXTRN	VRX:WORD		; x point.
	EXTRN	VRY:WORD		; y point.

	EXTRN	VRLENX:WORD		; x length.
	EXTRN	VRLENY:WORD		; y length.

	EXTRN	ARAVRM:WORD		; ＶＲＡＭプレーン
	EXTRN	ARA001:WORD		; 仮想ＶＲＡＭプレーン１
	EXTRN	ARA002:WORD		; 仮想ＶＲＡＭプレーン２
	EXTRN	ARA003:WORD		; 仮想ＶＲＡＭ３（２００ライン）

	EXTRN	CLRCDE:WORD		; color code.
	EXTRN	CLRVEW:WORD		; color view.
	EXTRN	CLRCNS:WORD		; contrast.
	EXTRN	CLRBRI:WORD		; brightness.

	EXTRN	CRXVEW:WORD		; 色相回転（０ー３６０）
	EXTRN	CRXCNS:WORD		; 彩度倍率（０ー１００）
	EXTRN	CRXBRI:WORD		; 明度倍率（０ー１００）
	EXTRN	CRXWHI:WORD		; ホワイトレベル（０ー１００）

	EXTRN	CBLUE:WORD		; blue  value (0-15)
	EXTRN	CRED:WORD		; red   value (0-15)
	EXTRN	CGREEN:WORD		; green value (0-15)

	EXTRN	CLRSOU:WORD		; 変更カラーパレット
	EXTRN	CLRDES:WORD		; 変更後カラーパレット

	EXTRN	CRTSKP:WORD		; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)

	EXTRN	WDXX:WORD		; WINDOWS/point x.
	EXTRN	WDYY:WORD		; WINDOWS/point y.
	EXTRN	WDX1:WORD		; WINDOWS/ point x1.
	EXTRN	WDY1:WORD		; WINDOWS/ point y1.
	EXTRN	WDX2:WORD		; WINDOWS/ point x2.
	EXTRN	WDY2:WORD		; WINDOWS/ point y2.
	EXTRN	WDHNO:WORD		; WINDOWS/ヘッダー番号
	EXTRN	WDGNO:WORD		; WINDOWS/横グラフ番号
	EXTRN	WDVNO:WORD		; WINDOWS/内容表示番号
	EXTRN	WDSTR:WORD		; WINDOWS/表示パラメータ名
	EXTRN	WDVAL:WORD		; WINDOWS/表示値
	EXTRN	WDBLNC:WORD		; WINDOWS/表示バランス値
	EXTRN	WDNAME:WORD		; WINDOWS/表示名前
	EXTRN	WDTIME:WORD		; WINDOWS/表示時間値
	EXTRN	WDINO:WORD		; WINDOWS/アイテムオフセット
	EXTRN	WDILIST:WORD		; WINDOWS/スタイルリストオフセット
	EXTRN	WDP_VAL:WORD		; WINDOWS/内容表示値
	EXTRN	WDP_UNIT:WORD		; WINDOWS/内容表示単位系
	EXTRN	WD_NONE_CHR:BYTE	; WINDOWS/無効キャラクタ
	EXTRN	WDTXTSEG:WORD		; WINDOWS/表示文字列セグメント
	EXTRN	WDTXTADR:WORD		; WINDOWS/表示文字列アドレス
	EXTRN	WDBTNNUM:WORD		; WINDOWS/選択ボタン番号
	EXTRN	WDBTNPUSH:WORD		; WINDOWS/ボタン押した
	EXTRN	WDMSX:WORD		; WINDOWS/マウスＸ
	EXTRN	WDMSY:WORD		; WINDOWS/マウスＹ
	EXTRN	WDMSL:WORD		; WINDOWS/マウス左ボタン
	EXTRN	WDMSR:WORD		; WINDOWS/マウス右ボタン
	EXTRN	WDPCLM:WORD		; WINDOWS/順序
	EXTRN	WDPLIN:WORD		; WINDOWS/行

	EXTRN	W_COL1:WORD		; WINDOWS/カラー・ハイライト
	EXTRN	W_COL2:WORD		; WINDOWS/カラー・明るい灰
	EXTRN	W_COL3:WORD		; WINDOWS/カラー・暗い灰
	EXTRN	W_COL4:WORD		; WINDOWS/カラー・黒
	EXTRN	W_COL5:WORD		; WINDOWS/カラー・暗い色

	EXTRN	ATMSEG:WORD		; WINDOWS/テキストバッファセグメント
	EXTRN	ATMTBL:WORD		; WINDOWS/表示単語アドレス
	EXTRN	ATMTLN:WORD		; WINDOWS/表示単語長さ
	EXTRN	ATMVAL:WORD		; WINDOWS/表示単語の数値
	EXTRN	ATMMAX:WORD		; WINDOWS/表示単語の数
	EXTRN	ATMDIM:WORD	 	; WINDOWS/表示単語のテーブルサイズ

	EXTRN	STR_BUFF:BYTE		; 文字列バッファ
	EXTRN	STR_VAL_BUFF:BYTE	; 表示値文字列バッファ

GIRL_OFS_TBL	LABEL	BYTE		; 娘の表示位置オフセット
		DB	0		;base.
		DB	-2		;1/10
		DB	+2		;2/11
		DB	0		;3/12
		DB	0		;4/13
		DB	0		;5/14
		DB	+6		;6/15
		DB	0		;7/16
		DB	+6		;8/17
		EVEN

XX1		DW	0
YY1		DW	0
XX2		DW	0
YY2		DW	0
NUM		DW	0

BGNUM		DW	0		; ＢＧ番号
TONUM		DW	0		; 闘士番号
SHNUM		DW	0		; 師範番号
MNNUM		DW	0		; モンスター番号
GLNUM		DW	0		; ムスメ番号
FCNUM		DW	0		; フェイス番号

NUM_MONTH	DW	0		; ｍｏｎｔｈ
NUM_WEEK	DW	0		; ｗｅｅｋ
NUM_DAYS	DW	0		; ｄａｙｓ

FLAG_MOUSE	DW	0		; 0=通常,1=マウス退避あり
FLAG_MOUSE2	DW	0		; 0=通常,1=マウス退避あり

CBASE_MAX	DW	8		; キャラ成長数
CBASE_DMAX	DW	4		; キャラ服パターン数
CBASE_FMAX	DW	3		; キャラ顔パターン数

CBASE_BD	DB	"CB"		; キャラ体ファイル名
CBASE_BDSC	DB	"?",0		; キャラ体成長

CBASE_DRESS	DB	"CB"		; キャラ服ファイル名
CBASE_DSC	DB	"?D"		; キャラ服成長
CBASE_DSEE	DB	"?",0		; キャラ服季節

CBASE_FACE	DB	"CB"		; キャラ顔ファイル名
CBASE_FSC	DB	"?F"		; キャラ顔成長
CBASE_FSEE	DB	"?",0		; キャラ顔季節

IVENT_VIEW_MAX	DW	9		; イベントパターン数
IVENT_VIEW	LABEL	WORD		; イベントパターン
		DW	OFFSET IVE_01	;**0
		DW	OFFSET IVE_01	;1=王様との会見
		DW	OFFSET IVE_02	;2=町の評判
		DW	OFFSET IVE_03	;3=ステータス
		DW	OFFSET IVE_04	;4=娘と話す
		DW	OFFSET IVE_05	;5=買物
		DW	OFFSET IVE_06	;6=武芸道場
		DW	OFFSET IVE_07	;7=学問場
		DW	OFFSET IVE_08	;8=礼法の道場
		DW	OFFSET IVE_09	;9=休息
IVE_01	DB	"I4_01",0
IVE_02	DB	"I4_02",0
IVE_03	DB	"I4_03",0
IVE_04	DB	"I4_04",0
IVE_05	DB	"I4_05",0
IVE_06	DB	"I2_01",0
IVE_07	DB	"I2_02",0
IVE_08	DB	"I2_03",0
IVE_09	DB	"I3_01",0

IVENT_VWWK_MAX	DW	12		; 行いイベントパターン数
IVENT_VWWK	DB	"I1_"		; 行いイベントパターン
IVENT_VWWK_NUM	DB	"??",0		; 行いイベントパターン

FL_TOHS_MAX	DW	24		; 闘士ＭＡＸ
FL_TOHS		DB	"E1_"		; フェイス "E1_00.PT1"
FL_TOHS_NUM	DB	"??",0		; 闘士番号

FL_SHIHAN_MAX	DW	3		; 師範ＭＡＸ
FL_SHIHAN	DB	"E3_"		; フェイス "E3_00.PT1"
FL_SHIHAN_NUM	DB	"??",0		; 師範番号

;*;FL_TOHS	LABEL	WORD		; 闘士
;*;		DW	OFFSET THS_00	;
;*;		DW	OFFSET THS_00	; 闘士番号１は自分の娘
;*;		DW	OFFSET THS_01
;*;		DW	OFFSET THS_02
;*;		DW	OFFSET THS_03
;*;		DW	OFFSET THS_04
;*;		DW	OFFSET THS_05
;*;		DW	OFFSET THS_06
;*;		DW	OFFSET THS_07
;*;		DW	OFFSET THS_08
;*;		DW	OFFSET THS_09
;*;		DW	OFFSET THS_10
;*;		DW	OFFSET THS_11
;*;		DW	OFFSET THS_12
;*;		DW	OFFSET THS_13
;*;		DW	OFFSET THS_14
;*;		DW	OFFSET THS_15
;*;		DW	OFFSET THS_16
;*;		DW	OFFSET THS_17
;*;		DW	OFFSET THS_18
;*;		DW	OFFSET THS_19
;*;		DW	OFFSET THS_20
;*;		DW	OFFSET THS_21
;*;		DW	OFFSET THS_22
;*;		DW	OFFSET THS_23
;*;THS_00	DB	"E1_00",0
;*;THS_01	DB	"E1_01",0
;*;THS_02	DB	"E1_02",0
;*;THS_03	DB	"E1_03",0
;*;THS_04	DB	"E1_04",0
;*;THS_05	DB	"E1_05",0
;*;THS_06	DB	"E1_06",0
;*;THS_07	DB	"E1_07",0
;*;THS_08	DB	"E1_08",0
;*;THS_09	DB	"E1_09",0
;*;THS_10	DB	"E1_10",0
;*;THS_11	DB	"E1_11",0
;*;THS_12	DB	"E1_12",0
;*;THS_13	DB	"E1_13",0
;*;THS_14	DB	"E1_14",0
;*;THS_15	DB	"E1_15",0
;*;THS_16	DB	"E1_16",0
;*;THS_17	DB	"E1_17",0
;*;THS_18	DB	"E1_18",0
;*;THS_19	DB	"E1_19",0
;*;THS_20	DB	"E1_20",0
;*;THS_21	DB	"E1_21",0
;*;THS_22	DB	"E1_22",0
;*;THS_23	DB	"E1_23",0

FL_TK_MAX	DW	10		; モンスターＭＡＸ
FL_TK		DB	"E2_"		; モンスター "E2_01.PT1"
FL_TK_NUM	DB	"??",0		; モンスター番号

;*;FL_TK		LABEL	WORD		; モンスター
;*;		DW	OFFSET TKF_01	;**0
;*;		DW	OFFSET TKF_01
;*;		DW	OFFSET TKF_02
;*;		DW	OFFSET TKF_03
;*;		DW	OFFSET TKF_04
;*;		DW	OFFSET TKF_05
;*;		DW	OFFSET TKF_06
;*;		DW	OFFSET TKF_07
;*;		DW	OFFSET TKF_08
;*;		DW	OFFSET TKF_09
;*;		DW	OFFSET TKF_10
;*;TKF_01	DB	"E2_01",0
;*;TKF_02	DB	"E2_02",0
;*;TKF_03	DB	"E2_03",0		; 山猫
;*;TKF_04	DB	"E2_04",0
;*;TKF_05	DB	"E2_05",0		; オーク
;*;TKF_06	DB	"E2_06",0
;*;TKF_07	DB	"E2_07",0
;*;TKF_08	DB	"E2_08",0
;*;TKF_09	DB	"E2_09",0		; トラ
;*;TKF_10	DB	"E2_10",0		; ドラゴン

FL_MYGL_F_SCC	DB	"F4_0"		; フェイス・成功 "F4_01"
FL_MYGL_F_SCC_N	DB	"1",0		;

FL_MYGL_F_SPP	DB	"F5_0"		; フェイス・失敗 "F5_01"
FL_MYGL_F_SPP_N	DB	"1",0		;

FL_FACE_MAX	DW	31		; フェイスＭＡＸ
FL_FACE		DB	"F"		; フェイス "F1_01.PT1"
FL_FACE_CUT	DB	"1_"		; フェイスカット番号
FL_FACE_NUM	DB	"??",0		; フェイス番号

;*;FL_FACE	LABEL	WORD		; フェイスヘッド番号
;*;	DW	OFFSET FACE_01		;**0
;*;
;*;	DW	OFFSET FACE_01		; 衛兵
;*;	DW	OFFSET FACE_02		; 近衛隊長
;*;	DW	OFFSET FACE_03		; 侍従
;*;	DW	OFFSET FACE_04		; 侍従長
;*;	DW	OFFSET FACE_05		; 王妃様
;*;	DW	OFFSET FACE_06		; 王様
;*;
;*;	DW	OFFSET FACE_07		; 武芸師範１
;*;	DW	OFFSET FACE_08		; 武芸師範２
;*;	DW	OFFSET FACE_09		; 武芸師範３
;*;	DW	OFFSET FACE_10		; 学問場の先生
;*;	DW	OFFSET FACE_11		; 礼法の先生
;*;
;*;	DW	OFFSET FACE_12		; 宿屋
;*;	DW	OFFSET FACE_13		; メイド
;*;	DW	OFFSET FACE_14		; 代筆屋
;*;	DW	OFFSET FACE_15		; 酒場１
;*;	DW	OFFSET FACE_16		; 医者
;*;	DW	OFFSET FACE_17		; 狩人
;*;	DW	OFFSET FACE_18		; 武器屋
;*;	DW	OFFSET FACE_19		; 宿屋２
;*;	DW	OFFSET FACE_20		; 木コリ
;*;	DW	OFFSET FACE_21		; 教会
;*;	DW	OFFSET FACE_22		; 酒場２
;*;	DW	OFFSET FACE_23		; 人足
;*;
;*;	DW	OFFSET FACE_24		; 主人公１０－１２成功
;*;	DW	OFFSET FACE_25		; 主人公１２－１４成功
;*;	DW	OFFSET FACE_26		; 主人公１４－１６成功
;*;	DW	OFFSET FACE_27		; 主人公１６－１８成功
;*;
;*;	DW	OFFSET FACE_28		; 主人公１０－１２失敗
;*;	DW	OFFSET FACE_29		; 主人公１２－１４失敗
;*;	DW	OFFSET FACE_30		; 主人公１４－１６失敗
;*;	DW	OFFSET FACE_31		; 主人公１６－１８失敗
;*;
;*;FACE_01	DB	"F1_01",0	; 衛兵
;*;FACE_02	DB	"F1_02",0	; 近衛隊長
;*;FACE_03	DB	"F1_03",0	; 侍従
;*;FACE_04	DB	"F1_04",0	; 侍従長
;*;FACE_05	DB	"F1_05",0	; 王妃様
;*;FACE_06	DB	"F1_06",0	; 王様
;*;FACE_07	DB	"F2_01",0	; 武芸師範１
;*;FACE_08	DB	"F2_02",0	; 武芸師範２
;*;FACE_09	DB	"F2_03",0	; 武芸師範３
;*;FACE_10	DB	"F2_04",0	; 学問場の先生
;*;FACE_11	DB	"F2_05",0	; 礼法の先生
;*;FACE_12	DB	"F3_01",0	; 宿屋
;*;FACE_13	DB	"F3_02",0	; メイド
;*;FACE_14	DB	"F3_03",0	; 代筆屋
;*;FACE_15	DB	"F3_04",0	; 酒場１
;*;FACE_16	DB	"F3_05",0	; 医者
;*;FACE_17	DB	"F3_06",0	; 狩人
;*;FACE_18	DB	"F3_07",0	; 武器屋
;*;FACE_19	DB	"F3_08",0	; 宿屋２
;*;FACE_20	DB	"F3_09",0	; 木コリ
;*;FACE_21	DB	"F3_10",0	; 教会
;*;FACE_22	DB	"F3_11",0	; 酒場２
;*;FACE_23	DB	"F3_12",0	; 人足
;*;FACE_24	DB	"F4_01",0	; 主人公１０－１２成功
;*;FACE_25	DB	"F4_02",0	; 主人公１２－１４成功
;*;FACE_26	DB	"F4_03",0	; 主人公１４－１６成功
;*;FACE_27	DB	"F4_04",0	; 主人公１６－１８成功
;*;FACE_28	DB	"F5_01",0	; 主人公１０－１２失敗
;*;FACE_29	DB	"F5_02",0	; 主人公１２－１４失敗
;*;FACE_30	DB	"F5_03",0	; 主人公１４－１６失敗
;*;FACE_31	DB	"F5_04",0	; 主人公１６－１８失敗


FL_MISS_DISK_F	DB	"P","2","3","4"	;ﾌｧｲﾙ末尾(成長１,成長２,成長３,成長４)
FL_MISSCON_MAX	DW	17+1		; ミスコンＭＡＸ
FL_MISC		DB	"MC_"		; ミスコン "MC_nn_x.PT1"
FL_MISC_NUM	DB	"nn",0		; ミスコン メンバ
;*;FL_MISC_AGE	DB	"P",0		; ミスコン 1,2,3,4(成長)

;*;FL_MISSCON	LABEL	WORD		; ミスコン
;*;	DW	OFFSET MISC_01		;**0
;*;	DW	OFFSET MISC_MY			; 1:自分の娘
;*;	DW	OFFSET MISC_01			; 2:
;*;	DW	OFFSET MISC_02			; 3:
;*;	DW	OFFSET MISC_03			; 4:
;*;	DW	OFFSET MISC_04			; .
;*;	DW	OFFSET MISC_05			; .
;*;	DW	OFFSET MISC_06			; .
;*;	DW	OFFSET MISC_07			; .
;*;	DW	OFFSET MISC_08
;*;	DW	OFFSET MISC_09
;*;	DW	OFFSET MISC_10
;*;	DW	OFFSET MISC_11
;*;	DW	OFFSET MISC_12
;*;	DW	OFFSET MISC_13
;*;	DW	OFFSET MISC_14
;*;	DW	OFFSET MISC_15
;*;	DW	OFFSET MISC_16
;*;	DW	OFFSET MISC_17			; 18:
;*;MISC_MY	DB	"MC_MY_x",0
;*;MISC_01	DB	"MC_01_x",0			; 'x'は書き換えられる
;*;MISC_02	DB	"MC_02_x",0
;*;MISC_03	DB	"MC_03_x",0
;*;MISC_04	DB	"MC_04_x",0
;*;MISC_05	DB	"MC_05_x",0
;*;MISC_06	DB	"MC_06_x",0
;*;MISC_07	DB	"MC_07_x",0
;*;MISC_08	DB	"MC_08_x",0
;*;MISC_09	DB	"MC_09_x",0
;*;MISC_10	DB	"MC_10_x",0
;*;MISC_11	DB	"MC_11_x",0
;*;MISC_12	DB	"MC_12_x",0
;*;MISC_13	DB	"MC_13_x",0
;*;MISC_14	DB	"MC_14_x",0
;*;MISC_15	DB	"MC_15_x",0
;*;MISC_16	DB	"MC_16_x",0
;*;MISC_17	DB	"MC_17_x",0


FL_BG_MAX	DW	6		; ＢＧＭＡＸ

FL_BG_LEFT	LABEL	WORD		; ＢＧ
		DW	OFFSET FL_BG_LEFT1	; 0
		DW	OFFSET FL_BG_LEFT1
		DW	OFFSET FL_BG_LEFT2
		DW	OFFSET FL_BG_LEFT3
		DW	OFFSET FL_BG_LEFT4
FL_BG_RIGHT	LABEL	WORD
		DW	OFFSET FL_BG_RIGHT1	; 0
		DW	OFFSET FL_BG_RIGHT1
		DW	OFFSET FL_BG_RIGHT2
		DW	OFFSET FL_BG_RIGHT3
		DW	OFFSET FL_BG_RIGHT4

FL_BG_LEFT1	LABEL	WORD		; ＢＧ
		DW	OFFSET BGF_1L1
		DW	OFFSET BGF_1L1
		DW	OFFSET BGF_2L1
		DW	OFFSET BGF_1L1	;3 kill
		DW	OFFSET BGF_1L1	;4 kill
		DW	OFFSET BGF_1L1	;5 kill
		DW	OFFSET BGF_6L
FL_BG_RIGHT1	LABEL	WORD
		DW	OFFSET BGF_1R1
		DW	OFFSET BGF_1R1
		DW	OFFSET BGF_2R1
		DW	OFFSET BGF_1R1	;3 kill
		DW	OFFSET BGF_1R1	;4 kill
		DW	OFFSET BGF_1R1	;5 kill
		DW	OFFSET BGF_6R
BGF_1L1	DB	"MBG1L",0		; メインＢＧ・春・左側
BGF_1R1	DB	"MBG1R",0		; メインＢＧ・春・右側
BGF_2L1	DB	"MBG2L",0		; メインＢＧ・武闘会・左側
BGF_2R1	DB	"MBG2R",0		; メインＢＧ・武闘会・右側
BGF_6L	DB	"MBG6L",0		; メインＢＧ・武芸
BGF_6R	DB	"MBG6R",0		; メインＢＧ・武芸

FL_BG_LEFT2	LABEL	WORD		; ＢＧ
		DW	OFFSET BGF_1L2
		DW	OFFSET BGF_1L2
		DW	OFFSET BGF_2L2
		DW	OFFSET BGF_1L1	;3 kill
		DW	OFFSET BGF_1L1	;4 kill
		DW	OFFSET BGF_1L1	;5 kill
		DW	OFFSET BGF_6L
FL_BG_RIGHT2	LABEL	WORD
		DW	OFFSET BGF_1R2
		DW	OFFSET BGF_1R2
		DW	OFFSET BGF_2R2
		DW	OFFSET BGF_1R1	;3 kill
		DW	OFFSET BGF_1R1	;4 kill
		DW	OFFSET BGF_1R1	;5 kill
		DW	OFFSET BGF_6R
BGF_1L2	DB	"MBG1L_2",0		; メインＢＧ・春・左側
BGF_1R2	DB	"MBG1R_2",0		; メインＢＧ・春・右側
BGF_2L2	DB	"MBG2L",0		; メインＢＧ・武闘会・左側
BGF_2R2	DB	"MBG2R",0		; メインＢＧ・武闘会・右側

FL_BG_LEFT3	LABEL	WORD		; ＢＧ
		DW	OFFSET BGF_1L3
		DW	OFFSET BGF_1L3
		DW	OFFSET BGF_2L3
		DW	OFFSET BGF_1L1	;3 kill
		DW	OFFSET BGF_1L1	;4 kill
		DW	OFFSET BGF_1L1	;5 kill
		DW	OFFSET BGF_6L
FL_BG_RIGHT3	LABEL	WORD
		DW	OFFSET BGF_1R3
		DW	OFFSET BGF_1R3
		DW	OFFSET BGF_2R3
		DW	OFFSET BGF_1R1	;3 kill
		DW	OFFSET BGF_1R1	;4 kill
		DW	OFFSET BGF_1R1	;5 kill
		DW	OFFSET BGF_6R
BGF_1L3	DB	"MBG1L_3",0		; メインＢＧ・春・左側
BGF_1R3	DB	"MBG1R_3",0		; メインＢＧ・春・右側
BGF_2L3	DB	"MBG2L",0		; メインＢＧ・武闘会・左側
BGF_2R3	DB	"MBG2R",0		; メインＢＧ・武闘会・右側

FL_BG_LEFT4	LABEL	WORD		; ＢＧ
		DW	OFFSET BGF_1L4
		DW	OFFSET BGF_1L4
		DW	OFFSET BGF_2L4
		DW	OFFSET BGF_1L1	;3 kill
		DW	OFFSET BGF_1L1	;4 kill
		DW	OFFSET BGF_1L1	;5 kill
		DW	OFFSET BGF_6L
FL_BG_RIGHT4	LABEL	WORD
		DW	OFFSET BGF_1R4
		DW	OFFSET BGF_1R4
		DW	OFFSET BGF_2R4
		DW	OFFSET BGF_1R1	;3 kill
		DW	OFFSET BGF_1R1	;4 kill
		DW	OFFSET BGF_1R1	;5 kill
		DW	OFFSET BGF_6R
BGF_1L4	DB	"MBG1L_4",0		; メインＢＧ・春・左側
BGF_1R4	DB	"MBG1R_4",0		; メインＢＧ・春・右側
BGF_2L4	DB	"MBG2L",0		; メインＢＧ・武闘会・左側
BGF_2R4	DB	"MBG2R",0		; メインＢＧ・武闘会・右側

OCHI_VIEW_FL	DB	"L"		; オチパターンファイル名 "L1_01.PT1"
OCHI_VIEW_FL_CT	DB	"?_"		; "?"  -> 1 から 3
OCHI_VIEW_FL_NM DB	"??",0		; "??" -> 00 から 30

FL_BACA_L	DB	"XC"		; バカンス左 "XC1-01.PT1"
FL_BACA_L_AGE	DB	"?-0"		; バカンス左1,2,3,4(成長)
FL_BACA_L_SEA	DB	"?",0		; バカンス左1,2,3,4(季節)

FL_BACA_R	DB	"WC"		; バカンス右
FL_BACA_R_AGE	DB	"?-0"		; バカンス左1,2,3,4(成長)
FL_BACA_R_SEA	DB	"?",0		; バカンス左1,2,3,4(季節)

FL_PAT10SX	DB	"PAT10S"	; 収穫祭
FL_PAT10SX_NUM	DB	"?",0		; 

DATA	ENDS

INCLUDE	PICTUER.INC

	END
;
;	end of "PICTUER.ASM"
;
