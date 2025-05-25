; "IPLMSG.ASM" PC-9801UV11 make by R.H 1989/12/12
;
;
;	パレットエフェクト
;
; GAME subroutine.

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	FEDIN		; Ｆ・Ｉ（フェードイン）
PUBLIC	FEDOUT		; Ｆ・Ｏ（フェードアウト）
PUBLIC	WHTFLS		; ＷＨＩＴＥ・ＦＬＡＳＨ
PUBLIC	WHTIN		; ＷＨＩＴＥ・ＩＮ
PUBLIC	WHTOUT		; ＷＨＩＴＥ・ＯＵＴ
PUBLIC	COLFLS		; カラー・ＦＬＡＳＨ
PUBLIC	COLFUL		; カラー・ＦＵＬＬ
PUBLIC	BLACK		; ブラックアウト
PUBLIC	WHITE		; ＷＨＩＴＥ
PUBLIC	BRIIN		; 明度５０％からノーマルへ
PUBLIC	BRIOUT		; 明度５０％ダウン
PUBLIC	COLBCK		; 色相反転
PUBLIC	COLRET		; 色相戻し
PUBLIC	FFWHT		; ＷＨＩＴＥ反射感
PUBLIC	PLTOL		; パレット・オーバラップ
PUBLIC	PLTMIX		; パレット・混合
PUBLIC	NORMIN		; ノーマルカラー

PUBLIC	PLTFIS		; Ｆ・Ｉ（フェードイン）／時分割初期
PUBLIC	PLTFOS		; Ｆ・Ｏ（フェードアウト）／時分割初期
PUBLIC	PLTCIS		; カラー・ＩＮ／時分割初期
PUBLIC	PLTOLS		; パレット・オーバラップ／時分割初期
PUBLIC	PLTOLT		; パレット・オーバラップ／時分割処理

PUBLIC	PLTINTSW	; パレット・割込み処理スイッチ
PUBLIC	PLTINTSPD	; パレット・割込み処理スピード
PUBLIC	PLTINTWT	; パレット・割込み処理終了待ち
PUBLIC	INTPLT		; far:パレット処理割込み(IPLMSG.ASM)

EXTRN	DKCMMD:NEAR	; メッセージ突入モード
;*;DKCMMD:RET		; メッセージ突入モード


EXTRN	PLSET:NEAR	; パレットセット
EXTRN	PLGET:NEAR	; パレットＧＥＴ
EXTRN	PLPUT:NEAR	; パレットＰＵＴ
EXTRN	PLPSET:NEAR	; パレット編集セット

EXTRN	TMWAIT:NEAR	; time wait.
EXTRN	TMVSRT:NEAR	; V-SYNC timer start.
EXTRN	TMVEND:NEAR	; V-SYNC timer end.
EXTRN	TMVWAT:NEAR	; V-SYNC timer wait.
EXTRN	TMVSET:NEAR	; V-SYNC timer set.
EXTRN	TMVCHK:NEAR	; V-SYNC timer check.
EXTRN	TMVEWT:NEAR	; V-SYNC timer end wait.
EXTRN	TMVCLR:NEAR	; V-SYNC timer clear.
EXTRN	TMVSTP:NEAR	; V-SYNC timer stop.
EXTRN	TMVCNT:NEAR	; V-SYNC timer cont.
EXTRN	TMVSAV:NEAR	; V-SYNC timer value save.
EXTRN	TMVLOD:NEAR	; V-SYNC timer value load.

EXTRN	TMVPLT:NEAR	; V-SYNC timer pallet program call.

EXTRN	SETCLR:NEAR	; color set.
EXTRN	CLRSET:NEAR	; color register set.


WAIT_TIMER	EQU	2	; カラー変化時間間隔初期値
COLOR_STEP	EQU	5	; カラー変化ステップ初期値
COLOR_LOOP_CNT	EQU	100/5	; カラー変化ループカウント初期値
COMN_PLT	EQU	3	; 作業用パレット





;	Ｆ・Ｉ（フェードイン）

FEDIN	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,0		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	CX,IPLMLP		; カラー変化ループカウント
FEDIN4:					;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	MOV	AX,IPLMDV		; カラー変化ステップ
	ADD	CRXBRI,AX		; 明度倍率（０ー１００）
;*NON*;	ADD	CRXCNS,AX		; 彩度倍率（０ー１００）
	LOOP	FEDIN4

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
FEDIN	ENDP


;	Ｆ・Ｏ（フェードアウト）

FEDOUT	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	CX,IPLMLP		; カラー変化ループカウント
FEDOUT4:				;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	MOV	AX,IPLMDV		; カラー変化ステップ
	SUB	CRXBRI,AX		; 明度倍率（０ー１００）
