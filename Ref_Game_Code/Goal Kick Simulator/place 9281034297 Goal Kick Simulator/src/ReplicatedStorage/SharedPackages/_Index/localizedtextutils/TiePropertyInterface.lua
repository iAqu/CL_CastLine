-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:11
-- Luau version 6, Types version 3
-- Time taken: 0.009218 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local var1_result1_upvr_9 = any_load_result1("Maid")
local var1_result1_upvr_3 = any_load_result1("Observable")
local var1_result1_upvr = any_load_result1("String")
local var1_result1_upvr_4 = any_load_result1("TieInterfaceUtils")
local var1_result1_upvr_13 = any_load_result1("TieUtils")
local module_upvr = {
	ClassName = "TiePropertyInterface";
}
module_upvr.__index = module_upvr
function module_upvr.new(arg1, arg2, arg3) -- Line 29
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	assert(arg1 or arg2, "Folder or adornee required")
	setmetatable_result1._folder = arg1
	setmetatable_result1._adornee = arg2
	setmetatable_result1._memberDefinition = assert(arg3, "No memberDefinition")
	setmetatable_result1._tieDefinition = setmetatable_result1._memberDefinition:GetTieDefinition()
	return setmetatable_result1
end
local var1_result1_upvr_8 = any_load_result1("Rx")
function module_upvr.Observe(arg1) -- Line 42
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_8 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: var1_result1_upvr_9 (readonly)
	]]
	return arg1:_observeValueBaseBrio():Pipe({var1_result1_upvr_8.switchMap(function(arg1_2) -- Line 44
		--[[ Upvalues[3]:
			[1]: var1_result1_upvr_8 (copied, readonly)
			[2]: var1_result1_upvr_3 (copied, readonly)
			[3]: var1_result1_upvr_9 (copied, readonly)
		]]
		if arg1_2:IsDead() then
			return var1_result1_upvr_8.of(nil)
		end
		local any_GetValue_result1_upvr_2 = arg1_2:GetValue()
		if not any_GetValue_result1_upvr_2 then
			return var1_result1_upvr_8.of(nil)
		end
		return var1_result1_upvr_3.new(function(arg1_3) -- Line 53
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_9 (copied, readonly)
				[2]: any_GetValue_result1_upvr_2 (readonly)
				[3]: arg1_2 (readonly)
			]]
			local any_new_result1_3 = var1_result1_upvr_9.new()
			arg1_3:Fire(any_GetValue_result1_upvr_2.Value)
			any_new_result1_3:GiveTask(any_GetValue_result1_upvr_2.Changed:Connect(function() -- Line 57
				--[[ Upvalues[2]:
					[1]: arg1_3 (readonly)
					[2]: any_GetValue_result1_upvr_2 (copied, readonly)
				]]
				arg1_3:Fire(any_GetValue_result1_upvr_2.Value)
			end))
			any_new_result1_3:GiveTask(arg1_2:GetDiedSignal():Connect(function() -- Line 61
				--[[ Upvalues[1]:
					[1]: arg1_3 (readonly)
				]]
				if arg1_3:IsPending() then
					arg1_3:Fire(nil)
				end
			end))
			return any_new_result1_3
		end)
	end), var1_result1_upvr_8.distinct()})
end
function module_upvr._getFolder(arg1) -- Line 74
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	return var1_result1_upvr_4.getFolder(arg1._tieDefinition, arg1._folder, arg1._adornee)
end
function module_upvr._getValueBase(arg1) -- Line 78
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_13 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	local any__getFolder_result1_3 = arg1:_getFolder()
	if not any__getFolder_result1_3 then
		return nil
	end
	local SOME_2 = any__getFolder_result1_3:FindFirstChild(arg1._memberDefinition:GetMemberName())
	if not SOME_2 then
		return nil
	end
	if SOME_2:IsA("BindableFunction") then
		return var1_result1_upvr_13.decode(SOME_2:Invoke())
	end
	if var1_result1_upvr.endsWith(SOME_2.ClassName, "Value") then
		return SOME_2
	end
	return nil
