-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:40
-- Luau version 6, Types version 3
-- Time taken: 0.039511 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("Maid")
local any_load_result1_result1_upvr_3 = any_load_result1("Observable")
local any_load_result1_result1_upvr_2 = any_load_result1("Promise")
local any_named_result1_upvw = any_load_result1("Symbol").named("unsetValue")
local module_upvr = {
	EMPTY = any_load_result1_result1_upvr_3.new(function(arg1) -- Line 40
		arg1:Complete()
	end);
	NEVER = any_load_result1_result1_upvr_3.new(function(arg1) -- Line 43
	end);
	pipe = function(arg1) -- Line 55, Named "pipe"
		local var13
		if type(arg1) ~= "table" then
			var13 = false
		else
			var13 = true
		end
		assert(var13, "Bad transformers")
		var13 = arg1
		for i, v in pairs(var13) do
			if type(v) ~= "function" then
				error("[Rx.pipe] Bad pipe value of type %q at index %q, expected function":format(type(v), tostring(i)))
			end
		end
		return function(arg1_2) -- Line 64
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			assert(arg1_2, "Bad source")
			for i_2, v_2 in pairs(arg1) do
				local v_2_result1 = v_2(arg1_2)
				local var26
				if type(v_2_result1) ~= "table" or v_2_result1.ClassName ~= "Observable" then
					local function INLINED() -- Internal function, doesn't exist in bytecode
						var26 = v_2_result1.ClassName
						return var26
					end
					if type(v_2_result1) ~= "table" or not INLINED() then
						var26 = ""
					end
					error("[Rx.pipe] - Failed to transform %q in pipe, made %q (%s)":format(tostring(i_2), tostring(v_2_result1), tostring(var26)))
				end
			end
			return v_2_result1
		end
	end;
	of = function(...) -- Line 93, Named "of"
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr_3 (readonly)
		]]
		local packed_6_upvr = table.pack(...)
		return any_load_result1_result1_upvr_3.new(function(arg1) -- Line 96
			--[[ Upvalues[1]:
				[1]: packed_6_upvr (readonly)
			]]
			for i_3 = 1, packed_6_upvr.n do
				arg1:Fire(packed_6_upvr[i_3])
			end
			arg1:Complete()
		end)
	end;
	failed = function(...) -- Line 111, Named "failed"
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr_3 (readonly)
		]]
		local packed_2_upvr = table.pack(...)
		return any_load_result1_result1_upvr_3.new(function(arg1) -- Line 114
			--[[ Upvalues[1]:
				[1]: packed_2_upvr (readonly)
			]]
			arg1:Fail(table.unpack(packed_2_upvr, 1, packed_2_upvr.n))
		end)
	end;
}
function module_upvr.from(arg1) -- Line 126
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: module_upvr (readonly)
	]]
	if any_load_result1_result1_upvr_2.isPromise(arg1) then
		return module_upvr.fromPromise(arg1)
	end
	if type(arg1) == "table" then
		return module_upvr.of(unpack(arg1))
	end
	error("[Rx.from] - cannot convert")
end
local var1_result1_upvr_3 = any_load_result1("CancelToken")
function module_upvr.toPromise(arg1, arg2) -- Line 143
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_new_result1_2_upvr = any_load_result1_result1_upvr.new()
	local any_new_result1_3_upvr = var1_result1_upvr_3.new(function(arg1_3) -- Line 146
		--[[ Upvalues[2]:
			[1]: any_new_result1_2_upvr (readonly)
			[2]: arg2 (readonly)
		]]
		any_new_result1_2_upvr:GiveTask(arg1_3)
		if arg2 then
			if arg2:IsCancelled() then
				arg1_3()
				return
			end
			any_new_result1_2_upvr:GiveTask(arg2.Cancelled:Connect(arg1_3))
		end
	end)
	local any_new_result1_23 = any_load_result1_result1_upvr_2.new(function(arg1_4, arg2_2) -- Line 157
		--[[ Upvalues[3]:
			[1]: any_new_result1_3_upvr (readonly)
			[2]: any_new_result1_2_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		if any_new_result1_3_upvr:IsCancelled() then
			arg2_2()
		else
			any_new_result1_2_upvr:GiveTask(any_new_result1_3_upvr.Cancelled:Connect(function() -- Line 163
				--[[ Upvalues[1]:
					[1]: arg2_2 (readonly)
				]]
				arg2_2()
			end))
			any_new_result1_2_upvr:GiveTask(arg1:Subscribe(arg1_4, arg2_2, arg2_2))
		end
	end)
	any_new_result1_23:Finally(function() -- Line 170
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr:DoCleaning()
	end)
	return any_new_result1_23
end
function module_upvr.merge(arg1) -- Line 183
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local var44
	if type(arg1) ~= "table" then
		var44 = false
	else
		var44 = true
	end
	assert(var44, "Bad observables")
	var44 = arg1
	local pairs_result1_10, pairs_result2_5, pairs_result3_4 = pairs(var44)
	for _, v_3 in pairs_result1_10, pairs_result2_5, pairs_result3_4 do
		assert(any_load_result1_result1_upvr_3.isObservable(v_3), "Not an observable")
	end
	pairs_result2_5 = any_load_result1_result1_upvr_3
	function pairs_result2_5(arg1_5) -- Line 190
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local any_new_result1 = any_load_result1_result1_upvr.new()
		for _, v_4 in pairs(arg1) do
			any_new_result1:GiveTask(v_4:Subscribe(arg1_5:GetFireFailComplete()))
		end
		return any_new_result1
	end
	return pairs_result2_5.new(pairs_result2_5)
end
function module_upvr.fromSignal(arg1) -- Line 208
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return any_load_result1_result1_upvr_3.new(function(arg1_6) -- Line 209
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:Connect(function(...) -- Line 211
			--[[ Upvalues[1]:
				[1]: arg1_6 (readonly)
			]]
			arg1_6:Fire(...)
		end)
	end)
end
function module_upvr.fromPromise(arg1) -- Line 224
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
	]]
	assert(any_load_result1_result1_upvr_2.isPromise(arg1))
	return any_load_result1_result1_upvr_3.new(function(arg1_7) -- Line 227
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		if arg1:IsFulfilled() then
			arg1_7:Fire(arg1:Wait())
			arg1_7:Complete()
			return nil
		end
		local any_new_result1_15 = any_load_result1_result1_upvr.new()
		local var61_upvw = true
		any_new_result1_15:GiveTask(function() -- Line 237
			--[[ Upvalues[1]:
				[1]: var61_upvw (read and write)
			]]
			var61_upvw = false
		end)
		arg1:Then(function(...) -- Line 242
			--[[ Upvalues[2]:
				[1]: var61_upvw (read and write)
				[2]: arg1_7 (readonly)
			]]
			if var61_upvw then
				arg1_7:Fire(...)
				arg1_7:Complete()
			end
		end, function(...) -- Line 248
			--[[ Upvalues[2]:
				[1]: var61_upvw (read and write)
				[2]: arg1_7 (readonly)
			]]
			if var61_upvw then
				arg1_7:Fail(...)
				arg1_7:Complete()
			end
		end)
		return any_new_result1_15
	end)
