; "R_KENSAK.ASM.ASM" PC-9801UV11 make by R.H 1990/11/8
;
;
;	「子育て」
;
;	検索
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	WORDID.INC


K_TBL_SIZE	EQU	20	; 検索テーブルサイズ

STYL_OFS_I_NAME	EQU	0	;［アイテム種別名　　］
STYL_OFS_P_MAX	EQU	2	;［パラメータ数　　　］
STYL_OFS_P_WORD	EQU	4	;［パラメータＷＯＲＤ数］


MOVX	MACRO	DEST,SOUR
	MOV	AX,WORD PTR SOUR
	MOV	WORD PTR DEST,AX
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

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	R_ITEM_SCH		; アイテム条件検索
PUBLIC	R_WORK_SCH		; 行い条件検索

PUBLIC	R_WORK_RGET		; 行いレコードＧＥＴ

PUBLIC	R_GET_SELECT		; ｱｲﾃﾑレコード内から選択単語を取り出す
PUBLIC	R_ADD_SELECT		; 選択単語へ追加

PUBLIC	R_ITM_MOCHIMON		; 持物アイテム検索
PUBLIC	R_ITM_SYUBETU		; 持物アイテム種別検索
PUBLIC	R_ITM_OFFSET		; 持物アイテムのアイテムオフセット計算
PUBLIC	R_ITM_MOCH_DEL		; 持物アイテム削除
PUBLIC	R_ITM_MOCH_INS		; 持物アイテム追加
PUBLIC	R_ITM_DOUBLE		; 持物アイテム重複チェック
PUBLIC	R_ITM_SOUBI_OUT		; 装備外されチェック
PUBLIC	R_ITEM_NMSH		; 名前でアイテム検索
PUBLIC	R_ITM_MOTTERU		; 持っているか検索
PUBLIC	R_MAGIC_ARU		; 所有魔法ある？
PUBLIC	R_MAGIC_LIST		; 所有魔法リスト
PUBLIC	R_K_CALC_MAHO		; 魔法を手に入れた
PUBLIC	R_SHOGO_TAKE		; 称号を手に入れた

PUBLIC	R_GET_LVL		; レベル

PUBLIC	R_KAIWA_JYOHO		; 会話情報

PUBLIC	R_ENV_IDNAME		; 環境文字のＩＤ検索

EXTRN	WIDITEM_STYLE:NEAR	; WINDOWS/アイテムスタイルリスト
EXTRN	WIDWAZA_STYLE:NEAR	; WINDOWS/技（わざ）スタイルリスト
EXTRN	WIDWORKS_STYLE:NEAR	; WINDOWS/行い（おこない）スタイルリスト

EXTRN	R_KEISAN:NEAR		; 各計算処理

; ****************************************************
;	アイテム条件検索
;	-I- DX : 種別・0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾
;		 4=道具,5=資格
;	-O- K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_ITEM_SCH	PROC	NEAR
	CALL	R_ITEM_STYLE		; アイテム・スタイルリストＧＥＴ
	CALL	R_ITEM_TOP		; アイテム先頭検索
	CALL	R_ITEM_SCH_GET		; アイテム検索とテーブルセット
	RET
R_ITEM_SCH	ENDP


; ****************************************************
;	持物アイテム検索
;	-I- AX            : 誰か（アドレス）
;	-O- K_TBL_ATR[]   : 検索レコード種別テーブル
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_ITM_MOCHIMON	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	; 持物リスト

	MOV	BX,AX			; 誰か（アドレス）
	MOV	SI,ES:[BX][HED_LST_MT]	; SI=持物リスト

				; ナオコ持物	LABEL	WORD
				;	DW	20	; 持物最大
				;	DW	0	; 持物数
				;	DW	20*2 DUP (0)

	; 持物数

	MOV	CX,ES:[SI][TKE_MAX]	; CX=数
	ADD	SI,TKE_TABLE		; SI=テーブル

	; コピー

	MOV	DI,0			; word pointer.
	CMP	CX,K_TBL_SIZE		; 検索レコードテーブルサイズ
	JBE	R_ITM_MOCHIMON_5	;
	MOV	CX,K_TBL_SIZE		; 検索レコードテーブルサイズ
R_ITM_MOCHIMON_5:
	MOV	K_TBL_MAX,CX		; 検索レコード数

	JCXZ	R_ITM_MOCHIMON_EXIT	;
R_ITM_MOCHIMON_LOOP:			;
	MOV	AX,ES:[SI]		;
	MOV	BX,ES:[SI][2]		;
	MOV	DS:K_TBL_ATR[DI],AX	; 検索レコード種別テーブル
	MOV	DS:K_TBL_REC[DI],BX	; 検索レコードテーブル
	ADD	SI,4			; double word pointer.
	ADD	DI,2			; word pointer.
	LOOP	R_ITM_MOCHIMON_LOOP	;

R_ITM_MOCHIMON_EXIT:
	RET
R_ITM_MOCHIMON	ENDP


; ****************************************************
;	持物アイテム種別検索
;	-I- AX            : 誰か（アドレス）
;	    DX            : 検索するアイテム属性
;	-O- K_TBL_ATR[]   : 検索レコード種別テーブル
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_MOCHI[] : 検索レコード持物テーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_ITM_SYUBETU	PROC	NEAR
	MOV	REC_ATR,DX		; 検索するアイテム属性
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	; 持物リスト

	MOV	BX,AX			; 誰か（アドレス）
	MOV	SI,ES:[BX][HED_LST_MT]	; SI=持物リスト

	; 持物数

	MOV	CX,ES:[SI][TKE_MAX]	; CX=数
	ADD	SI,TKE_TABLE		; SI=テーブル

	; コピー

	MOV	DI,0			; word pointer.
	CMP	CX,K_TBL_SIZE		; 検索レコードテーブルサイズ
	JBE	R_ITM_SYUBETU_5		;
	MOV	CX,K_TBL_SIZE		; 検索レコードテーブルサイズ
R_ITM_SYUBETU_5:
	MOV	K_TBL_MAX,0		; 検索レコード数

	MOV	REC_NO,0		; 持物レコード番号
	JCXZ	R_ITM_SYUBETU_EXIT	;
R_ITM_SYUBETU_LOOP:			;
	MOV	AX,ES:[SI]		; アイテム種別
	MOV	BX,ES:[SI][2]		; レコード番号
	ADD	SI,4			; double word pointer.
	CMP	AX,REC_ATR		; アイテム属性は同じか？
	JNE	R_ITM_SYUBETU_NEXT	;

	MOV	DS:K_TBL_ATR[DI],AX	; 検索レコード種別テーブル
	MOV	DS:K_TBL_REC[DI],BX	; 検索レコードテーブル
	MOVX	DS:K_TBL_MOCHI[DI],REC_NO ; 検索レコード持物テーブル
	ADD	DI,2			; word pointer.
	INC	K_TBL_MAX		; 検索レコード数
