-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:40
-- Luau version 6, Types version 3
-- Time taken: 0.002272 seconds

local random_state_upvr = Random.new()
return {
	NextValueFromDictionary = function(arg1, arg2) -- Line 5, Named "NextValueFromDictionary"
		--[[ Upvalues[1]:
			[1]: random_state_upvr (readonly)
		]]
		local tbl = {}
		for _, v in pairs(arg2) do
			tbl[#tbl + 1] = v
		end
		table.sort(tbl, function(arg1_2, arg2_2) -- Line 10
			local var16
			if (arg1_2.Chance or 1) >= (arg2_2.Chance or 1) then
				var16 = false
			else
				var16 = true
			end
			return var16
		end)
		for _, v_2 in pairs(tbl) do
			if random_state_upvr:NextNumber() <= v_2.Chance then
				return v_2
			end
		end
	end;
	NextValueFromTable = function(arg1, arg2) -- Line 21, Named "NextValueFromTable"
		--[[ Upvalues[1]:
			[1]: random_state_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var28
		if 0 >= #arg2 then
			var28 = false
		else
			var28 = true
		end
		assert(var28, "TABLE IS EMPTY!")
		local tbl_2 = {}
		var28 = pairs(arg2)
		local pairs_result1_2, pairs_result2_3, pairs_result3_2 = pairs(arg2)
		for _, v_3 in pairs_result1_2, pairs_result2_3, pairs_result3_2 do
			tbl_2[#tbl_2 + 1] = v_3
			local var33
		end
		pairs_result1_2 = var33[random_state_upvr:NextInteger(1, #var33)]
		return pairs_result1_2
	end;
	NextNumber = function(arg1, ...) -- Line 30, Named "NextNumber"
		--[[ Upvalues[1]:
			[1]: random_state_upvr (readonly)
		]]
		return random_state_upvr:NextNumber(...)
	end;
	NextInteger = function(arg1, arg2, arg3, ...) -- Line 34, Named "NextInteger"
		--[[ Upvalues[1]:
			[1]: random_state_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var34
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var34 = arg2
			return var34
		end
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var34 = arg3 - 1
			return var34
		end
		if not arg3 or not INLINED() or not arg3 or not INLINED_2() then
			var34 = 1
		end
		local var35
		local function INLINED_3() -- Internal function, doesn't exist in bytecode
			var35 = arg2 + 1
			return var35
		end
		if not var35 and (not arg2 or not INLINED_3()) then
			var35 = 1
		end
		return random_state_upvr:NextInteger(var34, var35, ...)
	end;
	NextRangeNumber = function(arg1, arg2) -- Line 38, Named "NextRangeNumber"
		--[[ Upvalues[1]:
			[1]: random_state_upvr (readonly)
		]]
		return random_state_upvr:NextNumber() * arg2 - arg2 / 2
	end;
}