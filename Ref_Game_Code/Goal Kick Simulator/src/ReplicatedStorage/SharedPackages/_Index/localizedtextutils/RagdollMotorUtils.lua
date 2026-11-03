-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:27:38
-- Luau version 6, Types version 3
-- Time taken: 0.012495 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local RunService_upvr = game:GetService("RunService")
local any_load_result1_result1_upvr_6 = any_load_result1("AttributeUtils")
local any_load_result1_result1_upvr_5 = any_load_result1("CharacterUtils")
local any_load_result1_result1_upvr_12 = any_load_result1("EnumUtils")
local any_load_result1_result1_upvr_8 = any_load_result1("Maid")
local any_load_result1_result1_upvr_4 = any_load_result1("R15Utils")
local any_load_result1_result1_upvr_3 = any_load_result1("RagdollConstants")
local any_load_result1_result1_upvr = any_load_result1("RxAttributeUtils")
local var1_result1_upvr_2 = any_load_result1("RxBrioUtils")
local any_load_result1_result1_upvr_7 = any_load_result1("RxInstanceUtils")
local any_load_result1_result1_upvr_10 = any_load_result1("RxR15Utils")
local module_2_upvr = {}
local module_4_upvr = {{
	partName = "Torso";
	motorName = "Root";
	isRootJoint = true;
}, {
	partName = "Torso";
	motorName = "Neck";
}, {
	partName = "Torso";
	motorName = "Left Shoulder";
}, {
	partName = "Torso";
	motorName = "Right Shoulder";
}, {
	partName = "Torso";
	motorName = "Left Hip";
}, {
	partName = "Torso";
	motorName = "Right Hip";
}}
local module_3_upvr = {{
	partName = "LowerTorso";
	motorName = "Root";
	isRootJoint = true;
}, {
	partName = "UpperTorso";
	motorName = "Waist";
}, {
	partName = "Head";
	motorName = "Neck";
}, {
	partName = "LeftUpperArm";
	motorName = "LeftShoulder";
}, {
	partName = "LeftLowerArm";
	motorName = "LeftElbow";
}, {
	partName = "LeftHand";
	motorName = "LeftWrist";
}, {
	partName = "RightUpperArm";
	motorName = "RightShoulder";
}, {
	partName = "RightLowerArm";
	motorName = "RightElbow";
}, {
	partName = "RightHand";
	motorName = "RightWrist";
}, {
	partName = "LeftUpperLeg";
	motorName = "LeftHip";
}, {
	partName = "LeftLowerLeg";
	motorName = "LeftKnee";
}, {
	partName = "LeftFoot";
	motorName = "LeftAnkle";
}, {
	partName = "RightUpperLeg";
	motorName = "RightHip";
}, {
	partName = "RightLowerLeg";
	motorName = "RightKnee";
}, {
	partName = "RightFoot";
	motorName = "RightAnkle";
}}
local tbl_2_upvr = {}
function module_2_upvr.getFirstRootJointData(arg1) -- Line 126
	--[[ Upvalues[2]:
		[1]: tbl_2_upvr (readonly)
		[2]: module_2_upvr (readonly)
	]]
	if tbl_2_upvr[arg1] then
		return tbl_2_upvr[arg1]
	end
	for _, v in pairs(module_2_upvr.getMotorData(arg1)) do
		if v.isRootJoint then
			tbl_2_upvr[arg1] = v
			return v
		end
	end
	error("Could not find root joint data")
end
function module_2_upvr.getMotorData(arg1) -- Line 141
	--[[ Upvalues[2]:
		[1]: module_3_upvr (readonly)
		[2]: module_4_upvr (readonly)
	]]
	if arg1 == Enum.HumanoidRigType.R15 then
		return module_3_upvr
	end
	if arg1 == Enum.HumanoidRigType.R6 then
		return module_4_upvr
	end
	error("[RagdollMotorUtils] - Unknown rigType %q":format(tostring(arg1)))
