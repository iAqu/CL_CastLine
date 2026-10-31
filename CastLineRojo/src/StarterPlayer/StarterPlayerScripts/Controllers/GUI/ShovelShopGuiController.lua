local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local ButtonAnimation = require(ReplicatedStorage.Modules.ButtonAnimation)
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local Knit = require(ReplicatedStorage.Packages.Knit)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local PromptUtil = require(ReplicatedStorage.Modules.PromptUtil)
local ShopHighlightUtil = require(ReplicatedStorage.Modules.ShopHighlightUtil)
local ShovelsData = require(ReplicatedFirst.Data.ShovelsData)

local LOCAL_PLAYER = Players.LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local SHOVEL_GUI = PLAYER_GUI:WaitForChild("ShovelShop") :: ScreenGui
local MAIN = SHOVEL_GUI:WaitForChild("Main") :: Frame
local SCROLLING_FRAME = MAIN:WaitForChild("MainFrame"):WaitForChild("ScrollingFrame") :: ScrollingFrame
local SHOVEL_TEMPLATE = SCROLLING_FRAME:WaitForChild("ShovelTemplate") :: Frame
local CLOSE_BUTTON = MAIN:WaitForChild("Top"):WaitForChild("CloseButton") :: GuiButton

local PROMPT_NAME = "ShovelShopPrompt"
local HIGHLIGHT_NAME = "ShovelShopPromptHighlight"
local GENERATED_ATTRIBUTE = "GeneratedShovelShopItem"

local ShovelShopGuiController = Knit.CreateController({
	Name = "ShovelShopGuiController",
})

local generatedFrames: { [string]: Frame } = {}
local requestPending = false
local shopPrompt: ProximityPrompt? = nil
local shopHighlight: Highlight? = nil

local function setButtonEnabled(button: GuiButton, enabled: boolean)
	button.Active = enabled
	button.AutoButtonColor = enabled
end

local function setShopHighlightEnabled(enabled: boolean)
	if shopHighlight and shopHighlight.Parent then
		shopHighlight.Enabled = enabled
	end
end

local function formatLuck(luck: number): string
	local percent = math.round(luck * 100)
	return if percent >= 0 then `+{percent}%` else `{percent}%`
end

local function applyState(ownedShovelIds: unknown, equippedShovelId: unknown)
	local playerData = PlayerDataController:GetData()
	if typeof(ownedShovelIds) == "table" then
		playerData.OwnedShovelIds = ownedShovelIds
	end
	if typeof(equippedShovelId) == "string" then
		playerData.EquippedShovelId = equippedShovelId
	end
end

local function refreshDisplay()
	local playerData = PlayerDataController:GetData()
	local ownedShovelIds = if typeof(playerData.OwnedShovelIds) == "table" then playerData.OwnedShovelIds else {}
	local equippedShovelId = playerData.EquippedShovelId

	for shovelId, frame in pairs(generatedFrames) do
		local isOwned = ownedShovelIds[shovelId] == true
		local isEquipped = equippedShovelId == shovelId
		local buyButton = frame:FindFirstChild("BuyButton") :: GuiButton?
		local equipButton = frame:FindFirstChild("EquipButton") :: GuiButton?
		local equippedButton = frame:FindFirstChild("EquipedButton") :: GuiButton?
		local priceLabel = frame:FindFirstChild("PriceLabel") :: TextLabel?

		if buyButton then
			buyButton.Visible = not isOwned
			setButtonEnabled(buyButton, not requestPending and not isOwned)
		end
		if equipButton then
			equipButton.Visible = isOwned and not isEquipped
			setButtonEnabled(equipButton, not requestPending and isOwned and not isEquipped)
		end
		if equippedButton then
			equippedButton.Visible = isEquipped
			setButtonEnabled(equippedButton, false)
		end
		if priceLabel then
			priceLabel.Visible = not isOwned
		end
	end
end

local function handleResult(result)
	if result then
		applyState(result.ownedShovelIds, result.equippedShovelId)
	end
	if result and result.ok then
		NotificationClient.GreenNotify(result.message or "Shovel equipped")
	else
		NotificationClient.RedNotify((result and result.message) or "Shovel request failed")
	end
end

local function requestShovel(shovelId: string, purchase: boolean)
	if requestPending then
		return
	end
	requestPending = true
	refreshDisplay()
	local shovelService = Knit.GetService("ShovelService")
	local promise = if purchase
		then shovelService:PurchaseAndEquipShovel(shovelId)
		else shovelService:EquipShovel(shovelId)
	promise:andThen(handleResult):catch(function()
		NotificationClient.RedNotify("Shovel request failed")
	end):finally(function()
		requestPending = false
		refreshDisplay()
	end)
end

