; "WIDHED.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	ＷＩＮＤＯＷＳ／ヘッダー（名前／ＨＰ系）
;
;
;	WIDHED_INIT		; WINDOWS/ヘッダー初期処理
;	WIDHED			; WINDOWS/ヘッダー表示
;	WIDHED_D_HP		; WINDOWS/ヘッダ・ＨＰ表示
;	WIDHED_RELOC		; WINDOWS/ヘッダー位置変更・全表示
;	WIDHED_CAL		; WINDOWS/ヘッダー位置変更・計算のみ
;	WIDHED_XSEIZA		; WINDOWS/星座表示
;	WIDHED_C_SEIZA		; WINDOWS/星座チェック
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO4\WORDID.INC


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

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/ヘッダー初期処理
; ****************************************************

FUNC	WWIDHED_INIT,WIDHED_INIT
	RET
FEND	WWIDHED_INIT


; ****************************************************
;	WINDOWS/ヘッダー表示
;	-I- WDHNO : ヘッダー番号
; ****************************************************

FUNC	WWIDHED,WIDHED
	MOV	AX,WDHNO			; ヘッダー番号
	CMP	AX,WIDMAX_HEAD			; ヘッダーテーブルレコード数
	JNB	WIDHED_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し
	CALL	WIDHED_LINK			; データリンケージ

	TEST	DSP_FLAGS,FLAGS_DISP		; フラグ／表示ＯＮ？
	JNZ	WIDHED_1			;

	CALL	WIDHED_ON			; 指定のヘッダーをＯＮ
	CALL	WIDHED_BRI			; 指定のヘッダブリンク

	JMP	WIDHED_EXIT			;
WIDHED_1:					;
	CALL	WIDHED_DRAW			; ヘッダー表示
	CALL	WIDHED_BRI			; 指定のヘッダブリンク
WIDHED_EXIT:					;
	RET
FEND	WWIDHED


; ****************************************************
;	WINDOWS/ヘッダ・ＨＰ表示
;	-I- WDHNO : ヘッダー番号
; ****************************************************

FUNC	WWIDHED_D_HP,WIDHED_D_HP
;*;	PRV	"WDHNO=",WDHNO

	MOV	AX,WDHNO			; ヘッダー番号
	CMP	AX,WIDMAX_HEAD			; ヘッダーテーブルレコード数
	JNB	WIDHED_D_HP_EXIT		;

	CALL	WIDPAR				; テーブル内容取り出し
	CALL	WIDHED_LOCATE			; ヘッダー表示位置

	MOV	AX,HD_DSPXX			; ヘッダー表示Ｘ位置
	MOV	BX,HD_DSPYY			; ヘッダー表示Ｙ位置
	MOV	CX,W_CLMEE			; カラム・最後
	MOV	DX,W_LINEE			; 行　　・最後
	CALLC	MS_STOP				; マウスカーソル退避

	CALL	WIDHED_HP			; ヘッダ・ＨＰ	表示
	CALL	WIDHED_LVL			; ヘッダ・レベル　表示
	CALL	WIDHED_GOLD			; ヘッダ・お金　表示
	CALL	WIDHED_SEIZA			; ヘッダ・星座　表示

	CALLC	MS_START			; マウスカーソル復帰
WIDHED_D_HP_EXIT:
	RET
FEND	WWIDHED_D_HP


; ****************************************************
;	WINDOWS/ヘッダー位置変更・全表示
;	-I- AX : ヘッダー 描画Ｘ位置
;	    DX : ヘッダー 描画開始位置
;	    CX : ヘッダー 描画本数
; ****************************************************

FUNC	WWIDHED_RELOC,WIDHED_RELOC
	MOV	WIDHED_SRTX,AX		; 内容表示 開始位置Ｘ
	MOV	WIDHED_UP,DX		; ヘッダー描画開始位置
	MOV	WIDHED_CNT,CX		; ヘッダー描画本数
	CALL	WIDHED_LOC		; ロケーション計算

	CALL	WIDHED_FLGSET		; ヘッダー全フラグの更新
	CALL	WIDHED_ALL		; ヘッダーの全表示

	RET
FEND	WWIDHED_RELOC



; ****************************************************
;	WINDOWS/ヘッダー位置変更・計算のみ
;	-I- AX : ヘッダー 描画Ｘ位置
;	    DX : ヘッダー 描画開始位置
;	    CX : ヘッダー 描画本数
; ****************************************************

FUNC	WWIDHED_CAL,WIDHED_CAL
	MOV	WIDHED_SRTX,AX		; 内容表示 開始位置Ｘ
	MOV	WIDHED_UP,DX		; ヘッダー描画開始位置
	MOV	WIDHED_CNT,CX		; ヘッダー描画本数
	CALL	WIDHED_LOC		; ロケーション計算

	CALL	WIDPAR			; テーブル内容取り出し
	CALL	WIDHED_LINK		; データリンケージ

	CALL	WIDHED_SHOW		; 指定のヘッダーを表示エリアへ
	RET
FEND	WWIDHED_CAL


; ****************************************************
;	WINDOWS/星座表示
;	-I- AX : Ｘ位置
;	    BX : Ｙ位置
;	    CX : 血液型
;	    DX : 星座名
; ****************************************************

FUNC	WWIDHED_XSEIZA,WIDHED_XSEIZA
	MOV	SEIZA_X,AX		; 星座Ｘ
	MOV	SEIZA_Y,BX		; 星座Ｙ
	MOV	BLOOD_NM,CX		; 血液型
	MOV	SEIZA_NM,DX		; 星座名
	CALL	SEIZA_HYOUZI		; 星座表示
	CALL	BLOOD_HYOUZI		; 血液型表示
	RET
FEND	WWIDHED_XSEIZA


; ****************************************************
;	WINDOWS/星座チェック
;	-I- BX : 星座名
;	-O- AX : 1=見つかった,0=見つからない
;	    CX : 星座番号
;
;		星座は"WIDCLEN.ASM"（ＷＩＮＤＯＷＳ／カレンダー）
;		の並び順です。
;
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
; ****************************************************

FUNC	WWIDHED_C_SEIZA,WIDHED_C_SEIZA
	CALLC	R_ENV_IDNAME		; 環境文字のＩＤ検索
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	WIDHED_C_SEIZA_NONE	;

					; DL : ＩＤ(サーチバイト)
	MOVX	ES,DS			;
	MOV	DI,OFFSET SEIZA_ID_TABLE ; 星座テーブル
	CALLC	BYTE_TBL_SCH		; バイトテーブルサーチ
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	WIDHED_C_SEIZA_NONE	;

	MOV	AX,1			; 1=見つかった
	RET
WIDHED_C_SEIZA_NONE:
	MOV	CX,0			;
	MOV	AX,0			; 0=見つからない
	RET
FEND	WWIDHED_C_SEIZA


;	指定のヘッダーをＯＮ
;	-I- WDHNO : ヘッダー番号

