--获取服务
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--拿到数据中心
local DataStore2 = require(ServerScriptService.Source.Plugin.DataStore2)

local TenMinSavePerPlayer = {}

--玩家加入游戏
local function PlayerJoinGame(player)

	TenMinSavePerPlayer[player] = true
	while TenMinSavePerPlayer[player] do
		task.wait(600)
		DataStore2.SaveAll(player)
	end
end

--玩家离开游戏
local function PlayerRemoving(player)
	--不在循环记录玩家抽奖时间
	TenMinSavePerPlayer[player] = nil
end

Players.PlayerAdded:Connect(PlayerJoinGame)
Players.PlayerRemoving:Connect(PlayerRemoving)