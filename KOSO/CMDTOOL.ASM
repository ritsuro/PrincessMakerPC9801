; "CMDTOOL.ASM" PC-9801UV11 make by R.H 1990/11/10
;
;
;	「子育て」
;
;	各種ツール
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC

STRING_LEN 	EQU	255	; string length.
STR_VAL_LEN 	EQU	6	; string length.（数値表示用）

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	STRSET			; 文字列バッファセット
PUBLIC	STRSETZ			; 文字列バッファセット
PUBLIC	STRFILL			; 文字列バッファＦＩＬＬ
PUBLIC	STRCLEAR		; 文字列バッファクリア
PUBLIC	STRZEROC		; 文字列バッファ０クリア
PUBLIC	STR_N_HNZN		; 文字列半角を全角
PUBLIC	US_WAIT			; ユーザ待ち
PUBLIC	DSPSTR_CLR		; 文字列表示クリア
PUBLIC	TM_WAIT			; タイマ待ち
PUBLIC	TM_WAIT_H		; タイマハーフ待ち
PUBLIC	ADDSTRSET		; 文字列の連結
PUBLIC	STRLENGTH		; 文字列長さ
PUBLIC	STRLENSPZ		; 文字列長さスペースまで
PUBLIC	KANJITUME		; 漢字文字詰め処理
PUBLIC	KANJISHORT		; 漢字文字列を半角に詰める
PUBLIC	KANJICHOT		; 漢字文字列をちょっとだけ半角に詰める
PUBLIC	SJISCK			; シフトＪＩＳチェック
PUBLIC	BYTE_TBL_SCH		; バイトテーブルサーチ

EXTRN	BOXPAL:NEAR		; ＢＯＸペイント
EXTRN	BOXNOT:NEAR		; ＢＯＸ反転
EXTRN	BOXMSS:NEAR		; ＢＯＸメッシュ
EXTRN	BOXMSU:NEAR		; ＢＯＸ１プレーンメッシュ
EXTRN	BOXPAI:NEAR		; ＢＯＸ１プレーンペイント
EXTRN	BOXBLK:NEAR		; ＢＯＸ１プレーンヌキ

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス

EXTRN	MUSINI:NEAR		; マウスの初期化
EXTRN	MUSRED:NEAR		; マウス読み込み
EXTRN	MUSSHT:NEAR		; マウス読み込み・ワンショット
EXTRN	MUSSET:NEAR		; マウス座標セット
EXTRN	MUSSTB:NEAR		; マウスボタンセット
EXTRN	MUSSTP:NEAR		; マウスの終了
EXTRN	MUSWAT:NEAR		; マウスボタンＯＦＦ待ち

EXTRN	TMWAIT:NEAR	; time wait.
EXTRN	TMVSRT:NEAR	; V-SYNC timer start.
EXTRN	TMVEND:NEAR	; V-SYNC timer end.
EXTRN	TMVWAT:NEAR	; V-SYNC timer wait.
EXTRN	TMVSET:NEAR	; V-SYNC timer set.
EXTRN	TMVCHK:NEAR	; V-SYNC timer check.
EXTRN	TMVEWT:NEAR	; V-SYNC timer end wait.
EXTRN	TMVCLR:NEAR	; V-SYNC timer clear.
EXTRN	TMVST2:NEAR	; V-SYNC timer2 set.
EXTRN	TMVCK2:NEAR	; V-SYNC timer2 check.
EXTRN	TMVST3:NEAR	; V-SYNC timer3 set.
EXTRN	TMVCK3:NEAR	; V-SYNC timer3 check.
EXTRN	TMVSTP:NEAR	; V-SYNC timer stop.
EXTRN	TMVCNT:NEAR	; V-SYNC timer cont.
EXTRN	TMVSAV:NEAR	; V-SYNC timer value save.
EXTRN	TMVLOD:NEAR	; V-SYNC timer value load.


