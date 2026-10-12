/mob/observer
	var/atom/movable/char
	var/loggedIn

/mob/observer/verb/observe(mob/M as mob in players)
	if(!istype(M, /mob/player) || !M.client)
		client.eye = src
		client.perspective = src
		observers.Remove(src)
		if(char)
			loc = locate(7, 7, 4)
		else
			loc = locate(7, 7, 3)
	else
		client.eye = M.client.eye
		client.perspective = M.client.perspective
		loc = null
		observers.Add(src)

/mob/observer/New(Loc, LogIn=0)
	loggedIn = LogIn

/mob/observer/Move()
	return 0

/mob/observer/Logout()
	players.Remove(src)
	tag = null
	loc = null
	spawn(1)
		if(char)
			char.loc = null
			if(char.team)
				char.team.members.Remove(char)
			del(char)
		if(playerLimit)
			if(serverName)
				world.status = "[serverName] ([players.len]/[playerLimit] players)"
			else
				world.status = "([players.len]/[playerLimit] players)"
		else
			world.status = serverName
		del(src)

/mob/observer/Login()
	if(!(client.key in adminList) && client.address && client.address != world.address && ((client.key in banKeys) || (client.address in banIP)))
		if(!(client.key in unbanned) && !(client.address in unbanned))
			src << "<b><tt><font color=red>You have been <u>banned</u> from this Lode Wars server.</font></tt></b><br>There are many Lode Wars subscribers who host servers on a regular basis, and this one in particular has made it clear that they do not wish your presence on their server. Please respect their wishes and find another server to play on."
			if(!(client.address in banIP))
				banIP.Add(client.address)
				admins << "Blocked banned key \"[client.key]\" from [client.address]."
			else if(!(client.key in banKeys))
				banKeys.Add(client.key)
				admins << "Blocked banned IP [client.address] using key \"[client.key]\"."
			del(client)
			del(src)
		else
			if(client.key in banKeys) banKeys.Remove(client.key)
			if(client.address in banIP) banIP.Remove(client.address)
			admins << "Allowed previously banned key \"[client.key]\" in from [client.address]."
	else if(!client.address || client.address == "127.0.0.1" || client.address == world.address)
		if(!host || host == key)
			admins.Add(src)
			verbs.Add(typesof(/mob/admin/verb))
			verbs.Add(typesof(/mob/host/verb))
			serverName = "[name]'s server"
			world.status = "[name]'s server"
			world.name = "Lode Wars: [name]'s server"
			host = key
		else if(!host)
			world << "<b><tt><font color=red>ERROR: nonsubscribed host. Shutting down...</font></tt></b>"
			sleep(1)
			del(world)
	else if(key in adminList)
		admins.Add(src)
		verbs.Add(typesof(/mob/admin/verb))
	else if(playerLimit && players.len >= playerLimit)
		usr << "Sorry, this server is full ([playerLimit] players max)."
		sleep(1)
		del(client)
		del(src)
	LoadHUD()
	spawn(10) HUDTime()
	client.eye = src
	client.perspective = src
	tag = name
	players.Add(src)
	if(!loggedIn)
		players << "[name] logs in."
		src << MOTD
		instructions()
		if(map)
			src << map.Readings()
		if(playerLimit > 0)
			if(serverName)
				world.status = "[serverName] ([players.len]/[playerLimit] players)"
			else
				world.status = "([players.len]/[playerLimit] players)"
		else
			world.status = serverName
	else
		client.screen.Add(masterHUD["/obj/hud/button/observe"])
		client.screen.Remove(masterHUD["/obj/hud/button/save"])
		client.screen.Remove(masterHUD["/obj/hud/button/get"])
		client.screen.Remove(masterHUD["/obj/hud/button/attack"])
	if(!map)
		loc = null
	else
		loc = locate(7, 7, 3)
