var/list/condensedCoords = list("strength" = "61,344", "attack" = "61,325", "speed" = "61,306", "dexterity" = "61,287", "intelligence" = "61,268", "aim" = "61,249", "defense" = "61,230", "digging" = "61,211", "rank" = "61,370", "health" = "69,182", "energy" = "69,163", "radiation" = "69,144", "cash" = "85,68", "carry" = "61, 87")
/proc/InitMasterHUD()
	var/icon/I
	var/obj/O
	I = new('hud2.dmi')
	for(var/x = 0, x <= 12, x++)
		for(var/y = 0, y <= 12, y++)
			if("[x],[y]" in icon_states('hud2.dmi'))
				O = new()
				O.icon = I
				O.icon_state = "[x],[y]"
				O.screen_loc = "[x],[y]"
				O.layer = 14
				O.name = "hud"
				masterHUD["[x],[y]"] = O
	masterHUD["up"] = new/obj/hud/invArrow/up()
	masterHUD["down"] = new/obj/hud/invArrow/down()
	for(var/T in typesof(/obj/hud/button) - /obj/hud/button)
		masterHUD["[T]"] = new T()
	InitShopHUD()
	InitSmallHUD()

/proc/InitSmallHUD()
	var/icon/I
	var/obj/O
	I = new('hud_small.dmi')
	for(var/x = 1, x <= 11, x++)
		for(var/y = 1, y <= 11, y++)
			if("[x - 1],[y - 1]" in icon_states('hud_small.dmi'))
				O = new()
				O.icon = I
				O.icon_state = "[x - 1],[y - 1]"
				O.screen_loc = "[x],[y]"
				O.layer = 14
				O.name = "hud"
				condensedHUD["[x],[y]"] = O

/proc/InitShopHUD()
	var/icon/I
	var/obj/O
	I = new('shop.dmi')
	for(var/x = 0, x <= 12, x++)
		for(var/y = 0, y <= 2, y++)
			if("[x],[y]" in icon_states('shop.dmi'))
				O = new()
				O.icon = I
				O.icon_state = "[x],[y]"
				O.screen_loc = "[x],[y]"
				O.layer = 14.5
				O.name = "hud"
				shopHUD["[x],[y]"] = O
	shopHUD["done"] = new/obj/hud/shopButton/done()
	shopHUD["cancel"] = new/obj/hud/shopButton/cancel()
	shopHUD["order"] = new/obj/hud/shopButton/order()

/mob/proc/HUDTime()
	if(!HUDMode && map && map.timer && client) client.screen.Add(map.timer)

/mob/proc/LoadHUD()
	if(HUDMode)
		client.screen.Cut()
		for(var/h in condensedHUD)
			client.screen.Add(condensedHUD[h])
	else
		client.screen.Cut()
		for(var/h in masterHUD)
			client.screen.Add(masterHUD[h])
		client.screen.Remove(masterHUD["up"])
		client.screen.Remove(masterHUD["down"])
		if(type == /mob/observer)
			client.screen.Remove(masterHUD["/obj/hud/button/save"])
			client.screen.Remove(masterHUD["/obj/hud/button/get"])
			client.screen.Remove(masterHUD["/obj/hud/button/attack"])
		else
			client.screen.Remove(masterHUD["/obj/hud/button/observe"])

/mob/player/proc/ShopHUD()
	for(var/h in shopHUD)
		client.screen.Add(shopHUD[h])

/mob/player/proc/DeShopHUD()
	for(var/h in shopHUD)
		client.screen.Remove(shopHUD[h])

/mob/player/proc/HUDUpdate(Field, digits=2, percent=0)
	var/obj/hud/H
	var/obj/hud/U
	var/Hx
	var/Hy
	var/Hloc
	var/value
	H = new()
	value = vars[Field]
	if(!client) return
	if(HUDMode)
		Hloc = condensedCoords[Field]
	else
		Hloc = HUDCoords[Field]
	if(percent)
		value = round(vars[Field] * 100 / vars["max_[Field]"])
	if(Field in HUD)
		client.screen.Remove(HUD[Field])
		del(HUD[Field])
	if(Field == "cash")
		digits = 5
		if(vars["cash"] > 99999)
			cash = 99999
			value = 99999
	HUD[Field] = H
	client.screen.Add(H)
	H.layer = 15
	if(Field == "carry")
		value = vars["carry"] - encumberance
		H.layer = 14.05
	H.icon = 'statnum.dmi'
	H.icon_state = num2text(value % 10)
	Hx = text2num(copytext(Hloc, 1, findtext(Hloc, ",")))
	Hy = text2num(copytext(Hloc, findtext(Hloc, ",") + 1, 0))
	H.screen_loc = "[round(Hx / 32)]:[Hx % 32],[round(Hy / 32)]:[Hy % 32]"
	H.mouse_opacity = 1
	H.name = Field
	for(var/i = 1, i < digits, i++)
		U = new()
		U.icon = 'statnum.dmi'
		U.icon_state = num2text(round(value % 10 ** (i + 1) / 10 ** i))
		U.pixel_x = i * -8
		U.layer = H.layer
		H.overlays.Add(U)
		del(U)

