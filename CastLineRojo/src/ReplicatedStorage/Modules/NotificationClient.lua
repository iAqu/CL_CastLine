local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local notificationGui = PlayerGui:WaitForChild("NotificationGui", 15)
if not notificationGui then
	return {}
end

local contrainer = notificationGui:WaitForChild("Container", 10)
if not contrainer then
	return {}
end

local notificationTemplate = contrainer:WaitForChild("NotificationTemplate")
local successNotificationTemplate = contrainer:WaitForChild("SuccessNotificationTemplate")
local WhiteNotificationTemplate = contrainer:WaitForChild("WhiteNotificationTemplate")

local ICON_TEMPLATE_WAIT_SECONDS = 5
local iconNotificationTemplate: GuiObject? = contrainer:FindFirstChild("IconNotificationTemplate")
if not iconNotificationTemplate then
	local deadline = os.clock() + ICON_TEMPLATE_WAIT_SECONDS
	while not iconNotificationTemplate and os.clock() < deadline do
		task.wait(0.1)
		iconNotificationTemplate = contrainer:FindFirstChild("IconNotificationTemplate")
	end
end

local originalTemplateSize = notificationTemplate.Size
local iconTemplateSize = if iconNotificationTemplate then iconNotificationTemplate.Size else originalTemplateSize

local DEDAULT_DURATION = 3.5
local MAX_ACTIVE = 4
local ENTER_TWEEN_TIME = 0.3
local EXIT_TWEEN_TIME = 0.2

local module = {}

type NotifyColor = "Red" | "White" | "Green" | "Icon"

local templatesByColor: { [NotifyColor]: GuiObject? } = {
	Red = notificationTemplate,
	Green = successNotificationTemplate,
	White = WhiteNotificationTemplate,
	Icon = iconNotificationTemplate,
}

local function formatIconImage(iconId: string): string
	if not iconId or iconId == "" or iconId == "nil" then
		return ""
	end
	if string.find(iconId, "rbxassetid://", 1, true) then
		return iconId
	end
	return "rbxassetid://" .. iconId
end

local ICON_IMAGE_HEIGHT_RATIO = 0.85
local ICON_IMAGE_MIN_PIXELS = 44
local ICON_IMAGE_MAX_PIXELS = 72
local ICON_IMAGE_FALLBACK_PIXELS = 56

local function resolveIconPixelSize(template: GuiObject): number
	local templateHeight = template.AbsoluteSize.Y
	if templateHeight <= 0 then
		local containerHeight = contrainer.AbsoluteSize.Y
		if containerHeight <= 0 then
			containerHeight = 400
		end
		templateHeight = template.Size.Y.Offset + template.Size.Y.Scale * containerHeight
	end
	if templateHeight <= 0 then
		return ICON_IMAGE_FALLBACK_PIXELS
	end
	return math.clamp(
		math.floor(templateHeight * ICON_IMAGE_HEIGHT_RATIO),
		ICON_IMAGE_MIN_PIXELS,
		ICON_IMAGE_MAX_PIXELS
	)
end

local function configureIconNotificationTemplate(template: GuiObject)
	local listLayout = template:FindFirstChild("UIListLayout")
	if not listLayout or not listLayout:IsA("UIListLayout") then
		if listLayout then
			listLayout:Destroy()
		end
		listLayout = Instance.new("UIListLayout")
		listLayout.Name = "UIListLayout"
		listLayout.FillDirection = Enum.FillDirection.Horizontal
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Padding = UDim.new(0, 8)
		listLayout.Parent = template
	end

	local iconImage = template:FindFirstChild("IconImage")
	local createdIconImage = false
	if not iconImage or not iconImage:IsA("ImageLabel") then
		if iconImage then
			iconImage:Destroy()
		end
		iconImage = Instance.new("ImageLabel")
		iconImage.Name = "IconImage"
		iconImage.BackgroundTransparency = 1
		iconImage.BorderSizePixel = 0
		iconImage.Parent = template
		createdIconImage = true
	end

	iconImage.LayoutOrder = 1
	iconImage.Visible = true
	iconImage.ZIndex = 2
	iconImage.BackgroundTransparency = 1
	iconImage.BorderSizePixel = 0
	iconImage.ScaleType = Enum.ScaleType.Fit

	if createdIconImage then
		local iconPixels = resolveIconPixelSize(template)
		iconImage.Size = UDim2.fromOffset(iconPixels, iconPixels)
	else
		local targetPixels = resolveIconPixelSize(template)
		local currentPixels = iconImage.AbsoluteSize.X
		if currentPixels <= 0 then
			currentPixels = iconImage.Size.X.Offset
		end
		if currentPixels < ICON_IMAGE_MIN_PIXELS then
			iconImage.Size = UDim2.fromOffset(targetPixels, targetPixels)
		end
	end

	if not iconImage:FindFirstChildOfClass("UIAspectRatioConstraint") then
		local aspect = Instance.new("UIAspectRatioConstraint")
		aspect.AspectRatio = 1
		aspect.Parent = iconImage
	end

	local textLabel = template:FindFirstChild("TextLabel")
	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.LayoutOrder = 2
		textLabel.Visible = true
		textLabel.ZIndex = 2
		textLabel.AutomaticSize = Enum.AutomaticSize.X
		textLabel.Size = UDim2.fromScale(0, 0.9)
		textLabel.Position = UDim2.fromScale(0, 0.5)
		textLabel.AnchorPoint = Vector2.new(0, 0.5)
		textLabel.BackgroundTransparency = 1
	end

	local infoLabel = template:FindFirstChild("InfoLabel")
	if infoLabel and infoLabel:IsA("TextLabel") then
		infoLabel.Visible = false
		infoLabel.Text = ""
	end
