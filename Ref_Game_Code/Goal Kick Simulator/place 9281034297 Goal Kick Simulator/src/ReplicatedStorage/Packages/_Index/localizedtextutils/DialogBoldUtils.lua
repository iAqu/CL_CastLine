-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:12
-- Luau version 6, Types version 3
-- Time taken: 0.000956 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
local var1_result1_upvr_2 = any_load_result1("DialogApplyStyleUtils")
function module_upvr.addBold(arg1, arg2) -- Line 12
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	var1_result1_upvr_2.applyStyling(arg1, "<b>", "</b>", module_upvr.createPushBoldStyle(arg2))
	var1_result1_upvr_2.applySingleStyling(arg1, '*', module_upvr.createPushBoldStyle(arg2))
end
local var1_result1_upvr = any_load_result1("DialogStyleUtils")
function module_upvr.createPushBoldStyle(arg1) -- Line 17
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return function() -- Line 18
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return var1_result1_upvr.createPushStyle({
			font = arg1:GetFont("title");
			addPercentTextSize = 0.5;
		})
	end
end
return module_upvr