var/list/playTeams = list()
/mob/verb/say(chat as text)
	set desc = "Broadcasts a message to all players in the game."
	Chat(chat, players)

/mob/verb/who()
	set desc = "Displays a listing of all players."
	var/teamImg
	for(var/team/T in teams)
		teamImg = "\icon[T.comm]"
		usr << "[teamImg]<b><font color=[T.fontColor]>[T.title]</font></b>"
		for(var/mob/player/M in T.members)
			usr << "      [M.name] ([M.race])"
	usr << ""
	usr << "<b>Observers</b>"
	for(var/mob/observer/P in players)
		usr << "      [P.name]"

/mob/verb/toggle_panels()
	set name = "show/hide stat panels"
	set desc = "Turns the stat panels on or off."
	client.show_verb_panel = !client.show_verb_panel

/mob/verb/forum()
	set desc = "Opens the Lode Wars forum."
	usr << link("http://www.byond.com/forums/49/5149/index.cgi")

/mob/verb/toggle_scores()
	set name = "show/hide scores"
	set desc = "Turns the on-screen score bar on or off."
	showScores = !showScores
	for(var/team/T in teams)
		if(showScores)
			client.screen.Add(T.scoreDisplay)
		else
			client.screen.Remove(T.scoreDisplay)

/mob/verb/toggle_hud()
	set name = "condense/expand HUD"
	set desc = "Toggles between the default HUD and a smaller, condensed version."
	if(!shopping)
		HUDMode = !HUDMode
		oldHUDMode = HUDMode
		LoadHUD()
		if(istype(src, /mob/player))
			var/P = src
			for(var/obj/item/O in P:inventory)
				O.UpdateQuantity()
			P:DisplayStats()
			if(P:team)
				P:HUDTeam()
	else
		oldHUDMode = !oldHUDMode

/mob/proc/Items()
	var/list/items
	items = list()
	for(var/obj/item/O in orange(1))
		if(isturf(O.loc))
			items.Add(O)
	. = items

/mob/proc/Go(Dir)
	if(!vehicle)
		if(Dir) Move(get_step(GetTurf(src), Dir), Dir)
	else
		vehicle.Go(Dir)

/mob/proc/Chat(chat as text, recievers, tags)
	var/startSearch
	var/teamImg
	startSearch = 1
	if(!client) return
	if(!(src in admins))
		var/stripped = ckey(chat)
		for(var/F in filter)
			startSearch = 1
			if(filter[F] == "boot" || filter[F] == "mute" || filter[F] == "block")
				while(findtext(stripped, F, startSearch, 0))
					startSearch = findtext(stripped, F, startSearch, 0) + length(F)
					if(filter[F] == "mute")
						if(!client.mute)
							players - src << "[src] was muted for swearing."
							client.mute = 1
					else if(filter[F] == "boot")
						players << "[src] was booted for swearing."
						del(client)
						Logout()
						return
					else if(filter[F] == "block")
						chat = "*CENSORED*"
						tags = "b"
						break
			else
				while(findtext(chat, F, startSearch, 0))
					startSearch = findtext(chat, F, startSearch, 0)
					chat = copytext(chat, 1, findtext(chat, F)) + filter[F] + copytext(chat, findtext(chat, F) + length(F), 0)
	if(client.mute)
		recievers = list(src)
	usr.chat_time = max(usr.chat_time, world.time)
	if(usr.team)
		teamImg = "\icon[usr.team.comm]"
	while(findtext(chat, "\n", startSearch, 0))
		usr.chat_time += 6
		chat = "[copytext(chat, 1, findtext(chat, "\n"))][copytext(chat, findtext(chat, "\n") + 1, 0)]"
	if(length(chat) > 250)
		var/len
		len = findtext(chat, ".", 250, 275)
		if(!len)
			len = findtext(chat, "!", 250, 275)
			if(!len)
				len = findtext(chat, "?", 250, 275)
				if(!len)
					len = findtext(chat, ":", 250, 275)
					if(!len)
						len = findtext(chat, ";", 250, 275)
						if(!len)
							len = findtext(chat, ",", 250, 275)
							if(!len)
								len = findtext(chat, "-", 250, 275)
								if(!len)
									len = findtext(chat, " ", 250, 275)
									if(!len)
										len = 250
		if(length(chat) > len + 1)
			spawn(1) usr.Chat(copytext(chat, len + 1, 0), recievers, tags)
		chat = copytext(chat, 1, len + 1)
	if(usr.chat_time > world.time + 85)
		usr << "Booted for spamming."
		recievers - usr << "[usr] was booted for spam."
		del(usr.client)
		del(usr)
	else
		chat = html_encode(chat)
		spawn(max(0, usr.chat_time - world.time))
			recievers << "[teamImg]<b>[usr.name]</b>\..."
			if(tags)
				recievers << "<[tags]>: [chat]</[tags]>"
			else
				recievers << ": [chat]"
		if(usr.chat_time > world.time + 10)
			usr.chat_time += 30
		else
			usr.chat_time += 15

