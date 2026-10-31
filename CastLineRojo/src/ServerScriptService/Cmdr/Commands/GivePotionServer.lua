local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local PotionService = require(ServerScriptService.Services.PotionService)
local PotionFeatureHelper = require(game:GetService("ReplicatedStorage").Modules.PotionFeatureHelper)

return function (context, player: Player?, potionId: string, amount: number?)
	if not PotionFeatureHelper.IsAcquisitionEnabled() then
		return PotionFeatureHelper.ACQUISITION_DISABLED_MESSAGE
	end
	local newPlayer = if player then player else context.Executor

    amount = amount or 1
    
    local playerData = PlayerDataService:GetAllData(newPlayer)
    if not playerData then
        return "No Profile found for player"
    end

    PotionService:AdjustPotionCount(newPlayer, potionId, amount)

    return "Given Potion!"
end
