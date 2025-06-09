; "VRMCHG.ASM" PC-9801UV11 make by R.H 1990/02/05
;
;
;	ＶＲＡＭ組替え
;
; public subroutine.

;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	VCHHST		; 縦横バイト並べ替え
PUBLIC	VCHRTW		; 縦横バイト並べ戻し
PUBLIC	VCHSEL		; ＶＲＡＭ偶数ライン１ビット左シフト
PUBLIC	VCHSER		; ＶＲＡＭ偶数ライン１ビット右シフト


ADDWIDTH	EQU	80	; ＶＲＡＭライン計算用（ＶＲＡＭ幅）
ADDWIDTHS	EQU	-80	; ＶＲＡＭライン計算用（－ＶＲＡＭ幅）
ADDWIDTHB	EQU	79	; ＶＲＡＭライン計算用
PLEANLEN	EQU	32000	; ＶＲＡＭプレーン長さ
VRAMLINE	EQU	400	; ＶＲＡＭライン数


;	縦横バイト並べ替え

VCHHST	PROC	NEAR
	MOV	AX,SSGR0	; visual data segment plean 0
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTWID		; 縦横バイト並べ替え１プレーン
	MOV	AX,SSGR1	; visual data segment plean 1
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTWID		; 縦横バイト並べ替え１プレーン
	MOV	AX,SSGR2	; visual data segment plean 2
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTWID		; 縦横バイト並べ替え１プレーン
	MOV	AX,SSGR3	; visual data segment plean 3
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTWID		; 縦横バイト並べ替え１プレーン
	RET
VCHHST	ENDP



;	縦横バイト並べ戻し

VCHRTW	PROC	NEAR
	MOV	AX,SSGR0	; visual data segment plean 0
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTRTW		; 縦横バイト並べ戻し１プレーン
	MOV	AX,SSGR1	; visual data segment plean 1
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTRTW		; 縦横バイト並べ戻し１プレーン
	MOV	AX,SSGR2	; visual data segment plean 2
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTRTW		; 縦横バイト並べ戻し１プレーン
	MOV	AX,SSGR3	; visual data segment plean 3
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	VSTRTW		; 縦横バイト並べ戻し１プレーン
	RET
VCHRTW	ENDP



;	ＶＲＡＭ偶数ライン１ビット左シフト

VCHSEL	PROC	NEAR
	MOV	AX,SSGR0	; visual data segment plean 0
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1L		; 偶数ライン１ビット左シフト１プレーン
	MOV	AX,SSGR1	; visual data segment plean 1
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1L		; 偶数ライン１ビット左シフト１プレーン
	MOV	AX,SSGR2	; visual data segment plean 2
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1L		; 偶数ライン１ビット左シフト１プレーン
	MOV	AX,SSGR3	; visual data segment plean 3
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1L		; 偶数ライン１ビット左シフト１プレーン
	RET
VCHSEL	ENDP



;	ＶＲＡＭ偶数ライン１ビット右シフト

VCHSER	PROC	NEAR
	MOV	AX,SSGR0	; visual data segment plean 0
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1R		; 偶数ライン１ビット右シフト１プレーン
	MOV	AX,SSGR1	; visual data segment plean 1
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1R		; 偶数ライン１ビット右シフト１プレーン
	MOV	AX,SSGR2	; visual data segment plean 2
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1R		; 偶数ライン１ビット右シフト１プレーン
	MOV	AX,SSGR3	; visual data segment plean 3
	MOV	PLNSEG,AX	; ＶＲＡＭプレーンセグメント
	CALL	EVLN1R		; 偶数ライン１ビット右シフト１プレーン
	RET
VCHSER	ENDP




;	縦横バイト並べ替え１プレーン
;	ＶＲＡＭバイトイメージの横ラインと縦列を入れ替えます
;	-I- PLNSEG : ＶＲＡＭプレーンセグメント

VSTWID	PROC	NEAR
	MOV	DX,PLNSEG	; プレーンセグメント
	CALL	VRMWBF		; ＶＲＡＭプレーン－＞ワークバッファ

	PUSH	DS

	MOV	AX,PLNSEG	; ＶＲＡＭプレーンセグメント=ES:DI
	MOV	ES,AX		;
	MOV	DI,0		;
	MOV	CX,PLEANLEN	; ＶＲＡＭプレーン長さ

	MOV	AX,SEG PLSBUF	;
	MOV	DS,AX		; ワークバッファ=DS:SI
	MOV	SI,OFFSET PLSBTP
VSTWID2:
	MOVSB			; ワークバッファ－＞ＶＲＡＭプレーン

	ADD	SI,ADDWIDTHB	; ＶＲＡＭライン計算用
	CMP	SI,PLEANLEN	; ＶＲＡＭプレーン長さ
	JL	VSTWID4		;

	SUB	SI,PLEANLEN	; ＶＲＡＭプレーン長さ
	INC	SI		; 次の列へ
VSTWID4:
	LOOP	VSTWID2

	POP	DS

	RET
VSTWID	ENDP



;	縦横バイト並べ戻し１プレーン
;	ＶＲＡＭバイトイメージの縦横入れ替えを戻します
;	-I- PLNSEG : ＶＲＡＭプレーンセグメント