WIDHED_ON	PROC	NEAR
	PUSH	ES
	PUSH	BX

	CALL	WIDHED_SHOW		; 指定のヘッダーを表示エリアへ
	CALL	WIDHED_ALL		; ヘッダーの全表示

	POP	BX
	POP	ES
	RET
WIDHED_ON	ENDP



;	指定のヘッダーを表示エリアへ
;	-I-   WDHNO : ヘッダー番号
;	-I/O- WIDHED_START : ヘッダー描画開始番号
;	      WIDHED_END   : ヘッダー描画終了番号
;	      WIDHED_UP    : ヘッダー描画開始位置
;	      WIDHED_CNT   : ヘッダー描画本数

WIDHED_SHOW	PROC	NEAR
	MOV	AX,WDHNO			; ヘッダー番号
	CMP	AX,WIDHED_START			; ヘッダー描画開始番号
	JB	WIDHED_SHOW_UPPER		;
	CMP	AX,WIDHED_END			; ヘッダー描画終了番号
	JNBE	WIDHED_SHOW_UNDER		;

	CALL	WIDHED_FLGSET			; ヘッダー全フラグの更新
	JMP	WIDHED_SHOW_EXIT		;


WIDHED_SHOW_UPPER:				;
	MOV	AX,WDHNO			; ヘッダー番号
	MOV	WIDHED_START,AX			; ヘッダー描画開始番号

	JMP	WIDHED_SHOW_CALC		;


WIDHED_SHOW_UNDER:				;
	MOV	AX,WDHNO			; ヘッダー番号
	SUB	AX,WIDHED_CNT			; ヘッダー描画本数
	INC	AX				;
	MOV	WIDHED_START,AX			; ヘッダー描画開始番号

WIDHED_SHOW_CALC:				;
	CALL	WIDHED_LOC			; ロケーション計算
	CALL	WIDHED_FLGSET			; ヘッダー全フラグの更新

WIDHED_SHOW_EXIT:
	RET
WIDHED_SHOW	ENDP



;	ヘッダー全フラグの更新
;	-I- WIDHED_START : ヘッダー描画開始番号
;	    WIDHED_END   : ヘッダー描画終了番号

WIDHED_FLGSET	PROC	NEAR
	MOV	AX,0				; 横グラフ番号
	CALL	WIDADR				; テーブルアドレス

	MOV	CX,WIDMAX_HEAD			; ヘッダーテーブルレコード数
WIDHED_FLGSET_LOOP:				;
	AND	WORD PTR ES:[BX][HED_FLAGS],NOT FLAGS_DISP ;フラグ/表示ＯＦＦ
	ADD	BX,HED_NEXT			; 次のヘッダー
	LOOP	WIDHED_FLGSET_LOOP		;

	MOV	AX,WIDHED_START			; ヘッダー描画開始番号
	CALL	WIDADR				; テーブルアドレス

	MOV	AX,WIDHED_START			; ヘッダー描画開始番号
WIDHED_FLGSET_LOOP2:				;
	OR	WORD PTR ES:[BX][HED_FLAGS],FLAGS_DISP ;フラグ/表示ＯＦＦ
	ADD	BX,HED_NEXT			; 次のヘッダー
	INC	AX				;
	CMP	AX,WIDHED_END			; ヘッダー描画終了番号
	JBE	WIDHED_FLGSET_LOOP2		;

WIDHED_FLGSET_EXIT:				;
	RET
WIDHED_FLGSET	ENDP



;	指定のヘッダブリンク
;	-I- WDHNO : ヘッダー番号

WIDHED_BRI	PROC	NEAR
	PUSH	ES
	PUSH	BX

;*NON*;	CALL	WIDHED_LOCATE			; ヘッダー表示位置
;*NON*;	CALL	WIDHED_BK			; ヘッダーブリンク

	POP	BX
	POP	ES
	RET
WIDHED_BRI	ENDP


;	ヘッダーの全表示
;	-I- WIDHED_START : ヘッダー描画開始番号
;	    WIDHED_END   : ヘッダー描画終了番号

WIDHED_ALL	PROC	NEAR
	PUSH	WDHNO				;

	MOVX	WDHNO,WIDHED_START		; ヘッダー描画開始番号
WIDHED_ALL_LOOP:
	MOV	AX,WDHNO			; ヘッダー番号
	CMP	AX,WIDMAX_HEAD			; ヘッダーテーブルレコード数
	JNB	WIDHED_ALL_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し
	CALL	WIDHED_DRAW			; ヘッダー表示

	MOV	AX,WDHNO			; ヘッダー番号
	CMP	AX,WIDHED_END			; ヘッダー描画終了番号
	JE	WIDHED_ALL_EXIT			;

	INC	WDHNO				; ヘッダー番号
	JMP	WIDHED_ALL_LOOP			;

WIDHED_ALL_EXIT:
	POP	WDHNO				;
	RET
WIDHED_ALL	ENDP



;	ヘッダー表示
;	-I- WDHNO : ヘッダー番号
;	    HEAD_ADRS  : ヘッダーアドレス
;	    DSP_FNAME  : 姓
;	    DSP_NAME   : 名
;	    DSP_SHOGO  : 称号
;	    DSP_HP     : ＨＰ
;	    DSP_LVL    : レベル
;	    DSP_HELP   : 説明
;	    DSP_FLAGS  : フラグ

WIDHED_DRAW	PROC	NEAR
	CALL	WIDHED_LOCATE			; ヘッダー表示位置

	CALL	WIDHED_FLAME			; ヘッダーのフレーム

	MOV	AX,HD_DSPXX			; ヘッダー表示Ｘ位置
	MOV	BX,HD_DSPYY			; ヘッダー表示Ｙ位置
	MOV	CX,W_CLMEE			; カラム・最後
	MOV	DX,W_LINEE			; 行　　・最後
	CALLC	MS_STOP				; マウスカーソル退避

;*;	CALL	WIDHED_FNAME			; ヘッダ・姓　表示
;*;	CALL	WIDHED_NAME			; ヘッダ・名　表示
	CALL	WIDHED_FULLNAME			; ヘッダ・氏名　表示
	CALL	WIDHED_SHOGO			; ヘッダ・称号　表示
	CALL	WIDHED_HP			; ヘッダ・ＨＰ	表示
	CALL	WIDHED_LVL			; ヘッダ・レベル　表示
	CALL	WIDHED_GOLD			; ヘッダ・お金　表示
	CALL	WIDHED_SEIZA			; ヘッダ・星座　表示

	CALLC	MS_START			; マウスカーソル復帰
	RET
WIDHED_DRAW	ENDP



