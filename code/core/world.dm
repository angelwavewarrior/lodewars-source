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

// get_dist, range() and orange() measure a bolo from its bottom-left tile. These use its whole footprint.

// The thing on the map that holds A: A itself, or the mob or vehicle carrying it.
/proc/MapHolder(atom/A)
	while(A && !isturf(A) && A.loc && !isturf(A.loc))
		A = A.loc
	return A

// Tiles between two footprints, as get_dist counts them: 0 overlapping, 1 adjacent.
/proc/TileDist(atom/A, atom/B)
	A = MapHolder(A)
	B = MapHolder(B)
	if(!A || !B || !A.z || A.z != B.z)
		return 1#INF
	var/aw = 1
	var/ah = 1
	var/bw = 1
	var/bh = 1
	if(istype(A, /atom/movable))
		aw = max(1, round(A:bound_width / world.icon_size))
		ah = max(1, round(A:bound_height / world.icon_size))
	if(istype(B, /atom/movable))
		bw = max(1, round(B:bound_width / world.icon_size))
		bh = max(1, round(B:bound_height / world.icon_size))
	var/dx = max(0, A.x - (B.x + bw - 1), B.x - (A.x + aw - 1))
	var/dy = max(0, A.y - (B.y + bh - 1), B.y - (A.y + ah - 1))
	return max(dx, dy)

// The tile of M's footprint nearest to T, where M's shots start.
/proc/NearestTile(atom/movable/M, atom/T)
	M = MapHolder(M)
	T = GetTurf(T)
	if(!M || !T || !istype(M, /atom/movable))
		return GetTurf(M)
	var/w = max(1, round(M.bound_width / world.icon_size))
	var/h = max(1, round(M.bound_height / world.icon_size))
	return locate(clamp(T.x, M.x, M.x + w - 1), clamp(T.y, M.y, M.y + h - 1), M.z)

// The tile just past M's footprint in direction D.
/proc/FrontTurf(atom/movable/M, D)
	var/tx = M.x
	var/ty = M.y
	if(D & EAST)
		tx = M.x + max(1, round(M.bound_width / world.icon_size))
	else if(D & WEST)
		tx = M.x - 1
	if(D & NORTH)
		ty = M.y + max(1, round(M.bound_height / world.icon_size))
	else if(D & SOUTH)
		ty = M.y - 1
	return locate(tx, ty, M.z)

// orange(R) around every tile M covers.
/proc/Around(atom/movable/M, R)
	. = list()
	for(var/turf/T in M.locs)
		. |= range(R, T)
	. -= M

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
