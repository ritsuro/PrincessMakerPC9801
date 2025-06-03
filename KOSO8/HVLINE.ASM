; "HVLINE.ASM" 1990/04/18 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.
;
;	ècâ°ÉâÉCÉìï`âÊ
;
;	SSDES0			; visual data segment plean 0
;	SSDES1			; visual data segment plean 1
;	SSDES2			; visual data segment plean 2
;	SSDES3			; visual data segment plean 3
;
;	VX1:WORD		; source point x1.
;	VY1:WORD		; source point y1.
;	VX2:WORD		; destination point x3.
;	VY2:WORD		; destination point y3.
;
;

ADDWIDTH	EQU	80	; éüÇÃÉâÉCÉìÉAÉhÉåÉXåvéZóp

CODE	SEGMENT	PUBLIC	'CODE'
	
	ASSUME	CS:CODE,DS:CODE

PUBLIC	DLINEH			; êÖïΩÉâÉCÉìï`âÊ
PUBLIC	DLINEV			; êÇíºÉâÉCÉìï`âÊ

;	êÖïΩÉâÉCÉìï`âÊ
;	-I- VX1 : start dot point x1.
;	    VX2 : end dot point x2.
;	    VY1 : line hight y1.
;	    CX  : line width.
;	    VCOL: color.

DLINEH	PROC	NEAR
	CMP	CX,0			;
	JG	DLINEH0			;
	RET				;
DLINEH0:
	MOV	DI,VY1			; line hight y1.
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	BP,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,BP			; DI = VY1 * 80 (start address)

	MOV	BX,VX1			; start line point X1.
	MOV	DX,VX2			; end line point X2.

	CMP	BX,DX			;
	JB	DLINEH1			; BX=start point X.
	XCHG	BX,DX			; DX=end point X.
DLINEH1:				;

	PUSH	CX			; CX=line width.

	MOV	CX,BX			; start point.
	AND	CX,111B			; bit shift.(dot point)
	MOV	AL,0FFH			; line start pattan.
	SHR	AL,CL			; AL=start dot shift.

	MOV	AH,0			; line end pattan.
	MOV	CX,DX			; end point.
	AND	CX,111B			; bit shift.(dot point)
	JZ	DLINEH2			;
	DEC	CX			;
	MOV	AH,080H			; line end pattan.
	SAR	AH,CL			; AH=end dot shift.
DLINEH2:
	MOV	CX,DX			; DX=end point X.
	SHR	CX,1			;
	SHR	CX,1			;
	SHR	CX,1			; CX=end point X byte.
	MOV	BP,BX			; BX=start point X.
	SHR	BP,1			;
	SHR	BP,1			;
	SHR	BP,1			; BP=start point X byte.
	CMP	CX,BP			;
	JNE	DLINEH4			; goto draw line!

					; AL=start pattan.
	AND	AL,AH			; AH=end pattan.
					; AL=put pattan.
	ADD	DI,BP			; DI = start address.

	POP	CX			; CX=line width.
DLINEH3:				;
	MOV	BX,VCOL			; BX=color.
	MOV	DX,SSDES0		; ES=visual data segment plean 0
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES1		; ES=visual data segment plean 1
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES2		; ES=visual data segment plean 2
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES3		; ES=visual data segment plean 3
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	ADD	DI,ADDWIDTH		; next address.
	LOOP	DLINEH3			;
	RET				;

DLINEH4:				;

	ADD	DI,BP			; DI = start address.
	MOV	SI,DI			; save offset.

	SUB	CX,BP			; BP=line length.
	MOV	BP,CX			;

	POP	CX			; CX=line width.
	PUSH	CX			;
DLINEH41:				;
	MOV	BX,VCOL			; BX=color.
	MOV	DX,SSDES0		; ES=visual data segment plean 0
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES1		; ES=visual data segment plean 1
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES2		; ES=visual data segment plean 2
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES3		; ES=visual data segment plean 3
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	ADD	DI,ADDWIDTH		; next address.
	LOOP	DLINEH41		;

	POP	CX			; CX=line width.
	PUSH	CX			;
	MOV	AL,AH			; AL=AH=end pattan.
	MOV	DI,SI			; load offset.
	ADD	DI,BP			; BP=end point X byte.
DLINEH42:				;
	MOV	BX,VCOL			; BX=color.
	MOV	DX,SSDES0		; ES=visual data segment plean 0
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES1		; ES=visual data segment plean 1
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES2		; ES=visual data segment plean 2
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	MOV	DX,SSDES3		; ES=visual data segment plean 3
	MOV	ES,DX			;
	CALL	DLINEH1DOT		; dot pattan put.
	ADD	DI,ADDWIDTH		; next address.
	LOOP	DLINEH42		;

	POP	CX			; CX=line width.
	INC	SI			;
	DEC	BP			;
