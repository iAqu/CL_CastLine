local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Config = require(script.Parent.FishingConfig)
local ProjectileMath = require(script.Parent.FishingProjectileMath)
local RigUtil = require(script.Parent.FishingRigUtil)
local WaterSurfaceUtil = require(script.Parent.WaterSurfaceUtil)
local FishingBiteSequence = require(script.Parent.FishingBiteSequence)

local FishingCastSequence = {}
FishingCastSequence.__index = FishingCastSequence

local function landingDuration()
	local settings = Config.Landing
	return settings.SinkTime + settings.ReboundTime + settings.SettleTime
end

local function lineAnchor(parent, name)
	local part = Instance.new("Part")
	part.Name, part.Size, part.Transparency = name, Vector3.one * 0.1, 1
	part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
	part.Parent = parent
	local attachment = Instance.new("Attachment")
	attachment.Name, attachment.Parent = "FishingLineAttachment", part
	return part, attachment
end

local function label(parent, name, position, size, text)
	local object = Instance.new("TextLabel")
	object.Name = name
	object.AnchorPoint = Vector2.new(0.5, 0.5)
	object.Position, object.Size = position, size
	object.BackgroundTransparency = 1
	object.AutoLocalize = false
	object.Font = Enum.Font.GothamBold
	object.TextColor3 = Color3.new(1, 1, 1)
	object.TextStrokeTransparency = 0.2
	object.TextScaled = true
	object.Text = text
	object.Parent = parent
	return object
end

function FishingCastSequence:_setPhase(phase)
	if self.phase == phase then
		return
	end
	self.phase = phase
	self.folder:SetAttribute("Phase", phase)
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
	self.shotMode, self.shotStarted, self.shotDuration = mode, now, duration
	if mode == "Chase" then
		self.chaseEye = self.cameraFrame.Position
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

