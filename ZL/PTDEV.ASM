;"PTDEV.ASM" 1988/11/05 R.H
;	modify 1989/12/08 R.H
;
;	pic device handler.
;
;	PC-9801UV11 make by R.H 1988
;
; public subroutine.
;

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA,ES:DATA,SS:CODE

	PUBLIC	PTLIN		; XOR line.
	PUBLIC	PTXRS		; cross line.
	PUBLIC	PTBOX		; XOR box.
	PUBLIC	PTPIC		; point pick.
	PUBLIC	PTCHG		; box point left & right set.
	PUBLIC	PTCHK		; check same 2 point?
	PUBLIC	PTSET		; ピックデバイスセット(0=KEY,1=MOUSE)
	PUBLIC	PTMODE		; ピックモード切り替え

	EXTRN	MUSINI:NEAR	; マウスの初期化
	EXTRN	MUSRED:NEAR	; マウス読み込み
	EXTRN	MUSSTP:NEAR	; マウスの終了

	EXTRN	GDCLIN:NEAR	;line.
	EXTRN	GDCBOX:NEAR	;box.
	EXTRN	GDCWAT:NEAR	;GDC wait.

; XOR line.
; -i- VX1,VY1  : start point.
;     VX2,VY2  : end point.

PTLIN	PROC	NEAR
	MOV	AX,VX1
	MOV	BX,VY1
	CALL	PNTCRT		; ピック座標－＞ＣＲＴ座標
	MOV	GX1,AX
	MOV	GY1,BX

	MOV	AX,VX2
	MOV	BX,VY2
	CALL	PNTCRT		; ピック座標－＞ＣＲＴ座標
	MOV	GX2,AX
	MOV	GY2,BX

	MOV	GCLR, 00000001B		; XOR mode.
	MOV	GMODE,10000000B		; disply mode.(plean 0)
	CALL	GDCLIN			; line.

	MOV	GCLR, 00000001B		; XOR mode.
	MOV	GMODE,10010000B		; disply mode.(plean 1)
	CALL	GDCLIN			; line.

	MOV	GCLR, 00000001B		; XOR mode.
	MOV	GMODE,10100000B		; disply mode.(plean 2)
	CALL	GDCLIN			; line.

	CALL	GDCWAT			;GDC wait.
	RET
PTLIN	ENDP


; cross line. (XOR)
; -i- VX1,VY1  : point.

PTXRS	PROC	NEAR
	MOV	AX,VX1
	MOV	BX,VY1
	MOV	VXX,AX
	MOV	VYY,BX

	MOV	AX,0			; x min.
	CALL	PNTPIC	; ＣＲＴ座標－＞ピック座標
	MOV	BX,VYY			; y location.
	MOV	VX1,AX			; x min.
	MOV	VY1,BX			;


	MOV	AX,639			; x max.
	CALL	PNTPIC	; ＣＲＴ座標－＞ピック座標
	MOV	BX,VYY			; y location.
	MOV	VX2,AX			; x max.
	MOV	VY2,BX			;
	CALL	PTLIN			; XOR line.

	MOV	BX,0			; y min.
	CALL	PNTPIC	; ＣＲＴ座標－＞ピック座標
	MOV	AX,VXX			; x location.
	MOV	VX1,AX			;
	MOV	VY1,BX			; y min.

	MOV	BX,399			; y max.
	CALL	PNTPIC	; ＣＲＴ座標－＞ピック座標
	MOV	AX,VXX			; x location.
	MOV	VX2,AX			;
	MOV	VY2,BX			; y max.
	CALL	PTLIN			; XOR line.

	MOV	AX,VXX			;
	MOV	BX,VYY			;
	MOV	VX1,AX			; vx1 = vxx
	MOV	VY1,BX			; vy1 = vyy

	RET
PTXRS	ENDP


; XOR box.
; -i/o- VX1,VY1  : start point.
;       VX2,VY2  : end point.

PTBOX	PROC	NEAR
	CALL	PTCHG		; point check.
	MOV	AX,VX1
	CMP	AX,VX2
	JNZ	PTBOX1
	CALL	PTLIN
	RET
PTBOX1:
	MOV	AX,VY1
	CMP	AX,VY2
	JNZ	PTBOX2
	CALL	PTLIN
	RET
