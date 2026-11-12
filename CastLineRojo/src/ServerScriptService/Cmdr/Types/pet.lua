local ReplicatedFirst = game:GetService("ReplicatedFirst")

local PetsData = require(ReplicatedFirst.Data.PetsData)

local petIds = {}
for petId in pairs(PetsData) do
	table.insert(petIds, petId)
end
table.sort(petIds)

return function(registry)
	registry:RegisterType("pet", registry.Cmdr.Util.MakeEnumType("pet", petIds))
end
