; "R_MESSAG.ASM" PC-9801UV11 make by R.H 1991/02/20
;
;
;	「子育て」
;
;	メッセージ
;
;	プログラムの最後に　INCLUDE　R_MESADD.INC　がある。
;	
;
;	R_MS_MACHINOKOE		; 街の声
;	R_MS_OH_KAIKEN		; 王様との会見
;	R_MS_SCHED_TXT		; スケジュール選択時のメッセージ
;	R_MS_OH_KAISRT		; 王様との会見選択時
;
;	R_MS_OH_HOMERU		; 王様のほめ言葉
;	R_MS_BUTOH		; 武闘会メッセージ
;	R_MS_MESSAGE		; その他メッセージ
;
;	R_MS_KYUSOKU		; 休息時メッセージ
;	R_MS_BACANCE		; バカンス時メッセージ
;
;	R_MS_MUSYA_SRT		; 武者修行スタート台詞
;	R_MS_MUSYA_SLC		; 武者修行選択台詞
;	R_MS_MUSYA_IDO		; 武者修行移動台詞
;	R_MS_MUSYA_MAKE		; 武者修行負け台詞
;
;	R_MS_KUCHIPAKU		; 口パクモード
;	R_MS_KUCHISTOP		; 口パクモード終り
;
;	R_SEG2:MESSAGE_PRINT	; メッセージ表示(R_SEG2)
;	R_SEG2:TALK_START	; 会話スタート(R_SEG2)
;	R_SEG2:TALK_END		; 会話ストップ(R_SEG2)
;	R_SEG2:TALK_SRT02	; 会話スタート（クリア無し）(R_SEG2)
;	R_SEG2:TALK_FIN		; 会話ストップ（クリア無し）(R_SEG2)
;	R_SEG2:HOW_MANY_YEARS	; 何年目か BX=年のword pointer
;
;	参考
;
;	1  学問
;	2  礼法
;	3  武者修行
;	4  アルバイト
;	5  休息
;	6  バカンス
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO6\KYOKU.INC

CODE	SEGMENT	PUBLIC	'CODE'
CODE	ENDS
DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS
R_SEG2	SEGMENT	PUBLIC	'R_SEG2'		; コード
R_SEG2	ENDS
R_SEG3	SEGMENT	PUBLIC	'R_SEG3'		; テキスト
R_SEG3	ENDS


; ****************************************************
;	会見フラグ
; ****************************************************

		;bit	FEDCBA9876543210
FLG_K_FIRST	EQU	0000000000000010B	; 会見２回目以降
FLG_K_KIHIN	EQU	0000000000000100B	; 気品不足２回目以降
FLG_K_GOKAKU	EQU	0000000000001000B	; 合格２回目以降

SLT_EIHEI	EQU	0			; フラグ衛兵
SLT_EIHEI_TAIC	EQU	2			; フラグ衛兵隊長
SLT_JIJYU	EQU	4			; フラグ侍従
SLT_JIJYU_CHO	EQU	6			; フラグ侍従長
SLT_OHUHI	EQU	8			; フラグ王妃様
SLT_OHSAMA	EQU	10			; フラグ王様

LVL_OUT		EQU	0			; 0=全滅！
LVL_EIHEI	EQU	1			; 1=衛兵までＯＫ
LVL_EIHEI_TAIC	EQU	2			; 2=近衛隊長までＯＫ
LVL_JIJYU	EQU	3			; 3=侍従までＯＫ
LVL_JIJYU_CHO	EQU	4			; 4=侍従長までＯＫ
LVL_OHUHI	EQU	5			; 5=王妃までＯＫ
LVL_OHSAMA	EQU	6			; 6=王様までＯＫ

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチン
; ****************************************************

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
SUBLL	PROC	FAR
	ENDM

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチンの終り
; ****************************************************

FEND	MACRO	SUBLL

SUBLL	ENDP
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
;	Ｒ＿ＳＥＧ２　から　ＣＯＤＥ　へ　ＣＡＬＬ
; ****************************************************

CALLC	MACRO	SUB1
	LOCAL	L1,L2
;*;	JMP	L1
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
	CALL	MESSAGE_PRINT		; メッセージ表示
	ENDM

; ****************************************************
;	ＥＤＩＴＸ	＜文字列＞
;	-O- DS:SI : 文字列データ
;	文字列データの編集
; ****************************************************

EDITX	MACRO	STRING
	LOCAL	L1
R_SEG3	SEGMENT	PUBLIC	'R_SEG3'	; テキスト
L1	DB	STRING,0
R_SEG3	ENDS
	MOV	MESS_ADRS,OFFSET L1	; メッセージアドレス
	CALL	TEXT_MAKER		; テキストメーカ
	MOV	SI,WDTXTADR		; メッセージアドレス
	ENDM

; ****************************************************
;	テキストセグメントの始まり
; ****************************************************

TEXT_IN		MACRO
R_SEG3	SEGMENT	PUBLIC	'R_SEG3'	; テキスト
	ENDM

; ****************************************************
;	テキストセグメントの終り
; ****************************************************

TEXT_OUT	MACRO
R_SEG3	ENDS
	ENDM

; ****************************************************
;	その他
; ****************************************************

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
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
TSTW	MACRO	DEST,SOUR
	TEST	WORD PTR DEST,SOUR
	ENDM
ORW	MACRO	DEST,SOUR
	OR	WORD PTR DEST,SOUR
	ENDM


R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA


PUBLIC	MESSAGE_PRINT			; メッセージ表示(R_SEG2)
PUBLIC	MESSAGE_LF			; メッセージ改行(R_SEG2)
PUBLIC	TALK_START			; 会話スタート(R_SEG2)
PUBLIC	TALK_END			; 会話ストップ(R_SEG2)
PUBLIC	TALK_SRT02			; 会話スタート（クリア無し）(R_SEG2)
PUBLIC	TALK_FIN			; 会話ストップ（クリア無し）(R_SEG2)
PUBLIC	HOW_MANY_YEARS			; 何年目か BX=年のword pointer(R_SEG2)

; ****************************************************
;	街の声
; ****************************************************

FUNC	RR_MS_MACHINOKOE,R_MS_MACHINOKOE
	CALL	TALK_START			; 会話スタート

;*;	☆このメッセージは別のサブルーチンへ移しました。
;*;
;*;	世間の評価も無視できない。
;*;	町に行ってこの子の評判を聞いてみようか・・・・・・"

	CALLC	TKRHME			; 台詞ホームポジション
	PRINTX	"町の人々に"
	CALL	MY_GIRL_NAME			; 娘の名前
	PRINTX	"の評判を聞いてみよう……"

	CALLC	WIDEVNT_U_OPEN		; WINDOWS/うわさウインドウＯＰＥＮ

	WSELECT	"街の人に聞く"

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,0				; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41			; 41=ヘッダーフラグのＩ／Ｏ
	CALLC	R_KEISAN			; 各計算処理
	MOV	MY_FLAGS,DX			; ヘッダフラグ

	CALL	MACHI_MESS_1ET			; 街の声その１・評価
	CALL	FUMUFUMU			; ふむふむ
	CALL	MACHI_MESS_2ET			; 街の声その２・高い能力
	CALL	FUMUFUMU			; ふむふむ
	CALL	MACHI_MESS_3ET			; 街の声その３・低い能力
	CALL	FUMUFUMU			; ふむふむ
	CALL	MACHI_MESS_4ET			; 街の声その４・へんなところ

	CALL	TALK_END			; 会話ストップ

	CALLC	WIDEVNT_U_CLOSE		; WINDOWS/うわさウインドウＣＬＯＳＥ
	RET
FEND	RR_MS_MACHINOKOE


; ****************************************************
;	街の声その１・評価
; ****************************************************

MACHI_MESS_1ET	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,40		; 40=町の評判
	CALLC	R_KEISAN		; 各計算処理
	CMP	DX,1
	JE	MACHI_MESS_1ET_S1
	CMP	DX,2
	JE	MACHI_MESS_1ET_S2
	CMP	DX,3
	JE	MACHI_MESS_1ET_S3
	CMP	DX,4
	JE	MACHI_MESS_1ET_S4
	CMP	DX,5
	JE	MACHI_MESS_1ET_S5
	CMP	DX,6
	JE	MACHI_MESS_1ET_S6
	CMP	DX,7
	JMPEQ	MACHI_MESS_1ET_S7
	RET
MACHI_MESS_1ET_S1:
	;評価１０未満
	PRINTX	"@町の声｢＊＊"
	CALL	MY_GIRL_NAME			; 娘の名前
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_1ET_S2:
	;１０～１９
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊"
	CALLC	R_SR_GIRL_FNAME		; キャラクタ姓
	PRINTX	"＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_1ET_S3:
	;２０～３９
        PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_1ET_S4:
	;４０～５９
	PRINTX	"@町の声｢"
	CALL	MY_GIRL_NAME			; 娘の名前
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_1ET_S5:
	;６０～７９
	PRINTX	"@町の声｢"
	CALL	MY_GIRL_NAME			; 娘の名前
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_1ET_S6:
	;８０～９９
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_1ET_S7:
	;１００以上
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊"
	CALL	MY_GIRL_NAME			; 娘の名前
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_1ET	ENDP


; ****************************************************
;	街の声その２・高い能力
; ****************************************************

MACHI_MESS_2ET	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,1			; 根性を除くフラグ=1
	MOV	S_FUNC,59		; 59=体力、腕力・・・で一番は
	CALLC	R_KEISAN		; 各計算処理

	CMP	BX,0			; 0=体力
	JE	MACHI_MESS_2ET_S0	;
	CMP	BX,1			; 1=腕力
	JE	MACHI_MESS_2ET_S1	;
	CMP	BX,2			; 2=知力
	JE	MACHI_MESS_2ET_S2	;
	CMP	BX,3			; 3=気品
	JE	MACHI_MESS_2ET_S3	;
	CMP	BX,4			; 4=根性
	JE	MACHI_MESS_2ET_S4	;
	CMP	BX,5			; 5=色気
	JE	MACHI_MESS_2ET_S5	;
	CMP	BX,6			; 6=モラル
	JE	MACHI_MESS_2ET_S6	;
	RET
MACHI_MESS_2ET_S0:			; 0=体力
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_2ET_S1:			; 1=腕力
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_2ET_S2:			; 2=知力
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_2ET_S3:			; 3=気品
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_2ET_S4:			; 4=根性
	PRINTX	"@＊＊＊"
	RET
MACHI_MESS_2ET_S5:			; 5=色気
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_2ET_S6:			; 6=モラル
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_2ET	ENDP


; ****************************************************
;	街の声その３・低い能力
; ****************************************************

MACHI_MESS_3ET	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,1			; 根性を除くフラグ=1
	MOV	S_FUNC,60		; 60=体力、腕力・・・で苦手は
	CALLC	R_KEISAN		; 各計算処理

	CMP	BX,0			; 0=体力
	JE	MACHI_MESS_3ET_S0	;
	CMP	BX,1			; 1=腕力
	JE	MACHI_MESS_3ET_S1	;
	CMP	BX,2			; 2=知力
	JE	MACHI_MESS_3ET_S2	;
	CMP	BX,3			; 3=気品
	JE	MACHI_MESS_3ET_S3	;
	CMP	BX,4			; 4=根性
	JE	MACHI_MESS_3ET_S4	;
	CMP	BX,5			; 5=色気
	JE	MACHI_MESS_3ET_S5	;
	CMP	BX,6			; 6=モラル
	JE	MACHI_MESS_3ET_S6	;
	RET
MACHI_MESS_3ET_S0:			; 0=体力
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_3ET_S1:			; 1=腕力
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_3ET_S2:			; 2=知力
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_3ET_S3:			; 3=気品
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_3ET_S4:			; 4=根性
	PRINTX	"@＊＊＊"
	RET
MACHI_MESS_3ET_S5:			; 5=色気
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_3ET_S6:			; 6=モラル
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	RET
MACHI_MESS_3ET	ENDP


; ****************************************************
;	街の声その４・へんなところ
;	-I- MY_FLAGS : ヘッダフラグ
; ****************************************************

MACHI_MESS_4ET	PROC	NEAR
	TEST	MY_FLAGS,FLAGS_HIKOU		; bit13 : 非行化
	JNZ	MACHI_MESS_4ET_HIKOUKA		;

	TEST	MY_FLAGS,FLAGS_BYOUKI		; bit12 : 病気化
	JNZ	MACHI_MESS_4ET_BYOUKI		;

MACHI_MESS_4ET_NORMAL:
	; 　ノーマル時
        ; メッセージなし
	RET
MACHI_MESS_4ET_HIKOUKA:
	;　非行化していたら
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	CALL	TENTENTEN		; ・・・・
	RET
MACHI_MESS_4ET_BYOUKI:
	;　病気時
	PRINTX	"@町の声｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	CALL	TENTENTEN		; ・・・・
	RET
MACHI_MESS_4ET	ENDP


; ****************************************************
;	王様との会見
;	-I- DX : 王様の会見レベル
;	    BX : 会見する相手
;		1=衛兵
;		2=近衛隊長
;		3=侍従
;		4=侍従長
;		5=王妃
;		6=王様
;	-O- AX : 成功か？ 0=だめ,1=成功,2=とりやめ
; ****************************************************

