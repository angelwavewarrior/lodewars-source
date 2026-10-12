/mob/Bump(O as mob|obj|turf|area)
	if(istype(src, /mob/player))
		var/mob/player/P = src
		/*if(mode != "attack" && istype(O, /turf/dirt) && (T.Bridged() || istype(src, /mob/player/bolo)))
			P.Dig(O)
		else*/
		if(mode == "attack")
			var/atom/M
			if(mode != "get" && istype(O, /obj/item/vehicle))
				var/V = O
				M = V:driver
				if(M && M.team != team)
					P:Attack(V)
			if(mode != "get" && istype(O, /mob))
				if(M.team != team)
					P:Attack(M)
		. = ..()

/turf/dirt/Cross(atom/movable/A)
	if(istype(A,/mob/player) && density)
		if(!A.density) return 1
		var/mob/player/player = A
		if(player.mode != "attack" && Bridged())
			player.Dig(src)
			return 0
	return 1
