/obj/item/useable/planted
	icon = 'planted.dmi'
	var/radius
	var/frequency = 5

/obj/item/useable/planted/alarm
	desc = "Simple alarms capable of detecting approaching intruders through a combination of vibrations and careful scanning of communication channels to pick up enemy signals, these can be easily buried to provide a lasting warning system."
	icon_state = "motion sensor"
	value = 350
	weight = 0.5
	radius = 3
	delay = 7
	frequency = 20

/obj/item/useable/planted/shock_mine
	desc = "Shock mines are a high-powered, military-grade alternative to the humble stun mine, dispensing a powerful electrical blast to terminate trespassers with prejudice."
	icon_state = "shock mine"
	value = 150
	weight = 0.5
	delay = 6
	radius = 0

/obj/item/useable/planted/stun_mine
	desc = "Simple devices designed to catch trespassers with nonlethal force, stun mines can be buried quickly, safely, and easily, without fear of discharging under the user's feet, or even that of his or her teammates."
	icon_state = "stun mine"
	value = 90
	weight = 0.5
	delay = 6
	radius = 0

/obj/item/useable/planted/Plant()
	. = ..()
	Update()
	verbs.Remove(/obj/item/verb/help)
	layer = TURF_LAYER
	name = "dirt"
	spawn(10) Scan()

/obj/item/useable/planted/stun_mine/Trigger(mob/M as mob)
	if(M.team != team)
		view(5, src) << "[M.name] trips a stun mine!"
		if(M.vehicle) M = M.vehicle
		M.TakeDamage(25, 0.4, 0.15, owner, "stun mine")
		loc = null
		del(src)

/obj/item/useable/planted/shock_mine/Trigger(mob/M as mob)
	if(M.team != team)
		view(5, src) << "[M.name] triggers a shock mine!"
		M.TakeDamage(35, 0.8, 0.6, owner, "shock mine")
		if(M.vehicle)
			M.vehicle.TakeDamage(35, 0.8, 0.6, owner, "shock mine")
		loc = null
		del(src)

/obj/item/useable/planted/alarm/Trigger(atom/M as mob)
	if(M.team != team)
		team.SecurityChannel(owner) << "Alarm sensor: <b>Enemy detected at [M.x],[M.y]!</b>"

/obj/item/useable/planted/proc/Scan()
	if(!planted)
		return
	for(var/mob/player/M in range(radius, src))
		M = GetMob(M)
		if(M && M.team != team)
			Trigger(M)
			break
	spawn(frequency) Scan()

/obj/item/useable/planted/proc/Trigger(M as mob)

/obj/item/useable/planted/proc/Update()
	if(isturf(loc) && planted)
		if(loc.density)
			icon_state = "wall"
		else
			icon_state = "floor"

/obj/item/useable/planted/UseBy(mob/player/M, A)
	var/T
	T = GetTurf(A)
	if(istype(T, /turf/dirt) && (!locate(/obj/item/useable/planted) in T) && CanReach(GetTurf(src), GetTurf(A)) && ..(M, A))
		var/P = new type(GetTurf(A))
		P:owner = M
		P:team = M.team
		P:Plant()
		Discard(M)
