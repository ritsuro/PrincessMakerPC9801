; "TALKER.ASM" PC-9801UV11 make by R.H 1989/12/12,1990/04/08
;
;	台詞表示処理
;
;	指定文字列を指定領域にスクロールさせながら
;	表示する
;
;	スクロール用にタイマ１を使用
;
; GAME subroutine.

INCLUDE TSTSET.INC

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	TKTIN			; 台詞表示初期処理
PUBLIC	TKTIN_F			; ふきだしのメッセージ（初期処理）
PUBLIC	TKTIN_F_RET		; 元の台詞表示へ戻す
PUBLIC	TKTPRN			; 台詞表示
PUBLIC	TKQZLF			; 台詞改行
PUBLIC	TKWAIT			; 台詞改行のプレイヤー待ち
PUBLIC	TKRSET			; 台詞改行のカウンタリセット
PUBLIC	TKRHME			; 台詞ホームポジション


EXTRN	BOXMSS:NEAR		; ＢＯＸメッシュ

EXTRN	TMVSET:NEAR		; V-SYNC timer set.
EXTRN	TMVCHK:NEAR		; V-SYNC timer check.
EXTRN	TMVCNT:NEAR		; V-SYNC timer cont.
EXTRN	TMVEWT:NEAR		; V-SYNC timer end wait.

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCWATTM:NEAR		; カーソルボタンＯＦＦ待ち（待ちタイマ付き）
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス
EXTRN	MSCSTP:NEAR		; カーソルストップ

EXTRN	MSWWAT:NEAR		; カーソルボタン待ち

EXTRN	BOXPAL:NEAR		; ＢＯＸペイント

EXTRN	VTXPRN:NEAR		; vram text print.
EXTRN	VTXPOR:NEAR		; vram text print OR.
EXTRN	VTXPFC:NEAR		; vram text print fuchi.
EXTRN	VTXSIZ:NEAR		; character size set.
EXTRN	VTXCOL:NEAR		; character color set.

EXTRN	MOVEVR:NEAR		; vram to vram move.


ADV_NXT_Y_INI	EQU	16	; 次の行までの間隔（初期値）
FKI_NXT_Y_INI	EQU	22	; 次の行までの間隔（初期値）

MAX_ADVNCH_NEXT	EQU	7	; アドベンチャー表示最大行
MOJI_ADVNCH_MAX	EQU	23	; アドベンチャー最大文字数＜注目！！＞
;*;MAX_FUKI_NEXT EQU	3	; ふきだし表示最大行
;*;MOJI_FUKI_MAX EQU	46 	; ふきだし最大文字数＜注目！！＞
MOJI_BUFF_MAX	EQU	48 	; バッファ最大文字数（上の２つより2ﾊﾞｲﾄ大きい）
TIME_SCROL	EQU	1	; スクロールインターバル

FONTSIZ		EQU	0	; フォントサイズ
				; 0=16x16,1=32x32,2=16x24,3=16x32

BACKCOLOR	EQU	15	; バックグラウンドカラー



;	台詞表示初期処理
;	アドベンチャー画面のメッセージ（初期処理）

TKTIN	PROC	NEAR
	MOV	ADDCHRFLG,1		; 1=追加文字処理
	MOV	PUTMODE,1		; 文字出力モード(0=PSET,1=OR,2=fuchi)

	MOV	NOWWTD,1		; 現在の１文字キャラクタ幅

	MOV	AX,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOV	BX,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOV	CX,ADV_END_X		; アドベンチャー・台詞右下Ｘ
	MOV	DX,ADV_END_Y		; アドベンチャー・台詞右下Ｙ
	MOV	QIZX,AX			; 台詞表示Ｘ
	MOV	QIZY,BX			; 台詞表示Ｙ
	MOV	QIZXS,AX		; 台詞表示ウインドウ左上Ｘ
	MOV	QIZYS,BX		; 台詞表示ウインドウ左上Ｙ
	MOV	QIZXE,CX		; 台詞表示ウインドウ右下Ｘ
	MOV	QIZYE,DX		; 台詞表示ウインドウ右下Ｙ
	DEC	CX			;
	MOV	VX1,AX			;
	MOV	VY1,BX			;
	MOV	VX2,CX			;
;*NON*;	ADD	DX,ADV_NXT_Y_INI	; 次の行までの間隔（初期値）
	MOV	VY2,DX			;
;*NON*;	MOV	CX,BACKCOLOR		; バックグラウンドカラー
;*;	CALL	MOUSESTOP		; マウスストップ
;*;;*NON*;	CALL	BOXPAL			; ＢＯＸペイント
;*;
;*;	MOV	CX,W_COL3		; カラー・暗い灰
;*;	CALL	BOXPAL			; ＢＯＸペイント
;*;	MOV	CX,W_COL4		; カラー・黒
;*;	CALL	BOXMSS			; ＢＯＸメッシュ
;*;
;*;	CALL	MOUSESTART		; マウススタート
;*;
	MOV	SCROLL_SW,0		; スクロールスイッチ(1=スクロール)
	MOV	LOCATE_NEXT,1		; 使用行 (最下位行を使用？)
	MOV	MAX_LOC_NEXT,MAX_ADVNCH_NEXT ; アドベンチャー表示最大行
	MOV	MOJI_MAX,MOJI_ADVNCH_MAX ; 最大文字数＜注目！！＞
	MOV	ADV_NXT_Y,ADV_NXT_Y_INI	; 次の行までの間隔

	MOV	LINCNT,0		; 文字数

	MOV	PRINT_CNT,1		; プリント行数

	MOV	KAIGYOU,0		; 1=次のプリント時に改行せよ

	RET
