-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local QuestList = require(ReplicatedStorage.Shared.Quests.QuestList)
local QuestUtility = require(ReplicatedStorage.Shared.Quests.QuestUtility)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Shared.Quests.Types)
local AuraQuest = QuestList.AuraQuest
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local Board = script.Parent:WaitForChild("Board")
local Gui = Board:WaitForChild("Gui")
local DisabledGui = Board:WaitForChild("DisabledGui")
local function RefreshQuests() --[[ RefreshQuests | Line: 31 | Upvalues: v1 (ref), AuraQuest (copy), QuestUtility (copy), Gui (copy), DisabledGui (copy) ]]
	local v12 = v1:Get(AuraQuest.ReplionPath)
	if not v12 then
		return
	end
	if not v12.Available.Forever then
		return
	end
	local v2 = #v12.Available.Forever.Quests
	local v3 = 0
	local v4 = 1 / v2
	local sum = 0
	local v5
	for i = 1, AuraQuest.Quests do
		local v6 = v12.Available.Forever.Quests[i]
		if v6 then
			local v7 = QuestUtility:GetQuestData("AuraQuest", "Forever", v6.QuestId)
			if v7 then
				local v8 = QuestUtility.GetQuestValue(v1, v7)
				local Progress = v6.Progress
				if v8 <= Progress then
					Progress, v3 = v8, v3 + 1
				end
				local v9 = math.clamp(Progress / v8, 0, 1)
				sum = sum + math.clamp(v9 / v2, 0, v4)
				v5 = function(p1) --[[ Line: 69 | Upvalues: v7 (copy), v9 (copy) ]]
					p1.Text = ("%* - %*%%"):format(v7.DisplayName, (math.floor(v9 * 10000 / 100)))
					p1.Visible = true
				end
			end
		else
			v5 = function(p1) --[[ Line: 74 ]]
				p1.Visible = false
			end
		end
		if v5 then
			task.spawn(function() --[[ Line: 80 | Upvalues: Gui (ref), i (copy), v5 (ref) ]]
				local v1 = Gui.Content:WaitForChild(("Label%*"):format(i), 10)
				if not v1 then
					return
				end
				v5(v1)
			end)
		end
	end
	local Progress = Gui.Content.Progress
	Progress.ProgressLabel.Text = ("PROGRESS: %*%% (Completed %*)"):format(math.round(sum * 100 * 10) / 10, v3)
	Progress.Bar.Size = UDim2.fromScale(math.clamp(sum, 0, 1), 1)
	Gui.Enabled = true
	DisabledGui.Enabled = false
end
local function SetupQuests() --[[ SetupQuests | Line: 103 | Upvalues: v1 (ref), AuraQuest (copy), RefreshQuests (copy) ]]
	v1:OnChange({ AuraQuest.Identifier, "Available", "Forever" }, function(p1, p2) --[[ Line: 104 | Upvalues: RefreshQuests (ref) ]]
		RefreshQuests()
	end)
	RefreshQuests()
end
(function() --[[ Start | Line: 111 | Upvalues: v1 (ref), Replion (copy), AuraQuest (copy), SetupQuests (copy), Gui (copy), DisabledGui (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	if v1:Get(AuraQuest.ReplionPath) then
		SetupQuests()
	else
		local v12 = nil
		v12 = v1:OnChange(AuraQuest.ReplionPath, function() --[[ Line: 119 | Upvalues: v12 (ref), SetupQuests (ref) ]]
			v12:Disconnect()
			SetupQuests()
		end)
		Gui.Enabled = false
		DisabledGui.Enabled = true
	end
end)()