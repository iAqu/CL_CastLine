local FishesData = require(script.Parent.FishInventoryData)
local NumberUtil = require(script.Parent.NumberUtil)
local RarityConfig = require(script.Parent.RarityConfig)
local RarityPresentation = require(script.Parent.RarityPresentation)

local FishingChanceReveal = {}
FishingChanceReveal.__index = FishingChanceReveal

local CHANCE_HEIGHT_MULTIPLIER = 1.2

local function validDenominator(value)
	if type(value) == "number" and value >= 1 and value < math.huge and value % 1 == 0 then
		return value
	end
	return nil
end

local function getTiers()
	local thresholds = {}
	for _, fish in FishesData do
		local value = validDenominator(fish.DisplayChance)
		if value then
			local rarity = RarityConfig.Get(fish.Rarity)
			thresholds[rarity] = math.min(thresholds[rarity] or math.huge, value)
		end
	end
	local tiers = {}
	for rarity, threshold in thresholds do
		table.insert(tiers, { rarity = rarity, threshold = threshold })
	end
	table.sort(tiers, function(a, b)
		if a.threshold == b.threshold then
			return a.rarity.Index < b.rarity.Index
		end
		return a.threshold < b.threshold
	end)
	return tiers
end

local tiers = getTiers()

local function colorFor(value)
	for index = #tiers, 1, -1 do
		if value >= tiers[index].threshold then
			return tiers[index].rarity.Name
		end
	end
	return "Common"
end

function FishingChanceReveal.new(luck)
	local root = luck:Clone()
	root.Name, root.Visible, root.ClipsDescendants = "CatchChance", false, false
	root.Position = luck.Position + UDim2.fromScale(0, 0.025)
	root.Glow:Destroy()
	root.Word:Destroy()
	local value = root.Value
	local size = value.Size
	value.Size = UDim2.new(size.X, UDim.new(size.Y.Scale * CHANCE_HEIGHT_MULTIPLIER, size.Y.Offset * CHANCE_HEIGHT_MULTIPLIER))
	value.TextColor3 = Color3.new(1, 1, 1)
	value.TextTransparency, value.TextStroke.Transparency = 0, 0
	value.ZIndex += 1
	local scale = value:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
	scale.Scale, scale.Parent = 1, value
	root.Parent = luck.Parent
	return setmetatable({ root = root, value = value, scale = scale }, FishingChanceReveal)
end

function FishingChanceReveal:_setNumber(value, rarity, now)
	local digits = tostring(value)
	local colorChanged = self.rarity ~= rarity
	if colorChanged then
		local template = RarityPresentation.GetTemplate(rarity)
		self.value.UIGradient.Enabled = template ~= nil
		if template then
			self.value.UIGradient.Color = template.Color
		end
		self.rarity = rarity
	end
	if self.number ~= value then
		local strong = self.digits and (#digits ~= #self.digits or colorChanged)
		local light = self.digits and (digits:sub(1, 1) ~= self.digits:sub(1, 1)
			or math.floor(value / 10) ~= math.floor(self.number / 10))
		if strong or (light and now >= (self.pulseAt or -math.huge) + 0.12) then
			self.pulseAt, self.pulseStrength = now, if strong then 0.24 else 0.09
		end
		self.number, self.digits = value, digits
		self.value.Text = "1 in " .. NumberUtil.FormatNumberWithComma(value)
	end
end

local function addRing(effects, name, color, thickness)
	local ring = Instance.new("Frame")
	ring.Name, ring.BackgroundTransparency = name, 1
	ring.AnchorPoint, ring.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)
	ring.ZIndex, ring.Parent = effects.ZIndex, effects

	local corner = Instance.new("UICorner")
	corner.CornerRadius, corner.Parent = UDim.new(0.5, 0), ring
	local stroke = Instance.new("UIStroke")
	stroke.Color, stroke.Thickness, stroke.Parent = color, thickness, ring
	return { frame = ring, stroke = stroke }
end

function FishingChanceReveal:_burst(color, strength, strong)
	local effects = Instance.new("Frame")
	effects.Name, effects.BackgroundTransparency = "Burst", 1
	effects.Position, effects.AnchorPoint = self.value.Position, self.value.AnchorPoint
	effects.ZIndex, effects.Parent = self.value.ZIndex - 1, self.root

	local white = Color3.new(1, 1, 1)
	local rings = { addRing(effects, "Ring", color:Lerp(white, 0.55), if strong then 4 + strength * 3 else 2) }
	if strong then
		table.insert(rings, addRing(effects, "EchoRing", color, 8 + strength * 4))
	end

	local stars = {}
	local count = if strong then 18 + math.floor(12 * strength) else 5 + math.floor(8 * strength)
	for index = 1, count do
		local star = Instance.new("ImageLabel")
		star.Name, star.BackgroundTransparency = "Star", 1
		star.Image, star.ScaleType = "rbxasset://textures/sparkle.png", Enum.ScaleType.Fit
		star.ImageColor3 = color:Lerp(white, if index % 3 == 0 then 0.9 else 0.45)
		star.AnchorPoint, star.ZIndex, star.Parent = Vector2.new(0.5, 0.5), effects.ZIndex, effects
		local angle = index * 2.399963
		local speed = 0.65 + 0.12 * (index % 5)
		table.insert(stars, { image = star, x = math.cos(angle) * speed, y = math.sin(angle) * speed })
	end
	self.effects, self.rings, self.stars = effects, rings, stars
	self.revealViewport = nil
	self.maxRevealScale = math.huge
	self.burstDuration = if strong then 0.86 + 0.22 * strength else 0.52
	self.burstIntensity = if strong then 0.7 + strength * 0.3 else 0.25 + strength
	self.confettiOptions = {
		startDelay = if strong then 0.46 + 0.12 * strength else 0.3,
		zIndex = effects.ZIndex - 1,
	}
