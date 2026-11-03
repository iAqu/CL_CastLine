-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Replion)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.TierUtility)
require(script:WaitForChild("Balance"))
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Areas)
require(ReplicatedStorage.Items)
local t = {
	["Blob Hunter"] = function(p1, p2, p3) --[[ Line: 30 ]]
		if p3.Name == "Blob Fish" then
			return p2.BlobMultiplier or 0
		end
	end,
	["Shark Hunter"] = function(p1, p2, p3) --[[ Line: 36 | Upvalues: ItemUtility (copy) ]]
		local v1 = nil
		if p3.Name:lower():find("shark") then
			v1 = false
		else
			local v2 = ItemUtility:GetItemData(p3.Name)
			if v2 and (v2.Variants and table.find(v2.Variants, "Color Burn")) then
				v1 = true
			end
		end
		if v1 then
			return p2.SharkMultiplier
		end
	end,
	FORGOTTENMultiplier = function(p1, p2, p3) --[[ FORGOTTENMultiplier | Line: 52 ]]
		if p3.Tier == 8 then
			return p2.FORGOTTENMultiplier
		end
	end,
	SECRETMultiplier = function(p1, p2, p3) --[[ SECRETMultiplier | Line: 58 ]]
		if p3.Tier == 7 then
			return p2.SECRETMultiplier
		end
	end,
	HeartLuck = function(p1, p2, p3) --[[ HeartLuck | Line: 64 | Upvalues: ItemUtility (copy) ]]
		local v1 = ItemUtility:GetItemData(p3.Name)
		if v1 and v1.EventTag == "VAL26" then
			return p2.HeartLuck
		end
	end,
	ClassicLuck = function(p1, p2, p3) --[[ ClassicLuck | Line: 71 | Upvalues: ItemUtility (copy) ]]
		local v1 = ItemUtility:GetItemData(p3.Name)
		if v1 and v1.EventTag == "CLASSIC26" then
			return p2.ClassicLuck
		end
	end,
	EasterLuck = function(p1, p2, p3) --[[ EasterLuck | Line: 78 | Upvalues: ItemUtility (copy) ]]
		local v1 = ItemUtility:GetItemData(p3.Name)
		if v1 and v1.EventTag == "EA26" then
			return p2.EasterLuck
		end
	end,
	["Easter Secret Boost"] = function(p1, p2, p3) --[[ Line: 85 ]]
		if p3.Tier == 7 then
			return 1.4
		end
	end,
	["Easter Forgotten Boost"] = function(p1, p2, p3) --[[ Line: 91 ]]
		if p3.Tier == 8 then
			return 1.4
		end
	end
}
local t2 = { "HeartLuck", "EasterLuck", "SECRETMultiplier", "FORGOTTENMultiplier" }
local function TransformLuck(p1, p2, p3, p4) --[[ TransformLuck | Line: 105 | Upvalues: t (copy), t2 (copy) ]]
	local sum = 1
	for i, v in ipairs(p2) do
		local v1 = t[v]
		if v1 then
			local v2 = v1(p1, p3, p4)
			if v2 then
				sum = sum + v2
			end
		end
	end
	for i, v in ipairs(t2) do
		local v3 = p3[v]
		if v3 and not (v3 < 1) then
			local v4 = t[v]
			if v4 then
				local v5 = v4(p1, p3, p4)
				if v5 then
					sum = sum + v5
				end
			end
		end
	end
	return p1 * sum
