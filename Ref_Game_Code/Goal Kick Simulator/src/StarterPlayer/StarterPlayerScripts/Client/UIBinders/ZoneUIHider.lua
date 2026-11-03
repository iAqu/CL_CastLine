-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:30
-- Luau version 6, Types version 3
-- Time taken: 0.001337 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 4
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	any_new_result1_upvr.Active = true
	task.spawn(function() -- Line 7
		--[[ Upvalues[3]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 39 start (CF ANALYSIS FAILED)
		repeat
			task.wait()
		until Util_upvr.ClientZone and not any_new_result1_upvr.Active
		if not any_new_result1_upvr.Active then return end
		local tbl_upvr = {}
		local function _(arg1_2) -- Line 12, Named "UpdateZone"
			--[[ Upvalues[2]:
				[1]: tbl_upvr (readonly)
				[2]: arg1 (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			local pairs_result1_2, pairs_result2, pairs_result3 = pairs(tbl_upvr)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [10] 9. Error Block 4 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [10] 9. Error Block 4 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [6] 6. Error Block 2 start (CF ANALYSIS FAILED)
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [10.6]
			-- KONSTANTERROR: [6] 6. Error Block 2 end (CF ANALYSIS FAILED)
		end
		local function _(arg1_3, arg2) -- Line 20
			--[[ Upvalues[3]:
				[1]: tbl_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [33] 25. Error Block 8 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [33] 25. Error Block 8 end (CF ANALYSIS FAILED)
		end
		local pairs_result1, pairs_result2_2, pairs_result3_2 = pairs(arg1:GetAttributes())
		-- KONSTANTERROR: [0] 1. Error Block 39 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [66] 51. Error Block 16 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [66] 51. Error Block 16 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [34] 28. Error Block 9 start (CF ANALYSIS FAILED)
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [66.8]
		-- KONSTANTERROR: [34] 28. Error Block 9 end (CF ANALYSIS FAILED)
	end)
	return any_new_result1_upvr
end
return module