FUNC	RR_MS_OH_KAIKEN,R_MS_OH_KAIKEN
	CALL	TALK_START			; 会話スタート

	DEC	BX
	CMP	BX,6
	JNB	R_MS_OH_KAIKEN_EXIT

	SHL	BX,1				; word pointer.
	CALL	WORD PTR DS:OH_JMP_TBL[BX]	; near jump table.
	CMP	AX,2				; 2=とりやめ
	JE	R_MS_OH_KAIKEN_EXIT		;

	PUSH	AX
	CALLC	WIDFACE_CLOSE_VEW	; WINDOWS/会見フェイスウインドウCLOSE
	POP	AX
R_MS_OH_KAIKEN_EXIT:
	CALL	TALK_END		; 会話ストップ
	RET
FEND	RR_MS_OH_KAIKEN

DATA	SEGMENT	PUBLIC	'DATA'
		EVEN
OH_JMP_TBL	LABEL	WORD
	DW	OFFSET KAIKEN_EIHEI		; ★☆★衛兵★☆★
	DW	OFFSET KAIKEN_EIHEI_TAICHO	; ☆★☆衛兵隊長★☆★
	DW	OFFSET KAIKEN_JIJYU		; ☆★☆侍従★☆★
	DW	OFFSET KAIKEN_JIJYU_CHO		; ★☆★侍従長☆★☆
	DW	OFFSET KAIKEN_OHUHI		; ☆★☆王妃様★☆★
	DW	OFFSET KAIKEN_OHSAMA		; ☆王様☆
DATA	ENDS


; ****************************************************
;	★☆★衛兵★☆★
;	-I- DX : 王様の会見レベル
;	-O- AX : 成功か？ 0=だめ,1=成功,2=とりやめ
; ****************************************************

KAIKEN_EIHEI	PROC	NEAR
	MOV	KING_LEVEL,DX		; 王様の会見レベル

	PRINTX	"城門の前に来ました。"

	WSELECT	"衛兵に会う,やめよう"
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	KAIKEN_EIHEI_YAME
	CMP	WIDSNM,1		; ユーザ選択番号
	JMPEQ	KAIKEN_EIHEI_YAME

	MOV	DX,1			; 衛兵
	CALLC	WIDFACE_OPEN_VEW	; WINDOWS/会見フェイスウインドウOPEN

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_EIHEI],FLG_K_FIRST	; フラグ衛兵・会見２回目以降
	JNZ	KAIKEN_EIHEI_S2			;
KAIKEN_EIHEI_S1:
	ORW	ES:[DI][SLT_EIHEI],FLG_K_FIRST	; フラグ衛兵・会見２回目以降
	; ＊（最初に言う台詞・１回目）＊
	PRINTX	"@衛兵｢＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_EIHEI_SS
KAIKEN_EIHEI_S2:
	; ＊（最初に言う台詞・２階目以降）＊
	PRINTX	"@衛兵｢＊＊＊＊＊＊＊＊」"
KAIKEN_EIHEI_SS:

	CALL	ITS_MINE			; ○○○です

	CMP	KING_LEVEL,LVL_EIHEI		; 会見レベル 衛兵までＯＫ
	JGE	KAIKEN_EIHEI_KK			;

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_EIHEI],FLG_K_KIHIN	; 気品不足２回目以降
	JNZ	KAIKEN_EIHEI_K2			;
KAIKEN_EIHEI_K1:
	ORW	ES:[DI][SLT_EIHEI],FLG_K_KIHIN	; 気品不足２回目以降
	; ＊（気品が足りない場合・１回目）＊
	PRINTX	"@衛兵｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_EIHEI_DAME
KAIKEN_EIHEI_K2:
	; ＊（気品が足りない場合・２回目以降）＊
	PRINTX	"@衛兵｢＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_EIHEI_DAME
KAIKEN_EIHEI_KK:

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_EIHEI],FLG_K_GOKAKU	; 合格２回目以降
	JNZ	KAIKEN_EIHEI_G2			;
KAIKEN_EIHEI_G1:
	ORW	ES:[DI][SLT_EIHEI],FLG_K_GOKAKU	; 合格２回目以降
	; ＊（合格の場合・１回目）＊
	PRINTX	"@衛兵｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"

	MOV	DX,KAIKEN_UP_TBL[1*2]		; 会見によりＵＰする評価 1=衛兵
	CALL	UP_HYOUKA			; ＵＰする評価
	JMP	KAIKEN_EIHEI_GG
KAIKEN_EIHEI_G2:
	; ＊（合格の場合・２回目以降）＊
	PRINTX	"@衛兵｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
KAIKEN_EIHEI_GG:
	CALL	TENTENTEN		; ・・・・
KAIKEN_EIHEI_OK:
	MOV	AX,1			; 成功か？ 1=成功
	RET
KAIKEN_EIHEI_YAME:
	MOV	AX,2			; 成功か？ 2=とりやめ
	RET
KAIKEN_EIHEI_DAME:
	CALL	DAMEDATTA		; だめだった・・・
	MOV	AX,0			; 成功か？ 0=だめ
	RET
KAIKEN_EIHEI	ENDP


; ****************************************************
;	☆★☆衛兵隊長★☆★
;	-I- DX : 王様の会見レベル
;	-O- AX : 成功か？ 0=だめ,1=成功
; ****************************************************

KAIKEN_EIHEI_TAICHO	PROC	NEAR
	MOV	KING_LEVEL,DX		; 王様の会見レベル

	PRINTX	"@衛兵の詰所に通されました。"

	WSELECT	"衛兵隊長に会う"

	MOV	DX,2			; 近衛隊長
	CALLC	WIDFACE_OPEN_VEW	; WINDOWS/会見フェイスウインドウOPEN

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_EIHEI_TAIC],FLG_K_FIRST	; 会見２回目以降
	JNZ	KAIKEN_EIHEI_TAI_S2			;
KAIKEN_EIHEI_TAI_S1:
	ORW	ES:[DI][SLT_EIHEI_TAIC],FLG_K_FIRST	; 会見２回目以降
	; ＊（最初に言う台詞・１回目）＊
	PRINTX	"@衛兵隊長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_EIHEI_TAI_SS
KAIKEN_EIHEI_TAI_S2:
	; ＊（最初に言う台詞・２回目以降）＊
	PRINTX	"@衛兵隊長｢＊＊＊＊＊＊＊＊＊」"
KAIKEN_EIHEI_TAI_SS:

	CALL	ITS_MINE			; ○○○です

	CMP	KING_LEVEL,LVL_EIHEI_TAIC	; 会見レベル 近衛隊長までＯＫ
	JGE	KAIKEN_EIHEI_TAI_KK		;

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_EIHEI_TAIC],FLG_K_KIHIN	; 気品不足２回目以降
	JNZ	KAIKEN_EIHEI_TAI_K2			;
KAIKEN_EIHEI_TAI_K1:
	ORW	ES:[DI][SLT_EIHEI_TAIC],FLG_K_KIHIN	; 気品不足２回目以降
	; ＊（気品が足りない場合・１回目）＊
	PRINTX	"@衛兵隊長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_EIHEI_TAI_DAME
KAIKEN_EIHEI_TAI_K2:
	; ＊（気品が足りない場合・２回目以降）＊
	PRINTX	"@衛兵隊長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_EIHEI_TAI_DAME
KAIKEN_EIHEI_TAI_KK:

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_EIHEI_TAIC],FLG_K_GOKAKU	; 合格２回目以降
	JNZ	KAIKEN_EIHEI_TAI_G2		;
KAIKEN_EIHEI_TAI_G1:
	ORW	ES:[DI][SLT_EIHEI_TAIC],FLG_K_GOKAKU	; 合格２回目以降
	; ＊（合格の場合・１回目）＊
	PRINTX	"@衛兵隊長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"

	MOV	DX,KAIKEN_UP_TBL[2*2]	; 会見によりＵＰする評価 2=近衛隊長
	CALL	UP_HYOUKA		; ＵＰする評価
	JMP	KAIKEN_EIHEI_TAI_GG
KAIKEN_EIHEI_TAI_G2:
	; ＊（合格の場合・２回目以降）＊
	PRINTX	"@衛兵隊長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
KAIKEN_EIHEI_TAI_GG:
	CALL	TENTENTEN		; ・・・・
KAIKEN_EIHEI_TAI_OK:
	MOV	AX,1			; 成功か？ 1=成功
	RET
KAIKEN_EIHEI_TAI_DAME:
	CALL	DAMEDATTA		; だめだった・・・
	MOV	AX,0			; 成功か？ 0=だめ
	RET
KAIKEN_EIHEI_TAICHO	ENDP


; ****************************************************
;	☆★☆侍従★☆★
;	-I- DX : 王様の会見レベル
;	-O- AX : 成功か？ 0=だめ,1=成功
; ****************************************************

KAIKEN_JIJYU	PROC	NEAR
	MOV	KING_LEVEL,DX		; 王様の会見レベル

	PRINTX	"@侍従の控室に案内されました。"

	WSELECT	"侍従に会う"

	MOV	DX,3			; 侍従
	CALLC	WIDFACE_OPEN_VEW	; WINDOWS/会見フェイスウインドウOPEN

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_JIJYU],FLG_K_FIRST	; 会見２回目以降
	JNZ	KAIKEN_JIJYU_S2			;
KAIKEN_JIJYU_S1:
	ORW	ES:[DI][SLT_JIJYU],FLG_K_FIRST	; 会見２回目以降
	; ＊（最初に言う台詞・１回目）＊
	PRINTX	"@侍従｢＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_JIJYU_SS
KAIKEN_JIJYU_S2:
	; ＊（最初に言い台詞・２回目以降）＊
	PRINTX	"@侍従｢＊＊＊＊＊＊＊＊＊＊＊」"
KAIKEN_JIJYU_SS:

	CALL	ITS_MINE			; ○○○です

	CMP	KING_LEVEL,LVL_JIJYU		; 会見レベル 侍従までＯＫ
	JGE	KAIKEN_JIJYU_KK			;

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_JIJYU],FLG_K_KIHIN	; 気品不足２回目以降
	JNZ	KAIKEN_JIJYU_K2			;
KAIKEN_JIJYU_K1:
	ORW	ES:[DI][SLT_JIJYU],FLG_K_KIHIN	; 気品不足２回目以降
	; ＊（気品が足りない場合・１回目）＊
	PRINTX	"@侍従｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_JIJYU_DAME
KAIKEN_JIJYU_K2:
	; ＊（気品が足りない場合・２回目以降）＊
	PRINTX "@侍従｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_JIJYU_DAME
KAIKEN_JIJYU_KK:

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_JIJYU],FLG_K_GOKAKU	; 合格２回目以降
	JNZ	KAIKEN_JIJYU_G2			;
KAIKEN_JIJYU_G1:
	ORW	ES:[DI][SLT_JIJYU],FLG_K_GOKAKU	; 合格２回目以降
	; ＊（合格の場合・１回目）＊
	PRINTX	"@侍従｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"

	MOV	DX,KAIKEN_UP_TBL[3*2]	; 会見によりＵＰする評価 3=侍従
	CALL	UP_HYOUKA		; ＵＰする評価
	JMP	KAIKEN_JIJYU_GG
KAIKEN_JIJYU_G2:
	; ＊（合格の場合・２回目以降）
	PRINTX	"@侍従｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
KAIKEN_JIJYU_GG:
	CALL	TENTENTEN		; ・・・・
KAIKEN_JIJYU_OK:
	MOV	AX,1			; 成功か？ 1=成功
	RET
KAIKEN_JIJYU_DAME:
	CALL	DAMEDATTA		; だめだった・・・
	MOV	AX,0			; 成功か？ 0=だめ
	RET
KAIKEN_JIJYU	ENDP


; ****************************************************
;	★☆★侍従長☆★☆
;	-I- DX : 王様の会見レベル
;	-O- AX : 成功か？ 0=だめ,1=成功
; ****************************************************

KAIKEN_JIJYU_CHO	PROC	NEAR
	MOV	KING_LEVEL,DX		; 王様の会見レベル

	PRINTX	"@侍従長の執務室に通されました。"

	WSELECT	"侍従長に会う"

	MOV	DX,4			; 侍従長
	CALLC	WIDFACE_OPEN_VEW	; WINDOWS/会見フェイスウインドウOPEN

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_JIJYU_CHO],FLG_K_FIRST	; 会見２回目以降
	JNZ	KAIKEN_JIJYU_CHO_S2		;
KAIKEN_JIJYU_CHO_S1:
	ORW	ES:[DI][SLT_JIJYU_CHO],FLG_K_FIRST	; 会見２回目以降
	; ＊（最初に言う台詞・１回目）＊
	PRINTX	"@侍従長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_JIJYU_CHO_SS
KAIKEN_JIJYU_CHO_S2:
	; ＊（最初に言う台詞・２回目）＊
	PRINTX	"@侍従長｢＊＊＊＊＊＊＊＊」"
