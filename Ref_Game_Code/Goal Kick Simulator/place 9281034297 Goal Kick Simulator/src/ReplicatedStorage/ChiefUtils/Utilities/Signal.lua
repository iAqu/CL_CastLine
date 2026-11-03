-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:41
-- Luau version 6, Types version 3
-- Time taken: 0.006163 seconds

local module_4 = {}
local tbl_upvr_4 = {}
tbl_upvr_4.__index = tbl_upvr_4
local function CopyTable_upvr(arg1) -- Line 8, Named "CopyTable"
	--[[ Upvalues[1]:
		[1]: CopyTable_upvr (readonly)
	]]
	local var7
	if type(arg1) ~= "table" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "First argument must be a table")
	var7 = #arg1
	var7 = pairs(arg1)
	for i, v in pairs(arg1) do
		if type(v) == "table" then
			table.create(var7)[i] = CopyTable_upvr(v)
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			table.create(var7)[i] = v
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return table.create(var7)
end
function module_4.new() -- Line 21
	--[[ Upvalues[1]:
		[1]: tbl_upvr_4 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable({
		__Events = {};
		__CoreEvents = {};
		__Destroyed = false;
	}, tbl_upvr_4)
	setmetatable_result1_upvr.Event = setmetatable({}, {
		__index = function(arg1, arg2) -- Line 24, Named "__index"
			--[[ Upvalues[1]:
				[1]: setmetatable_result1_upvr (readonly)
			]]
			if arg2 == "Connect" then
				return function(arg1_2, arg2_2) -- Line 26
					--[[ Upvalues[1]:
						[1]: setmetatable_result1_upvr (copied, readonly)
					]]
					return setmetatable_result1_upvr:Connect(arg2_2)
				end
			end
			error("Unrecognized event")
		end;
		__call = function(arg1, arg2) -- Line 30, Named "__call"
			return arg1:Connect(arg2)
		end;
		__newindex = error;
	})
	return setmetatable_result1_upvr
end
function tbl_upvr_4.Sync(arg1, arg2, ...) -- Line 38
	if typeof(arg2) ~= "function" then
		return error("event must be a function, got:"..typeof(arg2))
	end
	if arg1.__Destroyed then return end
	local __Events_upvr_2 = arg1.__Events
	local tbl_upvr_3 = {}
	tbl_upvr_3.Event = arg2
	table.insert(__Events_upvr_2, tbl_upvr_3)
	local module_2 = {}
	local function Disconnect(arg1_3) -- Line 46
		--[[ Upvalues[2]:
			[1]: __Events_upvr_2 (readonly)
			[2]: tbl_upvr_3 (readonly)
		]]
		for i_2, v_2 in pairs(__Events_upvr_2) do
			if v_2 == tbl_upvr_3 then
				table.remove(__Events_upvr_2, i_2)
				return
			end
		end
	end
	module_2.Disconnect = Disconnect
	module_2.Destroy = module_2.Disconnect
	arg2(...)
	return module_2
end
function tbl_upvr_4.Connect(arg1, arg2) -- Line 59
	if typeof(arg2) ~= "function" then
		return error("event must be a function, got:"..typeof(arg2))
	end
	if arg1.__Destroyed then return end
	local __Events_upvr_3 = arg1.__Events
	local tbl_upvr_2 = {}
	tbl_upvr_2.Event = arg2
	table.insert(__Events_upvr_3, tbl_upvr_2)
	local module_3 = {}
	local function Disconnect(arg1_4) -- Line 67
		--[[ Upvalues[2]:
			[1]: __Events_upvr_3 (readonly)
			[2]: tbl_upvr_2 (readonly)
		]]
		for i_3, v_3 in pairs(__Events_upvr_3) do
			if v_3 == tbl_upvr_2 then
				table.remove(__Events_upvr_3, i_3)
				return
			end
		end
	end
	module_3.Disconnect = Disconnect
	module_3.Destroy = module_3.Disconnect
	return module_3
end
function tbl_upvr_4._Connect(arg1, arg2) -- Line 79
	if typeof(arg2) ~= "function" then
		return error("event must be a function")
	end
	if arg1.__Destroyed then return end
	local __CoreEvents_upvr = arg1.__CoreEvents
	local tbl_upvr = {}
	tbl_upvr.Event = arg2
	table.insert(__CoreEvents_upvr, tbl_upvr)
	local module = {}
	local function Disconnect(arg1_5) -- Line 87
		--[[ Upvalues[2]:
			[1]: __CoreEvents_upvr (readonly)
			[2]: tbl_upvr (readonly)
		]]
		for i_4, v_4 in pairs(__CoreEvents_upvr) do
			if v_4 == tbl_upvr then
				table.remove(__CoreEvents_upvr, i_4)
				return
			end
		end
	end
	module.Disconnect = Disconnect
	module.Destroy = module.Disconnect
	return module
end
function tbl_upvr_4.On(arg1, arg2, arg3) -- Line 99
	if typeof(arg3) ~= "function" then
		return error("event must be a function")
	end
	if arg1.__Destroyed then return end
	local __Events_upvr = arg1.__Events
	local tbl_upvr_5 = {}
	tbl_upvr_5.Event = arg3
	tbl_upvr_5.Result = arg2
	__Events_upvr[#__Events_upvr + 1] = tbl_upvr_5
	local module_5 = {
		Disconnect = function(arg1_6) -- Line 107, Named "Disconnect"
			--[[ Upvalues[2]:
				[1]: __Events_upvr (readonly)
				[2]: tbl_upvr_5 (readonly)
			]]
			for i_5, v_5 in pairs(__Events_upvr) do
				if v_5 == tbl_upvr_5 then
					table.remove(__Events_upvr, i_5)
					return
				end
			end
		end;
		Destroy = module_5.Disconnect;
	}
	return module_5
end
function tbl_upvr_4.Fire(arg1, ...) -- Line 119
	--[[ Upvalues[1]:
		[1]: CopyTable_upvr (readonly)
	]]
	if arg1.__Destroyed then return end
	local args_list = {...}
	for _, v_6 in pairs({arg1.__Events, arg1.__CoreEvents}) do
		for _, v_7 in pairs(CopyTable_upvr(v_6)) do
			if v_7.Result == nil then
				table.insert({}, table.pack(v_7.Event(unpack({...}))))
			elseif v_7.Result == table.remove(args_list, 1) then
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				table.insert({}, table.pack(v_7.Event(unpack(args_list))))
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function tbl_upvr_4.Destroy(arg1) -- Line 143
	arg1.__Destroyed = true
end
function tbl_upvr_4.Wait(arg1) -- Line 147
	--[[ Upvalues[1]:
		[1]: tbl_upvr_4 (readonly)
	]]
	local var61_upvw
	local module_upvw = {}
	local time_result1_upvr = time()
	arg1:Connect(function(...) -- Line 151
		--[[ Upvalues[3]:
			[1]: var61_upvw (read and write)
			[2]: time_result1_upvr (readonly)
			[3]: module_upvw (read and write)
		]]
		var61_upvw = time() - time_result1_upvr
		module_upvw = {...}
	end)
	repeat
		task.wait()
	until var61_upvw and tbl_upvr_4.__Destroyed
	return var61_upvw, unpack(module_upvw)
end
return module_4