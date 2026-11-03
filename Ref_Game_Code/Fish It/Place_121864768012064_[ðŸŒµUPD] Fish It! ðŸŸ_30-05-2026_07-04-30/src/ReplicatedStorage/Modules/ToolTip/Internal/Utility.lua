-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Trove = require(ReplicatedStorage.Packages.Trove)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ColorUtility = require(ReplicatedStorage.Modules.ColorUtility)
local EventTags = require(ReplicatedStorage.Modules.EventTags)
local t = {}
Trove.new()
local t2 = {
	UsernameTrove = Trove.new(),
	Templates = {
		TradeLocked = script:WaitForChild("TradeLocked"),
		Untradable = script:WaitForChild("Untradable")
	},
	WipeCache = function(p1) --[[ WipeCache | Line: 21 | Upvalues: t (copy) ]]
		table.clear(t)
	end
}
function t2.Reset(p1) --[[ Reset | Line: 25 | Upvalues: t2 (copy) ]]
	t2.UsernameTrove:Clean()
end
function t2.FetchUsername(p1) --[[ FetchUsername | Line: 29 | Upvalues: Players (copy), t (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 30 | Upvalues: Players (ref), p1 (copy) ]]
		return Players:GetNameFromUserIdAsync(p1)
	end)
	if v1 then
		t[p1] = v2
		return tostring(v2)
	else
		return tostring(p1)
	end
end
function t2.GetUsername(p1) --[[ GetUsername | Line: 43 | Upvalues: t (copy), t2 (copy) ]]
	local v1 = t[p1]
	if v1 then
		return v1
	else
		return t2.FetchUsername(p1)
	end
end
function t2.getTierData(p1) --[[ getTierData | Line: 52 | Upvalues: TierUtility (copy) ]]
	local v1 = p1.Probability or p1.ForcedProbability
	if v1 then
		return TierUtility:GetTierFromRarity(v1.Chance)
	else
		return TierUtility:GetTier(p1.Data.Tier)
	end
end
function t2.getEventTagData(p1, p2) --[[ getEventTagData | Line: 65 | Upvalues: EventTags (copy) ]]
	local v1 = if p2 and p2.EventTag then p2.EventTag elseif p1.EventTag then p1.EventTag else nil
	if v1 then
		return EventTags[v1]
	end
end
function t2.getColorBlend(p1, p2) --[[ getColorBlend | Line: 77 | Upvalues: ColorUtility (copy) ]]
	local t = {}
	if p2 then
		table.insert(t, p2.TierColor)
	end
	if p1 then
		table.insert(t, p1.TierColor)
	end
	return ColorUtility:BlendColors(t)
end
function t2.formatDHMS(p1) --[[ formatDHMS | Line: 91 ]]
	local v1 = p1 % 86400
	local v2 = math.floor(p1 / 86400)
	local v3 = math.floor(v1 / 3600)
	local v4 = math.floor(v1 % 3600 / 60)
	local v5 = math.floor(p1 % 60)
	if v2 >= 1 then
		return string.format("%02dd %02dh %02dm %02ds", v2, v3, v4, v5)
	end
	if v3 >= 1 then
		return string.format("%02dh %02dm %02ds", v3, v4, v5)
	else
		return string.format("%02dm %02ds", v4, v5)
	end
end
return t2