/mob/player/proc/HUDBar(Field)
	var/obj/hud/H
	var/obj/hud/U
	var/Hx
	var/Hy
	var/add
	var/val
	H = new()
	val = round(vars[Field] / vars["max_[Field]"] * 75)
	if(!client) return
	if(HUDMode)
		HUDUpdate(Field, 3, 1)
		return
	if(Field in HUD)
		client.screen.Remove(HUD[Field])
		del(HUD[Field])
	HUD[Field] = H
	client.screen.Add(H)
	H.icon = file("[Field]bar.dmi")
	H.icon_state = num2text(min(32, val))
	H.layer = 15
	Hx = text2num(copytext(HUDCoords[Field], 1, findtext(HUDCoords[Field], ",")))
	Hy = text2num(copytext(HUDCoords[Field], findtext(HUDCoords[Field], ",") + 1, 0))
	H.screen_loc = "[round(Hx / 32)]:[Hx % 32],[round(Hy / 32)]:[Hy % 32]"
	H.name = Field
	while(val > 32)
		U = new()
		val -= 32
		add++
		U.icon = file("[Field]bar.dmi")
		U.icon_state = num2text(min(32, val))
		U.layer = 15
		U.pixel_y = add * 32
		H.overlays.Add(U)
		del(U)

/mob/player/proc/HUDTeam()
	var/obj/hud/H
	var/obj/hud/U
	var/Hx
	var/Hy
	H = new()
	if(oldHUDMode) return
	if("team" in HUD)
		client.screen.Remove(HUD["team"])
		del(HUD["team"])
	HUD["team"] = H
	client.screen.Add(H)
	H.icon = 'teambar1.dmi'
	H.icon_state = team.name
	H.layer = 15
	Hx = text2num(copytext(HUDCoords["team"], 1, findtext(HUDCoords["team"], ",")))
	Hy = text2num(copytext(HUDCoords["team"], findtext(HUDCoords["team"], ",") + 1, 0))
	H.screen_loc = "[round(Hx / 32)]:[Hx % 32],[round(Hy / 32)]:[Hy % 32]"
	H.name = "team"
	for(var/i = 2, i <= 3, i++)
		U = new()
		U.icon = file("teambar[i].dmi")
		U.icon_state = team.name
		U.layer = 15
		U.pixel_x = (i - 1) * -32
		H.overlays.Add(U)
		del(U)

/mob/player/proc/HUDInventory()
	if(!client) return
	SortInv()
	if(shopping)
		HUDShop(shopList)
	else
		var/obj/item/O
		for(O in inventory)
			if(O in client.screen) client.screen.Remove(O)
		if(HUDMode) return
		for(var/i = client.invSlot, i < client.invSlot + 8 && i <= inventory.len, i++)
			HUDItem(i)
		if(client.invSlot >= inventory.len - 7 - (activeItem != null))
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
		if(activeItem)
			HUDUse()

/mob/player/proc/HUDUse()
	var/image/I
	I = activeItem
	I.screen_loc = "0:5,0:4"
	if(!(I in client.screen))
		client.screen.Add(I)

/mob/player/proc/HUDItem(I, currentList=inventory)
	var/image/O
	var/Hx
	O = currentList[I]
	Hx = (I - client.invSlot) * 39 + 83
	if(O == activeItem)
		return
	O.screen_loc = "[round(Hx / 32)]:[Hx % 32],0:4"
	client.screen.Add(O)

/obj/hud/score/proc/Init(team, teamNo)
	var/Y
	Y = 353 - teamNo * 12
	screen_loc = "9:7,[round(Y / 32) + 1]:[Y % 32]"
	layer = 14
	color_ = team

