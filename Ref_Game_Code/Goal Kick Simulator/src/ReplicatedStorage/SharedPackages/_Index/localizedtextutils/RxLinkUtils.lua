-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:44
-- Luau version 6, Types version 3
-- Time taken: 0.003195 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr = any_load_result1("RxInstanceUtils")
local module_upvr = {}
local var1_result1_upvr_3 = any_load_result1("Rx")
function module_upvr.observeValidLinksBrio(arg1, arg2) -- Line 17
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: module_upvr (readonly)
	]]
	local var6
	if type(arg1) ~= "string" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "linkName should be 'string'")
	if typeof(arg2) ~= "Instance" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "parent should be 'Instance'")
	var6 = any_load_result1_result1_upvr
	var6 = arg2
	return var6.observeChildrenBrio(var6):Pipe({var1_result1_upvr_3.flatMap(function(arg1_2) -- Line 23
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_3 (copied, readonly)
			[2]: var1_result1_upvr_2 (copied, readonly)
			[3]: module_upvr (copied, readonly)
			[4]: arg1 (readonly)
		]]
		local any_GetValue_result1 = arg1_2:GetValue()
		if not any_GetValue_result1:IsA("ObjectValue") then
			return var1_result1_upvr_3.EMPTY
		end
		return var1_result1_upvr_2.completeOnDeath(arg1_2, module_upvr.observeValidityBrio(arg1, any_GetValue_result1))
	end)})
end
function module_upvr.observeLinkValueBrio(arg1, arg2) -- Line 34
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	local var10
	if type(arg1) ~= "string" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "linkName should be 'string'")
	if typeof(arg2) ~= "Instance" then
		var10 = false
	else
		var10 = true
	end
	assert(var10, "parent should be 'Instance'")
	var10 = any_load_result1_result1_upvr
	var10 = arg2
	return var10.observeChildrenOfNameBrio(var10, "ObjectValue", arg1):Pipe({var1_result1_upvr_2.flatMapBrio(function(arg1_3) -- Line 40
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
		]]
		return any_load_result1_result1_upvr.observePropertyBrio(arg1_3, "Value", function(arg1_4) -- Line 41
			if arg1_4 == nil then
			else
			end
			return true
		end)
	end)})
end
local any_load_result1_result1_upvr_3 = any_load_result1("Observable")
local var1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr_2 = any_load_result1("Brio")
function module_upvr.observeValidityBrio(arg1, arg2) -- Line 50
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local var18 = false
	if typeof(arg2) == "Instance" then
		var18 = arg2:IsA("ObjectValue")
	end
	assert(var18, "Bad link")
	if type(arg1) ~= "string" then
		var18 = false
	else
		var18 = true
	end
	assert(var18, "Bad linkName")
	var18 = any_load_result1_result1_upvr_3
	function var18(arg1_5) -- Line 54
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
			[4]: any_load_result1_result1_upvr_2 (copied, readonly)
		]]
		local any_new_result1_upvr = var1_result1_upvr.new()
		local function updateValidity() -- Line 57
			--[[ Upvalues[5]:
				[1]: arg2 (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: any_new_result1_upvr (readonly)
				[4]: any_load_result1_result1_upvr_2 (copied, readonly)
				[5]: arg1_5 (readonly)
			]]
			if arg2.Name ~= arg1 or not arg2.Value then
				any_new_result1_upvr._lastValid = nil
			else
				local any_new_result1_2 = any_load_result1_result1_upvr_2.new(arg2, arg2.Value)
				any_new_result1_upvr._lastValid = any_new_result1_2
				arg1_5:Fire(any_new_result1_2)
			end
		end
		any_new_result1_upvr:GiveTask(arg2:GetPropertyChangedSignal("Value"):Connect(updateValidity))
		any_new_result1_upvr:GiveTask(arg2:GetPropertyChangedSignal("Name"):Connect(updateValidity))
		if arg2.Name ~= arg1 or not arg2.Value then
			any_new_result1_upvr._lastValid = nil
			return any_new_result1_upvr
		end
		local any_new_result1 = any_load_result1_result1_upvr_2.new(arg2, arg2.Value)
		any_new_result1_upvr._lastValid = any_new_result1
		arg1_5:Fire(any_new_result1)
		return any_new_result1_upvr
	end
	return var18.new(var18)
end
return module_upvr