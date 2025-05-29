; "R_LOADS.ASM" PC-9801UV11 make by R.H 1991/03/11
;
;
;	「子育て」
;
;	ロード＆セーブ
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC

OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味

ARAWDX1		EQU	10	; エリア左上座標Ｘ
ARAWDY1		EQU	200	; エリア左上座標Ｙ
ARAWDX2		EQU	60	; エリアサイズＸ
ARAWDY2		EQU	200	; エリアサイズＹ

CODE	SEGMENT	PUBLIC	'CODE'
CODE	ENDS
DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS
R_SEG2	SEGMENT	PUBLIC	'R_SEG2'		; コード
R_SEG2	ENDS

; ****************************************************
;	Ｒ＿ＳＥＧ２　から　ＣＯＤＥ　へ　ＣＡＬＬ
; ****************************************************

CALLC	MACRO	SUB1
	LOCAL	L1,L2
	JMP	L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:	CALL	L2	
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２セグメントからＣＯＤＥセグメントへ
; ****************************************************

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

; ****************************************************
;	ＣＯＤＥセグメントからＲ＿ＳＥＧ２セグメントへ
; ****************************************************

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:
	ENDM

; ****************************************************
;	ＰＲＩＮＴＸ	＜文字列＞
;	文字列データのウインドウ表示
; ****************************************************

PRINTX	MACRO	STRING
	LOCAL	L1
R_SEG3	SEGMENT	PUBLIC	'R_SEG3'	; テキスト
L1	DB	STRING,0
R_SEG3	ENDS
	MOV	MESS_ADRS,OFFSET L1	; メッセージアドレス
	EXTRN	MESSAGE_PRINT:NEAR	; メッセージ表示
	CALL	MESSAGE_PRINT		; メッセージ表示
	ENDM

; ****************************************************
;	ＷＳＥＬＥＣＴ	＜指定文字列＞
;	SELECT	"話す,渡す,行く"
;	結果は WIDSNM （ユーザ選択番号）に反映される
;	             : =FFFFH : 指定なし
; ****************************************************

WSELECT	MACRO	SSSS
	LOCAL	L1,L2
	JMP	L2
DATA	SEGMENT	PUBLIC	'DATA'
	EXTRN	WIDSNM:WORD		; セレクト・ウインドウ／ユーザ選択番号
L1	DB	SSSS,0
DATA	ENDS
L2:
	MOV	AX,DS			; テキストバッファセグメント
	MOV	ES,AX			;
	MOV	BX,OFFSET L1		; 表示単語アドレス
	CALL	WWIDSLC2		; セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	ENDM


MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM



CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_LOADIN		; スタート時ロード
PUBLIC	R_LOADS			; ロード＆セーブ

PUBLIC	R_LOAD_MUSYA_LOAD	; 武者プロセスの起動
PUBLIC	R_LOAD_MUSYA_CALL	; 武者プロセスの呼出し

EXTRN	DKC_HD:NEAR		; ディスクチェンジ・ハードディスクチェック

; ****************************************************
;	スタート時ロード
;	-O- AX          : 0=通常,1=データロード
; ****************************************************

R_LOADIN	PROC	NEAR
	MOV	R_LOAD_NEW,0			; フラグ・データをロード

	MOV	R_LOAD_FUNC,1			; 1=ロード
	CALL	FAR PTR FDTOOLI			;"ＦＤＴＯＯＬ．ＣＯＭ"初期用

	CMP	R_LOAD_NEW,1			; フラグ・データをロード
	JNE	R_LOADIN_EXIT			;

	MOV	BX,1				; 1=ウインドウ・オープン
	CALL	WIDDISK				; WINDOWS/ディスクウインドウ

	MOV	BX,3				; 3=メッセージ／上段
	MOV	SI,OFFSET MSG_LOADCHU		; "ロード中"
	CALL	WIDDISK				; WINDOWS/ディスクウインドウ

R_LOADIN_EXIT:
	MOV	AX,R_LOAD_NEW			; フラグ・データをロード
	RET
R_LOADIN	ENDP


