; "TSTPLS.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;
;	データ圧縮テスト
;
;

INCLUDE	TSTSET.INC

TESTID	EQU	0		; プロテクトチェックユニット

DOSDAT	SEGMENT	PUBLIC	'DOSDAT'	; ＦＣＢ／ＤＴＡ領域
EXTRN	DTA:BYTE			; ＤＴＡ
DOSDAT	ENDS


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA,SS:STACK,ES:DATA

	EXTRN	MUSINI:NEAR	; マウスの初期化
	EXTRN	MUSSTP:NEAR	; マウスの終了

	EXTRN	UNPLS:NEAR	; データ復元
	EXTRN	PLESS:NEAR	; データ圧縮

	EXTRN	LODBET:NEAR	; ベタファイルロード
	EXTRN	SAVBET:NEAR	; ベタファイルセーブ

	EXTRN	LODZ88:NEAR	; ＰＣ８８Ｚ’ｓファイルロード
	EXTRN	SAVZ88:NEAR	; ＰＣ８８Ｚ’ｓファイルセーブ

	EXTRN	PLSET:NEAR	; パレットセット
	EXTRN	PLPSET:NEAR	; パレット編集セット

	EXTRN	LODPLT:NEAR	; パレットファイルロード
	EXTRN	SAVPLT:NEAR	; パレットファイルセーブ

	EXTRN	ARAPNT:NEAR	; point pic.
	EXTRN	ARABOX:NEAR	; box pic.

	EXTRN	VTXPRN:NEAR	; vram text print.
	EXTRN	VTXPOR:NEAR	; vram text print OR.
	EXTRN	VTXPFC:NEAR	; vram text print fuchi.
	EXTRN	VTXSIZ:NEAR	; character size set.
	EXTRN	VTXCOL:NEAR	; character color set.

	EXTRN	PLSMOD:NEAR	; 圧縮モード切り替え

	EXTRN	PATINI:NEAR	; パーツセット初期処理
	EXTRN	PATCLR:NEAR	; パーツセットクリア
	EXTRN	PATGET:NEAR	; パーツＧＥＴ
	EXTRN	PATPUT:NEAR	; パーツＰＵＴ
	EXTRN	PATPTX:NEAR	; パーツＰＵＴ座標指定
	EXTRN	PATPTF:NEAR	; パーツＰＵＴオフセット指定
	EXTRN	PATSAV:NEAR	; パーツセーブ
	EXTRN	PATLOD:NEAR	; パーツロード
	EXTRN	PATLDA:NEAR	; パーツ追加ロード

	EXTRN	PRINT:NEAR	; print of string.
	EXTRN	CLS:NEAR	; text clear.
	EXTRN	CSLON:NEAR	; cursole on.
	EXTRN	CSLOFF:NEAR	; cursole off.
	EXTRN	INPCHR:NEAR	; 1 char input.

	EXTRN	PTLIN:NEAR	; XOR line.
	EXTRN	PTXRS:NEAR	; cross line.
	EXTRN	PTBOX:NEAR	; XOR box.
	EXTRN	PTPIC:NEAR	; point pick.
	EXTRN	PTCHG:NEAR	; box point left & right set.
	EXTRN	PTCHK:NEAR	; check same 2 point?
	EXTRN	PTSET:NEAR	; ピックデバイスセット(0=KEY,1=MOUSE)
	EXTRN	PTMODE:NEAR	; ピックモード切り替え

	EXTRN	GDCSRT:NEAR	; graphic start.
	EXTRN	GDCSTP:NEAR	; graphic stop.
	EXTRN	GDCSET:NEAR	; graphic mode set.
	EXTRN	GDCPLT:NEAR	; palette reg set.
	EXTRN	GDCBCR:NEAR	; border color set.
	EXTRN	GDCLIN:NEAR	; line.
	EXTRN	GDCCIR:NEAR	; circle.
	EXTRN	GDCMDE:NEAR	; drawing mode set.
	EXTRN	GDCWAT:NEAR	; GDC wait.
	EXTRN	GDCBOX:NEAR	; box.

	EXTRN	DSKOPN:NEAR	; file open.
	EXTRN	DSKCRE:NEAR	; file open & creat.
	EXTRN	DSKCLS:NEAR	; file close.

	EXTRN	DSKDR:NEAR	; drive number set.

	EXTRN	DSKRED:NEAR	; load 1 byte data.
	EXTRN	DSKWRT:NEAR	; save 1 byte data.

	EXTRN	DSKLD:NEAR	; load data.
	EXTRN	DSKSV:NEAR	; save data.

	EXTRN	DSK600:NEAR	; ＤＴＡの最大バイト数ロード（高速処理用）

	EXTRN	DRPLS:NEAR	; drive number set.
	EXTRN	LDPLS:NEAR	; load pless 16 color CRT data.
	EXTRN	SVPLS:NEAR	; save pless 16 color CRT data.

	EXTRN	PTSET:NEAR	; ピックデバイスセット(0=KEY,1=MOUSE)
	EXTRN	PTMODE:NEAR	; ピックモード切り替え

	EXTRN	VRMCLR:NEAR	; ＶＲＡＭクリア
	EXTRN	DSP16M:NEAR	; １６色モードセット

	EXTRN	CLRCHG:NEAR	; カラーチェンジ

	EXTRN	TXTBOX:NEAR	; テキスト属性ＢＯＸセット

	EXTRN	MUSDAT:NEAR	; マウスカーソルデータファイル作成

	EXTRN	TUCDAT:NEAR	; タッチデータファイル作成

	EXTRN	MSKPLT:NEAR	; マスクデータファイル作成
	EXTRN	MSKPAR:NEAR	; マスクファイルチェック


;voidvoidvoid
;voidvoidvoid

