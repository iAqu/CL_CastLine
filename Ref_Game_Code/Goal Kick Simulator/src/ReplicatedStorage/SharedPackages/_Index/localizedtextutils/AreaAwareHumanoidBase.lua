-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:12
-- Luau version 6, Types version 3
-- Time taken: 0.005673 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr)
setmetatable_result1_upvr.ClassName = "AreaAwareHumanoidBase"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("Signal")
function setmetatable_result1_upvr.new(arg1) -- Line 23
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._presenceMap = {}
	setmetatable_result1_upvr_2.PresenceAdded = var1_result1_upvr.new()
	setmetatable_result1_upvr_2.PresenceRemoving = var1_result1_upvr.new()
	setmetatable_result1_upvr_2._maid:GiveTask(function() -- Line 31
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		setmetatable_result1_upvr_2._maid:DoCleaning()
		setmetatable_result1_upvr_2.PresenceAdded:Destroy()
		setmetatable_result1_upvr_2.PresenceRemoving:Destroy()
	end)
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.GetAreaBinder(arg1) -- Line 42
	error("not implemented")
end
function setmetatable_result1_upvr.GetObject(arg1) -- Line 46
	return arg1._obj
end
local any_load_result1_result1_upvr_4 = any_load_result1("CharacterUtils")
function setmetatable_result1_upvr.GetPlayer(arg1) -- Line 50
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	return any_load_result1_result1_upvr_4.getPlayerFromCharacter(arg1._obj)
end
local any_load_result1_result1_upvr_3 = any_load_result1("RootPartUtils")
function setmetatable_result1_upvr.PromiseRootPart(arg1) -- Line 54
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
	]]
	if arg1._rootPartPromise then
		return arg1._rootPartPromise
	end
	assert(not arg1._ownerIsSetupAlready, "Already setup as owner")
	arg1._ownerIsSetupAlready = true
	local any_promiseRootPart_result1_upvr = any_load_result1_result1_upvr_3.promiseRootPart(arg1._obj)
	arg1._maid:GiveTask(function() -- Line 63
		--[[ Upvalues[1]:
			[1]: any_promiseRootPart_result1_upvr (readonly)
		]]
		any_promiseRootPart_result1_upvr:Reject()
	end)
	arg1._rootPartPromise = arg1._maid:GivePromise(any_promiseRootPart_result1_upvr)
	return arg1._rootPartPromise
end
function setmetatable_result1_upvr.SetupAsOwner(arg1) -- Line 72
	arg1:PromiseRootPart():Then(function(arg1_2) -- Line 73
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		assert(not arg1._rootPart, "Already setup root part")
		local var12 = arg1_2
		if not var12 then
			var12 = error("No rootPart")
		end
		arg1._rootPart = var12
		arg1:_startCompileLoop()
	end)
end
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_upvr._startCompileLoop(arg1) -- Line 81
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	assert(not arg1._lastUpdateTime, "Already setup update loop")
	assert(arg1._rootPart, "Need to setup root part")
	arg1._lastUpdateTime = 0
	arg1._maid:GiveTask(RunService_upvr.Heartbeat:Connect(function() -- Line 87
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if 0.1 <= os.clock() - arg1._lastUpdateTime then
			debug.profilebegin("updateCompiledAreas")
			arg1._lastUpdateTime = os.clock()
			arg1:_checkAreas()
			debug.profileend()
		end
	end))
end
local any_load_result1_result1_upvr_5 = any_load_result1("BinderUtils")
function setmetatable_result1_upvr.FindArea(arg1, arg2) -- Line 98
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local any_GetAreaBinder_result1 = arg1:GetAreaBinder()
	local any_Get_result1 = any_GetAreaBinder_result1:Get(arg2)
	if not any_Get_result1 then
		any_Get_result1 = any_load_result1_result1_upvr_5.findFirstAncestor(any_GetAreaBinder_result1, arg2)
	end
	return any_Get_result1
