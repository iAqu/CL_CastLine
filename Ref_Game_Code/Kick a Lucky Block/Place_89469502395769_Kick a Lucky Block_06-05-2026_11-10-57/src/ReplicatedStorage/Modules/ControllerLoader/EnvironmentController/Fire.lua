-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local FireVFX = script.FireVFX
local v1 = Trove.new()
return {
	Properties = {
		Brightness = 1,
		EnvironmentDiffuseScale = 1,
		EnvironmentSpecularScale = 1,
		GlobalShadows = true,
		ClockTime = 16.647,
		GeographicLatitude = 21.134,
		ExposureCompensation = 0,
		Ambient = Color3.fromRGB(70, 70, 70),
		ColorShift_Bottom = Color3.new(),
		ColorShift_Top = Color3.new(),
		OutdoorAmbient = Color3.fromRGB(70, 70, 70)
	},
	Start = function(p1) --[[ Start | Line: 28 | Upvalues: v1 (copy), FireVFX (copy), Lighting (copy) ]]
		v1:Clone(FireVFX).Parent = workspace
		for i, v in ipairs(script.Lighting:GetChildren()) do
			v1:Clone(v).Parent = Lighting
		end
		for k, v in pairs(p1.Properties) do
			Lighting[k] = v
		end
	end,
	Destroy = function(p1) --[[ Destroy | Line: 42 | Upvalues: v1 (copy) ]]
		v1:Clean()
	end
}