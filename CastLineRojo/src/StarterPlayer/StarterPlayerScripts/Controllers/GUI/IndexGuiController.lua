local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local RarityConfig = require(ReplicatedStorage.Modules.RarityConfig)
local IndexItemViewport = require(ReplicatedStorage.Modules.IndexItemViewport)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local indexGui = playerGui:WaitForChild("IndexGui")
local rootFrame = indexGui:WaitForChild("Frame")
local mainFrame = rootFrame:WaitForChild("MainFrame")
local itemsFrame = mainFrame:WaitForChild("PetsFrame")
local template = itemsFrame:WaitForChild("PetTemplate")
local bottomFrame = rootFrame:WaitForChild("BottomFrame_New")
local progressFrame = bottomFrame:WaitForChild("ProgressFrame")
local progressBar = progressFrame:WaitForChild("ProgressBar") :: GuiObject
local collectLabel = progressFrame:WaitForChild("CollectLabel") :: TextLabel
local progressLabel = progressFrame:WaitForChild("ProgressLabel") :: TextLabel

type RewardProgress = {
	CollectedCount: number,
	TotalCount: number,
	UnlockedLuck: number,
	TierCollected: number,
	TierRequired: number,
	NextLuckIncrease: number,
	IsMax: boolean,
}

local discoveryLog: { [string]: boolean } = {}
local rewardClaimLog: { [string]: boolean } = {}
local entries: { [string]: Frame } = {}
local rewardProgress: RewardProgress? = nil

local IndexGuiController = Knit.CreateController({
	Name = "IndexGuiController",
})

local function getOrderedItemIds(): { string }
	local itemIds = {}
	for itemId in pairs(FishInventoryData) do
		table.insert(itemIds, itemId)
	end
	table.sort(itemIds, function(left, right)
		local leftItem = FishInventoryData[left]
		local rightItem = FishInventoryData[right]
		if leftItem.LayoutOrder ~= rightItem.LayoutOrder then
			return leftItem.LayoutOrder < rightItem.LayoutOrder
		end
		return left < right
	end)
	return itemIds
end

local ORDERED_ITEM_IDS = getOrderedItemIds()

local function hasClaimableReward(): boolean
	for _, itemId in ipairs(ORDERED_ITEM_IDS) do
		if discoveryLog[itemId] == true and rewardClaimLog[itemId] ~= true then
			return true
		end
	end
	return false
end

local function updateHomeNotification()
	Knit.GetController("HomeGuiController"):ShowIndexNotif(hasClaimableReward())
end

local function setText(instance: Instance?, value: string)
	if instance and instance:IsA("TextLabel") then
		instance.Text = value
	end
end

local function updateProgressUi()
	local progress = rewardProgress
	if not progress then
		return
	end

	collectLabel.Text = ("Collect: %d / %d "):format(progress.CollectedCount, progress.TotalCount)
	local progressRatio = 1
	if progress.IsMax then
		progressLabel.Text = ("Max Index Luck: +%d%% Luck"):format(math.round(progress.UnlockedLuck * 100))
	elseif progress.TierRequired > 0 then
		progressRatio = math.clamp(progress.TierCollected / progress.TierRequired, 0, 1)
		progressLabel.Text = ("Collect %d/%d Items for +%d%% Luck"):format(
			progress.TierCollected,
			progress.TierRequired,
			math.round(progress.NextLuckIncrease * 100)
		)
	else
		progressRatio = 0
	end
	progressBar.Size = UDim2.fromScale(progressRatio, 1)
end

