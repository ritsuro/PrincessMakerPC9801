; "MUSDAT.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;	マウスカーソルデータファイル作成
;
;

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	MUSDAT		; マウスカーソルデータファイル作成

PUBLIC	MCURMAKER	; 直接カーソルデータファイル作成


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

EXTRN	MSCSRT:NEAR	; カーソルスタート
EXTRN	MSCMOV:NEAR	; カーソル移動
EXTRN	MSCSTP:NEAR	; カーソルストップ

EXTRN	PTPIC:NEAR	; point pick.


EXTRN	LODBET:NEAR	; ベタファイルロード
EXTRN	SAVBET:NEAR	; ベタファイルセーブ

EXTRN	PATCLR:NEAR	; パーツセットクリア
EXTRN	PATGET:NEAR	; パーツＧＥＴ
EXTRN	PATGTA:NEAR	; パーツＧＥＴ圧縮無し
EXTRN	PATPUT:NEAR	; パーツＰＵＴ

EXTRN	VRMCLR:NEAR	; ＶＲＡＭクリア
EXTRN	DSP16M:NEAR	; １６色モードセット

EXTRN	CLRCHG:NEAR	; カラーチェンジ


MUSLENX		EQU	4	; マウスカーソルＸ長さ
MUSLENY		EQU	32	; マウスカーソルＹ長さ

MUSDATSIZE	EQU	4*32*5	; カーソルデータサイズ

; *******************************************
;	マウスカーソルデータファイル作成
; *******************************************
;	-I- DX : ドライブ番号

MUSDAT	PROC	NEAR
	MOV	USER_DRV,DX		; ユーザドライブ番号

	PRF	"マウスカーソルデータファイル作成[.DAT]"

	INP	"書き込みドライブ＝"
	CALL	STRDEC
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

MUSDAT_START:
	MOV	AX,USER_DRV	; ユーザドライブ番号
	CALL	DSKDR		; drive number set.

	CALL	VRMCLR		;ＶＲＡＭクリア

	INP	"ファイル名['Q':EXIT]＝"
	CALL	FLSET		; ファイル名セット

	PRF	"パレットファイル読み込み [*.ALG]"
	MOV	SI,OFFSET FLNM		; file name.
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	PRF	"ベタファイル読み込み [*.B1, *.R1, *.G1, *.E1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ベタファイルロード

	CALL	HARFTONE		; 明度を落とす


	INP	"マスクカラー番号"
	CALL	STRDEC
	MOV	MASK_COLOR,DX		; マスクカラー番号


	INP	"カーソルデータＧＥＴ（ＲＥＴキーを押して）"
	CALL	CLS		; text clear.
MUSDAT1:
	CALL	MSWAT		; カーソルボタンＯＦＦ待ち
	CALL	ARAPNT		; point pic.
	CALL	CLS		; text clear.
	CMP	AX,2		; ２＝強制終了
	JNE	MUSDAT2		;
	JMP	MUSDAT55	;
MUSDAT2:
	MOV	AX,VX1		;
	MOV	VRX,AX		; ＶＲＡＭ　Ｘ座標
	MOV	VRLENX,MUSLENX	; マウスカーソルＸ長さ

	MOV	AX,VY1		;
	MOV	VRY,AX		; ＶＲＡＭ　Ｙ座標
	MOV	VRLENY,MUSLENY	; マウスカーソルＹ長さ

;*DBG*;
;*DBG*;	PRVH	"VRX=",VRX	; ＶＲＡＭ　Ｘ座標
;*DBG*;	PRVH	"VRY=",VRY	; ＶＲＡＭ　Ｙ座標
;*DBG*;	PRVH	"VRLENX=",VRLENX	; Ｘ方向長さ
;*DBG*;	PRVH	"VRLENY=",VRLENY	; Ｙ方向長さ
;*DBG*;
;*DBG*;	INP	"???"

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR		; drive number set.

	PRS	"FLNM=",FLNM

	MOV	SI,OFFSET FLNM	; file name.
	CALL	MUSDATMAKER	; マウスカーソルデータファイル作成

	INP	"マウスある？[Q:'ない']"

	MOV	SI,OFFSET FLNM		; ファイル名
	MOV	DI,OFFSET MSCDAT	; カーソルデータ
	MOV	DX,SEG DATA		;
	MOV	CX,MUSDATSIZE		; カーソルデータサイズ
	CALL	DSKLD			; データロード

	
	CALL	MSCSRT			; カーソルスタート
	CALL	MSWAT			; カーソルボタンＯＦＦ待ち
