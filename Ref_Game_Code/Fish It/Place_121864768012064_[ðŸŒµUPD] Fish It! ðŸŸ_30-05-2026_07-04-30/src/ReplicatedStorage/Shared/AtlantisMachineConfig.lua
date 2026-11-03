-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local FishWeightChances = require(ReplicatedStorage.Shared.FishWeightChances)
local t = {
	Channel = "AtlantisMachine",
	LocationName = "Underwater City",
	MaxPoints = 1000,
	ActivationPriority = 999,
	TierPoints = {
		2,
		4.5,
		8,
		22,
		60,
		200,
		700
	},
	TierNames = {
		"Common",
		"Uncommon",
		"Rare",
		"Epic",
		"Legendary",
		"Mythical",
		"Secret"
	}
}
local t2 = {}
local t3 = {}
for k, v in pairs(t.TierPoints) do
	if v > 0 and k < 8 then
		table.insert(t2, v)
	end
end
table.sort(t2)
local t4 = {}
for k, v in pairs(t.TierPoints) do
	t4[v] = k
end
t.Boosts = {
	{
		Id = "luck",
		Name = "Luck Surge",
		Weight = 1,
		Color = Color3.fromRGB(102, 255, 224),
		Modifiers = {
			BaseLuck = 1
		}
	},
	{
		Id = "mutation",
		Name = "Mutation Surge",
		Weight = 1,
		Color = Color3.fromRGB(180, 135, 255),
		Modifiers = {
			MutationMultiplier = 1
		}
	},
	{
		Id = "speed",
		Name = "Speed Surge",
		Weight = 1,
		Color = Color3.fromRGB(82, 186, 255),
		Modifiers = {
			ReelMultiplier = 0.2
		}
	},
	{
		Id = "big",
		Name = "Big Catch Surge",
		Weight = 1,
		Color = Color3.fromRGB(255, 178, 102),
		Modifiers = {
			BigChanceMultiplier = 1
		}
	},
	{
		Id = "shiny",
		Name = "Shiny Surge",
		Weight = 1,
		Color = Color3.fromRGB(255, 243, 150),
		Modifiers = {
			ShinyMultiplier = 1
		}
	}
}
t.Durations = {
	{
		Id = "30m",
		Name = "30 Minutes",
		Seconds = 1800,
		Weight = 2
	},
	{
		Id = "60m",
		Name = "1 Hour",
		Seconds = 3600,
		Weight = 1
	},
	{
		Id = "90m",
		Name = "1.5 Hours",
		Seconds = 5400,
		Weight = 1
	}
}
function t.GetTier(p1, p2) --[[ GetTier | Line: 118 | Upvalues: TierUtility (copy) ]]
	if not p2 then
		return
	end
	if p2.Data.Tier then
		return p2.Data.Tier
	end
	if not p2.Probability then
		return
	end
	local v1 = TierUtility:GetTierFromRarity(p2.Probability.Chance)
	if v1 then
		return v1.Tier
	end
end
function t.IsFishItem(p1, p2) --[[ IsFishItem | Line: 137 ]]
	return if p2 then if p2.Data.Type == "Fish" then true else p2.Data.Type == "Fish" else p2
end
function t.GetPointsForItemData(p1, p2) --[[ GetPointsForItemData | Line: 141 ]]
	local v1 = p1:GetTier(p2)
	if v1 then
		return p1.TierPoints[v1] or 0, v1
	else
		return 0, nil
	end
end
function t.IsSacrificeBlocked(p1, p2) --[[ IsSacrificeBlocked | Line: 150 ]]
	local _, v1 = p1:GetPointsForItemData(p2)
	return if v1 == 8 then true elseif p2 then p2.EventTag ~= nil else p2
