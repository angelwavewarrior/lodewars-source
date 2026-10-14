/area

/atom
	var/radioactivity = 0
	var/team/team
	var/signal
	var/energy
	var/max_energy

/datum
	var/name

/obj
	var/planted = 0

/atom/movable
	var/damageable = 0
	var/defense
	var/energy_defense
	var/health
	var/max_health

/atom/movable/Bump(atom/O as mob|obj|turf|area)
	O.Bumped(src)

/atom/movable/proc/Teleport(destination as turf)
	var/I
	var/M
	var/mob/P
	I = image('FX.dmi', GetTurf(loc), "teleport", 6)
	M = image('FX.dmi', src, "teleport", 6)
	P = src
	flick("teleport", I)
	flick("teleport", M)
	players << I
	players << M
	. = Move(destination)
	if(istype(P, /mob/player))
		if(P.vehicle)
			P.vehicle.driver = null
			P.vehicle = null
	spawn(10)
		del(I)
		del(M)

/atom/proc/Bumped(O as mob|obj)
	. = 0

/atom/Click()
	var/mob/player/M
	var/turf/T
	M = usr
	T = GetTurf(src)
	if(loc)
		if(istype(M, /mob/player))
			var/obj/item/O = locate() in T
			var/mob/P = locate() in T
			if(O && O.planted)
				O = locate() in T.contents - O
			if(O && M.mode == "get" && M.CanGet(O))
				O.get()
			else if(P && M.mode == "attack" && P != M && TileDist(P, M) <= 1)
				P:attack()
			else if(M.activeItem)
				if(istype(M.activeItem, /obj/item/equippable/weapon))
					var/W = M.activeItem
					W:Fire(GetTurf(src))
				else if(istype(M.activeItem, /obj/item/useable))
					var/U = M.activeItem
					U:UseBy(M, src)
			else
				var/obj/item/useable/installation/I = locate() in T:contents
				var/obj/item/vehicle/V = locate() in T:contents
				if(I && I.planted)
					if(M.mode == "default" && TileDist(I, M) <= 1)
						I.UsedBy(M)
					else if(M.mode == "attack" && I.team != M.team && TileDist(I, M) <= 1)
						M.Attack(I)
				if(V)
					if(V.driver)
						if(M.mode == "attack" && V.driver.team != M.team && TileDist(V, M) <= 1)
							M.Attack(V)
					else
						if(M.mode == "default" && TileDist(V, M) <= 1)
							V.board()