;*NON*;	SUB	CRXCNS,AX		; 彩度倍率（０ー１００）
	LOOP	FEDOUT4

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	MOV	DX,0			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
FEDOUT	ENDP


;	ＷＨＩＴＥ・ＦＬＡＳＨ

WHTFLS	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CX,3
WHTFLS2:
	PUSH	CX

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	PUSH	CRXVEW			; 色相回転（０ー３６０）
	PUSH	CRXCNS			; 彩度倍率（０ー１００）
	PUSH	CRXBRI			; 明度倍率（０ー１００）
	PUSH	CRXWHI			; ホワイトレベル（０ー１００）

	CALL	DSPWAIT			;
	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,10		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,60		; ホワイトレベル（０ー１００）
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	CALL	DSPWAIT			;
	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,30		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	POP	CRXWHI			; ホワイトレベル（０ー１００）
	POP	CRXBRI			; 明度倍率（０ー１００）
	POP	CRXCNS			; 彩度倍率（０ー１００）
	POP	CRXVEW			; 色相回転（０ー３６０）
	POP	CX
	LOOP	WHTFLS2

	MOV	BX,0			;
	CALL	PLSET			; パレットセット

	MOV	DX,0			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
WHTFLS	ENDP



;	ＷＨＩＴＥ・ＩＮ

WHTIN	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,0		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,100		; ホワイトレベル（０ー１００）
	MOV	CX,IPLMLP		; カラー変化ループカウント
WHTIN4:					;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	MOV	AX,IPLMDV		; カラー変化ステップ
	ADD	CRXCNS,AX		; 彩度倍率（０ー１００）
	SUB	CRXWHI,AX		; ホワイトレベル（０ー１００）
	LOOP	WHTIN4

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
WHTIN	ENDP


;	ＷＨＩＴＥ・ＯＵＴ

WHTOUT	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	CX,IPLMLP		; カラー変化ループカウント
WHTOUT4:				;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	MOV	AX,IPLMDV		; カラー変化ステップ
	SUB	CRXCNS,AX		; 彩度倍率（０ー１００）
	ADD	CRXWHI,AX		; ホワイトレベル（０ー１００）
	LOOP	WHTOUT4

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	MOV	DX,0			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
WHTOUT	ENDP


;	カラー・ＦＬＡＳＨ
;	-I- CLRVEW : color.
;	    CLRCNS : contrast.
;	    CLRBRI : brightness.

COLFLS	PROC	NEAR
	CALL	COLFUL			; カラー・ＦＵＬＬ

	CALL	DSPWAIT			;
	CALL	DSPWAIT			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLSET			; パレットセット

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
COLFLS	ENDP


;	カラー・ＦＵＬＬ
;	-I- CLRVEW : color.
;	    CLRCNS : contrast.
;	    CLRBRI : brightness.

COLFUL	PROC	NEAR
	MOV	CLRCDE,0		; color code.
	MOV	CX,16			;
COLFUL_LOOP:
	PUSH	CX			;
	CALL	SETCLR			; color set.
	INC	CLRCDE			; color code.
	POP	CX			;
	LOOP	COLFUL_LOOP		;

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
COLFUL	ENDP




;	ブラックアウト

BLACK	PROC	NEAR
	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,0		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	MOV	DX,0			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
BLACK	ENDP


;	ＷＨＩＴＥアウト

WHITE	PROC	NEAR
	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,100		; ホワイトレベル（０ー１００）
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	MOV	DX,0			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
WHITE	ENDP



;	明度５０％からノーマルへ

BRIIN	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,50		; 彩度倍率（０ー１００）
	MOV	CRXBRI,50		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	CX,IPLMLP		; カラー変化ループカウント
	SHR	CX,1			; 50%
BRIIN4:					;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	MOV	AX,IPLMDV		; カラー変化ステップ
	ADD	CRXBRI,AX		; 明度倍率（０ー１００）
	ADD	CRXCNS,AX		; 彩度倍率（０ー１００）
	LOOP	BRIIN4

;*NON*;	MOV	AX,CRXVEW_B		; 色相回転（０ー３６０）
;*NON*;	MOV	CRXVEW,AX
;*NON*;	MOV	AX,CRXCNS_B		; 彩度倍率（０ー１００）
;*NON*;	MOV	CRXCNS,AX
;*NON*;	MOV	AX,CRXBRI_B		; 明度倍率（０ー１００）
;*NON*;	MOV	CRXBRI,AX
;*NON*;	MOV	AX,CRXWHI_B		; ホワイトレベル（０ー１００）
;*NON*;	MOV	CRXWHI,AX

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	RET
BRIIN	ENDP


