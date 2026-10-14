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
	var/loop = ++tick_loop
	spawn(50) Power(loop)
	. = ..()

/obj/item/useable/installation/generator/Unplant()
	icon = 'installation.dmi'
	verbs.Remove(/obj/item/useable/installation/generator/proc/withdraw)
	overlays.Cut()
	. = ..()

/obj/item/useable/installation/generator/UsedBy(mob/player/M)
	WithdrawBy(M)

/obj/item/useable/installation/generator/proc/Power(loop)
	if(!planted || loop != tick_loop) return
	flick("power", src)
	energy = min(max_energy, energy + rand(2, 4))
	spawn(50) Power(loop)

/obj/item/useable/installation/generator/proc/withdraw()
	set src in view(1)
	WithdrawBy(usr)

/obj/item/useable/installation/generator/proc/WithdrawBy(mob/player/M)
	if(istype(M, /mob/player) && M.team == team)
		if(energy && M.energy < M.max_energy)
			var/draw = min(M.max_energy - M.energy, energy)
			M.energy += draw
			energy -= draw
			M.HUDBar("energy")