end

local function applyIconInfoLabel(infoLabel: TextLabel?, _mutationId: string?)
	if not infoLabel then
		return
	end
	infoLabel.Visible = false
	infoLabel.Text = ""
end

local function ensureIconNotificationTemplate(): GuiObject?
	if iconNotificationTemplate and iconNotificationTemplate.Parent == contrainer then
		configureIconNotificationTemplate(iconNotificationTemplate)
		return iconNotificationTemplate
	end

	local existing = contrainer:FindFirstChild("IconNotificationTemplate")
	if existing and existing:IsA("GuiObject") then
		configureIconNotificationTemplate(existing)
		iconNotificationTemplate = existing
		templatesByColor.Icon = existing
		iconTemplateSize = existing.Size
		return existing
	end

	local template = successNotificationTemplate:Clone()
	template.Name = "IconNotificationTemplate"
	template.Visible = false
	configureIconNotificationTemplate(template)

	template.Parent = contrainer
	iconNotificationTemplate = template
	templatesByColor.Icon = template
	iconTemplateSize = template.Size
	return template
end

local activeNotifications: {
	[string]: {
		frame: GuiObject,
		textLabel: TextLabel,
		iconImage: ImageLabel?,
		baseText: string,
		count: number,
		expireAt: number,
		layoutOrder: number,
		isClosing: boolean?,
	},
} = {}

local notificationOrder: { string } = {}
local nextLayoutOrder = 0
local heartbeatConnection: RBXScriptConnection? = nil

local function makeKey(notifyColor: NotifyColor, notificationText: string, mutationId: string?): string
	local key = notifyColor .. "|" .. notificationText
	if notifyColor == "Icon" then
		key ..= "|" .. (mutationId or "")
	end
	return key
end

local function ensureNotificationGuiVisible()
	notificationGui.Enabled = true
	contrainer.Visible = true
end

local function formatNotificationText(baseText: string, count: number): string
	if count <= 1 then
		return baseText
	end
	return baseText .. " (x" .. tostring(count) .. ")"
end

local function playErrorSound()
	pcall(function()
		local effects = SoundService:FindFirstChild("Effects")
		local errorSound = effects and effects:FindFirstChild("ErrorSound")
		if errorSound and errorSound:IsA("Sound") then
			errorSound:Play()
		end
	end)
end

local function getTextStroke(textLabel: TextLabel): UIStroke?
	local uiStroke = textLabel:FindFirstChild("UIStroke")
	if uiStroke and uiStroke:IsA("UIStroke") then
		return uiStroke
	end
	return nil
end

local function setTextLabelTransparency(textLabel: TextLabel, transparency: number)
	textLabel.TextTransparency = transparency
	local uiStroke = getTextStroke(textLabel)
	if uiStroke then
		uiStroke.Transparency = transparency
	end
end

local function tweenTextLabelTransparency(textLabel: TextLabel, tweenInfo: TweenInfo, transparency: number): Tween
	local uiStroke = getTextStroke(textLabel)
	local textTween = TweenService:Create(textLabel, tweenInfo, {
		TextTransparency = transparency,
	})
	textTween:Play()
	if uiStroke then
		TweenService:Create(uiStroke, tweenInfo, {
			Transparency = transparency,
		}):Play()
	end
	return textTween
end

local function setImageTransparency(iconImage: ImageLabel?, transparency: number)
	if not iconImage then
		return
	end
	iconImage.ImageTransparency = transparency
end

local function tweenImageTransparency(iconImage: ImageLabel?, tweenInfo: TweenInfo, transparency: number)
	if not iconImage then
		return
	end
	TweenService:Create(iconImage, tweenInfo, {
		ImageTransparency = transparency,
	}):Play()
