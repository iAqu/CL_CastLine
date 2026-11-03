-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:29
-- Luau version 6, Types version 3
-- Time taken: 0.003118 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr_2.ClassName = "TiePropertyImplementation"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
function setmetatable_result1_upvr_2.new(arg1, arg2, arg3, arg4) -- Line 19
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._memberDefinition = assert(arg1, "No memberDefinition")
	setmetatable_result1_upvr._folder = assert(arg2, "No folder")
	setmetatable_result1_upvr._maid:GiveTask(function() -- Line 25
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		local any_GetMemberName_result1 = setmetatable_result1_upvr._memberDefinition:GetMemberName()
		local SOME_2 = setmetatable_result1_upvr._folder:FindFirstChild(any_GetMemberName_result1)
		setmetatable_result1_upvr._folder:SetAttribute(any_GetMemberName_result1, nil)
		if not SOME_2 then
		else
			SOME_2:Destroy()
		end
	end)
	setmetatable_result1_upvr:SetImplementation(arg3)
	return setmetatable_result1_upvr
end
local any_load_result1_result1_upvr_6 = any_load_result1("Maid")
function setmetatable_result1_upvr_2.SetImplementation(arg1, arg2) -- Line 43
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_6.new()
	arg1._maid._current = nil
	local var10
	if var10 == nil then
		var10 = arg1._memberDefinition:GetDefaultValue()
	end
	arg1:_updateImplementation(any_new_result1, var10)
	arg1._maid._current = any_new_result1
end
local any_load_result1_result1_upvr_7 = any_load_result1("TieUtils")
local any_load_result1_result1_upvr_2 = any_load_result1("ValueBaseUtils")
local any_load_result1_result1_upvr_4 = any_load_result1("AttributeUtils")
local any_load_result1_result1_upvr = any_load_result1("AttributeValue")
function setmetatable_result1_upvr_2._updateImplementation(arg1, arg2, arg3) -- Line 57
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_7 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
		[4]: any_load_result1_result1_upvr (readonly)
	]]
	if type(arg3) == "table" and arg3.Changed then
		local any__changeToClassIfNeeded_result1 = arg1:_changeToClassIfNeeded("BindableFunction", arg3)
		function any__changeToClassIfNeeded_result1.OnInvoke() -- Line 60
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr_7 (copied, readonly)
				[2]: arg3 (readonly)
			]]
			return any_load_result1_result1_upvr_7.encode(arg3)
		end
		any__changeToClassIfNeeded_result1.Parent = arg1._folder
	else
		if typeof(arg3) == "Instance" and arg3:IsA("ValueBase") then
			local any_getValueBaseType_result1 = any_load_result1_result1_upvr_2.getValueBaseType(arg3.ClassName)
			if any_getValueBaseType_result1 and any_load_result1_result1_upvr_4.isValidAttributeType(any_getValueBaseType_result1) and any_getValueBaseType_result1 ~= "nil" then
				arg1:_removeClassIfNeeded()
				arg1:_syncMember(arg2, any_load_result1_result1_upvr.new(arg1._folder, arg1._memberDefinition:GetMemberName()), arg3)
			else
				local any__changeToClassIfNeeded_result1_3 = arg1:_changeToClassIfNeeded(arg3.ClassName, arg3)
				arg1:_syncMember(arg2, any__changeToClassIfNeeded_result1_3, arg3)
				any__changeToClassIfNeeded_result1_3.Parent = arg1._folder
			end
		end
		if any_load_result1_result1_upvr_4.isValidAttributeType(typeof(arg3)) and arg3 ~= nil then
			arg1:_removeClassIfNeeded()
			arg1._folder:SetAttribute(arg1._memberDefinition:GetMemberName(), arg3)
			return
		end
		local any_getClassNameFromType_result1 = any_load_result1_result1_upvr_2.getClassNameFromType(typeof(arg3))
		if not any_getClassNameFromType_result1 then
			error("[TiePropertyImplementation] - Bad implementation value type %q, cannot set":format(typeof(arg3)))
		end
		local any__changeToClassIfNeeded_result1_2 = arg1:_changeToClassIfNeeded(any_getClassNameFromType_result1, arg3)
		any__changeToClassIfNeeded_result1_2.Value = arg3
		any__changeToClassIfNeeded_result1_2.Parent = arg1._folder
	end
end
local any_load_result1_result1_upvr_5 = any_load_result1("TiePropertyImplementationUtils")
function setmetatable_result1_upvr_2._changeToClassIfNeeded(arg1, arg2) -- Line 94
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	return any_load_result1_result1_upvr_5.changeToClassIfNeeded(arg1._memberDefinition, arg1._folder, arg2)
end
function setmetatable_result1_upvr_2._removeClassIfNeeded(arg1) -- Line 98
	local SOME = arg1._folder:FindFirstChild(arg1._memberDefinition:GetMemberName())
	if SOME then
		SOME:Destroy()
	end
end
function setmetatable_result1_upvr_2._syncMember(arg1, arg2, arg3, arg4) -- Line 105
	arg3.Value = arg4.Value
	arg2:GiveTask(arg4.Changed:Connect(function() -- Line 108
		--[[ Upvalues[2]:
			[1]: arg3 (readonly)
			[2]: arg4 (readonly)
		]]
		arg3.Value = arg4.Value
	end))
	arg2:GiveTask(arg3.Changed:Connect(function() -- Line 112
		--[[ Upvalues[2]:
			[1]: arg4 (readonly)
			[2]: arg3 (readonly)
		]]
		arg4.Value = arg3.Value
	end))
end
return setmetatable_result1_upvr_2