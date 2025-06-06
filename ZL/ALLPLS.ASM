; "ALLPLS.ASM" PC-9801UV11 make by R.H 1990/05/17
;
;	自動取り込み工程
;
;

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	ALLPLS		; 自動取り込み工程

EXTRN	MSKPLNGET:NEAR	; マスク化データＧＥＴ
EXTRN	MSKDATGET:NEAR	; マスク抜きデータＧＥＴ

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
EXTRN	PATPTX:NEAR	; パーツＰＵＴ座標指定
EXTRN	PATPTF:NEAR	; パーツＰＵＴオフセット指定
EXTRN	PATSAV:NEAR	; パーツセーブ
EXTRN	PATLOD:NEAR	; パーツロード
EXTRN	PATLDA:NEAR	; パーツ追加ロード
EXTRN	PATGTM:NEAR	; マスクパーツＧＥＴ
EXTRN	PATPTM:NEAR	; マスクパーツＰＵＴ
EXTRN	PATPXM:NEAR	; マスクパーツＰＵＴ座標指定
EXTRN	PATOPE:NEAR	; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

EXTRN	PLSMOD:NEAR	; 圧縮モード切り替え

EXTRN	BPPPTS:NEAR	; パレットファイルをパーツバッファへ

EXTRN	PATSIZ:NEAR	; パーツサイズのＧＥＴ

EXTRN	VRMCLR:NEAR	; ＶＲＡＭクリア

EXTRN	TXTBOX:NEAR	; テキスト属性ＢＯＸセット





; *******************************************
;	自動取り込み工程
;	-I- DX : ドライブ番号
; *******************************************

ALLPLS	PROC	NEAR
	MOV	USER_DRV,DX		; ユーザドライブ番号


	PRF	"自動取り込み工程 [*.PT1]"


	CALL	HARFBR			; 明度５０％


	CALL	INPUT_SIZE		; サイズ指定
	CMP	FRAME_NUM,0		; フレーム番号
	JUMP_EQ	ALLPLS_EXIT		;


	CALL	INPUT_FILENM		; ファイル名指定
	CMP	FILE_MAX,0		; 指定ファイル数
	JUMP_EQ	ALLPLS_EXIT		;

	CALL	FLDUMP			; ファイル名ダンプ

	INP	"圧縮方向指定[1=縦方向]"
	CALL	STRDEC			;
	AND	DX,1			; flags.
	MOV	PLSDIR_FLG,DX		; 圧縮方向指定[1=縦方向]


	INP	"完成データを書き込むドライブ番号="
	CALL	STRDEC			;
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号


	INP	"パレット読みますね [1=読まないってば]="
	CALL	STRDEC			;
	AND	DX,1			; flags.
	MOV	PALET_OFF,DX		; 1=パレット読み込み中止

	LF
	LF
ALLPLS_LOOP:
	MOV	FLNM_WRITE,'X'		; write file name TOP.

	CALL	FLGET			; 指定ファイル名ＧＥＴ
	CMP	AX,1			; 1=終了
	JUMP_EQ	ALLPLS_EXIT		;

	CALL	FLSET			; ファイル名セット

	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

	MOV	DX,PLSDIR_FLG		; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え

	CALL	HARFBR			; 明度５０％


	PRF	"ベタファイル読み込み [*.B1, *.R1, *.G1, *.E1]"

	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ベタファイルロード

	MOV	SIZE_PNT,0		; 指定サイズポインタ=0
ALLPLS_SIZE_LOOP:
	CALL	TITLES			; タイトル

	PRS	"ただいまのファイル:",FLNM

	CALL	PATCLR			; パーツセットクリア

	CMP	PALET_OFF,1		; 1=パレット読み込み中止
	JE	ALLPLS_PALET_SKIP	;

	MOV	SI,OFFSET FLNM		; file name.
	CALL	BPPPTS			; パレットファイルをパーツバッファへ
ALLPLS_PALET_SKIP:

	MOV	SI,SIZE_PNT		; 指定サイズポインタ=0
	SHL	SI,1			; word pointer.
	MOV	AX,SIZE_VRX[SI]		; ＶＲＡＭ　Ｘ座標
	MOV	BX,SIZE_VRY[SI]		; ＶＲＡＭ　Ｙ座標
	MOV	CX,SIZE_VRLENX[SI]	; Ｘ方向長さ
	MOV	DX,SIZE_VRLENY[SI]	; Ｙ方向長さ
	MOV	VRX,AX			;
	MOV	VRY,BX			;
	MOV	VRLENX,CX		;
	MOV	VRLENY,DX		;

	CMP	MASK_ON_FLAG,1		;マスク処理0=何もしない,1=マスク化処理
	JE	ALLPLS_PALET_MASK	;

	CALL	PATGET			; パーツＧＥＴ
	JMP	ALLPLS_PALET_55		;
