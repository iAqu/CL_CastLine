local Settings = require(script.Parent.FishingConfig).Vignette
local RarityConfig = require(script.Parent.RarityConfig)

local FishingVignette = {}
FishingVignette.__index = FishingVignette

local RING_COUNT = 26
local VISIBLE_PHASES = {
	Approaching = true,
	Holding = true,
	Nibbling = true,
	Bite = true,
	Struggling = true,
	Lifting = true,
	Caught = true,
}

local function child(parent, name, className)
	local instance = parent:FindFirstChild(name)
	assert(instance and instance:IsA(className), parent:GetFullName() .. "." .. name .. " must be a " .. className)
	return instance
end

function FishingVignette.new(playerGui, owner)
	local gui = child(playerGui, "FishingVignetteGui", "ScreenGui")
	local holder = child(gui, "Vignette", "Frame")
	local self = setmetatable({ gui = gui, rings = {}, amount = 0, target = 0 }, FishingVignette)
	-- 先检查完整预置，避免缺少圆环时修改了一半的 UI 无法回收。
	for index = 1, RING_COUNT do
		local frame = child(holder, "Ring" .. index, "Frame")
		self.rings[index] = { frame = frame, stroke = child(frame, "UIStroke", "UIStroke") }
	end
	for _, ring in ipairs(self.rings) do
		owner:_save(ring.frame, { "Size" })
		owner:_save(ring.stroke, { "Color", "Transparency", "Thickness" })
		ring.stroke.Transparency = 1
	end
	gui.Enabled = false
	self:_layout()
	return self
end

function FishingVignette:_layout()
	local size = self.gui.AbsoluteSize
	if size == self.viewport then
		return
	end
	self.viewport = size
	-- 保留 ThrowFood 的圆环直径和描边重叠比例。
	local height, width = math.max(size.Y, 100), math.max(size.X, 100)
	local inner = height * 1.05
	local step = (math.sqrt(width * width + height * height) * 1.15 - inner) / RING_COUNT
	for index, ring in ipairs(self.rings) do
		local diameter = inner + step * (index - 0.5)
		ring.frame.Size = UDim2.fromOffset(diameter, diameter)
		ring.stroke.Thickness = step * 1.9
	end
end

function FishingVignette:_sample(now)
	if self.startedAt then
		local duration = if self.target > self.from then Settings.FadeIn else Settings.FadeOut
		local alpha = math.clamp((now - self.startedAt) / duration, 0, 1)
		self.amount = self.from + (self.target - self.from) * (1 - (1 - alpha) ^ 2)
		if alpha == 1 then
			self.amount, self.startedAt = self.target, nil
		end
	end
end

function FishingVignette:_target(amount, now)
	if self.target ~= amount then
		self.from, self.target, self.startedAt = self.amount, amount, now
	end
end

function FishingVignette:Update(now, bite)
	if self.destroyed then
		return
	end
	self:_layout()
	self:_sample(now)
	if self.bite ~= bite then
		self.bite, self.shown = bite, false
		self.amount, self.target, self.startedAt = 0, 0, nil
		local color = RarityConfig.Get(bite and bite.fishConfig and bite.fishConfig.Rarity).Color
		for _, ring in ipairs(self.rings) do
			ring.stroke.Color = color
		end
	end
	local phase = bite and bite.timeline.phase
	if VISIBLE_PHASES[phase] and not self.shown then
		self.shown = true
		self:_target(Settings.Strength, now)
	elseif phase == "Escaped" or phase == "Reeled" or not bite then
		self:_target(0, now)
	end
	for index, ring in ipairs(self.rings) do
		local opacity = self.amount * (index / RING_COUNT) ^ 1.5 * 0.6
		ring.stroke.Transparency = 1 - math.clamp(opacity, 0, 1)
	end
	self.gui.Enabled = self.amount > 0 or self.target > 0
end

function FishingVignette:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	self.bite, self.startedAt = nil, nil
	self.amount, self.target = 0, 0
	self.gui.Enabled = false
	for _, ring in ipairs(self.rings) do
		ring.stroke.Transparency = 1
	end
end

return FishingVignette
