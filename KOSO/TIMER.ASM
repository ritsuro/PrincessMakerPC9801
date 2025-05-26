; TIMER.ASM 1988/11/22 R.H
;
;	タイマーセット
;
;	キーボード・ロケーションを行なうためのタイミング取り用に
;	ＫＥＹＭＵＳ（ＭＹＬＣ．ＡＳＭ）をコールしています
;
;	1990/06/02 音楽ドライバＰＭＤ９８用にＰＭＤＶＲＴ（ＰＭＤ．ＡＳＭ）
;	をコールしています
;
;	1990/07/21 複合効果音割込み(V-SYNC)INTSND
;	をコールしています
;
;
;	TMVSND ; V-SYNC timer sound program call.
;	連続効果音用用
;
; public subroutine.

INCLUDE	TSTSET.INC

EXTRN	IN_7220_GDC_PORT:FAR	; (far) in  port 7220 GDC.
EXTRN	OUT_7220_GDC_PORT:FAR	; (far) out port 7220 GDC.
EXTRN	IN_8259_PORT:FAR	; (far) in  port 8259.
EXTRN	OUT_8259_PORT:FAR	; (far) out port 8259.

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

TIMER_LOCK	MACRO
;*;	LOCAL	LL
;*;LL:	TEST	KYTBLS[2],80H	; [ｶﾅ] キーテーブル　＊＊＊＊＊＊
;*;	JNZ	LL		; デバックの為のロック
	ENDM

EXTRN	KEYMUS:FAR		; ｷｰﾎﾞｰﾄﾞ･ﾛｹｰｼｮﾝをマウスドライバへセット
EXTRN	PMDVRT:FAR		; ＶＲＴＣ割込みでコールすること[PMD98]
EXTRN	INTPLT:FAR		; パレット処理割込み(IPLMSG.ASM)

;*NON*;EXTRN	INTSND:FAR	; 複合効果音割込み(V-SYNC)
;*NON*;EXTRN	INTMUS:FAR	; 音楽効果処理割込み(V-SYNC)
;*NON*;EXTRN	SNDONX:FAR	; 効果音発生(DSOUND.ASM)ＦＡＲ


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

	PUBLIC	TMWAIT		; time wait.
	PUBLIC	TMVSRT		; V-SYNC timer start.
	PUBLIC	TMVEND		; V-SYNC timer end.
	PUBLIC	TMVWAT		; V-SYNC timer wait.
	PUBLIC	TMVSET		; V-SYNC timer set.
	PUBLIC	TMVCHK		; V-SYNC timer check.
	PUBLIC	TMVEWT		; V-SYNC timer end wait.
	PUBLIC	TMVST2		; V-SYNC timer2 set.
	PUBLIC	TMVCK2		; V-SYNC timer2 check.
	PUBLIC	TMVST3		; V-SYNC timer3 set.
	PUBLIC	TMVCK3		; V-SYNC timer3 check.
	PUBLIC	TMVWT4		; V-SYNC timer4 wait.
	PUBLIC	TMVST5		; V-SYNC timer5 set.
	PUBLIC	TMVCK5		; V-SYNC timer5 check.
	PUBLIC	TMVCLR		; V-SYNC timer clear.
	PUBLIC	TMVSTP		; V-SYNC timer stop.
	PUBLIC	TMVCNT		; V-SYNC timer cont.
	PUBLIC	TMVRND		; V-SYNC timer run counter read.
	PUBLIC	TMVSAV		; V-SYNC timer value save.
	PUBLIC	TMVLOD		; V-SYNC timer value load.

	PUBLIC	TMVJST		; V-SYNC timer jump set.
	PUBLIC	TMVJRS		; V-SYNC timer jump reset.

	PUBLIC	TMVJST_FAR	; (far) V-SYNC timer jump set.
	PUBLIC	TMVJRS_FAR	; (far) V-SYNC timer jump reset.

	PUBLIC	TMVPLT		; V-SYNC timer pallet program call.
;*NON*;	PUBLIC	TMVSND		; V-SYNC timer sound program call.


; time wait.
; -i- DX : time.

TMWAIT	PROC	NEAR
	PUSH	CX

	MOV	CX,DX
TMWAIT1:PUSH	CX
	MOV	CX,5000
TMWAIT2:NOP
	NOP
	LOOP	TMWAIT2
	POP	CX
	LOOP	TMWAIT1

	POP	CX
	RET

