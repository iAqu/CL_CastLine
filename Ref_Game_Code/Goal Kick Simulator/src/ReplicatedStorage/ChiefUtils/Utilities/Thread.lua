-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:48
-- Luau version 6, Types version 3
-- Time taken: 0.008004 seconds

local module_3 = {}
local Heartbeat_upvr = game:GetService("RunService").Heartbeat
module_3.Heartbeat = Heartbeat_upvr
function module_3.SpawnConnection(arg1, ...) -- Line 7
	--[[ Upvalues[1]:
		[1]: Heartbeat_upvr (readonly)
	]]
	local var4_upvw
	local packed_4_upvr = table.pack(...)
	var4_upvw = Heartbeat_upvr:Connect(function() -- Line 10
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: var4_upvw (read and write)
			[3]: packed_4_upvr (readonly)
		]]
		if arg1(var4_upvw, unpack(packed_4_upvr)) then
			var4_upvw:Disconnect()
		end
	end)
	return var4_upvw
end
function module_3.SpawnConnectionTimer(arg1, arg2, ...) -- Line 17
	--[[ Upvalues[1]:
		[1]: Heartbeat_upvr (readonly)
	]]
	local tick_result1_2_upvr = tick()
	local var8_upvw
	local packed_5_upvr = table.pack(...)
	var8_upvw = Heartbeat_upvr:Connect(function() -- Line 21
		--[[ Upvalues[5]:
			[1]: tick_result1_2_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: var8_upvw (read and write)
			[4]: arg2 (readonly)
			[5]: packed_5_upvr (readonly)
		]]
		local var10 = (tick() - tick_result1_2_upvr) / arg1
		if 1 < var10 then
			var8_upvw:Disconnect()
		end
		if arg2(math.min(1, var10), unpack(packed_5_upvr)) then
			var8_upvw:Disconnect()
		end
	end)
	return var8_upvw
end
function module_3.Delay(arg1, arg2, ...) -- Line 30
	local var11_upvw = false
	local packed_3_upvr = table.pack(...)
	task.delay(arg1, function() -- Line 33
		--[[ Upvalues[3]:
			[1]: var11_upvw (read and write)
			[2]: arg2 (readonly)
			[3]: packed_3_upvr (readonly)
		]]
		if var11_upvw then
		else
			arg2(table.unpack(packed_3_upvr, 1, packed_3_upvr.n))
		end
	end)
	local module_4 = {}
	local function Disconnect() -- Line 40
		--[[ Upvalues[1]:
			[1]: var11_upvw (read and write)
		]]
		var11_upvw = true
	end
	module_4.Disconnect = Disconnect
	return module_4
end
function module_3.Every(arg1, arg2, ...) -- Line 46
	--[[ Upvalues[1]:
		[1]: Heartbeat_upvr (readonly)
	]]
	local var16_upvw = 0
	local packed_6_upvr = table.pack(...)
	return Heartbeat_upvr:Connect(function() -- Line 50
		--[[ Upvalues[4]:
			[1]: var16_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: packed_6_upvr (readonly)
		]]
		if var16_upvw <= os.clock() then
			var16_upvw = os.clock() + arg1
			arg2(table.unpack(packed_6_upvr, 1, packed_6_upvr.n))
		end
	end)
end
function module_3.Condition(arg1, arg2, ...) -- Line 59
	local packed = table.pack(...)
	local tick_result1 = tick()
	while not (tick() < tick_result1 + arg1 or arg2(table.unpack(packed, 1, packed.n)) ~= true) do
		task.wait()
	end
	return tick() - tick_result1