; ***********************************************
;	文字列バッファセット
;	０（文字列終り）はセットしない
;	-I- ES:[SI]  : 元文字列
;	    DS:[DI]  : セットするバッファ
;	    CX       : バッファ最大長さ
;	-O- DS:[DI]  : 文字列バッファ
; ***********************************************

STRSET	PROC	NEAR
	PUSH	CX
	PUSH	DI
	PUSH	SI
	PUSH	AX
STRSET_2:				;
	MOV	AL,ES:[SI]		;
	CMP	AL,0			; end of string.
	JE	STRSET_3		;
	MOV	DS:[DI],AL		;
	INC	SI			;
	INC	DI			;
	LOOP	STRSET_2		;
STRSET_3:				;
	POP	AX
	POP	SI
	POP	DI
	POP	CX
	RET
STRSET	ENDP


; ***********************************************
;	文字列バッファセット
;	０（文字列終り）をセットする
;	-I- ES:[SI]  : 元文字列
;	    DS:[DI]  : セットするバッファ
;	    CX       : バッファ最大長さ
;	-O- DS:[DI]  : 文字列バッファ
; ***********************************************

STRSETZ	PROC	NEAR
	PUSH	CX
	PUSH	DI
	PUSH	SI
	PUSH	AX
STRSETZ_2:				;
	MOV	AL,ES:[SI]		;
	MOV	DS:[DI],AL		;
	CMP	AL,0			; end of string.
	JE	STRSETZ_3		;
	INC	SI			;
	INC	DI			;
	LOOP	STRSETZ_2		;
STRSETZ_3:				;
	POP	AX
	POP	SI
	POP	DI
	POP	CX
	RET
STRSETZ	ENDP


; ***********************************************
;	文字列バッファＦＩＬＬ
;	０（文字列終り）はセットしない
;	-I- DX       : 文字	ＡＮＫ（ＤＨ＝０），漢字（ＤＨ＝上位バイト）
;	    DS:[DI]  : セットするバッファ
;	    CX       : バッファ最大長さ
;	-O- DS:[DI]  : 文字列バッファ
; ***********************************************

STRFILL	PROC	NEAR
	PUSH	CX
	PUSH	DI
	PUSH	SI
	PUSH	AX

	CMP	DH,0			; 文字
	JNZ	STRFILL_KANJI		;

	MOVX	ES,DS
	MOV	AX,DX
	REP	STOSB

	JMP	STRFILL_EXIT
STRFILL_KANJI:
	SHR	CX,1			; word pointer.
	MOVX	ES,DS
	MOV	AX,DX
	XCHG	AH,AL
	REP	STOSW
STRFILL_EXIT:
	POP	AX
	POP	SI
	POP	DI
	POP	CX
	RET
STRFILL	ENDP

; ***********************************************
;	文字列バッファクリア
;	-O- STR_BUFF : 文字列バッファ
; ***********************************************

STRCLEAR	PROC	NEAR
	PUSH	ES			;
	PUSH	DI			;
	PUSH	CX			;
	PUSH	AX			;
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	AL,' '			; space.
	MOV	CX,STRING_LEN		; string length.
	REP	STOSB			;
	POP	AX			;
	POP	CX			;
	POP	DI			;
	POP	ES			;
	RET
STRCLEAR	ENDP


; ***********************************************
;	文字列バッファ０クリア
;	-O- STR_BUFF : 文字列バッファ
; ***********************************************

STRZEROC	PROC	NEAR
	PUSH	ES			;
	PUSH	DI			;
	PUSH	CX			;
	PUSH	AX			;
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	AL,0			; space.
	MOV	CX,STRING_LEN		; string length.
	REP	STOSB			;
	POP	AX			;
	POP	CX			;
	POP	DI			;
	POP	ES			;
	RET
STRZEROC	ENDP


; ***********************************************
;	文字列・数字半角を全角
;	-I- DS:[SI] : 数字半角
;	    DS:[DI] : 全角用バッファ
;	-O- DS:[DI] : 全角
; ***********************************************

STR_N_HNZN	PROC	NEAR
	PUSH	SI
	PUSH	DI
	MOV	CX,256
