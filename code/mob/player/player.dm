/mob/player
	var/list/HUD = list()
	var/strength
	var/speed
	var/dexterity
	var/intelligence
	var/aim
	var/attack
	var/digging
	var/experience = "unsaved"
	var/rank = 0
	var/swim = 0
	var/race
	var/size = 1
	var/radiation
	var/max_radiation = 1000
	var/radBlock
	var/regen
	var/carry
	var/encumberance
	var/cash = 1000
	var/bank
	var/debt = 0
	var/act_delay
	var/speed_accum
	var/attackAnim = "punch"
	var/digAnim = "dig"
	var/list/inventory = list()
	var/list/equipment = list()
	var/list/statOrder
	var/obj/item/useable/activeItem
	var/tutorial = 1
	var/deaths
	var/kills
	var/teamKills
	var/activity = 100
	var/playTime = 0
	var/save_time = 0
	var/list/shoppingCart = new/list()
	var/bill = 0
	var/shopList
	var/shopWeight
	damageable = 1
	max_energy = 30

/mob/player/proc/SelectTeam(T)
	if(experience == "unsaved")
		spawn(10) SelectTeam(T)
	else
		JoinTeam(T)

/mob/player/proc/JoinTeam(datum/T)
	var/the
	var/obj/O
	the = T.type != /team/black && T.type != /team/white && T.type != /team/blue
	if(the)
		the = "the "
	else
		the = ""
	team = T
	if(!(src in team.members)) team.members.Add(src)
	team.allMembers.Add(tag)
	team.UpdateScore()
	HUDTeam()
	O = new()
	O.icon = 'team_badge.dmi'
	O.icon_state = team.name
	O.pixel_y = (size - 1) * 32
	O.layer = 5
	overlays.Add(O)
	del(O)
	signals.Add(src)
	signal = "[name]"
	players << "[name] joins [the]\icon[team.comm] [team.title]!"
	experience = max(0, experience - 400 - rank * 100)
	playTime = map.timer.time / map.timer.start * 100
	Respawn()

/mob/player/proc/Respawn()
	health = max_health
	energy = max_energy
	radiation = 0
	radioactivity = 0
	for(var/H in list("health", "energy", "radiation"))
		HUDBar(H)
	Move(teamSpawns[team.name])
	loc = teamSpawns[team.name]
	animate_movement = 1
	icon_state = "run"
	spawn(10) Regen()

/mob/player/proc/Regen()
	var/atom/T
	var/netHealth
	var/netEnergy
	var/netRad
	T = loc
	if(!T || !map)
		return
	netHealth = round((0.66 - radiation / max_radiation) * 3) / 2
	if(radiation / max_radiation > health / max_health)
		netHealth--
	if(T.team == team)
		netHealth += 3
		netRad -= 15
		netEnergy += 1
	else
		if(type != /mob/player/bolo)
			netRad += T.radioactivity
		else
			netRad += T.radioactivity / 2
	netRad += radioactivity
	if("rad suit" in equipment)
		netRad = min(0.25, netRad)
	else if(radBlock && netRad)
		radBlock--
		netRad = min(0.5, netRad)
	netHealth *= 2.5
	netRad *= 2.5
	netEnergy *= 2.5
	netHealth = min(round(netHealth, 1), max_health - health)
	netRad = min(round(netRad, 1), max_radiation - radiation)
	netEnergy = min(round(netEnergy, 1), max_energy - energy)
	if("cycler" in equipment)
		netEnergy += round(radioactivity / 3 + T.radioactivity / 8) + 1
	if(regen)
		regen--
		netHealth += 2
	if(netHealth)
		health = min(health + netHealth, max_health)
		HUDBar("health")
	if(netEnergy)
		energy = min(energy + netEnergy, max_energy)
		HUDBar("energy")
	if(netRad)
		radiation = max(0, min(radiation + netRad, max_radiation))
		HUDBar("radiation")
	if(health <= 0)
		Die(null, "radiation")
	if(act_delay < world.time - 600 && activity > 0)
		act_delay = world.time - 1
		activity -= 100 / map.timer.start
		activity = max(0, activity)
	spawn(50) Regen()

/mob/player/proc/DisplayStats()
	for(var/A in list("strength", "dexterity", "intelligence", "defense", "aim", "speed", "digging", "attack", "rank", "carry"))
		HUDUpdate(A)
	for(var/A in list("health", "radiation", "energy"))
		HUDBar(A)
	HUDUpdate("cash", 5)
	HUDTime()
	HUDInventory()

