-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Modules.GuiControl)
local function BuyPass(p1) --[[ BuyPass | Line: 19 | Upvalues: GamePassUtility (copy), LocalPlayer (copy), MarketplaceService (copy) ]]
	if not GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, p1) then
		pcall(function() --[[ Line: 24 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), p1 (copy) ]]
			MarketplaceService:PromptGamePassPurchase(LocalPlayer, p1)
		end)
	end
end
Observers.observeTag("GamePassPrompt", function(p1) --[[ Line: 29 | Upvalues: GamePassUtility (copy), LocalPlayer (copy), Soundbook (copy), MarketplaceService (copy) ]]
	local v1 = p1:GetAttribute("GamePassId")
	if not v1 then
		warn((("[GamePassPrompt] No GamePassId found for: %*"):format((p1:GetFullName()))))
		return
	end
	local v2 = GamePassUtility:GetGamePassData(v1)
	if v2 then
		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.ObjectText = v2.Identifier
		ProximityPrompt.ActionText = ""
		ProximityPrompt.ClickablePrompt = true
		ProximityPrompt.RequiresLineOfSight = false
		ProximityPrompt.MaxActivationDistance = 14
		ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
		ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadUp
		ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		ProximityPrompt.Parent = p1
		local v3 = ProximityPrompt.Triggered:Connect(function(p1) --[[ Line: 54 | Upvalues: LocalPlayer (ref), GamePassUtility (ref), v1 (copy), Soundbook (ref), MarketplaceService (ref) ]]
			if p1 ~= LocalPlayer then
				return
			end
			if GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, v1) then
				return
			end
			Soundbook.Sounds.GamePassClick:Play()
			local v12 = v1
			if GamePassUtility:UserOwnsGamePassAsync(LocalPlayer, v12) then
				return
			end
			pcall(function() --[[ Line: 24 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v12 (copy) ]]
				MarketplaceService:PromptGamePassPurchase(LocalPlayer, v12)
			end)
		end)
		ProximityPrompt:SetAttribute("GamePassId", v1)
		ProximityPrompt:AddTag("GamePassPrice")
		return function() --[[ Line: 71 | Upvalues: v3 (copy), ProximityPrompt (copy) ]]
			v3:Disconnect()
			ProximityPrompt:Destroy()
		end
	else
		warn((("[GamePassPrompt] GamePassData does not exist for id %*!"):format(v1)))
	end
end)
return {}