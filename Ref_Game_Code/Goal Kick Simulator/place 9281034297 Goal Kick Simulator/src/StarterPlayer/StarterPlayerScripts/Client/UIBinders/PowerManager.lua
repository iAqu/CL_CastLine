-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:45
-- Luau version 6, Types version 3
-- Time taken: 0.009175 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
local function setCirclePosition_upvr(arg1, arg2) -- Line 8, Named "setCirclePosition"
	if arg2 then
		local var3 = math.ceil(arg2 * 140) / 140
		local clamped = math.clamp(math.ceil(64 * var3), 0, 63)
		arg1.ImageRectOffset = Vector2.new(clamped % 8 * 64, math.floor(clamped / 8) * 64)
		arg1.Percent.Text = (math.floor(var3 * 1000) / 10)..'%'
		if 0.8 < var3 then
			arg1.FarGradient.Enabled = false
			arg1.NormalGradient.Enabled = false
			arg1.CloseGradient.Enabled = true
			return var3
		end
		if 0.4 < var3 then
			arg1.FarGradient.Enabled = false
			arg1.NormalGradient.Enabled = true
			arg1.CloseGradient.Enabled = false
			return var3
		end
		arg1.FarGradient.Enabled = true
		arg1.NormalGradient.Enabled = false
		arg1.CloseGradient.Enabled = false
		return var3
	end
