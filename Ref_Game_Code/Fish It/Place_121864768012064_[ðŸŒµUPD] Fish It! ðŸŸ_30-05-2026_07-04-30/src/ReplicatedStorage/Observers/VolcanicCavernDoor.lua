-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("RunService")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Shared.ItemUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Controllers.TextNotificationController)
local spr = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("spr"))
local v1 = Replion.Client:WaitReplion("Data")
local v2 = Signal.new()
local v3 = false
local function OpenDoor(p1) --[[ OpenDoor | Line: 33 | Upvalues: v1 (copy), v3 (ref), spr (copy), Soundbook (copy) ]]
	if not p1 then
		return
	end
	if not v1 then
		return
	end
	if not v1:Find("CompletedQuests", "Kohana Gatekeeper") then
		return
	end
	if v3 then
		return
	end
	v3 = true
	spr.target(p1, 1, 0.15, {
		Pivot = p1:GetAttribute("EndCFrame")
	})
	local Position = p1:GetPivot().Position
	if not (v3 and (workspace.CurrentCamera.CFrame.Position - Position).Magnitude <= 150) then
		return
	end
	Soundbook.Sounds.VolcaniCavernDoor:Play()
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 64 | Upvalues: Observers (copy), Trove (copy), OpenDoor (copy), v2 (copy) ]]
	Observers.observeTag("VolcanicCavernDoor", function(p12) --[[ Line: 66 | Upvalues: Trove (ref), p1 (copy), OpenDoor (ref), v2 (ref) ]]
		local v1 = Trove.new()
		local v22 = p12.Parent
		local function CheckCompleted() --[[ CheckCompleted | Line: 74 | Upvalues: p1 (ref), OpenDoor (ref), v22 (copy) ]]
			if p1:Find("CompletedQuests", "Kohana Gatekeeper") then
				OpenDoor(v22)
			end
		end
		v2:Connect(function() --[[ Line: 86 | Upvalues: p1 (ref), OpenDoor (ref), v22 (copy) ]]
			if p1:Find("CompletedQuests", "Kohana Gatekeeper") then
				OpenDoor(v22)
			end
		end)
		if not p1:Find("CompletedQuests", "Kohana Gatekeeper") then
			return function() --[[ Line: 101 | Upvalues: v1 (ref) ]]
				if not v1 then
					return
				end
				v1:Destroy()
				v1 = nil
			end
		end
		OpenDoor(v22)
		return function() --[[ Line: 101 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end
			v1:Destroy()
			v1 = nil
		end
	end)
end)
return {
	OpenGate = v2
}