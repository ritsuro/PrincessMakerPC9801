; "DSKCGX.ASM" PC-9801UV11 make by R.H 1991/03/09
;
;
;	ディスクチェンジャ
;
;	1991/03/09 ＤＳＫＣＨＧ．ＡＳＭをもとに改造
;
;	ＲＡＭドライブはスキップする。
;
;	ディスクＩＤの内容
;	byte
;	0-1	システムＩＤ
;	2-3	プログラムＩＤ
;	4-5	ディスク番号
;	6-23	システム予約
;	24-1023	ユーザ解放データ
;
;
;	プログラムＩＤ（MY_DISKPROG）
;	0001H : 電脳学園３
;	0002H : サイレントメビウス
;	0003H : 電脳学園１リメイク
;	0004H : プリンセス・メーカー <====
;
;
; GAME subroutine.

DEBUG	EQU	1		; デバックアセンブルフラグ
IF	DEBUG			; デバックアセンブルフラグ
INCLUDE	TSTSET.INC
ELSE
;	デバックマクロダミー化
PRV	MACRO
	ENDM
PRF	MACRO
	ENDM
PRS	MACRO
	ENDM
PRVH	MACRO
	ENDM
ENDIF


MY_DISKSYSNAME	EQU	1111H	; このシステムＩＤ
MY_DISKPROG	EQU	0004H	; このプログラムＩＤ(2=silent,3=DEN1,4=PRI)
MY_DISKNUMSYS	EQU	1	; このシステムディスク番号
MY_DISKNUMD2	EQU	2	; このディスク２の番号
MY_DISKNUMD3	EQU	3	; このディスク３の番号
MY_DISKNUMD4	EQU	4	; このディスク４の番号
MY_DISKNUMD5	EQU	5	; このディスク５の番号
MY_DISKNUMD6	EQU	6	; このディスク６の番号
MY_DISKNUMD7	EQU	7	; このディスク７の番号
MY_DISKNUM_USR	EQU	99	; このユーザディスクの番号

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	DKCSET			; ディスクチェンジセット
PUBLIC	DKCIDW			; ディスクＩＤの書き込み
PUBLIC	FDDOOR			; ＦＤドライブドア開閉チェック

EXTRN	USER_SHOT:NEAR		; ユーザスタンバイ

EXTRN	DISKRESET:NEAR		; disk reset.

EXTRN	WIDDISK:NEAR		; WINDOWS/ディスクウインドウ
				; その引数
				; -I- BX : 1=ウインドウ・オープン
				;        : 2=ウインドウ・クローズ
				;        : 3=ウインドウ・メッセージ／上段
				;        : 4=ウインドウ・メッセージ／中段
				;        : 5=ウインドウ・メッセージ／下段
				;  DS:SI : メッセージ・アドレス


DCYL_ID		EQU	0		; ディスクＩＤ　シリンダ番号（Ｃ）
DHEAD_ID	EQU	1		; ディスクＩＤ　ヘッド番号（Ｈ）
DSECR_ID	EQU	3		; ディスクＩＤ　セクタ番号（Ｒ）

DCYL_DIR	EQU	0		; ＲＯＯＴ　シリンダ番号（Ｃ）
DHEAD_DIR	EQU	0		; ＲＯＯＴ　ヘッド番号（Ｈ）
DSECR_DIR	EQU	6		; ＲＯＯＴ　セクタ番号（Ｒ）

ID_LEN		EQU	10		; ディスクＩＤバイト数

DRVNUMMAX_FIX	EQU	4		; １ＭＦＤ固定ドライブ数

DISK_RESULT_TOP	EQU	0564H		; リザルトステータス情報アドレス
DISK_EQUIP	EQU	055CH		; 接続ユニット
RDISK_EQUIP	EQU	0488H		; ＲＡＭドライブ接続状況識別ビット

DISK_STATUS_DB	EQU	20H		; DMA Boundary. メモリアドレスがＤＭＡ
					; に向いていない（バンクにまたがった）
DISK_STATUS_NR	EQU	60H		; Not Ready. ユニットがノットレディ状態
DISK_STATUS_WP	EQU	10H		; Write Protect.ライトプロテクト状態

;		５’２ＨＤの場合です

DIRMAX		EQU	192		; ディレクトリ最大数
SEC_BYTE	EQU	1024		; セクタバイト数
FATSECTOR 	EQU	4		; ＦＡＴテーブルセクタ数
ROOTSECTOR 	EQU	6		; ＲＯＯＴＤＩＲセクタ数
CLAST_OFFSET	EQU	8+1		; クラスタ開始位置のセクタオフセット

READ_RETCOUNT 	EQU	1		; リード・リトライ回数
WRITE_RETCOUNT 	EQU	10		; セクタ書き込み・リトライ回数


;	ＰＲＩＮＴＭ	”表示文字列”

PRINTM	MACRO	NUM,STRING
	LOCAL	L1,L2
	PUSH	SI
	JMP	L2
L1	DB	STRING,0DH,0AH,0
L2:	MOV	SI,OFFSET L1
	MOV	BX,NUM
	CALL	MESSAGE_SET		; メッセージ
	POP	SI
	ENDM


;	ＰＲＩＮＴＳＩ

PRINTSI	MACRO	STRING
	PUSH	SI
	CALL	PRINT
	POP	SI
	ENDM


;	ディスクチェンジセット
;	-O- DX : (DRVNUM+1)ドライブ番号(1-4)
;	    AX : 1=ユーザディスク
;		 2=新しいディスク
;		 3=別のソフトが入っている
;	    USER_ST_BREAK  : 1=強制終了

DKCSET	PROC	NEAR
	MOV	AX,MY_DISKNUM_USR	; このユーザディスクの番号
	MOV	DIRDISK,AX		; 対象ディスク番号

	MOV	FLAG_WIDOPEN,0		; ウインドウオープンフラグ

	CALL	USER_STANBY_SETUP	; ユーザ、スタンバイセットアップ

	CALL	INSDSK			; ディスクを挿入させる
	CMP	USER_ST_BREAK,1		; 1=強制終了
	JE	DKCSET_5		;

	CMP	FLAG_USER_DISK,1	; 1=ユーザディスク
	JNE	DKCSET_EXIT		;
DKCSET_5:
	CMP	FLAG_WIDOPEN,0		; ウインドウオープンフラグ
	JE	DKCSET_EXIT		;
	MOV	BX,2			; 2=ウインドウ・クローズ
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
DKCSET_EXIT:
	MOV	DX,DRVNUM		; 指定ディスクのドライブ番号
	INC	DX			;
	MOV	AX,FLAG_USER_DISK	; ユーザディスクフラグ

	RET
DKCSET	ENDP


;	メッセージ
;	-I- BX : 1=ウインドウ・オープン
;	       : 2=ウインドウ・クローズ
;	       : 3=ウインドウ・メッセージ／上段
;	       : 4=ウインドウ・メッセージ／中段
;	       : 5=ウインドウ・メッセージ／下段
;	 DS:SI : メッセージ・アドレス

MESSAGE_SET	PROC	NEAR
	CMP	FLAG_WIDOPEN,1		; ウインドウオープンフラグ
	JE	MESSAGE_SET_PR		;

	CMP	BYTE PTR DS:[SI],0	; 文字なしはスキップ
	JE	MESSAGE_SET_EXIT	;

	MOV	FLAG_WIDOPEN,1		; ウインドウオープンフラグ
	PUSH	BX			;
	PUSH	SI			;
	MOV	BX,1			; 1=ウインドウ・オープン
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ
	POP	SI			;
	POP	BX			;