; ****************************************************
;	ロード＆セーブ
;	-I- R_LOAD_FUNC	: ロードセーブ機能 1=ロード,2=セーブ
;	-O- AX          : 0=通常,1=データロード
; ****************************************************

R_LOADS	PROC	NEAR
	MOV	R_LOAD_NEW,0			; フラグ・データをロード

	CMP	R_LDDEMO,33			; (R_LOADS.ASM)デモフラグ
	JE	R_LOADS_EXIT			; 0=通常,33=ランダムセレクト

	PR_TXT	"@データ整理中‥‥‥"

	CALL	FAR PTR FDTOOL			; "ＦＤＴＯＯＬ．ＣＯＭ"
R_LOADS_EXIT:
	MOV	AX,R_LOAD_NEW			; フラグ・データをロード
	RET
R_LOADS	ENDP


; ****************************************************
;	武者プロセスの起動
; ****************************************************

R_LOAD_MUSYA_LOAD	PROC	NEAR
	MOV	MUSYA_FLAG,0			; 武者フラグ0=だめ,1=よい

	CALL	FAR PTR MUSYA_PROC		; "ＭＵＳＹＡ．ＣＯＭ"
	CMP	AX,0				; 0=正常,2=ディスクエラー
	JNE	R_LOAD_MUSYA_LOAD_EXIT		;

	MOV	MUSYA_FLAG,1			; 武者フラグ0=だめ,1=よい
R_LOAD_MUSYA_LOAD_EXIT:
	RET
R_LOAD_MUSYA_LOAD	ENDP


; ****************************************************
;	武者プロセスの呼出し
;	-I- AX,BX,CX : プロセスの呼出し
;	-O- AX,BX,CX : プロセスの戻り値
; ****************************************************

R_LOAD_MUSYA_CALL	PROC	NEAR
	CMP	MUSYA_FLAG,1			; 武者フラグ0=だめ,1=よい
	JNE	R_LOAD_MUSYA_CALL_EXIT		;
	CALL	FAR PTR MUSYA_CALL		; "ＭＵＳＹＡ．ＣＯＭ"のコール
R_LOAD_MUSYA_CALL_EXIT:
	RET
R_LOAD_MUSYA_CALL	ENDP

CODE	ENDS


R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

FDTOOL_COM_INT20H	EQU	0H		; 戻り命令
FDTOOL_COM_CMND		EQU	80H		; コマンドラインオフセット
FDTOOL_COM_SPC		EQU	81H		; ' '
FDTOOL_COM_P		EQU	82H		; 'P'	呼出しのスイッチ
FDTOOL_COM_R		EQU	83H		; 'R'	.
FDTOOL_COM_C		EQU	84H		; 'C'	.
FDTOOL_COM_S		EQU	85H		; 'S'	.
FDTOOL_COM_FDD		EQU	86H		; 'A'	ＦＤドライブ先頭
FDTOOL_COM_OFS		EQU	87H		; '1234'.
FDTOOL_COM_SEG		EQU	8BH		; '6543'.
FDTOOL_COM_PR01		EQU	90H		; パラメータ１
FDTOOL_COM_PR02		EQU	92H		; パラメータ２
FDTOOL_COM_PR03		EQU	94H		; パラメータ３
FDTOOL_COM_END		EQU	0FFH		; デリミタ
CMND_BYTE_CNT		EQU	78H		; コマンドライン長さ

CHR_SPACE		EQU	' '		; space.
DELIM_CHR		EQU	0DH		; デリミタ
RETPROCCESS		EQU	11001011B	; ＦＡＲリターン

RETFAR	MACRO					; ＦＡＲリターン
	DB	11001011B			; RETF
	ENDM

; ****************************************************
;	"ＦＤＴＯＯＬ．ＣＯＭ"
;	-I- R_LOAD_FUNC	: ロードセーブ機能
;			1=ロード,2=セーブ
; ****************************************************

FDTOOL	PROC	FAR
	MOV	DX,SEGPAT1		; パーツバッファ＃１セグメント
	MOV	TOP_SEG,DX		; 先頭セグメントアドレス

	CALL	FDTOOL_LOAD		; "ＦＤＴＯＯＬ．ＣＯＭ"のロード
	CMP	AX,0			; 0=正常,2=ディスクエラー
	JNE	FDTOOL_EXIT		;

