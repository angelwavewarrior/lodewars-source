/proc/Explode(turf/T as turf, power, range, attacker as mob, distance, source="explosion")
	var/mob/player/M
	new/obj/FX(T, 'explosion.dmi', 6)
	for(var/atom/movable/A in T)
		if(A.damageable)
			if(ismob(A))
				M = A
				if(("torso" in M.equipment) && istype(M.equipment["torso"], /obj/item/equippable/armor/blast_jacket))
					A.TakeDamage(power * max(0.5, 1 - distance / max(range, 1)) * 0.4, 0.6, 0.8, attacker, source)
				else
					if(istype(A, /mob/player/bolo))
						power = round(power * 1.75)
					A.TakeDamage(power * max(0.5, 1 - distance / max(range, 1)), 0.6, 0.8, attacker, source)
			else
				A.TakeDamage(power * max(0.5, 1 - distance / max(range, 1)), 0.6, 0.8, attacker, source)
	if(istype(T, /turf/dirt) && T.density)
		T.Dug()

/proc/Explosion(T as turf, power, range, atom/attacker as mob, source)
	var/dist
	for(var/turf/U in block(locate(T:x - range, T:y - range, 2), locate(T:x + range, T:y + range, 2)))
		if(round(round(((U.x - T:x) ** 2 + (U.y - T:y) ** 2) ** 0.5, 0.5)) <= range)
			dist = get_dist(U, T)
			if(!istype(U, /turf/base))
				spawn(round(dist / 2)) Explode(U, power, range, attacker, dist, source)
			else if(istype(U, /turf/base/bin) && !(attacker && attacker.team == U.team))
				U:Dump()

/mob/player/proc/Attack(atom/movable/M as mob|obj)
	if(world.time >= act_delay && get_dist(src, M) <= size)
		var/lethal = 0.25
		var/pierce = 0.25
		var/delay = 9 - round(dexterity / 6) - round(attack / 6)
		var/water = 0
		var/source = "unarmed"
		var/dmg = round(rand(attack / 2 + strength / 10, attack + strength / 5))
		if(istype(loc, /turf/water))
			water = 1
		if(water && !istype(GetTurf(M), /turf/water) || !water && istype(GetTurf(M), /turf/water))
			return
		if(locate("held") in equipment)
			var/E = equipment["held"]
			if("attack" in E:adds)
				lethal = 0.45
				pierce = 0.45
		dir = get_dir(src, M)
		if(size > 1)
			source = "crush"
		if(dmg > size * 2 + 15)
			if(attack != CalcStat("attack") || strength != CalcStat("strength"))
				dmg = 2
		M.TakeDamage(dmg, lethal, pierce, src, source)
		experience += attack + 15
		if(team.expBonus == "attack")
			experience += 10
		if(istype(M, /obj/item/useable/installation/energy_fence))
			TakeDamage(20, 0.4, 0.6, null, "fence")
		if(water)
			icon_state = "swimaction"
		else
			icon_state = "action"
		spawn(delay)
			if(water)
				icon_state = "swim"
			else
				icon_state = "run"
		act_delay = world.time + delay

/mob/player/proc/KillPenalty(atom/M as mob, source, KO=0)
	if(M.team == team)
		if(teamKills > 5)
			players << "[name] booted for teamkilling."
			spawn(1)
				del(client)
				return
		else
			if(KO)
				src << "Your reciever crackles with the angry voice of your mining foreman <i>\"Watch it, pal! Just be happy you didn't rough him up too bad, or else you could consider yerself fired. Got it?\"</i>"
				experience -= 500 - rank * 50 + teamKills * 500
				teamKills++
			else
				src << "Your reciever crackles with the angry voice of your mining foreman <i>\"YOU MORON! You complete and utter waste of oxygen, what the *#@! do ya think you're doin', huh? If you're gonna whack someone, howsabout takin' out the <b>other</b> guys?\"</i>"
				if(source == "explosion")
					experience -= 300
					teamKills += 0.4
				else
					experience -= 500 - rank * 50 + teamKills * 500
					teamKills++
	else
		if(get_dist(M, team.bin) <= 16)
			experience += attack * 2 + 100
			if(team.expBonus == "trespass")
				src << "Your reciever crackles with the voice of your foreman. <i>\"Excellent work there, soldier. We need to send a strong message that the IKMF is not to be trifled with--keep it up and you could earn yourself a promotion.\"</i>"
				experience += 100
			kills += 0.4
		else
			if(KO)
				experience += attack * 2
				kills += 0.4
			else
				if(team.expBonus == "kill")
					src << "Your reciever crackles with the voice of the mining foreman. <i>\"'ey, not bad work dere, but youse might wanna try bein' a bit more careful. People might start askin' questions.\"</i>"
					experience -= 100 - kills * 50
				else
					src << "Your reciever crackles with the angry voice of the mining foreman. <i>\"You klutz! Do you have any idea how much of a mess you're leaving down there? Roughing up a few of the udder guys is one thing, but lay off the killing, 'k?\"</i>"
					experience -= 200 - kills * 100
				kills++