MESSAGE_SET_PR:				;
	CALL	WIDDISK			; WINDOWS/ディスクウインドウ

MESSAGE_SET_EXIT:
	RET
MESSAGE_SET	ENDP




;	ディスクＩＤの書き込み
;	-I- AX : ドライブ番号（１ー４）
;	    DX : ディスク番号
;	-O- AX : 0=通常
;	       : 1=ディスクはセットされていない
;	       : 2=違うディスクみたい

DKCIDW	PROC	NEAR
	PUSH	DX

	DEC	AX		; ドライブ番号

	PRV	"ドライブ番号=",AX
	PRV	"ディスク番号=",DX

	MOV	DRVNUM,AX		; １ＭＦＤドライブ番号（０ー３）

	MOV	AX,MY_DISKSYSNAME	; このシステムＩＤ
	MOV	ID_DISKSYSNAME,AX	; システムＩＤ

	MOV	AX,MY_DISKPROG		; このプログラムＩＤ
	MOV	ID_DISKPROG,AX		; プログラムＩＤ

	MOV	ID_DISKNUMBER,DX	; ディスク番号

	CALL	IDPUT			; 汎用変数の内容をＩＤテーブルへセット

	CALL	DSKIDSET		; ディスクＩＤの書き込み

	PRV	"0=通常,1=セットされていない,2=違うディスク AX=",AX

	POP	DX
	RET
DKCIDW	ENDP


;	指定ディスクを挿入させる
;	-I- DIRDISK : 対象ディスク番号
;	-O- DRVNUM  : 指定ディスクのドライブ番号
;	    FLAG_USER_DISK :	1=ユーザディスク
;				2=新しいディスク
;				3=別のソフトが入っている
;	    USER_ST_BREAK  : 1=強制終了

INSDSK	PROC	NEAR
	PRV	"対象ディスク番号=",DIRDISK 

	MOV	AX,DIRDISK		; 対象ディスク番号
	MOV	SCH_DISKID,AX		; 検索ディスクＩＤ
	CALL	SYSDRVCHK		; 対象ディスクのドライブ検索
	CMP	AX,0			; 0=対象ディスクはセットされています
	JE	INSDSK_OK		;

	CALL	NXTDRVCHK		; 次候補ディスクのドライブ検索
	CMP	AX,0			; 0=対象ディスクはセットされています
	JE	INSDSK_OK		;

	MOV	AX,DIRDISK		; 対象ディスク番号
	MOV	SCH_DISKID,AX		; 検索ディスクＩＤ
	CALL	MSG_DISKSET		; ディスクセットのメッセージ

	MOV	AX,DIRDISK		; 対象ディスク番号
	MOV	SCH_DISKID,AX		; 検索ディスクＩＤ
	CALL	INSDRIVE_WAIT		; ドライブにセットされるのを待つ
INSDSK_OK:
	PRINTM	4,0			; ２行目クリア
	PRINTM	5,0			; ３行目クリア
	PRV	"指定ディスクのドライブ番号=",DRVNUM
	RET
INSDSK	ENDP



;	ディスクセットのメッセージ
;	-I- SCH_DISKID : 検索ディスクＩＤ

MSG_DISKSET	PROC	NEAR
	PRINTM	3,"ドライブ２に、ユーザディスクか"
	PRINTM	4,"２ＨＤの新しいディスクをいれて下さい"
	RET
MSG_DISKSET	ENDP



;	ドライブにセットされるのを待つ
;	-I- SCH_DISKID : 検索ディスクＩＤ
;	-O- DRVNUM     : ドライブ番号（０ー３）
;	    FLAG_USER_DISK :	1=ユーザディスク
;				2=新しいディスク
;				3=別のソフトが入っている
;				4=フォーマット済みディスク
;	    USER_ST_BREAK  : 1=強制終了

INSDRIVE_WAIT	PROC	NEAR
	MOV	AX,DRVNUMMAX		; １ＭＦＤドライブ数
	MOV	DRVNUM,AX		; ドライブ番号（０ー３）

	MOV	USER_ST_BREAK,0		; 1=強制終了

INSDRIVE_WAIT_LOOP:
	CMP	DRVNUM,0		; if DRVNUM = 0 then DRVNUM=DRVNUMMAX
	JNE	INSDRIVE_WAIT4		;
	MOV	AX,DRVNUMMAX		; １ＭＦＤドライブ数
	MOV	DRVNUM,AX		; ドライブ番号（０ー３）
INSDRIVE_WAIT4:
	DEC	DRVNUM			; ドライブ番号（０ー３）
	MOV	AX,DRVNUM		;
	CALL	FDDOOR			; ＦＤドライブドア開閉チェック
	CMP	AX,1			; 0=前と変わらず,1=ドアを開閉した
					; 2=ドアが開きっぱなし
	JE	INSDRIVE_WAIT_CHK	;
	CMP	USER_ST_BREAK,1		; 1=強制終了
	JMPEQ	INSDRIVE_WAIT_BREAK	;

INSDRIVE_WAIT_NEXT:
	JMP	INSDRIVE_WAIT_LOOP

INSDRIVE_WAIT_CHK:
	MOV	AX,DRVNUM		;
	CALL	RAM_DR_EQUIP		; ＲＡＭドライブ接続チェック
	CMP	FLAG_RAM_DR,1		; RAMドライブ接続 1=接続されている
	JE	INSDRIVE_WAIT_NEXT	;

	CALL	DSKIDCHK		; ディスクＩＤの読みだし
	CMP	AX,1			; 0=通常
	JE	INSDRIVE_WAIT_NEXT	; 1=ディスクはセットされていない
	CMP	AX,2			;
	JMPEQ	INSDRIVE_WAIT_UNFORMAT	; 2=違うディスクみたい

INSDRIVE_WAIT_6:
	CALL	IDGET			; ＩＤを汎用変数へセット

	MOV	AX,ID_DISKSYSNAME	; システムＩＤ
	CMP	AX,MY_DISKSYSNAME	; このシステムＩＤ
	JE	INSDRIVE_WAIT_SYS_OK	;

	JMP	INSDRIVE_WAIT_ANTHER_DISK_OK

INSDRIVE_WAIT_SYS_OK:			;
	MOV	AX,ID_DISKPROG		; プログラムＩＤ
	CMP	AX,MY_DISKPROG		; このプログラムＩＤ
	JE	INSDRIVE_WAIT_PROG_OK	;

	JMP	INSDRIVE_WAIT_ANTHER_DISK_OK

INSDRIVE_WAIT_PROG_OK:			;
	MOV	AX,ID_DISKNUMBER	; ディスク番号
	CMP	AX,SCH_DISKID		; 検索ディスクＩＤ
	JMPEQ	INSDRIVE_WAIT_DISK_OK	;

	PRINTM	3,"このディスクではないですよ"
	PRINTM	4,"ドライブ２に、ユーザディスクか"
	PRINTM	5,"２ＨＤの新しいディスクをいれて下さい"

	JMP	INSDRIVE_WAIT_NEXT	;

INSDRIVE_WAIT_UNFORMAT:			; 未フォーマットディスク
INSDRIVE_WAIT_NEWFORMAT:		; フォーマットのみディスク
	PRINTM	3,"新しいディスクです"

	JMP	INSDRIVE_WAIT_NEW_DISK_OK

INSDRIVE_WAIT_DISK_OK:
	MOV	FLAG_USER_DISK,1	; 1=ユーザディスク
	RET
INSDRIVE_WAIT_NEW_DISK_OK:
	MOV	FLAG_USER_DISK,2	; 2=新しいディスク
	RET
