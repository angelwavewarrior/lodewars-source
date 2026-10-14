/obj/shop
	layer = 15.5
	var/itemType
	var/value
	var/weight
	var/obj/item/item
	var/obj/hud/highlight

/obj/shop/category
	icon = 'shop_menu.dmi'

/turf/base/shop_console
	icon_state = "console"
	density = 1

/obj/shop/category/ammo
	desc = "The ammunition required for non-energy weapons."
	icon_state = "ammo"

/obj/shop/category/armor
	desc = "Protective gear to absorb damage and keep you safe."
	icon_state = "armor"

/obj/shop/category/equipment
	desc = "Gear worn or carried to increase mining performance."
	icon_state = "equipment"

/obj/shop/category/installation
	desc = "Heavy duty structures for long-lasting use."
	icon_state = "installations"

/obj/shop/category/items
	desc = "Useful tools of all varieties."
	icon_state = "items"

/obj/shop/category/vehicles
	desc = "Machinery for getting to and from the mines more quickly."
	icon_state = "vehicles"

/obj/shop/category/weapon
	desc = "Tools of war for defending your claim... or attacking your enemies'."
	icon_state = "weapon"

/proc/InitializeShop()
	var/S
	for(S in shopCatalog)
		new/obj/shop(null, S)
	for(S in typesof(/obj/shop/category) - /obj/shop/category)
		shopBase.Add(new S())

/mob/player/proc/HUDShop(currentList)
	var/obj/O
	for(O in currentList + inventory)
		if(O in client.screen) client.screen.Remove(O)
	for(var/i = client.invSlot, i < client.invSlot + 8 && i <= currentList:len, i++)
		HUDItem(i, currentList)
	if(client.invSlot >= currentList:len - 7)
		if(masterHUD["down"] in client.screen)
			client.screen.Remove(masterHUD["down"])
	else
		if(!(masterHUD["down"] in client.screen))
			client.screen.Add(masterHUD["down"])
	if(client.invSlot <= 8)
		if(masterHUD["up"] in client.screen)
			client.screen.Remove(masterHUD["up"])
	else
		if(!(masterHUD["up"] in client.screen))
			client.screen.Add(masterHUD["up"])

/turf/base/shop_console/Click()
	if(get_dist(usr, src) <= 1)
		shop()

/turf/base/shop_console/verb/borrow()
	set desc = "Obtains some extra cash. Players cannot borrow if they already owe money, and must repay loans from their next paycheck."
	set src in orange(1)
	var/mob/player/M
	M = usr
	if(istype(M, /mob/player) && !M.debt)
		M.debt = (M.rank * 100 + 500) * 1.5
		M.cash += M.rank * 100 + 500
		M.HUDUpdate("cash", 5)
		M << "You take out a loan for $[M.rank * 100 + 500]."

/turf/base/shop_console/verb/shop()
	set desc = "Enters the graphical shop interface."
	set src in orange(1)
	var/mob/player/M
	M = usr
	if(!istype(M, /mob/player))
		return
	if(!M.shopping)
		if(M.HUDMode)
			M.toggle_hud()
			M.oldHUDMode = 1
		M.ShopHUD()
		M.shopList = shopBase
		M.client.invSlot = 1
		M.HUDShop(M.shopList)
		M.shopping = 1
	else if(M.shopList != shopBase)
		for(var/O in M.shopList)
			M.client.screen.Remove(O)
		M.client.invSlot = 1
		M.shopList = shopBase
		M.HUDShop(shopBase)

/turf/base/shop_console/verb/buy(S as obj in usr.team.totalShopList, amt=1 as num|null)
	set desc = "Purchase an item quickly without entering the graphical shop interface."
	set popup_menu = 0
	set src = orange(1)
	var/mob/player/M
	var/oldShop
	M = usr
	oldShop = M.shopping
	if(istype(M, /mob/player))
		M.shopping = 1
		// A full stack at most. Past the cash, each click only repeats "You can't afford that!",
		// and a huge amount would hold the server in this loop.
		amt = min(round(amt), 99)
		for(var/i = 1, i <= amt, i++)
			S:Click()
			if(S:value > M.cash)
				break
		if(!oldShop)
			M.DeShop()

/turf/base/shop_console/verb/sell(obj/item/O as obj)
	set desc = "Sells an item back to the store for credit."
	set src = orange(1)
	if(O && !istype(O, /obj/item/ore))
		if(O.loc == usr)
			var/M = usr
			O = O.drop()
			if(O)
				O.loc = null
				// Ammo value is per pack of amt rounds.
				var/V = O.value
				if(istype(O, /obj/item/ammo))
					V = O.value * O.quantity / O:amt
				// Each buyer's share of a merged stack is paid as if sold on its own.
				var/list/L = O.Buyers()
				var/Q = O.quantity
				for(var/K in L)
					var/P = V * L[K] / Q
					var/B = K ? locate(K) : null
					if(B && B == M)
						M:cash += round(P * 0.8)
						M << "You sell \the [O.name] for $[round(P * 0.8)]."
						M:HUDUpdate("cash", 5)
					else if(!B)
						M:cash += round(P * 0.4)
						M << "You sell \the [O.name] for $[round(P * 0.4)]."
						M:HUDUpdate("cash", 5)
					else if(B:team == M:team)
						B:cash += round(P * 0.8)
						M << "You return your teammate [B:name]'s [O.name]."
						B << "[M:name] returns your [O.name] to the shop for $[round(P * 0.8)]."
						B:HUDUpdate("cash", 5)
					else
						M:cash += round(P * 0.4)
						M << "You sell \the [O.name] for $[round(P * 0.4)]."
						B:insurance += round(P * 0.4)
						M:HUDUpdate("cash", 5)
				M:client:screen:Remove(O)
				if(O in M:inventory)
					M:inventory:Remove(O)
				if(O == M:activeItem)
					M:activeItem = null
				del(O)
	else
		usr << "You can't sell that! Deposit your ore in the ore bin outside of your base."

