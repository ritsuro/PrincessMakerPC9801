; "IOPORT.ASM" PC-9801UV11 make by R.H 1991/01/17
;
;	I/O port.
;
;	i80386-SX 16MHz wait i/o port.
;
;
;	example./ MACRO set.
;
;	EXTRN	IN_7220_GDC_PORT:NEAR	; (far) in  port 7220 GDC.
;	EXTRN	OUT_7220_GDC_PORT:NEAR	; (far) out port 7220 GDC.
;	EXTRN	IN_8259_PORT:NEAR	; (far) in  port 8259.
;	EXTRN	OUT_8259_PORT:NEAR	; (far) out port 8259.
;	EXTRN	IN_8255_PORT:NEAR	; (far) in  prot 8255.
;	EXTRN	OUT_8255_PORT:NEAR	; (far) out prot 8255.
;	EXTRN	IN_8251_PORT:NEAR	; (far) in  prot 8251.
;	EXTRN	OUT_8251_PORT:NEAR	; (far) out prot 8251.
;	;
;	IN_GDC	MACRO	AA,NUM
;	;same;	IN	AL,NUM
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	IN_7220_GDC_PORT	; (far) in  port 7220 GDC.
;		POP	DX
;		ENDM
;	;
;	OUTGDC	MACRO	NUM,AA
;	;same;	OUT	NUM,AL
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	OUT_7220_GDC_PORT	; (far) out port 7220 GDC.
;		POP	DX
;		ENDM
;	;
;	IN_8259	MACRO	AA,NUM
;	;same;	IN	AL,NUM
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	IN_8259_PORT		; (far) in  port 8259.
;		POP	DX
;		ENDM
;	;
;	OUT8259	MACRO	NUM,AA
;	;same;	OUT	NUM,AL
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	OUT_8259_PORT		; (far) out port 8259.
;		POP	DX
;		ENDM
;	;
;	IN_8255	MACRO	AA,NUM
;	;same;	IN	AL,NUM
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	IN_8255_PORT		; (far) in  prot 8255.
;		POP	DX
;		ENDM
;	;
;	OUT8255	MACRO	NUM,AA
;	;same;	OUT	NUM,AL
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	OUT_8255_PORT		; (far) out prot 8255.
;		POP	DX
;		ENDM
;	;
;	IN_8251	MACRO	AA,NUM
;	;same;	IN	AL,NUM
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	IN_8251_PORT		; (far) in  prot 8251.
;		POP	DX
;		ENDM
;	;
;	OUT8251	MACRO	NUM,AA
;	;same;	OUT	NUM,AL
;		PUSH	DX
;		MOV	DX,NUM			;
;		CALL	OUT_8251_PORT		; (far) out prot 8251.
;		POP	DX
;		ENDM
;
;
;
; public subroutine.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE

PUBLIC	IN_7220_GDC_PORT	; (far) in  port 7220 GDC.
PUBLIC	OUT_7220_GDC_PORT	; (far) out port 7220 GDC.
PUBLIC	IN_8259_PORT		; (far) in  port 8259.
PUBLIC	OUT_8259_PORT		; (far) out port 8259.
PUBLIC	IN_8255_PORT		; (far) in  prot 8255.
PUBLIC	OUT_8255_PORT		; (far) out prot 8255.
PUBLIC	IN_8251_PORT		; (far) in  prot 8251.
PUBLIC	OUT_8251_PORT		; (far) out prot 8251.

PACH_LABEL	DB	"IOPORTver0.0"

;	in  port 7220 GDC.
;	-I- DX : port number.
;	-O- AL : input data.

IN_7220_GDC_PORT	PROC	NEAR
	IN	AL,DX
	RET
IN_7220_GDC_PORT	ENDP

;	out port 7220 GDC.
;	-I- DX : port number.
;	    AL : output data.

OUT_7220_GDC_PORT	PROC	NEAR
	OUT	DX,AL
	RET
OUT_7220_GDC_PORT	ENDP

;	in  port 8259.
;	-I- DX : port number.
;	-O- AL : input data.

IN_8259_PORT		PROC	NEAR
	IN	AL,DX
	RET
IN_8259_PORT		ENDP

;	out port 8259.
;	-I- DX : port number.
;	    AL : output data.

OUT_8259_PORT		PROC	NEAR
	OUT	DX,AL
	RET
OUT_8259_PORT		ENDP

;	in  prot 8255.
;	-I- DX : port number.
;	-O- AL : input data.

IN_8255_PORT		PROC	NEAR
	IN	AL,DX
	RET
IN_8255_PORT		ENDP

;	out prot 8255.
;	-I- DX : port number.
;	    AL : output data.

OUT_8255_PORT		PROC	NEAR
	OUT	DX,AL
	RET
OUT_8255_PORT		ENDP

;	in  prot 8251.
;	-I- DX : port number.
;	-O- AL : input data.

IN_8251_PORT		PROC	NEAR
	IN	AL,DX
	RET
IN_8251_PORT		ENDP

;	out prot 8251.
;	-I- DX : port number.
;	    AL : output data.

OUT_8251_PORT		PROC	NEAR
	OUT	DX,AL
	RET
OUT_8251_PORT		ENDP

CODE	ENDS

	END
;
;	end of "IOPORT.ASM"
;
