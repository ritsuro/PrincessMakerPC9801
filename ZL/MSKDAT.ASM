; "MSKDAT.ASM" PC-9801UV11 make by R.H 1990/01/04
;
;	マスクデータファイル作成
;
;
;	1991/02/06 縦圧縮化
;

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	MSKPLT		; マスクデータファイル作成
PUBLIC	MSKPAR		; マスクファイルチェック
PUBLIC	MSKPLNGET	; マスク化データＧＥＴ
PUBLIC	MSKDATGET	; マスク抜きデータＧＥＴ

EXTRN	PLSMOD:NEAR	; 圧縮モード切り替え

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
EXTRN	PATPFM:NEAR	; マスクパーツＰＵＴオフセット指定
EXTRN	PATOPE:NEAR	; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

EXTRN	PATSIZ:NEAR	; パーツサイズのＧＥＴ

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




; *******************************************
;	マスクファイル作成
; *******************************************
;	-I- DX : ドライブ番号

MSKPLT	PROC	NEAR
	MOV	ZAHYOU_SHITEI,0		; 1=座標指定

	MOV	USER_DRV,DX		; ユーザドライブ番号
	PRF	"0:マスク１対パターン複数"
	PRF	"1:マスク１対パターン１"
	INP	"2:マスク１対パターン複数・座標指定"
	COMP	"1"
	JE	MSKPLT001
	COMP	"2"
	JE	MSKPLT0012
	JMP	MSKPLT002
MSKPLT001:
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	MSKPLL		; マスクファイル作成（マスク１対パターン１）
	RET
MSKPLT0012:
	MOV	ZAHYOU_SHITEI,1	; 1=座標指定
MSKPLT002:

	PRF	"マスクファイル作成 [*.PT1]"
	MOV	GETNUM,0	;
	CALL	PATCLR		; パーツセットクリア

	INP	"書き込みドライブ＝"
	CALL	STRDEC
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

	INP	"圧縮方向指定[1=縦方向]＝"
	CALL	STRDEC			;
	MOV	PLSDIR_FLG,DX		; 圧縮方向指定[1=縦方向]

MSKPLOT_START:
	MOV	AX,USER_DRV	; ユーザドライブ番号
	CALL	DSKDR		; drive number set.

	MOV	AX,GETNUM	;
	MOV	GETNUM_OFSET,AX	; パーツ番号オフセット

	CALL	VRMCLR			;ＶＲＡＭクリア

	INP	"ファイル名['Q':EXIT,'S':SAVE]＝"

	COMP	"S"
	JUMP_EQ	MSKPLOT9

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


;*BR*;	CALL	HARFBR			; 明度５０％


	CMP	ZAHYOU_SHITEI,1	; 1=座標指定
	JE	MSKPLOT01	;

	CMP	GETNUM,0	; 最初のＧＥＴはマスクデータ
	JNE	MSKPLOT_NOMASK	;

MSKPLOT01:			;
	INP	"マスクカラー番号"
	CALL	STRDEC
	MOV	MASK_COLOR,DX		; マスクカラー番号

	INP	"圧縮（ＲＥＴキーを押して）"
	CALL	CLS		; text clear.
MSKPLOT1:
	CALL	MSWAT		; カーソルボタンＯＦＦ待ち
	CALL	ARABOX		; box pic.
	CALL	CLS		; text clear.
	CMP	AX,2		; ２＝強制終了
	JNE	MSKPLOT2	;
	JMP	MSKPLOT55	;
MSKPLOT2:
	MOV	AX,VX1		;
	MOV	VRX,AX		; ＶＲＡＭ　Ｘ座標
	MOV	BX,VX2		;
	SUB	BX,AX		; Ｘ方向長さ
	INC	BX		;
	MOV	VRLENX,BX	; Ｘ方向長さ

	MOV	AX,VY1		;
	MOV	VRY,AX		; ＶＲＡＭ　Ｙ座標
	MOV	BX,VY2		;
	SUB	BX,AX		; Ｙ方向長さ
	INC	BX		;
	MOV	VRLENY,BX	; Ｙ方向長さ