;voidvoidvoid
;voidvoidvoid


	EXTRN	VCHHST:NEAR	; 縦横バイト並べ替え
	EXTRN	VCHRTW:NEAR	; 縦横バイト並べ戻し
	EXTRN	VCHSEL:NEAR	; ＶＲＡＭ偶数ライン１ビット左シフト
	EXTRN	VCHSER:NEAR	; ＶＲＡＭ偶数ライン１ビット右シフト

	EXTRN	VCXHST:NEAR	; 縦横バイト並べ替え
	EXTRN	VCXRTW:NEAR	; 縦横バイト並べ戻し

	EXTRN	VRMEDT:NEAR	; ＶＲＡＭエディタ

	EXTRN	BPPSET:NEAR	; パレットデータのセット
	EXTRN	BPPCHK:NEAR	; パレットデータのチェック
	EXTRN	BPPLST:NEAR	; パレットファイル読み込みパーツセット

	EXTRN	PLTPAT:NEAR	; パーツバッファからパレットを取り出す

	EXTRN	ALLPLS:NEAR	; 自動取り込み工程

	EXTRN	AANIME:NEAR	; オート・アニメ

	EXTRN	CHIPGET:NEAR	; チップＧＥＴ

	EXTRN	TMWAIT:NEAR	; time wait.
	EXTRN	TMVSRT:NEAR	; V-SYNC timer start.
	EXTRN	TMVEND:NEAR	; V-SYNC timer end.
	EXTRN	TMVWAT:NEAR	; V-SYNC timer wait.
	EXTRN	TMVSET:NEAR	; V-SYNC timer set.
	EXTRN	TMVCHK:NEAR	; V-SYNC timer check.
	EXTRN	TMVCLR:NEAR	; V-SYNC timer clear.
	EXTRN	TMVST2:NEAR	; V-SYNC timer2 set.
	EXTRN	TMVCK2:NEAR	; V-SYNC timer2 check.
	EXTRN	TMVST3:NEAR	; V-SYNC timer3 set.
	EXTRN	TMVCK3:NEAR	; V-SYNC timer3 check.
	EXTRN	TMVSTP:NEAR	; V-SYNC timer stop.
	EXTRN	TMVCNT:NEAR	; V-SYNC timer cont.
	EXTRN	TMVSAV:NEAR	; V-SYNC timer value save.
	EXTRN	TMVLOD:NEAR	; V-SYNC timer value load.

	EXTRN	BUNPLE:NEAR	; 圧縮フォーマットデータ復元
	EXTRN	BPLESS:NEAR	; バイナリデータ圧縮

	EXTRN	MITPRN:NEAR	; string. (null=end of string)


	EXTRN	PROTECT_SCC:NEAR	; ＳＣＣ厚木プロテクト
PROTECT_CHECK_UNIT	EQU	0	; プロテクトチェックユニット番号


	PUBLIC	VTXPAC		; ｾﾘﾌ 1ﾓｼﾞ ｺﾞﾄﾆ call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ｻｾﾃ ｸﾀﾞｻｲ｡
	PUBLIC	VTXEND		; ｾﾘﾌ ﾉ ｵﾜﾘ ﾆ   call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ﾄﾒﾃ ｸﾀﾞｻｲ｡
	VTXPAC:RET		; ｾﾘﾌ 1ﾓｼﾞ ｺﾞﾄﾆ call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ｻｾﾃ ｸﾀﾞｻｲ｡
	VTXEND:RET		; ｾﾘﾌ ﾉ ｵﾜﾘ ﾆ   call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ﾄﾒﾃ ｸﾀﾞｻｲ｡


START:	PUSH	DS

	MOV	AX,SEG DATA
	MOV	DS,AX

	MOV	AX,SS			; stack segment.
	MOV	SAVE_SS,AX		;
	MOV	SAVE_SP,SP		; stack pointer.

	MOV	AX,SEG STACK		; stack segment.
	MOV	SS,AX			;
	MOV	SP,OFFSET TOP_OF_STACK	; stack pointer.

	MOV	MOUSFL,0		; mouse flag 1=MOUSE.

	CALL	TMVSRT			; V-SYNC timer start.
	CALL	MAIN
	CALL	TMVEND			; V-SYNC timer end.

	CMP	MOUSFL,1		; mouse flag 1=MOUSE.
	JNE	MOUSE98			;
	CALL	MUSSTP			; マウスの終了
MOUSE98:

	CALL	CSLON			; カーソルＯＮ

	MOV	AX,SAVE_SS		;
	MOV	SS,AX			; stack segment.
	MOV	SP,SAVE_SP		; stack pointer.

	POP	DS
FINALE:	MOV	AH,4CH
	MOV	AL,0
	INT	21H



VRAMDSP0	MACRO
	MOV	AL,00H
	OUT	0A4H,AL
	ENDM

VRAMDSP1	MACRO
	MOV	AL,01H
	OUT	0A4H,AL
	ENDM


VRAMWRT0	MACRO
	MOV	AL,00H
	OUT	0A6H,AL
	ENDM

VRAMWRT1	MACRO
	MOV	AL,01H
	OUT	0A6H,AL
	ENDM




; *******************************************
;	ｍａｉｎ
; *******************************************


MAIN	PROC	NEAR
	VRAMDSP0
	VRAMWRT0

	CALL	CLS		; text clear.
	CALL	CSLOFF		; cursole off.

IF	TESTID

	LC	0,10		;
	MOV	AX,PROTECT_CHECK_UNIT	; プロテクトチェックユニット番号
	CALL	PROTECT_SCC	; ＳＣＣ厚木プロテクト
	CMP	AX,1		; 1=original,2=copy.
	JE	MAIN_START	;
	RET
ENDIF
MAIN_START:

	CALL	DSP16M		; １６色モードセット

	MOV	AX,1		;
	CALL	VTXSIZ		; character size set.

	MOV	AX,2
	CALL	VTXCOL		; character color set.

	CALL	PATINI		; パーツセット初期処理

	INP	"作業ドライブ設定[Q:EXIT,A:ｱﾆﾒ]＝"
	COMP	"A"
	JE	ANIME_CALL
	COMP	"a"
	JE	ANIME_CALL
	JMP	MAIN1
ANIME_CALL:
	CALL	AANIME		; オート・アニメ
	RET
MAIN1:
	CALL	STRDEC		;
	MOV	USER_DRV,DX	; ユーザドライブ番号
	MOV	AX,DX		; drive number.
	CALL	DSKDR		; drive number set.

	MOV	AX,1		; 1=Ｘ方向バイト単位
	CALL	PTMODE		; ピックモード切り替え

	INP	"ピックデバイスセット(0=KEY,1=MOUSE)"

	CALL	STRDEC		;
	MOV	MOUSFL,DX	; mouse.
	MOV	AX,DX		;
	CALL	PTSET		; ピックデバイスセット(0=KEY,1=MOUSE)

	CMP	MOUSFL,1	;
	JNE	MAIN33		;
	PUSH	SI		;
	CALL	MUSINI		; マウスの初期化
	POP	SI		;
MAIN33:

MAIN_MENU:

