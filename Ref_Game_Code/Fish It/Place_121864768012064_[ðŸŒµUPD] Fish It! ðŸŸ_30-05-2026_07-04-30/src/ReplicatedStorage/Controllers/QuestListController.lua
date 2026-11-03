-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Quests = require(ReplicatedStorage.Modules.Quests)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
require(ReplicatedStorage.Modules.ItemStringUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local Device = require(ReplicatedStorage.Modules.Device)
local v1 = nil
local v2 = nil
local v3 = nil
local v4 = nil
local LocalPlayer = Players.LocalPlayer
local v5 = nil
local v6 = Net:RemoteFunction("RF_ClaimMegalodonQuest")
local v7 = LocalPlayer.PlayerGui:WaitForChild("QuestList"):WaitForChild("Background"):WaitForChild("Content")
local List = v7:WaitForChild("Left"):WaitForChild("List")
local EmptyBackground = v7:WaitForChild("EmptyBackground")
local Right = v7:WaitForChild("Right")
local List_2 = Right:WaitForChild("ImageLabel"):WaitForChild("List")
local Template = List:WaitForChild("Template")
Template.Parent = nil
local Objective = List_2:WaitForChild("Objective")
Objective.Parent = nil
local v8 = Trove.new()
local v9 = false
local v10 = nil
local v11 = nil
local v12 = "Mainline"
local v13 = Signal.new()
local t = {}
local t2 = {}
local t3 = {}
local function modifyImageLabel(p1, p2) --[[ modifyImageLabel | Line: 78 ]]
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
local function updateCounts() --[[ updateCounts | Line: 90 | Upvalues: v5 (ref), TableUtil (copy), v7 (copy) ]]
	local v1 = v5:GetExpect({ "Quests" })
	local v2 = TableUtil.Count(v1.Mainline)
	local v3 = TableUtil.Count(v1.Event)
	v7.Buttons.Mainline.Amount.Text = ("Main (%*)"):format(v2)
	v7.Buttons.Event.Amount.Text = ("Event (%*)"):format(v3)
end
function t3.Init(p1) --[[ Init | Line: 99 | Upvalues: UserPriority (copy), v1 (ref), ReplicatedStorage (copy), v3 (ref), v2 (ref), v4 (ref), v13 (copy), v12 (ref), t (copy), updateCounts (copy) ]]
	if not UserPriority:IsTradePlaza() then
		v1 = require(ReplicatedStorage.Controllers.TextNotificationController)
		v3 = require(ReplicatedStorage.Controllers.MainlineQuestController)
		v2 = require(ReplicatedStorage.Controllers.DialogueController)
		v4 = require(ReplicatedStorage.Controllers.MainlineQuestController.Tracking)
		v13:Connect(function() --[[ Line: 109 | Upvalues: v12 (ref), t (ref), updateCounts (ref) ]]
			local v1 = v12
			for k, v in pairs(t) do
				v.Visible = v:GetAttribute("QuestType") == v1
			end
			updateCounts()
		end)
	end
end
function t3.Start(p1) --[[ Start | Line: 119 | Upvalues: v5 (ref), Replion (copy), UserPriority (copy), Device (copy), t3 (copy), GuiControl (copy), v7 (copy), updateCounts (copy), v2 (ref), v1 (ref), LocalPlayer (copy), PlayerStatsUtility (copy), v6 (copy), Right (copy), v11 (ref), v4 (ref), v12 (ref), v3 (ref) ]]
	v5 = Replion.Client:WaitReplion("Data")
	if not UserPriority:IsTradePlaza() then
		Device:RegisterDeviceChanged(t3.deviceChanged)
		t3.deviceChanged()
		t3:observeQuestline({ "Quests", "Mainline" })
		t3:observeQuestline({ "Quests", "Event" })
		GuiControl:Hook("Hold Button", v7.Buttons.Mainline).Clicked:Connect(function() --[[ Line: 132 | Upvalues: t3 (ref) ]]
			t3:Display("Mainline")
		end)
		GuiControl:Hook("Hold Button", v7.Buttons.Event).Clicked:Connect(function() --[[ Line: 136 | Upvalues: t3 (ref) ]]
			t3:Display("Event")
		end)
		GuiControl.GuiUnfocusedSignal:Connect(function() --[[ Line: 140 | Upvalues: t3 (ref) ]]
			t3:Unfocus(true)
		end)
		t3:Unfocus(true)
		v5:OnChange({ "Quests" }, updateCounts)
		updateCounts()
		v2:ObservePath("Ron", 1, function(p1) --[[ Line: 149 | Upvalues: v5 (ref), v1 (ref), LocalPlayer (ref), PlayerStatsUtility (ref), v6 (ref) ]]
			if p1 ~= 3 then
				return
			end
			if v5:Get("MegaAwarded") then
				v1:DeliverNotification({
					Type = "Text",
					Text = "Already claimed!",
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
				return
			end
			if v5:GetExpect("Level") < 300 then
				v1:DeliverNotification({
					Type = "Text",
					Text = "Requires Level 300",
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
				return
			end
			local UserId = LocalPlayer.UserId
			local v12 = false
			if PlayerStatsUtility:GetItemFromInventory(v5, function(p1) --[[ Line: 169 | Upvalues: UserId (copy), v12 (ref) ]]
				if p1.Id ~= 226 then
					return false
				end
				if p1.Metadata and (p1.Metadata.OriginalOwner and p1.Metadata.OriginalOwner ~= UserId) then
					v12 = true
					return false
				else
					return true
				end
			end, "Items") then
				if v6:InvokeServer() then
					v1:DeliverNotification({
						Type = "Text",
						Text = "Completed!",
						CustomDuration = 10,
						CustomSFX = "QuestCompleted",
						TextColor = {
							R = 0,
							G = 255,
							B = 0
						}
					})
				else
					v1:DeliverNotification({
						Type = "Text",
						Text = "Not gonna cut it kid.",
						CustomDuration = 10,
						TextColor = {
							R = 255,
							G = 0,
							B = 0
						}
					})
				end
			else
				v1:DeliverNotification({
					Type = "Text",
					CustomDuration = 10,
					CustomSFX = "Error",
					Text = if v12 then "You must catch 2/2 Megalodons yourself." else "You don\'t even have a single Megalodon?",
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
			end
		end)
		local v13 = GuiControl:Hook("Hold Button", Right.ImageLabel.QuestionButton)
		v13.Cleaner:Add(function() --[[ Line: 217 | Upvalues: v11 (ref), v4 (ref) ]]
			if v11 ~= v4:GetLastQuestName() then
				return
			end
			v4:Stop()
		end)
		v13.Clicked:Connect(function() --[[ Line: 225 | Upvalues: v12 (ref), v11 (ref), v4 (ref), v3 (ref) ]]
			local v1 = v12
			local v2 = v11
			if v4:GetLastQuestName() == v2 then
				v4:Stop()
			else
				v3:StartTracking_SMART(v1, v2)
			end
		end)
	end
end
function t3.Display(p1, p2) --[[ Display | Line: 237 | Upvalues: v12 (ref), v13 (copy) ]]
	if p2 ~= v12 then
		v12 = p2
		v13:Fire()
	end
end
function t3.Unfocus(p1, p2) --[[ Unfocus | Line: 246 | Upvalues: Right (copy), v8 (copy), v10 (ref), v11 (ref), EmptyBackground (copy) ]]
	Right.Visible = false
	v8:Clean()
	if not p2 then
		Right.Visible = false
		EmptyBackground.Visible = not Right.Visible
		return
	end
	v10 = nil
	v11 = nil
	Right.Visible = false
	EmptyBackground.Visible = not Right.Visible
end
function t3.Toggle(p1, p2, p3) --[[ Toggle | Line: 259 | Upvalues: v10 (ref), t3 (copy) ]]
	if ("%*%*"):format(p2, p3) == v10 then
		t3:Unfocus(true)
	else
		t3:Focus(p2, p3)
	end
end
function t3.Focus(p1, p2, p3) --[[ Focus | Line: 268 | Upvalues: UserPriority (copy), Quests (copy), v9 (ref), v10 (ref), v11 (ref), t3 (copy), v3 (ref), t2 (copy), v8 (copy), Objective (copy), List_2 (copy), CurrencyUtility (copy), StringLibrary (copy), ItemUtility (copy), TierUtility (copy), ReplicatedStorage (copy), modifyImageLabel (copy), v5 (ref), Right (copy), EmptyBackground (copy) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	local v1 = Quests[p2][p3]
	if not v1 then
		return
	end
	if v9 then
		return
	end
	local v2 = ("%*%*"):format(p2, p3)
	v9 = true
	v10 = v2
	v11 = p3
	t3:Unfocus(false)
	local v32 = false
	for v4, v52 in v1.Objectives do
		if v52.TrackQuestCFrame or v52.TrackNPC then
			v32 = true
			break
		end
	end
	local function updateFocus(p1) --[[ updateFocus | Line: 298 | Upvalues: v3 (ref), p2 (copy), p3 (copy), v1 (copy), t2 (ref), v2 (copy), v8 (ref), Objective (ref), List_2 (ref), CurrencyUtility (ref), StringLibrary (ref), ItemUtility (ref), TierUtility (ref), ReplicatedStorage (ref), modifyImageLabel (ref) ]]
		if not p1 then
			return
		end
		local v12 = v3.DidCompleteAll(p2, p3, p1)
		local v22 = v3:GetCompletedQuestsCopy()
		local v32 = v1.AssociatedTier or 1
		local v4 = t2[v2]
		if not v4 then
			t2[v2] = {}
			v4 = t2[v2]
			v8:Add(function() --[[ Line: 314 | Upvalues: v4 (ref), t2 (ref), v2 (ref) ]]
				if not v4 then
					t2[v2] = nil
					return
				end
				for v1, v22 in v4 do
					v22:Destroy()
				end
				t2[v2] = nil
			end)
			for v5, v6 in v1.Objectives do
				if if v22[p3] then v22[p3][v5] else p1.Objectives[v5] then
					local v82 = Objective:Clone()
					v82.Parent = List_2
					table.insert(v4, v82)
				end
			end
			for k, v in pairs(if typeof(v1.Reward) == "table" and #v1.Reward >= 1 then v1.Reward else { v1.Reward }) do
				local v10
				local v11 = nil
				local v122 = nil
				local v13 = nil
				local v14, v15, v16, v17, v18
				if v.Type == "Currency" then
					local v19 = CurrencyUtility:GetCurrency(v.Name)
					if v19 then
						local v20 = StringLibrary:Shorten(v.Amount)
						v122 = v19.TextColor
						v13 = v19.Icon
						v11 = v20
					end
					v14 = ReplicatedStorage.Assets.UITemplates.RewardTemplate:Clone()
					v15 = v14.UIStroke.UIGradient
					v16 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
					v15.Color = v16
					v17 = v14.Gradient.UIGradient
					v18 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
					v17.Color = v18
					v14.Box.ItemName.Text = v11 or "???"
					v14.Vector.Image = v13 or ""
					modifyImageLabel(v.Type, v14.Vector)
					v14.Parent = List_2.RewardFrame.List
					v8:Add(v14)
				else
					local v21 = ItemUtility.GetItemDataFromItemType(v.Type, v.Identifier)
					if v21 then
						v10 = if v21.Probability then TierUtility:GetTierFromRarity(v21.Probability.Chance) else TierUtility:GetTier(v21.Data.Tier or 1)
						v13 = v21.Data.Icon
						v122 = v10.TierColor
						v11 = v21.Data.Name
						v32 = math.max(v32, v10.Tier)
						v14 = ReplicatedStorage.Assets.UITemplates.RewardTemplate:Clone()
						v15 = v14.UIStroke.UIGradient
						v16 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
						v15.Color = v16
						v17 = v14.Gradient.UIGradient
						v18 = if v122 then v122 else ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
						v17.Color = v18
						v14.Box.ItemName.Text = v11 or "???"
						v14.Vector.Image = v13 or ""
						modifyImageLabel(v.Type, v14.Vector)
						v14.Parent = List_2.RewardFrame.List
						v8:Add(v14)
					end
				end
			end
		end
		local v25 = if v32 then TierUtility:GetTier(v32) else v32
		if v25 then
			List_2.RewardFrame.UIGradient.Color = v25.TierColor
		else
			List_2.RewardFrame.UIGradient.Color = ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
		end
		for v27, v28 in v1.Objectives do
			local v26
			local v29 = if v22[p3] then v22[p3][v27] else p1.Objectives[v27]
			if v29 then
				local v30 = v4[v27]
				if v30 then
					local BarFrame = v30.BarFrame
					local VectorFrame = v30.Content.VectorFrame
					local Display = v30.Content.Display
					local v31 = if v12 then true elseif v29.Progress >= v28.Goal then true else false
					local v322 = v31 and v28.Goal or (v29.Progress or 0)
					local _, v33, v34, v35, v36 = v3.getData(v28)
					v30.Content.Check.Vector.Visible = v31
					v30.Content.Check.Outline.UIStroke.UIGradient.Enabled = v31
					v26 = if v31 then 1 else math.clamp(v322 / v28.Goal, 0, 1)
					BarFrame.Bar.Size = UDim2.fromScale(v26, 0.8)
					BarFrame.Bar.Visible = if v26 > 0 then true else false
					BarFrame.Progress.Text = ("%* / %*"):format(StringLibrary:AddCommas(v322), (StringLibrary:AddCommas(v28.Goal)))
					BarFrame.Visible = true
					if v33 then
						Display.ItemName.UIGradient.Color = v33
					end
					if v34 then
						VectorFrame.Vector.Image = v34
						modifyImageLabel(v35, VectorFrame.Vector)
						if v28.Goal > 1 then
							VectorFrame.Quantity.Text = StringLibrary:Shorten(v28.Goal)
						end
						VectorFrame.Quantity.Visible = if v28.Goal > 1 then true else false
						VectorFrame.Visible = true
					else
						VectorFrame.Visible = false
					end
					if #v36 == 0 then
						Display.Prefix.Text = v28.Name
						Display.Prefix.Visible = true
						Display.ItemName.Visible = false
						Display.Suffix.Visible = false
						continue
					end
					for v40, v41 in { "Prefix", "ItemName", "Suffix" } do
						local v42 = Display[v41]
						local v43 = v36[v40]
						if v43 then
							v42.Text = v43
						end
						v42.Visible = if v43 == nil then false else true
					end
				end
			end
		end
	end
	local v6 = nil
	if v5:Find("CompletedQuests", p3) then
		local v7 = v3:GetCompletedQuestsCopy()[p3]
		if v7 then
			updateFocus(v7)
		end
	else
		local t = { "Quests", p2, p3 }
		v6 = v5:OnChange(t, updateFocus)
		updateFocus(v5:Get(t))
	end
	v8:Add(function() --[[ Line: 492 | Upvalues: v6 (ref) ]]
		if not v6 then
			return
		end
		v6:Disconnect()
	end)
	Right.ImageLabel.QuestionButton.Visible = v32
	Right.Visible = true
	v9 = false
	EmptyBackground.Visible = not Right.Visible
end
function t3.observeQuestline(p1, p2) --[[ observeQuestline | Line: 508 | Upvalues: UserPriority (copy), Trove (copy), v3 (ref), Quests (copy), t (copy), Template (copy), v12 (ref), TierUtility (copy), GuiControl (copy), t3 (copy), ReplicatedStorage (copy), List (copy) ]]
	if not UserPriority:IsTradePlaza() then
		local _ = p2[#p2]
		Trove.new()
		local function UpdateObjectivesProgress(p1, p2, p3) --[[ UpdateObjectivesProgress | Line: 517 | Upvalues: v3 (ref), Quests (ref) ]]
			local v1 = v3.GetQuestTypeFromName(p2)
			local v2 = if v1 then Quests[v1][p2] else v1
			if not v2 then
				return
			end
			local v32 = v3.DidCompleteAll(v1, p2, p3)
			p1.Completed.Visible = v32
			p1.LayoutOrder = if v32 then 1 else 0
			local BarFrame = p1.BarFrame
			if v32 then
				BarFrame.Bar.Size = UDim2.fromScale(1, 1)
				BarFrame.Bar.Visible = true
				return
			end
			local count = 0
			local sum = 0
			for v6, v7 in v2.Objectives do
				local v8 = p3.Objectives[v6]
				if v8 then
					sum = sum + v8.Progress
					count = count + 1
				end
			end
			local v10 = math.clamp(math.clamp(sum / count, 0, 1) / #p3.Objectives, 0, 1)
			BarFrame.Bar.Size = UDim2.fromScale(v10, 1)
			BarFrame.Bar.Visible = v10 > 0
		end
		v3:RegisterCallbacksForPath(p2, function(p1, p2) --[[ AddQuest | Line: 558 | Upvalues: v3 (ref), Quests (ref), t (ref), UpdateObjectivesProgress (copy), Template (ref), v12 (ref), TierUtility (ref), GuiControl (ref), t3 (ref), ReplicatedStorage (ref), List (ref) ]]
			local v1 = v3.GetQuestTypeFromName(p1)
			if not v1 then
				return
			end
			local v2 = Quests[v1][p1]
			local v32 = t[p1]
			if v32 then
				UpdateObjectivesProgress(v32, p1, p2)
				return
			end
			local v4 = Template:Clone()
			local Top = v4.Top
			v4:SetAttribute("QuestType", v1)
			v4.Visible = v1 == v12
			t[p1] = v4
			local v6 = if v2.AssociatedTier then TierUtility:GetTier(v2.AssociatedTier) else nil
			for v8, v9 in v2.Objectives do
				if v9.TrackQuestCFrame or v9.TrackNPC then
					break
				end
			end
			GuiControl:Hook("Hold Button", v4).Clicked:Connect(function() --[[ Line: 595 | Upvalues: t3 (ref), v1 (copy), p1 (copy) ]]
				t3:Toggle(v1, p1)
			end)
			UpdateObjectivesProgress(v4, p1, p2)
			Top.QuestName.Text = p1
			v4.Desc.Text = v2.Description or ""
			if v6 and v6.Tier > 1 then
				local v10 = math.clamp(v6.Tier, 1, 3)
				local Star1 = Top:FindFirstChild("Star1")
				if Star1 then
					Star1:Destroy()
				end
				local v11 = ReplicatedStorage.Assets.UITemplates:FindFirstChild((("Star%*"):format(v10)))
				if v11 then
					local Star1_2 = v11:Clone()
					Star1_2.Name = "Star1"
					Star1_2.Parent = Top
				end
			end
			v4.Parent = List
		end, function(p1, p2) --[[ RemoveQuest | Line: 635 | Upvalues: v3 (ref), t (ref) ]]
			if v3:GetCompletedQuestsCopy()[p1] then
				return
			end
			local v1 = t[p1]
			if not v1 then
				t[p1] = nil
				return
			end
			v1:Destroy()
			t[p1] = nil
		end, false)
	end
end
function t3.deviceChanged() --[[ deviceChanged | Line: 657 ]] end
return t3