-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Packages.Net)
local Loader = require(ReplicatedStorage.Packages.Loader)
require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local Data = script:WaitForChild("Data")
local v1 = Loader.LoadChildren(Data)
require(ReplicatedStorage.Types.Modifiers)
local v2 = Net:RemoteEvent("ReplicateCutscene")
Net:RemoteEvent("StopCutscene")
return {
	HideAll = function(p1) --[[ HideAll | Line: 25 | Upvalues: ReplicatedStorage (copy) ]]
		local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
		GuiControl:Close(true)
		GuiControl:Lock()
		GuiControl:SetHUDVisibility(false)
	end,
	GetCutsceneData = function(p1, p2, p3) --[[ GetCutsceneData | Line: 33 | Upvalues: v1 (copy), TierUtility (copy) ]]
		local v12 = v1[p2]
		if v12 then
			return v12
		end
		if not p3 then
			return
		end
		local v2 = v1[TierUtility:GetTierFromRarity(p3).Name]
		if v2 then
			return v2
		end
	end,
	ReplicateFor = function(p1, p2, p3, p4, p5) --[[ ReplicateFor | Line: 57 | Upvalues: v2 (copy) ]]
		for v1, v22 in p2 do
			if v22:GetAttribute("ServerCutsceneBlocker") then
				task.defer(function() --[[ Line: 63 | Upvalues: v22 (copy), v2 (ref), p3 (copy), p4 (copy), p5 (copy) ]]
					if not v22:GetAttribute("ServerCutsceneBlocker") then
						return
					end
					v22:GetAttributeChangedSignal("ServerCutsceneBlocker"):Wait()
					v2:FireClient(v22, p3, p4.character, p4.origin, p4.fishIdentifier, p4.metaData, p5)
				end)
				continue
			end
			v2:FireClient(v22, p3, p4.character, p4.origin, p4.fishIdentifier, p4.metaData, p5)
		end
	end,
	Replicate = function(p1, p2, p3, p4, p5, p6, p7, p8) --[[ Replicate | Line: 73 | Upvalues: v2 (copy) ]]
		v2:FireClient(p3, p2, p4, p5, p6, p7, p8)
	end
}