; -------------------------------------------------------------------------
; Sonic CD Disassembly
; By Ralakimus 2021
; -------------------------------------------------------------------------
; Goddess statue object
; -------------------------------------------------------------------------
GoddessTime	EQU	objoff_2A
GoddessCount	EQU	objoff_2B
; -------------------------------------------------------------------------

ObjGoddessStatue:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	.Index(pc,d0.w),d0
	jsr	.Index(pc,d0.w)
	jmp	MarkObjGone
; -------------------------------------------------------------------------
.Index:
	dc.w	ObjGoddessStatue_Init-.Index
	dc.w	ObjGoddessStatue_Main-.Index
	dc.w	ObjGoddessStatue_SpitRings-.Index
	dc.w	ObjGoddessStatue_Done-.Index
; -------------------------------------------------------------------------

ObjGoddessStatue_Init:
	addq.b	#2,routine(a0)
	ori.b	#4,render_flags(a0)
	move.b	#50,GoddessCount(a0)
; -------------------------------------------------------------------------

ObjGoddessStatue_Main:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	addi.w	#16,d0
	bcs.s	.End
	cmpi.w	#32,d0
	bcc.s	.End

	move.w	(MainCharacter+y_pos).w,d0
	sub.w	y_pos(a0),d0
	addi.w	#32,d0
	bcs.s	.End
	cmpi.w	#64,d0
	bcc.s	.End

	addq.b	#2,routine(a0)

.End:
	rts
; -------------------------------------------------------------------------

ObjGoddessStatue_SpitRings:
	subq.b	#1,GoddessTime(a0)
	bpl.s	ObjGoddessStatue_Done
	move.b	#10,GoddessTime(a0)

	subq.b	#1,GoddessCount(a0)
	bpl.s	ObjGoddessStatue_SpawnRing
	addq.b	#2,routine(a0)

ObjGoddessStatue_Done:
	rts
; -------------------------------------------------------------------------

ObjGoddessStatue_SpawnRing:
	jsr	SingleObjLoad
	bne.s	.End

	_move.b	#ObjID_LostRings,id(a1)
	addq.b	#2,routine(a1)
	move.b	#8,y_radius(a1)
	move.b	#8,x_radius(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#24,x_pos(a1)
	subi.w	#16,y_pos(a1)
	move.l	#Obj25_MapUnc_12382,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a1)
	move.b	#3,priority(a1)
	move.b	#4,render_flags(a1)
	move.b	#$47,collision_flags(a1)
	move.b	#8,width_pixels(a1)
	move.b	#8,y_radius(a1)
	move.b	#-$1,(Ring_spill_anim_counter).w

	move.w	#-$200,y_vel(a1)
	jsr	(RandomNumber).l
	lsl.w	#1,d0
	andi.w	#$E,d0
	move.w	.XVels(pc,d0.w),x_vel(a1)

.End:
	rts
; -------------------------------------------------------------------------
.XVels:
	dc.w	-$100
	dc.w	-$80
	dc.w	0
	dc.w	$80
	dc.w	$100
	dc.w	$180
	dc.w	$200
	dc.w	$280
; -------------------------------------------------------------------------