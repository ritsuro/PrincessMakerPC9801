; "VRMEDT.ASM" PC-9801UV11 make by R.H 1990/02/24
;
;
;	ＶＲＡＭエディタ
;
;
; public subroutine.

INCLUDE	TSTSET.INC


PLSBUF	SEGMENT	PUBLIC	'PLSBUF'	; データ圧縮用ワークバッファ
EXTRN	PLSBTP:BYTE			; データ圧縮用ワーク先頭
PLSBUF	ENDS


CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	VRMEDT			; ＶＲＡＭエディタ

EXTRN	LODBET:NEAR		; ベタファイルロード
EXTRN	SAVBET:NEAR		; ベタファイルセーブ

EXTRN	LODZ88:NEAR		; ＰＣ８８Ｚ’ｓファイルロード
EXTRN	SAVZ88:NEAR		; ＰＣ８８Ｚ’ｓファイルセーブ

EXTRN	DSKLD:NEAR		; load data.
EXTRN	DSKSV:NEAR		; save data.

EXTRN	VRMCLR:NEAR		; ＶＲＡＭクリア

ADDWIDTH	EQU	80	; ＶＲＡＭ横長さ



;	ＶＲＡＭエディタ

VRMEDT	PROC	NEAR
	CALL	CLS
	PRF	"ＶＲＡＭエディタへようこそ VRMEDT ver 0.0 1990/05/09 R.H"
VRMEDT_MENU:
	PRF	"1 :データロード"
	PRF	"2 :データセーブ"
	PRF	"3 :ベタファイルロード"
	PRF	"4 :ベタファイルセーブ"
	PRF	"5 :ＰＣ８８Ｚ’ｓファイルロード"
	PRF	"6 :ＰＣ８８Ｚ’ｓファイルセーブ"
	PRF	"7 :たたみ転送操作"
	PRF	"8 :ＶＲＡＭクリア"
	PRF	"9 :バイト幅４プレーン転送操作"
	PRF	"10:ＤＡＩ４ＵＮＩＴ展開操作"
	INP	" 処理番号[Q:EXIT]＝"

	CMP	BYTE PTR DS:[SI],'*'
	JNE	VRMEDT_SLCT
	CALL	CLS
	INP	" "
	JMP	VRMEDT_MENU
VRMEDT_SLCT:

	CALL	STRDEC

	CMP	DX,1		; min.
	JL	VRMEDT_NEXT	;
	CMP	DX,10		; max.
	JG	VRMEDT_NEXT	;

	MOV	BX,DX		; select menu number.
	SHL	BX,1		; word pointer.
	CALL	CS:JMP_TABLE[BX]

VRMEDT_NEXT:
	JMP	VRMEDT_MENU


JMP_TABLE	LABEL	WORD
	DW	0
	DW	OFFSET	DATLOD		; データロード
	DW	OFFSET	DATSAV		; データセーブ
	DW	OFFSET	LOAD_BET	; ベタファイルロード
	DW	OFFSET	SAVE_BET	; ベタファイルセーブ
	DW	OFFSET	LOAD_ZS88	; ＰＣ８８Ｚ’ｓファイルロード
	DW	OFFSET	SAVE_ZS88	; ＰＣ８８Ｚ’ｓファイルセーブ
	DW	OFFSET	TATAMISET	; たたみ転送操作
	DW	OFFSET	VRAM_CLEAR	; ＶＲＡＭクリア
	DW	OFFSET	BYT4PLSET	; バイト幅４プレーン転送操作
	DW	OFFSET	DAI4PLSET	; ＤＡＩ４ＵＮＩＴ展開操作

VRMEDT	ENDP



;	データロード

DATLOD	PROC	NEAR
	INP	"単純バイナリロードファイル名[拡張子自由]="
	MOV	DI,OFFSET PLSBTP	; データ圧縮用ワーク先頭
	MOV	DX,SEG PLSBUF		; データ圧縮用ワークバッファ
	MOV	CX,32000		; データのバイト数
	CALL	DSKLD			; file load.

	RET
DATLOD	ENDP



;	データセーブ

