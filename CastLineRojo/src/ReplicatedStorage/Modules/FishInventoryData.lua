local ReplicatedFirst = game:GetService("ReplicatedFirst")
local FishesData = require(ReplicatedFirst:WaitForChild("Data"):WaitForChild("FishesData"))

local inventory = {}
for fishId, fish in pairs(FishesData) do
	local entry = table.clone(fish)
	entry.ItemID = fishId
	inventory[fishId] = entry
end

return inventory
