-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Modules.Util.TableUtil)
require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.TierUtility)
local CustomStats = require(script.CustomStats)
local Transformers = require(script.Transformers)
require(ReplicatedStorage.Types.Modifiers)
local v1 = Random.new()
local t = {
	Array = {},
	Weighted = {},
	Utility = {},
	Core = {}
}
local function GetTransformer(p1, p2) --[[ GetTransformer | Line: 27 | Upvalues: Transformers (copy) ]]
	return Transformers[p2]
end
t.Utility.GetTransformer = GetTransformer
local function Transform(p1, p2, p3, p4, p5) --[[ Transform | Line: 33 | Upvalues: t (copy), CustomStats (copy) ]]
	local sum = 1
	local function updateValue(p1) --[[ updateValue | Line: 41 | Upvalues: t (ref), p2 (copy), p4 (copy), p5 (copy), sum (ref) ]]
		local v1 = t.Utility:GetTransformer(p1)
		if not v1 then
			return
		end
		local v2 = v1(p2, p4, p5)
		if v2 then
			sum = sum + v2
		end
	end
	for i, v in ipairs(p3) do
		local v1 = t.Utility:GetTransformer(v)
		if v1 then
			local v2 = v1(p2, p4, p5)
			if v2 then
				sum = sum + v2
			end
		end
	end
	for i, v in ipairs(CustomStats) do
		local v3 = p4[v]
		if v3 and v3 >= 1 then
			local v4 = t.Utility:GetTransformer(v)
			if v4 then
				local v5 = v4(p2, p4, p5)
				if v5 then
					sum = sum + v5
				end
			end
		end
	end
	return p2 * sum
