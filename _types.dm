/area
/atom
	var/radioactivity = 0
	var/team/team
	var/signal
	var/energy
	var/max_energy
/client
	var/mute = 0
	var/invSlot = 1
/crypto
	var/list/data = new/list(0)
/datum
	var/name
/map
	var/bgRadiation = 0
	var/obj/timer/timer
	var/max
	var/mainOre
	var/list/waterGrid = new/list(260, 260)
	var/waterContent = "random"
	var/size = "random"
	var/list/teams
	var/cash = 0
	var/rank = 0
	var/saved = 1
/mob
	var/shopping = 0
	var/mob/master
	var/atom/movable/head
	var/baseIcon
	var/list/children
	var/xOffset
	var/yOffset
	var/chat_time
	var/switching
	var/obj/item/vehicle/vehicle
	var/showScores
	var/HUDMode = 0
	var/oldHUDMode = 0
	var/insurance
	var/recovered
	var/mode = "default"
/obj
	var/planted = 0
/team
	var/sizeMod = 1
	var/score = 0
	var/list/members = list()
	var/list/allMembers = list()
	var/bannedItems
	var/list/weaponList = list()
	var/list/armorList = list()
	var/list/equipmentList = list()
	var/list/ammoList = list()
	var/list/installationList = list()
	var/list/itemList = list()
	var/list/vehicleList = list()
	var/list/totalShopList
	var/comm
	var/title
	var/title_offset
	var/list/selects = list()
	var/bin
	var/loadingZone
	var/sideZone
	var/obj/hud/score/scoreDisplay
	var/desc
	var/fontColor
	var/respawn
	var/expBonus
/turf
	var/solidness = 0
	var/damage = 0
/vein
	var/X
	var/Y
	var/num
	var/ore
	var/richness
/atom/movable
	var/damageable = 0
	var/defense
	var/energy_defense
	var/health
	var/max_health
/crypto/rc5
	var/const/w = 16
	var/const/P = 47073
	var/const/Q = 40503
	var/r = 16
	var/b = 16
	var/c = 8
	var/t = 34
	var/list/S = new/list(0)
	var/lasta = 0
	var/lastb = 0
	var/uselast = 0
/mob/admin
/mob/host
/mob/observer
	var/atom/movable/char
	var/loggedIn
/mob/player
	var/list/HUD = list()
	var/strength
	var/speed
	var/dexterity
	var/intelligence
	var/aim
	var/attack
	var/digging
	var/experience = "unsaved"
	var/rank = 0
	var/swim = 0
	var/race
	var/size = 1
	var/radiation
	var/max_radiation = 1000
	var/radBlock
	var/regen
	var/carry
	var/encumberance
	var/cash = 1000
	var/bank
	var/debt = 0
	var/act_delay
	var/speed_accum
	var/attackAnim = "punch"
	var/digAnim = "dig"
	var/list/inventory = list()
	var/list/equipment = list()
	var/list/statOrder
	var/obj/item/useable/activeItem
	var/tutorial = 1
	var/deaths
	var/kills
	var/teamKills
	var/activity = 100
	var/playTime = 0
	var/save_time = 0
	var/list/shoppingCart = new/list()
	var/bill = 0
	var/shopList
	var/shopWeight
	damageable = 1
	max_energy = 30

/obj/FX
	var/duration
/obj/beam
	icon = 'barrier.dmi'
	var/owner
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
/obj/hud
/obj/item
	icon = 'testobj.dmi'
	var/weight
	var/quantity = 1
	var/value
	var/ammo
	var/stackable = 0
	var/powerDrain
	var/highlight
	var/obj/item/vehicle/container
	var/owner
	var/buyer
	var/useAnim
/obj/select
/obj/shop
	layer = 15.5
	var/itemType
	var/value
	var/weight
	var/obj/item/item
	var/obj/hud/highlight
/obj/timer
	icon = 'statnum.dmi'
	layer = 15
	var/time = 40
	var/start = 40
	screen_loc = "12:16,12:17"
/obj/trail
	icon = 'bullet_trail.dmi'
	var/trail
/team/black
	name = "black"
	sizeMod = 0.9
	fontColor = "#333333"
	title = "The Jagrinki"
	title_offset = -2
	desc = "The Jagrinki are a mafia group whose seedy tendrils extend into virtually every enterprise imaginable, from legitimate businesses to the most appalling racketeering operations imaginable. Although not as well-funded as the competition, their dirty underhanded tactics garner them a nice chunk of cash for their employees' paychecks. The Jagrinki naturally have little use for laws or regulations of any sort, and can supply its operatives with all sorts of highly illegal equipment. The Jagrinki's extensive mob network allows them to cover up the murders its workers commit with relative ease."
	bannedItems = list(/obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/force_harness, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/speed_boosters, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/hoverpack, /obj/item/equippable/misc/disruptor_pick, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/installation/beacon, /obj/item/useable/installation/microrefinery, /obj/item/useable/planted/shock_mine, /obj/item/equippable/weapon/plasma_rifle, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/portable_decontamination_unit, /obj/item/equippable/armor/combat_suit, /obj/item/vehicle/flathauler, /obj/item/useable/nonexpendable/teleport, /obj/item/vehicle/drill)
	expBonus = "kill"
