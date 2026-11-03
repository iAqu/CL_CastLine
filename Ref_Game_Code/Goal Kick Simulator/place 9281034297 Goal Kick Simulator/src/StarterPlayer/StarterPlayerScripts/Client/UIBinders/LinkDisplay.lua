-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:40
-- Luau version 6, Types version 3
-- Time taken: 0.001509 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local var4 = arg1:GetAttribute("UI_InfoType") or ""
	local any_new_result1 = Util_upvr.Maid.new()
	local any_GetLink_result1 = Util_upvr.Link:GetLink(arg1:GetAttribute("UI_LinkName") or "Default")
	local var7
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [30] 23. Error Block 13 start (CF ANALYSIS FAILED)
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var7 = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(any_GetLink_result1[var4]))
		return var7
	end
	if typeof(any_GetLink_result1[var4]) ~= "number" or not INLINED() then
		var7 = any_GetLink_result1[var4]
		if not var7 then
			-- KONSTANTERROR: [51] 39. Error Block 6 start (CF ANALYSIS FAILED)
			var7 = '~'
			-- KONSTANTERROR: [51] 39. Error Block 6 end (CF ANALYSIS FAILED)
		end
	end
	arg1.Text = var7
	var7 = any_new_result1:GiveTask
	var7(any_GetLink_result1.Changed:On(var4, function(arg1_2) -- Line 12
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local var9
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [8] 7. Error Block 13 start (CF ANALYSIS FAILED)
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var9 = Util_upvr.ValueConvertor:ShrinkNumber(arg1_2)
			return var9
		end
		if typeof(arg1_2) ~= "number" or not INLINED_2() then
			var9 = arg1_2
			if not var9 then
				-- KONSTANTERROR: [25] 20. Error Block 6 start (CF ANALYSIS FAILED)
				var9 = '~'
				-- KONSTANTERROR: [25] 20. Error Block 6 end (CF ANALYSIS FAILED)
			end
		end
		arg1.Text = var9
		-- KONSTANTERROR: [8] 7. Error Block 13 end (CF ANALYSIS FAILED)
	end))
	do
		return any_new_result1
	end
	-- KONSTANTERROR: [30] 23. Error Block 13 end (CF ANALYSIS FAILED)
end
return module