TMWAIT	ENDP



; V-SYNC timer start.

TMVSRT	PROC	NEAR
;*;	MOV	STACK_CHECK_HI,SP	; stack check hi-address.
;*;	MOV	STACK_CHECK_LOW,SP	; stack check low-address.

	CALL	VECSET_VSYNC_SAVE	; vector save.

	CALL	VECSET_VSYNC		; V-SYNC int vector.

	CLI
	IN_8259	AL,02H			; IMR save.
	MOV	SAVE_IMR,AX		;

	AND	AL,0FBH			; V-SYNC unmask.
	OUT8259	02H,AL			; IMR set.
	STI

	OUTGDC	64H,AL			; V-SYNC reset.

	RET
TMVSRT	ENDP


; timer end.

TMVEND	PROC	NEAR

	CALL	VECSET_VSYNC_STOP	; V-SYNC stop vector.

	MOV	DX,10
	CALL	TMWAIT			; time wait.

	CLI
	MOV	AX,SAVE_IMR		;
	OUT8259	02H,AL			; IMR load.
	STI

	CALL	VECSET_VSYNC_LOAD	; vector load.

	RET
TMVEND	ENDP


; V-SYNC timer wait.
;	-I- AX : wait timer count.

TMVWAT	PROC	NEAR
	MOV	WORD PTR VSYNCC,AX
TMVWAT1:
	TIMER_LOCK

	CMP	WORD PTR VSYNCC,0
	JNZ	TMVWAT1
	RET
TMVWAT	ENDP



; V-SYNC timer set.
;	-I- AX : wait timer count.

TMVSET	PROC	NEAR
	MOV	WORD PTR VSYNCC,AX
;*;	LC	0,21
;*;	PRVH	"stack check hi-address =",STACK_CHECK_HI
;*;	PRVH	"stack check low-address=",STACK_CHECK_LOW
	RET
TMVSET	ENDP



; V-SYNC timer check.
;	-O- AX : 0=timer now, 1=timer end.
;	    DX : now counter.

TMVCHK	PROC	NEAR
	TIMER_LOCK

	MOV	DX,VSYNCC
	CMP	DX,0
	JZ	TMVCHK1
	MOV	AX,0		; 0=timer now.
	RET
TMVCHK1:
	MOV	AX,1		; 1=timer end.
	RET
TMVCHK	ENDP


; V-SYNC timer end wait.

TMVEWT	PROC	NEAR
TMVEWT1:
	TIMER_LOCK

	CMP	WORD PTR VSYNCC,0
	JNZ	TMVEWT1
	RET
TMVEWT	ENDP


; V-SYNC timer2 set.
;	-I- AX : wait timer count.

TMVST2	PROC	NEAR
	MOV	WORD PTR VSYNC2,AX
	RET
TMVST2	ENDP



; V-SYNC timer2 check.
;	-O- AX : 0=timer now, 1=timer end.
;	    DX : now counter.

TMVCK2	PROC	NEAR
	TIMER_LOCK

	MOV	DX,VSYNC2
	CMP	DX,0
	JZ	TMVCK21
	MOV	AX,0		; 0=timer now.
	RET
TMVCK21:
	MOV	AX,1		; 1=timer end.
	RET
TMVCK2	ENDP



; V-SYNC timer3 set.
;	-I- AX : wait timer count.

TMVST3	PROC	NEAR
	MOV	WORD PTR VSYNC3,AX
	RET
TMVST3	ENDP



; V-SYNC timer3 check.
;	-O- AX : 0=timer now, 1=timer end.
;	    DX : now counter.

TMVCK3	PROC	NEAR
	TIMER_LOCK

	MOV	DX,VSYNC3
	CMP	DX,0
	JZ	TMVCK31
	MOV	AX,0		; 0=timer now.
	RET
TMVCK31:
	MOV	AX,1		; 1=timer end.
	RET
TMVCK3	ENDP



; V-SYNC timer4 wait.
;	-I- AX : wait timer count.

TMVWT4	PROC	NEAR
	MOV	WORD PTR VSYNC4,AX
TMVWT41:

;*NON*;	TEXT_VRAM_SEG	EQU	0A000H	; text vram address.
;*NON*;	PUSH	ES
;*NON*;	MOV	AX,TEXT_VRAM_SEG	; テキストマークの明滅
;*NON*;	MOV	ES,AX			; text segment
;*NON*;	MOV	AX,'.'			;
;*NON*;	MOV	ES:[6],AX		;
;*NON*;	JMP	TMVWT45			;
;*NON*;TMVWT45:				;
;*NON*;	MOV	AX,' '			;
;*NON*;	MOV	ES:[6],AX		;
;*NON*;	POP	ES			;
;*NON*;
	CMP	WORD PTR VSYNC4,0
	JNZ	TMVWT41
	RET
TMVWT4	ENDP



; V-SYNC timer5 set.
;	-I- AX : wait timer count.

TMVST5	PROC	NEAR
	MOV	WORD PTR VSYNC5,AX
	RET
TMVST5	ENDP



; V-SYNC timer5 check.
;	-O- AX : 0=timer now, 1=timer end.
;	    DX : now counter.

TMVCK5	PROC	NEAR
	MOV	DX,VSYNC5
	CMP	DX,0
	JZ	TMVCK51
	MOV	AX,0		; 0=timer now.
	RET
TMVCK51:
	MOV	AX,1		; 1=timer end.
	RET
TMVCK5	ENDP




; V-SYNC timer clear.

TMVCLR	PROC	NEAR
	MOV	WORD PTR VSYNCC,0
	RET
TMVCLR	ENDP


; V-SYNC timer stop.

TMVSTP	PROC	NEAR

	CALL	VECSET_VSYNC_STOP	; V-SYNC stop vector.

	JMP	TMVSTP2			; JUMP (cpu cue buffer clear.)
TMVSTP2:				;

	TEST	BYTE PTR SAVE_IMR,00000100B	; return mask.
	JZ	TMVSTP1			; set mask ?

	CLI
	IN_8259	AL,02H			; IMR read.
	OR	AL,00000100B		; V-SYNC mask.
	OUT8259	02H,AL			; IMR write.
	STI
TMVSTP1:
	CALL	VECSET_VSYNC_LOAD	; vector load.

	RET
TMVSTP	ENDP


; V-SYNC timer cont.

TMVCNT	PROC	NEAR
	CALL	VECSET_VSYNC		; V-SYNC int vector.

	CLI
	IN_8259	AL,02H			; IMR read.
	AND	AL,0FBH			; V-SYNC unmask.
	OUT8259	02H,AL			; IMR write.
	STI

	OUTGDC	64H,AL			; V-SYNC reset.

	RET
TMVCNT	ENDP


; V_SYNC timer run counter read.
; -O- AX : now counter.

TMVRND	PROC	NEAR
	MOV	AX,WORD PTR DS:[VSYNCR]	; V-SYNC run counter.
	RET
TMVRND	ENDP


; V-SYNC timer value save.

TMVSAV	PROC	NEAR
	PUSH	AX
	MOV	AX,VSYNCC	; V-SYNC counter.
	MOV	SAVE_VSYNCC,AX	; V-SYNC counter save.
	MOV	AX,VSYNC2	; V-SYNC counter2.
	MOV	SAVE_VSYNC2,AX	; V-SYNC counter2 save.
	MOV	AX,VSYNC3	; V-SYNC counter3.
	MOV	SAVE_VSYNC3,AX	; V-SYNC counter3 save.
	MOV	AX,VSYNC4	; V-SYNC counter4.
	MOV	SAVE_VSYNC4,AX	; V-SYNC counter4 save.
	MOV	AX,VSYNC5	; V-SYNC counter5.
	MOV	SAVE_VSYNC5,AX	; V-SYNC counter5 save.
	MOV	AX,VSYNCR	; V-SYNC run counter.
	MOV	SAVE_VSYNCR,AX	; V-SYNC run counter save.
	MOV	AX,VSYNCJ	; V-SYNC set jump counter.
	MOV	SAVE_VSYNCJ,AX	; V-SYNC set jump counter save.

	POP	AX
	RET
TMVSAV	ENDP


; V-SYNC timer value load.

