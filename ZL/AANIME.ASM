; "AANIME.ASM" PC-9801UV11 make by R.H 1990/05/17
;
;	オート・アニメ
;
;

INCLUDE	TSTSET.INC

;	ＭＯＶＥ＿ＩＭＧ	＜転送元ＩＤ＞，＜転送先ＩＤ＞
;				，Ｘ１，Ｙ１，Ｘ２，Ｙ２，Ｘ３，Ｙ３

MOVE_IMG	MACRO	SOUID,DESTID,X1,Y1,X2,Y2,X3,Y3
	MOV	AX,WORD PTR SOUID[0]
	MOV	SSSOU0,AX
	MOV	AX,WORD PTR SOUID[2]
	MOV	SSSOU1,AX
	MOV	AX,WORD PTR SOUID[4]
	MOV	SSSOU2,AX
	MOV	AX,WORD PTR SOUID[6]
	MOV	SSSOU3,AX
	MOV	AX,WORD PTR DESTID[0]
	MOV	SSDES0,AX
	MOV	AX,WORD PTR DESTID[2]
	MOV	SSDES1,AX
	MOV	AX,WORD PTR DESTID[4]
	MOV	SSDES2,AX
	MOV	AX,WORD PTR DESTID[6]
	MOV	SSDES3,AX
	MOV	AX,X1
	MOV	WORD PTR VX1,AX
	MOV	AX,Y1
	MOV	WORD PTR VY1,AX
	MOV	AX,X2
	MOV	WORD PTR VX2,AX
	MOV	AX,Y2
	MOV	WORD PTR VY2,AX
	MOV	AX,X3
	MOV	WORD PTR VX3,AX
	MOV	AX,Y3
	MOV	WORD PTR VY3,AX
	EXTRN	MOVEVR:NEAR	; vram to vram move.
	CALL	MOVEVR		; vram to vram move.
ENDM

FRAME_SET	EQU	3	; フレーム番号(0=なにもしない)

UDRIVE		EQU	2	; ユーザドライブ番号


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	AANIME		; オート・アニメ

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

EXTRN	PTPIC:NEAR	; point pick.

EXTRN	PATCLR:NEAR	; パーツセットクリア
EXTRN	PATGET:NEAR	; パーツＧＥＴ
EXTRN	PATGTA:NEAR	; パーツＧＥＴ圧縮無し
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

EXTRN	PLSMOD:NEAR	; 圧縮モード切り替え

EXTRN	BPPPTS:NEAR	; パレットファイルをパーツバッファへ

EXTRN	PATSIZ:NEAR	; パーツサイズのＧＥＴ

EXTRN	VRMCLR:NEAR	; ＶＲＡＭクリア

EXTRN	TXTBOX:NEAR	; テキスト属性ＢＯＸセット




; *******************************************
;	オート・アニメ
; *******************************************

AANIME	PROC	NEAR

	PRF	"オート・アニメ [INS:送り/DEL:抜ける]"
	LF

	CALL	HARFBR			; 明度５０％

	MOV	USER_DRV,UDRIVE		; ユーザドライブ番号
	MOV	PLSDIR_FLG,0		; 圧縮モード(0:通常,1:縦方向)

	MOV	AX,USER_DRV		; ユーザドライブ番号
	CALL	DSKDR			; drive number set.

AANIME_LP:
	INP	"パレットファイル名＝"
	CALL	PALET_LSET		; パレットロード
	CMP	AX,1			; 1:error.
	JNE	AANIME_1		;
	PRF	"ファイルが見つかりません"
	JMP	AANIME_LP		;
AANIME_1:				;



	CALL	HARFBR			; 明度５０％
AANIME_LOOP:
	INP	"ベタファイル名＝"

	CALL	LODBET			; ベタファイルロード

	CMP	AX,1			; 1:error.
	JNE	AANIME_2		;
	PRF	"ファイルが見つかりません"
	JMP	AANIME_LOOP		;