MUSDAT44:				;
	CALL	MSCMOV			; カーソル移動
	CMP	DH,0			; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	MUSDAT45		;
	CMP	DL,0			; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	MUSDAT45		;
	JMP	MUSDAT44		;
MUSDAT45:				;
	CALL	MSCSTP			; カーソルストップ

MUSDAT55:				;
	RET
MUSDAT	ENDP


;	直接カーソルデータファイル作成
;	-I- DS:SI  : ファイル名
;	    VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ

MCURMAKER	PROC	NEAR
	MOV	MASK_COLOR,7	; マスクカラー番号
	CALL	MUSDATMAKER	; マウスカーソルデータファイル作成
	RET
MCURMAKER	ENDP




;	マウスカーソルデータファイル作成
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    DS:SI  : ファイル名
;	    MASK_COLOR : マスクカラー番号

MUSDATMAKER	PROC	NEAR
	CALL	DSKCRE		; file open & creat.
	CMP	AX,0		; AX : 0:normal, 1:open error.
	JNE	MUSDATMAKER_ERROR

	CALL	PATCLR		; パーツセットクリア
	CALL	PATGTA		; パーツＧＥＴ圧縮無し
	
	CALL	UMSKMK		; マスク部分の透明化

	MOV	MAX_PLEAN,3	; 最大プレーン番号（可変可能）
	CALL	MPATSAVE	; マウスパターンＶＲＡＭセーブ
	CMP	AX,0		; 0=正常,1=エラー
	JNE	MUSDATMAKER_ERROR

	MOV	CX,0		; パーツ番号
	CALL	PATPUT		; パーツＰＵＴ

	CALL	MASKMK		; マスク作成

	MOV	MAX_PLEAN,0	; 最大プレーン番号（可変可能）
	CALL	MPATSAVE	; マウスパターンＶＲＡＭセーブ
	CMP	AX,0		; 0=正常,1=エラー
	JNE	MUSDATMAKER_ERROR

	MOV	CX,0		; パーツ番号
	CALL	PATPUT		; パーツＰＵＴ

	CALL	DSKCLS		; file close.
	RET
MUSDATMAKER_ERROR:
	MOV	CX,0		; パーツ番号
	CALL	PATPUT		; パーツＰＵＴ

	CALL	DSKCLS		; file close.
	PRF	"ファイル書き込みエラー"
;*DBG*;	INP	"??"
	RET
MUSDATMAKER	ENDP



;	マスク部分の透明化
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    MASK_COLOR : マスクカラー番号

UMSKMK	PROC	NEAR
	MOV	AX,VRX		; ＶＲＡＭ　Ｘ座標
	MOV	VX1,AX		; 開始座標

	MOV	BX,VRY		; ＶＲＡＭ　Ｙ座標
	MOV	VY1,BX		; 開始座標

	ADD	AX,VRLENX	; Ｘ方向長さ
	DEC	AX		;
	MOV	VX2,AX		; 終了座標

	ADD	BX,VRLENY	; Ｙ方向長さ
	DEC	BX		;
	MOV	VY2,BX		; 終了座標

	MOV	CLRSOU,1	; 変更カラーパレット
	MOV	CX,15		;
UMSKMK_LOOP:			;
	MOV	AX,CLRSOU	; 変更カラーパレット
	CMP	AX,MASK_COLOR	; マスクカラー番号
	JE	UMSKMK3		;
	MOV	AX,CLRSOU	; 変更カラーパレット
	MOV	CLRDES,AX	; 変更後カラーパレット
	JMP	UMSKMK4		;
UMSKMK3:			;
	MOV	CLRDES,0	; 変更後カラーパレット（透明色）
UMSKMK4:			;
	PUSH	CX		;
	CALL	CLRCHG		; カラーチェンジ
	POP	CX		;
	INC	CLRSOU		; 変更カラーパレット
	LOOP	UMSKMK_LOOPE	;
	RET
UMSKMK_LOOPE:			;
	JMP	UMSKMK_LOOP	;
UMSKMK	ENDP



;	マスク作成
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    MASK_COLOR : マスクカラー番号

