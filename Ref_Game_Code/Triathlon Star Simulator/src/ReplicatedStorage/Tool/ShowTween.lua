-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:49
-- Luau version 6, Types version 3
-- Time taken: 0.005246 seconds

local module = {}
local Players_upvr = game:GetService("Players")
local TweenService_upvr = game:GetService("TweenService")
local CfgFind_upvr = require(game:GetService("ReplicatedStorage").Tool.CfgFind)
local function _(arg1, arg2) -- Line 16, Named "ShowInfo"
	--[[ Upvalues[2]:
		[1]: CfgFind_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	if not CfgFind_upvr.FindCfgByID(arg2) then
		warn("没有这个配置"..arg2)
		return false
	end
	local clone_3 = game.StarterGui.ScreenGui.PetInfo:Clone()
	clone_3.Parent = arg1.Parent
	clone_3.Visible = true
	return clone_3.Parent
end
function module.ShowLight() -- Line 31
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	local Frame = Instance.new("Frame", Players_upvr.LocalPlayer.PlayerGui.ScreenGui)
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame.BackgroundTransparency = 0
	TweenService_upvr:Create(Frame, TweenInfo.new(1.5, Enum.EasingStyle.Cubic), {
		BackgroundTransparency = 1;
	}):Play()
end
local Debris_upvr = game:GetService("Debris")
local RunService_upvr = game:GetService("RunService")
function module.ShowItem(arg1, arg2, arg3) -- Line 45
	--[[ Upvalues[5]:
		[1]: TweenService_upvr (readonly)
		[2]: Debris_upvr (readonly)
		[3]: CfgFind_upvr (readonly)
		[4]: Players_upvr (readonly)
		[5]: RunService_upvr (readonly)
	]]
	local var26_upvw
	for _, v in pairs(arg1:GetChildren()) do
		if v:IsA("Model") or v:IsA("BasePart") then
			var26_upvw = v
		end
	end
	if var26_upvw == nil then
		warn("没有展示对象")
		return false
	end
	if var26_upvw:IsA("Model") then
		local PrimaryPart = var26_upvw.PrimaryPart
		PrimaryPart.Anchored = true
		for _, v_2 in ipairs(var26_upvw:GetDescendants()) do
			if v_2:IsA("BasePart") and v_2.Name ~= PrimaryPart.Name then
				v_2.Anchored = false
				local WeldConstraint = Instance.new("WeldConstraint", PrimaryPart)
				WeldConstraint.Part0 = PrimaryPart
				WeldConstraint.Part1 = v_2
			end
		end
	end
	local clone_4_upvr = var26_upvw:Clone()
	clone_4_upvr.Parent = workspace
	for _, v_3 in pairs(clone_4_upvr:GetDescendants()) do
		if v_3:IsA("BasePart") then
			v_3.Transparency = 1
			v_3.CanCollide = false
			v_3.CanTouch = false
			v_3.CanQuery = false
		end
		if v_3:IsA("Decal") then
			v_3.Transparency = 1
		end
	end
	if clone_4_upvr:IsA("BasePart") then
		clone_4_upvr.Position = var26_upvw.Position
		local TweenInfo_new_result1_2 = TweenInfo.new(0.4, Enum.EasingStyle.Linear)
		local any_Create_result1 = TweenService_upvr:Create(clone_4_upvr, TweenInfo_new_result1_2, {
			CFrame = var26_upvw.CFrame * CFrame.Angles(0, 2.0943951023931953, 0);
		})
		local any_Create_result1_upvr_6 = TweenService_upvr:Create(arg1, TweenInfo.new(0.1), {
			Position = UDim2.new(arg1.Position.X.Scale, arg1.Position.X.Offset, arg1.Position.Y.Scale - 0.1, arg1.Position.Y.Offset);
		})
		local any_Create_result1_upvr_4 = TweenService_upvr:Create(arg1, TweenInfo.new(0.2), {
			Position = UDim2.new(arg1.Position.X.Scale, arg1.Position.X.Offset, arg1.Position.Y.Scale + 1, arg1.Position.Y.Offset);
		})
		local any_Create_result1_upvr_2 = TweenService_upvr:Create(clone_4_upvr, TweenInfo_new_result1_2, {
			CFrame = var26_upvw.CFrame * CFrame.Angles(0, 4.1887902047863905, 0);
		})
		any_Create_result1.Completed:Connect(function() -- Line 99
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvr_2 (readonly)
			]]
			any_Create_result1_upvr_2:Play()
		end)
		local any_Create_result1_upvr = TweenService_upvr:Create(clone_4_upvr, TweenInfo_new_result1_2, {
			CFrame = var26_upvw.CFrame * CFrame.Angles(0, (-math.pi*2), 0);
		})
		any_Create_result1_upvr_2.Completed:Connect(function() -- Line 100
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvr (readonly)
			]]
			any_Create_result1_upvr:Play()
		end)
		any_Create_result1_upvr.Completed:Connect(function() -- Line 101
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvr_6 (readonly)
			]]
			task.wait(0.2)
			any_Create_result1_upvr_6:Play()
		end)
		any_Create_result1_upvr_6.Completed:Connect(function() -- Line 104
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvr_4 (readonly)
			]]
			any_Create_result1_upvr_4:Play()
		end)
		local var52_upvw
		any_Create_result1_upvr_4.Completed:Connect(function() -- Line 105
			--[[ Upvalues[4]:
				[1]: Debris_upvr (copied, readonly)
				[2]: var52_upvw (read and write)
				[3]: clone_4_upvr (readonly)
				[4]: var26_upvw (read and write)
			]]
			Debris_upvr:AddItem(var52_upvw, 0)
			Debris_upvr:AddItem(clone_4_upvr, 0)
			Debris_upvr:AddItem(var26_upvw, 0)
		end)
		any_Create_result1:Play()
		if not CfgFind_upvr.FindCfgByID(arg2) then
			warn("没有这个配置"..arg2)
			var52_upvw = false
		else
			local clone_2 = game.StarterGui.ScreenGui.PetInfo:Clone()
			clone_2.Parent = arg1.Parent
			clone_2.Visible = true
			var52_upvw = clone_2.Parent
		end
	elseif clone_4_upvr:IsA("Model") then
		clone_4_upvr:PivotTo(var26_upvw:GetPrimaryPartCFrame())
		local TweenInfo_new_result1 = TweenInfo.new(0.4, Enum.EasingStyle.Linear)
		local tbl = {
			CFrame = clone_4_upvr.PrimaryPart.CFrame * CFrame.Angles(0, 2.0943951023931953, 0);
		}
		local any_Create_result1_3_upvr = TweenService_upvr:Create(clone_4_upvr.PrimaryPart, TweenInfo_new_result1, {
			CFrame = clone_4_upvr.PrimaryPart.CFrame * CFrame.Angles(0, (-math.pi*2), 0);
		})
		local any_Create_result1_upvr_5 = TweenService_upvr:Create(arg1, TweenInfo.new(0.1), {
			Position = UDim2.new(arg1.Position.X.Scale, arg1.Position.X.Offset, arg1.Position.Y.Scale - 0.1, arg1.Position.Y.Offset);
		})
		local any_Create_result1_2_upvr = TweenService_upvr:Create(arg1, TweenInfo.new(0.2), {
			Position = UDim2.new(arg1.Position.X.Scale, arg1.Position.X.Offset, arg1.Position.Y.Scale + 1, arg1.Position.Y.Offset);
		})
		local any_Create_result1_upvr_3 = TweenService_upvr:Create(clone_4_upvr.PrimaryPart, TweenInfo_new_result1, {
			CFrame = clone_4_upvr.PrimaryPart.CFrame * CFrame.Angles(0, 4.1887902047863905, 0);
		})
		TweenService_upvr:Create(clone_4_upvr.PrimaryPart, TweenInfo_new_result1, tbl).Completed:Connect(function() -- Line 132
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvr_3 (readonly)
			]]
			any_Create_result1_upvr_3:Play()
		end)
		any_Create_result1_upvr_3.Completed:Connect(function() -- Line 133
			--[[ Upvalues[1]:
				[1]: any_Create_result1_3_upvr (readonly)
			]]
			any_Create_result1_3_upvr:Play()
		end)
		any_Create_result1_3_upvr.Completed:Connect(function() -- Line 134
			--[[ Upvalues[1]:
				[1]: any_Create_result1_upvr_5 (readonly)
			]]
			task.wait(0.2)
			any_Create_result1_upvr_5:Play()
		end)
		any_Create_result1_upvr_5.Completed:Connect(function() -- Line 137
			--[[ Upvalues[1]:
				[1]: any_Create_result1_2_upvr (readonly)
			]]
			any_Create_result1_2_upvr:Play()
		end)
		local var75_upvw
		local any_Connect_result1_upvw = RunService_upvr.Heartbeat:Connect(function() -- Line 117
			--[[ Upvalues[2]:
				[1]: var26_upvw (read and write)
				[2]: clone_4_upvr (readonly)
			]]
			for i_4, v_4 in ipairs(var26_upvw:GetDescendants()) do
				if v_4:IsA("BasePart") then
					v_4.CFrame = clone_4_upvr:GetDescendants()[i_4].CFrame
					v_4.Size = clone_4_upvr:GetDescendants()[i_4].Size
				end
			end
		end)
		any_Create_result1_2_upvr.Completed:Connect(function() -- Line 138
			--[[ Upvalues[5]:
				[1]: Debris_upvr (copied, readonly)
				[2]: var75_upvw (read and write)
				[3]: clone_4_upvr (readonly)
				[4]: var26_upvw (read and write)
				[5]: any_Connect_result1_upvw (read and write)
			]]
			Debris_upvr:AddItem(var75_upvw, 0)
			Debris_upvr:AddItem(clone_4_upvr, 0)
			Debris_upvr:AddItem(var26_upvw, 0)
			if any_Connect_result1_upvw then
				any_Connect_result1_upvw:Disconnect()
				any_Connect_result1_upvw = nil
			end
		end)
		TweenService_upvr:Create(clone_4_upvr.PrimaryPart, TweenInfo_new_result1, tbl):Play()
		if not CfgFind_upvr.FindCfgByID(arg2) then
			warn("没有这个配置"..arg2)
			var75_upvw = false
		else
			local clone = game.StarterGui.ScreenGui.PetInfo:Clone()
			clone.Parent = arg1.Parent
			clone.Visible = true
			var75_upvw = clone.Parent
		end
	end
end
return module