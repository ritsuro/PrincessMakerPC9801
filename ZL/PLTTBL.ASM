; "PLTTBL.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;
;	パレットテーブル
;
;
; public table.

PALET	SEGMENT	PUBLIC	'PALET'

PUBLIC	PLTNUM			; ハードパレットテーブル
PUBLIC	PLTOFS			; パレットアドレステーブル（色相）
PUBLIC	PCNOFS			; パレットアドレステーブル（彩度）
PUBLIC	PBROFS			; パレットアドレステーブル（明度）

PLTNUM	LABEL	WORD
	DW	OFFSET PHDP0L
	DW	OFFSET PHDP0H
	DW	OFFSET PHDP1L
	DW	OFFSET PHDP1H
	DW	OFFSET PHDP2L
	DW	OFFSET PHDP2H
	DW	OFFSET PHDP3L
	DW	OFFSET PHDP3H

PLTOFS	LABEL	WORD
	DW	OFFSET PLT0L
	DW	OFFSET PLT0H
	DW	OFFSET PLT1L
	DW	OFFSET PLT1H
	DW	OFFSET PLT2L
	DW	OFFSET PLT2H
	DW	OFFSET PLT3L
	DW	OFFSET PLT3H

PCNOFS	LABEL	WORD
	DW	OFFSET PCNS0L
	DW	OFFSET PCNS0H
	DW	OFFSET PCNS1L
	DW	OFFSET PCNS1H
	DW	OFFSET PCNS2L
	DW	OFFSET PCNS2H
	DW	OFFSET PCNS3L
	DW	OFFSET PCNS3H

PBROFS	LABEL	WORD
	DW	OFFSET PBRI0L
	DW	OFFSET PBRI0H
	DW	OFFSET PBRI1L
	DW	OFFSET PBRI1H
	DW	OFFSET PBRI2L
	DW	OFFSET PBRI2H
	DW	OFFSET PBRI3L
	DW	OFFSET PBRI3H


PHDP0L	DW	0, 9,10,11,12,13,14,15
PHDP0H	DW	8, 1, 2, 3, 4, 5, 6, 7

PHDP1L	DW	0, 9,10,11,12,13,14,15
PHDP1H	DW	8, 1, 2, 3, 4, 5, 6, 7

PHDP2L	DW	0, 9,10,11,12,13,14,15
PHDP2H	DW	8, 1, 2, 3, 4, 5, 6, 7

PHDP3L	DW	0, 9,10,11,12,13,14,15
PHDP3H	DW	8, 1, 2, 3, 4, 5, 6, 7

PLT0L	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS0L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI0L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0064H

PLT0H	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS0H	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI0H	DW	0050H,0050H,0050H,0050H,0050H,0050H,0050H,0032H

PLT1L	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS1L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI1L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0064H

PLT1H	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS1H	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI1H	DW	0050H,0050H,0050H,0050H,0050H,0050H,0050H,0032H

PLT2L	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS2L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI2L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0064H

PLT2H	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS2H	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI2H	DW	0050H,0050H,0050H,0050H,0050H,0050H,0050H,0032H

PLT3L	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS3L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI3L	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0064H

PLT3H	DW	0000H,00F0H,0000H,012CH,0078H,00B4H,003CH,0000H
PCNS3H	DW	0000H,0064H,0064H,0064H,0064H,0064H,0064H,0000H
PBRI3H	DW	0050H,0050H,0050H,0050H,0050H,0050H,0050H,0032H

PALET	ENDS

	END

;* DEBUG *;INCLUDE	TSTSET.INC
;* DEBUG *;PUBLIC	DP
;* DEBUG *;CODE	SEGMENT	PUBLIC	'CODE'
;* DEBUG *;DP	PROC	NEAR
;* DEBUG *;	MOV	AX,SEG PALET
;* DEBUG *;	MOV	ES,AX
;* DEBUG *;	MOV	DI,OFFSET PLT0L
;* DEBUG *;
;* DEBUG *;	MOV	CX,16*3
;* DEBUG *;DP1:
;* DEBUG *;	MOV	DX,ES:[DI]
;* DEBUG *;	CALL	HEXSTR
;* DEBUG *;	CALL	PRINT
;* DEBUG *;	PR	" "
;* DEBUG *;	INC	DI
;* DEBUG *;	INC	DI
;* DEBUG *;	LOOP	DP1
;* DEBUG *;
;* DEBUG *;	RET
;* DEBUG *;DP	ENDP
;* DEBUG *;CODE	ENDS

;
;	end of "PLTTBL.ASM"
;
