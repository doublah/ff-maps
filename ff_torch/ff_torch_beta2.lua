IncludeScript("base_location");
IncludeScript("base_respawnturret");


-- base_teamplay.lua

-----------------------------------------------------------------------------
-- base_teamplay handles stuff for "normal" maps so this stuff doesn't need
-- to be replicated all over the place (like standard teamspawns,
-- doors, bags, and such)
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------
if POINTS_PER_CAPTURE == nil then POINTS_PER_CAPTURE = 10; end
if FORTPOINTS_PER_CAPTURE == nil then FORTPOINTS_PER_CAPTURE = 1000; end
if FORTPOINTS_PER_INITIALTOUCH == nil then FORTPOINTS_PER_INITIALTOUCH = 100; end
if FLAG_RETURN_TIME == nil then FLAG_RETURN_TIME = 60; end 
if FLAG_THROW_SPEED == nil then FLAG_THROW_SPEED = 330; end

redallowedmethod = function(self,player) return player:GetTeamId() == Team.kRed end
blueallowedmethod = function(self,player) return player:GetTeamId() == Team.kBlue end
yellowallowedmethod = function(self,player) return player:GetTeamId() == Team.kYellow end
greenallowedmethod = function(self,player) return player:GetTeamId() == Team.kGreen end

-- things for flags
teamskins = {}
teamskins[Team.kBlue] 	= 0
teamskins[Team.kRed] 	= 1
teamskins[Team.kYellow] = 2
teamskins[Team.kGreen] 	= 3

team_hudicons = {}
team_hudicons[Team.kBlue] 	= "hud_flag_blue.vtf"
team_hudicons[Team.kRed] 	= "hud_flag_red.vtf"
team_hudicons[Team.kGreen] 	= "hud_flag_green.vtf"
team_hudicons[Team.kYellow] = "hud_flag_yellow.vtf"

-----------------------------------------------------------------------------
-- Player spawn: give full health, armor, and ammo
-----------------------------------------------------------------------------
function player_spawn( player_entity ) 
   local player = CastToPlayer( player_entity ) 

   player:AddHealth( 400 ) 
   player:AddArmor( 400 ) 

   player:AddAmmo( Ammo.kNails, 400 ) 
   player:AddAmmo( Ammo.kShells, 400 ) 
   player:AddAmmo( Ammo.kRockets, 400 ) 
   player:AddAmmo( Ammo.kCells, 400 ) 
end

-----------------------------------------------------------------------------
-- No builds: area where you can't build
-----------------------------------------------------------------------------
nobuild = trigger_ff_script:new({})

function nobuild:onbuild( build_entity )	
	return EVENT_DISALLOWED 
end

no_build = nobuild

-----------------------------------------------------------------------------
-- No grens: area where grens won't explode
-----------------------------------------------------------------------------
nogrens = trigger_ff_script:new({})

function nogrens:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

no_grens = nogrens

-----------------------------------------------------------------------------
-- No Fucking Annoyances
-----------------------------------------------------------------------------
noannoyances = trigger_ff_script:new({})

function noannoyances:onbuild( build_entity )
	return EVENT_DISALLOWED 
end

function noannoyances:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

function noannoyances:oninfect( infect_entity )
	return EVENT_DISALLOWED 
end

no_annoyances = noannoyances
spawn_protection = noannoyances

-----------------------------------------------------------------------------
-- Generic Backpack
-----------------------------------------------------------------------------
genericbackpack = info_ff_script:new({
	health = 0,
	armor = 0,
	grenades = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 0,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function genericbackpack:dropatspawn() return true end

function genericbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function genericbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
	
		-- give player some health and armor
		if self.health ~= nil and self.health ~= 0 then dispensed = dispensed + player:AddHealth( self.health ) end
		if self.armor ~= nil and self.armor ~= 0 then dispensed = dispensed + player:AddArmor( self.armor ) end
	
		-- give player ammo
		if self.nails ~= nil and self.nails ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails) end
		if self.shells ~= nil and self.shells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells) end
		if self.rockets ~= nil and self.rockets ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets) end
		if self.cells ~= nil and self.cells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells) end
		if self.detpacks ~= nil and self.detpacks ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kDetpack, self.detpacks) end
		if self.mancannons ~= nil and self.mancannons ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kManCannon, self.mancannons) end
		if self.gren1 ~= nil and self.gren1 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren1) end
		if self.gren2 ~= nil and self.gren2 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end
	
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if backpack then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function genericbackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

