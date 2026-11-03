-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:52
-- Luau version 6, Types version 3
-- Time taken: 0.001516 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
function module_upvr.Binder(arg1) -- Line 8
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	function module_upvr.Request(arg1_2, arg2, arg3, arg4, arg5) -- Line 11
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: any_new_result1_upvr (readonly)
		]]
		arg1.Confirm.Price.Icon.Image = arg5 or "rbxassetid://9368218108"
		arg1.Confirm.Price.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg3 or 0)
		arg1.Container.Desc.Text = "Would you like to unlock\n<stroke thickness = \"1\"><font color=\"#ffffff\">%s</font></stroke>":format(arg2)
		any_new_result1_upvr.Prompt = arg1.Confirm.MouseButton1Click:Connect(function() -- Line 17
			--[[ Upvalues[2]:
				[1]: arg4 (readonly)
				[2]: Util_upvr (copied, readonly)
			]]
			if arg4(true) then
				Util_upvr.Windows:SwitchWindow()
				Util_upvr.Sounds:Play("BuySuccess")
			else
				Util_upvr.Windows:SwitchWindow()
				Util_upvr.Sounds:Play("BuyFailed")
			end
		end)
		Util_upvr.Windows:SwitchWindow(arg1, function() -- Line 26
			--[[ Upvalues[1]:
				[1]: arg4 (readonly)
			]]
			return arg4
		end)
	end
	return any_new_result1_upvr
end
Util_upvr.PromptPurchase = module_upvr
return module_upvr