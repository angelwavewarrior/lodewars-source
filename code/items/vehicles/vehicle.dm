/obj/item/vehicle
	density = 1
	var/mob/player/driver
	var/capacity
	var/list/carried = list()
	var/top = 0
	var/speed = 0
	var/maxSpeed = 0
	var/baseDelay = 11
	var/speedIncrement = 3
	var/debris = "debris"
	var/boardable = 1
	var/reverse = 0
	var/drive_time
	weight = 1
	damageable = 1

/obj/item/vehicle/Die(attacker as mob)
	damageable = 0
	Explosion(GetTurf(src), 20, 0, attacker, "vehicle")
	loc.overlays.Add(icon(icon, debris))
	if(driver)
		Unload(driver)
	if(capacity)
		for(var/obj/item/O in carried)
			O.container = null
	. = ..()

/obj/item/vehicle/Move(NewLoc, Dir)
	. = ..(NewLoc, Dir)
	if(driver)
		driver.loc = loc
		driver.dir = dir
		driver.icon_state = "still"
	if(capacity)
		for(var/obj/item/O in carried)
			O.loc = GetTurf(loc)
			if(O.loc != loc)
				carried.Remove(O)
				O.container = null

/obj/item/vehicle/New()
	if(top)
		AddTop()
	. = ..()

/obj/item/vehicle/Dropped()
	if(CanDrive(loc) || istype(loc, /turf/base/loadZone))
		verbs.Remove(/obj/item/verb/get)
		if(boardable)
			verbs.Add(/obj/item/vehicle/proc/board)
			verbs.Add(/obj/item/vehicle/proc/exit)
		if(capacity)
			verbs.Add(/obj/item/vehicle/proc/deposit)
			verbs.Add(/obj/item/vehicle/proc/dump)
	density = 1
	if(top) AddTop()

/obj/item/vehicle/Bump(O as mob|obj|turf|area)
	if(istype(O, /atom/movable))
		Crash(speed, O)
	else
		Crash(speed)

/obj/item/vehicle/proc/board()
	set desc = "Hop into a vehicle and begin driving."
	set src in oview(1)
	BoardBy(usr)

/obj/item/vehicle/proc/BoardBy(mob/player/M)
	if(CanBoard(M))
		Board(M)

/obj/item/vehicle/proc/exit()
	set desc = "Exits a vehicle."
	set src in oview(0)
	ExitBy(usr)

/obj/item/vehicle/proc/ExitBy(mob/player/M)
	var/turf/T
	T = GetTurf(src)
	if(M == driver)
		if(istype(GetTurf(src), /turf/water) && !M.swim && !T.Bridged())
			for(var/D in list(1, 2, 4, 8))
				T = get_step(loc, D)
				if((!istype(T, /turf/water) || T.Bridged()) && CanReach(M, T))
					Unload(M)
					break
		else
			Unload(M)

/obj/item/vehicle/proc/deposit()
	set desc = "Deposits a load of ore into a vehicle container."
	set src in oview(1)
	DepositBy(usr)

/obj/item/vehicle/proc/DepositBy(mob/player/M)
	if(!locate(/obj/item/ore) in M)
		M << "You have no ore to deposit!"
	else
		var/obj/item/ore/O = locate() in M
		var/obj/item/R
		while(O && carried.len < capacity)
			while(O.quantity > 0 && carried.len < capacity)
				R = new O.type(loc)
				R.value = O.value
				R.name = O.name
				R.icon = O.icon
				R.icon_state = O.icon_state
				R.invisibility = 0
				R.container = src
				carried.Add(R)
				O.quantity--
			if(!O.quantity)
				O.Move(M.loc)
				O.loc = null
				del(O)
			O = locate() in M
		M.Encumberance()

/obj/item/vehicle/proc/dump()
	set desc = "Empties a vehicle of its contents."
	set src in view(1)
	DumpBy(usr)

/obj/item/vehicle/proc/DumpBy(mob/player/M)
	var/turf/base/bin/B
	var/list/ores
	B = locate() in Around(M, 1)
	ores = list()
	if(!istype(M, /mob/player))
		return
	for(var/obj/item/ore/O in carried)
		carried.Remove(O)
		O.container = null
		O.loc = M
		ores.Add(O)
	if(ores.len)
		if(B && B.team == M.team)
			B.DepositBy(M)
		else
			var/turf/T = M.loc
			for(var/D in list(1, 2, 4, 8, 5, 6, 9, 10))
				if(CanReach(M, get_step(loc, D)))
					T = get_step(loc, D)
					break
			for(var/obj/item/ore/O in ores)
				O.loc = T
	M.HUDUpdate("carry")

