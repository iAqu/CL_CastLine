local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Constants = require(ReplicatedStorage.Modules.Constants)
local MovementSpeedUtil = require(ReplicatedStorage.Modules.MovementSpeedUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

return function(_context, player: Player, level: number)
	local outcome = Knit.GetService("UpgradeService"):SetUpgradeLevel(player, Constants.UPGRADE_ID.MOVE_SPEED, level)
	if not outcome.ok then
		return outcome.message
	end

	local profile = PlayerDataService:GetProfile(player)
	local zonePercent = player:GetAttribute(MovementSpeedUtil.ZONE_WALK_SPEED_PERCENT_ATTRIBUTE)
	local walkSpeed = MovementSpeedUtil.CalculateWalkSpeed(profile.Data, zonePercent)
	return string.format("Set %s's move speed level to %d (WalkSpeed: %d)", player.Name, outcome.newLevel, math.round(walkSpeed))
end
