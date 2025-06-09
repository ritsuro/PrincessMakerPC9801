; "VRMCH2.ASM" PC-9801UV11 make by R.H 1990/02/08
;
;
;	範囲指定ＶＲＡＭ組替え
;
; public subroutine.

;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;


PLSBUF	SEGMENT	PUBLIC	'PLSBUF'	; データ圧縮用ワークバッファ
PLSBUF	ENDS


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	VCXHST		; 縦横バイト並べ替え
PUBLIC	VCXRTW		; 縦横バイト並べ戻し


ADDWIDTH	EQU	80	; ＶＲＡＭライン計算用（ＶＲＡＭ幅）
ADDWIDTHB	EQU	79	; ＶＲＡＭライン計算用


;	縦横バイト並べ替え
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.

VCXHST	PROC	NEAR
	MOV	DX,SSGR0	; visual data segment plean 0
	CALL	MTXWBF		; 縦横バイト並べ替え範囲指定１プレーン
	CALL	VRMVRF		; ワークバッファ－＞ＶＲＡＭプレーン

	MOV	DX,SSGR1	; visual data segment plean 1
	CALL	MTXWBF		; 縦横バイト並べ替え範囲指定１プレーン
	CALL	VRMVRF		; ワークバッファ－＞ＶＲＡＭプレーン

	MOV	DX,SSGR2	; visual data segment plean 2
	CALL	MTXWBF		; 縦横バイト並べ替え範囲指定１プレーン
	CALL	VRMVRF		; ワークバッファ－＞ＶＲＡＭプレーン

	MOV	DX,SSGR3	; visual data segment plean 3
	CALL	MTXWBF		; 縦横バイト並べ替え範囲指定１プレーン
	CALL	VRMVRF		; ワークバッファ－＞ＶＲＡＭプレーン
	RET
VCXHST	ENDP



;	縦横バイト並べ戻し
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.

VCXRTW	PROC	NEAR
	MOV	DX,SSGR0	; visual data segment plean 0
	CALL	VRMWBF		; ＶＲＡＭプレーン－＞ワークバッファ
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

	MOV	DX,SSGR1	; visual data segment plean 1
	CALL	VRMWBF		; ＶＲＡＭプレーン－＞ワークバッファ
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

	MOV	DX,SSGR2	; visual data segment plean 2
	CALL	VRMWBF		; ＶＲＡＭプレーン－＞ワークバッファ
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

	MOV	DX,SSGR3	; visual data segment plean 3
	CALL	VRMWBF		; ＶＲＡＭプレーン－＞ワークバッファ
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

	RET
VCXRTW	ENDP



;	縦横バイト並べ替え範囲指定１プレーン
;	ＶＲＡＭプレーン－＞ワークバッファ
;	ＶＲＡＭバイトイメージの横ラインと縦列を入れ替えます
;	-I- DX : ＶＲＡＭプレーンセグメント
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.

MTXWBF	PROC	NEAR
	PUSH	DS

	MOV	AX,VRLENX	; x length.=AX
	MOV	BX,VRLENY	; y length.=BX

	MOV	SI,VRY		;
	SHL	SI,1		;
	SHL	SI,1		;  point address.
	SHL	SI,1		;
	SHL	SI,1		;  SI = VRY * 80 + VRX
	MOV	CX,SI		;
	SHL	SI,1		;
	SHL	SI,1		;
	ADD	SI,CX		;
	ADD	SI,VRX		;
	MOV	DS,DX		; ＶＲＡＭプレーンセグメント

	MOV	BP,SI		; ＶＲＡＭ指定位置の先頭オフセット

	MOV	CX,SEG PLSBUF	;
	MOV	ES,CX		; データ圧縮用ワークバッファ
	MOV	DI,OFFSET PLSBTP
MTXWBF2:
	MOV	CX,BX		; Ｙ長さ
MTXWBF3:
	MOVSB			;
	ADD	SI,ADDWIDTHB	; ＶＲＡＭライン計算用
	LOOP	MTXWBF3		;

	INC	BP		;
	MOV	SI,BP		; ＶＲＡＭ指定位置の先頭オフセット

	DEC	AX		; X length.=AX
	JNZ	MTXWBF2		;

	POP	DS
	RET
MTXWBF	ENDP



;	縦横バイト並べ戻し範囲指定１プレーン
;	ワークバッファ－＞ＶＲＡＭプレーン
;	ＶＲＡＭバイトイメージの縦横入れ替えを戻します
;	-I- DX : ＶＲＡＭプレーンセグメント
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.

