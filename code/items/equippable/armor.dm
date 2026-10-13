/obj/item/equippable/armor
	icon = 'armor.dmi'

/obj/item/equippable/armor/attack_helmet
	desc = "Standard-issue infantry gear, the attack helmet's visor is not only equipped with high-grade correctional optics but also an excellet heads-up targetting system capable of outperforming most rifle scopes for accuracy, boosting soldiers' aim while providing vital protection."
	icon_state = "attack helmet"
	weight = 0.5
	value = 5000
	adds = list("defense" = 2, "attack" = 1, "aim" = 2)
	slots = list("head")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/blast_jacket
	desc = "A long, heavy coat reinforced with shock-absorbent pads, blast jackets are moderately heavy and are ineffective against most firearms but can greatly reduce the damage suffered in explosions, and are standard gear for explosives-handling and demolition workers."
	icon_state = "blast jacket"
	weight = 1.5
	value = 1600
	adds = list("defense" = 2)
	slots = list("torso")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/bolo_plate
	desc = "This massive, bulky armor designed especially for the mammoth bolo is made of heavy, dense duro-steel alloys for maximum defense. Unfortunately, the sheer weight can slow down a bolo considerably."
	icon_state = "bolo plate"
	weight = 8
	value = 9000
	adds = list("defense" = 9, "speed" = -3)
	slots = list("torso", "legs")
	bannedRaces = list(/mob/player/zentan, /mob/player/mobbel, /mob/player/scradax, /mob/player/horzek, /mob/player/jezzer)

/obj/item/equippable/armor/combat_suit
	desc = "A shoulder-to-toe suit of high-performance combat gear, not only does the combat suit offer unmatched coverage and protection, it integrates both metabolic stimulators and computer-enhanced personal targeting systems to maximize combat performance."
	icon_state = "combat suit"
	weight = 3
	value = 9000
	adds = list("defense" = 9, "strength" = 1, "carry" = 1, "attack" = 2, "aim" = 1, "speed" = 1)
	slots = list("torso", "legs")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/durosteel_plate
	desc = "Duro-steel metal alloys, while heavy, are dense, sturdy, and strong, making for effective, if bulky, body armor. Duro-steel armor gives reasonably good protection against most forms of physical attack, but isn't particularly effective against energy weapons."
	icon_state = "durosteel plate"
	weight = 3.5
	value = 3500
	adds = list("defense" = 7, "speed" = -2, "dexterity" = -1)
	slots = list("torso")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/flex_jacket
	desc = "One of the most advanced forms of solid armor in common use, the flex jacket offers lightweight, powerful defense against most forms of attack. Though expensive to make, flex jackets are common infantry gear for many armies due to their combination of effective defense and freedom of movement."
	icon_state = "flex jacket"
	weight = 1.5
	value = 4000
	adds = list("defense" = 6)
	slots = list("torso")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/force_harness
	desc = "This heavy forcefield armor is designed to generate a forcefield to cover a bolo's entire massive frame. Producing such a large forcefield is rather inefficient and the defense provided by this item isn't quite what one might expect from such a heavy forcefield device, but is highly useful nonetheless."
	icon_state = "power harness"
	weight = 3.5
	value = 8000
	adds = list("defense" = 3, "energy_defense" = 3)
	slots = list("waist")
	bannedRaces = list(/mob/player/zentan, /mob/player/mobbel, /mob/player/scradax, /mob/player/horzek, /mob/player/jezzer)

/obj/item/equippable/armor/force_pack
	desc = "One of the heaviest personal forcefield generation devices available, the force pack offers complete coverage and enviable defensive strength for minimal energy drain."
	icon_state = "force pack"
	weight = 1.5
	value = 6500
	adds = list("defense" = 4, "energy_defense" = 4)
	slots = list("back")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/leg_guards
	desc = "Simple body armor for the lower limbs, leg guards provide effective protection without impeding movement."
	icon_state = "leg guards"
	weight = 0.5
	value = 500
	adds = list("defense" = 2)
	slots = list("legs")
	bannedRaces = list(/mob/player/jezzer, /mob/player/bolo)

/obj/item/equippable/armor/miner_cap
	name = "miner's cap"
	desc = "A simple but highly useful piece of equipment, a miner's cap doesn't provide much coverage, but the areas it protects are vital."
	icon_state = "miner's cap"
	weight = 0.5
	value = 350
	adds = list("defense" = 2)
	slots = list("head")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/nanomesh_armor
	desc = "A truly cutting-edge piece of armor, nanomesh technology allows for armor that doesn't just fit like a second skin--it fits like a <i>first</i> skin! Constructed of sensitive, reactive microscopic fibers, nanomesh armor is as heavy as any other combat gear but molds itself to the wearer's actions so well that they often move more smoothly in spite of the weight. Nanomesh armor is also mounted with a light personal forcefield generator to provide some protection against energy weapons, with a built-in power supply."
	icon_state = "nanomesh armor"
	weight = 2
	value = 10000
	adds = list("defense" = 6, "speed" = 1, "dexterity" = 1, "energy_defense" = 2, "max_energy" = 10)
	slots = list("torso")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/radiation_suit
	desc = "Heavy and bulky, radiation suits are designed to fit easily over other clothes or armor. Although clumsy and awkward to wear, radiation suits are one of the most reliable ways to shield oneself from harmful radiation."
	icon_state = "rad suit"
	weight = 1.5
	value = 1050
	adds = list("defense" = 1, "speed" = -2, "dexterity" = -2, "attack" = -1, "aim" = -1)
	slots = list("rad suit")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/shield_belt
	desc = "A small, belt-mounted forcefield generator capable of absorbing some of the impact from both ballistic and energy weapons. Forcefields do drain small amounts of power when stressed, unfortunately."
	icon_state = "shield belt"
	weight = 1
	value = 3500
	adds = list("defense" = 2, "energy_defense" = 2)
	slots = list("waist")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/armor/vest
	name = "impact vest"
	desc = "Made of finely woven armor material strengthened by small plates of duro-steel, impact vests are standard issue gear for police and low-level security officers. Impact vests provide effective defense against blunt, pounding attacks, but can't handle powerful piercing attacks or energy weapons well."
	icon_state = "impact vest"
	weight = 1
	value = 600
	adds = list("defense" = 3)
	slots = list("torso")
	bannedRaces = list(/mob/player/bolo)
