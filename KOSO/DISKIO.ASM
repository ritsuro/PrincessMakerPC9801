; "DISKIO.ASM"  1989/09/15 PC-9801UV11 make by R.H
;		1990/10/23 file handle.
;
;	disk i/o.
;
; public subroutine.

INCLUDE	TSTSET.INC

EXTRN	EMEMQUICK:FAR		; (far)Expanded memory data name search.
EXTRN	EMEMLOAD:FAR		; (far)Expanded memory data load.

ATR_MSGBOX	EQU	10100101B	; エラーメッセージ用

FILE_HANDLE	EQU	0		; DW 0 file handle.
RECORD_SIZE	EQU	0+2		; DW 0 record size.
BPOINT		EQU	0+2+2		; DW 0 file buffer point.
FLAG_WRITE	EQU	0+2+2+2		; DW 0 write flag.(0=empty buf,1=write)
PATH_LINE	EQU	0+2+2+2+2	; DB 20 DUP (0)  path name line.
DTA		EQU	0+2+2+2+2+20	; DB *  DUP (0)  data buffer.

ONE_BYTE_RW	EQU	1		; 1 byte read/write.0=OFF,1=ON
BUFFLEN		EQU	1		; buffer length.
DTALEN		EQU	65534-128-10	; DTA length.
PATH_LENGTH	EQU	20;128		; path line length.

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA,ES:DATA

PUBLIC	DSKOPN		; file open.
;*;PUBLIC DSKCRE	; file open & creat.
PUBLIC	DSKCLS		; file close.

;*;PUBLIC DSKRED	; load 1 byte data.
;*;PUBLIC DSKWRT	; save 1 byte data.

PUBLIC	DSKLD		; load data.
PUBLIC	DSKLDX		; load data DTA.
PUBLIC	DSKDTL		; load DTA to user memory.

;*;PUBLIC DSK600	; ＤＴＡの最大バイト数ロード（高速処理用）

PUBLIC	DSKOPNT		; temp file open.
PUBLIC	DSKLDT		; temp load data.
PUBLIC	DSKSVT		; temp save data.

PUBLIC	DSKRESET	; disk reset.


EXTRN	DKCCHK:NEAR	; ディスクチェンジチェック
EXTRN	TXTBOX:NEAR	; テキスト属性ＢＯＸセット


;*;;	load 1 byte data.
;*;;	-O- AL : 1 byte data
;*;;	    AH : 0:normal  1:E.O.F
;*;
;*;DSKRED	PROC	NEAR
;*;
;*;	PUSH	DS
;*;
;*;	PUSH	AX
;*;	MOV	AX,SEGDOS	; DOS interface segment.
;*;	MOV	DS,AX
;*;	POP	AX
;*;
;*;	CALL	DSKREAD
;*;
;*;	POP	DS
;*;	RET
;*;DSKRED	ENDP
;*;
;*;
;*;;	save 1 byte data.
;*;;	-I- AL : 1 byte data
;*;;	-O- AH : 0:normal  1:write error
;*;
;*;DSKWRT	PROC	NEAR
;*;
;*;	PUSH	DS
;*;
;*;	PUSH	AX
;*;	MOV	AX,SEGDOS	; DOS interface segment.
;*;	MOV	DS,AX
;*;	POP	AX
;*;
;*;	CALL	DSKWRITE
;*;
;*;	POP	DS
;*;	RET
;*;DSKWRT	ENDP


;	load data.
;	-i- SI : file name.
;		NULL = end of string.
;	    DX : dest segment address.
;	    DI : dest offset  address.
;	    CX : data length.
;	-o- AX : 0:normal,1:error.

DSKLD	PROC	NEAR
	CALL	DSKOPN
	CMP	AX,2			; 2:load Ex,memory.
	JE	DSKLD_EMEM		;
	CMP	AX,0			; 1:open error.
	JNE	DSKLD_ERROR		;

	CALL	READMOVE		; read & move.
	CMP	AX,0			; 1:error.
	JNE	DSKLD_ERROR		;

	CALL	DSKCLS			; file close.
	MOV	AX,0			; normal end.
DSKLD_EXIT:
	MOV	AX,0			; 0:normal.
	RET
