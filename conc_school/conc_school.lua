-- Conc_School.lua
-- Created by Alex "Dr.Satan" Laswell

IncludeScript("base_location");
IncludeScript("base_ctf4");

-- Points and Frags you receive for touching EndZone.
CONC_POINTS = 5000
CONC_FRAGS = 1000
JUGGLE_FRAGS = 10

-- Disable/Enable classes allowed.
SOLDIER = 0
SCOUT = 1
MEDIC = 1
DEMOMAN = 0
ENGINEER = 0
PYRO = 0

function startup()

	SetTeamName( Team.kBlue, "Students" )
	SetTeamName( Team.kRed, "Jugglers" )

	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 ) 
	
	-- BLUE TEAM
	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1)
	
	ShouldEnableClass( team, SCOUT, Player.kScout )
	ShouldEnableClass( team, MEDIC, Player.kMedic )
	
	
	-- RED TEAM
	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kEngineer, -1)
	
	ShouldEnableClass( team, SCOUT, Player.kScout )
	ShouldEnableClass( team, MEDIC, Player.kMedic )
	
end

function ShouldEnableClass( team, classtype, class )
	if classtype == 1 then
		team:SetClassLimit( class, 0 )
	else
		team:SetClassLimit( class, -1 )
	end
end

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
end

-- Disable conc effect.
function player_onconc( player_entity, concer_entity )
	return false
end


