local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local AreasWorkspace = require(ReplicatedStorage.Modules.AreasWorkspace)
local PlayerThumbnailUtil = require(ReplicatedStorage.Modules.PlayerThumbnailUtil)

local localPlayer = Players.LocalPlayer

local FarmSignController = Knit.CreateController({
	Name = "FarmSignController",
})

local EMPTY_OWNER_USER_ID = 0
local FARM_SIGN_NAME = "FarmSign"
local FARM_SIGN_ATTACHMENT_NAME = "FarmSignAttachment"
local OTHER_PLAYERS_SIGN_NAME = "OtherPlayersSign"

local TEXT_GRADIENT = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 253, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 112, 255)),
})
local WHITE = Color3.fromRGB(255, 255, 255)

local originalGuiStyles: { [GuiObject]: { backgroundColor: Color3, backgroundTransparency: number } } = {}
local earlyUiStarted = false

local function getOwnerUserId(farm: Instance): number
	local ownerUserId = farm:GetAttribute("OwnerUserId")
	if type(ownerUserId) == "number" then
		return ownerUserId
	end
	return EMPTY_OWNER_USER_ID
end

local function getOwnerName(farm: Instance): string
	local ownerName = farm:GetAttribute("OwnerName")
	if type(ownerName) == "string" then
		return ownerName
	end
	return ""
end

local function getAvatarImage(userId: number): string
	return PlayerThumbnailUtil.GetHeadshot(userId, 420)
end

local function setGradientEnabled(guiObject: Instance?, enabled: boolean)
	if not guiObject or not guiObject:IsA("GuiObject") then
		return
	end

	local gradient = guiObject:FindFirstChildOfClass("UIGradient")
	if gradient then
		gradient.Enabled = enabled
	end
end

local function setTextGradientEnabled(textLabel: TextLabel?, enabled: boolean)
	if not textLabel then
		return
	end

	local gradient = textLabel:FindFirstChildOfClass("UIGradient")
	if enabled and not gradient then
		gradient = Instance.new("UIGradient")
		gradient.Name = "UIGradient"
		gradient.Color = TEXT_GRADIENT
		gradient.Parent = textLabel
	end
	if gradient then
		gradient.Enabled = enabled
	end
end

local function captureOriginalStyle(guiObject: GuiObject)
	if originalGuiStyles[guiObject] then
		return
	end

	originalGuiStyles[guiObject] = {
		backgroundColor = guiObject.BackgroundColor3,
		backgroundTransparency = guiObject.BackgroundTransparency,
	}
end

local function useOriginalBackground(guiObject: Instance?)
	if not guiObject or not guiObject:IsA("GuiObject") then
		return
	end

	captureOriginalStyle(guiObject)
	local style = originalGuiStyles[guiObject]
	guiObject.BackgroundColor3 = style.backgroundColor
	guiObject.BackgroundTransparency = style.backgroundTransparency
end

local function useWhiteBackground(guiObject: Instance?, transparency: number?)
	if not guiObject or not guiObject:IsA("GuiObject") then
		return
	end

	captureOriginalStyle(guiObject)
	guiObject.BackgroundColor3 = WHITE
	guiObject.BackgroundTransparency = transparency or 0
end

local function findTextLabel(parent: Instance?, name: string): TextLabel?
	local child = parent and parent:FindFirstChild(name)
	if child and child:IsA("TextLabel") then
		return child
	end
	return nil
end

local function findImageButton(parent: Instance?, name: string): ImageButton?
	local child = parent and parent:FindFirstChild(name)
	if child and child:IsA("ImageButton") then
		return child
	end
	return nil
end

local function findImageLabel(parent: Instance?, name: string): ImageLabel?
	local child = parent and parent:FindFirstChild(name)
	if child and child:IsA("ImageLabel") then
		return child
	end
	return nil
end

local function getFarmSign(farm: Instance): BillboardGui?
	local attachment = farm:FindFirstChild(FARM_SIGN_ATTACHMENT_NAME)
	local attachedSign = attachment and attachment:FindFirstChild(FARM_SIGN_NAME)
	if attachedSign and attachedSign:IsA("BillboardGui") then
		return attachedSign
	end

	-- 兼容尚未迁移 Studio 层级的旧农场；不再由脚本写入 Adornee。
	local legacySign = farm:FindFirstChild(FARM_SIGN_NAME)
	if legacySign and legacySign:IsA("BillboardGui") then
		return legacySign
	end
	return nil
end

