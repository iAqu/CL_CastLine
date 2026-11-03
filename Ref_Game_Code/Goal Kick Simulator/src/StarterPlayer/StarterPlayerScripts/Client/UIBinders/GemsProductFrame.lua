-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:06
-- Luau version 6, Types version 3
-- Time taken: 0.001366 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.MouseDown = arg1.MouseButton1Down:Connect(function() -- Line 9
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: any_new_result1_upvr (readonly)
		]]
		arg1.Content:TweenSize(UDim2.new(0.85, 0, 0.85, 0), nil, nil, 0.2, true)
		Util_upvr.Sounds:Play("Tap")
		function any_new_result1_upvr.Unclick() -- Line 13
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1.Content:TweenSize(UDim2.new(1, 0, 1, 0), nil, nil, 0.2, true)
		end
	end)
	arg1.Content.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.MarketplaceService:GetProductInfo(arg1.Name, Enum.InfoType.Product).PriceInRobux)
	any_new_result1_upvr.PromptBuy = arg1.MouseButton1Click:Connect(function() -- Line 21
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, arg1.Name)
		Util_upvr.Sounds:Play("Pop")
		Util_upvr.Windows.State:AddState(6, false, function() -- Line 25
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			Util_upvr.Loader:SetLoading()
			return function() -- Line 27
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:DisableLoading()
			end
		end)
	end)
	any_new_result1_upvr.MouseUp = arg1.MouseButton1Up:Connect(function() -- Line 33
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.Unclick = nil
	end)
	any_new_result1_upvr.MouseLeave = arg1.MouseLeave:Connect(function() -- Line 37
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.Unclick = nil
	end)
	return any_new_result1_upvr
end
return module