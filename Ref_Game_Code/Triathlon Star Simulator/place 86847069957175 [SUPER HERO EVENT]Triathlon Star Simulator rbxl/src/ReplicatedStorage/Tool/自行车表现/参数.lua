-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:34
-- Luau version 6, Types version 3
-- Time taken: 0.000984 seconds

return {
	ChangePartVt = {{
		LowerTorso = "WaistRigAttachment";
		UpperTorso = "WaistRigAttachment";
	}, {
		LeftHand = "LeftWristRigAttachment";
		LeftLowerArm = "LeftWristRigAttachment";
	}, {
		RightHand = "RightWristRigAttachment";
		RightLowerArm = "RightWristRigAttachment";
	}, {
		LeftLowerArm = "LeftElbowRigAttachment";
		LeftUpperArm = "LeftElbowRigAttachment";
	}, {
		RightLowerArm = "RightElbowRigAttachment";
		RightUpperArm = "RightElbowRigAttachment";
	}, {
		LeftUpperArm = "LeftShoulderRigAttachment";
		UpperTorso = "LeftShoulderRigAttachment";
	}, {
		RightUpperArm = "RightShoulderRigAttachment";
		UpperTorso = "RightShoulderRigAttachment";
	}};
	HigInfoVt = {
		LeftShoulderRigAttachment = {
			Up = 0;
			Down = -90;
		};
		RightShoulderRigAttachment = {
			Up = 0;
			Down = -90;
		};
		LeftElbowRigAttachment = {
			Up = 45;
			Down = -45;
		};
		RightElbowRigAttachment = {
			Up = 45;
			Down = -45;
		};
		LeftWristRigAttachment = {
			Up = 45;
			Down = -45;
		};
		RightWristRigAttachment = {
			Up = 45;
			Down = -45;
		};
	};
	DisableMotor6D = {"LeftWrist", "LeftElbow", "LeftShoulder", "RightWrist", "RightElbow", "RightShoulder"};
	ResetCFramePartVt = {
		LeftLowerArm = CFrame.new(-1.31010222, -0.282374263, 0.102110982);
		LeftLowerLeg = CFrame.new(-0.445670813, -2.32468128, 0.0448719859);
		LeftUpperArm = CFrame.new(-1.19258928, 0.288140297, 0.0190240145);
		LeftUpperLeg = CFrame.new(-0.424465895, -1.42578983, -0.0578525662);
		RightLowerArm = CFrame.new(1.31010222, -0.282374024, 0.10211122);
		RightLowerLeg = CFrame.new(0.445671022, -2.32468152, 0.0448724627);
		RightUpperArm = CFrame.new(1.19258928, 0.288140178, 0.0190242529);
		RightUpperLeg = CFrame.new(0.424466014, -1.42578983, -0.0578523278);
	};
}