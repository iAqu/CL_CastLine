-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:43
-- Luau version 6, Types version 3
-- Time taken: 0.001444 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr = {}
local any_load_result1_result1_upvr = any_load_result1("Observable")
local var1_result1_upvr = any_load_result1("Maid")
function module_upvr.observeBinders(arg1) -- Line 20
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local var6
	if type(arg1) ~= "table" then
		var6 = false
	else
		var6 = true
	end
	assert(var6, "Bad binderGroup")
	var6 = any_load_result1_result1_upvr
	function var6(arg1_2) -- Line 23
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local any_new_result1 = var1_result1_upvr.new()
		any_new_result1:GiveTask(arg1.BinderAdded:Connect(function(arg1_3) -- Line 26
			--[[ Upvalues[1]:
				[1]: arg1_2 (readonly)
			]]
			arg1_2:Fire(arg1_3)
		end))
		for _, v in pairs(arg1:GetBinders()) do
			arg1_2:Fire(v)
		end
		return any_new_result1
	end
	return var6.new(var6)
end
local any_load_result1_result1_upvr_2 = any_load_result1("Rx")
local any_load_result1_result1_upvr_3 = any_load_result1("RxBinderUtils")
function module_upvr.observeAllClassesBrio(arg1) -- Line 44
	--[[ Upvalues[3]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var16
	if type(arg1) ~= "table" then
		var16 = false
	else
		var16 = true
	end
	assert(var16, "Bad binderGroup")
	var16 = module_upvr
	var16 = arg1
	return var16.observeBinders(var16):Pipe({any_load_result1_result1_upvr_2.flatMap(any_load_result1_result1_upvr_3.observeAllBrio)})
end
return module_upvr