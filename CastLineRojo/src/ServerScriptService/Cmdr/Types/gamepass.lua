local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local gamepasses = {}

for gamepassID, gamepass in PurchaseDataHelper.GetAllData() do
    if gamepass.Type == "GamePass" then
        table.insert(gamepasses, gamepassID)
    end
end

return function (registry)
    registry:RegisterType("gamepass", registry.Cmdr.Util.MakeEnumType("gamepass", gamepasses))
end
