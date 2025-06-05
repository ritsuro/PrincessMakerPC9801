; "SCHIP.ASM" R.H 1991/03/23 PC9801UV11
;
;	chip set.
;

WORLD_LOC_XX	EQU	2		; world location x.
WORLD_LOC_YY	EQU	40		; world location y.
WORLD_LOC_OFST	EQU	80*40+2		; world location offset.

NXT_CHIP_ADRS	EQU	80*32		; next line chip address.
NXT_LINE_OFST	EQU	80-4		; next line offset.

AJST_CHR_Y	EQU	80*12		; ajast char y.


PUT32X4	MACRO				; 32x4 plean put.
	LODSW				;
	STOSW				;
	LODSW				;
	STOSW				;
	ADD	DI,DX			; next line offset.
	LODSW				;
	STOSW				;
	LODSW				;
	STOSW				;
	ADD	DI,DX			; next line offset.
	LODSW				;
	STOSW				;
	LODSW				;
	STOSW				;
	ADD	DI,DX			; next line offset.
	LODSW				;
	STOSW				;
	LODSW				;
	STOSW				;
	ADD	DI,DX			; next line offset.
	ENDM				;

MSK32X4	MACRO				; 32x4 plean mask.
	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	AND	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	ENDM				;

OR32X4	MACRO				; 32x4 plean OR.
	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	LODSW				;
	OR	ES:[DI],AX		;
	INC	DI			;
	INC	DI			;
	ADD	DI,DX			; next line offset.

	ENDM				;


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	SCHIPPUT			; chip put.
PUBLIC	SCHIPCHR			; chip char.
PUBLIC	SCHIPCR2			; chip char2.


;	chip put.
;	-I- PUTXX : put x.
;	    PUTYY : put y.
;	    PUTNM : chip number.
;	-O- VRAM_OFFSET	: vram offset address.

SCHIPPUT	PROC	NEAR
	CALL	VMAP_ADRS_ON		; vram address on chip.

	MOV	BX,PUTNM		; chip number.
	SHL	BX,1			; word pointer.
	MOV	SI,DS:CHIPTABLE[BX]	; chip table.

	MOV	ES,VRAMPLN0		; vram plean 0.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_PUTS		; image put.

	MOV	ES,VRAMPLN1		; vram plean 1.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_PUTS		; image put.

	MOV	ES,VRAMPLN2		; vram plean 2.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_PUTS		; image put.

	MOV	ES,VRAMPLN3		; vram plean 3.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_PUTS		; image put.

	RET
SCHIPPUT	ENDP


;	chip char.
;	-I- PUTXX : put x.
;	    PUTYY : put y.
;	    PUTNM : chip number.

SCHIPCHR	PROC	NEAR
	CALL	SCHIPPUT		; chip put.

	SUB	VRAM_OFFSET,AJST_CHR_Y	; ajast char y.

	MOV	BX,CHRNM		; charcter number.
	SHL	BX,1			;
	SHL	BX,1			; 2 word pointer.
	CALL	SI_PUT			; si data put
	RET
SCHIPCHR	ENDP


;	chip char2.
;	-I- PUTXX : put x.
;	    PUTYY : put y.
;	    PUTNM : chip number.

SCHIPCR2	PROC	NEAR
	CALL	SCHIPPUT		; chip put.

	SUB	VRAM_OFFSET,AJST_CHR_Y	; ajast char y.

	MOV	BX,CHRNM		; charcter number.
	SHL	BX,1			;
	SHL	BX,1			; 2 word pointer.
	INC	BX			; +1
	INC	BX			; +1
	CALL	SI_PUT			; si data put
	RET
SCHIPCR2	ENDP


;	si data put

