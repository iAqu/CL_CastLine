local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local EventsData = require(ReplicatedFirst.Data.EventsData)
local EventConfig = require(ReplicatedStorage.Modules.EventConfig)
local EventStateUtil = require(ReplicatedStorage.Modules.EventStateUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local Signal = require(ReplicatedStorage.Packages.Signal)

export type EventSnapshot = {
	phase: string,
	eventId: string?,
	startedAt: number?,
	endsAt: number?,
	nextStartsAt: number,
	revision: number,
}

local function createServerRandom(): Random
	local seed = DateTime.now().UnixTimestampMillis % 2147483647
	for index = 1, #game.JobId do
		seed = (seed * 31 + string.byte(game.JobId, index)) % 2147483647
	end
	return Random.new(seed)
end

local EventService = Knit.CreateService({
	Name = "EventService",
	Client = {},
	StateChangedServerEvent = Signal.new(),
	_Random = createServerRandom(),
	_Events = {},
	_LastEventId = nil :: string?,
	_SlotIndex = nil :: number?,
	_SlotEvent = nil,
	_Snapshot = nil :: EventSnapshot?,
	_StateFolder = nil :: Folder?,
	_StateRevision = 0,
	_EarlyStateStarted = false,
	_DebugOverride = nil :: EventSnapshot?,
	_DebugOverrideRevision = 0,
})

local function isFiniteNumber(value: unknown): boolean
	return typeof(value) == "number"
		and value == value
		and value ~= math.huge
		and value ~= -math.huge
end

local function sameSnapshot(left: EventSnapshot?, right: EventSnapshot): boolean
	return left ~= nil
		and left.phase == right.phase
		and left.eventId == right.eventId
		and left.startedAt == right.startedAt
		and left.endsAt == right.endsAt
		and left.nextStartsAt == right.nextStartsAt
end

function EventService:_loadEvents()
	local validEvents = {}
	for key, event in pairs(EventsData) do
		local eventId = event.EventID
		local eventType = EventStateUtil.NormalizeEventType(event.EventType)
		local duration = event.Duration
		local effectValue = event.EffectValue
		local mutationId = MutationDataUtil.NormalizeMutationId(event.MutationId)
		local valid = typeof(eventId) == "string"
			and eventId ~= ""
			and typeof(event.DisplayName) == "string"
			and event.DisplayName ~= ""
			and isFiniteNumber(event.Index)
			and isFiniteNumber(duration)
			and duration >= 1
			and duration <= EventConfig.SLOT_SECONDS
			and isFiniteNumber(effectValue)
			and effectValue >= 0
			and eventType ~= nil
		if eventType == "mutation" then
			valid = valid and mutationId ~= nil and effectValue <= 1
		end
		if valid then
			table.insert(validEvents, event)
		else
			warn("EventService: ignoring invalid EventsData row", tostring(key))
		end
	end
	table.sort(validEvents, function(left, right)
		if left.Index ~= right.Index then
			return left.Index < right.Index
		end
		return left.EventID < right.EventID
	end)
	self._Events = validEvents
	if #validEvents == 1 then
		warn("EventService: only one valid event is configured; consecutive repeats are unavoidable")
	elseif #validEvents == 0 then
		warn("EventService: no valid event is configured")
	end
end

function EventService:_getStateFolder(): Folder
	local stateFolder = self._StateFolder
	if stateFolder and stateFolder.Parent then
		return stateFolder
	end
	local existing = ReplicatedStorage:FindFirstChild(EventConfig.STATE_FOLDER_NAME)
	if existing and existing:IsA("Folder") then
		stateFolder = existing
	else
		if existing then
			existing:Destroy()
			warn("EventService: replaced non-Folder ReplicatedStorage.EventState")
		end
		stateFolder = Instance.new("Folder")
		stateFolder.Name = EventConfig.STATE_FOLDER_NAME
		stateFolder.Parent = ReplicatedStorage
	end
	self._StateFolder = stateFolder
	return stateFolder
end

function EventService:_chooseEvent()
	if #self._Events == 0 then
		return nil
	end
	local candidates = {}
	for _, event in self._Events do
		if #self._Events == 1 or event.EventID ~= self._LastEventId then
			table.insert(candidates, event)
		end
	end
	return candidates[self._Random:NextInteger(1, #candidates)]
end

function EventService:_publish(snapshot: EventSnapshot)
	if sameSnapshot(self._Snapshot, snapshot) then
		return
	end
	self._StateRevision += 1
	snapshot.revision = self._StateRevision
	self._Snapshot = snapshot

	local stateFolder = self:_getStateFolder()
	local attributes = EventConfig.STATE_ATTRIBUTE
	stateFolder:SetAttribute(attributes.PHASE, snapshot.phase)
	stateFolder:SetAttribute(attributes.EVENT_ID, snapshot.eventId or "")
	stateFolder:SetAttribute(attributes.STARTED_AT, snapshot.startedAt or 0)
	stateFolder:SetAttribute(attributes.ENDS_AT, snapshot.endsAt or 0)
	stateFolder:SetAttribute(attributes.NEXT_STARTS_AT, snapshot.nextStartsAt)
	-- Revision is the commit marker for the preceding attribute writes.
	stateFolder:SetAttribute(attributes.REVISION, snapshot.revision)
	self.StateChangedServerEvent:Fire(table.clone(snapshot))
end

function EventService:_evaluate(timestamp: number): number
	local debugOverride = self._DebugOverride
	if debugOverride then
		if debugOverride.endsAt and timestamp < debugOverride.endsAt then
			self:_publish(table.clone(debugOverride))
			return debugOverride.endsAt
		end
		self._DebugOverride = nil
	end

	if not EventConfig.AUTO_SCHEDULE_ENABLED then
		local slotIndex = EventConfig.GetSlotIndex(timestamp)
		local nextStartsAt = EventConfig.GetSlotStartsAt(slotIndex) + EventConfig.SLOT_SECONDS
		self:_publish({
			phase = EventConfig.PHASE.WAITING,
			eventId = nil,
			startedAt = nil,
			endsAt = nil,
			nextStartsAt = nextStartsAt,
			revision = 0,
		})
		return nextStartsAt
	end

	local slotIndex = EventConfig.GetSlotIndex(timestamp)
	local slotStartsAt = EventConfig.GetSlotStartsAt(slotIndex)
	local nextStartsAt = slotStartsAt + EventConfig.SLOT_SECONDS
	if self._SlotIndex ~= slotIndex then
		self._SlotIndex = slotIndex
		self._SlotEvent = self:_chooseEvent()
	end

	local event = self._SlotEvent
	local endsAt = event and (slotStartsAt + event.Duration) or nil
	if event and endsAt and timestamp < endsAt then
		self._LastEventId = event.EventID
		self:_publish({
			phase = EventConfig.PHASE.ACTIVE,
			eventId = event.EventID,
			startedAt = slotStartsAt,
			endsAt = endsAt,
			nextStartsAt = nextStartsAt,
			revision = 0,
		})
		return endsAt
	end

	self:_publish({
		phase = EventConfig.PHASE.WAITING,
		eventId = nil,
		startedAt = nil,
		endsAt = nil,
		nextStartsAt = nextStartsAt,
		revision = 0,
	})
	return nextStartsAt
end

function EventService:StartDebugEvent(eventId: string): boolean
	if not RunService:IsStudio() or typeof(eventId) ~= "string" then
		return false
	end

	self:BeginEarlyState()
	local event = nil
	for _, configuredEvent in self._Events do
		if configuredEvent.EventID == eventId then
			event = configuredEvent
			break
		end
	end
	if not event then
		return false
	end

	local now = Workspace:GetServerTimeNow()
	local slotIndex = EventConfig.GetSlotIndex(now)
	local endsAt = now + event.Duration
	self._DebugOverrideRevision += 1
	self._DebugOverride = {
		phase = EventConfig.PHASE.ACTIVE,
		eventId = event.EventID,
		startedAt = now,
		endsAt = endsAt,
		nextStartsAt = EventConfig.GetSlotStartsAt(slotIndex) + EventConfig.SLOT_SECONDS,
		revision = 0,
	}
	self._LastEventId = event.EventID
	self:_publish(table.clone(self._DebugOverride))

	local overrideRevision = self._DebugOverrideRevision
	task.delay(event.Duration, function()
		if self._DebugOverrideRevision ~= overrideRevision then
			return
		end
		self._DebugOverride = nil
		self:_evaluate(Workspace:GetServerTimeNow())
	end)

	return true
end

function EventService:BeginEarlyState()
	if self._EarlyStateStarted then
		return
	end
	self._EarlyStateStarted = true
	self:_loadEvents()
	self:_evaluate(Workspace:GetServerTimeNow())
end

function EventService:GetActiveEvent()
	local now = Workspace:GetServerTimeNow()
	local slotIndex = EventConfig.GetSlotIndex(now)
	local currentSnapshot = self._Snapshot
	if self._SlotIndex ~= slotIndex
		or (currentSnapshot and currentSnapshot.endsAt and currentSnapshot.endsAt <= now)
	then
		self:_evaluate(now)
	end
	local snapshot = self._Snapshot
	if not snapshot
		or snapshot.phase ~= EventConfig.PHASE.ACTIVE
		or not snapshot.eventId
		or not snapshot.endsAt
		or snapshot.endsAt <= now
	then
		return nil
	end
	return EventsData[snapshot.eventId]
end

function EventService:GetActiveItemEffect()
	local event = self:GetActiveEvent()
	local eventType = event and EventStateUtil.NormalizeEventType(event.EventType) or nil
	return if eventType == "mutation" or eventType == "moreitem" then event else nil
end

function EventService:GetMoveSpeedMultiplier(): number
	local event = self:GetActiveEvent()
	if not event or EventStateUtil.NormalizeEventType(event.EventType) ~= "movespeed" then
		return 1
	end
	return 1 + math.max(0, tonumber(event.EffectValue) or 0)
end

function EventService:KnitInit()
	self:BeginEarlyState()
end

function EventService:KnitStart()
	task.spawn(function()
		while true do
			local deadline = self:_evaluate(Workspace:GetServerTimeNow())
			local remaining = deadline - Workspace:GetServerTimeNow()
			task.wait(math.max(0.05, remaining))
		end
	end)
end

return EventService
