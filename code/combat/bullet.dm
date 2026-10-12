/obj/bullet
	icon_state = "bullet"
	density = 1
	animate_movement = 0
	var/power
	var/penetration
	var/lethality
	var/mob/player/owner
	var/target
	var/trail
	var/heading
	var/range = 0
	var/delay = 1
	var/masterDir
	var/hit

/obj/bullet/beam
	icon_state = null
	delay = 0

/obj/bullet/rocket
	icon_state = "rocket"

/obj/bullet/slag
	icon_state = "slag"

/obj/bullet/beam/rad

/obj/bullet/beam/sonic

/obj/bullet/rocket/grenade
	icon = 'bullet.dmi'
	icon_state = "grenade"

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
	if(!range)
		// Target on the shooter's own tile: go the way the shooter faces.
		heading = (max(dirs:Find(usr.dir), 1) - 1) * 45
	else
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
