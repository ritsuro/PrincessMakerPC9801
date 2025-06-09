; "TXTLCK.ASM" 1990/02/01 R.H  PC-9801UV11 make by R.H 1990
;
;	TEXT LOCK.
;
; public subroutine.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	TXTLCK			; text lock.
PUBLIC	TXULCK			; text unlock.

EXTRN	DSKOPN:NEAR		; file open.
EXTRN	DSKCRE:NEAR		; file open & creat.
EXTRN	DSKCLS:NEAR		; file close.

EXTRN	DSKRED:NEAR		; load 1 byte data.
EXTRN	DSKWRT:NEAR		; save 1 byte data.


BUFLEN		EQU	15000	; buffer length.



;	text lock.
;	-I- LCFLRD : read file name.
;	    LCFLWT : write file name.

TXTLCK	PROC	NEAR
	MOV	PNTNOW,OFFSET BFDATA	; now offset pointer.
	MOV	CNTFRE,BUFLEN		; now free byte.

	MOV	SI,OFFSET LCFLRD	; read file name.
	CALL	TXTTRD			; data read.
	CMP	AX,0			; 0=normal,1=file not found.
	JNE	TXTLCK_NOT_ERROR	;
	CMP	SIZOVR,1		; 1=size over.
	JE	TXTLCK_SIZE_ERROR	;

	CALL	TLOCK			; lock edit.

	MOV	AX,PNTRED		; now read pointer.
	MOV	PNTNOW,AX		; now offset pointer.

	MOV	SI,OFFSET LCFLWT	; write file name.
	CALL	TXTTWT			; data write.
	CMP	AX,0			; 0=normal,1=write error.
	JNE	TXTLCK_WRT_ERROR	;

	MOV	AX,0			; 0=normal.
	RET
TXTLCK_NOT_ERROR:
	MOV	AX,1			; 1=file not found.
	RET
TXTLCK_SIZE_ERROR:
	MOV	AX,2			; 2=size over.
	RET
TXTLCK_WRT_ERROR:
	MOV	AX,3			; 3=write error.
	RET
TXTLCK	ENDP



;	text unlock.
;	-I- LCFLRD : read file name.
;	    LCFLWT : write file name.

TXULCK	PROC	NEAR
	MOV	PNTNOW,OFFSET BFDATA	; now offset pointer.
	MOV	CNTFRE,BUFLEN		; now free byte.

	MOV	SI,OFFSET LCFLRD	; read file name.
	CALL	TXTTRD			; data read.
	CMP	AX,0			; 0=normal,1=file not found.
	JNE	TXULCK_NOT_ERROR	;
	CMP	SIZOVR,1		; 1=size over.
	JE	TXULCK_SIZE_ERROR	;

	CALL	TUNLCK			; unlock edit.

	MOV	AX,PNTRED		; now read pointer.
	MOV	PNTNOW,AX		; now offset pointer.

	MOV	SI,OFFSET LCFLWT	; write file name.
	CALL	TXTTWT			; data write.
	CMP	AX,0			; 0=normal,1=write error.
	JNE	TXULCK_WRT_ERROR	;

	MOV	AX,0			; 0=normal.
	RET
TXULCK_NOT_ERROR:
	MOV	AX,1			; 1=file not found.
	RET
TXULCK_SIZE_ERROR:
	MOV	AX,2			; 2=size over.
	RET
TXULCK_WRT_ERROR:
	MOV	AX,3			; 3=write error.
	RET
TXULCK	ENDP



;	unlock edit.
;	-I- PNTNOW : now offset pointer.
;	    PNTRED : now read pointer.

TUNLCK	PROC	NEAR
	MOV	SI,0		; code table pointer.
	MOV	BX,PNTNOW	; now offset pointer.
TUNLCK2:
	CMP	BX,PNTRED	; now read pointer.
	JE	TUNLCK9		; data end.

	MOV	AL,DS:LOCKCD[SI] ; lock code.
	SUB	BYTE PTR DS:[BX],AL
	INC	BX		; buffer pointer.
	INC	SI		; code table pointer.
	CMP	SI,6		;
	JL	TUNLCK6		;
	MOV	SI,0		; code table pointer.
TUNLCK6:			;
	JMP	TUNLCK2		;
TUNLCK9:
	RET
TUNLCK	ENDP



;	lock edit.
;	-I- PNTNOW : now offset pointer.
;	    PNTRED : now read pointer.

TLOCK	PROC	NEAR
	MOV	SI,0		; code table pointer.
	MOV	BX,PNTNOW	; now offset pointer.
