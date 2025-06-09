; "DSPSET.ASM" 1989/09/15 R.H  PC-9801UV11 make by R.H 1989
;	modify 1989/12/08 R.H
;
;	ディスプレイ回りセット
;
; public subroutine.

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	VRMCLR	;ＶＲＡＭクリア
PUBLIC	DSP16M	;１６色モードセット

EXTRN	GDCSRT:NEAR	;graphic start.
EXTRN	GDCSTP:NEAR	;graphic stop.
EXTRN	GDCSET:NEAR	;graphic mode set.


;
;	ＶＲＡＭクリア
;

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


;	１６色モードセット

DSP16M	PROC	NEAR
	MOV	AL,1		;  16 color mode.
	OUT	06AH,AL		;

	CALL	GDCSRT			; graphic start.
	MOV	BYTE PTR GMODE,11000000B; 640x400 mode.
	CALL	GDCSET			; graphic mode set.

	MOV	AL,00001000B	;  400 line mode.
	OUT	068H,AL		;

	RET
DSP16M	ENDP


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

DATA	ENDS

	END
;
;	end of "DSPSET.ASM"
;
