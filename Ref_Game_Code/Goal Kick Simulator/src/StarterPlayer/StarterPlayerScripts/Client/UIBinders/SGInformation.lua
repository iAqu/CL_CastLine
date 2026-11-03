-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:03
-- Luau version 6, Types version 3
-- Time taken: 0.000740 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	any_new_result1.PromptToShop1 = arg1.Info.Coins.More.MouseButton1Up:Connect(function() -- Line 9
		--[[ Upvalues[1]:
			[1]: Util_upvr (copied, readonly)
		]]
		Util_upvr.Windows:SwitchWindow(Util_upvr.Windows.Object.Windows.Shop)
	end)
	any_new_result1.PromptToShop2 = arg1.Info.Gems.More.MouseButton1Up:Connect(function() -- Line 13
		--[[ Upvalues[1]:
			[1]: Util_upvr (copied, readonly)
		]]
		Util_upvr.Windows:SwitchWindow(Util_upvr.Windows.Object.Windows.Shop)
	end)
	return any_new_result1
end
return module