end

local function setNotificationContentTransparency(
	textLabel: TextLabel,
	iconImage: ImageLabel?,
	infoLabel: TextLabel?,
	transparency: number
)
	setTextLabelTransparency(textLabel, transparency)
	setImageTransparency(iconImage, transparency)
	if infoLabel and infoLabel.Visible then
		setTextLabelTransparency(infoLabel, transparency)
	end
end

local function tweenNotificationContentTransparency(
	textLabel: TextLabel,
	iconImage: ImageLabel?,
	infoLabel: TextLabel?,
	tweenInfo: TweenInfo,
	transparency: number
): Tween
	local textTween = tweenTextLabelTransparency(textLabel, tweenInfo, transparency)
	tweenImageTransparency(iconImage, tweenInfo, transparency)
	if infoLabel and infoLabel.Visible then
		tweenTextLabelTransparency(infoLabel, tweenInfo, transparency)
	end
	return textTween
end

local function bumpNotification(frame: GuiObject)
	local uiScale = frame:FindFirstChildOfClass("UIScale")
	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = frame
	end

	uiScale.Scale = 1
	TweenService:Create(uiScale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1.05,
	}):Play()

	task.delay(0.12, function()
		if uiScale.Parent then
			TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Scale = 1,
			}):Play()
		end
	end)
end

local function removeFromOrder(key: string)
	for index, orderedKey in ipairs(notificationOrder) do
		if orderedKey == key then
			table.remove(notificationOrder, index)
			break
		end
	end
end

local function removeNotification(key: string)
	activeNotifications[key] = nil
	removeFromOrder(key)
end

local function stopHeartbeatIfEmpty()
	if next(notificationOrder) == nil and heartbeatConnection then
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil
	end
end

local function closeNotification(key: string)
	local entry = activeNotifications[key]
	if not entry or entry.isClosing then
		return
	end

	entry.isClosing = true

	local frame = entry.frame
	local textLabel = entry.textLabel
	local iconImage = entry.iconImage
	local infoChild = frame:FindFirstChild("InfoLabel")
	local infoLabel = if infoChild and infoChild:IsA("TextLabel") then infoChild else nil

	removeNotification(key)

	if not frame.Parent then
		frame:Destroy()
		stopHeartbeatIfEmpty()
		return
	end

	local fadeInfo = TweenInfo.new(EXIT_TWEEN_TIME)
	tweenNotificationContentTransparency(textLabel, iconImage, infoLabel, fadeInfo, 1)

	local exitTween = TweenService:Create(
		frame,
		TweenInfo.new(EXIT_TWEEN_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{ Size = UDim2.fromScale(0, 0) }
	)
	exitTween:Play()
	exitTween.Completed:Once(function()
		frame:Destroy()
		stopHeartbeatIfEmpty()
	end)
end

local function evictOldestNotification()
	local oldestKey = notificationOrder[1]
	if oldestKey then
		closeNotification(oldestKey)
	end
end

local function ensureHeartbeat()
	if heartbeatConnection then
		return
	end

	heartbeatConnection = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		local keysToClose = {}

		for key, entry in pairs(activeNotifications) do
			if not entry.isClosing and entry.expireAt <= now then
				table.insert(keysToClose, key)
			end
		end

		for _, key in ipairs(keysToClose) do
			closeNotification(key)
		end
	end)
end

local function cloneTemplate(notifyColor: NotifyColor): GuiObject?
	local template = templatesByColor[notifyColor]
	if not template then
		return nil
	end
	return template:Clone()
end