TKTIN	ENDP


;	ふきだしのメッセージ（初期処理）

TKTIN_F	PROC	NEAR
	MOV	DX,1			; ハンドル番号
	CALL	HANDLE_SWAP		; ハンドル交換

	MOV	ADDCHRFLG,1		; 1=追加文字処理
	MOV	PUTMODE,2		; 文字出力モード(0=PSET,1=OR,2=fuchi)

	MOV	NOWWTD,1		; 現在の１文字キャラクタ幅

	MOV	AX,FKI_INI_X		; ふきだし・台詞左上Ｘ
	MOV	BX,FKI_INI_Y		; ふきだし・台詞左上Ｙ
	MOV	CX,FKI_END_X		; ふきだし・台詞右下Ｘ
	MOV	DX,FKI_END_Y		; ふきだし・台詞右下Ｙ
	MOV	QIZX,AX			; 台詞表示Ｘ
	MOV	QIZY,BX			; 台詞表示Ｙ
	MOV	QIZXS,AX		; 台詞表示ウインドウ左上Ｘ
	MOV	QIZYS,BX		; 台詞表示ウインドウ左上Ｙ
	MOV	QIZXE,CX		; 台詞表示ウインドウ右下Ｘ
	MOV	QIZYE,DX		; 台詞表示ウインドウ右下Ｙ

;*;	DEC	CX			;
;*;	MOV	VX1,AX			;
;*;	MOV	VY1,BX			;
;*;	MOV	VX2,CX			;
;*;;*NON*;	ADD	DX,ADV_NXT_Y_INI	; 次の行までの間隔（初期値）
;*;	MOV	VY2,DX			;

	MOV	SCROLL_SW,0		; スクロールスイッチ(1=スクロール)
	MOV	LOCATE_NEXT,1		; 使用行 (最下位行を使用？)
	MOVX	MAX_LOC_NEXT,FKI_MAX_FUKI_NEXT	; アドベンチャー表示最大行
	MOVX	MOJI_MAX,FKI_MOJI_FUKI_MAX	; 最大文字数＜注目！！＞
	MOV	ADV_NXT_Y,FKI_NXT_Y_INI	; 次の行までの間隔（初期値）

	MOV	LINCNT,0		; 文字数

	MOV	PRINT_CNT,1		; プリント行数

	MOV	KAIGYOU,0		; 1=次のプリント時に改行せよ

	RET
TKTIN_F	ENDP

;	元の台詞表示へ戻す

TKTIN_F_RET	PROC	NEAR
	MOV	DX,0			; ハンドル番号
	CALL	HANDLE_SWAP		; ハンドル交換
	RET
TKTIN_F_RET	ENDP


;	ハンドル交換
;	-I- DX : ハンドル番号

HANDLE_SWAP	PROC	NEAR
	CMP	DX,NOW_HANDLE		; 現在のハンドル番号
	JNE	HANDLE_SWAP_START	;
	RET

HANDLE_SWAP_START:
	MOV	NOW_HANDLE,DX		; 現在のハンドル番号

	MOV	CX,(OFFSET SAVE_TABLE_END)-(OFFSET SAVE_TABLE)
	MOV	SI,OFFSET SAVE_TABLE
	MOV	DI,OFFSET HANDLE_TABLE
HANDLE_SWAP_LOOP:
	MOV	AH,DS:[SI]
	MOV	AL,DS:[DI]
	MOV	DS:[SI],AL
	MOV	DS:[DI],AH
	INC	SI
	INC	DI
	LOOP	HANDLE_SWAP_LOOP
	RET
HANDLE_SWAP	ENDP


;	台詞ホームポジション

TKRHME	PROC	NEAR
	MOVX	VX1,QIZXS	; 台詞表示ウインドウ左上Ｘ
	MOVX	VY1,QIZYS	; 台詞表示ウインドウ左上Ｙ
	MOVX	VX2,QIZXE	; 台詞表示ウインドウ右下Ｘ
	MOVX	VY2,QIZYE	; 台詞表示ウインドウ右下Ｙ
	SUB	VX2,2		;
	MOV	CX,W_COL3		; カラー・暗い灰
	CALL	BOXPAL			; ＢＯＸペイント
	MOV	CX,W_COL4		; カラー・黒
	CALL	BOXMSS			; ＢＯＸメッシュ


;*;	MOV	CX,MAX_ADVNCH_NEXT	; アドベンチャー表示最大行
;*;TKRHME_LOOP:				;
;*;	PUSH	CX			;
;*;	CALL	ADV_SCROLL		; アドベンチャースクロール
;*;	POP	CX			;
;*;	LOOP	TKRHME_LOOP		;

	MOV	AX,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOV	BX,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOV	QIZX,AX			; 台詞表示Ｘ
	MOV	QIZY,BX			; 台詞表示Ｙ
	MOV	LOCATE_NEXT,1		; 使用行 (最下位行を使用？)
	MOV	PRINT_CNT,1		; プリント行数
	MOV	LINCNT,0		; 文字数
	MOV	PRINT_CNT,1		; プリント行数
	MOV	KAIGYOU,0		; 1=次のプリント時に改行せよ
	RET
