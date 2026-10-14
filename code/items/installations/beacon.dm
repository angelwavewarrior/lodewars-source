/obj/item/useable/installation/beacon
	name = "homing beacon"
	desc = "The homing beacon is a breathtakingly simple device, little more than a comm transmitter and a mounting stand, homing beacons broadcast a tracking signal with a custom-input signature to allow teammates with tracking devices to navigate easily. Beware, however, as clever enemies with comm scanners might be navigating their way by your homing beacons, as well!"
	icon_state = "beacon"
	value = 400
	weight = 1
	dismantleable = 1
	delay = 9
	max_health = 35
	defense = 20
	isDamageable = 1
	signal = "Homing beacon"

/obj/item/useable/installation/beacon/Disarm(mob/player/M as mob)
	if(rand(1, M.intelligence + M.dexterity) > difficulty)
		Unplant()
		M << "Homing beacon dismantled!"
	else
		M << "Homing beacon destroyed!"
		Die()

/obj/item/useable/installation/beacon/Plant()
	signals.Add(src)
	verbs.Add(/obj/item/useable/installation/beacon/proc/Input)
	overlays.Add(icon('team_badge.dmi', team.name))
	icon = 'installed.dmi'
	. = ..()

/obj/item/useable/installation/beacon/Unplant()
	overlays.Cut()
	verbs.Remove(/obj/item/useable/installation/beacon/proc/Input)
	signal = "Homing beacon"
	signals.Remove(src)
	icon = 'installation.dmi'
	. = ..()

/obj/item/useable/installation/beacon/Die()
	signals.Remove(src)
	. = ..()

/obj/item/useable/installation/beacon/UsedBy(mob/player/M)
	if(signal == "Homing beacon" && M.team == team)
		InputBy(M, input(M, "Beacon signal:") as text)

/obj/item/useable/installation/beacon/proc/Input(Text as text)
	set name = "input"
	set desc = "Input the description for the frequency broadcast by a homing beacon."
	set src in view(1)
	InputBy(usr, Text)

/obj/item/useable/installation/beacon/proc/InputBy(mob/M, Text)
	// Only the beacon's own team names it, so an enemy can't label it first.
	if(!istype(M, /mob/player) || M:team != team)
		return
	if(length(Text) > 100)
		Text = copytext(Text, 0, 101)
	signal = Text
	verbs.Remove(/obj/item/useable/installation/beacon/proc/Input)