/team/blue
	name = "blue"
	sizeMod = 1.1
	title = "Dailim Mining Inc."
	fontColor = "#0000FF"
	desc = "Dailim Mining Inc. is a relatively new mining venture funded largely from the personal vaults of fantastically wealthy multitrillionaire Gazno Dailim III. Dailim has poured untold billions into purchasing, developing, and--so rumor has it--ocassionally stealing the latest mining technology known to the galaxy to ensure that Dailim Mining is supplied with the industry's best, although the company's single-minded drive has caused other useful equipment to fall by the wayside. Dailim Mining is heavily focused on the bottom line and is known to give extra reward to miners who bring in large quantities of ore."
	bannedItems = list(/obj/item/equippable/weapon/azzik, /obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/sonic_disruptor, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/blast_jacket, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/cerebral_booster, /obj/item/useable/nonexpendable/com_scanner, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/planted/alarm, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/teleport)
	expBonus = "deposit"
/team/gold
	name = "gold"
	fontColor = "#CCCC00"
	title = "Omni-Corp Mining Division"
	title_offset = 2
	desc = "Omni-corp is a vast mega-corporation with subsidiaries in virtually every aspect of galactic industry. Like a giant space amoeba, Omni-corp has gradually absorbed competitor after competitor, giving them a galaxy-wide market presence. Its business strategy is largely like an amoeba, as well--Omni-corp draws on its vast subsidiaries to outfit its operations, giving them a tremendous variety of equipment available but regrettably lacking in any real specialization."
	bannedItems = list(/obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/sonic_disruptor, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/cerebral_booster, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/installation/microrefinery, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/teleport)
/team/green
	name = "green"
	sizeMod = 1.2
	title = "Pan-Galactic Eco Mining Cooperative"
	title_offset = -1
	fontColor = "#00CC00"
	desc = "The Pan-Galactic EMC is an ecologically aware cooperative with no particular national loyalties dedicated to responsible, world-friendly mining measures and peaceful noncompetitive practices. Or, as often derided by its competitors, they are space hippies. The EMC pioneers the use of many useful and environmentally sound technologies that are either unavailable to or unused by its competitors, but strict pro-environment policy prohibits the use of many more damaging or dangerous pieces of equipment. The EMC favors the use of honest, personal labor over high explosives or heavy digging tools and rewards miners who follow their lead."
	bannedItems = list(/obj/item/equippable/weapon/azzik, /obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/magpistol, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/speed_boosters, /obj/item/useable/nonexpendable/com_scanner, /obj/item/equippable/misc/power_pack, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/generator, /obj/item/useable/planted/shock_mine, /obj/item/useable/planted/alarm, /obj/item/useable/explosive/blast_pack, /obj/item/useable/installation/microrefinery, /obj/item/useable/nonexpendable/teleport)
	expBonus = "dig"
/team/orange
	name = "orange"
	sizeMod = 1.4
	fontColor = "#FF9900"
	title = "Tygeron Mineral Extraction Corporation"
	title_offset = -2
	desc = "The TME Corp is a long-standing but backwards mining cartel which has dominated interplanetary mining operations for centuries. Although huge and capable of employing a larger and better-paid workforce than competing companies, its entrenched position of power has lulled TME Corp into a false sense of security, and considering itself invincible it has refused to update the mining equipment it issues, rigidly insisting on using outdated technology while competitors embrace newer, more efficient equipment. The simple, brutish minds behind Tygeron corp encourage its workers to use heavy physical \"persuasion\" against competitors, although they do not condone actual murder."
	bannedItems = list(/obj/item/equippable/weapon/laser_pistol, /obj/item/equippable/weapon/sonic_disruptor, /obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/armor/shield_belt, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/force_harness, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/power_belt, /obj/item/equippable/misc/power_bracers, /obj/item/equippable/misc/hoverpack, /obj/item/equippable/misc/power_pack, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/speed_boosters, /obj/item/equippable/misc/hyper_belt, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/speed_boosters, /obj/item/useable/healing/bio_kit, /obj/item/useable/pill, /obj/item/useable/nonexpendable/com_scanner, /obj/item/equippable/misc/power_pack, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/generator, /obj/item/useable/planted/shock_mine, /obj/item/useable/planted/alarm, /obj/item/useable/explosive/micro_charge, /obj/item/useable/installation/microrefinery, /obj/item/useable/installation/med_station, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/installation/telepad, null, /obj/item/useable/installation/teleconsole, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/portable_decontamination_unit, /obj/item/useable/nonexpendable/teleport, /obj/item/vehicle/drill)
	expBonus = "attack"
