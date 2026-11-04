----获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer      
-- Module requires
local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool=require(ReplicatedStorage.Source.Utils.Tool)
local NumberFormat= require(ReplicatedStorage.Source.Utils.NumberFormat)

local Trove = require(Knit.Util.Trove)
local Timer = require(Knit.Util.Timer)

local trove = Trove.new()

local WinsBest=workspace.Rank.Wins.SurfaceGui.Frame.Frame.bottom.Number.TextLabel
local GemsBest=workspace.Rank.Gems.SurfaceGui.Frame.Frame.bottom.Number.TextLabel
local FishBest=workspace.Rank.Fish.SurfaceGui.Frame.Frame.bottom.Number.TextLabel

-- Module definition
local LeaderBoardUpdateController = Knit.CreateController{
	Name = "LeaderBoardUpdateController";
}
function refush()
	local PlayerResourceService = Knit.GetService("PlayerResourceService")
	local function ShowData(playerResourceData)
		WinsBest.Text=NumberFormat.AbbreviateNumber(playerResourceData.sumMoneys)
		GemsBest.Text=NumberFormat.AbbreviateNumber(playerResourceData.sumGems)
		FishBest.Text=NumberFormat.AbbreviateNumber(playerResourceData.sumFish)
	end
	PlayerResourceService:GetPlayerResourceData(player):andThen(ShowData)
end

function LeaderBoardUpdateController:KnitInit()
end

function LeaderBoardUpdateController:KnitStart()
	local timer = Timer.new(5)
	timer.Tick:Connect(function()
		refush()
	end)
	trove:Add(timer)
	timer:StartNow()
end

-- Return module
return LeaderBoardUpdateController
