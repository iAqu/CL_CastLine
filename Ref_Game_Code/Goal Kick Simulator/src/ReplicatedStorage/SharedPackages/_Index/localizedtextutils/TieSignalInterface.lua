-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:19
-- Luau version 6, Types version 3
-- Time taken: 0.001573 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "TieSignalInterface";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2, arg3) -- Line 15
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	assert(arg1 or arg2, "Folder or adornee required")
	setmetatable_result1._folder = arg1
	setmetatable_result1._adornee = arg2
	setmetatable_result1._memberDefinition = assert(arg3, "No memberDefinition")
	setmetatable_result1._tieDefinition = setmetatable_result1._memberDefinition:GetTieDefinition()
	return setmetatable_result1
end
local var1_result1_upvr_2 = any_load_result1("TieUtils")
function module_upvr.Fire(arg1, ...) -- Line 28
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local any__getBindableEvent_result1 = arg1:_getBindableEvent()
	if not any__getBindableEvent_result1 then
		warn("[TieSignalInterface] - No bindableEvent for %q":format(arg1._memberDefinition:GetMemberName()))
	end
	any__getBindableEvent_result1:Fire(var1_result1_upvr_2.encode(...))
end
local var1_result1_upvr_3 = any_load_result1("TieSignalConnection")
function module_upvr.Connect(arg1, arg2) -- Line 37
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local var7
	if type(arg2) ~= "function" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad callback")
	var7 = var1_result1_upvr_3
	var7 = arg1._memberDefinition
	return var7.new(var7, arg1._folder, arg1._adornee, arg2)
end
function module_upvr._getBindableEvent(arg1) -- Line 43
	local any__getFolder_result1 = arg1:_getFolder()
	if not any__getFolder_result1 then
		return nil
	end
	local SOME = any__getFolder_result1:FindFirstChild(arg1._memberDefinition:GetMemberName())
	if SOME and SOME:IsA("BindableEvent") then
		return SOME
	end
	return nil
end
local var1_result1_upvr = any_load_result1("TieInterfaceUtils")
function module_upvr._getFolder(arg1) -- Line 57
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	return var1_result1_upvr.getFolder(arg1._tieDefinition, arg1._folder, arg1._adornee)
end
return module_upvr