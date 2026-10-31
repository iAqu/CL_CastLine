local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Constants = require(ReplicatedStorage.Modules.Constants)
local FovController = require(ReplicatedStorage.Modules.FovController)
local GuiAnimationUtil = require(ReplicatedStorage.Modules.GuiAnimationUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PromptUtil = require(ReplicatedStorage.Modules.PromptUtil)
local ShopHighlightUtil = require(ReplicatedStorage.Modules.ShopHighlightUtil)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)

local LOCAL_PLAYER = Players.LocalPlayer
local PROMPT_NAME = "SellShopPrompt"
local PROMPT_ANCHOR_NAME = "SellShopPromptAnchor"
local HIGHLIGHT_NAME = "SellShopPromptHighlight"
local MENU_ACTION_NAME = "SeaDigSellMenuChoice"
local MENU_SCALE = 1.5
local MENU_DISTANCE_POLL_SECONDS = 0.2
local CHOICE_SIZE = UDim2.fromScale(0.9, 0.19)
local HOVER_TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local HOVER_PADDING_LEFT = UDim.new(0.04, 0)
local HOVER_SOUND_ID = "rbxassetid://6972108033"

local MENU_OPTIONS = {
	{ label = "💰 Sell All Items", key = "sell_all" },
	{ label = "👋 Sell Held Item", key = "sell_held" },
	{ label = "❌ Bye", key = "bye" },
}

local MENU_HOTKEYS = {
	[Enum.KeyCode.One] = MENU_OPTIONS[1].key,
	[Enum.KeyCode.Two] = MENU_OPTIONS[2].key,
	[Enum.KeyCode.Three] = MENU_OPTIONS[3].key,
}

local SellShopController = Knit.CreateController({
	Name = "SellShopController",
})

local promptAnchor: BasePart? = nil
local shopPrompt: ProximityPrompt? = nil
local shopHighlight: Highlight? = nil
local activeMenu: BillboardGui? = nil
local isMenuOpen = false
local requestPending = false
local menuRevision = 0
local choiceConnections: { RBXScriptConnection } = {}
local hoverSound: Sound? = nil

local function setShopHighlightEnabled(enabled: boolean)
	if shopHighlight and shopHighlight.Parent then
		shopHighlight.Enabled = enabled
	end
end

local function disconnectChoices()
	for _, connection in ipairs(choiceConnections) do
		connection:Disconnect()
	end
	table.clear(choiceConnections)
end

local function closeSellMenu()
	menuRevision += 1
	isMenuOpen = false
	requestPending = false
	ContextActionService:UnbindAction(MENU_ACTION_NAME)
	disconnectChoices()
	if activeMenu then
		activeMenu:Destroy()
		activeMenu = nil
	end
	if shopPrompt and shopPrompt.Parent then
		shopPrompt.Enabled = true
	end
	FovController.ClearAdjuster(FovController.MENU_TWEEN_TIME)
end

local function playHoverSound()
	if not hoverSound then
		hoverSound = Instance.new("Sound")
		hoverSound.Name = "SellMenuHover"
		hoverSound.SoundId = HOVER_SOUND_ID
		hoverSound.Volume = 0.5
		hoverSound.Parent = SoundService
	end
	hoverSound.PlaybackSpeed = 1 + math.random(-5, 5) / 100
	hoverSound.TimePosition = 0
	hoverSound:Play()
end

local function bindHoverEffect(imageButton: ImageButton, outerFrame: Instance, textElement: TextLabel)
	local padding = textElement:FindFirstChildOfClass("UIPadding")
	local imageLabel = outerFrame:FindFirstChild("ImageLabel")
	local restingTransparency = if imageLabel and imageLabel:IsA("ImageLabel")
		then imageLabel.ImageTransparency
		else nil

	table.insert(choiceConnections, imageButton.MouseEnter:Connect(function()
		playHoverSound()
		if padding then
			TweenService:Create(padding, HOVER_TWEEN_INFO, { PaddingLeft = HOVER_PADDING_LEFT }):Play()
		end
		if imageLabel and imageLabel:IsA("ImageLabel") then
			TweenService:Create(imageLabel, HOVER_TWEEN_INFO, { ImageTransparency = 0 }):Play()
		end
	end))
	table.insert(choiceConnections, imageButton.MouseLeave:Connect(function()
		if padding then
			TweenService:Create(padding, HOVER_TWEEN_INFO, { PaddingLeft = UDim.new(0, 0) }):Play()
		end
		if imageLabel and imageLabel:IsA("ImageLabel") and restingTransparency ~= nil then
			TweenService:Create(imageLabel, HOVER_TWEEN_INFO, {
				ImageTransparency = restingTransparency,
			}):Play()
		end
	end))
