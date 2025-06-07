; "ADVPLS.ASM" 1989/3/18 R.H
;      modify  1989/12/12 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;
;;;;	INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	DRPLS		;drive number set.
	PUBLIC	SVPLS		;save pless 16 color CRT data.

	EXTRN	DSKOPN:NEAR	; file open.
	EXTRN	DSKCRE:NEAR	; file open & creat.
	EXTRN	DSKCLS:NEAR	; file close.

	EXTRN	DSKDR:NEAR	; drive number set.

	EXTRN	DSKRED:NEAR	; load 1 byte data.
	EXTRN	DSKWRT:NEAR	; save 1 byte data.

	EXTRN	DSKLD:NEAR	; load data.
	EXTRN	DSKSV:NEAR	; save data.

PLEAN_MAX	EQU	4	; vram plean number.


; drive number set.
; -i- AX : drive number. 0:cullent 1:A 2:B ....

DRPLS	PROC	NEAR
	CALL	DSKDR		; drive number set.
	RET
DRPLS	ENDP


;*NON*;; load pless 16 color CRT data.
;*NON*;; -i- SI : file name.
;*NON*;;          NULL = end of string.
;*NON*;;
;*NON*;
;*NON*;LDPLS	PROC	NEAR
;*NON*;	PUSH	SI
;*NON*;
;*NON*;	CALL	PLS_FLNSET	; 画面圧縮ファイル名セット
;*NON*;
;*NON*;	MOV	SI,OFFSET FPSNAM ; ファイル名
;*NON*;	CALL	FLPLSOPEN	; file open.
;*NON*;
;*NON*;	CMP	AX,1		; if open error then exit.
;*NON*;	JE	LDPLS9		;
;*NON*;
;*NON*;	CALL	LDPLSDSPLY	; data read & convert.
;*NON*;
;*NON*;	CALL	FLPLSCLOSE	; file close.
;*NON*;LDPLS9:
;*NON*;	POP	SI
;*NON*;	RET
;*NON*;LDPLS	ENDP
;*NON*;
;*NON*;;	file read & convert.
;*NON*;;
;*NON*;
;*NON*;LDPLSDSPLY	PROC	NEAR
;*NON*;	CALL	VRMINI		; vram access init.
;*NON*;
;*NON*;LDPLSDSPLY0:
;*NON*;	CALL	LDPLSREAD	; <<data attrbute>>
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSPLY9	;
;*NON*;
;*NON*;LDPLSDSPLY1:
;*NON*;	CMP	AL,01		; if 01 then non pless.
;*NON*;	JNZ	LDPLSDSPLY2	;
;*NON*;
;*NON*;	CALL	LDPLSDSP1
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSPLY9	;
;*NON*;
;*NON*;	JMP	LDPLSDSPLY55
;*NON*;
;*NON*;LDPLSDSPLY2:
;*NON*;	CMP	AL,02		; if 02 then 0 data.
;*NON*;	JNZ	LDPLSDSPLY3	;
;*NON*;
;*NON*;	CALL	LDPLSDSP2
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSPLY9	;
;*NON*;
;*NON*;	JMP	LDPLSDSPLY55
;*NON*;
;*NON*;LDPLSDSPLY3:
;*NON*;	CMP	AL,03		; if 03 then same data.
;*NON*;	JNZ	LDPLSDSPLY4	;
;*NON*;
;*NON*;	CALL	LDPLSDSP3
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSPLY9	;
;*NON*;
;*NON*;	JMP	LDPLSDSPLY55
;*NON*;
;*NON*;LDPLSDSPLY4:
;*NON*;	CMP	AL,00		; if 00 then exit.
;*NON*;	JE	LDPLSDSPLY9	;
;*NON*;
;*NON*;	JMP	LDPLSDSPLY9	; else exit.
;*NON*;
;*NON*;LDPLSDSPLY55:
;*NON*;	JMP	LDPLSDSPLY0	; loop end.
;*NON*;
;*NON*;LDPLSDSPLY9:
;*NON*;	RET
;*NON*;LDPLSDSPLY	ENDP
;*NON*;
;*NON*;
;*NON*;;	non pless data. = 01h
;*NON*;
;*NON*;LDPLSDSP1	PROC	NEAR
;*NON*;	CALL	LDPLSREAD	; <<data length>>
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSP19	;
;*NON*;
;*NON*;	MOV	CX,0
;*NON*;	MOV	CL,AL
;*NON*;LDPLSDSP11:
;*NON*;	CALL	LDPLSREAD	; <<image data>>
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSP19	;
;*NON*;	CALL	VRAMPUT		;
;*NON*;	LOOP	LDPLSDSP11	;
;*NON*;
;*NON*;	MOV	AH,0		; normal.
;*NON*;	RET
;*NON*;LDPLSDSP19:
;*NON*;	MOV	AH,1		; E.O.F
;*NON*;	RET
;*NON*;LDPLSDSP1	ENDP
;*NON*;
;*NON*;
;*NON*;;	zero data. = 02h
;*NON*;
;*NON*;LDPLSDSP2	PROC	NEAR
;*NON*;	CALL	LDPLSREAD	; <<data length>>
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSP29	;
;*NON*;
;*NON*;	MOV	CX,0
;*NON*;	MOV	CL,AL
;*NON*;	MOV	AL,0		; data=0;
;*NON*;LDPLSDSP21:
;*NON*;	CALL	VRAMPUT		;
;*NON*;	LOOP	LDPLSDSP21	;
;*NON*;
;*NON*;	MOV	AH,0		; normal.
;*NON*;	RET
;*NON*;LDPLSDSP29:
;*NON*;	MOV	AH,1		; E.O.F
;*NON*;	RET
;*NON*;LDPLSDSP2	ENDP
;*NON*;
;*NON*;
;*NON*;;	same data. = 03h
;*NON*;
;*NON*;LDPLSDSP3	PROC	NEAR
;*NON*;	CALL	LDPLSREAD	; <<data length>>
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSP39	;
;*NON*;
;*NON*;	MOV	CX,0		;
;*NON*;	MOV	CL,AL		; loop counter
;*NON*;
;*NON*;	CALL	LDPLSREAD	; <<image data>>
;*NON*;	CMP	AH,0		; if E.O.F then exit.
;*NON*;	JNZ	LDPLSDSP39	;
;*NON*;LDPLSDSP31:
;*NON*;	CALL	VRAMPUT		;
;*NON*;	LOOP	LDPLSDSP31	;
;*NON*;
;*NON*;	MOV	AH,0		; normal.
;*NON*;	RET
;*NON*;LDPLSDSP39:
;*NON*;	MOV	AH,1		; E.O.F
;*NON*;	RET
;*NON*;LDPLSDSP3	ENDP
;*NON*;
;*NON*;