end
function module_2_upvr.initMotorAttributes(arg1, arg2) -- Line 151
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_12 (readonly)
		[2]: module_2_upvr (readonly)
		[3]: any_load_result1_result1_upvr_4 (readonly)
		[4]: any_load_result1_result1_upvr_6 (readonly)
		[5]: any_load_result1_result1_upvr_3 (readonly)
	]]
	local var47 = false
	if typeof(arg1) == "Instance" then
		var47 = arg1:IsA("Model")
	end
	assert(var47, "Bad character")
	assert(any_load_result1_result1_upvr_12.isOfType(Enum.HumanoidRigType, arg2), "Bad rigType")
	for _, v_2 in pairs(module_2_upvr.getMotorData(arg2)) do
		local any_getRigMotor_result1 = any_load_result1_result1_upvr_4.getRigMotor(arg1, v_2.partName, v_2.motorName)
		if any_getRigMotor_result1 then
			any_load_result1_result1_upvr_6.initAttribute(any_getRigMotor_result1, any_load_result1_result1_upvr_3.IS_MOTOR_ANIMATED_ATTRIBUTE, false)
			any_load_result1_result1_upvr_6.initAttribute(any_getRigMotor_result1, any_load_result1_result1_upvr_3.RETURN_SPRING_SPEED_ATTRIBUTE, 20)
		end
	end
end
local any_load_result1_result1_upvr_11 = any_load_result1("RagdollCollisionUtils")
function module_2_upvr.setupAnimatedMotor(arg1, arg2) -- Line 164
	--[[ Upvalues[2]:
		[1]: any_load_result1_result1_upvr_8 (readonly)
		[2]: any_load_result1_result1_upvr_11 (readonly)
	]]
	local any_new_result1 = any_load_result1_result1_upvr_8.new()
	any_new_result1:GiveTask(any_load_result1_result1_upvr_11.preventCollisionAmongOthers(arg1, arg2))
	return any_new_result1