/mob/player/TakeDamage()
	if(..())
		if(health / max_health < 0.5)
			for(var/obj/item/ore/O in src)
				for(var/i = 1, i <= O.quantity, i++)
					if(rand(0, 100) > (health / max_health) ** 0.5)
						O.Scatter(src, 1)

/mob/player/Die(mob/player/attacker as mob, source, lethality)
	var/KO
	var/delay
	var/obj/item/equippable/E
	KO = lethality * 100 < rand(1, 100)
	delay = lethality * 100 + 150
	delay += deaths * 3
	if(KO) delay *= 0.6
	if(client)
		spawn(round(delay))
			if(map && client) Respawn()
	else
		spawn(1) del(src)
	for(var/S in equipment)
		E = equipment[S]
		if(E) E.DoUnequip(src)
	equipment.Cut()
	for(var/obj/item/O in inventory)
		client.screen.Remove(O)
		O.Scatter(src)
	for(var/obj/item/O in client.screen)
		client.screen.Remove(O)
	inventory.Cut()
	if(!attacker)
		switch(source)
			if(null)
				players << "[name] dies!"
			if("vehicle")
				players << "[name] becomes roadkill!"
			if("radiation")
				players << "[name] dies of radiation exposure!"
			if("rail")
				players << "[name] gets zapped by an electrified rail!"
			if("water")
				players << "[name] drowns!"
	else
		if(attacker != src)
			if(source == "vehicle")
				players << "[name] was run over by [attacker.name]!"
			else if(source == "fence")
				players << "[name] was killed by a fence!"
			else if(findtext(source, "mine"))
				players << "[name] dies from a [source]!"
			else if(KO)
				players << "[name] was KOed by [attacker.name]!"
				attacker.KillPenalty(src, source, KO)
			else
				players << "[name] was killed by [attacker.name]!"
				attacker.KillPenalty(src, source, KO)
		else
			if(attacker == src)
				switch(source)
					if("explosion") players << "[name] blows [Him(src)]self up!"
					if("vehicle") players << "[name] crashes!"
					else players << "[name] commits suicide!"
			else
				players << "[name] dies!"
		experience -= rank * 10 + 100 - deaths * 100
		deaths++
	if(activeItem)
		if(istype(activeItem, /obj/item/useable))
			var/U = activeItem
			usr = src
			U:deselect()
		activeItem = null
		client.screen.Remove(activeItem)
	encumberance = 0
	HUDInventory()
	if(vehicle)
		vehicle.driver = null
		vehicle = null
	loc = null

/mob/player/verb/attack()
	set src in orange(1)
	var/mob/player/M
	M = usr
	src = GetMob(src)
	if(istype(M, /mob/player) && src != M)
		M.Attack(GetMob(src))

