local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local gamepasses = {}

for gamepassID in PurchaseDataHelper.GetGamePassesData() do
    table.insert(gamepasses, gamepassID)
end

return function (registry)
    registry:RegisterType("gamepass", registry.Cmdr.Util.MakeEnumType("gamepass", gamepasses))
end
