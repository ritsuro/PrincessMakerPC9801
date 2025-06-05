; "SMAPSS.ASM" R.H 1991/03/23 PC9801UV11
;
;	map handle.
;

INCLUDE	TSTSET.INC

CNSMAP1_LENXX	EQU	120		; big map1 size x.
CNSMAP1_LENYY	EQU	100		; big map1 size y.
CNSMAP1_MINXX	EQU	0		; big map1 min x.
CNSMAP1_MINYY	EQU	0		; big map1 min y.
CNSMAP1_MAXXX	EQU	120-12		; big map1 max x.
CNSMAP1_MAXYY	EQU	100-10		; big map1 max y.
CNSBIGM1SIZE	EQU	120*100		; big map1 byte size.

CNSMAP2_LENXX	EQU	60		; big map2 size x.
CNSMAP2_LENYY	EQU	100		; big map2 size y.
CNSMAP2_MINXX	EQU	0		; big map2 min x.
CNSMAP2_MINYY	EQU	0		; big map2 min y.
CNSMAP2_MAXXX	EQU	60-12		; big map2 max x.
CNSMAP2_MAXYY	EQU	100-10		; big map2 max y.
CNSBIGM2SIZE	EQU	60*100		; big map2 byte size.

VIWLENXX	EQU	12		; view map x.
VIWLENYY	EQU	10		; view map y.

GIRLOFSXX	EQU	6		; girl offset x in view.
GIRLOFSYY	EQU	5		; girl offset y in view.
GIRLOFSYY2	EQU	6		; girl offset y in view.

INIT_XX		EQU	68		; big map init location x.
INIT_YY		EQU	89		; big map init location y.

VIEWBSIZE	EQU	12*10		; view map byte size.

CHIP_BIT_MASK	EQU	00111111B	; chip number bit mask.

KANOU_CHIP_1	EQU	1		; idou kanou chip no1.
KANOU_CHIP_2	EQU	5		; idou kanou chip no2.
KANOU_CHIP_3	EQU	6		; idou kanou chip no3.
KANOU_CHIP_4	EQU	27		; idou kanou chip no4.
KANOU_CHIP_5	EQU	28		; idou kanou chip no5.
KANOU_CHIP_6	EQU	33		; idou kanou chip no6.

KANOU_CHIP_7	EQU	29		; idou kanou chip no7.
KANOU_CHIP_8	EQU	30		; idou kanou chip no8.
KANOU_CHIP_9	EQU	35		; idou kanou chip no9.
KANOU_CHIP_10	EQU	36		; idou kanou chip no10.
KANOU_CHIP_11	EQU	1		; idou kanou chip no11.
KANOU_CHIP_12	EQU	42		; idou kanou chip no12.
KANOU_CHIP_13	EQU	1		; idou kanou chip no13.
KANOU_CHIP_14	EQU	1		; idou kanou chip no14.


CK_PLC_ANZN_1	EQU	5		; anzen chitai no1./hana.
CK_PLC_ANZN_2	EQU	5		; anzen chitai no2.

CK_PLC_KINK_1	EQU	29		; kinkoh check no1./ishidatami.
CK_PLC_KINK_2	EQU	29		; kinkoh check no2.

CK_PLC_HENK_1	EQU	1		; henkyo check no1./sougen.
CK_PLC_HENK_2	EQU	1		; henkyo check no2.

CK_PLC_BNCH_1	EQU	35		; banchi check no1./doro.
CK_PLC_BNCH_2	EQU	42		; banchi check no2./ishibashi.

MAP_1_TO_2_X1	EQU	107		; map change point 1 to 2 x.
MAP_1_TO_2_Y1	EQU	67		; map change point 1 to 2 y.

MAP2_INTER_X1	EQU	0		; map2 inter x.
MAP2_INTER_Y1	EQU	2		; map2 inter y.

MAP_2_TO_1_X1	EQU	48		; map change point 2 to 1 x.
MAP_2_TO_1_Y1	EQU	89		; map change point 2 to 1 y.

MAP1_INTER_X1	EQU	108		; map1 inter x.
MAP1_INTER_Y1	EQU	80		; map1 inter y.

GOAL_X1		EQU	99		; map goal x.
GOAL_Y1		EQU	90		; map goal y.

CHR_MY_UP_1	EQU	1
CHR_MY_UP_2	EQU	2
CHR_MY_DOWN_1	EQU	3
CHR_MY_DOWN_2	EQU	4
CHR_MY_LEFT_1	EQU	5
CHR_MY_LEFT_2	EQU	6
CHR_MY_RIGHT_1	EQU	7
CHR_MY_RIGHT_2	EQU	8

CHP_TAKAR_OPEN	EQU	53	; "takara"open.
CHP_TAKAR_CLOSE	EQU	52	; "takara"close.

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	SMAPINIT			; map init.
PUBLIC	SMAPCHNG			; map chenge.
PUBLIC	SMAPLOAD			; map load.
PUBLIC	SMAPSAVE			; map save.
PUBLIC	SMAPPUTS			; map put.
PUBLIC	SMAPMOVS			; map move.
PUBLIC	SMAPIVNT			; map ivent.
PUBLIC	SMAPIVAC			; map ivent action.
PUBLIC	SMAPRWRT			; map rewrite.
PUBLIC	SMAPCHKS			; map check.
PUBLIC	SMAPGETC			; map chip get.
PUBLIC	SMAPPUTC			; map chip put.

EXTRN	SCHIPPUT:NEAR			; chip put.
EXTRN	SCHIPCHR:NEAR			; chip char.
EXTRN	SCHIPCR2:NEAR			; chip char2.


;	map init.

SMAPINIT	PROC	NEAR
	MOV	NOWXX,INIT_XX			; big map init location x.
	MOV	NOWYY,INIT_YY			; big map init location y.
	MOV	DI,OFFSET MAPNOW		; now view map.
	CALL	VIEW_MAP_CLEAR			; view map clear.

	MOV	BIGMAP_NUMBER,1			; map buffer number.
	MOV	BIGMAP_ADRS,OFFSET BIGMAP	; map buffer address.
	MOV	BIGMBSIZE,CNSBIGM1SIZE		; big map1 byte size.
	MOV	MAPLENXX,CNSMAP1_LENXX		; big map1 size x.
	MOV	MAPLENYY,CNSMAP1_LENYY		; big map1 size y.
	MOV	MAPMINXX,CNSMAP1_MINXX		; big map1 min x.
	MOV	MAPMINYY,CNSMAP1_MINYY		; big map1 min y.
	MOV	MAPMAXXX,CNSMAP1_MAXXX		; big map1 max x.
	MOV	MAPMAXYY,CNSMAP1_MAXYY		; big map1 max y.
	RET