MSKPLOT_NOMASK:
	PRVH	"VRX=",VRX	; ＶＲＡＭ　Ｘ座標
	PRVH	"VRY=",VRY	; ＶＲＡＭ　Ｙ座標
	PRVH	"VRLENX=",VRLENX	; Ｘ方向長さ
	PRVH	"VRLENY=",VRLENY	; Ｙ方向長さ


	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MUSPLOT_MSK_YOKO	;
	MOV	DX,1			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
	JMP	MUSPLOT_MSK_111		;
MUSPLOT_MSK_YOKO:			;
	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
MUSPLOT_MSK_111:			;



	CMP	GETNUM,0	; 最初のＧＥＴはマスクデータ
	JNE	MSKPLOT43	;
	CALL	MASKMK		; マスク作成
	CALL	PATGTM		; マスクパーツＧＥＴ
	CMP	AX,0		;
	JNE	MSKPLOT45	;
	JMP	MSKPLOT44	;
MSKPLOT43:
	CALL	UMSKMK		; マスク部分の透明化
	CALL	PATGET		; パーツＧＥＴ
	CMP	AX,0		;
	JNE	MSKPLOT45	;
MSKPLOT44:

	PRV	"個数＝",GETNUM

	INC	GETNUM
MSKPLOT45:
	PRVH	"データ長さ              BCOUNT=",BCOUNT
	PRVH	"データ終わりアドレス＋１BPOINT=",BPOINT
	PRVH	"0=normal end. 1=write error.AX=",AX

;;;;	CMP	GETNUM,1	; 最初のＧＥＴはマスクデータ
;;;;	JGE	MSKPLOT55	;

	JMP	MSKPLOT66	; loop end.

MSKPLOT55:
;;;	CALL	VRMCLR			; ＶＲＡＭクリア
	INP	"復元（ＲＥＴキーを押して）"
	MOV	AX,GETNUM_OFSET		; パーツ番号オフセット
	MOV	GETNUM_CHK,AX		; パーツ番号チェック
MSKPLOT56:
	CALL	MSWAT		; カーソルボタンＯＦＦ待ち

	CALL	ARAPNT		; point pic.
	CMP	AX,2		; ２＝強制終了
	JNE	MSKPLOT57	;
	JMP	MSKPLOT9	;
MSKPLOT57:
	CALL	CLS		; text clear.

	;	データ復元
	;	-I- VRX    : ＶＲＡＭ　Ｘ座標
	;	    VRY    : ＶＲＡＭ　Ｙ座標
	;	    VRLENX : Ｘ方向長さ
	;	    VRLENY : Ｙ方向長さ
	;	    BPNTOF : データバッファポインタ
	;	    BPNTSG : データバッファセグメント
	;	    BCNTMX : データ最大長さ
	;	-O- BCOUNT ; データ長さ
	;	    BPOINT ; データ終わりアドレス＋１
	;	    AH     : 0=normal 1=E.O.F

	PRVH	"データバッファポインタ  BPNTOF=",BPNTOF
	PRVH	"データバッファセグメントBPNTSG=",BPNTSG
	PRVH	"データ最大長さ          BCNTMX=",BCNTMX

	MOV	AX,VX1
	MOV	VRX,AX	; ＶＲＡＭ　Ｘ座標
	MOV	AX,VY1
	MOV	VRY,AX	; ＶＲＡＭ　Ｙ座標

	MOV	CX,GETNUM_CHK	; パーツ番号チェック


	CMP	GETNUM_CHK,0	; 最初のＧＥＴはマスクデータ
	JE	MSKPLOT6	;

	PUSH	CX		;
	MOV	CX,0		; mask number
	CALL	PATPTM		; マスクパーツＰＵＴ
	POP	CX		;
	MOV	DX,1		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
	CALL	PATPUT		; パーツＰＵＴ
	MOV	DX,0		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
	JMP	MSKPLOT66	;