end
function module_upvr.tap(arg1, arg2, arg3) -- Line 270
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var65 = true
	if type(arg1) ~= "function" then
		if arg1 ~= nil then
			var65 = false
		else
			var65 = true
		end
	end
	assert(var65, "Bad onFire")
	var65 = true
	if type(arg2) ~= "function" then
		if arg2 ~= nil then
			var65 = false
		else
			var65 = true
		end
	end
	assert(var65, "Bad onError")
	var65 = true
	if type(arg3) ~= "function" then
		if arg3 ~= nil then
			var65 = false
		else
			var65 = true
		end
	end
	assert(var65, "Bad onComplete")
	return function(arg1_8) -- Line 275
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_8), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_9) -- Line 278
			--[[ Upvalues[4]:
				[1]: arg1_8 (readonly)
				[2]: arg1 (copied, readonly)
				[3]: arg2 (copied, readonly)
				[4]: arg3 (copied, readonly)
			]]
			return arg1_8:Subscribe(function(...) -- Line 280
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: arg1_9 (readonly)
				]]
				if arg1 then
					arg1(...)
				end
				if arg1_9:IsPending() then
					arg1_9:Fire(...)
				end
			end, function(...) -- Line 288
				--[[ Upvalues[2]:
					[1]: arg2 (copied, readonly)
					[2]: arg1_9 (readonly)
				]]
				if arg2 then
					arg2(...)
				end
				arg1_9:Error(...)
			end, function(...) -- Line 294
				--[[ Upvalues[2]:
					[1]: arg3 (copied, readonly)
					[2]: arg1_9 (readonly)
				]]
				if arg3 then
					arg3(...)
				end
				arg1_9:Complete(...)
			end)
		end)
	end
end
function module_upvr.start(arg1) -- Line 312
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return function(arg1_10) -- Line 313
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_10), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_11) -- Line 316
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_10 (readonly)
			]]
			arg1_11:Fire(arg1())
			return arg1_10:Subscribe(arg1_11:GetFireFailComplete())
		end)
	end
end
function module_upvr.share() -- Line 332
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_named_result1_upvw (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return function(arg1) -- Line 333
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: any_named_result1_upvw (copied, readonly)
			[3]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		local any_new_result1_10_upvr = any_load_result1_result1_upvr.new()
		local tbl_2_upvr = {}
		local var76_upvw = any_named_result1_upvw
		local var77_upvw = any_named_result1_upvw
		local function connectToSourceIfNeeded() -- Line 340
			--[[ Upvalues[6]:
				[1]: any_new_result1_10_upvr (readonly)
				[2]: var76_upvw (read and write)
				[3]: any_named_result1_upvw (copied, readonly)
				[4]: var77_upvw (read and write)
				[5]: arg1 (readonly)
				[6]: tbl_2_upvr (readonly)
			]]
			if not any_new_result1_10_upvr._currentSub then
				var76_upvw = any_named_result1_upvw
				var77_upvw = any_named_result1_upvw
				any_new_result1_10_upvr._currentSub = arg1:Subscribe(function(...) -- Line 345
					--[[ Upvalues[1]:
						[1]: tbl_2_upvr (copied, readonly)
					]]
					for _, v_5 in pairs(tbl_2_upvr) do
						v_5:Fire(...)
					end
				end, function(...) -- Line 349
					--[[ Upvalues[2]:
						[1]: var76_upvw (copied, read and write)
						[2]: tbl_2_upvr (copied, readonly)
					]]
					var76_upvw = table.pack(...)
					for _, v_6 in pairs(tbl_2_upvr) do
						v_6:Fail(...)
					end
				end, function(...) -- Line 354
					--[[ Upvalues[2]:
						[1]: var77_upvw (copied, read and write)
						[2]: tbl_2_upvr (copied, readonly)
					]]
					var77_upvw = table.pack(...)
					for _, v_7 in pairs(tbl_2_upvr) do
						v_7:Complete(...)
					end
				end)
			end
		end
		local function disconnectFromSource() -- Line 363
			--[[ Upvalues[4]:
				[1]: any_new_result1_10_upvr (readonly)
				[2]: var76_upvw (read and write)
				[3]: any_named_result1_upvw (copied, readonly)
				[4]: var77_upvw (read and write)
			]]
			any_new_result1_10_upvr._currentSub = nil
			var76_upvw = any_named_result1_upvw
			var77_upvw = any_named_result1_upvw
		end
		assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_12) -- Line 372
			--[[ Upvalues[6]:
				[1]: var76_upvw (read and write)
				[2]: any_named_result1_upvw (copied, readonly)
				[3]: var77_upvw (read and write)
				[4]: tbl_2_upvr (readonly)
				[5]: connectToSourceIfNeeded (readonly)
				[6]: any_new_result1_10_upvr (readonly)
			]]
			if var76_upvw ~= any_named_result1_upvw then
				arg1_12:Fail(table.unpack(var76_upvw, 1, var76_upvw.n))
				return
			end
			if var77_upvw ~= any_named_result1_upvw then
				arg1_12:Fail(table.unpack(var77_upvw, 1, var77_upvw.n))
				return
			end
			table.insert(tbl_2_upvr, arg1_12)
			connectToSourceIfNeeded()
			return function() -- Line 386
				--[[ Upvalues[6]:
					[1]: tbl_2_upvr (copied, readonly)
					[2]: arg1_12 (readonly)
					[3]: any_new_result1_10_upvr (copied, readonly)
					[4]: var76_upvw (copied, read and write)
					[5]: any_named_result1_upvw (copied, readonly)
					[6]: var77_upvw (copied, read and write)
				]]
				local table_find_result1_3 = table.find(tbl_2_upvr, arg1_12)
				if table_find_result1_3 then
					table.remove(tbl_2_upvr, table_find_result1_3)
					if #tbl_2_upvr == 0 then
						any_new_result1_10_upvr._currentSub = nil
						var76_upvw = any_named_result1_upvw
						var77_upvw = any_named_result1_upvw
					end
				end
			end
		end)
	end
