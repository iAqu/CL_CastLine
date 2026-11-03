-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:22
-- Luau version 6, Types version 3
-- Time taken: 0.005766 seconds

local module_upvr_2 = {}
local module_upvr = {
	["nil"] = "ObjectValue";
	boolean = "BoolValue";
	number = "NumberValue";
	string = "StringValue";
	BrickColor = "BrickColorValue";
	CFrame = "CFrameValue";
	Color3 = "Color3Value";
	Instance = "ObjectValue";
	Ray = "RayValue";
	Vector3 = "Vector3Value";
}
local module_upvr_3 = {
	BoolValue = "boolean";
	NumberValue = "number";
	IntValue = "number";
	StringValue = "string";
	BrickColorValue = "BrickColor";
	CFrameValue = "CFrame";
	Color3Value = "Color3";
	ObjectValue = "Instance";
	RayValue = "Ray";
	Vector3Value = "Vector3";
}
function module_upvr_2.isValueBase(arg1) -- Line 42
	local var4 = false
	if typeof(arg1) == "Instance" then
		var4 = arg1:IsA("ValueBase")
	end
	return var4
end
function module_upvr_2.getValueBaseType(arg1) -- Line 52
	--[[ Upvalues[1]:
		[1]: module_upvr_3 (readonly)
	]]
	return module_upvr_3[arg1]
end
function module_upvr_2.getClassNameFromType(arg1) -- Line 62
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr[arg1]
end
function module_upvr_2.getOrCreateValue(arg1, arg2, arg3, arg4) -- Line 75
	-- KONSTANTERROR: [0] 1. Error Block 28 start (CF ANALYSIS FAILED)
	local var5
	if typeof(arg1) ~= "Instance" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad argument 'parent'")
	if type(arg2) ~= "string" then
		var5 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 28 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 30 start (CF ANALYSIS FAILED)
	var5 = true
	assert(var5, "Bad argument 'instanceType'")
	if type(arg3) ~= "string" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "Bad argument 'name'")
	local SOME = arg1:FindFirstChild(arg3)
	if SOME then
		var5 = SOME:IsA(arg2)
		if not var5 then
			var5 = warn
			var5("[ValueBaseUtils.getOrCreateValue] - Value of type %q of name %q is of type %q in %s instead":format(arg2, arg3, SOME.ClassName, SOME:GetFullName()))
		end
		return SOME
	end
	var5 = Instance.new(arg2)
	var5.Name = arg3
	var5.Value = arg4
	var5.Parent = arg1
	do
		return var5
	end
	-- KONSTANTERROR: [23] 18. Error Block 30 end (CF ANALYSIS FAILED)
end
function module_upvr_2.setValue(arg1, arg2, arg3, arg4) -- Line 107
	-- KONSTANTERROR: [0] 1. Error Block 28 start (CF ANALYSIS FAILED)
	local var7
	if typeof(arg1) ~= "Instance" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad argument 'parent'")
	if type(arg2) ~= "string" then
		var7 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 28 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 30 start (CF ANALYSIS FAILED)
	var7 = true
	assert(var7, "Bad argument 'instanceType'")
	if type(arg3) ~= "string" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad argument 'name'")
	local SOME_3 = arg1:FindFirstChild(arg3)
	if SOME_3 then
		var7 = SOME_3:IsA(arg2)
		if not var7 then
			var7 = warn
			var7("[ValueBaseUtils.setValue] - Value of type %q of name %q is of type %q in %s instead":format(arg2, arg3, SOME_3.ClassName, SOME_3:GetFullName()))
		end
		SOME_3.Value = arg4
	else
		var7 = Instance.new(arg2)
		var7.Name = arg3
		var7.Value = arg4
		var7.Parent = arg1
		-- KONSTANTERROR: [23] 18. Error Block 30 end (CF ANALYSIS FAILED)
	end
end
function module_upvr_2.getValue(arg1, arg2, arg3, arg4) -- Line 137
	-- KONSTANTERROR: [0] 1. Error Block 28 start (CF ANALYSIS FAILED)
	local var9
	if typeof(arg1) ~= "Instance" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad argument 'parent'")
	if type(arg2) ~= "string" then
		var9 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 28 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 30 start (CF ANALYSIS FAILED)
	var9 = true
	assert(var9, "Bad argument 'instanceType'")
	if type(arg3) ~= "string" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad argument 'name'")
	local SOME_2 = arg1:FindFirstChild(arg3)
	if SOME_2 then
		var9 = SOME_2:IsA(arg2)
		if var9 then
			var9 = SOME_2.Value
			return var9
		end
		var9 = warn
		var9("[ValueBaseUtils.getValue] - Value of type %q of name %q is of type %q in %s instead":format(arg2, arg3, SOME_2.ClassName, SOME_2:GetFullName()))
		var9 = nil
		return var9
	end
	do
		return arg4
	end
	-- KONSTANTERROR: [23] 18. Error Block 30 end (CF ANALYSIS FAILED)
end
function module_upvr_2.createGetSet(arg1, arg2) -- Line 165
	--[[ Upvalues[1]:
		[1]: module_upvr_2 (readonly)
	]]
	local var14
	if type(arg1) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad argument 'instanceType'")
	if type(arg2) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad argument 'name'")
	function var14(arg1_3, arg2_3) -- Line 173
		--[[ Upvalues[3]:
			[1]: module_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		local var15
		if typeof(arg1_3) ~= "Instance" then
			var15 = false
		else
			var15 = true
		end
		assert(var15, "Bad argument 'parent'")
		var15 = module_upvr_2
		var15 = arg1_3
		return var15.setValue(var15, arg1, arg2, arg2_3)
	end
	return function(arg1_2, arg2_2) -- Line 169
		--[[ Upvalues[3]:
			[1]: module_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		local var13
		if typeof(arg1_2) ~= "Instance" then
			var13 = false
		else
			var13 = true
		end
		assert(var13, "Bad argument 'parent'")
		var13 = module_upvr_2
		var13 = arg1_2
		return var13.getValue(var13, arg1, arg2, arg2_2)
	end, var14, function(arg1_4, arg2_4) -- Line 177
		--[[ Upvalues[3]:
			[1]: module_upvr_2 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		return module_upvr_2.getOrCreateValue(arg1_4, arg1, arg2, arg2_4)
	end
end
return module_upvr_2