TMVLOD	PROC	NEAR
	PUSH	AX
	MOV	AX,SAVE_VSYNCC	; V-SYNC counter save.
	MOV	VSYNCC,AX	; V-SYNC counter.
	MOV	AX,SAVE_VSYNC2	; V-SYNC counter2 save.
	MOV	VSYNC2,AX	; V-SYNC counter2.
	MOV	AX,SAVE_VSYNC3	; V-SYNC counter3 save.
	MOV	VSYNC3,AX	; V-SYNC counter3.
	MOV	AX,SAVE_VSYNC4	; V-SYNC counter4 save.
	MOV	VSYNC4,AX	; V-SYNC counter4.
	MOV	AX,SAVE_VSYNC5	; V-SYNC counter5 save.
	MOV	VSYNC5,AX	; V-SYNC counter5.
	MOV	AX,SAVE_VSYNCR	; V-SYNC run counter save.
	MOV	VSYNCR,AX	; V-SYNC run counter.
	MOV	AX,SAVE_VSYNCJ	; V-SYNC set jump counter save.
	MOV	VSYNCJ,AX	; V-SYNC set jump counter.
	POP	AX
	RET
TMVLOD	ENDP


;	(far) V-SYNC timer jump set.
;	-I- AX : wait time.
;	    SI : save SS
;	    BX : save SP
;	    CX : jump CS
;	    DX : jump IP
;	    DS : save DS
;	    flags : save FLAGS

TMVJST_FAR	PROC	FAR
	CALL	TMVJST		; V-SYNC timer jump set.
	RET
TMVJST_FAR	ENDP


;	(far) V-SYNC timer jump reset.

TMVJRS_FAR	PROC	FAR
	CALL	TMVJRS		; V-SYNC timer jump reset.
	RET
TMVJRS_FAR	ENDP


;	V-SYNC timer jump set.
;	-I- AX : wait time.
;	    SI : save SS
;	    BX : save SP
;	    CX : jump CS
;	    DX : jump IP
;	    DS : save DS
;	    flags : save FLAGS

TMVJST	PROC	NEAR
	MOV	VSYNCJ,AX			; V-SYNC set jump counter.
	MOV	SET_J_SS,SI			; save SS
	MOV	SET_J_SP,BX			; save SP
	MOV	SET_J_CS,CX			; jump CS
	MOV	SET_J_IP,DX			; jump IP

	PUSH	DS				; save DS
	POP	SET_J_DS			; save DS
	PUSHF
	POP	SET_J_FLAGS			; save FLAGS
	RET
TMVJST	ENDP


;	V-SYNC timer jump reset.

TMVJRS	PROC	NEAR
	MOV	VSYNCJ,0			; V-SYNC set jump counter.
	RET
TMVJRS	ENDP


; V-SYNC timer pallet program call.
; -I- AX : 割込みスイッチ 0=OFF,1=ON

TMVPLT	PROC	NEAR
	MOV	PALET_SW,AX		; 割込みスイッチ 0=OFF,1=ON
	RET
TMVPLT	ENDP


;*NON*;; V-SYNC timer sound program call.
;*NON*;; -I- AX : 効果音番号(0=OFF)
;*NON*;;     BX : 間隔時間（Ｖ－ＳＹＮＣ）
;*NON*;
;*NON*;TMVSND	PROC	NEAR
;*NON*;	MOV	SOUND_NUM,AX		; 効果音番号
;*NON*;	MOV	SOUND_TIME,BX		; 間隔時間（Ｖ－ＳＹＮＣ）
;*NON*;	MOV	SOUND_TCNT,0		; 間隔時間カウンタ
;*NON*;	RET
;*NON*;TMVSND	ENDP



VEC_CRTV_OFST	EQU	28H	; int 0Ah
VEC_CRTV_SEG	EQU	2AH	;

;	common subroutine.

VECSET_VSYNC	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	WORD PTR ES:[VEC_CRTV_OFST],OFFSET TMINT

	MOV	WORD PTR ES:[VEC_CRTV_SEG],SEG TMCODE

	STI
	RET
VECSET_VSYNC	ENDP

VECSET_VSYNC_STOP	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	WORD PTR ES:[VEC_CRTV_OFST],OFFSET TMINT_STOP

	MOV	WORD PTR ES:[VEC_CRTV_SEG],SEG TMCODE

	STI
	RET
VECSET_VSYNC_STOP	ENDP

VECSET_VSYNC_SAVE	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	AX,WORD PTR ES:[VEC_CRTV_OFST]
	MOV	SAVE_VEC_CRTV_OFST,AX

	MOV	AX,WORD PTR ES:[VEC_CRTV_SEG]
	MOV	SAVE_VEC_CRTV_SEG,AX

	STI
	RET
VECSET_VSYNC_SAVE	ENDP

