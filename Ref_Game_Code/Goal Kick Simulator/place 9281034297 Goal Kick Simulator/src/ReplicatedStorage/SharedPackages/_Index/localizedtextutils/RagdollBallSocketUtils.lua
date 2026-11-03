-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:26:59
-- Luau version 6, Types version 3
-- Time taken: 0.006347 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module_upvr_2 = {}
local tbl_3 = {
	UpperAngle = 10;
	TwistLowerAngle = -10;
	TwistUpperAngle = 10;
	FrictionTorque = 0.5;
	ReferenceMass = 0.43671694397926;
}
local tbl_8 = {
	UpperAngle = 20;
	TwistLowerAngle = 5;
	TwistUpperAngle = 120;
	FrictionTorque = 0.5;
	ReferenceMass = 0.70196455717087;
}
local tbl_7 = {
	UpperAngle = 30;
	TwistLowerAngle = -10;
	TwistUpperAngle = 10;
	FrictionTorque = 1;
	ReferenceMass = 0.69132566452026;
}
local tbl_6 = {
	UpperAngle = 5;
	TwistLowerAngle = -120;
	TwistUpperAngle = -5;
	FrictionTorque = 0.5;
	ReferenceMass = 0.65389388799667;
}
local tbl_4 = {
	UpperAngle = 110;
	TwistLowerAngle = -85;
	TwistUpperAngle = 85;
	FrictionTorque = 0.5;
	ReferenceMass = 0.90918225049973;
}
local tbl = {
	UpperAngle = 40;
	TwistLowerAngle = -5;
	TwistUpperAngle = 80;
	FrictionTorque = 0.5;
	ReferenceMass = 1.9175016880035;
}
local tbl_5 = {
	UpperAngle = 110;
	TwistLowerAngle = -85;
	TwistUpperAngle = 85;
	FrictionTorque = 0.5;
}
local tbl_2 = {
	UpperAngle = 40;
	TwistLowerAngle = -5;
	TwistUpperAngle = 80;
	FrictionTorque = 0.5;
}
local module_upvr = {{
	part0Name = "Torso";
	part1Name = "Head";
	attachmentName = "NeckAttachment";
	motorParentName = "Torso";
	motorName = "Neck";
	limits = {
		UpperAngle = 30;
		TwistLowerAngle = -40;
		TwistUpperAngle = 40;
		FrictionTorque = 0.5;
	};
}, {
	part0Name = "Torso";
	part1Name = "Left Leg";
	attachmentName = "LeftHipAttachment";
	motorParentName = "Torso";
	motorName = "Left Hip";
	limits = tbl_2;
}, {
	part0Name = "Torso";
	part1Name = "Right Leg";
	attachmentName = "RightHipAttachment";
	motorParentName = "Torso";
	motorName = "Right Hip";
	limits = tbl_2;
}, {
	part0Name = "Torso";
	part1Name = "Left Arm";
	attachmentName = "LeftShoulderRagdollAttachment";
	motorParentName = "Torso";
	motorName = "Left Shoulder";
	limits = tbl_5;
}, {
	part0Name = "Torso";
	part1Name = "Right Arm";
	attachmentName = "RightShoulderRagdollAttachment";
	motorParentName = "Torso";
	motorName = "Right Shoulder";
	limits = tbl_5;
}}
local module_upvr_3 = {{
	part0Name = "UpperTorso";
	part1Name = "Head";
	attachmentName = "NeckRigAttachment";
	motorParentName = "Head";
	motorName = "Neck";
	limits = {
		UpperAngle = 45;
		TwistLowerAngle = -40;
		TwistUpperAngle = 40;
		FrictionTorque = 400;
		ReferenceMass = 1.0249234437943;
	};
}, {
	part0Name = "LowerTorso";
	part1Name = "UpperTorso";
	attachmentName = "WaistRigAttachment";
	motorParentName = "UpperTorso";
	motorName = "Waist";
	limits = {
		UpperAngle = 20;
		TwistLowerAngle = -40;
		TwistUpperAngle = 20;
		FrictionTorque = 750;
		ReferenceMass = 2.861558675766;
	};
}, {
	part0Name = "UpperTorso";
	part1Name = "LeftUpperArm";
	attachmentName = "LeftShoulderRagdollAttachment";
	motorParentName = "LeftUpperArm";
	motorName = "LeftShoulder";
	limits = tbl_4;
}, {
	part0Name = "LeftUpperArm";
	part1Name = "LeftLowerArm";
	attachmentName = "LeftElbowRigAttachment";
	motorParentName = "LeftLowerArm";
	motorName = "LeftElbow";
	limits = tbl_8;
}, {
	part0Name = "LeftLowerArm";
	part1Name = "LeftHand";
	attachmentName = "LeftWristRigAttachment";
	motorParentName = "LeftHand";
	motorName = "LeftWrist";
	limits = tbl_7;
}, {
	part0Name = "UpperTorso";
	part1Name = "RightUpperArm";
	attachmentName = "RightShoulderRagdollAttachment";
	motorParentName = "RightUpperArm";
	motorName = "RightShoulder";
	limits = tbl_4;
}, {
	part0Name = "RightUpperArm";
	part1Name = "RightLowerArm";
	attachmentName = "RightElbowRigAttachment";
	motorParentName = "RightLowerArm";
	motorName = "RightElbow";
	limits = tbl_8;
}, {
	part0Name = "RightLowerArm";
	part1Name = "RightHand";
	attachmentName = "RightWristRigAttachment";
	motorParentName = "RightHand";
	motorName = "RightWrist";
	limits = tbl_7;
}, {
	part0Name = "LowerTorso";
	part1Name = "LeftUpperLeg";
	attachmentName = "LeftHipRigAttachment";
	motorParentName = "LeftUpperLeg";
	motorName = "LeftHip";
	limits = tbl;
}, {
	part0Name = "LeftUpperLeg";
	part1Name = "LeftLowerLeg";
	attachmentName = "LeftKneeRigAttachment";
	motorParentName = "LeftLowerLeg";
	motorName = "LeftKnee";
	limits = tbl_6;
}, {
	part0Name = "LeftLowerLeg";
	part1Name = "LeftFoot";
	attachmentName = "LeftAnkleRigAttachment";
	motorParentName = "LeftFoot";
	motorName = "LeftAnkle";
	limits = tbl_3;
}, {
	part0Name = "LowerTorso";
	part1Name = "RightUpperLeg";
	attachmentName = "RightHipRigAttachment";
	motorParentName = "RightUpperLeg";
	motorName = "RightHip";
	limits = tbl;
}, {
	part0Name = "RightUpperLeg";
	part1Name = "RightLowerLeg";
	attachmentName = "RightKneeRigAttachment";
	motorParentName = "RightLowerLeg";
	motorName = "RightKnee";
	limits = tbl_6;
}, {
	part0Name = "RightLowerLeg";
	part1Name = "RightFoot";
	attachmentName = "RightAnkleRigAttachment";
	motorParentName = "RightFoot";
	motorName = "RightAnkle";
	limits = tbl_3;
}}
function module_upvr_2.getRigData(arg1) -- Line 271
	--[[ Upvalues[2]:
		[1]: module_upvr_3 (readonly)
		[2]: module_upvr (readonly)
	]]
	if arg1 == Enum.HumanoidRigType.R15 then
		return module_upvr_3
	end
	if arg1 == Enum.HumanoidRigType.R6 then
		return module_upvr
	end
	error("[RagdollBallSocketUtils] - Unknown rigType %q":format(tostring(arg1)))
