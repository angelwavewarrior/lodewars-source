/team
	var/sizeMod = 1
	var/score = 0
	var/list/members = list()
	var/list/allMembers = list()
	var/bannedItems
	var/list/weaponList = list()
	var/list/armorList = list()
	var/list/equipmentList = list()
	var/list/ammoList = list()
	var/list/installationList = list()
	var/list/itemList = list()
	var/list/vehicleList = list()
	var/list/totalShopList
	var/comm
	var/title
	var/title_offset
	var/list/selects = list()
	var/bin
	var/loadingZone
	var/sideZone
	var/obj/hud/score/scoreDisplay
	var/desc
	var/fontColor
	var/respawn
	var/expBonus

/team/black
	name = "black"
	sizeMod = 0.9
	fontColor = "#333333"
	title = "The Jagrinki"
	title_offset = -2
	desc = "The Jagrinki are a mafia group whose seedy tendrils extend into virtually every enterprise imaginable, from legitimate businesses to the most appalling racketeering operations imaginable. Although not as well-funded as the competition, their dirty underhanded tactics garner them a nice chunk of cash for their employees' paychecks. The Jagrinki naturally have little use for laws or regulations of any sort, and can supply its operatives with all sorts of highly illegal equipment. The Jagrinki's extensive mob network allows them to cover up the murders its workers commit with relative ease."
	bannedItems = list(/obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/force_harness, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/speed_boosters, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/hoverpack, /obj/item/equippable/misc/disruptor_pick, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/installation/beacon, /obj/item/useable/installation/microrefinery, /obj/item/useable/planted/shock_mine, /obj/item/equippable/weapon/plasma_rifle, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/portable_decontamination_unit, /obj/item/equippable/armor/combat_suit, /obj/item/vehicle/flathauler, /obj/item/useable/nonexpendable/teleport, /obj/item/vehicle/drill)
	expBonus = "kill"

/team/blue
	name = "blue"
	sizeMod = 1.1
	title = "Dailim Mining Inc."
	fontColor = "#0000FF"
	desc = "Dailim Mining Inc. is a relatively new mining venture funded largely from the personal vaults of fantastically wealthy multitrillionaire Gazno Dailim III. Dailim has poured untold billions into purchasing, developing, and--so rumor has it--ocassionally stealing the latest mining technology known to the galaxy to ensure that Dailim Mining is supplied with the industry's best, although the company's single-minded drive has caused other useful equipment to fall by the wayside. Dailim Mining is heavily focused on the bottom line and is known to give extra reward to miners who bring in large quantities of ore."
	bannedItems = list(/obj/item/equippable/weapon/azzik, /obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/sonic_disruptor, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/blast_jacket, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/cerebral_booster, /obj/item/useable/nonexpendable/com_scanner, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/planted/alarm, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/teleport)
	expBonus = "deposit"

/team/gold
	name = "gold"
	fontColor = "#CCCC00"
	title = "Omni-Corp Mining Division"
	title_offset = 2
	desc = "Omni-corp is a vast mega-corporation with subsidiaries in virtually every aspect of galactic industry. Like a giant space amoeba, Omni-corp has gradually absorbed competitor after competitor, giving them a galaxy-wide market presence. Its business strategy is largely like an amoeba, as well--Omni-corp draws on its vast subsidiaries to outfit its operations, giving them a tremendous variety of equipment available but regrettably lacking in any real specialization."
	bannedItems = list(/obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/sonic_disruptor, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/cerebral_booster, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/installation/microrefinery, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/teleport)

/team/green
	name = "green"
	sizeMod = 1.2
	title = "Pan-Galactic Eco Mining Cooperative"
	title_offset = -1
	fontColor = "#00CC00"
	desc = "The Pan-Galactic EMC is an ecologically aware cooperative with no particular national loyalties dedicated to responsible, world-friendly mining measures and peaceful noncompetitive practices. Or, as often derided by its competitors, they are space hippies. The EMC pioneers the use of many useful and environmentally sound technologies that are either unavailable to or unused by its competitors, but strict pro-environment policy prohibits the use of many more damaging or dangerous pieces of equipment. The EMC favors the use of honest, personal labor over high explosives or heavy digging tools and rewards miners who follow their lead."
	bannedItems = list(/obj/item/equippable/weapon/azzik, /obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/magpistol, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/speed_boosters, /obj/item/useable/nonexpendable/com_scanner, /obj/item/equippable/misc/power_pack, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/generator, /obj/item/useable/planted/shock_mine, /obj/item/useable/planted/alarm, /obj/item/useable/explosive/blast_pack, /obj/item/useable/installation/microrefinery, /obj/item/useable/nonexpendable/teleport)
	expBonus = "dig"

