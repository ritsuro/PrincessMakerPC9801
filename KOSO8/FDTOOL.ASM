; "FDTOOL.ASM" PC-9801UV11 make by R.H 1990/12/29
;
;	プリンセスメーカー版
;	FDTOOL ver0.1 (C) 1991 r.hashimoto
;
;	プリメ・プロセスの呼出し形式
;	      'PRCS'=password.
;	FDTOOL PRCSA12346543 C U
;	'A'fd drive^----====
;	 (4hex)offset^    ^segment(4hex)
;
;		ＰＲＣＳの後に続く 'Ａ'はＦＤドライブ先頭で、
;		数字列はサブファンクションのアドレス
;
;		ハードディスク付きのＰＣでＦＤドライブ先頭が
;		Ｂ：ならば、"FDTOOL PRCSB" となる。
;		ハードディスク付きのＰＣでハードディスク指定ならば
;		"FDTOOL PRCSH" となる。
;
;
; public subroutine.

INCLUDE	TSTSET.INC

FDTOOL_COM_SPC		EQU	81H		; ' '
FDTOOL_COM_P		EQU	82H		; 'P'	呼出しのスイッチ
FDTOOL_COM_R		EQU	83H		; 'R'	.
FDTOOL_COM_C		EQU	84H		; 'C'	.
FDTOOL_COM_S		EQU	85H		; 'S'	.
FDTOOL_COM_FDD		EQU	86H		; 'A'	ＦＤドライブ先頭
FDTOOL_COM_OFS		EQU	87H		; '1234'.
FDTOOL_COM_SEG		EQU	8BH		; '6543'.

AXDX_input_argument	MACRO	PNT
	MOV	DI,ARG_TABLE_ADRS	;
	MOV	SI,DS:[DI][PNT*2]	; 引き数のテーブルのアドレス
	CALL	STRDEC			;
	MOV	AX,DX
	ENDM

CHR_input_argument	MACRO	PNT
	MOV	DI,ARG_TABLE_ADRS	;
	MOV	SI,DS:[DI][PNT*2]	; 引き数のテーブルのアドレス
	MOV	AL,DS:[SI]		;
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

EXTRN	GETARG:NEAR		; get argument.

EXTRN	WSHIFTDRV:NEAR		; window shift drive.
EXTRN	WFUNCADRS:NEAR		; window function address set.

EXTRN	DKFDNO:NEAR		; フォーマットのドライブ番号の設定（０ー３）
EXTRN	DKFORM:NEAR		; ディスクのフォーマット
EXTRN	DKF2ND:NEAR		; ディスクのセカンドフォーマット
EXTRN	DKFPSI:NEAR		; ディスクの物理フォーマット

EXTRN	DKCSET:NEAR		; ディスクチェンジセット
EXTRN	DKCIDW:NEAR		; ディスクＩＤの書き込み

EXTRN	MUSINI:NEAR		; マウスの初期化
EXTRN	MUSSTP:NEAR		; マウスの終了

EXTRN	USERDISK:NEAR		; ユーザーディスク・ユーティリティ

EXTRN	MENU_FORMATSTART:NEAR	; menu format start?


; ****************************************************
;	PROGRAM CODE
; ****************************************************

	ORG	100H
START:
	CALL	MAIN			; main proc.

	CMP	PRINCESS_PROC,1		; プリンセスメーカーのプロセス 1=on
	JE	FINALE_PRINCESS		;
FINALE:
	MOV	AH,4CH			; return to DOS.
	MOV	AL,0			;
	INT	21H			; end.
					;
	JMP	MUGEN			;

FINALE_PRINCESS:
	MOV	DX,0			;
	JMP	DX			; return to PRINCESS.
MUGEN:					;
	JMP	MUGEN			;


SEC_BYTE	EQU	1024		; セクタバイト数

PUBLIC		SCDATA			; セクタバッファ
PUBLIC		SEC_ID_TBL1		; セクタＩＤバッファ
		EVEN
SCDATA		DB	SEC_BYTE DUP (0) ; セクタバッファ
		DB	0,0		 ;