ALLPLS_PALET_MASK:			;

	CALL	MASK_MAKER		; マスク化データ
ALLPLS_PALET_55:			;


	CMP	AX,0			;
	JE	ALLPLS_NOERROR		;

	PRF	"ＰＡＴＧＥＴ　エラー発生"

	PRS	"ファイル名:",FLNM

	INP	"プログラマに連絡せよ"
	INP	"2:WAIT"
	INP	"1:WAIT"

	JMP	ALLPLS_EXIT
ALLPLS_NOERROR:
	PRVH	"データ長さ              BCOUNT=",BCOUNT



	;	"復元（ＲＥＴキーを押して）"

	MOV	DX,PLSDIR_FLG		; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え

	MOV	CX,1			; パーツ番号チェック
	CALL	PATPUT			; パーツＰＵＴ


	PRVH	"PATPUT 0:normal end. 1:error.AX=",AX


	CMP	SIZE_MAX,1		; 指定サイズ数
	JE	ALLPLS_4442		;
	MOV	SI,OFFSET FLNM_WRITE	;
	JMP	ALLPLS_4444		;
ALLPLS_4442:				;
	MOV	SI,OFFSET FLNM		;
ALLPLS_4444:				;
	PUSH	SI
	PR	"パーツファイル書き込み ["
	POP	SI
	CALL	PRINT
	PRF	".PT1]"

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.


	CMP	SIZE_MAX,1		; 指定サイズ数
	JE	ALLPLS_5552		;
ALLPLS_5551:
	MOV	SI,OFFSET FLNM_WRITE	; write file name."X???????"
	CALL	PATSAV			; パーツセーブ
	JMP	ALLPLS_5555		;
ALLPLS_5552:
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATSAV			; パーツセーブ
ALLPLS_5555:


	INC	SIZE_PNT		; 指定サイズポインタ

	MOV	AX,SIZE_PNT		; 指定サイズポインタ
	CMP	AX,SIZE_MAX		; 指定サイズ数
	JGE	ALLPLS_NEXT		;

	DEC	FLNM_WRITE	; write file name.("X*"->"W*"->"V*"->"U*"...)

	JMP	ALLPLS_SIZE_LOOP

ALLPLS_NEXT:
	JMP	ALLPLS_LOOP		;

ALLPLS_EXIT:
	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え

	RET
ALLPLS	ENDP


; *******************************************
;	マスク化データ
;	データ復元
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    MASK_COLOR : マスク処理 透明色
;	    PLSDIR_FLG : 圧縮モード(0:通常,1:縦方向)必ず０にします
; *******************************************

MASK_MAKER	PROC	NEAR
	MOV	DX,PLSDIR_FLG		; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え

	MOV	CX,MASK_COLOR		; マスクカラー番号
	CALL	MSKPLNGET		; マスク化データＧＥＴ

	PRF	"(mask)ベタファイル読み込み [*.B1, *.R1, *.G1, *.E1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ベタファイルロード

	MOV	CX,MASK_COLOR		; マスク処理 透明色
	CALL	MSKDATGET		; マスク抜きデータＧＥＴ

	RET
MASK_MAKER	ENDP


;	タイトル

TITLES	PROC	NEAR

	PRF	"	�ｮ�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�ｲ"
	PRF	"	�､　　　　　　　　　　　　　　　　　�､"
	PRF	"	�､　　　圧縮プログラム実行中　　　　�､"
	PRF	"	�､　　　　「とめないでね」　　　　　�､"
	PRF	"	�､　　　　　　　　　　　　　　　　　�､"
	PRF	"	�ｶ�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�ｺ"
	PRF	"	1990 (C) r.hashimoto"

	PRV	"ファイル数    :",FILE_MAX
	PRV	"処理ファイル数:",FILE_PNT

	RET
TITLES	ENDP



