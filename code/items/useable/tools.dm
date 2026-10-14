/obj/item/useable/nonexpendable
	stackable = 0

/obj/item/useable/nonexpendable/com_scanner
	name = "comm scanner"
	desc = "A handy device, the comm scanner is capable of tracking the location signals broadcast by bases and homing beacons, and even miners--friend or foe alike. Comm scanners require both energy and a good bit of brains to use."
	icon_state = "com scanner"
	weight = 1
	value = 3500
	powerDrain = 4
	delay = 13
	range = 6

/obj/item/useable/nonexpendable/locator
	name = "locator device"
	desc = "Locator devices are small handheld gadgets attuned to the tracking signals emitted by fellow miners or team homing beacons, and especially attuned to pick up location signals from home base with ease."
	icon_state = "locator device"
	weight = 0.5
	value = 600
	powerDrain = 2
	delay = 8
	range = 6

/obj/item/useable/nonexpendable/omni_tool
	name = "omni-tool"
	desc = "A handy gizmo, the omni-tool combines the functions of an entire tool kit full of power tools into one easy-to-carry gadget. It is, unfortunately, not quite so easy-to-use--using the omni-tool requires both intelligence and skill, but is invaluable for both servicing your team's machinery to keep it in peak condition and sabotaging that of your enemies, although it does require a very small bit of power"
	icon_state = "omni-tool"
	weight = 0.5
	value = 1200
	delay = 10
	useAnim = "action"
	powerDrain = 1

/obj/item/useable/nonexpendable/orefinder
	desc = "An invaluable tool, the orefinder uses advanced sonar techniques to detect solid, dense ore formations embedded in dirt. It drains relatively minor amounts of power, but unfortunately it does require quite a bit of manual fine-tuning--it takes a pretty bright user to use the orefinder effectively."
	icon_state = "orefinder"
	weight = 1
	value = 1000
	delay = 9
	powerDrain = 3
	range = 6

/obj/item/useable/nonexpendable/portable_decontamination_unit
	desc = "This helpful (although somewhat clumsy) tool can be used to clean the user or his or her teammates of radiation they've picked up. It is relatively easy to use, although it drains a good deal of power each use."
	icon_state = "decontam"
	weight = 1
	value = 1500
	delay = 15
	powerDrain = 5

/obj/item/useable/nonexpendable/teleport
	name = "personal teleporter"
	icon_state = "teleporter"
	var/destination
	weight = 0.5
	value = 4000
	powerDrain = 16
	delay = 10
	range = 6

/obj/item/useable/nonexpendable/teleport/UseBy(mob/player/M, target)
	if(..())
		var/time = M.act_delay
		if(!destination)
			destination = "Home base"
		M.act_delay = 0
		if(!M.Teleport(GetTurf(teleports[M.team.name][destination])))
			M << "<b>*TELEPORT MALFUNCTION: Destination teleport blocked! Aborting teleport...*</b>"
		M.act_delay = time

/obj/item/useable/nonexpendable/teleport/verb/tune(Destination in teleports[usr.team.name])
	set src in usr.client.screen
	destination = Destination

/obj/item/useable/nonexpendable/com_scanner/UseBy(mob/player/M, target)
	if(..())
		M << "Scanning location signals..."
		sleep(delay)
		var/dist
		for(var/atom/A in signals)
			if(A != M)
				dist = ((A.x - M.x) ** 2 + (A.y - M.y) ** 2) ** 0.5
				if(dist <= M.intelligence * 5)
					if(ismob(A))
						dist *= 3.5
					else
						dist *= 1.75
					if(rand(1, dist) - M.intelligence * 2.5 < 10)
						if(rand(1, dist) - M.intelligence * 2.5 < 10)
							M << "[abs(A.x - M.x)] paces [A.x < M.x ? "east" : "west"], [abs(A.y - M.y)] paces [A.y < M.y ? "north" : "south"] of [A.signal]"
						else
							M << "Unidentified signal detected [abs(A.x - M.x)] paces [A.x > M.x ? "east" : "west"], [abs(A.y - M.y)] paces [A.y > M.y ? "north" : "south"]"

