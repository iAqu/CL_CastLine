local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local AMBIENT_SOUND_NAMES = { "BGM_1", "OceanSound" }

local MusicController = Knit.CreateController {
	Name = "MusicController",
	_FishingActive = false,
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
			end
		end
	end
end

function MusicController:StopAmbientSounds()
	local bgm = self._Bgm
	if bgm then
		bgm:Stop()
	end

	local oceanSound = self._OceanSound
	if oceanSound then
		oceanSound:Stop()
	end
end

function MusicController:ApplyNormalAmbientState()
	local bgm = self._Bgm
	if bgm and not bgm.IsPlaying then
		bgm:Play()
	end

	local oceanSound = self._OceanSound
	if oceanSound and self._FishingActive and not oceanSound.IsPlaying then
		oceanSound:Play()
	end
end

function MusicController:SetFishingActive(active: boolean)
	self._FishingActive = active
	self:RefreshAmbientAudio()
end

-- Transient cinematic mix; callers release only their own contribution.
function MusicController:SetCinematicDuck(source, amount)
	self._CinematicDucks = self._CinematicDucks or {}
	self._CinematicDucks[source] = amount
	local bgm = self._Bgm
	if not bgm then
		return
	end
	local multiplier = 1
	for _, value in pairs(self._CinematicDucks) do
		multiplier = math.min(multiplier, value)
	end
	self._UnduckedVolume = self._UnduckedVolume or bgm.Volume
	bgm.Volume = self._UnduckedVolume * multiplier
	if not next(self._CinematicDucks) then
		self._UnduckedVolume = nil
	end
end

function MusicController:RefreshAmbientAudio()
	self:ResolveAmbientSounds()
	if self._OceanSound and not self._FishingActive then
		self._OceanSound:Stop()
	end

	local playerData = PlayerDataController:GetData()
	if not playerData then
		warn("MusicController: no player data found")
		return
	end
	if playerData.Settings[Constants.SETTINGS_ID.MUSIC] == false then
		self:StopAmbientSounds()
		return
	end

	self:ApplyNormalAmbientState()
end

function MusicController:KnitInit()
	LogHelper.Print("MusicController initialized")
end

function MusicController:KnitStart()
	local settingsGuiController = Knit.GetController("SettingsGuiController")
	settingsGuiController.ToggleMusic:Connect(function()
		self:RefreshAmbientAudio()
	end)

	self:RefreshAmbientAudio()
end

return MusicController