TLOCK2:
	CMP	BX,PNTRED	; now read pointer.
	JE	TLOCK9		; data end.

	MOV	AL,DS:LOCKCD[SI] ; lock code.
	ADD	BYTE PTR DS:[BX],AL
	INC	BX		; buffer pointer.
	INC	SI		; code table pointer.
	CMP	SI,6		;
	JL	TLOCK6		;
	MOV	SI,0		; code table pointer.
TLOCK6:				;
	JMP	TLOCK2		;
TLOCK9:
	RET
TLOCK	ENDP




;	data read.
;	-i- DS:SI  : file name.
;	    PNTNOW : now offset pointer.
;	    CNTFRE : now free byte.
;	-o- AX     : 0=normal,1=file not found.
;	    SIZOVR : 1=size over.
;	    PNTRED : now read pointer.
;	    CNTRED : now read byte.

TXTTRD	PROC	NEAR
	MOV	SIZOVR,0	; 1=size over.
	CALL	DSKOPN		; file open.
	CMP	AX,0		; 0:normal,1:open error.
	JNE	TXTTRD_ERROR	;

	MOV	CX,0		; read byte counter.
	MOV	BX,PNTNOW	; now offset pointer.

TXTTRD_LOOP:
	CMP	CX,CNTFRE	; now free byte.
	JNBE	TXTTRD_OVER	; size over?


	PUSH	BX		;
	PUSH	CX		;
	CALL	DSKRED		; load 1 byte data.
	POP	CX		;
	POP	BX		;
	CMP	AH,1		; 0:normal  1:E.O.F
	JE	TXTTRD8		;

	MOV	DS:[BX],AL	; 1 byte data
	INC	BX		; offset.
	INC	CX		; read byte counter.

	JMP	TXTTRD_LOOP	;

TXTTRD_OVER:
	MOV	SIZOVR,1	; 1=size over.
TXTTRD8:
	MOV	PNTRED,BX	; now read pointer.
	MOV	CNTRED,CX	; now read byte.

	CALL	DSKCLS		; file close.
	CMP	AH,0		; AH : 0:normal  1:write error
	JNE	TXTTRD_ERROR	;

	MOV	AX,0		; normal.
	RET
TXTTRD_ERROR:
	MOV	AX,1		; 1=file not found.
	RET
TXTTRD	ENDP



;	data write.
;	-i- DS:SI  : file name.
;	    PNTNOW : now offset pointer.
;	-o- AX     : 0=normal,1=write error.

TXTTWT	PROC	NEAR
	CALL	DSKCRE		; file open & creat.
	CMP	AX,0		; 0:normal,1:open error.
	JNE	TXTTWT_ERROR	;

	MOV	BX,OFFSET BUFTOP ; buffer top.
TXTTWT_LOOP:
	CMP	BX,PNTNOW	; now offset pointer.
	JNB	TXTTRD_END	; complete?

	MOV	AL,DS:[BX]	; 1 byte data
	INC	BX		; offset.
	PUSH	BX		;
	CALL	DSKWRT		; save 1 byte data.
	POP	BX		;
	CMP	AH,1		; 0:normal  1:write error
	JE	TXTTWT_ERROR	;

	JMP	TXTTWT_LOOP	;

TXTTRD_END:			;
	CALL	DSKCLS		; file close.
	CMP	AH,0		; AH : 0:normal  1:write error
	JNE	TXTTWT_ERROR	;

	MOV	AX,0		; normal.
	RET
TXTTWT_ERROR:
	MOV	AX,1		; 1=write error.
	RET
TXTTWT	ENDP



CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	LCFLRD			; read file name.
PUBLIC	LCFLWT			; write file name.


LCFLRD	DB	15 DUP (' '),0		; read file name.
LCFLWT	DB	15 DUP (' '),0		; write file name.

	EVEN
PNTNOW	DW	0		; now offset pointer.
CNTFRE	DW	0		; now free byte.

PNTRED	DW	0		; now read pointer.
CNTRED	DW	0		; now read byte.

SIZOVR	DW	0		; 1=size over.

BUFTOP	LABEL	BYTE		; buffer top.
BFDATA	DB	BUFLEN DUP (0)	; data set.


;voidvoidvoid
LOCKCD	LABEL	BYTE		; lock code.
	DB	00H	;0
	DB	00H	;1
	DB	00H	;2
	DB	00H	;3
	DB	00H	;4
	DB	00H	;5


DATA	ENDS

	END
;
;	end of "TXTLCK.ASM"
;
