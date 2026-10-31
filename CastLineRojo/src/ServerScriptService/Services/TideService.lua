local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TideConfig = require(ReplicatedStorage.Modules.TideConfig)
local SurfaceGeometryUtil = require(ReplicatedStorage.Modules.SurfaceGeometryUtil)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)

export type TidePhase = "Full" | "Receding" | "Low" | "Rising"
export type TideSnapshot = {
	phase: TidePhase,
	phaseStartedAt: number,
	phaseEndsAt: number?,
	lowTideEndsAt: number?,
	cycleEndsAt: number?,
	gateRevealAt: number?,
	isPaused: boolean,
	revision: number,
}

type TideAnimation = {
	value: CFrameValue,
	valueConnection: RBXScriptConnection,
	tween: Tween,
}

type PausedTide = {
	phase: TidePhase,
	phaseRemaining: number?,
}

local TideService = Knit.CreateService({
	Name = "TideService",
	Client = {
		StateChanged = Knit.CreateSignal(),
	},
	StateChangedServerEvent = Signal.new(),
	_ActiveAnimation = nil :: TideAnimation?,
	_RunRevision = 0,
	_StateRevision = 0,
	_Snapshot = nil :: TideSnapshot?,
	_Water = nil :: Model?,
	_HighTideMarker = nil :: BasePart?,
	_LowTideZonePart = nil :: BasePart?,
	_IsReady = false,
	_EarlyStateStarted = false,
	_FrameworkReady = false,
	_StateFolder = nil :: Folder?,
	_IsPaused = false,
	_PausedTide = nil :: PausedTide?,
})

local function getResources(): (Model?, BasePart?, BasePart?)
	local areas = Workspace:FindFirstChild("Areas")
	if not areas then
		warn("TideService: Workspace.Areas is missing")
		return nil, nil, nil
	end

	local water = areas:FindFirstChild("Water")
	if not water or not water:IsA("Model") then
		warn("TideService: Workspace.Areas.Water model is missing")
		return nil, nil, nil
	end

	local highTideMarker = areas:FindFirstChild("WaterSurfacePosition")
	if not highTideMarker or not highTideMarker:IsA("BasePart") then
		warn("TideService: Workspace.Areas.WaterSurfacePosition part is missing")
		return nil, nil, nil
	end

	local lowTideZone = areas:FindFirstChild(TideConfig.LOW_TIDE_ZONE_ID)
	local lowTideZonePart = lowTideZone and lowTideZone:FindFirstChild("MainPart")
	if not lowTideZonePart or not lowTideZonePart:IsA("BasePart") then
		warn("TideService: Workspace.Areas." .. TideConfig.LOW_TIDE_ZONE_ID .. ".MainPart is missing")
		return nil, nil, nil
	end

	return water, highTideMarker, lowTideZonePart
end

function TideService:_getHighTideY(): number
	return (self._HighTideMarker :: BasePart).Position.Y
end

function TideService:_getLowTideY(): number
	local zonePart = self._LowTideZonePart :: BasePart
	local water = self._Water :: Model
	local zoneTopLowestY = SurfaceGeometryUtil.GetTopSurfaceLowestY(zonePart)
	local waterSurfaceY = WaterSurfaceUtil.GetWaterSurfaceY()
	if not waterSurfaceY then
		warn("TideService: Workspace.Areas.Water.Top is missing; using the water pivot as the low-tide reference")
		return zoneTopLowestY
	end

	local surfaceOffsetY = waterSurfaceY - water:GetPivot().Position.Y
	return zoneTopLowestY - surfaceOffsetY
end

function TideService:_isAtTarget(targetY: number): boolean
	local water = self._Water :: Model
	return math.abs(water:GetPivot().Position.Y - targetY) <= TideConfig.TARGET_TOLERANCE
end

function TideService:_getTravelDuration(targetY: number): number
	local water = self._Water :: Model
	local distance = math.abs(targetY - water:GetPivot().Position.Y)
	if distance <= TideConfig.TARGET_TOLERANCE then
		return 0
	end
	return distance / TideConfig.WATER_SPEED
end

