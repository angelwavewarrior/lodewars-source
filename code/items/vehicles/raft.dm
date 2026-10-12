/obj/item/vehicle/raft
	name = "power raft"
	desc = "A lightweight, speedy form of water transportation, the power raft is designed to be both portable and powerful. It glides across water with ease and can be carried if necessary, but isn't particularly durable."
	icon = 'boat.dmi'
	icon_state = "drive"
	maxSpeed = 3
	baseDelay = 12
	max_health = 40
	health = 40
	defense = 11
	top = 0
	value = 1000
	weight = 5

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