PRF " 0: パーツファイル作成			19: 自動取り込み工程"
PRF " 1: パーツファイルチェック		20: オート・アニメ"
PRF " 2: 全画面データ圧縮ファイルセーブ	21: ＊＊＊＊＊＊＊＊＊＊＊＊＊"
PRF " 3: 全画面データ圧縮ファイルロード	22: ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
PRF " 4: カラーチェンジ			23: チップＧＥＴ"
PRF " 5: マウスカーソルファイル作成	"
PRF " 6: タッチ属性ファイル作成		"
PRF " 7: マスクデータファイル作成	"
PRF " 8: マスクファイルチェック		"
PRF " 9: ＊＊＊＊＊＊＊＊		"
PRF "10: ＊＊＊＊＊＊＊＊＊＊		"
PRF "11: 全画面ﾃﾞｰﾀ圧縮ﾌｧｲﾙセーブ(高圧縮)"
PRF "12: 全画面ﾃﾞｰﾀ圧縮ﾌｧｲﾙロード(高圧縮)"
PRF "13: テキストテスト			"
PRF "14: Ｚｓ’８８無圧縮ファイルを９８ベタファイルに"
PRF "15: 今のＶＲＡＭセーブ		"
PRF "16: ＶＲＡＭエディタ		"
PRF "17: パレットデータのセット		"
PRF "18: パレットデータのチェック	"

MENU_MIN	EQU	0		; メニュー最小番号
MENU_MAX	EQU	23		; メニュー最大番号

MAIN00001:				;
	INP	" 処理番号[Q:EXIT,*:明るい]＝"

	CMP	DS:[SI],BYTE PTR '*'	;
	JNE	MAIN001			;
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット
	CALL	CLS			;
	INP	" "			;
	CALL	HARFBR			; 明度５０％
	JMP	MAIN00001		;
MAIN001:				;

	CMP	DS:[SI],BYTE PTR ' '	; 入力なかったら
	JNBE	MAIN_SELECT		;
	JMP	MAIN_MENU		;
MAIN_SELECT:				;

	CALL	STRDEC			; ＤＸ＝選択番号は？
	CMP	DX,MENU_MIN		; メニュー最小番号
	JGE	MAIN002			;
	JMP	MAIN_MENU		;
MAIN002:				;
	CMP	DX,MENU_MAX		; メニュー最大番号
	JLE	MAIN003			;
	JMP	MAIN_MENU		;
MAIN003:				;

	MOV	BX,DX			;
	SHL	BX,1			; word pointer.
	JMP	CS:MAIN_JUMP_TABLE[BX]	; 指定の処理へジャンプ

	EVEN
MAIN_JUMP_TABLE	LABEL	WORD
	DW	OFFSET MAIN_MAKE	; 0
	DW	OFFSET MAIN_LOAD	; 1
	DW	OFFSET MAIN_FULL_PLS	; 2
	DW	OFFSET MAIN_FULL_LOAD	; 3
	DW	OFFSET MAIN_COLOR_CHNGE	; 4
	DW	OFFSET MAIN_MUSCOR_DAT	; 5
	DW	OFFSET MAIN_TOUCH_DAT	; 6
	DW	OFFSET MAIN_MASK_DAT	; 7
	DW	OFFSET MAIN_MASK_CHK	; 8
	DW	OFFSET MAIN_TEXT_LOCK	; 9
	DW	OFFSET MAIN_TEXT_UNLOCK	;10
	DW	OFFSET MAIN_FULZZ_SAVE	;11
	DW	OFFSET MAIN_FULZZ_LOAD	;12
	DW	OFFSET MAIN_TEXT_TEST	;13
	DW	OFFSET MAIN_Z88LOAD	;14
	DW	OFFSET MAIN_VRAMSAVE	;15
	DW	OFFSET MAIN_VRAMEDIT	;16
	DW	OFFSET MAIN_17		;17
	DW	OFFSET MAIN_18		;18
	DW	OFFSET MAIN_19		;19
	DW	OFFSET MAIN_20		;20
	DW	OFFSET MAIN_21		;21
	DW	OFFSET MAIN_22		;22
	DW	OFFSET MAIN_23		;23
	DW	OFFSET MAIN_FINALE	;end.
	DW	OFFSET MAIN_FINALE	;end.
	DW	OFFSET MAIN_FINALE	;end.
	DW	OFFSET MAIN_FINALE	;end.


MAIN_MAKE:			;
	CALL	MUSPLOT		; パーツファイル作成
	JMP	MAIN_FINALE	;
MAIN_LOAD:			;
	CALL	MUSPART		; テスト・パーツファイルチェック
	JMP	MAIN_FINALE	;
MAIN_FULL_PLS:			;
	CALL	FULLPLS		; フル画面圧縮
	JMP	MAIN_FINALE	;
MAIN_FULL_LOAD:			;
	CALL	FULLLOAD	; フル画面圧縮ファイルロード
	JMP	MAIN_FINALE	;
MAIN_COLOR_CHNGE:		;
	CALL	COLOR_CHANGE	; カラーチェンジ
	JMP	MAIN_FINALE	;
MAIN_MUSCOR_DAT:		;
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	MUSDAT		; マウスカーソルデータファイル作成
	JMP	MAIN_FINALE	;
MAIN_TOUCH_DAT:			;
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	TUCDAT		; タッチデータファイル作成
	JMP	MAIN_FINALE	;
MAIN_MASK_DAT:			;
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	MSKPLT		; マスクデータファイル作成
	JMP	MAIN_FINALE	;
MAIN_MASK_CHK:			;
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	MSKPAR		; マスクファイルチェック
	JMP	MAIN_FINALE	;
MAIN_TEXT_LOCK:			;
;voidvoidvoid
	JMP	MAIN_FINALE	;
MAIN_TEXT_UNLOCK:		;
;voidvoidvoid
	JMP	MAIN_FINALE	;
MAIN_FULZZ_SAVE:		;
	CALL	FLZZPLS		; 全画面データ圧縮ファイルセーブ（高圧縮）
	JMP	MAIN_FINALE	;
MAIN_FULZZ_LOAD:		;
	CALL	FLZZLOAD	; 全画面データ圧縮ファイルロード（高圧縮）
	JMP	MAIN_FINALE	;
MAIN_TEXT_TEST:			;
	CALL	TXTTEST		; テキストテスト
	JMP	MAIN_FINALE	;
