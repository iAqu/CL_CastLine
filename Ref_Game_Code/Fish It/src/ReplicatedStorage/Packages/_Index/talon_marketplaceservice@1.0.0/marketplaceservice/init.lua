-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = RunService:IsClient()
local v2 = RunService:IsServer()
local Net = require(ReplicatedStorage.Packages.Net)
local Promise = require(ReplicatedStorage.Packages.Promise)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local v3 = Net:RemoteFunction("TestServerProduct")
local v4 = Net:RemoteEvent("PromptGamePassPurchase")
local v5 = Net:RemoteEvent("PromptProductPurchase")
local v6 = Net:RemoteEvent("PromptPurchase")
local Cache = require(script.Cache)
local function f7(p1, p2) --[[ Line: 24 | Upvalues: Promise (copy), MarketplaceService (copy) ]]
	if typeof(p1) ~= "number" or p1 ~= p1 then
		return Promise.reject("[GetProductInfo] Argument \"assetId\" must be a number!")
	end
	if p1 < 1 then
		return Promise.reject("[GetProductInfo] Integers less than 1 are not valid assetsIds!")
	else
		return Promise.new(function(p12, p22) --[[ Line: 33 | Upvalues: MarketplaceService (ref), p1 (copy), p2 (copy) ]]
			local v1, v2 = pcall(function() --[[ Line: 34 | Upvalues: MarketplaceService (ref), p1 (ref), p2 (ref) ]]
				return MarketplaceService:GetProductInfo(p1, p2)
			end)
			if v1 then
				return p12(v2)
			else
				return p22((("[GetProductInfo] Failed to get info: %*"):format(v2)))
			end
		end)
	end
end
local t = {
	__index = function(p1, p2) --[[ __index | Line: 48 | Upvalues: MarketplaceService (copy) ]]
		local v1 = MarketplaceService[p2]
		if type(v1) == "function" then
			return function(p1, ...) --[[ Line: 51 | Upvalues: v1 (copy), MarketplaceService (ref) ]]
				return v1(MarketplaceService, ...)
			end
		else
			return v1
		end
	end
}
if v1 then
	local LocalPlayer = Players.LocalPlayer
	function t.PromptGamePassPurchase(p1, p2, p3) --[[ PromptGamePassPurchase | Line: 63 | Upvalues: MarketplaceService (copy), LocalPlayer (copy) ]]
		_G.addPurchase(p3)
		MarketplaceService:PromptGamePassPurchase(LocalPlayer, p3)
	end
	function t.PromptProductPurchase(p1, p2, p3) --[[ PromptProductPurchase | Line: 68 | Upvalues: UserPriority (copy), v3 (copy), MarketplaceService (copy), LocalPlayer (copy) ]]
		if workspace:GetAttribute("DevUseFakeRobuxProduct") and (UserPriority:IsValidTestSession() and v3:InvokeServer(p3)) then
			_G.addPurchase(3453919047)
			MarketplaceService:PromptProductPurchase(LocalPlayer, 3453919047)
			return
		end
		_G.addPurchase(p3)
		MarketplaceService:PromptProductPurchase(LocalPlayer, p3)
	end
	function t.PromptPurchase(p1, p2, p3) --[[ PromptPurchase | Line: 83 | Upvalues: MarketplaceService (copy), LocalPlayer (copy) ]]
		_G.addPurchase(p3)
		MarketplaceService:PromptPurchase(LocalPlayer, p3)
	end
	v4.OnClientEvent:Connect(function(p1) --[[ Line: 89 | Upvalues: t (copy), LocalPlayer (copy) ]]
		t:PromptGamePassPurchase(LocalPlayer, p1)
	end)
	v5.OnClientEvent:Connect(function(p1) --[[ Line: 93 | Upvalues: t (copy), LocalPlayer (copy) ]]
		t:PromptProductPurchase(LocalPlayer, p1)
	end)
	v6.OnClientEvent:Connect(function(p1) --[[ Line: 97 | Upvalues: t (copy), LocalPlayer (copy) ]]
		t:PromptPurchase(LocalPlayer, p1)
	end)
end
if v2 then
	function t.PromptPurchase(p1, p2, p3) --[[ PromptPurchase | Line: 103 | Upvalues: v6 (copy) ]]
		v6:FireClient(p2, p3)
	end
	function t.PromptGamePassPurchase(p1, p2, p3) --[[ PromptGamePassPurchase | Line: 107 | Upvalues: v4 (copy) ]]
		v4:FireClient(p2, p3)
	end
	function t.PromptProductPurchase(p1, p2, p3) --[[ PromptProductPurchase | Line: 111 | Upvalues: UserPriority (copy), v5 (copy) ]]
		if UserPriority:IsValidTestSession() then
			p2:SetAttribute("RealProduct", p3)
		end
		v5:FireClient(p2, p3)
	end
end
function t.GetProductInfoAsync(p1, p2, p3) --[[ GetProductInfoAsync | Line: 120 | Upvalues: Cache (copy), Promise (copy), f7 (copy) ]]
	local v2 = p3 or Enum.InfoType.Asset
	local v3 = Cache[v2]
	if not v3 then
		v3 = {}
		Cache[v2] = v3
	end
	local v4 = workspace:GetServerTimeNow()
	local v5 = v3[p2]
	if v5 and (v5.Data and v4 <= v5.Expiration) then
		return Promise.resolve(v5.Data)
	end
	return Promise.retryWithDelay(f7, 3, 1, p2, v2):andThen(function(p1) --[[ Line: 139 | Upvalues: v3 (ref), p2 (copy), v4 (copy) ]]
		v3[p2] = {
			Data = p1,
			Expiration = v4 + 180
		}
		return p1
	end):catch(function(...) --[[ Line: 147 | Upvalues: v5 (ref), v3 (ref), p2 (copy), Promise (ref) ]]
		v5 = v3[p2]
		if v5 and v5.Data then
			return Promise.resolve(v5.Data)
		else
			return Promise.reject(...)
		end
	end)
end
function t.GetProductInfo(p1, p2, p3) --[[ GetProductInfo | Line: 157 | Upvalues: Cache (copy), MarketplaceService (copy) ]]
	local v2 = p3 or Enum.InfoType.Asset
	local v3 = Cache[v2]
	if not v3 then
		v3 = {}
		Cache[v2] = v3
	end
	local v4 = workspace:GetServerTimeNow()
	local v5 = v3[p2]
	if v5 and (v5.Data and v4 <= v5.Expiration) then
		return v5.Data
	end
	local v6 = nil
	local v7, v8 = pcall(function() --[[ Line: 175 | Upvalues: v6 (ref), MarketplaceService (ref), p2 (copy), v2 (ref) ]]
		v6 = MarketplaceService:GetProductInfo(p2, v2 or Enum.InfoType.Product)
	end)
	if v7 then
		v3[p2] = {
			Data = v6,
			Expiration = v4 + 180
		}
		return v6
	else
		error(("[MarketplaceServiceModule] Failed to get ProductInfo for: %d || asset type: %s || error message: %s"):format(p2, v2.Name, (tostring(v8))))
	end
end
return t