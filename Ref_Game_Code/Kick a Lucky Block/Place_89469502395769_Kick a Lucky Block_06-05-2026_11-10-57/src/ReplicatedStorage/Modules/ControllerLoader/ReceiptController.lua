-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local MarketplaceService = game:GetService("MarketplaceService")
local t = {}
function OnPurchase(p1, p2, p3) --[[ OnPurchase | Line: 10 | Upvalues: MessagesService (copy), VFXService (copy) ]]
	if p3 then
		MessagesService:PlayMessage("Thanks for the support!\226\157\164\239\184\143")
		VFXService.PlayVFX("PlayConfetti")
	end
end
function t._init() --[[ _init | Line: 19 | Upvalues: MarketplaceService (copy) ]]
	MarketplaceService.PromptProductPurchaseFinished:Connect(OnPurchase)
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(OnPurchase)
end
return t