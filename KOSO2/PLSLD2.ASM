; "PLSLD2.ASM" 1989/12/14 R.H
;              PC-9801UV11 make by R.H 1989
;
; public subroutine.
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;
;
;	ＤＴＡをワークに使うのでＤＴＡが６００００バイトないと
;	困ります
;
;	ＤＳ：ＳＩ			圧縮データバッファ
;	ＥＳ：ＤＩ＝ＶＲＡＭ OR ＤＴＡ	展開データ
;	ＢＸ				ＶＲＡＭｾｸﾞﾒﾝﾄﾃｰﾌﾞﾙポインタ
;
;	オーバラップ処理用に VCXRTW_OL （縦横バイト並べ戻し・オーバラップ）
;	を作成しました。タイミング用タイマはタイマー１を使用。
;	オーバラップ単位時間の変更はBBOVTM（オーバラップタイム）を変更。
;
;	VRMMOV.ASM も同様の処理をしている。
;
;
;	プレーン毎のスキップを行えるようにしました。これは縦／横圧縮モード
;	(PLSMDE=0:通常,1:縦方向) オーバラップ時(BBOVLP)のいずれでも使えます。
;	CALL	PLSSKP		; パーツＰＵＴのプレーンスキップ
;		スキッププレーン (DX=bit3:plean3,bit2:plean2,bit1:1,bit0:0)
;


MAX_VRAM_POINT	EQU	32000	; ＶＲＡＭ１プレーンの終わりオフセット

PLEAN_MAX	EQU	4	; vram plean number.

ADDWIDTH	EQU	80	; vram offset shift.
ADDWIDTHB	EQU	79	; ＶＲＡＭライン計算用


DTA		EQU	0	; SEGDOS で示される
				; ＤＯＳインターフェースセグメント内の
				; ＤＴＡ領域のオフセットアドレス
				; 詳細は'DISKRD.ASM'を参照してください

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	UNPLS		; データ復元
	PUBLIC	PLSMOD		; 圧縮モード切り替え
	PUBLIC	PLSSKP		; パーツＰＵＴのプレーンスキップ

	PUBLIC	LDPLSD		; 圧縮フォーマットデータ復元（ＤＴＡ領域）

	EXTRN	BUNPLE:NEAR	; 圧縮フォーマットデータ復元

	EXTRN	TMWAIT:NEAR		; time wait.
	EXTRN	TMVSRT:NEAR		; V-SYNC timer start.
	EXTRN	TMVEND:NEAR		; V-SYNC timer end.
	EXTRN	TMVWAT:NEAR		; V-SYNC timer wait.
	EXTRN	TMVSET:NEAR		; V-SYNC timer set.
	EXTRN	TMVCHK:NEAR		; V-SYNC timer check.
	EXTRN	TMVST2:NEAR		; V-SYNC timer2 set.
	EXTRN	TMVCK2:NEAR		; V-SYNC timer2 check.
	EXTRN	TMVST3:NEAR		; V-SYNC timer3 set.
	EXTRN	TMVCK3:NEAR		; V-SYNC timer3 check.
	EXTRN	TMVWT4:NEAR		; V-SYNC timer4 wait.
	EXTRN	TMVCLR:NEAR		; V-SYNC timer clear.
	EXTRN	TMVSTP:NEAR		; V-SYNC timer stop.
	EXTRN	TMVCNT:NEAR		; V-SYNC timer cont.
	EXTRN	TMVRND:NEAR		; V-SYNC timer run counter read.
	EXTRN	TMVSAV:NEAR		; V-SYNC timer value save.
	EXTRN	TMVLOD:NEAR		; V-SYNC timer value load.


;	データ復元
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ
;	-O- BCOUNT ; データ長さ
;	    BPOINT ; データ終わりアドレス＋１
;	    AH     : 0=normal 1=E.O.F

UNPLS	PROC	NEAR
	CALL	LDPLSD		; data read & convert.

	CMP	PLSMDE,1	; 圧縮モード(0:通常,1:縦方向)
	JE	UNPLS2

	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VRMPUT
	POP	DS
	JMP	UNPLS9
UNPLS2:
	CMP	BBOVLP,0	; オーバラップフラグ
	JE	UNPLS3		;

	MOV	AX,0		; パターンＰＵＴオーバラップタイム
	CALL	TMVSET		; V-SYNC timer set.
	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VCXRTW_OL	; 縦横バイト並べ戻し・オーバラップ
	POP	DS
	JMP	UNPLS9
