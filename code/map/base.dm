/turf/base
	icon = 'base.dmi'

/turf/base/banner
	icon = 'banner.dmi'
	icon_state = "red"
	density = 1

/turf/base/bin
	icon_state = "ore bin"
	density = 1
	var/list/ores = list()

/turf/base/computer
	icon_state = "computer"
	density = 1

/turf/base/door
	icon_state = "door"
	var/door

/turf/base/floor
	icon_state = "floor"

/turf/base/light
	icon_state = "lamp"
	density = 1

/turf/base/loadZone
	name = "loading zone"
	icon_state = "loadbottom"
	density = 1

/turf/base/spawnArea
	icon_state = "floor"

/turf/base/tank1
	name = "atmospheric filter"
	icon_state = "tank1"
	density = 1

/turf/base/tank2
	name = "atmospheric filter"
	icon_state = "tank2"
	density = 1

/turf/base/wall
	icon_state = "wall"
	opacity = 1
	density = 1

/turf/base/loadZone/end
	icon_state = "loadtop"

/turf/base/loadZone/main

/turf/base/loadZone/middle
	icon_state = "loadmiddle"

/turf/base/spawnArea/spawnPoint
	icon_state = "respawn"

/turf/base/Clear()
	new/turf/dirt(src)

/turf/base/loadZone/middle/New()
	spawn(1)
		if(team) team.loadingZone = src

/turf/base/loadZone/end/New()
	spawn(1)
		if(team) team.sideZone = src

/turf/base/loadZone/Enter(V as obj)
	if(istype(V, /obj/item/vehicle))
		density = 0
		. = ..()
		density = 1
	else
		. = ..()

/turf/base/banner/New()
	icon = 'base.dmi'
	icon_state = "wall"
	. = ..()
	spawn(1)
		if(team) overlays.Add(icon('banner.dmi', team.name))

/turf/base/computer/Click()
	if(get_dist(usr, src) <= 1) readout()

/turf/base/computer/verb/readout()
	set src in range(1)
	if(istype(usr, /mob/player))
		usr << map.Readings()

/turf/base/bin/Click()
	if(get_dist(usr, src) <= 1)
		deposit()
	else
		..()

/turf/base/bin/New()
	spawn(1)
		if(team) team.bin = src

/turf/base/bin/Del()
	for(var/obj/O in ores)
		O.loc = null
		ores.Remove(O)
		del(O)

/turf/base/bin/proc/Dump()
	var/list/turfs
	var/O
	turfs = list()
	for(var/D in list(1, 2, 4, 8, 5, 6, 9, 10))
		if(CanReach(src, get_step(src, D)))
			turfs.Add(D)
	for(var/i = 1, i <= min(ores.len, rand(5, 10)), i++)
		if(turfs.len && ores.len)
			O = pick(ores)
			ores.Remove(O)
			team.score -= O:value
			O:Move(get_step(src, pick(turfs)))
	team.UpdateScore()

/turf/base/bin/verb/deposit()
	set src in orange(1)
	var/obj/item/ore/O
	var/mob/player/M
	O = locate() in usr
	M = usr
	if(M && istype(M, /mob/player) && M.team && M.team == team)
		var/R
		while(O)
			O.Move(src)
			while(O.quantity)
				R = new O.type(locate(1, 1, 1))
				R:value = O.value
				R:name = O.name
				R:icon = O.icon
				R:icon_state = O.icon_state
				R:invisibility = 0
				ores.Add(R)
				M.team.score += O.value
				M.experience += M.strength + 10
				if(M.team.expBonus == "deposit")
					M.experience += 15
				O.quantity--
				M << "You deposit the [R:name]."
			O.loc = null
			M.inventory.Remove(O)
			del(O)
			O = locate() in usr
		M.HUDUpdate("carry")
		team.UpdateScore()

/turf/base/bin/verb/steal()
	set src in orange(1)
	var/mob/player/M
	M = usr
	if(istype(M, /mob/player) && M.act_delay <= world.time)
		if(usr.team != team)
			if(ores.len)
				var/O = pick(ores)
				if(O && M.Encumberance() + 1 <= M.carry)
					M << "You snitch the [O]."
					team.score -= O:value
					team.UpdateScore()
					ores.Remove(O)
					O:Move(M)
					M.act_delay = world.time + (12 - M.dexterity / 2)
		else
			usr << "Try stealing from the enemy team instead!"

/turf/base/spawnArea/Enter(atom/M as mob)
	M = GetMob(M)
	if(istype(M, /mob/player) && M.team == team)
		return 1
	else
		return ..()

/turf/base/spawnArea/New()
	. = ..()
	spawn(1)
		if(z != 1 && istype(get_step(src, NORTH), /turf/base/spawnArea) && istype(get_step(src, EAST), /turf/base/spawnArea))
			new/turf/base/spawnArea/spawnPoint(src, team)

/turf/base/spawnArea/spawnPoint/Enter(atom/M as mob)
	M = GetMob(M)
	if(istype(M, /mob/player) && M.team == team)
		return 1
	else
		return ..()

/turf/base/spawnArea/spawnPoint/New(loc, Team)
	spawn(1)
		if(!team)
			team = Team
		if(team)
			teamSpawns[team.name] = src
			signal = "[team.name] home base"
			signals.Add(src)
			team.respawn = src
			teleports[team.name] = list("Home base" = src)

/turf/base/door/Enter(O as mob|obj)
	var/atom/M
	var/obj/item/vehicle/V
	M = O
	V = O
	if(istype(V, /obj/item/vehicle))
		if(V.driver)
			M = V.driver
	if(ismob(O))
		M = GetMob(M)
		if(M.team == team)
			density = 0
			overlays.Cut()
			return 1
		else
			return 0
	else
		return ..()

/turf/base/door/Exited(O as mob|obj)
	spawn(2)
		if(contents.len == 0)
			density = 1
			overlays.Add(icon('base.dmi', "door"))

/turf/base/door/New()
	icon_state = "floor"
	overlays.Add(icon('base.dmi', "door"))
