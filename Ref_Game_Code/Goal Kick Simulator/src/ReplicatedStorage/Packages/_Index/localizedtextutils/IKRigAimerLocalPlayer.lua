-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:41
-- Luau version 6, Types version 3
-- Time taken: 0.004922 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr)
setmetatable_result1_upvr.ClassName = "IKRigAimerLocalPlayer"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local var1_result1_upvr = any_load_result1("CameraStackService")
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 30
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: var1_result1_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr.new(), setmetatable_result1_upvr)
	setmetatable_result1._cameraStackService = arg1:GetService(var1_result1_upvr)
	local var6 = arg2
	if not var6 then
		var6 = error("No ikRig")
	end
	setmetatable_result1._ikRig = var6
	setmetatable_result1._lastUpdate = 0
	setmetatable_result1._lastReplication = 0
	setmetatable_result1._lookAround = true
	setmetatable_result1._aimData = nil
	setmetatable_result1._replicationRate = 1.3
	setmetatable_result1._replicationRates = {}
	return setmetatable_result1
end
function setmetatable_result1_upvr.SetRemoteEvent(arg1, arg2) -- Line 53
	assert(not arg1._remoteEvent, "Already have remoteEvent")
	arg1._remoteEvent = assert(arg2, "No remoteEvent")
end
function setmetatable_result1_upvr.SetLookAround(arg1, arg2) -- Line 63
	local var7
	if type(arg2) ~= "boolean" then
		var7 = false
	else
		var7 = true
	end
	assert(var7, "Bad lookAround")
	arg1._lookAround = arg2
end
local any_load_result1_result1_upvr_2 = any_load_result1("IKAimPositionPriorites")
function setmetatable_result1_upvr.SetAimPosition(arg1, arg2, arg3) -- Line 75
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local var10 = arg3
	if not var10 then
		var10 = any_load_result1_result1_upvr_2.DEFAULT
	end
	if arg1._aimData then
		if os.clock() - arg1._aimData.timeStamp < 0.2 then
			if var10 < arg1._aimData.priority then return end
		end
	end
	local tbl = {}
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	tbl.priority = var10
	tbl.position = arg2
	tbl.timeStamp = os.clock()
	arg1._aimData = tbl
end
function setmetatable_result1_upvr.PushReplicationRate(arg1, arg2) -- Line 91
	local var14
	if type(arg2) ~= "number" then
		var14 = false
	else
		var14 = true
	end
	assert(var14, "Bad replicateRate")
	local tbl_2_upvr = {}
	tbl_2_upvr.replicateRate = arg2
	var14 = table.insert
	var14(arg1._replicationRates, tbl_2_upvr)
	var14 = arg1:_updateReplicationRate
	var14()
	var14 = #arg1._replicationRates
	if 10 <= var14 then
		var14 = warn
		var14("[IKRigAimerLocalPlayer] - More than 10 replication rates stored, memory leak possible")
	end
	function var14() -- Line 105
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: tbl_2_upvr (readonly)
		]]
		local table_find_result1 = table.find(arg1._replicationRates, tbl_2_upvr)
		if table_find_result1 then
			table.remove(arg1._replicationRates, table_find_result1)
			arg1:_updateReplicationRate()
		end
	end
	return var14
end
function setmetatable_result1_upvr._updateReplicationRate(arg1) -- Line 114
	-- KONSTANTERROR: [0] 1. Error Block 10 start (CF ANALYSIS FAILED)
	local var16
	local pairs_result1, pairs_result2, pairs_result3 = pairs(arg1._replicationRates)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [7.6]
	if var16 then
		if nil.replicateRate < var16 then
			-- KONSTANTERROR: [12] 9. Error Block 4 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [12] 9. Error Block 4 end (CF ANALYSIS FAILED)
		end
		-- KONSTANTWARNING: GOTO [7] #6
	end
	-- KONSTANTERROR: [0] 1. Error Block 10 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 9. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 9. Error Block 4 end (CF ANALYSIS FAILED)
end
function setmetatable_result1_upvr.GetAimPosition(arg1) -- Line 130
	local var25
	if arg1._aimData then
		var25 = arg1._aimData.timeStamp
		if os.clock() - var25 < 0.2 then
			return arg1._aimData.position
		end
	end
	if not arg1._lookAround then
		return nil
	end
	local any_GetHumanoid_result1_2 = arg1._ikRig:GetHumanoid()
	var25 = arg1._cameraStackService:GetRawDefaultCamera().CameraState
	local CFrame = var25.CFrame
	var25 = any_GetHumanoid_result1_2.RootPart
	if var25 then
		var25 = any_GetHumanoid_result1_2.RootPart.CFrame
	end
	local var28
	if var25 and math.acos(CFrame:vectorToObjectSpace(var25.lookVector).Z) < 1.0471975511965976 then
		var28 = -var28
	end
	return CFrame.Position + CFrame.lookVector * var28
end
function setmetatable_result1_upvr.UpdateStepped(arg1) -- Line 167
	if os.clock() - arg1._lastUpdate <= 0.05 then
	else
		arg1._lastUpdate = os.clock()
		local any_GetTorso_result1 = arg1._ikRig:GetTorso()
		if any_GetTorso_result1 then
			any_GetTorso_result1:Point(arg1:GetAimPosition())
		end
		if arg1._remoteEvent and arg1._replicationRate < os.clock() - arg1._lastReplication then
			arg1._lastReplication = os.clock()
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			arg1._remoteEvent:FireServer(arg1:GetAimPosition())
		end
	end
end
return setmetatable_result1_upvr