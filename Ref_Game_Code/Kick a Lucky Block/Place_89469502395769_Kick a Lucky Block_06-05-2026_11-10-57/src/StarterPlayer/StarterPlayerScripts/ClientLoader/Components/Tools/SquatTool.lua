-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local WeightServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.WeightServiceClient)
local TimedUpgradesServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.TimedUpgradesServiceClient)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
require(ReplicatedStorage.Shared.Packages.Signal)
local KickUpgradesUI = require(ReplicatedStorage.Modules.UILoader.KickUpgradesUI)
local ZoneController = require(ReplicatedStorage.Modules.ControllerLoader.ZoneController)
local GameHandler = require(ReplicatedStorage.Modules.HandlerLoader.GameHandler)
local AnimationController = require(ReplicatedStorage.Modules.ControllerLoader.AnimationController)
local Animations = ReplicatedStorage.Objects.Animations
local WeightsData = require(ReplicatedStorage.Shared.Data.WeightsData)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	Tag = ({
		Tag = Tags.SquatTool
	}).Tag
}
t.__index = t
local function IsBlocked() --[[ IsBlocked | Line: 31 | Upvalues: LocalPlayer (copy), ZoneController (copy), GameHandler (copy) ]]
	if LocalPlayer.Character then
		return if ZoneController.Zone == "KickReady" then true else GameHandler.InGame
	else
		return true
	end
end
local function UnequipTool(p1) --[[ UnequipTool | Line: 38 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character
	if Character and p1.Parent == Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if not Humanoid then
			return
		end
		Humanoid:UnequipTools()
	end
end
function t.new(p1) --[[ new | Line: 49 | Upvalues: LocalPlayer (copy), t (copy) ]]
	if p1.Parent == LocalPlayer.Backpack or p1.Parent == LocalPlayer.Character then
		local v2 = setmetatable({
			Tool = p1,
			Initialized = false
		}, t)
		v2:_init()
		return v2
	end
end
function t._init(p1) --[[ _init | Line: 62 | Upvalues: Trove (copy), LocalPlayer (copy), WeightsData (copy), AnimationController (copy), KickUpgradesUI (copy), ZoneController (copy), GameHandler (copy), WeightServiceClient (copy), TimedUpgradesServiceClient (copy), RunService (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		local Tool = p1.Tool
		local v1 = Trove.new()
		p1.Trove = v1
		local v2 = 0
		local v3 = nil
		local function Cleanup() --[[ Cleanup | Line: 79 | Upvalues: LocalPlayer (ref), WeightsData (ref), Tool (copy), AnimationController (ref), KickUpgradesUI (ref) ]]
			if LocalPlayer.Character then
				LocalPlayer.Character.PrimaryPart.Anchored = false
				AnimationController.StopAnim(WeightsData.Animations[Tool.Name] or WeightsData.Animations.Default)
			end
			KickUpgradesUI:Unequipped()
		end
		v1:Connect(Tool.Equipped, function() --[[ Line: 88 | Upvalues: LocalPlayer (ref), ZoneController (ref), GameHandler (ref), Tool (copy), WeightsData (ref), AnimationController (ref), WeightServiceClient (ref), TimedUpgradesServiceClient (ref), v1 (copy), v2 (ref), v3 (ref), RunService (ref), KickUpgradesUI (ref), Cleanup (copy) ]]
			if if LocalPlayer.Character and ZoneController.Zone ~= "KickReady" then GameHandler.InGame else true then
				local Character = LocalPlayer.Character
				if Character and Tool.Parent == Character then
					local Humanoid = Character:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						Humanoid:UnequipTools()
					end
				end
			end
			local v4 = AnimationController.PlayAnim(WeightsData.Animations[Tool.Name] or WeightsData.Animations.Default)
			if v4 then
				v4.Looped = true
				v4:AdjustSpeed(1.5 * WeightServiceClient.Multipliers.Speed)
			end
			if v4 then
				local v5 = WeightServiceClient.MultiplierChanged:Connect(function() --[[ Line: 102 | Upvalues: v4 (copy), WeightServiceClient (ref), TimedUpgradesServiceClient (ref) ]]
					v4:AdjustSpeed(1.5 * WeightServiceClient.Multipliers.Speed * TimedUpgradesServiceClient:GetMultiplierForType("weight_speed"))
				end)
				v1:Add((TimedUpgradesServiceClient.NewTable:Connect(function(p1) --[[ Line: 107 | Upvalues: v4 (copy), WeightServiceClient (ref), TimedUpgradesServiceClient (ref) ]]
					v4:AdjustSpeed(1.5 * WeightServiceClient.Multipliers.Speed * TimedUpgradesServiceClient:GetMultiplierForType("weight_speed"))
				end)))
				v1:Add(v5)
			end
			v2 = tick()
			v3 = RunService.PreRender:Connect(function() --[[ Line: 115 | Upvalues: v2 (ref), WeightServiceClient (ref), KickUpgradesUI (ref) ]]
				local v1 = tick()
				if not (v1 - v2 < 1 / WeightServiceClient.Multipliers.Speed) then
					v2 = v1
					KickUpgradesUI:Pop()
				end
			end)
			v1:Add(v3)
			v1:Add(Cleanup)
			LocalPlayer.Character.PrimaryPart.Anchored = true
		end)
		v1:Connect(Tool.Unequipped, function() --[[ Line: 131 | Upvalues: v3 (ref), v1 (copy), Cleanup (copy), KickUpgradesUI (ref), WeightsData (ref), Tool (copy), AnimationController (ref), LocalPlayer (ref) ]]
			if v3 and v3.Connected then
				v1:Remove(v3)
				v3:Disconnect()
			end
			v1:Remove(Cleanup)
			KickUpgradesUI:Unequipped()
			AnimationController.StopAnim(WeightsData.Animations[Tool.Name] or WeightsData.Animations.Default)
			LocalPlayer.Character.PrimaryPart.Anchored = false
		end)
		p1.Trove:Add(ZoneController.ZoneChanged:Connect(function(p1) --[[ Line: 144 | Upvalues: Tool (copy), LocalPlayer (ref) ]]
			if p1 == "KickReady" then
				local Character = LocalPlayer.Character
				if not Character or Tool.Parent ~= Character then
					return
				end
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				if not Humanoid then
					return
				end
				Humanoid:UnequipTools()
			end
		end))
		p1.Trove:Add(GameHandler.GameChanged:Connect(function(p1) --[[ Line: 150 | Upvalues: Tool (copy), LocalPlayer (ref) ]]
			if p1 then
				local Character = LocalPlayer.Character
				if not Character or Tool.Parent ~= Character then
					return
				end
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				if not Humanoid then
					return
				end
				Humanoid:UnequipTools()
			end
		end))
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 157 ]]
	p1.Trove:Destroy()
end
return t