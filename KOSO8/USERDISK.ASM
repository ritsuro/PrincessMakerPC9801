; "USERDISK.ASM" PC-9801UV11 make by R.H 1990/12/29
;
;	プリンセスメーカー
;
;	ユーザーディスク・ユーティリティ
;
; public subroutine.

INCLUDE	TSTSET.INC

;		WINDOW1  COM    25383  91-03-04    1:41

DATA_AREA_LENGTH	EQU	29696	; データエリア長さ
					; DATA_AREA_LENGTH/1024
USER_DATA_CLAST		EQU	29	; ユーザデータの必要クラスタ数

;	ＰＲＩＮＴＭ	”表示文字列”

PRINTM	MACRO	NUM,STRING
	LOCAL	L1,L2
	PUSH	SI
	JMP	L2
L1	DB	STRING,0DH,0AH,0
L2:	MOV	SI,OFFSET L1
	MOV	BX,NUM
	EXTRN	WIDDISK:NEAR
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
	POP	SI
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
L1	DB	SSSS,0
EXTRN	WIDSNM:WORD			; セレクト・ウインドウ／ユーザ選択番号
L2:
	MOV	BX,OFFSET L1		; 表示単語アドレス
	EXTRN	WWIDSLC2:NEAR		;
	CALL	WWIDSLC2		; セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	ENDM


OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	USERDISK		; ユーザーディスク・ユーティリティ

EXTRN	UDISK_SAVE:NEAR		; ディスクセーブ
EXTRN	UDISK_LOAD:NEAR		; ディスクロード

EXTRN	DKFDNO:NEAR		; フォーマットのドライブ番号の設定（０ー３）
EXTRN	DKFORM:NEAR		; ディスクのフォーマット
EXTRN	DKF2ND:NEAR		; ディスクのセカンドフォーマット

EXTRN	DKCSET:NEAR		; ディスクチェンジセット
EXTRN	DKCIDW:NEAR		; ディスクＩＤの書き込み

EXTRN	WIDDISK:NEAR		; WINDOWS/ディスクウインドウ
				; その引数
				; -I- BX : 1=ウインドウ・オープン
				;        : 2=ウインドウ・クローズ
				;        : 3=ウインドウ・メッセージ／上段
				;        : 4=ウインドウ・メッセージ／中段
				;        : 5=ウインドウ・メッセージ／下段
				;  DS:SI : メッセージ・アドレス

EXTRN	WIDDLOAD:NEAR		; WINDOWS/ロードウインドウ
EXTRN	WIDDSAVE:NEAR		; WINDOWS/セーブウインドウ

EXTRN	MENU_YESNO:NEAR		; menu yes/no.



; ****************************************************
;	ユーザーディスク・ユーティリティ
;	-I- USER_D_FUNCTION : ユーザディスク機能 1=ロード,2=セーブ
;	    USER_D_CURRENT  : ユーザディスク・カレント指定=1
; ****************************************************

USERDISK	PROC	NEAR
	MOV	DRIVE_NUMBER,0		; ユーザディスクドライブ番号(1-4)

	CMP	USER_D_CURRENT,1	; ユーザディスク・カレント指定=1
	JE	USERDISK_2		;

	CALL	FD_SETTING		; ＦＤのセッティング
	CMP	AX,1			; 1=強制終了
	JE	USERDISK_CLOSE		;

USERDISK_2:
	CMP	USER_D_FUNCTION,1	; ユーザディスク機能 1=ロード,2=セーブ
	JE	USERDISK_LOAD		;

USERDISK_SAVE:
	CALL	DATA_SAVE		; データセーブ
	JMP	USERDISK_CLOSE		;
USERDISK_LOAD:
	CALL	DATA_LOAD		; データロード
USERDISK_CLOSE:
	RET
USERDISK	ENDP


; ****************************************************
;	データセーブ
;	-I- DRIVE_NUMBER : ユーザディスクドライブ番号(1-4,0=ｶﾚﾝﾄ)
;	-O- AX           : 0=正常,1=エラー
; ****************************************************

DATA_SAVE	PROC	NEAR
	CMP	DRIVE_NUMBER,0		; ユーザディスクドライブ番号 0=ｶﾚﾝﾄ
	JE	DATA_SAVE_555		;

	MOV	AX,DRIVE_NUMBER		; ユーザディスクドライブ番号(1-4)
	DEC	AX			; １ＭＦＤドライブ番号
	CALL	DKFDNO			; フォーマットのドライブ番号の設定

	MOV	DX,USER_DATA_CLAST	; ユーザデータの必要クラスタ数
	CALL	DKF2ND			; ディスクのセカンドフォーマット
	CMP	AX,0			; 0=正常
	JNE	DATA_SAVE_ERROR		;

