--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local EnchantService
local FishRodService

local MainGuiController
--GUI
local CenterMenu = player.PlayerGui:WaitForChild("MainMenu").CenterMenu
local MainHud = player.PlayerGui:WaitForChild("MainUi").MainHud
local EnchantMenu = CenterMenu.EnchantMenu
local EnchantMenuFrame = EnchantMenu.menu.Container.left.List

local fishRodFloder = EnchantMenuFrame.Folder.Frame

local BtnExit = EnchantMenu.menu.Exit.TextButton
local BtnEnchant = EnchantMenu.menu.Container.Bottom.TextButton

local frameName="EnchantMenu"

local selectArrary={}

local EnchantController = Knit.CreateController { Name = "EnchantController" }

function EnchantController:OpenDedault()
	local rods = {}
	
	local function getData(fishRodData)
		---清空数据
		for index, object in pairs(EnchantMenuFrame:GetChildren()) do 
			if object:IsA("TextButton") then
				object:Destroy()
			end
		end
		for k,v in pairs(fishRodData["ownFishRodList"]) do
			local fishRodInfo = FishRodHelper.GetFishRod(v.name)
			local PreFishRod = fishRodFloder:WaitForChild(fishRodInfo.quality):Clone()
			PreFishRod.Name = tostring(k)
			PreFishRod.Frame.imgPet.Image = fishRodInfo.img
			PreFishRod.Frame.Power.Text = NumberFormat.AbbreviateNumber(fishRodInfo.baseMultiplier,2)
			--合成
			if v.fuse == 2 then
				PreFishRod.Frame.Fuse.Image = "rbxassetid://12808209251"
				PreFishRod.Frame.Power.Shiny.Enabled = true
			elseif v.fuse == 3 then
				PreFishRod.Frame.Fuse.Image = "rbxassetid://12808210752"
				PreFishRod.Frame.Power.Rainbow.Enabled = true
			end
			---锁定
			if v.lock then
				PreFishRod.Frame.Lock.Visible=true
			else
				PreFishRod.Frame.Lock.Visible=false
			end
			local fuseUp = 1
			if v["fuse"] == 2 then
				fuseUp += 3
			elseif v["fuse"] == 3 then
				fuseUp += 10
			elseif v["fuse"] == 4 then
				fuseUp += 20
			end
			local levelUp = 1
			levelUp =  1 + (v.level * 0.05)
			-- Store the rod with its Power value and reference to PreFishRod
			table.insert(rods,{
				rod = PreFishRod,
				power = fishRodInfo.baseMultiplier * fuseUp * levelUp
			})
			PreFishRod.name.Value = v.name
			PreFishRod.Power.Value = fishRodInfo.baseMultiplier * fuseUp * levelUp
			PreFishRod.level.Value = v.level
			PreFishRod.exp.Value = v.exp
			PreFishRod.enchant.Value = v.enchant
			PreFishRod.quality.Value = fishRodInfo.quality
		end
		-- Sort rods by power in descending order
		table.sort(rods, function(a, b)
			return a.power > b.power
		end)
		-- Set LayoutOrder for each rod based on sorted power
		for index, rodData in ipairs(rods) do
			rodData.rod.LayoutOrder = index  -- Set LayoutOrder according to the sorted order
			rodData.rod.Parent = EnchantMenuFrame  -- Parent the rod to rodMenuFrame
			if rodData.rod.Name == tostring(selectArrary[1]) then
				rodData.rod.Frame.imgEquip.Visible = true
				rodData.rod.LayoutOrder = 0
			end
			rodData.rod.MouseButton1Click:Connect(function()
				EnchantController:SelectFishRod(rodData.rod.Name)
			end)
		end
		if selectArrary[1] == nil then
			EnchantMenu.menu.Container.Bottom.TextButton.Visible = false
		else
			EnchantMenu.menu.Container.Bottom.TextButton.Label.Text = 1000 + (fishRodData["ownFishRodList"][selectArrary[1]].enchantNum * 150)
			EnchantMenu.menu.Container.Bottom.TextButton.Visible = true
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end

function EnchantController:SelectFishRod(fishRodId)
	selectArrary = {}
	table.insert(selectArrary,fishRodId)
	EnchantController:OpenDedault()
end

function EnchantController:FishRodEnchant()
	if selectArrary[1] == nil  then
		MainGuiController:ShowMessageEffect("warning",nil,"Please choose a fishing rod first!")
	else
		EnchantService:FishRodEnchant(selectArrary[1]):andThen(function(result,message,img)
			if result then
				selectArrary = {}
				EnchantController:OpenDedault()
				MainGuiController:ShowMessageEffect("Enchant",nil,message,img)
			else
				EnchantController:OpenDedault()
				MainGuiController:ShowMessageEffect("warning",nil,message)
			end
		end)
	end
end

function EnchantController:KnitInit()
	EnchantService = Knit.GetService("EnchantService")
	FishRodService = Knit.GetService("FishRodService")

	MainGuiController = Knit.GetController("MainGuiController")
end

function EnchantController:KnitStart()
	BtnExit.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)
	BtnEnchant.MouseButton1Click:Connect(function()
		EnchantController:FishRodEnchant()
	end)
end

return EnchantController