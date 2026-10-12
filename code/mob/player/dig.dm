/mob/player/proc/Dig(turf/T as turf)
	var/delay
	delay = (32 - digging + T.solidness) / size
	icon_state = "dig"
	if(digging != CalcStat("digging"))
		delay = T.solidness + 30
	if(act_delay <= world.time)
		act_delay = world.time + delay
	else
		act_delay += delay
	sleep(delay * size - 1)
	icon_state = "run"
	var/check_dist = 1
	if(istype(src,/mob/player/bolo)) check_dist = 2
	if(src && T && get_dist(src, T) <= check_dist)
		experience += digging + 10
		T.Dug()
		act_delay = 0

/turf/proc/Dug()
	var/turf/U
	if(!density) return
	flick("crumble", src)
	density = 0
	opacity = 0
	Update()
	for(var/D in list(1, 2, 4, 8))
		U = get_step(src, D)
		U.Update()
