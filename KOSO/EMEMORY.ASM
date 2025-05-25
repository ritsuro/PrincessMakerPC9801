; "EMEMORY.ASM" PC-9801UV11 make by R.H 1990/12/29
;
;	Expanded memory i/o.
;
; public subroutine.

DEBUG_FLAG_1	EQU	0		; debug flag no.1
DEBUG_FLAG_2	EQU	0		; debug flag no.2
DTALEN		EQU	65534-128-10	; DTA length.(DISKIO.ASM)

;
; data file file name "NAMEFILE.EMS"
; data file format.
;
;		|.filename    .size   CL|
;		|0         1  .      2RF|
;		|01234567890123456789012|
;		|	width 21+2=23   |
;		|BTN      PT1     8002))|
;		|BTNSCD   PT1     1192))|
;		|BTNSCW   PT1     1764))|
;		|BTNWK    PT1     5988))|
;		|C1       PT1    40548))|
;		|C2       PT1    48560))|
;		|C3       PT1    47754))|

; Expanded memory page dir table.
;
;		|0.          11.12.13 .14.15 .16.17 .18.19
;		|[...12byte...][1word][1word][1work][1word]
;		|[ file name  ][e.o.s][page ][ofset][size ]


HEAD_TABLE_PAGE	EQU	0	; header table page.
DATA_START_PAGE	EQU	1	; data start page.

NAME_FLNM	EQU	0	; file name colum.
NAME_FLNM_LEN	EQU	12	; file name length.
NAME_SIZE	EQU	16	; file size colum.
NAME_SIZE_LEN	EQU	5	; file size length.
NAME_NEXT	EQU	23	; next file name.

NAME_EOS	EQU	12	; name e.o.s colum.
NAME_BANK_NO	EQU	14	; page number colum.
NAME_B_OFFSET	EQU	16	; page offset colum.
NAME_B_SIZE	EQU	18	; page size colum.


INCLUDE	TSTSET.INC

;	CODE call.

CALLC	MACRO	SUB1
	LOCAL	L2
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:EMMCOD,DS:DATA
	CALL	L2
	ENDM

;	EMMCOD -> CODE

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

;	CODE -> EMMCOD

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:EMMCOD,DS:DATA
L1:
	ENDM

JMPEQ	MACRO	LBL
	LOCAL	L1
	JNE	L1
	JMP	LBL
L1:
	ENDM

JMPNE	MACRO	LBL
	LOCAL	L1
	JE	L1
	JMP	LBL
L1:
	ENDM

EMMCOD	SEGMENT	PUBLIC	'EMMCOD'

	ASSUME	CS:EMMCOD,DS:DATA

PUBLIC	EMEMCHECK		; (far)Expanded memory check.
PUBLIC	EMEMALLOC		; (far)Expanded memory allocate.
PUBLIC	EMEMDEALLOC		; (far)Expanded memory deallocate.
PUBLIC	EMEMQUICK		; (far)Expanded memory data name search.
PUBLIC	EMEMLOAD		; (far)Expanded memory data load.

EXTRN	EMSCHK:NEAR		; EMS check.
EXTRN	EMSOPN:NEAR		; EMS open.
EXTRN	EMSCLS:NEAR		; EMS close.
EXTRN	EMSSEK:NEAR		; EMS seek.


;	Expanded memory check.
;	-O- AX : 1=ok,0=Expanded memory none.

EMEMCHECK	PROC	FAR
	CALL	EMSCHK				; EMS check.
	MOV	FREE_PAGE_COUNTER,BX		; free page counter.

IF	DEBUG_FLAG_1				; debug flag no.1
	CODE_IN
	PRV	"EMSCHK FREE_PAGE_COUNTER=",FREE_PAGE_COUNTER
	PRV	"EMSCHK AX=",AX
	CODE_OUT
ENDIF
	CMP	AX,0				; 0=normal.
	JNE	EMEMCHECK_NONE			;

EMEMCHECK_OK:

IF	DEBUG_FLAG_1				; debug flag no.1
	CODE_IN
	LC	0,0
	PRV	"BX:",BX : free page counter.
	CODE_OUT
ENDIF
	MOV	AX,1				; 1=ok.
	RET
EMEMCHECK_NONE:
	MOV	AX,0				; 0=Expanded memory none.
	RET
EMEMCHECK	ENDP


;	Expanded memory allocate.
;	-O- AX : 1=ok,0=Expanded memory none.

