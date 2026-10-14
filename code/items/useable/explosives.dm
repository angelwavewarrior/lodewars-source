/obj/item/useable/explosive
	var/power
	var/radius
	var/mob/player/user

/obj/item/useable/explosive/blast_pack
	desc = "A heavy-duty explosive device with a four-second fuse. Plant one of these and get out of the way!"
	icon_state = "blast pack"
	var/fuse = 40
	weight = 1
	value = 300
	power = 65
	radius = 4
	delay = 9

/obj/item/useable/explosive/grenade
	desc = "A simple and highly portable explosive device, grenades are highly useful weapons, capable of being carried easily and delivering damage at a distance."
	icon_state = "grenade"
	range = 6
	radius = 2
	power = 45
	delay = 4
	weight = 0.5
	value = 60

/obj/item/useable/explosive/micro_charge
	name = "micro-charge"
	desc = "Micro-charges are small, remotely detonated explosives designed for precision demolition, with a small but powerful and tightly focused blast capable of doing considerable damage."
	icon_state = "micro-charge"
	weight = 0.5
	value = 75
	power = 55
	radius = 2
	delay = 5
	range = 1

/obj/item/useable/explosive/proc/Detonate()
	if(user) power += user.intelligence
	Explosion(GetTurf(src), power, radius, user)
	loc = null
	spawn(10) del(src)

/obj/item/useable/explosive/micro_charge/Click()
	var/M
	M = usr
	if(loc && M == user)
		Detonate()
	else
		. = ..()

/obj/item/useable/explosive/micro_charge/UseBy(mob/player/M, A)
	var/T
	T = GetTurf(A)
	if(istype(T, /turf/dirt) && ..(M, A))
		var/obj/item/useable/explosive/micro_charge/C = new(GetTurf(A))
		C.user = M
		C.Plant()
		Discard(M)

/obj/item/useable/explosive/blast_pack/UseBy(mob/player/M, A)
	if((CanReach(M, A) || A:density) && ..(M, A))
		if(quantity == 1)
			M.activeItem = null
			Move(GetTurf(A))
			user = M
			Plant()
			Arm()
		else
			var/obj/item/useable/explosive/blast_pack/P = new(GetTurf(A))
			P.user = M
			P.Plant()
			P.Arm()
			TakeBuyerCounts(1)
			quantity--
			UpdateQuantity()
			M.HUDUpdate("carry")
		fuse = initial(fuse)

/obj/item/useable/explosive/blast_pack/proc/Arm()
	spawn(fuse) Detonate()

/obj/item/useable/explosive/grenade/UseBy(mob/player/M, A)
	var/T
	var/range
	T = GetTurf(src)
	range = ((A:x - T:x) ** 2 + (A:y - T:y) ** 2) ** 0.5
	if(..(M, A))
		var/obj/bullet/rocket/grenade/G = new(GetTurf(src))
		G.GetHeading(range, GetTurf(src), GetTurf(A))
		G.owner = M
		G.team = M.team
		G.power = power
		G.Fly()
		Discard(M)
