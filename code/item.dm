/obj/item/equippable/weapon/proc/LoadAmmo()
	var/obj/item/ammo/O
	var/mob/player/M
	O = locate(ammoType) in usr
	M = usr
	if(O && !ammo)
		ammo += min(O.amt, O.quantity)
		if(O.quantity <= O.amt)
			M.inventory.Remove(O)
			M.client.screen.Remove(O)
			M.encumberance -= O.CalcWeight(1)
			O.loc = null
			del(O)
		else
			O.quantity -= O.amt
			O.UpdateQuantity()
		UpdateQuantity()
		M.HUDInventory()

/obj/item/equippable/weapon/CalcWeight(Q=ammo)
	if(src && ammoType)
		var/A = new ammoType
		var/w = weight + round(ammo / A:amt) * 0.5
		del(A)
		return w
	else
		return weight

/obj/item/equippable/weapon/verb/load()
	set src in usr.client.screen
	if(ammoType)
		LoadAmmo()
	else
		usr << "Energy weapons need no ammo!"

/obj/item/equippable/weapon/verb/unload()
	set src in usr.client.screen
	if(ammo && ammoType)
		var/O = new ammoType(usr.loc)
		O:quantity = ammo
		ammo = 0
		UpdateQuantity()
		O:Move(usr)
		if(O) O:UpdateQuantity()

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
	if(DoUnequip(usr))
		usr << "You unequip \the [name]."
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
				if(E && (E == src || !E.unequip()))
					return
		if("held" in slots)
			if(M.activeItem)
				M.activeItem.deselect()
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
		if("carry" in adds && M.health > 0)
			var/lowVal
			while(M.encumberance > M.carry)
				lowVal = 100000
				var/obj/item/I
				for(O in M.inventory)
					if(O.value && O.weight && O.value / O.weight < lowVal && O != src)
						lowVal = O.value / O.weight
						I = O
				I.drop()
		else if("swim" in adds)
			M.Move(M.loc)

/obj/item/useable/New()
	. = ..()

/obj/item/useable/Click()
	var/mob/player/M
	M = usr
	if(M && istype(M, /mob/player) && (src in usr))
		if(M.activeItem == src)
			deselect()
		else
			select()
	else
		..()

/obj/item/useable/verb/select()
	set src in usr
	var/mob/player/M
	M = usr
	if(M.activeItem)
		var/O = M.activeItem
		if(istype(O, /obj/item/equippable))
			O:unequip()
		else
			M.activeItem.deselect()
	M.activeItem = src
	M << "Selected [name]. Click on a valid target to use."
	verbs.Add(/obj/item/useable/proc/Use)
	verbs.Remove(/obj/item/verb/drop)
	M.HUDInventory()

/obj/item/useable/verb/deselect()
	set src in usr
	var/mob/player/M
	M = usr
	if(src == M.activeItem)
		M.activeItem = null
		M.HUDInventory()
	verbs.Remove(/obj/item/useable/proc/Use)
	verbs.Add(/obj/item/verb/drop)

/obj/item/useable/proc/Use(target as mob|obj|turf|area)
	set name = "use"
	set src in usr
	var/mob/player/M
	var/wait
	var/reach
	if(!target)
		target = DefaultUse()
	M = usr
	wait = delay * (3 - M.dexterity / 10) / 1.25
	reach = 0
	if(M.dexterity != M.CalcStat("dexterity"))
		wait = delay * 3
	if(get_dist(M, target) <= range)
		reach = 1
	else
		if(M.children)
			for(var/mob/C in M.children)
				if(get_dist(C, target) <= range)
					reach = 1
					break
	if(M.act_delay > world.time || !reach || powerDrain > M.energy)
		return 0
	else
		M.act_delay = world.time + delay * (3 - M.dexterity / 10)
		if(useAnim)
			if(usr.icon_state == "swim")
				M.icon_state = "swimaction"
				M.dir = get_dir(M, target)
				spawn(wait) M.icon_state = "swim"
			else
				M.icon_state = useAnim
				M.dir = get_dir(M, target)
				spawn(wait) M.icon_state = "run"
		M.experience += delay * M.dexterity
		if(M.team.expBonus == "use")
			M.experience += 50
		if(powerDrain)
			M.energy -= powerDrain
			M.HUDBar("energy")
		return 1

