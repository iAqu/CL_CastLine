-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:58
-- Luau version 6, Types version 3
-- Time taken: 0.006422 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_7 = any_load_result1("BaseObject")
local var1_result1_upvr_2 = any_load_result1("InputKeyMap")
local var1_result1_upvr = any_load_result1("InputModeType")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_7)
setmetatable_result1_upvr.ClassName = "InputKeyMapList"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_2 = any_load_result1("ObservableMap")
function setmetatable_result1_upvr.new(arg1, arg2, arg3) -- Line 69
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_7.new(), setmetatable_result1_upvr)
	setmetatable_result1._inputKeyMapListName = assert(arg1, "No inputMapName")
	setmetatable_result1._options = assert(arg3, "No options")
	setmetatable_result1._inputModeTypeToInputKeyMap = any_load_result1_result1_upvr_2.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1._inputModeTypeToInputKeyMap)
	for _, v in pairs(arg2) do
		setmetatable_result1:Add(v)
	end
	return setmetatable_result1
end
function setmetatable_result1_upvr.isInputKeyMapList(arg1) -- Line 91
	--[[ Upvalues[1]:
		[1]: setmetatable_result1_upvr (readonly)
	]]
	local var15 = false
	if type(arg1) == "table" then
		if getmetatable(arg1) ~= setmetatable_result1_upvr then
			var15 = false
		else
			var15 = true
		end
	end
	return var15
end
function setmetatable_result1_upvr.IsUserRebindable(arg1) -- Line 99
	local var16
	if arg1._options.rebindable ~= true then
		var16 = false
	else
		var16 = true
	end
	return var16
end
function setmetatable_result1_upvr.GetBindingName(arg1) -- Line 107
	return arg1._options.bindingName
end
local any_load_result1_result1_upvr_4 = any_load_result1("String")
function setmetatable_result1_upvr.GetBindingTranslationKey(arg1) -- Line 111
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	return "keybinds."..any_load_result1_result1_upvr_4.toCamelCase(arg1._inputKeyMapListName)
end
function setmetatable_result1_upvr.Add(arg1, arg2) -- Line 119
	assert(arg2, "Bad inputKeyMap")
	arg1._maid[arg2:GetInputModeType()] = arg2
	arg1._inputModeTypeToInputKeyMap:Set(arg2:GetInputModeType(), arg2)
end
function setmetatable_result1_upvr.GetListName(arg1) -- Line 130
	return arg1._inputKeyMapListName
end
function setmetatable_result1_upvr.SetInputTypesList(arg1, arg2, arg3) -- Line 134
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	assert(var1_result1_upvr.isInputModeType(arg2), "Bad inputModeType")
	local var18 = true
	if type(arg3) ~= "table" then
		if arg3 ~= nil then
			var18 = false
		else
			var18 = true
		end
	end
	assert(var18, "Bad inputTypes")
	if arg3 == nil then
		arg1._inputModeTypeToInputKeyMap:Remove(arg2)
		arg1._maid[arg2] = nil
	else
		local any_Get_result1_3 = arg1._inputModeTypeToInputKeyMap:Get(arg2)
		if not any_Get_result1_3 then
			arg1:Add(var1_result1_upvr_2.new(arg2, arg3))
			return
		end
		any_Get_result1_3:SetInputTypesList(arg3)
	end
end
function setmetatable_result1_upvr.SetDefaultInputTypesList(arg1, arg2, arg3) -- Line 151
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_2 (readonly)
	]]
	assert(var1_result1_upvr.isInputModeType(arg2), "Bad inputModeType")
	local var20 = true
	if type(arg3) ~= "table" then
		if arg3 ~= nil then
			var20 = false
		else
			var20 = true
		end
	end
	assert(var20, "Bad inputTypes")
	if arg3 == nil then
		arg1._inputModeTypeToInputKeyMap:Remove(arg2)
		arg1._maid[arg2] = nil
	else
		local any_Get_result1_4 = arg1._inputModeTypeToInputKeyMap:Get(arg2)
		if not any_Get_result1_4 then
			arg1:Add(var1_result1_upvr_2.new(arg2, arg3))
			return
		end
		any_Get_result1_4:SetDefaultInputTypesList(arg3)
	end
