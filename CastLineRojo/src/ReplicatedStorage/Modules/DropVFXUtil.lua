local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local GuiUtil = require(script.Parent.GuiUtil)
local RarityRevealConfig = require(script.Parent.RarityRevealConfig)

local DropVFXUtil = {}

export type DropVFXSession = {
	SetVisible: (self: DropVFXSession, visible: boolean) -> (),
	Destroy: (self: DropVFXSession) -> (),
}

local function getTemplate(): Model?
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local rarityBeam = vfx and vfx:FindFirstChild("RarityBeam")
	local template = rarityBeam and rarityBeam:FindFirstChild("DropVFX")
	if template and template:IsA("Model") then
		return template
	end

	warn("[DropVFXUtil] Missing ReplicatedStorage.VFX.RarityBeam.DropVFX")
	return nil
end

local function getHorizontalSize(model: Model): number
	local _, bounds = model:GetBoundingBox()
	return math.max(bounds.X, bounds.Z)
end

local function getLargestBoundsAxis(model: Model): number
	local _, bounds = model:GetBoundingBox()
	return math.max(bounds.X, bounds.Y, bounds.Z)
end

local function getRarityColor(rarity: string): Color3?
	local rarityColor = GuiUtil.GetRarityGradientColor(rarity)
	if not rarityColor then
		warn(`[DropVFXUtil] Missing rarity color for {rarity}`)
		return nil
	end
	return rarityColor
end

local function applyRarityColor(effect: Model, rarityColor: Color3)
	local colorSequence = ColorSequence.new(rarityColor)
	for _, descendant in effect:GetDescendants() do
		if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
			descendant.Color = colorSequence
		end
	end
end

local function getLightParent(model: Model): BasePart?
	if model.PrimaryPart then
		return model.PrimaryPart
	end
	return model:FindFirstChildWhichIsA("BasePart", true)
end

function DropVFXUtil.AttachRarityPointLight(model: Model, rarity: string?, rangeModel: Model?): PointLight?
	local lightParent = getLightParent(model)
	if not lightParent then
		warn("[DropVFXUtil] Cannot attach rarity point light without a BasePart")
		return nil
	end

	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local rarityColor = getRarityColor(resolvedRarity)
	if not rarityColor then
		return nil
	end

	local range = getLargestBoundsAxis(rangeModel or model)
	if range <= 0 then
		warn("[DropVFXUtil] Cannot create rarity point light with empty bounds")
		return nil
	end

	local light = Instance.new("PointLight")
	light.Name = "RarityPointLight"
	light.Color = rarityColor
	light.Brightness = 5
	light.Range = range
	light.Shadows = false
	light.Parent = lightParent
	return light
end

local function prepareEffect(effect: Model)
	for _, descendant in effect:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
			descendant.CastShadow = false
		end
	end
end

local function setEffectVisible(effect: Model, visible: boolean)
	for _, descendant in effect:GetDescendants() do
		if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
			descendant.Enabled = visible
		end
	end
end

local function createEffect(horizontalSize: number, rarity: string?): Model?
	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local template = getTemplate()
	if not template then
		return nil
	end

	local templateHorizontalSize = getHorizontalSize(template)
	if templateHorizontalSize <= 0 or horizontalSize <= 0 then
		warn("[DropVFXUtil] Cannot scale DropVFX with an empty horizontal bounds")
		return nil
	end

	local effect = template:Clone()
	effect:ScaleTo(horizontalSize / templateHorizontalSize)
	local rarityColor = getRarityColor(resolvedRarity)
	if rarityColor then
		applyRarityColor(effect, rarityColor)
	end
	prepareEffect(effect)
	return effect
end

local function createSession(effect: Model, followConnection: RBXScriptConnection?): DropVFXSession
	local isVisible = true
	local function destroy()
		if followConnection then
			followConnection:Disconnect()
			followConnection = nil
		end
		if effect.Parent then
			effect:Destroy()
		end
	end

	return {
		SetVisible = function(_self: DropVFXSession, visible: boolean)
			if isVisible == visible then
				return
			end
			isVisible = visible
			setEffectVisible(effect, visible)
		end,
		Destroy = function(_self: DropVFXSession)
			destroy()
		end,
	}
end

function DropVFXUtil.Play(item: Model, rarity: string?): DropVFXSession?
	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local itemHorizontalSize = getHorizontalSize(item)
	local effect = createEffect(itemHorizontalSize, resolvedRarity)
	if not effect then
		return nil
	end
	DropVFXUtil.AttachRarityPointLight(effect, resolvedRarity, item)

	local function followItem()
		if not effect.Parent or not item.Parent then
			return false
		end
		local boundsCFrame = item:GetBoundingBox()
		effect:PivotTo(CFrame.new(boundsCFrame.Position))
		return true
	end

	local effectsFolder = Workspace:FindFirstChild("DigEffects")
	effect.Parent = effectsFolder or Workspace
	if not followItem() then
		effect:Destroy()
		return nil
	end

	local session: DropVFXSession? = nil
	local followConnection = RunService.RenderStepped:Connect(function()
		if not followItem() then
			if session then
				session:Destroy()
			end
		end
	end)
	session = createSession(effect, followConnection)
	return session
end

function DropVFXUtil.PlayAtPosition(position: Vector3, horizontalSize: number, rarity: string?): DropVFXSession?
	local effect = createEffect(horizontalSize, rarity)
	if not effect then
		return nil
	end

	DropVFXUtil.AttachRarityPointLight(effect, rarity)
	local effectsFolder = Workspace:FindFirstChild("DigEffects")
	effect.Parent = effectsFolder or Workspace
	effect:PivotTo(CFrame.new(position))
	return createSession(effect, nil)
end

return DropVFXUtil