MASKMK	PROC	NEAR
;*DBG*;	PRVH	"VRX=",VRX	; ＶＲＡＭ　Ｘ座標
;*DBG*;	PRVH	"VRY=",VRY	; ＶＲＡＭ　Ｙ座標
;*DBG*;	PRVH	"VRLENX=",VRLENX	; Ｘ方向長さ
;*DBG*;	PRVH	"VRLENY=",VRLENY	; Ｙ方向長さ

	MOV	AX,VRX		; ＶＲＡＭ　Ｘ座標
	MOV	VX1,AX		; 開始座標

	MOV	BX,VRY		; ＶＲＡＭ　Ｙ座標
	MOV	VY1,BX		; 開始座標

	ADD	AX,VRLENX	; Ｘ方向長さ
	DEC	AX		;
	MOV	VX2,AX		; 終了座標

	ADD	BX,VRLENY	; Ｙ方向長さ
	DEC	BX		;
	MOV	VY2,BX		; 終了座標
;*DBG*;
;*DBG*;	PRV	"VX1=",VX1
;*DBG*;	PRV	"VY1=",VY1
;*DBG*;	PRV	"VX2=",VX2
;*DBG*;	PRV	"VY2=",VY2
;*DBG*;	INP	"???MASK"
;*DBG*;

	MOV	CLRSOU,15	; 変更カラーパレット
	MOV	CX,15		;
MASKMK_LOOP:			;
	MOV	AX,CLRSOU	; 変更カラーパレット
	CMP	AX,MASK_COLOR	; マスクカラー番号
	JE	MASKMK3		;
	MOV	CLRDES,0	; 変更後カラーパレット（抜き）
	JMP	MASKMK4		;
MASKMK3:			;
	MOV	CLRDES,15	; 変更後カラーパレット（透明色）
MASKMK4:			;

;*DBG*;	PRV	"CLRSOU=",CLRSOU	; 変更カラーパレット
;*DBG*;	PRV	"CLRDES=",CLRDES	; 変更後カラーパレット
;*DBG*;	PRV	"VX1=",VX1
;*DBG*;	PRV	"VY1=",VY1
;*DBG*;	PRV	"VX2=",VX2
;*DBG*;	PRV	"VY2=",VY2
;*DBG*;	INP	"???LOOP"

	PUSH	CX		;
	CALL	CLRCHG		; カラーチェンジ
	POP	CX		;
	DEC	CLRSOU		; 変更カラーパレット
	LOOP	MASKMK_LOOPE	;
	RET
MASKMK_LOOPE:			;
	JMP	MASKMK_LOOP	;
MASKMK	ENDP



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




; ***************************************
;	ＶＲＡＭアクセス
; ***************************************

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PLSBUFMAX	EQU	4*32*4		; データバッファサイズ
ADDWIDTH	EQU	80		; 次のラインアドレス計算用



;	マウスパターンＶＲＡＭセーブ
;	（ファイルをオープンしておくこと）
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	-O- AX: 0=正常,1=エラー

MPATSAVE	PROC	NEAR
	CALL	VRAM_TO_WORK	; ＶＲＡＭ－＞データワークバッファコピー

	MOV	AX,SEG PLSBUF		; 対象データセグメント
	MOV	ES,AX			;
	MOV	DI,OFFSET PLSBUF_TOP	; 対象データオフセット

MPATSAVE2:
	MOV	AL,ES:[DI]	; 1 byte data
	INC	DI		;

	PUSH	ES
	PUSH	DI
	CALL	DSKWRT		; save 1 byte data.
	POP	DI
	POP	ES

	CMP	AH,0		; 0:normal  1:write error
	JNE	MPATSAVE_ERROR	;

	CMP	DI,PLSDATEND	; 対象データの終わりアドレス
	JE	MPATSAVE9
	JMP	MPATSAVE2
MPATSAVE9:
	PRV	"DI=",DI
	MOV	AX,0		; 0=正常
	RET
MPATSAVE_ERROR:
	MOV	AX,1		; 1=エラー
	RET
MPATSAVE	ENDP



;	ＶＲＡＭ－＞データワークバッファコピー
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	-O- PLSBUF:[PLSBUF_TOP] : 対象データ
;	    PLSDATEND : 対象データの終わりアドレス
;	    VRPLN     : 現在は使われていないﾌﾟﾚｰﾝ番号
;	    VROFST    : 対象データの先頭アドレス

VRAM_TO_WORK	PROC	NEAR
	CALL	VRMINI		; vram access init.
	MOV	AX,SEG PLSBUF	;
	MOV	ES,AX		;
	MOV	DI,OFFSET PLSBUF_TOP
	MOV	CX,PLSBUFMAX	; データ圧縮用ワークバッファサイズ
VRAM_TO_WORK1:
	PUSH	CX		;
	PUSH	DI		;
	PUSH	ES		;
	CALL	VRAMGET		; get 1 byte vram.
	POP	ES		;
	POP	DI		;
	POP	CX		;
	CMP	AH,0		; AH : 0:normal 1:data end.
	JNE	VRAM_TO_WORK9	;
	STOSB			; AL : 1 byte data.
	LOOP	VRAM_TO_WORK1	;
