-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:11
-- Luau version 6, Types version 3
-- Time taken: 0.004366 seconds

local module = {}
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local TweenService_upvr = game:GetService("TweenService")
local ObjectPool_upvr = require(ReplicatedStorage_upvr.Tool.ObjectPool)
local RunService_upvr = game:GetService("RunService")
function module.start(arg1, arg2, arg3, arg4) -- Line 9
	--[[ Upvalues[4]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: RunService_upvr (readonly)
	]]
	local any_GetFromPool_result1_upvr_3 = ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.DmgNum)
	any_GetFromPool_result1_upvr_3.Parent = workspace
	any_GetFromPool_result1_upvr_3.Position = arg1
	any_GetFromPool_result1_upvr_3.Anchored = true
	local Damage_3 = any_GetFromPool_result1_upvr_3.BillboardGui.Frame.Damage
	local BillboardGui_3 = any_GetFromPool_result1_upvr_3.BillboardGui
	Damage_3.Text = arg2
	Damage_3.TextColor3 = Color3.new(1, 1, 1)
	local Bao = any_GetFromPool_result1_upvr_3.BillboardGui.Frame.Bao
	Bao.Visible = false
	if arg3 then
		Bao.Visible = true
	end
	BillboardGui_3.Size = UDim2.new(0, 0, 0, 0)
	if arg3 then
		TweenService_upvr:Create(BillboardGui_3, TweenInfo.new(0.4), {
			Size = UDim2.new(8.604, 0, 4.302, 0);
		}):Play()
	else
		TweenService_upvr:Create(BillboardGui_3, TweenInfo.new(0.4), {
			Size = UDim2.new(5.736, 0, 2.868, 0);
		}):Play()
	end
	any_GetFromPool_result1_upvr_3.BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	local any_Create_result1_upvr_2 = TweenService_upvr:Create(Damage_3, TweenInfo.new(0.5), {
		TextColor3 = Color3.new(1, 0, 0);
	})
	delay(0.2, function() -- Line 77
		--[[ Upvalues[1]:
			[1]: any_Create_result1_upvr_2 (readonly)
		]]
		any_Create_result1_upvr_2:Play()
	end)
	local any_Create_result1_upvr_3 = TweenService_upvr:Create(BillboardGui_3, TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0, 0);
	})
	delay(0.5, function() -- Line 82
		--[[ Upvalues[3]:
			[1]: any_GetFromPool_result1_upvr_3 (readonly)
			[2]: TweenService_upvr (copied, readonly)
			[3]: any_Create_result1_upvr_3 (readonly)
		]]
		any_GetFromPool_result1_upvr_3.Anchored = true
		task.wait()
		any_Create_result1_upvr_3:Play()
		TweenService_upvr:Create(any_GetFromPool_result1_upvr_3.BillboardGui, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
			StudsOffsetWorldSpace = Vector3.new(1 - 2 * math.random(), -6, 1 - 2 * math.random());
		}):Play()
	end)
	task.spawn(function() -- Line 95
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_GetFromPool_result1_upvr_3 (readonly)
			[3]: RunService_upvr (copied, readonly)
			[4]: ObjectPool_upvr (copied, readonly)
		]]
		while true do
			local var21 = tick() - tick()
			if 1 <= var21 then break end
			any_GetFromPool_result1_upvr_3.CFrame = CFrame.new(arg1 + Vector3.new(math.random() - 0.5, 0.7, math.random() - 0.5) * 20 * var21 + 0.5 * Vector3.new(0, -workspace.Gravity * 0.25, 0) * var21 ^ 2)
			RunService_upvr.Heartbeat:Wait()
		end
		ObjectPool_upvr.BackToPool(any_GetFromPool_result1_upvr_3)
	end)