STR_N_HNZN_LOOP:
	MOV	AL,DS:[SI]		; 数字半角
	INC	SI			;

	CMP	AL,0			;
	JE	STR_N_HNZN_EXIT		;

	CMP	AL,'$'			;＄
	JE	STR_N_HNZN_4		;

	CMP	AL,'0'
	JB	STR_N_HNZN_3
	CMP	AL,'9'
	JNBE	STR_N_HNZN_3
STR_N_HNZN_2:
	MOV	AH,0
	ADD	AX,824FH-'0'		;"０"<-"0"
	MOV	DS:[DI],AH		;
	INC	DI			;
	MOV	DS:[DI],AL		;
	INC	DI			;
	JMP	STR_N_HNZN_NEXT
STR_N_HNZN_3:
	MOV	DS:[DI],AL		; 半角のまま
	INC	DI			;
	JMP	STR_N_HNZN_NEXT

STR_N_HNZN_4:
	MOV	AX,"＄"			;
	MOV	DS:[DI],AH		;
	INC	DI			;
	MOV	DS:[DI],AL		;
	INC	DI			;
STR_N_HNZN_NEXT:
	LOOP	STR_N_HNZN_LOOP
STR_N_HNZN_EXIT:
	MOV	DS:[DI],BYTE PTR 0	; ＥＯＳ
	POP	DI
	POP	SI
	RET
STR_N_HNZN	ENDP


; ***********************************************
;	ユーザ待ち
; ***********************************************

US_WAIT	PROC	NEAR
	CALL	MSCWAT			; カーソルボタンＯＦＦ待ち
	CALL	MSCSTS			; マウスカーソルステータス
	CMP	AX,1			; 1=マウスカーソル表示中
	JNE	US_WAIT_LOOP2		;

US_WAIT_LOOP:
	CALL	MSCMOV			; カーソル移動
	CMP	DH,0			;
	JE	US_WAIT_EXIT		;
	CMP	DL,0			;
	JE	US_WAIT_EXIT		;
	JMP	US_WAIT_LOOP		;

US_WAIT_LOOP2:
	CALL	MUSRED			; マウス読み込み
	CMP	DH,0			;
	JE	US_WAIT_EXIT		;
	CMP	DL,0			;
	JE	US_WAIT_EXIT		;
	JMP	US_WAIT_LOOP2		;

US_WAIT_EXIT:				;
	RET
US_WAIT	ENDP


; ***********************************************
;	文字列表示クリア
;	-I- AX : 表示Ｘ位置
;	    BX : 表示Ｙ位置
;	    CX : 文字長さ
; 	    DX : 文字サイズ 0=16x16  1=32x32  2=16x24  3=16x32 10=8x8
;	    DI : カラー
;	    SI : カラー２
; ***********************************************

DSPSTR_CLR	PROC	NEAR
	CMP	CX,0		; 文字長さ
	JE	DSPSTR_CLR_SKIP	;
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI


	MOV	VX1,AX
	MOV	VY1,BX
	MOV	VX2,AX
	MOV	VY2,BX

	CMP	DX,0		; 文字サイズ 0=16x16
	JE	DSPSTR_CLR_20	;
	CMP	DX,1		; 文字サイズ 1=32x32
	JE	DSPSTR_CLR_21	;
	CMP	DX,2		; 文字サイズ 2=16x24
	JE	DSPSTR_CLR_22	;
	CMP	DX,3		; 文字サイズ 3=16x32
	JE	DSPSTR_CLR_23	;
	CMP	DX,10		; 文字サイズ 10=8x8
	JE	DSPSTR_CLR_210	;
DSPSTR_CLR_20:
	MOV	DX,16
	JMP	DSPSTR_CLR_29
DSPSTR_CLR_21:
	SHL	CX,1
	MOV	DX,32
	JMP	DSPSTR_CLR_29
DSPSTR_CLR_22:
	MOV	DX,24
	JMP	DSPSTR_CLR_29
