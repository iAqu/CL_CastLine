local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local MovementSpeedUtil = require(ReplicatedStorage.Modules.MovementSpeedUtil)
local SurfaceGeometryUtil = require(ReplicatedStorage.Modules.SurfaceGeometryUtil)
local TideConfig = require(ReplicatedStorage.Modules.TideConfig)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)

type TideSnapshot = {
	phase: string,
	phaseStartedAt: number,
	phaseEndsAt: number?,
	lowTideEndsAt: number?,
	cycleEndsAt: number?,
	gateRevealAt: number?,
	isPaused: boolean,
	revision: number,
}

local localPlayer = Players.LocalPlayer

local TideController = Knit.CreateController({
	Name = "TideController",
	ProximityWarningStateChanged = Signal.new(),
})

local timeLabel: TextLabel? = nil
local tideLabel: TextLabel? = nil
local gateSurfaceGui: SurfaceGui? = nil
local gateCountdownFrame: Frame? = nil
local gateHintFrame: Frame? = nil
local gateTimeLabel: TextLabel? = nil
local gateHintLabel: TextLabel? = nil
local vignetteFrame: GuiObject? = nil
local vignetteImage: ImageLabel? = nil
local vignetteOriginalTransparency: number? = nil
local vignetteTween: Tween? = nil
local currentSnapshot: TideSnapshot? = nil
local currentRevision = -1
local lastGateSurfaceGuiVisible: boolean? = nil
local lastTopText: string? = nil
local lastGateTimeText: string? = nil
local earlyStateStarted = false
local zoneTopSurfaceYByIndex: { [number]: number } = {}
local lastRisingProximityWarningActive: boolean? = nil

local VIGNETTE_PULSE_TWEEN_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local VIGNETTE_PULSE_VISIBLE_TRANSPARENCY = 0.2
local VIGNETTE_PULSE_DIM_TRANSPARENCY = 0.75

local function resolveUi()
	local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local homeGui = playerGui and playerGui:FindFirstChild("HomeGui")
	local topFrame = homeGui and homeGui:FindFirstChild("TopFrame")
	local topTimeLabel = topFrame and topFrame:FindFirstChild("TimeLabel")
	if topTimeLabel and topTimeLabel:IsA("TextLabel") then
		timeLabel = topTimeLabel
	else
		warn("TideController: PlayerGui.HomeGui.TopFrame.TimeLabel is missing")
	end
	local topTideLabel = topFrame and topFrame:FindFirstChild("TideLabel")
	if topTideLabel and topTideLabel:IsA("TextLabel") then
		tideLabel = topTideLabel
		tideLabel.Visible = false
	else
		warn("TideController: PlayerGui.HomeGui.TopFrame.TideLabel is missing")
	end

	local vignette = homeGui and homeGui:FindFirstChild("VignetteFrame")
	local image = vignette and vignette:FindFirstChild("ImageLabel")
	if vignette and vignette:IsA("GuiObject") and image and image:IsA("ImageLabel") then
		vignetteFrame = vignette
		vignetteImage = image
		vignetteOriginalTransparency = image.ImageTransparency
		vignette.Visible = false
	else
		warn("TideController: PlayerGui.HomeGui.VignetteFrame.ImageLabel is missing or is not an ImageLabel")
	end

	local areas = Workspace:FindFirstChild("Areas")
	local doors = areas and areas:FindFirstChild("Doors")
	local gateInstance = doors and doors:FindFirstChild("Gate")
	if not gateInstance or not gateInstance:IsA("BasePart") then
		warn("TideController: Workspace.Areas.Doors.Gate is missing")
		return
	end
	gateInstance.Transparency = 1
	gateInstance.CanCollide = false

	local surfaceGui = gateInstance:FindFirstChild("SurfaceGui")
	if surfaceGui and surfaceGui:IsA("SurfaceGui") then
		gateSurfaceGui = surfaceGui
		surfaceGui.Enabled = true
	else
		warn("TideController: Workspace.Areas.Doors.Gate.SurfaceGui is missing")
		return
	end

	local frame = surfaceGui:FindFirstChild("Frame")
	if frame and frame:IsA("Frame") then
		gateCountdownFrame = frame
	else
		warn("TideController: Gate SurfaceGui Frame is missing")
	end
	local hintFrameInstance = surfaceGui:FindFirstChild("HintFame")
	if hintFrameInstance and hintFrameInstance:IsA("Frame") then
		gateHintFrame = hintFrameInstance
	else
		warn("TideController: Gate SurfaceGui HintFame is missing")
	end

	local timeInstance = frame and frame:FindFirstChild("TimeLabel")
	local hintInstance = frame and frame:FindFirstChild("HintLabel")
	if timeInstance and timeInstance:IsA("TextLabel") then
		gateTimeLabel = timeInstance
	else
		warn("TideController: Gate SurfaceGui Frame TimeLabel is missing")
	end
	if hintInstance and hintInstance:IsA("TextLabel") then
		gateHintLabel = hintInstance
	else
		warn("TideController: Gate SurfaceGui Frame HintLabel is missing")
	end
