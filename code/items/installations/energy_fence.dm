/obj/beam
	icon = 'barrier.dmi'
	var/owner

/obj/item/useable/installation/energy_fence
	desc = "Although fairly heavy, energy fence posts are designed for easy transportation and assembly. Simply set up a pair of energy fences in a line and they will generate a high-power energy pulse between themselves. The barrier energy fences create is specially attuned to team transmitter frequencies and will cause no harm to teammates who pass through the barrier, but enemies will recieve a very harmful jolt. Energy fences do have a self-sufficient power unit and require no external power supply, but be aware that they have a maximum range."
	icon_state = "energy fence"
	var/list/dirs = list()
	value = 850
	weight = 2
	delay = 12
	max_health = 60
	defense = 15
	isDamageable = 1

/obj/item/useable/installation/energy_fence/Plant()
	icon = 'barrier.dmi'
	icon_state = "base"
	overlays.Add(eFence)
	overlays.Add(icon('team_badge.dmi', team.name))
	..()

/obj/item/useable/installation/energy_fence/Use()
	set name = "use"
	set src in usr
	var/turf/OK
	OK = ..()
	if(OK)
		OK.Update()
		var/M = usr
		M:HUDUpdate("carry")

/obj/item/useable/installation/energy_fence/Botch(M as mob)
	var/obj/beam/B
	B = locate() in GetTurf(src)
	if(B)
		M << "Whoops!"
		B.Zap(M)

/obj/item/useable/installation/energy_fence/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty || !dirs.len)
		if(rand(1, M.intelligence + M.dexterity) > difficulty)
			Unplant()
			icon = initial(icon)
			icon_state = initial(icon_state)
			for(var/D in dirs)
				Kill(D)
			dirs.Cut()
			overlays.Cut()
			M << "Energy fence dismantled!"
		else
			M << "Energy fence destroyed!"
			Die()
	else
		for(var/D in dirs)
			Kill(D)
		dirs.Cut()
		M << "Energy fence depowered!"

/obj/item/useable/installation/energy_fence/Die()
	damageable = 0
	Explosion(loc, 10, 0, usr)
	for(var/D in dirs)
		Kill(D)
	dirs.Cut()
	. = ..()

/obj/item/useable/installation/energy_fence/proc/Energize(Dir, Target as turf)
	var/T
	var/obj/item/useable/installation/energy_fence/E
	var/obj/beam/B
	var/finished
	T = GetTurf(src)
	finished = 0
	dirs.Add(Dir)
	while(!finished)
		B = new(T)
		B.dir = Dir
		B.layer = 6
		B.owner = owner
		B.team = team
		if(T != loc)
			B.overlays.Add(image('barrier.dmi', null, team.name, 6, turn(Dir, 180)))
		E = locate() in T
		if(T == Target || E && E != src)
			E.dirs.Add(turn(Dir, 180))
			finished = 1
		else
			B.icon_state = team.name
		T = get_step(T, Dir)

/obj/item/useable/installation/energy_fence/proc/Kill(Dir, Target as turf)
	var/T
	var/obj/item/useable/installation/energy_fence/E
	var/obj/beam/B
	var/finished
	var/list/Beams
	T = GetTurf(src)
	finished = 0
	Beams = list()
	dirs.Remove(Dir)
	while(!finished)
		B = locate() in T
		Beams.Cut()
		while(B)
			if(B.dir == Dir || B.dir == turn(Dir, 180))
				del(B)
			if(B)
				Beams.Add(B)
				B = locate() in T:contents - Beams
			else
				B = locate() in T
		E = locate() in T
		if(E && (T == Target || E != src))
			E.dirs.Remove(turn(Dir, 180))
			finished = 1
		else if(T == Target)
			finished = 1
		T = get_step(T, Dir)

/obj/item/useable/installation/energy_fence/proc/Update()
	var/T
	var/obj/item/useable/installation/energy_fence/E
	var/obj/beam/B
	var/reach
	var/beam
	beam = 1
	if(!planted)
		return
	for(var/D in list(1, 2, 4, 8))
		reach = 0
		beam = (D in dirs)
		T = GetTurf(src)
		while(reach <= 6)
			T = get_step(T, D)
			if(T && T:density)
				beam = 0
				break
			B = locate() in T
			if(B)
				if(B.team != team)
					beam = 0
				else if(B.dir == D || B.dir == turn(D, 180))
					if(!(D in dirs)) beam = 0
			E = locate() in T
			if(E && E.planted)
				if(E.team == team)
					beam = 1
				else
					beam = 0
				break
			else
				reach++
		if(reach > 6) beam = 0
		if(!beam && (D in dirs))
			Kill(D, T)
		else if(beam && !(D in dirs))
			Energize(D, T)
	spawn(100) Update()

/obj/beam/proc/Zap(atom/movable/M as mob)
	range(5, src) << "[M.name] gets zapped!"
	M.TakeDamage(25, 0.7, 0.4, owner, "fence")
