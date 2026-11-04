-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:33
-- Luau version 6, Types version 3
-- Time taken: 0.001517 seconds

local module_upvr = {}
function module_upvr.deepCopy(arg1) -- Line 3
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg1 then
		for i, v in pairs(arg1) do
			if type(v) == "table" then
				v = module_upvr.deepCopy(v)
			end
			;({})[i] = v
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function module_upvr.IsEqual(arg1, arg2) -- Line 16
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var23
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var23 = type(arg2)
		return var23 ~= "table"
	end
	if var23 ~= "table" or INLINED() then
		if arg1 ~= arg2 then
			var23 = false
		else
			var23 = true
		end
		return var23
	end
	var23 = pairs(arg1)
	local pairs_result1_2, pairs_result2_3, pairs_result3_2 = pairs(arg1)
	for i_2, v_2 in pairs_result1_2, pairs_result2_3, pairs_result3_2 do
		if not module_upvr.IsEqual(arg2[i_2], v_2) then
			return false
		end
	end
	pairs_result1_2 = pairs(arg2)
	local pairs_result1, pairs_result2_2, pairs_result3 = pairs(arg2)
	for i_3, v_3 in pairs_result1, pairs_result2_2, pairs_result3 do
		if not module_upvr.IsEqual(arg1[i_3], v_3) then
			return false
		end
	end
	pairs_result1 = true
	return pairs_result1
end
return module_upvr