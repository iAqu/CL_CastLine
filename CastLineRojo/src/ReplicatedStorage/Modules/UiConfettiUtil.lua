local RunService = game:GetService("RunService")

local UiConfettiUtil = {}

local CELEBRATION_GRAVITY = Vector2.new(0, 0.28)
local SIDE_CANNONS_GRAVITY = Vector2.new(0, 1.128)
local SIDE_CANNONS_INTERVAL = 0.18
local DEFAULT_ZINDEX = 1000

local CONFETTI_COLORS = {
	Color3.fromRGB(255, 65, 65),
	Color3.fromRGB(255, 225, 55),
	Color3.fromRGB(70, 255, 95),
	Color3.fromRGB(50, 175, 255),
	Color3.fromRGB(195, 90, 255),
	Color3.fromRGB(255, 85, 195),
}

local nextParticleId = 0
local layers = {}

local CELEBRATION_SEQUENCE = {
	{ delay = 0, apply = function(emit)
		emit(16, 0.08, 0.92, 0.12)
	end },
	{ delay = 0.12, apply = function(emit)
		emit(12, 0.18, 0.82, 0.1)
	end },
	{ delay = 0.24, apply = function(emit)
		emit(10, 0.02, 0.28, 0.14)
	end },
	{ delay = 0.38, apply = function(emit)
		emit(10, 0.72, 0.98, 0.14)
	end },
	{ delay = 0.54, apply = function(emit)
		emit(12, 0.12, 0.88, 0.1)
	end },
	{ delay = 0.72, apply = function(emit)
		emit(8, 0.04, 0.34, 0.12)
		emit(8, 0.66, 0.96, 0.12)
	end },
	{ delay = 0.92, apply = function(emit)
		emit(10, 0.2, 0.8, 0.08)
	end },
	{ delay = 1.18, apply = function(emit)
		emit(6, 0.1, 0.3, 0.1)
		emit(6, 0.7, 0.9, 0.1)
	end },
	{ delay = 1.46, apply = function(emit)
		emit(8, 0.24, 0.76, 0.06)
	end },
}

local SIDE_CANNONS_SEQUENCE = {
	{ delay = 0, apply = function(emitSide)
		emitSide(14, -0.04, 0.03, 0.84, 0.96, 0.33, 0.51, -1.59, -1.23)
		emitSide(14, 0.97, 1.04, 0.84, 0.96, -0.51, -0.33, -1.59, -1.23)
	end },
	{ delay = 0.08, apply = function(emitSide)
		emitSide(12, -0.04, 0.04, 0.82, 0.96, 0.3, 0.48, -1.5, -1.17)
		emitSide(12, 0.96, 1.04, 0.82, 0.96, -0.48, -0.3, -1.5, -1.17)
	end },
	{ delay = 0.16, apply = function(emitSide)
		emitSide(12, -0.03, 0.05, 0.8, 0.95, 0.27, 0.45, -1.44, -1.11)
		emitSide(12, 0.95, 1.03, 0.8, 0.95, -0.45, -0.27, -1.44, -1.11)
	end },
	{ delay = 0.24, apply = function(emitSide)
		emitSide(10, -0.02, 0.05, 0.78, 0.94, 0.24, 0.42, -1.35, -1.05)
		emitSide(10, 0.95, 1.02, 0.78, 0.94, -0.42, -0.24, -1.35, -1.05)
	end },
	{ delay = 0.34, apply = function(emitSide)
		emitSide(10, -0.01, 0.05, 0.78, 0.92, 0.21, 0.36, -1.23, -0.96)
		emitSide(10, 0.95, 1.01, 0.78, 0.92, -0.36, -0.21, -1.23, -0.96)
	end },
	{ delay = 0.46, apply = function(emitSide)
		emitSide(8, 0, 0.05, 0.76, 0.9, 0.18, 0.3, -1.11, -0.84)
		emitSide(8, 0.95, 1, 0.76, 0.9, -0.3, -0.18, -1.11, -0.84)
	end },
}

