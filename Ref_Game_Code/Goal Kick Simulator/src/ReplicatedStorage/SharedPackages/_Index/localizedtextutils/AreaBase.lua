-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:58
-- Luau version 6, Types version 3
-- Time taken: 0.008598 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local var1_result1_upvr_3 = any_load_result1("BoundingBoxUtils")
local var1_result1_upvr = any_load_result1("CompiledBoundingBoxUtils")
local var1_result1_upvr_5 = any_load_result1("Maid")
local setmetatable_result1_upvr_2 = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr_2.ClassName = "AreaBase"
setmetatable_result1_upvr_2.__index = setmetatable_result1_upvr_2
local any_load_result1_result1_upvr_4 = any_load_result1("ObservableList")
local any_load_result1_result1_upvr_3 = any_load_result1("Signal")
local any_load_result1_result1_upvr = any_load_result1("AreaInterface")
function setmetatable_result1_upvr_2.new(arg1) -- Line 22
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
		[5]: any_load_result1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr = setmetatable(any_load_result1_result1_upvr_2.new(arg1), setmetatable_result1_upvr_2)
	setmetatable_result1_upvr._humanoids = any_load_result1_result1_upvr_4.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._humanoids)
	setmetatable_result1_upvr._players = any_load_result1_result1_upvr_4.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr._players)
	setmetatable_result1_upvr.HumanoidEntered = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.HumanoidEntered)
	setmetatable_result1_upvr.HumanoidExited = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.HumanoidExited)
	setmetatable_result1_upvr.PlayerEntered = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.PlayerEntered)
	setmetatable_result1_upvr.PlayerExited = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr._maid:GiveTask(setmetatable_result1_upvr.PlayerExited)
	setmetatable_result1_upvr.HumanoidCount = setmetatable_result1_upvr._humanoids:GetCountValue()
	setmetatable_result1_upvr.PlayerCount = setmetatable_result1_upvr._players:GetCountValue()
	setmetatable_result1_upvr.Removing = any_load_result1_result1_upvr_3.new()
	setmetatable_result1_upvr._maid:GiveTask(function() -- Line 47
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		setmetatable_result1_upvr.Removing:Fire()
		setmetatable_result1_upvr.Removing:Destroy()
	end)
	setmetatable_result1_upvr._maid:GiveTask(any_load_result1_result1_upvr:Implement(setmetatable_result1_upvr._obj, setmetatable_result1_upvr))
	setmetatable_result1_upvr:_setupInformation()
	return setmetatable_result1_upvr
end
function setmetatable_result1_upvr_2.GetObject(arg1) -- Line 59
	return arg1._obj
end
function setmetatable_result1_upvr_2.FireActivate(arg1, arg2) -- Line 63
	local any_GetActivator_result1 = arg2:GetActivator()
	local any_GetPlayer_result1 = any_GetActivator_result1:GetPlayer()
	local any_GetObject_result1 = any_GetActivator_result1:GetObject()
	arg1.HumanoidEntered:Fire(any_GetObject_result1, any_GetPlayer_result1)
	arg1._humanoids:Add(any_GetObject_result1)
	if any_GetPlayer_result1 then
		arg1._players:Add(any_GetPlayer_result1)
		arg1.PlayerEntered:Fire(any_GetPlayer_result1, any_GetObject_result1)
	end
end
function setmetatable_result1_upvr_2.FireDeactivate(arg1, arg2) -- Line 77
	local any_GetActivator_result1_2 = arg2:GetActivator()
	local any_GetPlayer_result1_2 = any_GetActivator_result1_2:GetPlayer()
	local any_GetObject_result1_2 = any_GetActivator_result1_2:GetObject()
	if any_GetObject_result1_2 then
		arg1._humanoids:RemoveFirst(any_GetObject_result1_2)
	end
	arg1.HumanoidExited:Fire(any_GetObject_result1_2, any_GetPlayer_result1_2)
	if any_GetPlayer_result1_2 then
		arg1._players:RemoveFirst(any_GetPlayer_result1_2)
		arg1.PlayerExited:Fire(any_GetPlayer_result1_2, any_GetObject_result1_2)
	end
end
function setmetatable_result1_upvr_2.GetPlayerList(arg1) -- Line 94
	return arg1._humanoids:GetList()
end
function setmetatable_result1_upvr_2.GetHumanoidList(arg1) -- Line 98
	return arg1._players:GetList()
end
function setmetatable_result1_upvr_2.ObservePlayersBrio(arg1) -- Line 102
	return arg1._players:ObserveItemsBrio()
