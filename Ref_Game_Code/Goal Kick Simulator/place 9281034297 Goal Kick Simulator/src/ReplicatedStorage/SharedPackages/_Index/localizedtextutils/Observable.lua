-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:13
-- Luau version 6, Types version 3
-- Time taken: 0.002088 seconds

local module_upvr = {
	ClassName = "Observable";
}
module_upvr.__index = module_upvr
function module_upvr.isObservable(arg1) -- Line 73
	local var2 = false
	if type(arg1) == "table" then
		if arg1.ClassName ~= "Observable" then
			var2 = false
		else
			var2 = true
		end
	end
	return var2
end
function module_upvr.new(arg1) -- Line 105
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local var3
	if type(arg1) ~= "function" then
		var3 = false
	else
		var3 = true
	end
	assert(var3, "Bad onSubscribe")
	var3 = {}
	var3._source = ""
	var3._onSubscribe = arg1
	return setmetatable(var3, module_upvr)
end
function module_upvr.Pipe(arg1, arg2) -- Line 134
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var12
	if type(arg2) ~= "table" then
		var12 = false
	else
		var12 = true
	end
	assert(var12, "Bad transformers")
	var12 = pairs(arg2)
	for _, v in pairs(arg2) do
		local var16
		if type(v) ~= "function" then
			var16 = false
		else
			var16 = true
		end
		assert(var16, "Bad transformer")
		var16 = arg1
		local v_result1 = v(var16)
		var16 = module_upvr.isObservable(v_result1)
		assert(var16)
	end
	return v_result1
end
local var18_upvr = require(script.Parent.loader).load(script)("Subscription")
function module_upvr.Subscribe(arg1, arg2, arg3, arg4) -- Line 156
	--[[ Upvalues[1]:
		[1]: var18_upvr (readonly)
	]]
	local any_new_result1 = var18_upvr.new(arg2, arg3, arg4)
	local any__onSubscribe_result1 = arg1._onSubscribe(any_new_result1)
	if any__onSubscribe_result1 then
		any_new_result1:_giveCleanup(any__onSubscribe_result1)
	end
	return any_new_result1
end
return module_upvr