R_ITM_SYUBETU_NEXT:			;
	INC	REC_NO			; 持物レコード番号
	LOOP	R_ITM_SYUBETU_LOOP	;

R_ITM_SYUBETU_EXIT:
	RET
R_ITM_SYUBETU	ENDP


; ****************************************************
;	持物アイテムのアイテムオフセット計算
;	-I- K_TBL_ATR[]   : 検索レコード種別テーブル
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_MAX     : 検索レコード数
;	-O- K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
; ****************************************************

R_ITM_OFFSET	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	DI,0				; word pointer.

	MOV	CX,K_TBL_MAX			; 検索レコード数
	JCXZ	R_ITM_OFFSET_LOOP_END		;
R_ITM_OFFSET_LOOP:

	MOV	BX,K_TBL_ATR[DI]		; アイテム種別
	SHL	BX,1				;
	SHL	BX,1				; 4 byte pointer.
	ADD	BX,WIDOFS_ITEM			; アイテムテーブル
	MOV	SI,ES:[BX]			; CX=種別のアイテムテーブル先頭

	MOV	AX,K_TBL_REC[DI]		; レコード番号
	MOV	BX,ITM_NEXT			; 次のアイテム
	MUL	BX				;
	ADD	AX,SI				;
	MOV	K_TBL_OFSET[DI],AX		; 検索レコードｵﾌｾｯﾄテーブル
	INC	DI				;
	INC	DI				; word pointer.
	LOOP	R_ITM_OFFSET_LOOP
R_ITM_OFFSET_LOOP_END:

	RET
R_ITM_OFFSET	ENDP


; ****************************************************
;	持物アイテム削除
;	-I- AX : 誰か（アドレス）
;	    DX : 持物リスト削除番号
; ****************************************************

R_ITM_MOCH_DEL	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	; 持物リスト

	MOV	BX,AX			; 誰か（アドレス）
	MOV	DI,ES:[BX][HED_LST_MT]	; DI=持物リスト

					; ナオコ持物	LABEL	WORD
					;	DW	20	; 持物最大
					;	DW	0	; 持物数
					;	DW	20*2 DUP (0)
	; 持物数

	MOV	CX,ES:[DI][TKE_DIM]	; CX=持物最大
	MOV	AX,ES:[DI][TKE_MAX]	; AX=持物数
	CMP	AX,0			;
	JE	R_ITM_MOCH_DEL_EXIT 	; 持物なければおわり

	DEC	WORD PTR ES:[DI][TKE_MAX] ; 持物数－１

	ADD	DI,TKE_TABLE		; DI=テーブル
	
	SUB	CX,DX			; 持物リスト削除番号
	DEC	CX			; -1
	SHL	DX,1			;
	SHL	DX,1			; * 4
	ADD	DI,DX			; 持物リスト削除番号へ、
	JCXZ	R_ITM_MOCH_DEL_EXIT	;
R_ITM_MOCH_DEL_LOOP:
	MOV	AX,ES:[DI][4]
	MOV	BX,ES:[DI][6]
	MOV	ES:[DI][0],AX
	MOV	ES:[DI][2],BX
	ADD	DI,4			; + 4
	LOOP	R_ITM_MOCH_DEL_LOOP

R_ITM_MOCH_DEL_EXIT:
	RET
R_ITM_MOCH_DEL	ENDP


; ****************************************************
;	持物アイテム追加
;	-I- AX : 誰か（アドレス）
;	    CX : アイテム種別
;		0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾,4=道具,5=資格
;	    DX : アイテムレコードＮＯ
;	-O- AX : 0=ＯＫ,2=いっぱいで持てません
; ****************************************************

R_ITM_MOCH_INS	PROC	NEAR
	MOV	ADRS_HOW,AX		; 誰か（アドレス）
	MOV	VAL_ATTR,CX		; 種別
	MOV	VAL_RECNO,DX		; レコードＮＯ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	; 持物リスト

	MOV	BX,AX			; 誰か（アドレス）
	MOV	DI,ES:[BX][HED_LST_MT]	; DI=持物リスト

					; ナオコ持物	LABEL	WORD
					;	DW	20	; 持物最大
					;	DW	0	; 持物数
					;	DW	20*2 DUP (0)
	; 持物数

	MOV	CX,ES:[DI][TKE_DIM]	; CX=持物最大
	MOV	AX,ES:[DI][TKE_MAX]	; AX=持物数
	CMP	AX,CX			;
	JNB	R_ITM_MOCH_INS_UPP	;

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

	MOV	AX,0		; 0=買いました
	RET
R_ITM_MOCH_INS_UPP:
	MOV	AX,2		; 2=いっぱいで持てません
	RET
R_ITM_MOCH_INS	ENDP


; ****************************************************
;	持物アイテム重複チェック
;	-I- AX : 誰か（アドレス）
;	    DX : 持物リスト番号
;	-O- AX : 0=重複しない,1=重複する
;	    BX : アイテム種別
;	    CX : レコード番号
;
;	 ナオコ持物	LABEL	WORD
;		DW	20	; 持物最大
;		DW	0	; 持物数
;		DW	20*2 DUP (0)
; ****************************************************

R_ITM_DOUBLE	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	; 持物リスト

	MOV	BX,AX			; 誰か（アドレス）
	MOV	DI,ES:[BX][HED_LST_MT]	; DI=持物リスト

	; 持物

	MOV	BX,DX			; 持物リスト番号
	SHL	BX,1			;
	SHL	BX,1			; 2word pointer.
	MOV	AX,ES:[DI][BX][TKE_TABLE]    ; AX=削除するアイテム種別
	MOV	DX,ES:[DI][BX][TKE_TABLE][2] ; DX=削除するレコード番号

	MOV	ITEM_ATR,AX		; アイテム種別
	MOV	ITEM_REC,DX		; レコード番号

	; 持物数

	MOV	CX,ES:[DI][TKE_MAX]	; CX=持物数
	CMP	CX,0			;
	JE	R_ITM_DOUBLE_NASI	; 持物なければおわり

	; 重複チェック

	MOV	NUM,0				; 見つかり数
	MOV	BX,0				; ポインタ