;	file open.
; -i- SI : file name.
;          NULL = end of string.
; -o- AX : 0:normal.
;	   1:open error.

FLPLSOPEN	PROC	NEAR
	CALL	DSKOPN		; file open.
	RET
FLPLSOPEN	ENDP

;	file open & creat.
; -i- SI : file name.
;          NULL = end of string.
; -o- AX : 0:normal.
;	   1:open error.

FLPLSCREAT	PROC	NEAR
	CALL	DSKCRE		; file open & creat.
	RET
FLPLSCREAT	ENDP


;	file read 1 byte data.
;
;	-O- AL : 1 byte data
;	    AH : 0:normal  1:E.O.F

LDPLSREAD	PROC
	CALL	DSKRED		; load 1 byte data.
	RET
LDPLSREAD	ENDP

;	file close.
;

FLPLSCLOSE	PROC
	CALL	DSKCLS		; file close.
	RET
FLPLSCLOSE	ENDP




; save pless 16 color CRT data.
; -i- SI : file name.
;          NULL = end of string.
; -o- DX : save byte count hi.(dabule word counter)
;     AX : save byte count low.(dabule word counter)
;     CX : save paragraph count.

SVPLS	PROC	NEAR
	PUSH	SI

	MOV	WORD PTR SAVCNT,0    ; save byte count.(dabule word counter)
	MOV	WORD PTR SAVCNT[2],0 ; save byte count.(dabule word counter)

	CALL	PLS_FLNSET	; 画面圧縮ファイル名セット

	MOV	SI,OFFSET FPSNAM ; ファイル名
	CALL	FLPLSCREAT	; file open.

	CMP	AX,1		; if open error then exit.
	JE	SVPLS9		;

	CALL	SVPLSDSPLY	; data convert & save.

	CMP	AH,1		; write error.
	JE	SVPLS8

