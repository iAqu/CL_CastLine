-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:05
-- Luau version 6, Types version 3
-- Time taken: 0.019017 seconds

local module_upvr = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris_upvr = game:GetService("Debris")
local TweenService_upvr = game:GetService("TweenService")
local VisibleMgr_upvr = require(ReplicatedStorage.Tool.VisibleMgr)
local RayCast_upvr = require(ReplicatedStorage["特效表现工具"].RayCast)
local tbl_7_upvr = {
	["样式1"] = script["地裂样式1"];
	["样式2"] = script["地裂样式2"];
	["样式3"] = script["地裂蜘蛛网"];
	["样式4"] = script["雪花"];
	["样式5"] = script["描边"];
	["样式6"] = script["字"];
	["样式7"] = script["地裂样式3"];
	["爱心地裂"] = script["爱心地裂"];
}
local tbl_6_upvr = {
	SmallWave = {
		Radius = 5;
		RockSizeMin = Vector3.new(1, 1, 1);
		RockSizeMax = Vector3.new(2, 2, 2);
		RockNum = 15;
		LandBreak = true;
		UpTime = 0.1;
		FloorType = "样式1";
	};
	SmallWave2 = {
		Radius = 6;
		RockSizeMin = Vector3.new(2, 2, 2);
		RockSizeMax = Vector3.new(3.5, 3.5, 3.5);
		RockNum = 15;
		LandBreak = true;
		UpTime = 0.1;
		FloorType = "样式1";
	};
	SmallWave3 = {
		Radius = 11;
		RockSizeMin = Vector3.new(4, 4, 4);
		RockSizeMax = Vector3.new(5.5, 5.5, 5.5);
		LandBreak = true;
		RockNum = 15;
		UpTime = 0.1;
		FloorType = "样式1";
	};
	SmallWave4 = {
		Radius = 8;
		RockSizeMin = Vector3.new(3, 3, 3);
		RockSizeMax = Vector3.new(4.5, 4.5, 4.5);
		LandBreak = true;
		RockNum = 15;
		UpTime = 0.1;
		FloorType = "样式1";
	};
	SmallWave5 = {
		Radius = 2;
		RockSizeMin = Vector3.new(2, 2, 2);
		RockSizeMax = Vector3.new(3, 3, 3);
		RockNum = 6;
		LandBreak = false;
		UpTime = 0.1;
		StayTime = 3.5;
		FadeTime = 1;
		FloorType = "样式1";
	};
	SmallWave6 = {
		Radius = 12;
		RockSizeMin = Vector3.new(6.5, 6.5, 6.5);
		RockSizeMax = Vector3.new(8, 8, 8);
		RockNum = 15;
		LandBreak = true;
		UpTime = 0.1;
		FloorType = "样式2";
	};
	SmallWave7 = {
		Radius = 18;
		RockSizeMin = Vector3.new(4.5, 4.5, 4.5);
		RockSizeMax = Vector3.new(8, 8, 8);
		RockNum = 15;
		LandBreak = true;
		UpTime = 0.1;
		FloorType = "样式7";
	};
	BigWave = {
		Radius = 10;
		RockSizeMin = Vector3.new(4, 4, 4);
		RockSizeMax = Vector3.new(6, 6, 6);
		RockNum = 20;
		LandBreak = true;
		UpTime = 0.1;
		FloorType = "样式1";
	};
	BigWave2 = {
		Radius = 12;
		RockSizeMin = Vector3.new(5, 5, 5);
		RockSizeMax = Vector3.new(7, 7, 7);
		RockNum = 20;
		LandBreak = false;
		UpTime = 0.2;
		FloorType = "样式1";
	};
	SpiderNetWave = {
		Radius = 11;
		RockSizeMin = Vector3.new(4, 4, 4);
		RockSizeMax = Vector3.new(6, 6, 6);
		RockNum = 15;
		LandBreak = true;
		UpTime = 0.1;
		FloorType = "样式3";
		CrushColor = Color3.new(1, 0.164706, 0.164706);
	};
	LoveDecal = {
		Radius = 25;
		RockSizeMin = Vector3.new(4, 4, 4);
		RockSizeMax = Vector3.new(6, 6, 6);
		RockNum = 0;
		LandBreak = true;
		UpTime = 0.1;
		StayTime = 2;
		FloorType = "爱心地裂";
		CrushColor = Color3.new(0, 0, 0);
	};
	Buddha = {
		Radius = 18;
		RockSizeMin = Vector3.new(6.5, 6.5, 6.5);
		RockSizeMax = Vector3.new(8, 8, 8);
		RockNum = 15;
		LandBreak = false;
		UpTime = 0.1;
		FloorType = "样式2";
	};
	Buddha2 = {
		Radius = 6;
		RockSizeMin = Vector3.new(2, 2, 2);
		RockSizeMax = Vector3.new(3, 3, 3);
		RockNum = 15;
		LandBreak = false;
		UpTime = 0.1;
		FloorType = "样式2";
	};
}
function module_upvr.FloorCrush(arg1, arg2, arg3, arg4, arg5) -- Line 152
	--[[ Upvalues[4]:
		[1]: tbl_7_upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	local clone_upvr_2 = tbl_7_upvr[arg5]:Clone()
	VisibleMgr_upvr.UnQueryAll(clone_upvr_2)
	VisibleMgr_upvr.UnCollideAll(clone_upvr_2)
	VisibleMgr_upvr.UnTouchAll(clone_upvr_2)
	VisibleMgr_upvr.AnchoredAll(clone_upvr_2)
	clone_upvr_2:PivotTo(CFrame.new(arg1))
	local var23 = arg4
	if not var23 then
		var23 = workspace
	end
	clone_upvr_2.Parent = var23
	if arg2 then
		clone_upvr_2.Size = arg2
	end
	if arg3 then
		clone_upvr_2.SurfaceGui["裂缝"].ImageColor3 = arg3
	end
	delay(1, function() -- Line 170
		--[[ Upvalues[3]:
			[1]: TweenService_upvr (copied, readonly)
			[2]: clone_upvr_2 (readonly)
			[3]: Debris_upvr (copied, readonly)
		]]
		local any_Create_result1 = TweenService_upvr:Create(clone_upvr_2.SurfaceGui["裂缝"], TweenInfo.new(0.5), {
			ImageTransparency = 1;
		})
		any_Create_result1.Completed:Connect(function() -- Line 174
			--[[ Upvalues[2]:
				[1]: Debris_upvr (copied, readonly)
				[2]: clone_upvr_2 (copied, readonly)
			]]
			Debris_upvr:AddItem(clone_upvr_2, 0)
		end)
		any_Create_result1:Play()
	end)
end
local _____________upvr = script["石块粒子"]
function module_upvr.FlyRocks(arg1, arg2, arg3) -- Line 184
	--[[ Upvalues[3]:
		[1]: _____________upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	local clone_upvr = _____________upvr:Clone()
	local var34 = arg3
	if not var34 then
		var34 = workspace
	end
	clone_upvr.Parent = var34
	VisibleMgr_upvr.UnCollideAll(clone_upvr)
	VisibleMgr_upvr.UnQueryAll(clone_upvr)
	VisibleMgr_upvr.UnTouchAll(clone_upvr)
	clone_upvr.Anchored = true
	clone_upvr:PivotTo(CFrame.new(arg1))
	for _, v in pairs(clone_upvr:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			if arg2 then
				v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, arg2), ColorSequenceKeypoint.new(1, arg2)})
			end
			v:Emit(v.Rate)
		end
	end
	delay(3, function() -- Line 209
		--[[ Upvalues[2]:
			[1]: Debris_upvr (copied, readonly)
			[2]: clone_upvr (readonly)
		]]
		Debris_upvr:AddItem(clone_upvr, 0)
	end)
end
function module_upvr.SpawnShockWave(arg1, arg2, arg3) -- Line 215
	--[[ Upvalues[6]:
		[1]: tbl_6_upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: TweenService_upvr (readonly)
		[6]: Debris_upvr (readonly)
	]]
	if not arg2 then
		local const_string_5 = "SmallWave"
	end
	local RockNum_7 = tbl_6_upvr[const_string_5].RockNum
	local RockSizeMin_6 = tbl_6_upvr[const_string_5].RockSizeMin
	local var91 = tbl_6_upvr[const_string_5].RockSizeMax - RockSizeMin_6
	for i_2 = 1, RockNum_7 do
		local Part_7 = Instance.new("Part", Instance.new("Model"))
		Part_7.Size = RockSizeMin_6 + Vector3.new(var91.X * math.random(), var91.Y * math.random(), var91.Z * math.random())
		Part_7:PivotTo(CFrame.new(arg1) * CFrame.Angles(0, math.rad(i_2 * 360 / RockNum_7), 0):ToWorldSpace(CFrame.new(0, 1 * (1 - 2 * math.random()), -tbl_6_upvr[const_string_5].Radius)) * CFrame.Angles(math.rad(360 * math.random()), 0, math.rad(360 * math.random())))
		local var93_upvr
	end
	VisibleMgr_upvr.UnQueryAll(var93_upvr)
	VisibleMgr_upvr.UnTouchAll(var93_upvr)
	VisibleMgr_upvr.UnCollideAll(var93_upvr)
	VisibleMgr_upvr.AnchoredAll(var93_upvr)
	local var94 = arg3
	if not var94 then
		var94 = workspace
	end
	var93_upvr.Parent = var94
	local pairs_result1_6, pairs_result2_12, pairs_result3_2 = pairs(var93_upvr:GetChildren())
	for i_3, v_2 in pairs_result1_6, pairs_result2_12, pairs_result3_2 do
		if v_2:IsA("BasePart") then
			local any_RayToLand_result1_6 = RayCast_upvr.RayToLand(v_2.Position)
			if any_RayToLand_result1_6 then
				v_2:PivotTo(v_2:GetPivot().Rotation + any_RayToLand_result1_6.Position)
				v_2.Material = any_RayToLand_result1_6.Material
				if any_RayToLand_result1_6.Material == Enum.Material.Plastic then
					v_2.Material = Enum.Material.SmoothPlastic
				end
				if any_RayToLand_result1_6.Instance:IsA("BasePart") then
					v_2.Color = any_RayToLand_result1_6.Instance.Color
					v_2.Transparency = any_RayToLand_result1_6.Instance.Transparency
					v_2.MaterialVariant = any_RayToLand_result1_6.Instance.MaterialVariant
					v_2.Material = any_RayToLand_result1_6.Instance.Material
				end
			end
		end
	end
	local any_RayToLand_result1_3 = RayCast_upvr.RayToLand(arg1)
	local var100
	pairs_result3_2 = arg1
	local var101 = pairs_result3_2
	if any_RayToLand_result1_3 then
		var101 = any_RayToLand_result1_3.Position
		i_3 = any_RayToLand_result1_3.Instance
		var100 = i_3.Color
	end
	module_upvr.FlyRocks(var101, var100, arg3)
	if tbl_6_upvr[const_string_5].LandBreak then
		module_upvr.FloorCrush(var101, Vector3.new(tbl_6_upvr[const_string_5].Radius * 2.3, 0.1, tbl_6_upvr[const_string_5].Radius * 2.3), var100, arg3, tbl_6_upvr[const_string_5].FloorType)
	end
	for _, v_3 in pairs(var93_upvr:GetDescendants()) do
		if v_3:IsA("BasePart") then
			v_3.Position -= Vector3.new(0, math.max(v_3.Size.X, v_3.Size.Y, v_3.Size.Z), 0)
			TweenService_upvr:Create(v_3, TweenInfo.new(tbl_6_upvr[const_string_5].UpTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = v_3.Position;
			}):Play()
		end
	end
	delay(1, function() -- Line 299
		--[[ Upvalues[3]:
			[1]: var93_upvr (readonly)
			[2]: TweenService_upvr (copied, readonly)
			[3]: Debris_upvr (copied, readonly)
		]]
		for _, v_4 in pairs(var93_upvr:GetDescendants()) do
			if v_4:IsA("BasePart") then
				TweenService_upvr:Create(v_4, TweenInfo.new(0.5), {
					Transparency = 1;
					Position = v_4.Position - Vector3.new(0, 1.4 * math.max(v_4.Size.X, v_4.Size.Y, v_4.Size.Z), 0);
				}):Play()
			end
		end
		delay(0.5, function() -- Line 312
			--[[ Upvalues[2]:
				[1]: Debris_upvr (copied, readonly)
				[2]: var93_upvr (copied, readonly)
			]]
			Debris_upvr:AddItem(var93_upvr, 0)
		end)
	end)
end
function module_upvr.SpawnShockWaveAndCrush(arg1, arg2) -- Line 321
	--[[ Upvalues[6]:
		[1]: tbl_6_upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: TweenService_upvr (readonly)
		[6]: Debris_upvr (readonly)
	]]
	if not arg2 then
		local const_string_7 = "SmallWave"
	end
	local RockNum_6 = tbl_6_upvr[const_string_7].RockNum
	local RockSizeMin_7 = tbl_6_upvr[const_string_7].RockSizeMin
	if not tbl_6_upvr[const_string_7].CrushColor then
	end
	local var164 = tbl_6_upvr[const_string_7].RockSizeMax - RockSizeMin_7
	for i_6 = 1, RockNum_6 do
		local Part_2 = Instance.new("Part", Instance.new("Model"))
		Part_2.Size = RockSizeMin_7 + Vector3.new(var164.X * math.random(), var164.Y * math.random(), var164.Z * math.random())
		Part_2:PivotTo(CFrame.new(arg1) * CFrame.Angles(0, math.rad(i_6 * 360 / RockNum_6), 0):ToWorldSpace(CFrame.new(0, 1 * (1 - 2 * math.random()), -tbl_6_upvr[const_string_7].Radius)) * CFrame.Angles(math.rad(360 * math.random()), 0, math.rad(360 * math.random())))
		local var166_upvr
	end
	VisibleMgr_upvr.UnQueryAll(var166_upvr)
	VisibleMgr_upvr.UnTouchAll(var166_upvr)
	VisibleMgr_upvr.UnCollideAll(var166_upvr)
	VisibleMgr_upvr.AnchoredAll(var166_upvr)
	var166_upvr.Parent = workspace
	local pairs_result1_2, pairs_result2_3, pairs_result3_16 = pairs(var166_upvr:GetChildren())
	for i_7, v_5 in pairs_result1_2, pairs_result2_3, pairs_result3_16 do
		if v_5:IsA("BasePart") then
			local any_RayToLand_result1 = RayCast_upvr.RayToLand(v_5.Position)
			if any_RayToLand_result1 then
				v_5:PivotTo(v_5:GetPivot().Rotation + any_RayToLand_result1.Position)
				v_5.Material = any_RayToLand_result1.Material
				if any_RayToLand_result1.Material == Enum.Material.Plastic then
					v_5.Material = Enum.Material.SmoothPlastic
				end
				if any_RayToLand_result1.Instance:IsA("BasePart") then
					v_5.Color = any_RayToLand_result1.Instance.Color
					v_5.Transparency = any_RayToLand_result1.Instance.Transparency
					v_5.MaterialVariant = any_RayToLand_result1.Instance.MaterialVariant
					v_5.Material = any_RayToLand_result1.Instance.Material
				end
			end
		end
	end
	local any_RayToLand_result1_14 = RayCast_upvr.RayToLand(arg1)
	local var172
	pairs_result3_16 = arg1
	local var173 = pairs_result3_16
	if any_RayToLand_result1_14 then
		var173 = any_RayToLand_result1_14.Position
		i_7 = any_RayToLand_result1_14.Instance
		var172 = i_7.Color
	end
	module_upvr.FlyRocks(var173, var172)
	if tbl_6_upvr[const_string_7].LandBreak then
		module_upvr.FloorCrush(var173, Vector3.new(tbl_6_upvr[const_string_7].Radius * 2.7, 0.1, tbl_6_upvr[const_string_7].Radius * 2.3), Color3.new(1, 0.415686, 0.145098), nil, tbl_6_upvr[const_string_7].FloorType)
	end
	for _, v_6 in pairs(var166_upvr:GetDescendants()) do
		if v_6:IsA("BasePart") then
			v_6.Position -= Vector3.new(0, math.max(v_6.Size.X, v_6.Size.Y, v_6.Size.Z), 0)
			TweenService_upvr:Create(v_6, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = v_6.Position;
			}):Play()
		end
	end
	delay(1, function() -- Line 407
		--[[ Upvalues[3]:
			[1]: var166_upvr (readonly)
			[2]: TweenService_upvr (copied, readonly)
			[3]: Debris_upvr (copied, readonly)
		]]
		for _, v_7 in pairs(var166_upvr:GetDescendants()) do
			if v_7:IsA("BasePart") then
				TweenService_upvr:Create(v_7, TweenInfo.new(0.5), {
					Transparency = 1;
					Position = v_7.Position - Vector3.new(0, 1.4 * math.max(v_7.Size.X, v_7.Size.Y, v_7.Size.Z), 0);
				}):Play()
			end
		end
		delay(0.5, function() -- Line 420
			--[[ Upvalues[2]:
				[1]: Debris_upvr (copied, readonly)
				[2]: var166_upvr (copied, readonly)
			]]
			Debris_upvr:AddItem(var166_upvr, 0)
		end)
	end)
end
function module_upvr.SpawnShockWaveAndCrush1(arg1, arg2) -- Line 428
	--[[ Upvalues[6]:
		[1]: tbl_6_upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: TweenService_upvr (readonly)
		[6]: Debris_upvr (readonly)
	]]
	if not arg2 then
		local const_string_2 = "SmallWave"
	end
	local RockNum_5 = tbl_6_upvr[const_string_2].RockNum
	local RockSizeMin = tbl_6_upvr[const_string_2].RockSizeMin
	local var237 = tbl_6_upvr[const_string_2].RockSizeMax - RockSizeMin
	for i_10 = 1, RockNum_5 do
		local Part_5 = Instance.new("Part", Instance.new("Model"))
		Part_5.Size = RockSizeMin + Vector3.new(var237.X * math.random(), var237.Y * math.random(), var237.Z * math.random())
		Part_5:PivotTo(CFrame.new(arg1) * CFrame.Angles(0, math.rad(i_10 * 360 / RockNum_5), 0):ToWorldSpace(CFrame.new(0, 1 * (1 - 2 * math.random()), -tbl_6_upvr[const_string_2].Radius)) * CFrame.Angles(math.rad(360 * math.random()), 0, math.rad(360 * math.random())))
		local var239_upvr
	end
	VisibleMgr_upvr.UnQueryAll(var239_upvr)
	VisibleMgr_upvr.UnTouchAll(var239_upvr)
	VisibleMgr_upvr.UnCollideAll(var239_upvr)
	VisibleMgr_upvr.AnchoredAll(var239_upvr)
	var239_upvr.Parent = workspace
	for i_11, v_8 in pairs(var239_upvr:GetChildren()) do
		if v_8:IsA("BasePart") then
			local any_RayToLand_result1_11 = RayCast_upvr.RayToLand(v_8.Position)
			if any_RayToLand_result1_11 then
				v_8:PivotTo(v_8:GetPivot().Rotation + any_RayToLand_result1_11.Position)
				v_8.Material = any_RayToLand_result1_11.Material
				if any_RayToLand_result1_11.Material == Enum.Material.Plastic then
					v_8.Material = Enum.Material.SmoothPlastic
				end
				if any_RayToLand_result1_11.Instance:IsA("BasePart") then
					v_8.Color = any_RayToLand_result1_11.Instance.Color
					v_8.Transparency = any_RayToLand_result1_11.Instance.Transparency
					v_8.MaterialVariant = any_RayToLand_result1_11.Instance.MaterialVariant
					v_8.Material = any_RayToLand_result1_11.Instance.Material
				end
			end
		end
	end
	local any_RayToLand_result1_8 = RayCast_upvr.RayToLand(arg1 + Vector3.new(0, 5, 0))
	local var245
	local var246 = arg1
	if any_RayToLand_result1_8 then
		var246 = any_RayToLand_result1_8.Position
		i_11 = any_RayToLand_result1_8.Instance
		var245 = i_11.Color
	end
	module_upvr.FlyRocks(var246, var245)
	if tbl_6_upvr[const_string_2].LandBreak then
		module_upvr.FloorCrush(var246, Vector3.new(tbl_6_upvr[const_string_2].Radius * 2.7, 0.1, tbl_6_upvr[const_string_2].Radius * 2.3), Color3.new(1, 0.529412, 0.258824), nil, tbl_6_upvr[const_string_2].FloorType)
	end
	for _, v_9 in pairs(var239_upvr:GetDescendants()) do
		if v_9:IsA("BasePart") then
			v_9.Position -= Vector3.new(0, math.max(v_9.Size.X, v_9.Size.Y, v_9.Size.Z), 0)
			TweenService_upvr:Create(v_9, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = v_9.Position;
			}):Play()
		end
	end
	local var252_upvr = tbl_6_upvr[const_string_2].FadeTime or 0.5
	delay(tbl_6_upvr[const_string_2].StayTime or 1, function() -- Line 514
		--[[ Upvalues[4]:
			[1]: var239_upvr (readonly)
			[2]: TweenService_upvr (copied, readonly)
			[3]: var252_upvr (readonly)
			[4]: Debris_upvr (copied, readonly)
		]]
		for _, v_10 in pairs(var239_upvr:GetDescendants()) do
			if v_10:IsA("BasePart") then
				TweenService_upvr:Create(v_10, TweenInfo.new(var252_upvr), {
					Transparency = 1;
					Position = v_10.Position - Vector3.new(0, 1.4 * math.max(v_10.Size.X, v_10.Size.Y, v_10.Size.Z), 0);
				}):Play()
			end
		end
		delay(var252_upvr, function() -- Line 527
			--[[ Upvalues[2]:
				[1]: Debris_upvr (copied, readonly)
				[2]: var239_upvr (copied, readonly)
			]]
			Debris_upvr:AddItem(var239_upvr, 0)
		end)
	end)
