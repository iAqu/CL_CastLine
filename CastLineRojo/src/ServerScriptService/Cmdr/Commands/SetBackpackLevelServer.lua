local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CarryCapacityUtil = require(ReplicatedStorage.Modules.CarryCapacityUtil)
local Constants = require(ReplicatedStorage.Modules.Constants)
local Knit = require(ReplicatedStorage.Packages.Knit)

return function(_context, player: Player, level: number)
	local outcome = Knit.GetService("UpgradeService"):SetUpgradeLevel(player, Constants.UPGRADE_ID.CARRY_WEIGHT, level)
	if not outcome.ok then
		return outcome.message
	end

	local capacity = tonumber(player:GetAttribute(CarryCapacityUtil.CAPACITY_ATTRIBUTE)) or 0
	return string.format("Set %s's backpack level to %d (Capacity: %dkg)", player.Name, outcome.newLevel, math.round(capacity))
end
