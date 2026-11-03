-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientTimeController = require(ReplicatedStorage.Controllers.ClientTimeController)
local t = {
	["Disable Shadows"] = function(p1) --[[ Line: 37 | Upvalues: Lighting (copy) ]]
		Lighting.GlobalShadows = not p1
	end,
	["Global Notifications"] = function(p1) --[[ Line: 41 ]] end,
	Music = function(p1) --[[ Line: 44 | Upvalues: ClientTimeController (copy), SoundService (copy) ]]
		local v1, v2 = ClientTimeController:GetLightingProfile()
		local Music = SoundService:FindFirstChild("Music")
		if not Music then
			return
		end
		local v3 = 0.05
		if v1 and v1.Music then
			v3 = v1.Music.Volume
		elseif v1 and (v1.Day ~= nil and v1.Night ~= nil) then
			local v5 = v1[if v2 then "Night" else "Day"]
			if v5 and v5.Music then
				v3 = v5.Music.Volume
			end
		end
		Music.Volume = if p1 and v3 then v3 else 0
	end,
	Ambience = function(p1) --[[ Line: 64 | Upvalues: ClientTimeController (copy), SoundService (copy) ]]
		local v1, v2 = ClientTimeController:GetLightingProfile()
		local Ambience = SoundService:FindFirstChild("Ambience")
		if not Ambience then
			return
		end
		local v3 = 0.05
		if v1 and v1.Ambience then
			v3 = v1.Ambience.Volume
		elseif v1 and (v1.Day ~= nil and v1.Night ~= nil) then
			local v5 = v1[if v2 then "Night" else "Day"]
			if v5 and v5.Ambience then
				v3 = v5.Ambience.Volume
			end
		end
		Ambience.Volume = if p1 and v3 then v3 else 0
	end
}
return function(p1, p2) --[[ Line: 87 | Upvalues: t (copy) ]]
	if p2 then
		for v1, v2 in p2 do
			local v3 = p1[v1]
			if v2 ~= v3 then
				local v4 = t[v1]
				if v4 then
					task.spawn(v4, v3)
				end
			end
		end
	else
		for v5, v6 in p1 do
			local v7 = t[v5]
			if v7 then
				task.spawn(v7, v6)
			end
		end
	end
end