end
local var1_result1_upvr = any_load_result1("Spring")
local any_load_result1_result1_upvr_13 = any_load_result1("QFrame")
local any_load_result1_result1_upvr_2 = any_load_result1("Rx")
function module_2_upvr.setupRagdollRootPartMotor(arg1, arg2, arg3) -- Line 174
	--[[ Upvalues[9]:
		[1]: any_load_result1_result1_upvr_8 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr_13 (readonly)
		[4]: any_load_result1_result1_upvr_2 (readonly)
		[5]: any_load_result1_result1_upvr_7 (readonly)
		[6]: any_load_result1_result1_upvr_5 (readonly)
		[7]: any_load_result1_result1_upvr (readonly)
		[8]: any_load_result1_result1_upvr_3 (readonly)
		[9]: RunService_upvr (readonly)
	]]
	local any_new_result1_6_upvr = any_load_result1_result1_upvr_8.new()
	local any_new_result1_2_upvr = var1_result1_upvr.new(any_load_result1_result1_upvr_13.fromCFrameClosestTo(arg1.Transform, any_load_result1_result1_upvr_13.new()))
	any_new_result1_2_upvr.t = any_load_result1_result1_upvr_13.new()
	local Camera_upvr = Instance.new("Camera")
	Camera_upvr.Name = "TempWeldContainer"
	Camera_upvr.Parent = arg2
	any_new_result1_6_upvr:GiveTask(Camera_upvr)
	local function setupWeld_upvr(arg1_2) -- Line 186, Named "setupWeld"
		--[[ Upvalues[7]:
			[1]: any_load_result1_result1_upvr_8 (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg3 (readonly)
			[4]: any_load_result1_result1_upvr_2 (copied, readonly)
			[5]: any_load_result1_result1_upvr_7 (copied, readonly)
			[6]: arg1 (readonly)
			[7]: Camera_upvr (readonly)
		]]
		local any_new_result1_4 = any_load_result1_result1_upvr_8.new()
		local any_upvr = Instance.new(arg1_2)
		any_upvr.Name = "TempRagdollWeld"
		any_upvr.Part0 = arg2
		any_upvr.Part1 = arg3
		any_new_result1_4:GiveTask(any_upvr)
		any_new_result1_4:GiveTask(any_load_result1_result1_upvr_2.combineLatest({
			C0 = any_load_result1_result1_upvr_7.observeProperty(arg1, "C0");
			Transform = any_load_result1_result1_upvr_7.observeProperty(arg1, "Transform");
		}):Subscribe(function(arg1_3) -- Line 199
			--[[ Upvalues[1]:
				[1]: any_upvr (readonly)
			]]
			any_upvr.C0 = arg1_3.C0 * arg1_3.Transform
		end))
		any_new_result1_4:GiveTask(any_load_result1_result1_upvr_7.observeProperty(arg1, "C1"):Subscribe(function(arg1_4) -- Line 202
			--[[ Upvalues[1]:
				[1]: any_upvr (readonly)
			]]
			any_upvr.C1 = arg1_4
		end))
		any_upvr.Parent = Camera_upvr
		return any_new_result1_4
	end
	if any_load_result1_result1_upvr_5.getPlayerFromCharacter(arg2) then
		any_new_result1_6_upvr._weld = setupWeld_upvr("Motor6D")
		any_new_result1_6_upvr:GiveTask(task.delay(0.25, function() -- Line 213
			--[[ Upvalues[2]:
				[1]: any_new_result1_6_upvr (readonly)
				[2]: setupWeld_upvr (readonly)
			]]
			any_new_result1_6_upvr._weld = setupWeld_upvr("Weld")
		end))
	else
		any_new_result1_6_upvr._weld = setupWeld_upvr("Weld")
	end
	any_new_result1_6_upvr:GiveTask(any_load_result1_result1_upvr.observeAttribute(arg1, any_load_result1_result1_upvr_3.RETURN_SPRING_SPEED_ATTRIBUTE, 20):Subscribe(function(arg1_5) -- Line 222
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (readonly)
		]]
		any_new_result1_2_upvr.s = arg1_5
	end))
	any_new_result1_6_upvr:GiveTask(RunService_upvr.Stepped:Connect(function() -- Line 227
		--[[ Upvalues[3]:
			[1]: any_load_result1_result1_upvr_13 (copied, readonly)
			[2]: any_new_result1_2_upvr (readonly)
			[3]: arg1 (readonly)
		]]
		local any_toCFrame_result1 = any_load_result1_result1_upvr_13.toCFrame(any_new_result1_2_upvr.p)
		if any_toCFrame_result1 then
			arg1.Transform = any_toCFrame_result1
		end
	end))
	arg1.Enabled = false
	any_new_result1_6_upvr:GiveTask(function() -- Line 236
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.Enabled = true
	end)
	return any_new_result1_6_upvr
