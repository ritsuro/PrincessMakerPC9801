; "DISKIO.ASM"  1989/09/15 PC-9801UV11 make by R.H
;		1990/10/23 file handle.
;
;	disk i/o.
;
; public subroutine.


ONE_BYTE_RW	EQU	1		; 1 byte read/write.0=OFF,1=ON
BUFFLEN		EQU	1		; buffer length.
DTALEN		EQU	65534-256-44	; DTA length.
PATH_LENGTH	EQU	256		; path line length.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DOSDAT

PUBLIC	DSKOPN		; file open.
PUBLIC	DSKCRE		; file open & creat.
PUBLIC	DSKCLS		; file close.

PUBLIC	DSKRED		; load 1 byte data.
PUBLIC	DSKWRT		; save 1 byte data.

PUBLIC	DSKLD		; load data.
PUBLIC	DSKSV		; save data.

PUBLIC	DSK600		; ＤＴＡの最大バイト数ロード（高速処理用）


;	load 1 byte data.
;	-O- AL : 1 byte data
;	    AH : 0:normal  1:E.O.F

DSKRED	PROC	NEAR

	PUSH	DS

	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	CALL	DSKREAD

	POP	DS
	RET
DSKRED	ENDP


;	save 1 byte data.
;	-I- AL : 1 byte data
;	-O- AH : 0:normal  1:write error

DSKWRT	PROC	NEAR

	PUSH	DS

	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	CALL	DSKWRITE

	POP	DS
	RET
DSKWRT	ENDP


;	load data.
;	-i- SI : file name.
;		NULL = end of string.
;	    DX : dest segment address.
;	    DI : dest offset  address.
;	    CX : data length.
;	-o- AX : 0:normal  1:error.

DSKLD	PROC	NEAR
	CALL	DSKOPN

	PUSH	DS

	PUSH	BX
	MOV	BX,SEG DOSDAT
	MOV	DS,BX
	POP	BX

	CMP	AX,0
	JNE	DSKLD9

	MOV	RECORD_SIZE,CX		; byte/record.

	PUSH	DX
	PUSH	DI
	PUSH	CX	
	CALL	read
	POP	CX
	POP	DI
	POP	DX

	MOV	SI,OFFSET DTA		; source address.
	MOV	ES,DX			; dest address.
	REP	MOVSB

	CALL	DSKCLS			; file close.
	MOV	AX,0			; normal end.
DSKLD9:
	POP	DS
	RET
DSKLD	ENDP



;	save data.
;	-i- SI : file name.
;		NULL = end of string.
;	    DX : source segment address.
;	    DI : source offset  address.
;	    CX : data length.
;	-o- AX : 0:normal,1:error.

DSKSV	PROC	NEAR
	CALL	DSKCRE			; file open.

	PUSH	DS

	PUSH	BX
	MOV	BX,SEG DOSDAT
	MOV	DS,BX
	POP	BX

	CMP	AX,0
	JNE	DSKSV9

	MOV	RECORD_SIZE,CX		; byte/record.

	MOV	SI,DI			; source address.

	MOV	DI,OFFSET DTA		; dest address.
	PUSH	DS
	MOV	DS,DX			; source segment.
	MOV	AX,SEG DOSDAT
	MOV	ES,AX			; dest segment.
	REP	MOVSB
	POP	DS

	CALL	write

	CALL	DSKCLS			; file close.
	MOV	AX,0			; normal end.
DSKSV9:
	POP	DS
	RET
DSKSV	ENDP



;	file open.
;	-i- DS:SI : file name.
;	    NULL = end of string.
;	-o- AX    : 0:normal,1:open error.

DSKOPN	PROC	NEAR
	PUSH	DS
	PUSH	DX
	PUSH	DI
	PUSH	CX

	MOV	DX,DS			; user DS segment.

	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	CALL	FNSET			; file name set.
	CALL	open			;
	JC	DSKOPN9			; if ( open error ) then exit

	MOV	RECORD_SIZE,BUFFLEN	; byte/record.

	MOV	FLAG_WRITE,0		; write flag.

	MOV	BPOINT,0		; buffer pointer.

	MOV	AX,0			; normal.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKOPN9:
	MOV	AX,1			; open error.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKOPN	ENDP


