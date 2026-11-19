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
sounds.OceanSound.IsPlaying = true -- A Studio sound may already be playing when the controller starts.
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
assert(sounds.BGM_1.IsPlaying and not sounds.OceanSound.IsPlaying, "Only BGM may play before fishing starts")
assert(sounds.BGM_1.Looped and sounds.OceanSound.Looped, "Both ambient sounds must loop")
controller:RefreshAmbientAudio()
assert(sounds.OceanSound.playCount == 0, "Refreshing outside fishing must not start ocean audio")
controller:SetFishingActive(true)
assert(sounds.BGM_1.IsPlaying and sounds.OceanSound.IsPlaying, "Entering fishing must start ocean audio")
controller:SetFishingActive(true)
controller:RefreshAmbientAudio()
assert(sounds.BGM_1.playCount == 1 and sounds.OceanSound.playCount == 1, "Refreshing must not restart playing sounds")
playerData.Settings.Music = false
toggleMusic()
assert(not sounds.BGM_1.IsPlaying and not sounds.OceanSound.IsPlaying, "Disabling Music must stop both sounds")
playerData.Settings.Music = true
toggleMusic()
assert(sounds.BGM_1.IsPlaying and sounds.OceanSound.IsPlaying, "Re-enabling Music must restart both sounds")
assert(sounds.OceanSound.Volume == 0.3 and sounds.OceanSound.PlaybackSpeed == 0.8, "Ocean audio must retain the Studio volume and speed")
controller:SetFishingActive(false)
assert(sounds.BGM_1.IsPlaying and not sounds.OceanSound.IsPlaying, "Leaving fishing must stop only ocean audio")
playerData.Settings.Music = false
toggleMusic()
playerData.Settings.Music = true
toggleMusic()
assert(sounds.BGM_1.IsPlaying and not sounds.OceanSound.IsPlaying, "Enabling Music outside fishing must not start ocean audio")
playerData.Settings.Music = false
toggleMusic()
local oceanPlayCount = sounds.OceanSound.playCount
controller:SetFishingActive(true)
assert(not sounds.OceanSound.IsPlaying and sounds.OceanSound.playCount == oceanPlayCount, "Entering fishing with Music off must stay silent")
playerData.Settings.Music = true
toggleMusic()
assert(sounds.OceanSound.IsPlaying and sounds.OceanSound.playCount == oceanPlayCount + 1, "Re-entered fishing must resume ocean audio when Music is enabled")
assert(sounds.OceanSound.Volume == 0.3 and sounds.OceanSound.PlaybackSpeed == 0.8, "Fishing and settings changes must preserve Studio audio properties")
assert(warningCount == 0, "Valid audio must not produce missing-system warnings")

local originalVolume = sounds.BGM_1.Volume
local introSource, otherSource = {}, {}
controller:SetCinematicDuck(introSource, 0.25)
assert(sounds.BGM_1.Volume == originalVolume * 0.25)
controller:SetCinematicDuck(otherSource, 0.1)
controller:SetCinematicDuck(introSource, nil)
assert(sounds.BGM_1.Volume == originalVolume * 0.1, "Releasing an intro must preserve other audio owners")
controller:SetCinematicDuck(otherSource, nil)
assert(sounds.BGM_1.Volume == originalVolume, "Cinematic completion must restore the original mix")

playerData = nil
controller:SetFishingActive(false)
assert(not sounds.OceanSound.IsPlaying, "Leaving fishing must stop ocean audio even if player data is unavailable")
assert(warningCount == 1, "Unavailable player data must keep the existing warning")
playerData = { Settings = { Music = true } }
warningCount = 0
sounds.OceanSound = nil
controller:RefreshAmbientAudio()
controller:RefreshAmbientAudio()
assert(warningCount == 1, "Missing sounds must warn only once")

print("AmbientAudioLifecycle.test.lua passed")
