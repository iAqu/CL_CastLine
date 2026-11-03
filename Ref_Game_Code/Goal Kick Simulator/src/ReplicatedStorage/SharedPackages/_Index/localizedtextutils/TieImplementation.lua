-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:39
-- Luau version 6, Types version 3
-- Time taken: 0.002574 seconds

local var1_upvr = require(script.Parent.loader).load(script)("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_upvr.ClassName = "TieImplementation"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1, arg2, arg3) -- Line 17
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_upvr.new(), setmetatable_result1_upvr)
	setmetatable_result1._definition = assert(arg1, "No definition")
	setmetatable_result1._adornee = assert(arg2, "No adornee")
	local var4 = arg3
	if not var4 then
		var4 = {}
	end
	setmetatable_result1._actualSelf = var4
	setmetatable_result1._folder = Instance.new("Folder")
	setmetatable_result1._folder.Name = setmetatable_result1._definition:GetContainerName()
	setmetatable_result1._folder.Archivable = false
	setmetatable_result1._maid:GiveTask(setmetatable_result1._folder)
	setmetatable_result1._memberImplementations = {}
	setmetatable_result1._memberMap = setmetatable_result1._definition:GetMemberMap()
	setmetatable_result1:_buildMemberImplementations(arg3)
	setmetatable_result1._folder.Parent = setmetatable_result1._adornee
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetFolder(arg1) -- Line 39
	return arg1._folder
end
function setmetatable_result1_upvr.__index(arg1, arg2) -- Line 43
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_upvr (readonly)
	]]
	if setmetatable_result1_upvr[arg2] then
		return setmetatable_result1_upvr[arg2]
	end
	if arg2 == "_folder" or arg2 == "_adornee" or arg2 == "_definition" or arg2 == "_memberImplementations" or arg2 == "_memberMap" or arg2 == "_actualSelf" then
		return rawget(arg1, arg2)
	end
	local rawget_result1 = rawget(arg1, "_memberMap")
	if rawget_result1[arg2] then
		return rawget_result1[arg2]:GetInterface(arg1._folder, arg1)
	end
	error("Bad index %q for TieImplementation":format(tostring(arg2)))
end
function setmetatable_result1_upvr.__newindex(arg1, arg2, arg3) -- Line 66
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_upvr (readonly)
	]]
	if arg2 == "_folder" or arg2 == "_adornee" or arg2 == "_definition" or arg2 == "_memberImplementations" or arg2 == "_memberMap" or arg2 == "_actualSelf" then
		rawset(arg1, arg2, arg3)
	else
		if arg1._memberImplementations[arg2] then
			arg1._memberImplementations[arg2]:SetImplementation(arg3, arg1._actualSelf)
			return
		end
		if setmetatable_result1_upvr[arg2] then
			error("Cannot set %q in TieImplementation":format(tostring(arg2)))
			return
		end
		error("Bad index %q for TieImplementation":format(tostring(arg2)))
	end
end
function setmetatable_result1_upvr._buildMemberImplementations(arg1, arg2) -- Line 84
	for _, v in pairs(arg1._definition:GetMemberMap()) do
		local var13
		if arg2 then
			local any_GetMemberName_result1 = v:GetMemberName()
			var13 = arg2[any_GetMemberName_result1]
			if not var13 then
				error("Missing member %q on %q":format(any_GetMemberName_result1, arg1._adornee:GetFullName()))
				-- KONSTANTWARNING: GOTO [31] #24
			end
		else
			var13 = nil
		end
		local any_Implement_result1 = v:Implement(arg1._folder, var13, arg1._actualSelf)
		arg1._maid:GiveTask(any_Implement_result1)
		arg1._memberImplementations[v:GetMemberName()] = any_Implement_result1
	end
end
return setmetatable_result1_upvr