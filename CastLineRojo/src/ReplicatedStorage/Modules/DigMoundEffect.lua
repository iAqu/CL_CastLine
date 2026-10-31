-- Procedurally generated local digging mound visuals.
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local GuiUtil = require(script.Parent.GuiUtil)
local RarityBeamUtil = require(script.Parent.RarityBeamUtil)
local RarityRevealConfig = require(script.Parent.RarityRevealConfig)

local DigMoundEffect = {}

type RockStart = {
	part: BasePart,
	cframe: CFrame,
	size: Vector3,
}

type DebrisBand = {
	sizeMin: number,
	sizeMax: number,
	countMin: number,
	countMax: number,
}

export type MoundSession = {
	folder: Model,
	center: BasePart,
	positionPart: BasePart,
	groundNormal: Vector3,
	groundPosition: Vector3,
	centerStartSize: Vector3,
	centerTargetSize: Vector3,
	rocks: { RockStart },
	rockOutwardDistance: number,
	progressCount: number,
	rarity: string,
	beams: RarityBeamUtil.BeamSession?,
	Destroy: (self: MoundSession) -> (),
	SetBeamVisible: (self: MoundSession, visible: boolean) -> (),
	SetProgress: (self: MoundSession, progress: number) -> (),
	Progress: (self: MoundSession, strength: number) -> (),
	Clear: (self: MoundSession, instant: boolean?) -> (),
}

local FALLBACK_COLOR = Color3.fromRGB(160, 140, 110)
local FALLBACK_MATERIAL = Enum.Material.Sand
local MAX_PROGRESS = 18
local PROGRESS_POWER = 1.25
local CENTER_BASE_DIAMETER = 2.5
local IDLE_PIT_SCALE = 1.2
local CENTER_TARGET_AREA_RATIO = 1.3
local CENTER_TARGET_SCALE = math.sqrt(CENTER_TARGET_AREA_RATIO)
local CENTER_ELLIPSE_JITTER = 0.08
local INITIAL_FOOTPRINT_AREA_RATIO = 0.8
local FOOTPRINT_DIAMETER_SCALE = math.sqrt(4 * INITIAL_FOOTPRINT_AREA_RATIO / math.pi)
local MOUND_CLEAR_DURATION = 0.4
local RANDOM_ROCK_COUNT_MIN = 7
local RANDOM_ROCK_COUNT_MAX = 18
local RANDOM_ROCK_BASE_RADIUS = 0.85
local RANDOM_ROCK_RADIUS_JITTER_MIN = -0.15
local RANDOM_ROCK_RADIUS_JITTER_MAX = 0.25
local RANDOM_ROCK_ANGLE_JITTER = 10
local RANDOM_ROCK_YAW_JITTER = 18
local ROCK_OUTWARD_DISTANCE = 2.2
local ROCK_SINK_DISTANCE = 1
local RANDOM_ROCK_SIZE_SCALE = Vector3.new(1.08, 1.15, 1.08)
local RIM_DARKEN = 1.2
local MAX_DEBRIS = 180
local DEBRIS_VELOCITY_STRENGTH = 1.65
local DEBRIS_IMPULSE_DURATION = 0.07
local DEBRIS_MIN_HORIZONTAL = 12
local DEBRIS_SPAWN_LIFT = 0.15
local SMALL_DEBRIS_COUNT_MIN = 4
local SMALL_DEBRIS_COUNT_MAX = 6
local SMALL_DEBRIS_SIZE_SCALE_MIN = 0.16
local SMALL_DEBRIS_SIZE_SCALE_MAX = 0.24
local SMALL_DEBRIS_MIN_HORIZONTAL = 22
local SMALL_DEBRIS_MAX_HORIZONTAL = 34
local SMALL_DEBRIS_MIN_UPWARD = 12
local SMALL_DEBRIS_MAX_UPWARD = 18
local SMALL_DEBRIS_FADE_MIN = 2
local SMALL_DEBRIS_FADE_MAX = 3
local DEBRIS_GROUP = "DigDebris"
local DEBRIS_IGNORE_GROUP = "DigDebrisIgnore"

local DEFAULT_CENTER_START_DIAMETER = CENTER_BASE_DIAMETER * IDLE_PIT_SCALE