UNPLS3:				;
	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VCXRTW		; 縦横バイト並べ戻し
	POP	DS
UNPLS9:
	RET
UNPLS	ENDP



;	圧縮モード切り替え
;	-I- DX : 圧縮モード(0:通常,1:縦方向)

PLSMOD	PROC	NEAR
	MOV	PLSMDE,DX	; 圧縮モード(0:通常,1:縦方向)
	RET
PLSMOD	ENDP



;	パーツＰＵＴのプレーンスキップ
;	-I- DX : スキッププレーン (bit3:plean3,bit2:plean2,bit1:1,bit0:0)

PLSSKP	PROC	NEAR
	MOV	PRSSKP,DX	; パーツＰＵＴのスキッププレーン
	RET
PLSSKP	ENDP



;	圧縮フォーマットデータ復元
;	-I- BPNTOF     : データバッファポインタ
;	    BPNTSG     : データバッファセグメント
;	-O- SEGDOS:DTA : ＤＴＡ領域に展開データ

LDPLSD	PROC	NEAR
	PUSH	DS

	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	ES,AX		;
	MOV	DI,DTA		; ＤＴＡトップ

	CALL	BUNPLE		; 圧縮フォーマットデータ復元

	POP	DS
	RET
LDPLSD	ENDP


;	ＶＲＡＭＰＵＴ
;	-I- ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	    DS        : データバッファセグメント
;	    SI        : データバッファポインタ
;	    PRSSKP    : パーツＰＵＴのスキッププレーン (bit3:plean3,...)

VRMPUT	PROC	NEAR
	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0001B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMPUT_01	;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	CALL	PLNSET		; 範囲指定１プレーンセット
	JMP	VRMPUT_02	;
VRMPUT_01:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMPUT_02:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0010B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMPUT_11	;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	CALL	PLNSET		; 範囲指定１プレーンセット
	JMP	VRMPUT_12	;
VRMPUT_11:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMPUT_12:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0100B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMPUT_21	;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	CALL	PLNSET		; 範囲指定１プレーンセット
	JMP	VRMPUT_22	;
VRMPUT_21:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMPUT_22:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,1000B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMPUT_31	;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	CALL	PLNSET		; 範囲指定１プレーンセット
	JMP	VRMPUT_32	;
VRMPUT_31:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMPUT_32:			;

	RET
VRMPUT	ENDP



;	範囲指定１プレーンセット
;	ワークバッファ－＞ＶＲＡＭプレーン
;	-I- DX        : ＶＲＡＭプレーンセグメント
;	    ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	-I/O- DS      : データバッファセグメント
;	      SI      : データバッファポインタ

PLNSET	PROC	NEAR
	MOV	AX,ES:VRLENX	; x length.=AX
	MOV	BX,ES:VRLENY	; y length.=BX

	MOV	DI,ES:VRY	;
	SHL	DI,1		;
	SHL	DI,1		;  point address.
	SHL	DI,1		;
	SHL	DI,1		;  DI = VRY * 80 + VRX
	MOV	CX,DI		;
	SHL	DI,1		;
	SHL	DI,1		;
	ADD	DI,CX		;
	ADD	DI,ES:VRX	;
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント
PLNSET2:
	MOV	CX,AX		; Ｘ長さ
	REP	MOVSB		;

	SUB	DI,AX		; X length.=AX
	ADD	DI,ADDWIDTH	; ＶＲＡＭライン計算用

	DEC	BX		; Y length.=BX
	JNZ	PLNSET2		;

	RET
PLNSET	ENDP



;	縦横バイト並べ戻し
;	-I- ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	    DS        : データバッファセグメント
;	    SI        : データバッファポインタ
;	    PRSSKP    : パーツＰＵＴのスキッププレーン (bit3:plean3,...)

VCXRTW	PROC	NEAR
	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0001B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_01	;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	JMP	VRMRTW_02	;
VRMRTW_01:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_02:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0010B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_11	;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	JMP	VRMRTW_12	;
VRMRTW_11:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_12:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0100B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_21	;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	JMP	VRMRTW_22	;
VRMRTW_21:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_22:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,1000B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_31	;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	JMP	VRMRTW_32	;
VRMRTW_31:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_32:			;

	RET
VCXRTW	ENDP



;	縦横バイト並べ戻し・オーバラップ
;	-I- ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	    DS        : データバッファセグメント
;	    SI        : データバッファポインタ
;	    PRSSKP    : パーツＰＵＴのスキッププレーン (bit3:plean3,...)

