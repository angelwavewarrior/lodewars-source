world/fps = 20

client/fps = 60

mob/glide_size = 16

/mob/player/Entered(obj/item/O as obj)
	if(istype(O, /obj/item))
		var/tempInv = inventory.Copy()
		var/I = locate(O.type) in tempInv
		while(O.stackable && I && I:quantity + O.quantity >= 100)
			tempInv:Remove(I)
			I = locate(O.type) in tempInv
		if(!O.owner) O.owner = src
		if(!O.team) O.team = src
		if(O.stackable && I)
			encumberance += O.CalcWeight()
			radioactivity += O.radioactivity * O.quantity
			I:quantity += O.quantity
			I:UpdateQuantity()
			O.loc = null
			// Deferred: deleting O now would end the Move or get proc still running on it.
			spawn() del(O)
		else
			encumberance += O.CalcWeight()
			radioactivity += O.radioactivity * O.quantity
			inventory.Add(O)
			O.DisplayWeight()
			O.layer = 14.5
			if(O.ammo)
				O.UpdateQuantity()
			HUDInventory()
		HUDUpdate("carry")

/mob/player/Exited(obj/item/O as obj)
	if(istype(O, /obj/item))
		var/E = O
		if(istype(E, /obj/item/equippable) && E:equipped)
			E:DoUnequip(src)
		encumberance -= O.weight * O.quantity
		radioactivity -= O.radioactivity * O.quantity
		inventory.Remove(O)
		O.layer = OBJ_LAYER
		if(client)
			if(O in client.screen)
				client.screen.Remove(O)
			SortInv()
			HUDInventory()
		if(activeItem == O)
			activeItem = null
		O.overlays.Cut()
		HUDUpdate("carry")

/mob/player/Move()
	//var/waterLogged
	//var/water
	//waterLogged = 0
	//water = 0
	if(shopping)
		shopping = 0
		DeShop()
	. = ..()
	/*if(act_delay < world.time)
		. = ..()
		if(.)
			var/moveSpeed = speed
			var/T = loc
			if(istype(loc, /turf/water) && !vehicle && !T:Bridged())
				if(istype(src, /mob/player/bolo))
					moveSpeed -= 3
				else
					moveSpeed += swim
					water = 1
					if(swim < 0)
						waterLogged = 2
			if(speed != CalcStat("speed"))
				moveSpeed = 0
			speed_accum = speed_accum + (sqrt(moveSpeed) - round(sqrt(moveSpeed)))
			act_delay = world.time + 8 - round(sqrt(moveSpeed)) + waterLogged
			if(speed_accum >= 1)
				speed_accum--
				act_delay--
			if(vehicle)
				icon_state = "still"
			else if(water && density)
				if(icon_state != "swim") spawn(4) icon_state = "swim"
			else if(icon_state != "run")
				spawn(2) icon_state = "run"
		else
			return 0*/