CODE_IN
	PR_CLS
	CMP	R_LOAD_FUNC,1		; 1=ロード,2=セーブ
	JE	FDTOOL_3		;
FDTOOL_2:
	PR_TXT	"現在のデータをディスクに@保存します。"
	JMP	FDTOOL_4
FDTOOL_3:
	PR_TXT	"ユーザディスク内のデータ@をロードします。"
	JMP	FDTOOL_4
FDTOOL_4:

CODE_OUT

	CALL	USER_DISK_MAKER		; ユーザディスク操作
FDTOOL_EXIT:
	CALLC	TKRHME			; 台詞ホームポジション
	RET
FDTOOL	ENDP


; ****************************************************
;	"ＭＵＳＹＡ．ＣＯＭ"
;	-O- AX : 0=正常,2=ディスクエラー
; ****************************************************

MUSYA_PROC	PROC	FAR
	MOV	DX,SEGPAT1		; パーツバッファ＃１セグメント
	MOV	TOP_SEG,DX		; 先頭セグメントアドレス

	MOV	SI,OFFSET MUSYA_COM		; "MUSYA.COM"
	MOV	DX,TOP_SEG			; 先頭セグメントアドレス
	MOV	DI,100H				; ＯＲＧ　１００Ｈ
	MOV	CX,MUSYA_COM_LEN		; "MUSYA.COM"のサイズ
	CALLC	DSKLD				; load data.
	CMP	AX,0				; 0:normal,1:error.
	JNE	MUSYA_PROC_DERROR		;

	CALL	PSP_SETUP			; ＰＳＰの準備

	MOV	AX,0				; 0=正常
	RET
MUSYA_PROC_DERROR:
	MOV	AX,2				; 2=ディスクエラー
	RET
MUSYA_PROC	ENDP


; ****************************************************
;	"ＭＵＳＹＡ．ＣＯＭ"のコール
;	-I- BX,CX,DX : プロセスの呼出し
;	-O- BX,CX,DX : プロセスの戻り値
; ****************************************************

MUSYA_CALL	PROC	FAR
	MOV	COM_PARA_BX,BX		; プリメ・プロセスの呼出しＢＸ
	MOV	COM_PARA_CX,CX		; プリメ・プロセスの呼出しＣＸ
	MOV	COM_PARA_DX,DX		; プリメ・プロセスの呼出しＤＸ

	CALL	COM_PROCESS		; 特殊ＣＯＭプロセスの実行

	MOV	COM_PARA_BX,0		; プリメ・プロセスの呼出しＢＸ
	MOV	COM_PARA_CX,0		; プリメ・プロセスの呼出しＣＸ
	MOV	COM_PARA_DX,0		; プリメ・プロセスの呼出しＤＸ

	MOV	BX,COM_RETU_BX		; プリメ・プロセスの戻り値ＢＸ
	MOV	CX,COM_RETU_CX		; プリメ・プロセスの戻り値ＣＸ
	MOV	DX,COM_RETU_DX		; プリメ・プロセスの戻り値ＤＸ
	RET
MUSYA_CALL	ENDP


; ****************************************************
;	"ＦＤＴＯＯＬ．ＣＯＭ"　初期用
;	-I- R_LOAD_FUNC	: ロードセーブ機能
;			1=ロード,2=セーブ
; ****************************************************

FDTOOLI	PROC	FAR
	MOV	DX,SEGPAT1		; パーツバッファ＃１セグメント
	MOV	TOP_SEG,DX		; 先頭セグメントアドレス

	CALL	FDTOOL_LOAD		; "ＦＤＴＯＯＬ．ＣＯＭ"のロード
	CMP	AX,0			; 0=正常,2=ディスクエラー
	JNE	FDTOOLI_EXIT		;

	CALL	USER_DISK_MAKER		; ユーザディスク操作

FDTOOLI_EXIT:
	RET
FDTOOLI	ENDP


; ****************************************************
;	ユーザディスク操作
;	-I- R_LOAD_FUNC	: ロードセーブ機能
;			1=ロード,2=セーブ
; ****************************************************