/obj/item/useable/nonexpendable/locator/UseBy(mob/player/M, target)
	if(..())
		M << "Scanning location signals..."
		sleep(delay)
		var/dist
		for(var/atom/A in signals)
			if(A.team == M.team && A != M)
				dist = ((A.x - M.x) ** 2 + (A.y - M.y) ** 2) ** 0.5
				if(ismob(A))
					dist *= 2
				if(istype(A, /turf/base/spawnArea/spawnPoint) || rand(1, dist) - M.intelligence * 2 < 10)
					M << "[abs(A.x - M.x)] paces [A.x < M.x ? "east" : "west"], [abs(A.y - M.y)] paces [A.y < M.y ? "north" : "south"] of [A.signal]"

/obj/item/useable/nonexpendable/orefinder/UseBy(mob/player/M, A)
	if(..())
		var/distance
		for(var/turf/T in block(locate(M.x - 5, M.y - 5, M.z), locate(M.x + 5, M.y + 5, M.z)))
			if(T.density && (locate(/obj/item/ore) in T.contents))
				distance = (M.x - T.x) ** 2 + (M.y - T.y) ** 2
				distance = distance ** 0.5
				if(rand(1, 25) - M.intelligence < 8 - distance)
					T.OrePing(M)

/obj/item/useable/nonexpendable/portable_decontamination_unit/DefaultUse(mob/M)
	return src

/obj/item/useable/nonexpendable/portable_decontamination_unit/UseBy(mob/player/M, mob/player/target)
	var/healAmt = rand(1, 20) * M.intelligence
	target = GetMob(target)
	if(istype(target, /mob/player) && target.team == M.team && ..(M, target))
		target.radiation -= healAmt
		target.radiation = max(0, target.radiation)
		target.HUDBar("radiation")
		if(target != M)
			view(5, M) << "[M.name] uses a portable decontamination unit on [target.name]."
		else
			view(5, M) << "[M.name] decontaminates [Him(M)]self."

/obj/item/useable/nonexpendable/omni_tool/UseBy(mob/player/M, T)
	T = GetTurf(T)
	if(istype(T, /turf) && ..(M, T))
		var/obj/item/useable/planted/P = locate() in T
		var/obj/item/useable/installation/I = locate() in T
		var/obj/item/vehicle/V = locate() in T
		if(istype(I, /obj/item/useable/installation/bridge))
			I = locate() in T:contents - I
		if(P && P.team != M.team)
			var/N = rand(1, M.intelligence)
			if(N > 5)
				P.owner = null
				P.team = null
				P.Unplant()
				P.icon_state = initial(P.icon_state)
				P.name = initial(P.name)
				M << "Found and disarmed a [P.name]."
				oview(5, M) << "[M.name] disarms a [P.name] with [His(M)] trusty omni-tool."
			else
				P.name = initial(P.name)
				M << "Tripped a hidden [P.name]!"
				P.Trigger(M)
				if(P) del(P)
		else if(I)
			if(I.team != M.team)
				if(rand(1, M.dexterity + M.intelligence) > I.difficulty)
					I.Disarm(M)
				else
					I.Botch(M)
			else if(I.damageable && I.health < I.max_health)
				view(5, M) << "[M.name] repairs [I.name]."
				I.health += I.max_health / 4
				I.health = min(I.health, I.max_health)
		else if(V && V.driver != M)
			if(rand(1, 30) < M.dexterity + M.intelligence)
				if(V.health < V.max_health && V.max_health)
					view(5, M) << "[M.name] repairs [V.name]."
					V.health += V.max_health / 4
					V.health = min(V.health, V.max_health)
				else
					M << "\The [V.name] is in perfect condition."
			else
				if(V.health < V.max_health && V.max_health)
					M << "Oops! You botch the repair attempt!"
					V.health -= rand(1, round(M.strength / 3) + 6)
					if(V.health < 1)
						V.Die()
				else
					M << "\The [V.name] is in perfect condition."
