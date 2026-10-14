/obj/item/useable/installation/rail
	desc = "Lightweight, easy-to-install track lines for monocarts to ride on."
	icon_state = "monocart tracks"
	var/list/dirs
	isDamageable = 0
	isDense = 0
	value = 35
	weight = 0.5

/obj/item/useable/installation/rail/Plant(mob/M)
	. = ..()
	icon = 'rail.dmi'
	icon_state = "line"
	layer = TURF_LAYER
	buyer = M.tag
	Connect()

/obj/item/useable/installation/rail/proc/AddHub()
	var/obj/O
	O = new()
	O.icon = 'rail.dmi'
	O.icon_state = "hub"
	overlays.Add(O)
	dirs.Add(16)
	del(O)

/obj/item/useable/installation/rail/proc/AddDir(D)
	overlays.Add(icon('rail.dmi', "power", D))
	dirs.Add(D)
	for(var/Dir in dirs)
		if(Dir < 16)
			if(Dir != dir && Dir != turn(dir, 180) && !(16 in dirs))
				AddHub()

/obj/item/useable/installation/rail/proc/Connect()
	var/obj/item/useable/installation/rail/R
	var/T
	for(var/D in list(1, 2, 4, 8))
		T = get_step(loc, D)
		R = LocatePlanted(T, /obj/item/useable/installation/rail)
		if(R)
			if(!R.dirs)
				R.dir = turn(D, 180)
				R.dirs = list(turn(D, 180))
				R.icon_state = "power"
			else
				R.AddDir(turn(D, 180))
			if(!dirs)
				dir = D
				dirs = list(D)
				icon_state = "power"
			else
				AddDir(D)
