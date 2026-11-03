-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:47
-- Luau version 6, Types version 3
-- Time taken: 0.015104 seconds

local module_2 = {}
local HttpService_upvr = game:GetService("HttpService")
local find_upvr = table.find
local function CopyDictionary_upvr(arg1) -- Line 215, Named "CopyDictionary"
	--[[ Upvalues[1]:
		[1]: CopyDictionary_upvr (readonly)
	]]
	local var8
	if type(arg1) ~= "table" then
		var8 = false
	else
		var8 = true
	end
	assert(var8, "First argument must be a table")
	var8 = pairs(arg1)
	for i, v in pairs(arg1) do
		if type(v) == "table" then
			({})[i] = CopyDictionary_upvr(v)
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			;({})[i] = v
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
local function CopyTable_upvr(arg1) -- Line 228, Named "CopyTable"
	--[[ Upvalues[1]:
		[1]: CopyTable_upvr (readonly)
	]]
	local var16
	if type(arg1) ~= "table" then
		var16 = false
	else
		var16 = true
	end
	assert(var16, "First argument must be a table")
	var16 = #arg1
	var16 = pairs(arg1)
	for i_2, v_2 in pairs(arg1) do
		if type(v_2) == "table" then
			table.create(var16)[i_2] = CopyTable_upvr(v_2)
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.create(var16)[i_2] = v_2
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return table.create(var16)
end
local function Sync_upvr(arg1, arg2) -- Line 249, Named "Sync"
	--[[ Upvalues[2]:
		[1]: CopyTable_upvr (readonly)
		[2]: Sync_upvr (readonly)
	]]
	local var36
	if type(arg1) ~= "table" then
		var36 = false
	else
		var36 = true
	end
	assert(var36, "First argument must be a table")
	if type(arg2) ~= "table" then
		var36 = false
	else
		var36 = true
	end
	assert(var36, "Second argument must be a table")
	var36 = arg1
	local pairs_result1_4, pairs_result2_7, pairs_result3_8 = pairs(var36)
	for i_4, v_4 in pairs_result1_4, pairs_result2_7, pairs_result3_8 do
		local var40 = arg2[i_4]
		if var40 == nil then
			arg1[i_4] = nil
		elseif type(v_4) ~= type(var40) then
			if type(var40) == "table" then
				arg1[i_4] = CopyTable_upvr(var40)
			else
				arg1[i_4] = var40
			end
		elseif type(v_4) == "table" then
			Sync_upvr(v_4, var40)
		end
	end
	pairs_result2_7 = arg2
	for i_5, v_5 in pairs(pairs_result2_7) do
		if arg1[i_5] == nil then
			if type(v_5) == "table" then
				arg1[i_5] = CopyTable_upvr(v_5)
			else
				arg1[i_5] = v_5
			end
		end
	end
