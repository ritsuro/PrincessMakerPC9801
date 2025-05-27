; "KEYBORD.ASM" PC-9801UV11 make by R.H 1990/01/13
;
;	KEYBORD I/O.
;
;	PC-9800TECHNICAL DATA BOOK P.89
;
; public subroutine.


EXTRN	IN_8259_PORT:FAR	; (far) in  port 8259.
EXTRN	OUT_8259_PORT:FAR	; (far) out port 8259.
EXTRN	IN_8251_PORT:FAR	; (far) in  prot 8251.
EXTRN	OUT_8251_PORT:FAR	; (far) out prot 8251.

IN_8259	MACRO	AA,NUM
;same;	IN	AL,NUM
	PUSH	DX
	MOV	DX,NUM			;
	CALL	IN_8259_PORT		; (far) in  port 8259.
	POP	DX
	ENDM

OUT8259	MACRO	NUM,AA
;same;	OUT	NUM,AL
	PUSH	DX
	MOV	DX,NUM			;
	CALL	OUT_8259_PORT		; (far) out port 8259.
	POP	DX
	ENDM

IN_8251	MACRO	AA,NUM
;same;	IN	AL,NUM
	PUSH	DX
	MOV	DX,NUM			;
	CALL	IN_8251_PORT		; (far) in  prot 8251.
	POP	DX
	ENDM

OUT8251	MACRO	NUM,AA
;same;	OUT	NUM,AL
	PUSH	DX
	MOV	DX,NUM			;
	CALL	OUT_8251_PORT		; (far) out prot 8251.
	POP	DX
	ENDM




CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	KYBSRT		; keybord start.
	PUBLIC	KYBEND		; keybord end.
	PUBLIC	KYBSTP		; keybord stop.
	PUBLIC	KYBCNT		; keybord cont.

	PUBLIC	KYBONS		; keybord STOP key on.
	PUBLIC	KYBOFS		; keybord STOP key off.

EXTRN	XSTOPX:FAR	; ＳＴＯＰキー終了処理
			; デバック時にＳＴＯＰキーを押すとここに飛び込んでくる


; keybord start.

KYBSRT	PROC	NEAR
	CALL	VECSET_KEYBORD_SAVE	; vector save.

	CALL	VECSET_KEYBORD		; keybord int vector.

	CLI
	IN_8259	AL,02H			; IMR save.
	MOV	SAVE_IMR,AX		;

	AND	AL,11111101B		; unmask.(IR1)
	OUT8259	02H,AL			; IMR set.
	STI

	RET
KYBSRT	ENDP


; keybord end.

KYBEND	PROC	NEAR

	CALL	VECSET_KEYBORD_STOP	; keybord stop vector.

	CLI
	MOV	AX,SAVE_IMR		;
	OUT8259	02H,AL			; IMR load.
	STI

	CALL	VECSET_KEYBORD_LOAD	; vector load.

	RET
KYBEND	ENDP


; keybord stop.

KYBSTP	PROC	NEAR

	CALL	VECSET_KEYBORD_STOP	; keybord stop vector.

	JMP	KYBSTP2			; JUMP (cpu cue buffer clear.)
KYBSTP2:				;

	TEST	BYTE PTR SAVE_IMR,00000010B	; return mask. (IR1)
	JZ	KYBSTP1			; set mask ?

	CLI
	IN_8259	AL,02H			; IMR read.
	OR	AL,00000010B		; mask.(IR1)
	OUT8259	02H,AL			; IMR write.
	STI
KYBSTP1:
	CALL	VECSET_KEYBORD_LOAD	; vector load.

	RET
KYBSTP	ENDP


; keybord cont.

KYBCNT	PROC	NEAR
	CALL	VECSET_KEYBORD		; keybord int vector.

	CLI
	IN_8259	AL,02H			; IMR read.
	AND	AL,11111101B		; unmask.(IR1)
	OUT8259	02H,AL			; IMR write.
	STI

	RET
KYBCNT	ENDP


;	keybord STOP key on.

KYBONS	PROC	NEAR
	MOV	STOPKEY_FLAG,1		; 1=STOP key on.
	RET
KYBONS	ENDP


;	keybord STOP key off.

KYBOFS	PROC	NEAR
	MOV	STOPKEY_FLAG,0		; 0=STOP key off.
	RET
KYBOFS	ENDP



VEC_KEY_OFST	EQU	24H	; int 09h
VEC_KEY_SEG	EQU	26H	;

;	common subroutine.

VECSET_KEYBORD	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	WORD PTR ES:[VEC_KEY_OFST],OFFSET KEYINT

	MOV	WORD PTR ES:[VEC_KEY_SEG],SEG KYICOD

	STI
	RET
VECSET_KEYBORD	ENDP

