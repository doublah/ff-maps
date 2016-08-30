-- ff_pyrat.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 30
-----------------------------------------------------------------------------
-- Spawn Supplies
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 0 )
	player:AddArmor( 300 )
	player:AddAmmo( Ammo.kBullets, 400 )
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 0 )
	player:AddAmmo( Ammo.kGren1, 0 )
	player:AddAmmo( Ammo.kGren2, 0 )
end
-----------------------------------------------------------------------------
-- Bags
-----------------------------------------------------------------------------

blue_bagcustom = genericbackpack:new({ 
	health = 100,
	armor = 300,
	grenades = 0,
	bullets = 300,
	nails = 300,
	shells = 300,
	rockets = 300,
	cells = 100,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})

blue_grenadecustom = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 20,
	bullets = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})

red_bagcustom = genericbackpack:new({
	health = 100,
	armor = 300,
	grenades = 0,
	bullets = 300,
	nails = 300,
	shells = 300,
	rockets = 300,
	cells = 100,
	detpacks = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})

red_grenadecustom = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 20,
	bullets = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})


-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_bluespawn = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_bluedeck = location_info:new({ text = "Blue Deck", team = Team.kBlue })
location_bluefloor = location_info:new({ text = "Blue Floor", team = Team.kBlue })
location_bluesails = location_info:new({ text = "Blue Sails", team = Team.kBlue })
location_blueboat = location_info:new({ text = "Blue Dinghy", team = Team.kBlue })


location_redspawn = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_reddeck = location_info:new({ text = "Red Deck", team = Team.kRed })
location_redfloor = location_info:new({ text = "Red Floor", team = Team.kRed })
location_redsails = location_info:new({ text = "Red Sails", team = Team.kRed })
location_redmess = location_info:new({ text = "Captains Mess", team = Team.kRed })
location_redledge = location_info:new({ text = "Captains Windows", team = Team.kRed })
location_redroof = location_info:new({ text = "Captains Roof", team = Team.kRed })
location_redboat = location_info:new({ text = "Red Dinghy", team = Team.kRed })


location_middleoutside = location_info:new({ text = "Mid Deck", team = NO_TEAM })
location_middleinside = location_info:new({ text = "Interior", team = NO_TEAM })
location_middlesails = location_info:new({ text = "Mid Sails", team = NO_TEAM })
location_middlebelow = location_info:new({ text = "Jail", team = NO_TEAM })
location_ocean = location_info:new({ text = "Ocean", team = NO_TEAM })

