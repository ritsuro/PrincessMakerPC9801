; TIMER.ASM 1988/11/22 R.H
;
;	タイマーセット
;
;［停止］キーボード・ロケーションを行なうためのタイミング取り用に
;［停止］ＫＥＹＭＵＳ（ＭＹＬＣ．ＡＳＭ）をコールしています
;
;［廃止］音楽ドライバ効果音処理を行なうため、効果音処理用割り込みルーチン
;［廃止］ＭＤＲＶＩＴ（ＭＤＲＶ９８．ＡＳＭ）をコールしています
;
;
;
; public subroutine.


;*NON*;EXTRN	KEYMUS:FAR	; ｷｰﾎﾞｰﾄﾞ･ﾛｹｰｼｮﾝをマウスドライバへセット
;*NON*;EXTRN	MDRVIT:FAR	; 効果音処理用割り込みルーチン

;*NON*;EXTRN	PMDVRT:FAR		; ＶＲＴＣ割込みでコールすること［ＰＭＤ９８］


CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	TMWAIT		; time wait.
	PUBLIC	TMVSRT		; V-SYNC timer start.
	PUBLIC	TMVEND		; V-SYNC timer end.
	PUBLIC	TMVWAT		; V-SYNC timer wait.
	PUBLIC	TMVSET		; V-SYNC timer set.
	PUBLIC	TMVCHK		; V-SYNC timer check.
	PUBLIC	TMVST2		; V-SYNC timer2 set.
	PUBLIC	TMVCK2		; V-SYNC timer2 check.
	PUBLIC	TMVST3		; V-SYNC timer3 set.
	PUBLIC	TMVCK3		; V-SYNC timer3 check.
	PUBLIC	TMVWT4		; V-SYNC timer4 wait.
	PUBLIC	TMVCLR		; V-SYNC timer clear.
	PUBLIC	TMVSTP		; V-SYNC timer stop.
	PUBLIC	TMVCNT		; V-SYNC timer cont.
	PUBLIC	TMVRND		; V-SYNC timer run counter read.
	PUBLIC	TMVSAV		; V-SYNC timer value save.
	PUBLIC	TMVLOD		; V-SYNC timer value load.

;*NON*;	PUBLIC	TMVSND		; V-SYNC timer sound program call.

;*NON*;	EXTRN	SNDONX:FAR	; 効果音発生(DSOUND.ASM)ＦＡＲ


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
	CALL	VECSET_VSYNC_SAVE	; vector save.

	CALL	VECSET_VSYNC		; V-SYNC int vector.

	CLI
	IN	AL,02H			; IMR save.
	MOV	SAVE_IMR,AX		;

	AND	AL,0FBH			; V-SYNC unmask.
	OUT	02H,AL			; IMR set.
	STI

	OUT	64H,AL			; V-SYNC reset.

	RET
TMVSRT	ENDP


; timer end.

TMVEND	PROC	NEAR

	CALL	VECSET_VSYNC_STOP	; V-SYNC stop vector.

	MOV	DX,10
	CALL	TMWAIT			; time wait.

	CLI
	MOV	AX,SAVE_IMR		;
	OUT	02H,AL			; IMR load.
	STI

	CALL	VECSET_VSYNC_LOAD	; vector load.

	RET
TMVEND	ENDP


; V-SYNC timer wait.
;	-I- AX : wait timer count.

TMVWAT	PROC	NEAR
	MOV	WORD PTR VSYNCC,AX
TMVWAT1:
	CMP	WORD PTR VSYNCC,0
	JNZ	TMVWAT1
	RET
TMVWAT	ENDP



; V-SYNC timer set.
;	-I- AX : wait timer count.

TMVSET	PROC	NEAR
	MOV	WORD PTR VSYNCC,AX
	RET
TMVSET	ENDP



; V-SYNC timer check.
;	-O- AX : 0=timer now, 1=timer end.
;	    DX : now counter.

TMVCHK	PROC	NEAR
	MOV	DX,VSYNCC
	CMP	DX,0
	JZ	TMVCHK1
	MOV	AX,0		; 0=timer now.
	RET
TMVCHK1:
	MOV	AX,1		; 1=timer end.
	RET
TMVCHK	ENDP



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
	PUSH	ES
	MOV	AX,0A000H	; テキストマークの明滅
	MOV	ES,AX		; text segment
	MOV	AX,'.'		;
	MOV	ES:[6],AX	;
	JMP	TMVWT45		;
TMVWT45:			;
	MOV	AX,' '		;
	MOV	ES:[6],AX	;
	POP	ES		;

	CMP	WORD PTR VSYNC4,0
	JNZ	TMVWT41
	RET
TMVWT4	ENDP




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
	IN	AL,02H			; IMR read.
	OR	AL,00000100B		; V-SYNC mask.
	OUT	02H,AL			; IMR write.
	STI
TMVSTP1:
	CALL	VECSET_VSYNC_LOAD	; vector load.

	RET
TMVSTP	ENDP


; V-SYNC timer cont.

TMVCNT	PROC	NEAR
	CALL	VECSET_VSYNC		; V-SYNC int vector.

	CLI
	IN	AL,02H			; IMR read.
	AND	AL,0FBH			; V-SYNC unmask.
	OUT	02H,AL			; IMR write.
	STI

	OUT	64H,AL			; V-SYNC reset.

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
	MOV	AX,VSYNCR	; V-SYNC run counter.
	MOV	SAVE_VSYNCR,AX	; V-SYNC run counter save.
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
	MOV	AX,SAVE_VSYNCR	; V-SYNC run counter save.
	MOV	VSYNCR,AX	; V-SYNC run counter.
	POP	AX
	RET
TMVLOD	ENDP


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

