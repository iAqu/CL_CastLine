local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local FishInventoryData = require(ReplicatedStorage.Modules.FishInventoryData)
local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local RarityConfig = require(ReplicatedStorage.Modules.RarityConfig)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local indexGui = playerGui:WaitForChild("IndexGui_New")
local rootFrame = indexGui:WaitForChild("Frame")
local mainFrame = rootFrame:WaitForChild("MainFrame")
local itemsFrame = mainFrame:WaitForChild("PetsFrame")
local template = itemsFrame:WaitForChild("PetTemplate")
local templateStroke = template.PetButton.BackgroundFrame:WaitForChild("UIStroke") :: UIStroke
local defaultStrokeColor = templateStroke.Color
local defaultStrokeThickness = templateStroke.Thickness
local detailFrame = mainFrame:WaitForChild("DetailFrame")
local detailIcon = detailFrame:WaitForChild("ViewportFrame"):WaitForChild("Icon") :: ImageLabel
local claimButton = detailFrame:WaitForChild("ClaimButton") :: TextButton
local claimBackground = claimButton:WaitForChild("BG")
local claimableGradient = claimBackground:WaitForChild("ClaimableGradient") :: UIGradient
local disabledGradient = claimBackground:WaitForChild("DisabledGradient") :: UIGradient
local progressFrame = mainFrame:WaitForChild("ProgressFrame")
local progressBar = progressFrame:WaitForChild("ProgressBar") :: GuiObject
local progressBarHeight = progressBar.Size.Y
local progressLabel = progressFrame:WaitForChild("ProgressLabel") :: TextLabel

type CollectionProgress = { CollectedCount: number, TotalCount: number }

local discoveryLog: { [string]: boolean } = {}
local rewardClaimLog: { [string]: boolean } = {}
local pendingClaims: { [string]: boolean } = {}
local missingIcons: { [string]: boolean } = {}
local entries: { [string]: Frame } = {}
local collectionProgress: CollectionProgress? = nil
local selectedItemId: string? = nil
local stateReady = false
local hasOpened = false
local scrollGeneration = 0

local IndexGuiController = Knit.CreateController({ Name = "IndexGuiController" })

local function getOrderedItemIds(): { string }
	local itemIds = {}
	for itemId in pairs(FishInventoryData) do
		table.insert(itemIds, itemId)
	end
	table.sort(itemIds, function(left, right)
		local leftOrder = FishInventoryData[left].LayoutOrder
		local rightOrder = FishInventoryData[right].LayoutOrder
		return if leftOrder == rightOrder then left < right else leftOrder < rightOrder
	end)
	return itemIds
end

local ORDERED_ITEM_IDS = getOrderedItemIds()

local function scrollSelectedIntoView()
	local entry = selectedItemId and entries[selectedItemId]
	local windowHeight = itemsFrame.AbsoluteWindowSize.Y
	if not entry or windowHeight <= 0 then
		return
	end
	local position = itemsFrame.CanvasPosition
	local top = entry.AbsolutePosition.Y - itemsFrame.AbsolutePosition.Y + position.Y
	local height = entry.AbsoluteSize.Y
	-- Leave room for the 1.1 hover scale and the selected border.
	local margin = math.max(8, height * 0.1)
	local targetY = position.Y
	if top - margin < position.Y then
		targetY = top - margin
	elseif top + height + margin > position.Y + windowHeight then
		targetY = top + height + margin - windowHeight
	end
	local maxY = math.max(0, itemsFrame.AbsoluteCanvasSize.Y - windowHeight)
	itemsFrame.CanvasPosition = Vector2.new(position.X, math.clamp(targetY, 0, maxY))
end

local function scheduleSelectedScroll()
	local generation = scrollGeneration
	local function revealCurrentSelection()
		if generation == scrollGeneration and indexGui.Enabled and stateReady then
			scrollSelectedIntoView()
		end
	end
	task.spawn(function()
		RunService.RenderStepped:Wait()
		revealCurrentSelection()
	end)
	-- GuiAnimation's 0.18s opening tween changes the grid's absolute geometry.
	task.delay(0.2, revealCurrentSelection)
