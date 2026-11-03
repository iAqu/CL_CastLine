-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:29
-- Luau version 6, Types version 3
-- Time taken: 0.001462 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
local var1_result1_upvr_2 = any_load_result1("DialogTextUtils")
function module_upvr.separateIntoTags(arg1) -- Line 12
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [55] 47. Error Block 9 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [55] 47. Error Block 9 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [1] 2. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [55.65666]
	-- KONSTANTERROR: [1] 2. Error Block 2 end (CF ANALYSIS FAILED)
end
local var1_result1_upvr = any_load_result1("DialogEventTypes")
function module_upvr.getBrokenParts(arg1, arg2) -- Line 36
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var5 = arg1[arg2]
	local var6
	if var5.type ~= var1_result1_upvr.WORD then
		return nil, nil, nil
	end
	local text = var5.text
	var6 = "%[[^%[^%]]+%]"
	local any_find_result1, any_find_result2 = text:find(var6)
	if not any_find_result1 then
		var6 = nil
		return var6, nil, nil
	end
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var6 = text:sub(1, any_find_result1 - 1)
		return var6
	end
	if 1 >= any_find_result1 or not INLINED() then
		var6 = nil
	end
	if any_find_result2 >= #text or not text:sub(any_find_result2 + 1) then
	end
	return var6, text:sub(any_find_result1 + 1, any_find_result2 - 1), nil
end
return module_upvr