R_ITM_DOUBLE_LOOP:
	CMP	AX,ES:[DI][BX][TKE_TABLE]	; AX=削除するアイテム種別
	JNE	R_ITM_DOUBLE_NEXT		;
	CMP	DX,ES:[DI][BX][TKE_TABLE][2]	; DX=削除するレコード番号
	JNE	R_ITM_DOUBLE_NEXT		;
	INC	NUM				; 見つかり数
R_ITM_DOUBLE_NEXT:
	ADD	BX,4				; 2 word pointer.
	LOOP	R_ITM_DOUBLE_LOOP

	CMP	NUM,1				; 見つかり数
	JNBE	R_ITM_DOUBLE_SURU		;

R_ITM_DOUBLE_NASI:
	MOV	AX,0			; 0=重複しない
	MOV	BX,ITEM_ATR		; アイテム種別
	MOV	CX,ITEM_REC		; レコード番号
	RET
R_ITM_DOUBLE_SURU:
	MOV	AX,1			; 1=重複する
	MOV	BX,ITEM_ATR		; アイテム種別
	MOV	CX,ITEM_REC		; レコード番号
	RET
R_ITM_DOUBLE	ENDP


; ****************************************************
;	装備外されチェック
;	-I- AX : 誰か（アドレス）
;	    BX : アイテム種別
;	    CX : レコード番号
;	-O- AX : 0=なし,1=外されるべき装備がある
; ****************************************************

R_ITM_SOUBI_OUT	PROC	NEAR
	MOV	ADRS_HOW,AX		; 誰か（アドレス）
	MOV	ITEM_ATR,BX		; アイテム種別
	MOV	ITEM_REC,CX		; レコード番号

	; 装備リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ADRS_HOW		; 人物
	MOV	SI,ES:[DI][HED_LST_SB]	; BX=装備リスト

	MOV	DX,ITEM_ATR		; アイテム種別
	MOV	CX,ITEM_REC		; レコード番号

	; 0.武器

	MOV	BX,0			;
	CMP	ES:[SI][BX]   ,DX	; アイテム種別
	JNE	R_ITM_SOUBI_OUT_1	;
	CMP	ES:[SI][BX][2],CX	; レコードＮＯ
	JNE	R_ITM_SOUBI_OUT_1	;
	JMP	R_ITM_SOUBI_OUT_HAZU	;
R_ITM_SOUBI_OUT_1:			;

	; 1.防具・兜

	MOV	BX,4			;
	CMP	ES:[SI][BX]   ,DX	; アイテム種別
	JNE	R_ITM_SOUBI_OUT_2	;
	CMP	ES:[SI][BX][2],CX	; レコードＮＯ
	JNE	R_ITM_SOUBI_OUT_2	;
	JMP	R_ITM_SOUBI_OUT_HAZU	;
R_ITM_SOUBI_OUT_2:			;

	; 2.防具・鎧

	MOV	BX,8			;
	CMP	ES:[SI][BX]   ,DX	; アイテム種別
	JNE	R_ITM_SOUBI_OUT_3	;
	CMP	ES:[SI][BX][2],CX	; レコードＮＯ
	JNE	R_ITM_SOUBI_OUT_3	;
	JMP	R_ITM_SOUBI_OUT_HAZU	;
R_ITM_SOUBI_OUT_3:			;

R_ITM_SOUBI_OUT_NORMAL:
	MOV	AX,0			; 0=なし
	RET
R_ITM_SOUBI_OUT_HAZU:
	MOV	AX,1			; 1=外されるべき装備がある
	RET
R_ITM_SOUBI_OUT	ENDP



; ****************************************************
;	アイテム検索とテーブルセット
;	-I- TOP_ADRS : アイテム先頭オフセット
;	    REC_MAX  : アイテム数
;	-O- K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_ITEM_SCH_GET	PROC	NEAR
	MOVX	PNT_ADRS,TOP_ADRS		; アイテムオフセットポインタ

	MOV	REC_NO,0			; アイテムレコード番号

	MOV	K_TBL_MAX,0			; 検索レコード数
R_ITEM_SCH_GET_LOOP:
	CMPX	K_TBL_MAX,K_TBL_DIM		; 検索レコードテーブルサイズ
	JGE	R_ITEM_SCH_GET_LOOP_END		;

	CMPX	REC_NO,REC_MAX			; アイテム数
	JGE	R_ITEM_SCH_GET_LOOP_END		;

	MOV	BX,K_TBL_MAX			; 検索レコード数
	SHL	BX,1				; word pointer.
	MOVX	DS:K_TBL_REC[BX],REC_NO		; アイテムレコード番号
	MOVX	DS:K_TBL_OFSET[BX],PNT_ADRS	; 検索レコードｵﾌｾｯﾄテーブル

	MOV	AX,SYL_ITEM_WORD		; パラメータＷＯＲＤ数
	SHL	AX,1				; byte counter.
	ADD	PNT_ADRS,AX			; アイテムオフセットポインタ

	INC	K_TBL_MAX			; 検索レコード数

	INC	REC_NO				; アイテムレコード番号

	JMP	R_ITEM_SCH_GET_LOOP
R_ITEM_SCH_GET_LOOP_END:
	RET
R_ITEM_SCH_GET	ENDP


; ****************************************************
;	アイテム先頭検索
;	-I- DX : 種別・0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾, 4=道具
;	-O- TOP_ADRS : アイテム先頭オフセット
;	    REC_MAX  : アイテム数
; ****************************************************

R_ITEM_TOP	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,DX			; テーブルのアイテムテーブルを取り出す
	SHL	BX,1			; word pointer.
	SHL	BX,1			; * 4
	ADD	BX,WIDOFS_ITEM		; アイテムテーブル
	MOVX	TOP_ADRS,ES:[BX]	; アイテム先頭オフセット
	MOVX	REC_MAX,ES:[BX][2]	; アイテム数
	RET
R_ITEM_TOP	ENDP



; ****************************************************
;	アイテム・スタイルリストＧＥＴ
;	-I- DX : 種別・0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾, 4=道具
;	-O- STYLE_LIST_ITEM : アイテム・スタイルリスト・アドレス
;	    SYL_ITEM_NAME   : アイテム・アイテム種別名
;	    SYL_ITEM_MAX    : アイテム・パラメータ数
;	    SYL_ITEM_WORD   : アイテム・パラメータＷＯＲＤ数
; ****************************************************

R_ITEM_STYLE	PROC	NEAR
	PUSH	DX

	CALL	WIDITEM_STYLE		; WINDOWS/アイテムスタイルリスト

	MOV	STYLE_LIST_ITEM,BX	; スタイルリスト・アドレス
	MOVX	SYL_ITEM_NAME,DS:[BX][STYL_OFS_I_NAME] ; アイテム種別名
	MOVX	SYL_ITEM_MAX,DS:[BX][STYL_OFS_P_MAX]   ; パラメータ数
	MOVX	SYL_ITEM_WORD,DS:[BX][STYL_OFS_P_WORD] ; パラメータＷＯＲＤ数

	POP	DX
	RET
