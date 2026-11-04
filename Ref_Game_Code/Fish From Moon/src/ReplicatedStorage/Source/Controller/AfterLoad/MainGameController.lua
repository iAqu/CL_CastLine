--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)

local MainGameService

local InputController
local SoundController

local MainGameController = Knit.CreateController { Name = "MainGameController" }

local function sendInfoToAllPlayer(player,landingPoint,isWin,fishType,newFish)
	InputController:sStartFishing(player,landingPoint,isWin,fishType,newFish)
end

local function soundFishSizeReward(player,soundName)
	if LocalPlayer == player then
		SoundController:PlaySoundOnce(soundName)
	end
end

function MainGameController:KnitInit()
	MainGameService = Knit.GetService("MainGameService")

	InputController = Knit.GetController("InputController")
	SoundController = Knit.GetController("SoundController")
end

function MainGameController:KnitStart()
	MainGameService.SendInfoToAllPlayer:Connect(sendInfoToAllPlayer)
	MainGameService.SoundFishSizeReward:Connect(soundFishSizeReward)
end

return MainGameController