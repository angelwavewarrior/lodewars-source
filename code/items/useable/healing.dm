/obj/item/useable/healing

/obj/item/useable/healing/bio_kit
	name = "biofix kit"
	desc = "A more thorough and elaborate medical alternative to med patches, biofix kits are practially portable hospitals, capable of quickly and easily healing serious wounds, as well as providing minor relief from radiation and providing for lasting well-being by boosting the body's basic healing rate."
	icon_state = "biofix kit"
	weight = 1
	value = 200
	delay = 6

/obj/item/useable/healing/med_patch
	desc = "A simple, easy-to-use bandage coated with special contact drugs. Although a med patch can't provide any real long-term medical repair, it can keep wounded soldiers or workers on their feet for a long time."
	icon_state = "med patch"
	weight = 0.5
	value = 30
	delay = 4

/obj/item/useable/healing/med_patch/Use(mob/player/target as mob)
	set name = "use"
	set src in usr
	var/mob/player/M
	M = usr
	target = GetMob(target)
	if(istype(target, /mob/player) && ..())
		var/healAmt = rand(12, round(M.intelligence * 0.65) + 10)
		target.health = min(target.health + healAmt, target.max_health)
		target.HUDBar("health")
		if(target != M)
			view(5) << "[M.name] uses a med patch on [target.name] for [healAmt] health."
		else
			view(5) << "[M.name] uses a med patch on [Him(M)]self for [healAmt] health."
		Discard()

/obj/item/useable/healing/bio_kit/Use(mob/player/target as mob)
	set name = "use"
	set src in usr
	var/mob/player/M
	M = usr
	target = GetMob(target)
	if(istype(target, /mob/player) && ..())
		var/healAmt = rand(30, M.intelligence + rand(1, M.intelligence) + 30)
		target.health = min(target.health + healAmt, target.max_health)
		target.radiation = max(0, target.radiation - 50 + rand(1, M.intelligence * 2.5))
		target.regen = 20
		target.HUDBar("health")
		if(target != M)
			view(5) << "[M.name] uses a biofix kit on [target.name] for [healAmt] health."
		else
			view(5) << "[M.name] uses a biofix kit on [Him(M)]self for [healAmt] health."
		Discard()
