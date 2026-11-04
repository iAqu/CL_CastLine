local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerService
local PlayerResourceService

local JoinGroupService =Knit.CreateService {
	Name = "JoinGroupService",
	Client = {
		ChangeGroupTime = Knit.CreateSignal(),
	}
}

function JoinGroupService:ChangeGroupTime(player)
	self.Client.ChangeGroupTime:Fire(player)
end

function JoinGroupService.Client:JoinGameGroupTime(player)
	local playerData = PlayerService:GetPlayerData(player)
	local joinGroupTime = playerData.joinGroupTime
	if game.Workspace:GetServerTimeNow() - joinGroupTime < 24*60*60 then
		return false
	else
		print("可以领取奖励")
		PlayerResourceService:ChangeGems(player,1500)
		playerData.joinGroupTime=game.Workspace:GetServerTimeNow()
		PlayerService:UpdatePlayerData(player, playerData)
		JoinGroupService:ChangeGroupTime(player)
		return true
	end
end
--加入游戏群组奖励
function JoinGroupService.Client:JoinGameGroup(player)
	--判断玩家是否已经领取过奖励
	local playerData = PlayerService:GetPlayerData(player)
	local isJoinGroup = playerData.joinGroup
	if isJoinGroup then
		print("已领取奖励")
		return false
	else
		PlayerResourceService:ChangeGems(player,5000)
		playerData.joinGroup = true
		playerData.joinGroupTime = game.Workspace:GetServerTimeNow()-24*60*60
		PlayerService:UpdatePlayerData(player, playerData)
		
		JoinGroupService:ChangeGroupTime(player)
		return true
	end
end

function JoinGroupService:KnitInit()
	PlayerService = Knit.GetService("PlayerService")
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end
function JoinGroupService:KnitStart()
	
end

return JoinGroupService