/team/purple
	name = "purple"
	fontColor = "#CC00CC"
	title = "Mezerit Excavation Company"
	title_offset = 2
	desc = "The ME Company is a secretive organization representing the mining interests of Mezlak-4. The Mezers are an elusive, high-technology race who live in deep underground bunkers with as little contact with the rest of the galaxy as they can manage, funding a few small outside labor companies to supply the worlds of Mezlak with raw materials. Little is known of them, save that they have an unparalleled understanding of advanced matter transference technology. Mezerit focuses heavily on intelligence gathering activities and encourages its workers to scout out veins with as much vigor as possible."
	bannedItems = list(/obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/force_harness, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/armor/blast_jacket, /obj/item/equippable/armor/shield_belt, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/blast_jacket, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/force_pack, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/power_bracers, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/cerebral_booster, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/installation/microrefinery, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/vehicle/flathauler, /obj/item/vehicle/drill)
	expBonus = "find"
/team/red
	name = "red"
	sizeMod = 0.8
	title = "Imperial Kadazil Mining Federation"
	title_offset = 0
	desc = "The IKMF is a powerful state-controlled mining conglomerate run by the militaristic Kadazil Empire. As the materials extracted are used primarily to feed the powerful Kadazillian war machine, it is considered a subsidiary of the armed forces; indeed, the IKMF hires workers as much for their muscle and skill with firearms as it does their familiarity with mining practices, and from the equipment it issues one can hardly tell if it is equipping soldiers or miners. The IKMF is fiercely territorial and encourages its workers to defend its outposts with lethal force."
	fontColor = "#FF0000"
	bannedItems = list(/obj/item/equippable/armor/nanomesh_armor, /obj/item/equippable/misc/speed_boosters, /obj/item/equippable/misc/nanofiber_gloves, /obj/item/equippable/misc/cerebral_booster, /obj/item/equippable/misc/hoverpack, /obj/item/equippable/misc/sonic_shovel, /obj/item/equippable/misc/disruptor_pick, /obj/item/useable/nonexpendable/com_scanner, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/installation/beacon, /obj/item/useable/installation/microrefinery, /obj/item/equippable/weapon/rad_rifle, /obj/item/useable/nonexpendable/orefinder, /obj/item/equippable/misc/energy_cycler, /obj/item/useable/nonexpendable/portable_decontamination_unit, /obj/item/useable/nonexpendable/teleport, /obj/item/vehicle/drill)
	expBonus = "trespass"
/team/white
	name = "white"
	sizeMod = 0.7
	title = "Besseltech Enterprises"
	fontColor = "#CCCCCC"
	desc = "Besseltech Enterprises is a cutting-edge research institute which has recently begun pursuing a policy of active mining venture as a means to simultaneously supply its needs for exotic minerals as well as test out its hazardous environment equipment. Bessel maintains a small but well-funded mining force, equipped with state-of-the-art technology, but has only a small presence in the interplanetary field of mining and cannot compete on as many fronts as some of its competitors. Besseltech takes its experimental testing role seriously and rewards miners who make use of its extensive array of gadgets and high-tech equipment."
	bannedItems = list(/obj/item/equippable/weapon/slag_rifle, /obj/item/equippable/weapon/riot_cannon, /obj/item/equippable/weapon/rocket_launcher, /obj/item/equippable/weapon/rad_rifle, /obj/item/equippable/weapon/plasma_rifle, /obj/item/equippable/weapon/assault_rifle, /obj/item/equippable/armor/leg_guards, /obj/item/equippable/armor/attack_helmet, /obj/item/equippable/armor/durosteel_plate, /obj/item/equippable/armor/flex_jacket, /obj/item/equippable/armor/combat_suit, /obj/item/equippable/armor/bolo_plate, /obj/item/equippable/misc/disruptor_pick, /obj/item/equippable/misc/power_bracers, /obj/item/useable/explosive/grenade, /obj/item/useable/installation/rad_scrubber, /obj/item/useable/planted/shock_mine, /obj/item/useable/installation/microrefinery, /obj/item/vehicle/flathauler, /obj/item/vehicle/drill)
	expBonus = "use"
/turf/base
	icon = 'base.dmi'
/turf/characterSelect
	name = ""
	icon = 'select_background.dmi'
