var/image/eFence = image('barrier.dmi', null, "top", 7)
var/list/boloIcons = list('bolo_00.dmi', 'bolo_01.dmi', 'bolo_10.dmi', 'bolo_11.dmi', 'bwater_00.dmi', 'bwater_10.dmi', 'bwater_01.dmi', 'bwater_11.dmi')
var/list/filter = list()
var/list/observers = list()
var/list/signals = list()
var/list/teams = list()
var/list/weaponsCatalog = typesof(/obj/item/equippable/weapon) - /obj/item/equippable/weapon
/obj/item/useable/installation/telepad/Plant()
	var/P
	P = teleports[team.name]
	icon = 'installed.dmi'
	P["Telepad at [x],[y]"] = src
	. = ..()

/obj/item/useable/installation/telepad/Unplant()
	var/list/P
	P = teleports[team.name]
	icon = 'installation.dmi'
	P.Remove("Telepad at [x],[y]")
	. = ..()

/obj/item/useable/installation/telepad/Die()
	Unplant()
	. = ..()

/obj/item/useable/installation/telepad/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		if(rand(1, M.intelligence + M.dexterity) > difficulty)
			Unplant()
			team = M.team
			owner = M
			Plant()
			M << "Telepad subverted."
	else
		M << "Telepoad destroyed!"
		Die()

/obj/item/useable/installation/teleconsole/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		Unplant()
		team = M.team
		owner = M
		Plant()
		M << "Teleport console subverted."
	else
		M << "Teleport console destroyed!"
		Die()

/obj/item/useable/installation/teleconsole/Plant()
	icon = 'installed.dmi'
	overlays.Add(icon('team_badge.dmi', team.name))
	verbs.Add(/obj/item/useable/installation/teleconsole/proc/teleport)
	verbs.Add(/obj/item/useable/installation/teleconsole/proc/recharge)
	energy = max_energy
	. = ..()

/obj/item/useable/installation/teleconsole/Unplant()
	icon = 'installation.dmi'
	overlays.Remove(icon('team_badge.dmi', team.name))
	verbs.Remove(/obj/item/useable/installation/teleconsole/proc/teleport)
	verbs.Remove(/obj/item/useable/installation/teleconsole/proc/recharge)
	. = ..()

/obj/item/useable/installation/teleconsole/UsedBy()
	if(!energy)
		recharge()
	else
		teleport(input("teleport \[destination\]") in teleports[usr.team.name])

/obj/item/useable/installation/teleconsole/proc/teleport(destination in teleports[usr.team.name])
	set src in view(1)
	if(istype(usr, /mob/player) && usr.team == team)
		var/obj/item/useable/installation/telepad/P = locate() in view(1, src)
		var/drain = 2
		if(P)
			var/O
			for(P in view(1, src))
				for(var/atom/movable/A in P.loc)
					if(A == P) continue
					if(ismob(A))
						drain = 10
					else
						O = A
						if(!istype(A, /obj/item/ammo))
							drain = O:weight
					if(energy >= drain)
						. = A.Teleport(GetTurf(teleports[usr.team.name][destination]))
						if(!.)
							usr << "<b>*CRITICAL ERROR: Destination teleport blocked! Aborting teleport... rerouting...*</b>"
							drain = round(drain / 2, 1)
						energy -= drain
					else
						usr << "<b>*Error: teleport console unit out of power*</b>"
						break

/obj/item/useable/installation/teleconsole/proc/recharge()
	set src in view(1)
	var/mob/player/M
	M = usr
	if(istype(M, /mob/player) && usr.team == team)
		if(usr.energy)
			var/draw = min(max_energy - energy, usr.energy)
			usr.energy -= draw
			energy += draw
			if(draw)
				M.HUDBar("energy")
			else
				usr << "Teleconsole unit is already at 100% power."
		else
			usr << "No power left to charge with!"

/obj/item/useable/installation/microrefinery/Plant()
	icon = 'installed.dmi'
	overlays.Add(icon('team_badge.dmi', team.name))
	verbs.Add(/obj/item/useable/installation/microrefinery/proc/insert)
	verbs.Add(/obj/item/useable/installation/microrefinery/proc/activate)
	. = ..()