MAIN_Z88LOAD:			;
	CALL	Z88LOAD		; Ｚｓ’８８無圧縮ファイル名"
	JMP	MAIN_FINALE	;
MAIN_VRAMSAVE:			;
	CALL	VRAM_SAVE	; ＶＲＡＭイメージセーブ
	JMP	MAIN_FINALE	;
MAIN_VRAMEDIT:			;
	CALL	VRMEDT		; ＶＲＡＭエディタ
	JMP	MAIN_FINALE	;
MAIN_17:			;
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	BPPSET		; パレットデータのセット
	JMP	MAIN_FINALE	;
MAIN_18:			;
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	BPPCHK		; パレットデータのチェック
	JMP	MAIN_FINALE	;
MAIN_19:			;
	MOV	DX,USER_DRV	; ユーザドライブ番号
	CALL	ALLPLS		; 自動取り込み工程
	JMP	MAIN_FINALE	;
MAIN_20:			;
	CALL	AANIME		; オート・アニメ
	JMP	MAIN_FINALE	;
MAIN_21:			;
;voidvoidvoid
	JMP	MAIN_FINALE	;
MAIN_22:			;
;voidvoidvoid
	JMP	MAIN_FINALE	;
MAIN_23:			;
	CALL	CHIPGET		; チップＧＥＴ
	JMP	MAIN_FINALE	;

MAIN_FINALE:
	JMP	MAIN_MENU

	RET
MAIN	ENDP



; *******************************************
;	パーツファイル作成
; *******************************************

MUSPLOT	PROC	NEAR
	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え

	PRF	"パーツファイル作成 [*.PT1]"

	MOV	GETNUM,0		; パーツ番号用カウンタ
	MOV	ARA_BAK_FLG,0		; 1=退避データあり,0=なし

	CALL	PATCLR			; パーツセットクリア

	INP	"書き込みドライブ＝"	;
	CALL	STRDEC			;
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号


	INP	"パレットファイルを読み込んでセットしておきますか['Y':セット]"
	COMP	"Y"			;
	JNE	MUSPLOT_PALET_SKIP	;
	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.
	CALL	BPPLST			; パレットファイル読み込みパーツセット
	INC	GETNUM			; パーツ番号用カウンタ
MUSPLOT_PALET_SKIP:			;

	INP	"圧縮方向指定[1=縦方向]＝"
	CALL	STRDEC			;
	MOV	PLSDIR_FLG,DX		; 圧縮方向指定[1=縦方向]

MUSPLOT_START:
	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

	MOV	AX,GETNUM		;
	MOV	GETNUM_OFSET,AX		; パーツ番号オフセット

	CALL	VRMCLR			; ＶＲＡＭクリア

	INP	"ファイル名['Q':EXIT]＝"
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

	CALL	HARFBR			; 明度５０％

	CMP	ARA_BAK_FLG,1		; 1=退避データあり,0=なし
	JE	MUSPLOT_1		;
	INP	"圧縮（ＲＥＴキーを押して） "
	JMP	MUSPLOT_PLOT		;
MUSPLOT_1:
	INP	"圧縮（ＲＥＴキーを押して） ['N':前回の座標を使う]"
	COMP	"N"			;
	JE	MUSPLOT_BAK_SET		;
	COMP	"n"			;
	JE	MUSPLOT_BAK_SET		;
	JMP	MUSPLOT_PLOT		;

MUSPLOT_BAK_SET:			;
	MOV	AX,ARA_BAK_X1		; ＧＥＴ座標の退避
	MOV	BX,ARA_BAK_Y1		;
	MOV	CX,ARA_BAK_X2		; ＧＥＴ座標の退避
	MOV	DX,ARA_BAK_Y2		;
	MOV	VRX,AX			;
	MOV	VRY,BX			;
	MOV	VRLENX,CX		;
	MOV	VRLENY,DX		;

	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MUSPLOT111		;
	CALL	VCXHST			; 縦横バイト並べ替え
MUSPLOT111:				;
	CALL	PATGET			; パーツＧＥＴ

	PRV	"AX=",AX
	PRV	"個数＝",GETNUM
	PRVH	"データ終わりアドレス＋１BPOINT=",BPOINT

	INC	GETNUM
	JMP	MUSPLOT_START		; next try.



MUSPLOT_PLOT:
	CALL	CLS			;
	CALL	MSWAT			; カーソルボタンＯＦＦ待ち
	MOV	BX,0			;
	CALL	PLSET			;
	CALL	ARABOX			; box pic.
	CALL	CLS			; text clear.
	CMP	AX,2			; ２＝強制終了
	JNE	MUSPLOT2		;
	JMP	MUSPLOT55		;
MUSPLOT2:
	MOV	AX,VX1			;
	MOV	VRX,AX			; ＶＲＡＭ　Ｘ座標
	MOV	BX,VX2			;
	SUB	BX,AX			; Ｘ方向長さ
	INC	BX			;
	MOV	VRLENX,BX		; Ｘ方向長さ

	MOV	AX,VY1			;
	MOV	VRY,AX			; ＶＲＡＭ　Ｙ座標
	MOV	BX,VY2			;
	SUB	BX,AX			; Ｙ方向長さ
	INC	BX			;
	MOV	VRLENY,BX		; Ｙ方向長さ

	PRVH	"VRX=",VRX		; ＶＲＡＭ　Ｘ座標
	PRVH	"VRY=",VRY		; ＶＲＡＭ　Ｙ座標
	PRVH	"VRLENX=",VRLENX	; Ｘ方向長さ
	PRVH	"VRLENY=",VRLENY	; Ｙ方向長さ

	MOV	AX,VRX			;
	MOV	BX,VRY			;
	MOV	CX,VRLENX		;
	MOV	DX,VRLENY		;
	MOV	ARA_BAK_X1,AX		; ＧＥＴ座標の退避
	MOV	ARA_BAK_Y1,BX		;
	MOV	ARA_BAK_X2,CX		; ＧＥＴ座標の退避
	MOV	ARA_BAK_Y2,DX		;
	MOV	ARA_BAK_FLG,1		; 1=退避データあり

MUSPLOT_POINTSET:
	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MUSPLOT21		;
	CALL	VCXHST			; 縦横バイト並べ替え
MUSPLOT21:				;

	CALL	PATGET			; パーツＧＥＴ
	CMP	AX,0			;
	JNE	MUSPLOT45		;

	PRV	"個数＝",GETNUM

	INC	GETNUM