;	file open & creat.
;	-i- DS:SI : file name.
;	   NULL = end of string.
;	-o- AX : 0:normal,1:open error.

DSKCRE	PROC	NEAR
	PUSH	DS
	PUSH	DX
	PUSH	DI
	PUSH	CX

	MOV	DX,DS			; user DS segment.

	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	CALL	FNSET			; file name set.
	CALL	creat			;
	JC	DSKCRE9			; if ( open error ) then exit

	MOV	RECORD_SIZE,BUFFLEN	; byte/record.

	MOV	FLAG_WRITE,0		; write flag.

	MOV	BPOINT,0		; buffer pointer.

	MOV	AX,0			; normal.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKCRE9:
	CALL	close
	MOV	AX,1			; open error.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKCRE	ENDP


;	file close.
;	-O- AH : 0:normal  1:write error

DSKCLS	PROC	NEAR
	PUSH	DS

	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	CMP	FLAG_WRITE,0		; write flag.
	JE	DSKCLS5

	CALL	write
	CMP	AL,0			; write_error?
	JZ	DSKCLS5			;

	CALL	close

	MOV	AH,1			; write error.
	POP	DS
	RET
DSKCLS5:
	CALL	close

	MOV	AH,0			; normal.
	POP	DS
	RET
DSKCLS	ENDP



;	file read 1 byte data.
;
;	-O- AL : 1 byte data
;	    AH : 0:normal  1:E.O.F

DSKREAD	PROC	NEAR
	PUSH 	CX

IF	ONE_BYTE_RW			; 1 byte rread/write.

	CALL	read			;
	JC	DSKREAD9		; disk error.
	CMP	AX,0			; if ( E.O.F ) then exit
	JE	DSKREAD9		;

	MOV	AL,BYTE PTR DTA		; AL = DTA[ 0 ]

	JMP	DSKREAD8		;
ENDIF
	
DSKREAD_START:

	CMP	BPOINT,0
	JZ	DSKREAD2

	MOV	AX,RECORD_SIZE		; 1 record data length.
	CMP	AX,BPOINT		; read addres check.
	JNBE	DSKREAD5		; if buffer empty then ...

DSKREAD2:
	CALL	BUFFER_CLEAR		; buffer 0 clear.
	CALL	read			;
	JC	DSKREAD9		; disk error.
	CMP	AX,0			; if ( E.O.F ) then exit
	JE	DSKREAD9		;

	MOV	BPOINT,0
DSKREAD5:
	MOV	BX,BPOINT		;
	MOV	AL,BYTE PTR DS:DTA[BX]	; AL = DTA[ BPOINT ]

	INC	BPOINT			; read address point inc.

DSKREAD8:
	MOV	AH,0			; normal.

	POP	CX
	RET

DSKREAD9:
	MOV	AH,1			; E.O.F

	POP	CX
	RET
DSKREAD	ENDP


;	file write 1 byte data.
;
;	-I- AL : 1 byte data
;	-O- AH : 0:normal  1:write error

DSKWRITE	PROC	NEAR
	PUSH	BX
	PUSH 	CX

IF	ONE_BYTE_RW			; 1 byte rread/write.

	MOV	BYTE PTR DTA,AL		; DTA[ BPOINT ] = AL
	CALL	write			;
	JC	DSKWRITE9		; if ( write_error ) then exit
	JMP	DSKWRITE8		;
ENDIF

	MOV	BX,BPOINT		;
	MOV	BYTE PTR DS:DTA[BX],AL	; DTA[ BPOINT ] = AL

	INC	BPOINT			; read address point inc.

	MOV	AX,RECORD_SIZE		; 1 record data length.
	CMP	AX,BPOINT		; read addres check.
	JNBE	DSKWRITE5		; if buffer empty then ...

	CALL	write			;
	JC	DSKWRITE9		; if ( write_error ) then exit

	CALL	BUFFER_CLEAR		; buffer 0 clear.

	MOV	BPOINT,0

	MOV	FLAG_WRITE,0		; write flag.
	JMP	DSKWRITE8