end

local function isClaimable(itemId: string): boolean
	return discoveryLog[itemId] == true and rewardClaimLog[itemId] ~= true
end

local function updateHomeNotification()
	local hasReward = false
	for _, itemId in ipairs(ORDERED_ITEM_IDS) do
		if isClaimable(itemId) then
			hasReward = true
			break
		end
	end
	Knit.GetController("HomeGuiController"):ShowIndexNotif(hasReward)
end

local function setIcon(icon: ImageLabel, itemId: string)
	local image = FishInventoryData[itemId].Icon
	icon.Image = if typeof(image) == "string" then image else ""
	icon.ImageColor3 = if discoveryLog[itemId] then Color3.new(1, 1, 1) else Color3.fromRGB(20, 20, 20)
	icon.Visible = true
	if icon.Image == "" and not missingIcons[itemId] then
		missingIcons[itemId] = true
		warn("IndexGuiController: missing fish icon", itemId)
	end
end

local function updateProgressUi()
	local progress = collectionProgress
	if not progress then
		return
	end
	progressLabel.Text = ("Unlocked: %d / %d "):format(progress.CollectedCount, progress.TotalCount)
	local ratio = if progress.TotalCount > 0 then math.clamp(progress.CollectedCount / progress.TotalCount, 0, 1) else 0
	progressBar.Size = UDim2.new(ratio, 0, progressBarHeight.Scale, progressBarHeight.Offset)
end

local function updateEntry(itemId: string)
	local entry = entries[itemId]
	if not entry then
		return
	end
	local button = entry.PetButton
	button.NameLabel.Text = if discoveryLog[itemId] then FishInventoryData[itemId].DisplayName else "???"
	button.Dot.Visible = isClaimable(itemId)
	setIcon(button.Icon, itemId)
end

local function updateDetail()
	local itemId = selectedItemId
	local item = itemId and FishInventoryData[itemId]
	detailFrame.Visible = item ~= nil
	if not item or not itemId then
		return
	end
	detailFrame.NameLabel.Text = if discoveryLog[itemId] then item.DisplayName else "???"
	detailFrame.RarityLabel.Text = RarityConfig.Normalize(item.Rarity)
	detailFrame.RarityLabel.TextColor3 = RarityConfig.Get(item.Rarity).Color
	local reward = math.round((tonumber(item.DefaultPrice) or 0) * 0.5)
	detailFrame.PriceLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(reward)
	setIcon(detailIcon, itemId)

	local available = isClaimable(itemId) and not pendingClaims[itemId]
	claimButton.Active = available
	claimButton.Selectable = available
	claimButton.AutoButtonColor = available
	claimableGradient.Enabled = available
	disabledGradient.Enabled = not available
	claimButton.NameLabel.Text = if not discoveryLog[itemId] then "LOCKED"
		elseif rewardClaimLog[itemId] then "CLAIMED"
		elseif pendingClaims[itemId] then "CLAIMING..."
		else "CLAIM"
end

local function selectItem(itemId: string)
	if selectedItemId then
		local previousStroke = entries[selectedItemId].PetButton.BackgroundFrame.UIStroke
		previousStroke.Color = defaultStrokeColor
		previousStroke.Thickness = defaultStrokeThickness
	end
	selectedItemId = itemId
	local stroke = entries[itemId].PetButton.BackgroundFrame.UIStroke
	stroke.Color = Color3.fromRGB(255, 215, 0)
	stroke.Thickness = 0.05
	GuiAnimation.SetNavigationOptions(indexGui, entries[itemId].PetButton)
	updateDetail()
end

local function selectDefaultItem()
	local firstDiscovered: string? = nil
	for _, itemId in ipairs(ORDERED_ITEM_IDS) do
		if isClaimable(itemId) then
			selectItem(itemId)
			return
		end
		if discoveryLog[itemId] and not firstDiscovered then
			firstDiscovered = itemId
		end
	end
	local fallback = firstDiscovered or ORDERED_ITEM_IDS[1]
	if fallback then
		selectItem(fallback)
	end