SMAPINIT	ENDP


;	map chenge.
;	-I- DX : map buffer number.

SMAPCHNG	PROC	NEAR
	CMP	DX,BIGMAP_NUMBER		; map buffer number.
	JE	SMAPCHNG_EXIT			;

	CMP	DX,2				;
	JE	SMAPCHNG_MAP2			;

	MOV	BIGMAP_NUMBER,1			; map buffer number.
	MOV	BIGMAP_ADRS,OFFSET BIGMAP	; map buffer address.
	MOV	BIGMBSIZE,CNSBIGM1SIZE		; big map1 byte size.
	MOV	MAPLENXX,CNSMAP1_LENXX		; big map1 size x.
	MOV	MAPLENYY,CNSMAP1_LENYY		; big map1 size y.
	MOV	MAPMINXX,CNSMAP1_MINXX		; big map1 min x.
	MOV	MAPMINYY,CNSMAP1_MINYY		; big map1 min y.
	MOV	MAPMAXXX,CNSMAP1_MAXXX		; big map1 max x.
	MOV	MAPMAXYY,CNSMAP1_MAXYY		; big map1 max y.
	JMP	SMAPCHNG_EXIT			;
SMAPCHNG_MAP2:
	MOV	BIGMAP_NUMBER,2			; map buffer number.
	MOV	BIGMAP_ADRS,OFFSET BIGMAP2	; map buffer2 address.
	MOV	BIGMBSIZE,CNSBIGM2SIZE		; big map2 byte size.
	MOV	MAPLENXX,CNSMAP2_LENXX		; big map2 size x.
	MOV	MAPLENYY,CNSMAP2_LENYY		; big map2 size y.
	MOV	MAPMINXX,CNSMAP2_MINXX		; big map2 min x.
	MOV	MAPMINYY,CNSMAP2_MINYY		; big map2 min y.
	MOV	MAPMAXXX,CNSMAP2_MAXXX		; big map2 max x.
	MOV	MAPMAXYY,CNSMAP2_MAXYY		; big map2 max y.
SMAPCHNG_EXIT:
	RET
SMAPCHNG	ENDP


;	map load.

SMAPLOAD	PROC	NEAR
	MOV	SI,OFFSET BIGMAP		; map buffer.
	MOV	FILE_SIZE,CNSBIGM1SIZE		; big map1 byte size.
	MOV	DX,OFFSET FILE_NAME		; file name.
	CALL	DISKLOAD			; disk load.

	MOV	SI,OFFSET BIGMAP2		; map buffer2.
	MOV	FILE_SIZE,CNSBIGM2SIZE		; big map2 byte size.
	MOV	DX,OFFSET FILE_NAME2		; file name2.
	CALL	DISKLOAD			; disk load.

	RET
SMAPLOAD	ENDP


;	map save.

SMAPSAVE	PROC	NEAR
	MOV	DI,OFFSET BIGMAP		; map buffer.
	MOV	FILE_SIZE,CNSBIGM1SIZE		; big map1 byte size.
	MOV	DX,OFFSET FILE_NAME		; file name.
	CALL	DISKSAVE			; disk save.

	MOV	DI,OFFSET BIGMAP2		; map buffer2.
	MOV	FILE_SIZE,CNSBIGM2SIZE		; big map2 byte size.
	MOV	DX,OFFSET FILE_NAME2		; file name2.
	CALL	DISKSAVE			; disk save.

	RET
SMAPSAVE	ENDP


;	map put.
;	-I- NOWXX : big map now location x.
;	    NOWYY : big map now location y.

SMAPPUTS	PROC	NEAR
	MOV	SI,BIGMAP_ADRS			; big map.
	MOV	DI,OFFSET MAPNXT		; next view map.
	CALL	BIG_MAP_GET			; get view map from big map.

	MOV	SI,OFFSET MAPNOW		; now view map.
	MOV	DI,OFFSET MAPDRW		; drawing view map.
	CALL	VIEW_MAP_COPY			; view map copy.

	MOV	SI,OFFSET MAPNXT		; next view map.
	MOV	DI,OFFSET MAPNOW		; now view map.
	CALL	VIEW_MAP_COPY			; view map copy.

	MOV	SI,OFFSET MAPNXT		; next view map.
	MOV	DI,OFFSET MAPDRW		; drawing view map.
	CALL	VIEW_MAP_XOR			; view map-map xor.

	MOV	SI,OFFSET MAPNXT		; next view map.
	MOV	DI,OFFSET MAPDRW		; drawing view map.
	CALL	CHR_SET_VIEW			; char set view map.

	MOV	SI,OFFSET MAPDRW		; drawing view map.
	CALL	MAP_PUT_VMAP			; map put to vmap.

	RET
SMAPPUTS	ENDP


;	map move.
;	-I/O- DIRXX : direction x.(-1,0,+1)
;	      DIRYY : direction y.(-1,0,+1)
;	-O-   AX    : 0=ok,1=kabe.

SMAPMOVS	PROC	NEAR
	CMP	DIRXX,-1
	JE	SMAPMOVS_START
	CMP	DIRXX,+1
	JE	SMAPMOVS_START

	CMP	DIRYY,-1
	JE	SMAPMOVS_START
	CMP	DIRYY,+1
	JE	SMAPMOVS_START
	RET

SMAPMOVS_START:
	CALL	MAP_MOVE_PNT		; map move point.
	CMP	AX,1			; 0=ok,1=kabe.
	JE	SMAPMOVS_KABE		;

SMAPMOVS_OK:				;
	CALL	CHR_DIRECTION		; char direction.
	CALL	MAP_CHANGE_CHK		; map chenge check.
	CALL	SMAPPUTS		; map put.

	MOV	AX,0			; 0=ok.
	RET

SMAPMOVS_KABE:
	PUSH	CHRDIR			; character dir. 1=UP,2=DN,3=L,4=R
	CALL	CHR_DIRECTION		; char direction.
	POP	DX			;
	CMP	DX,CHRDIR		; character dir. 1=UP,2=DN,3=L,4=R
	JE	SMAPMOVS_5		;
	CALL	SMAPPUTS		; map put.
SMAPMOVS_5:				;

	MOV	AX,CHRNM_BAK		; charcter number.
	MOV	BX,CHRNM		; charcter number.
	AND	AX,NOT 1		;
	AND	BX,NOT 1		;
	CMP	AX,BX			;
	JE	SMAPMOVS_E		;
	MOVX	CHRNM_BAK,CHRNM		; charcter number.
	MOV	SI,OFFSET MAPDRW	; drawing view map.
	CALL	MAP_PUT_VMAP		; map put to vmap.

