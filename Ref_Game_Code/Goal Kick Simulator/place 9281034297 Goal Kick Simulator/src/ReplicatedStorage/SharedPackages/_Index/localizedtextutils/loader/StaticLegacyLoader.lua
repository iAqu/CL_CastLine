-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:16
-- Luau version 6, Types version 3
-- Time taken: 0.006374 seconds

local ScriptInfoUtils_upvr = require(script.Parent.ScriptInfoUtils)
local LoaderUtils_upvr = require(script.Parent.LoaderUtils)
local module_upvr = {
	ClassName = "StaticLegacyLoader";
}
module_upvr.__index = module_upvr
function module_upvr.new() -- Line 15
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return setmetatable({
		_packageLookups = {};
	}, module_upvr)
end
local function __call(arg1, arg2) -- Line 23
	return arg1:Require(arg2)
end
module_upvr.__call = __call
function module_upvr.Lock(arg1) -- Line 27
	error("Cannot start loader while not running")
end
function module_upvr.Require(arg1, arg2, arg3) -- Line 31
	if type(arg3) == "number" then
		return require(arg3)
	end
	if type(arg3) == "string" then
		local any__findModule_result1 = arg1:_findModule(arg2, arg3)
		if any__findModule_result1 then
			arg1:_ensureFakeLoader(any__findModule_result1)
			return require(any__findModule_result1)
		end
		error("Error: Library '"..tostring(arg3).."' does not exist.", 2)
	else
		if typeof(arg3) == "Instance" and arg3:IsA("ModuleScript") then
			return require(arg3)
		end
		error("Error: module must be a string or ModuleScript, got '%s' for '%s'":format(typeof(arg3), tostring(arg3)))
	end
end
function module_upvr._findModule(arg1, arg2, arg3) -- Line 51
	--[[ Upvalues[1]:
		[1]: ScriptInfoUtils_upvr (readonly)
	]]
	local var14
	if typeof(arg2) ~= "Instance" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad root")
	if type(arg3) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad name")
	local any__findPackageRoot_result1 = arg1:_findPackageRoot(arg2)
	while any__findPackageRoot_result1 do
		var14 = arg1:_getOrCreateLookup(any__findPackageRoot_result1)
		if var14[arg3] then
			return var14[arg3]
		end
		local SOME = any__findPackageRoot_result1:FindFirstChild(ScriptInfoUtils_upvr.DEPENDENCY_FOLDER_NAME)
		if SOME then
			for _, v in pairs(SOME:GetChildren()) do
				if v:IsA("Folder") and v.Name:sub(1, 1) == '@' then
					for _, v_2 in pairs(v:GetChildren()) do
						local any__getPackageFolderLookup_result1 = arg1:_getPackageFolderLookup(v_2)
						if any__getPackageFolderLookup_result1[arg3] then
							return any__getPackageFolderLookup_result1[arg3]
						end
					end
				else
					local any__getPackageFolderLookup_result1_2 = arg1:_getPackageFolderLookup(v)
					if any__getPackageFolderLookup_result1_2[arg3] then
						return any__getPackageFolderLookup_result1_2[arg3]
					end
				end
			end
		end
	end
	var14 = nil
	return var14
end
function module_upvr.GetLoader(arg1, arg2) -- Line 91
	local var25
	if typeof(arg2) ~= "Instance" then
		var25 = false
	else
		var25 = true
	end
	assert(var25, "Bad moduleScript")
	var25 = {}
	return setmetatable(var25, {
		__call = function(arg1_2, arg2_2) -- Line 95, Named "__call"
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
			]]
			return arg1:Require(arg2, arg2_2)
		end;
		__index = function(arg1_3, arg2_3) -- Line 98, Named "__index"
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
			]]
			return arg1:Require(arg2, arg2_3)
		end;
	})