/turf/dirt
	icon = 'dirt.dmi'
	icon_state = "15"
	opacity = 1
	density = 1
/turf/rock
	icon = 'rock.dmi'
	icon_state = "15"
	opacity = 1
	density = 1
/turf/teamSelect
	name = ""
	icon = 'team_background.dmi'
/turf/water
	icon = 'water.dmi'
	icon_state = "deep"

/obj/bullet/beam
	icon_state = null
	delay = 0
/obj/bullet/rocket
	icon_state = "rocket"
/obj/bullet/slag
	icon_state = "slag"
/obj/hud/button
	icon = 'hudbuttons.dmi'
	layer = 15
/obj/hud/invArrow
	icon = 'invArrow.dmi'
	layer = 15
	var/cycleDir
/obj/hud/score
	var/color_
/obj/hud/shopButton
	icon = 'shopbuttons.dmi'
	layer = 15
/obj/item/ammo
	icon = 'ammo.dmi'
	var/amt
	stackable = 1
/obj/item/battery
/obj/item/equippable
	var/slots
	var/adds
	var/equipped = 0
	var/digAnim
	var/attackAnim
	var/bannedRaces
	stackable = 0
/obj/item/ore
	desc = "Collect ore and deposit it in your team's ore bin to score points."
	var/vein
	var/grade = 1
	var/oreName
	weight = 1
	stackable = 1
	invisibility = 1
/obj/item/useable
	icon = 'item.dmi'
	var/delay
	var/range = 1
	stackable = 1
/obj/item/vehicle
	density = 1
	var/mob/player/driver
	var/capacity
	var/list/carried = list()
	var/top = 0
	var/speed = 0
	var/maxSpeed = 0
	var/baseDelay = 11
	var/speedIncrement = 3
	var/debris = "debris"
	var/boardable = 1
	var/reverse = 0
	var/drive_time
	weight = 1
	damageable = 1
/obj/select/raceSelect
	icon = 'races.dmi'
	var/charType
/obj/select/teamSelect
/obj/shop/category
	icon = 'shop_menu.dmi'
/turf/base/banner
	icon = 'banner.dmi'
	icon_state = "red"
	density = 1
/turf/base/bin
	icon_state = "ore bin"
	density = 1
	var/list/ores = list()
/turf/base/computer
	icon_state = "computer"
	density = 1
/turf/base/door
	icon_state = "door"
	var/door
/turf/base/floor
	icon_state = "floor"
/turf/base/light
	icon_state = "lamp"
	density = 1
/turf/base/loadZone
	name = "loading zone"
	icon_state = "loadbottom"
	density = 1
/turf/base/shop_console
	icon_state = "console"
	density = 1
/turf/base/spawnArea
	icon_state = "floor"
/turf/base/tank1
	name = "atmospheric filter"
	icon_state = "tank1"
	density = 1
/turf/base/tank2
	name = "atmospheric filter"
	icon_state = "tank2"
	density = 1
/turf/base/wall
	icon_state = "wall"
	opacity = 1
	density = 1
/turf/dirt/open
	icon_state = null
	opacity = 0
	density = 0
/obj/bullet/beam/rad
/obj/bullet/beam/sonic
/obj/bullet/rocket/grenade
	icon = 'bullet.dmi'
	icon_state = "grenade"
/obj/hud/button/attack
	icon_state = "attack"
	screen_loc = "12:6,4:16"
/obj/hud/button/get
	icon_state = "get"
	screen_loc = "12:6,5:14"
/obj/hud/button/help
	icon_state = "help"
	screen_loc = "12:6,2:12"
/obj/hud/button/observe
	icon_state = "observe"
	screen_loc = "12:6,7:10"
/obj/hud/button/panels
	icon_state = "panels"
	screen_loc = "12:6,11:2"
/obj/hud/button/save
	icon_state = "save"
	screen_loc = "12:6,7:10"
/obj/hud/button/scores
	icon_state = "score"
	screen_loc = "12:6,10:4"
/obj/hud/button/talk
	icon_state = "talk"
	screen_loc = "12:6,8:8"
/obj/hud/button/who
	icon_state = "who"
	screen_loc = "12:6,9:6"
/obj/hud/invArrow/down
	icon_state = "down"
	cycleDir = 1
	screen_loc = "12:12,0:7"
/obj/hud/invArrow/up
	icon_state = "up"
	cycleDir = -1
	screen_loc = "12:12,0:29"
/obj/hud/shopButton/cancel
	name = "Cancel purchase"
	icon_state = "cancel"
	screen_loc = "1:16,0:18"
/obj/hud/shopButton/done
	name = "Done"
	icon_state = "done"
	screen_loc = "0:26,0:18"