end

local function paddedTextSize(bounds)
	return bounds + Vector2.new(bounds.Y * 0.55, bounds.Y * 0.23)
end

function FishingChanceReveal:_baseTextScale()
	-- Tall canvases can hit the TextScaled font-size ceiling before filling the label.
	local height = self.value.AbsoluteSize.Y / self.scale.Scale
	return math.clamp(height / 100, 1, CHANCE_HEIGHT_MULTIPLIER)
end

local function availableRingHeight(label, viewport)
	local centerY = label.AbsolutePosition.Y + label.AbsoluteSize.Y * 0.5 - viewport.AbsolutePosition.Y
	local height = 2 * math.min(centerY, viewport.AbsoluteSize.Y - centerY)
	return math.max(12, height - 12)
end

function FishingChanceReveal:_fitRevealScale(peak)
	local viewport = self.root.Parent
	local viewportSize = viewport.AbsoluteSize
	if self.revealViewport == viewportSize or viewportSize.X <= 0 or viewportSize.Y <= 0 or self.value.TextBounds.X <= 0 then
		return
	end
	self.revealViewport = viewportSize
	local width = viewportSize.X * 0.94 - 24
	local hasEcho = #self.rings > 1
	local echoGap = if hasEcho then 0.22 else 0
	local textHeightLimit = availableRingHeight(self.value, viewport) - (if hasEcho then 8 else 0) - 4
	local function fits(scale)
		self.scale.Scale = scale
		local bounds = self.value.TextBounds
		local size = paddedTextSize(bounds)
		return (size.X + size.Y * echoGap) * scale <= width and bounds.Y * scale <= textHeightLimit
	end

	if fits(peak) then
		self.maxRevealScale = peak
		return
	end
	-- TextScaled can reflow at larger UIScale values. Sample the actual result to find a fitting peak.
	local low, high = 0.1, peak
	for _ = 1, 8 do
		local middle = (low + high) * 0.5
		if fits(middle) then
			low = middle
		else
			high = middle
		end
	end
	self.maxRevealScale = low
end

