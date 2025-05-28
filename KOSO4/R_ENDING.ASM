; "R_ENDING.ASM" PC-9801UV11 make by R.H 1991/02/12
;
;
;	「子育て」
;
;	エンディング
;
;		1=女王
;		2=姫
;		3=長寿
;		4=将軍
;		5=王立アカデミー総裁
;		6=王宮魔法師
;		7=貴族の妻１
;		8=王の側室
;		9=司祭
;		10=騎士
;		11=近衛隊長
;		12=練金術師
;		13=魔道師
;		14=貴族の妻２
;		15=貴族の側室
;		16=上級尼僧
;		17=百姓の妻
;		18=木コリ
;		19=文士
;		20=魔法使い
;		21=商家の妻
;		22=酒場の女の子
;		23=尼僧
;		24=傭兵
;		25=賞金かせぎ
;		26=サギ師
;		27=旅の魔法使い
;		28=高級娼婦
;		29=売春婦
;		30=出戻り
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_ENDING			; エンディング
PUBLIC	R_ENDING_DBG			; エンディングデバック
PUBLIC	R_ENDING_VIEW			; 結果を見せる

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	ENDING:NEAR			; エンディング

EXTRN	R_SR_YOIDESUKA:NEAR		; よいですか

EXTRN	PT_PALET_ST:NEAR		; パレットのセット
EXTRN	PT_OCHI_LD:NEAR			; オチの絵ロード
EXTRN	PT_OCHI_PUT:NEAR		; オチの絵ＰＵＴ

EXTRN	WID_9_FLAME:NEAR		; WINDOWS/フレーム９（オチ）

; ****************************************************
;	エンディング
; ****************************************************

R_ENDING	PROC	NEAR
	CALL	R_ENDING_CALC		; 決算！
	CALL	R_ENDING_MAIN		; エンディングＭＡＩＮ
	RET
R_ENDING	ENDP


; ****************************************************
;	エンディングデバック
; ****************************************************

R_ENDING_DBG	PROC	NEAR
	CALL	R_ENDING_MAIN		; エンディングＭＡＩＮ
	RET
R_ENDING_DBG	ENDP


; ****************************************************
;	エンディングＭＡＩＮ
; ****************************************************

R_ENDING_MAIN	PROC	NEAR
;*;	MOV	AX,1			; 0=16x16  1=32x32  2=16x24  3=16x32
;*;	CALL	VTXSIZ				; character size set.
;*;	MOV	AX,10				; ヘッダー文字表示色
;*;	CALL	VTXCOL				; character color set.
;*;	MOV	AX,40-8				; Ｘ座標
;*;	MOV	BX,180				; Ｙ座標
;*;	MOV	SI,OFFSET UNMEI_MSG		; "運命の日・・・"
;*;	CALL	VTXPOR				; vram text print OR.

	PR_CLS
	PR_TXT	"運命の日………"

;*;	MOV	DX,16				; 夏のパレットのパターン番号
;*;	CALL	PT_PALET_ST			; パレットのセット
;*	CALL	NORMIN				; ノーマルカラー
;*;	MOV	AX,60*1				; wait timer count.
;*;	CALL	TMVWAT				; V-SYNC timer wait.
;*;	CALL	VRMCLR				; ＶＲＡＭクリア

	CALL	ENDING				; エンディング

;*;	MOV	AX,1			; 0=16x16  1=32x32  2=16x24  3=16x32
;*;	CALL	VTXSIZ				; character size set.
;*;	MOV	AX,10				; ヘッダー文字表示色
;*;	CALL	VTXCOL				; character color set.
;*;	MOV	AX,0				; Ｘ座標
;*;	MOV	BX,2				; Ｙ座標
;*;	MOV	SI,OFFSET MSG_MATE		; "待て、次号！！！"
;*;	CALL	VTXPOR				; vram text print OR.
;*;	CALL	NORMIN				; ノーマルカラー

	RET
R_ENDING_MAIN	ENDP


; ****************************************************
;	決算！
;	-O- SLCT_CLASS : 階級選択
;	    SLCT_WORKS : 仕事選択
; ****************************************************

R_ENDING_CALC	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,66			; 66=運命の決定
	CALL	R_KEISAN			; 各計算処理
	MOV	SLCT_CLASS,CX			; 階級選択
	MOV	SLCT_WORKS,DX			; 仕事選択
	RET
R_ENDING_CALC	ENDP


; ****************************************************
;	結果を見せる
;	-I- OCHI_KIND : 落ちの種類
;	    OCHI_CUT  : 落ちのカット番号
; ****************************************************

R_ENDING_VIEW	PROC	NEAR
	MOV	DX,OCHI_KIND			; 落ちの種類
	MOV	BX,OCHI_CUT			; 落ちのカット番号
	CALL	PT_OCHI_LD			; オチの絵ロード
	MOV	AX,20				; イベントウインドウＸ位置
	MOV	BX,60				; イベントウインドウＹ位置
	CALL	PT_OCHI_PUT			; オチの絵ＰＵＴ
	RET
R_ENDING_VIEW	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	OCHI_CUT			; 落ちのカット番号
PUBLIC	OCHI_KIND			; 落ちの種類

EXTRN	S_FUNC:WORD			; 計算ファンクション
EXTRN	SLCT_CLASS:WORD			; 階級選択
EXTRN	SLCT_WORKS:WORD			; 仕事選択


OCHI_CUT	DW	1		;
OCHI_KIND	DW	0		;
					;		1=女王
					;		2=姫
					;		3=長寿
					;		4=将軍
					;		5=王立アカデミー総裁
					;		6=王宮魔法師
					;		7=貴族の妻１
					;		8=王の側室
					;		9=司祭
					;		10=騎士
					;		11=近衛隊長
					;		12=練金術師
					;		13=魔道師
					;		14=貴族の妻２
					;		15=貴族の側室
					;		16=上級尼僧
					;		17=百姓の妻
					;		18=木コリ
					;		19=文士
					;		20=魔法使い
					;		21=商家の妻
					;		22=酒場の女の子
					;		23=尼僧
					;		24=傭兵
					;		25=賞金かせぎ
					;		26=サギ師
					;		27=旅の魔法使い
					;		28=高級娼婦
					;		29=売春婦
					;		30=出戻り

;;UNMEI_MSG	DB	"運命の日・・・",0
;;MSG_MATE	DB	"このあとのエンド処理は作成中@待て、次号！！！",0

DATA	ENDS

	END
;
;	end of "R_ENDING.ASM"
;
