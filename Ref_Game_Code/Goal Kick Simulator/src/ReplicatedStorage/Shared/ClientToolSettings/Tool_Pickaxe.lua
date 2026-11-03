-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:06
-- Luau version 6, Types version 3
-- Time taken: 0.000853 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Setup(arg1, arg2) -- Line 6
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	arg1.Maid:GiveTask(arg2.Equipped:Connect(function() -- Line 7
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		Util_upvr.MineController.Enabled = true
		Util_upvr.Animations:PlayAnimation("PickaxeIdle", "rbxassetid://9334695466")
		arg1.Maid.IdleAnimation = function() -- Line 10
			--[[ Upvalues[1]:
				[1]: Util_upvr (copied, readonly)
			]]
			Util_upvr.Animations:StopAnimation("PickaxeIdle")
		end
	end))
	arg1.Maid:GiveTask(arg2.Unequipped:Connect(function() -- Line 15
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		Util_upvr.MineController.Enabled = false
		arg1.Maid.IdleAnimation = nil
	end))
end
return module