EMEMALLOC	PROC	FAR
	MOV	EMEM_READY_FLAG,0		; Ex,memory ready flag.1=ready

	CALL	EMSOPN				; EMS open.
	CMP	AX,0				; 0=normal.
	JNE	EMEMALLOC_NONE			;

	CALL	DATA_NAME_LOAD			; data name table load.
	CMP	AX,0				; 0=normal.
	JNE	EMEMALLOC_NONE			;

	CALL	FULL_DATA_LOAD			; full data load.
	CMP	AX,0				; 0=normal.
	JNE	EMEMALLOC_NONE			;

	CALL	DEBUG_WRITE			; debug write.

EMEMALLOC_OK:
	MOV	EMEM_READY_FLAG,1		; Ex,memory ready flag.1=ready
	MOV	AX,1				; 1=ok.
	RET
EMEMALLOC_NONE:
	MOV	AX,0				; 0=Expanded memory none.
	RET
EMEMALLOC	ENDP


;	Expanded memory deallocate.

EMEMDEALLOC	PROC	FAR
	MOV	EMEM_READY_FLAG,0		; Ex,memory ready flag.1=ready
	CALL	EMSCLS				; EMS close.
	RET
EMEMDEALLOC	ENDP


;	Expanded memory data name search.
;	-I- DS:SI : data name.
;	-O- AX    : search flag 1=ok,0=undefined.
;	    DATA_NAME_TABLE_PNT : search data name pointer.

EMEMQUICK	PROC	FAR
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	ES

	CMP	EMEM_READY_FLAG,1		; Ex,memory ready flag.1=ready
	JNE	EMEMQUICK_UNDEFINED		;

	CALL	NAME_SEARCH			; name search.
	CMP	AX,0				; search flag 1=ok,0=undefined.
	JE	EMEMQUICK_UNDEFINED		;

EMEMQUICK_OK:
	MOV	AX,1				; search flag 1=ok.
	POP	ES
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	RET
EMEMQUICK_UNDEFINED:
	MOV	AX,0				; search flag 0=undefined.
	POP	ES
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	RET
EMEMQUICK	ENDP


;	Expanded memory data load.
;	-I- ES:DI               : write buffer.
;	    DATA_NAME_TABLE_PNT : search data name pointer.
;	-O- ES:[DI]             : load data.
;	    CX                  : byte length.
;	    AX                  : 0=normal,1=error.

EMEMLOAD	PROC	FAR
	PUSH	BX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	ES

	CMP	EMEM_READY_FLAG,1		; Ex,memory ready flag.1=ready
	JNE	EMEMLOAD_ERROR			;

	MOV	FILE_SEG,ES			; file data segment.
	MOV	FILE_OFS,DI			; file data address.

	MOV	BX,DATA_NAME_TABLE_PAGE		; data name table page.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	CMP	AX,0				; 0=none,3=error
	JNE	EMEMLOAD_ERROR			;

	CALL	DATA_LOADER			; data load.
	CMP	AX,0				; 0=normal,1=error.
	JNE	EMEMLOAD_ERROR			;

	MOV	CX,FILE_SIZE			; file size.
EMEMLOAD_NORMAL:
	MOV	AX,0				; 0=normal.
	POP	ES
	POP	DI
	POP	SI
	POP	DX
	POP	BX
	RET
EMEMLOAD_ERROR:
	MOV	CX,0
	MOV	AX,1				; 1=error.
	POP	ES
	POP	DI
	POP	SI
	POP	DX
	POP	BX
	RET
EMEMLOAD	ENDP


;	name search.
;	-I- DS:SI : search name.
;	-O- AX    : search flag 1=ok,0=undefined.
;	    DATA_NAME_TABLE_PNT : search data name pointer.

NAME_SEARCH	PROC	NEAR
	MOV	BX,DATA_NAME_TABLE_PAGE		; data name table page.
	PUSH	SI				;
	CALL	EMSSEK				; EMS seek.
	POP	SI				;
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	CMP	AX,0				; 0=none,3=error
	JNE	NAME_SEARCH_UNDEF		;

	MOV	DATA_NAME_TABLE_PNT,0		; data name table pointer.
	MOV	ES,FREAM_SEGMENT		; EMS fream segment.
NAME_SEARCH_LOOP:
	MOV	DI,DATA_NAME_TABLE_PNT		; data name table pointer.

	MOV	AL,ES:[DI]			;
	CMP	AL,0				; data end.
	JE	NAME_SEARCH_UNDEF		;
	CMP	AL,KILL_TAG			; data kill tag.
	JE	NAME_SEARCH_NEXT		;

	CALL	XSTRCMP				; string compare.
	JC	NAME_SEARCH_OK			; cf : on=yes,off=no.