;	テーブル内容取り出し
;	-I- WDHNO : ヘッダー番号
;	-O- ES:BX      : テーブルアドレス
;	    HEAD_ADRS  : ヘッダーアドレス
;	    DSP_FNAME  : 姓
;	    DSP_NAME   : 名
;	    DSP_SHOGO  : 称号
;	    DSP_HP     : ＨＰ
;	    DSP_LVL    : レベル
;	    DSP_HELP   : 説明
;	    DSP_FLAGS  : フラグ
;	    DSP_GR_OFS : グラフテーブルオフセット
;	    DSP_GR_MAX : グラフテーブルレコード数
;	    DSP_VA_OFS : 内容表示テーブルオフセット
;	    DSP_VA_MAX : 内容表示テーブルレコード数
;	    DSP_SEIZA  : 星座
;	    DSP_BLOOD  : 血液型
;	    DSP_GOLD   : お金

WIDPAR	PROC	NEAR
	MOV	AX,WDHNO			; ヘッダー番号
	CALL	WIDADR				; テーブルアドレス
	MOV	HEAD_ADRS,BX			; ヘッダーアドレス

	MOVX	DSP_FNAME, ES:[BX][HED_FNAME]	; 姓
	MOVX	DSP_NAME,  ES:[BX][HED_NAME]	; 名
	MOVX	DSP_SHOGO, ES:[BX][HED_SHOGO]	; 称号
	MOVX	DSP_HP,    ES:[BX][HED_HP]	; ＨＰ
	MOVX	DSP_LVL,   ES:[BX][HED_LVL]	; レベル
	MOVX	DSP_HELP,  ES:[BX][HED_HELP]	; 説明
	MOVX	DSP_FLAGS, ES:[BX][HED_FLAGS]	; フラグ
	MOVX	DSP_GR_OFS,ES:[BX][HED_GR_OFS]	; グラフテーブルオフセット
	MOVX	DSP_GR_MAX,ES:[BX][HED_GR_MAX]	; グラフテーブルレコード数
	MOVX	DSP_VA_OFS,ES:[BX][HED_VA_OFS]	; 内容表示テーブルオフセット
	MOVX	DSP_VA_MAX,ES:[BX][HED_VA_MAX]	; 内容表示テーブルレコード数

	MOV	DI,DSP_VA_OFS			; 内容表示テーブルオフセット
	MOVX	DSP_SEIZA,ES:[DI][VTB_SEIZA][VAL_VALUE]	; 星座
	MOVX	DSP_BLOOD,ES:[DI][VTB_KETUEKI][VAL_VALUE] ; 血液型
	MOVX	DSP_GOLD, ES:[DI][VTB_OKANE][VAL_VALUE]	; お金

	RET
WIDPAR	ENDP


;	データリンケージ
;	-I- DSP_GR_OFS : グラフテーブルオフセット
;	    DSP_GR_MAX : グラフテーブルレコード数
;	    DSP_VA_OFS : 内容表示テーブルオフセット
;	    DSP_VA_MAX : 内容表示テーブルレコード数

WIDHED_LINK	PROC	NEAR
	MOVX	WIDOFS_GRP,DSP_GR_OFS		; グラフテーブルオフセット
	MOVX	WIDMAX_GRP,DSP_GR_MAX		; グラフテーブルレコード数
	MOVX	WIDOFS_VAL,DSP_VA_OFS		; 内容表示テーブルオフセット
	MOVX	WIDMAX_VAL,DSP_VA_MAX		; 内容表示テーブルレコード数
	RET
WIDHED_LINK	ENDP


;	テーブルアドレス
;	-I- AX    : 横グラフ番号
;	-O- ES:BX : テーブルアドレス

WIDADR	PROC	NEAR
	MOV	BX,HED_NEXT		; 次のヘッダー
	MUL	BL			; AX=AX*BL
	MOV	BX,AX			;
	ADD	BX,WIDOFS_HEAD		; ヘッダーテーブルオフセット
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	RET
WIDADR	ENDP



;	ロケーション計算
;	-I-   WIDHED_START : ヘッダー描画開始番号
;	-I/O- WIDHED_UP    : ヘッダー描画開始位置
;	      WIDHED_CNT   : ヘッダー描画本数
;	-O-   WIDHED_END   : ヘッダー描画終了番号

WIDHED_LOC	PROC	NEAR
	MOV	AX,WIDHED_VIW_MIN		; ヘッダー 表示エリア下限
	CMP	WIDHED_UP,AX			; ヘッダー描画開始位置
	JGE	WIDHED_LOC_2			;
	MOV	WIDHED_UP,AX			; ヘッダー描画開始位置
WIDHED_LOC_2:

	MOV	AX,WIDHED_VIW_MAX		; ヘッダー 表示エリア上限
	CMP	WIDHED_UP,AX			; ヘッダー描画開始位置
	JLE	WIDHED_LOC_3			;
	MOV	WIDHED_UP,AX			; ヘッダー描画開始位置
WIDHED_LOC_3:

	MOV	AX,WIDHED_VIW_MAX		; ヘッダー 表示エリア上限
	SUB	AX,WIDHED_UP			; ヘッダー描画開始位置
	INC	AX				; これが最大表示本数
	CMP	WIDHED_CNT,AX			; ヘッダー描画本数
	JLE	WIDHED_LOC_4			;
	MOV	WIDHED_CNT,AX			; ヘッダー描画本数
WIDHED_LOC_4:					;

	CMP	WIDHED_CNT,1			; ヘッダー描画本数
	JGE	WIDHED_LOC_5			;
	MOV	WIDHED_CNT,1			; ヘッダー描画本数
WIDHED_LOC_5:

	MOV	AX,WIDHED_START			; ヘッダー描画開始番号
	ADD	AX,WIDHED_CNT			; ヘッダー描画本数
	DEC	AX				;
	MOV	WIDHED_END,AX			; ヘッダー描画終了番号

	RET
WIDHED_LOC	ENDP



;	ヘッダー表示位置
;	-I- WDHNO : ヘッダー番号
;	-O- HD_DSPXX : ヘッダー表示Ｘ位置
;	    HD_DSPYY : ヘッダー表示Ｙ位置

WIDHED_LOCATE	PROC	NEAR
	MOV	HD_DSPXX,0			; ヘッダー表示Ｘ位置

	MOV	AX,WIDHED_UP			; ヘッダー描画開始位置
	MOV	CX,LOCATE_HIGHT			; 表示ライン１本の高さ
	MUL	CL				;
	MOV	HD_DSPYY,AX			; ヘッダー表示Ｙ位置

	MOV	AX,WDHNO			; ヘッダー番号
	SUB	AX,WIDHED_START			; ヘッダー描画開始番号
	MOV	CX,HEAD_HIGHT			; ヘッダー１本の高さ
	MUL	CL				;
	ADD	HD_DSPYY,AX			; ヘッダー表示Ｙ位置

	ADDX	HD_DSPXX,WIDHED_SRTX		; 内容表示 開始位置Ｘ
	ADDX	HD_DSPYY,WIDHED_SRTY		; 内容表示 開始位置Ｙ

	RET
WIDHED_LOCATE	ENDP


;	ヘッダ・氏名　表示
;	-I- HEAD_ADRS : ヘッダーアドレス

