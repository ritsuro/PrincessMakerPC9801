; "BINSET.ASM" PC-9801UV11 make by R.H 1990/05/11
;
;	バイナリデータのセット
;
;	（１）	パーツバッファにバイナリデータをセットする
;		BPPSET : パレットデータのセット
;		BPPCHK : パレットデータのチェック
;		BPPLST : パレットファイル読み込みパーツセット
;
;		パレットのサイズ (PALET_LEN) に注意すること
;		(DSKPLT.ASMと同様)

INCLUDE	TSTSET.INC

PALET	SEGMENT	PUBLIC	'PALET'

EXTRN	PLTNUM:WORD		; ハードパレットテーブル
EXTRN	PLTOFS:WORD		; パレットアドレステーブル（色相）
EXTRN	PCNOFS:WORD		; パレットアドレステーブル（彩度）
EXTRN	PBROFS:WORD		; パレットアドレステーブル（明度）

PALET	ENDS


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	BPPSET		; パレットデータのセット
PUBLIC	BPPCHK		; パレットデータのチェック
PUBLIC	BPPLST		; パレットファイル読み込みパーツセット
PUBLIC	BPPPTS		; パレットファイルをパーツバッファへ

EXTRN	PATBGT:NEAR	; バイナリデータ書き込み
EXTRN	PATBPT:NEAR	; バイナリデータ読み出し

EXTRN	PLSET:NEAR	; パレットセット
EXTRN	PLPSET:NEAR	; パレット編集セット

EXTRN	LODPLT:NEAR	; パレットファイルロード
EXTRN	SAVPLT:NEAR	; パレットファイルセーブ

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

EXTRN	DSKOPN:NEAR	; file open.
EXTRN	DSKCRE:NEAR	; file open & creat.
EXTRN	DSKCLS:NEAR	; file close.

EXTRN	DSKDR:NEAR	; drive number set.

EXTRN	DSKRED:NEAR	; load 1 byte data.
EXTRN	DSKWRT:NEAR	; save 1 byte data.

EXTRN	DSKLD:NEAR	; load data.
EXTRN	DSKSV:NEAR	; save data.


WPALET_NUM	EQU	0	; ワーク用パレット番号

PALET_LEN	EQU	8*2*6	; パレットのバイト数



; *******************************************
;	パレットデータのセット
;	-I- DX : ドライブ番号
; *******************************************

BPPSET	PROC	NEAR
	MOV	USER_DRV,DX		; ユーザドライブ番号

	CALL	CLS

	PRF	"パレットデータのセット"

	CALL	PATCLR			; パーツセットクリア

	MOV	WCOUNT,0		; カウンタ

BPPSET_START:
	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

	INP	"パレットファイル名[*.ALG,'S':ﾊﾟｰﾂSAVE,'Q':EXIT]＝"

	COMP	"S"			;
	JUMP_EQ	BPPSET_WRITE		;

	CALL	FLSET			; ファイル名セット

	PRF	"パレットファイル読み込み [*.ALG]"

	MOV	SI,OFFSET FLNM		; file name.
	CALL	PALET_TO_PARTS		; パレットファイルをパーツバッファへ

	CMP	AX,1			; AX : 0=normal end, 1=error.
	JNE	BPPSET_SKIP		;

	PRV	"パーツバッファに書き込めない！？データいっぱいか？AX=",AX

	JMP	BPPSET_NEXT		;

BPPSET_SKIP:				;
	INC	WCOUNT			; カウンタ

	PRV	"ただいまの書き込み数=",WCOUNT

BPPSET_NEXT:				;
	JMP	BPPSET_START		; つぎのデータ読み込みへ