DSKLD_ERROR:
	MOV	AX,1			; 1:error.
	RET
DSKLD_EMEM:
	CALL	EMEMMOVE		; Expanded memory move.
	MOV	AX,0			; 0:normal.
	RET
DSKLD	ENDP


;	Expanded memory move.
;	-I- SEGDOS:DTA  : source buffer.
;	    DX:DI       : dest buffer.
;	    CX          : count.

EMEMMOVE	PROC	NEAR
	PUSH	DS
	PUSH	ES
	PUSH	SI
	PUSH	CX
	MOV	ES,DX			; dest address.
	MOV	SI,DTA			; source address.
	MOV	AX,SEGDOS		; DOS interface segment.
	MOV	DS,AX			;
	REP	MOVSB			;
	POP	CX
	POP	SI
	POP	ES
	POP	DS
	RET
EMEMMOVE	ENDP


;	load data DTA.
;	-i- SI    : file name.
;		    NULL = end of string.
;	    CX    : data length.
;	-o- AX    : 0:normal,1:error.
;	    ES:DI : data buffer address.
;	    CX    : byte length.

DSKLDX	PROC	NEAR
	CALL	DSKOPN			; file open.
	CMP	AX,2			; 2:load Ex,memory.
	JE	DSKLDX_EXIT		; normal end.
	CMP	AX,0			; 0:normal,1:open error.
	JNE	DSKLDX_ERROR		;

	CALL	READDATA		; read data.
	CMP	AX,0			; 1:error.
	JNE	DSKLDX_ERROR		;

	PUSH	CX			; byte length.
	CALL	DSKCLS			; file close.
	POP	CX			;
DSKLDX_EXIT:
	MOV	AX,0			; 0:normal.
	MOV	ES,SEGDOS		; DOS interface segment.
	MOV	DI,DTA			; data.
	RET
DSKLDX_ERROR:
	MOV	CX,0			; byte length.
	MOV	AX,1			; 1:error.
	MOV	ES,SEGDOS		; DOS interface segment.
	MOV	DI,DTA			; data.
	RET
DSKLDX	ENDP


;	temp load data.
;	-i- SI : file name.
;		NULL = end of string.
;	    DX : dest segment address.
;	    DI : dest offset  address.
;	    CX : data length.
;	-o- AX : 0:normal,1:error.

DSKLDT	PROC	NEAR
	CALL	DSKOPNT			; temp file open.
	CMP	AX,0
	JNE	DSKLDT_ERROR

	CALL	READMOVE		; read & move.
	CMP	AX,0			; 1:error.
	JNE	DSKLDT_ERROR		;

	CALL	DSKCLS			; file close.
DSKLDT_EXIT:
	MOV	AX,0			; 0:normal.
	RET
DSKLDT_ERROR:
	MOV	AX,1			; 1:error.
	RET
DSKLDT	ENDP



;	temp save data.
;	-i- SI : file name.
;		NULL = end of string.
;	    DX : source segment address.
;	    DI : source offset  address.
;	    CX : data length.
;	-o- AX : 0:normal,1:error.

DSKSVT	PROC	NEAR
	CALL	DSKCRET			; temp file open & creat.
	CMP	AX,0
	JNE	DSKSVT9

	CALL	WRITEMOVE		; move & write.

	CALL	DSKCLS			; file close.
	MOV	AX,0			; normal end.
DSKSVT9:
	RET
DSKSVT	ENDP



;	file open.
;	-i- DS:SI : file name.
;	    NULL = end of string.
;	-o- AX    : 0:normal,1:open error,2:load Ex,memory.

DSKOPN	PROC	NEAR
	PUSH	ES
	PUSH	DS
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	DI
	PUSH	SI

	CALL	EMEM_TO_DTA		; Expanded memory to DTA.
	CMP	AX,0			; 0=normal
	JE	DSKOPN_EMEMORY		;

	CALL	DKCCHK			; ディスクチェンジチェック
	CMP	AX,1			; 0=文字列見つかった, 1=見つからない
	JE	DSKOPN_NOTFOUND		;

	CALL	DSKOPNT			; temp file open.
	CMP	AX,1			; 0:normal. / 1:open error.
	JE	DSKOPN_ERROR		;