TKRHME	ENDP




;	アドベンチャー画面のメッセージ（文字列指定）
;	-I- ES:[SI] : 表示文字列

TKTPRN	PROC	NEAR
	PUSH	SI

	MOV	AX,FONTSIZ		; フォントサイズ
	CALL	VTXSIZ			; character size set.

	MOV	AX,TXCOL1		; 通常の台詞カラーおよび初期値
	CALL	VTXCOL			; character color set.

	MOV	BX,SI			; 表示文字列
	MOV	SCROLL_SW,1		; スクロールスイッチ(1=スクロール)
	CALL	TKQIZPRN		; 台詞表示
	MOV	SCROLL_SW,0		; スクロールスイッチ(1=スクロール)

	POP	SI			;
	RET				;
TKTPRN	ENDP



;	台詞表示
;	-I-   ES:[BX]    : 台詞文字列
;	      SCROLL_SW  : スクロールスイッチ(1=スクロール)
;	      QIZXS      : 台詞表示ウインドウ左上Ｘ
;	      QIZYS      : 台詞表示ウインドウ左上Ｙ
;	      QIZXE      : 台詞表示ウインドウ右下Ｘ
;	      QIZYE      : 台詞表示ウインドウ右下Ｙ
;	-I/O- QIZX       : 台詞表示Ｘ
;	      QIZY       : 台詞表示Ｙ
;	      LINCNT     : 文字数
;	      PRINT_CNT  : プリント行数

TKQIZPRN	PROC	NEAR

	CALL	TKQIZPRN_LFS		; スタート時の改行処理
	MOV	PRN_EOS,0		; 文字列終わり

	MOV	DI,OFFSET LINBUF	; 台詞表示ラインバッファ
	MOV	DX,ES:[BX]		; １全角取り出し
	CMP	DL,'@'			; いきなり改行か！
	JE	TKQIZPRN_INTER		;

TKQIZPRN_ST:				; 次のライン
	MOV	DI,OFFSET LINBUF	; 台詞表示ラインバッファ
TKQIZPRN_LOOP:
	MOV	DX,ES:[BX]		; １全角取り出し

	CMP	DL,' '			; 文字列の終わりＣＲ／ＬＦ
	JB	TKQIZPRN_EOS		;

	CALL	TKQZLFS			; 先行改行

TKQIZPRN_INTER:
	CMP	DL,'@'			; 改行指定
	JNE	TKQIZPRN_1		;
	INC	BX			;
	MOV	DS:[DI],BYTE PTR 0	; end of string.
	JMP	TKQIZPRN_4		;
TKQIZPRN_1:				;

	CALL	JISCHECK		; 漢字チェック
	CMP	AX,1			;
	JE	TKQIZPRN_KNJ		;
TKQIZPRN_ANK:				;
	MOV	DS:[DI],DL		;
	INC	LINCNT			; 文字数
	INC	DI			;
	INC	BX			;
	JMP	TKQIZPRN_3		;
TKQIZPRN_KNJ:				;
	MOV	DS:[DI],DX		;
	INC	LINCNT			; 文字数
	INC	LINCNT			; 文字数
	INC	DI			;
	INC	DI			;
	INC	BX			;
	INC	BX			;
	JMP	TKQIZPRN_3		;
TKQIZPRN_EOS:				;
	CMP	LINCNT,0		;
	JNE	TKQIZPRN_2		;
	JMP	TKQIZPRN_EXIT		; 終わり
TKQIZPRN_2:				;

	MOV	PRN_EOS,1		; 文字列終わり
	MOV	DS:[DI],BYTE PTR 0	; end of string.
	JMP	TKQIZPRN_4		;
TKQIZPRN_3:
	MOV	AX,MOJI_MAX		; 最大文字数＜注目！！＞
;*NON*;	DEC	AX			;
	CMP	LINCNT,AX		; 最大文字数
	JNB	TKQIZPRN_31		;
	JMP	TKQIZPRN_LOOP_END	; 終わり
TKQIZPRN_31:
	MOV	DS:[DI],BYTE PTR 0	; end of string.

	CMP	BYTE PTR ES:[BX],'@'	; 改行指定
	JNE	TKQIZPRN_311		;
	INC	BX			; 改行見送り
TKQIZPRN_311:				;

	CMP	BYTE PTR ES:[BX],0	; 文字列ちょうど終わり？
	JNE	TKQIZPRN_32		;
	MOV	PRN_EOS,1		; 文字列終わり
	JMP	TKQIZPRN_4		;
TKQIZPRN_32:
	MOV	DX,ES:[BX]		; １全角取り出し
	CALL	ADDCHECK		; 追加したい文字のチェック
	CMP	AX,1			;
	JNE	TKQIZPRN_4		;
	CALL	JISCHECK		; 漢字チェック
	CMP	AX,1			;
	JE	TKQIZPRN_KNJ2		;
	MOV	DS:[DI],DH		;
	MOV	DS:[DI][1],BYTE PTR 0	; end of string.
	INC	BX			;
	JMP	TKQIZPRN_4		;