end

local function playSellSuccessSound()
	local soundFolder = ReplicatedStorage:FindFirstChild("Sound")
	local collectCashFolder = soundFolder and soundFolder:FindFirstChild("CollectCash")
	local cashRegisterSound = collectCashFolder and collectCashFolder:FindFirstChild("CashRegister")
	if cashRegisterSound and cashRegisterSound:IsA("Sound") then
		SoundHelper.PlaySound(cashRegisterSound)
	end
end

local function showSellResult(result)
	if not result or not result.success then
		NotificationClient.RedNotify((result and result.errorMessage) or "I couldn't complete that sale.")
		return
	end
	local soldCount = tonumber(result.soldCount) or 0
	local earnedCash = tonumber(result.earnedCash) or 0
	local itemWord = if soldCount == 1 then "item" else "items"
	playSellSuccessSound()
	NotificationClient.GreenNotify(string.format(
		"Sold %d %s for $%s!",
		soldCount,
		itemWord,
		NumberUtil.FormatItemPriceCompact(earnedCash)
	))
	GuiAnimationUtil.PlayCharacterCashGain(LOCAL_PLAYER.Character, earnedCash)
	closeSellMenu()
end

local function requestSellAll()
	if requestPending then
		return
	end
	requestPending = true
	Knit.GetService("SellService"):RequestSellAllItems():andThen(function(result)
		requestPending = false
		if isMenuOpen then
			showSellResult(result)
		end
	end):catch(function(err)
		requestPending = false
		warn("SellShopController: sell all request failed", err)
		if isMenuOpen then
			NotificationClient.RedNotify("I couldn't complete that sale.")
		end
	end)
end

local function requestSellHeld()
	if requestPending then
		return
	end
	requestPending = true
	Knit.GetService("SellService"):RequestSellHeldItem():andThen(function(result)
		requestPending = false
		if isMenuOpen then
			showSellResult(result)
		end
	end):catch(function(err)
		requestPending = false
		warn("SellShopController: held item sale request failed", err)
		if isMenuOpen then
			NotificationClient.RedNotify("I couldn't complete that sale.")
		end
	end)
end

local function onMenuChoiceSelected(choiceKey: string)
	SoundHelper.PlaySound(Constants.SoundRes.GUI_BUTTON_CLICK)
	if choiceKey == "sell_all" then
		requestSellAll()
	elseif choiceKey == "sell_held" then
		requestSellHeld()
	elseif choiceKey == "bye" then
		closeSellMenu()
	end
end

local function createChoice(optionTemplate: Frame, index: number, option): Frame
	local choice = optionTemplate:Clone()
	choice.Name = "Option_" .. tostring(index)
	choice.LayoutOrder = index
	choice.Size = CHOICE_SIZE

	local outerFrame = choice:FindFirstChild("Frame")
	local innerFrame = outerFrame and outerFrame:FindFirstChild("Frame")
	local textElement = innerFrame and innerFrame:FindFirstChild("Text_Element")
	local indexLabel = innerFrame and innerFrame:FindFirstChild("TextLabel")
	local imageButton = outerFrame and outerFrame:FindFirstChild("ImageButton")
	if textElement and textElement:IsA("TextLabel") then
		textElement.Text = '["' .. option.label .. '"]'
		textElement:SetAttribute("Text", option.key)
		local constraint = Instance.new("UITextSizeConstraint")
		constraint.MaxTextSize = 32
		constraint.MinTextSize = 10
		constraint.Parent = textElement
	end
	if indexLabel and indexLabel:IsA("TextLabel") then
		indexLabel.Text = "#" .. tostring(index)
		local constraint = Instance.new("UITextSizeConstraint")
		constraint.MaxTextSize = 32
		constraint.MinTextSize = 10
		constraint.Parent = indexLabel
	end
	if imageButton and imageButton:IsA("ImageButton") then
		table.insert(choiceConnections, imageButton.Activated:Connect(function()
			onMenuChoiceSelected(option.key)
		end))
		if outerFrame and textElement and textElement:IsA("TextLabel") then
			bindHoverEffect(imageButton, outerFrame, textElement)
		end
	end
	return choice
end

local function bindMenuHotkeys()
	ContextActionService:BindActionAtPriority(MENU_ACTION_NAME, function(_, inputState, inputObject)
		if not isMenuOpen then
			return Enum.ContextActionResult.Pass
		end
		if inputState == Enum.UserInputState.Begin then
			local choiceKey = MENU_HOTKEYS[inputObject.KeyCode]
			if choiceKey then
				onMenuChoiceSelected(choiceKey)
			end
		end
		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.High.Value,
		Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three)
end