/mob/player/proc/SortInv()
	var/list/eqList
	var/list/unEqList
	var/list/itemList
	var/list/oreList
	var/obj/item/equippable/E
	eqList = list()
	unEqList = list()
	itemList = list()
	oreList = list()
	radioactivity = 0
	for(var/obj/item/O in inventory)
		radioactivity += O.radioactivity * O.quantity
		if(O == activeItem) continue
		if(istype(O, /obj/item/equippable))
			E = O
			if(E.equipped)
				eqList.Add(O)
			else
				unEqList.Add(O)
		else if(!istype(O, /obj/item/ore))
			itemList.Add(O)
		else
			oreList.Add(O)
	inventory.Cut()
	if(activeItem)
		if(oldHUDMode)
			inventory = list(activeItem) + eqList + unEqList + itemList + oreList
		else
			inventory = eqList + unEqList + itemList + oreList
			inventory.Add(activeItem)
	else
		inventory = eqList + unEqList + itemList + oreList

/mob/player/proc/Encumberance()
	encumberance = 0
	for(var/obj/item/O in inventory)
		encumberance += O.CalcWeight()
	carry = CalcStat("carry")
	HUDUpdate("carry")
	return encumberance

/mob/player/proc/CalcStat(Stat)
	var/findStat
	findStat = Stat
	if(Stat in vars)
		. = initial(vars[Stat])
		if(Stat == "carry") findStat = "strength"
		var/n = statOrder.Find(findStat)
		if(n)
			. += round(rank / 8) + (rank % 8 >= n)
		var/obj/item/equippable/E
		// Two-slot armour sits under both slots; count it once.
		var/list/counted = list()
		for(var/O in equipment)
			E = equipment[O]
			if(E in counted) continue
			counted += E
			if(Stat in E.adds)
				. += E.adds[Stat]

/mob/player/proc/DeShop()
	DeShopHUD()
	if(!loc || !team)
		// Dead or between rounds: nothing can be delivered, so refund the cart.
		if(client)
			for(var/O in shopList)
				client.screen.Remove(O)
			if(team)
				for(var/obj/shop/S in team.totalShopList)
					client.images.Remove(S.highlight)
		cash += bill
		for(var/S in shoppingCart)
			del(S)
		shoppingCart.Cut()
		bill = 0
		shopping = 0
		shopList = null
		shopWeight = 0
		return
	for(var/obj/O in shopList)
		client.screen.Remove(O)
	bill = 0
	shopping = 0
	shopList = null
	shopWeight = 0
	client.invSlot = 1
	if(shoppingCart.len)
		var/obj/item/O
		for(var/obj/shop/S in shoppingCart)
			O = new S.itemType
			// Before the Move, so a purchase merged into a carried stack keeps its own buyer.
			O.buyer = tag
			if(!istype(O, /obj/item/vehicle) || istype(O, /obj/item/vehicle/cart) || istype(O, /obj/item/vehicle/raft))
				O.loc = loc
				if(O.weight + Encumberance() <= carry)
					O.Move(src)
			else
				if(locate(/obj/item/vehicle) in team.loadingZone)
					src << "Error: loading zone blocked! Clear the loading zone before purchasing any further vehicles."
					cash += O.value
					del(O)
					HUDUpdate("cash", 5)
				else
					O.loc = team.loadingZone
					O.Dropped()
			del(S)
		shoppingCart.Cut()
	for(var/obj/shop/S in team.totalShopList)
		client.images.Remove(S.highlight)
		client.screen.Remove(S)
	if(oldHUDMode != HUDMode)
		toggle_hud()
	Encumberance()
	HUDInventory()

/mob/player/verb/team_chat(chat as text)
	set desc = "Broadcast a message to teammates."
	if(team)
		Chat(chat, team.members, "i")

/mob/player/verb/save()
	set desc = "Saves current stats. Normally not necessary due to automatic saves, but it's a good idea to save before switching servers."
	if(map && map.saved)
		if(save_time < world.time)
			if(SaveCharacter())
				usr << "Saved."
			save_time = world.time + 500
	else
		usr << "Saving not available at this time. Either the round is over, or this round is not being saved."

/mob/player/verb/mode(newMode in list("default", "attack", "get"))
	set desc = "Alters the action to be taken when running into objects or clicking."
	mode = newMode
	switch(mode)
		if("attack")
			client.mouse_pointer_icon = icon('cursor.dmi', "attack")
		if("default")
			client.mouse_pointer_icon = null
		if("get")
			client.mouse_pointer_icon = icon('cursor.dmi', "get")

/mob/player/verb/item(N as num)
	set hidden = 1
	var/currentList
	currentList = inventory
	if(shopping)
		currentList = shopList
	if(N == 0)
		if(activeItem)
			activeItem.Click()
	else if(N + client.invSlot - 1 <= currentList:len - (activeItem != null))
		var/O = currentList[N + client.invSlot - 1]
		O:Click()

