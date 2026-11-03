-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("TweenService")
game:GetService("RunService")
game:GetService("HapticService")
game:GetService("CollectionService")
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local Players = game:GetService("Players")
require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.NumberSpinner)
require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Thread)
require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Shared.VFXUtility)
require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.TierUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Shared.Effects)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Shared.BlockedHumanoidStates)
local CameraShaker = require(ReplicatedStorage.Modules.CameraShaker)
local PlayVFX = require(ReplicatedStorage.Controllers.VFXController).PlayVFX
require(ReplicatedStorage.Controllers.HUDController)
require(ReplicatedStorage.Controllers.AnimationController)
require(ReplicatedStorage.Modules.InputControl)
require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Shared.Effects.Types)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local v1 = Net:RemoteEvent("TotemSpawned")
local v2 = Net:RemoteEvent("TotemCreated")
local v3 = Net:RemoteEvent("TotemPickup")
workspace:WaitForChild("CosmeticFolder")
workspace:WaitForChild("Characters")
workspace:WaitForChild("Locations")
workspace:WaitForChild("Zones")
local function getZoneParams() --[[ getZoneParams | Line: 59 | Upvalues: LocalPlayer (copy) ]]
	local v1 = RaycastUtility:getFilteredTargets(LocalPlayer)
	local v2 = RaycastParams.new()
	v2.IgnoreWater = true
	v2.RespectCanCollide = false
	v2.FilterType = Enum.RaycastFilterType.Exclude
	v2.FilterDescendantsInstances = v1
	return v2
end
local t = {}
local function CameraShake(p1) --[[ CameraShake | Line: 74 | Upvalues: CurrentCamera (copy) ]]
	local v1 = CurrentCamera
	v1.CFrame = v1.CFrame * p1
end
local function camShake(p1) --[[ camShake | Line: 79 | Upvalues: CurrentCamera (copy) ]]
	local v1 = CurrentCamera
	v1.CFrame = v1.CFrame * p1
end
local v4 = CameraShaker.new(Enum.RenderPriority.Last.Value, camShake)
v4:Start()
function t.Init(p1) --[[ Init | Line: 87 | Upvalues: v1 (copy), t (copy), v2 (copy) ]]
	v1.OnClientEvent:Connect(function(p1) --[[ Line: 89 | Upvalues: t (ref) ]]
		t:TotemSpawn(p1)
	end)
	v2.OnClientEvent:Connect(function(p1, p2) --[[ Line: 95 | Upvalues: t (ref) ]]
		t:TotemCreated(p1, p2)
	end)
end
function t.TotemSpawn(p1, p2) --[[ TotemSpawn | Line: 102 | Upvalues: Soundbook (copy), PlayVFX (copy), v4 (copy), CameraShaker (copy) ]]
	Soundbook:RenderAt("TotemPlace", p2)
	PlayVFX:Fire("Totem Placed", CFrame.new(p2))
	v4:Shake(CameraShaker.Presets.Explosion)
end
function t.TotemCreated(p1, p2, p3) --[[ TotemCreated | Line: 114 | Upvalues: LocalPlayer (copy), v3 (copy) ]]
	if p2 then
		task.defer(function() --[[ Line: 119 | Upvalues: p2 (copy), LocalPlayer (ref), v3 (ref), p3 (copy) ]]
			if not p2.PrimaryPart then
				local Handle = p2:WaitForChild("Handle", 30)
				if Handle then
					p2.PrimaryPart = Handle
				end
			end
			local ProximityPrompt = p2.PrimaryPart:FindFirstChild("ProximityPrompt")
			local v1
			if ProximityPrompt then
				v1 = ProximityPrompt
			else
				local ProximityPrompt_2 = Instance.new("ProximityPrompt")
				ProximityPrompt_2.ObjectText = ""
				ProximityPrompt_2.ActionText = "Pick up"
				ProximityPrompt_2.ClickablePrompt = true
				ProximityPrompt_2.RequiresLineOfSight = false
				ProximityPrompt_2.MaxActivationDistance = 10
				ProximityPrompt_2.GamepadKeyCode = Enum.KeyCode.DPadDown
				ProximityPrompt_2.Style = Enum.ProximityPromptStyle.Custom
				ProximityPrompt_2.Parent = p2.PrimaryPart
				v1 = ProximityPrompt_2
			end
			v1.Triggered:Connect(function(p1) --[[ Line: 145 | Upvalues: LocalPlayer (ref), v3 (ref), p3 (ref) ]]
				if p1 == LocalPlayer then
					v3:FireServer(p3)
				end
			end)
		end)
	end
end
return t