;	明度５０％ダウン

BRIOUT	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

;*NON*;	MOV	AX,CRXVEW
;*NON*;	MOV	CRXVEW_B,AX		; 色相回転（０ー３６０）
;*NON*;	MOV	AX,CRXCNS
;*NON*;	MOV	CRXCNS_B,AX		; 彩度倍率（０ー１００）
;*NON*;	MOV	AX,CRXBRI
;*NON*;	MOV	CRXBRI_B,AX		; 明度倍率（０ー１００）
;*NON*;	MOV	AX,CRXWHI
;*NON*;	MOV	CRXWHI_B,AX		; ホワイトレベル（０ー１００）

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	CX,IPLMLP		; カラー変化ループカウント
	SHR	CX,1			; 50%
BRIOUT4:				;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	MOV	AX,IPLMDV		; カラー変化ステップ
	SUB	CRXBRI,AX		; 明度倍率（０ー１００）
	SUB	CRXCNS,AX		; 彩度倍率（０ー１００）
	LOOP	BRIOUT4

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	RET
BRIOUT	ENDP


;	色相反転

COLBCK	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	CX,180/20		;
COLBCK4:				;
	PUSH	CX			;
	ADD	CRXVEW,10*2		; 色相回転（０ー３６０）
	ADD	CRXWHI,2*2		; ホワイトレベル（０ー１００）
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	LOOP	COLBCK4

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	RET
COLBCK	ENDP


;	色相戻し

COLRET	PROC	NEAR
	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	CRXVEW,180		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,36		; ホワイトレベル（０ー１００）
	MOV	CX,180/20		;
COLRET4:				;
	PUSH	CX			;
	SUB	CRXVEW,10*2		; 色相回転（０ー３６０）
	SUB	CRXWHI,2*2		; ホワイトレベル（０ー１００）
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	LOOP	COLRET4

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLSET			; パレットセット

	RET
COLRET	ENDP





;	ＷＨＩＴＥ反射感

FFWHT	PROC	NEAR
	CALL	TMVCNT			; V-SYNC timer cont.

	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,0		; ホワイトレベル（０ー１００）
	MOV	CX,3			;
FFWHT4:					;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	ADD	CRXWHI,5*4		; ホワイトレベル（０ー１００）
	LOOP	FFWHT4

	MOV	CX,3			;
FFWHT5:					;
	PUSH	CX			;
	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット
	POP	CX			;
	SUB	CRXWHI,5*4		; ホワイトレベル（０ー１００）
	LOOP	FFWHT5

	CALL	DSPWAIT			;
	MOV	BX,0			;
	CALL	PLPSET			; パレット編集セット

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード

	RET
FFWHT	ENDP





;	パレット・オーバラップ
;	-I- AX : オーバラップ開始パレットテーブル番号
;	    BX : オーバラップ終了パレットテーブル番号


PLTOL	PROC	NEAR
	MOV	OLCOLS,AX	; オーバラップ開始パレットテーブル番号
	MOV	OLCOLE,BX	; オーバラップ終了パレットテーブル番号

	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	BX,OLCOLS	; オーバラップ開始パレットテーブル番号
	CALL	PLSET		; パレットセット

	MOV	BX,OLCOLS	; パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLTCPY		; ＧＥＴパレットを内部テーブルへセット
	CALL	PLTCPY_FLOT	; ６４乗の固定小数点テーブルへセット

	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLTOL_DEV	; パレットオーバ・ラップのステップ計算

	MOV	CX,STPDEV	; 分割数
PLTOL_LOOP:
	PUSH	CX
	CALL	DSPWAIT

	CALL	PLT_MUL		; パレットステップ計算

	MOV	BX,COMN_PLT	; 作業用パレット
	CALL	PLPUT		; パレットＰＵＴ

	MOV	BX,COMN_PLT	; 作業用パレット
	CALL	PLSET		; パレットセット

	POP	CX
	DEC	CX
	JZ	PLTOL_LOOP_END
	JMP	PLTOL_LOOP
PLTOL_LOOP_END:

	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLSET		; パレットセット

	RET
PLTOL	ENDP


;	パレットステップ計算

PLT_MUL	PROC	NEAR

	MOV	SI,0
	MOV	CX,16