end
function module_upvr._getValueBaseOrError(arg1) -- Line 99
	local any__getValueBase_result1_2 = arg1:_getValueBase()
	if not any__getValueBase_result1_2 then
		error("%s.%s is not implemented for %s":format(arg1._tieDefinition:GetContainerName(), arg1._memberDefinition:GetMemberName(), arg1:_getFullName()))
	end
	return any__getValueBase_result1_2
end
function module_upvr._getFullName(arg1) -- Line 110
	if arg1._folder then
		return arg1._folder:GetFullName()
	end
	if arg1._adornee then
		return arg1._adornee:GetFullName()
	end
	error("[TiePropertyInterface] - Either folder or adornee should be defined")
end
local var1_result1_upvr_11 = any_load_result1("TiePropertyChangedSignalConnection")
local any_load_result1_result1_upvr = any_load_result1("ValueObject")
function module_upvr._getChangedEvent(arg1) -- Line 120
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_11 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
	]]
	return {
		Connect = function(arg1_4, arg2) -- Line 122, Named "Connect"
			--[[ Upvalues[3]:
				[1]: var1_result1_upvr_11 (copied, readonly)
				[2]: any_load_result1_result1_upvr (copied, readonly)
				[3]: arg1 (readonly)
			]]
			local var24
			if type(arg2) ~= "function" then
				var24 = false
			else
				var24 = true
			end
			assert(var24, "Bad callback")
			var24 = var1_result1_upvr_11
			function var24(arg1_5) -- Line 124
				--[[ Upvalues[3]:
					[1]: any_load_result1_result1_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
					[3]: arg2 (readonly)
				]]
				local any_new_result1_2_upvr = any_load_result1_result1_upvr.new(nil)
				arg1_5:GiveTask(any_new_result1_2_upvr)
				arg1_5:GiveTask(arg1:Observe():Subscribe(function(arg1_6) -- Line 128
					--[[ Upvalues[1]:
						[1]: any_new_result1_2_upvr (readonly)
					]]
					any_new_result1_2_upvr.Value = arg1_6
				end))
				arg1_5:GiveTask(any_new_result1_2_upvr.Changed:Connect(arg2))
			end
			return var24.new(var24)
		end;
	}