SEC_ID_TBL1	LABEL	BYTE		; セクタＩＤバッファ
		;	C  H  R  N
		DB	00,00,01,03	; 1
		DB	00,00,02,03	; 2
		DB	00,00,03,03	; 3
		DB	00,00,04,03	; 4
		DB	00,00,05,03	; 5
		DB	00,00,06,03	; 6
		DB	00,00,07,03	; 7
		DB	00,00,08,03	; 8

; ****************************************************
;	メイン処理
; ****************************************************

MAIN	PROC	NEAR

	; (1) プリメ・プロセスかをチェック

	CMP	BYTE PTR DS:[FDTOOL_COM_SPC],' '
	JMPNE	MAIN_START
	CMP	BYTE PTR DS:[FDTOOL_COM_P],'P'
	JMPNE	MAIN_START
	CMP	BYTE PTR DS:[FDTOOL_COM_R],'R'
	JMPNE	MAIN_START
	CMP	BYTE PTR DS:[FDTOOL_COM_C],'C'
	JMPNE	MAIN_START
	CMP	BYTE PTR DS:[FDTOOL_COM_S],'S'
	JMPNE	MAIN_START

	MOV	PRINCESS_PROC,1		; プリンセスメーカーのプロセス 1=on

	MOV	CRTOFF,0		; crt off flag. 1=off
	MOV	INPUTOFF,0		; input off flag. 1=off

	;	FDTOOL PRCSA12346543 C U
	;	'A'fd drive^----====
	;	 (4hex)offset^    ^segment(4hex)

	MOV	AL,DS:[FDTOOL_COM_FDD]	; ＦＤドライブ先頭のドライブ名
	CMP	AL,'A'			;
	JB	MAIN_START		;
	CMP	AL,'Z'			;
	JNBE	MAIN_START		;

	CMP	AL,'H'			;
	JNE	MAIN_1			;
	MOV	USER_D_CURRENT,1	; ユーザディスク・カレント指定=1
	JMP	MAIN_2			;
MAIN_1:
	CALL	WSHIFTDRV		; window shift drive.
MAIN_2:

	CMP	BYTE PTR DS:[FDTOOL_COM_OFS],'0'
	JB	MAIN_START
	CMP	BYTE PTR DS:[FDTOOL_COM_SEG],'0'
	JB	MAIN_START

	MOVX	<WORD PTR STR_BUFF>   ,<DS:[FDTOOL_COM_OFS]>	; '12'.
	MOVX	<WORD PTR STR_BUFF[2]>,<DS:[FDTOOL_COM_OFS][2]>	; '34'.
	MOV	STR_BUFF[4],0					; end of str.
	MOV	SI,OFFSET STR_BUFF
	CALL	STRHEX			; hex -> string.
	MOV	VOFS,DX			; offset.

	MOVX	<WORD PTR STR_BUFF>   ,<DS:[FDTOOL_COM_SEG]>	; '65'.
	MOVX	<WORD PTR STR_BUFF[2]>,<DS:[FDTOOL_COM_SEG][2]>	; '43'.
	MOV	STR_BUFF[4],0					; end of str.
	MOV	SI,OFFSET STR_BUFF
	CALL	STRHEX			; hex -> string.
	MOV	VSEG,DX			; segment.

	MOV	AX,VOFS			; 外部ウインドウオフセット
	MOV	DX,VSEG			; 外部ウインドウセグメント
	CALL	WFUNCADRS		; window function address set.

	MOV	CRTOFF,1		; crt off flag. 1=off
	MOV	INPUTOFF,1		; input off flag. 1=off

