local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local character = player.Character
local lastCanThrow = nil
local updateInterval = 0.1
local lastUpdateTime = tick()
--GUI
local BottomToolUI = player.PlayerGui:WaitForChild("MainUi").MainHud.BottomTool

local CommonGuiController = Knit.CreateController {Name = "CommonGuiController"}

function CommonGuiController:ShowThrowUI()
	BottomToolUI.Visible = true
	player:SetAttribute("CanThrow",true)
end

function CommonGuiController:HideThrowUI()
	BottomToolUI.Visible = false
	player:SetAttribute("CanThrow",false)
end

local function checkZPosition()
	if character and character.PrimaryPart then
		local currentZ = character.PrimaryPart.Position.Z
		local newCanThrow = currentZ >= 30  -- 只在 Z 轴是否 >= 30 时切换状态

		if newCanThrow ~= lastCanThrow then
			-- 只有状态变化时才更新
			player:SetAttribute("CanThrow", newCanThrow)
			if newCanThrow then
				local CommonGuiController = Knit.GetController("CommonGuiController")
				CommonGuiController:ShowThrowUI()
			else
				local CommonGuiController = Knit.GetController("CommonGuiController")
				CommonGuiController:HideThrowUI()
			end
			lastCanThrow = newCanThrow
		end
	end
end

function CommonGuiController:KnitInit()
end

function CommonGuiController:KnitStart()
	RunService.Heartbeat:Connect(function()
		if tick() - lastUpdateTime >= updateInterval then
			checkZPosition()
			lastUpdateTime = tick()
		end
	end)
end

return CommonGuiController