local DEBRIS_BAND_WEAK: DebrisBand = { sizeMin = 3, sizeMax = 10, countMin = 1, countMax = 2 }
local DEBRIS_BAND_NORMAL: DebrisBand = { sizeMin = 8, sizeMax = 10, countMin = 2, countMax = 3 }
local DEBRIS_BAND_STRONG: DebrisBand = { sizeMin = 8, sizeMax = 17, countMin = 3, countMax = 5 }

local collisionGroupsReady = false
local localPlayerIgnoreSaved: { [BasePart]: string } = {}

local vfxFolder = ReplicatedStorage:WaitForChild("VFX")
local diggingParticles = vfxFolder:WaitForChild("Dig")
local soundFolder = ReplicatedStorage:WaitForChild("Sound")
local digSoundFolder = soundFolder:WaitForChild("Dig")
local diggingSounds = digSoundFolder:WaitForChild("Shovel")

local function cantCollide(part: BasePart)
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
end

local function getEffectsFolder(): Folder
	local folder = Workspace:FindFirstChild("DigEffects")
	if folder and folder:IsA("Folder") then
		return folder
	end

	folder = Instance.new("Folder")
	folder.Name = "DigEffects"
	folder.Parent = Workspace
	return folder
end

local function createRaycastParams(extraExclude: { Instance }?): RaycastParams
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true

	local exclude: { Instance } = { getEffectsFolder() }
	local areas = Workspace:FindFirstChild("Areas")
	local water = areas and areas:FindFirstChild("Water")
	if water and water:IsA("Model") then
		table.insert(exclude, water)
	end
	for _, player in Players:GetPlayers() do
		if player.Character then
			table.insert(exclude, player.Character)
		end
	end
	if extraExclude then
		for _, instance in extraExclude do
			table.insert(exclude, instance)
		end
	end
	params.FilterDescendantsInstances = exclude
	return params
end

local function sampleGround(position: Vector3, extraExclude: { Instance }?)
	local result = Workspace:Raycast(
		position + Vector3.new(0, 8, 0),
		Vector3.new(0, -24, 0),
		createRaycastParams(extraExclude)
	)
	if not result then
		return {
			position = position,
			normal = Vector3.yAxis,
			color = FALLBACK_COLOR,
			material = FALLBACK_MATERIAL,
			materialVariant = "",
		}
	end

	return {
		position = result.Position,
		normal = result.Normal,
		color = result.Instance.Color,
		material = result.Instance.Material,
		materialVariant = if result.Instance:IsA("BasePart") then result.Instance.MaterialVariant else "",
	}
end

local function darkenColor(color: Color3, factor: number): Color3
	local hue, saturation, value = color:ToHSV()
	return Color3.fromHSV(hue, saturation, value / factor)
end

