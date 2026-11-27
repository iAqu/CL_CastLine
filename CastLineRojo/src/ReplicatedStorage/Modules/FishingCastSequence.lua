local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Config = require(script.Parent.FishingConfig)
local CastPresentation = require(script.Parent.FishingCastPresentation)
local WaterEffects = require(script.Parent.FishingWaterEffects)
local ProjectileMath = require(script.Parent.FishingProjectileMath)
local RigUtil = require(script.Parent.FishingRigUtil)
local WaterSurfaceUtil = require(script.Parent.WaterSurfaceUtil)
local FishingBiteSequence = require(script.Parent.FishingBiteSequence)
local FishingCatchMeter = require(script.Parent.FishingCatchMeter)
local BaitElasticMotion = require(script.Parent.BaitElasticMotion)
local FishingSequenceInfo = require(script.Parent.FishingSequenceInfo)
local FishingRoll = require(script.Parent.FishingRoll)
local FishingVignette = require(script.Parent.FishingVignette)
local FishingCharacterVFX = require(script.Parent.FishingCharacterVFX)
local UiConfettiUtil = require(script.Parent.UiConfettiUtil)

local HOOK_CONFIRM_TIMEOUT = 8
local HOOK_LOOKUP_DELAY = 1.25
local HOOK_LOOKUP_INTERVAL = 0.35
local HOOK_LOOKUP_TIMEOUT = 1.5

local FishingCastSequence = {}
FishingCastSequence.__index = FishingCastSequence

local function landingDuration()
	local settings = Config.Landing
	return settings.SinkTime + settings.ReboundTime + settings.SettleTime
end

local function smoothstep(value)
	local t = math.clamp(value, 0, 1)
	return t * t * (3 - 2 * t)
end

local function limitMagnitude(offset, maximum)
	return if offset.Magnitude > maximum then offset.Unit * maximum else offset
end

local function canTapCatch(bite)
	local timeline = bite and bite.timeline
	return timeline and timeline.deepCatch
		and (timeline.phase == "Bite" or (timeline.phase == "Struggling" and timeline.awaitingHook))
end

local updateRipple, updateWaterVFX = WaterEffects.UpdateRipple, WaterEffects.Update

local function lineAnchor(parent, name)
	local part = Instance.new("Part")
	part.Name, part.Size, part.Transparency = name, Vector3.one * 0.1, 1
	part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
	part.Parent = parent
	local attachment = Instance.new("Attachment")
	attachment.Name, attachment.Parent = "FishingLineAttachment", part
	return part, attachment
end

local function guiChild(parent, name, className)
	local child = parent:FindFirstChild(name)
	assert(child and child:IsA(className), parent:GetFullName() .. "." .. name .. " must be a " .. className)
	return child
end

function FishingCastSequence:_setPhase(phase)
	if self.phase == phase then
		return
	end
	self.phase = phase
	self.folder:SetAttribute("Phase", phase)
	if self.fishAudio then
		self.fishAudio:SetPhase(phase, self.bite ~= nil and not self.bite.isEgg)
		if phase == "Caught" and self.bite and self.bite.isEgg then
			self.fishAudio:Play("FishSuccess")
		end
	end
end

function FishingCastSequence:_celebrateCatch(bite, confettiOptions)
	if self.destroyed or bite.isEgg or self.celebratedBite == bite then
		return
	end
	self.celebratedBite = bite
	if not bite.showcasePlayed then
		-- Present 在鱼体本帧定位完成后消费，和信息揭晓、音效同帧出现。
		bite.showcasePending = true
	end
	UiConfettiUtil.play(self.gui, "sideCannons", confettiOptions)
	if self.fishAudio then
		self.fishAudio:PlayShowcase()
	end
end

function FishingCastSequence:_audioEnabled()
	return not self.options.isSoundEnabled or self.options.isSoundEnabled()
end

function FishingCastSequence:_sound(name, volume, pitch)
	local settings = Config.Sounds[name]
	if not self:_audioEnabled() and not settings.Looped then
		return nil
	end
	local sound = Instance.new("Sound")
	sound.Name, sound.SoundId = name, settings.Id
	sound.Volume, sound.Looped = volume or settings.Volume, settings.Looped == true
	sound.PlaybackSpeed = pitch or settings.Pitch or 1
	sound.Parent = self.folder
	self.sounds[sound] = true
	if not sound.Looped then
		sound.Ended:Once(function()
			self.sounds[sound] = nil
			sound:Destroy()
		end)
	end
	if self:_audioEnabled() then
		sound:Play()
	end
	return sound
end

function FishingCastSequence:RefreshSoundSetting()
	if self.fishAudio then
		self.fishAudio:RefreshSoundSetting()
	end
	if not self:_audioEnabled() then
		for sound in pairs(self.sounds) do
			sound:Stop()
			if not sound.Looped then
				self.sounds[sound] = nil
				sound:Destroy()
			end
		end
	elseif self.phase == "Flying" and self.wind and not self.wind.IsPlaying then
		self.wind:Play()
	end
end

function FishingCastSequence:_shot(mode, duration, now)
	self.shotFrom, self.fovFrom = self.cameraFrame, self.cameraFov
	if mode == "Reel" and self.renderedStruggleFrame then
		self.shotFrom, self.fovFrom = self.renderedStruggleFrame, self.renderedStruggleFov
	end
	self.shotFocusFrom = (if mode == "Reel" then self.renderedStruggleFocus else nil)
		or self.cameraFocus or self.biteFocus
	self.landingCameraTransition = mode == "Landing" and duration > 0
	self.shotMode, self.shotStarted, self.shotDuration = mode, now, duration
	if mode == "Chase" then
		self.chaseEye = self.cameraFrame.Position
		if (self.fishingDepth or 0) > 0 then
			self.chaseStartPitch = math.asin(math.clamp(-self.cameraFrame.LookVector.Y, -1, 1))
		end
	end
end

function FishingCastSequence:_impulse(settings, now, bonus)
	table.insert(self.impulses, {
		settings = settings,
		shake = (settings.Shake or 0) + (settings.Bonus or 0) * (bonus or 0),
		started = now,
		seed = math.random() * 50,
	})
end

-- 同一更新内计算所有冲击，保持镜头只有一个写入点。
function FishingCastSequence:_sampleImpulses(now)
	local x, y, rx, ry, rz, fov = 0, 0, 0, 0, 0, 0
	for index = #self.impulses, 1, -1 do
		local impulse = self.impulses[index]
		local settings = impulse.settings
		local elapsed = math.max(0, now - impulse.started)
		local duration = settings.Duration or 0
		local recovery = settings.Recovery or 0
		if elapsed >= math.max(duration, Config.Camera.Attack + recovery) then
			table.remove(self.impulses, index)
		else
			if duration > 0 and elapsed < duration then
				local strength = impulse.shake * (1 - elapsed / duration) ^ 2
				local t, seed = now * settings.Frequency, impulse.seed
				x += math.noise(t, seed + 13) * 0.5 * strength
				y += math.noise(t, seed + 17) * 0.5 * strength
				rx += math.noise(t, seed) * 0.06 * strength
				ry += math.noise(t, seed + 5) * 0.06 * strength
				rz += math.noise(t, seed + 9) * 0.04 * strength
			end
			if settings.Fov and recovery > 0 then
				local envelope = if elapsed < Config.Camera.Attack
					then elapsed / Config.Camera.Attack
					else math.max(0, 1 - (elapsed - Config.Camera.Attack) / recovery) ^ 2
				fov += settings.Fov * envelope
			end
		end
	end
	return x, y, rx, ry, rz, fov
end

function FishingCastSequence:_save(instance, properties)
	for _, property in ipairs(properties) do
		table.insert(self.originals, { instance = instance, property = property, value = instance[property] })
	end
end

function FishingCastSequence:_scale(object)
	local scale = object:FindFirstChildOfClass("UIScale")
	if scale then
		self:_save(scale, { "Scale" })
	else
		scale = Instance.new("UIScale")
		scale.Parent = object
		table.insert(self.createdScales, scale)
	end
	return scale
end

function FishingCastSequence:_bindWaitingPromptSize()
	local label = self.continueLabel
	local factor = 1.5
	self.waitingPromptSizing = {}
	self.continuePromptPosition = label.Position
	self.waitingPromptPosition = label.Position
	self:_save(label, { "Position" })
	local function addSetting(instance, property, enlarged)
		local setting = { instance = instance, property = property, value = instance[property], enlarged = enlarged }
		table.insert(self.originals, setting)
		table.insert(self.waitingPromptSizing, setting)
	end
	if label.TextScaled then
		local size = label.Size
		local enlargedSize =
			UDim2.new(size.X.Scale * factor, size.X.Offset * factor, size.Y.Scale * factor, size.Y.Offset * factor)
		addSetting(label, "Size", enlargedSize)

		-- 以底边为锚点，触发最小尺寸时只向上扩展。
		local anchor = label.AnchorPoint
		local bottomOffset = 1 - anchor.Y
		addSetting(label, "AnchorPoint", Vector2.new(anchor.X, 1))
		self.waitingPromptPosition +=
			UDim2.new(0, 0, enlargedSize.Y.Scale * bottomOffset, enlargedSize.Y.Offset * bottomOffset)
		local minimum = Vector2.new(208, 24)
		local bounds = label:FindFirstChildOfClass("UISizeConstraint")
		if bounds then
			local minSize, maxSize = bounds.MinSize, bounds.MaxSize
			addSetting(
				bounds,
				"MinSize",
				Vector2.new(
					math.max(minSize.X, math.min(minimum.X, maxSize.X)),
					math.max(minSize.Y, math.min(minimum.Y, maxSize.Y))
				)
			)
		else
			bounds = Instance.new("UISizeConstraint")
			bounds.MinSize = minimum
			self.waitingPromptBounds = bounds
			addSetting(bounds, "Parent", label)
		end
		local constraint = label:FindFirstChildOfClass("UITextSizeConstraint")
		if constraint then
			addSetting(constraint, "MaxTextSize", math.round(constraint.MaxTextSize * factor))
			addSetting(constraint, "MinTextSize", math.round(constraint.MinTextSize * factor))
		end
	else
		addSetting(label, "TextSize", label.TextSize * factor)
	end
end

function FishingCastSequence:_updateWaitingPromptSize()
	local label = self.continueLabel
	local waiting = label.Visible and label.Text == Config.Bite.Text.Waiting
	local lift
	if waiting then
		lift = if self.gui.AbsoluteSize.Y <= 500 then 8 else 0
	end
	if self.waitingPromptLift == lift then
		return
	end
	self.waitingPromptLift = lift
	for _, setting in ipairs(self.waitingPromptSizing) do
		setting.instance[setting.property] = if waiting then setting.enlarged else setting.value
	end
	label.Position = if lift ~= nil
		then self.waitingPromptPosition - UDim2.fromOffset(0, lift)
		else self.continuePromptPosition
end

function FishingCastSequence:_bindGui(playerGui)
	self.gui = guiChild(playerGui, "FishingSequenceGui", "ScreenGui")
	self.gui.Enabled = false
	self.flash = guiChild(self.gui, "PerfectFlash", "Frame")
	self.bars = { guiChild(self.gui, "TopBar", "Frame"), guiChild(self.gui, "BottomBar", "Frame") }
	self.continueLabel = guiChild(self.gui, "ContinuePrompt", "TextLabel")
	self.continueText = self.continueLabel.Text
	self.popup = guiChild(self.gui, "PowerPopup", "TextLabel")
	self.popupStroke = guiChild(self.popup, "UIStroke", "UIStroke")
	self.popupScale = guiChild(self.popup, "UIScale", "UIScale")

	-- 只接管演出状态；退出后还原，保留 Studio 中调整的布局和样式。
	self:_save(self.flash, { "BackgroundColor3", "BackgroundTransparency", "Visible" })
	for _, bar in ipairs(self.bars) do
		self:_save(bar, { "Size" })
		bar.Size = UDim2.fromScale(1, 0)
	end
	self:_save(self.continueLabel, { "Text", "Visible", "TextTransparency" })
	self:_bindWaitingPromptSize()
	self:_save(self.popup, { "Text", "TextColor3", "Visible", "Position", "TextTransparency" })
	self:_save(self.popupStroke, { "Transparency" })
	self:_save(self.popupScale, { "Scale" })
	self.flash.BackgroundTransparency = 1
	self.barAmount = 0
	self.continueLabel.Visible = false
	self.continueLabel.TextTransparency = 0
	self.popup.Text, self.popup.Visible, self.popup.TextTransparency = "", false, 0
	self.popupStroke.Transparency, self.popupScale.Scale = 0, 1
	self.fullLuck = self.options and self.options.initialLuck or 1
	self.info = FishingSequenceInfo.new(self.gui, self, self.fullLuck, os.clock())
	self.vignette = FishingVignette.new(playerGui, self)
