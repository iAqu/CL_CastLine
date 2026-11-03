-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:31
-- Luau version 6, Types version 3
-- Time taken: 0.002942 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Blend")
local var1_result1_upvr_3 = any_load_result1("Rx")
local var1_result1_upvr = any_load_result1("RxInstanceUtils")
local module_upvr = {}
local GuiService_upvr = game:GetService("GuiService")
function module_upvr.getUIScale(arg1) -- Line 23
	--[[ Upvalues[1]:
		[1]: GuiService_upvr (readonly)
	]]
	local var7
	if typeof(arg1) ~= "Vector2" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad screenAbsoluteSize")
	var7 = arg1.x
	local minimum_2 = math.min(var7, arg1.y)
	var7 = arg1.y
	if GuiService_upvr:IsTenFootInterface() then
		return 2
	end
	if 900 <= minimum_2 then
		return 1.5
	end
	if 700 <= minimum_2 then
		return 1.25
	end
	if 500 <= var7 then
		return 1
	end
	if 325 <= var7 then
		return 0.75
	end
	return 0.6
end
function module_upvr.observeUIScale(arg1) -- Line 48
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: module_upvr (readonly)
	]]
	return var1_result1_upvr_2.Spring(var1_result1_upvr.observeProperty(arg1, "AbsoluteSize"):Pipe({var1_result1_upvr_3.map(module_upvr.getUIScale)}), 30)
end
function module_upvr.renderUIScale(arg1) -- Line 61
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	assert(arg1.ScreenGui, "No screenGui")
	return var1_result1_upvr_2.New("UIScale")({
		Parent = arg1.Parent;
		Scale = module_upvr.observeUIScale(arg1.ScreenGui);
	})
end
function module_upvr.renderDialogPadding(arg1) -- Line 76
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	assert(arg1.ScreenGui, "No screenGui")
	return var1_result1_upvr_2.New("UIPadding")({
		Parent = arg1.Parent;
		PaddingTop = module_upvr.observeDialogPadding(arg1.ScreenGui);
		PaddingBottom = module_upvr.observeDialogPadding(arg1.ScreenGui);
		PaddingLeft = module_upvr.observeDialogPadding(arg1.ScreenGui);
		PaddingRight = module_upvr.observeDialogPadding(arg1.ScreenGui);
	})
end
function module_upvr.observeDialogPadding(arg1) -- Line 93
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: module_upvr (readonly)
	]]
	return var1_result1_upvr_2.Spring(var1_result1_upvr.observeProperty(arg1, "AbsoluteSize"):Pipe({var1_result1_upvr_3.map(module_upvr.getDialogPadding)}), 30):Pipe({var1_result1_upvr_3.map(function(arg1_2) -- Line 98
		return UDim.new(0, arg1_2)
	end)})
end
function module_upvr.getDialogPadding(arg1) -- Line 109
	local var15
	if typeof(arg1) ~= "Vector2" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad screenAbsoluteSize")
	var15 = arg1.x
	local minimum = math.min(var15, arg1.y)
	var15 = 300
	if minimum <= var15 then
		var15 = 5
		return var15
	end
	var15 = 500
	if minimum <= var15 then
		var15 = 10
		return var15
	end
	var15 = 700
	if minimum <= var15 then
		var15 = 25
		return var15
	end
	var15 = 50
	return var15
end
return module_upvr