DSKOPN_NORMAL:				;
	MOV	AX,0			; normal.
	JMP	DSKOPN_EXIT		;
DSKOPN_NOTFOUND:
	MOV	AX,1			; open error.
	JMP	DSKOPN_EXIT		;
DSKOPN_EMEMORY:
	MOV	AX,2			; 2=load Ex,memory.
	JMP	DSKOPN_EXIT		;
DSKOPN_ERROR:
	CALL	OPEN_ERROR_MESSAGE	; open error message.
	MOV	AX,1			; open error.
DSKOPN_EXIT:
	POP	SI
	POP	DI
	POP	DX
	POP	CX
	POP	BX
	POP	DS
	POP	ES
	RET
DSKOPN	ENDP


;	open error message.
;	-i- DS:SI : file name.

OPEN_ERROR_MESSAGE	PROC	NEAR
	PUSH	SI		;
	PUSH	VX1		; source point x1.
	PUSH	VY1		; source point y1.
	PUSH	VX2		; length x2.
	PUSH	VY2		; length y2.

	PUSH	SI		;

	MOV	VX1,0		; source point x1.
	MOV	VY1,0		; source point y1.
	MOV	VX2,40		; length x2.
	MOV	VY2,3		; length y2.
	MOV	DX,ATR_MSGBOX	;
	CALL	TXTBOX		; テキスト属性ＢＯＸセット
	CALL	CLS		;

	POP	SI		;

	PR	"大変！　ディスク上にファイルが見つかりません file="
	CALL	PRINT		;
	LF			;

	POP	VY2		; length y2.
	POP	VX2		; length x2.
	POP	VY1		; source point y1.
	POP	VX1		; source point x1.
	POP	SI		;
	RET
OPEN_ERROR_MESSAGE	ENDP


;	Expanded memory to DTA.
;	-O- AX : 0=normal,1=error,2=undef.

EMEM_TO_DTA	PROC	NEAR
	CALL	EMEMQUICK		; Expanded memory data name search.
	CMP	AX,0			; search flag 1=ok,0=undefined.
	JE	EMEM_TO_DTA_UNDEF	;

	PUSH	CX			; data length.
	PUSH	DI			; dest offset.
	MOV	CX,DTALEN		; DTA length.
	MOV	ES,SEGDOS		; DOS interface segment.
	MOV	DI,DTA			;
	MOV	AL,0			; zero clear.
	REP	STOSB			;
	POP	DI			;
	POP	CX			;

	MOV	ES,SEGDOS		; DOS interface segment.
	MOV	DI,DTA			; data buffer.
	CALL	EMEMLOAD		; (far)Expanded memory data load.
	CMP	AX,0			; 0=normal,1=error.
	JNE	EMEM_TO_DTA_ERROR	;

EMEM_TO_DTA_EXIT:
	MOV	AX,0			; 0=normal
	RET
EMEM_TO_DTA_ERROR:
	MOV	AX,1			; 1=error
	RET
EMEM_TO_DTA_UNDEF:
	MOV	AX,2			; 2=undef
	RET
EMEM_TO_DTA	ENDP


;*;;	file open & creat.
;*;;	-i- DS:SI : file name.
;*;;	   NULL = end of string.
;*;;	-o- AX : 0:normal,1:open error.
;*;
;*;DSKCRE	PROC	NEAR
;*;	PUSH	DS
;*;	PUSH	DX
;*;	PUSH	DI
;*;	PUSH	CX
;*;
;*;	CALL	DKCCHK			; ディスクチェンジチェック
;*;	CMP	AX,1			; 0=文字列見つかった, 1=見つからない
;*;	JE	DSKCRE_NOTFOUND		;
;*;
;*;	CALL	DSKCRET			; temp file open & creat.
;*;
;*;	POP	CX
;*;	POP	DI
;*;	POP	DX
;*;	POP	DS
;*;	RET
;*;DSKCRE_NOTFOUND:			;
;*;	MOV	AX,1			; open error.
;*;	POP	CX
;*;	POP	DI
;*;	POP	DX
;*;	POP	DS
;*;	RET
;*;DSKCRE	ENDP