MUSPLOT45:
	PRVH	"データ長さ              BCOUNT=",BCOUNT
	PRVH	"データ終わりアドレス＋１BPOINT=",BPOINT
	PRVH	"0=normal end. 1=write error.AX=",AX


	JMP	MUSPLOT_PLOT		; loop end.



	; ここから復元

MUSPLOT55:
	CALL	VRMCLR			; ＶＲＡＭクリア
	INP	"復元（ＲＥＴキーを押して）"
	MOV	AX,GETNUM_OFSET		; パーツ番号オフセット
	MOV	GETNUM_CHK,AX		; パーツ番号チェック
MUSPLOT56:				;
	CALL	MSWAT			; カーソルボタンＯＦＦ待ち
	CALL	ARAPNT			; point pic.
	CMP	AX,2			; ２＝強制終了
	JNE	MUSPLOT57		;
	JMP	MUSPLOT9		;
MUSPLOT57:				;
	CALL	CLS			; text clear.

	MOV	AX,VX1			;
	MOV	VRX,AX			; ＶＲＡＭ　Ｘ座標
	MOV	AX,VY1			;
	MOV	VRY,AX			; ＶＲＡＭ　Ｙ座標

	MOV	CX,GETNUM_CHK		; パーツ番号チェック

;*NON*;	CALL	PATPTX			; パーツＰＵＴ座標指定

	CALL	PATPUT			; パーツＰＵＴ

	PRVH	"0:normal end. 1:error.AX=",AX

	CMP	AX,1			;
	JUMP_EQ	MUSPLOT_START		; next try.

	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MUSPLOT87		;
	PUSH	AX			;
	CALL	VCXRTW			; 縦横バイト並べ戻し
	POP	AX			;
MUSPLOT87:				;
	PRV	"個数＝",GETNUM_CHK

	INC	GETNUM_CHK		; パーツ番号チェック

	JMP	MUSPLOT56		;



MUSPLOT9:				;
	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.


	INP	"パーツファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット
	PRF	"パーツファイル書き込み [*.PT1]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATSAV			; パーツセーブ

MUSPLOT_EXIT:
	RET
MUSPLOT	ENDP



; *******************************************
;	テスト・パーツファイルチェック
; *******************************************

MUSPART	PROC	NEAR
	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD			; 圧縮モード切り替え

	CALL	CLS			; text clear.

	PRF	"パーツファイルチェック [*.PT1]"

	MOV	GETNUM,0		;
	CALL	PATCLR			; パーツセットクリア

	INP	"圧縮方向指定[1=縦方向]＝"

	CALL	STRDEC			;
	MOV	PLSDIR_FLG,DX		; 圧縮方向指定[1=縦方向]

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

	CALL	HARFBR			; 明度５０％

	INP	"パーツファイル名['Q':EXIT]＝"

	CALL	FLSET			; ファイル名セット

	PRF	"パーツファイル読み込み"

	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLOD			; パーツロード


MUSPART_TSUIKA:
	INP	"追加パーツファイル名['T':ﾃｽﾄｽﾀｰﾄ 'Q':EXIT]＝"
	COMP	"T"			;
	JE	MUSPART_TSUIKA_E	;

	CALL	FLSET			; ファイル名セット

	PRF	"追加パーツファイル読み込み"

	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATLDA			; パーツ追加ロード

	JMP	MUSPART_TSUIKA		;
MUSPART_TSUIKA_E:


	INP	"復元（ＲＥＴキーを押して）"

	CALL	CLS			; text clear.

	MOV	GETNUM,0		;

MUSPART_PUTS_LOOP:			;
;*NON*;	CALL	MSWAT			; カーソルボタンＯＦＦ待ち
	MOV	AX,4			;
	CALL	TMVWAT			; timer wait.
	CALL	ARAPNT			; point pic.
	CMP	AX,2			; ２＝強制終了
	JNE	MUSPART57		;
	JMP	MUSPART_END		;
MUSPART57:				;
	CALL	CLS			; text clear.

	PRV	"個数＝",GETNUM

	MOV	AX,VX1			;
	MOV	VRX,AX			; ＶＲＡＭ　Ｘ座標
	MOV	AX,VY1			;
	MOV	VRY,AX			; ＶＲＡＭ　Ｙ座標

	MOV	CX,GETNUM		;
	INC	GETNUM			;

	MOV	BX,0			; パレットテーブル番号
	CALL	PLTPAT			; パーツバッファからパレットを取り出す
	CMP	AX,0			; 0=normal end, 1=error.
	JNE	MUSPART_PUT		;

	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	JMP	MUSPART777		;

MUSPART_PUT:				;

	CALL	PATPTF			; パーツＰＵＴオフセット指定

;*NON*;	CALL	PATPTX			; パーツＰＵＴ座標指定
	CMP	AX,1			;
	JNE	MUSPART77		;
	MOV	GETNUM,0		;
	JMP	MUSPART777		;
MUSPART77:				;

	CMP	PLSDIR_FLG,1		; 圧縮方向指定[1=縦方向]
	JNE	MUSPART777		;
	PUSH	AX			;
	CALL	VCXRTW			; 縦横バイト並べ戻し
	POP	AX			;
MUSPART777:				;
	JMP	MUSPART_PUTS_LOOP	; loop end.



MUSPART_END:
	INP	"パーツファイル *.PT1 に書き込みますか？['Y':書き込み]="

	COMP	"Y"			;
	JE	MUSPART_WRT		;
	JMP	MUSPART_NEXT		;
MUSPART_WRT:				;

	INP	"パーツ書き込みドライブ['Q':EXIT]＝"
	CALL	STRDEC			;
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

	INP	"パーツファイル名[*.PT1,'Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	MOV	SI,OFFSET FLNM		; file name.
	CALL	PATSAV			; パーツセーブ

MUSPART_NEXT:
	JMP	MUSPART			; リトライ

MUSPART_EXIT:
	RET
MUSPART	ENDP



; *******************************************
;	フル画面圧縮
; *******************************************

FULLPLS	PROC	NEAR
	CALL	VRMCLR			; ＶＲＡＭクリア

	PRF	"フル画面圧縮 [*.PLS]"

	INP	"書き込みドライブ＝"
	CALL	STRDEC
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

