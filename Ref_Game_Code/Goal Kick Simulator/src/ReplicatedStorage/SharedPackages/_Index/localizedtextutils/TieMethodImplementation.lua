-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:28
-- Luau version 6, Types version 3
-- Time taken: 0.001305 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_2_upvr = setmetatable({}, var1_result1_upvr)
setmetatable_result1_2_upvr.ClassName = "TieMethodImplementation"
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr.new(arg1, arg2, arg3, arg4) -- Line 14
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(var1_result1_upvr.new(), setmetatable_result1_2_upvr)
	setmetatable_result1._memberDefinition = assert(arg1, "No memberDefinition")
	setmetatable_result1._folder = assert(arg2, "No folder")
	setmetatable_result1._actualSelf = assert(arg4, "No actualSelf")
	setmetatable_result1._bindableFunction = Instance.new("BindableFunction")
	setmetatable_result1._bindableFunction.Name = arg1:GetMemberName()
	setmetatable_result1._bindableFunction.Archivable = false
	setmetatable_result1._bindableFunction.Parent = setmetatable_result1._folder
	setmetatable_result1._maid:GiveTask(setmetatable_result1._bindableFunction)
	setmetatable_result1:SetImplementation(arg3)
	return setmetatable_result1
end
local any_load_result1_result1_upvr = any_load_result1("TieUtils")
function setmetatable_result1_2_upvr.SetImplementation(arg1, arg2) -- Line 32
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	if type(arg2) == "function" then
		arg1._bindableFunction.OnInvoke = function(...) -- Line 34
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg2 (readonly)
				[3]: arg1 (readonly)
			]]
			return any_load_result1_result1_upvr.encode(arg2(arg1._actualSelf, any_load_result1_result1_upvr.decode(...)))
		end
	else
		if arg2 ~= nil then
			error("Bad implementation")
		end
		arg1._bindableFunction.OnInvoke = function() -- Line 42
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			warn("%q is not implemented":format(tostring(arg1._memberDefinition:GetMemberName())))
		end
	end
end
return setmetatable_result1_2_upvr