;	temp file open.
;	-i- DS:SI : file name.
;	    NULL = end of string.
;	-o- AX    : 0:normal,1:open error.

DSKOPNT	PROC	NEAR
	PUSH	DS
	PUSH	DX
	PUSH	DI
	PUSH	CX
	MOV	DX,DS			; user DS segment.

	MOV	AX,SEGDOS		; DOS interface segment.
	MOV	DS,AX			;

	CALL	FNSET			; file name set.
	CALL	open			;
	JC	DSKOPNT9		; if ( open error ) then exit

	MOV	DS:[RECORD_SIZE],WORD PTR BUFFLEN	; byte/record.
	MOV	DS:[FLAG_WRITE],WORD PTR 0		; write flag.
	MOV	DS:[BPOINT],	WORD PTR 0		; buffer pointer.

	MOV	AX,0			; normal.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKOPNT9:
	MOV	AX,1			; open error.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKOPNT	ENDP


;	temp file open & creat.
;	-i- DS:SI : file name.
;	   NULL = end of string.
;	-o- AX : 0:normal,1:open error.

DSKCRET	PROC	NEAR
	PUSH	DS
	PUSH	DX
	PUSH	DI
	PUSH	CX

	MOV	DX,DS			; user DS segment.

	MOV	AX,SEGDOS		; DOS interface segment.
	MOV	DS,AX			;

	CALL	FNSET			; file name set.
	CALL	creat			;
	JC	DSKCRET9		; if ( open error ) then exit

	MOV	DS:[RECORD_SIZE],WORD PTR BUFFLEN	; byte/record.
	MOV	DS:[FLAG_WRITE],WORD PTR 0		; write flag.
	MOV	DS:[BPOINT],	WORD PTR 0		; buffer pointer.

	MOV	AX,0			; normal.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKCRET9:
	CALL	close
	MOV	AX,1			; open error.

	POP	CX
	POP	DI
	POP	DX
	POP	DS
	RET
DSKCRET	ENDP



;	file close.
;	-O- AH : 0:normal  1:write error

DSKCLS	PROC	NEAR
	PUSH	DS

	MOV	AX,SEGDOS		; DOS interface segment.
	MOV	DS,AX

	CMP	DS:[FLAG_WRITE],WORD PTR 0	; write flag.
	JE	DSKCLS5

	CALL	write			;

	MOV	DS:[FLAG_WRITE],WORD PTR 0	; write flag.

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



