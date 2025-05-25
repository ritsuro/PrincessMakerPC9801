; "KOSO.INC" PC-9801UV11 make by R.H 1990/10/13
;
; 以下の４個の変数はＶＲＡＭセグメント指定です
; このインクルードの機能を使う前に設定して下さい
; これらの変数はＣＭＤＴＢＬ．ＡＳＭで定義されています
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;
; ＶＲＡＭのセグメントアドレスはテーブルでも持っています
; このテーブルは高度な処理で使う以外には変更しないで下さい
;	ARAVRM			; これはＰＣ９８ＶＲＡＭ
;	ARA001			; これは仮想ＶＲＡＭ１
;	ARA002			; これは仮想ＶＲＡＭ２
;	ARA003			; これは仮想ＶＲＡＭ３（２００ライン）
;


STRING_LEN 	EQU	255	; string length.
STR_VAL_LEN 	EQU	6	; string length.（数値表示用）
STR_VAL_LEN2	EQU	24	; string length.（数値表示拡張）


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



;	ＯＬ＿ＩＭＧ	＜転送元ＩＤ＞，＜転送先ＩＤ＞
;				，Ｘ１，Ｙ１，Ｘ２，Ｙ２，Ｘ３，Ｙ３

OL_IMG	MACRO	SOUID,DESTID,X1,Y1,X2,Y2,X3,Y3
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
	EXTRN	OVLAP:NEAR	; オーバラップ
	CALL	OVLAP		;
	ENDM


;	ＭＯＶＥ＿ＰＬＮ	＜転送元セグメント＞，＜転送先セグメント＞

MOVE_PLN	MACRO	SOUID,DESTID
	PUSH	DS
	PUSH	ES
	PUSH	CX
	PUSH	SI
	PUSH	DI
	MOV	CX,DESTID
	MOV	ES,CX
	MOV	CX,SOUID
	MOV	DS,CX
	MOV	SI,0
	MOV	DI,0
	MOV	CX,80*400/2	; 1 plean length.
	REP	MOVSW
	POP	DI
	POP	SI
	POP	CX
	POP	ES
	POP	DS
	ENDM


;	ＳＨＩＦＴ＿Ｌ	Ｘ，Ｙ，Ｘｓｉｚｅ，Ｙｓｉｚｅ
;
;	ＶＲＡＭ１ビット左シフト

SHIFT_L		MACRO	X1,Y1,X2,Y2
	MOV	AX,X1
	MOV	WORD PTR VX1,AX
	MOV	AX,Y1
	MOV	WORD PTR VY1,AX
	MOV	AX,X2
	MOV	WORD PTR VX2,AX
	MOV	AX,Y2
	MOV	WORD PTR VY2,AX

	EXTRN	SHFLFT:NEAR	; ＶＲＡＭ１ビット左シフト
	CALL	SHFLFT
	ENDM



;	ＳＨＩＦＴ＿Ｒ	Ｘ，Ｙ，Ｘｓｉｚｅ，Ｙｓｉｚｅ
;
;	ＶＲＡＭ１ビット右シフト

SHIFT_R		MACRO	X1,Y1,X2,Y2
	MOV	AX,X1
	MOV	WORD PTR VX1,AX
	MOV	AX,Y1
	MOV	WORD PTR VY1,AX
	MOV	AX,X2
	MOV	WORD PTR VX2,AX
	MOV	AX,Y2
	MOV	WORD PTR VY2,AX

	EXTRN	SHFRGT:NEAR	; ＶＲＡＭ１ビット右シフト
	CALL	SHFRGT
	ENDM



;	ＡＲＡＣＨＫ	＜Ｘmin＞，＜Ｙmin＞，
;				＜Ｘmax＞，＜Ｙmax＞，＜当たりラベル＞
;	入力	ＡＸ：Ｘ座標　，ＢＸ：Ｙ座標

ARACHK	MACRO	X1,Y1,X2,Y2,LBL
	LOCAL	L1
	CMP	AX,X1
	JB	L1
	CMP	AX,X2
	JNBE	L1
	CMP	BX,Y1
	JB	L1
	CMP	BX,Y2
	JNBE	L1
	JMP	LBL
L1:
	ENDM