end
function module.startHpAdd(arg1, arg2) -- Line 119
	--[[ Upvalues[4]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: RunService_upvr (readonly)
	]]
	local any_GetFromPool_result1_upvr_2 = ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.HpNum)
	any_GetFromPool_result1_upvr_2.Parent = workspace
	any_GetFromPool_result1_upvr_2.Position = arg1
	any_GetFromPool_result1_upvr_2.Anchored = true
	local Damage_2 = any_GetFromPool_result1_upvr_2.BillboardGui.Frame.Damage
	local BillboardGui = any_GetFromPool_result1_upvr_2.BillboardGui
	Damage_2.Text = arg2
	Damage_2.TextColor3 = Color3.new(0, 1, 0)
	BillboardGui.Size = UDim2.new(0, 0, 0, 0)
	TweenService_upvr:Create(BillboardGui, TweenInfo.new(0.4), {
		Size = UDim2.new(5.736, 0, 2.868, 0);
	}):Play()
	any_GetFromPool_result1_upvr_2.BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	local any_Create_result1_upvr = TweenService_upvr:Create(BillboardGui, TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0, 0);
	})
	delay(0.5, function() -- Line 152
		--[[ Upvalues[3]:
			[1]: any_GetFromPool_result1_upvr_2 (readonly)
			[2]: TweenService_upvr (copied, readonly)
			[3]: any_Create_result1_upvr (readonly)
		]]
		any_GetFromPool_result1_upvr_2.Anchored = true
		task.wait()
		any_Create_result1_upvr:Play()
		TweenService_upvr:Create(any_GetFromPool_result1_upvr_2.BillboardGui, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
			StudsOffsetWorldSpace = Vector3.new(1 - 2 * math.random(), -6, 1 - 2 * math.random());
		}):Play()
	end)
	task.spawn(function() -- Line 165
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_GetFromPool_result1_upvr_2 (readonly)
			[3]: RunService_upvr (copied, readonly)
			[4]: ObjectPool_upvr (copied, readonly)
		]]
		while true do
			local var32 = tick() - tick()
			if 1 <= var32 then break end
			any_GetFromPool_result1_upvr_2.CFrame = CFrame.new(arg1 + Vector3.new(math.random() - 0.5, 0.7, math.random() - 0.5) * 20 * var32 + 0.5 * Vector3.new(0, -workspace.Gravity * 0.25, 0) * var32 ^ 2)
			RunService_upvr.Heartbeat:Wait()
		end
		ObjectPool_upvr.BackToPool(any_GetFromPool_result1_upvr_2)
	end)
end
function module.startAddExp(arg1, arg2) -- Line 186
	--[[ Upvalues[4]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ObjectPool_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: RunService_upvr (readonly)
	]]
	local any_GetFromPool_result1_upvr = ObjectPool_upvr.GetFromPool(ReplicatedStorage_upvr.ModelRes.ExpNum)
	any_GetFromPool_result1_upvr.Parent = workspace
	any_GetFromPool_result1_upvr.Position = arg1
	any_GetFromPool_result1_upvr.Anchored = true
	local Damage = any_GetFromPool_result1_upvr.BillboardGui.Frame.Damage
	local BillboardGui_2 = any_GetFromPool_result1_upvr.BillboardGui
	Damage.Text = arg2
	Damage.TextColor3 = Color3.new(1, 1, 1)
	BillboardGui_2.Size = UDim2.new(0, 0, 0, 0)
	TweenService_upvr:Create(BillboardGui_2, TweenInfo.new(0.4), {
		Size = UDim2.new(5.736, 0, 2.868, 0);
	}):Play()
	any_GetFromPool_result1_upvr.BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	local any_Create_result1_upvr_4 = TweenService_upvr:Create(BillboardGui_2, TweenInfo.new(0.5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0, 0);
	})
	delay(0.5, function() -- Line 230
		--[[ Upvalues[3]:
			[1]: any_GetFromPool_result1_upvr (readonly)
			[2]: TweenService_upvr (copied, readonly)
			[3]: any_Create_result1_upvr_4 (readonly)
		]]
		any_GetFromPool_result1_upvr.Anchored = true
		task.wait()
		any_Create_result1_upvr_4:Play()
		TweenService_upvr:Create(any_GetFromPool_result1_upvr.BillboardGui, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
			StudsOffsetWorldSpace = Vector3.new(1 - 2 * math.random(), -6, 1 - 2 * math.random());
		}):Play()
	end)
	task.spawn(function() -- Line 243
		--[[ Upvalues[4]:
			[1]: arg1 (readonly)
			[2]: any_GetFromPool_result1_upvr (readonly)
			[3]: RunService_upvr (copied, readonly)
			[4]: ObjectPool_upvr (copied, readonly)
		]]
		local var43 = math.random() - 0.5
		local var44
		if var43 < 0 then
			var43 = math.min(var43, -0.1)
		else
			var43 = math.max(var43, 0.1)
		end
		if var44 < 0 then
			var44 = math.min(var44, -0.1)
		else
			var44 = math.max(var44, 0.1)
		end
		while true do
			local var45 = tick() - tick()
			if 1 <= var45 then break end
			any_GetFromPool_result1_upvr.CFrame = CFrame.new(arg1 + Vector3.new(var43 * Vector3.new(1.5, 2, 1.5).X, 0.7 * Vector3.new(1.5, 2, 1.5).Y, var44 * Vector3.new(1.5, 2, 1.5).Z) * 20 * var45 + 0.5 * Vector3.new(0, -workspace.Gravity * 0.25, 0) * var45 ^ 2)
			RunService_upvr.Heartbeat:Wait()
		end
		ObjectPool_upvr.BackToPool(any_GetFromPool_result1_upvr)
	end)
end
return module