PTBOX2:
	MOV	AX,VX1
	MOV	BX,VY1
	CALL	PNTCRT		; ピック座標－＞ＣＲＴ座標
	MOV	GX1,AX
	MOV	GY1,BX

	MOV	AX,VX2
	MOV	BX,VY2
	INC	AX
	INC	BX
	CALL	PNTCRT		; ピック座標－＞ＣＲＴ座標
	DEC	AX
	DEC	BX
	MOV	GX2,AX
	MOV	GY2,BX

	MOV	GCLR, 00000001B		; XOR mode.
	MOV	GMODE,10000000B		; disply mode.(plean 0)
	CALL	GDCBOX			; box.

	MOV	GCLR, 00000001B		; XOR mode.
	MOV	GMODE,10010000B		; disply mode.(plean 1)
	CALL	GDCBOX			; box.

	MOV	GCLR, 00000001B		; XOR mode.
	MOV	GMODE,10100000B		; disply mode.(plean 2)
	CALL	GDCBOX			; box.

	CALL	GDCWAT			;GDC wait.
	RET
PTBOX	ENDP


; point pick.
; -o- VX1,VY1  : pic point.
;     AX       : 0:normal,1:pic,2:exit

PTPIC	PROC	NEAR
	CALL	PICDEV		; ピックデバイス
	MOV	BX,VXX
	MOV	VX1,BX
	MOV	BX,VYY
	MOV	VY1,BX
	RET
PTPIC	ENDP


; box point left & right set.
; -i- VX1,VY1  : point 1.
;     VX2,VY2  : point 2.
; -o- VX1,VY1  : left side point.
;     VX2,VY2  : right side point.

PTCHG	PROC	NEAR
	MOV	AX,VX2
	CMP	AX,VX1
	JNB	PTCHG1		; if vx1 > vx2 then
	MOV	BX,VX1		;   swap vx1,vx2
	MOV	VX1,AX		;
	MOV	VX2,BX		;
PTCHG1:	MOV	AX,VY2
	CMP	AX,VY1
	JNB	PTCHG2		; if vy1 > vy2 then
	MOV	BX,VY1		;   swap vy1,vy2
	MOV	VY1,AX		;
	MOV	VY2,BX		;
PTCHG2:	RET
PTCHG	ENDP


; check same 2 point?
; -i- VX1,VY1  : point 1.
;     VX2,VY2  : point 2.
; -o- AX       : 0:normal,1:same

PTCHK	PROC	NEAR
	MOV	AX,VX2		;
	SUB	AX,VX1		; AX = vx2 - vx1
	JNB	PTCHK1		; if AX < 0 then
	NEG	AX		;   AX = - AX
PTCHK1:	CMP	AX,SAMELENX	;
	JNB	PTCHK9		; if AX >= SAMELENX then exit.

	MOV	AX,VY2		;
	SUB	AX,VY1		; AX = vy2 - vy1
	JNB	PTCHK2		; if AX < 0 then
	NEG	AX		;   AX = - AX
PTCHK2:	CMP	AX,SAMELENY	;
	JNB	PTCHK9		; if AX >= SAMELENY then exit.

	MOV	AX,1		; same point.
	RET
PTCHK9:	MOV	AX,0		; normal.
	RET
PTCHK	ENDP


;	ピックデバイスセット(0=KEY,1=MOUSE)
;	-I- AX : 0=KEY,1=MOUSE

PTSET	PROC	NEAR
	MOV	PICSW,AX	; pic device ( 0=KEY,1=MOUSE )
	RET
PTSET	ENDP


;	ピックモード切り替え
;	-I- AX : 0=Ｘ方向ドット単位, 1=Ｘ方向バイト単位

PTMODE	PROC	NEAR
	CMP	AX,0
	JNE	PTMODE1
	MOV	XMODE,0 ; Ｘ方向モード（0=ドット単位,1=バイト単位）
	MOV	SAMELENX,5	; same point length.
	MOV	SAMELENY,5	; same point length.
	JMP	PTMODE99
PTMODE1:
	CMP	AX,1
	JNE	PTMODE2
	MOV	XMODE,1 ; Ｘ方向モード（0=ドット単位,1=バイト単位）
	MOV	SAMELENX,1	; same point length.
	MOV	SAMELENY,5	; same point length.
	JMP	PTMODE99
PTMODE2:
PTMODE99:
	RET
PTMODE	ENDP


;	ピック座標－＞ＣＲＴ座標
;	-I/O- AX: X point
;	      BX: Y point

PNTCRT	PROC	NEAR
	CMP	XMODE,1 ; Ｘ方向モード（0=ドット単位,1=バイト単位）
	JNE	PNTCRT9

	SHL	AX,1	; X point
	SHL	AX,1	;
	SHL	AX,1	;*8
PNTCRT9:
	RET
PNTCRT	ENDP