-- Gives player concs / removes all other ammo
function fullresupply( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:RemoveWeapon( "ff_weapon_shotgun" )
	player:RemoveWeapon( "ff_weapon_supershotgun" )
	player:RemoveWeapon( "ff_weapon_nailgun" )
	player:RemoveWeapon( "ff_weapon_supernailgun" )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	player:RemoveAmmo( Ammo.kCells, 400 )
		
	player:RemoveAmmo( Ammo.kGren1, 4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end


-----------------------------------------------------------------------------
-- End Zone Entity
-----------------------------------------------------------------------------

endzone = trigger_ff_script:new()

function endzone:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
			
		ConsoleToAll( player:GetName() .. " has graduated from conc_school!" )
		BroadCastMessage( player:GetName() .. " has graduated from conc_school!" )
		
		SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "yourteam.flagcap")
			
		player:AddFrags( CONC_FRAGS )
		player:AddFortPoints( CONC_POINTS, "Graduated!" )
			
	end
	
end

-----------------------------------------------------------------------------
-- Resuply (on spawn and via trigger)
-----------------------------------------------------------------------------

-- Resupplies the player on spawn.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	fullresupply( player )
	BroadCastMessageToPlayer(player, "Your weapons have been stripped. You must complete the map with your concussion grenades ONLY.")
end

resupplyzone = trigger_ff_script:new({ })

-- Resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function resupplyzone:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end


-----------------------------------------------------------------------------
-- Jump Locations 
-----------------------------------------------------------------------------

location_tele_room = location_info:new({ text = "Teleport Room", team = Team.kBlue })
location_jump1 = location_info:new({ text = "Jump 1 - Basic Conc", team = Team.kBlue })
location_jump2 = location_info:new({ text = "Jump 2 - Hand Held", team = Team.kBlue })
location_jump3 = location_info:new({ text = "Jump 3 - Up and Over", team = Team.kBlue })
location_jump4 = location_info:new({ text = "Jump 4 - NO glass?", team = Team.kBlue })
location_jump5 = location_info:new({ text = "Jump 5 - Double Conc", team = Team.kBlue })
location_jump6 = location_info:new({ text = "Jump 6 - Over and Up", team = Team.kBlue })
location_jump7 = location_info:new({ text = "Jump 7 - Water?", team = Team.kBlue })
location_jump8 = location_info:new({ text = "Jump 8 - Water + Double Conc", team = Team.kBlue })
location_jump9 = location_info:new({ text = "Jump 9 - Water + Window", team = Team.kBlue })
location_jump10 = location_info:new({ text = "Jump 10 - Strafe (Left)", team = Team.kBlue })
location_jump11 = location_info:new({ text = "Jump 11 - Strafe (Right)", team = Team.kBlue })
location_jump12 = location_info:new({ text = "Jump 12 - Down and Over", team = Team.kBlue })
location_jump13 = location_info:new({ text = "Jump 13 - Up and Over (2 concs)", team = Team.kBlue })
location_jump14 = location_info:new({ text = "Jump 14 - Through the hole", team = Team.kBlue })
location_jump15 = location_info:new({ text = "Jump 15 - Triple Conc", team = Team.kBlue })
location_tunnel = location_info:new({ text = "The Tunnel of Love", team = Team.kBlue })
location_endzone = location_info:new({ text = "You have completed conc_school!", team = Team.kGreen })

-----------------------------------------------------------------------------
-- Juggle Locations (taken from ff_juggle_this) 
-- modified to work with conc_school
-----------------------------------------------------------------------------

-- Keeps track of players record.
max_level = { }

location_juggle = trigger_ff_script:new({ })

function location_juggle:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		
		local level = self.level
		local color = Team.kUnassigned
		
		-- Set the value to 0 if it's still nil
		if max_level[player:GetId()] == nil then
			max_level[player:GetId()] = 0
		end
		
		if max_level[player:GetId()] < level then
			max_level[player:GetId()] = level
			-- Player has made some progress, play a sound, show a message and add some fortress points!
			BroadCastSoundToPlayer(player, "misc.doop")
			BroadCastMessageToPlayer(player, "New record: " .. level)
			player:AddFortPoints(1000, "Reaching level " .. level)
			player:AddFrags( JUGGLE_FRAGS )
		end
		
		local maxlevel = max_level[player:GetId()]
		
		-- Display FINISHED! as max level if the player has reached the top and change the color to green
		if maxlevel == 30 then
			maxlevel = "FINISHED!"
			color = Team.kGreen
		end
		
		-- If FINISHED! was just enabled to the player and the player falls down before fully exiting the previous location trigger,
		-- the record is shown wrong for the time the player is inside the current location trigger... this happens because the location
		-- is only removed when the player exits the trigger brush (see location_info:onendtouch).
		-- I'm not quite sure how to fix this easily but it's visible only for a second or so, no big deal :P
		player:SetLocation(entity:GetId(), "Level: " .. level .. " Record: " .. maxlevel , color)
	end
end

function location_juggle:onendtouch( touch_entity )
	-- remove the location from the player
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:RemoveLocation(entity:GetId())
	end
end

location_0 =  location_juggle:new({ level = 0 })
location_1 =  location_juggle:new({ level = 1 })
location_2 =  location_juggle:new({ level = 2 })
location_3 =  location_juggle:new({ level = 3 })
location_4 =  location_juggle:new({ level = 4 })
location_5 =  location_juggle:new({ level = 5 })
location_6 =  location_juggle:new({ level = 6 })
location_7 =  location_juggle:new({ level = 7 })
location_8 =  location_juggle:new({ level = 8 })
location_9 =  location_juggle:new({ level = 9 })
location_10 = location_juggle:new({ level = 10 })
location_11 = location_juggle:new({ level = 11 })
location_12 = location_juggle:new({ level = 12 })
location_13 = location_juggle:new({ level = 13 })
location_14 = location_juggle:new({ level = 14 })
location_15 = location_juggle:new({ level = 15 })
location_16 = location_juggle:new({ level = 16 })
location_17 = location_juggle:new({ level = 17 })
location_18 = location_juggle:new({ level = 18 })
location_19 = location_juggle:new({ level = 19 })
location_20 = location_juggle:new({ level = 20 })
location_21 = location_juggle:new({ level = 21 })
location_22 = location_juggle:new({ level = 22 })
location_23 = location_juggle:new({ level = 23 })
location_24 = location_juggle:new({ level = 24 })
location_25 = location_juggle:new({ level = 25 })
location_26 = location_juggle:new({ level = 26 })
location_27 = location_juggle:new({ level = 27 })
location_28 = location_juggle:new({ level = 28 })
location_29 = location_juggle:new({ level = 29 })
location_30 = location_juggle:new({ level = 30 })