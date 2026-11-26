local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(script.Parent.FishingConfig)
local Settings = Config.CharacterVFX
local FishingSpotUtil = require(script.Parent.FishingSpotUtil)
local Workspace = game:GetService("Workspace")
local RainbowCastTrail = require(script.Parent.RainbowCastTrail)

local FishingCharacterVFX = {}
FishingCharacterVFX.__index = FishingCharacterVFX
local warned = {}

local function rainbow()
	local keys = {}
	for i, rgb in ipairs(Config.CastRainbow) do
		table.insert(keys, ColorSequenceKeypoint.new((i - 1) / (#Config.CastRainbow - 1), Color3.fromRGB(unpack(rgb))))
	end
	return ColorSequence.new(keys)
end

function FishingCharacterVFX.new(rig: Model, parent: Instance, groundY: number?)
	local self = setmetatable({
		rig = rig,
		root = assert(rig.PrimaryPart, "Fishing rig root is missing"),
		humanoid = assert(rig:FindFirstChildOfClass("Humanoid"), "Fishing rig humanoid is missing"),
		groundY = groundY,
		effects = {},
		attachments = {},
	}, FishingCharacterVFX)
	self.folder = Instance.new("Folder")
	self.folder.Name, self.folder.Parent = "FishingCharacterVFX", parent
	self.connection = rig.Destroying:Connect(function()
		self:Destroy()
	end)
	return self
end

function FishingCharacterVFX:Configure(profile, tip)
	self.profile, self.tip, self.budget = profile, tip, 1
	self.groundY = self.groundY or (self.root.Position.Y - FishingSpotUtil.GetFootHeight(self.root, self.humanoid))
	local lowQuality = false
	pcall(function()
		local quality = UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
		lowQuality = quality > 0 and quality <= 4
	end)
	if lowQuality or game:GetService("UserInputService").TouchEnabled then
		self.budget = profile.VFX.ReducedBudget
	end
end

function FishingCharacterVFX:_groundPosition()
	local left, right = self.rig:FindFirstChild("LeftFoot"), self.rig:FindFirstChild("RightFoot")
	local position = self.root.Position - Vector3.yAxis * FishingSpotUtil.GetFootHeight(self.root, self.humanoid)
	if left and right then
		local foot = if left.Position.Y <= right.Position.Y then left else right
		position = foot.Position - Vector3.yAxis * (foot.Size.Y * 0.5)
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.RespectCanCollide = true
	params.IgnoreWater = true
	local excluded = { self.rig, self.folder }
	local player = game:GetService("Players").LocalPlayer
	if player and player.Character then
		table.insert(excluded, player.Character)
	end
	params.FilterDescendantsInstances = excluded
	local hit = Workspace:Raycast(position + Vector3.yAxis * 4, -Vector3.yAxis * 24, params)
	return if hit then hit.Position + Vector3.yAxis * 0.03 else Vector3.new(position.X, self.groundY, position.Z)
end

function FishingCharacterVFX:_position(effect)
	if effect.fixedFrame then
		effect.model:PivotTo(effect.fixedFrame)
		return
	end
	local root = self.root
	local position = root.Position
	if effect.ground then
		if self.profile then
			position = self:_groundPosition()
		else
			local groundY = self.groundY or (position.Y - FishingSpotUtil.GetFootHeight(root, self.humanoid))
			position = Vector3.new(position.X, groundY, position.Z)
		end
	elseif self.profile then
		local anchor = self.rig:FindFirstChild(effect.anchor or "UpperTorso")
		position = if anchor then anchor.Position else position
	end
	local forward = root.CFrame.LookVector * Vector3.new(1, 0, 1)
	local heading = if forward.Magnitude > 0.00001 then CFrame.lookAt(Vector3.zero, forward.Unit) else CFrame.identity
	local frame = CFrame.new(position) * heading * effect.rotation
	effect.model:PivotTo(frame)
	if self.profile and effect.ground then
		effect.fixedFrame = frame
	end
end

function FishingCharacterVFX:_create(name, now, ground, continuous, options)
	options = options or {}
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local group = vfx and vfx:FindFirstChild(options.group or "Fishing")
	local template = group and group:FindFirstChild(name)
	if not (template and (template:IsA("Model") or template:IsA("BasePart"))) then
		if not warned[name] then
			warned[name] = true
			warn("FishingCharacterVFX: VFX.Fishing." .. name .. " is missing")
		end
		return nil
	end
	local model = template:Clone()
	local scale = options.scale or 1
	if model:IsA("Model") then
		model:ScaleTo(model:GetScale() * scale)
	else
		model.Size *= scale
	end
	local effect = {
		model = model,
		rotation = template:GetPivot().Rotation,
		ground = ground,
		anchor = options.anchor,
		emissions = {},
		continuous = {},
		lifetime = 0,
		expiresAt = if continuous then math.huge else now,
	}
	-- 先登记所有克隆，异常退出时也能由 Destroy 回收。
	table.insert(self.effects, effect)
	local descendants = model:GetDescendants()
	table.insert(descendants, model)
	for _, descendant in ipairs(descendants) do
		if descendant:IsA("BaseScript") then
			descendant:Destroy()
		elseif descendant:IsA("BasePart") then
			descendant.Anchored, descendant.CanCollide = true, false
			descendant.CanTouch, descendant.CanQuery = false, false
		elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
			local enabled = descendant.Enabled
			descendant.Enabled = false
			if options.color then
				descendant.Color = options.color
			end
			if descendant:IsA("ParticleEmitter") then
				descendant.Rate *= (options.rate or 1) * (self.budget or 1)
				if self.profile and name == Settings.Wind then
					local keys = {}
					for _, key in ipairs(descendant.Transparency.Keypoints) do
						table.insert(
							keys,
							NumberSequenceKeypoint.new(
								key.Time,
								key.Value + (1 - key.Value) * 0.45,
								key.Envelope * 0.55
							)
						)
					end
					descendant.Transparency = NumberSequence.new(keys)
				end
				if options.only and not options.only[descendant.Name] then
					descendant.Rate, enabled = 0, false
				end
			end
			if continuous then
				table.insert(effect.continuous, { instance = descendant, enabled = enabled })
			end
			if descendant:IsA("ParticleEmitter") then
				effect.lifetime = math.max(effect.lifetime, descendant.Lifetime.Max)
				if not continuous then
					local at = now + (descendant:GetAttribute("EmitDelay") or 0)
					local endsAt = at + (descendant:GetAttribute("EmitDuration") or 0)
					effect.expiresAt =
						math.max(effect.expiresAt, endsAt + descendant.Lifetime.Max + Settings.CleanupPadding)
					table.insert(effect.emissions, {
						emitter = descendant,
						at = at,
						endsAt = endsAt,
						count = if options.only and not options.only[descendant.Name]
							then 0
							else math.max(
								1,
								math.floor(
									(options.count or 1)
											* (self.budget or 1)
											* (options.absoluteCount or (descendant:GetAttribute("EmitCount") or 1))
										+ 0.5
								)
							),
					})
				end
			end
		end
	end
	self:_position(effect)
	model.Parent = self.folder
	for _, active in ipairs(effect.continuous) do
		active.instance.Enabled = active.enabled
	end
	return effect
end

function FishingCharacterVFX:Start(now: number)
	if self.destroyed or self.started then
		return
	end
	self.started = true
	self.startedAt = now
	local settings = self.profile and self.profile.VFX
	self:_create(Settings.Land, now, true, false, { count = settings and settings.LandCount or 1 })
	self.wind = self:_create(Settings.Wind, now, false, true, {
		scale = settings and settings.WindScale or 1,
		rate = settings and settings.WindRate or 1,
		color = settings and rainbow() or nil,
	})
	self:Update(now)
end

function FishingCharacterVFX:BeginTrail(now)
	if self.destroyed or self.rodTrail then
		return
	end
	self.rodTrail = RainbowCastTrail.new(self.folder, self.profile.Trails.Rod, Config.CastRainbow)
	self.rodTrail:Start(self.tip.WorldPosition, Workspace.CurrentCamera.CFrame, now)
end

function FishingCharacterVFX:UpdateTrails(now, cameraFrame, baitPosition)
	if self.destroyed then
		return
	end
	if self.rodTrail and not self.rodTrail:Update(self.tip.WorldPosition, cameraFrame, now) then
		self.rodTrail = nil
	end
	if self.flightTrail and not self.flightTrail:Update(baitPosition, cameraFrame, now) then
		self.flightTrail = nil
	end
end

function FishingCharacterVFX:AppendTrailBounds(points, now)
	if self.rodTrail then
		self.rodTrail:AppendBounds(points, now)
	end
end

function FishingCharacterVFX:StopFlight(now)
	if self.flightTrail then
		self.flightTrail:Stop(now)
	end
end

function FishingCharacterVFX:_rainbow(now, ground, continuous, color, count, anchor)
	return self:_create("EffectPart_Rainbow", now, ground, continuous, {
		group = "MutationEffect",
		only = { Stars = true, Wind = true },
		color = color,
		absoluteCount = count or 6,
		rate = 0.75,
		anchor = anchor or "RightHand",
	})
end

function FishingCharacterVFX:Land(now)
	if self.destroyed or self.landed then
		return
	end
	self.landed = true
	self:_create(Settings.Land, now, true, false, { count = 0.5, scale = 0.8 })
	self:_rainbow(now, true, false, nil, 3)
	self:_create("BaitAppear", now, true, false, {
		only = { ExpandRing = true },
		color = rainbow(),
		scale = 1.5,
	})
end

function FishingCharacterVFX:Charge(now)
	if self.destroyed or self.charged then
		return
	end
	self.charged = true
	self.aura = self:_rainbow(now, false, true)
	local hand = self.rig:FindFirstChild("RightHand")
	if hand then
		local attachment = Instance.new("Attachment")
		table.insert(self.attachments, attachment)
		attachment.Name, attachment.Parent = "GodlikeChargeLight", hand
		local light = Instance.new("PointLight")
		light.Brightness, light.Range, light.Shadows = 0.7, 7, false
		light.Parent = attachment
		self.light = light
	end
end

function FishingCharacterVFX:_stopContinuous(effect, now)
	if not effect then
		return
	end
	for _, active in ipairs(effect.continuous) do
		active.instance.Enabled = false
	end
	effect.expiresAt = now + effect.lifetime + Settings.CleanupPadding
end

function FishingCharacterVFX:Release(now, position, cameraFrame)
	if self.destroyed or self.released then
		return
	end
	self.released = true
	self.flightTrail = RainbowCastTrail.new(self.folder, self.profile.Trails.Flight, Config.CastRainbow)
	self.flightTrail:Start(position, cameraFrame, now)
	if self.rodTrail then
		self.rodTrail:Stop(now)
	end
	self:_stopContinuous(self.aura, now)
	if self.light then
		self.light.Enabled = false
	end
end

function FishingCharacterVFX:BeginSwing(now: number)
	if self.destroyed or not self.started or self.swung then
		return
	end
	self.swung = true
	if self.wind then
		self:_stopContinuous(self.wind, now)
		self.wind = nil
	end
	local settings = self.profile and self.profile.VFX
	self:_create(Settings.Impact, now, true, false, {
		scale = settings and settings.ImpactScale or 1,
		count = settings and settings.ImpactCount or 1,
	})
	if settings then
		for _, rgb in ipairs(Config.CastRainbow) do
			self:_rainbow(now, false, false, ColorSequence.new(Color3.fromRGB(unpack(rgb))), 3)
		end
	end
	self:Update(now)
end

function FishingCharacterVFX:Update(now: number)
	if self.destroyed then
		return
	end
	if not self.rig.Parent or not self.root:IsDescendantOf(self.rig) or not self.folder.Parent then
		self:Destroy()
		return
	end
	if self.profile then
		local color = Color3.fromHSV((now * 0.7) % 1, 0.8, 1)
		if self.light then
			self.light.Color = color
		end
		if self.wind then
			local strength = 0.65 + 0.35 * math.clamp((now - self.startedAt) / 1.7, 0, 1)
			for _, active in ipairs(self.wind.continuous) do
				if active.instance:IsA("ParticleEmitter") then
					active.baseRate = active.baseRate or active.instance.Rate
					active.instance.Rate = active.baseRate * strength
				end
			end
		end
	end
	for index = #self.effects, 1, -1 do
		local effect = self.effects[index]
		if not effect.model.Parent or now >= effect.expiresAt then
			effect.model:Destroy()
			table.remove(self.effects, index)
		else
			self:_position(effect)
			for burstIndex = #effect.emissions, 1, -1 do
				local burst = effect.emissions[burstIndex]
				if now >= burst.at then
					if not burst.emitted then
						burst.emitted = true
						if now < burst.endsAt + burst.emitter.Lifetime.Max then
							burst.emitter:Emit(burst.count)
						end
					end
					burst.emitter.Enabled = now < burst.endsAt
					if now >= burst.endsAt then
						table.remove(effect.emissions, burstIndex)
					end
				end
			end
		end
	end
end

function FishingCharacterVFX:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	self.connection:Disconnect()
	if self.rodTrail then
		self.rodTrail:Destroy()
	end
	if self.flightTrail then
		self.flightTrail:Destroy()
	end
	self.rodTrail, self.flightTrail = nil, nil
	for _, effect in ipairs(self.effects) do
		effect.model:Destroy()
	end
	self.effects, self.wind = {}, nil
	for _, attachment in ipairs(self.attachments) do
		attachment:Destroy()
	end
	self.attachments = {}
	self.folder:Destroy()
end

return FishingCharacterVFX
