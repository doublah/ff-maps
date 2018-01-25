-- FF_Hollow_NeoN.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- Normal Pack
-----------------------------------------------------------------------------

frbag = genericbackpack:new({
	health = 0,
	armor = 50,
	grenades = 50,
	nails = 50,
	shells = 50,
	rockets = 50,
	cells = 75,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {},
	botgoaltype = Bot.kBackPack_Ammo
})

function fiddlepack:dropatspawn() return false end

rfrbag = fiddlepack:new({ touchflags = {AllowFlags.kRed} })
bfrbag = fiddlepack:new({ touchflags = {AllowFlags.kBlue} })


-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = trigger_ff_script:new()
blue_aardvarksec = trigger_ff_script:new()
bluesecstatus = 1
redsecstatus = 1

function red_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kBlue then
			if redsecstatus == 1 then
				redsecstatus = 0
				AddSchedule("aardvarksecup10red",50,aardvarksecup10red)
				AddSchedule("aardvarksecupred",60,aardvarksecupred)
				OpenDoor("red_aardvarkdoorhack")
				BroadCastMessage("Red Security Deactivated for 60 Seconds")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_REDDOWN" )
				RemoveHudItemFromAll( "red-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "red-sec-down", 60, 25, 16, 16, 3 )
			end
		end
	end
end

function blue_aardvarksec:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == Team.kRed then
			if bluesecstatus == 1 then
				bluesecstatus = 0
				AddSchedule("aardvarksecup10blue",50,aardvarksecup10blue)
				AddSchedule("aardvarksecupblue",60,aardvarksecupblue)
				OpenDoor("blue_aardvarkdoorhack")
				BroadCastMessage("Blue Security Deactivated for 60 Seconds")
				--BroadCastSound( "otherteam.flagstolen")
				SpeakAll( "SD_BLUEDOWN" )
				RemoveHudItemFromAll( "blue-sec-up" )
				AddHudIconToAll( "hud_secdown.vtf", "blue-sec-down", 60, 25, 16, 16, 2 )
			end
		end
	end
end

function aardvarksecupred()
	redsecstatus = 1
	CloseDoor("red_aardvarkdoorhack")
	BroadCastMessage("Red Security Online")
	SpeakAll( "SD_REDUP" )
	RemoveHudItemFromAll( "red-sec-down" )
	AddHudIconToAll( "hud_secup_red.vtf", "red-sec-up", 60, 25, 16, 16, 3 )
end

function aardvarksecupblue()
	bluesecstatus = 1
	CloseDoor("blue_aardvarkdoorhack")
	BroadCastMessage("Blue Security Online")
	SpeakAll( "SD_BLUEUP" )
	RemoveHudItemFromAll( "blue-sec-down" )
	AddHudIconToAll( "hud_secup_blue.vtf", "blue-sec-up", 60, 25, 16, 16, 2 )
end

function aardvarksecup10red()
	BroadCastMessage("Red Security Online in 10 Seconds")
end

function aardvarksecup10blue()
	BroadCastMessage("Blue Security Online in 10 Seconds")
end

-----------------------------------------------------------------------------
-- touch resupply
-----------------------------------------------------------------------------

supply = trigger_ff_script:new({ team = Team.kUnassigned })

function supply:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

blue_supply = supply:new({ team = Team.kBlue })
red_supply = supply:new({ team = Team.kRed })



-------------------------
-- flaginfo
-------------------------
function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )

	flaginfo_base(player_entity) --basic CTF HUD items

	RemoveHudItem( player, "red-sec-down" )
	RemoveHudItem( player, "blue-sec-down" )
	RemoveHudItem( player, "red-sec-up" )
	RemoveHudItem( player, "blue-sec-up" )

	if bluesecstatus == 1 then
		AddHudIcon( player, "hud_secup_blue.vtf", "blue-sec-up", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "blue-sec-down", button_blue.iconx, button_blue.icony, button_blue.iconw, button_blue.iconh, 2 )
	end

	if redsecstatus == 1 then
		AddHudIcon( player, "hud_secup_red.vtf", "red-sec-up", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
	else
		AddHudIcon( player, "hud_secdown.vtf", "red-sec-down", button_red.iconx, button_red.icony, button_red.iconw, button_red.iconh, 3 )
	end
end

-----------------------------------------------------------------------------
--Teh Clipz :DDDDDDDDDDDDDDDDDD

clip_brush1 = trigger_ff_clip:new({ clipflags = 0 })

blue_block1 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamBlue} })
red_block1 = clip_brush:new({ clipflags = {ClipFlags.kClipPlayers, ClipFlags.kClipTeamRed} })



-------------------------------------
-------------------
-- hurts
------------------
-------------------------------------

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })


