-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local t = {
	Environment = "Default",
	EnvironmentChanged = Signal.new()
}
local v1 = false
local v2 = Signal.new()
local t2 = {}
local t3 = {
	Objects = {},
	Properties = {
		Brightness = 0,
		EnvironmentDiffuseScale = 0,
		EnvironmentSpecularScale = 0,
		GlobalShadows = true,
		ClockTime = 11.6,
		GeographicLatitude = 0,
		ExposureCompensation = 0,
		Ambient = Color3.new(),
		ColorShift_Bottom = Color3.new(),
		ColorShift_Top = Color3.new(),
		OutdoorAmbient = Color3.fromRGB()
	}
}
function LoadDefaultPreset() --[[ LoadDefaultPreset | Line: 36 | Upvalues: Lighting (copy), t3 (copy) ]]
	local v1 = Lighting:GetChildren()
	for k, v in pairs(t3.Properties) do
		t3.Properties[k] = Lighting[k]
	end
	t3.Objects = v1
end
function LoadEnvironments() --[[ LoadEnvironments | Line: 45 | Upvalues: t2 (copy) ]]
	for i, v in ipairs(script:GetChildren()) do
		if v:IsA("ModuleScript") then
			local v1 = require(v)
			if typeof(v1) == "table" and (v1.Start and v1.Destroy) then
				t2[v.Name] = v1
			end
		end
	end
end
function HideDefault() --[[ HideDefault | Line: 56 | Upvalues: t3 (copy) ]]
	for i, v in ipairs(t3.Objects) do
		v.Parent = script
	end
end
function ShowDefault() --[[ ShowDefault | Line: 62 | Upvalues: t3 (copy), Lighting (copy) ]]
	for i, v in ipairs(t3.Objects) do
		v.Parent = Lighting
	end
	for k, v in pairs(t3.Properties) do
		Lighting[k] = v
	end
end
function t.ChangeEnvironment(p1, p2) --[[ ChangeEnvironment | Line: 74 | Upvalues: v1 (ref), v2 (copy), t2 (copy) ]]
	if not v1 then
		v2:Wait()
	end
	if p1.Environment == "Default" and p2 ~= "Default" then
		local v12 = t2[p2]
		if v12 then
			HideDefault()
			p1.Environment = p2
			p1.EnvironmentChanged:Fire(p2)
			v12:Start()
		else
			warn((("%* is missing from list."):format(p2)))
		end
	end
end
function t.Reset(p1) --[[ Reset | Line: 96 | Upvalues: t2 (copy) ]]
	if p1.Environment ~= "Default" then
		local v1 = t2[p1.Environment]
		if v1 then
			v1:Destroy()
		end
		ShowDefault()
		p1.Environment = "Default"
		p1.EnvironmentChanged:Fire("Default")
	end
end
function t._init(p1) --[[ _init | Line: 112 | Upvalues: v1 (ref), v2 (copy) ]]
	LoadDefaultPreset()
	LoadEnvironments()
	v1 = true
	v2:Fire()
end
return t