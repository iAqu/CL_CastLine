local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local PotionToolUtil = {}

PotionToolUtil.POTION_TOOL_ATTRIBUTE = "PotionTool"
PotionToolUtil.POTION_ID_ATTRIBUTE = "PotionId"
PotionToolUtil.POTION_COUNT_ATTRIBUTE = "Count"

local HANDHELD_POTION_SCALE = 0.5

local function formatAssetId(iconId: unknown): string?

	if typeof(iconId) ~= "string" or iconId == "" then
		return nil
	end

	if iconId:match("^%d+$") then
		return "rbxassetid://" .. iconId
	end

	return iconId
end

local function getPotionTemplate(potionId: string): Model?
	local models = ReplicatedStorage:FindFirstChild("Models")
	local potions = models and models:FindFirstChild("Potion")
	local template = potions and potions:FindFirstChild(potionId)
	if template and template:IsA("Model") then
		return template
	end
	return nil
end

local function prepareToolModel(model: Model): BasePart?
	local handle = model:FindFirstChild("RootPart", true)
	if not handle or not handle:IsA("BasePart") then
		handle = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	end

	if not handle or not handle:IsA("BasePart") then
		return nil
	end

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BaseScript") then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored = false
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
			descendant.Massless = true
		end
	end

	return handle
end

function PotionToolUtil.CreateTool(potionId: string, count: number): Tool?
	local purchaseData = PurchaseDataHelper.GetData(potionId)
	if not purchaseData then
		warn("PotionToolUtil: missing purchase data", potionId)
		return nil
	end

	local textureId = formatAssetId(purchaseData.IconId)
	if not textureId then
		warn("PotionToolUtil: missing potion icon", potionId)
		return nil
	end

	local template = getPotionTemplate(potionId)
	if not template then
		warn("PotionToolUtil: missing potion model", potionId)
		return nil
	end

	local model = template:Clone()
	model:ScaleTo(HANDHELD_POTION_SCALE)
	local handle = prepareToolModel(model)
	if not handle then
		model:Destroy()
		warn("PotionToolUtil: potion model has no BasePart", potionId)
		return nil
	end

	local tool = Instance.new("Tool")
	tool.Name = purchaseData.Name
	tool.TextureId = textureId
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool:SetAttribute(PotionToolUtil.POTION_TOOL_ATTRIBUTE, true)
	tool:SetAttribute(PotionToolUtil.POTION_ID_ATTRIBUTE, potionId)
	PotionToolUtil.SetCount(tool, count)

	handle.Name = "Handle"
	handle.Parent = tool

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant ~= handle then
			descendant.Parent = tool
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = handle
			weld.Part1 = descendant
			weld.Parent = handle
		end
	end

	model:Destroy()
	return tool
end

function PotionToolUtil.HasPotionModel(potionId: string): boolean
	return getPotionTemplate(potionId) ~= nil
end

function PotionToolUtil.IsPotionTool(tool: Instance?): boolean
	return tool ~= nil
		and tool:IsA("Tool")
		and tool:GetAttribute(PotionToolUtil.POTION_TOOL_ATTRIBUTE) == true
end

function PotionToolUtil.GetPotionId(tool: Tool): string?
	local potionId = tool:GetAttribute(PotionToolUtil.POTION_ID_ATTRIBUTE)
	if typeof(potionId) == "string" then
		return potionId
	end
	return nil
end

function PotionToolUtil.GetCount(tool: Tool): number
	local count = tool:GetAttribute(PotionToolUtil.POTION_COUNT_ATTRIBUTE)
	if typeof(count) == "number" then
		return math.max(0, math.floor(count))
	end
	return 0
end

function PotionToolUtil.SetCount(tool: Tool, count: number)
	local normalizedCount = math.max(0, math.floor(count))
	tool:SetAttribute(PotionToolUtil.POTION_COUNT_ATTRIBUTE, normalizedCount)
	tool.ToolTip = ""
end

return PotionToolUtil
