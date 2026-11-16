local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent.FishingConfig)
local Settings = Config.Bite.Drip

local FishDripEffect = {}
FishDripEffect.__index = FishDripEffect

local function shuffledIndices(count, random)
	local bag = {}
	for index = 1, count do
		bag[index] = index
	end
	for index = count, 2, -1 do
		local other = random:NextInteger(1, index)
		bag[index], bag[other] = bag[other], bag[index]
	end
	return bag
end

-- 平滑速率的解析积分；重复 Present、不同帧率均得到同一个累计发射量。
local function emissionCount(elapsed)
	local duration = Settings.DecayTime
	local time = math.clamp(elapsed, 0, duration)
	local easedIntegral = time ^ 3 / duration ^ 2 - time ^ 4 / (2 * duration ^ 3)
	local count = Settings.StartRate * time + (Settings.IdleRate - Settings.StartRate) * easedIntegral
	count += Settings.IdleRate * math.max(0, elapsed - duration)
	return math.floor(count + 0.000001)
end

local function surfaceBinding(body, point, scale)
	local rest = point:GetAttribute("RigV2SurfaceBind")
	local encoded = point:GetAttribute("RigV2SurfaceWeights")
	if typeof(rest) ~= "CFrame" or type(encoded) ~= "string" then
		return nil
	end
	local surface = CFrame.new(rest.Position * scale) * rest.Rotation
	local influences, total = {}, 0
	for name, value in string.gmatch(encoded, "([^:;]+):([^;]+)") do
		local joint, weight = body:FindFirstChild(name, true), tonumber(value)
		if not joint or not joint:IsA("Bone") or not weight or weight <= 0 or weight > 1 then
			return nil
		end
		-- WorldCFrame already includes animated ancestors. Build the bind frame from local offsets.
		local bind, parent = joint.CFrame, joint.Parent
		while parent and parent:IsA("Bone") do
			bind, parent = parent.CFrame * bind, parent.Parent
		end
		if parent ~= body then
			return nil
		end
		table.insert(influences, { joint = joint, weight = weight, offset = bind:ToObjectSpace(surface) })
		total += weight
	end
	if #influences == 0 or #influences > 4 or math.abs(total - 1) > 0.001 then
		return nil
	end
	return { point = point, influences = influences }
end

function FishDripEffect.new(fish, random)
	local self = setmetatable({
		emitters = {},
		burstEmitters = {},
		bag = {},
		bagIndex = 1,
		fish = fish,
		surfaces = {},
		surfaceScale = fish:GetAttribute("RigV2SurfaceScale"),
		random = random or Random.new(),
		lastCount = 0,
	}, FishDripEffect)
	local vfx = ReplicatedStorage:FindFirstChild("VFX")
	local water = vfx and vfx:FindFirstChild("WaterVFX")
	local template = water and water:FindFirstChild(Settings.Template)
	local source = template and template:FindFirstChildOfClass("ParticleEmitter")
	if not source then
		warn("FishDripEffect: VFX.WaterVFX." .. Settings.Template .. " is missing; skipping showcase droplets")
		return self
	end
	local points = {}
	for _, name in ipairs(Settings.Points) do
		local point = fish.PrimaryPart:FindFirstChild("FishDrip_" .. name, true)
		if not point or not point:IsA("Attachment") or not point.Parent:IsA("Bone") then
			warn("FishDripEffect: fish surface attachment " .. name .. " is missing; skipping showcase droplets")
			return self
		end
		table.insert(points, point)
	end
	local hasWeightedSurface = type(self.surfaceScale) == "number" and self.surfaceScale > 0
	if hasWeightedSurface then
		self.bindScale = fish:GetScale()
	end
	for _, point in ipairs(points) do
		if hasWeightedSurface then
			local binding = surfaceBinding(fish.PrimaryPart, point, self.bindScale / self.surfaceScale)
			if binding then
				table.insert(self.surfaces, binding)
			end
		end
		for _, burst in ipairs({ false, true }) do
			local emitter = source:Clone()
			emitter.Name = if burst then "ShowcaseBurst" else "ShowcaseDrip"
			emitter.Enabled, emitter.Rate = false, 0
			emitter.LockedToPart, emitter.VelocityInheritance = false, 0
			emitter.EmissionDirection = Enum.NormalId.Top
			local motion = if burst then Settings.Burst else Settings
			emitter.Speed = NumberRange.new(unpack(motion.Speed))
			emitter.SpreadAngle = Vector2.new(motion.Spread, motion.Spread)
			if burst then
				emitter.Drag = motion.Drag
				emitter.Acceleration = Vector3.new(unpack(motion.Acceleration))
				emitter.Lifetime = NumberRange.new(unpack(motion.Lifetime))
			end
			emitter.Parent = point
			table.insert(if burst then self.burstEmitters else self.emitters, emitter)
		end
	end
	return self
