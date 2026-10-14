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
	if(src && T && TileDist(src, T) <= 1)
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