MSKPLOT6:			;
	CALL	PATPTM		; マスクパーツＰＵＴ
MSKPLOT66:			;


	PRV	"個数＝",GETNUM_CHK

	INC	GETNUM_CHK	; パーツ番号チェック

	PRVH	"データ長さ              BCOUNT=",BCOUNT
	PRVH	"データ終わりアドレス＋１BPOINT=",BPOINT
	PRVH	"0:normal end. 1:error.AX=",AX

	JMP	MSKPLOT_START	; next try.
MSKPLOT88:
	JMP	MSKPLOT56
MSKPLOT9:

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	PRS	"last file name=",FLNM		; file name.

	INP	"パーツファイル名['Q':EXIT]＝"
	CALL	FLSET		; ファイル名セット
	PRF	"パーツファイル書き込み [*.PT1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATSAV			; パーツセーブ


MSKPLOT_EXIT:
	RET
MSKPLT	ENDP



; *******************************************
;	マスクファイル作成（マスク１対パターン１）
;	偶数NO.がマスクで奇数NO.がパターン
;
; *******************************************
;	-I- DX : ドライブ番号

MSKPLL	PROC	NEAR
	MOV	USER_DRV,DX	; ユーザドライブ番号

	PRF "偶数NO.がマスクで奇数NO.がパターン／マスクファイル作成 [*.PT1]"

	MOV	GETNUM,0	;
	CALL	PATCLR		; パーツセットクリア

	INP	"書き込みドライブ＝"
	CALL	STRDEC
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

	INP	"圧縮方向指定[1=縦方向]＝"
	CALL	STRDEC			;
	MOV	PLSDIR_FLG,DX		; 圧縮方向指定[1=縦方向]


	INP	"データロードしますか['Y'=ロードする]＝"
	COMP	"Y"
	JE	MSKPLL001
	JMP	MSKPLL000
MSKPLL001:
	INP	"ファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット
	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLOD			; パーツロード
	MOV	CX,0
MSKPLL0002:
	CALL	PATSIZ		; パーツサイズのＧＥＴ
	INC	CX		;
	CMP	AX,0		; データエンド検索
	JE	MSKPLL0002	;
	DEC	CX		;
	MOV	GETNUM,CX	;
MSKPLL000:

	PRV	"先頭パターン番号GETNUM=",GETNUM

MSKPLL_START:
	MOV	AX,USER_DRV	; ユーザドライブ番号
	CALL	DSKDR		; drive number set.

	MOV	AX,GETNUM	;
	MOV	GETNUM_OFSET,AX	; パーツ番号オフセット

	CALL	VRMCLR			;ＶＲＡＭクリア

	TEST	WORD PTR GETNUM,1 ; 偶数NO.がマスクデータ
	JNZ	MSKPLL_INP_NM
	INP	"ベタファイル名['Q':EXIT]＝"
	CMP	DS:[SI],BYTE PTR 0
	JUMP_EQ	MSKPLL9		; データセーブ

	CALL	FLSET		; ファイル名セット
MSKPLL_INP_NM:

	PRF	"パレットファイル読み込み [*.ALG]"
	MOV	SI,OFFSET FLNM		; file name.
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	PRF	"ベタファイル読み込み [*.B1, *.R1, *.G1, *.E1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ベタファイルロード


;*BR*;	CALL	HARFBR			; 明度５０％


	PRF	"圧縮"
	CALL	CLS		; text clear.
MSKPLL1:


	TEST	WORD PTR GETNUM,1 ; 偶数NO.がマスクデータ
	JZ	MSKPLL11	;
	JMP	MSKPLL13	;