NAME_SEARCH_NEXT:
	ADD	DATA_NAME_TABLE_PNT,NAME_NEXT	; next file name.
	JMP	NAME_SEARCH_LOOP		;

NAME_SEARCH_OK:
	MOV	AX,1			; 1=ok.
	RET
NAME_SEARCH_UNDEF:
	MOV	AX,0			; 0=undefined.
	RET
NAME_SEARCH	ENDP


;	data name table load.
;	-O- AX : 0=normal,1=error.

DATA_NAME_LOAD	PROC	NEAR
	MOV	BX,DATA_NAME_TABLE_PAGE	; data name table page.
	CALL	EMSSEK			; EMS seek.
	MOV	FREAM_SEGMENT,ES	; EMS fream segment.
	CMP	AX,0			; 0=none,3=error
	JNE	DATA_NAME_LOAD_ERROR	;

	CALL	CLEAR_PAGE		; page fream clear.

	MOV	DX,FREAM_SEGMENT	; EMS fream segment.
	MOV	DI,0			; dest offset  address.
	MOV	SI,OFFSET NAMEFILE_EMS	; file name.
	MOV	CX,DATA_NAME_TABLE_SIZE	; data name table size.
	CALLC	DSKLD			; load data.
;*;	CALLC	DSKLDT			; temp load data.
	CMP	AX,0			; 0:normal  1:error.
	JNE	DATA_NAME_LOAD_ERROR	;

DATA_NAME_LOAD_EXIT:
	MOV	AX,0			; 0=normal.
	RET
DATA_NAME_LOAD_ERROR:
	MOV	AX,1			; 1=error.
	RET
DATA_NAME_LOAD	ENDP


;	full data load.
;	-O- AX : 0=normal,1=error.

FULL_DATA_LOAD	PROC	NEAR
	MOV	WRITE_NOW_PAGE,DATA_START_PAGE	; write now page number.
	MOV	WRITE_NOW_OFST,0		; write now offset.
	MOV	DATA_NAME_TABLE_PNT,0		; data name table pointer.
FULL_DATA_LOAD_LOOP:
	CALL	NAME_GET			; file name get.
	CMP	AX,1				; 1=end.
	JE	FULL_DATA_LOAD_EXIT		;
	CMP	AX,2				; 2=error.
	JE	FULL_DATA_LOAD_ERROR		;

IF	DEBUG_FLAG_1				; debug flag no.1
	CODE_IN
	PRS	"FILE_NAME=",FILE_NAME
	PRV	"WRITE_NOW_OFST=",WRITE_NOW_OFST
	PRV	"FILE_SIZE=",FILE_SIZE
	CODE_OUT
ENDIF

	MOV	SI,OFFSET FILE_NAME		; file name.
	MOV	CX,DTALEN			; DTA length.
	CALLC	DSKLDX				; load data DTA.
	CMP	AX,0				; 0:normal,1:error.
	JNE	FULL_DATA_LOAD_KILL		;

	MOV	FILE_SIZE,CX			; file size.
	MOV	FILE_SEG,ES			; file data segment.
	MOV	FILE_OFS,DI			; file data address.

	CALL	DATA_SAVER			; data save.
	CMP	AX,0				; 0:normal,1:error.
	JNE	FULL_DATA_LOAD_EXIT		;

	CODE_IN
	LC	0,1
	MOV	SI,OFFSET FILE_NAME
	CALL	PRINT
	CODE_OUT

	JMP	FULL_DATA_LOAD_NEXT		;
FULL_DATA_LOAD_KILL:
	CALL	DATANAME_X_TAG			; data name kill tag.
FULL_DATA_LOAD_NEXT:
	ADD	DATA_NAME_TABLE_PNT,NAME_NEXT	; next file name.
	JMP	FULL_DATA_LOAD_LOOP

FULL_DATA_LOAD_EXIT:
	CALLC	CLS
	CALL	DATANAME_END			; data end.
	MOV	AX,0				; 0=normal.
	RET
FULL_DATA_LOAD_ERROR:
	CALLC	CLS
	CALL	DATANAME_END			; data end.
	MOV	AX,1				; 1=error.
	RET
FULL_DATA_LOAD	ENDP



;	file name get.
;	-I-   DATA_NAME_TABLE_PNT : data name table pointer.
;	-O-   AX                  : 0=normal,1=end,2=error.
;	      FILE_NAME           : file name.
;	      FILE_SIZE           : file size.

