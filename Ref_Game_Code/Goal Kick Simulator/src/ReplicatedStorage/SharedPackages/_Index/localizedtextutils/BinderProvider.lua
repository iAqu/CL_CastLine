-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:40
-- Luau version 6, Types version 3
-- Time taken: 0.003813 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("Promise")
local module_upvr = {
	ClassName = "BinderProvider";
	ServiceName = "BinderProvider";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2) -- Line 39
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 17 start (CF ANALYSIS FAILED)
	local setmetatable_result1 = setmetatable({}, module_upvr)
	if type(arg1) == "string" then
		setmetatable_result1.ServiceName = arg1
		-- KONSTANTWARNING: GOTO [37] #27
	end
	-- KONSTANTERROR: [0] 1. Error Block 17 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [18] 13. Error Block 18 start (CF ANALYSIS FAILED)
	local var5
	if type(arg1) == "function" and var5 == nil then
		warn("[BinderProvider] - Missing serviceName for binder provider. Please pass in a service name as the first argument.")
		var5 = arg1
	else
		error("Bad serviceName")
	end
	local var6 = var5
	if not var6 then
		var6 = error("No initMethod")
	end
	setmetatable_result1._initMethod = var6
	setmetatable_result1._initialized = false
	setmetatable_result1._started = false
	do
		return setmetatable_result1
	end
	-- KONSTANTERROR: [18] 13. Error Block 18 end (CF ANALYSIS FAILED)
end
function module_upvr.isBinderProvider(arg1) -- Line 66
	local var7 = false
	if type(arg1) == "table" then
		if arg1.ClassName ~= "BinderProvider" then
			var7 = false
		else
			var7 = true
		end
	end
	return var7
end
function module_upvr.PromiseBinder(arg1, arg2) -- Line 76
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	if arg1._bindersAddedPromise:IsFulfilled() then
		local any_Get_result1_2 = arg1:Get(arg2)
		if any_Get_result1_2 then
			return var1_result1_upvr_2.resolved(any_Get_result1_2)
		end
		return var1_result1_upvr_2.rejected()
	end
	return arg1._bindersAddedPromise:Then(function() -- Line 87
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: var1_result1_upvr_2 (copied, readonly)
		]]
		local any_Get_result1 = arg1:Get(arg2)
		if any_Get_result1 then
			return any_Get_result1
		end
		return var1_result1_upvr_2.rejected()
	end)
end
local var1_result1_upvr = any_load_result1("Maid")
function module_upvr.Init(arg1, ...) -- Line 102
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	assert(not arg1._initialized, "Already initialized")
	arg1._maid = var1_result1_upvr.new()
	arg1._binders = {}
	arg1._initialized = true
	arg1._bindersAddedPromise = var1_result1_upvr_2.new()
	arg1._maid:GiveTask(arg1._bindersAddedPromise)
	arg1._startPromise = var1_result1_upvr_2.new()
	arg1._maid:GiveTask(arg1._startPromise)
	arg1._initMethod(arg1, ...)
	arg1._bindersAddedPromise:Resolve()
end
function module_upvr.PromiseBindersAdded(arg1) -- Line 127
	return assert(arg1._bindersAddedPromise, "Be sure to require via serviceBag")
end
function module_upvr.PromiseBindersStarted(arg1) -- Line 136
	return assert(arg1._startPromise, "Be sure to require via serviceBag")
end
function module_upvr.Start(arg1) -- Line 143
	assert(arg1._initialized, "Not initialized")
	assert(not arg1._started, "Already started")
	arg1._started = true
	for _, v in pairs(arg1._binders) do
		v:Start()
	end
	arg1._startPromise:Resolve()
end
function module_upvr.__index(arg1, arg2) -- Line 155
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	error("%q Not a valid binder":format(tostring(arg2)))
end
function module_upvr.Get(arg1, arg2) -- Line 169
	local var17
	if type(arg2) ~= "string" then
		var17 = false
	else
		var17 = true
	end
	assert(var17, "tagName must be a string")
	var17 = arg1
	return rawget(var17, arg2)
end
function module_upvr.Add(arg1, arg2) -- Line 179
	assert(not arg1._started, "Already inited")
	assert(not arg1:Get(arg2:GetTag()), "Binder already exists")
	table.insert(arg1._binders, arg2)
	arg1[arg2:GetTag()] = arg2
end
function module_upvr.Destroy(arg1) -- Line 187
	for _, v_2 in pairs(arg1._binders) do
		rawset(arg1, v_2:GetTag(), nil)
	end
	arg1._maid:DoCleaning()
	arg1._binders = nil
end
return module_upvr