local function updateEntry(itemId: string)
	local entry = entries[itemId]
	local item = FishInventoryData[itemId]
	if not entry or not item then
		return
	end
	local button = entry:FindFirstChild("PetButton")
	if not button or not button:IsA("TextButton") then
		return
	end
	local discovered = discoveryLog[itemId] == true
	setText(button:FindFirstChild("NameLabel"), if discovered then item.DisplayName else "???")
	local rarityLabel = button:FindFirstChild("RarityLabel")
	setText(rarityLabel, RarityConfig.Normalize(item.Rarity))
	if rarityLabel and rarityLabel:IsA("TextLabel") then
		GuiUtil.SetRarityGradient(rarityLabel, item.Rarity)
	end

	local rewardFrame = button:FindFirstChild("RewardFrame")
	if rewardFrame and rewardFrame:IsA("GuiObject") then
		rewardFrame.Visible = discovered and rewardClaimLog[itemId] ~= true
		setText(rewardFrame:FindFirstChild("CountLabel"), ("$%d"):format(math.round((tonumber(item.DefaultPrice) or 0) * 0.5)))
	end

	local icon = button:FindFirstChild("Icon")
	if icon and icon:IsA("ImageLabel") then
		icon.Visible = true
		IndexItemViewport.Show(button, icon, item.Model, discovered)
	end
end

local function claimReward(itemId: string)
	if not discoveryLog[itemId] or rewardClaimLog[itemId] then
		return
	end
	Knit.GetService("IndexService"):ClaimIndexReward(itemId):andThen(function(result)
		if result and result.IsSuccess then
			rewardClaimLog[itemId] = true
			updateEntry(itemId)
			updateHomeNotification()
			NotificationClient.GreenNotify(result.ResultText)
		elseif result then
			NotificationClient.RedNotify(result.ResultText)
		end
	end):catch(function(err)
		warn("IndexGuiController: failed to claim index reward", err)
	end)
end

local function createEntries()
	template.Visible = false
	for _, child in ipairs(itemsFrame:GetChildren()) do
		if child:IsA("Frame") and child ~= template then
			child:Destroy()
		end
	end

	for _, itemId in ipairs(ORDERED_ITEM_IDS) do
		local item = FishInventoryData[itemId]
		local entry = template:Clone()
		entry.Name = "IndexItem_" .. itemId
		entry.LayoutOrder = item.LayoutOrder
		entry.Visible = true
		entry.Parent = itemsFrame
		entries[itemId] = entry
		local button = entry:FindFirstChild("PetButton")
		if button and button:IsA("TextButton") then
			button.Activated:Connect(function()
				claimReward(itemId)
			end)
		end
		updateEntry(itemId)
	end
end

function IndexGuiController:KnitStart()
	-- Hide Studio's default dot until the authoritative Index state has arrived.
	updateHomeNotification()

	local sortFrame = mainFrame:FindFirstChild("SortFrame")
	if sortFrame and sortFrame:IsA("GuiObject") then
		sortFrame.Visible = false
	end
	local filterFrame = mainFrame:FindFirstChild("FilterFrame")
	if filterFrame and filterFrame:IsA("GuiObject") then
		filterFrame.Visible = false
	end

	local closeButton = rootFrame:FindFirstChild("CloseButton")
	if closeButton and closeButton:IsA("GuiButton") then
		closeButton.Activated:Connect(function()
			GuiAnimation.CloseGui(indexGui)
		end)
	end

	local indexService = Knit.GetService("IndexService")
	indexService.IndexDiscovered:Connect(function(itemId: string, updatedRewardProgress: RewardProgress)
		if FishInventoryData[itemId] and not discoveryLog[itemId] then
			discoveryLog[itemId] = true
			rewardProgress = updatedRewardProgress
			updateEntry(itemId)
			updateProgressUi()
			updateHomeNotification()
		end
	end)
	indexService.IndexRewardClaimed:Connect(function(itemId: string)
		if FishInventoryData[itemId] then
			rewardClaimLog[itemId] = true
			updateEntry(itemId)
			updateHomeNotification()
		end
	end)

	indexService:GetIndexState():andThen(function(state)
		if not state then
			warn("IndexGuiController: index state is unavailable")
			return
		end
		discoveryLog = state.DiscoveryLog or {}
		rewardClaimLog = state.RewardClaimLog or {}
		rewardProgress = state.RewardProgress
		createEntries()
		updateProgressUi()
		updateHomeNotification()
	end):catch(function(err)
		warn("IndexGuiController: failed to get index state", err)
	end)

	GuiAnimation.Setup(indexGui)
	indexGui.Enabled = false
end

return IndexGuiController