MSKPLL11:			;

	INP	"マスクカラー番号['S'=データセーブ,'R'=リトライ]"
	COMP	"S"		;
	JUMP_EQ	MSKPLL9		; データセーブ
	COMP	"R"		;
	JUMP_EQ	MSKPLL_START	; next try.

	CALL	STRDEC		;
	MOV	MASK_COLOR,DX	; マスクカラー番号

	PRF	"マスク作成"	;
	CALL	MSWAT		; カーソルボタンＯＦＦ待ち
	CALL	ARABOX		; box pic.
	CALL	CLS		; text clear.
	CMP	AX,2		; ２＝強制終了
	JNE	MSKPLL2		;
	JMP	MSKPLL_START	; next try.
MSKPLL2:
	MOV	AX,VX1		;
	MOV	VRX,AX		; ＶＲＡＭ　Ｘ座標
	MOV	BX,VX2		;
	SUB	BX,AX		; Ｘ方向長さ
	INC	BX		;
	MOV	VRLENX,BX	; Ｘ方向長さ

	MOV	AX,VY1		;
	MOV	VRY,AX		; ＶＲＡＭ　Ｙ座標
	MOV	BX,VY2		;
	SUB	BX,AX		; Ｙ方向長さ
	INC	BX		;
	MOV	VRLENY,BX	; Ｙ方向長さ

	JMP	MSKPLL14	;

MSKPLL13:			; 奇数NO.がパターン
	MOV	CX,GETNUM
	DEC	CX
	CALL	PATSIZ		; パーツサイズのＧＥＴ
	PRF	"パーツＧＥＴ"	;
MSKPLL14:



	PRVH	"VRX=",VRX	; ＶＲＡＭ　Ｘ座標
	PRVH	"VRY=",VRY	; ＶＲＡＭ　Ｙ座標
	PRVH	"VRLENX=",VRLENX	; Ｘ方向長さ
	PRVH	"VRLENY=",VRLENY	; Ｙ方向長さ


	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MUSPLL_YOKO		;
	MOV	DX,1			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
	JMP	MUSPLL_111		;
MUSPLL_YOKO:				;
	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
MUSPLL_111:				;


	TEST	WORD PTR GETNUM,1 ; 偶数NO.がマスクデータ
	JNZ	MSKPLL43	;
	PRF	"### 1"
	CALL	MASKMK		; マスク作成
	PRF	"### 2"
	CALL	PATGTM		; マスクパーツＧＥＴ
	PRF	"### 3"
	CMP	AX,0		;
	JNE	MSKPLL45	;
	JMP	MSKPLL44	;
MSKPLL43:			; 奇数NO.がパターン
	CALL	UMSKMK		; マスク部分の透明化
	CALL	PATGET		; パーツＧＥＴ
	CMP	AX,0		;
	JNE	MSKPLL45	;
MSKPLL44:



	PRV	"個数＝",GETNUM

	INC	GETNUM
MSKPLL45:
	PRVH	"データ長さ              BCOUNT=",BCOUNT
	PRVH	"データ終わりアドレス＋１BPOINT=",BPOINT
	PRVH	"0=normal end. 1=write error.AX=",AX

MSKPLL55:
;;;	CALL	VRMCLR			; ＶＲＡＭクリア

	TEST	WORD PTR GETNUM,1 ; 偶数NO.がマスクデータ
	JNZ	MSKPLL555	;
	JMP	MSKPLL66	; マスクはスキップ
MSKPLL555:

	PRF	"復元"
	MOV	AX,GETNUM_OFSET		; パーツ番号オフセット
	MOV	GETNUM_CHK,AX		; パーツ番号チェック
MSKPLL56:
	CALL	MSWAT		; カーソルボタンＯＦＦ待ち

