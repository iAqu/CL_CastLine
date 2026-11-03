-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local Observers = require(ReplicatedStorage.Packages.Observers)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local PolicyWrapper = require(ReplicatedStorage.Shared.PolicyWrapper)
require(ReplicatedStorage.Shared.GiftProducts)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local v2 = nil
local v3 = Net:RemoteEvent("ProductPurchaseCompleted")
local t = { 2672015131, 2672015276, 2672015581, 2672015764, 2672016438, 3354034695 }
local function buyProduct(p1, p2, p3) --[[ buyProduct | Line: 39 | Upvalues: Replion (copy), GamePassUtility (copy), PolicyWrapper (copy), LocalPlayer (copy), v2 (ref), MarketplaceService (copy) ]]
	if not Replion.Client:GetReplion("Data") then
		return
	end
	local v1 = GamePassUtility:GetGiftData(p1)
	if v1 then
		p3 = v1.PaidRandomItems or p3
	end
	if p3 and PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted then
		v2:DeliverNotification({
			Type = "Text",
			Text = "You cannot purchase paid random items!",
			CustomDuration = 5,
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
	else
		pcall(function() --[[ Line: 70 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), p1 (copy) ]]
			return MarketplaceService:PromptProductPurchase(LocalPlayer, p1)
		end)
	end
end
local function giftProduct(p1, p2) --[[ giftProduct | Line: 75 | Upvalues: GamePassUtility (copy), v1 (ref) ]]
	local v12 = GamePassUtility:GetGiftData(p1)
	if not v12 then
		return
	end
	if not v1 then
		return
	end
	v1:Open(v12.product)
end
Replion.Client:AwaitReplion("Data", function() --[[ Line: 86 | Upvalues: v2 (ref), ReplicatedStorage (copy), v1 (ref), Observers (copy), GuiControl (copy), GamePassUtility (copy), buyProduct (copy), PlayerGui (copy), v3 (copy), t (copy), Soundbook (copy) ]]
	v2 = require(ReplicatedStorage.Controllers.TextNotificationController)
	v1 = require(ReplicatedStorage.Controllers.GiftingController)
	Observers.observeTag("DevProductPurchase", function(p1) --[[ Line: 90 | Upvalues: GuiControl (ref), GamePassUtility (ref), v1 (ref), buyProduct (ref) ]]
		local v12 = p1:GetAttribute("LimitedProduct")
		local v2 = p1:GetAttribute("DevProductId")
		if not v2 then
			warn((("[DevProductPurchase] No DevProductId found for: %*"):format((p1:GetFullName()))))
			return
		end
		local t = {}
		local Gift = p1:FindFirstChild("Gift")
		if Gift then
			local v3 = GuiControl:Hook("Hold Button", Gift)
			v3.Clicked:Connect(function() --[[ Line: 104 | Upvalues: p1 (copy), v2 (copy), GamePassUtility (ref), v1 (ref) ]]
				p1:HasTag("PaidRandomItems")
				local v12 = GamePassUtility:GetGiftData(v2)
				if not v12 then
					return
				end
				if not v1 then
					return
				end
				v1:Open(v12.product)
			end)
			table.insert(t, v3)
		end
		local v4 = p1:FindFirstChild("Buy") or p1:IsA("ImageButton") and p1
		if v4 then
			local v5 = GuiControl:Hook("Hold Button", v4)
			v5.Clicked:Connect(function() --[[ Line: 119 | Upvalues: p1 (copy), buyProduct (ref), v2 (copy), v12 (copy) ]]
				buyProduct(v2, v12, (p1:HasTag("PaidRandomItems")))
			end)
			table.insert(t, v5)
		end
		return function() --[[ Line: 132 | Upvalues: t (copy) ]]
			for v1, v2 in t do
				v2:Destroy()
			end
			table.clear(t)
		end
	end, { PlayerGui, workspace })
	v3.OnClientEvent:Connect(function(p1) --[[ Line: 140 | Upvalues: t (ref), Soundbook (ref), v2 (ref) ]]
		local v1
		if p1 and (p1.ProductId and table.find(t, p1.ProductId)) then
			Soundbook.Sounds.CoinsChanged:Play()
			v1 = {
				R = 255,
				G = 231,
				B = 18
			}
		else
			v1 = {
				R = 255,
				G = 255,
				B = 255
			}
		end
		v2:DeliverNotification({
			Type = "Text",
			Text = "\240\159\164\141 Thank you for supporting us!",
			CustomDuration = 5,
			TextColor = v1
		})
	end)
end)
return {}