-----------------------------------------------------------------------------
-- Health Kit (backpack-based)
-----------------------------------------------------------------------------
healthkit = genericbackpack:new({
	health = 25,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	respawntime = 20,
	touchsound = "HealthKit.Touch",
	botgoaltype = Bot.kBackPack_Health
})

-----------------------------------------------------------------------------
-- Armor Kit (backpack-based)
-----------------------------------------------------------------------------
armorkit = genericbackpack:new({
	armor = 200,
	cells = 150,					-- mirv: armour in 2fort/rock2/etc gives 150 cells too
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",
	botgoaltype = Bot.kBackPack_Armor
})

function armorkit:dropatspawn() return true end

-----------------------------------------------------------------------------
-- Ammo Kit (backpack-based)
-----------------------------------------------------------------------------
ammobackpack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function ammobackpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- bigpack -- has a bit of everything (excluding grens) (backpack-based)
-----------------------------------------------------------------------------
bigpack = genericbackpack:new({
	health = 150,
	armor = 200,
	grenades = 50,
	nails = 150,
	shells = 200,
	rockets = 100,
	cells = 200,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function bigpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Grenade Backpack
-----------------------------------------------------------------------------
grenadebackpack = genericbackpack:new({
	mancannons = 1,
	gren1 = 2,
	gren2 = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})

function grenadebackpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Door Triggers
-----------------------------------------------------------------------------
respawndoor = trigger_ff_script:new({ team = Team.kUnassigned, allowdisguised=false })

function respawndoor:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		
		local player = CastToPlayer( allowed_entity )
		
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
		
		if self.allowdisguised then
			if player:IsDisguised() and player:GetDisguisedTeam() == self.team then
				return EVENT_ALLOWED
			end
		end
	end
	return EVENT_DISALLOWED
end

function respawndoor:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDDOOR" )
	end
end

bluerespawndoor = respawndoor:new({ team = Team.kBlue })
redrespawndoor = respawndoor:new({ team = Team.kRed })
greenrespawndoor = respawndoor:new({ team = Team.kGreen })
yellowrespawndoor = respawndoor:new({ team = Team.kYellow })

-----------------------------------------------------------------------------
-- Elevator Triggers
-----------------------------------------------------------------------------

elevator_trigger = respawndoor:new( {} )

function elevator_trigger:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		BroadCastMessageToPlayer( player, "#FF_NOTALLOWEDELEVATOR" )
	end
end

blue_elevator_trigger 	= elevator_trigger:new({ team = Team.kBlue })
red_elevator_trigger 	= elevator_trigger:new({ team = Team.kRed })
green_elevator_trigger 	= elevator_trigger:new({ team = Team.kGreen })
yellow_elevator_trigger	= elevator_trigger:new({ team = Team.kYellow })

-----------------------------------------------------------------------------
-- Spawn functions
-----------------------------------------------------------------------------
redspawn = { validspawn = redallowedmethod }
bluespawn = { validspawn = blueallowedmethod }
greenspawn = { validspawn = greenallowedmethod }
yellowspawn = { validspawn = yellowallowedmethod }

-- aliases for people that like underscores
red_spawn = redspawn; blue_spawn = bluespawn;
green_spawn = greenspawn; yellow_spawn = yellowspawn
blue_respawndoor = bluerespawndoor; red_respawndoor = redrespawndoor;
green_respawndoor = greenrespawndoor; yellow_respawndoor = yellowrespawndoor

-----------------------------------------------------------------------------
-- Capture Points
-----------------------------------------------------------------------------
basecap = trigger_ff_script:new({
	health = 0,
	armor = 0,
	grenades = 200,
	shells = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 0,
	mancannons = 1,
	gren1 = 0,
	gren2 = 0,
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

bluerspawn = info_ff_script:new()

function basecap:allowed ( allowed_entity )
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

function basecap:ontrigger ( trigger_entity )
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

function basecap:oncapture(player, item)
	-- let the teams know that a capture occured
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
	SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")
end

-----------------------------------------------------------------------------
-- Flag
-- status: 0 = home, 1 = carried, 2 = dropped
-----------------------------------------------------------------------------
baseflag = info_ff_script:new({
	name = "base flag",
	team = 0,
	model = "models/flag/flag.mdl",
	tosssound = "Flag.Toss",
	modelskin = 1,
	dropnotouchtime = 2,
	capnotouchtime = 2,
	botgoaltype = Bot.kFlag,
	status = 0,
	hudicon = "",
	hudx = 5,
	hudy = 114,
	hudalign = 1,
	hudstatusiconalign = 2,
	hudstatusicon = "",
	hudstatusiconx = 0,
	hudstatusicony = 0,
	hudstatusiconw = 50,
	hudstatusiconh = 50,
	allowdrop = true,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function baseflag:precache()
	PrecacheSound(self.tosssound)
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	info_ff_script.precache(self)
end

function baseflag:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
	local flag = CastToInfoScript( entity )
	LogLuaEvent(0, 0, "flag_spawn","flag_name",flag:GetName())
	AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	self.status = 0
end

function baseflag:addnotouch(player_id, duration)
	self.notouch[player_id] = duration
	AddSchedule(self.name .. "-" .. player_id, duration, self.removenotouch, self, player_id)
end

function baseflag.removenotouch(self, player_id)
	self.notouch[player_id] = nil
end

function baseflag:touch( touch_entity )
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
		UpdateObjectiveIcon( player, GetEntityByName( team.."_cap" ) )

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
	end
end

function baseflag:onownerdie( owner_entity )
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

	-- log action in stats
	-- player:AddAction(nil, "ctf_flag_died", flag:GetName())
	LogLuaEvent(player:GetId(), 0, "flag_dropped", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ));	
	
	
end

function baseflag:ownercloak( owner_entity )
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
end

function baseflag:dropitemcmd( owner_entity )

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
end	

function baseflag:ondrop( owner_entity )
	local player = CastToPlayer( owner_entity )
	-- let the teams know that the flag was dropped
	SmartSound(player, "yourteam.drop", "yourteam.drop", "otherteam.drop")
	SmartMessage(player, "#FF_YOUDROP", "#FF_TEAMDROP", "#FF_OTHERTEAMDROP")
	
	local flag = CastToInfoScript(entity)
	flag:EmitSound(self.tosssound)
end

function baseflag:onloseitem( owner_entity )
	-- let the player that lost the flag put on a disguise
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable(true)
	-- let player cloak if he can
	player:SetCloakable( true )

	self:addnotouch(player:GetId(), self.capnotouchtime)
end

function baseflag:onownerforcerespawn( owner_entity )
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
end

function baseflag:onreturn( )
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
end

function baseflag:hasanimation() return true end

-----------------------------------------------------------------------------
-- Detable triggers.  Use this to make triggers that respond to a detpack explosion.
-----------------------------------------------------------------------------

detpack_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function detpack_trigger:onexplode( explosion_entity )
   if IsDetpack( explosion_entity ) then
      local detpack = CastToDetpack( explosion_entity )

      if detpack:GetTeamId() ~= self.team then
         -- Generic 'trigger' output for use with logic_ entities.
         OutputEvent( self.team_name .. "_det_relay", "trigger" )
      end
   end

   return EVENT_ALLOWED
end

red_detpack_trigger = detpack_trigger:new({ team = Team.kRed, team_name = "red" })
blue_detpack_trigger = detpack_trigger:new({ team = Team.kBlue, team_name = "blue" })
green_detpack_trigger = detpack_trigger:new({ team = Team.kGreen, team_name = "green" })
yellow_detpack_trigger = detpack_trigger:new({ team = Team.kYellow, team_name = "yellow" })

-----------------------------------------------------------------------------
-- backpack entity setup
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})




-----------------------------------------------------------------------------
-- entities
-----------------------------------------------------------------------------

-- hudalign and hudstatusiconalign : 0 = HUD_LEFT, 1 = HUD_RIGHT, 2 = HUD_CENTERLEFT, 3 = HUD_CENTERRIGHT 
-- (pixels from the left / right of the screen / left of the center of the screen / right of center of screen,
-- AfterShock
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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed,AllowFlags.kYellow,AllowFlags.kGreen}})

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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kYellow,AllowFlags.kGreen}})
						  
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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kGreen} })

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
						 objectiveicon = true,
						 touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue,AllowFlags.kRed,AllowFlags.kYellow} })						  

