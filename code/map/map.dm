/map
	var/bgRadiation = 0
	var/obj/timer/timer
	var/max
	var/mainOre
	var/list/waterGrid = new/list(260, 260)
	var/waterContent = "random"
	var/size = "random"
	var/list/teams
	var/cash
	var/rank
	var/saved = 1

/vein
	var/X
	var/Y
	var/num
	var/ore
	var/richness

/map/proc/Readings()
	var/output
	output = "<b>Environmental variables:</b>\n"
	output += "Radiation level: [map.RadLevel()]\n"
	output += "Map area: [map.size]\n"
	output += "Dominant ore type: [map.OreType()]\n"
	output += "Water content: [map.waterContent]\n"
	if(map.timer) output += "UMA deadline: [map.timer.time] minutes\n"
	return output

/map/proc/OreType()
	switch(mainOre)
		if(/obj/item/ore/asbylite) return "asbylite"
		if(/obj/item/ore/petrite) return "petrite"
		if(/obj/item/ore/grezlorite) return "grezlorite"
		if(/obj/item/ore/hezerite) return "hezerite"
		if(/obj/item/ore/draxilite) return "draxilite"
		if(/obj/item/ore/necite) return "necite"
		if(/obj/item/ore/kaburite) return "kaburite"

/map/proc/RadLevel()
	if(bgRadiation)
		switch(log(2, bgRadiation))
			if(-1) return "negligible"
			if(0) return "low"
			if(1) return "medium"
			if(2) return "high"
			if(3) return "<b>very high</b>"
			if(4) return "<b>dangerously high!</b>"
	else
		return "random"

/map/proc/Lake(X, Y, size, count, stretch, vertical)
	var/minX
	var/maxX
	var/minY
	var/maxY
	minX = max(7, X - size - stretch * !vertical)
	maxX = min(map.max, X + size + stretch * !vertical)
	minY = max(7, Y - size - stretch * vertical)
	maxY = min(map.max, Y + size + stretch * vertical)
	for(var/i = minX, i <= maxX, i++)
		for(var/j = minY, j <= maxY, j++)
			if(sqrt(max(0, abs(X - i) - stretch) ** 2 + max(0, abs(Y - j) - stretch) ** 2) + rand(-2, 2) <= size)
				waterGrid[i][j] = 1

/map/proc/GenerateLakes(N, size)
	var/lakes
	var/X
	var/Y
	lakes = round(rand((N - 1) ** 2 * (size / 5 + 1), (N - 1) ** 2 * (size / 5 + 1) * 1.5))
	waterGrid = new/list(max, max)
	for(var/i = 1, i <= lakes, i++)
		X = rand(14, max - 7)
		Y = rand(14, max - 7)
		Lake(X, Y, rand(N + 5, N + 10), rand(0, 10), rand(0, 1))

/proc/SpawnVein(oreType, X, Y, richness, amount, Vein)
	var/turf/T
	var/obj/item/ore/O
	var/randX
	var/randY
	var/OType
	var/value
	var/vein/V
	var/oreName
	O = new oreType
	V = new()
	oreName = O.name
	del(O)
	for(var/i = 1, i <= amount, i++)
		randX = rand(-7, 7)
		randY = rand(-7, 7)
		T = locate(X + randX, Y + randY, 2)
		if(T && !istype(T, /turf/rock) && !istype(T, /turf/base) && !T.contents.len)
			value = rand(0, round((randX ** 2 + randY ** 2) ** 0.5)) / richness
			if(value < 2)
				value = "rich"
			else if(value < 4)
				value = "medium"
			else
				value = "poor"
			OType = "[oreType]/[value]"
			O = new OType(T)
			if(O.loc != T)
				O.loc = T
			T.damage -= 10
			T.solidness += 10
			if(value == "rich")
				O.value *= 3
			else if(value == "medium")
				O.value *= 2
			. += O.value
			O.icon_state = value
			O.vein = V
			O.name = "[O.name] [oreName] ore"
			if(istype(T, /turf/water))
				O.layer = AREA_LAYER
				O.verbs.Remove(/obj/item/verb/help)
			T.Update()
	if(oreType == /obj/item/ore/kaburite)
		for(T in block(locate(max(1, X - 10), max(1, Y - 10), 2), locate(min(world.maxx, X + 10), min(world.maxy, Y + 10), 2)))
			if(!istype(T, /turf/rock))
				T.radioactivity += (15 - ((X - T.x) ** 2 + (Y - T.y) ** 2) ** 0.5) * richness
	V.X = X
	V.Y = Y
	V.ore = oreType
	V.richness = richness
	veins.Add(V)

