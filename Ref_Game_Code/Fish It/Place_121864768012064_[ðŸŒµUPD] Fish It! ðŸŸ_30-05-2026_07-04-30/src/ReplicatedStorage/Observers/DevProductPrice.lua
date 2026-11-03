-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
Observers.observeTag("DevProductPrice", function(p1) --[[ Line: 14 | Upvalues: MarketplaceService (copy) ]]
	local function onProductIdChanged() --[[ onProductIdChanged | Line: 15 | Upvalues: p1 (copy), MarketplaceService (ref) ]]
		local v1 = if p1:IsA("TextLabel") and p1.Name == "Cost" or p1.Name == "Label" then p1 else p1:FindFirstChild("Cost", true) or p1:FindFirstChild("Label")
		if not v1 then
			warn((("[DevProductPrice] Failed to update product for - %*"):format((p1:GetFullName()))))
		else
			local v3 = p1:GetAttribute("ProductId") or p1:GetAttribute("DevProductId")
			if not v3 or v3 <= 0 then
				v1.Visible = false
			else
				MarketplaceService:GetProductInfoAsync(v3, Enum.InfoType.Product):andThen(function(p1) --[[ Line: 42 | Upvalues: v1 (ref) ]]
					v1.Text = ("\238\128\130%*"):format(if p1 then tostring(p1.PriceInRobux) else "???")
					v1.Visible = true
				end):catch(function(p1) --[[ Line: 48 | Upvalues: v3 (copy), v1 (ref) ]]
					warn((("[DevProductPrice] Failed to get product price for id: %* ||| Error: %*"):format(v3, p1)))
					v1.Text = "\238\128\130 Unknown"
				end)
			end
		end
	end
	local v1 = p1:GetAttributeChangedSignal("ProductId"):Connect(onProductIdChanged)
	onProductIdChanged()
	return function() --[[ Line: 57 | Upvalues: v1 (copy) ]]
		v1:Disconnect()
	end
end)
return {}