end

function FishingCastSequence:_bindCastMeter(meter)
	self:_save(meter.holder, { "Visible" })
	if self.fixedCast then
		self:_save(meter.bar, { "Visible" })
		self:_save(meter.marker, { "Visible", "Position" })
		self.castFeedback = require(script.Parent.FishingCastFeedback)
		self.castFeedback.Bind(self)
		self:_save(meter.label, { "Visible" })
		self:_save(meter.prompt, { "Text", "Visible" })
		self.castPromptText = meter.prompt.Text
		meter.bar.Visible, meter.marker.Visible, meter.prompt.Visible = true, true, true
		meter.label.Visible = false
		meter.marker.Position = UDim2.fromScale(0.5, 1)
	else
		self:_save(meter.marker, { "Position", "BackgroundColor3" })
		self:_save(meter.label, { "Text" })
		self:_save(meter.prompt, { "Text", "TextColor3" })
		self:_save(meter.scale, { "Scale" })
		self:_save(meter.glow, { "BackgroundColor3", "BackgroundTransparency", "Size" })
		self.holderScale, self.markerScale = self:_scale(meter.holder), self:_scale(meter.marker)
		self.glowSize, self.glowTransparency = meter.glow.Size, meter.glow.BackgroundTransparency
		meter.marker.Position = UDim2.fromScale(0.5, 1)
		meter.label.Text, meter.prompt.Text = "+0", "TAP TO CAST!"
		self.holderScale.Scale, self.markerScale.Scale, meter.scale.Scale = 0.5, 1, 1
	end
	meter.holder.Visible, meter.gui.Enabled = true, true
	self.meterStarted, self.lastMeterStep = os.clock(), 0
	self.meterProgress, self.meterDirection = 0, 1
	if self.fixedCast and self.info then
		self.info:SetLuck(self.fullLuck * FishingRoll.GetCastLuckMultiplier(0), self.meterStarted, true)
	end
end

function FishingCastSequence:_initBitePrompt()
	local template = guiChild(self.gui, "BitePromptTemplate", "BillboardGui")
	local prompt = template:Clone()
	self.bitePrompt = prompt
	self.bitePromptScale = guiChild(guiChild(prompt, "Icon", "ImageLabel"), "UIScale", "UIScale")
	prompt.Name, prompt.Enabled, prompt.Adornee = "BitePrompt", false, self.bait
	self.bitePromptScale.Scale = Config.Bite.Prompt.StartScale
	prompt.StudsOffsetWorldSpace = Vector3.new(0, self.baitBaseSize.Y * 0.5 + Config.Bite.Prompt.HeightOffset, 0)
	prompt:SetAttribute("FishingBillboardExempt", true)
	prompt.Parent = self.folder
end

function FishingCastSequence:_init(rig, playerGui, meter, animation, baitTemplate, options)
	self.options, self.sounds = options or {}, {}
	self.fishingDepth = Config.Landing.FishingDepth
	self.fixedCast = self.options.fixedCast
	self.fishAudio = self.options.audio
	self.originals, self.createdScales = {}, {}
	self.rig, self.root, self.meter = rig, rig.PrimaryPart, meter
	self:_bindGui(playerGui)
	local rod = assert(rig:FindFirstChild("HeldFishingRod"), "HeldFishingRod is missing")
	local tip = rod:FindFirstChild("Top", true)
	assert(tip and tip:IsA("Attachment"), "HeldFishingRod.yugan.Top is missing")
	assert(WaterSurfaceUtil.GetWaterSurfaceY(), "Fishing water surface is missing")
	self.tip = tip
	self.launch = self.options.launchPosition or self.root.Position
	self.forward = Vector3.new(self.root.CFrame.LookVector.X, 0, self.root.CFrame.LookVector.Z).Unit
	self.initialYaw = self.options.initialYaw or math.random() * math.pi * 2
	self.spin = self.initialYaw
	self.folder = Instance.new("Folder")
	self.folder.Name = "FishingSequence"
	self.folder.Parent = Workspace
	self:_setPhase("Preparing")

	local visual = BaitElasticMotion.CloneVisual(self, baitTemplate)
	local bait = self.bait
	BaitElasticMotion.Apply(
		self,
		CFrame.new(tip.WorldPosition - Vector3.new(0, 1.5, 0)) * CFrame.Angles(0, self.initialYaw, 0),
		Vector3.one
	)
	visual.Parent = self.folder
	self:_initBitePrompt()
	self.baitHighlight = Instance.new("Highlight")
	self.baitHighlight.Name, self.baitHighlight.Adornee = "BaitOutline", visual
	self.baitHighlight.OutlineColor, self.baitHighlight.OutlineTransparency = Color3.new(1, 1, 1), 0
	self.waitingBaitFill = Color3.fromRGB(125, 225, 236)
	self.bitingBaitFill = Color3.fromRGB(unpack(Config.Bite.BaitFillColor))
	self.baitHighlight.FillColor = self.bitingBaitFill
	self.baitHighlight.FillTransparency = 1
	self.baitHighlight.DepthMode, self.baitHighlight.Parent = Enum.HighlightDepthMode.AlwaysOnTop, self.folder
	self.lineEnd, self.lineEndAttachment = lineAnchor(self.folder, "FishingLineEnd")
	self.lineTop, self.lineTopAttachment = lineAnchor(self.folder, "FishingLineTop")
	self.lineEnd.Position = if self.baitTop then self.baitTop.WorldPosition else bait.Position
	local beam = Instance.new("Beam")
	beam.Name = "FishingLine"
	beam.Attachment0, beam.Attachment1 = tip, self.lineEndAttachment
	beam.Width0, beam.Width1 = 0.07, 0.07
	beam.Color, beam.Transparency = ColorSequence.new(Color3.new(1, 1, 1)), NumberSequence.new(0.15)
	beam.FaceCamera, beam.Segments = true, 10
	beam.Parent = self.folder
	self.line = beam
	local trailA, trailB = Instance.new("Attachment"), Instance.new("Attachment")
	trailA.Position, trailB.Position = Vector3.new(0, bait.Size.Y * 0.25, 0), Vector3.new(0, -bait.Size.Y * 0.25, 0)
	trailA.Parent, trailB.Parent = bait, bait
	local trail = Instance.new("Trail")
	trail.Name = "FlightTrail"
	trail.Attachment0, trail.Attachment1 = trailA, trailB
	trail.Lifetime, trail.LightEmission = 0.35, 0.6
	trail.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(255, 240, 180))
	trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
	trail.WidthScale, trail.Enabled = NumberSequence.new(1, 0), false
	trail.Parent = bait
	self.trail, self.trailA, self.trailB = trail, trailA, trailB

	if self.options.tapCatch then
		self.catchMeter = FishingCatchMeter.new(meter, self.gui)
	end
	self:_bindCastMeter(meter)
	local humanoid = assert(rig:FindFirstChildOfClass("Humanoid"))
	self.castGroundY = self.options.castGroundY or (self.root.Position.Y - humanoid.HipHeight - self.root.Size.Y * 0.5)
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
	CastPresentation.Prepare(self, animator, animation, self.options.specialCastAnimation)
	self.characterVFX = FishingCharacterVFX.new(rig, self.folder, self.castGroundY)
	self.impulses = {}
	self.cameraFrame, self.cameraFov = Workspace.CurrentCamera.CFrame, Workspace.CurrentCamera.FieldOfView
	self:_shot("Behind", 0, os.clock())
	self.gui.Enabled = true
	self:_startBaitAppear(os.clock())
end

function FishingCastSequence:_stopBaitAppear()
	if not self.baitAppearStarted then
		return
	end
	self.baitAppearStarted = nil
	self.baitHighlight.FillColor = self.baitAppearFillColor
	self.baitHighlight.FillTransparency = 1
	self.baitAppearFillColor = nil
end

function FishingCastSequence:_updateBaitAppear(now)
	if not self.baitAppearStarted then
		return 1
	end
	local elapsed = now - self.baitAppearStarted
	if elapsed >= Config.BaitAppear.Duration then
		self:_stopBaitAppear()
		return 1
	end
	local scale, fill = BaitElasticMotion.SampleAppear(elapsed)
	self.baitHighlight.FillColor = Color3.new(1, 1, 1)
	self.baitHighlight.FillTransparency = fill
	return scale
end

function FishingCastSequence:_startBaitAppear(now)
	if self.destroyed or self.options.playBaitAppear ~= true or self.baitAppearPlayed then
		return
	end
	self.baitAppearPlayed, self.baitAppearStarted = true, now
	self.baitAppearFillColor = self.baitHighlight.FillColor
	BaitElasticMotion.Apply(self, self.bait.CFrame, Vector3.one * self:_updateBaitAppear(now))
	self:_updateLine()
	if self.fishAudio then
		self.fishAudio:Play("FishingBaitShow")
	end

	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local folder = vfx and vfx:FindFirstChild("Fishing")
	local template = folder and folder:FindFirstChild("BaitAppear")
	if not (template and (template:IsA("Model") or template:IsA("BasePart"))) then
		warn("FishingCastSequence: VFX.Fishing.BaitAppear is missing or invalid; skipping particles")
		return
	end
	local effect = template:Clone()
	local descendants = effect:GetDescendants()
	table.insert(descendants, effect)
	for _, descendant in ipairs(descendants) do
		if descendant:IsA("BasePart") then
			descendant.Anchored, descendant.CanCollide = true, false
			descendant.CanTouch, descendant.CanQuery = false, false
		elseif descendant:IsA("ParticleEmitter") then
			descendant.Enabled = false
		end
	end
	effect:PivotTo(CFrame.new(self.bait.Position) * template:GetPivot().Rotation)
	effect.Parent = self.folder
	game:GetService("Debris"):AddItem(effect, Config.BaitAppear.EffectLifetime)
	for _, descendant in ipairs(descendants) do
		if descendant:IsA("ParticleEmitter") then
			descendant:Emit(descendant:GetAttribute("EmitCount") or 1)
		end
	end
end

function FishingCastSequence.new(
	rig: Model,
	playerGui: PlayerGui,
	meter,
	animation: Animation,
	baitTemplate: BasePart | Model,
	options
)
	local self = setmetatable({}, FishingCastSequence)
	local ok, err = pcall(self._init, self, rig, playerGui, meter, animation, baitTemplate, options)
	if not ok then
		self:Destroy()
		error(err, 0)
	end
	return self
end

function FishingCastSequence.GetRating(value)
	return Config.GetCastRating(value)
end

function FishingCastSequence:UpdateMeter(value)
	local step = math.floor(value * Config.Meter.Segments)
	if step ~= self.lastMeterStep then
		self.lastMeterStep = step
		self:_sound("MeterTick", nil, 0.9 + value * 0.5)
	end
end

function FishingCastSequence:_castClickFeedback(value, now, clickPlayed)
	if not clickPlayed then
		self:_sound("ButtonClick", 0.8, 0.9 + value * 0.5)
		self:_impulse(Config.Camera.Tap, now, value)
	end
	if FishingCastSequence.GetRating(value).Perfect then
		self.perfectAt = now
		self.flash.BackgroundColor3 = Color3.fromRGB(unpack(FishingCastSequence.GetRating(value).Color))
		self.flash.Visible, self.flash.BackgroundTransparency = true, 0.65
		self:_sound("Perfect", 0.5, 1.3)
		self:_impulse(Config.Camera.Perfect, now)
	end
end

function FishingCastSequence:_castFeedback(value, now, clickPlayed)
	self.castFeedback = self.castFeedback or require(script.Parent.FishingCastFeedback)
	self.castFeedback.Show(self, FishingCastSequence.GetRating(value), now)
	self:_castClickFeedback(value, now, clickPlayed)
end

function FishingCastSequence:LockCastMeter(): number
	if self.lockedMeterProgress == nil then
		self.lockedMeterProgress = self.meterProgress or 0
		local now = os.clock()
		if self.options and self.options.meterStartsAt then
			self:_sound("ButtonClick", 0.8, 0.9 + self.lockedMeterProgress * 0.5)
			self:_impulse(Config.Camera.Tap, now, self.lockedMeterProgress)
		else
			self.meterLockedAt = now
			self:_castFeedback(self.lockedMeterProgress, now)
			self.folder:SetAttribute("CastRating", self.castRating)
		end
	end
	return self.lockedMeterProgress