local function playEnterAnimation(
	frame: GuiObject,
	textLabel: TextLabel,
	iconImage: ImageLabel?,
	infoLabel: TextLabel?,
	targetSize: UDim2
)
	setNotificationContentTransparency(textLabel, iconImage, infoLabel, 1)

	frame.Size = UDim2.fromScale(0, 0)
	frame.Visible = true

	local enterInfo = TweenInfo.new(ENTER_TWEEN_TIME)
	tweenNotificationContentTransparency(textLabel, iconImage, infoLabel, enterInfo, 0)
	TweenService:Create(
		frame,
		TweenInfo.new(ENTER_TWEEN_TIME, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
		{ Size = targetSize }
	):Play()
end

local function pushNotification(
	notifyColor: NotifyColor,
	notificationText: string,
	duration: number,
	playSound: boolean?,
	iconId: string?,
	mutationId: string?
)
	if notificationText == nil then
		return
	end

	ensureNotificationGuiVisible()

	if notifyColor == "Icon" and not templatesByColor.Icon then
		ensureIconNotificationTemplate()
	end

	if notifyColor == "Icon" and not templatesByColor.Icon then
		pushNotification("Green", notificationText, duration, false, nil, nil)
		return
	end

	local key = makeKey(notifyColor, notificationText, mutationId)
	local existing = activeNotifications[key]

	if existing and not existing.isClosing then
		existing.count += 1
		existing.baseText = notificationText
		existing.textLabel.Text = formatNotificationText(notificationText, existing.count)
		existing.expireAt = os.clock() + duration
		bumpNotification(existing.frame)
		removeFromOrder(key)
		table.insert(notificationOrder, key)
		return
	end

	while #notificationOrder >= MAX_ACTIVE do
		evictOldestNotification()
	end

	local newNotification = cloneTemplate(notifyColor)
	if not newNotification then
		return
	end

	local textLabel = newNotification:FindFirstChild("TextLabel", true)
	if not textLabel or not textLabel:IsA("TextLabel") then
		newNotification:Destroy()
		return
	end

	local iconImage: ImageLabel? = nil
	local infoLabel: TextLabel? = nil
	if notifyColor == "Icon" then
		local iconChild = newNotification:FindFirstChild("IconImage", true)
		if iconChild and iconChild:IsA("ImageLabel") then
			iconImage = iconChild
			iconImage.Visible = true
			local formattedIcon = formatIconImage(iconId or "")
			if formattedIcon ~= "" then
				iconImage.Image = formattedIcon
			end
		end

		local infoChild = newNotification:FindFirstChild("InfoLabel")
		if infoChild and infoChild:IsA("TextLabel") then
			infoLabel = infoChild
		end
		applyIconInfoLabel(infoLabel, mutationId)
	end

	local targetSize = if notifyColor == "Icon" then iconTemplateSize else originalTemplateSize

	nextLayoutOrder += 1
	newNotification.LayoutOrder = nextLayoutOrder
	textLabel.Text = notificationText
	newNotification.Parent = contrainer

	playEnterAnimation(newNotification, textLabel, iconImage, infoLabel, targetSize)

	activeNotifications[key] = {
		frame = newNotification,
		textLabel = textLabel,
		iconImage = iconImage,
		baseText = notificationText,
		count = 1,
		expireAt = os.clock() + duration,
		layoutOrder = nextLayoutOrder,
	}
	table.insert(notificationOrder, key)

	if playSound then
		playErrorSound()
	end

	ensureHeartbeat()
end

local function notify(
	notifyColor: NotifyColor,
	notificationText: string,
	duration: number?,
	playSound: boolean?,
	iconId: string?,
	mutationId: string?
)
	if not notificationText then
		return
	end

	pushNotification(notifyColor, notificationText, duration or DEDAULT_DURATION, playSound, iconId, mutationId)
end

-- deprecated
function module.Notify(notificationText: string, duration: number?)
	notify("Red", notificationText, duration, true)
end

-- deprecated
function module.SuccessNotify(notificationText: string, duration: number?)
	notify("Green", notificationText, duration, false)
end

function module.RedNotify(notificationText: string, duration: number?)
	notify("Red", notificationText, duration, true)
end

function module.GreenNotify(notificationText: string, duration: number?)
	notify("Green", notificationText, duration, false)
end

function module.WhiteNotify(notificationText: string, duration: number?)
	notify("White", notificationText, duration, false)
end

function module.NotifyAutoColor(notificationText: string, isSuccess: boolean, duration: number?)
	if isSuccess then
		module.GreenNotify(notificationText, duration)
	else
		module.RedNotify(notificationText, duration)
	end
end

function module.IconNotify(notificationText: string, iconId: string?, duration: number?, mutationId: string?)
	if not notificationText then
		return
	end

	if not iconId or iconId == "" then
		module.GreenNotify(notificationText, duration)
		return
	end

	ensureIconNotificationTemplate()
	if not iconNotificationTemplate then
		module.GreenNotify(notificationText, duration)
		return
	end

	notify("Icon", notificationText, duration, false, iconId, mutationId)
end

function module.NotifyGotAnimal(animalId: string, displayName: string?, _mutationId: string?)
	if not animalId then
		return
	end
	module.GreenNotify("Got " .. (displayName or animalId))
end

-- init
notificationGui.Enabled = true
notificationGui.Container.Visible = true
notificationGui.Container.NotificationTemplate.Visible = false
notificationGui.Container.SuccessNotificationTemplate.Visible = false
notificationGui.Container.WhiteNotificationTemplate.Visible = false
if iconNotificationTemplate then
	configureIconNotificationTemplate(iconNotificationTemplate)
	notificationGui.Container.IconNotificationTemplate.Visible = false
else
	ensureIconNotificationTemplate()
	if iconNotificationTemplate then
		notificationGui.Container.IconNotificationTemplate.Visible = false
	end
end

return module
