; "MUSCOR.ASM" 1989/03/21 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.
;
;	ARAVRM:WORD		; vram area.	( DEST )

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

	PUBLIC	MSCSRT		; カーソルスタート
	PUBLIC	MSCMOV		; カーソル移動
	PUBLIC	MSCWAT		; カーソルボタンＯＦＦ待ち
	PUBLIC	MSCSTP		; カーソルストップ
	PUBLIC	MSCSTS		; マウスカーソルステータス
	PUBLIC	MSCPNT		; カーソル表示位置

	EXTRN	MUSREDX:NEAR	; マウス読み込み
	EXTRN	MUSWATX:NEAR	; マウスボタンＯＦＦ待ち


ADDWIDTHCRT	EQU	80		; カーソル用計算
ADDWIDTH	EQU	80-4		; カーソル用計算
ADDWIDTH_SV	EQU	80-4		; エリア退避用計算
CUSLINE		EQU	32		; カーソルライン数
CUSLINE_SV	EQU	32		; エリア退避ライン数
MUSMAX_X	EQU	80-4		; マウス座標最大Ｘ
MUSMAX_Y	EQU	(50-4)*8	; マウス座標最大Ｙ
OFST_X		EQU	0		; マウス座標オフセットＸ
OFST_Y		EQU	0		; マウス座標オフセットＹ
MUSSIZ_X	EQU	4		; マウスサイズＸ
MUSSIZ_Y	EQU	4*8		; マウスサイズＹ


;	カーソルスタート

MSCSRT	PROC	NEAR
	MOV	MUSFLG,2	; 2=マウスカーソル書換中(割込防止)

	CALL	MUSREDX		; マウス読み込み
	CALL	ADJMOV		; 移動量調整

	MOV	CURX,AX
	MOV	CURY,BX

	CALL	VRAM_SAVE	; ＶＲＡＭ退避

	CALL	VRAM_PUT	; ＶＲＡＭカーソルＰＵＴ

	MOV	MUSFLG,1	; 1=マウスカーソル表示中
	RET
MSCSRT	ENDP


;	カーソルストップ

MSCSTP	PROC	NEAR
	MOV	MUSFLG,0	; 0=マウスＯＦＦ
	CALL	VRAM_LOAD	; ＶＲＡＭ戻す
	RET
MSCSTP	ENDP


;	カーソル移動
;	-O- AX : Ｘ座標
;	    BX : Ｙ座標
;	    DH : 左ボタン（1：ＯＦＦ／0：ＯＮ）
;	    DL : 右ボタン（1：ＯＦＦ／0：ＯＮ）

MSCMOV	PROC	NEAR
	MOV	MUSFLG,2	; 2=マウスカーソル書換中(割込防止)

	CALL	MUSREDX		; マウス読み込み
	CALL	ADJMOV		; 移動量調整

	CMP	AX,CURX		; カーソルＸ
	JNE	MSCMOV5

	CMP	BX,CURY		; カーソルＹ
	JNE	MSCMOV5

	JMP	MSCMOV9
MSCMOV5:
	PUSH	AX
	PUSH	BX
	PUSH	DX

	CALL	VRAM_LOAD	; ＶＲＡＭ戻す

	MOV	AX,CURNEWX	; カーソル新しいＸ
	MOV	CURX,AX
	MOV	AX,CURNEWY	; カーソル新しいＹ
	MOV	CURY,AX

	CALL	VRAM_SAVE	; ＶＲＡＭ退避
	CALL	VRAM_PUT	; ＶＲＡＭカーソルＰＵＴ

	POP	DX
	POP	BX
	POP	AX
MSCMOV9:
	ADD	AX,OFST_X
	ADD	BX,OFST_Y

	CALL	ADJUSR		; ユーザ座標調整

	MOV	MUSFLG,1	; 1=マウスカーソル表示中
	RET
MSCMOV	ENDP


;	カーソルボタンＯＦＦ待ち

MSCWAT	PROC	NEAR
	CALL	MUSREDX		; マウス読み込み
	CALL	MUSWATX		; マウスボタンＯＦＦ待ち
	RET
MSCWAT	ENDP


;	マウスカーソルステータス
;	-O- AX : 0=マウスＯＦＦ,1=マウスカーソル表示中

MSCSTS	PROC	NEAR
	MOV	AX,MUSFLG	; 1=マウスカーソル表示中,0=マウスＯＦＦ
	RET
MSCSTS	ENDP


;	カーソル表示位置
;	-O- AX : 左上Ｘ座標
;	    BX : 左上Ｙ座標
;	    CX : 右下Ｘ座標
;	    DX : 右下Ｙ座標

