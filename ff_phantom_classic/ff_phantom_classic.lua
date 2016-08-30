IncludeScript("base_shutdown");

--[[
*******************************************************

Security

*******************************************************
]]--

-- length of time that security goes down for
SECURITY_LENGTH = 45

red_upper_security_clip = red_security_clip
blue_upper_security_clip = blue_security_clip

local security_off_base = security_off or function() end
function security_off(team)
	security_off_base(team)

	-- get the clip entities
	local clips = Collection()
	local clipname = team.."_upper_security_clip"
	clips:GetByName({clipname})

	for clip in clips.items do
		clip = CastToTriggerClip(clip)
		if clip and _G[clipname] and _G[clipname].clipflags then
			-- clear flags, but send a dummy flag (for some reason with zero flags it blocks everything)
			clip:SetClipFlags({ClipFlags.kClipTeamBlue})
		end
	end
end

local security_on_base = security_on or function() end
function security_on(team)
	security_on_base(team)

	-- get the clip entities
	local clips = Collection()
	local clipname = team.."_upper_security_clip"
	clips:GetByName({clipname})

	for clip in clips.items do
		clip = CastToTriggerClip(clip)
		if clip and _G[clipname] and _G[clipname].clipflags then
			-- reset flags to normal
			clip:SetClipFlags(_G[clipname].clipflags)
		end
	end
end

--[[
*******************************************************

Bags

*******************************************************
]]--

-- make generic backpack an actual generic backpack
genericbackpack = genericbackpack:new({
	model = "models/items/backpack/backpack.mdl",
	touchsound = "Backpack.Touch"
})

spawn_grenpack = genericbackpack:new({
	gren1 = 2,
	gren2 = 2,
	respawntime = 60
})

spawn_pack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 20,
	cells = 100,
	health = 100,
	armor = 200,
	respawntime = 1
})

fr_pack = genericbackpack:new({
	grenades = 20,
	nails = 20,
	shells = 100,
	rockets = 20,
	cells = 65,
	respawntime = 20
})

fr_healthpack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	health = 30,
	armor = 50,
	respawntime = 30
})

ramp_pack = genericbackpack:new({
	grenades = 20,
	nails = 20,
	shells = 100,
	rockets = 20,
	cells = 100,
	respawntime = 30
})

-- a dumb way to automate this
local phantom_packs = { 
	ramp_pack=ramp_pack, 
	fr_healthpack=fr_healthpack, 
	fr_pack=fr_pack, 
	spawn_pack=spawn_pack, 
	spawn_grenpack=spawn_grenpack 
}
local pack_touch_flags = {
	blue = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue},
	red = {AllowFlags.kOnlyPlayers,AllowFlags.kRed},
	yellow = {AllowFlags.kOnlyPlayers,AllowFlags.kYellow},
	green = {AllowFlags.kOnlyPlayers,AllowFlags.kGreen}
}

function setup_backpacks( backpacks, tfs )
	for name,backpack in pairs(backpacks) do
		for teamstring,touchflags in pairs( tfs ) do
			_G[name.."_"..teamstring] = _G[name]:new({ touchflags=touchflags })
		end
	end
end

setup_backpacks( phantom_packs, pack_touch_flags )

--[[
*******************************************************

Spawn protection

*******************************************************
]]--

blue_spawn_clip = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamRed, ClipFlags.kClipTeamYellow, ClipFlags.kClipTeamGreen, ClipFlags.kClipAllInfoScripts, ClipFlags.kClipAllBuildables} })
red_spawn_clip = trigger_ff_clip:new({ clipflags = {ClipFlags.kClipPlayersByTeam, ClipFlags.kClipTeamBlue, ClipFlags.kClipTeamYellow, ClipFlags.kClipTeamGreen, ClipFlags.kClipAllInfoScripts, ClipFlags.kClipAllBuildables} })

-- trigger hurt definitions
red_spawn_hurt = not_red_trigger:new({})
blue_spawn_hurt = not_blue_trigger:new({})