;	サイズ指定
;	-O- SIZE_VRX[]    : ＶＲＡＭ　Ｘ座標
;	    SIZE_VRY[]    : ＶＲＡＭ　Ｙ座標
;	    SIZE_VRLENX[] : Ｘ方向長さ
;	    SIZE_VRLENY[] : Ｙ方向長さ
;	    SIZE_MAX      : 指定サイズ数
;	    SIZE_PNT      : 指定サイズポインタ=0
;	    FRAME_NUM     : フレーム番号(0=なにもしない)
;
;	    MASK_ON_FLAG  : マスク処理 0=何もしない, 1=マスク化処理
;	    MASK_COLOR    : マスク処理 透明色

INPUT_SIZE	PROC	NEAR
	MOV	FRAME_NUM,0			; フレーム番号

	MOV	MASK_ON_FLAG,0			; マスク処理 0=何もしない
						; 1=マスク化処理
	MOV	MASK_COLOR,0			; マスク処理 透明色

	PRF	" どのフレームにしますか？"
PRF " 1:ＯＰ，ＥＤビジュアル 60(480) x 230  2:メインウインドウ 46(368) x 200"
PRF " 3:イベントウインドウ   39(312) x 160  4:人物             17(136) x 140"
PRF " 5:アイテム             13(104) x  92  6:貴方が決める  user X  x user Y"
PRF " 7:全画面の２分割       40(320) x 400 x 2   8:戦闘        20(160) x 146"
PRF " 9:モンスター           32(256) x 190 10:電脳１クイズget54,17 24(192)x367"
	PRF	"11:「子育て」メイン画面の２分割 200(25) x 274 + 440(55) x 274"
	PRF	"12:「子育て」メインＢＧの２分割 200(25) x 336 + 200(25) x 336"
	PRF	"13:「子育て」ビジュアル　　　　 440(55) x 240"
	PRF	"14:「子育て」オチ・フレーム　　 320(40) x 180"
	PRF	"15:「子育て」ミスコン・フレーム 128(16) x 180"
	PRF	"16:「子育て」モンスタ・マスク化 264(33) x 260"
	PRF	"17:「子育て」12:の原点寄せ　　　200(25) x 336 + 200(25) x 336"
	PRF	"18:「子育て」１０才マスク    19:「子育て」１２才マスク"
	PRF	"20:「子育て」１４才マスク    21:「子育て」１６才マスク"
	PRF	"22:「子育て」イベントウインドウ　26(208) x 144"
	PRF	"23:「子育て」フェイス・フレーム  96(12) x 104"
	PRF	"24:「子育て」１１才マスク    25:「子育て」１３才マスク"
	PRF	"26:「子育て」１５才マスク    27:「子育て」１７才マスク"
INPUT_SIZE_LOOP:
	INP	" 番号:"
	CALL	STRDEC
	CMP	DX,0
	JE	INPUT_SIZE_LOOP
	CMP	DX,27				; 27=max.
	JG	INPUT_SIZE_LOOP

	MOV	BX,DX				;
	SHL	BX,1				; word pointer.
	JMP	CS:INPUT_SIZE_LABEL[BX]		; on goto.
INPUT_SIZE_LABEL	LABEL	WORD		;
	DW	0
	DW	OFFSET INPUT_SIZE_1
	DW	OFFSET INPUT_SIZE_2
	DW	OFFSET INPUT_SIZE_3
	DW	OFFSET INPUT_SIZE_4
	DW	OFFSET INPUT_SIZE_5
	DW	OFFSET INPUT_SIZE_6
	DW	OFFSET INPUT_SIZE_7
	DW	OFFSET INPUT_SIZE_8
	DW	OFFSET INPUT_SIZE_9
	DW	OFFSET INPUT_SIZE_10
	DW	OFFSET INPUT_SIZE_11
	DW	OFFSET INPUT_SIZE_12
	DW	OFFSET INPUT_SIZE_13
	DW	OFFSET INPUT_SIZE_14
	DW	OFFSET INPUT_SIZE_15
	DW	OFFSET INPUT_SIZE_16
	DW	OFFSET INPUT_SIZE_17
	DW	OFFSET INPUT_SIZE_18
	DW	OFFSET INPUT_SIZE_19
	DW	OFFSET INPUT_SIZE_20
	DW	OFFSET INPUT_SIZE_21
	DW	OFFSET INPUT_SIZE_22
	DW	OFFSET INPUT_SIZE_23

	DW	OFFSET INPUT_SIZE_24
	DW	OFFSET INPUT_SIZE_25
	DW	OFFSET INPUT_SIZE_26
	DW	OFFSET INPUT_SIZE_27

INPUT_SIZE_1:
;*;	PRF	" 1:ＯＰ，ＥＤビジュアル	60(480) x 230"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,60			; Ｘ方向長さ
	MOV	SIZE_VRLENY,230			; Ｙ方向長さ
	MOV	FRAME_NUM,1			; フレーム番号
	RET
INPUT_SIZE_2:
;*;	PRF	" 2:メインウインドウ		46(368) x 200"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,46			; Ｘ方向長さ
	MOV	SIZE_VRLENY,200			; Ｙ方向長さ
	MOV	FRAME_NUM,2			; フレーム番号
	RET
INPUT_SIZE_3:
;*;	PRF	" 3:イベントウインドウ		39(312) x 160"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,39			; Ｘ方向長さ
	MOV	SIZE_VRLENY,160			; Ｙ方向長さ
	MOV	FRAME_NUM,3			; フレーム番号
	RET
INPUT_SIZE_4:
;*;	PRF	" 4:人物			17(136) x 140"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,17			; Ｘ方向長さ
	MOV	SIZE_VRLENY,140			; Ｙ方向長さ
	MOV	FRAME_NUM,4			; フレーム番号
	RET
INPUT_SIZE_5:
;*;	PRF	" 5:アイテム			13(104) x  92"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,13			; Ｘ方向長さ
	MOV	SIZE_VRLENY,92			; Ｙ方向長さ
	MOV	FRAME_NUM,5			; フレーム番号
	RET
INPUT_SIZE_6:
	PRF	" 6:貴方が決める		user X  x user Y"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標

	INP	"Ｘ方向長さ="
	CALL	STRDEC
	MOV	SIZE_VRLENX,DX			; Ｘ方向長さ

	INP	"Ｙ方向長さ="
	CALL	STRDEC
	MOV	SIZE_VRLENY,DX			; Ｙ方向長さ

	MOV	FRAME_NUM,6			; フレーム番号
	RET

INPUT_SIZE_7:
;*;	PRF	" 7:全画面の２分割　　　	40(320) x 400 x 2"

	MOV	SIZE_MAX,2			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],0			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],40		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	SIZE_VRX[2],40			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[2],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[2],40		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[2],400		; 指定ＰＵＴ座標Ｙ

	MOV	FRAME_NUM,7			; フレーム番号
	RET
INPUT_SIZE_8:
;*;	PRF	" 8:戦闘			20(160) x  146"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,20			; Ｘ方向長さ
	MOV	SIZE_VRLENY,146			; Ｙ方向長さ
	MOV	FRAME_NUM,8			; フレーム番号
	RET
INPUT_SIZE_9:
;*;	PRF	" 9:モンスター			32(256) x  190"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,32			; Ｘ方向長さ
	MOV	SIZE_VRLENY,190			; Ｙ方向長さ
	MOV	FRAME_NUM,9			; フレーム番号
	RET
INPUT_SIZE_10:
;*;	PRF	"10:電脳１クイズ		get 54,17	24(192) x  367"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,54			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,17			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,24			; Ｘ方向長さ
	MOV	SIZE_VRLENY,367			; Ｙ方向長さ
	MOV	FRAME_NUM,10			; フレーム番号
	RET

INPUT_SIZE_11:
;*;	PRF	"11:「子育て」メイン画面の２分割 200(25) x 274 + 440(55) x 274"

	MOV	SIZE_MAX,2			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],0			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],25		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],274		; 指定ＰＵＴ座標Ｙ

	MOV	SIZE_VRX[2],25			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[2],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[2],55		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[2],274		; 指定ＰＵＴ座標Ｙ

	MOV	FRAME_NUM,11			; フレーム番号
	RET
INPUT_SIZE_12:
;*;	PRF	"12:「子育て」メインＢＧの２分割 200(25) x 336 + 200(25) x 336"

	MOV	SIZE_MAX,2			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],1			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],32			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],25		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],336		; 指定ＰＵＴ座標Ｙ

	MOV	SIZE_VRX[2],26			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[2],32			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[2],25		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[2],336		; 指定ＰＵＴ座標Ｙ

	MOV	FRAME_NUM,12			; フレーム番号
	RET
INPUT_SIZE_13:
;*;	PRF	"13:「子育て」ビジュアル　　　　 440(55) x 240"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],0			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],55		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],240		; 指定ＰＵＴ座標Ｙ

	MOV	FRAME_NUM,13			; フレーム番号
	RET
