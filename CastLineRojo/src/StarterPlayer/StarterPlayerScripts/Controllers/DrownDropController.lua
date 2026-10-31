local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ConditionsData = require(ReplicatedFirst.Data.ConditionsData)
local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local ConditionLabelUtil = require(ReplicatedStorage.Modules.ConditionLabelUtil)
local GuiUtil = require(ReplicatedStorage.Modules.GuiUtil)
local ItemStatUtil = require(ReplicatedStorage.Modules.ItemStatUtil)
local ItemTitlePositionUtil = require(ReplicatedStorage.Modules.ItemTitlePositionUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationTitleUtil = require(ReplicatedStorage.Modules.MutationTitleUtil)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local LOCAL_PLAYER = Players.LocalPlayer
local DROP_FOLDER_NAME = "DrownedItemDrops"
local DROP_ATTRIBUTE = "DrownedItemDrop"
local PROMPT_NAME = "DrownedItemPrompt"
local HIGHLIGHT_NAME = "DrownedItemHighlight"
local TITLE_NAME = "DrownedItemTitle"
local TITLE_ANCHOR_NAME = "DrownedItemTitleAnchor"
local TITLE_TEMPLATE_NAME = "ItemTitleTemplate_New"
local TITLE_WEIGHT_COLOR = "#B1DAF8"

local DrownDropController = Knit.CreateController({
	Name = "DrownDropController",
})

type BoundDrop = {
	highlight: Highlight,
	title: BillboardGui?,
	titleAnchor: Attachment?,
	connections: { RBXScriptConnection },
}

local boundDrops: { [Model]: BoundDrop } = {}
local boundFolders: { [Folder]: boolean } = {}

local function findLabel(gui: BillboardGui, name: string): TextLabel?
	local label = gui:FindFirstChild(name, true)
	return if label and label:IsA("TextLabel") then label else nil
end

local function getTitleTemplate(): BillboardGui?
	local playerGui = LOCAL_PLAYER:FindFirstChildOfClass("PlayerGui")
	local titleGui = playerGui and playerGui:FindFirstChild("TitleGui")
	local template = titleGui and titleGui:FindFirstChild(TITLE_TEMPLATE_NAME)
	return if template and template:IsA("BillboardGui") then template else nil
end

local function createTitle(model: Model, promptPart: BasePart): (BillboardGui?, Attachment?)
	local itemId = model:GetAttribute("ItemId")
	local weight = model:GetAttribute("Weight")
	local conditionId = model:GetAttribute("ConditionId")
	local price = model:GetAttribute("Price")
	if typeof(itemId) ~= "string"
		or typeof(weight) ~= "number"
		or typeof(conditionId) ~= "string"
		or typeof(price) ~= "number"
	then
		return nil, nil
	end

	local item = ItemsData[itemId]
	local template = getTitleTemplate()
	if not item or not template then
		return nil, nil
	end

	local boundsCFrame, boundsSize = model:GetBoundingBox()
	local titleAnchor = Instance.new("Attachment")
	titleAnchor.Name = TITLE_ANCHOR_NAME
	local titlePosition = boundsCFrame.Position + Vector3.new(0, boundsSize.Y * 0.5, 0)
	titleAnchor.Position = promptPart.CFrame:PointToObjectSpace(titlePosition)
	titleAnchor.Parent = promptPart

	local title = template:Clone()
	title.Name = TITLE_NAME
	title.Enabled = true
	title.Adornee = titleAnchor

	local nameLabel = findLabel(title, "NameLabel")
	if nameLabel then
		nameLabel.Text = `{item.DisplayName} <font color="{TITLE_WEIGHT_COLOR}">[{WeightFormat.FormatKg(weight)}]</font>`
	end
	local rarityLabel = findLabel(title, "RarityLabel")
	if rarityLabel then
		rarityLabel.Text = item.Rarity
		GuiUtil.SetRarityGradient(rarityLabel, item.Rarity)
	end
	local priceLabel = findLabel(title, "PriceLabel")
	if priceLabel then
		priceLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(price)
	end
	local condition = ConditionsData[conditionId]
	local frame = title:FindFirstChild("Frame")
	if frame then
		ConditionLabelUtil.Show(frame, conditionId)
		MutationTitleUtil.Show(frame, model:GetAttribute("MutationId"))
	end
	local luckLabel = findLabel(title, "LuckLabel")
	if luckLabel then
		local luck = ItemStatUtil.CalculateLuck(item, weight, condition and condition.LuckMult or 1)
		luckLabel.Text = "Luck: " .. ItemStatUtil.FormatLuckPercent(luck)
	end

	title.Parent = titleAnchor
	ItemTitlePositionUtil.ApplyBottomOffset(title, model)
	return title, titleAnchor
end

local function cleanupDrop(model: Model)
	local bound = boundDrops[model]
	if not bound then
		return
	end
	boundDrops[model] = nil
	for _, connection in ipairs(bound.connections) do
		connection:Disconnect()
	end
	if bound.title and bound.title.Parent then
		bound.title:Destroy()
	end
	if bound.titleAnchor and bound.titleAnchor.Parent then
		bound.titleAnchor:Destroy()
	end
end

local function bindDrop(model: Model)
	if boundDrops[model] or model:GetAttribute(DROP_ATTRIBUTE) ~= true then
		return
	end

	local prompt = model:FindFirstChild(PROMPT_NAME, true)
	local highlight = model:FindFirstChild(HIGHLIGHT_NAME)
	if not prompt or not prompt:IsA("ProximityPrompt") or not highlight or not highlight:IsA("Highlight") then
		return
	end
	local promptPart = prompt.Parent
	if not promptPart or not promptPart:IsA("BasePart") then
		return
	end

	local title, titleAnchor = createTitle(model, promptPart)

	local bound: BoundDrop = {
		highlight = highlight,
		title = title,
		titleAnchor = titleAnchor,
		connections = {},
	}
	boundDrops[model] = bound

	table.insert(bound.connections, model.AncestryChanged:Connect(function()
		if not model:IsDescendantOf(game) then
			cleanupDrop(model)
		end
	end))
end

local function bindDropFolder(folder: Folder)
	if boundFolders[folder] then
		return
	end
	boundFolders[folder] = true
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Model") then
			bindDrop(child)
		end
	end
	folder.ChildAdded:Connect(function(child)
		if child:IsA("Model") then
			task.defer(bindDrop, child)
		end
	end)
end

function DrownDropController:KnitStart()
	local existingFolder = Workspace:FindFirstChild(DROP_FOLDER_NAME)
	if existingFolder and existingFolder:IsA("Folder") then
		bindDropFolder(existingFolder)
	end
	Workspace.ChildAdded:Connect(function(child)
		if child.Name == DROP_FOLDER_NAME and child:IsA("Folder") then
			bindDropFolder(child)
		end
	end)
	RunService.RenderStepped:Connect(function()
		for model, bound in pairs(boundDrops) do
			if bound.title and bound.title.Parent then
				ItemTitlePositionUtil.ApplyBottomOffset(bound.title, model)
			end
		end
	end)
end

return DrownDropController