R_ITEM_STYLE	ENDP



; ****************************************************
;	行いレコードＧＥＴ
;	-I- DX : 種別・0=仕事
;	    CX : レコード番号
;	-O- BX : レコードのアドレス
;	    AX : 0=正常,1=レコード番号が範囲外
; ****************************************************

R_WORK_RGET	PROC	NEAR
	MOV	REC_NO,CX		; アイテムレコード番号

	CALL	R_WORK_STYLE		; 行い・スタイルリストＧＥＴ
	CALL	R_WORK_TOP		; 行い先頭検索

	CMPX	REC_NO,REC_MAX		; アイテム数
	JNB	R_WORK_RGET_ERROR	;

	CALL	R_WORK_REC_ADRS		; 行いレコードのアドレス

	MOV	BX,PNT_ADRS		; アイテムオフセットポインタ
	MOV	AX,0			; 0=正常
	RET
R_WORK_RGET_ERROR:
	MOV	BX,0			;
	MOV	AX,1			; 1=レコード番号が範囲外
	RET
R_WORK_RGET	ENDP



; ****************************************************
;	行いレコードのアドレス
;	-I- TOP_ADRS : アイテム先頭オフセット
;	    REC_NO   : アイテムレコード番号
;	-O- PNT_ADRS : アイテムオフセットポインタ
; ****************************************************

R_WORK_REC_ADRS		PROC	NEAR
	MOV	AX,SYL_ITEM_WORD		; パラメータＷＯＲＤ数
	SHL	AX,1				; byte counter.
	MOV	BX,REC_NO			; アイテムレコード番号
	MUL	BX				;
	ADD	AX,TOP_ADRS			; アイテム先頭オフセット
	MOV	PNT_ADRS,AX			; アイテムオフセットポインタ
	RET
R_WORK_REC_ADRS		ENDP



; ****************************************************
;	行い条件検索
;	-I- DX : 種別・0=仕事
;	    AX : 年齢
;	-O- K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_WORK_SCH	PROC	NEAR
	MOV	AGE_VALUE,AX		; 年齢
	CALL	R_WORK_STYLE		; 行い・スタイルリストＧＥＴ
	CALL	R_WORK_TOP		; 行い先頭検索
	CALL	R_WORK_SCH_GET		; 行い検索とテーブルセット
	CALL	R_WORK_SCH_AGE		; 行い年齢制限
	RET
R_WORK_SCH	ENDP


; ****************************************************
;	行い検索とテーブルセット
;	-I- TOP_ADRS : アイテム先頭オフセット
;	    REC_MAX  : アイテム数
;	-O- K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

R_WORK_SCH_GET	PROC	NEAR
	MOVX	PNT_ADRS,TOP_ADRS		; アイテムオフセットポインタ

	MOV	REC_NO,0			; アイテムレコード番号

	MOV	K_TBL_MAX,0			; 検索レコード数
R_WORK_SCH_GET_LOOP:
	CMPX	K_TBL_MAX,K_TBL_DIM		; 検索レコードテーブルサイズ
	JGE	R_WORK_SCH_GET_LOOP_END		;

	CMPX	REC_NO,REC_MAX			; アイテム数
	JGE	R_WORK_SCH_GET_LOOP_END		;

	MOV	BX,K_TBL_MAX			; 検索レコード数
	SHL	BX,1				; word pointer.
	MOVX	DS:K_TBL_REC[BX],REC_NO		; アイテムレコード番号
	MOVX	DS:K_TBL_OFSET[BX],PNT_ADRS	; 検索レコードｵﾌｾｯﾄテーブル

	MOV	AX,SYL_ITEM_WORD		; パラメータＷＯＲＤ数
	SHL	AX,1				; byte counter.
	ADD	PNT_ADRS,AX			; アイテムオフセットポインタ

	INC	K_TBL_MAX			; 検索レコード数

	INC	REC_NO				; アイテムレコード番号

	JMP	R_WORK_SCH_GET_LOOP
R_WORK_SCH_GET_LOOP_END:
	RET
R_WORK_SCH_GET	ENDP


; ****************************************************
;	行い年齢制限
;	-I-   AGE_VALUE     : 年齢
;	-I/O- K_TBL_REC[]   : 検索レコードテーブル
;	      K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	      K_TBL_MAX     : 検索レコード数
; ****************************************************

R_WORK_SCH_AGE	PROC	NEAR
	PUSH	DX

	MOV	SI,0			; word pointer.(source)
	MOV	DI,0			; word pointer.(destination)

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	CX,K_TBL_MAX		; 検索レコード数
	JCXZ	R_WORK_SCH_AGE_EXIT	;
R_WORK_SCH_AGE_LOOP:			;
	MOV	BX,DS:K_TBL_OFSET[SI]	; 検索レコードｵﾌｾｯﾄテーブル
	MOV	AX,ES:[BX][WRK_ARGE]	; 13.年齢制限
	CMP	AGE_VALUE,AX		; 年齢
	JB	R_WORK_SCH_AGE_4	;

	MOV	AX,DS:K_TBL_REC[SI]	; 検索レコードテーブル
	MOV	DX,DS:K_TBL_OFSET[SI]	; 検索レコードｵﾌｾｯﾄテーブル
	MOV	DS:K_TBL_REC[DI],AX	; 検索レコードテーブル
	MOV	DS:K_TBL_OFSET[DI],DX	; 検索レコードｵﾌｾｯﾄテーブル
	INC	K_TBL_MAX		; 検索レコード数
	INC	DI			; word pointer.(destination)
	INC	DI			;
R_WORK_SCH_AGE_4:			;
	DEC	K_TBL_MAX		; 検索レコード数
	INC	SI			; word pointer.
	INC	SI			;
	LOOP	R_WORK_SCH_AGE_LOOP	;

