-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:32
-- Luau version 6, Types version 3
-- Time taken: 0.005804 seconds

local module = {}
local InsMgr_upvr = require(game:GetService("ReplicatedStorage").Tool.InsMgr)
function module.Weld(arg1, arg2) -- Line 13
	if not arg2 then
		warn("缺少第二参数:绑定到指定part")
	else
		if arg1:IsA("Model") then
			for _, v_8 in pairs(arg1:GetDescendants()) do
				if v_8:IsA("BasePart") then
					local WeldConstraint = Instance.new("WeldConstraint", v_8)
					WeldConstraint.Part0 = v_8
					WeldConstraint.Part1 = arg2
				end
			end
		end
		if arg1:IsA("BasePart") then
			local WeldConstraint_2 = Instance.new("WeldConstraint", arg1)
			WeldConstraint_2.Part0 = arg1
			WeldConstraint_2.Part1 = arg2
		end
	end
end
function module.SelfWeld(arg1) -- Line 44
	local PrimaryPart = arg1.PrimaryPart
	if not PrimaryPart then
	else
		for _, v_9 in pairs(arg1:GetDescendants()) do
			if v_9:IsA("BasePart") then
				local Weld_4 = Instance.new("Weld", v_9)
				Weld_4.Part0 = PrimaryPart
				Weld_4.Part1 = v_9
				Weld_4.C1 = PrimaryPart.CFrame:Inverse() * v_9.CFrame * Weld_4.C0
			end
		end
	end
end
function module.AnchoredAll(arg1) -- Line 68
	for _, v in pairs(arg1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
		end
	end
end
function module.CollideAll(arg1) -- Line 83
	for _, v_2 in pairs(arg1:GetDescendants()) do
		if v_2:IsA("BasePart") then
			v_2.CanCollide = true
		end
	end
end
function module.UnCollideAll(arg1) -- Line 94
	for _, v_3 in pairs(arg1:GetDescendants()) do
		if v_3:IsA("BasePart") then
			v_3.CanCollide = false
		end
	end
end
function module.InitModelSize(arg1, arg2) -- Line 106
	if not arg2 then return end
	for _, v_4 in pairs(arg1:GetDescendants()) do
		if v_4:IsA("BasePart") then
			v_4.Size *= arg2
		end
		if v_4:IsA("Motor6D") then
			v_4.C0 = v_4.C0.Rotation + v_4.C0.Position * arg2
			v_4.C1 = v_4.C1.Rotation + v_4.C1.Position * arg2
		end
		if v_4:IsA("Weld") then
			v_4.C0 = v_4.C0.Rotation + v_4.C0.Position * arg2
			v_4.C1 = v_4.C1.Rotation + v_4.C1.Position * arg2
		end
		if v_4:IsA("Attachment") then
			v_4.Position *= arg2
		end
		if v_4:IsA("WeldConstraint") then
			local Part0 = v_4.Part0
			local Weld_3 = Instance.new("Weld", Part0)
			Weld_3.Part0 = Part0
			Weld_3.Part1 = v_4.Part1
			Weld_3.C0 = Weld_3.C0.Rotation + Weld_3.C0.Position * arg2
			Weld_3.C1 = Weld_3.C1.Rotation + Weld_3.C1.Position * arg2
		end
		for _, v_5 in pairs(v_4:GetChildren()) do
			if v_5:IsA("Texture") then
				v_5.StudsPerTileU *= arg2
				v_5.StudsPerTileV *= arg2
			end
		end
	end
	arg1:SetAttribute("Scale", 1)
	return arg1
end
local Debris_upvr = game:GetService("Debris")
function module.ResizeModel(arg1, arg2) -- Line 174
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: Debris_upvr (readonly)
	]]
	if not arg2 then
		return arg1
	end
	local class_Humanoid = arg1:FindFirstChildOfClass("Humanoid")
	if class_Humanoid then
		class_Humanoid.HipHeight *= arg2
	end
	for _, v_6 in pairs(arg1:GetDescendants()) do
		if v_6:IsA("BasePart") then
			local OriSize_3 = v_6:FindFirstChild("OriSize")
			if not OriSize_3 then
				OriSize_3 = InsMgr_upvr.GetIns("OriSize", "Vector3Value", v_6)
				OriSize_3.Value = v_6.Size
			end
			v_6.Size = OriSize_3.Value * arg2
		end
		if v_6:IsA("SpecialMesh") and v_6.MeshType == Enum.MeshType.FileMesh then
			local OriSize = v_6:FindFirstChild("OriSize")
			if not OriSize then
				OriSize = InsMgr_upvr.GetIns("OriSize", "Vector3Value", v_6)
				OriSize.Value = v_6.Scale
			end
			v_6.Scale = OriSize.Value * arg2
		end
		if v_6:IsA("Motor6D") then
			local OriC1 = v_6:FindFirstChild("OriC1")
			if not OriC1 then
				OriC1 = InsMgr_upvr.GetIns("OriC1", "CFrameValue", v_6)
				OriC1.Value = v_6.C1
			end
			local OriC0_2 = v_6:FindFirstChild("OriC0")
			if not OriC0_2 then
				OriC0_2 = InsMgr_upvr.GetIns("OriC0", "CFrameValue", v_6)
				OriC0_2.Value = v_6.C0
			end
			v_6.C0 = OriC0_2.Value.Rotation + OriC0_2.Value.Position * arg2
			v_6.C1 = OriC1.Value.Rotation + OriC1.Value.Position * arg2
		end
		if v_6:IsA("Weld") then
			local OriC1_3 = v_6:FindFirstChild("OriC1")
			if not OriC1_3 then
				OriC1_3 = InsMgr_upvr.GetIns("OriC1", "CFrameValue", v_6)
				OriC1_3.Value = v_6.C1
			end
			local OriC0 = v_6:FindFirstChild("OriC0")
			if not OriC0 then
				OriC0 = InsMgr_upvr.GetIns("OriC0", "CFrameValue", v_6)
				OriC0.Value = v_6.C0
			end
			v_6.C0 = OriC0.Value.Rotation + OriC0.Value.Position * arg2
			v_6.C1 = OriC1_3.Value.Rotation + OriC1_3.Value.Position * arg2
		end
		if v_6:IsA("Attachment") then
			local OriPos = v_6:FindFirstChild("OriPos")
			if not OriPos then
				OriPos = InsMgr_upvr.GetIns("OriPos", "Vector3Value", v_6)
				OriPos.Value = v_6.CFrame.Position
			end
			v_6.Position = OriPos.Value * arg2
		end
		if v_6:IsA("WeldConstraint") then
			local Part0_2 = v_6.Part0
			local Part1 = v_6.Part1
			local Weld_2 = Instance.new("Weld", Part0_2)
			Weld_2.C0 = CFrame.new(0, 0, 0)
			Weld_2.C1 = Part1.CFrame:Inverse() * Part0_2.CFrame * Weld_2.C0
			Weld_2.Part0 = Part0_2
			Weld_2.Part1 = Part1
			local OriC1_2 = Weld_2:FindFirstChild("OriC1")
			if not OriC1_2 then
				OriC1_2 = InsMgr_upvr.GetIns("OriC1", "CFrameValue", Weld_2)
				OriC1_2.Value = Weld_2.C1
			end
			local OriC0_3 = Weld_2:FindFirstChild("OriC0")
			if not OriC0_3 then
				OriC0_3 = InsMgr_upvr.GetIns("OriC0", "CFrameValue", Weld_2)
				OriC0_3.Value = Weld_2.C0
			end
			Weld_2.C0 = OriC0_3.Value.Rotation + OriC0_3.Value.Position * arg2
			Weld_2.C1 = OriC1_2.Value.Rotation + OriC1_2.Value.Position * arg2
			v_6.Enabled = false
			Debris_upvr:AddItem(v_6, 0)
		end
		for _, v_7 in pairs(v_6:GetChildren()) do
			if v_7:IsA("Texture") then
				v_7.StudsPerTileU *= arg2
				v_7.StudsPerTileV *= arg2
			end
		end
	end
	arg1:SetAttribute("Scale", arg2)
	return arg1