end
function t.GetEligibleItemMeta(p1, p2) --[[ GetEligibleItemMeta | Line: 155 | Upvalues: t3 (copy), ItemUtility (copy) ]]
	local v1 = t3[p2]
	if v1 == nil then
		local v2 = ItemUtility:GetItemData(p2)
		if not p1:IsFishItem(v2) then
			t3[p2] = false
			return
		end
		local v3, v4 = p1:GetPointsForItemData(v2)
		if v3 <= 0 or (v4 == 8 or v2.EventTag) then
			t3[p2] = false
			return
		end
		local t = {
			Name = v2.Data.Name,
			Icon = v2.Data.Icon,
			Tier = v4,
			Points = v3
		}
		t.IsSecret = v4 == 7
		t3[p2] = t
		return t
	elseif v1 == false then
		return nil
	else
		return v1
	end
end
function t.GetEligibleEntry(p1, p2, p3) --[[ GetEligibleEntry | Line: 185 ]]
	if p2.Favorited then
		return
	end
	local v1 = p1:GetEligibleItemMeta(p2.Id)
	if v1 then
		return {
			UUID = p2.UUID,
			Index = p3,
			Id = p2.Id,
			Name = v1.Name,
			Icon = v1.Icon,
			Tier = v1.Tier,
			Points = v1.Points,
			Timestamp = p2.Timestamp or 0,
			IsSecret = v1.IsSecret
		}
	end
end
function t.BuildSelectionBreakdown(p1, p2) --[[ BuildSelectionBreakdown | Line: 208 ]]
	local t = {}
	local t2 = {}
	for i, v in ipairs(p2) do
		t[v.Tier] = (t[v.Tier] or 0) + 1
	end
	for i = 1, 7 do
		local v1 = t[i]
		if v1 and v1 > 0 then
			local t3 = {
				Tier = i
			}
			local v2 = p1.TierNames[i]
			if not v2 then
				v2 = ("Tier %*"):format(i)
			end
			t3.Name = v2
			t3.Count = v1
			table.insert(t2, t3)
		end
	end
	return t2
end
function t.BuildEligibleEntries(p1, p2) --[[ BuildEligibleEntries | Line: 230 ]]
	local t = {}
	for i, v in ipairs(p2) do
		local v1 = p1:GetEligibleEntry(v, i)
		if v1 then
			table.insert(t, v1)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 240 ]]
		if p1.Points == p2.Points then
			if p1.Timestamp == p2.Timestamp then
				return p1.Name < p2.Name
			else
				return p1.Timestamp < p2.Timestamp
			end
		else
			return p1.Points < p2.Points
		end
	end)
	return t
end
function t.BuildSellAllSelection(p1, p2, p3) --[[ BuildSellAllSelection | Line: 255 | Upvalues: t2 (copy) ]]
	local v2 = math.max(p1.MaxPoints - p3, 0)
	local t = {}
	local t3 = {}
	local sum = 0
	for i, v in ipairs(t2) do
		t[v] = {}
	end
	for i, v in ipairs(p2) do
		local v3 = p1:GetEligibleEntry(v, i)
		if v3 then
			table.insert(t[v3.Points], v3)
		end
	end
	for i, v in ipairs(t2) do
		for i2, v3 in ipairs(t[v]) do
			if v2 > 0 and v2 <= sum then
				break
			end
			sum = sum + v3.Points
			table.insert(t3, v3)
		end
		if v2 > 0 and v2 <= sum then
			break
		end
	end
	local t4 = {
		Items = t3,
		Count = #t3,
		TotalPoints = sum,
		RemainingPoints = math.max(v2 - sum, 0)
	}
	t4.WillActivate = if v2 > 0 then v2 <= sum else false
	t4.Breakdown = p1:BuildSelectionBreakdown(t3)
	return t4