end

local function resolveZoneTopSurfaces(): boolean
	local areas = Workspace:FindFirstChild("Areas")
	if not areas then
		warn("TideController: Workspace.Areas is missing")
		return false
	end

	table.clear(zoneTopSurfaceYByIndex)
	for zoneIndex = 1, TideConfig.DIG_ZONE_COUNT do
		local zone = areas:FindFirstChild("Zone_" .. zoneIndex)
		local mainPart = zone and zone:FindFirstChild("MainPart")
		if not mainPart or not mainPart:IsA("BasePart") then
			table.clear(zoneTopSurfaceYByIndex)
			warn("TideController: Workspace.Areas.Zone_" .. zoneIndex .. ".MainPart is missing")
			return false
		end
		zoneTopSurfaceYByIndex[zoneIndex] = SurfaceGeometryUtil.GetTopSurfaceLowestY(mainPart)
	end
	return true
end

local function stopRisingWarning()
	if tideLabel then
		tideLabel.Visible = false
	end
end

local function startRisingWarning()
	if not tideLabel then
		return
	end
	tideLabel.Visible = true
end

local function stopRisingVignette()
	if vignetteTween then
		vignetteTween:Cancel()
		vignetteTween = nil
	end

	local vignette = vignetteFrame
	local image = vignetteImage
	if not vignette or not image then
		return
	end
	if vignetteOriginalTransparency then
		image.ImageTransparency = vignetteOriginalTransparency
	end
	vignette.Visible = false
end

local function isLocalCharacterAlive(): boolean
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0
end

local function isRisingForAlivePlayer(): boolean
	local snapshot = currentSnapshot
	return snapshot ~= nil
		and snapshot.phase == TideConfig.PHASE.RISING
		and not snapshot.isPaused
		and isLocalCharacterAlive()
end

local function isRisingTextWarningActive(): boolean
	return isRisingForAlivePlayer()
		and localPlayer:GetAttribute(MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE) == true
end

local function getCurrentDigZoneIndex(): number?
	local zoneId = localPlayer:GetAttribute(MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE)
	if typeof(zoneId) ~= "string" then
		return nil
	end

	local zoneIndex = tonumber(string.match(zoneId, "^Zone_(%d+)$"))
	if not zoneIndex or zoneIndex < 1 or zoneIndex > TideConfig.DIG_ZONE_COUNT then
		return nil
	end
	return zoneIndex
end

local function getRisingTideFrontZoneIndex(): number?
	local waterSurfaceY = WaterSurfaceUtil.GetWaterSurfaceY()
	if not waterSurfaceY then
		return nil
	end

	for zoneIndex = 1, TideConfig.DIG_ZONE_COUNT do
		local zoneTopSurfaceY = zoneTopSurfaceYByIndex[zoneIndex]
		if zoneTopSurfaceY and waterSurfaceY + TideConfig.TARGET_TOLERANCE >= zoneTopSurfaceY then
			return zoneIndex
		end
	end
	return nil
end

function TideController:IsRisingProximityWarningActive(): boolean
	if not isRisingForAlivePlayer() then
		return false
	end

	local playerZoneIndex = getCurrentDigZoneIndex()
	local waterZoneIndex = getRisingTideFrontZoneIndex()
	if not playerZoneIndex or not waterZoneIndex then
		return false
	end
	return waterZoneIndex - playerZoneIndex < TideConfig.PROXIMITY_WARNING_ZONE_DISTANCE
end

local function setRisingProximityWarningState(isActive: boolean): boolean
	if lastRisingProximityWarningActive ~= isActive then
		lastRisingProximityWarningActive = isActive
		TideController.ProximityWarningStateChanged:Fire(isActive)
	end
	return isActive