DATA_SAVE_555:
	MOV	DX,DRIVE_NUMBER		; ユーザディスクドライブ番号(1-4)
	CALL	WIDDSAVE		; WINDOWS/セーブウインドウ
	CMP	AX,1			; 0=正常,1=強制終了
	JE	DATA_SAVE_NORMAL	;

	MOVX	ES,DS			;
	MOV	SI,OFFSET MXFLNAME	; データファイル名（パスを含む）
	CALL	UDISK_SAVE		; ディスクセーブ
	CMP	AX,10			; 10=ドライブだめ
	JE	DATA_SAVE_OUT		;
	CMP	AX,0			; 0=正常
	JNE	DATA_SAVE_ERROR		; 2=ディスクエラー

DATA_SAVE_NORMAL:
	MOV	AX,0			; 0=正常
	RET
DATA_SAVE_ERROR:
	MOV	AX,1			; 1=エラー
	RET
DATA_SAVE_OUT:
	WSELECT	"ディスクを取ったのでだめだったよ‥‥"
	MOV	AX,1			; 1=エラー
	RET
DATA_SAVE	ENDP


; ****************************************************
;	データロード
;	-I- DRIVE_NUMBER : ユーザディスクドライブ番号(1-4,0=ｶﾚﾝﾄ)
;	-O- AX           : 0=正常,1=エラー
; ****************************************************

DATA_LOAD	PROC	NEAR
	MOV	DX,DRIVE_NUMBER		; ユーザディスクドライブ番号(1-4,0ｶﾚﾝﾄ)
	CALL	WIDDLOAD		; WINDOWS/ロードウインドウ
	CMP	AX,1			; 0=正常,1=強制終了
	JE	DATA_LOAD_NORMAL	;

	MOVX	ES,DS			;
	MOV	SI,OFFSET MXFLNAME	; データファイル名（パスを含む）
	CALL	UDISK_LOAD		; ディスクロード
	CMP	AX,10			; 10=ドライブだめ
	JE	DATA_LOAD_OUT		;
	CMP	AX,0			; 1=ヘッダが見つかりません
	JNE	DATA_LOAD_ERROR		; 2=ディスクエラー

DATA_LOAD_NORMAL:
	MOV	AX,0			; 0=正常
	RET
DATA_LOAD_ERROR:
	MOV	AX,1			; 1=エラー
	RET
DATA_LOAD_OUT:
	WSELECT	"ディスクを取ったのでだめだったよ‥‥"
	MOV	AX,1			; 1=エラー
	RET
DATA_LOAD	ENDP


; ****************************************************
;	ＦＤのセッティング
;	-O- DRIVE_NUMBER : ユーザディスクドライブ番号(1-4)
;	    AX           : 0=正常,1=強制終了
; ****************************************************

FD_SETTING	PROC	NEAR

FD_SETTING_START:
	CALL	USERDK_SCH		; ユーザディスクのサーチ
	CMP	USER_ST_BREAK,1		; ユーザＢＲＥＡＫ 1=強制終了
	JMPEQ	FD_SETTING_BREAK2	;

	CMP	FLAG_USER_DISK,1	; 1=ユーザディスク
	JMPEQ	FD_SETTING_END		;

	MOV	BX,DRIVE_NUMBER		; ユーザディスクドライブ番号(1-4)
	DEC	BX			; -1
	SHL	BX,1			; word pointer.
	MOV	AX,WORD PTR DS:DRIVE_CHR[BX]	; "１２３４"
	MOV	WORD PTR MSG_01[8],AX	; "ドライブ１のディスク
	MOV	WORD PTR MSG_02[8],AX	; "ドライブ１のディスク

	CMP	FLAG_USER_DISK,2	; 2=新しいディスク
	JE	FD_SETTING_NEW		;

	CMP	FLAG_USER_DISK,3	; 3=別のソフトが入っている
	JE	FD_SETTING_ANTHER	;

	JMP	FD_SETTING_ANTHER	;

FD_SETTING_NEW:
	MOV	SI,OFFSET MSG_01	; "ドライブ１のディスクを
	MOV	BX,4			;
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
	CALL	MENU_YESNO		; menu yes/no.
	CMP	AX,2			; 1=yes,2=no.
	JMPEQ	FD_SETTING_BREAK	;
	JMP	FD_SETTING_FORMAT	;

FD_SETTING_ANTHER:
	MOV	SI,OFFSET MSG_02	; "ドライブ１のディスクを
	MOV	BX,4			;
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
	CALL	MENU_YESNO		; menu yes/no.
	CMP	AX,2			; 1=yes,2=no.
	JMPEQ	FD_SETTING_BREAK	;

	PRINTM	3,"このディスクを本当にユーザディスク"
	PRINTM	4,"にして、いいですね。"
	CALL	MENU_YESNO		; menu yes/no.
	CMP	AX,2			; 1=yes,2=no.
	JMPEQ	FD_SETTING_BREAK	;