end
t.Utility.Transform = Transform
local function FillRandom(p1, p2, p3) --[[ FillRandom | Line: 74 | Upvalues: v1 (copy) ]]
	if next(p2) == nil then
		return
	end
	local v12 = if p3 then Random.new(p3) else Random.new()
	local list = {}
	for v2, v3 in p2 do
		table.insert(list, {
			key = v2,
			weight = v3
		})
	end
	table.sort(list, function(p1, p2) --[[ Line: 93 ]]
		return p1.weight < p2.weight
	end)
	local v4 = v12:NextNumber() * 100
	local t = {}
	for i, v in ipairs(list) do
		if v4 <= v.weight then
			table.insert(t, v)
		end
	end
	if #t > 1 then
		local weight = t[1].weight
		local t2 = {}
		for i, v in ipairs(list) do
			if math.round(v.weight * 10) / 10 == math.round(weight * 10) / 10 then
				table.insert(t2, v)
			end
		end
		if #t2 >= 1 then
			return t2[v1:NextInteger(1, #t2)].key
		end
	end
	return t[1]
end
t.Weighted.FillRandom = FillRandom
local function RandomFish(p1, p2, p3) --[[ RandomFish | Line: 128 ]]
	local v1 = if p3 then Random.new(p3) else Random.new()
	local sum = 0
	for v4, v5 in p2 do
		sum = sum + v5
	end
	local sum_2 = v1:NextNumber() * sum
	for v6, v7 in p2 do
		sum_2 = sum_2 - v7
		if sum_2 <= 0 then
			return v6
		end
	end
	return nil
end
t.Weighted.RandomFish = RandomFish
local function v(p1, p2, p3) --[[ Random | Line: 236 ]]
	local t = {}
	for v1, v2 in p2 do
		if type(v2) == "number" and v2 == v2 then
			if v2 < 0 then
				warn(("RNG.Weighted:Random: weight for \"%*\" is negative (%*)"):format(v1, v2), 2)
				continue
			end
			if v2 > 0 then
				table.insert(t, v1)
			end
			continue
		end
		warn(("RNG.Weighted:Random: weight for \"%*\" is not a number"):format(v1), 2)
	end
	if #t == 0 then
		error("RNG.Weighted:Random: no entries with positive weight", 2)
	end
	table.sort(t)
	local sum = 0
	for v3, v4 in t do
		sum = sum + p2[v4]
	end
	local sum_2 = (if p3 then Random.new(p3) else Random.new()):NextNumber() * sum
	for v6, v7 in t do
		sum_2 = sum_2 - p2[v7]
		if sum_2 <= 0 then
			return v7
		end
	end
end
t.Weighted.Random = v
local function v_2(p1, p2, p3) --[[ Random | Line: 431 ]]
	return p2[(if p3 then Random.new(p3) else Random.new()):NextInteger(1, #p2)]
end
t.Array.Random = v_2
local function OldWeightedTable(p1, p2, p3, p4, p5, p6) --[[ OldWeightedTable | Line: 442 | Upvalues: t (copy) ]]
	t.Core:_modifyTable(p2, p3, p4, p5, p6)
	local t2 = {}
	if next(t2) == nil then
		for v1, v2 in p2 do
			if not (v2.Chance <= 0) then
				t2[v2.Name] = v2.Chance
			end
		end
	end
	return t2
end
t.Core.OldWeightedTable = OldWeightedTable
local function _modifyTable(p1, p2, p3, p4, p5, p6) --[[ _modifyTable | Line: 471 | Upvalues: t (copy) ]]
	local BaseLuck = p3.BaseLuck
	local FishModifiers = p3.FishModifiers
	if BaseLuck <= 1 then
		return
	end
	local v1 = if BaseLuck >= 1000 then 0.005 elseif BaseLuck >= 500 then 0.00625 elseif BaseLuck >= 15 then 0.0125 elseif BaseLuck >= 6 then 0.016666666666666666 elseif BaseLuck >= 4 then 0.02 elseif BaseLuck >= 1.5 then 1 / math.clamp(math.floor((BaseLuck - 1) * 6), 1, 25) else 1
	local v3 = p6 and p6.ForcedTier
	local v7 = merge(if p4 then p4 else {}, if p5 then p5 else {})
	local count = 0
	if v3 and v3 > 0 then
		for k, v in pairs(p2) do
			if v.Tier == v3 then
				count = count + 1
			end
		end
		if count > 0 then
			v1 = 1
		end
	else
		for k, v in pairs(p2) do
			if v.Chance <= v1 then
				count = count + 1
			end
		end
	end
	if count == 0 then
		v3 = nil
		v1 = 1
	end
	local v8 = if v3 then function(p1) --[[ Line: 550 | Upvalues: v1 (ref), v3 (ref) ]]
	if v1 < p1.Chance then
		return true
	else
		return p1.Tier ~= v3
	end
end else function(p1) --[[ Line: 562 | Upvalues: v1 (ref) ]]
	if p1.Forever then
		return false
	end
	return v1 < p1.Chance
end
	for k, v in pairs(p2) do
		local sum
		if v8(v) then
			v.Chance = 0
			continue
		end
		sum = if p3 then t.Utility:Transform(BaseLuck, v7, p3, v) else BaseLuck
		local v10 = if FishModifiers then FishModifiers[v.Name] else FishModifiers
		if v10 then
			sum = sum + v10
		end
		if if p6 then if p6.Tier == v.Tier then true else false else p6 then
			sum = sum + p6.Luck
		end
		if v.Forever then
			sum = sum * 0.5
		end
		v.Chance = math.min(v.Chance * sum, 0.5)
	end
end
t.Core._modifyTable = _modifyTable
function merge(p1, p2) --[[ merge | Line: 612 ]]
	local t = {}
	local t2 = {}
	for i, v in ipairs(p1) do
		if not t[v] then
			t[v] = true
			table.insert(t2, v)
		end
	end
	for i, v in ipairs(p2) do
		if not t[v] then
			t[v] = true
			table.insert(t2, v)
		end
	end
	return t2
end
return t