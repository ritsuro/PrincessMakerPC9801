; "R_OHSAMA.ASM" PC-9801UV11 make by R.H 1991/01/15
;
;
;	「子育て」
;
;	王様との会見
;
;	会見レベルの調整は
;	R_KEISAN.ASM の	OH_KAIKEN_KIHIN_LVL : 王様会見の気品基準レベル
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO6\KYOKU.INC

NORMAL_BANK	EQU	0	; 通常のパーツバンク番号
BACKSAVE_BANK	EQU	1	; 背景退避用パーツバンク番号


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



CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	R_OHSAMA		; 王様との会見
PUBLIC	R_OHSAMA_OHOME		; 王様の御誉め
PUBLIC	R_OHSAMA_OHOME_BT	; 王様の御誉め・武闘会編

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_SR_GIRL_NAME:NEAR	; キャラクタ名

EXTRN	R_MS_OH_KAISRT:NEAR	; 王様との会見選択時
EXTRN	R_MS_OH_KAIKEN:NEAR	; 王様との会見

EXTRN	WIDFACE_OPEN_OH:NEAR	; WINDOWS/王様ウインドウＯＰＥＮ

EXTRN	WIDFACE_OPEN:NEAR	; WINDOWS/フェイスウインドウＯＰＥＮ
EXTRN	WIDFACE_CLOSE:NEAR	; WINDOWS/フェイスウインドウＣＬＯＳＥ
EXTRN	WIDFACE_OPEN_VEW:NEAR	; WINDOWS/会見フェイスウインドウOPEN
EXTRN	WIDFACE_CLOSE_VEW:NEAR	; WINDOWS/会見フェイスウインドウCLOSE

EXTRN	WIDEVNT_OPEN:NEAR	; WINDOWS/イベントウインドウＯＰＥＮ
EXTRN	WIDEVNT_CLOSE:NEAR	; WINDOWS/イベントウインドウＣＬＯＳＥ

EXTRN	WIDFUKI:NEAR		; WINDOWS/ふきだしウインドウ
EXTRN	WIDFUKI_OPEN:NEAR	; WINDOWS/ふきだしウインドウＯＰＥＮ
EXTRN	WIDFUKI_CLOSE:NEAR	; WINDOWS/ふきだしウインドウＣＬＯＳＥ

EXTRN	R_MS_OH_HOMERU:NEAR	; 王様のほめ言葉

EXTRN	R_SR_GIRL_NAMEGET:NEAR	; キャラクタ名ＧＥＴ

EXTRN	WIDTXT:NEAR		; テキストウインドウ

EXTRN	TKTIN_F:NEAR		; ふきだしのメッセージ（初期処理）
EXTRN	TKTIN_F_RET:NEAR	; 元の台詞表示へ戻す

EXTRN	R_SR_YOIDESUKA:NEAR	; よいですか

EXTRN	STRSET:NEAR		; 文字列バッファセット
EXTRN	STRSETZ:NEAR		; 文字列バッファセット
EXTRN	STRCLEAR:NEAR		; 文字列バッファクリア
EXTRN	STRZEROC:NEAR		; 文字列バッファ０クリア
EXTRN	ADDSTRSET:NEAR		; 文字列の連結


; ****************************************************
;	王様との会見
; ****************************************************

