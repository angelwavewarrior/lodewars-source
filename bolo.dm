/mob/proc/UpdateChildren()
	return 0

/mob/player/bolo/SelectTeam(T)
	if(!head)
		spawn(5) SelectTeam(T)
	else
		. = ..()

/mob/player/bolo/Login()
	var/mob/subBolo/M
	var/obj/O
	. = ..()
	density = 0
	for(var/i = 0, i <= 1, i++)
		for(var/j = 0, j <= 1, j++)
			M = new()
			M.density = 0
			M.master = src
			M.name = name
			M.verbs.Add(/mob/player/verb/attack)
			if(!i && !j)
				head = M
				M.head = M
				client.eye = M
				client.perspective = M
				M.animate_movement = 1
				head.icon = file("[baseIcon]_00.dmi")
				head.icon_state = "run"
				head.name = name
				head.gender = gender
			else
				M.head = head
				M.animate_movement = 3
				O = new()
				O.icon = file("[baseIcon]_[i][j].dmi")
				O.pixel_x = i * 32
				O.pixel_y = j * 32
				head.overlays.Add(O)
				del(O)
			M.xOffset = i
			M.yOffset = j
			M.water = new/obj()
			M:water:icon = file("bwater_[i][j].dmi")
			M:water:pixel_x = i * 32
			M:water:pixel_y = j * 32
			M:water:layer = 5
			children.Add(M)

/mob/player/bolo/Del()
	for(var/mob/subBolo/M in children)
		M.loc = null
		del(M.water)
		del(M)

/mob/player/bolo/Die()
	for(var/mob/M in children)
		M.loc = null
	. = ..()

/mob/player/bolo/Go(Dir)
	var/NewLoc
	var/oldLoc
	if(!head)
		return
	NewLoc = get_step(head, Dir)
	oldLoc = head.loc
	if(Dir >= 5 && Dir != 8)
		return
	if(world.time >= act_delay)
		. = 1
		if(NewLoc)
			for(var/mob/M in children)
				for(var/mob/B in children)
					B.density = 0
				M.density = 1
				M.Move(locate(NewLoc:x + M.xOffset, NewLoc:y + M.yOffset, z))
				if(M.loc != locate(NewLoc:x + M.xOffset, NewLoc:y + M.yOffset, z))
					. = 0
		if(.)
			. = Move(NewLoc, Dir)
			dir = Dir
			if(loc)
				if(!.)
					head.loc = oldLoc
					UpdateChildren()
		else
			head.loc = oldLoc
			dir = Dir
			UpdateChildren()
		for(var/mob/M in children)
			M.density = 1
			if(get_step(GetTurf(src), Dir) == M.loc)
				loc = M.loc
			UpdateWater()

/mob/player/bolo/UpdateChildren()
	if(!head.loc) return
	for(var/mob/subBolo/M in children)
		M.loc = locate(head.x + M.xOffset, head.y + M.yOffset, head.z)
	UpdateWater()
	head.icon_state = icon_state
	head.dir = dir

/mob/player/bolo/proc/UpdateWater()
	var/turf/T
	for(var/mob/subBolo/M in children)
		T = M.loc
		if(T && !T.Bridged())
			if(!(M in water))
				spawn(5) if(M) head.overlays.Add(M.water)
				water.Add(M)
		else
			if(M in water)
				spawn(2) if(M) head.overlays.Remove(M.water)
				water.Remove(M)