USER_DISK_MAKER	PROC	NEAR
	MOV	ES,TOP_SEG			; 先頭セグメントアドレス
	CMP	R_LOAD_FUNC,1			; 1=ロード
	JE	USER_DISK_MAKER_LOAD		;
	CMP	R_LOAD_FUNC,2			; 2=セーブ
	JE	USER_DISK_MAKER_SAVE		;
	JMP	USER_DISK_MAKER_EXIT		;
USER_DISK_MAKER_LOAD:
	MOV	BYTE PTR ES:[FDTOOL_COM_PR01],'U'	; パラメータ１
	MOV	BYTE PTR ES:[FDTOOL_COM_PR02],'L'	; パラメータ２
	JMP	USER_DISK_MAKER_EXEC
USER_DISK_MAKER_SAVE:
	MOV	BYTE PTR ES:[FDTOOL_COM_PR01],'U'	; パラメータ１
	MOV	BYTE PTR ES:[FDTOOL_COM_PR02],'S'	; パラメータ２
USER_DISK_MAKER_EXEC:
	CALL	FDTOOL_CALL		; "ＦＤＴＯＯＬ．ＣＯＭ"のコール
USER_DISK_MAKER_EXIT:
	RET
USER_DISK_MAKER	ENDP


;*;; ****************************************************
;*;;	メニュー
;*;; ****************************************************
;*;
;*;FDT_MENU	PROC	NEAR
;*;
;*;FDT_MENU_FORMAT_LOOP:
;*;	WSELECT	"format,2ndform,2ndform-2,USERDISK"
;*;
;*;	CMP	WIDSNM,OFFF			;=FFFFH : 指定なし
;*;	JMPEQ	FDT_MENU_FORMAT_EXIT		;
;*;	
;*;	CMP	WIDSNM,0
;*;	JE	FDT_MENU_FORMAT_FST
;*;	CMP	WIDSNM,1
;*;	JE	FDT_MENU_FORMAT_2ND
;*;	CMP	WIDSNM,2
;*;	JE	FDT_MENU_FORMAT_3RD
;*;	CMP	WIDSNM,3
;*;	JE	FDT_MENU_USTOOL
;*;
;*;	JMP	FDT_MENU_FORMAT_EXIT		;
;*;FDT_MENU_FORMAT_FST:
;*;	MOV	ES,TOP_SEG		; 先頭セグメントアドレス
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR01],'F'	; パラメータ１
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR02],'3'	; パラメータ２
;*;	JMP	FDT_MENU_FORMAT_CMND			;
;*;FDT_MENU_FORMAT_2ND:
;*;	MOV	ES,TOP_SEG		; 先頭セグメントアドレス
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR01],'G'	; パラメータ１
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR02],'3'	; パラメータ２
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR03]   ,'3'	; パラメータ３
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR03][1],'0'	;
;*;	JMP	FDT_MENU_FORMAT_CMND			;
;*;FDT_MENU_FORMAT_3RD:
;*;	MOV	ES,TOP_SEG		; 先頭セグメントアドレス
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR01],'G'	; パラメータ１
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR02],'3'	; パラメータ２
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR03]   ,'2'	; パラメータ３
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR03][1],'6'	;
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR03][2],'0'	;
;*;	JMP	FDT_MENU_FORMAT_CMND			;
;*;FDT_MENU_USTOOL:
;*;	MOV	ES,TOP_SEG		; 先頭セグメントアドレス
;*;	MOV	BYTE PTR ES:[FDTOOL_COM_PR01],'U'	; パラメータ１
;*;	JMP	FDT_MENU_FORMAT_CMND			;
;*;
;*;FDT_MENU_FORMAT_CMND:
;*;	CALL	FDTOOL_CALL		; "ＦＤＴＯＯＬ．ＣＯＭ"のコール
;*;	JMP	FDT_MENU_FORMAT_LOOP	;
;*;
;*;FDT_MENU_FORMAT_EXIT:
;*;	RET
;*;FDT_MENU	ENDP


