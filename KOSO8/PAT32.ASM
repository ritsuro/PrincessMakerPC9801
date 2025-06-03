; "PAT32.ASM" 1991/03/12 R.H PC-9801UV11 make by R.H 1991
;
;
;	３２×３２パターンＰＵＴ
;
;	0:ＯＦＦ
;	1:ＯＮ
;	2:ＨＩ
;	3:ＯＮ－ＴＵＣＨ
;	4:ＯＦＦ－ＴＵＣＨ
;
; public subroutine.

;	ARAVRM:WORD		; vram area.	( DEST )

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	PAT32PUT		; ３２×３２パターンＰＵＴ
PUBLIC	PAT32VRAM_LOAD		; ＶＲＡＭ戻す
PUBLIC	PAT32VRAM_SAVE		; ＶＲＡＭ退避



ADDWIDTHCRT	EQU	80	; カーソル用計算
ADDWIDTH	EQU	80-4	; カーソル用計算
CUSLINE		EQU	32	; カーソルライン数
ADDWIDTH_SV	EQU	80-4		; エリア退避用計算
CUSLINE_SV	EQU	32		; エリア退避ライン数


;	３２×３２パターンＰＵＴ
;	-I- CURX   : カーソルＸ
;	    CURY   : カーソルＹ
;	    CURNUM : パターン番号
;		0:ＯＦＦ
;		1:ＯＮ
;		2:ＨＩ
;		3:ＯＮ－ＴＵＣＨ
;		4:ＯＦＦ－ＴＵＣＨ

PAT32PUT	PROC	NEAR
	CALL	PATCHNG			; パターンチェンジ
	CALL	VRAM_PUT		; ＶＲＡＭカーソルＰＵＴ
	RET
PAT32PUT	ENDP


;	ＶＲＡＭ退避
;	-I- CURX   : カーソルＸ
;	    CURY   : カーソルＹ

PAT32VRAM_SAVE	PROC	NEAR
	CALL	VRAM_SAVE		; ＶＲＡＭ退避
	RET
PAT32VRAM_SAVE	ENDP


;	ＶＲＡＭ戻す

PAT32VRAM_LOAD	PROC	NEAR
	CALL	VRAM_LOAD		; ＶＲＡＭ戻す
	RET
PAT32VRAM_LOAD	ENDP


;	パターンチェンジ
;	-I- CURNUM : パターン番号

PATCHNG	PROC	NEAR
	CMP	CURNUM,1	;
	JE	PATCHNG_1	;
	CMP	CURNUM,2	;
	JE	PATCHNG_2	;
	CMP	CURNUM,3	;
	JE	PATCHNG_3	;
	CMP	CURNUM,4	;
	JE	PATCHNG_4	;

PATCHNG_0:				; ＯＦＦ
	MOV	AX,OFFSET CUSDT00
	MOV	BX,OFFSET CUSDT00+128
	MOV	CX,OFFSET CUSDT00+256
	MOV	DX,OFFSET CUSDT00+384
	MOV	DI,OFFSET CUSDT00+512
	JMP	PATCHNG_5

PATCHNG_1:				; ＯＮ
	MOV	AX,OFFSET CUSDT10
	MOV	BX,OFFSET CUSDT10+128
	MOV	CX,OFFSET CUSDT10+256
	MOV	DX,OFFSET CUSDT10+384
	MOV	DI,OFFSET CUSDT10+512
	JMP	PATCHNG_5

PATCHNG_2:				; ＨＩ
	MOV	AX,OFFSET CUSDT20
	MOV	BX,OFFSET CUSDT20+128
	MOV	CX,OFFSET CUSDT20+256
	MOV	DX,OFFSET CUSDT20+384
	MOV	DI,OFFSET CUSDT20+512
	JMP	PATCHNG_5

PATCHNG_3:				; ＯＮ－ＴＵＣＨ
	MOV	AX,OFFSET CUSDT30
	MOV	BX,OFFSET CUSDT30+128
	MOV	CX,OFFSET CUSDT30+256
	MOV	DX,OFFSET CUSDT30+384
	MOV	DI,OFFSET CUSDT30+512
	JMP	PATCHNG_5

