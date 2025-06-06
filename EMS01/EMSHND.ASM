; "EMSHND.ASM" PC-9801UV11 make by R.H 1991/01/02
;
;	EMS handle.
;
;
;
;
;
;
; public subroutine.


EMMCOD	SEGMENT	PUBLIC	'EMMCOD'

	ASSUME	CS:EMMCOD,DS:EMMDAT

;	FAR call.

PUBLIC	EMSCHK		; (far call)EMS check.
PUBLIC	EMSOPN		; (far call)EMS open.
PUBLIC	EMSCLS		; (far call)EMS close.
PUBLIC	EMSRED		; (far call)EMS read.
PUBLIC	EMSWRT		; (far call)EMS write.

EXTRN	EMMCHK:FAR			; EMM check.
EXTRN	EMM_G_S:FAR			; EMM Get Status.
EXTRN	EMM_G_P_FA:FAR			; EMM Get Page Frame Address.
EXTRN	EMM_G_U_PC:FAR			; EMM Get Unallocated Page Count.
EXTRN	EMM_A_P:FAR			; EMM Allocate Pages.
EXTRN	EMM_MU_H_P:FAR			; EMM Map/Unmap Handle Pages.
EXTRN	EMM_D_P:FAR			; EMM Deallocate Pages.


;	EMS check.
;	-O- AX : 0=none,1=EMS none,2=memory full,3=error
;	    BX : free page counter.

EMSCHK	PROC	FAR
	PUSH	DS
	MOV	AX,SEG EMMDAT
	MOV	DS,AX

	MOV	EMS_ON_FLAG,0		; EMS flag(1=on,0=off)

	CALL	EMMCHK			; EMM check.
	CMP	AX,0			; 0=none,1=EMMset
	JE	EMSCHK_NONE		;

	CALL	EMM_G_S			; EMM Get Status.
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSCHK_ERROR		;

	CALL	EMM_G_P_FA		; EMM Get Page Frame Address.
	MOV	EMM_PAGE_FREAM_SEG,BX	; EMM page fream segment.
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSCHK_ERROR		;

	CALL	EMM_G_U_PC		; EMM Get Unallocated Page Count.
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSCHK_ERROR		;
	CMP	BX,0			; EMM unallocated page count.
	JE	EMSCHK_MEMORY_FULL	;

EMSCHK_NORMAL:
	MOV	AX,0			; 0=normal.
	POP	DS
	RET
EMSCHK_NONE:
	MOV	BX,0			;
	MOV	AX,1			; 1=EMS none.
	POP	DS
	RET
EMSCHK_MEMORY_FULL:
	MOV	BX,0			;
	MOV	AX,2			; 2=memory full.
	POP	DS
	RET
EMSCHK_ERROR:
	MOV	BX,0			;
	MOV	AX,3			; 3=error.
	POP	DS
	RET
EMSCHK	ENDP


;	EMS open.
;	-O- AX : 0=none,1=EMS none,2=memory full,3=error

EMSOPN	PROC	FAR
	PUSH	DS
	MOV	AX,SEG EMMDAT
	MOV	DS,AX

	MOV	EMS_ON_FLAG,0		; EMS flag(1=on,0=off)

	CALL	EMSCHK			; EMS check.
	CMP	AX,0			; 0=none
	JNE	EMSOPN_EXIT		;

	CALL	EMM_A_P			; EMM Allocate Pages.
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSOPN_ERROR		;

	MOV	EMS_ON_FLAG,1		; EMS flag(1=on,0=off)
EMSOPN_NORMAL:
	MOV	AX,0			; 0=normal.
	POP	DS
	RET
EMSOPN_ERROR:
	MOV	AX,3			; 3=error.
	POP	DS
	RET
EMSOPN_EXIT:
	POP	DS
	RET
EMSOPN	ENDP


;	EMS close.
;	-O- AX : 0=none,3=error

EMSCLS	PROC	FAR
	PUSH	DS
	MOV	AX,SEG EMMDAT
	MOV	DS,AX

	CMP	EMS_ON_FLAG,1		; EMS flag(1=on,0=off)
	JNE	EMSCLS_ERROR		;

	CALL	EMM_D_P			; EMM Deallocate Pages.
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSCLS_ERROR		;

EMSCLS_NORMAL:
	MOV	AX,0			; 0=normal.
	POP	DS
	RET
EMSCLS_ERROR:
	MOV	AX,3			; 3=error.
	POP	DS
	RET
EMSCLS	ENDP


;	EMS read.(16kbyte)
;	-I- ES:DI   : data buffer address.
;	    BX      : page number.
;	-O- ES:[DI] : data buffer.
;	    AX      : 0=none,3=error

EMSRED	PROC	FAR
	PUSH	DS
	MOV	AX,SEG EMMDAT
	MOV	DS,AX

	CMP	EMS_ON_FLAG,1		; EMS flag(1=on,0=off)
	JNE	EMSRED_ERROR		;

	PUSH	ES			;
	PUSH	DI			;
	CALL	EMM_MU_H_P		; EMM Map/Unmap Handle Pages.
	POP	DI			;
	POP	ES			;
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSRED_ERROR		;

	PUSH	DS			;
	MOV	AX,EMM_PAGE_FREAM_SEG	; EMM page fream segment.
	MOV	DS,AX			;
	MOV	SI,0			;
	MOV	CX,4000H/2		; 16kbyte
	REP	MOVSW			;
	POP	DS			;

EMSRED_NORMAL:
	MOV	AX,0			; 0=normal.
	POP	DS
	RET
EMSRED_ERROR:
	MOV	AX,3			; 3=error.
	POP	DS
	RET
EMSRED	ENDP


;	EMS write.(16kbyte)
;	-I- DX:[SI] : data buffer.
;	    BX      : page number.
;	-O- AX      : 0=none,3=error

EMSWRT	PROC	FAR
	PUSH	DS
	MOV	AX,SEG EMMDAT
	MOV	DS,AX

	CMP	EMS_ON_FLAG,1		; EMS flag(1=on,0=off)
	JNE	EMSWRT_ERROR		;

	PUSH	DS			;
	MOV	AX,EMM_PAGE_FREAM_SEG	; EMM page fream segment.
	MOV	ES,AX			;
	MOV	DI,0			;
	MOV	DS,DX			;
	MOV	CX,4000H/2		; 16kbyte
	REP	MOVSW			;
	POP	DS			;

	PUSH	ES			;
	PUSH	DI			;
	CALL	EMM_MU_H_P		; EMM Map/Unmap Handle Pages.
	POP	DI			;
	POP	ES			;
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSWRT_ERROR		;
EMSWRT_NORMAL:
	MOV	AX,0			; 0=normal.
	POP	DS
	RET
EMSWRT_ERROR:
	MOV	AX,3			; 3=error.
	POP	DS
	RET
EMSWRT	ENDP


EMMCOD	ENDS



EMMDAT	SEGMENT	PUBLIC	'EMMDAT'

EMS_ON_FLAG		DW	0	; EMS flag(1=on,0=off)
EMM_PAGE_FREAM_SEG	DW	0	; EMM page fream segment.

EMMDAT	ENDS

	END
;
;	end of "EMSHND.ASM"
;
