; "WIDFACE.ASM" PC-9801UV11 make by R.H 1990/11/20
;
;
;	ＷＩＮＤＯＷＳ／フェイスウインドウ
;
;
;	WIDFACE_INIT		; WINDOWS/フェイスウインドウ初期処理
;	WIDFACE_OPEN		; WINDOWS/フェイスウインドウＯＰＥＮ
;	WIDFACE_CLOSE		; WINDOWS/フェイスウインドウＣＬＯＳＥ
;	WIDFACE_OPEN_VEW	; WINDOWS/会見フェイスウインドウＯＰＥＮ
;	WIDFACE_CLOSE_VEW	; WINDOWS/会見フェイスウインドウＣＬＯＳＥ
;	WIDFACE_OPEN_W		; WINDOWS/行いフェイスＯＰＥＮ
;	WIDFACE_CLOSE_W		; WINDOWS/行いフェイスＣＬＯＳＥ
;	WIDFACE_OPEN_OH		; WINDOWS/王様ウインドウＯＰＥＮ
;	WIDFACE_OPEN_M		; WINDOWS/ミスコンフェイスＯＰＥＮ
;	WIDFACE_LOAD_M_ONLY	; WINDOWS/ミスコンフェイスＬＯＡＤ ＯＮＬＹ
;	WIDFACE_PUT_M_ONLY	; WINDOWS/ミスコンフェイスＰＵＴ ＯＮＬＹ
;
;	WIDFACE_OPEN_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＯＰＥＮ
;	WIDFACE_CLOSE_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＣＬＯＳＥ
;	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

NORMAL_BANK	EQU	0	; 通常のパーツバンク番号
BACKSAVE_BANK	EQU	1	; 背景退避用パーツバンク番号

KAIKEN_LOC_X	EQU	34-1	; 会見ウインドウＸ位置
KAIKEN_LOC_Y	EQU	30*8-4	; 会見ウインドウＹ位置
KAIKEN_SIZ_X	EQU	12+2	; 会見ウインドウＸサイズ
KAIKEN_SIZ_Y	EQU	104+16	; 会見ウインドウＹサイズ

OKONAI_LOC_X	EQU	34-1	; 行いウインドウＸ位置
OKONAI_LOC_Y	EQU	30*8-4	; 行いウインドウＹ位置
OKONAI_SIZ_X	EQU	12+2	; 行いウインドウＸサイズ
OKONAI_SIZ_Y	EQU	104+16	; 行いウインドウＹサイズ

MY_GIRL_LOC_X	EQU	36	; ＧＩＲＬウインドウ成功失敗顔Ｘ位置
MY_GIRL_LOC_Y	EQU	144+16	; ＧＩＲＬウインドウ成功失敗顔Ｙ位置
MY_GIRL_SIZ_X	EQU	12+2	; ＧＩＲＬウインドウ成功失敗顔Ｘサイズ
MY_GIRL_SIZ_Y	EQU	104+18	; ＧＩＲＬウインドウ成功失敗顔Ｙサイズ


;	ＷＩＮＤＯＷ　から　ＣＯＤＥ　へ　ＣＡＬＬ

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
	ASSUME	CS:WINDOW,DS:DATA
L1:	CALL	L2
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチン

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS

	ASSUME	CS:WINDOW,DS:DATA

SUBLL	PROC	FAR
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチンの終り

FEND	MACRO	SUBLL
SUBLL	ENDP
	ENDM

;	ＷＩＮＤＯＷセグメントからＣＯＤＥセグメントへ

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

;	ＣＯＤＥセグメントからＷＩＮＤＯＷセグメントへ

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:
	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

MOVXBW	MACRO	DEST,SOUR
	MOV	AH,0
	MOV	AL,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/フェイスウインドウ初期処理
; ****************************************************

FUNC	WWIDFACE_INIT,WIDFACE_INIT
	RET
FEND	WWIDFACE_INIT


