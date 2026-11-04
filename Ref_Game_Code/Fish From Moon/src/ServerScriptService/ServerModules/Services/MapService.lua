--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--获取模组
local MapDataDAO = require(ServerScriptService.Source.DAO.MapDataDAO)
local MapHelper = require(ReplicatedStorage.Config.MapHelper)
local Tool=require(ReplicatedStorage.Source.Utils.Tool)
local Knit = require(ReplicatedStorage.Packages.Knit)

local MainGuiService
local PlayerResourceService

local MapService = Knit.CreateService {
	Name = "MapService",
	Client = {
		ChangeMapDoor = Knit.CreateSignal(),
		ChangeMapData = Knit.CreateSignal(),
		ChangeMaxLine = Knit.CreateSignal(),

		ChangeCam = Knit.CreateSignal(),
	},
}

function MapService.Client:ChangeMapWorld(player,mapId)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	local maxMap=playerResourceData.maxWorld
	if tonumber(mapId)>tonumber(maxMap) then
	else
		playerResourceData.world=mapId
		PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
	end
end
--添加
function MapService:AddMap(player,mapId)
	local mapData = MapDataDAO.GetMapData(player)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)

	if table.find(mapData.lock,tostring(mapId+1)) then
	else
		table.insert(mapData.lock,tostring(mapId+1))
		playerResourceData.maxWorld=mapId+1
		PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
		MapService:UpdateMapData(player,mapData)

		if mapId==1 then
			local BadgeId = 2898694647628183
			Tool.AwardBadge(player,BadgeId)
		end
		if mapId==2 then
			local BadgeId = 643719459568393
			Tool.AwardBadge(player,BadgeId)
		end
		if mapId==3 then
			local BadgeId = 864649802450234
			Tool.AwardBadge(player,BadgeId)
		end
	end
	MapService:ChangeMapDoor(player)
end

--购买地图
function MapService.Client:BuyMap(player,mapId)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	local needMoney = MapHelper.GetMapPrice(mapId)
	if playerResourceData.moneys >= needMoney then
		PlayerResourceService:ChangeMoneys(player,-(needMoney))
		MapService:AddMap(player,mapId)
		return true
	else
		MainGuiService:ShowMessageEffect(player,"warning",nil,"need more moneys!")
		return false
	end
end

--添加
function MapService:AddTeleportMap(player,mapId)
	local mapData = MapDataDAO.GetMapData(player)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)

	if table.find(mapData.teleptLock,tostring(mapId)) then
	else
		table.insert(mapData.teleptLock,tostring(mapId))
		MapService:UpdateMapData(player,mapData)
	end
	MapService:ChangeMapData(player)
	MapService:ChangeMapDoor(player)
end
--购买地图
function MapService.Client:BuyTeleport(player,mapId)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	local needGem = MapHelper.GetMapGemPrice(mapId)
	if playerResourceData.gems >= needGem then
		PlayerResourceService:ChangeGems(player,-(needGem))
		MapService:AddTeleportMap(player,mapId)
		return true
	else
		MainGuiService:ShowMessageEffect(player,"warning",nil,"need more gems!")
		return false
	end
end

---新世界修改点
--世界传送
function MapService:TeleportWorld(player,world)
	MainGuiService:ScreenSwitching(player,1.5)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	playerResourceData.world = world
	PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
	if world > 4  then
		MainGuiService:ShowMessage(player,"Tip : Not yet open world 5")
	else
		local TeleportPart = ReplicatedStorage.Reference:WaitForChild("TeleportWorld"..world).Value
		player.Character:PivotTo(TeleportPart:GetPivot())
	end
	-------新世界修改点
	MapService:ChangeCam(player,world)
end
--传送地图
function MapService.Client:GoMap(player,mapId)
	MapService:TeleportWorld(player,mapId)
	return true
end
--ChangeMapData
function MapService:ChangeMapData(player)
	self.Client.ChangeMapData:Fire(player)
end
--ChangeMapDoor
function MapService:ChangeMapDoor(player)
	self.Client.ChangeMapDoor:Fire(player)
end
--ChangeMaxLine
function MapService:ChangeMaxLine(player)
	self.Client.ChangeMaxLine:Fire(player)
end
--InitMap
function MapService:InitMapWorld(player)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	playerResourceData.world=1
	PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
end

function MapService:ChangeCam(player,teleId)
	self.Client.ChangeCam:Fire(player,teleId)
end

--获取玩家数据和地图
function MapService.Client:GetMAndPData(player)
	local mapData = MapDataDAO.GetMapData(player)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	return mapData,playerResourceData
end
--获取玩家数据
function MapService:GetMapData(player)
	local mapData = MapDataDAO.GetMapData(player)
	return mapData
end
--获取玩家数据 客户端
function MapService.Client:GetMapData(player)
	local mapData = MapDataDAO.GetMapData(player)
	return mapData
end
--更新玩家数据
function MapService:UpdateMapData(player,mapData)
	MapDataDAO.UpdateMapData(player,mapData)
end

function MapService:KnitInit()
	MainGuiService = Knit.GetService("MainGuiService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function MapService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		MapService:ChangeMapDoor(player)
		MapService:ChangeMaxLine(player)
		MapService:InitMapWorld(player)
	end)
end

return MapService