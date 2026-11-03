-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local AdService = game:GetService("AdService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = RunService:IsServer()
RunService:IsClient()
local Net = require(ReplicatedStorage.Packages.Net)
local Promise = require(ReplicatedStorage.Packages.Promise)
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
Net:RemoteEvent("PlayVideoAd")
Net:RemoteEvent("RelayVideoAd")
local t = {
	["1 Token Shard"] = {
		ProductId = 3577497029,
		RewardInfo = RewardInfo.currencyReward("TokenShards", 1)
	},
	["100 Battlepass Currency"] = {
		ProductId = 3588339750,
		RewardInfo = RewardInfo.currencyReward(RewardInfo.BattlepassCurrency, 100)
	}
}
return {
	Ads = 10,
	GetAdProducts = function(p1) --[[ GetAdProducts | Line: 44 | Upvalues: t (copy) ]]
		return t
	end,
	IsAdReward = function(p1, p2) --[[ IsAdReward | Line: 48 | Upvalues: t (copy) ]]
		for v1, v2 in t do
			if v2.ProductId == p2 then
				return true
			end
		end
		return false
	end,
	GetAdAvailability = function(p1) --[[ GetAdAvailability | Line: 59 | Upvalues: v1 (copy), Promise (copy), AdService (copy) ]]
		if v1 then
			return Promise.reject("Cannot use this method on the server!")
		else
			local v12 = Promise.promisify(function() --[[ Line: 64 | Upvalues: AdService (ref) ]]
				return AdService:GetAdAvailabilityNowAsync(Enum.AdFormat.RewardedVideo)
			end)
			return Promise.try(v12):andThen(function(p1) --[[ Line: 68 | Upvalues: Promise (ref) ]]
				if p1.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable then
					return Promise.resolve()
				else
					return Promise.reject("AdAvailabilityResult is not available")
				end
			end):catch(function(p1) --[[ Line: 73 ]]
				warn((("[AdsUtility] Unable to play video ad, reason: %*"):format(p1)))
			end)
		end
	end
}