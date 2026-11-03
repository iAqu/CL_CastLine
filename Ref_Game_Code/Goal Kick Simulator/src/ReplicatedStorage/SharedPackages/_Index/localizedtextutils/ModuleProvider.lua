-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:39
-- Luau version 6, Types version 3
-- Time taken: 0.005106 seconds

local module_upvr = {
	ClassName = "ModuleProvider";
	ServiceName = "ModuleProvider";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2, arg3, arg4) -- Line 11
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var2 = module_upvr
	local setmetatable_result1 = setmetatable({}, var2)
	if typeof(arg1) ~= "Instance" then
		var2 = false
	else
		var2 = true
	end
	assert(var2, "Bad parent")
	var2 = true
	if arg2 ~= nil then
		if type(arg2) ~= "function" then
			var2 = false
		else
			var2 = true
		end
	end
	assert(var2, "Bad checkModule")
	var2 = true
	if arg3 ~= nil then
		if type(arg3) ~= "function" then
			var2 = false
		else
			var2 = true
		end
	end
	assert(var2, "Bad initModule")
	var2 = true
	if arg4 ~= nil then
		if type(arg4) ~= "function" then
			var2 = false
		else
			var2 = true
		end
	end
	assert(var2, "Bad sortList")
	local var4 = arg1
	if not var4 then
		var4 = error
		var2 = "No parent"
		var4 = var4(var2)
	end
	setmetatable_result1._parent = var4
	setmetatable_result1._initModule = arg3
	setmetatable_result1._checkModule = arg2
	setmetatable_result1._sortList = arg4
	return setmetatable_result1
end
function module_upvr.Init(arg1) -- Line 28
	assert(not arg1._modulesList, "Already initialized")
	arg1._modulesList = {}
	arg1._moduleScriptToModule = {}
	arg1._registry = {}
	arg1:_processFolder(arg1._parent)
	if arg1._sortList then
		arg1._sortList(arg1._modulesList)
	end
	if arg1._initModule then
		for i, v in pairs(arg1._moduleScriptToModule) do
			arg1._initModule(v, i)
		end
	end
	arg1._moduleScriptToModule = nil
end
function module_upvr.GetModules(arg1) -- Line 50
	assert(arg1._modulesList, "Not initialized yet")
	return arg1._modulesList
end
function module_upvr.GetFromName(arg1, arg2) -- Line 56
	local _registry = arg1._registry
	assert(_registry, "Not initialized yet")
	if type(arg2) ~= "string" then
		_registry = false
	else
		_registry = true
	end
	assert(_registry, "Bad name")
	return arg1._registry[arg2]
end
function module_upvr._processFolder(arg1, arg2) -- Line 63
	for _, v_2 in pairs(arg2:GetChildren()) do
		if v_2:IsA("ModuleScript") then
			arg1:_addToRegistery(v_2)
		else
			arg1:_processFolder(v_2)
		end
	end
end
function module_upvr._addToRegistery(arg1, arg2) -- Line 73
	if arg1._registry[arg2.Name] then
		error("[ModuleProvider._addToRegistery] - Duplicate %q in registery":format(arg2.Name))
	end
	if not arg2.Parent:FindFirstChild("loader") then
		local clone_2 = script.Parent.ModuleProviderFakeLoader:Clone()
		clone_2.Name = "loader"
		clone_2.Archivable = false
		clone_2.Parent = arg2.Parent
	end
	local var23_upvw
	xpcall(function() -- Line 87
		--[[ Upvalues[2]:
			[1]: var23_upvw (read and write)
			[2]: arg2 (readonly)
		]]
		var23_upvw = require(arg2)
	end, function(arg1_3) -- Line 89
		--[[ Upvalues[1]:
			[1]: arg2 (readonly)
		]]
		error("[ModuleProvider._addToRegistery] - Failed to load %q due to %q":format(arg2:GetFullName(), tostring(arg1_3)))
	end)
	if arg1._checkModule then
		local any__checkModule_result1, any__checkModule_result2 = arg1._checkModule(var23_upvw, arg2)
		if not any__checkModule_result1 then
			error("[ModuleProvider] - Bad module %q - %q":format(arg2:GetFullName(), tostring(any__checkModule_result2)))
		end
	end
	table.insert(arg1._modulesList, var23_upvw)
	arg1._moduleScriptToModule[arg2] = var23_upvw
	arg1._registry[arg2.Name] = var23_upvw
end
return module_upvr