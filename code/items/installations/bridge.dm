/obj/item/useable/installation/bridge
	desc = "Sturdy, easily assembled magnetic bridge segments for constructing walkways over water."
	icon_state = "bridge"
	var/list/dirs
	isDamageable = 0
	isDense = 0
	value = 100
	weight = 1
	aquatic = 1

/obj/item/useable/installation/bridge/Plant()
	. = ..()
	icon = 'bridge.dmi'
	layer = TURF_LAYER
	buyer = usr.tag
	loc.layer = TURF_LAYER
	Connect()

/obj/item/useable/installation/bridge/proc/AddDir(D)
	overlays.Add(icon('bridge.dmi', "bridge", D))
	dirs.Add(D)

/obj/item/useable/installation/bridge/proc/Connect()
	var/obj/item/useable/installation/bridge/R
	var/T
	for(var/D in list(1, 2, 4, 8))
		T = get_step(loc, D)
		R = locate() in T
		if(R)
			if(!R.dirs)
				R.dir = turn(D, 180)
				R.dirs = list(turn(D, 180))
			else
				R.AddDir(turn(D, 180))
		if(R || istype(T, /turf/dirt))
			if(!dirs)
				dir = D
				dirs = list(D)
			else
				AddDir(D)