SMAPMOVS_E:
	MOV	AX,1			; 1=kabe.
	RET
SMAPMOVS	ENDP


;	map ivent.
;	-I-   DIRXX : direction x.(-1,0,+1)
;	      DIRYY : direction y.(-1,0,+1)
;	-O-   AX    : 0=none,1="kanban",2="takara"
;	      DX    : "kanban" number or "takara" number.
;	      IVENT_X_NOW : ivent x now.
;	      IVENT_Y_NOW : ivent y now.

SMAPIVNT	PROC	NEAR
	PUSH	DIRXX
	PUSH	DIRYY
	PUSH	IVENT_X_NOW		; girl offset x in view.
	PUSH	IVENT_Y_NOW		; girl offset y in view.

	MOV	IVENT_X_NOW,GIRLOFSXX	; girl offset x in view.
	MOV	IVENT_Y_NOW,GIRLOFSYY2	; girl offset y in view.

	CMP	DIRXX,-1
	JE	SMAPIVNT_START
	CMP	DIRXX,+1
	JE	SMAPIVNT_START
	CMP	DIRYY,-1
	JE	SMAPIVNT_START
	CMP	DIRYY,+1
	JE	SMAPIVNT_START
	JMP	SMAPIVNT_NONE
SMAPIVNT_START:
	MOV	AX,NOWXX		; big map now location x.
	MOV	BX,NOWYY		; big map now location y.
	MOV	CX,CHRDIR		; character dir.
	CMP	AX,IVENT_X_OLD		; ivent x old.
	JNE	SMAPIVNT_2		;
	CMP	BX,IVENT_Y_OLD		; ivent y old.
	JNE	SMAPIVNT_2		;
	CMP	CX,IVENT_CHRD_OLD	; ivent character dir old.
	JNE	SMAPIVNT_2		;
	JMP	SMAPIVNT_NONE		;
SMAPIVNT_2:
	MOV	NXTXX,AX		; big map next location x.
	MOV	NXTYY,BX		; big map next location y.
	MOV	IVENT_X_OLD,AX		; ivent x old.
	MOV	IVENT_Y_OLD,BX		; ivent y old.
	MOV	IVENT_CHRD_OLD,CX	; ivent character dir old.

	CMP	CHRDIR,1		; character dir. 1=UP
	JE	SMAPIVNT_UP		;
	CMP	CHRDIR,2		; character dir. 2=DN
	JE	SMAPIVNT_DOWN		;
	CMP	CHRDIR,3		; character dir. 3=L
	JE	SMAPIVNT_LEFT		;
	CMP	CHRDIR,4		; character dir. 4=R
	JE	SMAPIVNT_RIGHT		;
	JMP	SMAPIVNT_NONE		;
SMAPIVNT_UP:
	CMP	DIRYY,-1
	JMPNE	SMAPIVNT_EXIT
	DEC	NXTYY			; big map next location y.
	DEC	IVENT_Y_NOW		; girl offset y in view.
	JMP	SMAPIVNT_CHK2
SMAPIVNT_DOWN:
	CMP	DIRYY,+1
	JMPNE	SMAPIVNT_EXIT
	INC	NXTYY			; big map next location y.
	INC	IVENT_Y_NOW		; girl offset y in view.
	JMP	SMAPIVNT_CHK2
SMAPIVNT_LEFT:
	CMP	DIRXX,-1
	JMPNE	SMAPIVNT_EXIT
	DEC	NXTXX			; big map next location x.
	DEC	IVENT_X_NOW		; girl offset x in view.
	JMP	SMAPIVNT_CHK
SMAPIVNT_RIGHT:
	CMP	DIRXX,+1
	JMPNE	SMAPIVNT_EXIT
	INC	NXTXX			; big map next location x.
	INC	IVENT_X_NOW		; girl offset x in view.
	JMP	SMAPIVNT_CHK

SMAPIVNT_CHK:
	DEC	NXTYY			; big map next location y.
	DEC	IVENT_Y_NOW		; girl offset y in view.

	CALL	CHECK_KANBAN		; "kanban" check.
	CMP	AX,1			; 0=none,1=find.
	JE	SMAPIVNT_KANBAN		;

	CALL	CHECK_TAKARA		; "takara" check.
	CMP	AX,1			; 0=none,1=find.
	JE	SMAPIVNT_TAKARA		;

	INC	NXTYY			; big map next location y.
	INC	IVENT_Y_NOW		; girl offset y in view.

SMAPIVNT_CHK2:
	CALL	CHECK_KANBAN		; "kanban" check.
	CMP	AX,1			; 0=none,1=find.
	JE	SMAPIVNT_KANBAN		;

	CALL	CHECK_TAKARA		; "takara" check.
	CMP	AX,1			; 0=none,1=find.
	JE	SMAPIVNT_TAKARA		;

	JMP	SMAPIVNT_NONE		;

SMAPIVNT_TAKARA:
	POP	AX
	POP	AX
	POP	DIRYY
	POP	DIRXX
	MOV	AX,2			; 2="takara"
	RET
SMAPIVNT_KANBAN:
	POP	AX
	POP	AX
	POP	DIRYY
	POP	DIRXX
	MOV	AX,1			; 1="kanban"
	RET
SMAPIVNT_EXIT:
SMAPIVNT_NONE:
	POP	IVENT_Y_NOW		; girl offset y in view.
	POP	IVENT_X_NOW		; girl offset x in view.
	POP	DIRYY
	POP	DIRXX
	MOV	DX,0			;
	MOV	AX,0			; 0=none
	RET
SMAPIVNT	ENDP


;	map ivent action.
;	-I- DX          : function. 1="takara"open,2="takara"close.

SMAPIVAC	PROC	NEAR
	CMP	DX,1			; function. 1="takara"open.
	JE	SMAPIVAC_FC01		;
	CMP	DX,2			; function. 2="takara"close.
	JMPEQ	SMAPIVAC_FC02		;
	JMP	SMAPIVAC_EXIT		;
SMAPIVAC_FC01:
	MOV	AX,IVENT_X_NOW		; ivent x now.
	MOV	BX,IVENT_Y_NOW		; ivent y now.
	MOV	VIWXX,AX		; view x.
	MOV	VIWYY,BX		; view y.
	MOV	VIWCHP,CHP_TAKAR_OPEN	; "takara"open.
	CALL	SMAPPUTC		; map chip put.
	CALL	SMAPRWRT		; map rewrite.
	JMP	SMAPIVAC_EXIT		;
