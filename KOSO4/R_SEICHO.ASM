; "R_SEICHO.ASM" PC-9801UV11 make by R.H 1991/01/28
;
;
;	「子育て」
;
;	成長処理
;
;	Ｒ＿ＰＲＯＧ．ＡＳＭよりＣＡＬＬする。
;
;	R_SCHO_MONTH : 成長の月次処理
;		月次処理は月に１回しかＣＡＬＬしてはいけません。
;
;		46=身長・体重の成長
;		47=ポイントの成長
;
;	R_SCHO_DAYS  : 成長の日次処理
;		日次処理は日に１回しかＣＡＬＬしてはいけません。
;
;		44=誕生日と年齢
;		45=回復
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO6\KYOKU.INC

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

MOVXBW	MACRO	DEST,SOUR
	MOV	AH,0
	MOV	AL,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

SUBX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	SUB	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

EOS	EQU	0		; end of string.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_SCHO_MONTH		; 成長の月次処理
PUBLIC	R_SCHO_DAYS		; 成長の日次処理
PUBLIC	R_BORTH_DAY		; 誕生日の処理
PUBLIC	R_BORTH_DAY_DR		; 日数遅れの誕生日
PUBLIC	R_START_DAY		; 立上り時の処理
PUBLIC	R_QUICK_DAY		; 瞬時娘表示の処理
PUBLIC	R_SCHO_KISEKAE		; 娘着せ替えの処理
PUBLIC	R_SCHO_MUSUME		; 娘チェック(ロード用)
PUBLIC	R_SCHO_SYUKAKU		; 娘チェック(収穫祭用)

EXTRN	R_LEVEL_UP:NEAR		; レベルＵＰ処理

EXTRN	R_SR_POINT:NEAR		; ポイント表示
EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_SR_GIRL_NAME:NEAR	; キャラクタ名
EXTRN	R_SR_GIRL_FULL_NAME:NEAR ; キャラクタ名+姓
EXTRN	R_SR_YOIDESUKA:NEAR	; よいですか

EXTRN	WIDALLOC_CHRADRS:NEAR	; WINDOWS/キャラクタ・ヘッダアドレス

EXTRN	WID_GIRL_INIT:NEAR	; WINDOWS/ＧＩＲＬウインドウ初期処理
EXTRN	WID_GIRL:NEAR		; WINDOWS/ＧＩＲＬウインドウ
EXTRN	WID_GIRL_BORTH:NEAR	; WINDOWS/ＧＩＲＬウインドウ成長
EXTRN	WID_GIRL_FACE:NEAR	; WINDOWS/ＧＩＲＬウインドウ顔
EXTRN	WID_GIRL_KIGAE:NEAR	; WINDOWS/ＧＩＲＬウインドウ着替え


; ****************************************************
;	成長の月次処理
; ****************************************************

R_SCHO_MONTH	PROC	NEAR
;*DBG*;	PRF	"＊＊＊　成長の月次処理　＊＊＊"
;*DBG*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*DBG*;	MOV	BX,WIDMY_GIRL_OF	; 私の娘アドレス
;*DBG*;	PRVB	"-I- ES:[BX][HED_FLAGS]=",ES:[BX][HED_FLAGS]

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,65		; 65=非行化・病気化
	CALL	R_KEISAN		; 各計算処理

;*DBG*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*DBG*;	MOV	BX,WIDMY_GIRL_OF	; 私の娘アドレス
;*DBG*;	PRVB	"-O- ES:[BX][HED_FLAGS]=",ES:[BX][HED_FLAGS]


	CMP	AX,1			; 0=通常,1=変化あり
	JNE	R_SCHO_MONTH_3		;

	CMP	DX,0			; ありの場合 0=戻った
	JE	R_SCHO_MONTH_11		;
	CMP	DX,1			; ありの場合 1=非行化
	JE	R_SCHO_MONTH_12		;
	CMP	DX,2			; ありの場合 2=病気
	JE	R_SCHO_MONTH_13		;
R_SCHO_MONTH_11:
	PR_LF
	CALL	R_SR_GIRL_NAME		; キャラクタ名
	PR_TXT	"は元気になった。"
	JMP	R_SCHO_MONTH_GIRL