;*;	MOV	SI,0			; word pointer.(source)
;*;	MOV	DI,0			; word pointer.(destination)
;*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*;	MOV	CX,K_TBL_MAX		; 検索レコード数
;*;R_WORK_SCH_AGE_LP_2:			;
;*;	CMP	DS:K_TBL_ATR[SI],1	; 1=検索された
;*;	JE	R_WORK_SCH_AGE_6	;
;*;
;*;	MOV	AX,DS:K_TBL_REC[SI]	; 検索レコードテーブル
;*;	MOV	DX,DS:K_TBL_OFSET[SI]	; 検索レコードｵﾌｾｯﾄテーブル
;*;	MOV	DS:K_TBL_REC[DI],AX	; 検索レコードテーブル
;*;	MOV	DS:K_TBL_OFSET[DI],DX	; 検索レコードｵﾌｾｯﾄテーブル
;*;	DEC	K_TBL_MAX		; 検索レコード数
;*;	INC	DI			; word pointer.(destination)
;*;	INC	DI			;
;*;R_WORK_SCH_AGE_6:			;
;*;	INC	SI			; word pointer.
;*;	INC	SI			;
;*;	LOOP	R_WORK_SCH_AGE_LP_2	;

R_WORK_SCH_AGE_EXIT:
	POP	DX
	RET
R_WORK_SCH_AGE	ENDP


; ****************************************************
;	行い先頭検索
;	-I- DX : 種別・0=仕事
;	-O- TOP_ADRS : アイテム先頭オフセット
;	    REC_MAX  : アイテム数
; ****************************************************

R_WORK_TOP	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,DX			; テーブルの行いテーブルを取り出す
	SHL	BX,1			; word pointer.
	SHL	BX,1			; * 4
	ADD	BX,WIDOFS_WORKS		; 行いテーブル
	MOVX	TOP_ADRS,ES:[BX]	; アイテム先頭オフセット
	MOVX	REC_MAX,ES:[BX][2]	; アイテム数
	RET
R_WORK_TOP	ENDP



; ****************************************************
;	行い・スタイルリストＧＥＴ
;	-I- DX : 種別・0=仕事
;	-O- STYLE_LIST_ITEM : アイテム・スタイルリスト・アドレス
;	    SYL_ITEM_NAME   : アイテム・アイテム種別名
;	    SYL_ITEM_MAX    : アイテム・パラメータ数
;	    SYL_ITEM_WORD   : アイテム・パラメータＷＯＲＤ数
; ****************************************************

R_WORK_STYLE	PROC	NEAR
	PUSH	DX

	CALL	WIDWORKS_STYLE		; WINDOWS/行いスタイルリスト

	MOV	STYLE_LIST_ITEM,BX	; スタイルリスト・アドレス
	MOVX	SYL_ITEM_NAME,DS:[BX][STYL_OFS_I_NAME] ; アイテム種別名
	MOVX	SYL_ITEM_MAX,DS:[BX][STYL_OFS_P_MAX]   ; パラメータ数
	MOVX	SYL_ITEM_WORD,DS:[BX][STYL_OFS_P_WORD] ; パラメータＷＯＲＤ数

	POP	DX
	RET
R_WORK_STYLE	ENDP




; ****************************************************
;	ｱｲﾃﾑレコード内から選択単語を取り出す
;
;	-I- K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
;	    BX            : 何ワード目か
;	-O- ATMTBL[]  : WINDOWS/表示単語アドレス
;	    ATMMAX    : WINDOWS/表示単語の数
;	    ATMSEG    : WINDOWS/テキストバッファセグメント
; ****************************************************

R_GET_SELECT	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,0			; counter.
	MOV	SI,0			; word pointer.

	MOV	CX,K_TBL_MAX		; 検索レコード数
	JCXZ	R_GET_SELECT_EXIT	;
R_GET_SELECT_LOOP:
	CMP	DX,ATMDIM		; WINDOWS/表示単語のテーブルサイズ
	JGE	R_GET_SELECT_EXIT	;

	MOV	DI,DS:K_TBL_OFSET[SI]	; 検索レコードｵﾌｾｯﾄテーブル
	ADD	DI,BX			; 何ワード目か
	MOV	AX,ES:[DI]		;
	MOV	DS:ATMTBL[SI],AX	; WINDOWS/表示単語アドレス
	INC	DX			; counter.
	INC	SI			;
	INC	SI			; word pointer.
	LOOP	R_GET_SELECT_LOOP	;

R_GET_SELECT_EXIT:
	MOV	ATMMAX,DX		; 表示単語の数
	MOVX	ATMSEG,SEGWID		; ＷＩＮＤＯＷＳセグメント
	RET
R_GET_SELECT	ENDP


; ****************************************************
;	選択単語へ追加
;	-I-   DX        : 文字アドレス(ATMSEG内)
;	-I/O- ATMTBL[]  : WINDOWS/表示単語アドレス
;	      ATMMAX    : WINDOWS/表示単語の数
; ****************************************************

R_ADD_SELECT	PROC	NEAR
	CMPX	ATMMAX,ATMDIM		; WINDOWS/表示単語のテーブルサイズ
	JNB	R_ADD_SELECT_3		;
	INC	ATMMAX			; WINDOWS/表示単語の数
R_ADD_SELECT_3:
	MOV	BX,ATMMAX		;
	DEC	BX			;
	SHL	BX,1			; word pointer.
	MOV	DS:ATMTBL[BX],DX	; 文字アドレス(ATMSEG内)
	RET
R_ADD_SELECT	ENDP


; ****************************************************
;	名前でアイテム検索
;	-I- AX : 文字ＩＤ
;	    DX : アイテム種別
;	           0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾,4=道具,5=資格
;	-O- AX : 1=見つかった,0=見つからなかった
;	    DX : アイテムレコードＮＯ
;	    BX : アイテムオフセットポインタ
; ****************************************************

R_ITEM_NMSH	PROC	NEAR
	PUSH	AX
	CALL	R_ITEM_STYLE		; アイテム・スタイルリストＧＥＴ
	CALL	R_ITEM_TOP		; アイテム先頭検索
	POP	DX

	CALL	R_ITEM_ID_GET		; 文字ＩＤでアイテム検索
	CMP	AX,1			; 1=見つかった,0=見つからなかった
	JNE	R_ITEM_NMSH_NONE	;

R_ITEM_NMSH_SCH:			;
	MOV	BX,PNT_ADRS		; アイテムオフセットポインタ
	MOV	DX,REC_NO		; アイテムレコード番号
;*;	PRV	"pnt BX=",BX
;*;	PRV	"rec DX=",DX
	MOV	AX,1			; 1=見つかった
	RET
R_ITEM_NMSH_NONE:			;
	MOV	BX,0			;
	MOV	DX,0			;
	MOV	AX,0			; 0=見つからなかった
	RET
R_ITEM_NMSH	ENDP


; ****************************************************
;	文字ＩＤでアイテム検索
;	-I- TOP_ADRS : アイテム先頭オフセット
;	    REC_MAX  : アイテム数
;	    DX       : 文字ＩＤ
;	-O- AX       : 1=見つかった,0=見つからなかった
;	    REC_NO   : アイテムレコード番号
;	    PNT_ADRS : アイテムオフセットポインタ
; ****************************************************