; ****************************************************
;	WINDOWS/フェイスウインドウＯＰＥＮ
;	-I- DX : フェイス絵の番号
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
; ****************************************************

FUNC	WWIDFACE_OPEN,WIDFACE_OPEN
	MOV	AX,0			; ＰＵＴ　Ｘ座標
	MOV	BX,0			; ＰＵＴ　Ｙ座標
	CALLC	PT_FACE			; フェイスＰＵＴ
	RET
FEND	WWIDFACE_OPEN


; ****************************************************
;	WINDOWS/フェイスウインドウＣＬＯＳＥ
; ****************************************************

FUNC	WWIDFACE_CLOSE,WIDFACE_CLOSE
	CODE_IN
	LC	0,1
	PRF	"フェイスウインドウＣＬＯＳＥ"
	CODE_OUT
	RET
FEND	WWIDFACE_CLOSE


; ****************************************************
;	WINDOWS/会見フェイスウインドウＯＰＥＮ
;	-I- DX : フェイス絵の番号
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
; ****************************************************

FUNC	WWIDFACE_OPEN_VEW,WIDFACE_OPEN_VEW
	MOV	KAI_PAT_NUM,DX		; 会見パターン番号

	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	MOVX	WDX1,KAI_BACK_X1	; 会見退避左上Ｘ
	MOVX	WDY1,KAI_BACK_Y1	; 会見退避左上Ｙ
	MOVX	WDX2,KAI_BACK_X2	; 会見退避サイズＸ
	MOVX	WDY2,KAI_BACK_Y2	; 会見退避サイズＹ
	CALLC	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ

	MOVX	WDX1,KAI_FREM_X		; 会見ウインドウフレームＸ座標
	MOVX	WDY1,KAI_FREM_Y		; 会見ウインドウフレームＹ座標
	MOVX	WDX2,KAI_FREM_XL	; 会見ウインドウフレームサイズＸ
	MOVX	WDY2,KAI_FREM_YL	; 会見ウインドウフレームサイズＹ
	CALLC	WID_8_FLAME		; WINDOWS/フレーム８（フェイス）

	MOV	AX,KAI_POINT_X1		; 会見ウインドウＸ位置
	MOV	BX,KAI_POINT_Y1		; 会見ウインドウＹ位置
	MOV	DX,KAI_PAT_NUM		; 会見パターン番号
	CALLC	PT_FACE			; フェイスＰＵＴ

	RET
FEND	WWIDFACE_OPEN_VEW


; ****************************************************
;	WINDOWS/会見フェイスウインドウＣＬＯＳＥ
; ****************************************************

FUNC	WWIDFACE_CLOSE_VEW,WIDFACE_CLOSE_VEW
	CALLC	WIDFRM_BACKLOAD		; WINDOWS/背景をロード
	RET
FEND	WWIDFACE_CLOSE_VEW


; ****************************************************
;	WINDOWS/行いフェイスＯＰＥＮ
;	-I- DI : 種類
;	         1=城の人々
;	         2=武芸師範
;	         3=学問場の先生
;	         4=礼法の先生
;	         5=アルバイトの雇主
;	         6=主人公成功
;		 7=主人公失敗
;	    SI : 誰か（テーブル FACE_TBL_KIND を見ろ）
; ****************************************************

FUNC	WWIDFACE_OPEN_W,WIDFACE_OPEN_W
	MOV	FACE_KIND,DI		; フェイスの種類
	MOV	FACE_WHO,SI		; フェイス誰か

	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	MOVX	WDX1,OKO_BACK_X1	; 行い退避左上Ｘ
	MOVX	WDY1,OKO_BACK_Y1	; 行い退避左上Ｙ
	MOVX	WDX2,OKO_BACK_X2	; 行い退避サイズＸ
	MOVX	WDY2,OKO_BACK_Y2	; 行い退避サイズＹ
	CALLC	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ

	MOVX	WDX1,OKO_FREM_X		; 行いウインドウフレームＸ座標
	MOVX	WDY1,OKO_FREM_Y		; 行いウインドウフレームＹ座標
	MOVX	WDX2,OKO_FREM_XL	; 行いウインドウフレームサイズＸ
	MOVX	WDY2,OKO_FREM_YL	; 行いウインドウフレームサイズＹ
	CALLC	WID_8_FLAME		; WINDOWS/フレーム８（フェイス）

	MOV	DI,FACE_KIND		; フェイスの種類
	MOV	SI,FACE_WHO		; フェイス誰か
	CMP	DI,0
	JNE	WIDFACE_OPEN_W_1
	MOV	DI,1
