-- ff_argon_beta_1.lua


-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_location");
IncludeScript("base_ctf");
IncludeScript("base_respawnturret");
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------

if POINTS_PER_PERIOD == nil then POINTS_PER_PERIOD = 1; end
if PERIOD_TIME == nil then PERIOD_TIME = 9; end

blue = Team.kBlue
red = Team.kRed
current_timer = 0

function startup()

-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )
	
	-- start the timer for the points
	AddScheduleRepeating("addpoints", PERIOD_TIME, addpoints)
	
	-- set them team names
	SetTeamName( blue, "Blue Team" )
	SetTeamName( red, "Red Team" )
	

	-- Class limits
	local team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
 
	local team = GetTeam( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
end



-----------------------------------------------------
--Flags
-----------------------------------------------------

argon_baseflag = baseflag:new({})

function argon_baseflag:touch( touch_entity )
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end
	
	if player:GetTeamId() ~= self.team then
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		SmartSpeak(player, "CTF_YOUGOTFLAG", "CTF_GOTFLAG", "CTF_LOSTFLAG")
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP")
		
		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )
		
		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )
		RemoveHudItemFromAll( flag:GetName() .. "_h" )
		RemoveHudItemFromAll( flag:GetName() .. "_d" )
		AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
		AddHudIconToAll( self.hudstatusiconcarried, ( flag:GetName() .. "_c" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )

		-- log action in stats
		LogLuaEvent(player:GetId(), 0, "flag_touch", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());	
		
		local team = nil
		-- get team as a lowercase string
		if player:GetTeamId() == Team.kBlue then team = "blue" end
		if player:GetTeamId() == Team.kRed then team = "red" end
		if player:GetTeamId() == Team.kGreen then team = "green" end  
		if player:GetTeamId() == Team.kYellow then team = "yellow" end
		
		-- objective icon pointing to the cap
		UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), nil )
		UpdateTeamObjectiveIcon( GetTeam(Team.kRed), nil )
		UpdateObjectiveIcon( player, GetEntityByName( team.."_cap" ) )

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
	end
end

function argon_baseflag:onownerdie( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )
	RemoveHudItemFromAll( flag:GetName() .. "_c" )
	AddHudIconToAll( self.hudstatusicondropped, ( flag:GetName() .. "_d" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	self.status = 2
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), GetEntityByName("red_flag") )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed), GetEntityByName("red_flag") )

	-- log action in stats
	-- player:AddAction(nil, "ctf_flag_died", flag:GetName())
	LogLuaEvent(player:GetId(), 0, "flag_dropped", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ));	
end

function argon_baseflag:ownercloak( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
	
	LogLuaEvent(player:GetId(), 0, "flag_drop","flag_name",flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());	
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )
	RemoveHudItemFromAll( flag:GetName() .. "_c" )
	AddHudIconToAll( self.hudstatusicondropped, ( flag:GetName() .. "_d" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	self.status = 2
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), GetEntityByName("red_flag") )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed), GetEntityByName("red_flag") )
end

function argon_baseflag:dropitemcmd( owner_entity )

	if allowdrop == false then return end

	-- throw the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, FLAG_THROW_SPEED)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )
	RemoveHudItemFromAll( flag:GetName() .. "_c" )
	AddHudIconToAll( self.hudstatusicondropped, ( flag:GetName() .. "_d" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	self.status = 2
	LogLuaEvent(player:GetId(), 0, "flag_thrown","flag_name",flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" ..player:GetHealth());
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), GetEntityByName("red_flag") )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed), GetEntityByName("red_flag") )
end	

function argon_baseflag:ondrop( owner_entity )
	local player = CastToPlayer( owner_entity )
	-- let the teams know that the flag was dropped
	SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
	SmartMessage(player, "#FF_YOUDROP", "#FF_TEAMDROP", "#FF_OTHERTEAMDROP")
	
	local flag = CastToInfoScript(entity)
	flag:EmitSound(self.tosssound)
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), GetEntityByName("red_flag") )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed), GetEntityByName("red_flag") )
end

function argon_baseflag:onloseitem( owner_entity )
	-- let the player that lost the flag put on a disguise
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable(true)
	-- let player cloak if he can
	player:SetCloakable( true )

	self:addnotouch(player:GetId(), self.capnotouchtime)
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), GetEntityByName("red_flag") )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed), GetEntityByName("red_flag") )
end

function argon_baseflag:onownerforcerespawn( owner_entity )
	local flag = CastToInfoScript( entity )
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable( true )
	player:SetCloakable( true )
	RemoveHudItem( player, flag:GetName() )	
	flag:Drop(0, FLAG_THROW_SPEED)
	
	LogLuaEvent(player:GetId(), 0, "flag_dropped", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ));
	
	RemoveHudItemFromAll( flag:GetName() .. "_d" )
	RemoveHudItemFromAll( flag:GetName() .. "_c" )
	AddHudIconToAll( self.hudstatusicondropped, ( flag:GetName() .. "_d" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	self.status = 2
	
	-- clear the objective icon
	UpdateObjectiveIcon( player, nil )
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), GetEntityByName("red_flag") )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed), GetEntityByName("red_flag") )
end

