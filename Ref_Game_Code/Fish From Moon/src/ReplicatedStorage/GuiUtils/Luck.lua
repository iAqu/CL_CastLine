local Luck = {}
--加载服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TweenUntil = require(ReplicatedStorage.Utils.Tween)
local AllUse = require(game.ReplicatedStorage.QuanJu.AllUse)
local AnimModule = require(ReplicatedStorage.Utils.AnimModule)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)

local SoundController

local localPlayer = Players.LocalPlayer

local playerGui = localPlayer.PlayerGui

local PetUIGradientFolder = ReplicatedStorage.Assets.Pet.PetUIGradient
local PetUIStrokeFolder = ReplicatedStorage.Assets.Pet.PetUIStroke

local EggSystemGUI = playerGui:WaitForChild("EggSystem")
local DisplayFrame = EggSystemGUI:WaitForChild("DisPlay")
local DisplayCloseButton = DisplayFrame:WaitForChild("CloseButton")
local MoreFolder = DisplayFrame:WaitForChild("More")
local OneFolder = DisplayFrame:WaitForChild("One")

--开盒
local Egg  
local PetDisplay
local ispetsOpen
local hatchOneConnection 
local camera = workspace.Camera

function Luck.openEgg(OpenPets,eggid)
	if not OpenPets then
		return
	end
	if #OpenPets == 0 then
		return
	end

	playerGui:WaitForChild("EggSystem"):WaitForChild("DisPlay").Visible = false
	playerGui:WaitForChild("MainMenu").Enabled = false

	Egg = game.Workspace.Eggs.Egg:FindFirstChild("Egg_"..eggid):Clone()

	--对展示的鸡蛋进行一个处理
	for i, v in (Egg:GetChildren()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
		end
	end 

	Egg.Parent = camera
	
	--宠物展示模板名字
	for i,petinfo in OpenPets do
		
		SoundController = Knit.GetController("SoundController")
		--断开之前的 确保只有一次
		if hatchOneConnection then
			hatchOneConnection:Disconnect()
		end

		if not MoreFolder:FindFirstChild(tostring(i)) then
			i=1
		end

		if #OpenPets == 1 then
			PetDisplay = OneFolder:FindFirstChild("1")
			PetDisplay.Visible = true
			TweenUntil.target(PetDisplay.Sunray,0,0.05,{
				Rotation = 180,
			})
		else
			PetDisplay = MoreFolder:FindFirstChild(tostring(i))
			PetDisplay.Visible = true
			TweenUntil.target(PetDisplay.Sunray,0,0.05,{
				Rotation = 180,
			})
		end

		--宠物信息以及颜色的显示
		local displayName = FishRodHelper.GetFishRod(petinfo).name
		--品质
		local petRarity = FishRodHelper.GetFishRod(petinfo).quality
		--颜色
		local Color = PetUIStrokeFolder:FindFirstChild(petRarity).Color

		PetDisplay.PetIcon.Image = FishRodHelper.GetFishRod(petinfo).img
		PetDisplay.PetIcon.Visible = true
		--炫光
		PetDisplay.Sunray.ImageColor3 = Color
		--名字
		PetDisplay.PetName.Text = displayName
		if PetDisplay.PetName:FindFirstChildOfClass("UIGradient") then
			PetDisplay.PetName:FindFirstChildOfClass("UIGradient"):Destroy()
		end

		--品质
		PetDisplay.RarityLabel.Text = petRarity

		if PetDisplay.RarityLabel:FindFirstChildOfClass("UIGradient") then
			PetDisplay.RarityLabel:FindFirstChildOfClass("UIGradient"):Destroy()
		end
		
		PetUIGradientFolder[petRarity]:Clone().Parent = PetDisplay.RarityLabel
		
		task.spawn(function()
			local cf = CFrame.new(0,-7,-(Egg.PrimaryPart.Size.Z) * 2) * CFrame.Angles(0,math.rad(180),0)
			Egg:PivotTo(camera.CFrame * cf)
			hatchOneConnection = game:GetService("RunService").RenderStepped:Connect(function()
				if Egg.PrimaryPart == nil then
					hatchOneConnection:Disconnect()
					return
				end
				local cf = CFrame.new(0,-7,-(Egg.PrimaryPart.Size.Z) * 2) * CFrame.Angles(0,math.rad(180),0)
				Egg:PivotTo(camera.CFrame * cf)
			end)
			AnimModule.PlayAnim(Egg,ReplicatedStorage.Assets.Animations.BoxOpen)
		end)
		
		--抽奖时间
		task.spawn(function()
			SoundController:PlaySoundOnce("openBox")
			task.wait(3)
			SoundController:PlaySoundOnce("openBoxEnd")
			for i, v in pairs(Egg:GetChildren()) do
				if v:IsA("BasePart") then
					TweenService:Create(v,TweenInfo.new(.5),{Transparency = 1}):Play()
				end
			end
			hatchOneConnection:Disconnect()
			Egg:Destroy()
			game.Workspace.Camera:ClearAllChildren()
			DisplayFrame.Visible = true
			game.Workspace.Camera:ClearAllChildren()
		end)
	end
end

function Luck.closePreview()

	DisplayFrame.Visible = false

	--展示模型删掉
	for i,v:ViewportFrame in DisplayFrame:GetDescendants() do
		if v.Name == "Sunray" then
			TweenUntil.stop(v,"Rotation")
		end
	end  

	OneFolder:FindFirstChild("1").Visible = false

	for i,v:Frame in MoreFolder:GetChildren() do
		if v.ClassName == "Frame" then
			v.Visible = false
		end
	end

	AllUse.isCanLuckEgg=false
	localPlayer:SetAttribute("BuyFishRod",false)
	playerGui:WaitForChild("MainMenu").Enabled = true
end

return Luck