KAIKEN_JIJYU_CHO_SS:

	CALL	ITS_MINE			; ○○○です

	CMP	KING_LEVEL,LVL_JIJYU_CHO	; 会見レベル 侍従長までＯＫ
	JGE	KAIKEN_JIJYU_CHO_KK		;

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_JIJYU_CHO],FLG_K_KIHIN	; 気品不足２回目以降
	JNZ	KAIKEN_JIJYU_CHO_K2		;
KAIKEN_JIJYU_CHO_K1:
	ORW	ES:[DI][SLT_JIJYU_CHO],FLG_K_KIHIN	; 気品不足２回目以降
	; ＊（気品が足りない場合・１回目）＊
	PRINTX	"@侍従長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_JIJYU_CHO_DAME
KAIKEN_JIJYU_CHO_K2:
	; ＊（気品が足りない場合・２回目以降）＊
	PRINTX	"@侍従長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_JIJYU_CHO_DAME
KAIKEN_JIJYU_CHO_KK:

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_JIJYU_CHO],FLG_K_GOKAKU	; 合格２回目以降
	JNZ	KAIKEN_JIJYU_CHO_G2			;
KAIKEN_JIJYU_CHO_G1:
	ORW	ES:[DI][SLT_JIJYU_CHO],FLG_K_GOKAKU	; 合格２回目以降
	; ＊（合格の場合・１回目）＊
	PRINTX	"@侍従長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊」"

	MOV	DX,KAIKEN_UP_TBL[4*2]	; 会見によりＵＰする評価 4=侍従長
	CALL	UP_HYOUKA		; ＵＰする評価
	JMP	KAIKEN_JIJYU_CHO_GG
KAIKEN_JIJYU_CHO_G2:
	; ＊（合格の場合・２回目以降）
	PRINTX	"@侍従長｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
KAIKEN_JIJYU_CHO_GG:
	CALL	TENTENTEN		; ・・・・
KAIKEN_JIJYU_CHO_OK:
	MOV	AX,1			; 成功か？ 1=成功
	RET
KAIKEN_JIJYU_CHO_DAME:
	CALL	DAMEDATTA		; だめだった・・・
	MOV	AX,0			; 成功か？ 0=だめ
	RET
KAIKEN_JIJYU_CHO	ENDP


; ****************************************************
;	☆★☆王妃様★☆★
;	-I- DX : 王様の会見レベル
;	-O- AX : 成功か？ 0=だめ,1=成功
; ****************************************************

KAIKEN_OHUHI	PROC	NEAR
	MOV	KING_LEVEL,DX		; 王様の会見レベル

	PRINTX	"@王妃様にお目通りしました……"

	WSELECT	"王妃様に会う"

	MOV	DX,5			; 王妃様
	CALLC	WIDFACE_OPEN_VEW	; WINDOWS/会見フェイスウインドウOPEN

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_OHUHI],FLG_K_FIRST	; 会見２回目以降
	JNZ	KAIKEN_OHUHI_S2			;
KAIKEN_OHUHI_S1:
	ORW	ES:[DI][SLT_OHUHI],FLG_K_FIRST	; 会見２回目以降
	; ＊（最初に言う台詞・１回目）＊
	PRINTX	"@王妃｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_OHUHI_SS
KAIKEN_OHUHI_S2:
	; ＊（最初に言う台詞・２回目以降）＊
	PRINTX	"@王妃｢＊＊＊＊＊＊＊＊＊＊＊＊＊」"
KAIKEN_OHUHI_SS:

	CALL	ITS_MINE			; ○○○です

	CMP	KING_LEVEL,LVL_OHUHI		; 会見レベル 王妃までＯＫ
	JGE	KAIKEN_OHUHI_KK			;

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_OHUHI],FLG_K_KIHIN	; 気品不足２回目以降
	JNZ	KAIKEN_OHUHI_K2			;
KAIKEN_OHUHI_K1:
	ORW	ES:[DI][SLT_OHUHI],FLG_K_KIHIN	; 気品不足２回目以降
	; ＊（気品が足りない場合・１回目）＊
	PRINTX	"@王妃｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_OHUHI_DAME
KAIKEN_OHUHI_K2:
	; ＊（気品が足りない場合・２回目以降）＊
	PRINTX	"@王妃｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_OHUHI_DAME
KAIKEN_OHUHI_KK:

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_OHUHI],FLG_K_GOKAKU	; 合格２回目以降
	JNZ	KAIKEN_OHUHI_G2			;
KAIKEN_OHUHI_G1:
	ORW	ES:[DI][SLT_OHUHI],FLG_K_GOKAKU	; 合格２回目以降
	; ＊（合格の場合・１回目）＊
	PRINTX	"@王妃｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	MOV	DX,KAIKEN_UP_TBL[5*2]	; 会見によりＵＰする評価 5=王妃
	CALL	UP_HYOUKA		; ＵＰする評価
	JMP	KAIKEN_OHUHI_GG
KAIKEN_OHUHI_G2:
	; ＊（合格の場合）＊
	PRINTX	"@王妃｢＊＊＊＊＊＊＊＊＊＊＊＊＊」"
KAIKEN_OHUHI_GG:
	CALL	TENTENTEN		; ・・・・
KAIKEN_OHUHI_OK:
	MOV	AX,1			; 成功か？ 1=成功
	RET
KAIKEN_OHUHI_DAME:
	CALL	DAMEDATTA		; だめだった・・・
	MOV	AX,0			; 成功か？ 0=だめ
	RET
KAIKEN_OHUHI	ENDP



; ****************************************************
;	☆王様☆
;	-I- DX : 王様の会見レベル
;	-O- AX : 成功か？ 0=だめ,1=成功
; ****************************************************

KAIKEN_OHSAMA	PROC	NEAR
	MOV	KING_LEVEL,DX		; 王様の会見レベル

	PRINTX	"@王様の謁見室に案内されました。"

	WSELECT	"王様に会う"

	MOV	DX,6			; 王様
	CALLC	WIDFACE_OPEN_VEW	; WINDOWS/会見フェイスウインドウOPEN

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_OHSAMA],FLG_K_FIRST	; 会見２回目以降
	JNZ	KAIKEN_OHSAMA_S2		;
KAIKEN_OHSAMA_S1:
	ORW	ES:[DI][SLT_OHSAMA],FLG_K_FIRST	; 会見２回目以降
	; ＊（最初に言う台詞・１回目）＊
	PRINTX	"@王様｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_OHSAMA_SS
KAIKEN_OHSAMA_S2:
	; ＊（最初に言う台詞・２回目以降）
	PRINTX	"@王様｢＊＊＊＊＊＊」"
KAIKEN_OHSAMA_SS:

	CALL	ITS_MINE			; ○○○です

	CMP	KING_LEVEL,LVL_OHSAMA		; 会見レベル 王様までＯＫ
	JGE	KAIKEN_OHSAMA_KK		;

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_OHSAMA],FLG_K_KIHIN	; 気品不足２回目以降
	JNZ	KAIKEN_OHSAMA_K2		;
KAIKEN_OHSAMA_K1:
	ORW	ES:[DI][SLT_OHSAMA],FLG_K_KIHIN	; 気品不足２回目以降
	; ＊（気品が足りない場合・１回目）＊
	PRINTX	"@王様｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_OHSAMA_DAME
KAIKEN_OHSAMA_K2:
	; ＊（気品が足りない場合・２回目）＊
	PRINTX	"@王様｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	KAIKEN_OHSAMA_DAME
KAIKEN_OHSAMA_KK:

	MOV	ES,KAIKEN_FLG_SEG		; 会見フラグセグメント
	MOV	DI,KAIKEN_FLG_OFS		; 会見フラグオフセット
	TSTW	ES:[DI][SLT_OHSAMA],FLG_K_GOKAKU	; 合格２回目以降
	JNZ	KAIKEN_OHSAMA_G2			;
KAIKEN_OHSAMA_G1:
	ORW	ES:[DI][SLT_OHSAMA],FLG_K_GOKAKU	; 合格２回目以降
	; ＊（合格の場合・１回目）＊
	PRINTX	"@王様｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	CALLC	R_SR_GIRL_FNAME			; キャラクタ姓
	PRINTX	"＊＊＊"
	CALL	HAIHAI				; ハイ・・
	PRINTX	"@＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	PRINTX	"＊＊＊＊＊＊＊＊＊＊」"
	WSELECT	"はい！"

	MOV	DX,KAIKEN_UP_TBL[6*2]	; 会見によりＵＰする評価 6=王様
	CALL	UP_HYOUKA		; ＵＰする評価
	JMP	KAIKEN_OHSAMA_GG
KAIKEN_OHSAMA_G2:
	; ＊（合格の場合・２回目以降）＊
	PRINTX	"@王様｢＊＊＊＊＊"
	CALL	MY_GIRL_NAME			; 娘の名前
	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	WSELECT	"はい！"
KAIKEN_OHSAMA_GG:
KAIKEN_OHSAMA_OK:
	MOV	AX,1			; 成功か？ 1=成功
	RET
KAIKEN_OHSAMA_DAME:
	CALL	TENTENTEN		; ・・・・
	MOV	AX,0			; 成功か？ 0=だめ
	RET
KAIKEN_OHSAMA	ENDP


; ****************************************************
;	スケジュール選択時のメッセージ
;	-I- AX : 決定か？1=決定,2=中止
;	    BX : 項目
;		0=武芸
;		1=学問
;		2=礼法
;		3=武者修行
;		4=アルバイト
;		5=休息
;		6=バカンス
; ****************************************************

FUNC	RR_MS_SCHED_TXT,R_MS_SCHED_TXT

;*;CODE_IN
;*;	LC	0,15
;*;	PRV	"AX : 決定か？1=決定,2=中止:",AX
;*;	PRV	"BX :                  項目:",BX
;*;CODE_OUT
	MOV	FLG_KETTEI,AX			; 決定か？1=決定,2=中止
	MOV	NUM_KOUMOKU,BX			; 項目

	MOV	AX,SEG R_SEG3		;
	MOV	MESS_SEG,AX		; メッセージセグメント
	CALLC	TKRHME			; 台詞ホームポジション

	CALL	HOW_MANY_YEARS			; 何年目か

	MOVX	ES,<SEG R_SEG3>			;
	MOV	BX,NUM_KOUMOKU			; 項目
	SHL	BX,1				; word pointer.

	CMP	HOW_LONG_YEAR,2			; ２年以内
	JLE	R_MS_SCHED_TXT_Y12		;
	CMP	HOW_LONG_YEAR,4			; ４年以内
	JLE	R_MS_SCHED_TXT_Y34		;
	CMP	HOW_LONG_YEAR,6			; ６年以内
	JLE	R_MS_SCHED_TXT_Y56		;
	JMP	R_MS_SCHED_TXT_Y78		; それ以上

R_MS_SCHED_TXT_Y12:				;
	CMP	FLG_KETTEI,2			; 決定か？1=決定,2=中止
	JE	R_MS_SCHED_TXT_N12		;
	MOV	SI,ES:MSG_SC_12_YES[BX]		; １～２年のＹＥＳ
	JMP	R_MS_SCHED_TXT_PRN		;
R_MS_SCHED_TXT_N12:				;
	MOV	SI,ES:MSG_SC_12_NO[BX]		; １～２年のＮＯ
	JMP	R_MS_SCHED_TXT_PRN		;

R_MS_SCHED_TXT_Y34:				;
	CMP	FLG_KETTEI,2			; 決定か？1=決定,2=中止
	JE	R_MS_SCHED_TXT_N34		;
	MOV	SI,ES:MSG_SC_34_YES[BX]		; ３～４年のＹＥＳ
	JMP	R_MS_SCHED_TXT_PRN		;
R_MS_SCHED_TXT_N34:				;
	MOV	SI,ES:MSG_SC_34_NO[BX]		; ３～４年のＮＯ
	JMP	R_MS_SCHED_TXT_PRN		;

R_MS_SCHED_TXT_Y56:				;
	CMP	FLG_KETTEI,2			; 決定か？1=決定,2=中止
	JE	R_MS_SCHED_TXT_N56		;
	MOV	SI,ES:MSG_SC_56_YES[BX]		; ５～６年のＹＥＳ
	JMP	R_MS_SCHED_TXT_PRN		;
R_MS_SCHED_TXT_N56:				;
	MOV	SI,ES:MSG_SC_56_NO[BX]		; ５～６年のＮＯ
	JMP	R_MS_SCHED_TXT_PRN		;

R_MS_SCHED_TXT_Y78:				;
	CMP	FLG_KETTEI,2			; 決定か？1=決定,2=中止
	JE	R_MS_SCHED_TXT_N78		;
	MOV	SI,ES:MSG_SC_78_YES[BX]		; ７～８年のＹＥＳ
	JMP	R_MS_SCHED_TXT_PRN		;
R_MS_SCHED_TXT_N78:				;
	MOV	SI,ES:MSG_SC_78_NO[BX]		; ７～８年のＮＯ
	JMP	R_MS_SCHED_TXT_PRN		;

R_MS_SCHED_TXT_PRN:
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	RET
FEND	RR_MS_SCHED_TXT


TEXT_IN
		EVEN
