local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local CarryCapacityUtil = require(ReplicatedStorage.Modules.CarryCapacityUtil)
local Constants = require(ReplicatedStorage.Modules.Constants)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MovementSpeedUtil = require(ReplicatedStorage.Modules.MovementSpeedUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local PromptUtil = require(ReplicatedStorage.Modules.PromptUtil)
local ShopHighlightUtil = require(ReplicatedStorage.Modules.ShopHighlightUtil)
local UpgradeShopConfig = require(ReplicatedStorage.Modules.UpgradeShopConfig)

local LOCAL_PLAYER = Players.LocalPlayer
local UPGRADE_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui"):WaitForChild("UpgradeGui") :: ScreenGui
local MAIN_FRAME = UPGRADE_GUI:WaitForChild("Frame") :: Frame
local SPEED_FRAME = MAIN_FRAME:WaitForChild("Speed") :: Frame
local CARRY_FRAME = MAIN_FRAME:WaitForChild("Backpack") :: Frame
local CLOSE_BUTTON = MAIN_FRAME:WaitForChild("Top"):WaitForChild("CloseButton") :: GuiButton
local PROMPT_NAME = "UpgradeShopPrompt"
local PROMPT_ANCHOR_NAME = "UpgradeShopPromptAnchor"
local HIGHLIGHT_NAME = "UpgradeShopPromptHighlight"

local UpgradeShopGuiController = Knit.CreateController({
	Name = "UpgradeShopGuiController",
})

local purchasePending = false
local shopPrompt: ProximityPrompt? = nil
local shopHighlight: Highlight? = nil

local function setMirroredText(frame: Frame, name: string, text: string)
	local label = frame:FindFirstChild(name)
	if label and label:IsA("TextLabel") then
		label.Text = text
	end
	local shadow = frame:FindFirstChild("Shadow" .. name)
	if shadow and shadow:IsA("TextLabel") then
		shadow.Text = text
	end
end

local function setButtonEnabled(button: GuiButton, enabled: boolean)
	button.Active = enabled
	button.AutoButtonColor = enabled
end

local function updateUpgradeFrame(frame: Frame, upgradeId: string)
	local playerData = PlayerDataController:GetData()
	if not playerData then
		return
	end
	local currentLevel = UpgradeShopConfig.GetLevel(playerData, upgradeId)
	for index, amount in ipairs(UpgradeShopConfig.BUNDLE_AMOUNTS) do
		local gainLabel = frame:FindFirstChild(`Air{index}`)
		if gainLabel and gainLabel:IsA("TextLabel") then
			gainLabel.Text = if upgradeId == Constants.UPGRADE_ID.CARRY_WEIGHT
				then `+{amount} kg`
				else `+{amount} Speed`
		end
		local button = frame:FindFirstChild(`Buy{index}`)
		if button and button:IsA("GuiButton") then
			local priceLabel = button:FindFirstChild("Label")
			if priceLabel and priceLabel:IsA("TextLabel") then
				local price = UpgradeShopConfig.GetBundlePrice(upgradeId, currentLevel, amount)
				priceLabel.Text = "$" .. NumberUtil.FormatNumberStartKWithDecimal(price, 1)
			end
			setButtonEnabled(button, not purchasePending)
		end
	end
end

local function updateDisplay()
	local playerData = PlayerDataController:GetData()
	if not playerData then
		return
	end
	local speed = MovementSpeedUtil.GetSpeedAttribute(playerData)
	local capacity = CarryCapacityUtil.GetCapacity(playerData)
	setMirroredText(SPEED_FRAME, "Display", `Speed: {math.round(speed)}`)
	setMirroredText(CARRY_FRAME, "Display", `Carry Weight: {math.round(capacity)}kg`)
	updateUpgradeFrame(SPEED_FRAME, Constants.UPGRADE_ID.MOVE_SPEED)
	updateUpgradeFrame(CARRY_FRAME, Constants.UPGRADE_ID.CARRY_WEIGHT)
end

local function purchase(upgradeId: string, amount: number)
	if purchasePending then
		return
	end
	purchasePending = true
	updateDisplay()
	Knit.GetService("UpgradeService"):PurchaseUpgrade(upgradeId, amount):andThen(function(result)
		if result and result.ok then
			local playerData = PlayerDataController:GetData()
			if playerData and result.newLevel then
				playerData.Upgrades[upgradeId] = result.newLevel
			end
			NotificationClient.GreenNotify(result.message or "Upgraded")
		else
			NotificationClient.RedNotify((result and result.message) or "Upgrade failed")
		end
	end):catch(function()
		NotificationClient.RedNotify("Upgrade failed")
	end):finally(function()
		purchasePending = false
		updateDisplay()
	end)
end

local function bindUpgradeFrame(frame: Frame, upgradeId: string)
	for index, amount in ipairs(UpgradeShopConfig.BUNDLE_AMOUNTS) do
		local button = frame:WaitForChild(`Buy{index}`) :: GuiButton
		ButtonAnimation.SetUp(button)
		button.Activated:Connect(function()
			purchase(upgradeId, amount)
		end)
	end
end

local function setShopHighlightEnabled(enabled: boolean)
	if shopHighlight and shopHighlight.Parent then
		shopHighlight.Enabled = enabled
	end
end

local function createShopPrompt()
	local areas = Workspace:WaitForChild("Areas", 20)
	local items = areas and areas:WaitForChild("Items", 20)
	local shop = items and items:WaitForChild("UpgradeShop", 20)
	if not shop or not shop:IsA("Model") then
		warn("UpgradeShopGuiController: Workspace.Areas.Items.UpgradeShop is missing")
		return
	end

	local pad = shop:FindFirstChild("Pad")
	local hitbox = pad and pad:FindFirstChild("Hitbox")
	if not hitbox or not hitbox:IsA("BasePart") then
		warn("UpgradeShopGuiController: UpgradeShop.Pad.Hitbox is missing")
		return
	end

	local highlightTarget = shop:FindFirstChild("HighlightModel")
	if not highlightTarget or not highlightTarget:IsA("Model") then
		warn("UpgradeShopGuiController: UpgradeShop.HighlightModel is missing")
		return
	end

	local highlight = shop:FindFirstChild(HIGHLIGHT_NAME)
	if not highlight or not highlight:IsA("Highlight") then
		highlight = Instance.new("Highlight")
		highlight.Name = HIGHLIGHT_NAME
		highlight.Parent = shop
	end
	ShopHighlightUtil.Apply(highlight, highlightTarget)
	highlight.Enabled = false
	shopHighlight = highlight

	local promptAnchor = hitbox:FindFirstChild(PROMPT_ANCHOR_NAME)
	if not promptAnchor or not promptAnchor:IsA("BasePart") then
		promptAnchor = Instance.new("Part")
		promptAnchor.Name = PROMPT_ANCHOR_NAME
		promptAnchor.Size = Vector3.one
		promptAnchor.Transparency = 1
		promptAnchor.Anchored = true
		promptAnchor.CanCollide = false
		promptAnchor.CanTouch = false
		promptAnchor.CanQuery = false
		promptAnchor.Parent = hitbox
	end
	promptAnchor.CFrame = CFrame.new(highlightTarget:GetPivot().Position)

	local prompt = PromptUtil.Ensure(promptAnchor, PROMPT_NAME, {
		ActionText = "Open",
		ObjectText = "",
		HoldDuration = 0,
		MaxActivationDistance = PromptUtil.PROMPT_MAX_DISTANCE,
		RequiresLineOfSight = false,
		Enabled = true,
	})
	prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
	shopPrompt = prompt

	prompt.PromptShown:Connect(function()
		if not UPGRADE_GUI.Enabled then
			setShopHighlightEnabled(true)
		end
	end)
	prompt.PromptHidden:Connect(function()
		setShopHighlightEnabled(false)
	end)
	prompt.Triggered:Connect(function(player: Player)
		if player ~= LOCAL_PLAYER or UPGRADE_GUI.Enabled then
			return
		end
		prompt.Enabled = false
		setShopHighlightEnabled(false)
		updateDisplay()
		GuiAnimation.OpenGui(UPGRADE_GUI)
	end)
end

function UpgradeShopGuiController:KnitStart()
	local obsoleteWarmthDisplay = SPEED_FRAME:FindFirstChild("Display3")
	local obsoleteWarmthShadow = SPEED_FRAME:FindFirstChild("ShadowDisplay3")
	if obsoleteWarmthDisplay and obsoleteWarmthDisplay:IsA("GuiObject") then
		obsoleteWarmthDisplay.Visible = false
	end
	if obsoleteWarmthShadow and obsoleteWarmthShadow:IsA("GuiObject") then
		obsoleteWarmthShadow.Visible = false
	end

	ButtonAnimation.SetUp(CLOSE_BUTTON)
	CLOSE_BUTTON.Activated:Connect(function()
		GuiAnimation.CloseGui(UPGRADE_GUI)
	end)
	UPGRADE_GUI:GetPropertyChangedSignal("Enabled"):Connect(function()
		if UPGRADE_GUI.Enabled then
			if shopPrompt then
				shopPrompt.Enabled = false
			end
			setShopHighlightEnabled(false)
		elseif shopPrompt and shopPrompt.Parent then
			shopPrompt.Enabled = true
		end
	end)
	bindUpgradeFrame(SPEED_FRAME, Constants.UPGRADE_ID.MOVE_SPEED)
	bindUpgradeFrame(CARRY_FRAME, Constants.UPGRADE_ID.CARRY_WEIGHT)

	Knit.GetService("UpgradeService").Upgrade:Connect(function()
		task.defer(updateDisplay)
	end)
	Knit.GetService("CarryCapacityService").CapacityRejected:Connect(function(message: string)
		NotificationClient.RedNotify(message)
	end)

	updateDisplay()
	task.spawn(createShopPrompt)
end

return UpgradeShopGuiController