VCXRTW_OL	PROC	NEAR
	MOV	AX,SEG DATA		;
	MOV	ES,AX			;

	MOV	ES:BBMASK,01111111B	; パターンＰＵＴオーバラップマスク

	MOV	CX,8			;
VCXRTW_OL_LOOP:				;
	PUSH	CX			;
	MOV	AX,SEG DATA		;
	MOV	ES,AX			;
	ROR	BYTE PTR ES:BBMASK,1	; パターンＰＵＴオーバラップマスク
	ROR	BYTE PTR ES:BBMASK,1	; パターンＰＵＴオーバラップマスク
	ROR	BYTE PTR ES:BBMASK,1	; パターンＰＵＴオーバラップマスク
	CALL	VCXRTW_OL_MSK		; 縦横バイト並べ戻し・ドットマスク

	CALL	VCXRTW_OL_WAIT		; オーバラップＷＡＩＴ
	POP	CX			;
	LOOP	VCXRTW_OL_LOOP

	RET
VCXRTW_OL	ENDP


;	縦横バイト並べ戻し・ドットマスク
;	-I- ES:VRX: x point.
;	    ES:VRY: y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	    BBMASK    : パターンＰＵＴオーバラップマスク
;	    DS        : データバッファセグメント
;	    SI        : データバッファポインタ
;	    PRSSKP    : パーツＰＵＴのスキッププレーン (bit3:plean3,...)

VCXRTW_OL_MSK	PROC	NEAR
	PUSH	SI

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0001B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_OL_01	;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	CALL	MTXVRF_OL	; 縦横バイト並べ戻し・ドットマスク
	JMP	VRMRTW_OL_02	;
VRMRTW_OL_01:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_OL_02:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0010B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_OL_11	;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	CALL	MTXVRF_OL	; 縦横バイト並べ戻し・ドットマスク
	JMP	VRMRTW_OL_12	;
VRMRTW_OL_11:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_OL_12:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,0100B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_OL_21	;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	CALL	MTXVRF_OL	; 縦横バイト並べ戻し・ドットマスク
	JMP	VRMRTW_OL_22	;
VRMRTW_OL_21:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_OL_22:			;

	MOV	AX,SEG DATA	;
	MOV	ES,AX		;
	TEST	ES:PRSSKP,1000B	; パーツＰＵＴのスキッププレーン
	JNZ	VRMRTW_OL_31	;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	CALL	MTXVRF_OL	; 縦横バイト並べ戻し・ドットマスク
	JMP	VRMRTW_OL_32	;
VRMRTW_OL_31:			;
	CALL	PLN_FF		; 範囲指定１プレーン空送り
VRMRTW_OL_32:			;

	POP	SI
	RET
VCXRTW_OL_MSK	ENDP


;	オーバラップＷＡＩＴ

VCXRTW_OL_WAIT	PROC	NEAR
	PUSH	DS			;
	MOV	AX,SEG DATA		;
	MOV	DS,AX			;
	CALL	OVLAP_WAIT		; オーバラップＷＡＩＴ
	POP	DS			;
	RET
VCXRTW_OL_WAIT	ENDP



;	縦横バイト並べ戻し範囲指定１プレーン
;	ワークバッファ－＞ＶＲＡＭプレーン
;	ＶＲＡＭバイトイメージの縦横入れ替えを戻します
;	-I- DX        : ＶＲＡＭプレーンセグメント
;	    ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	    ES:BBOVLP : オーバラップフラグ
;	-I/O- DS      : データバッファセグメント
;	      SI      : データバッファポインタ

MTXVRF	PROC	NEAR
	MOV	AX,ES:VRLENX	; x length.=AX
	MOV	BX,ES:VRLENY	; y length.=BX

	MOV	DI,ES:VRY	;
	SHL	DI,1		;
	SHL	DI,1		;  point address.
	SHL	DI,1		;
	SHL	DI,1		;  DI = VRY * 80 + VRX
	MOV	CX,DI		;
	SHL	DI,1		;
	SHL	DI,1		;
	ADD	DI,CX		;
	ADD	DI,ES:VRX	;
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント
MTXVRF2:
	MOV	CX,BX		; Ｙ長さ
