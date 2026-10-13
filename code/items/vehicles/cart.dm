/obj/item/vehicle/cart
	name = "monocart"
	desc = "A fast, sturdy means of transportation, monocarts require the use of pre-laid tracks but are reliable, effective, and inexpensive."
	icon = 'cart.dmi'
	icon_state = "drive"
	maxSpeed = 3
	max_health = 80
	health = 80
	defense = 18
	value = 2000
	weight = 12
	capacity = 25

/obj/item/vehicle/cart/CanDrive(T as turf, Dir)
	var/obj/item/useable/installation/rail/O
	O = LocatePlanted(T, /obj/item/useable/installation/rail)
	if(O)
		return O.planted

/obj/item/vehicle/cart/DeadEnd()
	var/obj/item/useable/installation/rail/left
	var/obj/item/useable/installation/rail/right
	left = get_step(src, turn(dir, 90))
	right = get_step(src, turn(dir, -90))
	left = LocatePlanted(left, /obj/item/useable/installation/rail)
	right = LocatePlanted(right, /obj/item/useable/installation/rail)
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
		// A junction: stop, so the driver's next turn starts the cart.
		speed = 0
