/obj/item
	icon = 'testobj.dmi'
	var/weight
	var/quantity = 1
	var/value
	var/ammo
	var/stackable = 0
	var/powerDrain
	var/highlight
	var/obj/item/vehicle/container
	var/owner
	// Who bought this item, as the buyer's tag, when every unit in the stack has the same buyer.
	var/buyer
	// Set instead of buyer when a stack holds units from more than one buyer:
	// buyer tag = how many units are theirs, with "" for units nobody bought.
	// The newest buyer is last, and units leave from that end. buyer is null meanwhile.
	var/list/buyerCounts
	var/useAnim

/obj/item/battery

/obj/item/DblClick()
	Describe(usr)

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
	. = ..()

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
					O:SetBuyerCounts(TakeBuyerCounts(amount))
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
			O:SetBuyerCounts(TakeBuyerCounts(amount))
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
	O.buyer = buyer

// How many units of this stack each buyer owns, as buyer tag = units. Always a new list.
/obj/item/proc/GetBuyerCounts()
	if(buyerCounts)
		return buyerCounts.Copy()
	return list("[buyer]" = quantity)

// Stores counts on this stack: in buyer if one buyer is left, in buyerCounts otherwise.
/obj/item/proc/SetBuyerCounts(list/counts)
	for(var/buyerTag in counts.Copy())
		if(counts[buyerTag] <= 0)
			counts -= buyerTag
	if(!counts.len)
		return
	if(counts.len == 1)
		var/onlyBuyer = counts[1]
		buyerCounts = null
		buyer = onlyBuyer == "" ? null : onlyBuyer
	else
		buyerCounts = counts
		buyer = null

// Takes units off this stack's buyer counts, newest buyer first, and returns whose they were.
// The caller lowers quantity itself.
/obj/item/proc/TakeBuyerCounts(units)
	if(!buyerCounts)
		return list("[buyer]" = units)
	var/list/remaining = buyerCounts.Copy()
	var/list/taken = list()
	for(var/i = remaining.len, i >= 1 && units > 0, i--)
		var/buyerTag = remaining[i]
		var/fromThisBuyer = min(units, remaining[buyerTag])
		taken.Insert(1, buyerTag)
		taken[buyerTag] = fromThisBuyer
		remaining[buyerTag] -= fromThisBuyer
		units -= fromThisBuyer
	SetBuyerCounts(remaining)
	return taken

// Adds the counts of a stack merging into this one, as the newest. Call it before raising quantity,
// since a one-buyer stack's count is its quantity.
/obj/item/proc/AddBuyerCounts(list/added)
	var/list/counts = GetBuyerCounts()
	for(var/buyerTag in added)
		var/alreadyHeld = counts[buyerTag] || 0
		// Removed and added back, so this buyer becomes the newest.
		counts -= buyerTag
		counts[buyerTag] = alreadyHeld + added[buyerTag]
	SetBuyerCounts(counts)

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
	if(buyerCounts)
		var/list/owners = list()
		for(var/buyerTag in buyerCounts)
			owners += "[buyerTag ? buyerTag : "nobody"] ([buyerCounts[buyerTag]])"
		M << "<i>Belongs to [jointext(owners, ", ")]</i>"
	else if(buyer) M << "<i>Belongs to [buyer]</i>"
	M << desc

/obj/item/proc/Dropped()
