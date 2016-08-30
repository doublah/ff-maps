
IncludeScript("base_ctf")
IncludeScript("base_location")

FLAG_RETURN_TIME = 45

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_yard = location_info:new({ text = "Yard", team = Team.kUnassigned })
-----------------------------------------------------------------------------
-- Blue
-----------------------------------------------------------------------------
location_blue_bments = location_info:new({ text = "Battlements", team = Team.kBlue })
location_blue_bmentshall = location_info:new({ text = "Battlements Hallway", team = Team.kBlue })
location_blue_spawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_blue_spawnhall = location_info:new({ text = "Respawn Hall", team = Team.kBlue })
location_blue_fd = location_info:new({ text = "Front Entrance", team = Team.kBlue })
location_blue_fr = location_info:new({ text = "Flagroom", team = Team.kBlue })
location_blue_water = location_info:new({ text = "Water", team = Team.kBlue })
-----------------------------------------------------------------------------
-- Red
-----------------------------------------------------------------------------
location_red_bments = location_info:new({ text = "Battlements", team = Team.kRed })
location_red_bmentshall = location_info:new({ text = "Battlements Hallway", team = Team.kRed })
location_red_spawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_red_spawnhall = location_info:new({ text = "Respawn Hall", team = Team.kRed })
location_red_fd = location_info:new({ text = "Front Entrance", team = Team.kRed })
location_red_fr = location_info:new({ text = "Flagroom", team = Team.kRed })
location_red_water = location_info:new({ text = "Water", team = Team.kRed })

-----------------------------------------------------------------------------
-- FD Buttons
-----------------------------------------------------------------------------

red_fd1_btn = func_button:new({})
function red_fd1_btn:ondamage() OutputEvent( "red_fd1", "Open" ) end
red_fd2_btn = func_button:new({})
function red_fd2_btn:ondamage() OutputEvent( "red_fd2", "Open" ) end
blue_fd1_btn = func_button:new({})
function blue_fd1_btn:ondamage() OutputEvent( "blue_fd1", "Open" ) end
blue_fd2_btn = func_button:new({})
function blue_fd2_btn:ondamage() OutputEvent( "blue_fd2", "Open" ) end

-----------------------------------------------------------------------------
-- Grates
-----------------------------------------------------------------------------

base_grate_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		if detpack:GetTeamId() ~= self.team then
			OutputEvent( self.team_name .. "_grate", "Break" )
			OutputEvent( self.team_name .. "_grate_wall", "Kill" )
            BroadCastMessage( self.message ) 
		end
	end

	-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
	return EVENT_ALLOWED
end

red_grate_trigger = base_grate_trigger:new({ team = Team.kRed, team_name = "red", message = "Red grate has been destroyed!" })
blue_grate_trigger = base_grate_trigger:new({ team = Team.kBlue, team_name = "blue", message = "Blue grate has been destroyed!" })

-----------------------------------------------------------------------------
-- Edge of the Map Remove
-----------------------------------------------------------------------------

map_edge = trigger_ff_script:new({ })

function map_edge:allowed(allowed_entity)
	if IsPlayer(allowed_entity) then
		return false
	end
	return true
end

-----------------------------------------------------------------------------
-- Team Only Doors (renamed)
-----------------------------------------------------------------------------

blue_only = bluerespawndoor
red_only = redrespawndoor


---------------------------------
-- Packs
---------------------------------

blue_health = blue_healthkit
blue_armor = blue_armorkit:new({ modelskin = 0 })
blue_ammo = blue_ammobackpack
blue_nades = blue_grenadebackpack
blue_bmentsarmor = armorkit:new({ modelskin = 0 })
blue_bmentshealth = healthkit
red_health = red_healthkit
red_armor = red_armorkit:new({ modelskin = 1 })
red_ammo = red_ammobackpack
red_nades = red_grenadebackpack
red_bmentsarmor = armorkit:new({ modelskin = 1 })
red_bmentshealth = healthkit

bmentsnades = genericbackpack:new({
	grenades = 20,
	bullets = 50,
	nails = 50,
	shells = 50,
	rockets = 20,
	gren1 = 1,
	gren2 = 1,
	cells = 50,
    respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen},
	botgoaltype = Bot.kBackPack_Ammo
})

red_bmentsnades = bmentsnades:new({ })
blue_bmentsnades = bmentsnades:new({ })