MSG_SC_12_YES	LABEL	WORD			; １～２年のＹＥＳ
	DW	MSG_SC_BUGEI_12_Y		; 0=武芸
	DW	MSG_SC_GAKUMON_12_Y		; 1=学問
	DW	MSG_SC_REIHOU_12_Y		; 2=礼法
	DW	MSG_SC_MUSYA_12_Y		; 3=武者修行
	DW	MSG_SC_ALBA_12_Y		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_12_Y		; 5=休息
	DW	MSG_SC_BACA_12_Y		; 6=バカンス
MSG_SC_12_NO	LABEL	WORD			; １～２年のＮＯ
	DW	MSG_SC_BUGEI_12_N		; 0=武芸
	DW	MSG_SC_GAKUMON_12_N		; 1=学問
	DW	MSG_SC_REIHOU_12_N		; 2=礼法
	DW	MSG_SC_MUSYA_12_N		; 3=武者修行
	DW	MSG_SC_ALBA_12_N		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_12_N		; 5=休息
	DW	MSG_SC_BACA_12_N		; 6=バカンス

MSG_SC_34_YES	LABEL	WORD			; ３～４年のＹＥＳ
	DW	MSG_SC_BUGEI_34_Y		; 0=武芸
	DW	MSG_SC_GAKUMON_34_Y		; 1=学問
	DW	MSG_SC_REIHOU_34_Y		; 2=礼法
	DW	MSG_SC_MUSYA_34_Y		; 3=武者修行
	DW	MSG_SC_ALBA_34_Y		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_34_Y		; 5=休息
	DW	MSG_SC_BACA_34_Y		; 6=バカンス
MSG_SC_34_NO	LABEL	WORD			; ３～４年のＮＯ
	DW	MSG_SC_BUGEI_34_N		; 0=武芸
	DW	MSG_SC_GAKUMON_34_N		; 1=学問
	DW	MSG_SC_REIHOU_34_N		; 2=礼法
	DW	MSG_SC_MUSYA_34_N		; 3=武者修行
	DW	MSG_SC_ALBA_34_N		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_34_N		; 5=休息
	DW	MSG_SC_BACA_34_N		; 6=バカンス

MSG_SC_56_YES	LABEL	WORD			; ５～６年のＹＥＳ
	DW	MSG_SC_BUGEI_56_Y		; 0=武芸
	DW	MSG_SC_GAKUMON_56_Y		; 1=学問
	DW	MSG_SC_REIHOU_56_Y		; 2=礼法
	DW	MSG_SC_MUSYA_56_Y		; 3=武者修行
	DW	MSG_SC_ALBA_56_Y		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_56_Y		; 5=休息
	DW	MSG_SC_BACA_56_Y		; 6=バカンス
MSG_SC_56_NO	LABEL	WORD			; ５～６年のＮＯ
	DW	MSG_SC_BUGEI_56_N		; 0=武芸
	DW	MSG_SC_GAKUMON_56_N		; 1=学問
	DW	MSG_SC_REIHOU_56_N		; 2=礼法
	DW	MSG_SC_MUSYA_56_N		; 3=武者修行
	DW	MSG_SC_ALBA_56_N		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_56_N		; 5=休息
	DW	MSG_SC_BACA_56_N		; 6=バカンス

MSG_SC_78_YES	LABEL	WORD			; ７～８年のＹＥＳ
	DW	MSG_SC_BUGEI_78_Y		; 0=武芸
	DW	MSG_SC_GAKUMON_78_Y		; 1=学問
	DW	MSG_SC_REIHOU_78_Y		; 2=礼法
	DW	MSG_SC_MUSYA_78_Y		; 3=武者修行
	DW	MSG_SC_ALBA_78_Y		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_78_Y		; 5=休息
	DW	MSG_SC_BACA_78_Y		; 6=バカンス
MSG_SC_78_NO	LABEL	WORD			; ７～８年のＮＯ
	DW	MSG_SC_BUGEI_78_N		; 0=武芸
	DW	MSG_SC_GAKUMON_78_N		; 1=学問
	DW	MSG_SC_REIHOU_78_N		; 2=礼法
	DW	MSG_SC_MUSYA_78_N		; 3=武者修行
	DW	MSG_SC_ALBA_78_N		; 4=アルバイト
	DW	MSG_SC_KYUSOKU_78_N		; 5=休息
	DW	MSG_SC_BACA_78_N		; 6=バカンス


	;★武芸

MSG_SC_BUGEI_12_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;１～２年目
MSG_SC_BUGEI_12_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊",0				;中止

MSG_SC_BUGEI_34_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;３～４年目
MSG_SC_BUGEI_34_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊",0		;中止

MSG_SC_BUGEI_56_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊"				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;５～６年目
MSG_SC_BUGEI_56_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊",0			;中止

MSG_SC_BUGEI_78_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;７～８年目
MSG_SC_BUGEI_78_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊",0			;中止


	;★学問

MSG_SC_GAKUMON_12_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;１～２年目
MSG_SC_GAKUMON_12_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊",0			;中止

MSG_SC_GAKUMON_34_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0			;３～４年目
MSG_SC_GAKUMON_34_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;中止

MSG_SC_GAKUMON_56_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0			;５～６年目
MSG_SC_GAKUMON_56_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊",0			;中止

MSG_SC_GAKUMON_78_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;７～８年目
MSG_SC_GAKUMON_78_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊",0			;中止

	;★礼法

MSG_SC_REIHOU_12_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊"			;
	DB	"＊＊＊＊＊＊＊＊＊＊＊",0		;１～２年目
MSG_SC_REIHOU_12_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;中止

MSG_SC_REIHOU_34_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊"				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;３～４年目
MSG_SC_REIHOU_34_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊",0				;中止

MSG_SC_REIHOU_56_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊"				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;５～６年目
MSG_SC_REIHOU_56_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊",0			;中止

MSG_SC_REIHOU_78_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;７～８年目
MSG_SC_REIHOU_78_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊",0				;中止

	;★武者修行

MSG_SC_MUSYA_12_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊"			;
	DB	"＊＊＊＊＊＊＊＊＊＊＊",0			;１～２年目
MSG_SC_MUSYA_12_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;中止

MSG_SC_MUSYA_34_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;３～４年目
MSG_SC_MUSYA_34_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊",0			;中止

MSG_SC_MUSYA_56_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;５～６年目
MSG_SC_MUSYA_56_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊",0		;中止

MSG_SC_MUSYA_78_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊"			;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;７～８年目
MSG_SC_MUSYA_78_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊",0			;中止

	;★アルバイト

MSG_SC_ALBA_12_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊"			;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0			;１～２年目
MSG_SC_ALBA_12_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊",0				;中止

MSG_SC_ALBA_34_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;３～４年目
MSG_SC_ALBA_34_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;中止

MSG_SC_ALBA_56_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;５～６年目
MSG_SC_ALBA_56_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊",0			;中止

MSG_SC_ALBA_78_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;７～８年目
MSG_SC_ALBA_78_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊",0				;中止

	;★休息

MSG_SC_KYUSOKU_12_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊"				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0			;１～２年目
MSG_SC_KYUSOKU_12_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊"				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;中止

MSG_SC_KYUSOKU_34_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;３～４年目
MSG_SC_KYUSOKU_34_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;中止

MSG_SC_KYUSOKU_56_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;５～６年目
MSG_SC_KYUSOKU_56_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊",0				;中止

MSG_SC_KYUSOKU_78_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;７～８年目
MSG_SC_KYUSOKU_78_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊"				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;中止

	;★バカンス

MSG_SC_BACA_12_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊"				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;１～２年目
MSG_SC_BACA_12_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;中止

MSG_SC_BACA_34_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊",0		;３～４年目
MSG_SC_BACA_34_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊",0				;中止

MSG_SC_BACA_56_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"		;
	DB	"＊＊＊＊＊＊＊",0				;５～６年目
MSG_SC_BACA_56_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊"					;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊",0		;中止

MSG_SC_BACA_78_Y	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;７～８年目
MSG_SC_BACA_78_N	LABEL	BYTE				;
	DB	"＊＊＊＊＊＊＊＊＊"			;
	DB	"＊＊＊＊＊＊＊",0			;中止

TEXT_OUT


; ****************************************************
;	王様との会見選択時
; ****************************************************

FUNC	RR_MS_OH_KAISRT,R_MS_OH_KAISRT
	CALL	TALK_START			; 会話スタート

	PRINTX	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,0				; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41			; 41=ヘッダーフラグのＩ／Ｏ
	CALLC	R_KEISAN			; 各計算処理
	MOV	MY_FLAGS,DX			; ヘッダフラグ

	CALL	HOW_MANY_YEARS			; 何年目か

	MOVX	ES,<SEG R_SEG3>			;
	TEST	MY_FLAGS,FLAGS_BYOUKI		;bit12 : 病気化
	JNZ	R_MS_OH_KAISRT_BYOUKI		;
	TEST	MY_FLAGS,FLAGS_HIKOU		;bit13 : 非行化
	JNZ	R_MS_OH_KAISRT_HIKOU		;

R_MS_OH_KAISRT_NORMAL:
	MOV	SI,ES:OHKAI_TX_NORMAL[BX]	; 通常
	JMP	R_MS_OH_KAISRT_EXIT
R_MS_OH_KAISRT_BYOUKI:
	MOV	SI,ES:OHKAI_TX_BYOUKI[BX]	; 病気
	JMP	R_MS_OH_KAISRT_EXIT
R_MS_OH_KAISRT_HIKOU:
	MOV	SI,ES:OHKAI_TX_HIKOU[BX]	; 非行
R_MS_OH_KAISRT_EXIT:
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	CALL	TALK_FIN			; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_OH_KAISRT

TEXT_IN

OHKAI_TX_NORMAL	LABEL	WORD			; 通常
		DW	OHKAI_TX12NR		; １～２年目
		DW	OHKAI_TX34NR		; ３～４年目
		DW	OHKAI_TX56NR		; ５～６年目
		DW	OHKAI_TX78NR		; ７～８年目
OHKAI_TX_BYOUKI	LABEL	WORD			; 病気
		DW	OHKAI_TX12BY		;１～２年目
		DW	OHKAI_TX34BY		;３～４年目
		DW	OHKAI_TX56BY		;５～６年目
		DW	OHKAI_TX78BY		;７～８年目
OHKAI_TX_HIKOU	LABEL	WORD			; 非行
		DW	OHKAI_TX12HI		;１～２年目
		DW	OHKAI_TX34HI		;３～４年目
		DW	OHKAI_TX56HI		;５～６年目
		DW	OHKAI_TX78HI		;７～８年目

	;１～２年目
OHKAI_TX12NR	DB	"｢＊＊＊＊＊＊＊＊＊＊＊」",0			;通常
OHKAI_TX12BY	DB	"｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0		;病気
OHKAI_TX12HI	DB	"｢＊＊」",0					;非行

	;３～４年目
OHKAI_TX34NR	DB	"｢＊＊＊」",0					;通常
OHKAI_TX34BY	DB	"｢＊＊＊＊＊＊＊＊＊」",0		;病気
OHKAI_TX34HI	DB	"｢＊＊＊＊＊＊＊」",0				;非行

	;５～６年目
OHKAI_TX56NR	DB	"｢＊＊＊＊＊＊＊＊＊」",0			;通常
OHKAI_TX56BY	DB	"｢＊＊＊＊＊＊＊＊＊＊＊」",0	;病気
OHKAI_TX56HI	DB	"｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0;非行

	;７～８年目
OHKAI_TX78NR	DB	"｢＊＊＊＊＊＊＊」",0			;通常
OHKAI_TX78BY	DB	"｢＊＊＊＊」",0		;病気
OHKAI_TX78HI	DB	"｢＊＊＊＊＊＊＊＊」",0			;非行

TEXT_OUT


; ****************************************************
;	王様のほめ言葉
;	-I- BX : 項目
;		1=ミス表彰式
;		2=ミス自分の娘が優勝の場合
;		3=武闘会表彰式
;		4=武闘会自分の娘が優勝の場合
;		5=武闘会自分の娘が準優勝の場合
; ****************************************************

FUNC	RR_MS_OH_HOMERU,R_MS_OH_HOMERU
	CMP	BX,1			; 1=ミス表彰式
	JE	R_MS_OH_HOMERU_MISS_11	;
	CMP	BX,2			; 2=ミス自分の娘が優勝の場合
	JE	R_MS_OH_HOMERU_MISS_22	;
	CMP	BX,3			; 3=武闘会表彰式
	JE	R_MS_OH_HOMERU_MISS_33	;
	CMP	BX,4			; 4=武闘会自分の娘が優勝の場合
	JE	R_MS_OH_HOMERU_MISS_44	;
	CMP	BX,5			; 5=武闘会自分の娘が準優勝の場合
	JE	R_MS_OH_HOMERU_MISS_55	;

	JMP	RR_MS_OH_HOMERU_EXIT	;

	; コマンド
	; '&n'	名前
	; '&f'	姓
	; '&t'	敵名前