end
function setmetatable_result1_upvr.GetInputTypesList(arg1, arg2) -- Line 168
	local any_Get_result1 = arg1._inputModeTypeToInputKeyMap:Get(arg2)
	if any_Get_result1 then
		return any_Get_result1:GetInputTypesList()
	end
	return {}
end
function setmetatable_result1_upvr.GetDefaultInputTypesList(arg1, arg2) -- Line 177
	local any_Get_result1_2 = arg1._inputModeTypeToInputKeyMap:Get(arg2)
	if any_Get_result1_2 then
		return any_Get_result1_2:GetDefaultInputTypesList()
	end
	return {}
end
function setmetatable_result1_upvr.ObservePairsBrio(arg1) -- Line 190
	return arg1._inputModeTypeToInputKeyMap:ObservePairsBrio()
end
function setmetatable_result1_upvr.RestoreDefault(arg1) -- Line 197
	for _, v_2 in pairs(arg1._inputModeTypeToInputKeyMap:GetValueList()) do
		v_2:RestoreDefault()
	end
end
function setmetatable_result1_upvr.RemoveInputModeType(arg1, arg2) -- Line 208
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	assert(var1_result1_upvr.isInputModeType(arg2), "Bad inputModeType")
	arg1:SetInputTypesList(arg2, nil)
end
function setmetatable_result1_upvr.ObserveInputKeyMapsBrio(arg1) -- Line 217
	return arg1._inputModeTypeToInputKeyMap:ObserveValuesBrio()
end
function setmetatable_result1_upvr.ObserveInputModesTypesBrio(arg1) -- Line 224
	return arg1._inputModeTypeToInputKeyMap:ObserveKeysBrio()
end
function setmetatable_result1_upvr.ObserveInputKeyMapForInputMode(arg1, arg2) -- Line 234
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	assert(var1_result1_upvr.isInputModeType(arg2), "Bad inputModeType")
	return arg1._inputModeTypeToInputKeyMap:ObserveValueForKey(arg2)
end
function setmetatable_result1_upvr.ObserveIsTapInWorld(arg1) -- Line 245
	arg1:_ensureInit()
	return arg1._isTapInWorld:Observe()
end
function setmetatable_result1_upvr.ObserveIsRobloxTouchButton(arg1) -- Line 256
	arg1:_ensureInit()
	return arg1._isRobloxTouchButton:Observe()
end
function setmetatable_result1_upvr.IsRobloxTouchButton(arg1) -- Line 267
	arg1:_ensureInit()
	return arg1._isRobloxTouchButton:GetState()
end
function setmetatable_result1_upvr.IsTouchTapInWorld(arg1) -- Line 278
	arg1:_ensureInit()
	return arg1._isTapInWorld:GetState()
end
function setmetatable_result1_upvr.ObserveInputEnumsList(arg1) -- Line 289
	arg1:_ensureInit()
	return arg1._inputTypesForBinding:ObserveKeysList()
end
function setmetatable_result1_upvr.ObserveInputEnumsSet(arg1) -- Line 300
	arg1:_ensureInit()
	return arg1._inputTypesForBinding:ObserveKeysSet()