end
function module_upvr.shareReplay(arg1, arg2) -- Line 407
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: any_named_result1_upvw (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var100 = true
	if type(arg1) ~= "number" then
		if arg1 ~= nil then
			var100 = false
		else
			var100 = true
		end
	end
	assert(var100, "Bad bufferSize")
	var100 = true
	if type(arg2) ~= "number" then
		if arg2 ~= nil then
			var100 = false
		else
			var100 = true
		end
	end
	assert(var100, "Bad windowTimeSeconds")
	local var102_upvw = arg2 or math.huge
	local var103_upvw = arg1 or math.huge
	return function(arg1_13) -- Line 414
		--[[ Upvalues[5]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: any_named_result1_upvw (copied, readonly)
			[3]: var102_upvw (read and write)
			[4]: var103_upvw (read and write)
			[5]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		local any_new_result1_9_upvr = any_load_result1_result1_upvr.new()
		local tbl_4_upvr = {}
		local tbl_6_upvw = {}
		local var107_upvw = any_named_result1_upvw
		local var108_upvw = any_named_result1_upvw
		local function getEventsCopy_upvr() -- Line 422, Named "getEventsCopy"
			--[[ Upvalues[2]:
				[1]: tbl_6_upvw (read and write)
				[2]: var102_upvw (copied, read and write)
			]]
			for _, v_8 in pairs(tbl_6_upvw) do
				if os.clock() - v_8.timestamp <= var102_upvw then
					table.insert({}, v_8)
				end
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			return {}
		end
		local function connectToSourceIfNeeded_upvr() -- Line 435, Named "connectToSourceIfNeeded"
			--[[ Upvalues[8]:
				[1]: any_new_result1_9_upvr (readonly)
				[2]: tbl_6_upvw (read and write)
				[3]: var107_upvw (read and write)
				[4]: any_named_result1_upvw (copied, readonly)
				[5]: var108_upvw (read and write)
				[6]: arg1_13 (readonly)
				[7]: var103_upvw (copied, read and write)
				[8]: tbl_4_upvr (readonly)
			]]
			if not any_new_result1_9_upvr._currentSub then
				tbl_6_upvw = {}
				var107_upvw = any_named_result1_upvw
				var108_upvw = any_named_result1_upvw
				any_new_result1_9_upvr._currentSub = arg1_13:Subscribe(function(...) -- Line 441
					--[[ Upvalues[3]:
						[1]: tbl_6_upvw (copied, read and write)
						[2]: var103_upvw (copied, read and write)
						[3]: tbl_4_upvr (copied, readonly)
					]]
					if var103_upvw < #tbl_6_upvw + 1 then
						table.remove(tbl_6_upvw, 1)
					end
					local packed_4 = table.pack(...)
					packed_4.timestamp = os.clock()
					table.insert(tbl_6_upvw, packed_4)
					for _, v_9 in pairs(tbl_4_upvr) do
						v_9:Fire(...)
					end
				end, function(...) -- Line 456
					--[[ Upvalues[2]:
						[1]: var107_upvw (copied, read and write)
						[2]: tbl_4_upvr (copied, readonly)
					]]
					var107_upvw = table.pack(...)
					for _, v_10 in pairs(tbl_4_upvr) do
						v_10:Fail(...)
					end
				end, function(...) -- Line 461
					--[[ Upvalues[2]:
						[1]: var108_upvw (copied, read and write)
						[2]: tbl_4_upvr (copied, readonly)
					]]
					var108_upvw = table.pack(...)
					for _, v_11 in pairs(tbl_4_upvr) do
						v_11:Complete(...)
					end
				end)
			end
		end
		local function _() -- Line 470, Named "disconnectFromSource"
			--[[ Upvalues[5]:
				[1]: any_new_result1_9_upvr (readonly)
				[2]: tbl_6_upvw (read and write)
				[3]: var107_upvw (read and write)
				[4]: any_named_result1_upvw (copied, readonly)
				[5]: var108_upvw (read and write)
			]]
			any_new_result1_9_upvr._currentSub = nil
			tbl_6_upvw = {}
			var107_upvw = any_named_result1_upvw
			var108_upvw = any_named_result1_upvw
		end
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_13), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_14) -- Line 480
			--[[ Upvalues[8]:
				[1]: var107_upvw (read and write)
				[2]: any_named_result1_upvw (copied, readonly)
				[3]: var108_upvw (read and write)
				[4]: tbl_4_upvr (readonly)
				[5]: getEventsCopy_upvr (readonly)
				[6]: connectToSourceIfNeeded_upvr (readonly)
				[7]: any_new_result1_9_upvr (readonly)
				[8]: tbl_6_upvw (read and write)
			]]
			if var107_upvw ~= any_named_result1_upvw then
				arg1_14:Fail(table.unpack(var107_upvw, 1, var107_upvw.n))
				return
			end
			if var108_upvw ~= any_named_result1_upvw then
				arg1_14:Fail(table.unpack(var108_upvw, 1, var108_upvw.n))
				return
			end
			table.insert(tbl_4_upvr, arg1_14)
			for _, v_12 in pairs(getEventsCopy_upvr()) do
				arg1_14:Fire(table.unpack(v_12, 1, v_12.n))
			end
			connectToSourceIfNeeded_upvr()
			return function() -- Line 500
				--[[ Upvalues[7]:
					[1]: tbl_4_upvr (copied, readonly)
					[2]: arg1_14 (readonly)
					[3]: any_new_result1_9_upvr (copied, readonly)
					[4]: tbl_6_upvw (copied, read and write)
					[5]: var107_upvw (copied, read and write)
					[6]: any_named_result1_upvw (copied, readonly)
					[7]: var108_upvw (copied, read and write)
				]]
				local table_find_result1 = table.find(tbl_4_upvr, arg1_14)
				if table_find_result1 then
					table.remove(tbl_4_upvr, table_find_result1)
					if #tbl_4_upvr == 0 then
						any_new_result1_9_upvr._currentSub = nil
						tbl_6_upvw = {}
						var107_upvw = any_named_result1_upvw
						var108_upvw = any_named_result1_upvw
					end
				end
			end
		end)
	end
end
function module_upvr.cache() -- Line 519
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.shareReplay(1)
end
function module_upvr.startFrom(arg1) -- Line 529
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var141
	if type(arg1) ~= "function" then
		var141 = false
	else
		var141 = true
	end
	assert(var141, "Bad callback")
	return function(arg1_15) -- Line 531
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_15), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_16) -- Line 534
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_15 (readonly)
			]]
			for _, v_13 in pairs(arg1()) do
				arg1_16:Fire(v_13)
			end
			return arg1_15:Subscribe(arg1_16:GetFireFailComplete())
		end)
	end
end
function module_upvr.startWith(arg1) -- Line 551
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var149
	if type(arg1) ~= "table" then
		var149 = false
	else
		var149 = true
	end
	assert(var149, "Bad values")
	return function(arg1_17) -- Line 554
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_17), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_18) -- Line 557
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_17 (readonly)
			]]
			for _, v_14 in pairs(arg1) do
				arg1_18:Fire(v_14)
			end
			return arg1_17:Subscribe(arg1_18:GetFireFailComplete())
		end)
	end
end
function module_upvr.defaultsTo(arg1) -- Line 579
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return function(arg1_19) -- Line 580
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_19), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_20) -- Line 583
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_19 (readonly)
				[3]: arg1 (copied, readonly)
			]]
			local any_new_result1_20 = any_load_result1_result1_upvr.new()
			local var160_upvw = false
			any_new_result1_20:GiveTask(arg1_19:Subscribe(function(...) -- Line 589
				--[[ Upvalues[2]:
					[1]: var160_upvw (read and write)
					[2]: arg1_20 (readonly)
				]]
				var160_upvw = true
				arg1_20:Fire(...)
			end, arg1_20:GetFailComplete()))
			if not var160_upvw then
				arg1_20:Fire(arg1)
			end
			return any_new_result1_20
		end)
	end
