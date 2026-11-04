-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:12
-- Luau version 6, Types version 3
-- Time taken: 0.003608 seconds

local module = {}
local function OneLightning_upvr(arg1, arg2, arg3, arg4) -- Line 10, Named "OneLightning"
	arg1.Size = Vector3.new((arg2 - arg3).Magnitude, arg4.Y, arg4.Z)
	arg1:PivotTo(CFrame.lookAt((arg2 + arg3) / 2, arg3):ToWorldSpace(CFrame.Angles(0, (math.pi/2), 0)))
end
local function _(arg1) -- Line 20, Named "CreateLightningPart"
	local Part = Instance.new("Part")
	Part.Shape = Enum.PartType.Cylinder
	Part.Color = arg1
	Part.Material = Enum.Material.Neon
	Part.CanTouch = false
	Part.CanCollide = false
	Part.CanQuery = false
	Part.Anchored = true
	Part.Transparency = 1
	Part.CastShadow = false
	Part.Parent = workspace
	return Part
end
local tbl_upvr = {
	Temp = {
		LightNum = 6;
		LightColor = Color3.new(0.835294, 0.835294, 0);
		LightRandomLenth = 10;
		LightSizeRangeMax = Vector3.new(4, 4, 4);
		LightSizeRangeMin = Vector3.new(0.10000, 0.10000, 0.10000);
		LightTime = 0.5;
		LightFadeTime = 0.2;
		ShowDtTime = 0.05;
	};
	["Solo一技能"] = {
		LightNum = 4;
		LightColor = Color3.new(0.360784, 0.701961, 1);
		LightRandomLenth = 5;
		LightSizeRangeMax = Vector3.new(4, 4, 4);
		LightSizeRangeMin = Vector3.new(0.10000, 0.10000, 0.10000);
		LightTime = 0.2;
		LightFadeTime = 0.2;
		ShowDtTime = 0.05;
	};
	["Solo二技能"] = {
		LightNum = 4;
		LightColor = Color3.new(0.360784, 0.701961, 1);
		LightRandomLenth = 5;
		LightSizeRangeMax = Vector3.new(4, 4, 4);
		LightSizeRangeMin = Vector3.new(0.10000, 0.10000, 0.10000);
		LightTime = 0.3;
		LightFadeTime = 0.2;
		ShowDtTime = 0.025;
	};
	["大佛三技能"] = {
		LightNum = 4;
		LightColor = Color3.new(1, 0.945098, 0.341176);
		LightRandomLenth = 10;
		LightSizeRangeMax = Vector3.new(8, 8, 8);
		LightSizeRangeMin = Vector3.new(0.5, 0.5, 0.5);
		LightTime = 0.4;
		LightFadeTime = 0.7;
		ShowDtTime = 0.0025;
		FreshInterval = 2;
	};
	["怪兽八号二技能"] = {
		LightNum = 4;
		LightColor = Color3.new(0.360784, 0.701961, 1);
		LightRandomLenth = 5;
		LightSizeRangeMax = Vector3.new(4, 4, 4);
		LightSizeRangeMin = Vector3.new(0.10000, 0.10000, 0.10000);
		LightTime = 0.2;
		LightFadeTime = 0.2;
		ShowDtTime = 0.025;
		FreshInterval = 1;
	};
	["怪兽八号三技能"] = {
		LightNum = 4;
		LightColor = Color3.new(0.360784, 0.701961, 1);
		LightRandomLenth = 1.5;
		LightSizeRangeMax = Vector3.new(2, 3, 2);
		LightSizeRangeMin = Vector3.new(0.10000, 0.10000, 0.10000);
		LightTime = 0.25;
		LightFadeTime = 0.2;
		ShowDtTime = 0.025;
		FreshInterval = 1;
	};
	["剑气喷涌"] = {
		LightNum = 4;
		LightColor = Color3.new(0.494118, 0.654902, 1);
		LightRandomLenth = 8;
		LightSizeRangeMax = Vector3.new(4, 4, 4);
		LightSizeRangeMin = Vector3.new(0.10000, 0.10000, 0.10000);
		LightTime = 0.05;
		LightFadeTime = 0.15;
		ShowDtTime = 0.015;
		FreshInterval = 1;
	};
}
local RunService_upvr = game:GetService("RunService")
local Debris_upvr = game:GetService("Debris")
local TweenService_upvr = game:GetService("TweenService")
function module.CreateLightning(arg1, arg2, arg3) -- Line 123
	--[[ Upvalues[5]:
		[1]: tbl_upvr (readonly)
		[2]: RunService_upvr (readonly)
		[3]: Debris_upvr (readonly)
		[4]: TweenService_upvr (readonly)
		[5]: OneLightning_upvr (readonly)
	]]
	if not arg3 then
		local var16 = "Temp"
	end
	local LightNum_upvr = tbl_upvr[var16].LightNum
	local tbl_upvw = {}
	for i = 1, LightNum_upvr do
		local Part_2 = Instance.new("Part")
		Part_2.Shape = Enum.PartType.Cylinder
		Part_2.Color = tbl_upvr[var16].LightColor
		Part_2.Material = Enum.Material.Neon
		Part_2.CanTouch = false
		Part_2.CanCollide = false
		Part_2.CanQuery = false
		Part_2.Anchored = true
		Part_2.Transparency = 1
		Part_2.CastShadow = false
		Part_2.Parent = workspace
		tbl_upvw[i] = Part_2
		local _
	end
	local var22_upvw = 0
	local LightTime_upvr = tbl_upvr[var16].LightTime
	local LightFadeTime_upvr = tbl_upvr[var16].LightFadeTime
	local var25_upvw
	local ShowDtTime_upvr = tbl_upvr[var16].ShowDtTime
	local var27_upvw
	local cframe_looking_at_upvr = CFrame.lookAt(arg1, arg2)
	local LightRandomLenth_upvr = tbl_upvr[var16].LightRandomLenth
	local var30_upvr = (arg1 - arg2).Magnitude / LightNum_upvr
	local LightSizeRangeMin_upvr = tbl_upvr[var16].LightSizeRangeMin
	local LightSizeRangeMax_upvr = tbl_upvr[var16].LightSizeRangeMax
	var25_upvw = RunService_upvr.Heartbeat:Connect(function(arg1_2) -- Line 157
		--[[ Upvalues[16]:
			[1]: var22_upvw (read and write)
			[2]: LightTime_upvr (readonly)
			[3]: LightFadeTime_upvr (readonly)
			[4]: tbl_upvw (read and write)
			[5]: Debris_upvr (copied, readonly)
			[6]: var25_upvw (read and write)
			[7]: ShowDtTime_upvr (readonly)
			[8]: LightNum_upvr (readonly)
			[9]: var27_upvw (read and write)
			[10]: cframe_looking_at_upvr (readonly)
			[11]: LightRandomLenth_upvr (readonly)
			[12]: var30_upvr (readonly)
			[13]: LightSizeRangeMin_upvr (readonly)
			[14]: LightSizeRangeMax_upvr (readonly)
			[15]: TweenService_upvr (copied, readonly)
			[16]: OneLightning_upvr (copied, readonly)
		]]
		if LightTime_upvr + LightFadeTime_upvr <= var22_upvw then
			for _, v in pairs(tbl_upvw) do
				Debris_upvr:AddItem(v, 0)
			end
			tbl_upvw = {}
			var25_upvw:Disconnect()
			var25_upvw = nil
		else
			for i_3 = 1, LightNum_upvr do
				if i_3 <= math.floor(var22_upvw / ShowDtTime_upvr) then
					tbl_upvw[i_3].Transparency = 0
				end
				if i_3 == 1 then
				end
				local any_ToWorldSpace_result1 = cframe_looking_at_upvr:ToWorldSpace(CFrame.new(LightRandomLenth_upvr * (1 - 2 * math.random()), LightRandomLenth_upvr * (1 - 2 * math.random()), -var30_upvr * i_3))
				var27_upvw = any_ToWorldSpace_result1
				local vector3 = Vector3.new(1, LightSizeRangeMin_upvr.Y + math.random() * (LightSizeRangeMax_upvr.Y - LightSizeRangeMin_upvr.Y), LightSizeRangeMin_upvr.Z + math.random() * (LightSizeRangeMax_upvr.Z - LightSizeRangeMin_upvr.Z))
				if LightTime_upvr <= var22_upvw then
					vector3 *= 1 - TweenService_upvr:GetValue(math.clamp(var22_upvw - LightTime_upvr / LightFadeTime_upvr, 0, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				end
				OneLightning_upvr(tbl_upvw[i_3], cframe_looking_at_upvr:ToWorldSpace(CFrame.new(LightRandomLenth_upvr * (1 - 2 * math.random()), LightRandomLenth_upvr * (1 - 2 * math.random()), -var30_upvr * (i_3 - 1))).Position, any_ToWorldSpace_result1.Position, vector3)
			end
			var22_upvw += arg1_2
		end
	end)
end
return module