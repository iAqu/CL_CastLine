local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerResourceService
local PlayerBoostService
local CdkRewardService

local CodeService =Knit.CreateService {
	Name = "CodeService",
	Client = {
	}
}

--判断玩家是否领取过奖励
function CodeService:isPlayerGetCdkReward(player,cdk)
	local result = false
	local cdkRewardData = CdkRewardService:GetCdkRewardData(player)
	if cdkRewardData and cdkRewardData[cdk] then
		result = true
	end				
	return result
end
-----新世界修改点
--兑换码奖励
function CodeService.Client:UseCdk(player,cdk)
	--判断玩家是否已经领取过奖励
	local result = CodeService:isPlayerGetCdkReward(player,string.lower(cdk))
	if not result then
		--给与玩家奖励
		if tostring(string.lower(cdk)) == "release" then
			--记录玩家已经领取奖励
			local cdkRewardData = CdkRewardService:GetCdkRewardData(player)
			cdkRewardData[string.lower(cdk)] = true
			CdkRewardService:UpdateCdkRewardData(player, cdkRewardData)

			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",1)
			return true,"Code : You get MoneyPotion!"
		end

		return false,"Code : Not Valid Code!"
	else
		return false,"Code : Already Used!"
	end
end

function CodeService:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	CdkRewardService = Knit.GetService("CdkRewardService")
end
function CodeService:KnitStart()

end

return CodeService