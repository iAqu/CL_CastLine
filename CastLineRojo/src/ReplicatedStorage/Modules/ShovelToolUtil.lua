local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ShovelsData = require(ReplicatedFirst.Data.ShovelsData)

local ShovelToolUtil = {}

ShovelToolUtil.SHOVEL_TOOL_ATTRIBUTE = "ShovelTool"
ShovelToolUtil.SHOVEL_ID_ATTRIBUTE = "ShovelId"
ShovelToolUtil.POWER_ATTRIBUTE = "Power"
ShovelToolUtil.DEFAULT_SHOVEL_ID = "Shovel_101"
ShovelToolUtil.HAND_ATTACHMENT_NAME = "HandAttachment"

-- Relative to HandAttachment. Dig animation swings the blade down;
-- do not flip Grip again or the head faces the wrong way.
local HOLD_POSE = CFrame.Angles(0, 0, math.pi)

-- Used only when the shovel model has no HandAttachment.
ShovelToolUtil.IDLE_GRIP = CFrame.new(0.2, -0.4, -0.8) * HOLD_POSE
ShovelToolUtil.DIG_GRIP = ShovelToolUtil.IDLE_GRIP
ShovelToolUtil.DEFAULT_GRIP = ShovelToolUtil.IDLE_GRIP

function ShovelToolUtil.GetHandAttachment(container: Instance?): Attachment?
	if not container then
		return nil
	end

	local handle = container:FindFirstChild("Handle") or container:FindFirstChild("_Handle")
	local attachment = handle and handle:FindFirstChild(ShovelToolUtil.HAND_ATTACHMENT_NAME)
	if attachment and attachment:IsA("Attachment") then
		return attachment
	end

	attachment = container:FindFirstChild(ShovelToolUtil.HAND_ATTACHMENT_NAME, true)
	if attachment and attachment:IsA("Attachment") then
		return attachment
	end

	return nil
end

local function gripFromHold(tool: Tool, pose: CFrame, fallback: CFrame): CFrame
	local attachment = ShovelToolUtil.GetHandAttachment(tool)
	if attachment then
		return attachment.CFrame * pose
	end
	return fallback
end

function ShovelToolUtil.ApplyIdleGrip(tool: Tool)
	if ShovelToolUtil.IsShovelTool(tool) then
		tool.Grip = gripFromHold(tool, HOLD_POSE, ShovelToolUtil.IDLE_GRIP)
	end
end

function ShovelToolUtil.ApplyDigGrip(tool: Tool)
	ShovelToolUtil.ApplyIdleGrip(tool)
end

local function getShovelTemplate(shovelId: string): Model?
	local config = ShovelsData[shovelId]
	if not config then
		return nil
	end
	local models = ReplicatedStorage:FindFirstChild("Models")
	local shovels = models and models:FindFirstChild("Shovels")
	local template = shovels and shovels:FindFirstChild(config.Model)
	if template and template:IsA("Model") then
		return template
	end
	return nil
end

local function preparePart(part: BasePart)
	part.Anchored = false
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Massless = true
end

local function weldPartToHandle(handle: BasePart, part: BasePart)
	preparePart(part)
	part.Parent = handle.Parent
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = handle
	weld.Part1 = part
	weld.Parent = handle
end

function ShovelToolUtil.CreateTool(shovelId: string?): Tool?
	local resolvedId = shovelId or ShovelToolUtil.DEFAULT_SHOVEL_ID
	local config = ShovelsData[resolvedId]
	if not config then
		warn("ShovelToolUtil: unknown shovel", resolvedId)
		return nil
	end
	local template = getShovelTemplate(resolvedId)
	if not template then
		warn("ShovelToolUtil: missing shovel model", resolvedId)
		return nil
	end

	local model = template:Clone()
	local handle = model:FindFirstChild("_Handle")
	if not handle or not handle:IsA("BasePart") then
		handle = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	end
	if not handle or not handle:IsA("BasePart") then
		model:Destroy()
		warn("ShovelToolUtil: shovel model has no handle", resolvedId)
		return nil
	end

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BaseScript") then
			descendant:Destroy()
		end
	end

	local tool = Instance.new("Tool")
	tool.Name = config.DisplayName
	tool.TextureId = config.Icon
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool:SetAttribute(ShovelToolUtil.SHOVEL_TOOL_ATTRIBUTE, true)
	tool:SetAttribute(ShovelToolUtil.SHOVEL_ID_ATTRIBUTE, resolvedId)
	tool:SetAttribute(ShovelToolUtil.POWER_ATTRIBUTE, config.Power)

	preparePart(handle)
	handle.Name = "Handle"
	handle.Parent = tool

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant ~= handle then
			weldPartToHandle(handle, descendant)
		end
	end

	model:Destroy()
	ShovelToolUtil.ApplyIdleGrip(tool)
	return tool
end

function ShovelToolUtil.IsShovelTool(tool: Instance?): boolean
	return tool ~= nil
		and tool:IsA("Tool")
		and tool:GetAttribute(ShovelToolUtil.SHOVEL_TOOL_ATTRIBUTE) == true
end

function ShovelToolUtil.GetShovelId(tool: Tool): string?
	local shovelId = tool:GetAttribute(ShovelToolUtil.SHOVEL_ID_ATTRIBUTE)
	if typeof(shovelId) == "string" then
		return shovelId
	end
	return nil
end

function ShovelToolUtil.FindShovelTool(container: Instance?, shovelId: string?): Tool?
	if not container then
		return nil
	end

	local resolvedId = shovelId or ShovelToolUtil.DEFAULT_SHOVEL_ID
	for _, child in ipairs(container:GetChildren()) do
		if ShovelToolUtil.IsShovelTool(child) then
			local id = ShovelToolUtil.GetShovelId(child)
			if not shovelId or id == resolvedId then
				return child
			end
		end
	end
	return nil
end

function ShovelToolUtil.HasShovelModel(shovelId: string?): boolean
	return getShovelTemplate(shovelId or ShovelToolUtil.DEFAULT_SHOVEL_ID) ~= nil
end

return ShovelToolUtil
