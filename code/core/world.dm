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
	return M

// A planted installation of that type on T. locate() can return an unplanted one lying there.
/proc/LocatePlanted(T, type)
	for(var/obj/item/I in T)
		if(istype(I, type) && I.planted)
			return I

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