AANIME_2:				;


	INP	"枚数は、おいくつ？"
	CALL	STRDEC
	CMP	DX,0
	JE	AANIME_2
	CMP	DX,6
	JG	AANIME_2
	MOV	AN_MAX,DX



	INP	"Ｖ−ＳＹＮＣ待ちは、おいくつ？（１／６０秒）"
	CALL	STRDEC
	MOV	TIME_WAIT,DX		; Ｖ−ＳＹＮＣ待ち

	MOVE_IMG	ARAVRM,ARA001,0,0,80,400,0,0

AANIME_3:
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	AND	TIME_WAIT,1111111B	; Ｖ−ＳＹＮＣ待ち

	CALL	ANIME_MOVE		; アニメ

	CALL	HARFBR			; 明度５０％

	INP	"Ｖ−ＳＹＮＣ待ちは、おいくつ？（１／６０秒）"
	CMP	BYTE PTR DS:[SI],0
	JE	AANIME_NEXT
	CALL	STRDEC
	MOV	TIME_WAIT,DX		; Ｖ−ＳＹＮＣ待ち

	JMP	AANIME_3

AANIME_NEXT:
	JMP	AANIME_LOOP


AANIME_EXIT:
	RET


;*NON*;AANIME_MENU:
;*NON*;	PRF	" 2:メインウインドウ		46(368) x 200"
;*NON*;	PRF	" 3:イベントウインドウ		39(312) x 160"
;*NON*;	PRF	" 4:戦闘			20(160) x 146"
;*NON*;	PRF	" 5:高橋			・・・・・・・"
;*NON*;	INP	"フレーム番号(0=なにもしない)"
;*NON*;	CALL	STRDEC
;*NON*;
;*NON*;	MOV	FRAME_NUM,DX		; フレーム番号(0=なにもしない)
;*NON*;	CMP	DX,1
;*NON*;	JG	AANIME_1
;*NON*;	JMP	AANIME_MENU
;*NON*;AANIME_1:
;*NON*;	CMP	DX,5
;*NON*;	JLE	AANIME_11
;*NON*;	JMP	AANIME_MENU
;*NON*;AANIME_11:
;*NON*;
;*NON*;
;*NON*;	CALL	PALET_LSET		; パレットロード＆セット
;*NON*;
;*NON*;	CALL	HARFBR			; 明度５０％
;*NON*;
;*NON*;	CALL	PATCLR			; パーツセットクリア
;*NON*;
;*NON*;AANIME_LOOP:
;*NON*;	CALL	FLGET			; 指定ファイル名ＧＥＴ
;*NON*;	CMP	AX,1			; 1=終了
;*NON*;	JUMP_EQ	AANIME_LOOP_END		;
;*NON*;
;*NON*;	CALL	FLSET			; ファイル名セット
;*NON*;
;*NON*;	MOV	DX,PLSDIR_FLG		; 圧縮モード(0:通常,1:縦方向)
;*NON*;	CALL	PLSMOD			; 圧縮モード切り替え
;*NON*;
;*NON*;	MOV	SI,OFFSET FLNM		; file name.
;*NON*;	CALL	LODBET			; ベタファイルロード
;*NON*;	CMP	AX,1			;
;*NON*;	JUMP_EQ	AANIME_NOERROR		;
;*NON*;
;*NON*;
;*NON*;	CALL	TITLES			; タイトル
;*NON*;
;*NON*;;*NON*;	MOV	FRAME_NUM,FRAME_SET	; フレーム番号(0=なにもしない)
;*NON*;	CALL	SL_SIZE			; サイズ指定
;*NON*;
;*NON*;	MOV	AX,SIZE_VRX		; ＶＲＡＭ　Ｘ座標
;*NON*;	MOV	BX,SIZE_VRY		; ＶＲＡＭ　Ｙ座標
;*NON*;	MOV	CX,SIZE_VRLENX		; Ｘ方向長さ
;*NON*;	MOV	DX,SIZE_VRLENY		; Ｙ方向長さ
;*NON*;	MOV	VRX,AX			;
;*NON*;	MOV	VRY,BX			;
;*NON*;	MOV	VRLENX,CX		;
;*NON*;	MOV	VRLENY,DX		;
;*NON*;
;*NON*;	CMP	FRAME_NUM,5		; 高橋特別フレーム番号
;*NON*;	JE	TAKAHASHI		;
;*NON*;	CALL	PATGET			; パーツＧＥＴ
;*NON*;	JMP	TAKAHASHI2		;
;*NON*;TAKAHASHI:				;
;*NON*;	CALL	PATGTA			; パーツＧＥＴ圧縮無し
;*NON*;TAKAHASHI2:				;
;*NON*;	CMP	AX,0			;
;*NON*;	JE	AANIME_NOERROR		;
;*NON*;
;*NON*;	PRF	"ＰＡＴＧＥＴ　エラー発生"
;*NON*;
;*NON*;	PRS	"ファイル名:",FLNM
;*NON*;
;*NON*;	INP	"プログラマに連絡せよ"
;*NON*;	INP	"2:WAIT"
;*NON*;	INP	"1:WAIT"
;*NON*;
;*NON*;	JMP	AANIME_EXIT
;*NON*;AANIME_NOERROR:
;*NON*;	JMP	AANIME_LOOP
;*NON*;
;*NON*;AANIME_LOOP_END:
;*NON*;	CALL	PALET_LSET		; パレットロード＆セット
;*NON*;
;*NON*;	CALL	ANIME_MOVE		; アニメ
;*NON*;
;*NON*;AANIME_EXIT:
;*NON*;	RET
AANIME	ENDP