DSPSTR_CLR_23:
	MOV	DX,32
	JMP	DSPSTR_CLR_29
DSPSTR_CLR_210:
	MOV	DX,8
	JMP	DSPSTR_CLR_29
DSPSTR_CLR_29:
	ADD	VX2,CX
	ADD	VY2,DX

	DEC	VX2
	DEC	VY2

	PUSH	SI
	MOV	CX,DI		; カラー
	CALL	BOXPAL		; ＢＯＸペイント
	POP	SI

	MOV	CX,SI		; カラー２
	CALL	BOXMSS		; ＢＯＸメッシュ

	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
DSPSTR_CLR_SKIP:
	RET
DSPSTR_CLR	ENDP


; ***********************************************
;	タイマ待ち
; ***********************************************

TM_WAIT	PROC	NEAR
	CALL	MUSRED		; マウス読み込み
	CMP	DH,0			;
	JE	TM_WAIT_QUICK		;
	CMP	DL,0			;
	JE	TM_WAIT_QUICK		;
TM_WAIT_NORMAL:
	MOV	AX,40*1			; wait timer count.
	JMP	TM_WAIT_WAIT		;
TM_WAIT_QUICK:
	MOV	AX,10*1			; wait timer count.
TM_WAIT_WAIT:
	CALL	TMVWAT		; V-SYNC timer wait.
	RET
TM_WAIT	ENDP


; ***********************************************
;	タイマハーフ待ち
; ***********************************************

TM_WAIT_H	PROC	NEAR
	MOV	AX,10		; wait timer count.
	CALL	TMVWAT		; V-SYNC timer wait.
	RET
TM_WAIT_H	ENDP


; ***********************************************
;	文字列の連結
;	０（文字列終り）をセットする
;	-I- DS:[DI]  : 文字列
;	    DS:[SI]  : 連結する文字列
; ***********************************************

ADDSTRSET	PROC	NEAR
	PUSH	DI
	PUSH	SI

	MOV	AX,DS
	MOV	ES,AX
	CALL	STRLENGTH		; 文字列長さ

	ADD	DI,CX

	MOV	AX,DS
	MOV	ES,AX
	MOV	CX,256			; バッファ最大長さ
	CALL	STRSETZ			; 文字列バッファセット

	POP	SI
	POP	DI
	RET
ADDSTRSET	ENDP


; ****************************************************
;	文字列長さ
;	-I- ES:DI : 文字列アドレス
;	-O- CX    : 表示単語長さ
; ****************************************************

STRLENGTH	PROC	NEAR
	PUSH	DI

	MOV	CX,256
	MOV	AL,0
	REPNE	SCASB

	NEG	CX
	ADD	CX,256

	DEC	CX

	POP	DI

	RET
STRLENGTH	ENDP


; ****************************************************
;	文字列長さスペースまで
;	-I- ES:DI : 文字列アドレス
;	-O- CX    : 表示単語長さ
; ****************************************************

STRLENSPZ	PROC	NEAR
	PUSH	DI

	MOV	CX,256
STRLENSPZ_LOOP:
	MOV	AL,ES:[DI]
	INC	DI
	CMP	AL,' '
	JBE	STRLENSPZ_LOOP_E
	LOOP	STRLENSPZ_LOOP

	MOV	CX,256
	POP	DI
	RET

STRLENSPZ_LOOP_E:
	NEG	CX
	ADD	CX,256

	POP	DI
	RET
STRLENSPZ	ENDP


; ****************************************************
;	漢字文字詰め処理
;	-I- DS:[SI]  : 文字列
;	    CX       : 詰める長さ
; ****************************************************