MSCPNT	PROC	NEAR
	CALL	MSCMOV			; カーソル移動
	MOV	MUSFLG,2		; 2=マウスカーソル書換中(割込防止)
	MOV	CX,AX			; Ｘ座標
	MOV	DX,BX			; Ｙ座標
	ADD	CX,MUSSIZ_X		; マウスサイズＸ
	ADD	DX,MUSSIZ_Y		; マウスサイズＹ
	RET
MSCPNT	ENDP


;	移動量調整
;	-I/O- AX : Ｘ座標
;	      BX : Ｙ座標
;	-O-   CURNEWX : カーソル新しいＸ
;	      CURNEWY : カーソル新しいＹ

ADJMOV	PROC	NEAR
	SAR	AX,1	; AX = AX / 8
	SAR	AX,1	;
	SAR	AX,1	;

	TEST	AX,8000H
	JZ	ADJMOV20
	MOV	AX,0
	JMP	ADJMOV2
ADJMOV20:
	CMP	AX,MUSMAX_X	; マウス座標最大Ｘ
	JLE	ADJMOV2
	MOV	AX,MUSMAX_X	; マウス座標最大Ｘ
ADJMOV2:
	MOV	CURNEWX,AX	; カーソル新しいＸ

	TEST	BX,8000H
	JZ	ADJMOV30
	MOV	BX,0
	JMP	ADJMOV3
ADJMOV30:
	CMP	BX,MUSMAX_Y	; マウス座標最大Ｙ
	JLE	ADJMOV3		;
	MOV	BX,MUSMAX_Y	; マウス座標最大Ｙ
ADJMOV3:
	MOV	CURNEWY,BX	; カーソル新しいＹ
	RET
ADJMOV	ENDP


;	ユーザ座標調整
;	-I/O- AX : Ｘ座標
;	      BX : Ｙ座標

ADJUSR	PROC	NEAR
	CMP	MOVE_MODE,1	; カーソル移動モード
	JE	ADJUSR_1	;
	SAR	BX,1		; BX = BX / 8
	SAR	BX,1		;
	SAR	BX,1		;
ADJUSR_1:
	RET
ADJUSR	ENDP




;	ＶＲＡＭ退避

VRAM_SAVE	PROC	NEAR
	PUSH	DS

	MOV	BX,CURY		; カーソルＹ
	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURX		; カーソルＸ

	MOV	SI,BX		; 先頭オフセット

	MOV	DI,OFFSET VRMSAV0	; ＶＲＡＭ退避エリア

	MOV	AX,DS		; データセグメント
	MOV	ES,AX		;

	MOV	DX,DS

	MOV	AX,ARAVRM[0]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE2:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE2

	MOV	SI,BX		; 先頭オフセット

	MOV	DS,DX		;

	MOV	AX,ARAVRM[2]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE3:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE3

	MOV	SI,BX		; 先頭オフセット

	MOV	DS,DX		;

	MOV	AX,ARAVRM[4]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE4:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE4

	MOV	SI,BX		; 先頭オフセット

	MOV	DS,DX		;

	MOV	AX,ARAVRM[6]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_SAVE5:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_SAVE5

	POP	DS
	RET
VRAM_SAVE	ENDP



;	ＶＲＡＭ戻す

VRAM_LOAD	PROC	NEAR
	MOV	BX,CURY		; カーソルＹ
	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURX		; カーソルＸ

	MOV	SI,OFFSET VRMSAV0	; ＶＲＡＭ退避エリア

	MOV	DI,BX		; 先頭オフセット

	MOV	AX,ARAVRM[0]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_LOAD2:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_LOAD2

	MOV	DI,BX		; 先頭オフセット

	MOV	AX,ARAVRM[2]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_LOAD3:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_LOAD3

	MOV	DI,BX		; 先頭オフセット

	MOV	AX,ARAVRM[4]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_LOAD4:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_LOAD4

	MOV	DI,BX		; 先頭オフセット

	MOV	AX,ARAVRM[6]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; エリア退避ライン数
VRAM_LOAD5:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; エリア退避用計算

	LOOP	VRAM_LOAD5

	RET
VRAM_LOAD	ENDP


;	ＶＲＡＭカーソルＰＵＴ

VRAM_PUT	PROC	NEAR
	MOV	BX,CURY		; カーソルＹ
	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURX		; カーソルＸ