DLINEH43:				;
	PUSH	CX			;
	MOV	BX,VCOL			; BX=color.
	MOV	DX,SSDES0		; ES=visual data segment plean 0
	MOV	ES,DX			;
	MOV	DI,SI			;
	MOV	CX,BP			; BP=(end-start)-1 
	CALL	DLINEH1LINE		; line pattan put.
	MOV	DX,SSDES1		; ES=visual data segment plean 1
	MOV	ES,DX			;
	MOV	DI,SI			;
	MOV	CX,BP			; BP=(end-start)-1 
	CALL	DLINEH1LINE		; line pattan put.
	MOV	DX,SSDES2		; ES=visual data segment plean 2
	MOV	ES,DX			;
	MOV	DI,SI			;
	MOV	CX,BP			; BP=(end-start)-1 
	CALL	DLINEH1LINE		; line pattan put.
	MOV	DX,SSDES3		; ES=visual data segment plean 3
	MOV	ES,DX			;
	MOV	DI,SI			;
	MOV	CX,BP			; BP=(end-start)-1 
	CALL	DLINEH1LINE		; line pattan put.
	ADD	SI,ADDWIDTH		; next address.
	POP	CX			;
	LOOP	DLINEH43		;

	RET
					; line pattan.
					; -I/O- BX lower bit : color.
					;       ES : vram plean.
					;       DI : start address
					;       CX : line length(byte).
DLINEH1LINE:				; line pattan put.
	SHR	BX,1			; BX=color.
	JNB	DLINEH40_AND		;
DLINEH40_OR:				;
	MOV	AL,0FFH			; line pattan.
	REP	STOSB			; line put.
	JMP	DLINEH40_END		;
DLINEH40_AND:				;
	MOV	AL,0			; line pattan.
	REP	STOSB			; line put.
DLINEH40_END:				;
	RET
					; dot pattan put.
					; -I-   AL=put pattan.
					; -I/O- BX lower bit : color.
					;       ES : vram plean.
					;       DI : start address
DLINEH1DOT:				; dot pattan put.
	SHR	BX,1			; BX=color.
	JNB	DLINEH50_AND		;
DLINEH50_OR:				;
	OR	ES:[DI],AL		;
	RET				;
DLINEH50_AND:				;
	NOT	AL			;
	AND	ES:[DI],AL		;
	NOT	AL			;
	RET				;
DLINEH	ENDP



;	êÇíºÉâÉCÉìï`âÊ
;	-I- VX1 : line dot point x.
;	    VY1 : start line point y1.
;	    VY2 : end line point y2.
;	    CX  : line width.
;	    VCOL: color.

DLINEV	PROC	NEAR
	PUSH	CX
	CMP	CX,0			;
	JG	DLINEV0			;
	RET
DLINEV0:
	MOV	AX,08000H		; left side dot.
	CMP	CX,1			;
	JE	DLINEV1			;
	DEC	CX			;
	SAR	AX,CL			; line width.
DLINEV1:
	MOV	CX,VX1			; line dot point x.
	AND	CX,111B			; bit shift.(dot point)
	SHR	AX,CL			; dot shift.
	XCHG	AH,AL			; AX=line pattan.

	MOV	BX,VY1			; start line point y1.
	MOV	DX,VY2			; end line point y2.

	CMP	BX,DX			;
	JB	DLINEV2			; BX=start point Y.
	XCHG	BX,DX			; DX=end point Y.
DLINEV2:
	MOV	DI,BX			; BX=start point Y.
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	BP,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,BP			; DI = VY1 * 80 (start address)

	MOV	BP,VX1			; BP = X offset.
	SHR	BP,1			;
	SHR	BP,1			;
	SHR	BP,1			; / 8

	ADD	DI,BP			; start line.

	MOV	CX,DX			; DX=end point Y.
	SUB	CX,BX			; BX=start point Y.
	INC	CX			;

	MOV	BX,VCOL			; BX=color.

	MOV	SI,DI			;

	MOV	DI,SI			;
	MOV	DX,SSDES0		; ES=visual data segment plean 0
	MOV	ES,DX			;
	CALL	DLINEV1LINE		;

	MOV	DI,SI			;
	MOV	DX,SSDES1		; ES=visual data segment plean 1
	MOV	ES,DX			;
	CALL	DLINEV1LINE		;

	MOV	DI,SI			;
	MOV	DX,SSDES2		; ES=visual data segment plean 2
	MOV	ES,DX			;
	CALL	DLINEV1LINE		;

	MOV	DI,SI			;
	MOV	DX,SSDES3		; ES=visual data segment plean 3
	MOV	ES,DX			;
	CALL	DLINEV1LINE		;

	POP	CX
	RET
					; -I/O- BX lower bit : color.
					;       ES : vram plean.
DLINEV1LINE:				;       DI : start address
	MOV	BP,ADDWIDTH		; BP=next address.
	PUSH	CX			;
	SHR	BX,1			; BX=color.
	JNB	DLINEV40_AND		;
DLINEV40_OR:				;
	OR	ES:[DI],AX		;
	ADD	DI,BP			; BP=next address.
	LOOP	DLINEV40_OR		;
	JMP	DLINEV40_END		;
DLINEV40_AND:				;
	NOT	AX			;
DLINEV40_AND2:				;
	AND	ES:[DI],AX		;
	ADD	DI,BP			; BP=next address.
	LOOP	DLINEV40_AND2		;
	NOT	AX			;
DLINEV40_END:				;
	POP	CX			;
	RET
DLINEV	ENDP


; ****************************************************
;	DATA
; ****************************************************
	EVEN

EXTRN	SSDES0:WORD		; visual data segment plean 0
EXTRN	SSDES1:WORD		; visual data segment plean 1
EXTRN	SSDES2:WORD		; visual data segment plean 2
EXTRN	SSDES3:WORD		; visual data segment plean 3

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.
EXTRN	VCOL:WORD		; color.

CODE	ENDS

	END
;
;	end of "HVLINE.ASM"
;
