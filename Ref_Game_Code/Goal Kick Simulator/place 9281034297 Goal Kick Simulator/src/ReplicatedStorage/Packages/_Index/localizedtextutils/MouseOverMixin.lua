-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:13
-- Luau version 6, Types version 3
-- Time taken: 0.003607 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("ButtonUtils")
local module = {
	Add = function(arg1, arg2) -- Line 13, Named "Add"
		assert(arg2, "Bad class")
		assert(not arg2.GetMouseOverColor, "Class already has GetMouseOverColor")
		arg2.GetMouseOverBoolValue = arg1.GetMouseOverBoolValue
		arg2.AddMouseOverEffect = arg1.AddMouseOverEffect
		arg2._getMouseOverTweenProperties = arg1._getMouseOverTweenProperties
	end;
}
local var1_result1_upvr = any_load_result1("Maid")
function module.GetMouseOverBoolValue(arg1, arg2) -- Line 22
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_upvr = var1_result1_upvr.new()
	local BoolValue_upvr = Instance.new("BoolValue")
	BoolValue_upvr.Value = false
	any_new_result1_upvr:GiveTask(BoolValue_upvr)
	any_new_result1_upvr:GiveTask(arg2.InputBegan:Connect(function(arg1_2) -- Line 29
		--[[ Upvalues[4]:
			[1]: BoolValue_upvr (readonly)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: arg2 (readonly)
		]]
		if arg1_2.UserInputType == Enum.UserInputType.MouseMovement then
			BoolValue_upvr.Value = true
		elseif arg1_2.UserInputType == Enum.UserInputType.Touch then
			local any_new_result1 = var1_result1_upvr.new()
			any_new_result1_upvr[arg1_2] = any_new_result1
			any_new_result1:GiveTask(arg2.InputEnded:Connect(function(arg1_3) -- Line 37
				--[[ Upvalues[3]:
					[1]: arg1_2 (readonly)
					[2]: any_new_result1_upvr (copied, readonly)
					[3]: BoolValue_upvr (copied, readonly)
				]]
				if arg1_3 == arg1_2 then
					any_new_result1_upvr[arg1_2] = nil
					BoolValue_upvr.Value = false
				end
			end))
			delay(0.2, function() -- Line 44
				--[[ Upvalues[3]:
					[1]: any_new_result1_upvr (copied, readonly)
					[2]: arg1_2 (readonly)
					[3]: BoolValue_upvr (copied, readonly)
				]]
				if any_new_result1_upvr[arg1_2] then
					BoolValue_upvr.Value = true
				end
			end)
		end
	end))
	any_new_result1_upvr:GiveTask(arg2.InputEnded:Connect(function(arg1_4) -- Line 52
		--[[ Upvalues[1]:
			[1]: BoolValue_upvr (readonly)
		]]
		if arg1_4.UserInputType == Enum.UserInputType.MouseMovement then
			BoolValue_upvr.Value = false
		end
	end))
	return any_new_result1_upvr, BoolValue_upvr
end
function module._getMouseOverTweenProperties(arg1, arg2) -- Line 61
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	if arg2:IsA("ImageButton") then
		return {
			ImageColor3 = any_load_result1_result1_upvr.getMouseOverColor(arg2.ImageColor3);
			BackgroundColor3 = any_load_result1_result1_upvr.getMouseOverColor(arg2.BackgroundColor3);
		}
	end
	return {
		BackgroundColor3 = any_load_result1_result1_upvr.getMouseOverColor(arg2.BackgroundColor3);
	}
end
function module.AddMouseOverEffect(arg1, arg2, arg3) -- Line 74
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var30 = arg3
	if not var30 then
		var30 = any_load_result1_result1_upvr._getMouseOverTweenProperties(arg2)
	end
	local var31_upvw = var30
	if arg2:IsA("GuiButton") then
		arg2.AutoButtonColor = false
	end
	local any_getMouseOverBoolValue_result1, any_getMouseOverBoolValue_result2_upvr = any_load_result1_result1_upvr.getMouseOverBoolValue(arg2)
	for i, _ in pairs(var31_upvw) do
		({})[i] = arg2[i]
		local var38_upvr
	end
	if not any_getMouseOverBoolValue_result2_upvr.Value or not var31_upvw then
	end
	for i_3, v_3 in pairs(var38_upvr) do
		arg2[i_3] = v_3
	end
	any_getMouseOverBoolValue_result1:GiveTask(any_getMouseOverBoolValue_result2_upvr.Changed:Connect(function() -- Line 87, Named "update"
		--[[ Upvalues[4]:
			[1]: any_getMouseOverBoolValue_result2_upvr (readonly)
			[2]: var31_upvw (read and write)
			[3]: var38_upvr (readonly)
			[4]: arg2 (readonly)
		]]
		local var43
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var43 = var31_upvw
			return var43
		end
		if not any_getMouseOverBoolValue_result2_upvr.Value or not INLINED() then
			var43 = var38_upvr
		end
		for i_2, v_2 in pairs(var43) do
			arg2[i_2] = v_2
		end
	end))
	arg1._maid[any_getMouseOverBoolValue_result2_upvr] = any_getMouseOverBoolValue_result1
	return any_getMouseOverBoolValue_result2_upvr
end
return module