MTXVRF	PROC	NEAR
	PUSH	DS

	MOV	AX,VRLENX	; x length.=AX
	MOV	BX,VRLENY	; y length.=BX

	MOV	DI,VRY		;
	SHL	DI,1		;
	SHL	DI,1		;  point address.
	SHL	DI,1		;
	SHL	DI,1		;  DI = VRY * 80 + VRX
	MOV	CX,DI		;
	SHL	DI,1		;
	SHL	DI,1		;
	ADD	DI,CX		;
	ADD	DI,VRX		;
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント

	MOV	CX,SEG PLSBUF	;
	MOV	DS,CX		; データ圧縮用ワークバッファ
	MOV	SI,OFFSET PLSBTP
MTXVRF2:
	MOV	CX,BX		; Ｙ長さ
MTXVRF3:
	MOVSB			;
	ADD	DI,ADDWIDTHB	; ＶＲＡＭライン計算用
	LOOP	MTXVRF3		;

	INC	BP		;
	MOV	DI,BP		; データ圧縮用バッファの先頭オフセット

	DEC	AX		; X length.=AX
	JNZ	MTXVRF2		;

	POP	DS
	RET
MTXVRF	ENDP



;	ＶＲＡＭプレーン－＞ワークバッファ
;	-I- DX : ＶＲＡＭプレーンセグメント
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	-O- BP : ＶＲＡＭ指定位置の先頭オフセット

VRMWBF	PROC	NEAR
	PUSH	DS

	MOV	AX,VRLENX	; x length.=AX
	MOV	BX,VRLENY	; y length.=BX

	MOV	SI,VRY		;
	SHL	SI,1		;
	SHL	SI,1		;  point address.
	SHL	SI,1		;
	SHL	SI,1		;  SI = VRY * 80 + VRX
	MOV	CX,SI		;
	SHL	SI,1		;
	SHL	SI,1		;
	ADD	SI,CX		;
	ADD	SI,VRX		;
	MOV	DS,DX		; ＶＲＡＭプレーンセグメント

	MOV	BP,SI		; ＶＲＡＭ指定位置の先頭オフセット

	MOV	CX,SEG PLSBUF	;
	MOV	ES,CX		; データ圧縮用ワークバッファ
	MOV	DI,OFFSET PLSBTP

VRMWBF2:
	MOV	CX,AX		; Ｘ長さ
	REP	MOVSB		;
	ADD	SI,ADDWIDTH	; ＶＲＡＭライン計算用（ＶＲＡＭ幅）
	SUB	SI,AX		; Ｘ長さ、との差

	DEC	BX		; y length.=BX
	JNZ	VRMWBF2		;

	POP	DS
	RET
VRMWBF	ENDP



;	ワークバッファ－＞ＶＲＡＭプレーン
;	-I- DX : ＶＲＡＭプレーンセグメント
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	-O- BP : ＶＲＡＭ指定位置の先頭オフセット

VRMVRF	PROC	NEAR
	PUSH	DS

	MOV	AX,VRLENX	; x length.=AX
	MOV	BX,VRLENY	; y length.=BX

	MOV	DI,VRY		;
	SHL	DI,1		;
	SHL	DI,1		;  point address.
	SHL	DI,1		;
	SHL	DI,1		;  DI = VRY * 80 + VRX
	MOV	CX,DI		;
	SHL	DI,1		;
	SHL	DI,1		;
	ADD	DI,CX		;
	ADD	DI,VRX		;
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント

	MOV	BP,DI		; ＶＲＡＭ指定位置の先頭オフセット

	MOV	CX,SEG PLSBUF	;
	MOV	DS,CX		; データ圧縮用ワークバッファ
	MOV	SI,OFFSET PLSBTP

VRMVRF2:
	MOV	CX,AX		; Ｘ長さ
	REP	MOVSB		;
	ADD	DI,ADDWIDTH	; ＶＲＡＭライン計算用（ＶＲＡＭ幅）
	SUB	DI,AX		; Ｘ長さ、との差

	DEC	BX		; y length.=BX
	JNZ	VRMVRF2		;

	POP	DS
	RET
VRMVRF	ENDP


CODE	ENDS


;	データ圧縮用ワークバッファ

PLSBUF	SEGMENT	PUBLIC	'PLSBUF'
EXTRN	PLSBTP:BYTE
PLSBUF	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

PLNSEG	DW	0	; プレーンセグメント

DATA	ENDS

	END
;
;	end of "VRMCH2.ASM"
;
