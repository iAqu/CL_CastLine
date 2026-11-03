-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:32
-- Luau version 6, Types version 3
-- Time taken: 0.018885 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("Brio")
local any_load_result1_result1_upvr_6 = any_load_result1("Maid")
local any_load_result1_result1_upvr_5 = any_load_result1("MaidTaskUtils")
local any_load_result1_result1_upvr_9 = any_load_result1("Observable")
local any_load_result1_result1_upvr_14 = any_load_result1("Promise")
local any_load_result1_result1_upvr_4 = any_load_result1("Rx")
local any_load_result1_result1_upvr_3 = any_load_result1("Signal")
local any_load_result1_result1_upvr = any_load_result1("StepUtils")
local var1_result1_upvr = any_load_result1("ValueBaseUtils")
local any_load_result1_result1_upvr_12 = any_load_result1("ValueObject")
local module_2_upvr = {}
local any_load_result1_result1_upvr_8 = any_load_result1("BlendDefaultProps")
function module_2_upvr.New(arg1) -- Line 49
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_8 (readonly)
		[2]: any_load_result1_result1_upvr_9 (readonly)
		[3]: module_2_upvr (readonly)
	]]
	local var15
	if type(arg1) ~= "string" then
		var15 = false
	else
		var15 = true
	end
	assert(var15, "Bad className")
	var15 = any_load_result1_result1_upvr_8
	local var16_upvr = var15[arg1]
	function var15(arg1_2) -- Line 54
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_9 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: var16_upvr (readonly)
			[4]: module_2_upvr (copied, readonly)
		]]
		return any_load_result1_result1_upvr_9.new(function(arg1_3) -- Line 55
			--[[ Upvalues[4]:
				[1]: arg1 (copied, readonly)
				[2]: var16_upvr (copied, readonly)
				[3]: module_2_upvr (copied, readonly)
				[4]: arg1_2 (readonly)
			]]
			local any = Instance.new(arg1)
			if var16_upvr then
				for i, v in pairs(var16_upvr) do
					any[i] = v
				end
			end
			local any_mount_result1 = module_2_upvr.mount(any, arg1_2)
			any_mount_result1:GiveTask(any)
			arg1_3:Fire(any)
			return any_mount_result1
		end)
	end
	return var15
end
function module_2_upvr.State(arg1) -- Line 80
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_12 (readonly)
	]]
	return any_load_result1_result1_upvr_12.new(arg1)
end
function module_2_upvr.Throttled(arg1) -- Line 93
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	return arg1:Pipe({any_load_result1_result1_upvr_4.throttleDefer()})
end
function module_2_upvr.Shared(arg1) -- Line 108
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	return arg1:Pipe({any_load_result1_result1_upvr_4.cache()})
end
function module_2_upvr.Dynamic(...) -- Line 114
	--[[ Upvalues[4]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
		[3]: any_load_result1_result1_upvr_14 (readonly)
		[4]: any_load_result1_result1_upvr_9 (readonly)
	]]
	return module_2_upvr.Computed(...):Pipe({any_load_result1_result1_upvr_4.switchMap(function(arg1, ...) -- Line 119
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_14 (copied, readonly)
			[2]: any_load_result1_result1_upvr_4 (copied, readonly)
			[3]: any_load_result1_result1_upvr_9 (copied, readonly)
		]]
		if any_load_result1_result1_upvr_14.isPromise(arg1) then
			return any_load_result1_result1_upvr_4.fromPromise(arg1)
		end
		if any_load_result1_result1_upvr_9.isObservable(arg1) then
			return arg1
		end
		return any_load_result1_result1_upvr_4.of(arg1, ...)
	end)})
end
function module_2_upvr.Computed(...) -- Line 157
	--[[ Upvalues[3]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
		[3]: any_load_result1_result1_upvr_9 (readonly)
	]]
	local args_list = {...}
	local arg_count_upvr = select('#', ...)
	local var35_upvr = args_list[arg_count_upvr]
	local var36
	if type(var35_upvr) ~= "function" then
		var36 = false
	else
		var36 = true
	end
	assert(var36, "Bad compute")
	local tbl = {}
	var36 = arg_count_upvr - 1
	for i_2 = 1, var36 do
		local any_toPropertyObservable_result1_3 = module_2_upvr.toPropertyObservable(args_list[i_2])
		if any_toPropertyObservable_result1_3 then
			tbl[i_2] = any_toPropertyObservable_result1_3
		else
			tbl[i_2] = any_load_result1_result1_upvr_4.of(args_list[i_2])
		end
	end
	var36 = #tbl
	if var36 == 0 then
		var36 = any_load_result1_result1_upvr_9.new
		var36 = var36(function(arg1) -- Line 176
			--[[ Upvalues[1]:
				[1]: var35_upvr (readonly)
			]]
			arg1:Fire(var35_upvr())
		end)
		return var36
	end
	var36 = #tbl
	if var36 == 1 then
		var36 = any_load_result1_result1_upvr_4.map(var35_upvr)(tbl[1])
		return var36
	end
	var36 = any_load_result1_result1_upvr_4.combineLatest(tbl)
	var36 = var36:Pipe({any_load_result1_result1_upvr_4.map(function(arg1) -- Line 184
		--[[ Upvalues[2]:
			[1]: var35_upvr (readonly)
			[2]: arg_count_upvr (readonly)
		]]
		return var35_upvr(unpack(arg1, 1, arg_count_upvr - 1))
	end)})
	return var36
