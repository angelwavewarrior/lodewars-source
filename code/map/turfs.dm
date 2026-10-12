/turf
	var/solidness = 0
	var/damage = 0

/turf/dirt
	icon = 'dirt.dmi'
	icon_state = "15"
	opacity = 1
	density = 1

/turf/rock
	icon = 'rock.dmi'
	icon_state = "15"
	opacity = 1
	density = 1

/turf/water
	icon = 'water.dmi'
	icon_state = "deep"

/turf/dirt/open
	icon_state = null
	opacity = 0
	density = 0

/turf/proc/Update()

/turf/proc/Clear()

/turf/proc/Bridged()
	var/obj/item/useable/installation/bridge/O
	O = locate() in src
	if(!istype(src, /turf/water) || O && O.planted)
		. = 1
	else
		. = 0

/turf/proc/Initialize()
	if(map) radioactivity = map.bgRadiation
	for(var/atom/movable/A in contents)
		del(A)
	overlays.Cut()

/turf/proc/OrePing(mob/M as mob)
	var/I
	I = image('FX.dmi', src, "ore ping", 6)
	M << I
	spawn(70) if(M && M.client) M.client.images.Remove(I)

/turf/water/New()
	Initialize()
	radioactivity /= 2

/turf/water/Enter(mob/player/M as mob)
	if(!istype(M, /mob/player))
		. = ..()
	else
		if(M.swim || M.vehicle || Bridged() || !M.density)
			. = ..()
		else
			. = 0

/turf/water/Entered(O as obj)
	var/mob/player/M
	var/obj/beam/B
	M = O
	B = locate() in src
	if(!Bridged())
		if(istype(M, /mob/player))
			if(!M.swim && !M.vehicle && M.density)
				M.Die(null, "water", 0)
		if(locate(/obj/item) in src)
			if(!("submerged" in overlays))
				overlays.Add("submerged")
		if(istype(O, /obj/item))
			O:invisibility = 0
			if(!istype(O, /obj/item/vehicle/raft))
				O:layer = AREA_LAYER
			if(/obj/item/verb/help in O:verbs)
				O:verbs:Remove(/obj/item/verb/help)
	if(B && istype(M, /mob/player))
		if(M.team != B.team)
			B.Zap(M)

/turf/water/Exited(O as obj)
	if(!locate(/obj/item) in src)
		Update()
	if(istype(O, /obj/item))
		O:layer = OBJ_LAYER
		if(!(/obj/item/verb/help in O:verbs))
			O:verbs:Add(/obj/item/verb/help)

/turf/water/Update()
	var/T
	var/dirs
	dirs = 0
	overlays.Cut()
	for(var/D in list(1, 2, 4, 8))
		T = get_step(src, D)
		if(istype(T, /turf/water))
			dirs += D
	if(dirs < 15)
		overlays.Add(num2text(dirs))
	if(locate(/obj/item) in src)
		overlays.Add("submerged")
	for(var/obj/item/ore/O in src)
		if(O) O.invisibility = 0

/turf/dirt/open/New()
	Initialize()

/turf/dirt/Entered(atom/O as mob|obj)
	if(O.radioactivity && radioactivity <= map.bgRadiation + 3)
		radioactivity += 2
	if(istype(O, /obj/item))
	else
		if(istype(O, /mob/player))
			var/M = GetMob(O)
			var/obj/beam/B = locate() in src
			var/obj/item/useable/installation/rail/R = locate() in src
			if(M && B)
				if(M:team != B.team)
					B.Zap(M)
			if(R && R.icon_state == "power")
				M << "Zap! The electrified rail shocks you."
				M:TakeDamage(4, 0.6, 0.1, null, "rail")

/turf/dirt/Update()
	var/dirs
	var/water
	dirs = 0
	water = 0
	solidness = 0
	if(density)
		var/T
		for(var/D in list(1, 2, 4, 8))
			T = get_step(src, D)
			if(T && T:density)
				dirs += D
				solidness += 2
			if(istype(T, /turf/water))
				water += D
		for(var/D in list(5, 6, 9, 10))
			T = get_step(src, D)
			if(T && T:density)
				solidness += 1
		solidness = max(-5, solidness - damage)
		icon_state = num2text(dirs)
	else
		icon_state = 0
	for(var/obj/item/useable/planted/P in src)
		P.Update()
	if(dirs < 15)
		for(var/obj/item/ore/O in src)
			if(O) O.invisibility = 0

/turf/rock/Update()
	var/T
	var/dirs
	dirs = 0
	for(var/D in list(1, 2, 4, 8))
		T = get_step(src, D)
		if(T && (istype(T, /turf/dirt) || !T:density))
			dirs = D
			if(T:density)
				icon = 'rock.dmi'
			else
				icon = 'rock2.dmi'
	icon_state = num2text(15 - dirs)