/obj/item/useable/installation/microrefinery/Unplant()
	icon = 'installation.dmi'
	overlays.Cut()
	verbs.Remove(/obj/item/useable/installation/microrefinery/proc/insert)
	verbs.Remove(/obj/item/useable/installation/microrefinery/proc/activate)
	for(var/obj/item/O in contents)
		O.Move(loc)
	. = ..()

/obj/item/useable/installation/microrefinery/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		M << "Microrefinery destroyed!"
		Die()

/obj/item/useable/installation/microrefinery/UsedBy()
	if(contents.len)
		activate()
	else
		for(var/obj/item/ore/O in usr)
			if(O.grade != 3)
				insert(O)

/obj/item/useable/installation/microrefinery/proc/insert(obj/item/O as obj)
	set src in view(1)
	if(istype(usr, /mob/player) && O && istype(O, /obj/item/ore))
		if(usr.team == team)
			O = O.drop()
			O.Move(src)

/obj/item/useable/installation/microrefinery/proc/activate()
	set src in view(126)
	var/totalGrade
	totalGrade = list()
	if(istype(usr, /mob/player) && usr.team == team)
		if(contents.len)
			var/obj/item/ore/O
			for(O in src)
				totalGrade[O.oreName] += O.grade
				O.loc = null
				del(O)
			var/oreType
			for(var/G in totalGrade)
				while(totalGrade[G] > 0)
					if(totalGrade[G] >= 3)
						oreType = "/obj/item/ore/[G]/rich"
						O = new oreType(usr.loc)
						O.value *= 3
						totalGrade[G] -= 3
					else if(totalGrade[G] == 2)
						oreType = "/obj/item/ore/[G]/medium"
						O = new oreType(usr.loc)
						O.value *= 2
						totalGrade[G] -= 2
					else
						oreType = "/obj/item/ore/[G]/poor"
						O = new oreType(usr.loc)
						totalGrade[G] = 0
					O.icon_state = O.name
					O.name = "[O.name] [O.oreName] ore"
					O.invisibility = 0
		else
			usr << "<b>*Error! Microrefinery unit is empty!*</b>"
			usr << "Please insert poor or medium grade ore and retry."

/obj/item/useable/installation/rad_scrubber/Plant()
	icon = 'installed.dmi'
	overlays.Add(icon('team_badge.dmi', team.name))
	spawn(10) Clean()
	. = ..()

/obj/item/useable/installation/rad_scrubber/Unplant()
	icon = 'installation.dmi'
	overlays.Cut()
	. = ..()

/obj/item/useable/installation/rad_scrubber/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		Unplant()
		M << "Rad scrubber dismantled!"
	else
		M << "Rad scrubber destroyed!"
		Die()

/obj/item/useable/installation/rad_scrubber/proc/Clean()
	if(planted)
		for(var/atom/A in block(locate(x - 5, y - 5, z), locate(x + 5, y + 5, z)))
			if(isturf(A))
				if(A.radioactivity > 10)
					A.radioactivity--
				else if(A.radioactivity > 5 && !rand(0, 2))
					A.radioactivity--
				else if(!rand(0, 8))
					A.radioactivity--
				A.radioactivity = max(0, A.radioactivity)
				for(var/mob/player/M in A)
					if(M)
						M.radiation = round(M.radiation * 0.75) - 15
						M.radiation = max(0, M.radiation)
						M.HUDBar("radiation")
				for(var/obj/O in A)
					if(O.radioactivity > 1 && !rand(0, 5))
						O.radioactivity--
		spawn(35) Clean()

/obj/item/useable/installation/med_station/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		Unplant()
		M << "Med station dismantled!"
	else
		M << "Med station destroyed!"
		Die()

/obj/item/useable/installation/med_station/Plant()
	icon = 'installed.dmi'
	verbs.Add(/obj/item/useable/installation/med_station/proc/heal)
	overlays.Add(icon('team_badge.dmi', team.name))
	supplies = 5
	spawn(50) Synth()
	. = ..()

