-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:44
-- Luau version 6, Types version 3
-- Time taken: 0.002553 seconds

local module = {}
local tbl_upvr = {
	RunningState = {
		Priority = -1;
	};
}
tbl_upvr.__index = tbl_upvr
local Maid_upvr = require(script.Parent.Maid)
function module.new() -- Line 10
	--[[ Upvalues[2]:
		[1]: Maid_upvr (readonly)
		[2]: tbl_upvr (readonly)
	]]
	local any_new_result1 = Maid_upvr.new()
	return setmetatable({
		Priorities = {};
		Maid = any_new_result1;
		Destroy = any_new_result1.Destroy;
	}, tbl_upvr)
end
local Signal_upvr = require(script.Parent.Signal)
function tbl_upvr.AddState(arg1, arg2, arg3, arg4) -- Line 19
	--[[ Upvalues[1]:
		[1]: Signal_upvr (readonly)
	]]
	local var9_upvw = tonumber(arg2) or 0
	local var10
	if var9_upvw < arg1.RunningState.Priority then return end
	if var9_upvw ~= arg1.RunningState.Priority then
		var10 = true
	end
	if arg1.Maid.CurrentState and not var10 then
		return false
	end
	local any_new_result1_upvr = Signal_upvr.new()
	local module_2 = {
		Remove = function() -- Line 30, Named "Remove"
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: var9_upvw (read and write)
				[3]: any_new_result1_upvr (readonly)
			]]
			if not arg1.Priorities[var9_upvw] then
			else
				if arg1.Priorities[var9_upvw] == arg1.RunningState then
					arg1.Maid.CurrentState = nil
					arg1.RunningState = nil
				end
				arg1.Priorities[var9_upvw] = nil
				local var17
				if var17 then
					var17 = nil
					for _, v in pairs(arg1.Priorities) do
						var17 = v
					end
					arg1:AddState(var17.Priority, true, var17.Function)
				end
				any_new_result1_upvr:Fire()
			end
		end;
		Priority = var9_upvw;
	}
	module_2.Function = arg4
	module_2.Finished = any_new_result1_upvr
	arg1.RunningState = module_2
	arg1.Priorities[var9_upvw] = module_2
	local var22_upvw
	arg1.Maid.CurrentState = function() -- Line 54
		--[[ Upvalues[1]:
			[1]: var22_upvw (read and write)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [48] 37. Error Block 10 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [48] 37. Error Block 10 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [52] 40. Error Block 11 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [52] 40. Error Block 11 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [66] 50. Error Block 16 start (CF ANALYSIS FAILED)
		if typeof(var22_upvw) == "Instance" then
			var22_upvw:Destroy()
		end
		-- KONSTANTERROR: [66] 50. Error Block 16 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [77] 58. Error Block 15 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [77] 58. Error Block 15 end (CF ANALYSIS FAILED)
	end
	var22_upvw = arg4()
	return module_2
end
function tbl_upvr.RemoveState(arg1, arg2) -- Line 77
	local var23 = arg1.Priorities[arg2]
	if var23 then
		return var23:Remove()
	end
end
return module