function TideService:_getTravelDurationBetween(startY: number, targetY: number): number
	return math.abs(targetY - startY) / TideConfig.WATER_SPEED
end

function TideService:_pivotWaterToY(targetY: number)
	local water = self._Water :: Model
	local currentPivot = water:GetPivot()
	local targetPosition = Vector3.new(currentPivot.Position.X, targetY, currentPivot.Position.Z)
	water:PivotTo(CFrame.new(targetPosition) * currentPivot.Rotation)
end

function TideService:_cancelActiveAnimation()
	local animation = self._ActiveAnimation
	if not animation then
		return
	end

	self._ActiveAnimation = nil
	animation.valueConnection:Disconnect()
	animation.tween:Cancel()
	animation.value:Destroy()
end

function TideService:_replicateSnapshot(snapshot: TideSnapshot)
	local stateFolder = self._StateFolder
	if not stateFolder then
		local existing = ReplicatedStorage:FindFirstChild(TideConfig.STATE_FOLDER_NAME)
		if existing and existing:IsA("Folder") then
			stateFolder = existing
		else
			if existing then
				warn("TideService: ReplicatedStorage." .. TideConfig.STATE_FOLDER_NAME .. " must be a Folder")
				return
			end
			stateFolder = Instance.new("Folder")
			stateFolder.Name = TideConfig.STATE_FOLDER_NAME
		end
		self._StateFolder = stateFolder
	end

	local attributes = TideConfig.STATE_ATTRIBUTE
	stateFolder:SetAttribute(attributes.PHASE, snapshot.phase)
	stateFolder:SetAttribute(attributes.PHASE_STARTED_AT, snapshot.phaseStartedAt)
	stateFolder:SetAttribute(attributes.PHASE_ENDS_AT, snapshot.phaseEndsAt)
	stateFolder:SetAttribute(attributes.LOW_TIDE_ENDS_AT, snapshot.lowTideEndsAt)
	stateFolder:SetAttribute(attributes.CYCLE_ENDS_AT, snapshot.cycleEndsAt)
	stateFolder:SetAttribute(attributes.GATE_REVEAL_AT, snapshot.gateRevealAt)
	stateFolder:SetAttribute(attributes.IS_PAUSED, snapshot.isPaused)
	-- Revision 必须最后写；客户端把它作为一组属性已完整更新的提交信号。
	stateFolder:SetAttribute(attributes.REVISION, snapshot.revision)
	if not stateFolder.Parent then
		stateFolder.Parent = ReplicatedStorage
	end
end

function TideService:_moveWaterTo(runRevision: number, targetY: number): boolean
	if self._RunRevision ~= runRevision then
		return false
	end

	self:_cancelActiveAnimation()

	local water = self._Water :: Model
	local currentPivot = water:GetPivot()
	local distance = math.abs(targetY - currentPivot.Position.Y)
	if distance <= TideConfig.TARGET_TOLERANCE then
		self:_pivotWaterToY(targetY)
		return self._RunRevision == runRevision
	end

	local targetPosition = Vector3.new(currentPivot.Position.X, targetY, currentPivot.Position.Z)
	local targetPivot = CFrame.new(targetPosition) * currentPivot.Rotation
	local pivotValue = Instance.new("CFrameValue")
	pivotValue.Value = currentPivot

	local tween = TweenService:Create(
		pivotValue,
		TweenInfo.new(distance / TideConfig.WATER_SPEED, Enum.EasingStyle.Linear),
		{ Value = targetPivot }
	)
	local animation = {
		value = pivotValue,
		valueConnection = pivotValue:GetPropertyChangedSignal("Value"):Connect(function()
			water:PivotTo(pivotValue.Value)
		end),
		tween = tween,
	}
	self._ActiveAnimation = animation

	tween:Play()
	local playbackState = tween.Completed:Wait()

	if self._ActiveAnimation == animation then
		self._ActiveAnimation = nil
		animation.valueConnection:Disconnect()
		animation.value:Destroy()
	end

	if self._RunRevision ~= runRevision or playbackState ~= Enum.PlaybackState.Completed then
		return false
	end

	self:_pivotWaterToY(targetY)
	return true
