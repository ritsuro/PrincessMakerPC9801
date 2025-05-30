; "WIDALLC2.ASM" PC-9801UV11 make by R.H 1990/10/22
;
;
;	ＷＩＮＤＯＷＳ／データ結合処理
;
;	キャラクタ配給
;
; (C) 1991 ritsurou hashimoto.


INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	TSTSET.INC

MY_GIRL_NUMBER	EQU	1		; 自分の娘のメンバ番号

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	WIDALLOC_CHRADRS		; WINDOWS/キャラクタ・ヘッダアドレス
PUBLIC	WIDALLOC_MISSCON		; WINDOWS/キャラクタ・ミスコン選出
PUBLIC	WIDALLOC_BUTOKAI		; WINDOWS/キャラクタ・武闘会選出
PUBLIC	WIDALLOC_TSUIKA			; WINDOWS/キャラクタ・メンバ表へ追加

EXTRN	RANDAM_CX:NEAR			; 乱数範囲指定
EXTRN	RANDAM_GINI:NEAR		; 重複しない乱数スタート
EXTRN	RANDAM_GGET:NEAR		; 重複しない乱数


; ****************************************************
;	WINDOWS/キャラクタ・ヘッダアドレス
;	-I- DX    : キャラクタＮｏ．
;	-O- ES    : ＷＩＮＤＯＷＳセグメント
;	    BX    : ヘッダアドレス
; ****************************************************

WIDALLOC_CHRADRS	PROC	NEAR
	MOV	BX,DX				; キャラクタＮｏ．
	MOV	AX,HED_NEXT			; 次のヘッダー
	MUL	BX				;
	ADD	AX,WIDOFS_HEAD			; ヘッダーテーブル
	MOV	BX,AX				;

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	RET
WIDALLOC_CHRADRS	ENDP


; ****************************************************
;	WINDOWS/キャラクタ・ミスコン選出
;		自分の娘は除きます
;	-I- DX       : ミスコン出場者数
;	    BX       : メンバ表(byte)アドレス
;	-O- DS:[BX]  : 選出されたメンバ表(byte)
; ****************************************************

WIDALLOC_MISSCON	PROC	NEAR
	MOV	MISS_ENTRY_CNT,DX		; ミスコン出場者数

	MOV	MEMBER_COUNT,DX			; ミスコン出場者数
	MOV	MEMBER_MAT_ADRS,BX		; メンバ表(byte)アドレス
	MOVX	MEMBER_HANI,WID_MISCON_MAX	; メンバ範囲／ミスコンキャラ数

	MOV	SKIP_MEMBER,MY_GIRL_NUMBER	; この人を除きたい（自分の娘）
	CALL	MEMBER_SELECT			; メンバ選択
	RET
WIDALLOC_MISSCON	ENDP


; ****************************************************
;	WINDOWS/キャラクタ・武闘会選出
;		自分の娘は除きます
;	-I- DX       : 武闘会出場者数
;	    BX       : メンバ表(byte)アドレス
;	-O- DS:[BX]  : 選出されたメンバ表(byte)
; ****************************************************

WIDALLOC_BUTOKAI	PROC	NEAR
	MOV	BUTOH_ENTRY_CNT,DX		; 武闘会出場者数

	MOV	MEMBER_COUNT,DX			; 武闘会出場者数
	MOV	MEMBER_MAT_ADRS,BX		; メンバ表(byte)アドレス
	MOVX	MEMBER_HANI,WID_BUTOH_MAX	; メンバ範囲／武闘会キャラ数

	MOV	SKIP_MEMBER,MY_GIRL_NUMBER	; この人を除きたい（自分の娘）
	CALL	MEMBER_SELECT			; メンバ選択
	RET
WIDALLOC_BUTOKAI	ENDP


; ****************************************************
;	WINDOWS/キャラクタ・メンバ表へ追加
;	-I- BX       : メンバ表(byte)アドレス
;	    DX       : 現在の出場者数
;	    AX       : 追加するメンバ
;	-O- DS:[BX]  : 追加されたメンバ表(byte)
;	    DX       : 追加時のエントリィ番号
; ****************************************************

