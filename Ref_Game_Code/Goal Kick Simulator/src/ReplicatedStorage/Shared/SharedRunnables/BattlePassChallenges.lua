-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:11
-- Luau version 6, Types version 3
-- Time taken: 0.001579 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
local module_upvr_2 = {
	SCORE_GOAL = {
		RawText = "Score Goals!";
		Text = "Score %s goals!";
		MaxValue = 20;
	};
}
local tbl = {
	RawText = "Run!";
	Text = "Run %s studs.";
}
local function GetMaxValue(arg1, arg2) -- Line 14
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	return (Util_upvr.GameMath:GetSpeedValue(arg2.Stats.Speed) + 16) * 5
end
tbl.GetMaxValue = GetMaxValue
module_upvr_2.RUN = tbl
module_upvr_2.SCORE_GOAL_DISTANCE = {
	RawText = "Total Goal Distance!";
	Text = "Score goals for a total of %s studs!";
	GetMaxValue = function(arg1, arg2) -- Line 21, Named "GetMaxValue"
		return ((arg2.KickDistanceRecord or 0) + 100) * 20
	end;
}
module_upvr_2.SCORE_GOAL_STAR = {
	RawText = "Star Goals!";
	Text = "Make your Stars score %s goals!";
	MaxValue = 40;
}
module_upvr_2.EVENT_WINS = {
	RawText = "Win Events!";
	Text = "Win %s Events! (Top 3)";
	MaxValue = 1;
}
module_upvr_2.KICK_POWER_AREA = {
	RawText = "Kick from POWER AREA!";
	Text = "Kick from a POWER AREA for %s times!";
	MaxValue = 4;
}
local SeasonStart_upvr = Util_upvr.Settings.BATTLEPASSINFO.SeasonStart
local SeasonDuration_upvr = Util_upvr.Settings.BATTLEPASSINFO.SeasonDuration
function module_upvr.GetCurrentSeason(arg1) -- Line 46
	--[[ Upvalues[2]:
		[1]: SeasonStart_upvr (readonly)
		[2]: SeasonDuration_upvr (readonly)
	]]
	return math.floor((DateTime.now().UnixTimestamp - SeasonStart_upvr) / SeasonDuration_upvr) + 1
end
local function _(arg1) -- Line 49, Named "ExperienceFormula"
	return (arg1 * 30) ^ 1.55
end
function module_upvr.CalculateLevelExperience(arg1, arg2) -- Line 53
	assert(arg2, "Level was not given!")
	return (arg2 * 30) ^ 1.55
end
function module_upvr.GetExperienceNeeded(arg1, arg2) -- Line 58
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr:CalculateLevelExperience(arg2 + 1) - module_upvr:CalculateLevelExperience(arg2)
end
function module_upvr.GetChallengeData(arg1, arg2) -- Line 63
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	return module_upvr_2[arg2]
end
function module_upvr.GetList(arg1) -- Line 67
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr_2 (readonly)
	]]
	return Util_upvr.Table.CopyDictionary(module_upvr_2)
end
function module_upvr._GetList(arg1) -- Line 71
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	return module_upvr_2
end
Util_upvr.BattlePassChallenges = module_upvr
return module_upvr