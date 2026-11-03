-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local PolicyWrapper = require(ReplicatedStorage.Shared.PolicyWrapper)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local function buyProduct(p1, p2, p3) --[[ buyProduct | Line: 21 | Upvalues: Replion (copy), GamePassUtility (copy), PolicyWrapper (copy), LocalPlayer (copy), v1 (ref), MarketplaceService (copy) ]]
	if not Replion.Client:GetReplion("Data") then
		return
	end
	local v12 = GamePassUtility:GetGiftData(p1)
	if v12 then
		p3 = v12.PaidRandomItems or p3
	end
	if p3 and PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted then
		v1:DeliverNotification({
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
		pcall(function() --[[ Line: 52 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), p1 (copy) ]]
			MarketplaceService:PromptProductPurchase(LocalPlayer, p1)
		end)
	end
end
Replion.Client:AwaitReplion("Data", function() --[[ Line: 57 | Upvalues: v1 (ref), ReplicatedStorage (copy), Observers (copy), LocalPlayer (copy), buyProduct (copy) ]]
	v1 = require(ReplicatedStorage.Controllers.TextNotificationController)
	Observers.observeTag("DevProductPrompt", function(p1) --[[ Line: 60 | Upvalues: LocalPlayer (ref), buyProduct (ref) ]]
		local v1 = p1:GetAttribute("LimitedProduct")
		local v2 = p1:GetAttribute("DevProductId")
		if v2 then
			local v3 = p1:GetAttribute("ActionText") or "Buy Item"
			local v4 = p1:GetAttribute("ObjectText") or ""
			local ProximityPrompt = Instance.new("ProximityPrompt")
			ProximityPrompt.ObjectText = v4
			ProximityPrompt.ActionText = v3
			ProximityPrompt.ClickablePrompt = true
			ProximityPrompt.RequiresLineOfSight = false
			ProximityPrompt.MaxActivationDistance = 14
			ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
			ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadUp
			ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
			ProximityPrompt.Parent = p1
			local v5 = ProximityPrompt.Triggered:Connect(function(p12) --[[ Line: 83 | Upvalues: LocalPlayer (ref), p1 (copy), buyProduct (ref), v2 (copy), v1 (copy) ]]
				if p12 == LocalPlayer then
					buyProduct(v2, v1, (p1:HasTag("PaidRandomItems")))
				end
			end)
			return function() --[[ Line: 94 | Upvalues: v5 (copy), ProximityPrompt (copy) ]]
				v5:Disconnect()
				ProximityPrompt:Destroy()
			end
		else
			warn((("[DevProductPrompt] No DevProductId found for: %*"):format((p1:GetFullName()))))
		end
	end)
end)
return {}