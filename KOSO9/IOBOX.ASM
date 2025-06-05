; "IOBOX.ASM" PC-9801UV11 make by R.H 1990/10/23
;
;	multi i/o handler.
;
; public subroutine.

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	MUSREDX			; マウス読み込み
PUBLIC	MUSWATX			; マウスボタンＯＦＦ待ち

PUBLIC	TIMER			; タイマ(V-SYNC timer wait.)
;PUBLIC	TIMER_SET		; タイマセット(V-SYNC timer wait.)
;PUBLIC	TIMER_WAT		; タイマ待ち(V-SYNC timer wait.)

EXTRN	MUSRED:NEAR		; マウス読み込み
EXTRN	MUSWAT:NEAR		; マウスボタンＯＦＦ待ち


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
;	dos.
; ****************************************************


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

WIDSWCH		DW	0		; ウインドウ選択 0=内部,1=外部

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