/obj/item/useable/installation/med_station/Unplant()
	icon = 'installation.dmi'
	verbs.Remove(/obj/item/useable/installation/med_station/proc/heal)
	overlays.Cut()
	. = ..()

/obj/item/useable/installation/med_station/UsedBy()
	heal()

/obj/item/useable/installation/med_station/proc/Synth()
	if(!planted) return
	supplies = min(50, supplies + rand(3, 5))
	spawn(50) Synth()

/obj/item/useable/installation/med_station/proc/heal()
	set src in view(1)
	var/mob/player/M
	M = usr
	if(istype(usr, /mob/player) && usr.team == team)
		if(supplies && usr.health < usr.max_health - 1)
			var/draw = min(round((usr.max_health - usr.health) / 2), supplies)
			usr.health += draw * 2
			supplies -= draw
			M.HUDBar("health")
			range(5) << "[M.name] uses \the [name]."
			M << "Healed [draw * 2] health."

/obj/item/useable/installation/generator/Die()
	damageable = 0
	Explosion(loc, 25, 2, owner)
	. = ..()

/obj/item/useable/installation/generator/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		Unplant()
		M << "Generator dismantled!"
	else
		M << "Generator destroyed!"
		Die()

/obj/item/useable/installation/generator/Plant()
	icon = 'installed.dmi'
	verbs.Add(/obj/item/useable/installation/generator/proc/withdraw)
	overlays.Add(icon('team_badge.dmi', team.name))
	energy = 5
	spawn(50) Power()
	. = ..()

/obj/item/useable/installation/generator/Unplant()
	icon = 'installation.dmi'
	verbs.Remove(/obj/item/useable/installation/generator/proc/withdraw)
	overlays.Cut()
	. = ..()

/obj/item/useable/installation/generator/UsedBy()
	withdraw()

/obj/item/useable/installation/generator/proc/Power()
	if(!planted) return
	flick("power", src)
	energy = min(max_energy, energy + rand(2, 4))
	spawn(50) Power()

/obj/item/useable/installation/generator/proc/withdraw()
	set src in view(1)
	var/mob/player/M
	M = usr
	if(istype(usr, /mob/player) && usr.team == team)
		if(energy && usr.energy < usr.max_energy)
			var/draw = min(usr.max_energy - usr.energy, energy)
			usr.energy += draw
			energy -= draw
			M.HUDBar("energy")

/obj/item/useable/installation/beacon/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		Unplant()
		M << "Homing beacon dismantled!"
	else
		M << "Homing beacon destroyed!"
		Die()

/obj/item/useable/installation/beacon/Plant()
	signals.Add(src)
	verbs.Add(/obj/item/useable/installation/beacon/proc/Input)
	overlays.Add(icon('team_badge.dmi', team.name))
	icon = 'installed.dmi'
	. = ..()

/obj/item/useable/installation/beacon/Unplant()
	overlays.Cut()
	verbs.Remove(/obj/item/useable/installation/beacon/proc/Input)
	signal = "Homing beacon"
	signals.Remove(src)
	icon = 'installation.dmi'
	. = ..()

/obj/item/useable/installation/beacon/Die()
	signals.Remove(src)
	. = ..()

/obj/item/useable/installation/beacon/UsedBy()
	if(signal == "Homing beacon")
		Input(input("Beacon signal:") as text)

/obj/item/useable/installation/beacon/proc/Input(Text as text)
	set name = "input"
	set desc = "Input the description for the frequency broadcast by a homing beacon."
	set src in view(1)
	if(!istype(usr, /mob/player))
		return
	if(length(Text) > 100)
		Text = copytext(Text, 0, 101)
	signal = Text
	verbs.Remove(/obj/item/useable/installation/beacon/proc/Input)

/obj/item/useable/installation/energy_fence/Plant()
	icon = 'barrier.dmi'
	icon_state = "base"
	overlays.Add(eFence)
	overlays.Add(icon('team_badge.dmi', team.name))
	..()