WIDFACE_OPEN_W_1:
	CMP	DI,FACE_TBL_KIND	; ＭＡＸ
	JLE	WIDFACE_OPEN_W_2	;
	MOV	DI,FACE_TBL_KIND	;
WIDFACE_OPEN_W_2:

	SHL	DI,1			; word pointer.
	MOV	BX,DS:FACE_TBL_KIND[DI]	;

	CMP	SI,0			; min check.
	JNE	WIDFACE_OPEN_W_3	;
	MOV	SI,1			;
WIDFACE_OPEN_W_3:			;
	MOV	AH,0			; max check.
	MOV	AL,DS:[BX]		; byte.
	CMP	SI,AX			;
	JLE	WIDFACE_OPEN_W_4	;
	MOV	SI,AX			;
WIDFACE_OPEN_W_4:

	MOV	DH,0			;
	MOV	DL,DS:[BX][SI]		; 誰か（テーブルを見ろ）
	MOV	AX,OKO_PUTS_X1		; 行いウインドウﾌｪｲｽPUTＸ
	MOV	BX,OKO_PUTS_Y1		; 行いウインドウﾌｪｲｽPUTＹ
	CALLC	PT_FACE			; フェイスＰＵＴ
	RET
FEND	WWIDFACE_OPEN_W


; ****************************************************
;	WINDOWS/行いフェイスＣＬＯＳＥ
; ****************************************************

FUNC	WWIDFACE_CLOSE_W,WIDFACE_CLOSE_W
	CALLC	WIDFRM_BACKLOAD		; WINDOWS/背景をロード
	RET
FEND	WWIDFACE_CLOSE_W


; ****************************************************
;	WINDOWS/王様ウインドウＯＰＥＮ
;	-I- WDXX : ＰＵＴ　Ｘ座標
;	    WDYY : ＰＵＴ　Ｙ座標
; ****************************************************

FUNC	WWIDFACE_OPEN_OH,WIDFACE_OPEN_OH
	MOV	DX,6			; 06=王様 フェイス番号
	MOV	AX,WDXX			; ＰＵＴ　Ｘ座標
	MOV	BX,WDYY			; ＰＵＴ　Ｙ座標
	CALLC	PT_FACE			; フェイスＰＵＴ
	RET
FEND	WWIDFACE_OPEN_OH


; ****************************************************
;	WINDOWS/ミスコンフェイスＯＰＥＮ
;	データリンクも同時に行う
;	-I- DX   : ムスメ番号（１－１７）
;	    WDXX : ＰＵＴ　Ｘ座標
;	    WDYY : ＰＵＴ　Ｙ座標
;	    AX   : 出力形態 0=名前出さない,1=名前出す
;	-O- WIDTK_CHAR_OF : WINDOWS/敵キャラクタアドレス
;	    WIDOFS_GP_TK  : 敵・グラフテーブルオフセット
;	    WIDOFS_VL_TK  : 敵・内容表示オフセット
; ****************************************************

FUNC	WWIDFACE_OPEN_M,WIDFACE_OPEN_M
	CALL	FAR PTR WWIDFACE_LOAD_M_ONLY	; WINDOWS/ミスコンＬＯＡＤ
	CALL	FAR PTR WWIDFACE_PUT_M_ONLY	; WINDOWS/ミスコンＰＵＴ
	RET