MAIN_START:

	; (2) 引き数を取り出す

	CALL	GETARG			; get argument.
	MOV	ARG_TABLE_ADRS,SI	; 引き数のテーブルのアドレス
	MOV	ARG_COUNT,CX		; 引き数の数

	CMP	ARG_COUNT,1		; 引き数の数
	JMPLE	MAIN_HELP		;

	CHR_input_argument	0	;
	MOV	ARG_CHR1,AL		; 引き数１

	CHR_input_argument	1	;
	MOV	ARG_CHR2,AL		; 引き数２

	CHR_input_argument	2	;
	MOV	ARG_CHR3,AL		; 引き数３

	CHR_input_argument	3	;
	MOV	ARG_CHR4,AL		; 引き数４


	; (3) 入出力の選択

	CMP	PRINCESS_PROC,1		; プリンセスメーカーのプロセス 1=on
	JMPEQ	MAIN_SKIP2		;

					; default.
	MOV	CRTOFF,0		; crt off flag. 1=off
	MOV	INPUTOFF,0		; input off flag. 1=off

	CMP	ARG_CHR1,'U'		; U : command line use.
	JNE	MAIN_21			;
	MOV	CRTOFF,0		; crt off flag. 1=off
	MOV	INPUTOFF,0		; input off flag. 1=off
	JMP	MAIN_29			;
MAIN_21:				;
	CMP	ARG_CHR1,'C'		; C : child process use.
	JNE	MAIN_22			;
	MOV	CRTOFF,1		; crt off flag. 1=off
	MOV	INPUTOFF,1		; input off flag. 1=off
	JMP	MAIN_29			;
MAIN_22:				;
	CMP	ARG_CHR1,'T'		; T : text off.
	JNE	MAIN_29			;
	MOV	CRTOFF,1		; crt off flag. 1=off
	MOV	INPUTOFF,0		; input off flag. 1=off
	JMP	MAIN_29			;

MAIN_29:				;

MAIN_SKIP2:				;

	; (4) コマンド分岐

	CALL	TITLE_MES		; タイトル

	CMP	ARG_CHR2,'A'		; 引き数２
	JB	MAIN_HELP		;
	CMP	ARG_CHR2,'Z'		; 引き数２
	JNBE	MAIN_HELP		;

	MOV	BH,0			;
	MOV	BL,ARG_CHR2		; 引き数２
	SUB	BX,'A'			; A=0,B=1....
	SHL	BX,1			; word pointer.
	CALL	WORD PTR DS:JUMP_LABEL_TABLE[BX]
	JMP	MAIN_EXIT		;

JUMP_LABEL_TABLE	LABEL	WORD
	DW	DUMMY			;A
	DW	DUMMY			;B
	DW	DISK_ID_CHECK		;C disk chenge check.
	DW	DUMMY			;D
	DW	DUMMY			;E
	DW	FD_FORMAT		;F ＦＤのフォーマット
	DW	FD_2NDFORM		;G ＦＤのセカンドフォーマット
	DW	DUMMY			;H
	DW	DUMMY			;I
	DW	DUMMY			;J
	DW	DUMMY			;K
	DW	DUMMY			;L
	DW	DUMMY			;M
	DW	DUMMY			;N
	DW	DUMMY			;O
	DW	FD_PYSICAL_F		;P FD pysical format.
	DW	DUMMY			;Q
	DW	DUMMY			;R
	DW	DUMMY			;S
	DW	DUMMY			;T
	DW	USERDISK_MAKER		;U ユーザーディスク
	DW	DUMMY			;V
	DW	DUMMY			;W
	DW	DUMMY			;X
	DW	DUMMY			;Y
	DW	DUMMY			;Z

MAIN_HELP:				;
	CALL	TITLE_MES		; タイトル
	CALL	HELP_MESSAGE		; ＨＥＬＰ
MAIN_EXIT:
	CALL	MUSSTP			; マウスの終了
	RET
MAIN	ENDP

DUMMY	PROC	NEAR
	RET
DUMMY	ENDP

; ****************************************************
;	タイトル
; ****************************************************

TITLE_MES	PROC	NEAR
	MOV	SI,OFFSET MES_TITLE
	CALL	PRINT
	RET
TITLE_MES	ENDP

MES_TITLE	LABEL	BYTE
	DB	"プリンセスメーカー版",0DH,0AH
	DB	"FDTOOL ver0.1 (C) 1991 r.hashimoto",0DH,0AH
	DB	0

; ****************************************************
;	ＨＥＬＰ
; ****************************************************

HELP_MESSAGE	PROC	NEAR
	MOV	SI,OFFSET MSG_HELP
	CALL	PRINT
	RET
