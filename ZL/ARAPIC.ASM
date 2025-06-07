;"ARAPIC.ASM" 1988/11/20 R.H
;
;	locate input.
;
;	PC-9801UV11 make by R.H 1988
;
; public subroutine.
;
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA,ES:DATA,SS:CODE

	PUBLIC	ARAPNT		; point pic.
	PUBLIC	ARABOX		; box pic.

	EXTRN	PTLIN:NEAR		; XOR line.
	EXTRN	PTXRS:NEAR		; cross line.
	EXTRN	PTBOX:NEAR		; XOR box.
	EXTRN	PTPIC:NEAR		; point pick.
	EXTRN	PTCHG:NEAR		; box point left & right set.
	EXTRN	PTCHK:NEAR		; check same 2 point?

; point pic.
; -o- VX1,VY1 : pic point.
;     AX      : 0:normal,2:escape

ARAPNT	PROC	NEAR
	CALL	PTPIC		; pic point.
	CALL	PTXRS		; put xross marker.
	MOV	AX,VX1		;
	MOV	XCRT,AX		; xcrt = vx1
	MOV	AX,VY1		;
	MOV	YCRT,AX		; ycrt = vy1

ARAPNT1:CALL	PTPIC		; pic point.
	CMP	AX,1		; if pic then return.
	JZ	ARAPNT8		;
	CMP	AX,2		; if escape then return.
	JZ	ARAPNT9		;

	MOV	AX,VX1		;
	CMP	AX,XCRT		;
	JNZ	ARAPNT2		;
	MOV	AX,VY1		;
	CMP	AX,YCRT		;
	JNZ	ARAPNT2		;
	JMP	ARAPNT3		; if vx1<>xcrt or vy1<>ycrt then
ARAPNT2:MOV	AX,VX1		;
	MOV	VXX,AX		;   vxx = vx1
	MOV	AX,VY1		;
	MOV	VYY,AX		;   vyy = vy1
	MOV	AX,XCRT		;
	MOV	VX1,AX		;   vx1 = xcrt
	MOV	AX,YCRT		;
	MOV	VY1,AX		;   vy1 = ycrt
	CALL	PTXRS		;   clear xross point.
	MOV	AX,VXX		;
	MOV	VX1,AX		;   vx1 = vxx
	MOV	XCRT,AX		;   xcrt = vxx
	MOV	AX,VYY		;
	MOV	VY1,AX		;   vy1 = vyy
	MOV	YCRT,AX		;   ycrt = vyy
	CALL	PTXRS		;   put xross point.
ARAPNT3:			; endif
	JMP	ARAPNT1		; next.

ARAPNT8:MOV	AX,0		; pic.

ARAPNT9:PUSH	AX
	MOV	AX,XCRT		;
	MOV	VX1,AX		;   vx1 = xcrt
	MOV	AX,YCRT		;
	MOV	VY1,AX		;   vy1 = ycrt
	CALL	PTXRS		;   clear xross point.
	POP	AX
	RET
ARAPNT	ENDP

; box pic.
; -o- VX1,VY1 : left point.
;     VX2,VY2 : right point.
;     AX      : 0:normal,2:escape

ARABOX	PROC	NEAR
	CALL	ARAPNT		; point pic.
	CMP	AX,2		; if ax = 2 then exit.
	JNZ	ARABOX0		;
	JMP	ARABOX_EXIT
ARABOX0:
	MOV	AX,VX1		;
	MOV	XBOX,AX		; xbox = vx1
	MOV	AX,VY1		;
	MOV	YBOX,AX		; ybox = vy1

	CALL	PTPIC		; pic point.
	MOV	AX,XBOX		;
	MOV	VX2,AX		; vx2 = xbox
	MOV	AX,YBOX		;
	MOV	VY2,AX		; vy2 = ybox
	MOV	AX,VX1		;
	MOV	XCRT,AX		; xcrt = vx1
	MOV	AX,VY1		;
	MOV	YCRT,AX		; ycrt = vy1
	CALL	PTBOX		; put box marker.

ARABOX1:CALL	PTPIC		; pic point.
	CMP	AX,1		; if pic then
	JNZ	ARABOX11	;
	MOV	AX,XCRT		;
	MOV	VX1,AX		;   vx1 = xcrt
	MOV	AX,YCRT		;
	MOV	VY1,AX		;   vy1 = ycrt
	MOV	AX,XBOX		;
	MOV	VX2,AX		;   vx2 = xbox
	MOV	AX,YBOX		;
	MOV	VY2,AX		;   vy2 = ybox
	CALL	PTCHK		;   same check.
	OR	AX,AX		;
	JNZ	ARABOX11	;   if box then return.
	JMP	ARABOX8		;   if box then return.
ARABOX11:			; endif

	CMP	AX,2		; if escape then return.
	JZ	ARABOX9		;

	MOV	AX,VX1		;
	CMP	AX,XCRT		;
	JNZ	ARABOX2		;
	MOV	AX,VY1		;
	CMP	AX,YCRT		;
	JNZ	ARABOX2		;
	JMP	ARABOX3		;  if vx1<>xcrt or vy1<>ycrt then
ARABOX2:

	MOV	AX,VX1		;
	MOV	VXX,AX		;   vxx = vx1
	MOV	AX,VY1		;
	MOV	VYY,AX		;   vyy = vy1
	MOV	AX,XCRT		;
	MOV	VX1,AX		;   vx1 = xcrt
	MOV	AX,YCRT		;
	MOV	VY1,AX		;   vy1 = ycrt
	MOV	AX,XBOX		;
	MOV	VX2,AX		;   vx2 = xbox
	MOV	AX,YBOX		;
	MOV	VY2,AX		;   vy2 = ybox
	CALL	PTBOX		;   clear box marker.
	MOV	AX,VXX		;
	MOV	VX1,AX		;   vx1 = vxx
	MOV	XCRT,AX		;   xcrt = vxx
	MOV	AX,VYY		;
	MOV	VY1,AX		;   vy1 = vyy
	MOV	YCRT,AX		;   ycrt = vyy
	MOV	AX,XBOX		;
	MOV	VX2,AX		;   vx2 = xbox
	MOV	AX,YBOX		;
	MOV	VY2,AX		;   vy2 = ybox
	CALL	PTBOX		;   put box marker.
ARABOX3:			; endif
	JMP	ARABOX1		; next.

ARABOX8:MOV	AX,0		; pic.

ARABOX9:PUSH	AX
	MOV	AX,XCRT		;
	MOV	VX1,AX		;   vx1 = xcrt
	MOV	AX,YCRT		;
	MOV	VY1,AX		;   vy1 = ycrt
	MOV	AX,XBOX		;
	MOV	VX2,AX		;   vx2 = xbox
	MOV	AX,YBOX		;
	MOV	VY2,AX		;   vy2 = ybox
	CALL	PTBOX		;   clear xross point.
	POP	AX
ARABOX_EXIT:
	RET
	
ARABOX	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

	EXTRN	VX1:WORD	; left side x.
	EXTRN	VY1:WORD	; left side y.
	EXTRN	VX2:WORD	; right side x.
	EXTRN	VY2:WORD	; right side y.
	EXTRN	ADRS:WORD	; address.
	EXTRN	NUM:WORD	; number.

XCRT	DW	0
YCRT	DW	0
VXX	DW	0
VYY	DW	0
XBOX	DW	0
YBOX	DW	0

DATA	ENDS

	END
;
;	end of "ARAPIC.ASM"
;