/proc/SeedOre(mapSize, dominantType)
	var/veins
	var/X
	var/Y
	var/dist
	var/oreType
	veins = rand((map.max - 4) ** 2 / 500 + 5, (map.max - 4) ** 2 / 400 + 5)
	veinsFound.Cut()
	for(var/i = 1, i <= veins, i++)
		X = rand(7, map.max)
		Y = rand(7, map.max)
		dist = ((X - 80.5) ** 2 + (Y - 80.5) ** 2) ** 0.5 * 2.5
		dist += 15
		oreType = pick(dist * 3.5 + 100;/obj/item/ore/asbylite, dist * 2.5 + 100;/obj/item/ore/petrite, dist * 0.66 + 30;/obj/item/ore/grezlorite, dist + 100;/obj/item/ore/hezerite, dist * 0.33 + 30;/obj/item/ore/draxilite, 100;/obj/item/ore/necite, 100 - dist * 0.33;/obj/item/ore/kaburite)
		if(dominantType)
			if(rand(1, 6) == 6) oreType = dominantType
		. += SpawnVein(oreType, X, Y, (11 - round(rand(1, 120) ** 0.5)) / 5, rand(20, 30), i)

/proc/CreateBase(X, Y, Dir, Team)
	var/xDir
	var/yDir
	var/spinDir
	var/Loc
	var/oldLoc
	var/T
	var/turf/U
	xDir = turn(Dir, 90)
	yDir = turn(Dir, 180)
	Loc = locate(X, Y, 2)
	for(var/i = 1, i <= 15, i++)
		oldLoc = Loc
		for(var/j = 1, j <= 9, j++)
			T = locate(i, j, 1)
			spinDir = 0
			while(turn(SOUTH, spinDir) != T:dir)
				spinDir += 45
			for(var/obj/O in Loc)
				O.loc = null
				del(O)
			T = new T:type(Loc)
			T:dir = turn(Dir, spinDir)
			T:team = Team
			T:radioactivity = 0
			Loc = get_step(Loc, yDir)
			if(!istype(T, /turf/base))
				T:Update()
				T:Initialize()
			for(var/D in list(1, 2, 4, 8))
				U = get_step(T, D)
				spawn(1) U.Update()
		Loc = get_step(oldLoc, xDir)