local function generateShovelList()
	SHOVEL_TEMPLATE.Visible = false
	for _, child in ipairs(SCROLLING_FRAME:GetChildren()) do
		if child:IsA("Frame") and child:GetAttribute(GENERATED_ATTRIBUTE) == true then
			child:Destroy()
		end
	end
	table.clear(generatedFrames)

	local configs = {}
	for shovelId, config in pairs(ShovelsData) do
		table.insert(configs, { shovelId = shovelId, config = config })
	end
	table.sort(configs, function(a, b)
		return a.config.LayoutOrder < b.config.LayoutOrder
	end)

	for _, entry in ipairs(configs) do
		local shovelId = entry.shovelId
		local config = entry.config
		local frame = SHOVEL_TEMPLATE:Clone()
		frame.Name = shovelId
		frame.LayoutOrder = config.LayoutOrder
		frame:SetAttribute(GENERATED_ATTRIBUTE, true)

		local nameLabel = frame:FindFirstChild("Name") :: TextLabel?
		local shovelImage = frame:FindFirstChild("ShovelImage") :: ImageLabel?
		local information = frame:FindFirstChild("Information") :: Frame?
		local luckCounter = information and information:FindFirstChild("Luck")
		local powerCounter = information and information:FindFirstChild("Power")
		local priceLabel = frame:FindFirstChild("PriceLabel") :: TextLabel?
		if nameLabel then
			nameLabel.Text = config.DisplayName
		end
		if shovelImage then
			shovelImage.Image = config.Icon
		end
		if luckCounter then
			local counter = luckCounter:FindFirstChild("Counter")
			if counter and counter:IsA("TextLabel") then
				counter.Text = formatLuck(config.Luck)
			end
		end
		if powerCounter then
			local counter = powerCounter:FindFirstChild("Counter")
			if counter and counter:IsA("TextLabel") then
				counter.Text = tostring(config.Power)
			end
		end
		if priceLabel then
			priceLabel.Text = "$" .. NumberUtil.FormatNumberStartKWithDecimal(config.Price)
		end

		local buyButton = frame:WaitForChild("BuyButton") :: GuiButton
		local equipButton = frame:WaitForChild("EquipButton") :: GuiButton
		local equippedButton = frame:WaitForChild("EquipedButton") :: GuiButton
		ButtonAnimation.SetUp(buyButton)
		ButtonAnimation.SetUp(equipButton)
		buyButton.Activated:Connect(function()
			requestShovel(shovelId, true)
		end)
		equipButton.Activated:Connect(function()
			requestShovel(shovelId, false)
		end)
		setButtonEnabled(equippedButton, false)

		frame.Visible = true
		frame.Parent = SCROLLING_FRAME
		generatedFrames[shovelId] = frame
	end
	refreshDisplay()
end

local function createShopPrompt()
	local areas = Workspace:WaitForChild("Areas", 20)
	local items = areas and areas:WaitForChild("Items", 20)
	local shop = items and items:WaitForChild("ShovelShop", 20)
	if not shop or not shop:IsA("Model") then
		warn("ShovelShopGuiController: Workspace.Areas.Items.ShovelShop is missing")
		return
	end

	local businessman = shop:FindFirstChild("Businessman")
	local promptAnchor = businessman and businessman:FindFirstChild("HumanoidRootPart")
	if not promptAnchor or not promptAnchor:IsA("BasePart") then
		warn("ShovelShopGuiController: ShovelShop.Businessman.HumanoidRootPart is missing")
		return
	end
	local highlightTarget = shop:FindFirstChild("HighlightModel")
	if not highlightTarget or not highlightTarget:IsA("Model") then
		warn("ShovelShopGuiController: ShovelShop.HighlightModel is missing")
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
		if not SHOVEL_GUI.Enabled then
			setShopHighlightEnabled(true)
		end
	end)
	prompt.PromptHidden:Connect(function()
		setShopHighlightEnabled(false)
	end)
	prompt.Triggered:Connect(function(player: Player)
		if player ~= LOCAL_PLAYER or SHOVEL_GUI.Enabled then
			return
		end
		prompt.Enabled = false
		setShopHighlightEnabled(false)
		refreshDisplay()
		GuiAnimation.OpenGui(SHOVEL_GUI)
	end)
end

function ShovelShopGuiController:KnitStart()
	GuiAnimation.Setup(SHOVEL_GUI)
	generateShovelList()

	ButtonAnimation.SetUp(CLOSE_BUTTON)
	CLOSE_BUTTON.Activated:Connect(function()
		GuiAnimation.CloseGui(SHOVEL_GUI)
	end)
	SHOVEL_GUI:GetPropertyChangedSignal("Enabled"):Connect(function()
		if SHOVEL_GUI.Enabled then
			if shopPrompt then
				shopPrompt.Enabled = false
			end
			setShopHighlightEnabled(false)
		elseif shopPrompt and shopPrompt.Parent then
			shopPrompt.Enabled = true
		end
	end)

	Knit.GetService("ShovelService").ShovelStateChanged:Connect(function(ownedShovelIds, equippedShovelId)
		applyState(ownedShovelIds, equippedShovelId)
		refreshDisplay()
	end)
	task.spawn(createShopPrompt)
end

return ShovelShopGuiController
