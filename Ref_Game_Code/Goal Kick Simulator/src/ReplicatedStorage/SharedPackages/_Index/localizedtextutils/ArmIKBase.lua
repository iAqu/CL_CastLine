-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:43
-- Luau version 6, Types version 3
-- Time taken: 0.013453 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local any_load_result1_result1_upvr_6 = any_load_result1("BaseObject")
local any_optional_result1_upvr = any_load_result1.optional(any_load_result1, "LimbIKUtils")
local any_load_result1_result1_upvr_10 = any_load_result1("Maid")
local any_load_result1_result1_upvr_8 = any_load_result1("Motor6DStackInterface")
local any_load_result1_result1_upvr_4 = any_load_result1("Rx")
local any_load_result1_result1_upvr_3 = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr_2 = any_load_result1("RxInstanceUtils")
local setmetatable_result1_upvr = setmetatable({}, any_load_result1_result1_upvr_6)
setmetatable_result1_upvr.ClassName = "ArmIKBase"
setmetatable_result1_upvr.__index = setmetatable_result1_upvr
function setmetatable_result1_upvr.new(arg1, arg2) -- Line 32
	--[[ Upvalues[3]:
		[1]: any_load_result1_result1_upvr_6 (readonly)
		[2]: setmetatable_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_2 (readonly)
	]]
	local setmetatable_result1_upvr_2 = setmetatable(any_load_result1_result1_upvr_6.new(), setmetatable_result1_upvr)
	local var12 = arg1
	if not var12 then
		var12 = error("No humanoid")
	end
	setmetatable_result1_upvr_2._humanoid = var12
	setmetatable_result1_upvr_2._armName = assert(arg2, "No armName")
	setmetatable_result1_upvr_2._grips = {}
	if setmetatable_result1_upvr_2._armName == "Left" then
		setmetatable_result1_upvr_2._direction = 1
	elseif setmetatable_result1_upvr_2._armName == "Right" then
		setmetatable_result1_upvr_2._direction = -1
	else
		error("[ArmIKBase] - Bad armName %q":format(tostring(arg2)))
	end
	setmetatable_result1_upvr_2._gripping = Instance.new("BoolValue")
	setmetatable_result1_upvr_2._gripping.Value = false
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2._gripping)
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2:_observeCharacterBrio():Subscribe(function(arg1_2) -- Line 52
		--[[ Upvalues[2]:
			[1]: any_load_result1_result1_upvr_2 (copied, readonly)
			[2]: setmetatable_result1_upvr_2 (readonly)
		]]
		if arg1_2:IsDead() then
		else
			local any_ToMaid_result1_upvr = arg1_2:ToMaid()
			local any_GetValue_result1_upvr_2 = arg1_2:GetValue()
			any_ToMaid_result1_upvr:GiveTask(any_load_result1_result1_upvr_2.observeProperty(setmetatable_result1_upvr_2._gripping, "Value"):Subscribe(function(arg1_3) -- Line 60
				--[[ Upvalues[3]:
					[1]: any_ToMaid_result1_upvr (readonly)
					[2]: setmetatable_result1_upvr_2 (copied, readonly)
					[3]: any_GetValue_result1_upvr_2 (readonly)
				]]
				if arg1_3 then
					any_ToMaid_result1_upvr._gripping = setmetatable_result1_upvr_2:_startUpdateLoop(any_GetValue_result1_upvr_2)
				else
					any_ToMaid_result1_upvr._gripping = nil
				end
			end))
		end
	end))
	setmetatable_result1_upvr_2._maid:GiveTask(setmetatable_result1_upvr_2:_observeStateBrio():Subscribe(function(arg1_4) -- Line 69
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr_2 (readonly)
		]]
		if arg1_4:IsDead() then
		else
			local any_GetValue_result1_upvr = arg1_4:GetValue()
			setmetatable_result1_upvr_2._lastState = any_GetValue_result1_upvr
			arg1_4:ToMaid():GiveTask(function() -- Line 79
				--[[ Upvalues[2]:
					[1]: setmetatable_result1_upvr_2 (copied, readonly)
					[2]: any_GetValue_result1_upvr (readonly)
				]]
				if setmetatable_result1_upvr_2._lastState == any_GetValue_result1_upvr then
					setmetatable_result1_upvr_2._lastState = nil
				end
			end)
		end
	end))
	return setmetatable_result1_upvr_2
