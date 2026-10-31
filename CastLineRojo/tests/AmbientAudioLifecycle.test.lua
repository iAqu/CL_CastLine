local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local musicController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/MusicController.lua")
local tideController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/TideController.lua")

assert(
	musicController:find('local AMBIENT_SOUND_NAMES = { "BGM_1", "OceanSound", "Alarm" }', 1, true),
	"MusicController must centrally manage BGM, ocean, and alarm sounds"
)
assert(
	musicController:find("sound.Looped = true", 1, true),
	"All managed ambient sounds must be forced to loop"
)
assert(
	musicController:find("self._OceanBaseVolume = sound.Volume", 1, true)
		and musicController:find("self._OceanBasePlaybackSpeed = sound.PlaybackSpeed", 1, true),
	"OceanSound must retain its Studio-configured normal volume and playback speed"
)
assert(
	musicController:find("oceanSound.Volume = self._OceanBaseVolume * 4", 1, true)
		and musicController:find("oceanSound.PlaybackSpeed = self._OceanBasePlaybackSpeed * 1.2", 1, true),
	"Danger audio must amplify OceanSound volume fourfold and playback speed to 1.2x"
)
assert(
	musicController:find("bgm:Pause()", 1, true)
		and musicController:find("bgm:Resume()", 1, true),
	"Danger transitions must pause and resume BGM instead of restarting it"
)
assert(
	musicController:find("alarm:Play()", 1, true)
		and musicController:find("alarm:Stop()", 1, true),
	"Alarm must play only while the danger state is active"
)
assert(
	musicController:find("function MusicController:StopAmbientSounds()", 1, true)
		and musicController:find("bgm:Stop()", 1, true)
		and musicController:find("oceanSound:Stop()", 1, true),
	"Disabling Music must stop BGM and OceanSound"
)
assert(
	musicController:find("if playerData.Settings[Constants.SETTINGS_ID.MUSIC] == false then", 1, true),
	"The Music setting must be the master switch for all ambient audio"
)
assert(
	musicController:find("tideController.ProximityWarningStateChanged:Connect", 1, true),
	"MusicController must receive TideController's proximity state rather than duplicate its condition"
)
assert(
	tideController:find("ProximityWarningStateChanged = Signal.new()", 1, true)
		and tideController:find("function TideController:IsRisingProximityWarningActive()", 1, true)
		and tideController:find("TideController.ProximityWarningStateChanged:Fire(isActive)", 1, true),
	"TideController must publish the proximity state used by the vignette and danger audio"
)
assert(
	musicController:find("self._TideController:IsRisingProximityWarningActive()", 1, true),
	"Danger audio must query the same proximity state when refreshing settings"
)

print("AmbientAudioLifecycle.test.lua passed")
