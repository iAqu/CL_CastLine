-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:31
-- Luau version 6, Types version 3
-- Time taken: 0.001261 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
local var1_result1_upvr_2 = any_load_result1("DialogStyleUtils")
local var1_result1_upvr = any_load_result1("DialogTextUtils")
local any_load_result1_result1_upvr = any_load_result1("DialogApplyStyleUtils")
function module_upvr.addWhispers(arg1) -- Line 16
	--[[ Upvalues[4]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	any_load_result1_result1_upvr.apply(arg1, '(', ')', function(arg1_2, arg2) -- Line 17, Named "applyFunction"
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
		]]
		table.insert(arg1_2, arg2, module_upvr.createPushWhispherStyle())
		local var6 = arg2 + 1
		table.insert(arg1_2, var6, var1_result1_upvr.createAddVolumeMultiplier(0.2))
		local var7 = var6 + 1
		table.insert(arg1_2, var7, var1_result1_upvr.createAddPlaybackSpeedMultiplier(0.2))
		return var7 + 1
	end, function(arg1_3, arg2) -- Line 30, Named "deapplyFunction"
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_2 (copied, readonly)
			[3]: var1_result1_upvr (copied, readonly)
		]]
		table.insert(arg1, arg2, var1_result1_upvr_2.createPopStyle())
		local var8 = arg2 + 1
		table.insert(arg1_3, var8, var1_result1_upvr.createAddVolumeMultiplier(5))
		local var9 = var8 + 1
		table.insert(arg1_3, var9, var1_result1_upvr.createAddPlaybackSpeedMultiplier(5))
		local var10 = var9 + 1
		table.insert(arg1_3, var10, var1_result1_upvr.createPause(0.5))
		return var10 + 1
	end)
end
function module_upvr.createPushWhispherStyle() -- Line 49
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return var1_result1_upvr_2.createPushStyle({
		textColor3 = Color3.fromHSV(0, 0, 0.5);
		addPercentTextSize = -0.3;
	})
end
return module_upvr