end
local tbl_upvr_2 = {
	attribute = "attribute";
	none = "none";
}
local any_named_result1_upvw = any_load_result1("Symbol").named("unsetValue")
local var1_result1_upvr_6 = any_load_result1("AttributeValue")
local var1_result1_upvr_12 = any_load_result1("RxInstanceUtils")
function module_upvr._observeFromFolder(arg1, arg2) -- Line 144
	--[[ Upvalues[8]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr_9 (readonly)
		[3]: any_named_result1_upvw (readonly)
		[4]: tbl_upvr_2 (readonly)
		[5]: var1_result1_upvr_6 (readonly)
		[6]: var1_result1_upvr_13 (readonly)
		[7]: var1_result1_upvr (readonly)
		[8]: var1_result1_upvr_12 (readonly)
	]]
	return var1_result1_upvr_3.new(function(arg1_7) -- Line 145
		--[[ Upvalues[9]:
			[1]: arg1 (readonly)
			[2]: var1_result1_upvr_9 (copied, readonly)
			[3]: any_named_result1_upvw (copied, readonly)
			[4]: arg2 (readonly)
			[5]: tbl_upvr_2 (copied, readonly)
			[6]: var1_result1_upvr_6 (copied, readonly)
			[7]: var1_result1_upvr_13 (copied, readonly)
			[8]: var1_result1_upvr (copied, readonly)
			[9]: var1_result1_upvr_12 (copied, readonly)
		]]
		local any_GetMemberName_result1_upvr = arg1._memberDefinition:GetMemberName()
		local any_new_result1 = var1_result1_upvr_9.new()
		local tbl_upvr = {}
		local function update_upvr() -- Line 153, Named "update"
			--[[ Upvalues[9]:
				[1]: arg2 (copied, readonly)
				[2]: any_GetMemberName_result1_upvr (readonly)
				[3]: any_named_result1_upvw (read and write)
				[4]: tbl_upvr_2 (copied, readonly)
				[5]: arg1_7 (readonly)
				[6]: var1_result1_upvr_6 (copied, readonly)
				[7]: tbl_upvr (readonly)
				[8]: var1_result1_upvr_13 (copied, readonly)
				[9]: var1_result1_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 35 start (CF ANALYSIS FAILED)
			local var35
			if arg2:GetAttribute(any_GetMemberName_result1_upvr) ~= nil then
				var35 = tbl_upvr_2.attribute
				if any_named_result1_upvw ~= var35 then
					var35 = tbl_upvr_2
					any_named_result1_upvw = var35.attribute
					arg1_7:Fire(var1_result1_upvr_6.new(arg2, any_GetMemberName_result1_upvr))
				end
			else
				var35 = tbl_upvr
				local _1 = var35[1]
				if not _1 then
					var35 = any_named_result1_upvw
					if var35 ~= tbl_upvr_2.none then
						var35 = tbl_upvr_2.none
						any_named_result1_upvw = var35
						var35 = arg1_7:Fire
						var35(nil)
					end
					return
				end
				var35 = nil
				if _1:IsA("BindableFunction") then
					var35 = var1_result1_upvr_13.decode(_1:Invoke())
					-- KONSTANTWARNING: GOTO [88] #69
				end
				-- KONSTANTERROR: [0] 1. Error Block 35 end (CF ANALYSIS FAILED)
				-- KONSTANTERROR: [62] 49. Error Block 36 start (CF ANALYSIS FAILED)
				if var1_result1_upvr.endsWith(_1.ClassName, "Value") then
					var35 = _1
				else
					if any_named_result1_upvw ~= tbl_upvr_2.none then
						any_named_result1_upvw = tbl_upvr_2.none
						arg1_7:Fire(nil)
					end
					return
				end
				if any_named_result1_upvw ~= var35 then
					any_named_result1_upvw = var35
					arg1_7:Fire(var35)
				end
				-- KONSTANTERROR: [62] 49. Error Block 36 end (CF ANALYSIS FAILED)
			end
		end
		any_new_result1:GiveTask(var1_result1_upvr_12.observeChildrenOfNameBrio(arg2, "Instance", arg1._memberDefinition:GetMemberName()):Subscribe(function(arg1_8) -- Line 197
			--[[ Upvalues[2]:
				[1]: tbl_upvr (readonly)
				[2]: update_upvr (readonly)
			]]
			if arg1_8:IsDead() then
			else
				local any_GetValue_result1_upvr = arg1_8:GetValue()
				arg1_8:ToMaid():GiveTask(function() -- Line 205
					--[[ Upvalues[3]:
						[1]: tbl_upvr (copied, readonly)
						[2]: any_GetValue_result1_upvr (readonly)
						[3]: update_upvr (copied, readonly)
					]]
					local table_find_result1 = table.find(tbl_upvr, any_GetValue_result1_upvr)
					if table_find_result1 then
						table.remove(tbl_upvr, table_find_result1)
					end
					update_upvr()
				end)
				table.insert(tbl_upvr, any_GetValue_result1_upvr)
				update_upvr()
			end
		end))
		any_new_result1:GiveTask(arg2:GetAttributeChangedSignal(any_GetMemberName_result1_upvr):Connect(update_upvr))
		update_upvr()
		return any_new_result1
	end)
end
local var1_result1_upvr_10 = any_load_result1("RxBrioUtils")
function module_upvr._observeValueBaseBrio(arg1) -- Line 226
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_10 (readonly)
	]]
	return arg1:_observeFolderBrio():Pipe({var1_result1_upvr_10.switchMapBrio(function(arg1_9) -- Line 228
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:_observeFromFolder(arg1_9)
	end), var1_result1_upvr_10.onlyLastBrioSurvives()})
