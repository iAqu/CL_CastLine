-- Service refs
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Module requires
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(Knit.Util.Trove)
local Timer = require(Knit.Util.Timer)

local PlayerBoostService

-- Variables
local player = Players.LocalPlayer

local BoostData
local PlayerData

local trove = Trove.new()

local BoostFrames = player.PlayerGui:WaitForChild("MainUi",5).MainHud.Boobm.BoostMenu

-- Module definition
local BoostHandleController = Knit.CreateController{
	Name = "BoostHandleController";
}

function AbbTime(p4)        -----时间格式
	local v1 = math.floor(p4 / 86400);
	if v1 > 0 then
		return v1 .. "d";
	end;
	local v2 = math.floor(p4 / 3600);
	if v2 > 0 then
		return v2 .. "h";
	end;
	local v3 = math.floor(p4 / 60);
	if v3 > 0 then
		return v3 .. "m";
	end;
	local v4 = math.floor(p4);
	if not (v4 > 0) then
		return "0s";
	end;
	return v4 .. "s";
end

function isPlayerHaveBoost(boostname)       -----是否拥有
	if BoostData[boostname]  then
		if (BoostData[boostname] - os.time())<0 then
			return false
		else
			return true
		end
	else
		return false
	end
end

function GetBoostLessTime(boostname)        ------剩余时间
	if BoostData[boostname] then
		if (BoostData[boostname] - os.time())<0 then
			return 0
		else
			return BoostData[boostname] - os.time()
		end
	else
		return 0
	end
end

function changeBoost(boostData)
	BoostData = boostData
	for i,v in pairs(BoostFrames:GetChildren()) do
		if v:IsA("ImageButton") and v.Name~="Premium" then
			if isPlayerHaveBoost(v.Name) then
				local lessTime = GetBoostLessTime(v.Name)
				v.Timer.Text = AbbTime(lessTime)
				v.Visible = true
			else
				v.Visible = false
			end
		end
	end
end

function refush()                  --------图片显示
	PlayerBoostService:GetPlayerBoostData():andThen(changeBoost)
end

function BoostHandleController:KnitInit()
	PlayerBoostService = Knit.GetService("PlayerBoostService")
end

function BoostHandleController:KnitStart()
	local timer = Timer.new(1)
	timer.Tick:Connect(function()
		refush()
	end)
	trove:Add(timer)
	timer:StartNow()
end

-- Return module
return BoostHandleController