;	CALL	ARAPNT		; point pic.
;	CMP	AX,2		; ２＝強制終了
;	JNE	MSKPLL57	;
;	JMP	MSKPLL9	;
MSKPLL57:
;	CALL	CLS		; text clear.

	;	データ復元
	;	-I- VRX    : ＶＲＡＭ　Ｘ座標
	;	    VRY    : ＶＲＡＭ　Ｙ座標
	;	    VRLENX : Ｘ方向長さ
	;	    VRLENY : Ｙ方向長さ
	;	    BPNTOF : データバッファポインタ
	;	    BPNTSG : データバッファセグメント
	;	    BCNTMX : データ最大長さ
	;	-O- BCOUNT ; データ長さ
	;	    BPOINT ; データ終わりアドレス＋１
	;	    AH     : 0=normal 1=E.O.F

	PRVH	"データバッファポインタ  BPNTOF=",BPNTOF
	PRVH	"データバッファセグメントBPNTSG=",BPNTSG
	PRVH	"データ最大長さ          BCNTMX=",BCNTMX

	MOV	AX,VX1
	MOV	VRX,AX	; ＶＲＡＭ　Ｘ座標
	MOV	AX,VY1
	MOV	VRY,AX	; ＶＲＡＭ　Ｙ座標

	MOV	CX,GETNUM_CHK	; パーツ番号チェック

	PUSH	CX		;
	DEC	CX		; mask number
	PRF	"### ptm4"
	CALL	PATPTM		; マスクパーツＰＵＴ
	POP	CX		;
	MOV	DX,1		;
	PRF	"### ope5"
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
	PRF	"### put6"
	CALL	PATPUT		; パーツＰＵＴ
	MOV	DX,0		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
	JMP	MSKPLL66	;
MSKPLL6:			;
MSKPLL66:			;


	PRV	"個数＝",GETNUM_CHK

	INC	GETNUM_CHK	; パーツ番号チェック

	PRVH	"データ長さ              BCOUNT=",BCOUNT
	PRVH	"データ終わりアドレス＋１BPOINT=",BPOINT
	PRVH	"0:normal end. 1:error.AX=",AX
	CMP	AX,1
	JNE	MSKPLL88
	JMP	MSKPLL_START	; next try.
MSKPLL88:
	JMP	MSKPLL56
MSKPLL9:

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	PRS	"last file name=",FLNM		; file name.


	INP	"パーツファイル名['Q':EXIT]＝"
	CALL	FLSET		; ファイル名セット
	PRF	"パーツファイル書き込み [*.PT1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATSAV			; パーツセーブ


MSKPLL_EXIT:
	RET
MSKPLL	ENDP



; *******************************************
;	テスト・パーツファイルチェック
; *******************************************
;	-I- DX	; ユーザドライブ番号

MSKPAR	PROC	NEAR
	MOV	USER_DRV,DX	; ユーザドライブ番号
	PRF	"0:マスク１対パターン複数"
	INP	"1:マスク１対パターン１"
	COMP	"1"
	JE	MSKPAR001
	JMP	MSKPAR002
MSKPAR001:
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	MSKPPR		; マスクファイル作成（マスク１対パターン１）
	RET
MSKPAR002:

	INP	"圧縮方向指定[1=縦方向]＝"
	CALL	STRDEC			;
	MOV	PLSDIR_FLG,DX		; 圧縮方向指定[1=縦方向]

	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MSKPAR_YOKO		;
	MOV	DX,1			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
	JMP	MSKPAR_111		;
MSKPAR_YOKO:				;
	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
MSKPAR_111:				;


	PRF	"パーツファイルチェック [*.PT1]"
	MOV	GETNUM,0		;
	CALL	PATCLR			; パーツセットクリア
	CALL	VRMCLR			;ＶＲＡＭクリア

	CALL	CLS		; text clear.

	INP	"ベタファイル名['Q':EXIT]＝"
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


;*BR*;	CALL	HARFBR			; 明度５０％


	INP	"パーツファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット
	PRF	"パーツファイル読み込み"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLOD			; パーツロード