INPUT_SIZE_14:
;*;	PRF	"14:「子育て」オチ・フレーム　　 320(40) x 180"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],0			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],40		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],180		; 指定ＰＵＴ座標Ｙ

	MOV	FRAME_NUM,14			; フレーム番号
	RET
INPUT_SIZE_15:
;*;	PRF	"15:「子育て」ミスコン・フレーム 128(16) x 180"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],0			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],16		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],180		; 指定ＰＵＴ座標Ｙ

	MOV	FRAME_NUM,15			; フレーム番号
	RET
INPUT_SIZE_16:
;*;	PRF	"16:「子育て」モンスタ・マスク化 264(33) x 260"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],0			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],33		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],260		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,16			; フレーム番号
	RET
INPUT_SIZE_17:
;*;	PRF	"17:「子育て」12:の原点寄せ　　　200(25) x 336 + 200(25) x 336"

	MOV	SIZE_MAX,2			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],0			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],25		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],336		; 指定ＰＵＴ座標Ｙ

	MOV	SIZE_VRX[2],25			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[2],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[2],25		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[2],336		; 指定ＰＵＴ座標Ｙ

	MOV	FRAME_NUM,17			; フレーム番号
	RET
INPUT_SIZE_18:
;*;	PRF	"18:「子育て」１０才マスク"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],22			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],61-22		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,18			; フレーム番号
	RET
INPUT_SIZE_19:
;*;	PRF	"19:「子育て」１２才マスク"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],18			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],55-18		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,19			; フレーム番号
	RET
INPUT_SIZE_20:
;*;	PRF	"20:「子育て」１４才マスク"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],18			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],52-18		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,20			; フレーム番号
	RET
INPUT_SIZE_21:
;*;	PRF	"21:「子育て」１６才マスク"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],18			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],56-18		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,21			; フレーム番号
	RET
INPUT_SIZE_22:
;*;	PRF	"22:「子育て」イベントウインドウ　26(208) x 144"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,26			; Ｘ方向長さ
	MOV	SIZE_VRLENY,144			; Ｙ方向長さ
	MOV	FRAME_NUM,22			; フレーム番号
	RET
INPUT_SIZE_23:
;*;	PRF	"23:「子育て」フェイス・フレーム 96(12) x 104"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,12			; Ｘ方向長さ
	MOV	SIZE_VRLENY,104			; Ｙ方向長さ
	MOV	FRAME_NUM,23			; フレーム番号
	RET
INPUT_SIZE_24:
;*;	24:「子育て」１１才マスク

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],20			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],52-20		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,24			; フレーム番号
	RET
INPUT_SIZE_25:
;*;	25:「子育て」１３才マスク

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],21			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],56-21		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,25			; フレーム番号
	RET
INPUT_SIZE_26:
;*;	26:「子育て」１５才マスク

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],16			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],47-16		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,26			; フレーム番号
	RET
INPUT_SIZE_27:
;*;	27:「子育て」１７才マスク

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX[0],15			; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRY[0],0			; 指定ＰＵＴ座標Ｙ
	MOV	SIZE_VRLENX[0],48-15		; 指定ＰＵＴ座標Ｘ
	MOV	SIZE_VRLENY[0],400		; 指定ＰＵＴ座標Ｙ

	MOV	MASK_ON_FLAG,1			; マスク処理 0=何もしない
						; 1=マスク化処理

	INP	"マスク処理 透明色="		;
	CALL	STRDEC				;
	MOV	MASK_COLOR,DX			; マスク処理 透明色

	MOV	FRAME_NUM,27			; フレーム番号
	RET
INPUT_SIZE	ENDP



;	ファイル名指定
;	-I- FILE_UPPER  : 指定ファイル数上限
;	-O- FILE_MAX    : 指定ファイル数
;	    FILE_PNT    : 指定ファイルポインタ
;	    FILE_TABLE[]: ファイル名テーブル

INPUT_FILENM	PROC	NEAR
	PR	"ファイル名指定[合計"
	MOV	DX,FILE_UPPER		; 指定ファイル数上限
	CALL	DECSTR
	CALL	PRINT
	PRF	"個まで]"

	MOV	FILE_MAX,0		; 指定ファイル数
	MOV	FILE_PNT,0		; 指定ファイルポインタ