; ****************************************************
;	"ＦＤＴＯＯＬ．ＣＯＭ"のロード
;	-O- AX : 0=正常,2=ディスクエラー
; ****************************************************

FDTOOL_LOAD	PROC	NEAR
	MOV	SI,OFFSET FDTOOL_COM		; "FDTOOL.COM"
	MOV	DX,TOP_SEG			; 先頭セグメントアドレス
	MOV	DI,100H				; ＯＲＧ　１００Ｈ
	MOV	CX,FDTOOL_COM_LEN		; "FDTOOL.COM"のサイズ
	CALLC	DSKLD				; load data.
	CMP	AX,0				; 0:normal,1:error.
	JNE	FDTOOL_LOAD_DERROR		;

	MOV	FLAG_HDSET,0			; ハードディスク・フラグ

	CALLC	DKC_HD				; ハードディスクチェック
	CMP	AX,1				; 0=ＦＤ,1=ＨＤ
	JNE	FDTOOL_LOAD_2			;
	MOV	FLAG_HDSET,1			; ハードディスク・フラグ
FDTOOL_LOAD_2:					;

	CALL	PSP_SETUP			; ＰＳＰの準備

	MOV	AX,0			; 0=正常
	RET
FDTOOL_LOAD_DERROR:
	MOV	AX,2			; 2=ディスクエラー
	RET
FDTOOL_LOAD	ENDP


; ****************************************************
;	ＰＳＰの準備
;
;	プリメ・プロセスの呼出し形式
;
;	FDTOOL PRCS12346543 C U
;	           ----====
;	(4hex)offset^    ^segment(4hex)
;
;	PRCS の後に続く数字列はサブファンクションのアドレス
; ****************************************************

PSP_SETUP	PROC	NEAR
	MOV	ES,TOP_SEG			; 先頭セグメントアドレス

	; クリア

	MOV	AL,0				;
	MOV	DI,0				;
	MOV	CX,81H				;
	REP	STOSB				;

	MOV	AL,CHR_SPACE			; space.
	MOV	DI,FDTOOL_COM_CMND		;
	MOV	CX,79H				;
	REP	STOSB				;

	; "PRCS" 呼出しのスイッチ

	MOV	BYTE PTR ES:[FDTOOL_COM_CMND],CMND_BYTE_CNT ; 長さ
	MOV	BYTE PTR ES:[FDTOOL_COM_SPC],' '
	MOV	BYTE PTR ES:[FDTOOL_COM_P],'P'
	MOV	BYTE PTR ES:[FDTOOL_COM_R],'R'
	MOV	BYTE PTR ES:[FDTOOL_COM_C],'C'
	MOV	BYTE PTR ES:[FDTOOL_COM_S],'S'
	MOV	BYTE PTR ES:[FDTOOL_COM_END],0		; デリミタ

	; PRCS の後に続く数字列はサブファンクションのアドレス

	MOV	DX,OFFSET INTER_WINDOWSS	; 外部ウインドウ・ファンクｼｮﾝ
	CALLC	HEXSTR				; hex -> string.
	MOVX	ES:[FDTOOL_COM_OFS]   ,DS:[SI]		; '12'.
	MOVX	ES:[FDTOOL_COM_OFS][2],DS:[SI][2]	; '34'.

	MOV	DX,SEG R_SEG2			;
	CALLC	HEXSTR				; hex -> string.
	MOVX	ES:[FDTOOL_COM_SEG]   ,DS:[SI]		; '65'.
	MOVX	ES:[FDTOOL_COM_SEG][2],DS:[SI][2]	; '43'.

	; 'A'	ＦＤドライブ先頭

	MOV	AL,DRIVENAME_SFT	; ドライブ名と2HDユニット番号のズレ
	ADD	AL,'A'			;
	MOV	BYTE PTR ES:[FDTOOL_COM_FDD],AL	; 'A'	ＦＤドライブ先頭

	CMP	FLAG_HDSET,1		; ハードディスク・フラグ
	JNE	PSP_SETUP_5		;
	MOV	BYTE PTR ES:[FDTOOL_COM_FDD],'H' ; ハードディスク指定
