/obj/item/useable/pill
	name = "rad pills"
	desc = "Radiation pills are a simple, portable way to protect oneself from harmful background radiation. While rad pills provide minimal protection from direct, intense radiation, they can readily block even moderately high levels of radiation almost harmlessly."
	icon_state = "rad pills"
	weight = 0.5
	delay = 3
	value = 100
	range = 6

/obj/item/useable/pill/DefaultUse(mob/M)
	return src

/obj/item/useable/pill/UseBy(mob/player/M, target)
	if(..(M, src))
		M.radBlock = 30
		view(5, M) << "[M.name] takes a radiation pill."
		Discard(M)
