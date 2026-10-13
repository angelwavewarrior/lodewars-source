/mob/admin

/mob/host

/proc/LoadFilter()
	var/T
	var/start
	start = 1
	T = file2text(file("filter.txt"))
	if(T && length(T))
		// A last line with no newline after it would be skipped.
		if(copytext(T, length(T)) != "\n")
			T += "\n"
		while(findtext(T, ":", start) && findtext(T, "\n", start))
			filter[copytext(T, start, findtext(T, ":", start))] = copytext(T, findtext(T, ":", start) + 1, findtext(T, "\n", start))
			start = findtext(T, "\n", start) + 1

/proc/SaveFilter()
	var/T
	T = ""
	for(var/F in filter)
		T += "[F]:[filter[F]]\n"
	fdel("filter.txt")
	. = text2file(T, "filter.txt")

/proc/LoadAdmins()
	var/T
	var/start
	start = 1
	T = file2text(file("admin.txt"))
	if(T && length(T))
		// A last line with no newline after it would be skipped.
		if(copytext(T, length(T)) != "\n")
			T += "\n"
		var/K
		while(findtext(T, "\n", start))
			K = ckey(copytext(T, start, findtext(T, "\n", start)))
			if(K)
				adminList.Add(K)
			start = findtext(T, "\n", start) + 1

/proc/SaveAdmins()
	var/T
	T = ""
	for(var/A in adminList)
		T += "[A]\n"
	fdel("admin.txt")
	. = text2file(T, "admin.txt")

/proc/LoadBanned()
	var/T
	var/start
	start = 1
	T = file2text(file("banned.txt"))
	if(T && length(T))
		// A last line with no newline after it would be skipped.
		if(copytext(T, length(T)) != "\n")
			T += "\n"
		var/K
		while(findtext(T, "\n", start))
			K = ckey(copytext(T, start, findtext(T, "\n", start)))
			if(K)
				banKeys.Add(K)
			start = findtext(T, "\n", start) + 1
	banIP = LoadLines("bannedIP.txt")
	unbanned = LoadLines("unbanned.txt")

/proc/SaveBanned()
	var/T
	T = ""
	for(var/B in banKeys)
		T += "[B]\n"
	fdel("banned.txt")
	. = text2file(T, "banned.txt")
	SaveLines(banIP, "bannedIP.txt")
	SaveLines(unbanned, "unbanned.txt")

// One entry per line, spaces dropped. Addresses are not ckeys, which would drop the dots.
/proc/LoadLines(name)
	var/T
	var/start
	var/L
	. = list()
	start = 1
	T = file2text(file(name))
	if(T && length(T))
		if(copytext(T, length(T)) != "\n")
			T += "\n"
		while(findtext(T, "\n", start))
			L = replacetext(replacetext(copytext(T, start, findtext(T, "\n", start)), " ", ""), ascii2text(13), "")
			if(L)
				. += L
			start = findtext(T, "\n", start) + 1

/proc/SaveLines(list/L, name)
	var/T
	T = ""
	for(var/E in L)
		T += "[E]\n"
	fdel(name)
	. = text2file(T, name)

/proc/LoadMOTD()
	var/T
	T = file2text(file("MOTD.txt"))
	if(T && length(T))
		MOTD = T

/proc/SaveMOTD()
	fdel("MOTD.txt")
	. = text2file(MOTD, "MOTD.txt")