function argon_baseflag:onreturn( )
	-- let the teams know that the flag was returned
	local team = GetTeam( self.team )
	SmartTeamMessage(team, "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN")
	SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
	SmartTeamSpeak(team, "CTF_FLAGBACK", "CTF_EFLAGBACK")
	local flag = CastToInfoScript( entity )

	RemoveHudItemFromAll( flag:GetName() .. "_d" )
	RemoveHudItemFromAll( flag:GetName() .. "_c" )
	
	LogLuaEvent(0, 0, "flag_returned","flag_name",flag:GetName());
	
	AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	self.status = 0
	
	UpdateTeamObjectiveIcon( GetTeam(Team.kBlue), GetEntityByName("red_flag") )
	UpdateTeamObjectiveIcon( GetTeam(Team.kRed), GetEntityByName("red_flag") )
end


blue_flag = argon_baseflag:new({team = Team.kBlue,
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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}})

red_flag = argon_baseflag:new({team = Team.kRed,
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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}})
						  
yellow_flag = argon_baseflag:new({team = Team.kYellow,
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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kGreen} })

green_flag = argon_baseflag:new({team = Team.kGreen,
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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kYellow} })


-----------------------------------------------------------------------------
-- Capture Points
-----------------------------------------------------------------------------
argoncap = trigger_ff_script:new({
	health = 25,
	armor = 50,
	detpacks = 1,
	mancannons = 1,
	gren1 = 1,
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

bluerspawn = info_ff_script:new()

function argoncap:allowed ( allowed_entity )
	if IsPlayer( allowed_entity ) then
		-- get the player and his team
		local player = CastToPlayer( allowed_entity )
		local team = player:GetTeam()
	
		-- check if the player is on our team
		if team:GetTeamId() ~= self.team then
			return false
		end
	
		-- check if the player has the flag
		for i,v in ipairs(self.item) do
			local flag = GetInfoScriptByName(v)
			
			-- Make sure flag isn't nil
			if flag then
				if player:HasItem(flag:GetName()) then
					return true
				end
			end
		end
	end
	
	return false
end

function argoncap:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- player should capture now
		for i,v in ipairs( self.item ) do
			
			-- find the flag and cast it to an info_ff_script
			local flag = GetInfoScriptByName(v)

			-- Make sure flag isn't nil
			if flag then
			
				-- check if the player is carrying the flag
				if player:HasItem(flag:GetName()) then
					
					-- reward player for capture
					player:AddFortPoints(FORTPOINTS_PER_CAPTURE, "#FF_FORTPOINTS_CAPTUREFLAG")
					

					
					-- reward player's team for capture
					local team = player:GetTeam()
					team:AddScore(POINTS_PER_CAPTURE)
					-- log action in stats
					--player:AddAction(nil, "ctf_flag_cap", flag:GetName())
          LogLuaEvent(player:GetId(), 0, "flag_capture","flag_name",flag:GetName())	
					
					-- clear the objective icon
					UpdateObjectiveIcon( player, nil )
							
					-- Remove any hud icons
					-- local flag2 = CastToInfoScript(flag)
					RemoveHudItem( player, flag:GetName() )
					RemoveHudItemFromAll( flag:GetName() .. "_c" )
					RemoveHudItemFromAll( flag:GetName() .. "_d" )

					-- return the flag
					flag:Return()
				
					-- give player some health and armor
					if self.health ~= nil and self.health ~= 0 then player:AddHealth(self.health) end
					if self.armor ~= nil and self.armor ~= 0 then player:AddArmor(self.armor) end
	
					-- give the player some ammo
					if self.nails ~= nil and self.nails ~= 0 then player:AddAmmo(Ammo.kNails, self.nails) end
					if self.shells ~= nil and self.shells ~= 0 then player:AddAmmo(Ammo.kShells, self.shells) end
					if self.rockets ~= nil and self.rockets ~= 0 then player:AddAmmo(Ammo.kRockets, self.rockets) end
					if self.cells ~= nil and self.cells ~= 0 then player:AddAmmo(Ammo.kCells, self.cells) end
					if self.detpacks ~= nil and self.detpacks ~= 0 then player:AddAmmo(Ammo.kDetpack, self.detpacks) end
					if self.mancannons ~= nil and self.mancannons ~= 0 then player:AddAmmo(Ammo.kManCannon, self.mancannons) end
					if self.gren1 ~= nil and self.gren1 ~= 0 then player:AddAmmo(Ammo.kGren1, self.gren1) end
					if self.gren2 ~= nil and self.gren2 ~= 0 then player:AddAmmo(Ammo.kGren2, self.gren2) end
	
					self:oncapture( player, v )
				end
			end
		end
	end
end

function argoncap:oncapture(player, item)
	-- let the teams know that a capture occured
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
	SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")
end
	function addpoints()
	local team = GetTeam(red)
	team:AddScore(POINTS_PER_PERIOD)
end
-- red cap point
red_cap = argoncap:new({team = Team.kRed,
					   item = {"blue_flag","yellow_flag","green_flag"}})

-- blue cap point					   
blue_cap = argoncap:new({team = Team.kBlue,
						item = {"red_flag","yellow_flag","green_flag"}})

-- yellow cap point						
yellow_cap = argoncap:new({team = Team.kYellow,
						item = {"blue_flag","red_flag","green_flag"}})

-- green cap point						
green_cap = argoncap:new({team = Team.kGreen,
						item = {"blue_flag","red_flag","yellow_flag"}})	