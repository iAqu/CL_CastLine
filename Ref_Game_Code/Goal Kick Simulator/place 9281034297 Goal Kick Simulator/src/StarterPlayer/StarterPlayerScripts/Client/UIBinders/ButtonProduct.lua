-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:29
-- Luau version 6, Types version 3
-- Time taken: 0.001586 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local MarketplaceService_upvr = game:GetService("MarketplaceService")
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: MarketplaceService_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.PromptBuy = arg1.MouseButton1Click:Connect(function() -- Line 10
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: MarketplaceService_upvr (copied, readonly)
			[3]: LocalPlayer_upvr (copied, readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		local tonumber_result1 = tonumber(arg1.Name)
		if not tonumber_result1 then
			tonumber_result1 = arg1:GetAttribute("ProductID")
		end
		MarketplaceService_upvr:PromptProductPurchase(LocalPlayer_upvr, tonumber_result1)
		Util_upvr.Sounds:Play("Pop")
		Util_upvr.Windows.State:AddState(6, false, function() -- Line 15
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			Util_upvr.Loader:SetLoading()
			return function() -- Line 17
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:DisableLoading()
			end
		end)
	end)
	local Price = arg1:FindFirstChild("Price")
	if Price then
		local tonumber_result1_2 = tonumber(arg1.Name)
		if not tonumber_result1_2 then
			tonumber_result1_2 = arg1:GetAttribute("ProductID")
		end
		Price.Label.Text = Util_upvr.ValueConvertor:AddCommas(MarketplaceService_upvr:GetProductInfo(tonumber_result1_2, Enum.InfoType.Product).PriceInRobux)
	end
	any_new_result1_upvr.MouseUp = arg1.MouseButton1Up:Connect(function() -- Line 29
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.Unclick = nil
	end)
	any_new_result1_upvr.MouseLeave = arg1.MouseLeave:Connect(function() -- Line 33
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.Unclick = nil
	end)
	return any_new_result1_upvr
end
return module