DATSAV	PROC	NEAR
	INP	"単純バイナリセーブファイル名[拡張子自由]="
	MOV	DI,OFFSET PLSBTP	; データ圧縮用ワーク先頭
	MOV	DX,SEG PLSBUF		; データ圧縮用ワークバッファ
	MOV	CX,32000		; データのバイト数
	CALL	DSKSV			; file save.

	RET
DATSAV	ENDP



;	ベタファイルロード

LOAD_BET	PROC	NEAR
	INP	"ベタファイルロードファイル名 [*.B1, *.R1, *.G1, *.E1]="
	CALL	LODBET			; ベタファイルロード
	RET
LOAD_BET	ENDP



;	ベタファイルセーブ

SAVE_BET	PROC	NEAR
	INP	"ベタファイルセーブファイル名 [*.B1, *.R1, *.G1, *.E1]="
	CALL	SAVBET			; ベタファイルセーブ
	RET
SAVE_BET	ENDP



;	ＰＣ８８Ｚ’ｓファイルロード

LOAD_ZS88	PROC	NEAR
	INP	"ＰＣ８８Ｚ’ｓファイルロード [*.ST2]="
	CALL	LODZ88			; ＰＣ８８Ｚ’ｓファイルロード
	RET
LOAD_ZS88	ENDP



;	ＰＣ８８Ｚ’ｓファイルセーブ

SAVE_ZS88	PROC	NEAR
	INP	"ＰＣ８８Ｚ’ｓファイルセーブ [*.ST2]="
	CALL	SAVZ88			; ＰＣ８８Ｚ’ｓファイルセーブ
	RET
SAVE_ZS88	ENDP



;	ＶＲＡＭクリア

VRAM_CLEAR	PROC	NEAR
	CALL	VRMCLR		; ＶＲＡＭクリア
	RET
VRAM_CLEAR	ENDP



;	たたみ転送操作

TATAMISET	PROC	NEAR
	CALL	CLS
	INP	"						Ｘ長さ"
	CALL	STRDEC
	CMP	DX,0
	JE	TATAMISET1
	MOV	LENX,DX		; Ｘ長さ
	JMP	TATAMISET12
TATAMISET1:
	INC	LENX
	CMP	LENX,80
	JLE	TATAMISET12
	MOV	LENX,80
TATAMISET12:

	INP	"						Ｙ長さ"
	CALL	STRDEC
	CMP	DX,0
	JE	TATAMISET2
	MOV	LENY,DX		; Ｙ長さ
TATAMISET2:

	CALL	TATAMI		; たたみ転送

	JMP	TATAMISET
	RET
TATAMISET	ENDP



;	たたみ転送
;	-I- LENX : Ｘ長さ
;	    LENY : Ｙ長さ

TATAMI	PROC	NEAR
	PUSH	DS

	MOV	BP,ADDWIDTH		; ＶＲＡＭ横長さ
	SUB	BP,LENX			; BP=次のラインまでの長さ

	MOV	BX,LENX			; Ｘ長さ
	MOV	CX,LENY			; Ｙ長さ

	MOV	AX,ARAVRM[0]		; vram area 1.
	MOV	ES,AX			;
	MOV	AX,SEG PLSBUF		; データ圧縮用ワークバッファ
	MOV	DS,AX			;

	MOV	DI,0			;
	MOV	SI,OFFSET PLSBTP	; データ圧縮用ワーク先頭

TATAMI_LOOP:				;
	PUSH	CX			;

	MOV	CX,BX			; Ｘ長さ

	REP	MOVSB			;
	ADD	DI,BP			; BP=次のラインまでの長さ

	POP	CX			;
	LOOP	TATAMI_LOOP		;

	POP	DS
	RET
TATAMI	ENDP



;	バイト幅４プレーン転送操作

BYT4PLSET	PROC	NEAR
	CALL	CLS

	INP	"						Ｘ長さ"
	CALL	STRDEC
	CMP	DX,0
	JE	BYT4PLSET1
	MOV	LENX,DX		; Ｘ長さ
BYT4PLSET1:

	INP	"						Ｙ長さ"
	CALL	STRDEC
	CMP	DX,0
	JE	BYT4PLSET2
	MOV	LENY,DX		; Ｙ長さ
	JMP	BYT4PLSET22
