-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Areas = require(ReplicatedStorage.Areas)
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local Events = require(ReplicatedStorage.Events)
local SpecialItems = require(script.SpecialItems)
local t = {
	{
		Position = 1,
		Percentile = 0.25,
		Reward = RewardInfo.potionReward("Luck I Potion", 3)
	},
	{
		Position = 2,
		Percentile = 0.5,
		Reward = RewardInfo.enchantStoneReward("Super Enchant Stone", 1)
	},
	{
		Position = 3,
		Percentile = 0.75,
		Reward = RewardInfo.totemReward("Luck Totem", 1)
	},
	{
		Position = 4,
		Percentile = 1,
		Reward = { RewardInfo.itemReward("Ruin Key", 1) }
	}
}
local t2 = {
	Heartbreaker = {
		Replace = {
			["Love Nessie"] = "Broken Heart Nessie"
		},
		Remove = {}
	}
}
local t3 = {
	GetGlobalMilestoneRewards = function(p1, p2) --[[ GetGlobalMilestoneRewards | Line: 74 | Upvalues: t (copy) ]]
		return t[p2]
	end
}
function t3.GetTotalAreaCompletion(p1, p2, p3) --[[ GetTotalAreaCompletion | Line: 78 | Upvalues: Areas (copy), t3 (copy) ]]
	local sum = 0
	local sum_2 = 0
	for k, v in pairs(Areas) do
		local v1 = t3:GetAreaCompletion(p2, k, p3)
		sum = sum + v1.Max
		sum_2 = sum_2 + v1.Min
	end
	return NumberRange.new(math.min(sum_2, sum), sum)
end
function t3.GetArea(p1, p2) --[[ GetArea | Line: 95 | Upvalues: Areas (copy) ]]
	return Areas[p2]
end
function t3.GetGlobalFish(p1) --[[ GetGlobalFish | Line: 99 ]]
	return {}
end
function t3.ValidateFishingArea(p1, p2, p3) --[[ ValidateFishingArea | Line: 103 ]]
	local v1 = p2:GetAttribute("QuestRequirement")
	local v2 = p2:GetAttribute("EligiblePath")
	if not v2 then
		return true
	end
	local v3
	if v2 and (p3 and not p3.Destroyed) then
		if v1 then
			return p3:Find(v2, v1) ~= nil
		end
		v3 = p3:Get(v2)
	else
		v3 = nil
	end
	return v3
end
function t3.AreaUnlocked(p1, p2, p3) --[[ AreaUnlocked | Line: 124 | Upvalues: t3 (copy) ]]
	local v1 = t3:GetArea(p3)
	if not v1 then
		return false
	end
	if v1.DefaultLocation then
		return true
	end
	local v2 = t3:GetAreaCompletion(p2, p3)
	return v2.Min >= v2.Max
end
function t3.GetAreaCompletion(p1, p2, p3, p4) --[[ GetAreaCompletion | Line: 138 | Upvalues: t3 (copy), ItemUtility (copy), TierUtility (copy) ]]
	local v1 = t3:GetArea(p3)
	if not v1 then
		return NumberRange.new(0, 0)
	end
	local v2 = p2:GetExpect("CaughtFishMastery")
	local v3 = 0
	local v4 = 0
	local function TrackItem(p1) --[[ TrackItem | Line: 149 | Upvalues: ItemUtility (ref), p4 (copy), TierUtility (ref), v4 (ref), v2 (copy), v3 (ref) ]]
		local v1 = ItemUtility:GetItemData(p1)
		if not v1 then
			return
		end
		local Probability = v1.Probability
		if not Probability then
			return
		end
		if v1.EventTag then
			return
		end
		local count = 7
		if p4 then
			if p4.IgnoreFish and table.find(p4.IgnoreFish, v1.Data.Name) then
				return
			end
			if p4.IgnoreWeatherFish and v1.Events then
				return
			end
			if p4.SecretsAllowed then
				count = count + 1
			end
		end
		if count <= TierUtility:GetTierFromRarity(Probability.Chance).Tier then
			return
		end
		v4 = v4 + 1
		if not (v2[v1.Data.Name] or v2[v1.Data.Id]) then
			return
		end
		v3 = v3 + 1
	end
	for i, v in ipairs(v1.Items) do
		TrackItem(v)
	end
	return NumberRange.new(v3, v4)