/obj/item/vehicle/proc/AddTop()
	var/topType
	var/obj/O
	topType = "top"
	O = new()
	if(driver)
		topType = lowertext(driver.race)
	O.icon = icon(icon, topType)
	O.layer = 5
	overlays.Add(O)
	del(O)

/obj/item/vehicle/proc/CanBoard(mob/player/M as mob)
	if(istype(M, /mob/player) && isturf(loc) && M.size == 1 && !driver && !M.vehicle)
		. = 1
	else
		. = 0

/obj/item/vehicle/proc/DeadEnd()
	if(speed > 1)
		Move(get_step(src, turn(dir, 180)))
	Crash(1)
	speed = 0

/obj/item/vehicle/proc/Crash(S=speed, atom/movable/victim as mob|obj)
	var/damage
	damage = weight + max(rand(1, 5), S ** 2 - weight) + 1
	if(victim && victim.damageable)
		if(damage > 10) victim.TakeDamage(damage, 0.7, 0.7, driver, "vehicle")
	damage = max(rand(1, 5), S ** 2 - weight)
	if(damageable)
		if(damage > 5) TakeDamage(damage, 0.7, 0.7, driver, "vehicle")
	if(driver)
		damage -= weight
		if(damage > 5) driver.TakeDamage(damage, 0.7, 0.7, driver, "vehicle")
	speed = max(0, speed - 2)

/obj/item/vehicle/proc/Board(mob/M as mob)
	driver = M
	M.vehicle = src
	M.animate_movement = 3
	M.icon_state = "still"
	M.loc = loc
	M.dir = dir
	team = M.team
	overlays.Cut()
	if(top) AddTop()
	return 1

/obj/item/vehicle/proc/Unload(mob/M as mob)
	var/dirs
	dirs = list(turn(dir, 90), turn(dir, -90))
	driver = null
	M.vehicle = null
	M.animate_movement = 1
	M.icon_state = "run"
	team = null
	if(CanReach(M, get_step(loc, dirs[1])))
		M.Move(get_step(loc, dirs[1]))
	else if(CanReach(M, get_step(loc, dirs[2])))
		M.Move(get_step(loc, dirs[2]))
	else if(health < 0 || speed > 0)
		M.Move(loc)
	return 1

/obj/item/vehicle/proc/Drive(T as turf, Dir)
	// Too early: another drive loop is already running. Let that one carry on.
	if(drive_time > world.time + 1)
		return
	if(CanDrive(T, Dir))
		Move(T, Dir)
		if(speed)
			drive_time = world.time + baseDelay - abs(speed) * speedIncrement
			spawn(baseDelay - abs(speed) * speedIncrement)
				if(speed > 0)
					Drive(get_step(src, dir), dir)
				else if(speed < 0)
					Drive(get_step(src, turn(dir, 180)), dir)
	else
		DeadEnd()

/obj/item/vehicle/proc/CanDrive(turf/T as turf, Dir)
	if(istype(T, /turf/base/loadZone))
		return 1
	else
		return T && !T.density && !istype(T, /turf/base/door) && (!istype(T, /turf/water) || T.Bridged())

/obj/item/vehicle/proc/Turn(Dir)
	if(Dir && CanDrive(get_step(src, Dir), Dir))
		dir = Dir
		if(!speed)
			speed = 1
			spawn(baseDelay - speed * speedIncrement) Drive(get_step(src, Dir), Dir)

/obj/item/vehicle/proc/Go(Dir)
	if(Dir >= 5 && Dir != 8)
		return
	if(driver && driver.act_delay <= world.time)
		driver.act_delay = world.time + 7 - driver.dexterity / 4
		if(speed)
			if(Dir == dir)
				speed = min(maxSpeed, speed + 1)
			else if(speed > 0 && (Dir == turn(dir, 180) || !Dir))
				speed = max(0, round(speed * 0.75, 1) - 1)
			else if(Dir == turn(dir, 90) || Dir == turn(dir, 270))
				Turn(Dir)
				if(speed > 2) speed--
		else
			if(Dir == turn(dir, 180) && reverse)
				speed = -1
				spawn(baseDelay - speedIncrement) Drive(get_step(src, Dir), dir)
			else
				Turn(Dir)
