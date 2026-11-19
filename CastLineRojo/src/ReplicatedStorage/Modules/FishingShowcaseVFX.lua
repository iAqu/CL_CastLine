local Settings = require(script.Parent.FishingConfig).ShowcaseVFX
local RarityConfig = require(script.Parent.RarityConfig)
local RarityPresentation = require(script.Parent.RarityPresentation)
local MutationDataUtil = require(script.Parent.MutationDataUtil)

local FishingShowcaseVFX = {}
FishingShowcaseVFX.__index = FishingShowcaseVFX

function FishingShowcaseVFX.ShouldBurst(bite)
	if bite.isEgg then
		return false
	end
	return bite.isNewDiscovery == true
		or RarityConfig.Get(bite.fishConfig and bite.fishConfig.Rarity).Index >= RarityConfig.Get(Settings.BurstMinRarity).Index
		or MutationDataUtil.NormalizeMutationId(bite.mutationId) ~= nil
end

function FishingShowcaseVFX:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	if self.highlight.Parent then
		self.highlight.OutlineColor = Color3.new(0, 0, 0)
	end
	if self.part then
		self.part:Destroy()
		self.part = nil
	end
end

function FishingShowcaseVFX:Update(now)
	if self.destroyed then
		return false
	end
	if not self.fish.Parent or now >= self.expiresAt then
		self:Destroy()
		return false
	end
	if self.part and self.followFish then
		self.part.Position = self.fish:GetBoundingBox().Position
	end
	-- 外观每帧会恢复黑边；在最终表现阶段覆盖，不干预剪影的填充或遮挡。
	self.highlight.OutlineColor = if now < self.outlineEndsAt then self.color else Color3.new(0, 0, 0)
	return true
end

function FishingShowcaseVFX.new(bite, now, followFish)
	if bite.isEgg then
		return nil
	end
	local self = setmetatable({
		fish = bite.fish,
		followFish = followFish == true,
		highlight = bite.highlight,
		color = RarityPresentation.GetColor(bite.fishConfig and bite.fishConfig.Rarity),
		outlineEndsAt = now + Settings.OutlineDuration,
		expiresAt = now + Settings.OutlineDuration,
	}, FishingShowcaseVFX)
	if FishingShowcaseVFX.ShouldBurst(bite) then
		local center, size = bite.fish:GetBoundingBox()
		local peakSize = math.clamp(size.Magnitude * Settings.SizeRatio, Settings.SizeMin, Settings.SizeMax)
		local part = Instance.new("Part")
		part.Name, part.Size, part.CFrame = "FishingShowcaseStars", Vector3.one, CFrame.new(center.Position)
		part.Transparency, part.Anchored = 1, true
		part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
		local emitter = Instance.new("ParticleEmitter")
		emitter.Name, emitter.Texture = "Stars", Settings.Texture
		emitter.Color = ColorSequence.new(self.color)
		emitter.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(Settings.SizePeakTime, peakSize),
			NumberSequenceKeypoint.new(1, 0),
		})
		emitter.Transparency = NumberSequence.new(Settings.Transparency)
		emitter.Lifetime = NumberRange.new(Settings.LifetimeMin, Settings.LifetimeMax)
		emitter.Speed = NumberRange.new(Settings.SpeedMin, Settings.SpeedMax)
		emitter.SpreadAngle = Vector2.new(Settings.SpreadAngle, Settings.SpreadAngle)
		emitter.LightEmission = Settings.LightEmission
		emitter.Rate, emitter.Enabled, emitter.LockedToPart = 0, false, self.followFish
		emitter.Parent = part
		part.Parent = bite.owner.folder
		emitter:Emit(Settings.Count)
		self.part = part
		self.expiresAt = now + math.max(Settings.CleanupTime, Settings.OutlineDuration)
	end
	self:Update(now)
	return self
end

return FishingShowcaseVFX
