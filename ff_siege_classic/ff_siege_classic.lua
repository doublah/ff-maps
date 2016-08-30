
IncludeScript("base_ctf")
IncludeScript("base_location")

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_yard = location_info:new({ text = "Yard", team = Team.kUnassigned })
-----------------------------------------------------------------------------
-- Blue
-----------------------------------------------------------------------------
location_blue_bments = location_info:new({ text = "Battlements", team = Team.kBlue })
location_blue_upper_spawn = location_info:new({ text = "Upper Spawn", team = Team.kBlue })
location_blue_lower_spawn = location_info:new({ text = "Lower Spawn", team = Team.kBlue })
location_blue_vent = location_info:new({ text = "Air Vent", team = Team.kBlue })
location_blue_fd = location_info:new({ text = "Front Door", team = Team.kBlue })
location_blue_fr = location_info:new({ text = "Flagroom", team = Team.kBlue })
location_blue_water = location_info:new({ text = "Water", team = Team.kBlue })
location_blue_rr = location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_blue_hall = location_info:new({ text = "Hall", team = Team.kBlue })
location_blue_ramp = location_info:new({ text = "Ramp", team = Team.kBlue })
-----------------------------------------------------------------------------
-- Red
-----------------------------------------------------------------------------
location_red_bments = location_info:new({ text = "Battlements", team = Team.kRed })
location_red_upper_spawn = location_info:new({ text = "Upper Spawn", team = Team.kRed })
location_red_lower_spawn = location_info:new({ text = "Lower Spawn", team = Team.kRed })
location_red_vent = location_info:new({ text = "Air Vent", team = Team.kRed })
location_red_fd = location_info:new({ text = "Front Door", team = Team.kRed })
location_red_fr = location_info:new({ text = "Flagroom", team = Team.kRed })
location_red_water = location_info:new({ text = "Water", team = Team.kRed })
location_red_rr = location_info:new({ text = "Ramp Room", team = Team.kRed })
location_red_hall = location_info:new({ text = "Hall", team = Team.kRed })
location_red_ramp = location_info:new({ text = "Ramp", team = Team.kRed })

-----------------------------------------------------------------------------
-- Team Only Doors (renamed)
-----------------------------------------------------------------------------
blue_only = bluerespawndoor
red_only = redrespawndoor

---------------------------------
-- Packs
---------------------------------

rr_pack = genericbackpack:new({
	grenades = 200,
	bullets = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	gren1 = 2,
	gren2 = 1,
	cells = 0,
    respawntime = 25,
	health = 45,
	armor = 50,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen},
	botgoaltype = Bot.kBackPack_Ammo
})

flagroom_pack = genericbackpack:new({
	grenades = 200,
	bullets = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	gren1 = 0,
	gren2 = 0,
	cells = 100,
    respawntime = 20,
	health = 45,
	armor = 50,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen},
	botgoaltype = Bot.kBackPack_Ammo
})

function build_backpacks(tf)
	return flagroom_pack:new({touchflags = tf}),
		   rr_pack:new({touchflags = tf})
end

blue_flagroom_pack, blue_rr_pack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_flagroom_pack, red_rr_pack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})

---------------------------------
-- Resupply
---------------------------------

refill = trigger_ff_script:new({ team = Team.kUnassigned })

function refill:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
			
			OutputEvent( self.entity, "PlaySound" )
			BroadCastMessageToPlayer( player, "Ooooh, my pancreas" )
		end
	end
end

blue_up_refill = refill:new({ team = Team.kBlue, entity = "bus_sound" })
red_up_refill = refill:new({ team = Team.kRed, entity = "rus_sound" })
blue_low_refill = refill:new({ team = Team.kBlue, entity = "bls_sound" })
red_low_refill = refill:new({ team = Team.kRed, entity = "rls_sound" })