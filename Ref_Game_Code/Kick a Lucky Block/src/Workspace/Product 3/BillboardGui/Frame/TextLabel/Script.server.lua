-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local MarketplaceService = game:GetService("MarketplaceService")
local v1 = script.Parent
local v2, v3 = pcall(function() --[[ Line: 5 | Upvalues: MarketplaceService (copy) ]]
	return MarketplaceService:GetProductInfoAsync(3579677016, Enum.InfoType.Product)
end)
if v2 then
	v1.Text = v3.PriceInRobux
end