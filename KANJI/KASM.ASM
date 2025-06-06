; "KASM.ASM" PC-9801UV11 make by R.H 1990/10/23
;
;
;	ＫＡＳＭ　＜入力ファイル名＞，＜出力ファイル名＞
;
;
;	漢字ラベル　を　ＭＡＳＭ　でアセンブルできるようにする。
;
; (C) 1990 ritsurou hashimoto.

CODE	SEGMENT	PUBLIC	'CODE'
CODE	ENDS

RELOCATABLE	EQU	1	; 1=ならばリロケータブルな
				; バッファ領域を確保する。
				; そのときはＥＸＥＰＡＣＫで
				; 空きバッファを潰すとよい。

INBUF_LEN	EQU	65000	; 入力ファイルサイズ
OUTBUF_LEN	EQU	65000	; 出力ファイルサイズ


INCLUDE	TSTSET.INC

IF	RELOCATABLE			; 1=ならばリロケータブルバッファ

;	入力ファイルバッファ

INFILE	SEGMENT	PUBLIC	'INFILE'
INFILE_TOP	LABEL	BYTE
	DB	INBUF_LEN DUP (0)
INFILE	ENDS

;	出力ファイルバッファ

OUTFILE	SEGMENT	PUBLIC	'OUTFILE'
OUTFILE_TOP	LABEL	BYTE
	DB	OUTBUF_LEN DUP (0)
OUTFILE	ENDS

ENDIF



CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA,SS:STACK,ES:DATA

EXTRN	GETARG:NEAR		; get argument.

EXTRN	DSKOPN:NEAR		; file open.
EXTRN	DSKCRE:NEAR		; file open & creat.
EXTRN	DSKCLS:NEAR		; file close.

EXTRN	DSKRED:NEAR		; load 1 byte data.
EXTRN	DSKWRT:NEAR		; save 1 byte data.

EXTRN	DSKLD:NEAR		; load data.
EXTRN	DSKSV:NEAR		; save data.

EXTRN	DSK600:NEAR		; ＤＴＡの最大バイト数ロード（高速処理用）


EOF	EQU	1AH			; EOF


START:
	PUSH	DS			; save DS.

	MOV	AX,SEG DATA		; DS = DATA segment.
	MOV	DS,AX			;

	MOV	AX,SS			; stack segment.
	MOV	SAVE_SS,AX		;
	MOV	SAVE_SP,SP		; stack pointer.

	MOV	AX,SEG STACK		; stack segment.
	MOV	SS,AX			;
	MOV	SP,OFFSET TOP_OF_STACK	; stack pointer.

	CALL	MAIN			; main proc.

	MOV	AX,SAVE_SS		;
	MOV	SS,AX			; stack segment.
	MOV	SP,SAVE_SP		; stack pointer.

	POP	DS			;
FINALE:	MOV	AH,4CH			; return to DOS.
	MOV	AL,0			;
	INT	21H			; end.
MUGEN:					;
	JMP	MUGEN			;

; ****************************************************
;	メイン処理
; ****************************************************

MAIN	PROC	NEAR
	CALL	GETARG			; get argument.
	CMP	CX,2			; token count.
	JGE	MAIN_START		;

	PRF	"ＫＡＳＭ　＜入力ファイル名＞，＜出力ファイル名＞"
	PRF	"漢字ラベル　を　ＭＡＳＭ　でアセンブルできるようにする。"

	RET

MAIN_START:
	MOV	AX,DS:[SI]		; input file address.
	MOV	FILE_IN,AX		;
	MOV	AX,DS:[SI][2]		; output file address.
	MOV	FILE_OUT,AX		;


	PR	"読み込み:"		;
	MOV	SI,FILE_IN		; input file address.
	CALL	PRINT			;
	PRF	"#"			;


	CALL	FILE_LOAD		; ファイルロード
	CMP	AX,1			; 1=ディスクエラー
	JE	MAIN_ERROR_EXIT		;
	CMP	AX,2			; 2=ＥＯＦが見つからない
	JE	MAIN_T_ERROR_EXIT	;


	CALL	KNJCNV			; 漢字変換
	MOV	AX,CNT2			; 書き込みファイルバイト数
	MOV	CNT,AX			; 読み込みファイルバイト数


	PR	"書き込み:"		;
	MOV	SI,FILE_OUT		; output file address.
	CALL	PRINT			;
	PRF	"#"			;

	CALL	FILE_SAVE		; ファイルセーブ
	CMP	AX,1			; 1=ディスクエラー
	JE	MAIN_ERROR_EXIT		;

