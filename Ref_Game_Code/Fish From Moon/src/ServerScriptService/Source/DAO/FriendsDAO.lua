--获取服务
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
--获取模块
--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)
--Friends在数据库中的名称
local dataServiceName = "Friends-FlyFish"
DataStore2.Combine("DATA",dataServiceName)

local FriendsDAO = {}

--获取数据库
local function getFriendsStore(player)
    local FriendsStore = DataStore2(dataServiceName,player)
    return FriendsStore
end

--获取数据库
function FriendsDAO.GetFriendsStore(player)
    return getFriendsStore(player)
end

--获取数据
function FriendsDAO.GetFriendsData(player)
	local FriendsStore = getFriendsStore(player)
	
	local FriendsDafaultData = {
		friendList={
			
		},
		getRewardList={
			
		},
	}
	local Friends = FriendsStore:GetTable(FriendsDafaultData)
    return Friends
end

--更新数据
function FriendsDAO.UpdateFriendsData(player,Friends)
    local FriendsStore = getFriendsStore(player)
    FriendsStore:Set(Friends)
end

return FriendsDAO
