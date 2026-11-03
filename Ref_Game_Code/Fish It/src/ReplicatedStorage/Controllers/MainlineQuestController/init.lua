-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Quests = require(ReplicatedStorage.Modules.Quests)
local QuestLines = require(ReplicatedStorage.Modules.QuestLines)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
require(ReplicatedStorage.Modules.ItemStringUtility)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local TweenUtil = require(ReplicatedStorage.Modules.Util.TweenUtil)
local FishingCastText = require(ReplicatedStorage.Shared.Effects.FishingCastText)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local Device = require(ReplicatedStorage.Modules.Device)
local Tracking = require(script.Tracking)
local v1 = Trove.new()
local v2 = Signal.new()
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v3 = nil
local Quest = PlayerGui:WaitForChild("Quest")
local List = Quest:WaitForChild("List")
local Inside = List:WaitForChild("Inside")
local Objective = Inside:WaitForChild("Quest"):WaitForChild("Content"):WaitForChild("Objective")
Objective.Parent = nil
local Quest_2 = Inside:WaitForChild("Quest")
Quest_2.Parent = nil
local t = {}
local t2 = {}
local v4 = true
local t3 = {}
local v5 = 0
local t4 = {}
local function UpdateVisibility() --[[ UpdateVisibility | Line: 71 | Upvalues: List (copy), v4 (ref), v5 (ref) ]]
	List.Visible = v4 and v5 == 0
end
local function DidCompleteAll(p1, p2, p3) --[[ DidCompleteAll | Line: 75 | Upvalues: Quests (copy) ]]
	local v1 = if p1 then Quests[p1][p2] else p1
	if not v1 then
		return false
	end
	local v2 = false
	for v3, v4 in v1.Objectives do
		local v5 = p3.Objectives[v3]
		if v5 then
			v2 = v5.Progress >= v4.Goal
			if not v2 then
				break
			end
		end
	end
	return v2
end
local function GetQuestTypeFromName(p1) --[[ GetQuestTypeFromName | Line: 98 | Upvalues: Quests (copy) ]]
	for v1, v2 in Quests do
		if v2[p1] then
			return v1
		end
	end
	return nil
end
local function GetQuestData(p1, p2, p3) --[[ GetQuestData | Line: 107 | Upvalues: Quests (copy) ]]
	local v1 = Quests[p1]
	if not v1 then
		return
	end
	local v2 = v1[p2]
	if not v2 then
		return
	end
	local v3 = v2[p3]
	if v3 then
		return v3
	end
end
local function DidCompleteTutorialObjective(p1, p2, p3) --[[ DidCompleteTutorialObjective | Line: 120 | Upvalues: QuestLines (copy), Quests (copy) ]]
	if QuestLines:GetQuestLineFromId(p1) ~= "A New Adventure" then
		return false
	end
	local v1 = nil
	for v2, v3 in Quests do
		if v3[p1] then
			v1 = v2
			break
		end
	end
	local v4 = if v1 then Quests[v1][p1] else v1
	if not v4 then
		return false
	end
	for v5, v6 in v4.Objectives do
		local v7 = p2.Objectives[v5]
		local v8 = p3.Objectives[v5]
		if v7 and (v8 and (v7.Progress < v6.Goal and v8.Progress >= v6.Goal)) then
			return true
		end
	end
	return false
end
local function modifyImageLabel(p1, p2) --[[ modifyImageLabel | Line: 146 ]]
	if p1 == "Fishing Rods" then
		p2.Position = UDim2.fromScale(0.5, 1)
		p2.AnchorPoint = Vector2.new(0.5, 1)
		p2.Size = UDim2.fromScale(2, 2)
	else
		p2.Position = UDim2.fromScale(0, 0)
		p2.AnchorPoint = Vector2.new(0, 0)
		p2.Size = UDim2.fromScale(1, 1)
	end