;	ＡＲＡＣＨＫ２	＜Ｘ＞，＜Ｙ＞，＜当たりラベル＞
;	入力	ＡＸ：Ｘmin，ＢＸ：Ｙmin，ＣＸ：Ｘmax，ＤＸ：Ｙmax

ARACHK2	MACRO	XX,YY,LBL
	LOCAL	L1
	CMP	XX,AX
	JB	L1
	CMP	XX,CX
	JNBE	L1
	CMP	YY,BX
	JB	L1
	CMP	YY,DX
	JNBE	L1
	JMP	LBL
L1:
	ENDM


;	ＢＡＮＤＣＨＫ	＜比較＞，＜最小値＞，＜最大値＞，＜範囲外ラベル＞

BANDCHK	MACRO	CP1,CPMIN,CPMAX,LBL
	LOCAL	L1,L2
	PUSH	BP

	MOV	BP,CP1
	CMP	BP,CPMIN
	JB	L1

	MOV	BP,CP1
	CMP	BP,CPMAX
	JNBE	L1

	JMP	L2
L1:
	POP	BP
	JMP	LBL
L2:
	POP	BP
	ENDM


;	ＪＭＰＴＢＬ	＜番号＞
;		ＤＷ　ＯＦＦＳＥＴ　＜ラベル０＞
;		ＤＷ　ＯＦＦＳＥＴ　＜ラベル１＞
;			．
;			．

JMPTBL	MACRO	NUM
	LOCAL	L1
	MOV	BX,NUM					;
	SHL	BX,1					; word pointer.
	JMP	WORD PTR CS:L1[BX]			;
L1	LABEL	WORD
	ENDM



;	ＢＯＸＰＡ	＜Ｘmin＞，＜Ｙmin＞，
;			＜Ｘmax＞，＜Ｙmax＞，＜セグメント＞
;（１プレーンのみ塗り）

BOXPA	MACRO	X1,Y1,X2,Y2,SSEG
	MOV	AX,X1
	MOV	VX1,AX
	MOV	AX,Y1
	MOV	VY1,AX
	MOV	AX,X2
	MOV	VX2,AX
	MOV	AX,Y2
	MOV	VY2,AX
	MOV	DX,SSEG
	EXTRN	BOXPAI:NEAR
	CALL	BOXPAI		; ＢＯＸ１プレーンペイント
	ENDM


;	ＢＯＸＢＫ	＜Ｘmin＞，＜Ｙmin＞，
;			＜Ｘmax＞，＜Ｙmax＞，＜セグメント＞
;（１プレーンのみヌキ色）

BOXBK	MACRO	X1,Y1,X2,Y2,SSEG
	MOV	AX,X1
	MOV	VX1,AX
	MOV	AX,Y1
	MOV	VY1,AX
	MOV	AX,X2
	MOV	VX2,AX
	MOV	AX,Y2
	MOV	VY2,AX
	MOV	DX,SSEG
	EXTRN	BOXBLK:NEAR
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
	ENDM


;	ＢＯＸＰＡＡ	＜Ｘmin＞，＜Ｙmin＞，＜Ｘmax＞，＜Ｙmax＞
;				，＜カラーパレット番号＞
;	（いわゆるＢＯＸペイント）

BOXPAA	MACRO	X1,Y1,X2,Y2,CCOL
	MOV	AX,X1
	MOV	VX1,AX
	MOV	AX,Y1
	MOV	VY1,AX
	MOV	AX,X2
	MOV	VX2,AX
	MOV	AX,Y2
	MOV	VY2,AX
	MOV	CX,CCOL
	EXTRN	BOXPAL:NEAR
	CALL	BOXPAL		; ＢＯＸペイント
	ENDM


;	ＢＯＸＭＳ	＜Ｘmin＞，＜Ｙmin＞，＜Ｘmax＞，＜Ｙmax＞
;				，＜カラーパレット番号＞
;	（メッシュ）

BOXMS	MACRO	X1,Y1,X2,Y2,CCOL
	MOV	AX,X1
	MOV	VX1,AX
	MOV	AX,Y1
	MOV	VY1,AX
	MOV	AX,X2
	MOV	VX2,AX
	MOV	AX,Y2
	MOV	VY2,AX
	MOV	CX,CCOL
	EXTRN	BOXMSS:NEAR
	CALL	BOXMSS		; ＢＯＸメッシュ
	ENDM


