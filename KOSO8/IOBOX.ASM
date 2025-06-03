; "IOBOX.ASM" PC-9801UV11 make by R.H 1990/10/23
;
;	multi i/o handler.
;
; public subroutine.

INCLUDE	TSTSET.INC


; ****************************************************
;	ＷＳＥＬＥＣＴ	＜指定文字列＞
;	SELECT	"話す,渡す,行く"
;	結果は WIDSNM （ユーザ選択番号）に反映される
;	             : =FFFFH : 指定なし
; ****************************************************

WSELECT	MACRO	SSSS
	LOCAL	L1,L2
	JMP	L2
L1	DB	SSSS,0
L2:
	MOV	BX,OFFSET L1		; 表示単語アドレス
	CALL	WWIDSLC2		; セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	ENDM



CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	MENU_YESNO		; menu yes/no.
PUBLIC	MENU_FORMATSTART	; menu format start?

PUBLIC	UDISK_SAVE		; ディスクセーブ
PUBLIC	UDISK_LOAD		; ディスクロード

PUBLIC	WIDDISK			; WINDOWS/ディスクウインドウ(DSKCHG.ASM用)
PUBLIC	USER_SHOT		; ユーザスタンバイ

PUBLIC	MUSREDX			; マウス読み込み
PUBLIC	MUSWATX			; マウスボタンＯＦＦ待ち

PUBLIC	TIMER			; タイマ(V-SYNC timer wait.)

PUBLIC	DISKRESET		; disk reset.
PUBLIC	DISKFREE		; disk free space.
PUBLIC	DISKFLCHK		; disk file search.

PUBLIC	WSHIFTDRV		; window shift drive.
PUBLIC	WFUNCADRS		; window function address set.

PUBLIC	WWIDSLC2		; セレクト・ｳｲﾝﾄﾞｳ（簡易指定）

EXTRN	FDDOOR:NEAR		; ＦＤドライブドア開閉チェック

EXTRN	MUSRED:NEAR		; マウス読み込み
EXTRN	MUSWAT:NEAR		; マウスボタンＯＦＦ待ち

EXTRN	DKFDNO:NEAR		; フォーマットのドライブ番号の設定（０ー３）
EXTRN	DKFREE:NEAR		; ディスクの空きクラスタ

CLST_BYTE	EQU	1024	; クラスタバイト数
OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味


; ****************************************************
;	menu yes/no.
;	-O- AX : 1=yes,2=no.
; ****************************************************

MENU_YESNO	PROC	NEAR
	WSELECT	"YES,NO"
	CMP	WIDSNM,0
	JNE	MENU_YESNO_NO
MENU_YESNO_YES:
	MOV	AX,1			; 1=yes.
	RET
MENU_YESNO_NO:
	MOV	AX,2			; 2=no.
	RET
MENU_YESNO	ENDP


; ****************************************************
;	menu format start?
;	-O- AX : 1=yes,2=no.
; ****************************************************

MENU_FORMATSTART	PROC	NEAR
	PUSH	DX
	WSELECT	"format? , quit"
	CMP	WIDSNM,0
	JNE	MENU_FORMAT_NO
MENU_FORMAT_YES:
	MOV	AX,1			; 1=yes.
	POP	DX
	RET
MENU_FORMAT_NO:
	MOV	AX,2			; 2=no.
	POP	DX
	RET
MENU_FORMATSTART	ENDP


; ****************************************************
;	WINDOWS/ディスクウインドウ(DSKCHG.ASM用)
;	-I- BX : 1=ウインドウ・オープン
;	       : 2=ウインドウ・クローズ
;	       : 3=ウインドウ・メッセージ／上段
;	       : 4=ウインドウ・メッセージ／中段
;	       : 5=ウインドウ・メッセージ／下段
;	 DS:SI : メッセージ・アドレス
; ****************************************************

WIDDISK	PROC	NEAR
	CMP	WIDSWCH,0		; ウインドウ選択 0=内部,1=外部
	JE	WIDDISK_INTER		;

WIDDISK_GAIBU:
	MOVX	ES,DS			;
	MOV	WIDFUNCTION,3		; 機能 3=ディスクウインドウ
	CALL	WINDOWSS		; 外部ウインドウ・システム
	JMP	WIDDISK_EXIT
WIDDISK_INTER:
	PUSH	SI
	MOV	DX,BX
	CALL	DECSTR
	CALL	PRINT
	PR	":"
	POP	SI
	CALL	PRINT
	LF
WIDDISK_EXIT:
	RET
WIDDISK	ENDP