end
local any_load_result1_result1_upvr_11 = any_load_result1("ArmIKUtils")
function setmetatable_result1_upvr._startUpdateLoop(arg1, arg2) -- Line 89
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_10 (readonly)
		[2]: any_load_result1_result1_upvr_11 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_10.new()
	any_new_result1:GiveTask(any_load_result1_result1_upvr_11.ensureMotorAnimated(arg2, arg1._armName))
	any_new_result1:GiveTask(arg1:_ensureAnimator(arg2, arg1._armName.."UpperArm", arg1._armName.."Shoulder", function() -- Line 94
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1._shoulderTransform
	end))
	any_new_result1:GiveTask(arg1:_ensureAnimator(arg2, arg1._armName.."LowerArm", arg1._armName.."Elbow", function() -- Line 97
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1._elbowTransform
	end))
	any_new_result1:GiveTask(arg1:_ensureAnimator(arg2, arg1._armName.."Hand", arg1._armName.."Wrist", function() -- Line 100
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		return arg1._wristTransform
	end))
	return any_new_result1
end
local any_load_result1_result1_upvr = any_load_result1("RxR15Utils")
local var1_result1_upvr = any_load_result1("Motor6DSmoothTransformer")
function setmetatable_result1_upvr._ensureAnimator(arg1, arg2, arg3, arg4, arg5) -- Line 107
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_10 (readonly)
		[2]: any_load_result1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_3 (readonly)
		[4]: any_load_result1_result1_upvr_8 (readonly)
		[5]: var1_result1_upvr (readonly)
	]]
	local any_new_result1_2 = any_load_result1_result1_upvr_10.new()
	any_new_result1_2:GiveTask(any_load_result1_result1_upvr.observeRigMotorBrio(arg2, arg3, arg4):Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_5) -- Line 111
		--[[ Upvalues[1]:
			[1]: any_load_result1_result1_upvr_8 (copied, readonly)
		]]
		return any_load_result1_result1_upvr_8:ObserveLastImplementationBrio(arg1_5)
	end)}):Subscribe(function(arg1_6) -- Line 114
		--[[ Upvalues[2]:
			[1]: var1_result1_upvr (copied, readonly)
			[2]: arg5 (readonly)
		]]
		if arg1_6:IsDead() then
		else
			local any_new_result1_upvr = var1_result1_upvr.new(arg5)
			any_new_result1_upvr:SetTarget(1)
			local any_Push_result1_upvr = arg1_6:GetValue():Push(any_new_result1_upvr)
			arg1_6:ToMaid():GiveTask(function() -- Line 127
				--[[ Upvalues[2]:
					[1]: any_new_result1_upvr (readonly)
					[2]: any_Push_result1_upvr (readonly)
				]]
				any_new_result1_upvr:SetTarget(0)
				task.delay(2, function() -- Line 130
					--[[ Upvalues[2]:
						[1]: any_new_result1_upvr (copied, readonly)
						[2]: any_Push_result1_upvr (copied, readonly)
					]]
					any_new_result1_upvr:Destroy()
					any_Push_result1_upvr()
				end)
			end)
		end
	end))
	return any_new_result1_2
end
function setmetatable_result1_upvr._observeCharacterBrio(arg1) -- Line 140
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_2 (readonly)
		[2]: any_load_result1_result1_upvr_4 (readonly)
	]]
	if arg1._characterObservable then
		return arg1._characterObservable
	end
	arg1._characterObservable = any_load_result1_result1_upvr_2.observePropertyBrio(arg1._humanoid, "Parent", function(arg1_7) -- Line 145
		if arg1_7 == nil then
		else
		end
		return true
	end):Pipe({any_load_result1_result1_upvr_4.shareReplay(1)})
	return arg1._characterObservable