INSDRIVE_WAIT_ANTHER_DISK_OK:
	CALL	DIR_CHECK		; ディレクトリィチェック
	CMP	AX,0			; 0=あたらしい,1=データ有り
	JE	INSDRIVE_WAIT_NEWFORMAT	; フォーマットのみディスク

	CALL	CHECK_WP		; ライトプロテクトチェック
	CMP	FLAG_W_PROTECT,1	; フラグ・ライトプロテクト 1=ﾌﾟﾛﾃｸﾄ
	JMPEQ	INSDRIVE_WAIT_NEXT	;

	PRINTM	3,"これはちがうソフトのディスクですね"
	MOV	FLAG_USER_DISK,3	; 3=別のソフトが入っている
	RET
INSDRIVE_WAIT_BREAK:
	MOV	FLAG_USER_DISK,0
	RET
INSDRIVE_WAIT	ENDP



;	対象ディスクのドライブ検索
;	-I- SCH_DISKID	: 検索ディスクＩＤ
;	-O- AX		: 0=対象ディスクはセットされています
;			  1=対象ディスクが挿入されていません
;	    DRVNUM	: 対象ディスクのドライブ番号
;	    FLAG_USER_DISK :	1=ユーザディスク
;				2=新しいディスク
;				3=別のソフトが入っている

SYSDRVCHK	PROC	NEAR
	PRV	"検索ディスクＩＤ=",SCH_DISKID

	MOV	AX,DRVNUMMAX		; １ＭＦＤドライブ数
	MOV	DRVNUM,AX		; ドライブ番号（０ー３）
SYSDRVCHK_LOOP:
	CMP	DRVNUM,0		; if DRVNUM = 0 then DRVNUM=DRVNUMMAX
	JNE	SYSDRVCHK2		;
	JMP	SYSDRVCHK_NONE		; 見つからなかった
SYSDRVCHK2:
	DEC	DRVNUM			; ドライブ番号（０ー３）

	MOV	AX,DRVNUM		;
	CALL	RAM_DR_EQUIP		; ＲＡＭドライブ接続チェック
	CMP	FLAG_RAM_DR,1		; RAMドライブ接続 1=接続されている
	JE	SYSDRVCHK_NEXT		;

	CALL	DSKIDCHK		; ディスクＩＤの読みだし
	CMP	AX,1			; 1=ディスクはセットされていない
	JE	SYSDRVCHK_NEXT		;
	CMP	AX,2			; 2=違うディスクみたい
	JE	SYSDRVCHK_NEXT		;

	CALL	IDGET			; ＩＤを汎用変数へセット

	MOV	AX,ID_DISKSYSNAME	; システムＩＤ
	CMP	AX,MY_DISKSYSNAME	; このシステムＩＤ
	JNE	SYSDRVCHK_NEXT		;

	MOV	AX,ID_DISKPROG		; プログラムＩＤ
	CMP	AX,MY_DISKPROG		; このプログラムＩＤ
	JNE	SYSDRVCHK_NEXT		;

	MOV	AX,ID_DISKNUMBER	; ディスク番号
	CMP	AX,SCH_DISKID		; 検索ディスクＩＤ
	JNE	SYSDRVCHK_NEXT		;

	JMP	SYSDRVCHK_DISK_OK	; このディスクが対象ディスクです
SYSDRVCHK_NEXT:
	JMP	SYSDRVCHK_LOOP		;

SYSDRVCHK_DISK_OK:
	MOV	FLAG_USER_DISK,1	; 1=ユーザディスク
	JMP	SYSDRVCHK_OK		;
SYSDRVCHK_NEW_DISK_OK:
	MOV	FLAG_USER_DISK,2	; 2=新しいディスク
	JMP	SYSDRVCHK_OK		;
SYSDRVCHK_ANTHER_DISK_OK:
	MOV	FLAG_USER_DISK,3	; 3=別のソフトが入っている
	JMP	SYSDRVCHK_OK		;

SYSDRVCHK_OK:
	MOV	AX,0			; 0=対象ディスクはセットされています
	JMP	SYSDRVCHK_EXIT
SYSDRVCHK_NONE:
	MOV	AX,1			; 1=対象ディスクが挿入されていません
SYSDRVCHK_EXIT:
	RET
SYSDRVCHK	ENDP


;	次候補ディスクのドライブ検索
;	-I- SCH_DISKID	: 検索ディスクＩＤ
;	-O- AX		: 0=対象ディスクはセットされています
;			  1=対象ディスクが挿入されていません
;	    DRVNUM	: 対象ディスクのドライブ番号
;	    FLAG_USER_DISK :	1=ユーザディスク
;				2=新しいディスク
;				3=別のソフトが入っている

NXTDRVCHK	PROC	NEAR
	PRV	"検索ディスクＩＤ=",SCH_DISKID

	MOV	AX,DRVNUMMAX		; １ＭＦＤドライブ数
	MOV	DRVNUM,AX		; ドライブ番号（０ー３）
NXTDRVCHK_LOOP:
	CMP	DRVNUM,0		; if DRVNUM = 0 then DRVNUM=DRVNUMMAX
	JNE	NXTDRVCHK2		;
	JMP	NXTDRVCHK_NONE		; 見つからなかった
NXTDRVCHK2:
	DEC	DRVNUM			; ドライブ番号（０ー３）

	MOV	AX,DRVNUM		;
	CALL	RAM_DR_EQUIP		; ＲＡＭドライブ接続チェック
	CMP	FLAG_RAM_DR,1		; RAMドライブ接続 1=接続されている
	JE	NXTDRVCHK_NEXT		;

	CALL	DSKIDCHK		; ディスクＩＤの読みだし
	CMP	AX,1			; 1=ディスクはセットされていない
	JE	NXTDRVCHK_NEXT		;
	CMP	AX,2			; 2=違うディスクみたい
	JE	NXTDRVCHK_NEW_DISK_OK	;

	CALL	IDGET			; ＩＤを汎用変数へセット

	MOV	AX,ID_DISKSYSNAME	; システムＩＤ
	CMP	AX,MY_DISKSYSNAME	; このシステムＩＤ
	JNE	NXTDRVCHK_ANTHER_DISK_OK

	MOV	AX,ID_DISKPROG		; プログラムＩＤ
	CMP	AX,MY_DISKPROG		; このプログラムＩＤ
	JNE	NXTDRVCHK_ANTHER_DISK_OK

	MOV	AX,ID_DISKNUMBER	; ディスク番号
	CMP	AX,SCH_DISKID		; 検索ディスクＩＤ
	JNE	NXTDRVCHK_NEXT		;

	JMP	NXTDRVCHK_DISK_OK	; このディスクが対象ディスクです
NXTDRVCHK_NEXT:
	JMP	NXTDRVCHK_LOOP		;

NXTDRVCHK_DISK_OK:
	MOV	FLAG_USER_DISK,1	; 1=ユーザディスク
	JMP	NXTDRVCHK_OK		;

NXTDRVCHK_NEW_DISK_OK:
	PRINTM	3,"新しいディスクです"
	MOV	FLAG_USER_DISK,2	; 2=新しいディスク
	JMP	NXTDRVCHK_OK		;

