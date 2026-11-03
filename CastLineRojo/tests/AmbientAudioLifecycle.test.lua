local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/MusicController.lua", "r"))
local source = file:read("*a")
file:close()

local function sound(volume, speed)
	return {
		Volume = volume,
		PlaybackSpeed = speed,
		IsPlaying = false,
		playCount = 0,
		IsA = function(_, className) return className == "Sound" end,
		Play = function(self)
			self.IsPlaying = true
			self.playCount += 1
		end,
		Stop = function(self) self.IsPlaying = false end,
	}
end

local sounds = { BGM_1 = sound(0.4, 1), OceanSound = sound(0.3, 0.8) }
local playerData = { Settings = { Music = true } }
local toggleMusic
local warningCount = 0
local modules = {
	Knit = {
		CreateController = function(controller) return controller end,
		GetController = function(name)
			assert(name == "SettingsGuiController", "Audio must only depend on the settings controller")
			return { ToggleMusic = { Connect = function(_, callback) toggleMusic = callback end } }
		end,
	},
	PlayerDataController = { GetData = function() return playerData end },
	Constants = { SETTINGS_ID = { MUSIC = "Music" } },
	LogHelper = { Print = function() end },
}
local services = {
	ReplicatedStorage = { Packages = { Knit = "Knit" }, Modules = { Constants = "Constants", LogHelper = "LogHelper" } },
	StarterPlayer = { StarterPlayerScripts = { Controllers = { PlayerDataController = "PlayerDataController" } } },
	SoundService = { FindFirstChild = function(_, name)
		assert(name ~= "Alarm", "Audio must not look up the removed alarm")
		return sounds[name]
	end },
}
local chunk = assert(loadstring(source, "MusicController"))
setfenv(chunk, setmetatable({
	game = { GetService = function(_, name) return assert(services[name]) end },
	require = function(name) return assert(modules[name]) end,
	warn = function() warningCount += 1 end,
}, { __index = getfenv() }))
local controller = chunk()
controller:KnitStart()
assert(toggleMusic, "Music setting changes must be connected")
assert(sounds.BGM_1.IsPlaying and sounds.OceanSound.IsPlaying, "Enabled audio must play both ambient sounds")
assert(sounds.BGM_1.Looped and sounds.OceanSound.Looped, "Both ambient sounds must loop")
controller:RefreshAmbientAudio()
assert(sounds.BGM_1.playCount == 1 and sounds.OceanSound.playCount == 1, "Refreshing must not restart playing sounds")
playerData.Settings.Music = false
toggleMusic()
assert(not sounds.BGM_1.IsPlaying and not sounds.OceanSound.IsPlaying, "Disabling Music must stop both sounds")
playerData.Settings.Music = true
toggleMusic()
assert(sounds.BGM_1.IsPlaying and sounds.OceanSound.IsPlaying, "Re-enabling Music must restart both sounds")
assert(sounds.OceanSound.Volume == 0.3 and sounds.OceanSound.PlaybackSpeed == 0.8, "Ocean audio must retain the Studio volume and speed")
assert(warningCount == 0, "Valid audio must not produce missing-system warnings")

sounds.OceanSound = nil
controller:RefreshAmbientAudio()
controller:RefreshAmbientAudio()
assert(warningCount == 1, "Missing sounds must warn only once")

print("AmbientAudioLifecycle.test.lua passed")
