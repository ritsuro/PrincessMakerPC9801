; "MAINLOOP.ASM" PC-9801UV11 make by R.H 1991/03/25
;
;	main loop.
;
; public subroutine.

INCLUDE	TSTSET.INC

WORLD_LOC_XX	EQU	2		; world location x.
WORLD_LOC_YY	EQU	40		; world location y.
WORLD_LOC_OFST	EQU	80*40+2		; world location offset.

VIWLENXX	EQU	12		; view map x.
VIWLENYY	EQU	10		; view map y.

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	MAINLOOP			; main loop.

PUBLIC	MAINEXTRN			; main extrun process.

EXTRN	SMAPINIT:NEAR			; map init.
EXTRN	SMAPLOAD:NEAR			; map load.
EXTRN	SMAPSAVE:NEAR			; map save.
EXTRN	SMAPPUTS:NEAR			; map put.
EXTRN	SMAPMOVS:NEAR			; map move.
EXTRN	SMAPIVNT:NEAR			; map ivent.
EXTRN	SMAPIVAC:NEAR			; map ivent action.
EXTRN	SMAPRWRT:NEAR			; map rewrite.
EXTRN	SMAPCHKS:NEAR			; map check.
EXTRN	SMAPGETC:NEAR			; map chip get.
EXTRN	SMAPPUTC:NEAR			; map chip put.

EXTRN	MUSREDX:NEAR			; É}ÉEÉXì«Ç›çûÇ›
EXTRN	MUSWATX:NEAR			; É}ÉEÉXÉ{É^ÉìÇnÇeÇeë“Çø

EXTRN	TIMER:NEAR			; É^ÉCÉ}(V-SYNC timer wait.)

;	main loop.

MAINLOOP	PROC	NEAR
	CALL	CLS			; text clear.
	CALL	SMAPINIT		; map init.
	CALL	SMAPLOAD		; map load.
	CALL	SMAPPUTS		; map put.
MAINLOOP_LOOP:
	LC 0,0
	PRV	"chip number:",CUR_CHIP_NUMBER
	PRF	"1-64:chip number."
;*;	PRF	"91:LOAD"
	PRF	"92:SAVE"
	PRF	"93:EDIT"
	PRF	"94:MOVE"
	PRF	"95:PNT"
	PRF	"M:MOVE"
	PRF	"D:DMODE"
	PRF	"X:EXIT"
	PRF	"Q:QUIT"
MAINLOOP_INP:
	PR	"menu:"
	CALL	INPUT
	CMP	BYTE PTR DS:[SI],"X"
	JMPEQ	MAINLOOP_EXIT
	CMP	BYTE PTR DS:[SI],"x"
	JMPEQ	MAINLOOP_EXIT

	CMP	BYTE PTR DS:[SI],"Q"
	JMPEQ	MAINLOOP_QUIT
	CMP	BYTE PTR DS:[SI],"q"
	JMPEQ	MAINLOOP_QUIT

	CMP	BYTE PTR DS:[SI],"M"
	JMPEQ	MAINLOOP_MOVE
	CMP	BYTE PTR DS:[SI],"m"
	JMPEQ	MAINLOOP_MOVE
	CMP	BYTE PTR DS:[SI],"D"
	JMPEQ	MAINLOOP_DMODE
	CMP	BYTE PTR DS:[SI],"d"
	JMPEQ	MAINLOOP_DMODE
	CALL	STRDEC
;*;	CMP	DX,91
;*;	JE	MAINLOOP_LOAD
	CMP	DX,92
	JE	MAINLOOP_SAVE
	CMP	DX,93
	JE	MAINLOOP_EDIT
	CMP	DX,94
	JE	MAINLOOP_MOVE
	CMP	DX,95
	JE	MAINLOOP_PNT
	CMP	DX,99
	JMPEQ	MAINLOOP_EXIT
	CMP	DX,0
	JE	MAINLOOP_EDIT

	MOV	CUR_CHIP_NUMBER,DX	; chip number.
	JMP	MAINLOOP_EDIT		;

;*;MAINLOOP_LOAD:
;*;	CALL	SMAPINIT		; map init.
;*;	CALL	SMAPLOAD		; map load.
;*;	CALL	SMAPPUTS		; map put.
;*;	JMP	MAINLOOP_LOOP		;

MAINLOOP_SAVE:
	CALL	SMAPSAVE		; map save.
	JMP	MAINLOOP_LOOP		;

MAINLOOP_EDIT:
	CALL	CLS			; text clear.
	CALL	EDIT_MAIN		; edit main.
	JMP	MAINLOOP_LOOP		;

