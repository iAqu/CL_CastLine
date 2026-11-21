local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local WeightFormat = require(ReplicatedStorage.Modules.WeightFormat)

local Config = {}

export type BoardType = "Wins" | "Weight" | "Fish" | "Playtime"
export type RankRow = { Rank: number, UserId: number, DisplayName: string, Value: number }
export type Rankings = { Revision: number, Boards: { [BoardType]: { RankRow } } }

Config.Types = { "Wins", "Weight", "Fish", "Playtime" } :: { BoardType }
Config.MaxRows = 50
Config.AssetsName = "GlobalLeaderboardAssets"
Config.AnchorsName = "LeaderboardAnchors"

Config.Boards = {
	Wins = { Field = "TotalCashEarned", Store = "GlobalLeaderboard_CashEarned_V2", Label = "Cash" },
	Weight = { Field = "MaxCaughtFishWeightTenths", Store = "GlobalLeaderboard_MaxCaughtFishWeightTenths_V1", Label = "Weight" },
	Fish = { Field = "TotalFishCaught", Store = "GlobalLeaderboard_TotalFishCaught_V1", Label = "Fish" },
	Playtime = { Field = "PlayTime", Store = "GlobalLeaderboard_PlayTime_V1", Label = "Time" },
}

-- Largest integer representable by a Luau number below the signed 64-bit limit.
local MAX_SCORE = 9_223_372_036_854_774_784
local PLOT_COUNT = 6

function Config.NormalizeScore(value: unknown): number
	local numeric = tonumber(value)
	if not numeric or numeric ~= numeric or math.abs(numeric) == math.huge then
		return 0
	end
	return math.clamp(math.round(numeric), 0, MAX_SCORE)
end

function Config.RecordCatch(data, weight: number)
	data.TotalFishCaught = math.min(Config.NormalizeScore(data.TotalFishCaught) + 1, MAX_SCORE)
	data.MaxCaughtFishWeightTenths = math.max(
		Config.NormalizeScore(data.MaxCaughtFishWeightTenths),
		Config.NormalizeScore(weight * 10)
	)
end

function Config.GetNeighborGaps(slot: unknown): (string?, string?)
	if type(slot) ~= "number" or slot < 1 or slot > PLOT_COUNT or slot % 1 ~= 0 then
		return nil, nil
	end
	return string.format("Gap_%d_%d", (slot - 2) % PLOT_COUNT + 1, slot),
		string.format("Gap_%d_%d", slot, slot % PLOT_COUNT + 1)
end

function Config.FormatValue(boardType: BoardType, value: number): string
	if boardType == "Wins" then
		return NumberUtil.FormatWinsAmount(value, 2)
	elseif boardType == "Weight" then
		return WeightFormat.FormatKg(value / 10)
	elseif boardType == "Playtime" then
		return if value >= 86_400 then NumberUtil.ConvertToDHM_Unit(value) else NumberUtil.ConvertToHMS_Unit(value)
	end
	return NumberUtil.FormatNumberStartKWithDecimal(value, 2)
end

return Config