end
local random_state_upvr = Random.new(os.time())
local function TablePick_upvr(arg1) -- Line 466, Named "TablePick"
	--[[ Upvalues[1]:
		[1]: random_state_upvr (readonly)
	]]
	local any_NextInteger_result1_3 = random_state_upvr:NextInteger(1, #arg1)
	return arg1[any_NextInteger_result1_3], any_NextInteger_result1_3
end
local function DictionaryPick_upvr(arg1) -- Line 478, Named "DictionaryPick"
	--[[ Upvalues[1]:
		[1]: random_state_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	if not arg1 then return end
	local tbl_4 = {}
	for i_17 in pairs(arg1) do
		tbl_4[#tbl_4 + 1] = i_17
		local var153
	end
	local var154 = var153[random_state_upvr:NextInteger(1, #var153)]
	return arg1[var154], var154
end
local function Emtpy(arg1) -- Line 502
	while next(arg1) do
		arg1[next(arg1)] = nil
	end
end
function module_2.PickItemFromList(arg1, arg2, arg3) -- Line 509
	--[[ Upvalues[1]:
		[1]: TablePick_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	table.sort(arg2, function(arg1_5, arg2_5) -- Line 510
		local var184
		if (arg2_5:GetAttribute("Probability") or 1) >= (arg1_5:GetAttribute("Probability") or 1) then
			var184 = false
		else
			var184 = true
		end
		return var184
	end)
	local tbl_7 = {}
	local tbl_6 = {}
	local var190
	for _, v_14 in pairs(arg2) do
		local maximum = math.max(0, math.ceil(v_14:GetAttribute("Probability") or 1))
		if tbl_7[maximum] then
			table.insert(tbl_7[maximum], v_14)
		else
			tbl_7[maximum] = {v_14}
		end
		local tbl = {
			Value = tbl_7[maximum];
			RawProbability = maximum;
			Probability = maximum + var190;
		}
		tbl_7[maximum] = tbl.Value
		tbl_6[#tbl_6 + 1] = tbl
		var190 += maximum
	end
	table.sort(tbl_6, function(arg1_6, arg2_6) -- Line 534
		local var195
		if arg1_6.Probability >= arg2_6.Probability then
			var195 = false
		else
			var195 = true
		end
		return var195
	end)
	for _ = 1, arg3 or 1 do
		if 0 < math.random(0, var190) then
		end
	end
	for _, v_15 in pairs(tbl_6) do
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if math.random(0, var190) <= v_15.Probability then
			return TablePick_upvr(v_15.Value)
		end
	end
end
function module_2.CreateDisappearingTable(arg1) -- Line 552
	local tbl_2_upvr = {}
	local module = {}
	local tbl_5_upvr = {}
	local var202_upvw = arg1 or 1
	function module.__newindex(arg1_7, arg2, arg3) -- Line 560
		--[[ Upvalues[3]:
			[1]: tbl_2_upvr (readonly)
			[2]: tbl_5_upvr (readonly)
			[3]: var202_upvw (read and write)
		]]
		tbl_2_upvr[arg2] = arg3
		local os_clock_result1_upvr = os.clock()
		tbl_5_upvr[arg2] = os_clock_result1_upvr
		task.delay(var202_upvw, function() -- Line 564
			--[[ Upvalues[4]:
				[1]: tbl_5_upvr (copied, readonly)
				[2]: arg2 (readonly)
				[3]: os_clock_result1_upvr (readonly)
				[4]: tbl_2_upvr (copied, readonly)
			]]
			if tbl_5_upvr[arg2] == os_clock_result1_upvr then
				tbl_5_upvr[arg2] = nil
				tbl_2_upvr[arg2] = nil
			end
		end)
	end
	module.__index = tbl_2_upvr
	return setmetatable({}, module)
end
function module_2.GetTableRealSize(arg1) -- Line 488, Named "GetGictionarySize"
	local var157 = 0
	for _ in pairs(arg1) do
		var157 += 1
	end
	return var157
end
function module_2.DictionaryPickAndRemove(arg1) -- Line 496
	--[[ Upvalues[1]:
		[1]: DictionaryPick_upvr (readonly)
	]]
	local DictionaryPick_result1, DictionaryPick_result2 = DictionaryPick_upvr(arg1)
	arg1[DictionaryPick_result2] = nil
	return DictionaryPick_result1, DictionaryPick_result2
end
module_2.DictionaryPick = DictionaryPick_upvr
module_2.Empty = Emtpy
module_2.Clear = Emtpy
function module_2.PickAndRemove(arg1) -- Line 472, Named "TablePickAndRemove"
	--[[ Upvalues[1]:
		[1]: random_state_upvr (readonly)
	]]
	local any_NextInteger_result1 = random_state_upvr:NextInteger(1, #arg1)
	table.remove(arg1, any_NextInteger_result1)
	return arg1[any_NextInteger_result1]
end
module_2.Pick = TablePick_upvr
module_2.CopyDictionary = CopyDictionary_upvr
module_2.Copy = CopyTable_upvr
function module_2.CopyShallow(arg1) -- Line 242, Named "CopyTableShallow"
	local table_create_result1_3 = table.create(#arg1)
	for i_3, v_3 in pairs(arg1) do
		table_create_result1_3[i_3] = v_3
	end
	return table_create_result1_3
end
module_2.Sync = Sync_upvr
function module_2.FastRemove(arg1, arg2) -- Line 298
	local len_2 = #arg1
	arg1[arg2] = arg1[len_2]
	arg1[len_2] = nil
end
function module_2.FastRemoveFirstValue(arg1, arg2) -- Line 456
	--[[ Upvalues[1]:
		[1]: find_upvr (readonly)
	]]
	local var3_result1 = find_upvr(arg1, arg2)
	if var3_result1 then
		local len = #arg1
		arg1[var3_result1] = arg1[len]
		arg1[len] = nil
		return true, var3_result1
	end
	return false, nil
end
function module_2.Print(arg1, arg2, arg3) -- Line 363
	local Insert
	if type(arg1) ~= "table" then
		Insert = false
	else
		Insert = true
	end
	assert(Insert, "First argument must be a table")
	Insert = true
	if arg2 ~= nil then
		if type(arg2) ~= "string" then
			Insert = false
		else
			Insert = true
		end
	end
	assert(Insert, "Second argument must be a string or nil")
	local tbl_8_upvr = {}
	function Insert(arg1_2, arg2_2) -- Line 374
		--[[ Upvalues[1]:
			[1]: tbl_8_upvr (readonly)
		]]
		tbl_8_upvr[#tbl_8_upvr + 1] = " - ":rep(arg2_2)..arg1_2..'\n'
	end
	local function AlphaKeySort_upvr(arg1_3, arg2_3) -- Line 378, Named "AlphaKeySort"
		local var93
		if tostring(arg1_3.k) >= tostring(arg2_3.k) then
			var93 = false
		else
			var93 = true
		end
		return var93
	end
	local function PrintTable_upvr(arg1_4, arg2_4, arg3_2) -- Line 382, Named "PrintTable"
		--[[ Upvalues[4]:
			[1]: tbl_8_upvr (readonly)
			[2]: AlphaKeySort_upvr (readonly)
			[3]: arg3 (readonly)
			[4]: PrintTable_upvr (readonly)
		]]
		tbl_8_upvr[#tbl_8_upvr + 1] = " - ":rep(arg2_4 - 1)..arg3_2..':'..'\n'
		local tbl_3 = {}
		local tbl_9 = {}
		local var115
		for i_12, v_11 in pairs(arg1_4) do
			if type(v_11) == "table" then
				table.insert(tbl_9, {
					k = i_12;
					v = v_11;
				})
			else
				table.insert(tbl_3, {
					k = i_12;
					v = '['..typeof(v_11).."] "..tostring(v_11);
				})
			end
			local var118 = #tostring(i_12) + 1
			if var115 < var118 then
				var115 = var118
			end
		end
		table.sort(tbl_3, AlphaKeySort_upvr)
		table.sort(tbl_9, AlphaKeySort_upvr)
		for _, v_12 in ipairs(tbl_3) do
			tbl_8_upvr[#tbl_8_upvr + 1] = " - ":rep(arg2_4)..tostring(v_12.k)..':'..' ':rep(var115 - #tostring(v_12.k))..v_12.v..'\n'
		end
		if arg3 then
			for _, v_13 in ipairs(tbl_9) do
				PrintTable_upvr(v_13.v, arg2_4 + 1, tostring(v_13.k)..' ':rep(var115 - #tostring(v_13.k)).." [Table]")
			end
		else
			for _, v_16 in ipairs(tbl_9) do
				tbl_8_upvr[#tbl_8_upvr + 1] = " - ":rep(arg2_4)..tostring(v_16.k)..':'..' ':rep(var115 - #tostring(v_16.k)).."[Table]"..'\n'
			end
		end
	end
	PrintTable_upvr(arg1, 1, arg2 or "TABLE")
	print(table.concat(tbl_8_upvr, ""))
end
function module_2.Map(arg1, arg2) -- Line 305
	local var49
	if type(arg1) ~= "table" then
		var49 = false
	else
		var49 = true
	end
	assert(var49, "First argument must be a table")
	if type(arg2) ~= "function" then
		var49 = false
	else
		var49 = true
	end
	assert(var49, "Second argument must be an array")
	var49 = #arg1
	var49 = pairs(arg1)
	for i_6, v_6 in pairs(arg1) do
		table.create(var49)[i_6] = arg2(v_6, i_6, arg1)
		local var54
	end
	return var54
end
function module_2.Filter(arg1, arg2) -- Line 316
	local var61
	if type(arg1) ~= "table" then
		var61 = false
	else
		var61 = true
	end
	assert(var61, "First argument must be a table")
	if type(arg2) ~= "function" then
		var61 = false
	else
		var61 = true
	end
	assert(var61, "Second argument must be an array")
	var61 = #arg1
	local table_create_result1 = table.create(var61)
	var61 = #arg1
	if 0 < var61 then
		var61 = 0
		for i_7 = 1, #arg1 do
			local var63 = arg1[i_7]
			if arg2(var63, i_7, arg1) then
				var61 += 1
				table_create_result1[var61] = var63
			end
		end
		return table_create_result1
	end
	var61 = pairs(arg1)
	for i_8, v_7 in pairs(arg1) do
		if arg2(v_7, i_8, arg1) then
			table_create_result1[i_8] = v_7
		end
	end
	return table_create_result1
end
function module_2.Reduce(arg1, arg2, arg3) -- Line 340
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var75
	if type(arg1) ~= "table" then
		var75 = false
	else
		var75 = true
	end
	assert(var75, "First argument must be a table")
	if type(arg2) ~= "function" then
		var75 = false
	else
		var75 = true
	end
	assert(var75, "Second argument must be an array")
	var75 = true
	if arg3 ~= nil then
		if type(arg3) ~= "number" then
			var75 = false
		else
			var75 = true
		end
	end
	assert(var75, "Third argument must be a number or nil")
	var75 = pairs(arg1)
	for _, _ in pairs(arg1) do
		local var79
	end
	return var79
end
function module_2.Assign(arg1, ...) -- Line 353
	for _, v_9 in ipairs({...}) do
		for i_11, v_10 in pairs(v_9) do
			arg1[i_11] = v_10
		end
	end
	return arg1
end
module_2.IndexOf = find_upvr
function module_2.Reverse(arg1) -- Line 421
	local len_3 = #arg1
	local table_create_result1_2 = table.create(len_3)
	for i_15 = 1, len_3 do
		table_create_result1_2[i_15] = arg1[len_3 - i_15 + 1]
	end
	return table_create_result1_2
end
function module_2.Shuffle(arg1) -- Line 431
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var136
	if type(arg1) ~= "table" then
		var136 = false
	else
		var136 = true
	end
	assert(var136, "First argument must be a table")
	var136 = 2
	for i_16 = #arg1, var136, -1 do
		local any_NextInteger_result1_2 = Random.new():NextInteger(1, i_16)
		arg1[i_16] = arg1[any_NextInteger_result1_2]
		arg1[any_NextInteger_result1_2] = arg1[i_16]
		local _
	end
end
function module_2.IsEmpty(arg1) -- Line 441
	local var139
	if next(arg1) ~= nil then
		var139 = false
	else
		var139 = true
	end
	return var139
end
function module_2.EncodeJSON(arg1) -- Line 446
	--[[ Upvalues[1]:
		[1]: HttpService_upvr (readonly)
	]]
	return HttpService_upvr:JSONEncode(arg1)
end
function module_2.DecodeJSON(arg1) -- Line 451
	--[[ Upvalues[1]:
		[1]: HttpService_upvr (readonly)
	]]
	return HttpService_upvr:JSONDecode(arg1)
end
return module_2