R_MS_OH_HOMERU_MISS_11:		; ＊表彰式
	PRINTX	"王｢&t＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」@"
	CALLC	TKWAIT		; 台詞改行のプレイヤー待ち
	PRINTX	"&t｢＊＊＊＊＊＊＊＊＊＊」"
	JMP	RR_MS_OH_HOMERU_EXIT

R_MS_OH_HOMERU_MISS_22:		; ＊自分の娘が優勝の場合
	PRINTX	"王｢&n＊＊＊＊＊＊＊＊＊&f＊＊＊＊＊＊＊＊＊＊＊」@"
	CALLC	TKWAIT		; 台詞改行のプレイヤー待ち
	PRINTX	"&n｢＊＊＊＊＊＊＊＊」"
	JMP	RR_MS_OH_HOMERU_EXIT

R_MS_OH_HOMERU_MISS_33:			;
	PRINTX	"王｢&t＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」@"
	PRINTX	"&t｢＊＊＊＊＊」"
	JMP	RR_MS_OH_HOMERU_EXIT

R_MS_OH_HOMERU_MISS_44:			;＊自分の娘が優勝した場合
	PRINTX	"王｢&n＊＊＊＊＊＊＊＊＊＊＊＊＊&f＊＊＊＊＊」@"
	PRINTX	"&n｢＊＊＊＊＊＊＊＊＊＊」"
	JMP	RR_MS_OH_HOMERU_EXIT

R_MS_OH_HOMERU_MISS_55:			;＊自分の娘が準優勝の場合
	PRINTX	"王｢&t＊＊＊＊＊＊＊&n＊＊＊＊＊＊＊」@"
	JMP	RR_MS_OH_HOMERU_EXIT

RR_MS_OH_HOMERU_EXIT:
	RET
FEND	RR_MS_OH_HOMERU


; ****************************************************
;	武闘会メッセージ
;	-I- BX : メッセージ番号
;		1=開始時・１回戦目
;		2=開始時・次
;		3=終了時・勝ち
;		4=終了時・負け
; ****************************************************

FUNC	RR_MS_BUTOH,R_MS_BUTOH
	MOV	MESS_NM,BX		; メッセージ番号

	CALL	TALK_START		; 会話スタート

	CMP	MESS_NM,1		; メッセージ番号
	JE	R_MS_BUTOH_N01		;
	CMP	MESS_NM,2		; メッセージ番号
	JE	R_MS_BUTOH_N02		;
	CMP	MESS_NM,3		; メッセージ番号
	JE	R_MS_BUTOH_N03		;
	CMP	MESS_NM,4		; メッセージ番号
	JE	R_MS_BUTOH_N04		;

	JMP	R_MS_BUTOH_EXIT		;


R_MS_BUTOH_N01:
	PRINTX	"第一回戦の相手は@"
	MOVX	R_SR_CHR_ADRS,WIDTK_CHAR_OF ; 敵キャラクタアドレス
	CALLC	R_SR_TOKU_MESSAGE	; 特徴のメッセージ
	PRINTX	"だ！"
	JMP	R_MS_BUTOH_EXIT		;

R_MS_BUTOH_N02:
	PRINTX	"次の相手は@"
	MOVX	R_SR_CHR_ADRS,WIDTK_CHAR_OF ; 敵キャラクタアドレス
	CALLC	R_SR_TOKU_MESSAGE	; 特徴のメッセージ
	PRINTX	"だ！"			;
	JMP	R_MS_BUTOH_EXIT		;

R_MS_BUTOH_N03:
	PRINTX	"&t"
	MOV	DX,2			; 感情フラグ 2=好意
	CALLC	R_SENTOU_MSG		; 敵好メッセージ
	CALLC	TKWAIT			; 台詞改行のプレイヤー待ち
	PRINTX	"@＊＊＊＊@&n＊＊＊＊＊@&t＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	;* 田舎に帰っていった……"
	JMP	R_MS_BUTOH_EXIT		;

R_MS_BUTOH_N04:
	PRINTX	"&n＊＊＊＊＊＊＊＊＊＊＊＊"
	CALLC	TKWAIT			; 台詞改行のプレイヤー待ち
	PRINTX	"@&t"
	MOV	DX,1			; 感情フラグ 1=敵意
	CALLC	R_SENTOU_MSG		; 敵好メッセージ
	PRINTX	"@&n｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」"
	JMP	R_MS_BUTOH_EXIT		;

R_MS_BUTOH_EXIT:
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_BUTOH


; ****************************************************
;	その他メッセージ
;	-I- BX : メッセージ番号
;		1=
;		2=
;		3=
; ****************************************************

FUNC	RR_MS_MESSAGE,R_MS_MESSAGE
	MOV	MESS_NM,BX			; メッセージ番号

	CALL	TALK_SRT02			; 会話スタート（クリア無し）

	CMP	MESS_NM,1			; メッセージ番号
	JE	R_MS_MESSAGE_N01		;
	CMP	MESS_NM,2			; メッセージ番号
	JE	R_MS_MESSAGE_N02		;
	CMP	MESS_NM,3			; メッセージ番号
	JE	R_MS_MESSAGE_N03		;

	JMP	RR_MS_MESSAGE_EXIT

	; コマンド
	; '&n'	名前
	; '&f'	姓
	; '&t'	敵名前

R_MS_MESSAGE_N01:				;＊勝ったとき
	JMP	RR_MS_MESSAGE_EXIT

R_MS_MESSAGE_N02:				;＊負けたとき
	JMP	RR_MS_MESSAGE_EXIT

R_MS_MESSAGE_N03:
	JMP	RR_MS_MESSAGE_EXIT

RR_MS_MESSAGE_EXIT:
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_MESSAGE


; ****************************************************
;	休息時
;	-I- AX : 1=開始,2=終了
; ****************************************************

FUNC	RR_MS_KYUSOKU,R_MS_KYUSOKU
	MOV	KAISHI_FLG,AX			; 開始フラグ 1=開始,2=終了

	CALL	TALK_START			; 会話スタート

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,61			; 61=疲労の度合
	CALLC	R_KEISAN			; 各計算処理
	MOV	HIROU_KAGEN,DX			; 疲労加減 1=疲れ無し
						; 2=ちょっと,3=かなり,4=重傷

	CMP	HIROU_KAGEN,1			; 疲労加減
	JGE	R_MS_KYUSOKU_01			;
	MOV	HIROU_KAGEN,1			; 疲労加減
R_MS_KYUSOKU_01:
	CMP	HIROU_KAGEN,4			; 疲労加減
	JLE	R_MS_KYUSOKU_02			;
	MOV	HIROU_KAGEN,4			; 疲労加減
R_MS_KYUSOKU_02:

	CALL	HOW_MANY_YEARS			; 何年目か
	MOVX	ES,<SEG R_SEG3>			;

	CMP	KAISHI_FLG,1			; 開始フラグ 1=開始,2=終了
	JNE	R_MS_KYUSOKU_E_MS		;

R_MS_KYUSOKU_S_MS:
	MOV	SI,HIROU_KAGEN			; 疲労加減
	SHL	SI,1				; word pointer.
	MOV	DI,ES:KYUSOK_TX_TBL[SI]		; 休息メッセージテーブル
	MOV	SI,ES:[DI][BX]			; BX は年のポインタ
	JMP	R_MS_KYUSOKU_PRINT		;

R_MS_KYUSOKU_E_MS:
	MOV	SI,HIROU_KAGEN			; 疲労加減
	SHL	SI,1				; word pointer.
	MOV	DI,ES:KYUEND_TX_TBL[SI]		; 休息メッセージテーブル
	MOV	SI,ES:[DI][BX]			; BX は年のポインタ
	JMP	R_MS_KYUSOKU_PRINT		;

R_MS_KYUSOKU_PRINT:
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	CMP	KAISHI_FLG,1			; 1=開始,2=終了
	JNE	R_MS_KYUSOKU_5			;
	CALLC	R_SR_SR_LF			; 改行
	CALL	MY_GIRL_NAME			; 娘の名前
	PRINTX	"はおこづかいをもらって、街に遊びに行った……"
R_MS_KYUSOKU_5:

R_MS_KYUSOKU_EXIT:
	CALL	TENTENTEN		; ・・・・
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_KYUSOKU


TEXT_IN

	;☆★☆休息を選択した時のメッセージ★☆★

KYUSOK_TX_TBL	LABEL	WORD		;休息メッセージテーブル
	DW	0			;base 0.
	DW	KYUSOK_TX_1		;疲労が３０未満
	DW	KYUSOK_TX_2		;３０～５９
	DW	KYUSOK_TX_3		;６０～８９
	DW	KYUSOK_TX_4		;９０以上
KYUSOK_TX_1	LABEL	WORD		;疲労が３０未満
	DW	KYUSOK_12MS1,KYUSOK_34MS1,KYUSOK_56MS1,KYUSOK_78MS1
KYUSOK_TX_2	LABEL	WORD		;３０～５９
	DW	KYUSOK_12MS2,KYUSOK_34MS2,KYUSOK_56MS2,KYUSOK_78MS2
KYUSOK_TX_3	LABEL	WORD		;６０～８９
	DW	KYUSOK_12MS3,KYUSOK_34MS3,KYUSOK_56MS3,KYUSOK_78MS3
KYUSOK_TX_4	LABEL	WORD		;９０以上
	DW	KYUSOK_12MS4,KYUSOK_34MS4,KYUSOK_56MS4,KYUSOK_78MS4
	;＊＊１～２年目＊＊
KYUSOK_12MS1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;疲労が３０未満
KYUSOK_12MS2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0		;３０～５９
KYUSOK_12MS3	DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0		;６０～８９
KYUSOK_12MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;９０以上
	;＊＊３～４年目＊＊
KYUSOK_34MS1	DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0		;疲労が３０未満
KYUSOK_34MS2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0		;３０～５９
KYUSOK_34MS3	DB "｢＊＊＊＊＊＊＊＊＊＊」",0			;６０～８９
KYUSOK_34MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0		;９０以上
	;＊＊５～６年目＊＊
KYUSOK_56MS1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;疲労が３０未満
KYUSOK_56MS2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0 ;３０～５９
KYUSOK_56MS3	DB "｢＊＊＊＊＊」",0				;６０～８９
KYUSOK_56MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0		;９０以上
	;＊＊７～８年目＊＊
KYUSOK_78MS1	DB "｢＊＊＊＊＊＊＊＊＊＊」",0			;疲労が３０未満
KYUSOK_78MS2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;３０～５９
KYUSOK_78MS3	DB "｢＊＊＊＊」",0				;６０～８９
KYUSOK_78MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0 ;９０以上

	;☆★休息の終り☆★

KYUEND_TX_TBL	LABEL	WORD		;休息メッセージテーブル
	DW	0			;base 0.
	DW	KYUEND_TX_1		;疲労が３０未満
	DW	KYUEND_TX_2		;３０～５９
	DW	KYUEND_TX_3		;６０～８９
	DW	KYUEND_TX_4		;９０以上
KYUEND_TX_1	LABEL	WORD		;疲労が３０未満
	DW	KYUEND_12MS1,KYUEND_34MS1,KYUEND_56MS1,KYUEND_78MS1
KYUEND_TX_2	LABEL	WORD		;３０～５９
	DW	KYUEND_12MS2,KYUEND_34MS2,KYUEND_56MS2,KYUEND_78MS2
KYUEND_TX_3	LABEL	WORD		;６０～８９
	DW	KYUEND_12MS3,KYUEND_34MS3,KYUEND_56MS3,KYUEND_78MS3
KYUEND_TX_4	LABEL	WORD		;９０以上
	DW	KYUEND_12MS4,KYUEND_34MS4,KYUEND_56MS4,KYUEND_78MS4
	;＊＊１～２年目＊＊
KYUEND_12MS1	DB "｢＊＊＊＊＊＊＊＊＊」",0			;疲労が３０未満
KYUEND_12MS2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;３０～５９
KYUEND_12MS3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;６０～８９
KYUEND_12MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;９０以上
	;＊＊３～４年目＊＊
KYUEND_34MS1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;疲労が３０未満
KYUEND_34MS2	DB "｢＊＊＊＊＊＊＊＊＊＊」",0			;３０～５９
KYUEND_34MS3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;６０～８９
KYUEND_34MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;９０以上
	;＊＊５～６年目＊＊
KYUEND_56MS1	DB "｢＊＊＊＊＊＊＊＊＊＊」",0		;疲労が３０未満
KYUEND_56MS2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0		;３０～５９
KYUEND_56MS3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;６０～８９
KYUEND_56MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;９０以上
	;＊＊７～８年目＊＊
KYUEND_78MS1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0 	;３０未満
KYUEND_78MS2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;３０～５９
KYUEND_78MS3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;６０～８９
KYUEND_78MS4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0 ;９０以上

TEXT_OUT

; ****************************************************
;	バカンス時メッセージ
;	-I- AX : 1=開始,2=終了
;	    CX : 季節 (1:春,2:夏,3:秋,4:冬)
; ****************************************************