end
local any_load_result1_result1_upvr_13 = any_load_result1("RxInstanceUtils")
function module_2_upvr.OnChange(arg1) -- Line 207
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_13 (readonly)
	]]
	local var43
	if type(arg1) ~= "string" then
		var43 = false
	else
		var43 = true
	end
	assert(var43, "Bad propertyName")
	return function(arg1_4) -- Line 210
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_13 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return any_load_result1_result1_upvr_13.observeProperty(arg1_4, arg1)
	end
end
function module_2_upvr.OnEvent(arg1) -- Line 233
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var45
	if type(arg1) ~= "string" then
		var45 = false
	else
		var45 = true
	end
	assert(var45, "Bad eventName")
	return function(arg1_5) -- Line 236
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_4 (copied, readonly)
			[2]: arg1 (readonly)
		]]
		return any_load_result1_result1_upvr_4.fromSignal(arg1_5[arg1])
	end
end
function module_2_upvr.Attached(arg1) -- Line 265
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
		[2]: any_load_result1_result1_upvr_6 (readonly)
		[3]: any_load_result1_result1_upvr_5 (readonly)
	]]
	return function(arg1_6) -- Line 266
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_9 (copied, readonly)
			[2]: any_load_result1_result1_upvr_6 (copied, readonly)
			[3]: arg1 (readonly)
			[4]: any_load_result1_result1_upvr_5 (copied, readonly)
		]]
		return any_load_result1_result1_upvr_9.new(function(arg1_7) -- Line 267
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr_6 (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: arg1_6 (readonly)
				[4]: any_load_result1_result1_upvr_5 (copied, readonly)
			]]
			local any_new_result1 = any_load_result1_result1_upvr_6.new()
			local arg1_result1 = arg1(arg1_6)
			if any_load_result1_result1_upvr_5.isValidTask(arg1_result1) then
				any_new_result1:GiveTask(arg1_result1)
			end
			arg1_7:Fire(arg1_result1)
			return any_new_result1
		end)
	end
end
function module_2_upvr.ComputedPairs(arg1, arg2) -- Line 289
	--[[ Upvalues[5]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
		[3]: any_load_result1_result1_upvr_9 (readonly)
		[4]: any_load_result1_result1_upvr_6 (readonly)
		[5]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local any_toPropertyObservable_result1_upvr = module_2_upvr.toPropertyObservable(arg1)
	if not any_toPropertyObservable_result1_upvr then
		any_toPropertyObservable_result1_upvr = any_load_result1_result1_upvr_4.of(arg1)
	end
	return any_load_result1_result1_upvr_9.new(function(arg1_8) -- Line 292
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_6 (copied, readonly)
			[2]: any_toPropertyObservable_result1_upvr (readonly)
			[3]: arg2 (readonly)
			[4]: any_load_result1_result1_upvr_2 (copied, readonly)
		]]
		local any_new_result1_3 = any_load_result1_result1_upvr_6.new()
		local any_new_result1_upvr = any_load_result1_result1_upvr_6.new()
		any_new_result1_3:GiveTask(any_new_result1_upvr)
		local tbl_2_upvr = {}
		any_new_result1_3:GiveTask(any_toPropertyObservable_result1_upvr:Subscribe(function(arg1_9) -- Line 299
			--[[ Upvalues[6]:
				[1]: tbl_2_upvr (readonly)
				[2]: any_load_result1_result1_upvr_6 (copied, readonly)
				[3]: arg2 (copied, readonly)
				[4]: any_load_result1_result1_upvr_2 (copied, readonly)
				[5]: arg1_8 (readonly)
				[6]: any_new_result1_upvr (readonly)
			]]
			local var69
			if type(arg1_9) ~= "table" then
				var69 = false
			else
				var69 = true
			end
			assert(var69, "Bad value emitted from source")
			var69 = pairs(tbl_2_upvr)
			local pairs_result1_3, pairs_result2_5, pairs_result3 = pairs(tbl_2_upvr)
			for i_3, _ in pairs_result1_3, pairs_result2_5, pairs_result3 do
				({})[i_3] = true
				local var74
			end
			pairs_result1_3 = pairs(arg1_9)
			local pairs_result1_4, pairs_result2, pairs_result3_5 = pairs(arg1_9)
			for i_4, v_3 in pairs_result1_4, pairs_result2, pairs_result3_5 do
				var74[i_4] = nil
				if tbl_2_upvr[i_4] ~= v_3 then
					local any_new_result1_14 = any_load_result1_result1_upvr_6.new()
					local any_new_result1_11 = any_load_result1_result1_upvr_2.new(arg2(i_4, v_3, any_new_result1_14))
					any_new_result1_14:GiveTask(any_new_result1_11)
					arg1_8:Fire(any_new_result1_11)
					any_new_result1_upvr[i_4] = any_new_result1_14
					tbl_2_upvr[i_4] = v_3
				end
			end
			pairs_result1_4 = pairs(var74)
			for i_5, _ in pairs(var74) do
				any_new_result1_upvr[i_5] = nil
				tbl_2_upvr[i_5] = nil
			end
		end), arg1_8:GetFailComplete())
		return any_new_result1_3
	end)
