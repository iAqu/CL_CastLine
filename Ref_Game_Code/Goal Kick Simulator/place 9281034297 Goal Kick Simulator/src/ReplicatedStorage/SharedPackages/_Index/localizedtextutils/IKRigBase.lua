-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:36
-- Luau version 6, Types version 3
-- Time taken: 0.003322 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_2 = any_load_result1("BaseObject")
local any_load_result1_result1_upvr = any_load_result1("Promise")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_2)
setmetatable_result1_upvr.ClassName = "IKRigBase"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
local any_load_result1_result1_upvr_3 = any_load_result1("Signal")
function setmetatable_result1_upvr.new(arg1) -- Line 18
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local setmetatable_result1 = setmetatable(any_load_result1_result1_upvr_2.new(arg1), setmetatable_result1_upvr)
	setmetatable_result1.Updating = any_load_result1_result1_upvr_3.new()
	setmetatable_result1._maid:GiveTask(setmetatable_result1.Updating)
	setmetatable_result1._ikTargets = {}
	local Parent = arg1.Parent
	if not Parent then
		Parent = error("No character")
	end
	setmetatable_result1._character = Parent
	setmetatable_result1._lastUpdateTime = 0
	return setmetatable_result1
end
function setmetatable_result1_upvr.GetLastUpdateTime(arg1) -- Line 32
	return arg1._lastUpdateTime
end
local any_load_result1_result1_upvr_5 = any_load_result1("CharacterUtils")
function setmetatable_result1_upvr.GetPlayer(arg1) -- Line 36
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	return any_load_result1_result1_upvr_5.getPlayerFromCharacter(arg1._obj)
end
function setmetatable_result1_upvr.GetHumanoid(arg1) -- Line 40
	return arg1._obj
end
function setmetatable_result1_upvr.Update(arg1) -- Line 44
	arg1._lastUpdateTime = tick()
	arg1.Updating:Fire()
	for _, v in pairs(arg1._ikTargets) do
		v:Update()
	end
end
function setmetatable_result1_upvr.UpdateTransformOnly(arg1) -- Line 53
	for _, v_2 in pairs(arg1._ikTargets) do
		v_2:UpdateTransformOnly()
	end
end
function setmetatable_result1_upvr.PromiseTorso(arg1) -- Line 59
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	return any_load_result1_result1_upvr.resolved(arg1:GetTorso())
end
function setmetatable_result1_upvr.GetTorso(arg1) -- Line 63
	if not arg1._torso then
		arg1._torso = arg1:_getNewTorso()
	end
	return arg1._torso
end
function setmetatable_result1_upvr.PromiseLeftArm(arg1) -- Line 71
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	if arg1._obj.RigType ~= Enum.HumanoidRigType.R15 then
		return any_load_result1_result1_upvr.rejected("Rig is not HumanoidRigType.R15")
	end
	return any_load_result1_result1_upvr.resolved(arg1:GetLeftArm())
end
function setmetatable_result1_upvr.GetLeftArm(arg1) -- Line 79
	if not arg1._leftArm then
		arg1._leftArm = arg1:_getNewArm("Left")
	end
	return arg1._leftArm
end
function setmetatable_result1_upvr.PromiseRightArm(arg1) -- Line 87
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr (readonly)
	]]
	if arg1._obj.RigType ~= Enum.HumanoidRigType.R15 then
		return any_load_result1_result1_upvr.rejected("Rig is not HumanoidRigType.R15")
	end
	return any_load_result1_result1_upvr.resolved(arg1:GetRightArm())
end
function setmetatable_result1_upvr.GetRightArm(arg1) -- Line 95
	if not arg1._rightArm then
		arg1._rightArm = arg1:_getNewArm("Right")
	end
	return arg1._rightArm
end
local any_load_result1_result1_upvr_4 = any_load_result1("ArmIKBase")
function setmetatable_result1_upvr._getNewArm(arg1, arg2) -- Line 103
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var20 = true
	if arg2 ~= "Left" then
		if arg2 ~= "Right" then
			var20 = false
		else
			var20 = true
		end
	end
	assert(var20, "Bad armName")
	if arg1._obj.RigType ~= Enum.HumanoidRigType.R15 then
		return nil
	end
	local any_new_result1_2 = any_load_result1_result1_upvr_4.new(arg1._obj, arg2)
	table.insert(arg1._ikTargets, any_new_result1_2)
	return any_new_result1_2
end
local any_load_result1_result1_upvr_6 = any_load_result1("TorsoIKBase")
function setmetatable_result1_upvr._getNewTorso(arg1) -- Line 116
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
	]]
	if arg1._obj.RigType ~= Enum.HumanoidRigType.R15 then
		warn("Rig is not HumanoidRigType.R15")
		return nil
	end
	local any_new_result1 = any_load_result1_result1_upvr_6.new(arg1._obj)
	arg1._maid:GiveTask(any_new_result1)
	table.insert(arg1._ikTargets, 1, any_new_result1)
	return any_new_result1
end
return setmetatable_result1_upvr