R_ITEM_ID_GET	PROC	NEAR
	MOVX	PNT_ADRS,TOP_ADRS		; アイテムオフセットポインタ

;*;	PRV	"ID=",DX

	; 文字ＩＤのアドレス

	MOV	ES,SEGWID			;
	MOV	DI,WIDOFS_ENVIR			; 環境テーブル
	MOV	BX,ES:[DI][KAN_ENVIR_STR]	; 環境文字
	SHL	DX,1				; word pointer.
	ADD	BX,DX				;
	MOV	SI,ES:[BX]			; SI=対象の文字アドレス


	MOV	REC_NO,0			; アイテムレコード番号
R_ITEM_ID_GET_LOOP:
	CMPX	REC_NO,REC_MAX			; アイテム数
	JGE	R_ITEM_ID_GET_LOOP_END		;

	MOV	BX,PNT_ADRS			; 検索レコードｵﾌｾｯﾄテーブル
	MOV	AX,ES:[BX]			; ＩＤ文字とアイテム名は同じ？

	CMP	SI,AX				; ＩＤ文字とアイテム名は同じ？
	JE	R_ITEM_ID_GET_SCH		;

	MOV	AX,SYL_ITEM_WORD		; パラメータＷＯＲＤ数
	SHL	AX,1				; byte counter.
	ADD	PNT_ADRS,AX			; アイテムオフセットポインタ

	INC	REC_NO				; アイテムレコード番号
	JMP	R_ITEM_ID_GET_LOOP

R_ITEM_ID_GET_LOOP_END:
	MOV	AX,0			; 0=見つからなかった
	RET
R_ITEM_ID_GET_SCH:
;*;	PRV	"AX=",AX
;*;	PRV	"SI=",SI
	MOV	AX,1			; 1=見つかった
	RET
R_ITEM_ID_GET	ENDP


; ****************************************************
;	持っているか検索
;	-I- K_TBL_ATR[]   : 検索レコード種別テーブル
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_MAX     : 検索レコード数
;	    AX            : アイテム種別
;	0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾,4=道具,5=資格
;	    DX            : アイテムレコードＮＯ
;	-O- AX            : 1=見つかった,0=見つからなかった
;	    K_REC_NO      : 検索レコード番号
; ****************************************************

R_ITM_MOTTERU	PROC	NEAR
;*;	PRV	"K_TBL_MAX=",K_TBL_MAX		; 検索レコード数
;*;	PRV	"アイテム種別",AX
;*;	PRV	"アイテムレコードＮＯ",DX

	MOV	K_REC_NO,0		; 検索レコード番号
	MOV	SI,0			; word pointer.
	MOV	CX,K_TBL_MAX		; 検索レコード数
	JCXZ	R_ITM_MOTTERU_LOOP_END	;
R_ITM_MOTTERU_LOOP:			;
	CMP	DS:K_TBL_ATR[SI],AX	; 検索レコード種別テーブル
	JNE	R_ITM_MOTTERU_NEXT	;
	CMP	DS:K_TBL_REC[SI],DX	; 検索レコードテーブル
	JNE	R_ITM_MOTTERU_NEXT	;

	JMP	R_ITM_MOTTERU_SCH	;

R_ITM_MOTTERU_NEXT:			;
	INC	K_REC_NO		; 検索レコード番号
	ADD	SI,2			; word pointer.
	LOOP	R_ITM_MOTTERU_LOOP	;
R_ITM_MOTTERU_LOOP_END:			;
	JMP	R_ITM_MOTTERU_NONE	;

R_ITM_MOTTERU_SCH:			;
	MOV	AX,1			; 1=見つかった
;*;	PRV	"SCH**",AX
	RET
R_ITM_MOTTERU_NONE:			;
	MOV	AX,0			; 0=見つからなかった
;*;	PRV	"nonSCH**",AX
	RET
R_ITM_MOTTERU	ENDP


; ****************************************************
;	所有魔法ある？
;	-I- AX : 誰か（アドレス）
;	-O- CX : 技数
; ****************************************************

R_MAGIC_ARU	PROC	NEAR
	MOV	ADRS_HOW,AX		; 誰か（アドレス）

	; 技リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	MOV	SI,ES:[BX][HED_LST_WZ]	; SI=技リスト

	; ＧＥＴ

	MOV	CX,ES:[SI][2]		; 技数: WINDOWS/表示単語の数
	RET
R_MAGIC_ARU	ENDP


; ****************************************************
;	所有魔法リスト
;	-I- AX         : 誰か（アドレス）
;	-O- ATMTBL[]   : WINDOWS/表示単語アドレス
;	    ATMMAX     : WINDOWS/表示単語の数
;	    ATMSEG     : WINDOWS/テキストバッファセグメント
;
;	マリア技	LABEL	WORD
;			DW	5		; 技最大
;			DW	0		; 技数
;			DW	5 DUP (0)
;	攻撃魔法
;	防御魔法
;	治療魔法
;	ニードル（攻）
;	ファイア（攻）
;	マジックミサイル（攻）
;	バリア（防）
;	ヒール（回）
;	サンダー（攻）
; ****************************************************

R_MAGIC_LIST	PROC	NEAR
	MOV	ADRS_HOW,AX		; 誰か（アドレス）

	; 技リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	MOV	SI,ES:[BX][HED_LST_WZ]	; SI=技リスト

	; ＧＥＴ

	MOVX	ATMMAX,ES:[SI][2]	; 技数: WINDOWS/表示単語の数
	MOVX	ATMSEG,SEGWID		; WINDOWS/テキストバッファセグメント

	ADD	SI,4			; SI=技の名前１(2word add)
	MOV	BX,0			; word pointer.

	MOV	CX,ATMMAX		; 技数: WINDOWS/表示単語の数
	CMP	CX,ATMDIM		; WINDOWS/表示単語のテーブルサイズ
	JBE	R_MAGIC_LIST_55		;
	MOV	CX,ATMDIM		; WINDOWS/表示単語のテーブルサイズ
R_MAGIC_LIST_55:
	JCXZ	R_MAGIC_LIST_EXIT	;
R_MAGIC_LIST_LOOP:			;
	MOV	AX,ES:[SI]		; 技数: WINDOWS/表示単語の数
	MOV	DS:ATMTBL[BX],AX	; WINDOWS/表示単語アドレス
	INC	SI			;
	INC	SI			; word pointer.
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	R_MAGIC_LIST_LOOP	;