R_OHSAMA	PROC	NEAR
	CALL	R_MS_OH_KAISRT		; 王様との会見選択時

	MUSIC	KYOKU_F_O		; 音楽フェードアウト

	MOV	DX,1			; 1=王様との会見
	CALL	WIDEVNT_OPEN		; WINDOWS/イベントウインドウＯＰＥＮ

	MUSIC	KYOKU_OSHIRO		; お城

	MOV	KING_LEVEL,0		; 王様の会見レベル

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,0			; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41		; 41=ヘッダーフラグのＩ／Ｏ
	CALL	R_KEISAN		; 各計算処理
	MOV	KING_FLAG,DX		; 王様の会見フラグ

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,43		; 43=会見チェック
	CALL	R_KEISAN		; 各計算処理
	MOV	KING_LEVEL,AX		; 会見が許されるレベル
					; 0=全滅！
					; 1=衛兵までＯＫ
					; 2=近衛隊長までＯＫ
					; 3=侍従までＯＫ
					; 4=侍従長までＯＫ
					; 5=王妃までＯＫ
					; 6=王様までＯＫ

	; 衛兵ＯＫ

	AND	KING_FLAG,NOT FLAGS_EIHEI 	;bit01 : 衛兵ＯＫ
	CALL	INTERVIEW_EIHEI			; 衛兵
	CMP	AX,0				; 0=ＮＧ,1=ＯＫ
	JE	R_OHSAMA_NG			;
	OR	KING_FLAG,FLAGS_EIHEI		;bit01 : 衛兵ＯＫ
	CMP	AX,2				; 2=とりやめ
	JE	R_OHSAMA_EXIT			;

	; 近衛隊長ＯＫ

	AND	KING_FLAG,NOT FLAGS_KONOE	;bit02 : 近衛隊長ＯＫ
	CALL	INTERVIEW_KONOE			; 近衛隊長
	CMP	AX,0				; 0=ＮＧ,1=ＯＫ
	JE	R_OHSAMA_NG			;
	OR	KING_FLAG,FLAGS_KONOE		;bit02 : 近衛隊長ＯＫ

	; 侍従ＯＫ

	AND	KING_FLAG,NOT FLAGS_JIJYU	;bit03 : 侍従ＯＫ
	CALL	INTERVIEW_JIJYU			; 侍従
	CMP	AX,0				; 0=ＮＧ,1=ＯＫ
	JE	R_OHSAMA_NG			;
	OR	KING_FLAG,FLAGS_JIJYU		;bit03 : 侍従ＯＫ

	; 侍従長ＯＫ

	AND	KING_FLAG,NOT FLAGS_JIJYUCHO	;bit04 : 侍従長ＯＫ
	CALL	INTERVIEW_JIJYUCHO		; 侍従長
	CMP	AX,0				; 0=ＮＧ,1=ＯＫ
	JE	R_OHSAMA_NG			;
	OR	KING_FLAG,FLAGS_JIJYUCHO	;bit04 : 侍従長ＯＫ

	; 王妃ＯＫ

	AND	KING_FLAG,NOT FLAGS_OUHI	;bit05 : 王妃ＯＫ
	CALL	INTERVIEW_OUHI			; 王妃ＯＫ
	CMP	AX,0				; 0=ＮＧ,1=ＯＫ
	JE	R_OHSAMA_NG			;
	OR	KING_FLAG,FLAGS_OUHI		;bit05 : 王妃ＯＫ

	; 王様ＯＫ

	AND	KING_FLAG,NOT FLAGS_KING	;bit06 : 王様ＯＫ
	CALL	INTERVIEW_KING			; 王様ＯＫ
	CMP	AX,0				; 0=ＮＧ,1=ＯＫ
	JE	R_OHSAMA_NG			;
	OR	KING_FLAG,FLAGS_KING		;bit06 : 王様ＯＫ

R_OHSAMA_NG:
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,1			; 1:書き込み
	MOV	DX,KING_FLAG		; 王様の会見フラグ
	MOV	S_FUNC,41		; ヘッダーフラグのＩ／Ｏ
	CALL	R_KEISAN		; 各計算処理
R_OHSAMA_EXIT:
	CALL	WIDEVNT_CLOSE		; WINDOWS/イベントウインドウＣＬＯＳＥ

	CALL	MUSIC_KOSODATE		; 子育てのテーマ

	RET
R_OHSAMA	ENDP


; ****************************************************
;	衛兵
;	-I-   KING_LEVEL: 王様の会見レベル
;	-O-   AX        : 0=ＮＧ,1=ＯＫ,2=とりやめ
; ****************************************************

INTERVIEW_EIHEI		PROC	NEAR
	MOV	DX,KING_LEVEL		; 王様の会見レベル
	MOV	BX,1			; 会見する相手  1=衛兵
	CALL	R_MS_OH_KAIKEN		; 王様との会見
	RET
INTERVIEW_EIHEI		ENDP


; ****************************************************
;	近衛隊長
;	-I-   KING_LEVEL: 王様の会見レベル
;	-O-   AX        : 0=ＮＧ,1=ＯＫ
; ****************************************************

INTERVIEW_KONOE		PROC	NEAR
	MOV	DX,KING_LEVEL		; 王様の会見レベル
	MOV	BX,2			; 会見する相手 2=近衛隊長
	CALL	R_MS_OH_KAIKEN		; 王様との会見
	RET