KANJITUME	PROC	NEAR
	MOV	KANJI_STR_ADRS,SI	; 文字列アドレス
	MOV	KANJI_LEN_MAX,CX	; 表示文字の最長

	MOV	DI,KANJI_STR_ADRS	; 文字列アドレス
	MOVX	ES,DS			;
	CALL	STRLENSPZ		; 文字列長さスペースまで
	CMP	CX,KANJI_LEN_MAX	; 表示文字の最長
	JLE	KANJITUME_6		;

	MOV	SI,KANJI_STR_ADRS	; 文字列アドレス
	ADD	SI,2			;
	CALL	KANJICHOT		; 漢字文字列をちょっとだけ半角に詰める

	MOV	DI,KANJI_STR_ADRS	; 文字列アドレス
	MOVX	ES,DS			;
	CALL	STRLENSPZ		; 文字列長さスペースまで
	CMP	CX,KANJI_LEN_MAX	; 表示文字の最長
	JLE	KANJITUME_6		;

	MOV	SI,KANJI_STR_ADRS	; 文字列アドレス
	ADD	SI,2			;
	CALL	KANJISHORT		; 漢字文字列を半角に詰める
KANJITUME_6:
	RET
KANJITUME	ENDP

; ****************************************************
;	漢字文字列を半角に詰める
;	-I- DS:[SI]  : 文字列
; ****************************************************

KANJISHORT	PROC	NEAR
	MOV	AX,DS
	MOV	ES,AX

	MOV	BX,SI			; BX=書き込みポインタ
KANJISHORT_LOOP:
	LODSW				; AX=漢字文字
	CMP	AL,0			;
	JE	KANJISHORT_EXIT		;

	MOV	DX,AX			; character code.
	CALL	SJISCK			; シフトＪＩＳチェック
	CMP	AX,0			; 0=normal,1=shift jis code.
	JE	KANJISHORT_MOV_BYTE	;

	MOV	AX,DX			; character code.

	MOV	DI,OFFSET ZENHAN_Z_ST	; 辞書・変換前
	MOV	CX,OFFSET ZENHAN_Z_ED
	SUB	CX,OFFSET ZENHAN_Z_ST
	SHR	CX,1			; word counter.
	REPNE	SCASW			; 該当半角はあるか？
	JNE	KANJISHORT_MOV		;

	DEC	DI
	DEC	DI
	SUB	DI,OFFSET ZENHAN_Z_ST	; 辞書・何番目か？
	SHR	DI,1			; word -> byte.
	MOV	AL,DS:ZENHAN_HAN[DI]	; 辞書・変換後
	MOV	DS:[BX],AL		; BX=書き込みポインタ
	INC	BX
	JMP	KANJISHORT_NEXT		;
KANJISHORT_MOV:
	MOV	DS:[BX],AX		; BX=書き込みポインタ
	INC	BX			;
	INC	BX			;
	JMP	KANJISHORT_NEXT		;
KANJISHORT_MOV_BYTE:
	MOV	DS:[BX],DL		; BX=書き込みポインタ
	DEC	SI
	INC	BX
KANJISHORT_NEXT:
	JMP	KANJISHORT_LOOP

KANJISHORT_EXIT:
	MOV	BYTE PTR DS:[BX],0	; end of string.
	RET
KANJISHORT	ENDP


; ****************************************************
;	漢字文字列をちょっとだけ半角に詰める
;	-I- DS:[SI]  : 文字列
; ****************************************************

KANJICHOT	PROC	NEAR
	MOV	AX,DS
	MOV	ES,AX

	MOV	BX,SI			; BX=書き込みポインタ
KANJICHOT_LOOP:
	LODSW				; AX=漢字文字
	CMP	AL,0			;
	JE	KANJICHOT_EXIT		;

	MOV	DX,AX			; character code.
	CALL	SJISCK			; シフトＪＩＳチェック
	CMP	AX,0			; 0=normal,1=shift jis code.
	JE	KANJICHOT_MOV_BYTE	;

	MOV	AX,DX			; character code.

	MOV	DI,OFFSET ZENHAN_Z_HF	; 辞書・変換前
	MOV	CX,OFFSET ZENHAN_Z_ED
	SUB	CX,OFFSET ZENHAN_Z_HF
	SHR	CX,1			; word counter.
	REPNE	SCASW			; 該当半角はあるか？
	JNE	KANJICHOT_MOV		;

	DEC	DI
	DEC	DI
	SUB	DI,OFFSET ZENHAN_Z_HF	; 辞書・何番目か？
	SHR	DI,1			; word -> byte.
	MOV	AL,DS:ZENHAN_HAN_HF[DI]	; 辞書・変換後
	MOV	DS:[BX],AL		; BX=書き込みポインタ
	INC	BX
	JMP	KANJICHOT_NEXT		;
