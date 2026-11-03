-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:24
-- Luau version 6, Types version 3
-- Time taken: 0.008646 seconds

local RunService_upvr = game:GetService("RunService")
local CollectionService_upvr = game:GetService("CollectionService")
local Signal_upvr = require(script.Parent.Signal)
local module_upvr = {}
module_upvr.__index = module_upvr
module_upvr.ClassName = "Binder"
local Maid_upvr = require(script.Parent.Maid)
function module_upvr.new(arg1, arg2) -- Line 42
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Maid_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable({}, module_upvr)
	setmetatable_result1_upvr._maid = Maid_upvr.new()
	local var7 = arg1
	if not var7 then
		var7 = error("Bad argument 'tagName', expected string")
	end
	setmetatable_result1_upvr._tagName = var7
	var7 = arg2
	local var8 = var7
	if not var8 then
		var8 = error("Bad argument 'constructor', expected table or function: "..arg1)
	end
	setmetatable_result1_upvr._constructor = var8
	setmetatable_result1_upvr._instToClass = {}
	setmetatable_result1_upvr._allClassSet = {}
	setmetatable_result1_upvr._pendingInstSet = {}
	setmetatable_result1_upvr._listeners = {}
	task.delay(5, function() -- Line 55
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		if not setmetatable_result1_upvr._loaded then
			warn("Binder %q is not loaded. Call :Start() on it!":format(setmetatable_result1_upvr._tagName))
		end
	end)
	return setmetatable_result1_upvr
end
function module_upvr.isBinder(arg1) -- Line 67
	local var10 = false
	if type(arg1) == "table" then
		if arg1.ClassName ~= "Binder" then
			var10 = false
		else
			var10 = true
		end
	end
	return var10