end
local TweenService_upvr = game:GetService("TweenService")
function module.ResizeModelTween(arg1, arg2, arg3, arg4) -- Line 315
	--[[ Upvalues[2]:
		[1]: InsMgr_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	local PrimaryPart_upvr = arg1.PrimaryPart
	if not PrimaryPart_upvr then
		warn("No Primary Set")
	else
		for _, v_10_upvr in pairs(arg1:GetDescendants()) do
			if v_10_upvr:IsA("BasePart") then
				local OriSize_2 = v_10_upvr:FindFirstChild("OriSize")
				if not OriSize_2 then
					OriSize_2 = InsMgr_upvr.GetIns("OriSize", "Vector3Value", v_10_upvr)
					OriSize_2.Value = v_10_upvr.Size
				end
				local any_Create_result1 = TweenService_upvr:Create(v_10_upvr, TweenInfo.new(arg3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
					Size = OriSize_2.Value * arg2;
				})
				any_Create_result1.Completed:Connect(function() -- Line 336
					--[[ Upvalues[3]:
						[1]: v_10_upvr (readonly)
						[2]: PrimaryPart_upvr (readonly)
						[3]: arg4 (readonly)
					]]
					if v_10_upvr == PrimaryPart_upvr and arg4 then
						arg4()
					end
				end)
				any_Create_result1:Play()
				if v_10_upvr ~= PrimaryPart_upvr then
					TweenService_upvr:Create(v_10_upvr, TweenInfo.new(arg3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
						Position = PrimaryPart_upvr:GetPivot():PointToWorldSpace(PrimaryPart_upvr:GetPivot():ToObjectSpace(v_10_upvr:GetPivot()).Position * arg2);
					}):Play()
				end
			end
		end
	end
end
return module