;*NON*;	MOV	SI,CUSMSK	; カーソルマスク
;*NON*;	MOV	DI,BX		; 先頭オフセット
;*NON*;
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算0
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算1
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算2
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算3
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算4
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算5
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算6
;*NON*;	ADD	DI,ADDWIDTHCRT	; カーソル用計算7
;*NON*;;*NON*;	ADD	DI,1		;
;*NON*;	MOV	AX,ARAVRM[4]	; vram area.
;*NON*;	MOV	ES,AX		;
;*NON*;	MOV	CX,CUSLINE	; カーソルライン数
;*NON*;VRAM_PUT2_C:
;*NON*;	LODSW			;
;*NON*;	AND	WORD PTR ES:[DI],AX
;*NON*;	INC	DI
;*NON*;	INC	DI
;*NON*;	LODSW			;
;*NON*;	AND	WORD PTR ES:[DI],AX
;*NON*;	INC	DI
;*NON*;	INC	DI
;*NON*;	ADD	DI,ADDWIDTH	;
;*NON*;	LOOP	VRAM_PUT2_C


	MOV	SI,CUSMSK	; カーソルマスク
	MOV	DI,BX		; 先頭オフセット
	MOV	AX,ARAVRM[0]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT2:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT2

	MOV	SI,CUSDAT0	; カーソル
	MOV	DI,BX		; 先頭オフセット
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT22:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT22


	MOV	SI,CUSMSK	; カーソルマスク
	MOV	DI,BX		; 先頭オフセット
	MOV	AX,ARAVRM[2]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT3:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT3


	MOV	SI,CUSDAT1	; カーソル
	MOV	DI,BX		; 先頭オフセット
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT33:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT33


	MOV	SI,CUSMSK	; カーソルマスク
	MOV	DI,BX		; 先頭オフセット
	MOV	AX,ARAVRM[4]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT4:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT4


	MOV	SI,CUSDAT2	; カーソル
	MOV	DI,BX		; 先頭オフセット
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT44:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT44


	MOV	SI,CUSMSK	; カーソルマスク
	MOV	DI,BX		; 先頭オフセット
	MOV	AX,ARAVRM[6]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT5:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT5


	MOV	SI,CUSDAT3	; カーソル
	MOV	DI,BX		; 先頭オフセット
	MOV	CX,CUSLINE	; カーソルライン数
VRAM_PUT55:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT55

	RET
VRAM_PUT	ENDP


; ****************************************************
;	DATA
; ****************************************************
	EVEN

EXTRN	ARAVRM:WORD		; vram area.

CUSDAT0	DW	OFFSET MUSCURSOLE_3
CUSDAT1	DW	OFFSET MUSCURSOLE_3+4*32	
CUSDAT2	DW	OFFSET MUSCURSOLE_3+4*32*2
CUSDAT3	DW	OFFSET MUSCURSOLE_3+4*32*3
CUSMSK	DW	OFFSET MUSCURSOLE_3+4*32*4	; カーソルマスク

