-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:20
-- Luau version 6, Types version 3
-- Time taken: 0.001386 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	arg1.Contents.Buy.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.MarketplaceService:GetProductInfo(arg1:GetAttribute("NormalProductId") or 0, Enum.InfoType.Product).PriceInRobux or 0)
	arg1.Contents.BuyPlus.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.MarketplaceService:GetProductInfo(arg1:GetAttribute("BoostedProductId") or 0, Enum.InfoType.Product).PriceInRobux or 0)
	any_new_result1.PromptBuy1 = arg1.Contents.BuyPlus.MouseButton1Click:Connect(function() -- Line 13
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, arg1:GetAttribute("BoostedProductId"))
		Util_upvr.Sounds:Play("Pop")
		Util_upvr.Windows.State:AddState(6, false, function() -- Line 16
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			warn("set loading xd")
			Util_upvr.Loader:SetLoading()
			return function() -- Line 19
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:DisableLoading()
			end
		end)
	end)
	any_new_result1.PromptBuy2 = arg1.Contents.Buy.MouseButton1Click:Connect(function() -- Line 24
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, arg1:GetAttribute("NormalProductId"))
		Util_upvr.Sounds:Play("Pop")
		Util_upvr.Windows.State:AddState(6, false, function() -- Line 27
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			Util_upvr.Loader:SetLoading()
			return function() -- Line 29
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:DisableLoading()
			end
		end)
	end)
	return any_new_result1
end
return module