WIDHED_FULLNAME		PROC	NEAR
	MOVX	USER_LENGTH,W_CLMEE	; カラム・最後
	SUB	USER_LENGTH,3		;

	CALLC	STRZEROC		; 文字列バッファ０クリア

	MOVX	R_SR_CHR_ADRS,HEAD_ADRS	; 台詞・キャラクタアドレス
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALLC	R_SR_GIRL_FULNAMGET	; キャラクタ名+姓ＧＥＴ

	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,USER_LENGTH		; ユーザ文字長さ
	CALLC	KANJITUME		; 漢字文字詰め処理

	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	AX,HD_DSPXX		; ヘッダー表示Ｘ位置
	ADD	AX,W_CLM2		; カラム・名
	MOV	XX1,AX			;
	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADDX	YY1,W_LIN1		; 行　　・姓
	MOVX	HD_DSPCL2,W_COL1	; ヘッダー文字表示色
	MOV	HD_DSPCSZ,0		; ヘッダー文字表示サイズ
	CALL	STRING_PUT		; 文字列表示

	RET
WIDHED_FULLNAME		ENDP


;*;;	ヘッダ・姓　表示
;*;;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;*;;	    HD_DSPYY : ヘッダー表示Ｙ位置
;*;;	    DSP_FNAME: 姓
;*;
;*;WIDHED_FNAME	PROC	NEAR
;*;	MOVX	HD_DSPSTR,DSP_FNAME	; 姓
;*;	MOVX	MAXLEN,WIDHDFNAM_LEN	; ヘッダー 姓の最大長さ
;*;	MOV	AX,HD_DSPXX		; ヘッダー表示Ｘ位置
;*;	ADD	AX,W_CLM1		; カラム・姓
;*;	MOV	XX1,AX			;
;*;	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
;*;	ADDX	YY1,W_LIN1		; 行　　・姓
;*;	MOVX	HD_DSPCL2,W_COL1	; ヘッダー文字表示色
;*;	MOV	HD_DSPCSZ,0		; ヘッダー文字表示サイズ
;*;	CALL	WIDHED_STRINGS		; 文字列の表示
;*;	RET
;*;WIDHED_FNAME	ENDP
;*;
;*;
;*;
;*;;	ヘッダ・名　表示
;*;;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;*;;	    HD_DSPYY : ヘッダー表示Ｙ位置
;*;;	    DSP_NAME : 名
;*;
;*;WIDHED_NAME	PROC	NEAR
;*;	MOVX	HD_DSPSTR,DSP_NAME	; 名
;*;	MOVX	MAXLEN,WIDHDNAME_LEN	; ヘッダー 名の最大長さ
;*;	MOV	AX,HD_DSPXX		; ヘッダー表示Ｘ位置
;*;	ADD	AX,W_CLM2		; カラム・名
;*;	MOV	XX1,AX			;
;*;	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
;*;	ADDX	YY1,W_LIN2		; 行　　・名
;*;	MOVX	HD_DSPCL2,W_COL1	; ヘッダー文字表示色
;*;	MOV	HD_DSPCSZ,0		; ヘッダー文字表示サイズ
;*;	CALL	WIDHED_STRINGS		; 文字列の表示
;*;	RET
;*;WIDHED_NAME	ENDP



;	ヘッダ・称号　表示
;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;	    HD_DSPYY : ヘッダー表示Ｙ位置
;	    DSP_SHOGO: 称号

WIDHED_SHOGO	PROC	NEAR
	MOVX	HD_DSPCL2,W_COL1	; ヘッダー文字表示色
	MOV	HD_DSPCSZ,0		; ヘッダー文字表示サイズ

	MOV	MAXLEN,4		; ヘッダー 称号の最大長さ
	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
	ADDX	XX1,W_CLM3		; カラム・称号先頭
	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADDX	YY1,W_LIN3		; 行　　・称号先頭
	MOV	SI,OFFSET MSG_SHOGO	; "称号"
	CALL	STRING_PUT		; 文字列表示


	MOVX	HD_DSPSTR,DSP_SHOGO	; 称号
	MOVX	MAXLEN,WIDHDSHOGO_LEN	; ヘッダー 称号の最大長さ
	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
	ADDX	XX1,W_CLM4		; カラム・称号
	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADDX	YY1,W_LIN4		; 行　　・称号
	CALL	WIDHED_STRINGS		; 文字列の表示
	RET
WIDHED_SHOGO	ENDP



;	ヘッダ・ＨＰ　表示
;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;	    HD_DSPYY : ヘッダー表示Ｙ位置
;	    DSP_HP   : ＨＰ

WIDHED_HP	PROC	NEAR
;*;	PRV	"PXX1=",HD_DSPXX
;*;	PRV	"PYY1=",HD_DSPYY

	MOV	AX,15			; font color.
	CALLC	MITCOL			; mini string color.

	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
	ADDX	XX1,W_CLM6		; カラム・ＨＰ数値

	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADDX	YY1,W_LIN6		; 行　　・ＨＰ数値

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	DEC	BX			;
	MOV	CX,21			; 文字長さ
	MOV	DX,10			; 文字サイズ 10=8x8
	MOV	DI,W_COL3		; カラー・暗い灰
	MOV	SI,W_COL4		; カラー・黒
	CALLC	DSPSTR_CLR		; 文字列表示クリア

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

	MOV	DX,DSP_HP		; ＨＰ
	CALLC	DECSTR			; dec -> string.
	MOV	AX,DS:[SI][1]		;
	MOV	BX,DS:[SI][3]		;
	MOV	DS:[DI],   BYTE PTR 'H'	;
	MOV	DS:[DI][1],BYTE PTR 'P'	;
	MOV	DS:[DI][2],AX		;
	MOV	DS:[DI][4],BX		;
	MOV	DS:[DI][6],BYTE PTR 0	; end of string.

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
;*;	DEC	BX			;
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	MITPRN			; mini string. (null=end of string)
;*;	CALLC	MWTPRN			; WIDE string. (null=end of string)

	MOV	AX,DSP_HP		; ＨＰ
	CALL	HBER_VALUE_HP		; ＨＰのスケール
	MOV	HD_DSPVAL,AX		; ヘッダー表示値

	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
	ADDX	XX1,W_CLM7		; カラム・ＨＰグラフ

	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADDX	YY1,W_LIN7		; 行　　・ＨＰグラフ

	MOVX	HD_DSPWD,W_HP_WD	; ＨＰのグラフ表示太さ
	MOVX	HD_DSPCOL,W_HP_COL	; ＨＰのグラフ表示色
	MOVX	HD_DSPCOLR,W_HP_COLR	; ＨＰのヘッダーグラフレッドゾーン色
	CALL	WIDHED_HBER		; ヘッダーグラフ描画
	RET
WIDHED_HP	ENDP


;	ヘッダ・レベル　表示
;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;	    HD_DSPYY : ヘッダー表示Ｙ位置
;	    DSP_LVL : レベル

