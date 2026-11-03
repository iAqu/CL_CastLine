-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:23
-- Luau version 6, Types version 3
-- Time taken: 0.001440 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "BinderGroup";
}
module_upvr.__index = module_upvr
local any_load_result1_result1_upvr_2 = any_load_result1("Signal")
function module_upvr.new(arg1, arg2) -- Line 28
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._binders = {}
	setmetatable_result1._bindersByTag = {}
	setmetatable_result1._validateConstructor = arg2
	setmetatable_result1.BinderAdded = any_load_result1_result1_upvr_2.new()
	setmetatable_result1:AddList(arg1)
	return setmetatable_result1
end
function module_upvr.AddList(arg1, arg2) -- Line 47
	local var9
	if type(arg2) ~= "table" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad binders")
	var9 = arg2
	for _, v in pairs(var9) do
		arg1:Add(v)
	end
end
local any_load_result1_result1_upvr = any_load_result1("Binder")
function module_upvr.Add(arg1, arg2) -- Line 62
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	assert(any_load_result1_result1_upvr.isBinder(arg2), "Binder is not a binder")
	if arg1._validateConstructor then
		assert(arg1._validateConstructor(arg2:GetConstructor()))
	end
	local any_GetTag_result1 = arg2:GetTag()
	if arg1._bindersByTag[any_GetTag_result1] then
		warn("[BinderGroup.Add] - Binder with tag %q already added. Adding again.")
	end
	arg1._bindersByTag[any_GetTag_result1] = arg2
	table.insert(arg1._binders, arg2)
	arg1.BinderAdded:Fire(arg2)
end
function module_upvr.GetBinders(arg1) -- Line 89
	assert(arg1._binders, "No self._binders")
	return arg1._binders
end
return module_upvr