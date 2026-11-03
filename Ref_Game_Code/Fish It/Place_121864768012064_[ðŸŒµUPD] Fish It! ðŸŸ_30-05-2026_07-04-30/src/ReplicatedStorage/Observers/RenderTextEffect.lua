-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Effects = require(ReplicatedStorage.Shared.Effects)
Observers.observeTag("RenderTextEffect", function(p1) --[[ Line: 11 | Upvalues: HttpService (copy), Effects (copy) ]]
	if not p1:IsA("BasePart") then
		return
	end
	local v1 = p1:GetAttribute("CountdownStart")
	local v2 = p1:GetAttribute("CountdownEnd")
	if not (v1 and v2) then
		return
	end
	if v2 and v2 < workspace:GetServerTimeNow() then
		return
	end
	local v3 = HttpService:GenerateGUID(false)
	Effects:TextEffect({
		Channel = "All",
		MaxDistance = 500,
		IgnoreDistance = true,
		UUID = v3,
		CountdownData = {
			CountdownStart = v1,
			CountdownEnd = v2
		},
		TextData = {
			EffectType = "EventCountdownBG",
			StudsOffset = Vector3.new(0, 50, 0),
			AttachTo = p1,
			TextColor = ColorSequence.new(Color3.fromRGB(255, 255, 255))
		},
		Parent = p1
	})
	return function() --[[ Line: 52 | Upvalues: v3 (copy), Effects (ref) ]]
		if not v3 then
			return
		end
		Effects:DestroyEffect(nil, v3)
	end
end)
return {}