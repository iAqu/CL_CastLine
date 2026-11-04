local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

--获取工具类
local TimeFormat = require(ReplicatedStorage.Source.Utils.TimeFormat)

local PlayerService
local GamePassService
local PlayerBoostService
local PlayerResourceService

local VIPService =Knit.CreateService {
	Name = "VIPService",
	Client = {
		ChangePassVIP = Knit.CreateSignal(),
	}
}

--领取每日VIP宝箱
function VIPService.Client:GetVIPRewards(player)
	local playerData = PlayerService:GetPlayerData(player)
	local VIPTime = playerData.VIPTime
	if game.Workspace:GetServerTimeNow() - VIPTime < 24*60*60 then
		return false
	else
		PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",1)
		
		local playerData = PlayerService:GetPlayerData(player)
		playerData.VIPTime = game.Workspace:GetServerTimeNow()
		PlayerService:UpdatePlayerData(player, playerData)
		VIPService:ChangePassVIP(player)
		return true
	end
end
--获取玩家资源数据
function VIPService.Client:GetPlayerAndPassData(player)
	local playerData = PlayerService:GetPlayerData(player)
	local isVIP = GamePassService:IsPlayerHaveGamePass(player,"VIP")
	return playerData,isVIP
end

function VIPService:ChangePassVIP(player)
	self.Client.ChangePassVIP:Fire(player)
end

function VIPService:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	GamePassService = Knit.GetService("GamePassService")
	PlayerService = Knit.GetService("PlayerService")
end
function VIPService:KnitStart()

end

return VIPService
