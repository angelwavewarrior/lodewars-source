/obj/item/equippable/weapon/riot_cannon/Fire(A as mob|obj|turf|area, spin=0)
	var/M
	var/mob/player/P
	P = usr
	if(P.act_delay <= world.time || M:icon_state == attackAnim || spin)
		if(spin > 2)
			if(world.cpu < 60)
				. = ..(A, spin)
			else if(spin % 2)
				power = 7
				. = ..(A, spin)
				power = 3
		if(spin < rand(5, 6))
			spawn(1) if(src && usr) Fire(A, spin + 1)

/obj/item/ammo/CalcWeight(Q=quantity)
	if(round(Q / amt) != Q / amt)
		return (round(Q / amt) + 1) * 0.5
	else
		return round(Q / amt) * 0.5

/obj/item/ammo/New()
	. = ..()
	quantity = amt
