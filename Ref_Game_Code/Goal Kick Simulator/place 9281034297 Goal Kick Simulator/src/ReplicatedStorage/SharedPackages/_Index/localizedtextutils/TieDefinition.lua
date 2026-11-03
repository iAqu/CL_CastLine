-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:09
-- Luau version 6, Types version 3
-- Time taken: 0.010128 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_4 = any_load_result1("Rx")
local var1_result1_upvr_7 = any_load_result1("RxBrioUtils")
local var1_result1_upvr_4 = any_load_result1("RxInstanceUtils")
local var1_result1 = any_load_result1("Symbol")
local any_load_result1_result1_upvr = any_load_result1("TieInterface")
local module_upvr = {
	ClassName = "TieDefinition";
}
module_upvr.__index = module_upvr
module_upvr.Types = any_load_result1("Table").readonly({
	METHOD = var1_result1.named("method");
	SIGNAL = var1_result1.named("signal");
	PROPERTY = var1_result1.named("property");
})
local any_load_result1_result1_upvr_2 = any_load_result1("TieMethodDefinition")
local var1_result1_upvr_5 = any_load_result1("TieSignalDefinition")
local var1_result1_upvr_8 = any_load_result1("TiePropertyDefinition")
function module_upvr.new(arg1, arg2, arg3) -- Line 37
	--[[ Upvalues[4]:
		[1]: module_upvr (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: var1_result1_upvr_5 (readonly)
		[4]: var1_result1_upvr_8 (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1._definitionName = assert(arg1, "No definitionName")
	setmetatable_result1._memberMap = {}
	setmetatable_result1._isSharedDefinition = arg3
	for i, v in pairs(arg2) do
		local var20
		if type(i) ~= "string" then
			var20 = false
		else
			var20 = true
		end
		assert(var20, "Bad memberName")
		var20 = module_upvr.Types
		if v == var20.METHOD then
			var20 = any_load_result1_result1_upvr_2.new(setmetatable_result1, i)
			setmetatable_result1._memberMap[i] = var20
		else
			var20 = module_upvr.Types
			if v == var20.SIGNAL then
				var20 = var1_result1_upvr_5.new(setmetatable_result1, i)
				setmetatable_result1._memberMap[i] = var20
			else
				var20 = module_upvr.Types
				if v == var20.PROPERTY then
					var20 = var1_result1_upvr_8.new(setmetatable_result1, i, nil)
					setmetatable_result1._memberMap[i] = var20
				else
					var20 = var1_result1_upvr_8.new(setmetatable_result1, i, v)
					setmetatable_result1._memberMap[i] = var20
				end
			end
		end
	end
	return setmetatable_result1
end
function module_upvr.GetImplementations(arg1, arg2) -- Line 67
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var25
	if typeof(arg2) ~= "Instance" then
		var25 = false
	else
		var25 = true
	end
	assert(var25, "Bad adornee")
	var25 = arg1:GetContainerName()
	for _, v_2 in pairs(arg2:GetChildren()) do
		if v_2.Name == var25 and arg1:IsImplementation(v_2) then
			table.insert({}, any_load_result1_result1_upvr.new(arg1, v_2, nil))
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function module_upvr.FindFirstImplementation(arg1, arg2) -- Line 89
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var33
	if typeof(arg2) ~= "Instance" then
		var33 = false
	else
		var33 = true
	end
	assert(var33, "Bad adornee")
	var33 = pairs(arg2:GetChildren())
	local pairs_result1, pairs_result2, pairs_result3_6 = pairs(arg2:GetChildren())
	for _, v_3 in pairs_result1, pairs_result2, pairs_result3_6 do
		if v_3.Name == arg1:GetContainerName() and arg1:IsImplementation(v_3) then
			return any_load_result1_result1_upvr.new(arg1, v_3, nil)
		end
	end
	pairs_result1 = nil
	return pairs_result1
end
function module_upvr.HasImplementation(arg1, arg2) -- Line 109
	local var37
	if typeof(arg2) ~= "Instance" then
		var37 = false
	else
		var37 = true
	end
	assert(var37, "Bad adornee")
	local SOME = arg2:FindFirstChild(arg1:GetContainerName())
	if not SOME then
		var37 = false
		return var37
	end
	var37 = arg1:IsImplementation(SOME)
	return var37
end
function module_upvr.ObserveIsImplemented(arg1, arg2) -- Line 125
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var39
	if typeof(arg2) ~= "Instance" then
		var39 = false
	else
		var39 = true
	end
	assert(var39, "Bad adornee")
	return arg1:ObserveLastImplementationBrio(arg2):Pipe({var1_result1_upvr_7.map(function(arg1_2) -- Line 130
		if arg1_2 then
			return true
		end
		return false
	end), var1_result1_upvr_7.emitOnDeath(false), any_load_result1_result1_upvr_4.defaultsTo(false), any_load_result1_result1_upvr_4.distinct()})
end
function module_upvr.ObserveIsImplementation(arg1, arg2) -- Line 144
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_7 (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
	]]
	return arg1:_observeImplementation(arg2):Pipe({var1_result1_upvr_7.map(function(arg1_3) -- Line 147
		if arg1_3 then
			return true
		end
		return false
	end), var1_result1_upvr_7.emitOnDeath(false), any_load_result1_result1_upvr_4.defaultsTo(false), any_load_result1_result1_upvr_4.distinct()})
end
function module_upvr.ObserveIsImplementedOn(arg1, arg2, arg3) -- Line 162
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_7 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var44
	if typeof(arg2) ~= "Instance" then
		var44 = false
	else
		var44 = true
	end
	assert(var44, "Bad folder")
	if typeof(arg3) ~= "Instance" then
		var44 = false
	else
		var44 = true
	end
	assert(var44, "Bad adornee")
	var44 = var1_result1_upvr_4
	var44 = arg2
	return var44.observePropertyBrio(var44, "Parent", function(arg1_4) -- Line 166
		--[[ Upvalues[1]:
			[1]: arg3 (readonly)
		]]
		local var46
		if arg1_4 ~= arg3 then
			var46 = false
		else
			var46 = true
		end
		return var46
	end):Pipe({var1_result1_upvr_7.switchMapBrio(function() -- Line 169
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		return arg1:_observeImplementation(arg2)
	end), var1_result1_upvr_7.map(function(arg1_5) -- Line 172
		if arg1_5 then
			return true
		end
		return false
	end), var1_result1_upvr_7.emitOnDeath(false), any_load_result1_result1_upvr_4.defaultsTo(false), any_load_result1_result1_upvr_4.distinct()})
end
function module_upvr.ObserveLastImplementationBrio(arg1, arg2) -- Line 186
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_7 (readonly)
	]]
	local var50
	if typeof(arg2) ~= "Instance" then
		var50 = false
	else
		var50 = true
	end
	assert(var50, "Bad adornee")
	var50 = var1_result1_upvr_4
	var50 = arg2
	return var50.observeLastNamedChildBrio(var50, "Folder", arg1:GetContainerName()):Pipe({var1_result1_upvr_7.switchMapBrio(function(arg1_6) -- Line 191
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:_observeImplementation(arg1_6)
	end), var1_result1_upvr_7.onlyLastBrioSurvives()})
end
function module_upvr.ObserveImplementationsBrio(arg1, arg2) -- Line 203
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_7 (readonly)
	]]
	local var53
	if typeof(arg2) ~= "Instance" then
		var53 = false
	else
		var53 = true
	end
	assert(var53, "Bad adornee")
	var53 = var1_result1_upvr_4
	var53 = arg2
	return var53.observeChildrenOfNameBrio(var53, "Folder", arg1:GetContainerName()):Pipe({var1_result1_upvr_7.flatMapBrio(function(arg1_7) -- Line 208
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1:_observeImplementation(arg1_7)
	end)})
