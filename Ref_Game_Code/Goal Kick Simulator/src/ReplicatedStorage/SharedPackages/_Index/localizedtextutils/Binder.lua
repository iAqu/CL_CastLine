-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:45
-- Luau version 6, Types version 3
-- Time taken: 0.022069 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local CollectionService_upvr = game:GetService("CollectionService")
local var1_result1_upvr = any_load_result1("Signal")
local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "Binder"
local any_load_result1_result1_upvr_2 = any_load_result1("Maid")
function module_upvr.new(arg1, arg2, ...) -- Line 67
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable({}, module_upvr)
	setmetatable_result1_upvr._maid = any_load_result1_result1_upvr_2.new()
	local var8 = arg1
	if not var8 then
		var8 = error("Bad argument 'tagName', expected string")
	end
	setmetatable_result1_upvr._tagName = var8
	var8 = arg2
	local var9 = var8
	if not var9 then
		var9 = error("Bad argument 'constructor', expected table or function")
	end
	setmetatable_result1_upvr._constructor = var9
	setmetatable_result1_upvr._instToClass = {}
	setmetatable_result1_upvr._allClassSet = {}
	setmetatable_result1_upvr._pendingInstSet = {}
	setmetatable_result1_upvr._listeners = {}
	setmetatable_result1_upvr._args = {...}
	task.delay(5, function() -- Line 81
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		if not setmetatable_result1_upvr._loaded then
			warn("Binder %q is not loaded. Call :Start() on it!":format(setmetatable_result1_upvr._tagName))
		end
	end)
	return setmetatable_result1_upvr
end
function module_upvr.isBinder(arg1) -- Line 96
	local var27 = false
	if type(arg1) == "table" then
		var27 = false
		if type(arg1.Start) == "function" then
			var27 = false
			if type(arg1.GetTag) == "function" then
				var27 = false
				if type(arg1.GetConstructor) == "function" then
					var27 = false
					if type(arg1.ObserveInstance) == "function" then
						var27 = false
						if type(arg1.GetClassAddedSignal) == "function" then
							var27 = false
							if type(arg1.GetClassRemovingSignal) == "function" then
								var27 = false
								if type(arg1.GetClassRemovedSignal) == "function" then
									var27 = false
									if type(arg1.GetAll) == "function" then
										var27 = false
										if type(arg1.GetAllSet) == "function" then
											var27 = false
											if type(arg1.Bind) == "function" then
												var27 = false
												if type(arg1.Unbind) == "function" then
													var27 = false
													if type(arg1.BindClient) == "function" then
														var27 = false
														if type(arg1.UnbindClient) == "function" then
															var27 = false
															if type(arg1.Get) == "function" then
																var27 = false
																if type(arg1.Promise) == "function" then
																	if type(arg1.Destroy) ~= "function" then
																		var27 = false
																	else
																		var27 = true
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return var27
end
function module_upvr.Start(arg1) -- Line 119
	--[[ Upvalues[1]:
		[1]: CollectionService_upvr (readonly)
	]]
	if arg1._loaded then
	else
		arg1._loaded = true
		for _, v_2 in pairs(CollectionService_upvr:GetTagged(arg1._tagName)) do
			task.spawn(arg1._add, arg1, v_2)
		end
		arg1._maid:GiveTask(CollectionService_upvr:GetInstanceAddedSignal(arg1._tagName):Connect(function(arg1_2) -- Line 129
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_add(arg1_2)
		end))
		arg1._maid:GiveTask(CollectionService_upvr:GetInstanceRemovedSignal(arg1._tagName):Connect(function(arg1_3) -- Line 132
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_remove(arg1_3)
		end))
	end
end
function module_upvr.GetTag(arg1) -- Line 141
	return arg1._tagName
end
function module_upvr.GetConstructor(arg1) -- Line 151
	return arg1._constructor
