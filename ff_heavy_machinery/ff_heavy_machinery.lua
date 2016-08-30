-- ff_heavy-machinery.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_machine");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_RUNNERS_ESCAPE_FOR_RUNNERS = 40
POINTS_PER_RUNNERS_ESCAPE = 30
POINTS_PER_OPERATORS_RUNNERS_SUICIDE_FOR_OPERATORS = 5









function startup()

 

	-- set up team names
	SetTeamName( Team.kBlue, "OPERATORS" )
	SetTeamName( Team.kRed, "NONE" )
	SetTeamName( Team.kYellow, "RUNNERS" )
	SetTeamName( Team.kGreen, "NONE" )

	-- set up team limits
	SetPlayerLimit( Team.kBlue, 5 ) -- THE OPERATORS!DISTROY THE RUNNERS
	SetPlayerLimit( Team.kRed, -1 ) -- NONE.
	SetPlayerLimit( Team.kYellow, 0 ) -- THE RUNNERS.RUN LIKE HELL
	SetPlayerLimit( Team.kGreen, -1 ) -- NONE.

	team = GetTeam( Team.kBlue )
	team:SetClassLimit( Player.kScout, 0 )
	team:SetClassLimit( Player.kSniper, -1 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

	

	team = GetTeam( Team.kYellow )
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


end




-- escape portal entrance
runners_escape = trigger_ff_script:new({ })

-- escape touch
function runners_escape:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kYellow then
			player:AddFrags( POINTS_PER_RUNNERS_ESCAPE_FOR_RUNNERS )
			ConsoleToAll( player:GetName() .. " escaped!" )
			BroadCastMessage( "The Runner ESCAPED!---->" .. player:GetName() .. "!" )
			player:AddHealth( 75 )
                        
			local team = GetTeam( Team.kYellow )
			team:AddScore( POINTS_PER_RUNNERS_ESCAPE )

		end
	end

end


function precache()
	-- precache sounds
	PrecacheSound("yourteam.w00t")
end




-- runners water damage
water_damage = trigger_ff_script:new({ })

-- suicide touch
function water_damage:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kYellow then
			ConsoleToAll( player:GetName() .. " failed!" )
			BroadCastMessage( "The Runner FAILED!   " .. player:GetName() .. "!" )
			BroadCastSound ( "Misc.w00t" )
                        
			local team = GetTeam( Team.kBlue )
			team:AddScore( POINTS_PER_OPERATORS_RUNNERS_SUICIDE_FOR_OPERATORS )

		end
	end

end





-- runners tele damage
tele_damage = trigger_ff_script:new({ })

-- zap touch
function tele_damage:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kYellow then
			ConsoleToAll( player:GetName() .. " zaped!" )
			BroadCastMessage( "The Runner was ZAPPED!!   " .. player:GetName() .. "!" )
			BroadCastSound ( "Misc.w00t" )
                        
			local team = GetTeam( Team.kBlue )
			team:AddScore( POINTS_PER_OPERATORS_RUNNERS_SUICIDE_FOR_OPERATORS )

		end
	end

end




-- Dont give any one any thing, but strip grenades from operators
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )




	if player:GetTeamId() == Team.kBlue then
		-- Remove grens
		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:RemoveAmmo( Ammo.kGren2, 4 )
	end
end







