local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)

local LOCAL_PLAYER = Players.LocalPlayer

local MODELS_FOLDER_NAME = "Models"
local FOOTPRINT_FOLDER_NAME = "Footprints"
local ACTIVE_FOLDER_NAME = "Active"
local LEFT_TEMPLATE_NAME = "Footprint_Left"
local RIGHT_TEMPLATE_NAME = "Footprint_Right"

local MAX_VIEW_DISTANCE = 120
local BASE_STRIDE_DISTANCE = 2.8
local TELEPORT_DISTANCE = 12
local MIN_HORIZONTAL_SPEED = 1
local RAY_ORIGIN_HEIGHT = 1.5
local RAY_LENGTH = 5
local SURFACE_OFFSET = 0.02
local HOLD_SECONDS = 4
local FADE_SECONDS = 2
local SUBMERGED_FADE_SECONDS = 0.25
local MAINTENANCE_INTERVAL = 0.1
local SUBMERGED_CHECK_INTERVAL = 0.25
local MAX_ACTIVE_FOOTPRINTS = 120

type FootSide = "Left" | "Right"

type TemplateInfo = {
	part: MeshPart,
	size: Vector3,
	transparency: number,
}

type Tracker = {
	player: Player,
	character: Model,
	humanoid: Humanoid,
	root: BasePart,
	lastPosition: Vector3,
	distanceTravelled: number,
	nextSide: FootSide,
}

type ActiveFootprint = {
	part: MeshPart,
	owner: Player,
	side: FootSide,
	createdAt: number,
	fadeEndsAt: number?,
	tween: Tween?,
	tweenConnection: RBXScriptConnection?,
}

local FootprintController = Knit.CreateController({
	Name = "FootprintController",
})

local templateInfos: { [FootSide]: TemplateInfo } = {}
local pools: { [FootSide]: { MeshPart } } = {
	Left = {},
	Right = {},
}
local trackers: { [Player]: Tracker } = {}
local playerConnections: { [Player]: { RBXScriptConnection } } = {}
local activeFootprints: { ActiveFootprint } = {}
local raycastParams = RaycastParams.new()

local runtimeFolder: Folder? = nil
local activeFolder: Folder? = nil
local ownsRuntimeFolder = false
local ownsActiveFolder = false
local waterDrownController = nil
local heartbeatConnection: RBXScriptConnection? = nil
local playerAddedConnection: RBXScriptConnection? = nil
local playerRemovingConnection: RBXScriptConnection? = nil
local maintenanceElapsed = 0
local submergedCheckElapsed = 0

local BLOCKED_STATES = {
	[Enum.HumanoidStateType.Climbing] = true,
	[Enum.HumanoidStateType.Dead] = true,
	[Enum.HumanoidStateType.Freefall] = true,
	[Enum.HumanoidStateType.Jumping] = true,
	[Enum.HumanoidStateType.Seated] = true,
	[Enum.HumanoidStateType.Swimming] = true,
}

local function disconnect(connection: RBXScriptConnection?)
	if connection then
		connection:Disconnect()
	end
end

local function getCharacterScale(character: Model): number
	return math.clamp(character:GetScale(), 0.5, 3)
end

local function getTemplateInfo(side: FootSide): TemplateInfo?
	return templateInfos[side]
end

local function removeActiveRecord(record: ActiveFootprint)
	for index = #activeFootprints, 1, -1 do
		if activeFootprints[index] == record then
			table.remove(activeFootprints, index)
			return
		end
	end
end

local function recycleFootprint(record: ActiveFootprint)
	disconnect(record.tweenConnection)
	record.tweenConnection = nil
	if record.tween then
		record.tween:Cancel()
		record.tween = nil
	end

	removeActiveRecord(record)
	record.part.Parent = nil
	record.part.Transparency = 1
	table.insert(pools[record.side], record.part)
end

local function beginFade(record: ActiveFootprint, duration: number)
	local now = time()
	if record.fadeEndsAt and record.fadeEndsAt <= now + duration then
		return
	end

	disconnect(record.tweenConnection)
	record.tweenConnection = nil
	if record.tween then
		record.tween:Cancel()
	end

	record.fadeEndsAt = now + duration
	local tween = TweenService:Create(
		record.part,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{ Transparency = 1 }
	)
	record.tween = tween
	record.tweenConnection = tween.Completed:Connect(function(playbackState)
		if playbackState == Enum.PlaybackState.Completed then
			recycleFootprint(record)
		end
	end)
	tween:Play()
