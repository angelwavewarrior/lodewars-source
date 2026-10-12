// Logout clears key before its delayed save runs, so the save keeps the ckey from Login.
/mob/player/var/tmp/save_ckey

/mob/player/proc/SaveCharacter()
	if(map && !map.saved)
		return
	if(!save_ckey)
		return
	if(rank && experience != "unsaved")
		var/race
		switch(type)
			if(/mob/player/zentan) race = "zentan"
			if(/mob/player/jezzer) race = "jezzer"
			if(/mob/player/scradax) race = "scradax"
			if(/mob/player/horzek) race = "horzek"
			if(/mob/player/bolo) race = "bolo"
			if(/mob/player/mobbel) race = "mobbel"
		var/savefile/F = new("saves/player/[save_ckey].sav")
		F["[race]/rank"] << rank
		F["[race]/experience"] << experience
		F["[race]/cash"] << cash
		F["[race]/bank"] << bank
		F["[race]/debt"] << debt
		return TRUE

/mob/player/proc/LoadCharacter()
	if(map && !map.saved) return
	var/loaded = FALSE
	if(save_ckey && fexists("saves/player/[save_ckey].sav"))
		var/race = null
		switch(type)
			if(/mob/player/zentan) race = "zentan"
			if(/mob/player/jezzer) race = "jezzer"
			if(/mob/player/scradax) race = "scradax"
			if(/mob/player/horzek) race = "horzek"
			if(/mob/player/mobbel) race = "mobbel"
			if(/mob/player/bolo) race = "bolo"
		if(!race) return
		var/savefile/player_save = new("saves/player/[save_ckey].sav")
		if(race in player_save.dir)
			player_save["[race]/rank"] >> rank
			player_save["[race]/experience"] >> experience
			player_save["[race]/cash"] >> cash
			player_save["[race]/bank"] >> bank
			player_save["[race]/debt"] >> debt
			loaded = TRUE

	if(rank > 30)
		rank = 0
		cash = 0
		bank = 0
		debt = 0
		experience = 0
	if(loaded)
		if(debt && bank >= debt)
			bank -= debt
			debt = 0
		if(cash < 99999 && bank)
			var/debit = 99999 - cash
			bank -= debit
			cash += debit
		else if(cash > 99999)
			cash = 99999
		if(rank)
			var/V
			for(var/i = 1, i <= rank, i++)
				max_health++
				V = statOrder[(i - 1) % 8 + 1]
				vars[V] += 1
				if(V == "strength")
					carry++
	else if(!rank)
		experience = 0
		if(!cash)
			cash = 1000
			rank = 0
