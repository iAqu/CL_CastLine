-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.RewardInfo)
require(ReplicatedStorage.Types.Modifiers)
local t = {}
return {
	GetSpecialFish = function(p1) --[[ GetSpecialFish | Line: 42 | Upvalues: t (copy) ]]
		return t
	end,
	MatchArgs = function(p1, p2, p3) --[[ MatchArgs | Line: 46 | Upvalues: TableUtil (copy), ItemUtility (copy) ]]
		if not p2.Metadata then
			return false, false
		end
		if not p3 then
			return false, false
		end
		local v1 = TableUtil.Count(p3)
		local count = 0
		for v2, v3 in p3 do
			local v4 = p2.Metadata[v2]
			if v4 then
				local v5 = nil
				if v2 == "VariantId" then
					local v6 = ItemUtility:GetVariantData(v4)
					if v6 then
						v5 = if v3 == v6.Data.Id then true else v3 == v6.Data.Name
					end
				else
					v5 = if v3 == v4 then true else false
				end
				if v5 then
					count = count + 1
				end
			end
		end
		return v1 <= count, true
	end
}