end
function module_upvr.ObserveInstance(arg1, arg2, arg3) -- Line 162
	local var35 = arg1._listeners[arg2]
	if not var35 then
		var35 = {}
	end
	arg1._listeners[arg2] = var35
	arg1._listeners[arg2][arg3] = true
	return function() -- Line 166
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
		]]
		if not arg1._listeners[arg2] then
		else
			arg1._listeners[arg2][arg3] = nil
			if not next(arg1._listeners[arg2]) then
				arg1._listeners[arg2] = nil
			end
		end
	end
end
function module_upvr.GetClassAddedSignal(arg1) -- Line 194
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if arg1._classAddedSignal then
		return arg1._classAddedSignal
	end
	arg1._classAddedSignal = var1_result1_upvr.new()
	arg1._maid:GiveTask(arg1._classAddedSignal)
	return arg1._classAddedSignal
end
function module_upvr.GetClassRemovingSignal(arg1) -- Line 209
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if arg1._classRemovingSignal then
		return arg1._classRemovingSignal
	end
	arg1._classRemovingSignal = var1_result1_upvr.new()
	arg1._maid:GiveTask(arg1._classRemovingSignal)
	return arg1._classRemovingSignal
end
function module_upvr.GetClassRemovedSignal(arg1) -- Line 225
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if arg1._classRemovedSignal then
		return arg1._classRemovedSignal
	end
	arg1._classRemovedSignal = var1_result1_upvr.new()
	arg1._maid:GiveTask(arg1._classRemovedSignal)
	return arg1._classRemovedSignal
end
function module_upvr.GetAll(arg1) -- Line 254
	local module = {}
	for i, _ in pairs(arg1._allClassSet) do
		module[#module + 1] = i
	end
	return module
end
function module_upvr.GetAllSet(arg1) -- Line 285
	return arg1._allClassSet
end
function module_upvr.Bind(arg1, arg2) -- Line 302
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
	]]
	if RunService_upvr:IsClient() then
		warn("[Binder.Bind] - Bindings '%s' done on the client! Will be disrupted upon server replication! %s":format(arg1._tagName, debug.traceback()))
	end
	CollectionService_upvr:AddTag(arg2, arg1._tagName)
	return arg1:Get(arg2)
end
function module_upvr.Unbind(arg1, arg2) -- Line 318
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
	]]
	local var45
	if typeof(arg2) ~= "Instance" then
		var45 = false
	else
		var45 = true
	end
	assert(var45, "Bad inst'")
	if RunService_upvr:IsClient() then
		var45 = "[Binder.Bind] - Unbinding '%s' done on the client! Might be disrupted upon server replication! %s":format(arg1._tagName, debug.traceback())
		warn(var45)
	end
	CollectionService_upvr:RemoveTag(arg2, arg1._tagName)
end
function module_upvr.BindClient(arg1, arg2) -- Line 339
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
	]]
	if not RunService_upvr:IsClient() then
		warn("[Binder.BindClient] - Bindings '%s' done on the server! Will be replicated!":format(arg1._tagName))
	end
	CollectionService_upvr:AddTag(arg2, arg1._tagName)
	return arg1:Get(arg2)
end
function module_upvr.UnbindClient(arg1, arg2) -- Line 355
	--[[ Upvalues[1]:
		[1]: CollectionService_upvr (readonly)
	]]
	local var46
	if typeof(arg2) ~= "Instance" then
		var46 = false
	else
		var46 = true
	end
	assert(var46, "Bad inst")
	CollectionService_upvr:RemoveTag(arg2, arg1._tagName)
end
function module_upvr.Get(arg1, arg2) -- Line 366
	local var47
	if typeof(arg2) ~= "Instance" then
		var47 = false
	else
		var47 = true
	end
	assert(var47, "Argument 'inst' is not an Instance")
	var47 = arg1._instToClass
	return var47[arg2]
end
local var1_result1_upvr_2 = any_load_result1("promiseBoundClass")
function module_upvr.Promise(arg1, arg2, arg3) -- Line 378
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var49
	if typeof(arg2) ~= "Instance" then
		var49 = false
	else
		var49 = true
	end
	assert(var49, "Argument 'inst' is not an Instance")
	var49 = arg1
	return var1_result1_upvr_2(var49, arg2, arg3)
