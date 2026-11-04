--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerResourceService

local SettingService =Knit.CreateService{
	Name = "SettingService",
	Client = {}
}
---交易
function SettingService.Client:ChangeTrade(player,isTrade)
	return self.Server:ChangeTrade(player,isTrade)
end
function SettingService:ChangeTrade(player,isTrade)
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	playerResourceData.isTrade=isTrade
	PlayerResourceService:UpdatePlayerResourceData(player,playerResourceData)
	return true
end

function SettingService:KnitStart()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function SettingService:KnitInit()

end

return SettingService
