local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

return function (context, player: Player?, amount: number)
    local newPlayer = if player then player else context.Executor
    
    local profile = PlayerDataService:GetProfile(player)
    if not profile then 
        return "No Profile found for player"
    end
    
    -- PlayerDataService:AdjustWins(newPlayer, amount)
    PlayerDataService:AdjustWins(newPlayer, amount - profile.Data.Wins)
    return "Adjusted!"
end