/obj/item/equippable/weapon/proc/Fire(T as turf, spin)
	var/mob/player/M
	var/turf/U
	M = usr
	U = GetTurf(loc)
	if(M.act_delay < world.time || spin)
		var/water
		if(T == GetTurf(src))
			return
		else if(istype(T, /turf/base) && istype(GetTurf(src), /turf/base))
			return
		else if(istype(GetTurf(src), /turf/water) && !M.vehicle && !U.Bridged())
			water = 1
			if(attackAnim != "pistol")
				usr << "You can't fire that from water!"
				return
		var/attackDelay
		if((ammo || !ammoType) && M.energy >= powerDrain)
			var/B = new bulletType(GetTurf(src))
			var/range = ((T:x - loc.x) ** 2 + (T:y - loc.y) ** 2) ** 0.5
			if(!spin) view(6) << "[M.name] fires [name]!"
			B:power = power
			B:power += M.aim / 3 + M.attack / 6
			B:power = rand(round(B:power / 2, 1), B:power)
			B:penetration = penetration
			B:lethality = lethality
			B:owner = usr
			B:icon = 'bullet.dmi'
			B:trail = trail
			B:GetHeading(range, GetTurf(src), T)
			usr.dir = B:dir
			B:heading += rand(min(0, M.aim * 1.5 + accuracy * 30 + -55), max(0, 55 - M.aim * 1.5 - accuracy * 30))
			if(water)
				flick("swimfire", M)
			else
				if(auto)
					var/O = M
					O:icon_state = attackAnim
					spawn(4) if(O) O:icon_state = "run"
				else
					flick(attackAnim, M)
			B:Fly()
			if(ammoType)
				ammo--
				UpdateQuantity()
			if(powerDrain)
				M.energy -= powerDrain
				M.HUDBar("energy")
			attackDelay = round((delay + delay * 1.5 / (M.dexterity / 10) + 1 - M.dexterity / 6) / 2, 1)
			if(auto) attackDelay = round((delay * 2 + attackDelay) / 3)
			if(M.dexterity != M.CalcStat("dexterity"))
				attackDelay = round(delay * 1.5)
			M.act_delay = world.time + attackDelay
		else if(ammoType)
			LoadAmmo()
			attackDelay = round((delay + delay * 1.5 / (M.dexterity / 10) + 1 - M.dexterity / 6) / 2, 1)
			M.act_delay = world.time + attackDelay

/obj/FX/New(NewLoc, Icon, Duration)
	. = ..(NewLoc)
	icon = Icon
	duration = Duration
	layer = 6
	Animate(1)

/obj/FX/proc/Animate(Frame)
	icon_state = num2text(Frame)
	if(Frame <= duration)
		spawn(1) Animate(Frame + 1)
	else
		del(src)

/obj/trail/New()
	spawn(2) flick(trail, src)
	spawn(5) del(src)

/obj/bullet/Bump(O as mob|obj|turf|area)
	var/mob/B
	var/turf/T
	B = O
	T = GetTurf(O)
	if(istype(GetTurf(O), /turf/water) && !T.Bridged() && rand(0, 2))
		loc = O:loc
		return
	if(!(O == owner || ismob(B) && B.master == owner))
		if(istype(O, /obj/bullet))
			loc = O:loc
		else
			if(ismob(O) || isobj(O))
				var/M = O
				var/P = O
				if(istype(O, /obj/item/vehicle))
					var/V = O
					if(V:driver && !rand(0, 2)) O = V:driver
				if(ismob(O))
					M = GetMob(P)
				else
					power /= 2
				if(hit != M)
					if(owner)
						owner.experience += round((owner.aim + owner.attack + power * 0.67) / 2)
					if(M:damageable && power && penetration)
						M:TakeDamage(power, penetration, lethality, owner, name)
					hit = M
			else if(istype(O, /turf/dirt))
				var/dmg = 1
				T = O
				dmg += round(rand(power / 2, power) * penetration / 10)
				T.solidness -= dmg
				T.damage += dmg
				if(T.solidness < 0)
					if(rand(1, abs(T.solidness) * penetration * 10) > 10)
						T.Dug()
			loc = GetTurf(O)
			Hit(O)
	else
		loc = GetTurf(O)

/obj/bullet/Bumped(O as mob|obj)
	Bump(O)
	Move(O, loc)

/obj/bullet/proc/Stop()
	del(src)