end
function setmetatable_result1_upvr._observeStateBrio(arg1) -- Line 155
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_3 (readonly)
		[2]: any_load_result1_result1_upvr_2 (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
		[4]: any_load_result1_result1_upvr_8 (readonly)
	]]
	return arg1:_observeCharacterBrio():Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_8) -- Line 157
		--[[ Upvalues[5]:
			[1]: any_load_result1_result1_upvr_2 (copied, readonly)
			[2]: any_load_result1_result1_upvr_4 (copied, readonly)
			[3]: arg1 (readonly)
			[4]: any_load_result1_result1_upvr_3 (copied, readonly)
			[5]: any_load_result1_result1_upvr_8 (copied, readonly)
		]]
		local any_Pipe_result1_6 = any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_8, "BasePart", "UpperTorso"):Pipe({any_load_result1_result1_upvr_4.shareReplay(1)})
		local any_Pipe_result1_5 = any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_8, "BasePart", arg1._armName.."UpperArm"):Pipe({any_load_result1_result1_upvr_4.shareReplay(1)})
		local any_Pipe_result1_3 = any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_8, "BasePart", arg1._armName.."LowerArm"):Pipe({any_load_result1_result1_upvr_4.shareReplay(1)})
		local any_Pipe_result1_2 = any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_8, "BasePart", arg1._armName.."Hand"):Pipe({any_load_result1_result1_upvr_4.shareReplay(1)})
		local any_Pipe_result1 = any_Pipe_result1_5:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_9) -- Line 172
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr_2 (copied, readonly)
				[2]: arg1 (copied, readonly)
			]]
			return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_9, "Motor6D", arg1._armName.."Shoulder")
		end), any_load_result1_result1_upvr_4.shareReplay(1)})
		local any_Pipe_result1_7 = any_Pipe_result1_3:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_10) -- Line 178
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr_2 (copied, readonly)
				[2]: arg1 (copied, readonly)
			]]
			return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_10, "Motor6D", arg1._armName.."Elbow")
		end), any_load_result1_result1_upvr_4.shareReplay(1)})
		local any_Pipe_result1_4 = any_Pipe_result1_2:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_11) -- Line 184
			--[[ Upvalues[2]:
				[1]: any_load_result1_result1_upvr_2 (copied, readonly)
				[2]: arg1 (copied, readonly)
			]]
			return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_11, "Motor6D", arg1._armName.."Wrist")
		end), any_load_result1_result1_upvr_4.shareReplay(1)})
		return any_load_result1_result1_upvr_3.flatCombineLatest({
			UpperTorso = any_Pipe_result1_6;
			UpperArm = any_Pipe_result1_5;
			LowerArm = any_Pipe_result1_3;
			Hand = any_Pipe_result1_2;
			Shoulder = any_Pipe_result1;
			Elbow = any_Pipe_result1_7;
			Wrist = any_Pipe_result1_4;
			ShoulderMotor6DStack = any_Pipe_result1:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_12) -- Line 201
				--[[ Upvalues[1]:
					[1]: any_load_result1_result1_upvr_8 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_8:ObserveLastImplementationBrio(arg1_12)
			end), any_load_result1_result1_upvr_4.defaultsToNil});
			ElbowMotor6DStack = any_Pipe_result1_7:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_13) -- Line 207
				--[[ Upvalues[1]:
					[1]: any_load_result1_result1_upvr_8 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_8:ObserveLastImplementationBrio(arg1_13)
			end), any_load_result1_result1_upvr_4.defaultsToNil});
			WristMotor6DStack = any_Pipe_result1_4:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_14) -- Line 213
				--[[ Upvalues[1]:
					[1]: any_load_result1_result1_upvr_8 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_8:ObserveLastImplementationBrio(arg1_14)
			end), any_load_result1_result1_upvr_4.defaultsToNil});
			UpperTorsoShoulderRigAttachment = any_Pipe_result1_6:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_15) -- Line 220
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_15, "Attachment", arg1._armName.."ShoulderRigAttachment")
			end)});
			UpperArmShoulderRigAttachment = any_Pipe_result1_5:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_16) -- Line 225
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_16, "Attachment", arg1._armName.."ShoulderRigAttachment")
			end)});
			UpperArmElbowRigAttachment = any_Pipe_result1_5:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_17) -- Line 230
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_17, "Attachment", arg1._armName.."ElbowRigAttachment")
			end)});
			LowerArmElbowRigAttachment = any_Pipe_result1_3:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_18) -- Line 235
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_18, "Attachment", arg1._armName.."ElbowRigAttachment")
			end)});
			LowerArmWristRigAttachment = any_Pipe_result1_3:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_19) -- Line 240
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_19, "Attachment", arg1._armName.."WristRigAttachment")
			end)});
			HandWristRigAttachment = any_Pipe_result1_2:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_20) -- Line 245
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_20, "Attachment", arg1._armName.."WristRigAttachment")
			end)});
			HandGripAttachment = any_Pipe_result1_2:Pipe({any_load_result1_result1_upvr_3.switchMapBrio(function(arg1_21) -- Line 250
				--[[ Upvalues[2]:
					[1]: any_load_result1_result1_upvr_2 (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				return any_load_result1_result1_upvr_2.observeLastNamedChildBrio(arg1_21, "Attachment", arg1._armName.."GripAttachment")
			end)});
		})
	end), any_load_result1_result1_upvr_4.throttleDefer()})