SVPLS8:
	CALL	FLPLSCLOSE	; file close.
SVPLS9:
	MOV	AX,WORD PTR SAVCNT    ; save byte count.(dabule word counter)
	MOV	DX,WORD PTR SAVCNT[2] ; save byte count.(dabule word counter)
	MOV	CX,WORD PTR SAVCNT    ; save byte count.(dabule word counter)
	MOV	BX,WORD PTR SAVCNT[2] ; save byte count.(dabule word counter)
	RCR	BX,1
	RCR	CX,1
	RCR	BX,1
	RCR	CX,1
	RCR	BX,1
	RCR	CX,1
	RCR	BX,1
	RCR	CX,1	; save paragraph count.(dabule word counter)
	POP	SI
	RET
SVPLS	ENDP

;	file read & convert.
;
;	-o- AH: 0 or 2 : normal end. 1:write error.

SVPLSDSPLY	PROC	NEAR
	CALL	VRMINI		; vram access init.

SVPLSDSPLY0:
	CALL	SVPLSCHK	; data analize.

	CMP	AH,0
	JE	SVPLSDSPLY1	; data end  or  write error.

	RET

SVPLSDSPLY1:
	CMP	AL,01		; if 01 then non pless.
	JNZ	SVPLSDSPLY2	;

	CALL	SVPLSDSP1	; non pless data.
	CMP	AH,0		; if write_error or end then exit.
	JNZ	SVPLSDSPLY9	;

	JMP	SVPLSDSPLY55

SVPLSDSPLY2:
	CMP	AL,02		; if 02 then 0 data.
	JNZ	SVPLSDSPLY3	;

	CALL	SVPLSDSP2	; same data.=zero
	CMP	AH,0		; if write_error or end then exit.
	JNZ	SVPLSDSPLY9	;

	JMP	SVPLSDSPLY55

SVPLSDSPLY3:
	CMP	AL,03		; if 03 then same data.
	JNZ	SVPLSDSPLY4	;

	CALL	SVPLSDSP3	; same data.
	CMP	AH,0		; if write_error or end then exit.
	JNZ	SVPLSDSPLY9	;

	JMP	SVPLSDSPLY55

SVPLSDSPLY4:
	CMP	AL,00		; if 00 then exit.
	JE	SVPLSDSPLY9	;

	JMP	SVPLSDSPLY9	; else exit.

SVPLSDSPLY55:
	JMP	SVPLSDSPLY0	; loop end.

SVPLSDSPLY9:
	RET
SVPLSDSPLY	ENDP


;	non pless data. = 01h

SVPLSDSP1	PROC

	MOV	WORD PTR DTLEN,0	; data length.

	MOV	AL,01H		; <<non pless data>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JNE	SVPLSDSP10	;
	JMP	SVPLSDSP199	;
SVPLSDSP10:
	MOV	CX,3			; for i=1 to 3
SVPLSDSP11:				;
	CALL	SVPLSDSP1PNT		; pointer save.
	CALL	VRAMGET			; vram 1byte get.
	CMP	AH,0			;
	JNZ	SVPLSDSP18		; data end.
	MOV	BX,WORD PTR DTLEN	;
	MOV	BYTE PTR DS:BUF0[BX],AL	; buf0[dtlen++] <- al
	INC	BYTE PTR DTLEN		;
	LOOP	SVPLSDSP11		; next

