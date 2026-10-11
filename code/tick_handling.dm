atom/proc/Tick()

world/Tick()
	for(var/mob/player in players)
		player.Tick()