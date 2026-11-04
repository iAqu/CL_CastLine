-- Service refs
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer=Players.LocalPlayer
-- Module requires
local PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local AnimationPreloader = require(game.ReplicatedStorage.Source.Utils.AnimationPreloader)
local FishRodEnchantHelper = require(game.ReplicatedStorage.Config.FishRodEnchantHelper)
local OverallSituation = require(ReplicatedStorage.OverallSituation.OverallSituation)
local UpgradesHelper = require(game.ReplicatedStorage.Config.UpgradesHelper)
local FishHelper = require(game.ReplicatedStorage.Config.FishHelper)
local AnimModule = require(game.ReplicatedStorage.Utils.AnimModule)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Input = require(Knit.Util.Input)

local Keyboard = Input.Keyboard
local Touch = Input.Touch
local Gamepad = Input.Gamepad

local Control = PlayerModule:GetControls()

local UpgradesService
local MainGameService

local SoundController
local FishIndexController
-- Constants

local animFolder=ReplicatedStorage.Assets.Animations

-- Module definition
local InputController = Knit.CreateController{
	Name = "InputController";
}

local MakeFishAnimCd = tick()

--记者
local PhotoConn
-- 设置路径节点
local nodes = {
	Vector3.new(0, 0, 0),
	Vector3.new(0, 0, 220),
	Vector3.new(0, 0, 420),
	Vector3.new(0, 0, 620),
}
local reachedNodes = {}

local function CameraLight(mo:Model)
	SoundController:PlaySoundOnce("CameraPhoto")
	for k,v in pairs(mo:GetDescendants()) do
		if v:IsA("Beam") then
			v.Enabled = true
		end
		if v:IsA("ParticleEmitter") then
			local EMIT_AMOUNT= v:GetAttribute("EmitCount")
			v:Emit(EMIT_AMOUNT)
		end
	end
	task.spawn(function()
		task.wait(1)
		for k,v in pairs(mo:GetDescendants()) do
			if v:IsA("Beam") then
				v.Enabled = false
			end
		end
	end)
end

local function ModelCheckPhoto(model,player:Player)
	PhotoConn = game:GetService("RunService").Heartbeat:Connect(function()
		if not model.PrimaryPart then
			warn("Model has no PrimaryPart")
			return
		end
		local currentPosition:Vector3 = model.PrimaryPart.Position
		for i, node in ipairs(nodes) do
			if not reachedNodes[i] and  currentPosition.Z >= node.Z then
				CameraLight(workspace.CameraPhoto:WaitForChild(i))
				MainGameService:GamePhotoMoney(player)
				if i == 1 then
					player.PlayerGui:WaitForChild("CameraEffects").Enabled = true
					task.spawn(function()
						task.wait(0.7)
						player.PlayerGui:WaitForChild("CameraEffects").Enabled = false
					end)
				end
				reachedNodes[i] = true
			end
		end
	end)
end 

