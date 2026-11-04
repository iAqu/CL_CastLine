local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local OverallSituation = require(ReplicatedStorage.OverallSituation.OverallSituation)
local AnimationPreloader = require(game.ReplicatedStorage.Source.Utils.AnimationPreloader)
local PlayerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))

local Control = PlayerModule:GetControls()

local animFolder=ReplicatedStorage.Assets.Animations
local RollVFXFloder=ReplicatedStorage.Assets.RollVFX

local frameUIG = script.Parent.Parent.Parent.ChargeBar.bar.UIGradient

local isKeyPressed = false
local direction = 1  -- 1 means shrinking (from 1 to 0), -1 means expanding (from 0 to 1)
local currentTween = nil
local currentSizeY = 1  -- Start size Y at 1

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local function VFXEnable(level)
	local vfx=RollVFXFloder:WaitForChild("vfxEnable"):Clone()
	vfx.Position=player.Character:WaitForChild("HumanoidRootPart").Position
	vfx.Parent=player.Character
	for k,v in pairs(vfx:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end
	return vfx
end
local function VFXDisEnable(vfx)
	for k,v in pairs(vfx:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
	for k,v in pairs(vfx.Attachment:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(tonumber(v:GetAttribute("EmitCount")))
		end
	end
end

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

-- Function to update the Y size of the frame smoothly
local function updateFrameSize()
	local targetSizeY = (direction == 1) and 0 or 1  -- Toggle between 0 and 1
	local targetSize = Vector2.new(0, targetSizeY)

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	-- If there's already a tween, cancel it before starting a new one
	if currentTween then
		currentTween:Cancel()
	end

	-- Create a new tween and play it
	currentTween = TweenService:Create(frameUIG, tweenInfo, {Offset = targetSize})
	currentTween:Play()
end

-- Function to handle the cycling of size
local function cycleSize()
	while isKeyPressed do
		updateFrameSize()  -- Update the frame size
		wait(1)  -- Wait for the tween to complete before reversing direction
		direction = direction * -1  -- Reverse direction (1 -> -1 or -1 -> 1)
	end
end

local function StartHold()
	if character:FindFirstChild("Tool_"..player.Name) then
	else
		local FishRodService = Knit.GetService("FishRodService")
		FishRodService:EquipBestFishRod()
	end
	if player:GetAttribute("FlyTime") then
		return
	end

	local vfx = VFXEnable(3)

	frameUIG.Parent.Parent.Visible = true

	direction = 1
	currentSizeY = 1
	frameUIG.Offset = Vector2.new(0,1)
	frameUIG.Parent.Parent.percentage.Text = "0%"
	faceFollowPart(Vector3.new(0,0,0))
	OverallSituation.ThrowCD = true
	--character:WaitForChild("Humanoid").WalkSpeed = 0
	Control:Disable()
	AnimationPreloader.PlayAnimation(animFolder.HoldPower)
	local SoundController = Knit.GetController("SoundController")
	SoundController:PlaySoundOnce("ChargedSound")

	cycleSize()

	VFXDisEnable(vfx)

	SoundController:StopSoundOnce("ChargedSound")
	AnimationPreloader.StopAnimation(animFolder.HoldPower)
	AnimationPreloader.PlayAnimation(animFolder.FreePower)
	SoundController:StopSoundOnce("RodThrowSound")

	if frameUIG.Offset.Y >= 0.85 then
		OverallSituation.ThrowCD = false
		--character:WaitForChild("Humanoid").WalkSpeed = 0
		Control:Enable()
		OverallSituation.BtnOnce = false
	else
		player:SetAttribute("FlyTime",true)
		local MainGameService = Knit.GetService("MainGameService")
		local YY = frameUIG.Offset.Y
		if player:GetAttribute("ThrowBuff") then
			workspace.PreThrowBuffPart:ClearAllChildren()
			YY = 0
		end
		MainGameService:FlyFishHook(YY)
	end
end

-- Listen for key input (E key press)
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if OverallSituation.ThrowCD then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
		if not player:GetAttribute("CanThrow") then
			local MainGuiController = Knit.GetController("MainGuiController")
			MainGuiController:ShowMessageEffect("warning",nil,"You need to be a little farther away to be able to cast the rod!")
			return
		end
		if not OverallSituation.BtnOnce  then
			OverallSituation.BtnOnce =true
			if not isKeyPressed then
				isKeyPressed = true
				StartHold()
			end
		end
	end
end)

-- Listen for key release (E key)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.E then
		isKeyPressed = false
		frameUIG.Parent.Parent.Visible = false
		if currentTween then
			currentTween:Cancel()
		end
	end
end)

local function evalColorSequence(sequence: ColorSequence, time: number)
	-- If time is 0 or 1, return the first or last value respectively
	if time == 0 then
		return sequence.Keypoints[1].Value
	elseif time == 1 then
		return sequence.Keypoints[#sequence.Keypoints].Value
	end
	for i = 1, #sequence.Keypoints - 1 do
		local thisKeypoint = sequence.Keypoints[i]
		local nextKeypoint = sequence.Keypoints[i + 1]
		if time >= thisKeypoint.Time and time < nextKeypoint.Time then
			local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time)
			return Color3.new(
				(nextKeypoint.Value.R - thisKeypoint.Value.R) * alpha + thisKeypoint.Value.R,
				(nextKeypoint.Value.G - thisKeypoint.Value.G) * alpha + thisKeypoint.Value.G,
				(nextKeypoint.Value.B - thisKeypoint.Value.B) * alpha + thisKeypoint.Value.B
			)
		end
	end
end

local cam = workspace.Camera

local Btn = script.Parent

Btn.MouseButton1Down:Connect(function()
	if not player:GetAttribute("CanThrow") then
		local MainGuiController = Knit.GetController("MainGuiController")
		MainGuiController:ShowMessageEffect("warning",nil,"You need to be a little farther away to be able to cast the rod!")
		return
	end
	if not OverallSituation.BtnOnce then
		OverallSituation.BtnOnce = true
		if not isKeyPressed then
			isKeyPressed = true
			StartHold()
		end
	end
end)
Btn.MouseButton1Up:Connect(function()
	isKeyPressed = false
	frameUIG.Parent.Parent.Visible = false
	if currentTween then
		currentTween:Cancel()
	end
end)

frameUIG:GetPropertyChangedSignal("Offset"):Connect(function()
	frameUIG.Parent.Parent.percentage.Text = 100 - math.floor(frameUIG.Offset.Y * 100) .. "%"
	local uiGradient = frameUIG.Parent.TextClo
	local colorSequence = uiGradient.Color

	frameUIG.Parent.Parent.percentage.TextColor3 = evalColorSequence(colorSequence, frameUIG.Offset.Y)

	cam.FieldOfView = 70 + (-0.5 + frameUIG.Offset.Y) * 5
end)

local BtnPhone = player.PlayerGui:WaitForChild("PhoneTouch").TextButton

local PhoneFirst = false

BtnPhone.MouseButton1Down:Connect(function()
	if not PhoneFirst then
		PhoneFirst = true
		return
	end
	if not player:GetAttribute("CanThrow") then
		local MainGuiController = Knit.GetController("MainGuiController")
		MainGuiController:ShowMessageEffect("warning",nil,"You need to be a little farther away to be able to cast the rod!")
		return
	end
	if not OverallSituation.BtnOnce then
		OverallSituation.BtnOnce = true
		if not isKeyPressed then
			isKeyPressed = true
			StartHold()
		end
	end
end)
BtnPhone.MouseButton1Up:Connect(function()
	isKeyPressed = false
	frameUIG.Parent.Parent.Visible = false
	if currentTween then
		currentTween:Cancel()
	end
end)