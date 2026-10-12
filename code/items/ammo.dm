/obj/item/ammo
	icon = 'ammo.dmi'
	var/amt
	stackable = 1

/obj/item/ammo/five_eight
	name = "58 standard"
	desc = "A 12-round clip designed for use with old-fashioned 58 caliber powder guns."
	icon_state = "58 standard"
	amt = 12
	value = 25

/obj/item/ammo/gel
	name = "gel cartridge"
	desc = "30-round gel cartridge magazines are loaded with the condensed riot foam for gel weapons such as the LI-89 and LI-170P."
	icon_state = "gel cartridge"
	amt = 30
	value = 30

/obj/item/ammo/mag
	name = "mag clip"
	desc = "A 30-round magazine loaded with specially treated semiferrous magnetic rounds for magpistols and mag rifles."
	icon_state = "mag clip"
	amt = 30
	value = 120

/obj/item/ammo/rocket
	desc = "A standard-issue charge compatible with most rocket launchers."
	icon_state = "rocket"
	amt = 1
	value = 45

/obj/item/ammo/slag
	name = "slag rounds"
	desc = "An insulated 20-round magazine of melting rounds, for use with the SO83 slag rifle."
	icon_state = "slag rounds"
	amt = 20
	value = 250

/obj/item/ammo/CalcWeight(Q=quantity)
	if(round(Q / amt) != Q / amt)
		return (round(Q / amt) + 1) * 0.5
	else
		return round(Q / amt) * 0.5

/obj/item/ammo/New()
	. = ..()
	quantity = amt