;	ＬＯＡＤ＿ＰＡＴ	＜ファイル名＞
;	パーツロード

LOAD_PAT	MACRO	FNAME
	LOCAL	L1,L2
	JMP	L2
DATA	SEGMENT WORD	PUBLIC	'DATA'
L1	DB	FNAME,0
DATA	ENDS
L2:
	EXTRN	PATCLR:NEAR
	CALL	PATCLR		; パーツセットクリア
	MOV	SI,OFFSET L1
	CALL	PATLOD		; パーツロード
	ENDM



;	ＬＯＡＤ＿ＰＡＴＡ	＜ファイル名＞
;	パーツ追加ロード

LOAD_PATA	MACRO	FNAME
	LOCAL	L1,L2
	JMP	L2
DATA	SEGMENT WORD	PUBLIC	'DATA'
L1	DB	FNAME,0
DATA	ENDS
L2:	MOV	SI,OFFSET L1
	CALL	PATLDA		; パーツ追加ロード
	ENDM


;	ＬＯＡＤ＿ＰＡＴＢ	＜ファイル名＞
;	パーツロード＆バッファリング

LOAD_PATB	MACRO	FNAME
	LOCAL	L1,L2
	JMP	L2
DATA	SEGMENT WORD	PUBLIC	'DATA'
L1	DB	FNAME,0
DATA	ENDS
L2:
	CALL	PATCLR		; パーツセットクリア
	MOV	SI,OFFSET L1
	CALL	PATLDM		; パーツロード＆バッファリング
	ENDM



;	ＰＡＬＥＴ＿ＬＯＡＤ	＜パレットテーブル番号＞，＜パーツ番号＞
;	パレットロード

PALET_LOAD	MACRO	TBL,NUM
	MOV	CX,NUM		; パーツ番号
	MOV	BX,TBL		; パレットテーブル番号
	CALL	PLTPAT		; パーツバッファからパレットを取り出す
	ENDM


;	ＰＡＬＥＴ＿ＳＥＴ	＜パーツ番号＞
;	パレットセット

PALET_SET	MACRO	NUM
	MOV	CX,NUM		; パーツ番号
	MOV	BX,0		; パレットテーブル番号
	CALL	PLTPAT		; パーツバッファからパレットを取り出す
	MOV	BX,0		; パレットテーブル番号
	CALL	PLSET		; パレットセット
	ENDM


;	ＰＡＴ＿ＰＵＴ		＜パーツ番号＞，Ｘ，Ｙ
;	パーツＰＵＴ

PAT_PUT		MACRO	NUM,XX,YY
	MOV	AX,XX		;
	MOV	VRX,AX		; ＰＵＴＸ
	MOV	AX,YY		;
	MOV	VRY,AX		; ＰＵＴＹ
	MOV	CX,NUM		; パーツ番号
	CALL	PATPTF		; パーツＰＵＴオフセット指定
	ENDM


;	ＰＡＴ＿ＰＴＸ		＜パーツ番号＞，Ｘ，Ｙ
;	パーツＰＵＴ／パーツＰＵＴ座標指定

PAT_PTX		MACRO	NUM,XX,YY
	MOV	AX,XX		;
	MOV	VRX,AX		; ＰＵＴＸ
	MOV	AX,YY		;
	MOV	VRY,AX		; ＰＵＴＹ
	MOV	CX,NUM		; パーツ番号
	CALL	PATPTX		; パーツＰＵＴ座標指定
	ENDM


;	ＰＡＴ＿ＭＡＳＫ＿ＰＵＴ	＜パーツ番号＞，Ｘ，Ｙ
;	パーツＰＵＴ

