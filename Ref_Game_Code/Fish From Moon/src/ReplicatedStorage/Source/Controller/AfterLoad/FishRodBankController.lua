--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool = require(ReplicatedStorage.Source.Utils.Tool)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger = require(LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local FishRodService
local FishRodBankService
----GUI
local BankMenu = LocalPlayer.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.BankMenu
local BankFrame = BankMenu.Menu.Container.List

local BtnExitFishRodRankMenu = BankMenu.Menu.Exit.TextButton
local BtnUpLevel = BankMenu.Menu.Top.Storage.ExtraPetInventory.TextButton
local BtnConfigLevel = BankMenu.Menu.down.buttons.levelup.TextButton

local FishRodRankFolder = BankFrame.Folder.Frame

local frameName="BankMenu"

local cdTime = 0
local allFishRodGiveGem = 0

local FishRodBankController = Knit.CreateController { Name = "FishRodBankController" }

function FishRodBankController:OpenDedault()
	local rods = {}
	BankMenu.Menu.Container.Visible = true
	BankMenu.Menu.levelup.Visible = false

	BankMenu.Menu.down.buttons.Add.Visible = false
	BankMenu.Menu.down.buttons.Back.Visible = false
	BankMenu.Menu.down.buttons.Cancel.Visible = false
	BankMenu.Menu.down.buttons.withdraw.Visible = false

	---清空数据
	for index, object in pairs(BankFrame:GetChildren()) do 
		if object:IsA("TextButton") then
			object:Destroy()
		end
	end
	local function getData(fishRodBankData)

		BankMenu.Menu.Top.Storage.Label.Text = NumberFormat.AbbreviateNumber(Tool.getTableLegth(fishRodBankData.bankList),2).."/"..NumberFormat.AbbreviateNumber(fishRodBankData.fishRodRankBag,2)

		for k,v in pairs(fishRodBankData["bankList"]) do
			local fishRodInfo = FishRodHelper.GetFishRod(v.name)
			allFishRodGiveGem += fishRodInfo.baseRankGem
			local PreFishRod = FishRodRankFolder:WaitForChild(fishRodInfo.quality):Clone()
			--local PreFishRod = FishRodRankFolder:WaitForChild("COMMON"):Clone()
			PreFishRod.Name = tostring(k)
			PreFishRod.Frame.imgPet.Image = fishRodInfo.img
			PreFishRod.Frame.Power.Text = NumberFormat.AbbreviateNumber(fishRodInfo.baseMultiplier,2)
			--合成
			if v.fuse == 2 then
				PreFishRod.Frame.Fuse.image = "rbxassetid://12808209251"
			elseif v.fuse == 3 then
				PreFishRod.Frame.Fuse.image = "rbxassetid://12808210752"
			end
			---锁定
			if v.lock then
				PreFishRod.Frame.Lock.Visible=true
			else
				PreFishRod.Frame.Lock.Visible=false
			end
			-- Store the rod with its Power value and reference to PreFishRod
			table.insert(rods,{
				rod = PreFishRod,
				power = fishRodInfo.baseMultiplier
			})
		end
		-- Sort rods by power in descending order
		table.sort(rods, function(a, b)
			return a.power > b.power
		end)
		-- Set LayoutOrder for each rod based on sorted power
		for index, rodData in ipairs(rods) do
			rodData.rod.LayoutOrder = index
			rodData.rod.Parent = BankFrame
		end
		if os.time() - fishRodBankData.cliamTime >= 4*60*60 then
			BankMenu.Menu.down.Collect.Visible = true
			BankMenu.Menu.down.CDCollect.Visible = false
		else
			BankMenu.Menu.down.Collect.Visible = false
			BankMenu.Menu.down.CDCollect.Visible = true
			cdTime = os.time() - fishRodBankData.cliamTime
		end
		BankMenu.Menu.down.gems.text.current.Text = fishRodBankData.payGems
		BankMenu.Menu.down.gems.text.day.Text = "+"..NumberFormat.AbbreviateNumber(allFishRodGiveGem,2).."/Day"
	end

	FishRodBankService:GetFishRodBankData(LocalPlayer):andThen(getData)
end

function FishRodBankController:SelectLevelMenu()
	BankMenu.Menu.Container.Visible = false
	BankMenu.Menu.levelup.Visible = true
end

function FishRodBankController:KnitInit()
	FishRodService = Knit.GetService("FishRodService")
	FishRodBankService = Knit.GetService("FishRodBankService")
end

function FishRodBankController:KnitStart()
	BtnExitFishRodRankMenu.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	BtnUpLevel.MouseButton1Click:Connect(function()
		FishRodBankController:SelectLevelMenu()
	end)
	BtnConfigLevel.MouseButton1Click:Connect(function()
		FishRodBankController:SelectLevelMenu()
	end)
end

return FishRodBankController