NXTDRVCHK_ANTHER_DISK_OK:
	CALL	DIR_CHECK		; ディレクトリィチェック
	CMP	AX,0			; 0=あたらしい,1=データ有り
	JE	NXTDRVCHK_NEW_DISK_OK	;

	CALL	CHECK_WP		; ライトプロテクトチェック
	CMP	FLAG_W_PROTECT,1	; フラグ・ライトプロテクト 1=ﾌﾟﾛﾃｸﾄ
	JMPEQ	NXTDRVCHK_NEXT		;

	PRINTM	3,"これはちがうソフトのプログラムですね"
	MOV	FLAG_USER_DISK,3	; 3=別のソフトが入っている
	JMP	NXTDRVCHK_OK		;

NXTDRVCHK_OK:
	MOV	AX,0			; 0=対象ディスクはセットされています
	JMP	NXTDRVCHK_EXIT
NXTDRVCHK_NONE:
	MOV	AX,1			; 1=対象ディスクが挿入されていません
NXTDRVCHK_EXIT:
	RET
NXTDRVCHK	ENDP


;	ディレクトリィチェック
;	-I- DRVNUM : 対象ディスクのドライブ番号
;	-O- AX     : 0=あたらしい,1=データ有り

DIR_CHECK	PROC	NEAR
	MOV	AX,DRVNUM	;
	CALL	DRVSET		; ドライブ番号の設定（０ー３）

	MOV	AX,DCYL_DIR	; ＲＯＯＴ　シリンダ番号（Ｃ）
	MOV	DCYL,AX		; シリンダ番号（Ｃ）０ー７６
	MOV	AX,DHEAD_DIR	; ＲＯＯＴ　ヘッド番号（Ｈ）
	MOV	DHEAD,AX	; ヘッド番号（Ｈ）０ー１
	MOV	AX,DSECR_DIR	; ＲＯＯＴ　セクタ番号（Ｒ）
	MOV	DSECR,AX	; セクタ番号（Ｒ）１ー８（２６）

	CALL	SCREAD		; セクターリード
	PRV	"DIR_CHECK call-O-scread DERROR=",DERROR
	CMP	DERROR,0	; 0=正常,1=エラー
	JNE	DIR_CHECK_NEW	;

	MOV	SI,SCADRS	; セクタバッファアドレス
	CMP	DS:[SI],BYTE PTR 0
	JNE	DIR_CHECK_ARI	;

DIR_CHECK_NEW:
	MOV	AX,0		; 0=あたらしい
	RET
DIR_CHECK_ARI:
	MOV	AX,1		; 1=データ有り
	RET
DIR_CHECK	ENDP


;	ＩＤテーブルの内容を汎用変数へセット
;	-I- DRVNUM : １ＭＦＤドライブ番号（０ー３）
;	    ID_DISKSYSNAME : システムＩＤ
;	    ID_DISKPROG    : プログラムＩＤ
;	    ID_DISKNUMBER  : ディスク番号

IDGET	PROC	NEAR
	PRV	"１ＭＦＤドライブ番号=",DRVNUM

	MOV	BX,DRVNUM		; ドライブ番号
	SHL	BX,1			; word pointer.
	MOV	SI,DS:DSKID_ADRS[BX]	; ディスクＩＤアドレステーブル
	MOV	AX,DS:[SI][0]		;
	MOV	ID_DISKSYSNAME,AX	; システムＩＤ
	MOV	AX,DS:[SI][2]		;
	MOV	ID_DISKPROG,AX		; プログラムＩＤ
	MOV	AX,DS:[SI][4]		;
	MOV	ID_DISKNUMBER,AX	; ディスク番号

	PRVH	"システムＩＤ  =",ID_DISKSYSNAME
	PRVH	"プログラムＩＤ=",ID_DISKPROG
	PRV	"ディスク番号  =",ID_DISKNUMBER

	RET
IDGET	ENDP


;	ディスクＩＤの読みだし
;	-I- DRVNUM : １ＭＦＤドライブ番号（０ー３）
;	-O- DSKID_ADRS[AX*2] : ＩＤテーブル
;	    DSKID0 : ドライブ０のＩＤテーブル
;	    DSKID1 : ドライブ１のＩＤテーブル
;	    DSKID2 : ドライブ２のＩＤテーブル
;	    DSKID3 : ドライブ３のＩＤテーブル
;	    AX     : 0=通常
;	           : 1=ディスクはセットされていない
;	           : 2=違うディスクみたい
;	-I/O- DATA:[+SCADRS] : セクタのデータ

DSKIDCHK	PROC	NEAR
	PRV	"ディスクＩＤの読みだし:１ＭＦＤドライブ番号=",DRVNUM

	MOV	AX,DRVNUM	;
	CALL	FDDOOR		; ＦＤドライブドア開閉チェック
	CMP	AX,0		; 0=前と変わらず,1=ドアを開閉した
	JE	DSKIDCHK_OK	;
	CMP	AX,2		; 2=ドアが開きっぱなし
	JE	DSKIDCHK_NOT_RDY

	MOV	AX,DRVNUM	;
	CALL	READIDSEC	; ＩＤセクタの読みだし
	CMP	AX,1		; 1=リードエラー
	JE	DSKIDCHK_ERROR	;
	CMP	AX,2		; 2=ノットレディ
	JE	DSKIDCHK_NOT_RDY;
DSKIDCHK_OK:
	MOV	AX,0		; 0=通常
	RET
DSKIDCHK_NOT_RDY:
	MOV	AX,1		; 1=ディスクはセットされていない
	RET
DSKIDCHK_ERROR:
	MOV	AX,2		; 2=違うディスクみたい
	RET
DSKIDCHK	ENDP



;	ＩＤセクタの読みだし
;	-I- AX : １ＭＦＤドライブ番号（０ー３）
;	-O- DSKID_ADRS[AX*2] : ＩＤテーブル
;	    DSKID0 : ドライブ０のＩＤテーブル
;	    DSKID1 : ドライブ１のＩＤテーブル
;	    DSKID2 : ドライブ２のＩＤテーブル
;	    DSKID3 : ドライブ３のＩＤテーブル
;	    AX     : 0=正常,1=リードエラー,2=ノットレディ
;	-I/O- DATA:[+SCADRS] : セクタのデータ

READIDSEC	PROC	NEAR
	CALL	DRVSET		; ドライブ番号の設定（０ー３）

	MOV	AX,DCYL_ID	; ディスクＩＤ　シリンダ番号
	MOV	DCYL,AX		; シリンダ番号（Ｃ）０ー７６
	MOV	AX,DHEAD_ID	; ディスクＩＤ　ヘッド番号
	MOV	DHEAD,AX	; ヘッド番号（Ｈ）０ー１
	MOV	AX,DSECR_ID	; ディスクＩＤ　セクタ番号
	MOV	DSECR,AX	; セクタ番号（Ｒ）１ー８（２６）

	CALL	SCREAD		; セクターリード
	PRV	"READIDSEC call-O-scread DERROR=",DERROR
	CMP	DERROR,0	; 0=正常,1=エラー
	JNE	READIDSEC_ERROR	;

	CALL	DRVNO		; ドライブ番号の取得
	MOV	BX,AX		;
	SHL	BX,1		; word pointer.
	MOV	DI,DS:DSKID_ADRS[BX] ; ディスクＩＤアドレステーブル
	MOV	AX,DS		;
	MOV	ES,AX		;
	MOV	SI,SCADRS	; セクタバッファアドレス
	MOV	CX,ID_LEN	; ディスクＩＤバイト数
	REP	MOVSB		;

	MOV	AX,0		; 0=正常
	RET
READIDSEC_ERROR:
	CMP	DSTAT,DISK_STATUS_NR	; Not Ready. ユニットがノットレディ状態
	JE	READIDSEC_ERROR2	;
	MOV	AX,1			; 1=リードエラー
	RET