;	アニメ

ANIME_MOVE	PROC	NEAR
	CALL	CLS			; text clear.

	MOV	AN_NUMBER,0		;
ANIME_MOVE_LOOP:			;
	MOV	AX,TIME_WAIT		;
	CALL	TMVWAT			; V-SYNC timer wait.

	MOV	BX,AN_NUMBER		;
	SHL	BX,1			;
	SHL	BX,1			; 2 word pointer.
	MOV	AX,DS:AN_TABLE[BX]	;
	MOV	BX,DS:AN_TABLE[BX][2]	;

	MOV	VRX,AX			; ＶＲＡＭ　Ｘ座標
	MOV	VRY,BX			; ＶＲＡＭ　Ｙ座標
	MOV	VRLENX,20		; x length.
	MOV	VRLENY,146		; y length.
	MOVE_IMG	ARA001,ARAVRM,VRX,VRY,VRLENX,VRLENY,0,0

	CALL	CLS
ANIME_MOVE_777:				;
	INC	AN_NUMBER		;

	MOV	AX,AN_NUMBER		;
	CMP	AX,AN_MAX		;
	JL	ANIME_MOVE_788		;
	MOV	AN_NUMBER,0		;
ANIME_MOVE_788:				;

	CALL	ARAPNT			; point pic.
	CMP	AX,2			; ２＝強制終了
	JE	ANIME_MOVE_END		;
	JMP	ANIME_MOVE_LOOP		; loop end.

ANIME_MOVE_END:
	RET
ANIME_MOVE	ENDP




;*NON*;;	アニメ
;*NON*;
;*NON*;ANIME_MOVE	PROC	NEAR
;*NON*;	CALL	CLS			; text clear.
;*NON*;
;*NON*;	MOV	GETNUM,0		;
;*NON*;ANIME_MOVE_LOOP:			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	ARAPNT			; point pic.
;*NON*;;*NON*;	CMP	AX,2			; ２＝強制終了
;*NON*;;*NON*;	JUMP_EQ	ANIME_MOVE_END		;
;*NON*;
;*NON*;	MOV	VRX,0			; ＶＲＡＭ　Ｘ座標
;*NON*;	MOV	VRY,0			; ＶＲＡＭ　Ｙ座標
;*NON*;
;*NON*;	MOV	CX,GETNUM		;
;*NON*;	INC	GETNUM			;
;*NON*;
;*NON*;	CALL	PATPTF			; パーツＰＵＴオフセット指定
;*NON*;	CMP	AX,1			;
;*NON*;	JNE	ANIME_MOVE_777		;
;*NON*;
;*NON*;	MOV	GETNUM,0		;
;*NON*;	PRF	"シーケンス１周しました"
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CXWAIT			;
;*NON*;	CALL	CLS
;*NON*;ANIME_MOVE_777:				;
;*NON*;	JMP	ANIME_MOVE_LOOP		; loop end.
;*NON*;
;*NON*;ANIME_MOVE_END:
;*NON*;	RET
;*NON*;ANIME_MOVE	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;
;*NON*;
;*NON*;;	タイトル
;*NON*;
;*NON*;TITLES	PROC	NEAR
;*NON*;
;*NON*;	PRF	"	�ｮ�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�ｲ"
;*NON*;	PRF	"	�､　　　　　　　　　　　　　　　　　�､"
;*NON*;	PRF	"	�､　　　圧縮プログラム実行中　　　　�､"
;*NON*;	PRF	"	�､　　　　「とめないでね」　　　　　�､"
;*NON*;	PRF	"	�､　　　　　　　　　　　　　　　　　�､"
;*NON*;	PRF	"	�ｶ�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�｢�ｺ"
;*NON*;	PRF	"	1990 (C) r.hashimoto"
;*NON*;
;*NON*;	PRV	"ファイル数    :",FILE_MAX
;*NON*;	PRV	"処理ファイル数:",FILE_PNT
;*NON*;
;*NON*;	RET
;*NON*;TITLES	ENDP
;*NON*;
;*NON*;


