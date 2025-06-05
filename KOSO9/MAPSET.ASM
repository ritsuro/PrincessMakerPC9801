; "MAPSET.ASM" R.H 1991/03/23 PC9801UV11
;
;	map set.
;

CNSBIGM1SIZE	EQU	120*100		; big map1 byte size.
CNSBIGM2SIZE	EQU	60*100		; big map2 byte size.

CODE	SEGMENT	PUBLIC	'CODE'

PUBLIC	BIGMAP					; map buffer.
PUBLIC	BIGMAP2					; map buffer2.

BIGMAP		LABEL	BYTE			; map buffer.
	INCLUDE	MMP.INC
BIGMAP2		LABEL	BYTE			; map buffer2.
	INCLUDE	MP2.INC
;*;	DB	CNSBIGM2SIZE DUP (1)

CODE	ENDS

	END
;
;	end of "MAPSET.ASM"
;
