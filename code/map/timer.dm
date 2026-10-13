/obj/timer
	icon = 'statnum.dmi'
	layer = 15
	var/time = 40
	var/start = 40
	screen_loc = "12:16,12:17"

/obj/timer/proc/TickTock()
	overlays.Cut()
	icon_state = num2text(time % 10)
	if(time >= 10)
		var/obj/hud/H = new()
		H.icon = icon
		H.icon_state = num2text(round(time / 10))
		H.pixel_x = -8
		H.layer = 15
		overlays.Add(H)
		del(H)
	if(time > 0)
		// Count the minute down after it has passed, so a 15 minute round shows 15 and lasts 15.
		// end_game may set 0 while this waits.
		spawn(600)
			time = max(0, time - 1)
			TickTock()
		if(time == 5)
			players << "<b>Only five minutes remaining!</b>"
		else if(time == 1)
			players << "<b>One minute left--hurry back to your base to cash in your ore!</b>"
	else
		EndMap()
