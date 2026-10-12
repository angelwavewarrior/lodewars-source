/obj/item/useable/installation/med_station
	desc = "A collapsable infirmary unit capable of synthesizing certain medical supplies on its own, a med station can effectively act as a field hospital when nothing better can be provided."
	icon_state = "med station"
	var/supplies = 0
	weight = 3
	delay = 12
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 45
	defense = 14
	value = 1500

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
