; "PICTUER.INC" PC_9801UV11 make by R.H 1990/12/12
;
;	�u�q��āv
;
;	�G�̕\���^�f���E�h�m�b�k�t�c�d
;
;PUBLIC	P_RED			; ��
;PUBLIC	P_WHITE			; ��
;
;PUBLIC	PT_C1_LD		; �b�P�̃��[�h
;PUBLIC	PT_C1P			; �b�P
;
;PUBLIC	PT_C2_LD		; �b�Q�̃��[�h
;PUBLIC	PT_C2P			; �b�Q
;
;PUBLIC	PT_C3_LD		; �b�R�̃��[�h
;PUBLIC	PT_C3P			; �b�R
;
;PUBLIC	PT_C4_LD		; �b�S�̃��[�h
;PUBLIC	PT_C4P			; �b�S
;
;PUBLIC	PT_C5_LD		; �b�T�̃��[�h
;PUBLIC	PT_C5P			; �b�T
;
;;*;PUBLIC PT_C12P		; �b�P�Q
;
;PUBLIC	PT_OPEN_ALL_LD		; �I�[�v�j���O�S���[�h
;
;PUBLIC	PT_OPEN_NAME		; ���O���̓t���[��
;PUBLIC	PT_OPEN_BORTH		; �a�����t���[��
;PUBLIC	PT_OPEN_CUTF		; �I�[�v�j���O�t���[��
;
;PUBLIC	PT_END_TXT_LD		; �G���f�B���O�E�e�L�X�g�E���[�h
;
;
;
; (C) 1990 ritsurou hashimoto.

OP_OFS_XX	EQU	12		; �I�[�v�j���O�ʒu�w
OP_OFS_YY	EQU	80-30		; �I�[�v�j���O�ʒu�x

;*;TIME_SET	MACRO	TTT
;*;	MOV	AX,TTT		; wait timer count.
;*;	EXTRN	TMVST3:NEAR	; V-SYNC timer3 set.
;*;	CALL	TMVST3		; V-SYNC timer3 set.
;*;	ENDM
;*;
;*;TIME_WAIT	MACRO
;*;	LOCAL	L1
;*;L1:
;*;	EXTRN	TMVCK3:NEAR	; V-SYNC timer3 check.
;*;	CALL	TMVCK3		; V-SYNC timer3 check.
;*;	CMP	AX,0		; 0=timer now, 1=timer end.
;*;	JE	L1		;
;*;	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM



R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

; ***********************************************
;	�p�[�c�t�@�C�����[�h
; ***********************************************

FILE_CALL	WOPENBOR		; �a�����t���[��
FILE_CALL	XOPENBOR		;
FILE_CALL	WOPENNAM		; ���O�t���[��
FILE_CALL	XOPENNAM		;
FILE_CALL	WOPENCUT		; �I�[�v�j���O�t���[��
FILE_CALL	XOPENCUT		;

FILE_CALL	TITLE1			; �b�O�@�s�h�s�k�d
FILE_CALL	TITLE2			; �b�O�@�s�h�s�k�d
FILE_CALL	C1			; �b�P
FILE_CALL	C2			; �b�Q
FILE_CALL	C3			; �b�R
FILE_CALL	C4			; �b�S
FILE_CALL	C5A1			; �b�T
FILE_CALL	C5A2			; �b�T
FILE_CALL	C6A1			; �b�U
FILE_CALL	C6A2			; �b�U
FILE_CALL	C12			; �b�P�Q


; ***********************************************
;	�f��
; ***********************************************


;*;;	�������[�h
;*;
;*;PT_INI_LD	PROC	NEAR
;*;	PAT_BANK	10
;*;	CALL	FILE_INIT		; ���[�h������
;*;	CALL	TITLE1			;0 �b�O�@�s�h�s�k�d
;*;	CALL	TITLE2			;1 �b�O�@�s�h�s�k�d
;*;	RET
;*;PT_INI_LD	ENDP
;*;
;*;
;*;;	�b�O�i�f�h�m�`�w�j�̃��[�h
;*;
;*;PT_C0_LD	PROC	NEAR
;*;	RET
;*;PT_C0_LD	ENDP
;*;
;*;
;*;;	�b�O�i�f�h�m�`�w�j
;*;
;*;PT_C0_ST	PROC	NEAR
;*;	PAT_BANK	10
;*;	PLSMD	1
;*;	PAT_PUT	0,0,0		; put.
;*;	PAT_PUT	1,0,0		; put.
;*;	RET
;*;PT_C0_ST	ENDP


;	�b�P�̃��[�h

FUNC	PPT_C1_LD,PT_C1_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ���[�h������
	CALL	C1			; �b�P
	RET
FEND	PPT_C1_LD

;	�b�P

FUNC	PPT_C1P,PT_C1P
	PAT_BANK	0
	PLSMD	1
	MOV	AX,1			; 0=�ʏ�,1=�p�^�[���o�t�s�I�[�o���b�v
	CALLC	PATEFC			; �p�[�c�o�t�s�G�t�F�N�g
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY		; put.
	MOV	AX,0			; 0=�ʏ�,1=�p�^�[���o�t�s�I�[�o���b�v
	CALLC	PATEFC			; �p�[�c�o�t�s�G�t�F�N�g
	RET
FEND	PPT_C1P


;	�b�Q�̃��[�h

FUNC	PPT_C2_LD,PT_C2_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ���[�h������
	CALL	C2			; �b�Q
	RET
FEND	PPT_C2_LD

;	�b�Q

FUNC	PPT_C2P,PT_C2P
	PAT_BANK	0
	PLSMD	1
	MOV	AX,1			; 0=�ʏ�,1=�p�^�[���o�t�s�I�[�o���b�v
	CALLC	PATEFC			; �p�[�c�o�t�s�G�t�F�N�g
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY	; put.
	MOV	AX,0			; 0=�ʏ�,1=�p�^�[���o�t�s�I�[�o���b�v
	CALLC	PATEFC			; �p�[�c�o�t�s�G�t�F�N�g
	RET
FEND	PPT_C2P


;	�b�R�̃��[�h

FUNC	PPT_C3_LD,PT_C3_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ���[�h������
	CALL	C3			; �b�R
	RET
FEND	PPT_C3_LD

;	�b�R

FUNC	PPT_C3P,PT_C3P
	PAT_BANK	0
	PLSMD	1
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY		; put.
	RET
FEND	PPT_C3P


;	�b�S�̃��[�h

FUNC	PPT_C4_LD,PT_C4_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ���[�h������
	CALL	C4			; �b�S
	RET
FEND	PPT_C4_LD

;	�b�S

FUNC	PPT_C4P,PT_C4P
	PAT_BANK	0
	PLSMD	1
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY		; put.
	RET
FEND	PPT_C4P


;	�b�T�̃��[�h

FUNC	PPT_C5_LD,PT_C5_LD
	PAT_BANK	0
	CALL	FILE_INIT	; ���[�h������
	CALL	C5A1
	PAT_BANK	1
	CALL	FILE_INIT	; ���[�h������
	CALL	C5A2
	RET
FEND	PPT_C5_LD


;	�b�T

FUNC	PPT_C5P,PT_C5P
	PAT_BANK	0
	PLSMD	1
	PAT_PUT	0,0,0		; put.
	PAT_BANK	1
	PAT_PUT	0,0,0		; put.
	RET
FEND	PPT_C5P


;*;;	�b�P�Q
;*;
;*;PT_C12P	PROC	NEAR
;*;	PAT_BANK	10
;*;	PLSMD	1
;*;	PAT_PUT	4,0,0			; put.
;*;	RET
;*;PT_C12P	ENDP


;	�I�[�v�j���O�S���[�h

FUNC	PPT_OPEN_ALL_LD,PT_OPEN_ALL_LD
	PAT_BANK	1		; �a�`�m�j���P
	CALL	FILE_INIT		; ���[�h������
	CALL	WOPENNAM		; 0=���O�t���[��
	CALL	XOPENNAM		;
	CALL	WOPENBOR		; 2=�a�����t���[��
	CALL	XOPENBOR		;
	CALL	WOPENCUT		; 4=�I�[�v�j���O�t���[��
	CALL	XOPENCUT		;
	RET
FEND	PPT_OPEN_ALL_LD


;	���O���̓t���[��

FUNC	PPT_OPEN_NAME,PT_OPEN_NAME
	MOV	NUM1,0			; 0=���O�t���[��
	CALL	FULL_FREAM_PUTS		; �S��ʂo�t�s
	RET
FEND	PPT_OPEN_NAME


;	�a�����t���[��

FUNC	PPT_OPEN_BORTH,PT_OPEN_BORTH
	MOV	NUM1,2			; 2=�a�����t���[��
	CALL	FULL_FREAM_PUTS		; �S��ʂo�t�s
	RET
FEND	PPT_OPEN_BORTH


;	�I�[�v�j���O�t���[��

FUNC	PPT_OPEN_CUTF,PT_OPEN_CUTF
	MOV	NUM1,4			; 4=�I�[�v�j���O�t���[��
	CALL	FULL_FREAM_PUTS		; �S��ʂo�t�s
	RET
FEND	PPT_OPEN_CUTF


;	�G���f�B���O�E�e�L�X�g�E���[�h
;	SEGPAT1:TOPPAT1(�p�[�c�o�b�t�@���P)�փ��[�h

FUNC	PPT_END_TXT_LD,PT_END_TXT_LD
	MOV	SI,OFFSET ENDING_TEXT_FL ; �G���f�B���O�E�e�L�X�g�̃t�@�C����
	MOV	DX,SEGPAT1		; �p�[�c�o�b�t�@���P�Z�O�����g
	MOV	DI,TOPPAT1		; �擪�I�t�Z�b�g
	ADD	DI,31000		; (�p�[�c�o�b�t�@���P�㔼�j
	MOV	CX,33000		; data length.�R�R�O�O�O�o�C�g
	CALLC	DSKLD			; load data.
	RET
FEND	PPT_END_TXT_LD


;	�S��ʂo�t�s
;	-I- NUM1 : �擪�p�^�[���ԍ�

FULL_FREAM_PUTS	PROC	NEAR
	PAT_BANK	1		; �a�`�m�j���P
	PLSMD	1			;

	MOV	XX1,0			; �o�t�s�I�t�Z�b�g�@�w���W
	MOV	YY1,0			; �o�t�s�I�t�Z�b�g�@�x���W
	MOVX	NUM,NUM1		; �擪�p�^�[���ԍ�
	CALL	PATTAN_PUT		; �p�^�[���o�t�s

	MOV	XX1,0			; �o�t�s�I�t�Z�b�g�@�w���W
	MOV	YY1,0			; �o�t�s�I�t�Z�b�g�@�x���W
	MOVX	NUM,NUM1		; �擪�p�^�[���ԍ�
	INC	NUM			;
	CALL	PATTAN_PUT		; �p�^�[���o�t�s

	RET
FULL_FREAM_PUTS	ENDP


; ***********************************************
;	�p���b�g�Z�b�g
; ***********************************************

;	��

FUNC	PP_RED,P_RED
	MOV	CLRVEW,0		; color.
	MOV	CLRCNS,100		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALL	P_PALET			; �p���b�g
	RET
FEND	PP_RED


;	��

FUNC	PP_WHITE,P_WHITE
	MOV	CLRVEW,0		; color.
	MOV	CLRCNS,0		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALL	P_PALET			; �p���b�g
	RET
FEND	PP_WHITE


;	�p���b�g
;	-I- CLRVEW : color.
;	    CLRCNS : contrast.
;	    CLRBRI : brightness.

P_PALET	PROC	NEAR
	MOV	CLRCDE,1		; color code.
	MOV	CX,15			;
P_PALET_LOOP:
	PUSH	CX			;
	CALLC	SETCLR			; color set.
	INC	CLRCDE			; color code.
	POP	CX			;
	LOOP	P_PALET_LOOP		;
	RET
P_PALET	ENDP


; ***********************************************
;	�s�d�w�s�l�`�r�j�����C������
; ***********************************************

TXT_MASK_YL	PROC	NEAR
	MOV	VX1,638			;
	MOV	VY1,0			;
	MOV	VY2,399			;
	MOV	VCOL,0			;
	MOV	CX,2			; ����
	CALLC	DLINEV			; �������C���`��
	RET
TXT_MASK_YL	ENDP


R_SEG2	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SEGPAT1:WORD		; �p�[�c�o�b�t�@���P�Z�O�����g
EXTRN	TOPPAT1:WORD		; �擪�I�t�Z�b�g
EXTRN	ENDPAT1:WORD		; �I���I�t�Z�b�g

NUM1	DW	0
NUM2	DW	0
XXX1	DW	0
YYY1	DW	0
XXX2	DW	0
YYY2	DW	0
XXX3	DW	0
YYY3	DW	0

ENDING_TEXT_FL	DB	"OCHITEXT.TXT",0 ; �G���f�B���O�E�e�L�X�g�̃t�@�C����

DATA	ENDS

	END
;
;	end of "PICTUER.INC"
;