INPUT_FILENM_LOOP:
	MOV	AX,FILE_PNT		; 指定ファイルポインタ
	CMP	AX,FILE_UPPER		; 指定ファイル数上限
	JGE	INPUT_FILENM_EXIT	;

INPUT_FILENM_INP:
	PR	"ファイル名["
	MOV	DX,FILE_PNT
	INC	DX
	CALL	DECSTR
	CALL	PRINT
	INP	"番目]="
	CMP	BYTE PTR DS:[SI],' '
	JB	INPUT_FILENM_EXIT

	MOV	BX,FILE_PNT		; 指定ファイルポインタ
	SHL	BX,1			; word pointer.
	MOV	DI,DS:FILE_TABLE[BX]	; ファイル名テーブル

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	CX,8			; limit=7.
INPUT_FILENM_SET:			;
	LODSB				;
	CMP	AL,' '			; space.
	JB	INPUT_FILENM_SET_OK	;
	STOSB				;
	LOOP	INPUT_FILENM_SET	;
INPUT_FILENM_SET_OK:			;
	MOV	AL,0			; end of string.
	STOSB				;

	INC	FILE_PNT		; 指定ファイルポインタ


	JMP	INPUT_FILENM_LOOP


INPUT_FILENM_EXIT:			;
	MOV	AX,FILE_PNT		; 指定ファイルポインタ
	MOV	FILE_MAX,AX		; 指定ファイル数

	MOV	FILE_PNT,0		; 指定ファイルポインタ

	RET
INPUT_FILENM	ENDP




;	指定ファイル名ＧＥＴ
;	-I-   FILE_MAX    : 指定ファイル数
;	-I/O- FILE_PNT    : 指定ファイルポインタ
;	      FILE_TABLE[]: ファイル名テーブル
;	-O-   SI          : ファイル名
;	      AX          : 1=終了,0=通常

FLGET	PROC	NEAR
	MOV	AX,FILE_PNT		; 指定ファイルポインタ
	CMP	AX,FILE_MAX		; 指定ファイル数
	JGE	FLGET_END		; 終了か？

	MOV	BX,FILE_PNT		; 指定ファイルポインタ
	SHL	BX,1			; word pointer.
	MOV	SI,DS:FILE_TABLE[BX]	; ファイル名テーブル

	INC	FILE_PNT		; 指定ファイルポインタ

	MOV	AX,0			; 0=通常
	RET
FLGET_END:
	MOV	AX,1			; 1=終了
	RET
FLGET	ENDP




;	ファイル名ダンプ
;	-I-   FILE_MAX    : 指定ファイル数
;	      FILE_TABLE[]: ファイル名テーブル

FLDUMP	PROC	NEAR
	PRV	"指定ファイル数は ",FILE_MAX

	MOV	BX,0
	MOV	CX,FILE_MAX		; 指定ファイル数
FLDUMP_LOOP:
	PR	"ファイル名["
	MOV	DX,BX
	SHR	DX,1
	INC	DX
	CALL	DECSTR
	CALL	PRINT
	PR	"番目]:"

	MOV	SI,DS:FILE_TABLE[BX]	; ファイル名テーブル
	CALL	PRINT

	LF

	INC	BX
	INC	BX

	LOOP	FLDUMP_LOOP

	RET
FLDUMP	ENDP






;	明度５０％

HARFBR	PROC	NEAR
	MOV	BX,0
	PRF	"明度５０％"
	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	CALL	PLPSET			; パレット編集セット
	MOV	CX,50			;
HARFBR3:				;
	PUSH	CX			;
	CALL	CXWAIT			;
	CALL	CXWAIT			;
	CALL	CXWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	DEC	CRXBRI			; 明度倍率（０ー１００）
	LOOP	HARFBR3			;

	RET
HARFBR	ENDP


;	ファイル名セット
;	-I/O- SI          : ファイル名
;	-O-   FLNM        : file name.
;	      FLNM_WRITE  : write file name.("??????"->"X??????")