PSP_SETUP_5:

	; 戻り命令

	MOV	WORD PTR ES:[FDTOOL_COM_INT20H],RETPROCCESS	; 戻り命令

	RET
PSP_SETUP	ENDP


; ****************************************************
;	"ＦＤＴＯＯＬ．ＣＯＭ"のコール
; ****************************************************

FDTOOL_CALL	PROC	NEAR
	MOV	WDX1,ARAWDX1		; エリア左上座標Ｘ
	MOV	WDY1,ARAWDY1		; エリア左上座標Ｙ
	MOV	WDX2,ARAWDX2		; エリアサイズＸ
	MOV	WDY2,ARAWDY2		; エリアサイズＹ
	CALLC	WIDDSP_SV_H		; WINDOWS/画面範囲退避

	CALL	COM_PROCESS		; 特殊ＣＯＭプロセスの実行

	MOV	WDX1,ARAWDX1		; エリア左上座標Ｘ
	MOV	WDY1,ARAWDY1		; エリア左上座標Ｙ
	MOV	WDX2,ARAWDX2		; エリアサイズＸ
	MOV	WDY2,ARAWDY2		; エリアサイズＹ
	CALLC	WIDDSP_LD_H		; WINDOWS/画面範囲復元
	RET
FDTOOL_CALL	ENDP


; ****************************************************
;	特殊ＣＯＭプロセスの実行
;	-I- TOP_SEG : 先頭セグメントアドレス
;	    COM_PARA_BX : プリメ・プロセスの呼出しＢＸ
;	    COM_PARA_CX : プリメ・プロセスの呼出しＣＸ
;	    COM_PARA_DX : プリメ・プロセスの呼出しＤＸ
;	-O- COM_RETU_BX : プリメ・プロセスの戻り値ＢＸ
;	    COM_RETU_CX : プリメ・プロセスの戻り値ＣＸ
;	    COM_RETU_DX : プリメ・プロセスの戻り値ＤＸ
; ****************************************************

COM_PROCESS	PROC	NEAR
	MOV	EXE_SAVE_SS,SS		; スタックの退避
	MOV	EXE_SAVE_SP,SP		;

	CLI				; 割り込み禁止
	MOV	SS,TOP_SEG		; 先頭セグメントアドレス
	MOV	SP,0FFFEH		; スタックポインタ（ＳＰ）初期値

	MOV	AX,TOP_SEG		; 先頭セグメントアドレス
	MOV	START_SEG,AX		; スタートセグメントアドレス

	MOV	AX,100H			; インストラクションポインタの初期値
	MOV	START_OFFSET,AX		; スタートオフセットアドレス

	MOV	DX,CS			    ; プロセスの戻りセグメント
	MOV	AX,OFFSET COM_PROCESS_INTER ; プロセスの戻りアドレス
	PUSH	DX			; FAR RET segment.
	PUSH	AX			; FAR RET offset.

	PUSH	START_SEG		; スタートセグメントアドレス
	PUSH	START_OFFSET		; スタートオフセットアドレス

	MOV	BX,COM_PARA_BX		; プリメ・プロセスの呼出しＢＸ
	MOV	CX,COM_PARA_CX		; プリメ・プロセスの呼出しＣＸ
	MOV	DX,COM_PARA_DX		; プリメ・プロセスの呼出しＤＸ

	MOV	AX,START_SEG		; データセグメント
	MOV	ES,AX			;
	MOV	DS,AX			;

	STI				; 割り込み許可
	RETFAR				; プロセスへのジャンプ

COM_PROCESS_INTER:			; プロセスの戻りアドレス
	MOV	AX,SEG DATA		;
	MOV	DS,AX			;

	CLI				;
	MOV	SS,EXE_SAVE_SS		; スタックの復帰
	MOV	SP,EXE_SAVE_SP		;
	STI				;

	MOV	COM_RETU_BX,BX		; プリメ・プロセスの戻り値ＢＸ
	MOV	COM_RETU_CX,CX		; プリメ・プロセスの戻り値ＣＸ
	MOV	COM_RETU_DX,DX		; プリメ・プロセスの戻り値ＤＸ

	RET
COM_PROCESS	ENDP


