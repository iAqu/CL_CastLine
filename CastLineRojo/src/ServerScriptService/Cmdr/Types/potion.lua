local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local potions = {}

for itemID, item in PurchaseDataHelper.GetAllData() do
    if item.Type == "Potion" then
        table.insert(potions, itemID)
    end
end

return function (registry)
    registry:RegisterType("potion", registry.Cmdr.Util.MakeEnumType("potion", potions))
end