READIDSEC_ERROR2:
	MOV	AX,2			; 2=ノットレディ
	RET
READIDSEC	ENDP


;	汎用変数の内容をＩＤテーブルへセット
;	-I- DRVNUM : １ＭＦＤドライブ番号（０ー３）
;	    ID_DISKSYSNAME : システムＩＤ
;	    ID_DISKPROG    : プログラムＩＤ
;	    ID_DISKNUMBER  : ディスク番号

IDPUT	PROC	NEAR
	PRV	"１ＭＦＤドライブ番号=",DRVNUM
	PRVH	"システムＩＤ  =",ID_DISKSYSNAME
	PRVH	"プログラムＩＤ=",ID_DISKPROG
	PRV	"ディスク番号  =",ID_DISKNUMBER

	MOV	BX,DRVNUM	; ドライブ番号
	SHL	BX,1		; word pointer.
	MOV	SI,DS:DSKID_ADRS[BX]	; ディスクＩＤアドレステーブル
	MOV	AX,ID_DISKSYSNAME	; システムＩＤ
	MOV	DS:[SI][0],AX		;
	MOV	AX,ID_DISKPROG		; プログラムＩＤ
	MOV	DS:[SI][2],AX		;
	MOV	AX,ID_DISKNUMBER	; ディスク番号
	MOV	DS:[SI][4],AX		;
	RET
IDPUT	ENDP


;	ディスクＩＤの書き込み
;	-I- DRVNUM : １ＭＦＤドライブ番号（０－３）
;	    DSKID_ADRS[AX*2] : ＩＤテーブル
;	    DSKID0 : ドライブ０のＩＤテーブル
;	    DSKID1 : ドライブ１のＩＤテーブル
;	    DSKID2 : ドライブ２のＩＤテーブル
;	    DSKID3 : ドライブ３のＩＤテーブル
;	-O- AX     : 0=通常
;	           : 1=ディスクはセットされていない
;	           : 2=違うディスクみたい
;	-I/O- DATA:[+SCADRS] : セクタのデータ

DSKIDSET	PROC	NEAR
	PRV	"ディスクＩＤの書き込み:１ＭＦＤドライブ番号=",DRVNUM

	MOV	AX,DRVNUM	;
	CALL	FDDOOR		; ＦＤドライブドア開閉チェック
	CMP	AX,2		; 2=ドアが開きっぱなし
	JE	DSKIDSET_NOT_RDY

	MOV	AX,DRVNUM	;
	CALL	WRITEIDSEC	; ＩＤセクタの書き込み
	CMP	AX,0		; 0=正常,1=リードエラー
	JNE	DSKIDSET_ERROR	;
DSKIDSET_OK:
	MOV	AX,0		; 0=通常
	RET
DSKIDSET_NOT_RDY:
	MOV	AX,1		; 1=ディスクはセットされていない
	RET
DSKIDSET_ERROR:
	MOV	AX,2		; 2=違うディスクみたい
	RET
DSKIDSET	ENDP



;	ＩＤセクタの書き込み
;	-I- AX : １ＭＦＤドライブ番号（０ー３）
;	    DSKID_ADRS[AX*2] : ＩＤテーブル
;	    DSKID0 : ドライブ０のＩＤテーブル
;	    DSKID1 : ドライブ１のＩＤテーブル
;	    DSKID2 : ドライブ２のＩＤテーブル
;	    DSKID3 : ドライブ３のＩＤテーブル
;	-O- AX     : 0=正常,1=ライトエラー,2=ノットレディ
;	-I/O- DATA:[+SCADRS] : セクタのデータ

WRITEIDSEC	PROC	NEAR
	CALL	DRVSET		; ドライブ番号の設定（０ー３）

	MOV	BX,AX		;
	SHL	BX,1		; word pointer.
	MOV	SI,DS:DSKID_ADRS[BX] ; ディスクＩＤアドレステーブル
	MOV	AX,DS		;
	MOV	ES,AX		;
	MOV	DI,SCADRS	; セクタのデータ
	MOV	CX,ID_LEN	; ディスクＩＤバイト数
	REP	MOVSB		;

	MOV	AX,DCYL_ID	; ディスクＩＤ　シリンダ番号
	MOV	DCYL,AX		; シリンダ番号（Ｃ）０ー７６
	MOV	AX,DHEAD_ID	; ディスクＩＤ　ヘッド番号
	MOV	DHEAD,AX	; ヘッド番号（Ｈ）０ー１
	MOV	AX,DSECR_ID	; ディスクＩＤ　セクタ番号
	MOV	DSECR,AX	; セクタ番号（Ｒ）１ー８（２６）

	CALL	SCWRITE		; セクターリード
	CMP	DERROR,0	; 0=正常,1=エラー
	JNE	WRITEIDSEC_ERROR

	MOV	AX,0		; 0=正常
	RET
WRITEIDSEC_ERROR:
	CMP	DSTAT,DISK_STATUS_NR	; Not Ready. ユニットがノットレディ状態
	JE	WRITEIDSEC_ERROR2	;
	MOV	AX,1			; 1=ライトエラー
	RET
WRITEIDSEC_ERROR2:
	MOV	AX,2			; 2=ノットレディ
	RET
WRITEIDSEC	ENDP





;	セクターリード
;	バウンダリングエラーの為、ＳＣＡＤＲＳが変更される場合がある
;	-I- DCYL  : シリンダ番号（Ｃ）０ー７６
;	    DHEAD : ヘッド番号（Ｈ）０ー１
;	    DSECR : セクタ番号（Ｒ）１ー８（２６）
;	-O- SCADRS : セクタバッファアドレス
;	    DATA:[+SCADRS] : セクタのデータ
;	    DERROR : 0=正常,1=エラー
;	    DSTAT  : ステータス情報

SCREAD	PROC	NEAR
	CALL	FDISKRESET	; ディスクリセット

	PRVH	"r DUNIT ",DUNIT; デバイス識別・ユニット番号(DA/UA)
	PRVH	"r DLEN  ",DLEN	; データ長（ＤＴＬ）（バイト単位）
	PRVH	"r DCYL  ",DCYL ; シリンダ番号（Ｃ）０ー７６
	PRVH	"r DHEAD ",DHEAD; ヘッド番号（Ｈ）０ー１
	PRVH	"r DSECR ",DSECR; セクタ番号（Ｒ）１ー８（２６）
	PRVH	"r DSECN ",DSECN; セクタ長（Ｎ）

	MOV	AX,READ_RETCOUNT; リード・リトライカウンタ
	MOV	READ_RETRY,AX	;

SCREAD5:
	MOV	AX,DS		; セクタバッファ
	MOV	ES,AX		;
	MOV	BP,SCADRS	; セクタバッファアドレス

	MOV	AL,BYTE PTR DUNIT ; デバイス識別・ユニット番号(DA/UA)
	MOV	BX,WORD PTR DLEN  ; データ長（ＤＴＬ）（バイト単位）
	MOV	CL,BYTE PTR DCYL  ; シリンダ番号（Ｃ）０ー７６
	MOV	DH,BYTE PTR DHEAD ; ヘッド番号（Ｈ）０ー１
	MOV	DL,BYTE PTR DSECR ; セクタ番号（Ｒ）１ー８（２６）
	MOV	CH,BYTE PTR DSECN ; セクタ長（Ｎ）
	MOV	AH,BYTE PTR DREAD ; ＲＥＡＤ　ＤＡＴＡ
	INT	1BH		  ; ディスクＢＩＯＳ
	MOV	BYTE PTR DSTAT,AH ; ステータス情報

	JB	SCREAD555	  ;
	JMP	SCREAD9		  ; 正常終了
