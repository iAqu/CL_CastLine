-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:45
-- Luau version 6, Types version 3
-- Time taken: 0.003003 seconds

local module = {}
local Maid_upvr = require(script.Parent.Maid)
local tbl_upvr = {}
tbl_upvr.__index = tbl_upvr
local function Destroy(arg1) -- Line 38
	arg1.Maid:Destroy()
end
tbl_upvr.Destroy = Destroy
local Signal_upvr = require(script.Parent.Signal)
function module.newState(arg1) -- Line 42
	--[[ Upvalues[3]:
		[1]: tbl_upvr (readonly)
		[2]: Signal_upvr (readonly)
		[3]: Maid_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, tbl_upvr)
	for i, v in pairs(arg1) do
		setmetatable_result1[i] = v
	end
	setmetatable_result1.Removed = Signal_upvr.new()
	setmetatable_result1.Maid = Maid_upvr.new()
	return setmetatable_result1
end
local tbl_upvr_2 = {}
tbl_upvr_2.__index = tbl_upvr_2
function module.new() -- Line 58
	--[[ Upvalues[2]:
		[1]: tbl_upvr_2 (readonly)
		[2]: Maid_upvr (readonly)
	]]
	local setmetatable_result1_2 = setmetatable({}, tbl_upvr_2)
	setmetatable_result1_2.Active = true
	setmetatable_result1_2.States = {}
	setmetatable_result1_2.Maid = Maid_upvr.new()
	return setmetatable_result1_2
end
function tbl_upvr_2.AddStack(arg1, arg2, arg3) -- Line 67
	local clamped = math.clamp(arg3 or 1, 1, #arg1.States + 1)
	table.insert(arg1.States, clamped, arg2)
	local var16
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var16 = arg2.Run(arg1)
		return var16
	end
	if not arg2.Run or not INLINED() then
		var16 = nil
	end
	arg2.Maid.RunState = var16
	if clamped == 1 then
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var16 = arg2.Focus(arg1)
			return var16
		end
		if not arg2.Focus or not INLINED_2() then
			var16 = nil
		end
		arg1.Maid.FocusState = var16
	end
end
function tbl_upvr_2.Clear(arg1) -- Line 77
	while next(arg1.States) do
		table.remove(arg1.States):Destroy()
	end
	arg1.Maid.FocusState = nil
	arg1.Maid.RunState = nil
end
function tbl_upvr_2.RemoveStack(arg1, arg2) -- Line 86
	for i_2, v_2 in pairs(arg1.States) do
		if v_2 == arg2 then
			table.remove(arg1.States, i_2)
			v_2:Destroy()
			local var24
			if i_2 == 1 then
				local _1 = arg1.States[1]
				local function INLINED_3() -- Internal function, doesn't exist in bytecode
					var24 = _1.Focus()
					return var24
				end
				if not _1 or not _1.Focus or not INLINED_3() then
					var24 = nil
				end
				arg1.Maid.FocusState = var24
			end
			return
		end
	end
end
function tbl_upvr_2.Destroy(arg1) -- Line 102
	arg1.Active = nil
	arg1.Maid:Destroy()
	repeat
		local popped = table.remove(arg1.States, 1)
		if popped then
			popped:Destroy()
		end
	until not popped
	arg1.States = nil
end
return module