;*;;	file read 1 byte data.
;*;;
;*;;	-O- AL : 1 byte data
;*;;	    AH : 0:normal  1:E.O.F
;*;
;*;DSKREAD	PROC	NEAR
;*;	PUSH 	CX
;*;
;*;IF	ONE_BYTE_RW			; 1 byte rread/write.
;*;
;*;	CALL	read			;
;*;	JC	DSKREAD9		; disk error.
;*;	CMP	AX,0			; if ( E.O.F ) then exit
;*;	JE	DSKREAD9		;
;*;
;*;	MOV	AL,BYTE PTR DS:[DTA]	; AL = DTA[ 0 ]
;*;
;*;	JMP	DSKREAD8		;
;*;ENDIF
;*;	
;*;DSKREAD_START:
;*;
;*;	CMP	DS:[BPOINT],WORD PTR 0
;*;	JZ	DSKREAD2
;*;
;*;	MOV	AX,DS:[RECORD_SIZE]	; 1 record data length.
;*;	CMP	AX,DS:[BPOINT]		; read addres check.
;*;	JNBE	DSKREAD5		; if buffer empty then ...
;*;
;*;DSKREAD2:
;*;	CALL	BUFFER_CLEAR		; buffer 0 clear.
;*;	CALL	read			;
;*;	JC	DSKREAD9		; disk error.
;*;	CMP	AX,0			; if ( E.O.F ) then exit
;*;	JE	DSKREAD9		;
;*;
;*;	MOV	DS:[BPOINT],WORD PTR 0	;
;*;DSKREAD5:
;*;	MOV	BX,DS:[BPOINT]		;
;*;	MOV	AL,BYTE PTR DS:[DTA][BX]	; AL = DTA[ BPOINT ]
;*;
;*;	INC	WORD PTR DS:[BPOINT]	; read address point inc.
;*;
;*;DSKREAD8:
;*;	MOV	AH,0			; normal.
;*;
;*;	POP	CX
;*;	RET
;*;
;*;DSKREAD9:
;*;	MOV	AH,1			; E.O.F
;*;
;*;	POP	CX
;*;	RET
;*;DSKREAD	ENDP
;*;
;*;
;*;;	file write 1 byte data.
;*;;
;*;;	-I- AL : 1 byte data
;*;;	-O- AH : 0:normal  1:write error
;*;
;*;DSKWRITE	PROC	NEAR
;*;	PUSH	BX
;*;	PUSH 	CX
;*;
;*;IF	ONE_BYTE_RW			; 1 byte rread/write.
;*;
;*;	MOV	BYTE PTR DS:[DTA],AL	; DTA[ BPOINT ] = AL
;*;	CALL	write			;
;*;	JC	DSKWRITE9		; if ( write_error ) then exit
;*;	JMP	DSKWRITE8		;
;*;ENDIF
;*;
;*;	MOV	BX,DS:[BPOINT]		;
;*;	MOV	BYTE PTR DS:[DTA][BX],AL ; DTA[ BPOINT ] = AL
;*;
;*;	INC	WORD PTR DS:[BPOINT]	; read address point inc.
;*;
;*;	MOV	AX,DS:[RECORD_SIZE]	; 1 record data length.
;*;	CMP	AX,DS:[BPOINT]		; read addres check.
;*;	JNBE	DSKWRITE5		; if buffer empty then ...
;*;
;*;	CALL	write			;
;*;	JC	DSKWRITE9		; if ( write_error ) then exit
;*;
;*;	CALL	BUFFER_CLEAR		; buffer 0 clear.
;*;
;*;	MOV	DS:[BPOINT],WORD PTR 0	;
;*;
;*;	MOV	DS:[FLAG_WRITE],WORD PTR 0	; write flag.
;*;	JMP	DSKWRITE8
;*;DSKWRITE5:
;*;	MOV	DS:[FLAG_WRITE],WORD PTR 1	; write flag.
;*;DSKWRITE8:
;*;	MOV	AH,0			; normal.
;*;
;*;	POP	CX
;*;	POP	BX
;*;	RET
;*;
;*;DSKWRITE9:
;*;	MOV	AH,1			; write error.
;*;
;*;	POP	CX
;*;	POP	BX
;*;	RET
;*;
;*;DSKWRITE	ENDP
;*;
;*;
;*;
;*;;	ＤＴＡの最大バイト数ロード（高速処理用）
;*;
;*;DSK600	PROC	NEAR
;*;	PUSH	AX
;*;	PUSH	BX
;*;	PUSH	CX
;*;	PUSH	DX
;*;	PUSH	ES
;*;	PUSH	DS
;*;	PUSH	DI
;*;	PUSH	SI
;*;
;*;	MOV	AX,SEGDOS		; DOS interface segment.
;*;	MOV	DS,AX			;
;*;	MOV	DS:[RECORD_SIZE],WORD PTR DTALEN ; byte/record.
;*;
;*;	CALL	read
;*;
;*;	POP	SI
;*;	POP	DI
;*;	POP	DS
;*;	POP	ES
;*;	POP	DX
;*;	POP	CX
;*;	POP	BX
;*;	POP	AX
;*;	RET
;*;DSK600	ENDP


;	load DTA to user memory.
;	-I- DX : dest segment address.
;	    DI : dest offset  address.
;	    CX : data length.
;	-O- DX:[DI] : data.

DSKDTL	PROC	NEAR
	PUSH	DS			;
	MOV	ES,DX			; user segment.
	MOV	SI,DTA			; DTA offset.
	MOV	AX,SEGDOS		; DOS interface segment.
	MOV	DS,AX			;
	REP	MOVSB			;
	POP	DS			;
	RET
DSKDTL	ENDP


;	read & move.
;	-I- DX : dest segment address.
;	    DI : dest offset  address.
;	    CX : data length.
;	-O- DX:[DI] : data.
;	    AX : 0:normal,1:error.