; ****************************************************
;	外部ウインドウ・ファンクション
;	外部プロセスからＣＡＬＬされる
;	-I- AX : 機能   1=セレクトウインドウ
;			2=マウス読み込み
;			3=ディスクウインドウ(DSKCHG.ASM用)
;			4=マウス読み込み・ワンショット
;			5=タイマ
;			6=データロード
;			7=データセーブ
;			8=ＤＳＫＣＨＧリセット
;	-I/O- R_LOAD_NEW : フラグ・データをロードした
; ****************************************************

INTER_WINDOWSS	PROC	FAR
	PUSH	DS

	PUSH	AX
	MOV	AX,SEG DATA
	MOV	DS,AX
	POP	AX

	MOV	WIDFUNCTION,AX		; 機能

	CMP	WIDFUNCTION,1		; 1=セレクトウインドウ
	JE	INTER_WINDOWSS_F1	;
	CMP	WIDFUNCTION,2		; 2=マウス読み込み
	JE	INTER_WINDOWSS_F2	;
	CMP	WIDFUNCTION,3		; 3=ディスクウインドウ(DSKCHG.ASM用)
	JE	INTER_WINDOWSS_F3	;
	CMP	WIDFUNCTION,4		; 4=マウス読み込み・ワンショット
	JE	INTER_WINDOWSS_F4	;
	CMP	WIDFUNCTION,5		; 5=タイマ
	JE	INTER_WINDOWSS_F5	;
	CMP	WIDFUNCTION,6		; 6=データロード
	JE	INTER_WINDOWSS_F6	;
	CMP	WIDFUNCTION,7		; 7=データセーブ
	JE	INTER_WINDOWSS_F7	;
	CMP	WIDFUNCTION,8		; 8=ＤＳＫＣＨＧリセット
	JE	INTER_WINDOWSS_F8	;

	JMP	INTER_WINDOWSS_EXIT	;


	;	1=セレクトウインドウ
	;	-I- ES:[BX]: 指定文字列
	;	-O- ユーザ選択番号 (FFFFH : 指定なし)

INTER_WINDOWSS_F1:			;-I- ES:[BX]: 指定文字列
	CALLC	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	MOV	AX,WIDSNM		;-O- ユーザ選択番号 (FFFFH : 指定なし)
	JMP	INTER_WINDOWSS_EXIT


	;	2=マウス読み込み
	;	-O- AX : Ｘ座標
	;	    BX : Ｙ座標
	;	    DH : 左ボタン1:OFF,0:ON
	;	    DL : 右ボタン1:OFF,0:ON

INTER_WINDOWSS_F2:
	CALLC	MUSRED			; マウス読み込み
	JMP	INTER_WINDOWSS_EXIT


	;	3=ディスクウインドウ
	;	-I- BX : 1=ウインドウ・オープン
	;	       : 2=ウインドウ・クローズ
	;	       : 3=メッセージ／上段
	;	       : 4=メッセージ／中段
	;	       : 5=メッセージ／下段
	;	 ES:SI : メッセージ・アドレス
INTER_WINDOWSS_F3:
	MOV	DI,OFFSET STR_BUFF	;
	MOV	CX,STRING_LEN		; string length.
	CALLC	STRSETZ			; 文字列バッファセット
	MOV	SI,OFFSET STR_BUFF	;
	CALLC	WIDDISK			; WINDOWS/ディスクウインドウ
	JMP	INTER_WINDOWSS_EXIT


	;	4=マウス読み込み・ワンショット
	;	-O- AX : Ｘ座標
	;	    BX : Ｙ座標
	;	    DH : 左ボタン（1：ＯＦＦ／0：ＯＮ）
	;	    DL : 右ボタン（1：ＯＦＦ／0：ＯＮ）
INTER_WINDOWSS_F4:
	CALLC	MUSSHT		; マウス読み込み・ワンショット
	JMP	INTER_WINDOWSS_EXIT


	;	5=タイマ(V-SYNC timer wait.)
	;	-I- DX : wait timer count.