end
function setmetatable_result1_upvr_2.ObserveHumanoidsBrio(arg1) -- Line 106
	return arg1._humanoids:ObserveItemsBrio()
end
local var1_result1_upvr_4 = any_load_result1("Observable")
local var1_result1_upvr_6 = any_load_result1("Brio")
function setmetatable_result1_upvr_2.ObservePlayerInAreaBrio(arg1, arg2) -- Line 110
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr_4 (readonly)
		[2]: var1_result1_upvr_5 (readonly)
		[3]: var1_result1_upvr_6 (readonly)
	]]
	local var21
	if typeof(arg2) ~= "Instance" then
		var21 = false
	else
		var21 = true
	end
	assert(var21, "Bad player")
	var21 = var1_result1_upvr_4
	function var21(arg1_2) -- Line 113
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_5 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: var1_result1_upvr_6 (copied, readonly)
		]]
		local any_new_result1_4_upvr = var1_result1_upvr_5.new()
		any_new_result1_4_upvr:GiveTask(arg1.PlayerEntered:Connect(function(arg1_3) -- Line 116
			--[[ Upvalues[4]:
				[1]: arg2 (copied, readonly)
				[2]: var1_result1_upvr_6 (copied, readonly)
				[3]: any_new_result1_4_upvr (readonly)
				[4]: arg1_2 (readonly)
			]]
			if arg1_3 == arg2 then
				local any_new_result1 = var1_result1_upvr_6.new(arg1_3)
				any_new_result1_4_upvr._current = any_new_result1
				arg1_2:Fire(any_new_result1)
			end
		end))
		any_new_result1_4_upvr:GiveTask(arg1.PlayerExited:Connect(function(arg1_4) -- Line 123
			--[[ Upvalues[2]:
				[1]: arg2 (copied, readonly)
				[2]: any_new_result1_4_upvr (readonly)
			]]
			if arg1_4 == arg2 then
				any_new_result1_4_upvr._current = nil
			end
		end))
		for _, v in pairs(arg1._players:GetList()) do
			if v == arg2 then
				local any_new_result1_3 = var1_result1_upvr_6.new(v)
				any_new_result1_4_upvr._current = any_new_result1_3
				arg1_2:Fire(any_new_result1_3)
			end
		end
		return any_new_result1_4_upvr
	end
	return var21.new(var21)
end
function setmetatable_result1_upvr_2.IsPartOf(arg1, arg2) -- Line 141
	local var32
	if typeof(arg2) ~= "Instance" then
		var32 = false
	else
		var32 = true
	end
	assert(var32, "Bad instance")
	if arg1._obj:IsA("BasePart") and arg2 == arg1._obj then
		return true
	end
	local children = arg2:IsA("BasePart")
	if children then
		children = arg2:IsDescendantOf(arg1._obj)
	end
	return children
end
local var1_result1_upvr_2 = any_load_result1("AdorneeUtils")
function setmetatable_result1_upvr_2.GetAreaPart(arg1, arg2) -- Line 153
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_2 (readonly)
	]]
	local var35
	if typeof(arg2) ~= "Vector3" then
		var35 = false
	else
		var35 = true
	end
	assert(var35, "Bad position")
	local _, any_IsPointInArea_result2 = arg1:IsPointInArea(arg2)
	if any_IsPointInArea_result2 then
		return any_IsPointInArea_result2
	end
	if arg1._obj:IsA("BasePart") then
		return arg1._obj
	end
	return var1_result1_upvr_2.getPart(arg1._obj)
end
function setmetatable_result1_upvr_2._addPart(arg1, arg2) -- Line 169
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr_5 (readonly)
	]]
	local any_new_result1_2 = var1_result1_upvr_5.new()
	table.insert(arg1._parts, arg2)
	arg1:_updatePartInfo(arg2)
	any_new_result1_2:GiveTask(arg2:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line 177
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		arg1:_updatePartInfo(arg2)
		arg1:_updateCachedBoundingBox()
	end))
	any_new_result1_2:GiveTask(arg2:GetPropertyChangedSignal("Size"):Connect(function() -- Line 181
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		arg1:_updatePartInfo(arg2)
		arg1:_updateCachedBoundingBox()
	end))
	any_new_result1_2:GiveTask(arg2:GetPropertyChangedSignal("Anchored"):Connect(function() -- Line 185
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		arg1:_updatePartInfo(arg2)
		arg1:_updateCachedBoundingBox()
	end))
	arg1._maid[arg2] = any_new_result1_2