;	ＣＲＴ座標－＞ピック座標
;	-I/O- AX: X point
;	      BX: Y point

PNTPIC	PROC	NEAR
	CMP	XMODE,1 ; Ｘ方向モード（0=ドット単位,1=バイト単位）
	JNE	PNTPIC9

	SHR	AX,1	; X point
	SHR	AX,1	;
	SHR	AX,1	;/8
PNTPIC9:
	RET
PNTPIC	ENDP


;	ピックデバイス
;	-o- VXX,VYY : location point.
;	    AX      : 0=normal, 1=pic, 2=exit

PICDEV	PROC	NEAR
	CMP	PICSW,0		; pic device ( 0=KEY,1=MOUSE )
	JNE	PICDEV_MOUSE

	CALL	KEYLOC		; key location.
	JMP	PICDEV_EXIT
PICDEV_MOUSE:
	CALL	MUSLOC		; MOUSE pic.

PICDEV_EXIT:
	PUSH	AX
	MOV	AX,VXX
	MOV	BX,VYY
	CALL	PNTPIC	; ＣＲＴ座標－＞ピック座標
	MOV	VXX,AX
	MOV	VYY,BX
	POP	AX
	RET
PICDEV	ENDP


;	MOUSE pic.
;	-o- VXX,VYY : location point.
;	    AX      : 0=normal, 1=pic, 2=exit

MUSLOC	PROC	NEAR
	CALL	MUSRED		; マウス読み込み

;;;;;;;;	ADD	AX,319	; Ｘ座標
;;;;;;;;	ADD	BX,199	; Ｙ座標

	CMP	AX,639		; if x > 639 then  x = 639
	JNG	MUSLOC21	;
	MOV	AX,639		;
MUSLOC21:
	CMP	AX,0		; if x < 0 then  x = 0
	JNL	MUSLOC22	;
	MOV	AX,0		;
MUSLOC22:

	CMP	BX,399		; if y > 399 then  y = 399
	JNG	MUSLOC31	;
	MOV	BX,399		;
MUSLOC31:
	CMP	BX,0		; if y < 0 then  y = 0
	JNL	MUSLOC32	;
	MOV	BX,0		;
MUSLOC32:
	MOV	VXX,AX
	MOV	VYY,BX

	CMP	DH,0	; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JNE	MUSLOC5
	MOV	AX,1	; ＰＩＣ
	JMP	MUSLOC9
MUSLOC5:
	CMP	DL,0	; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JNE	MUSLOC6
	MOV	AX,2	; ＥＸＩＴ
	JMP	MUSLOC9
MUSLOC6:
	MOV	AX,0	; ボタンは押されていない
MUSLOC9:
	RET
MUSLOC	ENDP



;	key bord locate.

; key group 06h.
KEY_SHOU_NARI		EQU	00000001B
KEY_DAI_NARI		EQU	00000010B
KEY_DOT			EQU	00000100B
KEY_UNDER_BER		EQU	00001000B
KEY_SPACE		EQU	00010000B
KEY_XFER		EQU	00100000B
KEY_ROLL_UP		EQU	01000000B
KEY_ROLL_DOWN		EQU	10000000B
; key group 07h.
KEY_INS			EQU	00000001B
KEY_DEL			EQU	00000010B
KEY_UP			EQU	00000100B
KEY_LEFT		EQU	00001000B
KEY_RIGHT		EQU	00010000B
KEY_DOWN		EQU	00100000B
KEY_HOME_CLR		EQU	01000000B
KEY_HELP		EQU	10000000B

KEY_BORD_SCYAN	MACRO	KEY_CODE_GROUP
	MOV	AH,04H				;KEY BORD SENCE
	MOV	AL,KEY_CODE_GROUP		;KEY CODE GROUP
	INT	18H				;KEY BORD SCAYN
ENDM

KEYIN	MACRO
	MOV	AH,6
	MOV	DL,0FFH
	INT	21H
ENDM

KEY_BORD_CLEAR	MACRO
	LOCAL	L1,L2
	PUSH	AX
L1:	MOV	AH,01H				;KEY BUFFER SENCE.
	INT	18H				;KEY BORD BIOS.
	OR	BH,BH
	JZ	L2
	MOV	AH,00H				;KEY DATA INPUT.
	INT	18H				;KEY BORD BIOS.
	JMP	L1
L2:	POP	AX
ENDM


; key location.
; -o- VXX,VYY : location point.
;     AX      : 0=normal, 1=pic, 2=exit

