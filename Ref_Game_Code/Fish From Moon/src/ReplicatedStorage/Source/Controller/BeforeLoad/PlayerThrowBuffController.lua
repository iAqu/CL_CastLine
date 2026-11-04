local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local PlayerThrowBuffService

local FishRodEnchantHelper = require(game.ReplicatedStorage.Config.FishRodEnchantHelper)
local UpgradesHelper = require(game.ReplicatedStorage.Config.UpgradesHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Zone = require(ReplicatedStorage.Plugin.Zone)
local Trove = require(Knit.Util.Trove)
local Timer = require(Knit.Util.Timer)

local trove = Trove.new()

local PlayerThrowBuffController = Knit.CreateController { Name = "PlayerThrowBuffController" }

local function ShowThrowBuff(player)
	LocalPlayer:SetAttribute("ThrowBuff",true)
	LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips.AreaTip.Visible = true
	task.spawn(function()
		task.wait(0.5)
		LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips.StrengthTip.Visible = true
	end)
	task.spawn(function()
		task.wait(1)
		LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips.MoneyTip.Visible = true
	end)
end
local function HideThrowBuff(player)
	LocalPlayer:SetAttribute("ThrowBuff",false)
	LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips.AreaTip.Visible = false
	LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips.StrengthTip.Visible = false
	LocalPlayer.PlayerGui:WaitForChild("MainUi").MainHud.Tips.MoneyTip.Visible = false
end
--创建
local function creatTask1ThrowBuff()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local PreThrowBuff = ReplicatedStorage.Assets.Prefabs.ThrowBuff:Clone()
		PreThrowBuff.PrimaryPart.Position = Vector3.new(-0, 1.828, 39.962)
		PreThrowBuff.Parent = workspace.PreThrowBuffPart

		local zone = Zone.new(PreThrowBuff:WaitForChild("CheckPart"))
		zone.playerEntered:Connect(ShowThrowBuff)
		zone.playerExited:Connect(HideThrowBuff)
	end	
end
--创建
local function creatTask2ThrowBuff()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		workspace.PreThrowBuffPart:ClearAllChildren()

		local PreThrowBuff = ReplicatedStorage.Assets.Prefabs.ThrowBuff:Clone()
		PreThrowBuff.PrimaryPart.Position = Vector3.new(-0, 1.828, 56.473)
		PreThrowBuff.Parent = workspace.PreThrowBuffPart

		local zone = Zone.new(PreThrowBuff:WaitForChild("CheckPart"))
		zone.playerEntered:Connect(ShowThrowBuff)
		zone.playerExited:Connect(HideThrowBuff)
	end	
end
--创建
local function creatTask3ThrowBuff()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		workspace.PreThrowBuffPart:ClearAllChildren()
	end	
end

local function creatBuffPart(pos)
	workspace.PreThrowBuffPart:ClearAllChildren()
	
	local PreThrowBuff = ReplicatedStorage.Assets.Prefabs.ThrowBuff:Clone()
	PreThrowBuff.PrimaryPart.Position = pos
	PreThrowBuff.Parent = workspace.PreThrowBuffPart

	local zone = Zone.new(PreThrowBuff:WaitForChild("CheckPart"))
	zone.playerEntered:Connect(ShowThrowBuff)
	zone.playerExited:Connect(HideThrowBuff)
end

local function createPowerBuff()
	local function getData(playerThrowBuffData,upgradesData,fishRodData)
		if playerThrowBuffData.Task2 then
			local enchantUp = 0
			if fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant > 5 and fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant < 11 then
				enchantUp = FishRodEnchantHelper.GetEnchantIndex(fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].enchant).buff
			end
			local power = upgradesData.strengthLevel + enchantUp
			local canDis = UpgradesHelper.GetUpgradesNum("strengthLevel",power)
			local x = math.random(-35,35)
			local y = 1.828
			local minz = (canDis + 30 - 70) < 30 and 40 or (canDis + 30 - 70)
			local maxz = (canDis + 30 - 20) < 30 and 40 or (canDis + 30 - 20)
			local z = math.random(minz,maxz)
			creatBuffPart(Vector3.new(x,y,z))
		else
			return
		end
	end
	PlayerThrowBuffService:GetPlayerThrowBuffAndUpgeadesData():andThen(getData)
end

function PlayerThrowBuffController:KnitInit()
	PlayerThrowBuffService = Knit.GetService("PlayerThrowBuffService")
end

function PlayerThrowBuffController:KnitStart()
	PlayerThrowBuffService.CreatTask1ThrowBuff:Connect(creatTask1ThrowBuff)
	PlayerThrowBuffService.CreatTask2ThrowBuff:Connect(creatTask2ThrowBuff)
	PlayerThrowBuffService.CreatTask3ThrowBuff:Connect(creatTask3ThrowBuff)

	local timer = Timer.new(35)
	--local timer = Timer.new(10)
	timer.Tick:Connect(function()
		createPowerBuff()
	end)
	trove:Add(timer)
	timer:StartNow()
end

return PlayerThrowBuffController