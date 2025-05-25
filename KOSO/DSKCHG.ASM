; "DSKCHG.ASM" PC-9801UV11 make by R.H 1989/12/19
;		1990/04/13,1990/06/11
;
;
;	ƒfƒBƒXƒNƒ`ƒFƒ“ƒWƒƒ
;
;	1991/01/23 ‚c‚h‚r‚j‚h‚nD‚`‚r‚l‚Ìƒnƒ“ƒhƒ‹—p‚É‰ü‘¢
;
;
;	mŽæÁn1990/04/13 ‚c‚h‚r‚j‚q‚cD‚`‚r‚l‚É‘Î‰ž‚µ‚Ä‚¢‚é
;	mŽæÁn‚»‚ÌŽå‚È‰ü‘¢“_‚Í
;	mŽæÁn@‚PjƒfƒBƒŒƒNƒgƒŠƒBƒe[ƒuƒ‹‚ð”¼•ª‚É‚µ‚½
;
;
;	‚c‚r‚j‚n‚o‚m‚s‚Æ‚c‚r‚j‚k‚c‚s‚ðƒR[ƒ‹‚µ‚Ä‚¢‚é‚Ì‚Å1989/12/26”Å‚Ì
;	‚c‚h‚r‚j‚h‚nD‚`‚r‚l‚ÆƒŠƒ“ƒN‚µ‚È‚¯‚ê‚Î‚È‚è‚Ü‚¹‚ñ
;
;	’ˆÓIIƒZƒNƒ^[ƒŠ[ƒh‚ÌƒGƒ‰[‚ª—L‚Á‚½Žž‚Í
;	‚±‚Ìƒoƒbƒtƒ@‚ÌˆÊ’u‚à‹^‚Á‚Ä‚Ý‚é•K—v‚ ‚è‚Ü‚·B
;	‘ÎôA‚k‚h‚m‚j‚ÌŒ‹‡‡˜‚ð‘Ö‚¦‚Ä‚Ý‚é“™EEEE
;	iƒoƒbƒtƒ@‚r‚b‚c‚`‚s‚`‚ª‚c‚l‚`‚Ìƒoƒ“ƒNi‚Q‚e‚e‚e‚e‚ˆ“™j‚É
;	@‚Ü‚½‚ª‚ç‚È‚¢‚æ‚¤‚É‚µ‚Ä‰º‚³‚¢j
;
;	ƒn[ƒhƒfƒBƒXƒNŽg—pŽž‚É‰—‚Ä‚ÍA'$dosxstop'Žw’è‚ð‚µ‚Ä•W€‚c‚n‚r‚Ö‚Ì
;	Ž–‘OƒAƒNƒZƒX‚ðŽ~‚ß‚Ä‰º‚³‚¢B
;
;
;	'SYSTEM.DIR'‚É
;
;		'$dosxstop'‚Æ‚¢‚¤A–¼‘O‚ª‚ ‚Á‚½ê‡‚Í
;		•W€‚c‚n‚r‚ÌŽ–‘OƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
;
;		"$errordsp"‚Æ‚¢‚¤A–¼‘O‚ª‚ ‚Á‚½ê‡‚ÍƒGƒ‰[•\Ž¦‚ð‚µ‚Ü‚·B
;
;		"$unit0="‚Æ‚¢‚¤A–¼‘O‚ª‚ ‚Á‚½ê‡‚Íƒ†ƒjƒbƒg”‚O‚Í
;		ƒhƒ‰ƒCƒuA:,B:,C:,D:,E:,F:...‚Ì‚¢‚¸‚ê‚É‚È‚é‚©‚ð•ÏX‚µ‚Ü‚·B
;		—p–@	"$unit0=C"	: ƒ†ƒjƒbƒg”‚O‚Íƒhƒ‰ƒCƒu‚bF
;
;	1990/07/15 ‚d‚o‚r‚n‚m»‚o‚b|‚R‚W‚U‚l‚Ìƒhƒ‰ƒCƒu‘Îô‚Å
;	@@FDDOORi‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒNj‚ÌƒZƒ“ƒXƒRƒ}ƒ“ƒh(04H)‚ð
;	@@VƒZƒ“ƒXƒRƒ}ƒ“ƒh(84H)‚É•ÏX‚µ‚½‚ª‘o•û‚Æ‚àƒoƒO‚ç‚µ‚«‚à‚Ì
;	@@‚ª‚ ‚éˆ×A‹­§“I‚ÉƒfƒBƒXƒN‚ð“Ç‚Ü‚¹‚éƒXƒe[ƒ^ƒX‚ð•Ô‚·‚æ‚¤‚É‚µ‚½B
;
;	1990/08/20 DKCDORi‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒNj‚Ì”pŽ~B
;
;
;	WIDDISK(WIDDISK.ASM) : WINDOWS/ƒfƒBƒXƒNƒEƒCƒ“ƒhƒE(DSKCHG.ASM—p)
;	‚ð‚b‚`‚k‚k‚·‚éB
;
;
;	ƒfƒBƒXƒN‚h‚c‚Ì“à—e
;	byte
;	0-1	ƒVƒXƒeƒ€‚h‚c
;	2-3	ƒvƒƒOƒ‰ƒ€‚h‚c
;	4-5	ƒfƒBƒXƒN”Ô†
;	6-23	ƒVƒXƒeƒ€—\–ñ
;	24-1023	ƒ†[ƒU‰ð•úƒf[ƒ^
;
;
;	ƒvƒƒOƒ‰ƒ€‚h‚ciMY_DISKPROGj
;	0001H : “d”]Šw‰€‚R
;	0002H : ƒTƒCƒŒƒ“ƒgƒƒrƒEƒX
;	0003H : “d”]Šw‰€‚PƒŠƒƒCƒN
;	0004H : ƒvƒŠƒ“ƒZƒXEƒ[ƒJ[ <====
;
;
; GAME subroutine.

DEBUG	EQU	0		; ƒfƒoƒbƒNƒAƒZƒ“ƒuƒ‹ƒtƒ‰ƒO
IF	DEBUG			; ƒfƒoƒbƒNƒAƒZƒ“ƒuƒ‹ƒtƒ‰ƒO
INCLUDE	TSTSET.INC
ELSE
;	ƒfƒoƒbƒNƒ}ƒNƒƒ_ƒ~[‰»
PRV	MACRO
	ENDM
PRF	MACRO
	ENDM
PRS	MACRO
	ENDM
PRVH	MACRO
	ENDM
LC	MACRO	XX,YY
	PUSH	AX
	PUSH	BX
	MOV	AX,XX
	MOV	BX,YY
	CALL	LOCATE		; locate.
	POP	BX
	POP	BX
	ENDM
ENDIF

MY_DISKSYSNAME	EQU	1111H	; ‚±‚ÌƒVƒXƒeƒ€‚h‚c
MY_DISKPROG	EQU	0004H	; ‚±‚ÌƒvƒƒOƒ‰ƒ€‚h‚c(2=silent,3=DEN1,4=PRI)
MY_DISKNUMSYS	EQU	1	; ‚±‚ÌƒVƒXƒeƒ€ƒfƒBƒXƒN”Ô†
MY_DISKNUMD2	EQU	2	; ‚±‚ÌƒfƒBƒXƒN‚Q‚Ì”Ô†
MY_DISKNUMD3	EQU	3	; ‚±‚ÌƒfƒBƒXƒN‚R‚Ì”Ô†
MY_DISKNUMD4	EQU	4	; ‚±‚ÌƒfƒBƒXƒN‚S‚Ì”Ô†
MY_DISKNUMD5	EQU	5	; ‚±‚ÌƒfƒBƒXƒN‚T‚Ì”Ô†
MY_DISKNUMD6	EQU	6	; ‚±‚ÌƒfƒBƒXƒN‚U‚Ì”Ô†
MY_DISKNUMD7	EQU	7	; ‚±‚ÌƒfƒBƒXƒN‚V‚Ì”Ô†


EXTRN	INT_FDISK_BIOS:FAR	; (far) disk/FD bios.

INT_FD_BIOS	MACRO		; disk/FD bios.
;same;	INT	1BH		; disk bios.
	CALL	INT_FDISK_BIOS	; (far) FD bios.
	ENDM


;*DBG*;INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA,ES:DATA

PUBLIC	DKCINI			; ƒfƒBƒXƒNƒ`ƒFƒ“ƒW‰Šúˆ—
PUBLIC	DKCCHK			; ƒfƒBƒXƒNƒ`ƒFƒ“ƒWƒ`ƒFƒbƒN
PUBLIC	DKCSET			; ƒfƒBƒXƒNƒ`ƒFƒ“ƒWƒZƒbƒg
PUBLIC	DKCRST			; ƒfƒBƒXƒNƒ`ƒFƒ“ƒWƒŠƒZƒbƒg
PUBLIC	DKC_HD			; ƒfƒBƒXƒNƒ`ƒFƒ“ƒWEƒn[ƒhƒfƒBƒXƒNƒ`ƒFƒbƒN

;*NON*;PUBLIC	DKCIDW		; ƒfƒBƒXƒN‚h‚c‚Ì‘‚«ž‚Ý
;*NON*;PUBLIC	DKCINS		; ƒfƒBƒXƒNƒCƒ“ƒT[ƒgƒ`ƒFƒbƒN

PUBLIC	DKCMMD			; ƒƒbƒZ[ƒW“Ë“üƒ‚[ƒh

;*;PUBLIC DKCLD			; ƒfƒBƒXƒN‚h‚cƒ†[ƒUƒf[ƒ^‚Ì“Ç‚Ýž‚Ý
;*;PUBLIC DKCSV			; ƒfƒBƒXƒN‚h‚cƒ†[ƒUƒf[ƒ^‚Ì‘‚«ž‚Ý
;*;PUBLIC DKCWID		; ÃÞ¨½¸ÁªÝ¼Þ•\Ž¦‚·‚éƒEƒCƒ“ƒhƒE‚Ì‘I‘ð

;
;	‚h‚cƒZƒNƒ^‚ÌŒã‚ë‚P‚O‚O‚OƒoƒCƒg‚ð“Ç‚Ý‘‚«Ž©—R‚Ìƒf[ƒ^‚Æ‚·‚é
;


EXTRN	DSKRESET:NEAR		; disk reset.

EXTRN	DSKCLS:NEAR		; file close.

EXTRN	DSKOPNT:NEAR		; temp file open.ƒhƒ‰ƒCƒuŒŸõ–³‚µ
EXTRN	DSKLDT:NEAR		; temp load data.ƒhƒ‰ƒCƒuŒŸõ–³‚µ


;	ŽžŠÔŠÄŽ‹—pƒ^ƒCƒ}ƒJƒEƒ“ƒ^

EXTRN	TMVWT4:NEAR		; V-SYNC timer4 wait.

;	ŒxƒƒbƒZ[ƒW‚Ì‚½‚ß‚Ì‚u‚q‚`‚l•\Ž¦ˆ——p

EXTRN	BRIIN:NEAR		; –¾“x‚T‚O“‚©‚çƒm[ƒ}ƒ‹‚Ö
EXTRN	BRIOUT:NEAR		; –¾“x‚T‚O“ƒ_ƒEƒ“

EXTRN	WIDDISK:NEAR		; WINDOWS/ƒfƒBƒXƒNƒEƒCƒ“ƒhƒE(DSKCHG.ASM—p)
;*;EXTRN	WIDMES:NEAR	; ƒƒbƒZ[ƒWEƒEƒCƒ“ƒhƒE
				; ‚»‚Ìˆø”
				; -I- BX : 1=ƒEƒCƒ“ƒhƒEEƒI[ƒvƒ“
				;        : 2=ƒEƒCƒ“ƒhƒEEƒNƒ[ƒY
				;        : 3=ƒEƒCƒ“ƒhƒEEƒƒbƒZ[ƒW^ã’i
				;        : 4=ƒEƒCƒ“ƒhƒEEƒƒbƒZ[ƒW^’†’i
				;        : 5=ƒEƒCƒ“ƒhƒEEƒƒbƒZ[ƒW^‰º’i
				;  DS:SI : ƒƒbƒZ[ƒWEƒAƒhƒŒƒX

EXTRN	MUSINI:NEAR		; ƒ}ƒEƒX‚Ì‰Šú‰»
EXTRN	MUSRED:NEAR		; ƒ}ƒEƒX“Ç‚Ýž‚Ý
EXTRN	MUSSHT:NEAR		; ƒ}ƒEƒX“Ç‚Ýž‚ÝEƒƒ“ƒVƒ‡ƒbƒg
EXTRN	MUSSET:NEAR		; ƒ}ƒEƒXÀ•WƒZƒbƒg
EXTRN	MUSSTB:NEAR		; ƒ}ƒEƒXƒ{ƒ^ƒ“ƒZƒbƒg
EXTRN	MUSSTP:NEAR		; ƒ}ƒEƒX‚ÌI—¹
EXTRN	MUSWAT:NEAR		; ƒ}ƒEƒXƒ{ƒ^ƒ“‚n‚e‚e‘Ò‚¿


TIME_DKCMSG		EQU	40	; ƒƒbƒZ[ƒWŽžŠÔ
TIME_WINDOW		EQU	1	; ƒEƒCƒ“ƒhƒEƒCƒ“ƒ^[ƒoƒ‹ŽžŠÔ

DCYL_ID			EQU	0	; ƒfƒBƒXƒN‚h‚c@ƒVƒŠƒ“ƒ_”Ô†i‚bj
DHEAD_ID		EQU	1	; ƒfƒBƒXƒN‚h‚c@ƒwƒbƒh”Ô†i‚gj
DSECR_ID		EQU	3	; ƒfƒBƒXƒN‚h‚c@ƒZƒNƒ^”Ô†i‚qj
;
ID_LEN			EQU	10	; ƒfƒBƒXƒN‚h‚cƒoƒCƒg”
;
DIRTABLE_MAX		EQU	400	; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹s””ƒ
;
DIRTABLE_NM_LEN		EQU	13+2	; ƒfƒBƒŒƒNƒgƒŠƒBÃ°ÌÞÙ‚Ì‚P–{‚ÌƒoƒCƒg”
DIRTABLE_OF_DNO		EQU	11	; ƒfƒBƒŒƒNƒgƒŠƒBEƒhƒ‰ƒCƒu”Ô†µÌ¾¯Ä
DIRTABLE_OF_NAM		EQU	0	; ƒfƒBƒŒƒNƒgƒŠƒBEƒtƒ@ƒCƒ‹–¼µÌ¾¯Ä
;
DRVNUMMAX_FIX		EQU	4	; ‚P‚l‚e‚cŒÅ’èƒhƒ‰ƒCƒu”
;
FLNLEN		EQU	8		; ƒtƒ@ƒCƒ‹–¼‚Ì’·‚³
FLTLEN		EQU	3		; Šg’£Žq‚Ì’·‚³
;					; ŠeƒIƒtƒZƒbƒg’l
FDMNAM		EQU	0		; ƒtƒ@ƒCƒ‹–¼
FDMTYP		EQU	8H		; Šg’£Žq
FDMATR		EQU	0BH		; ƒtƒ@ƒCƒ‹‘®«
FDMSYS		EQU	0CH		; ƒVƒXƒeƒ€—\–ñ
FDMTIM		EQU	16H		; ƒtƒ@ƒCƒ‹XVŽž
FDMDAT		EQU	18H		; ƒtƒ@ƒCƒ‹XV”NŒŽ“ú
FDMCLS		EQU	1AH		; ƒtƒ@ƒCƒ‹‚ÌÅ‰‚ÌƒNƒ‰ƒXƒ^
FDMSIZ		EQU	1CH		; ƒtƒ@ƒCƒ‹ƒTƒCƒY
;		‚Tf‚Q‚g‚c‚Ìê‡‚Å‚·
DIRMAX		EQU	192		; ƒfƒBƒŒƒNƒgƒŠÅ‘å”
SEC_BYTE	EQU	1024		; ƒZƒNƒ^ƒoƒCƒg”
FATSECTOR 	EQU	4		; ‚e‚`‚sƒe[ƒuƒ‹ƒZƒNƒ^”
ROOTSECTOR 	EQU	6		; ‚q‚n‚n‚s‚c‚h‚qƒZƒNƒ^”
CLAST_OFFSET	EQU	8+1		; ƒNƒ‰ƒXƒ^ŠJŽnˆÊ’u‚ÌƒZƒNƒ^ƒIƒtƒZƒbƒg
;
DISK_RESULT_TOP	EQU	0564H		; ƒŠƒUƒ‹ƒgƒXƒe[ƒ^ƒXî•ñƒAƒhƒŒƒX
DISK_EQUIP	EQU	055CH		; Ú‘±ƒ†ƒjƒbƒg
RDISK_EQUIP	EQU	0488H		; ‚q‚`‚lƒhƒ‰ƒCƒuÚ‘±ó‹µŽ¯•Êƒrƒbƒg
;
DISK_STATUS_DB	EQU	20H		; DMA Boundary. ƒƒ‚ƒŠƒAƒhƒŒƒX‚ª‚c‚l‚`
					; ‚ÉŒü‚¢‚Ä‚¢‚È‚¢iƒoƒ“ƒN‚É‚Ü‚½‚ª‚Á‚½j
DISK_STATUS_NR	EQU	60H		; Not Ready. ƒ†ƒjƒbƒg‚ªƒmƒbƒgƒŒƒfƒBó‘Ô
;
READ_RETCOUNT 	EQU	1		; ƒŠ[ƒhEƒŠƒgƒ‰ƒC‰ñ”
WRITE_RETCOUNT 	EQU	10		; ƒZƒNƒ^‘‚«ž‚ÝEƒŠƒgƒ‰ƒC‰ñ”
;
CHR_LF		EQU	0AH		; ‚k‚eiƒ‰ƒCƒ“ƒtƒB[ƒhj
CHR_CR		EQU	0DH		; ‚b‚qiƒLƒƒƒŠƒbƒWƒŠƒ^[ƒ“j
CHR_EQUAL	EQU	'='		; @ƒCƒR[ƒ‹
CHR_DELIM	EQU	','		; C@ƒfƒŠƒ~ƒ^



;	‚o‚q‚h‚m‚s‚l	h•\Ž¦•¶Žš—ñh

EXTRN	TXTBOX:NEAR	; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg
EXTRN	CLS:NEAR
EXTRN	CHPUT:NEAR
EXTRN	PRINT:NEAR
EXTRN	LOCATE:NEAR

PRINTM	MACRO	STRING
	LOCAL	L1,L2
	PUSH	SI
	JMP	L2
DATA	SEGMENT	PUBLIC	'DATA'
	EVEN
L1	DB	STRING,0DH,0AH,0
	EVEN
DATA	ENDS
L2:	MOV	SI,OFFSET L1
	CALL	MSGPRN
;*DBG*;	CALL	PRINT
	POP	SI
ENDM


;	‚o‚q‚h‚m‚s‚r‚h

PRINTSI	MACRO	STRING
	PUSH	SI
	CALL	MSGPRN
;*DBG*;	CALL	PRINT
	POP	SI
ENDM

PRVV	MACRO	STRING,PARAM
	LOCAL	L1,L2
	PUSH	SI
	PUSH	DX
	PUSH	SI
	JMP	L2
DATA	SEGMENT	PUBLIC	'DATA'
	EVEN
L1	DB	STRING,0
	EVEN
DATA	ENDS
L2:	MOV	SI,OFFSET L1
	EXTRN	PRINT:NEAR
	CALL	PRINT
	POP	SI
	MOV	DX,PARAM
	EXTRN	HEXSTR:NEAR
	CALL	HEXSTR
	CALL	PRINT
	EXTRN	LFPRN:NEAR	;
	CALL	LFPRN		; line feed.
	POP	DX
	POP	SI
	ENDM



;	ƒfƒBƒXƒNƒ`ƒFƒ“ƒW‰Šúˆ—

DKCINI	PROC	NEAR
	CALL	MSG_START	; ƒƒbƒZ[ƒWƒXƒ^[ƒg

	CALL	CURDIRFILERD	; ƒJƒŒƒ“ƒg‚©‚çÃÞ¨Ú¸ÄØÌ§²Ù“Ç‚Ýž‚Ý
	CMP	AX,0		; 0:normal.
	JE	DKCINI_DSKCHK	; ¬Œ÷‚µ‚½‚ç‚±‚Ìƒtƒ@ƒCƒ‹‚Å‚¢‚±‚¤I

	CALL	INSSYS		; ƒVƒXƒeƒ€ƒfƒBƒXƒN‚ð‘}“ü‚³‚¹‚é
	CALL	DIRFILEREAD	; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹“Ç‚Ýž‚Ý

DKCINI_DSKCHK:
				; ‚•‚Ž‚‰‚”‚O

	MOV	SI,OFFSET UNIT0	; ƒ†ƒjƒbƒg”‚O‚Íƒhƒ‰ƒCƒu‰½"$unit0="
	CALL	KFLNSET		; Žw’èƒtƒ@ƒCƒ‹–¼‚ÌƒJƒ‰ƒ€‡‚í‚¹
	CALL	DIRSCH		; ƒfƒBƒŒƒNƒgƒŠƒBƒT[ƒ`
	CMP	AX,0		; 0=Œ©‚Â‚©‚ç‚È‚¢
	JE	DKCINI65	;
	MOV	AL,DIRNAME[7]	; ‘ÎÛƒtƒ@ƒCƒ‹–¼
	SUB	AL,'A'		;
	MOV	DRIVENAME_SFT,AL ; ƒhƒ‰ƒCƒu–¼‚Æ2HDƒ†ƒjƒbƒg”Ô†‚ÌƒYƒŒ
	JMP	DKCINI66	;
DKCINI65:
	MOV	DRIVENAME_SFT,0	; ƒhƒ‰ƒCƒu–¼‚Æ2HDƒ†ƒjƒbƒg”Ô†‚ÌƒYƒŒ
DKCINI66:
				; ‚„‚‚“‚˜‚“‚”‚‚

	MOV	SI,OFFSET DOSXSTOP ; •W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
	CALL	KFLNSET		; Žw’èƒtƒ@ƒCƒ‹–¼‚ÌƒJƒ‰ƒ€‡‚í‚¹
	CALL	DIRSCH		; ƒfƒBƒŒƒNƒgƒŠƒBƒT[ƒ`
	CMP	AX,0		; 0=Œ©‚Â‚©‚ç‚È‚¢
	JE	DKCINI71	;
	MOV	DOSSTP,1	; 0=’Êí,1=•W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
	JMP	DKCINI72	;
DKCINI71:
	MOV	DOSSTP,0	; 0=’Êí,1=•W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
DKCINI72:
				; ‚…‚’‚’‚‚’‚„‚“‚

	MOV	SI,OFFSET ERRORDSP ; ƒGƒ‰[•\Ž¦‚n‚m
	CALL	KFLNSET		; Žw’èƒtƒ@ƒCƒ‹–¼‚ÌƒJƒ‰ƒ€‡‚í‚¹
	CALL	DIRSCH		; ƒfƒBƒŒƒNƒgƒŠƒBƒT[ƒ`
	CMP	AX,0		; 0=Œ©‚Â‚©‚ç‚È‚¢
	JE	DKCINI73	;
	MOV	FLAG_ERR_OUT,1	; 0=ƒGƒ‰[•\Ž¦—}§,1=ƒGƒ‰[•\Ž¦
	JMP	DKCINI74	;
DKCINI73:
	MOV	FLAG_ERR_OUT,0	; 0=ƒGƒ‰[•\Ž¦—}§,1=ƒGƒ‰[•\Ž¦
DKCINI74:
	CALL	MSG_STOP	; ƒƒbƒZ[ƒWƒXƒgƒbƒv
	RET
DKCINI	ENDP



;	ƒfƒBƒXƒNƒ`ƒFƒ“ƒWƒ`ƒFƒbƒN
;	-I- DS:SI : ƒtƒ@ƒCƒ‹–¼
;	-O- DS:SI :(OFFSET DIRNAME) ‘ÎÛƒtƒ@ƒCƒ‹–¼
;	    AX    : 0=•¶Žš—ñŒ©‚Â‚©‚Á‚½, 1=Œ©‚Â‚©‚ç‚È‚¢

DKCCHK	PROC	NEAR
	MOV	FILE_NAME_ADRS,SI	; ƒtƒ@ƒCƒ‹–¼
	CALL	MSG_START		; ƒƒbƒZ[ƒWƒXƒ^[ƒg

	CALL	KFLNSET			; Žw’èƒtƒ@ƒCƒ‹–¼‚ÌƒJƒ‰ƒ€‡‚í‚¹
	CALL	DIRSCH			; ƒfƒBƒŒƒNƒgƒŠƒBƒT[ƒ`
	CMP	AX,0			; 0=Œ©‚Â‚©‚ç‚È‚¢
	JE	DKCCHK_NONE		;

	CMP	DIRDISK,0		; ‘ÎÛƒfƒBƒXƒN”Ô†‚OA‚Ìê‡‚Í
	JE	DKCCHK_CURRENT		; ƒJƒŒƒ“ƒgƒfƒBƒXƒNƒŠ[ƒh‚ÌŽw’è

	CALL	INSDSK			; ƒfƒBƒXƒN‚ð‘}“ü‚³‚¹‚é

	CALL	KFLHANDLE		; ƒnƒ“ƒhƒ‹—pƒpƒX–¼•ÒW
	MOV	SI,OFFSET DIRHANDLEPATH	; ƒnƒ“ƒhƒ‹—pƒpƒX–¼ "A:12345678.123",0

	MOV	AX,0			; 0=•¶Žš—ñŒ©‚Â‚©‚Á‚½
	JMP	DKCCHK_RET		;
DKCCHK_CURRENT:
	MOV	DRVNUM,-1		; Žw’èƒhƒ‰ƒCƒu”Ô†i|‚P‚ÍƒJƒŒƒ“ƒgj
	CALL	KFLHANDLE		; ƒnƒ“ƒhƒ‹—pƒpƒX–¼•ÒW
	MOV	SI,OFFSET DIRHANDLEPATH	; ƒnƒ“ƒhƒ‹—pƒpƒX–¼ "A:12345678.123",0

	MOV	AX,0			; 0=•¶Žš—ñŒ©‚Â‚©‚Á‚½
	JMP	DKCCHK_RET		;
DKCCHK_NONE:
	CALL	DKCMSG			; Œ©‚Â‚©‚ç‚È‚¢ƒƒbƒZ[ƒW
	MOV	AX,1			; 1=Œ©‚Â‚©‚ç‚È‚¢
	JMP	DKCCHK_RET		;
DKCCHK_RET:
	CALL	MSG_STOP		; ƒƒbƒZ[ƒWƒXƒgƒbƒv
	RET
DKCCHK	ENDP



;	ƒfƒBƒXƒNƒ`ƒFƒ“ƒWƒZƒbƒg
;	-I- AX : ƒfƒBƒXƒN”Ô†
;	-O- DX : (DRVNUM+1)ƒhƒ‰ƒCƒu”Ô†(1-4)

DKCSET	PROC	NEAR
	MOV	DIRDISK,AX	; ‘ÎÛƒfƒBƒXƒN”Ô†
	CALL	MSG_START	; ƒƒbƒZ[ƒWƒXƒ^[ƒg
	CALL	INSDSK		; ƒfƒBƒXƒN‚ð‘}“ü‚³‚¹‚é
	CALL	MSG_STOP	; ƒƒbƒZ[ƒWƒXƒgƒbƒv
	MOV	DX,DRVNUM	; Žw’èƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†
	INC	DX		;
	RET
DKCSET	ENDP


;	ƒfƒBƒXƒNƒ`ƒFƒ“ƒWƒŠƒZƒbƒg

DKCRST	PROC	NEAR
	MOV	DISK_DOOR_INI[0],0FFH	; ƒfƒBƒXƒNŠJ•Â‰ŠúÌ×¸Þ
	MOV	DISK_DOOR_INI[1],0FFH	; ƒfƒBƒXƒNŠJ•Â‰ŠúÌ×¸Þ
	MOV	DISK_DOOR_INI[2],0FFH	; ƒfƒBƒXƒNŠJ•Â‰ŠúÌ×¸Þ
	MOV	DISK_DOOR_INI[3],0FFH	; ƒfƒBƒXƒNŠJ•Â‰ŠúÌ×¸Þ
	RET
DKCRST	ENDP


;	ƒfƒBƒXƒNƒ`ƒFƒ“ƒWEƒn[ƒhƒfƒBƒXƒNƒ`ƒFƒbƒN
;	-O- AX : 0=‚e‚c,1=‚g‚c

DKC_HD	PROC	NEAR
	CMP	DOSSTP,1	; 0=’Êí,1=•W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
	JE	DKC_HD_HD	;
DKC_HD_FD:
	MOV	AX,0		; 0=‚e‚c
	RET
DKC_HD_HD:
	MOV	AX,1		; 1=‚g‚c
	RET
DKC_HD	ENDP


;*NON*;
;*NON*;;	ƒfƒBƒXƒN‚h‚c‚Ì‘‚«ž‚Ý
;*NON*;;	-I- AX : ƒhƒ‰ƒCƒu”Ô†i‚P[‚Sj
;*NON*;;	    DX : ƒfƒBƒXƒN”Ô†
;*NON*;;	-O- AX : 0=’Êí
;*NON*;;	       : 1=ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
;*NON*;;	       : 2=ˆá‚¤ƒfƒBƒXƒN‚Ý‚½‚¢
;*NON*;
;*NON*;DKCIDW	PROC	NEAR
;*NON*;	PUSH	DX
;*NON*;
;*NON*;	DEC	AX		; ƒhƒ‰ƒCƒu”Ô†
;*NON*;
;*NON*;	PRV	"ƒhƒ‰ƒCƒu”Ô†=",AX
;*NON*;	PRV	"ƒfƒBƒXƒN”Ô†=",DX
;*NON*;
;*NON*;	MOV	DRVNUM,AX	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;*NON*;
;*NON*;	MOV	AX,MY_DISKSYSNAME	; ‚±‚ÌƒVƒXƒeƒ€‚h‚c
;*NON*;	MOV	ID_DISKSYSNAME,AX	; ƒVƒXƒeƒ€‚h‚c
;*NON*;
;*NON*;	MOV	AX,MY_DISKPROG		; ‚±‚ÌƒvƒƒOƒ‰ƒ€‚h‚c
;*NON*;	MOV	ID_DISKPROG,AX		; ƒvƒƒOƒ‰ƒ€‚h‚c
;*NON*;
;*NON*;	MOV	ID_DISKNUMBER,DX	; ƒfƒBƒXƒN”Ô†
;*NON*;
;*NON*;	CALL	IDPUT		; ”Ä—p•Ï”‚Ì“à—e‚ð‚h‚cƒe[ƒuƒ‹‚ÖƒZƒbƒg
;*NON*;
;*NON*;	CALL	DSKIDSET	; ƒfƒBƒXƒN‚h‚c‚Ì‘‚«ž‚Ý
;*NON*;
;*NON*;	PRV	"0=’Êí,1=ƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢,2=ˆá‚¤ƒfƒBƒXƒN AX=",AX
;*NON*;
;*NON*;	POP	DX
;*NON*;	RET
;*NON*;DKCIDW	ENDP
;*NON*;


;*NON*;;	ƒfƒBƒXƒNƒCƒ“ƒT[ƒgƒ`ƒFƒbƒN
;*NON*;;	-I- DS:SI : ƒtƒ@ƒCƒ‹–¼
;*NON*;;	-O- AX : 0=‘ÎÛƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚Ü‚·
;*NON*;;	         1=‘ÎÛƒfƒBƒXƒN‚ª‘}“ü‚³‚ê‚Ä‚¢‚Ü‚¹‚ñ
;*NON*;;	         2=Œ©‚Â‚©‚ç‚È‚¢
;*NON*;;	    BX : ‘ÎÛƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†
;*NON*;
;*NON*;DKCINS	PROC	NEAR
;*NON*;	MOV	FILE_NAME_ADRS,SI	; ƒtƒ@ƒCƒ‹–¼
;*NON*;
;*NON*;	CALL	KFLNSET		; Žw’èƒtƒ@ƒCƒ‹–¼‚ÌƒJƒ‰ƒ€‡‚í‚¹
;*NON*;	CALL	DIRSCH		; ƒfƒBƒŒƒNƒgƒŠƒBƒT[ƒ`
;*NON*;	CMP	AX,0		; 0=Œ©‚Â‚©‚ç‚È‚¢
;*NON*;	JE	DKCINS_NONE	;
;*NON*;
;*NON*;	CMP	DIRDISK,0	; ‘ÎÛƒfƒBƒXƒN”Ô†‚OA‚Ìê‡‚Í
;*NON*;	JE	DKCINS_SET	; ƒZƒbƒg‚³‚ê‚Ä‚¢‚é
;*NON*;
;*NON*;	MOV	DX,DIRDISK	; ‘ÎÛƒfƒBƒXƒN”Ô†
;*NON*;	MOV	SCH_DISKID,DX	; ŒŸõƒfƒBƒXƒN‚h‚c
;*NON*;	CALL	SYSDRVCHK	; ‘ÎÛƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒuŒŸõ
;*NON*;	MOV	BX,DRVNUM	; ‘ÎÛƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†
;*NON*;	RET
;*NON*;
;*NON*;DKCINS_SET:			;
;*NON*;	MOV	AX,0		; ‘ÎÛƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚Ü‚·
;*NON*;	RET
;*NON*;DKCINS_NONE:			;
;*NON*;	MOV	AX,2		; 0=Œ©‚Â‚©‚ç‚È‚¢
;*NON*;	RET
;*NON*;DKCINS	ENDP
;*NON*;

;*;
;*;;	ƒfƒBƒXƒN‚h‚cƒ†[ƒUƒf[ƒ^‚Ì“Ç‚Ýž‚Ý
;*;;	-I- DX : ƒf[ƒ^ƒoƒbƒtƒ@‚ÌƒZƒOƒƒ“ƒg
;*;;	    DI : ƒf[ƒ^ƒoƒbƒtƒ@‚ÌƒIƒtƒZƒbƒg
;*;;	    CX : “Ç‚Ýž‚Ýƒf[ƒ^ƒoƒCƒg”
;*;;	-O- DX:[DI] : “Ç‚Ýž‚Ýƒf[ƒ^
;*;
;*;DKCLD	PROC	NEAR
;*;	PUSH	CX
;*;	PUSH	DX
;*;	PUSH	DI
;*;
;*;	CALL	MSG_START	; ƒƒbƒZ[ƒWƒXƒ^[ƒg
;*;
;*;	CALL	INSSYS		; ƒVƒXƒeƒ€ƒfƒBƒXƒN‚ð‘}“ü‚³‚¹‚é
;*;
;*;	MOV	AX,DRVNUMSYS	; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
;*;	CALL	READIDSEC	; ‚h‚cƒZƒNƒ^‚Ì“Ç‚Ý‚¾‚µ
;*;
;*;	POP	DI
;*;	POP	DX
;*;	POP	CX
;*;
;*;	MOV	ES,DX			;
;*;	MOV	SI,SCADRS		; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
;*;	ADD	SI,24			; ƒZƒNƒ^‚Ìƒf[ƒ^|„ƒ†[ƒUƒoƒbƒtƒ@
;*;	REP	MOVSB			;
;*;
;*;	CALL	MSG_STOP	; ƒƒbƒZ[ƒWƒXƒgƒbƒv
;*;	RET
;*;DKCLD	ENDP
;*;
;*;
;*;
;*;;	ƒfƒBƒXƒN‚h‚cƒ†[ƒUƒf[ƒ^‚Ì‘‚«ž‚Ý
;*;;	-I- DX : ƒf[ƒ^ƒoƒbƒtƒ@‚ÌƒZƒOƒƒ“ƒg
;*;;	    SI : ƒf[ƒ^ƒoƒbƒtƒ@‚ÌƒIƒtƒZƒbƒg
;*;;	    CX : ‘‚«ž‚Ýƒf[ƒ^ƒoƒCƒg”
;*;;	    DX:[SI] : ‘‚«ž‚Ýƒf[ƒ^
;*;
;*;DKCSV	PROC	NEAR
;*;	PUSH	CX
;*;	PUSH	DX
;*;	PUSH	SI
;*;
;*;	CALL	MSG_START	; ƒƒbƒZ[ƒWƒXƒ^[ƒg
;*;
;*;	CALL	INSSYS		; ƒVƒXƒeƒ€ƒfƒBƒXƒN‚ð‘}“ü‚³‚¹‚é
;*;
;*;	MOV	AX,DRVNUMSYS	; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
;*;	CALL	READIDSEC	; ‚h‚cƒZƒNƒ^‚Ì“Ç‚Ý‚¾‚µ
;*;
;*;	MOV	AX,DRVNUMSYS	; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
;*;	MOV	DRVNUM,AX	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;*;	CALL	IDGET		; ‚h‚cƒe[ƒuƒ‹‚Ì“à—e‚ð”Ä—p•Ï”‚ÖƒZƒbƒg
;*;
;*;	POP	SI
;*;	POP	DX
;*;	POP	CX
;*;
;*;	PUSH	DS
;*;
;*;	MOV	DI,SCADRS		; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
;*;	ADD	DI,24			; ƒZƒNƒ^‚Ìƒf[ƒ^|„ƒ†[ƒUƒoƒbƒtƒ@
;*;	MOV	AX,DS			;
;*;	MOV	ES,AX			;
;*;	MOV	DS,DX			;
;*;	REP	MOVSB			;
;*;
;*;	POP	DS
;*;
;*;	MOV	AX,DRVNUMSYS	; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
;*;	MOV	DRVNUM,AX	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;*;	CALL	IDPUT		; ”Ä—p•Ï”‚Ì“à—e‚ð‚h‚cƒe[ƒuƒ‹‚ÖƒZƒbƒg
;*;
;*;	MOV	AX,DRVNUMSYS	; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
;*;	CALL	WRITEIDSEC	; ‚h‚cƒZƒNƒ^‚Ì‘‚«ž‚Ý
;*;
;*;	CALL	MSG_STOP	; ƒƒbƒZ[ƒWƒXƒgƒbƒv
;*;	RET
;*;DKCSV	ENDP




;	ƒfƒBƒŒƒNƒgƒŠƒBƒT[ƒ`
;	-I- FLNAME  : ƒtƒ@ƒCƒ‹–¼
;	-O- AX      : 1=•¶Žš—ñŒ©‚Â‚©‚Á‚½,0=Œ©‚Â‚©‚ç‚È‚¢
;	    DIRDISK : ‘ÎÛƒfƒBƒXƒN”Ô†
;	    DIRNAME : ‘ÎÛƒtƒ@ƒCƒ‹–¼

DIRSCH	PROC	NEAR
	PRS	"ƒfƒBƒŒƒNƒgƒŠƒBƒT[ƒ`@ƒtƒ@ƒCƒ‹–¼",FLNAME

	CALL	STRSCH			; •¶Žš—ñŒŸõ
	CMP	AX,0			;
	JE	DIRSCH_NONE		;
 
	MOV	SI,BX			; Œ©‚Â‚©‚Á‚½•¶Žš—ñæ“ª
	ADD	SI,DIRTABLE_OF_DNO	; ƒfƒBƒŒƒNƒgƒŠƒBEƒhƒ‰ƒCƒu”Ô†
	MOV	AL,DS:[SI]		; ‘ÎÛƒfƒBƒXƒN”Ô†(CHAR)
	SUB	AL,'0'			;
	MOV	AH,0			;
	MOV	DIRDISK,AX		; ‘ÎÛƒfƒBƒXƒN”Ô†(int)

	MOV	SI,BX			; Œ©‚Â‚©‚Á‚½•¶Žš—ñæ“ª
	ADD	SI,DIRTABLE_OF_NAM	; ƒfƒBƒŒƒNƒgƒŠƒBEƒtƒ@ƒCƒ‹–¼
	MOV	DI,OFFSET DIRNAME	; ‘ÎÛƒtƒ@ƒCƒ‹–¼
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	CX,FLNLEN+FLTLEN  ; Šg’£Žq‚Ì’·‚³+ƒtƒ@ƒCƒ‹–¼‚Ì’·‚³
	REP	MOVSB			;

	MOV	AX,1	; 1=•¶Žš—ñŒ©‚Â‚©‚Á‚½
	JMP	DIRSCH_RET
DIRSCH_NONE:
	MOV	AX,0	; 0=Œ©‚Â‚©‚ç‚È‚¢
	JMP	DIRSCH_RET
DIRSCH_RET:
	PRV	"‘ÎÛƒfƒBƒXƒN”Ô†=",DIRDISK
	PRS	"‘ÎÛƒtƒ@ƒCƒ‹–¼=",DIRNAME
	PRV	"1=•¶Žš—ñŒ©‚Â‚©‚Á‚½,0=Œ©‚Â‚©‚ç‚È‚¢ AX=",AX
	RET
DIRSCH	ENDP



;	•¶Žš—ñŒŸõ
;	'C', ''ƒ`ƒFƒbƒN•t‚«
;	-I- FLNAME  : ƒtƒ@ƒCƒ‹–¼
;	    DIRTABLE: ƒfƒBƒŒƒNƒgƒŠƒBƒe[ƒuƒ‹
;	-O- DS:BX   : Œ©‚Â‚©‚Á‚½•¶Žš—ñæ“ª
;	    AX      : 1=•¶Žš—ñŒ©‚Â‚©‚Á‚½,0=Œ©‚Â‚©‚ç‚È‚¢

STRSCH	PROC	NEAR
	MOV	AX,DS
	MOV	ES,AX
	MOV	SI,OFFSET FLNAME	; ƒtƒ@ƒCƒ‹–¼
	MOV	DI,OFFSET DIRTABLE	; ƒfƒBƒŒƒNƒgƒŠƒBƒe[ƒuƒ‹
STRSCH2:
	MOV	DX,SI			; search string.
	MOV	BX,DI			; string table.
	MOV	CX,FLNLEN+FLTLEN	; ƒtƒ@ƒCƒ‹–¼‚Ì’·‚³+Šg’£Žq‚Ì’·‚³
STRSCH3:
	CMPSB				; dest.
	JNE	STRSCH_NEXT		; ˆá‚¤
	CMP	ES:[DI],BYTE PTR CHR_EQUAL	; @ƒCƒR[ƒ‹
	JE	STRSCH_SCH			; Œ©‚Â‚©‚è‚Ü‚µ‚½
	CMP	ES:[DI],BYTE PTR CHR_DELIM	; C@ƒfƒŠƒ~ƒ^
	JE	STRSCH_SCH			; Œ©‚Â‚©‚è‚Ü‚µ‚½
	LOOP	STRSCH3			;
	JMP	STRSCH_SCH		; Œ©‚Â‚©‚è‚Ü‚µ‚½

STRSCH_NEXT:				;
	MOV	SI,DX			; search string.
	ADD	BX,DIRTABLE_NM_LEN	; Ã°ÌÞÙ‚Ì‚P–{‚ÌƒoƒCƒg”
	MOV	DI,BX			; string table.
	CMP	BYTE PTR DS:[DI],0	; ƒe[ƒuƒ‹I‚í‚èH
	JE	STRSCH_NONE		;

	JMP	STRSCH2			;

STRSCH_SCH:
	MOV	AX,1			; 1=•¶Žš—ñŒ©‚Â‚©‚Á‚½
	RET
STRSCH_NONE:
	MOV	AX,0			; 0=Œ©‚Â‚©‚ç‚È‚¢
	RET
STRSCH	ENDP



;	ƒJƒŒƒ“ƒg‚©‚çƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹“Ç‚Ýž‚Ý
;	-o- AX : 0:normal.
;	         1:error.

CURDIRFILERD	PROC	NEAR
	MOV	SI,OFFSET SYSDIRNAM	; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹–¼
	CALL	DSKOPNT			; temp file open.
	CMP	AX,0			; -o- AX : 0:normal.
	JNE	CURDIRFILERD_EXIT	;	   1:open error.

	CALL	DSKCLS			; file close.

	MOV	SI,OFFSET SYSDIRNAM	; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹–¼
	MOV	DX,SEG DATA		; dest segment address.
	MOV	DI,OFFSET DIRTABLE	; dest offset  address.
	MOV	CX,DIRTABLE_MAX*DIRTABLE_NM_LEN	; data length.
	CALL	DSKLDT			; temp load data.ƒhƒ‰ƒCƒuŒŸõ–³‚µ

CURDIRFILERD_EXIT:
	PRV	"ƒJƒŒƒ“ƒg‚©‚çÃÞ¨Ú¸ÄØÌ§²Ù‚Ì“Ç‚Ýž‚Ý@AX=",AX
	RET
CURDIRFILERD	ENDP



;	ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹“Ç‚Ýž‚Ý
;	-I- DRVNUMSYS : ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
;	-o- AX : 0:normal.
;	         1:error.

DIRFILEREAD	PROC	NEAR
	MOV	BX,DRVNUMSYS		; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
	MOV	AL,DS:DRIVENAME_TBL[BX]	; ƒhƒ‰ƒCƒu–¼ƒe[ƒuƒ‹ 0=A,1=B,2=C,3=D
	ADD	AL,DRIVENAME_SFT	; ƒhƒ‰ƒCƒu–¼‚Æ2HDƒ†ƒjƒbƒg”Ô†‚ÌƒYƒŒ
	MOV	SYSDIRPATH,AL		; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹EƒpƒX–¼

	MOV	SI,OFFSET SYSDIRPATH	; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹EƒpƒX–¼
	MOV	DX,SEG DATA		; dest segment address.
	MOV	DI,OFFSET DIRTABLE	; dest offset  address.
	MOV	CX,DIRTABLE_MAX*DIRTABLE_NM_LEN	; data length.
	CALL	DSKLDT			; temp load data.ƒhƒ‰ƒCƒuŒŸõ–³‚µ

	PRV	"ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹‚Ì“Ç‚Ýž‚Ý@AX=",AX
	RET
DIRFILEREAD	ENDP



;	ƒVƒXƒeƒ€ƒfƒBƒXƒN‚ð‘}“ü‚³‚¹‚é
;	-O- DRVNUMSYS : ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†

INSSYS	PROC	NEAR
	MOV	AX,MY_DISKNUMSYS; ‚±‚ÌƒVƒXƒeƒ€ƒfƒBƒXƒN”Ô†
	MOV	SCH_DISKID,AX	; ŒŸõƒfƒBƒXƒN‚h‚c
	CALL	SYSDRVCHK	; ‘ÎÛƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒuŒŸõ
	CMP	AX,0		; 0=ƒVƒXƒeƒ€ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚é
	JE	INSSYS_OK	;

	MOV	AX,MY_DISKNUMSYS; ‚±‚ÌƒVƒXƒeƒ€ƒfƒBƒXƒN”Ô†
	MOV	SCH_DISKID,AX	; ŒŸõƒfƒBƒXƒN‚h‚c
	CALL	MSG_DISKSET	; ƒfƒBƒXƒNƒZƒbƒg‚ÌƒƒbƒZ[ƒW

	MOV	AX,MY_DISKNUMSYS; ‚±‚ÌƒVƒXƒeƒ€ƒfƒBƒXƒN”Ô†
	MOV	SCH_DISKID,AX	; ŒŸõƒfƒBƒXƒN‚h‚c
	CALL	INSDRIVE_WAIT	; ƒhƒ‰ƒCƒu‚ÉƒZƒbƒg‚³‚ê‚é‚Ì‚ð‘Ò‚Â
INSSYS_OK:
	MOV	AX,DRVNUM	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
	MOV	DRVNUMSYS,AX	; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†
	RET
INSSYS	ENDP



;	Žw’èƒfƒBƒXƒN‚ð‘}“ü‚³‚¹‚é
;	-I- DIRDISK : ‘ÎÛƒfƒBƒXƒN”Ô†
;	-O- DRVNUM  : Žw’èƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†

INSDSK	PROC	NEAR
	PRV	"‘ÎÛƒfƒBƒXƒN”Ô†=",DIRDISK 

	MOV	AX,DIRDISK	; ‘ÎÛƒfƒBƒXƒN”Ô†
	MOV	SCH_DISKID,AX	; ŒŸõƒfƒBƒXƒN‚h‚c
	CALL	SYSDRVCHK	; ‘ÎÛƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒuŒŸõ
	CMP	AX,0		; 0=ƒVƒXƒeƒ€ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚é
	JE	INSDSK_OK	;

	MOV	AX,DIRDISK	; ‘ÎÛƒfƒBƒXƒN”Ô†
	MOV	SCH_DISKID,AX	; ŒŸõƒfƒBƒXƒN‚h‚c
	CALL	MSG_DISKSET	; ƒfƒBƒXƒNƒZƒbƒg‚ÌƒƒbƒZ[ƒW

	CALL	DSKRESET	; disk reset.

	MOV	AX,DIRDISK	; ‘ÎÛƒfƒBƒXƒN”Ô†
	MOV	SCH_DISKID,AX	; ŒŸõƒfƒBƒXƒN‚h‚c
	CALL	INSDRIVE_WAIT	; ƒhƒ‰ƒCƒu‚ÉƒZƒbƒg‚³‚ê‚é‚Ì‚ð‘Ò‚Â
INSDSK_OK:
	PRV	"Žw’èƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†=",DRVNUM
	RET
INSDSK	ENDP



;	ƒfƒBƒXƒNƒZƒbƒg‚ÌƒƒbƒZ[ƒW
;	-I- SCH_DISKID : ŒŸõƒfƒBƒXƒN‚h‚c

MSG_DISKSET	PROC	NEAR
	CMP	SCH_DISKID,MY_DISKNUMSYS ; ‚±‚ÌƒVƒXƒeƒ€ƒfƒBƒXƒN
	JNE	MSG_DISKSET1
	PRINTM	"ƒhƒ‰ƒCƒu‚P‚ÉƒfƒBƒXƒN‚`‚ð‚¢‚ê‚Ä‰º‚³‚¢"
	JMP	MSG_DISKSET99
MSG_DISKSET1:
	CMP	SCH_DISKID,MY_DISKNUMD2	; ‚±‚Ìƒf[ƒ^ƒfƒBƒXƒN‚Q
	JNE	MSG_DISKSET2
	PRINTM	"ƒhƒ‰ƒCƒu‚Q‚ÉƒfƒBƒXƒN‚a‚ð‚¢‚ê‚Ä‰º‚³‚¢"
	JMP	MSG_DISKSET99
MSG_DISKSET2:
	CMP	SCH_DISKID,MY_DISKNUMD3	; ‚±‚Ìƒf[ƒ^ƒfƒBƒXƒN‚R
	JNE	MSG_DISKSET3
	PRINTM	"ƒhƒ‰ƒCƒu‚Q‚ÉƒfƒBƒXƒN‚b‚ð‚¢‚ê‚Ä‰º‚³‚¢"
	JMP	MSG_DISKSET99
MSG_DISKSET3:
	CMP	SCH_DISKID,MY_DISKNUMD4	; ‚±‚Ìƒf[ƒ^ƒfƒBƒXƒN‚S
	JNE	MSG_DISKSET4
	PRINTM	"ƒhƒ‰ƒCƒu‚Q‚ÉƒfƒBƒXƒN‚c‚ð‚¢‚ê‚Ä‰º‚³‚¢"
	JMP	MSG_DISKSET99
MSG_DISKSET4:
	CMP	SCH_DISKID,MY_DISKNUMD5	; ‚±‚Ìƒf[ƒ^ƒfƒBƒXƒN‚T
	JNE	MSG_DISKSET5
	PRINTM	"ƒhƒ‰ƒCƒu‚Q‚ÉƒfƒBƒXƒN‚d‚ð‚¢‚ê‚Ä‰º‚³‚¢"
	JMP	MSG_DISKSET99
MSG_DISKSET5:
	CMP	SCH_DISKID,MY_DISKNUMD6	; ‚±‚Ìƒf[ƒ^ƒfƒBƒXƒN‚U
	JNE	MSG_DISKSET6
	PRINTM	"ƒhƒ‰ƒCƒu‚Q‚ÉƒfƒBƒXƒN‚e‚ð‚¢‚ê‚Ä‰º‚³‚¢"
	JMP	MSG_DISKSET99
MSG_DISKSET6:
	CMP	SCH_DISKID,MY_DISKNUMD7	; ‚±‚Ìƒf[ƒ^ƒfƒBƒXƒN‚V
	JNE	MSG_DISKSET7
	PRINTM	"ƒhƒ‰ƒCƒu‚Q‚ÉƒfƒBƒXƒN‚f‚ð‚¢‚ê‚Ä‰º‚³‚¢"
	JMP	MSG_DISKSET99
MSG_DISKSET7:
MSG_DISKSET99:
	RET
MSG_DISKSET	ENDP



;	ƒhƒ‰ƒCƒu‚ÉƒZƒbƒg‚³‚ê‚é‚Ì‚ð‘Ò‚Â
;	-I- SCH_DISKID : ŒŸõƒfƒBƒXƒN‚h‚c
;	-O- DRVNUM     : ƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj

INSDRIVE_WAIT	PROC	NEAR
	MOV	AX,DRVNUMMAX	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”
	MOV	DRVNUM,AX	; ƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj

INSDRIVE_WAIT_LOOP:
	CMP	DRVNUM,0	; if DRVNUM = 0 then DRVNUM=DRVNUMMAX
	JNE	INSDRIVE_WAIT4	;
	MOV	AX,DRVNUMMAX	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”
	MOV	DRVNUM,AX	; ƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
INSDRIVE_WAIT4:
	DEC	DRVNUM		; ƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj

	MOV	AX,DRVNUM	;
	CALL	RAM_DR_EQUIP	; ‚q‚`‚lƒhƒ‰ƒCƒuÚ‘±ƒ`ƒFƒbƒN

	MOV	AX,DRVNUM	;
	CALL	FDDOOR		; ‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒN
	CMP	AX,1		; 0=‘O‚Æ•Ï‚í‚ç‚¸,1=ƒhƒA‚ðŠJ•Â‚µ‚½
				; 2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ
	JE	INSDRIVE_WAIT_CHK

INSDRIVE_WAIT_NEXT:
	JMP	INSDRIVE_WAIT_LOOP

INSDRIVE_WAIT_CHK:
	CALL	DSKIDCHK		; ƒfƒBƒXƒN‚h‚c‚Ì“Ç‚Ý‚¾‚µ
	CMP	AX,1			; 0=’Êí
	JE	INSDRIVE_WAIT_NEXT	; 1=ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
	CMP	AX,2			;
	JNE	INSDRIVE_WAIT_6		; 2=ˆá‚¤ƒfƒBƒXƒN‚Ý‚½‚¢

	CMP	FLAG_RAM_DR,1		; RAMƒhƒ‰ƒCƒuÚ‘± 1=Ú‘±‚³‚ê‚Ä‚¢‚é
	JE	INSDRIVE_WAIT_NEXT	;
	PRINTM	"‚±‚ÌƒfƒBƒXƒN‚ÍŠÖŒW‚È‚¢‚æI"
	CALL	MSG_DISKSET		; ƒfƒBƒXƒNƒZƒbƒg‚ÌƒƒbƒZ[ƒW

	JMP	INSDRIVE_WAIT_NEXT	;
INSDRIVE_WAIT_6:
	CALL	IDGET			; ‚h‚c‚ð”Ä—p•Ï”‚ÖƒZƒbƒg

	MOV	AX,ID_DISKSYSNAME	; ƒVƒXƒeƒ€‚h‚c
	CMP	AX,MY_DISKSYSNAME	; ‚±‚ÌƒVƒXƒeƒ€‚h‚c
	JE	INSDRIVE_WAIT_SYS_OK	;

	CMP	FLAG_RAM_DR,1		; RAMƒhƒ‰ƒCƒuÚ‘± 1=Ú‘±‚³‚ê‚Ä‚¢‚é
	JE	INSDRIVE_WAIT_NEXT	;
	PRINTM	"‚±‚ê‚Í‚¿‚ª‚¤ƒ\ƒtƒg‚ÌƒfƒBƒXƒN‚Å‚·‚Ë"
	CALL	MSG_DISKSET		; ƒfƒBƒXƒNƒZƒbƒg‚ÌƒƒbƒZ[ƒW

	JMP	INSDRIVE_WAIT_NEXT	;
INSDRIVE_WAIT_SYS_OK:			;
	MOV	AX,ID_DISKPROG		; ƒvƒƒOƒ‰ƒ€‚h‚c
	CMP	AX,MY_DISKPROG		; ‚±‚ÌƒvƒƒOƒ‰ƒ€‚h‚c
	JE	INSDRIVE_WAIT_PROG_OK	;

	CMP	FLAG_RAM_DR,1		; RAMƒhƒ‰ƒCƒuÚ‘± 1=Ú‘±‚³‚ê‚Ä‚¢‚é
	JE	INSDRIVE_WAIT_NEXT	;
	PRINTM	"‚±‚ê‚Í‚¿‚ª‚¤ƒ\ƒtƒg‚ÌƒvƒƒOƒ‰ƒ€‚Å‚·‚Ë"
	CALL	MSG_DISKSET		; ƒfƒBƒXƒNƒZƒbƒg‚ÌƒƒbƒZ[ƒW

	JMP	INSDRIVE_WAIT_NEXT	;
INSDRIVE_WAIT_PROG_OK:			;
	MOV	AX,ID_DISKNUMBER	; ƒfƒBƒXƒN”Ô†
	CMP	AX,SCH_DISKID		; ŒŸõƒfƒBƒXƒN‚h‚c
	JE	INSDRIVE_WAIT_DISK_OK	;

	CMP	FLAG_RAM_DR,1		; RAMƒhƒ‰ƒCƒuÚ‘± 1=Ú‘±‚³‚ê‚Ä‚¢‚é
	JE	INSDRIVE_WAIT_NEXT	;
	PRINTM	"‚±‚ÌƒfƒBƒXƒN‚Å‚Í‚È‚¢‚Å‚·‚æ"
	CALL	MSG_DISKSET		; ƒfƒBƒXƒNƒZƒbƒg‚ÌƒƒbƒZ[ƒW

	JMP	INSDRIVE_WAIT_NEXT
INSDRIVE_WAIT_DISK_OK:
;*NON*;	PRINTM	"ƒfƒBƒXƒN‚ðŠm”F‚µ‚Ü‚µ‚½"

	RET
INSDRIVE_WAIT	ENDP



;	‘ÎÛƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒuŒŸõ
;	-I- SCH_DISKID : ŒŸõƒfƒBƒXƒN‚h‚c
;	-O- AX : 0=‘ÎÛƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚Ü‚·
;	         1=‘ÎÛƒfƒBƒXƒN‚ª‘}“ü‚³‚ê‚Ä‚¢‚Ü‚¹‚ñ
;	         2=
;	         3=
;	    DRVNUM : ‘ÎÛƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†

SYSDRVCHK	PROC	NEAR
	PRV	"ŒŸõƒfƒBƒXƒN‚h‚c=",SCH_DISKID

	MOV	AX,DRVNUMMAX	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”
	MOV	DRVNUM,AX	; ƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
SYSDRVCHK_LOOP:
	CMP	DRVNUM,0	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
	JNE	SYSDRVCHK2	;
	JMP	SYSDRVCHK_NONE	; Œ©‚Â‚©‚ç‚È‚©‚Á‚½
SYSDRVCHK2:
	DEC	DRVNUM		;
	CALL	DSKIDCHK	; ƒfƒBƒXƒN‚h‚c‚Ì“Ç‚Ý‚¾‚µ
	CMP	AX,0		; 0=’Êí
	JNE	SYSDRVCHK_NEXT	; 1=ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
				; 2=ˆá‚¤ƒfƒBƒXƒN‚Ý‚½‚¢

	CALL	IDGET		; ‚h‚c‚ð”Ä—p•Ï”‚ÖƒZƒbƒg

	MOV	AX,ID_DISKSYSNAME ; ƒVƒXƒeƒ€‚h‚c
	CMP	AX,MY_DISKSYSNAME ; ‚±‚ÌƒVƒXƒeƒ€‚h‚c
	JNE	SYSDRVCHK_NEXT	;
	MOV	AX,ID_DISKPROG	; ƒvƒƒOƒ‰ƒ€‚h‚c
	CMP	AX,MY_DISKPROG	; ‚±‚ÌƒvƒƒOƒ‰ƒ€‚h‚c
	JNE	SYSDRVCHK_NEXT	;
	MOV	AX,ID_DISKNUMBER; ƒfƒBƒXƒN”Ô†
	CMP	AX,SCH_DISKID	; ŒŸõƒfƒBƒXƒN‚h‚c
	JNE	SYSDRVCHK_NEXT	;

	JMP	SYSDRVCHK_OK	; ‚±‚ÌƒfƒBƒXƒN‚ª‘ÎÛƒfƒBƒXƒN‚Å‚·
SYSDRVCHK_NEXT:
	JMP	SYSDRVCHK_LOOP	;

SYSDRVCHK_OK:
	MOV	AX,0	; 0=‘ÎÛƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚Ü‚·
	JMP	SYSDRVCHK_RET
SYSDRVCHK_NONE:
	MOV	AX,1	; 1=‘ÎÛƒfƒBƒXƒN‚ª‘}“ü‚³‚ê‚Ä‚¢‚Ü‚¹‚ñ
	JMP	SYSDRVCHK_RET
SYSDRVCHK_RET:
	PRV	"‘ÎÛƒfƒBƒXƒN‚ÍH0=ƒZƒbƒg,1=ƒZƒbƒg‚µ‚Ä‚¢‚È‚¢ AX=",AX
	RET
SYSDRVCHK	ENDP



;	‚h‚cƒe[ƒuƒ‹‚Ì“à—e‚ð”Ä—p•Ï”‚ÖƒZƒbƒg
;	-I- DRVNUM : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	    ID_DISKSYSNAME : ƒVƒXƒeƒ€‚h‚c
;	    ID_DISKPROG    : ƒvƒƒOƒ‰ƒ€‚h‚c
;	    ID_DISKNUMBER  : ƒfƒBƒXƒN”Ô†

IDGET	PROC	NEAR
	PRV	"‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†=",DRVNUM

	MOV	BX,DRVNUM		; ƒhƒ‰ƒCƒu”Ô†
	SHL	BX,1			; word pointer.
	MOV	SI,DS:DSKID_ADRS[BX]	; ƒfƒBƒXƒN‚h‚cƒAƒhƒŒƒXƒe[ƒuƒ‹
	MOV	AX,DS:[SI][0]		;
	MOV	ID_DISKSYSNAME,AX	; ƒVƒXƒeƒ€‚h‚c
	MOV	AX,DS:[SI][2]		;
	MOV	ID_DISKPROG,AX		; ƒvƒƒOƒ‰ƒ€‚h‚c
	MOV	AX,DS:[SI][4]		;
	MOV	ID_DISKNUMBER,AX	; ƒfƒBƒXƒN”Ô†

	PRVH	"ƒVƒXƒeƒ€‚h‚c  =",ID_DISKSYSNAME
	PRVH	"ƒvƒƒOƒ‰ƒ€‚h‚c=",ID_DISKPROG
	PRV	"ƒfƒBƒXƒN”Ô†  =",ID_DISKNUMBER

	RET
IDGET	ENDP



;*;;	”Ä—p•Ï”‚Ì“à—e‚ð‚h‚cƒe[ƒuƒ‹‚ÖƒZƒbƒg
;*;;	-I- DRVNUM : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;*;;	    ID_DISKSYSNAME : ƒVƒXƒeƒ€‚h‚c
;*;;	    ID_DISKPROG    : ƒvƒƒOƒ‰ƒ€‚h‚c
;*;;	    ID_DISKNUMBER  : ƒfƒBƒXƒN”Ô†
;*;
;*;IDPUT	PROC	NEAR
;*;	PRV	"‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†=",DRVNUM
;*;	PRVH	"ƒVƒXƒeƒ€‚h‚c  =",ID_DISKSYSNAME
;*;	PRVH	"ƒvƒƒOƒ‰ƒ€‚h‚c=",ID_DISKPROG
;*;	PRV	"ƒfƒBƒXƒN”Ô†  =",ID_DISKNUMBER
;*;
;*;	MOV	BX,DRVNUM	; ƒhƒ‰ƒCƒu”Ô†
;*;	SHL	BX,1		; word pointer.
;*;	MOV	SI,DS:DSKID_ADRS[BX]	; ƒfƒBƒXƒN‚h‚cƒAƒhƒŒƒXƒe[ƒuƒ‹
;*;	MOV	AX,ID_DISKSYSNAME	; ƒVƒXƒeƒ€‚h‚c
;*;	MOV	DS:[SI][0],AX		;
;*;	MOV	AX,ID_DISKPROG		; ƒvƒƒOƒ‰ƒ€‚h‚c
;*;	MOV	DS:[SI][2],AX		;
;*;	MOV	AX,ID_DISKNUMBER	; ƒfƒBƒXƒN”Ô†
;*;	MOV	DS:[SI][4],AX		;
;*;	RET
;*;IDPUT	ENDP



;	ƒfƒBƒXƒN‚h‚c‚Ì“Ç‚Ý‚¾‚µ
;	-I- DRVNUM : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	-O- DSKID_ADRS[AX*2] : ‚h‚cƒe[ƒuƒ‹
;	    DSKID0 : ƒhƒ‰ƒCƒu‚O‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID1 : ƒhƒ‰ƒCƒu‚P‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID2 : ƒhƒ‰ƒCƒu‚Q‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID3 : ƒhƒ‰ƒCƒu‚R‚Ì‚h‚cƒe[ƒuƒ‹
;	    AX     : 0=’Êí
;	           : 1=ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
;	           : 2=ˆá‚¤ƒfƒBƒXƒN‚Ý‚½‚¢
;	-I/O- DATA:[+SCADRS] : ƒZƒNƒ^‚Ìƒf[ƒ^

DSKIDCHK	PROC	NEAR
	PRV	"ƒfƒBƒXƒN‚h‚c‚Ì“Ç‚Ý‚¾‚µ:‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†=",DRVNUM

	MOV	AX,DRVNUM	;
	CALL	FDDOOR		; ‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒN
	CMP	AX,0		; 0=‘O‚Æ•Ï‚í‚ç‚¸,1=ƒhƒA‚ðŠJ•Â‚µ‚½
	JE	DSKIDCHK_OK	;
	CMP	AX,2		; 2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ
	JE	DSKIDCHK_NOT_RDY

	MOV	AX,DRVNUM	;
	CALL	READIDSEC	; ‚h‚cƒZƒNƒ^‚Ì“Ç‚Ý‚¾‚µ
	CMP	AX,1		; 1=ƒŠ[ƒhƒGƒ‰[
	JE	DSKIDCHK_ERROR	;
	CMP	AX,2		; 2=ƒmƒbƒgƒŒƒfƒB
	JE	DSKIDCHK_NOT_RDY;
DSKIDCHK_OK:
	MOV	AX,0		; 0=’Êí
	RET
DSKIDCHK_NOT_RDY:
	MOV	AX,1		; 1=ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
	RET
DSKIDCHK_ERROR:
	MOV	AX,2		; 2=ˆá‚¤ƒfƒBƒXƒN‚Ý‚½‚¢
	RET
DSKIDCHK	ENDP



;	‚h‚cƒZƒNƒ^‚Ì“Ç‚Ý‚¾‚µ
;	-I- AX : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	-O- DSKID_ADRS[AX*2] : ‚h‚cƒe[ƒuƒ‹
;	    DSKID0 : ƒhƒ‰ƒCƒu‚O‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID1 : ƒhƒ‰ƒCƒu‚P‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID2 : ƒhƒ‰ƒCƒu‚Q‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID3 : ƒhƒ‰ƒCƒu‚R‚Ì‚h‚cƒe[ƒuƒ‹
;	    AX     : 0=³í,1=ƒŠ[ƒhƒGƒ‰[,2=ƒmƒbƒgƒŒƒfƒB
;	-I/O- DATA:[+SCADRS] : ƒZƒNƒ^‚Ìƒf[ƒ^

READIDSEC	PROC	NEAR
	CALL	DRVSET		; ƒhƒ‰ƒCƒu”Ô†‚ÌÝ’èi‚O[‚Rj

	MOV	AX,DCYL_ID	; ƒfƒBƒXƒN‚h‚c@ƒVƒŠƒ“ƒ_”Ô†
	MOV	DCYL,AX		; ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
	MOV	AX,DHEAD_ID	; ƒfƒBƒXƒN‚h‚c@ƒwƒbƒh”Ô†
	MOV	DHEAD,AX	; ƒwƒbƒh”Ô†i‚gj‚O[‚P
	MOV	AX,DSECR_ID	; ƒfƒBƒXƒN‚h‚c@ƒZƒNƒ^”Ô†
	MOV	DSECR,AX	; ƒZƒNƒ^”Ô†i‚qj‚P[‚Wi‚Q‚Uj

	CALL	SCREAD		; ƒZƒNƒ^[ƒŠ[ƒh
	PRV	"READIDSEC call-O-scread DERROR=",DERROR
	CMP	DERROR,0	; 0=³í,1=ƒGƒ‰[
	JNE	READIDSEC_ERROR	;

	CALL	DRVNO		; ƒhƒ‰ƒCƒu”Ô†‚ÌŽæ“¾
	MOV	BX,AX		;
	SHL	BX,1		; word pointer.
	MOV	DI,DS:DSKID_ADRS[BX] ; ƒfƒBƒXƒN‚h‚cƒAƒhƒŒƒXƒe[ƒuƒ‹
	MOV	AX,DS		;
	MOV	ES,AX		;
	MOV	SI,SCADRS	; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
	MOV	CX,ID_LEN	; ƒfƒBƒXƒN‚h‚cƒoƒCƒg”
	REP	MOVSB		;

	MOV	AX,0		; 0=³í
	RET
READIDSEC_ERROR:
	CMP	DSTAT,DISK_STATUS_NR	; Not Ready. ƒ†ƒjƒbƒg‚ªƒmƒbƒgƒŒƒfƒBó‘Ô
	JE	READIDSEC_ERROR2	;
	MOV	AX,1			; 1=ƒŠ[ƒhƒGƒ‰[
	RET
READIDSEC_ERROR2:
	MOV	AX,2			; 2=ƒmƒbƒgƒŒƒfƒB
	RET
READIDSEC	ENDP


;*NON*;
;*NON*;;	ƒfƒBƒXƒN‚h‚c‚Ì‘‚«ž‚Ý
;*NON*;;	-I- DRVNUM : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O|‚Rj
;*NON*;;	    DSKID_ADRS[AX*2] : ‚h‚cƒe[ƒuƒ‹
;*NON*;;	    DSKID0 : ƒhƒ‰ƒCƒu‚O‚Ì‚h‚cƒe[ƒuƒ‹
;*NON*;;	    DSKID1 : ƒhƒ‰ƒCƒu‚P‚Ì‚h‚cƒe[ƒuƒ‹
;*NON*;;	    DSKID2 : ƒhƒ‰ƒCƒu‚Q‚Ì‚h‚cƒe[ƒuƒ‹
;*NON*;;	    DSKID3 : ƒhƒ‰ƒCƒu‚R‚Ì‚h‚cƒe[ƒuƒ‹
;*NON*;;	-O- AX     : 0=’Êí
;*NON*;;	           : 1=ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
;*NON*;;	           : 2=ˆá‚¤ƒfƒBƒXƒN‚Ý‚½‚¢
;*NON*;;	-I/O- DATA:[+SCADRS] : ƒZƒNƒ^‚Ìƒf[ƒ^
;*NON*;
;*NON*;DSKIDSET	PROC	NEAR
;*NON*;	PRV	"ƒfƒBƒXƒN‚h‚c‚Ì‘‚«ž‚Ý:‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†=",DRVNUM
;*NON*;
;*NON*;	MOV	AX,DRVNUM	;
;*NON*;	CALL	FDDOOR		; ‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒN
;*NON*;	CMP	AX,2		; 2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ
;*NON*;	JE	DSKIDSET_NOT_RDY
;*NON*;
;*NON*;	MOV	AX,DRVNUM	;
;*NON*;	CALL	WRITEIDSEC	; ‚h‚cƒZƒNƒ^‚Ì‘‚«ž‚Ý
;*NON*;	CMP	AX,0		; 0=³í,1=ƒŠ[ƒhƒGƒ‰[
;*NON*;	JNE	DSKIDSET_ERROR	;
;*NON*;DSKIDSET_OK:
;*NON*;	MOV	AX,0		; 0=’Êí
;*NON*;	RET
;*NON*;DSKIDSET_NOT_RDY:
;*NON*;	MOV	AX,1		; 1=ƒfƒBƒXƒN‚ÍƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
;*NON*;	RET
;*NON*;DSKIDSET_ERROR:
;*NON*;	MOV	AX,2		; 2=ˆá‚¤ƒfƒBƒXƒN‚Ý‚½‚¢
;*NON*;	RET
;*NON*;DSKIDSET	ENDP
;*NON*;


;	‚h‚cƒZƒNƒ^‚Ì‘‚«ž‚Ý
;	-I- AX : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	    DSKID_ADRS[AX*2] : ‚h‚cƒe[ƒuƒ‹
;	    DSKID0 : ƒhƒ‰ƒCƒu‚O‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID1 : ƒhƒ‰ƒCƒu‚P‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID2 : ƒhƒ‰ƒCƒu‚Q‚Ì‚h‚cƒe[ƒuƒ‹
;	    DSKID3 : ƒhƒ‰ƒCƒu‚R‚Ì‚h‚cƒe[ƒuƒ‹
;	-O- AX     : 0=³í,1=ƒ‰ƒCƒgƒGƒ‰[,2=ƒmƒbƒgƒŒƒfƒB
;	-I/O- DATA:[+SCADRS] : ƒZƒNƒ^‚Ìƒf[ƒ^

WRITEIDSEC	PROC	NEAR
	CALL	DRVSET		; ƒhƒ‰ƒCƒu”Ô†‚ÌÝ’èi‚O[‚Rj

	MOV	BX,AX		;
	SHL	BX,1		; word pointer.
	MOV	SI,DS:DSKID_ADRS[BX] ; ƒfƒBƒXƒN‚h‚cƒAƒhƒŒƒXƒe[ƒuƒ‹
	MOV	AX,DS		;
	MOV	ES,AX		;
	MOV	DI,SCADRS	; ƒZƒNƒ^‚Ìƒf[ƒ^
	MOV	CX,ID_LEN	; ƒfƒBƒXƒN‚h‚cƒoƒCƒg”
	REP	MOVSB		;

	MOV	AX,DCYL_ID	; ƒfƒBƒXƒN‚h‚c@ƒVƒŠƒ“ƒ_”Ô†
	MOV	DCYL,AX		; ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
	MOV	AX,DHEAD_ID	; ƒfƒBƒXƒN‚h‚c@ƒwƒbƒh”Ô†
	MOV	DHEAD,AX	; ƒwƒbƒh”Ô†i‚gj‚O[‚P
	MOV	AX,DSECR_ID	; ƒfƒBƒXƒN‚h‚c@ƒZƒNƒ^”Ô†
	MOV	DSECR,AX	; ƒZƒNƒ^”Ô†i‚qj‚P[‚Wi‚Q‚Uj

	CALL	SCWRITE		; ƒZƒNƒ^[ƒŠ[ƒh
	CMP	DERROR,0	; 0=³í,1=ƒGƒ‰[
	JNE	WRITEIDSEC_ERROR

	MOV	AX,0		; 0=³í
	RET
WRITEIDSEC_ERROR:
	CMP	DSTAT,DISK_STATUS_NR	; Not Ready. ƒ†ƒjƒbƒg‚ªƒmƒbƒgƒŒƒfƒBó‘Ô
	JE	WRITEIDSEC_ERROR2	;
	MOV	AX,1			; 1=ƒ‰ƒCƒgƒGƒ‰[
	RET
WRITEIDSEC_ERROR2:
	MOV	AX,2			; 2=ƒmƒbƒgƒŒƒfƒB
	RET
WRITEIDSEC	ENDP





;	ƒZƒNƒ^[ƒŠ[ƒh
;	ƒoƒEƒ“ƒ_ƒŠƒ“ƒOƒGƒ‰[‚Ìˆ×A‚r‚b‚`‚c‚q‚r‚ª•ÏX‚³‚ê‚éê‡‚ª‚ ‚é
;	-I- DCYL  : ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
;	    DHEAD : ƒwƒbƒh”Ô†i‚gj‚O[‚P
;	    DSECR : ƒZƒNƒ^”Ô†i‚qj‚P[‚Wi‚Q‚Uj
;	-O- SCADRS : ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
;	    DATA:[+SCADRS] : ƒZƒNƒ^‚Ìƒf[ƒ^
;	    DERROR : 0=³í,1=ƒGƒ‰[
;	    DSTAT  : ƒXƒe[ƒ^ƒXî•ñ

SCREAD	PROC	NEAR
	CALL	DOSCALLX	; ‚c‚n‚r‚ÖƒAƒNƒZƒX‚³‚¹‚Ä‚¨‚­

	PRVH	"r DUNIT ",DUNIT; ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†(DA/UA)
	PRVH	"r DLEN  ",DLEN	; ƒf[ƒ^’·i‚c‚s‚kjiƒoƒCƒg’PˆÊj
	PRVH	"r DCYL  ",DCYL ; ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
	PRVH	"r DHEAD ",DHEAD; ƒwƒbƒh”Ô†i‚gj‚O[‚P
	PRVH	"r DSECR ",DSECR; ƒZƒNƒ^”Ô†i‚qj‚P[‚Wi‚Q‚Uj
	PRVH	"r DSECN ",DSECN; ƒZƒNƒ^’·i‚mj

	MOV	AX,READ_RETCOUNT; ƒŠ[ƒhEƒŠƒgƒ‰ƒCƒJƒEƒ“ƒ^
	MOV	READ_RETRY,AX	;

SCREAD5:
	MOV	AX,SEG DATA	; ƒZƒNƒ^ƒoƒbƒtƒ@
	MOV	ES,AX		;
	MOV	BP,SCADRS	; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX

	MOV	AL,BYTE PTR DUNIT ; ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†(DA/UA)
	MOV	BX,WORD PTR DLEN  ; ƒf[ƒ^’·i‚c‚s‚kjiƒoƒCƒg’PˆÊj
	MOV	CL,BYTE PTR DCYL  ; ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
	MOV	DH,BYTE PTR DHEAD ; ƒwƒbƒh”Ô†i‚gj‚O[‚P
	MOV	DL,BYTE PTR DSECR ; ƒZƒNƒ^”Ô†i‚qj‚P[‚Wi‚Q‚Uj
	MOV	CH,BYTE PTR DSECN ; ƒZƒNƒ^’·i‚mj
	MOV	AH,BYTE PTR DREAD ; ‚q‚d‚`‚c@‚c‚`‚s‚`
	INT_FD_BIOS		  ; disk/FD bios.
	MOV	BYTE PTR DSTAT,AH ; ƒXƒe[ƒ^ƒXî•ñ

	JNB	SCREAD9		  ; ³íI—¹

	CMP	BYTE PTR DSTAT,DISK_STATUS_DB
				; DMA Boundary.ƒƒ‚ƒŠƒAƒhƒŒƒX‚ª‚c‚l‚`
				; ‚ÉŒü‚¢‚Ä‚¢‚È‚¢iƒoƒ“ƒN‚É‚Ü‚½‚ª‚Á‚½j
	JNE	SCREAD6
	PRF	"’v–½“I‚ÈƒGƒ‰[( READ SECTOR:error DB )"
	PRINTM	"DMA Boundary error.‚É‚æ‚èƒoƒbƒtƒ@Ø‘Ö"
	MOV	AX,TIME_DKCMSG		; ƒƒbƒZ[ƒWŽžŠÔ
	CALL	TMVWT4			; V-SYNC timer4 wait.

	MOV	SCADRS,OFFSET SCDATA2	; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
	JMP	SCREAD5			; ‚c‚l‚`ƒoƒbƒtƒ@‚Ì•ÏX


SCREAD6:
	DEC	READ_RETRY	  ; ƒŠ[ƒhEƒŠƒgƒ‰ƒCƒJƒEƒ“ƒ^
	JZ	SCREAD99

	MOV	AH,BYTE PTR DRECAL ; ‚q‚d‚b‚`‚k‚h‚a‚q‚`‚s‚d
	INT_FD_BIOS		   ; disk/FD bios.
	MOV	BYTE PTR DSTAT,AH  ; ƒXƒe[ƒ^ƒXî•ñ
	PRVH	"R recalibrate DSTAT=",DSTAT

	JMP	SCREAD5
SCREAD9:
	MOV	DERROR,0	; 0=³í
	RET
SCREAD99:
	MOV	DERROR,1	; 1=ƒGƒ‰[
	MOV	AX,2
;*NON*;	CALL	SCERROR		; ƒfƒBƒXƒN‚h^‚nƒGƒ‰[‚Ì’Ê’m
	RET
SCREAD	ENDP



;	ƒZƒNƒ^[‘‚«ž‚Ý
;	ƒoƒEƒ“ƒ_ƒŠƒ“ƒOƒGƒ‰[‚Ìˆ×A‚r‚b‚`‚c‚q‚r‚ª•ÏX‚³‚ê‚éê‡‚ª‚ ‚é
;	-I- DATA:[+SCADRS] : ƒZƒNƒ^‚Ìƒf[ƒ^
;	    DCYL          : ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
;	    DHEAD         : ƒwƒbƒh”Ô†i‚gj‚O[‚P
;	    DSECR         : ƒZƒNƒ^”Ô†i‚qj‚P[‚Q‚U
;	-O- SCADRS        : ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
;	    DERROR        : 0=³í,1=ƒGƒ‰[
;	    DSTAT         : ƒXƒe[ƒ^ƒXî•ñ

SCWRITE	PROC	NEAR
	CALL	DOSCALLX	; ‚c‚n‚r‚ÖƒAƒNƒZƒX‚³‚¹‚Ä‚¨‚­

SCWRITE0:
	MOV	AH,BYTE PTR DSENSE ; ‚r‚d‚m‚r‚d
	MOV	AL,BYTE PTR DUNIT ; ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†(DA/UA)
	INT_FD_BIOS		  ; disk/FD bios.
	MOV	BYTE PTR DSTAT,AH ; ƒXƒe[ƒ^ƒXî•ñ
	TEST	AH,10H		; 1=ƒ‰ƒCƒgƒvƒƒeƒNƒg‚ª•t‚¢‚Ä‚¢‚é
	JZ	SCWRITE01	;
	JMP	SCWRITE99	; ƒGƒ‰[
SCWRITE01:
	PRVH	"w DUNIT ",DUNIT; ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†(DA/UA)
	PRVH	"w DLEN  ",DLEN ; ƒf[ƒ^’·i‚c‚s‚kjiƒoƒCƒg’PˆÊj
	PRVH	"w DCYL  ",DCYL ; ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
	PRVH	"w DHEAD ",DHEAD; ƒwƒbƒh”Ô†i‚gj‚O[‚P
	PRVH	"w DSECR ",DSECR; ƒZƒNƒ^”Ô†i‚qj‚P[‚Wi‚Q‚Uj
	PRVH	"w DSECN ",DSECN; ƒZƒNƒ^’·i‚mj

	MOV	AX,WRITE_RETCOUNT; ƒZƒNƒ^‘‚«ž‚ÝEƒŠƒgƒ‰ƒC‰ñ”
	MOV	WRITE_RETRY,AX	 ; ƒZƒNƒ^‘‚«ž‚ÝEƒŠƒgƒ‰ƒCƒJƒEƒ“ƒ^
SCWRITE1:
	MOV	AX,SEG DATA	 ; ‚c‚l‚`ƒoƒbƒtƒ@ƒZƒOƒƒ“ƒg
	MOV	ES,AX		 ;
	MOV	BP,SCADRS	 ; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX

	MOV	AL,BYTE PTR DUNIT ; ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†(DA/UA)
	MOV	BX,WORD PTR DLEN  ; ƒf[ƒ^’·i‚c‚s‚kjiƒoƒCƒg’PˆÊj
	MOV	CL,BYTE PTR DCYL  ; ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
	MOV	DH,BYTE PTR DHEAD ; ƒwƒbƒh”Ô†i‚gj‚O[‚P
	MOV	DL,BYTE PTR DSECR ; ƒZƒNƒ^”Ô†i‚qj‚P[‚Q‚U
	MOV	CH,BYTE PTR DSECN ; ƒZƒNƒ^’·i‚mj@

	MOV	AH,BYTE PTR DWRITE; ‚v‚q‚h‚s‚d‚c‚`‚s‚`
	INT_FD_BIOS		  ; disk/FD bios.
	MOV	BYTE PTR DSTAT,AH ; ƒXƒe[ƒ^ƒXî•ñ

	JNB	SCWRITE9	; ³íI—¹

	CMP	BYTE PTR DSTAT,DISK_STATUS_DB
				; DMA Boundary.ƒƒ‚ƒŠƒAƒhƒŒƒX‚ª‚c‚l‚`
				; ‚ÉŒü‚¢‚Ä‚¢‚È‚¢iƒoƒ“ƒN‚É‚Ü‚½‚ª‚Á‚½j
	JNE	SCWRITE5

	PRF	"’v–½“I‚ÈƒGƒ‰[( WRITE SECTOR:error DB )"

	PUSH	AX
	PUSH	CX
	PUSH	ES
	PUSH	DI
	PUSH	SI
	MOV	AX,DS
	MOV	ES,AX
	MOV	SI,OFFSET SCDATA
	MOV	DI,OFFSET SCDATA2
	MOV	CX,SEC_BYTE		; ƒZƒNƒ^ƒoƒbƒtƒ@‚Ì’·‚³
	REP	MOVSB
	POP	SI
	POP	DI
	POP	ES
	POP	CX
	POP	AX

	MOV	SCADRS,OFFSET SCDATA2	; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
	JMP	SCWRITE1		; ‚c‚l‚`ƒoƒbƒtƒ@‚Ì•ÏX

SCWRITE5:
	DEC	WRITE_RETRY	; ƒZƒNƒ^‘‚«ž‚ÝEƒŠƒgƒ‰ƒCƒJƒEƒ“ƒ^
	JZ	SCWRITE99

	MOV	AH,BYTE PTR DRECAL ; ‚q‚d‚b‚`‚k‚h‚a‚q‚`‚s‚d
	INT_FD_BIOS		   ; disk/FD bios.
	MOV	BYTE PTR DSTAT,AH  ; ƒXƒe[ƒ^ƒXî•ñ

	JMP	SCWRITE1	;
SCWRITE9:
	MOV	DERROR,0	; 0=³í
	RET
SCWRITE99:
	MOV	DERROR,1	; 1=ƒGƒ‰[
	RET
SCWRITE	ENDP


;*NON*;
;*NON*;
;*NON*;;	ƒfƒBƒXƒN‚h^‚nƒGƒ‰[‚Ì’Ê’m
;*NON*;;	-I- AX : 1=ƒV[ƒN’†‚ÌƒGƒ‰[
;*NON*;;		 2=“Ç‚Ýž‚Ý’†‚ÌƒGƒ‰[
;*NON*;;		 3=‘‚«ž‚Ý’†‚ÌƒGƒ‰[
;*NON*;;		 4=ƒtƒ@ƒCƒ‹‚ªŒ©‚Â‚©‚ç‚È‚¢
;*NON*;
;*NON*;SCERROR	PROC	NEAR
;*NON*;	CMP	AX,1
;*NON*;	JE	SCERROR1
;*NON*;	CMP	AX,2
;*NON*;	JE	SCERROR2
;*NON*;	CMP	AX,3
;*NON*;	JE	SCERROR3
;*NON*;	CMP	AX,4
;*NON*;	JE	SCERROR4
;*NON*;
;*NON*;	MOV	SI,OFFSET MSGER0
;*NON*;	CALL	PRINT
;*NON*;	RET
;*NON*;SCERROR1:
;*NON*;	MOV	SI,OFFSET MSGER1
;*NON*;	CALL	PRINT
;*NON*;	RET
;*NON*;SCERROR2:
;*NON*;	MOV	SI,OFFSET MSGER2
;*NON*;	CALL	PRINT
;*NON*;	RET
;*NON*;SCERROR3:
;*NON*;	MOV	SI,OFFSET MSGER3
;*NON*;	CALL	PRINT
;*NON*;	RET
;*NON*;SCERROR4:
;*NON*;	MOV	SI,OFFSET MSGER4
;*NON*;	CALL	PRINT
;*NON*;	RET
;*NON*;SCERROR	ENDP
;*NON*;
;*NON*;

;	‚c‚n‚r‚ÖƒAƒNƒZƒX‚³‚¹‚Ä‚¨‚­
;	-I- DOSSTP : 0=’Êí,1=•W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·

DOSCALLX	PROC	NEAR
	CMP	DOSSTP,1	; 0=’Êí,1=•W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
	JE	DOSCALLX9	;

	CALL	DRVNO		; ƒhƒ‰ƒCƒu”Ô†‚ÌŽæ“¾
	MOV	BX,AX		; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†
	MOV	AL,DS:DRIVENAME_TBL[BX]	; ƒhƒ‰ƒCƒu–¼ƒe[ƒuƒ‹ 0=A,1=B,2=C,3=D
	ADD	AL,DRIVENAME_SFT	; ƒhƒ‰ƒCƒu–¼‚Æ2HDƒ†ƒjƒbƒg”Ô†‚ÌƒYƒŒ
	MOV	DOSCALLX_DUMMY,AL ; "A:XXXXYYYYAAA",0 : ‚c‚n‚rƒAƒNƒZƒX—pƒ_ƒ~[

	MOV	SI,OFFSET DOSCALLX_DUMMY
	CALL	DSKOPNT		; DOS file open.ƒhƒ‰ƒCƒuŒŸõ–³‚µÌ§²Ùµ°ÌßÝ
	CMP	AX,0		;
	JNE	DOSCALLX9	;

	CALL	DSKCLS		; DOS file close.
DOSCALLX9:			;
	RET
DOSCALLX	ENDP



;	‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒN
;	-I- AX : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	-O- AX : 0=‘O‚Æ•Ï‚í‚ç‚¸,1=ƒhƒA‚ðŠJ•Â‚µ‚½,2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ

FDDOOR	PROC	NEAR
	PUSH	DX
	PUSH	BX
	PUSH	ES

	PUSH	AX		; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
	CALL	FDEQUIP		; ‚e‚cÚ‘±ƒ`ƒFƒbƒN
	CMP	AX,0		; 1=Ú‘±‚³‚ê‚Ä‚¢‚é,0=Ú‘±–³‚µ
	POP	AX		;
	JE	FDDOOR_NO_SET	;

	PUSH	AX	;
	CALL	FDRSLT	; ‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒN(Ø»ÞÙÄ½Ã°À½Áª¯¸)
	POP	BX	; BX=drive number.
	CMP	AX,1	; 1=ƒhƒA‚ðŠJ•Â‚µ‚½
	JE	FDDOOR_SET
	CMP	AX,0	; 0=‘O‚Æ•Ï‚í‚ç‚¸, 2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ
	JE	FDDOOR_NORMAL

FDDOOR_RETRY:
	; ƒŠƒUƒ‹ƒgƒXƒe[ƒ^ƒXEƒe[ƒuƒ‹‚É”½‰f‚³‚ê‚È‚¢
	; ê‡‚É‘Î‚µ‚Ä‚à‚a‚h‚n‚r‚Åƒ`ƒFƒbƒN‚·‚é

	MOV	AL,BL			; AX=ƒhƒ‰ƒCƒu”Ô†
					; 90H‚Í‚P‚l‚e‚c‚Å‚ ‚é‚±‚Æ‚ðŽ¦‚·
	OR	AL,90H			; AL=ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†(DA/UA)
;*NON*;	MOV	AH,BYTE PTR DSENSE	; ‚r‚d‚m‚r‚d
	MOV	AH,BYTE PTR DSENSE_NEW	; ‚r‚d‚m‚r‚di^‚r‚s‚`‚s‚t‚rj
	INT_FD_BIOS		        ; disk/FD bios.

	JB	FDDOOR_NO_SET		; CF=1 ˆÙíI—¹

	TEST	AH,60H			; 60H=‚m‚q^”}‘Ì‚ªƒZƒbƒg‚³‚ê‚Ä‚¢‚È‚¢
	JNZ	FDDOOR_NO_SET		;
FDDOOR_SET:
	CALL	USER_STANBY		; ƒ†[ƒU‚©‚ç’¼ÚAƒXƒ^ƒ“ƒoƒC‚ªo‚½
	MOV	AX,1			; 1=ƒhƒA‚ðŠJ•Â‚µ‚½
	JMP	FDDOOR9			;
FDDOOR_NO_SET:
	CALL	DRVTIMER		; ƒfƒBƒXƒN‘•’uŠÄŽ‹ƒ^ƒCƒ}
	CALL	USER_STANBY		; ƒ†[ƒU‚©‚ç’¼ÚAƒXƒ^ƒ“ƒoƒC‚ªo‚½
	MOV	AX,2			; 2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ
	JMP	FDDOOR9			;
FDDOOR_NORMAL:
	CALL	USER_STANBY		; ƒ†[ƒU‚©‚ç’¼ÚAƒXƒ^ƒ“ƒoƒC‚ªo‚½
	CMP	BX,1			; 1=ƒXƒ^ƒ“ƒoƒC
	JNE	FDDOOR_NORMAL2		;
	MOV	AX,1			; 1=ƒhƒA‚ðŠJ•Â‚µ‚½
	JMP	FDDOOR9			;
FDDOOR_NORMAL2:
	MOV	AX,0			; 0=‘O‚Æ•Ï‚í‚ç‚¸
FDDOOR9:
	PRV	"FDDOOR -o- (0n,1oc,2o)=",AX
	POP	ES
	POP	BX
	POP	DX
	RET
FDDOOR	ENDP



;	‚e‚cƒhƒ‰ƒCƒuƒhƒAŠJ•Âƒ`ƒFƒbƒNiƒŠƒUƒ‹ƒgƒXƒe[ƒ^ƒXƒ`ƒFƒbƒNj
;	-I- AX : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	-O- AX : 0=‘O‚Æ•Ï‚í‚ç‚¸,1=ƒhƒA‚ðŠJ•Â‚µ‚½,2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ

FDRSLT	PROC	NEAR
	PUSH	DX
	PUSH	BX
	PUSH	ES

	MOV	DX,AX		; DX=ƒhƒ‰ƒCƒu”Ô†

	MOV	BX,AX
	SHL	BX,1	; *2
	SHL	BX,1	; *4
	SHL	BX,1	; *8
	ADD	BX,DISK_RESULT_TOP ; ƒŠƒUƒ‹ƒgƒXƒe[ƒ^ƒXî•ñƒAƒhƒŒƒX
	MOV	AX,0			;
	MOV	ES,AX			;
	MOV	AL,BYTE PTR ES:[BX]	; disk result status ST0.
;		  |iiSenHuu|
;		  |ccEcrDss|
;		  |10    10|
	AND	AL,11001000B

	CMP	AL,0
	JNE	FDRSLT5		;
	MOV	AX,0		; 0=‘O‚Æ•Ï‚í‚ç‚¸
	JMP	FDRSLT9		;
FDRSLT5:
	CMP	AL,11000000B	;
	JNE	FDRSLT6		;
	MOV	AX,1		; 1=ƒhƒA‚ðŠJ•Â‚µ‚½
	JMP	FDRSLT9
FDRSLT6:
	CMP	AL,11001000B	;
	JNE	FDRSLT7		;
	MOV	AX,2		; 2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ
	JMP	FDRSLT9
FDRSLT7:
	MOV	AX,2		; 2=ƒhƒA‚ªŠJ‚«‚Á‚Ï‚È‚µ

FDRSLT9:
	MOV	BX,DX		; DX=ƒhƒ‰ƒCƒu”Ô†
	CMP	BYTE PTR DS:DISK_DOOR_INI[BX],0	; ƒfƒBƒXƒNŠJ•Â‰ŠúÌ×¸Þ
	JZ	FDRSLT_RET

	MOV	BYTE PTR DS:DISK_DOOR_INI[BX],0	; ƒfƒBƒXƒNŠJ•Â‰ŠúÌ×¸Þ
	CMP	AX,0		; 0=‘O‚Æ•Ï‚í‚ç‚¸
	JNE	FDRSLT_RET	;
	MOV	AX,1		; 1=ƒhƒA‚ðŠJ•Â‚µ‚½
FDRSLT_RET:
	POP	ES
	POP	BX
	POP	DX
	RET
FDRSLT	ENDP


;	‚e‚cÚ‘±ƒ`ƒFƒbƒN
;	-I- AX : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	-O- AX : 1=Ú‘±‚³‚ê‚Ä‚¢‚é,0=Ú‘±–³‚µ

FDEQUIP	PROC	NEAR
	PUSH	CX
	PUSH	DX

	MOV	DX,0			; Ú‘±ƒ`ƒFƒbƒN
	MOV	ES,DX			;
	MOV	CL,AL			; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
	MOV	DL,1			;
	SHL	DL,CL			; ƒrƒbƒg‚n‚m‚È‚ç‚ÎÚ‘±
	TEST	ES:[DISK_EQUIP],DL	; Ú‘±ƒ†ƒjƒbƒg
	JNZ	FDEQUIP_ON		;
FDEQUIP_OFF:
	MOV	AX,0			; 0=Ú‘±–³‚µ
	POP	DX
	POP	CX
	RET
FDEQUIP_ON:
	MOV	AX,1			; 1=Ú‘±‚³‚ê‚Ä‚¢‚é
	POP	DX
	POP	CX
	RET
FDEQUIP	ENDP


;	‚q‚`‚lƒhƒ‰ƒCƒuÚ‘±ƒ`ƒFƒbƒN
;	-I- AX          : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
;	-O- FLAG_RAM_DR : RAMƒhƒ‰ƒCƒuÚ‘± 1=Ú‘±‚³‚ê‚Ä‚¢‚é,0=Ú‘±–³‚µ

RAM_DR_EQUIP	PROC	NEAR
	MOV	DX,0			; Ú‘±ƒ`ƒFƒbƒN
	MOV	ES,DX			;
	MOV	CL,AL			; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
	MOV	DL,1			;
	SHL	DL,CL			; ƒrƒbƒg‚n‚m‚È‚ç‚ÎÚ‘±

	TEST	ES:[DISK_EQUIP],DL	; Ú‘±ƒ†ƒjƒbƒg
	JZ	RAM_DR_EQUIP_OFF	;
	TEST	ES:[RDISK_EQUIP],DL	; ‚q‚`‚lƒhƒ‰ƒCƒuÚ‘±ó‹µŽ¯•Êƒrƒbƒg
	JZ	RAM_DR_EQUIP_OFF	;
	JMP	RAM_DR_EQUIP_ON		;
RAM_DR_EQUIP_OFF:
	MOV	FLAG_RAM_DR,0		; 0=Ú‘±–³‚µ
	RET
RAM_DR_EQUIP_ON:
	MOV	FLAG_RAM_DR,1		; 1=Ú‘±‚³‚ê‚Ä‚¢‚é
	RET
RAM_DR_EQUIP	ENDP


;	ƒhƒ‰ƒCƒu”Ô†‚ÌÝ’èi‚O[‚Rj
;	-I- AX : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†

DRVSET	PROC	NEAR
	PUSH	AX
	AND	AL,011B
	AND	BYTE PTR DUNIT,11111100B
	OR	BYTE PTR DUNIT,AL
	POP	AX
	RET
DRVSET	ENDP



;	ƒhƒ‰ƒCƒu”Ô†‚ÌŽæ“¾
;	-O- AX : ‚P‚l‚e‚cƒhƒ‰ƒCƒu”Ô†

DRVNO	PROC	NEAR
	MOV	AX,DUNIT	; ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†iDA/UAj
	AND	AX,00000011B	; DA/UA=100100dd

	PRV	"DUNIT‚Ìƒhƒ‰ƒCƒu”Ô†=",AX
	RET
DRVNO	ENDP



;	ƒfƒBƒXƒN‘•’uŠÄŽ‹ƒ^ƒCƒ}

DRVTIMER	PROC	NEAR
	PUSH	AX
	PUSH	BX
WAIT_FDUNIT_TIMER	EQU	3	; ƒfƒBƒXƒNŠÄŽ‹—p‚u‚r‚x‚m‚b²ÝÀ°ÊÞÙÀ²Ï’l
	MOV	AX,WAIT_FDUNIT_TIMER	; wait timer count.
	CALL	TMVWT4			; V-SYNC timer4 wait.
	POP	BX
	POP	AX
	RET
DRVTIMER	ENDP


;	ƒnƒ“ƒhƒ‹—pƒpƒX–¼•ÒW
;	-I- DRVNUM        : Žw’èƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†i|‚P‚ÍƒJƒŒƒ“ƒgj
;	    DIRNAME       : ‘ÎÛƒtƒ@ƒCƒ‹–¼
;	-O- DIRHANDLEPATH : ƒnƒ“ƒhƒ‹—pƒpƒX–¼ "A:12345678.123",0

KFLHANDLE	PROC	NEAR
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET DIRHANDLEPATH	; ƒnƒ“ƒhƒ‹—pƒpƒX–¼

	CMP	DRVNUM,-1		; ƒhƒ‰ƒCƒu”Ô†i|‚P‚ÍƒJƒŒƒ“ƒgj
	JE	KFLHANDLE_NAME		;

KFLHANDLE_DRIVE:			;
	MOV	BX,DRVNUM		; Žw’èƒfƒBƒXƒN‚Ìƒhƒ‰ƒCƒu”Ô†
	MOV	AL,DS:DRIVENAME_TBL[BX]	; ƒhƒ‰ƒCƒu–¼ƒe[ƒuƒ‹ 0=A,1=B,2=C,3=D
	ADD	AL,DRIVENAME_SFT	; ƒhƒ‰ƒCƒu–¼‚Æ2HDƒ†ƒjƒbƒg”Ô†‚ÌƒYƒŒ
	STOSB				; ƒhƒ‰ƒCƒu–¼ "A","B","C","D"
	MOV	AL,':'			;
	STOSB				;

KFLHANDLE_NAME:				;
	MOV	SI,OFFSET DIRNAME	; ‘ÎÛƒtƒ@ƒCƒ‹–¼
	MOV	CX,8			;
KFLHANDLE_LOOP1:			;
	LODSB				; ‘ÎÛƒtƒ@ƒCƒ‹–¼
	CMP	AL,' '			; space.
	JBE	KFLHANDLE_NEXT1		;
	CMP	AL,'.'			; dot.
	JE	KFLHANDLE_DOT		;
	STOSB				; "A:12345678.123",0
KFLHANDLE_NEXT1:			;
	LOOP	KFLHANDLE_LOOP1		;

KFLHANDLE_DOT:				; D
	MOV	AL,'.'			; dot.
	STOSB				; "A:12345678.123",0

KFLHANDLE_ATTR:				; Šg’£Žq
	MOV	CX,3			;
KFLHANDLE_LOOP2:			;
	LODSB				; ‘ÎÛƒtƒ@ƒCƒ‹–¼
	CMP	AL,' '			; space.
	JBE	KFLHANDLE_EOS		;
	STOSB				; "A:12345678.123",0
KFLHANDLE_NEXT2:			;
	LOOP	KFLHANDLE_LOOP2		;

KFLHANDLE_EOS:				; ƒpƒX–¼‚ÌI‚è
	MOV	AL,0			; end of string.
	STOSB				; "A:12345678.123",0

	RET
KFLHANDLE	ENDP


;	Žw’èƒtƒ@ƒCƒ‹–¼‚ÌƒJƒ‰ƒ€‡‚í‚¹ ex. "TEST.ASM"->"TEST____ASM"
;	-I- DS:SI  : ƒtƒ@ƒCƒ‹–¼
;	-O- FLNAME : ƒtƒ@ƒCƒ‹–¼

KFLNSET	PROC	NEAR
	PUSH	SI

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DI,OFFSET FLNAME
	MOV	CX,FLNLEN+FLTLEN
	MOV	AL,' '
	REP	STOSB

	MOV	DI,OFFSET FLNAME
	MOV	CX,FLNLEN+FLTLEN
KFLNSET2:
	LODSB
	CMP	AL,'.'		; next type.
	JE	KFLNSET4	;
	CMP	AL,20H		; end of string.
	JB	KFLNSET9	;
	STOSB			;
	LOOP	KFLNSET2	;
	JMP	KFLNSET9	;

KFLNSET4:
	MOV	DI,OFFSET FLTYPE
	MOV	CX,FLTLEN
KFLNSET5:
	LODSB
	CMP	AL,'.'		; next type.
	JE	KFLNSET9	;
	CMP	AL,20H		; end of string.
	JB	KFLNSET9	;
	STOSB			;
	LOOP	KFLNSET5	;

KFLNSET9:
	POP	SI
	RET
KFLNSET	ENDP


MSGX1	EQU	20
MSGY1	EQU	8
MSGX2	EQU	59
MSGY2	EQU	13
CHR_CR	EQU	0DH
CHR_LF	EQU	0AH

ATR_MSGBOX	EQU	10100101B
ATR_WID_NO	EQU	00000001B
ATR_WID_OP	EQU	00000001B ;11000101B


;	ƒƒbƒZ[ƒWo—Í
;	-I- DS:SI : ƒƒbƒZ[ƒW•¶Žš—ñ

MSGPRN	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	BP
	PUSH	DI
	PUSH	SI
	PUSH	ES


	CMP	XWINDOW_FLAG,1		; 1=ŠO•”ƒEƒCƒ“ƒhƒE‚ðŽg‚¤
	JNE	MSGPRN1			;
	CALL	XWINDOW_START		; ŠO•”ƒEƒCƒ“ƒhƒE•\Ž¦
	JMP	MSGPRN9			;
MSGPRN1:				;


	CMP	MSGWIDFLG,0		; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn
	JNE	MSGPRN00		;

	CALL	CLS

	CALL	MSG_WINDOW_OPEN		; ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“

	MOV	VX1,MSGX1-2		; source point x1.
	MOV	VY1,MSGY1-1		; source point y1.
	MOV	VX2,MSGX2+2		; length x2.
	MOV	VY2,MSGY2+1		; length y2.
	MOV	DX,ATR_MSGBOX		;
	PUSH	SI			;
	CALL	TXTBOX			; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg
	POP	SI			;

	PUSH	SI			;
	MOV	AX,MSGX1		;
	MOV	BX,MSGY2-2		;
	CALL	LOCATE			; locate.
	MOV	SI,OFFSET MSG_SYSNAME1	; system name.
	CALL	PRINT			;
	MOV	AX,MSGX1		;
	MOV	BX,MSGY2-1		;
	CALL	LOCATE			; locate.
	MOV	SI,OFFSET MSG_SYSNAME2	; system name.
	CALL	PRINT			;
	MOV	AX,MSGX1		;
	MOV	BX,MSGY2		;
	CALL	LOCATE			; locate.
	MOV	SI,OFFSET MSG_SYSNAME3	; system name.
	CALL	PRINT			;
	POP	SI			;

MSGPRN00:
	MOV	AX,0			;
	MOV	BX,24			;
	CALL	LOCATE			; locate.
	MOV	AL,CHR_CR		;
	CALL	CHPUT			;
	MOV	AL,CHR_LF		; roll up.
	CALL	CHPUT			;

	MOV	AX,MSGX1		;
	MOV	BX,MSGY1-1		;
	CALL	LOCATE			; locate.
	MOV	CX,MSGX2-MSGX1+1	;
MSGPRN01:
	MOV	AL,' '			; space clear.
	CALL	CHPUT			;
	LOOP	MSGPRN01

	MOV	CHRPNT,MSGX1		; ƒLƒƒƒ‰ƒNƒ^ƒ|ƒCƒ“ƒ^
	MOV	AX,CHRPNT		;
	MOV	BX,MSGY2		;
	CALL	LOCATE			; locate.
MSGPRN2:
	CMP	CHRPNT,MSGX2		;
	JBE	MSGPRN5			;

	MOV	AX,0			;
	MOV	BX,24			;
	CALL	LOCATE			; locate.
	MOV	AL,CHR_CR		;
	CALL	CHPUT			;
	MOV	AL,CHR_LF		; roll up.
	CALL	CHPUT			;

	MOV	AX,MSGX1		;
	MOV	BX,MSGY1-1		;
	CALL	LOCATE			; locate.
	MOV	CX,MSGX2-MSGX1+1	;
MSGPRN02:
	MOV	AL,' '			; space clear.
	CALL	CHPUT			;
	LOOP	MSGPRN02		;

	MOV	CHRPNT,MSGX1		; ƒLƒƒƒ‰ƒNƒ^ƒ|ƒCƒ“ƒ^
	MOV	AX,CHRPNT		;
	MOV	BX,MSGY2		;
	CALL	LOCATE			; locate.
MSGPRN5:				;
	MOV	AL,DS:[SI]		;
	CALL	CHPUT			;

	INC	CHRPNT			;
	INC	SI			;
	CMP	BYTE PTR DS:[SI],0	; •¶Žš—ñI‚í‚è
	JE	MSGPRN9			;

	CALL	MSG_WINDOW_WAIT		;

	JMP	MSGPRN2			;

MSGPRN9:
	CMP	MSGWIDFLG,1		; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn
	JE	MSGPRN99		;
	CALL	MUSWAT			; ƒ}ƒEƒXƒ{ƒ^ƒ“‚n‚e‚e‘Ò‚¿
	CALL	MUSSHT			; ƒ}ƒEƒX“Ç‚Ýž‚ÝEƒƒ“ƒVƒ‡ƒbƒg
	MOV	MSGWIDFLG,1		; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn
MSGPRN99:

	POP	ES
	POP	SI
	POP	DI
	POP	BP
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
MSGPRN	ENDP



;	ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“

MSG_WINDOW_OPEN	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	ES

	MOV	FLAG_WINDOW_OPEN,1	; ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“ƒtƒ‰ƒO 1=OPEN

	CMP	XWINDOW_FLAG,1		; 1=ŠO•”ƒEƒCƒ“ƒhƒE‚ðŽg‚¤
	JNE	MSG_WINDOW_OPEN1	;
	CALL	XWINDOW_OPEN		; ŠO•”ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“
	JMP	MSG_WINDOW_OPEN_EXIT	; exit.
MSG_WINDOW_OPEN1:			;


	CALL	MSGIN		; ƒƒbƒZ[ƒW“Ë“üˆ—

	MOV	AH,35		; ‚wÀ•W‚‚‰‚Ž
	MOV	AL,10		; ‚xÀ•W‚‚‰‚Ž
	MOV	BH,44		; ‚wÀ•W‚‚‚˜
	MOV	BL,13		; ‚xÀ•W‚‚‚˜
	MOV	DX,ATR_WID_OP	; ƒeƒLƒXƒg‘®«
	MOV	CX,10
MSG_WINDOW_OPEN2:
	CALL	MSG_WINDOW_WAIT	;
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AL		; ‚xÀ•W‚‚‰‚Ž
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BL		; ‚xÀ•W‚‚‚˜
	MOV	DX,ATR_WID_NO	; ƒeƒLƒXƒg‘®«(BLACK)
	CALL	MSG_WINDOW_VW	; ƒEƒCƒ“ƒhƒEƒrƒ…[
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AL		; ‚xÀ•W‚‚‰‚Ž
	DEC	AL		; ‚xÀ•W‚‚‰‚Ž
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BL		; ‚xÀ•W‚‚‚˜
	INC	BL		; ‚xÀ•W‚‚‚˜
	MOV	DX,ATR_WID_OP	; ƒeƒLƒXƒg‘®«
	CALL	MSG_WINDOW_VW	; ƒEƒCƒ“ƒhƒEƒrƒ…[
	LOOP	MSG_WINDOW_OPEN2

	MOV	BYTE PTR WINDX1,AH	; ‚wÀ•W‚‚‰‚Ž
	MOV	BYTE PTR WINDY1,AL	; ‚xÀ•W‚‚‰‚Ž
	MOV	BYTE PTR WINDX2,BH	; ‚wÀ•W‚‚‚˜
	MOV	BYTE PTR WINDY2,BL	; ‚xÀ•W‚‚‚˜

;*DBG*;	PUSH	SI
;*DBG*;	MOV	AX,5			;
;*DBG*;	MOV	BX,22			;
;*DBG*;	INC	BX			;
;*DBG*;	CALL	LOCATE			; locate.
;*DBG*;	MOV	SI,OFFSET MSG_SYSNAME	; system name.
;*DBG*;	CALL	PRINT
;*DBG*;
;*DBG*;	EXTRN	DECSTR:NEAR
;*DBG*;	MOV	DX,WINDX1
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	MOV	DX,WINDY1
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	MOV	DX,WINDX2
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	MOV	DX,WINDY2
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	POP	SI

	MOV	BYTE PTR WINDX1,AH	; ‚wÀ•W‚‚‰‚Ž
	MOV	BYTE PTR WINDY1,AL	; ‚xÀ•W‚‚‰‚Ž
	MOV	BYTE PTR WINDX2,BH	; ‚wÀ•W‚‚‚˜
	MOV	BYTE PTR WINDY2,BL	; ‚xÀ•W‚‚‚˜

MSG_WINDOW_OPEN_EXIT:
	POP	ES
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
MSG_WINDOW_OPEN	ENDP



;	ƒEƒGƒCƒg

MSG_WINDOW_WAIT	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AX,TIME_WINDOW	; ƒEƒCƒ“ƒhƒEƒCƒ“ƒ^[ƒoƒ‹ŽžŠÔ
	CALL	TMVWT4		; V-SYNC timer4 wait.
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
MSG_WINDOW_WAIT	ENDP



;	ƒEƒCƒ“ƒhƒEƒrƒ…[
;	-I- AH : ‚wÀ•W‚‚‰‚Ž
;	    AL : ‚xÀ•W‚‚‰‚Ž
;	    BH : ‚wÀ•W‚‚‚˜
;	    BL : ‚xÀ•W‚‚‚˜
;	    DX : ƒeƒLƒXƒg‘®«
                             
MSG_WINDOW_VW	PROC	NEAR
	MOV	VX1,0
	MOV	VY1,0
	MOV	VX2,0
	MOV	VY2,0
	MOV	BYTE PTR VX1,AH		; ‚wÀ•W‚‚‰‚Ž
	MOV	BYTE PTR VY1,AL		; ‚xÀ•W‚‚‰‚Ž
	MOV	BYTE PTR VX2,BH		; ‚wÀ•W‚‚‚˜
	MOV	BYTE PTR VY2,AL		; ‚xÀ•W‚‚‰‚Ž
	CALL	TXTBOX			; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg
	MOV	BYTE PTR VX1,BH		; ‚wÀ•W‚‚‚˜
	MOV	BYTE PTR VY1,AL		; ‚xÀ•W‚‚‰‚Ž
	MOV	BYTE PTR VX2,BH		; ‚wÀ•W‚‚‚˜
	INC	BYTE PTR VX2
	INC	BYTE PTR VX2
	MOV	BYTE PTR VY2,BL		; ‚xÀ•W‚‚‚˜
	CALL	TXTBOX			; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg
	MOV	BYTE PTR VX1,AH		; ‚wÀ•W‚‚‰‚Ž
	MOV	BYTE PTR VY1,BL		; ‚xÀ•W‚‚‚˜
	MOV	BYTE PTR VX2,BH		; ‚wÀ•W‚‚‚˜
	MOV	BYTE PTR VY2,BL		; ‚xÀ•W‚‚‚˜
	CALL	TXTBOX			; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg
	MOV	BYTE PTR VX1,AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	BYTE PTR VX1
	DEC	BYTE PTR VX1
	MOV	BYTE PTR VY1,AL		; ‚xÀ•W‚‚‰‚Ž
	MOV	BYTE PTR VX2,AH		; ‚wÀ•W‚‚‰‚Ž
	MOV	BYTE PTR VY2,BL		; ‚xÀ•W‚‚‚˜
	CALL	TXTBOX			; ƒeƒLƒXƒg‘®«‚a‚n‚wƒZƒbƒg
	RET
MSG_WINDOW_VW	ENDP



;	ƒEƒCƒ“ƒhƒEƒNƒ[ƒY

MSG_WINDOW_CLOSE	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	ES

	MOV	FLAG_WINDOW_OPEN,0	; ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“ƒtƒ‰ƒO 1=OPEN

	CMP	XWINDOW_FLAG,1		; 1=ŠO•”ƒEƒCƒ“ƒhƒE‚ðŽg‚¤
	JNE	MSG_WINDOW_CLOSE1	;
	CALL	XWINDOW_CLOSE		; ŠO•”ƒEƒCƒ“ƒhƒEƒNƒ[ƒY
	JMP	MSG_WINDOW_CLOSE_EXIT	;
MSG_WINDOW_CLOSE1:			;

	MOV	AH,BYTE PTR WINDX1	; ‚wÀ•W‚‚‰‚Ž
	INC	AH
	MOV	AL,BYTE PTR WINDY1	; ‚xÀ•W‚‚‰‚Ž
	INC	AL
	MOV	BH,BYTE PTR WINDX2	; ‚wÀ•W‚‚‚˜
	DEC	BH
	MOV	BL,BYTE PTR WINDY2	; ‚xÀ•W‚‚‚˜
	DEC	BL
	MOV	DX,ATR_WID_OP	; ƒeƒLƒXƒg‘®«
	MOV	CX,10
MSG_WINDOW_CLOSE2:
	CALL	MSG_WINDOW_WAIT	;
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AH		; ‚wÀ•W‚‚‰‚Ž
	DEC	AL		; ‚xÀ•W‚‚‰‚Ž
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BH		; ‚wÀ•W‚‚‚˜
	INC	BL		; ‚xÀ•W‚‚‚˜
	MOV	DX,ATR_WID_NO	; ƒeƒLƒXƒg‘®«(BLACK)
	CALL	MSG_WINDOW_VW	; ƒEƒCƒ“ƒhƒEƒrƒ…[
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AH		; ‚wÀ•W‚‚‰‚Ž
	INC	AL		; ‚xÀ•W‚‚‰‚Ž
	INC	AL		; ‚xÀ•W‚‚‰‚Ž
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BH		; ‚wÀ•W‚‚‚˜
	DEC	BL		; ‚xÀ•W‚‚‚˜
	DEC	BL		; ‚xÀ•W‚‚‚˜
	MOV	DX,ATR_WID_OP	; ƒeƒLƒXƒg‘®«
	CALL	MSG_WINDOW_VW	; ƒEƒCƒ“ƒhƒEƒrƒ…[
	LOOP	MSG_WINDOW_CLOSE2

	CALL	CLS
	CALL	MSGOUT		; ƒƒbƒZ[ƒWŒãˆ—

MSG_WINDOW_CLOSE_EXIT:
	POP	ES
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
MSG_WINDOW_CLOSE	ENDP



;	ƒƒbƒZ[ƒWƒXƒ^[ƒg

MSG_START	PROC	NEAR
	MOV	MSGWIDFLG,0		; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn
	CALL	USER_STANBY_SETUP	; ƒ†[ƒUAƒXƒ^ƒ“ƒoƒCƒZƒbƒgƒAƒbƒv
	RET
MSG_START	ENDP



;	ƒƒbƒZ[ƒWƒXƒgƒbƒv

MSG_STOP	PROC	NEAR
	CMP	MSGWIDFLG,0		; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn
	JE	MSG_STOP9
	CALL	MSG_WINDOW_CLOSE	; ƒEƒCƒ“ƒhƒEƒNƒ[ƒY
	MOV	MSGWIDFLG,0		; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn
MSG_STOP9:
	RET
MSG_STOP	ENDP



;	Œ©‚Â‚©‚ç‚È‚¢ƒƒbƒZ[ƒW

DKCMSG	PROC	NEAR
	CMP	FLAG_ERR_OUT,1		; 0=ƒGƒ‰[•\Ž¦—}§,1=ƒGƒ‰[•\Ž¦
	JE	DKCMSG0			;
	RET
DKCMSG0:
	PUSH	SI
	PRINTM	"ƒtƒ@ƒCƒ‹‚ªŒ©‚Â‚©‚è‚Ü‚¹‚ñ"
	MOV	SI,FILE_NAME_ADRS	; ƒtƒ@ƒCƒ‹–¼
	PRINTSI

	MOV	AX,TIME_DKCMSG		; ƒƒbƒZ[ƒWŽžŠÔ
	CALL	TMVWT4			; V-SYNC timer4 wait.

	POP	SI
	RET
DKCMSG	ENDP


;	ƒƒbƒZ[ƒW“Ë“üƒ‚[ƒh
;	-I- DX : 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“

DKCMMD	PROC	NEAR
;*;	MOV	MODEMSG,DX	; 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“

	MOV	MODEMSG,0	; 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“

	MOV	AX,DX		; 1=ŠO•”ƒEƒCƒ“ƒhƒE‚ðŽg‚¤,
				; 0=“à•”‚ÌƒEƒCƒ“ƒhƒE‚ðŽg‚¤
	CALL	DKCWID		; •\Ž¦‚·‚éƒEƒCƒ“ƒhƒE‚Ì‘I‘ð

	RET
DKCMMD	ENDP



;	ƒƒbƒZ[ƒW“Ë“üˆ—
;	-I- MODEMSG : 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“

MSGIN	PROC	NEAR
	CMP	MODEMSG,1	; 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“
	JE	MSGIN1		;
	RET
MSGIN1:
	CALL	BRIOUT		; –¾“x‚T‚O“ƒ_ƒEƒ“
	RET
MSGIN	ENDP



;	ƒƒbƒZ[ƒWŒãˆ—
;	-I- MODEMSG : 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“

MSGOUT	PROC	NEAR
	CMP	MODEMSG,1	; 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“
	JE	MSGOUT1		;
	RET
MSGOUT1:
	CALL	BRIIN		; –¾“x‚T‚O“‚©‚çƒm[ƒ}ƒ‹‚Ö
	RET
MSGOUT	ENDP


;	•\Ž¦‚·‚éƒEƒCƒ“ƒhƒE‚Ì‘I‘ð
;	-I- AX : 1=ŠO•”ƒEƒCƒ“ƒhƒE‚ðŽg‚¤,0=“à•”‚ÌƒEƒCƒ“ƒhƒE‚ðŽg‚¤

DKCWID	PROC	NEAR
	MOV	XWINDOW_FLAG,AX		; 1=ŠO•”ƒEƒCƒ“ƒhƒE‚ðŽg‚¤
	RET
DKCWID	ENDP



;	ŠO•”ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“

XWINDOW_OPEN	PROC	NEAR
	MOV	BX,1			; 1=ƒEƒCƒ“ƒhƒEEƒI[ƒvƒ“
	CALL	WIDDISK			; WINDOWS/ƒfƒBƒXƒNƒEƒCƒ“ƒhƒE
;*;	CALL	WIDMES			; ƒƒbƒZ[ƒWEƒEƒCƒ“ƒhƒE

	MOV	XWINDOW_LINE,0		; ŠO•”ƒEƒCƒ“ƒhƒEŽg—ps

	RET
XWINDOW_OPEN	ENDP


;	ŠO•”ƒEƒCƒ“ƒhƒEƒNƒ[ƒY

XWINDOW_CLOSE	PROC	NEAR
	MOV	BX,2			; 2=ƒEƒCƒ“ƒhƒEEƒNƒ[ƒY
	CALL	WIDDISK			; WINDOWS/ƒfƒBƒXƒNƒEƒCƒ“ƒhƒE
;*;	CALL	WIDMES			; ƒƒbƒZ[ƒWEƒEƒCƒ“ƒhƒE
	RET
XWINDOW_CLOSE	ENDP


;	ŠO•”ƒEƒCƒ“ƒhƒE•\Ž¦
;	-I- SI : •¶Žš—ñ

XWINDOW_START	PROC	NEAR
	CMP	MSGWIDFLG,0		; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn
	JNE	XWINDOW_START001	;
	PUSH	SI			;
	CALL	MSG_WINDOW_OPEN		; ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“
	POP	SI			;
XWINDOW_START001:			;
	CMP	XWINDOW_LINE,1		; ŠO•”ƒEƒCƒ“ƒhƒEŽg—ps
	JE	XWINDOW_START1		;
	MOV	BX,3			; 3=ƒEƒCƒ“ƒhƒEEƒƒbƒZ[ƒW^ã’i
	MOV	XWINDOW_LINE,1		; ŠO•”ƒEƒCƒ“ƒhƒEŽg—ps
	JMP	XWINDOW_START2		;
XWINDOW_START1:				;
	MOV	BX,4			; 4=ƒEƒCƒ“ƒhƒEEƒƒbƒZ[ƒW^’†’i
	MOV	XWINDOW_LINE,0		; ŠO•”ƒEƒCƒ“ƒhƒEŽg—ps
XWINDOW_START2:				;
	PUSH	SI			;
	CALL	WIDDISK			; WINDOWS/ƒfƒBƒXƒNƒEƒCƒ“ƒhƒE
;*;	CALL	WIDMES			; ƒƒbƒZ[ƒWEƒEƒCƒ“ƒhƒE
	POP	SI			;
	RET
XWINDOW_START	ENDP


;	ƒ†[ƒUAƒXƒ^ƒ“ƒoƒCƒZƒbƒgƒAƒbƒv

USER_STANBY_SETUP	PROC	NEAR
	MOV	USER_ST_COUNT,0		; ƒ†[ƒUƒXƒ^ƒ“ƒoƒCƒJƒEƒ“ƒ^
	RET
USER_STANBY_SETUP	ENDP


;	ƒ†[ƒU‚©‚ç’¼ÚAƒXƒ^ƒ“ƒoƒC‚ªo‚½
;	-O- BX : 1=ƒXƒ^ƒ“ƒoƒC,0=’Êí

USER_STANBY	PROC	NEAR
	CMP	FLAG_WINDOW_OPEN,1	; ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“ƒtƒ‰ƒO 1=OPEN
	JE	USER_STANBY_START	;
	MOV	BX,0			; 0=’Êí
	RET
USER_STANBY_START:
	PUSH	AX
	PUSH	CX
	PUSH	DX
	PUSH	BP
	PUSH	SI
	PUSH	DI
	PUSH	ES

	CMP	USER_ST_COUNT,0		; ƒ†[ƒUƒXƒ^ƒ“ƒoƒCƒJƒEƒ“ƒ^
	JNE	USER_STANBY_9		;


	CALL	MUSSHT			; ƒ}ƒEƒX“Ç‚Ýž‚ÝEƒƒ“ƒVƒ‡ƒbƒg
	CMP	DH,0			; ¶ƒ{ƒ^ƒ“i1F‚n‚e‚e^0F‚n‚mj
	JE	USER_STANBY_8		;
	CMP	DL,0			; ‰Eƒ{ƒ^ƒ“i1F‚n‚e‚e^0F‚n‚mj
	JE	USER_STANBY_8		;

USER_STANBY_7:				;
	MOV	BX,0			; 0=’Êí
	JMP	USER_STANBY_EXIT	;
USER_STANBY_8:				;
	MOV	AX,DRVNUMMAX		; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”
	DEC	AX			;
	MOV	USER_ST_COUNT,AX	; ƒ†[ƒUƒXƒ^ƒ“ƒoƒCƒJƒEƒ“ƒ^
	MOV	BX,1			; 1=ƒXƒ^ƒ“ƒoƒC
	JMP	USER_STANBY_EXIT	;
USER_STANBY_9:				;
	DEC	USER_ST_COUNT		; ƒ†[ƒUƒXƒ^ƒ“ƒoƒCƒJƒEƒ“ƒ^
	MOV	BX,1			; 1=ƒXƒ^ƒ“ƒoƒC
USER_STANBY_EXIT:
	POP	ES
	POP	DI
	POP	SI
	POP	BP
	POP	DX
	POP	CX
	POP	AX
	RET
USER_STANBY	ENDP


;*;;	ƒfƒBƒXƒNƒXƒe[ƒ^ƒX
;*;
;*;DUMP_DISK	PROC	NEAR
;*;	MOV	AX,0		;
;*;	MOV	ES,AX		;
;*;	LC	0,2
;*;	PRVV	"UNIT#0:",<ES:[564H]>
;*;	PRVV	"UNIT#1:",<ES:[564H+8]>
;*;	PRVV	"UNIT#2:",<ES:[564H+8*2]>
;*;	PRVV	"UNIT#3:",<ES:[564H+8*3]>
;*;
;*;	RET
;*;DUMP_DISK	ENDP


CODE	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	DRIVENAME_SFT		; ƒhƒ‰ƒCƒu–¼‚Æ2HDƒ†ƒjƒbƒg”Ô†‚ÌƒYƒŒ

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

;	ƒZƒNƒ^ƒoƒbƒtƒ@i‚c‚l‚`ƒoƒbƒtƒ@j
;	‚c‚l‚`ƒoƒEƒ“ƒ_ƒŠƒGƒ‰[‚ð”ð‚¯‚éˆ×ASCDATA2 ‚ð CMDTBL.ASM ‚ÖˆÚ“®‚µ‚½B
	EVEN
PUBLIC	SCDATA					; ƒZƒNƒ^ƒoƒbƒtƒ@
EXTRN	SCDATA2:BYTE				; ƒZƒNƒ^ƒoƒbƒtƒ@
SCADRS	DW	OFFSET SCDATA			; ƒZƒNƒ^ƒoƒbƒtƒ@ƒAƒhƒŒƒX
SCDATA		DB	SEC_BYTE DUP (0)	; ƒZƒNƒ^ƒoƒbƒtƒ@
;SCDATA2	DB	SEC_BYTE DUP (0)	; ƒZƒNƒ^ƒoƒbƒtƒ@
	DB	0,0

	EVEN
; ‚a‚h‚n‚rƒRƒ}ƒ“ƒhŽ¯•ÊƒR[ƒh
;		MM-S....
;		TFrK0110
DREAD	DW	11110110B	; ‚q‚d‚`‚c@‚c‚`‚s‚`
;*N*;DRECAL	DW	00100111B	; ‚q‚d‚b‚`‚k‚h‚a‚q‚`‚s‚d
DRECAL	DW	00000111B	; ‚q‚d‚b‚`‚k‚h‚a‚q‚`‚s‚d
DWRITE	DW	01010101B	; ‚v‚q‚h‚s‚d‚c‚`‚s‚`

DSENSE	DW	04H		; ‚r‚d‚m‚r‚d
DSEEK	DW	10H		; ‚r‚d‚d‚j

DSENSE_NEW DW	84H		; ‚r‚d‚m‚r‚di‚b‚n‚l‚l‚`‚m‚c^‚r‚s‚`‚s‚t‚rj

;		100100dd
DUNIT	DW	10010001B	; ƒfƒoƒCƒXŽ¯•ÊEƒ†ƒjƒbƒg”Ô†iDA/UAj

;	‚h‚c‚qi‚h‚cî•ñj
DLEN	DW	SEC_BYTE	; ƒf[ƒ^’·i‚c‚s‚kjiƒoƒCƒg’PˆÊj
DCYL	DW	0		; ƒVƒŠƒ“ƒ_”Ô†i‚bj‚O[‚V‚U
DHEAD	DW	0		; ƒwƒbƒh”Ô†i‚gj‚O[‚P
DSECR	DW	1		; ƒZƒNƒ^”Ô†i‚qj‚P[‚Wi‚Q‚Uj
DSECN	DW	03		; ƒZƒNƒ^’·i‚mj
				; 00/128, 01/256, 02/512, 03/1024
DSTAT	DW	0		; ƒXƒe[ƒ^ƒXî•ñ
DERROR	DW	0		; 0=³í,1=ƒGƒ‰[


DISK_DOOR_INI	DB	0FFH,0FFH,0FFH,0FFH	; ƒfƒBƒXƒNŠJ•Â‰ŠúÌ×¸Þ

	EVEN
READ_RETRY	DW	0	; ƒŠ[ƒhEƒŠƒgƒ‰ƒCƒJƒEƒ“ƒ^
WRITE_RETRY	DW	0	; ƒZƒNƒ^‘‚«ž‚ÝEƒŠƒgƒ‰ƒCƒJƒEƒ“ƒ^

BUFF_SEG	DW	0	; ƒoƒbƒtƒ@ƒZƒOƒƒ“ƒg
BUFF_OFFSET	DW	0	; ƒoƒbƒtƒ@ƒIƒtƒZƒbƒg


DSKID_ADRS	LABEL	WORD		; ƒfƒBƒXƒN‚h‚cƒAƒhƒŒƒXƒe[ƒuƒ‹
	DW	OFFSET DSKID0		;
	DW	OFFSET DSKID1		;
	DW	OFFSET DSKID2		;
	DW	OFFSET DSKID3		;
DSKID0	DB	ID_LEN DUP (0)		; ƒhƒ‰ƒCƒu‚O‚Ì‚h‚cƒe[ƒuƒ‹
DSKID1	DB	ID_LEN DUP (0)		; ƒhƒ‰ƒCƒu‚P‚Ì‚h‚cƒe[ƒuƒ‹
DSKID2	DB	ID_LEN DUP (0)		; ƒhƒ‰ƒCƒu‚Q‚Ì‚h‚cƒe[ƒuƒ‹
DSKID3	DB	ID_LEN DUP (0)		; ƒhƒ‰ƒCƒu‚R‚Ì‚h‚cƒe[ƒuƒ‹

	EVEN
ID_DISKSYSNAME	DW	0		; ƒVƒXƒeƒ€‚h‚c
ID_DISKPROG	DW	0		; ƒvƒƒOƒ‰ƒ€‚h‚c
ID_DISKNUMBER	DW	0		; ƒfƒBƒXƒN”Ô†

DRIVENAME_TBL	DB	"ABCDEFGHIJ"	; ƒhƒ‰ƒCƒu–¼ƒe[ƒuƒ‹ 0=A,1=B,2=C,3=D
DRIVENAME_SFT	DB	0,0		; ƒhƒ‰ƒCƒu–¼‚Æ2HDƒ†ƒjƒbƒg”Ô†‚ÌƒYƒŒ

DRVNUMMAX	DW	DRVNUMMAX_FIX	; ‚P‚l‚e‚cƒhƒ‰ƒCƒu”
DRVNUM		DW	0		; ƒhƒ‰ƒCƒu”Ô†i‚O[‚Rj
DRVNUMSYS	DW	0		; ƒVƒXƒeƒ€ƒhƒ‰ƒCƒu”Ô†

SCH_DISKID	DW	0		; ŒŸõƒfƒBƒXƒN‚h‚c

FLNAME		DB	"        "	; ƒtƒ@ƒCƒ‹–¼
FLTYPE		DB	"   ",0		; Šg’£Žq

		EVEN
DIRDISK		DW	0		; ‘ÎÛƒfƒBƒXƒN”Ô†

DIRNAME		DB	"           ",0	; ‘ÎÛƒtƒ@ƒCƒ‹–¼

DIRHANDLEPATH	DB	14 DUP (0),0,0	; ƒnƒ“ƒhƒ‹—pƒpƒX–¼ "A:12345678.123",0

SYSDIRPATH	LABEL	BYTE		; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹EƒpƒX–¼
SYSDIRDRIVE	DB	"A:"		; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹Eƒhƒ‰ƒCƒu–¼
SYSDIRNAM	DB	"SYSTEM.DIR",0	; ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹–¼

DOSCALLX_DUMMY	DB	"A:XXXXYYYY.AAA",0 ; ‚c‚n‚rƒAƒNƒZƒX—pƒ_ƒ~[

					; ID length=8
DOSXSTOP	DB	"$dosxstop",0	; •W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
ERRORDSP	DB	"$errordsp",0	; ƒGƒ‰[•\Ž¦‚n‚m
UNIT0		DB	"$unit0=",0	; ƒ†ƒjƒbƒg”‚O‚Íƒhƒ‰ƒCƒu‰½"$unit0="


;	ƒfƒBƒŒƒNƒgƒŠƒBƒtƒ@ƒCƒ‹‚ðƒIƒ“ƒƒ‚ƒŠ[‚ÉŽ‚Â‚±‚Æ‚É‚·‚é

DIRTABLE	LABEL	WORD		; ƒfƒBƒŒƒNƒgƒŠƒBƒe[ƒuƒ‹
;*;	DB	DIRTABLE_MAX*DIRTABLE_NM_LEN DUP (0)
DB	"-------------",0DH,0AH
DB	"system by r.h",0DH,0AH
DB	" (C)1991.02  ",0DH,0AH
DB	"dirctory file",0DH,0AH
DB	"==$dosxstop  ",0DH,0AH
DB	"$errordsp    ",0DH,0AH
DB	"$unit0=A:    ",0DH,0AH
DB	"-disk1-------",0DH,0AH
DB	"< file ><a>RD",0DH,0AH
DB	"BTN     PT11 ",0DH,0AH
DB	"BTNWK   PT11 ",0DH,0AH
DB	"BTNSCD  PT11 ",0DH,0AH
DB	"BTNSCW  PT11 ",0DH,0AH
DB	"CLEND   PT11 ",0DH,0AH
DB	"FREAMB1 PT11 ",0DH,0AH
DB	"FREAMB2 PT11 ",0DH,0AH
DB	"FREAMB3 PT11 ",0DH,0AH
DB	"FREAMM1 PT11 ",0DH,0AH
DB	"FREAMM2 PT11 ",0DH,0AH
DB	"FREAMM3 PT11 ",0DH,0AH
DB	"FREAMD  PT11 ",0DH,0AH
DB	"FREAMU1 PT11 ",0DH,0AH
DB	"FREAMU2 PT11 ",0DH,0AH
DB	"GRAPH   PT11 ",0DH,0AH
DB	"VALUE   PT11 ",0DH,0AH
DB	"KAZARI  PT11 ",0DH,0AH
DB	"PALET   PT11 ",0DH,0AH
DB	"PAT6    PT11 ",0DH,0AH
DB	"PAT7    PT11 ",0DH,0AH
DB	"PAT7WK  PT11 ",0DH,0AH
DB	"PAT8    PT11 ",0DH,0AH
DB	"BLOOD   PT11 ",0DH,0AH
DB	"MONTH   PT11 ",0DH,0AH
DB	"WEEK    PT11 ",0DH,0AH
DB	"BIGNUM  PT11 ",0DH,0AH
DB	"PROPR   PT11 ",0DH,0AH
DB	"PROP2   PT11 ",0DH,0AH
DB	"I1_01   PT11 ",0DH,0AH
DB	"I1_02   PT11 ",0DH,0AH
DB	"I1_03   PT11 ",0DH,0AH
DB	"I1_04   PT11 ",0DH,0AH
DB	"I1_05   PT11 ",0DH,0AH
DB	"I1_06   PT11 ",0DH,0AH
DB	"I1_07   PT11 ",0DH,0AH
DB	"I1_08   PT11 ",0DH,0AH
DB	"I1_09   PT11 ",0DH,0AH
DB	"I1_10   PT11 ",0DH,0AH
DB	"I1_11   PT11 ",0DH,0AH
DB	"I1_12   PT11 ",0DH,0AH
DB	"I2_01   PT11 ",0DH,0AH
DB	"I2_02   PT11 ",0DH,0AH
DB	"I2_03   PT11 ",0DH,0AH
DB	"I3_01   PT11 ",0DH,0AH
DB	"I4_01   PT11 ",0DH,0AH
DB	"I4_02   PT11 ",0DH,0AH
DB	"I4_05   PT11 ",0DH,0AH
DB	"PM1     M  1 ",0DH,0AH
DB	"PM2     M  1 ",0DH,0AH
DB	"PM3     M  1 ",0DH,0AH
DB	"PM4     M  1 ",0DH,0AH
DB	"PM5     M  1 ",0DH,0AH
DB	"PM6     M  1 ",0DH,0AH
DB	"PM7     M  1 ",0DH,0AH
DB	"PM8     M  1 ",0DH,0AH
DB	"PM9     M  1 ",0DH,0AH
DB	"PM10    M  1 ",0DH,0AH
DB	"PM11    M  1 ",0DH,0AH
DB	"PM12    M  1 ",0DH,0AH
DB	"PM13    M  1 ",0DH,0AH
DB	"PM14    M  1 ",0DH,0AH
DB	"PM15    M  1 ",0DH,0AH
DB	"E2_01   PT11 ",0DH,0AH
DB	"E2_02   PT11 ",0DH,0AH
DB	"E2_03   PT11 ",0DH,0AH
DB	"E2_04   PT11 ",0DH,0AH
DB	"E2_05   PT11 ",0DH,0AH
DB	"E2_06   PT11 ",0DH,0AH
DB	"E2_07   PT11 ",0DH,0AH
DB	"E2_08   PT11 ",0DH,0AH
DB	"E2_09   PT11 ",0DH,0AH
DB	"E2_10   PT11 ",0DH,0AH
DB	"E3_01   PT11 ",0DH,0AH
DB	"E3_02   PT11 ",0DH,0AH
DB	"E3_03   PT11 ",0DH,0AH
DB	"F1_01   PT11 ",0DH,0AH
DB	"F1_02   PT11 ",0DH,0AH
DB	"F1_03   PT11 ",0DH,0AH
DB	"F1_04   PT11 ",0DH,0AH
DB	"F1_05   PT11 ",0DH,0AH
DB	"F1_06   PT11 ",0DH,0AH
DB	"F2_01   PT11 ",0DH,0AH
DB	"F2_02   PT11 ",0DH,0AH
DB	"F2_03   PT11 ",0DH,0AH
DB	"F2_04   PT11 ",0DH,0AH
DB	"F2_05   PT11 ",0DH,0AH
DB	"F3_01   PT11 ",0DH,0AH
DB	"F3_02   PT11 ",0DH,0AH
DB	"F3_03   PT11 ",0DH,0AH
DB	"F3_04   PT11 ",0DH,0AH
DB	"F3_05   PT11 ",0DH,0AH
DB	"F3_06   PT11 ",0DH,0AH
DB	"F3_07   PT11 ",0DH,0AH
DB	"F3_08   PT11 ",0DH,0AH
DB	"F3_09   PT11 ",0DH,0AH
DB	"F3_10   PT11 ",0DH,0AH
DB	"F3_11   PT11 ",0DH,0AH
DB	"F3_12   PT11 ",0DH,0AH
DB	"F4_01   PT11 ",0DH,0AH
DB	"F4_02   PT11 ",0DH,0AH
DB	"F4_03   PT11 ",0DH,0AH
DB	"F4_04   PT11 ",0DH,0AH
DB	"F5_01   PT11 ",0DH,0AH
DB	"F5_02   PT11 ",0DH,0AH
DB	"F5_03   PT11 ",0DH,0AH
DB	"F5_04   PT11 ",0DH,0AH
DB	"MBG6L   PT11 ",0DH,0AH
DB	"MBG6R   PT11 ",0DH,0AH
DB	"FDTOOL  COM1 ",0DH,0AH
DB	"MUSYA   COM1 ",0DH,0AH
DB	"-disk2-------",0DH,0AH
DB	"WOPENBORPT12 ",0DH,0AH
DB	"XOPENBORPT12 ",0DH,0AH
DB	"WOPENCUTPT12 ",0DH,0AH
DB	"XOPENCUTPT12 ",0DH,0AH
DB	"WOPENNAMPT12 ",0DH,0AH
DB	"XOPENNAMPT12 ",0DH,0AH
DB	"C1      PT12 ",0DH,0AH
DB	"C2      PT12 ",0DH,0AH
DB	"C3      PT12 ",0DH,0AH
DB	"C4      PT12 ",0DH,0AH
DB	"C5A1    PT12 ",0DH,0AH
DB	"C5A2    PT12 ",0DH,0AH
DB	"MBG1L   PT12 ",0DH,0AH
DB	"MBG1R   PT12 ",0DH,0AH
DB	"CB1     PT12 ",0DH,0AH
DB	"CB1D1   PT12 ",0DH,0AH
DB	"CB1D2   PT12 ",0DH,0AH
DB	"CB1D3   PT12 ",0DH,0AH
DB	"CB1D4   PT12 ",0DH,0AH
DB	"CB1F1   PT12 ",0DH,0AH
DB	"CB1F2   PT12 ",0DH,0AH
DB	"CB1F3   PT12 ",0DH,0AH
DB	"CB2     PT12 ",0DH,0AH
DB	"CB2D1   PT12 ",0DH,0AH
DB	"CB2D2   PT12 ",0DH,0AH
DB	"CB2D3   PT12 ",0DH,0AH
DB	"CB2D4   PT12 ",0DH,0AH
DB	"CB2F1   PT12 ",0DH,0AH
DB	"CB2F2   PT12 ",0DH,0AH
DB	"CB2F3   PT12 ",0DH,0AH
DB	"XC1-01  PT12 ",0DH,0AH
DB	"WC1-01  PT12 ",0DH,0AH
DB	"XC1-02  PT12 ",0DH,0AH
DB	"WC1-02  PT12 ",0DH,0AH
DB	"XC1-03  PT12 ",0DH,0AH
DB	"WC1-03  PT12 ",0DH,0AH
DB	"XC1-04  PT12 ",0DH,0AH
DB	"WC1-04  PT12 ",0DH,0AH
DB	"WINDOW1 COM2 ",0DH,0AH
DB	"NAMEFILEEMS2 ",0DH,0AH
DB	"-disk3-------",0DH,0AH
DB	"MBG1L_2 PT13 ",0DH,0AH
DB	"MBG1R_2 PT13 ",0DH,0AH
DB	"CB3     PT13 ",0DH,0AH
DB	"CB3D1   PT13 ",0DH,0AH
DB	"CB3D2   PT13 ",0DH,0AH
DB	"CB3D3   PT13 ",0DH,0AH
DB	"CB3D4   PT13 ",0DH,0AH
DB	"CB3F1   PT13 ",0DH,0AH
DB	"CB3F2   PT13 ",0DH,0AH
DB	"CB3F3   PT13 ",0DH,0AH
DB	"CB4     PT13 ",0DH,0AH
DB	"CB4D1   PT13 ",0DH,0AH
DB	"CB4D2   PT13 ",0DH,0AH
DB	"CB4D3   PT13 ",0DH,0AH
DB	"CB4D4   PT13 ",0DH,0AH
DB	"CB4F1   PT13 ",0DH,0AH
DB	"CB4F2   PT13 ",0DH,0AH
DB	"CB4F3   PT13 ",0DH,0AH
DB	"XC2-01  PT13 ",0DH,0AH
DB	"WC2-01  PT13 ",0DH,0AH
DB	"XC2-02  PT13 ",0DH,0AH
DB	"WC2-02  PT13 ",0DH,0AH
DB	"XC2-03  PT13 ",0DH,0AH
DB	"WC2-03  PT13 ",0DH,0AH
DB	"XC2-04  PT13 ",0DH,0AH
DB	"WC2-04  PT13 ",0DH,0AH
DB	"L1_07   PT13 ",0DH,0AH
DB	"L1_08   PT13 ",0DH,0AH
DB	"L1_09   PT13 ",0DH,0AH
DB	"L1_10   PT13 ",0DH,0AH
DB	"L1_11   PT13 ",0DH,0AH
DB	"L1_12   PT13 ",0DH,0AH
DB	"L2_07   PT13 ",0DH,0AH
DB	"L2_08   PT13 ",0DH,0AH
DB	"L2_09   PT13 ",0DH,0AH
DB	"L2_10   PT13 ",0DH,0AH
DB	"L2_11   PT13 ",0DH,0AH
DB	"L2_12   PT13 ",0DH,0AH
DB	"L3_07   PT13 ",0DH,0AH
DB	"L3_08   PT13 ",0DH,0AH
DB	"L3_09   PT13 ",0DH,0AH
DB	"L3_10   PT13 ",0DH,0AH
DB	"L3_11   PT13 ",0DH,0AH
DB	"L3_12   PT13 ",0DH,0AH
DB	"-disk4-------",0DH,0AH
DB	"MBG1L_3 PT14 ",0DH,0AH
DB	"MBG1R_3 PT14 ",0DH,0AH
DB	"CB5     PT14 ",0DH,0AH
DB	"CB5D1   PT14 ",0DH,0AH
DB	"CB5D2   PT14 ",0DH,0AH
DB	"CB5D3   PT14 ",0DH,0AH
DB	"CB5D4   PT14 ",0DH,0AH
DB	"CB5F1   PT14 ",0DH,0AH
DB	"CB5F2   PT14 ",0DH,0AH
DB	"CB5F3   PT14 ",0DH,0AH
DB	"CB6     PT14 ",0DH,0AH
DB	"CB6D1   PT14 ",0DH,0AH
DB	"CB6D2   PT14 ",0DH,0AH
DB	"CB6D3   PT14 ",0DH,0AH
DB	"CB6D4   PT14 ",0DH,0AH
DB	"CB6F1   PT14 ",0DH,0AH
DB	"CB6F2   PT14 ",0DH,0AH
DB	"CB6F3   PT14 ",0DH,0AH
DB	"XC3-01  PT14 ",0DH,0AH
DB	"WC3-01  PT14 ",0DH,0AH
DB	"XC3-02  PT14 ",0DH,0AH
DB	"WC3-02  PT14 ",0DH,0AH
DB	"XC3-03  PT14 ",0DH,0AH
DB	"WC3-03  PT14 ",0DH,0AH
DB	"XC3-04  PT14 ",0DH,0AH
DB	"WC3-04  PT14 ",0DH,0AH
DB	"L1_25   PT14 ",0DH,0AH
DB	"L1_26   PT14 ",0DH,0AH
DB	"L1_27   PT14 ",0DH,0AH
DB	"L1_28   PT14 ",0DH,0AH
DB	"L1_29   PT14 ",0DH,0AH
DB	"L1_30   PT14 ",0DH,0AH
DB	"L2_25   PT14 ",0DH,0AH
DB	"L2_26   PT14 ",0DH,0AH
DB	"L2_27   PT14 ",0DH,0AH
DB	"L2_28   PT14 ",0DH,0AH
DB	"L2_29   PT14 ",0DH,0AH
DB	"L2_30   PT14 ",0DH,0AH
DB	"L3_25   PT14 ",0DH,0AH
DB	"L3_26   PT14 ",0DH,0AH
DB	"L3_27   PT14 ",0DH,0AH
DB	"L3_28   PT14 ",0DH,0AH
DB	"L3_29   PT14 ",0DH,0AH
DB	"L3_30   PT14 ",0DH,0AH
DB	"-disk5-------",0DH,0AH
DB	"MBG1L_4 PT15 ",0DH,0AH
DB	"MBG1R_4 PT15 ",0DH,0AH
DB	"CB7     PT15 ",0DH,0AH
DB	"CB7D1   PT15 ",0DH,0AH
DB	"CB7D2   PT15 ",0DH,0AH
DB	"CB7D3   PT15 ",0DH,0AH
DB	"CB7D4   PT15 ",0DH,0AH
DB	"CB7F1   PT15 ",0DH,0AH
DB	"CB7F2   PT15 ",0DH,0AH
DB	"CB7F3   PT15 ",0DH,0AH
DB	"CB8     PT15 ",0DH,0AH
DB	"CB8D1   PT15 ",0DH,0AH
DB	"CB8D2   PT15 ",0DH,0AH
DB	"CB8D3   PT15 ",0DH,0AH
DB	"CB8D4   PT15 ",0DH,0AH
DB	"CB8F1   PT15 ",0DH,0AH
DB	"CB8F2   PT15 ",0DH,0AH
DB	"CB8F3   PT15 ",0DH,0AH
DB	"XC4-01  PT15 ",0DH,0AH
DB	"WC4-01  PT15 ",0DH,0AH
DB	"XC4-02  PT15 ",0DH,0AH
DB	"WC4-02  PT15 ",0DH,0AH
DB	"XC4-03  PT15 ",0DH,0AH
DB	"WC4-03  PT15 ",0DH,0AH
DB	"XC4-04  PT15 ",0DH,0AH
DB	"WC4-04  PT15 ",0DH,0AH
DB	"L1_01   PT15 ",0DH,0AH
DB	"L1_02   PT15 ",0DH,0AH
DB	"L1_03   PT15 ",0DH,0AH
DB	"L1_04   PT15 ",0DH,0AH
DB	"L1_05   PT15 ",0DH,0AH
DB	"L1_06   PT15 ",0DH,0AH
DB	"L2_01   PT15 ",0DH,0AH
DB	"L2_02   PT15 ",0DH,0AH
DB	"L2_03   PT15 ",0DH,0AH
DB	"L2_04   PT15 ",0DH,0AH
DB	"L2_05   PT15 ",0DH,0AH
DB	"L2_06   PT15 ",0DH,0AH
DB	"L3_01   PT15 ",0DH,0AH
DB	"L3_02   PT15 ",0DH,0AH
DB	"L3_03   PT15 ",0DH,0AH
DB	"L3_04   PT15 ",0DH,0AH
DB	"L3_05   PT15 ",0DH,0AH
DB	"L3_06   PT15 ",0DH,0AH
DB	"OCHITEXTTXT5 ",0DH,0AH
DB	"-disk6-¼­³¶¸-",0DH,0AH
DB	"MBG2L   PT16 ",0DH,0AH
DB	"MBG2R   PT16 ",0DH,0AH
DB	"MC_01   PT16 ",0DH,0AH
DB	"MC_02   PT16 ",0DH,0AH
DB	"MC_03   PT16 ",0DH,0AH
DB	"MC_04   PT16 ",0DH,0AH
DB	"MC_05   PT16 ",0DH,0AH
DB	"MC_06   PT16 ",0DH,0AH
DB	"MC_07   PT16 ",0DH,0AH
DB	"MC_08   PT16 ",0DH,0AH
DB	"MC_09   PT16 ",0DH,0AH
DB	"MC_10   PT16 ",0DH,0AH
DB	"MC_11   PT16 ",0DH,0AH
DB	"MC_12   PT16 ",0DH,0AH
DB	"MC_13   PT16 ",0DH,0AH
DB	"MC_14   PT16 ",0DH,0AH
DB	"MC_15   PT16 ",0DH,0AH
DB	"MC_16   PT16 ",0DH,0AH
DB	"MC_17   PT16 ",0DH,0AH
DB	"MC_18   PT16 ",0DH,0AH
DB	"MC_19   PT16 ",0DH,0AH
DB	"MC_20   PT16 ",0DH,0AH
DB	"MC_21   PT16 ",0DH,0AH
DB	"MC_22   PT16 ",0DH,0AH
DB	"MC_23   PT16 ",0DH,0AH
DB	"MC_24   PT16 ",0DH,0AH
DB	"MC_25   PT16 ",0DH,0AH
DB	"E1_01   PT16 ",0DH,0AH
DB	"E1_02   PT16 ",0DH,0AH
DB	"E1_03   PT16 ",0DH,0AH
DB	"E1_04   PT16 ",0DH,0AH
DB	"E1_05   PT16 ",0DH,0AH
DB	"E1_06   PT16 ",0DH,0AH
DB	"E1_07   PT16 ",0DH,0AH
DB	"E1_08   PT16 ",0DH,0AH
DB	"E1_09   PT16 ",0DH,0AH
DB	"E1_10   PT16 ",0DH,0AH
DB	"E1_11   PT16 ",0DH,0AH
DB	"E1_12   PT16 ",0DH,0AH
DB	"E1_13   PT16 ",0DH,0AH
DB	"E1_14   PT16 ",0DH,0AH
DB	"E1_15   PT16 ",0DH,0AH
DB	"E1_16   PT16 ",0DH,0AH
DB	"E1_17   PT16 ",0DH,0AH
DB	"E1_18   PT16 ",0DH,0AH
DB	"E1_19   PT16 ",0DH,0AH
DB	"E1_20   PT16 ",0DH,0AH
DB	"E1_21   PT16 ",0DH,0AH
DB	"E1_22   PT16 ",0DH,0AH
DB	"E1_23   PT16 ",0DH,0AH
DB	"PAT10S1 PT16 ",0DH,0AH
DB	"PAT10S2 PT16 ",0DH,0AH
DB	"PAT10S3 PT16 ",0DH,0AH
DB	"PAT10S4 PT16 ",0DH,0AH
DB	"PAT10S5 PT16 ",0DH,0AH
DB	"FREAMBT1PT16 ",0DH,0AH
DB	"FREAMBT2PT16 ",0DH,0AH
DB	"FREAMC1 PT16 ",0DH,0AH
DB	"FREAMC2 PT16 ",0DH,0AH
DB	"-disk7---µÁ--",0DH,0AH
DB	"L1_13   PT17 ",0DH,0AH
DB	"L1_14   PT17 ",0DH,0AH
DB	"L1_15   PT17 ",0DH,0AH
DB	"L1_16   PT17 ",0DH,0AH
DB	"L1_17   PT17 ",0DH,0AH
DB	"L1_18   PT17 ",0DH,0AH
DB	"L1_19   PT17 ",0DH,0AH
DB	"L1_20   PT17 ",0DH,0AH
DB	"L1_21   PT17 ",0DH,0AH
DB	"L1_22   PT17 ",0DH,0AH
DB	"L1_23   PT17 ",0DH,0AH
DB	"L1_24   PT17 ",0DH,0AH
DB	"L2_13   PT17 ",0DH,0AH
DB	"L2_14   PT17 ",0DH,0AH
DB	"L2_15   PT17 ",0DH,0AH
DB	"L2_16   PT17 ",0DH,0AH
DB	"L2_17   PT17 ",0DH,0AH
DB	"L2_18   PT17 ",0DH,0AH
DB	"L2_19   PT17 ",0DH,0AH
DB	"L2_20   PT17 ",0DH,0AH
DB	"L2_21   PT17 ",0DH,0AH
DB	"L2_22   PT17 ",0DH,0AH
DB	"L2_23   PT17 ",0DH,0AH
DB	"L2_24   PT17 ",0DH,0AH
DB	"L3_13   PT17 ",0DH,0AH
DB	"L3_14   PT17 ",0DH,0AH
DB	"L3_15   PT17 ",0DH,0AH
DB	"L3_16   PT17 ",0DH,0AH
DB	"L3_17   PT17 ",0DH,0AH
DB	"L3_18   PT17 ",0DH,0AH
DB	"L3_19   PT17 ",0DH,0AH
DB	"L3_20   PT17 ",0DH,0AH
DB	"L3_21   PT17 ",0DH,0AH
DB	"L3_22   PT17 ",0DH,0AH
DB	"L3_23   PT17 ",0DH,0AH
DB	"L3_24   PT17 ",0DH,0AH
DB	"-------------",0DH,0AH
	DB	10*DIRTABLE_NM_LEN DUP (0)
	DB	0,0
	DB	0,0

MSG_SYSNAME1	DB	"†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§",0
MSG_SYSNAME2	DB	"    EXELOAD PRG system view ver0.2    ",0
MSG_SYSNAME3	DB	"†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§†§",0


		EVEN
DOSSTP		DW	0	; 0=’Êí,1=•W€‚c‚n‚r‚ÌƒAƒNƒZƒX‚ðŽ~‚ß‚Ü‚·
FLAG_ERR_OUT	DW	1	; 0=ƒGƒ‰[•\Ž¦—}§,1=ƒGƒ‰[•\Ž¦

FILE_NAME_ADRS	DW	0	; ƒtƒ@ƒCƒ‹–¼

CHRPNT		DW	0	; ƒLƒƒƒ‰ƒNƒ^ƒ|ƒCƒ“ƒ^
MSGWIDFLG	DW	0	; 1=ƒƒbƒZ[ƒW•\Ž¦ŠJŽn

MODEMSG		DW	1	; 0=‰½‚à‚µ‚È‚¢, 1=‚T‚O“ƒ_ƒEƒ“

FLAG_WINDOW_OPEN DW	0	; ƒEƒCƒ“ƒhƒEƒI[ƒvƒ“ƒtƒ‰ƒO 1=OPEN

XWINDOW_FLAG	DW	0	; 1=ŠO•”ƒEƒCƒ“ƒhƒE‚ðŽg‚¤
XWINDOW_LINE	DW	0	; ŠO•”ƒEƒCƒ“ƒhƒEŽg—ps

WINDX1		DW	0	; ‚wÀ•W‚‚‰‚Ž
WINDY1		DW	0	; ‚xÀ•W‚‚‰‚Ž
WINDX2		DW	0	; ‚wÀ•W‚‚‚˜
WINDY2		DW	0	; ‚xÀ•W‚‚‚˜

USER_ST_COUNT	DW	0	; ƒ†[ƒUƒXƒ^ƒ“ƒoƒCƒJƒEƒ“ƒ^

FLAG_RAM_DR	DW	0	; RAMƒhƒ‰ƒCƒuÚ‘± 1=Ú‘±‚³‚ê‚Ä‚¢‚é,0=Ú‘±–³‚µ

;*NON*;MSGER0	DB	"[ Ü¶×Å²´×° ]",CHR_CR,CHR_LF,0
;*NON*;MSGER1	DB	"[ ¼°¸´×° ]",CHR_CR,CHR_LF,0
;*NON*;MSGER2	DB	"[ read error ]",CHR_CR,CHR_LF,0
;*NON*;MSGER3	DB	"[ write error ]",CHR_CR,CHR_LF,0
;*NON*;MSGER4	DB	"[ Ì§²Ù ¶Þ ÐÂ¶×Å² ]",CHR_CR,CHR_LF,0

DATA	ENDS
	END
;
;	end of "DSKCHG.ASM"
;
