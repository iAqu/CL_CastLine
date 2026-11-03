-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local Quests = require(ReplicatedStorage.Modules.Quests)
local MainlineQuestController = require(ReplicatedStorage.Controllers.MainlineQuestController)
local t = {
	Start = function(p1) --[[ Start | Line: 20 | Upvalues: UserPriority (copy), Replion (copy), Observers (copy), Quests (copy), MainlineQuestController (copy) ]]
		if not UserPriority:IsTradePlaza() then
			local v1 = Replion.Client:WaitReplion("Data"):GetExpect("Quests")
			Observers.observeTag("QuestBoard", function(p1) --[[ Line: 28 | Upvalues: Quests (ref), v1 (copy) ]]
				local v12 = p1:GetAttribute("QuestType")
				local v2 = p1:GetAttribute("QuestId")
				if not (v12 or v2) then
					return
				end
				local v3 = Quests[v12][v2]
				if not v3 then
					return
				end
				local Board = p1:WaitForChild("Board", 1000000)
				local v5 = if Board then Board:WaitForChild("Gui", 1000000) else Board
				if not v5 then
					return
				end
				UpdateBoard(v2, v3, v1[v12][v2], v5)
			end)
			MainlineQuestController:RegisterCallbacksForPath({ "Quests", "Mainline" }, SendBoardUpdate, nil, false)
		end
	end
}
function GetBoardFromQuestId(p1) --[[ GetBoardFromQuestId | Line: 55 | Upvalues: CollectionService (copy) ]]
	for i, v in ipairs(CollectionService:GetTagged("QuestBoard")) do
		if v:GetAttribute("QuestId") == p1 then
			return v
		end
	end
	return nil
end
function SendBoardUpdate(p1, p2) --[[ SendBoardUpdate | Line: 64 | Upvalues: Quests (copy) ]]
	local v1 = GetBoardFromQuestId(p1)
	if not v1 then
		return
	end
	local v2 = v1:GetAttribute("QuestType")
	local v3 = Quests[v2][p1]
	if not (v2 or v3) then
		return
	end
	local Board = v1:WaitForChild("Board", 1000000)
	local v4 = if Board then Board:WaitForChild("Gui", 1000000) else Board
	if not v4 then
		return
	end
	UpdateBoard(p1, v3, p2, v4)
end
function CalculateTotalProgress(p1, p2, p3) --[[ CalculateTotalProgress | Line: 79 ]]
	local count = 0
	local sum = 0
	for i, v in ipairs(p2.Objectives) do
		if p3 and (p3.Objectives and p3.Objectives[i]) then
			count = count + 1
		end
	end
	for i, v in ipairs(p2.Objectives) do
		local v1 = if p3 then p3.Objectives[i] else p3
		local v2 = v1 and v1.Progress or 0
		if v.Goal <= v2 then
			sum = sum + 1
			continue
		end
		sum = sum + math.clamp(v2 / v.Goal, 0, 1)
	end
	return sum / #p2.Objectives * 100
end
function UpdateBoard(p1, p2, p3, p4) --[[ UpdateBoard | Line: 103 ]]
	local v1 = CalculateTotalProgress(p1, p2, p3)
	local Progress = p4:WaitForChild("Content"):WaitForChild("Progress")
	Progress:WaitForChild("ProgressLabel").Text = "Progress: " .. math.floor(v1) .. "%"
	Progress:WaitForChild("Bar").Size = UDim2.fromScale(v1 / 100, 1)
end
return t