;*;	MOV	GR_STYLE_FLAG,AX	; 出力形態 0=名前出さない,1=名前出す
;*;	CMP	DX,WID_MISCON_MAX	; ミスコンキャラ数
;*;	JLE	WIDFACE_OPEN_M_1	;
;*;	MOV	DX,WID_MISCON_MAX	; ミスコンキャラ数
;*;WIDFACE_OPEN_M_1:			;
;*;
;*;	MOV	GIRL_NUMBER,DX		; ムスメ番号（１－１７）
;*;	MOV	AX,WDXX			; ＰＵＴ　Ｘ座標
;*;	MOV	BX,WDYY			; ＰＵＴ　Ｙ座標
;*;	MOV	GR_FCEXX,AX		; フェイス表示Ｘ位置
;*;	MOV	GR_FCEYY,BX		; フェイス表示Ｙ位置
;*;	ADD	BX,180			; Y+180
;*;	MOV	GR_NAMXX,AX		; 名前表示Ｘ位置
;*;	MOV	GR_NAMYY,BX		; 名前表示Ｙ位置
;*;	MOV	GR_TXTCLR,15		; 文字表示色	白
;*;	MOV	GR_TXTCSZ,0		; 文字表示サイズ 0=(16x16)
;*;
;*;	MOV	BX,GIRL_NUMBER		; ムスメ番号（１－１７）
;*;	MOVXBW	DX,WID_MISCON_TBL[BX]	; (byte)ミスコンテーブル
;*;	CALLC	WIDALLOC_TEKICHR	; WINDOWS/敵キャラクタ・データ結合
;*;
;*;	CALL	FACE_SHOW		; フェイス登場
;*;
;*;	RET
FEND	WWIDFACE_OPEN_M


; ****************************************************
;	WINDOWS/ミスコンフェイスＬＯＡＤ ＯＮＬＹ
;	データリンクも同時に行う
;	-I- DX   : ムスメ番号（１－１７）
;	    WDXX : ＰＵＴ　Ｘ座標
;	    WDYY : ＰＵＴ　Ｙ座標
;	    AX   : 出力形態 0=名前出さない,1=名前出す
;	-O- WIDTK_CHAR_OF : WINDOWS/敵キャラクタアドレス
;	    WIDOFS_GP_TK  : 敵・グラフテーブルオフセット
;	    WIDOFS_VL_TK  : 敵・内容表示オフセット
; ****************************************************

FUNC	WWIDFACE_LOAD_M_ONLY,WIDFACE_LOAD_M_ONLY
	MOV	GR_STYLE_FLAG,AX	; 出力形態 0=名前出さない,1=名前出す
	CMP	DX,WID_MISCON_MAX	; ミスコンキャラ数
	JLE	WIDFACE_LOAD_M_1	;
	MOV	DX,WID_MISCON_MAX	; ミスコンキャラ数
WIDFACE_LOAD_M_1:
	MOV	GIRL_NUMBER,DX		; ムスメ番号（１－１７）
	MOV	AX,WDXX			; ＰＵＴ　Ｘ座標
	MOV	BX,WDYY			; ＰＵＴ　Ｙ座標
	MOV	GR_FCEXX,AX		; フェイス表示Ｘ位置
	MOV	GR_FCEYY,BX		; フェイス表示Ｙ位置
	ADD	BX,180			; Y+180
	MOV	GR_NAMXX,AX		; 名前表示Ｘ位置
	MOV	GR_NAMYY,BX		; 名前表示Ｙ位置
	MOV	GR_TXTCLR,15		; 文字表示色	白
	MOV	GR_TXTCSZ,0		; 文字表示サイズ 0=(16x16)

	MOV	BX,GIRL_NUMBER		; ムスメ番号（１－１７）
	MOVXBW	DX,WID_MISCON_TBL[BX]	; (byte)ミスコンテーブル
	CALLC	WIDALLOC_TEKICHR	; WINDOWS/敵キャラクタ・データ結合

	MOV	DX,GIRL_NUMBER		; ムスメ番号（１－１７）
	CALLC	PT_MISSCON_LD		; ミスコンＬＯＡＤ ＯＮＬＹ

	RET
