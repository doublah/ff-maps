
-- ff_beta.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_location")
-----------------------------------------------------------------------------
-- startup 
-----------------------------------------------------------------------------
function startup()
	-- set up team limits
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)
	
	SetTeamName(Team.kBlue, "Blue Pirates")
	SetTeamName(Team.kRed, "Red Ninjas")
	SetTeamName(Team.kYellow, "Yellow Sasquatches")
	SetTeamName(Team.kGreen, "Green Zombies")
	
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( 0 )

	local team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( 0 ) 

	local team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( 0 )	
	team:SetClassLimit( 0 ) 

	local team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( 0 ) 

end
-----------------------------------------------------------------------------
-- Spawn Supplies
-----------------------------------------------------------------------------

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )

end



-----------------------------------------------------------------------------
-- Bags
-----------------------------------------------------------------------------

blue_bagcustom = genericbackpack:new({ 
	health = 100,
	armor = 300,
	grenades = 20,
	bullets = 300,
	nails = 300,
	shells = 300,
	rockets = 300,
	cells = 200,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}
})
red_bagcustom = genericbackpack:new({ 
	health = 100,
	armor = 300,
	grenades = 20,
	bullets = 300,
	nails = 300,
	shells = 300,
	rockets = 300,
	cells = 100,
	detpacks = 1,
	gren1 = 4,
	gren2 = 4,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}
})
-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_bluespawn  = location_info:new({ text = "Blue Spawn", team = Team.kBlue })
location_redspawn = location_info:new({ text = "Red Spawn", team = Team.kRed })

location_specbox = location_info:new({ text = "Spec Box", team = NO_TEAM })
location_arena1 = location_info:new({ text = "Arena 1", team = NO_TEAM })
location_arena2 = location_info:new({ text = "Arena 2", team = NO_TEAM })
location_arena3 = location_info:new({ text = "Arena 3", team = NO_TEAM })
location_arena4 = location_info:new({ text = "Arena 4", team = NO_TEAM })
location_arena5 = location_info:new({ text = "Arena 5", team = NO_TEAM })
location_arena6 = location_info:new({ text = "Arena 6", team = NO_TEAM })
location_arenaseven = location_info:new({ text = "Arena Seven", team = NO_TEAM })

location_arena1blue = location_info:new({ text = "Arena 1", team = Team.kBlue })
location_arena2blue = location_info:new({ text = "Arena 2", team = Team.kBlue })
location_arena3blue = location_info:new({ text = "Arena 3", team = Team.kBlue })
location_arena4blue = location_info:new({ text = "Arena 4", team = Team.kBlue })
location_arena5blue = location_info:new({ text = "Arena 5", team = Team.kBlue })
location_arena6blue = location_info:new({ text = "Arena 6", team = Team.kBlue })

location_arena1red = location_info:new({ text = "Arena 1", team = Team.kRed })
location_arena2red = location_info:new({ text = "Arena 2", team = Team.kRed })
location_arena3red = location_info:new({ text = "Arena 3", team = Team.kRed })
location_arena4red = location_info:new({ text = "Arena 4", team = Team.kRed })
location_arena5red = location_info:new({ text = "Arena 5", team = Team.kRed })
location_arena6red = location_info:new({ text = "Arena 6", team = Team.kRed })

location_blueblock = location_info:new({ text = "Blue Block", team = Team.kBlue })
location_redblock = location_info:new({ text = "Red Block", team = Team.kRed })
location_yellowblock = location_info:new({ text = "Yellow Block", team = Team.kYellow })
location_greenblock = location_info:new({ text = "Green Block", team = Team.kGreen })
location_blockfort = location_info:new({ text = "Blockfort", team = NO_TEAM })


-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

bluebutton1 = func_button:new({}) 
function bluebutton1:ondamage() OutputEvent( "bluebutton1", "Open" ) end 
function bluebutton1:onpress() OutputEvent( "bluebutton1", "Open" ) end 
bluebutton2 = func_button:new({}) 
function bluebutton2:ondamage() OutputEvent( "bluebutton2", "Open" ) end 
function bluebutton2:onpress() OutputEvent( "bluebutton2", "Open" ) end 
bluebutton3 = func_button:new({}) 
function bluebutton3:ondamage() OutputEvent( "bluebutton3", "Open" ) end 
function bluebutton3:onpress() OutputEvent( "bluebutton3", "Open" ) end 
bluebutton4 = func_button:new({}) 
function bluebutton4:ondamage() OutputEvent( "bluebutton4", "Open" ) end 
function bluebutton4:onpress() OutputEvent( "bluebutton4", "Open" ) end 
bluebutton5 = func_button:new({}) 
function bluebutton5:ondamage() OutputEvent( "bluebutton5", "Open" ) end 
function bluebutton5:onpress() OutputEvent( "bluebutton5", "Open" ) end 
bluebutton6 = func_button:new({}) 
function bluebutton6:ondamage() OutputEvent( "bluebutton6", "Open" ) end 
function bluebutton6:onpress() OutputEvent( "bluebutton6", "Open" ) end 
bluebutton7 = func_button:new({}) 
function bluebutton7:ondamage() OutputEvent( "bluebutton7", "Open" ) end 
function bluebutton7:onpress() OutputEvent( "bluebutton7", "Open" ) end 
bluebutton8 = func_button:new({}) 
function bluebutton8:ondamage() OutputEvent( "bluebutton8", "Open" ) end 
function bluebutton8:onpress() OutputEvent( "bluebutton8", "Open" ) end 

