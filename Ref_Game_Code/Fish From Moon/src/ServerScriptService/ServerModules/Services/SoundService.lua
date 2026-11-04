--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local SoundServerService = game:GetService("SoundService")

local SoundService =
	Knit.CreateService {
		Name = "SoundService",
		Client = {
			PlayOneAwakeSound = Knit.CreateSignal()
		}
	}

--播放一次声音
function SoundService:PlayServiceOneAwakeSound(soundName)
	if not soundName then
		print("游戏声音不能为空")
	end
	SoundServerService:WaitForChild(soundName):Play()
end

--播放一次声音
function SoundService:PlayOneAwakeSound(player, soundName)
	if not soundName then
		print("游戏声音不能为空")
	end
	self.Client.PlayOneAwakeSound:Fire(player, soundName)
end

function SoundService:KnitStart()
end

function SoundService:KnitInit()
	
end

return SoundService
