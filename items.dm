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

/obj/item/useable/nonexpendable/teleport/Use()
	set name = "use"
	set src in usr
	var/mob/player/M
	M = usr
	if(..())
		var/time = M.act_delay
		if(!destination)
			destination = "Home base"
		M.act_delay = 0
		if(!usr.Teleport(GetTurf(teleports[usr.team.name][destination])))
			usr << "<b>*TELEPORT MALFUNCTION: Destination teleport blocked! Aborting teleport...*</b>"
		M.act_delay = time

/obj/item/useable/nonexpendable/teleport/verb/tune(Destination in teleports[usr.team.name])
	set src in usr.client.screen
	destination = Destination

/obj/item/useable/nonexpendable/com_scanner/Use()
	set name = "use"
	set src in usr
	if(..())
		var/M = usr
		usr << "Scanning location signals..."
		sleep(delay)
		var/dist
		for(var/atom/A in signals)
			if(A != usr)
				dist = ((A.x - M:x) ** 2 + (A.y - M:y) ** 2) ** 0.5
				if(dist <= M:intelligence * 5)
					if(ismob(A))
						dist *= 3.5
					else
						dist *= 1.75
					if(rand(1, dist) - M:intelligence * 2.5 < 10)
						if(rand(1, dist) - M:intelligence * 2.5 < 10)
							usr << "[abs(A.x - M:x)] paces [A.x < M:x ? "east" : "west"], [abs(A.y - M:y)] paces [A.y < M:y ? "north" : "south"] of [A.signal]"
						else
							usr << "Unidentified signal detected [abs(A.x - M:x)] paces [A.x > M:x ? "east" : "west"], [abs(A.y - M:y)] paces [A.y > M:y ? "north" : "south"]"

/obj/item/useable/nonexpendable/locator/Use()
	set name = "use"
	set src in usr
	if(..())
		var/M = usr
		usr << "Scanning location signals..."
		sleep(delay)
		var/dist
		for(var/atom/A in signals)
			if(A.team == M:team && A != usr)
				dist = ((A.x - M:x) ** 2 + (A.y - M:y) ** 2) ** 0.5
				if(ismob(A))
					dist *= 2
				if(istype(A, /turf/base/spawnArea/spawnPoint) || rand(1, dist) - M:intelligence * 2 < 10)
					usr << "[abs(A.x - M:x)] paces [A.x < M:x ? "east" : "west"], [abs(A.y - M:y)] paces [A.y < M:y ? "north" : "south"] of [A.signal]"

/obj/item/useable/nonexpendable/orefinder/Use(A as mob|obj|turf|area)
	set name = "use"
	set src in usr
	var/mob/player/M
	M = usr
	if(..())
		var/distance
		for(var/turf/T in block(locate(M.x - 5, M.y - 5, M.z), locate(M.x + 5, M.y + 5, M.z)))
			if(T.density && (locate(/obj/item/ore) in T.contents))
				distance = (M.x - T.x) ** 2 + (M.y - T.y) ** 2
				distance = distance ** 0.5
				if(rand(1, 25) - M.intelligence < 8 - distance)
					T.OrePing(M)

/obj/item/useable/nonexpendable/portable_decontamination_unit/DefaultUse()
	return src

/obj/item/useable/nonexpendable/portable_decontamination_unit/Use(mob/player/target as mob)
	set name = "use"
	set src in usr
	var/mob/player/M = usr
	var/healAmt = rand(1, 20) * M.intelligence
	target = GetMob(target)
	if(istype(target, /mob/player) && target.team == M.team && ..(target))
		target.radiation -= healAmt
		target.radiation = max(0, target.radiation)
		target.HUDBar("radiation")
		if(target != M)
			view(5) << "[M.name] uses a portable decontamination unit on [target.name]."
		else
			view(5) << "[M.name] decontaminates [Him(M)]self."

