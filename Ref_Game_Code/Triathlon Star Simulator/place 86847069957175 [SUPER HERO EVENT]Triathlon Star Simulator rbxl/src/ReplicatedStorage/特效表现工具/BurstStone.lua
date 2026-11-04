-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:02
-- Luau version 6, Types version 3
-- Time taken: 0.022146 seconds

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService_upvr = game:GetService("TweenService")
local Debris_upvr = game:GetService("Debris")
local RunService_upvr = game:GetService("RunService")
local RayCast_upvr = require(ReplicatedStorage["特效表现工具"].RayCast)
local BeatBackEffect_upvr = require(ReplicatedStorage["特效表现工具"].BeatBackEffect)
local function StoneRise_upvr(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -- Line 12, Named "StoneRise"
	--[[ Upvalues[3]:
		[1]: RayCast_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	if not arg7 then
	end
	if not arg8 then
	end
	if not arg9 then
	end
	local Part_upvr_2 = Instance.new("Part")
	Part_upvr_2.Anchored = true
	Part_upvr_2.CanTouch = false
	Part_upvr_2.CanQuery = false
	Part_upvr_2.CanCollide = false
	Part_upvr_2.Material = Enum.Material.SmoothPlastic
	Part_upvr_2.Size = arg2
	local var9 = CFrame.new(arg1 + Vector3.new(0, 10, 0)) * CFrame.Angles(math.rad(15 * (1 - 2 * math.random())), math.random() * (-math.pi*2), math.rad(20 * (1 - 2 * math.random())))
	local any_RayToLand_result1_4 = RayCast_upvr.RayToLand(arg1 + Vector3.new(0, 10, 0))
	if any_RayToLand_result1_4 then
		if any_RayToLand_result1_4.Instance:IsA("BasePart") then
			Part_upvr_2.Color = any_RayToLand_result1_4.Instance.Color
		end
		Part_upvr_2.Material = any_RayToLand_result1_4.Material
		if Part_upvr_2.Material == Enum.Material.Plastic then
			Part_upvr_2.Material = Enum.Material.SmoothPlastic
		end
		if any_RayToLand_result1_4.Instance.MaterialVariant then
			Part_upvr_2.MaterialVariant = any_RayToLand_result1_4.Instance.MaterialVariant
		end
		Part_upvr_2.CastShadow = false
		var9 = var9.Rotation + any_RayToLand_result1_4.Position
	end
	local var11 = (2.5 + 0.5 * math.random()) * (arg2.X + arg2.Y + arg2.Z) / 3
	Part_upvr_2:PivotTo(var9 - Vector3.new(0, var11, 0))
	Part_upvr_2.Parent = workspace
	local any_Create_result1_2 = TweenService_upvr:Create(Part_upvr_2, TweenInfo.new(arg3, arg5, arg6), {
		CFrame = var9;
	})
	local any_Create_result1_4_upvr = TweenService_upvr:Create(Part_upvr_2, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		CFrame = var9 - Vector3.new(0, var11, 0);
	})
	any_Create_result1_4_upvr.Completed:Connect(function() -- Line 61
		--[[ Upvalues[2]:
			[1]: Debris_upvr (copied, readonly)
			[2]: Part_upvr_2 (readonly)
		]]
		Debris_upvr:AddItem(Part_upvr_2, 0)
	end)
	any_Create_result1_2.Completed:Connect(function() -- Line 65
		--[[ Upvalues[2]:
			[1]: arg4 (readonly)
			[2]: any_Create_result1_4_upvr (readonly)
		]]
		delay(arg4, function() -- Line 66
			--[[ Upvalues[1]:
				[1]: any_Create_result1_4_upvr (copied, readonly)
			]]
			any_Create_result1_4_upvr:Play()
		end)
	end)
	any_Create_result1_2:Play()
end
local function StoneFly_upvr(arg1, arg2, arg3, arg4) -- Line 74, Named "StoneFly"
	--[[ Upvalues[3]:
		[1]: RayCast_upvr (readonly)
		[2]: BeatBackEffect_upvr (readonly)
		[3]: Debris_upvr (readonly)
	]]
	local Part_upvr = Instance.new("Part")
	Part_upvr.Anchored = true
	Part_upvr.CanTouch = false
	Part_upvr.CanQuery = false
	Part_upvr.CanCollide = false
	Part_upvr.Material = Enum.Material.SmoothPlastic
	Part_upvr.Size = arg2
	local any_RayToLand_result1_2 = RayCast_upvr.RayToLand(arg1 + Vector3.new(0, 10, 0))
	if any_RayToLand_result1_2 then
		if any_RayToLand_result1_2.Instance:IsA("BasePart") then
			Part_upvr.Color = any_RayToLand_result1_2.Instance.Color
		end
		Part_upvr.Material = any_RayToLand_result1_2.Material
		if Part_upvr.Material == Enum.Material.Plastic then
			Part_upvr.Material = Enum.Material.SmoothPlastic
		end
		if any_RayToLand_result1_2.Instance.MaterialVariant then
			Part_upvr.MaterialVariant = any_RayToLand_result1_2.Instance.MaterialVariant
		end
		Part_upvr.CastShadow = false
	end
	Part_upvr.Parent = workspace
	Part_upvr:PivotTo(CFrame.new(arg1) * CFrame.Angles((-math.pi*2) * math.random(), 0, (-math.pi*2) * math.random()))
	Part_upvr.Anchored = false
	BeatBackEffect_upvr.Kick_Model_Back(Part_upvr, Vector3.new(1 - 2 * math.random(), 4, 1 - 2 * math.random()).Unit, 0.1, arg4, Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 0))
	delay(arg3, function() -- Line 108
		--[[ Upvalues[2]:
			[1]: Debris_upvr (copied, readonly)
			[2]: Part_upvr (readonly)
		]]
		Debris_upvr:AddItem(Part_upvr, 0)
	end)
end
function module.CreateShock(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 115
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: StoneFly_upvr (readonly)
		[4]: StoneRise_upvr (readonly)
	]]
	local var23_upvw = 0
	local var24_upvw = 0
	local var25_upvw
	local var26_upvw = 0
	var25_upvw = RunService_upvr.RenderStepped:Connect(function(arg1_2) -- Line 123
		--[[ Upvalues[13]:
			[1]: var23_upvw (read and write)
			[2]: arg6 (readonly)
			[3]: TweenService_upvr (copied, readonly)
			[4]: var24_upvw (read and write)
			[5]: var25_upvw (read and write)
			[6]: var26_upvw (read and write)
			[7]: arg5 (readonly)
			[8]: arg1 (readonly)
			[9]: arg3 (readonly)
			[10]: arg4 (readonly)
			[11]: arg2 (readonly)
			[12]: StoneFly_upvr (copied, readonly)
			[13]: StoneRise_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		if arg6 <= var23_upvw and 0 < var24_upvw then
			var25_upvw:Disconnect()
			var25_upvw = nil
		else
			if arg6 <= var23_upvw then
				var24_upvw += 1
			end
			while var26_upvw / arg5 <= TweenService_upvr:GetValue(math.clamp(var23_upvw / arg6, 0, 1), Enum.EasingStyle.Circular, Enum.EasingDirection.Out) do
				var26_upvw += 1
				local var31 = arg1:ToWorldSpace(CFrame.new(arg3, 0, 0)) * CFrame.Angles(0, math.rad(arg4), 0):ToWorldSpace(CFrame.new(0, 0, -arg2 * var26_upvw / arg5))
				local var32 = arg1:ToWorldSpace(CFrame.new(-arg3, 0, 0)) * CFrame.Angles(0, math.rad(-arg4), 0):ToWorldSpace(CFrame.new(0, 0, -arg2 * var26_upvw / arg5))
				local var33 = Vector3.new(0.69999, 0.69999, 0.69999) + (Vector3.new(7, 7, 7) - Vector3.new(0.69999, 0.69999, 0.69999)) * TweenService_upvr:GetValue(math.clamp(var26_upvw / arg5, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.In)
				StoneFly_upvr((var31.Position + var32.Position) / 2 + Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()), Vector3.new(2, 2, 2), 3, 160 + 100 * math.random())
				StoneFly_upvr((var31.Position + var32.Position) / 2 + Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()), Vector3.new(2, 2, 2), 3, 160 + 100 * math.random())
				StoneRise_upvr(var31.Position, var33, 0.1, 2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				StoneRise_upvr(var32.Position, var33, 0.1, 2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				if var26_upvw == arg5 then
					for _ = 1, 12 do
						StoneFly_upvr((var31.Position + var32.Position) / 2 + Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()), Vector3.new(3, 3, 3) + Vector3.new(1, 1, 1) * math.random(), 3, 250 + 100 * math.random())
						local _
					end
				end
			end
			var23_upvw += arg1_2
		end
	end)
end
local tbl_upvr_2 = {
	Temp = {
		MaxSize = Vector3.new(9, 9, 9);
		MinSize = Vector3.new(0.69999, 0.69999, 0.69999);
		ShockLenth = 30;
		StoneNum = 8;
		RiseTime = 0.2;
		WholeTime = 0.2;
		RiseStoneLifeTime = 2;
		RiseStoneDisapearTime = 1;
		RiseStoneDisapearStyle = Enum.EasingStyle.Linear;
		RiseStoneDisapearDir = Enum.EasingDirection.In;
		RiseStoneSpawnCFrameOffset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
		FlyMaxSize = Vector3.new(3, 3, 3);
		FlyMinSize = Vector3.new(2, 2, 2);
		FlyStoneLifeTime = 3;
		FlyStoneForce = 160;
		FlyStoneForceRandomRange = 60;
	};
	["单条向左偏移石块"] = {
		MaxSize = Vector3.new(10, 10, 10);
		MinSize = Vector3.new(3, 3, 3);
		ShockLenth = 50;
		StoneNum = 10;
		RiseTime = 0.3;
		WholeTime = 0.4;
		RiseStoneLifeTime = 1.5;
		RiseStoneDisapearTime = 0.4;
		RiseStoneDisapearStyle = Enum.EasingStyle.Back;
		RiseStoneDisapearDir = Enum.EasingDirection.In;
		RiseStoneSpawnCFrameOffset = CFrame.new(0, 0, 0) * CFrame.Angles(0, -0.13962634015954636, 0);
		FlyMaxSize = Vector3.new(5, 5, 5);
		FlyMinSize = Vector3.new(2, 2, 2);
		FlyStoneLifeTime = 2;
		FlyStoneForce = 250;
		FlyStoneForceRandomRange = 60;
	};
	["单条向右偏移石块"] = {
		MaxSize = Vector3.new(10, 10, 10);
		MinSize = Vector3.new(3, 3, 3);
		ShockLenth = 50;
		StoneNum = 10;
		RiseTime = 0.3;
		WholeTime = 0.4;
		RiseStoneLifeTime = 1.5;
		RiseStoneDisapearTime = 0.4;
		RiseStoneDisapearStyle = Enum.EasingStyle.Back;
		RiseStoneDisapearDir = Enum.EasingDirection.In;
		RiseStoneSpawnCFrameOffset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0.13962634015954636, 0);
		FlyMaxSize = Vector3.new(5, 5, 5);
		FlyMinSize = Vector3.new(2, 2, 2);
		FlyStoneLifeTime = 2;
		FlyStoneForce = 250;
		FlyStoneForceRandomRange = 60;
	};
}
function module.CreateShockOneSide(arg1, arg2) -- Line 233
	--[[ Upvalues[5]:
		[1]: tbl_upvr_2 (readonly)
		[2]: RunService_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: StoneFly_upvr (readonly)
		[5]: StoneRise_upvr (readonly)
	]]
	local var39_upvr = tbl_upvr_2[arg2]
	local var41_upvw = 0
	local var42_upvw = 0
	local var43_upvw
	local var44_upvw = 0
	local any_ToWorldSpace_result1_2_upvw = arg1:ToWorldSpace(var39_upvr.RiseStoneSpawnCFrameOffset)
	local MinSize_upvr = var39_upvr.MinSize
	local MaxSize_upvr = var39_upvr.MaxSize
	var43_upvw = RunService_upvr.RenderStepped:Connect(function(arg1_3) -- Line 246
		--[[ Upvalues[11]:
			[1]: var41_upvw (read and write)
			[2]: var39_upvr (readonly)
			[3]: TweenService_upvr (copied, readonly)
			[4]: var42_upvw (read and write)
			[5]: var43_upvw (read and write)
			[6]: var44_upvw (read and write)
			[7]: any_ToWorldSpace_result1_2_upvw (read and write)
			[8]: MinSize_upvr (readonly)
			[9]: MaxSize_upvr (readonly)
			[10]: StoneFly_upvr (copied, readonly)
			[11]: StoneRise_upvr (copied, readonly)
		]]
		if var39_upvr.WholeTime <= var41_upvw and 0 < var42_upvw then
			var43_upvw:Disconnect()
			var43_upvw = nil
		else
			if var39_upvr.WholeTime <= var41_upvw then
				var42_upvw += 1
			end
			while var44_upvw / var39_upvr.StoneNum <= TweenService_upvr:GetValue(math.clamp(var41_upvw / var39_upvr.WholeTime, 0, 1), Enum.EasingStyle.Circular, Enum.EasingDirection.Out) do
				var44_upvw += 1
				local any_ToWorldSpace_result1 = any_ToWorldSpace_result1_2_upvw:ToWorldSpace(CFrame.new(0, 0, -var39_upvr.ShockLenth * var44_upvw / var39_upvr.StoneNum))
				StoneFly_upvr(any_ToWorldSpace_result1.Position + Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()), var39_upvr.FlyMinSize + (var39_upvr.FlyMaxSize - var39_upvr.FlyMinSize) * math.random(), var39_upvr.FlyStoneLifeTime, var39_upvr.FlyStoneForce + var39_upvr.FlyStoneForceRandomRange * math.random())
				StoneRise_upvr(any_ToWorldSpace_result1.Position, MinSize_upvr + (MaxSize_upvr - MinSize_upvr) * TweenService_upvr:GetValue(math.clamp(var44_upvw / var39_upvr.StoneNum, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.In), var39_upvr.RiseTime, var39_upvr.RiseStoneLifeTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, var39_upvr.RiseStoneDisapearTime, var39_upvr.RiseStoneDisapearStyle, var39_upvr.RiseStoneDisapearDir)
			end
			var41_upvw += arg1_3
		end
	end)
end
function module.CreateShockBothSides(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 286
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: StoneFly_upvr (readonly)
		[4]: StoneRise_upvr (readonly)
	]]
	local var50_upvw = 0
	local var51_upvw = 0
	local var52_upvw
	local var53_upvw = 0
	var52_upvw = RunService_upvr.RenderStepped:Connect(function(arg1_4) -- Line 294
		--[[ Upvalues[13]:
			[1]: var50_upvw (read and write)
			[2]: arg6 (readonly)
			[3]: TweenService_upvr (copied, readonly)
			[4]: var51_upvw (read and write)
			[5]: var52_upvw (read and write)
			[6]: var53_upvw (read and write)
			[7]: arg5 (readonly)
			[8]: arg1 (readonly)
			[9]: arg3 (readonly)
			[10]: arg4 (readonly)
			[11]: arg2 (readonly)
			[12]: StoneFly_upvr (copied, readonly)
			[13]: StoneRise_upvr (copied, readonly)
		]]
		if arg6 <= var50_upvw and 0 < var51_upvw then
			var52_upvw:Disconnect()
			var52_upvw = nil
		else
			if arg6 <= var50_upvw then
				var51_upvw += 1
			end
			while var53_upvw / arg5 <= TweenService_upvr:GetValue(math.clamp(var50_upvw / arg6, 0, 1), Enum.EasingStyle.Circular, Enum.EasingDirection.Out) do
				var53_upvw += 1
				local var54 = arg1:ToWorldSpace(CFrame.new(arg3, 0, 0)) * CFrame.Angles(0, math.rad(arg4), 0):ToWorldSpace(CFrame.new(0, 0, -arg2 * var53_upvw / arg5))
				local var55 = arg1:ToWorldSpace(CFrame.new(-arg3, 0, 0)) * CFrame.Angles(0, math.rad(-arg4), 0):ToWorldSpace(CFrame.new(0, 0, -arg2 * var53_upvw / arg5))
				local var56 = Vector3.new(5, 5, 5) + (Vector3.new(7, 7, 7) - Vector3.new(5, 5, 5)) * TweenService_upvr:GetValue(math.clamp(var53_upvw / arg5, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.In)
				StoneFly_upvr((var54.Position + var55.Position) / 2 + Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()), Vector3.new(3, 3, 3), 3, 250 + 100 * math.random())
				StoneFly_upvr((var54.Position + var55.Position) / 2 + Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 1 - 2 * math.random()), Vector3.new(3, 3, 3), 3, 250 + 100 * math.random())
				StoneRise_upvr(var54.Position, var56, 0.1, 2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				StoneRise_upvr(var55.Position, var56, 0.1, 2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			end
			var50_upvw += arg1_4
		end
	end)
end
function module.CreateShockBothSidesSmallStone(arg1, arg2, arg3, arg4, arg5, arg6) -- Line 344
	--[[ Upvalues[3]:
		[1]: RunService_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: StoneRise_upvr (readonly)
	]]
	local var58_upvw = 0
	local var59_upvw = 0
	local var60_upvw
	local var61_upvw = 0
	var60_upvw = RunService_upvr.RenderStepped:Connect(function(arg1_5) -- Line 352
		--[[ Upvalues[12]:
			[1]: var58_upvw (read and write)
			[2]: arg6 (readonly)
			[3]: TweenService_upvr (copied, readonly)
			[4]: var59_upvw (read and write)
			[5]: var60_upvw (read and write)
			[6]: var61_upvw (read and write)
			[7]: arg5 (readonly)
			[8]: arg1 (readonly)
			[9]: arg3 (readonly)
			[10]: arg4 (readonly)
			[11]: arg2 (readonly)
			[12]: StoneRise_upvr (copied, readonly)
		]]
		if arg6 <= var58_upvw and 0 < var59_upvw then
			var60_upvw:Disconnect()
			var60_upvw = nil
		else
			if arg6 <= var58_upvw then
				var59_upvw += 1
			end
			while var61_upvw / arg5 <= TweenService_upvr:GetValue(math.clamp(var58_upvw / arg6, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out) do
				var61_upvw += 1
				local var62 = Vector3.new(3, 3, 3) + (Vector3.new(5, 5, 5) - Vector3.new(3, 3, 3)) * TweenService_upvr:GetValue(math.clamp(var61_upvw / arg5, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.In)
				StoneRise_upvr((arg1:ToWorldSpace(CFrame.new(arg3, 0, 0)) * CFrame.Angles(0, math.rad(arg4), 0):ToWorldSpace(CFrame.new(0, 0, -arg2 * var61_upvw / arg5))).Position, var62, 0.1, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				StoneRise_upvr((arg1:ToWorldSpace(CFrame.new(-arg3, 0, 0)) * CFrame.Angles(0, math.rad(-arg4), 0):ToWorldSpace(CFrame.new(0, 0, -arg2 * var61_upvw / arg5))).Position, var62, 0.1, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			end
			var58_upvw += arg1_5
		end
	end)
end
local tbl_upvr = {
	Temp = {{
		MinSize = Vector3.new(3, 3, 3);
		MaxSize = Vector3.new(4, 4, 4);
		SpawnOffset = Vector3.new(8, 1, 8);
		Force = 480;
		ForceOffset = 40;
		StoneNum = 10;
		StayTime = 3;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(2, 2, 2);
		MaxSize = Vector3.new(3, 3, 3);
		SpawnOffset = Vector3.new(16, 1, 16);
		Force = 420;
		ForceOffset = 40;
		StoneNum = 10;
		StayTime = 2.5;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(1, 1, 1);
		MaxSize = Vector3.new(2, 2, 2);
		SpawnOffset = Vector3.new(25, 1, 25);
		Force = 340;
		ForceOffset = 30;
		StoneNum = 20;
		StayTime = 2;
		CanCollide = true;
	}};
	["小块石头飞起"] = {{
		MinSize = Vector3.new(1.5, 1.5, 1.5);
		MaxSize = Vector3.new(2.5, 2.5, 2.5);
		SpawnOffset = Vector3.new(5, 1, 5);
		Force = 380;
		ForceOffset = 40;
		StoneNum = 5;
		StayTime = 3;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(1.5, 1.5, 1.5);
		MaxSize = Vector3.new(1, 1, 1);
		SpawnOffset = Vector3.new(12, 1, 12);
		Force = 320;
		ForceOffset = 40;
		StoneNum = 5;
		StayTime = 2.5;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(0.5, 0.5, 0.5);
		MaxSize = Vector3.new(1, 1, 1);
		SpawnOffset = Vector3.new(18, 1, 18);
		Force = 240;
		ForceOffset = 30;
		StoneNum = 10;
		StayTime = 2;
		CanCollide = true;
	}};
	["小块石头飞起_偏大"] = {{
		MinSize = Vector3.new(2.5, 2.5, 2.5);
		MaxSize = Vector3.new(3.29999, 3.29999, 3.29999);
		SpawnOffset = Vector3.new(7, 1, 7);
		Force = 250;
		ForceOffset = 40;
		StoneNum = 3;
		StayTime = 3;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(2.5, 2.5, 2.5);
		MaxSize = Vector3.new(3, 3, 3);
		SpawnOffset = Vector3.new(10, 1, 10);
		Force = 300;
		ForceOffset = 40;
		StoneNum = 5;
		StayTime = 2.5;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(1.5, 1.5, 1.5);
		MaxSize = Vector3.new(2.5, 2.5, 2.5);
		SpawnOffset = Vector3.new(16, 1, 16);
		Force = 350;
		ForceOffset = 30;
		StoneNum = 10;
		StayTime = 2;
		CanCollide = true;
	}};
	["小块石头飞起_砸地"] = {{
		MinSize = Vector3.new(1, 1, 1);
		MaxSize = Vector3.new(3, 3, 3);
		SpawnOffset = Vector3.new(7, 1, 7);
		Force = 150;
		ForceOffset = 40;
		StoneNum = 7;
		StayTime = 3;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(2, 2, 2);
		MaxSize = Vector3.new(2.5, 2.5, 2.5);
		SpawnOffset = Vector3.new(10, 1, 10);
		Force = 200;
		ForceOffset = 40;
		StoneNum = 7;
		StayTime = 2.5;
		CanCollide = true;
	}};
	["两圈石头飞起"] = {{
		MinSize = Vector3.new(2.5, 2.5, 2.5);
		MaxSize = Vector3.new(3.29999, 3.29999, 3.29999);
		SpawnOffset = Vector3.new(5, 1, 5);
		Force = 250;
		ForceOffset = 40;
		StoneNum = 2;
		StayTime = 3;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(1, 1, 1);
		MaxSize = Vector3.new(2.5, 2.5, 2.5);
		SpawnOffset = Vector3.new(9, 1, 9);
		Force = 350;
		ForceOffset = 40;
		StoneNum = 7;
		StayTime = 2.5;
		CanCollide = true;
	}};
	["小块石头飞起_偏小"] = {{
		MinSize = Vector3.new(1.5, 1.5, 1.5);
		MaxSize = Vector3.new(2, 2, 2);
		SpawnOffset = Vector3.new(15, 1, 15);
		Force = 300;
		ForceOffset = 20;
		StoneNum = 3;
		StayTime = 2.5;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(1, 1, 1);
		MaxSize = Vector3.new(1.5, 1.5, 1.5);
		SpawnOffset = Vector3.new(10, 1, 10);
		Force = 400;
		ForceOffset = 10;
		StoneNum = 6;
		StayTime = 2;
		CanCollide = true;
	}};
	["小块石头飞起_均匀"] = {{
		MinSize = Vector3.new(1.5, 1.5, 1.5);
		MaxSize = Vector3.new(2.5, 2.5, 2.5);
		SpawnOffset = Vector3.new(15, 1, 15);
		Force = 150;
		ForceOffset = 20;
		StoneNum = 5;
		StayTime = 2.5;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(1, 1, 1);
		MaxSize = Vector3.new(1.5, 1.5, 1.5);
		SpawnOffset = Vector3.new(10, 1, 10);
		Force = 250;
		ForceOffset = 10;
		StoneNum = 8;
		StayTime = 2;
		CanCollide = true;
	}};
	["石头飞起_均匀"] = {{
		MinSize = Vector3.new(1.5, 1.5, 1.5);
		MaxSize = Vector3.new(2.5, 2.5, 2.5);
		SpawnOffset = Vector3.new(25, 1, 25);
		Force = 150;
		ForceOffset = 100;
		StoneNum = 5;
		StayTime = 2.5;
		CanCollide = true;
	}, {
		MinSize = Vector3.new(1, 1, 1);
		MaxSize = Vector3.new(1.5, 1.5, 1.5);
		SpawnOffset = Vector3.new(15, 1, 15);
		Force = 200;
		ForceOffset = 100;
		StoneNum = 8;
		StayTime = 2;
		CanCollide = true;
	}};
}
function module.CreateStoneFly(arg1, arg2) -- Line 614
	--[[ Upvalues[5]:
		[1]: tbl_upvr (readonly)
		[2]: RayCast_upvr (readonly)
		[3]: BeatBackEffect_upvr (readonly)
		[4]: TweenService_upvr (readonly)
		[5]: Debris_upvr (readonly)
	]]
	if not arg2 then
		local const_string_upvw = "Temp"
	end
	local len_upvr = #tbl_upvr[const_string_upvw]
	local module_upvr = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule", math.huge):WaitForChild("CameraModule"):WaitForChild("ZoomController"):WaitForChild("Popper"))
	task.spawn(function() -- Line 624
		--[[ Upvalues[9]:
			[1]: len_upvr (readonly)
			[2]: tbl_upvr (copied, readonly)
			[3]: const_string_upvw (read and write)
			[4]: module_upvr (readonly)
			[5]: arg1 (readonly)
			[6]: RayCast_upvr (copied, readonly)
			[7]: BeatBackEffect_upvr (copied, readonly)
			[8]: TweenService_upvr (copied, readonly)
			[9]: Debris_upvr (copied, readonly)
		]]
		for i = 1, len_upvr do
			local var97 = tbl_upvr[const_string_upvw][i]
			for _ = 1, var97.StoneNum do
				local Part_upvr_4 = Instance.new("Part")
				Part_upvr_4.Anchored = true
				Part_upvr_4.CanTouch = false
				Part_upvr_4.CanQuery = false
				Part_upvr_4.CanCollide = false
				Part_upvr_4.Material = Enum.Material.SmoothPlastic
				Part_upvr_4.Size = var97.MinSize + Vector3.new(var97.MinSize.X + math.random() * (var97.MaxSize.X - var97.MinSize.X), var97.MinSize.Y + math.random() * (var97.MaxSize.Y - var97.MinSize.Y), var97.MinSize.Z + math.random() * (var97.MaxSize.Z - var97.MinSize.Z))
				Part_upvr_4.Parent = workspace
				if var97.CanCollide then
					module_upvr.AddToCameraBlackList(Part_upvr_4)
					Part_upvr_4.CanCollide = true
					Part_upvr_4.CollisionGroup = "Player"
				end
				local any_ToWorldSpace_result1_4 = CFrame.new(arg1.Position):ToWorldSpace(CFrame.new(var97.SpawnOffset.X * (1 - 2 * math.random()), var97.SpawnOffset.Y * (1 - 2 * math.random()), var97.SpawnOffset.Z * (1 - 2 * math.random())))
				local any_RayToLand_result1 = RayCast_upvr.RayToLand(any_ToWorldSpace_result1_4.Position + Vector3.new(0, 3, 0))
				if any_RayToLand_result1 then
					if any_RayToLand_result1.Instance:IsA("BasePart") then
						Part_upvr_4.Color = any_RayToLand_result1.Instance.Color
					end
					Part_upvr_4.Material = any_RayToLand_result1.Material
					if Part_upvr_4.Material == Enum.Material.Plastic then
						Part_upvr_4.Material = Enum.Material.SmoothPlastic
					end
					if any_RayToLand_result1.Instance.MaterialVariant then
						Part_upvr_4.MaterialVariant = any_RayToLand_result1.Instance.MaterialVariant
					end
					Part_upvr_4.CastShadow = false
				end
				Part_upvr_4:PivotTo(any_ToWorldSpace_result1_4)
				Part_upvr_4.Anchored = false
				BeatBackEffect_upvr.Kick_Model_Back(Part_upvr_4, ((any_ToWorldSpace_result1_4.Position - arg1.Position).Unit + Vector3.new(0, 10, 0)).Unit, 0.1, var97.Force + (1 - 2 * math.random()) * var97.ForceOffset, Vector3.new(1 - 2 * math.random(), 1 - 2 * math.random(), 0))
				delay(var97.StayTime, function() -- Line 677
					--[[ Upvalues[3]:
						[1]: TweenService_upvr (copied, readonly)
						[2]: Part_upvr_4 (readonly)
						[3]: Debris_upvr (copied, readonly)
					]]
					local any_Create_result1_3 = TweenService_upvr:Create(Part_upvr_4, TweenInfo.new(0.1), {
						Transparency = 1;
					})
					any_Create_result1_3.Completed:Connect(function() -- Line 679
						--[[ Upvalues[2]:
							[1]: Debris_upvr (copied, readonly)
							[2]: Part_upvr_4 (copied, readonly)
						]]
						Debris_upvr:AddItem(Part_upvr_4, 0)
					end)
					any_Create_result1_3:Play()
				end)
			end
		end
	end)
end
local tbl_upvr_3 = {
	Temp = {{
		MinSize = Vector3.new(5, 2, 5);
		MaxSize = Vector3.new(7, 3, 7);
		PositionOffset = Vector3.new(0, -0.8000, -9);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.10471, 0, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 5;
		Delay = 0;
		LifeTime = 2;
	}, {
		MinSize = Vector3.new(6, 2, 6);
		MaxSize = Vector3.new(7, 3, 7);
		PositionOffset = Vector3.new(0, -1.5, -18);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.26179, 0, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 9;
		Delay = 0.03;
		LifeTime = 2;
	}, {
		MinSize = Vector3.new(7, 1.5, 6);
		MaxSize = Vector3.new(9, 2.5, 9);
		PositionOffset = Vector3.new(0, -1.5, -28);
		PositionRamdomOffset = Vector3.new(3, 0.5, 3);
		AngleOffset = Vector3.new(0.34906, 0, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.05;
		LifeTime = 2;
	}};
	Temp1 = {{
		MinSize = Vector3.new(1.5, 0.5, 1.5);
		MaxSize = Vector3.new(2.5, 1.5, 2.5);
		PositionOffset = Vector3.new(0, -0.8000, -4);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.10471, 0, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 5;
		Delay = 0;
		LifeTime = 2;
	}, {
		MinSize = Vector3.new(2.5, 1.5, 2.5);
		MaxSize = Vector3.new(4, 2, 4);
		PositionOffset = Vector3.new(0, -1.5, -10);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.26179, 0, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 9;
		Delay = 0.03;
		LifeTime = 2;
	}, {
		MinSize = Vector3.new(4, 2, 4);
		MaxSize = Vector3.new(6, 2.5, 6);
		PositionOffset = Vector3.new(0, -1.5, -16);
		PositionRamdomOffset = Vector3.new(3, 0.5, 3);
		AngleOffset = Vector3.new(0.34906, 0, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.05;
		LifeTime = 2;
	}};
	Temp2 = {{
		MinSize = Vector3.new(1.5, 0.5, 1.5);
		MaxSize = Vector3.new(2.5, 1.5, 2.5);
		PositionOffset = Vector3.new(0, -0.8000, -4);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.10471, 0, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 5;
		Delay = 0;
		LifeTime = 2;
	}, {
		MinSize = Vector3.new(2.5, 1.5, 2.5);
		MaxSize = Vector3.new(4, 2, 4);
		PositionOffset = Vector3.new(0, -1.5, -10);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.26179, 0, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 9;
		Delay = 0.03;
		LifeTime = 2;
	}};
	["闪闪地裂"] = {{
		MinSize = Vector3.new(1.5, 1.5, 0.5);
		MaxSize = Vector3.new(2.5, 2.5, 1.5);
		PositionOffset = Vector3.new(0, -0.8000, -13);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.03;
		LifeTime = 1.5;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(3, 2, 2);
		MaxSize = Vector3.new(4, 2.5, 3);
		PositionOffset = Vector3.new(0, -1.5, -20);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(-0.5235, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.13;
		LifeTime = 1.5;
		ScaleOutTime = 3;
	}};
	["闪闪二技能地裂"] = {{
		MinSize = Vector3.new(4.5, 3, 1.5);
		MaxSize = Vector3.new(6, 3, 2.5);
		PositionOffset = Vector3.new(0, -0.8000, -30);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.03;
		LifeTime = 1.5;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(6, 3, 3);
		MaxSize = Vector3.new(7, 3, 4);
		PositionOffset = Vector3.new(0, -1.5, -40);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(-0.5235, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.13;
		LifeTime = 1.5;
		ScaleOutTime = 3;
	}};
	["爱心地裂"] = {{
		MinSize = Vector3.new(2, 3, 0.5);
		MaxSize = Vector3.new(3, 3.5, 1.5);
		PositionOffset = Vector3.new(0, -0.8000, -22);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.03;
		LifeTime = 2;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(3, 2.5, 2);
		MaxSize = Vector3.new(4, 3.5, 3);
		PositionOffset = Vector3.new(0, -1.5, -30);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(-0.5235, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.13;
		LifeTime = 2;
		ScaleOutTime = 3;
	}};
	["大佛二技能地裂"] = {{
		MinSize = Vector3.new(5, 4, 3);
		MaxSize = Vector3.new(7, 4, 3);
		PositionOffset = Vector3.new(0, -0.8000, -33);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.03;
		LifeTime = 1.8;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(7, 4, 4);
		MaxSize = Vector3.new(8, 4, 5);
		PositionOffset = Vector3.new(0, -1.5, -43);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.13;
		LifeTime = 1.8;
		ScaleOutTime = 3;
	}};
	["大佛二技能大地裂"] = {{
		MinSize = Vector3.new(7, 6, 5);
		MaxSize = Vector3.new(9, 6, 5);
		PositionOffset = Vector3.new(0, -0.8000, -45);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.03;
		LifeTime = 1.5;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(9, 6, 6);
		MaxSize = Vector3.new(10, 5, 7);
		PositionOffset = Vector3.new(0, -1.5, -65);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.13;
		LifeTime = 1.5;
		ScaleOutTime = 3;
	}};
	["大佛三技能地裂"] = {{
		MinSize = Vector3.new(5, 5, 4);
		MaxSize = Vector3.new(8, 5, 4);
		PositionOffset = Vector3.new(0, -0.8000, -20);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 5;
		Delay = 0.03;
		LifeTime = 1.5;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(7, 6, 6);
		MaxSize = Vector3.new(9, 5, 7);
		PositionOffset = Vector3.new(0, -1.5, -30);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 6;
		Delay = 0.09;
		LifeTime = 1.5;
		ScaleOutTime = 3;
	}, {
		MinSize = Vector3.new(8, 6, 6);
		MaxSize = Vector3.new(9, 5, 7);
		PositionOffset = Vector3.new(0, -1.5, -40);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 7;
		Delay = 0.13;
		LifeTime = 1.5;
		ScaleOutTime = 3;
	}};
	["大佛三技能地裂2"] = {{
		MinSize = Vector3.new(3, 3, 2);
		MaxSize = Vector3.new(8, 5, 4);
		PositionOffset = Vector3.new(0, -2, -20);
		PositionRamdomOffset = Vector3.new(5, 3, 10);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.34906, 0.52359, 0.34906);
		OriAngle = 0;
		StoneNum = 5;
		Delay = 0.03;
		LifeTime = 1;
		ScaleOutTime = 1.6;
		AttachAll = true;
	}};
	["怪兽八号三技能地裂第一拳"] = {{
		MinSize = Vector3.new(2, 1.5, 0.5);
		MaxSize = Vector3.new(3.5, 2.5, 1.5);
		PositionOffset = Vector3.new(0, -0.8000, -16);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.5235987755982988, (math.random() * 2 - 1) * 0.3490658503988659, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 10;
		Delay = 0.03;
		LifeTime = 1.2;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(4, 1, 2);
		MaxSize = Vector3.new(6, 1.5, 3);
		PositionOffset = Vector3.new(0, -1.5, -20);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.5235987755982988, (math.random() * 2 - 1) * 0.3490658503988659, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 6;
		Delay = 0.13;
		LifeTime = 1.2;
		ScaleOutTime = 3;
	}};
	["怪兽八号三技能地裂第二拳"] = {{
		MinSize = Vector3.new(2.5, 2, 1);
		MaxSize = Vector3.new(4, 3, 2);
		PositionOffset = Vector3.new(0, -0.8000, -19);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.5235987755982988, (math.random() * 2 - 1) * 0.3490658503988659, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 11;
		Delay = 0.03;
		LifeTime = 1.2;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(5, 2, 3);
		MaxSize = Vector3.new(7, 2.5, 4);
		PositionOffset = Vector3.new(0, -1.5, -24);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.5235987755982988, (math.random() * 2 - 1) * 0.3490658503988659, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 7;
		Delay = 0.13;
		LifeTime = 1.2;
		ScaleOutTime = 3;
	}};
	["怪兽八号三技能地裂第三拳"] = {{
		MinSize = Vector3.new(3, 2.5, 1.5);
		MaxSize = Vector3.new(4.5, 3.5, 2.5);
		PositionOffset = Vector3.new(0, -0.8000, -24);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.5235987755982988, (math.random() * 2 - 1) * 0.3490658503988659, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.03;
		LifeTime = 1.2;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(6, 3, 4);
		MaxSize = Vector3.new(8, 3.5, 5);
		PositionOffset = Vector3.new(0, -1.5, -30);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(0.5235987755982988, (math.random() * 2 - 1) * 0.3490658503988659, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 8;
		Delay = 0.13;
		LifeTime = 1.2;
		ScaleOutTime = 3;
	}};
	["怪兽八号一技能地裂"] = {{
		MinSize = Vector3.new(4.5, 2, 1.5);
		MaxSize = Vector3.new(6, 2, 2.5);
		PositionOffset = Vector3.new(0, -0.8000, -25);
		PositionRamdomOffset = Vector3.new(0.5, 0, 0.5);
		AngleOffset = Vector3.new(0.52359, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.03490, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.03;
		LifeTime = 1.5;
		ScaleOutTime = 2.5;
	}, {
		MinSize = Vector3.new(6, 2, 3);
		MaxSize = Vector3.new(7, 2, 4);
		PositionOffset = Vector3.new(0, -1.5, -35);
		PositionRamdomOffset = Vector3.new(1, 0, 1.5);
		AngleOffset = Vector3.new(-0.5235, 0.10471, 0);
		AngleRandomOffset = Vector3.new(0.05235, 0.08726, 0.08726);
		OriAngle = 0;
		StoneNum = 12;
		Delay = 0.06;
		LifeTime = 1.5;
		ScaleOutTime = 3;
	}};
}
function module.CreateLandBreak(arg1, arg2) -- Line 1106
	--[[ Upvalues[4]:
		[1]: tbl_upvr_3 (readonly)
		[2]: RayCast_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: Debris_upvr (readonly)
	]]
	if not arg1 then
	else
		if not arg2 then
			local const_string = "Temp"
		end
		for i_4 = 1, #tbl_upvr_3[const_string] do
			local var153_upvr = tbl_upvr_3[const_string][i_4]
			local AttachAll_upvr = var153_upvr.AttachAll
			task.delay(var153_upvr.Delay, function() -- Line 1123
				--[[ Upvalues[6]:
					[1]: var153_upvr (readonly)
					[2]: arg1 (readonly)
					[3]: AttachAll_upvr (readonly)
					[4]: RayCast_upvr (copied, readonly)
					[5]: TweenService_upvr (copied, readonly)
					[6]: Debris_upvr (copied, readonly)
				]]
				for i_5 = 1, var153_upvr.StoneNum do
					local Part_upvr_3 = Instance.new("Part")
					Part_upvr_3.Anchored = true
					Part_upvr_3.CanTouch = false
					Part_upvr_3.CanQuery = false
					Part_upvr_3.CanCollide = false
					Part_upvr_3.Material = Enum.Material.SmoothPlastic
					Part_upvr_3.Size = var153_upvr.MinSize + Vector3.new(var153_upvr.MinSize.X + math.random() * (var153_upvr.MaxSize.X - var153_upvr.MinSize.X), var153_upvr.MinSize.Y + math.random() * (var153_upvr.MaxSize.Y - var153_upvr.MinSize.Y), var153_upvr.MinSize.Z + math.random() * (var153_upvr.MaxSize.Z - var153_upvr.MinSize.Z))
					Part_upvr_3.Parent = workspace
					local var159 = 360 / var153_upvr.StoneNum
					local vector3_2 = Vector3.new((1 - 2 * math.random()) * var153_upvr.AngleRandomOffset.X, (1 - 2 * math.random()) * var153_upvr.AngleRandomOffset.Y, (1 - 2 * math.random()) * var153_upvr.AngleRandomOffset.Z)
					local vector3 = Vector3.new((1 - 2 * math.random()) * var153_upvr.PositionRamdomOffset.X, (1 - 2 * math.random()) * var153_upvr.PositionRamdomOffset.Y, (1 - 2 * math.random()) * var153_upvr.PositionRamdomOffset.Z)
					local any_ToWorldSpace_result1_3_upvw = CFrame.new(arg1.Position) * CFrame.Angles(0, math.rad(var153_upvr.OriAngle + var159 * i_5), 0):ToWorldSpace(CFrame.new(var153_upvr.PositionOffset + vector3) * CFrame.Angles(var153_upvr.AngleOffset.X + vector3_2.X, var153_upvr.AngleOffset.Y + vector3_2.Y, var153_upvr.AngleOffset.Z + vector3_2.Z))
					if AttachAll_upvr then
						any_ToWorldSpace_result1_3_upvw = arg1:ToWorldSpace(CFrame.Angles(0, math.rad(var153_upvr.OriAngle + var159 * i_5), 0)):ToWorldSpace(CFrame.new(var153_upvr.PositionOffset + vector3) * CFrame.Angles(var153_upvr.AngleOffset.X + vector3_2.X, var153_upvr.AngleOffset.Y + vector3_2.Y, var153_upvr.AngleOffset.Z + vector3_2.Z))
					end
					Part_upvr_3:PivotTo(any_ToWorldSpace_result1_3_upvw:ToWorldSpace(CFrame.new(1 - 2 * math.random(), -4, 1 - 2 * math.random()) * CFrame.Angles(math.rad((1 - 2 * math.random()) * 45), math.rad((1 - 2 * math.random()) * 45), math.rad((1 - 2 * math.random()) * 45))))
					local any_RayToLand_result1_3 = RayCast_upvr.RayToLand(any_ToWorldSpace_result1_3_upvw.Position + Vector3.new(0, 10, 0))
					if any_RayToLand_result1_3 then
						if any_RayToLand_result1_3.Instance:IsA("BasePart") then
							Part_upvr_3.Color = any_RayToLand_result1_3.Instance.Color
						end
						Part_upvr_3.Material = any_RayToLand_result1_3.Material
						if Part_upvr_3.Material == Enum.Material.Plastic then
							Part_upvr_3.Material = Enum.Material.SmoothPlastic
						end
						if any_RayToLand_result1_3.Instance.MaterialVariant then
							Part_upvr_3.MaterialVariant = any_RayToLand_result1_3.Instance.MaterialVariant
						end
						Part_upvr_3.CastShadow = false
					end
					TweenService_upvr:Create(Part_upvr_3, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
						CFrame = any_ToWorldSpace_result1_3_upvw;
					}):Play()
					delay(var153_upvr.LifeTime, function() -- Line 1168
						--[[ Upvalues[5]:
							[1]: Part_upvr_3 (readonly)
							[2]: TweenService_upvr (copied, readonly)
							[3]: any_ToWorldSpace_result1_3_upvw (read and write)
							[4]: var153_upvr (copied, readonly)
							[5]: Debris_upvr (copied, readonly)
						]]
						local Size = Part_upvr_3.Size
						local any_Create_result1 = TweenService_upvr:Create(Part_upvr_3, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
							CFrame = any_ToWorldSpace_result1_3_upvw + Vector3.new(0, -math.max(Size.X, Size.Y, Size.Z), 0);
							Transparency = 1;
						})
						if var153_upvr.ScaleOutTime then
							TweenService_upvr:Create(Part_upvr_3, TweenInfo.new(var153_upvr.ScaleOutTime), {
								Size = Vector3.new(0.10000, 0.10000, 0.10000);
							}):Play()
						end
						any_Create_result1.Completed:Connect(function() -- Line 1178
							--[[ Upvalues[2]:
								[1]: Debris_upvr (copied, readonly)
								[2]: Part_upvr_3 (copied, readonly)
							]]
							Debris_upvr:AddItem(Part_upvr_3, 0)
						end)
						any_Create_result1:Play()
					end)
				end
			end)
		end
	end
end
return module