end
local var1_result1_upvr = any_load_result1("EnumUtils")
local any_load_result1_result1_upvr_5 = any_load_result1("Maid")
local any_load_result1_result1_upvr_3 = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr_2 = any_load_result1("RxR15Utils")
local any_load_result1_result1_upvr_7 = any_load_result1("RxInstanceUtils")
local Workspace_upvr = game:GetService("Workspace")
local any_load_result1_result1_upvr_6 = any_load_result1("AttributeUtils")
local any_load_result1_result1_upvr = any_load_result1("RagdollConstants")
local any_load_result1_result1_upvr_4 = any_load_result1("RxAttributeUtils")
function module_upvr_2.ensureBallSockets(arg1, arg2) -- Line 281
	--[[ Upvalues[10]:
		[1]: var1_result1_upvr (readonly)
		[2]: any_load_result1_result1_upvr_5 (readonly)
		[3]: module_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
		[5]: any_load_result1_result1_upvr_2 (readonly)
		[6]: any_load_result1_result1_upvr_7 (readonly)
		[7]: Workspace_upvr (readonly)
		[8]: any_load_result1_result1_upvr_6 (readonly)
		[9]: any_load_result1_result1_upvr (readonly)
		[10]: any_load_result1_result1_upvr_4 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var52 = false
	if typeof(arg1) == "Instance" then
		var52 = arg1:IsA("Model")
	end
	assert(var52, "Bad character")
	assert(var1_result1_upvr.isOfType(Enum.HumanoidRigType, arg2), "Bad rigType")
	local any_new_result1_2_upvr = any_load_result1_result1_upvr_5.new()
	for _, v_upvr in pairs(module_upvr_2.getRigData(arg2)) do
		local assert_result1_2 = assert(v_upvr.part1Name, "No part1Name")
		local assert_result1 = assert(v_upvr.attachmentName, "No attachmentName")
		local assert_result1_4_upvr = assert(v_upvr.limits, "No limits")
		any_new_result1_2_upvr:GiveTask(any_load_result1_result1_upvr_3.flatCombineLatest({
			motor = any_load_result1_result1_upvr_2.observeRigMotorBrio(arg1, v_upvr.motorParentName, assert(v_upvr.motorName, "No motorName"));
			part1 = any_load_result1_result1_upvr_2.observeCharacterPartBrio(arg1, assert_result1_2);
			attachment0 = any_load_result1_result1_upvr_2.observeRigAttachmentBrio(arg1, assert(v_upvr.part0Name, "No part0Name"), assert_result1);
			attachment1 = any_load_result1_result1_upvr_2.observeRigAttachmentBrio(arg1, assert_result1_2, assert_result1);
			gravity = any_load_result1_result1_upvr_7.observeProperty(Workspace_upvr, "Gravity");
		}):Subscribe(function(arg1_2) -- Line 302
			--[[ Upvalues[7]:
				[1]: any_load_result1_result1_upvr_5 (copied, readonly)
				[2]: assert_result1_4_upvr (readonly)
				[3]: any_load_result1_result1_upvr_6 (copied, readonly)
				[4]: any_load_result1_result1_upvr (copied, readonly)
				[5]: any_load_result1_result1_upvr_4 (copied, readonly)
				[6]: any_new_result1_2_upvr (readonly)
				[7]: v_upvr (readonly)
			]]
			if arg1_2.attachment0 and arg1_2.attachment1 and arg1_2.part1 and arg1_2.motor then
				local any_new_result1 = any_load_result1_result1_upvr_5.new()
				local BallSocketConstraint_upvr = Instance.new("BallSocketConstraint")
				BallSocketConstraint_upvr.Name = "RagdollBallSocket"
				BallSocketConstraint_upvr.Enabled = true
				BallSocketConstraint_upvr.LimitsEnabled = true
				BallSocketConstraint_upvr.UpperAngle = assert_result1_4_upvr.UpperAngle
				BallSocketConstraint_upvr.TwistLimitsEnabled = true
				BallSocketConstraint_upvr.TwistLowerAngle = assert_result1_4_upvr.TwistLowerAngle
				BallSocketConstraint_upvr.TwistUpperAngle = assert_result1_4_upvr.TwistUpperAngle
				BallSocketConstraint_upvr.Attachment0 = arg1_2.attachment0
				BallSocketConstraint_upvr.Attachment1 = arg1_2.attachment1
				local assert_result1_3 = assert(assert_result1_4_upvr.FrictionTorque, "No FrictionTorque")
				any_load_result1_result1_upvr_6.initAttribute(arg1_2.motor, any_load_result1_result1_upvr.FRICTION_TORQUE_ATTRIBUTE, assert_result1_3)
				any_load_result1_result1_upvr_6.initAttribute(arg1_2.motor, any_load_result1_result1_upvr.UPPER_ANGLE_ATTRIBUTE, assert_result1_4_upvr.UpperAngle)
				any_load_result1_result1_upvr_6.initAttribute(arg1_2.motor, any_load_result1_result1_upvr.TWIST_LOWER_ANGLE_ATTRIBUTE, assert_result1_4_upvr.TwistLowerAngle)
				any_load_result1_result1_upvr_6.initAttribute(arg1_2.motor, any_load_result1_result1_upvr.TWIST_UPPER_ANGLE_ATTRIBUTE, assert_result1_4_upvr.TwistUpperAngle)
				any_new_result1:GiveTask(any_load_result1_result1_upvr_4.observeAttribute(arg1_2.motor, any_load_result1_result1_upvr.UPPER_ANGLE_ATTRIBUTE, assert_result1_4_upvr.UpperAngle):Subscribe(function(arg1_3) -- Line 326
					--[[ Upvalues[1]:
						[1]: BallSocketConstraint_upvr (readonly)
					]]
					BallSocketConstraint_upvr.UpperAngle = arg1_3
				end))
				any_new_result1:GiveTask(any_load_result1_result1_upvr_4.observeAttribute(arg1_2.motor, any_load_result1_result1_upvr.TWIST_LOWER_ANGLE_ATTRIBUTE, assert_result1_4_upvr.TwistLowerAngle):Subscribe(function(arg1_4) -- Line 330
					--[[ Upvalues[1]:
						[1]: BallSocketConstraint_upvr (readonly)
					]]
					BallSocketConstraint_upvr.TwistLowerAngle = arg1_4
				end))
				any_new_result1:GiveTask(any_load_result1_result1_upvr_4.observeAttribute(arg1_2.motor, any_load_result1_result1_upvr.TWIST_UPPER_ANGLE_ATTRIBUTE, assert_result1_4_upvr.TwistUpperAngle):Subscribe(function(arg1_5) -- Line 334
					--[[ Upvalues[1]:
						[1]: BallSocketConstraint_upvr (readonly)
					]]
					BallSocketConstraint_upvr.TwistUpperAngle = arg1_5
				end))
				any_new_result1:GiveTask(any_load_result1_result1_upvr_4.observeAttribute(arg1_2.motor, any_load_result1_result1_upvr.FRICTION_TORQUE_ATTRIBUTE, assert_result1_3):Subscribe(function(arg1_6) -- Line 339
					--[[ Upvalues[3]:
						[1]: arg1_2 (readonly)
						[2]: assert_result1_4_upvr (copied, readonly)
						[3]: BallSocketConstraint_upvr (readonly)
					]]
					local ReferenceMass = assert_result1_4_upvr.ReferenceMass
					local var70
					local function INLINED() -- Internal function, doesn't exist in bytecode
						var70 = arg1_2.part1:GetMass() / ReferenceMass
						return var70
					end
					if not ReferenceMass or not INLINED() then
						var70 = 1
					end
					BallSocketConstraint_upvr.MaxFrictionTorque = (arg1_6 * var70) * (arg1_2.gravity / 196.2)
				end))
				BallSocketConstraint_upvr.Parent = arg1_2.part1
				any_new_result1:GiveTask(BallSocketConstraint_upvr)
				any_new_result1_2_upvr[v_upvr] = any_new_result1
			else
				BallSocketConstraint_upvr = v_upvr
				any_new_result1_2_upvr[BallSocketConstraint_upvr] = nil
			end
		end))
		local var71
	end
	return var71
end
return module_upvr_2