FUNC	RR_MS_BACANCE,R_MS_BACANCE
	MOV	KAISHI_FLG,AX			; 開始フラグ 1=開始,2=終了
	MOV	F_SEASON,CX			; 季節(1:春,2:夏,3:秋,4:冬)

	CALL	TALK_START			; 会話スタート

	CMP	KAISHI_FLG,1			; 2=終了
	JNE	R_MS_BACANCE_1			;
	CODE_IN
	EXTRN	R_SR_SR_KAKO:NEAR		; "｢"
	EXTRN	R_SR_WIDSTR:NEAR		; 文字列表示
	EXTRN	R_SR_SR_KOKA:NEAR		; "」"
	EXTRN	R_SR_SR_LF:NEAR			; 改行
	CALL	R_SR_SR_KAKO			; "｢"
	MOV	DX,R_NAISTR			;
	CALL	R_SR_WIDSTR			; 文字列表示
	CALL	R_SR_SR_KOKA			; "」"
	CALL	R_SR_SR_LF			; 改行
	CODE_OUT				;
R_MS_BACANCE_1:					;

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,0				; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41			; 41=ヘッダーフラグのＩ／Ｏ
	CALLC	R_KEISAN			; 各計算処理
	MOV	MY_FLAGS,DX			; ヘッダフラグ

	MOVX	MESS_SEG,<SEG R_SEG3>		; メッセージセグメント

	CALL	HOW_MANY_YEARS			; 何年目か BX=年のword pointer

	MOV	SI,F_SEASON			; 季節(1:春,2:夏,3:秋,4:冬)
	DEC	SI				; －１
	CMP	SI,4				; if ( si >= 4 ) si = 0
	JB	R_MS_BACANCE_2			;   over check.
	MOV	SI,0				;
R_MS_BACANCE_2:					;
	SHL	SI,1				; word pointer. SI=季節

	MOVX	ES,<SEG R_SEG3>			;

	CMP	KAISHI_FLG,2			; 2=終了
	JE	R_MS_BACANCE_ED			;
	TEST	MY_FLAGS,FLAGS_HIKOU		;bit13 : 非行化
	JNZ	R_MS_BACANCE_HI			;
	TEST	MY_FLAGS,FLAGS_BYOUKI		;bit12 : 病気化
	JNZ	R_MS_BACANCE_BY			;
R_MS_BACANCE_NR:
	MOV	DI,ES:BACAN_NR_TABLE[SI]	; ノーマル時のバカンス
	JMP	R_MS_BACANCE_PRINT
R_MS_BACANCE_HI:
	MOV	DI,ES:BACAN_HI_TABLE[SI]	; 非行時のバカンス
	JMP	R_MS_BACANCE_PRINT
R_MS_BACANCE_BY:
	MOV	DI,ES:BACAN_BY_TABLE[SI]	; 非行時のバカンス
	JMP	R_MS_BACANCE_PRINT
R_MS_BACANCE_ED:
	MOV	DI,ES:BACAEND_ALL_TBL[SI]	; SI=季節

	MOV	SI,ES:[DI][BX]			; BX=年
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	CALL	TENTENTEN			; ・・・・

	JMP	R_MS_BACANCE_EXIT
R_MS_BACANCE_PRINT:
	MOV	SI,ES:[DI][BX]			; BX=年
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	MUSIC_FAR	KYOKU_F_O		; 音楽フェードアウト

	CALL	TENTENTEN			; ・・・・

	MUSIC_FAR	KYOKU_BACANCE		; バｶﾝｽ

R_MS_BACANCE_EXIT:
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_BACANCE

TEXT_IN

	;☆★☆バカンスを選択した時のメッセージ★☆★

BACAN_NR_TABLE	LABEL	WORD		; ノーマル時のバカンス
	DW	BACAN_HARU_NR		; 春
	DW	BACAN_NATU_NR		; 夏
	DW	BACAN_AKI_NR		; 秋
	DW	BACAN_FUYU_NR		; 冬
BACAN_HI_TABLE	LABEL	WORD		; 非行時のバカンス
	DW	BACAN_HARU_HI		; 春
	DW	BACAN_NATU_HI		; 夏
	DW	BACAN_AKI_HI		; 秋
	DW	BACAN_FUYU_HI		; 冬
BACAN_BY_TABLE	LABEL	WORD		; 病気時のバカンス
	DW	BACAN_HARU_BY		; 春
	DW	BACAN_NATU_BY		; 夏
	DW	BACAN_AKI_BY		; 秋
	DW	BACAN_FUYU_BY		; 冬

BACAN_HARU_NR	LABEL	WORD			; 春
	DW BACAN_HARU_12_NR,BACAN_HARU_34_NR
	DW BACAN_HARU_56_NR,BACAN_HARU_78_NR
BACAN_NATU_NR	LABEL	WORD			; 夏
	DW BACAN_NATU_12_NR,BACAN_NATU_34_NR
	DW BACAN_NATU_56_NR,BACAN_NATU_78_NR
BACAN_AKI_NR	LABEL	WORD			; 秋
	DW BACAN_AKI_12_NR ,BACAN_AKI_34_NR
	DW BACAN_AKI_56_NR ,BACAN_AKI_78_NR
BACAN_FUYU_NR	LABEL	WORD			; 冬
	DW BACAN_FUYU_12_NR,BACAN_FUYU_34_NR
	DW BACAN_FUYU_56_NR,BACAN_FUYU_78_NR

BACAN_HARU_HI	LABEL	WORD			; 春
	DW BACAN_HARU_12_HI,BACAN_HARU_34_HI
	DW BACAN_HARU_56_HI,BACAN_HARU_78_HI
BACAN_NATU_HI	LABEL	WORD			; 夏
	DW BACAN_NATU_12_HI,BACAN_NATU_34_HI
	DW BACAN_NATU_56_HI,BACAN_NATU_78_HI
BACAN_AKI_HI	LABEL	WORD			; 秋
	DW BACAN_AKI_12_HI ,BACAN_AKI_34_HI
	DW BACAN_AKI_56_HI ,BACAN_AKI_78_HI
BACAN_FUYU_HI	LABEL	WORD			; 冬
	DW BACAN_FUYU_12_HI,BACAN_FUYU_34_HI
	DW BACAN_FUYU_56_HI,BACAN_FUYU_78_HI

BACAN_HARU_BY	LABEL	WORD			; 春
	DW BACAN_HARU_12_BY,BACAN_HARU_34_BY
	DW BACAN_HARU_56_BY,BACAN_HARU_78_BY
BACAN_NATU_BY	LABEL	WORD			; 夏
	DW BACAN_NATU_12_BY,BACAN_NATU_34_BY
	DW BACAN_NATU_56_BY,BACAN_NATU_78_BY
BACAN_AKI_BY	LABEL	WORD			; 秋
	DW BACAN_AKI_12_BY ,BACAN_AKI_34_BY
	DW BACAN_AKI_56_BY ,BACAN_AKI_78_BY
BACAN_FUYU_BY	LABEL	WORD			; 冬
	DW BACAN_FUYU_12_BY,BACAN_FUYU_34_BY
	DW BACAN_FUYU_56_BY,BACAN_FUYU_78_BY

	;☆　春（３，４，５月）

	;＊１～２年目
BACAN_HARU_12_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;ノーマル時
BACAN_HARU_12_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;非行時
BACAN_HARU_12_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0		;病気時
	;＊３～４年目
BACAN_HARU_34_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;ノーマル時
BACAN_HARU_34_HI DB "｢＊＊＊＊＊＊＊＊＊」",0		;非行時
BACAN_HARU_34_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;病気時
	;＊５～６年目
BACAN_HARU_56_NR DB "｢＊＊＊＊＊＊＊＊＊＊」",0		;ノーマル時
BACAN_HARU_56_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;非行時
BACAN_HARU_56_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0 ;病気時
	;＊７～８年目
BACAN_HARU_78_NR DB "｢＊＊＊＊＊＊＊＊＊」",0			;ノーマル時
BACAN_HARU_78_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"		;
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;非行時
BACAN_HARU_78_BY DB "｢＊＊＊＊＊＊＊＊」",0		;病気時

	;☆　夏（６，７，８月）

	;＊１～２年目
BACAN_NATU_12_NR DB "｢＊＊＊＊＊＊＊＊」",0			;ノーマル時
BACAN_NATU_12_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;非行時
BACAN_NATU_12_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;病気時
	;＊３～４年目
BACAN_NATU_34_NR DB "｢＊＊＊＊＊＊＊＊＊＊」",0		;ノーマル時
BACAN_NATU_34_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"	;
		DB "＊＊＊＊＊＊＊＊＊＊」",0			;非行時
BACAN_NATU_34_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;病気時
	;＊５～６年目
BACAN_NATU_56_NR DB "｢＊＊＊＊＊＊＊＊＊＊」",0		;ノーマル時
BACAN_NATU_56_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊」",0				;非行時
BACAN_NATU_56_BY DB "｢＊＊＊＊＊＊＊＊＊」",0		;病気時
	;＊７～８年目
BACAN_NATU_78_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0		;ノーマル時
BACAN_NATU_78_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0;非行時
BACAN_NATU_78_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;病気時

	;☆　秋（９，１０，１１月）

	;＊１～２年目
BACAN_AKI_12_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0		;ノーマル時
BACAN_AKI_12_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0		;非行時
BACAN_AKI_12_BY DB "｢＊＊＊＊＊＊＊＊＊＊」",0		;病気時
	;＊３～４年目
BACAN_AKI_34_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;ノーマル時
BACAN_AKI_34_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0	;非行時
BACAN_AKI_34_BY DB "｢＊＊＊＊＊＊＊＊＊＊」",0		;病気時
	;＊５～６年目
BACAN_AKI_56_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_AKI_56_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_AKI_56_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊７～８年目
BACAN_AKI_78_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_AKI_78_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_AKI_78_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

	;☆　冬（１２，１，２月）

	;＊１～２年目
BACAN_FUYU_12_NR DB "｢＊＊＊＊＊＊＊」",0
BACAN_FUYU_12_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_FUYU_12_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊３～４年目
BACAN_FUYU_34_NR DB "｢＊＊＊＊＊＊＊＊＊＊」",0
BACAN_FUYU_34_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_FUYU_34_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊５～６年目
BACAN_FUYU_56_NR DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_FUYU_56_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊」",0
BACAN_FUYU_56_BY DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊７～８年目
BACAN_FUYU_78_NR DB "｢＊＊＊＊＊＊」",0
BACAN_FUYU_78_HI DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊」",0
BACAN_FUYU_78_BY DB "｢＊＊＊＊＊＊＊＊」",0

	;☆★バカンスが終ったら☆★

BACAEND_ALL_TBL		LABEL	WORD
	DW	BACAEND_HARU_TBL		;春
	DW	BACAEND_NATU_TBL		;夏
	DW	BACAEND_AKI_TBL			;秋
	DW	BACAEND_FUYU_TBL		;冬

BACAEND_HARU_TBL	LABEL	WORD	;☆　春（３，４，５月）
	DW BACAEND_HARU_12,BACAEND_HARU_34
	DW BACAEND_HARU_56,BACAEND_HARU_78
BACAEND_NATU_TBL	LABEL	WORD	;☆　夏（６，７，８月）
	DW BACAEND_NATU_12,BACAEND_NATU_34
	DW BACAEND_NATU_56,BACAEND_NATU_78
BACAEND_AKI_TBL		LABEL	WORD	;☆　秋（９，１０，１１月）
	DW BACAEND_AKI_12,BACAEND_AKI_34
	DW BACAEND_AKI_56,BACAEND_AKI_78
BACAEND_FUYU_TBL	LABEL	WORD	;☆　冬（１２，１，２月）
	DW BACAEND_FUYU_12,BACAEND_FUYU_34
	DW BACAEND_FUYU_56,BACAEND_FUYU_78

	;☆　春（３，４，５月）
	;＊１～２年目
BACAEND_HARU_12 DB "｢＊＊＊＊＊＊＊＊＊＊」",0
	;＊３～４年目
BACAEND_HARU_34 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊５～６年目
BACAEND_HARU_56 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊７～８年目
BACAEND_HARU_78 DB "｢＊＊＊＊＊＊＊＊」",0

	;☆　夏（６，７，８月）
	;＊１～２年目
BACAEND_NATU_12 DB "｢＊＊＊＊＊＊＊＊＊＊」",0
	;＊３～４年目
BACAEND_NATU_34 DB "｢＊＊＊＊＊＊＊＊＊＊」",0
	;＊５～６年目
BACAEND_NATU_56 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊７～８年目
BACAEND_NATU_78 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

	;☆　秋（９，１０，１１月）
	;＊１～２年目
BACAEND_AKI_12 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊３～４年目
BACAEND_AKI_34 DB "｢＊＊＊＊＊＊＊＊＊」",0
	;＊５～６年目
BACAEND_AKI_56 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊」",0
	;＊７～８年目
BACAEND_AKI_78 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊」",0

	;☆　冬（１２，１，２月）
	;＊１～２年目
BACAEND_FUYU_12 DB "｢＊＊＊＊＊＊＊＊＊」",0
	;＊３～４年目
BACAEND_FUYU_34 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊５～６年目
BACAEND_FUYU_56 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊７～８年目
BACAEND_FUYU_78 DB "｢＊＊＊＊＊＊＊＊＊」",0