end
local any_load_result1_result1_upvr_15 = any_load_result1("AccelTween")
function module_2_upvr.AccelTween(arg1, arg2) -- Line 342
	--[[ Upvalues[6]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
		[3]: any_load_result1_result1_upvr_15 (readonly)
		[4]: any_load_result1_result1_upvr_9 (readonly)
		[5]: any_load_result1_result1_upvr_6 (readonly)
		[6]: any_load_result1_result1_upvr (readonly)
	]]
	local any_toPropertyObservable_result1_2_upvr = module_2_upvr.toPropertyObservable(arg1)
	if not any_toPropertyObservable_result1_2_upvr then
		any_toPropertyObservable_result1_2_upvr = any_load_result1_result1_upvr_4.of(arg1)
	end
	local any_toNumberObservable_result1_upvr_2 = module_2_upvr.toNumberObservable(arg2)
	local function _(arg1_10, arg2_2) -- Line 346, Named "createAccelTween"
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_15 (copied, readonly)
			[2]: any_toNumberObservable_result1_upvr_2 (readonly)
		]]
		local any_new_result1_6_upvr = any_load_result1_result1_upvr_15.new()
		if arg2_2 then
			any_new_result1_6_upvr.p = arg2_2
			any_new_result1_6_upvr.t = arg2_2
			any_new_result1_6_upvr.v = 0
		end
		if any_toNumberObservable_result1_upvr_2 then
			arg1_10:GiveTask(any_toNumberObservable_result1_upvr_2:Subscribe(function(arg1_11) -- Line 356
				--[[ Upvalues[1]:
					[1]: any_new_result1_6_upvr (readonly)
				]]
				local var88
				if type(arg1_11) ~= "number" then
					var88 = false
				else
					var88 = true
				end
				assert(var88, "Bad value")
				any_new_result1_6_upvr.a = arg1_11
			end))
		end
		return any_new_result1_6_upvr
	end
	return any_load_result1_result1_upvr_9.new(function(arg1_12) -- Line 366
		--[[ Upvalues[5]:
			[1]: any_load_result1_result1_upvr_6 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: any_toPropertyObservable_result1_2_upvr (readonly)
			[4]: any_load_result1_result1_upvr_15 (copied, readonly)
			[5]: any_toNumberObservable_result1_upvr_2 (readonly)
		]]
		local var90_upvw
		local any_new_result1_9_upvr = any_load_result1_result1_upvr_6.new()
		local any_bindToRenderStep_result1_upvr, any_bindToRenderStep_result2_2 = any_load_result1_result1_upvr.bindToRenderStep(function() -- Line 370
			--[[ Upvalues[2]:
				[1]: arg1_12 (readonly)
				[2]: var90_upvw (read and write)
			]]
			arg1_12:Fire(var90_upvw.p)
			local var93
			if 0 >= var90_upvw.rtime then
				var93 = false
			else
				var93 = true
			end
			return var93
		end)
		any_new_result1_9_upvr:GiveTask(any_bindToRenderStep_result2_2)
		any_new_result1_9_upvr:GiveTask(any_toPropertyObservable_result1_2_upvr:Subscribe(function(arg1_13) -- Line 376
			--[[ Upvalues[5]:
				[1]: var90_upvw (read and write)
				[2]: any_new_result1_9_upvr (readonly)
				[3]: any_load_result1_result1_upvr_15 (copied, readonly)
				[4]: any_toNumberObservable_result1_upvr_2 (copied, readonly)
				[5]: any_bindToRenderStep_result1_upvr (readonly)
			]]
			local var97 = var90_upvw
			if not var97 then
				local any_new_result1_upvr_2 = any_load_result1_result1_upvr_15.new()
				if arg1_13 then
					any_new_result1_upvr_2.p = arg1_13
					any_new_result1_upvr_2.t = arg1_13
					any_new_result1_upvr_2.v = 0
				end
				if any_toNumberObservable_result1_upvr_2 then
					any_new_result1_9_upvr:GiveTask(any_toNumberObservable_result1_upvr_2:Subscribe(function(arg1_14) -- Line 356
						--[[ Upvalues[1]:
							[1]: any_new_result1_upvr_2 (readonly)
						]]
						local var100
						if type(arg1_14) ~= "number" then
							var100 = false
						else
							var100 = true
						end
						assert(var100, "Bad value")
						any_new_result1_upvr_2.a = arg1_14
					end))
				end
				var97 = any_new_result1_upvr_2
			end
			var90_upvw = var97
			var90_upvw.t = arg1_13
			any_bindToRenderStep_result1_upvr()
		end))
		return any_new_result1_9_upvr
	end)