/obj/item/useable/installation/energy_fence/Use()
	set name = "use"
	set src in usr
	var/turf/OK
	OK = ..()
	if(OK)
		OK.Update()
		var/M = usr
		M:HUDUpdate("carry")

/obj/item/useable/installation/energy_fence/Botch(M as mob)
	var/obj/beam/B
	B = locate() in GetTurf(src)
	if(B)
		M << "Whoops!"
		B.Zap(M)

/obj/item/useable/installation/energy_fence/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty || !dirs.len)
		if(rand(1, M.intelligence + M.dexterity) > difficulty)
			Unplant()
			icon = initial(icon)
			icon_state = initial(icon_state)
			for(var/D in dirs)
				Kill(D)
			dirs.Cut()
			overlays.Cut()
			M << "Energy fence dismantled!"
		else
			M << "Energy fence destroyed!"
			Die()
	else
		for(var/D in dirs)
			Kill(D)
		dirs.Cut()
		M << "Energy fence depowered!"

/obj/item/useable/installation/energy_fence/Die()
	damageable = 0
	Explosion(loc, 10, 0, usr)
	for(var/D in dirs)
		Kill(D)
	dirs.Cut()
	if(buyer)
		var/B = locate(buyer)
		if(B)
			B:insurance += round(value * 0.4)
	. = ..()

/obj/item/useable/installation/energy_fence/proc/Energize(Dir, Target as turf)
	var/T
	var/obj/item/useable/installation/energy_fence/E
	var/obj/beam/B
	var/finished
	T = GetTurf(src)
	finished = 0
	dirs.Add(Dir)
	while(!finished)
		B = new(T)
		B.dir = Dir
		B.layer = 6
		B.owner = owner
		B.team = team
		if(T != loc)
			B.overlays.Add(image('barrier.dmi', null, team.name, 6, turn(Dir, 180)))
		E = locate() in T
		if(T == Target || E && E != src)
			E.dirs.Add(turn(Dir, 180))
			finished = 1
		else
			B.icon_state = team.name
		T = get_step(T, Dir)

/obj/item/useable/installation/energy_fence/proc/Kill(Dir, Target as turf)
	var/T
	var/obj/item/useable/installation/energy_fence/E
	var/obj/beam/B
	var/finished
	var/list/Beams
	T = GetTurf(src)
	finished = 0
	Beams = list()
	dirs.Remove(Dir)
	while(!finished)
		B = locate() in T
		Beams.Cut()
		while(B)
			if(B.dir == Dir || B.dir == turn(Dir, 180))
				del(B)
			if(B)
				Beams.Add(B)
				B = locate() in T:contents - Beams
			else
				B = locate() in T
		E = locate() in T
		if(E && (T == Target || E != src))
			E.dirs.Remove(turn(Dir, 180))
			finished = 1
		else if(T == Target)
			finished = 1
		T = get_step(T, Dir)

/obj/item/useable/installation/energy_fence/proc/Update()
	var/T
	var/obj/item/useable/installation/energy_fence/E
	var/obj/beam/B
	var/reach
	var/beam
	beam = 1
	if(!planted)
		return
	for(var/D in list(1, 2, 4, 8))
		reach = 0
		beam = (D in dirs)
		T = GetTurf(src)
		while(reach <= 6)
			T = get_step(T, D)
			if(T && T:density)
				beam = 0
				break
			B = locate() in T
			if(B)
				if(B.team != team)
					beam = 0
				else if(B.dir == D || B.dir == turn(D, 180))
					if(!(D in dirs)) beam = 0
			E = locate() in T
			if(E && E.planted)
				if(E.team == team)
					beam = 1
				else
					beam = 0
				break
			else
				reach++
		if(reach > 6) beam = 0
		if(!beam && (D in dirs))
			Kill(D, T)
		else if(beam && !(D in dirs))
			Energize(D, T)
	spawn(100) Update()

/obj/beam/proc/Zap(atom/movable/M as mob)
	range(5, src) << "[M.name] gets zapped!"
	M.TakeDamage(25, 0.7, 0.4, owner, "fence")