SCREAD555:

	CMP	BYTE PTR DSTAT,DISK_STATUS_DB
				; DMA Boundary.メモリアドレスがＤＭＡ
				; に向いていない（バンクにまたがった）
	JNE	SCREAD6
	PRF	"致命的なエラー( WRITE SECTOR:error DB )"

	MOV	SCADRS,OFFSET SCDATA2	; セクタバッファアドレス
	JMP	SCREAD5			; ＤＭＡバッファの変更


SCREAD6:
	DEC	READ_RETRY	  ; リード・リトライカウンタ
	JZ	SCREAD99

	MOV	AH,BYTE PTR DRECAL ; ＲＥＣＡＬＩＢＲＡＴＥ
	INT	1BH		   ; ディスクＢＩＯＳ
	MOV	BYTE PTR DSTAT,AH  ; ステータス情報
	PRVH	"R recalibrate DSTAT=",DSTAT

	JMP	SCREAD5
SCREAD9:
	MOV	DERROR,0	; 0=正常
	RET
SCREAD99:
	MOV	DERROR,1	; 1=エラー
	MOV	AX,2
;*NON*;	CALL	SCERROR		; ディスクＩ／Ｏエラーの通知
	RET
SCREAD	ENDP



;	セクター書き込み
;	バウンダリングエラーの為、ＳＣＡＤＲＳが変更される場合がある
;	-I- DATA:[+SCADRS] : セクタのデータ
;	    DCYL          : シリンダ番号（Ｃ）０ー７６
;	    DHEAD         : ヘッド番号（Ｈ）０ー１
;	    DSECR         : セクタ番号（Ｒ）１ー２６
;	-O- SCADRS        : セクタバッファアドレス
;	    DERROR        : 0=正常,1=エラー
;	    DSTAT         : ステータス情報

SCWRITE	PROC	NEAR
	CALL	FDISKRESET	; ディスクリセット

SCWRITE0:
	MOV	AH,BYTE PTR DSENSE ; ＳＥＮＳＥ
	MOV	AL,BYTE PTR DUNIT ; デバイス識別・ユニット番号(DA/UA)
	INT	1BH		  ; ディスクＢＩＯＳ
	MOV	BYTE PTR DSTAT,AH ; ステータス情報
	TEST	AH,10H		; 1=ライトプロテクトが付いている
	JZ	SCWRITE01	;
	JMP	SCWRITE99	; エラー
SCWRITE01:
	PRVH	"w DUNIT ",DUNIT; デバイス識別・ユニット番号(DA/UA)
	PRVH	"w DLEN  ",DLEN ; データ長（ＤＴＬ）（バイト単位）
	PRVH	"w DCYL  ",DCYL ; シリンダ番号（Ｃ）０ー７６
	PRVH	"w DHEAD ",DHEAD; ヘッド番号（Ｈ）０ー１
	PRVH	"w DSECR ",DSECR; セクタ番号（Ｒ）１ー８（２６）
	PRVH	"w DSECN ",DSECN; セクタ長（Ｎ）

	MOV	AX,WRITE_RETCOUNT; セクタ書き込み・リトライ回数
	MOV	WRITE_RETRY,AX	 ; セクタ書き込み・リトライカウンタ
SCWRITE1:
	MOV	AX,DS		 ; ＤＭＡバッファセグメント
	MOV	ES,AX		 ;
	MOV	BP,SCADRS	 ; セクタバッファアドレス

	MOV	AL,BYTE PTR DUNIT ; デバイス識別・ユニット番号(DA/UA)
	MOV	BX,WORD PTR DLEN  ; データ長（ＤＴＬ）（バイト単位）
	MOV	CL,BYTE PTR DCYL  ; シリンダ番号（Ｃ）０ー７６
	MOV	DH,BYTE PTR DHEAD ; ヘッド番号（Ｈ）０ー１
	MOV	DL,BYTE PTR DSECR ; セクタ番号（Ｒ）１ー２６
	MOV	CH,BYTE PTR DSECN ; セクタ長（Ｎ）　

	MOV	AH,BYTE PTR DWRITE; ＷＲＩＴＥＤＡＴＡ
	INT	1BH		  ; ディスクＢＩＯＳ
	MOV	BYTE PTR DSTAT,AH ; ステータス情報

	JNB	SCWRITE9	; 正常終了

	CMP	BYTE PTR DSTAT,DISK_STATUS_DB
				; DMA Boundary.メモリアドレスがＤＭＡ
				; に向いていない（バンクにまたがった）
	JNE	SCWRITE5

	PRF	"致命的なエラー( WRITE SECTOR:error DB )"

	PUSH	AX
	PUSH	CX
	PUSH	ES
	PUSH	DI
	PUSH	SI
	MOV	AX,DS
	MOV	ES,AX
	MOV	SI,OFFSET SCDATA
	MOV	DI,OFFSET SCDATA2
	MOV	CX,SEC_BYTE		; セクタバッファの長さ
	REP	MOVSB
	POP	SI
	POP	DI
	POP	ES
	POP	CX
	POP	AX

	MOV	SCADRS,OFFSET SCDATA2	; セクタバッファアドレス
	JMP	SCWRITE1		; ＤＭＡバッファの変更

SCWRITE5:
	DEC	WRITE_RETRY	; セクタ書き込み・リトライカウンタ
	JZ	SCWRITE99

	MOV	AH,BYTE PTR DRECAL ; ＲＥＣＡＬＩＢＲＡＴＥ
	INT	1BH		   ; ディスクＢＩＯＳ
	MOV	BYTE PTR DSTAT,AH  ; ステータス情報

	JMP	SCWRITE1	;
SCWRITE9:
	MOV	DERROR,0	; 0=正常
	RET
SCWRITE99:
	MOV	DERROR,1	; 1=エラー
	RET
SCWRITE	ENDP



;	ディスクリセット

FDISKRESET	PROC	NEAR
	CALL	DISKRESET		; disk reset.
	RET
FDISKRESET	ENDP



;	ＦＤドライブドア開閉チェック
;	-I- AX : １ＭＦＤドライブ番号（０ー３）
;	-O- AX : 0=前と変わらず,1=ドアを開閉した,2=ドアが開きっぱなし

FDDOOR	PROC	NEAR
	PRV	"FDDOOR -i- drive=",AX
;*NON*;	PUSH	DX
;*NON*;	PUSH	BX
;*NON*;	PUSH	ES
;*NON*;	CALL	FDRSLT	; ＦＤドライブドア開閉チェック(ﾘｻﾞﾙﾄｽﾃｰﾀｽﾁｪｯｸ)
;*NON*;	CMP	AX,2	; 0=前と変わらず,1=ドアを開閉した,2=ドアが開きっぱなし
;*NON*;	JNE	FDDOOR_9
;*NON*;	MOV	AX,1	;
;*NON*;FDDOOR_9:
;*NON*;	POP	ES
;*NON*;	POP	BX
;*NON*;	POP	DX
;*NON*;	RET

	PUSH	DX
	PUSH	BX
	PUSH	ES

	PUSH	AX		; １ＭＦＤドライブ番号（０ー３）
	CALL	FDEQUIP		; ＦＤ接続チェック
	CMP	AX,0		; 1=接続されている,0=接続無し
	POP	AX		;
	JE	FDDOOR_NO_SET	;

	PUSH	AX	;
	CALL	FDRSLT	; ＦＤドライブドア開閉チェック(ﾘｻﾞﾙﾄｽﾃｰﾀｽﾁｪｯｸ)
	POP	BX	; BX=drive number.
	CMP	AX,1	; 1=ドアを開閉した
	JE	FDDOOR_SET
	CMP	AX,0	; 0=前と変わらず, 2=ドアが開きっぱなし
	JE	FDDOOR_NORMAL