local function startFishing(player,landingPoint,isWin,fishType,newFish)
	
	-- Ensure we have the player's character and tool
	local character = player.Character
	if not character then return end

	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then return end

	-- Position the float in front of the player
	local playerPosition = character.HumanoidRootPart.Position
	local forwardDirection = character.HumanoidRootPart.CFrame.LookVector -- Direction the player is facing
	local floatStartPosition = playerPosition + forwardDirection * 5 -- Adjust distance in front of player as needed

	local pos1 = floatStartPosition
	local pos2 = landingPoint

	-- Set up the camera to follow the float
	local floatPart = ReplicatedStorage.Assets.FishHook:WaitForChild(tool.Value.Value):Clone()
	floatPart.PrimaryPart.CFrame = CFrame.new(floatStartPosition) * CFrame.Angles(math.rad(90), 0, 0)
	floatPart.Parent = workspace.fishHook

	local camera:Camera = workspace.CurrentCamera
	if LocalPlayer == player then
		camera.CameraSubject = floatPart
		camera.CameraType = Enum.CameraType.Track
	end
	
	local velocityX = 5
	local deltaX = (landingPoint - floatStartPosition).X
	local timess = deltaX / velocityX

	local dir = pos2 - pos1
	local dur = math.log(1.001 + 1 + dir.Magnitude * 0.01) * 1.1 + 0.1
	--local dur = math.log((1.001 + dir.Magnitude) * 1.1)
	--local dur = (0.001 + dir.Magnitude * 0.01) * 0.5
	local force = dir / dur + Vector3.new(0, game.Workspace.Gravity * dur * 0.5, 0)

	local fishingRodPosition = tool.Handle.Position
	local beam = Instance.new("Beam")
	beam.Attachment0 = tool.yugan:FindFirstChild("Top")
	beam.Attachment1 = floatPart.FishHook:FindFirstChild("Top")
	beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
	beam.Width0 = 0.2
	beam.Width1 = 0.2
	beam.Parent = floatPart

	floatPart.PrimaryPart:ApplyImpulse(force * floatPart.PrimaryPart.AssemblyMass)
	--鱼钩自动转?
	local bodyGyro = Instance.new("BodyGyro", floatPart.PrimaryPart)
	bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)  -- 设置足够大，确保可以旋转
	bodyGyro.P = 2000  -- 旋转速度
	bodyGyro.CFrame = floatPart.PrimaryPart.CFrame  -- 初始角度
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function()
		if floatPart.PrimaryPart.Parent then
			local velocity = floatPart.PrimaryPart.AssemblyLinearVelocity  -- 获取当前速度
			if velocity.Magnitude > 1 then
				bodyGyro.CFrame = CFrame.lookAt(floatPart.PrimaryPart.Position, floatPart.PrimaryPart.Position + velocity)
			end
		end
	end)
	if LocalPlayer == player then
		SoundController:PlaySoundOnce("FishGookFly")
	end

	--floatPart:SetNetworkOwner(nil)
	task.delay(dur,function()
		for k,v in pairs(workspace.VFX.InW:GetDescendants()) do
			task.spawn(function()
				if v:IsA("ParticleEmitter") then
					local EMIT_AMOUNT= v:GetAttribute("EmitCount")
					v:Emit(EMIT_AMOUNT)
				end
			end)
		end
		connection:Disconnect()
		connection = nil
		
		task.spawn(function()
			task.wait(1)
			for k,v in pairs(workspace.VFX.WaitW:GetDescendants()) do
				task.spawn(function()
					if v:IsA("ParticleEmitter") then
						v.Enabled = true
					end
				end)
			end
		end)
		
		if isWin then
			if LocalPlayer == player then
				
				SoundController:PlaySoundOnce("PopSoud")
				SoundController:StopSoundOnce("PopSoud")
				SoundController:PlaySoundOnce("FishRodWater")

				camera.CameraSubject = nil
				local poss = workspace.CameraPos.CamMovePart.Position
				local lookAt = workspace.CameraPos.LookAtPart.Position

				local cameraCFrame=CFrame.new(poss,lookAt)

				local tween = TweenService:Create(camera, TweenInfo.new(2), { CFrame = cameraCFrame })
				tween:Play()
			end

			task.wait(2)
			floatPart:Destroy()
			
			for k,v in pairs(workspace.VFX.WaitW:GetDescendants()) do
				task.spawn(function()
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end)
			end
			for k,v in pairs(workspace.VFX.FromW:GetDescendants()) do
				task.spawn(function()
					if v:IsA("ParticleEmitter") then
						local EMIT_AMOUNT= v:GetAttribute("EmitCount")
						v:Emit(EMIT_AMOUNT)
					end
				end)
			end
			if LocalPlayer == player then
				AnimationPreloader.PlayAnimation(animFolder.GetFishRod)
			end

			local pos1 = landingPoint
			local pos2 = floatStartPosition

			local dir = pos2 - pos1
			local dur = math.log(1.001 + 1 + dir.Magnitude * 0.01)
			local force = dir / dur + Vector3.new(0, game.Workspace.Gravity * dur *0.5, 0)
			
			local qualityName = FishHelper.GetFish(fishType).quality
			if tostring(qualityName) ~= "COMMON" then
				for k,v in pairs(workspace.VFX:WaitForChild(qualityName):GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(tonumber(v:GetAttribute("EmitCount")))
					end
				end
			end
			local fish = game.ReplicatedStorage.Assets.Fish:WaitForChild(fishType):Clone()
			--local fish = game.ReplicatedStorage.Assets.Fish:WaitForChild("Jadefin"):Clone()
			fish.PrimaryPart.CFrame = CFrame.new(pos1) * CFrame.Angles(0, math.rad(180), 0)
			fish.Parent = workspace
			fish.PrimaryPart:ApplyImpulse(force * fish.PrimaryPart.AssemblyMass)
			--鱼自动转?
			local bodyGyro = Instance.new("BodyGyro", fish.PrimaryPart)
			bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)  -- 设置足够大，确保可以旋转
			bodyGyro.P = 2000  -- 旋转速度
			bodyGyro.CFrame = fish.PrimaryPart.CFrame  -- 初始角度
			local connectionFish
			connectionFish = game:GetService("RunService").Heartbeat:Connect(function()
				if fish.PrimaryPart.Parent then
					local velocity = fish.PrimaryPart.AssemblyLinearVelocity  -- 获取当前速度
					if velocity.Magnitude > 1 then
						bodyGyro.CFrame = CFrame.lookAt(fish.PrimaryPart.Position, fish.PrimaryPart.Position + velocity)
					end
				end
			end)
			if LocalPlayer == player then
				
				ModelCheckPhoto(fish,player)

				camera.CameraSubject = fish:WaitForChild("CameraPart")
				camera.CameraType = Enum.CameraType.Track

				SoundController:PlaySoundOnce("BackFishRod")
				SoundController:PlaySoundOnce("BackFishRodSound")
				SoundController:PlaySoundOnce("FishFlySound")
				--ball:SetNetworkOwner(nil)
				if newFish then
					FishIndexController:NewFishUI(fishType)
				end
				task.delay(dur,function()
					connectionFish:Disconnect()
					connectionFish = nil
					PhotoConn:Disconnect()
					PhotoConn = nil
					reachedNodes = {}
					UpgradesService:CSWalkSpeed(player)
					Control:Enable()
					OverallSituation.ThrowCD = false
					camera.CameraSubject = LocalPlayer.Character.Humanoid
					camera.CameraType = Enum.CameraType.Custom
					MainGameService:GameWinGetMoney(player,LocalPlayer:GetAttribute("ThrowBuff"))
					player:SetAttribute("FlyTime",false)
					SoundController:PlaySoundOnce("FishGround")
					task.wait(3)
					fish:Destroy()
				end)
			else
				connectionFish:Disconnect()
				connectionFish = nil
				task.wait(3)
				fish:Destroy()
			end
		else
			if LocalPlayer == player then
				SoundController:PlaySoundOnce("FishGround")
				task.spawn(function()
					local preX = ReplicatedStorage.Assets.Prefabs.feildT:Clone()
					preX.Position = pos2
					preX.Parent = workspace
					task.wait(1)
					preX:Destroy()
				end)
			end
			task.wait(2)
			floatPart:Destroy()
			UpgradesService:CSWalkSpeed(player)
			Control:Enable()
			OverallSituation.ThrowCD = false
			camera.CameraSubject = LocalPlayer.Character.Humanoid
			camera.CameraType = Enum.CameraType.Custom
			player:SetAttribute("FlyTime",false)
		end
		OverallSituation.BtnOnce = false
	end)