end
local var1_result1_upvr_2 = any_load_result1("Spring")
local any_load_result1_result1_upvr_7 = any_load_result1("SpringUtils")
function module_2_upvr.Spring(arg1, arg2, arg3) -- Line 407
	--[[ Upvalues[7]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_9 (readonly)
		[5]: any_load_result1_result1_upvr_6 (readonly)
		[6]: any_load_result1_result1_upvr (readonly)
		[7]: any_load_result1_result1_upvr_7 (readonly)
	]]
	local any_toPropertyObservable_result1_4_upvr = module_2_upvr.toPropertyObservable(arg1)
	if not any_toPropertyObservable_result1_4_upvr then
		any_toPropertyObservable_result1_4_upvr = any_load_result1_result1_upvr_4.of(arg1)
	end
	local any_toNumberObservable_result1_upvr = module_2_upvr.toNumberObservable(arg2)
	local any_toNumberObservable_result1_upvr_3 = module_2_upvr.toNumberObservable(arg3)
	local function createSpring_upvr(arg1_15, arg2_3) -- Line 412, Named "createSpring"
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: any_toNumberObservable_result1_upvr (readonly)
			[3]: any_toNumberObservable_result1_upvr_3 (readonly)
		]]
		local any_new_result1_12_upvr = var1_result1_upvr_2.new(arg2_3)
		if any_toNumberObservable_result1_upvr then
			arg1_15:GiveTask(any_toNumberObservable_result1_upvr:Subscribe(function(arg1_16) -- Line 416
				--[[ Upvalues[1]:
					[1]: any_new_result1_12_upvr (readonly)
				]]
				local var108
				if type(arg1_16) ~= "number" then
					var108 = false
				else
					var108 = true
				end
				assert(var108, "Bad value")
				any_new_result1_12_upvr.Speed = arg1_16
			end))
		end
		if any_toNumberObservable_result1_upvr_3 then
			arg1_15:GiveTask(any_toNumberObservable_result1_upvr_3:Subscribe(function(arg1_17) -- Line 423
				--[[ Upvalues[1]:
					[1]: any_new_result1_12_upvr (readonly)
				]]
				local var110
				if type(arg1_17) ~= "number" then
					var110 = false
				else
					var110 = true
				end
				assert(var110, "Bad value")
				any_new_result1_12_upvr.Damper = arg1_17
			end))
		end
		return any_new_result1_12_upvr
	end
	return any_load_result1_result1_upvr_9.new(function(arg1_18) -- Line 434
		--[[ Upvalues[5]:
			[1]: any_load_result1_result1_upvr_6 (copied, readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: any_load_result1_result1_upvr_7 (copied, readonly)
			[4]: any_toPropertyObservable_result1_4_upvr (readonly)
			[5]: createSpring_upvr (readonly)
		]]
		local var112_upvw
		local any_new_result1_13_upvr = any_load_result1_result1_upvr_6.new()
		local any_bindToRenderStep_result1_upvr_2, any_bindToRenderStep_result2 = any_load_result1_result1_upvr.bindToRenderStep(function() -- Line 438
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr_7 (copied, readonly)
				[2]: var112_upvw (read and write)
				[3]: arg1_18 (readonly)
			]]
			local any_animating_result1, any_animating_result2 = any_load_result1_result1_upvr_7.animating(var112_upvw)
			arg1_18:Fire(any_load_result1_result1_upvr_7.fromLinearIfNeeded(any_animating_result2))
			return any_animating_result1
		end)
		any_new_result1_13_upvr:GiveTask(any_bindToRenderStep_result2)
		any_new_result1_13_upvr:GiveTask(any_toPropertyObservable_result1_4_upvr:Subscribe(function(arg1_19) -- Line 445
			--[[ Upvalues[5]:
				[1]: any_load_result1_result1_upvr_7 (copied, readonly)
				[2]: var112_upvw (read and write)
				[3]: createSpring_upvr (copied, readonly)
				[4]: any_new_result1_13_upvr (readonly)
				[5]: any_bindToRenderStep_result1_upvr_2 (readonly)
			]]
			if arg1_19 then
				local var120 = var112_upvw
				if not var120 then
					var120 = createSpring_upvr(any_new_result1_13_upvr, any_load_result1_result1_upvr_7.toLinearIfNeeded(arg1_19))
				end
				var112_upvw = var120
				var112_upvw.t = any_load_result1_result1_upvr_7.toLinearIfNeeded(arg1_19)
				any_bindToRenderStep_result1_upvr_2()
			else
				warn("Got nil value from emitted source")
			end
		end))
		return any_new_result1_13_upvr
	end)
