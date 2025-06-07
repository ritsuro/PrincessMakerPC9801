; "ADVTBL.ASM" 1989/3/21 R.H
;              PC-9801UV11 make by R.H 1989
; public table.



ARA001_SEG	EQU	8000H	; 本体の後ろフリエリア
ARA002_SEG	EQU	8000H	; 本体の後ろフリエリア

EFECT_BUFF_LEN	EQU	1024	; エフェクト用バッファの長さ

DATA	SEGMENT	PUBLIC	'DATA'


PUBLIC	SSGR0			; visual data segment plean 0
PUBLIC	SSGR1			; visual data segment plean 1
PUBLIC	SSGR2			; visual data segment plean 2
PUBLIC	SSGR3			; visual data segment plean 3

PUBLIC	SSDES0			; visual data segment plean 0
PUBLIC	SSDES1			; visual data segment plean 1
PUBLIC	SSDES2			; visual data segment plean 2
PUBLIC	SSDES3			; visual data segment plean 3

PUBLIC	SSSOU0			; visual data segment plean 0
PUBLIC	SSSOU1			; visual data segment plean 1
PUBLIC	SSSOU2			; visual data segment plean 2
PUBLIC	SSSOU3			; visual data segment plean 3

PUBLIC	VX1			; point x1.
PUBLIC	VY1			; point y1.
PUBLIC	VX2			; point x2.
PUBLIC	VY2			; point y2.
PUBLIC	VX3			; point x3.
PUBLIC	VY3			; point y3.
PUBLIC	ADRS			; address.
PUBLIC	NUM			; number.

PUBLIC	ARAVRM			; vram area.
PUBLIC	ARA001			; ram area 1.
PUBLIC	ARA002			; ram area 2.

	EVEN
SSGR0	DW	0A800H		; visual data segment plean 0
SSGR1	DW	0B000H		; visual data segment plean 1
SSGR2	DW	0B800H		; visual data segment plean 2
SSGR3	DW	0E000H		; visual data segment plean 3

SSDES0	DW	0		; visual data segment plean 0
SSDES1	DW	0		; visual data segment plean 1
SSDES2	DW	0		; visual data segment plean 2
SSDES3	DW	0		; visual data segment plean 3

SSSOU0	DW	0		; visual data segment plean 0
SSSOU1	DW	0		; visual data segment plean 1
SSSOU2	DW	0		; visual data segment plean 2
SSSOU3	DW	0		; visual data segment plean 3

VX1	DW	0		; point x1.
VY1	DW	0		; point y1.
VX2	DW	0		; point x2.
VY2	DW	0		; point y2.
VX3	DW	0		; point x3.
VY3	DW	0		; point y3.
ADRS	DW	0		; address.
NUM	DW	0		; number.

ARAVRM	LABEL	WORD		; vram area.
	DW	0A800H		; vram plean 0.
	DW	0B000H		; vram plean 1.
	DW	0B800H		; vram plean 2.
	DW	0E000H		; vram plean 3.

ARA001	LABEL	WORD			; ram area 1.
;****;		DW	SEG BUF001		; area plean 0.
;****;		DW	SEG BUF002		; area plean 1.
;****;		DW	SEG BUF003		; area plean 2.
;****;		DW	SEG BUF004		; area plean 3.
	DW	ARA001_SEG		; area plean 0.
	DW	ARA001_SEG+2000		; area plean 1.
	DW	ARA001_SEG+(2000*2)	; area plean 2.
	DW	ARA001_SEG+(2000*3)	; area plean 3.

ARA002	LABEL	WORD			; ram area 2.
;****;		DW	SEG BUF001		; area plean 0.
;****;		DW	SEG BUF002		; area plean 1.
;****;		DW	SEG BUF003		; area plean 2.
;****;		DW	SEG BUF004		; area plean 3.
	DW	ARA002_SEG		; area plean 0.
	DW	ARA002_SEG+2000		; area plean 1.
	DW	ARA002_SEG+(2000*2)	; area plean 2.
	DW	ARA002_SEG+(2000*3)	; area plean 3.

DATA	ENDS

;****;	
;****;	BUF001	SEGMENT	PUBLIC	'BUF001'
;****;		DB	32000 DUP (?)
;****;	BUF001	ENDS
;****;	
;****;	BUF002	SEGMENT	PUBLIC	'BUF001'
;****;		DB	32000 DUP (?)
;****;	BUF002	ENDS
;****;	
;****;	BUF003	SEGMENT	PUBLIC	'BUF001'
;****;		DB	32000 DUP (?)
;****;	BUF003	ENDS
;****;	
;****;	BUF004	SEGMENT	PUBLIC	'BUF001'
;****;		DB	32000 DUP (?)
;****;	BUF004	ENDS
;****;	
;****;	
;****;	BUF005	SEGMENT	PUBLIC	'BUF001'
;****;		DB	32000 DUP (?)
;****;	BUF005	ENDS
;****;	
;****;	BUF006	SEGMENT	PUBLIC	'BUF001'
;****;		DB	32000 DUP (?)
;****;	BUF006	ENDS
;****;	


;	エフェクト用バッファ

EFECT0	SEGMENT	PUBLIC	'EFECT0'
	PUBLIC	ECTOP0
ECTOP0	DB	EFECT_BUFF_LEN DUP (0)

EFECT0	ENDS


	END
;
;	end of "ADVTBL.ASM"
;
