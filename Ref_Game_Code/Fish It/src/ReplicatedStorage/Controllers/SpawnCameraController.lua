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
require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Thread)
local PlayerGui = Players.LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local v1 = Net:RemoteEvent("ResetPlayerCamera")
local t = {}
function t.Init(p1) --[[ Init | Line: 31 | Upvalues: v1 (copy), t (copy) ]]
	v1.OnClientEvent:Connect(function() --[[ Line: 33 | Upvalues: t (ref) ]]
		t:FixCamera()
	end)
end
function t.FixCamera(p1) --[[ FixCamera | Line: 40 | Upvalues: Players (copy) ]]
	local CurrentCamera = workspace.CurrentCamera
	local Character = Players.LocalPlayer.Character
	if not Character then
		return
	end
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
	if HumanoidRootPart then
		CurrentCamera.CFrame = CFrame.lookAt((HumanoidRootPart.CFrame * CFrame.new(0, 2, 8)).Position, HumanoidRootPart.Position + Vector3.new(0, 2, 0))
	end
end
return t