READMOVE	PROC	NEAR
	PUSH	DS

	MOV	AX,SEGDOS		; DOS interface segment.
	MOV	DS,AX			;

	MOV	DS:[RECORD_SIZE],CX	; byte/record.

	PUSH	CX			; data length.
	PUSH	DX			; dest segment.
	PUSH	DI			; dest offset.
	MOV	AL,0			; zero clear.
	MOV	ES,DX			; dest address.
	REP	STOSB			;
	POP	DI			;
	POP	DX			;
	POP	CX			;

	PUSH	DX			;
	PUSH	DI			;
	CALL	read			;
	POP	DI			;
	POP	DX			;
	JC	READMOVE_ERROR		; error.

	MOV	CX,AX			;
	MOV	SI,DTA			; source address.
	MOV	ES,DX			; dest address.
	REP	MOVSB			;

READMOVE_NORMAL:
	MOV	AX,0			; 0:normal
	POP	DS			;
	RET
READMOVE_ERROR:
	MOV	AX,1			; 1:error.
	POP	DS			;
	RET
READMOVE	ENDP


;	read data.
;	-I- CX : data length.
;	-O- SEGDOS:[DTA] : data.
;	    AX : 0:normal,1:error.
;	    CX : byte length.

READDATA	PROC	NEAR
	PUSH	DS
	MOV	AX,SEGDOS
	MOV	DS,AX

	MOV	DS:[RECORD_SIZE],CX	; byte/record.

	CALL	read
	JC	READDATA_ERROR
	MOV	CX,AX			; byte length.
READDATA_EXIT:
	MOV	AX,0			; 0:normal
	POP	DS
	RET
READDATA_ERROR:
	MOV	CX,0			;
	MOV	AX,1			; 1:error.
	POP	DS
	RET
READDATA	ENDP


;	move & write.
;	-I- DX : dest segment address.
;	    DI : dest offset  address.
;	    CX : data length.
;	-O- DX:[DI] : data.

WRITEMOVE	PROC	NEAR
	PUSH	DS

	MOV	AX,SEGDOS		; DOS interface segment.
	MOV	DS,AX

	MOV	DS:[RECORD_SIZE],CX	; byte/record.

	MOV	SI,DI			; source address.

	MOV	DI,DTA			; dest address.
	PUSH	DS
	MOV	AX,DS			; DOS interface segment.
	MOV	ES,AX			; dest segment.
	MOV	DS,DX			; source segment.
	REP	MOVSB
	POP	DS

	CALL	write

	POP	DS
	RET
WRITEMOVE	ENDP


;	file name set.
;	-i- DX ; user DS segment.
;	    SI :file name.

FNSET	PROC	NEAR
	PUSH	DS
	PUSH	ES
	PUSH	SI
	PUSH	DI
	PUSH	DX
	PUSH	CX

	; path line clear.

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,PATH_LINE		; path name line.
	MOV	CX,PATH_LENGTH		; path line length.
	MOV	AL,0			;
	REP	STOSB			;

	; length check.

	MOV	ES,DX			; user data segment.
	MOV	DI,SI			; path name line.
	MOV	CX,PATH_LENGTH		; path line length.
	MOV	AL,0			;
	REPNE	SCASB			;
	MOV	CX,DI			;
	SUB	CX,SI			; CX=string length.

	PUSH	CX			;

	MOV	AX,DS			; copy string to path_line.
	MOV	ES,AX			; data segment.
	MOV	DS,DX			; user DS segment.
	MOV	DI,PATH_LINE		; path name line.
	REP	MOVSB			;

	POP	CX			;

	MOV	DI,PATH_LINE		; path name line.
	MOV	AL,' '			; space.
	REPNE	SCASB			;
	JNE	FNSET_9			;

	; "ABC     TXT" -> "ABC.TXT",0

	MOV	ES:[DI][-1],BYTE PTR '.'

	MOV	SI,DI			;

	MOV	AL,' '			; space.
	REPE	SCASB			;
	JE	FNSET_9			;

	DEC	DI			;
	INC	CX			;

	MOV	AX,ES			;
	MOV	DS,AX			;
	XCHG	SI,DI			;
	REP	MOVSB			;