FDDOOR_RETRY:
	; リザルトステータス・テーブルに反映されない
	; 場合に対してもＢＩＯＳでチェックする

	MOV	AL,BL			; AX=ドライブ番号
					; 90Hは１ＭＦＤであることを示す
	OR	AL,90H			; AL=デバイス識別・ユニット番号(DA/UA)
	MOV	AH,BYTE PTR DSENSE_NEW	; ＳＥＮＳＥ（／ＳＴＡＴＵＳ）
	INT	1BH			; ディスクＢＩＯＳ

	JB	FDDOOR_NO_SET		; CF=1 異常終了

	AND	AH,0F0H			; bit0-7 clear.
	CMP	AH,DISK_STATUS_NR	; Not Ready. ユニットがノットレディ状態
	JE	FDDOOR_NO_SET		;

FDDOOR_SET:
	CALL	USER_STANBY		; ユーザから直接、スタンバイが出た
	MOV	AX,1			; 1=ドアを開閉した
	JMP	FDDOOR9			;
FDDOOR_NO_SET:
	CALL	USER_STANBY		; ユーザから直接、スタンバイが出た
	MOV	AX,2			; 2=ドアが開きっぱなし
	JMP	FDDOOR9			;
FDDOOR_NORMAL:
	CALL	USER_STANBY		; ユーザから直接、スタンバイが出た
	CMP	BX,1			; 1=スタンバイ
	JNE	FDDOOR_NORMAL2		;
	MOV	AX,1			; 1=ドアを開閉した
	JMP	FDDOOR9			;
FDDOOR_NORMAL2:
	MOV	AX,0			; 0=前と変わらず
FDDOOR9:
	PRV	"FDDOOR -o- (0n,1oc,2o)=",AX
	POP	ES
	POP	BX
	POP	DX
	RET
FDDOOR	ENDP



;	ＦＤドライブドア開閉チェック（リザルトステータスチェック）
;	-I- AX : １ＭＦＤドライブ番号（０ー３）
;	-O- AX : 0=前と変わらず,1=ドアを開閉した,2=ドアが開きっぱなし

FDRSLT	PROC	NEAR
	PUSH	DX
	PUSH	BX
	PUSH	ES

	MOV	DX,AX			; DX=ドライブ番号

	MOV	BX,AX
	SHL	BX,1	; *2
	SHL	BX,1	; *4
	SHL	BX,1	; *8
	ADD	BX,DISK_RESULT_TOP ; リザルトステータス情報アドレス
	MOV	AX,0			;
	MOV	ES,AX			;
	MOV	AL,BYTE PTR ES:[BX]	; disk result status ST0.
;		  |iiSenHuu|
;		  |ccEcrDss|
;		  |10    10|
	AND	AL,11001000B

	CMP	AL,0
	JNE	FDRSLT5		;
	MOV	AX,0		; 0=前と変わらず
	JMP	FDRSLT9		;
FDRSLT5:
	CMP	AL,11000000B	;
	JNE	FDRSLT6		;
	MOV	AX,1		; 1=ドアを開閉した
	JMP	FDRSLT9
FDRSLT6:
	CMP	AL,11001000B	;
	JNE	FDRSLT7		;
	MOV	AX,2		; 2=ドアが開きっぱなし
	JMP	FDRSLT9
FDRSLT7:
	MOV	AX,2		; 2=ドアが開きっぱなし

FDRSLT9:
	MOV	BX,DX		; DX=ドライブ番号
	CMP	BYTE PTR DS:DISK_DOOR_INI[BX],0	; ディスク開閉初期ﾌﾗｸﾞ
	JZ	FDRSLT_RET

	MOV	BYTE PTR DS:DISK_DOOR_INI[BX],0	; ディスク開閉初期ﾌﾗｸﾞ
	CMP	AX,0		; 0=前と変わらず
	JNE	FDRSLT_RET	;
	MOV	AX,1		; 1=ドアを開閉した
FDRSLT_RET:
	POP	ES
	POP	BX
	POP	DX
	RET
FDRSLT	ENDP


;	ＦＤ接続チェック
;	-I- AX : １ＭＦＤドライブ番号（０ー３）
;	-O- AX : 1=接続されている,0=接続無し

FDEQUIP	PROC	NEAR
	PUSH	CX
	PUSH	DX

	MOV	DX,0			; 接続チェック
	MOV	ES,DX			;
	MOV	CL,AL			; １ＭＦＤドライブ番号（０ー３）
	MOV	DL,1			;
	SHL	DL,CL			; ビットＯＮならば接続
	TEST	ES:[DISK_EQUIP],DL	; 接続ユニット
	JNZ	FDEQUIP_ON		;
FDEQUIP_OFF:
	MOV	AX,0			; 0=接続無し
	POP	DX
	POP	CX
	RET
FDEQUIP_ON:
	MOV	AX,1			; 1=接続されている
	POP	DX
	POP	CX
	RET
FDEQUIP	ENDP


;	ＲＡＭドライブ接続チェック
;	-I- AX          : １ＭＦＤドライブ番号（０ー３）
;	-O- FLAG_RAM_DR : RAMドライブ接続 1=接続されている,0=接続無し

RAM_DR_EQUIP	PROC	NEAR
	MOV	DX,0			; 接続チェック
	MOV	ES,DX			;
	MOV	CL,AL			; １ＭＦＤドライブ番号（０ー３）
	MOV	DL,1			;
	SHL	DL,CL			; ビットＯＮならば接続

	TEST	ES:[DISK_EQUIP],DL	; 接続ユニット
	JZ	RAM_DR_EQUIP_OFF	;
	TEST	ES:[RDISK_EQUIP],DL	; ＲＡＭドライブ接続状況識別ビット
	JZ	RAM_DR_EQUIP_OFF	;
	JMP	RAM_DR_EQUIP_ON		;
RAM_DR_EQUIP_OFF:
	MOV	FLAG_RAM_DR,0		; 0=接続無し
	RET
RAM_DR_EQUIP_ON:
	MOV	FLAG_RAM_DR,1		; 1=接続されている
	RET
RAM_DR_EQUIP	ENDP



;	ライトプロテクトチェック
;	-I- DRVNUM         : １ＭＦＤドライブ番号（０－３）
;	-O- FLAG_W_PROTECT : フラグ・ライトプロテクト 1=ﾌﾟﾛﾃｸﾄ

CHECK_WP	PROC	NEAR
	MOV	FLAG_W_PROTECT,0	; フラグ・ライトプロテクト 1=ﾌﾟﾛﾃｸﾄ

	MOV	AX,DRVNUM		; 対象ディスクのドライブ番号
					; AX=ドライブ番号
					; 90Hは１ＭＦＤであることを示す
	OR	AL,90H			; AL=デバイス識別・ユニット番号(DA/UA)
	MOV	AH,BYTE PTR DSENSE_NEW	; ＳＥＮＳＥ（／ＳＴＡＴＵＳ）
	INT	1BH			; ディスクＢＩＯＳ

	PRVH	"AX=",AX

	JB	CHECK_WP_8		; CF=1 異常終了

	AND	AH,0F0H			; bit0-7 clear.
	CMP	AH,DISK_STATUS_WP	; Write Protect.ライトプロテクト状態
	JNE	CHECK_WP_5		;
	MOV	FLAG_W_PROTECT,1	; フラグ・ライトプロテクト 1=ﾌﾟﾛﾃｸﾄ
