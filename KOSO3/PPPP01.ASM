;"PPPP01.ASM" 1991/03/11
;
;voidvoidvoid
;
;
;voidvoidvoid
;	ＥＸＥ形式リロケータブル可能にしました。
;
;	バッファを２重にして、リロケート時の
;	ＤＭＡバウンダリを回避します。
;
;	これは、ハードディスク用のキーディスク
;	に対応させるためのものです。
;
;
; modifay  r.hashimoto

INCLUDE	TSTSET.INC

EXTRN	INT_FDISK_BIOS:FAR	; (far) disk/FD bios.

INT_FD_BIOS	MACRO		; disk/FD bios.
;same;	INT	1BH		; disk bios.
	CALL	INT_FDISK_BIOS	; (far) FD bios.
	ENDM

;voidvoidvoid
;voidvoidvoid

SCCCODE	SEGMENT	PUBLIC	'SCCCODE'

	ASSUME	CS:SCCCODE,DS:DATA

;voidvoidvoid


;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

;voidvoidvoid

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

;voidvoidvoid

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

SCCCODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SEGDOS:WORD			; ＤＯＳインターフェースセグメント

;voidvoidvoid
;voidvoidvoid

DATA	ENDS
	END
;
;	end of "PPPP01.ASM"
;
