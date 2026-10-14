/obj/item/useable
	icon = 'item.dmi'
	var/delay
	var/range = 1
	stackable = 1

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
			TakeBuyers(1)
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