end

function FishingCastSequence:BeginCast(now: number)
	if self.phase ~= "Preparing" then
		return false
	end
	self:LockCastMeter()
	self.castClickedAt = now
	self.castWindupPending = true
	self.castWindup = true
	self.castFromScale = self.baitVisualScale
	self.castFromOffset = self.bait.Position - (self.tip.WorldPosition - Vector3.new(0, 1.5, 0))
	self:_stopBaitAppear()
	self:_setPhase("Casting")
	return true
end

function FishingCastSequence:Cast(value: number, distance: number?, luck: number?, castRating: string?)
	if self.phase ~= "Preparing" and not self.castWindupPending then
		return
	end
	if self.fixedCast then
		self:LockCastMeter()
		if self.options and self.options.meterStartsAt then
			self.meterProgress, self.lockedMeterProgress = value, value
			self.meter.marker.Position = UDim2.fromScale(0.5, 1 - value)
			self:_castFeedback(value, os.clock(), true)
		end
	end
	local now = os.clock()
	self.castWindupPending = nil
	self.distance = distance or (if self.fixedCast then Config.FixedCastDistance else ProjectileMath.Distance(value))
	self.folder:SetAttribute("Distance", self.distance)
	self.folder:SetAttribute("CastRating", castRating or self.castRating)
	CastPresentation.Select(self, castRating)
	if self.castProfile.Id == "Godlike" then
		self.characterVFX:Configure(self.castProfile, self.tip)
	end
	self.castClickedAt = if self.castWindup then self.castClickedAt else now
	if self.info then
		self.info:SetCastProgress(value)
		if luck then
			self.info:SetLuck(luck, now, true)
		end
	end
	self.castBlendAt = now
	self.castFromScale = self.baitVisualScale
	local heldLength = if self.castProfile.Id == "Godlike" then 0.4 else 1.5
	self.castFromOffset = self.bait and self.bait.Position - (self.tip.WorldPosition - Vector3.new(0, heldLength, 0))
	self:_stopBaitAppear()
	self:_setPhase("Casting")
	if not self.fixedCast then
		self:_castFeedback(math.clamp(value, 0, 1), self.castClickedAt)
	end
end

function FishingCastSequence:_waterTarget()
	local waterY = assert(WaterSurfaceUtil.GetWaterSurfaceY(), "Fishing water surface disappeared")
	local position = self.launch + self.forward * self.distance
	return Vector3.new(position.X, waterY, position.Z)
end

function FishingCastSequence:_diveOffset(now)
	local depth = self.fishingDepth or 0
	if depth > 0 and self.landedAt then
		depth *= smoothstep((now - self.landedAt) / Config.Landing.DiveTime)
	end
	return -depth
end

function FishingCastSequence:_baitTarget(now, surface)
	return surface + Vector3.yAxis * self:_diveOffset(now)
end

function FishingCastSequence:_landingPosition(now, surface)
	return self:_baitTarget(now, surface) + Vector3.yAxis * self:_landingOffset(now - self.landedAt)
end

function FishingCastSequence:_release(now)
	if self.flightStarted then
		return
	end
	if self.castProfile and self.castProfile.Id == "Godlike" then
		BaitElasticMotion.Apply(
			self,
			CFrame.new(self.tip.WorldPosition) * self.bait.CFrame.Rotation,
			self.baitVisualScale
		)
	end
	self.releasePosition, self.flightStarted = self.bait.Position, now
	self.flightDuration = ProjectileMath.FlightTime(self.distance)
	self.flightFromScale = self.baitVisualScale
	self.trail.Enabled = not (self.castProfile and self.castProfile.Id == "Godlike")
	self.trail:Clear()
	self:_setPhase("Flying")
	self:_shot("Chase", 0.35, now)
	if self.castProfile and self.castProfile.Id == "Godlike" then
		self.characterVFX:Release(now, self.bait.Position, Workspace.CurrentCamera.CFrame)
	end
	self:_impulse((self.castProfile or Config.CastProfiles.Normal).ReleaseImpulse, now)
	self.wind = self:_sound("WindLoop")
end