VECSET_VSYNC_LOAD	PROC	NEAR
	CLI

	MOV	AX,0		; 0 base.
	MOV	ES,AX		;

	MOV	AX,SAVE_VEC_CRTV_OFST
	MOV	WORD PTR ES:[VEC_CRTV_OFST],AX

	MOV	AX,SAVE_VEC_CRTV_SEG
	MOV	WORD PTR ES:[VEC_CRTV_SEG],AX

	STI
	RET
VECSET_VSYNC_LOAD	ENDP

CODE	ENDS




;	V-SYNC interrapt routine.

TMCODE	SEGMENT	PUBLIC	'TMCODE'
	ASSUME	CS:TMCODE,DS:DATA

TMINT	PROC	FAR
	PUSH	DS
	PUSH	AX

;*DBG*;	MOV	AX,0A000H	; テキストマークの明滅
;*DBG*;	MOV	DS,AX		; text segment
;*DBG*;	MOV	AX,'@'		;
;*DBG*;	CMP	AX,DS:[2]	; text offset
;*DBG*;	JNZ	CS0203		;
;*DBG*;	MOV	AX,' '		;
;*DBG*;CS0203:			;
;*DBG*;	MOV	DS:[2],AX	;


	MOV	AX,SEG DATA
	MOV	DS,AX

	CMP	WORD PTR DS:[VSYNCC],0
	JZ	TMINT2
	DEC	WORD PTR DS:[VSYNCC]
TMINT2:
	CMP	WORD PTR DS:[VSYNC2],0
	JZ	TMINT22
	DEC	WORD PTR DS:[VSYNC2]
TMINT22:
	CMP	WORD PTR DS:[VSYNC3],0
	JZ	TMINT23
	DEC	WORD PTR DS:[VSYNC3]
TMINT23:
	CMP	WORD PTR DS:[VSYNC4],0
	JZ	TMINT24
	DEC	WORD PTR DS:[VSYNC4]
TMINT24:
	CMP	WORD PTR DS:[VSYNC5],0
	JZ	TMINT25
	DEC	WORD PTR DS:[VSYNC5]
TMINT25:
	CMP	WORD PTR DS:[VSYNCJ],0
	JZ	TMINT299
	DEC	WORD PTR DS:[VSYNCJ]
TMINT299:
	INC	WORD PTR DS:[VSYNCR]	; V-SYNC run counter.

	CMP	WORD PTR DS:[VSYNCJ],1
	JE	TMINT_SET_JUMP

	PUSH	ES
	PUSH	DS
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	BP
	PUSH	SI
	PUSH	DI

	CALL	PMDVRT		; ＶＲＴＣ割込みでコールすること［ＰＭＤ９８］

	MOV	AX,SEG DATA		;
	MOV	DS,AX			;

;*;	CMP	SP,STACK_CHECK_HI	; stack check hi-address.
;*;	JBE	TMINT41			;
;*;	MOV	STACK_CHECK_HI,SP	; stack check hi-address.
;*;TMINT41:				;
;*;
;*;	CMP	SP,STACK_CHECK_LOW	; stack check low-address.
;*;	JNB	TMINT42			;
;*;	MOV	STACK_CHECK_LOW,SP	; stack check low-address.
;*;TMINT42:				;

	;	キーボード・ロケーションを行なうためのタイミング取り用に
	;	ＫＥＹＭＵＳ（ＭＹＬＣ．ＡＳＭ）をコールしています

	CALL	KEYMUS		; ｷｰﾎﾞｰﾄﾞ･ﾛｹｰｼｮﾝをマウスドライバへセット

	CMP	PALET_SW,1	; 割込みスイッチ 0=OFF,1=ON
	JNE	TMINT66		;
	CALL	INTPLT		; パレット処理割込み(IPLMSG.ASM)
TMINT66:

;*NON*;	CALL	INTSND		; 複合効果音割込み(V-SYNC)
;*NON*;	CALL	INTMUS		; 音楽効果処理割込み(V-SYNC)
;*NON*;
;*NON*;
;*NON*;	MOV	AX,SOUND_NUM	; 効果音番号
;*NON*;	CMP	AX,0		; ＯＦＦ？
;*NON*;	JE	TMINT77		;
;*NON*;
;*NON*;	INC	SOUND_TCNT	; 間隔時間カウンタ
;*NON*;	MOV	AX,SOUND_TCNT	; 間隔時間カウンタ
;*NON*;	CMP	AX,SOUND_TIME	; 間隔時間（Ｖ－ＳＹＮＣ）
;*NON*;	JB	TMINT77		;
;*NON*;
;*NON*;	MOV	AX,SOUND_NUM	; 効果音番号
;*NON*;	CALL	SNDONX		; 効果音発生(DSOUND.ASM)ＦＡＲ
;*NON*;	MOV	SOUND_TCNT,0	; 間隔時間カウンタ
;*NON*;TMINT77:

	POP	DI
	POP	SI
	POP	BP
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	POP	DS
	POP	ES



	MOV	AL,20H	; EOI send.
	OUT8259	00H,AL	;

	JMP	TMINT88