NAME_GET	PROC	NEAR
	MOV	BX,DATA_NAME_TABLE_PAGE	; data name table page.
	CALL	EMSSEK			; EMS seek.
	MOV	FREAM_SEGMENT,ES	; EMS fream segment.
	CMP	AX,0			; 0=none,3=error
	JMPNE	NAME_GET_ERROR		;

	MOV	ES,FREAM_SEGMENT	; EMS fream segment.
	MOV	SI,DATA_NAME_TABLE_PNT	; data name table pointer.

	CMP	ES:[SI],BYTE PTR ' '	; under space char.
	JB	NAME_GET_EMPTY		;

	ADD	SI,NAME_SIZE		; file size colum.
	MOV	DI,OFFSET FILE_NAME	; file name.
	MOV	CX,NAME_SIZE_LEN	; file size length.
	PUSH	DS			;
	MOV	AX,ES			;
	MOV	BX,DS			;
	MOV	ES,BX			;
	MOV	DS,AX			;
	REP	MOVSB			; copy.
	POP	DS			;
	MOV	ES:[DI],BYTE PTR 0	; end of string.

	MOV	SI,OFFSET FILE_NAME	; file size.
	CALLC	STRSPL			; space pless. "  123" - > "123  "
	CALLC	STRDEC			; string -> dec.
	MOV	FILE_SIZE,DX		; file size.

	MOV	CX,NAME_FLNM_LEN	; file name length.
	MOV	DI,OFFSET FILE_NAME	; file name.
	MOV	SI,DATA_NAME_TABLE_PNT	; data name table pointer.
	PUSH	DS			;
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DX,FREAM_SEGMENT	; EMS fream segment.
	MOV	DS,DX			;
	REP	MOVSB			; copy.
	POP	DS			;

	MOV	FILE_NAME[8],'.'	; separater.
	MOV	SI,OFFSET FILE_NAME	; file name.
	CALLC	STRSPD			; "file  .asm" - > "file.asm"

	MOV	CX,NAME_FLNM_LEN	; file name length.
	MOV	SI,OFFSET FILE_NAME	; file name.
	MOV	DI,DATA_NAME_TABLE_PNT	; data name table pointer.
	MOV	DX,FREAM_SEGMENT	; EMS fream segment.
	MOV	ES,DX			;
	REP	MOVSB			; copy.

	MOV	DI,DATA_NAME_TABLE_PNT	; data name table pointer.
	MOV	ES:[DI][NAME_EOS],WORD PTR 0	; name e.o.s.

NAME_GET_EXIT:
	MOV	AX,0			; 0=normal
	RET
NAME_GET_EMPTY:
	MOV	AX,1			; 1=end. 
	RET
NAME_GET_ERROR:
	MOV	AX,2			; 2=error.
	RET
NAME_GET	ENDP



;	data load.
;	-I-   DATA_NAME_TABLE_PNT : load data name.(table pointer)
;	      FREAM_SEGMENT       : EMS fream segment.
;	      FILE_SEG            : file data segment.
;	      FILE_OFS            : file data address.
;	-O-   AX                  : 0=normal,1=error.
;	      FILE_SIZE           : file size.

DATA_LOADER	PROC	NEAR

	MOV	ES,FREAM_SEGMENT		; EMS fream segment.
	MOV	DI,DATA_NAME_TABLE_PNT		; data name table pointer.

	MOV	AX,ES:[DI][NAME_BANK_NO]	; page number.
	MOV	READ_NOW_PAGE,AX		; read now page number.

	MOV	AX,ES:[DI][NAME_B_OFFSET]	; page offset colum.
	MOV	READ_NOW_OFST,AX		; read now offset.

	MOV	AX,ES:[DI][NAME_B_SIZE]		; page size colum.
	MOV	FILE_SIZE,AX			; file size.

	CALL	EMEMORY_TO_BUFFER		; Ex,memory -> buffer.
	CMP	AX,0				; 0:normal,1:error.
	JNE	DATA_LOADER_ERROR		;

DATA_LOADER_EXIT:
	MOV	AX,0			; 0=normal.
	RET
DATA_LOADER_ERROR:
	MOV	AX,1			; 1=error.
	RET
DATA_LOADER	ENDP


