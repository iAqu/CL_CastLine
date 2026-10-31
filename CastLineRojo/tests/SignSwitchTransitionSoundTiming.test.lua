local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local transition = read("src/ReplicatedStorage/Modules/SignSwitchTransitionUtil.lua")
local playStart = assert(transition:find("function SignSwitchTransitionUtil.Play", 1, true))
local soundStart = assert(transition:find("SoundHelper.PlaySound(Constants.SoundRes.GUI_FUSE_SUCCESS)", playStart, true))
local highlightStart = assert(transition:find("WhiteFlashOverlayUtil.CreateHighlight(oldSign)", playStart, true))
local finishRevealStart = assert(transition:find("local function finishReveal", 1, true))
local runCoveredPhaseStart = assert(transition:find("local function runCoveredPhase", finishRevealStart, true))
local finishReveal = transition:sub(finishRevealStart, runCoveredPhaseStart - 1)

assert(
	soundStart < highlightStart,
	"The zone-sign switch sound must start before the old-sign white fade begins"
)

assert(
	not finishReveal:find("GUI_FUSE_SUCCESS", 1, true),
	"The zone-sign switch sound must not replay during finishReveal"
)

print("SignSwitchTransitionSoundTiming.test.lua passed")