/obj/shop/New(Loc, Type)
	if(Type)
		itemType = Type
		spawn(0) InitializeShopItem()
	. = ..()

/obj/shop/proc/Copy()
	var/obj/shop/S
	S = new()
	S.itemType = itemType
	S.value = value
	S.weight = weight
	S.icon = icon
	S.icon_state = icon_state
	S.name = name
	for(var/O in overlays)
		S.overlays.Add(O)
	S.highlight = image(highlight, S)
	S.verbs.Add(/obj/shop/proc/return_purchase)
	return S

/obj/shop/proc/DisplayPrice()
	var/obj/hud/O
	var/digit
	digit = 0
	if(value)
		digit = round(log(10, value))
	if(isturf(loc))
		return
	for(var/i = 0, i <= digit, i++)
		O = new()
		O.icon = 'smallnum.dmi'
		O.icon_state = num2text(round(value % 10 ** (digit - i + 1) / 10 ** (digit - i)))
		O.pixel_x = 25 - (digit - i) * 6
		O.pixel_y = 1
		O.layer = 15.5
		overlays.Add(O)
		del(O)

/obj/shop/proc/InitializeShopItem()
	var/H
	item = new itemType()
	value = item.value
	weight = item.weight
	icon = item.icon
	icon_state = item.icon_state
	name = item.name
	item.UpdateQuantity()
	for(var/O in item.overlays)
		overlays.Add(O)
	DisplayPrice()
	if(!shopItems[name]) shopItems[name] = src
	highlight = new/obj/hud()
	highlight.pixel_y = 37
	highlight.icon = 'hudlight.dmi'
	highlight.layer = 14.5
	H = highlight
	highlight = image(highlight, src)
	del(H)
	verbs.Add(/obj/shop/proc/help)

/obj/shop/proc/buy(Amt=1 as num)
	set src in usr.client.screen
	var/mob/player/M = usr
	Amt = min(round(Amt), 99)
	for(var/i = 1, i <= Amt, i++)
		Click()
		if(value > M.cash)
			break

/obj/shop/proc/return_purchase()
	set name = "return"
	set src in usr.client.screen
	Click()

/obj/shop/proc/help()
	set src in usr.client.screen
	usr << "<b>[name]</b>"
	usr << "weight: [weight]   value: $[value]"
	if(item)
		usr << item.desc
	else
		usr << desc

/obj/shop/Click()
	var/mob/player/M
	M = usr
	if(src in M.shoppingCart)
		M.shoppingCart.Remove(src)
		M.client.screen.Remove(src)
		M.shopWeight -= weight
		M.bill -= value
		M.cash += value
		M.HUDUpdate("cash", 5)
		// Every entry is an /obj/shop; match the item it sells.
		var/more = 0
		for(var/obj/shop/C in M.shoppingCart)
			if(C.itemType == itemType) more = 1
		if(!more)
			for(var/obj/shop/S in M.team.totalShopList)
				if(S.itemType == itemType)
					while(S.highlight in M.client.images)
						M.client.images.Remove(S.highlight)
		del(src)
	else
		if(value > M.cash)
			M << "You can't afford that!"
			return
		else if(!istype(item, /obj/item/vehicle) || istype(item, /obj/item/vehicle/cart) || istype(item, /obj/item/vehicle/raft))
			if(M.shopWeight <= M.carry && weight + M.Encumberance() + M.shopWeight > M.carry)
				if(alert("You can't carry that much! Purchase anyhow?", "Confirm purchase", "Yes", "No") == "No")
					return
		else if(alert("This vehicle will be delivered to the loading area outside your base. Is this OK?", "Confirm purchase", "Yes", "No") == "No")
			return
		// Again: cash may have gone while the alert was open.
		if(value > M.cash)
			M << "You can't afford that!"
			return
		if(M.shopping)
			M.shoppingCart.Add(Copy())
			M.bill += value
			M.shopWeight += weight
			M.cash -= value
			M << highlight
			M.HUDUpdate("cash", 5)

/obj/shop/category/Click()
	var/mob/player/M
	M = usr
	for(var/O in shopBase)
		usr.client.screen.Remove(O)
	M.HUDShop(M.shopList)

/obj/shop/category/equipment/Click()
	var/mob/player/M
	M = usr
	M.shopList = M.team.equipmentList
	..()

/obj/shop/category/weapon/Click()
	var/mob/player/M
	M = usr
	if(M.team)
		M.shopList = M.team.weaponList
	..()

/obj/shop/category/ammo/Click()
	var/mob/player/M
	M = usr
	M.shopList = M.team.ammoList
	..()

/obj/shop/category/armor/Click()
	var/mob/player/M
	M = usr
	M.shopList = M.team.armorList
	..()

/obj/shop/category/items/Click()
	var/mob/player/M
	M = usr
	M.shopList = M.team.itemList
	..()

/obj/shop/category/installation/Click()
	var/mob/player/M
	M = usr
	M.shopList = M.team.installationList
	..()

/obj/shop/category/vehicles/Click()
	var/mob/player/M
	M = usr
	M.shopList = M.team.vehicleList
	..()
