
	
instruct:
		db	0x99+' ',0x9A+' '," Avoid barriers and other",13
		db	0x9B+' ',0x9C+' '," tall obstacles",13
		db	0x9D+' ',0x9E+' ',13
		db	0x84+' ',0x86+' '," Press up/down + X to spin",13
		db	0x85+' ',0x87+' '," and pass between barriers",13
		db	0x80+' ',0x82+' '," Use looping to avoid",13
		db	0x81+' ',0x83+' '," enemy bullets",13
		db	0x88+' ',0x89+' ',0x88+' ',13
		db	0x8B+' ',0x8C+' ',0x8B+' '," Destroy ground targets",13
		db	0x8D+' ',0x8E+' ',0x8F+' '," to weaken Dreadnought's",13	
		db	0x90+' ',0x91+' ',0x92+' '," defense",13	
		db	0x88+' ',0x93+' ',0x94+' ',13
		db	0x88+' ',0x95+' ',0x96+' ',13
		db	"Land on the main runway of",13	
		db	"each Dreadnought and activate",13
		db	"its self destruction system",13	
		
		
show_instructions:
	call cls
	call _color_set
	call _destr_set
	
	ld  de,instruct
	ld	hl,0x1800+32*1+2
	call	prstr
	ld	hl,0x1800+32*2+2
	call	prstr
	ld	hl,0x1800+32*3+2
	call	prstr
	
	ld	hl,0x1800+32*5+2
	call	prstr
	ld	hl,0x1800+32*6+2
	call	prstr

	ld	hl,0x1800+32*8+2
	call	prstr
	ld	hl,0x1800+32*9+2
	call	prstr
	
	ld	hl,0x1800+32*11+2
	call	prstr
	ld	hl,0x1800+32*12+2
	call	prstr
	ld	hl,0x1800+32*13+2
	call	prstr
	ld	hl,0x1800+32*14+2
	call	prstr
	ld	hl,0x1800+32*15+2
	call	prstr
	ld	hl,0x1800+32*16+2
	call	prstr

	ld	hl,0x1800+32*18+2
	call	prstr
	ld	hl,0x1800+32*19+2
	call	prstr
	ld	hl,0x1800+32*20+2
	call	prstr
		
	ld	de,0x1800+32*22+8
	call	setwrtvram
	ld	bc,0x1098
1:	ld	hl,runway_map
	outi
	nop
	nop
	outi
	jr nz,1b
	ld	hl,runway_map
	outi
	
	ld	de,0x1800+32*23+8
	call	setwrtvram
	ld	bc,0x1098
1:	ld	hl,runway_map+2
	outi
	nop
	nop
	outi
	jr nz,1b
	ld	hl,runway_map+2
	outi
		
	ei
	
3:
	xor	a
	ld	(aniframe),a
	
2:	halt	
	call plot_spt_char_anim
	ld b,10
1:	halt
	djnz 1b
	
	ld	a,(aniframe)
	inc	a
	ld	(aniframe),a
	cp 32
	jr z,3b
		
	call	joy_read
	and	0x13		; up/down/fire
	jp	nz,return
	
	jr 2b
	
	
plot_spt_char_anim:
	setvdpwvram 0x0400
	ld	a,(aniframe)
	and 7
	call	1f
	setvdpwvram 0x0C00
	ld	a,(aniframe)
	and 7
	call	1f
	; setvdpwvram 0x1400
	; ld	a,(aniframe)
	; and 7
	; call	1f
	
	setvdpwvram 0x0420
	ld	a,(aniframe)
	and 15
	add	a,32
	call	1f
	setvdpwvram 0x0C20
	ld	a,(aniframe)
	and 15
	add	a,32
	; call	1f
	; setvdpwvram 0x1420
	; ld	a,(aniframe)
	; and 15
	; add	a,32
	; call	1f
	; ret
	
1:	ld	hl,ms_ani
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	l,(hl)
	ld	h,b
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld	e,l
	ld	d,h
	add	hl,hl
	add	hl,de
	ld	de,ms_spt
	add hl,de
	ld	bc,0x2098
1:	outi
	jr nz,1b
	ret

; set colours
_color_set
	setvdpwvram (0x2000+128*8)
	call 1f
	setvdpwvram (0x2800+128*8)
	call 1f
	setvdpwvram (0x3000+128*8)
1:	ld	b,8*8
1:	ld	a,0xF1
	out	(0x98),a
	djnz	1b
	ret

_destr_set:
	halt
	setvdpwvram (0x0000+136*8)
	call 2f
	setvdpwvram (0x0800+136*8)
	call 2f
	setvdpwvram (0x1000+136*8)
	call 2f
	
	setvdpwvram (0x2000+136*8)
	call 1f
	setvdpwvram (0x2800+136*8)
	call 1f
	setvdpwvram (0x3000+136*8)
1:
	ld	hl,destruct_colors
	ld	bc,23*8*256+0x98
11:	outi
	jr	nz,11b
	ret
2:
	ld	hl,destruct_tiles
	ld	bc,23*8*256+0x98
11:	outi
	jr	nz,11b
	ret
	
	
destruct_tiles:
	incbin	destr_shape.bin
runway_shape:
	db 0x00,0x00,0x00,0x00,0x00,0xC0,0x07,0x01
	db 0x01,0x07,0xC0,0x00,0x00,0x00,0x00,0xFF 
barrier_shape:
	db	0x80,0x40,0x40,0x40,0x40,0x40,0x40,0x40    ;
	db	0x01,0x02,0x02,0x02,0x02,0x02,0x02,0x02    ;
	db	0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40    ;
	db	0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02    ;
	db	0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x80    ;
	db	0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x01    ;

destruct_colors:
	incbin	destr_col.bin
runway_col:   
	db 0x55,0x44,0x44,0x44,0x44,0xA4,0x4A,0x4A
	db 0x4A,0x4A,0xA4,0x44,0x44,0x44,0x44,0x11 
barrier_col:
	db 0x4C,0xC4,0x4C,0x4C,0x4C,0x4C,0x4C,0x4C    
	db 0x1C,0xC1,0x1C,0x1C,0x1C,0x1C,0x1C,0x1C    
	db 0x4C,0x4C,0x4C,0x4C,0x4C,0x4C,0x4C,0x4C    
	db 0x1C,0x1C,0x1C,0x1C,0x1C,0x1C,0x1C,0x1C    
	db 0x4C,0x4C,0x4C,0x4C,0x4C,0x4C,0xC4,0x4C    
	db 0x1C,0x1C,0x1C,0x1C,0x1C,0x1C,0xC1,0x1C    

	
; destruct_map
	; db 0x00,0x01,0x00
	; db 0x03,0x04,0x03
	; db 0x05,0x06,0x07
	; db 0x08,0x09,0x0A
	; db 0x00,0x0B,0x0C
	; db 0x00,0x0D,0x0E
runway_map:
	db	0x8D,0x97
	db	0x90,0x98
	