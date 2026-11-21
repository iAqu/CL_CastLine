local Config = require(script.Parent.FishingConfig)
local GuiUtil = require(script.Parent.GuiUtil)
local ItemStatUtil = require(script.Parent.ItemStatUtil)
local MutationDataUtil = require(script.Parent.MutationDataUtil)
local NumberUtil = require(script.Parent.NumberUtil)
local PlotFishIncome = require(script.Parent.PlotFishIncome)
local RarityPresentation = require(script.Parent.RarityPresentation)

local FishingSequenceInfo = {}
FishingSequenceInfo.__index = FishingSequenceInfo
local MUTATION_LABEL_IDS = { "Diamond", "Golden", "Mint", "Rainbow" }

-- Throw Food 的整数幸运值渐变档位。
local LUCK_COLORS = {
	{ "FFFFFF", "CDD2E1" },
	{ "FFF58C", "FFCD28" },
	{ "FFC86E", "FF821E" },
	{ "FF8282", "EB2828" },
	{ "FF96E6", "EB32BE" },
	{ "D296FF", "8C32EB" },
	{ "8CB4FF", "325AEB" },
	{ "96FFFF", "28D2E6" },
	{ "AAFF96", "32DC50" },
	{ "FFFFFF", "141419" },
	{ "468CFF", "A028E6" },
	{ "FFE63C", "E6281E" },
	{ "3CE678", "1EC8E6" },
	{ "FF78C8", "FF9628" },
	{ "FFD750", "FFFFFF" },
	{ "BE5AFF", "190A28" },
	{ "B4FAFF", "5A96FF" },
	{ "B4FF50", "FFBE28" },
	{ "FF5A3C", "280F0F" },
	{ "3CD2BE", "143282" },
	{ "FF50DC", "3C64FF" },
	{ "FFA03C", "6E3C1E" },
	{ "E6EBF5", "5A78C8" },
	{ "FFFA78", "3CC85A" },
	{ "DC1E46", "FFAAD2" },
	{ "9646FF", "3CE6FF" },
	{ "FFFFFF", "FF5050" },
	{ "28E6A0", "FFF05A" },
	{ "5A64FF", "FFFFFF" },
	{ "FF8C28", "141419" },
	{ "FFC8F0", "822878" },
	{ "78FF3C", "143C1E" },
	{ "3CF0FF", "FF3CC8" },
	{ "FFF0C8", "B46E28" },
	{ "1E1E78", "FFDC50" },
	{ "FF6428", "3CDCFF" },
	{ "C8FFC8", "2878FF" },
	{ "FF3C3C", "FFE63C" },
	{ "E6C8FF", "280A3C" },
	{ "FFFADC", "FFA0DC" },
	{ "FFFFFF", "FFD73C" },
}

local function child(parent, name, className)
	local instance = parent:FindFirstChild(name)
	assert(instance and instance:IsA(className), parent:GetFullName() .. "." .. name .. " must be a " .. className)
	return instance
end

