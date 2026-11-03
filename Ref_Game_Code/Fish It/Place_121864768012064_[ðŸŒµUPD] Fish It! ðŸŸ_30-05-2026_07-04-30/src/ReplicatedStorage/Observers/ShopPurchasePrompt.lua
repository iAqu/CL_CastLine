-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Net = require(ReplicatedStorage.Packages.Net)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local CoinProductsUtility = require(ReplicatedStorage.Modules.CoinProductsUtility)
local ClaimableItemsUtility = require(ReplicatedStorage.Shared.ClaimableItemsUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Modules.GuiControl)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = Net:RemoteFunction("PurchaseFishingRod")
local v2 = Net:RemoteFunction("PurchaseBait")
local v3 = Net:RemoteFunction("PurchaseGear")
local v4 = Net:RemoteFunction("PurchaseCharm")
local v5 = Net:RemoteFunction("ClaimItem")
local v6 = false
local function GetPurchaseMessage(p1) --[[ GetPurchaseMessage | Line: 36 | Upvalues: TierUtility (copy), StringLibrary (copy) ]]
	local v1 = nil
	if p1.Probability then
		v1 = TierUtility:GetTierFromRarity(p1.Probability.Chance)
	elseif p1.Data.Tier then
		v1 = TierUtility:GetTier(p1.Data.Tier)
	end
	local v5 = (if v1 then v1.TierColor.Keypoints[1].Value else Color3.fromRGB(255, 255, 255)):ToHex()
	return ("Would you like to buy <b><font color=\"#%*\">%*</font></b> for %*?"):format(v5, p1.Data.Name, (("<font color=\"rgb(255, 196, 57)\">%* Coins</font>"):format((StringLibrary:Shorten(p1.Price)))))
end
local function GetClaimMessage(p1) --[[ GetClaimMessage | Line: 54 | Upvalues: TierUtility (copy) ]]
	local v1 = nil
	if p1.Probability then
		v1 = TierUtility:GetTierFromRarity(p1.Probability.Chance)
	elseif p1.Data.Tier then
		v1 = TierUtility:GetTier(p1.Data.Tier)
	end
	return ("Claim <b><font color=\"#%*\">%*</font></b>"):format((if v1 then v1.TierColor.Keypoints[1].Value else Color3.fromRGB(255, 255, 255)):ToHex(), p1.Data.Name)
end
local function Purchase(p1, p2) --[[ Purchase | Line: 69 | Upvalues: v6 (ref), Replion (copy), ItemUtility (copy), TextNotificationController (copy), v3 (copy), v2 (copy), v1 (copy), v4 (copy), CoinProductsUtility (copy), GetPurchaseMessage (copy), PromptController (copy), Soundbook (copy) ]]
	if v6 then
		return
	end
	local v12 = Replion.Client:GetReplion("Data")
	if not v12 then
		return
	end
	local v22 = ItemUtility.GetItemDataFromItemType(p1, p2)
	if not v22 then
		return
	end
	if not v22.Price then
		return
	end
	if v22.EligiblePath and v12:Get(v22.EligiblePath) ~= true then
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "You do not have this unlocked!",
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
		return
	end
	local v32 = nil
	if p1 == "Gears" then
		v32 = v3
	elseif p1 == "Baits" then
		v32 = v2
	elseif p1 == "Fishing Rods" then
		v32 = v1
	elseif p1 == "Charms" then
		v32 = v4
	end
	if not v32 then
		return
	end
	v6 = true
	local Price = v22.Price
	if not Price then
		PromptController:FirePrompt((GetPurchaseMessage(v22))):andThen(function(p1_2) --[[ Line: 136 | Upvalues: v32 (ref), v22 (copy) ]]
			if p1_2 then
				return v32:InvokeServer(v22.Data.Id)
			else
				return false
			end
		end):andThen(function(p1_2) --[[ Line: 143 | Upvalues: Soundbook (ref) ]]
			if not p1_2 then
				return
			end
			Soundbook.Sounds.StorePurchase:Play()
			Soundbook.Sounds.CoinsChanged:Play()
		end):catch(warn):await()
		v6 = false
		return
	end
	local v42 = v12:GetExpect("Coins")
	if v42 < Price then
		CoinProductsUtility:PurchaseBestCoinPack(v42, Price)
	else
		PromptController:FirePrompt((GetPurchaseMessage(v22))):andThen(function(p1_2) --[[ Line: 136 | Upvalues: v32 (ref), v22 (copy) ]]
			if p1_2 then
				return v32:InvokeServer(v22.Data.Id)
			else
				return false
			end
		end):andThen(function(p1_2) --[[ Line: 143 | Upvalues: Soundbook (ref) ]]
			if not p1_2 then
				return
			end
			Soundbook.Sounds.StorePurchase:Play()
			Soundbook.Sounds.CoinsChanged:Play()
		end):catch(warn):await()
	end
	v6 = false
