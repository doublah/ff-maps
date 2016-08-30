IncludeScript("base_location");
IncludeScript("base_ctf");
IncludeScript("base_conc");

location_1 = location_info:new({text = "Jump 1", team = NO_TEAM})
location_2 = location_info:new({text = "Jump 2", team = NO_TEAM})
location_3 = location_info:new({text = "Jump 3", team = NO_TEAM})
location_4 = location_info:new({text = "Jump 4", team = NO_TEAM})
location_5 = location_info:new({text = "Jump 5", team = NO_TEAM})
location_6 = location_info:new({text = "Bonus A", team = NO_TEAM})
location_7 = location_info:new({text = "Bonus B", team = NO_TEAM})
location_capture = location_info:new({text = "Capture Point", team = NO_TEAM})
location_flag = location_info:new({text = "Flag Area", team = NO_TEAM})


-- base_conc.lua - Created By: OneEyed
-- Version 1.1

---------------------------------
-- DEFAULTS (CHANGEABLE)
---------------------------------

-- Disable/Enable Concussion Effect.
CONC_EFFECT = 0

-- Freestyle / Race modes.
CONC_MODE = CONC_FREESTYLE

-- Race Restart Delay
RESTART_DELAY = 10

-- Points and Frags you receive for touching EndZone.
CONC_POINTS = 110
CONC_FRAGS = 10

-- Disable/Enable classes allowed.
SOLDIER = 0
SCOUT = 1
MEDIC = 1
DEMOMAN = 0
ENGINEER = 0
PYRO = 0

-- Disable/Enable Invunerability
INVUL = 1


---------------------------------
-- DO NOT CHANGE THESE
---------------------------------
reached_end = 0
CONC_FREESTYLE = 0
CONC_RACE = 1
---------------------------------


function startup()

	SetTeamName( Team.kBlue, "Blue Team" )
	SetTeamName( Team.kRed, "Red Team" )

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
	
	ShouldEnableClass( team, SCOUT, Player.kScout )
	ShouldEnableClass( team, MEDIC, Player.kMedic )
	ShouldEnableClass( team, SOLDIER, Player.kSoldier )
	ShouldEnableClass( team, DEMOMAN, Player.kDemoman )
	ShouldEnableClass( team, PYRO, Player.kPyro )
	ShouldEnableClass( team, ENGINEER, Player.kEngineer )
	
	
	-- RED TEAM
	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	
	ShouldEnableClass( team, SCOUT, Player.kScout )
	ShouldEnableClass( team, MEDIC, Player.kMedic )
	ShouldEnableClass( team, SOLDIER, Player.kSoldier )
	ShouldEnableClass( team, DEMOMAN, Player.kDemoman )
	ShouldEnableClass( team, PYRO, Player.kPyro )
	ShouldEnableClass( team, ENGINEER, Player.kEngineer )
	
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end

function ShouldEnableClass( team, classtype, class )
	if classtype == 1 then
		team:SetClassLimit( class, 0 )
	else
		team:SetClassLimit( class, -1 )
	end
end


-----------------------------------------------------------------------------
-- Invul Check
-----------------------------------------------------------------------------
function player_ondamage( player, damageinfo )
	
	if INVUL == 1 then
		player:AddHealth( 400 )
		player:AddArmor( 400 )
	end
end


-----------------------------------------------------------------------------
-- Concussion Check
-----------------------------------------------------------------------------
function player_onconc( player_entity, concer_entity )

	if CONC_EFFECT == 0 then
		return EVENT_DISALLOWED
	end

	return EVENT_ALLOWED
end


-----------------------------------------------------------------------------
-- Ammo Check
-----------------------------------------------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )
	
	class = player:GetClass()
	if class == Player.kSoldier or class == Player.kDemoman then
		player:AddAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kGren2, -4 )
	else
		player:AddAmmo( Ammo.kGren1, -4 )
		player:AddAmmo( Ammo.kGren2, 4 )
	end

	-- Add items (similar to both teams)
	player:AddAmmo( Ammo.kShells, 200 )
	player:AddAmmo( Ammo.kRockets, 30 )
	player:AddAmmo( Ammo.kNails, 200 )

end


-----------------------------------------------------------------------------
-- Precache Sounds
-----------------------------------------------------------------------------

function precache()
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("misc.doop")
end


-----------------------------------------------------------------------------
-- Conc Backpack
-----------------------------------------------------------------------------

concbackpack = info_ff_script:new({
	health = 200,
	armor = 200,
	rockets = 50,
	gren = 4,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function concbackpack:dropatspawn() return true end

function concbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

function concbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
		
		-- give player some health and armor
		dispensed = dispensed + player:AddHealth( self.health )
		dispensed = dispensed + player:AddArmor( self.armor )
		dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets)
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren)
		else
			dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren)
		end
		
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if (backpack ~= nil) then
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function concbackpack:materialize( )
	entity:EmitSound(self.materializesound)
end


-----------------------------------------------------------------------------
-- Health Backpack
-----------------------------------------------------------------------------

healthbackpack = concbackpack:new({
	health = 200,
	armor = 200,
	rockets = 0,
	gren = 0,
	respawntime = 5,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",	
	touchsound = "ArmorKit.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})


-----------------------------------------------------------------------------
-- End Zone Entity
-----------------------------------------------------------------------------

endzone = trigger_ff_script:new()

function endzone:ontouch( touch_entity )

	if CONC_MODE == CONC_RACE then
		if reached_end == 0 and IsPlayer( touch_entity ) then
			local player = CastToPlayer( touch_entity )

			ConsoleToAll( player:GetName() .. " reached the endzone!" )
			BroadCastMessage( player:GetName() .. " reached the endzone!" )
		
			SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "yourteam.flagcap")
			
			player:AddFrags( CONC_FRAGS )
			player:AddFortPoints( CONC_POINTS, "Reached Endzone" )
			reached_end = 1
			
			AddSchedule( "RestartRace", RESTART_DELAY, RestartRace )
		end
	else
		if IsPlayer( touch_entity ) then
			local player = CastToPlayer( touch_entity )
		
			SmartSound(player, "misc.doop", "", "")
			
			player:AddFrags( CONC_FRAGS )
			player:AddFortPoints( CONC_POINTS, "Reached Endzone" )
			
			RestartPlayer( player )
		end
	end
end

function RestartRace()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens })
	reached_end = 0
end

function RestartPlayer( player )
	ApplyToPlayer( player, { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens })
end


-----------------------------------------------------------------------------
-- Conc Trigger (Gives Ammo, Grenades, HP and ARMOR)
-----------------------------------------------------------------------------

trigger_conc = trigger_ff_script:new({})

function trigger_conc:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		class = player:GetClass()
		if class == Player.kSoldier or class == Player.kDemoman then
			player:AddAmmo(Ammo.kGren1, self.gren)
		else
			player:AddAmmo(Ammo.kGren2, self.gren)
		end
		player:AddHealth( 400 )
		player:AddArmor( 400 )
	end
end