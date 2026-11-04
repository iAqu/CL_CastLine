--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
-- Module requires
local AnimationPreloader = require(ReplicatedStorage.Source.Utils.AnimationPreloader)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(Knit.Util.Trove)
local Utility = require(Knit.Util.Utility)
local Timer = require(Knit.Util.Timer)

-- Variables
local player = Players.LocalPlayer
local playerGui = player.PlayerGui

local animFolder=ReplicatedStorage.Assets.Animations

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local trove = Trove.new()

local PlayerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local Control = PlayerModule:GetControls()

local UpgradesService
-- GUI
local frameUIG = playerGui:WaitForChild("MainUi",5).MainHud.BottomTool.ChargeBar.bar.UIGradient

local BtnAutoPlayer = playerGui:WaitForChild("MainUi",5).MainHud.BottomTool.menuout.Auto

-- Module definition
local AutoClickController = Knit.CreateController{
	Name = "AutoClickController";
}

local function faceFollowPart(targetPosition)
	if not targetPosition then
		warn("Target position is required")
		return
	end

	local direction = (targetPosition - hrp.Position)

	-- 防止零向量错误
	if direction.Magnitude == 0 then
		return
	end

	-- 计算新的面向方向（仅在水平面上）
	direction = Vector3.new(direction.X, 0, direction.Z).unit
	local newCFrame = CFrame.new(hrp.Position, hrp.Position + direction)

	-- 创建 Tween 动画
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out) -- 持续 1 秒
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = newCFrame})

	tween:Play()
end

local function AutoScale()
	frameUIG.Offset = Vector2.new(0,1)
	frameUIG.Parent.Parent.percentage.Text = "0%"
	faceFollowPart(Vector3.new(0,0,0))
	playerGui:WaitForChild("MainUi",5).MainHud.BottomTool.ChargeBar.Visible = true
	local targetSizeY = 1 - (0.8 + (math.random()/10))
	local targetSize = Vector2.new(0, targetSizeY)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

	local frameUIG = playerGui:WaitForChild("MainUi",5).MainHud.BottomTool.ChargeBar.bar.UIGradient
	TweenService:Create(frameUIG, tweenInfo, {Offset = targetSize}):Play()
	return targetSizeY
end
-- Module code
function AutoClickController:CheckAutoPlayer()

	trove:Clean()
	--if player:GetAttribute("FlyTime") then
	--	return
	--end
	print(player:GetAttribute("AutoPlayer"))
	player:SetAttribute("AutoPlayer",not player:GetAttribute("AutoPlayer"))

	print(player:GetAttribute("AutoPlayer"))
	if player:GetAttribute("AutoPlayer") then
		BtnAutoPlayer.Green.Enabled=true
		BtnAutoPlayer.UIGradient.Enabled=false
		local interval = 0.1
		if interval then
			local timer = Timer.new(interval)
			timer.Tick:Connect(function()
				if player:GetAttribute("FlyTime") then
					return
				end
				if character:FindFirstChild("Tool_"..player.Name) then
				else
					local FishRodService = Knit.GetService("FishRodService")
					FishRodService:EquipBestFishRod()
				end
				character:WaitForChild("Humanoid").WalkSpeed = 0
				Control:Disable()
				player:SetAttribute("FlyTime",true)
				task.wait(1)
				AnimationPreloader.PlayAnimation(animFolder.HoldPower)
				local returnY = AutoScale()
				task.wait(0.6)
				AnimationPreloader.StopAnimation(animFolder.HoldPower)
				AnimationPreloader.PlayAnimation(animFolder.FreePower)
				playerGui:WaitForChild("MainUi",5).MainHud.BottomTool.ChargeBar.Visible = false
				local MainGameService = Knit.GetService("MainGameService")
				MainGameService:FlyFishHook(returnY)
			end)
			trove:Add(timer)
			timer:StartNow()
		end
	else
		BtnAutoPlayer.Green.Enabled=false
		BtnAutoPlayer.UIGradient.Enabled=true
	end
end

function AutoClickController:KnitInit()
	UpgradesService = Knit.GetService("UpgradesService")
end

function AutoClickController:KnitStart()
	BtnAutoPlayer.MouseButton1Click:Connect(function()
		self:CheckAutoPlayer()
	end)
end

-- Return module
return AutoClickController