TKQIZPRN_KNJ2:				;
	MOV	DS:[DI],DX		;
	MOV	DS:[DI][2],BYTE PTR 0	; end of string.
	INC	BX			;
	INC	BX			;
TKQIZPRN_4:				;

	PUSH	ES			;
	PUSH	BX			;
	MOV	SI,OFFSET LINBUF	; 台詞表示ラインバッファ
	MOV	AX,QIZX			; 台詞表示Ｘ
	MOV	BX,QIZY			; 台詞表示Ｙ
	CMP	PUTMODE,1		; 文字出力モード(0=PSET,1=OR,2=fuchi)
	JE	TKQIZPRN_43		;
	CMP	PUTMODE,2		; 文字出力モード(0=PSET,1=OR,2=fuchi)
	JE	TKQIZPRN_433		;
TKQIZPRN_42:				;
	CALL	MOUSESTOP		; マウスストップ
	CALL	VTXPRN			;
	CALL	MOUSESTART		; マウススタート
	JMP	TKQIZPRN_44		;
TKQIZPRN_43:				;
	CALL	MOUSESTOP		; マウスストップ
	CALL	VTXPOR			; vram text print OR.
	CALL	MOUSESTART		; マウススタート
	JMP	TKQIZPRN_44		;
TKQIZPRN_433:				;
	CALL	MOUSESTOP		; マウスストップ
	CALL	VTXPFC			; vram text print fuchi.
	CALL	MOUSESTART		; マウススタート
	JMP	TKQIZPRN_44		;
TKQIZPRN_44:				;
	POP	BX			;
	POP	ES			;

	CMP	PRN_EOS,1		; 文字列終わり
	JE	TKQIZPRN_EXIT		; 終わり

	CALL	TKQIZPRN_LF		; 表示処理中の改行処理

	JMP	TKQIZPRN_ST		; 次のライン
TKQIZPRN_LOOP_END:			;
	JMP	TKQIZPRN_LOOP		;
TKQIZPRN_EXIT:				;
	MOV	AX,LINCNT		; 文字数
	MOV	BX,NOWWTD		; 現在の１文字キャラクタ幅
	CWD				;
	IMUL	BX			;
	ADD	AX,QIZXS		; 台詞表示ウインドウ左上Ｘ
	MOV	QIZX,AX			;
	RET				;
TKQIZPRN	ENDP



;	スタート時の改行処理

TKQIZPRN_LFS	PROC	NEAR
	PUSH	ES
	PUSH	AX
	PUSH	BX
	PUSH	DI
	PUSH	SI

	MOV	AX,MOJI_MAX		; 最大文字数＜注目！！＞
	CMP	LINCNT,AX		; 最大文字数
	JB	TKQIZPRN_LFS_EXIT	;

	MOV	KAIGYOU,1		; 1=次のプリント時に改行せよ

TKQIZPRN_LFS_EXIT:			;
	POP	SI
	POP	DI
	POP	BX
	POP	AX
	POP	ES
	RET
TKQIZPRN_LFS	ENDP



;	表示処理中の改行処理

TKQIZPRN_LF	PROC	NEAR
	PUSH	ES
	PUSH	AX
	PUSH	BX
	PUSH	DI
	PUSH	SI

	MOV	KAIGYOU,1		; 1=次のプリント時に改行せよ

	POP	SI
	POP	DI
	POP	BX
	POP	AX
	POP	ES
	RET
TKQIZPRN_LF	ENDP


;	台詞改行

TKQZLF	PROC	NEAR
	CMP	KAIGYOU,1		; 1=次のプリント時に改行せよ
	JNE	TKQZLF_SKIP		;

	CALL	TKQZLFEED		; 台詞改行処理
TKQZLF_SKIP:
	MOV	KAIGYOU,1		; 1=次のプリント時に改行せよ
	RET
TKQZLF	ENDP


;	先行改行

TKQZLFS	PROC	NEAR
	PUSH	ES
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	DI
	PUSH	SI

	CMP	KAIGYOU,1		; 1=次のプリント時に改行せよ
	JNE	TKQZLFS_SKIP		;

	CALL	TKQZLFEED		; 台詞改行処理
TKQZLFS_SKIP:
	MOV	KAIGYOU,0		; 1=次のプリント時に改行せよ
	POP	SI
	POP	DI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	POP	ES
	RET
TKQZLFS	ENDP


;	台詞改行処理

TKQZLFEED	PROC	NEAR
;*NON*;	PRV	"LOCATE_NEXT=",LOCATE_NEXT
;*NON*;	PRV	"PRINT_CNT=",PRINT_CNT

	MOV	AX,MAX_LOC_NEXT		; 表示最大数
	CMP	LOCATE_NEXT,AX		; 使用行
	JB	TKQZLFEED5		; 最下位行でないならばロケートずらす

	CMP	FLG_USERW,1		; ユーザ待ちを除くか？
	JE	TKQZLFEED2		;

	MOV	AX,MAX_LOC_NEXT		; 表示最大数
	CMP	PRINT_CNT,AX		; プリント行数
