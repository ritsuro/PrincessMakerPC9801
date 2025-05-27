; "DATPL3A.ASM" PC-9801UV11 make by R.H 1990/05/10
;
;	バイナリデータ圧縮
;
;	バイナリデータ（ＶＲＡＭに依存しないデータ）作成のために
;	ＤＡＴＰＬＳを改造したものです。
;
;	ＤＡＴＰＬ３．ＡＳＭの高圧縮版
;
;	先に読んだデータと同じパターンを検索して、繰り返しＩＤに
;	置き換える。
;
;
; public subroutine.
;


INCLUDE	TSTSET.INC


CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	BUNPLE		; 圧縮フォーマットデータ復元
;*NON*;	PUBLIC	BPLESS		; バイナリデータ圧縮


;	圧縮フォーマットデータ復元
;	-I- BPNTOF  : データバッファポインタ
;	    BPNTSG  : データバッファセグメント
;	    ES:DI   : 展開データアドレス
;	-O- ES:[DI] : 展開データ

BUNPLE	PROC	NEAR
	MOV	AX,BPNTSG		;
	MOV	BX,BPNTOF		;
	MOV	GETSEG,AX		; get buffer segment.
	MOV	GETSTART,BX		; get start address.

	MOV	PUTSEG,ES		; put buffer segment.
	MOV	PUTSTART,DI		; put start address.

	CALL	UNPLESS			; data unpless.

	RET
BUNPLE	ENDP




END_OF_DATA	EQU	0	; ＥＮＤ	データ終り
ID_COPY		EQU	8000H	; ＣＯＰＹ	展開済みデータのコピー(bit15)
MASK_LENGTH	EQU	7FFFH	; ＬＥＮＧＴＨマスク

COPY_LENGTH	EQU	6	; ＣＯＰＹデータの下限


;	data unpless.
;	-I- GETSEG   : get buffer segment.
;	    GETSTART : get start address.
;	    PUTSEG   : put buffer segment.
;	    PUTSTART : put start address.
;	-O- PUTSEG:[PUTSTART] : pless data.
;	    GETPOINT : get address.
;	    PUTPOINT : put address.

UNPLESS	PROC	NEAR
	PUSH	DS

	MOV	DI,PUTSTART		; put start address.
	MOV	AX,PUTSEG		; put buffer segment.
	MOV	ES,AX			;

	MOV	SI,GETSTART		; get start address.
	MOV	AX,GETSEG		; get buffer segment.
	MOV	DS,AX			;

UNPLESS_LOOP:
	LODSW

	CMP	AX,END_OF_DATA		; [ END ]
	JE	UNPLESS_EXIT		;

	TEST	AX,ID_COPY		; [ COPY ]
	JNZ	UNPLESS_COPY		;

UNPLESS_IMAGE:				; [ IMAGE ]
	MOV	CX,AX			; [ image length ]
	REP	MOVSW			; move [ image ]
	JMP	UNPLESS_LOOP		;

UNPLESS_COPY:				; [ COPY ]
	MOV	CX,AX			; [ string length ]
	AND	CX,MASK_LENGTH		; length mask.

	LODSW				; [ string address ]

	MOV	DX,DS			; save DS.
	MOV	BP,SI			; save SI.

	MOV	SI,DI			;
	SUB	SI,AX			; copy source.

	MOV	AX,ES			;
	MOV	DS,AX			;
	REP	MOVSW			; copy string.

	MOV	DS,DX			; load DS.
	MOV	SI,BP			; load SI.
	JMP	UNPLESS_LOOP

UNPLESS_EXIT:
	POP	DS
	RET
UNPLESS	ENDP