MAIN_EXIT:
	PRF	"終了しました"
	RET
MAIN_ERROR_EXIT:
	PRF	"ディスクエラー"
	RET
MAIN_T_ERROR_EXIT:
	PRF	"［ＥＯＦ］がみつからない"
	RET
MAIN	ENDP


;	ファイルロード
;	-I- FILE_IN : 読み込みファイル名アドレス
;	-O- CNT     : 読み込みファイルバイト数
;	    AX      : 0=正常, 1=ディスクエラー, 2=ＥＯＦが見つからない

FILE_LOAD	PROC	NEAR
	MOV	DX,SEG_I_BUFF		; 入力ファイルバッファ
	MOV	DI,OFS_I_BUFF		; dest offset  address.
	MOV	CX,INBUF_LEN		; 入力ファイルサイズ
	MOV	SI,FILE_IN		; input file address.

	CALL	DSKLD			; load data.

	CMP	AX,0			; 0:normal,1:open error.
	JNE	FILE_LOAD_DISK_ERROR	;

	MOV	ES,SEG_I_BUFF		; 入力ファイルバッファ
	MOV	DI,OFS_I_BUFF		;
	MOV	AL,EOF			; EOF
	MOV	CX,INBUF_LEN		; 入力ファイルサイズ
	REPNE	SCASB			;
	CMP	CX,0			;
	JE	FILE_LOAD_EOF_ERROR	;

	MOV	CNT,DI			;

FILE_LOAD_EXIT:
	MOV	AX,0			; 0=正常
	RET
FILE_LOAD_DISK_ERROR:
	MOV	AX,1			; 1=ディスクエラー
	RET
FILE_LOAD_EOF_ERROR:
	MOV	AX,2			; 2=ＥＯＦが見つからない
	RET
FILE_LOAD	ENDP



;	ファイルセーブ
;	-I- FILE_OUT : 書き込みファイル名アドレス
;	    CNT      : 書き込みファイルバイト数
;	-O- AX       : 0=正常, 1=ディスクエラー

FILE_SAVE	PROC	NEAR
	MOV	DX,SEG_O_BUFF		; 出力ファイルバッファ
	MOV	DI,OFS_O_BUFF		; dest offset  address.
	MOV	CX,CNT			; data length.
	MOV	SI,FILE_OUT		; output file address.

	CALL	DSKSV			; save data.

	CMP	AX,0			; 0:normal,1:error.
	JNE	FILE_SAVE_DISK_ERROR	;

FILE_SAVE_EXIT:
	MOV	AX,0			; 0=正常
	RET
FILE_SAVE_DISK_ERROR:
	MOV	AX,1			; 1=ディスクエラー
	RET
FILE_SAVE	ENDP



;	漢字変換
;	-O- CNT2  : 書き込みファイルバイト数

KNJCNV	PROC	NEAR
	MOV	CNT2,0			; 書き込みファイルバイト数

	MOV	ES,SEG_I_BUFF		; 入力ファイルバッファ
	MOV	DI,OFS_I_BUFF		; ES:[DI] 入力

	MOV	BX,SEG_O_BUFF		; 出力ファイルバッファ
	MOV	BP,OFS_O_BUFF		; BX:[BP] 出力

KNJCNV_LOOP:
	MOV	AX,ES:[DI]		;
	INC	DI			; input pointer.

	CMP	AL,1AH			; <EOF>
	JNE	KNJCNV_C_20		;
	JMP	KNJCNV_LOOP_END		;