local function startDistanceWatch(revision: number)
	task.spawn(function()
		while isMenuOpen and menuRevision == revision do
			task.wait(MENU_DISTANCE_POLL_SECONDS)
			local character = LOCAL_PLAYER.Character
			local rootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not rootPart or not rootPart:IsA("BasePart") or not promptAnchor or not promptAnchor.Parent
				or (rootPart.Position - promptAnchor.Position).Magnitude > PromptUtil.PROMPT_MAX_DISTANCE
			then
				closeSellMenu()
				return
			end
		end
	end)
end

local function openSellMenu()
	if isMenuOpen or requestPending then
		return
	end
	local gui = ReplicatedStorage:FindFirstChild("Gui")
	local templates = gui and gui:FindFirstChild("SellDialog")
	local optionTemplate = templates and templates:FindFirstChild("Option_UI")
	local billboardTemplate = templates and templates:FindFirstChild("Billboard_UI")
	if not optionTemplate or not optionTemplate:IsA("Frame")
		or not billboardTemplate or not billboardTemplate:IsA("BillboardGui")
	then
		warn("SellShopController: ReplicatedStorage.Gui.SellDialog templates are missing")
		return
	end
	local character = LOCAL_PLAYER.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not rootPart or not rootPart:IsA("BasePart") then
		return
	end

	closeSellMenu()
	isMenuOpen = true
	menuRevision += 1
	local revision = menuRevision
	if shopPrompt then
		shopPrompt.Enabled = false
	end
	setShopHighlightEnabled(false)
	FovController.SetAdjuster(FovController.MENU_ADJUSTER, FovController.MENU_TWEEN_TIME)
	bindMenuHotkeys()

	local menu = billboardTemplate:Clone()
	menu.Name = "SellMenuBillboard"
	menu.MaxDistance = 150
	menu.Size = UDim2.new(
		menu.Size.X.Scale * MENU_SCALE,
		menu.Size.X.Offset * MENU_SCALE,
		menu.Size.Y.Scale * MENU_SCALE,
		menu.Size.Y.Offset * MENU_SCALE
	)
	menu.Adornee = rootPart
	menu.Parent = LOCAL_PLAYER:WaitForChild("PlayerGui")
	activeMenu = menu
	local objects = menu:FindFirstChild("Objects", true)
	if not objects or not objects:IsA("Frame") then
		warn("SellShopController: SellDialog.Billboard_UI.Objects is missing")
		closeSellMenu()
		return
	end
	for _, child in ipairs(objects:GetChildren()) do
		if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
			child:Destroy()
		end
	end
	for index, option in ipairs(MENU_OPTIONS) do
		createChoice(optionTemplate, index, option).Parent = objects
	end
	startDistanceWatch(revision)
end

local function createShopPrompt()
	local areas = Workspace:WaitForChild("Areas", 20)
	local items = areas and areas:WaitForChild("Items", 20)
	local shop = items and items:WaitForChild("SellShop", 20)
	if not shop or not shop:IsA("Model") then
		warn("SellShopController: Workspace.Areas.Items.SellShop is missing")
		return
	end
	local pad = shop:FindFirstChild("Pad")
	local hitbox = pad and pad:FindFirstChild("Hitbox")
	local highlightTarget = shop:FindFirstChild("HighlightModel")
	if not hitbox or not hitbox:IsA("BasePart") then
		warn("SellShopController: SellShop.Pad.Hitbox is missing")
		return
	end
	if not highlightTarget or not highlightTarget:IsA("Model") then
		warn("SellShopController: SellShop.HighlightModel is missing")
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

	local anchor = hitbox:FindFirstChild(PROMPT_ANCHOR_NAME)
	if not anchor or not anchor:IsA("BasePart") then
		anchor = Instance.new("Part")
		anchor.Name = PROMPT_ANCHOR_NAME
		anchor.Size = Vector3.one
		anchor.Transparency = 1
		anchor.Anchored = true
		anchor.CanCollide = false
		anchor.CanTouch = false
		anchor.CanQuery = false
		anchor.Parent = hitbox
	end
	anchor.CFrame = CFrame.new(highlightTarget:GetPivot().Position)
	promptAnchor = anchor
	local prompt = PromptUtil.Ensure(anchor, PROMPT_NAME, {
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
		if not isMenuOpen then
			setShopHighlightEnabled(true)
		end
	end)
	prompt.PromptHidden:Connect(function()
		setShopHighlightEnabled(false)
	end)
	prompt.Triggered:Connect(function(player: Player)
		if player == LOCAL_PLAYER then
			openSellMenu()
		end
	end)
end

function SellShopController:KnitStart()
	LOCAL_PLAYER.CharacterRemoving:Connect(function()
		closeSellMenu()
	end)
	task.spawn(createShopPrompt)
end

return SellShopController