/obj/hud/shopButton/order
	name = "View order"
	icon_state = "order"
	screen_loc = "0:4,0:18"
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
/obj/item/equippable/armor
	icon = 'armor.dmi'
/obj/item/equippable/misc
	icon = 'equipment.dmi'
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
/obj/item/ore/asbylite
	icon = 'ore_asbylite.dmi'
	oreName = "asbylite"
	value = 300
/obj/item/ore/draxilite
	icon = 'ore_draxilite.dmi'
	oreName = "draxilite"
	value = 800
/obj/item/ore/grezlorite
	icon = 'ore_grezlorite.dmi'
	oreName = "grezlorite"
	value = 600
/obj/item/ore/hezerite
	icon = 'ore_hezerite.dmi'
	oreName = "hezerite"
	value = 700
/obj/item/ore/kaburite
	icon = 'ore_kaburite.dmi'
	oreName = "kaburite"
	value = 2000
	radioactivity = 3
/obj/item/ore/necite
	icon = 'ore_necite.dmi'
	oreName = "necite"
	value = 1000
/obj/item/ore/petrite
	icon = 'ore_petrite.dmi'
	oreName = "petrite"
	value = 500
/obj/item/useable/battery
	name = "battery charge"
	desc = "A quick, highly portable means of recharging energy sources, battery charges can be used to instantly refill a portion of your power supply, making them invaluable for keeping high-power equipment active in the field."
	icon_state = "battery"
	weight = 0.5
	delay = 5
	value = 150
	range = 6
/obj/item/useable/explosive
	var/power
	var/radius
	var/mob/player/user
/obj/item/useable/healing
/obj/item/useable/installation
	icon = 'installation.dmi'
	var/isDense = 1
	var/isDamageable = 0
	var/difficulty = 10
	var/dismantleable = 0
	var/aquatic = 0
	useAnim = "action"
/obj/item/useable/nonexpendable
	stackable = 0
/obj/item/useable/pill
	name = "rad pills"
	desc = "Radiation pills are a simple, portable way to protect oneself from harmful background radiation. While rad pills provide minimal protection from direct, intense radiation, they can readily block even moderately high levels of radiation almost harmlessly."
	icon_state = "rad pills"
	weight = 0.5
	delay = 3
	value = 100
	range = 6
/obj/item/useable/planted
	icon = 'planted.dmi'
	var/radius
	var/frequency = 5
/obj/item/vehicle/buggy
	name = "tunnel buggy"
	desc = "Built to operate in confined spaces, the tunnel buggy mounts a small but powerful engine capable of moving very quickly; unfortunately, its durability leaves something to be desired, and is easy to destroy."
	icon = 'buggy.dmi'
	icon_state = "drive"
	maxSpeed = 5
	baseDelay = 12
	speedIncrement = 2
	max_health = 50
	health = 50
	defense = 8
	top = 1
	value = 5000
	weight = 12
/obj/item/vehicle/cart
	name = "monocart"
	desc = "A fast, sturdy means of transportation, monocarts require the use of pre-laid tracks but are reliable, effective, and inexpensive."
	icon = 'cart.dmi'
	icon_state = "drive"
	maxSpeed = 3
	max_health = 80
	health = 80
	defense = 18
	value = 2000
	weight = 12
	capacity = 25
/obj/item/vehicle/drill
	name = "power digger"
	desc = "A huge self-propelled drill capable of moving earth at a tremendous rate."
	icon = 'drill.dmi'
	icon_state = "head"
	var/obj/item/vehicle/drill/part/head/head
	var/obj/item/vehicle/drill/part/rear/rear
	maxSpeed = 2
	baseDelay = 11
	max_health = 80
	health = 80
	defense = 20
	value = 10000
	weight = 28
	boardable = 1
	reverse = 1
/obj/item/vehicle/flathauler
	desc = "A heavy-duty freight vehicle, the flathauler is not the fastest or most maneuverable vehicle, but is sturdy and capable of carrying great loads of ore (as well as other teammates) easily."
	icon = 'flathauler.dmi'
	icon_state = "cab"
	var/obj/item/vehicle/flathauler/bed/bed
	maxSpeed = 3
	baseDelay = 12
	max_health = 100
	health = 100
	defense = 15
	value = 7000
	weight = 20
	top = 1
/obj/item/vehicle/raft
	name = "power raft"
	desc = "A lightweight, speedy form of water transportation, the power raft is designed to be both portable and powerful. It glides across water with ease and can be carried if necessary, but isn't particularly durable."
	icon = 'boat.dmi'
	icon_state = "drive"
	maxSpeed = 3
	baseDelay = 12
	max_health = 40
	health = 40
	defense = 11
	top = 0
	value = 1000
	weight = 5
