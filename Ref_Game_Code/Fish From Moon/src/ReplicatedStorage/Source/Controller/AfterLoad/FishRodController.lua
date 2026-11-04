--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool = require(ReplicatedStorage.Source.Utils.Tool)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger = require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local FishRodService
local GamePassService

local NPCController
local ItemController

--GUI
local CenterMenu = player.PlayerGui:WaitForChild("MainMenu").CenterMenu
local MainHud = player.PlayerGui:WaitForChild("MainUi").MainHud
local RodMenu = CenterMenu.RodMenu
local rodMenuFrame = RodMenu.menu.Container.left.List

local fishRodFloder = rodMenuFrame.Folder.Frame

local BtnFishRodMenu = MainHud.Left.Holder.rods.btn
local BtnExitFishRodMenu = RodMenu.menu.Exit.TextButton

local BtnNPCPage = RodMenu.menu.SwitchBag.NPCPage
local BtnItemPage = RodMenu.menu.SwitchBag.ItemPage

local BtnEquipBest = RodMenu.menu.Container.Bottom.DefaultMode.EquipBest.TextButton
local BtnLock = RodMenu.menu.Container.Bottom.DefaultMode.Lock.TextButton
local BtnDelete=RodMenu.menu.Container.Bottom.DefaultMode.Delete.TextButton

local BtnCancelLock=RodMenu.menu.Container.Bottom.LockMode.Cancel.TextButton
local BtnConfirmLock=RodMenu.menu.Container.Bottom.LockMode.Confirm.TextButton

local BtnTipDelete=RodMenu.menu.Container.Bottom.DeleteMode.ConfirmDelete.TextButton
local BtnCancelDelete=RodMenu.menu.Container.Bottom.DeleteMode.Cancel.TextButton
local BtnSelectAll=RodMenu.menu.Container.Bottom.DeleteMode.SelectALL.TextButton
local BtnTipSureDelete=RodMenu.menu.Confirm.button.Yes.TextButton
local BtnTipCancelDelete=RodMenu.menu.Confirm.button.No.TextButton

local frameName="RodMenu"

local array={}
local useArrary={}
local lockArrary={}
local deleteArrary={}

local FishRodController = Knit.CreateController { Name = "FishRodController" }

function FishRodController:OpenDedault()
	local rods = {}

	array={}
	useArrary={}
	lockArrary={}
	deleteArrary={}

	RodMenu.menu.Confirm.Visible=false

	RodMenu.menu.Container.Bottom.DeleteMode.Visible=false
	RodMenu.menu.Container.Bottom.LockMode.Visible=false
	RodMenu.menu.Container.Bottom.DefaultMode.Visible=true
	RodMenu.menu.Mode.Value = "Normal"
	---清空数据
	for index, object in pairs(rodMenuFrame:GetChildren()) do 
		if object:IsA("TextButton") then
			object:Destroy()
		end
	end
	local function getData(fishRodData)
		array=fishRodData.ownFishRodList
		useArrary=fishRodData.usingFishRodList

		----查询有没有背包加容量
		GamePassService:IsPlayerHaveGamePass("Storage50"):andThen(function(result)
			if result then
				GamePassService:IsPlayerHaveGamePass("Storage100"):andThen(function(result)
					if result then
						RodMenu.menu.Container.Top.Storage.ExtraPetInventory.Visible=false
					else
						RodMenu.menu.Container.Top.Storage.ExtraPetInventory.Visible=true
						RodMenu.menu.Container.Top.Storage.ExtraPetInventory.TextButton.Item.Value="1078494888"
					end
				end)
			else
				RodMenu.menu.Container.Top.Storage.ExtraPetInventory.Visible=true
				RodMenu.menu.Container.Top.Storage.ExtraPetInventory.TextButton.Item.Value="1078806277"
			end
		end)
		
		RodMenu.menu.Container.Top.Storage.Label.Text = NumberFormat.AbbreviateNumber(Tool.getTableLegth(fishRodData.ownFishRodList),2).."/"..NumberFormat.AbbreviateNumber(fishRodData.fishRodbag,2)

		for k,v in pairs(fishRodData["ownFishRodList"]) do
			local fishRodInfo = FishRodHelper.GetFishRod(v.name)
			local PreFishRod = fishRodFloder:WaitForChild(fishRodInfo.quality):Clone()
			PreFishRod.Name = tostring(k)
			PreFishRod.Frame.imgPet.Image = fishRodInfo.img
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
			
			PreFishRod.Frame.Power.Text = NumberFormat.AbbreviateNumber(fishRodInfo.baseMultiplier * fuseUp * levelUp,2)
		end
		-- Sort rods by power in descending order
		table.sort(rods, function(a, b)
			return a.power > b.power
		end)
		-- Set LayoutOrder for each rod based on sorted power
		for index, rodData in ipairs(rods) do
			rodData.rod.LayoutOrder = index  -- Set LayoutOrder according to the sorted order
			rodData.rod.Parent = rodMenuFrame  -- Parent the rod to rodMenuFrame
			if rodData.rod.Name == tostring(fishRodData.usingFishRodList[1]) then
				rodData.rod.Frame.imgEquip.Visible = true
				rodData.rod.LayoutOrder = 0
			end
			rodData.rod.MouseButton1Click:Connect(function()
				FishRodController:SelectFishRod(rodData.rod.Name)
			end)
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end