/obj/item/useable/proc/DefaultUse()
	return get_step(usr, usr.dir)

/obj/item/useable/proc/Discard()
	var/mob/player/M
	M = usr
	if(istype(M, /mob/player))
		if(quantity > 1)
			quantity--
			M.encumberance -= CalcWeight(1)
			UpdateQuantity()
			M.HUDUpdate("carry")
		else
			M.client.screen.Remove(src)
			M.inventory.Remove(src)
			M.inventory.Remove(locate(type) in M)
			M.activeItem = null
			M.HUDInventory()
			loc = null
			M.encumberance -= CalcWeight(1)
			M.HUDUpdate("carry")
			del(src)

/obj/item/ore/Move(mob/player/M as mob)
	. = ..()
	if(istype(M, /mob/player))
		if(!(vein in veinsFound))
			M.experience += (M.speed + M.digging) * (value / 500)
			if(M.team && M.team.expBonus == "find")
				M.experience += 150
	if(container)
		container.carried.Remove(src)
		container = null

/obj/item/Die()
	if(buyer)
		var/B = locate(buyer)
		if(B)
			B:insurance += round(value * 0.4)
	. = ..()

/obj/item/Del()
	if(container)
		container.carried.Remove(src)
		container = null

/obj/item/verb/get()
	set src in oview(1)
	var/mob/player/M
	var/amount
	var/dense
	var/reach
	var/obj/item/vehicle/V
	var/turf/T
	M = usr
	amount = 1
	dense = density
	reach = 0
	V = src
	T = loc
	if(istype(V, /obj/item/vehicle) && V.driver)
		return
	if(istype(T, /turf) && istype(M, /mob/player) && M.act_delay <= world.time && M.loc)
		density = 0
		if(CanReach(M, src))
			reach = 1
		else
			if(M.children)
				for(var/mob/C in M.children)
					if(CanReach(C, src))
						reach = 1
						break
		if(!istype(src, /obj/item/vehicle/raft))
			if(loc && M.loc && (loc.type == /turf/water || M.loc.type == /turf/water) && loc.type != M.loc.type)
				reach = 0
			if(istype(loc, /turf/water) && !T.Bridged() && M.icon_state != "swim")
				reach = 0
		if((src.loc in M.locs)) reach = 1
		if(reach && !planted || container)
			if(istype(src, /obj/item/ammo))
				var/A = src
				amount = min(A:quantity, A:amt)
			if(CalcWeight(amount) + M.Encumberance() > M.carry)
				usr << "You can't carry that much!"
			else
				if(quantity <= amount)
					Move(usr)
				else
					var/O = new type
					ItemCopy(O)
					O:quantity = amount
					O:Move(usr)
					quantity -= amount
				T = M.loc
				if(!T.Bridged())
					M.icon_state = "swimaction"
					M.act_delay = world.time + 30 - M.swim * 2
					M.experience += M.swim + 20
					spawn(30 - M.swim * 2)
						if(M) M.icon_state = "swim"
				else
					M.act_delay = world.time + 6 - round(M.dexterity / 5)
		density = dense

/obj/item/verb/drop()
	set src in usr
	var/mob/player/M
	var/amount
	var/dense
	M = loc
	amount = 1
	dense = density
	if(istype(src, /obj/item/ammo))
		var/A = src
		amount = min(A:quantity, A:amt)
	if(istype(src, /obj/item/equippable))
		var/E = src
		if(E:equipped)
			if(!E:DoUnequip(M))
				return
	if(M && istype(M, /mob/player) && M.loc && usr)
		if(M.activeItem == src)
			M.activeItem = null
		if(quantity <= amount || !stackable)
			density = 0
			Move(usr.loc)
			density = dense
			. = src
			Dropped()
			if(M.client && map)
				M.HUDInventory()
		else
			var/O = new type(usr)
			ItemCopy(O)
			O:quantity = amount
			O:density = 0
			O:Move(usr.loc)
			O:density = dense
			quantity -= amount
			. = O
			O:Dropped()
			UpdateQuantity()

/obj/item/verb/help()
	set src in world
	DblClick()

/obj/item/proc/attack()
	set src in view(1)
	var/mob/player/M
	M = usr
	if(damageable)
		M.Attack(src)