end
local any_load_result1_result1_upvr_16 = any_load_result1("RxValueBaseUtils")
local any_load_result1_result1_upvr_11 = any_load_result1("ValueObjectUtils")
function module_2_upvr.toPropertyObservable(arg1) -- Line 466
	--[[ Upvalues[7]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_16 (readonly)
		[4]: any_load_result1_result1_upvr_12 (readonly)
		[5]: any_load_result1_result1_upvr_11 (readonly)
		[6]: any_load_result1_result1_upvr_14 (readonly)
		[7]: any_load_result1_result1_upvr_4 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 21 start (CF ANALYSIS FAILED)
	if any_load_result1_result1_upvr_9.isObservable(arg1) then
		return arg1
	end
	if typeof(arg1) == "Instance" then
		if var1_result1_upvr.isValueBase(arg1) then
			do
				return any_load_result1_result1_upvr_16.observeValue(arg1)
			end
			-- KONSTANTWARNING: GOTO [58] #48
		end
	elseif type(arg1) == "table" then
		if any_load_result1_result1_upvr_12.isValueObject(arg1) then
			return any_load_result1_result1_upvr_11.observeValue(arg1)
		end
		if any_load_result1_result1_upvr_14.isPromise(arg1) then
			return any_load_result1_result1_upvr_4.fromPromise(arg1)
		end
	end
	-- KONSTANTERROR: [0] 1. Error Block 21 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [58] 48. Error Block 12 start (CF ANALYSIS FAILED)
	do
		return nil
	end
	-- KONSTANTERROR: [58] 48. Error Block 12 end (CF ANALYSIS FAILED)
end
function module_2_upvr.toNumberObservable(arg1) -- Line 491
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
		[2]: module_2_upvr (readonly)
	]]
	if type(arg1) == "number" then
		return any_load_result1_result1_upvr_4.of(arg1)
	end
	return module_2_upvr.toPropertyObservable(arg1)
end
function module_2_upvr.toEventObservable(arg1) -- Line 505
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
	]]
	if any_load_result1_result1_upvr_9.isObservable(arg1) then
		return arg1
	end
	if typeof(arg1) == "RBXScriptSignal" or any_load_result1_result1_upvr_3.isSignal(arg1) then
		return any_load_result1_result1_upvr_4.fromSignal(arg1)
	end
	return nil
end
function module_2_upvr.toEventHandler(arg1) -- Line 521
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 21 start (CF ANALYSIS FAILED)
	if type(arg1) == "function" then
		return arg1
	end
	if typeof(arg1) == "Instance" then
		if var1_result1_upvr.isValueBase(arg1) then
			do
				return function(arg1_20) -- Line 527
					--[[ Upvalues[1]:
						[1]: arg1 (readonly)
					]]
					arg1.Value = arg1_20
				end
			end
			-- KONSTANTWARNING: GOTO [48] #39
		end
	elseif type(arg1) == "table" then
		if any_load_result1_result1_upvr_3.isSignal(arg1) then
			return function(...) -- Line 533
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1:Fire(...)
			end
		end
		if arg1.ClassName == "ValueObject" then
			return function(arg1_21) -- Line 537
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1.Value = arg1_21
			end
		end
	end
	-- KONSTANTERROR: [0] 1. Error Block 21 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [48] 39. Error Block 12 start (CF ANALYSIS FAILED)
	do
		return nil
	end
	-- KONSTANTERROR: [48] 39. Error Block 12 end (CF ANALYSIS FAILED)
