var/list/shopBase = list()
var/list/veins = list()
/proc/GenerateTeams()
	var/N
	var/teamType
	var/list/dirs
	var/D
	var/X
	var/Y
	var/list/availTeams
	var/list/easterEggs
	var/date
	N = rand(0, 9)
	dirs = list(1, 2, 4, 8)
	availTeams = typesof(/team) - /team
	easterEggs = list()
	date = time2text(world.realtime, "MM:DD")
	if(date == "10:31")
		easterEggs = list(/team/black, /team/orange)
	else if(date == "12:25")
		easterEggs = list(/team/red, /team/green)
	else if(date == "07:04")
		easterEggs = list(/team/red, /team/white, /team/blue)
	if(players.len < 8)
		N = max(0, N - 2)
	else if(players.len > 13)
		N += 2
	if(!map.teams)
		for(var/i, i <= round(N / 4) + 1, i++)
			if(easterEggs.len && rand(0, 2))
				teamType = pick(easterEggs)
				easterEggs.Remove(teamType)
			else
				teamType = pick(availTeams)
			teams.Add(new teamType())
			availTeams.Remove(teamType)
	else
		for(var/i = 1, i <= map.teams.len, i++)
			teamType = map.teams[i]
			teams.Add(new teamType())
	for(var/team/E in teams)
		D = pick(dirs)
		dirs.Remove(D)
		switch(D)
			if(4)
				X = map.max + 1
				Y = rand(47, map.max - 40)
			if(8)
				X = 6
				Y = rand(47, map.max - 40)
			if(1)
				Y = map.max + 1
				X = rand(47, map.max - 40)
			if(2)
				Y = 6
				X = rand(47, map.max - 40)
		CreateBase(X, Y, D, E)

/team/New()
	TeamShopLists()
	comm = image('team_comm.dmi', null, name)
	CreateSelect()
	TeamScoreDisplay()
	. = ..()

/team/proc/TeamScoreDisplay()
	scoreDisplay = new/obj/hud/score()
	scoreDisplay.Init(name, teams.len + 1)
	scoreDisplay.Update(members.len, score)

/team/proc/UpdateScore()
	scoreDisplay.Update(members.len, score)

/team/proc/Full()
	if(members.len >= 2)
		var/total
		var/avgSize
		for(var/team/T in teams)
			total += T.members.len
			avgSize += T.sizeMod
		avgSize /= teams.len
		total /= teams.len
		total *= sizeMod / avgSize
		if(members.len <= total)
			return 0
		else
			return 1
	else
		return 0

/team/proc/SecurityChannel(M as mob)
	return range(7, respawn) + M

/team/proc/CreateSelect()
	var/obj/select/teamSelect/S
	var/obj/O
	S = new(locate(8, 8 - teams.len, 4))
	S.icon = 'team_title.dmi'
	S.icon_state = "[name]3"
	S.name = title
	S.team = src
	S.pixel_x = title_offset - 10
	S.pixel_y = teams.len * -6
	selects.Add(S)
	for(var/i = 0, i <= 2, i++)
		O = new()
		O.icon = 'team_title.dmi'
		O.icon_state = "[name][i]"
		O.pixel_x = i * 32 - 96
		S.overlays.Add(O)
		del(O)
	for(var/i = 4, i <= 7, i++)
		O = new()
		O.icon = 'team_title.dmi'
		O.icon_state = "[name][i]"
		O.pixel_x = (i - 3) * 32
		S.overlays.Add(O)
		del(O)
	S = new(locate(4, 8 - teams.len, 4))
	S.icon = comm:icon
	S.icon_state = comm:icon_state
	S.pixel_x = -10
	S.pixel_y = 6 - teams.len * 6
	S.name = title
	S.team = src
	selects.Add(S)
	del(O)

/team/proc/TeamShopLists()
	set background = 1
	var/obj/shop/S
	while(!shopItems.len)
		sleep(1)
	for(var/I in shopItems)
		S = shopItems[I]
		if(!(S.itemType in bannedItems))
			if(istype(S.item, /obj/item/equippable/weapon))
				weaponList.Add(new/obj/shop(null, S.itemType))
			else if(istype(S.item, /obj/item/equippable/armor))
				armorList.Add(new/obj/shop(null, S.itemType))
			else if(istype(S.item, /obj/item/equippable/misc))
				equipmentList.Add(new/obj/shop(null, S.itemType))
			else if(istype(S.item, /obj/item/useable/installation))
				installationList.Add(new/obj/shop(null, S.itemType))
			else if(istype(S.item, /obj/item/ammo))
				ammoList.Add(new/obj/shop(null, S.itemType))
			else if(istype(S.item, /obj/item/useable))
				itemList.Add(new/obj/shop(null, S.itemType))
			else if(istype(S.item, /obj/item/vehicle))
				vehicleList.Add(new/obj/shop(null, S.itemType))
	totalShopList = weaponList + armorList + equipmentList + installationList + ammoList + itemList + vehicleList

/team/Del()
	for(var/S in totalShopList)
		del(S)
	weaponList.Cut()
	armorList.Cut()
	equipmentList.Cut()
	installationList.Cut()
	ammoList.Cut()
	itemList.Cut()
	totalShopList.Cut()
	. = ..()