DSKWRITE5:
	MOV	FLAG_WRITE,1		; write flag.
DSKWRITE8:
	MOV	AH,0			; normal.

	POP	CX
	POP	BX
	RET

DSKWRITE9:
	MOV	AH,1			; write error.

	POP	CX
	POP	BX
	RET

DSKWRITE	ENDP



;	ＤＴＡの最大バイト数ロード（高速処理用）

DSK600	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	ES
	PUSH	DS
	PUSH	DI
	PUSH	SI

	MOV	BX,SEG DOSDAT
	MOV	DS,BX

	MOV	RECORD_SIZE,DTALEN	; byte/record.

	CALL	read

	POP	SI
	POP	DI
	POP	DS
	POP	ES
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
DSK600	ENDP




;	file name set.
;	-i- DX ; user DS segment.
;	    SI :file name.

FNSET	PROC	NEAR
	PUSH	DS
	PUSH	ES
	PUSH	SI
	PUSH	DI
	PUSH	DX

	MOV	CX,PATH_LENGTH		; path line length.
	MOV	AX,SEG DOSDAT		;
	MOV	ES,AX			; user data segment.
	MOV	DS,DX			; user DS segment.
	MOV	DI,OFFSET PATH_LINE	; path name line.
	REP	MOVSB			;

	POP	DX
	POP	DI
	POP	SI
	POP	ES
	POP	DS
	RET
FNSET	ENDP


;	buffer 0 clear.

BUFFER_CLEAR	PROC	NEAR
	MOV	DI,OFFSET DTA		; source address.
	MOV	AX,SEG DOSDAT		;
	MOV	ES,AX			; dest address.
	MOV	AL,0			;
	MOV	CX,BUFFLEN		; buffer length.
	REP	STOSB			;
	RET
BUFFER_CLEAR	ENDP




; file open or creat.

FOPEN	PROC	NEAR
	CALL	open
	JNC	FOPEN1
	CALL	creat
FOPEN1:	RET
FOPEN	ENDP

open	PROC	NEAR
	MOV	DX,OFFSET PATH_LINE
	MOV	AL,0			; read mode.
	MOV	AH,3DH
	INT	21H
	MOV	FILE_HANDLE,AX
	RET
open	ENDP

creat	PROC	NEAR
	MOV	DX,OFFSET PATH_LINE
	MOV	CX,0			; file attribute.
	MOV	AH,3CH
	INT	21H
	MOV	FILE_HANDLE,AX
	RET
creat	ENDP

close	PROC	NEAR
	MOV	BX,FILE_HANDLE
	MOV	AH,3EH
	INT	21H
	RET
close	ENDP

read	PROC	NEAR
	MOV	CX,RECORD_SIZE		; 1 record data length.
	MOV	BX,FILE_HANDLE
	MOV	DX,OFFSET DTA
	MOV	AH,3FH
	INT	21H
	RET
read	ENDP

write	PROC	NEAR
	MOV	CX,RECORD_SIZE		; 1 record data length.
	MOV	BX,FILE_HANDLE
	MOV	DX,OFFSET DTA
	MOV	AH,40H
	INT	21H
	RET
write	ENDP

CODE	ENDS


DOSDAT	SEGMENT	PUBLIC	'DOSDAT'

PUBLIC		DTA			; data buffer.
DTA		DB	DTALEN DUP (?)	;

PATH_LINE	DB	PATH_LENGTH DUP (0),0,0		; path name line.

FILE_HANDLE	DW	0		; file handle.
RECORD_SIZE	DW	0		; record size.
BPOINT		DW	0		; file buffer point.
DS_SEG		DW	0		; user data segment.
FLAG_WRITE	DW	0		; write flag. (0=empty buf,1=write)

DOSDAT	ENDS

	END
;
;	end of "DISKIO.ASM"
;
