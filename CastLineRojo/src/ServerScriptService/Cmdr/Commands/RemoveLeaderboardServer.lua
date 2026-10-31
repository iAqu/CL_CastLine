local ServerScriptService = game:GetService("ServerScriptService")

local GlobalLeaderboardService = require(ServerScriptService.Services.GlobalLeaderboardService)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

return function (context, playerId)
    -- local newPlayer = if player then player else context.Executor
    
    -- local profile = PlayerDataService:GetProfile(player)
    -- if not profile then 
    --     return "No Profile found for player"
    -- end
    
    GlobalLeaderboardService:RemoveLeaderboard(playerId)
end

