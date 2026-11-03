-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local NPCQuestGivers = require(ReplicatedStorage.Shared.NPCQuestGivers)
local NPCNametag = script:WaitForChild("NPCNametag")
local NPCQuest = script:WaitForChild("NPCQuest")
local function ContainsNPCQuest(p1) --[[ ContainsNPCQuest | Line: 11 | Upvalues: NPCQuestGivers (copy) ]]
	for v1, v2 in NPCQuestGivers do
		if v2.NPC == p1 then
			return true
		end
	end
	return false
end
Observers.observeTag("NPCTracker", function(p1) --[[ Line: 21 | Upvalues: NPCQuestGivers (copy), NPCNametag (copy), NPCQuest (copy) ]]
	local v1 = p1.Parent
	if not v1 then
		return
	end
	local v2 = v1.Name
	local v3 = false
	for v4, v5 in NPCQuestGivers do
		if v5.NPC == v2 then
			v3 = true
			break
		end
	end
	local v6 = nil
	local v7
	if p1 then
		v7 = NPCNametag:Clone()
		v7.Name = ("Tag - %*"):format(v2)
		v7.DisplayName.Text = v2
		v7.Parent = p1
		v7.Enabled = true
		if v3 then
			v6 = NPCQuest:Clone()
			v6.Name = ("Tracker - %*"):format(v2)
			v6.Parent = p1
			v6.Enabled = true
		end
	else
		v7 = nil
	end
	return function() --[[ Line: 47 | Upvalues: v7 (ref), v6 (ref) ]]
		if v7 then
			v7:Destroy()
		end
		if not v6 then
			return
		end
		v6:Destroy()
	end
end, { workspace })
return {}