end
function module_upvr._getPackageFolderLookup(arg1, arg2) -- Line 104
	if arg2:IsA("ObjectValue") then
		if arg2.Value then
			return arg1:_getOrCreateLookup(arg2.Value)
		end
		warn("[StaticLegacyLoader] - Bad link in packageFolder")
		return {}
	end
	if arg2:IsA("Folder") or arg2:IsA("Camera") then
		return arg1:_getOrCreateLookup(arg2)
	end
	if arg2:IsA("ModuleScript") then
		return arg1:_getOrCreateLookup(arg2)
	end
	warn("Unknown instance %q (%s) in dependencyFolder - %q":format(arg2.Name, arg2.ClassName, arg2:GetFullName()))
	return {}
end
function module_upvr._getOrCreateLookup(arg1, arg2) -- Line 123
	local var27
	if typeof(arg2) ~= "Instance" then
		var27 = false
	else
		var27 = true
	end
	assert(var27, "Bad packageFolderOrModuleScript")
	var27 = arg1._packageLookups
	if var27[arg2] then
		var27 = arg1._packageLookups
		return var27[arg2]
	end
	local module = {}
	var27 = arg1:_buildLookup
	var27(module, arg2)
	var27 = arg1._packageLookups
	var27[arg2] = module
	return module
end
function module_upvr._buildLookup(arg1, arg2, arg3) -- Line 138
	--[[ Upvalues[1]:
		[1]: ScriptInfoUtils_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [5] 5. Error Block 2 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 9. Error Block 15 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [10] 9. Error Block 15 end (CF ANALYSIS FAILED)
end
function module_upvr._findPackageRoot(arg1, arg2) -- Line 150
	--[[ Upvalues[1]:
		[1]: LoaderUtils_upvr (readonly)
	]]
	local var29
	if typeof(arg2) ~= "Instance" then
		var29 = false
	else
		var29 = true
	end
	assert(var29, "Bad instance")
	local Parent_3 = arg2.Parent
	while Parent_3 do
		var29 = game
		if Parent_3 == var29 then break end
		var29 = LoaderUtils_upvr.isPackage(Parent_3)
		if var29 then
			return Parent_3
		end
		var29 = arg1:_couldBePackageRootTopLevel(Parent_3)
		if var29 then
			return Parent_3
		end
	end
	var29 = nil
	return var29
end
function module_upvr._couldBePackageRootTopLevel(arg1, arg2) -- Line 168
	--[[ Upvalues[1]:
		[1]: LoaderUtils_upvr (readonly)
	]]
	for _, v_3 in pairs(arg2:GetChildren()) do
		if v_3:IsA("Folder") and v_3.Name:sub(1, 1) == '@' then
			for _, v_4 in pairs(v_3:GetChildren()) do
				if LoaderUtils_upvr.isPackage(v_4) then
					return true
				end
			end
		end
	end
	return true
end
local BounceTemplateUtils_upvr = require(script.Parent.BounceTemplateUtils)
local Parent_2_upvr = script.Parent
function module_upvr._ensureFakeLoader(arg1, arg2) -- Line 182
	--[[ Upvalues[2]:
		[1]: BounceTemplateUtils_upvr (readonly)
		[2]: Parent_2_upvr (readonly)
	]]
	local var43
	if typeof(arg2) ~= "Instance" then
		var43 = false
	else
		var43 = true
	end
	assert(var43, "Bad module")
	local Parent = arg2.Parent
	if not Parent then
		var43 = warn
		var43("[StaticLegacyLoader] - No parent")
	else
		if Load then
			var43 = true
		else
			var43 = false
		end
		local loader = Parent:FindFirstChild("loader")
		if loader then
			if BounceTemplateUtils_upvr.isBounceTemplate(loader) then
				loader.Archivable = var43
			end
			return
		end
		local any_create_result1 = BounceTemplateUtils_upvr.create(Parent_2_upvr, "loader")
		any_create_result1.Archivable = var43
		any_create_result1.Parent = Parent
	end
end
return module_upvr