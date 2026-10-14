/mob/player/bolo
	bounds = "1,1 to 64,64"
	// One wading overlay per 32x32 quarter, keyed "xy", and the quarters now in open water.
	var/tmp/list/waterOverlays
	var/tmp/list/wading = list()

/mob/player/bolo/Move()
	. = ..()
	UpdateWater()

/mob/player/bolo/Respawn()
	. = ..()
	UpdateWater()

/mob/player/bolo/proc/UpdateWater()
	if(!waterOverlays)
		waterOverlays = list()
		var/list/icons = list("00" = 'bwater_00.dmi', "01" = 'bwater_01.dmi', "10" = 'bwater_10.dmi', "11" = 'bwater_11.dmi')
		for(var/q in icons)
			var/obj/O = new
			O.icon = icons[q]
			O.pixel_x = text2num(copytext(q, 1, 2)) * 32
			O.pixel_y = text2num(copytext(q, 2, 3)) * 32
			O.layer = 5
			waterOverlays[q] = O
	for(var/q in waterOverlays)
		var/turf/T = locate(x + text2num(copytext(q, 1, 2)), y + text2num(copytext(q, 2, 3)), z)
		var/obj/O = waterOverlays[q]
		// Bridged() is true for anything but unbridged water.
		if(T && !T.Bridged())
			if(!(q in wading))
				wading += q
				// Shown as the step's glide ends, as the four-part bolo did.
				spawn(5) if(q in wading) overlays += O
		else if(q in wading)
			wading -= q
			spawn(2) if(!(q in wading)) overlays -= O