/obj/select/raceSelect/Bolo
	desc = "Bolos are huge six-limbed mammoths that tower over the competition... literally. The strength of a bolo is tremendous, and their tough hides can withstand great amounts of punishment, but neither their hands nor their brains are very developed; moreover, their huge size makes for a cramped fit in narrow tunnels, although it does allow them to wade through water with ease.."
	icon_state = "Bolo_00"
	charType = /mob/player/bolo
/obj/select/raceSelect/Horzek
	desc = "Horzeks are large, lumbering thugs that are short on brains and long on brawn. Although they have impressive strength, horzeks tend to be lazy and have little work ethic--why work to get something when you can beat it out of someone smaller?"
	icon_state = "Horzek"
	charType = /mob/player/horzek
/obj/select/raceSelect/Jezzer
	desc = "Jezzers are slithering, multi-limbed worms who have adapted over the eons to a life of underground tunneling and exploration. Digging is simply their nature, making them ideal diggers, though they are relatively slow and fragile otherwise."
	icon_state = "Jezzer"
	charType = /mob/player/jezzer
/obj/select/raceSelect/Mobbel
	desc = "The mobbel are an amphibious race of underground dwellers. Though they are small and fragile-looking, mobbels' compact build possesses considerable muscle, making them fairly strong, agile, and tough all at once. Their webbed hands are clumsy and bad at digging, but they are expert swimmers and divers."
	icon_state = "Mobbel"
	charType = /mob/player/mobbel
/obj/select/raceSelect/Scradax
	desc = "Scradax are smallish, scurrying creatures not unlike Earth's rodents, except several feet long and sentient. Scradax are adept at crawling through cramped, narrow tunnels to evade--or give!--pursuit, and although they tend to be frail they are keen hunters and vicious fighters."
	icon_state = "Scradax"
	charType = /mob/player/scradax
/obj/select/raceSelect/Zentan
	desc = "The Zentan are a crafty, intelligent race notorious for their sense of opportunism. They understand technology easily and, although not much for heavy labor, are quick with both their fingers and their wits, making them cunning saboteurs."
	icon_state = "Zentan"
	charType = /mob/player/zentan
/obj/shop/category/ammo
	desc = "The ammunition required for non-energy weapons."
	icon_state = "ammo"
/obj/shop/category/armor
	desc = "Protective gear to absorb damage and keep you safe."
	icon_state = "armor"
/obj/shop/category/equipment
	desc = "Gear worn or carried to increase mining performance."
	icon_state = "equipment"
/obj/shop/category/installation
	desc = "Heavy duty structures for long-lasting use."
	icon_state = "installations"
/obj/shop/category/items
	desc = "Useful tools of all varieties."
	icon_state = "items"
/obj/shop/category/vehicles
	desc = "Machinery for getting to and from the mines more quickly."
	icon_state = "vehicles"
/obj/shop/category/weapon
	desc = "Tools of war for defending your claim... or attacking your enemies'."
	icon_state = "weapon"
/turf/base/loadZone/end
	icon_state = "loadtop"
/turf/base/loadZone/main
/turf/base/loadZone/middle
	icon_state = "loadmiddle"
/turf/base/spawnArea/spawnPoint
	icon_state = "respawn"
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
	adds = list("defense" = 3, "energy defense" = 3)
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
	attackAnim = "pistol"
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
	accuracy = 88
/obj/item/ore/asbylite/medium
	grade = 2
/obj/item/ore/asbylite/poor
/obj/item/ore/asbylite/rich
	grade = 3
/obj/item/ore/draxilite/medium
	grade = 2
/obj/item/ore/draxilite/poor
/obj/item/ore/draxilite/rich
	grade = 3
/obj/item/ore/grezlorite/medium
	grade = 2
/obj/item/ore/grezlorite/poor
/obj/item/ore/grezlorite/rich
	grade = 3
/obj/item/ore/hezerite/medium
	grade = 2
/obj/item/ore/hezerite/poor
/obj/item/ore/hezerite/rich
	grade = 3
/obj/item/ore/kaburite/medium
	grade = 2
/obj/item/ore/kaburite/poor
/obj/item/ore/kaburite/rich
	grade = 3
/obj/item/ore/necite/medium
	grade = 2
/obj/item/ore/necite/poor
/obj/item/ore/necite/rich
	grade = 3
/obj/item/ore/petrite/medium
	grade = 2
/obj/item/ore/petrite/poor
/obj/item/ore/petrite/rich
	grade = 3
/obj/item/useable/explosive/blast_pack
	desc = "A heavy-duty explosive device with a four-second fuse. Plant one of these and get out of the way!"
	icon_state = "blast pack"
	var/fuse = 40
	weight = 1
	value = 300
	power = 65
	radius = 4
	delay = 9
