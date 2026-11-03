-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:38
-- Luau version 6, Types version 3
-- Time taken: 0.001439 seconds

local module_upvr = {}
local tbl_upvr_2 = {
	[Enum.UserInputType.MouseButton1] = true;
	[Enum.UserInputType.MouseButton2] = true;
	[Enum.UserInputType.MouseButton3] = true;
	[Enum.UserInputType.MouseWheel] = true;
	[Enum.UserInputType.MouseMovement] = true;
}
local tbl_upvr = {
	[Enum.UserInputType.MouseButton1] = true;
	[Enum.UserInputType.MouseButton2] = true;
	[Enum.UserInputType.MouseButton3] = true;
}
function module_upvr.isMouseUserInputType(arg1) -- Line 28
	--[[ Upvalues[1]:
		[1]: tbl_upvr_2 (readonly)
	]]
	local var4
	if typeof(arg1) ~= "EnumItem" then
		var4 = false
	else
		var4 = true
	end
	assert(var4, "Bad userInputType")
	var4 = tbl_upvr_2[arg1]
	return var4 or false
end
function module_upvr.isMouseButtonInputType(arg1) -- Line 40
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	local var5
	if typeof(arg1) ~= "EnumItem" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad userInputType")
	var5 = tbl_upvr[arg1]
	return var5 or false
end
function module_upvr.isSameInputObject(arg1, arg2) -- Line 54
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	assert(arg1, "Bad inputObject")
	assert(arg2, "Bad otherInputObject")
	if arg1 == arg2 then
		return true
	end
	local any_isMouseUserInputType_result1 = module_upvr.isMouseUserInputType(arg1.UserInputType)
	if any_isMouseUserInputType_result1 then
		if arg1.UserInputType ~= arg2.UserInputType then
			any_isMouseUserInputType_result1 = false
		else
			any_isMouseUserInputType_result1 = true
		end
		return any_isMouseUserInputType_result1
	end
	return false
end
return module_upvr