PLT_MUL_LOOP_PR:
	MOV	AX,CRTVEW_FLOT[SI]	; 色相回転（０ー３６０）
	ADD	AX,CRVEW_STEP[SI]	; 色相回転（０ー３６０）
	MOV	CRTVEW_FLOT[SI],AX	; 色相回転（０ー３６０）

	MOV	AX,CRTCNS_FLOT[SI]	; 彩度倍率（０ー１００）
	ADD	AX,CRCNS_STEP[SI]	; 彩度倍率（０ー１００）
	MOV	CRTCNS_FLOT[SI],AX	; 彩度倍率（０ー１００）

	MOV	AX,CRTBRI_FLOT[SI]	; 明度倍率（０ー１００）
	ADD	AX,CRBRI_STEP[SI]	; 明度倍率（０ー１００）
	MOV	CRTBRI_FLOT[SI],AX	; 明度倍率（０ー１００）


	MOV	AX,CRTVEW_FLOT[SI]	; 色相回転（０ー３６０）
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			; florting point64 -> int*2
	MOV	CRTVEW[SI],AX		; 色相回転（０ー３６０）

	MOV	AX,CRTCNS_FLOT[SI]	; 彩度倍率（０ー１００）
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			; florting point64 -> int*2
	MOV	CRTCNS[SI],AX	; 彩度倍率（０ー１００）

	MOV	AX,CRTBRI_FLOT[SI]	; 明度倍率（０ー１００）
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			;
	SHR	AX,1			; florting point64 -> int*2
	MOV	CRTBRI[SI],AX	; 明度倍率（０ー１００）

	INC	SI
	INC	SI
	DEC	CX
	JZ	PLT_MUL_LOOP_PR_END
	JMP	PLT_MUL_LOOP_PR
PLT_MUL_LOOP_PR_END:
	RET
PLT_MUL	ENDP


;	Ｆ・Ｉ（フェードイン）／時分割初期

PLTFIS	PROC	NEAR
	MOV	OLCOLS,1	; オーバラップ開始パレットテーブル番号
	MOV	OLCOLE,0	; オーバラップ終了パレットテーブル番号

	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	BX,OLCOLE	; パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLT0BR		; 明度を０にする

	MOV	BX,OLCOLS	; パレットテーブル番号
	CALL	PLPUT		; パレットＰＵＴ

	CALL	PLTCPY		; ＧＥＴパレットを内部テーブルへセット
	CALL	PLTCPY_FLOT	; ６４乗の固定小数点テーブルへセット

	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLTOL_DEV	; パレットオーバ・ラップのステップ計算

	MOV	CX,STPDEV	; 分割数
	MOV	STPTIM,CX	; 時間ポインタ
	MOV	STPOFF,0	; 時間処理終了フラグ

	MOV	INT_V_MD_FL,1	; Ｖ割込み処理後のメッセージ突入モード
				; 0=何もしない, 1=５０％ダウン

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード
	RET
PLTFIS	ENDP



;	Ｆ・Ｏ（フェードアウト）／時分割初期

PLTFOS	PROC	NEAR
	MOV	OLCOLS,1	; オーバラップ開始パレットテーブル番号
	MOV	OLCOLE,0	; オーバラップ終了パレットテーブル番号

	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	BX,OLCOLE	; パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	MOV	BX,OLCOLS	; パレットテーブル番号
	CALL	PLPUT		; パレットＰＵＴ

	CALL	PLTCPY		; ＧＥＴパレットを内部テーブルへセット
	CALL	PLTCPY_FLOT	; ６４乗の固定小数点テーブルへセット

	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLT0BR		; 明度を０にする

	MOV	BX,OLCOLE	; パレットテーブル番号
	CALL	PLPUT		; パレットＰＵＴ

	CALL	PLTOL_DEV	; パレットオーバ・ラップのステップ計算

	MOV	CX,STPDEV	; 分割数
	MOV	STPTIM,CX	; 時間ポインタ
	MOV	STPOFF,0	; 時間処理終了フラグ

	MOV	INT_V_MD_FL,0	; Ｖ割込み処理後のメッセージ突入モード
				; 0=何もしない, 1=５０％ダウン

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード
	RET
PLTFOS	ENDP


;	カラー・ＩＮ／時分割初期
;	-I- CLRVEW : color.
;	    CLRCNS : contrast.
;	    CLRBRI : brightness.