end
module_upvr.defaultsToNil = module_upvr.defaultsTo(nil)
function module_upvr.endWith(arg1) -- Line 629
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return function(arg1_21) -- Line 630
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_21), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_22) -- Line 633
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_21 (readonly)
				[3]: arg1 (copied, readonly)
			]]
			local any_new_result1_6 = any_load_result1_result1_upvr.new()
			any_new_result1_6:GiveTask(arg1_21:Subscribe(function(...) -- Line 637
				--[[ Upvalues[1]:
					[1]: arg1_22 (readonly)
				]]
				arg1_22:Fire(...)
			end, function(...) -- Line 640
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: arg1_22 (readonly)
				]]
				for _, v_15 in pairs(arg1) do
					arg1_22:Fire(v_15)
				end
				arg1_22:Fail(...)
			end), function() -- Line 646
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: arg1_22 (readonly)
				]]
				for _, v_16 in pairs(arg1) do
					arg1_22:Fire(v_16)
				end
				arg1_22:Complete()
			end)
			return any_new_result1_6
		end)
	end
end
function module_upvr.where(arg1) -- Line 673
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var178
	if type(arg1) ~= "function" then
		var178 = false
	else
		var178 = true
	end
	assert(var178, "Bad predicate callback")
	return function(arg1_23) -- Line 676
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_23), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_24) -- Line 679
			--[[ Upvalues[2]:
				[1]: arg1_23 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			return arg1_23:Subscribe(function(...) -- Line 681
				--[[ Upvalues[2]:
					[1]: arg1 (copied, readonly)
					[2]: arg1_24 (readonly)
				]]
				if arg1(...) then
					arg1_24:Fire(...)
				end
			end, arg1_24:GetFailComplete())
		end)
	end
end
function module_upvr.distinct() -- Line 704
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_named_result1_upvw (readonly)
	]]
	return function(arg1) -- Line 705
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_named_result1_upvw (copied, readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_25) -- Line 708
			--[[ Upvalues[2]:
				[1]: any_named_result1_upvw (copied, readonly)
				[2]: arg1 (readonly)
			]]
			return arg1:Subscribe(function(arg1_26) -- Line 712
				--[[ Upvalues[2]:
					[1]: any_named_result1_upvw (read and write)
					[2]: arg1_25 (readonly)
				]]
				if any_named_result1_upvw == arg1_26 then
				else
					any_named_result1_upvw = arg1_26
					arg1_25:Fire(any_named_result1_upvw)
				end
			end, arg1_25:GetFailComplete())
		end)
	end
end
function module_upvr.mapTo(...) -- Line 732
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local packed_5_upvr = table.pack(...)
	return function(arg1) -- Line 734
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: packed_5_upvr (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_27) -- Line 737
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: packed_5_upvr (copied, readonly)
			]]
			return arg1:Subscribe(function() -- Line 738
				--[[ Upvalues[2]:
					[1]: arg1_27 (readonly)
					[2]: packed_5_upvr (copied, readonly)
				]]
				arg1_27:Fire(table.unpack(packed_5_upvr, 1, packed_5_upvr.n))
			end, arg1_27:GetFailComplete())
		end)
	end
end
function module_upvr.map(arg1) -- Line 761
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var189
	if type(arg1) ~= "function" then
		var189 = false
	else
		var189 = true
	end
	assert(var189, "Bad project callback")
	return function(arg1_28) -- Line 764
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_28), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_29) -- Line 767
			--[[ Upvalues[2]:
				[1]: arg1_28 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			return arg1_28:Subscribe(function(...) -- Line 768
				--[[ Upvalues[2]:
					[1]: arg1_29 (readonly)
					[2]: arg1 (copied, readonly)
				]]
				arg1_29:Fire(arg1(...))
			end, arg1_29:GetFailComplete())
		end)
	end
end
function module_upvr.mergeAll() -- Line 792
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return function(arg1) -- Line 793
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_30) -- Line 796
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: any_load_result1_result1_upvr_3 (copied, readonly)
			]]
			local any_new_result1_25_upvr = any_load_result1_result1_upvr.new()
			local var196_upvw = 0
			local var197_upvw = false
			any_new_result1_25_upvr:GiveTask(arg1:Subscribe(function(arg1_31) -- Line 803
				--[[ Upvalues[6]:
					[1]: any_load_result1_result1_upvr_3 (copied, readonly)
					[2]: var196_upvw (read and write)
					[3]: any_load_result1_result1_upvr (copied, readonly)
					[4]: arg1_30 (readonly)
					[5]: var197_upvw (read and write)
					[6]: any_new_result1_25_upvr (readonly)
				]]
				assert(any_load_result1_result1_upvr_3.isObservable(arg1_31), "Not an observable")
				var196_upvw += 1
				local any_new_result1_21_upvr = any_load_result1_result1_upvr.new()
				any_new_result1_21_upvr:GiveTask(arg1_31:Subscribe(function(...) -- Line 811
					--[[ Upvalues[1]:
						[1]: arg1_30 (copied, readonly)
					]]
					arg1_30:Fire(...)
				end, function(...) -- Line 815
					--[[ Upvalues[1]:
						[1]: arg1_30 (copied, readonly)
					]]
					arg1_30:Fail(...)
				end, function() -- Line 819
					--[[ Upvalues[5]:
						[1]: any_new_result1_21_upvr (readonly)
						[2]: var196_upvw (copied, read and write)
						[3]: var197_upvw (copied, read and write)
						[4]: arg1_30 (copied, readonly)
						[5]: any_new_result1_25_upvr (copied, readonly)
					]]
					any_new_result1_21_upvr:DoCleaning()
					var196_upvw -= 1
					if var196_upvw == 0 and var197_upvw then
						arg1_30:Complete()
						any_new_result1_25_upvr:DoCleaning()
					end
				end))
				local any_GiveTask_result1_upvr_2 = any_new_result1_25_upvr:GiveTask(any_new_result1_21_upvr)
				any_new_result1_21_upvr:GiveTask(function() -- Line 831
					--[[ Upvalues[2]:
						[1]: any_new_result1_25_upvr (copied, readonly)
						[2]: any_GiveTask_result1_upvr_2 (readonly)
					]]
					any_new_result1_25_upvr[any_GiveTask_result1_upvr_2] = nil
				end)
			end, function(...) -- Line 835
				--[[ Upvalues[2]:
					[1]: arg1_30 (readonly)
					[2]: any_new_result1_25_upvr (readonly)
				]]
				arg1_30:Fail(...)
				any_new_result1_25_upvr:DoCleaning()
			end, function() -- Line 839
				--[[ Upvalues[4]:
					[1]: var197_upvw (read and write)
					[2]: var196_upvw (read and write)
					[3]: arg1_30 (readonly)
					[4]: any_new_result1_25_upvr (readonly)
				]]
				var197_upvw = true
				if var196_upvw == 0 then
					arg1_30:Complete()
					any_new_result1_25_upvr:DoCleaning()
				end
			end))
			return any_new_result1_25_upvr
		end)
	end