end
return {
	RandomFromWeightedTable = function(p1, p2, p3) --[[ RandomFromWeightedTable | Line: 151 ]]
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
		local v8 = (-1 / 0)
		for v9, v10 in p2 do
			if v8 < v10 then
				v8 = v10
			end
		end
		if not (v8 > 0) then
			return nil
		end
		local t = {}
		for v11, v12 in p2 do
			if v12 == v8 then
				table.insert(t, v11)
			end
		end
		if #t > 0 then
			return t[v1:NextInteger(1, #t)]
		else
			return nil
		end
	end,
	CreateWeightedTable_OLD = function(p1, p2, p3, p4, p5) --[[ CreateWeightedTable_OLD | Line: 195 | Upvalues: TransformLuck (copy) ]]
		local v1 = 1
		local v2 = 0
		local count = 0
		local sum = 0
		if p3 then
			if p3.BaseLuck > 1 then
				v1 = p3.BaseLuck
			end
			if p3.FishingPityTier > 0 then
				v2 = p3.FishingPityTier
			end
		end
		local v3 = math.clamp(v1 * 10, 10, 25)
		local v4, v5
		if v1 >= 1000 then
			v4 = 0.00625
			v5 = 0.005
		elseif v1 >= 30 then
			v4 = 1 / 60
			v5 = 0.01
		else
			v4 = 1 / v3
			v5 = if v1 >= 8 then 0.016666666666666666 else 1 / v3 / 2
		end
		if v1 > 1 then
			for v6, v7 in p2 do
				local sum_2
				if not v7.IgnoreLuck and (if v7.Chance <= v5 then true else v7.Forever) then
					local Chance = v7.Chance
					if p3 then
						local v9 = if p4 then p4 else {}
						local v10 = if p5 then p5 else {}
						TransformLuck(v1, v9, p3, v7)
						sum_2, p5, p4 = TransformLuck(v1, v10, p3, v7), v10, v9
					else
						sum_2 = v1
					end
					local v12 = p3.FishModifiers and p3.FishModifiers[v7.Name]
					if v12 then
						sum_2 = sum_2 + v12
					end
					local v13 = math.clamp(Chance * sum_2, 0, 0.5)
					v7.Chance = v13
					v7.IgnoreLuck = true
					sum = sum + (v13 - Chance)
					count = count + 1
				end
			end
		end
		table.sort(p2, function(p1, p2) --[[ Line: 266 ]]
			return p1.Chance > p2.Chance
		end)
		local sum_2 = 0
		for v14, v15 in p2 do
			sum_2 = sum_2 + v15.Chance
		end
		if p3 then
			sum = sum * (v1 + 1)
		end
		if v2 > 0 then
			for v16, v17 in p2 do
				if not (v17.IgnoreTier or v17.Tier and (v2 <= v17.Tier or v2 - 1 <= v17.Tier)) then
					v17.Chance = 0
				end
			end
		elseif v1 > 1 then
			for v18, v19 in p2 do
				if not (v19.IgnoreLuck or v19.Forever) then
					if sum <= 0 then
						break
					end
					if v4 <= v19.Chance then
						local v20 = if v19.Chance <= sum then v19.Chance else v19.Chance - sum
						v19.Chance = v19.Chance - v20
						sum = sum - v20 * 0.5
					end
				end
			end
		end
		local t = {}
		if p3 and p3.FishingPityTier > 0 then
			for v21, v22 in p2 do
				if not (v22.Chance <= 0) and (not v22.IgnoreTier and (v22.Tier and v22.Tier == p3.FishingPityTier)) then
					t[v22.Name] = v22.Chance
				end
			end
		end
		if next(t) == nil then
			for v23, v24 in p2 do
				if not (v24.Chance <= 0) then
					t[v24.Name] = v24.Chance
				end
			end
		end
		return t
	end,
	RandomFromArray = function(p1, p2, p3) --[[ RandomFromArray | Line: 333 ]]
		return p2[(if p3 then Random.new(p3) else Random.new()):NextInteger(1, #p2)]
	end,
	Random = function(p1, p2, p3) --[[ Random | Line: 342 ]]
		if next(p2) == nil then
			return
		end
		local v2 = (if p3 then Random.new(p3) else Random.new()):NextNumber() * 100
		local list = {}
		for v3, v4 in p2 do
			table.insert(list, {
				key = v3,
				weight = v4
			})
		end
		table.sort(list, function(p1, p2) --[[ Line: 358 ]]
			return p1.weight < p2.weight
		end)
		local t = {}
		for i, v in ipairs(list) do
			if v2 <= v.weight then
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
				return t2[math.random(1, #t2)].key
			end
		end
		for i, v in ipairs(list) do
			if v2 <= v.weight then
				return v.key
			end
		end
	end,
	RandomFromWeightedTable_OLD = function(p1, p2, p3) --[[ RandomFromWeightedTable_OLD | Line: 398 ]]
		local sum = 0
		for v1, v2 in p2 do
			sum = sum + v2
		end
		local v3 = if p3 then Random.new(p3) else Random.new()
		local v4 = v3:NextNumber() * sum
		local v5 = 0
		local t = {}
		local t2 = {}
		for v6, v7 in p2 do
			local v8 = math.max(v7, v5)
			table.insert(t, {
				key = v6,
				weight = v7
			})
			v5 = v8
		end
		table.sort(t, function(p1, p2) --[[ Line: 420 ]]
			return p1.weight < p2.weight
		end)
		local v10 = math.min(v4, v5)
		for v11, v12 in t do
			if (not (#t2 > 0) or v10 == v12.weight) and v10 <= v12.weight then
				table.insert(t2, v12.key)
				v10 = v12.weight
			end
		end
		if #t2 > 0 then
			local v13 = t2[v3:NextInteger(1, #t2)]
			if v13 then
				return v13
			end
		end
		for i = #t - 1, 1, -1 do
			local v14 = t[i]
			if v14.weight < 0.1 then
				break
			end
			if math.random(1, 2) == 2 then
				return v14.key
			end
		end
		local sum_2 = 0
		for v15, v16 in p2 do
			sum_2 = sum_2 + v16
			if v10 <= sum_2 then
				return v15
			end
		end
		if t[#t] then
			return t[#t].key
		else
			return "Clownfish"
		end
	end
}