function FishRodController:SelectFishRod(fishRodId)
	if RodMenu.menu.Mode.Value == "Normal" then
		FishRodController:ChangeFishRod(fishRodId)
	elseif RodMenu.menu.Mode.Value == "Lock" then
		if table.find(lockArrary,fishRodId) then
			table.remove(lockArrary,table.find(lockArrary,fishRodId))
			rodMenuFrame:FindFirstChild(tostring(fishRodId)).Frame.Lock.Visible=false
		else
			table.insert(lockArrary,fishRodId)
			rodMenuFrame:FindFirstChild(tostring(fishRodId)).Frame.Lock.Visible=true
		end
	else
		if table.find(useArrary,fishRodId) then
			return
		end
		if array[tostring(fishRodId)].lock then
			return
		end
		if table.find(deleteArrary,fishRodId) then
			table.remove(deleteArrary,table.find(deleteArrary,fishRodId))
			rodMenuFrame:FindFirstChild(tostring(fishRodId)).Frame.imgDelete.Visible=false
		else
			table.insert(deleteArrary,fishRodId)
			rodMenuFrame:FindFirstChild(tostring(fishRodId)).Frame.imgDelete.Visible=true
		end
	end
end
--装备
function FishRodController:ChangeFishRod(fishRodId)
	FishRodService:ChangeFishRod(fishRodId):andThen(function(result,message)
		if result then
			FishRodController:OpenDedault()
		else
			print(message)
		end
	end)
end
--装备最好
function FishRodController:EquipBestFishRod()
	FishRodService:EquipBestFishRod():andThen(function(result,message)
		if result then
			FishRodController:OpenDedault()
		else
			print(message)
		end
	end)
end
--点击进入锁定状态
function FishRodController:LockState()
	FishRodController:OpenDedault()

	RodMenu.menu.Mode.Value = "Lock"

	RodMenu.menu.Container.Bottom.DeleteMode.Visible=false
	RodMenu.menu.Container.Bottom.LockMode.Visible=true
	RodMenu.menu.Container.Bottom.DefaultMode.Visible=false

	local function getData(fishRodData)
		for k,v in pairs(fishRodData["ownFishRodList"]) do
			if v.lock then
				table.insert(lockArrary,k)
				rodMenuFrame:FindFirstChild(tostring(k)).Frame.Lock.Visible=true
			end
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end
--确定锁定选中的全部宠物
function FishRodController:LockSelectFishRod()
	FishRodService:LockSelectFishRod(lockArrary):andThen(function(result,message)
		if result then
			lockArrary={}
			RodMenu.menu.Mode.Value = "Normal"
			FishRodController:OpenDedault()
		else
			print(message)
		end
	end)