end
function module_upvr.switchAll() -- Line 863
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return function(arg1) -- Line 864
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_32) -- Line 867
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: any_load_result1_result1_upvr_3 (copied, readonly)
			]]
			local any_new_result1_22_upvr = any_load_result1_result1_upvr.new()
			local var210_upvw = false
			local var211_upvw = false
			any_new_result1_22_upvr:GiveTask(function() -- Line 873
				--[[ Upvalues[1]:
					[1]: any_new_result1_22_upvr (readonly)
				]]
				any_new_result1_22_upvr._innerSub = nil
				any_new_result1_22_upvr._outerSuber = nil
			end)
			local var214_upvw
			any_new_result1_22_upvr._outerSuber = arg1:Subscribe(function(arg1_33) -- Line 882
				--[[ Upvalues[6]:
					[1]: any_load_result1_result1_upvr_3 (copied, readonly)
					[2]: var211_upvw (read and write)
					[3]: var214_upvw (read and write)
					[4]: any_new_result1_22_upvr (readonly)
					[5]: arg1_32 (readonly)
					[6]: var210_upvw (read and write)
				]]
				assert(any_load_result1_result1_upvr_3.isObservable(arg1_33), "Bad observable")
				var211_upvw = false
				var214_upvw = arg1_33
				any_new_result1_22_upvr._innerSub = nil
				any_new_result1_22_upvr._innerSub = arg1_33:Subscribe(function(...) -- Line 890
					--[[ Upvalues[1]:
						[1]: arg1_32 (copied, readonly)
					]]
					arg1_32:Fire(...)
				end, function(...) -- Line 893
					--[[ Upvalues[3]:
						[1]: var214_upvw (copied, read and write)
						[2]: arg1_33 (readonly)
						[3]: arg1_32 (copied, readonly)
					]]
					if var214_upvw == arg1_33 then
						arg1_32:Fail(...)
					end
				end, function() -- Line 898
					--[[ Upvalues[6]:
						[1]: var214_upvw (copied, read and write)
						[2]: arg1_33 (readonly)
						[3]: var211_upvw (copied, read and write)
						[4]: var210_upvw (copied, read and write)
						[5]: arg1_32 (copied, readonly)
						[6]: any_new_result1_22_upvr (copied, readonly)
					]]
					if var214_upvw == arg1_33 then
						var211_upvw = true
						if var211_upvw and var210_upvw then
							arg1_32:Complete()
							any_new_result1_22_upvr:DoCleaning()
						end
					end
				end)
			end, function(...) -- Line 908
				--[[ Upvalues[2]:
					[1]: arg1_32 (readonly)
					[2]: any_new_result1_22_upvr (readonly)
				]]
				arg1_32:Fail(...)
				any_new_result1_22_upvr:DoCleaning()
			end, function() -- Line 912
				--[[ Upvalues[4]:
					[1]: var210_upvw (read and write)
					[2]: var211_upvw (read and write)
					[3]: arg1_32 (readonly)
					[4]: any_new_result1_22_upvr (readonly)
				]]
				var210_upvw = true
				if var211_upvw and var210_upvw then
					arg1_32:Complete()
					any_new_result1_22_upvr:DoCleaning()
				end
			end)
			return any_new_result1_22_upvr
		end)
	end
end
function module_upvr.flatMap(arg1, arg2) -- Line 934
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local var220
	if type(arg1) ~= "function" then
		var220 = false
	else
		var220 = true
	end
	assert(var220, "Bad project")
	return function(arg1_34) -- Line 937
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: arg2 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_34), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_35) -- Line 940
			--[[ Upvalues[5]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_34 (readonly)
				[3]: arg1 (copied, readonly)
				[4]: any_load_result1_result1_upvr_3 (copied, readonly)
				[5]: arg2 (copied, readonly)
			]]
			local any_new_result1_24_upvr = any_load_result1_result1_upvr.new()
			local var224_upvw = 0
			local var225_upvw = false
			any_new_result1_24_upvr:GiveTask(arg1_34:Subscribe(function(...) -- Line 947
				--[[ Upvalues[8]:
					[1]: arg1 (copied, readonly)
					[2]: any_load_result1_result1_upvr_3 (copied, readonly)
					[3]: var224_upvw (read and write)
					[4]: any_load_result1_result1_upvr (copied, readonly)
					[5]: arg2 (copied, readonly)
					[6]: arg1_35 (readonly)
					[7]: var225_upvw (read and write)
					[8]: any_new_result1_24_upvr (readonly)
				]]
				local arg1_result1 = arg1(...)
				assert(any_load_result1_result1_upvr_3.isObservable(arg1_result1), "Bad observable from project")
				var224_upvw += 1
				local any_new_result1_19_upvr = any_load_result1_result1_upvr.new()
				local var230_upvr = ...
				any_new_result1_19_upvr:GiveTask(arg1_result1:Subscribe(function(...) -- Line 958
					--[[ Upvalues[3]:
						[1]: arg2 (copied, readonly)
						[2]: arg1_35 (copied, readonly)
						[3]: var230_upvr (readonly)
					]]
					if arg2 then
						arg1_35:Fire(arg2(var230_upvr, ...))
					else
						arg1_35:Fire(...)
					end
				end, function(...) -- Line 966
					--[[ Upvalues[1]:
						[1]: arg1_35 (copied, readonly)
					]]
					arg1_35:Fail(...)
				end, function() -- Line 969
					--[[ Upvalues[5]:
						[1]: any_new_result1_19_upvr (readonly)
						[2]: var224_upvw (copied, read and write)
						[3]: var225_upvw (copied, read and write)
						[4]: arg1_35 (copied, readonly)
						[5]: any_new_result1_24_upvr (copied, readonly)
					]]
					any_new_result1_19_upvr:DoCleaning()
					var224_upvw -= 1
					if var224_upvw == 0 and var225_upvw then
						arg1_35:Complete()
						any_new_result1_24_upvr:DoCleaning()
					end
				end))
				local any_GiveTask_result1_upvr = any_new_result1_24_upvr:GiveTask(any_new_result1_19_upvr)
				any_new_result1_19_upvr:GiveTask(function() -- Line 981
					--[[ Upvalues[2]:
						[1]: any_new_result1_24_upvr (copied, readonly)
						[2]: any_GiveTask_result1_upvr (readonly)
					]]
					any_new_result1_24_upvr[any_GiveTask_result1_upvr] = nil
				end)
			end, function(...) -- Line 985
				--[[ Upvalues[2]:
					[1]: arg1_35 (readonly)
					[2]: any_new_result1_24_upvr (readonly)
				]]
				arg1_35:Fail(...)
				any_new_result1_24_upvr:DoCleaning()
			end, function() -- Line 989
				--[[ Upvalues[4]:
					[1]: var225_upvw (read and write)
					[2]: var224_upvw (read and write)
					[3]: arg1_35 (readonly)
					[4]: any_new_result1_24_upvr (readonly)
				]]
				var225_upvw = true
				if var224_upvw == 0 then
					arg1_35:Complete()
					any_new_result1_24_upvr:DoCleaning()
				end
			end))
			return any_new_result1_24_upvr
		end)
	end
end
function module_upvr.switchMap(arg1) -- Line 1002
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.pipe({module_upvr.map(arg1), module_upvr.switchAll()})
end
function module_upvr.takeUntil(arg1) -- Line 1009
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	assert(any_load_result1_result1_upvr_3.isObservable(arg1))
	return function(arg1_36) -- Line 1012
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_36), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_37) -- Line 1015
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: arg1_36 (readonly)
			]]
			local any_new_result1_upvr = any_load_result1_result1_upvr.new()
			local var241_upvw = false
			local function cancel() -- Line 1019
				--[[ Upvalues[2]:
					[1]: any_new_result1_upvr (readonly)
					[2]: var241_upvw (read and write)
				]]
				any_new_result1_upvr:DoCleaning()
				var241_upvw = true
			end
			any_new_result1_upvr:GiveTask(arg1:Subscribe(cancel, cancel, nil))
			if var241_upvw then
				any_new_result1_upvr:DoCleaning()
				return nil
			end
			any_new_result1_upvr:GiveTask(arg1_36:Subscribe(arg1_37:GetFireFailComplete()))
			return any_new_result1_upvr
		end)
	end
