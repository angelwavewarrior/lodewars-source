/mob/player/appearance_flags = LONG_GLIDE

/mob/player/proc/HandleMovement(direction)
	if(vehicle)
		icon_state = "still"
		Go(direction)
		return
	var/moveSpeed = speed
	var/turf/T = loc
	var/water = 0
	var/waterLogged = 0
	if(istype(loc, /turf/water) && !vehicle && !T:Bridged())
		if(istype(src, /mob/player/bolo))
			moveSpeed -= 3
		else
			moveSpeed += swim
			water = 1
			if(swim < 0)
				waterLogged = 2
	if(speed != CalcStat("speed"))
		moveSpeed = 0
	var/delay =  (8 - round(sqrt(moveSpeed)) + waterLogged)
	glide_size = (32 / delay) * world.tick_lag
	if(water && density)
		if(icon_state != "swim") spawn(4) icon_state = "swim"
	else if(icon_state != "run")
		spawn(2) icon_state = "run"
	var/turf/old_loc = loc
	src.Go(direction)
	if(loc != old_loc)
		speed_accum = speed_accum + (sqrt(moveSpeed) - round(sqrt(moveSpeed)))
		act_delay = world.time + delay
		if(speed_accum >= 1)
			speed_accum--
			act_delay--
