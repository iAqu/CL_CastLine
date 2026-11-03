-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RebirthServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.RebirthServiceClient)
local RebirthData = require(ReplicatedStorage.Shared.Data.RebirthData)
local MutationData = require(ReplicatedStorage.Shared.Data.MutationData)
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
return function(p1) --[[ Line: 14 | Upvalues: InfiniteMath (copy), EntitiesData (copy), MutationData (copy), RebirthServiceClient (copy), RebirthData (copy) ]]
	local sum = InfiniteMath.new(0)
	local v1 = InfiniteMath.new(0)
	for k, v in pairs(p1) do
		local v2 = EntitiesData.Brainrots[v.Brainrot]
		if v2 then
			local CPS = v2.CPS
			if CPS then
				local v3 = EntitiesData.GetMultiplierPerLevel(v.Level or 1)
				if v.Mutation then
					local v4 = MutationData.Buffs[v.Mutation] and MutationData.Buffs[v.Mutation].Value
					if v4 then
						v3 = v3 * v4
					end
				end
				local v5 = CPS * 24 * 60 * 60 * 0.5 * v3
				if v1 < v5 then
					v1 = v5
				end
				sum = sum + v5
			end
		end
	end
	if v1 then
		for k, v in pairs(p1) do
			local v6 = EntitiesData.Brainrots[v.Brainrot]
			if v6 and v6.Best then
				sum = sum + v1 * v6.Best
			end
		end
	end
	local v7 = RebirthData:GetMultiplierFromLevel(RebirthServiceClient.RebirthLevel or 1)
	if v7 then
		sum = sum * v7
	end
	return sum
end