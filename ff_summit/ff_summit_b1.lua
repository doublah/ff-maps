IncludeScript("base_hunted");
IncludeScript("base_respawnturret");

function startup()
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 1)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, -1)

	local team = GetTeam( Team.kBlue )
	team:SetAllies( Team.kRed )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, 0 )

	team = GetTeam( Team.kRed )
	team:SetAllies( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, 0 )
	team:SetClassLimit( Player.kDemoman, 0 )
	team:SetClassLimit( Player.kMedic, 0 )
	team:SetClassLimit( Player.kHwguy, 0 )
	team:SetClassLimit( Player.kPyro, 0 )
	team:SetClassLimit( Player.kSpy, 0 )
	team:SetClassLimit( Player.kEngineer, 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	team = GetTeam( Team.kYellow )
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, 1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, 1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, 1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )
end

door_tunnel = yellowrespawndoor
door_bunker = yellowrespawndoor

function flaginfo( player_entity )
	--don't do nothing
end

detpack_trigger = trigger_ff_script:new({ team = Team.kRed  })

function detpack_trigger:onexplode( explosion_entity )
	ConsoleToAll("onexplode")
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )
		if detpack:GetTeamId() ~= self.team then
			OutputEvent( "detpack_relay", "Trigger" )
			BroadCastMessage("Yellow team blew up the barn!")
		end
	end

	return EVENT_ALLOWED
end

function player_ondamage( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end

	local attacker = damageinfo:GetAttacker()
	local inflictor = damageinfo:GetInflictor()

	-- taking out the hunted damage rules for beta purposes.

	if IsPlayer( attacker ) then

		attacker = CastToPlayer( attacker )

		if attacker:GetTeamId() == Team.kBlue and player:GetTeamId() ~= HUNTED_ALLIES_TEAM then

			damageinfo:ScaleDamage(4)
			attacker:AddFortPoints( POINTS_PER_HUNTED_ATTACK * 10, "Hunted Attack" )
			--ConsoleToAll( "The Hunted, " .. attacker:GetName() .. ", dealt quad damage to" .. player:GetName() .. "!" )

		end

	end

end

--I want to limit ammo count for sins
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	
	if player:GetTeamId() == Team.kYellow then

        	player:RemoveAmmo( Ammo.kShells, 300 )
        	player:AddAmmo( Ammo.kShells, 30 )   

        	player:RemoveAmmo( Ammo.kRockets, 300 )
        	player:AddAmmo( Ammo.kRockets, 16 ) 

		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:RemoveAmmo( Ammo.kGren2, 4 )
	end       
end

-----------
--locations
-----------

loc_svalley = location_info:new({ text = "Southern Valley", team = NO_TEAM })
loc_nvalley = location_info:new({ text = "Northern Valley", team = NO_TEAM })
loc_field = location_info:new({ text = "Extraction Point", team = NO_TEAM })
loc_assbunker = location_info:new({ text = "Assassin Tunnels", team = Team.kYellow })
loc_tunnel = location_info:new({ text = "Highway Tunnel", team = NO_TEAM })
loc_house = location_info:new({ text = "Farmhouse", team = NO_TEAM })
loc_barn = location_info:new({ text = "Barn", team = NO_TEAM })
loc_hill = location_info:new({ text = "Forest Slope", team = NO_TEAM })
loc_epass = location_info:new({ text = "Eastern Pass", team = NO_TEAM })
loc_cave = location_info:new({ text = "The Cave", team = NO_TEAM })