end

local function acquireFootprint(side: FootSide): MeshPart?
	local info = getTemplateInfo(side)
	if not info then
		return nil
	end

	local pool = pools[side]
	local footprint = table.remove(pool)
	if not footprint then
		footprint = info.part:Clone()
	end

	footprint.Name = side == "Left" and "Footprint_Left_Active" or "Footprint_Right_Active"
	footprint.Anchored = true
	footprint.CanCollide = false
	footprint.CanQuery = false
	footprint.CanTouch = false
	footprint.CastShadow = false
	footprint.Transparency = info.transparency
	return footprint
end

local function getFootPart(character: Model, side: FootSide): BasePart?
	local r15Name = side == "Left" and "LeftFoot" or "RightFoot"
	local r6Name = side == "Left" and "Left Leg" or "Right Leg"
	local foot = character:FindFirstChild(r15Name) or character:FindFirstChild(r6Name)
	return if foot and foot:IsA("BasePart") then foot else nil
end

local function getRayOrigin(tracker: Tracker, side: FootSide, scale: number): Vector3
	local foot = getFootPart(tracker.character, side)
	if foot then
		return foot.Position + Vector3.yAxis * RAY_ORIGIN_HEIGHT * scale
	end

	local sideSign = if side == "Left" then -1 else 1
	return tracker.root.Position
		+ tracker.root.CFrame.RightVector * sideSign * 0.35 * scale
		+ Vector3.yAxis * 0.5 * scale
end

local function getFootprintCFrame(position: Vector3, normal: Vector3, root: BasePart, side: FootSide): CFrame?
	local forward = root.CFrame.LookVector - normal * root.CFrame.LookVector:Dot(normal)
	if forward.Magnitude < 0.001 then
		return nil
	end
	forward = forward.Unit

	local right = forward:Cross(normal)
	if right.Magnitude < 0.001 then
		return nil
	end
	right = right.Unit

	local footprintPosition = position + normal * SURFACE_OFFSET
	if side == "Left" then
		return CFrame.fromMatrix(footprintPosition, right, forward, normal)
	end
	return CFrame.fromMatrix(footprintPosition, -right, forward, -normal)
end

local function placeFootprint(tracker: Tracker, side: FootSide): boolean
	local scale = getCharacterScale(tracker.character)
	local rayOrigin = getRayOrigin(tracker, side, scale)
	local result = Workspace:Raycast(rayOrigin, -Vector3.yAxis * RAY_LENGTH * scale, raycastParams)
	if not result then
		return false
	end
	if waterDrownController:IsPointSubmerged(result.Position) then
		return false
	end

	local footprintCFrame = getFootprintCFrame(result.Position, result.Normal, tracker.root, side)
	if not footprintCFrame then
		return false
	end

	if #activeFootprints >= MAX_ACTIVE_FOOTPRINTS then
		recycleFootprint(activeFootprints[1])
	end

	local info = getTemplateInfo(side)
	local footprint = acquireFootprint(side)
	if not info or not footprint or not activeFolder then
		return false
	end

	footprint.Size = info.size * scale
	footprint.CFrame = footprintCFrame
	footprint.Parent = activeFolder
	table.insert(activeFootprints, {
		part = footprint,
		owner = tracker.player,
		side = side,
		createdAt = time(),
		fadeEndsAt = nil,
		tween = nil,
		tweenConnection = nil,
	})
	return true
end

local function recyclePlayerFootprints(player: Player)
	for index = #activeFootprints, 1, -1 do
		local record = activeFootprints[index]
		if record.owner == player then
			recycleFootprint(record)
		end
	end
end

local function clearTracker(player: Player, character: Model?)
	local tracker = trackers[player]
	if tracker and (not character or tracker.character == character) then
		trackers[player] = nil
		recyclePlayerFootprints(player)
	end
end