;*;	JBE	TKQZLFEED2		; 送り行数が少ない内はユーザ待ちなし
	JB	TKQZLFEED2		; 送り行数が少ない内はユーザ待ちなし

	CALL	USER_WAIT		; カーソルボタン待ち
	MOV	PRINT_CNT,1		; プリント行数

TKQZLFEED2:				;
	CMP	LINCNT,0		; 文字数
	JNE	TKQZLFEED3		;

	INC	PRINT_CNT		; プリント行数
	CALL	ADV_SCROLL_H		; アドベンチャースクロール／ハーフ
	JMP	TKQZLFEED6		;
TKQZLFEED3:				;
	INC	PRINT_CNT		; プリント行数
	CALL	ADV_SCROLL		; アドベンチャースクロール
	JMP	TKQZLFEED6		;
TKQZLFEED5:
	INC	PRINT_CNT		; プリント行数
	MOV	CX,ADV_NXT_Y		; 次の行までの間隔
	ADD	QIZY,CX			;
	INC	LOCATE_NEXT		; 使用行(最下位行を使用？)
TKQZLFEED6:
	MOV	AX,QIZXS		; 台詞表示ウインドウ左上Ｘ
	MOV	QIZX,AX			; 台詞表示Ｘ
	MOV	LINCNT,0		; 文字数
	RET
TKQZLFEED	ENDP



;	台詞改行のプレイヤー待ち

TKWAIT	PROC	NEAR
	CALL	USER_WAIT		; カーソルボタン待ち
	RET
TKWAIT	ENDP



;	台詞改行のカウンタリセット

TKRSET	PROC	NEAR
	MOV	PRINT_CNT,1		; プリント行数
	RET
TKRSET	ENDP




;	カーソルボタン待ち

USER_WAIT	PROC	NEAR
	CMP	TALKDEMO,55	; デモフラグ 0=通常,55=ランダムセレクト
	JNE	USER_WAIT_START
	RET
USER_WAIT_START:
	PUSH	AX
	PUSH	BX

	MOV	MUS_FLAG,0	; マウスフラグ
	CALL	MSCWATTM	; カーソルボタンＯＦＦ待ち（待ちタイマ付き）
	CALL	MSCSTS		; マウスカーソルステータス
	CMP	AX,1		; 1=マウスカーソル表示中
	JNE	USER_WAIT_2	;
	MOV	MUS_FLAG,1	; マウスフラグ
	CALL	MSCSTP		; カーソルストップ
USER_WAIT_2:

	MOV	AX,QIZXS	; 台詞表示ウインドウ左上Ｘ
	ADD	AX,QIZXE	; 台詞表示ウインドウ右下Ｘ
	SHR	AX,1		; / 2
	DEC	AX		;
	DEC	AX		; - 2
;*;	MOV	BX,QIZYE	; 台詞表示ウインドウ右下Ｙ
	MOV	BX,QIZY		; 台詞表示Ｙ
;*;	SUB	BX,1		; - 1
	ADD	BX,8*2		; +4
	CALL	MSWWAT		; カーソルボタン待ち

	CALL	MSCWATTM	; カーソルボタンＯＦＦ待ち（待ちタイマ付き）

	CMP	MUS_FLAG,1	; マウスフラグ
	JNE	USER_WAIT_8	;
	MOV	MUS_FLAG,0	; マウスフラグ
	CALL	MSCSRT		; カーソルスタート
USER_WAIT_8:

	POP	BX
	POP	AX
	RET
USER_WAIT	ENDP




;	追加したい文字列のチェック
;	-I- DX : ＪＩＳコード
;	    ADDCHRFLG : 1=追加文字処理
;	-O- AX : 0=必要無し  1=追加

ADDCHECK	PROC	NEAR
	CMP	ADDCHRFLG,1	; 1=追加文字処理
	JE	ADDCHECK2	;
	MOV	AX,0		; 0=必要無し
	RET
ADDCHECK2:
	XCHG	DH,DL

	CMP	DX,8149H	; ！
	JE	ADDCHECK_ADD	;

	CMP	DX,08176H	; 」
	JE	ADDCHECK_ADD_HNK

	CMP	DX,8141H	; 、。，？！････
	JB	ADDCHECK_NON
;*NON*;	CMP	DX,81ACH	; 、。，？！････
	CMP	DX,8144H	; 、。，？！････
	JNB	ADDCHECK_NON
ADDCHECK_ADD:
ADDCHECK_ADD_HNK:		;
	XCHG	DH,DL
	MOV	AX,1		; 1=追加
	RET
ADDCHECK_NON:
	XCHG	DH,DL
	MOV	AX,0		; 0=必要無し
	RET
ADDCHECK	ENDP


;	漢字チェック
;	-I- DX : ＪＩＳコード
;	-O- AX : 0=ANK  1=KANJI

JISCLOW_L	EQU	7FH	; 下方コードLOW
JISCLOW_H	EQU	9FH	;	    HI
JISCHI_L	EQU	0E0H	; 上方コードLOW
JISCHI_H	EQU	0FFH	;	    HI

