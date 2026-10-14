/obj/item/vehicle/flathauler
	desc = "A heavy-duty freight vehicle, the flathauler is not the fastest or most maneuverable vehicle, but is sturdy and capable of carrying great loads of ore (as well as other teammates) easily."
	icon = 'flathauler.dmi'
	icon_state = "cab"
	var/obj/item/vehicle/flathauler/bed/bed
	maxSpeed = 3
	baseDelay = 12
	max_health = 100
	health = 100
	defense = 15
	value = 7000
	weight = 20
	top = 1

/obj/item/vehicle/flathauler/bed
	name = "flathauler"
	icon_state = "bed"
	animate_movement = 2
	var/obj/item/vehicle/cab
	debris = "bed debris"
	top = 0
	max_health = 70
	health = 70
	defense = 20
	weight = 15
	capacity = 35

/obj/item/vehicle/flathauler/DeadEnd()
	Crash(1)
	speed = 0

/obj/item/vehicle/flathauler/Board(M, stop=0)
	. = ..()
	if(!. && bed && !stop)
		bed.Board(M, 1)

/obj/item/vehicle/flathauler/New()
	. = ..()
	spawn(1)
		var/T = GetTurf(src)
		if(T && T:team && !istype(src, /obj/item/vehicle/flathauler/bed))
			dir = turn(T:dir, 90)
			T = T:team:sideZone
			bed = new/obj/item/vehicle/flathauler/bed(T)
			bed.Dropped()
			bed.cab = src
			bed.dir = turn(T:dir, 90)

/obj/item/vehicle/flathauler/Move()
	var/T
	var/D
	T = loc
	D = dir
	. = ..()
	if(.)
		if(bed)
			bed.density = 0
			bed.Move(T)
			bed.density = 1
			bed.dir = D

/obj/item/vehicle/flathauler/Die()
	var/atom/movable/B
	B = bed
	if(B)
		bed.cab = null
		bed = null
		B.Die()
	. = ..()

/obj/item/vehicle/flathauler/Go(Dir)
	if(Dir == get_dir(src, bed))
		if(!speed)
			return
		else if(Dir == turn(dir, 180))
			. = ..()
	else
		. = ..()

/obj/item/vehicle/flathauler/bed/Go()
	return

/obj/item/vehicle/flathauler/bed/Board(M, stop=0)
	. = ..()
	if(!. && cab && !stop)
		cab.board(M, 1)

/obj/item/vehicle/flathauler/bed/Die()
	if(cab)
		cab.Die()
	else
		. = ..()

/obj/item/vehicle/flathauler/bed/dump()
	set desc = "Empties a vehicle of its contents."
	set src in view(1)
	. = ..()
	if(driver)
		Unload(driver)
