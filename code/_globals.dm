var/playerLimit = 0
var/serverName
var/host
var/MOTD = "<b>Welcome to <a href=\"http://www.byond.com/hub/Leftley/LodeWars\">Lode Wars</a>.</b>"
var/map/map
var/map/nextMap

world
	mob = /mob/observer
	name = "Lode Wars"
	hub = "Leftley.Lode Wars"

var/image/eFence = image('barrier.dmi', null, "top", 7)
var/list/boloIcons = list('bolo_00.dmi', 'bolo_01.dmi', 'bolo_10.dmi', 'bolo_11.dmi', 'bwater_00.dmi', 'bwater_10.dmi', 'bwater_01.dmi', 'bwater_11.dmi')
var/list/filter = list()
var/list/observers = list()
var/list/signals = list()
var/list/teams = list()
var/list/weaponsCatalog = typesof(/obj/item/equippable/weapon) - /obj/item/equippable/weapon
var/list/admins = list()
var/list/shopBase = list()
var/list/playTeams = list()
var/list/condensedCoords = list("strength" = "61,344", "attack" = "61,325", "speed" = "61,306", "dexterity" = "61,287", "intelligence" = "61,268", "aim" = "61,249", "defense" = "61,230", "digging" = "61,211", "rank" = "61,370", "health" = "69,182", "energy" = "69,163", "radiation" = "69,144", "cash" = "85,68", "carry" = "61, 87")
var/list/adminList = list()
var/list/ammoCatalog = typesof(/obj/item/ammo) - /obj/item/ammo
var/list/teleports = list()
var/list/armorCatalog = typesof(/obj/item/equippable/armor) - /obj/item/equippable/armor
var/list/teamSpawns = list()
var/list/banKeys = list()
var/list/equipCatalog = typesof(/obj/item/equippable/misc) - /obj/item/equippable/misc
var/list/masterHUD = list()
var/list/banIP = list()
var/list/condensedHUD = list()
var/list/installationCatalog = typesof(/obj/item/useable/installation) - /obj/item/useable/installation
var/list/itemCatalog = typesof(/obj/item/useable) - /obj/item/useable - /obj/item/useable/nonexpendable - /obj/item/useable/installation - /obj/item/useable/explosive - /obj/item/useable/healing - /obj/item/useable/planted - installationCatalog
var/list/shopHUD = list()
var/list/unbanned = list()
var/list/HUDCoords = list("strength" = "36,370", "attack" = "36,349", "speed" = "36,328", "dexterity" = "36,307", "intelligence" = "36,286", "aim" = "36,265", "defense" = "36,244", "digging" = "36,223", "rank" = "143,401", "health" = "8,109", "energy" = "23,109", "radiation" = "38,109", "cash" = "59,59", "team" = "66,402", "carry" = "60, 11")
var/list/players = list()
var/list/vehicleCatalog = typesof(/obj/item/vehicle) - /obj/item/vehicle - /obj/item/vehicle/flathauler/bed - typesof(/obj/item/vehicle/drill/part)
var/shopCatalog = weaponsCatalog + ammoCatalog + armorCatalog + equipCatalog + itemCatalog + installationCatalog + vehicleCatalog
var/list/money = list()
var/list/shopItems = list()
var/list/veinsFound = list()
