; "TUCDAT.ASM" PC-9801UV11 make by R.H 1989/12/25
;
;	タッチデータファイル作成
;
;

INCLUDE	TSTSET.INC

TOUCH	SEGMENT	PUBLIC	'TOUCH'
TOUCH	ENDS

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	TUCDAT		; タッチデータファイル作成


EXTRN	PLSET:NEAR	; パレットセット
EXTRN	PLPSET:NEAR	; パレット編集セット

EXTRN	LODPLT:NEAR	; パレットファイルロード
EXTRN	SAVPLT:NEAR	; パレットファイルセーブ

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

EXTRN	LODBET:NEAR	; ベタファイルロード
EXTRN	SAVBET:NEAR	; ベタファイルセーブ

EXTRN	PATCLR:NEAR	; パーツセットクリア
EXTRN	PATGET:NEAR	; パーツＧＥＴ
EXTRN	PATPUT:NEAR	; パーツＰＵＴ

EXTRN	VRMCLR:NEAR	; ＶＲＡＭクリア
EXTRN	DSP16M:NEAR	; １６色モードセット

EXTRN	CLRCHG:NEAR	; カラーチェンジ

EXTRN	TCHGET:NEAR	; タッチ属性ＧＥＴ
EXTRN	TCHPUT:NEAR	; タッチ属性ＰＵＴ

EXTRN	PTLIN:NEAR	; XOR line.
EXTRN	PTXRS:NEAR	; cross line.
EXTRN	PTBOX:NEAR	; XOR box.
EXTRN	PTPIC:NEAR	; point pick.
EXTRN	PTCHG:NEAR	; box point left & right set.
EXTRN	PTCHK:NEAR	; check same 2 point?
EXTRN	PTSET:NEAR	; ピックデバイスセット(0=KEY,1=MOUSE)
EXTRN	PTMODE:NEAR	; ピックモード切り替え

EXTRN	TXTBOX:NEAR	; テキスト属性ＢＯＸセット

TOUCH_SIZE	EQU	40*25	; タッチ属性バッファサイズ
TOUCH_MAX	EQU	20	; タッチ属性マックス


; *******************************************
;	タッチデータファイル作成
; *******************************************
;	-I- DX : ドライブ番号

TUCDAT	PROC	NEAR
	MOV	USER_DRV,DX		; ユーザドライブ番号

	PRF	"タッチデータファイル作成[.TCH]"

	INP	"タッチデータ読み込み／書き込みドライブ＝"
	CALL	STRDEC
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

TUCDAT_START:
	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

	CALL	VRMCLR			; ＶＲＡＭクリア

	INP	"ファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット
	CALL	FLSETT			; 属性ファイル名セット

	PRF	"パレットファイル読み込み [*.ALG]"
	MOV	SI,OFFSET FLNM		; file name.
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	PRF	"ベタファイル読み込み [*.B1, *.R1, *.G1, *.E1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ベタファイルロード

	CALL	GRIDXX			; グリッド表示

	CALL	HARFTONE		; 明度を落とす

	MOV	DI,OFFSET TOPTCH	; タッチ属性バッファ
	MOV	DX,SEG TOUCH		;
	MOV	ES,DX			;
	MOV	CX,TOUCH_SIZE		; タッチ属性バッファサイズ
	MOV	AL,0			;
	REP	STOSB			; データクリア

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	MOV	SI,OFFSET FLNMT		; file name.
	MOV	DI,OFFSET TOPTCH	; タッチ属性バッファ
	MOV	DX,SEG TOUCH		;
	MOV	CX,TOUCH_SIZE		; タッチ属性バッファサイズ
	CALL	DSKLD			; データロード

	CALL	TOUCH_MAKER		; タッチ属性

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	MOV	SI,OFFSET FLNMT		; file name.
	MOV	DI,OFFSET TOPTCH	; タッチ属性バッファ
	MOV	DX,SEG TOUCH		;
	MOV	CX,TOUCH_SIZE		; タッチ属性バッファサイズ
	CALL	DSKSV			; データセーブ

TUCDAT55:				;
	RET
TUCDAT	ENDP




;	タッチ属性

TOUCH_MAKER	PROC	NEAR
	MOV	VX1,0		; start point.
	MOV	VY1,0		; start point.
	MOV	VX2,1		; end point.
	MOV	VY2,0		; end point.
	MOV	DX,11000101B	; attribute.
	CALL	TXTBOX		; テキスト属性ＢＯＸセット

	CALL	TOUCH_GRID	; タッチ属性表示

	MOV	AX,0		;
	MOV	BX,0		;
	CALL	LOCATE		;
	MOV	AH,BYTE PTR TOUCH_ATR	; タッチ属性
	CALL	PRNAH		; AH reg print. タッチ属性左上表示

	MOV	TOUCH_ATR,0	; タッチ属性

TOUCH_MAKER1:
	CALL	ARAPNT		; point pic.

	MOV	DX,0001H	;
	CMP	AX,2		; 2=escape
	JNE	TOUCH_MAKER10	;
	MOV	DX,0100H	;