;*NON*;;	バイナリデータ圧縮
;*NON*;;	-I- DX:[SI]: バイナリデータ
;*NON*;;	    CX     : データ長さ
;*NON*;;	    BPNTOF : データバッファポインタ
;*NON*;;	    BPNTSG : データバッファセグメント
;*NON*;;	    BCNTMX : データ最大長さ
;*NON*;;	-O- BCOUNT ; データ長さ
;*NON*;;	    BPOINT ; データ終わりアドレス＋１
;*NON*;;	    AH     : 0 or 2 : normal end. 1:write error.
;*NON*;
;*NON*;BPLESS	PROC	NEAR
;*NON*;	MOV	GETSEG,DX		; get buffer segment.
;*NON*;	MOV	GETSTART,SI		; get start address.
;*NON*;	MOV	GETPOINT,SI		; get pointer.
;*NON*;	ADD	SI,CX			;
;*NON*;	MOV	GETEND,SI		; get end address.
;*NON*;
;*NON*;
;*NON*;	MOV	AX,BPNTSG		;
;*NON*;	MOV	PUTSEG,AX		; put buffer segment.
;*NON*;	MOV	AX,BPNTOF		;
;*NON*;	MOV	PUTSTART,AX		; put start address.
;*NON*;	MOV	PUTPOINT,AX		; put pointer.
;*NON*;	ADD	AX,BCNTMX		;
;*NON*;	MOV	PUTEND,AX		; put end address.
;*NON*;
;*NON*;	PRF	"圧縮中 PLESSING"
;*NON*;
;*NON*;	CALL	PLESSING		; data pless.
;*NON*;
;*NON*;
;*NON*;	MOV	CX,GETPOINT		; get pointer.
;*NON*;	SUB	CX,GETSTART		; get start address.
;*NON*;
;*NON*;	MOV	AX,PUTPOINT		; put address.
;*NON*;	SUB	AX,PUTSTART		; put start address.
;*NON*;	MOV	BX,100			;
;*NON*;	MUL	BX			; AX = AX * 100 / CX
;*NON*;	DIV	CX			; percent = ( odata * 100 ) / idata
;*NON*;
;*NON*;	PRV	"%>",AX
;*NON*;
;*NON*;	MOV	AX,PUTPOINT		; put address.
;*NON*;	SUB	AX,PUTSTART		; put start address.
;*NON*;	MOV	BCOUNT,AX		; データ長さ
;*NON*;
;*NON*;	MOV	AX,PUTPOINT		; put address.
;*NON*;	MOV	BPOINT,AX		; データ終わりアドレス＋１
;*NON*;
;*NON*;	MOV	AH,0			; 0 or 2 : normal end. 1:write error.
;*NON*;	RET
;*NON*;BPLESS	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;
;*NON*;;	data pless.
;*NON*;;	-I- GETSEG   : get buffer segment.
;*NON*;;	    GETSTART : get start address.
;*NON*;;	    GETEND   : get end address.
;*NON*;;	    GETPOINT : get pointer.
;*NON*;;	    PUTSEG   : put buffer segment.
;*NON*;;	    PUTSTART : put start address.
;*NON*;;	    PUTEND   : put end address.
;*NON*;;	    PUTPOINT : put pointer.
;*NON*;;	-O- PUTSEG:[PUTSTART] : pless data.
;*NON*;;	    GETPOINT : get address.
;*NON*;;	    PUTPOINT : put address.
;*NON*;
;*NON*;PLESSING	PROC	NEAR
;*NON*;	MOV	FLAG_IMAGE_PUT,0	; IMAGE put flag
;*NON*;
;*NON*;	JMP	PLESSING_IMAGE		; start IMAGE
;*NON*;
;*NON*;PLESSING_LOOP:
;*NON*;	CALL	ENDCHECK		; end check.
;*NON*;
;*NON*;	CMP	AX,1			; 1=data end.
;*NON*;	JE	PLESSING_END		;
;*NON*;
;*NON*;	CALL	STRING_REP_COMPER	; string repart comper.
;*NON*;
;*NON*;	CMP	STRLENGTH,COPY_LENGTH	; under COPY length.
;*NON*;	JNB	PLESSING_COPY		;
;*NON*;
;*NON*;	JMP	PLESSING_IMAGE		;
;*NON*;
;*NON*;PLESSING_END:				;
;*NON*;	PR	"END:"
;*NON*;	CALL	SETFORM_IMAGE		; set header IMAGE.
;*NON*;	CALL	SETFORM_END		; set header END.
;*NON*;	JMP	PLESSING_EXIT		;
;*NON*;
;*NON*;PLESSING_IMAGE:				;
;*NON*;	CMP	FLAG_IMAGE_PUT,1	; IMAGE put flag.
;*NON*;	JE	PLESSING_IMAGE2		;
;*NON*;	MOV	FLAG_IMAGE_PUT,1	; IMAGE put flag.
;*NON*;
;*NON*;	MOV	AX,GETPOINT		; get pointer.
;*NON*;	MOV	IMAGE_DATADRS,AX	; IMAGE data address.
;*NON*;	MOV	IMAGE_LENG,0		; IMAGE word length.
;*NON*;PLESSING_IMAGE2:			;
;*NON*;	INC	IMAGE_LENG		; IMAGE word length.
;*NON*;	INC	GETPOINT		; get pointer.
;*NON*;	INC	GETPOINT		; get pointer.
;*NON*;
;*NON*;	JMP	PLESSING_NEXT		;
;*NON*;
;*NON*;PLESSING_COPY:				;
;*NON*;	LC	58,0
;*NON*;	PRV	"string length. :",STRLENGTH
;*NON*;	LC	58,1
;*NON*;	PRV	"string address.:",STRADDRESS
;*NON*;	LC	58,2
;*NON*;	PRV	"get pointer.   :",GETPOINT
;*NON*;	LC	0,24
;*NON*;
;*NON*;	CALL	SETFORM_IMAGE		; set header IMAGE.
;*NON*;	CALL	SETFORM_COPY		; set header COPY.
;*NON*;
;*NON*;	JMP	PLESSING_NEXT		;
;*NON*;
;*NON*;PLESSING_NEXT:				;
;*NON*;	JMP	PLESSING_LOOP		;
;*NON*;
;*NON*;PLESSING_EXIT:
;*NON*;	RET
;*NON*;PLESSING	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;
;*NON*;;	set header END.
;*NON*;;	-I-   PUTSEG   : put buffer segment.
;*NON*;;	-I/O- PUTPOINT : put pointer.
;*NON*;
;*NON*;SETFORM_END	PROC	NEAR
;*NON*;	MOV	AX,PUTSEG		; put buffer segment.
;*NON*;	MOV	ES,AX			;
;*NON*;	MOV	DI,PUTPOINT		; put address.
;*NON*;
;*NON*;	MOV	AX,END_OF_DATA		; [ END ]
;*NON*;	STOSW				;
;*NON*;
;*NON*;	MOV	PUTPOINT,DI		; put address.
;*NON*;
;*NON*;	RET
;*NON*;SETFORM_END	ENDP
;*NON*;
;*NON*;
;*NON*;;	set header IMAGE.
;*NON*;;	-I-   PUTSEG        : put buffer segment.
;*NON*;;	      IMAGE_DATADRS : IMAGE data address.
;*NON*;;	      IMAGE_LENG    : IMAGE word length.
;*NON*;;	      GETSEG        : get buffer segment.
;*NON*;;	-I/O- PUTPOINT      : put address.
;*NON*;;	      FLAG_IMAGE_PUT: IMAGE put flag. 0=IMAGE none.
;*NON*;
;*NON*;SETFORM_IMAGE	PROC	NEAR
;*NON*;	CMP	FLAG_IMAGE_PUT,0	; non IMAGE data ?
;*NON*;	JNE	SETFORM_IMAGE1		;
;*NON*;	RET
;*NON*;
;*NON*;SETFORM_IMAGE1:				;
;*NON*;	MOV	FLAG_IMAGE_PUT,0	; IMAGE put flag
;*NON*;
;*NON*;	MOV	AX,PUTSEG		; put buffer segment.
;*NON*;	MOV	ES,AX			;
;*NON*;	MOV	DI,PUTPOINT		; put address.
;*NON*;
;*NON*;	MOV	AX,IMAGE_LENG		; IMAGE word length.
;*NON*;	STOSW				; [ image data length ]
;*NON*;
;*NON*;	MOV	SI,IMAGE_DATADRS	; IMAGE data address.
;*NON*;
;*NON*;	MOV	CX,IMAGE_LENG		; IMAGE word length.
;*NON*;
;*NON*;	PUSH	DS			;
;*NON*;	MOV	AX,GETSEG		; get buffer segment.
;*NON*;	MOV	DS,AX			;
;*NON*;	REP	MOVSW			;
;*NON*;	POP	DS			;
;*NON*;
;*NON*;	MOV	PUTPOINT,DI		; put address.
;*NON*;
;*NON*;	RET
;*NON*;SETFORM_IMAGE	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;;	set header COPY.
;*NON*;;	-I-   PUTSEG        : put buffer segment.
;*NON*;;	      STRLENGTH     : string length.
;*NON*;;	      STRADDRESS    : string address.
;*NON*;;	      GETEND_POINT  : get end pointer.
;*NON*;;	-I/O- PUTPOINT      : put address.
;*NON*;;	-O-   GETPOINT      : get pointer.
;*NON*;
;*NON*;SETFORM_COPY	PROC	NEAR
;*NON*;	MOV	AX,PUTSEG		; put buffer segment.
;*NON*;	MOV	ES,AX			;
;*NON*;	MOV	DI,PUTPOINT		; put address.
;*NON*;
;*NON*;	MOV	AX,STRLENGTH		; [ string length ]
;*NON*;	SHR	AX,1			;
;*NON*;	OR	AX,ID_COPY		; [ COPY ]
;*NON*;	STOSW				;
;*NON*;
;*NON*;	MOV	AX,GETPOINT		;  get pointer - string point.
;*NON*;	SUB	AX,STRADDRESS		; [ string address ]
;*NON*;	STOSW				;
;*NON*;
;*NON*;	MOV	PUTPOINT,DI		; put address.
;*NON*;
;*NON*;	MOV	AX,GETEND_POINT		; get end pointer.
;*NON*;	MOV	GETPOINT,AX		; get pointer.
;*NON*;
;*NON*;	RET
;*NON*;SETFORM_COPY	ENDP
;*NON*;
;*NON*;
;*NON*;;	string repart comper.
;*NON*;;	-O- STRADDRESS  : same string address.
;*NON*;;	    STRLENGTH   : same string length.
;*NON*;;	    GETEND_POINT: get end pointer.
;*NON*;
;*NON*;STRING_REP_COMPER	PROC	NEAR
;*NON*;	MOV	AX,GETSEG		; get buffer segment.
;*NON*;	MOV	ES,AX			;
;*NON*;	MOV	BX,GETPOINT		; get pointer.
;*NON*;	MOV	BP,GETSTART		; get start address.
;*NON*;
;*NON*;	MOV	GETEND_POINT,BX		; get end pointer.
;*NON*;	MOV	STRADDRESS,BP		; same string address.
;*NON*;
;*NON*;	MOV	STRLENGTH,0		; same string length.
;*NON*;
;*NON*;STRING_REP_COMPER_LOOP:
;*NON*;
;*NON*;	CMP	BP,BX			; if comper string pointer.=get pointer
;*NON*;	JE	STRING_REP_COMPER_EXIT	; then exit
;*NON*;
;*NON*;	MOV	CX,GETEND		; get end address.
;*NON*;	SUB	CX,BX			; get pointer.
;*NON*;
;*NON*;	SHR	CX,1			; word counter.
;*NON*;
;*NON*;	INC	CX			; add+1(end char check+1)
;*NON*;
;*NON*;	MOV	DX,DS			; save DS.
;*NON*;
;*NON*;	MOV	AX,ES			;
;*NON*;	MOV	DS,AX			; buffer segment.
;*NON*;
;*NON*;	MOV	AX,CX			; AX=max word length.
;*NON*;
;*NON*;	MOV	SI,BX			; source string pointer.
;*NON*;	MOV	DI,BP			; comper string pointer.
;*NON*;	REPE	CMPSW			;
;*NON*;
;*NON*;	MOV	DS,DX			; load DS.
;*NON*;
;*NON*;	SUB	AX,CX			;
;*NON*;	DEC	AX			; AX=same word length.
;*NON*;
;*NON*;	SHL	AX,1			; byte counter.
;*NON*;
;*NON*;	CMP	AX,0			;
;*NON*;	JE	STRING_REP_COMPER_NEXT	;
;*NON*;
;*NON*;	CMP	AX,STRLENGTH		; if DX > all length. then
;*NON*;	JBE	STRING_REP_COMPER_NEXT	;
;*NON*;	MOV	STRADDRESS,BP		;   new  same string address.
;*NON*;	MOV	STRLENGTH,AX		;   new  same string length.
;*NON*;	ADD	AX,BX			;   source string pointer.
;*NON*;	MOV	GETEND_POINT,AX		;   get end pointer.
;*NON*;STRING_REP_COMPER_NEXT:			; endif
;*NON*;
;*NON*;	INC	BP			;
;*NON*;	INC	BP			;
;*NON*;
;*NON*;	MOV	CX,BX			; get pointer.
;*NON*;	SUB	CX,BP			; comper string pointer.
;*NON*;
;*NON*;	SHR	CX,1			; word counter.
;*NON*;	INC	CX			; add+1(end char check+1)
;*NON*;
;*NON*;	MOV	DI,BP			; comper string pointer.
;*NON*;	MOV	AX,ES:[BX]		; source string pointer.
;*NON*;	REPNE	SCASW			;
;*NON*;	DEC	DI			;
;*NON*;	DEC	DI			;
;*NON*;	MOV	BP,DI			; comper string pointer.
;*NON*;
;*NON*;	JMP	STRING_REP_COMPER_LOOP	;
;*NON*;
;*NON*;STRING_REP_COMPER_EXIT:
;*NON*;	RET
;*NON*;STRING_REP_COMPER	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;;	end check.
;*NON*;;	-O- AX : 1=data end,0=normal.
;*NON*;
;*NON*;ENDCHECK	PROC	NEAR
;*NON*;	MOV	AX,GETPOINT		; get pointer.
;*NON*;	CMP	AX,GETEND		; get end address.
;*NON*;	JE	ENDCHECK_END_DATA	;
;*NON*;
;*NON*;	MOV	AX,0			; 0=normal.
;*NON*;	RET
;*NON*;ENDCHECK_END_DATA:
;*NON*;	MOV	AX,1			; 1=data end.
;*NON*;	RET
;*NON*;ENDCHECK	ENDP