end

function TideService:_publishPhase(
	runRevision: number,
	phase: TidePhase,
	duration: number?,
	gateRevealDelay: number?,
	lowTideEndsAt: number?,
	cycleEndsAt: number?
): boolean
	if self._RunRevision ~= runRevision then
		return false
	end

	local now = Workspace:GetServerTimeNow()
	self._StateRevision += 1
	local snapshot: TideSnapshot = {
		phase = phase,
		phaseStartedAt = now,
		phaseEndsAt = if duration then now + duration else nil,
		lowTideEndsAt = lowTideEndsAt,
		cycleEndsAt = cycleEndsAt,
		gateRevealAt = if gateRevealDelay then now + gateRevealDelay else nil,
		isPaused = self._IsPaused,
		revision = self._StateRevision,
	}
	self._Snapshot = snapshot
	self:_replicateSnapshot(snapshot)
	self.StateChangedServerEvent:Fire(table.clone(snapshot))
	if self._FrameworkReady then
		self.Client.StateChanged:FireAll(table.clone(snapshot))
	end
	return true
end

function TideService:_waitForDuration(runRevision: number, duration: number): boolean
	local deadline = Workspace:GetServerTimeNow() + duration
	while self._RunRevision == runRevision do
		local remaining = deadline - Workspace:GetServerTimeNow()
		if remaining <= 0 then
			return true
		end
		task.wait(math.min(remaining, 0.25))
	end
	return false
end

function TideService:_refreshDigItemsAfterHighTide(runRevision: number)
	while self._RunRevision == runRevision and not self._FrameworkReady do
		task.wait()
	end
	if self._RunRevision ~= runRevision then
		return
	end
	Knit.GetService("DigItemService"):RefreshAllZones()
end

function TideService:_runFullCycle(runRevision: number, fullPhaseAlreadyPublished: boolean?)
	while self._RunRevision == runRevision do
		local fullPhaseEndsAt: number
		if fullPhaseAlreadyPublished then
			local snapshot = self._Snapshot
			fullPhaseEndsAt = if snapshot and snapshot.phaseEndsAt
				then snapshot.phaseEndsAt
				else Workspace:GetServerTimeNow()
			fullPhaseAlreadyPublished = false
		else
			if not self:_publishPhase(
				runRevision,
				TideConfig.PHASE.FULL,
				TideConfig.FULL_DURATION,
				TideConfig.GATE_REVEAL_DELAY
			) then
				return
			end
			local snapshot = self._Snapshot
			fullPhaseEndsAt = if snapshot and snapshot.phaseEndsAt
				then snapshot.phaseEndsAt
				else Workspace:GetServerTimeNow()
		end
		local fullPhaseRemaining = math.max(0, fullPhaseEndsAt - Workspace:GetServerTimeNow())
		if not self:_waitForDuration(runRevision, fullPhaseRemaining) then
			return
		end

		local now = Workspace:GetServerTimeNow()
		local lowTideY = self:_getLowTideY()
		local highTideY = self:_getHighTideY()
		local lowTideEndsAt = now + self:_getTravelDuration(lowTideY) + TideConfig.LOW_DURATION
		local cycleEndsAt = lowTideEndsAt + self:_getTravelDurationBetween(lowTideY, highTideY)
		if not self:_publishPhase(runRevision, TideConfig.PHASE.RECEDING, nil, nil, lowTideEndsAt, cycleEndsAt) then
			return
		end
		if not self:_moveWaterTo(runRevision, self:_getLowTideY()) then
			return
		end

		if not self:_publishPhase(
			runRevision,
			TideConfig.PHASE.LOW,
			math.max(0, lowTideEndsAt - Workspace:GetServerTimeNow()),
			nil,
			lowTideEndsAt,
			cycleEndsAt
		) then
			return
		end
		if not self:_waitForDuration(runRevision, math.max(0, lowTideEndsAt - Workspace:GetServerTimeNow())) then
			return
		end

		if not self:_publishPhase(runRevision, TideConfig.PHASE.RISING, nil, nil, nil, cycleEndsAt) then
			return
		end
		if not self:_moveWaterTo(runRevision, self:_getHighTideY()) then
			return
		end
		self:_refreshDigItemsAfterHighTide(runRevision)
	end
