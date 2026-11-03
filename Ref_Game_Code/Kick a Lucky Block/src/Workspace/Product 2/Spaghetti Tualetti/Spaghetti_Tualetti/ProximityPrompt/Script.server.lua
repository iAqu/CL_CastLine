-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
script.Parent.Triggered:Connect(function(p1) --[[ Line: 8 | Upvalues: LocalPlayer (copy), MarketplaceService (copy) ]]
	if p1 == LocalPlayer then
		MarketplaceService:PromptProductPurchase(LocalPlayer, 3571978990)
	end
end)