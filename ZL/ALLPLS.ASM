; "ALLPLS.ASM" PC-9801UV11 make by R.H 1990/05/17
;
;	Ž©“®Žæ‚èž‚ÝH’ö
;
;

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	ALLPLS		; Ž©“®Žæ‚èž‚ÝH’ö

EXTRN	MSKPLNGET:NEAR	; ƒ}ƒXƒN‰»ƒf[ƒ^‚f‚d‚s
EXTRN	MSKDATGET:NEAR	; ƒ}ƒXƒN”²‚«ƒf[ƒ^‚f‚d‚s

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

EXTRN	PATCLR:NEAR	; ƒp[ƒcƒZƒbƒgƒNƒŠƒA
EXTRN	PATGET:NEAR	; ƒp[ƒc‚f‚d‚s
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

EXTRN	PLSMOD:NEAR	; ˆ³kƒ‚[ƒhØ‚è‘Ö‚¦

EXTRN	BPPPTS:NEAR	; ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹‚ðƒp[ƒcƒoƒbƒtƒ@‚Ö

EXTRN	PATSIZ:NEAR	; ƒp[ƒcƒTƒCƒY‚Ì‚f‚d‚s

EXTRN	VRMCLR:NEAR	; ‚u‚q‚`‚lƒNƒŠƒA

EXTRN	TXTBOX:NEAR	; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg





; *******************************************
;	Ž©“®Žæ‚èž‚ÝH’ö
;	-I- DX : ƒhƒ‰ƒCƒu”Ô†
; *******************************************

ALLPLS	PROC	NEAR
	MOV	USER_DRV,DX		; ƒ†[ƒUƒhƒ‰ƒCƒu”Ô†


	PRF	"Ž©“®Žæ‚èž‚ÝH’ö [*.PT1]"


	CALL	HARFBR			; –¾“x‚T‚O“


	CALL	INPUT_SIZE		; ƒTƒCƒYŽw’è
	CMP	FRAME_NUM,0		; ƒtƒŒ[ƒ€”Ô†
	JUMP_EQ	ALLPLS_EXIT		;


	CALL	INPUT_FILENM		; ƒtƒ@ƒCƒ‹–¼Žw’è
	CMP	FILE_MAX,0		; Žw’èƒtƒ@ƒCƒ‹”
	JUMP_EQ	ALLPLS_EXIT		;

	CALL	FLDUMP			; ƒtƒ@ƒCƒ‹–¼ƒ_ƒ“ƒv

	INP	"ˆ³k•ûŒüŽw’è[1=c•ûŒü]"
	CALL	STRDEC			;
	AND	DX,1			; flags.
	MOV	PLSDIR_FLG,DX		; ˆ³k•ûŒüŽw’è[1=c•ûŒü]


	INP	"Š®¬ƒf[ƒ^‚ð‘‚«ž‚Þƒhƒ‰ƒCƒu”Ô†="
	CALL	STRDEC			;
	MOV	USER_DRV_DEST,DX	; ƒ†[ƒU‘‚«ž‚Ýƒhƒ‰ƒCƒu”Ô†


	INP	"ƒpƒŒƒbƒg“Ç‚Ý‚Ü‚·‚Ë [1=“Ç‚Ü‚È‚¢‚Á‚Ä‚Î]="
	CALL	STRDEC			;
	AND	DX,1			; flags.
	MOV	PALET_OFF,DX		; 1=ƒpƒŒƒbƒg“Ç‚Ýž‚Ý’†Ž~

	LF
	LF
ALLPLS_LOOP:
	MOV	FLNM_WRITE,'X'		; write file name TOP.

	CALL	FLGET			; Žw’èƒtƒ@ƒCƒ‹–¼‚f‚d‚s
	CMP	AX,1			; 1=I—¹
	JUMP_EQ	ALLPLS_EXIT		;

	CALL	FLSET			; ƒtƒ@ƒCƒ‹–¼ƒZƒbƒg

	MOV	AX,USER_DRV		; ƒ†[ƒUƒhƒ‰ƒCƒu”Ô†
	CALL	DSKDR			; drive number set.

	MOV	DX,PLSDIR_FLG		; ˆ³kƒ‚[ƒh(0:’Êí,1:c•ûŒü)
	CALL	PLSMOD			; ˆ³kƒ‚[ƒhØ‚è‘Ö‚¦

	CALL	HARFBR			; –¾“x‚T‚O“


	PRF	"ƒxƒ^ƒtƒ@ƒCƒ‹“Ç‚Ýž‚Ý [*.B1, *.R1, *.G1, *.E1]"

	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ƒxƒ^ƒtƒ@ƒCƒ‹ƒ[ƒh

	MOV	SIZE_PNT,0		; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^=0
ALLPLS_SIZE_LOOP:
	CALL	TITLES			; ƒ^ƒCƒgƒ‹

	PRS	"‚½‚¾‚¢‚Ü‚Ìƒtƒ@ƒCƒ‹:",FLNM

	CALL	PATCLR			; ƒp[ƒcƒZƒbƒgƒNƒŠƒA

	CMP	PALET_OFF,1		; 1=ƒpƒŒƒbƒg“Ç‚Ýž‚Ý’†Ž~
	JE	ALLPLS_PALET_SKIP	;

	MOV	SI,OFFSET FLNM		; file name.
	CALL	BPPPTS			; ƒpƒŒƒbƒgƒtƒ@ƒCƒ‹‚ðƒp[ƒcƒoƒbƒtƒ@‚Ö
ALLPLS_PALET_SKIP:

	MOV	SI,SIZE_PNT		; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^=0
	SHL	SI,1			; word pointer.
	MOV	AX,SIZE_VRX[SI]		; ‚u‚q‚`‚l@‚wÀ•W
	MOV	BX,SIZE_VRY[SI]		; ‚u‚q‚`‚l@‚xÀ•W
	MOV	CX,SIZE_VRLENX[SI]	; ‚w•ûŒü’·‚³
	MOV	DX,SIZE_VRLENY[SI]	; ‚x•ûŒü’·‚³
	MOV	VRX,AX			;
	MOV	VRY,BX			;
	MOV	VRLENX,CX		;
	MOV	VRLENY,DX		;

	CMP	MASK_ON_FLAG,1		;ƒ}ƒXƒNˆ—0=‰½‚à‚µ‚È‚¢,1=ƒ}ƒXƒN‰»ˆ—
	JE	ALLPLS_PALET_MASK	;

	CALL	PATGET			; ƒp[ƒc‚f‚d‚s
	JMP	ALLPLS_PALET_55		;
ALLPLS_PALET_MASK:			;

	CALL	MASK_MAKER		; ƒ}ƒXƒN‰»ƒf[ƒ^
ALLPLS_PALET_55:			;


	CMP	AX,0			;
	JE	ALLPLS_NOERROR		;

	PRF	"‚o‚`‚s‚f‚d‚s@ƒGƒ‰[”­¶"

	PRS	"ƒtƒ@ƒCƒ‹–¼:",FLNM

	INP	"ƒvƒƒOƒ‰ƒ}‚É˜A—‚¹‚æ"
	INP	"2:WAIT"
	INP	"1:WAIT"

	JMP	ALLPLS_EXIT
ALLPLS_NOERROR:
	PRVH	"ƒf[ƒ^’·‚³              BCOUNT=",BCOUNT



	;	"•œŒ³i‚q‚d‚sƒL[‚ð‰Ÿ‚µ‚Äj"

	MOV	DX,PLSDIR_FLG		; ˆ³kƒ‚[ƒh(0:’Êí,1:c•ûŒü)
	CALL	PLSMOD			; ˆ³kƒ‚[ƒhØ‚è‘Ö‚¦

	MOV	CX,1			; ƒp[ƒc”Ô†ƒ`ƒFƒbƒN
	CALL	PATPUT			; ƒp[ƒc‚o‚t‚s


	PRVH	"PATPUT 0:normal end. 1:error.AX=",AX


	CMP	SIZE_MAX,1		; Žw’èƒTƒCƒY”
	JE	ALLPLS_4442		;
	MOV	SI,OFFSET FLNM_WRITE	;
	JMP	ALLPLS_4444		;
ALLPLS_4442:				;
	MOV	SI,OFFSET FLNM		;
ALLPLS_4444:				;
	PUSH	SI
	PR	"ƒp[ƒcƒtƒ@ƒCƒ‹‘‚«ž‚Ý ["
	POP	SI
	CALL	PRINT
	PRF	".PT1]"

	MOV	AX,USER_DRV_DEST	; ƒ†[ƒU‘‚«ž‚Ýƒhƒ‰ƒCƒu”Ô†
	CALL	DSKDR			; drive number set.


	CMP	SIZE_MAX,1		; Žw’èƒTƒCƒY”
	JE	ALLPLS_5552		;
ALLPLS_5551:
	MOV	SI,OFFSET FLNM_WRITE	; write file name."X???????"
	CALL	PATSAV			; ƒp[ƒcƒZ[ƒu
	JMP	ALLPLS_5555		;
ALLPLS_5552:
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATSAV			; ƒp[ƒcƒZ[ƒu
ALLPLS_5555:


	INC	SIZE_PNT		; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	AX,SIZE_PNT		; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^
	CMP	AX,SIZE_MAX		; Žw’èƒTƒCƒY”
	JGE	ALLPLS_NEXT		;

	DEC	FLNM_WRITE	; write file name.("X*"->"W*"->"V*"->"U*"...)

	JMP	ALLPLS_SIZE_LOOP

ALLPLS_NEXT:
	JMP	ALLPLS_LOOP		;

ALLPLS_EXIT:
	MOV	DX,0			; ˆ³kƒ‚[ƒh(0:’Êí,1:c•ûŒü)
	CALL	PLSMOD			; ˆ³kƒ‚[ƒhØ‚è‘Ö‚¦

	RET
ALLPLS	ENDP


; *******************************************
;	ƒ}ƒXƒN‰»ƒf[ƒ^
;	ƒf[ƒ^•œŒ³
;	-I- VRX    : ‚u‚q‚`‚l@‚wÀ•W
;	    VRY    : ‚u‚q‚`‚l@‚xÀ•W
;	    VRLENX : ‚w•ûŒü’·‚³
;	    VRLENY : ‚x•ûŒü’·‚³
;	    MASK_COLOR : ƒ}ƒXƒNˆ— “§–¾F
;	    PLSDIR_FLG : ˆ³kƒ‚[ƒh(0:’Êí,1:c•ûŒü)•K‚¸‚O‚É‚µ‚Ü‚·
; *******************************************

MASK_MAKER	PROC	NEAR
	MOV	DX,PLSDIR_FLG		; ˆ³kƒ‚[ƒh(0:’Êí,1:c•ûŒü)
	CALL	PLSMOD			; ˆ³kƒ‚[ƒhØ‚è‘Ö‚¦

	MOV	CX,MASK_COLOR		; ƒ}ƒXƒNƒJƒ‰[”Ô†
	CALL	MSKPLNGET		; ƒ}ƒXƒN‰»ƒf[ƒ^‚f‚d‚s

	PRF	"(mask)ƒxƒ^ƒtƒ@ƒCƒ‹“Ç‚Ýž‚Ý [*.B1, *.R1, *.G1, *.E1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ƒxƒ^ƒtƒ@ƒCƒ‹ƒ[ƒh

	MOV	CX,MASK_COLOR		; ƒ}ƒXƒNˆ— “§–¾F
	CALL	MSKDATGET		; ƒ}ƒXƒN”²‚«ƒf[ƒ^‚f‚d‚s

	RET
MASK_MAKER	ENDP


;	ƒ^ƒCƒgƒ‹

TITLES	PROC	NEAR

	PRF	"	†®†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†²"
	PRF	"	†¤@@@@@@@@@@@@@@@@@†¤"
	PRF	"	†¤@@@ˆ³kƒvƒƒOƒ‰ƒ€ŽÀs’†@@@@†¤"
	PRF	"	†¤@@@@u‚Æ‚ß‚È‚¢‚Å‚Ëv@@@@@†¤"
	PRF	"	†¤@@@@@@@@@@@@@@@@@†¤"
	PRF	"	†¶†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†¢†º"
	PRF	"	1990 (C) r.hashimoto"

	PRV	"ƒtƒ@ƒCƒ‹”    :",FILE_MAX
	PRV	"ˆ—ƒtƒ@ƒCƒ‹”:",FILE_PNT

	RET
TITLES	ENDP



;	ƒTƒCƒYŽw’è
;	-O- SIZE_VRX[]    : ‚u‚q‚`‚l@‚wÀ•W
;	    SIZE_VRY[]    : ‚u‚q‚`‚l@‚xÀ•W
;	    SIZE_VRLENX[] : ‚w•ûŒü’·‚³
;	    SIZE_VRLENY[] : ‚x•ûŒü’·‚³
;	    SIZE_MAX      : Žw’èƒTƒCƒY”
;	    SIZE_PNT      : Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^=0
;	    FRAME_NUM     : ƒtƒŒ[ƒ€”Ô†(0=‚È‚É‚à‚µ‚È‚¢)
;
;	    MASK_ON_FLAG  : ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢, 1=ƒ}ƒXƒN‰»ˆ—
;	    MASK_COLOR    : ƒ}ƒXƒNˆ— “§–¾F

INPUT_SIZE	PROC	NEAR
	MOV	FRAME_NUM,0			; ƒtƒŒ[ƒ€”Ô†

	MOV	MASK_ON_FLAG,0			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—
	MOV	MASK_COLOR,0			; ƒ}ƒXƒNˆ— “§–¾F

	PRF	" ‚Ç‚ÌƒtƒŒ[ƒ€‚É‚µ‚Ü‚·‚©H"
PRF " 1:‚n‚oC‚d‚cƒrƒWƒ…ƒAƒ‹ 60(480) x 230  2:ƒƒCƒ“ƒEƒCƒ“ƒhƒE 46(368) x 200"
PRF " 3:ƒCƒxƒ“ƒgƒEƒCƒ“ƒhƒE   39(312) x 160  4:l•¨             17(136) x 140"
PRF " 5:ƒAƒCƒeƒ€             13(104) x  92  6:‹M•û‚ªŒˆ‚ß‚é  user X  x user Y"
PRF " 7:‘S‰æ–Ê‚Ì‚Q•ªŠ„       40(320) x 400 x 2   8:í“¬        20(160) x 146"
PRF " 9:ƒ‚ƒ“ƒXƒ^[           32(256) x 190 10:“d”]‚PƒNƒCƒYget54,17 24(192)x367"
	PRF	"11:uŽqˆç‚ÄvƒƒCƒ“‰æ–Ê‚Ì‚Q•ªŠ„ 200(25) x 274 + 440(55) x 274"
	PRF	"12:uŽqˆç‚ÄvƒƒCƒ“‚a‚f‚Ì‚Q•ªŠ„ 200(25) x 336 + 200(25) x 336"
	PRF	"13:uŽqˆç‚ÄvƒrƒWƒ…ƒAƒ‹@@@@ 440(55) x 240"
	PRF	"14:uŽqˆç‚ÄvƒIƒ`EƒtƒŒ[ƒ€@@ 320(40) x 180"
	PRF	"15:uŽqˆç‚Ävƒ~ƒXƒRƒ“EƒtƒŒ[ƒ€ 128(16) x 180"
	PRF	"16:uŽqˆç‚Ävƒ‚ƒ“ƒXƒ^Eƒ}ƒXƒN‰» 264(33) x 260"
	PRF	"17:uŽqˆç‚Äv12:‚ÌŒ´“_Šñ‚¹@@@200(25) x 336 + 200(25) x 336"
	PRF	"18:uŽqˆç‚Äv‚P‚OËƒ}ƒXƒN    19:uŽqˆç‚Äv‚P‚QËƒ}ƒXƒN"
	PRF	"20:uŽqˆç‚Äv‚P‚SËƒ}ƒXƒN    21:uŽqˆç‚Äv‚P‚UËƒ}ƒXƒN"
	PRF	"22:uŽqˆç‚ÄvƒCƒxƒ“ƒgƒEƒCƒ“ƒhƒE@26(208) x 144"
	PRF	"23:uŽqˆç‚ÄvƒtƒFƒCƒXEƒtƒŒ[ƒ€  96(12) x 104"
	PRF	"24:uŽqˆç‚Äv‚P‚PËƒ}ƒXƒN    25:uŽqˆç‚Äv‚P‚RËƒ}ƒXƒN"
	PRF	"26:uŽqˆç‚Äv‚P‚TËƒ}ƒXƒN    27:uŽqˆç‚Äv‚P‚VËƒ}ƒXƒN"
INPUT_SIZE_LOOP:
	INP	" ”Ô†:"
	CALL	STRDEC
	CMP	DX,0
	JE	INPUT_SIZE_LOOP
	CMP	DX,27				; 27=max.
	JG	INPUT_SIZE_LOOP

	MOV	BX,DX				;
	SHL	BX,1				; word pointer.
	JMP	CS:INPUT_SIZE_LABEL[BX]		; on goto.
INPUT_SIZE_LABEL	LABEL	WORD		;
	DW	0
	DW	OFFSET INPUT_SIZE_1
	DW	OFFSET INPUT_SIZE_2
	DW	OFFSET INPUT_SIZE_3
	DW	OFFSET INPUT_SIZE_4
	DW	OFFSET INPUT_SIZE_5
	DW	OFFSET INPUT_SIZE_6
	DW	OFFSET INPUT_SIZE_7
	DW	OFFSET INPUT_SIZE_8
	DW	OFFSET INPUT_SIZE_9
	DW	OFFSET INPUT_SIZE_10
	DW	OFFSET INPUT_SIZE_11
	DW	OFFSET INPUT_SIZE_12
	DW	OFFSET INPUT_SIZE_13
	DW	OFFSET INPUT_SIZE_14
	DW	OFFSET INPUT_SIZE_15
	DW	OFFSET INPUT_SIZE_16
	DW	OFFSET INPUT_SIZE_17
	DW	OFFSET INPUT_SIZE_18
	DW	OFFSET INPUT_SIZE_19
	DW	OFFSET INPUT_SIZE_20
	DW	OFFSET INPUT_SIZE_21
	DW	OFFSET INPUT_SIZE_22
	DW	OFFSET INPUT_SIZE_23

	DW	OFFSET INPUT_SIZE_24
	DW	OFFSET INPUT_SIZE_25
	DW	OFFSET INPUT_SIZE_26
	DW	OFFSET INPUT_SIZE_27

INPUT_SIZE_1:
;*;	PRF	" 1:‚n‚oC‚d‚cƒrƒWƒ…ƒAƒ‹	60(480) x 230"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,60			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,230			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,1			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_2:
;*;	PRF	" 2:ƒƒCƒ“ƒEƒCƒ“ƒhƒE		46(368) x 200"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,46			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,200			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,2			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_3:
;*;	PRF	" 3:ƒCƒxƒ“ƒgƒEƒCƒ“ƒhƒE		39(312) x 160"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,39			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,160			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,3			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_4:
;*;	PRF	" 4:l•¨			17(136) x 140"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,17			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,140			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,4			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_5:
;*;	PRF	" 5:ƒAƒCƒeƒ€			13(104) x  92"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,13			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,92			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,5			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_6:
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

INPUT_SIZE_7:
;*;	PRF	" 7:‘S‰æ–Ê‚Ì‚Q•ªŠ„@@@	40(320) x 400 x 2"

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
INPUT_SIZE_8:
;*;	PRF	" 8:í“¬			20(160) x  146"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,20			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,146			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,8			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_9:
;*;	PRF	" 9:ƒ‚ƒ“ƒXƒ^[			32(256) x  190"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,32			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,190			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,9			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_10:
;*;	PRF	"10:“d”]‚PƒNƒCƒY		get 54,17	24(192) x  367"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,54			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,17			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,24			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,367			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,10			; ƒtƒŒ[ƒ€”Ô†
	RET

INPUT_SIZE_11:
;*;	PRF	"11:uŽqˆç‚ÄvƒƒCƒ“‰æ–Ê‚Ì‚Q•ªŠ„ 200(25) x 274 + 440(55) x 274"

	MOV	SIZE_MAX,2			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],0			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],25		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],274		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	SIZE_VRX[2],25			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[2],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[2],55		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[2],274		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	FRAME_NUM,11			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_12:
;*;	PRF	"12:uŽqˆç‚ÄvƒƒCƒ“‚a‚f‚Ì‚Q•ªŠ„ 200(25) x 336 + 200(25) x 336"

	MOV	SIZE_MAX,2			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],1			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],32			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],25		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],336		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	SIZE_VRX[2],26			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[2],32			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[2],25		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[2],336		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	FRAME_NUM,12			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_13:
;*;	PRF	"13:uŽqˆç‚ÄvƒrƒWƒ…ƒAƒ‹@@@@ 440(55) x 240"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],0			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],55		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],240		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	FRAME_NUM,13			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_14:
;*;	PRF	"14:uŽqˆç‚ÄvƒIƒ`EƒtƒŒ[ƒ€@@ 320(40) x 180"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],0			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],40		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],180		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	FRAME_NUM,14			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_15:
;*;	PRF	"15:uŽqˆç‚Ävƒ~ƒXƒRƒ“EƒtƒŒ[ƒ€ 128(16) x 180"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],0			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],16		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],180		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	FRAME_NUM,15			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_16:
;*;	PRF	"16:uŽqˆç‚Ävƒ‚ƒ“ƒXƒ^Eƒ}ƒXƒN‰» 264(33) x 260"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],0			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],33		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],260		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,16			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_17:
;*;	PRF	"17:uŽqˆç‚Äv12:‚ÌŒ´“_Šñ‚¹@@@200(25) x 336 + 200(25) x 336"

	MOV	SIZE_MAX,2			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],0			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],25		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],336		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	SIZE_VRX[2],25			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[2],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[2],25		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[2],336		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	FRAME_NUM,17			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_18:
