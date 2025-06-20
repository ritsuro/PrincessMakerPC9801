; "CNZS88.ASM" PC-9801UV11 make by R.H 1990/02/24
;
;
;	�o�b�W�W�y�f���t�@�C���̃A�N�Z�X
;
;
; public subroutine.

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	LODZ88			; �o�b�W�W�y�f���t�@�C�����[�h
PUBLIC	SAVZ88			; �o�b�W�W�y�f���t�@�C���Z�[�u

	EXTRN	DSKOPN:NEAR	; file open.
	EXTRN	DSKCRE:NEAR	; file open & creat.
	EXTRN	DSKCLS:NEAR	; file close.

	EXTRN	DSKDR:NEAR	; drive number set.
	EXTRN	DSKRED:NEAR	; load 1 byte data.
	EXTRN	DSKWRT:NEAR	; save 1 byte data.
	EXTRN	DSKLD:NEAR	; load data.
	EXTRN	DSKSV:NEAR	; save data.


ZS88ST2_LEN	EQU	48000	; �y�f���W�W�f�[�^�̃o�C�g��


;	�o�b�W�W�y�f���t�@�C�����[�h
;	-I- DS:SI  : �t�@�C���� (null=end of string)

LODZ88	PROC	NEAR
	PUSH	SI

	CALL	BFLNSET			; �o�b�W�W�y�f���t�@�C�����Z�b�g

	MOV	SI,OFFSET FLZ88		; �o�b�W�W�y�f���t�@�C����
	MOV	DI,0			; vram offset.
	MOV	DX,ARAVRM[0]		; vram segment.
	MOV	CX,ZS88ST2_LEN		; �y�f���W�W�f�[�^�̃o�C�g��
	CALL	DSKLD			; file load.

	CALL	PLNDEV			; �X�W�v���[���ɕ���

	POP	SI
	RET
LODZ88	ENDP


;	�o�b�W�W�y�f���t�@�C���Z�[�u
;	-I- DS:SI  : �t�@�C���� (null=end of string)

SAVZ88	PROC	NEAR
	PUSH	SI

	PUSH	SI
	CALL	PLNSST		; �X�W�v���[�����y�f���W�W�t�H�[�}�b�g��
	POP	SI

	CALL	BFLNSET			; �o�b�W�W�y�f���t�@�C�����Z�b�g

	MOV	SI,OFFSET FLZ88		; �o�b�W�W�y�f���t�@�C����
	MOV	DI,0			; vram offset.
	MOV	DX,ARAVRM[0]		; vram segment.
	MOV	CX,ZS88ST2_LEN		; �y�f���W�W�f�[�^�̃o�C�g��
	CALL	DSKSV			; file save.

	POP	SI
	RET
SAVZ88	ENDP



Z881PLNLEN	EQU	16000		; �y�f���W�W�P�v���[���o�C�g��

;	�X�W�v���[���ɕ���

PLNDEV	PROC	NEAR
	PUSH	DS
	MOV	DX,DS

	MOV	AX,ARAVRM[4]		; dest vram segment.
	MOV	ES,AX			;
	MOV	AX,ARAVRM[0]		;
	MOV	DS,AX			;
	MOV	SI,Z881PLNLEN*2		;
	MOV	DI,0			;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	MOV	DS,DX			;
	MOV	AX,ARAVRM[2]		; dest vram segment.
	MOV	ES,AX			;
	MOV	AX,ARAVRM[0]		;
	MOV	DS,AX			;
	MOV	SI,Z881PLNLEN		;
	MOV	DI,0			;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	MOV	DS,DX			;
	MOV	AX,ARAVRM[0]		; dest vram segment.
	MOV	ES,AX			;
	MOV	DI,Z881PLNLEN		;
	MOV	CX,Z881PLNLEN/2		;
	MOV	AX,0			;
	REP	STOSW			;

	POP	DS
	RET
PLNDEV	ENDP



;	�X�W�v���[�����y�f���W�W�t�H�[�}�b�g��

PLNSST	PROC	NEAR
	PUSH	DS
	MOV	DX,DS

	MOV	AX,ARAVRM[0]		;
	MOV	ES,AX			;
	MOV	AX,ARAVRM[2]		; dest vram segment.
	MOV	DS,AX			;
	MOV	SI,0			;
	MOV	DI,Z881PLNLEN		;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	MOV	DS,DX			;
	MOV	AX,ARAVRM[0]		;
	MOV	ES,AX			;
	MOV	AX,ARAVRM[4]		; dest vram segment.
	MOV	DS,AX			;
	MOV	DI,Z881PLNLEN*2		;
	MOV	SI,0			;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	POP	DS
	RET
PLNSST	ENDP



;	�o�b�W�W�y�f���t�@�C�����Z�b�g
;	-I- DS:SI : �t�@�C����

BFLNSET	PROC	NEAR
	PUSH	SI

	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET FLNAME	; �t�@�C�����N���A
	MOV	CX,8
	MOV	AL,' '
	REP	STOSB

	MOV	DI,OFFSET FLNAME	; �t�@�C����
	MOV	CX,8
BFLNSET2:
	LODSB
	CMP	AL,' '			; end of string.
	JB	BFLNSET3		;
	STOSB
	LOOP	BFLNSET2
BFLNSET3:
	MOV	SI,OFFSET FLNAME	; �t�@�C����
	MOV	DI,OFFSET FLZ88		; �o�b�W�W�y�f���t�@�C����
	MOV	CX,8			;
	REP	MOVSB			;

	POP	SI
	RET
BFLNSET	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	ARAVRM:WORD		; vram area.

FLNAME	DB	"        ",0		; �t�@�C����
FLZ88	DB	"        ","ST2",0	; �o�b�W�W�y�f���t�@�C����

DATA	ENDS

	END
;
;	end of "CNZS88.ASM"
;
