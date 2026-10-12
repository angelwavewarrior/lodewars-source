/obj/item/useable/installation/rail/Plant()
	. = ..()
	icon = 'rail.dmi'
	icon_state = "line"
	layer = TURF_LAYER
	buyer = usr.tag
	Connect()

/obj/item/useable/installation/rail/proc/AddHub()
	var/obj/O
	O = new()
	O.icon = 'rail.dmi'
	O.icon_state = "hub"
	overlays.Add(O)
	dirs.Add(16)
	del(O)

/obj/item/useable/installation/rail/proc/AddDir(D)
	overlays.Add(icon('rail.dmi', "power", D))
	dirs.Add(D)
	for(var/Dir in dirs)
		if(Dir < 16)
			if(Dir != dir && Dir != turn(dir, 180) && !(16 in dirs))
				AddHub()

/obj/item/useable/installation/rail/proc/Connect()
	var/obj/item/useable/installation/rail/R
	var/T
	for(var/D in list(1, 2, 4, 8))
		T = get_step(loc, D)
		R = locate() in T
		if(R)
			if(!R.dirs)
				R.dir = turn(D, 180)
				R.dirs = list(turn(D, 180))
				R.icon_state = "power"
			else
				R.AddDir(turn(D, 180))
			if(!dirs)
				dir = D
				dirs = list(D)
				icon_state = "power"
			else
				AddDir(D)

/obj/item/useable/installation/bridge/Plant()
	. = ..()
	icon = 'bridge.dmi'
	layer = TURF_LAYER
	buyer = usr.tag
	loc.layer = TURF_LAYER
	Connect()

/obj/item/useable/installation/bridge/proc/AddDir(D)
	overlays.Add(icon('bridge.dmi', "bridge", D))
	dirs.Add(D)

/obj/item/useable/installation/bridge/proc/Connect()
	var/obj/item/useable/installation/bridge/R
	var/T
	for(var/D in list(1, 2, 4, 8))
		T = get_step(loc, D)
		R = locate() in T
		if(R)
			if(!R.dirs)
				R.dir = turn(D, 180)
				R.dirs = list(turn(D, 180))
			else
				R.AddDir(turn(D, 180))
		if(R || istype(T, /turf/dirt))
			if(!dirs)
				dir = D
				dirs = list(D)
			else
				AddDir(D)

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
	if(CanBoard(usr))
		Board(usr)

/obj/item/vehicle/proc/exit()
	set desc = "Exits a vehicle."
	set src in oview(0)
	var/mob/player/M
	var/turf/T
	M = usr
	T = GetTurf(src)
	if(usr == driver)
		if(istype(GetTurf(src), /turf/water) && !M.swim && !T.Bridged())
			for(var/D in list(1, 2, 4, 8))
				T = get_step(loc, D)
				if((!istype(T, /turf/water) || T.Bridged()) && CanReach(M, T))
					Unload(usr)
					break
		else
			Unload(usr)

/obj/item/vehicle/proc/deposit()
	set desc = "Deposits a load of ore into a vehicle container."
	set src in oview(1)
	if(!locate(/obj/item/ore) in usr)
		usr << "You have no ore to deposit!"
	else
		var/obj/item/ore/O = locate() in usr
		var/M = usr
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
				O.Move(usr.loc)
				O.loc = null
				del(O)
			O = locate() in usr
		M:Encumberance()

/obj/item/vehicle/proc/dump()
	set desc = "Empties a vehicle of its contents."
	set src in range(1)
	var/turf/base/bin/B
	var/list/ores
	var/mob/player/M
	B = locate() in range(1)
	ores = list()
	M = usr
	if(!istype(usr, /mob/player))
		return
	for(var/obj/item/ore/O in carried)
		carried.Remove(O)
		O.container = null
		O.loc = usr
		ores.Add(O)
	if(ores.len)
		if(B)
			if(B.team == usr.team)
				B.deposit()
		else
			for(var/D in list(1, 2, 4, 8, 5, 6, 9, 10))
				if(CanReach(usr, get_step(loc, D)))
					for(var/obj/item/ore/O in ores)
						O.loc = get_step(loc, D)
					break
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
	damage = weight + max(rand(1, 5), speed ** 2 - weight) + 1
	if(victim && victim.damageable)
		if(damage > 10) victim.TakeDamage(damage, 0.7, 0.7, driver, "vehicle")
	damage = max(rand(1, 5), speed ** 2 - weight)
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
	if(CanDrive(T, Dir) && drive_time <= world.time + 1)
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

/obj/item/vehicle/raft/CanDrive(turf/T as turf, Dir)
	return istype(T, /turf/water) && !T.Bridged()

