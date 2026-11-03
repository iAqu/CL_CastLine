-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:49
-- Luau version 6, Types version 3
-- Time taken: 0.000945 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local var1_result1_upvr_2 = any_load_result1("Promise")
local var1_result1_upvr = any_load_result1("Maid")
function module.promiseCharacter(arg1) -- Line 19
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local var5_upvr
	if typeof(arg1) ~= "Instance" then
		var5_upvr = false
	else
		var5_upvr = true
	end
	assert(var5_upvr, "Bad player")
	var5_upvr = var1_result1_upvr_2
	local any_new_result1_upvr = var5_upvr.new()
	var5_upvr = arg1.Character
	if var5_upvr then
		var5_upvr = any_new_result1_upvr:Resolve
		var5_upvr(arg1.Character)
		return any_new_result1_upvr
	end
	var5_upvr = var1_result1_upvr.new()
	var5_upvr:GiveTask(arg1.CharacterAdded:Connect(function(arg1_2) -- Line 31
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Resolve(arg1_2)
	end))
	any_new_result1_upvr:Finally(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: var5_upvr (readonly)
		]]
		var5_upvr:DoCleaning()
	end)
	return any_new_result1_upvr
end
return module