end
local var1_result1_upvr_5 = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr_6 = any_load_result1("Rx")
local var1_result1_upvr_3 = any_load_result1("SlottedTouchButtonUtils")
local any_load_result1_result1_upvr_8 = any_load_result1("Brio")
function setmetatable_result1_upvr.ObserveSlottedTouchButtonDataBrio(arg1) -- Line 311
	--[[ Upvalues[4]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: any_load_result1_result1_upvr_6 (readonly)
		[3]: var1_result1_upvr_3 (readonly)
		[4]: any_load_result1_result1_upvr_8 (readonly)
	]]
	return arg1._inputModeTypeToInputKeyMap:ObservePairsBrio():Pipe({var1_result1_upvr_5.flatMapBrio(function(arg1_2, arg2) -- Line 313
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_6 (copied, readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
			[3]: any_load_result1_result1_upvr_8 (copied, readonly)
		]]
		return arg2:ObserveInputTypesList():Pipe({any_load_result1_result1_upvr_6.switchMap(function(arg1_3) -- Line 315
			--[[ Upvalues[4]:
				[1]: var1_result1_upvr_3 (copied, readonly)
				[2]: arg1_2 (readonly)
				[3]: any_load_result1_result1_upvr_8 (copied, readonly)
				[4]: any_load_result1_result1_upvr_6 (copied, readonly)
			]]
			local module = {}
			for _, v_3 in pairs(arg1_3) do
				if var1_result1_upvr_3.isSlottedTouchButton(v_3) then
					table.insert(module, any_load_result1_result1_upvr_8.new(var1_result1_upvr_3.createTouchButtonData(v_3.slotId, arg1_2)))
				end
			end
			if not next(module) then
				return any_load_result1_result1_upvr_6.EMPTY
			end
			return any_load_result1_result1_upvr_6.of(unpack(module))
		end)})
	end)})
end
local any_load_result1_result1_upvr_5 = any_load_result1("ObservableCountingMap")
local any_load_result1_result1_upvr_3 = any_load_result1("StateStack")
local any_load_result1_result1_upvr = any_load_result1("Maid")
local var1_result1_upvr_4 = any_load_result1("InputTypeUtils")
function setmetatable_result1_upvr._ensureInit(arg1) -- Line 335
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
		[2]: any_load_result1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_4 (readonly)
	]]
	if arg1._inputTypesForBinding then
		return arg1._inputTypesForBinding
	end
	arg1._inputTypesForBinding = any_load_result1_result1_upvr_5.new()
	arg1._maid:GiveTask(arg1._inputTypesForBinding)
	arg1._isTapInWorld = any_load_result1_result1_upvr_3.new(false)
	arg1._maid:GiveTask(arg1._isTapInWorld)
	arg1._isRobloxTouchButton = any_load_result1_result1_upvr_3.new(false)
	arg1._maid:GiveTask(arg1._isRobloxTouchButton)
	arg1._maid:GiveTask(arg1._inputModeTypeToInputKeyMap:ObserveValuesBrio():Subscribe(function(arg1_4) -- Line 350
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr (copied, readonly)
			[2]: arg1 (readonly)
			[3]: var1_result1_upvr_4 (copied, readonly)
		]]
		if arg1_4:IsDead() then
		else
			local any_ToMaid_result1_upvr = arg1_4:ToMaid()
			any_ToMaid_result1_upvr:GiveTask(arg1_4:GetValue():ObserveInputTypesList():Subscribe(function(arg1_5) -- Line 358
				--[[ Upvalues[4]:
					[1]: any_load_result1_result1_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
					[3]: var1_result1_upvr_4 (copied, readonly)
					[4]: any_ToMaid_result1_upvr (readonly)
				]]
				for _, v_4 in pairs(arg1_5) do
					if typeof(v_4) == "EnumItem" then
						any_load_result1_result1_upvr.new():GiveTask(arg1._inputTypesForBinding:Add(v_4))
					elseif var1_result1_upvr_4.isTapInWorld(v_4) then
						any_load_result1_result1_upvr.new():GiveTask(arg1._isTapInWorld:PushState(true))
					elseif var1_result1_upvr_4.isRobloxTouchButton(v_4) then
						any_load_result1_result1_upvr.new():GiveTask(arg1._isRobloxTouchButton:PushState(true))
					end
				end
				any_ToMaid_result1_upvr._current = any_load_result1_result1_upvr.new()
			end))
		end
	end))
	return arg1._inputTypesForBinding
end
return setmetatable_result1_upvr