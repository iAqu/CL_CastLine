-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:12
-- Luau version 6, Types version 3
-- Time taken: 0.001856 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("DialogEventTypes")
local tbl_upvr = {
	['.'] = true;
	['!'] = true;
	['?'] = true;
	[','] = true;
}
local module_upvr = {}
local any_load_result1_result1_upvr = any_load_result1("DialogTextUtils")
function module_upvr.addPunctuationPauses(arg1) -- Line 21
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [100] 84. Error Block 11 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [100] 84. Error Block 11 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [1] 2. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [101.65666]
	-- KONSTANTERROR: [1] 2. Error Block 2 end (CF ANALYSIS FAILED)
end
function module_upvr.tryToFindEllipsis(arg1, arg2) -- Line 53
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local var6 = arg1[arg2]
	if var6.type ~= var1_result1_upvr.WORD then
		return false
	end
	local var7, var8 = var6.text:gmatch("(%.%.[%.]+)(%s*)$")()
	if not var7 then
		return false
	end
	local any_sub_result1 = var6.text:sub(1, -(#var7 + #var8) - 1)
	if #any_sub_result1 == 0 then
		any_sub_result1 = nil
	end
	return any_sub_result1, var7, var8
end
function module_upvr.shouldAddPunctuationPause(arg1, arg2) -- Line 72
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local var10 = arg1[arg2]
	if var10.type ~= var1_result1_upvr.WORD then
		return false
	end
	if not tbl_upvr[var10.text:gmatch("(%p)%s*$")()] then
		return false
	end
	local var11 = arg1[arg2 + 1]
	if not var11 then
		return false
	end
	if var11.type == var1_result1_upvr.PAUSE then
		return false
	end
	return true
end
return module_upvr