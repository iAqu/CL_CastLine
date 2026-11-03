-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:37
-- Luau version 6, Types version 3
-- Time taken: 0.001596 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local any_new_result1_upvr = Util_upvr.Maid.new()
local CurrentCamera_upvr = workspace.CurrentCamera
function module.Shake(arg1, arg2, arg3, arg4) -- Line 9
	--[[ Upvalues[3]:
		[1]: any_new_result1_upvr (readonly)
		[2]: Util_upvr (readonly)
		[3]: CurrentCamera_upvr (readonly)
	]]
	local var5_upvw
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var5_upvw = arg2 * 0.4
		return var5_upvw
	end
	if not arg2 or not INLINED() then
		var5_upvw = 0.4
	end
	var5_upvw = any_new_result1_upvr
	local var7_upvw = 0
	local var8_upvw = arg4 or 1
	var5_upvw.Shaking = Util_upvr.Thread.Loop(function(arg1_2) -- Line 14
		--[[ Upvalues[6]:
			[1]: var7_upvw (read and write)
			[2]: var8_upvw (read and write)
			[3]: arg3 (readonly)
			[4]: any_new_result1_upvr (copied, readonly)
			[5]: var5_upvw (read and write)
			[6]: CurrentCamera_upvr (copied, readonly)
		]]
		var7_upvw += arg1_2
		local var9 = var7_upvw * math.pi * 2 * var8_upvw
		local var10
		if arg3 then
			local clamped = math.clamp(var7_upvw / arg3, 0, 1)
			if 1 <= clamped then
				any_new_result1_upvr.Shaking = nil
			end
			var10 = var5_upvw * (1 - clamped)
		end
		local var12 = var10
		if not var12 then
			var12 = var5_upvw
		end
		local var13 = var10
		if not var13 then
			var13 = var5_upvw
		end
		CurrentCamera_upvr.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(math.sin(var9) * var12 * arg1_2, math.cos(var9 / 3) * var13 / 2 * arg1_2, 0)
	end)
end
function module.Unshake(arg1) -- Line 32
	--[[ Upvalues[1]:
		[1]: any_new_result1_upvr (readonly)
	]]
	any_new_result1_upvr:Destroy()
end
return module