INTERVIEW_KONOE		ENDP


; ****************************************************
;	侍従
;	-I-   KING_LEVEL: 王様の会見レベル
;	-O-   AX        : 0=ＮＧ,1=ＯＫ
; ****************************************************

INTERVIEW_JIJYU		PROC	NEAR
	MOV	DX,KING_LEVEL		; 王様の会見レベル
	MOV	BX,3			; 会見する相手 3=侍従
	CALL	R_MS_OH_KAIKEN		; 王様との会見
	RET
INTERVIEW_JIJYU		ENDP


; ****************************************************
;	侍従長
;	-I-   KING_LEVEL: 王様の会見レベル
;	-O-   AX        : 0=ＮＧ,1=ＯＫ
; ****************************************************

INTERVIEW_JIJYUCHO	PROC	NEAR
	MOV	DX,KING_LEVEL		; 王様の会見レベル
	MOV	BX,4			; 会見する相手 4=侍従長
	CALL	R_MS_OH_KAIKEN		; 王様との会見
	RET
INTERVIEW_JIJYUCHO	ENDP


; ****************************************************
;	王妃
;	-I-   KING_LEVEL: 王様の会見レベル
;	-O-   AX        : 0=ＮＧ,1=ＯＫ
; ****************************************************

INTERVIEW_OUHI		PROC	NEAR
	MOV	DX,KING_LEVEL		; 王様の会見レベル
	MOV	BX,5			; 会見する相手 5=王妃
	CALL	R_MS_OH_KAIKEN		; 王様との会見
	RET
INTERVIEW_OUHI		ENDP


; ****************************************************
;	王様
;	-I-   KING_LEVEL: 王様の会見レベル
;	-O-   AX        : 0=ＮＧ,1=ＯＫ
; ****************************************************

INTERVIEW_KING		PROC	NEAR
	MOV	DX,KING_LEVEL		; 王様の会見レベル
	MOV	BX,6			; 会見する相手 6=王様
	CALL	R_MS_OH_KAIKEN		; 王様との会見
	RET
INTERVIEW_KING		ENDP


; ****************************************************
;	王様の御誉め
;	-I- BX : 誉める相手のヘッダアドレス
; ****************************************************

R_OHSAMA_OHOME	PROC	NEAR
	MOV	FLAG_IVENT,2		; フラグ・イベント 2=ミスコン
	CALL	OHSAMA_OHOME		; 王様の御誉め処理
	RET
R_OHSAMA_OHOME	ENDP


; ****************************************************
;	王様の御誉め・武闘会編
;	-I- BX : 誉める相手のヘッダアドレス
;	    CX : 準優勝誉める相手のヘッダアドレス
; ****************************************************

R_OHSAMA_OHOME_BT	PROC	NEAR
	MOV	FLAG_IVENT,1		; フラグ・イベント 1=武闘会
	CALL	OHSAMA_OHOME		; 王様の御誉め処理
	RET
R_OHSAMA_OHOME_BT	ENDP


; ****************************************************
;	王様の御誉め処理
;	-I- FLAG_IVENT : フラグ・イベント 1=武闘会,2=ミスコン
;	    BX         : 誉める相手のヘッダアドレス
;	    CX         : 準優勝誉める相手のヘッダアドレス
; ****************************************************

OHSAMA_OHOME	PROC	NEAR
	MOV	MAN_ADRS,BX		; 誉める相手のヘッダアドレス
	MOV	MAN_JYUNADRS,CX		; 準優勝誉める相手のヘッダアドレス

	MOV	DX,OHSAMA_FUKI_NO	; 王様ふぎだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ

	MOVX	WDXX,OHSAMA_FC_XX	; 王様の御誉め 顔 Ｘ座標
	MOVX	WDYY,OHSAMA_FC_YY	; 王様の御誉め 顔 Ｙ座標
	CALL	WIDFACE_OPEN_OH		; WINDOWS/王様ウインドウＯＰＥＮ

	CALL	TKTIN_F			; ふきだしのメッセージ（初期処理）

	CALL	OHSAMA_SERIFU_ED	; 王様の誉め言葉の編集

	CALL	TKTIN_F_RET		; 元の台詞表示へ戻す

	CALL	R_SR_YOIDESUKA		; よいですか

	MOV	DX,OHSAMA_FUKI_NO	; 王様ふぎだし番号
	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ
	RET