function FishingSequenceInfo.new(gui, owner, initialLuck, now)
	local luck = child(gui, "LuckMeter", "Frame")
	local reveal = child(gui, "RevealInfo", "Frame")
	local isTutorial = owner.options and owner.options.tutorial
	local self = setmetatable({
		owner = owner,
		luck = luck,
		showLuck = not isTutorial,
		reveal = reveal,
		value = child(luck, "Value", "TextLabel"),
		glow = child(luck, "Glow", "Frame"),
		name = child(child(reveal, "Name", "Frame"), "Label", "TextLabel"),
		rarityRow = child(reveal, "Rarity", "Frame"),
		income = child(child(reveal, "Income", "Frame"), "Label", "TextLabel"),
		mutationRow = child(reveal, "Mutation", "Frame"),
		shown = 1,
		target = 1,
		lastWhole = 1,
		lastStep = 10,
	}, FishingSequenceInfo)
	self.scale = owner:_scale(self.value)
	self.mutationLabels = {}
	for _, id in MUTATION_LABEL_IDS do
		local label = child(self.mutationRow, "MutationLabel_" .. id, "TextLabel")
		self.mutationLabels[id] = label
		owner:_save(label, { "Visible" })
		label.Visible = false
	end
	local legacyLabel = self.mutationRow:FindFirstChild("Label")
	if legacyLabel and legacyLabel:IsA("GuiObject") then
		owner:_save(legacyLabel, { "Visible" })
		legacyLabel.Visible = false
	end
	self.valueGradient = child(self.value, "UIGradient", "UIGradient")
	self.glowGradient = child(self.glow, "UIGradient", "UIGradient")
	self.baseScale = self.scale.Scale
	self.glowTransparency = self.glow.BackgroundTransparency
	for _, frame in { luck, reveal, self.name.Parent, self.rarityRow, self.income.Parent, self.mutationRow } do
		owner:_save(frame, { "Visible" })
	end
	local weightRow = child(reveal, "Weight", "Frame")
	owner:_save(weightRow, { "Visible" })
	owner:_save(child(weightRow, "Label", "TextLabel"), { "Text" })
	self.name.Parent.Visible, self.income.Parent.Visible = true, true
	self.rarityRow.Visible = false
	self.mutationRow.Visible = false
	for _, label in { self.value, self.name, self.income } do
		owner:_save(label, { "Text", "TextColor3" })
	end
	owner:_save(self.name, { "BackgroundColor3" })
	owner:_save(self.glow, { "BackgroundTransparency" })
	owner:_save(self.valueGradient, { "Color" })
	owner:_save(self.glowGradient, { "Color" })
	local newBadge = self.name.Parent:FindFirstChild("New")
	if newBadge and newBadge:IsA("GuiObject") then
		self.newBadge = newBadge
		owner:_save(newBadge, { "Visible" })
		if isTutorial then
			-- Leave room for the larger continue instruction above the fish name.
			owner:_save(newBadge, { "Position" })
			newBadge.Position += UDim2.fromScale(0.26, 0)
		end
		newBadge.Visible = false
	end
	luck.Visible, reveal.Visible = self.showLuck, false
	self.value.TextColor3 = Color3.new(1, 1, 1)
	self:_applyWhole(1)
	self.value.Text = "1.00X"
	self:SetLuck(initialLuck or 1, now)
	return self
end