KEYLOC	PROC	NEAR

	KEY_BORD_SCYAN	07H

	KEY_BORD_CLEAR

	TEST	AH,KEY_HELP		; slow.
	JNZ	KEYLOC_WAIT2
	PUSH	CX
	MOV	CX,1000H
KEYLOC_WAIT1:
	NOP
	LOOP	KEYLOC_WAIT1
	POP	CX
KEYLOC_WAIT2:

	TEST	AH,KEY_INS		; pic !!
	JNZ	KEYLOC_PIC

	TEST	AH,KEY_DEL
	JNZ	KEYLOC_EXIT		; escape !!

	MOV	CX,1			; move step.
	TEST	AH,KEY_HOME_CLR
	JZ	KEYLOC0
	MOV	CX,4			; move step.
KEYLOC0:

	TEST	AH,KEY_UP
	JZ	KEYLOC1
	CALL	KEYLOC_UP
KEYLOC1:
	TEST	AH,KEY_DOWN
	JZ	KEYLOC2
	CALL	KEYLOC_DOWN
KEYLOC2:
	TEST	AH,KEY_LEFT
	JZ	KEYLOC3
	CALL	KEYLOC_LEFT
KEYLOC3:
	TEST	AH,KEY_RIGHT
	JZ	KEYLOC4
	CALL	KEYLOC_RIGHT
KEYLOC4:
	XOR	AX,AX			; normal.
	JMP	KEYLOC_FINALE

KEYLOC_PIC:
	MOV	AX,1			; pic.
	JMP	KEYLOC_FINALE
KEYLOC_EXIT:
	MOV	AX,2			; exit.
	JMP	KEYLOC_FINALE

KEYLOC_FINALE:
	MOV	BX,KEYXX
	MOV	VXX,BX
	MOV	BX,KEYYY
	MOV	VYY,BX
	RET

KEYLOC_UP:
	PUSH	CX
KEYLOC_UP1:
	CMP	KEYYY,0			; if KEYYY <= 0 then return.
	JLE	KEYLOC_UP9		;
	DEC	KEYYY			; KEYYY--
	LOOP	KEYLOC_UP1
KEYLOC_UP9:
	POP	CX
	RET

KEYLOC_DOWN:
	PUSH	CX
KEYLOC_DOWN1:
	CMP	KEYYY,399		; if KEYYY >= 399 then return.
	JGE	KEYLOC_DOWN9		;
	INC	KEYYY			; KEYYY++
	LOOP	KEYLOC_DOWN1
KEYLOC_DOWN9:
	POP	CX
	RET

KEYLOC_LEFT:
	PUSH	CX
KEYLOC_LEFT1:
	CMP	KEYXX,0			; if KEYXX <= 0 then return.
	JLE	KEYLOC_LEFT9		;
	DEC	KEYXX			; KEYXX--
	LOOP	KEYLOC_LEFT1
KEYLOC_LEFT9:
	POP	CX
	RET

KEYLOC_RIGHT:
	PUSH	CX
KEYLOC_RIGHT1:
	CMP	KEYXX,639		; if KEYXX >= 639 then return.
	JGE	KEYLOC_RIGHT9		;
	INC	KEYXX			; KEYXX++
	LOOP	KEYLOC_RIGHT1
KEYLOC_RIGHT9:
	POP	CX
	RET

KEYLOC	ENDP


CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

	EXTRN	VX1:WORD	; left side x.
	EXTRN	VY1:WORD	; left side y.
	EXTRN	VX2:WORD	; right side x.
	EXTRN	VY2:WORD	; right side y.
	EXTRN	ADRS:WORD	; address.
	EXTRN	NUM:WORD	; number.

	EXTRN	GX1:WORD	; point 1 x.
	EXTRN	GY1:WORD	; point 1 y.
	EXTRN	GX2:WORD	; point 2 x.
	EXTRN	GY2:WORD	; point 2 y.
	EXTRN	GMODE:WORD	; mode.
	EXTRN	GCODE:WORD	; code.
	EXTRN	GCLR:WORD	; color.
	EXTRN	GRD:WORD	; radius.

	VXX	DW	0	; point save area. x
	VYY	DW	0	; point save area. y

	KEYXX	DW	639/2	; key location x. ( valiable )
	KEYYY	DW	399/2	; key location y. ( valiable )

SAMELENX	DW	5	; same point length.
SAMELENY	DW	5	; same point length.

PICSW	DW	0	; pic device ( 0=KEY,1=MOUSE )
XMODE	DW	0	; Ｘ方向モード（0=ドット単位,1=バイト単位）

DATA	ENDS

	END
;
;	end of "PTDEV.ASM"
;
