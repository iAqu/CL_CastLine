-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local function GetPriceInRobux(p1) --[[ GetPriceInRobux | Line: 19 | Upvalues: MarketplaceService (copy) ]]
	return MarketplaceService:GetProductInfoAsync(p1, Enum.InfoType.GamePass):andThen(function(p1) --[[ Line: 21 ]]
		if p1.PriceInRobux then
			return tostring(p1.PriceInRobux)
		else
			return "???"
		end
	end):catch(function(p12) --[[ Line: 28 | Upvalues: p1 (copy) ]]
		warn((("[GamePassPrice] Failed to get gamePassId price: %* ||| Error: %*"):format(p1, p12)))
	end):await()
end
local function ObserveGamePassId(p1, p2) --[[ ObserveGamePassId | Line: 34 | Upvalues: GamePassUtility (copy), LocalPlayer (copy), GetPriceInRobux (copy) ]]
	local v1 = nil
	if p1:IsA("GuiObject") then
		v1 = function() --[[ Line: 38 | Upvalues: p1 (copy), GamePassUtility (ref), LocalPlayer (ref), GetPriceInRobux (ref) ]]
			local v1 = if p1.Name == "Buy" then p1 else p1:FindFirstChild("Buy")
			if not v1 then
				return
			end
			local v2 = v1:FindFirstChild("Label") or v1:FindFirstChild("Cost")
			if not v2 then
				return
			end
			local v3 = if v1.Parent then v1.Parent:GetAttribute("GamePassId") else nil
			if not v3 then
				v2.Text = "Unknown Price"
				return
			end
			if v3 <= 0 then
				v2.Text = "Invalid Gamepass"
				return
			end
			if GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, v3) then
				v2.Text = "OWNED"
				return
			end
			local v5, v6 = GetPriceInRobux(v3)
			if v5 and v6 then
				v2.Text = ("\238\128\130%*"):format(v6)
			else
				v2.Text = "\238\128\130 Unknown"
			end
			v2.Visible = true
		end
	elseif p1:IsA("ProximityPrompt") then
		v1 = function() --[[ Line: 87 | Upvalues: p1 (copy), GamePassUtility (ref), LocalPlayer (ref), GetPriceInRobux (ref) ]]
			local v1 = p1:GetAttribute("GamePassId")
			if not v1 then
				p1.ActionText = "Unknown Price"
				return
			end
			if v1 <= 0 then
				p1.ActionText = "Invalid Gamepass"
				return
			end
			if GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, v1) then
				p1.ActionText = "OWNED"
				return
			end
			local v2, v3 = GetPriceInRobux(v1)
			if v2 and v3 then
				p1.ActionText = ("\238\128\130%*"):format(v3)
			else
				p1.ActionText = "\238\128\130 Unknown"
			end
		end
	end
	local v2 = p2:OnChange("Passes", function() --[[ Line: 115 | Upvalues: v1 (ref) ]]
		v1()
	end)
	local v3 = p1:GetAttributeChangedSignal("GamePassId"):Connect(v1)
	v1()
	return function() --[[ Line: 122 | Upvalues: v2 (copy), v3 (copy) ]]
		v2:Disconnect()
		v3:Disconnect()
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 128 | Upvalues: Observers (copy), ObserveGamePassId (copy) ]]
	Observers.observeTag("GamePassPrice", function(p12) --[[ Line: 129 | Upvalues: ObserveGamePassId (ref), p1 (copy) ]]
		return ObserveGamePassId(p12, p1)
	end)
end)
return {}