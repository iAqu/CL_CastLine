-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:05
-- Luau version 6, Types version 3
-- Time taken: 0.005648 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
local var1_result1_upvr = any_load_result1("DialogEventTypes")
local any_load_result1_result1_upvr = any_load_result1("DialogStyleUtils")
local var1_result1_upvr_2 = any_load_result1("DialogTextUtils")
function module_upvr.applyStyling(arg1, arg2, arg3, arg4) -- Line 13
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	module_upvr.apply(arg1, arg2, arg3, function(arg1_2, arg2_2) -- Line 14, Named "applyFunction"
		--[[ Upvalues[1]:
			[1]: arg4 (readonly)
		]]
		table.insert(arg1_2, arg2_2, arg4())
		return arg2_2 + 1
	end, function(arg1_3, arg2_3) -- Line 19, Named "deapplyFunction"
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		table.insert(arg1, arg2_3, any_load_result1_result1_upvr.createPopStyle())
		return arg2_3 + 1
	end)
end
function module_upvr.apply(arg1, arg2, arg3, arg4, arg5) -- Line 27
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	repeat
	until 1 > #arg1
end
function module_upvr.applySingleStyling(arg1, arg2, arg3) -- Line 34
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local const_number = 1
	while const_number <= #arg1 do
		local any_processWordForSingle_result1, _ = module_upvr.processWordForSingle(arg1, const_number, false, arg2, arg3)
	end
end
function module_upvr.processWordForSingle(arg1, arg2, arg3, arg4, arg5) -- Line 43
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	local var10 = arg1[arg2]
	local var11
	if var10.type ~= var1_result1_upvr.WORD then
		return var11 + 1, arg3
	end
	local any_find_result1_2 = var10.text:find(arg4, nil, true)
	if not any_find_result1_2 then
		return var11 + 1, arg3
	end
	local any_sub_result1_4 = var10.text:sub(1, any_find_result1_2 - 1)
	local any_sub_result1 = var10.text:sub(any_find_result1_2 + #arg4)
	table.remove(arg1, var11)
	if 0 < #any_sub_result1_4 then
		table.insert(arg1, var11, var1_result1_upvr_2.createWord(any_sub_result1_4))
		var11 += 1
	end
	if arg3 then
		table.insert(arg1, var11, any_load_result1_result1_upvr.createPopStyle())
		var11 += 1
	else
		table.insert(arg1, var11, arg5())
		var11 += 1
	end
	if 0 < #any_sub_result1 then
		table.insert(arg1, var11, var1_result1_upvr_2.createWord(any_sub_result1))
	end
	return var11, not arg3
end
function module_upvr.processWord(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 80
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local var15 = arg1[arg2]
	if var15.type ~= var1_result1_upvr.WORD then
		return arg2 + 1
	end
	local any_find_result1 = var15.text:find(arg4, nil, true)
	local var17
	if any_find_result1 and var17 and any_find_result1 < var17 then
		var17 = nil
		local var18
	end
	if var17 and any_find_result1 then
		table.remove(arg1, var18)
		local any_sub_result1_5 = var15.text:sub(1, var17 - 1)
		local any_sub_result1_8 = var15.text:sub(any_find_result1 + #arg4)
		if 0 < #any_sub_result1_5 then
			table.insert(arg1, var18, var1_result1_upvr_2.createWord(any_sub_result1_5))
			var18 += 1
		end
		var18 = arg5(arg1, var18)
		table.insert(arg1, var18, var1_result1_upvr_2.createWord(var15.text:sub(var17 + #arg3, any_find_result1 - 1)))
		var18 += 1
		var18 = arg6(arg1, var18)
		if 0 < #any_sub_result1_8 then
			table.insert(arg1, var18, var1_result1_upvr_2.createWord(any_sub_result1_8))
			var18 += 1
		end
		return var18
	end
	if var17 then
		table.remove(arg1, var18)
		local any_sub_result1_6 = var15.text:sub(1, var17 - 1)
		local any_sub_result1_2 = var15.text:sub(var17 + #arg3)
		if 0 < #any_sub_result1_6 then
			table.insert(arg1, var18, var1_result1_upvr_2.createWord(any_sub_result1_6))
			var18 += 1
		end
		var18 = arg5(arg1, var18)
		if 0 < #any_sub_result1_2 then
			table.insert(arg1, var18, var1_result1_upvr_2.createWord(any_sub_result1_2))
		end
		return var18
	end
	if any_find_result1 then
		table.remove(arg1, var18)
		local any_sub_result1_3 = var15.text:sub(1, any_find_result1 - 1)
		local any_sub_result1_7 = var15.text:sub(any_find_result1 + #arg4)
		if 0 < #any_sub_result1_3 then
			table.insert(arg1, var18, var1_result1_upvr_2.createWord(any_sub_result1_3))
			var18 += 1
		end
		var18 = arg6(arg1, var18)
		if 0 < #any_sub_result1_7 then
			table.insert(arg1, var18, var1_result1_upvr_2.createWord(any_sub_result1_7))
		end
		return var18
	end
	return var18 + 1
end
return module_upvr