end

function FishDripEffect:_updateSurfaces()
	if #self.surfaces == 0 then
		return
	end
	local scale = self.fish:GetScale() / self.bindScale
	for _, binding in ipairs(self.surfaces) do
		local position, right, up = Vector3.zero, Vector3.zero, Vector3.zero
		for _, influence in ipairs(binding.influences) do
			local joint, weight, offset = influence.joint, influence.weight, influence.offset
			local frame = joint.TransformedWorldCFrame * CFrame.new(offset.Position * scale) * offset.Rotation
			position += frame.Position * weight
			right += frame.RightVector * weight
			up += frame.UpVector * weight
		end
		-- Match the skinned surface instead of following a single joint through a large bend.
		local parent = binding.point.Parent.TransformedWorldCFrame
		local rotation = parent.Rotation * binding.point.CFrame.Rotation
		if up.Magnitude > 0.0001 then
			up = up.Unit
			right -= up * right:Dot(up)
			if right.Magnitude > 0.0001 then
				rotation = CFrame.fromMatrix(Vector3.zero, right.Unit, up)
			end
		end
		binding.point.CFrame = parent:ToObjectSpace(CFrame.new(position) * rotation)
	end
end

function FishDripEffect:_nextPoint()
	if self.bagIndex > #self.bag then
		self.bag = shuffledIndices(#self.emitters, self.random)
		if #self.bag > 1 and self.bag[1] == self.lastPoint then
			self.bag[1], self.bag[2] = self.bag[2], self.bag[1]
		end
		self.bagIndex = 1
	end
	local index = self.bag[self.bagIndex]
	self.bagIndex += 1
	self.lastPoint = index
	return index
end

function FishDripEffect:_clear()
	for _, layer in ipairs({ self.emitters, self.burstEmitters }) do
		for _, emitter in ipairs(layer) do
			emitter.Enabled = false
			emitter:Clear()
		end
	end
	self.active, self.lastElapsed, self.lastBurst = false, nil, nil
	self.lastCount, self.bag, self.bagIndex, self.lastPoint = 0, {}, 1, nil
end

function FishDripEffect:Update(phase, elapsed, request)
	if self.destroyed or #self.emitters == 0 then
		return
	end
	if phase ~= "Caught" then
		if self.active then
			self:_clear()
		end
		return
	end
	if self.lastElapsed and elapsed < self.lastElapsed then
		self:_clear()
	end
	self.active = true
	self:_updateSurfaces()
	local wanted = emissionCount(elapsed)
	local count = math.min(math.max(0, wanted - self.lastCount), Settings.MaxCatchup)
	-- 丢弃长帧中已过期的粒子，不把欠量留到后面的帧。
	self.lastCount, self.lastElapsed = wanted, elapsed
	for _ = 1, count do
		self.emitters[self:_nextPoint()]:Emit(1)
	end
	if request and request.name == "ShowcaseFlop" and request.token ~= nil and request.token ~= self.lastBurst then
		local position = request.position or 0
		if position >= Settings.Burst.Window[1] then
			self.lastBurst = request.token
			if position <= Settings.Burst.Window[2] then
				local indices = shuffledIndices(#self.burstEmitters, self.random)
				for index = 1, math.min(Settings.Burst.Count, #indices) do
					self.burstEmitters[indices[index]]:Emit(1)
				end
			end
		end
	end
end

function FishDripEffect:Destroy()
	if self.destroyed then
		return
	end
	self.destroyed = true
	self:_clear()
	for _, layer in ipairs({ self.emitters, self.burstEmitters }) do
		for _, emitter in ipairs(layer) do
			emitter:Destroy()
		end
	end
	self.emitters, self.burstEmitters, self.surfaces = {}, {}, {}
end

return FishDripEffect