function FishingSequenceInfo:_applyWhole(whole)
	local colors = LUCK_COLORS[math.clamp(whole, 1, #LUCK_COLORS)]
	local gradient = ColorSequence.new(Color3.fromHex(colors[1]), Color3.fromHex(colors[2]))
	self.valueGradient.Color, self.glowGradient.Color = gradient, gradient
end

function FishingSequenceInfo:SetLuck(value, now, immediate)
	if self.destroyed then
		return
	end
	local target = tonumber(value)
	if not target or target ~= target or target <= 0 or target == math.huge
		or (target == self.target and (not immediate or self.shown == target))
	then
		return
	end
	if immediate then
		self.startedAt = nil
		self.from, self.shown, self.target = target, target, target
		self:_updateLuck(now)
		return
	end
	self:_updateLuck(now)
	self.from, self.target, self.startedAt = self.shown, target, now
end

function FishingSequenceInfo:_updateLuck(now)
	if self.startedAt then
		local alpha = math.clamp((now - self.startedAt) / 0.6, 0, 1)
		local eased = 1 - (1 - alpha) ^ 3
		self.shown = if alpha == 1 then self.target else self.from + (self.target - self.from) * eased
	end
	local whole = math.floor(self.shown + 1e-6)
	local step = math.floor(self.shown * 10 + 1e-6)
	local wholeChanged, stepChanged = whole ~= self.lastWhole, step ~= self.lastStep
	self.lastWhole, self.lastStep = whole, step
	if wholeChanged then
		self.pulseAt = now
		self:_applyWhole(whole)
	end
	if self.audioReady and self.luck.Visible and self.owner.phase ~= "Preparing" and (wholeChanged or stepChanged) then
		-- 每次采样只提示当前档位，整数优先；静音时也消费变化，不延迟补播。
		if wholeChanged then
			self.owner:_sound("LuckWhole", nil, math.min(1 + math.max(whole - 1, 0) * 0.06, 1.8))
		else
			local fraction = math.clamp(self.shown - whole, 0, 1)
			local pitch = fraction * 0.5 + 0.9 + math.min(math.max(whole - 1, 0), 6) * 0.05
			self.owner:_sound("LuckTick", nil, pitch)
		end
	end
	self.value.Text = string.format("%.2fX", math.floor(self.shown * 100 + 1e-6) / 100)
	local progress = if self.pulseAt then math.clamp((now - self.pulseAt) / 0.5, 0, 1) else 1
	local strength = (1 - progress) ^ 2
	self.scale.Scale = self.baseScale * (1 + 0.45 * strength * math.cos(progress * math.pi * 4))
	self.glow.BackgroundTransparency = self.glowTransparency + (0.55 - self.glowTransparency) * strength
end

function FishingSequenceInfo.FillReveal(reveal, item, weight, mutation, isNew)
	local nameRow = child(reveal, "Name", "Frame")
	local nameLabel = child(nameRow, "Label", "TextLabel")
	local badge = nameRow:FindFirstChild("New")
	if badge then
		badge.Visible = isNew == true
	end
	nameLabel.Text = item.DisplayName
	nameLabel.TextColor3 = RarityPresentation.GetColor(item.Rarity)
	local weightRow = child(reveal, "Weight", "Frame")
	local weightText = ItemStatUtil.FormatFishWeight(item, weight)
	child(weightRow, "Label", "TextLabel").Text = weightText or ""
	weightRow.Visible = weightText ~= nil
	local mutationId = MutationDataUtil.NormalizeMutationId(mutation)
	local mutationRow = child(reveal, "Mutation", "Frame")
	local visible = false
	for _, id in MUTATION_LABEL_IDS do
		local label = child(mutationRow, "MutationLabel_" .. id, "TextLabel")
		label.Visible = id == mutationId
		visible = visible or label.Visible
	end
	local legacy = mutationRow:FindFirstChild("Label")
	if legacy then
		legacy.Visible = false
	end
	mutationRow.Visible = visible
	child(reveal, "Rarity", "Frame").Visible = false
	local incomeRow = child(reveal, "Income", "Frame")
	incomeRow.Visible, nameRow.Visible = true, true
	local bestBaseCps
	if PlotFishIncome.UsesPercentageCps(item.Rarity) then
		local player = game:GetService("Players").LocalPlayer
		bestBaseCps = player and player:GetAttribute(PlotFishIncome.BEST_CPS_ATTRIBUTE)
	end
	local income = PlotFishIncome.GetCpsPrice(item, MutationDataUtil.GetEarnCashRate(mutation), bestBaseCps, weight)
	child(incomeRow, "Label", "TextLabel").Text = "$" .. NumberUtil.FormatItemPriceCompact(income) .. "/s"
end

function FishingSequenceInfo:_showCatch(bite)
	if self.revealedBite == bite then
		return
	end
	local item = bite.fishConfig or { DisplayName = bite.template.Name, CpsPrice = 0 }
	FishingSequenceInfo.FillReveal(self.reveal, item, bite.catchWeight, bite.mutationId, bite.isNewDiscovery)
	if not self.originalNameGradients then
		self.originalNameGradients = {}
		for _, childInstance in self.name:GetChildren() do
			if childInstance:IsA("UIGradient") then
				table.insert(self.originalNameGradients, childInstance)
				childInstance.Parent = nil
			end
		end
	end
	GuiUtil.SetRarityGradient(self.name, item.Rarity or "Common")
	self.revealedBite = bite
	self.owner:_celebrateCatch(bite)
end

function FishingSequenceInfo:Update(now, bite)
	if self.destroyed then
		return
	end
	local timeline = bite and bite.timeline
	local revealAt = if timeline and timeline.liftTiming then timeline.liftTiming.riseEnd
		else (if bite and bite.isEgg then Config.Bite.LiftTime * Config.Bite.LiftRiseEnd else Config.Bite.FishLift.RiseTime)
	local revealed = timeline and (timeline.phase == "Caught"
		or (timeline.phase == "Lifting" and now - timeline.startedAt >= revealAt))
	self.luck.Visible, self.reveal.Visible = self.showLuck and not revealed, revealed == true
	self:_updateLuck(now)
	self.audioReady = true
	if revealed then
		self:_showCatch(bite)
	else
		self.revealedBite = nil
		if self.newBadge then
			self.newBadge.Visible = false
		end
	end
end

function FishingSequenceInfo:Destroy()
	if self.originalNameGradients then
		GuiUtil.ClearGradeint(self.name)
		for _, gradient in self.originalNameGradients do
			gradient.Parent = self.name
		end
		self.originalNameGradients = nil
	end
	self.destroyed = true
end

return FishingSequenceInfo