end
function module_upvr.packed(...) -- Line 1055
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local packed_7_upvr = table.pack(...)
	return any_load_result1_result1_upvr_3.new(function(arg1) -- Line 1058
		--[[ Upvalues[1]:
			[1]: packed_7_upvr (readonly)
		]]
		arg1:Fire(unpack(packed_7_upvr, 1, packed_7_upvr.n))
		arg1:Complete()
	end)
end
function module_upvr.unpacked(arg1) -- Line 1069
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
	return any_load_result1_result1_upvr_3.new(function(arg1_38) -- Line 1072
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:Subscribe(function(arg1_39) -- Line 1073
			--[[ Upvalues[1]:
				[1]: arg1_38 (readonly)
			]]
			if type(arg1_39) == "table" then
				arg1_38:Fire(unpack(arg1_39))
			else
				warn("[Rx.unpacked] - Observable didn't return a table got type %q":format(type(arg1_39)))
			end
		end, arg1_38:GetFailComplete())
	end)
end
function module_upvr.finalize(arg1) -- Line 1102
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local var246
	if type(arg1) ~= "function" then
		var246 = false
	else
		var246 = true
	end
	assert(var246, "Bad finalizerCallback")
	return function(arg1_40) -- Line 1105
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_40), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_41) -- Line 1108
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_40 (readonly)
				[3]: arg1 (copied, readonly)
			]]
			local any_new_result1_5 = any_load_result1_result1_upvr.new()
			any_new_result1_5:GiveTask(arg1_40:Subscribe(arg1_41:GetFireFailComplete()))
			any_new_result1_5:GiveTask(arg1)
			return any_new_result1_5
		end)
	end
end
function module_upvr.combineLatestAll() -- Line 1129
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: module_upvr (readonly)
	]]
	return function(arg1) -- Line 1130
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: module_upvr (copied, readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_42) -- Line 1133
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: any_load_result1_result1_upvr_3 (copied, readonly)
				[4]: module_upvr (copied, readonly)
			]]
			local tbl_upvr = {}
			local any_new_result1_18_upvr = any_load_result1_result1_upvr.new()
			local var254_upvw = true
			any_new_result1_18_upvr:GiveTask(function() -- Line 1138
				--[[ Upvalues[1]:
					[1]: var254_upvw (read and write)
				]]
				var254_upvw = false
			end)
			any_new_result1_18_upvr:GiveTask(arg1:Subscribe(function(arg1_43) -- Line 1143
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_3 (copied, readonly)
					[2]: tbl_upvr (readonly)
				]]
				assert(any_load_result1_result1_upvr_3.isObservable(arg1_43))
				table.insert(tbl_upvr, arg1_43)
			end, function(...) -- Line 1148
				--[[ Upvalues[1]:
					[1]: arg1_42 (readonly)
				]]
				arg1_42:Fail(...)
			end), function() -- Line 1151
				--[[ Upvalues[5]:
					[1]: var254_upvw (read and write)
					[2]: any_new_result1_18_upvr (readonly)
					[3]: module_upvr (copied, readonly)
					[4]: tbl_upvr (readonly)
					[5]: arg1_42 (readonly)
				]]
				if not var254_upvw then
				else
					any_new_result1_18_upvr:GiveTask(module_upvr.combineLatest(tbl_upvr)):Subscribe(arg1_42:GetFireFailComplete())
				end
			end)
			return any_new_result1_18_upvr
		end)
	end
end
module_upvr.combineAll = module_upvr.combineLatestAll
function module_upvr.catchError(arg1) -- Line 1188
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local var259
	if type(arg1) ~= "function" then
		var259 = false
	else
		var259 = true
	end
	assert(var259, "Bad callback")
	return function(arg1_44) -- Line 1191
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_44), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_45) -- Line 1194
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_44 (readonly)
				[3]: arg1 (copied, readonly)
				[4]: any_load_result1_result1_upvr_3 (copied, readonly)
			]]
			local any_new_result1_8_upvr = any_load_result1_result1_upvr.new()
			local var263_upvw = true
			any_new_result1_8_upvr:GiveTask(function() -- Line 1199
				--[[ Upvalues[1]:
					[1]: var263_upvw (read and write)
				]]
				var263_upvw = false
			end)
			any_new_result1_8_upvr:GiveTask(arg1_44:Subscribe(function(...) -- Line 1204
				--[[ Upvalues[1]:
					[1]: arg1_45 (readonly)
				]]
				arg1_45:Fire(...)
			end, function(...) -- Line 1207
				--[[ Upvalues[5]:
					[1]: var263_upvw (read and write)
					[2]: arg1 (copied, readonly)
					[3]: any_load_result1_result1_upvr_3 (copied, readonly)
					[4]: any_new_result1_8_upvr (readonly)
					[5]: arg1_45 (readonly)
				]]
				if not var263_upvw then
				else
					local arg1_result1_3 = arg1(...)
					assert(any_load_result1_result1_upvr_3.isObservable(arg1_result1_3), "Bad observable")
					any_new_result1_8_upvr:GiveTask(arg1_result1_3:Subscribe(arg1_45:GetFireFailComplete()))
				end
			end, function() -- Line 1221
				--[[ Upvalues[1]:
					[1]: arg1_45 (readonly)
				]]
				arg1_45:Complete()
			end))
			return any_new_result1_8_upvr
		end)
	end