function FishingCastSequence:_init(rig, playerGui, meter, animation, baitTemplate, options)
	self.options, self.sounds = options or {}, {}
	self.originals, self.createdScales = {}, {}
	self.rig, self.root, self.meter = rig, rig.PrimaryPart, meter
	local rod = assert(rig:FindFirstChild("HeldFishingRod"), "HeldFishingRod is missing")
	local tip = rod:FindFirstChild("Top", true)
	assert(tip and tip:IsA("Attachment"), "HeldFishingRod.yugan.Top is missing")
	assert(WaterSurfaceUtil.GetWaterSurfaceY(), "Workspace.Areas.Water.Top is missing")
	self.tip = tip
	self.launch = self.root.Position
	self.forward = Vector3.new(self.root.CFrame.LookVector.X, 0, self.root.CFrame.LookVector.Z).Unit
	self.folder = Instance.new("Folder")
	self.folder.Name = "FishingSequence"
	self.folder.Parent = Workspace
	self:_setPhase("Preparing")

	local bait = baitTemplate:Clone()
	self.bait = bait
	for _, descendant in ipairs(bait:GetDescendants()) do
		if
			descendant:IsA("BaseScript")
			or descendant:IsA("JointInstance")
			or descendant:IsA("Constraint")
			or descendant:IsA("WeldConstraint")
		then
			descendant:Destroy()
		end
	end
	bait.Name = "FishBait"
	bait.Anchored, bait.CanCollide, bait.CanTouch, bait.CanQuery = true, false, false, false
	bait.CFrame = CFrame.new(tip.WorldPosition - Vector3.new(0, 1.5, 0))
	bait.Parent = self.folder
	self.baitHighlight = Instance.new("Highlight")
	self.baitHighlight.Name, self.baitHighlight.Adornee = "BaitOutline", bait
	self.baitHighlight.OutlineColor, self.baitHighlight.OutlineTransparency = Color3.new(1, 1, 1), 0
	self.baitHighlight.FillColor = Color3.fromRGB(unpack(Config.Bite.BaitFillColor))
	self.baitHighlight.FillTransparency = 1
	self.baitHighlight.DepthMode, self.baitHighlight.Parent = Enum.HighlightDepthMode.AlwaysOnTop, self.folder
	self.baitAppearance = { [bait] = bait.Transparency }
	for _, descendant in ipairs(bait:GetDescendants()) do
		if descendant:IsA("BasePart") or descendant:IsA("Decal") or descendant:IsA("Texture") then
			self.baitAppearance[descendant] = descendant.Transparency
		end
	end
	self.lineEnd, self.lineEndAttachment = lineAnchor(self.folder, "FishingLineEnd")
	self.lineTop, self.lineTopAttachment = lineAnchor(self.folder, "FishingLineTop")
	self.lineEnd.Position = bait.CFrame:PointToWorldSpace(Vector3.new(0, bait.Size.Y * 0.35, 0))
	local beam = Instance.new("Beam")
	beam.Name = "FishingLine"
	beam.Attachment0, beam.Attachment1 = tip, self.lineEndAttachment
	beam.Width0, beam.Width1 = 0.035, 0.035
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
	self.trail = trail

	self.gui = Instance.new("ScreenGui")
	-- 进度条为 150；闪屏和黑边在其后，判定文字保持清晰。
	self.gui.Name, self.gui.DisplayOrder = "FishingSequenceGui", 140
	self.gui.IgnoreGuiInset, self.gui.ResetOnSpawn = true, false
	self.gui.Parent = playerGui
	self.flash = Instance.new("Frame")
	self.flash.Name, self.flash.BorderSizePixel = "PerfectFlash", 0
	self.flash.Size, self.flash.BackgroundTransparency = UDim2.fromScale(1, 1), 1
	self.flash.ZIndex, self.flash.Parent = 0, self.gui
	self.bars = {}
	for index = 1, 2 do
		local bar = Instance.new("Frame")
		bar.Name = if index == 1 then "TopBar" else "BottomBar"
		bar.BackgroundColor3, bar.BorderSizePixel = Color3.new(0, 0, 0), 0
		bar.Size = UDim2.fromScale(1, 0)
		bar.AnchorPoint = Vector2.new(0, index - 1)
		bar.Position = UDim2.fromScale(0, index - 1)
		bar.Parent = self.gui
		table.insert(self.bars, bar)
	end
	self.barAmount = 0
	self.distanceLabel = label(self.gui, "Distance", UDim2.fromScale(0.5, 0.12), UDim2.fromScale(0.3, 0.045), "0 STUDS")
	self.returnLabel = label(
		self.gui,
		"ReturnPrompt",
		UDim2.fromScale(0.5, 0.87),
		UDim2.fromScale(0.85, 0.045),
		Config.Bite.Text.Return
	)
	self.statusLabel = label(self.gui, "CatchStatus", UDim2.fromScale(0.5, 0.78), UDim2.fromScale(0.85, 0.055), "")
	self.statusLabel.Visible = false
	self.distanceLabel.Visible, self.returnLabel.Visible = false, false
	self.popup = label(self.gui, "PowerPopup", UDim2.fromScale(0.62, 0.5), UDim2.fromScale(0.2, 0.07), "")
	self.popup.FontFace, self.popup.ZIndex, self.popup.Visible = meter.prompt.FontFace, 10, false
	self.popup.TextStrokeTransparency = 1
	self.popupStroke = Instance.new("UIStroke")
	self.popupStroke.Color, self.popupStroke.Thickness = Color3.new(0, 0, 0), 4
	self.popupStroke.Parent = self.popup
	self.popupScale = Instance.new("UIScale")
	self.popupScale.Parent = self.popup
	self:_save(meter.holder, { "Visible" })
	self:_save(meter.marker, { "Position", "BackgroundColor3" })
	self:_save(meter.label, { "Text" })
	self:_save(meter.prompt, { "Text", "TextColor3" })
	self:_save(meter.scale, { "Scale" })
	self:_save(meter.glow, { "BackgroundColor3", "BackgroundTransparency", "Size" })
	self.holderScale, self.markerScale = self:_scale(meter.holder), self:_scale(meter.marker)
	self.glowSize, self.glowTransparency = meter.glow.Size, meter.glow.BackgroundTransparency
	meter.marker.Position = UDim2.fromScale(0.5, 1)
	meter.label.Text, meter.prompt.Text = "+0", "TAP TO CAST!"
	meter.holder.Visible, meter.gui.Enabled = true, true
	self.holderScale.Scale, self.markerScale.Scale, meter.scale.Scale = 0.5, 1, 1
	self.meterStarted, self.lastMeterStep = os.clock(), 0
	local humanoid = assert(rig:FindFirstChildOfClass("Humanoid"))
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
	self.track = animator:LoadAnimation(animation)
	self.track.Priority, self.track.Looped = Enum.AnimationPriority.Action, false
	self.impulses = {}
	self.cameraFrame, self.cameraFov = Workspace.CurrentCamera.CFrame, Workspace.CurrentCamera.FieldOfView
	self:_shot("Behind", 0, os.clock())