local function createConfettiPiece(minX, maxX, minY, maxY, minVelocity, maxVelocity)
	nextParticleId = nextParticleId + 1
	return {
		id = nextParticleId,
		age = 0,
		lifetime = 3.1 + math.random() * 1.5,
		position = Vector2.new(minX + math.random() * (maxX - minX), minY + math.random() * (maxY - minY)),
		velocity = Vector2.new(
			minVelocity.X + math.random() * (maxVelocity.X - minVelocity.X),
			minVelocity.Y + math.random() * (maxVelocity.Y - minVelocity.Y)
		),
		rotation = math.random() * 360,
		rotSpeed = -240 + math.random() * 480,
		size = Vector2.new(14 + math.random() * 18, 9 + math.random() * 14),
		color = CONFETTI_COLORS[math.random(1, #CONFETTI_COLORS)],
		swayPhase = math.random() * math.pi * 2,
		swaySpeed = 3 + math.random() * 2.5,
		swayAmplitude = 0.025 + math.random() * 0.035,
	}
end

local function getOrCreateLayer(parentGui)
	local existingLayer = layers[parentGui]
	if existingLayer and existingLayer.container.Parent then
		return existingLayer
	end

	local container = parentGui:FindFirstChild("ConfettiLayer")
	if not container then
		container = Instance.new("Frame")
		container.Name = "ConfettiLayer"
		container.Size = UDim2.fromScale(1, 1)
		container.BackgroundTransparency = 1
		container.ClipsDescendants = true
		container.BorderSizePixel = 0
		container.ZIndex = DEFAULT_ZINDEX
		container.Parent = parentGui
	end

	local layer = {
		container = container,
		activeParticles = existingLayer and existingLayer.activeParticles or {},
		frameById = existingLayer and existingLayer.frameById or {},
		framePool = existingLayer and existingLayer.framePool or {},
		sequenceToken = existingLayer and existingLayer.sequenceToken or 0,
		heartbeatConn = existingLayer and existingLayer.heartbeatConn or nil,
		gravity = CELEBRATION_GRAVITY,
		zIndex = DEFAULT_ZINDEX,
	}
	layers[parentGui] = layer
	return layer
end

local function acquireFrame(layer)
	local frame = table.remove(layer.framePool)
	if not frame then
		frame = Instance.new("Frame")
		frame.Name = "ConfettiPiece"
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 0

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 2)
		corner.Parent = frame

		frame.ZIndex = layer.zIndex
		frame.Parent = layer.container
	end

	frame.Visible = true
	return frame
end

local function releaseFrame(layer, particleId)
	local frame = layer.frameById[particleId]
	if not frame then
		return
	end

	layer.frameById[particleId] = nil
	frame.Visible = false
	table.insert(layer.framePool, frame)
end

local function syncParticleFrame(layer, particle)
	local frame = layer.frameById[particle.id]
	if not frame then
		frame = acquireFrame(layer)
		layer.frameById[particle.id] = frame
	end

	local progress = math.clamp(particle.age / particle.lifetime, 0, 1)
	local transparency = 0
	if progress >= 0.8 then
		transparency = (progress - 0.8) / 0.2
	end

	frame.Position = UDim2.fromScale(particle.position.X, particle.position.Y)
	frame.Size = UDim2.fromOffset(particle.size.X, particle.size.Y)
	frame.Rotation = particle.rotation
	frame.BackgroundColor3 = particle.color
	frame.BackgroundTransparency = transparency
end

local function emitConfetti(layer, count, minX, maxX, fallSpeed)
	for _ = 1, count do
		table.insert(
			layer.activeParticles,
			createConfettiPiece(
				minX,
				maxX,
				-0.2,
				-0.12,
				Vector2.new(-0.06, fallSpeed + 0.08),
				Vector2.new(0.06, fallSpeed + 0.2)
			)
		)
	end
end

local function emitSideConfetti(layer, count, minX, maxX, minY, maxY, minVelX, maxVelX, minVelY, maxVelY)
	if count <= 0 then
		return
	end

	for _ = 1, count do
		table.insert(
			layer.activeParticles,
			createConfettiPiece(minX, maxX, minY, maxY, Vector2.new(minVelX, minVelY), Vector2.new(maxVelX, maxVelY))
		)
	end
end

local function emitSideCannonsStream(layer)
	emitSideConfetti(layer, 4, 0, 0.05, 0.76, 0.9, 0.18, 0.3, -1.11, -0.84)
	emitSideConfetti(layer, 4, 0.95, 1, 0.76, 0.9, -0.3, -0.18, -1.11, -0.84)
end

local function ensureHeartbeat(layer)
	if layer.heartbeatConn then
		return
	end

	layer.heartbeatConn = RunService.Heartbeat:Connect(function(dt)
		if layer.sideCannonsElapsed then
			local elapsed = layer.sideCannonsElapsed + dt
			layer.sideCannonsElapsed = elapsed % SIDE_CANNONS_INTERVAL
			if elapsed >= SIDE_CANNONS_INTERVAL then
				emitSideCannonsStream(layer)
			end
		end

		local activeParticles = layer.activeParticles
		if #activeParticles == 0 then
			if layer.heartbeatConn then
				layer.heartbeatConn:Disconnect()
				layer.heartbeatConn = nil
			end
			return
		end

		local nextParticles = table.create(#activeParticles)
		local expiredIds = {}

		for _, particle in activeParticles do
			local age = particle.age + dt
			if age < particle.lifetime then
				local sway = math.sin(age * particle.swaySpeed + particle.swayPhase) * particle.swayAmplitude
				local velocity = particle.velocity + layer.gravity * dt
				local position = particle.position + Vector2.new(velocity.X + sway, velocity.Y) * dt

				table.insert(nextParticles, {
					id = particle.id,
					age = age,
					lifetime = particle.lifetime,
					position = position,
					velocity = velocity,
					rotation = particle.rotation + particle.rotSpeed * dt,
					rotSpeed = particle.rotSpeed,
					size = particle.size,
					color = particle.color,
					swayPhase = particle.swayPhase,
					swaySpeed = particle.swaySpeed,
					swayAmplitude = particle.swayAmplitude,
				})
			else
				table.insert(expiredIds, particle.id)
			end
		end

		layer.activeParticles = nextParticles

		for _, particleId in expiredIds do
			releaseFrame(layer, particleId)
		end

		for _, particle in nextParticles do
			syncParticleFrame(layer, particle)
		end
	end)
end

local function makeEmitConfetti(layer)
	return function(count, minX, maxX, fallSpeed)
		emitConfetti(layer, count, minX, maxX, fallSpeed)
		ensureHeartbeat(layer)
	end
end

local function makeEmitSideConfetti(layer)
	return function(count, minX, maxX, minY, maxY, minVelX, maxVelX, minVelY, maxVelY)
		emitSideConfetti(layer, count, minX, maxX, minY, maxY, minVelX, maxVelX, minVelY, maxVelY)
		ensureHeartbeat(layer)
	end
end

local function playCelebrationSequence(layer, sequenceToken)
	task.spawn(function()
		local elapsed = 0
		local emit = makeEmitConfetti(layer)
		for _, step in CELEBRATION_SEQUENCE do
			task.wait(step.delay - elapsed)
			elapsed = step.delay
			if layer.sequenceToken ~= sequenceToken then
				break
			end
			step.apply(emit)
		end
	end)
end

local function playSideCannonsSequence(layer, sequenceToken)
	task.spawn(function()
		local elapsed = 0
		local emitSide = makeEmitSideConfetti(layer)
		for _, step in SIDE_CANNONS_SEQUENCE do
			task.wait(step.delay - elapsed)
			elapsed = step.delay
			if layer.sequenceToken ~= sequenceToken then
				break
			end
			step.apply(emitSide)
		end
	end)
end

function UiConfettiUtil.startSideCannons(parentGui)
	local layer = getOrCreateLayer(parentGui)
	if layer.sideCannonsElapsed then
		return
	end
	layer.sideCannonsElapsed = 0
	layer.gravity = SIDE_CANNONS_GRAVITY
	emitSideCannonsStream(layer)
	ensureHeartbeat(layer)
end

function UiConfettiUtil.clear(parentGui)
	local layer = layers[parentGui]
	if not layer then
		return
	end
	layers[parentGui] = nil
	layer.sequenceToken = layer.sequenceToken + 1
	if layer.heartbeatConn then
		layer.heartbeatConn:Disconnect()
		layer.heartbeatConn = nil
	end
	layer.container:Destroy()
	table.clear(layer.activeParticles)
	table.clear(layer.frameById)
	table.clear(layer.framePool)
end

function UiConfettiUtil.play(parentGui, preset)
	if not parentGui then
		return
	end

	preset = preset or "celebration"

	local layer = getOrCreateLayer(parentGui)
	if preset == "sideCannons" then
		layer.gravity = SIDE_CANNONS_GRAVITY
	else
		layer.gravity = CELEBRATION_GRAVITY
	end
	layer.sequenceToken = layer.sequenceToken + 1
	local sequenceToken = layer.sequenceToken

	task.defer(function()
		if preset == "sideCannons" then
			playSideCannonsSequence(layer, sequenceToken)
		else
			playCelebrationSequence(layer, sequenceToken)
		end
	end)
end

return UiConfettiUtil
