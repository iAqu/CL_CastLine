-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:10
-- Luau version 6, Types version 3
-- Time taken: 0.001931 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local var1_result1_upvr_2 = any_load_result1("Promise")
local var1_result1_upvr = any_load_result1("Maid")
function module.promiseRootPart(arg1) -- Line 27
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	if arg1.RootPart then
		return var1_result1_upvr_2.resolved(arg1.RootPart)
	end
	local any_new_result1_upvr_2 = var1_result1_upvr.new()
	local any_new_result1_upvr = var1_result1_upvr_2.new()
	task.spawn(function() -- Line 37
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		while not arg1.RootPart and any_new_result1_upvr:IsPending() do
			task.wait(0.05)
		end
		if arg1.RootPart then
			any_new_result1_upvr:Resolve(arg1.RootPart)
		else
			any_new_result1_upvr:Reject()
		end
	end)
	task.delay(60, function() -- Line 48
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		if any_new_result1_upvr:IsPending() then
			warn("[RootPartUtils.promiseRootPart] - TImed out on root part", debug.traceback())
			any_new_result1_upvr:Reject("Timed out")
		end
	end)
	any_new_result1_upvr_2:GiveTask(arg1.AncestryChanged:Connect(function() -- Line 55
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		if not arg1:IsDescendantOf(game) then
			any_new_result1_upvr:Reject("Humanoid removed from game")
		end
	end))
	any_new_result1_upvr_2:GiveTask(arg1.Died:Connect(function() -- Line 61
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr:Reject("Humanoid died")
	end))
	any_new_result1_upvr:Finally(function() -- Line 65
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2:DoCleaning()
	end)
	return any_new_result1_upvr
end
return module