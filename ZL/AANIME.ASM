; "AANIME.ASM" PC-9801UV11 make by R.H 1990/05/17
;
;	ƒI[ƒgEƒAƒjƒ
;
;

INCLUDE	TSTSET.INC

;	‚l‚n‚u‚dQ‚h‚l‚f	ƒ“]‘—Œ³‚h‚c„Cƒ“]‘—æ‚h‚c„
;				C‚w‚PC‚x‚PC‚w‚QC‚x‚QC‚w‚RC‚x‚R

MOVE_IMG	MACRO	SOUID,DESTID,X1,Y1,X2,Y2,X3,Y3
	MOV	AX,WORD PTR SOUID[0]
	MOV	SSSOU0,AX
	MOV	AX,WORD PTR SOUID[2]
	MOV	SSSOU1,AX
	MOV	AX,WORD PTR SOUID[4]
	MOV	SSSOU2,AX
	MOV	AX,WORD PTR SOUID[6]
	MOV	SSSOU3,AX
	MOV	AX,WORD PTR DESTID[0]
	MOV	SSDES0,AX
	MOV	AX,WORD PTR DESTID[2]
	MOV	SSDES1,AX
	MOV	AX,WORD PTR DESTID[4]
	MOV	SSDES2,AX
	MOV	AX,WORD PTR DESTID[6]
	MOV	SSDES3,AX
	MOV	AX,X1
	MOV	WORD PTR VX1,AX
	MOV	AX,Y1
	MOV	WORD PTR VY1,AX
	MOV	AX,X2
	MOV	WORD PTR VX2,AX
	MOV	AX,Y2
	MOV	WORD PTR VY2,AX
	MOV	AX,X3
	MOV	WORD PTR VX3,AX
	MOV	AX,Y3
	MOV	WORD PTR VY3,AX
	EXTRN	MOVEVR:NEAR	; vram to vram move.
	CALL	MOVEVR		; vram to vram move.
ENDM

