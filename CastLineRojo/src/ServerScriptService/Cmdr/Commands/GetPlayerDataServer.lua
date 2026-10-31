local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

return function (context, player: Player?, dataDirectory: string?)
    player = if player then player else context.Executor
    
    local profile = PlayerDataService:GetProfile(player)
    if not profile then 
        return "No Profile found for player"
    end
    
    if not dataDirectory then
        LogHelper.Print(profile.Data)
        return "All data printed!"
    end

    LogHelper.Print(profile.Data[dataDirectory])
    return "Data printed!"
end

