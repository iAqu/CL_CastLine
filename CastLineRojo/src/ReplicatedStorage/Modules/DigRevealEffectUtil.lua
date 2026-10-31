local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local GuiUtil = require(script.Parent.GuiUtil)
local RarityRevealConfig = require(script.Parent.RarityRevealConfig)

local DigRevealEffectUtil = {}

export type OutlineStyle = {
	color: Color3,
	transparency: number,
	alwaysOnTop: boolean,
}

local DEFAULT_EMIT_COUNT = 10
local NORMAL_BURST_LIFETIME = 3
local HIGH_TIER_BURST_LIFETIME = 4

local FALLBACK_COLORS = {
	Common = Color3.fromRGB(200, 200, 200),
	Uncommon = Color3.fromRGB(130, 220, 130),
	Rare = Color3.fromRGB(106, 217, 108),
	Epic = Color3.fromRGB(59, 177, 252),
	Unique = Color3.fromRGB(170, 0, 255),
	Supreme = Color3.fromRGB(255, 120, 210),
	Legendary = Color3.fromRGB(233, 82, 175),
	Mythical = Color3.fromRGB(255, 204, 0),
	Secret = Color3.fromRGB(170, 0, 255),
	Exclusive = Color3.fromRGB(254, 94, 58),
}

-- AF 当前没有 Legendary Burst；Supreme 是与其最接近的下一档资源。
local BURST_TEMPLATE_FALLBACK = {
	Legendary = "Supreme",
}

local function getRarityColor(rarity: string): Color3
	return GuiUtil.GetRarityGradientColor(rarity) or FALLBACK_COLORS[rarity] or FALLBACK_COLORS.Common
end

local function scaleNumberSequence(sequence: NumberSequence, scale: number): NumberSequence
	local keypoints = table.create(#sequence.Keypoints)
	for index, keypoint in sequence.Keypoints do
		keypoints[index] = NumberSequenceKeypoint.new(
			keypoint.Time,
			keypoint.Value * scale,
			keypoint.Envelope * scale
		)
	end
	return NumberSequence.new(keypoints)
end

local function getBurstTemplate(rarity: string): BasePart?
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local animalRoller = vfx and vfx:FindFirstChild("AnimalRoller")
	if not animalRoller then
		return nil
	end

	local templateName = BURST_TEMPLATE_FALLBACK[rarity] or rarity
	local template = animalRoller:FindFirstChild(templateName)
	if template and template:IsA("BasePart") then
		return template
	end

	local common = animalRoller:FindFirstChild("Common")
	return if common and common:IsA("BasePart") then common else nil
end

local function getParticleMultiplier(rank: number): number
	if rank >= 5 then
		return 1.75
	elseif rank >= 4 then
		return 1.5
	elseif rank >= 3 then
		return 1.25
	end
	return 1
end

function DigRevealEffectUtil.GetOutlineStyle(rarity: string?): OutlineStyle
	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local rank = RarityRevealConfig.GetRank(resolvedRarity)
	return {
		color = getRarityColor(resolvedRarity),
		transparency = 0,
		alwaysOnTop = rank >= 5,
	}
end

function DigRevealEffectUtil.PlayBurst(model: Model, rarity: string?, sizeScale: number?)
	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local rank = RarityRevealConfig.GetRank(resolvedRarity)
	local template = getBurstTemplate(resolvedRarity)
	if not template then
		return
	end

	local anchor = Instance.new("Part")
	anchor.Name = "DigRevealBurst"
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = false
	anchor.CanTouch = false
	anchor.CastShadow = false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(1, 1, 1)
	anchor.CFrame = CFrame.new(model:GetBoundingBox().Position)
	anchor.Parent = Workspace:FindFirstChild("DigEffects") or Workspace

	for _, child in template:GetChildren() do
		child:Clone().Parent = anchor
	end

	local effectScale = math.clamp(sizeScale or 1, 0.8, 2.2)
	local emitMultiplier = getParticleMultiplier(rank)
	for _, descendant in anchor:GetDescendants() do
		if descendant:IsA("ParticleEmitter") then
			descendant.Enabled = false
			descendant.Size = scaleNumberSequence(descendant.Size, effectScale)
			local configuredCount = descendant:GetAttribute("EmitCount")
			local emitCount = if typeof(configuredCount) == "number"
				then configuredCount
				else if descendant.Rate > 0 then descendant.Rate else DEFAULT_EMIT_COUNT
			local configuredDelay = descendant:GetAttribute("EmitDelay")
			local emitDelay = if typeof(configuredDelay) == "number" then configuredDelay else 0
			task.delay(emitDelay, function()
				if descendant.Parent then
					descendant:Emit(math.max(1, math.floor(emitCount * emitMultiplier + 0.5)))
				end
			end)
		elseif descendant:IsA("PointLight") then
			descendant.Enabled = true
			task.delay(0.1, function()
				if descendant.Parent then
					descendant.Enabled = false
				end
			end)
		end
	end

	if rank >= 5 then
		local light = Instance.new("PointLight")
		light.Name = "RarityEnvironmentLight"
		light.Color = getRarityColor(resolvedRarity)
		light.Brightness = 2.4 + math.min(rank - 5, 5) * 0.3
		light.Range = 12 * effectScale
		light.Shadows = false
		light.Parent = anchor
		TweenService:Create(
			light,
			TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Brightness = 0, Range = 6 * effectScale }
		):Play()
	end

	Debris:AddItem(anchor, if rank >= 5 then HIGH_TIER_BURST_LIFETIME else NORMAL_BURST_LIFETIME)
end

return DigRevealEffectUtil