R_SCHO_MONTH_12:
	PR_LF
	CALL	R_SR_GIRL_NAME		; キャラクタ名
	PR_TXT	"が非行化した。"
	JMP	R_SCHO_MONTH_GIRL
R_SCHO_MONTH_13:
	PR_LF
	CALL	R_SR_GIRL_NAME		; キャラクタ名
	PR_TXT	"が病気になった。"
R_SCHO_MONTH_GIRL:
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	MUSUME			; 娘チェック
	CALL	WID_GIRL_FACE		; WINDOWS/ＧＩＲＬウインドウ顔
	CALL	MUSIC_KOSODATE		; 子育てのテーマ
R_SCHO_MONTH_3:

	MOV	CHAR_NUMBER,0		; キャラクター番号

	MOV	CX,WIDMAX_HEAD		; ヘッダーテーブルレコード数
R_SCHO_MONTH_LOOP:
	PUSH	CX

	MOV	DX,CHAR_NUMBER		; キャラクター番号
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	CHAR_HEAD_ADRS,BX	; ヘッダ・アドレス

;*DBG*;	PRVH	"月CHAR_HEAD_ADRS=",CHAR_HEAD_ADRS


	;	乱数に従い、年齢毎の成長を計算する。

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,46		; 46=身長・体重の成長
	CALL	R_KEISAN		; 各計算処理


	;	ヒロイン以外の自動的成長を計算する

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,47		; 47=ポイントの成長
	CALL	R_KEISAN		; 各計算処理

	MOV	BX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	CALL	R_LEVEL_UP		; レベルＵＰ処理

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,14		; 14=ヘッダー整合
	CALL	R_KEISAN		; 各計算処理

	INC	CHAR_NUMBER		; キャラクター番号

	POP	CX
	LOOP	R_SCHO_MONTH_LOOP

	RET
R_SCHO_MONTH	ENDP


; ****************************************************
;	成長の日次処理
;	-O- MY_GIRL_AGE     : 年齢
;	    MY_GIRL_BORTH_F : 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
; ****************************************************

R_SCHO_DAYS	PROC	NEAR
;*DBG*;	PRV	"＊＊＊  VAL_DATE=",VAL_DATE
;*DBG*;	PRV	"＊＊＊　成長の日次処理　＊＊＊ WIDMAX_HEAD=",WIDMAX_HEAD

	MOV	CHAR_NUMBER,0		; キャラクター番号

	MOV	CX,WIDMAX_HEAD		; ヘッダーテーブルレコード数
R_SCHO_DAYS_LOOP:
	PUSH	CX

	MOV	DX,CHAR_NUMBER		; キャラクター番号
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	CHAR_HEAD_ADRS,BX	; ヘッダ・アドレス

;*DBG*;	PRVH	"日CHAR_HEAD_ADRS=",CHAR_HEAD_ADRS

	;	環境時間と誕生日を較べて、誕生日ならば年齢を
	;	インクリメントする。

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	BX,WIDOFS_ENVIR		; 環境テーブル
	MOV	S_FUNC,44		; 44=誕生日と年齢
	CALL	R_KEISAN		; 各計算処理


	MOV	CX,CHAR_NUMBER		; キャラクター番号
	CMP	CX,WIDCHAR_NUMBER_MUSUME ; 自分の娘のキャラ番号（＝Ｎｏ．０）
	JNE	R_SCHO_DAYS_55		;

	MOV	MY_GIRL_AGE,DX		; 年齢
	MOV	MY_GIRL_BORTH_F,AX	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
R_SCHO_DAYS_55:

	;	グラフ値の全てを最大値まで回復する。

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,45		; 45=回復
	CALL	R_KEISAN		; 各計算処理

	MOV	BX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	CALL	R_LEVEL_UP		; レベルＵＰ処理

	MOV	AX,CHAR_HEAD_ADRS	; ヘッダ・アドレス
	MOV	S_FUNC,14		; 14=ヘッダー整合
	CALL	R_KEISAN		; 各計算処理

	INC	CHAR_NUMBER		; キャラクター番号

	POP	CX
	LOOP	R_SCHO_DAYS_LOOP

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,70		; 70=病気の日次処理
	CALL	R_KEISAN		; 各計算処理

	RET