/obj/item/useable/explosive/grenade
	desc = "A simple and highly portable explosive device, grenades are highly useful weapons, capable of being carried easily and delivering damage at a distance."
	icon_state = "grenade"
	range = 6
	radius = 2
	power = 45
	delay = 4
	weight = 0.5
	value = 60
/obj/item/useable/explosive/micro_charge
	name = "micro-charge"
	desc = "Micro-charges are small, remotely detonated explosives designed for precision demolition, with a small but powerful and tightly focused blast capable of doing considerable damage."
	icon_state = "micro-charge"
	weight = 0.5
	value = 75
	power = 55
	radius = 2
	delay = 5
	range = 1
/obj/item/useable/healing/bio_kit
	name = "biofix kit"
	desc = "A more thorough and elaborate medical alternative to med patches, biofix kits are practially portable hospitals, capable of quickly and easily healing serious wounds, as well as providing minor relief from radiation and providing for lasting well-being by boosting the body's basic healing rate."
	icon_state = "biofix kit"
	weight = 1
	value = 200
	delay = 6
/obj/item/useable/healing/med_patch
	desc = "A simple, easy-to-use bandage coated with special contact drugs. Although a med patch can't provide any real long-term medical repair, it can keep wounded soldiers or workers on their feet for a long time."
	icon_state = "med patch"
	weight = 0.5
	value = 30
	delay = 4
/obj/item/useable/installation/beacon
	name = "homing beacon"
	desc = "The homing beacon is a breathtakingly simple device, little more than a comm transmitter and a mounting stand, homing beacons broadcast a tracking signal with a custom-input signature to allow teammates with tracking devices to navigate easily. Beware, however, as clever enemies with comm scanners might be navigating their way by your homing beacons, as well!"
	icon_state = "beacon"
	value = 400
	weight = 1
	dismantleable = 1
	delay = 9
	max_health = 35
	defense = 20
	isDamageable = 1
	signal = "Homing beacon"
/obj/item/useable/installation/bridge
	desc = "Sturdy, easily assembled magnetic bridge segments for constructing walkways over water."
	icon_state = "bridge"
	var/list/dirs
	isDamageable = 0
	isDense = 0
	value = 100
	weight = 1
	aquatic = 1
/obj/item/useable/installation/energy_fence
	desc = "Although fairly heavy, energy fence posts are designed for easy transportation and assembly. Simply set up a pair of energy fences in a line and they will generate a high-power energy pulse between themselves. The barrier energy fences create is specially attuned to team transmitter frequencies and will cause no harm to teammates who pass through the barrier, but enemies will recieve a very harmful jolt. Energy fences do have a self-sufficient power unit and require no external power supply, but be aware that they have a maximum range."
	icon_state = "energy fence"
	var/list/dirs = list()
	value = 850
	weight = 2
	delay = 12
	max_health = 60
	defense = 15
	isDamageable = 1
/obj/item/useable/installation/generator
	desc = "A simple power generating unit capable of charging a simple self-contained battery unit and interfacing with other power storage devices to allow workers to recharge in the field."
	icon_state = "generator"
	weight = 4
	delay = 20
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 80
	defense = 20
	max_energy = 50
	value = 4000
/obj/item/useable/installation/med_station
	desc = "A collapsable infirmary unit capable of synthesizing certain medical supplies on its own, a med station can effectively act as a field hospital when nothing better can be provided."
	icon_state = "med station"
	var/supplies = 0
	weight = 3
	delay = 12
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 45
	defense = 14
	value = 1500
/obj/item/useable/installation/microrefinery
	desc = "A very useful piece of equipment, the microrefinery is capable of purifying low-grade ores inserted into its processing bin and producing smaller amounts of higher-grade ore. The microrefinery doesn't actually increase the value of the ore it processes, but is capable of turning a large amount of ore into a smaller, lighter load worth the same amount."
	icon_state = "microrefinery"
	weight = 5
	delay = 25
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 80
	defense = 15
	value = 3500
/obj/item/useable/installation/rad_scrubber
	name = "radiation scrubber"
	desc = "Radiation scrubbers are relatively simple, self-contained environmental purification units that are capable of both absorbing background radiation and decontaminating individuals in the area who have already caught significant doses of radiation."
	icon_state = "rad scrubber"
	weight = 2.5
	delay = 11
	isDamageable = 1
	isDense = 1
	dismantleable = 1
	max_health = 40
	defense = 13
	value = 2000
/obj/item/useable/installation/rail
	desc = "Lightweight, easy-to-install track lines for monocarts to ride on."
	icon_state = "monocart tracks"
	var/list/dirs
	isDamageable = 0
	isDense = 0
	value = 35
	weight = 0.5