HELP_MESSAGE	ENDP

MSG_HELP	LABEL	BYTE
DB " a> FDTOOL {1} {2} {3} {4} {5}"		,0DH,0AH
DB "{1} U : command line use."			,0DH,0AH
DB "    C : child process use."			,0DH,0AH
DB "    T : text off."				,0DH,0AH
DB "{2}                               {2}"			,0DH,0AH
DB "    C : disk chenge check.       |    U : user disk utility.",0DH,0AH
DB "      {3} 1-? disk ID#           |      {3} S=save L=load"	,0DH,0AH
DB "    F : FD format.               |       ex> FDTOOL U U S"	,0DH,0AH
DB "      {3} 1-4 format drive unit#"		,0DH,0AH
DB "       ex> FDTOOL U F 1"			,0DH,0AH
DB "    G : FD 2nd format."			,0DH,0AH
DB "      {3} 1-4 format drive unit#"		,0DH,0AH
DB "      {4} use clast counter."		,0DH,0AH
DB "       ex> FDTOOL U G 1 12"			,0DH,0AH
DB "    P : FD pysical format."			,0DH,0AH
DB "      {3} 1-4 format drive unit#"		,0DH,0AH
DB "      {4} start track."			,0DH,0AH
DB "      {5} track count."			,0DH,0AH
DB "       ex> FDTOOL U P 2 1 34"		,0DH,0AH
DB 0


; ****************************************************
;	ユーザーディスク
;	FDTOOL n U ?
;		   S = SAVE
;		   L = LOAD
; ****************************************************

USERDISK_MAKER	PROC	NEAR
	CMP	ARG_CHR3,'S'		; SAVE
	JE	USERDISK_MAKER_SAVE	;
	CMP	ARG_CHR3,'L'		; LOAD
	JE	USERDISK_MAKER_LOAD	;
	RET

USERDISK_MAKER_LOAD:
	MOV	USER_D_FUNCTION,1	; ユーザディスク機能 1=ロード
	CALL	USERDISK		; ユーザーディスク・ユーティリティ
	RET

USERDISK_MAKER_SAVE:
	MOV	USER_D_FUNCTION,2	; ユーザディスク機能 2=セーブ
	CALL	USERDISK		; ユーザーディスク・ユーティリティ
	RET
USERDISK_MAKER	ENDP

; ****************************************************
;	ＦＤのフォーマット
;	FDTOOL n F <drive#>
; ****************************************************

FD_FORMAT	PROC	NEAR
	CMP	ARG_COUNT,3		; 引き数の数
	JE	FD_FORMAT_START		;
	RET
FD_FORMAT_START:
	AXDX_input_argument	2
	PRVU	"FD format unit#",AX
	DEC	AX			; －１
	CALL	DKFDNO			; フォーマットのドライブ番号の設定

	CALL	MENU_FORMATSTART	; menu format start?
	CMP	AX,1			; 1=yes,2=no.
	JMPNE	FD_FORMAT_EXIT		;

	CALL	DKFORM			; ディスクのフォーマット
	CMP	AX,2			;
	JE	FD_FORMAT_ER2		;
	CMP	AX,3			;
	JE	FD_FORMAT_ER3		;
	CMP	AX,4			;
	JE	FD_FORMAT_ER4		;

	PRF	"format complet."
	JMP	FD_FORMAT_EXIT
FD_FORMAT_ER2:
	PRF	"disk error"
	JMP	FD_FORMAT_EXIT
FD_FORMAT_ER3:
	PRF	"not ready"
	JMP	FD_FORMAT_EXIT
FD_FORMAT_ER4:
	PRF	"write protect"
FD_FORMAT_EXIT:
	RET
FD_FORMAT	ENDP


; ****************************************************
;	ＦＤのセカンドフォーマット
;	FDTOOL n G <drive#> <clast>
; ****************************************************

FD_2NDFORM	PROC	NEAR
	CMP	ARG_COUNT,4		; 引き数の数
	JE	FD_2NDFORM_START	;
	RET