TEXT_OUT


; ****************************************************
;	武者修行スタート台詞
; ****************************************************

FUNC	RR_MS_MUSYA_SRT,R_MS_MUSYA_SRT

	CALL	TALK_START			; 会話スタート

	PRINTX	"武者修行@"

	CALL	MY_GIRL_NAME			; 娘の名前

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,62			; 62=気品段階
	CALLC	R_KEISAN			; 各計算処理
	MOV	KIHIN_LEV1,DX			; 気品段階（１から６）
	MOV	KIHIN_LEV2,AX			; 気品段階（１から３）

	MOVX	ES,<SEG R_SEG3>			;

	MOV	BX,KIHIN_LEV1			; 気品段階（１から６）
	CMP	BX,5				; ５まで
	JBE	R_MS_MUSYA_SRT_2		;
	MOV	BX,5				;
R_MS_MUSYA_SRT_2:				;
	SHL	BX,1				; word pointer.
	MOV	SI,ES:MUSYA_SRT_TBL[BX]		; 武者修行スタート台詞
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	MUSIC_FAR	KYOKU_F_O		; 音楽フェードアウト

	WSELECT	"すこし心配だな……"

	CALL	TALK_FIN		; 会話ストップ（クリア無し）

	RET
FEND	RR_MS_MUSYA_SRT


; ****************************************************
;	武者修行選択台詞
;	-I- DX : 場所 1=近郊,2=辺境,3=蛮地
; ****************************************************

FUNC	RR_MS_MUSYA_SLC,R_MS_MUSYA_SLC
	CMP	DX,3				; ３まで
	JBE	R_MS_MUSYA_SLC_1		;
	MOV	DX,3				;
R_MS_MUSYA_SLC_1:				;
	MOV	WHERE_NOW,DX			; 場所 1=近郊,2=辺境,3=蛮地

	CALL	TALK_SRT02			; 会話スタート（クリア無し）

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,62			; 62=気品段階
	CALLC	R_KEISAN			; 各計算処理
	MOV	KIHIN_LEV1,DX			; 気品段階（１から６）
	MOV	KIHIN_LEV2,AX			; 気品段階（１から３）

	MOVX	ES,<SEG R_SEG3>			;

	MOV	BX,WHERE_NOW			; 場所 1=近郊,2=辺境,3=蛮地
	SHL	BX,1				; word pointer.
	MOV	DI,ES:MUSYA_SLC_ALL_TBL[BX]	;
	MOV	BX,KIHIN_LEV2			; 気品段階（１から３）
	SHL	BX,1				; word pointer.
	MOV	SI,ES:[DI][BX]			; message table.
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_MUSYA_SLC


; ****************************************************
;	武者修行移動台詞
;	-I- DX : 場所 1=近郊,2=辺境,3=蛮地
;	    CX : いつ 1=昼,2=夜
; ****************************************************

FUNC	RR_MS_MUSYA_IDO,R_MS_MUSYA_IDO
	CMP	DX,3				; ３まで
	JBE	R_MS_MUSYA_IDO_1		;
	MOV	DX,3				;
R_MS_MUSYA_IDO_1:				;
	MOV	WHERE_NOW,DX			; 場所 1=近郊,2=辺境,3=蛮地

	CMP	CX,2				; ２まで
	JBE	R_MS_MUSYA_IDO_2		;
	MOV	CX,2				;
R_MS_MUSYA_IDO_2:				;
	MOV	WHEN_FLAG,CX			; いつ 1=昼,2=夜

;*;	CALL	TALK_SRT02			; 会話スタート（クリア無し）
	CALLC	R_SR_SR_LF		; 改行

	CMP	WHEN_FLAG,1			; いつ 1=昼,2=夜
	JNE	R_MS_MUSYA_IDO_5		;
	CALL	MY_GIRL_NAME			; 娘の名前
R_MS_MUSYA_IDO_5:				;

	MOVX	ES,<SEG R_SEG3>			;

	MOV	BX,WHERE_NOW			; 場所 1=近郊,2=辺境,3=蛮地
	SHL	BX,1				; word pointer.
	MOV	DI,ES:MUSYA_IDO_ALL_TBL[BX]	; 移動中台詞
	MOV	BX,WHEN_FLAG			; いつ 1=昼,2=夜
	SHL	BX,1				; word pointer.
	MOV	SI,ES:[DI][BX]			; message table.
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	CALL	TALK_FIN			; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_MUSYA_IDO


; ****************************************************
;	武者修行決算台詞
; ****************************************************

FUNC	RR_MS_MUSYA_MAKE,R_MS_MUSYA_MAKE
	CALL	TALK_SRT02			; 会話スタート（クリア無し）

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,62			; 62=気品段階
	CALLC	R_KEISAN			; 各計算処理
	MOV	KIHIN_LEV1,DX			; 気品段階（１から６）
	MOV	KIHIN_LEV2,AX			; 気品段階（１から３）

	MOVX	ES,<SEG R_SEG3>			;
	MOV	BX,KIHIN_LEV2			; 気品段階（１から３）
	SHL	BX,1				; word pointer.
	MOV	SI,ES:MUSYA_UPD_MAKE_TBL[BX]	; 戦いに負けたら‥‥‥
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	CALL	TALK_FIN			; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_MUSYA_MAKE



TEXT_IN

MUSYA_SRT_TBL	LABEL	WORD	; 武者修行スタート台詞
	DW	MUSYA_SRT01	;base0.
	DW	MUSYA_SRT01
	DW	MUSYA_SRT02
	DW	MUSYA_SRT03
	DW	MUSYA_SRT04
	DW	MUSYA_SRT05
MUSYA_SRT01 DB "｢＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SRT02 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SRT03 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SRT04 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SRT05 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0


MUSYA_SLC_ALL_TBL	LABEL	WORD	; 移動選択台詞
	DW	MUSYA_SLC_KK_TBL	;base0.
	DW	MUSYA_SLC_KK_TBL	;＊都城の近郊＊
	DW	MUSYA_SLC_HE_TBL	;＊辺境地区＊
	DW	MYSYA_SLC_BA_TBL	;＊蛮地＊
MUSYA_SLC_KK_TBL	LABEL	WORD	;＊都城の近郊＊
	DW	MUSYA_SLC_KK1		; base0.
	DW	MUSYA_SLC_KK1
	DW	MUSYA_SLC_KK2
	DW	MUSYA_SLC_KK3
MUSYA_SLC_HE_TBL	LABEL	WORD	;＊辺境地区＊
	DW	MUSYA_SLC_HE1		; base0.
	DW	MUSYA_SLC_HE1
	DW	MUSYA_SLC_HE2
	DW	MUSYA_SLC_HE3
MYSYA_SLC_BA_TBL	LABEL	WORD	;＊蛮地＊
	DW	MUSYA_SLC_BA1		; base0.
	DW	MUSYA_SLC_BA1
	DW	MUSYA_SLC_BA2
	DW	MUSYA_SLC_BA3
	;＊都城の近郊＊
MUSYA_SLC_KK1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SLC_KK2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SLC_KK3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊辺境地区＊
MUSYA_SLC_HE1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SLC_HE2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SLC_HE3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0
	;＊蛮地＊
MUSYA_SLC_BA1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	      DB "＊＊＊＊＊＊＊」",0
MUSYA_SLC_BA2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_SLC_BA3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0


MUSYA_IDO_ALL_TBL	LABEL	WORD	; 移動中台詞
	DW	MUSYA_IDO_KK_TBL	;base0.
	DW	MUSYA_IDO_KK_TBL	;＊都城の近郊＊
	DW	MUSYA_IDO_HE_TBL	;＊辺境地区＊
	DW	MYSYA_IDO_BA_TBL	;＊蛮地＊
MUSYA_IDO_KK_TBL	LABEL	WORD	;＊都城の近郊＊
	DW	MUSYA_IDO_KK1		;base0.
	DW	MUSYA_IDO_KK1
	DW	MUSYA_IDO_KK2
MUSYA_IDO_HE_TBL	LABEL	WORD	;＊辺境地区＊
	DW	MUSYA_IDO_HE1		;base0.
	DW	MUSYA_IDO_HE1
	DW	MUSYA_IDO_HE2
MYSYA_IDO_BA_TBL	LABEL	WORD	;＊蛮地＊
	DW	MUSYA_IDO_BA1		;base0.
	DW	MUSYA_IDO_BA1
	DW	MUSYA_IDO_BA2
MUSYA_IDO_KK1 DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
MUSYA_IDO_KK2 DB "＊＊＊＊＊＊＊＊＊＊",0

MUSYA_IDO_HE1 DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
MUSYA_IDO_HE2 DB "＊＊＊＊＊＊＊＊＊＊",0

MUSYA_IDO_BA1 DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
MUSYA_IDO_BA2 DB "＊＊＊＊＊＊＊＊＊＊",0


MUSYA_UPD_MAKE_TBL	LABEL	WORD	; 戦いに負けたら……
	DW	MUSYA_UPD_MA1		;base0.
	DW	MUSYA_UPD_MA1
	DW	MUSYA_UPD_MA2
	DW	MUSYA_UPD_MA3
MUSYA_UPD_MA1 DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0
MUSYA_UPD_MA2 DB "｢＊＊＊＊＊」",0
MUSYA_UPD_MA3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

TEXT_OUT


; ****************************************************
;	口パクモード
; ****************************************************

FUNC	RR_MS_KUCHIPAKU,R_MS_KUCHIPAKU
	MOV	AX,1			; 口ぱくモード 1=口ぱくあり
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	RET
FEND	RR_MS_KUCHIPAKU


; ****************************************************
;	口パクモード終り
; ****************************************************

FUNC	RR_MS_KUCHISTOP,R_MS_KUCHISTOP
	MOV	AX,0			; 口ぱくモード 0=口ぱくなし
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	RET
FEND	RR_MS_KUCHISTOP


; ****************************************************
;	何年目か
;	-O- HOW_LONG_YEAR : 何年目か
;	    BX       : 0=１～２年目,2=３～４年目,4=５～６年目,6=７～８年目
; ****************************************************

HOW_MANY_YEARS	PROC	NEAR
	MOV	DX,VAL_YEAR		; (now)年

	CMP	VAL_MONTH,3		; (now)月
	JG	HOW_MANY_YEARS_1	;
	DEC	DX			; 年度末か？
HOW_MANY_YEARS_1:

	SUB	DX,ST_VAL_YEAR		; 環境開始・年
	JGE	HOW_MANY_YEARS_2	;
	MOV	DX,0			; 過去は無し
HOW_MANY_YEARS_2:
	INC	DX			; ＋１
	MOV	HOW_LONG_YEAR,DX	; 何年目か
	MOV	BX,HOW_LONG_YEAR		;
	DEC	BX				; －１
	SHR	BX,1				; ／２
	SHL	BX,1				; word pointer.
	RET
HOW_MANY_YEARS	ENDP


; ****************************************************
;	ＵＰする評価
;	-I- DX : 加算される評価
; ****************************************************

UP_HYOUKA	PROC	NEAR
	CALLC	R_UWA_HYOUKA		; 評価処理
	RET
UP_HYOUKA	ENDP


; ****************************************************
;	ふむふむ
; ****************************************************

FUMUFUMU	PROC	NEAR
	WSELECT	"ふむふむ"
	RET
FUMUFUMU	ENDP


; ****************************************************
;	・・・・
; ****************************************************

TENTENTEN	PROC	NEAR
	WSELECT	"・・・・"
	RET
TENTENTEN	ENDP


; ****************************************************
;	だめだった・・・
; ****************************************************

DAMEDATTA	PROC	NEAR
	WSELECT	"だめだった・・・"
	RET
DAMEDATTA	ENDP


; ****************************************************
;	ハイ・・
; ****************************************************

HAIHAI	PROC	NEAR
	WSELECT	"ハイ・・"
	RET
HAIHAI	ENDP


; ****************************************************
;	○○○です
; ****************************************************

ITS_MINE	PROC	NEAR
	CALLC	R_SR_SL_NAME		; select○○○です
	RET
ITS_MINE	ENDP


; ****************************************************
;	娘の名前
; ****************************************************

MY_GIRL_NAME	PROC	NEAR
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALLC	R_SR_GIRL_NAME			; キャラクタ名
	RET
MY_GIRL_NAME	ENDP


; ****************************************************
;	会話スタート
; ****************************************************

TALK_START	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AX,SEG R_SEG3		;
	MOV	MESS_SEG,AX		; メッセージセグメント
	CALLC	TKRHME			; 台詞ホームポジション
	MOV	AX,1			; 口ぱくモード 1=口ぱくあり
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
TALK_START	ENDP


; ****************************************************
;	会話スタート（クリア無し）
; ****************************************************

TALK_SRT02	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AX,SEG R_SEG3		;
	MOV	MESS_SEG,AX		; メッセージセグメント
	CALLC	R_SR_SR_LF		; 改行
	MOV	AX,1			; 口ぱくモード 1=口ぱくあり
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
TALK_SRT02	ENDP


; ****************************************************
;	会話ストップ
; ****************************************************

