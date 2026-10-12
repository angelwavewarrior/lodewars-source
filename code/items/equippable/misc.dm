/obj/item/equippable/misc
	icon = 'equipment.dmi'

/obj/item/equippable/misc/backpack
	desc = "A simple canvas bag for carrying extra ore or equipment. Backpacks allow the wearer to carry up to 2 extra units of weight."
	icon_state = "backpack"
	weight = 0.5
	value = 100
	adds = list("carry" = 2.5)
	slots = list("back")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/belt_pack
	desc = "Little more than a series of belt-mounted pouches, the belt pack is nevertheless ideal for carrying a few extra odds and ends. The belt pack can store one and a half units of extra items."
	icon_state = "belt pack"
	weight = 0.5
	value = 125
	adds = list("carry" = 2)
	slots = list("waist")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/bolo_pack
	desc = "A large piece of gear slung over a bolo's broad back, this simple but useful piece of equipment consists of a set of packs worn to either side."
	icon_state = "bolo pack"
	weight = 1
	value = 800
	adds = list("carry" = 4)
	slots = list("back")
	bannedRaces = list(/mob/player/zentan, /mob/player/mobbel, /mob/player/scradax, /mob/player/horzek, /mob/player/jezzer)

/obj/item/equippable/misc/cerebral_booster
	name = "cerebro helmet"
	desc = "A highly experimental device, the cerebral booster is capable of picking up, processing, and sending brainwaves to interface with a sentient mind, in effect acting as an expansion to one's mental capacities. While thought to have limited application, test runs have shown that the cerebral booster can greatly increase performance with highly delicate equipment handling."
	icon_state = "cerebro helmet"
	weight = 0.5
	value = 9000
	adds = list("defense" = 1, "intelligence" = 4)
	slots = list("head")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/disruptor_pick
	desc = "A highly experimental tool, the disruptor pick is equipped with a small device on the axe head capable of generating minor gravitational pulses capable of greatly disturbing dirt and even solid rock formations with minimal damage to the pick itself (or, thankfully, the miner swinging it!) The disruptor pick is rumored to be just as damaging against live specimens as well, although it's not recommended you try to find out."
	icon_state = "disruptor pick"
	weight = 2
	value = 6500
	adds = list("digging" = 6, "attack" = 5)
	slots = list("held")

/obj/item/equippable/misc/energy_cycler
	desc = "A useful gadget, the energy cycler is capable of absorbing excess energy from the surroundings and storing it as useable electrical power, replenishing your battery reserves. The energy cycler is even capable of generating power from environmental radiation, although it's not very healthy to try. The lightweight energy cycler can be carried just about anywhere and doesn't use up any equipment spaces."
	icon_state = "energy cycler"
	weight = 0.5
	value = 2000
	slots = list("cycler")

/obj/item/equippable/misc/hoverpack
	desc = "A high-tech backpack mounted with a small hover motor, hover packs don't provide enough lift to allow flight (not that flying in narrow, low-ceilinged mine tunnels is recommended!) but can easily support its own weight even when full. Hover packs hold up to 4 weight units with practically no burden on the wearer."
	icon_state = "hover pack"
	weight = 0.5
	value = 5500
	adds = list("carry" = 4.5)
	slots = list("back")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/hyper_belt
	desc = "The hyper belt is a simple but effective gadget worn at the waist that uses mild electrical stimulation and adrenal-booster drugs to increase general physical performance, particularly speed. Unfortunately, the hyper belt has been shown to have some mild side effects associated with it, making users jittery and decreasing coordination."
	icon_state = "hyper belt"
	weight = 1
	value = 3500
	adds = list("speed" = 2, "strength" = 1, "carry" = 1, "digging" = 1, "attack" = 1, "defense" = 1, "dexterity" = -1, "intelligence" = -1, "aim" = -1)
	slots = list("waist")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/nanofiber_gloves
	desc = "Woven of microscopic fibers capable of reacting to nerve impulses, nanofiber gloves act as highly dextrous, sensitive prosthetic hands capable of fine manipulation to a degree few could hope to match with their bare fingers."
	icon_state = "nanofiber gloves"
	weight = 0.5
	value = 7000
	adds = list("dexterity" = 3, "defense" = 1)
	slots = list("hands")

/obj/item/equippable/misc/power_belt
	desc = "A small electrical storage battery worn at the hip, the power belt increases the total energy reserves your equipment has to draw on."
	icon_state = "power belt"
	weight = 0.5
	value = 1000
	adds = list("max_energy" = 10)
	slots = list("waist")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/power_bracers
	desc = "A very useful piece of equipment for many manual laborers, power bracers use a combination of muscle stimulation, contact stimulants, and very low-level force manipulation to increase the force applied by the wearer, in effect making them stronger."
	icon_state = "power bracers"
	weight = 0.5
	value = 4000
	adds = list("strength" = 2, "attack" = 1, "defense" = 1, "carry" = 2)
	slots = list("hands")

/obj/item/equippable/misc/power_pack
	desc = "A larger, more powerful battery than that found in the power belt, the power pack can store almost half again as much juice as your standard-issue battery units and is highly recommended for any miner that plans on using any energy-intensive tools (or weapons!)"
	icon_state = "power pack"
	weight = 1
	value = 2500
	adds = list("max_energy" = 30)
	slots = list("back")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/scuba_gear
	desc = "Although miners are unlikely to encounter any lakes of real depth in their digging, it's very difficult for a heavily burdened miner to stay afloat. This set of scuba gear contains a pair of air tanks with as much capacity as one miner could possibly need and an adjustable mouth piece capable of use by anyone. Unfortunately, the air tanks will not fit over other items worn on the back."
	icon_state = "scuba equipment"
	weight = 1
	value = 450
	adds = list("swim" = -4)
	slots = list("back")
	bannedRaces = list(/mob/player/bolo)

/obj/item/equippable/misc/sonic_shovel
	desc = "A common, effective tool, sonic shovels emit infrasonic pulses on contact in order to loosen dirt and make digging easier, and the added weight from the sonic equipment make them decent swinging weapons in a pinch."
	icon_state = "sonic shovel"
	weight = 1.5
	value = 3500
	adds = list("digging" = 4, "attack" = 3)
	slots = list("held")

/obj/item/equippable/misc/spade
	name = "digger spade"
	desc = "A simple digging tool, the shorthandled digger's spade is fairly good at breaking up tough dirt but on the whole isn't capable of moving dirt very quickly."
	icon_state = "digger spade"
	weight = 1
	value = 150
	adds = list("digging" = 2, "attack" = 2)
	slots = list("held")

/obj/item/equippable/misc/speed_boosters
	desc = "Designed along similar principles as the power bracers, speed boosters magnify the amount of force the wearer's legs are capable of applying, allowing them to run faster with less effort."
	icon_state = "speed boosters"
	weight = 1
	value = 4500
	adds = list("speed" = 3)
	slots = list("legs")
	bannedRaces = list(/mob/player/jezzer)
	bannedRaces = list(/mob/player/jezzer)
