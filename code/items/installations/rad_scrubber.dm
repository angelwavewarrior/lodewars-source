/obj/item/useable/installation/rad_scrubber
	name = "radiation scrubber"
	desc = "Radiation scrubbers are relatively simple, self-contained environmental purification units that are capable of both absorbing background radiation and decontaminating individuals in the area who have already caught significant doses of radiation."
	icon_state = "rad scrubber"
	weight = 2.5
	delay = 11
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 40
	defense = 13
	value = 2000

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