;	data save.
;	before open data name table page.
;	-I-   FILE_SEG            : file data segment.
;	      FILE_OFS            : file data address.
;	      FILE_SIZE           : file size.
;	      DATA_NAME_TABLE_PNT : data name table pointer.
;	-I/O- WRITE_NOW_PAGE      : write now page number.
;	      WRITE_NOW_OFST      : write now offset.
;	      FREAM_SEGMENT       : EMS fream segment.
;	-O-   AX                  : 0:normal,1:error.

DATA_SAVER	PROC	NEAR

	MOV	ES,FREAM_SEGMENT		; EMS fream segment.
	MOV	DI,DATA_NAME_TABLE_PNT		; data name table pointer.

	MOV	AX,WRITE_NOW_PAGE		; write now page number.
	MOV	ES:[DI][NAME_BANK_NO],AX	; page number.

	MOV	AX,WRITE_NOW_OFST		; write now offset.
	MOV	ES:[DI][NAME_B_OFFSET],AX	; page offset colum.

	MOV	AX,FILE_SIZE			; file size.
	MOV	ES:[DI][NAME_B_SIZE],AX		; page size colum.

	CALL	BUFFER_TO_EMEMORY		; buffer -> Ex,memory.
	CMP	AX,0				; 0:normal,1:error.
	JNE	DATA_SAVER_ERROR		;
DATA_SAVER_EXIT:
	MOV	AX,0			; 0=normal.
	RET
DATA_SAVER_ERROR:
	MOV	AX,1			; 1=error.
	RET
DATA_SAVER	ENDP


;	buffer -> Ex,memory.
;	-I-   FILE_SEG       : file data segment.
;	      FILE_OFS       : file data address.
;	      FILE_SIZE      : file size.
;	-I/O- WRITE_NOW_PAGE : write now page number.
;	      WRITE_NOW_OFST : write now offset.
;	      FREAM_SEGMENT  : EMS fream segment.
;	-O-   AX             : 0:normal,1:error.

BUFFER_TO_EMEMORY	PROC	NEAR
	CALL	DATA_LENGTH_CALC		; data length calc.

	MOV	BX,WRITE_NOW_PAGE		; write now page number.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	CMP	AX,0				; 0=none,3=error
	JNE	BUFFER_TO_EMEMORY_ERROR		;

	MOV	CX,MOVSIZ_FIRST			; move size first.
	CALL	PAGE_FREAM_WRITE		; page fream write.

	MOV	CX,MOVSIZ_FULL_COUNT		; move full size count.
	JCXZ	BUFFER_TO_EMEMORY_LP_E		;
BUFFER_TO_EMEMORY_LOOP:

	MOV	WRITE_NOW_OFST,0		; write now offset.
	INC	WRITE_NOW_PAGE			; write now page number.

	PUSH	CX				;
	MOV	BX,WRITE_NOW_PAGE		; write now page number.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	POP	CX				;
	CMP	AX,0				; 0=none,3=error
	JNE	BUFFER_TO_EMEMORY_ERROR		;

	PUSH	CX
	MOV	CX,PAGE_ONE_SIZE		; 1 page size.
	CALL	PAGE_FREAM_WRITE		; page fream write.
	POP	CX

	LOOP	BUFFER_TO_EMEMORY_LOOP
BUFFER_TO_EMEMORY_LP_E:
	CMP	MOVSIZ_LAST,0			; move size last.
	JE	BUFFER_TO_EMEMORY_EXIT		;

	MOV	WRITE_NOW_OFST,0		; write now offset.
	INC	WRITE_NOW_PAGE			; write now page number.

	MOV	BX,WRITE_NOW_PAGE		; write now page number.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	CMP	AX,0				; 0=none,3=error
	JNE	BUFFER_TO_EMEMORY_ERROR		;

	MOV	CX,MOVSIZ_LAST			; move size last.
	CALL	PAGE_FREAM_WRITE		; page fream write.

BUFFER_TO_EMEMORY_EXIT:
	MOV	AX,0				; 0=normal.
	RET
BUFFER_TO_EMEMORY_ERROR:
	MOV	AX,1				; 1=error.
	RET
BUFFER_TO_EMEMORY	ENDP


;	Ex,memory -> buffer.
;	-I-   FILE_SEG       : file data segment.
;	      FILE_OFS       : file data address.
;	      FILE_SIZE      : file size.
;	-I/O- READ_NOW_PAGE  : read now page number.
;	      READ_NOW_OFST  : read now offset.
;	      FREAM_SEGMENT  : EMS fream segment.
;	-O-   AX             : 0:normal,1:error.