end
function setmetatable_result1_upvr_2._updatePartInfo(arg1, arg2) -- Line 193
	--[[ Upvalues[1]:
		[1]: var1_result1_upvr (readonly)
	]]
	if arg2.Anchored then
		arg1._compiledPartInfo[arg2] = var1_result1_upvr.compileBBox(arg2.CFrame, arg2.Size)
		arg1._uncompiledParts[arg2] = nil
	else
		arg1._uncompiledParts[arg2] = true
	end
end
function setmetatable_result1_upvr_2._removePart(arg1, arg2) -- Line 203
	if table.find(arg1._parts, arg2) then
		table.remove(arg1._parts, arg2)
	end
	arg1._maid[arg2] = nil
	arg1._uncompiledParts[arg2] = nil
	arg1._compiledPartInfo[arg2] = nil
end
function setmetatable_result1_upvr_2._updateCachedBoundingBox(arg1) -- Line 215
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr_3 (readonly)
		[2]: var1_result1_upvr (readonly)
	]]
	if 1 < #arg1._parts then
		local any_getBoundingBox_result1, any_getBoundingBox_result2 = var1_result1_upvr_3.getBoundingBox(arg1._parts)
		arg1._totalCompiledBoundingBox = var1_result1_upvr.compileBBox(CFrame.new(any_getBoundingBox_result2), any_getBoundingBox_result1)
	else
		arg1._totalCompiledBoundingBox = nil
	end
end
function setmetatable_result1_upvr_2._setupInformation(arg1) -- Line 225
	arg1._parts = {}
	arg1._compiledPartInfo = {}
	arg1._uncompiledParts = {}
	arg1._maid:GiveTask(arg1._obj.DescendantAdded:Connect(function(arg1_5) -- Line 230
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_5:IsA("BasePart") then
			arg1:_addPart(arg1_5)
			arg1:_updateCachedBoundingBox()
		end
	end))
	arg1._maid:GiveTask(arg1._obj.DescendantRemoving:Connect(function(arg1_6) -- Line 237
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_6:IsA("BasePart") then
			arg1:_removePart(arg1_6)
			arg1:_updateCachedBoundingBox()
		end
	end))
	if arg1._obj:IsA("BasePart") then
		arg1:_addPart(arg1._obj)
	end
	for _, v_2 in pairs(arg1._obj:GetDescendants()) do
		if v_2:IsA("BasePart") then
			arg1:_addPart(v_2)
		end
	end
	arg1:_updateCachedBoundingBox()
end
local tbl_upvr = {Vector3.new(0.5, 0.5, -0.5), Vector3.new(0.5, 0.5, 0.5), Vector3.new(0.5, -0.5, -0.5), Vector3.new(0.5, -0.5, 0.5), Vector3.new(-0.5, 0.5, -0.5), Vector3.new(-0.5, 0.5, 0.5), Vector3.new(-0.5, -0.5, -0.5), Vector3.new(-0.5, -0.5, 0.5)}
function setmetatable_result1_upvr_2.IsBoundingBoxCompletelyInArea(arg1, arg2, arg3) -- Line 268
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if not arg1:IsPointInArea(arg2.p) then
		return false
	end
	for _, v_3 in pairs(tbl_upvr) do
		if not arg1:IsPointInArea(arg2:pointToWorldSpace(arg3 * v_3)) then
			return false
		end
	end
	return true
end
function setmetatable_result1_upvr_2.IsBoundingBoxTouchingOrInArea(arg1, arg2, arg3) -- Line 284
	--[[ Upvalues[1]:
		[1]: tbl_upvr (readonly)
	]]
	if arg1:IsPointInArea(arg2.p) then
		return true
	end
	for _, v_4 in pairs(tbl_upvr) do
		if arg1:IsPointInArea(arg2:pointToWorldSpace(arg3 * v_4)) then
			return true
		end
	end
	return false
end
function setmetatable_result1_upvr_2.IsPointInArea(arg1, arg2) -- Line 304
	--[[ Upvalues[2]:
		[1]: var1_result1_upvr (readonly)
		[2]: var1_result1_upvr_3 (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 43 start (CF ANALYSIS FAILED)
	if arg1._totalCompiledBoundingBox and not var1_result1_upvr.testPointBBox(arg2, arg1._totalCompiledBoundingBox) then
		return false, nil
	end
	local pairs_result1, pairs_result2, pairs_result3_2 = pairs(arg1._compiledPartInfo)
	-- KONSTANTERROR: [0] 1. Error Block 43 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [87] 66. Error Block 19 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [87] 66. Error Block 19 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [20] 16. Error Block 5 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [87.7]
	-- KONSTANTERROR: [20] 16. Error Block 5 end (CF ANALYSIS FAILED)
end
return setmetatable_result1_upvr_2