FEND	WWIDFACE_LOAD_M_ONLY


; ****************************************************
;	WINDOWS/ミスコンフェイスＰＵＴ ＯＮＬＹ
; ****************************************************

FUNC	WWIDFACE_PUT_M_ONLY,WIDFACE_PUT_M_ONLY
	CALL	FACE_SHOW		; フェイス登場
	RET
FEND	WWIDFACE_PUT_M_ONLY


; ****************************************************
;	WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＯＰＥＮ
; ****************************************************

FUNC	WWIDFACE_OPEN_G,WIDFACE_OPEN_G
	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	MOVX	WDX1,GIRL_BACK_X1	; ＧＩＲＬウインドウ成功失敗顔Ｘ位置
	MOVX	WDY1,GIRL_BACK_Y1	; ＧＩＲＬウインドウ成功失敗顔Ｙ位置
	MOVX	WDX2,GIRL_BACK_X2	; ＧＩＲＬウインドウ成功失敗顔Ｘ位置
	MOVX	WDY2,GIRL_BACK_Y2	; ＧＩＲＬウインドウ成功失敗顔Ｙ位置
	CALLC	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ

	MOVX	WDX1,GIRL_FREM_X	; ＧＩＲＬウインドウフレームＸ座標
	MOVX	WDY1,GIRL_FREM_Y	; ＧＩＲＬウインドウフレームＹ座標
	MOVX	WDX2,GIRL_FREM_XL	; ＧＩＲＬウインドウフレームサイズＸ
	MOVX	WDY2,GIRL_FREM_YL	; ＧＩＲＬウインドウフレームサイズＹ
	CALLC	WID_8_FLAME		; WINDOWS/フレーム８（フェイス）

;*;	MOV	DX,1			; 顔 1=成功,2=失敗
;*;	CALL	FAR PTR WWIDFACE_PUT_G	; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ
	RET
FEND	WWIDFACE_OPEN_G


; ****************************************************
;	WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＣＬＯＳＥ
; ****************************************************

FUNC	WWIDFACE_CLOSE_G,WIDFACE_CLOSE_G
	CALLC	WIDFRM_BACKLOAD		; WINDOWS/背景をロード
	RET
FEND	WWIDFACE_CLOSE_G


; ****************************************************
;	WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ
;	-I- DX : 顔 1=成功,2=失敗
; ****************************************************

FUNC	WWIDFACE_PUT_G,WIDFACE_PUT_G
	MOV	GIRL_FACE_FLG,DX	; 娘のフェイスウインドウ 1=成功,2=失敗

	CALL	LOAD_GIRL_FACE		; 娘の成功・失敗顔ロード

	MOV	AX,GIRL_PUTS_X1		; ＧＩＲＬウインドウフェイスＰＵＴＸ
	MOV	BX,GIRL_PUTS_Y1		; ＧＩＲＬウインドウフェイスＰＵＴＹ
	MOV	DX,GIRL_FACE_FLG	; 娘のフェイスウインドウ 1=成功,2=失敗
	CALLC	PT_PUT_MYGIRL_FACE	; 娘フェイスＰＵＴ
	RET
FEND	WWIDFACE_PUT_G


; ****************************************************
;	娘の成功・失敗顔ロード
; ****************************************************

LOAD_GIRL_FACE	PROC	NEAR
	MOV	DX,W_GIRL_GROW		; 少女（成長１,成長２,成長３....）
	MOV	AX,GIRL_FACE_NOW	; ロード済み失敗・成功の顔
	INC	DX			;
	INC	AX			;
	SHR	DX,1			; 1,2  3,4  5,6  7,8
	SHR	AX,1			; 1,2  3,4  5,6  7,8
	CMP	DX,AX			;
	JE	LOAD_GIRL_FACE_EXIT	;

	MOV	DX,W_GIRL_GROW		; 少女（成長１,成長２,成長３....）
	MOV	GIRL_FACE_NOW,DX	; ロード済み失敗・成功の顔

	CALLC	PT_LD_MYGIRL_FACE	; 娘フェイスＬＯＡＤ
