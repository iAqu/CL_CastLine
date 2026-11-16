local ReplicatedFirst = game:GetService("ReplicatedFirst")

local FishingAssets = require(script.Parent.FishingAssets)
local FishingConfig = require(script.Parent.FishingConfig)
local RodsData = require(ReplicatedFirst:WaitForChild("Data"):WaitForChild("RodsData"))

local RodInventory = {}

function RodInventory.Owns(data, rodId: string): boolean
	return rodId == FishingConfig.DefaultRodId
		or (typeof(data.OwnedRods) == "table" and data.OwnedRods[rodId] == true)
end

function RodInventory.GetEquippedId(data): string
	local rodId = data.EquippedRodId
	local rod = if typeof(rodId) == "string" then RodsData[rodId] else nil
	if rod and RodInventory.Owns(data, rodId) and FishingAssets.GetRod(rod.Model) then
		return rodId
	end
	return FishingConfig.DefaultRodId
end

function RodInventory.Reconcile(data)
	if typeof(data.OwnedRods) ~= "table" then
		data.OwnedRods = {}
	end
	data.OwnedRods[FishingConfig.DefaultRodId] = true
	data.EquippedRodId = RodInventory.GetEquippedId(data)
end

return RodInventory
