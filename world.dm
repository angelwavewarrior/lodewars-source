/world/New()
	LoadFilter()
	LoadAdmins()
	LoadMOTD()
	LoadBanned()
	InitMasterHUD()
	InitializeShop()
	spawn(15) GenerateMap()
	return ..()

/proc/GetTurf(O as mob|obj|turf|area)
	if(O && !isturf(O))
		return GetTurf(O:loc)
	else
		return O

/proc/GetMob(mob/M as mob)
	. = M
	if(istype(M, /mob) && M.master)
		. = M.master

/*/proc/IsHead(mob/M as mob)
	. = null
	if(istype(M, /mob) && M.master && M.master.head == M)
		. = M.master
	else if(!istype(M, /mob) || !M.master && !M.head)
		. = M

/proc/HeadForMob(mob/M as mob)
	if(ismob(M) && M.head)
		. = M.head
	else
		. = M*/

/proc/Him(mob/M as mob)
	if(M.client.gender == "female")
		return "her"
	else
		return "him"

/proc/His(mob/M as mob)
	if(M.client.gender == "female")
		return "her"
	else
		return "his"

/proc/Proper(text)
	if(length(text) > 1)
		return uppertext(copytext(text, 1, 2)) + copytext(text, 2, 0)
	else
		return uppertext(text)

/proc/CanReach(Source as mob|obj|turf|area, Target as mob|obj|turf|area)
	var/obj/O
	O = new(GetTurf(Source))
	O.density = 1
	O.Move(GetTurf(Target))
	if(O.loc == GetTurf(Target))
		. = 1
	else
		. = 0
	del(O)

/proc/GetMultiDist(mob/A as mob, B as mob|obj|turf|area)
	var/minDist
	minDist = get_dist(A, B)
	for(var/mob/C in A.children)
		minDist = min(minDist, get_dist(C, B))
	return minDist

/obj/timer/proc/TickTock()
	overlays.Cut()
	time--
	icon_state = num2text(time % 10)
	if(time >= 10)
		var/obj/hud/H = new()
		H.icon = icon
		H.icon_state = num2text(round(time / 10))
		H.pixel_x = -8
		H.layer = 15
		overlays.Add(H)
		del(H)
	if(time > 0)
		spawn(600) TickTock()
		if(time == 5)
			players << "<b>Only five minutes remaining!</b>"
		else if(time == 1)
			players << "<b>One minute left--hurry back to your base to cash in your ore!</b>"
	else
		EndMap()

/obj/item/DblClick()
	Describe(usr)

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

/atom/movable/Bump(atom/O as mob|obj|turf|area)
	O.Bumped(src)

/atom/movable/proc/Teleport(destination as turf)
	var/I
	var/M
	var/mob/P
	I = image('FX.dmi', GetTurf(loc), "teleport", 6)
	M = image('FX.dmi', src, "teleport", 6)
	P = src
	flick("teleport", I)
	flick("teleport", M)
	players << I
	players << M
	. = Move(destination)
	if(istype(P, /mob/player))
		if(P.vehicle)
			P.vehicle.driver = null
			P.vehicle = null
	spawn(10)
		del(I)
		del(M)

/atom/proc/Bumped(O as mob|obj)
	. = 0

/atom/Click()
	var/mob/player/M
	var/turf/T
	M = usr
	T = GetTurf(src)
	if(loc)
		if(istype(M, /mob/player))
			var/obj/item/O = locate() in T
			var/mob/P = locate() in T
			if(O && O.planted)
				O = locate() in T.contents - O
			if(O && M.mode == "get" && M.CanGet(O))
				O.get()
			else if(P && M.mode == "attack" && P != M && !(P in M.children) && get_dist(P, M) <= 1)
				P:attack()
			else if(M.activeItem)
				if(istype(M.activeItem, /obj/item/equippable/weapon))
					var/W = M.activeItem
					W:Fire(GetTurf(src))
				else if(istype(M.activeItem, /obj/item/useable))
					var/U = M.activeItem
					U:Use(src)
			else
				var/obj/item/useable/installation/I = locate() in T:contents
				var/obj/item/vehicle/V = locate() in T:contents
				if(I && I.planted)
					if(M.mode == "default" && get_dist(I, M) <= 1)
						I.UsedBy(M)
					else if(M.mode == "attack" && I.team != M.team && get_dist(I, M) <= 1)
						M.Attack(I)
				if(V)
					if(V.driver)
						if(M.mode == "attack" && V.driver.team != M.team && get_dist(V, M) <= 1)
							M.Attack(V)
					else
						if(M.mode == "default" && get_dist(V, M) <= 1)
							V.board()