end

function FishingCastSequence.new(
	rig: Model,
	playerGui: PlayerGui,
	meter,
	animation: Animation,
	baitTemplate: BasePart,
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
	for _, rating in ipairs(Config.Meter.Ratings) do
		if value >= rating.Min then
			return rating
		end
	end
	return Config.Meter.Ratings[#Config.Meter.Ratings]
end

function FishingCastSequence:UpdateMeter(value)
	local step = math.floor(value * Config.Meter.Segments)
	if step ~= self.lastMeterStep then
		self.lastMeterStep = step
		self:_sound("MeterTick", nil, 0.9 + value * 0.5)
	end
end

function FishingCastSequence:_castFeedback(value, now)
	local rating = FishingCastSequence.GetRating(value)
	local color = Color3.fromRGB(unpack(rating.Color))
	self.meter.prompt.Text, self.meter.prompt.TextColor3 = rating.Text, color
	self.meter.marker.BackgroundColor3, self.meter.glow.BackgroundColor3 = color, color
	self.popup.Text = string.format("+%d POWER", self.distance - Config.BaseDistance)
	self.popup.TextColor3, self.popup.Visible = color, true
	local viewport = Workspace.CurrentCamera.ViewportSize
	local halfWidth = self.popup.AbsoluteSize.X / 2
	local x = math.clamp(
		self.meter.label.AbsolutePosition.X + self.meter.label.AbsoluteSize.X + halfWidth + 12,
		halfWidth + 8,
		math.max(halfWidth + 8, viewport.X - halfWidth - 8)
	)
	self.popupOrigin =
		UDim2.fromOffset(x, math.clamp(self.meter.marker.AbsolutePosition.Y, viewport.Y * 0.25, viewport.Y * 0.8))
	self:_sound("ButtonClick", nil, 0.9 + value * 0.5)
	self:_impulse(Config.Camera.Tap, now, value)
	if value >= Config.Meter.Ratings[1].Min then
		self.perfectAt = now
		self.flash.BackgroundColor3 = color
		self:_sound("Perfect")
		self:_impulse(Config.Camera.Perfect, now)
	end
end

function FishingCastSequence:Cast(value: number)
	if self.phase ~= "Preparing" then
		return
	end
	self.distance = ProjectileMath.Distance(value)
	self.folder:SetAttribute("Distance", self.distance)
	self.castClickedAt = os.clock()
	self:_setPhase("Casting")
	self:_castFeedback(math.clamp(value, 0, 1), self.castClickedAt)
end

function FishingCastSequence:_waterTarget()
	local waterY = assert(WaterSurfaceUtil.GetWaterSurfaceY(), "Workspace.Areas.Water.Top disappeared")
	local position = self.launch + self.forward * self.distance
	return Vector3.new(position.X, waterY + self.bait.Size.Y * 0.15, position.Z)
end

function FishingCastSequence:_release(now)
	self.releasePosition, self.flightStarted = self.bait.Position, now
	self.flightDuration = ProjectileMath.FlightTime(self.distance)
	self.trail.Enabled = true
	self.trail:Clear()
	self.distanceLabel.Visible = true
	self:_setPhase("Flying")
	self:_shot("Chase", 0.35, now)
	self:_impulse(Config.Camera.Release, now)
	self:_sound("ThrowWhoosh")
	self.wind = self:_sound("WindLoop")
end

function FishingCastSequence:_splash(now, position, strength)
	local effects = ReplicatedStorage:FindFirstChild("Effects")
	local fishing = effects and effects:FindFirstChild("Fishing")
	local template = fishing and fishing:FindFirstChild("Splash")
	if not (template and template:IsA("BasePart")) then
		if not self.warnedSplash then
			self.warnedSplash = true
			warn("FishingCastSequence: Effects.Fishing.Splash is missing; using water ripples only")
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

function FishingCastSequence:_ripple(now, position, strength)
	local part = Instance.new("Part")
	part.Name, part.Anchored, part.Transparency = "WaterRipple", true, 1
	part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
	part.Parent = self.folder
	local gui = Instance.new("SurfaceGui")
	gui.Face, gui.CanvasSize, gui.LightInfluence = Enum.NormalId.Top, Vector2.new(256, 256), 0
	gui.Parent = part
	local ring = Instance.new("Frame")
	ring.Size, ring.Position, ring.BackgroundTransparency = UDim2.fromScale(0.9, 0.9), UDim2.fromScale(0.05, 0.05), 1
	ring.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius, corner.Parent = UDim.new(1, 0), ring
	local stroke = Instance.new("UIStroke")
	stroke.Thickness, stroke.Color, stroke.Parent = 3, Color3.fromRGB(220, 250, 255), ring
	self.ripples = self.ripples or {}
	table.insert(
		self.ripples,
		{ part = part, gui = gui, stroke = stroke, started = now, position = position, strength = strength }
	)
end

function FishingCastSequence:_waterFeedback(now, position, strength, splash)
	local surface = self:_waterTarget()
	position = Vector3.new(position.X, surface.Y - self.bait.Size.Y * 0.15, position.Z)
	self:_ripple(now, position, strength)
	if splash then
		self:_splash(now, position, strength)
	end
	self:_sound("Splash", Config.Sounds.Splash.Volume * strength, 1.1 - strength * 0.2)
end

function FishingCastSequence:_updateWaterEffects(now)
	local surface = self:_waterTarget()
	local waterY = surface.Y - self.bait.Size.Y * 0.15
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
		local alpha = math.clamp((now - ripple.started) / 1.1, 0, 1)
		ripple.gui.Enabled = now >= ripple.started
		local size = (2 + 10 * (1 - (1 - alpha) ^ 2)) * ripple.strength
		ripple.part.Size = Vector3.new(size, 0.02, size)
		ripple.part.CFrame = CFrame.new(ripple.position.X, waterY + 0.04, ripple.position.Z)
		ripple.stroke.Transparency = alpha
		if alpha == 1 then
			ripple.part:Destroy()
			table.remove(self.ripples, index)
		end
	end
end

function FishingCastSequence:TryHook(now)
	if self.bite then
		return self.bite:TryHook(now)
	end
	return false
end

function FishingCastSequence:CanReturn(now)
	return self.bite ~= nil and self.bite:CanReturn(now)
end

function FishingCastSequence:_setBaitVisible(visible)
	if self.baitVisible == visible then
		return
	end
	self.baitVisible = visible
	self.baitHighlight.Enabled = visible
	for instance, transparency in pairs(self.baitAppearance) do
		instance.Transparency = if visible then transparency else 1
	end
end

function FishingCastSequence:_presentBait(phase)
	self:_setBaitVisible(phase ~= "Lifting" and phase ~= "Caught")
	self.baitHighlight.FillTransparency = if phase == "Bite" or phase == "Struggling"
		then Config.Bite.BaitFillTransparency
		else 1
end

function FishingCastSequence:_updateLine()
	local bite = self.bite
	self.lineEnd.Position = (bite and bite.linePosition)
		or self.bait.CFrame:PointToWorldSpace(Vector3.new(0, self.bait.Size.Y * 0.35, 0))
	local vertical = bite and (bite.timeline.phase == "Lifting" or bite.timeline.phase == "Caught")
	if vertical then
		self.lineTop.Position = self.lineEnd.Position + Vector3.yAxis * Config.Bite.ShowcaseLineHeight
		self.line.Attachment0 = self.lineTopAttachment
	else
		self.line.Attachment0 = self.tip
	end
end

function FishingCastSequence:_startBiteRound(now, readyAt)
	if self.bite then
		self.bite:Destroy()
		self.bite = nil
		for _, effect in ipairs(self.splashes or {}) do
			effect.part:Destroy()
		end
		for _, effect in ipairs(self.ripples or {}) do
			effect.part:Destroy()
		end
		self.splashes, self.ripples = {}, {}
	end
	self:_presentBait("Waiting")
	self.bait.CFrame = CFrame.new(self:_waterTarget()) * CFrame.Angles(0, self.spin or 0, 0)
	self.bite = FishingBiteSequence.new(self, now, readyAt)
	self.round = (self.round or 0) + 1
	self.folder:SetAttribute("Round", self.round)
end

function FishingCastSequence:_land(now)
	self.landedAt = now
	self.readyAt = now + math.max(Config.ReturnInputDelay, landingDuration())
	self.trail.Enabled = false
	self:_setPhase("Waiting")
	self:_shot("Landing", 0.4, now)
	self.landingEye = self.cameraFrame.Position
	local strength = math.clamp(self.distance / 400, 0, 1)
	self:_impulse(Config.Camera.Landing, now, strength)
	self:_sound("Splash", Config.Sounds.Splash.Volume + strength * 0.2, 0.95 - strength * 0.25)
	self:_sound("FovImpact")
	local surface = self:_waterTarget() - Vector3.new(0, self.bait.Size.Y * 0.15, 0)
	self:_splash(now, surface, 1)
	self.distanceLabel.Text = string.format("%d STUDS", self.distance)
	self.returnLabel.Visible = false
	for index = 1, 3 do
		self:_ripple(now + (index - 1) * 0.15, surface, 1)
	end
	self:_startBiteRound(now, self.readyAt)
end

function FishingCastSequence:_updateAction(now)
	if not self.actionStarted then
		if self.track.Length <= 0 then
			assert(now - self.castClickedAt < Config.AnimationLoadTimeout, "CastRod failed to load before timeout")
			return
		end
		if now - self.castClickedAt < Config.CastLeadTime then
			return
		end
		self.actionStarted = now
		RigUtil.RestoreReadyPose(self.rig)
		self.track:Play(0.05, 1, 1)
	end
	local elapsed = now - self.actionStarted
	if elapsed >= Config.FrontShotTime and not self.frontShown then
		self.frontShown = true
		self:_shot("Front", 0.28, now)
		self:_impulse(Config.Camera.Front, now)
		self:_sound("CameraWhoosh")
	end
	if elapsed >= Config.OrbitShotTime and not self.orbitShown then
		self.orbitShown = true
		self:_shot("Orbit", 0.3, now)
		self:_impulse(Config.Camera.Orbit, now)
		self:_sound("SpinWhoosh")
	end
	if elapsed >= Config.ReleaseTime then
		self:_release(now)
	end
end

function FishingCastSequence:_landingOffset(elapsed)
	local settings = Config.Landing
	local sink = -self.bait.Size.Y * settings.SinkDepth
	local peak = self.bait.Size.Y * settings.ReboundHeight
	local reboundEnd = settings.SinkTime + settings.ReboundTime
	if elapsed < settings.SinkTime then
		local alpha = math.clamp(elapsed / settings.SinkTime, 0, 1)
		return sink * (1 - (1 - alpha) ^ 2)
	elseif elapsed < reboundEnd then
		local alpha = (elapsed - settings.SinkTime) / settings.ReboundTime
		return sink + (peak - sink) * (1 - (1 - alpha) ^ 2)
	elseif elapsed < landingDuration() then
		local alpha = (elapsed - reboundEnd) / settings.SettleTime
		return peak * (1 + math.cos(alpha * math.pi)) * 0.5
	end
	return math.sin((elapsed - landingDuration()) * 2.5) * 0.1
end

function FishingCastSequence:_updateBait(now, dt)
	if self.phase == "Preparing" or self.phase == "Casting" then
		self.bait.CFrame = CFrame.new(self.tip.WorldPosition - Vector3.new(0, 1.5, 0))
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
		self.spin = spin
		self.bait.CFrame = CFrame.new(position) * CFrame.Angles(spin * 0.7, spin, spin * 0.3)
		self.distanceLabel.Text = string.format(
			"%d STUDS",
			math.floor(math.clamp((position - self.launch):Dot(self.forward), 0, self.distance) + 0.5)
		)
		self.wind.Volume = math.clamp(self.velocity.Magnitude / 90, 0.1, 0.7)
		self.wind.PlaybackSpeed = 0.85 + math.clamp(self.velocity.Magnitude / 120, 0, 0.5)
		if elapsed >= self.flightDuration then
			self.bait.CFrame = CFrame.new(self:_waterTarget()) * CFrame.Angles(0, spin, 0)
			self:_land(now)
		end
	elseif self.bite then
		local elapsed = now - self.landedAt
		local target = self:_waterTarget()
		local offset = self:_landingOffset(elapsed)
		local position = target + Vector3.new(0, offset, 0)
		self.bait.CFrame = CFrame.new(position) * CFrame.Angles(0, self.spin, 0)
		self.wind.Volume *= math.exp(-dt * 12)
		if elapsed > 0.3 then
			self.wind:Stop()
		end
		self.bite:Update(now)
		if self.bite:CanRetry(now) then
			-- 从当前帧补饵重开一轮，不追赶卡顿期间已经错过的多轮等待。
			self:_startBiteRound(now)
			self.bite:Update(now)
		end
	end
end

function FishingCastSequence:_showcaseCamera(target, viewport)
	local settings, bite = Config.Bite, self.bite
	local aspect = viewport.X / math.max(viewport.Y, 1)
	local tangent = math.tan(math.rad(settings.ShowcaseFov * 0.5))
	local distance = math.max(
		settings.ShowcaseMinDistance,
		(bite.halfLength * (bite.scale or 1) + settings.ShowcasePadding) / (tangent * settings.ShowcaseScreenFraction),
		(bite.bodyWidth * (bite.scale or 1) * 0.5 + settings.ShowcasePadding)
			/ (tangent * aspect * settings.ShowcaseScreenFraction)
	)
	local focus = target + Vector3.yAxis * settings.ShowcaseHeight
	return CFrame.lookAt(focus - self.forward * distance, focus), focus
end

function FishingCastSequence:_updateCamera(now, dt)
	local frame = self.root.CFrame
	local elapsed = now - self.shotStarted
	local shot, fov
	local focus = self.bait.Position
	local showcasing = self.bite and (self.bite.timeline.phase == "Lifting" or self.bite.timeline.phase == "Caught")
	if self.shotMode == "Behind" then
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
		local angle = math.rad(-150) + elapsed * 4.2
		local radius = 7.5 - math.min(elapsed, 0.5) * 1.5
		shot = CFrame.lookAt(
			frame:PointToWorldSpace(Vector3.new(math.sin(angle) * radius, 2.6, math.cos(angle) * radius)),
			frame.Position + Vector3.new(0, 1.2, 0)
		)
		fov = 66
	elseif self.shotMode == "Chase" then
		local velocity = self.velocity or self.forward
		local direction = if velocity.Magnitude > 0.01 then velocity.Unit else self.forward
		local progress = self.progress or 0
		local desired = self.bait.Position
			- self.forward * (9 + progress * 6)
			+ Vector3.new(0, 3.5 + progress * 3, 0)
			- direction * 2
		self.chaseEye = self.chaseEye:Lerp(desired, 1 - math.exp(-41.5 * dt))
		shot, fov =
			CFrame.lookAt(self.chaseEye, self.bait.Position + direction * 4),
			66 + math.clamp(velocity.Magnitude * 0.12, 0, 16)
	elseif showcasing then
		local target = self:_waterTarget()
		local goal, goalFocus = self:_showcaseCamera(target, Workspace.CurrentCamera.ViewportSize)
		if not self.showcaseFrom then
			self.showcaseFrom = self.cameraFrame - target
			self.showcaseFocus = (self.biteFocus or target) - target
		end
		local progress = if self.bite.timeline.phase == "Caught"
			then 1
			else math.clamp((now - self.bite.timeline.startedAt) / Config.Bite.LiftTime, 0, 1)
		progress = progress * progress * (3 - 2 * progress)
		local position = (self.showcaseFrom + target).Position:Lerp(goal.Position, progress)
		local track = if self.bite.timeline.phase == "Caught"
			then 1
			else math.clamp((now - self.bite.timeline.startedAt) / 0.25, 0, 1)
		local fishFocus = self.bite.showcasePosition or self.bite.lastPosition or goalFocus
		focus = (target + self.showcaseFocus):Lerp(fishFocus, track)
		shot = CFrame.lookAt(position, focus)
		fov = Config.Bite.ShowcaseFov
	elseif self.bite and self.bite.lastPosition and self.bite.timeline.phase ~= "Settling" then
		local target = self:_waterTarget()
		local fishPosition = self.bite.lastPosition
		local waiting = self.bite.timeline.phase == "Escaped" or self.bite.timeline.phase == "Waiting"
		local desiredFocus = if waiting then target else target:Lerp(fishPosition, 0.5)
		self.biteFocus = (self.biteFocus or target):Lerp(desiredFocus, 1 - math.exp(-6 * dt))
		focus = self.biteFocus
		local viewport = Workspace.CurrentCamera.ViewportSize
		local aspect = viewport.X / math.max(viewport.Y, 1)
		local halfAngle = math.atan(math.tan(math.rad(30)) * math.min(aspect, 1))
		local radius = self.bite.halfLength + 2 + (if waiting then 0 else (fishPosition - target).Magnitude * 0.5)
		local distance = math.max(16, radius / math.sin(halfAngle))
		shot = CFrame.lookAt(focus - self.forward * distance * 0.8 + Vector3.yAxis * distance * 0.65, focus)
		shot = self.cameraFrame:Lerp(shot, 1 - math.exp(-5 * dt))
		fov = 60
	else
		-- 跟随水面升降，不跟随鱼饵的短促回弹，保留回弹在画面中的幅度。
		local target = self:_waterTarget()
		local waterDelta = target - self.landingPosition
		shot = CFrame.lookAt(
			self.landingEye + waterDelta + Vector3.new(0, math.min(elapsed, 1) * 0.4, 0),
			target + Vector3.new(0, 0.5, 0)
		)
		focus = target
		fov = 60
	end
	local alpha = if self.shotDuration <= 0 then 1 else math.clamp(elapsed / self.shotDuration, 0, 1)
	alpha = TweenService:GetValue(alpha, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	shot, fov = self.shotFrom:Lerp(shot, alpha), self.fovFrom + (fov - self.fovFrom) * alpha
	self.cameraFrame, self.cameraFov = shot, fov
	local x, y, rx, ry, rz, fovOffset = self:_sampleImpulses(now)
	if self.bite and self.bite.timeline.phase == "Struggling" then
		local settings = Config.Camera.Struggle
		local t = now * settings.Frequency
		x += math.noise(t, 13) * settings.Shake * 0.5
		y += math.noise(t, 17) * settings.Shake * 0.5
		rx += math.noise(t, 23) * settings.Shake * 0.025
		rz += math.noise(t, 29) * settings.Shake * 0.025
	end
	local time = now * 0.35
	local noise = CFrame.new(math.noise(time + 30) * 0.075, math.noise(time + 40) * 0.06, 0)
		* CFrame.Angles(math.noise(time) * 0.01, math.noise(time + 10) * 0.0125, math.noise(time + 20) * 0.004)
	if showcasing then
		local amount = if self.bite.timeline.phase == "Caught"
			then math.clamp((now - self.bite.timeline.startedAt) / Config.Camera.ShowcaseSwayFade, 0, 1)
			else 0
		amount = amount * amount * (3 - 2 * amount)
		noise = noise:Lerp(CFrame.identity, 1 - amount)
	end
	local shake = CFrame.new(x, y, 0) * CFrame.Angles(rx, ry, rz)
	local camera = assert(Workspace.CurrentCamera, "CurrentCamera disappeared")
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame, camera.FieldOfView = shot * noise * shake, fov + fovOffset
	camera.Focus = CFrame.new(focus)
end

function FishingCastSequence:_updatePresentation(now)
	local meter, settings = self.meter, Config.Meter
	local function ease(t, duration, style, direction)
		return TweenService:GetValue(math.clamp(t / duration, 0, 1), style, direction or Enum.EasingDirection.Out)
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
	if self.perfectAt then
		local alpha = math.clamp((now - self.perfectAt) / settings.PerfectFlash, 0, 1)
		self.flash.BackgroundTransparency = 1 - 0.35 * (1 - alpha) ^ 2
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
	local before = self.phase
	self:_updateBait(now, dt)
	self:_updateLine()
	if before ~= "Waiting" and self.phase == "Waiting" then
		self.landingPosition = self:_waterTarget()
	end
	if self.bite then
		self:_updateWaterEffects(now)
	end
	self:RefreshSoundSetting()
	self:_updatePresentation(now)
	local targetBars = if self.phase == "Casting" then 1 else 0
	self.barAmount += (targetBars - self.barAmount) * math.min(dt / 0.15, 1)
	for _, bar in ipairs(self.bars) do
		bar.Size = UDim2.fromScale(1, self.barAmount * 0.11)
	end
	self:_updateCamera(now, dt)
end

function FishingCastSequence:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	for _, original in ipairs(self.originals or {}) do
		if original.instance.Parent then
			pcall(function()
				original.instance[original.property] = original.value
			end)
		end
	end
	for _, scale in ipairs(self.createdScales or {}) do
		scale:Destroy()
	end
	if self.track then
		-- Animator 被外部销毁时，也必须继续释放 UI、鱼线和声音。
		pcall(function()
			self.track:Stop(0)
			self.track:Destroy()
		end)
	end
	if self.bite then
		self.bite:Destroy()
	end
	if self.folder then
		self.folder:Destroy()
	end
	if self.gui then
		self.gui:Destroy()
	end
end

return FishingCastSequence