PLTCIS	PROC	NEAR
	MOV	OLCOLS,1	; オーバラップ開始パレットテーブル番号
	MOV	OLCOLE,0	; オーバラップ終了パレットテーブル番号

	CALL	TMVCNT		; V-SYNC timer cont.

	CALL	PLTCLR		; 全パレットを指定カラーにする

	MOV	BX,OLCOLS	; パレットテーブル番号
	CALL	PLPUT		; パレットＰＵＴ

	MOV	BX,OLCOLS	; オーバラップ開始パレットテーブル番号
	CALL	PLSET		; パレットセット

	CALL	PLTCPY		; ＧＥＴパレットを内部テーブルへセット
	CALL	PLTCPY_FLOT	; ６４乗の固定小数点テーブルへセット

	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLTOL_DEV	; パレットオーバ・ラップのステップ計算

	MOV	CX,STPDEV	; 分割数
	MOV	STPTIM,CX	; 時間ポインタ
	MOV	STPOFF,0	; 時間処理終了フラグ

	MOV	INT_V_MD_FL,1	; Ｖ割込み処理後のメッセージ突入モード
				; 0=何もしない, 1=５０％ダウン

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード
	RET
PLTCIS	ENDP


;	パレット・オーバラップ／時分割初期
;	-I- AX : オーバラップ開始パレットテーブル番号
;	    BX : オーバラップ終了パレットテーブル番号

PLTOLS	PROC	NEAR
	MOV	OLCOLS,AX	; オーバラップ開始パレットテーブル番号
	MOV	OLCOLE,BX	; オーバラップ終了パレットテーブル番号

	CALL	TMVCNT		; V-SYNC timer cont.

	MOV	BX,OLCOLS	; オーバラップ開始パレットテーブル番号
	CALL	PLSET		; パレットセット

	MOV	BX,OLCOLS	; パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLTCPY		; ＧＥＴパレットを内部テーブルへセット
	CALL	PLTCPY_FLOT	; ６４乗の固定小数点テーブルへセット

	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLTOL_DEV	; パレットオーバ・ラップのステップ計算

	MOV	CX,STPDEV	; 分割数
	MOV	STPTIM,CX	; 時間ポインタ
	MOV	STPOFF,0	; 時間処理終了フラグ

	MOV	INT_V_MD_FL,1	; Ｖ割込み処理後のメッセージ突入モード
				; 0=何もしない, 1=５０％ダウン

	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード
	RET
PLTOLS	ENDP



;	パレット・オーバラップ／時分割処理
;	-I/O- STPTIM : 時間ポインタ
;	      STPOFF : 時間処理終了フラグ

PLTOLT	PROC	NEAR
	CMP	STPOFF,0	; 時間処理終了フラグ
	JE	PLTOLT1
	RET
PLTOLT1:
	CMP	STPTIM,0	; 時間ポインタ
	JNE	PLTOLT_LOOP	;
	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLSET		; パレットセット
	MOV	STPOFF,1	; 時間処理終了フラグ
	RET

PLTOLT_LOOP:
	CALL	PLT_MUL		; パレットステップ計算

	MOV	BX,COMN_PLT	; 作業用パレット
	CALL	PLPUT		; パレットＰＵＴ

	MOV	BX,COMN_PLT	; 作業用パレット
	CALL	PLSET		; パレットセット

	DEC	STPTIM		; 時間ポインタ

	RET
PLTOLT	ENDP



;	パレット・混合
;	-I- AX : 混合パレットテーブル番号
;	    BX : 混合パレットテーブル番号
;	    DX : セットパレットテーブル
;	    CX : 比率（０－２０）

PLTMIX	PROC	NEAR
	MOV	OLCOLS,AX	; オーバラップ開始パレットテーブル番号
	MOV	OLCOLE,BX	; オーバラップ終了パレットテーブル番号
	MOV	STCOL,DX	; セットパレットテーブル
	MOV	PROPRT,CX	; 比率（０－２０）

	MOV	BX,OLCOLS	; パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CMP	PROPRT,0	; 比率（０－２０）
	JE	PLTMIX_LOOP_END	;

	CALL	PLTCPY		; ＧＥＴパレットを内部テーブルへセット
	CALL	PLTCPY_FLOT	; ６４乗の固定小数点テーブルへセット

	MOV	BX,OLCOLE	; オーバラップ終了パレットテーブル番号
	CALL	PLGET		; パレットＧＥＴ

	CALL	PLTOL_DEV	; パレットオーバ・ラップのステップ計算

PLTMIX_LOOP:
	CALL	PLT_MUL		; パレットステップ計算

	DEC	PROPRT		; 比率（０－２０）
	JNZ	PLTMIX_LOOP	;
PLTMIX_LOOP_END:

	MOV	BX,STCOL	; セットパレットテーブル
	CALL	PLPUT		; パレットＰＵＴ

	RET
PLTMIX	ENDP


;	ノーマルカラー

NORMIN	PROC	NEAR
	MOV	BX,0			; パレット
	CALL	PLSET			; パレットセット
	MOV	DX,1			; 0=何もしない, 1=５０％ダウン
	CALL	DKCMMD			; メッセージ突入モード
	RET
