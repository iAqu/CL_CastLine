-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:28
-- Luau version 6, Types version 3
-- Time taken: 0.003038 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {
	ClassName = "TieInterface";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2, arg3) -- Line 15
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	assert(arg2 or arg3, "Folder or adornee required")
	setmetatable_result1._definition = assert(arg1, "No definition")
	setmetatable_result1._folder = arg2
	setmetatable_result1._adornee = arg3
	setmetatable_result1._memberDefinitionMap = setmetatable_result1._definition:GetMemberMap()
	return setmetatable_result1
end
function module_upvr.IsImplemented(arg1) -- Line 33
	local rawget_result1 = rawget(arg1, "_folder")
	local rawget_result1_2 = rawget(arg1, "_adornee")
	local rawget_result1_4 = rawget(arg1, "_definition")
	if rawget_result1 then
		if rawget_result1_2 then
			if rawget_result1.Parent ~= rawget_result1_2 then
				return false
			end
			if rawget_result1.Name ~= arg1:GetContainerName() then
				return false
			end
		end
		return rawget_result1_4:IsImplementation(rawget_result1)
	end
	return rawget_result1_4:HasImplementation(rawget_result1_2)
end
function module_upvr.ObserveIsImplemented(arg1) -- Line 58
	local rawget_result1_5 = rawget(arg1, "_folder")
	local rawget_result1_3 = rawget(arg1, "_adornee")
	local rawget_result1_6 = rawget(arg1, "_definition")
	if rawget_result1_5 then
		if rawget_result1_3 then
			return rawget_result1_6:ObserveIsImplementationOn(rawget_result1_5, rawget_result1_3)
		end
		return rawget_result1_6:ObserveIsImplementation(rawget_result1_5)
	end
	return rawget_result1_6:ObserveIsImplemented(rawget_result1_3)
end
local any_load_result1_result1_upvr_2 = any_load_result1("TieMethodInterfaceUtils")
local var1_result1_upvr = any_load_result1("TieSignalInterface")
local any_load_result1_result1_upvr = any_load_result1("TiePropertyInterface")
function module_upvr.__index(arg1, arg2) -- Line 74
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	local var13 = rawget(arg1, "_memberDefinitionMap")[arg2]
	if var13 then
		if var13.ClassName == "TieMethodDefinition" then
			return any_load_result1_result1_upvr_2.get(arg1, rawget(arg1, "_definition"), var13, rawget(arg1, "_folder"), rawget(arg1, "_adornee"))
		end
		if var13.ClassName == "TieSignalDefinition" then
			return var1_result1_upvr.new(rawget(arg1, "_folder"), rawget(arg1, "_adornee"), var13)
		end
		if var13.ClassName == "TiePropertyDefinition" then
			return any_load_result1_result1_upvr.new(rawget(arg1, "_folder"), rawget(arg1, "_adornee"), var13)
		end
		error("Unknown member definition %q":format(tostring(var13.ClassName)))
	else
		if module_upvr[arg2] then
			return module_upvr[arg2]
		end
		error("Bad %q is not a member of %s":format(tostring(arg2), rawget(arg1, "_definition"):GetContainerName()))
	end
end
return module_upvr