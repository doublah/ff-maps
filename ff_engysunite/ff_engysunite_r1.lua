----------------------------------------------------------------------
-- Includes
----------------------------------------------------------------------

IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_ctf")
IncludeScript("base_respawnturret")
-----------------------------------------------------------------------------
-- map level handlers
-----------------------------------------------------------------------------
function startup()
	-- set up team limits
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)
	
	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetAllies( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kYellow)
	team:SetAllies( Team.kGreen )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam(Team.kGreen)
	team:SetAllies( Team.kYellow )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	RemoveHudItem( player, blue_flag.name )
	RemoveHudItemFromAll( blue_flag.name .. "_c" )
	RemoveHudItemFromAll( blue_flag.name .. "_d" )

	RemoveHudItem( player, red_flag.name )
	RemoveHudItemFromAll( red_flag.name .. "_c" )
	RemoveHudItemFromAll( red_flag.name .. "_d" )

	RemoveHudItem( player, green_flag.name )
	RemoveHudItemFromAll( green_flag.name .. "_c" )
	RemoveHudItemFromAll( green_flag.name .. "_d" )

	RemoveHudItem( player, yellow_flag.name )
	RemoveHudItemFromAll( yellow_flag.name .. "_c" )
	RemoveHudItemFromAll( yellow_flag.name .. "_d" )

	-- copied from blue_flag variables
	AddHudIcon( player, blue_flag.hudstatusiconhome, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	AddHudIcon( player, red_flag.hudstatusiconhome, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	AddHudIcon( player, green_flag.hudstatusiconhome, ( green_flag.name.. "_h" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
	AddHudIcon( player, yellow_flag.hudstatusiconhome, ( yellow_flag.name.. "_h" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )

	local flag = GetInfoScriptByName("blue_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, blue_flag.hudstatusiconcarried, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, blue_flag.hudstatusicondropped, ( blue_flag.name.. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	end

	flag = GetInfoScriptByName("red_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, red_flag.hudstatusiconcarried, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, red_flag.hudstatusicondropped, ( red_flag.name.. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	end

	flag = GetInfoScriptByName("yellow_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, yellow_flag.hudstatusiconcarried, ( yellow_flag.name.. "_h" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, yellow_flag.hudstatusicondropped, ( yellow_flag.name.. "_h" ), yellow_flag.hudstatusiconx, yellow_flag.hudstatusicony, yellow_flag.hudstatusiconw, yellow_flag.hudstatusiconh, yellow_flag.hudstatusiconalign )
	end

	flag = GetInfoScriptByName("green_flag")
	
	if flag:IsCarried() then
			AddHudIcon( player, green_flag.hudstatusiconcarried, ( green_flag.name.. "_h" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, green_flag.hudstatusicondropped, ( green_flag.name.. "_h" ), green_flag.hudstatusiconx, green_flag.hudstatusicony, green_flag.hudstatusiconw, green_flag.hudstatusiconh, green_flag.hudstatusiconalign )
	end
end

----------------------------------------------------------------------
-- Armor Kit
----------------------------------------------------------------------

armorkitgeneric = genericbackpack:new({
	armor = 200,
	cells = 200,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",
	respawntime = 5,	
	touchsound = "ArmorKit.Touch",
})

supplypackgeneric = genericbackpack:new({
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

----------------------------------------------------------------------
-- Spawn Bags
----------------------------------------------------------------------

function player_spawn( player_id )
	local player = GetPlayer(player_id)

	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddRemove( Ammo.kCells, 400 )
end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
end



blue_flag = baseflag:new({team = Team.kBlue,
						 modelskin = 0,
						 name = "Blue Flag",
						 hudicon = "hud_flag_blue.vtf",
						 hudx = 5,
						 hudy = 114,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1, 
						 hudstatusicondropped = "hud_flag_dropped_blue.vtf",
						 hudstatusiconhome = "hud_flag_home_blue.vtf",
						 hudstatusiconcarried = "hud_flag_carried_blue.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kGreen}})

red_flag = baseflag:new({team = Team.kRed,
						 modelskin = 1,
						 name = "Red Flag",
						 hudicon = "hud_flag_red.vtf",
						 hudx = 5,
						 hudy = 162,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_red.vtf",
						 hudstatusiconhome = "hud_flag_home_red.vtf",
						 hudstatusiconcarried = "hud_flag_carried_red.vtf",
						 hudstatusiconx = 60,
						 hudstatusicony = 5,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kYellow}})
						  
yellow_flag = baseflag:new({team = Team.kYellow,
						 modelskin = 2,
						 name = "Yellow Flag",
						 hudicon = "hud_flag_yellow.vtf",
						 hudx = 5,
						 hudy = 210,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_yellow.vtf",
						 hudstatusiconhome = "hud_flag_home_yellow.vtf",
						 hudstatusiconcarried = "hud_flag_carried_yellow.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 2,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed} })

green_flag = baseflag:new({team = Team.kGreen,
						 modelskin = 3,
						 name = "Green Flag",
						 hudicon = "hud_flag_green.vtf",
						 hudx = 5,
						 hudy = 258,
						 hudwidth = 48,
						 hudheight = 48,
						 hudalign = 1,
						 hudstatusicondropped = "hud_flag_dropped_green.vtf",
						 hudstatusiconhome = "hud_flag_home_green.vtf",
						 hudstatusiconcarried = "hud_flag_carried_green.vtf",
						 hudstatusiconx = 53,
						 hudstatusicony = 25,
						 hudstatusiconw = 15,
						 hudstatusiconh = 15,
						 hudstatusiconalign = 3,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue} })						  

my_cap = basecap:new({})

function my_cap:oncapture(player, item)
    if player:GetTeamId() == Team.kBlue then
      OutputEvent( "alpha_door1", "Open" )
      OutputEvent( "alpha_door2", "Open" )
      OutputEvent( "alpha_door3", "Open" )
      OutputEvent( "alpha_door4", "Open" )
      OutputEvent( "alpha_maingate", "Open" )
      OutputEvent( "alphaspecialdoor", "Disable" )
      OutputEvent( "beta_door1", "Close" )
      OutputEvent( "beta_door2", "Close" )
      OutputEvent( "beta_door3", "Close" )
      OutputEvent( "beta_door4", "Close" )
      OutputEvent( "beta_maingate", "Close" )
      OutputEvent( "betaspecialdoor", "Enable" )
    elseif player:GetTeamId() == Team.kGreen then
      OutputEvent( "alpha_door1", "Open" )
      OutputEvent( "alpha_door2", "Open" )
      OutputEvent( "alpha_door3", "Open" )
      OutputEvent( "alpha_door4", "Open" )
      OutputEvent( "alpha_maingate", "Open" )
      OutputEvent( "alphaspecialdoor", "Disable" )
      OutputEvent( "beta_door1", "Close" )
      OutputEvent( "beta_door2", "Close" )
      OutputEvent( "beta_door3", "Close" )
      OutputEvent( "beta_door4", "Close" )
      OutputEvent( "beta_maingate", "Close" )
      OutputEvent( "betaspecialdoor", "Enable" )
    elseif player:GetTeamId() == Team.kYellow then
      OutputEvent( "alpha_door1", "Close" )
      OutputEvent( "alpha_door2", "Close" )
      OutputEvent( "alpha_door3", "Close" )
      OutputEvent( "alpha_door4", "Close" )
      OutputEvent( "alpha_maingate", "Close" )
      OutputEvent( "alphaspecialdoor", "Enable" )
      OutputEvent( "beta_door1", "Open" )
      OutputEvent( "beta_door2", "Open" )
      OutputEvent( "beta_door3", "Open" )
      OutputEvent( "beta_door4", "Open" )
      OutputEvent( "beta_maingate", "Open" )
      OutputEvent( "betaspecialdoor", "Disable" )
    elseif player:GetTeamId() == Team.kRed then
      OutputEvent( "alpha_door1", "Close" )
      OutputEvent( "alpha_door2", "Close" )
      OutputEvent( "alpha_door3", "Close" )
      OutputEvent( "alpha_door4", "Close" )
      OutputEvent( "alpha_maingate", "Close" )
      OutputEvent( "alphaspecialdoor", "Enable" )
      OutputEvent( "beta_door1", "Open" )
      OutputEvent( "beta_door2", "Open" )
      OutputEvent( "beta_door3", "Open" )
      OutputEvent( "beta_door4", "Open" )
      OutputEvent( "beta_maingate", "Open" )
      OutputEvent( "betaspecialdoor", "Disable" )
    end

    -- let the teams know that a capture occured
    SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
    SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
    SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")

end

blue_my_cap = my_cap:new({team = Team.kBlue,
			  item = {"green_flag"}})

red_my_cap = my_cap:new({team = Team.kRed,
			 item = {"yellow_flag"}})

yellow_my_cap = my_cap:new({team = Team.kYellow,
			  item = {"red_flag"}})

green_my_cap = my_cap:new({team = Team.kGreen,
			  item = {"blue_flag"}})

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_pit = location_info:new({ text = "The Pit", team = NO_TEAM })

location_bluespawn = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_blueflagroom = location_info:new({ text = "Blue Flagroom", team = Team.kBlue })
location_bluepond = location_info:new({ text = "Blue Pond", team = Team.kBlue })
location_bluecap = location_info:new({ text = "Capture Point", team = Team.kBlue })
location_bluearmory = location_info:new({ text = "Blue Armory", team = NO_TEAM })
location_bluesupply = location_info:new({ text = "Blue Resupply", team = Team.kBlue })

location_redspawn = location_info:new({ text = "Red Spawn", team = Team.kRed })
location_redflagroom = location_info:new({ text = "Red Flagroom", team = Team.kRed })
location_redpond = location_info:new({ text = "Red Pond", team = Team.kRed })
location_redcap = location_info:new({ text = "Capture Point", team = Team.kRed })
location_redarmory = location_info:new({ text = "Red Armory", team = NO_TEAM })
location_redsupply = location_info:new({ text = "Red Resupply", team = Team.kRed })

location_yellowspawn = location_info:new({ text = "Yellow Spawn", team = Team.kYellow })
location_yellowflagroom = location_info:new({ text = "Yellow Flagroom", team = Team.kYellow })
location_yellowpond = location_info:new({ text = "Yellow Pond", team = Team.kYellow })
location_yellowcap = location_info:new({ text = "Capture Point", team = Team.kYellow })
location_yellowarmory = location_info:new({ text = "Yellow Armory", team = NO_TEAM })
location_yellowsupply = location_info:new({ text = "Yellow Resupply", team = Team.kYellow })

location_greenspawn = location_info:new({ text = "Green Spawn", team = Team.kGreen })
location_greenflagroom = location_info:new({ text = "Green Flagroom", team = Team.kGreen })
location_greenpond = location_info:new({ text = "Green Pond", team = Team.kGreen })
location_greencap = location_info:new({ text = "Capture Point", team = Team.kGreen })
location_greenarmory = location_info:new({ text = "Green Armory", team = NO_TEAM })
location_greensupply = location_info:new({ text = "Green Resupply", team = Team.kGreen })
