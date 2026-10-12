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
		player_save["[race]/rank"] >> rank
		player_save["[race]/experience"] >> experience
		player_save["[race]/cash"] >> cash
		player_save["[race]/bank"] >> bank
		player_save["[race]/debt"] >> debt
		loaded = TRUE

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
	if(rank > 30)
		rank = 0
		cash = 0
		bank = 0
		debt = 0
		experience = 0

/*/mob/player/proc/LoadCharacter()
	var/race
	var/savefile/F
	var/loadFile
	var/loaded
	var/time
	var/count
	var/check
	loadFile = client.Import()
	loaded = 0
	count = 0
	if(map && !map.saved)
		return
	switch(type)
		if(/mob/player/zentan) race = "zentan"
		if(/mob/player/jezzer) race = "jezzer"
		if(/mob/player/scradax) race = "scradax"
		if(/mob/player/horzek) race = "horzek"
		if(/mob/player/mobbel) race = "mobbel"
		if(/mob/player/bolo) race = "bolo"
	while(!loadFile && count < 3)
		loadFile = client.Import()
		sleep(5)
		count++
	if(loadFile)
		F = new(loadFile)
		F["check"] >> check
		check = RC5_Decrypt(check, "snakesdonthavearms")
		if(!check || check == name)
			F["[race]/rank"] >> rank
			if(!text2num(RC5_Decrypt(rank, "snakesdonthavearms")))
			rank = text2num(RC5_Decrypt(rank, "snakesdonthavearms"))
			F["[race]/experience"] >> experience
			if(!text2num(RC5_Decrypt(experience, "snakesdonthavearms")))
			experience = text2num(RC5_Decrypt(experience, "snakesdonthavearms"))
			F["[race]/cash"] >> cash
			if(!text2num(RC5_Decrypt(cash, "snakesdonthavearms")))
			cash = text2num(RC5_Decrypt(cash, "snakesdonthavearms"))
			F["[race]/bank"] >> bank
			bank = text2num(RC5_Decrypt(bank, "snakesdonthavearms"))
			F["[race]/debt"] >> debt
			debt = text2num(RC5_Decrypt(debt, "snakesdonthavearms"))
			F["[race]/time"] >> time
			time = text2num(RC5_Decrypt(time, "snakesdonthavearms"))
			F["[race]/sum"] >> check
			if(check) check = text2num(RC5_Decrypt(check, "snakesdonthavearms"))
			if(check && check != rank + cash + experience)
				rank = 0
				cash = 0
				experience = 0
				loaded = 0
				admins << "Bogus savefile authentication from [ckey]."
			if(!rank)
				loaded = 0
			else
				loaded = 1
		else
			admins << "Bogus savefile authentication from [ckey]."
	if(length(file("saves/[ckey(name)].sav")))
		F = new(file("saves/[ckey(name)].sav"))
		var/oldTime = time
		F["[race]/time"] >> time
		time = text2num(RC5_Decrypt(time, "snakesdonthavearms"))
		if(map && map.timer)
			time += map.timer.time * 600
		if(time >= oldTime || !loaded)
			F["check"] >> check
			check = RC5_Decrypt(check, "snakesdonthavearms")
			if(!check || check == name)
				F["[race]/rank"] >> rank
				rank = text2num(RC5_Decrypt(rank, "snakesdonthavearms"))
				F["[race]/experience"] >> experience
				experience = text2num(RC5_Decrypt(experience, "snakesdonthavearms"))
				F["[race]/cash"] >> cash
				cash = text2num(RC5_Decrypt(cash, "snakesdonthavearms"))
				F["[race]/bank"] >> bank
				bank = text2num(RC5_Decrypt(bank, "snakesdonthavearms"))
				F["[race]/debt"] >> debt
				debt = text2num(RC5_Decrypt(debt, "snakesdonthavearms"))
				F["[race]/sum"] >> check
				if(check) check = text2num(RC5_Decrypt(check, "snakesdonthavearms"))
				if(check && check != rank + cash + experience)
					rank = 0
					cash = 0
					experience = 0
					loaded = 0
					admins << "Bogus savefile authentication from [ckey]."
			else
				admins << "Bogus savefile authentication from [ckey]."
			if(!rank)
				loaded = 0
			else
				loaded = 1
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
	if(rank > 30)
		rank = 0
		cash = 0
		bank = 0
		debt = 0
		experience = 0*/
