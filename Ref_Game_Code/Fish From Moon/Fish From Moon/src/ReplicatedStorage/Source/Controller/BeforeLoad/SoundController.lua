--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundServerService = game:GetService("SoundService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local SoundService

local player = game:GetService("Players").LocalPlayer
local playerGui = player.PlayerGui

local SoundController = Knit.CreateController {Name = "SoundController"}

--播放一次声音
local function PlayOneAwakeSound(soundName)
	if not soundName then
		error("游戏声音不能为空")
		return
	end
	SoundServerService:WaitForChild(soundName):Play()
end

--暂停一次声音
local function StopOneAwakeSound(soundName)
	if not soundName then
		error("游戏声音不能为空")
		return
	end
	SoundServerService:WaitForChild(soundName):Stop()
end

function SoundController:PlaySoundOnce(soundName)
	PlayOneAwakeSound(soundName)
end

function SoundController:StopSoundOnce(soundName)
	StopOneAwakeSound(soundName)
end

function SoundController:KnitInit()
	SoundService = Knit.GetService("SoundService")
end
function SoundController:KnitStart()
	SoundService.PlayOneAwakeSound:Connect(PlayOneAwakeSound)
end

return SoundController