end

local function updateRisingProximityWarningState(): boolean
	return setRisingProximityWarningState(TideController:IsRisingProximityWarningActive())
end

local function updateRisingVignette(isProximityWarningActive: boolean)
	if not isProximityWarningActive then
		stopRisingVignette()
		return
	end

	local vignette = vignetteFrame
	local image = vignetteImage
	local originalTransparency = vignetteOriginalTransparency
	if not vignette or not image or not image:IsDescendantOf(game) or originalTransparency == nil then
		stopRisingVignette()
		return
	end
	if vignetteTween then
		return
	end

	image.ImageTransparency = VIGNETTE_PULSE_VISIBLE_TRANSPARENCY
	vignette.Visible = true
	vignetteTween = TweenService:Create(image, VIGNETTE_PULSE_TWEEN_INFO, {
		ImageTransparency = VIGNETTE_PULSE_DIM_TRANSPARENCY,
	})
	vignetteTween:Play()
end

local function setGateSurfaceGuiVisible(isCountdownVisible: boolean)
	if lastGateSurfaceGuiVisible == isCountdownVisible then
		return
	end
	lastGateSurfaceGuiVisible = isCountdownVisible
	if gateSurfaceGui then
		gateSurfaceGui.Enabled = true
	end
	if gateCountdownFrame then
		gateCountdownFrame.Visible = isCountdownVisible
	end
	if gateHintFrame then
		gateHintFrame.Visible = not isCountdownVisible
	end
end

local function setTopText(text: string)
	if lastTopText == text then
		return
	end
	lastTopText = text
	if timeLabel then
		timeLabel.Visible = true
		timeLabel.Text = text
	end
end

local function setGateTimeText(text: string)
	if lastGateTimeText == text then
		return
	end
	lastGateTimeText = text
	if gateTimeLabel then
		gateTimeLabel.Text = text
	end
end

local function formatCountdownWithMilliseconds(secondsRemaining: number): string
	local totalMilliseconds = math.floor(math.max(0, secondsRemaining) * 1000)
	local minutes = math.floor(totalMilliseconds / 60_000)
	local seconds = math.floor(totalMilliseconds / 1_000) % 60
	local milliseconds = totalMilliseconds % 1_000
	return string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)
end

local function isValidSnapshot(snapshot: unknown): boolean
	if typeof(snapshot) ~= "table" then
		return false
	end
	local candidate = snapshot :: any
	if typeof(candidate.phase) ~= "string"
		or typeof(candidate.isPaused) ~= "boolean"
		or typeof(candidate.revision) ~= "number"
	then
		return false
	end
	return candidate.phase == TideConfig.PHASE.FULL
		or candidate.phase == TideConfig.PHASE.RECEDING
		or candidate.phase == TideConfig.PHASE.LOW
		or candidate.phase == TideConfig.PHASE.RISING
end

local function applySnapshot(snapshot: unknown)
	if not isValidSnapshot(snapshot) then
		warn("TideController: received invalid tide snapshot")
		return
	end

	local typedSnapshot = snapshot :: TideSnapshot
	if typedSnapshot.revision < currentRevision then
		return
	end
	currentRevision = typedSnapshot.revision
	currentSnapshot = typedSnapshot
end

local function updatePresentation()
	local isProximityWarningActive = updateRisingProximityWarningState()
	local snapshot = currentSnapshot
	if not snapshot then
		stopRisingWarning()
		stopRisingVignette()
		setGateSurfaceGuiVisible(false)
		return
	end

	local now = Workspace:GetServerTimeNow()
	if snapshot.isPaused then
		stopRisingWarning()
		stopRisingVignette()
		setTopText("Tide paused")
		return
	elseif snapshot.phase == TideConfig.PHASE.FULL then
		stopRisingWarning()
		setTopText("Waiting for low tide")
		if gateHintLabel then
			gateHintLabel.Text = "Waiting for low tide"
		end

		local phaseEndsAt = snapshot.phaseEndsAt or now
		setGateTimeText(tostring(math.max(0, math.round(phaseEndsAt - now))))
		setGateSurfaceGuiVisible(true)
	elseif snapshot.phase == TideConfig.PHASE.RECEDING then
		stopRisingWarning()
		local cycleEndsAt = snapshot.cycleEndsAt
		if cycleEndsAt then
			setTopText(formatCountdownWithMilliseconds(cycleEndsAt - now))
		else
			setTopText("Tide is receding")
		end
		setGateSurfaceGuiVisible(false)
	elseif snapshot.phase == TideConfig.PHASE.LOW then
		stopRisingWarning()
		local cycleEndsAt = snapshot.cycleEndsAt or snapshot.phaseEndsAt or now
		setTopText(formatCountdownWithMilliseconds(cycleEndsAt - now))
		setGateSurfaceGuiVisible(false)
	elseif snapshot.phase == TideConfig.PHASE.RISING then
		if isRisingTextWarningActive() then
			startRisingWarning()
		else
			stopRisingWarning()
		end
		local cycleEndsAt = snapshot.cycleEndsAt or snapshot.phaseEndsAt or now
		setTopText(formatCountdownWithMilliseconds(cycleEndsAt - now))
		setGateSurfaceGuiVisible(false)
	end
	updateRisingVignette(isProximityWarningActive)
