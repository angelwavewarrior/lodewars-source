/obj/item/equippable
	var/slots
	var/adds
	var/equipped = 0
	var/digAnim
	var/attackAnim
	var/bannedRaces
	stackable = 0

/obj/item/equippable/Click()
	var/M
	M = usr
	if(M && istype(M, /mob/player) && (src in usr))
		if(equipped)
			unequip()
		else
			equip()
	else
		..()

/obj/item/equippable/verb/equip()
	set src in usr
	if(DoEquip(usr))
		usr << "You equip \the [name]."
		. = 1

/obj/item/equippable/verb/unequip()
	set src in usr
	return UnequipBy(usr)

/obj/item/equippable/proc/UnequipBy(mob/player/M)
	if(DoUnequip(M))
		M << "You unequip \the [name]."
		. = 1

/obj/item/equippable/proc/DoEquip(mob/player/M as mob)
	if(bannedRaces && (M.type in bannedRaces))
		M << "You can't equip that!"
		return 0
	else
		var/obj/item/equippable/E
		for(var/S in slots)
			if(S)
				E = M.equipment[S]
				if(E && (E == src || !E.UnequipBy(M)))
					return
		if("held" in slots)
			if(M.activeItem)
				M.activeItem.DeselectFor(M)
		M.act_delay += 35 - M.dexterity - M.speed
		suffix = "(equipped)"
		equipped = 1
		if(istype(src, /obj/item/equippable/weapon))
			M.activeItem = src
		M.HUDInventory()
		if(!M.oldHUDMode)
			Highlight()
		for(var/S in slots)
			if(S)
				M.equipment[S] = src
		for(var/A in adds)
			if(A && (A in M.vars))
				M.vars[A] += adds[A]
				if(A in HUDCoords)
					if(M in list("health", "energy", "radiation"))
						M.HUDBar(A)
					else
						M.HUDUpdate(A)
		if(istype(src, /obj/item/equippable/weapon) && M.oldHUDMode)
			suffix = "(equipped) [ammo] ammo"
		. = 1

/obj/item/equippable/proc/DoUnequip(mob/player/M as mob)
	if(!equipped)
		return
	else
		for(var/S in slots)
			if(M.equipment[S] == src)
				M.equipment.Remove(S)
		M.act_delay += 40 - M.dexterity - M.speed
		suffix = ""
		equipped = 0
		if(M.activeItem == src && M.client && map)
			M.activeItem = null
			M.HUDInventory()
		for(var/A in adds)
			if(A && (A in M.vars))
				M.vars[A] -= adds[A]
				if((A in HUDCoords) && M.client && map)
					M.HUDUpdate(A)
		overlays.Remove(highlight)
		var/obj/item/O = highlight
		highlight = null
		del(O)
		if(istype(src, /obj/item/equippable/weapon) && M.oldHUDMode)
			suffix = "[ammo] ammo"
		. = 1
		if(("carry" in adds) && M.health > 0)
			var/lowVal
			while(M.encumberance > M.carry)
				lowVal = 100000
				var/obj/item/I
				for(O in M.inventory)
					if(O.value && O.weight && O.value / O.weight < lowVal && O != src)
						lowVal = O.value / O.weight
						I = O
				if(!I || !I.DropFrom(M))
					break
		else if("swim" in adds)
			M.Move(M.loc)
