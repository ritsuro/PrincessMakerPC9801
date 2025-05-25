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

;	NEAR call.

PUBLIC	EMSCHK		; EMS check.
PUBLIC	EMSOPN		; EMS open.
PUBLIC	EMSCLS		; EMS close.
PUBLIC	EMSSEK		; EMS seek.

EXTRN	EMMCHK:NEAR			; EMM check.
EXTRN	EMM_G_S:NEAR			; EMM Get Status.
EXTRN	EMM_G_P_FA:NEAR			; EMM Get Page Frame Address.
EXTRN	EMM_G_U_PC:NEAR			; EMM Get Unallocated Page Count.
EXTRN	EMM_A_P:NEAR			; EMM Allocate Pages.
EXTRN	EMM_MU_H_P:NEAR			; EMM Map/Unmap Handle Pages.
EXTRN	EMM_D_P:NEAR			; EMM Deallocate Pages.


;	EMS check.
;	-O- AX : 0=normal,1=EMS none,2=memory full,3=error
;	    BX : free page counter.

EMSCHK	PROC	NEAR
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
;	-O- AX : 0=normal,1=EMS none,2=memory full,3=error

EMSOPN	PROC	NEAR
	PUSH	DS
	MOV	AX,SEG EMMDAT
	MOV	DS,AX

	MOV	EMS_ON_FLAG,0		; EMS flag(1=on,0=off)

	CALL	EMSCHK			; EMS check.
	CMP	AX,0			; 0=normal
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

EMSCLS	PROC	NEAR
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


;	EMS seek.
;	-I- BX : page number.
;	-O- ES : fream segment.
;	    AX : 0=none,3=error

EMSSEK	PROC	NEAR
	PUSH	DS
	MOV	AX,SEG EMMDAT
	MOV	DS,AX

	CMP	EMS_ON_FLAG,1		; EMS flag(1=on,0=off)
	JNE	EMSSEK_ERROR		;

	CALL	EMM_MU_H_P		; EMM Map/Unmap Handle Pages.
	CMP	AX,0			; EMM status (0=normal,0<>error)
	JNE	EMSSEK_ERROR		;

EMSSEK_NORMAL:
	MOV	ES,EMM_PAGE_FREAM_SEG	; EMM page fream segment.
	MOV	AX,0			; 0=normal.
	POP	DS
	RET
EMSSEK_ERROR:
	MOV	ES,EMM_PAGE_FREAM_SEG	; EMM page fream segment.
	MOV	AX,3			; 3=error.
	POP	DS
	RET
EMSSEK	ENDP

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