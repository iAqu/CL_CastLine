local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")
local showcase = assert(
	controller:match("local function playFinishedDigSession.-\nend\n\nlocal function startDigSession"),
	"DigController must retain a final showcase flow before starting the next dig"
)
local cleanup = assert(
	controller:match("local function cleanupShowcaseSession.-\nend\n\nlocal function cleanupAllShowcaseSessions"),
	"DigController must retain dedicated showcase cleanup"
)

assert(
	controller:find("local showcasingSessions: { [ActiveSession]: boolean } = {}", 1, true),
	"Completed showcases must be tracked separately from the active dig"
)
assert(
	controller:find("local function beginShowcaseSession", 1, true),
	"Showcases need a dedicated lifecycle entry point"
)
assert(
	controller:find("local function cleanupAllShowcaseSessions", 1, true),
	"Character resets must clean up outstanding showcases"
)

local showcaseStarted = assert(showcase:find("beginShowcaseSession(session)", 1, true))
local digReleased = assert(showcase:find("activeSession = nil", showcaseStarted, true))
local promptRefreshed = assert(showcase:find("refreshNearestDigPrompt()", digReleased, true))
local delayedCleanup = assert(showcase:find("task.delay(SHOWCASE_DURATION", 1, true))
assert(showcaseStarted < digReleased, "The completed dig must become a showcase before releasing the dig lock")
assert(digReleased < promptRefreshed, "Releasing the dig lock must immediately refresh the next prompt")
assert(promptRefreshed < delayedCleanup, "The next dig prompt must be available before the showcase finishes")

assert(
	not cleanup:find("activeSession = nil", 1, true),
	"An older showcase must never clear a newer active dig session"
)
assert(
	not cleanup:find("humanoid.WalkSpeed", 1, true),
	"An older showcase must not restore the movement state of a newer dig"
)
assert(
	not cleanup:find("stopDigCameraPunch()", 1, true),
	"An older showcase must not stop the camera feedback of a newer dig"
)
assert(
	cleanup:find("if next(showcasingSessions) == nil then", 1, true),
	"Showcase FOV must remain active until the last concurrent showcase finishes"
)

print("DigShowcaseConcurrency.test.lua passed")