end
local function getData(p1) --[[ getData | Line: 158 | Upvalues: ItemUtility (copy), TierUtility (copy), CurrencyUtility (copy), FishingCastText (copy) ]]
	local v1 = nil
	local v2 = nil
	local v3 = nil
	local v4 = nil
	local t = {}
	local function fetchItemStats(p12, p2) --[[ fetchItemStats | Line: 166 | Upvalues: ItemUtility (ref), v4 (ref), v3 (ref), TierUtility (ref), v1 (ref), v2 (ref), p1 (copy), t (copy) ]]
		local v12 = if p12 then ItemUtility.GetItemDataFromItemType(p12, p2) else ItemUtility:GetItemData(p2)
		if not v12 then
			return
		end
		if v12.Data and v12.Data.Icon then
			v4 = v12.Data.Type
			v3 = v12.Data.Icon
		end
		local v42 = if v12.Probability then TierUtility:GetTierFromRarity(v12.Probability.Chance) else TierUtility:GetTier(v12.Data.Tier or 1)
		if v42 then
			v1 = v42.Tier
			v2 = v42.TierColor
		end
		local v7 = if p1.Name:find((("%*s"):format(p2))) then ("%*s"):format(p2) elseif p1.Name:find(p2) then p2 else nil
		if not v7 then
			return
		end
		local v9 = if v42 then ("%* %*"):format(v42.Name, v7) else nil
		local v11 = if v9 then if p1.Name:find(v9) then v9 else v7 else v7
		local v122 = p1.Name:split(v11)
		table.insert(t, v122[1] or "")
		table.insert(t, v11)
		table.insert(t, v122[2] or "")
	end
	if p1.Type == "EarnedCoins" then
		v2 = CurrencyUtility:GetCurrency("Coins").TextColor
		v3 = CurrencyUtility:GetCurrency("Coins").Icon
	elseif p1.AssociatedItem and p1.AssociatedType then
		fetchItemStats(p1.AssociatedType, p1.AssociatedItem)
	elseif p1.Type == "Catch" and p1.Requirements then
		local v5 = p1.Requirements.Name or p1.Requirements.Fish
		if v5 then
			fetchItemStats(nil, v5)
		elseif p1.Requirements.Tier then
			local v6 = TierUtility:GetTier(p1.Requirements.Tier)
			if v6 then
				v2 = v6.TierColor
				local v7 = if p1.SearchTerm then p1.SearchTerm else v6.Name
				local v8 = p1.Name:split(v7)
				table.insert(t, v8[1])
				table.insert(t, v7)
				table.insert(t, v8[2])
			end
		elseif p1.Requirements.EffectIndex then
			local v11 = FishingCastText[p1.Requirements.EffectIndex]
			if v11 then
				local Text = v11.Text
				local v12 = p1.Name:split(Text)
				if v12 then
					v2 = v11.TextColor
					table.insert(t, v12[1])
					table.insert(t, Text)
					table.insert(t, v12[2])
				end
			end
		end
	end
	return v1, v2, v3, v4, t
end
function t4.Start(p1) --[[ Start | Line: 254 | Upvalues: v3 (ref), Replion (copy), UserPriority (copy), Quest (copy), Quest_2 (copy), Objective (copy), Device (copy), t2 (copy), Inside (copy), v2 (copy), t4 (copy), Observers (copy), LocalPlayer (copy), Tracking (copy), QuestLines (copy) ]]
	v3 = Replion.Client:WaitReplion("Data")
	local v1 = UserPriority:IsTradePlaza()
	local TokenShardsAdFrame = Quest.List:FindFirstChild("TokenShardsAdFrame")
	if TokenShardsAdFrame then
		TokenShardsAdFrame.Visible = v1
		if v1 then
			TokenShardsAdFrame:AddTag("HideUI")
		end
	end
	if not v1 then
		local function onListChanged() --[[ onListChanged | Line: 288 | Upvalues: Device (ref), t2 (ref), Inside (ref) ]]
			local v1 = Device:IsMobile()
			local count = 0
			for v2, v3 in t2 do
				count = count + 1
			end
			if count >= 2 or v1 then
				Inside.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			else
				Inside.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			end
			if count >= 2 then
				Inside.ScrollingEnabled = true
				Inside.Selectable = true
			else
				Inside.ScrollingEnabled = false
				Inside.Selectable = false
			end
		end
		v2:Connect(function() --[[ deferChange | Line: 310 | Upvalues: onListChanged (copy) ]]
			task.wait(0.5)
			onListChanged()
		end)
		Device:RegisterDeviceChanged(onListChanged)
		Device:RegisterDeviceChanged(t4.deviceChanged)
		t4.deviceChanged()
		onListChanged()
		t4:observeQuestline({ "Quests", "Mainline" })
		t4:observeQuestline({ "Quests", "Event" })
		Observers.observeCharacter(function(p1, p2) --[[ Line: 325 | Upvalues: LocalPlayer (ref), Tracking (ref), v3 (ref), QuestLines (ref), t4 (ref) ]]
			if p1 == LocalPlayer then
				task.wait(1)
				local function getActiveQuest() --[[ getActiveQuest | Line: 332 | Upvalues: Tracking (ref), v3 (ref), QuestLines (ref), t4 (ref) ]]
					task.wait(0.5)
					if Tracking:Resume() then
						return
					end
					local v1 = v3:GetExpect({ "Quests", "Mainline" })
					local v2 = false
					local v32 = false
					for v4, v5 in QuestLines.QuestLines do
						v32 = true
						for v6, v7 in v5 do
							if v1[v7] then
								t4:StartTracking_SMART("Mainline", v7)
								v2 = true
								break
							end
						end
					end
					if v2 and v32 then
						return
					end
					Tracking:Stop()
				end
				v3:OnChange({ "Quests", "Mainline" }, getActiveQuest)
				getActiveQuest()
			end
		end)
		return
	end
	Quest.Enabled = true
	local Inside_2 = Quest.List:FindFirstChild("Inside")
	if not Inside_2 then
		Quest_2:Destroy()
		Objective:Destroy()
		return
	end
	local EventFrame = Inside_2:FindFirstChild("EventFrame")
	if EventFrame and EventFrame.Visible then
		Inside_2.Visible = true
	else
		Inside_2.Visible = false
	end
	Quest_2:Destroy()
	Objective:Destroy()