WIDHED_LVL	PROC	NEAR
	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
	ADDX	XX1,W_CLM9		; カラム・レベル数値

	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADDX	YY1,W_LIN9		; 行　　・レベル数値

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	ADD	BX,1			; +1
	MOV	CX,11			; 文字長さ
	MOV	DX,10			; 文字サイズ 10=8x8
	MOV	DI,W_COL3		; カラー・暗い灰
	MOV	SI,W_COL4		; カラー・黒
	CALLC	DSPSTR_CLR		; 文字列表示クリア


	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

	MOV	DS:[DI],   BYTE PTR 'L'	;
	MOV	DS:[DI][1],BYTE PTR 'e'	;
	MOV	DS:[DI][2],BYTE PTR 'v'	;
	MOV	DS:[DI][3],BYTE PTR 'e'	;
	MOV	DS:[DI][4],BYTE PTR 'l'	;
	MOV	DS:[DI][5],BYTE PTR 0	; end of string.

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	ADD	BX,2			; +2
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	MITPRN			; mini string. (null=end of string)


	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

	MOV	DX,DSP_LVL		; レベル
	CALLC	DECSTR			; dec -> string.
	MOV	BX,DS:[SI][3]		;
	MOV	DS:[DI][0],BX		;
	MOV	DS:[DI][2],BYTE PTR 0	; end of string.

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	ADD	AX,5			;
;*;	DEC	BX			;
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
;*;	CALLC	MITPRN			; mini string. (null=end of string)
	CALLC	MWTPRN			; WIDE string. (null=end of string)

	RET
WIDHED_LVL	ENDP


;	ヘッダ・星座　表示
;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;	    HD_DSPYY : ヘッダー表示Ｙ位置
;	    DSP_SEIZA: 星座
;	    DSP_BLOOD: 血液型

WIDHED_SEIZA	PROC	NEAR
	MOV	AX,HD_DSPXX		; ヘッダー表示Ｘ位置
	MOV	BX,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADD	AX,W_CLM10		; カラム・星座
	ADD	BX,W_LIN10		; 行　　・星座
	MOV	SEIZA_X,AX		; 星座Ｘ
	MOV	SEIZA_Y,BX		; 星座Ｙ
	MOVX	SEIZA_NM,DSP_SEIZA	; 星座
	CALL	SEIZA_HYOUZI		; 星座表示

	MOVX	BLOOD_NM,DSP_BLOOD	; 血液型
	CALL	BLOOD_HYOUZI		; 血液型表示
	RET
WIDHED_SEIZA	ENDP


;	星座表示
;	-I- SEIZA_X   : 星座Ｘ
;	    SEIZA_Y   : 星座Ｙ
;	    SEIZA_NM  : 星座名

SEIZA_HYOUZI	PROC	NEAR
	MOV	BX,SEIZA_NM		; 星座名
	CALLC	R_ENV_IDNAME		; 環境文字のＩＤ検索
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	SEIZA_HYOUZI_EXIT	;

					; DL : ＩＤ(サーチバイト)
	MOVX	ES,DS			;
	MOV	DI,OFFSET SEIZA_ID_TABLE ; 星座テーブル
	CALLC	BYTE_TBL_SCH		; バイトテーブルサーチ
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	SEIZA_HYOUZI_EXIT	;

	MOV	DX,CX			; 星座
	MOV	AX,SEIZA_X		; 星座Ｘ
	MOV	BX,SEIZA_Y		; 星座Ｙ
	CALLC	PT_PUT_SEIZA		; 星座ＰＵＴ
SEIZA_HYOUZI_EXIT:
	RET
SEIZA_HYOUZI	ENDP


;	血液型表示
;	-I- SEIZA_X   : 星座Ｘ
;	    SEIZA_Y   : 星座Ｙ
;	    BLOOD_NM  : 血液型

BLOOD_HYOUZI	PROC	NEAR
	MOV	BX,BLOOD_NM		; 血液型
	CALLC	R_ENV_IDNAME		; 環境文字のＩＤ検索
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	BLOOD_HYOUZI_EXIT	;

					; DL : ＩＤ(サーチバイト)
	MOVX	ES,DS			;
	MOV	DI,OFFSET BLOOD_ID_TABLE ; 血液型ＩＤテーブル
	CALLC	BYTE_TBL_SCH		; バイトテーブルサーチ
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	BLOOD_HYOUZI_EXIT	;

	MOV	DX,CX			; 星座
	MOV	AX,SEIZA_X		; 星座Ｘ
	MOV	BX,SEIZA_Y		; 星座Ｙ
	CALLC	PT_PUT_BLOOD		; 血液型ＰＵＴ
BLOOD_HYOUZI_EXIT:
	RET
BLOOD_HYOUZI	ENDP


;	ヘッダ・お金　表示
;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;	    HD_DSPYY : ヘッダー表示Ｙ位置
;	    DSP_GOLD : お金

WIDHED_GOLD	PROC	NEAR
	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
	ADDX	XX1,W_CLM11		; カラム・お金

	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	ADDX	YY1,W_LIN11		; 行　　・お金

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	ADD	BX,1			; +1
	MOV	CX,12			; 文字長さ
	MOV	DX,10			; 文字サイズ 10=8x8
	MOV	DI,W_COL3		; カラー・暗い灰
	MOV	SI,W_COL4		; カラー・黒
	CALLC	DSPSTR_CLR		; 文字列表示クリア

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	ADD	AX,5			; +5
	SUB	BX,5			; -5
	MOV	CX,5			; 文字長さ
	MOV	DX,0			; 文字サイズ 0=16x16
	MOV	DI,W_COL3		; カラー・暗い灰
	MOV	SI,W_COL4		; カラー・黒
	CALLC	DSPSTR_CLR		; 文字列表示クリア


	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

	MOV	DS:[DI],   BYTE PTR 'G'	;
	MOV	DS:[DI][1],BYTE PTR 'O'	;
	MOV	DS:[DI][2],BYTE PTR 'L'	;
	MOV	DS:[DI][3],BYTE PTR 'D'	;
	MOV	DS:[DI][4],BYTE PTR 0	; end of string.

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	ADD	BX,2			; +2
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	MITPRN			; mini string. (null=end of string)

	MOV	DX,DSP_GOLD		; お金
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	CALLC	STRSPL			; space pless. "  123" - > "123  "

	MOVX	ES,DS			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	DS:[DI][0],BYTE PTR '$'	;
	MOVX	DS:[DI][1],DS:[SI][0]	;
	MOVX	DS:[DI][3],DS:[SI][2]	;
	MOVX	DS:[DI][5],DS:[SI][4]	;
	MOVX	DS:[DI][7],DS:[SI][6]	;

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	ADD	AX,4			; +4
	SUB	BX,3			; -3
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	MGXPRN			; GAINAX mini string.
;*;	CALLC	MDTPRN			; MID string. (null=end of string)
;*;	CALLC	MITPRN			; mini string. (null=end of string)
;*;	CALLC	MWTPRN			; WIDE string. (null=end of string)
	RET
