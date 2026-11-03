-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:15
-- Luau version 6, Types version 3
-- Time taken: 0.005270 seconds

local Utils_upvr = require(script.Parent.Utils)
local module_upvr = {
	DEPENDENCY_FOLDER_NAME = "node_modules";
	ModuleReplicationTypes = Utils_upvr.readonly({
		CLIENT = "client";
		SERVER = "server";
		SHARED = "shared";
		IGNORE = "ignore";
		PLUGIN = "plugin";
	});
	createScriptInfo = function(arg1, arg2, arg3) -- Line 23, Named "createScriptInfo"
		--[[ Upvalues[1]:
			[1]: Utils_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
		local var4
		if typeof(arg1) ~= "Instance" then
			var4 = false
		else
			var4 = true
		end
		assert(var4, "Bad instance")
		if type(arg2) ~= "string" then
			var4 = false
			-- KONSTANTWARNING: GOTO [24] #19
		end
		-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [23] 18. Error Block 22 start (CF ANALYSIS FAILED)
		var4 = true
		assert(var4, "Bad name")
		if type(arg3) ~= "string" then
			var4 = false
		else
			var4 = true
		end
		assert(var4, "Bad replicationMode")
		var4 = Utils_upvr
		var4 = {}
		var4.name = arg2
		var4.replicationMode = arg3
		var4.instance = arg1
		do
			return var4.readonly(var4)
		end
		-- KONSTANTERROR: [23] 18. Error Block 22 end (CF ANALYSIS FAILED)
	end;
}
function module_upvr.createScriptInfoLookup() -- Line 35
	--[[ Upvalues[2]:
		[1]: Utils_upvr (readonly)
		[2]: module_upvr (readonly)
	]]
	return Utils_upvr.readonly({
		[module_upvr.ModuleReplicationTypes.SERVER] = {};
		[module_upvr.ModuleReplicationTypes.CLIENT] = {};
		[module_upvr.ModuleReplicationTypes.SHARED] = {};
		[module_upvr.ModuleReplicationTypes.PLUGIN] = {};
	})
end
function module_upvr.getScriptInfoLookupForMode(arg1, arg2) -- Line 45
	local var6
	if type(arg1) ~= "table" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad scriptInfoLookup")
	if type(arg2) ~= "string" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad replicationMode")
	return arg1[arg2]
end
local BounceTemplateUtils_upvr = require(script.Parent.BounceTemplateUtils)
local Parent_upvr = script.Parent
function module_upvr.populateScriptInfoLookup(arg1, arg2, arg3) -- Line 52
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: BounceTemplateUtils_upvr (readonly)
		[3]: Parent_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 50 start (CF ANALYSIS FAILED)
	local var9
	if typeof(arg1) ~= "Instance" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad instance")
	if type(arg2) ~= "table" then
		var9 = false
		-- KONSTANTWARNING: GOTO [24] #19
	end
	-- KONSTANTERROR: [0] 1. Error Block 50 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 18. Error Block 52 start (CF ANALYSIS FAILED)
	var9 = true
	assert(var9, "Bad scriptInfoLookup")
	if type(arg3) ~= "string" then
		var9 = false
	else
		var9 = true
	end
	assert(var9, "Bad lastReplicationMode")
	-- KONSTANTERROR: [23] 18. Error Block 52 end (CF ANALYSIS FAILED)
end
local module_upvr_2 = {
	HoldingBindersServer = true;
	HoldingBindersClient = true;
	IKService = true;
	IKServiceClient = true;
}
local CollectionService_upvr = game:GetService("CollectionService")
function module_upvr.isAvailableInShared(arg1) -- Line 94
	--[[ Upvalues[2]:
		[1]: CollectionService_upvr (readonly)
		[2]: module_upvr_2 (readonly)
	]]
	if CollectionService_upvr:HasTag(arg1.instance, "LinkToShared") then
		return true
	end
	return module_upvr_2[arg1.name]
end
function module_upvr.addToInfoMap(arg1, arg2) -- Line 103
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var12
	if type(arg1) ~= "table" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad scriptInfoLookup")
	if type(arg2) ~= "table" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad scriptInfo")
	var12 = arg2.replicationMode
	local assert_result1 = assert(var12, "Bad replicationMode")
	var12 = assert(arg1[assert_result1], "Bad replicationMode")
	module_upvr.addToInfoMapForMode(var12, arg2)
	if assert_result1 == module_upvr.ModuleReplicationTypes.SHARED then
		module_upvr.addToInfoMapForMode(arg1[module_upvr.ModuleReplicationTypes.SERVER], arg2)
		module_upvr.addToInfoMapForMode(arg1[module_upvr.ModuleReplicationTypes.CLIENT], arg2)
	elseif module_upvr.isAvailableInShared(arg2) then
		module_upvr.addToInfoMapForMode(arg1[module_upvr.ModuleReplicationTypes.SHARED], arg2)
	end
end
function module_upvr.addToInfoMapForMode(arg1, arg2) -- Line 123
	if arg1[arg2.name] then
		warn("Duplicate module %q in same package under same replication scope. Only using first one. \n- %q\n- %q":format(arg2.name, arg2.instance:GetFullName(), arg1[arg2.name].instance:GetFullName()))
	else
		arg1[arg2.name] = arg2
	end
end
function module_upvr.getFolderReplicationMode(arg1, arg2) -- Line 135
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var14
	if type(arg1) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad folderName")
	if type(arg2) ~= "string" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad lastReplicationMode")
	var14 = module_upvr
	if arg1 == var14.DEPENDENCY_FOLDER_NAME then
		var14 = module_upvr.ModuleReplicationTypes
		return var14.IGNORE
	end
	var14 = module_upvr.ModuleReplicationTypes
	if arg2 == var14.PLUGIN then
		return arg2
	end
	if arg1 == "Shared" then
		var14 = module_upvr.ModuleReplicationTypes
		return var14.SHARED
	end
	if arg1 == "Client" then
		var14 = module_upvr.ModuleReplicationTypes
		return var14.CLIENT
	end
	if arg1 == "Server" then
		var14 = module_upvr.ModuleReplicationTypes
		return var14.SERVER
	end
	return arg2
end
return module_upvr