R_SCHO_DAYS	ENDP


; ****************************************************
;	誕生日の処理
;	-I- MY_GIRL_AGE     : 年齢
;	    MY_GIRL_BORTH_F : 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
; ****************************************************

R_BORTH_DAY	PROC	NEAR
	CMP	MY_GIRL_BORTH_F,1		; 1=ｂｏｒｔｈｄａｙ！
	JE	R_BORTH_DAY_START		;
	RET					;
R_BORTH_DAY_START:				;
	CALL	MY_BORTH_DAY			; 誕生日の処理
	CALL	R_SR_YOIDESUKA			; よいですか
	RET
R_BORTH_DAY	ENDP


; ****************************************************
;	日数遅れの誕生日
;	-I- MY_GIRL_AGE     : 年齢
; ****************************************************

R_BORTH_DAY_DR	PROC	NEAR
	MOV	DX,VAL_DATE			; (now)日
	SUB	DX,MY_BORTH_DATE		; 娘の誕生日の日
	CMP	DX,0				;
	JE	R_BORTH_DAY_DR_3		;

	PUSH	DX
	PR_LF
	POP	DX
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"日、遅れの誕生日・・・"	;
	JMP	R_BORTH_DAY_DR_5		;
R_BORTH_DAY_DR_3:
R_BORTH_DAY_DR_5:
	CALL	MY_BORTH_DAY			; 誕生日の処理
	CALL	R_SR_YOIDESUKA			; よいですか
	RET
R_BORTH_DAY_DR	ENDP


; ****************************************************
;	誕生日の処理
;	-I- MY_GIRL_AGE     : 年齢
; ****************************************************

MY_BORTH_DAY	PROC	NEAR
	PR_TXT	"@娘の「"
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_SR_GIRL_FULL_NAME		; キャラクタ名+姓
	PR_TXT	"」は"
	MOV	DX,MY_GIRL_AGE			; 年齢
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"才になりました。"


	MOV	BX,MY_GIRL_AGE		; 年齢
	SUB	BX,10			; １０才から
	JGE	MY_BORTH_DAY_2		;
	MOV	BX,0			;
MY_BORTH_DAY_2:
	CMP	BX,GROW_TABLE_MAX	; 成長テーブルの最大
	JNB	MY_BORTH_DAY_EXIT	;
	SHL	BX,1			; 2 byte pointer.
	CMP	DS:GROW_TABLE[BX][1],1	; 変化ありか？
	JNE	MY_BORTH_DAY_EXIT	;

	CALL	MUSUME			; 娘チェック
	CALL	WID_GIRL_BORTH		; WINDOWS/ＧＩＲＬウインドウ成長
MY_BORTH_DAY_EXIT:
	RET
MY_BORTH_DAY	ENDP


; ****************************************************
;	立上り時の処理
; ****************************************************

R_START_DAY	PROC	NEAR
	CALL	MUSUME			; 娘チェック
	CALL	WID_GIRL_BORTH		; WINDOWS/ＧＩＲＬウインドウ成長
	RET
R_START_DAY	ENDP


; ****************************************************
;	瞬時娘表示の処理
; ****************************************************

R_QUICK_DAY	PROC	NEAR
	CALL	MUSUME			; 娘チェック
	CALL	WID_GIRL		; WINDOWS/ＧＩＲＬウインドウ
	RET
R_QUICK_DAY	ENDP


; ****************************************************
;	娘着せ替えの処理
; ****************************************************

R_SCHO_KISEKAE	PROC	NEAR
	CALL	MUSUME			; 娘チェック
	CALL	WID_GIRL_KIGAE		; WINDOWS/ＧＩＲＬウインドウ着替え
	RET
R_SCHO_KISEKAE	ENDP


; ****************************************************
;	娘チェック(ロード用)
; ****************************************************

R_SCHO_MUSUME	PROC	NEAR
	CALL	MUSUME			; 娘チェック
	RET
R_SCHO_MUSUME	ENDP


; ****************************************************
;	娘チェック(収穫祭用)
; ****************************************************

R_SCHO_SYUKAKU	PROC	NEAR
	CALL	MUSUME			; 娘チェック
	RET
R_SCHO_SYUKAKU	ENDP