WIDHED_GOLD	ENDP




;	文字列の表示
;	-I- HD_DSPSTR : ヘッダー文字列
;	    MAXLEN    : 文字列最大長さ
;	    XX1       : Ｘ座標
;	    YY1       : Ｙ座標
;	    HD_DSPCL2 : ヘッダー文字表示色
;	    HD_DSPCSZ : ヘッダー文字表示サイズ

WIDHED_STRINGS	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,HD_DSPSTR		; ヘッダー文字列（文字列のアドレス）

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,MAXLEN		; 文字列最大長さ
	CALLC	STRSET			; 文字列バッファセット

	MOV	DI,MAXLEN		; 文字列最大長さ
	ADD	DI,1			;
	MOV	DS:STR_BUFF[DI],WORD PTR 0 ; EOS


	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALL	STRING_PUT		; 文字列表示

	POP	BX			;
	POP	ES			;
	RET
WIDHED_STRINGS	ENDP


;	文字列表示
;	-I- DS:[SI]   : 文字列バッファ
;	    XX1       : Ｘ座標
;	    YY1       : Ｙ座標
;	    HD_DSPCL2 : ヘッダー文字表示色
;	    HD_DSPCSZ : ヘッダー文字表示サイズ

STRING_PUT	PROC	NEAR
	PUSH	SI

	MOV	AX,HD_DSPCSZ		; ヘッダー文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,0			; ヘッダー文字表示色
	CALLC	VTXCOL			; character color set.

	POP	SI			;
	PUSH	SI			;

	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	ADD	BX,1			;
	CALLC	VTXPOR			; vram text print OR.

	POP	SI			;
	PUSH	SI			;

	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,HD_DSPCL2		; ヘッダー文字表示色
	CALLC	VTXCOL			; character color set.

	POP	SI			;
	PUSH	SI			;

	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	SUB	BX,1			;
	CALLC	VTXPOR			; vram text print OR.

	POP	SI
	RET
STRING_PUT	ENDP



;	レベルのスケール
;	-I/O- AX : 内容表示値

HBER_VALUE_MP	PROC	NEAR
	SHL	AX,1
	SHL	AX,1
	CMP	AX,120			; １２０まで
	JB	HBER_VALUE_MP_EXIT	;
	MOV	AX,120			; １２０
HBER_VALUE_MP_EXIT:
	RET
HBER_VALUE_MP	ENDP



;	ＨＰのスケール
;	-I/O- AX : 内容表示値

HBER_VALUE_HP	PROC	NEAR
	CMP	AX,100			; 内容表示値
	JNB	HBER_VALUE_HP_100	; 100以上

	SHR	AX,1			; AX = AX / 2
	JMP	HBER_VALUE_HP_EE	; メータ５０まで

HBER_VALUE_HP_100:			;
	MOV	DX,0			;
	MOV	BX,25			; AX = AX / 25
	DIV	BX			;
	ADD	AX,50-4			; メータ５０から１２０まで
HBER_VALUE_HP_EE:
	CMP	AX,120-5		; １２０まで
	JB	HBER_VALUE_HP_EXIT	;
	MOV	AX,120-5		; １２０
HBER_VALUE_HP_EXIT:
	RET
HBER_VALUE_HP	ENDP



;	ヘッダーグラフ描画
;	-I- HD_DSPVAL: ヘッダー表示値
;	    XX1      : Ｘ座標
;	    YY1      : Ｙ座標
;	    HD_DSPWD : ヘッダーグラフ表示太さ
;	    HD_DSPCOL: ヘッダーグラフ表示色
;	    HD_DSPCOLR: ヘッダーグラフレッドゾーン表示色

WIDHED_HBER	PROC	NEAR
;*;	PRV	"XX1=",XX1
;*;	PRV	"YY1=",YY1

	PUSH	ES			;
	PUSH	BX			;

	MOV	AX,XX1			; Ｘ座標
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; グラフ表示Ｘ位置

	ADD	AX,HD_DSPVAL		; ヘッダー表示値
	MOV	VX2,AX			;

	MOV	AX,YY1			; Ｙ座標
	MOV	VY1,AX			;

;*;	ADD	VX1,2			;
;*;	ADD	VX2,2			;
;*;	ADD	VY1,2			;
;*;	MOV	CX,HD_DSPWD		; ヘッダーグラフ表示太さ
;*;	MOVX	VCOL,W_COL4		; カラー・黒
;*;	CALLC	DLINEH			; 水平ライン描画
;*;	SUB	VX1,2			;
;*;	SUB	VX2,2			;
;*;	SUB	VY1,2			;

	MOV	CX,HD_DSPWD		; ヘッダーグラフ表示太さ
	MOVX	VCOL,HD_DSPCOL		; ヘッダーグラフ表示色
	CALLC	DLINEH			; 水平ライン描画

	CMP	HD_DSPVAL,50-4		; レッドゾーンか？
	JBE	WIDHED_HBER_5		;

	ADD	VX1,50-4		; グラフ表示Ｘ位置
	MOV	CX,HD_DSPWD		; ヘッダーグラフ表示太さ
	MOVX	VCOL,HD_DSPCOLR		; ヘッダーグラフレッドゾーン表示色
	CALLC	DLINEH			; 水平ライン描画
WIDHED_HBER_5:				;

WIDHED_HBER_EXIT:
	POP	BX			;
	POP	ES			;
	RET
WIDHED_HBER	ENDP



;	ヘッダーのフレーム
;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;	    HD_DSPYY : ヘッダー表示Ｙ位置

WIDHED_FLAME	PROC	NEAR
	MOVX	WDX1,HD_DSPXX		; ヘッダー表示Ｘ位置
	MOVX	WDY1,HD_DSPYY		; ヘッダー表示Ｙ位置
	MOVX	WDX2,W_CLMEE		; カラム・最後
	MOVX	WDY2,W_LINEE		; 行　　・最後
	CALLC	WID_5_FLAME		; WINDOWS/フレーム５（宝石）

	RET

