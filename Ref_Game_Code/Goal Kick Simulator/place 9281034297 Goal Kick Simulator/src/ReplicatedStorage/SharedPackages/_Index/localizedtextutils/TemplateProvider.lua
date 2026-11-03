-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:57
-- Luau version 6, Types version 3
-- Time taken: 0.008423 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local var1_result1_upvr_2 = any_load_result1("Maid")
local module_upvr = {
	ClassName = "TemplateProvider";
	ServiceName = "TemplateProvider";
}
module_upvr.__index = module_upvr
local StarterGui_upvr = game:GetService("StarterGui")
function module_upvr.new(arg1, arg2) -- Line 56
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: StarterGui_upvr (readonly)
		[3]: RunService_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._replicationParent = arg2
	setmetatable_result1._containersToInitializeSet = {}
	if typeof(arg1) == "Instance" or type(arg1) == "number" then
		setmetatable_result1._containersToInitializeSet[arg1] = true
	elseif typeof(arg1) == "table" then
		for _, v_7 in pairs(arg1) do
			local var14 = true
			if typeof(v_7) ~= "Instance" then
				if type(v_7) ~= "number" then
					var14 = false
				else
					var14 = true
				end
			end
			assert(var14, "Bad item in initialization set")
			var14 = true
			setmetatable_result1._containersToInitializeSet[v_7] = var14
			var14 = v_7
			if typeof(var14) == "Instance" and v_7:IsDescendantOf(StarterGui_upvr) and v_7:IsA("ScreenGui") and RunService_upvr:IsRunning() then
				v_7.Enabled = false
			end
		end
	end
	if setmetatable_result1._replicationParent then
		setmetatable_result1._containersToInitializeSet[setmetatable_result1._replicationParent] = true
	end
	return setmetatable_result1
end
function module_upvr.Init(arg1) -- Line 91
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	assert(not arg1._initialized, "Already initialized")
	arg1._maid = var1_result1_upvr_2.new()
	arg1._initialized = true
	arg1._registry = {}
	arg1._containersSet = {}
	arg1._promises = {}
	for i, _ in pairs(arg1._containersToInitializeSet) do
		arg1:AddContainer(i)
	end
end
local any_load_result1_result1_upvr = any_load_result1("Promise")
function module_upvr.PromiseClone(arg1, arg2) -- Line 111
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var21_upvr
	if type(arg2) ~= "string" then
		var21_upvr = false
	else
		var21_upvr = true
	end
	assert(var21_upvr, "templateName must be a string")
	arg1:_verifyInit()
	var21_upvr = arg1._registry
	if var21_upvr[arg2] then
		var21_upvr = any_load_result1_result1_upvr.resolved(arg1:Clone(arg2))
		return var21_upvr
	end
	var21_upvr = arg1._promises[arg2]
	if not var21_upvr then
		var21_upvr = any_load_result1_result1_upvr.new()
		arg1._promises[arg2] = var21_upvr
		arg1._maid[var21_upvr] = var21_upvr
		var21_upvr:Then(function() -- Line 127
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: var21_upvr (readonly)
			]]
			arg1._maid[var21_upvr] = nil
		end)
		task.delay(5, function() -- Line 131
			--[[ Upvalues[3]:
				[1]: var21_upvr (readonly)
				[2]: arg2 (readonly)
				[3]: arg1 (readonly)
			]]
			if var21_upvr:IsPending() then
				warn("[TemplateProvider.PromiseClone] - May fail to replicate template %q from cloud. %s":format(arg2, arg1:_getReplicationHint()))
			end
		end)
	end
	var21_upvr = arg1._promises[arg2]
	var21_upvr = var21_upvr:Then(function() -- Line 140
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		return arg1:Clone(arg2)
	end)
	return var21_upvr
end
function module_upvr._getReplicationHint(arg1) -- Line 146
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local var25 = ""
	if RunService_upvr:IsClient() then
		var25 = "Make sure the template provider is initialized on the server."
	end
	return var25
end
local var1_result1_upvr_3 = any_load_result1("String")
function module_upvr.Clone(arg1, arg2) -- Line 166
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local var27
	if type(arg2) ~= "string" then
		var27 = false
	else
		var27 = true
	end
	assert(var27, "templateName must be a string")
	arg1:_verifyInit()
	var27 = arg1._registry
	if not var27[arg2] then
		var27 = error
		var27("[TemplateProvider.Clone] - Cannot provide %q":format(tostring(arg2)))
		var27 = nil
		return var27
	end
	var27 = var27[arg2]:Clone()
	var27.Name = var1_result1_upvr_3.removePostfix(arg2, "Template")
	return var27
end
function module_upvr.Get(arg1, arg2) -- Line 188
	local var29
	if type(arg2) ~= "string" then
		var29 = false
	else
		var29 = true
	end
	assert(var29, "templateName must be a string")
	arg1:_verifyInit()
	var29 = arg1._registry
	return var29[arg2]
end
function module_upvr.AddContainer(arg1, arg2) -- Line 200
	local var30 = true
	if typeof(arg2) ~= "Instance" then
		if type(arg2) ~= "number" then
			var30 = false
		else
			var30 = true
		end
	end
	assert(var30, "Bad container")
	arg1:_verifyInit()
	if not arg1._containersSet[arg2] then
		arg1._containersSet[arg2] = true
		if type(arg2) == "number" then
			arg1._maid[arg2] = arg1:_loadCloudAsset(arg2)
			return
		end
		if typeof(arg2) == "Instance" then
			arg1._maid[arg2] = arg1:_loadFolder(arg2)
			return
		end
		error("Unknown container type to load")
	end