function FishingChanceReveal:_fitBurst()
	local bounds = self.value.TextBounds
	local canvas = self.root.AbsoluteSize
	self.effects.Visible = bounds.X > 0 and canvas.X > 0 and canvas.Y > 0
	if not self.effects.Visible then
		return
	end

	local size = paddedTextSize(bounds)
	self.effects.Size = UDim2.fromScale(size.X / canvas.X, size.Y / canvas.Y)
	self.ringAspect = size.Y / size.X
	local viewport = self.root.Parent
	self.starReach = viewport.AbsoluteSize.X * 0.45 / size.X
	self.ringHeightLimit = availableRingHeight(self.value, viewport) / size.Y
	self.innerRingHeightLimit = self.ringHeightLimit - (if #self.rings > 1 then 8 / size.Y else 0)
end

function FishingChanceReveal:_updateBurst(elapsed, scale)
	if elapsed >= self.burstDuration then
		self.effects:Destroy()
		self.effects = nil
		return
	end
	if not self.effects.Visible then
		return
	end
	local alpha = elapsed / self.burstDuration
	local spread = 1 - (1 - alpha) ^ 2
	local intensity = self.burstIntensity
	local ringFade = math.clamp((elapsed - 0.15) / (self.burstDuration * 0.8 - 0.15), 0, 1)
	for index, ring in ipairs(self.rings) do
		local echo = index - 1
		local gap = echo * (0.10 + 0.12 * spread)
		local heightLimit = if echo == 0 then self.innerRingHeightLimit else self.ringHeightLimit
		ring.frame.Size = UDim2.fromScale(
			(1 + gap * self.ringAspect) * scale,
			math.min((1 + gap) * scale, heightLimit)
		)
		ring.stroke.Transparency = echo * 0.39 + (1 - echo * 0.39) * ringFade
	end
	local starFade = math.clamp((alpha - 0.22) / 0.78, 0, 1)
	local horizontalSpread = math.min(self.starReach, 0.42 + (0.30 + intensity * 0.42) * spread)
	for index, star in ipairs(self.stars) do
		local size = (0.22 + 0.35 * intensity + 0.09 * (index % 3)) * (1 + (scale - 1) * 0.55) * (1 - starFade * 0.68)
		star.image.Size = UDim2.fromScale(0.26, size)
		-- Scatter from the ring in every direction, then arc downward as the stars lose speed.
		star.image.Position = UDim2.fromScale(
			0.5 + star.x * horizontalSpread,
			0.5 + star.y * (0.29 + (0.30 + intensity * 0.28) * spread) + alpha ^ 2 * (0.45 + intensity * 0.95)
		)
		star.image.ImageTransparency = starFade ^ 1.4
		star.image.Rotation = star.x * (16 + 80 * alpha)
	end
end

function FishingChanceReveal.GetTarget(bite, revealed)
	local phase = bite and bite.timeline.phase
	if bite and not bite.isEgg and (phase == "Struggling" or phase == "Lifting" or revealed) then
		return validDenominator(bite.catchChanceDenominator)
	end
	return nil
end

function FishingChanceReveal:Hide()
	self.root.Visible = false
	if self.effects then
		self.effects:Destroy()
		self.effects = nil
	end
end

function FishingChanceReveal:_roll(now, timeline, target, revealAt)
	local elapsed = now - timeline.startedAt
	if timeline.phase == "Lifting" then
		elapsed += timeline.struggleTime
	end
	local duration = timeline.struggleTime + revealAt
	local alpha = math.clamp(elapsed / duration, 0, 1)
	-- 先让个位数动起来，再沿数量级加速，最后减速靠近定格值。
	local introShare = math.min(0.25, 0.9 / math.log(math.max(target, 2)))
	local eased = (1 - introShare) * alpha ^ 2 * (3 - 2 * alpha) + introShare * (1 - (1 - alpha) ^ 8)
	local value = math.clamp(math.floor(target ^ eased), 1, math.max(1, target - 1))
	if value > (self.number or 1) and now >= self.nextTickAt then
		-- 按滚动曲线在对数刻度上的速度调节滴答间隔。
		local slope = (1 - introShare) * 6 * alpha * (1 - alpha) + introShare * 8 * (1 - alpha) ^ 7
		local speed = math.log10(target) * slope / duration
		self.nextTickAt = now + math.clamp(0.18 / (0.8 + speed), 0.055, 0.21)
		return value, eased
	end
	return value
end

function FishingChanceReveal:Update(now, bite, target, revealed, revealAt)
	self.root.Visible = true
	if self.bite ~= bite then
		if self.effects then
			self.effects:Destroy()
			self.effects = nil
		end
		self.bite, self.number, self.digits, self.pulseAt, self.lockedAt = bite, nil, nil, nil, nil
		self.nextTickAt = now
	end

	if revealed then
		local revealStrength, strongReveal
		if not self.lockedAt then
			local rarity = RarityConfig.Get(bite.fishConfig.Rarity)
			local strength = math.clamp((rarity.Index - 1) / 11, 0, 1)
			local colorTier = colorFor(target)
			self:_setNumber(target, colorTier, now)
			local strong = rarity.Index >= RarityConfig.ByName.Legendary.Index
			self.lockedAt = now
			self.punch = if strong then 0.56 + 0.20 * strength else 0.26 + 0.14 * strength
			self:_burst(RarityPresentation.GetColor(colorTier), strength, strong)
			revealStrength, strongReveal = strength, strong
		end
		local elapsed = now - self.lockedAt
		local alpha = math.clamp((elapsed - 0.09) / 0.48, 0, 1)
		local swing = math.cos(alpha * math.pi * 2.5)
		local baseScale = self:_baseTextScale()
		local desiredPeak = baseScale + self.punch
		if self.effects then
			self:_fitRevealScale(desiredPeak)
		end
		local peak = math.min(desiredPeak, self.maxRevealScale)
		local rest = math.min(baseScale, peak / 1.08)
		local bounce = (1 - alpha) ^ 2 * (if swing < 0 then swing * 0.46 else swing)
		local scale = rest + (peak - rest) * bounce
		self.scale.Scale = scale
		if self.effects then
			self:_fitBurst()
			self:_updateBurst(elapsed, scale)
		end
		return nil, revealStrength, strongReveal
	end

	local value, tickProgress = 1, nil
	if target then
		value, tickProgress = self:_roll(now, bite.timeline, target, revealAt)
	end
	self:_setNumber(value, colorFor(value), now)
	local pulse = if self.pulseAt then math.clamp((now - self.pulseAt) / 0.22, 0, 1) else 1
	local swing = (self.pulseStrength or 0) * (1 - pulse) ^ 2 * math.cos(pulse * math.pi * 2)
	local scale = self:_baseTextScale() * (1 + swing)
	self.scale.Scale = scale
	local width = self.value.TextBounds.X * scale
	local availableWidth = self.root.Parent.AbsoluteSize.X * 0.94
	if availableWidth > 0 and width > availableWidth then
		self.scale.Scale = scale * availableWidth / width
	end
	return tickProgress
end

function FishingChanceReveal:Destroy()
	self.root:Destroy()
end

return FishingChanceReveal
