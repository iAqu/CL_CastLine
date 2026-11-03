-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:11
-- Luau version 6, Types version 3
-- Time taken: 0.001593 seconds

local module_2_upvr = {
	ClassName = "InputModeType";
}
module_2_upvr.__index = module_2_upvr
function module_2_upvr.new(arg1, arg2) -- Line 18
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_2_upvr)
	setmetatable_result1._valid = {}
	setmetatable_result1.Name = arg1 or "Unnamed"
	setmetatable_result1:_addValidTypesFromTable(arg2)
	return setmetatable_result1
end
function module_2_upvr.isInputModeType(arg1) -- Line 34
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	local var3 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= module_2_upvr then
			var3 = false
		else
			var3 = true
		end
	end
	return var3
end
function module_2_upvr.IsValid(arg1, arg2) -- Line 43
	assert(arg2, "Must send in inputType")
	return arg1._valid[arg2]
end
function module_2_upvr.GetKeys(arg1) -- Line 53
	local module = {}
	for i, _ in pairs(arg1._valid) do
		table.insert(module, i)
	end
	return module
end
function module_2_upvr._addValidTypesFromTable(arg1, arg2) -- Line 61
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	for _, v_2 in pairs(arg2) do
		if typeof(v_2) == "EnumItem" then
			arg1._valid[v_2] = true
		elseif module_2_upvr.isInputModeType(v_2) then
			arg1:_addInputModeType(v_2)
		else
			warn("invalid key", v_2)
		end
	end
end
function module_2_upvr._addInputModeType(arg1, arg2) -- Line 73
	--[[ Upvalues[1]:
		[1]: module_2_upvr (readonly)
	]]
	assert(module_2_upvr.isInputModeType(arg2), "Bad inputModeType")
	for i_3, _ in pairs(arg2._valid) do
		arg1._valid[i_3] = true
	end
end
return module_2_upvr