KANJICHOT_MOV:
	MOV	DS:[BX],AX		; BX=書き込みポインタ
	INC	BX
	INC	BX
	JMP	KANJICHOT_NEXT		;
KANJICHOT_MOV_BYTE:
	MOV	DS:[BX],DL		; BX=書き込みポインタ
	DEC	SI
	INC	BX
KANJICHOT_NEXT:
	JMP	KANJICHOT_LOOP

KANJICHOT_EXIT:
	MOV	BYTE PTR DS:[BX],0	; end of string.
	RET
KANJICHOT	ENDP


; ****************************************************
;	シフトＪＩＳチェック
;	-I- DX : character code.
;	-O- AX : 0=normal,1=shift jis code.
; ****************************************************

SJISCK	PROC	NEAR
	MOV	AX,0
	CMP	DL,081H
	JB	SJISCK3
	CMP	DL,09FH
	JNBE	SJISCK3
	MOV	AX,1		; shift jis code.
	RET
SJISCK3:
	CMP	DL,0E0H
	JB	SJISCK9
	CMP	DL,0FCH
	JNBE	SJISCK9
	MOV	AX,1		; shift jis code.
SJISCK9:
	RET
SJISCK	ENDP


; ****************************************************
;	バイトテーブルサーチ
;	-I- ES:[DI] : バイトテーブル
;	          ES:[DI][0] : テーブルサイズ=n
;	          ES:[DI][1] : 先頭
;	          ES:[DI][.] :  .
;	          ES:[DI][.] :  .
;	          ES:[DI][.] :  .
;	          ES:[DI][n] : 最後
;	    DL      : サーチバイト
;	-O- AX      : 1=見つかった,0=見つからない
;	    CX      : みつかったオフセット（１からｎまで）
; ****************************************************

BYTE_TBL_SCH	PROC	NEAR
	MOV	AL,ES:[DI]
	INC	DI
	MOV	CH,0
	MOV	CL,AL

	MOV	BX,CX			; BX=table size.

	MOV	AL,DL			; サーチバイト
	REPNE	SCASB
	JNE	BYTE_TBL_SCH_NON

	INC	CX			;+1

	NEG	CX			; CX = BX - CX
	ADD	CX,BX			; BX=table size.

	INC	CX			;+1
BYTE_TBL_SCH_OK:
	MOV	AX,1			; 1=見つかった
	RET
BYTE_TBL_SCH_NON:
	MOV	AX,0			; 0=見つからない
	RET
BYTE_TBL_SCH	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.
EXTRN	VX3:WORD		; destination point x3.
EXTRN	VY3:WORD		; destination point y3.

EXTRN	STR_BUFF:BYTE		; 文字列バッファ
EXTRN	STR_VAL_BUFF:BYTE	; 表示値文字列バッファ

KANJI_LEN_MAX	DW	0	; 表示文字の最長
KANJI_STR_ADRS	DW	0	; 文字列アドレス

ZENHAN_Z_ST	LABEL	WORD
	DB	"アイウエオカキクケコサシスセソタチツテトナニヌネノ"
	DB	"ハヒフヘホマミムメモヤユヨラリルレロワヲン"
ZENHAN_Z_HF	LABEL	BYTE
	DB	"ァィゥェォャュョッー－・"
ZENHAN_Z_ED	LABEL	WORD
ZENHAN_HAN	LABEL	BYTE
	DB	"ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝ"
ZENHAN_HAN_HF	LABEL	BYTE
	DB	"ｧｨｩｪｫｬｭｮｯｰ-･",0

DATA	ENDS

	END
;
;	end of "CMDTOOL.ASM"
;
