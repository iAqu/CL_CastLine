-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local function buyPass(p1) --[[ buyPass | Line: 21 | Upvalues: GamePassUtility (copy), LocalPlayer (copy), Soundbook (copy), MarketplaceService (copy) ]]
	if not GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, p1) then
		pcall(function() --[[ Line: 26 | Upvalues: Soundbook (ref), MarketplaceService (ref), LocalPlayer (ref), p1 (copy) ]]
			Soundbook.Sounds.GamePassClick:Play()
			MarketplaceService:PromptGamePassPurchase(LocalPlayer, p1)
		end)
	end
end
local function giftPass(p1) --[[ giftPass | Line: 32 | Upvalues: GamePassUtility (copy), v1 (ref) ]]
	local v12 = GamePassUtility:GetGiftDataFromGamePassId(p1)
	if not v12 then
		return
	end
	if not v1 then
		return
	end
	v1:Open(v12.product)
end
Replion.Client:AwaitReplion("Data", function() --[[ Line: 43 | Upvalues: v1 (ref), ReplicatedStorage (copy), Observers (copy), GamePassUtility (copy), GuiControl (copy), LocalPlayer (copy), Soundbook (copy), MarketplaceService (copy) ]]
	v1 = require(ReplicatedStorage.Controllers.GiftingController)
	Observers.observeTag("GamePassPurchase", function(p1) --[[ Line: 46 | Upvalues: GamePassUtility (ref), GuiControl (ref), v1 (ref), LocalPlayer (ref), Soundbook (ref), MarketplaceService (ref) ]]
		local v12 = p1:GetAttribute("GamePassId")
		if not v12 then
			warn((("[GamePassPurchase] No GamePassId found for: %*"):format((p1:GetFullName()))))
			return
		end
		if not GamePassUtility:GetGamePassData(v12) then
			warn((("[GamePassPurchase] GamePassData does not exist for id %*!"):format(v12)))
			return
		end
		local t = {}
		local Gift = p1:FindFirstChild("Gift")
		if Gift then
			local v2 = GuiControl:Hook("Hold Button", Gift)
			v2.Clicked:Connect(function() --[[ Line: 65 | Upvalues: v12 (copy), GamePassUtility (ref), v1 (ref) ]]
				local v13 = GamePassUtility:GetGiftDataFromGamePassId(v12)
				if not v13 then
					return
				end
				if not v1 then
					return
				end
				v1:Open(v13.product)
			end)
			table.insert(t, v2)
		end
		local Buy = p1:FindFirstChild("Buy")
		if Buy then
			local v3 = GuiControl:Hook("Hold Button", Buy)
			v3.Clicked:Connect(function() --[[ Line: 78 | Upvalues: v12 (copy), GamePassUtility (ref), LocalPlayer (ref), Soundbook (ref), MarketplaceService (ref) ]]
				local v1 = v12
				if not GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, v1) then
					pcall(function() --[[ Line: 26 | Upvalues: Soundbook (ref), MarketplaceService (ref), LocalPlayer (ref), v1 (copy) ]]
						Soundbook.Sounds.GamePassClick:Play()
						MarketplaceService:PromptGamePassPurchase(LocalPlayer, v1)
					end)
				end
			end)
			Buy:AddTag("GamePassPrice")
			table.insert(t, v3)
		else
			warn((("[GamePassPurchase] No buy button found for: %*"):format((p1:GetFullName()))))
		end
		return function() --[[ Line: 92 | Upvalues: t (copy) ]]
			for v1, v2 in t do
				v2:Destroy()
			end
			table.clear(t)
		end
	end)
end)
return {}