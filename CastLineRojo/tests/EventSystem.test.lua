local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local eventsData = read("src/ReplicatedFirst/Data/EventsData.lua")
local config = read("src/ReplicatedStorage/Modules/EventConfig.lua")
local stateUtil = read("src/ReplicatedStorage/Modules/EventStateUtil.lua")
local service = read("src/ServerScriptService/Services/EventService.lua")
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/EventController.lua")
local debugServer = read("src/ServerScriptService/EventDebug.server.lua")
local debugPanel = read("src/StarterPlayer/StarterPlayerScripts/TestDebugPanel.client.lua")

assert(eventsData:find("EffectValue: number", 1, true), "EventsData must expose EffectValue")
assert(eventsData:find("MutationId: string", 1, true), "EventsData must expose MutationId")
assert(config:find("SLOT_SECONDS = 15 * 60", 1, true), "Events must use quarter-hour slots")
assert(config:find("AUTO_SCHEDULE_ENABLED = false", 1, true), "Auto event scheduling must be temporarily disabled")
assert(service:find("not EventConfig.AUTO_SCHEDULE_ENABLED", 1, true), "EventService must skip auto scheduling when disabled")
assert(service:find("game.JobId", 1, true) and service:find("_Random = createServerRandom()", 1, true), "Each server must seed its own independent random generator")
assert(service:find("event.EventID ~= self._LastEventId", 1, true), "A server must exclude its previous event")
assert(service:find("self._LastEventId = event.EventID", 1, true), "An active event must become the server's previous event")
assert(not service:find("MemoryStoreService", 1, true), "Events must not be coordinated across servers")
assert(not service:find("MessagingService", 1, true), "Events must not be broadcast across servers")
assert(service:find("EventConfig.GetSlotIndex(timestamp)", 1, true), "Event state must derive from absolute quarter-hour slots")
assert(service:find("slotStartsAt + event.Duration", 1, true), "Event duration must come from EventsData")
assert(service:find("nextStartsAt = slotStartsAt + EventConfig.SLOT_SECONDS", 1, true), "Waiting state must target the next quarter hour")
assert(service:find("duration <= EventConfig.SLOT_SECONDS", 1, true), "Events longer than one slot must be rejected")
assert(service:find("function EventService:StartDebugEvent", 1, true), "EventService must expose a Studio debug event entry point")
assert(service:find("not RunService:IsStudio()", 1, true), "EventService must reject debug events outside Studio")
assert(service:find("self._DebugOverride = {", 1, true), "A debug event must publish an override snapshot")
assert(service:find("endsAt = now + event.Duration", 1, true), "A debug event must use its configured duration")
assert(service:find("self._DebugOverrideRevision", 1, true), "Replacing a debug event must invalidate the old expiry callback")
assert(service:find("task.delay(event.Duration", 1, true), "A debug event must clear itself when its configured duration expires")
assert(service:find("self:_evaluate(Workspace:GetServerTimeNow())", 1, true), "A finished debug event must resume natural scheduling")

assert(debugServer:find('REMOTE_NAME = "EventDebugRemote"', 1, true), "Event debug controls must use their own remote")
assert(debugServer:find("if not RunService:IsStudio() then", 1, true), "Event debug controls must be Studio-only")
assert(debugServer:find('typeof(eventId) ~= "string"', 1, true), "Event debug requests must validate the event id type")
assert(debugServer:find("EventService:StartDebugEvent(eventId)", 1, true), "Event debug requests must delegate to EventService")

for index = 1, 3 do
	local eventId = string.format("Event_%02d", index)
	local buttonName = "Start" .. eventId .. "Button"
	assert(debugPanel:find(buttonName, 1, true), "TestGui must bind " .. buttonName)
	assert(debugPanel:find('eventId = "' .. eventId .. '"', 1, true), "TestGui must map " .. buttonName .. " to " .. eventId)
end
assert(debugPanel:find("eventDebugRemote:FireServer(eventButton.eventId)", 1, true), "Event buttons must request their mapped event id")
assert(not eventsData:find("Event_04", 1, true), "Wind Weather must be removed from event data")
assert(not debugPanel:find("Event_04", 1, true), "Wind Weather must not have a debug binding")
assert(not eventsData:find("Event_05", 1, true), "The low-tide event must be removed from the event data")
assert(not debugPanel:find("Event_05", 1, true), "The low-tide event must not have a debug binding")

assert(stateUtil:find('normalized == "mutation"', 1, true), "Mutation event types must be normalized")
assert(not stateUtil:find('normalized == "movespeed"', 1, true), "MoveSpeed event types must be retired")
assert(stateUtil:find('normalized == "moreitem"', 1, true), "MoreItem event types must be normalized")


assert(controller:find('eventNameLabel.Text = "Next Event In"', 1, true), "Inactive UI must show Next Event In")
assert(controller:find("not EventConfig.AUTO_SCHEDULE_ENABLED", 1, true), "Event UI must hide when auto scheduling is disabled")
assert(controller:find("eventFrame.Visible = false", 1, true), "EventFrame must hide when auto scheduling is disabled and no event is active")
assert(controller:find('string.format("%02d:%02d"', 1, true), "Event UI must format MM:SS")
assert(controller:find("Workspace:GetServerTimeNow()", 1, true), "Client countdown must use synchronized absolute time")
assert(controller:find("originalWaterColors", 1, true), "Water colors must be restorable")
assert(not controller:find("Transparency =", 1, true), "Event water presentation must not change transparency")
assert(controller:find("RAINBOW_HUE_SPEED = 0.5", 1, true), "Rainbow water must use the AF hue speed")

print("EventSystem.test.lua passed")