TOUCH_MAKER10:
	MOV	AX,VX1		;
	MOV	BX,VY1		;
	SHR	BX,1		;
	SHR	BX,1		;
	SHR	BX,1		; / 8

				;	-O- AX : Ｘ座標
				;	    BX : Ｙ座標
				;	    DH : 左ボタン（1：ＯＦＦ／0：ＯＮ）
				;	    DL : 右ボタン（1：ＯＦＦ／0：ＯＮ）

	SHR	AX,1		;
	SHL	AX,1		;
	SHR	BX,1		;
	SHL	BX,1		;

	MOV	TOUCH_STEP,0	;
	CMP	AX,TUCOLDX	; タッチＸ座標
	JNE	TOUCH_MAKER11	;
	CMP	BX,TUCOLDY	; タッチＹ座標
	JNE	TOUCH_MAKER11	;
	MOV	TOUCH_STEP,1	;
TOUCH_MAKER11:

	MOV	VX1,AX		;
	MOV	VY1,BX		;

	MOV	AX,TOUCH_ATR	; タッチ属性

TOUCH_MAKER2:
	CMP	DH,1
	JE	TOUCH_MAKER3

	ADD	AX,TOUCH_STEP	; タッチピックステップ
	CMP	AX,TOUCH_MAX	;
	JLE	TOUCH_MAKER30	;
	MOV	AX,0		;
TOUCH_MAKER30:
	JMP	TOUCH_MAKER5	;
TOUCH_MAKER3:
	CMP	DL,1
	JE	TOUCH_MAKER4

	SUB	AX,TOUCH_STEP	; タッチピックステップ
	CMP	AX,0		;
	JGE	TOUCH_MAKER40	;
	MOV	AX,TOUCH_MAX	;
TOUCH_MAKER40:
	JMP	TOUCH_MAKER5	;
TOUCH_MAKER4:
	JMP	TOUCH_MAKER1	;
TOUCH_MAKER5:

	CMP	VX1,2		;
	JG	TOUCH_MAKER55	; ＶＸ１＜＝２　しかも　ＶＹ１＜＝２
TOUCH_MAKER53:			; ならば終了
	CMP	VY1,2		;
	JG	TOUCH_MAKER55	;
	JMP	TOUCH_MAKER99	;
TOUCH_MAKER55:			;
	MOV	TOUCH_ATR,AX	; タッチ属性
				; ＡＸ＝タッチ属性

	CALL	TCHPUT		; タッチ属性ＰＵＴ

	CALL	TOUCH_GRID	; タッチ属性表示
	MOV	AX,0		;
	MOV	BX,0		;
	CALL	LOCATE		;
	MOV	AH,BYTE PTR TOUCH_ATR	; タッチ属性
	CALL	PRNAH		; AH reg print. タッチ属性左上表示

	MOV	AX,VX1		;
	SHR	AX,1		;
	SHL	AX,1		;
	MOV	TUCOLDX,AX	; タッチＸ座標
	MOV	BX,VY1		;
	SHR	BX,1		;
	SHL	BX,1		;
	MOV	TUCOLDY,BX	; タッチＹ座標

	CALL	MSWAT		; カーソルボタンＯＦＦ待ち

	JMP	TOUCH_MAKER1	;

TOUCH_MAKER99:
	MOV	VX1,0		; start point.
	MOV	VY1,0		; start point.
	MOV	VX2,1		; end point.
	MOV	VY2,0		; end point.
	MOV	DX,11100001B	; attribute.
	CALL	TXTBOX		; テキスト属性ＢＯＸセット

	CALL	CLS		; cls
	RET
TOUCH_MAKER	ENDP




;	タッチ属性表示

TOUCH_GRID	PROC	NEAR
	MOV	AX,0
	MOV	BX,0
	CALL	LOCATE

	MOV	AX,SEG TOUCH
	MOV	ES,AX
	MOV	DI,OFFSET TOPTCH

	MOV	AX,0			; locate X
	MOV	BX,0			; locate Y
	MOV	CX,TOUCH_SIZE-40	; タッチ属性バッファサイズ
TOUCH_GRID2:
	CALL	LOCATE			;
	INC	AX			; x
	INC	AX			; x
	CMP	AX,78			; if x >= 78 then x=0 y++
	JLE	TOUCH_GRID3		;
	MOV	AX,0
	INC	BX
TOUCH_GRID3:
	PUSH	AX
	PUSH	BX
	MOV	AH,ES:[DI]
	CMP	AH,0
	JE	TOUCH_GRID4
	CALL	PRNAH			; print of a register.
	JMP	TOUCH_GRID5
TOUCH_GRID4:
	MOV	AL,' '
	CALL	CHPUT
	CALL	CHPUT
TOUCH_GRID5:
	INC	DI
	POP	BX
	POP	AX
	LOOP	TOUCH_GRID2

	RET