SVPLSDSP12:
	CALL	SVPLSDSP1PNT		; pointer save.
	CALL	VRAMGET			; vram 1byte get.
	CMP	AH,0			;
	JNZ	SVPLSDSP18		; data end.
	MOV	BX,WORD PTR DTLEN	;
	MOV	BYTE PTR DS:BUF0[BX],AL	; buf0[dtlen++] <- al
	INC	BYTE PTR DTLEN		;

	CALL	SVPLSDSP1CHK		; same check.
	CMP	AH,1			;
	JNE	SVPLSDSP13		; if 1 then end image data.

	CALL	SVPLSDSP1BAK		; back pointer.
	SUB	BYTE PTR DTLEN,3	;
	JMP	SVPLSDSP17		; normal end.

SVPLSDSP13:
	CMP	BYTE PTR DTLEN,255	;
	JE	SVPLSDSP17		; normal end.

	JMP	SVPLSDSP12		; loop end.

SVPLSDSP17:			;			normal end.
	MOV	AL,BYTE PTR DTLEN	; <<data length>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP199	;

	MOV	CX,DTLEN	;
	MOV	BX,0		; <<data write>>
SVPLSDSP171:			;
	MOV	AL,DS:BUF0[BX]	;
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP199	;
	INC	BX		;
	LOOP	SVPLSDSP171	;	

	MOV	AH,0		; normal.
	CALL	DUMP	;+++++++++++++++++++++++++++++++++++++++++
	RET

SVPLSDSP18:			;			E.O.F
	MOV	AL,BYTE PTR DTLEN	; <<data length>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP199	;

	MOV	CX,DTLEN	;
	MOV	BX,0		; <<data write>>
SVPLSDSP181:			;
	MOV	AL,DS:BUF0[BX]	;
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP199	;
	INC	BX		;
	LOOP	SVPLSDSP181	;	

	MOV	AL,00H		; <<E.O.F>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP199	;

	MOV	AH,2		; end of data.
	RET

SVPLSDSP199:
	MOV	AH,1		; write error.
	RET

SVPLSDSP1CHK:			; same check.
	DEC	BX
	CMP	AL,DS:BUF0[BX]
	JNE	SVPLSDSP1CHK9
	DEC	BX
	CMP	AL,DS:BUF0[BX]
	JNE	SVPLSDSP1CHK9
	MOV	AH,1		; check!
	RET
SVPLSDSP1CHK9:
	MOV	AH,0		; normal.
	RET

SVPLSDSP1BAK:
	MOV	AX,VRPLNBAK[4]
	MOV	VRPLN,AX
	MOV	AX,VROFSTBAK[4]
	MOV	VROFST,AX
	RET

SVPLSDSP1PNT:
	MOV	AX,VRPLNBAK[2]
	MOV	VRPLNBAK[4],AX

	MOV	AX,VRPLNBAK[0]
	MOV	VRPLNBAK[2],AX

	MOV	AX,VRPLN
	MOV	VRPLNBAK[0],AX

	MOV	AX,VROFSTBAK[2]
	MOV	VROFSTBAK[4],AX

	MOV	AX,VROFSTBAK[0]
	MOV	VROFSTBAK[2],AX

	MOV	AX,VROFST
	MOV	VROFSTBAK[0],AX
	RET
SVPLSDSP1	ENDP


DUMP	PROC	NEAR
;	PUSH	AX
;	PRV	"AX=",AX
;	PRV	"DTLEN=",DTLEN
;	PRV	"BPOINT=",BPOINT
;	PRV	"VRPLN      =",VRPLN
;	CALL	KESCAP
;	POP	AX
	RET
DUMP	ENDP


;	zero data. = 02h

SVPLSDSP2	PROC	NEAR

	MOV	BYTE PTR DTLEN,0	; data length.
	MOV	BYTE PTR DTIMG,0	; data image.=0

	MOV	AL,02H		; <<non pless data>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP299	;

