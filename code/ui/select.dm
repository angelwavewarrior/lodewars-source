/obj/select

/turf/characterSelect
	name = ""
	icon = 'select_background.dmi'

/turf/teamSelect
	name = ""
	icon = 'team_background.dmi'

/obj/select/raceSelect
	icon = 'races.dmi'
	var/charType

/obj/select/teamSelect

/obj/select/raceSelect/Bolo
	desc = "Bolos are huge six-limbed mammoths that tower over the competition... literally. The strength of a bolo is tremendous, and their tough hides can withstand great amounts of punishment, but neither their hands nor their brains are very developed; moreover, their huge size makes for a cramped fit in narrow tunnels, although it does allow them to wade through water with ease.."
	icon_state = "Bolo_00"
	charType = /mob/player/bolo

/obj/select/raceSelect/Horzek
	desc = "Horzeks are large, lumbering thugs that are short on brains and long on brawn. Although they have impressive strength, horzeks tend to be lazy and have little work ethic--why work to get something when you can beat it out of someone smaller?"
	icon_state = "Horzek"
	charType = /mob/player/horzek

/obj/select/raceSelect/Jezzer
	desc = "Jezzers are slithering, multi-limbed worms who have adapted over the eons to a life of underground tunneling and exploration. Digging is simply their nature, making them ideal diggers, though they are relatively slow and fragile otherwise."
	icon_state = "Jezzer"
	charType = /mob/player/jezzer

/obj/select/raceSelect/Mobbel
	desc = "The mobbel are an amphibious race of underground dwellers. Though they are small and fragile-looking, mobbels' compact build possesses considerable muscle, making them fairly strong, agile, and tough all at once. Their webbed hands are clumsy and bad at digging, but they are expert swimmers and divers."
	icon_state = "Mobbel"
	charType = /mob/player/mobbel

/obj/select/raceSelect/Scradax
	desc = "Scradax are smallish, scurrying creatures not unlike Earth's rodents, except several feet long and sentient. Scradax are adept at crawling through cramped, narrow tunnels to evade--or give!--pursuit, and although they tend to be frail they are keen hunters and vicious fighters."
	icon_state = "Scradax"
	charType = /mob/player/scradax

/obj/select/raceSelect/Zentan
	desc = "The Zentan are a crafty, intelligent race notorious for their sense of opportunism. They understand technology easily and, although not much for heavy labor, are quick with both their fingers and their wits, making them cunning saboteurs."
	icon_state = "Zentan"
	charType = /mob/player/zentan

/turf/characterSelect/New()
	icon_state = "[x - 2],[y - 2]"
	pixel_x = 16

/turf/teamSelect/New()
	icon_state = "[x - 2],[y - 2]"
	pixel_x = 16

/obj/select/verb/help()
	set src in range(6)
	DblClick()

/obj/select/teamSelect/Click()
	var/mob/observer/O
	O = usr
	if(istype(O, /mob/observer) && O.char && !(O in observers))
		if(!team.Full() || (O.tag in team.allMembers))
			var/M = O.char
			O.char = null
			M:HUDMode = O.HUDMode
			M:oldHUDMode = M:HUDMode
			M:insurance = O.insurance
			M:recovered = O.recovered
			M:key = O.key
			team.members.Add(M)
			M:SelectTeam(team)
		else
			usr << "That team is full. Please pick another."

/obj/select/teamSelect/DblClick()
	usr << "<b>[name]</b>"
	usr << "[team.members.len] players"
	usr << "[team.desc]\n"

/obj/select/raceSelect/New()
	var/obj/O
	for(var/i = 0, i < 2, i++)
		O = new()
		O.icon = 'racetitle.dmi'
		O.icon_state = "[name][i]"
		O.pixel_x = i * 32 + 32
		overlays.Add(O)
		del(O)

/obj/select/raceSelect/DblClick()
	usr << "<b>[name]</b>"
	usr << "[desc]\n"

/obj/select/raceSelect/Click()
	var/M
	var/mob/observer/O
	M = new charType
	O = usr
	if(istype(O, /mob/observer) && !(O in observers))
		M:name = usr.name
		M:gender = usr.gender
		O.char = M
		O.loc = locate(7, 7, 4)

/obj/select/raceSelect/Bolo/New()
	var/obj/O
	O = new()
	O.icon = icon
	O.icon_state = "Bolo_10"
	O.pixel_x = 32
	overlays.Add(O)
	del(O)
	O = new()
	O.icon = icon
	O.icon_state = "Bolo_01"
	O.pixel_y = 32
	overlays.Add(O)
	del(O)
	O = new()
	O.icon = icon
	O.icon_state = "Bolo_11"
	O.pixel_x = 32
	O.pixel_y = 32
	overlays.Add(O)
	del(O)
	. = ..()
