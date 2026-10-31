local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local AMBIENT_SOUND_NAMES = { "BGM_1", "OceanSound", "Alarm" }

local MusicController = Knit.CreateController {
	Name = "MusicController",
	_BgmPausedForDanger = false,
	_MissingSoundWarnings = {},
}

local function findAmbientSound(soundName: string, warnedMissingSounds: { [string]: boolean }): Sound?
	local sound = SoundService:FindFirstChild(soundName)
	if not sound then
		if not warnedMissingSounds[soundName] then
			warnedMissingSounds[soundName] = true
			warn("MusicController: SoundService." .. soundName .. " is missing")
		end
		return nil
	end
	if not sound:IsA("Sound") then
		if not warnedMissingSounds[soundName] then
			warnedMissingSounds[soundName] = true
			warn("MusicController: SoundService." .. soundName .. " must be a Sound")
		end
		return nil
	end

	warnedMissingSounds[soundName] = nil
	return sound
end

function MusicController:ResolveAmbientSounds()
	for _, soundName in ipairs(AMBIENT_SOUND_NAMES) do
		local sound = findAmbientSound(soundName, self._MissingSoundWarnings)
		if sound then
			sound.Looped = true
			if soundName == "BGM_1" then
				self._Bgm = sound
			elseif soundName == "OceanSound" then
				self._OceanSound = sound
				if self._OceanBaseVolume == nil then
					self._OceanBaseVolume = sound.Volume
					self._OceanBasePlaybackSpeed = sound.PlaybackSpeed
				end
			elseif soundName == "Alarm" then
				self._Alarm = sound
			end
		end
	end
end

function MusicController:RestoreOceanSound()
	local oceanSound = self._OceanSound
	if not oceanSound then
		return
	end
	if self._OceanBaseVolume ~= nil then
		oceanSound.Volume = self._OceanBaseVolume
	end
	if self._OceanBasePlaybackSpeed ~= nil then
		oceanSound.PlaybackSpeed = self._OceanBasePlaybackSpeed
	end
end

function MusicController:StopAmbientSounds()
	local bgm = self._Bgm
	if bgm then
		bgm:Stop()
	end

	local oceanSound = self._OceanSound
	if oceanSound then
		self:RestoreOceanSound()
		oceanSound:Stop()
	end

	local alarm = self._Alarm
	if alarm then
		alarm:Stop()
	end

	self._BgmPausedForDanger = false
end

function MusicController:ApplyNormalAmbientState()
	local bgm = self._Bgm
	if bgm then
		if self._BgmPausedForDanger then
			bgm:Resume()
		elseif not bgm.IsPlaying then
			bgm:Play()
		end
	end
	self._BgmPausedForDanger = false

	local oceanSound = self._OceanSound
	if oceanSound then
		self:RestoreOceanSound()
		if not oceanSound.IsPlaying then
			oceanSound:Play()
		end
	end

	local alarm = self._Alarm
	if alarm then
		alarm:Stop()
	end
end

function MusicController:ApplyDangerAmbientState()
	local bgm = self._Bgm
	if bgm and bgm.IsPlaying then
		bgm:Pause()
		self._BgmPausedForDanger = true
	end

	local oceanSound = self._OceanSound
	if oceanSound then
		if self._OceanBaseVolume ~= nil then
			oceanSound.Volume = self._OceanBaseVolume * 4
		end
		if self._OceanBasePlaybackSpeed ~= nil then
			oceanSound.PlaybackSpeed = self._OceanBasePlaybackSpeed * 1.2
		end
		if not oceanSound.IsPlaying then
			oceanSound:Play()
		end
	end

	local alarm = self._Alarm
	if alarm and not alarm.IsPlaying then
		alarm:Play()
	end
end

function MusicController:RefreshAmbientAudio()
	self:ResolveAmbientSounds()

	local playerData = PlayerDataController:GetData()
	if not playerData then
		warn("MusicController: no player data found")
		return
	end
	if playerData.Settings[Constants.SETTINGS_ID.MUSIC] == false then
		self:StopAmbientSounds()
		return
	end

	if self._TideController:IsRisingProximityWarningActive() then
		self:ApplyDangerAmbientState()
	else
		self:ApplyNormalAmbientState()
	end
end

function MusicController:KnitInit()
	LogHelper.Print("MusicController initialized")
end

function MusicController:KnitStart()
	local tideController = Knit.GetController("TideController")
	self._TideController = tideController
	tideController.ProximityWarningStateChanged:Connect(function()
		self:RefreshAmbientAudio()
	end)

	local settingsGuiController = Knit.GetController("SettingsGuiController")
	settingsGuiController.ToggleMusic:Connect(function()
		self:RefreshAmbientAudio()
	end)

	self:RefreshAmbientAudio()
end

return MusicController
