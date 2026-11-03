-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:24
-- Luau version 6, Types version 3
-- Time taken: 0.002826 seconds

local var1_upvr = require(script.Parent.loader).load(script)("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, var1_upvr)
setmetatable_result1_upvr.ClassName = "BindableRagdollHumanoidOnFall"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 25
	--[[ Upvalues[2]:
		[1]: var1_upvr (readonly)
		[2]: setmetatable_result1_upvr (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(var1_upvr.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1_upvr_2._ragdollBinder = assert(arg2, "Bad ragdollBinder")
	setmetatable_result1_upvr_2.ShouldRagdoll = Instance.new("BoolValue")
	setmetatable_result1_upvr_2.ShouldRagdoll.Value = false
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.ShouldRagdoll)
	setmetatable_result1_upvr_2:_initLastVelocityRecords()
	setmetatable_result1_upvr_2._lastRagDollTime = 0
	local var4_upvw = true
	setmetatable_result1_upvr_2._maid:GiveTask(function() -- Line 39
		--[[ Upvalues[1]:
			[1]: var4_upvw (read and write)
		]]
		var4_upvw = false
	end)
	task.spawn(function() -- Line 43
		--[[ Upvalues[2]:
			[1]: var4_upvw (read and write)
			[2]: setmetatable_result1_upvr_2 (readonly)
		]]
		task.wait(math.random() * 0.1)
		while var4_upvw do
			setmetatable_result1_upvr_2:_updateVelocity()
			task.wait(0.1)
		end
	end)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._ragdollBinder:ObserveInstance(setmetatable_result1_upvr_2._obj, function(arg1_2) -- Line 51
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if not arg1_2 then
			setmetatable_result1_upvr_2._lastRagDollTime = tick()
			setmetatable_result1_upvr_2.ShouldRagdoll.Value = false
		end
	end))
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr._initLastVelocityRecords(arg1) -- Line 61
	arg1._lastVelocityRecords = {}
	for _ = 1, 9 do
		table.insert(arg1._lastVelocityRecords, Vector3.new())
	end
end
function setmetatable_result1_upvr._getLargestSpeedInRecords(arg1) -- Line 68
	local var16
	for _, v in pairs(arg1._lastVelocityRecords) do
		local magnitude = v.magnitude
		if var16 < magnitude then
			var16 = magnitude
		end
	end
	return var16
end
function setmetatable_result1_upvr._ragdollFromFall(arg1) -- Line 81
	arg1.ShouldRagdoll.Value = true
	task.spawn(function() -- Line 84
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		while arg1.Destroy and 3 <= arg1:_getLargestSpeedInRecords() and arg1.ShouldRagdoll.Value do
			task.wait(0.05)
		end
		if arg1.Destroy and arg1.ShouldRagdoll.Value then
			task.wait(0.75)
		end
		if arg1.Destroy and 0 < arg1._obj.Health then
			arg1.ShouldRagdoll.Value = false
		end
	end)
end
function setmetatable_result1_upvr._updateVelocity(arg1) -- Line 101
	-- KONSTANTERROR: [0] 1. Error Block 34 start (CF ANALYSIS FAILED)
	table.remove(arg1._lastVelocityRecords, 1)
	local RootPart = arg1._obj.RootPart
	if not RootPart then
		table.insert(arg1._lastVelocityRecords, Vector3.new())
		return
	end
	local pairs_result1, pairs_result2, pairs_result3_2 = pairs(arg1._lastVelocityRecords)
	-- KONSTANTERROR: [0] 1. Error Block 34 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [40] 28. Error Block 41 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [40.9]
	if nil.y < math.huge then
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	end
	-- KONSTANTERROR: [40] 28. Error Block 41 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [33] 23. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [46.11]
	-- KONSTANTERROR: [33] 23. Error Block 4 end (CF ANALYSIS FAILED)
end
return setmetatable_result1_upvr