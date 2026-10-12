/world/New()
	LoadFilter()
	LoadAdmins()
	LoadMOTD()
	LoadBanned()
	InitMasterHUD()
	InitializeShop()
	spawn(15) GenerateMap()
	return ..()

/proc/GetTurf(O as mob|obj|turf|area)
	if(O && !isturf(O))
		return GetTurf(O:loc)
	else
		return O

/proc/GetMob(mob/M as mob)
	. = M
	if(istype(M, /mob) && M.master)
		. = M.master

/*/proc/IsHead(mob/M as mob)
	. = null
	if(istype(M, /mob) && M.master && M.master.head == M)
		. = M.master
	else if(!istype(M, /mob) || !M.master && !M.head)
		. = M

/proc/HeadForMob(mob/M as mob)
	if(ismob(M) && M.head)
		. = M.head
	else
		. = M*/

/proc/Him(mob/M as mob)
	if(M.client.gender == "female")
		return "her"
	else
		return "him"

/proc/His(mob/M as mob)
	if(M.client.gender == "female")
		return "her"
	else
		return "his"

/proc/Proper(text)
	if(length(text) > 1)
		return uppertext(copytext(text, 1, 2)) + copytext(text, 2, 0)
	else
		return uppertext(text)

/proc/CanReach(Source as mob|obj|turf|area, Target as mob|obj|turf|area)
	var/obj/O
	O = new(GetTurf(Source))
	O.density = 1
	O.Move(GetTurf(Target))
	if(O.loc == GetTurf(Target))
		. = 1
	else
		. = 0
	del(O)

/proc/GetMultiDist(mob/A as mob, B as mob|obj|turf|area)
	var/minDist
	minDist = get_dist(A, B)
	for(var/mob/C in A.children)
		minDist = min(minDist, get_dist(C, B))
	return minDist
