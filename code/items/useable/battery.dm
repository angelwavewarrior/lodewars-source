/obj/item/useable/battery
	name = "battery charge"
	desc = "A quick, highly portable means of recharging energy sources, battery charges can be used to instantly refill a portion of your power supply, making them invaluable for keeping high-power equipment active in the field."
	icon_state = "battery"
	weight = 0.5
	delay = 5
	value = 150
	range = 6

/obj/item/useable/battery/Use()
	set name = "use"
	set src in usr
	var/mob/player/M
	var/boostAmt
	M = usr
	boostAmt = round(rand(1, M.intelligence) / 3) + 18
	if(..(src))
		M.energy = min(M.energy + boostAmt, M.max_energy)
		M.HUDBar("energy")
		view(5) << "[M.name] uses a battery charge."
		Discard()