local function scaleNumberSequence(sequence: NumberSequence, scale: number): NumberSequence
	local keypoints = table.create(#sequence.Keypoints)
	for index, keypoint in sequence.Keypoints do
		keypoints[index] = NumberSequenceKeypoint.new(
			keypoint.Time,
			keypoint.Value * scale,
			keypoint.Envelope * scale
		)
	end
	return NumberSequence.new(keypoints)
end

local function cloneParticle(name: string, parent: BasePart, color: Color3)
	local template = diggingParticles:FindFirstChild(name)
	if not template or not template:IsA("ParticleEmitter") then
		return
	end
	local particle = template:Clone()
	particle.Enabled = false
	particle.Color = ColorSequence.new(color)
	particle.Parent = parent
end

local function emitParticles(root: Instance, amount: number)
	for _, descendant in root:GetDescendants() do
		if descendant:IsA("ParticleEmitter") then
			descendant:Emit(math.max(1, math.floor(amount)))
		end
	end
end

local function collisionGroupExists(name: string): boolean
	for _, groupInfo in PhysicsService:GetRegisteredCollisionGroups() do
		if groupInfo.name == name then
			return true
		end
	end
	return false
end

local function registerCollisionGroup(name: string)
	if not collisionGroupExists(name) then
		PhysicsService:RegisterCollisionGroup(name)
	end
end

local function ensureCollisionGroups()
	if collisionGroupsReady then
		return
	end
	if RunService:IsClient() then
		collisionGroupsReady = collisionGroupExists(DEBRIS_GROUP) and collisionGroupExists(DEBRIS_IGNORE_GROUP)
		return
	end

	registerCollisionGroup(DEBRIS_GROUP)
	registerCollisionGroup(DEBRIS_IGNORE_GROUP)
	PhysicsService:CollisionGroupSetCollidable(DEBRIS_GROUP, "Default", true)
	PhysicsService:CollisionGroupSetCollidable(DEBRIS_GROUP, DEBRIS_IGNORE_GROUP, false)

	for _, groupInfo in PhysicsService:GetRegisteredCollisionGroups() do
		if groupInfo.name ~= DEBRIS_IGNORE_GROUP then
			local collidable = PhysicsService:CollisionGroupsAreCollidable("Default", groupInfo.name)
			PhysicsService:CollisionGroupSetCollidable(DEBRIS_IGNORE_GROUP, groupInfo.name, collidable)
		end
	end
	PhysicsService:CollisionGroupSetCollidable(DEBRIS_IGNORE_GROUP, DEBRIS_GROUP, false)
	collisionGroupsReady = true
end

local function setLocalPlayerDebrisIgnore(enabled: boolean)
	local localPlayer = Players.LocalPlayer
	if not localPlayer or not localPlayer.Character or not collisionGroupExists(DEBRIS_IGNORE_GROUP) then
		return
	end

	if enabled then
		for _, descendant in localPlayer.Character:GetDescendants() do
			if descendant:IsA("BasePart") then
				localPlayerIgnoreSaved[descendant] = descendant.CollisionGroup
				descendant.CollisionGroup = DEBRIS_IGNORE_GROUP
			end
		end
		return
	end

	for part, previousGroup in localPlayerIgnoreSaved do
		if part.Parent then
			part.CollisionGroup = previousGroup
		end
	end
	table.clear(localPlayerIgnoreSaved)
end

local function countActiveDebris(): number
	local count = 0
	for _, child in getEffectsFolder():GetChildren() do
		if child:IsA("BasePart") and child.Name == "Debris_Rock_Active" then
			count += 1
		end
	end
	return count
end

local function getDebrisBand(strength: number): DebrisBand
	if strength < 0.6 then
		return DEBRIS_BAND_WEAK
	elseif strength < 0.85 then
		return DEBRIS_BAND_NORMAL
	end
	return DEBRIS_BAND_STRONG
end

local function assignDebrisVelocity(part: BasePart, velocityStrength: number)
	local spread = 10 * velocityStrength
	local angle = math.random() * math.pi * 2
	local horizontalSpeed = DEBRIS_MIN_HORIZONTAL + math.random() * (spread - DEBRIS_MIN_HORIZONTAL)
	local velocity = Vector3.new(math.cos(angle) * horizontalSpeed, 6 * velocityStrength, math.sin(angle) * horizontalSpeed)
		* 1.4
	part.AssemblyAngularVelocity = Vector3.new(math.random(-12, 12), math.random(-12, 12), math.random(-12, 12))

	local linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.Name = "DebrisImpulse"
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.VectorVelocity = velocity
	linearVelocity.MaxForce = math.huge
	linearVelocity.Parent = part
	Debris:AddItem(linearVelocity, DEBRIS_IMPULSE_DURATION)
end

local function assignSmallDebrisVelocity(part: BasePart)
	local angle = math.random() * math.pi * 2
	local horizontalSpeed = SMALL_DEBRIS_MIN_HORIZONTAL
		+ math.random() * (SMALL_DEBRIS_MAX_HORIZONTAL - SMALL_DEBRIS_MIN_HORIZONTAL)
	part.AssemblyAngularVelocity = Vector3.new(math.random(-18, 18), math.random(-18, 18), math.random(-18, 18))

	local linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.Name = "SmallDebrisImpulse"
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.VectorVelocity = Vector3.new(
		math.cos(angle) * horizontalSpeed,
		SMALL_DEBRIS_MIN_UPWARD + math.random() * (SMALL_DEBRIS_MAX_UPWARD - SMALL_DEBRIS_MIN_UPWARD),
		math.sin(angle) * horizontalSpeed
	)
	linearVelocity.MaxForce = math.huge
	linearVelocity.Parent = part
	Debris:AddItem(linearVelocity, DEBRIS_IMPULSE_DURATION)
end

local function createFlingParts(
	band: DebrisBand,
	count: number,
	shape: "cube" | "slab",
	position: Vector3,
	material: Enum.Material,
	materialVariant: string,
	color: Color3
)
	if count <= 0 or countActiveDebris() >= MAX_DEBRIS then
		return
	end

	ensureCollisionGroups()
	local effectsFolder = getEffectsFolder()
	for _ = 1, count do
		if countActiveDebris() >= MAX_DEBRIS then
			break
		end
		local sizeScalar = math.random(band.sizeMin, band.sizeMax) / math.random(10, 16)
		local size = if shape == "cube"
			then Vector3.new(sizeScalar, sizeScalar, sizeScalar)
			else Vector3.new(sizeScalar, 0.5, sizeScalar)
		local part = Instance.new("Part")
		part.Name = "Debris_Rock_Active"
		part.Size = size
		part.Material = material
		part.MaterialVariant = materialVariant
		part.Color = color
		part.CFrame = CFrame.new(position + Vector3.new(0, size.Y * 0.5 + DEBRIS_SPAWN_LIFT, 0))
			* CFrame.Angles(math.rad(math.random(1, 180)), math.rad(math.random(1, 180)), math.rad(math.random(1, 180)))
		part.Anchored = false
		part.CanCollide = true
		part.CanQuery = false
		part.CanTouch = false
		if collisionGroupExists(DEBRIS_GROUP) then
			part.CollisionGroup = DEBRIS_GROUP
		end
		CollectionService:AddTag(part, "IgnoreCamera")
		part.Parent = effectsFolder
		assignDebrisVelocity(part, DEBRIS_VELOCITY_STRENGTH)

		local fadeTime = math.random(4, 7)
		TweenService:Create(part, TweenInfo.new(fadeTime, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Transparency = 1,
			Size = size / 10,
		}):Play()
		Debris:AddItem(part, fadeTime)
	end
end

local function spawnDigDebris(
	strength: number,
	position: Vector3,
	material: Enum.Material,
	materialVariant: string,
	color: Color3
)
	local band = getDebrisBand(strength)
	createFlingParts(band, math.random(band.countMin, band.countMax), "cube", position, material, materialVariant, color)
	createFlingParts(band, math.random(band.countMin, band.countMax), "slab", position, material, materialVariant, color)
end

local function spawnSmallDigDebris(
	strength: number,
	position: Vector3,
	material: Enum.Material,
	materialVariant: string,
	color: Color3
)
	if countActiveDebris() >= MAX_DEBRIS then
		return
	end

	ensureCollisionGroups()
	local band = getDebrisBand(strength)
	local effectsFolder = getEffectsFolder()
	for _ = 1, math.random(SMALL_DEBRIS_COUNT_MIN, SMALL_DEBRIS_COUNT_MAX) do
		if countActiveDebris() >= MAX_DEBRIS then
			break
		end
		local baseSizeScalar = math.random(band.sizeMin, band.sizeMax) / math.random(10, 16)
		local baseSize = if math.random() < 0.5
			then Vector3.new(baseSizeScalar, baseSizeScalar, baseSizeScalar)
			else Vector3.new(baseSizeScalar, 0.5, baseSizeScalar)
		local debrisSizeScale = SMALL_DEBRIS_SIZE_SCALE_MIN
			+ math.random() * (SMALL_DEBRIS_SIZE_SCALE_MAX - SMALL_DEBRIS_SIZE_SCALE_MIN)
		local size = baseSize * debrisSizeScale
		local part = Instance.new("Part")
		part.Name = "Debris_Rock_Active"
		part.Size = size
		part.Material = material
		part.MaterialVariant = materialVariant
		part.Color = color
		part.CFrame = CFrame.new(position + Vector3.new(0, size.Y * 0.5 + DEBRIS_SPAWN_LIFT, 0))
			* CFrame.Angles(math.rad(math.random(1, 180)), math.rad(math.random(1, 180)), math.rad(math.random(1, 180)))
		part.Anchored = false
		part.CanCollide = true
		part.CanQuery = false
		part.CanTouch = false
		if collisionGroupExists(DEBRIS_GROUP) then
			part.CollisionGroup = DEBRIS_GROUP
		end
		CollectionService:AddTag(part, "IgnoreCamera")
		part.Parent = effectsFolder
		assignSmallDebrisVelocity(part)

		local fadeTime = math.random(SMALL_DEBRIS_FADE_MIN, SMALL_DEBRIS_FADE_MAX)
		TweenService:Create(part, TweenInfo.new(fadeTime, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Transparency = 1,
			Size = size / 10,
		}):Play()
		Debris:AddItem(part, fadeTime)
	end
end

local function playDigSound(strength: number, parent: BasePart)
	local soundTemplates: { Sound } = {}
	for _, candidate in diggingSounds:GetChildren() do
		if candidate:IsA("Sound") then
			table.insert(soundTemplates, candidate)
		end
	end

	if #soundTemplates == 0 then
		return
	end
	local template = soundTemplates[math.random(1, #soundTemplates)]

	local sound = template:Clone()
	sound.Parent = parent
	sound.PlaybackSpeed = 0.85 + math.clamp(strength, 0.4, 1.4) * 0.25
	sound:Play()
	Debris:AddItem(sound, 2)
end

local function destroyBeamEffects(session: MoundSession, instant: boolean?)
	if not session.beams then
		return
	end
	if instant then
		session.beams:Destroy()
	else
		session.beams:fadeOut()
	end
	session.beams = nil
end

local function createPositionPart(position: Vector3, parent: Instance): BasePart
	local part = Instance.new("Part")
	part.Name = "PositionPart"
	part.Size = Vector3.new(0.1, 0.1, 0.1)
	part.Transparency = 1
	part.CFrame = CFrame.new(position)
	cantCollide(part)
	part.Parent = parent
	return part
end

function DigMoundEffect.EnsureCollisionGroups()
	ensureCollisionGroups()
end

function DigMoundEffect.Init(
	position: Vector3,
	extraExclude: { Instance }?,
	rarity: string?,
	horizontalFootprint: Vector2?,
	itemBounds: Vector3?
): MoundSession?
	local ground = sampleGround(position, extraExclude)
	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local folder = Instance.new("Model")
	folder.Name = "DigMound"
	folder.Parent = getEffectsFolder()

	local positionPart = createPositionPart(ground.position, folder)

	local hasCustomFootprint = horizontalFootprint
		and horizontalFootprint.X > 0
		and horizontalFootprint.Y > 0
	local centerJitterY = if hasCustomFootprint then 0 else (math.random() * 2 - 1) * CENTER_ELLIPSE_JITTER
	local centerJitterZ = if hasCustomFootprint then 0 else (math.random() * 2 - 1) * CENTER_ELLIPSE_JITTER
	local centerDiameterY = if hasCustomFootprint
		then horizontalFootprint.X * FOOTPRINT_DIAMETER_SCALE
		else DEFAULT_CENTER_START_DIAMETER
	local centerDiameterZ = if hasCustomFootprint
		then horizontalFootprint.Y * FOOTPRINT_DIAMETER_SCALE
		else DEFAULT_CENTER_START_DIAMETER
	local centerStartSize = Vector3.new(
		0.2,
		centerDiameterY * (1 + centerJitterY),
		centerDiameterZ * (1 + centerJitterZ)
	)
	local centerTargetSize = centerStartSize * Vector3.new(1, CENTER_TARGET_SCALE, CENTER_TARGET_SCALE)
	local beamRootRadii = Vector2.new(centerStartSize.Y * 0.5, centerStartSize.Z * 0.5)

	local center = Instance.new("Part")
	center.Name = "CenterCylinder"
	center.Shape = Enum.PartType.Cylinder
	center.Size = centerStartSize
	center.Material = ground.material
	center.MaterialVariant = ground.materialVariant
	center.Color = darkenColor(darkenColor(ground.color, RIM_DARKEN), 1.15)
	-- A Roblox cylinder's X axis is its depth. Rotate it onto world Y so Size.Y/Z
	-- map directly to the personal item's horizontal footprint.
	center.CFrame = CFrame.new(ground.position) * CFrame.Angles(0, 0, math.pi / 2) + Vector3.new(0, -0.05, 0)
	cantCollide(center)
	center.Parent = folder
	cloneParticle("Smoke", center, ground.color)
	cloneParticle("SmokeLine", center, ground.color)
	cloneParticle("Specs", center, ground.color)

	local rockCount = math.random(RANDOM_ROCK_COUNT_MIN, RANDOM_ROCK_COUNT_MAX)
	local angleStep = 360 / rockCount
	local rockScaleX = centerStartSize.Y / DEFAULT_CENTER_START_DIAMETER
	local rockScaleZ = centerStartSize.Z / DEFAULT_CENTER_START_DIAMETER
	local rockSizeScale = math.sqrt(rockScaleX * rockScaleZ)
	local rockOutwardDistance = ROCK_OUTWARD_DISTANCE * rockSizeScale
	local rocks: { RockStart } = {}
	for index = 1, rockCount do
		local angleDeg = (index - 1) * angleStep + math.random(-RANDOM_ROCK_ANGLE_JITTER, RANDOM_ROCK_ANGLE_JITTER)
		local radiusScale = 1
			+ (RANDOM_ROCK_RADIUS_JITTER_MIN
				+ math.random() * (RANDOM_ROCK_RADIUS_JITTER_MAX - RANDOM_ROCK_RADIUS_JITTER_MIN)) / RANDOM_ROCK_BASE_RADIUS
		local angleRad = math.rad(angleDeg)
		local ringPosition = ground.position + Vector3.new(
			math.cos(angleRad) * RANDOM_ROCK_BASE_RADIUS * rockScaleX * radiusScale,
			0,
			math.sin(angleRad) * RANDOM_ROCK_BASE_RADIUS * rockScaleZ * radiusScale
		)
		local rockSample = sampleGround(ringPosition, extraExclude)

		local rock = Instance.new("Part")
		rock.Name = "Rock/" .. index
		rock.Material = rockSample.material
		rock.MaterialVariant = rockSample.materialVariant
		rock.Color = darkenColor(rockSample.color, RIM_DARKEN)
		rock.CFrame = CFrame.lookAt(
			Vector3.new(ringPosition.X, 0, ringPosition.Z),
			Vector3.new(ground.position.X, 0, ground.position.Z)
		)
		rock.Orientation = rock.Orientation
			+ Vector3.new(-math.random(15, 35), math.random(-RANDOM_ROCK_YAW_JITTER, RANDOM_ROCK_YAW_JITTER), 0)

		local baseSize = Vector3.new(math.random(10, 20) / 10, 1, math.random(120, 126) / 100)
			* rockSizeScale
		rock.Size = baseSize + Vector3.new(0, 0.72, 0)
		rock.CFrame = (rock.CFrame * CFrame.new(0, (baseSize.Y - rock.Size.Y) / 2, 0))
			+ Vector3.new(0, ground.position.Y, 0)
		cantCollide(rock)
		rock.Parent = folder
		table.insert(rocks, {
			part = rock,
			cframe = rock.CFrame,
			size = rock.Size,
		})
	end

	local session = {
		folder = folder,
		center = center,
		positionPart = positionPart,
		groundNormal = ground.normal,
		groundPosition = ground.position,
		centerStartSize = centerStartSize,
		centerTargetSize = centerTargetSize,
		rocks = rocks,
		rockOutwardDistance = rockOutwardDistance,
		progressCount = 0,
		rarity = resolvedRarity,
		beams = RarityBeamUtil.Create(ground.position, folder, resolvedRarity, itemBounds, beamRootRadii),
	} :: MoundSession

	function session:SetBeamVisible(visible: boolean)
		if self.beams then
			self.beams:SetVisible(visible)
		end
	end

	function session:SetProgress(progress: number)
		local eased = math.clamp(progress, 0, 1) ^ PROGRESS_POWER
		self.center.Size = self.centerStartSize:Lerp(self.centerTargetSize, eased)
		for _, rockState in self.rocks do
			if not rockState.part.Parent then
				continue
			end
			local targetCFrame = rockState.cframe
				- rockState.cframe.LookVector * self.rockOutwardDistance
				- rockState.cframe.UpVector * ROCK_SINK_DISTANCE
			local targetSize = Vector3.new(
				rockState.size.X * RANDOM_ROCK_SIZE_SCALE.X,
				rockState.size.Y * RANDOM_ROCK_SIZE_SCALE.Y,
				rockState.size.Z * RANDOM_ROCK_SIZE_SCALE.Z
			)
			rockState.part.CFrame = rockState.cframe:Lerp(targetCFrame, eased)
			rockState.part.Size = rockState.size:Lerp(targetSize, eased)
		end
	end

	function session:Progress(strength: number)
		if self.progressCount >= MAX_PROGRESS then
			return
		end
		if self.progressCount == 0 then
			setLocalPlayerDebrisIgnore(true)
		end
		self.progressCount += 1

		local scaledStrength = math.clamp(strength, 0.4, 1.4)
		emitParticles(self.center, scaledStrength * 18)
		playDigSound(scaledStrength, self.center)
		spawnDigDebris(scaledStrength, self.positionPart.Position, ground.material, ground.materialVariant, ground.color)
		spawnSmallDigDebris(scaledStrength, self.positionPart.Position, ground.material, ground.materialVariant, ground.color)
	end

	function session:Clear(instant: boolean?)
		destroyBeamEffects(self, instant)
		setLocalPlayerDebrisIgnore(false)
		if instant then
			self.folder:Destroy()
			return
		end

		for _, descendant in self.folder:GetDescendants() do
			if descendant:IsA("BasePart") and descendant ~= self.positionPart then
				TweenService:Create(descendant, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					CFrame = descendant.CFrame - Vector3.new(0, 1.2, 0),
					Transparency = 1,
				}):Play()
			end
		end
		Debris:AddItem(self.folder, MOUND_CLEAR_DURATION)
	end

	function session:Destroy()
		destroyBeamEffects(self, true)
		setLocalPlayerDebrisIgnore(false)
		if self.folder.Parent then
			self.folder:Destroy()
		end
	end

	return session
end

function DigMoundEffect.PlayFinishSparkles(parent: BasePart, rarity: string?, sizeScale: number?)
	local template = diggingParticles:FindFirstChild("FinishSparkles")
	if not template or not template:IsA("ParticleEmitter") then
		return
	end
	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local style = RarityRevealConfig.GetStyle(resolvedRarity)
	local effectScale = math.clamp(sizeScale or 1, 0.8, 2.2)
	local sparkles = template:Clone()
	sparkles.Enabled = false
	local rarityColor = GuiUtil.GetRarityGradientColor(resolvedRarity)
	if rarityColor then
		sparkles.Color = ColorSequence.new(rarityColor)
	end
	sparkles.Size = scaleNumberSequence(sparkles.Size, effectScale)
	sparkles.Parent = parent
	for burstIndex = 1, style.sparkleBursts do
		local emitCount = math.max(1, math.floor(math.random(style.minSparkles, style.maxSparkles) * effectScale + 0.5))
		if burstIndex == 1 then
			sparkles:Emit(emitCount)
		else
			task.delay((burstIndex - 1) * 0.12, function()
				if sparkles.Parent then
					sparkles:Emit(emitCount)
				end
			end)
		end
	end
	Debris:AddItem(sparkles, 2)
end

function DigMoundEffect.PlayRevealSound(parent: BasePart, rarity: string?)
	local landTemplate = digSoundFolder:FindFirstChild("Land")
	local shineTemplate = digSoundFolder:FindFirstChild("Shine")
	local style = RarityRevealConfig.GetStyle(rarity)

	if landTemplate and landTemplate:IsA("Sound") then
		local land = landTemplate:Clone()
		land.Parent = parent
		land:Play()
		Debris:AddItem(land, 3)
	end

	if shineTemplate and shineTemplate:IsA("Sound") then
		local shine = shineTemplate:Clone()
		shine.PlaybackSpeed = style.soundPlaybackSpeed
		shine.Parent = parent
		shine:Play()
		Debris:AddItem(shine, 3)
	end
end

return DigMoundEffect
