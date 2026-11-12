local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Constants)

local GamePassEffectUtil = {}

local function ownsGamePass(playerData, gamePassId: string): boolean
	return typeof(playerData) == "table"
		and typeof(playerData.GamePasses) == "table"
		and playerData.GamePasses[gamePassId] == true
end

function GamePassEffectUtil.GetSaleMultiplier(playerData): number
	local bonus = 0
	if ownsGamePass(playerData, Constants.GAMEPASS.VIP) then
		bonus += 0.2
	end
	if ownsGamePass(playerData, Constants.GAMEPASS.DOUBLE_WINS) then
		bonus += 1
	end
	return 1 + bonus
end

function GamePassEffectUtil.GetItemLuckMultiplier(playerData): number
	local bonus = 0
	if ownsGamePass(playerData, Constants.GAMEPASS.SUPER_LUCK) then
		bonus += 0.5
	end
	if ownsGamePass(playerData, Constants.GAMEPASS.MEGA_LUCK) then
		bonus += 2
	end
	return 1 + bonus
end

return GamePassEffectUtil