VSTRTW	PROC	NEAR
	MOV	DX,PLNSEG	; プレーンセグメント
	CALL	VRMWBF		; ＶＲＡＭプレーン－＞ワークバッファ

	PUSH	DS

	MOV	AX,PLNSEG	; ＶＲＡＭプレーンセグメント=ES:DI
	MOV	ES,AX		;
	MOV	DI,0		;
	MOV	CX,PLEANLEN	; ＶＲＡＭプレーン長さ

	MOV	AX,SEG PLSBUF	;
	MOV	DS,AX		; ワークバッファ=DS:SI
	MOV	SI,OFFSET PLSBTP
VSTRTW2:
	MOVSB			; ワークバッファ－＞ＶＲＡＭプレーン

	ADD	DI,ADDWIDTHB	; ＶＲＡＭライン計算用
	CMP	DI,PLEANLEN	; ＶＲＡＭプレーン長さ
	JL	VSTRTW4		;

	SUB	DI,PLEANLEN	; ＶＲＡＭプレーン長さ
	INC	DI		; 次の列へ
VSTRTW4:
	LOOP	VSTRTW2

	POP	DS

	RET
VSTRTW	ENDP



;	偶数ライン１ビット左シフト１プレーン
;	-I- PLNSEG : ＶＲＡＭプレーンセグメント

EVLN1L	PROC	NEAR
	MOV	AX,PLNSEG	; ＶＲＡＭプレーンセグメント=ES:DI
	MOV	ES,AX		;
	MOV	DI,PLEANLEN-ADDWIDTH ; ＶＲＡＭライン最後の偶数ライン

	MOV	CX,VRAMLINE/2	; ＶＲＡＭライン数
EVLN1L1:
	PUSH	CX

	MOV	CX,ADDWIDTH	; ＶＲＡＭライン計算用（ＶＲＡＭ幅）
EVLN1L2:
	DEC	DI		; ＶＲＡＭの先頭（左）へ向かっている
	RCL	BYTE PTR ES:[DI],1	; １ビットずつ左へ送る
	LOOP	EVLN1L2
	RCL	AL,1		; 先頭の１ビットを後ろのビット０へセット
	AND	AL,1B		;
	AND	BYTE PTR ES:[DI][ADDWIDTHB],11111110B
	OR	BYTE PTR ES:[DI][ADDWIDTHB],AL

	SUB	DI,ADDWIDTH	; ＶＲＡＭ１ラインスキップする
	POP	CX
	LOOP	EVLN1L1		; 偶数ラインはすべて行なう

	RET
EVLN1L	ENDP



;	偶数ライン１ビット右シフト１プレーン
;	-I- PLNSEG : ＶＲＡＭプレーンセグメント

EVLN1R	PROC	NEAR
	MOV	AX,PLNSEG	; ＶＲＡＭプレーンセグメント=ES:DI
	MOV	ES,AX		;
	MOV	DI,0		;

	MOV	CX,VRAMLINE/2	; ＶＲＡＭライン数
EVLN1R1:
	PUSH	CX

	MOV	CX,ADDWIDTH	; ＶＲＡＭライン計算用（ＶＲＡＭ幅）
EVLN1R2:
	RCR	BYTE PTR ES:[DI],1	; １ビットずつ右へ送る
	INC	DI
	LOOP	EVLN1R2
	RCR	AL,1		; 後ろの１ビットを先頭のビット７へセット
	AND	AL,10000000B	;
	AND	BYTE PTR ES:[DI][ADDWIDTHS],01111111B
	OR	BYTE PTR ES:[DI][ADDWIDTHS],AL

	ADD	DI,ADDWIDTH	; ＶＲＡＭ１ラインスキップする
	POP	CX
	LOOP	EVLN1R1		; 偶数ラインはすべて行なう

	RET
EVLN1R	ENDP



;	ＶＲＡＭプレーン－＞ワークバッファ
;	-I- DX : ＶＲＡＭプレーンセグメント

VRMWBF	PROC	NEAR
	PUSH	DS
	MOV	DS,DX		; ＶＲＡＭプレーンセグメント
	MOV	SI,0		;
	MOV	AX,SEG PLSBUF	;
	MOV	ES,AX		; データ圧縮用ワークバッファ
	MOV	DI,OFFSET PLSBTP
	MOV	CX,PLEANLEN/2	; ＶＲＡＭプレーン長さ
	REP	MOVSW		;
	POP	DS
	RET
VRMWBF	ENDP



;	ワークバッファ－＞ＶＲＡＭプレーン
;	-I- DX : ＶＲＡＭプレーンセグメント

VRMVRF	PROC	NEAR
	PUSH	DS
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント
	MOV	DI,0		;
	MOV	AX,SEG PLSBUF
	MOV	DS,AX		; データ圧縮用ワークバッファ
	MOV	SI,OFFSET PLSBTP
	MOV	CX,PLEANLEN/2	; ＶＲＡＭプレーン長さ
	REP	MOVSW		;
	POP	DS
	RET
VRMVRF	ENDP


CODE	ENDS


;	データ圧縮用ワークバッファ

PLSBUF	SEGMENT	PUBLIC	'PLSBUF'
EXTRN	PLSBTP:BYTE
PLSBUF	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

PLNSEG	DW	0	; プレーンセグメント

DATA	ENDS

	END
;
;	end of "VRMCHG.ASM"
;