JISCHECK	PROC	NEAR

	CMP	DL,JISCLOW_L	; 下方コードLOW
	JB	JISCHECK_ANK	;

	CMP	DL,JISCLOW_H	;	    HI
	JBE	JISCHECK_KANJI	;

	CMP	DL,JISCHI_L	; 上方コードLOW
	JB	JISCHECK_ANK	;

	CMP	DL,JISCHI_H	;	    HI
	JBE	JISCHECK_KANJI	;
JISCHECK_KANJI:
	MOV	AX,1		; KANJI
	RET			;
JISCHECK_ANK:
	MOV	AX,0		; ANK
	RET			;
JISCHECK	ENDP



;	アドベンチャースクロール／ハーフ
;	-I- QIZXS : 台詞表示ウインドウ左上Ｘ
;	    QIZYS : 台詞表示ウインドウ左上Ｙ
;	    QIZXE : 台詞表示ウインドウ右下Ｘ
;	    QIZYE : 台詞表示ウインドウ右下Ｙ
;	    SCROLLDEV : スクロール移動相対量

ADV_SCROLL_H	PROC	NEAR
	PUSH	SCROLLDEV		; スクロール移動相対量
;*NON*;	SHR	SCROLLDEV,1		;
	CALL	ADV_SCROLL		; アドベンチャースクロール
	POP	SCROLLDEV		; スクロール移動相対量
	RET
ADV_SCROLL_H	ENDP



;	アドベンチャースクロール
;	-I- QIZXS : 台詞表示ウインドウ左上Ｘ
;	    QIZYS : 台詞表示ウインドウ左上Ｙ
;	    QIZXE : 台詞表示ウインドウ右下Ｘ
;	    QIZYE : 台詞表示ウインドウ右下Ｙ
;	    SCROLLDEV : スクロール移動相対量

ADV_SCROLL	PROC	NEAR
	MOV	AX,QIZXS	; 台詞表示ウインドウ左上Ｘ
	MOV	QSCX1,AX	; スクロール左上Ｘ

	MOV	AX,QIZYS	; 台詞表示ウインドウ左上Ｙ
	MOV	QSCY1,AX	; スクロール左上Ｙ

	MOV	AX,QIZXE	; 台詞表示ウインドウ右下Ｘ
	MOV	QSCX2,AX	; スクロール右下Ｘ

	MOV	AX,QIZYE	; 台詞表示ウインドウ右下Ｙ
	MOV	QSCY2,AX	; スクロール右下Ｙ

	CALL	TKSCRL		; メッセージスクロール
	RET
ADV_SCROLL	ENDP





;	メッセージスクロール
;	-I- QSCX1 : スクロール左上Ｘ
;	    QSCY1 : スクロール左上Ｙ
;	    QSCX2 : スクロール右下Ｘ
;	    QSCY2 : スクロール右下Ｙ
;	    SCROLLDEV : スクロール移動相対量

TKSCRL	PROC	NEAR
	CALL	TMVCNT			; V-SYNC timer cont.
	CALL	MOUSESTOP		;  マウスストップ

	MOV	AX,WORD PTR ARAVRM[0]
	MOV	SSSOU0,AX
	MOV	AX,WORD PTR ARAVRM[2]
	MOV	SSSOU1,AX
	MOV	AX,WORD PTR ARAVRM[4]
	MOV	SSSOU2,AX
	MOV	AX,WORD PTR ARAVRM[6]
	MOV	SSSOU3,AX
	MOV	AX,WORD PTR ARAVRM[0]
	MOV	SSDES0,AX
	MOV	AX,WORD PTR ARAVRM[2]
	MOV	SSDES1,AX
	MOV	AX,WORD PTR ARAVRM[4]
	MOV	SSDES2,AX
	MOV	AX,WORD PTR ARAVRM[6]
	MOV	SSDES3,AX

	MOV	AX,QSCX1
	MOV	VX1,AX

	MOV	AX,ADV_NXT_Y		; 次の行までの間隔
	SHR	AX,1
;*NON*;	SHR	AX,1			; ２アクションスクロール
	CWD
	MOV	BX,SCROLLDEV		; スクロール移動相対量
	IMUL	BX
	MOV	DX,QSCY1		; scroll value.
	ADD	DX,AX			; 次の行までの間隔
	MOV	VY1,DX

	MOV	AX,QSCX2
	SUB	AX,QSCX1
	MOV	VX2,AX
	MOV	AX,QSCY2
	SUB	AX,QSCY1		; scroll value.
	MOV	DX,ADV_NXT_Y		; 次の行までの間隔
;*NON*;	SHR	DX,1			; ２アクションスクロール
	SUB	AX,DX
	MOV	VY2,AX

	MOV	AX,QSCX1
	MOV	VX3,AX
	MOV	AX,QSCY1
	MOV	VY3,AX

	MOV	AX,TIME_SCROL		; スクロールインターバル
	CALL	TMVSET			; V-SYNC timer set.
	CALL	MOVEVR			; vram to vram move.
	CALL	LINE_CLR_UNIT		; ラインクリア・ユニット
	CALL	TMVEWT			; V-SYNC timer end wait.

	CALL	MOUSESTART		; マウススタート

	RET

