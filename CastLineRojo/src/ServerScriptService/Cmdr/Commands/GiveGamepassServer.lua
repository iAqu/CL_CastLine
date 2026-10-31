local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local GamePassService = require(ServerScriptService.Services.GamePassService)

return function (context, player: Player?, gamepassId: string)
    local newPlayer = if player then player else context.Executor
    
    local playerData = PlayerDataService:GetAllData(newPlayer)
    if not playerData then
        return "No Profile found for player"
    end

    if playerData.GamePasses[gamepassId] then
        return "Player already has this gamepass"
    end

    -- playerData.Gamepasses[gamepassId] = true

    GamePassService:GiveGamePass(newPlayer, gamepassId)

    return "Given Gamepass!"
end

