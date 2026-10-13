/obj/item/vehicle/drill
	name = "power digger"
	desc = "A huge self-propelled drill capable of moving earth at a tremendous rate."
	icon = 'drill.dmi'
	icon_state = "head"
	var/obj/item/vehicle/drill/part/head/head
	var/obj/item/vehicle/drill/part/rear/rear
	maxSpeed = 2
	baseDelay = 11
	max_health = 80
	health = 80
	defense = 20
	value = 10000
	weight = 28
	boardable = 1
	reverse = 1

/obj/item/vehicle/drill/part
	animate_movement = 2
	var/obj/item/vehicle/drill/main

/obj/item/vehicle/drill/part/head
	debris = "head debris"

/obj/item/vehicle/drill/part/rear
	icon_state = "back"
	debris = "back debris"

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
				if(main && main.driver) main.driver.experience += main.driver.dexterity
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