NORMIN	ENDP


;	パレットオーバ・ラップのステップ計算
;	-I- CRTVEW[0-15]:word : 色相回転（０ー３６０）変更後
;	    CRTCNS[0-15]:word : 彩度倍率（０ー１００）
;	    CRTBRI[0-15]:word : 明度倍率（０ー１００）
;	    CRTVEWN[0-15]:word: 色相回転（０ー３６０）変更前
;	    CRTCNSN[0-15]:word: 彩度倍率（０ー１００）
;	    CRTBRIN[0-15]:word: 明度倍率（０ー１００）
;	    STPDEV            : 分割数
;	-O- CRVEW_STEP[0-15]:w: 色相回転（０ー３６０）
;	    CRCNS_STEP[0-15]:w: 彩度倍率（０ー１００）
;	    CRBRI_STEP[0-15]:w: 明度倍率（０ー１００）
;	    ＳＴＥＰは６４乗の固定小数点

PLTOL_DEV	PROC	NEAR
	MOV	SI,0
	MOV	CX,16
PLTOL_DEV_VEW1:
	MOV	AX,DS:CRTVEW[SI]	; 色相回転（０ー３６０）
	SUB	AX,DS:CRTVEWN[SI]	; 色相回転（０ー３６０）
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;*64 floting point
	CWD				;
	MOV	BX,STPDEV		; 分割数
	IDIV	BX			;
	MOV	DS:CRVEW_STEP[SI],AX	; 色相回転（０ー３６０）
	INC	SI
	INC	SI
	LOOP	PLTOL_DEV_VEW1		;

	MOV	SI,0
	MOV	CX,16
PLTOL_DEV_CNS1:
	MOV	AX,DS:CRTCNS[SI]	; 彩度倍率（０ー１００）
	SUB	AX,DS:CRTCNSN[SI]	; 彩度倍率（０ー１００）
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;*64 floting point
	CWD				;
	MOV	BX,STPDEV		; 分割数
	IDIV	BX			;
	MOV	DS:CRCNS_STEP[SI],AX	; 彩度倍率（０ー１００）
	INC	SI
	INC	SI
	LOOP	PLTOL_DEV_CNS1		;

	MOV	SI,0
	MOV	CX,16
PLTOL_DEV_BRI1:
	MOV	AX,DS:CRTBRI[SI]	; 明度倍率（０ー１００）
	SUB	AX,DS:CRTBRIN[SI]	; 明度倍率（０ー１００）
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;*64 floting point
	CWD				;
	MOV	BX,STPDEV		; 分割数
	IDIV	BX			;
	MOV	DS:CRBRI_STEP[SI],AX	; 明度倍率（０ー１００）
	INC	SI
	INC	SI
	LOOP	PLTOL_DEV_BRI1		;

	RET
PLTOL_DEV	ENDP


;	明度を０にする
;	-I/O- CRTVEW[0-15]:word : 色相回転（０ー３６０）
;	      CRTCNS[0-15]:word : 彩度倍率（０ー１００）
;	      CRTBRI[0-15]:word : 明度倍率（０ー１００）
;	      CRTCDE[0-15]:word : ハードパレットテーブル

PLT0BR	PROC	NEAR
	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET CRTBRI	; 明度倍率（０ー１００）
	MOV	CX,16
	MOV	AX,0
	REP	STOSW

	RET
PLT0BR	ENDP


;	全パレットを指定カラーにする
;	-I- CLRVEW : color.
;	    CLRCNS : contrast.
;	    CLRBRI : brightness.
;	-O- CRTVEW[0-15]:word : 色相回転（０ー３６０）
;	    CRTCNS[0-15]:word : 彩度倍率（０ー１００）
;	    CRTBRI[0-15]:word : 明度倍率（０ー１００）
;	    CRTCDE[0-15]:word : ハードパレットテーブル

PLTCLR	PROC	NEAR

	PUSH	CLRVEW		; color.
	PUSH	CLRCNS		; contrast.
	PUSH	CLRBRI		; brightness.
	MOV	BX,0		;
	CALL	PLGET		; パレットＧＥＴ
	POP	CLRBRI		; brightness.
	POP	CLRCNS		; contrast.
	POP	CLRVEW		; color.

	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET CRTVEW	; 色相回転（０ー３６０）
	MOV	CX,16
	MOV	AX,CLRVEW		; color.
	REP	STOSW

	MOV	DI,OFFSET CRTCNS	; 彩度倍率（０ー１００）
	MOV	CX,16
	MOV	AX,CLRCNS		; contrast.
	REP	STOSW

	MOV	DI,OFFSET CRTBRI	; 明度倍率（０ー１００）
	MOV	CX,16
	MOV	AX,CLRBRI		; brightness.
	REP	STOSW

	RET