;*;	PRF	"18:uŽqˆç‚Äv‚P‚OËƒ}ƒXƒN"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],22			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],61-22		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,18			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_19:
;*;	PRF	"19:uŽqˆç‚Äv‚P‚QËƒ}ƒXƒN"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],18			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],55-18		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,19			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_20:
;*;	PRF	"20:uŽqˆç‚Äv‚P‚SËƒ}ƒXƒN"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],18			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],52-18		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,20			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_21:
;*;	PRF	"21:uŽqˆç‚Äv‚P‚UËƒ}ƒXƒN"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],18			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],56-18		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,21			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_22:
;*;	PRF	"22:uŽqˆç‚ÄvƒCƒxƒ“ƒgƒEƒCƒ“ƒhƒE@26(208) x 144"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,26			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,144			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,22			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_23:
;*;	PRF	"23:uŽqˆç‚ÄvƒtƒFƒCƒXEƒtƒŒ[ƒ€ 96(12) x 104"

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX,0			; ‚u‚q‚`‚l@‚wÀ•W
	MOV	SIZE_VRY,0			; ‚u‚q‚`‚l@‚xÀ•W
	MOV	SIZE_VRLENX,12			; ‚w•ûŒü’·‚³
	MOV	SIZE_VRLENY,104			; ‚x•ûŒü’·‚³
	MOV	FRAME_NUM,23			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_24:
