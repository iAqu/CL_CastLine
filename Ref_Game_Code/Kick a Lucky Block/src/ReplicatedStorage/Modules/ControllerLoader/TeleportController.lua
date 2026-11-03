-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientPlotService = require(ReplicatedStorage.Modules.ServicesLoader.ClientPlotService)
local t = {}
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = ClientPlotService.Model or ClientPlotService.ModelAdded:Wait()
local v2 = CFrame.new(-12.87, -9.5, 0.4, 0, 0, 1, 0, 1, 0, -1, 0, 0)
local v3 = v1:GetPivot():ToWorldSpace(v2)
local v4 = CFrame.new(134.125, 0.125, 83.866) * CFrame.Angles(0, -1.5707963267948966, 0)
function t.TeleportToBase(p1) --[[ TeleportToBase | Line: 17 | Upvalues: LocalPlayer (copy), v3 (copy) ]]
	if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
		local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
		local v1 = CFrame.new(0, 0, 0)
		if Humanoid then
			v1 = CFrame.new(0, Humanoid.HipHeight, 0)
		end
		LocalPlayer.Character.PrimaryPart.CFrame = v3 * v1
	end
end
function t.TeleportToSeller(p1) --[[ TeleportToSeller | Line: 30 | Upvalues: LocalPlayer (copy), v4 (copy) ]]
	if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
		LocalPlayer.Character.PrimaryPart.CFrame = v4 * CFrame.new(0, LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.HipHeight or 0, 0)
	end
end
return t