end
function module_2_upvr.Children(arg1, arg2) -- Line 590
	--[[ Upvalues[2]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var126
	if typeof(arg1) ~= "Instance" then
		var126 = false
	else
		var126 = true
	end
	assert(var126, "Bad parent")
	var126 = module_2_upvr
	var126 = arg2
	if var126._observeChildren(var126) then
		var126 = var126._observeChildren(var126):Pipe({any_load_result1_result1_upvr_4.tap(function(arg1_22) -- Line 596
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1_22.Parent = arg1
		end)})
		return var126
	end
	var126 = any_load_result1_result1_upvr_4.EMPTY
	return var126
end
function module_2_upvr.Instance(arg1) -- Line 641
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
	]]
	return any_load_result1_result1_upvr_9.new(function(arg1_23) -- Line 642
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1_23:Fire(arg1)
	end)
end
local any_load_result1_result1_upvr_10 = any_load_result1("BrioUtils")
function module_2_upvr.Single(arg1) -- Line 677
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
		[2]: any_load_result1_result1_upvr_6 (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_10 (readonly)
	]]
	return any_load_result1_result1_upvr_9.new(function(arg1_24) -- Line 678
		--[[ Upvalues[4]:
			[1]: any_load_result1_result1_upvr_6 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: any_load_result1_result1_upvr_2 (copied, readonly)
			[4]: any_load_result1_result1_upvr_10 (copied, readonly)
		]]
		local any_new_result1_10_upvr = any_load_result1_result1_upvr_6.new()
		any_new_result1_10_upvr:GiveTask(arg1:Subscribe(function(arg1_25) -- Line 681
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr_2 (copied, readonly)
				[2]: any_load_result1_result1_upvr_10 (copied, readonly)
				[3]: any_new_result1_10_upvr (readonly)
				[4]: arg1_24 (readonly)
			]]
			if any_load_result1_result1_upvr_2.isBrio(arg1_25) then
				local clone = any_load_result1_result1_upvr_10.clone(arg1_25)
				any_new_result1_10_upvr._current = clone
				arg1_24:Fire(clone)
				return clone
			end
			local any_new_result1_8 = any_load_result1_result1_upvr_2.new(arg1_25)
			any_new_result1_10_upvr._current = any_new_result1_8
			arg1_24:Fire(any_new_result1_8)
			return any_new_result1_8
		end))
		return any_new_result1_10_upvr
	end)