FNSET_9:
	POP	CX
	POP	DX
	POP	DI
	POP	SI
	POP	ES
	POP	DS
	RET
FNSET	ENDP


;	buffer 0 clear.

BUFFER_CLEAR	PROC	NEAR
	MOV	DI,DTA			; source address.
	MOV	AX,DS			;
	MOV	ES,AX			; dest address.
	MOV	AL,0			;
	MOV	CX,BUFFLEN		; buffer length.
	REP	STOSB			;
	RET
BUFFER_CLEAR	ENDP


;	disk reset.

DSKRESET	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AH,0DH		; disk reset.
	INT	21H		; dos function.
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
DSKRESET	ENDP


; file open or creat.

FOPEN	PROC	NEAR
	CALL	open
	JNC	FOPEN1
	CALL	creat
FOPEN1:	RET
FOPEN	ENDP

open	PROC	NEAR
	CALL	ACESON			; access flag set.

	MOV	DX,PATH_LINE		;
	MOV	AL,0			; read mode.
	MOV	AH,3DH
	INT	21H
	MOV	DS:[FILE_HANDLE],AX

	CALL	ACESOFF			; access flag reset.
	RET
open	ENDP

creat	PROC	NEAR
	CALL	ACESON			; access flag set.

	MOV	DX,PATH_LINE		;
	MOV	CX,0			; file attribute.
	MOV	AH,3CH
	INT	21H
	MOV	DS:[FILE_HANDLE],AX

	CALL	ACESOFF			; access flag reset.
	RET
creat	ENDP

close	PROC	NEAR
	CALL	ACESON			; access flag set.

	MOV	BX,DS:[FILE_HANDLE]
	MOV	AH,3EH
	INT	21H

	CALL	ACESOFF			; access flag reset.
	RET
close	ENDP

read	PROC	NEAR
	CALL	ACESON			; access flag set.

	MOV	CX,DS:[RECORD_SIZE]	; 1 record data length.
	MOV	BX,DS:[FILE_HANDLE]
	MOV	DX,DTA
	MOV	AH,3FH
	INT	21H

	CALL	ACESERR			; access error message.
	CALL	ACESOFF			; access flag reset.
	RET
read	ENDP

write	PROC	NEAR
	CALL	ACESON			; access flag set.

	MOV	CX,DS:[RECORD_SIZE]	; 1 record data length.
	MOV	BX,DS:[FILE_HANDLE]
	MOV	DX,DTA
	MOV	AH,40H
	INT	21H

	CALL	ACESOFF			; access flag reset.
	RET
write	ENDP


;	access flag set.

ACESON	PROC	NEAR
	PUSH	ES
	PUSH	AX
	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	MOV	ES:DOSACS,1	; DOS access flag. 1=now access.
	POP	AX
	POP	ES
	RET
ACESON	ENDP

;	access flag reset.

ACESOFF	PROC	NEAR
	PUSH	ES
	PUSH	AX
	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	MOV	ES:DOSACS,0	; DOS access flag. 0=nomal
	POP	AX
	POP	ES
	RET
ACESOFF	ENDP


;	access error message.

ACESERR	PROC	NEAR
	RET	;******
;*;	JNB	ACESERR_SKIP
;*;	PUSH	DS
;*;	PUSH	AX
;*;	PUSH	CX
;*;
;*;	MOV	AX,SEG DATA	;
;*;	MOV	DS,AX		;
;*;	PRF	"read error."
;*;
;*;	MOV	CX,5000		; time interval.
;*;ACESERR_LOOP:
;*;	PUSH	ES
;*;	NOP
;*;	POP	ES
;*;	LOOP	ACESERR_LOOP
;*;
;*;	POP	CX
;*;	POP	AX
;*;	POP	DS
;*;ACESERR_SKIP:
	RET
ACESERR	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	DOSACS			; DOS access flag. 0=nomal,1=now access.
DOSACS	DW	0		;

EXTRN	SEGDOS:WORD		; DOS interface segment.

EXTRN	VX1:WORD		; source point x1.エラーメッセージ用
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

DATA	ENDS

	END
;
;	end of "DISKIO.ASM"
;
