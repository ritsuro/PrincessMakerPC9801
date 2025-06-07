; "ADVMOV.ASM" 1989/3/21 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.

;
;	SSDES0			; visual data segment plean 0
;	SSDES1			; visual data segment plean 1
;	SSDES2			; visual data segment plean 2
;	SSDES3			; visual data segment plean 3
;
;	SSSOU0			; visual data segment plean 0
;	SSSOU1			; visual data segment plean 1
;	SSSOU2			; visual data segment plean 2
;	SSSOU3			; visual data segment plean 3
;
;	VX1:WORD		; source point x1.
;	VY1:WORD		; source point y1.
;	VX2:WORD		; length x2.
;	VY2:WORD		; length y2.
;	VX3:WORD		; destination point x3.
;	VY3:WORD		; destination point y3.
;

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	MOVEVR		; vram to vram move.
;*NON*;	PUBLIC	MOVRVR		; vram to vram OR.
;*NON*;	PUBLIC	MOVAVR		; vram to vram AND.
;*NON*;	PUBLIC	MOVHVR		; vram to vram hi-speed move.

; vram to vram move.
; -i- SSSOU0-2 : source data segment.
;     SSDES0-2 : destination data segment.
;     VX1,VY1  : source point.
;     VX2,VY2  : data size.
;     VX3,VY3  : dest point.

MOVEVR	PROC	NEAR
	CMP	WORD PTR VX2,0	;
	JZ	MOVEVR99	; if vx2=0 or vy2=0 then exit.
	CMP	WORD PTR VY2,0	;
	JZ	MOVEVR99	;
	JMP	MOVEVR00	;
MOVEVR99:			;
	RET			;
MOVEVR00:

	MOV	BX,VY1		;
	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,VX1		;

	MOV	DX,VY3		;
	SHL	DX,1		;
	SHL	DX,1		;  destination point.
	SHL	DX,1		;
	SHL	DX,1		;  dx = vy3 * 80 + vx3
	MOV	AX,DX		;
	SHL	DX,1		;
	SHL	DX,1		;
	ADD	DX,AX		;
	ADD	DX,VX3		;

	PUSH	DS

	MOV	AX,SSDES0	;
	MOV	CS:SSD0,AX	; visual data segment plean 0
	MOV	AX,SSDES1	;
	MOV	CS:SSD1,AX	; visual data segment plean 1
	MOV	AX,SSDES2	;
	MOV	CS:SSD2,AX	; visual data segment plean 2
	MOV	AX,SSDES3	;
	MOV	CS:SSD3,AX	; visual data segment plean 3

	MOV	AX,SSSOU0	;
	MOV	CS:SSS0,AX	; visual data segment plean 0
	MOV	AX,SSSOU1	;
	MOV	CS:SSS1,AX	; visual data segment plean 1
	MOV	AX,SSSOU2	;
	MOV	CS:SSS2,AX	; visual data segment plean 2
	MOV	AX,SSSOU3	;
	MOV	CS:SSS3,AX	; visual data segment plean 3

	MOV	AX,VX2		; x counter.
	MOV	BP,VY2		; y counter.
MOVEVR1:
	MOV	CX,CS:SSD0	; dest.
	MOV	ES,CX		;
	MOV	CX,CS:SSS0	; source.
	MOV	DS,CX		;

	MOV	SI,BX		; source.
	MOV	DI,DX		; dest.
	MOV	CX,AX		; x counter.
	REP	MOVSB		; moving!

	MOV	CX,CS:SSD1	; dest.
	MOV	ES,CX		;
	MOV	CX,CS:SSS1	; source.
	MOV	DS,CX		;

	MOV	SI,BX		; source.
	MOV	DI,DX		; dest.
	MOV	CX,AX		; x counter.
	REP	MOVSB		; moving!

	MOV	CX,CS:SSD2	; dest.
	MOV	ES,CX		;
	MOV	CX,CS:SSS2	; source.
	MOV	DS,CX		;

	MOV	SI,BX		; source.
	MOV	DI,DX		; dest.
	MOV	CX,AX		; x counter.
	REP	MOVSB		; moving!

	MOV	CX,CS:SSD3	; dest.
	MOV	ES,CX		;
	MOV	CX,CS:SSS3	; source.
	MOV	DS,CX		;

	MOV	SI,BX		; source.
	MOV	DI,DX		; dest.
	MOV	CX,AX		; x counter.
	REP	MOVSB		; moving!


	ADD	BX,80		; next source.
	ADD	DX,80		; next dest.

	DEC	BP		;
	JNZ	MOVEVR1		; loop next.

	POP	DS

	RET