FULLPLS_START:
	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

	INP	"ファイル名['Q':EXIT]＝"
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

	CALL	HARFBR			; 明度５０％

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	PRF	"フル画面圧縮ファイル書き込み [*.PLS]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	SVPLS			; save pless 16 color CRT data.

	PRVH	"save byte count hi. (dabule word counter)=",DX
	PRVH	"save byte count low.(dabule word counter)=",AX
	PRV	"save paragraph count.                    =",CX
	MOV	DX,0
	MOV	AX,CX
	MOV	BX,80			; ( 12800/16 ) /100
	IDIV	BX
	PRV	"圧縮率＝",AX

	JMP	FULLPLS_START

	RET
FULLPLS	ENDP



; *******************************************
;	フル画面圧縮ファイルロード
; *******************************************

FULLLOAD	PROC	NEAR
	CALL	VRMCLR			; ＶＲＡＭクリア
FULLLOAD2:
	CALL	CLS			; text clear.
	PRF	"フル画面圧縮ロード [*.PLS]"

	INP	"ファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット

	CALL	VRMCLR			; ＶＲＡＭクリア

	PRF	"パレットファイル読み込み [*.ALG]"
	MOV	SI,OFFSET FLNM		; file name.
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	PRF	"フル画面圧縮ファイル読み込み [*.PLS]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LDPLS			; load pless 16 color CRT data.

	CALL	HARFBR			; 明度５０％
	CALL	POINTPRINT		; 座標表示

	JMP	FULLLOAD2

FULLLOAD	ENDP


; *******************************************
;	カラーチェンジ
; *******************************************

COLOR_CHANGE	PROC	NEAR
	CALL	VRMCLR			; ＶＲＡＭクリア
COLOR_CHANGE2:
	CALL	CLS			; text clear.
	PRF	"カラーチェンジテスト"

	INP	"ファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット

	CALL	VRMCLR			; ＶＲＡＭクリア

	PRF	"パレットファイル読み込み [*.ALG]"
	MOV	SI,OFFSET FLNM		; file name.
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	PRF	"フル画面圧縮ファイル読み込み [*.PLS]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LDPLS			; load pless 16 color CRT data.

	CALL	HARFBR			; 明度５０％

	CALL	CLS			; text clear.
COLOR_CHANGE3:				;
	INP	"変更カラーパレット"
	CALL	STRDEC
	MOV	CLRSOU,DX		; 変更カラーパレット
	INP	"変更後カラーパレット"
	CALL	STRDEC
	MOV	CLRDES,DX		; 変更後カラーパレット

	CALL	MSWAT			; カーソルボタンＯＦＦ待ち
	CALL	ARABOX			; box pic.
	CMP	AX,2			; ２＝強制終了
	JNE	COLOR_CHANGE4		;
	JMP	COLOR_CHANGE5		;
COLOR_CHANGE4:
	CALL	CLRCHG			; color change.
	JMP	COLOR_CHANGE3
COLOR_CHANGE5:
	JMP	COLOR_CHANGE2

	RET
COLOR_CHANGE	ENDP



; *******************************************
;	11: 全画面データ圧縮ファイルセーブ（高圧縮）
; *******************************************

FLZZPLS	PROC	NEAR
	CALL	VRMCLR			; ＶＲＡＭクリア

	PRF	"全画面データ圧縮ファイルセーブ（高圧縮）[*.PLS]"

	INP	"書き込みドライブ＝"
	CALL	STRDEC
	MOV	USER_DRV_DEST,DX	; ユーザ書き込みドライブ番号

FLZZPLS_START:
	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

	INP	"ファイル名['Q':EXIT]＝"
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

	CALL	HARFBR			; 明度５０％

	MOV	AX,USER_DRV_DEST	; ユーザ書き込みドライブ番号
	CALL	DSKDR			; drive number set.

	PRF	"ＶＲＡＭ偶数ライン１ビット左シフト"
	CALL	VCHSEL			; ＶＲＡＭ偶数ライン１ビット左シフト

	PRF	"縦横バイト並べ替え"
	CALL	VCHHST			; 縦横バイト並べ替え

	PRF	"フル画面圧縮ファイル書き込み [*.PLS]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	SVPLS			; save pless 16 color CRT data.

	PRVH	"save byte count hi. (dabule word counter)=",DX
	PRVH	"save byte count low.(dabule word counter)=",AX
	PRV	"save paragraph count.                    =",CX
	MOV	DX,0
	MOV	AX,CX
	MOV	BX,80			; ( 12800/16 ) /100
	IDIV	BX
	PRV	"圧縮率＝",AX

	JMP	FLZZPLS_START

	RET
FLZZPLS	ENDP




; *******************************************
;	12: 全画面データ圧縮ファイルロード（高圧縮）
; *******************************************

FLZZLOAD	PROC	NEAR
	CALL	VRMCLR			; ＶＲＡＭクリア
FLZZLOAD2:
	CALL	CLS			; text clear.

	PRF	"全画面データ圧縮ファイルロード（高圧縮）[*.PLS]"

	INP	"ファイル名['Q':EXIT]＝"
	CALL	FLSET			; ファイル名セット

	CALL	VRMCLR			; ＶＲＡＭクリア

	PRF	"パレットファイル読み込み [*.ALG]"
	MOV	SI,OFFSET FLNM		; file name.
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	PRF	"フル画面圧縮ファイル読み込み [*.PLS]"
	MOV	SI,OFFSET FLNM		; file name.
	CALL	LDPLS			; load pless 16 color CRT data.

	PRF	"縦横バイト並べ戻し"
	CALL	VCHRTW			; 縦横バイト並べ戻し

	PRF	"ＶＲＡＭ偶数ライン１ビット右シフト"
	CALL	VCHSER			; ＶＲＡＭ偶数ライン１ビット右シフト

	CALL	HARFBR			; 明度５０％
	CALL	POINTPRINT		; 座標表示

	JMP	FLZZLOAD2

FLZZLOAD	ENDP



; *******************************************
;	ＶＲＡＭイメージセーブ
; *******************************************

VRAM_SAVE	PROC	NEAR

	INP	"ＶＲＡＭ　０ｏｒ１"

	CALL	STRDEC
	CMP	DX,1
	JE	VRAM_SAVE1
	VRAMDSP0
	VRAMWRT0
	JMP	VRAM_SAVE12
VRAM_SAVE1:
	VRAMDSP1
	VRAMWRT1
VRAM_SAVE12:

	CALL	HARFBR			; 明度５０％

	INP	"ファイル名['Q':EXIT]＝"

	CALL	FLSET			; ファイル名セット

	PRF	"ＶＲＡＭファイル書き込み [*.B1,R1,G1,E1]"

	MOV	SI,OFFSET FLNM
	CALL	SAVBET			; ベタファイルセーブ

	RET
