-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:07
-- Luau version 6, Types version 3
-- Time taken: 0.003085 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local LimitedTime_upvr = arg1:GetAttribute("LimitedTime")
	if LimitedTime_upvr then
		local function UpdateLimitedTime_upvr(arg1_2) -- Line 14, Named "UpdateLimitedTime"
			--[[ Upvalues[6]:
				[1]: Util_upvr (copied, readonly)
				[2]: LimitedTime_upvr (readonly)
				[3]: arg1 (readonly)
				[4]: any_new_result1_upvr (readonly)
				[5]: UpdateLimitedTime_upvr (readonly)
				[6]: any_GetLink_result1_upvr (readonly)
			]]
			if not arg1_2 or not (os.time() - arg1_2) then
				local const_number = math.huge
			end
			if Util_upvr.Windows then
				if Util_upvr.Windows.Object then
					local Shop = Util_upvr.Windows.Object.Side:FindFirstChild("Shop", true)
					local var16
				end
			end
			if Shop then
				if const_number > LimitedTime_upvr then
					var16 = false
				else
					var16 = true
				end
				Shop:SetAttribute("Highlight", var16)
			end
			if const_number <= LimitedTime_upvr then
				var16 = LimitedTime_upvr - const_number
				arg1.TimeValue.Text = Util_upvr.ValueConvertor:FormatTime(var16)
				var16 = Util_upvr
				function var16() -- Line 23
					--[[ Upvalues[3]:
						[1]: UpdateLimitedTime_upvr (copied, readonly)
						[2]: any_GetLink_result1_upvr (copied, readonly)
						[3]: arg1 (copied, readonly)
					]]
					UpdateLimitedTime_upvr(any_GetLink_result1_upvr.LimitedTimeDeals[arg1.Name])
				end
				any_new_result1_upvr.AutoUpdateTimer = var16.Thread.Delay(1, var16)
			else
				arg1.Visible = false
			end
		end
		UpdateLimitedTime_upvr(any_GetLink_result1_upvr.LimitedTimeDeals[arg1.Name])
		any_new_result1_upvr.LimitedTimeChanged = any_GetLink_result1_upvr.LimitedTimeDeals.Changed:On(arg1.Name, function(arg1_3) -- Line 31
			--[[ Upvalues[3]:
				[1]: UpdateLimitedTime_upvr (readonly)
				[2]: any_GetLink_result1_upvr (readonly)
				[3]: arg1 (readonly)
			]]
			UpdateLimitedTime_upvr(any_GetLink_result1_upvr.LimitedTimeDeals[arg1.Name])
		end)
	else
		UpdateLimitedTime_upvr = arg1.TimeValue
		UpdateLimitedTime_upvr.Visible = false
	end
	UpdateLimitedTime_upvr = arg1.Contents.Buy.Price.AmountText
	UpdateLimitedTime_upvr.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.MarketplaceService:GetProductInfo(arg1:GetAttribute("ProductId") or 0, Enum.InfoType.Product).PriceInRobux or 0)
	UpdateLimitedTime_upvr = arg1.Contents.Buy.MouseButton1Click
	UpdateLimitedTime_upvr = UpdateLimitedTime_upvr:Connect(function() -- Line 39
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, arg1:GetAttribute("ProductId"))
		Util_upvr.Sounds:Play("Pop")
		Util_upvr.Windows.State:AddState(6, false, function() -- Line 42
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			Util_upvr.Loader:SetLoading()
			return function() -- Line 44
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:DisableLoading()
			end
		end)
	end)
	any_new_result1_upvr.PromptBuy = UpdateLimitedTime_upvr
	return any_new_result1_upvr
end
return module