KNJCNV_C_20:
	CMP	AL,0AH			; <LF>
	JNE	KNJCNV_C_21		;
	MOV	FLG_CMNT,0		; コメントフラグ
	MOV	FLG_STRING,0		; 文字列フラグ
	JMP	KNJCNV_SETB		;

KNJCNV_C_21:
	CMP	AL,0DH			; <CR>
	JNE	KNJCNV_C_22		;
	MOV	FLG_CMNT,0		; コメントフラグ
	MOV	FLG_STRING,0		; 文字列フラグ
	JMP	KNJCNV_SETB		;

KNJCNV_C_22:
	CMP	AL,09H			; <TAB>
	JNE	KNJCNV_C_23		;
	JMP	KNJCNV_SETB		;

KNJCNV_C_23:				;
	CMP	AL,";"			; <;>　コメント
	JNE	KNJCNV_C_232		;

	CMP	FLG_STRING,0		; 文字列フラグ
	JNE	KNJCNV_C_231		;

	MOV	FLG_CMNT,NOT 0		; コメントフラグ

KNJCNV_C_231:				;
	JMP	KNJCNV_SETB		;

KNJCNV_C_232:				;
	CMP	AL,22H			; <">
	JNE	KNJCNV_C_24		;

	CMP	FLG_STRING,0		; 文字列フラグ
	JE	KNJCNV_C_23_E		;
	CMP	CHR_QOUT,22H		; <"> クォーテーション
	JE	KNJCNV_C_23_E		;
	JMP	KNJCNV_SETB		;
KNJCNV_C_23_E:				;
	NOT	FLG_STRING		; 文字列フラグ
	MOV	CHR_QOUT,22H		; <"> クォーテーション
	JMP	KNJCNV_SETB		;

KNJCNV_C_24:				;
	CMP	AL,27H			; <'>
	JNE	KNJCNV_C_25		;

	CMP	FLG_STRING,0		; 文字列フラグ
	JE	KNJCNV_C_24_E		;
	CMP	CHR_QOUT,27H		; <'> クォーテーション
	JE	KNJCNV_C_24_E		;
	JMP	KNJCNV_SETB		;
KNJCNV_C_24_E:				;
	NOT	FLG_STRING		; 文字列フラグ
	MOV	CHR_QOUT,27H		; <'> クォーテーション
	JMP	KNJCNV_SETB		;

KNJCNV_C_25:				;
	CMP	FLG_CMNT,0		; コメントフラグ
	JNE	KNJCNV_SETB		;
	CMP	FLG_STRING,0		; 文字列フラグ
	JNE	KNJCNV_SETB		;

	MOV	DX,AX			; character code.
	PUSH	AX			;
	CALL	SJISCK			; shift jis check.
	CMP	AX,0			; 0=normal,1=shift jis code.
	POP	AX			;
	JE	KNJCNV_SETB		;

	MOV	DX,AX			; character code.
	XCHG	DH,DL			;
	CALL	SJISCNV			; shift JIS -> JIS
					; DX : jis code.
	CALL	HEXSTR			; "鏡"->"3640"
	ADD	DS:[SI],BYTE PTR 'A'-'2' ; "3640"->"A640"

	MOV	CX,ES			;
	MOV	ES,BX			;
	MOV	AX,DS:[SI]		;
	MOV	ES:[BP],AX		;
	MOV	AX,DS:[SI][2]		;
	MOV	ES:[BP][2],AX		;
	ADD	BP,4			; BX:[BP] 出力
	MOV	ES,CX			;

	INC	DI			; input pointer.

	JMP	KNJCNV_NEXT		;

KNJCNV_SETB:
	MOV	CX,ES			;
	MOV	ES,BX			;
	MOV	ES:[BP],AL		;
	INC	BP			; BX:[BP] 出力
	MOV	ES,CX			;
KNJCNV_NEXT:
	JMP	KNJCNV_LOOP