end
function t3.GetItemProbabilities(p1, p2, p3, p4, p5, p6, p7) --[[ GetItemProbabilities | Line: 200 | Upvalues: t3 (copy), Events (copy), PlayerStatsUtility (copy), t2 (copy), ItemUtility (copy), TierUtility (copy), SpecialItems (copy) ]]
	local t = {}
	local v1 = t3:GetArea(p3)
	if not v1 then
		return t
	end
	local OverrideProbability = v1.OverrideProbability
	local v2 = table.clone(v1.Items)
	local v3 = getEventsReplion()
	if v3 then
		for i, v in ipairs((v3:GetExpect("Events"))) do
			local v5 = Events[v]
			if v5 then
				local v6 = nil
				if p5 then
					local v7 = v5.LinkedEvents and v5.LinkedEvents.Fish[p5]
					if v7 then
						v6 = v7
					end
				elseif p3 then
					local v8 = v5.AreaConfiguration and v5.AreaConfiguration.Fish[p3]
					if v8 then
						v6 = v8
					end
				end
				if v6 then
					for i2, v7 in ipairs(v6) do
						table.insert(v2, v7)
					end
				end
				if v5.GlobalFish then
					for i2, v7 in ipairs(v5.GlobalFish) do
						table.insert(v2, v7)
					end
				end
			end
		end
	end
	local v9 = PlayerStatsUtility:GetQuestFish(p2, p3)
	if p6 then
		table.insert(v9, p6)
	end
	if p7 and #p7 > 0 then
		for i, v in ipairs(p7) do
			local v10 = t2[v]
			if v10 then
				if next(v10.Replace) then
					for v11, v12 in v10.Replace do
						local v13 = table.find(v2, v11)
						if v13 then
							table.remove(v2, v13)
							table.insert(v2, v12)
						end
					end
				end
				if #v10.Remove > 0 then
					for i2, v4 in ipairs(v10.Remove) do
						local v14 = table.find(v2, v4)
						if v14 then
							table.remove(v2, v14)
						end
					end
				end
			end
		end
	end
	local function registerFish(p1, p2) --[[ registerFish | Line: 294 | Upvalues: ItemUtility (ref), p4 (copy), TierUtility (ref), OverrideProbability (copy), t (copy) ]]
		local v1 = ItemUtility:GetItemData(p1)
		if not v1 then
			return
		end
		local Probability = v1.Probability
		if not Probability then
			return
		end
		if v1.Weight and p4 < v1.Weight.Default.Min then
			return
		end
		local t2 = {
			Chance = if OverrideProbability and OverrideProbability[p1] then OverrideProbability[p1] else Probability.Chance,
			Identifier = v1.Data.Id,
			Name = v1.Data.Name,
			IgnoreTier = v1.IgnoreTier,
			Tier = if Probability then TierUtility:GetTierFromRarity(Probability.Chance).Tier else v1.Data.Tier,
			Proability = Probability
		}
		if p2 then
			t2.Forever = true
		end
		table.insert(t, t2)
	end
	for i, v in ipairs(v9) do
		registerFish(v, true)
	end
	for i, v in ipairs(v2) do
		registerFish(v, false)
	end
	local v15 = t3:GetGlobalFish()
	if #v15 > 0 then
		for i, v in ipairs(v15) do
			registerFish(v, false)
		end
	end
	if #SpecialItems > 0 then
		for i, v in ipairs(SpecialItems) do
			local v16 = ItemUtility:GetItemData(v.Identifier)
			if v16 then
				local Probability = v16.Probability
				table.insert(t, {
					Chance = v.Chance,
					Identifier = v.Identifier,
					Name = v.Name,
					IgnoreTier = v16.IgnoreTier,
					Tier = if Probability then TierUtility:GetTierFromRarity(Probability.Chance).Tier else v16.Data.Tier,
					Proability = Probability
				})
			end
		end
	end
	return t
end
function getEventsReplion() --[[ getEventsReplion | Line: 388 | Upvalues: RunService (copy), Replion (copy) ]]
	if RunService:IsClient() then
		return Replion.Client:WaitReplion("Events")
	else
		return Replion.Server:WaitReplion("Events")
	end
end
return t3