/obj/item/useable/installation/teleconsole
	name = "teleport console"
	desc = "One of the two pieces of equipment necessary for a functionary teleport station, the teleport console contains most of the actual teleportation apparatus, as well as the computer interface necessary to use it. A teleport console <b>must</b> be installed adjacent to a telepad in order to function, and its comparatively small power supply must periodically be recharged from personal batteries."
	icon_state = "teleconsole"
	weight = 5
	delay = 25
	value = 6500
	dismantleable = 1
	isDamageable = 1
	max_health = 65
	defense = 15
	energy_defense = 5
	max_energy = 20
/obj/item/useable/installation/telepad
	icon_state = "telepad"
	var/list/hookUp = list()
	weight = 2
	delay = 20
	value = 4000
	isDamageable = 1
	isDense = 0
	health = 100
/obj/item/useable/nonexpendable/com_scanner
	name = "comm scanner"
	desc = "A handy device, the comm scanner is capable of tracking the location signals broadcast by bases and homing beacons, and even miners--friend or foe alike. Comm scanners require both energy and a good bit of brains to use."
	icon_state = "com scanner"
	weight = 1
	value = 3500
	powerDrain = 4
	delay = 13
	range = 6
/obj/item/useable/nonexpendable/locator
	name = "locator device"
	desc = "Locator devices are small handheld gadgets attuned to the tracking signals emitted by fellow miners or team homing beacons, and especially attuned to pick up location signals from home base with ease."
	icon_state = "locator device"
	weight = 0.5
	value = 600
	powerDrain = 2
	delay = 8
	range = 6
/obj/item/useable/nonexpendable/omni_tool
	name = "omni-tool"
	desc = "A handy gizmo, the omni-tool combines the functions of an entire tool kit full of power tools into one easy-to-carry gadget. It is, unfortunately, not quite so easy-to-use--using the omni-tool requires both intelligence and skill, but is invaluable for both servicing your team's machinery to keep it in peak condition and sabotaging that of your enemies, although it does require a very small bit of power"
	icon_state = "omni-tool"
	weight = 0.5
	value = 1200
	delay = 10
	useAnim = "action"
	powerDrain = 1
/obj/item/useable/nonexpendable/orefinder
	desc = "An invaluable tool, the orefinder uses advanced sonar techniques to detect solid, dense ore formations embedded in dirt. It drains relatively minor amounts of power, but unfortunately it does require quite a bit of manual fine-tuning--it takes a pretty bright user to use the orefinder effectively."
	icon_state = "orefinder"
	weight = 1
	value = 1000
	delay = 9
	powerDrain = 3
	range = 6
/obj/item/useable/nonexpendable/portable_decontamination_unit
	desc = "This helpful (although somewhat clumsy) tool can be used to clean the user or his or her teammates of radiation they've picked up. It is relatively easy to use, although it drains a good deal of power each use."
	icon_state = "decontam"
	weight = 1
	value = 1500
	delay = 15
	powerDrain = 5
/obj/item/useable/nonexpendable/teleport
	name = "personal teleporter"
	icon_state = "teleporter"
	var/destination
	weight = 0.5
	value = 4000
	powerDrain = 16
	delay = 10
	range = 6
/obj/item/useable/planted/alarm
	desc = "Simple alarms capable of detecting approaching intruders through a combination of vibrations and careful scanning of communication channels to pick up enemy signals, these can be easily buried to provide a lasting warning system."
	icon_state = "motion sensor"
	value = 350
	weight = 0.5
	radius = 3
	delay = 7
	frequency = 20
/obj/item/useable/planted/shock_mine
	desc = "Shock mines are a high-powered, military-grade alternative to the humble stun mine, dispensing a powerful electrical blast to terminate trespassers with prejudice."
	icon_state = "shock mine"
	value = 150
	weight = 0.5
	delay = 6
	radius = 0
/obj/item/useable/planted/stun_mine
	desc = "Simple devices designed to catch trespassers with nonlethal force, stun mines can be buried quickly, safely, and easily, without fear of discharging under the user's feet, or even that of his or her teammates."
	icon_state = "stun mine"
	value = 90
	weight = 0.5
	delay = 6
	radius = 0
/obj/item/vehicle/drill/part
	animate_movement = 2
	var/obj/item/vehicle/drill/main
/obj/item/vehicle/flathauler/bed
	name = "flathauler"
	icon_state = "bed"
	animate_movement = 2
	var/obj/item/vehicle/cab
	debris = "bed debris"
	top = 0
	max_health = 70
	health = 70
	defense = 20
	weight = 15
	capacity = 35
/obj/item/vehicle/drill/part/head
	debris = "head debris"
/obj/item/vehicle/drill/part/rear
	icon_state = "back"
	debris = "back debris"