EMEMORY_TO_BUFFER	PROC	NEAR
	MOV	AX,READ_NOW_OFST		; read now offset.
	MOV	WRITE_NOW_OFST,AX		; write now offset.
	CALL	DATA_LENGTH_CALC		; data length calc.

IF	DEBUG_FLAG_1				; debug flag no.1
	CODE_IN
	PRV	"MOVSIZ_FIRST=",MOVSIZ_FIRST
	PRV	"MOVSIZ_FULL_COUNT=",MOVSIZ_FULL_COUNT
	PRV	"MOVSIZ_LAST=",MOVSIZ_LAST
	PRV	"FILE_SEG=",FILE_SEG
	PRV	"FILE_OFS=",FILE_OFS
	PRV	"FILE_SIZE=",FILE_SIZE
	CODE_OUT
ENDIF
	MOV	BX,READ_NOW_PAGE		; read now page number.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	CMP	AX,0				; 0=none,3=error
	JNE	EMEMORY_TO_BUFFER_ERROR		;

	MOV	CX,MOVSIZ_FIRST			; move size first.
	CALL	PAGE_FREAM_READ			; page fream read.

	MOV	CX,MOVSIZ_FULL_COUNT		; move full size count.
	JCXZ	EMEMORY_TO_BUFFER_LP_E		;
EMEMORY_TO_BUFFER_LOOP:

	MOV	READ_NOW_OFST,0			; read now offset.
	INC	READ_NOW_PAGE			; read now page number.

	PUSH	CX				;
	MOV	BX,READ_NOW_PAGE		; read now page number.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	POP	CX				;
	CMP	AX,0				; 0=none,3=error
	JNE	EMEMORY_TO_BUFFER_ERROR		;

	PUSH	CX
	MOV	CX,PAGE_ONE_SIZE		; 1 page size.
	CALL	PAGE_FREAM_READ			; page fream read.
	POP	CX

	LOOP	EMEMORY_TO_BUFFER_LOOP
EMEMORY_TO_BUFFER_LP_E:
	CMP	MOVSIZ_LAST,0			; move size last.
	JE	EMEMORY_TO_BUFFER_EXIT		;

	MOV	READ_NOW_OFST,0			; read now offset.
	INC	READ_NOW_PAGE			; read now page number.

	MOV	BX,READ_NOW_PAGE		; read now page number.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	CMP	AX,0				; 0=none,3=error
	JNE	EMEMORY_TO_BUFFER_ERROR		;

	MOV	CX,MOVSIZ_LAST			; move size last.
	CALL	PAGE_FREAM_READ			; page fream read.

EMEMORY_TO_BUFFER_EXIT:
	MOV	AX,0				; 0=normal.
	RET
EMEMORY_TO_BUFFER_ERROR:
	MOV	AX,1				; 1=error.
	RET
EMEMORY_TO_BUFFER	ENDP


;	data length calc.
;	-I- WRITE_NOW_OFST    : write now offset.
;	    FILE_SIZE         : file size.
;	-O- MOVSIZ_FIRST      : move size first.
;	    MOVSIZ_FULL_COUNT : move full size count.
;	    MOVSIZ_LAST       : move size last.

DATA_LENGTH_CALC	PROC	NEAR
	MOV	MOVSIZ_FIRST,0		; move size first.
	MOV	MOVSIZ_FULL_COUNT,0	; move full size count.
	MOV	MOVSIZ_LAST,0		; move size last.

	MOV	AX,FILE_SIZE		; file size.
	MOV	BYTE_COUNT,AX		; byte counter.

	; if   free area size >= file size   then
	;    size first = file size
	;    exit
	; else
	;    size first = free area size
	; endif

	MOV	DX,PAGE_ONE_SIZE	; 1 page size.
	SUB	DX,WRITE_NOW_OFST	; write now offset.
					; DX=free area size.
	CMP	DX,BYTE_COUNT		; byte counter.
	JB	DATA_LENGTH_CALC_2	;

	MOV	AX,FILE_SIZE		; file size.
	MOV	MOVSIZ_FIRST,AX		; move size first.

	JMP	DATA_LENGTH_CALC_EXIT	;
DATA_LENGTH_CALC_2:
	MOV	MOVSIZ_FIRST,DX		; move size first = first page free.

	SUB	BYTE_COUNT,DX		; byte counter.

	; full size count = byte count   /   page one size
	; size last       = byte count  MOD  page one size

	MOV	AX,BYTE_COUNT		; byte counter.
	MOV	DX,0			; double word.
	MOV	BX,PAGE_ONE_SIZE	; 1 page size.
	DIV	BX			;
	MOV	MOVSIZ_FULL_COUNT,AX	; move full size count.
	MOV	MOVSIZ_LAST,DX		; move size last.

