local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)

local MutationVisualUtil = {}

local EFFECT_PART_NAME = "ItemMutationEffectPart"
local EFFECT_PART_BY_MUTATION = {
	Golden = "EffectPart_Golden",
	Diamond = "EffectPart_Diamond",
	Rainbow = "EffectPart_Rainbow",
}
local warned: { [string]: boolean } = {}

local function warnOnce(key: string, message: string)
	if warned[key] then
		return
	end
	warned[key] = true
	warn(message)
end

local function getTemplate(mutationId: string): BasePart?
	local effects = ReplicatedStorage:FindFirstChild("Effects")
	local mutationEffects = effects and effects:FindFirstChild("MutationEffect")
	local templateName = EFFECT_PART_BY_MUTATION[mutationId]
	local template = templateName and mutationEffects and mutationEffects:FindFirstChild(templateName)
	return if template and template:IsA("BasePart") then template else nil
end

local function getParts(target: Instance): { BasePart }
	local parts = {}
	for _, descendant in target:GetDescendants() do
		if descendant:IsA("BasePart") and descendant.Name ~= EFFECT_PART_NAME then
			table.insert(parts, descendant)
		end
	end
	return parts
end

local function getAnchor(target: Instance, parts: { BasePart }): BasePart?
	if target:IsA("Model") and target.PrimaryPart then
		return target.PrimaryPart
	end
	local handle = target:FindFirstChild("Handle", true)
	if handle and handle:IsA("BasePart") then
		return handle
	end
	return parts[1]
end

local function getLocalBounds(anchor: BasePart, parts: { BasePart }): (Vector3, Vector3)
	local inverse = anchor.CFrame:Inverse()
	local min = Vector3.new(math.huge, math.huge, math.huge)
	local max = Vector3.new(-math.huge, -math.huge, -math.huge)
	for _, part in parts do
		local localCFrame = inverse * part.CFrame
		local half = part.Size * 0.5
		for x = -1, 1, 2 do
			for y = -1, 1, 2 do
				for z = -1, 1, 2 do
					local point = localCFrame * Vector3.new(half.X * x, half.Y * y, half.Z * z)
					min = Vector3.new(math.min(min.X, point.X), math.min(min.Y, point.Y), math.min(min.Z, point.Z))
					max = Vector3.new(math.max(max.X, point.X), math.max(max.Y, point.Y), math.max(max.Z, point.Z))
				end
			end
		end
	end
	return (min + max) * 0.5, max - min
end

function MutationVisualUtil.Remove(target: Instance)
	for _, descendant in target:GetDescendants() do
		if descendant.Name == EFFECT_PART_NAME then
			descendant:Destroy()
		end
	end
end

function MutationVisualUtil.Apply(target: Instance, value: unknown)
	MutationVisualUtil.Remove(target)
	local mutationId = MutationDataUtil.NormalizeMutationId(value)
	if not mutationId then
		return
	end
	local template = getTemplate(mutationId)
	if not template then
		warnOnce(
			"template_" .. mutationId,
			("MutationVisualUtil: missing Effects.MutationEffect.%s"):format(EFFECT_PART_BY_MUTATION[mutationId])
		)
		return
	end
	local parts = getParts(target)
	local anchor = getAnchor(target, parts)
	if not anchor or #parts == 0 then
		warnOnce("anchor_" .. target.Name, "MutationVisualUtil: no BasePart found on " .. target:GetFullName())
		return
	end
	local localCenter, size = getLocalBounds(anchor, parts)
	local effectPart = template:Clone()
	effectPart.Name = EFFECT_PART_NAME
	effectPart.Size = Vector3.new(math.max(0.1, size.X), math.max(0.1, size.Y), math.max(0.1, size.Z))
	effectPart.CFrame = anchor.CFrame * CFrame.new(localCenter)
	effectPart.Anchored = false
	effectPart.CanCollide = false
	effectPart.CanTouch = false
	effectPart.CanQuery = false
	effectPart.Massless = true
	for _, descendant in effectPart:GetDescendants() do
		if descendant:IsA("ParticleEmitter") then
			descendant.LockedToPart = true
		end
	end
	effectPart.Parent = anchor
	local weld = Instance.new("WeldConstraint")
	weld.Name = "ItemMutationEffectWeld"
	weld.Part0 = anchor
	weld.Part1 = effectPart
	weld.Parent = effectPart
end

return MutationVisualUtil