FRAME_SET	EQU	3	; ƒtƒŒ[ƒ€”Ô†(0=‚È‚É‚à‚µ‚È‚¢)

UDRIVE		EQU	2	; ƒ†[ƒUƒhƒ‰ƒCƒu”Ô†


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	AANIME		; ƒI[ƒgEƒAƒjƒ

EXTRN	PLSET:NEAR	; ƒpƒŒƒbƒgƒZƒbƒg
EXTRN	PLPSET:NEAR	; ƒpƒŒƒbƒg•ÒWƒZƒbƒg

EXTRN	LODPLT:NEAR	; ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹ƒ[ƒh
EXTRN	SAVPLT:NEAR	; ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹ƒZ[ƒu

EXTRN	ARAPNT:NEAR	; point pic.
EXTRN	ARABOX:NEAR	; box pic.

EXTRN	DSKOPN:NEAR	; file open.
EXTRN	DSKCRE:NEAR	; file open & creat.
EXTRN	DSKCLS:NEAR	; file close.

EXTRN	DSKDR:NEAR	; drive number set.

EXTRN	DSKRED:NEAR	; load 1 byte data.
EXTRN	DSKWRT:NEAR	; save 1 byte data.

EXTRN	DSKLD:NEAR	; load data.
EXTRN	DSKSV:NEAR	; save data.

EXTRN	LODBET:NEAR	; ƒxƒ^ƒtƒ@ƒCƒ‹ƒ[ƒh
EXTRN	SAVBET:NEAR	; ƒxƒ^ƒtƒ@ƒCƒ‹ƒZ[ƒu

EXTRN	PTPIC:NEAR	; point pick.

EXTRN	PATCLR:NEAR	; ƒp[ƒcƒZƒbƒgƒNƒŠƒA
EXTRN	PATGET:NEAR	; ƒp[ƒc‚f‚d‚s
EXTRN	PATGTA:NEAR	; ƒp[ƒc‚f‚d‚sˆ³k–³‚µ
EXTRN	PATPUT:NEAR	; ƒp[ƒc‚o‚t‚s
EXTRN	PATPTX:NEAR	; ƒp[ƒc‚o‚t‚sÀ•WŽw’è
EXTRN	PATPTF:NEAR	; ƒp[ƒc‚o‚t‚sƒIƒtƒZƒbƒgŽw’è
EXTRN	PATSAV:NEAR	; ƒp[ƒcƒZ[ƒu
EXTRN	PATLOD:NEAR	; ƒp[ƒcƒ[ƒh
EXTRN	PATLDA:NEAR	; ƒp[ƒc’Ç‰Áƒ[ƒh
EXTRN	PATGTM:NEAR	; ƒ}ƒXƒNƒp[ƒc‚f‚d‚s
EXTRN	PATPTM:NEAR	; ƒ}ƒXƒNƒp[ƒc‚o‚t‚s
EXTRN	PATPXM:NEAR	; ƒ}ƒXƒNƒp[ƒc‚o‚t‚sÀ•WŽw’è
EXTRN	PATOPE:NEAR	; ƒIƒyƒŒ[ƒVƒ‡ƒ“ƒZƒbƒg(µÍßÚ°¼®Ý 0=normal,1=OR )

EXTRN	TMWAIT:NEAR	; time wait.
EXTRN	TMVSRT:NEAR	; V-SYNC timer start.
EXTRN	TMVEND:NEAR	; V-SYNC timer end.
EXTRN	TMVWAT:NEAR	; V-SYNC timer wait.
EXTRN	TMVSET:NEAR	; V-SYNC timer set.
EXTRN	TMVCHK:NEAR	; V-SYNC timer check.
EXTRN	TMVCLR:NEAR	; V-SYNC timer clear.
EXTRN	TMVST2:NEAR	; V-SYNC timer2 set.
EXTRN	TMVCK2:NEAR	; V-SYNC timer2 check.
EXTRN	TMVST3:NEAR	; V-SYNC timer3 set.
EXTRN	TMVCK3:NEAR	; V-SYNC timer3 check.
EXTRN	TMVSTP:NEAR	; V-SYNC timer stop.
EXTRN	TMVCNT:NEAR	; V-SYNC timer cont.
EXTRN	TMVSAV:NEAR	; V-SYNC timer value save.
EXTRN	TMVLOD:NEAR	; V-SYNC timer value load.

EXTRN	PLSMOD:NEAR	; ˆ³kƒ‚[ƒhØ‚è‘Ö‚¦

EXTRN	BPPPTS:NEAR	; ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹‚ðƒp[ƒcƒoƒbƒtƒ@‚Ö

EXTRN	PATSIZ:NEAR	; ƒp[ƒcƒTƒCƒY‚Ì‚f‚d‚s

EXTRN	VRMCLR:NEAR	; ‚u‚q‚`‚lƒNƒŠƒA

EXTRN	TXTBOX:NEAR	; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg




; *******************************************
;	ƒI[ƒgEƒAƒjƒ
; *******************************************

AANIME	PROC	NEAR

	PRF	"ƒI[ƒgEƒAƒjƒ [INS:‘—‚è/DEL:”²‚¯‚é]"
	LF

	CALL	HARFBR			; –¾“x‚T‚O“

	MOV	USER_DRV,UDRIVE		; ƒ†[ƒUƒhƒ‰ƒCƒu”Ô†
	MOV	PLSDIR_FLG,0		; ˆ³kƒ‚[ƒh(0:’Êí,1:c•ûŒü)

	MOV	AX,USER_DRV		; ƒ†[ƒUƒhƒ‰ƒCƒu”Ô†
	CALL	DSKDR			; drive number set.

AANIME_LP:
	INP	"ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹–¼"
	CALL	PALET_LSET		; ƒpƒŒƒbƒgƒ[ƒh
	CMP	AX,1			; 1:error.
	JNE	AANIME_1		;
	PRF	"ƒtƒ@ƒCƒ‹‚ªŒ©‚Â‚©‚è‚Ü‚¹‚ñ"
	JMP	AANIME_LP		;
AANIME_1:				;



	CALL	HARFBR			; –¾“x‚T‚O“
AANIME_LOOP:
	INP	"ƒxƒ^ƒtƒ@ƒCƒ‹–¼"

	CALL	LODBET			; ƒxƒ^ƒtƒ@ƒCƒ‹ƒ[ƒh

	CMP	AX,1			; 1:error.
	JNE	AANIME_2		;
	PRF	"ƒtƒ@ƒCƒ‹‚ªŒ©‚Â‚©‚è‚Ü‚¹‚ñ"
	JMP	AANIME_LOOP		;
AANIME_2:				;


	INP	"–‡”‚ÍA‚¨‚¢‚­‚ÂH"
	CALL	STRDEC
	CMP	DX,0
	JE	AANIME_2
	CMP	DX,6
	JG	AANIME_2
	MOV	AN_MAX,DX



	INP	"‚u|‚r‚x‚m‚b‘Ò‚¿‚ÍA‚¨‚¢‚­‚ÂHi‚P^‚U‚O•bj"
	CALL	STRDEC
	MOV	TIME_WAIT,DX		; ‚u|‚r‚x‚m‚b‘Ò‚¿

	MOVE_IMG	ARAVRM,ARA001,0,0,80,400,0,0

AANIME_3:
	MOV	BX,0			; ƒpƒŒƒbƒgƒe[ƒuƒ‹”Ô†
	CALL	PLSET			; ƒpƒŒƒbƒgƒZƒbƒg

	AND	TIME_WAIT,1111111B	; ‚u|‚r‚x‚m‚b‘Ò‚¿

	CALL	ANIME_MOVE		; ƒAƒjƒ

	CALL	HARFBR			; –¾“x‚T‚O“

	INP	"‚u|‚r‚x‚m‚b‘Ò‚¿‚ÍA‚¨‚¢‚­‚ÂHi‚P^‚U‚O•bj"
	CMP	BYTE PTR DS:[SI],0
	JE	AANIME_NEXT
	CALL	STRDEC
	MOV	TIME_WAIT,DX		; ‚u|‚r‚x‚m‚b‘Ò‚¿

	JMP	AANIME_3

AANIME_NEXT:
	JMP	AANIME_LOOP


AANIME_EXIT:
	RET


;*NON*;AANIME_MENU:
;*NON*;	PRF	" 2:ƒƒCƒ“ƒEƒCƒ“ƒhƒE		46(368) x 200"
;*NON*;	PRF	" 3:ƒCƒxƒ“ƒgƒEƒCƒ“ƒhƒE		39(312) x 160"
;*NON*;	PRF	" 4:í“¬			20(160) x 146"
;*NON*;	PRF	" 5:‚‹´			EEEEEEE"
;*NON*;	INP	"ƒtƒŒ[ƒ€”Ô†(0=‚È‚É‚à‚µ‚È‚¢)"
;*NON*;	CALL	STRDEC
;*NON*;
;*NON*;	MOV	FRAME_NUM,DX		; ƒtƒŒ[ƒ€”Ô†(0=‚È‚É‚à‚µ‚È‚¢)
;*NON*;	CMP	DX,1
;*NON*;	JG	AANIME_1
;*NON*;	JMP	AANIME_MENU
;*NON*;AANIME_1:
;*NON*;	CMP	DX,5
;*NON*;	JLE	AANIME_11
;*NON*;	JMP	AANIME_MENU
;*NON*;AANIME_11:
;*NON*;
;*NON*;
;*NON*;	CALL	PALET_LSET		; ƒpƒŒƒbƒgƒ[ƒh•ƒZƒbƒg
;*NON*;
;*NON*;	CALL	HARFBR			; –¾“x‚T‚O“
;*NON*;
;*NON*;	CALL	PATCLR			; ƒp[ƒcƒZƒbƒgƒNƒŠƒA
;*NON*;
;*NON*;AANIME_LOOP:
;*NON*;	CALL	FLGET			; Žw’èƒtƒ@ƒCƒ‹–¼‚f‚d‚s
;*NON*;	CMP	AX,1			; 1=I—¹
;*NON*;	JUMP_EQ	AANIME_LOOP_END		;
;*NON*;
;*NON*;	CALL	FLSET			; ƒtƒ@ƒCƒ‹–¼ƒZƒbƒg
;*NON*;
;*NON*;	MOV	DX,PLSDIR_FLG		; ˆ³kƒ‚[ƒh(0:’Êí,1:c•ûŒü)
;*NON*;	CALL	PLSMOD			; ˆ³kƒ‚[ƒhØ‚è‘Ö‚¦
;*NON*;
;*NON*;	MOV	SI,OFFSET FLNM		; file name.
;*NON*;	CALL	LODBET			; ƒxƒ^ƒtƒ@ƒCƒ‹ƒ[ƒh
;*NON*;	CMP	AX,1			;
;*NON*;	JUMP_EQ	AANIME_NOERROR		;
;*NON*;
;*NON*;
;*NON*;	CALL	TITLES			; ƒ^ƒCƒgƒ‹
;*NON*;
;*NON*;;*NON*;	MOV	FRAME_NUM,FRAME_SET	; ƒtƒŒ[ƒ€”Ô†(0=‚È‚É‚à‚µ‚È‚¢)
;*NON*;	CALL	SL_SIZE			; ƒTƒCƒYŽw’è
;*NON*;
;*NON*;	MOV	AX,SIZE_VRX		; ‚u‚q‚`‚l@‚wÀ•W
;*NON*;	MOV	BX,SIZE_VRY		; ‚u‚q‚`‚l@‚xÀ•W
;*NON*;	MOV	CX,SIZE_VRLENX		; ‚w•ûŒü’·‚³
;*NON*;	MOV	DX,SIZE_VRLENY		; ‚x•ûŒü’·‚³
;*NON*;	MOV	VRX,AX			;
;*NON*;	MOV	VRY,BX			;
;*NON*;	MOV	VRLENX,CX		;
;*NON*;	MOV	VRLENY,DX		;
;*NON*;
;*NON*;	CMP	FRAME_NUM,5		; ‚‹´“Á•ÊƒtƒŒ[ƒ€”Ô†
;*NON*;	JE	TAKAHASHI		;
;*NON*;	CALL	PATGET			; ƒp[ƒc‚f‚d‚s
;*NON*;	JMP	TAKAHASHI2		;
;*NON*;TAKAHASHI:				;
;*NON*;	CALL	PATGTA			; ƒp[ƒc‚f‚d‚sˆ³k–³‚µ
;*NON*;TAKAHASHI2:				;
;*NON*;	CMP	AX,0			;
;*NON*;	JE	AANIME_NOERROR		;
;*NON*;
;*NON*;	PRF	"‚o‚`‚s‚f‚d‚s@ƒGƒ‰[”­¶"
;*NON*;
;*NON*;	PRS	"ƒtƒ@ƒCƒ‹–¼:",FLNM
;*NON*;
;*NON*;	INP	"ƒvƒƒOƒ‰ƒ}‚É˜A—‚¹‚æ"
;*NON*;	INP	"2:WAIT"
;*NON*;	INP	"1:WAIT"
;*NON*;
;*NON*;	JMP	AANIME_EXIT
;*NON*;AANIME_NOERROR:
;*NON*;	JMP	AANIME_LOOP
;*NON*;
;*NON*;AANIME_LOOP_END:
;*NON*;	CALL	PALET_LSET		; ƒpƒŒƒbƒgƒ[ƒh•ƒZƒbƒg
;*NON*;
;*NON*;	CALL	ANIME_MOVE		; ƒAƒjƒ
;*NON*;
;*NON*;AANIME_EXIT:
;*NON*;	RET
AANIME	ENDP



;	ƒAƒjƒ

ANIME_MOVE	PROC	NEAR
	CALL	CLS			; text clear.

	MOV	AN_NUMBER,0		;
ANIME_MOVE_LOOP:			;
	MOV	AX,TIME_WAIT		;
	CALL	TMVWAT			; V-SYNC timer wait.

	MOV	BX,AN_NUMBER		;
	SHL	BX,1			;
	SHL	BX,1			; 2 word pointer.
	MOV	AX,DS:AN_TABLE[BX]	;
	MOV	BX,DS:AN_TABLE[BX][2]	;

	MOV	VRX,AX			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	VRY,BX			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	VRLENX,20		; x length.
	MOV	VRLENY,146		; y length.
	MOVE_IMG	ARA001,ARAVRM,VRX,VRY,VRLENX,VRLENY,0,0

	CALL	CLS
ANIME_MOVE_777:				;
	INC	AN_NUMBER		;

	MOV	AX,AN_NUMBER		;
	CMP	AX,AN_MAX		;
	JL	ANIME_MOVE_788		;
	MOV	AN_NUMBER,0		;
ANIME_MOVE_788:				;

	CALL	ARAPNT			; point pic.
	CMP	AX,2			; ‚Q‹­§I—¹
	JE	ANIME_MOVE_END		;
	JMP	ANIME_MOVE_LOOP		; loop end.

ANIME_MOVE_END:
	RET
ANIME_MOVE	ENDP




;*NON*;;	ƒAƒjƒ
;*NON*;
;*NON*;ANIME_MOVE	PROC	NEAR
;*NON*;	CALL	CLS			; text clear.
;*NON*;
;*NON*;	MOV	GETNUM,0		;
;*NON*;ANIME_MOVE_LOOP:			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	ARAPNT			; point pic.
;*NON*;;*NON*;	CMP	AX,2			; ‚Q‹­§I—¹
;*NON*;;*NON*;	JUMP_EQ	ANIME_MOVE_END		;
;*NON*;
;*NON*;	MOV	VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
;*NON*;	MOV	VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
;*NON*;
;*NON*;	MOV	CX,GETNUM		;
;*NON*;	INC	GETNUM			;
;*NON*;
;*NON*;	CALL	PATPTF			; ƒp[ƒc‚o‚t‚sƒIƒtƒZƒbƒgŽw’è
;*NON*;	CMP	AX,1			;
;*NON*;	JNE	ANIME_MOVE_777		;
;*NON*;
;*NON*;	MOV	GETNUM,0		;
;*NON*;	PRF	"ƒV[ƒPƒ“ƒX‚PŽü‚µ‚Ü‚µ‚½"
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CLS
;*NON*;ANIME_MOVE_777:				;
;*NON*;	JMP	ANIME_MOVE_LOOP		; loop end.
;*NON*;
;*NON*;ANIME_MOVE_END:
;*NON*;	RET
;*NON*;ANIME_MOVE	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;
;*NON*;
;*NON*;;	ƒ^ƒCƒgƒ‹
;*NON*;
;*NON*;TITLES	PROC	NEAR
;*NON*;
;*NON*;	PRF	"	†®†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†²"
;*NON*;	PRF	"	†¤@@@@@@@@@@@@@@@@@†¤"
;*NON*;	PRF	"	†¤@@@ˆ³kƒvƒƒOƒ‰ƒ€ŽÀs’†@@@@†¤"
;*NON*;	PRF	"	†¤@@@@u‚Æ‚ß‚È‚¢‚Å‚Ëv@@@@@†¤"
;*NON*;	PRF	"	†¤@@@@@@@@@@@@@@@@@†¤"
;*NON*;	PRF	"	†¶†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†º"
;*NON*;	PRF	"	1990 (C) r.hashimoto"
;*NON*;
;*NON*;	PRV	"ƒtƒ@ƒCƒ‹”    :",FILE_MAX
;*NON*;	PRV	"ˆ—ƒtƒ@ƒCƒ‹”:",FILE_PNT
;*NON*;
;*NON*;	RET
;*NON*;TITLES	ENDP
;*NON*;
;*NON*;


;	ƒpƒŒƒbƒgƒ[ƒh
;	-I- SI : ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹–¼
;	-O- AX : 1=ƒGƒ‰[

PALET_LSET	PROC	NEAR
	MOV	BX,0			; ƒpƒŒƒbƒgƒe[ƒuƒ‹”Ô†
	CALL	LODPLT			; ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹ƒ[ƒh
	RET
PALET_LSET	ENDP



;	ƒTƒCƒYŽw’è
;	-I- FRAME_NUM     : ƒtƒŒ[ƒ€”Ô†(0=‚È‚É‚à‚µ‚È‚¢)
;	-O- SIZE_VRX[]    : ‚u‚q‚`‚l@‚wÀ•W
;	    SIZE_VRY[]    : ‚u‚q‚`‚l@‚xÀ•W
;	    SIZE_VRLENX[] : ‚w•ûŒü’·‚³
;	    SIZE_VRLENY[] : ‚x•ûŒü’·‚³

SL_SIZE	PROC	NEAR
	CMP	FRAME_NUM,1			; ƒtƒŒ[ƒ€”Ô†
	JL	SL_SIZE_END			;
	CMP	FRAME_NUM,7			; ƒtƒŒ[ƒ€”Ô†
	JG	SL_SIZE_END			;
	JMP	SL_SIZE_SET			;
SL_SIZE_END:					;
	RET

SL_SIZE_SET:
	MOV	BX,FRAME_NUM			; ƒtƒŒ[ƒ€”Ô†
	SHL	BX,1				; word pointer.
	JMP	CS:SL_SIZE_LABEL[BX]		; on goto.
SL_SIZE_LABEL	LABEL	WORD		;
	DW	0
	DW	OFFSET SL_SIZE_1
	DW	OFFSET SL_SIZE_2
	DW	OFFSET SL_SIZE_3
	DW	OFFSET SL_SIZE_4
	DW	OFFSET SL_SIZE_5
	DW	OFFSET SL_SIZE_6
	DW	OFFSET SL_SIZE_7


SL_SIZE_1:
	PRF	" 1:‚n‚oC‚d‚cƒrƒWƒ…ƒAƒ‹	60(480) x 230"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,60			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,230			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,1			; ƒtƒŒ[ƒ€”Ô†
	RET
SL_SIZE_2:
	PRF	" 2:ƒƒCƒ“ƒEƒCƒ“ƒhƒE		46(368) x 200"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,46			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,200			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,2			; ƒtƒŒ[ƒ€”Ô†
	RET
SL_SIZE_3:
	PRF	" 3:ƒCƒxƒ“ƒgƒEƒCƒ“ƒhƒE		39(312) x 160"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,39			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,160			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,3			; ƒtƒŒ[ƒ€”Ô†
	RET
SL_SIZE_4:
;;;;	PRF	" 4:l•¨			17(136) x 140"
	PRF	" 4:í“¬	*****		20(160) x 146"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,20			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,146			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,4			; ƒtƒŒ[ƒ€”Ô†
	RET
SL_SIZE_5:
	PRF	" 5:‚‹´			"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,20			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,146			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,5			; ƒtƒŒ[ƒ€”Ô†
	RET
SL_SIZE_6:
	PRF	" 6:‹M•û‚ªŒˆ‚ß‚é		user X  x user Y"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W

	INP	"‚w•ûŒü’·‚³="
	CALL	STRDEC
	MOV	SIZE_VRLENX,DX			; ‚w•ûŒü’·‚³

	INP	"‚x•ûŒü’·‚³="
	CALL	STRDEC
	MOV	SIZE_VRLENY,DX			; ‚x•ûŒü’·‚³

	MOV	FRAME_NUM,6			; ƒtƒŒ[ƒ€”Ô†
	RET

SL_SIZE_7:
	PRF	" 7:‘S‰æ–Ê‚Ì‚Q•ªŠ„@@@	40(320) x 400 x 2"

	MOV	SIZE_MAX,2			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],0			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],40		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	SIZE_VRX[2],40			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[2],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[2],40		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[2],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	FRAME_NUM,7			; ƒtƒŒ[ƒ€”Ô†
	RET
SL_SIZE	ENDP





;	–¾“x‚T‚O“

HARFBR	PROC	NEAR
	MOV	BX,0
	PRF	"–¾“x‚T‚O“"
	MOV	CRXVEW,0		; F‘Š‰ñ“]i‚O[‚R‚U‚Oj
	MOV	CRXCNS,100		; Ê“x”{—¦i‚O[‚P‚O‚Oj
	MOV	CRXBRI,100		; –¾“x”{—¦i‚O[‚P‚O‚Oj
	CALL	PLPSET			; ƒpƒŒƒbƒg•ÒWƒZƒbƒg
	MOV	CX,50			;
HARFBR3:				;
	PUSH	CX			;
	CALL	CXWAIT			;
	CALL	CXWAIT			;
	CALL	CXWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; ƒpƒŒƒbƒg•ÒWƒZƒbƒg
	POP	CX			;
	DEC	CRXBRI			; –¾“x”{—¦i‚O[‚P‚O‚Oj
	LOOP	HARFBR3			;

	RET
HARFBR	ENDP


;	Žw’èƒtƒ@ƒCƒ‹–¼‚f‚d‚s
;	-I-   FILE_MAX    : Žw’èƒtƒ@ƒCƒ‹”
;	-I/O- FILE_PNT    : Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
;	      FILE_TABLE[]: ƒtƒ@ƒCƒ‹–¼ƒe[ƒuƒ‹
;	-O-   SI          : ƒtƒ@ƒCƒ‹–¼
;	      AX          : 1=I—¹,0=’Êí

FLGET	PROC	NEAR
	MOV	AX,FILE_PNT		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
	CMP	AX,FILE_MAX		; Žw’èƒtƒ@ƒCƒ‹”
	JGE	FLGET_END		; I—¹‚©H

	MOV	BX,FILE_PNT		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
	SHL	BX,1			; word pointer.
	MOV	SI,DS:FILE_TABLE[BX]	; ƒtƒ@ƒCƒ‹–¼ƒe[ƒuƒ‹

	INC	FILE_PNT		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^

	MOV	AX,0			; 0=’Êí
	RET
FLGET_END:
	MOV	AX,1			; 1=I—¹
	RET
FLGET	ENDP


;	ƒJ[ƒ\ƒ‹ƒ{ƒ^ƒ“‚n‚e‚e‘Ò‚¿

MSWAT	PROC	NEAR
MSWAT1:
	PUSH	VX1			;
	PUSH	VY1			;
	CALL	PTPIC			; point pick.
	POP	VX1			;
	POP	VY1			;
	CMP	AX,0			; 0:normal,1:pic,2:exit
	JNE	MSWAT1			;

	RET
MSWAT	ENDP

;	ƒtƒ@ƒCƒ‹–¼ƒZƒbƒg
;	-I/O- SI          : ƒtƒ@ƒCƒ‹–¼
;	-O-   FLNM        : file name.
;	      FLNM_WRITE  : write file name.("??????"->"X??????")

FLSET	PROC	NEAR
	PUSH	AX
	PUSH	CX
	PUSH	DI

	MOV	AX,DS
	MOV	ES,AX

	MOV	BYTE PTR DS:[SI][8],0	; end of string.

	MOV	AL,' '
	MOV	DI,OFFSET FLNM		; file name.
	MOV	CX,8
	REP	STOSB

	MOV	AL,' '
	MOV	DI,OFFSET FLNM_WRITE2	; write file name.(skip top)
	MOV	CX,8-1
	REP	STOSB

	SETS	FLNM			; file name.
	SETS	FLNM_WRITE2		; write file name.(skip top)

	POP	DI
	POP	CX
	POP	AX
	RET
FLSET	ENDP


CXWAIT	PROC	NEAR
	PUSH	CX
	MOV	CX,5000
CXWAIT2:
	LOOP	CXWAIT2
	POP	CX
	RET
CXWAIT	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	CRXVEW:WORD		; F‘Š‰ñ“]i‚O[‚R‚U‚Oj
EXTRN	CRXCNS:WORD		; Ê“x”{—¦i‚O[‚P‚O‚Oj
EXTRN	CRXBRI:WORD		; –¾“x”{—¦i‚O[‚P‚O‚Oj
EXTRN	CRXWHI:WORD		; ƒzƒƒCƒgƒŒƒxƒ‹i‚O[‚P‚O‚Oj

EXTRN	ARAVRM:WORD		; vram area.
EXTRN	ARA001:WORD		; ram area 1.
EXTRN	ARA002:WORD		; ram area 2.


EXTRN	GX1:WORD
EXTRN	GY1:WORD
EXTRN	GX2:WORD
EXTRN	GY2:WORD
EXTRN	GMODE:WORD
EXTRN	GCODE:WORD
EXTRN	GCLR:WORD
EXTRN	GRD:WORD

EXTRN	CLRSOU:WORD		; •ÏXƒJƒ‰[ƒpƒŒƒbƒg
EXTRN	CLRDES:WORD		; •ÏXŒãƒJƒ‰[ƒpƒŒƒbƒg

EXTRN	VX1:WORD		; left side x.
EXTRN	VY1:WORD		; left side y.
EXTRN	VX2:WORD		; right side x.
EXTRN	VY2:WORD		; right side y.
EXTRN	ADRS:WORD		; address.
EXTRN	NUM:WORD		; number.

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3


	EXTRN	SSGR0:WORD		; visual data segment plean 0
	EXTRN	SSGR1:WORD		; visual data segment plean 1
	EXTRN	SSGR2:WORD		; visual data segment plean 2
	EXTRN	SSGR3:WORD		; visual data segment plean 3

	EXTRN	SSDES0:WORD		; visual data segment plean 0
	EXTRN	SSDES1:WORD		; visual data segment plean 1
	EXTRN	SSDES2:WORD		; visual data segment plean 2
	EXTRN	SSDES3:WORD		; visual data segment plean 3

	EXTRN	SSSOU0:WORD		; visual data segment plean 0
	EXTRN	SSSOU1:WORD		; visual data segment plean 1
	EXTRN	SSSOU2:WORD		; visual data segment plean 2
	EXTRN	SSSOU3:WORD		; visual data segment plean 3


	EXTRN	VX1:WORD		; source point x1.
	EXTRN	VY1:WORD		; source point y1.
	EXTRN	VX2:WORD		; length x2.
	EXTRN	VY2:WORD		; length y2.
	EXTRN	VX3:WORD		; destination point x3.
	EXTRN	VY3:WORD		; destination point y3.


EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.
EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; ƒf[ƒ^ƒoƒbƒtƒ@ƒ|ƒCƒ“ƒ^
EXTRN	BPNTSG:WORD		; ƒf[ƒ^ƒoƒbƒtƒ@ƒZƒOƒƒ“ƒg
EXTRN	BCNTMX:WORD		; ƒf[ƒ^Å‘å’·‚³
EXTRN	BCOUNT:WORD		; ƒf[ƒ^’·‚³

EXTRN	CLRSOU:WORD		; •ÏXƒJƒ‰[ƒpƒŒƒbƒg
EXTRN	CLRDES:WORD		; •ÏXŒãƒJƒ‰[ƒpƒŒƒbƒg


TIME_WAIT	DW	0	; ‚u|‚r‚x‚m‚b‘Ò‚¿




			;12345678
FLNM		DB	"        ",0,0	; file name.

FLNM_PALET	DB	"A       ",0,0	; ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹–¼

FLNM_WORK	DB	"A       ",0,0	; write work file name.

FLNM_WRITE	DB	"X"		; write file name.
FLNM_WRITE2	DB	"       ",0,0	;


AN_NUMBER	DW	0
AN_MAX		DW	9
AN_TABLE	LABEL	WORD
		DW	20*0   ,146*0
		DW	20*1   ,146*0
		DW	20*2   ,146*0
		DW	20*0   ,146*1
		DW	20*1   ,146*1
		DW	20*2   ,146*1
		DW	20*0   ,146*2
		DW	20*1   ,146*2
		DW	20*2   ,146*2
		DW	-1,-1




		EVEN

GETNUM		DW	0	; ƒpƒ^[ƒ“‚f‚d‚s”Ô†

FILE_MAX	DW	12	; Žw’èƒtƒ@ƒCƒ‹”
FILE_UPPER	DW	22	; Žw’èƒtƒ@ƒCƒ‹”ãŒÀ
FILE_PNT	DW	0	; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
FILE_TABLE	LABEL	WORD	; ƒtƒ@ƒCƒ‹–¼ƒe[ƒuƒ‹
		DW	OFFSET FILE_NM0
		DW	OFFSET FILE_NM1
		DW	OFFSET FILE_NM2
		DW	OFFSET FILE_NM3
		DW	OFFSET FILE_NM4
		DW	OFFSET FILE_NM5
		DW	OFFSET FILE_NM6
		DW	OFFSET FILE_NM7
		DW	OFFSET FILE_NM8
		DW	OFFSET FILE_NM9
		DW	OFFSET FILE_NM10
		DW	OFFSET FILE_NM11
		DW	OFFSET FILE_NM12
		DW	OFFSET FILE_NM13
		DW	OFFSET FILE_NM14
		DW	OFFSET FILE_NM15
		DW	OFFSET FILE_NM16
		DW	OFFSET FILE_NM17
		DW	OFFSET FILE_NM18
		DW	OFFSET FILE_NM19
		DW	OFFSET FILE_NM20
		DW	OFFSET FILE_NM21
FILE_NM0	DB	"A1      ",0,0
FILE_NM1	DB	"A2      ",0,0
FILE_NM2	DB	"A3      ",0,0
FILE_NM3	DB	"A4      ",0,0
FILE_NM4	DB	"A5      ",0,0
FILE_NM5	DB	"A6      ",0,0
FILE_NM6	DB	"A7      ",0,0
FILE_NM7	DB	"A8      ",0,0
FILE_NM8	DB	"A9      ",0,0
FILE_NM9	DB	"A10     ",0,0
FILE_NM10	DB	"A11     ",0,0
FILE_NM11	DB	"A12     ",0,0
FILE_NM12	DB	"        ",0,0
FILE_NM13	DB	"        ",0,0
FILE_NM14	DB	"        ",0,0
FILE_NM15	DB	"        ",0,0
FILE_NM16	DB	"        ",0,0
FILE_NM17	DB	"        ",0,0
FILE_NM18	DB	"        ",0,0
FILE_NM19	DB	"        ",0,0
FILE_NM20	DB	"        ",0,0
FILE_NM21	DB	"        ",0,0

		EVEN
SIZE_MAX	DW	0		; Žw’èƒTƒCƒY”
SIZE_UPPER	DW	22		; Žw’èƒTƒCƒY”ãŒÀ
SIZE_PNT	DW	0		; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^
SIZE_VRX	DW	22 DUP (0)	; Žw’è‚o‚t‚sÀ•W‚w
SIZE_VRY	DW	22 DUP (0)	; Žw’è‚o‚t‚sÀ•W‚x
SIZE_VRLENX	DW	22 DUP (0)	; Žw’è‚o‚t‚sÀ•W‚w
SIZE_VRLENY	DW	22 DUP (0)	; Žw’è‚o‚t‚sÀ•W‚x


USER_DRV	DW	0	; ƒ†[ƒUƒhƒ‰ƒCƒu”Ô†
USER_DRV_DEST	DW	0	; ƒ†[ƒU‘‚«ž‚Ýƒhƒ‰ƒCƒu”Ô†

PLSDIR_FLG	DW	0	; ˆ³k•ûŒüŽw’è[1=c•ûŒü]

PALET_OFF	DW	0	; 1=ƒpƒŒƒbƒg“Ç‚Ýž‚Ý’†Ž~

FRAME_NUM	DW	0	; ƒtƒŒ[ƒ€”Ô†

DATA	ENDS

	END
;
;	end of "AANIME.ASM"
;