end
function t4.StartTracking_SMART(p1, p2, p3) --[[ StartTracking_SMART | Line: 391 | Upvalues: UserPriority (copy), v1 (copy), Quests (copy), Tracking (copy), v3 (ref) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	v1:Clean()
	local v12 = false
	local v2 = true
	local t = { "Quests", p2, p3 }
	local function destroySelf() --[[ destroySelf | Line: 404 | Upvalues: v1 (ref) ]]
		v1:Clean()
	end
	local function relink(p1) --[[ relink | Line: 408 | Upvalues: Quests (ref), p2 (copy), p3 (copy), v2 (ref), v12 (ref), Tracking (ref) ]]
		if not p1 then
			return
		end
		local v1 = Quests[p2][p3]
		local Objectives = p1.Objectives
		local v22 = nil
		for i, v in ipairs(p1.Objectives) do
			local v3 = v1.Objectives[i]
			local v4 = false
			if v3.TrackQuestCFrame or v3.TrackNPC then
				v4 = true
			end
			if v4 and v.Progress < v3.Goal then
				v22 = i
				break
			end
		end
		if not v22 then
			Tracking:Stop()
			return
		end
		if v2 then
			v12 = true
		end
		Tracking:Track(p2, p3, v22, v2)
		v2 = false
	end
	local v32 = v3:OnChange(t, function(p1, p2) --[[ Line: 451 | Upvalues: relink (copy) ]]
		if not p1 then
			return
		end
		relink(p1)
	end)
	local v4 = v3:OnChange({ "Quests", p2 }, function(p1, p2) --[[ Line: 457 | Upvalues: p3 (copy), v1 (ref) ]]
		if not (p1[p3] == nil) then
			return
		end
		v1:Clean()
	end)
	local v5 = v3:Get(t)
	if not v5 then
		v1:Add(function() --[[ Line: 470 | Upvalues: v32 (copy), v4 (copy) ]]
			v32:Disconnect()
			v4:Disconnect()
		end)
		return v12
	end
	relink(v5)
	v1:Add(function() --[[ Line: 470 | Upvalues: v32 (copy), v4 (copy) ]]
		v32:Disconnect()
		v4:Disconnect()
	end)
	return v12
end
function t4.observeQuestline(p1, p2) --[[ observeQuestline | Line: 478 | Upvalues: UserPriority (copy), Trove (copy), Quests (copy), DidCompleteAll (copy), PlayerGui (copy), StringLibrary (copy), t (copy), Quest_2 (copy), TierUtility (copy), Objective (copy), getData (copy), modifyImageLabel (copy), GuiControl (copy), Tracking (copy), t4 (copy), ReplicatedStorage (copy), Inside (copy), t2 (copy), v2 (copy), TweenUtil (copy), Replion (copy) ]]
	if not UserPriority:IsTradePlaza() then
		local _ = p2[#p2]
		Trove.new()
		local function UpdateObjectives(p1, p2, p3) --[[ UpdateObjectives | Line: 487 | Upvalues: Quests (ref), DidCompleteAll (ref), PlayerGui (ref), StringLibrary (ref) ]]
			local v1 = nil
			for v2, v3 in Quests do
				if v3[p2] then
					v1 = v2
					break
				end
			end
			local v4 = if v1 then Quests[v1][p2] else v1
			if not v4 then
				return
			end
			local v5 = DidCompleteAll(v1, p2, p3)
			local v6 = p1.Content
			for v8, v9 in v4.Objectives do
				local v7
				local v10 = p3.Objectives[v8]
				if v10 then
					local v11 = v6:FindFirstChild((("Objective%*"):format(v8)))
					if v11 then
						local BarFrame = v11.BarFrame
						local v12 = v11.Content
						local v13 = if v5 then true elseif v10.Progress >= v9.Goal then true else false
						v12.Check.Vector.Visible = v13
						v12.Check.Outline.UIStroke.UIGradient.Enabled = v13
						local v14 = if v9.Goal > 1 then true else false
						if v14 then
							v7 = if v13 then 1 else math.clamp(v10.Progress / v9.Goal, 0, 1)
							if BarFrame:IsDescendantOf(PlayerGui) then
								BarFrame.Bar:TweenSize(UDim2.fromScale(v7, 0.8))
							else
								BarFrame.Bar.Size = UDim2.fromScale(v7, 0.8)
							end
							BarFrame.Bar.Visible = if v7 > 0 then true else false
						end
						BarFrame.Progress.Text = ("%* / %*"):format(StringLibrary:AddCommas(v10.Progress), (StringLibrary:AddCommas(v9.Goal)))
						BarFrame.Progress.Visible = if v9.Goal >= 10 then true else false
						BarFrame.Visible = v14
					end
				end
			end
		end
		local function AddQuest(p1, p2) --[[ AddQuest | Line: 544 | Upvalues: Quests (ref), t (ref), UpdateObjectives (copy), Quest_2 (ref), TierUtility (ref), Objective (ref), getData (ref), modifyImageLabel (ref), StringLibrary (ref), GuiControl (ref), Tracking (ref), t4 (ref), ReplicatedStorage (ref), Inside (ref), t2 (ref), v2 (ref) ]]
			local v1 = nil
			for v22, v3 in Quests do
				if v3[p1] then
					v1 = v22
					break
				end
			end
			if not v1 then
				return
			end
			local v4 = Quests[v1][p1]
			if p2.LimitedEventQuest then
				return
			end
			local v5 = t[p1]
			if v5 then
				UpdateObjectives(v5, p1, p2)
				return
			end
			local v6 = Quest_2:Clone()
			local v7 = v6.Content
			local TopFrame = v6.Top.TopFrame
			t[p1] = v6
			local v8 = if v4.AssociatedTier then TierUtility:GetTier(v4.AssociatedTier) else nil
			local v10 = false
			for v11, v12 in v4.Objectives do
				if v12.TrackQuestCFrame or v12.TrackNPC then
					v10 = true
					break
				end
			end
			for v13, v14 in v4.Objectives do
				if p2.Objectives[v13] then
					local v15 = Objective:Clone()
					local VectorFrame = v15.Content.VectorFrame
					local Display = v15.Content.Display
					v15.Name = ("Objective%*"):format(v13)
					local _, v16, v17, v18, v19 = getData(v14)
					if v16 then
						Display.ItemName.UIGradient.Color = v16
					end
					if v17 then
						modifyImageLabel(v18, VectorFrame.Vector)
						if v14.Goal > 1 then
							VectorFrame.Quantity.Text = StringLibrary:Shorten(v14.Goal)
						end
						VectorFrame.Vector.Image = v17
						VectorFrame.Quantity.Visible = if v14.Goal > 1 then true else false
						VectorFrame.Visible = true
					else
						VectorFrame.Visible = false
					end
					if #v19 == 0 then
						Display.Prefix.Text = v14.Name
						Display.Prefix.Visible = true
						Display.ItemName.Visible = false
						Display.Suffix.Visible = false
					else
						for v21, v22 in { "Prefix", "ItemName", "Suffix" } do
							local v23 = Display[v22]
							local v24 = v19[v21]
							if v24 then
								v23.Text = v24
							end
							v23.Visible = if v24 == nil then false else true
						end
					end
					v15.Parent = v7
					continue
				end
				warn("Skipped because", p1, "missing value of", v13)
			end
			UpdateObjectives(v6, p1, p2)
			if v10 then
				local v26 = GuiControl:Hook("Hold Button", TopFrame.QuestionButton)
				v26.Cleaner:Add(function() --[[ Line: 642 | Upvalues: Tracking (ref), p1 (copy) ]]
					if Tracking:GetLastQuestName() ~= p1 then
						return
					end
					Tracking:Stop()
				end)
				v26.Clicked:Connect(function() --[[ Line: 648 | Upvalues: Tracking (ref), p1 (copy), t4 (ref), v1 (copy) ]]
					if Tracking:GetLastQuestName() == p1 then
						Tracking:Stop()
					else
						t4:StartTracking_SMART(v1, p1)
					end
				end)
			end
			TopFrame.QuestionButton.Visible = v10
			TopFrame.Header.Text = p1
			if v8 then
				v6.Line.UIGradient.Color = v8.TierColor
			end
			if v8 and v8.Tier > 1 then
				local v27 = math.clamp(v8.Tier, 1, 3)
				local Star1 = TopFrame:FindFirstChild("Star1")
				if Star1 then
					Star1:Destroy()
				end
				local v28 = ReplicatedStorage.Assets.UITemplates:FindFirstChild((("Star%*"):format(v27)))
				if v28 then
					local Star1_2 = v28:Clone()
					Star1_2.Name = "Star1"
					Star1_2.Parent = TopFrame
				end
			end
			v6.Parent = Inside
			table.insert(t2, p1)
			v2:Fire()
		end
		local function RemoveQuest(p1, p2) --[[ RemoveQuest | Line: 693 | Upvalues: t (ref), v2 (ref), t2 (ref), TweenUtil (ref) ]]
			local v1 = t[p1]
			local function clean() --[[ clean | Line: 701 | Upvalues: v1 (copy), v2 (ref), t2 (ref), p1 (copy), t (ref) ]]
				if v1 then
					v1:Destroy()
					v2:Fire()
				end
				local v12 = table.find(t2, p1)
				if v12 then
					table.remove(t2, v12)
				end
				t[p1] = nil
			end
			if v1 then
				task.delay(0.5, TweenUtil.TweenPadding, v1.UIPadding, 500, "Left", TweenInfo.new(0.3), function() --[[ Line: 714 | Upvalues: v1 (copy), v2 (ref), t2 (ref), p1 (copy), t (ref) ]]
					task.wait(0.5)
					if v1 then
						v1:Destroy()
						v2:Fire()
					end
					local v12 = table.find(t2, p1)
					if not v12 then
						t[p1] = nil
						return
					end
					table.remove(t2, v12)
					t[p1] = nil
				end)
			end
			if v1 then
				return
			end
			if v1 then
				v1:Destroy()
				v2:Fire()
			end
			local v22 = table.find(t2, p1)
			if v22 then
				table.remove(t2, v22)
			end
			t[p1] = nil
		end
		Replion.Client:AwaitReplion("Data", function() --[[ Line: 725 | Upvalues: t4 (ref), p2 (copy), AddQuest (copy), RemoveQuest (copy) ]]
			t4:RegisterCallbacksForPath(p2, AddQuest, RemoveQuest, true)
		end)
	end
end
function t4.RegisterCallbacksForPath(p1, p2, p3, p4, p5) --[[ RegisterCallbacksForPath | Line: 735 | Upvalues: UserPriority (copy), v3 (ref), Replion (copy), TableUtil (copy), t2 (copy), t4 (copy), DidCompleteTutorialObjective (copy), Soundbook (copy) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	if not v3 then
		v3 = Replion.Client:WaitReplion("Data")
	end
	local function QuestsChanged(p1, p2) --[[ QuestsChanged | Line: 744 | Upvalues: v3 (ref), TableUtil (ref), t2 (ref), p5 (copy), t4 (ref), p3 (copy), p4 (copy), DidCompleteTutorialObjective (ref), Soundbook (ref) ]]
		local v1 = v3:GetExpect("CompletedQuests")
		local v2 = TableUtil.IntersectDictionary(p2, p1)
		for i = #v2, 1, -1 do
			local v32 = v2[i]
			if table.find(v1, v32) and not table.find(t2, v32) then
				if not p5 then
					local v4 = t4:GetCompletedQuestsCopy()
					if v4[v32] then
						p3(v32, v4[v32])
					end
				end
				continue
			end
			local v5 = p2[v32]
			if v5 and p4 then
				p4(v32, v5)
			end
		end
		for v6, v7 in p1 do
			local v8 = p2[v6]
			if v8 and DidCompleteTutorialObjective(v6, v8, v7) then
				Soundbook.Sounds.TutorialQuestCompleted:Play()
			end
			if v7.Claimed then
				if p4 then
					Soundbook.Sounds.QuestCompleted:Play()
					p4(v6, v7)
				end
				continue
			end
			p3(v6, v7)
		end
	end
	v3:OnChange(p2, QuestsChanged)
	QuestsChanged(v3:GetExpect(p2), {})
	if p5 then
		return
	end
	for v1, v2 in t4:GetCompletedQuestsCopy() do
		p3(v1, v2)
	end
end
function t4.GetCompletedQuestsCopy(p1) --[[ GetCompletedQuestsCopy | Line: 805 | Upvalues: v3 (ref), Quests (copy) ]]
	local t = {}
	for v1, v2 in v3:GetExpect("CompletedQuests") do
		local v32 = if Quests.Mainline[v2] then "Mainline" elseif Quests.Event[v2] then "Event" else nil
		if v32 then
			local v4 = Quests[v32][v2]
			if v4 then
				local t2 = {}
				for v5, v6 in v4.Objectives do
					table.insert(t2, {
						Id = v5,
						Progress = v6.Goal
					})
				end
				t[v2] = {
					Objectives = t2,
					CurrentObj = #t2,
					Timestamp = v4.Expires
				}
			end
		end
	end
	return t
end
function t4.Disable(p1) --[[ Disable | Line: 838 | Upvalues: v4 (ref), List (copy), v5 (ref) ]]
	v4 = false
	List.Visible = v4 and v5 == 0
end
function t4.Enable(p1) --[[ Enable | Line: 843 | Upvalues: UserPriority (copy), v4 (ref), List (copy), v5 (ref) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	v4 = true
	List.Visible = v4 and v5 == 0
end
function t4.SetEnabled(p1, p2) --[[ SetEnabled | Line: 852 | Upvalues: t4 (copy) ]]
	if p2 then
		t4:Enable()
	else
		t4:Disable()
	end
end
function t4.Toggle(p1) --[[ Toggle | Line: 860 | Upvalues: v4 (ref), List (copy), v5 (ref) ]]
	v4 = not v4
	List.Visible = v4 and v5 == 0
end
function t4.IsEnabled(p1) --[[ IsEnabled | Line: 865 | Upvalues: List (copy) ]]
	return List.Visible
end
function t4.Suppress(p1, p2) --[[ Suppress | Line: 869 | Upvalues: t3 (copy), v5 (ref), List (copy), v4 (ref) ]]
	if t3[p2] then
		return
	end
	t3[p2] = true
	v5 = v5 + 1
	List.Visible = v4 and v5 == 0
end
function t4.Unsuppress(p1, p2) --[[ Unsuppress | Line: 879 | Upvalues: t3 (copy), v5 (ref), List (copy), v4 (ref) ]]
	if not t3[p2] then
		return
	end
	t3[p2] = nil
	v5 = math.max(v5 - 1, 0)
	List.Visible = v4 and v5 == 0
end
function t4.deviceChanged() --[[ deviceChanged | Line: 889 | Upvalues: Device (copy), Quest (copy) ]]
	if Device:IsMobile() then
		Quest.List.Inside.Size = UDim2.fromScale(1.8, 0.5)
		Quest.List.Position = UDim2.fromScale(1, 0.38)
		Quest.List.UIScale.Scale = 0.7
	else
		Quest.List.Inside.Size = UDim2.fromScale(1.2, 0.4)
		Quest.List.Position = UDim2.fromScale(1, 0.5)
		Quest.List.UIScale.Scale = 0.8
	end
end
t4.DidCompleteAll = DidCompleteAll
t4.GetQuestTypeFromName = GetQuestTypeFromName
t4.getData = getData
return t4