/mob/verb/map_settings()
	set desc = "Displays the current map settings."
	if(!nextMap)
		usr << "No map settings are in place."
	else
		usr << "<b>Map settings:</b>"
		usr << "Map size: [nextMap.size]"
		usr << "Map water: [nextMap.waterContent]"
		usr << "Map radiation: [nextMap.RadLevel()]"
		if(nextMap.timer)
			usr << "Map time: [nextMap.timer.time]"
		else
			usr << "Map time: auto"
		if(nextMap.teams && nextMap.teams.len)
			usr << "Teams: [nextMap.teams.len]"
			for(var/T in nextMap.teams)
				switch(T)
					if(/team/red) usr << "   Red"
					if(/team/blue) usr << "   Blue"
					if(/team/green) usr << "   Green"
					if(/team/gold) usr << "   Gold"
					if(/team/orange) usr << "   Orange"
					if(/team/purple) usr << "   Purple"
					if(/team/white) usr << "   White"
					if(/team/black) usr << "   Black"
		if(!nextMap.saved)
			usr << "Not saved. Players will be rank [isnull(nextMap.rank) ? 0 : nextMap.rank] and start with [isnull(nextMap.cash) ? "the usual cash" : "$[nextMap.cash]"]."

/mob/host/verb/admin_privelages(mob/M as mob in players)
	set desc = "Bestows or removes admin commands (barring certain host-only commands) from a player."
	set category = "Admin"
	if(M in admins)
		if(M.client && !(!M.client.address || M.client.address == world.address || M.client.address == "127.0.0.1"))
			admins.Remove(M)
			M.verbs.Remove(typesof(/mob/admin/verb))
			adminList.Remove(M.ckey)
			players << "[M.name]'s admin privelages have been revoked."
	else
		admins.Add(M)
		M.verbs.Add(typesof(/mob/admin/verb))
		adminList.Add(M.ckey)
		players << "[M.name] has been made an admin by [usr.name]."
	SaveAdmins()

/mob/host/verb/shut_down()
	set desc = "Shuts down the world."
	set category = "Admin"
	del(world)

/mob/host/verb/server_name(N as text)
	set desc = "Sets the title the game appears under on the listing of active Lode Wars games."
	set category = "Admin"
	world.name = "Lode Wars: [N]"
	if(playerLimit > 0)
		world.status = "[N] ([players.len]/[playerLimit] players)"
	else
		world.status = N
	serverName = N

/mob/host/verb/MOTD(M as message)
	set desc = "Sets the MOTD (Message Of The Day--a message seen by all players as they log in. Editing MOTD.txt has the same effect.)"
	set category = "Admin"
	MOTD = M
	SaveMOTD()

/mob/admin/verb/ban(M in players + "Ban key")
	set desc = "Bans a user from the game."
	set category = "Admin"
	var/addy
	var/mob/B
	B = M
	if(M == "Ban key")
		M = input("Ban what key?") as text
	// A typed key is matched as a ckey. The host is not in adminList.
	if((M in admins) || (istext(M) && ((ckey(M) in adminList) || ckey(M) == ckey(host))))
		return
	players << "[M] has been banned by [name]."
	if(ismob(M))
		B = GetMob(M)
		banKeys.Add(B.ckey)
		unbanned.Remove(B.ckey)
		if(B.client)
			addy = B.client.address
			banIP.Add(B.client.address)
			del(B.client)
		del(B)
	else
		banKeys.Add(ckey(M))
		unbanned.Remove(ckey(M))
		for(var/mob/P in players)
			if(P.ckey == ckey(M))
				if(P.client)
					addy = P.client.address
					banIP.Add(P.client.address)
					del(P.client)
				del(P)
	for(var/mob/P in players)
		if(P.client && P.client.address && P.client.address == addy)
			del(P.client)
			del(P)
	// Login lets in anything still on the unbanned list.
	if(addy)
		unbanned.Remove(addy)
	SaveBanned()

/mob/admin/verb/unban(Type in list("Key name", "IP address"), target in Type == "Key name" ? banKeys : banIP)
	set desc = "Unbans a key or address."
	set category = "Admin"
	switch(Type)
		if("Key name") banKeys.Remove(target)
		if("IP address") banIP.Remove(target)
	unbanned.Add(target)
	admins << "[name] has unbanned [target]."
	SaveBanned()