INTER_WINDOWSS_F5:
	MOV	AX,DX		;
	CALLC	TMVWAT		; V-SYNC timer wait.
	JMP	INTER_WINDOWSS_EXIT


	;	6=データロード
	;	-I- ES:SI : ファイル名
	;	-O- AX    : 0=正常
	;	          : 1=ヘッダが見つかりません
	;	          : 2=ディスクエラー
INTER_WINDOWSS_F6:
	MOV	R_LOAD_NEW,0		; フラグ・データをロードした

	CALLC	WIDALC_LOAD		; WINDOWS/データロード
	CMP	AX,0			; 0=正常
	JNE	INTER_WINDOWSS_678	;
	MOV	R_LOAD_NEW,1		;
INTER_WINDOWSS_678:
	JMP	INTER_WINDOWSS_EXIT


	;	7=データセーブ
	;	WINDOWS/データセーブ
	;	-I- ES:SI : ファイル名
	;	-O- AX    : 0=正常
	;	          : 2=ディスクエラー
INTER_WINDOWSS_F7:
	CALLC	WIDALC_SAVE		; WINDOWS/データセーブ
	JMP	INTER_WINDOWSS_EXIT


	; 8=ＤＳＫＣＨＧリセット
INTER_WINDOWSS_F8:
	CALLC	DKCRST			; ディスクチェンジリセット
	JMP	INTER_WINDOWSS_EXIT


INTER_WINDOWSS_EXIT:
	POP	DS
	RETFAR				; プロセスへ戻る
INTER_WINDOWSS	ENDP


; ****************************************************
;	WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
; ****************************************************

WWIDSLC2	PROC	NEAR
	CALLC	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	RET
WWIDSLC2	ENDP

R_SEG2	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	R_LOAD_FUNC			; ロードセーブ機能

EXTRN	SEGPAT1:WORD			; パーツバッファ＃１セグメント
EXTRN	DRIVENAME_SFT:BYTE		; ドライブ名と2HDユニット番号のズレ
EXTRN	WIDSNM:WORD			; セレクト・ウインドウ／ユーザ選択番号
EXTRN	MESS_ADRS:WORD			; メッセージアドレス

FLAG_HDSET	DW	0		; ハードディスク・フラグ

PUBLIC	R_LDDEMO			;
R_LDDEMO	DW	0		; (R_LOADS.ASM)デモフラグ
					; 0=通常,33=ランダムセレクト

R_LOAD_FUNC	DW	0		; ロードセーブ機能
					; 1=ロード,2=セーブ

R_LOAD_NEW	DW	0		; フラグ・データをロードした

FDTOOL_COM	DB	"FDTOOL.COM",0	; "FDTOOL.COM"
FDTOOL_COM_LEN	DW	50000		; "FDTOOL.COM"のサイズ

EXE_SAVE_SS	DW	0		; スタックセグメント退避
EXE_SAVE_SP	DW	0		; スタックポインタ退避

TOP_SEG		DW	0		; 先頭セグメントアドレス

START_ADDRESS	LABEL	DWORD		; スタートアドレス
START_OFFSET	DW	0		; スタートオフセットアドレス
START_SEG	DW	0		; スタートセグメントアドレス

WIDFUNCTION	DW	0		; 機能 1=セレクトウインドウ

COM_PARA_BX	DW	0		; プリメ・プロセスの呼出しＢＸ
COM_PARA_CX	DW	0		; プリメ・プロセスの呼出しＣＸ
COM_PARA_DX	DW	0		; プリメ・プロセスの呼出しＤＸ

COM_RETU_BX	DW	0		; プリメ・プロセスの戻り値ＢＸ
COM_RETU_CX	DW	0		; プリメ・プロセスの戻り値ＣＸ
COM_RETU_DX	DW	0		; プリメ・プロセスの戻り値ＤＸ

MUSYA_FLAG	DW	0		; 武者フラグ0=だめ,1=よい
MUSYA_COM	DB	"MUSYA.COM",0	; "MUSYA.COM"
MUSYA_COM_LEN	DW	64000		; "MUSYA.COM"のサイズ

MSG_LOADCHU	DB	"ロード中",0,0

DATA	ENDS

	END
;
;	end of "R_LOADS.ASM"
;
