; "MIDTXT.ASM" 1990/07/08 R.H PC-9801UV11 make by R.H 1990
;
;	mid size text vram put routine.
;
;
;	SEGVT0:WORD	; text put vram segment plean 0.
;	SEGVT1:WORD	; text put vram segment plean 1.
;	SEGVT2:WORD	; text put vram segment plean 2.
;	SEGVT3:WORD	; text put vram segment plean 3.
;
;


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	MDTPRN			; MID string. (null=end of string)


ADDWIDTH	EQU	80	; next line add.


; MID string.
; -i- DS:SI   : string. (null=end of string)
;     AX      : location x point.
;     BX      : location y point.

MDTPRN	PROC	NEAR
	CALL	MDT_LOCATE		; vram location.
MDTPRN_LOOP:
	LODSB				; get char.
	CMP	AL,0			; end of string.
	JE	MDTPRN_EXIT		;
	CALL	MDT_GETFONT_ADRS	; get font adrs.
	CALL	MDT_VRMPUT		; put vram.

	INC	LOCATE_ADRS		; location vram address. next+.

	JMP	MDTPRN_LOOP		;
MDTPRN_EXIT:
	RET
MDTPRN	ENDP


;	vram location.
;	-I- AX          : location x point.
;	    BX          : location y point.
;	-O- LOCATE_ADRS : location vram address.

MDT_LOCATE	PROC	NEAR
	SHL	BX,1			;
	SHL	BX,1			;
	SHL	BX,1			;
	SHL	BX,1			;
	MOV	DX,BX			;
	SHL	BX,1			;
	SHL	BX,1			;
	ADD	BX,DX			;  y = bx * 80

	ADD	BX,ADDWIDTH		; 1 LINE shift

	ADD	AX,BX			; address = x + y
	MOV	LOCATE_ADRS,AX		; location vram address.
	RET
MDT_LOCATE	ENDP



;	get font adrs.
;	-I- AL : character code.
;	-O- BX : font address.

MDT_GETFONT_ADRS	PROC	NEAR
	MOV	BL,AL		; character code.
	MOV	BH,0		;

	SUB	BL,20H		; + 20H (space code)
	SHL	BX,1		;
	SHL	BX,1		;
	SHL	BX,1		; * 8

	ADD	BX,OFFSET FONT_TABLE
	RET
MDT_GETFONT_ADRS	ENDP



;	put vram.
;	-I- LOCATE_ADRS : location vram address.
;	    BX : font address.

MDT_VRMPUT	PROC	NEAR
	MOV	BP,SI		; save string pointer.

	MOV	AX,SEGVT0	; text put vram segment plean 0.
	MOV	ES,AX		;
	TEST	FONT_COLOR,0001B ; font color.
	JZ	MDT_VRMPUT_01	;
	CALL	MDT_PUTOR	; vram put 1 plean OR.
	JMP	MDT_VRMPUT_02	;
MDT_VRMPUT_01:			;
	CALL	MDT_PUTMASK	; vram put 1 plean MASK.
MDT_VRMPUT_02:			;

	MOV	AX,SEGVT1	; text put vram segment plean 1.
	MOV	ES,AX		;
	TEST	FONT_COLOR,0010B ; font color.
	JZ	MDT_VRMPUT_11	;
	CALL	MDT_PUTOR	; vram put 1 plean OR.
	JMP	MDT_VRMPUT_12	;
MDT_VRMPUT_11:			;
	CALL	MDT_PUTMASK	; vram put 1 plean MASK.
MDT_VRMPUT_12:			;

	MOV	AX,SEGVT2	; text put vram segment plean 2.
	MOV	ES,AX		;
	TEST	FONT_COLOR,0100B ; font color.
	JZ	MDT_VRMPUT_21	;
	CALL	MDT_PUTOR	; vram put 1 plean OR.
	JMP	MDT_VRMPUT_22	;
MDT_VRMPUT_21:			;
	CALL	MDT_PUTMASK	; vram put 1 plean MASK.
MDT_VRMPUT_22:			;

	MOV	AX,SEGVT3	; text put vram segment plean 3.
	MOV	ES,AX		;
	TEST	FONT_COLOR,1000B ; font color.
	JZ	MDT_VRMPUT_31	;
	CALL	MDT_PUTOR	; vram put 1 plean OR.
	JMP	MDT_VRMPUT_32	;
MDT_VRMPUT_31:			;
	CALL	MDT_PUTMASK	; vram put 1 plean MASK.
MDT_VRMPUT_32:			;

	MOV	SI,BP		; load string pointer.
	RET
MDT_VRMPUT	ENDP


;	vram put 1 plean OR.
;	-I- ES : put vram seggment.
;	    BX : font address.
;	    LOCATE_ADRS : location vram address.

MDT_PUTOR	PROC	NEAR
	MOV	SI,BX		; font address.
	MOV	DI,LOCATE_ADRS	; location vram address.

	MOV	CX,8		;
MDT_PUTOR2:			;
	LODSB			; get 1 line.
	OR	ES:[DI],AL	; OR put 1 line.
	ADD	DI,ADDWIDTH	; next line add.
	OR	ES:[DI],AL	; OR put 1 line.
	ADD	DI,ADDWIDTH	; next line add.
	LOOP	MDT_PUTOR2	;
	RET
MDT_PUTOR	ENDP


;	vram put 1 plean MASK.
;	-I- ES : put vram seggment.
;	    BX : font address.
;	    LOCATE_ADRS : location vram address.

MDT_PUTMASK	PROC	NEAR
	MOV	SI,BX		; font address.
	MOV	DI,LOCATE_ADRS	; location vram address.

	MOV	CX,8		;
MDT_PUTMASK2:			;
	LODSB			; get 1 line.
	NOT	AL		;
	AND	ES:[DI],AL	; OR put 1 line.
	ADD	DI,ADDWIDTH	; next line add.
	AND	ES:[DI],AL	; OR put 1 line.
	ADD	DI,ADDWIDTH	; next line add.
	LOOP	MDT_PUTMASK2	;
	RET
MDT_PUTMASK	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	FONT_TABLE:BYTE		; FONT1.INC character pattan 1.
EXTRN	FONT_COLOR:WORD		; font color.

EXTRN	SEGVT0:WORD	; text put vram segment plean 0.
EXTRN	SEGVT1:WORD	; text put vram segment plean 1.
EXTRN	SEGVT2:WORD	; text put vram segment plean 2.
EXTRN	SEGVT3:WORD	; text put vram segment plean 3.

LOCATE_ADRS	DW	0		; location vram address.

DATA	ENDS

	END
;
;	end of "MIDTXT.ASM"
;
