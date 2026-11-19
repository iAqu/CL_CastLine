local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Constants)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)

local EffectUtil = {}

local DEFAULT_EMIT_COUNT = 10
local EFFECT_LIFETIME = 2
local MIN_EFFECT_SCALE = 0.6
local MAX_EFFECT_SCALE = 4
local FOOTPRINT_TUNING = 0.9
local EFFECT_BASE_FOOTPRINT_FALLBACK = 5.3

local function getHorizontalFootprint(model: Model): number
	local _, size = model:GetBoundingBox()
	return math.max(size.X, size.Z)
end

local function emitParticleBurst(root: Instance)
	if root:IsA("ParticleEmitter") then
		root:Emit(root:GetAttribute("EmitCount") or DEFAULT_EMIT_COUNT)
	end

	for _, descendant in root:GetDescendants() do
		if descendant:IsA("ParticleEmitter") then
			descendant:Emit(descendant:GetAttribute("EmitCount") or DEFAULT_EMIT_COUNT)
		end
	end
end

function EffectUtil.PlayOnceParticle(particlePart: BasePart, cframe: CFrame, destroyTime: number?)
    destroyTime = destroyTime or 2

    local cloneParticlePart = particlePart:Clone()
    cloneParticlePart.Parent = workspace
    cloneParticlePart.CFrame = cframe
    cloneParticlePart.Anchored = true
    cloneParticlePart.CanCollide = false
    cloneParticlePart.Transparency = 1

    for _, particle in pairs(cloneParticlePart:GetDescendants()) do
        if particle:IsA("ParticleEmitter") then
            particle:Emit(particle:GetAttribute("EmitCount") or DEFAULT_EMIT_COUNT)
        end
    end
    game:GetService("Debris"):AddItem(cloneParticlePart, destroyTime)
end

function EffectUtil.PlayOnceParticleWeld(particlePart: BasePart, targetPart: BasePart, destroyTime: number?)
    destroyTime = destroyTime or 2

    local cloneParticlePart = particlePart:Clone()
    cloneParticlePart.Parent = workspace
    cloneParticlePart.CFrame = targetPart.CFrame
    cloneParticlePart.Anchored = false
    cloneParticlePart.CanCollide = false
    cloneParticlePart.Transparency = 1
    local weld = Instance.new("WeldConstraint")
    weld.Parent = cloneParticlePart
    weld.Part0 = cloneParticlePart
    weld.Part1 = targetPart

    for _, particle in pairs(cloneParticlePart:GetDescendants()) do
        if particle:IsA("ParticleEmitter") then
            particle:Emit(particle:GetAttribute("EmitCount") or DEFAULT_EMIT_COUNT)
        end
    end
    game:GetService("Debris"):AddItem(cloneParticlePart, destroyTime)
end

function EffectUtil.PlayBodySizeChangeEffect(attachPart: BasePart, target: Model | number?, playSound: boolean?): Model?
	if not attachPart or not attachPart:IsA("BasePart") then
		return nil
	end

	local effectsFolder = ReplicatedStorage:FindFirstChild("VFX")
	local characterEffects = effectsFolder and effectsFolder:FindFirstChild("Character")
	local particleModel = characterEffects and characterEffects:FindFirstChild("BodySizeChange")
	if not particleModel or not particleModel:IsA("Model") then
		return nil
	end

	local cloneModel = particleModel:Clone()

	local _, baseSize = cloneModel:GetBoundingBox()
	local baseFootprint = math.max(baseSize.X, baseSize.Z)
	if baseFootprint <= 0 then
		baseFootprint = EFFECT_BASE_FOOTPRINT_FALLBACK
	end

	local scale: number
	if typeof(target) == "Instance" and target:IsA("Model") then
		scale = (getHorizontalFootprint(target) / baseFootprint) * FOOTPRINT_TUNING
	elseif typeof(target) == "number" then
		scale = target
	else
		scale = 1
	end

	scale = math.clamp(scale, MIN_EFFECT_SCALE, MAX_EFFECT_SCALE)
	pcall(function()
		cloneModel:ScaleTo(scale)
	end)

	local sourcePart = cloneModel.PrimaryPart
	if not sourcePart then
		cloneModel:Destroy()
		return nil
	end

	for _, descendant in cloneModel:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
		end
	end

	cloneModel:PivotTo(attachPart.CFrame)
	cloneModel.Parent = workspace

	emitParticleBurst(cloneModel)
	game:GetService("Debris"):AddItem(cloneModel, EFFECT_LIFETIME)
	if playSound ~= false then
		SoundHelper.PlaySound(Constants.SoundRes.GUI_FUSE_SUCCESS)
	end
	return cloneModel
end

return EffectUtil