DATA_LENGTH_CALC_EXIT:
	RET
DATA_LENGTH_CALC	ENDP


;	data name kill tag.
;	-I-   DATA_NAME_TABLE_PNT : data name table pointer.

DATANAME_X_TAG	PROC	NEAR
	MOV	BX,DATA_NAME_TABLE_PAGE	; data name table page.
	CALL	EMSSEK			; EMS seek.
	MOV	FREAM_SEGMENT,ES	; EMS fream segment.
	CMP	AX,0			; 0=none,3=error
	JNE	DATANAME_X_TAG_EXIT	;

	MOV	ES,FREAM_SEGMENT	; EMS fream segment.
	MOV	DI,DATA_NAME_TABLE_PNT	; data name table pointer.
	MOV	AL,KILL_TAG		; data kill tag.
	MOV	ES:[DI],AL		;
DATANAME_X_TAG_EXIT:
	RET
DATANAME_X_TAG	ENDP


;	data end.
;	-I-   DATA_NAME_TABLE_PNT : data name table pointer.

DATANAME_END	PROC	NEAR
	MOV	BX,DATA_NAME_TABLE_PAGE	; data name table page.
	CALL	EMSSEK			; EMS seek.
	MOV	FREAM_SEGMENT,ES	; EMS fream segment.
	CMP	AX,0			; 0=none,3=error
	JNE	DATANAME_END_EXIT	;

	MOV	ES,FREAM_SEGMENT	; EMS fream segment.
	MOV	DI,DATA_NAME_TABLE_PNT	; data name table pointer.
	MOV	ES:[DI],BYTE PTR 0	; data end.
	MOV	ES:[DI][1],BYTE PTR '&'	; data end.
DATANAME_END_EXIT:
	RET
DATANAME_END	ENDP


;	page fream write.
;	-I-   FREAM_SEGMENT  : EMS fream segment.
;	      CX             : byte length.(0-65535)
;	-I/O- FILE_SEG       : file data segment.
;	      FILE_OFS       : file data address.
;	      WRITE_NOW_OFST : write now offset.

PAGE_FREAM_WRITE	PROC	NEAR
	PUSH	CX
	JCXZ	PAGE_FREAM_WRITE_EXIT

	MOV	DX,FILE_SEG		; file data segment.
	MOV	SI,FILE_OFS		; file data address.

	MOV	ES,FREAM_SEGMENT	; EMS fream segment.
	MOV	DI,WRITE_NOW_OFST	; write now offset.

	PUSH	DS
	MOV	DS,DX			; source data segment.
	REP	MOVSB			; copy.
	POP	DS

	MOV	FILE_OFS,SI		; file data address.
	MOV	WRITE_NOW_OFST,DI	; write now offset.

PAGE_FREAM_WRITE_EXIT:
	POP	CX
	RET
PAGE_FREAM_WRITE	ENDP


;	page fream read.
;	-I-   FREAM_SEGMENT  : EMS fream segment.
;	      CX             : byte length.(0-65535)
;	-I/O- FILE_SEG       : file data segment.
;	      FILE_OFS       : file data address.
;	      READ_NOW_OFST  : read now offset.

PAGE_FREAM_READ	PROC	NEAR
	PUSH	CX
	JCXZ	PAGE_FREAM_READ_EXIT

	MOV	DX,FREAM_SEGMENT	; EMS fream segment.
	MOV	SI,READ_NOW_OFST	; read now offset.

	MOV	ES,FILE_SEG		; file data segment.
	MOV	DI,FILE_OFS		; file data address.

	PUSH	DS
	MOV	DS,DX			; source data segment.
	REP	MOVSB			; copy.
	POP	DS

	MOV	FILE_OFS,DI		; file data address.
	MOV	READ_NOW_OFST,SI	; read now offset.

PAGE_FREAM_READ_EXIT:
	POP	CX
	RET
PAGE_FREAM_READ	ENDP


;	page fream clear.

CLEAR_PAGE	PROC	NEAR
	MOV	CX,PAGE_ONE_SIZE	; 1 page size.
	SHR	CX,1			; word pointer.
	MOV	ES,FREAM_SEGMENT	; EMS fream segment.
	MOV	DI,0			;
	MOV	AX,0			;
	REP	STOSW			;
	RET
CLEAR_PAGE	ENDP