;*NON*;	MOV	AX,QSCX1
;*NON*;	MOV	VX1,AX
;*NON*;	MOV	AX,QSCY1		; scroll value.
;*NON*;	INC	AX
;*NON*;	INC	AX
;*NON*;	INC	AX
;*NON*;	INC	AX
;*NON*;	MOV	VY1,AX
;*NON*;
;*NON*;	MOV	AX,QSCX2
;*NON*;	SUB	AX,QSCX1
;*NON*;	MOV	VX2,AX
;*NON*;
;*NON*;	MOV	AX,QSCY2
;*NON*;	SUB	AX,QSCY1
;*NON*;	DEC	AX
;*NON*;	DEC	AX
;*NON*;	DEC	AX
;*NON*;	MOV	VY2,AX
;*NON*;
;*NON*;	MOV	AX,QSCX1
;*NON*;	MOV	VX3,AX
;*NON*;	MOV	AX,QSCY1
;*NON*;	MOV	VY3,AX
;*NON*;
;*NON*;	MOV	CX,SCROLLDEV		; スクロール移動相対量
;*NON*;TKSCRL2:
;*NON*;	PUSH	DI
;*NON*;	PUSH	SI
;*NON*;	PUSH	CX
;*NON*;	CALL	MOVEVR			; vram to vram move.
;*NON*;TKSCRL3:
;*NON*;	CALL	TMVCHK			; V-SYNC timer check.
;*NON*;	CMP	AX,0			; 0=timer now, 1=timer end.
;*NON*;	JE	TKSCRL3			;
;*NON*;	MOV	AX,TIME_SCROL		; スクロールインターバル
;*NON*;	CALL	TMVSET			; V-SYNC timer set.
;*NON*;	POP	CX
;*NON*;	POP	SI
;*NON*;	POP	DI
;*NON*;	LOOP	TKSCRL2
;*NON*;
;*NON*;	RET
TKSCRL	ENDP


;	ラインクリア・ユニット

LINE_CLR_UNIT	PROC	NEAR
	PUSH	VX1
	PUSH	VY1
	PUSH	VX2
	PUSH	VY2

	MOV	BX,ADV_NXT_Y		; 次の行までの間隔
;*NON*;	SHR	BX,1			; ２アクションスクロール
	MOV	DX,VY1
	ADD	DX,VY2
	MOV	AX,QSCX1		; スクロール左上Ｘ
	MOV	VX1,AX			;
	MOV	AX,DX			; スクロール右下Ｙ
	SUB	AX,BX
	MOV	VY1,AX			;
	MOV	AX,QSCX2		; スクロール右下Ｘ
	DEC	AX			; **
	DEC	AX			; **
	MOV	VX2,AX			;
	MOV	AX,DX			; スクロール右下Ｙ
	MOV	VY2,AX			;
	MOV	CX,W_COL3		; カラー・暗い灰
	CALL	BOXPAL			; ＢＯＸペイント
	MOV	CX,W_COL4		; カラー・黒
	CALL	BOXMSS			; ＢＯＸメッシュ

	POP	VY2
	POP	VX2
	POP	VY1
	POP	VX1
	RET
LINE_CLR_UNIT	ENDP


;	マウスストップ

MOUSESTOP	PROC	NEAR
;*NON*;	PUSH	AX
;*NON*;	PUSH	BX
;*NON*;	PUSH	CX
;*NON*;	PUSH	DX
;*NON*;	PUSH	SI
;*NON*;	PUSH	DI
;*NON*;	PUSH	BP
;*NON*;	PUSH	DS
;*NON*;	PUSH	ES
;*NON*;
;*NON*;	CALL	MSCSTP			; カーソルストップ
;*NON*;
;*NON*;	POP	ES
;*NON*;	POP	DS
;*NON*;	POP	BP
;*NON*;	POP	DI
;*NON*;	POP	SI
;*NON*;	POP	DX
;*NON*;	POP	CX
;*NON*;	POP	BX
;*NON*;	POP	AX
	RET
MOUSESTOP	ENDP



;	マウススタート

MOUSESTART	PROC	NEAR
;*NON*;	PUSH	AX
;*NON*;	PUSH	BX
;*NON*;	PUSH	CX
;*NON*;	PUSH	DX
;*NON*;	PUSH	SI
;*NON*;	PUSH	DI
;*NON*;	PUSH	BP
;*NON*;	PUSH	DS
;*NON*;	PUSH	ES
;*NON*;
;*NON*;	CALL	MSCSRT			; カーソルスタート
;*NON*;
;*NON*;	POP	ES
;*NON*;	POP	DS
;*NON*;	POP	BP
;*NON*;	POP	DI
;*NON*;	POP	SI
;*NON*;	POP	DX
;*NON*;	POP	CX
;*NON*;	POP	BX
;*NON*;	POP	AX
	RET
MOUSESTART	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	TALKDEMO		; (TALKER.ASM)デモフラグ
				; 0=通常,55=ランダムセレクト

EXTRN	ADV_INI_X:WORD		; アドベンチャー・台詞左上Ｘ
EXTRN	ADV_INI_Y:WORD		; アドベンチャー・台詞左上Ｙ
EXTRN	ADV_END_X:WORD		; アドベンチャー・台詞右下Ｘ
EXTRN	ADV_END_Y:WORD		; アドベンチャー・台詞右下Ｙ
EXTRN	ADV_SIZE_X:WORD		; アドベンチャー・台詞サイズＸ
EXTRN	ADV_SIZE_Y:WORD		; アドベンチャー・台詞サイズＹ

