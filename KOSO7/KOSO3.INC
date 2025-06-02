; "KOSO3.INC" PC-9801UV11 make by R.H 1990/12/10
;
;
;	拡張セットその３
;

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

TIME_SET	MACRO	TTT
	MOV	AX,TTT		; wait timer count.
	CALL	TMVST2		; V-SYNC timer2 set.
	ENDM

TIME_WAIT	MACRO
	LOCAL	L1,L2
L1:
	TEST	BYTE PTR KYTBLS[0],1B		; key code「ESC」
	JNZ	L2		; skip
	CALL	TMVCK2		; V-SYNC timer2 check.
	CMP	AX,0		; 0=timer now, 1=timer end.
	JE	L1		;
L2:
	ENDM

EXTRN	TMWAIT:NEAR		; time wait.
EXTRN	TMVSRT:NEAR		; V-SYNC timer start.
EXTRN	TMVEND:NEAR		; V-SYNC timer end.
EXTRN	TMVWAT:NEAR		; V-SYNC timer wait.
EXTRN	TMVSET:NEAR		; V-SYNC timer set.
EXTRN	TMVCHK:NEAR		; V-SYNC timer check.
EXTRN	TMVEWT:NEAR		; V-SYNC timer end wait.
EXTRN	TMVST2:NEAR		; V-SYNC timer2 set.
EXTRN	TMVCK2:NEAR		; V-SYNC timer2 check.
EXTRN	TMVST3:NEAR		; V-SYNC timer3 set.
EXTRN	TMVCK3:NEAR		; V-SYNC timer3 check.
EXTRN	TMVWT4:NEAR		; V-SYNC timer4 wait.
EXTRN	TMVST5:NEAR		; V-SYNC timer5 set.
EXTRN	TMVCK5:NEAR		; V-SYNC timer5 check.
EXTRN	TMVCLR:NEAR		; V-SYNC timer clear.
EXTRN	TMVSTP:NEAR		; V-SYNC timer stop.
EXTRN	TMVCNT:NEAR		; V-SYNC timer cont.
EXTRN	TMVRND:NEAR		; V-SYNC timer run counter read.
EXTRN	TMVSAV:NEAR		; V-SYNC timer value save.
EXTRN	TMVLOD:NEAR		; V-SYNC timer value load.

CODE	ENDS


DATA	SEGMENT	WORD PUBLIC	'DATA'

EXTRN	KYTBLS:BYTE		; key code table top.

DATA	ENDS

;
;	end of "KOSO3.INC"
;