;*NON*;	MOVX	VX1,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	MOVX	VY1,HD_DSPYY		; ヘッダー表示Ｙ位置
;*NON*;	MOVX	VX2,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	MOVX	VY2,HD_DSPYY		; ヘッダー表示Ｙ位置
;*NON*;	ADDX	VX2,W_CLMEE		; カラム・最後
;*NON*;	ADDX	VY2,W_LINEE		; 行　　・最後
;*NON*;	MOV	CX,W_COL3		; カラー・暗い灰
;*NON*;	CALL	BOXPAL			; ＢＯＸペイント
;*NON*;	MOV	CX,W_COL4		; カラー・黒
;*NON*;	CALL	BOXMSS			; ＢＯＸメッシュ
;*NON*;
;*NON*;	MOV	AX,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	SHL	AX,1			;
;*NON*;	SHL	AX,1			;
;*NON*;	SHL	AX,1			; * 8
;*NON*;	MOV	VX1,AX			; ヘッダー表示Ｘ位置
;*NON*;	MOV	AX,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	ADD	AX,W_CLMEE		; カラム・最後
;*NON*;	INC	AX			;
;*NON*;	SHL	AX,1			;
;*NON*;	SHL	AX,1			;
;*NON*;	SHL	AX,1			; * 8
;*NON*;	MOV	VX2,AX			; ヘッダー表示Ｘ位置
;*NON*;
;*NON*;	MOVX	VY1,HD_DSPYY		; ヘッダー表示Ｙ位置
;*NON*;	MOVX	VCOL,W_COL4		; カラー・黒
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;	INC	VY1			;
;*NON*;	MOVX	VCOL,W_COL1		; カラー・ハイライト
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;	INC	VY1			;
;*NON*;	MOVX	VCOL,W_COL2		; カラー・明るい灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;	INC	VY1			;
;*NON*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;	ADDX	VY1,W_LINEE		; 行　　・最後
;*NON*;	SUB	VY1,6			;
;*NON*;
;*NON*;	MOVX	VCOL,W_COL1		; カラー・ハイライト
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;	INC	VY1			;
;*NON*;	MOVX	VCOL,W_COL2		; カラー・明るい灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;	INC	VY1			;
;*NON*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;	INC	VY1			;
;*NON*;	MOVX	VCOL,W_COL4		; カラー・黒
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEH			; 水平ライン描画
;*NON*;
;*NON*;
;*NON*;
;*NON*;	MOVX	VY1,HD_DSPYY		; ヘッダー表示Ｙ位置
;*NON*;
;*NON*;	MOV	AX,HD_DSPYY		; ヘッダー表示Ｙ位置
;*NON*;	ADD	AX,W_LINEE		; 行　　・最後
;*NON*;	DEC	AX			;
;*NON*;	MOV	VY2,AX			;
;*NON*;
;*NON*;
;*NON*;	MOVX	VCOL,W_COL4		; カラー・黒
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;	INC	VX1			;
;*NON*;	INC	VY1			;
;*NON*;	DEC	VY2			;
;*NON*;	MOVX	VCOL,W_COL1		; カラー・ハイライト
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;	INC	VX1			;
;*NON*;	INC	VY1			;
;*NON*;	DEC	VY2			;
;*NON*;	MOVX	VCOL,W_COL2		; カラー・明るい灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;	INC	VX1			;
;*NON*;	INC	VY1			;
;*NON*;	DEC	VY2			;
;*NON*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;
;*NON*;	MOVX	VX1,VX2			;
;*NON*;	SUB	VX1,3			;
;*NON*;
;*NON*;	MOVX	VCOL,W_COL1		; カラー・ハイライト
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;	INC	VX1			;
;*NON*;	DEC	VY1			;
;*NON*;	INC	VY2			;
;*NON*;	MOVX	VCOL,W_COL2		; カラー・明るい灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;	INC	VX1			;
;*NON*;	DEC	VY1			;
;*NON*;	INC	VY2			;
;*NON*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;	INC	VX1			;
;*NON*;	DEC	VY1			;
;*NON*;	INC	VY2			;
;*NON*;	MOVX	VCOL,W_COL4		; カラー・黒
;*NON*;	MOV	CX,1			; 太さ
;*NON*;	CALL	DLINEV			; 垂直ライン描画
;*NON*;
;*NON*;	RET
WIDHED_FLAME	ENDP


;*NON*;;	フレーム内デリミタ配置
;*NON*;;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;*NON*;;	    HD_DSPYY : ヘッダー表示Ｙ位置
;*NON*;
;*NON*;WIDHED_FL_DLM	PROC	NEAR
;*NON*;	MOVX	YY1,HD_DSPYY		; ヘッダー表示Ｙ位置
;*NON*;
;*NON*;	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	ADDX	XX1,W_CLM0		; カラム・先頭
;*NON*;	INC	XX1			;
;*NON*;	CALL	WIDHED_DELIM		; デリミタマーク表示
;*NON*;
;*NON*;	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	ADDX	XX1,W_CLM3		; カラム・称号先頭
;*NON*;	CALL	WIDHED_DELIM		; デリミタマーク表示
;*NON*;	INC	XX1			;
;*NON*;	CALL	WIDHED_DELIM		; デリミタマーク表示
;*NON*;
;*NON*;	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	ADDX	XX1,W_CLM5		; カラム・ＨＰ先頭
;*NON*;	CALL	WIDHED_DELIM		; デリミタマーク表示
;*NON*;	INC	XX1			;
;*NON*;	CALL	WIDHED_DELIM		; デリミタマーク表示
;*NON*;
;*NON*;	MOVX	XX1,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	ADDX	XX1,W_CLMEE		; カラム・最後
;*NON*;	DEC	XX1			;
;*NON*;	CALL	WIDHED_DELIM		; デリミタマーク表示
;*NON*;
;*NON*;	RET
;*NON*;WIDHED_FL_DLM	ENDP



;	デリミタマーク表示
;	-I- XX1 : Ｘ座標
;	    YY1 : Ｙ座標

WIDHED_DELIM	PROC	NEAR
	MOVX	VX1,XX1			; Ｘ座標
	MOVX	VX2,XX1			;

	MOVX	VY1,YY1			;
	MOVX	VY2,YY1			;
	ADD	VY1,3			;
	ADD	VY2,3+15		;

	MOV	CX,W_COL3		; カラー・暗い灰
	CALLC	BOXPAL			; ＢＯＸペイント

	MOVX	VCOL,W_COL1		; カラー・ハイライト
	CALLC	BOXMSS			; ＢＯＸメッシュ

	SHL	VX1,1			;
	SHL	VX1,1			;
	SHL	VX1,1			; * 8

	DEC	VY2
	INC	VY1

	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	MOVX	VCOL,W_COL4		; カラー・黒
	ADD	VX1,8			;
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画
	RET
WIDHED_DELIM	ENDP