VECSET_KEYBORD_STOP	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	WORD PTR ES:[VEC_KEY_OFST],OFFSET KEYINT_STOP

	MOV	WORD PTR ES:[VEC_KEY_SEG],SEG KYICOD

	STI
	RET
VECSET_KEYBORD_STOP	ENDP

VECSET_KEYBORD_SAVE	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	AX,WORD PTR ES:[VEC_KEY_OFST]
	MOV	SAVE_VEC_KEY_OFST,AX

	MOV	AX,WORD PTR ES:[VEC_KEY_SEG]
	MOV	SAVE_VEC_KEY_SEG,AX

	STI
	RET
VECSET_KEYBORD_SAVE	ENDP

VECSET_KEYBORD_LOAD	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	AX,SAVE_VEC_KEY_OFST
	MOV	WORD PTR ES:[VEC_KEY_OFST],AX

	MOV	AX,SAVE_VEC_KEY_SEG
	MOV	WORD PTR ES:[VEC_KEY_SEG],AX

	STI
	RET
VECSET_KEYBORD_LOAD	ENDP

CODE	ENDS



;	keybord interrapt routine.


KYCMDW		EQU	43H	; mode/command write.
KYDATR		EQU	41H	; data read.
KYSTRD		EQU	43H	; status read.

KRETRY_MAX	EQU	3	; keybord retry counter max.


KYICOD	SEGMENT	PUBLIC	'KYICOD'
	ASSUME	CS:KYICOD,DS:DATA



KEYINT	PROC	FAR
	PUSH	DS
	PUSH	AX
	PUSH	BX
	PUSH	CX

;*DBG*;
;*DBG*;	MOV	AX,0A000H	; テキストマークの明滅
;*DBG*;	MOV	DS,AX		; text segment
;*DBG*;	MOV	AX,'%'		;
;*DBG*;	CMP	AX,DS:[4]	; text offset
;*DBG*;	JNZ	KEYINT00	;
;*DBG*;	MOV	AX,' '		;
;*DBG*;KEYINT00:			;
;*DBG*;	MOV	DS:[4],AX	;
;*DBG*;

	MOV	CX,5		;
KEYINT_WT:			;
	NOP			;
	LOOP	KEYINT_WT	; JUMP (cpu cue buffer clear.)

	MOV	AX,SEG DATA	; DS=data segment.
	MOV	DS,AX		;

	IN_8251	AL,KYSTRD	; status read.
	TEST	AL,00111000B	; error flag.
	JZ	KEYINT_NO_ERROR	;

	INC	KRETRY		; retry count check.
	CMP	KRETRY,KRETRY_MAX
	JL	KEYINT_ERROR	;

	MOV	KRETRY,0	; retry count clear.

	CALL	KEYINT_WAIT	; 13usec(?)

KEYINT_RESET:			; reset.
	MOV	AL,00111010B	; command RST=1 set.
	OUT8251	KYCMDW,AL	; mode/command write.

	CALL	KEYINT_WAIT	; 13usec(?)

	MOV	AL,00110010B	; command RST=0 set.
	OUT8251	KYCMDW,AL	; mode/command write.

	CALL	KEYINT_WAIT	; 18usec(?)

	MOV	AL,00010110B	; command RxE=1,KBDE=0 set.
	OUT8251	KYCMDW,AL	; mode/command write.

	CALL	KEYINT_WAIT	;

	JMP	KEYINT_EXIT	;

KEYINT_ERROR:			; error.
	MOV	AL,00010100B	; command RTY=0 set.
	OUT8251	KYCMDW,AL	; mode/command write.
	IN_8251	AL,KYDATR	; data read.
	JMP	KEYINT_SET	;

KEYINT_NO_ERROR:		; no error.
	MOV	AL,00010110B	; command RTY=1 set.
	OUT8251	KYCMDW,AL	; mode/command write.
	IN_8251	AL,KYDATR	; data read.
	JMP	KEYINT_SET	;

KEYINT_SET:
	CALL	KEY_CODE_SET	; key code set.
	CALL	KEY_LOCATE	; key locate.
KEYINT_EXIT:
	MOV	AL,20H		; EOI send.
	OUT8259	00H,AL		;

	CMP	DOSACS,1	; DOS access flag. 0=nomal,1=now access.
	JE	KEYINT_EXIT2	; (DISKRD.ASM)

	CALL	STOPKEY		; stop key intarapt.

	CMP	STOPCNT,0	; 0 < [STOP] key on,0=off
	JNE	KEYINT_EXIT_STOP_KEY

;*NON*;	TEST	KYTBLS[1],1000000B		; [COPY] key on?
;*NON*;	JNZ	KEYINT_EXIT_STOP_KEY		;

