-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("RunService")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.spr)
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 18 | Upvalues: ReplicatedStorage (copy), Observers (copy), Trove (copy), Players (copy) ]]
	require(ReplicatedStorage.Controllers.TextNotificationController)
	require(ReplicatedStorage.Controllers.PromptController)
	require(ReplicatedStorage.Controllers.PurchaseScreenBlackoutController)
	require(ReplicatedStorage.Shared.Soundbook)
	Observers.observeTag("QuickTeleport", function(p1) --[[ Line: 25 | Upvalues: Trove (ref), Players (ref) ]]
		local v1 = Trove.new()
		local StartTeleport = p1:WaitForChild("StartTeleport", 30)
		if not StartTeleport then
			return
		end
		local TeleportTo = p1:WaitForChild("TeleportTo", 30)
		if TeleportTo then
			local v2 = false
			v1:Add(StartTeleport.Touched:Connect(function(p1) --[[ Line: 41 | Upvalues: Players (ref), TeleportTo (copy), v2 (ref) ]]
				local v1 = p1.Parent
				if not v1 then
					return
				end
				local v22 = Players:GetPlayerFromCharacter(v1)
				if not v22 then
					return
				end
				if v22 ~= Players.LocalPlayer then
					return
				end
				local Character = v22.Character
				if Character then
					Character:PivotTo(TeleportTo.CFrame)
					v2 = false
				end
			end))
			return function() --[[ Line: 67 | Upvalues: v1 (ref) ]]
				if not v1 then
					return
				end
				v1:Destroy()
				v1 = nil
			end
		end
	end)
end)
return {}