/proc/GenerateMap()
	set background = 1
	var/mapSize
	var/sizes
	var/mapWater
	var/list/wetness
	mapSize = rand(1, 5)
	sizes = list("tiny", "small", "medium", "large", "huge", "gigantic")
	mapWater = rand(2, 4)
	wetness = list("none", "low", "moderate", "high", "very high", "extreme")
	if(players.len <= 4)
		if(mapSize >= 4) mapSize -= 2
	else if(players.len <= 10)
		if(mapSize == 5) mapSize = 3
	else if(players.len >= 14)
		if(mapSize == 1) mapSize = 3
		if(mapSize == 5 && rand(0, 1)) mapSize = 4
	else if(players.len >= 20)
		if(mapSize < 3) mapSize += 2
	else if(players.len >= 27)
		if(mapSize < 3) mapSize += 3
	map = new/map()
	if(!nextMap)
		map = new/map()
		map.size = sizes[mapSize]
		map.waterContent = wetness[mapWater]
		map.bgRadiation = 2 ** rand(-1, 4)
		while(map.bgRadiation >= 4 && rand(0, 1)) map.bgRadiation /= 2
		map.mainOre = pick(13;/obj/item/ore/asbylite, 20;/obj/item/ore/petrite, 16;/obj/item/ore/grezlorite, 16;/obj/item/ore/hezerite, 15;/obj/item/ore/draxilite, 12;/obj/item/ore/necite, 8;/obj/item/ore/kaburite)
		map.timer = new/obj/timer()
		map.timer.time = rand(mapSize * 5 + 20, mapSize * 5 + 30)
		if(mapSize == 4) map.timer.time += 10
		if(mapSize == 5) map.timer.time += 20
		map.timer.start = map.timer.time
	else
		map = new/map()
		map.size = nextMap.size
		map.teams = nextMap.teams
		map.bgRadiation = nextMap.bgRadiation
		map.waterContent = nextMap.waterContent
		if(!map.mainOre)
			map.mainOre = pick(13;/obj/item/ore/asbylite, 20;/obj/item/ore/petrite, 16;/obj/item/ore/grezlorite, 16;/obj/item/ore/hezerite, 15;/obj/item/ore/draxilite, 12;/obj/item/ore/necite, 8;/obj/item/ore/kaburite)
		if(map.size == "random")
			map.size = sizes[mapSize]
		else
			map.size = nextMap.size
		if(map.waterContent == "random")
			map.waterContent = wetness[mapWater]
		else
			map.waterContent = nextMap.waterContent
			mapWater = wetness.Find(map.waterContent)
		if(map.bgRadiation == 0)
			map.bgRadiation = 2 ** rand(-1, 4)
			while(map.bgRadiation >= 4 && rand(0, 1)) map.bgRadiation /= 2
		else
			map.bgRadiation = nextMap.bgRadiation
		map.cash = nextMap.cash
		map.rank = nextMap.rank
		map.saved = nextMap.saved
		if(!nextMap.timer)
			map.timer = new/obj/timer()
			map.timer.time = rand(mapSize * 5 + 20, mapSize * 5 + 30)
			if(mapSize == 4) map.timer.time += 10
			if(mapSize == 5) map.timer.time += 20
			map.timer.start = map.timer.time
		else
			map.timer = new/obj/timer()
			map.timer.time = nextMap.timer.time
			map.timer.start = map.timer.time
		// Map settings cover one round.
		nextMap = null
	map.timer.TickTock()
	switch(map.size)
		if("tiny") map.max = 94
		if("small") map.max = 134
		if("medium") map.max = 174
		if("large") map.max = 214
		if("huge") map.max = 254
	sleep(2)
	map.GenerateLakes(mapWater, mapSize)
	ClearMap()
	SeedOre(mapSize, map.mainOre)
	GenerateTeams()
	players << "Round started!"
	players << map.Readings()
	spawn(5)
		for(var/mob/observer/O in players + world)
			if(!O.loc)
				O.loc = locate(7, 7, 3)
				O.HUDTime()