/obj/hud/score/proc/Update(players, score)
	var/obj/hud/H
	var/obj/hud/U
	var/digit
	overlays.Cut()
	H = new()
	H.icon = 'team_score.dmi'
	H.icon_state = color_
	H.layer = 15
	H.pixel_x = -16
	overlays.Add(H)
	del(H)
	for(var/i = 1, i <= 10, i++)
		U = new()
		U.icon = 'scorenum.dmi'
		U.pixel_x = i * 8 + -6
		if(i > 3) U.pixel_x += 3
		U.layer = 15
		if(i == 1)
			U.icon_state = "ppl"
		else if(i == 2)
			if(players >= 10)
				U.icon_state = num2text(round(players / 10))
			else
				U.icon_state = num2text(players % 10)
		else if(i == 3)
			if(players >= 10)
				U.icon_state = num2text(players % 10)
			else
				del(U)
		else if(i == 4)
			U.icon_state = "score"
		else
			if(score)
				digit = round(log(10, score))
			else
				digit = 0
			if(i <= digit + 5)
				U.icon_state = num2text(round(score % 10 ** (digit + 6 - i) / 10 ** (digit + 5 - i)))
			else
				del(U)
				break
		if(U)
			overlays.Add(U)
			del(U)

/obj/hud/invArrow/Click()
	var/mob/player/M
	var/max
	M = usr
	max = M.inventory.len
	if(M.shopping && M.shopList)
		max = M:shopList:len
	usr.client.invSlot += cycleDir * 8
	usr.client.invSlot = max(1, min(round(max / 8) * 8 + 1, usr.client.invSlot))
	M.HUDInventory()

/obj/hud/button/who/Click()
	usr.who()

/obj/hud/button/observe/Click()
	var/mob/observer/O
	var/target
	O = usr
	target = input("Observe whom?") in players
	if(istype(O, /mob/observer))
		O.observe(target)

/obj/hud/button/scores/Click()
	usr.toggle_scores()

/obj/hud/button/talk/Click()
	usr.say(input("", "say \"text\"") as text)

/obj/hud/button/panels/Click()
	usr.toggle_panels()

/obj/hud/button/help/Click()
	usr.instructions()

/obj/hud/button/save/Click()
	var/mob/player/M
	M = usr
	if(istype(M, /mob/player) && M.client)
		M.save()

/obj/hud/button/get/Click()
	var/mob/player/M
	M = usr
	if(istype(M, /mob/player) && M.client)
		if(M.mode != "get")
			M.mode("get")
		else
			M.mode("default")

/obj/hud/button/attack/Click()
	var/mob/player/M
	M = usr
	if(istype(M, /mob/player) && M.client)
		if(M.mode != "attack")
			M.mode("attack")
		else
			M.mode("default")

/obj/hud/shopButton/done/Click()
	var/mob/player/M
	M = usr
	if(M.shopList == shopBase)
		M.DeShop()
	else
		for(var/O in M.shopList)
			M.client.screen.Remove(O)
		M.client.invSlot = 1
		M.shopList = shopBase
		M.HUDShop(shopBase)

/obj/hud/shopButton/done/verb/done()
	set src in usr.client.screen
	Click()

/obj/hud/shopButton/order/Click()
	var/mob/player/M
	M = usr
	for(var/O in M.shopList)
		M.client.screen.Remove(O)
	M.shopList = M.shoppingCart
	M.client.invSlot = 1
	M.HUDShop(M.shoppingCart)

/obj/hud/shopButton/order/verb/view_order()
	set src in usr.client.screen
	Click()

/obj/hud/shopButton/cancel/Click()
	var/mob/player/M
	M = usr
	for(var/obj/shop/S in M.team.totalShopList)
		M.client.images.Remove(S.highlight)
		M.client.screen.Remove(S)
	for(var/obj/shop/S in M.shoppingCart)
		M.client.screen.Remove(S)
	M.shoppingCart.Cut()
	M.cash += M.bill
	M.bill = 0
	M.shopWeight = 0
	for(var/O in M.shopList)
		M.client.screen.Remove(O)
	M.shopList = shopBase
	M.client.invSlot = 1
	M.HUDUpdate("cash", 5)
	M.HUDShop(M.shopList)

/obj/hud/shopButton/cancel/verb/cancel_order()
	set src in usr.client.screen
	Click()
