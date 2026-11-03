-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:14
-- Luau version 6, Types version 3
-- Time taken: 0.002167 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local tbl_upvr = {}
function module.Binder(arg1) -- Line 8
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local function Update_upvr(arg1_2) -- Line 13, Named "Update"
		--[[ Upvalues[4]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: tbl_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		-- KONSTANTERROR: [0] 1. Error Block 51 start (CF ANALYSIS FAILED)
		local var7 = arg1_2 or 0
		local any_GetRebirthUpgradeData_result1 = Util_upvr.GameMath:GetRebirthUpgradeData(arg1.Name)
		if not any_GetRebirthUpgradeData_result1 then
			any_GetRebirthUpgradeData_result1 = {}
		end
		local var9 = any_GetRebirthUpgradeData_result1[var7 + 1]
		local var10 = any_GetRebirthUpgradeData_result1[var7]
		local len = #any_GetRebirthUpgradeData_result1
		if not var9 or not var9.Cost then
		end
		arg1.Buy.Price.AmountText.Text = "MAX"
		arg1.ProgressBar.Count.Text = var7..'/'..len
		arg1.ProgressBar.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(var7 / len, 0.025)
		-- KONSTANTERROR: [0] 1. Error Block 51 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [69] 50. Error Block 8 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [69] 50. Error Block 8 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [72] 52. Error Block 9 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [72] 52. Error Block 9 end (CF ANALYSIS FAILED)
	end
	any_new_result1.PromptBuy = arg1.Buy.MouseButton1Up:Connect(function() -- Line 38
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		if Util_upvr.Network:Invoke("RebirthUpgrade", arg1.Name) then
			Util_upvr.Sounds:Play("BuySuccess")
		else
			Util_upvr.Sounds:Play("BuyFailed")
		end
	end)
	any_new_result1.TokensChanged = any_GetLink_result1_upvr.Changed:On("RebirthTokens", function() -- Line 45
		--[[ Upvalues[3]:
			[1]: Update_upvr (readonly)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		Update_upvr(any_GetLink_result1_upvr.RebirthUpgrades[arg1.Name])
	end)
	any_new_result1.RebirthChanged = any_GetLink_result1_upvr.RebirthUpgrades.Changed:On(arg1.Name, Update_upvr)
	Update_upvr(any_GetLink_result1_upvr.RebirthUpgrades[arg1.Name])
	return any_new_result1
end
return module