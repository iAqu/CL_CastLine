-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:02
-- Luau version 6, Types version 3
-- Time taken: 0.006115 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1 = any_load_result1("InputModeTypes")
local any_load_result1_result1_upvr = any_load_result1("Maid")
local module_upvr = {
	ClassName = "InputModeTypeSelector";
	DEFAULT_MODE_TYPES = {any_load_result1_result1.Gamepads, any_load_result1_result1.Keyboard, any_load_result1_result1.Touch};
}
local any_load_result1_result1_upvr_2 = any_load_result1("ServiceBag")
local any_load_result1_result1_3_upvr = any_load_result1("InputModeServiceClient")
local any_load_result1_result1_2_upvr = any_load_result1("ValueObject")
function module_upvr.new(arg1, arg2) -- Line 29
	--[[ Upvalues[5]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_3_upvr (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
		[5]: any_load_result1_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	assert(any_load_result1_result1_upvr_2.isServiceBag(arg1), "Bad serviceBag")
	setmetatable_result1._serviceBag = assert(arg1, "No serviceBag")
	setmetatable_result1._inputModeServiceClient = setmetatable_result1._serviceBag:GetService(any_load_result1_result1_3_upvr)
	setmetatable_result1._maid = any_load_result1_result1_upvr.new()
	setmetatable_result1._inputModeTypeList = {}
	setmetatable_result1._activeModeType = any_load_result1_result1_2_upvr.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._activeModeType)
	setmetatable_result1.Changed = setmetatable_result1._activeModeType.Changed
	local var14 = arg2
	if not var14 then
		var14 = module_upvr.DEFAULT_MODE_TYPES
	end
	for _, v in pairs(var14) do
		setmetatable_result1:AddInputModeType(v)
	end
	return setmetatable_result1
end
function module_upvr.fromObservableBrio(arg1, arg2) -- Line 67
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local any_new_result1_3_upvr = module_upvr.new(arg1, {})
	any_new_result1_3_upvr._maid:GiveTask(arg2:Subscribe(function(arg1_2) -- Line 70
		--[[ Upvalues[1]:
			[1]: any_new_result1_3_upvr (readonly)
		]]
		if arg1_2:IsDead() then
		else
			local any_GetValue_result1_upvr = arg1_2:GetValue()
			any_new_result1_3_upvr:AddInputModeType(any_GetValue_result1_upvr)
			arg1_2:ToMaid():GiveTask(function() -- Line 79
				--[[ Upvalues[2]:
					[1]: any_new_result1_3_upvr (copied, readonly)
					[2]: any_GetValue_result1_upvr (readonly)
				]]
				if any_new_result1_3_upvr.Destroy then
					any_new_result1_3_upvr:RemoveInputModeType(any_GetValue_result1_upvr)
				end
			end)
		end
	end))
	return any_new_result1_3_upvr
end
function module_upvr.GetActiveInputType(arg1) -- Line 93
	return rawget(arg1, "_activeModeType").Value
end
function module_upvr.ObserveActiveInputType(arg1) -- Line 101
	return rawget(arg1, "_activeModeType"):Observe()
end
function module_upvr.__index(arg1, arg2) -- Line 110
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if arg2 == "Value" then
		return rawget(arg1, "_activeModeType").Value
	end
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	local rawget_result1 = rawget(arg1, arg2)
	if rawget_result1 then
		return rawget_result1
	end
	error("[InputModeTypeSelector] - Bad index '%s'":format(tostring(arg2)))
end
function module_upvr.Bind(arg1, arg2) -- Line 149
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local any_new_result1_7_upvr = any_load_result1_result1_upvr.new()
	arg1._maid[arg2] = any_new_result1_7_upvr
	any_new_result1_7_upvr:GiveTask(arg1._activeModeType.Changed:Connect(function(arg1_4, arg2_3) -- Line 153, Named "onChange"
		--[[ Upvalues[3]:
			[1]: any_new_result1_7_upvr (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: arg2 (readonly)
		]]
		any_new_result1_7_upvr._modeMaid = nil
		if arg1_4 then
			local any_new_result1 = any_load_result1_result1_upvr.new()
			any_new_result1_7_upvr._modeMaid = any_new_result1
			if arg1_4 then
				arg2(arg1_4, any_new_result1)
			end
		end
	end))
	local Value_2 = arg1._activeModeType.Value
	any_new_result1_7_upvr._modeMaid = nil
	if Value_2 then
		local any_new_result1_4 = any_load_result1_result1_upvr.new()
		any_new_result1_7_upvr._modeMaid = any_new_result1_4
		if Value_2 then
			arg2(Value_2, any_new_result1_4)
		end
	end
	return arg1
end
function module_upvr.RemoveInputModeType(arg1, arg2) -- Line 176
	if not arg1._maid[arg2] then
	else
		local table_find_result1 = table.find(arg1._inputModeTypeList, arg2)
		if table_find_result1 then
			table.remove(arg1._inputModeTypeList, table_find_result1)
		else
			warn("[InputModeTypeSelector] - Failed to find inputModeType")
		end
		arg1._maid[arg2] = nil
		if arg1._activeModeType.Value == arg2 then
			arg1:_pickNewInputMode()
		end
	end
end
function module_upvr.AddInputModeType(arg1, arg2) -- Line 199
	if arg1._maid[arg2] then
	else
		table.insert(arg1._inputModeTypeList, arg2)
		local any_GetInputMode_result1 = arg1._inputModeServiceClient:GetInputMode(arg2)
		arg1._maid[arg2] = any_GetInputMode_result1.Enabled:Connect(function() -- Line 206
			--[[ Upvalues[2]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
			]]
			arg1._activeModeType.Value = arg2
		end)
		if not arg1._activeModeType.Value or arg1._inputModeServiceClient:GetInputMode(arg1._activeModeType.Value):GetLastEnabledTime() < any_GetInputMode_result1:GetLastEnabledTime() then
			arg1._activeModeType.Value = arg2
		end
	end
end
function module_upvr._pickNewInputMode(arg1) -- Line 216
	local var42
	for _, v_2 in pairs(arg1._inputModeTypeList) do
		if (-math.huge) <= arg1._inputModeServiceClient:GetInputMode(v_2):GetLastEnabledTime() then
		end
	end
	arg1._activeModeType.Value = nil
end
function module_upvr.Destroy(arg1) -- Line 237
	arg1._maid:DoCleaning()
	setmetatable(arg1, nil)
end
return module_upvr