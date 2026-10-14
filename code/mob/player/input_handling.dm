// On every mob, since the skin's Any macro sends these from any mob; only players act on them.
// On players alone, an observer's every key press gave "unrecognized verb".
/mob/var/tmp/keys_pressed

/mob/verb/KeyDown(button as text)
	set hidden = 1
	set instant = 1
	keys_pressed ||= list()
	keys_pressed[button] = 1

/mob/verb/KeyUp(button as text)
	set hidden = 1
	set instant = 1
	if(!keys_pressed) return
	keys_pressed -= button

/mob/player/Tick()
	if(keys_pressed)
		var/movement_step = 0
		if(keys_pressed["North"] || keys_pressed["W"]) movement_step |= NORTH
		if(keys_pressed["South"] || keys_pressed["S"]) movement_step |= SOUTH
		if(keys_pressed["East"] || keys_pressed["D"]) movement_step |= EAST
		if(keys_pressed["West"] || keys_pressed["A"]) movement_step |= WEST
		if(keys_pressed["Northwest"]) movement_step |= NORTHWEST
		if(keys_pressed["Northeast"]) movement_step |= NORTHEAST
		if(keys_pressed["Southeast"]) movement_step |= SOUTHEAST
		if(keys_pressed["Southwest"]) movement_step |= SOUTHWEST
		if((movement_step & (NORTH | SOUTH)) == (NORTH | SOUTH)) movement_step &= ~(NORTH | SOUTH)
		if((movement_step & (EAST | WEST)) == (EAST | WEST)) movement_step &= ~(EAST | WEST)
		if(movement_step && act_delay < world.time)
			HandleMovement(movement_step)
