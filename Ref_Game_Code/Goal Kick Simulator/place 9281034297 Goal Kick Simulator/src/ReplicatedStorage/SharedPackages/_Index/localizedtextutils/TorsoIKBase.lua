-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:05
-- Luau version 6, Types version 3
-- Time taken: 0.005894 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local any_load_result1_result1_upvr_3 = any_load_result1("BaseObject")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_3)
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
setmetatable_result1_upvr.ClassName = "TorsoIKBase"
local any_load_result1_result1_upvr_6 = any_load_result1("Signal")
local any_load_result1_result1_upvr_4 = any_load_result1("IKResource")
local any_load_result1_result1_upvr = any_load_result1("IKResourceUtils")
local any_load_result1_result1_upvr_5 = any_load_result1("AccelTween")
function setmetatable_result1_upvr.new(arg1) -- Line 19
	--[[ Upvalues[6]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_6 (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
		[5]: any_load_result1_result1_upvr (readonly)
		[6]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_3.new(), setmetatable_result1_upvr)
	local var9 = arg1
	if not var9 then
		var9 = error("No humanoid")
	end
	setmetatable_result1_upvr_2._humanoid = var9
	setmetatable_result1_upvr_2.Pointed = any_load_result1_result1_upvr_6.new()
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2.Pointed)
	setmetatable_result1_upvr_2._resources = any_load_result1_result1_upvr_4.new(any_load_result1_result1_upvr.createResource({
		name = "Character";
		robloxName = setmetatable_result1_upvr_2._humanoid.Parent.Name;
		children = {any_load_result1_result1_upvr.createResource({
			name = "RootPart";
			robloxName = "HumanoidRootPart";
		}), any_load_result1_result1_upvr.createResource({
			name = "LowerTorso";
			robloxName = "LowerTorso";
		}), any_load_result1_result1_upvr.createResource({
			name = "UpperTorso";
			robloxName = "UpperTorso";
			children = {any_load_result1_result1_upvr.createResource({
				name = "Waist";
				robloxName = "Waist";
			})};
		}), any_load_result1_result1_upvr.createResource({
			name = "Head";
			robloxName = "Head";
			children = {any_load_result1_result1_upvr.createResource({
				name = "Neck";
				robloxName = "Neck";
			})};
		})};
	}))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._resources)
	local Parent = setmetatable_result1_upvr_2._humanoid.Parent
	if not Parent then
		Parent = error("No humanoid.Parent")
	end
	setmetatable_result1_upvr_2._resources:SetInstance(Parent)
	setmetatable_result1_upvr_2._waistY = any_load_result1_result1_upvr_5.new(20)
	setmetatable_result1_upvr_2._waistZ = any_load_result1_result1_upvr_5.new(15)
	setmetatable_result1_upvr_2._headY = any_load_result1_result1_upvr_5.new(30)
	setmetatable_result1_upvr_2._headZ = any_load_result1_result1_upvr_5.new(20)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._resources.ReadyChanged:Connect(function() -- Line 70
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if setmetatable_result1_upvr_2._resources:IsReady() then
			setmetatable_result1_upvr_2:_recordLastValidTransforms()
			setmetatable_result1_upvr_2:_updatePoint()
		end
	end))
	if setmetatable_result1_upvr_2._resources:IsReady() then
		setmetatable_result1_upvr_2:_recordLastValidTransforms()
	end
	return setmetatable_result1_upvr_2
end
function setmetatable_result1_upvr.UpdateTransformOnly(arg1) -- Line 84
	if not arg1._relWaistTransform or not arg1._relNeckTransform then
	else
		if not arg1._resources:IsReady() then return end
		local any_Get_result1_4 = arg1._resources:Get("Waist")
		local any_Get_result1_5 = arg1._resources:Get("Neck")
		local Transform = any_Get_result1_4.Transform
		if arg1._lastWaistTransform ~= Transform then
			arg1._lastValidWaistTransform = Transform
		end
		any_Get_result1_4.Transform = arg1._lastValidWaistTransform * arg1._relWaistTransform
		arg1._lastWaistTransform = any_Get_result1_4.Transform
		local Transform_2 = any_Get_result1_5.Transform
		if arg1._lastNeckTransform ~= Transform_2 then
			arg1._lastValidNeckTransform = Transform_2
		end
		any_Get_result1_5.Transform = arg1._lastValidNeckTransform * arg1._relNeckTransform
		arg1._lastNeckTransform = any_Get_result1_5.Transform
	end
end
function setmetatable_result1_upvr._recordLastValidTransforms(arg1) -- Line 112
	assert(arg1._resources:IsReady())
	local any_Get_result1 = arg1._resources:Get("Waist")
	local any_Get_result1_3 = arg1._resources:Get("Neck")
	arg1._lastValidWaistTransform = any_Get_result1.Transform
	arg1._lastWaistTransform = any_Get_result1.Transform
	arg1._lastValidNeckTransform = any_Get_result1_3.Transform
	arg1._lastNeckTransform = any_Get_result1_3.Transform
end
function setmetatable_result1_upvr.Update(arg1) -- Line 124
	arg1._relWaistTransform = CFrame.Angles(0, arg1._waistY.p, 0) * CFrame.Angles(arg1._waistZ.p, 0, 0)
	arg1._relNeckTransform = CFrame.Angles(0, arg1._headY.p, 0) * CFrame.Angles(arg1._headZ.p, 0, 0)
	arg1:UpdateTransformOnly()
end
function setmetatable_result1_upvr.GetTarget(arg1) -- Line 133
	return arg1._target
end
function setmetatable_result1_upvr.Point(arg1, arg2) -- Line 137
	arg1._target = arg2
	if arg1._resources:IsReady() then
		arg1:_updatePoint()
	end
	arg1.Pointed:Fire(arg1._target)
end
local any_load_result1_result1_upvr_2 = any_load_result1("TorsoIKUtils")
function setmetatable_result1_upvr._updatePoint(arg1) -- Line 147
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
	]]
	assert(arg1._resources:IsReady())
	if arg1._target then
		local any_getTargetAngles_result1, any_getTargetAngles_result2, any_getTargetAngles_result3, any_getTargetAngles_result4 = any_load_result1_result1_upvr_2.getTargetAngles(arg1._resources:Get("RootPart"), arg1._target)
		arg1._waistY.t = any_getTargetAngles_result1
		arg1._headY.t = any_getTargetAngles_result2
		arg1._waistZ.t = any_getTargetAngles_result3
		arg1._headZ.t = any_getTargetAngles_result4
	else
		arg1._waistY.t = 0
		arg1._headY.t = 0
		arg1._waistZ.t = 0
		arg1._headZ.t = 0
	end
end
function setmetatable_result1_upvr.GetTargetUpperTorsoCFrame(arg1) -- Line 170
	if not arg1._resources:IsReady() then
		return nil
	end
	local any_Get_result1_2 = arg1._resources:Get("Waist")
	return (arg1._resources:Get("LowerTorso").CFrame * any_Get_result1_2.C0) * (arg1._lastValidWaistTransform * CFrame.Angles(0, arg1._waistY.t, 0) * CFrame.Angles(arg1._waistZ.t, 0, 0)) * any_Get_result1_2.C1:inverse()
end
function setmetatable_result1_upvr.GetUpperTorsoCFrame(arg1) -- Line 185
	if not arg1._resources:IsReady() then
		return nil
	end
	return arg1._resources:Get("LowerTorso").CFrame
end
return setmetatable_result1_upvr