/proc/EndMap()
	var/payout
	var/highScore
	var/tie
	var/save
	var/team/winner
	var/mob/observer/O
	highScore = -1
	players << "<b>Round finished!</b>"
	for(var/team/T in teams)
		if(T.score > highScore)
			highScore = T.score
			winner = T
			tie = 0
		else if(T.score == highScore)
			tie = 1
	if(tie)
		players << "No clear winner has emerged from this round, and the claim remains in dispute."
	else
		players << "The round is won by the victorious [winner.title]!"
	for(var/mob/M in world)
		if(!M.master && !M.client)
			del(M)
	for(var/team/T in teams)
		if(T.members.len)
			for(var/mob/player/P in T.members)
				payout = T.score / T.members.len
				payout = round(payout * (P.rank / 100 + 0.1))
				payout = round(payout * (P.activity / 100))
				payout = round(payout * ((P.playTime * 9 + 100) / 1000))
				if(winner && T != winner)
					payout = round(payout * 0.9)
				else if(winner && T == winner)
					payout = round(payout * 1.1)
				if(map.saved)
					if(P.activity > 70)
						P << "Good work! Your paycheck comes out to $[payout]."
					else if(P.activity > 15)
						P << "Your boss caught you slacking on the job and docked your pay. You only get $[payout]."
						P.experience -= P.rank * 100
						if(P.activity < 40)
							P.experience -= P.rank * 150
					else
						P << "Your boss glares at you for not working and tears up your paycheck right in front of your face."
						payout = 0
						P.experience -= P.rank * 150
					if(P.debt)
						if(P.debt <= payout)
							payout -= P.debt
							P.debt = 0
							P << "A portion of your pay goes towards paying off your shop loan."
						else
							P.debt -= payout
							payout = 0
							P.debt = round(P.debt * 1.1)
							P << "Unfortunately, your pay is confiscated to pay back your debts."
					P.cash += payout
					if(P.cash > 99999)
						P.cash = 99999
					if(isnum(P.experience) && P.rank < 30)
						if(P.experience > P.rank * 2 ** (P.rank / 3.25) * 1000)
							P.rank++
							P << "The mining foreman walks up to you as you exit the mines. <i>\"Hey, youse did a little better down dere then dose udder slugs. Congraddulations, yer promoted--now get back to work!\"</i>"
						else if(P.experience > round((P.rank * 2 ** (P.rank / 3.25) * 1000 + (P.rank - 1) * 2 ** ((P.rank - 1) / 3.25) * 1000) / 2))
							P << "The mining foreman walks up to you as you exit the mines. <i>\"Not a bad piece o work you dids down dere today. Keep it up and youse might be promoted to maggot someday.\"</i>"
						if(P.rank > 1 && P.experience < (P.rank - 2) * 2 ** ((P.rank - 2) / 3.25) * 1000)
							P << "The mining foreman storms angrily up to you as you exit the mines. <i>\"Oh, great, just great. D'you have any </i>idea<i> how much trouble you're in, you miserable lil puke? If I had my way, see, you'd never be workin around here again, but lucky for you youse gets anudder chance. Just don't expect t'see a paycheck that large for a loooong time, pal.\"</i>"
							while(P.rank > 1 && P.experience < (P.rank - 2) * 2 ** ((P.rank - 2) / 3.25) * 1000)
								P.rank--
							P.experience -= 2500
						else if(P.rank > 1 && P.experience < (P.rank - 1) * 2 ** ((P.rank - 1) / 3.25) * 1000 + -500)
							P << "The mining foreman walks up to you as you exit the mines. <i>\"You lazy bum! You oughta be glad youse has a job at all, the way youse been workin--or, excuse me, </i>not<i> workin, you lousy screwup.\"</i>"
						P.experience = max(0, P.experience)
				else
					P << "You score [payout] points for your work."
	// Before the teams go: Refunds compares the holder's team with the buyer's.
	Refunds()
	for(var/team/T in teams)
		del(T.comm)
		for(var/S in T.selects)
			del(S)
		del(T)
	teams.Cut()
	del(money)
	money = new/list()
	if(map.saved)
		save = 1
	del(map)
	for(var/mob/player/P in players)
		if(P.recovered)
			P << "$[P.recovered] worth of equipment returned safely."
			P.cash += P.recovered
			P.HUDUpdate("cash", 5)
		if(P.insurance)
			P << "Recovered $[P.insurance] from insurance on lost or stolen items."
			P.cash += P.insurance
			P.HUDUpdate("cash", 5)
		P.recovered = 0
		P.insurance = 0
	for(var/mob/P in players)
		P.loc = null
		spawn(0)
			O = new(null, 1)
			O.name = P.name
			O.gender = P.gender
			O.loc = null
			O.HUDMode = P.HUDMode
			P.client.screen.Cut()
			P.switching = 1
			if(istype(P, /mob/player))
				if(save)
					P:SaveCharacter(1)
			if(P)
				O.key = P.key
				del(P)
	spawn(200) GenerateMap()

/proc/ClearMap()
	set background = 1
	var/turf/T
	var/list/tel
	signals.Cut()
	for(var/P in teleports)
		tel = teleports[P]
		tel.Cut()
		del(tel)
	teleports.Cut()
	for(var/X = 6, X <= map.max + 6, X++)
		for(var/Y = 6, Y <= map.max + 6, Y++)
			T = locate(X, Y, 2)
			for(var/atom/movable/A in T.contents)
				A.loc = null
				del(A)
			if(X == 6 || Y == 6 || X >= map.max + 1 || Y >= map.max + 1)
				new/turf/rock(T)
			else
				if(map.waterGrid[X][Y])
					new/turf/water(T)
				else
					new/turf/dirt(T)
	for(var/X = 6, X <= map.max + 6, X++)
		for(var/Y = 6, Y <= map.max + 6, Y++)
			T = locate(X, Y, 2)
			T.Initialize()
			T.Update()
	return 1

/proc/Refunds()
	for(var/obj/item/I in world)
		var B, P
		if(I && I.loc && I.buyer && !istype(I, /obj/item/ore))
			B = locate(I.buyer)
			// Ammo value is per pack of amt rounds.
			var/V = I.value
			if(istype(I, /obj/item/ammo))
				V = I.value * I.quantity / I:amt
			if(B)
				if(ismob(I.loc))
					P = I.loc
					if(P:team == B:team)
						B:recovered += round(V * 0.8)
					else
						P:recovered += round(V * 0.4)
						B:insurance += round(V * 0.4)
				else
					B:recovered += round(V * 0.6)
			del(I)
