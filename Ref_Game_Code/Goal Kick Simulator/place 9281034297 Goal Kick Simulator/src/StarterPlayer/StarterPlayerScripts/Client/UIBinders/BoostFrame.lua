-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:37
-- Luau version 6, Types version 3
-- Time taken: 0.004534 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
Util_upvr.MarketplaceService.PromptProductPurchaseFinished:Connect(function(...) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	Util_upvr.Windows.State:RemoveState(6)
end)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 10
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local var9 = any_GetLink_result1_upvr.OwnedBoosts[arg1.Name]
	local var10
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		var10 = "Use ("..var9..')'
		return var10
	end
	if not var9 or 0 >= var9 or not INLINED_2() then
		var10 = "None"
	end
	arg1.Contents.Use.Title.Text = var10
	var10 = arg1.Name
	any_new_result1_upvr.UpdateAvailable = any_GetLink_result1_upvr.OwnedBoosts.Changed:On(var10, function(arg1_2) -- Line 15, Named "UpdateAvailable"
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		local var8
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var8 = "Use ("..arg1_2..')'
			return var8
		end
		if not arg1_2 or 0 >= arg1_2 or not INLINED() then
			var8 = "None"
		end
		arg1.Contents.Use.Title.Text = var8
	end)
	local function UpdateActualTimer_upvr(arg1_3) -- Line 21, Named "UpdateActualTimer"
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
		]]
		local var11
		local function INLINED_3() -- Internal function, doesn't exist in bytecode
			var11 = Util_upvr.ValueConvertor:FormatTime(arg1_3)
			return var11
		end
		if not arg1_3 or 0 >= arg1_3 or not INLINED_3() then
			var11 = "Inactive!"
		end
		arg1.Contents.TimeValue.Text = var11
	end
	local function _(arg1_4) -- Line 25, Named "UpdateTimer"
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: UpdateActualTimer_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var12 = arg1_4
		if var12 then
			var12 = arg1_4.Value
		end
		if not var12 or 0 >= var12 or not Util_upvr.ValueConvertor:FormatTime(var12) then
		end
		arg1.Contents.TimeValue.Text = "Inactive!"
		local var13 = arg1_4
		if var13 then
			var13 = arg1_4.Changed:On("Value", UpdateActualTimer_upvr)
		end
		any_new_result1_upvr.TimerValueChanged = var13
	end
	var10 = any_GetLink_result1_upvr.Boosts[arg1.Name]
	local var14 = var10
	if var14 then
		var14 = var10.Value
	end
	if not var14 or 0 >= var14 or not Util_upvr.ValueConvertor:FormatTime(var14) then
	end
	arg1.Contents.TimeValue.Text = "Inactive!"
	var14 = var10
	local var15 = var14
	if var15 then
		var15 = var10.Changed:On("Value", UpdateActualTimer_upvr)
	end
	any_new_result1_upvr.TimerValueChanged = var15
	var10 = any_GetLink_result1_upvr.Boosts.Changed
	var10 = var10:On(arg1.Name, function() -- Line 30
		--[[ Upvalues[5]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: any_new_result1_upvr (readonly)
			[5]: UpdateActualTimer_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var17 = any_GetLink_result1_upvr.Boosts[arg1.Name]
		local var18 = var17
		if var18 then
			var18 = var17.Value
		end
		if not var18 or 0 >= var18 or not Util_upvr.ValueConvertor:FormatTime(var18) then
		end
		arg1.Contents.TimeValue.Text = "Inactive!"
		local var19 = var17
		if var19 then
			var19 = var17.Changed:On("Value", UpdateActualTimer_upvr)
		end
		any_new_result1_upvr.TimerValueChanged = var19
	end)
	any_new_result1_upvr.UpdateTimer = var10
	var10 = arg1.Contents.Use.MouseButton1Click
	var10 = var10:Connect(function() -- Line 34
		--[[ Upvalues[3]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		if any_GetLink_result1_upvr.OwnedBoosts[arg1.Name] and 0 < any_GetLink_result1_upvr.OwnedBoosts[arg1.Name] and Util_upvr.Network:Invoke("UseBoost", arg1.Name) then
			Util_upvr.Sounds:Play("MoneyGainedSuccess")
		else
			Util_upvr.Sounds:Play("BuyFailed")
		end
	end)
	any_new_result1_upvr.UseBoost = var10
	var10 = arg1.Contents.Buy.Price.AmountText
	var10.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.MarketplaceService:GetProductInfo(arg1:GetAttribute("ProductId") or 0, Enum.InfoType.Product).PriceInRobux or 0)
	var10 = arg1.Contents.Buy.MouseButton1Click
	var10 = var10:Connect(function() -- Line 43
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		Util_upvr.MarketplaceService:PromptProductPurchase(LocalPlayer_upvr, arg1:GetAttribute("ProductId"))
		Util_upvr.Sounds:Play("Pop")
		Util_upvr.Windows.State:AddState(6, false, function() -- Line 46
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			Util_upvr.Loader:SetLoading()
			return function() -- Line 48
				--[[ Upvalues[1]:
					[1]: Util_upvr (copied, readonly)
				]]
				Util_upvr.Loader:DisableLoading()
			end
		end)
	end)
	any_new_result1_upvr.PromptBuy = var10
	return any_new_result1_upvr
end
return module