KEYINT_EXIT2:
	POP	CX
	POP	BX
	POP	AX
	POP	DS

	IRET

KEYINT_EXIT_STOP_KEY:
	CMP	STOPKEY_FLAG,0		; 1=STOP key on / 0=STOP key off.
	JE	KEYINT_EXIT2		;

	POP	CX
	POP	BX
	POP	AX
	POP	DS

	MOV	BP,SP			;
	MOV	AX,OFFSET XSTOPX	; ＳＴＯＰキー終了処理
	MOV	[BP],AX			; ＩＰ
	MOV	AX,SEG CODE		;
	MOV	[BP][2],AX		; ＣＳ
	; SS:SP [  I P  ] +0
	;       [  C S  ] +2
	;       [ flags ] +4
	IRET
KEYINT	ENDP


;	wait.

KEYINT_WAIT	PROC	NEAR
	MOV	CX,60		;
KEYINT_WAIT3:			;
	NOP			;
	LOOP	KEYINT_WAIT3	; JUMP (cpu cue buffer clear.)
	RET
KEYINT_WAIT	ENDP



;	key code set.
;	-I-   AL : read data.
;	-I/O- DS:[KYTBLS] : key code table.

KEY_CODE_SET	PROC	NEAR
	TEST	AL,80H			; break?
	JNZ	KEY_CODE_SET_BREAK	;

KEY_CODE_SET_MAKE:
	MOV	BL,AL			;
	AND	BX,1111B		; key group num.
	
	MOV	CL,AL			;
	AND	CL,7FH			;
	SHR	CL,1			; 1 nibl shift.
	SHR	CL,1			;
	SHR	CL,1			;
	SHR	CL,1			;
	MOV	AH,1			;
	SHL	AH,CL			; bitset
	OR	DS:KYTBLS[BX],AH	;
	RET

KEY_CODE_SET_BREAK:
	MOV	BL,AL			;
	AND	BX,1111B		; key group num.
	
	MOV	CL,AL			;
	AND	CL,7FH			;
	SHR	CL,1			; 1 nibl shift.
	SHR	CL,1			;
	SHR	CL,1			;
	SHR	CL,1			;
	MOV	AH,11111110B		;
	ROL	AH,CL			; bitset
	AND	DS:KYTBLS[BX],AH	;
	RET
KEY_CODE_SET	ENDP



;	key locate.
;	-I- DS:KYTBLS : key code table.
;	-O- DS:KYDRX  : key locate direction x(+-)
;	    DS:KYDRY  : key locate direction y(+-)
;	    DS:KYONL  : key left  bottan.(0=ON)
;	    DS:KYONR  : key right bottan.(0=ON)

KEY_LOCATE	PROC	NEAR
	MOV	BX,0				; key locate direction x(+-)
	MOV	CX,0				; key locate direction y(+-)

	TEST	BYTE PTR DS:KYTBLS[11],1000B	; left.
	JZ	KEY_LOCATE1			;
	DEC	BX				; x--
KEY_LOCATE1:
	TEST	BYTE PTR DS:KYTBLS[12],1000B	; right.
	JZ	KEY_LOCATE11			;
	INC	BX				; x++
KEY_LOCATE11:
	TEST	BYTE PTR DS:KYTBLS[10],1000B	; upper.
	JZ	KEY_LOCATE2			;
	DEC	CX				; y--
KEY_LOCATE2:
	TEST	BYTE PTR DS:KYTBLS[13],1000B	; under.
	JZ	KEY_LOCATE22			;
	INC	CX				; y++
KEY_LOCATE22:


	TEST	BYTE PTR DS:KYTBLS[6],10000B	; left.'4'
	JZ	KEY_LOCATE3			;
	DEC	BX				; x--
KEY_LOCATE3:
	TEST	BYTE PTR DS:KYTBLS[8],10000B	; right.'6'
	JZ	KEY_LOCATE33			;
	INC	BX				; x++
KEY_LOCATE33:
	TEST	BYTE PTR DS:KYTBLS[3],10000B	; upper.'8'
	JZ	KEY_LOCATE4			;
	DEC	CX				; y--
KEY_LOCATE4:
	TEST	BYTE PTR DS:KYTBLS[11],10000B	; under.'2'
	JZ	KEY_LOCATE44			;
	INC	CX				; y++
KEY_LOCATE44:
	MOV	DS:KYDRX,BX			; key locate direction x(+-)
	MOV	DS:KYDRY,CX			; key locate direction y(+-)

	MOV	KYONL,1				; key left  bottan.(0=ON)
	TEST	BYTE PTR DS:KYTBLS[9],100B	; 'Z'
	JNZ	KEY_LOCATE52			;
	TEST	BYTE PTR DS:KYTBLS[4],1000B	; SPACE BAR
	JNZ	KEY_LOCATE52			;
	TEST	BYTE PTR DS:KYTBLS[12],10B	; RETURN
	JNZ	KEY_LOCATE52			;
	TEST	BYTE PTR DS:KYTBLS[6],1000B	; ROLL UP
	JNZ	KEY_LOCATE52			;
	TEST	BYTE PTR DS:KYTBLS[8],1000B	; INS
	JNZ	KEY_LOCATE52			;
	JMP	KEY_LOCATE54			;