/mob/player/proc/SelectTeam(T)
	if(experience == "unsaved")
		spawn(10) SelectTeam(T)
	else
		JoinTeam(T)

/mob/player/proc/JoinTeam(datum/T)
	var/the
	var/H
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
	H = src
	O = new()
	if(head)
		H = head
	O.icon = 'team_badge.dmi'
	O.icon_state = team.name
	O.pixel_y = (size - 1) * 32
	O.layer = 5
	H:overlays:Add(O)
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
	if(head)
		head.loc = teamSpawns[team.name]
		UpdateChildren()
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

/mob/player/proc/Dig(turf/T as turf)
	var/delay
	var/A
	delay = (32 - digging + T.solidness) / size
	A = HeadForMob(src)
	icon_state = "dig"
	if(digging != CalcStat("digging"))
		delay = T.solidness + 30
	if(act_delay <= world.time)
		act_delay = world.time + delay
	else
		act_delay += delay
	sleep(delay * size - 1)
	icon_state = "run"
	if(A && A != src) A:icon_state = "run"
	if(src && T && get_dist(src, T) == 1)
		experience += digging + 10
		T.Dug()

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
		radioactivity += O.radioactivity
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
		for(var/O in equipment)
			E = equipment[O]
			if(Stat in E.adds)
				. += E.adds[Stat]

/mob/player/proc/DeShop()
	DeShopHUD()
	if(!loc || !team)
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
			if(O)
				O.buyer = tag
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
			if(SaveCharacter(1))
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
			del(O)
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
	var/waterLogged
	var/water
	waterLogged = 0
	water = 0
	if(shopping)
		shopping = 0
		DeShop()
	if(act_delay < world.time)
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
			return 0

/mob/player/Login()
	players.Add(src)
	if(map)
		if(map.saved)
			LoadCharacter()
			if(rank == 0)
				if("[name]/[race]" in money)
					cash = money["[name]/[race]"]
		else
			if(map.cash) cash = map.cash
			if(map.rank) rank = map.rank
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
	if(!client.address || client.address == "127.0.0.1" || client.address == world.address)
		admins.Add(src)
		verbs.Add(typesof(/mob/admin/verb))
		verbs.Add(typesof(/mob/host/verb))
	else if(key in adminList)
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
	players.Remove(src)
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
	for(var/mob/M in children)
		M.loc = null
		children.Remove(M)
		del(M)
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

/mob/Bump(O as mob|obj|turf|area)
	var/turf/T
	T = loc
	src = GetMob(src)
	if(istype(src, /mob/player))
		var/P = src
		if(mode != "attack" && istype(O, /turf/dirt) && (T.Bridged() || istype(src, /mob/player/bolo)))
			P:Dig(O)
		else
			var/atom/M
			if(mode != "get" && istype(O, /obj/item/vehicle))
				var/V = O
				M = V:driver
				if(M && M.team != team)
					P:Attack(V)
			if(mode != "get" && istype(O, /mob))
				M = GetMob(O)
				if(M.team != team)
					P:Attack(M)
		. = ..()

/mob/Stat()
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