end

function TideService:_startAtHighTide(runRevision: number, refreshWhenAlreadyHigh: boolean?)
	if not self:_isAtTarget(self:_getHighTideY()) then
		local cycleEndsAt = Workspace:GetServerTimeNow() + self:_getTravelDuration(self:_getHighTideY())
		if not self:_publishPhase(runRevision, TideConfig.PHASE.RISING, nil, nil, nil, cycleEndsAt) then
			return
		end
		if not self:_moveWaterTo(runRevision, self:_getHighTideY()) then
			return
		end
		self:_refreshDigItemsAfterHighTide(runRevision)
	elseif refreshWhenAlreadyHigh then
		self:_refreshDigItemsAfterHighTide(runRevision)
	end

	self:_runFullCycle(runRevision)
end

function TideService:_startAtLowTide(runRevision: number, lowPhaseDuration: number?)
	local lowDuration = lowPhaseDuration or TideConfig.LOW_DURATION
	local lowTideEndsAt: number
	local cycleEndsAt: number
	if not self:_isAtTarget(self:_getLowTideY()) then
		lowTideEndsAt = Workspace:GetServerTimeNow()
			+ self:_getTravelDuration(self:_getLowTideY())
			+ lowDuration
		cycleEndsAt = lowTideEndsAt + self:_getTravelDurationBetween(self:_getLowTideY(), self:_getHighTideY())
		if not self:_publishPhase(runRevision, TideConfig.PHASE.RECEDING, nil, nil, lowTideEndsAt, cycleEndsAt) then
			return
		end
		if not self:_moveWaterTo(runRevision, self:_getLowTideY()) then
			return
		end
	else
		lowTideEndsAt = Workspace:GetServerTimeNow() + lowDuration
		cycleEndsAt = lowTideEndsAt + self:_getTravelDurationBetween(self:_getLowTideY(), self:_getHighTideY())
	end

	if not self:_publishPhase(
		runRevision,
		TideConfig.PHASE.LOW,
		math.max(0, lowTideEndsAt - Workspace:GetServerTimeNow()),
		nil,
		lowTideEndsAt,
		cycleEndsAt
	) then
		return
	end
	if not self:_waitForDuration(runRevision, math.max(0, lowTideEndsAt - Workspace:GetServerTimeNow())) then
		return
	end
	if not self:_publishPhase(runRevision, TideConfig.PHASE.RISING, nil, nil, nil, cycleEndsAt) then
		return
	end
	if not self:_moveWaterTo(runRevision, self:_getHighTideY()) then
		return
	end
	self:_refreshDigItemsAfterHighTide(runRevision)

	self:_runFullCycle(runRevision)
end

function TideService:_pauseTide()
	if self._IsPaused then
		return
	end

	local snapshot = self._Snapshot
	if not snapshot then
		warn("TideService: cannot pause tide without a state snapshot")
		return
	end

	local phaseRemaining: number? = nil
	if snapshot.phase == TideConfig.PHASE.FULL or snapshot.phase == TideConfig.PHASE.LOW then
		phaseRemaining = math.max(0, (snapshot.phaseEndsAt or Workspace:GetServerTimeNow()) - Workspace:GetServerTimeNow())
	end

	self._RunRevision += 1
	local runRevision = self._RunRevision
	self:_cancelActiveAnimation()
	self._IsPaused = true
	self._PausedTide = {
		phase = snapshot.phase,
		phaseRemaining = phaseRemaining,
	}
	self:_publishPhase(runRevision, snapshot.phase, nil, nil, nil, nil)
end