;*NON*;;	ヘッダーブリンク
;*NON*;;	タイマ１使用
;*NON*;;	-I- HD_DSPXX : ヘッダー表示Ｘ位置
;*NON*;;	    HD_DSPYY : ヘッダー表示Ｙ位置
;*NON*;
;*NON*;WIDHED_BK	PROC	NEAR
;*NON*;	PUSH	ES			;
;*NON*;	PUSH	BX			;
;*NON*;
;*NON*;	MOV	CX,4			;
;*NON*;WIDHED_BK_LOOP:				;
;*NON*;	PUSH	CX			;
;*NON*;	MOV	AX,5			; wait timer count.
;*NON*;	CALL	TMVSET			; V-SYNC timer set.
;*NON*;	MOVX	VX1,HD_DSPXX		; ヘッダー表示Ｘ位置
;*NON*;	MOVX	VX2,VX1			;
;*NON*;	ADDX	VX2,W_CLMEE		; カラム・最後
;*NON*;	MOV	AX,HD_DSPYY		; ヘッダー表示Ｙ位置
;*NON*;	MOV	VY1,AX			;
;*NON*;	ADD	AX,W_LINEE		; 行　　・最後
;*NON*;	DEC	AX			;
;*NON*;	DEC	AX			;
;*NON*;	MOV	VY2,AX			;
;*NON*;	MOV	CX,1111B		;
;*NON*;	CALL	BOXNOT			; ＢＯＸ反転
;*NON*;	CALL	TMVEWT			; V-SYNC timer end wait.
;*NON*;	POP	CX			;
;*NON*;	LOOP	WIDHED_BK_LOOP		;
;*NON*;
;*NON*;	POP	BX			;
;*NON*;	POP	ES			;
;*NON*;	RET
;*NON*;WIDHED_BK	ENDP

WINDOW	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

WIDHED_UP	DW	0		; ヘッダー描画開始位置
WIDHED_CNT	DW	25		; ヘッダー描画本数
WIDHED_START	DW	0		; ヘッダー描画開始番号
WIDHED_END	DW	24		; ヘッダー描画終了番号

WIDHED_SRTX	DW	31		; 内容表示 開始位置Ｘ
WIDHED_SRTY	DW	0		; 内容表示 開始位置Ｙ

W_CLM0		DW	0		; カラム・先頭
W_LIN0		DW	0		; 行　　・先頭

W_CLM2		DW	2		; カラム・名
W_LIN2		DW	0+7		; 行　　・名

W_CLM1		DW	2+12		; カラム・姓
W_LIN1		DW	0+7		; 行　　・姓

W_CLM3		DW	2		; カラム・称号先頭
W_LIN3		DW	8*2+7		; 行　　・称号先頭

W_CLM4		DW	7		; カラム・称号
W_LIN4		DW	8*2+7		; 行　　・称号

W_CLM5		DW	1		; カラム・ＨＰ先頭
W_LIN5		DW	8*5+11		; 行　　・ＨＰ先頭
W_CLM6		DW	1		; カラム・ＨＰ数値
W_LIN6		DW	8*5+11		; 行　　・ＨＰ数値
W_CLM7		DW	1+6		; カラム・ＨＰグラフ
W_LIN7		DW	8*5+11		; 行　　・ＨＰグラフ

W_CLM8		DW	1		; カラム・レベル先頭
W_LIN8		DW	8*4+7		; 行　　・レベル先頭
W_CLM9		DW	1		; カラム・レベル数値
W_LIN9		DW	8*4+7		; 行　　・レベル数値
W_CLM10		DW	22		; カラム・星座
W_LIN10		DW	8*3+1		; 行　　・星座
W_CLM11		DW	12		; カラム・お金
W_LIN11		DW	8*4+7		; 行　　・お金
;*;W_CLM10	DW	2		; カラム・レベルグラフ
;*;W_LIN10	DW	8*7+8		; 行　　・レベルグラフ

W_CLMEE		DW	20+7		; カラム・最後
W_LINEE		DW	8*12-8*4	; 行　　・最後

LOCATE_HIGHT	DW	8		; 表示ライン１本の高さ
HEAD_HIGHT	DW	24-8		; ヘッダー１本の高さ

W_HP_WD		DW	6		; ＨＰのグラフ表示太さ
W_HP_COL	DW	8		; ＨＰのグラフ表示色
W_HP_COLR	DW	15		; ＨＰのヘッダーグラフレッドゾーン色

W_MP_WD		DW	6		; レベルのグラフ表示太さ
W_MP_COL	DW	8		; レベルのグラフ表示色
W_MP_COLR	DW	15		; レベルのヘッダーグラフレッドゾーン色

W_GRP_COLB	DW	2		; グラフＯＦＦ部分色

HEAD_ADRS	DW	0		; ヘッダーアドレス

DSP_FNAME	DW	0		; 姓
DSP_NAME	DW	0		; 名
DSP_SHOGO	DW	0		; 称号
DSP_HP		DW	0		; ＨＰ
DSP_LVL		DW	0		; レベル
DSP_HELP	DW	0		; 説明
DSP_FLAGS	DW	0		; フラグ
DSP_GR_OFS	DW	0		; グラフテーブルオフセット
DSP_GR_MAX	DW	0		; グラフテーブルレコード数
DSP_VA_OFS	DW	0		; 内容表示テーブルオフセット
DSP_VA_MAX	DW	0		; 内容表示テーブルレコード数
DSP_SEIZA	DW	0		; 星座
DSP_BLOOD	DW	0		; 血液型
DSP_GOLD	DW	0		; お金

HD_DSPXX	DW	0		; ヘッダー表示Ｘ位置
HD_DSPYY	DW	0		; ヘッダー表示Ｙ位置
HD_DSPCL2	DW	0		; ヘッダー文字表示色
HD_DSPCSZ	DW	0		; ヘッダー文字表示サイズ
HD_DSPVAL	DW	0		; ヘッダー表示値
HD_DSPSTR	DW	0		; ヘッダー文字列

HD_DSPWD	DW	0		; ヘッダーグラフ表示太さ
HD_DSPCOL	DW	0		; ヘッダーグラフ表示色
HD_DSPCOLR	DW	0		; ヘッダーグラフレッドゾーン表示色

XX1		DW	0		; Ｘ座標
YY1		DW	0		; Ｙ座標
MAXLEN		DW	0		; 文字列最大長さ

SEIZA_X		DW	0		; 星座Ｘ
SEIZA_Y		DW	0		; 星座Ｙ
SEIZA_NM	DW	0		; 星座名
BLOOD_NM	DW	0		; 血液型

USER_LENGTH	DW	0		; ユーザ文字長さ

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

SEIZA_ID_TABLE	LABEL	BYTE
		DB	12		;max.
		DB	ID_88		; おひつじ座
		DB	ID_89		; おうし座
		DB	ID_90		; ふたご座
		DB	ID_91		; かに座
		DB	ID_92		; しし座
		DB	ID_93		; おとめ座
		DB	ID_94		; てんびん座
		DB	ID_95		; さそり座
		DB	ID_96		; いて座
		DB	ID_97		; やぎ座
		DB	ID_98		; みずがめ座
		DB	ID_99		; うお座
		DB	0

;	血液型ＩＤテーブル
;
;	1=Ａ型
;	2=Ｂ型
;	3=ＡＢ型
;	4=Ｏ型

BLOOD_ID_TABLE	LABEL	BYTE
		DB	4		;max.
		DB	ID_104		; Ａ型
		DB	ID_106		; Ｂ型
		DB	ID_105		; ＡＢ型
		DB	ID_107		; Ｏ型
		DB	0

MSG_SHOGO	DB	"称号",0,0

DATA	ENDS

	END
;
;	end of "WIDHED.ASM"
;