; ****************************************************
;	ユーザスタンバイ
;	-O- AX : 0=通常,1=スタンバイ,2=強制終了
; ****************************************************

USER_SHOT	PROC	NEAR
	CMP	WIDSWCH,0		; ウインドウ選択 0=内部,1=外部
	JE	USER_SHOT_INTER		;

USER_SHOT_GAIBU:
	MOV	WIDFUNCTION,4		; 機能 4=マウス読み込み・ワンショット
	CALL	WINDOWSS		; 外部ウインドウ・システム
	CMP	DH,0			; DH : 左ボタン1:OFF,0:ON
	JE	USER_SHOT_STB		;
	CMP	DL,0			; DL : 右ボタン1:OFF,0:ON
	JE	USER_SHOT_BREAK		;

	JMP	USER_SHOT_NORMAL	;
USER_SHOT_INTER:			;
	CALL	KESCAP			; ESC key & break check & pause.
	CMP	AX,0			; 0=normal, 1=ESC on, 2=ctrl-C
	JNE	USER_SHOT_STB		;

USER_SHOT_NORMAL:
	MOV	AX,0			; 0=通常
	RET
USER_SHOT_STB:
	MOV	AX,1			; 1=スタンバイ
	RET
USER_SHOT_BREAK:
	MOV	AX,2			; 2=強制終了
	RET
USER_SHOT	ENDP


; ****************************************************
;	マウス読み込み
;	-O- AX : Ｘ座標
;	    BX : Ｙ座標
;	    DH : 左ボタン（1：ＯＦＦ／0：ＯＮ）
;	    DL : 右ボタン（1：ＯＦＦ／0：ＯＮ）
; ****************************************************

MUSREDX	PROC	NEAR
	CMP	WIDSWCH,0		; ウインドウ選択 0=内部,1=外部
	JE	MUSREDX_INTER		;

MUSREDX_GAIBU:
	MOV	WIDFUNCTION,2		; 2=マウス読み込み
	CALL	WINDOWSS		; 外部ウインドウ・システム
	RET
MUSREDX_INTER:
	CALL	MUSRED			; マウス読み込み
	RET
MUSREDX	ENDP


; ****************************************************
;	マウスボタンＯＦＦ待ち
; ****************************************************

MUSWATX	PROC	NEAR
	CMP	WIDSWCH,0		; ウインドウ選択 0=内部,1=外部
	JE	MUSWATX_INETR		;

MUSWATX_GAIBU:
MUSWAT_LOOP:
	MOV	WIDFUNCTION,2		; 2=マウス読み込み
	CALL	WINDOWSS		; 外部ウインドウ・システム
	CMP	DH,0			; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	MUSWAT_LOOP		;
	CMP	DL,0			; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	MUSWAT_LOOP		;
	RET
MUSWATX_INETR:
	CALL	MUSWAT			; マウスボタンＯＦＦ待ち
	RET
MUSWATX	ENDP


; ****************************************************
;	タイマ(V-SYNC timer wait.)
;	-I- AX : wait timer count.
; ****************************************************

TIMER	PROC	NEAR
	CMP	WIDSWCH,0		; ウインドウ選択 0=内部,1=外部
	JE	TIMER_INTER		;

TIMER_GAIBU:
	MOV	DX,AX			;
	MOV	WIDFUNCTION,5		; 機能 5=タイマ
	CALL	WINDOWSS		; 外部ウインドウ・システム
	JMP	TIMER_EXIT		;

TIMER_INTER:
	PUSH	CX
	MOV	CX,AX
TMWAIT1:
	PUSH	CX
	MOV	CX,3000
TMWAIT2:JMP	TMWAIT3
TMWAIT3:JMP	TMWAIT4
TMWAIT4:JMP	TMWAIT5
TMWAIT5:NOP
	LOOP	TMWAIT2
	POP	CX
	LOOP	TMWAIT1
	POP	CX

	JMP	TIMER_EXIT		;

TIMER_EXIT:
	RET
TIMER	ENDP


; ****************************************************
;	データロード
;	-I- ES:SI : ファイル名
;	-O- AX    : 0=正常
;	          : 1=ヘッダが見つかりません
;	          : 2=ディスクエラー
;	          : 10=ドライブだめ
; ****************************************************

UDISK_LOAD	PROC	NEAR
	CALL	UDRV_CHK		; パス名のドライブをチェック
	CMP	AX,1			; 0=正常,1=ドライブだめ
	JE	UDISK_LOAD_DAME		;

	CALL	EDT_PATH		; パス名修正
	MOV	WIDFUNCTION,6		; 機能 6=データロード
	CALL	WINDOWSS		; 外部ウインドウ・システム
	RET