KEY_LOCATE52:					;
	MOV	KYONL,0				; key left  bottan.(0=ON)
KEY_LOCATE54:					;

	MOV	KYONR,1				; key right bottan.(0=ON)
	TEST	BYTE PTR DS:KYTBLS[10],100B	; 'X'
	JNZ	KEY_LOCATE55			;
	TEST	BYTE PTR DS:KYTBLS[0],1B	; ESC
	JNZ	KEY_LOCATE55			;
	TEST	BYTE PTR DS:KYTBLS[15],1B	; TAB
	JNZ	KEY_LOCATE55			;
	TEST	BYTE PTR DS:KYTBLS[7],1000B	; ROLL DOWN
	JNZ	KEY_LOCATE55			;
	TEST	BYTE PTR DS:KYTBLS[9],1000B	; DEL
	JNZ	KEY_LOCATE55			;
	JMP	KEY_LOCATE59			;
KEY_LOCATE55:					;
	MOV	KYONR,0				; key right bottan.(0=ON)
KEY_LOCATE59:
	RET
KEY_LOCATE	ENDP


;	stop key intarapt.

STOPKEY	PROC	NEAR
	CMP	STOPCNT,0			; 0 < [STOP] key on,0=off
	JE	STOPKEY1			;
	DEC	STOPCNT				; 0 < [STOP] key on,0=off
	RET
STOPKEY1:
	TEST	BYTE PTR DS:KYTBLS[0],1000000B	; [STOP] key on?
	JNZ	STOPKEY_ON
	RET
STOPKEY_ON:
	MOV	STOPCNT,2			; 0 < [STOP] key on,0=off
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	DI
	PUSH	SI
	PUSH	BP
	PUSH	DS
	PUSH	ES

	MOV	AX,SEG DATA	; DS=data segment.
	MOV	DS,AX		;

				; リトラクト／ハードディスク＃０
	MOV	AL,80H		; デバイス種別・ユニット番号（ＤＡ／ＵＡ）
	MOV	AH,00101111B	; リトライしない
	INT	1BH		;

				; リトラクト／ハードディスク＃１
	MOV	AL,81H		; デバイス種別・ユニット番号（ＤＡ／ＵＡ）
	MOV	AH,00101111B	; リトライしない
	INT	1BH		;

	POP	ES
	POP	DS
	POP	BP
	POP	SI
	POP	DI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
STOPKEY	ENDP



KEYINT_STOP	PROC	FAR
	PUSH	AX
	MOV	AL,20H	; EOI send.
	OUT8259	00H,AL	;
	POP	AX
	IRET
KEYINT_STOP	ENDP


KYICOD	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	DOSACS:WORD		; DOS access flag. 0=nomal,1=now access.
				; (DISKIO.ASM)

SAVE_IMR	DW	0		; IMR save area.

SAVE_VEC_KEY_OFST	DW	0	; keybord vector offset.
SAVE_VEC_KEY_SEG	DW	0	; keybord vector segment.

KRETRY		DW	0		; keybord retry counter.

;	key direction.

PUBLIC		KYDRX			; key locate direction x(+-)
PUBLIC		KYDRY			; key locate direction y(+-)
PUBLIC		KYONL			; key left  bottan.(0=ON)
PUBLIC		KYONR			; key right bottan.(0=ON)
KYDRX		DW	0		; key locate direction x(+-)
KYDRY		DW	0		; key locate direction y(+-)
KYONL		DW	1		; key left  bottan.(0=ON)
KYONR		DW	1		; key right bottan.(0=ON)


;	[STOP] key intarapt flag.

STOPCNT		DW	0		; 0 < [STOP] key on,0=off

STOPKEY_FLAG	DW	1		; 1=STOP key on / 0=STOP key off.


;	key code table.

PUBLIC	KYTBLS
KYTBLS	 LABEL	BYTE
	DB	0	;0
	DB	0	;1
	DB	0	;2
	DB	0	;3
	DB	0	;4
	DB	0	;5
	DB	0	;6
	DB	0	;7
	DB	0	;8
	DB	0	;9
	DB	0	;A
	DB	0	;B
	DB	0	;C
	DB	0	;D
	DB	0	;E
	DB	0	;F

DATA	ENDS

	END
;
;	end of "KEYBORD.ASM"
;