MAINLOOP_MOVE:
	CALL	CLS			; text clear.
	CALL	MAP_MOVE		; map move.
	JMP	MAINLOOP_LOOP		;

MAINLOOP_DMODE:
	CMP	MOVECHK_FREE,0		; move check free.0=none,1=free
	JNE	MAINLOOP_DMODE2		;
	MOV	MOVECHK_FREE,1		; move check free.0=none,1=free
	JMP	MAINLOOP_LOOP		;
MAINLOOP_DMODE2:			;
	MOV	MOVECHK_FREE,0		; move check free.0=none,1=free
	JMP	MAINLOOP_LOOP		;

MAINLOOP_PNT:
	PR	"NOWXX="
	CALL	INPUT
	CALL	STRDEC
	MOV	NOWXX,DX

	PR	"NOWYY="
	CALL	INPUT
	CALL	STRDEC
	MOV	NOWYY,DX

	CALL	SMAPPUTS		; map put.
	JMP	MAINLOOP_LOOP		;

MAINLOOP_EXIT:
	CALL	SMAPSAVE		; map save.
	RET
MAINLOOP_QUIT:
	RET
MAINLOOP	ENDP


;	main extrun process.
;	-I- BH : function.
;		1=init
;		2=move
;		3=rewrite
;		4="takara"open
;		5="takara"close
;	    CX : direction x.(-1,0,+1)
;	    DX : direction y.(-1,0,+1)
;	-O- BL : status. 1=ok,2=kabe,3=catch,4=end.
;	    BH : place.  1=kinkoh,2=henkyo,3=banchi,4=anzenchitai,5=goal.
;				6=kanban,7=takara.
;	       : ivent   "kanban" number or "takara" number.

MAINEXTRN	PROC	NEAR
	CMP	BH,1			; 1=init
	JE	MAINEXTRN_INIT		;
	CMP	BH,2			; 2=move
	JE	MAINEXTRN_MOVE		;
	CMP	BH,3			; 3=rewrite
	JE	MAINEXTRN_REWRITE	;
	CMP	BH,4			; 4="takara"open
	JE	MAINEXTRN_TAKARA_OPEN	;
	CMP	BH,5			; 5="takara"close
	JE	MAINEXTRN_TAKARA_CLOSE	;

MAINEXTRN_INIT:				;
	CALL	SMAPINIT		; map init.
	CALL	SMAPPUTS		; map put.
	JMP	MAINEXTRN_OK		;

MAINEXTRN_MOVE:				;
;*;	LC	0,15
;*;	PRV	"CX=",CX
;*;	PRV	"DX=",DX
;*;	PRV	"NOWXX=",NOWXX
;*;	PRV	"NOWYY=",NOWYY

	MOV	DIRXX,CX		; direction x.(-1,0,+1)
	MOV	DIRYY,DX		; direction y.(-1,0,+1)

	CALL	SMAPIVNT		; map ivent.
	MOV	BL,DL			; "kanban" number or "takara" number.
	CMP	AX,1			; 1="kanban"
	JE	MAINEXTRN_KANBAN	;
	CMP	AX,2			; 2="takara"
	JE	MAINEXTRN_TAKARA	;

	CALL	SMOTH_MOVE		; smoth move.

	CALL	SMAPCHKS		; map check.
	MOV	BH,AL			; place.
	JMP	MAINEXTRN_OK		;

MAINEXTRN_REWRITE:			;
	CALL	SMAPRWRT		; map rewrite.
	CALL	SMOTH_MOVE		; smoth move.
	CALL	SMAPCHKS		; map check.
	MOV	BH,AL			; place.
	JMP	MAINEXTRN_OK		;

MAINEXTRN_TAKARA_OPEN:			; "takara"open
	MOV	DX,1			; function. 1="takara"open.
	CALL	SMAPIVAC		; map ivent action.
	JMP	MAINEXTRN_OK		;

MAINEXTRN_TAKARA_CLOSE:			; "takara"close
	MOV	DX,2			; function. 2="takara"close.
	CALL	SMAPIVAC		; map ivent action.
	JMP	MAINEXTRN_OK		;

MAINEXTRN_KANBAN:
	MOV	BH,6			; 6=kanban
	RET
MAINEXTRN_TAKARA:
	MOV	BH,7			; 7=takara.
	RET
MAINEXTRN_OK:
	MOV	BL,1			; 1=move.
	RET
MAINEXTRN_KABE:
	MOV	BL,2			; 2=kabe.
	RET
MAINEXTRN_CATCH:
	MOV	BL,3			; 3=catch.
	RET
