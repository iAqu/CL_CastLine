local ReplicatedFirst = game:GetService("ReplicatedFirst")

local EggsData = require(ReplicatedFirst.Data.EggsData)

local eggIds = {}
for eggId in pairs(EggsData) do
	table.insert(eggIds, eggId)
end
table.sort(eggIds)

return function(registry)
	registry:RegisterType("egg", registry.Cmdr.Util.MakeEnumType("egg", eggIds))
end
