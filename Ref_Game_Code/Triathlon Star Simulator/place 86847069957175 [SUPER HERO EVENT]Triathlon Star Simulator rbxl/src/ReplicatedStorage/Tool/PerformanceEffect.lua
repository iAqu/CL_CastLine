-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:24
-- Luau version 6, Types version 3
-- Time taken: 0.001126 seconds

local module = {}
local Players_upvr = game:GetService("Players")
local module_upvr = require(game:GetService("ReplicatedStorage"):WaitForChild("Tool"):WaitForChild("UIanima"))
function module.NormalClick(arg1, arg2, arg3) -- Line 8
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	module_upvr.NormalClick(arg1, arg2, arg3)
end
function module.CriticalClick(arg1, arg2, arg3) -- Line 12
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	module_upvr.NormalClick(arg1, arg2, true)
	module_upvr.CoinFountain(Players_upvr.LocalPlayer, arg1, math.random(10, 15))
end
function module.StageOne(arg1, arg2, arg3, arg4) -- Line 18
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	module_upvr.BonusEffect(arg1, arg2, arg3, arg4)
	module_upvr.CoinFountain(Players_upvr.LocalPlayer, arg1, math.random(10, 15))
end
function module.StageTwo(arg1, arg2, arg3, arg4) -- Line 24
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	module_upvr.BonusEffect(arg1, arg2, arg3, arg4)
	module_upvr.CoinFountain(Players_upvr.LocalPlayer, arg1, math.ceil(math.random(10, 15) * 1.5))
end
function module.StageThree(arg1, arg2, arg3, arg4) -- Line 31
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	local var4 = math.random(10, 15) * 2
	module_upvr.BonusEffect(arg1, arg2, arg3, arg4)
	module_upvr.CoinFountain(Players_upvr.LocalPlayer, arg1, var4)
	module_upvr.CoinFountain(Players_upvr.LocalPlayer, arg3, math.ceil(0.5 * var4))
end
return module