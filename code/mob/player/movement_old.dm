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
			I:AddBuyers(O.Buyers())
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
	if(shopping)
		shopping = 0
		DeShop()
	. = ..()