SVPLSDSP21:
	MOV	BX,VRPLN	; save pointer.
	MOV	VRPLNBAK,BX	;
				;
	MOV	BX,VROFST	;
	MOV	VROFSTBAK,BX	;

	CALL	VRAMGET		; vram 1byte get.
	CMP	AH,0		;
	JNZ	SVPLSDSP28	; data end.

	CMP	AL,BYTE PTR DTIMG	; same data end.
	JNE	SVPLSDSP26	;

	INC	BYTE PTR DTLEN	; data length inc.

	CMP	BYTE PTR DTLEN,255
	JE	SVPLSDSP27	; max length.

	JMP	SVPLSDSP21	; loop end

SVPLSDSP26:
	MOV	BX,VRPLNBAK	; return back pointer.(1 byte)
	MOV	VRPLN,BX	;
				;
	MOV	BX,VROFSTBAK	;
	MOV	VROFST,BX	;

SVPLSDSP27:
	MOV	AL,BYTE PTR DTLEN	; <<data length>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP299	;

	MOV	AH,0		; normal.
	RET

SVPLSDSP28:
	MOV	AL,BYTE PTR DTLEN	; <<data length>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP299	;

	MOV	AL,00H		; <<E.O.F>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP299	;

	MOV	AH,2		; end of data.
	RET

SVPLSDSP299:
	MOV	AH,1		; write error.
	RET
SVPLSDSP2	ENDP


;	same data. = 03h

SVPLSDSP3	PROC	NEAR

	MOV	BYTE PTR DTLEN,0	; data length.
	MOV	BYTE PTR DTIMG,0	; same data image.

	MOV	AL,03H		; <<non pless data>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JNE	SVPLSDSP30	;
	JMP	SVPLSDSP399
SVPLSDSP30:
	CALL	VRAMGET		; vram 1byte get.
	CMP	AH,0		;
	JNZ	SVPLSDSP38	; data end.
	MOV	BYTE PTR DTIMG,AL	; image data.
	INC	BYTE PTR DTLEN	;
SVPLSDSP31:
	MOV	BX,VRPLN	; pointer save.
	MOV	VRPLNBAK,BX	;
				;
	MOV	BX,VROFST	;
	MOV	VROFSTBAK,BX	;

	CALL	VRAMGET		; vram 1byte get.
	CMP	AH,0		;
	JNZ	SVPLSDSP38	; data end.

	CMP	AL,BYTE PTR DTIMG	; same data end.
	JNE	SVPLSDSP36	;

	INC	BYTE PTR DTLEN	; data length inc.

	CMP	BYTE PTR DTLEN,255
	JE	SVPLSDSP37	; max length.

	JMP	SVPLSDSP31	; loop end.

SVPLSDSP36:
	MOV	BX,VRPLNBAK	; return back point.
	MOV	VRPLN,BX	;
				;
	MOV	BX,VROFSTBAK	;
	MOV	VROFST,BX	;

SVPLSDSP37:
	MOV	AL,BYTE PTR DTLEN	; <<data length>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP399	;

	MOV	AL,BYTE PTR DTIMG	; <<image data>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP399	;

	MOV	AH,0		; normal.
	RET

SVPLSDSP38:
	MOV	AL,BYTE PTR DTLEN	; <<data length>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP399	;

	MOV	AL,BYTE PTR DTIMG	; <<image data>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP399	;

	MOV	AL,00H		; <<E.O.F>>
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSDSP399	;

	MOV	AH,2		; end of data.
	RET

SVPLSDSP399:
	MOV	AH,1		; write error.
	RET
SVPLSDSP3	ENDP



;	data analize.
;	-O- AL : data type. 00:data end   01:non pless data
;			    02:zero data  03:same data
;	    AH : 0:normal 1:write error 2:data end