MSKPART4444:
	INP	"追加パーツファイル名['T':ﾃｽﾄｽﾀｰﾄ 'Q':EXIT]＝"

	COMP	"T"
	JE	MSKPART55		;

	CALL	FLSET			; ファイル名セット
	PRF	"追加パーツファイル読み込み"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLDA			; パーツ追加ロード
	JMP	MSKPART4444		;
MSKPART55:
	INP	"復元（ＲＥＴキーを押して）"
	CALL	CLS		; text clear.
	MOV	GETNUM,1	; ０はマスクデータ
MSKPART56:
	CALL	MSWAT		; カーソルボタンＯＦＦ待ち
	CALL	ARAPNT		; point pic.
	CMP	AX,2		; ２＝強制終了
	JNE	MSKPART57	;
	JMP	MSKPART9	;
MSKPART57:
	CALL	CLS		; text clear.

	;	データ復元
	;	-I- VRX    : ＶＲＡＭ　Ｘ座標
	;	    VRY    : ＶＲＡＭ　Ｙ座標
	;	    VRLENX : Ｘ方向長さ
	;	    VRLENY : Ｙ方向長さ
	;	    BPNTOF : データバッファポインタ
	;	    BPNTSG : データバッファセグメント
	;	    BCNTMX : データ最大長さ
	;	-O- BCOUNT ; データ長さ
	;	    BPOINT ; データ終わりアドレス＋１
	;	    AH     : 0=normal 1=E.O.F

;	PRVH	"データバッファポインタ  BPNTOF=",BPNTOF
;	PRVH	"データバッファセグメントBPNTSG=",BPNTSG
;	PRVH	"データ最大長さ          BCNTMX=",BCNTMX

	MOV	AX,VX1	;
	MOV	VRX,AX	; ＶＲＡＭ　Ｘ座標
	MOV	AX,VY1	;
	MOV	VRY,AX	; ＶＲＡＭ　Ｙ座標

	MOV	CX,0
	PUSH	VRX
	PUSH	VRY
	CALL	PATPFM		; マスクパーツＰＵＴオフセット指定
	POP	VRY
	POP	VRX
;*NON*;	CALL	PATPXM		; マスクＰＵＴ

	MOV	DX,1		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	MOV	CX,GETNUM
	CALL	PATPTF		; パーツＰＵＴオフセット指定
;*NON*;	CALL	PATPTX		; ＰＵＴ

	MOV	DX,0		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	PRV	"個数＝",GETNUM

	INC	GETNUM

;	PRVH	"データ長さ              BCOUNT=",BCOUNT
;	PRVH	"データ終わりアドレス＋１BPOINT=",BPOINT
;	PRVH	"0:normal end. 1:error.AX=",AX
	CMP	AX,1
	JNE	MSKPART88

	MOV	GETNUM,1
	MOV	DX,1		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	MOV	CX,GETNUM
	CALL	PATPTF		; パーツＰＵＴオフセット指定
;*NON*;	CALL	PATPTX		; ＰＵＴ

	MOV	DX,0		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

MSKPART88:
	JMP	MSKPART56	; loop end.
MSKPART9:
	JMP	MSKPAR		; retry.
MSKPART_EXIT:
	RET
MSKPAR	ENDP



; *******************************************
;	マスク化データＧＥＴ
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    CX     : マスクカラー番号
;	-O- AX     : 0=正常,1=エラー
; *******************************************

MSKPLNGET	PROC	NEAR
	PUSH	VRX
	PUSH	VRY
	PUSH	VRLENX
	PUSH	VRLENY

	MOV	MASK_COLOR,CX		; マスクカラー番号

	CALL	MASKMK			; マスク作成
	CALL	PATGTM			; マスクパーツＧＥＴ
	CMP	AX,0			;
	JNE	MSKPLNGET_ERROR		;

MSKPLNGET_NORMAL:
	MOV	AX,0			; 0=正常
	POP	VRLENY
	POP	VRLENX
	POP	VRY
	POP	VRX
	RET