end
function module_upvr._add(arg1, arg2) -- Line 383
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 60 start (CF ANALYSIS FAILED)
	local var58
	if typeof(arg2) ~= "Instance" then
		var58 = false
	else
		var58 = true
	end
	assert(var58, "Argument 'inst' is not an Instance")
	var58 = arg1._instToClass
	if var58[arg2] then
	else
		var58 = arg1._pendingInstSet
		if var58[arg2] == true then
			var58 = "[Binder._add] - Reentered add. Still loading, probably caused by error in constructor."
			warn(var58)
			return
		end
		var58 = true
		arg1._pendingInstSet[arg2] = var58
		var58 = type(arg1._constructor)
		if var58 == "function" then
			var58 = arg1._constructor(arg2, unpack(arg1._args))
			-- KONSTANTWARNING: GOTO [87] #63
		end
		var58 = arg1._constructor.Create
		if var58 then
			var58 = arg1._constructor:Create(arg2, unpack(arg1._args))
			-- KONSTANTWARNING: GOTO [87] #63
		end
		-- KONSTANTERROR: [0] 1. Error Block 60 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [74] 54. Error Block 43 start (CF ANALYSIS FAILED)
		var58 = arg1._constructor.new(arg2, unpack(arg1._args))
		var58 = arg1._pendingInstSet[arg2]
		local var59
		if var58 ~= true then
			var58 = warn
			local function INLINED() -- Internal function, doesn't exist in bytecode
				var59 = arg1._constructor.ClassName
				return var59
			end
			if type(arg1._constructor) ~= "table" or not INLINED() then
				var59 = arg1._constructor
			end
			var58("[Binder._add] - Failed to load instance %q of %q, removed while loading!":format(arg2:GetFullName(), tostring(var59)))
			return
		end
		var58 = arg1._pendingInstSet
		local var60
		var58[arg2] = var60
		if arg1._instToClass[arg2] ~= nil then
			var60 = false
		else
			var60 = true
		end
		var58 = assert
		var58(var60, "Overwrote")
		var58 = var58
		if not var58 then
			var58 = {}
		end
		local var61 = var58
		var58 = arg1._allClassSet
		var58[var61] = true
		var58 = arg1._instToClass
		var58[arg2] = var61
		var58 = arg1._listeners[arg2]
		if var58 then
			for i_3, _ in pairs(var58) do
				task.spawn(i_3, var61)
				local var65
			end
		end
		if arg1._classAddedSignal then
			arg1._classAddedSignal:Fire(var65, arg2)
		end
		-- KONSTANTERROR: [74] 54. Error Block 43 end (CF ANALYSIS FAILED)
	end
end
local any_load_result1_result1_upvr = any_load_result1("MaidTaskUtils")
function module_upvr._remove(arg1, arg2) -- Line 439
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	arg1._pendingInstSet[arg2] = nil
	local var69 = arg1._instToClass[arg2]
	if var69 == nil then
	else
		if arg1._classRemovingSignal then
			arg1._classRemovingSignal:Fire(var69, arg2)
		end
		arg1._instToClass[arg2] = nil
		arg1._allClassSet[var69] = nil
		local var70 = arg1._listeners[arg2]
		if var70 then
			for i_4, _ in pairs(var70) do
				task.spawn(i_4, nil)
			end
		end
		if any_load_result1_result1_upvr.isValidTask(var69) then
			any_load_result1_result1_upvr.doTask(var69)
		end
		if arg1._classRemovedSignal then
			arg1._classRemovedSignal:Fire(var69, arg2)
		end
	end
end
function module_upvr.Destroy(arg1) -- Line 477
	local next_result1, next_result2 = next(arg1._instToClass)
	local var76
	while next_result2 ~= nil do
		arg1:_remove(next_result1)
		if arg1._instToClass[next_result1] ~= nil then
			var76 = false
		else
			var76 = true
		end
		assert(var76, "Failed to remove")
		var76 = arg1._instToClass
		local _, _ = next(var76)
	end
	arg1._maid:DoCleaning()
end
return module_upvr