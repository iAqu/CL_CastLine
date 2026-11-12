local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = require(script.Parent.FishingConfig).RarityVFX
local RarityConfig = require(script.Parent.RarityConfig)

local FishingRarityVFX = {}
FishingRarityVFX.__index = FishingRarityVFX

local function scaleSequence(sequence, scale)
	local points = {}
	for _, point in ipairs(sequence.Keypoints) do
		table.insert(points, NumberSequenceKeypoint.new(point.Time, point.Value * scale, point.Envelope * scale))
	end
	return NumberSequence.new(points)
end

function FishingRarityVFX:Destroy()
	self.destroyed = true
	self.model:Destroy()
	self.emissions = {}
end

function FishingRarityVFX:Update(now, position, diameter)
	if self.destroyed then
		return false
	end
	if not self.model.Parent or now >= self.expiresAt then
		self:Destroy()
		return false
	end
	local scale = diameter / Settings.ReferenceDiameter * self.sizeScale
	if self.scale ~= scale then
		-- ScaleTo 处理部件和附件；粒子空间参数从原值覆盖，避免引擎缩放被计算两次。
		self.model:ScaleTo(self.baseScale * scale)
		for _, original in ipairs(self.particles) do
			local emitter = original.emitter
			emitter.Size = scaleSequence(original.size, scale)
			emitter.Speed = NumberRange.new(original.speed.Min * scale, original.speed.Max * scale)
			emitter.Acceleration = original.acceleration * scale
		end
		self.scale = scale
	end
	self.model:PivotTo(CFrame.new(position) * self.rotation)
	for index = #self.emissions, 1, -1 do
		local burst = self.emissions[index]
		if now >= burst.at then
			if not burst.emitted then
				burst.emitted = true
				if now < burst.endsAt + burst.emitter.Lifetime.Max then
					burst.emitter:Emit(burst.count)
				end
			end
			burst.emitter.Enabled = now < burst.endsAt
			if now >= burst.endsAt then
				table.remove(self.emissions, index)
			end
		end
	end
	return true
end

function FishingRarityVFX.Play(owner, now, position, rarity, diameter, stage)
	local name = RarityConfig.Get(rarity).Name
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local folder = vfx and vfx:FindFirstChild("AnimalRoller")
	local template = folder and folder:FindFirstChild(name)
	if not template or not template:IsA("Model") then
		owner.warnedRarityVFX = owner.warnedRarityVFX or {}
		if not owner.warnedRarityVFX[name] then
			owner.warnedRarityVFX[name] = true
			warn("FishingRarityVFX: VFX.AnimalRoller." .. name .. " is missing or invalid; skipping effect")
		end
		return nil
	end
	local exit = stage == "Exit"
	local model = template:Clone()
	local self = setmetatable({
		model = model,
		rotation = template:GetPivot().Rotation,
		baseScale = template:GetScale(),
		sizeScale = if exit then Settings.ExitSizeScale else 1,
		stage = stage,
		started = now,
		expiresAt = now,
		particles = {},
		emissions = {},
	}, FishingRarityVFX)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored, descendant.CanCollide = true, false
			descendant.CanTouch, descendant.CanQuery = false, false
		elseif descendant:IsA("ParticleEmitter") then
			descendant.Enabled = false
			table.insert(self.particles, {
				emitter = descendant,
				size = descendant.Size,
				speed = descendant.Speed,
				acceleration = descendant.Acceleration,
			})
			if not exit or descendant:GetAttribute("ExitEnabled") == true then
				local at = now + (descendant:GetAttribute("EmitDelay") or 0)
				local endsAt = at + (descendant:GetAttribute("EmitDuration") or 0)
				local count = descendant:GetAttribute("EmitCount") or 1
				count = if exit then math.max(1, math.floor(count * Settings.ExitCountScale + 0.5)) else count
				table.insert(self.emissions, { emitter = descendant, at = at, endsAt = endsAt, count = count })
				self.expiresAt = math.max(self.expiresAt, endsAt + descendant.Lifetime.Max + Settings.CleanupPadding)
			end
		end
	end
	model.Parent = owner.folder
	self:Update(now, position, diameter)
	return self
end

return FishingRarityVFX