BPPSET_WRITE:
	INP	"書き込みドライブ['Q':EXIT]＝"
	CALL	STRDEC			;
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

	INP	"パーツファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	PRF	"パーツファイル書き込み [*.PT1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATSAV			; パーツセーブ

	RET
BPPSET	ENDP



; *******************************************
;	パレットファイル読み込みパーツセット
; *******************************************

BPPLST	PROC	NEAR
	INP	"パレットファイル名[*.ALG]＝"

	CALL	FLSET			; ファイル名セット

	PRF	"パレットファイル読み込み [*.ALG]"

	MOV	SI,OFFSET FLNM		; file name.
	CALL	PALET_TO_PARTS		; パレットファイルをパーツバッファへ

	RET
BPPLST	ENDP


; *******************************************
;	パレットファイルをパーツバッファへ
;	-I- DS:SI : パレットファイル名
; *******************************************

BPPPTS	PROC	NEAR
	CALL	PALET_TO_PARTS		; パレットファイルをパーツバッファへ
	RET
BPPPTS	ENDP



; *******************************************
;	パレットファイルをパーツバッファへ
;	-I- DS:SI : パレットファイル名
;	-O- AX    : 0=normal end, 1=error.
; *******************************************

PALET_TO_PARTS	PROC	NEAR
	MOV	BX,WPALET_NUM		; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード

	MOV	BX,WPALET_NUM		; パレットテーブル番号
	CALL	PLSET			; パレットセット

	MOV	BX,WPALET_NUM		; ワーク用パレット番号
	CALL	PLTDMP			; パレットデータのダンプ

	MOV	AX,SEG PALET		; パレット用セグメント
	MOV	ES,AX			;
	MOV	BX,WPALET_NUM		; パレットテーブル番号
	SHL	BX,1			; word pointer.
	MOV	AX,ES:PLTOFS[BX]	; パレットアドレステーブル（色相）

	MOV	DX,ES			; パレット用セグメント
	MOV	SI,AX			; パレットテーブル先頭
	MOV	CX,PALET_LEN		; パレットのバイト数
	CALL	PATBGT			; バイナリデータ書き込み

	RET
PALET_TO_PARTS	ENDP



; *******************************************
;	パレットデータのチェック
;	-I- DX : ドライブ番号
; *******************************************

BPPCHK	PROC	NEAR
	MOV	USER_DRV,DX		; ユーザドライブ番号

	CALL	CLS

	PRF	"パレットデータのチェック"

BPPCHK_START:
	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

	INP	"パーツファイル名['Q':EXIT]＝"

	CALL	FLSET			; ファイル名セット

	PRF	"パーツファイル読み込み [*.PT1]"

	CALL	PATCLR			; パーツセットクリア

	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLOD			; パーツロード

BPPCHK_LOOP:
	CALL	CLS
	INP	"パレットの入ったパーツ番号['Q':EXIT,'S':SAVE]＝"
	COMP	"S"			;
	JUMP_EQ	BPPCHK_SAVE		;

	CALL	STRDEC			;
	MOV	CX,DX			; パーツ番号

	MOV	AX,SEG PALET		; パレット用セグメント
	MOV	ES,AX			;
	MOV	BX,WPALET_NUM		; パレットテーブル番号
	SHL	BX,1			; word pointer.
	MOV	AX,ES:PLTOFS[BX]	; パレットアドレステーブル（色相）

	MOV	DX,ES			; パレット用セグメント
	MOV	SI,AX			; パレットテーブル先頭
	CALL	PATBPT			; バイナリデータ読み出し

	MOV	BX,WPALET_NUM		; パレットテーブル番号
	CALL	PLSET			; パレットセット

	CMP	AX,0			; 0=normal end, 1=error.
	JE	BPPCHK2			;
	PRF	"このパーツ番号はパレットのデータでは無いようです"
BPPCHK2:				;
	JMP	BPPCHK_NEXT		;

BPPCHK_SAVE:
	MOV	BX,WPALET_NUM		; パレットテーブル番号
	CALL	PLTDMP			; パレットデータのダンプ

	MOV	BX,WPALET_NUM		; パレットテーブル番号
	CALL	PLSET			; パレットセット

	INP	"パレットファイル *.ALG に書き込みますか？['Y':書き込み]="

	COMP	"Y"			;
	JE	BPPCHK_WRITE		;
	JMP	BPPCHK_NEXT		;

BPPCHK_WRITE:				;

	INP	"パレット書き込みドライブ['Q':EXIT]＝"
	CALL	STRDEC			;
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

	INP	"パレットファイル名[*.ALG,'Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	MOV	BX,WPALET_NUM		; ワーク用パレット番号
	MOV	SI,OFFSET FLNM		; file name.
	CALL	SAVPLT			; パレットファイルセーブ

BPPCHK_NEXT:				;
	JMP	BPPCHK_LOOP		; ループエンド

BPPCHK_EXIT:
	RET
BPPCHK	ENDP



; *******************************************
;	パレットデータのダンプ
;	-I- BX : パレットテーブル番号
; *******************************************

PLTDMP	PROC	NEAR
	PUSH	BX

	SHL	BX,1			; word x 2
	SHL	BX,1			;

	MOV	AX,SEG PALET		; パレット用セグメント
	MOV	ES,AX			;

	PR	"色相 "
	MOV	SI,ES:PLTOFS[BX][0]	; パレットアドレステーブル（色相）
	CALL	DMP8W			; データ表示
	PR	":"
	MOV	SI,ES:PLTOFS[BX][2]	; パレットアドレステーブル（色相）
	CALL	DMP8W			; データ表示
	LF

	PR	"彩度 "
	MOV	SI,ES:PCNOFS[BX][0]	; パレットアドレステーブル（彩度）
	CALL	DMP8W			; データ表示
	PR	":"
	MOV	SI,ES:PCNOFS[BX][2]	; パレットアドレステーブル（彩度）
	CALL	DMP8W			; データ表示
	LF

	PR	"明度 "
	MOV	SI,ES:PBROFS[BX][0]	; パレットアドレステーブル（明度）
	CALL	DMP8W			; データ表示
	PR	":"
	MOV	SI,ES:PBROFS[BX][2]	; パレットアドレステーブル（明度）
	CALL	DMP8W			; データ表示
	LF

	POP	BX
	RET
PLTDMP	ENDP


; *******************************************
;	データ表示
;	-I- ES:[SI] : 表示データ（１ＷＯＲＤ×８）
; *******************************************

DMP8W	PROC	NEAR
	PUSH	BX

	MOV	BP,0			; word pointer.
	MOV	CX,8			; loop counter.
DMP8W_LOOP:				;
	PUSH	CX			;
	PUSH	ES			;
	PUSH	SI			;
	PUSH	BP			;

	MOV	DX,ES:[SI][BP]		;
	CALL	DECSTR			;
	ADD	SI,2			; 先頭の２桁飛ばす
	CALL	PRINT			;

	CMP	CX,1			;
	JE	DMP8W_SKIP		;
	PR	":"			;
DMP8W_SKIP:				;

	POP	BP			;
	POP	SI			;
	POP	ES			;
	POP	CX			;
	INC	BP			;
	INC	BP			; word pointer.
	LOOP	DMP8W_LOOP		;

	POP	BX
	RET
DMP8W	ENDP


; *******************************************
;	ファイル名セット
;	-I- SI : ファイル名
; *******************************************

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

USER_DRV	DW	0		; ユーザドライブ番号
USER_DRV_DEST	DW	0		; ユーザ書き込みドライブ番号

WCOUNT		DW	0		; カウンタ

FLNM	DB	"        ",0,0		; file name.

DATA	ENDS

	END
;
;	end of "BINSET.ASM"
;
