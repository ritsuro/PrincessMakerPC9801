; "DISKIO.ASM" 1989/9/15 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.

BUFFLEN	EQU	1	;1024	 ; buffer length.
DTALEN	EQU	65534-44 ; DTA length.

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DOSDAT

	PUBLIC	DSKOPN		; file open.
	PUBLIC	DSKCRE		; file open & creat.
	PUBLIC	DSKCLS		; file close.

	PUBLIC	DSKDR		; drive number set.

	PUBLIC	DSKRED		; load 1 byte data.
	PUBLIC	DSKWRT		; save 1 byte data.

	PUBLIC	DSKLD		; load data.
	PUBLIC	DSKSV		; save data.

	PUBLIC	DSK600		; ＤＴＡの最大バイト数ロード（高速処理用）


;	drive number set.
;
;	-i- AX : drive number. 0:cullent 1:A 2:B ....

DSKDR	PROC	NEAR
	PUSH	DS
	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	MOV	BYTE PTR FCB_D,AL

	POP	DS
	RET
DSKDR	ENDP


;	load 1 byte data.
;
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
;
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
;
;	-i- SI : file name.
;		NULL = end of string.
;	    DX : dest segment address.
;	    DI : dest offset  address.
;	    CX : data length.
;
;	-o- AX : 0:normal.
;	         1:error.

DSKLD	PROC	NEAR
	CALL	DSKOPN

	PUSH	DS
	PUSH	BX
	MOV	BX,SEG DOSDAT
	MOV	DS,BX
	POP	BX

	CMP	AX,0
	JNE	DSKLD9

	MOV	WORD PTR FCB_RS,CX	; byte/record.

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
;
;	-i- SI : file name.
;		NULL = end of string.
;	    DX : source segment address.
;	    DI : source offset  address.
;	    CX : data length.
;
;	-o- AX : 0:normal.
;	         1:error.

DSKSV	PROC	NEAR
	CALL	DSKCRE			; file open.

	PUSH	DS
	PUSH	BX
	MOV	BX,SEG DOSDAT
	MOV	DS,BX
	POP	BX

	CMP	AX,0
	JNE	DSKSV9

	MOV	WORD PTR FCB_RS,CX	; byte/record.

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
;
;	-i- DS:SI : file name.
;	    NULL = end of string.
;	-o- AX : 0:normal.
;	    1:open error.

DSKOPN	PROC	NEAR
	PUSH	DS
	PUSH	DX
	PUSH	DI
	PUSH	CX

	MOV	DX,DS	; user DS segment.

	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	PUSH	DX
	CALL	FCBINI
	CALL	set_file_buffer
	POP	DX

	CALL	FNSET			;file name set to FCB
	CALL	open
	CMP	AL,0			; if ( open error ) then exit
	JNZ	DSKOPN9		;

	MOV	WORD PTR FCB_RS,BUFFLEN	; byte/record.

	MOV	FLAG_WRITE,0		; write flag.

	MOV	WORD PTR BPOINT,0	; buffer pointer.
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
;
;	-i- DS:SI : file name.
;	   NULL = end of string.
;	-o- AX : 0:normal.
;	   1:open error.

DSKCRE	PROC	NEAR
	PUSH	DS
	PUSH	DX
	PUSH	DI
	PUSH	CX

	MOV	DX,DS	; user DS segment.

	PUSH	AX
	MOV	AX,SEG DOSDAT
	MOV	DS,AX
	POP	AX

	PUSH	DX
	CALL	FCBINI
	CALL	set_file_buffer
	POP	DX

	CALL	FNSET			;file name set to FCB
	CALL	creat
	CMP	AL,0			; if ( open error ) then exit
	JNZ	DSKCRE9		;

	MOV	WORD PTR FCB_RS,BUFFLEN	; byte/record.

	MOV	FLAG_WRITE,0		; write flag.

	MOV	WORD PTR BPOINT,0	; buffer pointer.
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

DSKCLS	PROC
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

DSKREAD	PROC
	PUSH 	CX

	CMP	WORD PTR BPOINT,0
	JZ	DSKREAD2

	MOV	AX,WORD PTR FCB_RS	; 1 record data length.
	CMP	AX,WORD PTR BPOINT	; read addres check.
	JNBE	DSKREAD5		; if buffer empty then ...

DSKREAD2:
	CALL	read
	CMP	AL,03H			; if ( read data ) then skip.
	JE	DSKREAD3		;
	CMP	AL,0			; if ( E.O.F ) then exit
	JNZ	DSKREAD9		;
DSKREAD3:
	MOV	WORD PTR BPOINT,0
DSKREAD5:
	MOV	BX,BPOINT		;
	MOV	AL,BYTE PTR DS:DTA[BX]	; AL = DTA[ BPOINT ]

	INC	WORD PTR BPOINT		; read address point inc.

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

