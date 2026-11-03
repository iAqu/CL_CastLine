-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:49
-- Luau version 6, Types version 3
-- Time taken: 0.001507 seconds

local module = {}
local ValueManager = require(script.Parent.ValueManager)
local any_new_result1_upvr = ValueManager.new({
	Target = 0;
	Real = 0;
	Style = "Linear";
	StyleValue = 1;
	auto = false;
})
local any_new_result1_upvr_2 = ValueManager.new({
	Target = 0;
	Real = 0;
	Style = "Linear";
	StyleValue = 0.1;
	auto = false;
})
function module.GetSyncedUTC() -- Line 31
	--[[ Upvalues[1]:
		[1]: any_new_result1_upvr (readonly)
	]]
	return os.clock() + any_new_result1_upvr.GetAccurate()
end
function module.GetSlowSyncedUTC() -- Line 37
	--[[ Upvalues[1]:
		[1]: any_new_result1_upvr_2 (readonly)
	]]
	return os.clock() + any_new_result1_upvr_2.GetAccurate()
end
local RunService_upvr = game:GetService("RunService")
local Network_upvr = require(script.Parent.Network)
coroutine.wrap(function() -- Line 41
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: Network_upvr (readonly)
		[3]: any_new_result1_upvr (readonly)
		[4]: any_new_result1_upvr_2 (readonly)
	]]
	if RunService_upvr:IsServer() then
		if task.wait(1) then
			Network_upvr:FireAllClients("TimeUpdate", os.clock())
			-- KONSTANTWARNING: GOTO [5] #5
		end
	else
		Network_upvr.Events.TimeUpdate = function(arg1) -- Line 47
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr (copied, readonly)
				[2]: any_new_result1_upvr_2 (copied, readonly)
			]]
			any_new_result1_upvr.Target = arg1 - os.clock()
			if any_new_result1_upvr.Real == 0 then
				any_new_result1_upvr.Real = any_new_result1_upvr.Target
			end
			any_new_result1_upvr_2.Target = any_new_result1_upvr.Target
			if any_new_result1_upvr_2.Real == 0 then
				any_new_result1_upvr_2.Real = any_new_result1_upvr_2.Target
			end
		end
	end
end)()
return module