SMAPIVAC_FC02:
	MOV	AX,IVENT_X_NOW		; ivent x now.
	MOV	BX,IVENT_Y_NOW		; ivent y now.
	MOV	VIWXX,AX		; view x.
	MOV	VIWYY,BX		; view y.
	MOV	VIWCHP,CHP_TAKAR_CLOSE	; "takara"close.
	CALL	SMAPPUTC		; map chip put.
	CALL	SMAPRWRT		; map rewrite.
	JMP	SMAPIVAC_EXIT		;
SMAPIVAC_EXIT:
	RET
SMAPIVAC	ENDP



;	map rewrite.

SMAPRWRT	PROC	NEAR
	MOV	DI,OFFSET MAPNOW	; now view map.
	CALL	VIEW_MAP_CLEAR		; view map clear.
	CALL	SMAPPUTS		; map put.
	RET
SMAPRWRT	ENDP


;	map check.
;	-O- AX : place.  1=kinkoh,2=henkyo,3=banchi,4=anzenchitai,5=goal.

SMAPCHKS	PROC	NEAR
	CMP	NOWXX,GOAL_X1		; map goal x.
	JNE	SMAPCHKS_1		;
	CMP	NOWYY,GOAL_Y1		; map goal y.
	JNE	SMAPCHKS_1		;
	JMP	SMAPCHKS_GOAL		;
SMAPCHKS_1:				;

	MOV	VIWXX,GIRLOFSXX		; girl offset x in view.
	MOV	VIWYY,GIRLOFSYY2	; girl offset y in view.
	CALL	SMAPGETC		; map chip get.

	MOV	AL,BYTE PTR VIWCHP	; view chip number.

	CMP	AL,CK_PLC_KINK_1	; kinkoh check no1./ishidatami.
	JE	SMAPCHKS_KINKOU		;
	CMP	AL,CK_PLC_KINK_2	; kinkoh check no2.
	JE	SMAPCHKS_KINKOU		;

	CMP	AL,CK_PLC_HENK_1	; henkyo check no1./sougen.
	JE	SMAPCHKS_HENKYOU	;
	CMP	AL,CK_PLC_HENK_2	; henkyo check no2.
	JE	SMAPCHKS_HENKYOU	;

	CMP	AL,CK_PLC_BNCH_1	; banchi check no1./doro.
	JE	SMAPCHKS_BANCHI		;
	CMP	AL,CK_PLC_BNCH_2	; banchi check no2./ishibashi.
	JE	SMAPCHKS_BANCHI		;

	CMP	AL,CK_PLC_ANZN_1	; anzen chitai no1./hana.
	JE	SMAPCHKS_ANZEN		;
	CMP	AL,CK_PLC_ANZN_2	; anzen chitai no2.
	JE	SMAPCHKS_ANZEN		;

SMAPCHKS_DEF:
	MOV	AX,DEF_PLACE		; default place.
	RET
SMAPCHKS_KINKOU:
	MOV	AX,1			; 1=kinkoh
	MOV	DEF_PLACE,AX		; default place.
	RET
SMAPCHKS_HENKYOU:
	MOV	AX,2			; 2=henkyo
	MOV	DEF_PLACE,AX		; default place.
	RET
SMAPCHKS_BANCHI:
	MOV	AX,3			; 3=banchi
	MOV	DEF_PLACE,AX		; default place.
	RET
SMAPCHKS_ANZEN:
	MOV	AX,4			; 4=anzenchitai.
	MOV	DEF_PLACE,AX		; default place.
	RET
SMAPCHKS_GOAL:
	MOV	AX,5			; 5=goal.
	RET
SMAPCHKS	ENDP


;	map chip get.
;	-I- VIWXX  : view x.
;	    VIWYY  : view y.
;	-O- VIWCHP : view chip number.

SMAPGETC	PROC	NEAR	
	MOV	AX,VIWXX			; view x.
	MOV	BX,VIWYY			; view y.
	ADD	AX,NOWXX			; big map now location x.
	ADD	BX,NOWYY			; big map now location y.
	MOV	PNTXX,AX			; big map now location x.
	MOV	PNTYY,BX			; big map now location y.
	CALL	GET_BIG_MAP			; get chip number to big map.
	RET
SMAPGETC	ENDP


;	map chip put.
;	-I- VIWXX  : view x.
;	    VIWYY  : view y.
;	    VIWCHP : view chip number.

SMAPPUTC	PROC	NEAR
	MOV	AX,VIWXX			; view x.
	MOV	BX,VIWYY			; view y.
	ADD	AX,NOWXX			; big map now location x.
	ADD	BX,NOWYY			; big map now location y.
	MOV	PNTXX,AX			; big map now location x.
	MOV	PNTYY,BX			; big map now location y.
	CALL	PUT_BIG_MAP			; put chip number to big map.
	RET
SMAPPUTC	ENDP


; *********************************************************
;	checks subroutine.
; *********************************************************

;	map move point.
;	-I/O- DIRXX : direction x.(-1,0,+1)
;	      DIRYY : direction y.(-1,0,+1)
;	      NOWXX : big map now location x.
;	      NOWYY : big map now location y.
;	-O-   AX    : 0=ok,1=kabe.

MAP_MOVE_PNT	PROC	NEAR
	PUSH	DIRXX			; direction x.(-1,0,+1)
	PUSH	DIRYY			; direction y.(-1,0,+1)

	CALL	MOVE_POINT		; move point calc.
	CMP	AX,0			; 0=ok,1=kabe.
	JE	MAP_MOVE_PNT_OK		;

	CMP	DIRYY,0			;
	JE	MAP_MOVE_PNT_5		;
	PUSH	DIRXX			;
	MOV	DIRXX,0			;
	CALL	MOVE_POINT		; move point calc.
	POP	DX			;
	CMP	AX,0			; 0=ok,1=kabe.
	JE	MAP_MOVE_PNT_OK		;

	MOV	DIRXX,DX		;
MAP_MOVE_PNT_5:

	CMP	DIRXX,0			;
	JE	MAP_MOVE_PNT_6		;
	PUSH	DIRYY			;
	MOV	DIRYY,0			;
	CALL	MOVE_POINT		; move point calc.
	POP	DX			;
	CMP	AX,0			; 0=ok,1=kabe.
	JE	MAP_MOVE_PNT_OK		;

	MOV	DIRYY,DX		;
MAP_MOVE_PNT_6:

MAP_MOVE_PNT_KABE:
	POP	DIRYY			; direction y.(-1,0,+1)
	POP	DIRXX			; direction x.(-1,0,+1)
	MOV	AX,1			; 1=kabe.
	RET