end
function module_2_upvr._observeChildren(arg1) -- Line 706
	--[[ Upvalues[9]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
		[2]: any_load_result1_result1_upvr_12 (readonly)
		[3]: any_load_result1_result1_upvr_6 (readonly)
		[4]: module_2_upvr (readonly)
		[5]: any_load_result1_result1_upvr_5 (readonly)
		[6]: any_load_result1_result1_upvr_2 (readonly)
		[7]: any_load_result1_result1_upvr_14 (readonly)
		[8]: any_load_result1_result1_upvr_4 (readonly)
		[9]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var141_upvw
	if typeof(arg1) == "Instance" then
		return any_load_result1_result1_upvr_9.new(function(arg1_26) -- Line 709
			--[[ Upvalues[1]:
				[1]: var141_upvw (read and write)
			]]
			arg1_26:Fire(var141_upvw)
			return var141_upvw
		end)
	end
	if any_load_result1_result1_upvr_12.isValueObject(var141_upvw) then
		return any_load_result1_result1_upvr_9.new(function(arg1_27) -- Line 717
			--[[ Upvalues[4]:
				[1]: any_load_result1_result1_upvr_6 (copied, readonly)
				[2]: var141_upvw (read and write)
				[3]: module_2_upvr (copied, readonly)
				[4]: any_load_result1_result1_upvr_5 (copied, readonly)
			]]
			local any_new_result1_7_upvr = any_load_result1_result1_upvr_6.new()
			local function update() -- Line 721
				--[[ Upvalues[5]:
					[1]: var141_upvw (copied, read and write)
					[2]: any_new_result1_7_upvr (readonly)
					[3]: arg1_27 (readonly)
					[4]: module_2_upvr (copied, readonly)
					[5]: any_load_result1_result1_upvr_5 (copied, readonly)
				]]
				-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
				local Value = var141_upvw.Value
				-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [10] 8. Error Block 2 start (CF ANALYSIS FAILED)
				any_new_result1_7_upvr._current = Value
				arg1_27:Fire(Value)
				do
					return
				end
				-- KONSTANTERROR: [10] 8. Error Block 2 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [19] 15. Error Block 3 start (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [19] 15. Error Block 3 end (CF ANALYSIS FAILED)
			end
			any_new_result1_7_upvr:GiveTask(var141_upvw.Changed:Connect(update))
			update()
			return any_new_result1_7_upvr
		end)
	end
	if any_load_result1_result1_upvr_2.isBrio(var141_upvw) then
		return any_load_result1_result1_upvr_9.new(function(arg1_28) -- Line 772
			--[[ Upvalues[2]:
				[1]: var141_upvw (read and write)
				[2]: module_2_upvr (copied, readonly)
			]]
			if var141_upvw:IsDead() then
				return nil
			end
			local any_GetValue_result1 = var141_upvw:GetValue()
			if typeof(any_GetValue_result1) == "Instance" then
				local any_ToMaid_result1 = var141_upvw:ToMaid()
				any_ToMaid_result1:GiveTask(any_GetValue_result1)
				arg1_28:Fire(any_GetValue_result1)
				return any_ToMaid_result1
			end
			local any__observeChildren_result1 = module_2_upvr._observeChildren(any_GetValue_result1)
			if any__observeChildren_result1 then
				local any_ToMaid_result1_upvr = var141_upvw:ToMaid()
				any_ToMaid_result1_upvr:GiveTask(any__observeChildren_result1:Subscribe(function(arg1_29) -- Line 793
					--[[ Upvalues[1]:
						[1]: arg1_28 (readonly)
					]]
					arg1_28:Fire(arg1_29)
				end, function(...) -- Line 795
					--[[ Upvalues[1]:
						[1]: arg1_28 (readonly)
					]]
					arg1_28:Fail(...)
				end, function() -- Line 797
					--[[ Upvalues[1]:
						[1]: any_ToMaid_result1_upvr (readonly)
					]]
					any_ToMaid_result1_upvr:DoCleaning()
				end))
				return any_ToMaid_result1_upvr
			end
			any_ToMaid_result1_upvr = warn
			any_ToMaid_result1_upvr("Unknown type in brio %q":format(typeof(any_GetValue_result1)))
			any_ToMaid_result1_upvr = nil
			return any_ToMaid_result1_upvr
		end)
	end
	if any_load_result1_result1_upvr_14.isPromise(var141_upvw) then
	end
	local function INLINED() -- Internal function, doesn't exist in bytecode
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		return typeof(any_load_result1_result1_upvr_4.fromPromise(var141_upvw)) == "RBXScriptSignal"
	end
	if any_load_result1_result1_upvr_3.isSignal(any_load_result1_result1_upvr_4.fromPromise(var141_upvw)) or INLINED() then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	end
	if any_load_result1_result1_upvr_9.isObservable(any_load_result1_result1_upvr_4.fromSignal(any_load_result1_result1_upvr_4.fromPromise(var141_upvw))) then
		local any_fromSignal_result1_upvw = any_load_result1_result1_upvr_4.fromSignal(any_load_result1_result1_upvr_4.fromPromise(var141_upvw))
		return any_load_result1_result1_upvr_9.new(function(arg1_30) -- Line 821
			--[[ Upvalues[3]:
				[1]: any_load_result1_result1_upvr_6 (copied, readonly)
				[2]: any_fromSignal_result1_upvw (read and write)
				[3]: module_2_upvr (copied, readonly)
			]]
			local any_new_result1_2_upvr = any_load_result1_result1_upvr_6.new()
			any_new_result1_2_upvr:GiveTask(any_fromSignal_result1_upvw:Subscribe(function(arg1_31) -- Line 824
				--[[ Upvalues[4]:
					[1]: any_new_result1_2_upvr (readonly)
					[2]: arg1_30 (readonly)
					[3]: module_2_upvr (copied, readonly)
					[4]: any_load_result1_result1_upvr_6 (copied, readonly)
				]]
				if typeof(arg1_31) == "Instance" then
					any_new_result1_2_upvr:GiveTask(arg1_31)
					arg1_30:Fire(arg1_31)
				else
					local any__observeChildren_result1_3 = module_2_upvr._observeChildren(arg1_31)
					if any__observeChildren_result1_3 then
						local any_new_result1_5_upvr = any_load_result1_result1_upvr_6.new()
						any_new_result1_5_upvr:GiveTask(any__observeChildren_result1_3:Subscribe(function(arg1_32) -- Line 838
							--[[ Upvalues[1]:
								[1]: arg1_30 (copied, readonly)
							]]
							arg1_30:Fire(arg1_32)
						end, function(...) -- Line 840
							--[[ Upvalues[2]:
								[1]: any_new_result1_5_upvr (readonly)
								[2]: arg1_30 (copied, readonly)
							]]
							any_new_result1_5_upvr:DoCleaning()
							arg1_30:Fail(...)
						end, function() -- Line 843
							--[[ Upvalues[1]:
								[1]: any_new_result1_5_upvr (readonly)
							]]
							any_new_result1_5_upvr:DoCleaning()
						end))
						any_new_result1_5_upvr:GiveTask(function() -- Line 847
							--[[ Upvalues[2]:
								[1]: any_new_result1_2_upvr (copied, readonly)
								[2]: any_new_result1_5_upvr (readonly)
							]]
							any_new_result1_2_upvr[any_new_result1_5_upvr] = nil
						end)
						any_new_result1_2_upvr[any_new_result1_5_upvr] = any_new_result1_5_upvr
						return
					end
					any_new_result1_5_upvr = warn
					any_new_result1_5_upvr("Failed to convert %q into children":format(tostring(arg1_31)))
				end
			end, function(...) -- Line 854
				--[[ Upvalues[1]:
					[1]: arg1_30 (readonly)
				]]
				arg1_30:Fire(...)
			end, function() -- Line 856
			end))
			return any_new_result1_2_upvr
		end)
	end
	if type(any_fromSignal_result1_upvw) == "table" and not getmetatable(any_fromSignal_result1_upvw) then
		local module = {}
		for i_6, v_5 in pairs(any_fromSignal_result1_upvw) do
			local any__observeChildren_result1_2 = module_2_upvr._observeChildren(v_5)
			if any__observeChildren_result1_2 then
				table.insert(module, any__observeChildren_result1_2)
			else
				warn("Failed to convert [%s] %q into children":format(tostring(i_6), tostring(v_5)))
			end
		end
		if next(module) then
			return any_load_result1_result1_upvr_4.merge(module)
		end
		return nil
	end
	return nil
end
function module_2_upvr.mount(arg1, arg2) -- Line 902
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: module_2_upvr (readonly)
		[3]: any_load_result1_result1_upvr_9 (readonly)
	]]
	local any_new_result1_4 = any_load_result1_result1_upvr_6.new()
	local var183
	for i_7_upvr, v_6_upvr in pairs(arg2) do
		if type(i_7_upvr) == "string" then
			if i_7_upvr == "Parent" then
				var183 = v_6_upvr
			else
				local any_toPropertyObservable_result1 = module_2_upvr.toPropertyObservable(v_6_upvr)
				if any_toPropertyObservable_result1 then
					any_new_result1_4:GiveTask(any_toPropertyObservable_result1:Subscribe(function(arg1_33) -- Line 915
						--[[ Upvalues[2]:
							[1]: arg1 (readonly)
							[2]: i_7_upvr (readonly)
						]]
						task.spawn(function() -- Line 916
							--[[ Upvalues[3]:
								[1]: arg1 (copied, readonly)
								[2]: i_7_upvr (copied, readonly)
								[3]: arg1_33 (readonly)
							]]
							arg1[i_7_upvr] = arg1_33
						end)
					end))
				else
					task.spawn(function() -- Line 921
						--[[ Upvalues[3]:
							[1]: arg1 (readonly)
							[2]: i_7_upvr (readonly)
							[3]: v_6_upvr (readonly)
						]]
						arg1[i_7_upvr] = v_6_upvr
					end)
				end
			end
		elseif type(i_7_upvr) == "function" then
			local any_toEventObservable_result1 = module_2_upvr.toEventObservable(i_7_upvr(arg1, v_6_upvr))
			if any_load_result1_result1_upvr_9.isObservable(any_toEventObservable_result1) then
				table.insert({}, {any_toEventObservable_result1, v_6_upvr})
			else
				warn("Unable to apply event listener %q":format(tostring(i_7_upvr)))
			end
		else
			warn("Unable to apply property %q":format(tostring(i_7_upvr)))
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	for i_8, v_7 in pairs({}) do
		any_new_result1_4:GiveTask(v_7[1]:Subscribe(module_2_upvr.toEventHandler(v_7[2])))
	end
	if var183 then
		if module_2_upvr.toPropertyObservable(var183) then
			i_8 = module_2_upvr.toPropertyObservable(var183):Subscribe(function(arg1_34) -- Line 947
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1.Parent = arg1_34
			end)
			any_new_result1_4:GiveTask(i_8)
			return any_new_result1_4
		end
		arg1.Parent = var183
	end
	return any_new_result1_4
end
return module_2_upvr