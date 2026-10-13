/obj/item/useable/installation
	icon = 'installation.dmi'
	var/isDense = 1
	var/isDamageable = 0
	var/difficulty = 10
	var/dismantleable = 0
	var/aquatic = 0
	// Numbers each timer loop; replanting starts a new one and the old one stops.
	var/tmp/tick_loop = 0
	useAnim = "action"

/obj/item/useable/installation/Plant()
	density = isDense
	damageable = isDamageable
	health = max_health
	buyer = usr.tag
	if(dismantleable)
		verbs.Add(/obj/item/useable/installation/proc/dismantle)
	. = ..()

/obj/item/useable/installation/Unplant()
	density = 0
	damageable = 0
	. = ..()

/obj/item/useable/installation/Die()
	Unplant()
	. = ..()

/obj/item/useable/installation/Use(turf/T as turf)
	set name = "use"
	set src in usr
	var/mob/player/M
	var/obj/item/useable/installation/bridge/I
	M = usr
	I = locate() in T
	if(!isturf(T))
		T = GetTurf(T)
	if(T && istype(T, /turf) && (T.Bridged() && !aquatic || !T.Bridged() && aquatic) && !T.density && length(T.contents - I) == 0 && ..(T))
		if(!stackable || quantity == 1)
			M.activeItem = null
			team = M.team
			owner = M
			Move(T)
			Plant()
			. = src
		else
			I = new type(T)
			I.team = M.team
			I.owner = M
			I.Plant()
			quantity--
			UpdateQuantity()
			. = I
		M.HUDUpdate("carry")

/obj/item/useable/installation/proc/Disarm(M as mob)

/obj/item/useable/installation/proc/Botch(atom/movable/M as mob)
	M << "Ooops!"
	M.TakeDamage(7, 0.8, 0.5, M, "omni-tool")

/obj/item/useable/installation/proc/UsedBy(M as mob)

/obj/item/useable/installation/proc/dismantle()
	set src in orange(1)
	if(usr.tag == buyer)
		Unplant()
		verbs.Remove(/obj/item/useable/installation/proc/dismantle)
	else
		usr << "Only the owner can dismantle that installation."