MAINEXTRN_END:
	MOV	BL,4			; 4=end.
	RET
MAINEXTRN	ENDP


;	edit main.

EDIT_MAIN	PROC	NEAR
EDIT_MAIN_LOOP:
	CALL	MAP_EDIT		; map edit.
	CMP	AX,1			; 1=èIóπ
	JE	EDIT_MAIN_EXIT		;

	CALL	MAP_MOVE		; map move.
;*;	CMP	AX,1			; 1=èIóπ
;*;	JE	EDIT_MAIN_EXIT		;


	JMP	EDIT_MAIN_LOOP		;
EDIT_MAIN_EXIT:
	RET
EDIT_MAIN	ENDP


;	map move.
;	-O- AX : 0=í èÌ,1=èIóπ

MAP_MOVE	PROC	NEAR
	MOV	DIRXX,0			; direction x.(-1,0,+1)
	MOV	DIRYY,0			; direction y.(-1,0,+1)

MAP_MOVE_LOOP:
	MOV	AX,10			;
	CALL	TIMER			; É^ÉCÉ}(V-SYNC timer wait.)

	MOVX	DIRXX,MUSDRX		; mouse locate direction x(+-)
	MOVX	DIRYY,MUSDRY		; mouse locate direction y(+-)

	CALL	MUSREDX			; É}ÉEÉXì«Ç›çûÇ›
	CMP	DL,0			; âEÉ{É^ÉìÅi1ÅFÇnÇeÇeÅ^0ÅFÇnÇmÅj
	JMPEQ	MAP_MOVE_EXIT		;
	CMP	DH,0			; ç∂É{É^ÉìÅi1ÅFÇnÇeÇeÅ^0ÅFÇnÇmÅj
	JNE	MAP_MOVE_2		;
	MOV	DIRXX,0			; mouse locate direction x(+-)
	MOV	DIRYY,0			; mouse locate direction y(+-)
	MOV	MUSDRX,0		; mouse locate direction x(+-)
	MOV	MUSDRY,0		; mouse locate direction y(+-)
MAP_MOVE_2:

;*;
;*;	CALL	MUSREDX			; É}ÉEÉXì«Ç›çûÇ›
;*;	MOV	MOUSE_OLD_X,AX		; mouse old x.
;*;	MOV	MOUSE_OLD_Y,BX		; mouse old y.
;*;
;*;MAP_MOVE_LOOP:
;*;	MOV	AX,10			;
;*;	CALL	TIMER			; É^ÉCÉ}(V-SYNC timer wait.)
;*;
;*;	CALL	MUSREDX			; É}ÉEÉXì«Ç›çûÇ›
;*;	CMP	DH,0			; ç∂É{É^ÉìÅi1ÅFÇnÇeÇeÅ^0ÅFÇnÇmÅj
;*;	JMPEQ	MAP_MOVE_EXIT		;
;*;	CMP	DL,0			; âEÉ{É^ÉìÅi1ÅFÇnÇeÇeÅ^0ÅFÇnÇmÅj
;*;	JMPEQ	MAP_MOVE_QUIT		;
;*;
;*;	MOV	MOUSE_X,AX		; mouse x.
;*;	MOV	MOUSE_Y,BX		; mouse y.
;*;
;*;	CMPX	MOUSE_X,MOUSE_OLD_X	; mouse x.
;*;	JL	MAP_MOVE_X_LOW		;
;*;	JG	MAP_MOVE_X_HI		;
;*;	JMP	MAP_MOVE_X_E		;
;*;MAP_MOVE_X_LOW:				;
;*;	DEC	DIRXX			; direction x.(-1,0,+1)
;*;	JMP	MAP_MOVE_X_E		;
;*;MAP_MOVE_X_HI:				;
;*;	INC	DIRXX			; direction x.(-1,0,+1)
;*;	JMP	MAP_MOVE_X_E		;
;*;MAP_MOVE_X_E:				;
;*;
;*;	CMPX	MOUSE_Y,MOUSE_OLD_Y	; mouse y.
;*;	JL	MAP_MOVE_Y_LOW		;
;*;	JG	MAP_MOVE_Y_HI		;
;*;	JMP	MAP_MOVE_Y_E		;
;*;MAP_MOVE_Y_LOW:				;
;*;	DEC	DIRYY			; direction y.(-1,0,+1)
;*;	JMP	MAP_MOVE_Y_E		;
;*;MAP_MOVE_Y_HI:				;
;*;	INC	DIRYY			; direction y.(-1,0,+1)
;*;	JMP	MAP_MOVE_Y_E		;
;*;MAP_MOVE_Y_E:				;
;*;
;*;
;*;	CMP	DIRXX,-1		; direction x.(-1,0,+1)
;*;	JGE	MAP_MOVE_51		;
;*;	MOV	DIRXX,-1		; direction x.(-1,0,+1)
;*;MAP_MOVE_51:				;
;*;	CMP	DIRXX,+1		; direction x.(-1,0,+1)
;*;	JLE	MAP_MOVE_52		;
;*;	MOV	DIRXX,+1		; direction x.(-1,0,+1)
;*;MAP_MOVE_52:				;
;*;
;*;	CMP	DIRYY,-1		; direction y.(-1,0,+1)
;*;	JGE	MAP_MOVE_53		;
;*;	MOV	DIRYY,-1		; direction y.(-1,0,+1)
;*;MAP_MOVE_53:				;
;*;	CMP	DIRYY,+1		; direction y.(-1,0,+1)
;*;	JLE	MAP_MOVE_54		;
;*;	MOV	DIRYY,+1		; direction y.(-1,0,+1)
;*;MAP_MOVE_54:				;
;*;

	CALL	SMOTH_MOVE		; smoth move.

	LC	52,1
	PRV	"NOWXX:",NOWXX
	LC	52,2
	PRV	"NOWYY:",NOWYY

	JMP	MAP_MOVE_LOOP		;

MAP_MOVE_EXIT:
	MOV	AX,0			; 0=í èÌ
	RET
MAP_MOVE_QUIT:
	MOV	AX,1			; 1=èIóπ
	RET
MAP_MOVE	ENDP


;	smoth move.
;	-I- DIRXX : direction x.(-1,0,+1)
;	    DIRYY : direction y.(-1,0,+1)

SMOTH_MOVE	PROC	NEAR
	CALL	SMAPMOVS		; map move.
SMOTH_MOVE_EXIT:
	RET
SMOTH_MOVE	ENDP


;	map edit.
;	-O- AX : 0=í èÌ,1=èIóπ

MAP_EDIT	PROC	NEAR
	CALL	MUSWATX			; É}ÉEÉXÉ{É^ÉìÇnÇeÇeë“Çø
MAP_EDIT_LOOP:
	CALL	MUSREDX			; É}ÉEÉXì«Ç›çûÇ›
	CMP	DL,0			; âEÉ{É^ÉìÅi1ÅFÇnÇeÇeÅ^0ÅFÇnÇmÅj
	JMPEQ	MAP_EDIT_RIGHT		;

	MOV	MOUSE_X,AX		; mouse x.
	MOV	MOUSE_Y,BX		; mouse y.

	CMP	DH,0			; ç∂É{É^ÉìÅi1ÅFÇnÇeÇeÅ^0ÅFÇnÇmÅj
	JNE	MAP_EDIT_MOVE		;

	MOVX	VIWCHP,CUR_CHIP_NUMBER	; chip number.
	CALL	SMAPPUTC		; map chip put.
	CALL	SMAPPUTS		; map put.

;*;	JMP	MAP_EDIT_NEXT		;
MAP_EDIT_MOVE:
	CALL	MAP_ED_POINT		; map edit point.
MAP_EDIT_NEXT:
	JMP	MAP_EDIT_LOOP		;

MAP_EDIT_RIGHT:				;
	CMP	VIWYY,0			; view y.
	JNE	MAP_EDIT_GET		;

	CMP	VIWXX,0			; view x.
	JE	MAP_EDIT_QUIT		;
	CMP	VIWXX,1			; view x.
	JE	MAP_EDIT_QUIT		;
	JMP	MAP_EDIT_EXIT		;

MAP_EDIT_GET:				;
	CALL	SMAPGETC		; map chip get.
	MOVX	CUR_CHIP_NUMBER,VIWCHP	; chip number.
	JMP	MAP_EDIT_NEXT		;


MAP_EDIT_EXIT:
	CALL	MUSWATX			; É}ÉEÉXÉ{É^ÉìÇnÇeÇeë“Çø
	MOV	AX,0			; 0=í èÌ
	RET
MAP_EDIT_QUIT:
	MOV	AX,1			; 1=èIóπ
	RET
MAP_EDIT	ENDP


;	map edit point.
;	-I- MOUSE_X : mouse x.
;	    MOUSE_Y : mouse y.
;	-O- VIWCHP  : chip number.
;	    VIWXX   : view x.
;	    VIWYY   : view y.

MAP_ED_POINT	PROC	NEAR
	MOV	AX,MOUSE_X		; mouse x.
	MOV	BX,MOUSE_Y		; mouse y.

	SUB	AX,WORLD_LOC_XX		; world location x.
	JGE	MAP_ED_POINT_01		;
	MOV	AX,0			;
MAP_ED_POINT_01:			;
	SUB	BX,WORLD_LOC_YY		; world location y.
	JGE	MAP_ED_POINT_02		;
	MOV	BX,0			;
MAP_ED_POINT_02:			;

	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			; / 8

	SHR	BX,1			;
	SHR	BX,1			;
	SHR	BX,1			; / 8

	CMP	AX,0			;
	JGE	MAP_ED_POINT_11		;
	MOV	AX,0			;
MAP_ED_POINT_11:			;
	CMP	AX,VIWLENXX-1		; view map x.
	JLE	MAP_ED_POINT_12		;
	MOV	AX,VIWLENXX-1		; view map x.
MAP_ED_POINT_12:			;

	CMP	BX,0			;
	JGE	MAP_ED_POINT_21		;
	MOV	BX,0			;
MAP_ED_POINT_21:			;
	CMP	BX,VIWLENYY-1		; view map y.
	JLE	MAP_ED_POINT_22		;
	MOV	BX,VIWLENYY-1		; view map y.
MAP_ED_POINT_22:			;

	MOV	EDIT_VIEW_X,AX		; edit view point x.
	MOV	EDIT_VIEW_Y,BX		; edit view point y.

	MOV	VIWXX,AX		; view x.
	MOV	VIWYY,BX		; view y.
	CALL	SMAPGETC		; map chip get.

	LC	52,5
	PRV	"EDIT_VIEW_X:",EDIT_VIEW_X
	LC	52,6
	PRV	"EDIT_VIEW_Y:",EDIT_VIEW_Y
	LC	52,7
	PRVH	"VIWCHP:",VIWCHP

	CALL	PUT_CURSOLE		; put cursole.

	RET
MAP_ED_POINT	ENDP


;	put cursole.
;	-I- EDIT_VIEW_X : edit view point x.
;	    EDIT_VIEW_Y : edit view point y.

PUT_CURSOLE	PROC	NEAR
	MOV	AX,EDIT_VIEW_X		; edit view point x.
	MOV	BX,EDIT_VIEW_Y		; edit view point y.

	SHL	AX,1			;
	SHL	AX,1			; * 4
	ADD	AX,WORLD_LOC_XX		; world location x.

	SHL	BX,1			; * 2
	ADD	BX,WORLD_LOC_YY/16+1	; world location y.

	PUSH	AX
	PUSH	BX

	MOV	AX,OLD_CUR_X		; old cursole x.
	MOV	BX,OLD_CUR_Y		; old cursole y.
	DEC	BX
	CALL	LOCATE			; locate.
	PR	"    "
	ADD	BX,2
	CALL	LOCATE			; locate.
	PR	"    "

	POP	BX
	POP	AX

	MOV	OLD_CUR_X,AX		; old cursole x.
	MOV	OLD_CUR_Y,BX		; old cursole y.

	DEC	BX
	CALL	LOCATE			; locate.
	PR	"+  +"
	ADD	BX,2
	CALL	LOCATE			; locate.
	PR	"+  +"

	RET
PUT_CURSOLE	ENDP

; ****************************************************
;	DATA
; ****************************************************
	EVEN
EXTRN	MOVECHK_FREE:WORD			; move check free.0=none,1=free

EXTRN	DIRXX:WORD				; direction x.(-1,0,+1)
EXTRN	DIRYY:WORD				; direction y.(-1,0,+1)
EXTRN	VIWXX:WORD				; view x.
EXTRN	VIWYY:WORD				; view y.
EXTRN	VIWCHP:WORD				; view chip EX:WORDRN	

EXTRN	NOWXX:WORD				; big map now location x.
EXTRN	NOWYY:WORD				; big map now location y.

EXTRN		MUSDRX:WORD		; mouse locate direction x(+-)
EXTRN		MUSDRY:WORD		; mouse locate direction y(+-)

CUR_CHIP_NUMBER	DW	1		; chip number.

MOUSE_X		DW	0		; mouse x.
MOUSE_Y		DW	0		; mouse y.

MOUSE_OLD_X	DW	0		; mouse old x.
MOUSE_OLD_Y	DW	0		; mouse old y.

EDIT_VIEW_X	DW	0		; edit view point x.
EDIT_VIEW_Y	DW	0		; edit view point y.

OLD_CUR_X	DW	0		; old cursole x.
OLD_CUR_Y	DW	0		; old cursole y.

CODE	ENDS

	END
;
;	end of "MAINLOOP.ASM"
;