TALK_END	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AX,0			; 口ぱくモード 0=口ぱくなし
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	CALLC	TKRHME			; 台詞ホームポジション
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
TALK_END	ENDP


; ****************************************************
;	会話ストップ（クリア無し）
; ****************************************************

TALK_FIN	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AX,0			; 口ぱくモード 0=口ぱくなし
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
TALK_FIN	ENDP


; ****************************************************
;	メッセージ表示
;	-I- MESS_SEG  : メッセージセグメント
;	    MESS_ADRS : メッセージアドレス
; ****************************************************

MESSAGE_PRINT	PROC	NEAR
	PUSH	ES
	PUSH	BX
	PUSH	SI
	PUSH	DI
	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALL	TEXT_MAKER		; テキストメーカ
	CALLC	WIDTXT			; テキストウインドウ
	POP	DI
	POP	SI
	POP	BX
	POP	ES
	RET
MESSAGE_PRINT	ENDP


; ****************************************************
;	メッセージ改行(R_SEG2)
; ****************************************************

MESSAGE_LF	PROC	NEAR
	PUSH	ES
	PUSH	BX
	PUSH	SI
	PUSH	DI
	CALLC	R_SR_SR_LF		; 改行
	POP	DI
	POP	SI
	POP	BX
	POP	ES
	RET
MESSAGE_LF	ENDP


; ****************************************************
;	テキストメーカ
;	-I- MESS_SEG  : メッセージセグメント
;	    MESS_ADRS : メッセージアドレス
;	-O- WDTXTSEG  : メッセージセグメント(=DS)
;	    WDTXTADR  : メッセージアドレス
;
;	コマンド
;		'&n'	名前
;		'&f'	姓
;		'&t'	敵名前
;		'&0'	パラメータ０
;		'&1'	パラメータ１
;		'&2'	パラメータ２
;		'&3'	パラメータ３
;		'&m'	お金
;		'&d'	日数
;		'&k'	経験値
;
; ****************************************************

TEXT_MAKER	PROC	NEAR
	CALLC	STRZEROC		; 文字列バッファ０クリア
	MOV	ES,MESS_SEG		; メッセージセグメント
	MOV	SI,MESS_ADRS		; メッセージアドレス
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
TEXT_MAKER_LOOP:			;
	MOV	AL,ES:[SI]		;
	INC	SI			;
	CMP	AL,0			; end of string.
	JMPEQ	TEXT_MAKER_LOOP_E	;

	CMP	AL,'&'			;
	JNE	TEXT_MAKER_SET		;

	MOV	AL,ES:[SI]		;
	INC	SI			;

	CMP	AL,'n'			; 名前
	JNE	TEXT_MAKER_1		;
	CALL	TEXT_GET_NAME		; ＧＥＴ名前
	JMP	TEXT_MAKER_NEXT		;
TEXT_MAKER_1:				;
	CMP	AL,'f'			; 名前
	JNE	TEXT_MAKER_12		;
	CALL	TEXT_GET_FNAME		; ＧＥＴ姓
	JMP	TEXT_MAKER_NEXT		;
TEXT_MAKER_12:				;
	CMP	AL,'t'			; 敵名前
	JNE	TEXT_MAKER_2		;
	CALL	TEXT_GET_TNAME		; ＧＥＴ敵名前
	JMP	TEXT_MAKER_NEXT		;
TEXT_MAKER_2:				;
	CMP	AL,'0'			; パラメータ０
	JNE	TEXT_MAKER_30		;
	MOV	DX,TXT_PARM		; テキストパラメータ
	JMP	TEXT_MAKER_PARA		;
TEXT_MAKER_30:				;
	CMP	AL,'1'			; パラメータ１
	JNE	TEXT_MAKER_31		;
	MOV	DX,TXT_PARM[2*1]	; テキストパラメータ
	JMP	TEXT_MAKER_PARA		;
TEXT_MAKER_31:				;
	CMP	AL,'2'			; パラメータ２
	JNE	TEXT_MAKER_32		;
	MOV	DX,TXT_PARM[2*2]	; テキストパラメータ
	JMP	TEXT_MAKER_PARA		;
TEXT_MAKER_32:				;
	CMP	AL,'3'			; パラメータ３
	JNE	TEXT_MAKER_33		;
	MOV	DX,TXT_PARM[2*3]	; テキストパラメータ
	JMP	TEXT_MAKER_PARA		;
TEXT_MAKER_33:				;
	CMP	AL,'m'			; お金
	JNE	TEXT_MAKER_34		;
	MOV	DX,TXT_MONEY		; テキストお金
	JMP	TEXT_MAKER_PARA		;
TEXT_MAKER_34:				;
	CMP	AL,'d'			; 日数
	JNE	TEXT_MAKER_35		;
	MOV	DX,TXT_DAYS		; テキスト日数
	JMP	TEXT_MAKER_PARA		;
TEXT_MAKER_35:				;
	CMP	AL,'k'			; 経験値
	JNE	TEXT_MAKER_36		;
	MOV	DX,TXT_KEIKEN		; テキスト経験値
	JMP	TEXT_MAKER_PARA		;
TEXT_MAKER_36:				;
	MOV	DS:[DI],BYTE PTR '&'	;
	INC	DI			;
	JMP	TEXT_MAKER_SET		;
TEXT_MAKER_PARA:			;
	CALL	TEXT_GET_PARA		; ＧＥＴパラメータ
	JMP	TEXT_MAKER_NEXT		;
TEXT_MAKER_SET:				;
	MOV	DS:[DI],AL		;
	INC	DI			;
TEXT_MAKER_NEXT:			;
	JMP	TEXT_MAKER_LOOP		;

TEXT_MAKER_LOOP_E:			;
	MOV	DS:[DI],BYTE PTR 0	; end of string.
	MOV	WDTXTSEG,DS		 ; メッセージセグメント
	MOV	WDTXTADR,OFFSET STR_BUFF ; メッセージアドレス
	RET
TEXT_MAKER	ENDP


; ****************************************************
;	ＧＥＴ名前
;	-I- DS:[DI] : セットバッファ先頭
;	-O- DS:[DI] : 処理後ポインタを移動
; ****************************************************

TEXT_GET_NAME	PROC	NEAR
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	NAME_GET			; 名前ＧＥＴ
	RET
TEXT_GET_NAME	ENDP


; ****************************************************
;	ＧＥＴ姓
;	-I- DS:[DI] : セットバッファ先頭
;	-O- DS:[DI] : 処理後ポインタを移動
; ****************************************************

TEXT_GET_FNAME	PROC	NEAR
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	FNAME_GET			; 姓ＧＥＴ
	RET
TEXT_GET_FNAME	ENDP


; ****************************************************
;	ＧＥＴ敵名前
;	-I- DS:[DI] : セットバッファ先頭
;	-O- DS:[DI] : 処理後ポインタを移動
; ****************************************************

TEXT_GET_TNAME	PROC	NEAR
	MOVX	R_SR_CHR_ADRS,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	CALL	NAME_GET			; 名前ＧＥＴ
	RET
TEXT_GET_TNAME	ENDP


; ****************************************************
;	名前ＧＥＴ
;	-I- R_SR_CHR_ADRS : キャラクタアドレス
; ****************************************************

NAME_GET	PROC	NEAR
	PUSH	ES
	PUSH	SI

	MOV	CX,256				; 名前長さ
	CALLC	R_SR_GIRL_NAMEGET		; キャラクタ名ＧＥＴ
	MOVX	ES,DS				;
	CALLC	STRLENGTH			; 文字列長さ
	ADD	DI,CX				; 表示単語長さ

	POP	SI
	POP	ES
	RET
NAME_GET	ENDP


; ****************************************************
;	姓ＧＥＴ
;	-I- R_SR_CHR_ADRS : キャラクタアドレス
; ****************************************************

FNAME_GET	PROC	NEAR
	PUSH	ES
	PUSH	SI

	MOV	CX,256				; 名前長さ
	CALLC	R_SR_GIRL_F_NAMEGET		; キャラクタ姓ＧＥＴ

	MOVX	ES,DS				;
	CALLC	STRLENGTH			; 文字列長さ
	ADD	DI,CX				; 表示単語長さ

	POP	SI
	POP	ES
	RET
FNAME_GET	ENDP


; ****************************************************
;	ＧＥＴパラメータ
;	-I- DS:[DI] : セットバッファ先頭
;	    DX      : パラメータ
;	-O- DS:[DI] : 処理後ポインタを移動
; ****************************************************

TEXT_GET_PARA	PROC	NEAR
	PUSH	ES
	PUSH	SI

	PUSH	DI			;
	CALLC	DECSTR			; val DX to dec string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	CALLC	STRSPL			; space pless. "  123" - > "123  "
	POP	DI			;
	CALLC	STR_N_HNZN		; 文字列半角を全角
	MOVX	ES,DS			;
	CALLC	STRLENGTH		; 文字列長さ
	ADD	DI,CX			; 表示単語長さ

	POP	SI
	POP	ES
	RET
TEXT_GET_PARA	ENDP



; ****************************************************
;	WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
; ****************************************************

WWIDSLC2	PROC	NEAR
	CALLC	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	RET
WWIDSLC2	ENDP

R_SEG2	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	MESS_ADRS			; メッセージアドレス
PUBLIC	MESS_SEG			; メッセージセグメント

PUBLIC	TXT_PARM			; テキストパラメータ
PUBLIC	TXT_MONEY			; テキストお金
PUBLIC	TXT_DAYS			; テキスト日数
PUBLIC	TXT_KEIKEN			; テキスト経験値

EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

EXTRN	R_NAISTR:WORD			; 内容文字列

EXTRN	S_FUNC:WORD			; 計算ファンクション
EXTRN	WIDSNM:WORD			; ユーザ選択番号

EXTRN	STR_BUFF:BYTE			; 文字列バッファ
EXTRN	STR_VAL_BUFF:BYTE		; 表示値文字列バッファ

EXTRN	TM_SEASON:WORD			; (now)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	FLG_SHOGATSU:WORD		; (now)フラグ・正月
EXTRN	FLG_URUBI:WORD			; (now)フラグ・うるう日
EXTRN	FLG_CHRISTMAS_EVE:WORD		; (now)フラグ・クリスマスイブ
EXTRN	FLG_BORTH:WORD			; (now)フラグ・誕生日
EXTRN	FLG_HOLIDAY:WORD		; (now)フラグ・休日
EXTRN	FLG_SYUKAKU:WORD		; (now)フラグ・収穫祭の準備

EXTRN	ST_VAL_YEAR:WORD		; 環境開始・年
EXTRN	ST_VAL_MONTH:WORD		; 環境開始・月
EXTRN	ST_VAL_WEEK:WORD		; 環境開始・曜日
EXTRN	ST_VAL_DATE:WORD		; 環境開始・日

EXTRN	VAL_YEAR:WORD			; (now)年
EXTRN	VAL_MONTH:WORD			; (now)月
EXTRN	VAL_WEEK:WORD			; (now)曜日
EXTRN	VAL_DATE:WORD			; (now)日

EXTRN	KAIKEN_FLG_OFS:WORD		; 会見フラグオフセット
EXTRN	KAIKEN_FLG_SEG:WORD		; 会見フラグセグメント

KING_LEVEL	DW	0		; 王様の会見レベル

KAIKEN_UP_TBL	LABEL	WORD		; 会見によりＵＰする評価
		DW	0		; base0.
		DW	8		; 1=衛兵
		DW	8		; 2=近衛隊長
		DW	8		; 3=侍従
		DW	8		; 4=侍従長
		DW	8		; 5=王妃
		DW	8		; 6=王様

HOW_LONG_YEAR	DW	0		; 何年目か

MESS_ADRS	DW	0		; メッセージアドレス
MESS_SEG	DW	SEG R_SEG3	; メッセージセグメント
MY_FLAGS	DW	0		; ヘッダフラグ

FLG_KETTEI	DW	0		; 決定か？1=決定,2=中止
NUM_KOUMOKU	DW	0		; 項目
					; 0=武芸,1=学問,2=礼法,3=武者修行
					; 4=アルバイト,5=休息,6=バカンス

HIROU_KAGEN	DW	0		; 疲労加減
					; 1=疲れ無し,2=ちょっと,3=かなり,4=重傷

KAISHI_FLG	DW	0		; 開始フラグ 1=開始,2=終了

F_SEASON	DW	0		; 季節(1:春,2:夏,3:秋,4:冬)

KIHIN_LEV1	DW	0		; 気品段階（１から６）
KIHIN_LEV2	DW	0		; 気品段階（１から３）

WHERE_NOW	DW	1		; 場所 1=近郊,2=辺境,3=蛮地
WHEN_FLAG	DW	1		; いつ 1=昼,2=夜

TXT_PARM	DW	4 DUP (0)	; テキストパラメータ
TXT_MONEY	DW	0		; テキストお金
TXT_DAYS	DW	0		; テキスト日数
TXT_KEIKEN	DW	0		; テキスト経験値

MESS_NM		DW	0		; メッセージ番号

DATA	ENDS

INCLUDE	R_MESADD.INC

	END
;
;	end of "R_MESSAG.ASM"
;