/obj/item/vehicle/raft/Dropped()
	var/go
	go = 0
	if(CanDrive(loc))
		go = 1
	if(!go)
		for(var/D in list(1, 2, 4, 8))
			if(CanDrive(get_step(loc, D)))
				go = 1
	if(go)
		verbs.Add(/obj/item/vehicle/proc/board)
		verbs.Add(/obj/item/vehicle/proc/exit)
	density = 1

/obj/item/vehicle/raft/Move(A as mob|obj|turf|area)
	. = ..()
	loc = loc
	spawn(1)
		if(!isturf(loc))
			verbs.Remove(/obj/item/vehicle/proc/board)
			verbs.Remove(/obj/item/vehicle/proc/exit)

/obj/item/vehicle/raft/Die()
	if(driver)
		driver.vehicle = null
		loc.Entered(driver)
	. = ..()

/obj/item/vehicle/raft/DeadEnd()
	Crash(1)
	speed = 0

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
	set src in range(1)
	. = ..()
	if(driver)
		Unload(driver)

/obj/item/vehicle/cart/CanDrive(T as turf, Dir)
	var/obj/item/useable/installation/rail/O
	O = locate() in T
	if(O)
		return O.planted

/obj/item/vehicle/cart/DeadEnd()
	var/obj/item/useable/installation/rail/left
	var/obj/item/useable/installation/rail/right
	left = get_step(src, turn(dir, 90))
	right = get_step(src, turn(dir, -90))
	left = locate() in left
	right = locate() in right
	if(left && !left.planted) left = null
	if(right && !right.planted) left = null
	if(left && !right)
		dir = turn(dir, 90)
		if(speed == maxSpeed) speed--
		Drive(get_step(src, dir), dir)
	else if(!left && right)
		dir = turn(dir, -90)
		if(speed == maxSpeed) speed--
		Drive(get_step(src, dir), dir)
	else if(!left && !right)
		if(!carried.len && speed > 1)
			speed = 1
			dir = turn(dir, 180)
			Drive(get_step(src, dir), dir)
		else
			speed = 0
	else
		if(speed == maxSpeed) speed--

/obj/item/vehicle/drill/Die()
	if(head)
		head.main = null
		head.Die()
	if(rear)
		rear.main = null
		rear.Die()
	. = ..()

/obj/item/vehicle/drill/part/New(NewLoc, Dir, owner)
	. = ..()
	main = owner

/obj/item/vehicle/drill/part/Board(M as mob)
	if(main && main.CanBoard(M))
		main.Board(M)

/obj/item/vehicle/drill/part/Bump(O as mob|obj|turf|area)
	if(O != head && O != rear)
		. = ..()

/obj/item/vehicle/drill/part/Die()
	if(main)
		if(src == main.head)
			main.head = null
		else
			main.rear = null
		main.Die()
	. = ..()

/obj/item/vehicle/drill/part/head/Bump(O as mob|obj|turf|area)
	if(istype(O, /turf/dirt))
		var/T = O
		icon_state = "dig"
		spawn(round(T:solidness / 2) + 6)
			icon_state = "head"
			if(src && get_step(src, dir) == T)
				if(driver) driver.experience += driver.dexterity
				T:Dug()
	else if(O != main)
		. = ..()

/obj/item/vehicle/drill/Turn(Dir)
	var/Reverse
	var/T
	Reverse = turn(Dir, 180)
	T = get_step(src, Dir)
	if(dir == Dir)
		. = ..()
		Update()
	else
		if(CanDrive(T) && CanReach(src, T))
			T = get_step(src, Reverse)
			if(CanDrive(T) && CanReach(src, T))
				dir = Dir
				head.animate_movement = 0
				rear.animate_movement = 0
				Update()
				spawn(2)
					head.animate_movement = 3
					rear.animate_movement = 3
				. = ..()

/obj/item/vehicle/drill/Move(NewLoc, Dir)
	var/test
	var/turf/T
	test = head
	T = get_step(NewLoc, Dir)
	if(test)
		if(loc && isturf(loc))
			if(speed < 0)
				test = rear
				T = get_step(NewLoc, turn(Dir, 180))
			if(T.Bridged() && test:Move(T, Dir))
				. = ..()
				Update()
	else
		. = ..()

/obj/item/vehicle/drill/New(NewLoc, Dir, owner)
	. = ..()
	spawn(1)
		if(loc && !owner)
			dir = turn(loc.dir, -90)
			head = new/obj/item/vehicle/drill/part/head(loc, dir, src)
			rear = new/obj/item/vehicle/drill/part/rear(loc, dir, src)
			icon_state = "body"
			Dropped()
			Update()
			head.Dropped()
			rear.Dropped()

/obj/item/vehicle/drill/proc/Update()
	head.loc = loc
	rear.loc = loc
	head.icon_state = "head"
	head.dir = dir
	rear.dir = dir
	head.loc = get_step(src, dir)
	rear.loc = get_step(src, turn(dir, 180))