end
function setmetatable_result1_upvr.FindPresenceForArea(arg1, arg2) -- Line 110
	assert(arg2, "Bad area")
	if arg1._presenceMap[arg2] then
		return arg1._presenceMap[arg2]
	end
	return nil
end
local any_load_result1_result1_upvr_6 = any_load_result1("Maid")
local any_load_result1_result1_upvr_2 = any_load_result1("AreaPresence")
function setmetatable_result1_upvr.GetOrCreatePresence(arg1, arg2, arg3, arg4) -- Line 120
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local var20_upvr = arg2
	assert(var20_upvr, "Bad area")
	if typeof(arg3) ~= "Instance" then
		var20_upvr = false
	else
		var20_upvr = true
	end
	assert(var20_upvr, "Bad areaPart")
	if typeof(arg4) ~= "Vector3" then
		var20_upvr = false
	else
		var20_upvr = true
	end
	assert(var20_upvr, "No relPointInArea")
	var20_upvr = arg1._presenceMap
	if var20_upvr[arg2] then
		var20_upvr = arg1._presenceMap
		return var20_upvr[arg2]
	end
	var20_upvr = any_load_result1_result1_upvr_6
	local any_new_result1 = var20_upvr.new()
	var20_upvr = any_load_result1_result1_upvr_2.new(arg2, arg1)
	any_new_result1:GiveTask(var20_upvr.Done:Connect(function() -- Line 132
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var20_upvr (readonly)
		]]
		arg1:RemovePresence(var20_upvr)
	end))
	any_new_result1:GiveTask(arg2.Removing:Connect(function() -- Line 135
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: var20_upvr (readonly)
		]]
		arg1:RemovePresence(var20_upvr)
	end))
	arg1._presenceMap[arg2] = var20_upvr
	any_new_result1:GiveTask(function() -- Line 139
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
			[3]: var20_upvr (readonly)
		]]
		if arg1._presenceMap[arg2] == var20_upvr then
			arg1._presenceMap[arg2] = nil
		end
		arg1.PresenceRemoving:Fire(var20_upvr)
		var20_upvr:Destroy()
	end)
	arg1._maid[var20_upvr] = any_new_result1
	var20_upvr:DoInitialActivation()
	if not arg1.Destroy then
		return nil
	end
	arg1.PresenceAdded:Fire(var20_upvr, arg3, arg4)
	return var20_upvr
end
function setmetatable_result1_upvr.GetPresenceList(arg1) -- Line 162
	local module = {}
	for _, v in pairs(arg1._presenceMap) do
		table.insert(module, v)
	end
	return module
end
function setmetatable_result1_upvr.RemovePresenceForArea(arg1, arg2) -- Line 170
	local any_FindPresenceForArea_result1 = arg1:FindPresenceForArea(arg2)
	if any_FindPresenceForArea_result1 then
		arg1:RemovePresence(any_FindPresenceForArea_result1)
	end
end
function setmetatable_result1_upvr.RemovePresence(arg1, arg2) -- Line 177
	local var34 = arg2
	assert(var34, "Bad areaPresence")
	if arg2.ClassName ~= "AreaPresence" then
		var34 = false
	else
		var34 = true
	end
	assert(var34, "Bad areaPresence")
	arg1._maid[arg2] = nil
end
function setmetatable_result1_upvr._checkAreas(arg1) -- Line 184
	local Position = arg1._rootPart.Position
	for i_2, _ in pairs(arg1:GetAreaBinder():GetAllSet()) do
		local any_IsPointInArea_result1, any_IsPointInArea_result2 = i_2:IsPointInArea(Position)
		if any_IsPointInArea_result1 then
			arg1:GetOrCreatePresence(i_2, any_IsPointInArea_result2, any_IsPointInArea_result2.CFrame:pointToObjectSpace(Position))
		else
			local var43 = arg1._presenceMap[i_2]
			if var43 then
				arg1:RemovePresence(var43)
			end
		end
	end
end
return setmetatable_result1_upvr