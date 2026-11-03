-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:24
-- Luau version 6, Types version 3
-- Time taken: 0.001962 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("LuvColor3Utils")
local module_upvr = {
	getTextColorForColoredBacking = function(arg1) -- Line 12, Named "getTextColorForColoredBacking"
		--[[ Upvalues[1]:
			[1]: var1_result1_upvr (readonly)
		]]
		local var4
		if typeof(arg1) ~= "Color3" then
			var4 = false
		else
			var4 = true
		end
		assert(var4, "Bad accentColor")
		var4 = var1_result1_upvr.fromColor3(arg1)
		local unpack_result1, unpack_result2_2, unpack_result3 = unpack(var4)
		if 75 <= unpack_result3 then
			return var1_result1_upvr.toColor3({unpack_result1, unpack_result2_2, 2})
		end
		return var1_result1_upvr.toColor3({unpack_result1, unpack_result2_2, 98})
	end;
}
local any_load_result1_result1_upvr = any_load_result1("Blend")
function module_upvr.computeTextColor(arg1, arg2) -- Line 23
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.Computed(arg1, arg2, function(arg1_2, arg2_2) -- Line 27
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: module_upvr (copied, readonly)
		]]
		local unpack_result1_4, _, unpack_result3_3 = unpack(var1_result1_upvr.fromColor3(arg1_2))
		if unpack_result3_3 <= 40 then
			return module_upvr.getTextColorForDarkBacking(arg2_2)
		end
		return module_upvr.getTextColorForLightBacking(arg2_2)
	end)
end
function module_upvr.getTextColorForLightBacking(arg1) -- Line 37
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var15
	if typeof(arg1) ~= "Color3" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad accentColor")
	var15 = var1_result1_upvr.fromColor3(arg1)
	local unpack_result1_3, unpack_result2_3, unpack_result3_2 = unpack(var15)
	return var1_result1_upvr.toColor3({unpack_result1_3, unpack_result2_3, math.min(unpack_result3_2, 70)})
end
function module_upvr.getTextColorForDarkBacking(arg1) -- Line 44
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var20
	if typeof(arg1) ~= "Color3" then
		var20 = false
	else
		var20 = true
	end
	assert(var20, "Bad accentColor")
	var20 = var1_result1_upvr.fromColor3(arg1)
	local unpack_result1_2, unpack_result2, unpack_result3_4 = unpack(var20)
	return var1_result1_upvr.toColor3({unpack_result1_2, unpack_result2, math.max(unpack_result3_4, 30)})
end
return module_upvr