MTXVRF3:
	MOVSB			;
	ADD	DI,ADDWIDTHB	; ＶＲＡＭライン計算用
	LOOP	MTXVRF3		;

	INC	BP		;
	MOV	DI,BP		; ＶＲＡＭ転送の先頭オフセット

	DEC	AX		; X length.=AX
	JNZ	MTXVRF2		;

	RET
MTXVRF	ENDP



;	縦横バイト並べ戻し範囲指定１プレーン・ドットマスク
;	ワークバッファ－＞ＶＲＡＭプレーン
;	ＶＲＡＭバイトイメージの縦横入れ替えを戻します
;	-I- DX        : ＶＲＡＭプレーンセグメント
;	    ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	    ES:BBMASK : パターンＰＵＴオーバラップマスク
;	-I/O- DS      : データバッファセグメント
;	      SI      : データバッファポインタ

MTXVRF_OL	PROC	NEAR
	MOV	AL,BYTE PTR ES:VRLENX		; x length.=AL
	MOV	BX,ES:VRLENY			; y length.=BX

	MOV	AH,BYTE PTR ES:BBMASK	; AH=パターンＰＵＴオーバラップマスク

	MOV	DI,ES:VRY	;
	SHL	DI,1		;
	SHL	DI,1		;  point address.
	SHL	DI,1		;
	SHL	DI,1		;  DI = VRY * 80 + VRX
	MOV	CX,DI		;
	SHL	DI,1		;
	SHL	DI,1		;
	ADD	DI,CX		;
	ADD	DI,ES:VRX	;
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント

	MOV	DL,AL		; DL=x length.=AL

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント
MTXVRF_OL2:
	MOV	CX,BX		; Ｙ長さ
MTXVRF_OL3:
	MOV	AL,ES:[DI]	; AL <- vram.
	AND	AL,AH		; AL mask.
	MOV	DH,DS:[SI]	; DH <- buffer.
	NOT	AH		;
	AND	DH,AH		; DH not mask.
	NOT	AH		;
	OR	AL,DH		; AL or DH
	STOSB			; AL put. -> vram.
	INC	SI		;

	ROL	AH,1		; AH=パターンＰＵＴオーバラップマスク
	ROL	AH,1		; AH=パターンＰＵＴオーバラップマスク

	ADD	DI,ADDWIDTHB	; ＶＲＡＭライン計算用
	LOOP	MTXVRF_OL3	;

	INC	BP		;
	MOV	DI,BP		; ＶＲＡＭ転送の先頭オフセット

	DEC	DL		; X length.=DL
	JNZ	MTXVRF_OL2	;

	RET
MTXVRF_OL	ENDP


;	オーバラップＷＡＩＴ

OVLAP_WAIT	PROC	NEAR
	PUSH	AX		;
	PUSH	BX		;
	PUSH	DX		;
OVLAP_WAIT2:			;
	CALL	TMVCHK		; V-SYNC timer check.
	CMP	AX,1		; 0=timer now, 1=timer end.
	JNE	OVLAP_WAIT2	;
	MOV	AX,BBOVTM	; パターンＰＵＴオーバラップタイム
	CALL	TMVSET		; V-SYNC timer set.
	POP	DX
	POP	BX
	POP	AX
	RET
OVLAP_WAIT	ENDP


;	範囲指定１プレーン空送り
;	ワークバッファ－＞ＶＲＡＭプレーン
;	-I- ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	-I/O- DS      : データバッファセグメント
;	      SI      : データバッファポインタ

PLN_FF	PROC	NEAR
	MOV	BX,ES:VRLENY	; y length.=BX
	MOV	AX,ES:VRLENX	; x length.=AX
	CWD			;
	IMUL	BX		;
	ADD	SI,AX		; 空送り
	RET
PLN_FF	ENDP

CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	BBOVTM			; パターンＰＵＴオーバラップタイム
PUBLIC	BBOVLP			; パターンＰＵＴオーバラップフラグ

EXTRN	PRSSKP:WORD		; パーツＰＵＴのスキッププレーン
				; (bit3:plean3,bit2:plean2,bit1:1,bit0:0)

EXTRN	SEGDOS:WORD		; ＤＯＳインターフェースセグメント

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

EXTRN	PLSMDE:WORD		; 圧縮モード(0:通常,1:縦方向)

BBOVLP		DW	0	; パターンＰＵＴオーバラップフラグ
BBOVTM		DW	4	; パターンＰＵＴオーバラップタイム
BBMASK		DW	0	; パターンＰＵＴオーバラップマスク

DATA	ENDS

	END
;
;	end of "PLSLD2.ASM"
;