PATCHNG_4:				; ＯＦＦ－ＴＵＣＨ
	MOV	AX,OFFSET CUSDT40
	MOV	BX,OFFSET CUSDT40+128
	MOV	CX,OFFSET CUSDT40+256
	MOV	DX,OFFSET CUSDT40+384
	MOV	DI,OFFSET CUSDT40+512
	JMP	PATCHNG_5

PATCHNG_5:
	MOV	ADRDAT0,AX
	MOV	ADRDAT1,BX
	MOV	ADRDAT2,CX
	MOV	ADRDAT3,DX
	MOV	CUSMSK,DI
	RET
PATCHNG	ENDP


;	ＶＲＡＭカーソルＰＵＴ
;	-I- CURX : カーソルＸ
;	    CURY : カーソルＹ

VRAM_PUT	PROC	NEAR
	MOV	BX,CURY		; カーソルＹ
	SHL	BX,1		;
	SHL	BX,1		;
	SHL	BX,1		; bx = vy1 * 8

	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURX		; カーソルＸ


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

	MOV	AX,ARAVRM[0]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT0	; カーソル
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

	MOV	AX,ARAVRM[2]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT1	; カーソル
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

	MOV	AX,ARAVRM[4]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT2	; カーソル
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


	MOV	AX,ARAVRM[6]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT3	; カーソル
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


;	ＶＲＡＭ退避

VRAM_SAVE	PROC	NEAR
	PUSH	DS

	MOV	BX,CURY		; カーソルＹ
	SHL	BX,1		;
	SHL	BX,1		;
	SHL	BX,1		; bx = vy1 * 8

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

	MOV	AX,CURX		; カーソルＸ
	MOV	BX,CURY		; カーソルＹ
	MOV	CURXBAK,AX	; カーソルＸ
	MOV	CURYBAK,BX	; カーソルＹ
	RET
VRAM_SAVE	ENDP



;	ＶＲＡＭ戻す

VRAM_LOAD	PROC	NEAR
	MOV	BX,CURYBAK	; カーソルＹ
	SHL	BX,1		;
	SHL	BX,1		;
	SHL	BX,1		; bx = vy1 * 8

	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURXBAK	; カーソルＸ

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


; ****************************************************
;	DATA
; ****************************************************
	EVEN

EXTRN	ARAVRM:WORD		; vram area.

PUBLIC	CURNUM			; パターン番号
PUBLIC	CURX			; ３２×３２パターンＸ
PUBLIC	CURY			; ３２×３２パターンＹ

CURNUM	DW	0		; パターン番号
CURX	DW	0		; ３２×３２パターンＸ
CURY	DW	0		; ３２×３２パターンＹ
CURXBAK	DW	0		; カーソルＸ
CURYBAK	DW	0		; カーソルＹ

ADRDAT0	DW	CUSDT10
ADRDAT1	DW	CUSDT10+128
ADRDAT2	DW	CUSDT10+256
ADRDAT3	DW	CUSDT10+384
CUSMSK	DW	CUSDT10+512

VRMSAV0 DB	40*5 DUP (?)		; ＶＲＡＭ退避エリア
VRMSAV1	DB	40*5 DUP (?)		;
VRMSAV2	DB	40*5 DUP (?)		;
VRMSAV3	DB	40*5 DUP (?)		;

	; ＯＦＦ
CUSDT00		LABEL	BYTE
	INCLUDE	P32OFF.INC

	; ＯＮ
CUSDT10		LABEL	BYTE
	INCLUDE	P32ON.INC

	; ＨＩ
CUSDT20		LABEL	BYTE

	; ＯＮ－ＴＵＣＨ
CUSDT30		LABEL	BYTE
	INCLUDE	P32ONT.INC

	; ＯＦＦ－ＴＵＣＨ
CUSDT40		LABEL	BYTE
	INCLUDE	P32OFT.INC


CODE	ENDS

	END
;
;	end of "PAT32.ASM"
;