SI_PUT	PROC	NEAR
	MOV	SI,DS:CHARTABLE[BX]	; char table.
	ADD	SI,4*32*4		;

	MOV	ES,VRAMPLN0		; vram plean 0.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_MASK		; image mask.

	MOV	SI,DS:CHARTABLE[BX]	; char table.
	ADD	SI,4*32*4		;

	MOV	ES,VRAMPLN1		; vram plean 1.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_MASK		; image mask.

	MOV	SI,DS:CHARTABLE[BX]	; char table.
	ADD	SI,4*32*4		;

	MOV	ES,VRAMPLN2		; vram plean 2.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_MASK		; image mask.

	MOV	SI,DS:CHARTABLE[BX]	; char table.
	ADD	SI,4*32*4		;

	MOV	ES,VRAMPLN3		; vram plean 3.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_MASK		; image mask.


	MOV	SI,DS:CHARTABLE[BX]	; char table.

	MOV	ES,VRAMPLN0		; vram plean 0.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_OR		; image OR.

	MOV	ES,VRAMPLN1		; vram plean 1.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_OR		; image OR.

	MOV	ES,VRAMPLN2		; vram plean 2.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_OR		; image OR.

	MOV	ES,VRAMPLN3		; vram plean 3.
	MOV	DX,NXT_LINE_OFST	; next line offset.
	MOV	DI,VRAM_OFFSET		; vram offset address.
	CALL	IMAGE_OR		; image OR.

	RET
SI_PUT	ENDP


;	image put.
;	-I/O- DS:SI : pattan address.
;	      ES:DI : vram put address.
;	      DX    : next line offset.

IMAGE_PUTS	PROC	NEAR
	MOV	CX,8
IMAGE_PUTS_LOOP:			;
	PUT32X4				; 32x4 plean put.1
	LOOP	IMAGE_PUTS_LOOP		;
	RET
IMAGE_PUTS	ENDP


;	image mask.
;	-I/O- DS:SI : pattan address.
;	      ES:DI : vram put address.
;	      DX    : next line offset.

IMAGE_MASK	PROC	NEAR
	MOV	CX,8
IMAGE_MASK_LOOP:			;
	MSK32X4				; 32x4 plean mask.1
	LOOP	IMAGE_MASK_LOOP		;
	RET
IMAGE_MASK	ENDP


;	image OR.
;	-I/O- DS:SI : pattan address.
;	      ES:DI : vram put address.
;	      DX    : next line offset.

IMAGE_OR	PROC	NEAR
	MOV	CX,8
IMAGE_OR_LOOP:				;
	OR32X4				; 32x4 plean OR.1
	LOOP	IMAGE_OR_LOOP		;
	RET
IMAGE_OR	ENDP


;	vram address on chip.
;	-I- PUTXX : put x.
;	    PUTYY : put y.
;	-O- VRAM_OFFSET	: vram offset address.

VMAP_ADRS_ON	PROC	NEAR
	MOV	AX,PUTYY		; put y.
	MOV	BX,NXT_CHIP_ADRS	; next line chip address.
	MUL	BX			; AX=AX*BX
	MOV	DX,PUTXX		; put x.
	SHL	DX,1			;
	SHL	DX,1			; * 4(byte step)
	ADD	AX,DX			;
	MOV	VRAM_OFFSET,AX		; vram offset address.
	ADD	VRAM_OFFSET,WORLD_LOC_OFST ; world location offset.
	RET
VMAP_ADRS_ON	ENDP


; *********************************************************
;		DATA.
; *********************************************************
		EVEN

EXTRN	CHIPTABLE:WORD			; chip table.
EXTRN	CHARTABLE:WORD			; char table.

EXTRN	PUTXX:WORD			; put x.
EXTRN	PUTYY:WORD			; put y.
EXTRN	PUTNM:WORD			; chip number.
EXTRN	CHRNM:WORD			; charcter number.

VRAMPLN0	DW	0A800H		; vram plean 0.
VRAMPLN1	DW	0B000H		; vram plean 1.
VRAMPLN2	DW	0B800H		; vram plean 2.
VRAMPLN3	DW	0E000H		; vram plean 3.

VRAM_OFFSET	DW	0		; vram offset address.

CODE	ENDS

	END
;
;	end of "SCHIP.ASM"
;
