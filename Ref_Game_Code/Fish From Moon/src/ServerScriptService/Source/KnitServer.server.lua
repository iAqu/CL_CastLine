
local startTick = tick()

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit.AddServices(game:GetService("ServerScriptService").ServerModules.Services)
Knit.Start():catch(warn)

print("[SERVER] official-9.0.1 Loaded: ", tick() - startTick)