MAP_MOVE_PNT_OK:
	POP	AX
	POP	AX
	MOV	AX,0			; 0=ok
	RET
MAP_MOVE_PNT	ENDP



;	map chenge check.
;	-I/O- NOWXX : big map now location x.
;	      NOWYY : big map now location y.

MAP_CHANGE_CHK	PROC	NEAR
	CMP	BIGMAP_NUMBER,2			; map buffer number.
	JE	MAP_CHANGE_CHK_MAP2		;

MAP_CHANGE_CHK_MAP1:
	CMP	NOWXX,MAP_1_TO_2_X1	; map change point 1 to 2 x.
	JNE	MAP_CHANGE_CHK_EXIT	;
	CMP	NOWYY,MAP_1_TO_2_Y1	; map change point 1 to 2 y.
	JNE	MAP_CHANGE_CHK_EXIT	;

	MOV	NOWXX,MAP2_INTER_X1	; map2 inter x.
	MOV	NOWYY,MAP2_INTER_Y1	; map2 inter y.

	MOV	DX,2			; map buffer number.
	CALL	SMAPCHNG		; map chenge.

	JMP	MAP_CHANGE_CHK_EXIT	;
MAP_CHANGE_CHK_MAP2:
	CMP	NOWXX,MAP_2_TO_1_X1	; map change point 2 to 1 x.
	JNE	MAP_CHANGE_CHK_EXIT	;
	CMP	NOWYY,MAP_2_TO_1_Y1	; map change point 2 to 1 y.
	JNE	MAP_CHANGE_CHK_EXIT	;

	MOV	NOWXX,MAP1_INTER_X1	; map1 inter x.
	MOV	NOWYY,MAP1_INTER_Y1	; map1 inter y.

	MOV	DX,1			; map buffer number.
	CALL	SMAPCHNG		; map chenge.

MAP_CHANGE_CHK_EXIT:
	RET
MAP_CHANGE_CHK	ENDP


;	char direction.
;	-I-   DIRXX : direction x.(-1,0,+1)
;	      DIRYY : direction y.(-1,0,+1)
;	-I/O- CHRNM : chracter number.
;	      CHRDIR: character dir. 1=UP,2=DN,3=L,4=R

CHR_DIRECTION	PROC	NEAR
	MOV	AX,DIRXX		; direction x.(-1,0,+1)
	MOV	BX,DIRYY		; direction y.(-1,0,+1)
	CMP	AX,DIRXX_OLD		; direction x old.(-1,0,+1)
	JNE	CHR_DIRECTION_CHG	;
	CMP	BX,DIRYY_OLD		; direction y old.(-1,0,+1)
	JNE	CHR_DIRECTION_CHG	;

	CMP	AX,0			;
	JNE	CHR_DIRECTION_UGOKI	;
	CMP	BX,0			;
	JNE	CHR_DIRECTION_UGOKI	;

	JMP	CHR_DIRECTION_SKIP	;
CHR_DIRECTION_CHG:
	MOV	DIRXX_OLD,AX		; direction x old.(-1,0,+1)
	MOV	DIRYY_OLD,BX		; direction y old.(-1,0,+1)

	CMP	DIRXX,-1		; direction x.(-1,0,+1)
	JE	CHR_DIRECTION_NON_LEFT	;
	CMP	DIRXX,+1		; direction x.(-1,0,+1)
	JE	CHR_DIRECTION_NON_RIGHT	;
	CMP	DIRYY,-1		; direction y.(-1,0,+1)
	JE	CHR_DIRECTION_UP	;
	CMP	DIRYY,+1		; direction y.(-1,0,+1)
	JE	CHR_DIRECTION_DOWN	;

	JMP	CHR_DIRECTION_SKIP	;
CHR_DIRECTION_NON_LEFT:			;
	MOV	CHRNM,CHR_MY_LEFT_1	;
	MOV	CHRDIR,3		; character dir.3=L
	JMP	CHR_DIRECTION_UGOKI	;
CHR_DIRECTION_NON_RIGHT:
	MOV	CHRNM,CHR_MY_RIGHT_1	;
	MOV	CHRDIR,4		; character dir.4=R
	JMP	CHR_DIRECTION_UGOKI	;
CHR_DIRECTION_UP:
	MOV	CHRNM,CHR_MY_UP_1	;
	MOV	CHRDIR,1		; character dir.1=UP
	JMP	CHR_DIRECTION_UGOKI	;
CHR_DIRECTION_DOWN:
	MOV	CHRNM,CHR_MY_DOWN_1	;
	MOV	CHRDIR,2		; character dir.2=DN
	JMP	CHR_DIRECTION_UGOKI	;

CHR_DIRECTION_UGOKI:

	INC	UGOKI_FLAG		; ugoki flag.
	AND	UGOKI_FLAG,1B		;

	AND	CHRNM,0FFFEH		;
	MOV	AX,UGOKI_FLAG		;
	ADD	CHRNM,AX		;

CHR_DIRECTION_SKIP:
	RET
CHR_DIRECTION	ENDP


;	move point calc.
;	-I-   DIRXX : direction x.(-1,0,+1)
;	      DIRYY : direction y.(-1,0,+1)
;	-I/O- NOWXX : big map now location x.
;	      NOWYY : big map now location y.
;	-O-   AX    : 0=ok,1=kabe.

MOVE_POINT	PROC	NEAR
	MOV	AX,NOWXX		; big map now location x.
	MOV	BX,NOWYY		; big map now location y.
	ADD	AX,DIRXX		; direction x.(-1,0,+1)
	ADD	BX,DIRYY		; direction y.(-1,0,+1)

	CMP	AX,MAPMINXX		; big map min x.
	JL	MOVE_POINT_XX_SKIP	;
	CMP	AX,MAPMAXXX		; big map max x.
	JG	MOVE_POINT_XX_SKIP	;
	MOV	NXTXX,AX		; big map next location x.
MOVE_POINT_XX_SKIP:

	CMP	BX,MAPMINYY		; big map min y.
	JL	MOVE_POINT_YY_SKIP	;
	CMP	BX,MAPMAXYY		; big map max y.
	JG	MOVE_POINT_YY_SKIP	;
	MOV	NXTYY,BX		; big map next location y.
MOVE_POINT_YY_SKIP:

	CALL	MOVE_CHECK		; move check.
	CMP	AX,1			; 0=ok,1=kabe.
	JE	MOVE_POINT_KABE		;

	MOV	AX,NXTXX		; big map next location x.
	MOV	BX,NXTYY		; big map next location y.
	MOV	NOWXX,AX		; big map now location x.
	MOV	NOWYY,BX		; big map now location y.