end
function module_3.Loop(arg1) -- Line 69
	--[[ Upvalues[1]:
		[1]: Heartbeat_upvr (readonly)
	]]
	local var20_upvw = 0
	local var22_upvw = true
	local module_2 = {}
	local any_Connect_result1_upvw_2 = Heartbeat_upvr:Connect(function(arg1_2) -- Line 73
		--[[ Upvalues[3]:
			[1]: var20_upvw (read and write)
			[2]: var22_upvw (read and write)
			[3]: arg1 (readonly)
		]]
		var20_upvw += arg1_2
		if var22_upvw then
			var22_upvw = false
			var20_upvw = 0
			arg1(arg1_2, var20_upvw)
			var22_upvw = true
		end
	end)
	local function Disconnect() -- Line 84
		--[[ Upvalues[1]:
			[1]: any_Connect_result1_upvw_2 (read and write)
		]]
		any_Connect_result1_upvw_2:Disconnect()
	end
	module_2.Disconnect = Disconnect
	local function Skip(arg1_3, arg2) -- Line 87
		--[[ Upvalues[1]:
			[1]: var20_upvw (read and write)
		]]
		var20_upvw += arg2
	end
	module_2.Skip = Skip
	return module_2
end
function module_3.LoopFor(arg1, arg2) -- Line 93
	--[[ Upvalues[1]:
		[1]: Heartbeat_upvr (readonly)
	]]
	local var25_upvw = 0
	local tbl_2_upvr = {}
	local var28_upvw = true
	local var29_upvw = 0
	local var30_upvw
	var30_upvw = Heartbeat_upvr:Connect(function(arg1_4) -- Line 100
		--[[ Upvalues[7]:
			[1]: var25_upvw (read and write)
			[2]: var28_upvw (read and write)
			[3]: var29_upvw (read and write)
			[4]: arg1 (readonly)
			[5]: arg2 (readonly)
			[6]: var30_upvw (read and write)
			[7]: tbl_2_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		var25_upvw += arg1_4
		if var28_upvw then
			var28_upvw = false
			local var39 = var25_upvw
			var25_upvw = 0
			var29_upvw = math.clamp(var29_upvw + var39, 0, arg1)
			local var40 = var29_upvw / arg1
			arg2(var40, var39, arg1_4)
			if var29_upvw == arg1 then
				var30_upvw:Disconnect()
				for _, v in pairs(tbl_2_upvr) do
					v(true, var40)
					local _
				end
				return
			end
			var28_upvw = true
		end
	end)
	local module_5 = {}
	local function Disconnect() -- Line 121
		--[[ Upvalues[2]:
			[1]: var30_upvw (read and write)
			[2]: tbl_2_upvr (readonly)
		]]
		var30_upvw:Disconnect()
		for _, v_2 in pairs(tbl_2_upvr) do
			v_2(false)
		end
	end
	module_5.Disconnect = Disconnect
	local tbl = {}
	local function Wait(arg1_5) -- Line 127
		local var52_upvw = false
		arg1_5:Connect(function() -- Line 129
			--[[ Upvalues[1]:
				[1]: var52_upvw (read and write)
			]]
			var52_upvw = true
		end)
		while not var52_upvw do
			task.wait()
		end
		return arg1_5
	end
	tbl.Wait = Wait
	local function Connect(arg1_6, arg2_2) -- Line 135
		--[[ Upvalues[1]:
			[1]: tbl_2_upvr (readonly)
		]]
		tbl_2_upvr[#tbl_2_upvr + 1] = arg2_2
		return arg1_6
	end
	tbl.Connect = Connect
	module_5.Ended = tbl
	local function Skip(arg1_7, arg2_3) -- Line 140
		--[[ Upvalues[1]:
			[1]: var25_upvw (read and write)
		]]
		var25_upvw += arg2_3
	end
	module_5.Skip = Skip
	return module_5
end
function module_3.RepeatLoopFor(arg1, arg2) -- Line 145
	--[[ Upvalues[1]:
		[1]: Heartbeat_upvr (readonly)
	]]
	local var54_upvw = 0
	local tbl_4_upvr = {}
	local var57_upvw = true
	local var58_upvw = 0
	local module = {}
	local any_Connect_result1_upvw = Heartbeat_upvr:Connect(function(arg1_8) -- Line 152
		--[[ Upvalues[6]:
			[1]: var54_upvw (read and write)
			[2]: var57_upvw (read and write)
			[3]: var58_upvw (read and write)
			[4]: arg1 (readonly)
			[5]: arg2 (readonly)
			[6]: tbl_4_upvr (readonly)
		]]
		var54_upvw += arg1_8
		if var57_upvw then
			var57_upvw = false
			local var61 = var54_upvw
			var54_upvw = 0
			var58_upvw = math.clamp(var58_upvw + var61, 0, arg1)
			arg2(var58_upvw / arg1, var61, arg1_8)
			if var58_upvw == arg1 then
				for _, v_3 in pairs(tbl_4_upvr) do
					v_3(true)
				end
				var58_upvw = 0
				var57_upvw = true
				return
			end
			var57_upvw = true
		end
	end)
	function module.Disconnect() -- Line 173
		--[[ Upvalues[2]:
			[1]: any_Connect_result1_upvw (read and write)
			[2]: tbl_4_upvr (readonly)
		]]
		any_Connect_result1_upvw:Disconnect()
		for _, v_4 in pairs(tbl_4_upvr) do
			v_4(false)
		end
	end
	local tbl_3 = {}
	local function Wait(arg1_9) -- Line 179
		local var73_upvw = false
		arg1_9:Connect(function() -- Line 181
			--[[ Upvalues[1]:
				[1]: var73_upvw (read and write)
			]]
			var73_upvw = true
		end)
		while not var73_upvw do
			task.wait()
		end
		return arg1_9
	end
	tbl_3.Wait = Wait
	function tbl_3.Connect(arg1_10, arg2_4) -- Line 187
		--[[ Upvalues[1]:
			[1]: tbl_4_upvr (readonly)
		]]
		tbl_4_upvr[#tbl_4_upvr + 1] = arg2_4
		return arg1_10
	end
	module.Ended = tbl_3
	function module.Skip(arg1_11, arg2_5) -- Line 192
		--[[ Upvalues[1]:
			[1]: var54_upvw (read and write)
		]]
		var54_upvw += arg2_5
	end
	return module
end
function module_3.Run(arg1) -- Line 197
	--[[ Upvalues[1]:
		[1]: Heartbeat_upvr (readonly)
	]]
	local var75_upvr = arg1
	if var75_upvr then
		var75_upvr = arg1.Runner
	end
	assert(var75_upvr, "First argument is not valid / missing Runner function")
	local var77_upvw = 0
	local var78_upvr = arg1.Time or 1
	local var79_upvw = true
	local var80_upvw
	var80_upvw = Heartbeat_upvr:Connect(function(arg1_12) -- Line 204
		--[[ Upvalues[6]:
			[1]: var77_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: var78_upvr (readonly)
			[4]: var79_upvw (read and write)
			[5]: var80_upvw (read and write)
			[6]: var75_upvr (readonly)
		]]
		var77_upvw = math.clamp(var77_upvw + arg1_12 * (arg1.Speed or 1), 0, var78_upvr)
		if var79_upvw then
			var79_upvw = false
			if var77_upvw == var78_upvr then
				var80_upvw:Disconnect()
			end
			var75_upvr(arg1_12, var77_upvw / var78_upvr)
			var79_upvw = true
		end
	end)
	local function Destroy(arg1_13) -- Line 217
		--[[ Upvalues[1]:
			[1]: var80_upvw (read and write)
		]]
		var80_upvw:Disconnect()
	end
	arg1.Destroy = Destroy
	return arg1
end
function module_3.WaitDelay(arg1, arg2, ...) -- Line 223
	local var81_upvw = true
	local packed_2_upvr = table.pack(...)
	coroutine.wrap(function() -- Line 226
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: var81_upvw (read and write)
			[3]: arg2 (readonly)
			[4]: packed_2_upvr (readonly)
		]]
		wait(arg1)
		if not var81_upvw then
		else
			coroutine.wrap(arg2)(table.unpack(packed_2_upvr, 1, packed_2_upvr.n))
		end
	end)()
	return {
		Destroy = function() -- Line 232, Named "Destroy"
			--[[ Upvalues[1]:
				[1]: var81_upvw (read and write)
			]]
			var81_upvw = false
		end;
	}
end
function module_3.Coro(arg1, ...) -- Line 237
	return coroutine.wrap(arg1)(...)
end
function module_3.Wait(arg1) -- Line 241
	return task.wait(arg1)
end
return module_3