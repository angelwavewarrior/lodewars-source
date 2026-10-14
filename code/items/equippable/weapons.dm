/obj/item/equippable/weapon
	icon = 'weapons.dmi'
	var/bulletType = /obj/bullet
	var/power = 5
	var/penetration = 0.25
	var/lethality = 0.5
	var/delay
	var/ammoType
	var/trail
	var/auto = 0
	var/accuracy = 0.8
	slots = list("held")
	attackAnim = "pistol"

/obj/item/equippable/weapon/assault_rifle
	name = "Jevco SA-7 assault rifle"
	desc = "The SA-7 assault rifle is a larger, more powerful weapon using the same principles as mag pistols, applied with both a longer magnetic propulsion path for greater accuracy and firing velocity and a faster rate of fire. Although difficult for most civilian outfits to acquire, the SA-7 is not a fully automatic weapon and thus is not technically illegal."
	icon_state = "assault rifle"
	weight = 1
	value = 7500
	power = 11
	penetration = 0.6
	lethality = 0.8
	attackAnim = "rifle"
	ammoType = /obj/item/ammo/mag
	delay = 4
	ammo = 30
	accuracy = 0.92

/obj/item/equippable/weapon/azzik
	name = "Azzik 58R"
	desc = "Although powder weapons are thought of as obsolete by many, on the rough frontiers of space such \"antique\" weapons proliferate rapidly. The Azzik 58R is a dubious weapon in many respects, but packs quite a lot of stopping power at a low price."
	icon_state = "58R"
	weight = 0.5
	value = 700
	power = 10
	penetration = 0.4
	lethality = 0.7
	ammoType = /obj/item/ammo/five_eight
	delay = 6
	ammo = 12
	attackAnim = "pistol"
	accuracy = 0.75

/obj/item/equippable/weapon/gelpistol
	name = "LI-89 gelpistol"
	desc = "A common civilian-grade weapon, the LI-89 fires packets of foaming impact gel at relatively low velocities, making for a highly nonlethal weapon that excels at subduing enemies without inflicting permanent injury, but is woefully underpowered in any sort of serious fighting; having little penetration power against bare skin, gel rounds are all but useless against armor."
	icon_state = "gelpistol"
	weight = 0.5
	value = 750
	power = 9
	penetration = 0.2
	lethality = 0.2
	ammoType = /obj/item/ammo/gel
	delay = 6
	ammo = 30
	accuracy = 0.75
	attackAnim = "pistol"

/obj/item/equippable/weapon/laser_pistol
	name = "Z8 laser pistol"
	desc = "Although laser weapons have been in use for centuries, they remain of limited application--although weapons such as the Z8 are compatible with a wide variety of power sources and need no physical ammo, their energy drain is considerable even for small arms. Nevertheless the Z8 is an excellent, if limited weapon; lasers can punch through conventional armor much more easily than bullets, and do so without using excessively lethal force."
	icon_state = "laser pistol"
	weight = 0.5
	value = 2500
	power = 8
	penetration = 0.8
	lethality = 0.5
	ammoType = null
	powerDrain = 2
	trail = "laser"
	bulletType = /obj/bullet/beam
	delay = 6
	attackAnim = "pistol"
	accuracy = 0.96

/obj/item/equippable/weapon/magpistol
	name = "Jevco EP-950 magnetic pistol"
	desc = "Using magnetic fields to guide and propel its shots, the EP-950 mag pistol is a sophisticated sidearm, possessing greater power and accuracy than old-fashioned powder weapons with less noise and kickback. Mag pistols are legal throughout large portions of civilized space and cheap enough to be readily accessible, and are in general solidly dependable firearms."
	icon_state = "mag pistol"
	weight = 0.5
	value = 2250
	power = 12
	penetration = 0.6
	lethality = 0.8
	ammoType = /obj/item/ammo/mag
	delay = 6
	ammo = 30
	attackAnim = "pistol"
	accuracy = 0.83

/obj/item/equippable/weapon/plasma_rifle
	name = "W7 plasma rifle"
	desc = "One of the most horrifyingly powerful personal weapons ever concieved, plasma rifles fire a stream of hyperactive gases heated to many thousand degrees Celsius. As one might imagine, this makes for an incredibly powerful weapon; fortunately for anyone caught on the recieving end of one of these, the technology is not quite perfected, and the only portable, personal plasma weapons available have an energy drain almost as appalling as their incredible lethality."
	icon_state = "plasma rifle"
	weight = 1.5
	value = 12500
	power = 40
	penetration = 0.9
	lethality = 1
	attackAnim = "rifle"
	trail = "plasma"
	bulletType = /obj/bullet/beam
	ammoType = null
	powerDrain = 6
	delay = 7
	accuracy = 0.99

/obj/item/equippable/weapon/rad_rifle
	name = "BEM5 rad rifle"
	desc = "Perhaps the most insiduous weapon ever devised, the rad rifle is banned in the most stringent regulations for any all uses, including a general military-use ban enforced vigilantly and with extreme prejudice by the known galaxy's largest armed powers. The BEM5 fires a concentrated burst of radiation, capable of inflicting painful but not particularly lethal radiation burns; far more insiduous, however, is the high lethality of the dose of radiation anyone unprotected caught in the beam of a rad rifle picks up."
	icon_state = "rad rifle"
	weight = 1
	value = 12000
	power = 8
	penetration = 0.7
	lethality = 0.6
	bulletType = /obj/bullet/beam
	trail = "rad"
	delay = 7
	attackAnim = "rifle"
	ammoType = null
	powerDrain = 5
	accuracy = 0.9