/mob/admin/verb/end_game()
	set desc = "Sets a 1 minute time limit on the game."
	set category = "Admin"
	if(map && alert("Are you sure you want to end the game?", "Confirmation", "Yes", "No") == "Yes")
		players << "<b>[name] declares an emergency end to the game</b>!"
		map.timer.time = 0

/mob/admin/verb/set_player_limit(N as num)
	set desc = "Sets a limit on the total number of players that can log into a server--good for keeping lower-end servers from being flooded with players."
	set category = "Admin"
	// 0 is no limit. A negative limit would turn away every new player.
	N = max(0, round(N))
	playerLimit = N
	if(N)
		players << "Player limit set to [N] players."
	else
		players << "This server now has no player limit."
	if(playerLimit > 0)
		if(serverName)
			world.status = "[serverName] ([players.len]/[playerLimit] players)"
		else
			world.status = "([players.len]/[playerLimit] players)"
	else
		world.status = serverName

/mob/admin/verb/IP()
	set desc = "Displays a listing of all players and their addresses."
	set category = "Admin"
	set hidden = 1
	var/mob/player/M
	for(var/mob/P in players + world)
		M = GetMob(P)
		if(istype(M, /mob/player))
			if(P.client) src << "[P.name]: rank [M.rank] [M.race] ([P.client.address])"
		else
			if(P.client) src << "[P.name]: observer ([P.client.address])"

/mob/admin/verb/map_size(N in list("tiny", "small", "medium", "large", "huge", "random"))
	set desc = "Sets the size of the next map."
	set category = "Map"
	if(!nextMap)
		nextMap = new/map()
	nextMap.size = N
	admins << "[name] sets the next game to be a [N] sized map."

/mob/admin/verb/map_water(N in list("none", "low", "moderate", "high", "very high", "random"))
	set desc = "Sets the water content of the next map."
	set category = "Map"
	if(!nextMap)
		nextMap = new/map()
	nextMap.waterContent = N
	admins << "[name] sets the next game to have [N] water."

/mob/admin/verb/map_time(N as num)
	set desc = "Sets the time limit (in minutes) for the next map."
	set category = "Map"
	if(N)
		if(!nextMap)
			nextMap = new/map()
		if(!nextMap.timer)
			nextMap.timer = new/obj/timer()
		nextMap.timer.time = max(15, N)
		admins << "[name] sets the next game to be [nextMap.timer.time] minutes long."
	else
		if(nextMap && nextMap.timer)
			del(nextMap.timer)
		admins << "[name] sets the next map to have a random timer."

/mob/admin/verb/map_radiation(N in list("negligible", "low", "medium", "high", "very high", "dangerously high", "random"))
	set desc = "Sets the amount of background radiation for the next map."
	set category = "Map"
	if(!nextMap)
		nextMap = new/map()
	switch(N)
		if("negligible") nextMap.bgRadiation = 0.5
		if("low") nextMap.bgRadiation = 1
		if("medium") nextMap.bgRadiation = 2
		if("high") nextMap.bgRadiation = 4
		if("very high") nextMap.bgRadiation = 8
		if("dangerously high") nextMap.bgRadiation = 16
		if("random") nextMap.bgRadiation = 0
	admins << "[name] sets the next game to have [N] radiation."

/mob/admin/verb/map_teams()
	set desc = "Picks the teams available for the next map."
	set category = "Map"
	var/list/teamList
	var/list/newTeams
	var/inputTeam
	teamList = list("Red" = /team/red, "Blue" = /team/blue, "Green" = /team/green, "Gold" = /team/gold, "Purple" = /team/purple, "Orange" = /team/orange, "Black" = /team/black, "White" = /team/white, "Done")
	newTeams = list()
	while(newTeams.len < 4 && inputTeam != "Done")
		inputTeam = input("Pick a team to add to the next game's roster:") in teamList
		if(inputTeam != "Done")
			newTeams.Add(teamList[inputTeam])
		teamList.Remove(inputTeam)
	if(newTeams.len >= 2)
		if(!nextMap)
			nextMap = new/map()
		if(!nextMap.teams)
			nextMap.teams = list()
		else
			nextMap.teams.Cut()
		for(var/T in newTeams)
			nextMap.teams.Add(T)
		admins << "[name] sets the next game to have [newTeams.len] teams."
	else if(newTeams.len == 0)
		if(nextMap)
			del(nextMap.teams)
		admins << "[name] sets the next game to have randomized teams."
	else
		src << "Cancelled team selection (not enough teams entered)."

