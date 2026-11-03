-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:14
-- Luau version 6, Types version 3
-- Time taken: 0.000893 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local var1_result1_upvr_2 = any_load_result1("Promise")
local var1_result1_upvr = any_load_result1("Maid")
function module.promiseClockSynced(arg1) -- Line 19
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	if arg1:IsSynced() then
		return var1_result1_upvr_2.resolved(arg1)
	end
	assert(arg1.SyncedEvent, "Somehow master clock isn't synced")
	local any_new_result1_upvr_2 = var1_result1_upvr_2.new()
	local any_new_result1_upvr = var1_result1_upvr.new()
	any_new_result1_upvr:GiveTask(arg1.SyncedEvent:Connect(function() -- Line 29
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr_2 (readonly)
		]]
		if arg1:IsSynced() then
			any_new_result1_upvr_2:Resolve(arg1)
		end
	end))
	any_new_result1_upvr_2:Finally(function() -- Line 35
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:DoCleaning()
	end)
	return any_new_result1_upvr_2
end
return module