end
function module_upvr.Start(arg1, ...) -- Line 72
	--[[ Upvalues[2]:
		[1]: Signal_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	if arg1._loaded then
	else
		arg1._loaded = true
		local any_new_result1 = Signal_upvr.new()
		for _, v_2_upvr in pairs(CollectionService_upvr:GetTagged(arg1._tagName)) do
			any_new_result1:Fire()
			any_new_result1:Connect(function() -- Line 81
				--[[ Upvalues[2]:
					[1]: arg1 (readonly)
					[2]: v_2_upvr (readonly)
				]]
				arg1:_add(v_2_upvr)
			end):Disconnect()
			local var24
		end
		var24:Destroy()
		arg1._maid:GiveTask(CollectionService_upvr:GetInstanceAddedSignal(arg1._tagName):Connect(function(arg1_2) -- Line 91
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_add(arg1_2)
		end))
		arg1._maid:GiveTask(CollectionService_upvr:GetInstanceRemovedSignal(arg1._tagName):Connect(function(arg1_3) -- Line 94
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_remove(arg1_3)
		end))
	end
end
function module_upvr.GetTag(arg1) -- Line 100
	return arg1._tagName
end
function module_upvr.GetConstructor(arg1) -- Line 105
	return arg1._constructor
end
function module_upvr.ObserveInstance(arg1, arg2, arg3) -- Line 110
	local var27 = arg1._listeners[arg2]
	if not var27 then
		var27 = {}
	end
	arg1._listeners[arg2] = var27
	arg1._listeners[arg2][arg3] = true
	return function() -- Line 114
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
function module_upvr.GetClassAddedSignal(arg1) -- Line 139
	--[[ Upvalues[1]:
		[1]: Signal_upvr (readonly)
	]]
	if arg1._classAddedSignal then
		return arg1._classAddedSignal
	end
	arg1._classAddedSignal = Signal_upvr.new()
	arg1._maid:GiveTask(arg1._classAddedSignal)
	return arg1._classAddedSignal
end
function module_upvr.GetClassRemovingSignal(arg1) -- Line 150
	--[[ Upvalues[1]:
		[1]: Signal_upvr (readonly)
	]]
	if arg1._classRemovingSignal then
		return arg1._classRemovingSignal
	end
	arg1._classRemovingSignal = Signal_upvr.new()
	arg1._maid:GiveTask(arg1._classRemovingSignal)
	return arg1._classRemovingSignal
end
function module_upvr.GetAll(arg1) -- Line 176
	local module = {}
	for i, _ in pairs(arg1._allClassSet) do
		module[#module + 1] = i
	end
	return module
end
function module_upvr.GetAllSet(arg1) -- Line 201
	return arg1._allClassSet
end
function module_upvr.Bind(arg1, arg2) -- Line 209
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
function module_upvr.Unbind(arg1, arg2) -- Line 220
	--[[ Upvalues[2]:
		[1]: RunService_upvr (readonly)
		[2]: CollectionService_upvr (readonly)
	]]
	local var37
	if typeof(arg2) ~= "Instance" then
		var37 = false
	else
		var37 = true
	end
	assert(var37)
	if RunService_upvr:IsClient() then
		var37 = "[Binder.Bind] - Unbinding '%s' done on the client! Might be disrupted upon server replication! %s":format(arg1._tagName, debug.traceback())
		warn(var37)
	end
	CollectionService_upvr:RemoveTag(arg2, arg1._tagName)
end
function module_upvr.BindClient(arg1, arg2) -- Line 234
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
function module_upvr.UnbindClient(arg1, arg2) -- Line 245
	--[[ Upvalues[1]:
		[1]: CollectionService_upvr (readonly)
	]]
	local var38
	if typeof(arg2) ~= "Instance" then
		var38 = false
	else
		var38 = true
	end
	assert(var38)
	CollectionService_upvr:RemoveTag(arg2, arg1._tagName)
end
function module_upvr.Get(arg1, arg2) -- Line 251
	local var39
	if typeof(arg2) ~= "Instance" then
		var39 = false
	else
		var39 = true
	end
	assert(var39, "Argument 'inst' is not an Instance")
	var39 = arg1._instToClass
	return var39[arg2]
end
function module_upvr.Promise(arg1, arg2, arg3) -- Line 256
	local var40
	if typeof(arg2) ~= "Instance" then
		var40 = false
	else
		var40 = true
	end
	assert(var40, "Argument 'inst' is not an Instance")
end
function module_upvr._add(arg1, arg2) -- Line 261
	--[[ Upvalues[1]:
		[1]: Signal_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 64 start (CF ANALYSIS FAILED)
	local var41
	if typeof(arg2) ~= "Instance" then
		var41 = false
	else
		var41 = true
	end
	assert(var41, "Argument 'inst' is not an Instance")
	var41 = arg1._instToClass
	if var41[arg2] then return end
	var41 = arg1._pendingInstSet
	if var41[arg2] == true then
		var41 = "[Binder._add] - Reentered add. Still loading, probably caused by error in constructor."
		warn(var41)
		return
	end
	var41 = true
	arg1._pendingInstSet[arg2] = var41
	var41 = type(arg1._constructor)
	if var41 == "function" then
		var41 = arg1._constructor(arg2)
		-- KONSTANTWARNING: GOTO [86] #63
	end
	var41 = arg1._constructor.Create
	if var41 then
		var41 = arg1._constructor:Create(arg2)
		-- KONSTANTWARNING: GOTO [86] #63
	end
	-- KONSTANTERROR: [0] 1. Error Block 64 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [62] 46. Error Block 54 start (CF ANALYSIS FAILED)
	var41 = arg1._constructor.new
	if var41 then
		var41 = arg1._constructor.new(arg2)
		-- KONSTANTWARNING: GOTO [86] #63
	end
	-- KONSTANTERROR: [62] 46. Error Block 54 end (CF ANALYSIS FAILED)
end
function module_upvr._remove(arg1, arg2) -- Line 332
	--[[ Upvalues[1]:
		[1]: Signal_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	arg1._pendingInstSet[arg2] = nil
	local var50 = arg1._instToClass[arg2]
	if var50 == nil then
	else
		if arg1._classRemovingSignal then
			arg1._classRemovingSignal:Fire(var50, arg2)
		end
		arg1._instToClass[arg2] = nil
		arg1._allClassSet[var50] = nil
		local var51 = arg1._listeners[arg2]
		if var51 then
			local any_new_result1_2 = Signal_upvr.new()
			for i_3_upvr, _ in pairs(var51) do
				any_new_result1_2:Fire()
				any_new_result1_2.Event:Connect(function() -- Line 355
					--[[ Upvalues[1]:
						[1]: i_3_upvr (readonly)
					]]
					i_3_upvr(nil)
				end):Disconnect()
				local var57
			end
			var57:Destroy()
		end
		if var50.Destroy then
			var50:Destroy()
			return
		end
	end
end
function module_upvr.Destroy(arg1) -- Line 376
	local next_result1, next_result2 = next(arg1._instToClass)
	while next_result2 ~= nil do
		arg1:_remove(next_result2)
		if arg1._instToClass[next_result1] ~= nil then
			arg1._instToClass[next_result1] = nil
		end
		local _, _ = next(arg1._instToClass)
	end
	arg1._maid:Destroy()
end
return module_upvr