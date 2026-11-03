-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:00
-- Luau version 6, Types version 3
-- Time taken: 0.003056 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 8
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
	local any_GetProductInfo_result1_upvr = Util_upvr.MarketplaceService:GetProductInfo(arg1.Name, Enum.InfoType.Product)
	arg1.Content.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(any_GetProductInfo_result1_upvr.PriceInRobux)
	any_new_result1_upvr.MouseDown = arg1.MouseButton1Down:Connect(function() -- Line 17
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		arg1.Content:TweenSize(UDim2.new(0.85, 0, 0.85, 0), nil, nil, 0.2, true)
		function any_new_result1_upvr.Unclick() -- Line 19
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1.Content:TweenSize(UDim2.new(1, 0, 1, 0), nil, nil, 0.2, true)
		end
	end)
	any_new_result1_upvr.PromptBuy = arg1.MouseButton1Click:Connect(function() -- Line 24
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, arg1.Name)
		Util_upvr.Sounds:Play("Pop")
		Util_upvr.Windows.State:AddState(6, false, function() -- Line 28
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			Util_upvr.Loader:SetLoading()
			return function() -- Line 30
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:DisableLoading()
			end
		end)
	end)
	local function _() -- Line 36, Named "UpdateAmount"
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: LocalPlayer_upvr (copied, readonly)
			[4]: any_GetProductInfo_result1_upvr (readonly)
		]]
		arg1.Content.Title.Text = '+'..Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetGoldAmountFromRobuxPrice(LocalPlayer_upvr, any_GetProductInfo_result1_upvr.PriceInRobux)).." Coins!"
	end
	arg1.Content.Title.Text = '+'..Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetGoldAmountFromRobuxPrice(LocalPlayer_upvr, any_GetProductInfo_result1_upvr.PriceInRobux)).." Coins!"
	local any_new_result1_upvr_2 = Util_upvr.Maid.new()
	for i, v in pairs(Util_upvr.Link:GetRawLink().Inventory) do
		if not v then
			any_new_result1_upvr_2[i] = nil
		end
		local var23 = any_GetLink_result1_upvr.Inventory[i]
		if var23 then
			var23 = any_GetLink_result1_upvr.Inventory[i].Changed
			var23 = var23:On("Equipped", function(arg1_4) -- Line 46
				--[[ Upvalues[4]:
					[1]: arg1 (readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: LocalPlayer_upvr (copied, readonly)
					[4]: any_GetProductInfo_result1_upvr (readonly)
				]]
				if arg1_4 == nil or arg1_4 == true then
					arg1.Content.Title.Text = '+'..Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetGoldAmountFromRobuxPrice(LocalPlayer_upvr, any_GetProductInfo_result1_upvr.PriceInRobux)).." Coins!"
				end
			end)
		end
		any_new_result1_upvr_2[i] = var23
	end
	any_new_result1_upvr_2.InventoryChanged = any_GetLink_result1_upvr.Inventory.Changed:Connect(function(arg1_2, arg2) -- Line 42, Named "TrackBall"
		--[[ Upvalues[6]:
			[1]: any_new_result1_upvr_2 (readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: arg1 (readonly)
			[4]: Util_upvr (copied, readonly)
			[5]: LocalPlayer_upvr (copied, readonly)
			[6]: any_GetProductInfo_result1_upvr (readonly)
		]]
		if not arg2 then
			any_new_result1_upvr_2[arg1_2] = nil
		end
		local var18 = any_GetLink_result1_upvr.Inventory[arg1_2]
		if var18 then
			var18 = any_GetLink_result1_upvr.Inventory[arg1_2].Changed
			var18 = var18:On("Equipped", function(arg1_3) -- Line 46
				--[[ Upvalues[4]:
					[1]: arg1 (copied, readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: LocalPlayer_upvr (copied, readonly)
					[4]: any_GetProductInfo_result1_upvr (copied, readonly)
				]]
				if arg1_3 == nil or arg1_3 == true then
					arg1.Content.Title.Text = '+'..Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetGoldAmountFromRobuxPrice(LocalPlayer_upvr, any_GetProductInfo_result1_upvr.PriceInRobux)).." Coins!"
				end
			end)
		end
		any_new_result1_upvr_2[arg1_2] = var18
	end)
	any_new_result1_upvr.MouseUp = arg1.MouseButton1Up:Connect(function() -- Line 58
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.Unclick = nil
	end)
	any_new_result1_upvr.MouseLeave = arg1.MouseLeave:Connect(function() -- Line 62
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.Unclick = nil
	end)
	return any_new_result1_upvr
end
return module