TMCODE	SEGMENT
	ASSUME	CS:TMCODE,DS:DATA

TMINT	PROC	FAR
	PUSH	DS
	PUSH	AX

;*NON*;
;*NON*;	MOV	AX,SEG DATA
;*NON*;	MOV	DS,AX
;*NON*;	CMP	BYTE PTR DS:KYTBLS[13],1B	; key code '\'
;*NON*;	JNE	TMINT00		;
;*NON*;	MOV	AX,0A000H	; テキストマークの明滅
;*NON*;	MOV	DS,AX		; text segment
;*NON*;	MOV	AX,'.'		;
;*NON*;	MOV	DS:[2],AX	;
;*NON*;	JMP	TMINT001	;
;*NON*;TMINT001:			;
;*NON*;	JMP	TMINT002	;
;*NON*;TMINT00:			;
;*NON*;	MOV	AX,0A000H	; テキストマークの明滅
;*NON*;	MOV	DS,AX		; text segment
;*NON*;	MOV	AX,' '		;
;*NON*;	MOV	DS:[2],AX	;
;*NON*;TMINT002:			;
;*NON*;

;*DBG*;	MOV	AX,0A000H	; テキストマークの明滅
;*DBG*;	MOV	DS,AX		; text segment
;*DBG*;	MOV	AX,'@'		;
;*DBG*;	CMP	AX,DS:[2]	; text offset
;*DBG*;	JNZ	CS0203		;
;*DBG*;	MOV	AX,' '		;
;*DBG*;CS0203:			;
;*DBG*;	MOV	DS:[2],AX	;
;*DBG*;


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
	INC	WORD PTR DS:[VSYNCR]	; V-SYNC run counter.

;*NON*;
;*NON*;	;	キーボード・ロケーションを行なうためのタイミング取り用に
;*NON*;	;	ＫＥＹＭＵＳ（ＭＹＬＣ．ＡＳＭ）をコールしています
;*NON*;	CALL	KEYMUS		; ｷｰﾎﾞｰﾄﾞ･ﾛｹｰｼｮﾝをマウスドライバへセット
;*NON*;
;*NON*;
;*NON*;	;	音楽ドライバ効果音処理を行なうため、効果音処理用割り込み
;*NON*;	;	ＭＤＲＶＩＴ（ＭＤＲＶ９８．ＡＳＭ）をコールしています
;*NON*;	CALL	MDRVIT		; 効果音処理用割り込みルーチン
;*NON*;

;*NON*;	CALL	PMDVRT		; ＶＲＴＣ割込みでコールすること［ＰＭＤ９８］
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
;*NON*;	PUSH	ES
;*NON*;	PUSH	DS
;*NON*;	PUSH	AX
;*NON*;	PUSH	BX
;*NON*;	PUSH	CX
;*NON*;	PUSH	DX
;*NON*;	PUSH	BP
;*NON*;	PUSH	SI
;*NON*;	PUSH	DI
;*NON*;	MOV	AX,SOUND_NUM	; 効果音番号
;*NON*;	CALL	SNDONX		; 効果音発生(DSOUND.ASM)ＦＡＲ
;*NON*;	MOV	SOUND_TCNT,0	; 間隔時間カウンタ
;*NON*;	POP	DI
;*NON*;	POP	SI
;*NON*;	POP	BP
;*NON*;	POP	DX
;*NON*;	POP	CX
;*NON*;	POP	BX
;*NON*;	POP	AX
;*NON*;	POP	DS
;*NON*;	POP	ES
;*NON*;TMINT77:

	MOV	AL,20H	; EOI send.
	OUT	00H,AL	;

	JMP	TMINT88
TMINT88:
	POP	AX
	POP	DS

	OUT	64H,AL			; V-SYNC reset.

	IRET
TMINT	ENDP


TMINT_STOP	PROC	FAR
	PUSH	AX
	MOV	AL,20H	; EOI send.
	OUT	00H,AL	;

	POP	AX
	IRET
TMINT_STOP	ENDP

TMCODE	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	VSYNCC				; V-SYNC counter.
PUBLIC	VSYNC2				; V-SYNC counter2.
PUBLIC	VSYNC3				; V-SYNC counter3.
PUBLIC	VSYNC4				; V-SYNC counter4.

;*NON*;
;*NON*;					; デバッグ監視用にｷｰﾏﾄﾘｯｸｽを使う
;*NON*;EXTRN	KYTBLS:BYTE		; key code table.
;*NON*;

SOUND_NUM	DW	0		; 効果音番号
SOUND_TIME	DW	1		; 間隔時間（Ｖ－ＳＹＮＣ）
SOUND_TCNT	DW	0		; 間隔時間カウンタ

		EVEN
VSYNCC		DW	0		; V-SYNC counter.
VSYNC2		DW	0		; V-SYNC counter2.
VSYNC3		DW	0		; V-SYNC counter3.
VSYNC4		DW	0		; V-SYNC counter4.
VSYNCR		DW	0		; V-SYNC run counter.

SAVE_VSYNCC	DW	0		; V-SYNC counter save.
SAVE_VSYNC2	DW	0		; V-SYNC counter2 save.
SAVE_VSYNC3	DW	0		; V-SYNC counter3 save.
SAVE_VSYNC4	DW	0		; V-SYNC counter4 save.
SAVE_VSYNCR	DW	0		; V-SYNC run counter save.

SAVE_IMR	DW	0		; IMR save area.

SAVE_VEC_CRTV_OFST	DW	0	; V-SYNC vector offset.
SAVE_VEC_CRTV_SEG	DW	0	; V-SYNC vector segment.

DATA	ENDS

	END
;
;	end of "TIMER.ASM"
;