DSKWRITE	PROC
	PUSH	BX
	PUSH 	CX

	MOV	BX,BPOINT		;
	MOV	BYTE PTR DS:DTA[BX],AL	; DTA[ BPOINT ] = AL

	INC	WORD PTR BPOINT		; read address point inc.

	MOV	AX,WORD PTR FCB_RS	; 1 record data length.
	CMP	AX,WORD PTR BPOINT	; read addres check.
	JNBE	DSKWRITE5		; if buffer empty then ...

	CALL	write
	CMP	AL,0			; if ( write_error ) then exit
	JNZ	DSKWRITE9		;

	MOV	WORD PTR BPOINT,0

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

	MOV	BX,SEG DOSDAT		; ＤＯＳインターフェースセグメント
	MOV	DS,BX

	MOV	WORD PTR DS:[FCB_RS],DTALEN	; byte/record.

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




; file name set to FCB
; -i- DX ; user DS segment.
;     SI :file name.
;

FNSET	PROC	NEAR
	PUSH	ES
	PUSH	SI
	PUSH	DI

	MOV	AH,' '
	MOV	AL,' '
	MOV	WORD PTR FCB_FILENAME[0],AX
	MOV	WORD PTR FCB_FILENAME[2],AX
	MOV	WORD PTR FCB_FILENAME[4],AX
	MOV	WORD PTR FCB_FILENAME[6],AX
	MOV	WORD PTR FCB_TYP[0],AX
	MOV	BYTE PTR FCB_TYP[2],AL

	MOV	ES,DX	; user data segment.

	MOV	DI,OFFSET FCB_FILENAME
FNSET1:	MOV	AL,ES:[SI]
	CMP	AL,0
	JZ	FNSET4		;end of string.
	CMP	AL,'.'
	JZ	FNSET3		; typ.
	MOV	AL,ES:[SI]	;
	MOV	DS:[DI],AL	;
	INC	SI		;
	INC	DI		; set char.
	JMP	FNSET1

FNSET3:	INC	SI
	MOV	DI,OFFSET FCB_TYP
	JMP	FNSET1

FNSET4:	POP	DI
	POP	SI
	POP	ES
	RET
FNSET	ENDP


; FCB init.

FCBINI	PROC	NEAR
	PUSH	ES
	PUSH	DI
	MOV	AX,DS
	MOV	ES,AX
	MOV	DI,OFFSET FCB
	INC	DI	; FCB_D skip ( drive number )
	MOV	AL,0
	MOV	CX,36-1	; FCB_D skip
	REP	STOSB
	POP	DI
	POP	ES
	RET
FCBINI	ENDP


; file open or creat.

FOPEN	PROC	NEAR
	CALL	open
	CMP	AL,0
	JZ	FOPEN1
	CALL	creat
FOPEN1:	RET
FOPEN	ENDP

open	PROC	NEAR
	MOV	DX,OFFSET FCB
	MOV	AH,0FH
	INT	21H
	RET
open	ENDP

creat	PROC	NEAR
	MOV	DX,OFFSET FCB
	MOV	AH,16H
	INT	21H
	RET
creat	ENDP

close	PROC	NEAR
	MOV	DX,OFFSET FCB
	MOV	AH,10H
	INT	21H
	RET
close	ENDP

set_file_buffer	PROC	NEAR
	MOV	DX,OFFSET DTA
	MOV	AH,1AH
	INT	21H
	RET
set_file_buffer	ENDP	

read	PROC	NEAR
	MOV	DX,OFFSET FCB
	MOV	AH,14H
	INT	21H
	RET
read	ENDP

write	PROC	NEAR
	MOV	DX,OFFSET FCB
	MOV	AH,15H
	INT	21H
	RET
write	ENDP

CODE	ENDS


DOSDAT	SEGMENT	PUBLIC	'DOSDAT'
;	DAT.
PUBLIC	DTA			; ＤＴＡ
	EVEN
DTA	DB	DTALEN DUP (?)

FCB		LABEL	BYTE
FCB_D		DB	1 DUP (0)
FCB_FILENAME	DB	8 DUP (0)
FCB_TYP		DB	3 DUP (0)
FCB_CB		DW	0
FCB_RS		DW	0
FCB_FS		DD	0
FCB_DM		DW	0
FCB_DT		DW	0
FCB_SYS		DB	8 DUP (0)
FCB_CR		DB	0
FCB_RR		DD	0
	EVEN

BPOINT	DW	0		; file buffer point.

DS_SEG	DW	0		; user data segment.

FLAG_WRITE	DW	0	; write flag. (0=empty buf,1=write)


DOSDAT	ENDS

	END
;
;	end of "DISKIO.ASM"
;
