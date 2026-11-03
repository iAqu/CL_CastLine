-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:08
-- Luau version 6, Types version 3
-- Time taken: 0.000663 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
local any_load_result1_result1_upvr = any_load_result1("DialogApplyStyleUtils")
function module_upvr.addItalics(arg1) -- Line 12
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	any_load_result1_result1_upvr.applyStyling(arg1, "<i>", "</i>", module_upvr.createPushEmphasisStyle)
	any_load_result1_result1_upvr.applySingleStyling(arg1, '_', module_upvr.createPushEmphasisStyle)
end
local any_load_result1_result1_upvr_2 = any_load_result1("DialogStyleUtils")
function module_upvr.createPushEmphasisStyle() -- Line 17
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	return any_load_result1_result1_upvr_2.createPushStyle({
		font = Enum.Font.SourceSansItalic;
	})
end
return module_upvr