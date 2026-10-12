/obj/item/useable/installation/generator
	desc = "A simple power generating unit capable of charging a simple self-contained battery unit and interfacing with other power storage devices to allow workers to recharge in the field."
	icon_state = "generator"
	weight = 4
	delay = 20
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 80
	defense = 20
	max_energy = 50
	value = 4000

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