local function attachCharacter(player: Player, character: Model)
	task.spawn(function()
		local humanoid = character:WaitForChild("Humanoid", 10)
		local root = character:WaitForChild("HumanoidRootPart", 10)
		if player.Character ~= character
			or not humanoid
			or not humanoid:IsA("Humanoid")
			or not root
			or not root:IsA("BasePart")
		then
			return
		end

		clearTracker(player)
		trackers[player] = {
			player = player,
			character = character,
			humanoid = humanoid,
			root = root,
			lastPosition = root.Position,
			distanceTravelled = 0,
			nextSide = "Left",
		}
	end)
end

local function stopTrackingPlayer(player: Player)
	clearTracker(player)
	local connections = playerConnections[player]
	if connections then
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		playerConnections[player] = nil
	end
end

local function trackPlayer(player: Player)
	stopTrackingPlayer(player)
	playerConnections[player] = {
		player.CharacterAdded:Connect(function(character)
			attachCharacter(player, character)
		end),
		player.CharacterRemoving:Connect(function(character)
			clearTracker(player, character)
		end),
	}

	if player.Character then
		attachCharacter(player, player.Character)
	end
end

local function isTrackerEligible(tracker: Tracker, observerRoot: BasePart?): boolean
	if not tracker.character.Parent or tracker.humanoid.Health <= 0 or tracker.humanoid.FloorMaterial == Enum.Material.Air then
		return false
	end
	if BLOCKED_STATES[tracker.humanoid:GetState()] then
		return false
	end
	if tracker.player ~= LOCAL_PLAYER then
		return observerRoot ~= nil and (tracker.root.Position - observerRoot.Position).Magnitude <= MAX_VIEW_DISTANCE
	end
	return true
end

local function updateTracker(tracker: Tracker, deltaTime: number, observerRoot: BasePart?)
	local position = tracker.root.Position
	local delta = Vector3.new(position.X - tracker.lastPosition.X, 0, position.Z - tracker.lastPosition.Z)
	tracker.lastPosition = position

	local scale = getCharacterScale(tracker.character)
	if delta.Magnitude >= TELEPORT_DISTANCE * scale or not isTrackerEligible(tracker, observerRoot) then
		tracker.distanceTravelled = 0
		return
	end
	if deltaTime <= 0 or delta.Magnitude / deltaTime < MIN_HORIZONTAL_SPEED then
		return
	end

	tracker.distanceTravelled += delta.Magnitude
	if tracker.distanceTravelled < BASE_STRIDE_DISTANCE * scale then
		return
	end
	tracker.distanceTravelled = 0

	local side = tracker.nextSide
	if placeFootprint(tracker, side) then
		tracker.nextSide = if side == "Left" then "Right" else "Left"
	end
end

local function maintainFootprints(checkSubmerged: boolean)
	local now = time()
	for index = #activeFootprints, 1, -1 do
		local record = activeFootprints[index]
		if not record.part.Parent then
			recycleFootprint(record)
		elseif checkSubmerged and waterDrownController:IsPointSubmerged(record.part.Position) then
			beginFade(record, SUBMERGED_FADE_SECONDS)
		elseif not record.fadeEndsAt and now - record.createdAt >= HOLD_SECONDS then
			beginFade(record, FADE_SECONDS)
		end
	end
end

local function collectSurfaces(): { BasePart }
	local surfaces = {}
	local areas = Workspace:FindFirstChild("Areas")
	if not areas then
		return surfaces
	end

	for _, zone in areas:GetChildren() do
		if zone.Name:match("^Zone_%d+$") then
			for _, surfaceName in ipairs({ "MainPart", "EndPart" }) do
				local surface = zone:FindFirstChild(surfaceName)
				if surface and surface:IsA("BasePart") then
					table.insert(surfaces, surface)
				end
			end
		end
	end
	return surfaces
end