;	パレットロード
;	-I- SI : パレットファイル名
;	-O- AX : 1=エラー

PALET_LSET	PROC	NEAR
	MOV	BX,0			; パレットテーブル番号
	CALL	LODPLT			; パレットファイルロード
	RET
PALET_LSET	ENDP



;	サイズ指定
;	-I- FRAME_NUM     : フレーム番号(0=なにもしない)
;	-O- SIZE_VRX[]    : ＶＲＡＭ　Ｘ座標
;	    SIZE_VRY[]    : ＶＲＡＭ　Ｙ座標
;	    SIZE_VRLENX[] : Ｘ方向長さ
;	    SIZE_VRLENY[] : Ｙ方向長さ

SL_SIZE	PROC	NEAR
	CMP	FRAME_NUM,1			; フレーム番号
	JL	SL_SIZE_END			;
	CMP	FRAME_NUM,7			; フレーム番号
	JG	SL_SIZE_END			;
	JMP	SL_SIZE_SET			;
SL_SIZE_END:					;
	RET

SL_SIZE_SET:
	MOV	BX,FRAME_NUM			; フレーム番号
	SHL	BX,1				; word pointer.
	JMP	CS:SL_SIZE_LABEL[BX]		; on goto.
SL_SIZE_LABEL	LABEL	WORD		;
	DW	0
	DW	OFFSET SL_SIZE_1
	DW	OFFSET SL_SIZE_2
	DW	OFFSET SL_SIZE_3
	DW	OFFSET SL_SIZE_4
	DW	OFFSET SL_SIZE_5
	DW	OFFSET SL_SIZE_6
	DW	OFFSET SL_SIZE_7


SL_SIZE_1:
	PRF	" 1:ＯＰ，ＥＤビジュアル	60(480) x 230"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,60			; Ｘ方向長さ
	MOV	SIZE_VRLENY,230			; Ｙ方向長さ
	MOV	FRAME_NUM,1			; フレーム番号
	RET
SL_SIZE_2:
	PRF	" 2:メインウインドウ		46(368) x 200"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,46			; Ｘ方向長さ
	MOV	SIZE_VRLENY,200			; Ｙ方向長さ
	MOV	FRAME_NUM,2			; フレーム番号
	RET
SL_SIZE_3:
	PRF	" 3:イベントウインドウ		39(312) x 160"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,39			; Ｘ方向長さ
	MOV	SIZE_VRLENY,160			; Ｙ方向長さ
	MOV	FRAME_NUM,3			; フレーム番号
	RET
SL_SIZE_4:
;;;;	PRF	" 4:人物			17(136) x 140"
	PRF	" 4:戦闘	*****		20(160) x 146"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,20			; Ｘ方向長さ
	MOV	SIZE_VRLENY,146			; Ｙ方向長さ
	MOV	FRAME_NUM,4			; フレーム番号
	RET