/obj/item/proc/Scatter(loc, Q=quantity)
	var/list/openTurfs
	var/O
	usr = loc
	loc = GetTurf(loc)
	openTurfs = list(loc)
	for(var/D in list(1, 2, 4, 8, 5, 6, 9, 10))
		if(CanReach(loc, get_step(loc, D)))
			openTurfs.Add(get_step(loc, D))
	for(var/i = Q, i > 0, i--)
		O = drop()
		if(openTurfs.len && O)
			O:Move(pick(openTurfs))

/obj/item/proc/UpdateQuantity()
	var/obj/hud/O
	var/obj/hud/T
	var/val
	var/mob/M
	O = new()
	T = new()
	val = quantity
	M = loc
	overlays.Cut()
	if(isturf(loc))
		return
	if(!M || !M.oldHUDMode)
		DisplayWeight()
		if(highlight)
			overlays.Add(highlight)
	if(istype(src, /obj/item/equippable/weapon))
		if(M && M.oldHUDMode)
			if(src:equipped)
				suffix = "(equipped) [ammo] ammo"
			else
				suffix = "[ammo] ammo"
			return
		else
			val = ammo
			if(!val)
				return
	else if(istype(src, /obj/item/ammo))
		if(M && M.oldHUDMode)
			val = round(quantity / src:amt)
			suffix = "[src:amt] ammo"
	else
		if(quantity == 1)
			return
	if(!ismob(loc))
		return
	O.icon = 'smallnum.dmi'
	O.icon_state = num2text(val % 10)
	if(M && !M.oldHUDMode)
		O.pixel_x = 25
		O.pixel_y = 1
	O.layer = 15
	if(val > 9)
		T = new()
		T.icon = 'smallnum.dmi'
		T.icon_state = num2text(round(val / 10))
		T.pixel_x = -6
		T.layer = 15
		O.overlays.Add(T)
		del(T)
	overlays.Add(O)
	del(O)

/obj/item/proc/CalcWeight(Q=quantity)
	return initial(weight) * Q

/obj/item/proc/ItemCopy(obj/item/O as obj)
	O.quantity = quantity
	O.value = value
	O.name = name
	O.icon = icon
	O.icon_state = icon_state
	O.invisibility = invisibility

/obj/item/proc/Plant()
	planted = 1
	verbs.Remove(/obj/item/verb/get)

/obj/item/proc/Unplant()
	planted = 0
	verbs.Add(/obj/item/verb/get)

/obj/item/proc/DisplayWeight()
	var/obj/hud/O
	var/val
	O = new()
	val = CalcWeight()
	O.icon = 'smallnum.dmi'
	O.icon_state = num2text(val % 10)
	if(val >= 10)
		O.pixel_x = 15
	else if(round(val) != val)
		O.pixel_x = 8
	else
		O.pixel_x = 13
	O.pixel_y = 36
	O.layer = 15
	overlays.Add(O)
	del(O)
	if(val > 9)
		O = new()
		O.icon = 'smallnum.dmi'
		O.icon_state = num2text(round(val / 10))
		O.pixel_x = 9
		O.pixel_y = 36
		O.layer = 15
		overlays.Add(O)
		del(O)
	else if(round(val) != val)
		O = new()
		O.icon = 'smallnum.dmi'
		O.icon_state = num2text((val - round(val)) * 10)
		O.pixel_x = 16
		O.pixel_y = 36
		O.layer = 15
		overlays.Add(O)
		del(O)
		O = new()
		O.icon = 'smallnum.dmi'
		O.icon_state = "."
		O.pixel_x = 14
		O.pixel_y = 37
		O.layer = 15
		overlays.Add(O)
		del(O)

/obj/item/proc/Highlight()
	var/obj/hud/O
	var/mob/M
	if(!ismob(loc))
		return
	O = new()
	M = loc
	if(M.oldHUDMode)
		return
	O.icon = 'hudlight.dmi'
	O.pixel_x = 0
	O.pixel_y = 37
	O.layer = 14.5
	overlays.Add(O)
	highlight = O

/obj/item/proc/Describe(M as mob)
	M << "<b>[Proper(name)]</b>"
	M << "weight: [weight]   value: $[value]"
	if(buyer) M << "<i>Belongs to [buyer]</i>"
	M << desc