local function initializeTemplates(): boolean
	local models = ReplicatedStorage:FindFirstChild(MODELS_FOLDER_NAME)
	local templateFolder = models and models:FindFirstChild(FOOTPRINT_FOLDER_NAME)
	if not templateFolder or not templateFolder:IsA("Folder") then
		warn("FootprintController: ReplicatedStorage.Models.Footprints folder is missing")
		return false
	end

	local left = templateFolder:FindFirstChild(LEFT_TEMPLATE_NAME)
	local right = templateFolder:FindFirstChild(RIGHT_TEMPLATE_NAME)
	if not left or not left:IsA("MeshPart") or not right or not right:IsA("MeshPart") then
		warn("FootprintController: ReplicatedStorage.Models.Footprints templates are missing or invalid")
		return false
	end

	local workspaceFolder = Workspace:FindFirstChild(FOOTPRINT_FOLDER_NAME)
	if workspaceFolder then
		if not workspaceFolder:IsA("Folder") then
			warn("FootprintController: Workspace.Footprints must be a Folder")
			return false
		end
		runtimeFolder = workspaceFolder
	else
		local newRuntimeFolder = Instance.new("Folder")
		newRuntimeFolder.Name = FOOTPRINT_FOLDER_NAME
		newRuntimeFolder.Parent = Workspace
		runtimeFolder = newRuntimeFolder
		workspaceFolder = newRuntimeFolder
		ownsRuntimeFolder = true
	end

	local existingActive = workspaceFolder:FindFirstChild(ACTIVE_FOLDER_NAME)
	if existingActive then
		if not existingActive:IsA("Folder") then
			warn("FootprintController: Workspace.Footprints.Active must be a Folder")
			return false
		end
		activeFolder = existingActive
	else
		local newActiveFolder = Instance.new("Folder")
		newActiveFolder.Name = ACTIVE_FOLDER_NAME
		newActiveFolder.Parent = workspaceFolder
		activeFolder = newActiveFolder
		ownsActiveFolder = true
	end

	templateInfos.Left = {
		part = left,
		size = left.Size,
		transparency = left.Transparency,
	}
	templateInfos.Right = {
		part = right,
		size = right.Size,
		transparency = right.Transparency,
	}
	return true
end

function FootprintController:KnitStart()
	local surfaces = collectSurfaces()
	if #surfaces == 0 then
		warn("FootprintController: no Zone_* footprint surfaces were found")
		return
	end
	if not initializeTemplates() then
		return
	end
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = surfaces
	raycastParams.IgnoreWater = true

	waterDrownController = Knit.GetController("WaterDrownController")
	for _, player in ipairs(Players:GetPlayers()) do
		trackPlayer(player)
	end
	playerAddedConnection = Players.PlayerAdded:Connect(trackPlayer)
	playerRemovingConnection = Players.PlayerRemoving:Connect(stopTrackingPlayer)

	heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
		local localCharacter = LOCAL_PLAYER.Character
		local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
		local observerRoot = if localRoot and localRoot:IsA("BasePart") then localRoot else nil

		for _, tracker in pairs(trackers) do
			updateTracker(tracker, deltaTime, observerRoot)
		end

		maintenanceElapsed += deltaTime
		submergedCheckElapsed += deltaTime
		if maintenanceElapsed >= MAINTENANCE_INTERVAL then
			local checkSubmerged = submergedCheckElapsed >= SUBMERGED_CHECK_INTERVAL
			maintenanceElapsed = 0
			if checkSubmerged then
				submergedCheckElapsed = 0
			end
			maintainFootprints(checkSubmerged)
		end
	end)
end

function FootprintController:Destroy()
	disconnect(heartbeatConnection)
	disconnect(playerAddedConnection)
	disconnect(playerRemovingConnection)
	heartbeatConnection = nil
	playerAddedConnection = nil
	playerRemovingConnection = nil

	local trackedPlayers = {}
	for player in pairs(playerConnections) do
		table.insert(trackedPlayers, player)
	end
	for _, player in ipairs(trackedPlayers) do
		stopTrackingPlayer(player)
	end
	for index = #activeFootprints, 1, -1 do
		recycleFootprint(activeFootprints[index])
	end
	for _, pool in pairs(pools) do
		for _, footprint in ipairs(pool) do
			footprint:Destroy()
		end
		table.clear(pool)
	end
	table.clear(templateInfos)
	if ownsRuntimeFolder and runtimeFolder then
		runtimeFolder:Destroy()
	elseif ownsActiveFolder and activeFolder then
		activeFolder:Destroy()
	end
	runtimeFolder = nil
	activeFolder = nil
	ownsRuntimeFolder = false
	ownsActiveFolder = false
end

return FootprintController