end
function module_upvr._observeFolderBrio(arg1) -- Line 235
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_4 (readonly)
	]]
	return var1_result1_upvr_4.observeFolderBrio(arg1._tieDefinition, arg1._folder, arg1._adornee)
end
function module_upvr.__index(arg1, arg2) -- Line 239
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	if module_upvr[arg2] then
		return module_upvr[arg2]
	end
	if arg2 == "Value" then
		local any__getFolder_result1_2 = arg1:_getFolder()
		if any__getFolder_result1_2 then
			local attribute = any__getFolder_result1_2:GetAttribute(arg1._memberDefinition:GetMemberName())
			if attribute ~= nil then
				return attribute
			end
		end
		return arg1:_getValueBaseOrError().Value
	end
	if arg2 == "Changed" then
		return arg1:_getChangedEvent()
	end
	if arg2 == "_adornee" or arg2 == "_folder" or arg2 == "_memberDefinition" or arg2 == "_tieDefinition" then
		return rawget(arg1, arg2)
	end
	error("Bad index %q for TiePropertyInterface":format(tostring(arg2)))
end
local var1_result1_upvr_5 = any_load_result1("AttributeUtils")
local var1_result1_upvr_2 = any_load_result1("ValueBaseUtils")
local var1_result1_upvr_7 = any_load_result1("TiePropertyImplementationUtils")
function module_upvr.__newindex(arg1, arg2, arg3) -- Line 262
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_5 (readonly)
		[2]: var1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_7 (readonly)
	]]
	if arg2 == "_adornee" or arg2 == "_folder" or arg2 == "_memberDefinition" or arg2 == "_tieDefinition" then
		rawset(arg1, arg2, arg3)
	else
		if arg2 == "Value" then
			if var1_result1_upvr_5.isValidAttributeType(typeof(arg3)) and arg3 ~= nil then
				local any__getFolder_result1_6 = arg1:_getFolder()
				if any__getFolder_result1_6 then
					any__getFolder_result1_6:SetAttribute(arg1._memberDefinition:GetMemberName(), arg3)
					local SOME = any__getFolder_result1_6:FindFirstChild(arg1._memberDefinition:GetMemberName())
					if SOME then
						SOME:Destroy()
					end
					return
				end
			end
			local any_getClassNameFromType_result1 = var1_result1_upvr_2.getClassNameFromType(typeof(arg3))
			if not any_getClassNameFromType_result1 then
				error("[TiePropertyImplementation] - Bad implementation value type %q, cannot set":format(typeof(arg3)))
			end
			local any__getValueBase_result1 = arg1:_getValueBase()
			if any__getValueBase_result1 and any__getValueBase_result1.ClassName == any_getClassNameFromType_result1 then
				any__getValueBase_result1.Value = arg3
			else
				local any__getFolder_result1_4 = arg1:_getFolder()
				if any__getFolder_result1_4 then
					local any_changeToClassIfNeeded_result1 = var1_result1_upvr_7.changeToClassIfNeeded(arg1._memberDefinition, any__getFolder_result1_4, any_getClassNameFromType_result1)
					any_changeToClassIfNeeded_result1.Value = arg3
					any_changeToClassIfNeeded_result1.Parent = any__getFolder_result1_4
					return
				end
				error("[TiePropertyImplementation] - No folder for %q":format(arg1._memberDefinition:GetMemberName()))
			end
		end
		if arg2 == "Changed" then
			error("Cannot assign %q for TiePropertyInterface":format(tostring(arg2)))
			return
		end
		error("Bad index %q for TiePropertyInterface":format(tostring(arg2)))
	end
end
return module_upvr