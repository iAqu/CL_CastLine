-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:13
-- Luau version 6, Types version 3
-- Time taken: 0.023027 seconds

local module = {}
local TweenService_upvr = game:GetService("TweenService")
local RunService_upvr = game:GetService("RunService")
local Debris_upvr = game:GetService("Debris")
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local HumanModule_upvr = require(ReplicatedStorage_upvr.Tool.HumanModule)
local HideScreenGuiModule_upvr = require(ReplicatedStorage_upvr.Tool.HideScreenGuiModule)
local CfgFind_upvr = require(ReplicatedStorage_upvr.Tool.CfgFind)
local SoundModule_upvr = require(game.ReplicatedStorage.Tool.SoundModule)
local VpfPos_upvr = require(ReplicatedStorage_upvr.Tool.VpfPos)
local EnumMgr_upvr = require(ReplicatedStorage_upvr.Tool.EnumMgr)
local TranslationHelper_upvr = require(ReplicatedStorage_upvr.Tool.TranslationHelper)
local Fixed_upvr = Enum.CameraType.Fixed
local Vertical_upvr = Enum.FieldOfViewMode.Vertical
local function _(arg1) -- Line 57, Named "CreateCamera"
	--[[ Upvalues[2]:
		[1]: Fixed_upvr (readonly)
		[2]: Vertical_upvr (readonly)
	]]
	local Camera = Instance.new("Camera")
	Camera.Parent = arg1
	Camera.CFrame = CFrame.new(Camera.CFrame.Position)
	Camera.CameraType = Fixed_upvr
	Camera.DiagonalFieldOfView = 88
	Camera.FieldOfView = 70
	Camera.FieldOfViewMode = Vertical_upvr
	Camera.MaxAxisFieldOfView = 70
	arg1.CurrentCamera = Camera
end
local function CreateViewPortFrame_upvr(arg1) -- Line 69, Named "CreateViewPortFrame"
	--[[ Upvalues[2]:
		[1]: Fixed_upvr (readonly)
		[2]: Vertical_upvr (readonly)
	]]
	local Frame_2 = Instance.new("Frame", arg1)
	Frame_2.BackgroundTransparency = 1
	Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
	local ViewportFrame = Instance.new("ViewportFrame", Frame_2)
	ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.Ambient = Color3.new(1, 1, 1)
	ViewportFrame.LightColor = Color3.new(1, 1, 1)
	ViewportFrame.Size = UDim2.new(1, 0, 1, 0)
	ViewportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Instance.new("UIAspectRatioConstraint", ViewportFrame).AspectRatio = 1
	local Camera_2 = Instance.new("Camera")
	Camera_2.Parent = ViewportFrame
	Camera_2.CFrame = CFrame.new(Camera_2.CFrame.Position)
	Camera_2.CameraType = Fixed_upvr
	Camera_2.DiagonalFieldOfView = 88
	Camera_2.FieldOfView = 70
	Camera_2.FieldOfViewMode = Vertical_upvr
	Camera_2.MaxAxisFieldOfView = 70
	ViewportFrame.CurrentCamera = Camera_2
	return ViewportFrame
