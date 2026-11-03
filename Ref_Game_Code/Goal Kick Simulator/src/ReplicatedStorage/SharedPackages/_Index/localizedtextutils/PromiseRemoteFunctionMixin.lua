-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:02
-- Luau version 6, Types version 3
-- Time taken: 0.000924 seconds

local module = {
	Add = function(arg1, arg2, arg3) -- Line 40, Named "Add"
		local var2
		if type(arg2) ~= "table" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "Bad class")
		if type(arg3) ~= "string" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "Bad remoteFunctionName")
		var2 = not arg2.PromiseRemoteFunctionMixin
		assert(var2, "Class already has PromiseRemoteFunctionMixin defined")
		var2 = not arg2._remoteFunctionName
		assert(var2, "Class already has _remoteFunctionName defined")
		arg2.PromiseRemoteFunction = arg1.PromiseRemoteFunction
		arg2._remoteFunctionName = arg3
	end;
}
local var3_upvr = require(script.Parent.loader).load(script)("promiseChild")
function module.PromiseRemoteFunction(arg1) -- Line 54
	--[[ Upvalues[1]:
		[1]: var3_upvr (readonly)
	]]
	return arg1._maid:GivePromise(var3_upvr(arg1._obj, arg1._remoteFunctionName))
end
return module