SL_SIZE_5:
	PRF	" 5:高橋			"

	MOV	SIZE_MAX,1			; 指定サイズ数
	MOV	SIZE_PNT,0			; 指定サイズポインタ

	MOV	SIZE_VRX,0			; ＶＲＡＭ　Ｘ座標
	MOV	SIZE_VRY,0			; ＶＲＡＭ　Ｙ座標
	MOV	SIZE_VRLENX,20			; Ｘ方向長さ
	MOV	SIZE_VRLENY,146			; Ｙ方向長さ
	MOV	FRAME_NUM,5			; フレーム番号
	RET
SL_SIZE_6:
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

SL_SIZE_7:
	PRF	" 7:全画面の２分割　　　	40(320) x 400 x 2"

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
SL_SIZE	ENDP





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
EXTRN	ARA001:WORD		; ram area 1.
EXTRN	ARA002:WORD		; ram area 2.


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


	EXTRN	SSGR0:WORD		; visual data segment plean 0
	EXTRN	SSGR1:WORD		; visual data segment plean 1
	EXTRN	SSGR2:WORD		; visual data segment plean 2
	EXTRN	SSGR3:WORD		; visual data segment plean 3

	EXTRN	SSDES0:WORD		; visual data segment plean 0
	EXTRN	SSDES1:WORD		; visual data segment plean 1
	EXTRN	SSDES2:WORD		; visual data segment plean 2
	EXTRN	SSDES3:WORD		; visual data segment plean 3

	EXTRN	SSSOU0:WORD		; visual data segment plean 0
	EXTRN	SSSOU1:WORD		; visual data segment plean 1
	EXTRN	SSSOU2:WORD		; visual data segment plean 2
	EXTRN	SSSOU3:WORD		; visual data segment plean 3


	EXTRN	VX1:WORD		; source point x1.
	EXTRN	VY1:WORD		; source point y1.
	EXTRN	VX2:WORD		; length x2.
	EXTRN	VY2:WORD		; length y2.
	EXTRN	VX3:WORD		; destination point x3.
	EXTRN	VY3:WORD		; destination point y3.


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


TIME_WAIT	DW	0	; Ｖ−ＳＹＮＣ待ち




			;12345678
FLNM		DB	"        ",0,0	; file name.

FLNM_PALET	DB	"A       ",0,0	; パレットファイル名

FLNM_WORK	DB	"A       ",0,0	; write work file name.

FLNM_WRITE	DB	"X"		; write file name.
FLNM_WRITE2	DB	"       ",0,0	;


AN_NUMBER	DW	0
AN_MAX		DW	9
AN_TABLE	LABEL	WORD
		DW	20*0   ,146*0
		DW	20*1   ,146*0
		DW	20*2   ,146*0
		DW	20*0   ,146*1
		DW	20*1   ,146*1
		DW	20*2   ,146*1
		DW	20*0   ,146*2
		DW	20*1   ,146*2
		DW	20*2   ,146*2
		DW	-1,-1




		EVEN

GETNUM		DW	0	; パターンＧＥＴ番号

FILE_MAX	DW	12	; 指定ファイル数
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
FILE_NM0	DB	"A1      ",0,0
FILE_NM1	DB	"A2      ",0,0
FILE_NM2	DB	"A3      ",0,0
FILE_NM3	DB	"A4      ",0,0
FILE_NM4	DB	"A5      ",0,0
FILE_NM5	DB	"A6      ",0,0
FILE_NM6	DB	"A7      ",0,0
FILE_NM7	DB	"A8      ",0,0
FILE_NM8	DB	"A9      ",0,0
FILE_NM9	DB	"A10     ",0,0
FILE_NM10	DB	"A11     ",0,0
FILE_NM11	DB	"A12     ",0,0
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


USER_DRV	DW	0	; ユーザドライブ番号
USER_DRV_DEST	DW	0	; ユーザ書き込みドライブ番号

PLSDIR_FLG	DW	0	; 圧縮方向指定[1=縦方向]

PALET_OFF	DW	0	; 1=パレット読み込み中止

FRAME_NUM	DW	0	; フレーム番号

DATA	ENDS

	END
;
;	end of "AANIME.ASM"
;
