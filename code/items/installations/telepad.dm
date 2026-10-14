/obj/item/useable/installation/telepad
	icon_state = "telepad"
	var/list/hookUp = list()
	weight = 2
	delay = 20
	value = 4000
	isDamageable = 1
	isDense = 0
	max_health = 100
	// TakeDamage divides by defense - energy_defense, so both unset is a division by zero.
	defense = 15

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
			Plant(M)
			M << "Telepad subverted."
	else
		M << "Telepoad destroyed!"
		Die()