function FishingCastSequence:_splash(now, position, strength)
	local effects = ReplicatedStorage:FindFirstChild("VFX")
	local fishing = effects and effects:FindFirstChild("Fishing")
	local template = fishing and fishing:FindFirstChild("Splash")
	if not (template and template:IsA("BasePart")) then
		if not self.warnedSplash then
			self.warnedSplash = true
			warn("FishingCastSequence: VFX.Fishing.Splash is missing; using water ripples only")
		end
		return
	end
	local part = template:Clone()
	part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
	part.CFrame = CFrame.new(position)
	part.Parent = self.folder
	local splash = { part = part, started = now, emissions = {} }
	self.splashes = self.splashes or {}
	table.insert(self.splashes, splash)
	for _, descendant in ipairs(part:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") then
			descendant.Enabled = false
			local count = math.max(1, math.floor((descendant:GetAttribute("BurstCount") or 1) * strength))
			descendant:Emit(count)
			local second = descendant:GetAttribute("SecondBurstDelay")
			if second then
				table.insert(splash.emissions, { emitter = descendant, at = now + second, count = count })
			end
		end
	end
end

function FishingCastSequence:_ripple(startedAt, position, strength, now)
	return WaterEffects.Ripple(self, startedAt, position, strength, now)
end

function FishingCastSequence:_waterFeedback(now, position, strength, splash, silent)
	position = Vector3.new(position.X, self:_waterTarget().Y, position.Z)
	self:_ripple(now, position, strength)
	if splash then
		self:_splash(now, position, strength)
	end
	if not silent then
		self:_sound("Splash", Config.Sounds.Splash.Volume * strength, 1.1 - strength * 0.2)
	end
end

function FishingCastSequence:_nibbleRipple(now, position)
	WaterEffects.NibbleRipple(self, now, position)
end

function FishingCastSequence:_nibbleFeedback(now, position)
	WaterEffects.Nibble(self, now, position)
end

local playVFX = WaterEffects.Play

function FishingCastSequence:_playWaterVFX(now, name, position, direction, fishScale, fishDiameter)
	local settings = Config.WaterVFX
	if name == settings.Struggle then
		return WaterEffects.PlayStruggle(self, now, position, direction, fishScale, fishDiameter)
	end
	local scale = if name == settings.Exit then fishScale else nil
	return playVFX(self, now, "WaterVFX", name, position, direction, scale)
end

function FishingCastSequence:_playRarityVFX(now, position, rarity, diameter, stage)
	local RarityVFX = require(script.Parent.FishingRarityVFX)
	return RarityVFX.Play(self, now, position, rarity, diameter, stage)
end

function FishingCastSequence:_updateIdleWaterVFX(now)
	local phase = self.bite and self.bite.timeline.phase
	local effect = self.idleWaterVFX
	if not Config.WaterVFX.IdleEnabled or (phase ~= "Waiting" and phase ~= "Approaching" and phase ~= "Holding") then
		if effect then
			effect.model:Destroy()
		end
		self.idleWaterVFX = nil
		return
	end

	local position = self:_waterTarget()
	if effect == nil then
		-- A missing template is retried on the next idle period.
		self.idleWaterVFX = playVFX(self, now, "WaterVFX", Config.WaterVFX.Idle, position, nil, nil, true) or false
	elseif effect and effect.model:GetPivot().Position ~= position then
		effect.model:PivotTo(CFrame.new(position) * effect.rotation)
	end
end

function FishingCastSequence:_updateWaterEffects(now)
	for index = #(self.waterVFX or {}), 1, -1 do
		local effect = self.waterVFX[index]
		if not effect.model.Parent or now >= effect.expiresAt then
			effect.model:Destroy()
			table.remove(self.waterVFX, index)
		else
			updateWaterVFX(effect, now)
		end
	end
	local waterY = self:_waterTarget().Y
	for index = #(self.splashes or {}), 1, -1 do
		local splash = self.splashes[index]
		local position = splash.part.Position
		splash.part.Position = Vector3.new(position.X, waterY, position.Z)
		for burstIndex = #splash.emissions, 1, -1 do
			local burst = splash.emissions[burstIndex]
			if now >= burst.at then
				burst.emitter:Emit(burst.count)
				table.remove(splash.emissions, burstIndex)
			end
		end
		if now >= splash.started + Config.Landing.SplashLifetime then
			splash.part:Destroy()
			table.remove(self.splashes, index)
		end
	end
	for index = #(self.ripples or {}), 1, -1 do
		local ripple = self.ripples[index]
		if updateRipple(ripple, now, waterY) then
			ripple.part:Destroy()
			table.remove(self.ripples, index)
		end
	end
end

function FishingCastSequence:OnCatchEscaped(round, now)
	local bite = self.bite
	if self.destroyed or self.round ~= round or not canTapCatch(bite) then
		return
	end
	self.hookPending, self.catchLookupNeeded = nil, false
	self.catchProgress, self.catchProgressAt = 0, nil
	bite:RejectHook(now, true)
end

function FishingCastSequence:_applyCatchProgress(bite, reply)
	if reply.hookedAt and bite.timeline.phase == "Bite" then
		local localHookAt = self.localRoundStart + (reply.hookedAt - self.serverRoundStart)
		bite:TryHook(math.max(bite.timeline.biteAt, localHookAt), nil, true)
	end
	if reply.sequence and reply.sequence >= self.catchProgressSequence then
		self.catchProgressSequence = reply.sequence
		self.catchProgress, self.catchProgressAt = reply.progress, reply.lastTapAt
	end
end

function FishingCastSequence:_tapCatch(now)
	local bite = self.bite
	if not canTapCatch(bite) or self.hookPending or self.hookExit then
		return false
	end
	if self.lastCatchTap and now - self.lastCatchTap < Config.DeepCatch.MinTapInterval then
		return false
	end
	self.lastCatchTap = now
	self.catchTapSequence += 1
	local sequence, round = self.catchTapSequence, self.round
	local function confirm(result)
		if result.code == "CatchEscaped" then
			self:OnCatchEscaped(round, os.clock())
			return
		end
		local attempt = self.hookPending or self:_awaitCatchConfirmation(bite, round)
		self:_resolveHook(attempt, result, os.clock())
	end
	self.options.tapCatch(round, sequence):timeout(HOOK_CONFIRM_TIMEOUT):andThen(function(reply)
		if self.destroyed or self.bite ~= bite or self.round ~= round or self.hookExit or not canTapCatch(bite) then
			return
		end
		self:_applyCatchProgress(bite, reply)
		if reply.catchResult then
			confirm(reply.catchResult)
		elseif reply.pending then
			if not self.hookPending then
				self:_awaitCatchConfirmation(bite, round)
			end
		elseif reply.ok == false then
			confirm(reply)
		end
	end):catch(function()
		if not self.destroyed and self.bite == bite and canTapCatch(bite) then
			self.catchLookupNeeded = true
		end
	end)
	return true
end

function FishingCastSequence:_awaitCatchConfirmation(bite, round)
	local now = os.clock()
	local attempt = {
		bite = bite,
		round = round,
		lookupAt = now,
		deadline = now + HOOK_CONFIRM_TIMEOUT,
	}
	self.hookPending = attempt
	return attempt
end

function FishingCastSequence:TryHook(now)
	local bite = self.bite
	if not bite or self.hookPending or self.hookExit then
		return false
	end
	if bite.timeline.deepCatch then
		return self:_tapCatch(now)
	end
	if self.options.tutorial and bite.timeline:Advance(now) ~= "Bite" then
		local phase = bite.timeline.phase
		if phase == "Waiting" or phase == "Approaching" or phase == "Holding" or phase == "Nibbling" then
			bite.timeline:_enter("Escaped", now)
			self.serverRetryAt = Workspace:GetServerTimeNow() + Config.Bite.EscapeTime
			if self.options.onEarlyHook then
				self.options.onEarlyHook()
			end
		end
		return false
	end
	if not self.options.hook or bite.timeline:Advance(now) ~= "Bite" then
		local hooked = bite:TryHook(now)
		if self.phase == "Reeling" and self.options.cancel then
			self.options.cancel(self.round)
		end
		return hooked
	end
	if self.hookRound == self.round then
		return false
	end
	local pressedAt = self.serverRoundStart + (now - self.localRoundStart)
	if not bite:TryHook(now, nil, true) then
		return false
	end
	local attempt = {
		bite = bite,
		round = self.round,
		lookupAt = now + HOOK_LOOKUP_DELAY,
		deadline = now + HOOK_CONFIRM_TIMEOUT,
	}
	self.hookRound = self.round
	self.hookPending = attempt
	self.options.hook(self.round, pressedAt):andThen(function(result)
		self:_resolveHook(attempt, result, os.clock())
	end):catch(function()
		if self.hookPending == attempt then
			attempt.lookupAt = os.clock()
		end
	end)
	return true
end

function FishingCastSequence:_resolveHook(attempt, result, now)
	if self.destroyed or self.hookPending ~= attempt then
		return
	end
	if result.code == "CatchEscaped" then
		self:OnCatchEscaped(attempt.round, now)
		return
	end
	self.hookPending = nil
	if result.ok then
		if attempt.bite.timeline.deepCatch then
			self.catchProgress = 1
		end
		attempt.bite:ConfirmHook(now, result)
		return
	end

	attempt.bite:RejectHook(now)
	if result.message == "Missed the bite" then
		if self.options.tutorial then
			self.serverRetryAt = Workspace:GetServerTimeNow() + Config.Bite.EscapeTime
		end
	else
		self.hookExit = { at = now + Config.Bite.EscapeTime, message = result.message }
	end
end

function FishingCastSequence:_updateHookConfirmation(now)
	local attempt = self.hookPending
	if not attempt then
		if self.catchLookupNeeded and not self.catchLookupPending and now >= (self.catchLookupAt or 0) then
			local bite = self.bite
			self.catchLookupNeeded, self.catchLookupPending = false, true
			self.options.getHookResult(self.round):timeout(HOOK_LOOKUP_TIMEOUT):andThen(function(reply)
				if self.destroyed or self.bite ~= bite or not canTapCatch(bite) then
					return
				end
				self:_applyCatchProgress(bite, reply)
				if reply.status == "Succeeded" or reply.status == "Rejected" then
					local recovery = self.hookPending or self:_awaitCatchConfirmation(bite, self.round)
					self:_resolveHook(recovery, reply.result, os.clock())
				elseif reply.status == "Pending" and not self.hookPending then
					self:_awaitCatchConfirmation(bite, self.round)
				end
			end):catch(function()
				if self.bite == bite then
					self.catchLookupNeeded = true
				end
			end):finally(function()
				if self.bite == bite then
					self.catchLookupPending = false
					self.catchLookupAt = os.clock() + HOOK_LOOKUP_INTERVAL
				end
			end)
		end
		return
	end
	if now >= attempt.deadline then
		self.hookPending = nil
		attempt.bite:RejectHook(now)
		attempt.bite:TryHook(now)
		self.hookExit = { message = "Could not confirm the catch." }
		return
	end
	if attempt.lookupPending or now < attempt.lookupAt then
		return
	end

	attempt.lookupPending = true
	self.options.getHookResult(attempt.round):timeout(HOOK_LOOKUP_TIMEOUT):andThen(function(reply)
		if reply.status == "Succeeded" or reply.status == "Rejected" then
			self:_resolveHook(attempt, reply.result, os.clock())
		end
	end):catch(function() end):finally(function()
		attempt.lookupPending = false
		attempt.lookupAt = os.clock() + HOOK_LOOKUP_INTERVAL
	end)
end

function FishingCastSequence:CanReturn(now)
	return not self.hookPending and not self.hookExit and self.bite ~= nil and self.bite:CanReturn(now)
end

function FishingCastSequence:_setBaitVisible(visible)
	if self.baitVisible == visible then
		return
	end
	self.baitVisible = visible
	for instance, transparency in pairs(self.baitAppearance) do
		instance.Transparency = if visible then transparency else 1
	end
end

function FishingCastSequence:_presentBait(phase, elapsed)
	if self.bitePrompt then
		local settings = Config.Bite.Prompt
		local alpha = if phase == "Bite" then math.clamp((elapsed or 0) / settings.PopTime, 0, 1) else 0
		local pop = TweenService:GetValue(alpha, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		self.bitePromptScale.Scale = settings.StartScale + (1 - settings.StartScale) * pop
		self.bitePrompt.Enabled = phase == "Bite" and not (self.bite and self.bite.timeline.deepCatch)
	end
	local visible = phase ~= "Lifting" and phase ~= "Caught" and phase ~= "Reeled"
	self:_setBaitVisible(visible)
	local fade = if phase == "Struggling"
		then math.clamp((elapsed or 0) / Config.Bite.Struggle.HighlightFadeTime, 0, 1)
		elseif not visible then 1
		else 0
	fade = fade * fade * (3 - 2 * fade)
	local biting = phase == "Bite" or phase == "Struggling"
	local firstPerson = phase == "Approaching" and self.bite and self.bite.timeline.deepCatch
	local waitingUnderwater = firstPerson or (not biting and visible and phase ~= "Reeling"
		and (self.fishingDepth or 0) > 0 and WaterSurfaceUtil.IsPointSubmerged(self.bait.Position))
	local fill = if biting then Config.Bite.BaitFillTransparency elseif waitingUnderwater then 0.86 else 1
	self.baitHighlight.FillColor = if waitingUnderwater then self.waitingBaitFill else self.bitingBaitFill
	self.baitHighlight.FillTransparency = fill + (1 - fill) * fade
	self.baitHighlight.OutlineTransparency = fade
	self.baitHighlight.Enabled = visible and fade < 1
end

function FishingCastSequence:_updateLine()
	local bite = self.bite
	local reeling = bite and (bite.timeline.phase == "Reeling" or bite.timeline.phase == "Reeled")
	self.lineEnd.Position = (bite and bite.linePosition)
		or (self.baitTop and self.baitTop.WorldPosition)
		or self.bait.Position
	local vertical = bite and (bite.timeline.phase == "Lifting" or bite.timeline.phase == "Caught" or reeling)
	self.line.FaceCamera = true
	if vertical then
		self.lineTop.Position = self.lineEnd.Position + Vector3.yAxis * Config.Bite.ShowcaseLineHeight
		self.line.Attachment0 = self.lineTopAttachment
	else
		self.line.Attachment0 = self.tip
	end
end

function FishingCastSequence:_startBiteRound(now, readyAt, round)
	if self.bite then
		self.bite:Destroy()
		self.bite = nil
		for _, effect in ipairs(self.splashes or {}) do
			effect.part:Destroy()
		end
		for _, effect in ipairs(self.ripples or {}) do
			effect.part:Destroy()
		end
		for _, effect in ipairs(self.waterVFX or {}) do
			effect.model:Destroy()
		end
		self.waterVFX = {}
		self.splashes, self.ripples = {}, {}
	end
	if (self.fishingDepth or 0) == 0 then
		BaitElasticMotion.Apply(self, CFrame.new(self:_waterTarget()) * CFrame.Angles(0, self.spin or 0, 0), Vector3.one)
	end
	self:_presentBait("Waiting")
	self.catchProgress, self.catchProgressAt, self.lastCatchTap = 0, nil, nil
	self.catchTapSequence, self.catchProgressSequence = 0, 0
	self.catchLookupNeeded, self.catchLookupPending, self.catchLookupAt = false, false, nil
	if round then
		local fish, template
		if self.options.resolveCatch then
			fish, template = self.options.resolveCatch(round.catchKind or "Fish", round.catchId or round.fishId)
		else
			fish, template = self.options.resolveFish(round.fishId)
		end
		assert(template, "Selected fish model unavailable")
		self.bite = FishingBiteSequence.new(
			self, now, readyAt, Random.new(round.seed), Random.new(round.motionSeed), template, fish, round.catchKind, self.options.tutorial, round.weight
		)
		local timeline = self.bite.timeline
		local biteAt = now + (round.biteAt - round.startedAt)
		if round.entrance and self.options.tapCatch then
			self.bite:SetDeepCatch(round.entrance, biteAt, round.seed)
			self.catchProgress, self.catchProgressAt = Config.DeepCatch.InitialProgress, round.biteAt
		else
			timeline.scheduledBiteAt = biteAt
			timeline.scheduledBiteEndsAt = now + (round.biteEndsAt - round.startedAt)
		end
		if round.mutationId then
			self.bite:PreviewMutation(round.mutationId)
		end
		self.bite.fish:SetAttribute("FishId", fish.FishID)
		self.bite.fish:SetAttribute("CatchKind", round.catchKind or "Fish")
		self.bite.fish:SetAttribute("CatchId", round.catchId or fish.FishID)
		self.bite.fish:SetAttribute("Rarity", fish.Rarity)
		self.bite.fish:SetAttribute("DisplayName", fish.DisplayName)
		self.folder:SetAttribute("Luck", round.luck)
		if self.info then
			self.info:SetLuck(round.luck, os.clock())
		end
		self.round = round.round
	else
		self.bite = FishingBiteSequence.new(self, now, readyAt)
		self.round = (self.round or 0) + 1
	end
	self.folder:SetAttribute("Round", self.round)
end

function FishingCastSequence:_requestBiteRound()
	if self.roundPending or (self.roundRetryAt and os.clock() < self.roundRetryAt) then
		return
	end
	self.roundPending = true
	self.options.requestRound(self.round or 0):andThen(function(round)
		if self.destroyed then
			return
		end
		self.roundPending = false
		if round.code == "RoundNotReady" then
			self.roundRetryAt = os.clock() + math.max(0.05, round.retryAfter)
			return
		end
		self.roundRetryAt = nil
		if not round.ok then
			self.options.onFailure(round.message)
			return
		end
		-- Deep catches share the server's bite clock. Keep the send-time anchor for legacy timestamped hooks.
		local receivedAt = os.clock()
		self.serverRoundStart = round.startedAt
		self.serverRetryAt = round.retryAt
		local serverAnchor = if round.entrance then Workspace:GetServerTimeNow() else round.sentAt
		self.localRoundStart = receivedAt + (round.startedAt - serverAnchor)
		local localReadyAt = self.localRoundStart + (round.readyAt - round.startedAt)
		self.readyAt = math.max(self.readyAt, localReadyAt)
		self:_startBiteRound(self.localRoundStart, self.readyAt, round)
	end):catch(function(err)
		if not self.destroyed then
			warn("FishingCastSequence: " .. tostring(err))
			self.options.onFailure("Could not start the next fishing round")
		end
	end)
end

function FishingCastSequence:_land(now)
	BaitElasticMotion.CommitFlightGrowth(self)
	self.bitePrompt.StudsOffsetWorldSpace = Vector3.new(
		0, self.baitBaseSize.Y * 0.5 + Config.Bite.Prompt.HeightOffset, 0
	)
	self.landedAt = now
	self.readyAt = now + Config.GetLandingSettleTime()
	self.trail.Enabled = false
	if self.castProfile and self.castProfile.Id == "Godlike" then
		self.characterVFX:StopFlight(now)
	end
	self.track:Stop(0)
	RigUtil.ApplyReadyPose(self.rig)
	self:_setPhase("Waiting")
	self:_shot("Landing", 0.4, now)
	if (self.fishingDepth or 0) > 0 then
		self.shotFocusFrom = self.shotFocusFrom or self.bait.Position
		self.diveCameraOffset = self.shotFrom.Position - self.shotFocusFrom
	end
	local strength = math.clamp(self.distance / 400, 0, 1)
	self:_impulse(Config.Camera.Landing, now, strength)
	self:_sound("Splash", Config.Sounds.Splash.Volume + strength * 0.2, 0.95 - strength * 0.25)
	local surface = self:_waterTarget()
	self:_playWaterVFX(now, Config.WaterVFX.Entry, surface)
	self.continueLabel.Visible = false
	for index = 1, 3 do
		self:_ripple(now + (index - 1) * Config.WaterRipple.LandingInterval, surface, 1, now)
	end
	if self.options.requestRound then
		self:_requestBiteRound()
	else
		self:_startBiteRound(now, self.readyAt)
	end
end

function FishingCastSequence:_updateAction(now)
	local profile = self.castProfile or Config.CastProfiles.Normal
	if not self.actionStarted then
		self.castProfile = profile
		local elapsed = now - self.castClickedAt
		if self.castWindup then
			RigUtil.ApplyCastWindup(self.rig, math.clamp(elapsed / profile.LeadTime, 0, 1))
		end
		if self.castWindupPending or elapsed < profile.LeadTime or not CastPresentation.Ready(self, now) then
			return
		end
		self.castWindup = nil
		self.actionStarted = now
		RigUtil.RestoreReadyPose(self.rig)
		CastPresentation.Play(self)
		self.characterVFX:Start(now)
		if profile.Id == "Godlike" then
			self:_shot("Special", 0, now)
		end
		if self.fishAudio then
			self.fishAudio:Play("FishingRodCast")
			self.fishAudio:Play("FishingCastWind")
		end
	end
	local elapsed = now - self.actionStarted
	if profile.Id == "Godlike" then
		if elapsed >= profile.TrailTime and not self.rainbowTrailStarted then
			self.rainbowTrailStarted = true
			self.characterVFX:BeginTrail(now)
		end
		if elapsed >= profile.LandingTime and not self.specialLanded then
			self.specialLanded = true
			self.characterVFX:Land(now)
			self:_impulse(profile.LandingImpulse, now)
		end
		if elapsed >= profile.ChargeTime and not self.specialCharged then
			self.specialCharged = true
			self.characterVFX:Charge(now)
		end
	end
	if elapsed >= profile.ImpactTime and not self.swingStarted then
		self.swingStarted = true
		self.characterVFX:BeginSwing(now)
		if profile.ImpactImpulse then
			self:_impulse(profile.ImpactImpulse, now)
		end
		if self.fishAudio then
			self.fishAudio:Play("FishingCastImpact")
		end
	end
	if profile.Id ~= "Godlike" and elapsed >= profile.FrontTime and not self.frontShown then
		self.frontShown = true
		self:_shot("Front", 0.28, now)
		self:_impulse(Config.Camera.Front, now)
		self:_sound("CameraWhoosh")
	end
	if elapsed >= profile.OrbitTime and not self.orbitShown then
		self.orbitShown = true
		if profile.Id ~= "Godlike" then
			self:_shot("Orbit", 0.3, now)
			self:_impulse(Config.Camera.Orbit, now)
		end
		self:_sound("SpinWhoosh")
	end
	if elapsed >= profile.ReleaseTime then
		self:_release(now)
	end
end

function FishingCastSequence:_landingOffset(elapsed)
	local settings = Config.Landing
	local sink = -BaitElasticMotion.BaseSize(self).Y * settings.SinkDepth
	local peak = BaitElasticMotion.BaseSize(self).Y * settings.ReboundHeight
	local reboundEnd = settings.SinkTime + settings.ReboundTime
	if elapsed < settings.SinkTime then
		local alpha = math.clamp(elapsed / settings.SinkTime, 0, 1)
		return sink * (1 - (1 - alpha) ^ 2)
	elseif elapsed < reboundEnd then
		local alpha = (elapsed - settings.SinkTime) / settings.ReboundTime
		return sink + (peak - sink) * alpha * alpha * (3 - 2 * alpha)
	elseif elapsed < landingDuration() then
		local alpha = (elapsed - reboundEnd) / settings.SettleTime
		return peak * BaitElasticMotion.Settle(alpha)
	end
	return 0
end

function FishingCastSequence:_updateBait(now, dt)
	local initialRotation = CFrame.Angles(0, self.initialYaw or 0, 0)
	if self.phase == "Preparing" or self.phase == "Casting" then
		local elapsed = now - (self.castClickedAt or self.meterStarted)
		local offset, scale = BaitElasticMotion.Sample(self.phase, elapsed)
		if self.phase == "Preparing" then
			scale *= self:_updateBaitAppear(now)
		end
		local heldLength = if self.castProfile and self.castProfile.Id == "Godlike" then 0.4 else 1.5
		local position = self.tip.WorldPosition
			- Vector3.new(0, heldLength, 0)
			+ Vector3.yAxis * BaitElasticMotion.BaseSize(self).Y * offset
		if self.phase == "Casting" then
			local alpha = math.clamp((now - (self.castBlendAt or self.castClickedAt)) / Config.BaitElastic.BlendTime, 0, 1)
			alpha = alpha * alpha * (3 - 2 * alpha)
			position += (self.castFromOffset or Vector3.zero) * (1 - alpha)
			scale = (self.castFromScale or Vector3.one):Lerp(scale, alpha)
		end
		BaitElasticMotion.Apply(self, CFrame.new(position) * initialRotation, scale)
		if self.phase == "Casting" then
			self:_updateAction(now)
		end
	elseif self.phase == "Flying" then
		local elapsed = math.min(now - self.flightStarted, self.flightDuration)
		-- 落水前按实际水面重采样终点高度，避免高度跳变。
		local arc = ProjectileMath.CreateArc(self.releasePosition, self:_waterTarget(), self.flightDuration)
		local position = arc:PositionAt(elapsed)
		self.velocity, self.progress = arc:VelocityAt(elapsed), elapsed / self.flightDuration
		local spin = elapsed * 7
		self.spin = (self.initialYaw or 0) + spin
		local _, scale = BaitElasticMotion.Sample("Flying", elapsed, self.flightDuration)
		local blend = math.clamp(elapsed / Config.BaitElastic.BlendTime, 0, 1)
		blend = blend * blend * (3 - 2 * blend)
		scale = (self.flightFromScale or Vector3.one):Lerp(scale, blend)
		scale *= BaitElasticMotion.SampleFlightGrowth(self.progress)
		local frame = if elapsed >= self.flightDuration
			then CFrame.new(self:_waterTarget()) * CFrame.Angles(0, self.spin, 0)
			else CFrame.new(position) * initialRotation * CFrame.Angles(spin * 0.7, spin, spin * 0.3)
		BaitElasticMotion.Apply(self, frame, scale)
		self.wind.Volume = math.clamp(self.velocity.Magnitude / 90, 0.1, 0.7)
		self.wind.PlaybackSpeed = 0.85 + math.clamp(self.velocity.Magnitude / 120, 0, 0.5)
		if elapsed >= self.flightDuration then
			self:_land(now)
		end
	elseif self.landedAt then
		local elapsed = now - self.landedAt
		self.wind.Volume *= math.exp(-dt * 12)
		if elapsed > 0.3 then
			self.wind:Stop()
		end
		if self.roundRetryAt then
			self:_requestBiteRound()
		end
		if self.bite then
			self.bite:Update(now, true)
			if not self.hookPending and not self.hookExit and self.bite:CanRetry(now) then
				if self.bite.timeline.deepCatch then
					self.bite:TryHook(now)
					self.options.cancel(self.round)
				elseif self.options.requestRound then
					if Workspace:GetServerTimeNow() >= self.serverRetryAt + 0.05 then
						self:_requestBiteRound()
					end
				else
					self:_startBiteRound(now)
					self.bite:Update(now, true)
				end
			end
		elseif (self.fishingDepth or 0) > 0 then
			-- 等待服务端回合期间，鱼饵仍按真实落水时刻下潜。
			local position = self:_landingPosition(now, self:_waterTarget())
			BaitElasticMotion.Apply(self, CFrame.new(position) * CFrame.Angles(0, self.spin or 0, 0), Vector3.one)
			self:_presentBait("Settling", elapsed)
		end
	end
end

function FishingCastSequence:_showcaseProgress(now)
	local settings, timeline = Config.Bite, self.bite.timeline
	local elapsed = now - timeline.startedAt
	if not self.bite.isEgg then
		self.bite:_prepareLift(self:_waterTarget())
		local plan = self.bite.liftPlan
		if timeline.phase == "Caught" then
			elapsed += plan.timing.duration
		end
		local fish = settings.FishLift
		local entry = math.clamp((elapsed - plan.exitAt - fish.CameraHold) / fish.CameraBlend, 0, 1)
		local pullback = math.clamp(elapsed / plan.timing.riseEnd, 0, 1)
		return entry * entry * (3 - 2 * entry), pullback * pullback * (3 - 2 * pullback)
	end
	if timeline.phase == "Caught" then
		elapsed += settings.LiftTime
	end
	local entry = math.clamp(elapsed / 0.25, 0, 1)
	local pullbackAt = settings.LiftTime * settings.LiftRiseEnd + settings.ShowcaseCloseupHold
	local pullback = math.clamp((elapsed - pullbackAt) / settings.ShowcasePullbackTime, 0, 1)
	return entry * entry * (3 - 2 * entry), pullback * pullback * (3 - 2 * pullback)
end

function FishingCastSequence:_showcaseCamera(target, viewport)
	local settings, bite = Config.Bite, self.bite
	local aspect = math.max(viewport.X, 1) / math.max(viewport.Y, 1)
	local tangent = math.tan(math.rad(settings.ShowcaseFov * 0.5))
	local halfAngle = math.atan(tangent * math.min(aspect, 1))
	local scale = bite.catchScale or bite.defaultScale or 1
	local distance = math.max(
		settings.ShowcaseMinDistance,
		settings.ShowcaseCloseupDistance,
		(bite.halfLength * scale + settings.ShowcasePadding) / (tangent * settings.ShowcaseScreenFraction),
		(bite.bodyWidth * scale * 0.5 + settings.ShowcasePadding) / (tangent * aspect * settings.ShowcaseScreenFraction),
		(bite:GetShowcaseRadius() + settings.ShowcasePadding) / math.sin(halfAngle)
	)
	local focus = target + Vector3.yAxis * bite:GetShowcaseHeight()
	return CFrame.lookAt(focus - self.forward * distance, focus), focus
end

-- 鱼蛋展示和水下取景使用包围球补足镜头距离。
function FishingCastSequence:_protectShowcase(frame, center, radius, viewport, fov, weight)
	local relative = frame:PointToObjectSpace(center)
	local vertical = math.rad(fov * 0.5)
	local aspect = math.max(viewport.X, 1) / math.max(viewport.Y, 1)
	local horizontal = math.atan(math.tan(vertical) * aspect)
	local depth = math.max(
		(math.abs(relative.X) * math.cos(horizontal) + radius) / math.sin(horizontal),
		(math.abs(relative.Y) * math.cos(vertical) + radius) / math.sin(vertical)
	)
	-- 沿当前镜头后退，保留滞后取景，同时保证包括震动在内的完整包围球入镜。
	return frame * CFrame.new(0, 0, math.max(0, depth + relative.Z) * weight)
end

-- 延迟追随并少量抬升机位，抬头保留高度感；下落后逐渐恢复水平展示。
function FishingCastSequence:_fishLiftCamera(now, target)
	local bite, settings = self.bite, Config.Bite.FishLift
	bite:_prepareLift(target)
	local plan = bite.liftPlan
	local elapsed = now - bite.timeline.startedAt
	if bite.timeline.phase == "Caught" then
		elapsed += plan.timing.duration
	end
	if not self.showcaseFrom then
		local incoming = self.renderedStruggleFrame or self.cameraFrame
		self.showcaseFrom = incoming - target
		self.showcaseFocus = (self.renderedStruggleFocus or self.cameraFocus or self.biteFocus or target) - target
	end
	local entry, pullback = self:_showcaseProgress(now)
	local settle = smoothstep((elapsed - plan.timing.landAt) / (plan.timing.duration - plan.timing.landAt))
	local scale = bite.catchScale or bite.defaultScale or 1
	local laggedAt = math.clamp(elapsed - settings.CameraLag * (1 - settle), 0, plan.timing.duration)
	local laggedFrame = bite:_liftFrame(laggedAt, target)
	local laggedScale = bite:_scaleAt("Lifting", laggedAt)
	local centerOffset = bite.showcaseCenterOffset
	local lagged = laggedFrame:PointToWorldSpace(centerOffset * laggedScale)
	-- 落定机位由基础姿态决定，鱼身摆动只改变注视点。
	local goalFocus = bite:_liftFrame(plan.timing.duration, target):PointToWorldSpace(centerOffset * scale)
	local focus = (target + self.showcaseFocus):Lerp(lagged:Lerp(goalFocus, settle), entry)
	local size = math.max(bite.halfLength * 2, bite.bodyWidth) * scale
	local distance = Config.Bite.ShowcaseCloseupDistance
		+ math.clamp((size - settings.CameraPullbackStartSize) * settings.CameraPullbackPerStud, 0, settings.CameraMaxPullback)
	local incoming = (self.showcaseFrom + target).Position
	local depth = self.fishingDepth or 0
	if depth > 0 then
		-- 展示镜头按原有水面构图求解，先跟随鱼的起升，再从出水点接入展示。
		focus += Vector3.yAxis * depth * (1 - entry)
	end
	local level = smoothstep((elapsed - plan.timing.fallStart) / (plan.timing.duration - plan.timing.fallStart))
	local surfaceEye = incoming + Vector3.yAxis * depth
	local eye = focus - self.forward * distance
		- Vector3.yAxis * (focus.Y - surfaceEye.Y) * (1 - settings.CameraRiseFollow) * (1 - level)
	local position = surfaceEye:Lerp(eye, pullback)
	if depth > 0 and elapsed < plan.exitAt + settings.CameraBlend then
		local rise = bite:_liftFrame(elapsed, target).Position - (target + bite.liftInitial.Position)
		local blend = smoothstep((elapsed - plan.exitAt) / settings.CameraBlend)
		position = (incoming + rise):Lerp(position, blend)
		focus = (target + self.showcaseFocus + rise):Lerp(focus, blend)
	end
	if bite.showcaseFramingCenter then
		focus = focus:Lerp(bite.showcaseFramingCenter, settle)
	end
	return CFrame.lookAt(position, focus), focus, settle
end

function FishingCastSequence:_reelCamera(target, viewport)
	local settings = Config.Bite
	local aspect = math.max(viewport.X, 1) / math.max(viewport.Y, 1)
	local tangent = math.tan(math.rad(settings.ShowcaseFov * 0.5))
	-- 镜头随鱼饵移动，取景距离只由鱼饵尺寸和视口决定。
	local radius = BaitElasticMotion.BaseSize(self).Magnitude * Config.BaitElastic.MaxStretch * 0.5
		+ settings.ShowcasePadding
	local halfAngle = math.atan(tangent * math.min(aspect, 1) * settings.ShowcaseScreenFraction)
	local distance = math.max(
		Config.Reel.CameraMinDistance,
		radius / math.sin(halfAngle)
	)
	local motion = self.bite and self.bite.reelMotion
	local focus = target + (if motion then motion.position else Vector3.yAxis * settings.ShowcaseHeight)
	return CFrame.lookAt(focus - self.forward * distance, focus), focus
end

function FishingCastSequence:_baitViewCamera(now, dt, viewport)
	local settings, view = Config.Camera.WaterFraming, Config.Camera.BaitView
	local surface, bite = self:_waterTarget(), self.bite
	local target = self:_baitTarget(now, surface)
	local aspect = math.max(viewport.X, 1) / math.max(viewport.Y, 1)
	local narrowAxis = math.min(aspect, 1)
	local tangent = math.tan(math.rad(view.Fov * 0.5)) * narrowAxis
	local size = BaitElasticMotion.BaseSize(self)
	local baitRadius = size.Magnitude * Config.BaitElastic.MaxStretch * 0.5
	local contactRadius = Vector2.new(size.X, size.Z).Magnitude * Config.BaitElastic.MaxStretch * 0.5
	local travel = size.Y * math.max(
		Config.Landing.SinkDepth,
		Config.Landing.ReboundHeight,
		Config.Bite.BiteDepthFraction + Config.BaitElastic.BiteBounceHeight
	)
	-- 落水后用鱼饵基础尺寸预留屏幕空间，鱼的运动只改变朝向和焦距。
	local offset = -self.forward * view.Distance + Vector3.yAxis * view.Height
	local distance = math.max(offset.Magnitude, travel + math.max(
		baitRadius / math.sin(math.atan(tangent * settings.BaitFrameFraction)),
		contactRadius / (tangent * settings.BaitCenterFraction)
	))
	local eye = target + offset.Unit * distance
	local baitPosition = bite and bite.lastBaitPosition or target
	if (self.fishingDepth or 0) > 0 then
		eye = Vector3.new(eye.X, target.Y + view.Height, eye.Z)
		if self.landedAt and (not bite or bite.timeline.phase == "Settling") then
			baitPosition = self:_landingPosition(now, surface)
		end
	end
	local neutral = CFrame.lookAt(eye, baitPosition)
	local desiredAim, desiredFov = Vector2.zero, view.Fov
	local contactWeight = 0
	local phase = bite and bite.timeline.phase
	if bite and not bite.timeline.deepCatch and bite.lastPathPosition
		and phase ~= "Settling" and phase ~= "Waiting" and phase ~= "Escaped"
	then
		local elapsed = math.max(0, now - bite.timeline.startedAt)
		if phase == "Bite" then
			contactWeight = smoothstep(elapsed / Config.Bite.BiteSinkTime)
		elseif phase == "Nibbling" then
			local timing = bite.timeline:GetNibbleTiming()
			contactWeight = smoothstep(elapsed / timing.attackTime)
				* (1 - smoothstep((elapsed - timing.returnAt) / Config.Bite.Nibble.ReboundTime))
		end

		local radius = math.max(bite.halfLength, bite.presentationRadius) * bite.scale
		local sizeFraction = radius / (distance * tangent)
		local sizeWeight = smoothstep((sizeFraction - settings.SizeWidenStart)
			/ (settings.SizeWidenFull - settings.SizeWidenStart))
		local flat = (bite.lastPathPosition - baitPosition) * Vector3.new(1, 0, 1)
		local separation = flat.Magnitude - bite.halfLength * bite.scale
		local distanceWeight = smoothstep((separation - settings.DistanceStart)
			/ (settings.DistanceFull - settings.DistanceStart))
		local direction = neutral:VectorToObjectSpace(flat)
		local projected = Vector2.new(direction.X, direction.Y)
		if projected.Magnitude > 0.00001 then
			desiredAim = projected.Unit * distanceWeight
		end
		desiredFov += sizeWeight * settings.SizeFov + distanceWeight * settings.DistanceFov * (1 - contactWeight)
	end

	local fov = self.baitViewFov or view.Fov
	if desiredFov >= fov then
		self.baitViewNarrowAt = nil
		fov += (desiredFov - fov) * (1 - 0.5 ^ (dt / settings.WidenHalfLife))
	else
		self.baitViewNarrowAt = self.baitViewNarrowAt or now
		local narrowDt = math.clamp(now - self.baitViewNarrowAt - settings.NarrowDelay, 0, dt)
		fov += (desiredFov - fov) * (1 - 0.5 ^ (narrowDt / settings.NarrowHalfLife))
	end
	self.baitViewFov = fov

	local aim = (self.baitViewAim or Vector2.zero):Lerp(desiredAim, 1 - 0.5 ^ (dt / settings.AimHalfLife))
	self.baitViewAim = aim
	local safeSlope = math.tan(math.rad(fov * 0.5)) * narrowAxis * settings.BaitCenterFraction
	local slope = aim * math.min(safeSlope, math.tan(math.rad(settings.MaxTurn)))
	if contactWeight > 0 and bite.lastBaitContact then
		local contact = neutral:PointToObjectSpace(bite.lastBaitContact)
		local contactSlope = Vector2.new(contact.X, contact.Y) / math.max(-contact.Z, 0.001)
		slope = slope:Lerp(contactSlope, contactWeight)
	end
	if slope.Magnitude > safeSlope then
		slope = slope.Unit * safeSlope
	end
	local depth = (baitPosition - eye).Magnitude
	local focus = baitPosition + (neutral.RightVector * slope.X + neutral.UpVector * slope.Y) * depth
	return CFrame.lookAt(eye, focus), fov, focus
end

function FishingCastSequence:_deepCatchCamera(target, time, viewport)
	local bite, settings = self.bite, Config.DeepCatch
	local baitRadius = BaitElasticMotion.BaseSize(self).Magnitude * 0.5
	local progress = math.clamp(time / settings.EntranceTime, 0, 1)
	local mouth = bite.lastMouthPosition
	local toBait = target - mouth
	local eye = mouth + toBait.Unit * math.min(0.3, toBait.Magnitude * 0.5)
	local roll = math.sin(progress * math.pi * 2 * settings.SwayCycles) * (1 - progress) * math.rad(settings.RollDegrees)
	local fov = 76 - 12 * smoothstep(progress)
	local frame = CFrame.lookAt(eye, target) * CFrame.Angles(0, 0, roll)
	return self:_protectShowcase(frame, target, baitRadius, viewport, fov, 1), fov, target
end

function FishingCastSequence:_updateDeepCatchSpeedLines(cameraFrame)
	local effect = self.deepCatchSpeedLines
	if not cameraFrame then
		if effect then
			effect:Destroy()
			self.deepCatchSpeedLines = nil
		end
		return
	end

	local effectFrame = cameraFrame * CFrame.new(0, 0, -5) * CFrame.Angles(math.pi * 0.5, 0, 0)
	if effect then
		effect.CFrame = effectFrame
		return
	end
	if self.deepCatchSpeedLinesMissing then
		return
	end
	local particle = ReplicatedStorage:FindFirstChild("Particle")
	local boost = particle and particle:FindFirstChild("SpeedBoost")
	local template = boost and boost:FindFirstChild("WindStreaks")
	if not (template and template:IsA("BasePart")) then
		self.deepCatchSpeedLinesMissing = true
		warn("FishingCastSequence: Particle.SpeedBoost.WindStreaks is missing")
		return
	end
	effect = template:Clone()
	effect.Name = "DeepCatchSpeedLines"
	effect.Anchored, effect.CanCollide, effect.CanTouch, effect.CanQuery = true, false, false, false
	effect.CFrame = effectFrame
	for _, descendant in effect:GetDescendants() do
		if descendant:IsA("ParticleEmitter") then
			descendant.Rate *= 0.6
			descendant.Enabled = true
		end
	end
	self.deepCatchSpeedLines = effect
	effect.Parent = self.folder
end

function FishingCastSequence:_chaseCamera(dt)
	local velocity = self.velocity or self.forward
	local direction = if velocity.Magnitude > 0.01 then velocity.Unit else self.forward
	local progress = self.progress or 0
	local bait = self.bait.Position
	local desired = bait - self.forward * (9 + progress * 6)
		+ Vector3.yAxis * (3.5 + progress * 3) - direction * 2
	self.chaseEye = self.chaseEye:Lerp(desired, 1 - math.exp(-41.5 * dt))
	local focus = bait + direction * 4
	local eye = self.chaseEye
	if self.chaseStartPitch then
		local dive = Config.Camera.Dive
		local blend = smoothstep(progress / dive.FlightPitchEnd)
		local pitch = self.chaseStartPitch + (math.rad(dive.EntryPitch) - self.chaseStartPitch) * blend
		local distance = (desired - focus).Magnitude
		focus = focus:Lerp(bait, blend)
		local horizontal = (eye - focus) * Vector3.new(1, 0, 1)
		local heading = if horizontal.Magnitude > 0.001 then horizontal.Unit else -self.forward
		eye = focus + (heading * math.cos(pitch) + Vector3.yAxis * math.sin(pitch)) * distance
	end
	return CFrame.lookAt(eye, focus), 66 + math.clamp(velocity.Magnitude * 0.12, 0, 16),
		if self.chaseStartPitch then focus else bait
end

function FishingCastSequence:_diveCamera(now, elapsed, alpha, settledShot, settledFocus)
	local surface = self:_waterTarget()
	local movingBait = self:_landingPosition(now, surface)
	-- 承接上一帧，再将飞行机位相对鱼饵的偏移带过水线。
	local focus = self.shotFocusFrom:Lerp(surface, alpha) + (movingBait - surface)
	local blendTime = Config.Camera.Dive.SettleBlendTime
	local blend = smoothstep((elapsed - (Config.Landing.DiveTime - blendTime)) / blendTime)
	local eye = (focus + self.diveCameraOffset):Lerp(settledShot.Position, blend)
	focus = focus:Lerp(settledFocus, blend)
	return CFrame.lookAt(eye, focus), focus
end

function FishingCastSequence:_wallSafeStruggleFrame(frame, anchor, clearance)
	local offset = frame.Position - anchor
	if offset.Magnitude < 0.001 then
		return frame
	end
	local params = self.struggleRaycastParams
	if not params then
		params = RaycastParams.new()
		params.IgnoreWater = true
		params.RespectCanCollide = true
		self.struggleRaycastParams = params
	end
	local excluded = { self.folder }
	if self.rig then
		table.insert(excluded, self.rig)
	end
	for _, player in Players:GetPlayers() do
		if player.Character then
			table.insert(excluded, player.Character)
		end
	end
	local waterTop = WaterSurfaceUtil.GetWaterTop()
	if waterTop then
		for _, part in waterTop.Parent:GetChildren() do
			if part.Name == "Top" and part:IsA("BasePart") then
				table.insert(excluded, part)
			end
		end
	end
	params.FilterDescendantsInstances = excluded
	local hit = Workspace:Spherecast(anchor, clearance, offset, params)
	local distance = hit and hit.Distance
	if not distance then
		-- 球扫不会返回初始重叠，中心射线仍可识别紧贴起点的墙。
		local ray = Workspace:Raycast(anchor, offset, params)
		distance = ray and ray.Distance - clearance
	end
	if not distance then
		return frame
	end
	local eye = anchor + offset.Unit * math.max(0, distance - 0.05)
	return CFrame.new(eye) * frame.Rotation
end

function FishingCastSequence:_struggleCamera(now, dt, viewport)
	local bite, settings = self.bite, Config.Camera.Struggle
	local startedAt = bite.timeline.startedAt
	local view = self.struggleView
	if not view or view.bite ~= bite or (not bite.timeline.deepCatch and view.startedAt ~= startedAt) then
		local anchor = self:_waterTarget() - Vector3.yAxis * (self.fishingDepth or 0)
		local baitView = Config.Camera.BaitView
		local fov = baitView.Fov
		local offset = -self.forward * baitView.Distance + Vector3.yAxis * baitView.Height
		if Config.Camera.FollowFishEnabled then
			local aspect = math.max(viewport.X, 1) / math.max(viewport.Y, 1)
			local halfAngle = math.atan(math.tan(math.rad(fov * 0.5)) * math.min(aspect, 1))
			local radius = math.max(bite.halfLength, bite.presentationRadius) * bite.scale + 2
			local distance = math.max(16, radius / math.sin(halfAngle))
			offset = (-self.forward * 0.8 + Vector3.yAxis * 0.65) * distance
		end
		local eye = anchor + limitMagnitude(offset, settings.BaseDistance)
		local fixed = CFrame.lookAt(eye, anchor)
		local clearance = settings.WallClearance + settings.MaxShakeOffset
		view = {
			bite = bite,
			startedAt = startedAt,
			anchor = anchor,
			frame = self:_wallSafeStruggleFrame(fixed, anchor, clearance),
			fov = fov,
		}
		if not bite.timeline.deepCatch then
			local incoming = self.cameraFrame
			local incomingEye = anchor + limitMagnitude(incoming.Position - anchor, settings.BaseDistance)
			view.from = self:_wallSafeStruggleFrame(CFrame.new(incomingEye) * incoming.Rotation, anchor, clearance)
			view.fromFov = self.cameraFov
			view.fromFocus = self.cameraFocus or self.biteFocus or anchor
		end
		self.struggleView = view
	end
	local shot, focus = view.frame, view.anchor
	if bite.timeline.phase == "Struggling" and not bite.timeline.tutorial and bite.lastMouthPosition then
		local look = shot.LookVector
		local toward = bite.lastMouthPosition - shot.Position
		local axis = look:Cross(toward)
		local rotation = CFrame.identity
		if axis.Magnitude > 1e-6 then
			local angle = math.atan2(axis.Magnitude, look:Dot(toward))
			rotation = CFrame.fromAxisAngle(axis.Unit, math.min(angle, math.rad(settings.FollowDegrees)))
		end
		view.follow = (view.follow or CFrame.identity):Lerp(rotation, 1 - 0.5 ^ (dt / settings.FollowHalfLife))
		shot = CFrame.new(shot.Position) * view.follow * shot.Rotation
		focus = shot.Position + shot.LookVector * (view.anchor - shot.Position).Magnitude
	end
	if bite.timeline.deepCatch then
		return shot, view.fov, focus, view.anchor
	end
	local blend = smoothstep((now - startedAt) / settings.EntryBlendTime)
	if blend >= 1 then
		return shot, view.fov, focus, view.anchor
	end
	return view.from:Lerp(shot, blend), view.fromFov + (view.fov - view.fromFov) * blend,
		view.fromFocus:Lerp(focus, blend), view.anchor
end

function FishingCastSequence:_updateCamera(now, dt, camera)
	camera = camera or assert(Workspace.CurrentCamera, "CurrentCamera disappeared")
	local viewport = camera.ViewportSize
	local frame = self.root.CFrame
	local elapsed = now - self.shotStarted
	local shot, fov
	local focus = self.bait.Position
	local waterView, fixedWaterView = false, false
	local struggleAnchor
	local showcasing = self.bite and (self.bite.timeline.phase == "Lifting" or self.bite.timeline.phase == "Caught")
	local showcasePullback = 1
	local fishSettle
	local reeling = self.bite and (self.bite.timeline.phase == "Reeling" or self.bite.timeline.phase == "Reeled")
	local timeline = self.bite and self.bite.timeline
	local struggling = timeline and timeline.phase == "Struggling"
	local holdingCatch = timeline and timeline.deepCatch and timeline.phase == "Bite"
	local keepEscapeView = timeline and timeline.deepCatch and timeline.phase == "Escaped" and self.renderedStruggleFrame
	local struggle = Config.Camera.Struggle
	local entranceTime = if timeline and timeline.entrance then timeline:GetDeepCatchEntranceTime(now) else nil
	if self.shotMode == "Special" then
		shot, fov, focus = CastPresentation.Camera(self, now - self.actionStarted, viewport)
	elseif self.shotMode == "Behind" then
		shot = CFrame.lookAt(
			frame:PointToWorldSpace(Vector3.new(3.2, 2.4, 7.5)),
			frame.Position + frame.LookVector * 14 + Vector3.new(0, 0.5, 0)
		)
		fov = 62
	elseif self.shotMode == "Front" then
		shot = CFrame.lookAt(
			frame:PointToWorldSpace(Vector3.new(-2.2 + elapsed * 0.4, 0.9 + elapsed * 0.2, -7.5)),
			frame.Position + Vector3.new(0, 0.6, 0)
		)
		fov = 60
	elseif self.shotMode == "Orbit" then
		local settings = Config.Camera.CastOrbit
		local progress = math.clamp(elapsed / settings.Duration, 0, 1)
		progress = progress * progress * (3 - 2 * progress)
		local angle = math.rad(-150) * (1 - progress)
		local radius = 7.5 + (settings.Distance - 7.5) * progress
		local height = 2.6 + (settings.Height - 2.6) * progress
		focus = frame.Position + Vector3.yAxis * (1.2 + (settings.FocusHeight - 1.2) * progress)
		shot = CFrame.lookAt(
			frame:PointToWorldSpace(Vector3.new(math.sin(angle) * radius, height, math.cos(angle) * radius)),
			focus
		)
		fov = 66
	elseif self.shotMode == "Chase" then
		shot, fov, focus = self:_chaseCamera(dt)
	elseif reeling then
		shot, focus = self:_reelCamera(self:_waterTarget(), viewport)
		fov = Config.Bite.ShowcaseFov
	elseif showcasing and not self.bite.isEgg then
		shot, focus, fishSettle = self:_fishLiftCamera(now, self:_waterTarget())
		fov = Config.Bite.ShowcaseFov
	elseif showcasing then
		local target = self:_waterTarget()
		local goal, goalFocus = self:_showcaseCamera(target, viewport)
		if not self.showcaseFrom then
			self.showcaseFrom = self.cameraFrame - target
			self.showcaseFocus = (self.biteFocus or target) - target
		end
		local entry, pullback = self:_showcaseProgress(now)
		showcasePullback = pullback
		local fishFocus = self.bite.showcasePosition or self.bite.lastPosition or goalFocus
		local closeup = fishFocus - self.forward * Config.Bite.ShowcaseCloseupDistance
		local depth = self.fishingDepth or 0
		local rise = Vector3.yAxis * math.clamp(fishFocus.Y - target.Y + depth + self.bite.depth, 0, depth)
		local position = (self.showcaseFrom + target + rise).Position:Lerp(closeup:Lerp(goal.Position, pullback), entry)
		focus = (target + self.showcaseFocus + rise):Lerp(fishFocus, entry)
		shot = CFrame.lookAt(position, focus)
		fov = Config.Bite.ShowcaseFov
	elseif entranceTime ~= nil then
		waterView = true
		shot, fov, focus = self:_deepCatchCamera(self.bite.lastBaitPosition, entranceTime, viewport)
	elseif (holdingCatch or struggling) and not self.bite.isEgg then
		waterView = true
		shot, fov, focus, struggleAnchor = self:_struggleCamera(now, dt, viewport)
	elseif keepEscapeView then
		shot, fov, focus = self.renderedStruggleFrame, self.renderedStruggleFov, self.renderedStruggleFocus
	elseif Config.Camera.FollowFishEnabled
		and (not self.bite or not self.bite.isEgg)
	then
		waterView, fixedWaterView = true, true
		shot, fov, focus = self:_baitViewCamera(now, dt, viewport)
	elseif
		Config.Camera.FollowFishEnabled
		and self.bite
		and self.bite.lastPosition
		and self.bite.timeline.phase ~= "Settling"
	then
		waterView = true
		local bite = self.bite
		local target = self:_baitTarget(now, self:_waterTarget())
		local phase = bite.timeline.phase
		local waiting = phase == "Escaped" or phase == "Waiting"
		focus = if waiting then target else target:Lerp(bite.lastPosition, 0.5)
		local aspect = math.max(viewport.X, 1) / math.max(viewport.Y, 1)
		local halfAngle = math.atan(math.tan(math.rad(30)) * math.min(aspect, 1))
		local fishRadius = math.max(bite.halfLength, bite.presentationRadius) * bite.scale
		local radius = fishRadius + 2 + (if waiting then 0 else (bite.lastPosition - target).Magnitude * 0.5)
		local distance = math.max(16, radius / math.sin(halfAngle))
		local offset = -self.forward * distance * 0.8 + Vector3.yAxis * distance * 0.65
		local eye = focus + limitMagnitude(offset, Config.Camera.FollowFishMaxDistance)
		shot = CFrame.lookAt(eye, focus)
		fov = 60
	else
		waterView = true
		local settings = Config.Camera.BaitView
		-- 固定看向鱼饵的等候位置。
		focus = self:_baitTarget(now, self:_waterTarget())
		shot = CFrame.lookAt(focus - self.forward * settings.Distance + Vector3.yAxis * settings.Height, focus)
		fov = settings.Fov
	end
	local alpha = if self.shotDuration <= 0 then 1 else math.clamp(elapsed / self.shotDuration, 0, 1)
	alpha = TweenService:GetValue(alpha, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local authoredShot = entranceTime ~= nil or struggleAnchor ~= nil or keepEscapeView
	local diving = not authoredShot and waterView and self.shotMode == "Landing" and self.diveCameraOffset ~= nil
		and elapsed <= Config.Landing.DiveTime
	if authoredShot then
		self.landingCameraTransition = false
	elseif diving then
		shot, focus = self:_diveCamera(now, elapsed, alpha, shot, focus)
		self.landingCameraTransition = false
		fixedWaterView = true
	elseif waterView then
		if self.landingCameraTransition then
			focus = (self.shotFocusFrom or focus):Lerp(focus, alpha)
			if alpha >= 1 then
				self.landingCameraTransition = false
			end
		elseif not fixedWaterView then
			local amount = 1 - math.exp(-Config.Camera.WaterViewSmoothSpeed * dt)
			shot = self.cameraFrame:Lerp(shot, amount)
			focus = (self.cameraFocus or self.biteFocus or self:_waterTarget()):Lerp(focus, amount)
		end
	end
	if not diving and not authoredShot then
		shot = self.shotFrom:Lerp(shot, alpha)
	end
	if not authoredShot then
		fov = self.fovFrom + (fov - self.fovFrom) * alpha
	end
	if reeling and alpha < 1 and self.shotFocusFrom then
		focus = self.shotFocusFrom:Lerp(focus, alpha)
	end
	if waterView then
		self.biteFocus = focus
	end
	self.cameraFrame, self.cameraFov, self.cameraFocus = shot, fov, focus
	local x, y, rx, ry, rz, fovOffset = self:_sampleImpulses(now)
	if struggling then
		local t = now * struggle.Frequency
		x += math.noise(t, 13) * struggle.Shake * 0.5
		y += math.noise(t, 17) * struggle.Shake * 0.5
		rx += math.noise(t, 23) * struggle.Shake * 0.025
		rz += math.noise(t, 29) * struggle.Shake * 0.025
	end
	local time = now * 0.35
	local noise = CFrame.new(math.noise(time + 30) * 0.075, math.noise(time + 40) * 0.06, 0)
		* CFrame.Angles(math.noise(time) * 0.01, math.noise(time + 10) * 0.0125, math.noise(time + 20) * 0.004)
	if reeling then
		local amount = math.clamp(elapsed / Config.Reel.SwayFadeTime, 0, 1)
		amount = amount * amount * (3 - 2 * amount)
		noise = noise:Lerp(CFrame.identity, 1 - Config.Reel.SwayScale * amount)
	elseif showcasing and self.bite.isEgg then
		local amount = if self.bite.timeline.phase == "Caught"
			then math.clamp((now - self.bite.timeline.startedAt) / Config.Camera.ShowcaseSwayFade, 0, 1)
			else 0
		amount = amount * amount * (3 - 2 * amount)
		noise = noise:Lerp(CFrame.identity, 1 - amount)
	end
	local shake = CFrame.new(x, y, 0) * CFrame.Angles(rx, ry, rz)
	local motion = noise * shake
	if struggleAnchor then
		local axis, angle = motion:ToAxisAngle()
		local maxAngle = math.rad(struggle.MaxShakeDegrees)
		local rotation = if angle > maxAngle then CFrame.fromAxisAngle(axis, maxAngle) else motion.Rotation
		motion = CFrame.new(limitMagnitude(motion.Position, struggle.MaxShakeOffset)) * rotation
		fovOffset = 0
	elseif fishSettle then
		motion = motion:Lerp(CFrame.identity, fishSettle)
		fovOffset *= 1 - fishSettle
	end
	local presentation = shot * motion
	local renderedFov = fov + fovOffset
	if entranceTime ~= nil or keepEscapeView then
		-- 上游有独立摆动，逃脱时保持最后一帧机位接入空收。
		presentation, renderedFov = shot, fov
	elseif fixedWaterView then
		-- 落水运镜结束时一起收掉冲击和摇摆，锁定提竿前的机位。
		presentation = shot * motion:Lerp(CFrame.identity, alpha)
		renderedFov = fov + fovOffset * (1 - alpha)
	end
	if showcasing and self.bite.isEgg and self.bite.presentationRadius then
		local center = self.bite.showcasePosition or self.bite.lastPosition
		local radius = if self.bite.timeline.phase == "Caught"
			then self.bite:GetShowcaseRadius()
			else self.bite.presentationRadius * self.bite.scale
		radius += Config.Bite.ShowcasePadding
		presentation =
			self:_protectShowcase(presentation, center, radius, viewport, renderedFov, showcasePullback)
	end
	if struggleAnchor then
		presentation = self:_wallSafeStruggleFrame(presentation, struggleAnchor, struggle.WallClearance)
		-- 出水和空收从最后实际渲染的光轴接入。
		local distance = math.max(1, (focus - presentation.Position):Dot(presentation.LookVector))
		focus = presentation.Position + presentation.LookVector * distance
	else
		self.struggleView = nil
	end
	if not keepEscapeView then
		self.renderedStruggleFrame = if struggleAnchor then presentation else nil
		self.renderedStruggleFov = if struggleAnchor then renderedFov else nil
		self.renderedStruggleFocus = if struggleAnchor then focus else nil
	end
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame, camera.FieldOfView = presentation, renderedFov
	camera.Focus = CFrame.new(focus)
	self:_updateDeepCatchSpeedLines(if entranceTime ~= nil then presentation else nil)
end

function FishingCastSequence:_updatePresentation(now, dt)
	local meter, settings = self.meter, Config.Meter
	if self.fixedCast and self.phase == "Preparing" then
		if self.castPromptText and meter.prompt.Visible then
			meter.prompt.Text = if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
				then "PRESS A TO CAST!"
				else self.castPromptText
		end
		if self.lockedMeterProgress == nil then
			local startsAt = self.options and self.options.meterStartsAt
			if startsAt then
				self.meterProgress = Config.GetCastMeterProgress(Workspace:GetServerTimeNow() - startsAt)
			else
				local speed = settings.BaseSpeed * (1 + (settings.TopSpeedFactor - 1) * self.meterProgress)
				self.meterProgress += self.meterDirection * speed * dt
				if self.meterProgress >= 1 then
					self.meterProgress, self.meterDirection = 1, -1
				elseif self.meterProgress <= 0 then
					self.meterProgress, self.meterDirection = 0, 1
				end
			end
		else
			self.meterProgress = self.lockedMeterProgress
		end
		meter.marker.Position = UDim2.fromScale(0.5, 1 - self.meterProgress)
		if self.lockedMeterProgress == nil then
			local step = math.floor(self.meterProgress * settings.Segments)
			if step ~= self.lastMeterStep then
				self.lastMeterStep = step
				self:_sound("MeterTick", 0.25, 0.9 + self.meterProgress * 0.5)
			end
		end
		if self.info then
			self.info:SetCastProgress(self.meterProgress)
			self.info:SetLuck(self.fullLuck * FishingRoll.GetCastLuckMultiplier(self.meterProgress), now, true)
		end
	end
	if self.info then
		local updateBiteGuide = self.options and self.options.updateBiteGuide
		local guideVisible = if updateBiteGuide then updateBiteGuide(self) else nil
		self.info:Update(now, self.bite, guideVisible)
	end
	if self.perfectAt then
		local alpha = math.clamp((now - self.perfectAt) / settings.PerfectFlash, 0, 1)
		self.flash.BackgroundTransparency = 1 - 0.35 * (1 - alpha) ^ 2
	end
	if self.fixedCast then
		if self.castFeedback then
			self.castFeedback.Update(self, now)
		end
		return
	end
	local function ease(t, duration, style, direction)
		return TweenService:GetValue(math.clamp(t / duration, 0, 1), style, direction or Enum.EasingDirection.Out)
	end
	if self.castFeedback then
		self.castFeedback.Update(self, now)
		return
	end
	local entered = ease(now - self.meterStarted, settings.Enter, Enum.EasingStyle.Back)
	self.holderScale.Scale = 0.5 + entered * 0.5
	if self.castClickedAt then
		local elapsed = now - self.castClickedAt
		self.markerScale.Scale = 1 + (settings.MarkerPunch - 1) * (1 - ease(elapsed, 0.4, Enum.EasingStyle.Elastic))
		meter.scale.Scale = 1 + (settings.PromptPunch - 1) * (1 - ease(elapsed, 0.5, Enum.EasingStyle.Elastic))
		local glow
		if elapsed < settings.GlowAttack then
			glow = ease(elapsed, settings.GlowAttack, Enum.EasingStyle.Quad)
		else
			glow = 1 - ease(elapsed - settings.GlowAttack, settings.GlowRecovery, Enum.EasingStyle.Quad)
		end
		meter.glow.Size = self.glowSize:Lerp(UDim2.fromScale(1.6, 4), glow)
		meter.glow.BackgroundTransparency = self.glowTransparency + (0.3 - self.glowTransparency) * glow
		if elapsed >= settings.Hold then
			local exit = ease(elapsed - settings.Hold, settings.Exit, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			self.holderScale.Scale = 1 - exit * 0.6
			meter.gui.Enabled = elapsed < settings.Hold + settings.Exit
		end
		self.popupScale.Scale = 0.3 + 0.7 * ease(elapsed, 0.3, Enum.EasingStyle.Back)
		self.popup.Position = self.popupOrigin
			- UDim2.fromScale(
				0,
				settings.PopupRise * ease(math.max(0, elapsed - 0.15), settings.PopupDuration, Enum.EasingStyle.Quad)
			)
		local fade = math.clamp((elapsed / settings.PopupDuration - 0.55) / 0.45, 0, 1)
		self.popup.TextTransparency, self.popupStroke.Transparency = fade, fade
		self.popup.Visible = elapsed < settings.PopupDuration
	else
		meter.scale.Scale = 1 + math.sin((now - self.meterStarted) * 6) * 0.05
	end
end

function FishingCastSequence:Update(now: number, dt: number)
	assert(
		self.bait.Parent
			and self.line.Parent
			and self.lineEnd.Parent
			and self.lineEndAttachment.Parent
			and self.lineTop.Parent
			and self.lineTopAttachment.Parent
			and self.tip:IsDescendantOf(self.rig)
			and self.gui.Parent,
		"Fishing sequence resource disappeared"
	)
	self:_updateHookConfirmation(now)
	local before = self.phase
	if
		self.castProfile
		and self.castProfile.Id == "Godlike"
		and self.actionStarted
		and (self.phase == "Casting" or self.phase == "Flying")
	then
		CastPresentation.GroundClearance(self)
	end
	self:_updateBait(now, dt)
	self:_updateWaitingPromptSize()
	if self.catchMeter then
		local visible = canTapCatch(self.bite)
		local progress = self.catchProgress or 0
		if visible and progress < 1 and self.catchProgressAt then
			progress = Config.GetCatchProgress(progress, self.catchProgressAt, Workspace:GetServerTimeNow())
			if progress == 0 and not self.hookPending then
				self.catchLookupNeeded = true
			end
		end
		self.catchMeter:Update(visible == true, progress)
	end
	local exit = self.hookExit
	if exit and (if exit.at then now >= exit.at else self.bite:CanReturn(now)) then
		self.options.onFailure(exit.message)
		return
	end
	self.characterVFX:Update(now)
	if before ~= "Waiting" and self.phase == "Waiting" then
		self.landingPosition = self:_waterTarget()
	end
	self:_updateIdleWaterVFX(now)
	if self.bite then
		self:_updateWaterEffects(now)
	end
	self:RefreshSoundSetting()
	self:_updatePresentation(now, dt)
	self.vignette:Update(now, self.bite)
	local targetBars = if self.phase == "Casting" then 1 else 0
	self.barAmount += (targetBars - self.barAmount) * math.min(dt / 0.15, 1)
	for _, bar in ipairs(self.bars) do
		bar.Size = UDim2.fromScale(1, self.barAmount * 0.11)
	end
	local caughtBodyFrame
	if self.phase == "Caught" and self.options.presentCaught then
		self:_updateDeepCatchSpeedLines(nil)
		caughtBodyFrame = self.options.presentCaught(self.bite, now, Workspace.CurrentCamera)
	else
		self:_updateCamera(now, dt)
	end
	if self.castProfile and self.castProfile.Id == "Godlike" then
		self.characterVFX:UpdateTrails(now, Workspace.CurrentCamera.CFrame, self.bait.Position)
	end
	if self.bite then
		self.bite:Present(Workspace.CurrentCamera.CFrame.Position, caughtBodyFrame)
	end
	if self.catchMeter then
		local timeline = self.bite and self.bite.timeline
		local elapsed = if timeline and timeline.deepCatch and timeline.phase == "Bite" then now - timeline.startedAt else nil
		local approaching = timeline and timeline.deepCatch and timeline.phase == "Approaching"
		self.catchMeter:ShowBitePrompt(elapsed, Workspace.CurrentCamera, self.bait,
			self.bite and self.bite.lastMouthPosition, approaching)
	end
	if caughtBodyFrame then
		self.line.Enabled = false
	else
		self:_updateLine()
	end
end

function FishingCastSequence:Destroy(keepFail)
	if self.destroyed then
		return
	end
	self.destroyed = true
	self:_updateDeepCatchSpeedLines(nil)
	if self.castFeedback then
		self.castFeedback.Destroy(self)
	end
	if self.catchMeter then
		self.catchMeter:Destroy()
	end
	if self.bitePrompt then
		self.bitePrompt:Destroy()
		self.bitePrompt, self.bitePromptScale = nil, nil
	end
	if self.characterVFX then
		self.characterVFX:Destroy()
	end
	if self.vignette then
		self.vignette:Destroy()
	end
	if self.info then
		self.info:Destroy()
	end
	UiConfettiUtil.clear(self.gui)
	self.celebratedBite = nil
	if self.fishAudio then
		self.fishAudio:Destroy(keepFail and self.phase == "Reeled")
	end
	for _, original in ipairs(self.originals or {}) do
		if original.instance.Parent then
			pcall(function()
				original.instance[original.property] = original.value
			end)
		end
	end
	if self.waitingPromptBounds then
		self.waitingPromptBounds:Destroy()
	end
	for _, scale in ipairs(self.createdScales or {}) do
		scale:Destroy()
	end
	CastPresentation.Destroy(self)
	if self.bite then
		self.bite:Destroy()
	end
	if self.folder then
		self.folder:Destroy()
	end
	self.idleWaterVFX = nil
	self.waterVFX = {}
	if self.gui and self.gui.Parent then
		self.gui.Enabled = false
	end
end

return FishingCastSequence
