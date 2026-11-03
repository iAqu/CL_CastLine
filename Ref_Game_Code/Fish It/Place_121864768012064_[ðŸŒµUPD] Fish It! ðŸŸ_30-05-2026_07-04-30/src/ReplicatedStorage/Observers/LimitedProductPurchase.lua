-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.Net)
local Observers = require(ReplicatedStorage.Packages.Observers)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
require(ReplicatedStorage.Shared.Products.LimitedProducts)
local ActiveProduct = require(ReplicatedStorage.Shared.Products.LimitedProducts.ActiveProduct)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local t = {}
local v1 = 0
local function limitedError(p1) --[[ limitedError | Line: 26 ]]
	warn((("[LimitedProduct] Error while purchasing: %*"):format(p1)))
end
local function buyLimited(p1) --[[ buyLimited | Line: 30 | Upvalues: MarketplaceService (copy), LocalPlayer (copy), limitedError (copy) ]]
	xpcall(function() --[[ Line: 31 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), p1 (copy) ]]
		return MarketplaceService:PromptProductPurchase(LocalPlayer, p1)
	end, limitedError)
end
Replion.Client:AwaitReplion("LimitedItems", function(p1) --[[ Line: 36 | Upvalues: ActiveProduct (copy), v1 (ref), t (copy), Observers (copy), GuiControl (copy), TextNotificationController (copy), Replion (copy), MarketplaceService (copy), LocalPlayer (copy), limitedError (copy) ]]
	local function updateLabel(p1, p2) --[[ updateLabel | Line: 38 | Upvalues: ActiveProduct (ref) ]]
		if p1:GetAttribute("DevProductId") == ActiveProduct then
			p1.Text = ("%* LEFT"):format(p2)
		else
			p1.Text = "??? LEFT"
		end
	end
	local function updateStock() --[[ updateStock | Line: 47 | Upvalues: p1 (copy), v1 (ref), t (ref), ActiveProduct (ref) ]]
		local v12 = p1:GetExpect("Active")
		local v2 = p1:GetExpect("RemainingStock")
		if not v12 then
			v2 = 0
		end
		v1 = v2
		for i, v in ipairs(t) do
			if v:GetAttribute("DevProductId") == ActiveProduct then
				v.Text = ("%* LEFT"):format(v2)
				continue
			end
			v.Text = "??? LEFT"
		end
	end
	updateStock()
	p1:OnChange("RemainingStock", updateStock)
	p1:OnChange("Active", updateStock)
	Observers.observeTag("LimitedProductQuantity", function(p1) --[[ Line: 65 | Upvalues: t (ref), v1 (ref), ActiveProduct (ref) ]]
		local v12 = t
		table.insert(v12, p1)
		local v2 = v1
		if p1:GetAttribute("DevProductId") == ActiveProduct then
			p1.Text = ("%* LEFT"):format(v2)
		else
			p1.Text = "??? LEFT"
		end
		return function() --[[ Line: 69 | Upvalues: t (ref), p1 (copy) ]]
			local v1 = table.find(t, p1)
			if not v1 then
				return
			end
			table.remove(t, v1)
		end
	end)
	Observers.observeTag("LimitedProductPurchase", function(p12) --[[ Line: 77 | Upvalues: GuiControl (ref), p1 (copy), TextNotificationController (ref), Replion (ref), MarketplaceService (ref), LocalPlayer (ref), limitedError (ref) ]]
		local v1 = p12:FindFirstChild("Buy") or p12:IsA("ImageButton") and p12
		if not v1 then
			return
		end
		local v2 = p12:GetAttribute("DevProductId")
		if v2 then
			local v3 = GuiControl:Hook("Hold Button", v1)
			v3.Clicked:Connect(function() --[[ Line: 90 | Upvalues: p1 (ref), TextNotificationController (ref), Replion (ref), v2 (copy), MarketplaceService (ref), LocalPlayer (ref), limitedError (ref) ]]
				if not p1:GetExpect("Active") then
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "No stock left!",
						TextColor = {
							R = 255,
							G = 0,
							B = 0
						}
					})
					return
				end
				local v1 = Replion.Client:GetReplion("Data")
				local v22
				if v1 and v1:Find("Limiteds", v2) then
					TextNotificationController:DeliverNotification({
						Type = "Text",
						Text = "You already own this item!",
						TextColor = {
							R = 0,
							G = 255,
							B = 255
						}
					})
					task.wait(1)
				end
				v22 = v2
				xpcall(function() --[[ Line: 31 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v22 (copy) ]]
					return MarketplaceService:PromptProductPurchase(LocalPlayer, v22)
				end, limitedError)
			end)
			return function() --[[ Line: 107 | Upvalues: v3 (copy) ]]
				v3:Destroy()
			end
		end
	end)
end)
return {}