end
local var1_result1_upvr_2 = any_load_result1("Table")
function module_upvr.combineLatest(arg1) -- Line 1256
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_named_result1_upvw (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_2 (readonly)
	]]
	local var271
	if type(arg1) ~= "table" then
		var271 = false
	else
		var271 = true
	end
	assert(var271, "Bad observables")
	var271 = any_load_result1_result1_upvr_3
	function var271(arg1_46) -- Line 1259
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_3 (copied, readonly)
			[3]: any_named_result1_upvw (copied, readonly)
			[4]: any_load_result1_result1_upvr (copied, readonly)
			[5]: var1_result1_upvr_2 (copied, readonly)
		]]
		local tbl_5_upvr = {}
		local var284_upvw
		for i_18, v_17 in pairs(arg1) do
			if any_load_result1_result1_upvr_3.isObservable(v_17) then
				var284_upvw += 1
				tbl_5_upvr[i_18] = any_named_result1_upvw
			else
				tbl_5_upvr[i_18] = v_17
			end
		end
		if var284_upvw == 0 then
			arg1_46:Fire(tbl_5_upvr)
			arg1_46:Complete()
			return
		end
		local function _() -- Line 1280, Named "fireIfAllSet"
			--[[ Upvalues[4]:
				[1]: tbl_5_upvr (readonly)
				[2]: any_named_result1_upvw (copied, readonly)
				[3]: arg1_46 (readonly)
				[4]: var1_result1_upvr_2 (copied, readonly)
			]]
			for _, v_18 in pairs(tbl_5_upvr) do
				if v_18 == any_named_result1_upvw then return end
			end
			arg1_46:Fire(var1_result1_upvr_2.copy(tbl_5_upvr))
		end
		for i_20_upvr, v_19 in pairs(arg1) do
			if any_load_result1_result1_upvr_3.isObservable(v_19) then
				any_load_result1_result1_upvr.new():GiveTask(v_19:Subscribe(function(arg1_47) -- Line 1293
					--[[ Upvalues[5]:
						[1]: tbl_5_upvr (readonly)
						[2]: i_20_upvr (readonly)
						[3]: any_named_result1_upvw (copied, readonly)
						[4]: arg1_46 (readonly)
						[5]: var1_result1_upvr_2 (copied, readonly)
					]]
					tbl_5_upvr[i_20_upvr] = arg1_47
					for _, v_20 in pairs(tbl_5_upvr) do
						if v_20 == any_named_result1_upvw then return end
					end
					arg1_46:Fire(var1_result1_upvr_2.copy(tbl_5_upvr))
				end, function(...) -- Line 1297
					--[[ Upvalues[2]:
						[1]: var284_upvw (read and write)
						[2]: arg1_46 (readonly)
					]]
					var284_upvw -= 1
					arg1_46:Fail(...)
				end, function() -- Line 1301
					--[[ Upvalues[2]:
						[1]: var284_upvw (read and write)
						[2]: arg1_46 (readonly)
					]]
					var284_upvw -= 1
					if var284_upvw == 0 then
						arg1_46:Complete()
					end
				end))
			end
		end
		return any_load_result1_result1_upvr.new()
	end
	return var271.new(var271)
end
function module_upvr.using(arg1, arg2) -- Line 1329
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr_3.new(function(arg1_48) -- Line 1330
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		local any_new_result1_17 = any_load_result1_result1_upvr.new()
		local arg1_result1_2 = arg1()
		any_new_result1_17:GiveTask(arg1_result1_2)
		local arg2_result1 = arg2(arg1_result1_2)
		assert(any_load_result1_result1_upvr_3.isObservable(arg2_result1), "Bad observable")
		any_new_result1_17:GiveTask(arg2_result1:Subscribe(arg1_48:GetFireFailComplete()))
		return any_new_result1_17
	end)
end
function module_upvr.first() -- Line 1355
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	return module_upvr.take(1)
end
function module_upvr.take(arg1) -- Line 1366
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local var305
	if type(arg1) ~= "number" then
		var305 = false
	else
		var305 = true
	end
	assert(var305, "Bad number")
	if 0 >= arg1 then
		var305 = false
	else
		var305 = true
	end
	assert(var305, "Bad number")
	return function(arg1_49) -- Line 1370
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_49), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_50) -- Line 1373
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_49 (readonly)
				[3]: arg1 (copied, readonly)
			]]
			local any_new_result1_26 = any_load_result1_result1_upvr.new()
			local var310_upvw = 0
			any_new_result1_26:GiveTask(arg1_49:Subscribe(function(...) -- Line 1377
				--[[ Upvalues[3]:
					[1]: var310_upvw (read and write)
					[2]: arg1 (copied, readonly)
					[3]: arg1_50 (readonly)
				]]
				if arg1 <= var310_upvw then
					warn("[Rx.take] - Still getting values past subscription")
				else
					var310_upvw += 1
					arg1_50:Fire(...)
					if arg1 <= var310_upvw then
						arg1_50:Complete()
					end
				end
			end, arg1_50:GetFailComplete()))
			return any_new_result1_26
		end)
	end
end
function module_upvr.skip(arg1) -- Line 1403
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local var311
	if type(arg1) ~= "number" then
		var311 = false
	else
		var311 = true
	end
	assert(var311, "Bad toSkip")
	if 0 >= arg1 then
		var311 = false
	else
		var311 = true
	end
	assert(var311, "Bad toSkip")
	return function(arg1_51) -- Line 1407
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_51), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_52) -- Line 1410
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_51 (readonly)
				[3]: arg1 (copied, readonly)
			]]
			local any_new_result1_16 = any_load_result1_result1_upvr.new()
			local var316_upvw = 0
			any_new_result1_16:GiveTask(arg1_51:Subscribe(function(...) -- Line 1414
				--[[ Upvalues[3]:
					[1]: var316_upvw (read and write)
					[2]: arg1 (copied, readonly)
					[3]: arg1_52 (readonly)
				]]
				if var316_upvw <= arg1 then
					var316_upvw += 1
				else
					arg1_52:Fire(...)
				end
			end, arg1_52:GetFailComplete()))
			return any_new_result1_16
		end)
	end
end
function module_upvr.defer(arg1) -- Line 1438
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	return any_load_result1_result1_upvr_3.new(function(arg1_53) -- Line 1439
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		local var318_upvw
		local pcall_result1, pcall_result2 = pcall(function() -- Line 1441
			--[[ Upvalues[2]:
				[1]: var318_upvw (read and write)
				[2]: arg1 (copied, readonly)
			]]
			var318_upvw = arg1()
		end)
		if not pcall_result1 then
			arg1_53:Fail(pcall_result2)
			return
		end
		if not any_load_result1_result1_upvr_3.isObservable(var318_upvw) then
			arg1_53:Fail("Not an observable")
			return
		end
		return var318_upvw:Subscribe(arg1_53:GetFireFailComplete())
	end)
end
local var1_result1_upvr_4 = any_load_result1("cancellableDelay")
function module_upvr.delay(arg1) -- Line 1465
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: var1_result1_upvr_4 (readonly)
	]]
	local var323
	if type(arg1) ~= "number" then
		var323 = false
	else
		var323 = true
	end
	assert(var323, "Bad seconds")
	return function(arg1_54) -- Line 1468
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: var1_result1_upvr_4 (copied, readonly)
			[4]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_54), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_55) -- Line 1471
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1_54 (readonly)
				[3]: var1_result1_upvr_4 (copied, readonly)
				[4]: arg1 (copied, readonly)
			]]
			local any_new_result1_14_upvr = any_load_result1_result1_upvr.new()
			any_new_result1_14_upvr:GiveTask(arg1_54:Subscribe(function(...) -- Line 1474
				--[[ Upvalues[4]:
					[1]: any_new_result1_14_upvr (readonly)
					[2]: var1_result1_upvr_4 (copied, readonly)
					[3]: arg1 (copied, readonly)
					[4]: arg1_55 (readonly)
				]]
				local packed_3_upvr = table.pack(...)
				any_new_result1_14_upvr[packed_3_upvr] = var1_result1_upvr_4(arg1, function() -- Line 1477
					--[[ Upvalues[3]:
						[1]: any_new_result1_14_upvr (copied, readonly)
						[2]: packed_3_upvr (readonly)
						[3]: arg1_55 (copied, readonly)
					]]
					any_new_result1_14_upvr[packed_3_upvr] = nil
					arg1_55:Fire(table.unpack(packed_3_upvr, 1, packed_3_upvr.n))
				end)
			end, arg1_55:GetFailComplete()))
			return any_new_result1_14_upvr
		end)
	end