end

local function claimReward()
	local itemId = selectedItemId
	if not itemId or not isClaimable(itemId) or pendingClaims[itemId] then
		return
	end
	pendingClaims[itemId] = true
	updateDetail()
	Knit.GetService("IndexService"):ClaimIndexReward(itemId):andThen(function(result)
		pendingClaims[itemId] = nil
		if result and result.IsSuccess then
			rewardClaimLog[itemId] = true
			updateEntry(itemId)
			updateHomeNotification()
			NotificationClient.GreenNotify(result.ResultText)
		elseif result then
			NotificationClient.RedNotify(result.ResultText)
		end
		updateDetail()
	end):catch(function(err)
		pendingClaims[itemId] = nil
		updateDetail()
		warn("IndexGuiController: failed to claim index reward", err)
	end)
end

local function createEntries()
	for rank, itemId in ipairs(ORDERED_ITEM_IDS) do
		local entry = template:Clone()
		entry.Name = "IndexItem_" .. itemId
		-- Sequential ranks also make equal LayoutOrder values deterministic in UIGridLayout.
		entry.LayoutOrder = rank
		entry.Visible = true
		entry.PetButton.Selectable = true
		GuiUtil.SetRarityGradient(entry.PetButton.BackgroundFrame, FishInventoryData[itemId].Rarity)
		ButtonAnimation.SetUp(entry.PetButton, 1.1)
		entry.Parent = itemsFrame
		entries[itemId] = entry
		entry.PetButton.Activated:Connect(function()
			selectItem(itemId)
		end)
		updateEntry(itemId)
	end
end

function IndexGuiController:KnitStart()
	local oldGui = playerGui:FindFirstChild("IndexGui")
	if oldGui then
		oldGui.Enabled = false
	end
	template.Visible = false
	template.PetButton.Selectable = false
	detailFrame.Visible = false
	updateHomeNotification()
	GuiAnimation.Setup(indexGui)
	indexGui.Enabled = false

	rootFrame.CloseButton.Activated:Connect(function()
		GuiAnimation.CloseGui(indexGui)
	end)
	claimButton.Activated:Connect(claimReward)
	indexGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		scrollGeneration += 1
		if not indexGui.Enabled or not stateReady then
			return
		end
		if not hasOpened then
			selectDefaultItem()
			hasOpened = true
		end
		scheduleSelectedScroll()
	end)

	local indexService = Knit.GetService("IndexService")
	indexService.IndexDiscovered:Connect(function(itemId: string, progress: CollectionProgress)
		if FishInventoryData[itemId] then
			discoveryLog[itemId] = true
			collectionProgress = progress
			updateEntry(itemId)
			updateDetail()
			updateProgressUi()
			updateHomeNotification()
		end
	end)
	indexService.IndexRewardClaimed:Connect(function(itemId: string)
		if FishInventoryData[itemId] then
			rewardClaimLog[itemId] = true
			updateEntry(itemId)
			updateDetail()
			updateHomeNotification()
		end
	end)

	indexService:GetIndexState():andThen(function(state)
		if not state then
			warn("IndexGuiController: index state is unavailable")
			return
		end
		-- Preserve events received while the initial request was in flight.
		for itemId, discovered in pairs(state.DiscoveryLog or {}) do
			if discovered == true then
				discoveryLog[itemId] = true
			end
		end
		for itemId, claimed in pairs(state.RewardClaimLog or {}) do
			if claimed == true then
				rewardClaimLog[itemId] = true
			end
		end
		if not collectionProgress or state.CollectionProgress.CollectedCount >= collectionProgress.CollectedCount then
			collectionProgress = state.CollectionProgress
		end
		createEntries()
		stateReady = true
		selectDefaultItem()
		hasOpened = indexGui.Enabled
		if indexGui.Enabled then
			scheduleSelectedScroll()
		end
		updateProgressUi()
		updateHomeNotification()
	end):catch(function(err)
		warn("IndexGuiController: failed to get index state", err)
	end)
end

return IndexGuiController