end
--点击进入删除状态
function FishRodController:DeleteState()
	FishRodController:OpenDedault()

	RodMenu.menu.Mode.Value = "Delete"

	RodMenu.menu.Container.Bottom.DeleteMode.Visible=true
	RodMenu.menu.Container.Bottom.LockMode.Visible=false
	RodMenu.menu.Container.Bottom.DefaultMode.Visible=false
end
--点击全选
function FishRodController:SelectAll()
	local function getData(fishRodData)
		for k,v in pairs(fishRodData["ownFishRodList"]) do
			if tostring(k) == fishRodData["usingFishRodList"][1] then
				continue
			end
			if v.lock then
				continue
			end
			table.insert(deleteArrary,k)
			rodMenuFrame:FindFirstChild(tostring(k)).Frame.imgDelete.Visible=true
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end
--点击提示是否删除
function FishRodController:DeleteSureFishRod()
	RodMenu.menu.Confirm.Visible=true
end
--确定删除选中的全部宠物
function FishRodController:DeleteSelectFishRod()
	FishRodService:DeleteSelectFishRod(deleteArrary):andThen(function(result,message)
		if result then
			deleteArrary={}
			RodMenu.menu.Mode.Value = "Normal"
			FishRodController:OpenDedault()
		else
			print(message)
		end
	end)
end

--购买背包容量
function FishRodController:BuyBagStorage()
	FishRodService:BuyBagStorage()
end
--刷新页面
local function changeBagData()
	if RodMenu.Visible then
		FishRodController:OpenDedault()
	end
end

function FishRodController:KnitInit()
	FishRodService = Knit.GetService("FishRodService")
	GamePassService = Knit.GetService("GamePassService")

	NPCController = Knit.GetController("NPCController")
	ItemController = Knit.GetController("ItemController")
end

function FishRodController:KnitStart()
	BtnFishRodMenu.MouseButton1Click:Connect(function()
		self.OpenDedault()
		FrameTrigger.OpenFram(frameName)
	end)
	BtnExitFishRodMenu.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	BtnNPCPage.MouseButton1Click:Connect(function()
		NPCController:OpenDedault()
		local frameName="NPCBagMenu"
		FrameTrigger.OpenFram(frameName)
	end)
	BtnItemPage.MouseButton1Click:Connect(function()
		ItemController:OpenDedault()
		local frameName="ItemMenu"
		FrameTrigger.OpenFram(frameName)
	end)

	BtnEquipBest.MouseButton1Click:Connect(function()
		self.EquipBestFishRod()
	end)
	BtnLock.MouseButton1Click:Connect(function()
		self.LockState()
	end)
	BtnCancelLock.MouseButton1Click:Connect(function()
		self.OpenDedault()
	end)
	BtnConfirmLock.MouseButton1Click:Connect(function()
		self.LockSelectFishRod()
	end)
	BtnDelete.MouseButton1Click:Connect(function()
		self.DeleteState()
	end)
	BtnSelectAll.MouseButton1Click:Connect(function()
		self.SelectAll()
	end)
	BtnCancelDelete.MouseButton1Click:Connect(function()
		self.OpenDedault()
	end)
	BtnTipDelete.MouseButton1Click:Connect(function()
		self.DeleteSureFishRod()
	end)
	BtnTipSureDelete.MouseButton1Click:Connect(function()
		self.DeleteSelectFishRod()
	end)
	BtnTipCancelDelete.MouseButton1Click:Connect(function()
		self.OpenDedault()
	end)
	
	FishRodService.ChangeBagData:Connect(changeBagData)
end

return FishRodController