end
function module_upvr.RemoveContainer(arg1, arg2) -- Line 221
	local var31
	if typeof(arg2) ~= "Instance" then
		var31 = false
	else
		var31 = true
	end
	assert(var31, "Bad container")
	arg1:_verifyInit()
	var31 = nil
	arg1._containersSet[arg2] = var31
	var31 = nil
	arg1._maid[arg2] = var31
end
function module_upvr.IsAvailable(arg1, arg2) -- Line 234
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var32
	if type(arg2) ~= "string" then
		var32 = false
	else
		var32 = true
	end
	assert(var32, "templateName must be a string")
	arg1:_verifyInit()
	var32 = arg1._registry[arg2]
	if var32 == nil then
	else
	end
	return true
end
function module_upvr.GetAll(arg1) -- Line 246
	arg1:_verifyInit()
	local module_2 = {}
	for _, v_2 in pairs(arg1._registry) do
		table.insert(module_2, v_2)
	end
	return module_2
end
function module_upvr.GetContainers(arg1) -- Line 262
	arg1:_verifyInit()
	local module = {}
	for i_3, _ in pairs(arg1._containersSet) do
		table.insert(module, i_3)
	end
	return module
end
function module_upvr._verifyInit(arg1) -- Line 272
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not RunService_upvr:IsRunning() and not arg1._initialized then
		arg1:Init()
	end
	assert(arg1._initialized, "TemplateProvider is not initialized")
end
local var1_result1_upvr = any_load_result1("InsertServiceUtils")
function module_upvr._loadCloudAsset(arg1, arg2) -- Line 283
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: RunService_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local var50
	if type(arg2) ~= "number" then
		var50 = false
	else
		var50 = true
	end
	assert(var50, "Bad assetId")
	var50 = var1_result1_upvr_2
	local any_new_result1_upvr = var50.new()
	var50 = RunService_upvr:IsServer()
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var50 = RunService_upvr:IsRunning()
		return var50
	end
	if var50 or not INLINED() then
		var50 = any_new_result1_upvr:GivePromise(var1_result1_upvr.promiseAsset(arg2))
		var50 = var50:Then
		var50(function(arg1_2) -- Line 289
			--[[ Upvalues[3]:
				[1]: RunService_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: any_new_result1_upvr (readonly)
			]]
			if RunService_upvr:IsRunning() then
				for _, v_4 in pairs(arg1_2:GetChildren()) do
					v_4.Parent = arg1._replicationParent
				end
			else
				any_new_result1_upvr:GiveTask(arg1:_loadFolder(arg1_2))
			end
		end)
	end
	return any_new_result1_upvr
end
function module_upvr._transformParent(arg1, arg2) -- Line 305
	if typeof(arg2) == "Instance" then
		return arg2
	end
	local var58
	if type(arg2) == "function" then
		local arg2_result1 = arg2()
		if typeof(arg2_result1) ~= "Instance" then
			var58 = false
		else
			var58 = true
		end
		assert(var58, "Bad container")
		return arg2_result1
	end
	error("Bad getParent type")
end
function module_upvr._loadFolder(arg1, arg2) -- Line 317
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: RunService_upvr (readonly)
	]]
	local any_new_result1_upvr_2 = var1_result1_upvr_2.new()
	if RunService_upvr:IsRunning() then
		any_new_result1_upvr_2:GiveTask(arg2.ChildAdded:Connect(function(arg1_3) -- Line 322
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: any_new_result1_upvr_2 (readonly)
			]]
			arg1:_handleChildAdded(any_new_result1_upvr_2, arg1_3)
		end))
		any_new_result1_upvr_2:GiveTask(arg2.ChildRemoved:Connect(function(arg1_4) -- Line 325
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: any_new_result1_upvr_2 (readonly)
			]]
			arg1:_handleChildRemoved(any_new_result1_upvr_2, arg1_4)
		end))
	end
	for _, v_5 in pairs(arg2:GetChildren()) do
		arg1:_handleChildAdded(any_new_result1_upvr_2, v_5)
	end
	any_new_result1_upvr_2:GiveTask(function() -- Line 334
		--[[ Upvalues[3]:
			[1]: any_new_result1_upvr_2 (readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		any_new_result1_upvr_2:DoCleaning()
		for _, v_6 in pairs(arg2:GetChildren()) do
			arg1:_handleChildRemoved(any_new_result1_upvr_2, v_6)
		end
	end)
	return any_new_result1_upvr_2
end
function module_upvr._handleChildRemoved(arg1, arg2, arg3) -- Line 346
	arg2[arg3] = nil
	arg1:_removeFromRegistry(arg3)
end
function module_upvr._handleChildAdded(arg1, arg2, arg3) -- Line 351
	if arg3:IsA("Folder") then
		arg2[arg3] = arg1:_loadFolder(arg3)
	else
		arg1:_addToRegistery(arg3)
	end
end
function module_upvr._addToRegistery(arg1, arg2) -- Line 359
	local Name_2 = arg2.Name
	if arg1._registry[Name_2] then
		warn("[TemplateProvider._addToRegistery] - Duplicate %q in registery. Overridding":format(Name_2))
	end
	arg1._registry[Name_2] = arg2
	if arg1._promises[Name_2] then
		arg1._promises[Name_2]:Resolve(arg2)
		arg1._promises[Name_2] = nil
	end
end
function module_upvr._removeFromRegistry(arg1, arg2) -- Line 374
	local Name = arg2.Name
	if arg1._registry[Name] == arg2 then
		arg1._registry[Name] = nil
	end
end
function module_upvr.Destroy(arg1) -- Line 385
	arg1._maid:DoCleaning()
end
return module_upvr