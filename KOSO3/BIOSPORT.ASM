; "BIOSPORT.ASM" PC-9801UV11 make by R.H 1991/01/17
;
;	BIOS port.
;
;	EXTRN	INT_FDISK_BIOS:FAR	; (far) disk/FD bios.
;
;	INT_FD_BIOS	MACRO		; disk/FD bios.
;	;same;	INT	1BH		; disk bios.
;		CALL	INT_FDISK_BIOS	; (far) disk/FD bios.
;		ENDM
;
;	example./ MACRO set.

TIME_WAIT	EQU	60*11			; wait time.

EXTRN	TMVJST_FAR:FAR		; (far) V-SYNC timer jump set.
EXTRN	TMVJRS_FAR:FAR		; (far) V-SYNC timer jump reset.

BIOSPORT	SEGMENT	PUBLIC	'BIOSPORT'

	ASSUME	CS:BIOSPORT,DS:DATA

	PUBLIC	INT_FDISK_BIOS		; (far) disk/FD bios.

PACH_LABEL	DB	"BIOSPORTver0.0"

;	(far) disk/FD bios.

INT_FDISK_BIOS	PROC	FAR
	CALL	PUSH_ALL
	MOV	AX,TIME_WAIT				; wait time.
	MOV	SI,SS					; save SS
	MOV	BX,SP					; save SP
	MOV	CX,SEG BIOSPORT				; jump CS
	MOV	DX,OFFSET INT_FDISK_BIOS_TIME_OVER	; jump IP
							; DS : save DS
	CALL	TMVJST_FAR		; (far) V-SYNC timer jump set.
	CALL	POP_ALL

	INT	1BH			; DISK BIOS.

	PUSHF
	CALL	PUSH_ALL
	CALL	TMVJRS_FAR		; (far) V-SYNC timer jump reset.
	CALL	POP_ALL
	POPF
	RET
INT_FDISK_BIOS	ENDP


;	FD bios time over.

INT_FDISK_BIOS_TIME_OVER	PROC	FAR
	MOV	AX,0A000H			;
	MOV	ES,AX				; text segment
	MOV	BX,80*2*24+2*2
	MOV	BYTE PTR ES:[BX][0],'B'		; text offset
	MOV	BYTE PTR ES:[BX][2],'I'		; text offset
	MOV	BYTE PTR ES:[BX][4],'O'		; text offset
	MOV	BYTE PTR ES:[BX][6],'S'		; text offset
	MOV	BYTE PTR ES:[BX][10],'ﾊ'	; text offset
	MOV	BYTE PTR ES:[BX][12],'ﾞ'	; text offset
	MOV	BYTE PTR ES:[BX][14],'ｸ'	; text offset
	MOV	BYTE PTR ES:[BX][16],'ﾞ'	; text offset

	CALL	POP_ALL
	MOV	AH,60H		; not ready.
	STC			; error.
	RET
INT_FDISK_BIOS_TIME_OVER	ENDP


; ***************************************************************
;	ＰＵＳＨＡ／ＰＯＰＡ
; ***************************************************************

;	ＰＵＳＨＡＬＬ
;	-O- SAVE_DS : ユーザレジスタＤＳ
;	    SAVE_AX : ユーザレジスタＡＸ
;	    SAVE_BX : ユーザレジスタＢＸ
;	    SAVE_CX : ユーザレジスタＣＸ
;	    SAVE_DX : ユーザレジスタＤＸ
;	    SAVE_DI : ユーザレジスタＤＩ
;	    SAVE_SI : ユーザレジスタＳＩ
;	    SAVE_BP : ユーザレジスタＢＰ
;	    DS      : ＤＡＴＡセグメント
;		ＤＳ以外のレジスタはユーザの値が保証される。

PUSH_ALL	PROC	NEAR
	PUSH	ES
	PUSH	AX
	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	ES:SAVE_DS,DS
	MOV	DS,AX
	POP	AX
	POP	ES

	MOV	SAVE_ES,ES
	MOV	SAVE_AX,AX
	MOV	SAVE_BX,BX
	MOV	SAVE_CX,CX
	MOV	SAVE_DX,DX
	MOV	SAVE_DI,DI
	MOV	SAVE_SI,SI
	MOV	SAVE_BP,BP

	RET
PUSH_ALL	ENDP


;	ＰＯＰＡＬＬ
;	-I- SAVE_DS : ユーザレジスタＤＳ
;	    SAVE_AX : ユーザレジスタＡＸ
;	    SAVE_BX : ユーザレジスタＢＸ
;	    SAVE_CX : ユーザレジスタＣＸ
;	    SAVE_DX : ユーザレジスタＤＸ
;	    SAVE_DI : ユーザレジスタＤＩ
;	    SAVE_SI : ユーザレジスタＳＩ
;	    SAVE_BP : ユーザレジスタＢＰ

POP_ALL		PROC	NEAR
	PUSH	DS

	PUSH	AX
	MOV	AX,SEG DATA
	MOV	DS,AX
	POP	AX

	MOV	ES,SAVE_ES
	MOV	AX,SAVE_AX
	MOV	BX,SAVE_BX
	MOV	CX,SAVE_CX
	MOV	DX,SAVE_DX
	MOV	DI,SAVE_DI
	MOV	SI,SAVE_SI
	MOV	BP,SAVE_BP

	POP	DS

	PUSH	ES
	PUSH	AX
	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DS,ES:SAVE_DS
	POP	AX
	POP	ES

	RET
POP_ALL		ENDP

BIOSPORT	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

SAVE_SP		DW	0		; スタックポインタ退避
SAVE_SS		DW	0		; スタックセグメント退避

SAVE_ES		DW	0		; ユーザレジスタＥＳ
SAVE_DS		DW	0		; ユーザレジスタＤＳ
SAVE_AX		DW	0		; ユーザレジスタＡＸ
SAVE_BX		DW	0		; ユーザレジスタＢＸ
SAVE_CX		DW	0		; ユーザレジスタＣＸ
SAVE_DX		DW	0		; ユーザレジスタＤＸ
SAVE_DI		DW	0		; ユーザレジスタＤＩ
SAVE_SI		DW	0		; ユーザレジスタＳＩ
SAVE_BP		DW	0		; ユーザレジスタＢＰ

DATA	ENDS
	END
;
;	end of "BIOSPORT.ASM"
;