/obj/bullet/proc/GetHeading(range, start as mob|obj|turf|area, stop as mob|obj|turf|area)
	var/dirs
	dirs = list(4, 5, 1, 9, 8, 10, 2, 6, 4, 5, 1)
	heading = arccos(abs(stop:x - start:x) / range)
	if(stop:x < start:x)
		if(stop:y < start:y)
			heading += 180
		else
			heading = 180 - heading
	else if(stop:y < start:y)
		heading = 360 - heading
	dir = dirs[round((heading + 22.5) / 45) + 1]
	masterDir = dir
	usr.dir = dir
	return heading

/obj/bullet/proc/Fly()
	var/X
	var/Y
	X = x * 32 + pixel_x + 16
	Y = y * 32 + pixel_y + 16
	X += cos(heading) * 30
	Y += sin(heading) * 30
	Move(locate(round(X / 32), round(Y / 32), z))
	dir = masterDir
	pixel_x = X % 32 - 16
	pixel_y = Y % 32 - 16
	range++
	if(range < 10)
		spawn(delay) Fly()
	else
		Stop()
	if(trail && density && 0)
		var/obj/trail/O = new(loc)
		O.overlays.Cut()
		O.trail = trail
		O.pixel_x = pixel_x
		O.pixel_y = pixel_y
		O.dir = dir

/obj/bullet/proc/Hit(A as mob|obj|turf|area)
	icon = 'bullet_hit.dmi'
	spawn(1) flick(icon_state, src)
	density = 0
	delay = max(1, delay)
	spawn(delay * 3 + 1) del(src)
	delay *= 2

/obj/bullet/rocket/grenade/Bump(O as mob|obj|turf|area)
	if(O:icon_state != "swim")
		density = 1
		if(!loc.density)
			loc = GetTurf(O)
		heading += rand(-75, 75) + 180

/obj/bullet/rocket/Hit(A as mob|obj|turf|area)
	Explosion(GetTurf(A), power, 2, owner)
	..()

/obj/bullet/rocket/Stop()
	Hit(loc)

/obj/bullet/beam/sonic/Hit(A as mob|obj|turf|area)
	if(istype(A, /turf/base))
		. = ..()

/obj/bullet/beam/rad/Hit(mob/player/M as mob)
	if(ismob(M))
		M = GetMob(M)
	if(istype(M, /mob/player) && !("rad suit" in M.equipment))
		M.radiation += rand(50, 200)
		M.radiation = min(M.radiation, M.max_radiation)
		M.HUDBar("radiation")
	else
		return ..()

/atom/movable/proc/TakeDamage(Amount, Piercing, Lethality, atom/Attacker as mob, Source)
	var/physDefense
	var/forceDefense
	var/mob/player/M
	var/dmg
	physDefense = defense - energy_defense
	forceDefense = energy_defense
	M = src
	if(!damageable || health <= 0)
		return
	if(istype(M, /mob/player) && M.CalcStat("defense") != M.defense)
		physDefense = 1
		forceDefense = 1
	else
		if(physDefense > 10)
			physDefense = 2 ** (physDefense / 4 - 2.5)
		else
			physDefense = 2 ** (1 - 10 / physDefense)
		forceDefense = 2 ** (energy_defense / 4)
	if(energy && energy_defense && forceDefense > 1)
		Amount /= forceDefense
		energy -= round(Amount * forceDefense - Amount) / 5
		if(ismob(src))
			M.HUDBar("energy")
	dmg = Amount * Piercing
	dmg += Amount * (1 - Piercing) / physDefense
	if(ismob(src))
		dmg /= 2
		dmg += (dmg - (1 - Lethality) * (1 - health / max_health)) * 0.5
	else
		if(Source == "bullet" || Source == "unarmed" || Source == "laser")
			dmg /= 2
	if(Attacker && Attacker.team == team)
		dmg /= 1.5
	dmg = round(dmg, 1)
	health -= dmg
	if(ismob(src) && dmg)
		M = src
		M.HUDBar("health")
	range(5, src) << "\The [name] takes [dmg] damage!"
	if(health <= 0)
		Die(Attacker, Source, Lethality)
		. = 0
	else
		. = dmg

/atom/movable/proc/Die(attacker as mob, Source)
	range(5, src) << "\The [name] is destroyed!"
	for(var/obj/O in src)
		O.loc = GetTurf(O)
	loc = null
	del(src)
