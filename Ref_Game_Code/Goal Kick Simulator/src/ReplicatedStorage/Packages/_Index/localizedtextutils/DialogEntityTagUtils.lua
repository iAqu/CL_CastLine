-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:48
-- Luau version 6, Types version 3
-- Time taken: 0.001441 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
function module_upvr.replaceContextTags(arg1, arg2) -- Line 14
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	repeat
	until 1 > #arg1
end
local var1_result1_upvr = any_load_result1("DialogEventTypes")
local var1_result1_upvr_2 = any_load_result1("DialogEntityTypes")
local var1_result1_upvr_3 = any_load_result1("DialogStyleUtils")
local var1_result1_upvr_4 = any_load_result1("DialogTextUtils")
function module_upvr.handleContextTag(arg1, arg2, arg3) -- Line 21
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	local var8 = arg1[arg2]
	if var8.type ~= var1_result1_upvr.TAG then
		return arg2 + 1
	end
	local var9 = arg3[var8.text]
	if not var9 then
		warn("[DialogEntityTagUtils.handleContextTag] - Failed to get contextItem for %q":format(tostring(var8.text)))
		return arg2 + 1
	end
	table.remove(arg1, arg2)
	if var9.type == var1_result1_upvr_2.ENTITY or var9.type == var1_result1_upvr_2.TALKER_ENTITY then
		assert(var9.text, "Bad text")
		table.insert(arg1, arg2, var1_result1_upvr_3.createPushStyle({
			textColor3 = arg3[var8.text].textColor3;
		}))
		local var11 = arg2 + 1
		table.insert(arg1, var11, var1_result1_upvr_4.createWord(var9.text))
		local var12 = var11 + 1
		table.insert(arg1, var12, var1_result1_upvr_3.createPopStyle())
		return var12 + 1
	end
	if var9.type == var1_result1_upvr_2.INPUT_HINT then
		assert(var9.inputKeyMapList, "Bad inputKeyMapList")
		table.insert(arg1, var12, var1_result1_upvr_4.createInputImage(var9.inputKeyMapList))
		return var12 + 1
	end
	warn("[DialogEntityTagUtils] - Unknown contextItem.type %q":format(tostring(var9.type)))
	return var12 + 1
end
return module_upvr