end
function module_upvr.timer(arg1, arg2) -- Line 1495
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	local var331 = true
	if type(arg1) ~= "number" then
		if arg1 ~= nil then
			var331 = false
		else
			var331 = true
		end
	end
	assert(var331, "Bad initialDelaySeconds")
	if type(arg2) ~= "number" then
		var331 = false
	else
		var331 = true
	end
	assert(var331, "Bad seconds")
	var331 = any_load_result1_result1_upvr_3
	function var331(arg1_56) -- Line 1499
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		local any_new_result1_13 = any_load_result1_result1_upvr.new()
		local var333_upvw = true
		local var335_upvw = -1
		local task_spawn_result1_upvr = task.spawn(function() -- Line 1505
			--[[ Upvalues[5]:
				[1]: arg1 (copied, readonly)
				[2]: var333_upvw (read and write)
				[3]: var335_upvw (read and write)
				[4]: arg1_56 (readonly)
				[5]: arg2 (copied, readonly)
			]]
			if arg1 and 0 < arg1 then
				task.wait(arg1)
			end
			while var333_upvw do
				var335_upvw += 1
				arg1_56:Fire(var335_upvw)
				task.wait(arg2)
			end
		end)
		any_new_result1_13:GiveTask(function() -- Line 1517
			--[[ Upvalues[2]:
				[1]: var333_upvw (read and write)
				[2]: task_spawn_result1_upvr (readonly)
			]]
			var333_upvw = false
			coroutine.close(task_spawn_result1_upvr)
		end)
		return any_new_result1_13
	end
	return var331.new(var331)
end
function module_upvr.withLatestFrom(arg1) -- Line 1535
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_named_result1_upvw (readonly)
	]]
	assert(arg1, "Bad inputObservables")
	for _, v_21 in pairs(arg1) do
		assert(any_load_result1_result1_upvr_3.isObservable(v_21), "Bad observable")
	end
	return function(arg1_57) -- Line 1542
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: any_named_result1_upvw (copied, readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_57), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_58) -- Line 1545
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: any_named_result1_upvw (copied, readonly)
				[4]: arg1_57 (readonly)
			]]
			local any_new_result1_11 = any_load_result1_result1_upvr.new()
			local tbl_3_upvr = {}
			for i_23_upvr, v_22 in pairs(arg1) do
				tbl_3_upvr[i_23_upvr] = any_named_result1_upvw
				any_new_result1_11:GiveTask(v_22:Subscribe(function(arg1_59) -- Line 1553
					--[[ Upvalues[2]:
						[1]: tbl_3_upvr (readonly)
						[2]: i_23_upvr (readonly)
					]]
					tbl_3_upvr[i_23_upvr] = arg1_59
				end, nil, nil))
			end
			any_new_result1_11:GiveTask(arg1_57:Subscribe(function(arg1_60) -- Line 1558
				--[[ Upvalues[3]:
					[1]: tbl_3_upvr (readonly)
					[2]: any_named_result1_upvw (copied, readonly)
					[3]: arg1_58 (readonly)
				]]
				for _, v_23 in pairs(tbl_3_upvr) do
					if v_23 == any_named_result1_upvw then return end
				end
				local tbl = {}
				tbl[1] = arg1_60
				tbl[2] = unpack(tbl_3_upvr)
				arg1_58:Fire(tbl)
			end, arg1_58:GetFailComplete()))
			return any_new_result1_11
		end)
	end
end
function module_upvr.scan(arg1, arg2) -- Line 1580
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var362
	if type(arg1) ~= "function" then
		var362 = false
	else
		var362 = true
	end
	assert(var362, "Bad accumulator")
	return function(arg1_61) -- Line 1583
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_61), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_62) -- Line 1586
			--[[ Upvalues[3]:
				[1]: arg2 (copied, readonly)
				[2]: arg1_61 (readonly)
				[3]: arg1 (copied, readonly)
			]]
			return arg1_61:Subscribe(function(...) -- Line 1589
				--[[ Upvalues[3]:
					[1]: arg2 (read and write)
					[2]: arg1 (copied, readonly)
					[3]: arg1_62 (readonly)
				]]
				arg2 = arg1(arg2, ...)
				arg1_62:Fire(arg2)
			end, arg1_62:GetFailComplete())
		end)
	end
end
local var1_result1_upvr = any_load_result1("ThrottledFunction")
function module_upvr.throttleTime(arg1, arg2) -- Line 1610
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local var367
	if type(arg1) ~= "number" then
		var367 = false
	else
		var367 = true
	end
	assert(var367, "Bad duration")
	var367 = true
	if type(arg2) ~= "table" then
		if arg2 ~= nil then
			var367 = false
		else
			var367 = true
		end
	end
	assert(var367, "Bad throttleConfig")
	return function(arg1_63) -- Line 1614
		--[[ Upvalues[5]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: var1_result1_upvr (copied, readonly)
			[4]: arg1 (readonly)
			[5]: arg2 (readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1_63), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_64) -- Line 1617
			--[[ Upvalues[5]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: var1_result1_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
				[4]: arg2 (copied, readonly)
				[5]: arg1_63 (readonly)
			]]
			local any_new_result1_12 = any_load_result1_result1_upvr.new()
			local any_new_result1_7_upvr = var1_result1_upvr.new(arg1, function(...) -- Line 1620
				--[[ Upvalues[1]:
					[1]: arg1_64 (readonly)
				]]
				arg1_64:Fire(...)
			end, arg2)
			any_new_result1_12:GiveTask(any_new_result1_7_upvr)
			any_new_result1_12:GiveTask(arg1_63:Subscribe(function(...) -- Line 1625
				--[[ Upvalues[1]:
					[1]: any_new_result1_7_upvr (readonly)
				]]
				any_new_result1_7_upvr:Call(...)
			end, arg1_64:GetFailComplete()))
			return any_new_result1_12
		end)
	end
end
function module_upvr.throttleDefer() -- Line 1638
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return function(arg1) -- Line 1639
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_3 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
		]]
		assert(any_load_result1_result1_upvr_3.isObservable(arg1), "Bad observable")
		return any_load_result1_result1_upvr_3.new(function(arg1_65) -- Line 1642
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr (copied, readonly)
				[2]: arg1 (readonly)
			]]
			local any_new_result1_4_upvr = any_load_result1_result1_upvr.new()
			local var378_upvw
			any_new_result1_4_upvr:GiveTask(arg1:Subscribe(function(...) -- Line 1647
				--[[ Upvalues[3]:
					[1]: var378_upvw (read and write)
					[2]: any_new_result1_4_upvr (readonly)
					[3]: arg1_65 (readonly)
				]]
				if not var378_upvw then
					var378_upvw = table.pack(...)
					any_new_result1_4_upvr._currentQueue = task.defer(function() -- Line 1652
						--[[ Upvalues[2]:
							[1]: var378_upvw (copied, read and write)
							[2]: arg1_65 (copied, readonly)
						]]
						local var380 = var378_upvw
						var378_upvw = nil
						if arg1_65:IsPending() then
							arg1_65:Fire(table.unpack(var380, 1, var380.n))
						end
					end)
				else
					var378_upvw = table.pack(...)
				end
			end, arg1_65:GetFailComplete()))
			return any_new_result1_4_upvr
		end)
	end
end
return module_upvr