SVPLSCHK	PROC	NEAR

	MOV	BX,VRPLN		;
	MOV	VRPLNBAK,BX		;
					;
	MOV	BX,VROFST		;
	MOV	VROFSTBAK,BX		;

	CALL	VRAMGET		; vram 1byte get.
	CMP	AH,0		;
	JE	SVPLSCHK1	;
	JMP	SVPLSCHK99	; data end.
SVPLSCHK1:
	MOV	BUF1,AL

	CALL	VRAMGET
	CMP	AH,0
	JE	SVPLSCHK11
	JMP	SVPLSCHK98	; data end.
SVPLSCHK11:
	MOV	BUF2,AL
	
	CALL	VRAMGET
	CMP	AH,0
	JNZ	SVPLSCHK97	; data end.

	MOV	BUF3,AL

	MOV	BH,BYTE PTR BUF1	; if buf1=buf2=buf3 then
	CMP	BH,BYTE PTR BUF2	;
	JNE	SVPLSCHK2		;
	CMP	BH,BYTE PTR BUF3	;
	JNE	SVPLSCHK2		;
	JMP	SVPLSCHK66		;
SVPLSCHK2:
	MOV	AL,01H		; non pless data.
	JMP	SVPLSCHK9

SVPLSCHK66:
	CMP	BYTE PTR BUF1,0
	JE	SVPLSCHK67

	MOV	AL,03H		; same data.
	JMP	SVPLSCHK9

SVPLSCHK67:
	MOV	AL,02H		; zero data.
SVPLSCHK9:
	MOV	BX,VRPLNBAK
	MOV	VRPLN,BX

	MOV	BX,VROFSTBAK
	MOV	VROFST,BX

	MOV	AH,0		; normal.
	RET

SVPLSCHK96:
	MOV	AL,01H		; non pless.
	CALL	SVPLSWRITE
	CMP	AH,1
	JNE	SVPLSCHK961
	JMP	SVPLSCHK999
SVPLSCHK961:

	MOV	AL,3		; length.
	CALL	SVPLSWRITE
	CMP	AH,1
	JNE	SVPLSCHK962
	JMP	SVPLSCHK999
SVPLSCHK962:

	MOV	AL,BUF1
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	MOV	AL,BUF2
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	MOV	AL,BUF3
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	JMP	SVPLSCHK99
SVPLSCHK97:
	MOV	AL,01H		; non pless.
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	MOV	AL,2		; length.
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	MOV	AL,BUF1
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	MOV	AL,BUF2
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	JMP	SVPLSCHK99
SVPLSCHK98:
	MOV	AL,01H		; non pless.
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	MOV	AL,1		; length.
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999

	MOV	AL,BUF1
	CALL	SVPLSWRITE
	CMP	AH,1
	JE	SVPLSCHK999
	JMP	SVPLSCHK99

SVPLSCHK99:
	MOV	AL,00H		; E.O.F
	CALL	SVPLSWRITE	;
	CMP	AH,1		;
	JE	SVPLSCHK999	;

	MOV	AL,2		; end of data.
	RET

SVPLSCHK999:
	MOV	AL,1		; write error.
	RET

SVPLSCHK	ENDP


;	file write 1 byte data.
;
;	-I- AL : 1 byte data
;	-O- AH : 0:normal  1:write error
;	-I/O- SAVCNT : save byte count.(dabule word counter)

SVPLSWRITE	PROC
	PUSH	BX
	PUSH 	CX

	CALL	DSKWRT		; save 1 byte data.

	ADD	WORD PTR SAVCNT,1    ; save byte count.(dabule word counter)
	ADC	WORD PTR SAVCNT[2],0 ; save byte count.(dabule word counter)

	POP	CX
	POP	BX
	RET
SVPLSWRITE	ENDP



; 1 byte vram set.
; -i- AL : 1 byte data.

