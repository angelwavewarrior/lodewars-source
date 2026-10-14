/obj/item/useable/installation/teleconsole
	name = "teleport console"
	desc = "One of the two pieces of equipment necessary for a functionary teleport station, the teleport console contains most of the actual teleportation apparatus, as well as the computer interface necessary to use it. A teleport console <b>must</b> be installed adjacent to a telepad in order to function, and its comparatively small power supply must periodically be recharged from personal batteries."
	icon_state = "teleconsole"
	weight = 5
	delay = 25
	value = 6500
	dismantleable = 1
	isDamageable = 1
	max_health = 65
	defense = 15
	energy_defense = 5
	max_energy = 20

/obj/item/useable/installation/teleconsole/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		Unplant()
		team = M.team
		owner = M
		Plant(M)
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

/obj/item/useable/installation/teleconsole/UsedBy(mob/player/M)
	if(!energy)
		RechargeBy(M)
	else
		TeleportBy(M, input(M, "teleport \[destination\]") in teleports[M.team.name])

/obj/item/useable/installation/teleconsole/proc/teleport(destination in teleports[usr.team.name])
	set src in view(1)
	return TeleportBy(usr, destination)

/obj/item/useable/installation/teleconsole/proc/TeleportBy(mob/M, destination)
	if(istype(M, /mob/player) && M.team == team)
		var/obj/item/useable/installation/telepad/P = locate() in view(1, src)
		var/drain = 2
		if(P)
			var/O
			for(P in view(1, src))
				for(var/atom/movable/A in P.loc)
					if(A == P) continue
					if(!ismob(A) && !istype(A, /obj/item)) continue
					if(ismob(A))
						drain = 10
					else
						O = A
						if(!istype(A, /obj/item/ammo))
							drain = O:weight
					if(energy >= drain)
						. = A.Teleport(GetTurf(teleports[M.team.name][destination]))
						if(!.)
							M << "<b>*CRITICAL ERROR: Destination teleport blocked! Aborting teleport... rerouting...*</b>"
							drain = round(drain / 2, 1)
						energy -= drain
					else
						M << "<b>*Error: teleport console unit out of power*</b>"
						break

/obj/item/useable/installation/teleconsole/proc/recharge()
	set src in view(1)
	RechargeBy(usr)

/obj/item/useable/installation/teleconsole/proc/RechargeBy(mob/player/M)
	if(istype(M, /mob/player) && M.team == team)
		if(M.energy)
			var/draw = min(max_energy - energy, M.energy)
			M.energy -= draw
			energy += draw
			if(draw)
				M.HUDBar("energy")
			else
				M << "Teleconsole unit is already at 100% power."
		else
			M << "No power left to charge with!"