end
local any_load_result1_result1_upvr_3 = any_load_result1("Observable")
local any_load_result1_result1_upvr_5 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("ValueObject")
local any_named_result1_upvr = var1_result1.named("unsetValue")
local var1_result1_upvr_2 = any_load_result1("Brio")
function module_upvr._observeImplementation(arg1, arg2) -- Line 214
	--[[ Upvalues[6]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr_5 (readonly)
		[3]: var1_result1_upvr (readonly)
		[4]: any_named_result1_upvr (readonly)
		[5]: var1_result1_upvr_2 (readonly)
		[6]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr_3.new(function(arg1_8) -- Line 215
		--[[ Upvalues[7]:
			[1]: any_load_result1_result1_upvr_5 (copied, readonly)
			[2]: var1_result1_upvr (copied, readonly)
			[3]: any_named_result1_upvr (copied, readonly)
			[4]: var1_result1_upvr_2 (copied, readonly)
			[5]: any_load_result1_result1_upvr (copied, readonly)
			[6]: arg1 (readonly)
			[7]: arg2 (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local any_new_result1_2_upvr = any_load_result1_result1_upvr_5.new()
		local any_new_result1_upvr = var1_result1_upvr.new(any_named_result1_upvr)
		any_new_result1_2_upvr:GiveTask(any_new_result1_upvr)
		any_new_result1_2_upvr:GiveTask(any_new_result1_upvr.Changed:Connect(function() -- Line 226
			--[[ Upvalues[7]:
				[1]: any_new_result1_2_upvr (readonly)
				[2]: any_new_result1_upvr (readonly)
				[3]: var1_result1_upvr_2 (copied, readonly)
				[4]: any_load_result1_result1_upvr (copied, readonly)
				[5]: arg1 (copied, readonly)
				[6]: arg2 (copied, readonly)
				[7]: arg1_8 (readonly)
			]]
			any_new_result1_2_upvr._brio = nil
			if any_new_result1_upvr.Value then
				local any_new_result1 = var1_result1_upvr_2.new(any_load_result1_result1_upvr.new(arg1, arg2, nil))
				arg1_8:Fire(any_new_result1)
				any_new_result1_2_upvr._brio = any_new_result1
			else
				any_new_result1_2_upvr._brio = nil
			end
		end))
		local function update_upvw() -- Line 238, Named "update"
			--[[ Upvalues[3]:
				[1]: any_new_result1_upvr (readonly)
				[2]: arg1 (copied, readonly)
				[3]: arg2 (copied, readonly)
			]]
			any_new_result1_upvr.Value = arg1:IsImplementation(arg2)
		end
		any_new_result1_upvr = any_new_result1_2_upvr:GiveTask
		any_new_result1_upvr(arg2.ChildAdded:Connect(function(arg1_9) -- Line 243
			--[[ Upvalues[2]:
				[1]: any_new_result1_2_upvr (readonly)
				[2]: update_upvw (read and write)
			]]
			any_new_result1_2_upvr[arg1_9] = arg1_9:GetPropertyChangedSignal("Name"):Connect(update_upvw)
			update_upvw()
		end))
		any_new_result1_upvr = pairs(arg1._memberMap)
		local pairs_result1_2, pairs_result2_4, pairs_result3_5 = pairs(arg1._memberMap)
		for i_4, v_4 in pairs_result1_2, pairs_result2_4, pairs_result3_5 do
			if v_4.ClassName == "TiePropertyDefinition" then
				any_new_result1_2_upvr:GiveTask(arg2:GetAttributeChangedSignal(i_4):Connect(update_upvw))
			end
		end
		pairs_result1_2 = any_new_result1_2_upvr:GiveTask
		pairs_result1_2(arg2.ChildRemoved:Connect(function(arg1_10) -- Line 254
			--[[ Upvalues[2]:
				[1]: any_new_result1_2_upvr (readonly)
				[2]: update_upvw (read and write)
			]]
			any_new_result1_2_upvr[arg1_10] = nil
			update_upvw()
		end))
		pairs_result1_2 = pairs(arg2:GetChildren())
		local pairs_result1_6, pairs_result2_5, pairs_result3_4 = pairs(arg2:GetChildren())
		for _, v_5 in pairs_result1_6, pairs_result2_5, pairs_result3_4 do
			any_new_result1_2_upvr[v_5] = v_5:GetPropertyChangedSignal("Name"):Connect(update_upvw)
		end
		pairs_result1_6 = update_upvw
		pairs_result1_6()
		return any_new_result1_2_upvr
	end)
end
local var1_result1_upvr_3 = any_load_result1("TieImplementation")
function module_upvr.Implement(arg1, arg2, arg3) -- Line 281
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_3 (readonly)
	]]
	local var91
	if typeof(arg2) ~= "Instance" then
		var91 = false
	else
		var91 = true
	end
	assert(var91, "Bad adornee")
	var91 = true
	if type(arg3) ~= "table" then
		if arg3 ~= nil then
			var91 = false
		else
			var91 = true
		end
	end
	assert(var91, "Bad implementer")
	var91 = var1_result1_upvr_3
	var91 = arg1
	return var91.new(var91, arg2, arg3)
end
function module_upvr.Get(arg1, arg2) -- Line 297
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	local var92
	if typeof(arg2) ~= "Instance" then
		var92 = false
	else
		var92 = true
	end
	assert(var92, "Bad adornee")
	var92 = any_load_result1_result1_upvr
	var92 = arg1
	return var92.new(var92, nil, arg2)
end
function module_upvr.GetName(arg1) -- Line 307
	return arg1._definitionName
end
local RunService_upvr = game:GetService("RunService")
function module_upvr.GetContainerName(arg1) -- Line 311
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if RunService_upvr:IsClient() and not arg1._isSharedDefinition then
		return arg1._definitionName.."Client"
	end
	return arg1._definitionName
end
function module_upvr.GetMemberMap(arg1) -- Line 319
	return arg1._memberMap
end
local var1_result1_upvr_6 = any_load_result1("String")
function module_upvr.IsImplementation(arg1, arg2) -- Line 323
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_6 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 32 start (CF ANALYSIS FAILED)
	local tbl = {}
	for _, v_6 in pairs(arg2:GetChildren()) do
		tbl[v_6.Name] = v_6
	end
	local pairs_result1_3, pairs_result2_3, pairs_result3 = pairs(arg1._memberMap)
	-- KONSTANTERROR: [0] 1. Error Block 32 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [85] 63. Error Block 24 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [85] 63. Error Block 24 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [23] 16. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	-- KONSTANTERROR: [23] 16. Error Block 4 end (CF ANALYSIS FAILED)
end
return module_upvr