-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:19
-- Luau version 6, Types version 3
-- Time taken: 0.001602 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("DialogEventTypes")
local module_2_upvr = {}
local var1_result1_upvr = any_load_result1("DialogConstants")
function module_2_upvr.getStyleFromStack(arg1) -- Line 12
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local module = {}
	local var8
	for i = #arg1, 1, -1 do
		local var9 = arg1[i]
		local font = module.font
		if not font then
			font = var9.font
		end
		module.font = font
		font = module.textColor3
		local var11 = font
		if not var11 then
			var11 = var9.textColor3
		end
		module.textColor3 = var11
		if var9.addPercentTextSize then
			var8 += var9.addPercentTextSize
		end
	end
	module.textSize = math.ceil(var8 * var1_result1_upvr.DEFAULT_TEXT_SIZE)
	return module
end
function module_2_upvr.createPushStyle(arg1) -- Line 29
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return {
		type = var1_result1_upvr_2.PUSH_STYLE;
		addPercentTextSize = arg1.addPercentTextSize;
		textColor3 = arg1.textColor3;
		font = arg1.font;
	}
end
function module_2_upvr.createPopStyle() -- Line 38
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	return {
		type = var1_result1_upvr_2.POP_STYLE;
	}
end
function module_2_upvr.createPushDefaultStyle() -- Line 44
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return module_2_upvr.createPushStyle({
		font = Enum.Font.SourceSans;
		textColor3 = Color3.new(0, 0, 0);
	})
end
function module_2_upvr.createDefaultStack() -- Line 51
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	return {module_2_upvr.createPushDefaultStyle()}
end
return module_2_upvr