VRAM_TO_WORK9:
	MOV	PLSDATEND,DI	; 圧縮対象データの終わりアドレス
	MOV	VRPLN,0		; 現在は使われていないﾌﾟﾚｰﾝ番号
	MOV	AX,OFFSET PLSBUF_TOP
	MOV	VROFST,AX	; vram offset.
	RET
VRAM_TO_WORK	ENDP



; get 1 byte vram.
; -o- AL : 1 byte data.
;     AH : 0:normal 1:data end.

VRAMGET	PROC	NEAR
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AX,WORD PTR VRPLN	; プレーン番号
	CMP	AX,MAX_PLEAN		; 最大プレーン番号
	JLE	VRAMGET1

	MOV	AH,1			; data end.

	POP	DX
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

	INC	VROFST			;

	INC	VRPX			;
	MOV	BX,VRPX			;
	CMP	BX,VRLENX		; x length.
	JB	VRAMGET9		;

	ADD	VROFSTSHIFT,ADDWIDTH	; vram offset shift.
	MOV	BX,VROFSTSHIFT		;
	MOV	VROFST,BX		; next line.

	MOV	VRPX,0			;
	INC	VRPY			;
	MOV	BX,VRPY			;
	CMP	BX,VRLENY		;
	JB	VRAMGET9		;

	INC	VRPLN		; inc vram plean.
	MOV	BX,VROFSTBASE	; vram offset base.
	MOV	VROFSTSHIFT,BX	; vram offset shift.
	MOV	VROFST,BX	; vram offset

	MOV	VRPX,0		; x plot.
	MOV	VRPY,0		; y plot.
VRAMGET9:
	MOV	AH,0			; normal.

	POP	DX
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

	MOV	BX,VRY		;
	SHL	BX,1		;
	SHL	BX,1		;  point address.
	SHL	BX,1		;
	SHL	BX,1		;  bx = VRY * 80 + VRX
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,VRX		;
	MOV	VROFST,BX	; vram offset.
	MOV	VROFSTBASE,BX	; vram offset base.
	MOV	VROFSTSHIFT,BX	; vram offset shift.

	MOV	VRPX,0		; x plot.
	MOV	VRPY,0		; y plot.

	MOV	BCOUNT,0	; データ長さ
	MOV	AX,BPNTOF	; データバッファポインタ
	MOV	BPOINT,AX	;

	RET
VRMINI	ENDP


CODE	ENDS



;	データ圧縮用ワークバッファ

PLSBUF	SEGMENT
PLSBUF_TOP	LABEL	BYTE
	DB	PLSBUFMAX DUP (0)
PLSBUF	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

ARASEG	DW	0,0,0,0		; segment table.

VRMOFS	DW	0		; vram offset address.


BPOINT		DW	0	; data buffer point.
BPNTOF		DW	0	; データバッファポインタ
BPNTSG		DW	0	; データバッファセグメント
BCNTMX		DW	0	; データ最大長さ
BCOUNT		DW	0	; データ長さ


MAX_PLEAN	DW	3	; 最大プレーン番号（可変可能）


PLSDATEND	DW	0	; 圧縮対象データの終わりアドレス


VRPLN		DW	0	; vram segment.
VROFST		DW	0	; vram offset.
VROFSTBASE	DW	0	; vram offset base.
VROFSTSHIFT	DW	0	; vram offset shift.

EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

VRPX	DW	0		; x plot.
VRPY	DW	0		; y plot.

VRPLNBAK	DW	3 DUP (0)	; vram segment back.
VROFSTBAK	DW	3 DUP (0)	; vram offset back.

DTLEN	DW	0		; data length.
DTIMG	DW	0		; data image.

DATA	ENDS

; ***************************************
;	ＶＲＡＭアクセス終わり
; ***************************************






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

FLNM	DB	"        ","MUS",0	; file name.

USER_DRV	DW	0	; ユーザドライブ番号
USER_DRV_DEST	DW	0	; ユーザ書き込みドライブ番号

MASK_COLOR	DW	1	; マスクカラー番号

MX1	DW	0	; Ｘ座標左上
MY1	DW	0	; Ｙ座標左上
MX2	DW	0	; Ｘ座標右下
MY2	DW	0	; Ｙ座標右下

DATA	ENDS

	END
;
;	end of "MUSDAT.ASM"
;