WIDALLOC_TSUIKA		PROC	NEAR
	MOV	MEMBER_MAT_ADRS,BX		; メンバ表(byte)アドレス
	MOV	MEMBER_COUNT,DX			; 現在の出場者数
	MOV	MEMBER_NUM,AX			; 追加するメンバ

	MOV	CX,MEMBER_COUNT			; 出場者数
	INC	CX				; ＋１
	CALL	RANDAM_CX			; 乱数範囲指定
	MOV	DI,AX				; DI=１からＣＸの数字
	DEC	DI				; base 0.

	PUSH	DI				;
	MOV	CX,MEMBER_COUNT			; 出場者数
	SUB	CX,DI				; 最後ならば、ずらす必要は無い
	JZ	WIDALLOC_TSUIKA_SKIP		;
	MOV	BX,MEMBER_MAT_ADRS		; メンバ表(byte)アドレス
	ADD	BX,MEMBER_COUNT			; ＋出場者数
	DEC	BX				; －１
WIDALLOC_TSUIKA_LOOP:				;
	MOV	AL,DS:[BX]			;
	MOV	DS:[BX][1],AL			; １バイトづつ、ずらす
	DEC	BX				;
	LOOP	WIDALLOC_TSUIKA_LOOP		;
WIDALLOC_TSUIKA_SKIP:				;
	POP	DI				;

	MOV	AX,MEMBER_NUM			; 追加するメンバ
	MOV	BX,MEMBER_MAT_ADRS		; メンバ表(byte)アドレス
	MOV	DS:[BX][DI],AL			;

	MOV	DX,DI				; 追加時のエントリィ番号

	RET
WIDALLOC_TSUIKA		ENDP


; ****************************************************
;	メンバ選択
;	-I- MEMBER_COUNT    : メンバ数
;	    MEMBER_MAT_ADRS : メンバ表(byte)アドレス
;	    MEMBER_HANI     : メンバ範囲（２００まで）
;	    SKIP_MEMBER     : この人を除きたい。
; ****************************************************

MEMBER_SELECT	PROC	NEAR
	CALL	RANDAM_GINI		; 重複しない乱数スタート

	MOVX	ADRS1,MEMBER_MAT_ADRS	; メンバ表(byte)アドレス
	MOV	CNT1,0			; メンバ数
	MOV	CNT2,0			; 無限ループ防止用
MEMBER_SELECT_LOOP:
	INC	CNT2			; 無限ループ防止用
	CMP	CNT2,400		;
	JNBE	MEMBER_SELECT_LOP_END	;

	CALL	RANDAM_GGET		; 重複しない乱数

	CMP	AX,SKIP_MEMBER		; この人を除きたい
	JE	MEMBER_SELECT_NEXT	; ならばスキップ

	CMP	AX,MEMBER_HANI		; メンバ範囲（２００まで）
	JNBE	MEMBER_SELECT_NEXT	; 範囲を越えるならばスキップ

	MOV	BX,ADRS1		; メンバ表へ乱数ＡＬをセット
	MOV	DS:[BX],AL		;

	INC	CNT1			; メンバ数
	INC	ADRS1			; メンバ表

	CMPX	CNT1,MEMBER_COUNT	; メンバ数に足りたならば終り
	JNB	MEMBER_SELECT_LOP_END	;

MEMBER_SELECT_NEXT:
	JMP	MEMBER_SELECT_LOOP	;
MEMBER_SELECT_LOP_END:
	RET
MEMBER_SELECT	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

MEMBER_COUNT	DW	0	; メンバ数
MEMBER_MAT_ADRS	DW	0	; メンバ表アドレス
MEMBER_HANI	DW	0	; メンバ範囲

MISS_ENTRY_CNT	DW	0	; ミスコン出場者数
BUTOH_ENTRY_CNT	DW	0	; 武闘会出場者数

MEMBER_NUM	DW	0	; メンバ
SKIP_MEMBER	DW	0	; この人を除きたい。

ADRS1		DW	0
CNT1		DW	0
CNT2		DW	0

DATA	ENDS

	END
;
;	end of "WIDALLC2.ASM"
;