end
local function Claim(p1) --[[ Claim | Line: 156 | Upvalues: Replion (copy), ClaimableItemsUtility (copy), ItemUtility (copy), TextNotificationController (copy), GetClaimMessage (copy), PromptController (copy), v5 (copy), Soundbook (copy) ]]
	local v1 = Replion.Client:GetReplion("Data")
	if not v1 then
		return
	end
	local v2 = ClaimableItemsUtility:Get(p1)
	if not v2 then
		return
	end
	local v3 = ItemUtility.GetItemDataFromItemType(v2.ItemType, p1)
	if not v3 then
		return
	end
	local v4, v52 = ClaimableItemsUtility:Check(v1, p1)
	if v4 then
		PromptController:FirePrompt((GetClaimMessage(v3))):andThen(function(p12) --[[ Line: 187 | Upvalues: v5 (ref), p1 (copy) ]]
			if p12 then
				return v5:InvokeServer(p1)
			else
				return false
			end
		end):andThen(function(p1) --[[ Line: 194 | Upvalues: Soundbook (ref) ]]
			if not p1 then
				return
			end
			Soundbook.Sounds.StorePurchase:Play()
		end):catch(warn):await()
	else
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = v52 or "You cannot claim this!",
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
	end
end
Observers.observeTag("ClaimItemPrompt", function(p1) --[[ Line: 204 | Upvalues: ClaimableItemsUtility (copy), ItemUtility (copy), LocalPlayer (copy), Claim (copy) ]]
	local v1 = p1:GetAttribute("Identifier")
	if not v1 then
		return
	end
	local v2 = ClaimableItemsUtility:Get(v1)
	if not v2 then
		return
	end
	local v3 = ItemUtility.GetItemDataFromItemType(v2.ItemType, v1)
	if v3 then
		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.ObjectText = ("Claim %*"):format(v3.Data.Name)
		ProximityPrompt.ActionText = ""
		ProximityPrompt.ClickablePrompt = true
		ProximityPrompt.RequiresLineOfSight = false
		ProximityPrompt.MaxActivationDistance = 12
		ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
		ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadUp
		ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		ProximityPrompt.Parent = p1
		local v4 = ProximityPrompt.Triggered:Connect(function(p1) --[[ Line: 232 | Upvalues: LocalPlayer (ref), Claim (ref), v1 (copy) ]]
			if LocalPlayer ~= p1 then
				return
			end
			Claim(v1)
		end)
		return function() --[[ Line: 238 | Upvalues: v4 (copy), ProximityPrompt (copy) ]]
			v4:Disconnect()
			ProximityPrompt:Destroy()
		end
	end
end)
Observers.observeTag("ShopPurchasePrompt", function(p1) --[[ Line: 246 | Upvalues: ItemUtility (copy), StringLibrary (copy), LocalPlayer (copy), Purchase (copy) ]]
	local v1 = p1:GetAttribute("ItemType")
	local v2 = p1:GetAttribute("Identifier")
	if not (v1 and v2) then
		return
	end
	local v3 = ItemUtility.GetItemDataFromItemType(v1, v2)
	if not v3 then
		return
	end
	if v3.Price then
		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.ObjectText = ("Buy %*"):format(v3.Data.Name)
		ProximityPrompt.ActionText = ("%* Coins"):format((StringLibrary:Shorten(v3.Price)))
		ProximityPrompt.ClickablePrompt = true
		ProximityPrompt.RequiresLineOfSight = false
		ProximityPrompt.MaxActivationDistance = 12
		ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
		ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadUp
		ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		ProximityPrompt.Parent = p1
		local v4 = ProximityPrompt.Triggered:Connect(function(p1) --[[ Line: 274 | Upvalues: LocalPlayer (ref), Purchase (ref), v1 (copy), v2 (copy) ]]
			if LocalPlayer ~= p1 then
				return
			end
			Purchase(v1, v2)
		end)
		return function() --[[ Line: 280 | Upvalues: v4 (copy), ProximityPrompt (copy) ]]
			v4:Disconnect()
			ProximityPrompt:Destroy()
		end
	end
end)
return {}