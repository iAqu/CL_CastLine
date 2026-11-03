-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:52
-- Luau version 6, Types version 3
-- Time taken: 0.000771 seconds

local module = {}
for i_upvr, v_upvr in pairs(module) do
	while true do
		local MarketplaceService_upvr = game:GetService("MarketplaceService")
		local pcall_result1, pcall_result2 = pcall(function() -- Line 13
			--[[ Upvalues[3]:
				[1]: MarketplaceService_upvr (readonly)
				[2]: i_upvr (readonly)
				[3]: v_upvr (readonly)
			]]
			local any_GetProductInfo_result1 = MarketplaceService_upvr:GetProductInfo(i_upvr, Enum.InfoType.GamePass)
			v_upvr.Name = any_GetProductInfo_result1.Name
			v_upvr.Description = any_GetProductInfo_result1.Description
			v_upvr.Image = any_GetProductInfo_result1.IconImageAssetId
			v_upvr.Price = any_GetProductInfo_result1.PriceInRobux
		end)
		if not pcall_result1 then
			warn(pcall_result2)
		end
		if pcall_result1 then break end
		if not task.wait(1) then
		end
	end
end
return module