BYT4PLSET2:
	DEC	LENY
	CMP	LENY,0
	JGE	BYT4PLSET22
	MOV	LENY,0
BYT4PLSET22:

	CALL	BYT4PL		; バイト幅４プレーン転送

	JMP	BYT4PLSET
	RET
BYT4PLSET	ENDP



;	バイト幅４プレーン転送
;	-I- LENX : Ｘ長さ
;	    LENY : Ｙ長さ

BYT4PL	PROC	NEAR
	PUSH	DS

	MOV	CX,LENX			; Ｘ長さ
	MOV	BX,LENY			; Ｙ長さ

	MOV	AX,ARAVRM[0]		; vram area 0.
	MOV	CS:SSD0,AX		; visual data segment plean 0
	MOV	AX,ARAVRM[2]		; vram area 1.
	MOV	CS:SSD1,AX		; visual data segment plean 1
	MOV	AX,ARAVRM[4]		; vram area 2.
	MOV	CS:SSD2,AX		; visual data segment plean 2
	MOV	AX,ARAVRM[6]		; vram area 3.
	MOV	CS:SSD3,AX		; visual data segment plean 3

	MOV	AX,SEG PLSBUF		; データ圧縮用ワークバッファ
	MOV	DS,AX			;

	MOV	DI,0			;
	MOV	SI,OFFSET PLSBTP	; データ圧縮用ワーク先頭
	ADD	SI,2			;
BYT4PL_LOOP:				;
	PUSH	CX			;

	MOV	DX,DI			; vram pointer.

	MOV	CX,BX			; Ｙ長さ
BYT4PL_LOOP2:				;
	MOV	AX,CS:SSD0		; visual data segment plean 0
	MOV	ES,AX			;
	LODSB				;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD1		; visual data segment plean 1
	MOV	ES,AX			;
	LODSB				;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD2		; visual data segment plean 2
	MOV	ES,AX			;
	LODSB				;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD3		; visual data segment plean 3
	MOV	ES,AX			;
	LODSB				;
	STOSB				;
	DEC	DI			;
	ADD	DI,ADDWIDTH		; ＶＲＡＭ横長さ
	LOOP	BYT4PL_LOOP2		;

	MOV	DI,DX			; vram pointer.
	INC	DI			; 次のライン

	POP	CX			;
	LOOP	BYT4PL_LOOP		;

	POP	DS
	RET
BYT4PL	ENDP



;	ＤＡＩ４ＵＮＩＴ展開操作

DAI4PLSET	PROC	NEAR
	CALL	CLS

	INP	"						Ｘ長さ"
	CALL	STRDEC
	CMP	DX,0
	JE	DAI4PLSET1
	MOV	LENX,DX		; Ｘ長さ
DAI4PLSET1:

	INP	"						Ｙ長さ"
	CALL	STRDEC
	CMP	DX,0
	JE	DAI4PLSET2
	MOV	LENY,DX		; Ｙ長さ
	JMP	DAI4PLSET22
DAI4PLSET2:
	DEC	LENY
	CMP	LENY,0
	JGE	DAI4PLSET22
	MOV	LENY,0
DAI4PLSET22:

	CALL	DAI4PL		; ＤＡＩ４ＵＮＩＴ展開

	JMP	DAI4PLSET
	RET
DAI4PLSET	ENDP



;	ＤＡＩ４ＵＮＩＴ展開
;	-I- LENX : Ｘ長さ
;	    LENY : Ｙ長さ