end
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local CurrentCamera_upvr = workspace.CurrentCamera
function module_upvr.Binder(arg1) -- Line 35
	--[[ Upvalues[5]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: setCirclePosition_upvr (readonly)
		[4]: CurrentCamera_upvr (readonly)
		[5]: module_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local Target_upvr = LocalPlayer_upvr.PlayerGui:WaitForChild("Target")
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
	local var11_upvw = false
	function module_upvr.Track(arg1_2, arg2) -- Line 43
		--[[ Upvalues[10]:
			[1]: var11_upvw (read and write)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: setCirclePosition_upvr (copied, readonly)
			[5]: arg1 (readonly)
			[6]: arg1 (readonly)
			[7]: any_new_result1_upvr (readonly)
			[8]: any_GetLink_result1_upvr (readonly)
			[9]: CurrentCamera_upvr (copied, readonly)
			[10]: Target_upvr (readonly)
		]]
		if var11_upvw then return end
		local Character = LocalPlayer_upvr.Character
		if not Character or not Character.PrimaryPart then return end
		if not Character:FindFirstChild("Humanoid") then return end
		var11_upvw = true
		Util_upvr.Sounds:Play("TimeClickStart")
		local setCirclePosition_upvr_result1_upvw = setCirclePosition_upvr(arg1, 0)
		arg1.Visible = true
		any_new_result1_upvr.Tracking = Util_upvr.Thread.LoopFor(1, function(arg1_3) -- Line 54
			--[[ Upvalues[3]:
				[1]: setCirclePosition_upvr_result1_upvw (read and write)
				[2]: setCirclePosition_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
			]]
			setCirclePosition_upvr_result1_upvw = setCirclePosition_upvr(arg1, math.sin(arg1_3 * math.pi))
		end)
		any_new_result1_upvr.OnDeactive = Util_upvr.Input.Actions.PowerInterrupt.Deactivated:Connect(function() -- Line 57
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (copied, readonly)
			]]
			any_new_result1_upvr.Tracking:Disconnect()
		end)
		if any_GetLink_result1_upvr.AutoKick and arg2 then
			any_new_result1_upvr.AutoKickDelay = Util_upvr.Thread.Delay(0.4 + 0.2 * math.random(), function() -- Line 61
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr (copied, readonly)
				]]
				any_new_result1_upvr.Tracking:Disconnect()
			end)
		end
		any_new_result1_upvr.Closing = nil
		any_new_result1_upvr.Tracking.Ended:Wait()
		any_new_result1_upvr.AutoKickDelay = nil
		if 0.8 < setCirclePosition_upvr_result1_upvw then
			Util_upvr.Sounds:Play("TimeClickPerfect")
		elseif 0.4 < setCirclePosition_upvr_result1_upvw then
			Util_upvr.Sounds:Play("TimeClickNormal")
		else
			Util_upvr.Sounds:Play("TimeClickBad")
		end
		local any_Invoke_result1 = Util_upvr.Network:Invoke("Throw", setCirclePosition_upvr_result1_upvw)
		if any_Invoke_result1 then
			CurrentCamera_upvr.CameraSubject = any_Invoke_result1
			any_new_result1_upvr.Interrupt = Util_upvr.Thread.Delay(1, function() -- Line 84
				--[[ Upvalues[3]:
					[1]: Target_upvr (copied, readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: any_new_result1_upvr (copied, readonly)
				]]
				Target_upvr.Hotbar.Kick.ActionIcon.Image = Util_upvr.Icons.KickInterrupt
				Target_upvr.Hotbar.Kick.PowerInterrupt.TextLabel.Text = "STOP"
				any_new_result1_upvr.InterruptActive = true
				function any_new_result1_upvr.Interrupt() -- Line 89
					--[[ Upvalues[3]:
						[1]: Target_upvr (copied, readonly)
						[2]: Util_upvr (copied, readonly)
						[3]: any_new_result1_upvr (copied, readonly)
					]]
					Target_upvr.Hotbar.Kick.ActionIcon.Image = Util_upvr.Icons.Kick
					Target_upvr.Hotbar.Kick.PowerInterrupt.TextLabel.Text = "HOLD"
					any_new_result1_upvr.InterruptActive = nil
				end
			end)
			while any_Invoke_result1.Parent do
				CurrentCamera_upvr.FieldOfView = 70 + any_Invoke_result1.Velocity.Magnitude / 25
				task.wait()
			end
			any_new_result1_upvr.Interrupt = nil
			CurrentCamera_upvr.FieldOfView = 70
			if CurrentCamera_upvr.CameraSubject == any_Invoke_result1 then
				CurrentCamera_upvr.CameraSubject = CurrentCamera_upvr.CameraSubject
			end
			any_new_result1_upvr.Closing = Util_upvr.Thread.Delay(0.25, function() -- Line 106
				--[[ Upvalues[2]:
					[1]: var11_upvw (copied, read and write)
					[2]: arg1 (copied, readonly)
				]]
				var11_upvw = false
				arg1.Visible = false
			end)
			return setCirclePosition_upvr_result1_upvw
		end
		var11_upvw = false
		arg1.Visible = false
		return 0
	end
	Target_upvr.Hotbar.Kick.Auto.MouseButton1Down:Connect(function() -- Line 117
		--[[ Upvalues[6]:
			[1]: any_GetLink_result1_upvr (readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: module_upvr (copied, readonly)
			[5]: Target_upvr (readonly)
			[6]: LocalPlayer_upvr (copied, readonly)
		]]
		local var22
		if any_GetLink_result1_upvr.AutoKick then
			local function INLINED() -- Internal function, doesn't exist in bytecode
				var22 = var22(function() -- Line 119
					--[[ Upvalues[1]:
						[1]: module_upvr (copied, readonly)
					]]
					if not module_upvr:Track(true) then
						task.wait(1)
					end
					task.wait(1)
				end)
				var22 = Util_upvr.Thread.Loop
				return var22
			end
			if any_new_result1_upvr.AutoKick ~= nil or not INLINED() then
				var22 = nil
			end
			any_new_result1_upvr.AutoKick = var22
			var22 = any_new_result1_upvr
			if var22.AutoKick then
				var22 = Target_upvr.Hotbar.Kick
				var22 = Color3.fromRGB(5, 235, 44)
				var22.Auto.BackgroundColor3 = var22
			else
				var22 = Target_upvr.Hotbar.Kick
				var22 = Color3.fromRGB(255, 70, 38)
				var22.Auto.BackgroundColor3 = var22
			end
		end
		Util_upvr.MarketplaceService:PromptGamePassPurchase(LocalPlayer_upvr, 55416490)
	end)
	any_new_result1_upvr.Active = true
	task.spawn(function() -- Line 136
		--[[ Upvalues[5]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: Target_upvr (readonly)
			[5]: arg1 (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		repeat
			local var25_upvr
			task.wait()
		until Util_upvr.ClientZone and not any_new_result1_upvr.Active
		if not any_new_result1_upvr.Active then
		else
			local var26_upvw
			var25_upvr = Util_upvr.ClientZone.ZoneChanged:Connect(function(arg1_4) -- Line 142, Named "UpdateZone"
				--[[ Upvalues[5]:
					[1]: any_GetLink_result1_upvr (copied, readonly)
					[2]: var26_upvw (read and write)
					[3]: Util_upvr (copied, readonly)
					[4]: Target_upvr (copied, readonly)
					[5]: any_new_result1_upvr (copied, readonly)
				]]
				local var27_upvr = any_GetLink_result1_upvr.ZoneStats[arg1_4]
				if not var27_upvr then
					var27_upvr = any_GetLink_result1_upvr.Stats
				end
				if var26_upvw == var27_upvr then
				else
					var26_upvw = var27_upvr
					local function UpdateValue() -- Line 147
						--[[ Upvalues[3]:
							[1]: Util_upvr (copied, readonly)
							[2]: var27_upvr (readonly)
							[3]: Target_upvr (copied, readonly)
						]]
						Target_upvr.Hotbar.Kick.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(Util_upvr.GameMath:GetMinKickDistance(var27_upvr.KickPower, var27_upvr.KickAccuracy) ^ 0.8))
					end
					any_new_result1_upvr.OnStatsChanged = var27_upvr.Changed:Connect(UpdateValue)
					Target_upvr.Hotbar.Kick.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(Util_upvr.GameMath:GetMinKickDistance(var27_upvr.KickPower, var27_upvr.KickAccuracy) ^ 0.8))
				end
			end)
			any_new_result1_upvr.ZoneChanged = var25_upvr
			var25_upvr = Util_upvr.ClientZone
			var25_upvr = any_GetLink_result1_upvr.ZoneStats[var25_upvr.CurrentZone]
			if not var25_upvr then
				var25_upvr = any_GetLink_result1_upvr.Stats
			end
			if var26_upvw == var25_upvr then
			else
				var26_upvw = var25_upvr
				local function UpdateValue() -- Line 147
					--[[ Upvalues[3]:
						[1]: Util_upvr (copied, readonly)
						[2]: var25_upvr (readonly)
						[3]: Target_upvr (copied, readonly)
					]]
					Target_upvr.Hotbar.Kick.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(Util_upvr.GameMath:GetMinKickDistance(var25_upvr.KickPower, var25_upvr.KickAccuracy) ^ 0.8))
				end
				any_new_result1_upvr.OnStatsChanged = var25_upvr.Changed:Connect(UpdateValue)
				Target_upvr.Hotbar.Kick.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(Util_upvr.GameMath:GetMinKickDistance(var25_upvr.KickPower, var25_upvr.KickAccuracy) ^ 0.8))
			end
			var25_upvr = arg1:GetAttributeChangedSignal("Area")
			var25_upvr = var25_upvr:Connect(function() -- Line 158
				--[[ Upvalues[5]:
					[1]: Util_upvr (copied, readonly)
					[2]: any_GetLink_result1_upvr (copied, readonly)
					[3]: var26_upvw (read and write)
					[4]: Target_upvr (copied, readonly)
					[5]: any_new_result1_upvr (copied, readonly)
				]]
				local var29_upvr = any_GetLink_result1_upvr.ZoneStats[Util_upvr.ClientZone.CurrentZone]
				if not var29_upvr then
					var29_upvr = any_GetLink_result1_upvr.Stats
				end
				if var26_upvw == var29_upvr then
				else
					var26_upvw = var29_upvr
					any_new_result1_upvr.OnStatsChanged = var29_upvr.Changed:Connect(function() -- Line 147, Named "UpdateValue"
						--[[ Upvalues[3]:
							[1]: Util_upvr (copied, readonly)
							[2]: var29_upvr (readonly)
							[3]: Target_upvr (copied, readonly)
						]]
						Target_upvr.Hotbar.Kick.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(Util_upvr.GameMath:GetMinKickDistance(var29_upvr.KickPower, var29_upvr.KickAccuracy) ^ 0.8))
					end)
					Target_upvr.Hotbar.Kick.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.floor(Util_upvr.GameMath:GetMinKickDistance(var29_upvr.KickPower, var29_upvr.KickAccuracy) ^ 0.8))
				end
			end)
			any_new_result1_upvr.AttributeChanged = var25_upvr
		end
	end)
	any_new_result1_upvr.PowerInterruptActivated = Util_upvr.Input.Actions.PowerInterrupt.Activated:Connect(function(arg1_5, arg2) -- Line 164
		--[[ Upvalues[4]:
			[1]: Util_upvr (copied, readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: any_new_result1_upvr (readonly)
			[4]: module_upvr (copied, readonly)
		]]
		if arg2 then
		else
			if Util_upvr.NoKickZone:IsInside(LocalPlayer_upvr.Character:GetPivot().Position) then return end
			for i, v in pairs(LocalPlayer_upvr.Character:GetChildren()) do
				if v:IsA("Tool") then return end
			end
			if any_new_result1_upvr.InterruptActive and any_new_result1_upvr.Interrupt then
				Util_upvr.Network:Fire("InterruptKick")
				any_new_result1_upvr.Interrupt = nil
				return
			end
			i = Util_upvr
			any_new_result1_upvr.AutoThrow = i.Thread.Loop(function() -- Line 176
				--[[ Upvalues[1]:
					[1]: module_upvr (copied, readonly)
				]]
				if not module_upvr:Track() then
					task.wait(1)
				end
			end)
		end
	end)
	Util_upvr.Input.Actions.PowerInterrupt.Deactivated:Connect(function() -- Line 182
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr (readonly)
		]]
		any_new_result1_upvr.AutoThrow = nil
	end)
	Util_upvr.PlayerMaids.Client.CharacterAdded:Connect(function(arg1_6) -- Line 185
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.Parent.Adornee = arg1_6
	end)
	arg1.Visible = false
	return any_new_result1_upvr
end
Util_upvr.PowerManager = module_upvr
return module_upvr