PLTCLR	ENDP



;	ＧＥＴパレットを内部テーブルへセット

PLTCPY	PROC	NEAR
	MOV	AX,DS
	MOV	ES,AX

	MOV	SI,OFFSET CRTVEW	; 色相回転（０ー３６０）
	MOV	DI,OFFSET CRTVEWN	; 色相回転（０ー３６０）
	MOV	CX,16
	REP	MOVSW

	MOV	SI,OFFSET CRTCNS	; 彩度倍率（０ー１００）
	MOV	DI,OFFSET CRTCNSN	; 彩度倍率（０ー１００）
	MOV	CX,16
	REP	MOVSW

	MOV	SI,OFFSET CRTBRI	; 明度倍率（０ー１００）
	MOV	DI,OFFSET CRTBRIN	; 明度倍率（０ー１００）
	MOV	CX,16
	REP	MOVSW

	MOV	SI,OFFSET CRTCDE	; ハードパレットテーブル
	MOV	DI,OFFSET CRTCDEN	; ハードパレットテーブル
	MOV	CX,16
	REP	MOVSW

	RET
PLTCPY	ENDP



;	ＧＥＴパレットを６４乗の固定小数点テーブルへセット

PLTCPY_FLOT	PROC	NEAR
	MOV	AX,DS
	MOV	ES,AX

	MOV	SI,OFFSET CRTVEW	; 色相回転（０ー３６０）
	MOV	DI,OFFSET CRTVEW_FLOT	; 色相回転（０ー３６０）
	MOV	CX,16
PLTCPY_FLOT1:
	LODSW
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;*64 floting point
	STOSW
	LOOP	PLTCPY_FLOT1


	MOV	SI,OFFSET CRTCNS	; 彩度倍率（０ー１００）
	MOV	DI,OFFSET CRTCNS_FLOT	; 彩度倍率（０ー１００）
	MOV	CX,16
PLTCPY_FLOT2:
	LODSW
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;*64 floting point
	STOSW
	LOOP	PLTCPY_FLOT2


	MOV	SI,OFFSET CRTBRI	; 明度倍率（０ー１００）
	MOV	DI,OFFSET CRTBRI_FLOT	; 明度倍率（０ー１００）
	MOV	CX,16
PLTCPY_FLOT3:
	LODSW
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			;*64 floting point
	STOSW
	LOOP	PLTCPY_FLOT3

	RET
PLTCPY_FLOT	ENDP



;	表示用ウェイト

DSPWAIT	PROC	NEAR
	MOV	AX,IPLMSW	; パレットエフェクト単位時間(VSYNC)
	CALL	TMVCLR		; V-SYNC timer clear.
	CALL	TMVWAT		; V-SYNC timer wait.
	RET
DSPWAIT	ENDP


;	パレット・割込み処理スイッチ

PLTINTSW	PROC	NEAR
	MOV	INT_V_COUNT,0	; Ｖ割込み処理のカウンタ
	MOV	AX,1		; 割込みスイッチ 0=OFF,1=ON
	CALL	TMVPLT		; V-SYNC timer pallet program call.

					; 0=何もしない, 1=５０％ダウン
	MOV	DX,INT_V_MD_FL		; Ｖ割込み処理後のメッセージ突入モード
	CALL	DKCMMD			; メッセージ突入モード
	RET
PLTINTSW	ENDP


;	パレット・割込み処理スピード
;	-I- AX : Ｖ割込み処理の指定インターバル

PLTINTSPD	PROC	NEAR
	MOV	INT_V_INTERVAL,AX	; Ｖ割込み処理の指定インターバル
	AND	INT_V_INTERVAL,111B	; Ｖ割込み処理の指定インターバル
	RET
PLTINTSPD	ENDP


;	パレット・割込み処理終了待ち

PLTINTWT	PROC	NEAR
PLTINTWT_LOOP:
	CMP	STPOFF,1		; 時間処理終了フラグ
	JNE	PLTINTWT_LOOP		;

					; 0=何もしない, 1=５０％ダウン
	MOV	DX,INT_V_MD_FL		; Ｖ割込み処理後のメッセージ突入モード
	CALL	DKCMMD			; メッセージ突入モード

	RET
PLTINTWT	ENDP


;	far:パレット処理割込み(IPLMSG.ASM)