MSKPLNGET_ERROR:
	MOV	AX,1			; 1=エラー
	POP	VRLENY
	POP	VRLENX
	POP	VRY
	POP	VRX
	RET
MSKPLNGET	ENDP


; *******************************************
;	マスク抜きデータＧＥＴ
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    CX     : マスクカラー番号
;	-O- AX     : 0=正常,1=エラー
; *******************************************

MSKDATGET	PROC	NEAR
	PUSH	VRX
	PUSH	VRY
	PUSH	VRLENX
	PUSH	VRLENY

	MOV	MASK_COLOR,CX		; マスクカラー番号

	CALL	UMSKMK			; マスク部分の透明化
	CALL	PATGET			; パーツＧＥＴ
	CMP	AX,0			;
	JNE	MSKDATGET_ERROR		;

MSKDATGET_NORMAL:
	MOV	AX,0			; 0=正常
	POP	VRLENY
	POP	VRLENX
	POP	VRY
	POP	VRX
	RET
MSKDATGET_ERROR:
	MOV	AX,1			; 1=エラー
	POP	VRLENY
	POP	VRLENX
	POP	VRY
	POP	VRX
	RET
MSKDATGET	ENDP



; *******************************************
;	テスト・パーツファイルチェック
; *******************************************
;	-I- DX	; ユーザドライブ番号

MSKPPR	PROC	NEAR
	MOV	USER_DRV,DX		; ユーザドライブ番号

	PRF	"パーツファイルチェック [*.PT1]"
	MOV	GETNUM,0		;
	CALL	PATCLR			; パーツセットクリア
	CALL	VRMCLR			; ＶＲＡＭクリア

	CALL	CLS			; text clear.

	INP	"圧縮方向指定[1=縦方向]＝"
	CALL	STRDEC			;
	MOV	PLSDIR_FLG,DX		; 圧縮方向指定[1=縦方向]

	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MSKPPR_YOKO		;
	MOV	DX,1			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
	JMP	MSKPPR_111		;
MSKPPR_YOKO:				;
	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え
MSKPPR_111:				;

	INP	"ベタファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット

	PRF	"パレットファイル読み込み [*.ALG]"
	MOV	SI,OFFSET FLNM		; file name.
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	PRF	"ベタファイル読み込み [*.B1, *.R1, *.G1, *.E1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LODBET			; ベタファイルロード


;*BR*;	CALL	HARFBR			; 明度５０％


	INP	"パーツファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット
	PRF	"パーツファイル読み込み"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLOD			; パーツロード
MSKPPRT4444:
	INP	"追加パーツファイル名['T':ﾃｽﾄｽﾀｰﾄ 'Q':EXIT]＝"

	COMP	"T"
	JE	MSKPPRT55		;

	CALL	FLSET			; ファイル名セット
	PRF	"追加パーツファイル読み込み"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLDA			; パーツ追加ロード
	JMP	MSKPPRT4444		;
MSKPPRT55:

	INP	"復元（ＲＥＴキーを押して）"

	CALL	CLS			; text clear.
	MOV	GETNUM,0		; 奇数NO.はマスクデータ
MSKPPRT56:
	CALL	MSWAT			; カーソルボタンＯＦＦ待ち
	CALL	ARAPNT			; point pic.
	CMP	AX,2			; ２＝強制終了
	JNE	MSKPPRT57		;
	JMP	MSKPPRT9		;
MSKPPRT57:
	CALL	CLS			; text clear.

	MOV	AX,VX1			;
	MOV	VRX,AX			; ＶＲＡＭ　Ｘ座標
	MOV	AX,VY1			;
	MOV	VRY,AX			; ＶＲＡＭ　Ｙ座標

	MOV	CX,GETNUM
	PUSH	VRX
	PUSH	VRY
	CALL	PATPFM		; マスクパーツＰＵＴオフセット指定
	POP	VRY
	POP	VRX