MOVEVR	ENDP

	SSD0	DW	0	; visual data segment plean 0
	SSD1	DW	0	; visual data segment plean 1
	SSD2	DW	0	; visual data segment plean 2
	SSD3	DW	0	; visual data segment plean 3

	SSS0	DW	0	; visual data segment plean 0
	SSS1	DW	0	; visual data segment plean 1
	SSS2	DW	0	; visual data segment plean 2
	SSS3	DW	0	; visual data segment plean 3

;*NON*;
;*NON*;; vram to vram OR.
;*NON*;; -i- SSSOU0-2 : source data segment.
;*NON*;;     SSDES0-2 : destination data segment.
;*NON*;;     VX1,VY1  : source point.
;*NON*;;     VX2,VY2  : data size.
;*NON*;;     VX3,VY3  : dest point.
;*NON*;
;*NON*;MOVRVR	PROC	NEAR
;*NON*;	CMP	WORD PTR VX2,0	;
;*NON*;	JZ	MOVRVR99	; if vx2=0 or vy2=0 then exit.
;*NON*;	CMP	WORD PTR VY2,0	;
;*NON*;	JZ	MOVRVR99	;
;*NON*;	JMP	MOVRVR00	;
;*NON*;MOVRVR99:			;
;*NON*;	RET			;
;*NON*;MOVRVR00:
;*NON*;
;*NON*;	MOV	BX,VY1		;
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;  source point.
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;  bx = vy1 * 80 + vx1
;*NON*;	MOV	AX,BX		;
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;
;*NON*;	ADD	BX,AX		;
;*NON*;	ADD	BX,VX1		;
;*NON*;
;*NON*;	MOV	DX,VY3		;
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;  destination point.
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;  dx = vy3 * 80 + vx3
;*NON*;	MOV	AX,DX		;
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;
;*NON*;	ADD	DX,AX		;
;*NON*;	ADD	DX,VX3		;
;*NON*;
;*NON*;	PUSH	DS
;*NON*;
;*NON*;	MOV	AX,SSDES0	;
;*NON*;	MOV	CS:SSD0,AX	; visual data segment plean 0
;*NON*;	MOV	AX,SSDES1	;
;*NON*;	MOV	CS:SSD1,AX	; visual data segment plean 1
;*NON*;	MOV	AX,SSDES2	;
;*NON*;	MOV	CS:SSD2,AX	; visual data segment plean 2
;*NON*;	MOV	AX,SSDES3	;
;*NON*;	MOV	CS:SSD3,AX	; visual data segment plean 3
;*NON*;
;*NON*;	MOV	AX,SSSOU0	;
;*NON*;	MOV	CS:SSS0,AX	; visual data segment plean 0
;*NON*;	MOV	AX,SSSOU1	;
;*NON*;	MOV	CS:SSS1,AX	; visual data segment plean 1
;*NON*;	MOV	AX,SSSOU2	;
;*NON*;	MOV	CS:SSS2,AX	; visual data segment plean 2
;*NON*;	MOV	AX,SSSOU3	;
;*NON*;	MOV	CS:SSS3,AX	; visual data segment plean 3
;*NON*;
;*NON*;	MOV	AX,VX2		; x counter.
;*NON*;	MOV	BP,VY2		; y counter.
;*NON*;MOVRVR1:
;*NON*;	MOV	CX,CS:SSD0	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS0	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVRVR21:
;*NON*;	LODSB			;
;*NON*;	OR	ES:[DI],AL	; OR
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVRVR21	;
;*NON*;	POP	AX
;*NON*;
;*NON*;	MOV	CX,CS:SSD1	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS1	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVRVR22:
;*NON*;	LODSB			;
;*NON*;	OR	ES:[DI],AL	; OR
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVRVR22	;
;*NON*;	POP	AX
;*NON*;
;*NON*;	MOV	CX,CS:SSD2	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS2	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVRVR23:
;*NON*;	LODSB			;
;*NON*;	OR	ES:[DI],AL	; OR
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVRVR23	;
;*NON*;	POP	AX
;*NON*;
;*NON*;	MOV	CX,CS:SSD3	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS3	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVRVR24:
;*NON*;	LODSB			;
;*NON*;	OR	ES:[DI],AL	; OR
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVRVR24	;
;*NON*;	POP	AX
;*NON*;
;*NON*;
;*NON*;	ADD	BX,80		; next source.
;*NON*;	ADD	DX,80		; next dest.
;*NON*;
;*NON*;	DEC	BP		;
;*NON*;	JNZ	MOVRVR1		; loop next.
;*NON*;
;*NON*;	POP	DS
;*NON*;
;*NON*;	RET
;*NON*;
;*NON*;MOVRVR	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;; vram to vram AND.
;*NON*;; -i- SSSOU0-2 : source data segment.
;*NON*;;     SSDES0-2 : destination data segment.
;*NON*;;     VX1,VY1  : source point.
;*NON*;;     VX2,VY2  : data size.
;*NON*;;     VX3,VY3  : dest point.
;*NON*;
;*NON*;MOVAVR	PROC	NEAR
;*NON*;	CMP	WORD PTR VX2,0	;
;*NON*;	JZ	MOVAVR99	; if vx2=0 or vy2=0 then exit.
;*NON*;	CMP	WORD PTR VY2,0	;
;*NON*;	JZ	MOVAVR99	;
;*NON*;	JMP	MOVAVR00	;
;*NON*;MOVAVR99:			;
;*NON*;	RET			;
;*NON*;MOVAVR00:
;*NON*;
;*NON*;	MOV	BX,VY1		;
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;  source point.
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;  bx = vy1 * 80 + vx1
;*NON*;	MOV	AX,BX		;
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;
;*NON*;	ADD	BX,AX		;
;*NON*;	ADD	BX,VX1		;
;*NON*;
;*NON*;	MOV	DX,VY3		;
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;  destination point.
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;  dx = vy3 * 80 + vx3
;*NON*;	MOV	AX,DX		;
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;
;*NON*;	ADD	DX,AX		;
;*NON*;	ADD	DX,VX3		;
;*NON*;
;*NON*;	PUSH	DS
;*NON*;
;*NON*;	MOV	AX,SSDES0	;
;*NON*;	MOV	CS:SSD0,AX	; visual data segment plean 0
;*NON*;	MOV	AX,SSDES1	;
;*NON*;	MOV	CS:SSD1,AX	; visual data segment plean 1
;*NON*;	MOV	AX,SSDES2	;
;*NON*;	MOV	CS:SSD2,AX	; visual data segment plean 2
;*NON*;	MOV	AX,SSDES3	;
;*NON*;	MOV	CS:SSD3,AX	; visual data segment plean 3
;*NON*;
;*NON*;	MOV	AX,SSSOU0	;
;*NON*;	MOV	CS:SSS0,AX	; visual data segment plean 0
;*NON*;	MOV	AX,SSSOU1	;
;*NON*;	MOV	CS:SSS1,AX	; visual data segment plean 1
;*NON*;	MOV	AX,SSSOU2	;
;*NON*;	MOV	CS:SSS2,AX	; visual data segment plean 2
;*NON*;	MOV	AX,SSSOU3	;
;*NON*;	MOV	CS:SSS3,AX	; visual data segment plean 3
;*NON*;
;*NON*;	MOV	AX,VX2		; x counter.
;*NON*;	MOV	BP,VY2		; y counter.
;*NON*;MOVAVR1:
;*NON*;	MOV	CX,CS:SSD0	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS0	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVAVR21:
;*NON*;	LODSB			;
;*NON*;	AND	ES:[DI],AL	; AND
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVAVR21	;
;*NON*;	POP	AX
;*NON*;
;*NON*;	MOV	CX,CS:SSD1	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS1	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVAVR22:
;*NON*;	LODSB			;
;*NON*;	AND	ES:[DI],AL	; AND
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVAVR22	;
;*NON*;	POP	AX
;*NON*;
;*NON*;	MOV	CX,CS:SSD2	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS2	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVAVR23:
;*NON*;	LODSB			;
;*NON*;	AND	ES:[DI],AL	; AND
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVAVR23	;
;*NON*;	POP	AX
;*NON*;
;*NON*;	MOV	CX,CS:SSD3	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS3	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	PUSH	AX
;*NON*;MOVAVR24:
;*NON*;	LODSB			;
;*NON*;	AND	ES:[DI],AL	; AND
;*NON*;	INC	DI		;
;*NON*;	LOOP	MOVAVR24	;
;*NON*;	POP	AX
;*NON*;
;*NON*;
;*NON*;	ADD	BX,80		; next source.
;*NON*;	ADD	DX,80		; next dest.
;*NON*;
;*NON*;	DEC	BP		;
;*NON*;	JNZ	MOVAVR1		; loop next.
;*NON*;
;*NON*;	POP	DS
;*NON*;
;*NON*;	RET
;*NON*;
;*NON*;MOVAVR	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;
;*NON*;; v-sync wait.
;*NON*;
;*NON*;VSYNC_WAIT	MACRO
;*NON*;	LOCAL	L1,L2
;*NON*;	PUSH	AX
;*NON*;L1:
;*NON*;	IN	AL,0A0H		; V-SYNC
;*NON*;	TEST	AL,00100000B	;
;*NON*;	JZ	L1		;
;*NON*;
;*NON*;	MOV	CX,6		;
;*NON*;	LOOP	$		; CPU 54+5 clock wait.
;*NON*;L2:
;*NON*;	IN	AL,0A0H		; V-SYNC
;*NON*;	TEST	AL,00100000B	;
;*NON*;	JNZ	L2		;
;*NON*;
;*NON*;	POP	AX
;*NON*;ENDM
;*NON*;
;*NON*;
;*NON*;
;*NON*;; vram to vram hi-speed move.
;*NON*;; -i- SSSOU0-2 : source data segment.
;*NON*;;     SSDES0-2 : destination data segment.
;*NON*;;     VY1  : source point.
;*NON*;;     VY2  : data size.
;*NON*;;     VY3  : dest point.
;*NON*;
;*NON*;MOVHVR	PROC	NEAR
;*NON*;	CMP	WORD PTR VY2,0	;
;*NON*;	JZ	MOVHVR99	; if  vy2=0 then exit.
;*NON*;	JMP	MOVHVR00	;
;*NON*;MOVHVR99:			;
;*NON*;	RET			;
;*NON*;MOVHVR00:
;*NON*;
;*NON*;	MOV	BX,VY1		;
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;  source point.
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;  bx = vy1 * 80
;*NON*;	MOV	AX,BX		;
;*NON*;	SHL	BX,1		;
;*NON*;	SHL	BX,1		;
;*NON*;	ADD	BX,AX		;
;*NON*;
;*NON*;	MOV	DX,VY3		;
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;  destination point.
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;  dx = vy3 * 80
;*NON*;	MOV	AX,DX		;
;*NON*;	SHL	DX,1		;
;*NON*;	SHL	DX,1		;
;*NON*;	ADD	DX,AX		;
;*NON*;
;*NON*;	PUSH	DS
;*NON*;
;*NON*;	MOV	AX,SSDES0	;
;*NON*;	MOV	CS:SSD0,AX	; visual data segment plean 0
;*NON*;	MOV	AX,SSDES1	;
;*NON*;	MOV	CS:SSD1,AX	; visual data segment plean 1
;*NON*;	MOV	AX,SSDES2	;
;*NON*;	MOV	CS:SSD2,AX	; visual data segment plean 2
;*NON*;	MOV	AX,SSDES3	;
;*NON*;	MOV	CS:SSD3,AX	; visual data segment plean 3
;*NON*;
;*NON*;	MOV	AX,SSSOU0	;
;*NON*;	MOV	CS:SSS0,AX	; visual data segment plean 0
;*NON*;	MOV	AX,SSSOU1	;
;*NON*;	MOV	CS:SSS1,AX	; visual data segment plean 1
;*NON*;	MOV	AX,SSSOU2	;
;*NON*;	MOV	CS:SSS2,AX	; visual data segment plean 2
;*NON*;	MOV	AX,SSSOU3	;
;*NON*;	MOV	CS:SSS3,AX	; visual data segment plean 3
;*NON*;;*NON*;
;*NON*;;*NON*;	MOV	AX,VY2		; x counter.
;*NON*;;*NON*;	SHL	AX,1		;  source point.
;*NON*;;*NON*;	SHL	AX,1		;
;*NON*;;*NON*;	SHL	AX,1		;  ax = vy1 * 40
;*NON*;;*NON*;	MOV	CX,AX		;
;*NON*;;*NON*;	SHL	AX,1		;
;*NON*;;*NON*;	SHL	AX,1		;
;*NON*;;*NON*;	ADD	AX,CX		;
;*NON*;;*NON*;
;*NON*;	MOV	AX,40		; x counter.
;*NON*;	MOV	BP,VY2		; y counter.
;*NON*;MOVHVR1:
;*NON*;	MOV	CX,CS:SSD0	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS0	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	REP	MOVSW		; moving!
;*NON*;
;*NON*;	MOV	CX,CS:SSD1	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS1	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	REP	MOVSW		; moving!
;*NON*;
;*NON*;	MOV	CX,CS:SSD2	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS2	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	REP	MOVSW		; moving!
;*NON*;
;*NON*;	MOV	CX,CS:SSD3	; dest.
;*NON*;	MOV	ES,CX		;
;*NON*;	MOV	CX,CS:SSS3	; source.
;*NON*;	MOV	DS,CX		;
;*NON*;
;*NON*;	MOV	SI,BX		; source.
;*NON*;	MOV	DI,DX		; dest.
;*NON*;	MOV	CX,AX		; x counter.
;*NON*;	REP	MOVSW		; moving!
;*NON*;
;*NON*;	ADD	BX,80		; next source.
;*NON*;	ADD	DX,80		; next dest.
;*NON*;
;*NON*;	DEC	BP		;
;*NON*;	JNZ	MOVHVR1		; loop next.
;*NON*;
;*NON*;	POP	DS
;*NON*;
;*NON*;	RET
;*NON*;MOVHVR	ENDP
;*NON*;

CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SSDES0:WORD		; visual data segment plean 0
EXTRN	SSDES1:WORD		; visual data segment plean 1
EXTRN	SSDES2:WORD		; visual data segment plean 2
EXTRN	SSDES3:WORD		; visual data segment plean 3

EXTRN	SSSOU0:WORD		; visual data segment plean 0
EXTRN	SSSOU1:WORD		; visual data segment plean 1
EXTRN	SSSOU2:WORD		; visual data segment plean 2
EXTRN	SSSOU3:WORD		; visual data segment plean 3

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.
EXTRN	VX3:WORD		; destination point x3.
EXTRN	VY3:WORD		; destination point y3.

		EVEN
DATA	ENDS

	END
;
; end of "ADVMOV.ASM"
;