TOUCH_GRID	ENDP



;	グリッド表示

GRIDXX	PROC	NEAR
	MOV	VX1,0		; start point.
	MOV	VY1,0		; start point.
	MOV	VX2,639/8	; end point.
	MOV	VY2,0		; end point.
	MOV	CX,400/16	;
GRIDXX2:
	PUSH	CX		;
	CALL	PTLIN		; XOR line.
	POP	CX		;
	ADD	VY1,16		; start point.
	ADD	VY2,16		; end point.
	LOOP	GRIDXX2		;

	MOV	VX1,0		; start point.
	MOV	VY1,0		; start point.
	MOV	VX2,0		; end point.
	MOV	VY2,399		; end point.
	MOV	CX,640/16	;
GRIDXX3:
	PUSH	CX		;
	CALL	PTLIN		; XOR line.
	POP	CX		;
	ADD	VX1,2		; start point.
	ADD	VX2,2		; end point.
	LOOP	GRIDXX3		;

	RET
GRIDXX	ENDP



;	明度を落とす

HARFTONE	PROC	NEAR
	PRF	"明度５０％"
	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	CALL	PLPSET			; パレット編集セット
	MOV	CX,50			;
HARFTONE03:				;
	PUSH	CX			;
	CALL	CXWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	DEC	CRXBRI			; 明度倍率（０ー１００）
	LOOP	HARFTONE03
	RET
HARFTONE	ENDP



;	ファイル名セット
;	-I- SI : ファイル名

FLSET	PROC	NEAR
	PUSH	AX
	PUSH	CX
	PUSH	DI

	MOV	AX,DS
	MOV	ES,AX

	MOV	AL,' '
	MOV	DI,OFFSET FLNM	; file name.
	MOV	CX,8
	REP	STOSB

	SETS	FLNM	; file name.

	POP	DI
	POP	CX
	POP	AX
	RET
FLSET	ENDP


;	属性ファイル名セット
;	-I- SI : ファイル名

FLSETT	PROC	NEAR
	PUSH	AX
	PUSH	CX
	PUSH	DI

	MOV	AX,DS
	MOV	ES,AX

	MOV	AL,' '
	MOV	DI,OFFSET FLNMT	; file name.
	MOV	CX,8
	REP	STOSB

	SETS	FLNMT	; file name.

	POP	DI
	POP	CX
	POP	AX
	RET
FLSETT	ENDP


CXWAIT	PROC	NEAR
	PUSH	CX
	MOV	CX,5000
CXWAIT2:
	LOOP	CXWAIT2
	POP	CX
	RET
CXWAIT	ENDP


;	カーソルボタンＯＦＦ待ち

MSWAT	PROC	NEAR
MSWAT1:
	PUSH	VX1
	PUSH	VY1
	CALL	PTPIC	; point pick.
	POP	VX1
	POP	VY1
	CMP	AX,0	; 0:normal,1:pic,2:exit
	JNE	MSWAT1	

	RET
MSWAT	ENDP


CODE	ENDS



;	タッチ属性バッファサイズ

TOUCH	SEGMENT	PUBLIC	'TOUCH'
EXTRN	TOPTCH:BYTE
TOUCH	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	MSCDAT:BYTE	; カーソルデータ

EXTRN	CRXVEW:WORD	; 色相回転（０ー３６０）
EXTRN	CRXCNS:WORD	; 彩度倍率（０ー１００）
EXTRN	CRXBRI:WORD	; 明度倍率（０ー１００）
EXTRN	CRXWHI:WORD	; ホワイトレベル（０ー１００）

EXTRN	ARAVRM:WORD	; vram area.

EXTRN	GX1:WORD
EXTRN	GY1:WORD
EXTRN	GX2:WORD
EXTRN	GY2:WORD
EXTRN	GMODE:WORD
EXTRN	GCODE:WORD
EXTRN	GCLR:WORD
EXTRN	GRD:WORD

EXTRN	CLRSOU:WORD		; 変更カラーパレット
EXTRN	CLRDES:WORD		; 変更後カラーパレット

EXTRN	VX1:WORD		; left side x.
EXTRN	VY1:WORD		; left side y.
EXTRN	VX2:WORD		; right side x.
EXTRN	VY2:WORD		; right side y.
EXTRN	ADRS:WORD		; address.
EXTRN	NUM:WORD		; number.

		;12345678
FLNM	DB	"        ",0		; file name.
FLNMT	DB	"        ","TCH",0	; file name.

		EVEN
USER_DRV	DW	0	; ユーザドライブ番号
USER_DRV_DEST	DW	0	; ユーザ書き込みドライブ番号

TOUCH_ATR	DW	0	; タッチ属性
TOUCH_STEP	DW	1	; タッチピックステップ

TUCOLDX		DW	0	; タッチＸ座標
TUCOLDY		DW	0	; タッチＹ座標

DATA	ENDS

	END
;
;	end of "TUCDAT.ASM"
;