KNJCNV_LOOP_END:
	MOV	ES,BX			;
	MOV	ES:[BP],BYTE PTR 1AH	; <EOF>
	INC	BP			; BX:[BP] 出力
	MOV	CNT2,BP			; 書き込みファイルバイト数
	RET
KNJCNV	ENDP


;	shift jis check.
;	-I- DX : character code.
;	-O- AX : 0=normal,1=shift jis code.

SJISCK	PROC	NEAR
	MOV	AX,0
	CMP	DL,081H
	JB	SJISCK3
	CMP	DL,09FH
	JNBE	SJISCK3
	MOV	AX,1		; shift jis code.
	RET
SJISCK3:
	CMP	DL,0E0H
	JB	SJISCK9
	CMP	DL,0FCH
	JNBE	SJISCK9
	MOV	AX,1		; shift jis code.
SJISCK9:
	RET
SJISCK	ENDP


;	shift JIS -> JIS
;	-I/O- DX : jis code.

SJISCNV	PROC	NEAR
	CMP	DL,09EH		;	IF (I2 .LE. I9E)  THEN
	JNBE	SJISCNV4	;
	CMP	DH,09FH		;	  IF (I1 .LE. I9F)  THEN
	JNBE	SJISCNV2	;
	SUB	DH,071H		;	    I1  =  (I1 - I71) * 2 + 1
	SHL	DH,1		;
	INC	DH		;
	JMP	SJISCNV3	;
SJISCNV2:			;	  ELSE
	SUB	DH,0B1H		;	    I1  =  (I1 - IB1) * 2 + 1
	SHL	DH,1		;
	INC	DH		;
SJISCNV3:			;	  END IF
	SUB	DL,01FH		;	  I2  =  I2 - I1F
	CMP	DL,061H		;	IF (I2 .GE. I61)  I2 = I2 - 1
	JB	SJISCNV33	;
	DEC	DL		;
SJISCNV33:			;
	JMP	SJISCNV7	;
SJISCNV4:			;	ELSE
	CMP	DH,09FH		;	  IF (I1 .LE. I9F)  THEN
	JNBE	SJISCNV6	;
	SUB	DH,070H		;	    I1  =  (I1 - I70) * 2
	SHL	DH,1		;
	JMP	SJISCNV66	;
SJISCNV6:			;	  ELSE
	SUB	DH,0B0H		;	    I1  =  (I1 - IB0) * 2
	SHL	DH,1		;
SJISCNV66:			;	  END IF
	SUB	DL,07EH		;	  I2  =  I2 - I7E
SJISCNV7:			;	END IF
	RET			;
SJISCNV	ENDP

CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

SAVE_SS		DW	0		; stack segment.
SAVE_SP		DW	0		; stack pointer.

CNT		DW	0		;
CNT2		DW	0		;


IF	RELOCATABLE			; 1=ならばリロケータブルバッファ

	SEG_I_BUFF	DW	SEG INFILE	; 入力ファイルバッファ
	OFS_I_BUFF	DW	OFFSET INFILE_TOP
	SEG_O_BUFF	DW	SEG OUTFILE	; 出力ファイルバッファ
	OFS_O_BUFF	DW	OFFSET OUTFILE_TOP
ELSE
	SEG_I_BUFF	DW	8000H		; 入力ファイルバッファ
	OFS_I_BUFF	DW	0		;
	SEG_O_BUFF	DW	9000H		; 出力ファイルバッファ
	OFS_O_BUFF	DW	0		;
ENDIF


FILE_IN		DW	0		; input  file address.
FILE_OUT	DW	0		; output file address.

FLG_CMNT	DW	0		; コメントフラグ
FLG_STRING	DW	0		; 文字列フラグ
CHR_QOUT	DW	0		; クォーテーション

DATA	ENDS

STACK	SEGMENT	STACK
		EVEN
		DW	1000 DUP (?)
TOP_OF_STACK	LABEL	WORD
STACK	ENDS

	END	START
;
;	end of "KASM.ASM"
;
