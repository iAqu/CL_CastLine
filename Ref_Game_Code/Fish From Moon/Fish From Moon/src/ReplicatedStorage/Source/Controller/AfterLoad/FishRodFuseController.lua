--加载服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--加载组件
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat= require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local FishRodService
local FishRodFuseService

local MainGuiController

local FishRodFuseController = Knit.CreateController { Name = "FishRodFuseController" }

local FuseShinyMenu = player.PlayerGui:WaitForChild("MainMenu").CenterMenu.FuseShinyMenu
local BtnCloseFuseShiny = FuseShinyMenu.Menu.Exit.TextButton
local puseFrame = FuseShinyMenu.Menu.Left.List
local FishRodFuseFolder = puseFrame.Folder.Frame
local BtnCraftShiny = FuseShinyMenu.Menu.Right.Button.TextButton

local sumArray={}
local selectArray={}

--打开合成界面
function FishRodFuseController:OpenFishRodShinyDedault()

	local rods = {}
	sumArray={}
	selectArray={}

	local function getData(fishRodData)
		---清空数据
		for index, object in pairs(puseFrame:GetChildren()) do
			if object:IsA("TextButton") then
				object:Destroy()
			end
		end
		---右侧初始化
		FuseShinyMenu.Menu.Right.Rate.Rate.TextLabel.Text = "0%"
		FuseShinyMenu.Menu.Right.price.Label.Text = "0"
		for index, object in pairs(FuseShinyMenu.Menu.Right.Rate.dot:GetChildren()) do
			if object:IsA("Frame") then
				object:WaitForChild("On").Enabled = false
				object:WaitForChild("Off").Enabled = true
				object:WaitForChild("UIStroke").Enabled = false
			end
		end
		for k,v in pairs(fishRodData["ownFishRodList"]) do
			--跳过已经装备的
			if table.find(fishRodData["usingFishRodList"],k) then
				continue
			end
			--跳过锁定的v
			if v.lock then
				continue
			end
			if v.fuse == 1 then
				local fishRodInfo = FishRodHelper.GetFishRod(v.name)
				local PreFishRod = FishRodFuseFolder:WaitForChild(fishRodInfo.quality):Clone()
				PreFishRod.Name = tostring(k)
				PreFishRod.Frame.imgPet.Image = fishRodInfo.img
				PreFishRod.Frame.Power.Text = NumberFormat.AbbreviateNumber(fishRodInfo.baseMultiplier,2)

				local levelUp = 1
				levelUp =  1 + (v.level * 0.05)
				-- Store the rod with its Power value and reference to PreFishRod
				table.insert(rods,{
					rod = PreFishRod,
					power = fishRodInfo.baseMultiplier * levelUp
				})
			end-- Sort rods by power in descending order
			table.sort(rods, function(a, b)
				return a.power > b.power
			end)
			-- Set LayoutOrder for each rod based on sorted power
			for index, rodData in ipairs(rods) do
				rodData.rod.LayoutOrder = index  -- Set LayoutOrder according to the sorted order
				rodData.rod.Parent = puseFrame  -- Parent the rod to rodMenuFrame
			end
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end

