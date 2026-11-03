-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:21
-- Luau version 6, Types version 3
-- Time taken: 0.006400 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local any_load_result1_upvr_result1_upvr = any_load_result1_upvr("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_upvr_result1_upvr)
setmetatable_result1_upvr.ClassName = "ServiceBag"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1_upvr("Signal")
function setmetatable_result1_upvr.new(arg1) -- Line 53
	--[[ Upvalues[3]:
		[1]: any_load_result1_upvr_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_upvr_result1_upvr.new(), setmetatable_result1_upvr)
	setmetatable_result1._services = {}
	setmetatable_result1._parentProvider = arg1
	setmetatable_result1._serviceTypesToInitializeSet = {}
	setmetatable_result1._initializedServiceTypeSet = {}
	setmetatable_result1._initializing = false
	setmetatable_result1._serviceTypesToStart = {}
	setmetatable_result1._destroying = var1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._destroying)
	return setmetatable_result1
end
function setmetatable_result1_upvr.isServiceBag(arg1) -- Line 77
	local var6 = false
	if type(arg1) == "table" then
		if arg1.ClassName ~= "ServiceBag" then
			var6 = false
		else
			var6 = true
		end
	end
	return var6
end
function setmetatable_result1_upvr.GetService(arg1, arg2) -- Line 89
	--[[ Upvalues[1]:
		[1]: any_load_result1_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var7
	if typeof(arg2) == "Instance" then
		var7 = any_load_result1_upvr(var7)
	end
	if type(var7) ~= "table" then
	else
	end
	assert(true, "Bad serviceType definition")
	if arg1._services[var7] then
		arg1:_ensureInitialization(var7)
		return arg1._services[var7]
	end
	if arg1._parentProvider then
		return arg1._parentProvider:GetService(var7)
	end
	arg1:_addServiceType(var7)
	arg1:_ensureInitialization(var7)
	return arg1._services[var7]
end
function setmetatable_result1_upvr.HasService(arg1, arg2) -- Line 117
	--[[ Upvalues[1]:
		[1]: any_load_result1_upvr (readonly)
	]]
	local var8
	if typeof(arg2) == "Instance" then
		var8 = any_load_result1_upvr(var8)
	end
	if arg1._services[var8] then
		return true
	end
	return false
end
function setmetatable_result1_upvr.Init(arg1) -- Line 133
	assert(not arg1._initializing, "Already initializing")
	assert(arg1._serviceTypesToInitializeSet, "Already initialized")
	arg1._initializing = true
	while next(arg1._serviceTypesToInitializeSet) do
		local next_result1 = next(arg1._serviceTypesToInitializeSet)
		arg1._serviceTypesToInitializeSet[next_result1] = nil
		arg1:_ensureInitialization(next_result1)
	end
	arg1._serviceTypesToInitializeSet = nil
	arg1._initializing = false
end
function setmetatable_result1_upvr.Start(arg1) -- Line 152
	assert(arg1._serviceTypesToStart, "Already started")
	assert(not arg1._initializing, "Still initializing")
	while next(arg1._serviceTypesToStart) do
		local popped = table.remove(arg1._serviceTypesToStart)
		local assert_result1_upvr = assert(arg1._services[popped], "No service")
		local any__getServiceName_result1_upvr = arg1:_getServiceName(popped)
		if assert_result1_upvr.Start then
			local var13_upvw
			local spawn = task.spawn
			spawn(function() -- Line 163
				--[[ Upvalues[3]:
					[1]: any__getServiceName_result1_upvr (readonly)
					[2]: var13_upvw (read and write)
					[3]: assert_result1_upvr (readonly)
				]]
				debug.setmemorycategory(any__getServiceName_result1_upvr)
				var13_upvw = coroutine.running()
				assert_result1_upvr:Start()
			end)
			if coroutine.status(var13_upvw) ~= "dead" then
				spawn = false
			else
				spawn = true
			end
			if not spawn then
				error("Starting service %q yielded":format(any__getServiceName_result1_upvr))
			end
		end
	end
	arg1._serviceTypesToStart = nil
end
function setmetatable_result1_upvr._getServiceName(arg1, arg2) -- Line 179
	local var16_upvw
	pcall(function() -- Line 181
		--[[ Upvalues[2]:
			[1]: var16_upvw (read and write)
			[2]: arg2 (readonly)
		]]
		var16_upvw = arg2.ServiceName
	end)
	if type(var16_upvw) == "string" then
		return var16_upvw
	end
	return tostring(arg2)
end
function setmetatable_result1_upvr.IsStarted(arg1) -- Line 195
	local var18
	if arg1._serviceTypesToStart ~= nil then
		var18 = false
	else
		var18 = true
	end
	return var18
end
function setmetatable_result1_upvr.CreateScope(arg1) -- Line 205
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_upvr (readonly)
	]]
	local any_new_result1_upvr = setmetatable_result1_upvr.new(arg1)
	arg1:_addServiceType(any_new_result1_upvr)
	arg1._maid[any_new_result1_upvr] = any_new_result1_upvr._destroying:Connect(function() -- Line 211
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		arg1._maid[any_new_result1_upvr] = nil
		arg1._services[any_new_result1_upvr] = nil
	end)
	return any_new_result1_upvr
end
function setmetatable_result1_upvr._addServiceType(arg1, arg2) -- Line 220
	if not arg1._serviceTypesToInitializeSet then
		error("Already finished initializing, cannot add %q":format(arg1:_getServiceName(arg2)))
	else
		if arg1._services[arg2] then return end
		local tbl = {}
		tbl.__index = arg2
		arg1._services[arg2] = setmetatable({}, tbl)
		arg1:_ensureInitialization(arg2)
	end
end
function setmetatable_result1_upvr._ensureInitialization(arg1, arg2) -- Line 238
	if arg1._initializedServiceTypeSet[arg2] then
	else
		if arg1._initializing then
			arg1._serviceTypesToInitializeSet[arg2] = nil
			arg1._initializedServiceTypeSet[arg2] = true
			arg1:_initService(arg2)
			return
		end
		if arg1._serviceTypesToInitializeSet then
			arg1._serviceTypesToInitializeSet[arg2] = true
			return
		end
		error(string.format("Cannot initialize service %q past initializing phase", arg1:_getServiceName(arg2)))
	end
end
function setmetatable_result1_upvr._initService(arg1, arg2) -- Line 255
	local assert_result1_upvr_2 = assert(arg1._services[arg2], "No service")
	local any__getServiceName_result1_upvr_2 = arg1:_getServiceName(arg2)
	if assert_result1_upvr_2.Init then
		local var24_upvw
		local spawn_2 = task.spawn
		spawn_2(function() -- Line 261
			--[[ Upvalues[4]:
				[1]: any__getServiceName_result1_upvr_2 (readonly)
				[2]: var24_upvw (read and write)
				[3]: assert_result1_upvr_2 (readonly)
				[4]: arg1 (readonly)
			]]
			debug.setmemorycategory(any__getServiceName_result1_upvr_2)
			var24_upvw = coroutine.running()
			assert_result1_upvr_2:Init(arg1)
		end)
		if coroutine.status(var24_upvw) ~= "dead" then
			spawn_2 = false
		else
			spawn_2 = true
		end
		if not spawn_2 then
			error("Initializing service %q yielded":format(any__getServiceName_result1_upvr_2))
		end
	end
	table.insert(arg1._serviceTypesToStart, arg2)
end
function setmetatable_result1_upvr.Destroy(arg1) -- Line 280
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_upvr (readonly)
	]]
	arg1._destroying:Fire()
	local _services = arg1._services
	local next_result1_2, next_result2_upvw = next(_services)
	while next_result2_upvw ~= nil do
		_services[next_result1_2] = nil
		if not arg1._serviceTypesToInitializeSet or not arg1._serviceTypesToInitializeSet[next_result1_2] then
			task.spawn(function() -- Line 291
				--[[ Upvalues[1]:
					[1]: next_result2_upvw (read and write)
				]]
				if next_result2_upvw.Destroy then
					next_result2_upvw:Destroy()
				end
			end)
		end
		local next_result1_3, next_result2 = next(_services)
		next_result2_upvw = next_result2
	end
	getmetatable(setmetatable_result1_upvr).Destroy(arg1)
end
return setmetatable_result1_upvr