VRAM_SAVE	ENDP



;voidvoidvoid

TEXTLOCK	PROC	NEAR
;voidvoidvoid

	INP	"読み込みファイル名"
	SETS	LCFLRD			; read file name.
	INP	"書き込みファイル名"
	SETS	LCFLWT			; write file name.

;voidvoidvoid

	RET
TEXTLOCK	ENDP


;voidvoidvoid

TEXTUNLOCK	PROC	NEAR
;voidvoidvoid

	INP	"読み込みファイル名"
	SETS	LCFLRD			; read file name.
	INP	"書き込みファイル名"
	SETS	LCFLWT			; write file name.

;voidvoidvoid

	RET
TEXTUNLOCK	ENDP




; *
;voidvoidvoid
; *


;voidvoidvoid

TEXT_P_LOCK	PROC	NEAR
;voidvoidvoid

	CALL	FL_CLR			; ファイル名クリア

	INP	"読み込みファイル名"
	SETS	FLNM			; file name.

	INP	"書き込みファイル名"
	SETS	LCFLWT			; write file name.

	MOV	AX,SEG DOSDAT		; ＦＣＢ／ＤＴＡ領域
	MOV	ES,AX			;
	MOV	DI,OFFSET DTA		; string.
	MOV	CX,65000		; length.
	MOV	AL,0			; charcter.
	CALL	CHRSET			; char set.

	MOV	SI,OFFSET FLNM		; file name.
	CALL	DSKOPN			; file open.
	CMP	AX,0			; 0:normal.
	JE	TEXT_P_LOCK2		; 1:open error.
	PRF	"ファイルが見つからない"
	JMP	TEXT_P_LOCK		;

TEXT_P_LOCK2:
	CALL	DSK600			; ＤＴＡの最大バイト数ロード
	CALL	DSKCLS			; file close.

	MOV	AX,SEG DOSDAT		; ＦＣＢ／ＤＴＡ領域
	MOV	ES,AX			;
	MOV	DI,OFFSET DTA		; string.
	CALL	STRLEN			; string length.(max65530)

	MOV	CX,AX			; length. データ長さ
	MOV	DX,SEG DOSDAT		; ＦＣＢ／ＤＴＡ領域
	MOV	SI,OFFSET DTA		; string. DX:[SI]: バイナリデータ

	MOV	AX,ARAVRM[0]		; vram area.
	MOV	BPNTSG,AX		; データバッファセグメント
	MOV	BPNTOF,0		; データバッファポインタ
	MOV	BCNTMX,65000		; データ最大長さ

	
	PRV	"バイナリデータ圧縮-I-CX=",CX
	CALL	BPLESS			; バイナリデータ圧縮
	PRF	"バイナリデータ圧縮-O-"


	CMP	AH,1			; 0 or 2 : normal end. 1:write error.
	JNE	TEXT_P_LOCK3		;

	PRF	"圧縮エラー発生"	;

	JMP	TEXT_P_LOCK		;

TEXT_P_LOCK3:
	MOV	CX,BCOUNT		; データ長さ
	MOV	DX,ARAVRM[0]		; vram area.
	MOV	DI,0			; データバッファセグメント

	MOV	SI,OFFSET FL_ZL_TMP	; file name.
	CALL	DSKSV			; save data.

	MOV	SI,OFFSET FL_ZL_TMP	; file name.
	SETS	LCFLRD			; read file name.
;voidvoidvoid

	RET
TEXT_P_LOCK	ENDP



;voidvoidvoid

TEXT_P_UNLOCK	PROC	NEAR
;voidvoidvoid

	CALL	FL_CLR			; ファイル名クリア

	INP	"読み込みファイル名"
	SETS	LCFLRD			; read file name.
	INP	"書き込みファイル名"
	SETS	LCFLWT			; write file name.
	SETS	FLNM			; file name.

;voidvoidvoid

	MOV	SI,OFFSET FLNM		; file name.
	CALL	DSKOPN			; file open.
	CMP	AX,0			; 0:normal.
	JE	TEXT_P_UNLOCK2		; 1:open error.
	PRF	"ファイルが見つからない"
	JMP	TEXT_P_UNLOCK		;

TEXT_P_UNLOCK2:
	CALL	DSK600			; ＤＴＡの最大バイト数ロード
	CALL	DSKCLS			; file close.


	MOV	AX,ARAVRM[0]		; vram area.
	MOV	ES,AX			;
	MOV	DI,0			; string.
	MOV	CX,65000		; length.
	MOV	AL,0			; charcter.
	CALL	CHRSET			; char set.


	MOV	BPNTSG,SEG DOSDAT	; ＦＣＢ／ＤＴＡ領域
	MOV	BPNTOF,OFFSET DTA	; string. DX:[SI]: バイナリデータ

	MOV	AX,ARAVRM[0]		; vram area.
	MOV	ES,AX			;
	MOV	DI,0			;
	CALL	BUNPLE			; 圧縮フォーマットデータ復元


	MOV	AX,ARAVRM[0]		; vram area.
	MOV	ES,AX			;
	MOV	DI,0			;
	CALL	STRLEN			; string length.(max65530)
	MOV	CX,AX			; length.

	MOV	DX,ARAVRM[0]		; vram area.
	MOV	DI,0			; データバッファセグメント
	MOV	SI,OFFSET FLNM		; file name.
	CALL	DSKSV			; save data.

	RET
TEXT_P_UNLOCK	ENDP

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

;	ファイル名クリア

FL_CLR	PROC	NEAR
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	AL,' '			;
	MOV	CX,8			;
	MOV	DI,OFFSET LCFLRD	; read file name.
	REP	STOSB			;
	MOV	CX,8			;
	MOV	DI,OFFSET LCFLWT	; write file name.
	REP	STOSB			;
	MOV	CX,8			;
	MOV	DI,OFFSET FLNM		; file name.
	REP	STOSB			;
	RET
FL_CLR	ENDP


;	ウェイト

CXWAIT	PROC	NEAR
	PUSH	CX
	MOV	CX,5000
CXWAIT2:
	LOOP	CXWAIT2
	POP	CX
	RET
CXWAIT	ENDP



;	ポイントプリント