end
local any_load_result1_result1_upvr_5 = any_load_result1("IKAimPositionPriorites")
function setmetatable_result1_upvr.Grip(arg1, arg2, arg3) -- Line 261
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local tbl_upvr = {}
	tbl_upvr.attachment = arg2
	local var79
	if not var79 then
		var79 = any_load_result1_result1_upvr_5.DEFAULT
	end
	tbl_upvr.priority = var79
	var79 = 1
	while arg1._grips[var79] and arg3 < arg1._grips[var79].priority do
		var79 += 1
	end
	table.insert(arg1._grips, var79, tbl_upvr)
	arg1._gripping.Value = true
	return function() -- Line 275
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: tbl_upvr (readonly)
		]]
		if arg1.Destroy then
			arg1:_stopGrip(tbl_upvr)
		end
	end
end
function setmetatable_result1_upvr._stopGrip(arg1, arg2) -- Line 282
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local pairs_result1, pairs_result2, pairs_result3 = pairs(arg1._grips)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [15] 11. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [15] 11. Error Block 4 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [6] 5. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [15.6]
	-- KONSTANTERROR: [6] 5. Error Block 2 end (CF ANALYSIS FAILED)
end
function setmetatable_result1_upvr.UpdateTransformOnly(arg1) -- Line 301
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	if not arg1._grips[1] then
	else
		if not arg1._shoulderTransform or not arg1._elbowTransform or not arg1._wristTransform then return end
		if not arg1._lastState then return end
		local Shoulder = arg1._lastState.Shoulder
		local Elbow = arg1._lastState.Elbow
		local Wrist = arg1._lastState.Wrist
		if not Shoulder and Elbow and Wrist then return end
		if RunService_upvr:IsRunning() then
			Shoulder.Transform = arg1._shoulderTransform
			Elbow.Transform = arg1._elbowTransform
			Wrist.Transform = arg1._wristTransform
			return
		end
		if not arg1._initTest then
			arg1._initTest = true
			arg1._testDefaultShoulderC0 = Shoulder.C0
			arg1._testDefaultElbowC0 = Elbow.C0
			arg1._testDefaultWristC0 = Wrist.C0
		end
		Shoulder.C0 = arg1._testDefaultShoulderC0 * arg1._shoulderTransform
		Elbow.C0 = arg1._testDefaultElbowC0 * arg1._elbowTransform
		Wrist.C0 = arg1._testDefaultWristC0 * arg1._wristTransform
	end
end
if not any_optional_result1_upvr or false then
	local cframe_upvr = CFrame.Angles((math.pi/2), 0, 0)
	local function Update(arg1) -- Line 345
		--[[ Upvalues[1]:
			[1]: cframe_upvr (readonly)
		]]
		if arg1:_oldUpdatePoint() then
			arg1._shoulderTransform = CFrame.new(Vector3.new(), arg1._offset) * cframe_upvr * CFrame.Angles(arg1._shoulderXAngle, 0, 0)
			arg1._elbowTransform = CFrame.Angles(arg1._elbowXAngle, 0, 0)
			arg1._wristTransform = CFrame.new()
			arg1:UpdateTransformOnly()
		end
	end
	setmetatable_result1_upvr.Update = Update
else
	setmetatable_result1_upvr.Update = function(arg1) -- Line 360, Named "Update"
		if arg1:_newUpdate() then
			arg1:UpdateTransformOnly()
		end
	end
end
function setmetatable_result1_upvr._oldUpdatePoint(arg1) -- Line 367
	local _1_2 = arg1._grips[1]
	if not _1_2 then
		arg1:_clear()
		return false
	end
	if not arg1:_oldCalculatePoint(_1_2.attachment.WorldPosition) then
		arg1:_clear()
		return false
	end
	return true
end
function setmetatable_result1_upvr._clear(arg1) -- Line 382
	arg1._offset = nil
	arg1._elbowTransform = nil
	arg1._shoulderTransform = nil
	arg1._wristTransform = nil