FD_2NDFORM_START:
	AXDX_input_argument	2
	PRVU	"FD format unit#",AX
	DEC	AX			; －１
	CALL	DKFDNO			; フォーマットのドライブ番号の設定

	AXDX_input_argument	3
	PRVU	"use clast count=",DX	; 使用したいクラスタ数

	CALL	MENU_FORMATSTART	; menu format start?
	CMP	AX,1			; 1=yes,2=no.
	JMPNE	FD_2NDFORM_EXIT

	CALL	DKF2ND			; ディスクのセカンドフォーマット
	CMP	AX,2			;
	JE	FD_2NDFORM_ER2		;
	CMP	AX,3			;
	JE	FD_2NDFORM_ER3		;
	CMP	AX,4			;
	JE	FD_2NDFORM_ER4		;

	PRF	"format complet."
	JMP	FD_2NDFORM_EXIT
FD_2NDFORM_ER2:
	PRF	"disk error"
	JMP	FD_2NDFORM_EXIT
FD_2NDFORM_ER3:
	PRF	"not ready"
	JMP	FD_2NDFORM_EXIT
FD_2NDFORM_ER4:
	PRF	"write protect"
FD_2NDFORM_EXIT:
	RET
FD_2NDFORM	ENDP


; ****************************************************
;	物理フォーマット
;	FDTOOL U P <drive#> <start> <count>
; ****************************************************

FD_PYSICAL_F	PROC	NEAR
	CMP	ARG_COUNT,5		; 引き数の数
	JE	FD_PYSICAL_F_START	;
	RET
FD_PYSICAL_F_START:
	AXDX_input_argument	2
	PRVU	"FD format unit#",AX
	DEC	AX			; －１
	CALL	DKFDNO			; フォーマットのドライブ番号の設定

	AXDX_input_argument	3
	MOV	TRK_START,AX		; start track.

	AXDX_input_argument	4
	MOV	TRK_COUNT,AX		; track count.

	PRVU	"start track=",TRK_START	; start track.
	PRVU	"track count=",TRK_COUNT	; track count.

	CALL	MENU_FORMATSTART	; menu format start?
	CMP	AX,1			; 1=yes,2=no.
	JNE	FD_PYSICAL_F_EXIT	;

	MOV	AX,TRK_START		; 先頭トラック番号
	MOV	CX,TRK_COUNT		; フォーマットするトラック数
	CALL	DKFPSI			; ディスクの物理フォーマット

FD_PYSICAL_F_EXIT:
	RET
FD_PYSICAL_F	ENDP


; ****************************************************
;	disk chenge check.
;	FDTOOL n C <diskID#>
; ****************************************************

DISK_ID_CHECK	PROC	NEAR
	CALL	DKCSET			; ディスクチェンジセット
	PRVU	"ドライブ番号(1-4)=",DX
	RET
DISK_ID_CHECK	ENDP



; ****************************************************
;	DATA
; ****************************************************
	EVEN

PUBLIC	PRINCESS_PROC		; プリンセスメーカーのプロセス 1=on
EXTRN	CRTOFF:WORD		; crt off flag. 1=off
EXTRN	INPUTOFF:WORD		; input off flag. 1=off

EXTRN	USER_D_CURRENT:WORD	; ユーザディスク・カレント指定=1
EXTRN	USER_D_FUNCTION:WORD	; ユーザディスク機能

PRINCESS_PROC	DW	0	; プリンセスメーカーのプロセス 1=on

ARG_TABLE_ADRS	DW	0	; 引き数のテーブルのアドレス
ARG_COUNT	DW	0	; 引き数の数

ARG_CHR1	DB	0	; 引き数１
ARG_CHR2	DB	0	; 引き数２
ARG_CHR3	DB	0	; 引き数３
ARG_CHR4	DB	0	; 引き数４

TRK_START	DW	0	; start track.
TRK_COUNT	DW	0	; track count.

STR_BUFF	DB	16 DUP (0) ; work string.

VSEG		DW	0	; segment.
VOFS		DW	0	; offset.

CODE	ENDS

	END	START
;
;	end of "FDTOOL.ASM"
;
