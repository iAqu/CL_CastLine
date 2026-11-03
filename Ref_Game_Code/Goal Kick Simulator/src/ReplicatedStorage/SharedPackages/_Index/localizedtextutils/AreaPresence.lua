-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:39
-- Luau version 6, Types version 3
-- Time taken: 0.001084 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "AreaPresence"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("Signal")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 15
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr_2.new(), setmetatable_result1_upvr)
	setmetatable_result1._area = assert(arg1, "Bad area")
	setmetatable_result1._activator = assert(arg2, "Bad activator")
	setmetatable_result1._activeParts = {}
	setmetatable_result1.Done = var1_result1_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.Done)
	return setmetatable_result1
end
function setmetatable_result1_upvr.DoInitialActivation(arg1) -- Line 29
	arg1._area:FireActivate(arg1)
	arg1._maid:GiveTask(function() -- Line 32
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._area:FireDeactivate(arg1)
	end)
end
function setmetatable_result1_upvr.GetArea(arg1) -- Line 37
	return arg1._area
end
function setmetatable_result1_upvr.GetAreaObject(arg1) -- Line 41
	return arg1._area:GetObject()
end
function setmetatable_result1_upvr.GetActivator(arg1) -- Line 45
	return arg1._activator
end
return setmetatable_result1_upvr