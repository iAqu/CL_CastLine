-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = RunService:IsClient()
local v2 = RunService:IsServer()
local MarketplaceService_2 = require(ReplicatedStorage.Packages.MarketplaceService)
local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Replion = require(ReplicatedStorage.Packages.Replion)
local GamePass = require(ReplicatedStorage.Shared.GamePass)
local GiftProducts = require(ReplicatedStorage.Shared.GiftProducts)
local v3 = if v1 then require(ReplicatedStorage.Controllers.TextNotificationController) else nil
local v4 = Net:RemoteEvent("ProductPurchaseFinished")
local t = {
	GetGamePassIdFromName = function(p1, p2) --[[ GetGamePassIdFromName | Line: 31 | Upvalues: GamePass (copy) ]]
		for v1, v2 in GamePass do
			if v2.Identifier == p2 then
				return v1
			end
		end
	end,
	PromptGamePassPurchaseAndWaitForResult = function(p1, p2, p3) --[[ PromptGamePassPurchaseAndWaitForResult | Line: 40 | Upvalues: Signal (copy), MarketplaceService_2 (copy), v4 (copy) ]]
		local v1 = Signal.new()
		pcall(function() --[[ Line: 43 | Upvalues: MarketplaceService_2 (ref), p2 (copy), p3 (copy) ]]
			MarketplaceService_2:PromptGamePassPurchase(p2, p3)
		end)
		task.defer(function() --[[ Line: 47 | Upvalues: v4 (ref), p3 (copy), v1 (copy) ]]
			local v12, v2 = v4.OnClientEvent:Wait()
			v1:Fire(if v12 == p3 then v2 else false)
		end)
		local v2 = v1:Wait()
		v1:Destroy()
		return v2
	end,
	GetGiftDataFromName = function(p1, p2) --[[ GetGiftDataFromName | Line: 60 | Upvalues: GiftProducts (copy) ]]
		for v1, v2 in GiftProducts do
			if v2.product == p2 then
				return v2, v1
			end
		end
	end,
	GetGiftData = function(p1, p2) --[[ GetGiftData | Line: 70 | Upvalues: GiftProducts (copy) ]]
		local v1 = GiftProducts[p2]
		if v1 then
			return v1
		end
		for v2, v3 in GiftProducts do
			if v3.productId == p2 then
				return v3
			end
		end
	end,
	GetGamePassData = function(p1, p2) --[[ GetGamePassData | Line: 85 | Upvalues: GamePass (copy) ]]
		return GamePass[p2]
	end,
	GetGiftDataFromGamePassId = function(p1, p2) --[[ GetGiftDataFromGamePassId | Line: 89 | Upvalues: GiftProducts (copy) ]]
		for v1, v2 in GiftProducts do
			if v2.gamePassId == p2 then
				return v2, v1
			end
		end
	end,
	UserOwnsGamePassAsync = function(p1, p2, p3) --[[ UserOwnsGamePassAsync | Line: 98 | Upvalues: MarketplaceService (copy) ]]
		assert(if typeof(p2) == "Instance" then true else false, "Argument \"player\" must be a Instance!")
		assert(if typeof(p3) == "number" then true else false, "Argument \"gamePassId\" must be a number!")
		assert(if p3 == p3 then true else false, "Argument \"gamePassId\" is NaN!")
		local v4 = ("Pass%d"):format(p3)
		if p2:GetAttribute(v4) == true then
			return true
		end
		local v5 = getPlayerReplion(p2)
		if v5 and v5:Find("Passes", p3) then
			p2:SetAttribute(v4, p3)
			return true
		end
		local v6, v7 = pcall(function() --[[ Line: 116 | Upvalues: MarketplaceService (ref), p2 (copy), p3 (copy) ]]
			return MarketplaceService:UserOwnsGamePassAsync(p2.UserId, p3)
		end)
		if not v6 then
			return false
		end
		if not v7 then
			return v7
		end
		p2:SetAttribute(v4, p3)
		return v7
	end
}
function t.ClientPromptGamepassFromName(p1, p2) --[[ ClientPromptGamepassFromName | Line: 131 | Upvalues: v2 (copy), t (copy), Players (copy), v3 (ref) ]]
	if v2 then
		return false
	end
	local v1 = t:GetGamePassIdFromName(p2)
	if not v1 then
		return false
	end
	if t:UserOwnsGamePassAsync(Players.LocalPlayer, v1) then
		return true
	end
	local v22 = t:PromptGamePassPurchaseAndWaitForResult(Players.LocalPlayer, v1)
	if v22 then
		v3:DeliverNotification({
			Type = "Text",
			Text = "Thank you for purchasing! \240\159\146\154",
			TextColor = {
				R = 9,
				G = 203,
				B = 9
			}
		})
	else
		v3:DeliverNotification({
			Type = "Text",
			Text = "You do not own this gamepass!",
			TextColor = {
				R = 255,
				G = 203,
				B = 16
			}
		})
	end
	return v22
end
function getPlayerReplion(p1) --[[ getPlayerReplion | Line: 165 | Upvalues: RunService (copy), Replion (copy) ]]
	if RunService:IsServer() then
		return Replion.Server:GetReplionFor(p1, "Data")
	else
		return Replion.Client:WaitReplion("Data")
	end
end
return t