FLSET	PROC	NEAR
	PUSH	AX
	PUSH	CX
	PUSH	DI

	MOV	AX,DS
	MOV	ES,AX

	MOV	BYTE PTR DS:[SI][8],0	; end of string.

	MOV	AL,' '
	MOV	DI,OFFSET FLNM		; file name.
	MOV	CX,8
	REP	STOSB

	MOV	AL,' '
	MOV	DI,OFFSET FLNM_WRITE2	; write file name.(skip top)
	MOV	CX,8-1
	REP	STOSB

	SETS	FLNM			; file name.
	SETS	FLNM_WRITE2		; write file name.(skip top)

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


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	CRXVEW:WORD		; 色相回転（０ー３６０）
EXTRN	CRXCNS:WORD		; 彩度倍率（０ー１００）
EXTRN	CRXBRI:WORD		; 明度倍率（０ー１００）
EXTRN	CRXWHI:WORD		; ホワイトレベル（０ー１００）

EXTRN	ARAVRM:WORD		; vram area.

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

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.
EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ

EXTRN	CLRSOU:WORD		; 変更カラーパレット
EXTRN	CLRDES:WORD		; 変更後カラーパレット

			;12345678
FLNM		DB	"        ",0,0	; file name.

FLNM_WRITE	DB	"X"		; write file name.
FLNM_WRITE2	DB	"       ",0,0	;


		EVEN

FILE_MAX	DW	0	; 指定ファイル数
FILE_UPPER	DW	22	; 指定ファイル数上限
FILE_PNT	DW	0	; 指定ファイルポインタ
FILE_TABLE	LABEL	WORD	; ファイル名テーブル
		DW	OFFSET FILE_NM0
		DW	OFFSET FILE_NM1
		DW	OFFSET FILE_NM2
		DW	OFFSET FILE_NM3
		DW	OFFSET FILE_NM4
		DW	OFFSET FILE_NM5
		DW	OFFSET FILE_NM6
		DW	OFFSET FILE_NM7
		DW	OFFSET FILE_NM8
		DW	OFFSET FILE_NM9
		DW	OFFSET FILE_NM10
		DW	OFFSET FILE_NM11
		DW	OFFSET FILE_NM12
		DW	OFFSET FILE_NM13
		DW	OFFSET FILE_NM14
		DW	OFFSET FILE_NM15
		DW	OFFSET FILE_NM16
		DW	OFFSET FILE_NM17
		DW	OFFSET FILE_NM18
		DW	OFFSET FILE_NM19
		DW	OFFSET FILE_NM20
		DW	OFFSET FILE_NM21
FILE_NM0	DB	"        ",0,0
FILE_NM1	DB	"        ",0,0
FILE_NM2	DB	"        ",0,0
FILE_NM3	DB	"        ",0,0
FILE_NM4	DB	"        ",0,0
FILE_NM5	DB	"        ",0,0
FILE_NM6	DB	"        ",0,0
FILE_NM7	DB	"        ",0,0
FILE_NM8	DB	"        ",0,0
FILE_NM9	DB	"        ",0,0
FILE_NM10	DB	"        ",0,0
FILE_NM11	DB	"        ",0,0
FILE_NM12	DB	"        ",0,0
FILE_NM13	DB	"        ",0,0
FILE_NM14	DB	"        ",0,0
FILE_NM15	DB	"        ",0,0
FILE_NM16	DB	"        ",0,0
FILE_NM17	DB	"        ",0,0
FILE_NM18	DB	"        ",0,0
FILE_NM19	DB	"        ",0,0
FILE_NM20	DB	"        ",0,0
FILE_NM21	DB	"        ",0,0

		EVEN
SIZE_MAX	DW	0		; 指定サイズ数
SIZE_UPPER	DW	22		; 指定サイズ数上限
SIZE_PNT	DW	0		; 指定サイズポインタ
SIZE_VRX	DW	22 DUP (0)	; 指定ＰＵＴ座標Ｘ
SIZE_VRY	DW	22 DUP (0)	; 指定ＰＵＴ座標Ｙ
SIZE_VRLENX	DW	22 DUP (0)	; 指定ＰＵＴ座標Ｘ
SIZE_VRLENY	DW	22 DUP (0)	; 指定ＰＵＴ座標Ｙ
MASK_ON_FLAG	DW	0		; マスク処理 0=何もしない
					; 1=マスク化処理
MASK_COLOR	DW	0		; マスク処理 透明色

USER_DRV	DW	0	; ユーザドライブ番号
USER_DRV_DEST	DW	0	; ユーザ書き込みドライブ番号

PLSDIR_FLG	DW	0	; 圧縮方向指定[1=縦方向]

PALET_OFF	DW	0	; 1=パレット読み込み中止

FRAME_NUM	DW	0	; フレーム番号

DATA	ENDS

	END
;
;	end of "ALLPLS.ASM"
;