end
local var1_result1_upvr_3 = any_load_result1("Motor6DStackInterface")
function module_2_upvr.setupRagdollMotor(arg1, arg2, arg3) -- Line 243
	--[[ Upvalues[5]:
		[1]: any_load_result1_result1_upvr_8 (readonly)
		[2]: var1_result1_upvr_3 (readonly)
		[3]: any_load_result1_result1_upvr_6 (readonly)
		[4]: any_load_result1_result1_upvr_3 (readonly)
		[5]: RunService_upvr (readonly)
	]]
	local any_new_result1_5 = any_load_result1_result1_upvr_8.new()
	arg1.Enabled = false
	any_new_result1_5:GiveTask(function() -- Line 247
		--[[ Upvalues[6]:
			[1]: var1_result1_upvr_3 (copied, readonly)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
			[4]: arg3 (readonly)
			[5]: any_load_result1_result1_upvr_6 (copied, readonly)
			[6]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		local any_FindFirstImplementation_result1 = var1_result1_upvr_3:FindFirstImplementation(arg1)
		if any_FindFirstImplementation_result1 then
			any_FindFirstImplementation_result1:TransformFromCFrame(arg2.CFrame * arg1.C0:toObjectSpace(arg3.CFrame * arg1.C1), any_load_result1_result1_upvr_6.getAttribute(arg1, any_load_result1_result1_upvr_3.RETURN_SPRING_SPEED_ATTRIBUTE, 20))
		end
		arg1.Enabled = true
	end)
	any_new_result1_5:GiveTask(RunService_upvr.Stepped:Connect(function() -- Line 259
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.Transform = CFrame.new()
	end))
	return any_new_result1_5
end
function module_2_upvr.suppressJustRootPart(arg1, arg2) -- Line 266
	--[[ Upvalues[7]:
		[1]: module_2_upvr (readonly)
		[2]: any_load_result1_result1_upvr_10 (readonly)
		[3]: var1_result1_upvr_2 (readonly)
		[4]: any_load_result1_result1_upvr_7 (readonly)
		[5]: any_load_result1_result1_upvr (readonly)
		[6]: any_load_result1_result1_upvr_3 (readonly)
		[7]: any_load_result1_result1_upvr_8 (readonly)
	]]
	local any_getFirstRootJointData_result1 = module_2_upvr.getFirstRootJointData(arg2)
	local any_new_result1_3 = any_load_result1_result1_upvr_8.new()
	any_new_result1_3:GiveTask(any_load_result1_result1_upvr_10.observeRigMotorBrio(arg1, any_getFirstRootJointData_result1.partName, any_getFirstRootJointData_result1.motorName):Pipe({var1_result1_upvr_2.switchMapBrio(function(arg1_6) -- Line 270
		--[[ Upvalues[4]:
			[1]: var1_result1_upvr_2 (copied, readonly)
			[2]: any_load_result1_result1_upvr_7 (copied, readonly)
			[3]: any_load_result1_result1_upvr (copied, readonly)
			[4]: any_load_result1_result1_upvr_3 (copied, readonly)
		]]
		local module_5 = {}
		module_5.motor = arg1_6
		module_5.part0 = any_load_result1_result1_upvr_7.observeProperty(arg1_6, "Part0")
		module_5.part1 = any_load_result1_result1_upvr_7.observeProperty(arg1_6, "Part1")
		module_5.isAnimated = any_load_result1_result1_upvr.observeAttribute(arg1_6, any_load_result1_result1_upvr_3.IS_MOTOR_ANIMATED_ATTRIBUTE, false)
		return var1_result1_upvr_2.flatCombineLatest(module_5)
	end)}):Subscribe(function(arg1_7) -- Line 282
		--[[ Upvalues[2]:
			[1]: module_2_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		if arg1_7:IsDead() then
		else
			local any_GetValue_result1 = arg1_7:GetValue()
			local any_ToMaid_result1_2 = arg1_7:ToMaid()
			if not any_GetValue_result1.motor or not any_GetValue_result1.part0 or not any_GetValue_result1.part1 then return end
			if any_GetValue_result1.isAnimated then
				any_ToMaid_result1_2._current = module_2_upvr.setupAnimatedMotor(arg1, any_GetValue_result1.part1)
				return
			end
			any_ToMaid_result1_2._current = module_2_upvr.setupRagdollRootPartMotor(any_GetValue_result1.motor, any_GetValue_result1.part0, any_GetValue_result1.part1)
		end
	end))
	return any_new_result1_3
end
function module_2_upvr.suppressMotors(arg1, arg2, arg3) -- Line 304
	--[[ Upvalues[8]:
		[1]: any_load_result1_result1_upvr_12 (readonly)
		[2]: any_load_result1_result1_upvr_8 (readonly)
		[3]: module_2_upvr (readonly)
		[4]: any_load_result1_result1_upvr_10 (readonly)
		[5]: var1_result1_upvr_2 (readonly)
		[6]: any_load_result1_result1_upvr_7 (readonly)
		[7]: any_load_result1_result1_upvr (readonly)
		[8]: any_load_result1_result1_upvr_3 (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var91 = false
	if typeof(arg1) == "Instance" then
		var91 = arg1:IsA("Model")
	end
	assert(var91, "Bad character")
	assert(any_load_result1_result1_upvr_12.isOfType(Enum.HumanoidRigType, arg2), "Bad rigType")
	for _, v_3_upvr in pairs(module_2_upvr.getMotorData(arg2)) do
		any_load_result1_result1_upvr_8.new():GiveTask(any_load_result1_result1_upvr_10.observeRigMotorBrio(arg1, v_3_upvr.partName, v_3_upvr.motorName):Pipe({var1_result1_upvr_2.switchMapBrio(function(arg1_8) -- Line 312
			--[[ Upvalues[4]:
				[1]: var1_result1_upvr_2 (copied, readonly)
				[2]: any_load_result1_result1_upvr_7 (copied, readonly)
				[3]: any_load_result1_result1_upvr (copied, readonly)
				[4]: any_load_result1_result1_upvr_3 (copied, readonly)
			]]
			local module = {}
			module.motor = arg1_8
			module.part0 = any_load_result1_result1_upvr_7.observeProperty(arg1_8, "Part0")
			module.part1 = any_load_result1_result1_upvr_7.observeProperty(arg1_8, "Part1")
			module.isAnimated = any_load_result1_result1_upvr.observeAttribute(arg1_8, any_load_result1_result1_upvr_3.IS_MOTOR_ANIMATED_ATTRIBUTE, false)
			return var1_result1_upvr_2.flatCombineLatest(module)
		end)}):Subscribe(function(arg1_9) -- Line 322
			--[[ Upvalues[4]:
				[1]: module_2_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: v_3_upvr (readonly)
				[4]: arg3 (readonly)
			]]
			if arg1_9:IsDead() then
			else
				local any_GetValue_result1_upvr = arg1_9:GetValue()
				local any_ToMaid_result1 = arg1_9:ToMaid()
				if not any_GetValue_result1_upvr.motor or not any_GetValue_result1_upvr.part0 or not any_GetValue_result1_upvr.part1 then return end
				if any_GetValue_result1_upvr.isAnimated then
					any_ToMaid_result1._current = module_2_upvr.setupAnimatedMotor(arg1, any_GetValue_result1_upvr.part1)
					return
				end
				if v_3_upvr.isRootJoint then
					any_ToMaid_result1._current = module_2_upvr.setupRagdollRootPartMotor(any_GetValue_result1_upvr.motor, any_GetValue_result1_upvr.part0, any_GetValue_result1_upvr.part1)
				else
					any_ToMaid_result1._current = module_2_upvr.setupRagdollMotor(any_GetValue_result1_upvr.motor, any_GetValue_result1_upvr.part0, any_GetValue_result1_upvr.part1)
				end
				if module_2_upvr.guessIfNetworkOwner(any_GetValue_result1_upvr.part1) then
					task.defer(function() -- Line 346
						--[[ Upvalues[3]:
							[1]: arg3 (copied, readonly)
							[2]: v_3_upvr (copied, readonly)
							[3]: any_GetValue_result1_upvr (readonly)
						]]
						if time() - arg3.readingTimePhysics <= 0.1 then
							local var103 = arg3.rotation[v_3_upvr]
							if var103 then
								local part1_2 = any_GetValue_result1_upvr.part1
								part1_2.RotVelocity += var103
							end
							local var105 = arg3.linear[v_3_upvr]
							if var105 then
								local part1 = any_GetValue_result1_upvr.part1
								part1.Velocity += var105
							end
						end
					end)
				end
			end
		end))
		local var107
	end
	return var107
end
local Players_upvr = game:GetService("Players")
function module_2_upvr.guessIfNetworkOwner(arg1) -- Line 369
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: any_load_result1_result1_upvr_5 (readonly)
	]]
	local var109_upvw
	local LocalPlayer = Players_upvr.LocalPlayer
	local function var111() -- Line 374
		--[[ Upvalues[2]:
			[1]: var109_upvw (read and write)
			[2]: arg1 (readonly)
		]]
		var109_upvw = arg1:GetNetworkOwner()
	end
	if pcall(var111) then
		if var109_upvw ~= LocalPlayer then
			var111 = false
		else
			var111 = true
		end
		return var111
	end
	if any_load_result1_result1_upvr_5.getPlayerFromCharacter(arg1) ~= LocalPlayer then
		var111 = false
	else
		var111 = true
	end
	return var111
end
local any_load_result1_result1_upvr_9 = any_load_result1("Promise")
function module_2_upvr.promiseVelocityRecordings(arg1, arg2) -- Line 384
	--[[ Upvalues[4]:
		[1]: any_load_result1_result1_upvr_12 (readonly)
		[2]: any_load_result1_result1_upvr_9 (readonly)
		[3]: module_2_upvr (readonly)
		[4]: any_load_result1_result1_upvr_4 (readonly)
	]]
	local var148 = false
	if typeof(arg1) == "Instance" then
		var148 = arg1:IsA("Model")
	end
	assert(var148, "Bad character")
	assert(any_load_result1_result1_upvr_12.isOfType(Enum.HumanoidRigType, arg2), "Bad rigType")
	local HumanoidRootPart_upvr = arg1:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart_upvr then
		return any_load_result1_result1_upvr_9.rejected("No humanoid root part")
	end
	for _, v_4 in pairs(module_2_upvr.getMotorData(arg2)) do
		local any_getRigMotor_result1_3 = any_load_result1_result1_upvr_4.getRigMotor(arg1, v_4.partName, v_4.motorName)
		if any_getRigMotor_result1_3 then
			local Part0 = any_getRigMotor_result1_3.Part0
			local Part1 = any_getRigMotor_result1_3.Part1
			if Part0 and Part1 then
				({})[v_4] = {
					motor = any_getRigMotor_result1_3;
					part0 = Part0;
					part1 = Part1;
					relCFrame = HumanoidRootPart_upvr.CFrame:toObjectSpace(Part1.CFrame);
				}
			end
		end
	end
	local tbl_4_upvr = {}
	return any_load_result1_result1_upvr_9.spawn(function(arg1_11, arg2_3) -- Line 412
		--[[ Upvalues[5]:
			[1]: module_2_upvr (copied, readonly)
			[2]: HumanoidRootPart_upvr (readonly)
			[3]: tbl_4_upvr (readonly)
			[4]: any_load_result1_result1_upvr_4 (copied, readonly)
			[5]: arg1 (readonly)
		]]
		local any_yieldUntilStepped_result1_2 = module_2_upvr.yieldUntilStepped()
		local CFrame = HumanoidRootPart_upvr.CFrame
		local tbl_3 = {
			readingTimePhysics = time();
			linear = {};
			rotation = {};
		}
		for i_5, v_5 in pairs(tbl_4_upvr) do
			local any_getRigMotor_result1_5 = any_load_result1_result1_upvr_4.getRigMotor(arg1, i_5.partName, i_5.motorName)
			if v_5.motor == any_getRigMotor_result1_5 and v_5.part0 == any_getRigMotor_result1_5.Part0 and v_5.part1 == any_getRigMotor_result1_5.Part1 then
				tbl_3.linear[i_5] = CFrame:vectorToWorldSpace((CFrame:pointToObjectSpace(v_5.part1.Position) - v_5.relCFrame.p) / any_yieldUntilStepped_result1_2)
				local any_ToEulerAnglesXYZ_result1_2, any_ToEulerAnglesXYZ_result2, any_ToEulerAnglesXYZ_result3_2 = v_5.relCFrame:toObjectSpace(CFrame:toObjectSpace(v_5.part1.CFrame)):ToEulerAnglesXYZ()
				tbl_3.rotation[i_5] = CFrame:vectorToWorldSpace(Vector3.new(any_ToEulerAnglesXYZ_result1_2, any_ToEulerAnglesXYZ_result2, any_ToEulerAnglesXYZ_result3_2)) / any_yieldUntilStepped_result1_2
			end
		end
		arg1_11(tbl_3)
	end)
end
function module_2_upvr.yieldUntilStepped() -- Line 447
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	local var171
	repeat
		RunService_upvr.Stepped:Wait()
		RunService_upvr.Stepped:Wait()
		var171 = time() - time()
	until 0 < var171
	return var171
end
return module_2_upvr