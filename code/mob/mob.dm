/mob
	var/shopping = 0
	var/chat_time
	var/switching
	var/obj/item/vehicle/vehicle
	var/showScores
	var/HUDMode = 0
	var/oldHUDMode = 0
	var/insurance
	var/recovered
	var/mode = "default"

/mob/verb/say(chat as text)
	set desc = "Broadcasts a message to all players in the game."
	Chat(chat, players)

/mob/verb/who()
	set desc = "Displays a listing of all players."
	var/teamImg
	for(var/team/T in teams)
		teamImg = "\icon[T.comm]"
		usr << "[teamImg]<b><font color=[T.fontColor]>[T.title]</font></b>"
		for(var/mob/player/M in T.members)
			usr << "      [M.name] ([M.race])"
	usr << ""
	usr << "<b>Observers</b>"
	for(var/mob/observer/P in players)
		usr << "      [P.name]"

/mob/verb/toggle_panels()
	set name = "show/hide stat panels"
	set desc = "Turns the stat panels on or off."
	client.show_verb_panel = !client.show_verb_panel

/mob/verb/forum()
	set desc = "Opens the Lode Wars forum."
	usr << link("http://www.byond.com/forums/49/5149/index.cgi")

/mob/verb/toggle_scores()
	set name = "show/hide scores"
	set desc = "Turns the on-screen score bar on or off."
	showScores = !showScores
	for(var/team/T in teams)
		if(showScores)
			client.screen.Add(T.scoreDisplay)
		else
			client.screen.Remove(T.scoreDisplay)

/mob/verb/toggle_hud()
	set name = "condense/expand HUD"
	set desc = "Toggles between the default HUD and a smaller, condensed version."
	if(!shopping)
		HUDMode = !HUDMode
		oldHUDMode = HUDMode
		LoadHUD()
		if(istype(src, /mob/player))
			var/P = src
			for(var/obj/item/O in P:inventory)
				O.UpdateQuantity()
			P:DisplayStats()
			if(P:team)
				P:HUDTeam()
	else
		oldHUDMode = !oldHUDMode

/mob/proc/Items()
	var/list/items
	items = list()
	for(var/obj/item/O in Around(src, 1))
		if(isturf(O.loc))
			items.Add(O)
	. = items

/mob/proc/Go(Dir)
	if(!vehicle)
		if(Dir) Move(get_step(GetTurf(src), Dir), Dir)
	else
		vehicle.Go(Dir)

/mob/proc/Chat(chat as text, recievers, tags)
	var/startSearch
	var/teamImg
	startSearch = 1
	if(!client) return
	if(!(src in admins))
		var/stripped = ckey(chat)
		for(var/F in filter)
			startSearch = 1
			if(filter[F] == "boot" || filter[F] == "mute" || filter[F] == "block")
				while(findtext(stripped, F, startSearch, 0))
					startSearch = findtext(stripped, F, startSearch, 0) + length(F)
					if(filter[F] == "mute")
						if(!client.mute)
							players - src << "[src] was muted for swearing."
							client.mute = 1
					else if(filter[F] == "boot")
						players << "[src] was booted for swearing."
						del(client)
						return
					else if(filter[F] == "block")
						chat = "*CENSORED*"
						tags = "b"
						break
			else
				// Search on past each replacement, which may contain the word itself.
				while(findtext(chat, F, startSearch, 0))
					startSearch = findtext(chat, F, startSearch, 0)
					chat = copytext(chat, 1, startSearch) + filter[F] + copytext(chat, startSearch + length(F), 0)
					startSearch += length(filter[F])
	if(client.mute)
		recievers = list(src)
	chat_time = max(chat_time, world.time)
	if(team)
		teamImg = "\icon[team.comm]"
	// Search from the start. startSearch is left over from the filter loops.
	while(findtext(chat, "\n"))
		chat_time += 6
		chat = "[copytext(chat, 1, findtext(chat, "\n"))][copytext(chat, findtext(chat, "\n") + 1, 0)]"
	if(length(chat) > 250)
		var/len
		len = findtext(chat, ".", 250, 275)
		if(!len)
			len = findtext(chat, "!", 250, 275)
			if(!len)
				len = findtext(chat, "?", 250, 275)
				if(!len)
					len = findtext(chat, ":", 250, 275)
					if(!len)
						len = findtext(chat, ";", 250, 275)
						if(!len)
							len = findtext(chat, ",", 250, 275)
							if(!len)
								len = findtext(chat, "-", 250, 275)
								if(!len)
									len = findtext(chat, " ", 250, 275)
									if(!len)
										len = 250
		if(length(chat) > len + 1)
			spawn(1) Chat(copytext(chat, len + 1, 0), recievers, tags)
		chat = copytext(chat, 1, len + 1)
	if(chat_time > world.time + 85)
		src << "Booted for spamming."
		recievers - src << "[src] was booted for spam."
		// Logout saves and then deletes the mob.
		del(client)
	else
		chat = html_encode(chat)
		spawn(max(0, chat_time - world.time))
			recievers << "[teamImg]<b>[name]</b>\..."
			if(tags)
				recievers << "<[tags]>: [chat]</[tags]>"
			else
				recievers << ": [chat]"
		if(chat_time > world.time + 10)
			chat_time += 30
		else
			chat_time += 15

/mob/Stat()
	if(client && client.show_verb_panel)
		if(statpanel("Teams"))
			if(map && map.timer) stat("Minutes remaining:", map.timer.time)
			if(teams)
				for(var/team/E in teams)
					stat("[Proper(E.name)] team:", "[E.score] points")
					for(var/mob/player/M in E.members)
						M = GetMob(M)
						stat("[M.name] ([M.race])")
			if(usr.key == "Leftley")
				stat("CPU", world.cpu)