; ****************************************************
;	娘チェック
;	-I- W_GIRL_SEASON : 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
;	    W_GIRL_GROW   : 少女（成長１,成長２,成長３,成長４）
;	    W_GIRL_FACE   : 顔（１－３）
; ****************************************************

MUSUME	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	BX,ES:[DI][VTB_NENREI][VAL_VALUE] ; 年齢

	SUB	BX,10			; １０才から
	CMP	BX,GROW_TABLE_MAX	; 成長テーブルの最大
	JL	MUSUME_5		;
	MOV	BX,7			; １７才
	JMP	MUSUME_6		;
MUSUME_5:				;
	CMP	BX,0			;
	JGE	MUSUME_6		;
	MOV	BX,1			;
MUSUME_6:				;
	SHL	BX,1			; 2 byte pointer.
	MOVXBW	W_GIRL_GROW,DS:GROW_TABLE[BX]	; 少女（成長１,成長２・・・）
	MOVX	W_GIRL_SEASON,WIDCHAR_DRESS	; 自分の娘の着ている服
				; 0=何も着ない,1=春服,2=夏服,3=秋,4=冬

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,0			; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41		; 41=ヘッダーフラグのＩ／Ｏ
	CALL	R_KEISAN		; 各計算処理

	TEST	DX,FLAGS_BYOUKI		;bit12 : 病気化
	JNZ	MUSUME_BYOUKI		;
	TEST	DX,FLAGS_HIKOU		;bit13 : 非行化
	JNZ	MUSUME_HIKOU		;

	MOV	W_GIRL_FACE,1		; 顔（１－３）
	RET
MUSUME_BYOUKI:
	MOV	W_GIRL_FACE,2		; 顔（１－３）
	RET
MUSUME_HIKOU:
	MOV	W_GIRL_FACE,3		; 顔（１－３）
	RET
MUSUME	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	MY_GIRL_BORTH_F			; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
					; public FLG_BORTH(now)フラグ・誕生日
					; との整合性も注意しなければならない。

EXTRN	VAL_YEAR:WORD			; (now)年
EXTRN	VAL_MONTH:WORD			; (now)月
EXTRN	VAL_WEEK:WORD			; (now)曜日
EXTRN	VAL_DATE:WORD			; (now)日

EXTRN	MY_BORTH_MONTH:WORD		; 娘の誕生日の月
EXTRN	MY_BORTH_DATE:WORD		; 娘の誕生日の日

EXTRN	S_FUNC:WORD			; 計算ファンクション

EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

EXTRN	W_GIRL_SEASON:WORD	; 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
EXTRN	W_GIRL_GROW:WORD	; 少女（成長１,成長２,成長３,成長４）
EXTRN	W_GIRL_FACE:WORD	; 顔（１－３）

EXTRN	TM_SEASON:WORD			; (now)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	FLG_SHOGATSU:WORD		; (now)フラグ・正月
EXTRN	FLG_URUBI:WORD			; (now)フラグ・うるう日
EXTRN	FLG_CHRISTMAS_EVE:WORD		; (now)フラグ・クリスマスイブ
EXTRN	FLG_BORTH:WORD			; (now)フラグ・誕生日
EXTRN	FLG_HOLIDAY:WORD		; (now)フラグ・休日
EXTRN	FLG_SYUKAKU:WORD		; (now)フラグ・収穫祭の準備


GROW_TABLE_MAX	DW	8		; 成長テーブルの最大
GROW_TABLE	LABEL	BYTE		; 少女（成長１,成長２,成長３,成長４）
		DB	1,1		; １０才	２バイト目がＯＮのもの
		DB	2,1		; １１才	はボディの絵が変わる。
		DB	3,1		; １２才
		DB	4,1		; １３才
		DB	5,1		; １４才
		DB	6,1		; １５才
		DB	7,1		; １６才
		DB	8,1		; １７才

MY_GIRL_AGE	DW	0		; 年齢
MY_GIRL_BORTH_F	DW	0		; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！

CHAR_NUMBER	DW	0		; キャラクター番号
CHAR_HEAD_ADRS	DW	0		; ヘッダ・アドレス

DATA	ENDS

	END
;
;	end of "R_SEICHO.ASM"
;