MOVE_POINT_EXIT:
	MOV	AX,0			; 0=ok
	RET
MOVE_POINT_KABE:
	MOV	AX,1			; 1=kabe.
	RET
MOVE_POINT	ENDP


;	move check.
;	-I- NXTXX : big map next location x.
;	    NXTYY : big map next location y.
;	-O- AX    : 0=ok,1=kabe.

MOVE_CHECK	PROC	NEAR
	CMP	MOVECHK_FREE,1		; move check free.0=none,1=free
	JMPEQ	MOVE_CHECK_OK		;

	CALL	POINT_GET		; point get.

	CMP	AL,KANOU_CHIP_1		; idou kanou chip no1.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_2		; idou kanou chip no2.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_3		; idou kanou chip no3.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_4		; idou kanou chip no4.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_5		; idou kanou chip no5.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_6		; idou kanou chip no6.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_7		; idou kanou chip no7.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_8		; idou kanou chip no8.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_9		; idou kanou chip no9.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_10	; idou kanou chip no10.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_11	; idou kanou chip no11.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_12	; idou kanou chip no12.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_13	; idou kanou chip no13.
	JE	MOVE_CHECK_OK		;
	CMP	AL,KANOU_CHIP_14	; idou kanou chip no14.
	JE	MOVE_CHECK_OK		;

	JMP	MOVE_CHECK_KABE		;
MOVE_CHECK_OK:
	MOV	AX,0			; 0=ok
	RET
MOVE_CHECK_KABE:
	MOV	AX,1			; 1=kabe.
	RET
MOVE_CHECK	ENDP


;	"takara" check.
;	-I- NXTXX : big map next location x.
;	    NXTYY : big map next location y.
;	-O- AX    : 0=none,1=find.
;	    DX    : number.

CHECK_TAKARA	PROC	NEAR
	CALL	POINT_GET			; point get.
	CMP	AL,CHP_TAKAR_CLOSE		; "takara"close.
	JNE	CHECK_TAKARA_NONE		;

	MOV	SI,OFFSET LOC_TAKARA_TBL	; "takara" location table.
	MOV	DX,NXTXX			; big map next location x.
	MOV	BX,NXTYY			; big map next location y.
	CALL	TABLE_P_SCH			; table point search.

	CMP	BIGMAP_NUMBER,2			; map buffer number.
	JE	CHECK_TAKARA_2			;
CHECK_TAKARA_1:
	CMP	DX,3				; number.
	JG	CHECK_TAKARA_NONE		;
	JMP	CHECK_TAKARA_3			;
CHECK_TAKARA_2:
	CMP	DX,3				; number.
	JLE	CHECK_TAKARA_NONE		;
CHECK_TAKARA_3:
	RET
CHECK_TAKARA_NONE:
	MOV	AX,0				; 0=none
	RET
CHECK_TAKARA	ENDP


;	"kanban" check.
;	-I- NXTXX : big map next location x.
;	    NXTYY : big map next location y.
;	-O- AX    : 0=none,1=find.
;	    DX    : number.

CHECK_KANBAN	PROC	NEAR
	MOV	SI,OFFSET LOC_KANBAN_TBL	; "kanban" location table.
	MOV	DX,NXTXX			; big map next location x.
	MOV	BX,NXTYY			; big map next location y.
	CALL	TABLE_P_SCH			; table point search.

	CMP	BIGMAP_NUMBER,2			; map buffer number.
	JE	CHECK_KANBAN_2			;
CHECK_KANBAN_1:
	CMP	DX,5				; number.
	JG	CHECK_KANBAN_NONE		;
	JMP	CHECK_KANBAN_3			;
CHECK_KANBAN_2:
	CMP	DX,5				; number.
	JLE	CHECK_KANBAN_NONE		;
CHECK_KANBAN_3:
	RET
CHECK_KANBAN_NONE:
	MOV	AX,0				; 0=none
	RET
CHECK_KANBAN	ENDP


;	point get.
;	-I- NXTXX : big map next location x.
;	    NXTYY : big map next location y.
;	-O- AL    : chip number.

POINT_GET	PROC	NEAR
	MOVX	PNTXX,NXTXX		; big map now location x.
	MOVX	PNTYY,NXTYY		; big map now location y.
	ADD	PNTXX,GIRLOFSXX		; girl offset x in view.
	ADD	PNTYY,GIRLOFSYY2	; girl offset y in view.
	MOV	SI,BIGMAP_ADRS		; big map.
	CALL	BIGMAP_PNT_ADRS		; big map start address.
	LODSB				; al=chip number.
	RET
POINT_GET	ENDP


;	char set view map.
;	-I- SI : source view map address.
;	    DI : dest view map address.

CHR_SET_VIEW	PROC	NEAR
	MOV	BX,GIRLOFSYY*VIWLENXX+GIRLOFSXX	; girl offset x in view.
	MOV	AL,DS:[SI][BX]
	MOV	DS:[DI][BX],AL

	MOV	BX,GIRLOFSYY2*VIWLENXX+GIRLOFSXX ; girl offset x in view.
	MOV	AL,DS:[SI][BX]
	MOV	DS:[DI][BX],AL

	RET
CHR_SET_VIEW	ENDP


;	table point search.
;	-I- SI : table address.
;	    DX : x point.
;	    BX : y point.
;	-O- AX : 0=none,1=find.
;	    DX : number.

TABLE_P_SCH	PROC	NEAR
	MOV	DI,0			; number.
	LODSB				;
	MOV	CL,AL			; max.
	XOR	CH,CH			; CH=0
	JCXZ	TABLE_P_SCH_NONE	;
TABLE_P_SCH_LOOP:
	INC	DI			; number.
	LODSB				;
	MOV	AH,AL			; ah=x
	LODSB				; al=y
	CMP	AH,DL			; DL : x point.
	JNE	TABLE_P_SCH_NEXT	;
	CMP	AL,BL			; BL : y point.
	JNE	TABLE_P_SCH_NEXT	;
	JMP	TABLE_P_SCH_SCH		;
TABLE_P_SCH_NEXT:
	LOOP	TABLE_P_SCH_LOOP
TABLE_P_SCH_NONE:
	MOV	DX,0			; number.
	MOV	AX,0			; 0=none.
	RET
TABLE_P_SCH_SCH:
	MOV	DX,DI			; number.
	MOV	AX,1			; 1=find.
	RET
TABLE_P_SCH	ENDP



; *********************************************************
;	memory subroutine.
; *********************************************************