/mob/player/verb/inventory(D in list("forward", "backward"))
	set hidden = 1
	var/H
	if(D == "forward")
		if(masterHUD["down"] in client.screen)
			H = masterHUD["down"]
			H:Click()
	else
		if(masterHUD["up"] in client.screen)
			H = masterHUD["up"]
			H:Click()

/mob/player/verb/get(target in list("ores", "ammo", "equipment", "items", "any") + Items(1))
	var/filter
	var/best
	var/bestVal
	var/turf/T
	var/turf/U
	if(isobj(target))
		var/O = target
		O:get()
		return
	switch(target)
		if("ores") filter = /obj/item/ore
		if("ammo") filter = /obj/item/ammo
		if("equipment") filter = /obj/item/equippable
		if("items") filter = /obj/item/useable
	for(var/obj/item/O in orange(1))
		if(!filter || istype(O, filter))
			if(O.value > bestVal && encumberance + O.weight <= carry)
				T = GetTurf(O)
				U = GetTurf(usr)
				if(isturf(O.loc) && CanReach(usr, O) && !O.planted && T.Bridged() == U.Bridged())
					bestVal = O.value
					best = O
	if(best)
		best:get()

/mob/player/Enter(O as obj)
	if(istype(O, /obj/item))
		if(encumberance + O:weight > carry)
			usr << "You can't carry \the [O:name], it's too heavy!"
			. = 0
		else
			. = 1

/mob/player/Login()
	save_ckey = ckey
	players.Add(src)
	if(map)
		if(map.saved)
			LoadCharacter()
			if(rank == 0)
				if("[name]/[race]" in money)
					cash = money["[name]/[race]"]
		else
			if(!isnull(map.cash)) cash = map.cash
			if(!isnull(map.rank)) rank = map.rank
			if(rank)
				var/V
				for(var/i = 1, i <= rank, i++)
					max_health++
					V = statOrder[(i - 1) % 8 + 1]
					vars[V] += 1
					if(V == "strength")
						carry++
			experience = 0
			if("[name]/[race]" in money)
				cash = money["[name]/[race]"]
	DisplayStats()
	tag = name
	// Only the host. Another key on the host's machine is local too.
	if(host && key == host)
		admins.Add(src)
		verbs.Add(typesof(/mob/admin/verb))
		verbs.Add(typesof(/mob/host/verb))
	else if(ckey in adminList)
		admins.Add(src)
		verbs.Add(typesof(/mob/admin/verb))
	client.mouse_pointer_icon = null
	client.eye = src
	client.perspective = src
	client.screen.Remove(masterHUD["/obj/hud/button/observe"])
	client.screen.Add(masterHUD["/obj/hud/button/save"])
	client.screen.Add(masterHUD["/obj/hud/button/get"])
	client.screen.Add(masterHUD["/obj/hud/button/attack"])

/mob/player/Logout()
	var/stop
	// Before the status line, so the count leaves this player out.
	players.Remove(src)
	if(!switching)
		players << "[name] logs out."
		if(playerLimit)
			if(serverName)
				world.status = "[serverName] ([players.len]/[playerLimit] players)"
			else
				world.status = "([players.len]/[playerLimit] players)"
		else
			world.status = serverName
		if(experience != "unsaved")
			spawn(1)
				if(map && map.saved && rank)
					SaveCharacter(0)
				else
					money["[name]/[race]"] = cash
				del(src)
		else
			spawn(1) del(src)
	else
		switching = 0
	admins.Remove(src)
	if(team)
		team.members.Remove(src)
		team.UpdateScore()
	usr = src
	for(var/obj/item/O in contents)
		stop = O.quantity
		O.verbs.Add(/obj/item/verb/drop)
		for(var/i = 1, i <= stop, i++)
			if(O) O.drop()
	var/obj/item/O
	for(var/H in HUD)
		O = HUD[H]
		del(O)
	HUD.Cut()
	loc = null
	key = null
	if(vehicle)
		vehicle.driver = null
		vehicle = null

/mob/player/Stat()
	if(client && client.show_verb_panel)
		if(statpanel("Teams"))
			if(map && map.timer) stat("Minutes remaining:", map.timer.time)
			if(teams)
				for(var/team/E in teams)
					stat("[Proper(E.name)] team:", "[E.score] points")
					for(var/mob/player/M in E.members)
						M = GetMob(M)
						stat("[M.name] ([M.race])")
			if(usr.key == "Leftley")
				stat("CPU", world.cpu)
		if(oldHUDMode && statpanel("Inventory"))
			stat(inventory)