function TideService:_resumeTide()
	local pausedTide = self._PausedTide
	if not self._IsPaused or not pausedTide then
		return
	end

	self._IsPaused = false
	self._PausedTide = nil
	self._RunRevision += 1
	local runRevision = self._RunRevision

	task.spawn(function()
		if pausedTide.phase == TideConfig.PHASE.FULL then
			if not self:_publishPhase(
				runRevision,
				TideConfig.PHASE.FULL,
				pausedTide.phaseRemaining or 0,
				TideConfig.GATE_REVEAL_DELAY,
				nil,
				nil
			) then
				return
			end
			self:_runFullCycle(runRevision, true)
		elseif pausedTide.phase == TideConfig.PHASE.RECEDING then
			self:_startAtLowTide(runRevision)
		elseif pausedTide.phase == TideConfig.PHASE.LOW then
			self:_startAtLowTide(runRevision, pausedTide.phaseRemaining or 0)
		elseif pausedTide.phase == TideConfig.PHASE.RISING then
			self:_startAtHighTide(runRevision, true)
		end
	end)
end

function TideService:TogglePause()
	if not RunService:IsStudio() then
		warn("TideService: ignored debug tide pause outside Studio")
		return
	end
	if not self._IsReady then
		warn("TideService: cannot pause tide before resources are ready")
		return
	end

	if self._IsPaused then
		self:_resumeTide()
	else
		self:_pauseTide()
	end
end

function TideService:ForceInstantTideTarget(target: string)
	if not RunService:IsStudio() then
		warn("TideService: ignored instant debug tide change outside Studio")
		return
	end
	if target ~= "High" and target ~= "Low" then
		warn("TideService: unsupported instant debug tide target", target)
		return
	end
	if not self._IsReady then
		warn("TideService: cannot change tide before resources are ready")
		return
	end

	self._IsPaused = false
	self._PausedTide = nil
	self._RunRevision += 1
	local runRevision = self._RunRevision
	self:_cancelActiveAnimation()
	task.spawn(function()
		if target == "High" then
			self:_pivotWaterToY(self:_getHighTideY())
			self:_refreshDigItemsAfterHighTide(runRevision)
			if self._RunRevision == runRevision then
				self:_runFullCycle(runRevision)
			end
		else
			self:_pivotWaterToY(self:_getLowTideY())
			self:_startAtLowTide(runRevision)
		end
	end)
end

function TideService:ForceTideTarget(target: string)
	if not RunService:IsStudio() then
		warn("TideService: ignored debug tide change outside Studio")
		return
	end
	if target ~= "High" and target ~= "Low" then
		warn("TideService: unsupported debug tide target", target)
		return
	end
	if not self._IsReady then
		warn("TideService: cannot change tide before resources are ready")
		return
	end

	self._IsPaused = false
	self._PausedTide = nil
	self._RunRevision += 1
	local runRevision = self._RunRevision
	self:_cancelActiveAnimation()
	task.spawn(function()
		if target == "High" then
			self:_startAtHighTide(runRevision)
		else
			self:_startAtLowTide(runRevision)
		end
	end)
end

function TideService:GetStateSnapshot(): TideSnapshot?
	local snapshot = self._Snapshot
	return if snapshot then table.clone(snapshot) else nil
end

function TideService.Client:GetStateSnapshot(_player: Player): TideSnapshot?
	return self.Server:GetStateSnapshot()
end

function TideService:BeginEarlyState()
	if self._EarlyStateStarted then
		return
	end

	local water, highTideMarker, lowTideZonePart = getResources()
	if not water or not highTideMarker or not lowTideZonePart then
		return
	end

	self._EarlyStateStarted = true
	self._Water = water
	self._HighTideMarker = highTideMarker
	self._LowTideZonePart = lowTideZonePart
	self._IsReady = true
	self._IsPaused = false
	self._PausedTide = nil
	self._RunRevision += 1
	local runRevision = self._RunRevision
	self:_pivotWaterToY(self:_getHighTideY())
	if not self:_publishPhase(
		runRevision,
		TideConfig.PHASE.FULL,
		TideConfig.FULL_DURATION,
		TideConfig.GATE_REVEAL_DELAY
	) then
		return
	end
	task.spawn(function()
		self:_runFullCycle(runRevision, true)
	end)
end

function TideService:KnitStart()
	self._FrameworkReady = true
	self:BeginEarlyState()

	local snapshot = self._Snapshot
	if snapshot then
		self.Client.StateChanged:FireAll(table.clone(snapshot))
	end
end

return TideService