-- red cap point
red_cap = basecap:new({team = Team.kRed,
					   item = {"blue_flag","yellow_flag","green_flag"}})

-- blue cap point					   
blue_cap = basecap:new({team = Team.kBlue,
						item = {"red_flag","yellow_flag","green_flag"}})

-- yellow cap point						
yellow_cap = basecap:new({team = Team.kYellow,
						item = {"blue_flag","red_flag","green_flag"}})

-- green cap point						
green_cap = basecap:new({team = Team.kGreen,
						item = {"blue_flag","red_flag","yellow_flag"}})

-----------------------------------------------------------------------------
-- map handlers
-----------------------------------------------------------------------------
function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end

function precache()
	-- precache sounds
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
end

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	local flag = GetInfoScriptByName("blue_flag")
	local flagname = flag:GetName()
	
	RemoveHudItem( player, flagname .. "_c" )
	RemoveHudItem( player, flagname.. "_d" )
	RemoveHudItem( player, flagname .. "_h" )

	if flag:IsCarried() then
			AddHudIcon( player, blue_flag.hudstatusiconcarried, ( flagname .. "_c" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, blue_flag.hudstatusicondropped, ( flagname .. "_d" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )
	else
		AddHudIcon( player, blue_flag.hudstatusiconhome, ( flagname .. "_h" ), blue_flag.hudstatusiconx, blue_flag.hudstatusicony, blue_flag.hudstatusiconw, blue_flag.hudstatusiconh, blue_flag.hudstatusiconalign )	
	end

	flag = GetInfoScriptByName("red_flag")
	flagname = flag:GetName()
	
	RemoveHudItem( player, flagname .. "_c" )
	RemoveHudItem( player, flagname.. "_d" )
	RemoveHudItem( player, flagname .. "_h" )

	if flag:IsCarried() then
			AddHudIcon( player, red_flag.hudstatusiconcarried, ( flagname .. "_c" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	elseif flag:IsDropped() then
			AddHudIcon( player, red_flag.hudstatusicondropped, ( flagname .. "_d" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )
	else
			AddHudIcon( player, red_flag.hudstatusiconhome, ( flagname .. "_h" ), red_flag.hudstatusiconx, red_flag.hudstatusicony, red_flag.hudstatusiconw, red_flag.hudstatusiconh, red_flag.hudstatusiconalign )	
	end
end


-----------------------------------------------------------------------------
-- CAP POINT SPECIAL TRIGGERS
-----------------------------------------------------------------------------


my_cap = basecap:new({})

function my_cap:oncapture(player, item)
    if player:GetTeamId() == Team.kBlue then
    OutputEvent( "blue_cap_sound", "PlaySound" )
    OutputEvent( "blue_cap_shake", "StartShake" )
    OutputEvent( "blue_cap_splash", "Splash" )
    OutputEvent( "blue_cap_fire", "StartFire" )
    OutputEvent( "blue_cap_fire", "disable", "", 0.3 )
    OutputEvent( "blue_cap_fire", "enable", "", 1 )
    elseif player:GetTeamId() == Team.kRed then
    OutputEvent( "red_cap_sound", "PlaySound" )
    OutputEvent( "red_cap_shake", "StartShake" )
    OutputEvent( "red_cap_splash", "Splash" )
    OutputEvent( "red_cap_fire", "StartFire" )
    OutputEvent( "red_cap_fire", "disable", "", 0.3 )
    OutputEvent( "red_cap_fire", "enable", "", 1 )
    end


    -- let the teams know that a capture occured
    SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
    SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
    SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP")

end

my_cap_red = my_cap:new({team = Team.kRed,
			 item = {"blue_flag","yellow_flag","green_flag"}})

my_cap_blue = my_cap:new({team = Team.kBlue,
			  item = {"red_flag","yellow_flag","green_flag"}})

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------



blue_location_spawn 	= location_info:new({ text = "Blue Spawn", team = Team.kBlue })
blue_location_fr 	= location_info:new({ text = "Blue Flagroom", team = Team.kBlue })
blue_location_bats 	= location_info:new({ text = "Blue Battlements", team = Team.kBlue })
blue_location_fd 	= location_info:new({ text = "Blue Frontdoor", team = Team.kBlue })
blue_location_resup	= location_info:new({ text = "Blue Resupply", team = Team.kBlue })
neutral_location_yard	= location_info:new({ text = "Yard", team = Team.kUnassigned })
red_location_spawn	= location_info:new({ text = "Red Spawn", team = Team.kRed })
red_location_fr		= location_info:new({ text = "Red Flagroom", team = Team.kRed })
red_location_bats	= location_info:new({ text = "Red Battlements", team = Team.kRed })
red_location_fd		= location_info:new({ text = "Red Frontdoor", team = Team.kRed })
red_location_resup	= location_info:new({ text = "Red Resupply", team = Team.kRed })