INTPLT	PROC	FAR
	MOV	AX,SEG DATA
	MOV	DS,AX

	INC	INT_V_COUNT		; Ｖ割込み処理のカウンタ
	MOV	AX,INT_V_COUNT		; Ｖ割込み処理の指定インターバル
	CMP	AX,INT_V_INTERVAL	; Ｖ割込み処理の指定インターバル
	JB	INTPLT_EXIT

	MOV	INT_V_COUNT,0		; Ｖ割込み処理のカウンタ

	CALL	PLTOLT			; パレット・オーバラップ／時分割処理
	CMP	STPOFF,1		; 時間処理終了フラグ
	JNE	INTPLT_EXIT

	MOV	AX,0			; 割込みスイッチ 0=OFF,1=ON
	CALL	TMVPLT			; V-SYNC timer pallet program call.
INTPLT_EXIT:
	RET
INTPLT	ENDP

CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	IPLMSW			; パレットエフェクト単位時間(VSYNC)
PUBLIC	IPLMDV			; カラー変化ステップ
PUBLIC	IPLMLP			; カラー変化ループカウント

EXTRN	CRXVEW:WORD		; 色相回転（０ー３６０）
EXTRN	CRXCNS:WORD		; 彩度倍率（０ー１００）
EXTRN	CRXBRI:WORD		; 明度倍率（０ー１００）
EXTRN	CRXWHI:WORD		; ホワイトレベル（０ー１００）

EXTRN	CRTVEW:WORD		; 色相回転（０ー３６０）
EXTRN	CRTCNS:WORD		; 彩度倍率（０ー１００）
EXTRN	CRTBRI:WORD		; 明度倍率（０ー１００）
EXTRN	CRTCDE:WORD		; ハードパレットテーブル
EXTRN	CRTSKP:WORD		; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)

EXTRN	CLRCDE:WORD		; color code.
EXTRN	CLRVEW:WORD		; color view.
EXTRN	CLRCNS:WORD		; contrast.
EXTRN	CLRBRI:WORD		; brightness.

IPLMSW	DW	WAIT_TIMER	; パレットエフェクト単位時間(VSYNC)
IPLMDV	DW	COLOR_STEP	; カラー変化ステップ
IPLMLP	DW	COLOR_LOOP_CNT	; カラー変化ループカウント


CRTVEWN	DW	16 DUP (0)	; 色相回転（０ー３６０）
CRTCNSN	DW	16 DUP (0)	; 彩度倍率（０ー１００）
CRTBRIN	DW	16 DUP (0)	; 明度倍率（０ー１００）
CRTCDEN	DW	16 DUP (0)	; ハードパレットテーブル

CRXVEW_B	DW	0	; 色相回転（０ー３６０）
CRXCNS_B	DW	0	; 彩度倍率（０ー１００）
CRXBRI_B	DW	0	; 明度倍率（０ー１００）
CRXWHI_B	DW	0	; ホワイトレベル（０ー１００）

OLCOLS		DW	0	; オーバラップ開始パレットテーブル番号
OLCOLE		DW	0	; オーバラップ終了パレットテーブル番号
STCOL		DW	0	; セットパレットテーブル

STPDEV		DW	20	; 分割数

STPTIM		DW	0	; 時間ポインタ

STPOFF		DW	1	; 時間処理終了フラグ

PROPRT		DW	0	; 比率（０－２０）

CRVEW_STEP	DW	16 DUP (0)	; 色相回転（０ー３６０）
CRCNS_STEP	DW	16 DUP (0)	; 彩度倍率（０ー１００）
CRBRI_STEP	DW	16 DUP (0)	; 明度倍率（０ー１００）

CRTVEW_FLOT	DW	16 DUP (0)	; 色相回転（０ー３６０）
CRTCNS_FLOT	DW	16 DUP (0)	; 彩度倍率（０ー１００）
CRTBRI_FLOT	DW	16 DUP (0)	; 明度倍率（０ー１００）

INT_V_COUNT	DW	0		; Ｖ割込み処理のカウンタ
INT_V_INTERVAL	DW	1		; Ｖ割込み処理の指定インターバル
INT_V_MD_FL	DW	0		; Ｖ割込み処理後のメッセージ突入モード
					; 0=何もしない, 1=５０％ダウン

DATA	ENDS


;*DBG*;
;*DBG*;	EXTRN	MSCWAT:NEAR	; カーソルボタンＯＦＦ待ち
;*DBG*;	CALL	MSCWAT
;*DBG*;	EXTRN	MSCMOV:NEAR	; カーソル移動
;*DBG*;L110:
;*DBG*;	CALL	MSCMOV
;*DBG*;	CMP	DH,0
;*DBG*;	JNZ	L110
;*DBG*;


	END
;
;	end of "IPLMSG.ASM"
;