end
local any_load_result1_result1_upvr_7 = any_load_result1("QFrame")
function setmetatable_result1_upvr._newUpdate(arg1) -- Line 389
	--[[ Upvalues[2]:
		[1]: any_optional_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_7 (readonly)
	]]
	local _1 = arg1._grips[1]
	if not _1 or not arg1._lastState then
		arg1._elbowTransform = nil
		arg1._shoulderTransform = nil
		arg1._wristTransform = nil
		return false
	end
	local UpperTorsoShoulderRigAttachment = arg1._lastState.UpperTorsoShoulderRigAttachment
	local UpperArmShoulderRigAttachment = arg1._lastState.UpperArmShoulderRigAttachment
	local UpperArmElbowRigAttachment = arg1._lastState.UpperArmElbowRigAttachment
	local LowerArmElbowRigAttachment = arg1._lastState.LowerArmElbowRigAttachment
	local LowerArmWristRigAttachment = arg1._lastState.LowerArmWristRigAttachment
	local HandWristRigAttachment = arg1._lastState.HandWristRigAttachment
	local HandGripAttachment_2 = arg1._lastState.HandGripAttachment
	if not UpperTorsoShoulderRigAttachment or not UpperArmShoulderRigAttachment or not UpperArmElbowRigAttachment or not LowerArmElbowRigAttachment or not LowerArmWristRigAttachment or not HandWristRigAttachment or not HandGripAttachment_2 then
		return false
	end
	local any_solveLimb_result1, any_solveLimb_result2, any_solveLimb_result3 = any_optional_result1_upvr.solveLimb(any_optional_result1_upvr.createConfig(UpperArmElbowRigAttachment.Position - UpperArmShoulderRigAttachment.Position, (LowerArmWristRigAttachment.Position - LowerArmElbowRigAttachment.Position) + (HandGripAttachment_2.Position - HandWristRigAttachment.Position), 1), any_load_result1_result1_upvr_7.fromCFrameClosestTo(UpperTorsoShoulderRigAttachment.WorldCFrame:toObjectSpace(_1.attachment.WorldCFrame), any_load_result1_result1_upvr_7.new()), arg1._direction * 0.3490658503988659)
	arg1._shoulderTransform = any_load_result1_result1_upvr_7.toCFrame(any_solveLimb_result1)
	arg1._elbowTransform = any_load_result1_result1_upvr_7.toCFrame(any_solveLimb_result2)
	arg1._wristTransform = any_load_result1_result1_upvr_7.toCFrame(any_solveLimb_result3)
	return true
end
local any_load_result1_result1_upvr_9 = any_load_result1("Math")
function setmetatable_result1_upvr._oldCalculatePoint(arg1, arg2) -- Line 437
	--[[ Upvalues[1]:
		[1]: any_load_result1_result1_upvr_9 (readonly)
	]]
	if not arg1._lastState then
		return false
	end
	local Shoulder_2 = arg1._lastState.Shoulder
	local Elbow_2 = arg1._lastState.Elbow
	local Wrist_2 = arg1._lastState.Wrist
	local HandGripAttachment = arg1._lastState.HandGripAttachment
	if not Shoulder_2 or not Elbow_2 or not Wrist_2 or not HandGripAttachment then
		return false
	end
	if not Shoulder_2.Part0 or not Elbow_2.Part0 or not Elbow_2.Part1 then
		return false
	end
	local _testDefaultShoulderC0 = arg1._testDefaultShoulderC0
	if not _testDefaultShoulderC0 then
		_testDefaultShoulderC0 = Shoulder_2.C0
	end
	local var107 = Shoulder_2.Part0.CFrame * _testDefaultShoulderC0
	local _testDefaultElbowC0 = arg1._testDefaultElbowC0
	if not _testDefaultElbowC0 then
		_testDefaultElbowC0 = Elbow_2.C0
	end
	local var109 = Elbow_2.Part0.CFrame * _testDefaultElbowC0
	local _testDefaultWristC0 = arg1._testDefaultWristC0
	if not _testDefaultWristC0 then
		_testDefaultWristC0 = Wrist_2.C0
	end
	local var111 = Elbow_2.Part1.CFrame * _testDefaultWristC0
	local Magnitude_2 = (var107.Position - var109.Position).Magnitude
	local var113 = (var109.Position - var111.Position).Magnitude + (HandGripAttachment.WorldPosition - var111.Position).Magnitude
	local any_pointToObjectSpace_result1 = var107:pointToObjectSpace(arg2)
	local Magnitude = any_pointToObjectSpace_result1.Magnitude
	if Magnitude_2 + var113 < Magnitude then
		Magnitude = Magnitude_2 + var113
	end
	if Magnitude == 0 then
		return false
	end
	local any_lawOfCosines_result1 = any_load_result1_result1_upvr_9.lawOfCosines(Magnitude_2, Magnitude, var113)
	local any_lawOfCosines_result1_2 = any_load_result1_result1_upvr_9.lawOfCosines(var113, Magnitude_2, Magnitude)
	if not any_lawOfCosines_result1 or not any_lawOfCosines_result1_2 then
		return false
	end
	any_lawOfCosines_result1_2 -= math.pi
	local var118 = any_lawOfCosines_result1_2
	if -0.09817477042468103 < var118 then
		var118 = -0.09817477042468103
	end
	arg1._shoulderXAngle = -any_lawOfCosines_result1
	arg1._elbowXAngle = -var118
	arg1._offset = any_pointToObjectSpace_result1.unit * Magnitude
	return true
end
return setmetatable_result1_upvr