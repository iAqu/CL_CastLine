-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = {
	MutationData = require(ReplicatedStorage.Shared.Data.MutationData),
	AddedEntries = {}
}
local v1 = Random.new()
function DeepCopyTable(p1) --[[ DeepCopyTable | Line: 12 ]]
	local t = {}
	for k, v in pairs(p1) do
		if type(v) == "table" then
			t[k] = DeepCopyTable(v)
		end
		t[k] = v
	end
	return t
end
function t.GenerateMutation(p1, p2, p3, p4) --[[ GenerateMutation | Line: 24 | Upvalues: v1 (copy) ]]
	local v12 = p2 or 1
	local sum = 0
	local list = {}
	local v2 = DeepCopyTable(p1.MutationData.Mutations)
	if next(p1.AddedEntries) then
		for k, v in pairs(p1.AddedEntries) do
			table.insert(v2, v)
		end
		table.sort(v2, function(p1, p2) --[[ Line: 36 ]]
			return p1.Chance < p2.Chance
		end)
	end
	for i, v in ipairs(v2) do
		if v.Name ~= "None" and not (p3 and table.find(p3, v.Name)) then
			local sum_2 = 0
			if p4 then
				if p4[v.Name] then
					sum_2 = sum_2 + (p4[v.Name] - 1)
				end
				if p4.Global then
					sum_2 = sum_2 + (p4.Global - 1)
				end
			end
			local v3 = v.Chance * (v12 + sum_2)
			table.insert(list, {
				Name = v.Name,
				Chance = v3
			})
			sum = sum + v3
		end
	end
	if sum < 100 then
		table.insert(list, {
			Name = "None",
			Chance = 100 - sum
		})
	end
	table.sort(list, function(p1, p2) --[[ Line: 73 ]]
		return p1.Chance < p2.Chance
	end)
	local v4 = v1:NextNumber(0, 100)
	local sum_2 = 0
	for i, v in ipairs(list) do
		sum_2 = sum_2 + v.Chance
		if v4 <= sum_2 then
			return v.Name
		end
	end
	return "None"
end
function t.AddSpecialEntry(p1, p2, p3) --[[ AddSpecialEntry | Line: 90 ]]
	p1.AddedEntries[p2] = {
		Name = p2,
		Chance = p3
	}
end
function t.RemoveEntry(p1, p2) --[[ RemoveEntry | Line: 97 ]]
	p1.AddedEntries[p2] = nil
end
function t.GetMutationsFromInstance(p1, p2) --[[ GetMutationsFromInstance | Line: 101 ]]
	if p2 then
		local t = {}
		for i, v in ipairs(p1.MutationData.ValidMutations) do
			if v ~= "None" and p2:HasTag(v) then
				table.insert(t, v)
			end
		end
		table.sort(t, function(p12, p2) --[[ Line: 118 | Upvalues: p1 (copy) ]]
			return p1.MutationData.Buffs[p12].XP < p1.MutationData.Buffs[p2].XP
		end)
		return t
	end
end
return t