end

local function applyReplicatedState(stateFolder: Folder)
	local attributes = TideConfig.STATE_ATTRIBUTE
	local revision = stateFolder:GetAttribute(attributes.REVISION)
	local phase = stateFolder:GetAttribute(attributes.PHASE)
	local phaseStartedAt = stateFolder:GetAttribute(attributes.PHASE_STARTED_AT)
	if typeof(revision) ~= "number" or typeof(phase) ~= "string" or typeof(phaseStartedAt) ~= "number" then
		return
	end

	applySnapshot({
		phase = phase,
		phaseStartedAt = phaseStartedAt,
		phaseEndsAt = stateFolder:GetAttribute(attributes.PHASE_ENDS_AT),
		lowTideEndsAt = stateFolder:GetAttribute(attributes.LOW_TIDE_ENDS_AT),
		cycleEndsAt = stateFolder:GetAttribute(attributes.CYCLE_ENDS_AT),
		gateRevealAt = stateFolder:GetAttribute(attributes.GATE_REVEAL_AT),
		isPaused = stateFolder:GetAttribute(attributes.IS_PAUSED),
		revision = revision,
	})
	updatePresentation()
end

function TideController:BeginEarlyState()
	if earlyStateStarted then
		return
	end
	earlyStateStarted = true

	task.spawn(function()
		local playerGui = localPlayer:WaitForChild("PlayerGui", 15)
		if not playerGui then
			warn("TideController: PlayerGui did not replicate in time")
			return
		end
		if not playerGui:WaitForChild("HomeGui", 15) then
			warn("TideController: HomeGui did not replicate in time")
			return
		end

		resolveUi()
		resolveZoneTopSurfaces()
		setGateSurfaceGuiVisible(false)
		stopRisingVignette()

		localPlayer:GetAttributeChangedSignal(MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE):Connect(updatePresentation)
		localPlayer:GetAttributeChangedSignal(MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE):Connect(updatePresentation)
		localPlayer.CharacterAdded:Connect(function()
			stopRisingWarning()
			stopRisingVignette()
			updatePresentation()
		end)
		localPlayer.CharacterRemoving:Connect(function()
			stopRisingWarning()
			stopRisingVignette()
			setRisingProximityWarningState(false)
		end)
		RunService.Heartbeat:Connect(updatePresentation)

		local stateInstance = ReplicatedStorage:WaitForChild(TideConfig.STATE_FOLDER_NAME, 15)
		if not stateInstance or not stateInstance:IsA("Folder") then
			warn("TideController: replicated tide state is missing")
			return
		end

		stateInstance:GetAttributeChangedSignal(TideConfig.STATE_ATTRIBUTE.REVISION):Connect(function()
			applyReplicatedState(stateInstance)
		end)
		-- 先订阅再读取，避免快照在两步之间更新而丢失最新 revision。
		applyReplicatedState(stateInstance)
	end)
end

function TideController:KnitStart()
	self:BeginEarlyState()

	local tideService = Knit.GetService("TideService")
	tideService.StateChanged:Connect(function(snapshot: TideSnapshot)
		applySnapshot(snapshot)
		updatePresentation()
	end)

	tideService:GetStateSnapshot():andThen(function(snapshot: TideSnapshot?)
		if snapshot then
			applySnapshot(snapshot)
			updatePresentation()
		end
	end):catch(function(err)
		warn("TideController: failed to get tide snapshot", err)
	end)
end

return TideController
