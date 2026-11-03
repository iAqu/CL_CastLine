-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Signal)
local v1 = nil
local v2 = Trove.new()
local function NightTimeCoral(p1) --[[ NightTimeCoral | Line: 18 | Upvalues: v2 (copy) ]]
	local v1, v22, v3 = p1.Color:ToHSV()
	local PointLight = Instance.new("PointLight")
	PointLight.Brightness = 0.7
	PointLight.Range = 14
	PointLight.Color = Color3.fromHSV(v1, math.min(v22 + 0.2, 1), v3)
	PointLight.Parent = p1
	p1.Material = Enum.Material.Neon
	v2:Add(PointLight)
	v2:Add(function() --[[ Line: 30 | Upvalues: p1 (copy) ]]
		p1.Material = Enum.Material.SmoothPlastic
	end)
end
Replion.Client:AwaitReplion("Time", function(p1) --[[ Line: 36 | Upvalues: v1 (ref), ReplicatedStorage (copy), CollectionService (copy), NightTimeCoral (copy), v2 (copy), Observers (copy) ]]
	v1 = require(ReplicatedStorage.Controllers.ClientTimeController)
	v1.NightTimeChanged:Connect(function() --[[ Line: 39 | Upvalues: v1 (ref), CollectionService (ref), NightTimeCoral (ref), v2 (ref) ]]
		if not v1.NightTime then
			v2:Clean()
			return
		end
		for i, v in ipairs(CollectionService:GetTagged("CoralLight")) do
			NightTimeCoral(v)
		end
	end)
	Observers.observeTag("CoralLight", function(p1) --[[ Line: 49 | Upvalues: v1 (ref), NightTimeCoral (ref) ]]
		if not v1.NightTime then
			return function() --[[ Line: 54 ]] end
		end
		NightTimeCoral(p1)
		return function() --[[ Line: 54 ]] end
	end, { workspace })
end)
return {}