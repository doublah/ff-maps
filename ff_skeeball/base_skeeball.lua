-- base_skeeball.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- Basic Skeeball gameplay. Respawns all players when the VIP is killed
-----------------------------------------------------------------------------
ONEPOINTS = 10
TWOPOINTS = 20
THREEPOINTS = 30
FOURPOINTS = 40
FIVEPOINTS = 50

function startup()

	SetTeamName( Team.kBlue, "Balls" )
	SetTeamName( Team.kRed, "Killers" )

SetPlayerLimit( Team.kBlue, 0 ) -- There can be only one Highlander!
SetPlayerLimit( Team.kRed, 0 ) -- Unlimited bodyguards.
SetPlayerLimit( Team.kYellow, -1 )
SetPlayerLimit( Team.kGreen, -1 )

local team = GetTeam( Team.kBlue )
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
	team:SetClassLimit( Player.kScout, -1 )
	team:SetClassLimit( Player.kSniper, 0 )
	team:SetClassLimit( Player.kSoldier, -1 )
	team:SetClassLimit( Player.kDemoman, -1 )
	team:SetClassLimit( Player.kMedic, -1 )
	team:SetClassLimit( Player.kHwguy, -1 )
	team:SetClassLimit( Player.kPyro, -1 )
	team:SetClassLimit( Player.kSpy, -1 )
	team:SetClassLimit( Player.kEngineer, -1 )
	team:SetClassLimit( Player.kCivilian, -1 )

end



-- Onepoint
onepoint = trigger_ff_script:new({ })

-- escape touch
function onepoint:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			player:AddFrags( ONEPOINTS )
			local team = GetTeam( Team.kBlue )
			team:AddScore( ONEPOINTS)

		end
	end

end

-- twopoint
twopoint = trigger_ff_script:new({ })

-- escape touch
function twopoint:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			player:AddFrags( TWOPOINTS )
			local team = GetTeam( Team.kBlue )
			team:AddScore( TWOPOINTS )

		end
	end

end

-- threepoint
threepoint = trigger_ff_script:new({ })

-- escape touch
function threepoint:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			player:AddFrags( THREEPOINTS )
			local team = GetTeam( Team.kBlue )
			team:AddScore( THREEPOINTS )

		end
	end

end

-- fourpoint
fourpoint = trigger_ff_script:new({ })

-- escape touch
function fourpoint:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			player:AddFrags( FOURPOINTS )
			local team = GetTeam( Team.kBlue )
			team:AddScore( FOURPOINTS )

		end
	end

end

-- threepoint
fivepoint = trigger_ff_script:new({ })

-- escape touch
function fivepoint:ontouch( touch_entity )

	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			player:AddFrags( FIVEPOINTS )
			local team = GetTeam( Team.kBlue )
			team:AddScore( FIVEPOINTS )

		end
	end

end