MUSCURSOLE_1	LABEL	BYTE
MUSCURSOLE_2	LABEL	BYTE
MUSCURSOLE_3	LABEL	BYTE
MUSCURSOLE_4	LABEL	BYTE
		DB	0c0H,000H,000H,000H,0f0H,000H,000H,000H
		DB	07cH,000H,000H,000H,07eH,000H,000H,000H
		DB	03dH,000H,000H,000H,03cH,080H,000H,000H
		DB	01eH,040H,000H,000H,00fH,020H,000H,000H
		DB	007H,090H,000H,000H,003H,0c8H,000H,000H
		DB	001H,0e4H,000H,000H,000H,0f2H,000H,000H
		DB	000H,079H,000H,000H,000H,03cH,080H,000H
		DB	000H,01eH,040H,020H,000H,00fH,020H,078H
		DB	000H,007H,090H,038H,000H,003H,0c8H,008H
		DB	000H,001H,0e4H,010H,000H,000H,0eeH,030H
		DB	000H,000H,06dH,060H,000H,000H,025H,060H
		DB	000H,000H,000H,0c0H,000H,000H,00cH,080H
		DB	000H,000H,003H,080H,000H,001H,08eH,070H
		DB	000H,001H,08cH,038H,000H,001H,0f0H,05cH
		DB	000H,000H,020H,02eH,000H,000H,000H,007H
		DB	000H,000H,000H,003H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,060H,000H,000H,000H
		DB	038H,000H,000H,000H,03cH,000H,000H,000H
		DB	01cH,000H,000H,000H,004H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,078H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,01eH,000H
		DB	000H,000H,00eH,000H,000H,000H,00fH,000H
		DB	000H,000H,012H,020H,000H,000H,000H,000H
		DB	000H,000H,000H,040H,000H,000H,080H,0a0H
		DB	000H,000H,082H,050H,000H,000H,000H,028H
		DB	000H,000H,000H,014H,000H,000H,000H,00bH
		DB	000H,000H,000H,005H,000H,000H,000H,002H
		DB	000H,000H,000H,000H,060H,000H,000H,000H
		DB	038H,000H,000H,000H,03cH,000H,000H,000H
		DB	01cH,000H,000H,000H,004H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,000H,000H,000H,000H,000H
		DB	000H,000H,000H,020H,000H,000H,000H,020H
		DB	000H,000H,000H,038H,000H,000H,000H,008H
		DB	000H,000H,000H,010H,000H,000H,000H,030H
		DB	000H,000H,014H,060H,000H,000H,011H,040H
		DB	000H,000H,00cH,0c0H,000H,000H,000H,080H
		DB	000H,000H,003H,040H,000H,001H,08eH,090H
		DB	000H,001H,008H,038H,000H,001H,0f0H,014H
		DB	000H,000H,020H,002H,000H,000H,000H,000H
		DB	000H,000H,000H,001H,000H,000H,000H,000H
		DB	080H,000H,000H,000H,0e0H,000H,000H,000H
		DB	078H,000H,000H,000H,07cH,000H,000H,000H
		DB	03eH,000H,000H,000H,027H,000H,000H,000H
		DB	013H,080H,000H,000H,009H,0c0H,000H,000H
		DB	004H,0e0H,000H,000H,002H,070H,000H,000H
		DB	001H,038H,000H,000H,000H,09cH,000H,000H
		DB	000H,04eH,000H,000H,000H,027H,000H,000H
		DB	000H,013H,080H,000H,000H,009H,0c0H,078H
		DB	000H,004H,0e0H,000H,000H,002H,070H,000H
		DB	000H,001H,038H,000H,000H,000H,090H,000H
		DB	000H,000H,046H,000H,000H,000H,02bH,020H
		DB	000H,000H,012H,020H,000H,000H,000H,000H
		DB	000H,000H,000H,0c0H,000H,000H,080H,0e0H
		DB	000H,000H,086H,050H,000H,000H,000H,068H
		DB	000H,000H,000H,03cH,000H,000H,000H,00eH
		DB	000H,000H,000H,007H,000H,000H,000H,002H

		DB	03fH,0ffH,0ffH,0ffH,00fH,0ffH,0ffH,0ffH
		DB	083H,0ffH,0ffH,0ffH,081H,0ffH,0ffH,0ffH
		DB	0c0H,0ffH,0ffH,0ffH,0c0H,07fH,0ffH,0ffH
		DB	0e0H,03fH,0ffH,0ffH,0f0H,01fH,0ffH,0ffH
		DB	0f8H,00fH,0ffH,0ffH,0fcH,007H,0ffH,0ffH
		DB	0feH,003H,0ffH,0ffH,0ffH,001H,0ffH,0ffH
		DB	0ffH,080H,0ffH,0ffH,0ffH,0c0H,07fH,0ffH
		DB	0ffH,0e0H,03fH,087H,0ffH,0f0H,01fH,007H
		DB	0ffH,0f8H,00fH,087H,0ffH,0fcH,007H,0e7H
		DB	0ffH,0feH,003H,0c7H,0ffH,0ffH,001H,08fH
		DB	0ffH,0ffH,080H,01fH,0ffH,0ffH,0c0H,01fH
		DB	0ffH,0ffH,0e0H,01fH,0ffH,0ffH,0f0H,03fH
		DB	0ffH,0feH,0f0H,00fH,0ffH,0fcH,060H,007H
		DB	0ffH,0fcH,021H,003H,0ffH,0fcH,00fH,001H
		DB	0ffH,0feH,01fH,080H,0ffH,0ffH,0ffH,0c0H
		DB	0ffH,0ffH,0ffH,0e0H,0ffH,0ffH,0ffH,0f0H
IF 0
		DB	004H,0e0H,000H,000H,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	002H,070H,000H,000H,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	001H,038H,000H,000H,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	000H,09cH,000H,000H,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	000H,04eH,000H,000H,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
		DB	0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH,0ffH
ENDIF


VRMSAV0 DB	40*5 DUP (?)		; ＶＲＡＭ退避エリア
VRMSAV1	DB	40*5 DUP (?)		;
VRMSAV2	DB	40*5 DUP (?)		;
VRMSAV3	DB	40*5 DUP (?)		;

CURX	DW	0			; カーソルＸ
CURY	DW	0			; カーソルＹ

CURNEWX	DW	0			; カーソル新しいＸ
CURNEWY	DW	0			; カーソル新しいＹ

MOVE_MODE DW	1			; カーソル移動モード
					; 0=横バイト／縦バイト
					; 1=横バイト／縦ドット

MUSFLG	DW	0			; 0=マウスＯＦＦ
					; 1=マウスカーソル表示中
					; 2=マウスカーソル書換中(割込防止)

CODE	ENDS

	END
;
;	end of "MUSCOR.ASM"
;