VRAMPUT	PROC	NEAR
	PUSH	BX
	PUSH	CX

	MOV	BX,VRPLN		; vram plean number.
	SHL	BX,1
	MOV	DX,DS:ARASEG[BX]	; ES <- vram segment.
	MOV	ES,DX			;

	MOV	DI,VROFST		; vram offset.
	MOV	ES:[DI],AL		; AL -> vram

	INC	WORD PTR VROFST		;

	CMP	WORD PTR VROFST,80*400	; if vrofst=vram_size then
	JL	VRAMPUT9		;

	INC	WORD PTR VRPLN		; inc vram plean.
	MOV	WORD PTR VROFST,0	; vrofst = 0
VRAMPUT9:

	POP	CX
	POP	BX
	RET
VRAMPUT	ENDP


; get 1 byte vram.
; -o- AL : 1 byte data.
;     AH : 0:normal 1:data end.


VRAMGET	PROC	NEAR
	PUSH	BX
	PUSH	CX

	CMP	WORD PTR VRPLN,PLEAN_MAX	; vram plean number.
	JL	VRAMGET1

	MOV	AH,1			; data end.
	POP	CX
	POP	BX
	RET
VRAMGET1:
	MOV	BX,VRPLN		; vram plean number.
	SHL	BX,1
	MOV	DX,DS:ARASEG[BX]	; ES <- vram segment.
	MOV	ES,DX			;

	MOV	DI,VROFST		; vram offset.
	MOV	AL,ES:[DI]		; AL -> vram

	INC	WORD PTR VROFST		;

	CMP	WORD PTR VROFST,80*400	; if vrofst=vram_size then
	JL	VRAMGET9		;

	INC	WORD PTR VRPLN		; inc vram plean.
	MOV	WORD PTR VROFST,0	; vrofst = 0
VRAMGET9:
	MOV	AH,0			; normal.

	POP	CX
	POP	BX
	RET
VRAMGET	ENDP


; vram access init.

VRMINI	PROC	NEAR

	MOV	AX,SSGR0	; visual data segment plean 0
	MOV	WORD PTR DS:ARASEG[0],AX

	MOV	AX,SSGR1	; visual data segment plean 1
	MOV	WORD PTR DS:ARASEG[2],AX

	MOV	AX,SSGR2	; visual data segment plean 2
	MOV	WORD PTR DS:ARASEG[4],AX

	MOV	AX,SSGR3	; visual data segment plean 3
	MOV	WORD PTR DS:ARASEG[6],AX

	MOV	WORD PTR VRPLN,0	; vram plean.
	MOV	WORD PTR VROFST,0	; vram offset.

	RET
VRMINI	ENDP


;	画面圧縮ファイル名セット
;	-I- DS:SI : ファイル名

PLS_FLNSET	PROC	NEAR
	PUSH	SI

	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET FPSNAM	; ファイル名クリア
	MOV	CX,8
	MOV	AL,' '
	REP	STOSB

	MOV	DI,OFFSET FPSNAM	; ファイル名
	MOV	CX,8
PLS_FLNSET2:
	LODSB
	CMP	AL,' '			; end of string.
	JB	PLS_FLNSET3		;
	STOSB
	LOOP	PLS_FLNSET2
PLS_FLNSET3:
	POP	SI
	RET
PLS_FLNSET	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3
	EVEN

FPSNAM	DB	"        PLS",0	; ファイル名

SAVCNT	DD	0		; save byte count.(dabule word counter)

ARASEG	DW	0,0,0,0		; segment table.

BPOINT	DW	0		; file buffer point.

VRPLN	DW	0		; vram segment.
VROFST	DW	0		; vram offset.

VRPLNBAK	DW	3 DUP (0)	; vram segment back.
VROFSTBAK	DW	3 DUP (0)	; vram offset back.

BUF0	LABEL	BYTE		;
BUF1	DB	0		; check buffer.
BUF2	DB	0		;
BUF3	DB	0		;
BUF4	DB	0		;
BUF5	DB	252 DUP (0)	;
	EVEN
DTLEN	DW	0		; data length.
DTIMG	DW	0		; data image.

DATA	ENDS

	END
;
;	end of "ADVPLS.ASM"
;