UDISK_LOAD_DAME:
	MOV	AX,10			; 10=ドライブだめ
	RET
UDISK_LOAD	ENDP


; ****************************************************
;	データセーブ
;	WINDOWS/データセーブ
;	-I- ES:SI : ファイル名
;	-O- AX    : 0=正常
;	          : 2=ディスクエラー
;	          : 10=ドライブだめ
; ****************************************************

UDISK_SAVE	PROC	NEAR
	CALL	UDRV_CHK		; パス名のドライブをチェック
	CMP	AX,1			; 0=正常,1=ドライブだめ
	JE	UDISK_SAVE_DAME		;

	CALL	EDT_PATH		; パス名修正
	MOV	WIDFUNCTION,7		; 機能 7=データセーブ
	CALL	WINDOWSS		; 外部ウインドウ・システム
	RET
UDISK_SAVE_DAME:
	MOV	AX,10			; 10=ドライブだめ
	RET
UDISK_SAVE	ENDP


; ****************************************************
;	パス名のドライブをチェック
;	-I- ES:SI : ファイル名
;	-O- AX    : 0=正常,1=ドライブだめ
; ****************************************************

UDRV_CHK	PROC	NEAR
	CMP	BYTE PTR ES:[SI][1],':'	; ? ':'
	JNE	UDRV_CHK_NORMAL		;

	MOV	AL,BYTE PTR ES:[SI]	; ファイル名
	MOV	AH,0			;
	SUB	AL,'A'			; AX : １ＭＦＤドライブ番号（０ー３）
	PUSH	ES			;
	PUSH	SI			;
	CALL	FDDOOR			; ＦＤドライブドア開閉チェック
	POP	SI			;
	POP	ES			;
	CMP	AX,2			; 2=ドアが開きっぱなし
	JE	UDRV_CHK_NOT_READY	;

UDRV_CHK_NORMAL:
	MOV	AX,0			; 0=正常
	RET
UDRV_CHK_NOT_READY:
	MOV	AX,1			; 1=ドライブだめ
	RET
UDRV_CHK	ENDP


; ****************************************************
;	dos.
; ****************************************************

; ****************************************************
;	disk reset.
; ****************************************************

DISKRESET	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AH,0DH		; disk reset.
	INT	21H		; dos function.

	MOV	WIDFUNCTION,8		; 8=ＤＳＫＣＨＧリセット
	CALL	WINDOWSS		; 外部ウインドウ・システム

	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
DISKRESET	ENDP


; ****************************************************
;	disk free space.
;	-I- DX    : １ＭＦＤドライブ番号（０－３）
;	-O- DX:AX :(DWORD) ディスク空き容量
; ****************************************************

DISKFREE	PROC	NEAR
	MOV	AX,DX		; １ＭＦＤドライブ番号
	CALL	DKFDNO		; フォーマットのドライブ番号の設定（０ー３）

	CALL	DKFREE		; ディスクの空きクラスタ
	CMP	AX,0		; 0=正常,1=エラー
	JNE	DISKFREE_NONE	;

	MOV	AX,DX		; 空きクラスタ数
	MOV	DX,0		;
	MOV	BX,CLST_BYTE	; クラスタバイト数
	MUL	BX		; 空きクラスタ数
	RET
DISKFREE_NONE:
	MOV	DX,0		;
	MOV	AX,0		; disk free space.
	RET
DISKFREE	ENDP


; ****************************************************
;	disk file search.
;	-I- DS:SI : file name.
;	-O- AX    : 1=ある,2=ない
; ****************************************************

DISKFLCHK	PROC	NEAR
	PUSH	ES
	MOVX	ES,DS		;
	CALL	EDT_PATH	; パス名修正
	POP	ES

	MOV	DX,SI		; path name.
	MOV	AH,3DH		; handle open.
	MOV	AL,0		; read mode.
	INT	21H		; dos function.
	JC	DISKFLCHK_NAI	;

	MOV	BX,AX		; file handle.
	MOV	AH,3EH		; handle close.
	INT	21H		; dos function.

	MOV	AX,1		; 1=ある
	RET
DISKFLCHK_NAI:
	MOV	AX,2		; 2=ない
	RET
DISKFLCHK	ENDP


; ****************************************************
;	パス名修正
;	-I/O- ES:SI : file name.
; ****************************************************

EDT_PATH	PROC	NEAR
	CMP	BYTE PTR ES:[SI][1],':'	; ? ':'
	JNE	EDT_PATH_EXIT		;

	PUSH	AX
	MOV	AL,BYTE PTR WIDFDDSFT	; ＦＤドライブ先頭のドライブ名シフト
	ADD	DS:[SI],AL		; 'A'+1 -> 'B'
	POP	AX
