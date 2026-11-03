-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
require(ReplicatedStorage.Shared.StringLibrary)
local t = {}
if UserPriority:IsTradePlaza() then
	t["Most RAP"] = {
		IgnoreZeroScores = true,
		PostScoreUponRemoving = true,
		Placements = 50,
		VisualPlacements = 100,
		Key = "MostRAPV1",
		Path = { "RAP" }
	}
else
	t["Monthly Caught Fish"] = {
		PostScoreUponRemoving = true,
		Placements = 100,
		VisualPlacements = 50,
		Key = "CaughtFishV2",
		Path = { "Statistics", "FishCaught" }
	}
	t["Rarest Caught Fish"] = {
		PostScoreUponRemoving = false,
		Placements = 10,
		VisualPlacements = 10,
		Key = "RarestCaughtFishV2"
	}
	t["Event Classic Variants Caught"] = {
		PostScoreUponRemoving = true,
		Placements = 500,
		VisualPlacements = 100,
		Key = "RetroVariantsCaughtV1",
		Path = { "RetroVariantsCaught" }
	}
end
return t