; "PROTECT.ASM" 1991/05/08 R.H
;
;	プロテクトチェック
;
; public subroutine.

INCLUDE	TSTSET.INC

PROTECT_DISK_NUMBER	EQU	1	; プロテクトディスク番号
PROTECT_DISK_NUMBER2	EQU	2	; プロテクトディスク番号

;voidvoidvoid

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	PROTECT_CHECK			; プロテクトチェック

EXTRN	DKCSET:NEAR			; ディスクチェンジセット

; ****************************************************
;	プロテクトチェック
; ****************************************************

PROTECT_CHECK	PROC	NEAR
	MOV	AX,PROTECT_DISK_NUMBER	; ディスク番号
	CALL	DKCSET			; ディスクチェンジセット
	MOV	AX,DX			; (DRVNUM+1)ドライブ番号(1-4)
	DEC	AX			; ユニット番号（０－３）

;voidvoidvoid

;voidvoidvoid
;voidvoidvoid
	RET
PROTECT_CHECK_ERROR:
	MOV	AX,PROTECT_DISK_NUMBER2	; プロテクトディスク番号その２
	CALL	DKCSET			; ディスクチェンジセット
	MOV	AX,DX			; (DRVNUM+1)ドライブ番号(1-4)
	DEC	AX			; ユニット番号（０－３）

;voidvoidvoid

;voidvoidvoid
;voidvoidvoid
	RET
PROTECT_CHECK_ERROR2:	;
	PRF	"このディスクは破壊されています"	; AX=",AX

	CALL	PROTECT_SHOW
	
	JMP	PROTECT_CHECK
PROTECT_CHECK	ENDP

PROTECT_SHOW	PROC	NEAR
	JMP	$
	RET
PROTECT_SHOW	ENDP

CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS

	END
;
;	end of "PROTECT.ASM"
;
