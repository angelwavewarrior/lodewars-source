/obj/item/ore
	desc = "Collect ore and deposit it in your team's ore bin to score points."
	var/vein
	var/grade = 1
	var/oreName
	weight = 1
	stackable = 1
	invisibility = 1

/obj/item/ore/asbylite
	icon = 'ore_asbylite.dmi'
	oreName = "asbylite"
	value = 300

/obj/item/ore/draxilite
	icon = 'ore_draxilite.dmi'
	oreName = "draxilite"
	value = 800

/obj/item/ore/grezlorite
	icon = 'ore_grezlorite.dmi'
	oreName = "grezlorite"
	value = 600

/obj/item/ore/hezerite
	icon = 'ore_hezerite.dmi'
	oreName = "hezerite"
	value = 700

/obj/item/ore/kaburite
	icon = 'ore_kaburite.dmi'
	oreName = "kaburite"
	value = 2000
	radioactivity = 3

/obj/item/ore/necite
	icon = 'ore_necite.dmi'
	oreName = "necite"
	value = 1000

/obj/item/ore/petrite
	icon = 'ore_petrite.dmi'
	oreName = "petrite"
	value = 500

/obj/item/ore/asbylite/medium
	grade = 2

/obj/item/ore/asbylite/poor

/obj/item/ore/asbylite/rich
	grade = 3

/obj/item/ore/draxilite/medium
	grade = 2

/obj/item/ore/draxilite/poor

/obj/item/ore/draxilite/rich
	grade = 3

/obj/item/ore/grezlorite/medium
	grade = 2

/obj/item/ore/grezlorite/poor

/obj/item/ore/grezlorite/rich
	grade = 3

/obj/item/ore/hezerite/medium
	grade = 2

/obj/item/ore/hezerite/poor

/obj/item/ore/hezerite/rich
	grade = 3

/obj/item/ore/kaburite/medium
	grade = 2

/obj/item/ore/kaburite/poor

/obj/item/ore/kaburite/rich
	grade = 3

/obj/item/ore/necite/medium
	grade = 2

/obj/item/ore/necite/poor

/obj/item/ore/necite/rich
	grade = 3

/obj/item/ore/petrite/medium
	grade = 2

/obj/item/ore/petrite/poor

/obj/item/ore/petrite/rich
	grade = 3

/obj/item/ore/Move(mob/player/M as mob)
	. = ..()
	if(. && istype(M, /mob/player))
		if(vein && !(vein in veinsFound))
			veinsFound.Add(vein)
			M.experience += (M.speed + M.digging) * (value / 500)
			if(M.team && M.team.expBonus == "find")
				M.experience += 150
	if(container)
		container.carried.Remove(src)
		container = null
