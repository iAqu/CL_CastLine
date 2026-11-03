-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeedServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.SpeedServiceClient)
local TimedUpgradesServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.TimedUpgradesServiceClient)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = require(ReplicatedStorage.Shared.Packages.Trove).new()
local t = {}
function OnSpeedChanged() --[[ OnSpeedChanged | Line: 20 | Upvalues: LocalPlayer (copy), SpeedServiceClient (copy) ]]
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = SpeedServiceClient.InSlowMode and SpeedServiceClient.CurrentSpeed or SpeedServiceClient.CurrentSpeed * (SpeedServiceClient.Multiplier or 1)
	end
end
function OnNewCharacter(p1) --[[ OnNewCharacter | Line: 35 | Upvalues: v1 (copy), SpeedServiceClient (copy) ]]
	if p1 then
		v1:Clean()
		local v12 = p1:FindFirstChild("Humanoid") or p1:WaitForChild("Humanoid")
		v12.WalkSpeed = SpeedServiceClient.CurrentSpeed
		OnSpeedChanged()
		v1:Connect(v12:GetPropertyChangedSignal("WalkSpeed"), OnSpeedChanged)
	end
end
function t._init() --[[ _init | Line: 51 | Upvalues: LocalPlayer (copy), TimedUpgradesServiceClient (copy), SpeedServiceClient (copy) ]]
	OnNewCharacter(LocalPlayer.Character)
	TimedUpgradesServiceClient.NewTable:Connect(OnSpeedChanged)
	SpeedServiceClient.SpeedChanged:Connect(OnSpeedChanged)
	LocalPlayer.CharacterAdded:Connect(OnNewCharacter)
	LocalPlayer:GetAttributeChangedSignal("x2Speed"):Connect(OnSpeedChanged)
end
return t