EDT_PATH_EXIT:
	RET
EDT_PATH	ENDP


; ****************************************************
;	window shift drive.
;	-I- AL : ＦＤドライブ先頭のドライブ名
; ****************************************************

WSHIFTDRV	PROC	NEAR
	CMP	AL,'A'
	JB	WSHIFTDRV_EXIT
	CMP	AL,'Z'
	JNBE	WSHIFTDRV_EXIT
	
	SUB	AL,'A'			; ＦＤドライブ先頭のドライブ名
	MOV	BYTE PTR WIDFDDSFT,AL	; ＦＤドライブ先頭のドライブ名シフト
WSHIFTDRV_EXIT:
	RET
WSHIFTDRV	ENDP


; ****************************************************
;	window function address set.
;	-I- AX : 外部ウインドウオフセット
;	    DX : 外部ウインドウセグメント
; ****************************************************

WFUNCADRS	PROC	NEAR
	MOV	WIDSADROFS,AX		; 外部ウインドウオフセット
	MOV	WIDSADRSEG,DX		; 外部ウインドウセグメント
	MOV	WIDSWCH,1		; ウインドウ選択 0=内部,1=外部
	RET
WFUNCADRS	ENDP


; ****************************************************
;	セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
;	-I- DS:[BX]  : 指定文字列
;	-O- WIDSNM   : セレクト・ウインドウ／ユーザ選択番号
;	             : =FFFFH : 指定なし
;
;	［話す］	L1	DB	"話す,渡す,行く",0
;	［渡す］
;	［行く］
; ****************************************************

WWIDSLC2	PROC	NEAR
	CMP	WIDSWCH,0		; ウインドウ選択 0=内部,1=外部
	JE	WWIDSLC2_INTER		;

WWIDSLC2_GAIBU:
	MOVX	ES,DS			;
	MOV	WIDFUNCTION,1		; 機能 1=セレクトウインドウ
	CALL	WINDOWSS		; 外部ウインドウ・システム
	MOV	WIDSNM,AX		; ユーザ選択番号
	JMP	WWIDSLC2_EXIT		;

WWIDSLC2_INTER:
	PR	"select with key (1,2,3...)["
	MOV	SI,BX			; 指定文字列
	CALL	PRINT			; print.
	PR	"]"
	CALL	INPUT			; input.
	LF
	CALL	STRDEC			; string -> dec.

	CMP	DX,0			;
	JE	WWIDSLC2_OFF		;
	DEC	DX			; -1
	MOV	WIDSNM,DX		; セレクト／ユーザ選択番号
	JMP	WWIDSLC2_EXIT		;
WWIDSLC2_OFF:
	MOV	WIDSNM,OFFF		; セレクト／ユーザ選択番号
WWIDSLC2_EXIT:
	RET
WWIDSLC2	ENDP


; ****************************************************
;	外部ウインドウ・システム
;	-I- WIDFUNCTION : 機能  1=セレクトウインドウ
;				2=マウス読み込み
;				3=ディスクウインドウ(DSKCHG.ASM用)
;				4=マウス読み込み・ワンショット
;				5=タイマ
;				6=データロード
;				7=データセーブ
;				8=ＤＳＫＣＨＧリセット
; ****************************************************

WINDOWSS	PROC	NEAR
	CMP	WIDSWCH,1		; ウインドウ選択 0=内部,1=外部
	JNE	WINDOWSS_EXIT		;

	MOV	AX,WIDFUNCTION		; 機能
	CALL	DWORD PTR WIDSADR	; 外部ウインドウアドレス

WINDOWSS_EXIT:
	RET
WINDOWSS	ENDP


; ****************************************************
;	DATA
; ****************************************************
	EVEN

PUBLIC	WIDSNM				; セレクト・ウインドウ／ユーザ選択番号

WIDSWCH		DW	0		; ウインドウ選択 0=内部,1=外部
WIDFDDSFT	DW	0		; ＦＤドライブ先頭のドライブ名シフト

WIDSADR		LABEL	DWORD		; 外部ウインドウアドレス
WIDSADROFS	DW	0		; 外部ウインドウオフセット
WIDSADRSEG	DW	0		; 外部ウインドウセグメント
WIDFUNCTION	DW	0		; 機能 1=セレクトウインドウ

WIDSNM	DW	0			; セレクト・ウインドウ／ユーザ選択番号

CODE	ENDS

	END
;
;	end of "IOBOX.ASM"
;