/obj/item/equippable/weapon/riot_cannon
	name = "LI-170P riot cannon"
	desc = "A weapon designed to saturate crowds with as much subduing force as possible with a minimum of actual casualties, the LI-170P fires standard gel rounds but at a much faster velocity and very, <i>very</i> much faster rate of fire than a standard-issue gelpistol. They're also considerably less standard-issue--the LI-170P is limited issue even for state-run police and security forces, and all but impossible for civilian outfits to acquire... legally."
	icon_state = "riot cannon"
	weight = 2
	value = 8000
	power = 3
	penetration = 0.3
	lethality = 0.4
	ammoType = /obj/item/ammo/gel
	attackAnim = "chaingun"
	auto = 1
	delay = 7
	ammo = 30
	accuracy = 0.3

/obj/item/equippable/weapon/rocket_launcher
	name = "G-553 rocket launcher"
	desc = "A simple yet powerful weapon, the G-553 amounts to little more than a metal tube with a few fancy gizmos attached, but is not a weapon to be underestimated by any means. Although the rockets it fires are bulky and heavy, they have one hell of a kick to them, making the rocket launcher a weapon of choice for long-range demolition."
	icon_state = "rocket launcher"
	weight = 2
	value = 10500
	power = 45
	penetration = 0
	lethality = 0
	attackAnim = "cannon"
	bulletType = /obj/bullet/rocket
	trail = "rocket"
	ammoType = /obj/item/ammo/rocket
	delay = 15
	accuracy = 0.85

/obj/item/equippable/weapon/slag_rifle
	name = "SO83 slag rifle"
	desc = "A very thoroughly military-grade weapon, the SO83 is highly illegal and thus highly rare outside of official armed forces, although it remains a favorite for black market weapons deals. Although not an indispensible battlefield weapon, the powerful, semimolten round that slag rifles fire has a truly horrific effect for such comparatively low caliber weapons: the slag rifle is an excellent light anti-armor weapon, being small enough for one man to handle with ease and powerful enough to punch through anything that's on two legs."
	icon_state = "slag rifle"
	weight = 1
	value = 7000
	power = 20
	penetration = 0.8
	lethality = 0.9
	attackAnim = "rifle"
	bulletType = /obj/bullet/slag
	ammoType = /obj/item/ammo/slag
	delay = 7
	ammo = 20
	accuracy = 0.9

/obj/item/equippable/weapon/sonic_disruptor
	name = "U6-AP sonic disruptor"
	desc = "The U6-AP sonic disruptor is a fairly new weapon, barely out of the experimental stage, but results are nonetheless promising. Applying concentrated bursts of wide-frequency tones, the U6-AP is capable of greatly warping and distorting armor or hard biomass, causing minimal harm to soft tissue but wreaking considerable structural damage against solid targets. Its relatively slow firing rate and considerable power drain are both lamentable drawbacks, but the disruptor rifle is one of the few weapons in common use capable of taking out armored targets with nonlethal force."
	icon_state = "disruptor rifle"
	weight = 1
	value = 5500
	power = 11
	penetration = 1
	lethality = 0.4
	attackAnim = "rifle"
	bulletType = /obj/bullet/beam/sonic
	ammoType = null
	powerDrain = 2
	delay = 7
	attackAnim = "rifle"
	accuracy = 0.88

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
		else if(istype(GetTurf(src), /turf/water) && !M.vehicle && !U.Bridged() && !istype(M, /mob/player/bolo))
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

/obj/item/equippable/weapon/riot_cannon/Fire(A as mob|obj|turf|area, spin=0)
	var/mob/player/P
	P = usr
	if(P.act_delay <= world.time || P.icon_state == attackAnim || spin)
		if(spin > 2)
			if(world.cpu < 60)
				. = ..(A, spin)
			else if(spin % 2)
				power = 7
				. = ..(A, spin)
				power = 3
		if(spin < rand(5, 6))
			spawn(1) if(src && usr) Fire(A, spin + 1)

/obj/item/equippable/weapon/proc/LoadAmmo()
	var/obj/item/ammo/O
	var/mob/player/M
	O = locate(ammoType) in usr
	M = usr
	if(O && !ammo)
		ammo += min(O.amt, O.quantity)
		if(O.quantity <= O.amt)
			M.inventory.Remove(O)
			M.client.screen.Remove(O)
			M.encumberance -= O.CalcWeight(1)
			O.loc = null
			del(O)
		else
			O.TakeBuyerCounts(O.amt)
			O.quantity -= O.amt
			O.UpdateQuantity()
		UpdateQuantity()
		M.HUDInventory()

/obj/item/equippable/weapon/CalcWeight(Q=ammo)
	if(src && ammoType)
		var/A = new ammoType
		var/w = weight + round(ammo / A:amt) * 0.5
		del(A)
		return w
	else
		return weight

/obj/item/equippable/weapon/verb/load()
	set src in usr.client.screen
	if(ammoType)
		LoadAmmo()
	else
		usr << "Energy weapons need no ammo!"

/obj/item/equippable/weapon/verb/unload()
	set src in usr.client.screen
	if(ammo && ammoType)
		var/O = new ammoType(usr.loc)
		O:quantity = ammo
		ammo = 0
		UpdateQuantity()
		O:Move(usr)
		if(O) O:UpdateQuantity()
