; "PAT32.ASM" 1991/03/12 R.H PC-9801UV11 make by R.H 1991
;
;
;	�R�Q�~�R�Q�p�^�[���o�t�s
;
;	0:�n�e�e
;	1:�n�m
;	2:�g�h
;	3:�n�m�|�s�t�b�g
;	4:�n�e�e�|�s�t�b�g
;
; public subroutine.

;	ARAVRM:WORD		; vram area.	( DEST )

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	PAT32PUT		; �R�Q�~�R�Q�p�^�[���o�t�s
PUBLIC	PAT32VRAM_LOAD		; �u�q�`�l�߂�
PUBLIC	PAT32VRAM_SAVE		; �u�q�`�l�ޔ�



ADDWIDTHCRT	EQU	80	; �J�[�\���p�v�Z
ADDWIDTH	EQU	80-4	; �J�[�\���p�v�Z
CUSLINE		EQU	32	; �J�[�\�����C����
ADDWIDTH_SV	EQU	80-4		; �G���A�ޔ�p�v�Z
CUSLINE_SV	EQU	32		; �G���A�ޔ����C����


;	�R�Q�~�R�Q�p�^�[���o�t�s
;	-I- CURX   : �J�[�\���w
;	    CURY   : �J�[�\���x
;	    CURNUM : �p�^�[���ԍ�
;		0:�n�e�e
;		1:�n�m
;		2:�g�h
;		3:�n�m�|�s�t�b�g
;		4:�n�e�e�|�s�t�b�g

PAT32PUT	PROC	NEAR
	CALL	PATCHNG			; �p�^�[���`�F���W
	CALL	VRAM_PUT		; �u�q�`�l�J�[�\���o�t�s
	RET
PAT32PUT	ENDP


;	�u�q�`�l�ޔ�
;	-I- CURX   : �J�[�\���w
;	    CURY   : �J�[�\���x

PAT32VRAM_SAVE	PROC	NEAR
	CALL	VRAM_SAVE		; �u�q�`�l�ޔ�
	RET
PAT32VRAM_SAVE	ENDP


;	�u�q�`�l�߂�

PAT32VRAM_LOAD	PROC	NEAR
	CALL	VRAM_LOAD		; �u�q�`�l�߂�
	RET
PAT32VRAM_LOAD	ENDP


;	�p�^�[���`�F���W
;	-I- CURNUM : �p�^�[���ԍ�

PATCHNG	PROC	NEAR
	CMP	CURNUM,1	;
	JE	PATCHNG_1	;
	CMP	CURNUM,2	;
	JE	PATCHNG_2	;
	CMP	CURNUM,3	;
	JE	PATCHNG_3	;
	CMP	CURNUM,4	;
	JE	PATCHNG_4	;

PATCHNG_0:				; �n�e�e
	MOV	AX,OFFSET CUSDT00
	MOV	BX,OFFSET CUSDT00+128
	MOV	CX,OFFSET CUSDT00+256
	MOV	DX,OFFSET CUSDT00+384
	MOV	DI,OFFSET CUSDT00+512
	JMP	PATCHNG_5

PATCHNG_1:				; �n�m
	MOV	AX,OFFSET CUSDT10
	MOV	BX,OFFSET CUSDT10+128
	MOV	CX,OFFSET CUSDT10+256
	MOV	DX,OFFSET CUSDT10+384
	MOV	DI,OFFSET CUSDT10+512
	JMP	PATCHNG_5

PATCHNG_2:				; �g�h
	MOV	AX,OFFSET CUSDT20
	MOV	BX,OFFSET CUSDT20+128
	MOV	CX,OFFSET CUSDT20+256
	MOV	DX,OFFSET CUSDT20+384
	MOV	DI,OFFSET CUSDT20+512
	JMP	PATCHNG_5

PATCHNG_3:				; �n�m�|�s�t�b�g
	MOV	AX,OFFSET CUSDT30
	MOV	BX,OFFSET CUSDT30+128
	MOV	CX,OFFSET CUSDT30+256
	MOV	DX,OFFSET CUSDT30+384
	MOV	DI,OFFSET CUSDT30+512
	JMP	PATCHNG_5

PATCHNG_4:				; �n�e�e�|�s�t�b�g
	MOV	AX,OFFSET CUSDT40
	MOV	BX,OFFSET CUSDT40+128
	MOV	CX,OFFSET CUSDT40+256
	MOV	DX,OFFSET CUSDT40+384
	MOV	DI,OFFSET CUSDT40+512
	JMP	PATCHNG_5

PATCHNG_5:
	MOV	ADRDAT0,AX
	MOV	ADRDAT1,BX
	MOV	ADRDAT2,CX
	MOV	ADRDAT3,DX
	MOV	CUSMSK,DI
	RET
PATCHNG	ENDP


;	�u�q�`�l�J�[�\���o�t�s
;	-I- CURX : �J�[�\���w
;	    CURY : �J�[�\���x

VRAM_PUT	PROC	NEAR
	MOV	BX,CURY		; �J�[�\���x
	SHL	BX,1		;
	SHL	BX,1		;
	SHL	BX,1		; bx = vy1 * 8

	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURX		; �J�[�\���w


	MOV	SI,CUSMSK	; �J�[�\���}�X�N
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	AX,ARAVRM[0]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT2:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT2

	MOV	AX,ARAVRM[0]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT0	; �J�[�\��
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT22:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT22


	MOV	SI,CUSMSK	; �J�[�\���}�X�N
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	AX,ARAVRM[2]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT3:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT3

	MOV	AX,ARAVRM[2]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT1	; �J�[�\��
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT33:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT33


	MOV	SI,CUSMSK	; �J�[�\���}�X�N
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	AX,ARAVRM[4]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT4:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT4

	MOV	AX,ARAVRM[4]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT2	; �J�[�\��
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT44:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT44


	MOV	SI,CUSMSK	; �J�[�\���}�X�N
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	AX,ARAVRM[6]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT5:
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	AND	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT5


	MOV	AX,ARAVRM[6]	; vram area.
	MOV	ES,AX		;
	MOV	SI,ADRDAT3	; �J�[�\��
	MOV	DI,BX		; �擪�I�t�Z�b�g
	MOV	CX,CUSLINE	; �J�[�\�����C����
VRAM_PUT55:
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	LODSW			;
	OR	WORD PTR ES:[DI],AX
	INC	DI
	INC	DI
	ADD	DI,ADDWIDTH	;
	LOOP	VRAM_PUT55

	RET
VRAM_PUT	ENDP


;	�u�q�`�l�ޔ�

VRAM_SAVE	PROC	NEAR
	PUSH	DS

	MOV	BX,CURY		; �J�[�\���x
	SHL	BX,1		;
	SHL	BX,1		;
	SHL	BX,1		; bx = vy1 * 8

	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURX		; �J�[�\���w

	MOV	SI,BX		; �擪�I�t�Z�b�g

	MOV	DI,OFFSET VRMSAV0	; �u�q�`�l�ޔ��G���A

	MOV	AX,DS		; �f�[�^�Z�O�����g
	MOV	ES,AX		;

	MOV	DX,DS

	MOV	AX,ARAVRM[0]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_SAVE2:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_SAVE2

	MOV	SI,BX		; �擪�I�t�Z�b�g

	MOV	DS,DX		;

	MOV	AX,ARAVRM[2]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_SAVE3:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_SAVE3

	MOV	SI,BX		; �擪�I�t�Z�b�g

	MOV	DS,DX		;

	MOV	AX,ARAVRM[4]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_SAVE4:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_SAVE4

	MOV	SI,BX		; �擪�I�t�Z�b�g

	MOV	DS,DX		;

	MOV	AX,ARAVRM[6]	; vram area.
	MOV	DS,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_SAVE5:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	SI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_SAVE5

	POP	DS

	MOV	AX,CURX		; �J�[�\���w
	MOV	BX,CURY		; �J�[�\���x
	MOV	CURXBAK,AX	; �J�[�\���w
	MOV	CURYBAK,BX	; �J�[�\���x
	RET
VRAM_SAVE	ENDP



;	�u�q�`�l�߂�

VRAM_LOAD	PROC	NEAR
	MOV	BX,CURYBAK	; �J�[�\���x
	SHL	BX,1		;
	SHL	BX,1		;
	SHL	BX,1		; bx = vy1 * 8

	SHL	BX,1		;
	SHL	BX,1		;  source point.
	SHL	BX,1		;
	SHL	BX,1		;  bx = vy1 * 80 + vx1
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,CURXBAK	; �J�[�\���w

	MOV	SI,OFFSET VRMSAV0	; �u�q�`�l�ޔ��G���A

	MOV	DI,BX		; �擪�I�t�Z�b�g

	MOV	AX,ARAVRM[0]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_LOAD2:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_LOAD2

	MOV	DI,BX		; �擪�I�t�Z�b�g

	MOV	AX,ARAVRM[2]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_LOAD3:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_LOAD3

	MOV	DI,BX		; �擪�I�t�Z�b�g

	MOV	AX,ARAVRM[4]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_LOAD4:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_LOAD4

	MOV	DI,BX		; �擪�I�t�Z�b�g

	MOV	AX,ARAVRM[6]	; vram area.
	MOV	ES,AX		;
	MOV	CX,CUSLINE_SV	; �G���A�ޔ����C����
VRAM_LOAD5:
	MOVSW			;
	MOVSW			;
;*;	MOVSB			;
	ADD	DI,ADDWIDTH_SV	; �G���A�ޔ�p�v�Z

	LOOP	VRAM_LOAD5

	RET
VRAM_LOAD	ENDP


; ****************************************************
;	DATA
; ****************************************************
	EVEN

EXTRN	ARAVRM:WORD		; vram area.

PUBLIC	CURNUM			; �p�^�[���ԍ�
PUBLIC	CURX			; �R�Q�~�R�Q�p�^�[���w
PUBLIC	CURY			; �R�Q�~�R�Q�p�^�[���x

CURNUM	DW	0		; �p�^�[���ԍ�
CURX	DW	0		; �R�Q�~�R�Q�p�^�[���w
CURY	DW	0		; �R�Q�~�R�Q�p�^�[���x
CURXBAK	DW	0		; �J�[�\���w
CURYBAK	DW	0		; �J�[�\���x

ADRDAT0	DW	CUSDT10
ADRDAT1	DW	CUSDT10+128
ADRDAT2	DW	CUSDT10+256
ADRDAT3	DW	CUSDT10+384
CUSMSK	DW	CUSDT10+512

VRMSAV0 DB	40*5 DUP (?)		; �u�q�`�l�ޔ��G���A
VRMSAV1	DB	40*5 DUP (?)		;
VRMSAV2	DB	40*5 DUP (?)		;
VRMSAV3	DB	40*5 DUP (?)		;

	; �n�e�e
CUSDT00		LABEL	BYTE
	INCLUDE	P32OFF.INC

	; �n�m
CUSDT10		LABEL	BYTE
	INCLUDE	P32ON.INC

	; �g�h
CUSDT20		LABEL	BYTE

	; �n�m�|�s�t�b�g
CUSDT30		LABEL	BYTE
	INCLUDE	P32ONT.INC

	; �n�e�e�|�s�t�b�g
CUSDT40		LABEL	BYTE
	INCLUDE	P32OFT.INC


CODE	ENDS

	END
;
;	end of "PAT32.ASM"
;