end
function t.BuildSellAllSummary(p1, p2, p3) --[[ BuildSellAllSummary | Line: 298 | Upvalues: t2 (copy), t4 (copy) ]]
	local v2 = math.max(p1.MaxPoints - p3, 0)
	local t = {}
	local count = 0
	local sum = 0
	local sum_2 = 0
	for i, v in ipairs(t2) do
		t[v] = 0
	end
	for i, v in ipairs(p2) do
		if v.Favorited then
			count = count + 1
			continue
		end
		local v3 = p1:GetEligibleItemMeta(v.Id)
		if v3 then
			local Points = v3.Points
			t[Points] = t[Points] + 1
		end
	end
	local t3 = {}
	for i, v in ipairs(t2) do
		local v4 = t[v]
		if v4 > 0 and v2 > 0 then
			local v7 = math.min(v4, (math.ceil(math.max(v2 - sum, 0) / v)))
			sum_2 = sum_2 + v7
			sum = sum + v7 * v
			local v8 = t4[v]
			if v8 then
				t3[v8] = (t3[v8] or 0) + v7
			end
		elseif v4 > 0 then
			sum_2 = sum_2 + v4
			sum = sum + v4 * v
			local v9 = t4[v]
			if v9 then
				t3[v9] = (t3[v9] or 0) + v4
			end
		end
		if v2 > 0 and v2 <= sum then
			break
		end
	end
	local t5 = {}
	for i = 1, 7 do
		local v10 = t3[i]
		if v10 and v10 > 0 then
			local t6 = {
				Tier = i
			}
			local v11 = p1.TierNames[i]
			if not v11 then
				v11 = ("Tier %*"):format(i)
			end
			t6.Name = v11
			t6.Count = v10
			table.insert(t5, t6)
		end
	end
	local t6 = {
		Count = sum_2,
		TotalPoints = sum,
		RemainingPoints = math.max(v2 - sum, 0)
	}
	t6.WillActivate = if v2 > 0 then v2 <= sum else false
	t6.FavoritedCount = count
	t6.Breakdown = t5
	return t6
end
function t.PickWeightedEntry(p1, p2, p3) --[[ PickWeightedEntry | Line: 373 ]]
	local sum = 0
	for i, v in ipairs(p2) do
		sum = sum + (v.Weight or 0)
	end
	if sum <= 0 then
		return p2[1]
	end
	local v1 = if p3 then p3 else math.random() * sum
	local sum_2 = 0
	for i, v in ipairs(p2) do
		sum_2 = sum_2 + (v.Weight or 0)
		if v1 <= sum_2 then
			return v
		end
	end
	return p2[#p2]
end
function t.GetBoost(p1, p2) --[[ GetBoost | Line: 397 ]]
	for i, v in ipairs(p1.Boosts) do
		if v.Id == p2 then
			return v
		end
	end
end
function t.GetDuration(p1, p2) --[[ GetDuration | Line: 405 ]]
	for i, v in ipairs(p1.Durations) do
		if v.Id == p2 then
			return v
		end
	end
end
function t.GetWeightedPercentages(p1, p2) --[[ GetWeightedPercentages | Line: 413 ]]
	local sum = 0
	local t = {}
	for i, v in ipairs(p2) do
		sum = sum + (v.Weight or 0)
	end
	if sum <= 0 then
		return t
	end
	for i, v in ipairs(p2) do
		local t2 = {
			Id = v.Id,
			Name = v.Name
		}
		t2.Percentage = math.round((v.Weight or 0) / sum * 1000) / 10
		table.insert(t, t2)
	end
	return t
end
function t.GetBoostPercentages(p1) --[[ GetBoostPercentages | Line: 436 ]]
	return p1:GetWeightedPercentages(p1.Boosts)
end
function t.GetDurationPercentages(p1) --[[ GetDurationPercentages | Line: 440 ]]
	return p1:GetWeightedPercentages(p1.Durations)
end
function t.GetWeightTable(p1, p2) --[[ GetWeightTable | Line: 444 | Upvalues: FishWeightChances (copy) ]]
	local v3 = math.clamp(FishWeightChances.Big * math.max(p2 or 1, 0), 0, 100)
	return {
		Big = v3,
		Default = 100 - v3
	}
end
return t