LOAD_GIRL_FACE_EXIT:
	RET
LOAD_GIRL_FACE	ENDP


; ****************************************************
;	フェイス登場
;	-I- GIRL_NUMBER : ムスメ番号（１－１７）
;	    WIDTK_CHAR_OF : WINDOWS/敵キャラクタアドレス
;	    GR_FCEXX    : フェイス表示Ｘ位置
;	    GR_FCEYY    : フェイス表示Ｙ位置
;	    GR_NAMXX    : 名前表示Ｘ位置
;	    GR_NAMYY    : 名前表示Ｙ位置
;	    GR_TXTCLR   : 文字表示色
;	    GR_TXTCSZ   : 文字表示サイズ
;	    GR_STYLE_FLAG : 出力形態 0=名前出さない,1=名前出す
; ****************************************************

FACE_SHOW	PROC	NEAR
	MOV	AX,GR_FCEXX		; フェイス表示Ｘ位置
	MOV	BX,GR_FCEYY		; フェイス表示Ｙ位置
	CALLC	PT_MISSCON_PUT		; ミスコンＰＵＴ ＯＮＬＹ

	CMP	GR_STYLE_FLAG,0		; 出力形態 0=名前出さない,1=名前出す
	JE	FACE_SHOW_EXIT		;
	MOV	AX,WIDTK_CHAR_OF	; WINDOWS/敵キャラクタアドレス
	CALL	GIRL_NAME		; キャラクタ名
FACE_SHOW_EXIT:
	RET
FACE_SHOW	ENDP


; ****************************************************
;	キャラクタ名
;	-I- AX : キャラクタアドレス
; ****************************************************

GIRL_NAME	PROC	NEAR
	MOV	ADRS_HOW,AX		; キャラクタアドレス

;*;	CALLC	STRZEROC		; 文字列バッファ０クリア
;*;;*;	CALLC	STRCLEAR		; 文字列バッファクリア
;*;	; ヘッダー
;*;	MOV	BX,ADRS_HOW		; 人物
;*;	; 名前
;*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*;	MOV	SI,ES:[BX][HED_NAME]	; SI=名
;*;	; 説明セット
;*;	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
;*;	MOV	CX,STRING_LEN		; バッファ最大長さ
;*;	CALLC	STRSETZ			; 文字列バッファセット
;*;	; ＣＲＴへ
;*;	MOV	AX,GR_TXTCSZ		; 文字表示サイズ
;*;	CALLC	VTXSIZ			; character size set.
;*;	MOV	AX,GR_TXTCLR		; 文字表示色
;*;	CALLC	VTXCOL			; character color set.
;*;	MOV	AX,GR_NAMXX		; 名前表示Ｘ位置
;*;	MOV	BX,GR_NAMYY		; 名前表示Ｙ位置
;*;	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
;*;	CALLC	VTXPFC			; vram text print fuchi.
;*;;*;	CALLC	VTXPOR			; vram text print OR.


	CALLC	STRZEROC		; 文字列バッファ０クリア

	MOVX	R_SR_CHR_ADRS,ADRS_HOW	; キャラクタアドレス
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; 名前長さ
	CALLC	R_SR_GIRL_FULNAMGET	; キャラクタ名+姓ＧＥＴ

	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,15			; 表示名前の最長
	CALLC	KANJITUME		; 漢字文字詰め処理

	; ＣＲＴへ

	MOV	AX,GR_TXTCSZ		; 文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,GR_TXTCLR		; 文字表示色
	CALLC	VTXCOL			; character color set.

	MOV	AX,GR_NAMXX		; 名前表示Ｘ位置
	MOV	BX,GR_NAMYY		; 名前表示Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	VTXPFC			; vram text print fuchi.
;*;	CALLC	VTXPOR			; vram text print OR.

	RET
GIRL_NAME	ENDP



WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	WID_MISCON_MAX:WORD		; ミスコンキャラ数
EXTRN	WID_MISCON_TBL:BYTE		; (byte)ミスコンテーブル
EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス
EXTRN	W_GIRL_GROW:WORD		; 少女（成長１,成長２,成長３,成長４）


;	会見フェイスウインドウ

KAI_PAT_NUM	DW	0		; 会見パターン番号
KAI_POINT_X1	DW	KAIKEN_LOC_X+1	; 会見ウインドウＸ位置
KAI_POINT_Y1	DW	KAIKEN_LOC_Y+7	; 会見ウインドウＹ位置
KAI_FREM_X	DW	KAIKEN_LOC_X	; 会見ウインドウフレームＸ座標
KAI_FREM_Y	DW	KAIKEN_LOC_Y	; 会見ウインドウフレームＹ座標
KAI_FREM_XL	DW	KAIKEN_SIZ_X	; 会見ウインドウフレームサイズＸ
KAI_FREM_YL	DW	KAIKEN_SIZ_Y	; 会見ウインドウフレームサイズＹ
KAI_BACK_X1	DW	KAIKEN_LOC_X-1	; 会見退避左上Ｘ
KAI_BACK_Y1	DW	KAIKEN_LOC_Y-8	; 会見退避左上Ｙ
KAI_BACK_X2	DW	KAIKEN_SIZ_X+2	; 会見退避サイズＸ
KAI_BACK_Y2	DW	KAIKEN_SIZ_Y+16	; 会見退避サイズＹ

;	ミスコン

GIRL_NUMBER	DW	0		; ムスメ番号（１－１７）
ADRS_HOW	DW	0		; キャラクタアドレス

;	フレーム・ミスコン

GR_FCEXX	DW	0		; フェイス表示Ｘ位置
GR_FCEYY	DW	0		; フェイス表示Ｙ位置
GR_NAMXX	DW	0		; 名前表示Ｘ位置
GR_NAMYY	DW	0		; 名前表示Ｙ位置
GR_TXTCLR	DW	0		; 文字表示色
GR_TXTCSZ	DW	0		; 文字表示サイズ

GR_STYLE_FLAG	DW	0		; 出力形態 0=名前出さない,1=名前出す

;	フレーム・行いフェイス

OKO_PUTS_X1	DW	OKONAI_LOC_X+1	; 行いウインドウﾌｪｲｽPUTＸ
OKO_PUTS_Y1	DW	OKONAI_LOC_Y+7	; 行いウインドウﾌｪｲｽPUTＹ
OKO_FREM_X	DW	OKONAI_LOC_X	; 行いウインドウフレームＸ座標
OKO_FREM_Y	DW	OKONAI_LOC_Y	; 行いウインドウフレームＹ座標
OKO_FREM_XL	DW	OKONAI_SIZ_X	; 行いウインドウフレームサイズＸ
OKO_FREM_YL	DW	OKONAI_SIZ_Y	; 行いウインドウフレームサイズＹ
OKO_BACK_X1	DW	OKONAI_LOC_X-1	; 行い退避左上Ｘ
OKO_BACK_Y1	DW	OKONAI_LOC_Y-8	; 行い退避左上Ｙ
OKO_BACK_X2	DW	OKONAI_SIZ_X+2	; 行い退避サイズＸ
OKO_BACK_Y2	DW	OKONAI_SIZ_Y+16	; 行い退避サイズＹ

;	娘のフェイスウインドウ

