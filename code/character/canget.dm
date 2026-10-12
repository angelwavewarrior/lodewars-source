/mob/player/proc/CanGet(obj/item)
	if(item.loc == src.loc) return TRUE
	if(istype(item.loc,/turf/dirt))
		if(item.loc.density) return FALSE
	var/dist_check = 1
	var/dist = get_dist(src,item)
	if(dist <= dist_check) return TRUE
	var/min_dist = dist
	for(var/turf/on in locs)
		var/on_dist = get_dist(on,item)
		if(on_dist < min_dist) min_dist = on_dist
	if(min_dist <= dist_check) return TRUE
	return FALSE