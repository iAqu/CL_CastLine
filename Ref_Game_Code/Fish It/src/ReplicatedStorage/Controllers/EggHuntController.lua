-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local SuperTween = require(script.Parent.WarpController.Internal.SuperTween)
local v1 = Net:RemoteEvent("EasterMosiacEgg")
local v2 = nil
local LocalPlayer = Players.LocalPlayer
local v3 = false
local t = {}
local t2 = {}
local function Update(p1, p2) --[[ Update | Line: 22 ]]
	local v1 = p1.Parent
	local v3 = tonumber(v1.Name)
	local Sound = v1:FindFirstChildOfClass("Sound")
	local v4 = p2 == v3
	for v5, v6 in v1:GetDescendants() do
		if v6:IsA("ParticleEmitter") then
			v6.Enabled = v4
		end
	end
	v1.Transparency = if v4 then 0 else 1
	p1.Enabled = v4
	Sound.Volume = if v4 then 0.5 else 0
end
local function Update2(p1, p2) --[[ Update2 | Line: 39 | Upvalues: v2 (ref), t (copy) ]]
	local v1 = v2:Get("EasterMosiac")
	local v22 = p1.Parent
	local Aura = v22:FindFirstChild("Aura")
	local v3 = table.find(t, v22.Name)
	for v4, v5 in v22:GetDescendants() do
		if v5:IsA("ParticleEmitter") then
			v5.Enabled = v1 or v3
		end
	end
	v22.Transparency = if v1 or v3 then 0 else 0.5
	p1.Enabled = not v1 and not v3 and (if p2 >= 9 then true else false)
	Aura.Volume = if v1 or v3 then 0.1 else 0
end
local function OnEasterHuntStepChanged(p1) --[[ OnEasterHuntStepChanged | Line: 56 | Upvalues: CollectionService (copy), Update (copy), Update2 (copy) ]]
	for v1, v2 in CollectionService:GetTagged("EggHunt") do
		Update(v2, p1)
	end
	for v3, v4 in CollectionService:GetTagged("EasterMosiacEgg") do
		Update2(v4, p1)
	end
end
local function OnInstanceAdded(p1) --[[ OnInstanceAdded | Line: 66 | Upvalues: v2 (ref), Update (copy) ]]
	Update(p1, (v2:Get("EasterHuntStep")))
end
local function OpenDoors(p1) --[[ OpenDoors | Line: 71 | Upvalues: v3 (ref), CollectionService (copy), SuperTween (copy) ]]
	if v3 then
		return
	end
	v3 = true
	for v1, v2 in CollectionService:GetTagged("EasterMosiacDoor") do
		if p1 then
			local v32 = v2.Name == "Left" and CFrame.new(8, 0, 0) or CFrame.new(-8, 0, 0)
			v2:PivotTo(v2:GetPivot() * v32)
			continue
		end
		local v4 = v2.Name == "Left" and CFrame.new(8, 0, 0) or CFrame.new(-8, 0, 0)
		local v5 = v2:GetPivot() * v4
		SuperTween.new(v2, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Pivot = v5
		}):Play()
	end
	if p1 ~= nil then
		return
	end
	for v6, v7 in CollectionService:GetTagged("EasterMosiacDoorSFX") do
		v7:Play()
	end
end
local function OnInstanceAdded2(p1) --[[ OnInstanceAdded2 | Line: 102 | Upvalues: v2 (ref), OpenDoors (copy) ]]
	if not v2:Get("EasterMosiac") then
		return
	end
	OpenDoors(true)
end
local function OnInstanceAdded3(p1) --[[ OnInstanceAdded3 | Line: 108 | Upvalues: v2 (ref), Update2 (copy) ]]
	Update2(p1, (v2:Get("EasterHuntStep")))
end
function t2.Start(p1) --[[ Start | Line: 113 | Upvalues: v2 (ref), Replion (copy), OnEasterHuntStepChanged (copy), OpenDoors (copy), v1 (copy), t (copy), CollectionService (copy), Update2 (copy), Observers (copy), OnInstanceAdded (copy), OnInstanceAdded2 (copy), OnInstanceAdded3 (copy) ]]
	v2 = Replion.Client:WaitReplion("Data")
	v2:OnChange("EasterHuntStep", OnEasterHuntStepChanged)
	v2:OnChange("EasterMosiac", function(p1) --[[ Line: 117 | Upvalues: OpenDoors (ref) ]]
		if not p1 then
			return
		end
		OpenDoors()
	end)
	v1.OnClientEvent:Connect(function(p1) --[[ Line: 123 | Upvalues: t (ref), v2 (ref), CollectionService (ref), Update2 (ref) ]]
		if not table.find(t, p1) then
			table.insert(t, p1)
		end
		local v22 = v2:Get("EasterHuntStep")
		for v3, v4 in CollectionService:GetTagged("EasterMosiacEgg") do
			Update2(v4, v22)
			local Place = v4.Parent:FindFirstChild("Place")
			if Place then
				Place:Play()
			end
		end
	end)
	Observers.observeTag("EggHunt", OnInstanceAdded)
	Observers.observeTag("EasterMosiacDoor", OnInstanceAdded2)
	Observers.observeTag("EasterMosiacEgg", OnInstanceAdded3)
end
return t2