;*;	24:uŽqˆç‚Äv‚P‚PËƒ}ƒXƒN

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],20			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],52-20		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,24			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_25:
;*;	25:uŽqˆç‚Äv‚P‚RËƒ}ƒXƒN

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],21			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],56-21		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,25			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_26:
;*;	26:uŽqˆç‚Äv‚P‚TËƒ}ƒXƒN

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],16			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],47-16		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,26			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE_27:
;*;	27:uŽqˆç‚Äv‚P‚VËƒ}ƒXƒN

	MOV	SIZE_MAX,1			; Žw’èƒTƒCƒY”
	MOV	SIZE_PNT,0			; Žw’èƒTƒCƒYƒ|ƒCƒ“ƒ^

	MOV	SIZE_VRX[0],15			; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRY[0],0			; Žw’è‚o‚t‚sÀ•W‚x
	MOV	SIZE_VRLENX[0],48-15		; Žw’è‚o‚t‚sÀ•W‚w
	MOV	SIZE_VRLENY[0],400		; Žw’è‚o‚t‚sÀ•W‚x

	MOV	MASK_ON_FLAG,1			; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
						; 1=ƒ}ƒXƒN‰»ˆ—

	INP	"ƒ}ƒXƒNˆ— “§–¾F="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; ƒ}ƒXƒNˆ— “§–¾F

	MOV	FRAME_NUM,27			; ƒtƒŒ[ƒ€”Ô†
	RET
INPUT_SIZE	ENDP



;	ƒtƒ@ƒCƒ‹–¼Žw’è
;	-I- FILE_UPPER  : Žw’èƒtƒ@ƒCƒ‹”ãŒÀ
;	-O- FILE_MAX    : Žw’èƒtƒ@ƒCƒ‹”
;	    FILE_PNT    : Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
;	    FILE_TABLE[]: ƒtƒ@ƒCƒ‹–¼ƒe[ƒuƒ‹

INPUT_FILENM	PROC	NEAR
	PR	"ƒtƒ@ƒCƒ‹–¼Žw’è[‡Œv"
	MOV	DX,FILE_UPPER		; Žw’èƒtƒ@ƒCƒ‹”ãŒÀ
	CALL	DECSTR
	CALL	PRINT
	PRF	"ŒÂ‚Ü‚Å]"

	MOV	FILE_MAX,0		; Žw’èƒtƒ@ƒCƒ‹”
	MOV	FILE_PNT,0		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
INPUT_FILENM_LOOP:
	MOV	AX,FILE_PNT		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
	CMP	AX,FILE_UPPER		; Žw’èƒtƒ@ƒCƒ‹”ãŒÀ
	JGE	INPUT_FILENM_EXIT	;

INPUT_FILENM_INP:
	PR	"ƒtƒ@ƒCƒ‹–¼["
	MOV	DX,FILE_PNT
	INC	DX
	CALL	DECSTR
	CALL	PRINT
	INP	"”Ô–Ú]="
	CMP	BYTE PTR DS:[SI],' '
	JB	INPUT_FILENM_EXIT

	MOV	BX,FILE_PNT		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
	SHL	BX,1			; word pointer.
	MOV	DI,DS:FILE_TABLE[BX]	; ƒtƒ@ƒCƒ‹–¼ƒe[ƒuƒ‹

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	CX,8			; limit=7.
INPUT_FILENM_SET:			;
	LODSB				;
	CMP	AL,' '			; space.
	JB	INPUT_FILENM_SET_OK	;
	STOSB				;
	LOOP	INPUT_FILENM_SET	;
INPUT_FILENM_SET_OK:			;
	MOV	AL,0			; end of string.
	STOSB				;

	INC	FILE_PNT		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^


	JMP	INPUT_FILENM_LOOP


INPUT_FILENM_EXIT:			;
	MOV	AX,FILE_PNT		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^
	MOV	FILE_MAX,AX		; Žw’èƒtƒ@ƒCƒ‹”

	MOV	FILE_PNT,0		; Žw’èƒtƒ@ƒCƒ‹ƒ|ƒCƒ“ƒ^

	RET
INPUT_FILENM	ENDP




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




;	ƒtƒ@ƒCƒ‹–¼ƒ_ƒ“ƒv
;	-I-   FILE_MAX    : Žw’èƒtƒ@ƒCƒ‹”
;	      FILE_TABLE[]: ƒtƒ@ƒCƒ‹–¼ƒe[ƒuƒ‹

FLDUMP	PROC	NEAR
	PRV	"Žw’èƒtƒ@ƒCƒ‹”‚Í ",FILE_MAX

	MOV	BX,0
	MOV	CX,FILE_MAX		; Žw’èƒtƒ@ƒCƒ‹”
FLDUMP_LOOP:
	PR	"ƒtƒ@ƒCƒ‹–¼["
	MOV	DX,BX
	SHR	DX,1
	INC	DX
	CALL	DECSTR
	CALL	PRINT
	PR	"”Ô–Ú]:"

	MOV	SI,DS:FILE_TABLE[BX]	; ƒtƒ@ƒCƒ‹–¼ƒe[ƒuƒ‹
	CALL	PRINT

	LF

	INC	BX
	INC	BX

	LOOP	FLDUMP_LOOP

	RET
FLDUMP	ENDP






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

			;12345678
FLNM		DB	"        ",0,0	; file name.

FLNM_WRITE	DB	"X"		; write file name.
FLNM_WRITE2	DB	"       ",0,0	;


		EVEN

FILE_MAX	DW	0	; Žw’èƒtƒ@ƒCƒ‹”
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
FILE_NM0	DB	"        ",0,0
FILE_NM1	DB	"        ",0,0
FILE_NM2	DB	"        ",0,0
FILE_NM3	DB	"        ",0,0
FILE_NM4	DB	"        ",0,0
FILE_NM5	DB	"        ",0,0
FILE_NM6	DB	"        ",0,0
FILE_NM7	DB	"        ",0,0
FILE_NM8	DB	"        ",0,0
FILE_NM9	DB	"        ",0,0
FILE_NM10	DB	"        ",0,0
FILE_NM11	DB	"        ",0,0
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
MASK_ON_FLAG	DW	0		; ƒ}ƒXƒNˆ— 0=‰½‚à‚µ‚È‚¢
					; 1=ƒ}ƒXƒN‰»ˆ—
MASK_COLOR	DW	0		; ƒ}ƒXƒNˆ— “§–¾F

USER_DRV	DW	0	; ƒ†[ƒUƒhƒ‰ƒCƒu”Ô†
USER_DRV_DEST	DW	0	; ƒ†[ƒU‘‚«ž‚Ýƒhƒ‰ƒCƒu”Ô†

PLSDIR_FLG	DW	0	; ˆ³k•ûŒüŽw’è[1=c•ûŒü]

PALET_OFF	DW	0	; 1=ƒpƒŒƒbƒg“Ç‚Ýž‚Ý’†Ž~

FRAME_NUM	DW	0	; ƒtƒŒ[ƒ€”Ô†

DATA	ENDS

	END
;
;	end of "ALLPLS.ASM"
;