;*NON*;;	dump.
;*NON*;
;*NON*;DUMP	PROC	NEAR
;*NON*;	MOV	DX,GETPOINT
;*NON*;	CALL	DECSTR
;*NON*;	CALL	PRINT
;*NON*;	PR	":"
;*NON*;	MOV	DX,PUTPOINT
;*NON*;	CALL	DECSTR
;*NON*;	CALL	PRINT
;*NON*;	PR	":"
;*NON*;	RET
;*NON*;DUMP	ENDP
;*NON*;
;*NON*;
;*NON*;;	string dump.
;*NON*;;	-I- STRADDRESS  : same string address.
;*NON*;;	    STRLENGTH   : same string length.
;*NON*;;	    GETPOINT    : get pointer.
;*NON*;;	    GETSEG      : get buffer segment.
;*NON*;
;*NON*;DUMP2	PROC	NEAR
;*NON*;	MOV	AX,GETSEG		; get buffer segment.
;*NON*;	MOV	ES,AX			;
;*NON*;
;*NON*;	LF
;*NON*;
;*NON*;	PR	"string "
;*NON*;
;*NON*;	MOV	SI,STRADDRESS		; same string address.
;*NON*;	MOV	CX,STRLENGTH		; same string length.
;*NON*;	SHR	CX,1			;
;*NON*;DUMP2_1:
;*NON*;	MOV	DX,ES:[SI]
;*NON*;	INC	SI
;*NON*;	INC	SI
;*NON*;	PUSH	SI
;*NON*;	PUSH	CX
;*NON*;	CALL	DECSTR			;
;*NON*;	CALL	PRINT			; print ah reg.
;*NON*;	PR	":"
;*NON*;	POP	CX
;*NON*;	POP	SI
;*NON*;	LOOP	DUMP2_1
;*NON*;
;*NON*;	LF
;*NON*;
;*NON*;	PR	"getstr "
;*NON*;
;*NON*;	MOV	SI,GETPOINT		; get pointer.
;*NON*;	MOV	CX,STRLENGTH		; same string length.
;*NON*;	SHR	CX,1			;
;*NON*;DUMP2_2:
;*NON*;	MOV	DX,ES:[SI]
;*NON*;	INC	SI
;*NON*;	INC	SI
;*NON*;	PUSH	SI
;*NON*;	PUSH	CX
;*NON*;	CALL	DECSTR			;
;*NON*;	CALL	PRINT			; print ah reg.
;*NON*;	PR	":"
;*NON*;	POP	CX
;*NON*;	POP	SI
;*NON*;	LOOP	DUMP2_2
;*NON*;
;*NON*;	LF
;*NON*;
;*NON*;	RET
;*NON*;DUMP2	ENDP



CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ

GETSEG		DW	0	; get buffer segment.
GETSTART	DW	0	; get start address.
GETEND		DW	0	; get end address.
GETPOINT	DW	0	; get pointer.

GETEND_POINT	DW	0	; get end pointer.

PUTSEG		DW	0	; put buffer segment.
PUTSTART	DW	0	; put start address.
PUTEND		DW	0	; put end address.
PUTPOINT	DW	0	; put pointer.

STRADDRESS	DW	0	; same string address.
STRLENGTH	DW	0	; same string length.

FLAG_IMAGE_PUT	DW	0	; IMAGE put flag.
IMAGE_LENG	DW	0	; IMAGE word length.
IMAGE_DATADRS	DW	0	; IMAGE data address.

DATA	ENDS

	END
;
;	end of "DATPL3A.ASM"
;
