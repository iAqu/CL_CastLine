-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local Promise = require(ReplicatedStorage.Packages.Promise)
local Observers = require(ReplicatedStorage.Packages.Observers)
local t = {
	AreAdsAllowed = false,
	ArePaidRandomItemsRestricted = true,
	IsContentSharingAllowed = false,
	IsEligibleToPurchaseSubscription = false,
	IsPaidItemTradingAllowed = false,
	IsSubjectToChinaPolicies = true,
	AllowedExternalLinkReferences = {}
}
local v3 = Promise.promisify(function(p1) --[[ Line: 39 | Upvalues: PolicyService (copy) ]]
	return PolicyService:GetPolicyInfoForPlayerAsync(p1)
end)
local t2 = {}
local t3 = {
	_getPolicy = function(p1, p2) --[[ _getPolicy | Line: 49 | Upvalues: Promise (copy), v3 (copy) ]]
		return Promise.retryWithDelay(v3, 2, 1, p2):catch(warn):await()
	end
}
function t3._tryPolicyCache(p1, p2) --[[ _tryPolicyCache | Line: 55 | Upvalues: t3 (copy), t2 (copy) ]]
	local v1, v2 = t3:_getPolicy(p2)
	if not v1 then
		return
	end
	t2[p2] = v2
end
function t3.GetPolicyInfo(p1, p2) --[[ GetPolicyInfo | Line: 62 | Upvalues: t2 (copy), t3 (copy), t (copy) ]]
	local v1 = t2[p2]
	if v1 then
		return v1
	end
	local v2, v3 = t3:_getPolicy(p2)
	if v2 then
		return v3
	else
		return t
	end
end
if v1 then
	Observers.observePlayer(function(p1) --[[ Line: 78 | Upvalues: t3 (copy), t2 (copy) ]]
		t3:_tryPolicyCache(p1)
		return function() --[[ Line: 81 | Upvalues: t2 (ref), p1 (copy) ]]
			t2[p1] = nil
		end
	end)
end
if v2 then
	task.spawn(function() --[[ Line: 88 | Upvalues: t3 (copy), Players (copy) ]]
		t3:_tryPolicyCache(Players.LocalPlayer)
	end)
end
return t3