FD_SETTING_FORMAT:
	PRINTM	3,"ユーザディスク作成中"
	PRINTM	4,0

	MOV	AX,DRIVE_NUMBER		; ユーザディスクドライブ番号
	DEC	AX			; １ＭＦＤドライブ番号
	CALL	DKFDNO			; フォーマットのドライブ番号の設定
	CALL	DKFORM			; ディスクのフォーマット
	CMP	AX,0			; 0=正常
	JNE	FD_SETTING_ERROR	;

	JMP	FD_SETTING_EXIT		;

FD_SETTING_ERROR:
	CALL	ERROR_MSG		; エラーメッセージ
	PRINTM	4,"もういちど、挑戦しますか？"
	CALL	MENU_YESNO		; menu yes/no.
	PUSH	AX			;
	MOV	BX,2			; 2=ウインドウ・クローズ
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
	POP	AX			;
	CMP	AX,2			; 1=yes,2=no.
	JE	FD_SETTING_BREAK	;
	JMP	FD_SETTING_START	;

FD_SETTING_EXIT:
	MOV	BX,2			; 2=ウインドウ・クローズ
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
FD_SETTING_END:
	MOV	AX,0			; 0=正常
	RET
FD_SETTING_BREAK:
	MOV	BX,2			; 2=ウインドウ・クローズ
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
FD_SETTING_BREAK2:
	MOV	AX,1			; 1=強制終了
	RET
FD_SETTING	ENDP


; ****************************************************
;	ユーザディスクのサーチ
;	-O- DRIVE_NUMBER   : ユーザディスクドライブ番号(1-4)
;	    FLAG_USER_DISK : ユーザディスクフラグ
;			 1=ユーザディスク
;			 2=新しいディスク
;			 3=別のソフトが入っている
;	    USER_ST_BREAK  : ユーザＢＲＥＡＫ 1=強制終了
; ****************************************************

USERDK_SCH	PROC	NEAR
	CALL	DKCSET				; ディスクチェンジセット
	MOV	FLAG_USER_DISK,AX		; ユーザディスクフラグ
	MOV	DRIVE_NUMBER,DX			; ユーザディスクドライブ番号
	RET
USERDK_SCH	ENDP


; ****************************************************
;	エラーメッセージ
;	-I- AX :0=正常, 2=ディスクエラー
;		3=デバイスがノットレディ, 4=ライトプロテクト
; ****************************************************

ERROR_MSG	PROC	NEAR
	CMP	AX,4
	JLE	ERROR_MSG_MSG
	PRINTM	3,"なんか、ディスクの調子が悪いんですけど・・・"
	RET
ERROR_MSG_MSG:
	MOV	BX,AX				;
	SHL	BX,1				; word pointer.
	MOV	SI,DS:ERROR_MESSAGE[BX]		;
	MOV	BX,3				;
	CALL	WIDDISK				; WINDOWS/ディスクウインドウ
	RET
ERROR_MSG	ENDP


; ****************************************************
;	DATA
; ****************************************************
		EVEN

PUBLIC	USER_D_CURRENT			; ユーザディスク・カレント指定=1
PUBLIC	USER_D_FUNCTION			; ユーザディスク機能

EXTRN	USER_ST_BREAK:WORD		; ユーザＢＲＥＡＫ 1=強制終了
EXTRN	MXFLNAME:BYTE			; データファイル名

USER_D_CURRENT	DW	0		; ユーザディスク・カレント指定=1
USER_D_FUNCTION	DW	0		; ユーザディスク機能 1=ロード,2=セーブ
DRIVE_NUMBER	DW	0		; ユーザディスクドライブ番号(1-4)
FLAG_USER_DISK	DW	0		; ユーザディスクフラグ
					; 1=ユーザディスク
					; 2=新しいディスク
					; 3=別のソフトが入っている

MSG_01	DB	"ドライブ１のディスクをユーザディスクとします",0
MSG_02	DB	"ドライブ１のディスクをユーザディスクに…？",0
DRIVE_CHR	DB	"１２３４"

ERROR_MESSAGE	LABEL	WORD
		DW	MMNON
		DW	MMNON
		DW	ERR02
		DW	ERR03
		DW	ERR04
MMNON	DB	0
ERR02	DB	"ディスクの調子が、よくないよ。",0		;ディスクエラ
ERR03	DB	"ディスクをはずさないでよ！",0			;ノットレディ
ERR04	DB	"ちょっと、ライトプロテクトをとってよ！",0	;Ｗプロテクト

CODE	ENDS

	END
;
;	end of "USERDISK.ASM"
;