;	get chip number to big map.
;	-I- PNTXX : big map now location x.
;	    PNTYY : big map now location y.
;	-O- VIWCHP : view chip number.

GET_BIG_MAP	PROC	NEAR
	MOV	SI,BIGMAP_ADRS		; big map.
	CALL	BIGMAP_PNT_ADRS		; big map start address.
	MOV	AL,DS:[SI]		; big map start address.
	MOV	BYTE PTR VIWCHP,AL	; big map start address.
	RET
GET_BIG_MAP	ENDP


;	put chip number to big map.
;	-I- PNTXX : big map now location x.
;	    PNTYY : big map now location y.
;	    VIWCHP : view chip number.

PUT_BIG_MAP	PROC	NEAR
	MOV	SI,BIGMAP_ADRS		; big map.
	CALL	BIGMAP_PNT_ADRS		; big map start address.
	MOV	AL,BYTE PTR VIWCHP	; big map start address.
	MOV	DS:[SI],AL		; big map start address.
	RET
PUT_BIG_MAP	ENDP


;	big map start address.
;	-I- SI    : big map address.
;	    PNTXX : big map now location x.
;	    PNTYY : big map now location y.
;	-O- SI    : big map start address.

BIGMAP_PNT_ADRS	PROC	NEAR
	MOV	AX,PNTYY			; big map now location y.
	MOV	BX,MAPLENXX			; big map size x.
	MUL	BX				;
	ADD	AX,PNTXX			; big map now location x.
	ADD	SI,AX				; big map address.
	RET
BIGMAP_PNT_ADRS	ENDP


;	map put to vmap.
;	-I- SI : view map address.

MAP_PUT_VMAP	PROC	NEAR
	MOV	PUTYY,0				; put y.
	MOV	CX,VIWLENYY			; view map y.
MAP_PUT_VMAP_LOOP_YY:				;
	PUSH	CX				;
	MOV	PUTXX,0				; put x.
	MOV	CX,VIWLENXX			; view map x.
MAP_PUT_VMAP_LOOP_XX:				;
	PUSH	CX				;
	LODSB					;
	CMP	AL,0				; 0=none.
	JE	MAP_PUT_VMAP_NEXT_XX		;

	AND	AL,CHIP_BIT_MASK		; chip number bit mask.
	MOV	BYTE PTR PUTNM,AL		; chip number.
	CALL	CHIPPUT				; chip put.

MAP_PUT_VMAP_NEXT_XX:				;
	INC	PUTXX				; put x.
	POP	CX				;
	LOOP	MAP_PUT_VMAP_LOOP_XX		;
	INC	PUTYY				; put y.
	POP	CX				;
	LOOP	MAP_PUT_VMAP_LOOP_YY		;
	RET
MAP_PUT_VMAP	ENDP


;	get view map from big map.
;	-I- SI : big map address.
;	    DI : view map address.

BIG_MAP_GET	PROC	NEAR
	CALL	BIGMAP_SRT_ADRS			; big map start address.

	MOV	DX,SI				; big map pointer.

	MOVX	ES,DS				;
	MOV	CX,VIWLENYY			; view map y.
BIG_MAP_GET_LOOP:				;
	PUSH	CX				;

	MOV	SI,DX				; big map pointer.
	MOV	CX,VIWLENXX			; view map x.
	REP	MOVSB				; moving.

	ADD	DX,MAPLENXX			; big map size x.

	POP	CX				;
	LOOP	BIG_MAP_GET_LOOP		;
	RET
BIG_MAP_GET	ENDP


;	big map start address.
;	-I- SI : big map address.
;	-O- SI : big map start address.

BIGMAP_SRT_ADRS	PROC	NEAR
	MOV	AX,NOWYY			; big map now location y.
	MOV	BX,MAPLENXX			; big map size x.
	MUL	BX				;
	ADD	AX,NOWXX			; big map now location x.
	ADD	SI,AX				; big map address.
	RET
BIGMAP_SRT_ADRS	ENDP


;	view map clear.
;	-I- DI : view map address.

VIEW_MAP_CLEAR	PROC	NEAR
	MOVX	ES,DS				;
	MOV	CX,VIEWBSIZE			; view map byte size.
	MOV	AL,0				; zero clear.
	REP	STOSB				; clear.
	RET
VIEW_MAP_CLEAR	ENDP


;	view map copy.
;	-I- SI : source view map address.
;	    DI : dest view map address.

VIEW_MAP_COPY	PROC	NEAR
	MOVX	ES,DS				;
	MOV	CX,VIEWBSIZE			; view map byte size.
	REP	MOVSB				; clear.
	RET
VIEW_MAP_COPY	ENDP


;	view map-map xor.
;	-I- SI : source view map address.
;	    DI : dest view map address.

VIEW_MAP_XOR	PROC	NEAR
	XOR	AH,AH				; zero.
	MOV	CX,VIEWBSIZE			; view map byte size.
VIEW_MAP_XOR_LOOP:
	LODSB					; load al.
	CMP	DS:[DI],AL			; compear(xor)
	JE	VIEW_MAP_XOR_CLEAR		;

VIEW_MAP_XOR_SET:				;
	MOV	DS:[DI],AL			;
	INC	DI				; byte pointer.
	LOOP	VIEW_MAP_XOR_LOOP
	RET

VIEW_MAP_XOR_CLEAR:				;
	MOV	DS:[DI],AH			; clear.
	INC	DI				; byte pointer.
	LOOP	VIEW_MAP_XOR_LOOP
	RET
VIEW_MAP_XOR	ENDP


; *********************************************************
;	exturnal subroutine.
; *********************************************************

;	chip put.
;	-I- PUTXX : put x.
;	    PUTYY : put y.
;	    PUTNM : chip number.

CHIPPUT	PROC	NEAR
	CMP	PUTXX,GIRLOFSXX		; girl offset x in view.
	JNE	CHIPPUT_2		;
	CMP	PUTYY,GIRLOFSYY		; girl offset y in view.
	JNE	CHIPPUT_1		;
	CALL	CHIPON_CHR		; chip put on char.
	RET
CHIPPUT_1:
	CMP	PUTYY,GIRLOFSYY2	; girl offset y in view.
	JNE	CHIPPUT_2		;
	CALL	CHIPON_2CHR		; chip put on char2.
	RET
CHIPPUT_2:				;
	PUSH	SI			;
	CALL	SCHIPPUT		; chip put.
	POP	SI
	RET
CHIPPUT	ENDP


;	chip put on char.
;	-I- PUTXX : put x.
;	    PUTYY : put y.
;	    PUTNM : chip number.