CHECK_WP_5:
CHECK_WP_8:
	PRV	"FLAG_W_PROTECT=",FLAG_W_PROTECT
	RET
CHECK_WP	ENDP


;	ユーザ、スタンバイセットアップ

USER_STANBY_SETUP	PROC	NEAR
	MOV	USER_ST_COUNT,0		; ユーザスタンバイカウンタ
	MOV	USER_ST_BREAK,0		; ユーザＢＲＥＡＫ 1=強制終了
	RET
USER_STANBY_SETUP	ENDP


;	ユーザから直接、スタンバイが出た
;	-I/O-  USER_ST_BREAK : 1=強制終了
;	-O-    BX : 1=スタンバイ,0=通常

USER_STANBY	PROC	NEAR
	PUSH	AX
	PUSH	CX
	PUSH	DX
	PUSH	BP
	PUSH	SI
	PUSH	DI
	PUSH	ES

	CMP	USER_ST_COUNT,0		; ユーザスタンバイカウンタ
	JNE	USER_STANBY_9		;

	CALL	USER_SHOT		; ユーザスタンバイ
	CMP	AX,0			; 0=通常
	JE	USER_STANBY_7		;
	CMP	AX,1			; 1=スタンバイ
	JE	USER_STANBY_8		;

	MOV	USER_ST_BREAK,1		; ユーザＢＲＥＡＫ 1=強制終了
	MOV	BX,0			; 0=通常
	JMP	USER_STANBY_EXIT	;
USER_STANBY_7:				;
	MOV	BX,0			; 0=通常
	JMP	USER_STANBY_EXIT	;
USER_STANBY_8:				;
	MOV	AX,DRVNUMMAX		; １ＭＦＤドライブ数
	DEC	AX			;
	MOV	USER_ST_COUNT,AX	; ユーザスタンバイカウンタ
	MOV	BX,1			; 1=スタンバイ
	JMP	USER_STANBY_EXIT	;
USER_STANBY_9:				;
	DEC	USER_ST_COUNT		; ユーザスタンバイカウンタ
	MOV	BX,1			; 1=スタンバイ
USER_STANBY_EXIT:
	POP	ES
	POP	DI
	POP	SI
	POP	BP
	POP	DX
	POP	CX
	POP	AX
	RET
USER_STANBY	ENDP



;	ドライブ番号の設定（０ー３）
;	-I- AX : １ＭＦＤドライブ番号

DRVSET	PROC	NEAR
	PUSH	AX
	AND	AL,011B
	AND	BYTE PTR DUNIT,11111100B
	OR	BYTE PTR DUNIT,AL
	POP	AX
	RET
DRVSET	ENDP



;	ドライブ番号の取得
;	-O- AX : １ＭＦＤドライブ番号

DRVNO	PROC	NEAR
	MOV	AX,DUNIT	; デバイス識別・ユニット番号（DA/UA）
	AND	AX,00000011B	; DA/UA=100100dd

	PRV	"DUNITのドライブ番号=",AX
	RET
DRVNO	ENDP


; ****************************************************
;	DATA
; ****************************************************
		EVEN

PUBLIC	USER_ST_BREAK			; ユーザＢＲＥＡＫ 1=強制終了

PUBLIC	SCADRS				; セクタバッファアドレス
EXTRN	SCDATA:BYTE			; セクタバッファ
PUBLIC	SCDATA2				; セクタバッファ

SCADRS		DW	OFFSET SCDATA	 ; セクタバッファアドレス
;SCDATA		DB	SEC_BYTE DUP (0) ; セクタバッファ
;		DB	0,0		 ;
SCDATA2		DB	SEC_BYTE DUP (0) ; セクタバッファ
		DB	0,0		 ;

;	ＢＩＯＳコマンド識別コード
;			MM-S....
;			TFrK0110
DREAD		DW	11110110B	; ＲＥＡＤ　ＤＡＴＡ
;*N*;DRECAL	DW	00100111B	; ＲＥＣＡＬＩＢＲＡＴＥ
DRECAL		DW	00000111B	; ＲＥＣＡＬＩＢＲＡＴＥ
DWRITE		DW	01010101B	; ＷＲＩＴＥＤＡＴＡ

DSENSE		DW	04H		; ＳＥＮＳＥ
DSEEK		DW	10H		; ＳＥＥＫ
DSENSE_NEW	DW	84H		; ＳＥＮＳＥ（／ＳＴＡＴＵＳ）

;			100100dd
DUNIT		DW	10010001B	; デバイス識別・ユニット番号（DA/UA）

;		ＩＤＲ（ＩＤ情報）
DLEN		DW	SEC_BYTE	; データ長（ＤＴＬ）（バイト単位）
DCYL		DW	0		; シリンダ番号（Ｃ）０ー７６
DHEAD		DW	0		; ヘッド番号（Ｈ）０ー１
DSECR		DW	1		; セクタ番号（Ｒ）１ー８（２６）
DSECN		DW	03		; セクタ長（Ｎ）
					; 00/128, 01/256, 02/512, 03/1024
DSTAT		DW	0		; ステータス情報
DERROR		DW	0		; 0=正常,1=エラー

DISK_DOOR_INI	DB	0FFH,0FFH,0FFH,0FFH	; ディスク開閉初期ﾌﾗｸﾞ

		EVEN
READ_RETRY	DW	0		; リード・リトライカウンタ
WRITE_RETRY	DW	0		; セクタ書き込み・リトライカウンタ

DSKID_ADRS	LABEL	WORD		; ディスクＩＤアドレステーブル
		DW	OFFSET DSKID0	;
		DW	OFFSET DSKID1	;
		DW	OFFSET DSKID2	;
		DW	OFFSET DSKID3	;
DSKID0		DB	ID_LEN DUP (0)	; ドライブ０のＩＤテーブル
DSKID1		DB	ID_LEN DUP (0)	; ドライブ１のＩＤテーブル
DSKID2		DB	ID_LEN DUP (0)	; ドライブ２のＩＤテーブル
DSKID3		DB	ID_LEN DUP (0)	; ドライブ３のＩＤテーブル

		EVEN
ID_DISKSYSNAME	DW	0		; システムＩＤ
ID_DISKPROG	DW	0		; プログラムＩＤ
ID_DISKNUMBER	DW	0		; ディスク番号

DRVNUMMAX	DW	DRVNUMMAX_FIX	; １ＭＦＤドライブ数
DRVNUM		DW	0		; ドライブ番号（０ー３）
DRVNUMSYS	DW	0		; システムドライブ番号

SCH_DISKID	DW	0		; 検索ディスクＩＤ
DIRDISK		DW	0		; 対象ディスク番号

USER_ST_BREAK	DW	0		; ユーザＢＲＥＡＫ 1=強制終了
USER_ST_COUNT	DW	0		; ユーザスタンバイカウンタ

FLAG_WIDOPEN	DW	0		; ウインドウオープンフラグ

FLAG_RAM_DR	DW	0		; RAMドライブ接続
					; 1=接続されている,0=接続無し

FLAG_USER_DISK	DW	0		; ユーザディスクフラグ
					; 1=ユーザディスク
					; 2=新しいディスク
					; 3=別のソフトが入っている

FLAG_W_PROTECT	DW	0		; フラグ・ライトプロテクト 1=ﾌﾟﾛﾃｸﾄ

CODE	ENDS
	END
;
;	end of "DSKCGX.ASM"
;