EXTRN	FKI_INI_X:WORD		; ふきだし・台詞左上Ｘ
EXTRN	FKI_INI_Y:WORD		; ふきだし・台詞左上Ｙ
EXTRN	FKI_END_X:WORD		; ふきだし・台詞右下Ｘ
EXTRN	FKI_END_Y:WORD		; ふきだし・台詞右下Ｙ
EXTRN	FKI_SIZE_X:WORD		; ふきだし・台詞サイズＸ
EXTRN	FKI_SIZE_Y:WORD		; ふきだし・台詞サイズＹ
EXTRN	FKI_MAX_FUKI_NEXT:WORD	; ふきだし表示最大行
EXTRN	FKI_MOJI_FUKI_MAX:WORD	; ふきだし最大文字数＜注目！！＞

EXTRN	W_COL1:WORD		; WINDOWS/カラー・ハイライト
EXTRN	W_COL2:WORD		; WINDOWS/カラー・明るい灰
EXTRN	W_COL3:WORD		; WINDOWS/カラー・暗い灰
EXTRN	W_COL4:WORD		; WINDOWS/カラー・黒


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

EXTRN	ARAVRM:WORD		; vram area.

TALKDEMO	DW	0		; デモフラグ 0=通常,55=ランダムセレクト

TXCOL1		DW	15		; 通常の台詞カラーおよび初期値

LINBUF		DB	MOJI_BUFF_MAX DUP (0),0,0 ; 台詞表示ラインバッファ

NOW_HANDLE	DW	0		; 現在のハンドル番号

HANDLE_TABLE	LABEL	WORD
ADV_NXT_Y	DW	ADV_NXT_Y_INI	; 次の行までの間隔
QIZX		DW	0 ;ADV_INI_X	; 台詞表示Ｘ
QIZY		DW	0 ;ADV_INI_Y	; 台詞表示Ｙ
QIZXS		DW	0 ;ADV_INI_X	; 台詞表示ウインドウ左上Ｘ
QIZYS		DW	0 ;ADV_INI_Y	; 台詞表示ウインドウ左上Ｙ
QIZXE		DW	0 ;ADV_END_X	; 台詞表示ウインドウ右下Ｘ
QIZYE		DW	0 ;ADV_END_Y	; 台詞表示ウインドウ右下Ｙ
QSCX1		DW	0 ;ADV_INI_X	; スクロール左上Ｘ
QSCY1		DW	0 ;ADV_INI_Y	; スクロール左上Ｙ
QSCX2		DW	0 ;ADV_END_X	; スクロール右下Ｘ
QSCY2		DW	0 ;ADV_END_Y	; スクロール右下Ｙ
LINCNT		DW	0		; 文字数
PRINT_CNT	DW	0		; プリント行数
MOJI_MAX	DW	32		; 最大文字数＜注目！！＞
LOCATE_NEXT	DW	0		; 使用行 (最下位行を使用？)
MAX_LOC_NEXT	DW	0		; 表示最大数
FLG_USERW	DW	0		; ユーザ待ちを除くか？
ADDCHRFLG	DW	1		; 1=追加文字処理
PRN_EOS		DW	0		; 文字列終わり=1
KAIGYOU		DW	0		; 1=次のプリント時に改行せよ
NOWWTD		DW	1		; 現在の１文字キャラクタ幅
SCROLLDEV	DW	2		; スクロール移動相対量
MUS_FLAG	DW	0		; マウスフラグ
SCROLL_SW	DW	0		; スクロールスイッチ(1=スクロール)
PUTMODE		DW	0		; 文字出力モード(0=PSET,1=OR,2=fuchi)

SAVE_TABLE	LABEL	WORD
		DW	0		; 次の行までの間隔
		DW	0 		; 台詞表示Ｘ
		DW	0 		; 台詞表示Ｙ
		DW	0 		; 台詞表示ウインドウ左上Ｘ
		DW	0 		; 台詞表示ウインドウ左上Ｙ
		DW	0 		; 台詞表示ウインドウ右下Ｘ
		DW	0 		; 台詞表示ウインドウ右下Ｙ
		DW	0 		; スクロール左上Ｘ
		DW	0 		; スクロール左上Ｙ
		DW	0 		; スクロール右下Ｘ
		DW	0 		; スクロール右下Ｙ
		DW	0		; 文字数
		DW	0		; プリント行数
		DW	0		; 最大文字数＜注目！！＞
		DW	0		; 使用行 (最下位行を使用？)
		DW	0		; 表示最大数
		DW	0		; ユーザ待ちを除くか？
		DW	0		; 1=追加文字処理
		DW	0		; 文字列終わり=1
		DW	0		; 1=次のプリント時に改行せよ
		DW	0		; 現在の１文字キャラクタ幅
		DW	2 ;**		; スクロール移動相対量
		DW	0		; マウスフラグ
		DW	0		; スクロールスイッチ(1=スクロール)
		DW	0		; 文字出力モード(0=PSET,1=OR,2=fuchi)
SAVE_TABLE_END	LABEL	WORD
		DW	0
DATA	ENDS

	END
;
;	end of "TALKER.ASM"
;