CHIPON_CHR	PROC	NEAR
	PUSH	SI
	CALL	SCHIPCHR		; chip char.
	POP	SI
	RET
CHIPON_CHR	ENDP


;	chip put on char2.
;	-I- PUTXX : put x.
;	    PUTYY : put y.
;	    PUTNM : chip number.

CHIPON_2CHR	PROC	NEAR
	PUSH	SI
	CALL	SCHIPCR2		; chip char2.
	POP	SI
	RET
CHIPON_2CHR	ENDP


;	disk load.
;	-I- SI        : big map address.
;	    DX        : file name.
;	    FILE_SIZE : file size.

DISKLOAD	PROC	NEAR
	MOV	AL,0			; access mode.
	MOV	AH,3DH			; handle open.
	INT	21H			; DOS call.
	JC	DISKLOAD_EXIT		;
	MOV	FILE_HANDLE,AX		; file handle.

	MOV	DX,SI			; map buffer.
	MOV	CX,FILE_SIZE		; file size.
	MOV	BX,FILE_HANDLE		; file handle.
	MOV	AH,3FH			; read handle.
	INT	21H			; DOS call.

	MOV	BX,FILE_HANDLE		; file handle.
	MOV	AH,3EH			; handle close.
	INT	21H			; DOS call.
DISKLOAD_EXIT:
	RET
DISKLOAD	ENDP


;	disk save.
;	-I- DI        : big map address.
;	    DX        : file name.
;	    FILE_SIZE : file size.

DISKSAVE	PROC	NEAR
	MOV	CX,0			; attribute.
	MOV	AH,3CH			; handle open.
	INT	21H			; DOS call.
	JC	DISKSAVE_EXIT		;
	MOV	FILE_HANDLE,AX		; file handle.

	MOV	DX,DI			; map buffer.
	MOV	CX,FILE_SIZE		; file size.
	MOV	BX,FILE_HANDLE		; file handle.
	MOV	AH,40H			; write handle.
	INT	21H			; DOS call.

	MOV	BX,FILE_HANDLE		; file handle.
	MOV	AH,3EH			; handle close.
	INT	21H			; DOS call.
DISKSAVE_EXIT:
	RET
DISKSAVE	ENDP


; *********************************************************
;		DATA.
; *********************************************************
		EVEN
PUBLIC	DIRXX					; direction x.(-1,0,+1)
PUBLIC	DIRYY					; direction y.(-1,0,+1)
PUBLIC	VIWXX					; view x.
PUBLIC	VIWYY					; view y.
PUBLIC	VIWCHP					; view chip number.

PUBLIC	PUTXX					; put x.
PUBLIC	PUTYY					; put y.
PUBLIC	PUTNM					; chip number.
PUBLIC	CHRNM					; charcter number.

PUBLIC	NOWXX					; big map now location x.
PUBLIC	NOWYY					; big map now location y.

PUBLIC	MOVECHK_FREE				; move check free.0=none,1=free

EXTRN	BIGMAP:BYTE				; map buffer.
EXTRN	BIGMAP2:BYTE				; map buffer2.

MOVECHK_FREE	DW	0			; move check free.0=none,1=free

BIGMAP_NUMBER	DW	1			; map buffer number.
BIGMAP_ADRS	DW	OFFSET BIGMAP		; map buffer address.
BIGMBSIZE	DW	CNSBIGM1SIZE		; big map1 byte size.

MAPLENXX	DW	CNSMAP1_LENXX		; big map1 size x.
MAPLENYY	DW	CNSMAP1_LENYY		; big map1 size y.
MAPMINXX	DW	CNSMAP1_MINXX		; big map min x.
MAPMINYY	DW	CNSMAP1_MINYY		; big map min y.
MAPMAXXX	DW	CNSMAP1_MAXXX		; big map max x.
MAPMAXYY	DW	CNSMAP1_MAXYY		; big map max y.

PUTXX		DW	0			; put x.
PUTYY		DW	0			; put y.
PUTNM		DW	0			; chip number.
CHRNM		DW	1			; charcter number.
CHRNM_BAK	DW	1			; charcter number back.
CHRDIR		DW	1			; character dir.
						; 1=UP,2=DN,3=L,4=R

MAPNXT		DW	VIEWBSIZE DUP (0)	; next view map.
MAPNOW		DW	VIEWBSIZE DUP (0FFH)	; now view map.
MAPDRW		DW	VIEWBSIZE DUP (0)	; drawing view map.

NOWXX		DW	0			; big map now location x.
NOWYY		DW	0			; big map now location y.

NXTXX		DW	0			; big map next location x.
NXTYY		DW	0			; big map next location y.

PNTXX		DW	0			; big map location x.
PNTYY		DW	0			; big map location y.

DIRXX		DW	0			; direction x.(-1,0,+1)
DIRYY		DW	0			; direction y.(-1,0,+1)
VIWXX		DW	0			; view x.
VIWYY		DW	0			; view y.
VIWCHP		DW	0			; view chip number.

DIRXX_OLD	DW	0			; direction x old.(-1,0,+1)
DIRYY_OLD	DW	0			; direction y old.(-1,0,+1)

IVENT_X_OLD	DW	0			; ivent x old.
IVENT_Y_OLD	DW	0			; ivent y old.
IVENT_CHRD_OLD	DW	1			; ivent character dir old.

IVENT_X_NOW	DW	0			; ivent x now.
IVENT_Y_NOW	DW	0			; ivent y now.

UGOKI_FLAG	DW	0			; ugoki flag.

DEF_PLACE	DW	0			; default place.

LOC_TAKARA_TBL	LABEL	BYTE			; "takara" location table.
		DB	5			; max.
		DB	 19,89			; 1.
		DB	  2,12			; 2.
		DB	107,18			; 3.
		DB	  4,11			; 4.
		DB	 13,58			; 5.
		DB	0

LOC_KANBAN_TBL	LABEL	BYTE			; "kanban" location table.
		DB	8			; max.
		DB	 68,84 			; 1.
		DB	 15,51			; 2.
		DB	 30,31			; 3.
		DB	 26, 8			; 4.
		DB	 75,26			; 5.
		DB	 45,87			; 6.
		DB	106,78 			; 7.
		DB	100,88			; 8.
		DB	0

FILE_HANDLE	DW	0			; file handle.
FILE_SIZE	DW	0			; file size.
FILE_NAME	DB	"MUSYA.MMP",0		; file name.
FILE_NAME2	DB	"MUSYA.MP2",0		; file name2.

CODE	ENDS

	END
;
;	end of "SMAPSS.ASM"
;