DAI4PL	PROC	NEAR
	PUSH	DS

	MOV	CX,LENX			; Ｘ長さ
	MOV	BX,LENY			; Ｙ長さ

	MOV	AX,ARAVRM[0]		; vram area 0.
	MOV	CS:SSD0,AX		; visual data segment plean 0
	MOV	AX,ARAVRM[2]		; vram area 1.
	MOV	CS:SSD1,AX		; visual data segment plean 1
	MOV	AX,ARAVRM[4]		; vram area 2.
	MOV	CS:SSD2,AX		; visual data segment plean 2
	MOV	AX,ARAVRM[6]		; vram area 3.
	MOV	CS:SSD3,AX		; visual data segment plean 3

	MOV	AX,SEG PLSBUF		; データ圧縮用ワークバッファ
	MOV	DS,AX			;

	MOV	BP,0			; スキップカウンタ

	MOV	DI,0			;
	MOV	SI,OFFSET PLSBTP	; データ圧縮用ワーク先頭
	ADD	SI,0CH			; 先頭から０Ｃｈバイト目がＩＤで
	MOV	AL,DS:[SI]		;
	MOV	CS:ATRID,AL		; data attrbute.
	ADD	SI,06			; さらに６バイト加算してデータ先頭


DAI4PL_LOOP:				;
	PUSH	CX			;

	MOV	DX,DI			; vram pointer.

	MOV	CX,BX			; Ｙ長さ
DAI4PL_LOOP2:				;
	CMP	BP,0			; スキップカウンタ
	JE	DAI4PL2			;
	DEC	BP			;
	SUB	SI,8			;
	JMP	DAI4PL_NEXT2		; スキップ
DAI4PL2:				;
	MOV	AX,CS:SSD0		; visual data segment plean 0
	MOV	ES,AX			;
	LODSB				;

	CMP	AL,CS:ATRID		; data attrbute.
	JE	DAI4PL23		;

	JMP	DAI4PL3			;
DAI4PL23:				;
	LODSB				;
	INC	SI			;
	INC	SI			;
	MOV	AH,0			;
	MOV	BP,AX			; BP=スキップカウンタ
	DEC	BP			;
	SUB	SI,8			;
	JMP	DAI4PL_NEXT2		; スキップ
DAI4PL3:				;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD1		; visual data segment plean 1
	MOV	ES,AX			;
	LODSB				;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD2		; visual data segment plean 2
	MOV	ES,AX			;
	LODSB				;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD3		; visual data segment plean 3
	MOV	ES,AX			;
	LODSB				;
	STOSB				;
	DEC	DI			;
	JMP	DAI4PL_NEXT22		;
DAI4PL_NEXT2:				;
	MOV	AX,CS:SSD0		; visual data segment plean 0
	MOV	ES,AX			;
	LODSB				;
	MOV	AL,0			;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD1		; visual data segment plean 1
	MOV	ES,AX			;
	LODSB				;
	MOV	AL,0			;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD2		; visual data segment plean 2
	MOV	ES,AX			;
	LODSB				;
	MOV	AL,0			;
	STOSB				;
	DEC	DI			;
	MOV	AX,CS:SSD3		; visual data segment plean 3
	MOV	ES,AX			;
	LODSB				;
	MOV	AL,0			;
	STOSB				;
	DEC	DI			;

	INC	SI
	INC	SI
	INC	SI
	INC	SI
DAI4PL_NEXT22:				;

	ADD	DI,ADDWIDTH		; ＶＲＡＭ横長さ
	LOOP	DAI4PL_LOOP2		;

	MOV	DI,DX			; vram pointer.
	INC	DI			; 次のライン

	POP	CX			;
	LOOP	DAI4PL_LOOP_SS		;
	JMP	DAI4PL_EXIT		;
DAI4PL_LOOP_SS:				;
	JMP	DAI4PL_LOOP		;
DAI4PL_EXIT:
	POP	DS
	RET
DAI4PL	ENDP

	ATRID	DB	0	; data attrbute.
		DB	0	;
	SSD0	DW	0	; visual data segment plean 0
	SSD1	DW	0	; visual data segment plean 1
	SSD2	DW	0	; visual data segment plean 2
	SSD3	DW	0	; visual data segment plean 3

	SSS0	DW	0	; visual data segment plean 0
	SSS1	DW	0	; visual data segment plean 1
	SSS2	DW	0	; visual data segment plean 2
	SSS3	DW	0	; visual data segment plean 3

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	ARAVRM:WORD		; vram area.

LENX	DW	0		; Ｘ長さ
LENY	DW	0		; Ｙ長さ

DATA	ENDS

	END
;
;	end of "VRMEDT.ASM"
;