OHSAMA_OHOME	ENDP


; ****************************************************
;	王様の誉め言葉の編集
;	-I- MAN_ADRS   : 誉める相手のヘッダアドレス
;	    FLAG_IVENT : フラグ・イベント 1=武闘会,2=ミスコン
;	    MAN_JYUNADRS : 準優勝誉める相手のヘッダアドレス
;	-O- STR_BUFF   : 誉め言葉
; ****************************************************

OHSAMA_SERIFU_ED	PROC	NEAR
	CMP	FLAG_IVENT,1		; フラグ・イベント 1=武闘会
	JE	OHSAMA_SERIFU_ED_BUTOH	;
	CMP	FLAG_IVENT,2		; フラグ・イベント 2=ミスコン
	JE	OHSAMA_SERIFU_ED_MISSCON

OHSAMA_SERIFU_ED_BUTOH:
	CMPX	WIDMY_GIRL_OF,MAN_ADRS	; 私の娘アドレス
	JE	OHSAMA_SERIFU_ED_MY	;
	CMPX	WIDMY_GIRL_OF,MAN_JYUNADRS ; 私の娘アドレス
	JE	OHSAMA_SERIFU_ED_JN_MY	;

OHSAMA_SERIFU_ED_TK:			;
	MOV	BX,3			; 3=武闘会表彰式
	JMP	OHSAMA_SERIFU_ED_TALK	;
OHSAMA_SERIFU_ED_MY:			;
	MOV	BX,4			; 4=武闘会自分の娘が優勝の場合
	JMP	OHSAMA_SERIFU_ED_TALK	;
OHSAMA_SERIFU_ED_JN_MY:			;
	MOV	BX,5			; 5=武闘会自分の娘が準優勝の場合
	JMP	OHSAMA_SERIFU_ED_TALK	;

OHSAMA_SERIFU_ED_MISSCON:
	CMPX	WIDMY_GIRL_OF,MAN_ADRS	; 私の娘アドレス
	JE	OHSAMA_SERIFU_ED_M_MY	;
OHSAMA_SERIFU_ED_M_TK:			;
	MOV	BX,1			; 1=ミス表彰式
	JMP	OHSAMA_SERIFU_ED_TALK	;
OHSAMA_SERIFU_ED_M_MY:			;
	MOV	BX,2			; 2=ミス自分の娘が優勝の場合
	JMP	OHSAMA_SERIFU_ED_TALK	;

OHSAMA_SERIFU_ED_TALK:			;
	CALL	R_MS_OH_HOMERU		; 王様のほめ言葉
	RET
OHSAMA_SERIFU_ED	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	S_FUNC:WORD			; 計算ファンクション

EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

EXTRN	STR_BUFF:BYTE			; 文字列バッファ
EXTRN	STR_VAL_BUFF:BYTE		; 表示値文字列バッファ

KING_LEVEL	DW	0		; 王様の会見レベル
KING_FLAG	DW	0		; 王様の会見フラグ

KING_MSG_ADRS	DW	0		; 王様の会見メッセージアドレス


OHSAMA_FUKI_NO	DW	7		; 王様ふぎだし番号

OHSAMA_FC_XX	DW	23		; 王様の御誉め 顔 Ｘ座標
OHSAMA_FC_YY	DW	15*8-1		; 王様の御誉め 顔 Ｙ座標

MAN_ADRS	DW	0		; 誉める相手のヘッダアドレス
MAN_JYUNADRS	DW	0		; 準優勝誉める相手のヘッダアドレス

FLAG_IVENT	DW	0		; フラグ・イベント 1=武闘会,2=ミスコン

FACE_XX1	DW	0		; ＰＵＴ　Ｘ座標
FACE_YY1	DW	0		; ＰＵＴ　Ｙ座標

MAN_NUMBER	DW	0		; 人物番号
MAN_TABLE	LABEL	BYTE		; (byte)フェイス番号テーブル
		DB	0		; base 1.
		DB	1		; 01 : 衛兵
		DB	2		; 02 : 近衛隊長
		DB	3		; 03 : 侍従
		DB	4		; 04 : 侍従長
		DB	5		; 05 : 王妃様
		DB	6		; 06 : 王様

DATA	ENDS

	END
;
;	end of "R_OHSAMA.ASM"
;