R_MAGIC_LIST_EXIT:
	RET
R_MAGIC_LIST	ENDP


; ****************************************************
;	魔法を手に入れた
;	-I- AX : 私（アドレス）
;	    DX : 魔法の種類 1=攻撃魔法,2=防御魔法,3=治療魔法
;
;	マリア技	LABEL	WORD
;			DW	3	; 技最大
;			DW	3	; 技数
;			DW	攻撃魔法
;			DW	防御魔法
;			DW	治療魔法
; ****************************************************

R_K_CALC_MAHO	PROC	NEAR
	MOV	ADRS_HOW,AX		; 人物
	MOV	MAHO_KIND,DX		; 魔法の種類

	; 技リスト

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,ADRS_HOW		; 誰か（アドレス）
	MOV	SI,ES:[BX][HED_LST_WZ]	; SI=技リスト

	MOV	DX,MAHO_KIND		; 魔法の種類
	CMP	DX,1			; 1=攻撃魔法
	JE	CALC_MAHO_KOUGEKI	;
	CMP	DX,2			; 2=防御魔法
	JE	CALC_MAHO_BOUGYO	;
	CMP	DX,3			; 3=治療魔法
	JE	CALC_MAHO_CHIRYO	;
	JMP	CALC_MAHO_EXIT		;

CALC_MAHO_KOUGEKI:			; 攻撃魔法
	MOV	WORD PTR ES:[SI][2],1	; 技数: WINDOWS/表示単語の数
	MOV	DX,ID_48		; 攻撃魔法
	CALL	ID_TO_ENV_STRING	; ＩＤから環境文字アドレス
	MOV	ES:[SI][4],CX		;
	JMP	CALC_MAHO_EXIT		;

CALC_MAHO_BOUGYO:			; 防御魔法
	MOV	WORD PTR ES:[SI][2],2	; 技数: WINDOWS/表示単語の数
	MOV	DX,ID_49		; 防御魔法
	CALL	ID_TO_ENV_STRING	; ＩＤから環境文字アドレス
	MOV	ES:[SI][6],CX		; 防御魔法
	JMP	CALC_MAHO_EXIT		;

CALC_MAHO_CHIRYO:			; 治療魔法
	MOV	WORD PTR ES:[SI][2],3	; 技数: WINDOWS/表示単語の数
	MOV	DX,ID_50		; 治療魔法
	CALL	ID_TO_ENV_STRING	; ＩＤから環境文字アドレス
	MOV	ES:[SI][8],CX		; 治療魔法
	JMP	CALC_MAHO_EXIT		;

CALC_MAHO_EXIT:
	RET
R_K_CALC_MAHO	ENDP


; ****************************************************
;	称号を手に入れた
;	-I- DX : 称号のＩＤ
; ****************************************************

R_SHOGO_TAKE	PROC	NEAR
	CALL	ID_TO_ENV_STRING	; ＩＤから環境文字アドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	ES:[BX][HED_SHOGO],CX	; 称号

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,8			; 8=称号をもらうとき
	MOV	CX,0			;
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理
	RET
R_SHOGO_TAKE	ENDP


; ****************************************************
;	レベル
;	-I- AX : 誰か（アドレス）
;	-O- DX : レベル
; ****************************************************

R_GET_LVL	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,AX			; 誰か（アドレス）
	MOV	DX,ES:[BX][HED_LVL]	; DX=レベル
	RET
R_GET_LVL	ENDP


; ****************************************************
;	会話情報
;	１回ＣＡＬＬするごとに、更新される。
;	-I- AX : 1=クリア,2=フラグ
;	-O- AX : 会話 1=会話よい,2=会話駄目
; ****************************************************

R_KAIWA_JYOHO	PROC	NEAR
	CMP	AX,1			; 1=クリア
	JE	R_KAIWA_JYOHO_1		;
	CMP	AX,2			; 2=フラグ
	JE	R_KAIWA_JYOHO_2		;

R_KAIWA_JYOHO_1:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	WORD PTR ES:[ADD_KAIWA_TBL][0],0 ; 会話テーブル・月
	JMP	R_KAIWA_JYOHO_YOI
R_KAIWA_JYOHO_2:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	AX,VAL_MONTH		; (now)月
	CMP	AX,ES:[ADD_KAIWA_TBL][0] ; 会話テーブル・月
	JE	R_KAIWA_JYOHO_DAME	;

	MOV	ES:[ADD_KAIWA_TBL][0],AX ; 会話テーブル・月
R_KAIWA_JYOHO_YOI:
	MOV	AX,1			; 会話 1=会話よい
	RET
R_KAIWA_JYOHO_DAME:
	MOV	AX,2			; 会話 2=会話駄目
	RET
R_KAIWA_JYOHO	ENDP


; ****************************************************
;	ＩＤから環境文字アドレス
;	-I- DX : ＩＤ
;	-O- CX : 環境文字アドレス
; ****************************************************

ID_TO_ENV_STRING	PROC	NEAR
	PUSH	ES
	PUSH	SI

	SHL	DX,1			; word pointer.

	MOV	ES,SEGWID		;
	MOV	DI,WIDOFS_ENVIR		; 環境テーブル
	MOV	BX,ES:[DI]		;
	ADD	BX,DX			;
	MOV	CX,ES:[BX]		;

	POP	SI
	POP	ES
	RET
ID_TO_ENV_STRING	ENDP



; ****************************************************
;	環境文字のＩＤ検索
;	-I- BX : 環境文字のアドレス
;	-O- DX : ＩＤ
;	    AX : 1=見つかった,0=見つからない
; ****************************************************

R_ENV_IDNAME	PROC	NEAR
	MOV	ES,SEGWID			;
	MOV	DI,WIDOFS_ENVIR			; 環境テーブル
	MOV	SI,ES:[DI][KAN_ENVIR_STR]	; 環境文字
	MOV	DX,0				; ＩＤ
	MOV	CX,60000			;
R_ENV_IDNAME_LOOP:
	MOV	AX,ES:[SI]			;
	CMP	AX,0FFFFH			; 環境文字列の終り
	JE	R_ENV_IDNAME_UNDEF		;
	CMP	AX,BX				; BX=環境文字のアドレス
	JE	R_ENV_IDNAME_OK			;

	INC	DX				; ＩＤ
	INC	SI				;
	INC	SI				; word pointer.
	LOOP	R_ENV_IDNAME_LOOP		;

	JMP	R_ENV_IDNAME_UNDEF		;

R_ENV_IDNAME_OK:
	MOV	AX,1				; 1=見つかった
	RET