;*NON*;	CALL	PATPXM			; マスクＰＵＴ

	MOV	DX,1		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	MOV	CX,GETNUM
	INC	CX		;
	CALL	PATPTF		; パーツＰＵＴオフセット指定
;*NON*;	CALL	PATPTX		; ＰＵＴ

	MOV	DX,0		;
	CALL	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	PRV	"個数＝",GETNUM

	INC	GETNUM
	INC	GETNUM

	CMP	AX,1			;
	JNE	MSKPPRT88		;
	JMP	MSKPPRT55		; 復元（ＲＥＴキーを押して）
MSKPPRT88:
	JMP	MSKPPRT56		; loop end.
MSKPPRT9:
	JMP	MSKPPR			; retry.
MSKPPRT_EXIT:
	RET
MSKPPR	ENDP



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



CXWAIT	PROC	NEAR
	PUSH	CX
	MOV	CX,5000
CXWAIT2:
	LOOP	CXWAIT2
	POP	CX
	RET
CXWAIT	ENDP


;	ポイントプリント
;

POINTPRINT	PROC	NEAR
POINTPRINT1:			;
	CALL	MSWAT		;
	CALL	ARAPNT		; point pic.
	CMP	AX,2		; ２＝強制終了
	JE	POINTPRINT9	;
	PR	"座標:"		;
	MOV	DX,VX1		;
	CALL	DECSTR		;
	CALL	PRINT		;
	PR	":"		;
	MOV	DX,VY1		;
	CALL	DECSTR		;
	CALL	PRINT		;
	LF			;
	JMP	POINTPRINT1	;
POINTPRINT9:
	CALL	CLS		;
	RET
POINTPRINT	ENDP


;	カーソルボタンＯＦＦ待ち

MSWAT	PROC	NEAR
MSWAT1:
	PUSH	VX1
	PUSH	VY1
	CALL	PTPIC	; point pick.
	POP	VX1
	POP	VY1
	CMP	AX,0	; 0:normal,1:pic,2:exit
	JNE	MSWAT1	;
	RET
MSWAT	ENDP


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



CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

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

EXTRN	SSGR0:WORD	; visual data segment plean 0
EXTRN	SSGR1:WORD	; visual data segment plean 1
EXTRN	SSGR2:WORD	; visual data segment plean 2
EXTRN	SSGR3:WORD	; visual data segment plean 3

EXTRN	VRX:WORD	; x point.
EXTRN	VRY:WORD	; y point.
EXTRN	VRLENX:WORD	; x length.
EXTRN	VRLENY:WORD	; y length.

EXTRN	BPOINT:WORD	; data buffer point.
EXTRN	BPNTOF:WORD	; データバッファポインタ
EXTRN	BPNTSG:WORD	; データバッファセグメント
EXTRN	BCNTMX:WORD	; データ最大長さ
EXTRN	BCOUNT:WORD	; データ長さ

EXTRN	CLRSOU:WORD		; 変更カラーパレット
EXTRN	CLRDES:WORD		; 変更後カラーパレット

		;12345678
FLNM	DB	"        ",0		; file name.
FLNMT	DB	"        ","TCH",0	; file name.

		EVEN
ZAHYOU_SHITEI	DW	0	; 1=座標指定

GETNUM		DW	0	; パターンＧＥＴ番号
GETNUM_OFSET	DW	0	; パーツ番号オフセット
GETNUM_CHK	DW	0	; パーツ番号チェック

USER_DRV	DW	0	; ユーザドライブ番号
USER_DRV_DEST	DW	0	; ユーザ書き込みドライブ番号

MASK_COLOR	DW	1	; マスクカラー番号

PLSDIR_FLG	DW	0	; 圧縮方向指定

DATA	ENDS

	END
;
;	end of "MSKDAT.ASM"
;