end
local function WeldEgg_upvr(arg1) -- Line 87, Named "WeldEgg"
	local PrimaryPart_2 = arg1.PrimaryPart
	PrimaryPart_2.Anchored = true
	for _, v in pairs(arg1:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= PrimaryPart_2.Name then
			local WeldConstraint = Instance.new("WeldConstraint", PrimaryPart_2)
			v.Anchored = false
			WeldConstraint.Part0 = PrimaryPart_2
			WeldConstraint.Part1 = v
		end
	end
end
local any_GetCfgByName_result1_upvr = CfgFind_upvr.GetCfgByName("tailingboxdataConf")
local function _(arg1) -- Line 104, Named "GetBox"
	--[[ Upvalues[1]:
		[1]: any_GetCfgByName_result1_upvr (readonly)
	]]
	local clone_8 = game.ReplicatedStorage:WaitForChild("ModelRes"):WaitForChild("TailingBox"):WaitForChild(any_GetCfgByName_result1_upvr[arg1].Model):Clone()
	local PrimaryPart_4 = clone_8.PrimaryPart
	PrimaryPart_4.Anchored = true
	for _, v_2 in pairs(clone_8:GetDescendants()) do
		if v_2:IsA("BasePart") and v_2.Name ~= PrimaryPart_4.Name then
			local WeldConstraint_2 = Instance.new("WeldConstraint", PrimaryPart_4)
			v_2.Anchored = false
			WeldConstraint_2.Part0 = PrimaryPart_4
			WeldConstraint_2.Part1 = v_2
		end
	end
	return clone_8
end
local function _(arg1) -- Line 121, Named "GetLoot"
	--[[ Upvalues[2]:
		[1]: CfgFind_upvr (readonly)
		[2]: WeldEgg_upvr (readonly)
	]]
	local any_FindCfgByID_result1_4 = CfgFind_upvr.FindCfgByID(arg1)
	if not any_FindCfgByID_result1_4 then
		warn("缺少这个蛋的配置:", arg1)
		return
	end
	local clone = game.ReplicatedStorage.ModelRes.Egg[any_FindCfgByID_result1_4.Model]:Clone()
	WeldEgg_upvr(clone)
	return clone
end
local VisibleMgr_upvr = require(ReplicatedStorage_upvr.Tool.VisibleMgr)
local function GetRewardPart_upvr(arg1) -- Line 135, Named "GetRewardPart"
	--[[ Upvalues[4]:
		[1]: CfgFind_upvr (readonly)
		[2]: EnumMgr_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
		[4]: VisibleMgr_upvr (readonly)
	]]
	local any_FindCfgByID_result1_5 = CfgFind_upvr.FindCfgByID(arg1)
	if not any_FindCfgByID_result1_5 then
		warn("缺少这个奖品的配置:", arg1)
		return
	end
	if any_FindCfgByID_result1_5.tp == EnumMgr_upvr.ItemType.Hero then
	end
	if any_FindCfgByID_result1_5.tp == EnumMgr_upvr.ItemType.Weapon then
		local clone_3 = game.ReplicatedStorage.ModelRes.WeaponShow[any_FindCfgByID_result1_5.Model]:Clone()
		for i_3, v_3 in pairs(clone_3:GetDescendants()) do
			if v_3:IsA("ParticleEmitter") then
				v_3.Enabled = false
			end
			if v_3:IsA("Trail") then
				v_3.Enabled = false
			end
		end
		if clone_3.PrimaryPart then
			local PrimaryPart = clone_3.PrimaryPart
			PrimaryPart.Parent = ReplicatedStorage_upvr
			clone_3.PrimaryPart = nil
			i_3 = clone_3:GetPivot()
			v_3 = Vector3.new(0, clone_3:GetExtentsSize().Y / 10, 0)
			i_3 = i_3.Position - v_3
			PrimaryPart.Position = i_3
			PrimaryPart.Parent = clone_3
			clone_3.PrimaryPart = PrimaryPart
		end
	end
	if not clone_3 then return end
	VisibleMgr_upvr.UnCollideAll(clone_3)
	local PrimaryPart_3 = clone_3.PrimaryPart
	PrimaryPart_3.Anchored = true
	for _, v_4 in pairs(clone_3:GetDescendants()) do
		if v_4:IsA("BasePart") and v_4.Name ~= PrimaryPart_3.Name then
			local WeldConstraint_3 = Instance.new("WeldConstraint", PrimaryPart_3)
			v_4.Anchored = false
			WeldConstraint_3.Part0 = PrimaryPart_3
			WeldConstraint_3.Part1 = v_4
		end
	end
	return clone_3
end
local GradientsMgr_upvr = require(ReplicatedStorage_upvr.Tool.GradientsMgr)
local function CreateAnima_upvr(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) -- Line 201, Named "CreateAnima"
	--[[ Upvalues[9]:
		[1]: TweenService_upvr (readonly)
		[2]: GetRewardPart_upvr (readonly)
		[3]: RunService_upvr (readonly)
		[4]: SoundModule_upvr (readonly)
		[5]: EnumMgr_upvr (readonly)
		[6]: CfgFind_upvr (readonly)
		[7]: TranslationHelper_upvr (readonly)
		[8]: GradientsMgr_upvr (readonly)
		[9]: Debris_upvr (readonly)
	]]
	local var54_upvw
	local DrawMaskGui_2 = game.Players.LocalPlayer.PlayerGui.ScreenGui.DrawMaskGui
	if DrawMaskGui_2:FindFirstChild("Light") then
		var54_upvw = DrawMaskGui_2:WaitForChild("Light")
	else
		var54_upvw = Instance.new("Frame", DrawMaskGui_2)
		var54_upvw.Size = UDim2.new(1, 0, 1, 0)
		var54_upvw.BorderSizePixel = 0
		var54_upvw.BackgroundTransparency = 1
		var54_upvw.BackgroundColor3 = Color3.new(1, 1, 1)
		var54_upvw.Name = "Light"
	end
	local GetRewardPart_upvr_result1_upvr = GetRewardPart_upvr(arg5)
	arg3.Parent.Position = UDim2.new(arg1.X.Scale, 0, -1 - arg1.Y.Scale + arg2.Y.Scale, 0)
	arg3.Parent.Size = arg2
	arg6.BackgroundTransparency = 1
	arg4.Parent = workspace
	arg4:PivotTo(CFrame.new(0, -1000, 0))
	local clone_7_upvr = arg4:Clone()
	clone_7_upvr.Parent = arg3
	arg3.Camera.CameraSubject = clone_7_upvr
	GetRewardPart_upvr_result1_upvr.Parent = workspace
	GetRewardPart_upvr_result1_upvr:PivotTo(CFrame.new(0, -1000, 0))
	local clone_upvr_2 = GetRewardPart_upvr_result1_upvr:Clone()
	arg3.Camera.CFrame = CFrame.lookAt(arg4.PrimaryPart.Position + Vector3.new(6 + arg4.PrimaryPart.Size.Z, 0, 0), arg4.PrimaryPart.Position)
	clone_7_upvr:PivotTo(CFrame.lookAt(arg4.PrimaryPart.Position, arg3.Camera.CFrame.Position))
	GetRewardPart_upvr_result1_upvr:PivotTo(CFrame.lookAt(arg4.PrimaryPart.Position, arg3.Camera.CFrame.Position))
	arg4:PivotTo(clone_7_upvr:GetPrimaryPartCFrame())
	local var60 = 0.9 * arg7
	local var61 = 0.6 * arg7
	local var62 = 0.5 * arg7
	local var63 = 0.2 * arg7
	local var64 = 0.05 * arg7
	local var65 = 0.1 * arg7
	local var66 = 0.5 * arg7
	local var67_upvr = 1 * arg7
	;({}).FillTransparency = 0
	local tbl_5 = {}
	tbl_5.Position = arg1
	local any_Create_result1 = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var60, Enum.EasingStyle.Bounce), tbl_5)
	local TweenInfo_new_result1_5 = TweenInfo.new(var61, Enum.EasingStyle.Back)
	local tbl = {
		Rotation = 20;
	}
	local any_Create_result1_26_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo_new_result1_5, tbl)
	local any_Create_result1_22_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var62, Enum.EasingStyle.Back), {
		Rotation = -20;
	})
	local any_Create_result1_27_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo_new_result1_5, tbl)
	local any_Create_result1_19_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var64, Enum.EasingStyle.Bounce), {
		Rotation = 10;
	})
	local any_Create_result1_20_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var64, Enum.EasingStyle.Bounce), {
		Rotation = -10;
	})
	local TweenInfo_new_result1_2 = TweenInfo.new(var63, Enum.EasingStyle.Linear)
	local any_Create_result1_23_upvr = TweenService_upvr:Create(arg4.PrimaryPart, TweenInfo_new_result1_2, {
		CFrame = arg4.PrimaryPart.CFrame * CFrame.Angles(0, 2.0943951023931953, 0);
	})
	local any_Create_result1_upvr_8 = TweenService_upvr:Create(arg4.PrimaryPart, TweenInfo_new_result1_2, {
		CFrame = arg4.PrimaryPart.CFrame * CFrame.Angles(0, 4.1887902047863905, 0);
	})
	local any_Create_result1_14_upvr = TweenService_upvr:Create(arg4.PrimaryPart, TweenInfo_new_result1_2, {
		CFrame = arg4.PrimaryPart.CFrame * CFrame.Angles(0, (-math.pi*2), 0);
	})
	local any_Create_result1_24_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var65), {})
	local TweenInfo_new_result1 = TweenInfo.new(var66, Enum.EasingStyle.Linear)
	local any_Create_result1_10_upvr = TweenService_upvr:Create(GetRewardPart_upvr_result1_upvr.PrimaryPart, TweenInfo_new_result1, {
		CFrame = GetRewardPart_upvr_result1_upvr.PrimaryPart.CFrame * CFrame.Angles(0, 2.0943951023931953, 0);
	})
	local any_Create_result1_upvr_6 = TweenService_upvr:Create(GetRewardPart_upvr_result1_upvr.PrimaryPart, TweenInfo_new_result1, {
		CFrame = GetRewardPart_upvr_result1_upvr.PrimaryPart.CFrame * CFrame.Angles(0, 4.1887902047863905, 0);
	})
	local any_Create_result1_4_upvr = TweenService_upvr:Create(GetRewardPart_upvr_result1_upvr.PrimaryPart, TweenInfo_new_result1, {
		CFrame = GetRewardPart_upvr_result1_upvr.PrimaryPart.CFrame * CFrame.Angles(0, (-math.pi*2), 0);
	})
	local any_Create_result1_7_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.6 * arg7, Enum.EasingStyle.Elastic), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 1.5, 0, arg3.Parent.Size.Y.Scale * 1.5, 0);
	})
	any_Create_result1.Completed:Connect(function() -- Line 365
		--[[ Upvalues[3]:
			[1]: any_Create_result1_7_upvr (readonly)
			[2]: any_Create_result1_26_upvr (readonly)
			[3]: SoundModule_upvr (copied, readonly)
		]]
		any_Create_result1_7_upvr:Play()
		any_Create_result1_26_upvr:Play()
		SoundModule_upvr:PlaySoundLocal("蛋摇晃")
	end)
	local any_Create_result1_upvr_4 = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.5 * arg7, Enum.EasingStyle.Elastic), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 1.8, 0, arg3.Parent.Size.Y.Scale * 1.8, 0);
	})
	any_Create_result1_26_upvr.Completed:Connect(function() -- Line 370
		--[[ Upvalues[3]:
			[1]: any_Create_result1_upvr_4 (readonly)
			[2]: any_Create_result1_22_upvr (readonly)
			[3]: SoundModule_upvr (copied, readonly)
		]]
		any_Create_result1_upvr_4:Play()
		any_Create_result1_22_upvr:Play()
		SoundModule_upvr:PlaySoundLocal("蛋摇晃")
	end)
	any_Create_result1_22_upvr.Completed:Connect(function() -- Line 375
		--[[ Upvalues[2]:
			[1]: any_Create_result1_27_upvr (readonly)
			[2]: SoundModule_upvr (copied, readonly)
		]]
		any_Create_result1_27_upvr:Play()
		SoundModule_upvr:PlaySoundLocal("蛋摇晃")
	end)
	local any_Create_result1_6_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.8 * arg7, Enum.EasingStyle.Back), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 0.5, 0, arg3.Parent.Size.Y.Scale * 0.5, 0);
	})
	any_Create_result1_27_upvr.Completed:Connect(function() -- Line 379
		--[[ Upvalues[2]:
			[1]: any_Create_result1_6_upvr (readonly)
			[2]: any_Create_result1_19_upvr (readonly)
		]]
		any_Create_result1_6_upvr:Play()
		any_Create_result1_19_upvr:Play()
	end)
	local var118_upvw = 0
	any_Create_result1_19_upvr.Completed:Connect(function() -- Line 386
		--[[ Upvalues[2]:
			[1]: var118_upvw (read and write)
			[2]: any_Create_result1_20_upvr (readonly)
		]]
		var118_upvw += 1
		any_Create_result1_20_upvr:Play()
	end)
	any_Create_result1_20_upvr.Completed:Connect(function() -- Line 391
		--[[ Upvalues[4]:
			[1]: var118_upvw (read and write)
			[2]: any_Create_result1_23_upvr (readonly)
			[3]: arg3 (readonly)
			[4]: any_Create_result1_19_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [14] 12. Error Block 4 start (CF ANALYSIS FAILED)
		arg3.Parent.Rotation = 0
		do
			return
		end
		-- KONSTANTERROR: [14] 12. Error Block 4 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [21] 17. Error Block 5 start (CF ANALYSIS FAILED)
		any_Create_result1_19_upvr:Play()
		-- KONSTANTERROR: [21] 17. Error Block 5 end (CF ANALYSIS FAILED)
	end)
	local any_Create_result1_13_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.6 * arg7, Enum.EasingStyle.Back), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 1.2, 0, arg3.Parent.Size.Y.Scale * 1.2, 0);
	})
	any_Create_result1_23_upvr.Completed:Connect(function() -- Line 402
		--[[ Upvalues[2]:
			[1]: any_Create_result1_upvr_8 (readonly)
			[2]: any_Create_result1_13_upvr (readonly)
		]]
		any_Create_result1_upvr_8:Play()
		any_Create_result1_13_upvr:Play()
	end)
	any_Create_result1_upvr_8.Completed:Connect(function() -- Line 406
		--[[ Upvalues[1]:
			[1]: any_Create_result1_14_upvr (readonly)
		]]
		any_Create_result1_14_upvr:Play()
	end)
	local any_Create_result1_12_upvr = TweenService_upvr:Create(var54_upvw, TweenInfo.new(1.5, Enum.EasingStyle.Cubic), {
		BackgroundTransparency = 1;
	})
	local Size_upvr = arg3.Parent.Size
	any_Create_result1_14_upvr.Completed:Connect(function() -- Line 407
		--[[ Upvalues[18]:
			[1]: arg3 (readonly)
			[2]: clone_upvr_2 (readonly)
			[3]: arg4 (readonly)
			[4]: arg9 (readonly)
			[5]: EnumMgr_upvr (copied, readonly)
			[6]: SoundModule_upvr (copied, readonly)
			[7]: arg8 (readonly)
			[8]: CfgFind_upvr (copied, readonly)
			[9]: arg5 (readonly)
			[10]: TranslationHelper_upvr (copied, readonly)
			[11]: arg10 (readonly)
			[12]: GradientsMgr_upvr (copied, readonly)
			[13]: var54_upvw (read and write)
			[14]: any_Create_result1_12_upvr (readonly)
			[15]: any_Create_result1_24_upvr (readonly)
			[16]: Size_upvr (readonly)
			[17]: clone_7_upvr (readonly)
			[18]: arg4 (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		if arg3 and arg3:FindFirstChild("Camera") and arg3.Parent then
			local var135
			if clone_upvr_2 then
				var135 = arg3
				var135 = CFrame.lookAt(arg4.PrimaryPart.Position + Vector3.new(5, 0, 0), arg4.PrimaryPart.Position)
				var135.Camera.CFrame = var135
				var135 = EnumMgr_upvr.Rare.Secret
				if arg9 == var135 then
					SoundModule_upvr:PlaySoundLocal("SecretReward", arg8, 0.01)
				else
					var135 = EnumMgr_upvr.Rare.Immortal
					if arg9 == var135 then
						SoundModule_upvr:PlaySoundLocal("ImmortalReward", arg8, 0.01)
					else
						SoundModule_upvr:PlaySoundLocal("蛋结果展示", arg8, 0.01)
					end
				end
				var135 = game.StarterGui.ScreenGui
				local clone_9 = var135.PetInfo:Clone()
				var135 = arg3.Parent
				clone_9.Parent = var135
				var135 = true
				clone_9.Visible = var135
				var135 = "???"
				local any_FindCfgByID_result1_2 = CfgFind_upvr.FindCfgByID(arg5)
				if any_FindCfgByID_result1_2 then
					var135 = any_FindCfgByID_result1_2.ZhName
					local xyd = any_FindCfgByID_result1_2.xyd
				end
				clone_9.PetName.Text = var135
				TranslationHelper_upvr.SetText(clone_9.Rare, EnumMgr_upvr.RareName[xyd])
				if arg10 == true then
					clone_9.AutoDel.Visible = false
				else
					local AutoDelete = game.Players.LocalPlayer:FindFirstChild("AutoDelete")
					if AutoDelete then
						local SOME = AutoDelete:FindFirstChild(arg5)
						if SOME and SOME.Value == 1 then
							clone_9.AutoDel.Visible = true
						else
							clone_9.AutoDel.Visible = false
						end
					else
						clone_9.AutoDel.Visible = false
					end
				end
				GradientsMgr_upvr.addGradients(clone_9.PetName, xyd)
				GradientsMgr_upvr.addGradients(clone_9.Rare, xyd)
				if var54_upvw then
					var54_upvw.BackgroundTransparency = 0
					any_Create_result1_12_upvr:Play()
				end
				any_Create_result1_24_upvr:Play()
				arg3.Parent.Size = Size_upvr
				local any_FindCfgByID_result1_3 = CfgFind_upvr.FindCfgByID(arg5)
				local var142
				if any_FindCfgByID_result1_3 and any_FindCfgByID_result1_3.tp == EnumMgr_upvr.ItemType.Weapon then
					var142 = Vector3.new(5 * clone_upvr_2:GetExtentsSize().Y / 5, 0, 0)
				end
				arg3.Camera.CFrame = CFrame.lookAt(clone_upvr_2.PrimaryPart.Position + var142, clone_upvr_2.PrimaryPart.Position)
				arg3.Camera.CameraSubject = clone_upvr_2
				clone_upvr_2.Parent = arg3
			end
		end
		clone_7_upvr:Destroy()
		arg4:Destroy()
	end)
	any_Create_result1_24_upvr.Completed:Connect(function() -- Line 482
		--[[ Upvalues[2]:
			[1]: any_Create_result1_10_upvr (readonly)
			[2]: arg9 (readonly)
		]]
		any_Create_result1_10_upvr:Play()
		if not arg9 then
		end
	end)
	arg6.BackgroundTransparency = 1
	local any_Create_result1_3_upvr = TweenService_upvr:Create(arg6, TweenInfo.new(0.2), {
		Position = UDim2.new(arg6.Position.X.Scale, arg6.Position.X.Offset, arg6.Position.Y.Scale - 0.1, arg6.Position.Y.Offset);
	})
	local any_Create_result1_11_upvr = TweenService_upvr:Create(arg6, TweenInfo.new(0.3), {
		Position = UDim2.new(arg6.Position.X.Scale, arg6.Position.X.Offset, arg6.Position.Y.Scale + 1, arg6.Position.Y.Offset);
	})
	any_Create_result1_10_upvr.Completed:Connect(function() -- Line 496
		--[[ Upvalues[1]:
			[1]: any_Create_result1_upvr_6 (readonly)
		]]
		any_Create_result1_upvr_6:Play()
	end)
	any_Create_result1_upvr_6.Completed:Connect(function() -- Line 499
		--[[ Upvalues[1]:
			[1]: any_Create_result1_4_upvr (readonly)
		]]
		any_Create_result1_4_upvr:Play()
	end)
	any_Create_result1_4_upvr.Completed:Connect(function() -- Line 502
		--[[ Upvalues[2]:
			[1]: var67_upvr (readonly)
			[2]: any_Create_result1_3_upvr (readonly)
		]]
		task.wait(var67_upvr)
		any_Create_result1_3_upvr:Play()
	end)
	any_Create_result1_3_upvr.Completed:Connect(function() -- Line 511
		--[[ Upvalues[1]:
			[1]: any_Create_result1_11_upvr (readonly)
		]]
		any_Create_result1_11_upvr:Play()
	end)
	local any_Connect_result1_upvw = RunService_upvr.Heartbeat:Connect(function() -- Line 266
		--[[ Upvalues[4]:
			[1]: clone_7_upvr (readonly)
			[2]: arg4 (readonly)
			[3]: clone_upvr_2 (readonly)
			[4]: GetRewardPart_upvr_result1_upvr (readonly)
		]]
		for i_5, v_5 in pairs(clone_7_upvr:GetDescendants()) do
			if v_5:IsA("BasePart") then
				v_5.CFrame = arg4:GetDescendants()[i_5].CFrame
				v_5.Size = arg4:GetDescendants()[i_5].Size
			end
		end
		for i_6, v_6 in pairs(clone_upvr_2:GetDescendants()) do
			if v_6:IsA("BasePart") then
				v_6.CFrame = GetRewardPart_upvr_result1_upvr:GetDescendants()[i_6].CFrame
				v_6.Size = GetRewardPart_upvr_result1_upvr:GetDescendants()[i_6].Size
			end
		end
	end)
	any_Create_result1_11_upvr.Completed:Connect(function() -- Line 514
		--[[ Upvalues[5]:
			[1]: arg3 (readonly)
			[2]: Debris_upvr (copied, readonly)
			[3]: arg6 (readonly)
			[4]: GetRewardPart_upvr_result1_upvr (readonly)
			[5]: any_Connect_result1_upvw (read and write)
		]]
		arg3.Parent.Visible = false
		Debris_upvr:AddItem(arg3.Parent, 0)
		arg6.Position = UDim2.new(0, 0, 0, 0)
		GetRewardPart_upvr_result1_upvr:Destroy()
		if any_Connect_result1_upvw then
			any_Connect_result1_upvw:Disconnect()
			any_Connect_result1_upvw = nil
		end
	end)
	any_Create_result1:Play()
	return var60 + var61 * 2 + var62 + var64 * 5 + var63 * 3 + var65 + var66 * 3 + var67_upvr + 0.5
end
function module.StartAnima(arg1, arg2, arg3, arg4) -- Line 532
	--[[ Upvalues[7]:
		[1]: CfgFind_upvr (readonly)
		[2]: HideScreenGuiModule_upvr (readonly)
		[3]: CreateViewPortFrame_upvr (readonly)
		[4]: VpfPos_upvr (readonly)
		[5]: WeldEgg_upvr (readonly)
		[6]: CreateAnima_upvr (readonly)
		[7]: HumanModule_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var197
	for _, v_7 in pairs(arg4) do
		var197 += 1
		local var198 = 1
		local any_FindCfgByID_result1_10 = CfgFind_upvr.FindCfgByID(v_7)
		if any_FindCfgByID_result1_10 then
			var198 = any_FindCfgByID_result1_10.xyd
		end
		if 1 < var198 then
		end
	end
	local Frame = game.Players.LocalPlayer.PlayerGui.ScreenGui.DrawMaskGui:WaitForChild("Frame")
	HideScreenGuiModule_upvr:HideGui()
	Frame:ClearAllChildren()
	local var201 = false
	local any_FindEggCfgById_result1 = CfgFind_upvr.FindEggCfgById(arg2)
	if any_FindEggCfgById_result1 then
		if any_FindEggCfgById_result1.cost == 0 then
			var201 = true
		end
	end
	for i_8 = 1, var197 do
		local var203 = var197
		local any_GetViewPortInfo_result1_4, any_GetViewPortInfo_result2_2 = VpfPos_upvr.GetViewPortInfo(i_8, var203)
		local any_FindCfgByID_result1_11 = CfgFind_upvr.FindCfgByID(arg2)
		if not any_FindCfgByID_result1_11 then
			warn("缺少这个蛋的配置:", arg2)
			var203 = nil
		else
			local clone_5 = game.ReplicatedStorage.ModelRes.Egg[any_FindCfgByID_result1_11.Model]:Clone()
			WeldEgg_upvr(clone_5)
			var203 = clone_5
		end
	end
	wait(CreateAnima_upvr(any_GetViewPortInfo_result2_2, any_GetViewPortInfo_result1_4, CreateViewPortFrame_upvr(Frame), var203, arg4[i_8], Frame, arg3, var197, var198, var201) + 0.5)
	spawn(function() -- Line 574
		--[[ Upvalues[1]:
			[1]: HumanModule_upvr (copied, readonly)
		]]
		local any_GetHumanoidRootPart_result1_upvr_2 = HumanModule_upvr.GetHumanoidRootPart(game.Players.LocalPlayer)
		if any_GetHumanoidRootPart_result1_upvr_2 then
			any_GetHumanoidRootPart_result1_upvr_2.CanTouch = false
			delay(0, function() -- Line 578
				--[[ Upvalues[1]:
					[1]: any_GetHumanoidRootPart_result1_upvr_2 (readonly)
				]]
				any_GetHumanoidRootPart_result1_upvr_2.CanTouch = true
			end)
		end
	end)
end
local function CreateAnima2D_upvr(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -- Line 586, Named "CreateAnima2D"
	--[[ Upvalues[3]:
		[1]: TweenService_upvr (readonly)
		[2]: RunService_upvr (readonly)
		[3]: SoundModule_upvr (readonly)
	]]
	local var211_upvw
	local DrawMaskGui = game.Players.LocalPlayer.PlayerGui.ScreenGui.DrawMaskGui
	if DrawMaskGui:FindFirstChild("Light") then
		var211_upvw = DrawMaskGui:WaitForChild("Light")
	else
		var211_upvw = Instance.new("Frame", DrawMaskGui)
		var211_upvw.Size = UDim2.new(1, 0, 1, 0)
		var211_upvw.BorderSizePixel = 0
		var211_upvw.BackgroundTransparency = 1
		var211_upvw.BackgroundColor3 = Color3.new(1, 1, 1)
		var211_upvw.Name = "Light"
	end
	arg3.Parent.Position = UDim2.new(arg1.X.Scale, 0, -1 - arg1.Y.Scale + arg2.Y.Scale, 0)
	arg3.Parent.Size = arg2
	arg6.BackgroundTransparency = 1
	arg4.Parent = workspace
	arg4:PivotTo(CFrame.new(0, -1000, 0))
	local clone_upvr = arg4:Clone()
	clone_upvr.Parent = arg3
	arg3.Camera.CameraSubject = clone_upvr
	arg3.Camera.CFrame = CFrame.lookAt(arg4.PrimaryPart.Position + Vector3.new(8 + arg4.PrimaryPart.Size.Z, 0, 0), arg4.PrimaryPart.Position)
	clone_upvr:PivotTo(CFrame.lookAt(arg4.PrimaryPart.Position, arg3.Camera.CFrame.Position))
	arg4:PivotTo(clone_upvr:GetPrimaryPartCFrame())
	local var215 = 0.9 * arg7
	local var216 = 0.6 * arg7
	local var217 = 0.5 * arg7
	local var218 = 0.2 * arg7
	local var219 = 0.05 * arg7
	local var220 = 0.1 * arg7
	;({}).FillTransparency = 0
	local tbl_3 = {}
	tbl_3.Position = arg1
	local any_Create_result1_21 = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var215, Enum.EasingStyle.Bounce), tbl_3)
	local TweenInfo_new_result1_3 = TweenInfo.new(var216, Enum.EasingStyle.Back)
	local tbl_4 = {
		Rotation = 20;
	}
	local any_Create_result1_9_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo_new_result1_3, tbl_4)
	local any_Create_result1_8_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var217, Enum.EasingStyle.Back), {
		Rotation = -20;
	})
	local any_Create_result1_18_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo_new_result1_3, tbl_4)
	local any_Create_result1_17_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var219, Enum.EasingStyle.Bounce), {
		Rotation = 10;
	})
	local any_Create_result1_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var219, Enum.EasingStyle.Bounce), {
		Rotation = -10;
	})
	local TweenInfo_new_result1_4 = TweenInfo.new(var218, Enum.EasingStyle.Linear)
	local any_Create_result1_upvr_2 = TweenService_upvr:Create(arg4.PrimaryPart, TweenInfo_new_result1_4, {
		CFrame = arg4.PrimaryPart.CFrame * CFrame.Angles(0, 2.0943951023931953, 0);
	})
	local any_Create_result1_16_upvr = TweenService_upvr:Create(arg4.PrimaryPart, TweenInfo_new_result1_4, {
		CFrame = arg4.PrimaryPart.CFrame * CFrame.Angles(0, 4.1887902047863905, 0);
	})
	local any_Create_result1_upvr_7 = TweenService_upvr:Create(arg4.PrimaryPart, TweenInfo_new_result1_4, {
		CFrame = arg4.PrimaryPart.CFrame * CFrame.Angles(0, (-math.pi*2), 0);
	})
	local any_Create_result1_upvr_3 = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.6 * arg7, Enum.EasingStyle.Elastic), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 1.5, 0, arg3.Parent.Size.Y.Scale * 1.5, 0);
	})
	any_Create_result1_21.Completed:Connect(function() -- Line 729
		--[[ Upvalues[3]:
			[1]: any_Create_result1_upvr_3 (readonly)
			[2]: any_Create_result1_9_upvr (readonly)
			[3]: SoundModule_upvr (copied, readonly)
		]]
		any_Create_result1_upvr_3:Play()
		any_Create_result1_9_upvr:Play()
		SoundModule_upvr:PlaySoundLocal("蛋摇晃")
	end)
	local any_Create_result1_15_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.5 * arg7, Enum.EasingStyle.Elastic), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 1.8, 0, arg3.Parent.Size.Y.Scale * 1.8, 0);
	})
	any_Create_result1_9_upvr.Completed:Connect(function() -- Line 734
		--[[ Upvalues[3]:
			[1]: any_Create_result1_15_upvr (readonly)
			[2]: any_Create_result1_8_upvr (readonly)
			[3]: SoundModule_upvr (copied, readonly)
		]]
		any_Create_result1_15_upvr:Play()
		any_Create_result1_8_upvr:Play()
		SoundModule_upvr:PlaySoundLocal("蛋摇晃")
	end)
	any_Create_result1_8_upvr.Completed:Connect(function() -- Line 739
		--[[ Upvalues[2]:
			[1]: any_Create_result1_18_upvr (readonly)
			[2]: SoundModule_upvr (copied, readonly)
		]]
		any_Create_result1_18_upvr:Play()
		SoundModule_upvr:PlaySoundLocal("蛋摇晃")
	end)
	local any_Create_result1_5_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.8 * arg7, Enum.EasingStyle.Back), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 0.5, 0, arg3.Parent.Size.Y.Scale * 0.5, 0);
	})
	any_Create_result1_18_upvr.Completed:Connect(function() -- Line 743
		--[[ Upvalues[2]:
			[1]: any_Create_result1_5_upvr (readonly)
			[2]: any_Create_result1_17_upvr (readonly)
		]]
		any_Create_result1_5_upvr:Play()
		any_Create_result1_17_upvr:Play()
	end)
	local var258_upvw = 0
	any_Create_result1_17_upvr.Completed:Connect(function() -- Line 750
		--[[ Upvalues[2]:
			[1]: var258_upvw (read and write)
			[2]: any_Create_result1_upvr (readonly)
		]]
		var258_upvw += 1
		any_Create_result1_upvr:Play()
	end)
	any_Create_result1_upvr.Completed:Connect(function() -- Line 755
		--[[ Upvalues[4]:
			[1]: var258_upvw (read and write)
			[2]: any_Create_result1_upvr_2 (readonly)
			[3]: arg3 (readonly)
			[4]: any_Create_result1_17_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [14] 12. Error Block 4 start (CF ANALYSIS FAILED)
		arg3.Parent.Rotation = 0
		do
			return
		end
		-- KONSTANTERROR: [14] 12. Error Block 4 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [21] 17. Error Block 5 start (CF ANALYSIS FAILED)
		any_Create_result1_17_upvr:Play()
		-- KONSTANTERROR: [21] 17. Error Block 5 end (CF ANALYSIS FAILED)
	end)
	local any_Create_result1_2_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(0.6 * arg7, Enum.EasingStyle.Back), {
		Size = UDim2.new(arg3.Parent.Size.X.Scale * 1.2, 0, arg3.Parent.Size.Y.Scale * 1.2, 0);
	})
	any_Create_result1_upvr_2.Completed:Connect(function() -- Line 767
		--[[ Upvalues[2]:
			[1]: any_Create_result1_16_upvr (readonly)
			[2]: any_Create_result1_2_upvr (readonly)
		]]
		any_Create_result1_16_upvr:Play()
		any_Create_result1_2_upvr:Play()
	end)
	any_Create_result1_16_upvr.Completed:Connect(function() -- Line 771
		--[[ Upvalues[1]:
			[1]: any_Create_result1_upvr_7 (readonly)
		]]
		any_Create_result1_upvr_7:Play()
	end)
	local any_Create_result1_upvr_5 = TweenService_upvr:Create(var211_upvw, TweenInfo.new(1.5, Enum.EasingStyle.Cubic), {
		BackgroundTransparency = 1;
	})
	local any_Create_result1_25_upvr = TweenService_upvr:Create(arg3.Parent, TweenInfo.new(var220), {})
	local Size_upvr_2 = arg3.Parent.Size
	local any_Connect_result1_upvw_2 = RunService_upvr.Heartbeat:Connect(function() -- Line 641
		--[[ Upvalues[2]:
			[1]: clone_upvr (readonly)
			[2]: arg4 (readonly)
		]]
		for i_9, v_8 in pairs(clone_upvr:GetDescendants()) do
			if v_8:IsA("BasePart") then
				v_8.CFrame = arg4:GetDescendants()[i_9].CFrame
				v_8.Size = arg4:GetDescendants()[i_9].Size
			end
		end
	end)
	any_Create_result1_upvr_7.Completed:Connect(function() -- Line 772
		--[[ Upvalues[13]:
			[1]: arg3 (readonly)
			[2]: arg4 (readonly)
			[3]: var211_upvw (read and write)
			[4]: SoundModule_upvr (copied, readonly)
			[5]: arg8 (readonly)
			[6]: any_Create_result1_upvr_5 (readonly)
			[7]: any_Create_result1_25_upvr (readonly)
			[8]: Size_upvr_2 (readonly)
			[9]: clone_upvr (readonly)
			[10]: arg4 (readonly)
			[11]: any_Connect_result1_upvw_2 (read and write)
			[12]: arg5 (readonly)
			[13]: arg6 (readonly)
		]]
		if arg3 and arg3:FindFirstChild("Camera") then
			arg3.Camera.CFrame = CFrame.lookAt(arg4.PrimaryPart.Position + Vector3.new(5, 0, 0), arg4.PrimaryPart.Position)
		end
		if var211_upvw then
			var211_upvw.BackgroundTransparency = 0
		end
		SoundModule_upvr:PlaySoundLocal("蛋结果展示", arg8, 0.01)
		any_Create_result1_upvr_5:Play()
		any_Create_result1_25_upvr:Play()
		if arg3 and arg3.Parent then
			arg3.Parent.Size = Size_upvr_2
		end
		clone_upvr:Destroy()
		arg4:Destroy()
		if any_Connect_result1_upvw_2 then
			any_Connect_result1_upvw_2:Disconnect()
			any_Connect_result1_upvw_2 = nil
		end
		arg5.Visible = true
		arg5.Parent = arg6
	end)
	any_Create_result1_21:Play()
	return var215 + var216 * 2 + var217 + var219 * 5 + var218 * 3 + var220 + 1 * arg7
end
function module.BoxAnima2D(arg1, arg2) -- Line 804
	--[[ Upvalues[8]:
		[1]: CreateViewPortFrame_upvr (readonly)
		[2]: VpfPos_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
		[4]: ReplicatedStorage_upvr (readonly)
		[5]: WeldEgg_upvr (readonly)
		[6]: TranslationHelper_upvr (readonly)
		[7]: Debris_upvr (readonly)
		[8]: CreateAnima2D_upvr (readonly)
	]]
	local Frame_4_upvr = game.Players.LocalPlayer.PlayerGui.ScreenGui.DrawMaskGui:WaitForChild("Frame")
	Frame_4_upvr:ClearAllChildren()
	local any_GetViewPortInfo_result1_3, any_GetViewPortInfo_result2_4 = VpfPos_upvr.GetViewPortInfo(1, 1)
	local any_FindCfgByID_result1_7 = CfgFind_upvr.FindCfgByID(arg2)
	local clone_10 = ReplicatedStorage_upvr.ModelRes.Egg:FindFirstChild(arg1):Clone()
	WeldEgg_upvr(clone_10)
	if not clone_10 then
		warn("没有找到蛋模型", arg1)
	else
		local clone_4_upvr = ReplicatedStorage_upvr:WaitForChild("UI"):WaitForChild("抽取道具展示"):Clone()
		clone_4_upvr:WaitForChild("ItemInfo"):WaitForChild("道具图片").Image = "rbxassetid://"..any_FindCfgByID_result1_7.Icon
		TranslationHelper_upvr.SetText(clone_4_upvr:WaitForChild("ItemInfo"):WaitForChild("道具名称"), any_FindCfgByID_result1_7.ZhName)
		clone_4_upvr:WaitForChild("ItemInfo"):WaitForChild("稀有度").Visible = false
		clone_4_upvr:WaitForChild("Button"):WaitForChild("继续按钮").Visible = false
		clone_4_upvr:WaitForChild("Button"):WaitForChild("领取按钮").MouseButton1Click:Connect(function() -- Line 832
			--[[ Upvalues[3]:
				[1]: Frame_4_upvr (readonly)
				[2]: Debris_upvr (copied, readonly)
				[3]: clone_4_upvr (readonly)
			]]
			Frame_4_upvr:ClearAllChildren()
			Debris_upvr:AddItem(clone_4_upvr, 0)
		end)
		wait(CreateAnima2D_upvr(any_GetViewPortInfo_result2_4, any_GetViewPortInfo_result1_3, CreateViewPortFrame_upvr(Frame_4_upvr), clone_10, clone_4_upvr, Frame_4_upvr, 1, 1) + 0.5)
	end
end
function module.BoxAnima3D(arg1, arg2) -- Line 845
	--[[ Upvalues[8]:
		[1]: CfgFind_upvr (readonly)
		[2]: HideScreenGuiModule_upvr (readonly)
		[3]: CreateViewPortFrame_upvr (readonly)
		[4]: VpfPos_upvr (readonly)
		[5]: ReplicatedStorage_upvr (readonly)
		[6]: WeldEgg_upvr (readonly)
		[7]: CreateAnima_upvr (readonly)
		[8]: HumanModule_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local tbl_2 = {}
	table.insert(tbl_2, arg2)
	local var292
	for _, v_9 in pairs(tbl_2) do
		var292 += 1
		local var293 = 1
		local any_FindCfgByID_result1_8 = CfgFind_upvr.FindCfgByID(v_9)
		if any_FindCfgByID_result1_8 then
			var293 = any_FindCfgByID_result1_8.xyd
		end
		if 1 < var293 then
		end
	end
	local Frame_3 = game.Players.LocalPlayer.PlayerGui.ScreenGui.DrawMaskGui:WaitForChild("Frame")
	HideScreenGuiModule_upvr:HideGui()
	Frame_3:ClearAllChildren()
	for i_11 = 1, var292 do
		local any_GetViewPortInfo_result1_2, any_GetViewPortInfo_result2_3 = VpfPos_upvr.GetViewPortInfo(i_11, var292)
		local clone_2 = ReplicatedStorage_upvr.ModelRes.Egg:FindFirstChild(arg1):Clone()
		WeldEgg_upvr(clone_2)
		local var299
	end
	wait(CreateAnima_upvr(any_GetViewPortInfo_result2_3, any_GetViewPortInfo_result1_2, CreateViewPortFrame_upvr(Frame_3), clone_2, tbl_2[i_11], Frame_3, 1, var292, var293, true) + 0.5)
	spawn(function() -- Line 887
		--[[ Upvalues[1]:
			[1]: HumanModule_upvr (copied, readonly)
		]]
		local any_GetHumanoidRootPart_result1_upvr = HumanModule_upvr.GetHumanoidRootPart(game.Players.LocalPlayer)
		if any_GetHumanoidRootPart_result1_upvr then
			any_GetHumanoidRootPart_result1_upvr.CanTouch = false
			delay(0, function() -- Line 891
				--[[ Upvalues[1]:
					[1]: any_GetHumanoidRootPart_result1_upvr (readonly)
				]]
				any_GetHumanoidRootPart_result1_upvr.CanTouch = true
			end)
		end
	end)
end
return module