/mob/admin/verb/map_cash(n as num|null)
	set desc = "Sets the base amount of cash players start with for the next round. This option means that characters are neither saved nor loaded for the next round, but instead start with predetermined rank and money. Leave it blank to remove the setting."
	set category = "Map"
	if(!isnull(n))
		n = max(0, min(99999, n))
		if(!nextMap)
			nextMap = new/map()
		nextMap.cash = n
		nextMap.saved = 0
		admins << "[name] sets players to start the next game with $[n]. The next game is not saved."
	else if(nextMap)
		nextMap.cash = null
		if(isnull(nextMap.rank))
			nextMap.saved = 1
			admins << "[name] removes the next game's starting cash. The next game is saved again."
		else
			admins << "[name] removes the next game's starting cash."

/mob/admin/verb/map_rank(n as num|null)
	set desc = "Sets the rank players are assigned for the next round. This option means that characters are neither saved nor loaded for the next round, but instead start with predetermined rank and money. Leave it blank to remove the setting."
	set category = "Map"
	if(!isnull(n))
		n = max(0, min(30, round(n)))
		if(!nextMap)
			nextMap = new/map()
		nextMap.rank = n
		nextMap.saved = 0
		admins << "[name] sets players to be rank [n] in the next game. The next game is not saved."
	else if(nextMap)
		nextMap.rank = null
		if(isnull(nextMap.cash))
			nextMap.saved = 1
			admins << "[name] removes the next game's starting rank. The next game is saved again."
		else
			admins << "[name] removes the next game's starting rank."

/mob/admin/verb/clear_map_settings()
	set desc = "Restores all map settings to the default, randomized setting."
	set category = "Map"
	if(nextMap)
		del(nextMap)
		admins << "[name] declares next game a standard, random game."

/mob/admin/verb/reboot()
	set desc = "Reboots the world."
	set category = "Admin"
	world.Reboot()

/mob/admin/verb/boot(mob/M as mob in players)
	set desc = "Removes a player from the game."
	set category = "Admin"
	if(!(M in admins))
		players << "[M.name] was booted by [usr]."
		if(M.client)
			del(M.client)

/mob/admin/verb/mute(mob/M as mob in players)
	set desc = "Toggles a player's ability to talk on or off."
	set category = "Admin"
	M = GetMob(M)
	if(!(M in admins) && M.client)
		if(!M.client.mute)
			M.client.mute = 1
			players - M << "[M.name] was muted by [usr]."
		else
			M.client.mute = 0
			players - M << "[M.name] was unmuted by [usr]."

/mob/admin/verb/swear_filter(action in list("add", "remove", "list", "clear"))
	set desc = "Set up the automated swear filter (saved as filter.txt)."
	set category = "Admin"
	var/F
	switch(action)
		if("add")
			F = input("Add what text to swear filter?") as text
			filter[F] = input("What action should be taken?") in list("mute", "boot", "replace", "block")
			if(filter[F] == "replace")
				filter[F] = input("What word should be substituted for the filtered word?") as text
		if("remove")
			filter.Remove(input("Remove what word from swear filter?") as text)
		if("list")
			for(F in filter)
				if(filter[F] == "mute" || filter[F] == "boot" || filter[F] == "block")
					usr << "<b>[F]</b>: [filter[F]]"
				else
					usr << "<b>[F]</b>: replace with [filter[F]]"
		if("clear")
			filter.Cut()
	SaveFilter()