redbutton1 = func_button:new({}) 
function redbutton1:ondamage() OutputEvent( "redbutton1", "Open" ) end 
function redbutton1:onpress() OutputEvent( "redbutton1", "Open" ) end 
redbutton2 = func_button:new({}) 
function redbutton2:ondamage() OutputEvent( "redbutton2", "Open" ) end 
function redbutton2:onpress() OutputEvent( "redbutton2", "Open" ) end 
redbutton3 = func_button:new({}) 
function redbutton3:ondamage() OutputEvent( "redbutton3", "Open" ) end 
function redbutton3:onpress() OutputEvent( "redbutton3", "Open" ) end 
redbutton4 = func_button:new({}) 
function redbutton4:ondamage() OutputEvent( "redbutton4", "Open" ) end 
function redbutton4:onpress() OutputEvent( "redbutton4", "Open" ) end 
redbutton5 = func_button:new({}) 
function redbutton5:ondamage() OutputEvent( "redbutton5", "Open" ) end 
function redbutton5:onpress() OutputEvent( "redbutton5", "Open" ) end 
redbutton6 = func_button:new({}) 
function redbutton6:ondamage() OutputEvent( "redbutton6", "Open" ) end 
function redbutton6:onpress() OutputEvent( "redbutton6", "Open" ) end 
redbutton7 = func_button:new({}) 
function redbutton7:ondamage() OutputEvent( "redbutton7", "Open" ) end 
function redbutton7:onpress() OutputEvent( "redbutton7", "Open" ) end 
redbutton8 = func_button:new({}) 
function redbutton8:ondamage() OutputEvent( "redbutton8", "Open" ) end 
function redbutton8:onpress() OutputEvent( "redbutton8", "Open" ) end 

bluearena0_telebutton1 = func_button:new({}) 
function bluearena0_telebutton1:ondamage() OutputEvent( "bluearena0_telebutton1", "Open" ) end 
function bluearena0_telebutton1:onpress() OutputEvent( "bluearena0_telebutton1", "Open" ) end 
bluearena0_telebutton2 = func_button:new({}) 
function bluearena0_telebutton2:ondamage() OutputEvent( "bluearena0_telebutton2", "Open" ) end 
function bluearena0_telebutton2:onpress() OutputEvent( "bluearena0_telebutton2", "Open" ) end 
bluearena0_telebutton3 = func_button:new({}) 
function bluearena0_telebutton3:ondamage() OutputEvent( "bluearena0_telebutton3", "Open" ) end 
function bluearena0_telebutton3:onpress() OutputEvent( "bluearena0_telebutton3", "Open" ) end 
bluearena0_telebutton4 = func_button:new({}) 
function bluearena0_telebutton4:ondamage() OutputEvent( "bluearena0_telebutton4", "Open" ) end 
function bluearena0_telebutton4:onpress() OutputEvent( "bluearena0_telebutton4", "Open" ) end 
bluearena0_telebutton5 = func_button:new({}) 
function bluearena0_telebutton5:ondamage() OutputEvent( "bluearena0_telebutton5", "Open" ) end 
function bluearena0_telebutton5:onpress() OutputEvent( "bluearena0_telebutton5", "Open" ) end 
bluearena0_telebutton6 = func_button:new({}) 
function bluearena0_telebutton6:ondamage() OutputEvent( "bluearena0_telebutton6", "Open" ) end 
function bluearena0_telebutton6:onpress() OutputEvent( "bluearena0_telebutton6", "Open" ) end 
bluearena0_telebutton7 = func_button:new({}) 
function bluearena0_telebutton7:ondamage() OutputEvent( "bluearena0_telebutton7", "Open" ) end 
function bluearena0_telebutton7:onpress() OutputEvent( "bluearena0_telebutton7", "Open" ) end 
bluearena0_telebutton8 = func_button:new({}) 
function bluearena0_telebutton8:ondamage() OutputEvent( "bluearena0_telebutton8", "Open" ) end 
function bluearena0_telebutton8:onpress() OutputEvent( "bluearena0_telebutton8", "Open" ) end 

