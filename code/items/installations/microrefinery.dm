/obj/item/useable/installation/microrefinery
	desc = "A very useful piece of equipment, the microrefinery is capable of purifying low-grade ores inserted into its processing bin and producing smaller amounts of higher-grade ore. The microrefinery doesn't actually increase the value of the ore it processes, but is capable of turning a large amount of ore into a smaller, lighter load worth the same amount."
	icon_state = "microrefinery"
	weight = 5
	delay = 25
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 80
	defense = 15
	value = 3500

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
			if(O.loc != usr)
				usr << "Pick the ore up first."
				return
			O.Move(src)

/obj/item/useable/installation/microrefinery/proc/activate()
	set src in view(126)
	var/totalGrade
	totalGrade = list()
	if(istype(usr, /mob/player) && usr.team == team)
		if(contents.len)
			var/obj/item/ore/O
			for(O in src)
				totalGrade[O.oreName] += O.grade * O.quantity
				O.loc = null
				del(O)
			var/oreType
			var/amount
			for(var/G in totalGrade)
				while(totalGrade[G] > 0)
					if(totalGrade[G] >= 3)
						oreType = "/obj/item/ore/[G]/rich"
						O = new oreType(usr.loc)
						O.value *= 3
						amount = min(round(totalGrade[G] / 3), 99)
						totalGrade[G] -= amount * 3
					else if(totalGrade[G] == 2)
						oreType = "/obj/item/ore/[G]/medium"
						O = new oreType(usr.loc)
						O.value *= 2
						amount = 1
						totalGrade[G] -= 2
					else
						oreType = "/obj/item/ore/[G]/poor"
						O = new oreType(usr.loc)
						amount = 1
						totalGrade[G] = 0
					O.quantity = amount
					O.icon_state = O.name
					O.name = "[O.name] [O.oreName] ore"
					O.invisibility = 0
		else
			usr << "<b>*Error! Microrefinery unit is empty!*</b>"
			usr << "Please insert poor or medium grade ore and retry."
