; "CNZS88.ASM" PC-9801UV11 make by R.H 1990/02/24
;
;
;	ＰＣ８８Ｚ’ｓファイルのアクセス
;
;
; public subroutine.

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	LODZ88			; ＰＣ８８Ｚ’ｓファイルロード
PUBLIC	SAVZ88			; ＰＣ８８Ｚ’ｓファイルセーブ

	EXTRN	DSKOPN:NEAR	; file open.
	EXTRN	DSKCRE:NEAR	; file open & creat.
	EXTRN	DSKCLS:NEAR	; file close.

	EXTRN	DSKDR:NEAR	; drive number set.
	EXTRN	DSKRED:NEAR	; load 1 byte data.
	EXTRN	DSKWRT:NEAR	; save 1 byte data.
	EXTRN	DSKLD:NEAR	; load data.
	EXTRN	DSKSV:NEAR	; save data.


ZS88ST2_LEN	EQU	48000	; Ｚ’ｓ８８データのバイト数


;	ＰＣ８８Ｚ’ｓファイルロード
;	-I- DS:SI  : ファイル名 (null=end of string)

LODZ88	PROC	NEAR
	PUSH	SI

	CALL	BFLNSET			; ＰＣ８８Ｚ’ｓファイル名セット

	MOV	SI,OFFSET FLZ88		; ＰＣ８８Ｚ’ｓファイル名
	MOV	DI,0			; vram offset.
	MOV	DX,ARAVRM[0]		; vram segment.
	MOV	CX,ZS88ST2_LEN		; Ｚ’ｓ８８データのバイト数
	CALL	DSKLD			; file load.

	CALL	PLNDEV			; ９８プレーンに分割

	POP	SI
	RET
LODZ88	ENDP


;	ＰＣ８８Ｚ’ｓファイルセーブ
;	-I- DS:SI  : ファイル名 (null=end of string)

SAVZ88	PROC	NEAR
	PUSH	SI

	PUSH	SI
	CALL	PLNSST		; ９８プレーンをＺ’ｓ８８フォーマットへ
	POP	SI

	CALL	BFLNSET			; ＰＣ８８Ｚ’ｓファイル名セット

	MOV	SI,OFFSET FLZ88		; ＰＣ８８Ｚ’ｓファイル名
	MOV	DI,0			; vram offset.
	MOV	DX,ARAVRM[0]		; vram segment.
	MOV	CX,ZS88ST2_LEN		; Ｚ’ｓ８８データのバイト数
	CALL	DSKSV			; file save.

	POP	SI
	RET
SAVZ88	ENDP



Z881PLNLEN	EQU	16000		; Ｚ’ｓ８８１プレーンバイト数

;	９８プレーンに分割

PLNDEV	PROC	NEAR
	PUSH	DS
	MOV	DX,DS

	MOV	AX,ARAVRM[4]		; dest vram segment.
	MOV	ES,AX			;
	MOV	AX,ARAVRM[0]		;
	MOV	DS,AX			;
	MOV	SI,Z881PLNLEN*2		;
	MOV	DI,0			;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	MOV	DS,DX			;
	MOV	AX,ARAVRM[2]		; dest vram segment.
	MOV	ES,AX			;
	MOV	AX,ARAVRM[0]		;
	MOV	DS,AX			;
	MOV	SI,Z881PLNLEN		;
	MOV	DI,0			;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	MOV	DS,DX			;
	MOV	AX,ARAVRM[0]		; dest vram segment.
	MOV	ES,AX			;
	MOV	DI,Z881PLNLEN		;
	MOV	CX,Z881PLNLEN/2		;
	MOV	AX,0			;
	REP	STOSW			;

	POP	DS
	RET
PLNDEV	ENDP



;	９８プレーンをＺ’ｓ８８フォーマットへ

PLNSST	PROC	NEAR
	PUSH	DS
	MOV	DX,DS

	MOV	AX,ARAVRM[0]		;
	MOV	ES,AX			;
	MOV	AX,ARAVRM[2]		; dest vram segment.
	MOV	DS,AX			;
	MOV	SI,0			;
	MOV	DI,Z881PLNLEN		;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	MOV	DS,DX			;
	MOV	AX,ARAVRM[0]		;
	MOV	ES,AX			;
	MOV	AX,ARAVRM[4]		; dest vram segment.
	MOV	DS,AX			;
	MOV	DI,Z881PLNLEN*2		;
	MOV	SI,0			;
	MOV	CX,Z881PLNLEN/2		;
	REP	MOVSW			;

	POP	DS
	RET
PLNSST	ENDP



;	ＰＣ８８Ｚ’ｓファイル名セット
;	-I- DS:SI : ファイル名

BFLNSET	PROC	NEAR
	PUSH	SI

	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET FLNAME	; ファイル名クリア
	MOV	CX,8
	MOV	AL,' '
	REP	STOSB

	MOV	DI,OFFSET FLNAME	; ファイル名
	MOV	CX,8
BFLNSET2:
	LODSB
	CMP	AL,' '			; end of string.
	JB	BFLNSET3		;
	STOSB
	LOOP	BFLNSET2
BFLNSET3:
	MOV	SI,OFFSET FLNAME	; ファイル名
	MOV	DI,OFFSET FLZ88		; ＰＣ８８Ｚ’ｓファイル名
	MOV	CX,8			;
	REP	MOVSB			;

	POP	SI
	RET
BFLNSET	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	ARAVRM:WORD		; vram area.

FLNAME	DB	"        ",0		; ファイル名
FLZ88	DB	"        ","ST2",0	; ＰＣ８８Ｚ’ｓファイル名

DATA	ENDS

	END
;
;	end of "CNZS88.ASM"
;
