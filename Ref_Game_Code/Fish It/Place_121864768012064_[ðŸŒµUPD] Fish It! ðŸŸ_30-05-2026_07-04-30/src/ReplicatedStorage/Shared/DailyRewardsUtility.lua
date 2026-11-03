-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
local v1 = RewardInfo.potionReward("Luck II Potion", 1)
local t = {
	RewardInfo.currencyReward("Coins", 250),
	RewardInfo.potionReward("Luck I Potion", 1),
	RewardInfo.potionReward("Mutation I Potion", 1),
	RewardInfo.currencyReward("Coins", 350),
	RewardInfo.potionReward("Luck I Potion", 2),
	RewardInfo.currencyReward("Coins", 500),
	RewardInfo.boatReward("Dinky Fishing Boat")
}
local v2 = #t
return {
	Cycle = v2,
	GetRewards = function(p1) --[[ GetRewards | Line: 22 | Upvalues: t (copy) ]]
		return t
	end,
	GetMaxReward = function(p1) --[[ GetMaxReward | Line: 26 | Upvalues: v1 (copy) ]]
		return v1
	end,
	GetReward = function(p1, p2, p3) --[[ GetReward | Line: 30 | Upvalues: v2 (copy), v1 (copy), t (copy) ]]
		local v12 = p2 % v2
		if p2 > 0 and v12 == 0 then
			v12 = v2
		end
		if v12 == v2 and p3 then
			return v1
		end
		if t[v12] then
			return t[v12], v12
		else
			return t[1], 1
		end
	end
}