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
	var/loop = ++tick_loop
	spawn(50) Synth(loop)
	. = ..()

/obj/item/useable/installation/med_station/Unplant()
	icon = 'installation.dmi'
	verbs.Remove(/obj/item/useable/installation/med_station/proc/heal)
	overlays.Cut()
	. = ..()

/obj/item/useable/installation/med_station/UsedBy(mob/player/M)
	HealBy(M)

/obj/item/useable/installation/med_station/proc/Synth(loop)
	if(!planted || loop != tick_loop) return
	supplies = min(50, supplies + rand(3, 5))
	spawn(50) Synth(loop)

/obj/item/useable/installation/med_station/proc/heal()
	set src in view(1)
	HealBy(usr)

/obj/item/useable/installation/med_station/proc/HealBy(mob/player/M)
	if(istype(M, /mob/player) && M.team == team)
		if(supplies && M.health < M.max_health - 1)
			var/draw = min(round((M.max_health - M.health) / 2), supplies)
			M.health += draw * 2
			supplies -= draw
			M.HUDBar("health")
			range(5, M) << "[M.name] uses \the [name]."
			M << "Healed [draw * 2] health."
