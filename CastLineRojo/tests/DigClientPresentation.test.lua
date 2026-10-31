local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")
local service = read("src/ServerScriptService/Services/DigItemService.lua")

assert(service:find("task.wait(getDigInterval(reservation.player))", 1, true), "Server must retain authoritative dig cadence")
local digLoopStart = assert(service:find("function DigItemService:_runDigLoop", 1, true))
assert(service:find("Interval = getDigInterval", digLoopStart, true), "Dig steps must refresh the authoritative interval")
assert(service:find("currentHealth = math.max(0, currentHealth - power)", digLoopStart, true), "Only the server may deduct dig health")

assert(controller:find("digInterval: number", 1, true), "Client sessions must retain the authoritative interval")
assert(controller:find("local function startLocalDigPresentation", 1, true), "Client needs its own presentation clock")
assert(controller:find("if not playLocalDigPresentation(session) then", 1, true), "The first dig motion must play synchronously")
assert(controller:find("startLocalDigPresentation(session)", 1, true), "Accepted sessions must start local presentation immediately")
assert(controller:find("session.digTrack:Play(0.05, 1, session.digSpeedMultiplier)", 1, true), "Local ticks must play the dig animation")
assert(controller:find("session.mound:Progress(strength)", 1, true), "Local ticks must play mound effects")
assert(controller:find("session.silhouette:Kick(strength)", 1, true), "Local ticks must play silhouette impact")
assert(controller:find("session.digInterval = digInterval", 1, true), "Server steps must refresh the client interval")

local digStepStart = assert(controller:find("digItemService.DigStep:Connect", 1, true))
local digEndedStart = assert(controller:find("digItemService.DigEnded:Connect", digStepStart, true))
local digStepSection = controller:sub(digStepStart, digEndedStart - 1)
assert(digStepSection:find("applyHealthSnapshot", 1, true), "Server steps must reconcile authoritative health")
assert(not digStepSection:find("digTrack:Play", 1, true), "Server steps must not restart client-owned animation")
assert(not digStepSection:find("playDigCameraPunch", 1, true), "Server steps must not duplicate client impact presentation")
assert(not digStepSection:find("mound:Progress", 1, true), "Server steps must not duplicate client mound effects")
