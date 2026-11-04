--获取服务
local AvatarEditorService = game:GetService("AvatarEditorService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local MapHelper = require(ReplicatedStorage.Config.MapHelper)
local Monetization = require(ReplicatedStorage.Config.Monetization)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local MapService
local PlayerService
local GamePassService
local PlayerResourceService

local MainGuiController

----GUI
local MapMenu=player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.MapMenu
local mapFrame=MapMenu.Frame.Container.List.Frame

local BtnOpen=player.PlayerGui:WaitForChild("MainUi",5).MainHud.Left.Holder.Teleport.btn
local BtnClose=MapMenu.Frame.Exit.TextButton

local MapFolder = mapFrame.Folder.Frame
local MapGui = MapFolder.worldButton

local frameName="MapMenu"

local MapController = Knit.CreateController { Name = "MapController" }

local function showFavorite()
	local function getData(data)
		if data.isFavorite then
		else
			AvatarEditorService:PromptSetFavorite(130840440285347,Enum.AvatarItemType.Asset,true)
			PlayerService:SetFGame()
		end
	end
	PlayerService:GetPlayerData(player):andThen(getData)
end

local function changeMapData()
	local function getData(mapData,playerResourceData)
		local lock = mapData.lock
		local teleptLock = mapData.teleptLock
		---清空数据
		for index, object in pairs(mapFrame:GetChildren()) do 
			if object:IsA("Frame") and object.Name ~= "worldLine" then
				object:Destroy()
			end
		end
		local mapList = MapHelper.GetMap()
		local maxWorld = playerResourceData.maxWorld
		local world = playerResourceData.world
		if maxWorld==2 then
			showFavorite()
		end
		---克隆属性
		for k,v in pairs(mapList) do
			local mapid = k
			local mapGui = MapGui:Clone()
			mapGui.MapId.Value = mapid
			mapGui.GO.BG.Image = MapHelper.GetMapImg(k)
			mapGui.GO.Worldname.Text = MapHelper.GetMapName(k)
			mapGui.BUY.Lock.Text = NumberFormat.AbbreviateNumber(MapHelper.GetMapGemPrice(k),2)

			if MapHelper.GetMapDevice(k)[1].img ~= "" then
				mapGui.GO.pic1.Visible = true
			end
			if MapHelper.GetMapDevice(k)[2].img ~= "" then
				mapGui.GO.pic2.Visible = true
			end
			mapGui.GO.pic1.ImageLabel.Image = MapHelper.GetMapDevice(k)[1].img
			mapGui.GO.pic2.ImageLabel.Image = MapHelper.GetMapDevice(k)[2].img

			mapGui.GO.Pin.Visible = false
			if tonumber(mapid) == tonumber(world) then
				mapGui.GO.Pin.Visible = true
			end 

			mapGui.GO.Visible = false
			mapGui.OFF.Visible = true
			mapGui.BUY.Visible = false

			mapGui.LayoutOrder = v.layout

			if table.find(lock,tostring(mapid)) then
				mapGui.GO.Visible = false
				mapGui.BUY.Visible = true
				mapGui.OFF.Visible = false
			end
			if table.find(teleptLock,tostring(mapid)) then
				mapGui.GO.Visible = true
				mapGui.BUY.Visible = false
				mapGui.OFF.Visible = false
			end
			mapGui.Parent = mapFrame
		end
	end
	MapService:GetMAndPData(player):andThen(getData)
end

--打开界面
function MapController:OpenDedault()
	changeMapData()
end

function changeCam(teleId)
	----新世界修改点
	local cam=workspace.CurrentCamera
	local poss =Vector3.new(-9.482, 10, -50)

	poss=ReplicatedStorage.Reference:WaitForChild("TeleportWorld"..teleId).Value.Position

	local lookAt = player.Character.PrimaryPart.Position

	local cameraCFrame=CFrame.new(poss+Vector3.new(0,0,-10),lookAt)

	cam.CFrame=cameraCFrame
	FrameTrigger.CloseFram(frameName)
end

local function unlockDoor()
	PlayerResourceService:GetPlayerResourceData():andThen(function(playerResourceData)
		local maxWorld = playerResourceData.maxWorld
		local maxLine = playerResourceData.maxLine
		----新世界修改点
		for i = 1,4,1 do
			if maxWorld > i  then
				local doorName = "Level_" .. tostring(i)	
				if workspace.World.Door:FindFirstChild(doorName) then
					if workspace.World.Door[doorName]:FindFirstChild("Door") then
						workspace.World.Door[doorName].Door:Destroy()	
					end
				end 
			end 
		end
	end)
end

local function changeMaxLine()
	PlayerResourceService:GetPlayerResourceData():andThen(function(playerResourceData)
		local maxLine = playerResourceData.maxLine
		if maxLine == 0 then
		else
			if workspace:WaitForChild("MaxLine"):FindFirstChild("Door") then
				workspace:WaitForChild("MaxLine"):FindFirstChild("Door").Position = Vector3.new(0.665, 5.77, maxLine)
			else
				local mxl = ReplicatedStorage.Assets.MaxLine.Door:Clone()
				mxl.Position = Vector3.new(0.665, 5.77, maxLine)
				mxl.Parent = workspace:WaitForChild("MaxLine")
			end
		end
	end)
end

local function changeMapDoor()
	unlockDoor()
end

local function checkTeleportPass()
	if player:GetAttribute("FlyTime") then
		MainGuiController:ShowMessageEffect("warning",nil,"Teleportation is not possible during fishing!")
		return
	else
		GamePassService:IsPlayerHaveGamePass("Teleport"):andThen(function(result)
			if result then
				MapController:OpenDedault()
				FrameTrigger.OpenFram(frameName)
			else
				MarketplaceService:PromptGamePassPurchase(player,Monetization.Gamepasses.Teleport.Id)
			end
		end)
	end
end

function MapController:KnitInit()
	MapService = Knit.GetService("MapService")
	PlayerService = Knit.GetService("PlayerService")
	GamePassService = Knit.GetService("GamePassService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")

	MainGuiController = Knit.GetController("MainGuiController")
end

function MapController:KnitStart()

	BtnOpen.MouseButton1Click:Connect(function()
		checkTeleportPass()
	end)
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
	end)

	MapService.ChangeMapData:Connect(changeMapData)
	MapService.ChangeMapDoor:Connect(changeMapDoor)
	MapService.ChangeMaxLine:Connect(changeMaxLine)

	MapService.ChangeCam:Connect(changeCam)
end

return MapController