local function updateFarmSign(farm: Instance, ownerUserId: number, ownerName: string, isOwnFarm: boolean)
	local farmSign = getFarmSign(farm)
	if not farmSign then
		return
	end

	local hasOwner = ownerUserId ~= EMPTY_OWNER_USER_ID
	farmSign.Enabled = hasOwner

	local homeImage = findImageLabel(farmSign, "HomeImage")
	local ownerImage = findImageButton(farmSign, "OwnerImage")

	if not hasOwner then
		if homeImage then
			homeImage.Visible = false
		end
		if ownerImage then
			ownerImage.Visible = false
			ownerImage.Image = ""
			ownerImage.ImageColor3 = WHITE
			useOriginalBackground(ownerImage)
			setGradientEnabled(ownerImage, false)
		end
		return
	end

	local title = findTextLabel(farmSign, "Title")

	if homeImage then
		homeImage.Visible = isOwnFarm
	end

	if ownerImage then
		ownerImage.Visible = not isOwnFarm
		if isOwnFarm then
			ownerImage.Image = ""
		else
			ownerImage.Image = getAvatarImage(ownerUserId)
			ownerImage.ImageColor3 = WHITE
			useWhiteBackground(ownerImage)
		end
		setGradientEnabled(ownerImage, false)
		if isOwnFarm then
			useOriginalBackground(ownerImage)
		end
	end

	if title then
		title.Text = if isOwnFarm then "Your Base" else ("%s's Base"):format(ownerName)
		title.TextColor3 = WHITE
		if isOwnFarm then
			useOriginalBackground(title)
		else
			captureOriginalStyle(title)
			title.BackgroundTransparency = 1
		end
		setTextGradientEnabled(title, isOwnFarm)
	end
end

local function updateOtherPlayersSign(farm: Instance, ownerUserId: number, ownerName: string, isOwnFarm: boolean)
	local sign = farm:FindFirstChild("Sign")
	local otherPlayersSign = sign and sign:FindFirstChild(OTHER_PLAYERS_SIGN_NAME)
	if not otherPlayersSign or not otherPlayersSign:IsA("SurfaceGui") then
		return
	end

	local hasOwner = ownerUserId ~= EMPTY_OWNER_USER_ID
	otherPlayersSign.Enabled = hasOwner
	if not hasOwner then
		return
	end

	local holder = otherPlayersSign:FindFirstChild("Holder")
	local playerHolder = holder and holder:FindFirstChild("PlayerHolder")
	local imageHolder = playerHolder and playerHolder:FindFirstChild("PlayerImageHolder")
	local ownerImage = findImageButton(imageHolder, "OwnerImage")
	local playerName = playerHolder and playerHolder:FindFirstChild("PlayerName")
	local emptyText = findTextLabel(playerName, "EmptyText")
	local nameText = findTextLabel(playerName, "NameText")

	if ownerImage then
		ownerImage.Visible = true
		ownerImage.Image = getAvatarImage(ownerUserId)
		ownerImage.ImageColor3 = WHITE
		if isOwnFarm then
			useOriginalBackground(ownerImage)
		else
			useWhiteBackground(ownerImage)
		end
		setGradientEnabled(ownerImage, false)
	end

	if imageHolder and imageHolder:IsA("GuiObject") then
		imageHolder.Visible = true
		if isOwnFarm then
			useOriginalBackground(imageHolder)
		else
			captureOriginalStyle(imageHolder)
			imageHolder.BackgroundTransparency = 1
		end
		setGradientEnabled(imageHolder, false)
	end

	if emptyText then
		emptyText.Visible = false
	end

	if nameText then
		nameText.Visible = true
		nameText.Text = if isOwnFarm then "Your Base" else ("%s's Base"):format(ownerName)
		if isOwnFarm then
			useOriginalBackground(nameText)
		else
			captureOriginalStyle(nameText)
			nameText.BackgroundTransparency = 1
		end
	end
end

local function updateFarm(farm: Instance)
	local ownerUserId = getOwnerUserId(farm)
	local ownerName = getOwnerName(farm)
	local isOwnFarm = ownerUserId == localPlayer.UserId

	updateFarmSign(farm, ownerUserId, ownerName, isOwnFarm)
	updateOtherPlayersSign(farm, ownerUserId, ownerName, isOwnFarm)
end

function FarmSignController:BeginEarlyUi()
	if earlyUiStarted then
		return
	end
	earlyUiStarted = true

	task.spawn(function()
		Workspace:WaitForChild("Areas", 20)

		local farms = AreasWorkspace.getSortedPlots()
		if #farms == 0 then
			warn("[FarmSignController] No valid plots found under Workspace.Areas.Plot")
			return
		end

		local function updateAllFarms()
			for _, farm in ipairs(farms) do
				updateFarm(farm)
			end
		end

		for _, farm in ipairs(farms) do
			updateFarm(farm)

			farm:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
				updateFarm(farm)
			end)
			farm:GetAttributeChangedSignal("OwnerName"):Connect(function()
				updateFarm(farm)
			end)
		end

		localPlayer:GetAttributeChangedSignal("PlotSlotId"):Connect(function()
			updateAllFarms()
		end)
	end)
end

function FarmSignController:KnitStart()
	self:BeginEarlyUi()
end

return FarmSignController