PAT_MASK_PUT	MACRO	NUM,XX,YY
	MOV	AX,XX			;
	MOV	VRX,AX			; ＰＵＴＸ
	MOV	AX,YY			;
	MOV	VRY,AX			; ＰＵＴＹ
	MOV	CX,NUM			;

	PUSH	VRX
	PUSH	VRY

	PUSH	CX			; 一つ目はマスク

	CALL	PATPFM			; マスクパーツＰＵＴオフセット指定

	MOV	DX,1			;
	CALL	PATOPE			; (ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	POP	CX
	INC	CX			; 二つ目はパターン

	POP	VRY
	POP	VRX

	CALL	PATPTF			; パーツＰＵＴオフセット指定

	MOV	DX,0			;
	CALL	PATOPE			; (ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
	ENDM


;	ＰＡＴ＿ＭＡＳＫ＿ＰＴＸ	＜パーツ番号＞，Ｘ，Ｙ
;	パーツＰＵＴ座標指定

PAT_MASK_PTX	MACRO	NUM,XX,YY
	MOV	AX,XX			;
	MOV	VRX,AX			; ＰＵＴＸ
	MOV	AX,YY			;
	MOV	VRY,AX			; ＰＵＴＹ
	MOV	CX,NUM			;

	PUSH	VRX
	PUSH	VRY

	PUSH	CX			; 一つ目はマスク

	CALL	PATPXM			; マスクパーツＰＵＴ座標指定

	MOV	DX,1			;
	CALL	PATOPE			; (ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )

	POP	CX
	INC	CX			; 二つ目はパターン

	POP	VRY
	POP	VRX

	CALL	PATPTX			; パーツＰＵＴ座標指定

	MOV	DX,0			;
	CALL	PATOPE			; (ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
	ENDM


;	ＰＡＴ＿ＢＡＮＫ	＜バンク番号＞
;	パーツバンク切り替え

PAT_BANK	MACRO	NUM
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	DX,NUM			; バンク番号（０ー１）
	CALL	PATBNK			; バンクチェンジ
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	ENDM


;	ＰＬＳＭＤ	＜圧縮モード＞
;	圧縮モード切り替え(0:通常,1:縦方向)

PLSMD	MACRO	MODES
	PUSH	DX
	MOV	DX,MODES	; 圧縮モード(0:通常,1:縦方向)
	CALL	PLSMOD		; 圧縮モード切り替え
	POP	DX
	ENDM


;	ＢＡＲ＿Ｈ	＜始点Ｘ＞，＜始点Ｙ＞，＜終点Ｘ＞，
;				＜太さ＞，＜カラー＞
;	横棒を描く

BAR_H	MACRO	XX1,YY1,XX2,HHHH,COL
	MOV	CX,XX1			; start dot point x1.
	MOV	VX1,CX			;
	MOV	CX,YY1			; start dot point y1.
	MOV	VY1,CX			;
	MOV	CX,XX2			; end dot point x2.
	MOV	VX2,CX			;
	MOV	CX,COL			; color.
	MOV	VCOL,CX			;
	MOV	CX,HHHH			; line width.
	CALL	DLINEH			; 水平ライン描画
	ENDM


;	ＢＡＲ＿Ｖ	＜始点Ｘ＞，＜始点Ｙ＞，＜終点Ｙ＞，
;				＜太さ＞，＜カラー＞
;	縦棒を描く

BAR_V	MACRO	XX1,YY1,YY2,HHHH,COL
	MOV	CX,XX1			; line dot point x.
	MOV	VX1,CX			;
	MOV	CX,YY1			; start line point y1.
	MOV	VY1,CX			;
	MOV	CX,YY2			; end line point y2.
	MOV	VY2,CX			;
	MOV	CX,COL			; color.
	MOV	VCOL,CX			;
	MOV	CX,HHHH			; line width.
	CALL	DLINEV			; 垂直ライン描画
	ENDM


CODE	SEGMENT WORD	PUBLIC	'CODE'

	EXTRN	PLSET:NEAR	; パレットセット
	EXTRN	PLGET:NEAR	; パレットＧＥＴ
	EXTRN	PLPUT:NEAR	; パレットＰＵＴ
	EXTRN	PLPSET:NEAR	; パレット編集セット

	EXTRN	PATINI:NEAR	; パーツセット初期処理
	EXTRN	PATCLR:NEAR	; パーツセットクリア
	EXTRN	PATGTA:NEAR	; パーツＧＥＴ圧縮無し
	EXTRN	PATPUT:NEAR	; パーツＰＵＴ
	EXTRN	PATPTX:NEAR	; パーツＰＵＴ座標指定
	EXTRN	PATPTF:NEAR	; パーツＰＵＴオフセット指定
	EXTRN	PATLOD:NEAR	; パーツロード
	EXTRN	PATLDA:NEAR	; パーツ追加ロード
	EXTRN	PATBNK:NEAR	; バンクチェンジ
	EXTRN	PATOPE:NEAR	; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
	EXTRN	PATEFC:NEAR	; パーツＰＵＴエフェクト

	EXTRN	PATPTM:NEAR	; マスクパーツＰＵＴ
	EXTRN	PATPXM:NEAR	; マスクパーツＰＵＴ座標指定
	EXTRN	PATPFM:NEAR	; マスクパーツＰＵＴオフセット指定
	EXTRN	PATSIZ:NEAR	; パーツサイズのＧＥＴ

	EXTRN	PATMST:NEAR	; マスクパーツのＰＵＴプレーン設定

	EXTRN	PLTPAT:NEAR	; パーツバッファからパレットを取り出す

	EXTRN	PLSMOD:NEAR	; 圧縮モード切り替え

	EXTRN	PLSSKP:NEAR	; パーツＰＵＴのプレーンスキップ


	EXTRN	DSKLD:NEAR	; load data.

	EXTRN	TMWAIT:NEAR	; time wait.
	EXTRN	TMVSRT:NEAR	; V-SYNC timer start.
	EXTRN	TMVEND:NEAR	; V-SYNC timer end.
	EXTRN	TMVWAT:NEAR	; V-SYNC timer wait.
	EXTRN	TMVSET:NEAR	; V-SYNC timer set.
	EXTRN	TMVCHK:NEAR	; V-SYNC timer check.
	EXTRN	TMVEWT:NEAR	; V-SYNC timer end wait.
	EXTRN	TMVCLR:NEAR	; V-SYNC timer clear.
	EXTRN	TMVST2:NEAR	; V-SYNC timer2 set.
	EXTRN	TMVCK2:NEAR	; V-SYNC timer2 check.
	EXTRN	TMVST3:NEAR	; V-SYNC timer3 set.
	EXTRN	TMVCK3:NEAR	; V-SYNC timer3 check.
	EXTRN	TMVSTP:NEAR	; V-SYNC timer stop.
	EXTRN	TMVCNT:NEAR	; V-SYNC timer cont.
	EXTRN	TMVSAV:NEAR	; V-SYNC timer value save.
	EXTRN	TMVLOD:NEAR	; V-SYNC timer value load.

	EXTRN	FEDIN:NEAR	; Ｆ・Ｉ（フェードイン）
	EXTRN	FEDOUT:NEAR	; Ｆ・Ｏ（フェードアウト）
	EXTRN	WHTFLS:NEAR	; ＷＨＩＴＥ・ＦＬＡＳＨ
	EXTRN	WHTIN:NEAR	; ＷＨＩＴＥ・ＩＮ
	EXTRN	WHTOUT:NEAR	; ＷＨＩＴＥ・ＯＵＴ
	EXTRN	COLFLS:NEAR	; カラー・ＦＬＡＳＨ
	EXTRN	COLFUL:NEAR	; カラー・ＦＵＬＬ
	EXTRN	BLACK:NEAR	; ブラックアウト
	EXTRN	WHITE:NEAR	; ＷＨＩＴＥ
	EXTRN	BRIIN:NEAR	; 明度５０％からノーマルへ
	EXTRN	BRIOUT:NEAR	; 明度５０％ダウン
	EXTRN	COLBCK:NEAR	; 色相反転
	EXTRN	COLRET:NEAR	; 色相戻し
	EXTRN	FFWHT:NEAR	; ＷＨＩＴＥ反射感
	EXTRN	PLTOL:NEAR	; パレット・オーバラップ
	EXTRN	NORMIN:NEAR	; ノーマルカラー

	EXTRN	PLTFIS:NEAR	; Ｆ・Ｉ（フェードイン）／時分割初期
	EXTRN	PLTFOS:NEAR	; Ｆ・Ｏ（フェードアウト）／時分割初期
	EXTRN	PLTCIS:NEAR	; カラー・ＩＮ／時分割初期
	EXTRN	PLTOLS:NEAR	; パレット・オーバラップ／時分割初期
	EXTRN	PLTOLT:NEAR	; パレット・オーバラップ／時分割処理

	EXTRN	VRMCLR:NEAR	; ＶＲＡＭクリア
	EXTRN	DSP16M:NEAR	; １６色モードセット
	EXTRN	DSP200:NEAR	; ２００／８色モードセット
	EXTRN	VRMDP0:NEAR	; ＶＲＡＭ０表示
	EXTRN	VRMDP1:NEAR	; ＶＲＡＭ１表示
	EXTRN	VRMWT0:NEAR	; ＶＲＡＭ０アクセス
	EXTRN	VRMWT1:NEAR	; ＶＲＡＭ１アクセス

	EXTRN	BOXPAL:NEAR	; ＢＯＸペイント
	EXTRN	BOXNOT:NEAR	; ＢＯＸ反転
	EXTRN	BOXMSS:NEAR	; ＢＯＸメッシュ
	EXTRN	BOXMSU:NEAR	; ＢＯＸ１プレーンメッシュ
	EXTRN	BOXPAI:NEAR	; ＢＯＸ１プレーンペイント
	EXTRN	BOXBLK:NEAR	; ＢＯＸ１プレーンヌキ

	EXTRN	VTXPRN:NEAR	; vram text print.
	EXTRN	VTXPOR:NEAR	; vram text print OR.
	EXTRN	VTXPFC:NEAR	; vram text print fuchi.
	EXTRN	VTXSIZ:NEAR	; character size set.
	EXTRN	VTXCOL:NEAR	; character color set.

	EXTRN	DLINEH:NEAR	; 水平ライン描画
	EXTRN	DLINEV:NEAR	; 垂直ライン描画

	EXTRN	MITCOL:NEAR	; mini string color.
	EXTRN	MITPRN:NEAR	; mini string. (null=end of string)
	EXTRN	MDTPRN:NEAR	; MID string. (null=end of string)
	EXTRN	MWTPRN:NEAR	; WIDE string. (null=end of string)
	EXTRN	MBTPRN:NEAR	; BIG string. (null=end of string)

	EXTRN	STRSET:NEAR	; 文字列バッファセット
	EXTRN	STRSETZ:NEAR	; 文字列バッファセット
	EXTRN	STRCLEAR:NEAR	; 文字列バッファクリア

CODE	ENDS


DATA	SEGMENT WORD	PUBLIC	'DATA'

	EXTRN	GX1:WORD		; ＧＤＣ関係 ('GRBIO.ASM')
	EXTRN	GY1:WORD		;
	EXTRN	GX2:WORD		;
	EXTRN	GY2:WORD		;
	EXTRN	GMODE:WORD		;
	EXTRN	GCODE:WORD		;
	EXTRN	GCLR:WORD		;
	EXTRN	GRD:WORD		;

	EXTRN	SSGR0:WORD		; visual data segment plean 0
	EXTRN	SSGR1:WORD		; visual data segment plean 1
	EXTRN	SSGR2:WORD		; visual data segment plean 2
	EXTRN	SSGR3:WORD		; visual data segment plean 3

	EXTRN	SSDEST:WORD		; visual data segment plean.
	EXTRN	SSDES0:WORD		; visual data segment plean 0
	EXTRN	SSDES1:WORD		; visual data segment plean 1
	EXTRN	SSDES2:WORD		; visual data segment plean 2
	EXTRN	SSDES3:WORD		; visual data segment plean 3

	EXTRN	SSSOUR:WORD		; visual data segment plean.
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

	EXTRN	VCOL:WORD		; color.

	EXTRN	VRX:WORD		; x point.
	EXTRN	VRY:WORD		; y point.

	EXTRN	VRLENX:WORD		; x length.
	EXTRN	VRLENY:WORD		; y length.

	EXTRN	ARAVRM:WORD		; ＶＲＡＭプレーン
	EXTRN	ARA001:WORD		; 仮想ＶＲＡＭプレーン１
	EXTRN	ARA002:WORD		; 仮想ＶＲＡＭプレーン２
	EXTRN	ARA003:WORD		; 仮想ＶＲＡＭ３（２００ライン）

	EXTRN	CLRCDE:WORD		; color code.
	EXTRN	CLRVEW:WORD		; color view.
	EXTRN	CLRCNS:WORD		; contrast.
	EXTRN	CLRBRI:WORD		; brightness.

	EXTRN	CRXVEW:WORD		; 色相回転（０ー３６０）
	EXTRN	CRXCNS:WORD		; 彩度倍率（０ー１００）
	EXTRN	CRXBRI:WORD		; 明度倍率（０ー１００）
	EXTRN	CRXWHI:WORD		; ホワイトレベル（０ー１００）

	EXTRN	CBLUE:WORD		; blue  value (0-15)
	EXTRN	CRED:WORD		; red   value (0-15)
	EXTRN	CGREEN:WORD		; green value (0-15)

	EXTRN	CLRSOU:WORD		; 変更カラーパレット
	EXTRN	CLRDES:WORD		; 変更後カラーパレット

	EXTRN	CRTSKP:WORD		; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)

	EXTRN	WDXX:WORD		; WINDOWS/point x.
	EXTRN	WDYY:WORD		; WINDOWS/point y.
	EXTRN	WDX1:WORD		; WINDOWS/ point x1.
	EXTRN	WDY1:WORD		; WINDOWS/ point y1.
	EXTRN	WDX2:WORD		; WINDOWS/ point x2.
	EXTRN	WDY2:WORD		; WINDOWS/ point y2.
	EXTRN	WDHNO:WORD		; WINDOWS/ヘッダー番号
	EXTRN	WDGNO:WORD		; WINDOWS/横グラフ番号
	EXTRN	WDVNO:WORD		; WINDOWS/内容表示番号
	EXTRN	WDSTR:WORD		; WINDOWS/表示パラメータ名
	EXTRN	WDVAL:WORD		; WINDOWS/表示値
	EXTRN	WDBLNC:WORD		; WINDOWS/表示バランス値
	EXTRN	WDNAME:WORD		; WINDOWS/表示名前
	EXTRN	WDTIME:WORD		; WINDOWS/表示時間値
	EXTRN	WDINO:WORD		; WINDOWS/アイテムオフセット
	EXTRN	WDILIST:WORD		; WINDOWS/スタイルリストオフセット
	EXTRN	WDP_VAL:WORD		; WINDOWS/内容表示値
	EXTRN	WDP_UNIT:WORD		; WINDOWS/内容表示単位系
	EXTRN	WD_NONE_CHR:BYTE	; WINDOWS/無効キャラクタ
	EXTRN	WDTXTSEG:WORD		; WINDOWS/表示文字列セグメント
	EXTRN	WDTXTADR:WORD		; WINDOWS/表示文字列アドレス
	EXTRN	WDBTNNUM:WORD		; WINDOWS/選択ボタン番号
	EXTRN	WDBTNPUSH:WORD		; WINDOWS/ボタン押した
	EXTRN	WDMSX:WORD		; WINDOWS/マウスＸ
	EXTRN	WDMSY:WORD		; WINDOWS/マウスＹ
	EXTRN	WDMSL:WORD		; WINDOWS/マウス左ボタン
	EXTRN	WDMSR:WORD		; WINDOWS/マウス右ボタン
	EXTRN	WDPCLM:WORD		; WINDOWS/順序
	EXTRN	WDPLIN:WORD		; WINDOWS/行

	EXTRN	W_COL1:WORD		; WINDOWS/カラー・ハイライト
	EXTRN	W_COL2:WORD		; WINDOWS/カラー・明るい灰
	EXTRN	W_COL3:WORD		; WINDOWS/カラー・暗い灰
	EXTRN	W_COL4:WORD		; WINDOWS/カラー・黒
	EXTRN	W_COL5:WORD		; WINDOWS/カラー・暗い色

	EXTRN	ATMSEG:WORD		; WINDOWS/テキストバッファセグメント
	EXTRN	ATMTBL:WORD		; WINDOWS/表示単語アドレス
	EXTRN	ATMTLN:WORD		; WINDOWS/表示単語長さ
	EXTRN	ATMVAL:WORD		; WINDOWS/表示単語の数値
	EXTRN	ATMMAX:WORD		; WINDOWS/表示単語の数
	EXTRN	ATMDIM:WORD	 	; WINDOWS/表示単語のテーブルサイズ

	EXTRN	STR_BUFF:BYTE		; 文字列バッファ
	EXTRN	STR_VAL_BUFF:BYTE	; 表示値文字列バッファ

DATA	ENDS

;
;	end of "KOSO.INC"
;
