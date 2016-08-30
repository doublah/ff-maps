-- ff_juggle_this.lua

IncludeScript("base_teamplay");

function startup()
	-- Enable only Red team.
	SetPlayerLimit(Team.kBlue, -1)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- Enable only Scout and Medic.
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSniper, -1 )
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSoldier, -1 )
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kDemoman, -1 )
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kHwguy, -1 )
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kPyro, -1 )
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kSpy, -1 )
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kEngineer, -1 )
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kCivilian, -1 )
	
end

function precache()
	PrecacheSound("misc.doop")
end

-- Disable conc effect.
function player_onconc( player_entity, concer_entity )
	return false
end


-- Fully resupplies the player.
function fullresupply( player )
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, -400 )
	player:AddAmmo( Ammo.kCells, -400 )
	
	player:AddAmmo( Ammo.kGren1, -4 )
	player:AddAmmo( Ammo.kGren2, 4 )
end

-- Keeps track of players record.
max_level = { }

-- Reset records - Doesn't work until version 1.1
--[[
function player_ondisconnect( player_entity )
	local player = CastToPlayer( player_entity )
	max_level[player:GetId()] = 0
end
]]

-- Fully resupplies the player on spawn.
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	fullresupply( player )
end

resupplyzone = trigger_ff_script:new({ })

-- Fully resupplies the players once every 0.1 seconds when they are inside the resupply zone.
function resupplyzone:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		fullresupply( player )
	end
	-- Return true to allow triggering the zone if needed.
	return true
end

-- Locations
location_info = trigger_ff_script:new({ })

function location_info:ontouch( touch_entity )

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

function location_info:onendtouch( touch_entity )
	-- remove the location from the player
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:RemoveLocation(entity:GetId())
	end
end

location_0 =  location_info:new({ level = 0 })
location_1 =  location_info:new({ level = 1 })
location_2 =  location_info:new({ level = 2 })
location_3 =  location_info:new({ level = 3 })
location_4 =  location_info:new({ level = 4 })
location_5 =  location_info:new({ level = 5 })
location_6 =  location_info:new({ level = 6 })
location_7 =  location_info:new({ level = 7 })
location_8 =  location_info:new({ level = 8 })
location_9 =  location_info:new({ level = 9 })
location_10 = location_info:new({ level = 10 })
location_11 = location_info:new({ level = 11 })
location_12 = location_info:new({ level = 12 })
location_13 = location_info:new({ level = 13 })
location_14 = location_info:new({ level = 14 })
location_15 = location_info:new({ level = 15 })
location_16 = location_info:new({ level = 16 })
location_17 = location_info:new({ level = 17 })
location_18 = location_info:new({ level = 18 })
location_19 = location_info:new({ level = 19 })
location_20 = location_info:new({ level = 20 })
location_21 = location_info:new({ level = 21 })
location_22 = location_info:new({ level = 22 })
location_23 = location_info:new({ level = 23 })
location_24 = location_info:new({ level = 24 })
location_25 = location_info:new({ level = 25 })
location_26 = location_info:new({ level = 26 })
location_27 = location_info:new({ level = 27 })
location_28 = location_info:new({ level = 28 })
location_29 = location_info:new({ level = 29 })
location_30 = location_info:new({ level = 30 })