POINTPRINT	PROC	NEAR
POINTPRINT1:			;
	CALL	MSWAT		; カーソルボタンＯＦＦ待ち
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
	PUSH	VX1			;
	PUSH	VY1			;
	CALL	PTPIC			; point pick.
	POP	VX1			;
	POP	VY1			;
	CMP	AX,0			; 0:normal,1:pic,2:exit
	JNE	MSWAT1			;

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
;	-I- DS:SI : ファイル名

FLSET	PROC	NEAR
	PUSH	AX
	PUSH	CX
	PUSH	DI

	MOV	AX,DS
	MOV	ES,AX

	MOV	AL,' '
	MOV	DI,OFFSET FLNM		; file name.
	MOV	CX,8
	REP	STOSB

	MOV	BYTE PTR DS:[SI][8],0	; ８文字までしか受け付けません

	SETS	FLNM			; file name.

	POP	DI
	POP	CX
	POP	AX
	RET
FLSET	ENDP



;	テキストテスト

TXTTEST	PROC	NEAR
TXTTEST1:
	CALL	CLS

	INP	"0=16x16  1=32x32  2=16x24  3=16x32 :"
	CALL	STRDEC			;
	MOV	AX,DX			; 0=16x16  1=32x32  2=16x24  3=16x32
	CALL	VTXSIZ			; character size set.

	INP	"character color 0-15 :"
	CALL	STRDEC			;
	MOV	AX,DX			; character color 0-15
	CALL	VTXCOL			; character color set.

TXTTEST2:
	CALL	CLS
	INP	"文字列:"
	SETS	STRBUFF		; 文字列

	MOV	AX,10
	MOV	BX,40
	MOV	SI,OFFSET STRBUFF
	CALL	VTXPRN		; vram text print.
	MOV	AX,10
	MOV	BX,100
	MOV	SI,OFFSET STRBUFF
	CALL	VTXPOR		; vram text print OR.
	MOV	AX,10
	MOV	BX,200
	MOV	SI,OFFSET STRBUFF
	CALL	VTXPFC		; vram text print fuchi.
	MOV	AX,10
	MOV	BX,250
	MOV	SI,OFFSET STRBUFF
	CALL	MITPRN		; string. (null=end of string)

	JMP	TXTTEST2	;
	RET
TXTTEST	ENDP


;	Ｚｓ’８８無圧縮ファイル名

Z88LOAD	PROC	NEAR
	PRF	"Ｚｓ’８８無圧縮ファイルを９８ベタファイルに"

	INP	"読み込みファイル名"
	SETS	FLZS88			; Ｚｓ’８８無圧縮ファイル名

	MOV	SI,OFFSET FLZS88
	CALL	LODZ88			; ＰＣ８８Ｚ’ｓファイルロード

	MOV	SI,OFFSET FLZS88
	CALL	SAVBET			; ベタファイルセーブ

	JMP	Z88LOAD
	RET
Z88LOAD	ENDP


;	string length.(max65530)
;	-I- ES:DI : string.
;	-O- AX    : length.

STRLEN	PROC	NEAR
	MOV	CX,65530
	MOV	SI,DI
	MOV	AL,0
	REPNE	SCASB
	MOV	AX,DI
	SUB	AX,SI
	DEC	AX
	RET
STRLEN	ENDP



;	char set.
;	-I- ES:DI : string.
;	    CX    : length.
;	    AL    : charcter.

CHRSET	PROC	NEAR
	REP	STOSB
	RET
CHRSET	ENDP



CODE	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

SAVE_SS	DW	0	; stack segment.
SAVE_SP	DW	0	; stack pointer.

PUBLIC	SEGDOS		; ＰＬＳＬＤ．ＡＳＭからＰＬＳＬＤ４．ＡＳＭ
SEGDOS	DW SEG DOSDAT	; まで使っているワークエリアセグメント値
			; ＤＴＡ領域をセットしておく

EXTRN	SSGR0:WORD	; visual data segment plean 0
EXTRN	SSGR1:WORD	; visual data segment plean 1
EXTRN	SSGR2:WORD	; visual data segment plean 2
EXTRN	SSGR3:WORD	; visual data segment plean 3

EXTRN	VX1:WORD	; left side x.
EXTRN	VY1:WORD	; left side y.
EXTRN	VX2:WORD	; right side x.
EXTRN	VY2:WORD	; right side y.
EXTRN	ADRS:WORD	; address.
EXTRN	NUM:WORD	; number.

EXTRN	VRX:WORD	; x point.
EXTRN	VRY:WORD	; y point.

EXTRN	VRLENX:WORD	; x length.
EXTRN	VRLENY:WORD	; y length.

EXTRN	BPOINT:WORD	; data buffer point.
EXTRN	BPNTOF:WORD	; データバッファポインタ
EXTRN	BPNTSG:WORD	; データバッファセグメント
EXTRN	BCNTMX:WORD	; データ最大長さ
EXTRN	BCOUNT:WORD	; データ長さ

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

EXTRN	LCFLRD:BYTE		; read file name.
EXTRN	LCFLWT:BYTE		; write file name.


		EVEN
MOUSFL		DW	0	; mouse flag 1=MOUSE.

GETNUM		DW	0	; パターンＧＥＴ番号
GETNUM_OFSET	DW	0	; パーツ番号オフセット
GETNUM_CHK	DW	0	; パーツ番号チェック

ARA_BAK_X1	DW	0	; ＧＥＴ座標の退避
ARA_BAK_Y1	DW	0	;
ARA_BAK_X2	DW	0	;
ARA_BAK_Y2	DW	0	;
ARA_BAK_FLG	DW	0	; 1=退避データあり,0=なし

PLSDIR_FLG	DW	0	; 圧縮方向指定

FL_ZL_TMP	DB	"ZL.TMP",0	; file name.

FLNM	DB	"                  ",0	; file name.
FLZS88	DB	"                  ",0	; Ｚｓ’８８無圧縮ファイル名
	EVEN

STRBUFF	DW	256 DUP (0),0		; 文字列

TITLES	LABEL	BYTE
	DB	"　　パーツデータ圧縮　　@"
	DB	"　 parts data conpless　",0



		EVEN
USER_DRV	DW	0	; ユーザドライブ番号
USER_DRV_DEST	DW	0	; ユーザ書き込みドライブ番号

DATA	ENDS


STACK	SEGMENT	STACK
	EVEN
	DB	10000 DUP (?)
TOP_OF_STACK	LABEL	WORD
STACK	ENDS

	END	START
;
;	end of "TSTPLS.ASM"
;
