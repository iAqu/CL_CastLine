local ServerScriptService = game:GetService("ServerScriptService")

local RebirthService = require(ServerScriptService.Services.RebirthService)

return function (context)
    local player = context.Executor
    return RebirthService:Rebirth(player)
end
