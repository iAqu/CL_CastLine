-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local v1 = require(ReplicatedStorage.Shared.Packages.Trove).new()
return {
	Properties = {
		Brightness = 1,
		EnvironmentDiffuseScale = 1,
		EnvironmentSpecularScale = 1,
		GlobalShadows = true,
		ClockTime = 13,
		GeographicLatitude = 0,
		ExposureCompensation = 0,
		Ambient = Color3.fromRGB(70, 70, 70),
		ColorShift_Bottom = Color3.new(),
		ColorShift_Top = Color3.new(),
		OutdoorAmbient = Color3.fromRGB(70, 70, 70)
	},
	Start = function(p1) --[[ Start | Line: 27 | Upvalues: v1 (copy), Lighting (copy) ]]
		for i, v in ipairs((script.Assets:GetChildren())) do
			v1:Clone(v).Parent = workspace.Debris
		end
		for i, v in ipairs(script.Lighting:GetChildren()) do
			v1:Clone(v).Parent = Lighting
		end
		for k, v in pairs(p1.Properties) do
			Lighting[k] = v
		end
	end,
	Destroy = function(p1) --[[ Destroy | Line: 44 | Upvalues: v1 (copy) ]]
		v1:Clean()
	end
}