/obj/item/useable/nonexpendable/omni_tool/Use(T as turf)
	set name = "use"
	set src in usr
	var/mob/player/M
	M = usr
	T = GetTurf(T)
	if(istype(T, /turf) && ..(T))
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
				usr << "Found and disarmed a [P.name]."
				oview(5) << "[usr.name] disarms a [P.name] with [His(usr)] trusty omni-tool."
			else
				P.name = initial(P.name)
				usr << "Tripped a hidden [P.name]!"
				P.Trigger(M)
				if(P) del(P)
		else if(I)
			if(I.team != M.team)
				if(rand(1, M.dexterity + M.intelligence) > I.difficulty)
					I.Disarm(M)
				else
					I.Botch(M)
			else if(I.damageable && I.health < I.max_health)
				view(5) << "[usr.name] repairs [I.name]."
				I.health += I.max_health / 4
				I.health = min(I.health, I.max_health)
		else if(V && V.driver != src)
			if(rand(1, 30) < M.dexterity + M.intelligence)
				if(V.health < V.max_health && V.max_health)
					view(5) << "[usr.name] repairs [V.name]."
					V.health += V.max_health / 4
					V.health = min(V.health, V.max_health)
				else
					usr << "\The [V.name] is in perfect condition."
			else
				if(V.health < V.max_health && V.max_health)
					usr << "Oops! You botch the repair attempt!"
					V.health -= rand(1, round(M.strength / 3) + 6)
					if(V.health < 1)
						V.Die()
				else
					usr << "\The [V.name] is in perfect condition."

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

/obj/item/useable/pill/DefaultUse()
	return src

/obj/item/useable/pill/Use()
	set name = "use"
	set src in usr
	var/mob/player/M
	M = usr
	if(..(src))
		M.radBlock = 30
		view(5) << "[M.name] takes a radiation pill."
		Discard()

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
		view(5, src) << "[M.name] triggers a stun mine!"
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

/obj/item/useable/planted/Use(A as mob|obj|turf|area)
	set name = "use"
	set src in usr
	var/T
	T = GetTurf(A)
	if(istype(T, /turf/dirt) && (!locate(/obj/item/useable/planted) in T) && CanReach(GetTurf(src), GetTurf(A)) && ..(A))
		var/P = new type(GetTurf(A))
		var/M = usr
		P:owner = M
		P:team = M:team
		P:Plant()
		Discard()

/obj/item/useable/explosive/proc/Detonate()
	if(user) power += user.intelligence
	Explosion(GetTurf(src), power, radius, user)
	loc = null
	spawn(10) del(src)

/obj/item/useable/explosive/micro_charge/Click()
	var/M
	M = usr
	if(loc && M == user)
		Detonate()
	else
		. = ..()

/obj/item/useable/explosive/micro_charge/Use(A as mob|obj|turf|area)
	set name = "use"
	set src in usr
	var/T
	T = GetTurf(A)
	if(istype(T, /turf/dirt) && ..(A))
		var/obj/item/useable/explosive/micro_charge/C = new(GetTurf(A))
		C.user = usr
		C.Plant()
		Discard()

/obj/item/useable/explosive/blast_pack/Use(A as mob|obj|turf|area)
	set name = "use"
	set src in usr
	if((CanReach(usr, A) || A:density) && ..(A))
		var/M = usr
		if(quantity == 1)
			M:activeItem = null
			Move(GetTurf(A))
			user = usr
			Plant()
			Arm()
		else
			var/obj/item/useable/explosive/blast_pack/P = new(GetTurf(A))
			P.user = usr
			P.Plant()
			P.Arm()
			quantity--
			UpdateQuantity()
			M:HUDUpdate("carry")
		fuse = initial(fuse)

/obj/item/useable/explosive/blast_pack/proc/Arm()
	spawn(fuse) Detonate()

/obj/item/useable/explosive/grenade/Use(A as mob|obj|turf|area)
	set name = "use"
	set src in usr
	var/T
	var/range
	T = GetTurf(src)
	range = ((A:x - T:x) ** 2 + (A:y - T:y) ** 2) ** 0.5
	if(..(A))
		var/obj/bullet/rocket/grenade/G = new(GetTurf(src))
		G.GetHeading(range, GetTurf(src), GetTurf(A))
		G.owner = usr
		G.team = usr.team
		G.power = power
		G.Fly()
		Discard()

/obj/item/proc/Dropped()