redarena0_telebutton1 = func_button:new({}) 
function redarena0_telebutton1:ondamage() OutputEvent( "redarena0_telebutton1", "Open" ) end 
function redarena0_telebutton1:onpress() OutputEvent( "redarena0_telebutton1", "Open" ) end 
redarena0_telebutton2 = func_button:new({}) 
function redarena0_telebutton2:ondamage() OutputEvent( "redarena0_telebutton2", "Open" ) end 
function redarena0_telebutton2:onpress() OutputEvent( "redarena0_telebutton2", "Open" ) end 
redarena0_telebutton3 = func_button:new({}) 
function redarena0_telebutton3:ondamage() OutputEvent( "redarena0_telebutton3", "Open" ) end 
function redarena0_telebutton3:onpress() OutputEvent( "redarena0_telebutton3", "Open" ) end 
redarena0_telebutton4 = func_button:new({}) 
function redarena0_telebutton4:ondamage() OutputEvent( "redarena0_telebutton4", "Open" ) end 
function redarena0_telebutton4:onpress() OutputEvent( "redarena0_telebutton4", "Open" ) end 
redarena0_telebutton5 = func_button:new({}) 
function redarena0_telebutton5:ondamage() OutputEvent( "redarena0_telebutton5", "Open" ) end 
function redarena0_telebutton5:onpress() OutputEvent( "redarena0_telebutton5", "Open" ) end 
redarena0_telebutton6 = func_button:new({}) 
function redarena0_telebutton6:ondamage() OutputEvent( "redarena0_telebutton6", "Open" ) end 
function redarena0_telebutton6:onpress() OutputEvent( "redarena0_telebutton6", "Open" ) end 
redarena0_telebutton7 = func_button:new({}) 
function redarena0_telebutton7:ondamage() OutputEvent( "redarena0_telebutton7", "Open" ) end 
function redarena0_telebutton7:onpress() OutputEvent( "redarena0_telebutton7", "Open" ) end 
redarena0_telebutton8 = func_button:new({}) 
function redarena0_telebutton8:ondamage() OutputEvent( "redarena0_telebutton8", "Open" ) end 
function redarena0_telebutton8:onpress() OutputEvent( "redarena0_telebutton8", "Open" ) end 

painting1 = func_button:new({}) 
function painting1:ondamage() OutputEvent( "painting1", "Press" ) end 
painting2 = func_button:new({}) 
function painting2:ondamage() OutputEvent( "painting2", "Press" ) end 
painting3 = func_button:new({}) 
function painting3:ondamage() OutputEvent( "painting3", "Press" ) end 
painting4 = func_button:new({}) 
function painting4:ondamage() OutputEvent( "painting4", "Press" ) end 
painting5 = func_button:new({}) 
function painting5:ondamage() OutputEvent( "painting5", "Press" ) end 
painting6 = func_button:new({}) 
function painting6:ondamage() OutputEvent( "painting6", "Press" ) end 
painting7 = func_button:new({}) 
function painting7:ondamage() OutputEvent( "painting7", "Press" ) end 
painting8 = func_button:new({}) 
function painting8:ondamage() OutputEvent( "painting8", "Press" ) end 
painting9 = func_button:new({}) 
function painting9:ondamage() OutputEvent( "painting9", "Press" ) end 
painting10 = func_button:new({}) 
function painting10:ondamage() OutputEvent( "painting10", "Press" ) end 
painting11 = func_button:new({}) 
function painting11:ondamage() OutputEvent( "painting11", "Press" ) end 
painting12 = func_button:new({}) 
function painting12:ondamage() OutputEvent( "painting12", "Press" ) end 
painting13 = func_button:new({}) 
function painting13:ondamage() OutputEvent( "painting13", "Press" ) end 
painting14 = func_button:new({}) 
function painting14:ondamage() OutputEvent( "painting14", "Press" ) end 
painting15 = func_button:new({}) 
function painting15:ondamage() OutputEvent( "painting15", "Press" ) end 
painting16 = func_button:new({}) 
function painting16:ondamage() OutputEvent( "painting16", "Press" ) end 

-----------------------------------------------------------------------------
-- Spawns
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

yellow_o_only = function(self,player) return ((player:GetTeamId() == Team.kYellow) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
yellow_d_only = function(self,player) return ((player:GetTeamId() == Team.kYellow) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

yellow_ospawn = { validspawn = yellow_o_only }
yellow_dspawn = { validspawn = yellow_d_only }

green_o_only = function(self,player) return ((player:GetTeamId() == Team.kGreen) and ((player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian) or (player:GetClass() == Player.kCivilian))) end
green_d_only = function(self,player) return ((player:GetTeamId() == Team.kGreen) and (((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false) and ((player:GetClass() == Player.kCivilian) == false))) end

green_ospawn = { validspawn = green_o_only }
green_dspawn = { validspawn = green_d_only }