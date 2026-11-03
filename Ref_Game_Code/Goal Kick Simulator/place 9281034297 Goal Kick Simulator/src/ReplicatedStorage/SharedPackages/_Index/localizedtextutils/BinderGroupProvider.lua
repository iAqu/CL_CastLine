-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:33
-- Luau version 6, Types version 3
-- Time taken: 0.001871 seconds

local module_upvr = {
	ClassName = "BinderGroupProvider";
	ServiceName = "BinderGroupProvider";
}
module_upvr.__index = module_upvr
local var2_upvr = require(script.Parent.loader).load(script)("Promise")
function module_upvr.new(arg1) -- Line 20
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: var2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	local var4 = arg1
	if not var4 then
		var4 = error("No initMethod")
	end
	setmetatable_result1._initMethod = var4
	setmetatable_result1._groupsAddedPromise = var2_upvr.new()
	setmetatable_result1._init = false
	setmetatable_result1._binderGroups = {}
	return setmetatable_result1
end
function module_upvr.PromiseGroupsAdded(arg1) -- Line 36
	return arg1._groupsAddedPromise
end
function module_upvr.Init(arg1, ...) -- Line 44
	assert(not arg1._init, "Already initialized")
	arg1._initMethod(arg1, ...)
	arg1._init = true
	arg1._groupsAddedPromise:Resolve()
end
function module_upvr.Start(arg1) -- Line 56
end
function module_upvr.__index(arg1, arg2) -- Line 60
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("%q Not a valid index":format(tostring(arg2)))
end
function module_upvr.Get(arg1, arg2) -- Line 74
	local var5
	if type(arg2) ~= "string" then
		var5 = false
	else
		var5 = true
	end
	assert(var5, "groupName must be a string")
	var5 = arg1
	return rawget(var5, arg2)
end
function module_upvr.Add(arg1, arg2, arg3) -- Line 85
	local var6
	if type(arg2) ~= "string" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad groupName")
	if type(arg3) ~= "table" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad binderGroup")
	var6 = not arg1._init
	assert(var6, "Already initialized")
	var6 = not arg1:Get(arg2)
	assert(var6, "Duplicate groupName")
	var6 = arg1._binderGroups
	table.insert(var6, arg3)
	arg1[arg2] = arg3
end
return module_upvr