--选择闪耀鱼竿
function FishRodFuseController:SelectShinyFishRod(fishRodid)
	local function getData(fishRodData)
		--点击已经点击的
		if table.find(selectArray,tostring(fishRodid)) then
			--只有一个，点击这一个，清空选择，重新展示合成
			if #(selectArray)==1 then
				sumArray={}
				selectArray={}
				puseFrame.CanvasPosition=Vector2.new(0,0)
				FishRodFuseController.OpenFishRodShinyDedault()
				return
			else	--有多个，点击移除点击的
				table.remove(selectArray,table.find(selectArray,tostring(fishRodid)))
			end
		else	--点击没有点击的
			--没有，点击第一个，加入选择数组，将一样的显示出来
			if #(sumArray)==0 then
				for k, v in pairs(fishRodData.ownFishRodList) do
					if v.name == fishRodData.ownFishRodList[fishRodid].name and v.lock == fishRodData.ownFishRodList[fishRodid].lock then
						table.insert(sumArray,k)
					end
				end
				table.insert(selectArray,fishRodid)
				puseFrame.CanvasPosition=Vector2.new(0,0)
			else	--点击加一个
				if #(selectArray)==5  then
					return
				end
				table.insert(selectArray,fishRodid)
			end
		end
		-----已经选择的打勾
		for index, object in ipairs(puseFrame:GetChildren()) do
			if object:IsA("TextButton") then
				if table.find(selectArray,object.Name) then
					object.Frame.imgEquip.Visible = true
				else
					object.Frame.imgEquip.Visible = false
				end
				if table.find(sumArray,object.Name) then
					continue
				else
					object:Destroy()
				end
			end
		end
		FuseShinyMenu.Menu.Right.Rate.Rate.TextLabel.Text = math.ceil((#selectArray)*(20)).."%"
		FuseShinyMenu.Menu.Right.price.Label.Text = "500"
		for index, object in pairs(FuseShinyMenu.Menu.Right.Rate.dot:GetChildren()) do
			if object:IsA("Frame") then
				if tonumber(object.Name) <= math.ceil(#selectArray) then
					object:WaitForChild("On").Enabled = true
					object:WaitForChild("Off").Enabled = false
				else
					object:WaitForChild("On").Enabled = false
					object:WaitForChild("Off").Enabled = true
				end
			end
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end

-- 目标Frame的名字
local loopCount = 2 -- 循环次数
local interval = 0.1 -- 每个帧闪烁间隔

-- 获取子Frame
local frames = {}

-- 隐藏所有Frame的UIStroke
local function hideAllStrokes()
	for _, frame in pairs(frames) do
		local stroke = frame:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Enabled = false
		end
	end
end
-- 显示指定Frame的UIStroke
local function showStroke(index)
	hideAllStrokes()
	local frame = frames[index]
	if frame then
		local stroke = frame:FindFirstChildOfClass("UIStroke")
		if stroke then
			stroke.Enabled = true
		end
	end
end
-- 动画效果：循环指定次数后停在目标点
local function animateToPoint(fuseMenu,finalPoint, loops, interval)
	for i = 1, 5 do
			local frame = fuseMenu:FindFirstChild(tostring(i))
		if frame then
			table.insert(frames, frame)
		end
	end
	for i = 1, loops do
		for j = 1, #frames do
			showStroke(j)
			wait(interval)
		end
	end

	-- 最后停在目标点
	for i = 1, finalPoint do
		showStroke(i)
		wait(interval)
	end
end

-----------------------------彩虹合成-------------------------------
local FuseRainbowMenu = player.PlayerGui:WaitForChild("MainMenu").CenterMenu.FuseRainbowMenu
local BtnCloseFuseRainbow = FuseRainbowMenu.Menu.Exit.TextButton
local puseRainbowFrame = FuseRainbowMenu.Menu.Left.List
local FishRodFuseRainbowFolder = puseRainbowFrame.Folder.Frame
local BtnCraftRainbow = FuseRainbowMenu.Menu.Right.Button.TextButton

---合成动画
function SuccessAnim(tt,result)
	local frrrr
	if tt then
		frrrr = FuseShinyMenu.Menu.Right.Rate.dot
	else
		frrrr = FuseRainbowMenu.Menu.Right.Rate.dot
	end
	if result then
		animateToPoint(frrrr, 1, loopCount, interval)
		MainGuiController:ShowMessage("Fuse successful!")
		print("成功")
	else
		animateToPoint(frrrr, 5, loopCount, interval)
		MainGuiController:ShowMessageEffect("warning",nil,"Fuse failed!")
		print("失败")
	end
end

----点击合成
function FishRodFuseController:ClickFuse()
	local successGaiLv=FuseShinyMenu.Menu.Right.Rate.Rate.TextLabel.Text
	FishRodFuseService:ClickFuse(selectArray,successGaiLv):andThen(function(result,message)

		sumArray={}
		selectArray={}

		if result then
			SuccessAnim(true,true)
		else
			if message=="Fuse Fail !" then
				SuccessAnim(true,false)
			else
				MainGuiController:ShowMessageEffect("warning",nil,message)
			end
		end
		wait(1.5)
		FishRodFuseController.OpenFishRodShinyDedault()
	end)
end

-----------------------------彩虹合成-------------------------------
local sumRainbowArray={}
local selectRainbowArray={}

--打开合成界面
function FishRodFuseController:OpenFishRodRainbowDedault()

	local rods = {}
	sumRainbowArray={}
	selectRainbowArray={}

	local function getData(fishRodData)
		---清空数据
		for index, object in pairs(puseRainbowFrame:GetChildren()) do
			if object:IsA("TextButton") then
				object:Destroy()
			end
		end
		---右侧初始化
		FuseRainbowMenu.Menu.Right.Rate.Rate.TextLabel.Text = "0%"
		FuseRainbowMenu.Menu.Right.price.Label.Text = "0"
		for index, object in pairs(FuseRainbowMenu.Menu.Right.Rate.dot:GetChildren()) do
			if object:IsA("Frame") then
				object:WaitForChild("On").Enabled = false
				object:WaitForChild("Off").Enabled = true
				object:WaitForChild("UIStroke").Enabled = false
			end
		end
		for k,v in pairs(fishRodData["ownFishRodList"]) do
			--跳过已经装备的
			if table.find(fishRodData["usingFishRodList"],k) then
				continue
			end
			--跳过锁定的v
			if v.lock then
				continue
			end
			if v.fuse == 2 then
				local fishRodInfo = FishRodHelper.GetFishRod(v.name)
				local PreFishRod = FishRodFuseRainbowFolder:WaitForChild(fishRodInfo.quality):Clone()
				PreFishRod.Name = tostring(k)
				PreFishRod.Frame.imgPet.Image = fishRodInfo.img
				PreFishRod.Frame.Power.Text = NumberFormat.AbbreviateNumber(fishRodInfo.baseMultiplier,2)

				local levelUp = 1
				levelUp =  1 + (v.level * 0.05)
				
				local fuseUp = 1
				fuseUp =  3
				-- Store the rod with its Power value and reference to PreFishRod
				table.insert(rods,{
					rod = PreFishRod,
					power = fishRodInfo.baseMultiplier * levelUp * fuseUp
				})
			end-- Sort rods by power in descending order
			table.sort(rods, function(a, b)
				return a.power > b.power
			end)
			-- Set LayoutOrder for each rod based on sorted power
			for index, rodData in ipairs(rods) do
				rodData.rod.LayoutOrder = index  -- Set LayoutOrder according to the sorted order
				rodData.rod.Parent = puseRainbowFrame  -- Parent the rod to rodMenuFrame
			end
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end

--选择彩虹鱼竿
function FishRodFuseController:SelectRainbowFishRod(fishRodid)
	local function getData(fishRodData)
		--点击已经点击的
		if table.find(selectRainbowArray,tostring(fishRodid)) then
			--只有一个，点击这一个，清空选择，重新展示合成
			if #(selectRainbowArray)==1 then
				sumRainbowArray={}
				selectRainbowArray={}
				puseFrame.CanvasPosition=Vector2.new(0,0)
				FishRodFuseController.OpenFishRodRainbowDedault()
				return
			else	--有多个，点击移除点击的
				table.remove(selectRainbowArray,table.find(selectRainbowArray,tostring(fishRodid)))
			end
		else	--点击没有点击的
			--没有，点击第一个，加入选择数组，将一样的显示出来
			if #(sumRainbowArray)==0 then
				for k, v in pairs(fishRodData.ownFishRodList) do
					if v.name == fishRodData.ownFishRodList[fishRodid].name and v.lock == fishRodData.ownFishRodList[fishRodid].lock then
						table.insert(sumRainbowArray,k)
					end
				end
				table.insert(selectRainbowArray,fishRodid)
				puseFrame.CanvasPosition=Vector2.new(0,0)
			else	--点击加一个
				if #(selectRainbowArray)==5  then
					return
				end
				table.insert(selectRainbowArray,fishRodid)
			end
		end
		-----已经选择的打勾
		for index, object in ipairs(puseRainbowFrame:GetChildren()) do
			if object:IsA("TextButton") then
				if table.find(selectRainbowArray,object.Name) then
					object.Frame.imgEquip.Visible = true
				else
					object.Frame.imgEquip.Visible = false
				end
				if table.find(sumRainbowArray,object.Name) then
					continue
				else
					object:Destroy()
				end
			end
		end
		FuseRainbowMenu.Menu.Right.Rate.Rate.TextLabel.Text = math.ceil((#selectRainbowArray)*(20)).."%"
		FuseRainbowMenu.Menu.Right.price.Label.Text = "2000"
		for index, object in pairs(FuseRainbowMenu.Menu.Right.Rate.dot:GetChildren()) do
			if object:IsA("Frame") then
				if tonumber(object.Name) <= math.ceil(#selectRainbowArray) then
					object:WaitForChild("On").Enabled = true
					object:WaitForChild("Off").Enabled = false
				else
					object:WaitForChild("On").Enabled = false
					object:WaitForChild("Off").Enabled = true
				end
			end
		end
	end
	FishRodService:GetFishRodData(player):andThen(getData)
end

----点击合成
function FishRodFuseController:ClickRainbowFuse()
	local successGaiLv=FuseRainbowMenu.Menu.Right.Rate.Rate.TextLabel.Text
	FishRodFuseService:ClickFuse(selectArray,successGaiLv):andThen(function(result,message)

		sumRainbowArray={}
		selectRainbowArray={}

		if result then
			SuccessAnim(false,true)
		else
			if message=="Fuse Fail !" then
				SuccessAnim(false,false)
			else
				MainGuiController:ShowMessageEffect("warning",nil,message)
			end
		end
		wait(1.5)
		FishRodFuseController.OpenFishRodRainbowDedault()
	end)
end

function FishRodFuseController:KnitInit()
	FishRodService = Knit.GetService("FishRodService")
	FishRodFuseService = Knit.GetService("FishRodFuseService")

	MainGuiController = Knit.GetController("MainGuiController")
end

function FishRodFuseController:KnitStart()
	BtnCloseFuseShiny.MouseButton1Click:Connect(function()
		local frameName = "FuseShinyMenu"
		FrameTrigger.CloseFram(frameName)
	end)
	BtnCraftShiny.MouseButton1Click:Connect(function()
		self.ClickFuse()
	end)
end

return FishRodFuseController