end

local function MakeFishAnim()
	if not MakeFishAnimCd then
		return
	end
	if tick() - MakeFishAnimCd < 0.3 then
		return
	end
	MakeFishAnimCd = tick()
end

function InputController:sStartFishing(player,landingPoint,isWin,fishType,newFish)
	startFishing(player,landingPoint,isWin,fishType,newFish)
end
	
function InputController:StartFishing(player,percent)
	local disNum
	local isWin
	local function getData(updateData,fishRodData)
		local enchantUp = 0
		if fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant > 5 and fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant < 11 then
			enchantUp = FishRodEnchantHelper.GetEnchantIndex(fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant).buff
		end
		disNum = UpgradesHelper.GetUpgradesNum("strengthLevel",updateData.strengthLevel + enchantUp) * (0.5 + (1 - percent) * 0.5)
		local distanceZ = player.Character.HumanoidRootPart.Position.Z - disNum
		if distanceZ <= 30 then
			distanceZ = 0
			print("这个获胜")
			isWin = true
		else
			print("没赢")
			isWin = false
		end
		local landingPoint = Vector3.new(0, 5, distanceZ)
		--startFishing(player,landingPoint,isWin)
		for k,v in pairs(Players:GetPlayers()) do
			if v ~= player then
				startFishing(v,landingPoint,isWin)
			end
		end
	end
	UpgradesService:GetUpgradesAndFishRodData(player):andThen(getData)
end
-- Module code
function InputController:FireClick()
	--MakeFishAnim()
end

function InputController:Click()
	self:FireClick()
end

function InputController:Inputs()
	-- Computer
	UserInputService.InputBegan:Connect(function(input, processedByUI)
		if processedByUI then return end
		local inputType = input.UserInputType
		if inputType == Enum.UserInputType.MouseButton1 then
			self:Click()
		end
	end)
	-- Console
	local gamepadInput = Gamepad.new()
	gamepadInput.ButtonDown:Connect(function(button, processedByUI)
		if processedByUI then return end
		if button == Enum.KeyCode.ButtonR2 then
			self:Click()
		end
		if button == Enum.KeyCode.ButtonB then
			print("手柄按B")
		end
	end)

	-- Mobile
	local mobileInput = Touch.new()
	mobileInput.TouchTapInWorld:Connect(function(position, processedByUI)
		if processedByUI then return end
		self:Click()
	end)
end

function InputController:KnitInit()
	UpgradesService = Knit.GetService("UpgradesService")
	MainGameService = Knit.GetService("MainGameService")

	SoundController = Knit.GetController("SoundController")
	FishIndexController = Knit.GetController("FishIndexController")
end

function InputController:KnitStart()
	self:Inputs()

	self.MakeFishCd = tick()
end

-- Return module
return InputController