;	string compare.
;	-i- DS:SI :source string.
;	    ES:DI :immediate string.
;	           NULL=end of string
;	-o- cf : on=yes,off=no.

XSTRCMP	PROC	NEAR
	PUSH	ES
	PUSH	DI
	PUSH	SI

XSTRCMP_LOOP:				;
	CMPSB				;
	JNE	XSTRCMP_CHK		; if [si]<>[di] then exit.
	CMP	BYTE PTR DS:[SI][-1],' ' ; space.
	JNBE	XSTRCMP_LOOP		; if end-of-string then exit.

XSTRCMP_CHK:
	CMP	BYTE PTR ES:[DI][-1],' ' ; space.
	JNBE	XSTRCMP_NO		; no.
	CMP	BYTE PTR DS:[SI][-1],' ' ; space.
	JNBE	XSTRCMP_NO		; no.

XSTRCMP_YES:
	STC
	JMP	XSTRCMP_9
XSTRCMP_NO:
	CLC
XSTRCMP_9:
	POP	SI
	POP	DI
	POP	ES
	RET
XSTRCMP	ENDP


;	debug write.

DEBUG_WRITE	PROC	NEAR

IF	DEBUG_FLAG_2				; debug flag no.2

	MOV	BX,DATA_NAME_TABLE_PAGE		; data name table page.
	CALL	EMSSEK				; EMS seek.
	MOV	FREAM_SEGMENT,ES		; EMS fream segment.
	CMP	AX,0				; 0=none,3=error
	JMPNE	DEBUG_WRITE_EXIT		;

	CODE_IN
	PRF	"Expanded memory page dir table."
	PRF	"[...12byte...][1word][1word][1work][1word]"
	PRF	"[ file name  ][e.o.s][page ][ofset][size ]"

	MOV	ES,FREAM_SEGMENT		; EMS fream segment.
	MOV	SI,0				;
DEBUG_WRITE_LOOP:
	CMP	ES:[SI],BYTE PTR ' '
	JNB	DEBUG_WRITE_2
	JMP	DEBUG_WRITE_LP_E
DEBUG_WRITE_2:

	PUSH	SI

	PR	"|"
	MOV	CX,12
DEBUG_WRITE_LOOP2:
	MOV	AH,ES:[SI]
	PRCH					; 1 char put.
	INC	SI
	LOOP	DEBUG_WRITE_LOOP2

	INC	SI
	INC	SI

	MOV	CX,3
DEBUG_WRITE_LOOP3:
	PR	"|"
	MOV	DX,ES:[SI]
	INC	SI
	INC	SI
	PUSH	SI
	CALL	DECSTR
	CALL	PRINT
	POP	SI
	LOOP	DEBUG_WRITE_LOOP3

	LF

	POP	SI

	ADD	SI,NAME_NEXT		; next file name.

	JMP	DEBUG_WRITE_LOOP
DEBUG_WRITE_LP_E:

	CODE_OUT
DEBUG_WRITE_EXIT:

ENDIF
	RET
DEBUG_WRITE	ENDP

EMMCOD	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

FREE_PAGE_COUNTER	DW	0	; free page counter.

EMEM_READY_FLAG		DW	0	; Ex,memory ready flag.1=ready.

DATA_NAME_TABLE_PAGE	DW HEAD_TABLE_PAGE ; data name table page.
DATA_NAME_TABLE_SIZE	DW	4000H	; data name table size.
DATA_NAME_TABLE_PNT	DW	0	; data name table pointer.

PAGE_ONE_SIZE		DW	4000H	; 1 page size.
FREAM_SEGMENT		DW	0	; EMS fream segment.

NAMEFILE_EMS		DB	"NAMEFILE.EMS",0,0	; file name.

KILL_TAG		DB	"/",0	; data kill tag.

WRITE_NOW_PAGE		DW	0	; write now page number.
WRITE_NOW_OFST		DW	0	; write now offset.

READ_NOW_PAGE		DW	0	; read now page number.
READ_NOW_OFST		DW	0	; read now offset.

FILE_NAME		DB 14 DUP (0)	; file name.
FILE_SIZE		DW	0	; file size.
FILE_SEG		DW	0	; file data segment.
FILE_OFS		DW	0	; file data address.

MOVSIZ_FIRST		DW	0	; move size first.
MOVSIZ_FULL_COUNT	DW	0	; move full size count.
MOVSIZ_LAST		DW	0	; move size last.

BYTE_COUNT		DW	0	; byte counter.

DATA	ENDS

	END
;
;	end of "EMEMORY.ASM"
;