end
function module_upvr.SpawnShockWaveAndCrush2(arg1, arg2, arg3) -- Line 535
	--[[ Upvalues[6]:
		[1]: tbl_6_upvr (readonly)
		[2]: VisibleMgr_upvr (readonly)
		[3]: RayCast_upvr (readonly)
		[4]: module_upvr (readonly)
		[5]: TweenService_upvr (readonly)
		[6]: Debris_upvr (readonly)
	]]
	if not arg2 then
		local const_string_6 = "SmallWave"
	end
	local RockNum_3 = tbl_6_upvr[const_string_6].RockNum
	local RockSizeMin_4 = tbl_6_upvr[const_string_6].RockSizeMin
	local var274 = tbl_6_upvr[const_string_6].RockSizeMax - RockSizeMin_4
	for i_14 = 1, RockNum_3 do
		local Part_6 = Instance.new("Part", Instance.new("Model"))
		Part_6.Size = RockSizeMin_4 + Vector3.new(var274.X * math.random(), var274.Y * math.random(), var274.Z * math.random())
		Part_6:PivotTo(CFrame.new(arg1) * CFrame.Angles(0, math.rad(i_14 * 360 / RockNum_3), 0):ToWorldSpace(CFrame.new(0, 1 * (1 - 2 * math.random()), -tbl_6_upvr[const_string_6].Radius)) * CFrame.Angles(math.rad(360 * math.random()), 0, math.rad(360 * math.random())))
		local var276_upvr
	end
	VisibleMgr_upvr.UnQueryAll(var276_upvr)
	VisibleMgr_upvr.UnTouchAll(var276_upvr)
	VisibleMgr_upvr.UnCollideAll(var276_upvr)
	VisibleMgr_upvr.AnchoredAll(var276_upvr)
	var276_upvr.Parent = workspace
	for _, v_11 in pairs(var276_upvr:GetChildren()) do
		if v_11:IsA("BasePart") then
			local any_RayToLand_result1_10 = RayCast_upvr.RayToLand(v_11.Position)
			if any_RayToLand_result1_10 then
				v_11:PivotTo(v_11:GetPivot().Rotation + any_RayToLand_result1_10.Position)
				v_11.Material = any_RayToLand_result1_10.Material
				if any_RayToLand_result1_10.Material == Enum.Material.Plastic then
					v_11.Material = Enum.Material.SmoothPlastic
				end
				if any_RayToLand_result1_10.Instance:IsA("BasePart") then
					v_11.Color = any_RayToLand_result1_10.Instance.Color
					v_11.Transparency = any_RayToLand_result1_10.Instance.Transparency
					v_11.MaterialVariant = any_RayToLand_result1_10.Instance.MaterialVariant
					v_11.Material = any_RayToLand_result1_10.Instance.Material
				end
			end
		end
	end
	local any_RayToLand_result1_9 = RayCast_upvr.RayToLand(arg1)
	if any_RayToLand_result1_9 then
		_ = any_RayToLand_result1_9.Instance
	end
	if tbl_6_upvr[const_string_6].LandBreak then
		module_upvr.FloorCrush(any_RayToLand_result1_9.Position, Vector3.new(tbl_6_upvr[const_string_6].Radius * 2.7, 0.1, tbl_6_upvr[const_string_6].Radius * 2.7), arg3, nil, tbl_6_upvr[const_string_6].FloorType)
	end
	for _, v_12 in pairs(var276_upvr:GetDescendants()) do
		if v_12:IsA("BasePart") then
			v_12.Position -= Vector3.new(0, math.max(v_12.Size.X, v_12.Size.Y, v_12.Size.Z), 0)
			TweenService_upvr:Create(v_12, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = v_12.Position;
			}):Play()
		end
	end
	local var287_upvr = tbl_6_upvr[const_string_6].FadeTime or 0.5
	delay(tbl_6_upvr[const_string_6].StayTime or 1, function() -- Line 621
		--[[ Upvalues[4]:
			[1]: var276_upvr (readonly)
			[2]: TweenService_upvr (copied, readonly)
			[3]: var287_upvr (readonly)
			[4]: Debris_upvr (copied, readonly)
		]]
		for _, v_13 in pairs(var276_upvr:GetDescendants()) do
			if v_13:IsA("BasePart") then
				TweenService_upvr:Create(v_13, TweenInfo.new(var287_upvr), {
					Transparency = 1;
					Position = v_13.Position - Vector3.new(0, 1.4 * math.max(v_13.Size.X, v_13.Size.Y, v_13.Size.Z), 0);
				}):Play()
			end
		end
		delay(var287_upvr, function() -- Line 634
			--[[ Upvalues[2]:
				[1]: Debris_upvr (copied, readonly)
				[2]: var276_upvr (copied, readonly)
			]]
			Debris_upvr:AddItem(var276_upvr, 0)
		end)
	end)
end
return module_upvr