; "DSPSET.ASM" 1989/09/15 R.H  PC-9801UV11 make by R.H 1989
;	modify 1989/12/08 R.H
;
;	�f�B�X�v���C���Z�b�g
;
;	PC-9801 technical data book p.116 GDC mode reg.
;
; public subroutine.

EXTRN	IN_7220_GDC_PORT:FAR	; (far) in  port 7220 GDC.
EXTRN	OUT_7220_GDC_PORT:FAR	; (far) out port 7220 GDC.

IN_GDC	MACRO	AA,NUM
;same;	IN	AL,NUM
	PUSH	DX
	MOV	DX,NUM			;
	CALL	IN_7220_GDC_PORT	; (far) in  port 7220 GDC.
	POP	DX
	ENDM

OUTGDC	MACRO	NUM,AA
;same;	OUT	NUM,AL
	PUSH	DX
	MOV	DX,NUM			;
	CALL	OUT_7220_GDC_PORT	; (far) out port 7220 GDC.
	POP	DX
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	VRMCLR		; �u�q�`�l�N���A
PUBLIC	DSP16M		; �P�U�F���[�h�Z�b�g
PUBLIC	DSP200		; �Q�O�O�^�W�F���[�h�Z�b�g
PUBLIC	VRMDP0		; �u�q�`�l�O�\��
PUBLIC	VRMDP1		; �u�q�`�l�P�\��
PUBLIC	VRMWT0		; �u�q�`�l�O�A�N�Z�X
PUBLIC	VRMWT1		; �u�q�`�l�P�A�N�Z�X
PUBLIC	VRMIE1		; �����ݒ��u�q�`�l���[�h
PUBLIC	VRMID1		; �����ݕ��A�u�q�`�l���[�h

EXTRN	GDCSRT:NEAR	;graphic start.
EXTRN	GDCSTP:NEAR	;graphic stop.
EXTRN	GDCSET:NEAR	;graphic mode set.
EXTRN	GDCWAT:NEAR	;GDC wait.


;	�u�q�`�l�N���A

VRMCLR	PROC	NEAR
	MOV	AX,WORD PTR ARAVRM[0]	; vram plean 1.
	MOV	ES,AX
	MOV	DI,0
	MOV	CX,40*400
	MOV	AX,0
	REP	STOSW

	MOV	AX,WORD PTR ARAVRM[2]	; vram plean 2.
	MOV	ES,AX
	MOV	DI,0
	MOV	CX,40*400
	MOV	AX,0
	REP	STOSW

	MOV	AX,WORD PTR ARAVRM[4]	; vram plean 3.
	MOV	ES,AX
	MOV	DI,0
	MOV	CX,40*400
	MOV	AX,0
	REP	STOSW

	MOV	AX,WORD PTR ARAVRM[6]	; vram plean 4.
	MOV	ES,AX
	MOV	DI,0
	MOV	CX,40*400
	MOV	AX,0
	REP	STOSW

	RET
VRMCLR	ENDP


;	�P�U�F���[�h�Z�b�g

DSP16M	PROC	NEAR
	MOV	AL,1		;  16 color mode.
	OUTGDC	06AH,AL		;

	CALL	GDCSRT			; graphic start.
	MOV	BYTE PTR GMODE,11000000B; 640x400 mode.
	CALL	GDCSET			; graphic mode set.

	MOV	AL,00001000B	;  400 line mode.
	OUTGDC	068H,AL		;

	CALL	GDCWAT		; GDC wait.
	RET
DSP16M	ENDP


;	�Q�O�O�^�W�F���[�h�Z�b�g

DSP200	PROC	NEAR
	MOV	AL,0		;  8 color mode.
	OUTGDC	06AH,AL		;

	CALL	GDCSRT			; graphic start.
	MOV	BYTE PTR GMODE,10000000B; 640x200 mode. LOWER,color,bank0.
	CALL	GDCSET			; graphic mode set.

	MOV	AL,00001000B	;  200 line mode.
	OUTGDC	068H,AL		;

	CALL	GDCWAT		; GDC wait.
	RET
DSP200	ENDP


;	�u�q�`�l�O�\��

VRMDP0	PROC	NEAR
	MOV	AL,00H
	OUTGDC	0A4H,AL
	MOV	VRM_DSP_MODE_NOW,0	; vram write bank number.
	RET
VRMDP0	ENDP


;	�u�q�`�l�P�\��

VRMDP1	PROC	NEAR
	MOV	AL,01H
	OUTGDC	0A4H,AL
	MOV	VRM_DSP_MODE_NOW,1	; vram write bank number.
	RET
VRMDP1	ENDP


;	�u�q�`�l�O�A�N�Z�X

VRMWT0	PROC	NEAR
	MOV	AL,00H
	OUTGDC	0A6H,AL
	MOV	VRM_WRT_MODE_NOW,0	; vram write bank number.
	RET
VRMWT0	ENDP


;	�u�q�`�l�P�A�N�Z�X

VRMWT1	PROC	NEAR
	MOV	AL,01H
	OUTGDC	0A6H,AL
	MOV	VRM_WRT_MODE_NOW,1	; vram write bank number.
	RET
VRMWT1	ENDP


;	�����ݒ��u�q�`�l���[�h

VRMIE1	PROC	NEAR
	MOV	AX,VRM_WRT_MODE_NOW	; vram write bank number.
	CMP	AX,VRM_DSP_MODE_NOW	; vram write bank number.
	JE	VRMIE1_EXIT		;

	MOV	AX,VRM_DSP_MODE_NOW	; vram write bank number.
	OUTGDC	0A6H,AL			; write bank set.

VRMIE1_EXIT:
	RET
VRMIE1	ENDP


;	�����ݕ��A�u�q�`�l���[�h

VRMID1	PROC	NEAR
	MOV	AX,VRM_WRT_MODE_NOW	; vram write bank number.
	CMP	AX,VRM_DSP_MODE_NOW	; vram write bank number.
	JE	VRMID1_EXIT		;

	MOV	AX,VRM_WRT_MODE_NOW	; vram write bank number.
	OUTGDC	0A6H,AL			; write bank set.

VRMID1_EXIT:
	RET
VRMID1	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	GX1:WORD		;
EXTRN	GY1:WORD		; GRBIO subroutine parameter.
EXTRN	GX2:WORD		;
EXTRN	GY2:WORD		;
EXTRN	GMODE:WORD		;
EXTRN	GCODE:WORD		;
EXTRN	GCLR:WORD		;
EXTRN	GRD:WORD		;

EXTRN	ARAVRM:WORD		; vram area.

VRM_WRT_MODE_NOW	DW	0	; vram write bank number.
VRM_DSP_MODE_NOW	DW	0	; vram write bank number.

DATA	ENDS

	END
;
;	end of "DSPSET.ASM"
;
