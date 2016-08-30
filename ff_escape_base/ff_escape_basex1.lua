-- ff_escape-baseX1.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

SetConvar( "sv_skillutility", 1 )
SetConvar( "sv_helpmsg", 1 )
SetConvar( "sm_jetpack", 0 )
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

function startup()

 

	-- set up team names
	SetTeamName( Team.kBlue, "DIPLOMATS" )
	SetTeamName( Team.kRed, "NONE" )
	SetTeamName( Team.kYellow, "NONE" )
	SetTeamName( Team.kGreen, "NONE" )

	-- set up team limits
	SetPlayerLimit( Team.kBlue, 0 ) -- THE DIPLOMATS HAVE TO ESCAPE.
	SetPlayerLimit( Team.kRed, -1 ) -- NONE.
	SetPlayerLimit( Team.kYellow, -1 ) -- NONE.
	SetPlayerLimit( Team.kGreen, -1 ) -- NONE.

	team = GetTeam( Team.kBlue )
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