/team/orange
	name = "orange"
	sizeMod = 1.4
	fontColor = "#FF9900"
	title = "Tygeron Mineral Extraction Corporation"
	title_offset = -2
	desc = "The TME Corp is a long-standing but backwards mining cartel which has dominated interplanetary mining operations for centuries. Although huge and capable of employing a larger and better-paid workforce than competing companies, its entrenched position of power has lulled TME Corp into a false sense of security, and considering itself invincible it has refused to update the mining equipment it issues, rigidly insisting on using outdated technology while competitors embrace newer, more efficient equipment. The simple, brutish minds behind Tygeron corp encourage its workers to use heavy physical \"persuasion\" against competitors, although they do not condone actual murder."
	bannedItems = list(/obj/item/equippable/weapon/laser_pistol, /obj/item/equippable/weapon/sonic_disruptor, /obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/armor/shield_belt, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/force_harness, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/power_belt, /obj/item/equippable/misc/power_bracers, /obj/item/equippable/misc/hoverpack, /obj/item/equippable/misc/power_pack, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/speed_boosters, /obj/item/equippable/misc/hyper_belt, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/speed_boosters, /obj/item/useable/healing/bio_kit, /obj/item/useable/pill, /obj/item/useable/nonexpendable/com_scanner, /obj/item/equippable/misc/power_pack, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/generator, /obj/item/useable/planted/shock_mine, /obj/item/useable/planted/alarm, /obj/item/useable/explosive/micro_charge, /obj/item/useable/installation/microrefinery, /obj/item/useable/installation/med_station, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/installation/telepad, null, /obj/item/useable/installation/teleconsole, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/portable_decontamination_unit, /obj/item/useable/nonexpendable/teleport, /obj/item/vehicle/drill)
	expBonus = "attack"

/team/purple
	name = "purple"
	fontColor = "#CC00CC"
	title = "Mezerit Excavation Company"
	title_offset = 2
	desc = "The ME Company is a secretive organization representing the mining interests of Mezlak-4. The Mezers are an elusive, high-technology race who live in deep underground bunkers with as little contact with the rest of the galaxy as they can manage, funding a few small outside labor companies to supply the worlds of Mezlak with raw materials. Little is known of them, save that they have an unparalleled understanding of advanced matter transference technology. Mezerit focuses heavily on intelligence gathering activities and encourages its workers to scout out veins with as much vigor as possible."
	bannedItems = list(/obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/force_harness, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/blast_jacket, /obj/item/equippable/armor/shield_belt, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/blast_jacket, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/power_bracers, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/cerebral_booster, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/installation/microrefinery, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/vehicle/flathauler, /obj/item/vehicle/drill)
	expBonus = "find"

/team/red
	name = "red"
	sizeMod = 0.8
	title = "Imperial Kadazil Mining Federation"
	title_offset = 0
	desc = "The IKMF is a powerful state-controlled mining conglomerate run by the militaristic Kadazil Empire. As the materials extracted are used primarily to feed the powerful Kadazillian war machine, it is considered a subsidiary of the armed forces; indeed, the IKMF hires workers as much for their muscle and skill with firearms as it does their familiarity with mining practices, and from the equipment it issues one can hardly tell if it is equipping soldiers or miners. The IKMF is fiercely territorial and encourages its workers to defend its outposts with lethal force."
	fontColor = "#FF0000"
	bannedItems = list(/obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/misc/speed_boosters, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/hoverpack, /obj/item/equippable/misc/sonic_shovel, /obj/item/equippable/misc/disruptor_pick, /obj/item/useable/nonexpendable/com_scanner, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/installation/beacon, /obj/item/useable/installation/microrefinery, /obj/item/equippable/weapon/rad_rifle, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/portable_decontamination_unit, /obj/item/useable/nonexpendable/teleport, /obj/item/vehicle/drill)
	expBonus = "trespass"

/team/white
	name = "white"
	sizeMod = 0.7
	title = "Besseltech Enterprises"
	fontColor = "#CCCCCC"
	desc = "Besseltech Enterprises is a cutting-edge research institute which has recently begun pursuing a policy of active mining venture as a means to simultaneously supply its needs for exotic minerals as well as test out its hazardous environment equipment. Bessel maintains a small but well-funded mining force, equipped with state-of-the-art technology, but has only a small presence in the interplanetary field of mining and cannot compete on as many fronts as some of its competitors. Besseltech takes its experimental testing role seriously and rewards miners who make use of its extensive array of gadgets and high-tech equipment."
	bannedItems = list(/obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/power_bracers, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/installation/microrefinery, /obj/item/vehicle/flathauler, /obj/item/vehicle/drill)
	expBonus = "use"

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