TMINT88:
	POP	AX
	POP	DS

	OUTGDC	64H,AL			; V-SYNC reset.

	IRET


TMINT_SET_JUMP:
	MOV	SS,SET_J_SS		; save SS
	MOV	SP,SET_J_SP		; save SP
	SUB	SP,6			; iret stack.

	; SS:SP [  I P  ] +0
	;       [  C S  ] +2
	;       [ flags ] +4

	MOV	BP,SP			;
	MOV	AX,SET_J_IP		; jump IP
	MOV	SS:[BP][0],AX		; [  I P  ] +0
	MOV	AX,SET_J_CS		; jump CS
	MOV	SS:[BP][2],AX		; [  C S  ] +2
	MOV	AX,SET_J_FLAGS		; save FLAGS
	MOV	SS:[BP][4],AX		; [ flags ] +4

	MOV	DS,SET_J_DS		; save DS


	MOV	AL,20H	; EOI send.
	OUT8259	00H,AL	;

	JMP	TMINT99
TMINT99:

	OUTGDC	64H,AL			; V-SYNC reset.

	IRET
TMINT	ENDP


TMINT_STOP	PROC	FAR
	PUSH	AX
	MOV	AL,20H	; EOI send.
	OUT8259	00H,AL	;

	POP	AX
	IRET
TMINT_STOP	ENDP

TMCODE	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	VSYNCC				; V-SYNC counter.
PUBLIC	VSYNC2				; V-SYNC counter2.
PUBLIC	VSYNC3				; V-SYNC counter3.
PUBLIC	VSYNC4				; V-SYNC counter4.
PUBLIC	VSYNC5				; V-SYNC counter4.

					; デバッグ監視用にｷｰﾏﾄﾘｯｸｽを使う
EXTRN	KYTBLS:BYTE			; key code table.

PALET_SW	DW	0		; 割込みスイッチ 0=OFF,1=ON

;*NON*;SOUND_NUM	DW	0	; 効果音番号
;*NON*;SOUND_TIME	DW	1	; 間隔時間（Ｖ－ＳＹＮＣ）
;*NON*;SOUND_TCNT	DW	0	; 間隔時間カウンタ

		EVEN
VSYNCC		DW	0		; V-SYNC counter.
VSYNC2		DW	0		; V-SYNC counter2.
VSYNC3		DW	0		; V-SYNC counter3.
VSYNC4		DW	0		; V-SYNC counter4.
VSYNC5		DW	0		; V-SYNC counter5.
VSYNCR		DW	0		; V-SYNC run counter.
VSYNCJ		DW	0		; V-SYNC set jump counter.

SAVE_VSYNCC	DW	0		; V-SYNC counter save.
SAVE_VSYNC2	DW	0		; V-SYNC counter2 save.
SAVE_VSYNC3	DW	0		; V-SYNC counter3 save.
SAVE_VSYNC4	DW	0		; V-SYNC counter4 save.
SAVE_VSYNC5	DW	0		; V-SYNC counter5 save.
SAVE_VSYNCR	DW	0		; V-SYNC run counter save.
SAVE_VSYNCJ	DW	0		; V-SYNC set jump counter save.

SAVE_IMR	DW	0		; IMR save area.

SAVE_VEC_CRTV_OFST	DW	0	; V-SYNC vector offset.
SAVE_VEC_CRTV_SEG	DW	0	; V-SYNC vector segment.

;*;STACK_CHECK_HI	DW	0		; stack check hi-address.
;*;STACK_CHECK_LOW	DW	0		; stack check low-address.

SET_J_SS		DW	0		; save SS
SET_J_SP		DW	0		; save SP
SET_J_CS		DW	0		; jump CS
SET_J_IP		DW	0		; jump IP
SET_J_DS		DW	0		; save DS
SET_J_FLAGS		DW	0		; save FLAGS

DATA	ENDS

	END
;
;	end of "TIMER.ASM"
;