GIRL_PUTS_X1	DW	MY_GIRL_LOC_X+1	; ＧＩＲＬウインドウフェイスＰＵＴＸ
GIRL_PUTS_Y1	DW	MY_GIRL_LOC_Y+8	; ＧＩＲＬウインドウフェイスＰＵＴＹ
GIRL_FREM_X	DW	MY_GIRL_LOC_X	; ＧＩＲＬウインドウフレームＸ座標
GIRL_FREM_Y	DW	MY_GIRL_LOC_Y	; ＧＩＲＬウインドウフレームＹ座標
GIRL_FREM_XL	DW	MY_GIRL_SIZ_X	; ＧＩＲＬウインドウフレームサイズＸ
GIRL_FREM_YL	DW	MY_GIRL_SIZ_Y	; ＧＩＲＬウインドウフレームサイズＹ
GIRL_BACK_X1	DW	MY_GIRL_LOC_X-1	; ＧＩＲＬウインドウ成功失敗顔Ｘ位置
GIRL_BACK_Y1	DW	MY_GIRL_LOC_Y-8	; ＧＩＲＬウインドウ成功失敗顔Ｙ位置
GIRL_BACK_X2	DW	MY_GIRL_SIZ_X+2	; ＧＩＲＬウインドウ成功失敗顔Ｘ位置
GIRL_BACK_Y2	DW	MY_GIRL_SIZ_Y+16; ＧＩＲＬウインドウ成功失敗顔Ｙ位置


GIRL_FACE_FLG	DW	0		; 娘のフェイスウインドウ　1=成功,2=失敗
GIRL_FACE_NOW	DW	0FFH		; ロード済み失敗・成功の顔


FACE_KIND	DW	0		; フェイスの種類
FACE_WHO	DW	0		; フェイス誰か


;	チョイ役テーブル

FACE_TBL_KIND	LABEL	WORD		;フェイス対応テーブル
		DW	7		;	MAX
		DW	FACE_TBL01	;	1=城の人々
		DW	FACE_TBL02	;	2=武芸師範
		DW	FACE_TBL03	;	3=学問場の先生
		DW	FACE_TBL04	;	4=礼法の先生
		DW	FACE_TBL05	;	5=アルバイトの雇主
		DW	FACE_TBL06	;	6=主人公成功
		DW	FACE_TBL07	;	7=主人公失敗
FACE_TBL01	LABEL	BYTE		;1=城の人々
		DB	6		;	MAX
		DB	01		;	1=衛兵
		DB	02		;	2=近衛隊長
		DB	03		;	3=侍従
		DB	04		;	4=侍従長
		DB	05		;	5=王妃様
		DB	06		;	6=王様
FACE_TBL02	LABEL	BYTE		;2=武芸師範
		DB	4		;	MAX
		DB	07		;	1=武芸師範１
		DB	08		;	2=武芸師範２
		DB	09		;	3=武芸師範３
		DB	07		;	4=武芸師範３
FACE_TBL03	LABEL	BYTE		;3=学問場の先生
		DB	1		;	MAX
		DB	10		;	1=学問場の先生
FACE_TBL04	LABEL	BYTE		;4=礼法の先生
		DB	1		;	MAX
		DB	11		;	1=礼法の先生
FACE_TBL05	LABEL	BYTE		;5=アルバイトの雇主
		DB	12		;	MAX
		DB	12		;	1=宿屋
		DB	13		;	2=メイド
		DB	14		;	3=代筆屋
		DB	15		;	4=酒場１
		DB	16		;	5=医者
		DB	17		;	6=狩人
		DB	18		;	7=武器屋
		DB	19		;	8=宿屋２
		DB	20		;	9=木コリ
		DB	21		;	10=教会
		DB	22		;	11=酒場２
		DB	23		;	12=人足
FACE_TBL06	LABEL	BYTE		;6=主人公成功
		DB	4		;	MAX
		DB	24		;	主人公１０－１２成功
		DB	25		;	主人公１２－１４成功
		DB	26		;	主人公１４－１６成功
		DB	27		;	主人公１６－１８成功
FACE_TBL07	LABEL	BYTE		;7=主人公失敗
		DB	4		;	MAX
		DB	28		;	主人公１０－１２失敗
		DB	29		;	主人公１２－１４失敗
		DB	30		;	主人公１４－１６失敗
		DB	31		;	主人公１６－１８失敗

DATA	ENDS

	END
;
;	end of "WIDFACE.ASM"
;