R_ENV_IDNAME_UNDEF:
	MOV	DX,0				; ＩＤ
	MOV	AX,0				; 0=見つからない
	RET
R_ENV_IDNAME	ENDP


;*;; ****************************************************
;*;;	持っているか検索
;*;;	-I- ATMTBL[]  : WINDOWS/表示単語アドレス
;*;;	    ATMMAX    : WINDOWS/表示単語の数
;*;
;*;;	-I- K_TBL_ATR[]: 検索レコード種別テーブル
;*;;	    K_TBL_REC[]: 検索レコードテーブル
;*;;	    DX        : 文字ＩＤ
;*;;	-O- AX        : 1=見つかった,0=見つからなかった
;*;;	    K_REC_NO  : 検索レコード番号
;*;; ****************************************************
;*;
;*;R_ITM_MOTTERU	PROC	NEAR
;*;	MOV	K_REC_NO,0		; 検索レコード番号
;*;
;*;	; 文字ＩＤのアドレス
;*;
;*;	MOV	ES,SEGWID		;
;*;	MOV	DI,WIDOFS_ENVIR		; 環境テーブル
;*;	MOV	BX,ES:[DI][KAN_ENVIR_STR] ; 環境文字
;*;	SHL	DX,1			; word pointer.
;*;	ADD	BX,DX			;
;*;	MOV	SI,ES:[BX]		; SI=対象の文字アドレス
;*;
;*;
;*;	MOV	DI,0			; word pointer.
;*;	MOV	CX,ATMMAX		; WINDOWS/表示単語の数
;*;	JCXZ	R_ITM_MOTTERU_LOOP_END	;
;*;R_ITM_MOTTERU_LOOP:			;
;*;	MOV	BX,DS:K_TBL_REC[DI]	; 検索レコードテーブル
;*;	SHL	BX,1			;
;*;	SHL	BX,1			; dword.
;*;	MOV	AX,ES:[BX][0]		;
;*;
;*;	CMP	SI,
;*;	JNE	R_ITM_MOTTERU_NEXT	;
;*;	JMP	R_ITM_MOTTERU_SCH	;
;*;R_ITM_MOTTERU_NEXT:			;
;*;	INC	K_REC_NO		; 検索レコード番号
;*;	ADD	DI,2			; word pointer.
;*;	LOOP	R_ITM_MOTTERU_LOOP	;
;*;
;*;R_ITM_MOTTERU_LOOP_END:			;
;*;	MOV	AX,0			; 0=見つからなかった
;*;	RET
;*;R_ITM_MOTTERU_SCH:			;
;*;	MOV	AX,1			; 1=見つかった
;*;	RET
;*;R_ITM_MOTTERU	ENDP



CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	K_TBL_REC		; 検索レコードテーブル
PUBLIC	K_TBL_OFSET		; 検索レコードｵﾌｾｯﾄテーブル
PUBLIC	K_TBL_MOCHI		; 検索レコード持物テーブル
PUBLIC	K_TBL_ATR		; 検索レコード種別テーブル
PUBLIC	K_TBL_MAX		; 検索レコード数
PUBLIC	K_TBL_DIM		; 検索レコードテーブルサイズ

EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	ATMSEG:WORD		; WINDOWS/テキストバッファセグメント
EXTRN	ATMTBL:WORD		; WINDOWS/表示単語アドレス
EXTRN	ATMMAX:WORD		; WINDOWS/表示単語の数
EXTRN	ATMDIM:WORD	 	; WINDOWS/表示単語のテーブルサイズ

EXTRN	NOW_DATE:BYTE		; (now)現在時間
EXTRN	VAL_YEAR:WORD		; (now)年
EXTRN	VAL_MONTH:WORD		; (now)月
EXTRN	VAL_WEEK:WORD		; (now)曜日
EXTRN	VAL_DATE:WORD		; (now)日
EXTRN	VAL_A_DATE:WORD		; (now)年内合計日付
EXTRN	VAL_M_END:WORD		; (now)月末の日
EXTRN	TM_SEASON:WORD		; (now)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	FLG_SHOGATSU:WORD	; (now)フラグ・正月
EXTRN	FLG_URUBI:WORD		; (now)フラグ・うるう日
EXTRN	FLG_CHRISTMAS_EVE:WORD	; (now)フラグ・クリスマスイブ
EXTRN	FLG_BORTH:WORD		; (now)フラグ・誕生日
EXTRN	FLG_HOLIDAY:WORD	; (now)フラグ・休日
EXTRN	FLG_SYUKAKU:WORD	; (now)フラグ・収穫祭の準備

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

STYLE_LIST_ITEM	DW	0	; アイテム・スタイルリスト・アドレス
SYL_ITEM_NAME	DW	0	; アイテム・アイテム種別名
SYL_ITEM_MAX	DW	0	; アイテム・パラメータ数
SYL_ITEM_WORD	DW	0	; アイテム・パラメータＷＯＲＤ数

K_TBL_REC	DW	K_TBL_SIZE DUP (0)	; 検索レコードテーブル
K_TBL_OFSET	DW	K_TBL_SIZE DUP (0)	; 検索レコードｵﾌｾｯﾄテーブル
K_TBL_MOCHI	DW	K_TBL_SIZE DUP (0)	; 検索レコード持物テーブル
K_TBL_ATR	DW	K_TBL_SIZE DUP (0)	; 検索レコード種別テーブル
K_TBL_MAX	DW	0			; 検索レコード数
K_TBL_DIM	DW	K_TBL_SIZE		; 検索レコードテーブルサイズ

K_REC_NO	DW	0			; 検索レコード番号

AGE_LIMIT	DW	0			; 年齢制限
AGE_VALUE	DW	0			; 年齢

TOP_ADRS	DW	0			; アイテム先頭オフセット
PNT_ADRS	DW	0			; アイテムオフセットポインタ
REC_NO		DW	0			; アイテムレコード番号
REC_MAX		DW	0			; アイテム数

REC_ATR		DW	0			; アイテム属性

ADRS_HOW	DW	0			; 誰か（アドレス）
ADRS_ITEM	DW	0			; アイテム（アドレス）

MAHO_KIND	DW	0	; 魔法の種類 1=攻撃魔法,2=防御魔法,3=治療魔法
MAHO_ADRS	DW	0	; 魔法のアドレス

ITEM_ATR	DW	0			; アイテム種別
ITEM_REC	DW	0			; レコード番号

VAL_ATTR	DW	0			; 種別
VAL_RECNO	DW	0			; レコードＮＯ

NUM		DW	0			; 番号

DATA	ENDS

	END
;
;	end of "R_KENSAK.ASM"
;
