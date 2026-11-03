-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:52
-- Luau version 6, Types version 3
-- Time taken: 0.009497 seconds

local module_upvr = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local var3_upvw = false
local TweenService_upvr = game:GetService("TweenService")
local tbl_2_upvr = {}
function module_upvr.SyncCards(arg1, arg2, arg3) -- Line 9
	--[[ Upvalues[5]:
		[1]: var3_upvw (read and write)
		[2]: Util_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: tbl_2_upvr (readonly)
		[5]: module_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	if not arg3 or #arg3 == 0 then
	elseif not var3_upvw then
		var3_upvw = true
		while not Util_upvr.Windows do
			task.wait()
		end
		local CardBlur_upvr = Util_upvr.Lighting.CardBlur
		Util_upvr.Windows.State:AddState(11, false, function() -- Line 16
			--[[ Upvalues[3]:
				[1]: CardBlur_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: arg2 (readonly)
			]]
			CardBlur_upvr.Enabled = true
			Util_upvr.Thread.LoopFor(0.5, function(arg1_2) -- Line 18
				--[[ Upvalues[1]:
					[1]: arg2 (copied, readonly)
				]]
				arg2.Content.ImageTransparency = 1 - arg1_2
			end)
			arg2.Enabled = true
			local any_Play_result1_upvr = Util_upvr.Sounds:Play("CardIdle")
			return function() -- Line 24
				--[[ Upvalues[3]:
					[1]: arg2 (copied, readonly)
					[2]: CardBlur_upvr (copied, readonly)
					[3]: any_Play_result1_upvr (readonly)
				]]
				arg2.Enabled = false
				CardBlur_upvr.Enabled = false
				if any_Play_result1_upvr then
					any_Play_result1_upvr:Stop()
				end
			end
		end)
		task.wait(1)
		local var47
		if next(arg3) then
			local popped = table.remove(arg3, 1)
			local tbl = {}
			local var50_upvw = false
			var47 = Util_upvr
			local any_new_result1_upvr = var47.Maid.new()
			var47 = Util_upvr
			var47 = var47.Assets:GetAsset("Packs", popped.Name)
			if var47 then
				var47 = var47.Assets:GetAsset("Packs", popped.Name):GetAttribute("CardImage")
			end
			for _ = 1, 4 do
				local clone_upvr = arg2.Card:Clone()
				clone_upvr.Position = UDim2.new(0.5, 0, -0.5, 0)
				local var54 = var47
				if not var54 then
					var54 = clone_upvr.Content.Back.Image
				end
				clone_upvr.Content.Back.Image = var54
				clone_upvr.Parent = arg2
				clone_upvr.Visible = true
				any_new_result1_upvr:GiveTask(clone_upvr)
				local var56_upvr = math.random() * 30 - 15 + math.sign(math.random() - 0.5) * 720
				Util_upvr.Thread.LoopFor(1, function(arg1_3) -- Line 55
					--[[ Upvalues[2]:
						[1]: clone_upvr (readonly)
						[2]: var56_upvr (readonly)
					]]
					local sine = math.sin((math.pi/2) * arg1_3)
					clone_upvr.Rotation = var56_upvr * sine
					clone_upvr.Position = UDim2.new(0.5, 0, sine * 1 + -0.5, 0)
				end)
				Util_upvr.Sounds:Play("CardMove")
				tbl[#tbl + 1] = clone_upvr
				task.wait(0.25)
			end
			task.wait(1)
			for i_2, v_upvr in pairs(tbl) do
				local var62_upvr = ((i_2 - 1 - 2) / 4 + 0.125) / 1.25
				Util_upvr.Thread.LoopFor(0.5, function(arg1_4) -- Line 67
					--[[ Upvalues[2]:
						[1]: v_upvr (readonly)
						[2]: var62_upvr (readonly)
					]]
					v_upvr.Position = UDim2.new(0.5 + var62_upvr * math.sin((math.pi/2) * arg1_4), 0, 0.5, 0)
				end)
			end
			task.wait(0.5)
			arg2.Instruction.Visible = true
			function any_new_result1_upvr.ResetInstruction() -- Line 75
				--[[ Upvalues[1]:
					[1]: arg2 (readonly)
				]]
				arg2.Instruction.Visible = false
			end
			local any_new_result1_upvr_2 = Util_upvr.Signal.new()
			for _, v_2_upvr in pairs(tbl) do
				any_new_result1_upvr[v_2_upvr] = v_2_upvr.MouseButton1Click:Connect(function() -- Line 81
					--[[ Upvalues[3]:
						[1]: var50_upvw (read and write)
						[2]: v_2_upvr (readonly)
						[3]: any_new_result1_upvr (readonly)
					]]
					var50_upvw = v_2_upvr
					any_new_result1_upvr.Interrupted = nil
				end)
				local var69_upvw
			end
			function any_new_result1_upvr.Interrupted() -- Line 86
				--[[ Upvalues[1]:
					[1]: any_new_result1_upvr_2 (readonly)
				]]
				any_new_result1_upvr_2:Fire()
			end
			any_new_result1_upvr_2:Wait()
			any_new_result1_upvr.ResetInstruction = nil
			if not var69_upvw then
				any_new_result1_upvr_2 = any_new_result1_upvr:Destroy()
				return any_new_result1_upvr_2
			end
			Util_upvr.Sounds:Play("CardMove")
			for i_4, _ in pairs(tbl) do
				any_new_result1_upvr[v_upvr] = nil
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if var69_upvw == v_upvr then
					task.delay(0.5, function() -- Line 99
						--[[ Upvalues[2]:
							[1]: TweenService_upvr (copied, readonly)
							[2]: v_upvr (readonly)
						]]
						TweenService_upvr:Create(v_upvr, TweenInfo.new(0.5), {
							Position = UDim2.new(0.5, 0, 0.5, 0);
							Rotation = 0;
						}):Play()
					end)
				else
					local var77_upvr = (i_4 - 1 - 2) / 4 + 0.125
					Util_upvr.Thread.LoopFor(0.5, function(arg1_5) -- Line 108
						--[[ Upvalues[2]:
							[1]: v_upvr (readonly)
							[2]: var77_upvr (readonly)
						]]
						v_upvr.Position = UDim2.new(0.5 + var77_upvr, 0, 0.5 + arg1_5, 0)
					end)
				end
			end
			task.wait(0.85)
			Util_upvr.Sounds:Play("CardFlip")
			Util_upvr.Thread.LoopFor(0.25, function(arg1_6) -- Line 116
				--[[ Upvalues[1]:
					[1]: var69_upvw (read and write)
				]]
				var69_upvw.Content.Size = UDim2.new(1 - arg1_6, 0, 1, 0)
			end).Ended:Wait()
			local any_GetAsset_result1 = Util_upvr.Assets:GetAsset("Stars", popped.Value)
			if not any_GetAsset_result1 or not any_GetAsset_result1:GetAttribute("Rarity") then
			end
			local var80 = 1 % 5
			if var80 == 0 then
			else
			end
			local var81 = var80
			local any_GetCompanionKickValues_result1, any_GetCompanionKickValues_result2, any_GetCompanionKickValues_result3 = Util_upvr.GameMath:GetCompanionKickValues(popped.Value, 1)
			for i_5, v_4 in pairs({
				KickPower = any_GetCompanionKickValues_result1;
				KickAccuracy = any_GetCompanionKickValues_result2;
				StarMulti = any_GetCompanionKickValues_result3;
			}) do
				local SOME = var69_upvw.Content.Front.Stats:FindFirstChild(i_5)
				if not SOME then return end
				SOME.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(v_4)
			end
			var69_upvw.Content.Front.Container.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(Util_upvr.GameMath:GetMinKickDistance(any_GetCompanionKickValues_result1, any_GetCompanionKickValues_result2))
			if not any_GetAsset_result1 or not any_GetAsset_result1:GetAttribute("Icon") then
			end
			var69_upvw.Content.Front.Container.Profile.Image = "rbxassetid://9561109778"
			arg2.Stars.Icon.TileSize = UDim2.new(1 / var81, 0, 1, 0)
			arg2.Stars.Icon.Size = UDim2.new(var81 / 5, 0, 1, 0)
			var69_upvw.Content.Front.Stats.Title.Text = popped.Value
			var69_upvw.Content.Front.Visible = true
			var69_upvw.Content.Back.Visible = false
			Util_upvr.Thread.LoopFor(0.25, function(arg1_7) -- Line 144
				--[[ Upvalues[1]:
					[1]: var69_upvw (read and write)
				]]
				var69_upvw.Content.Size = UDim2.new(arg1_7, 0, 1, 0)
			end).Ended:Wait()
			Util_upvr.Sounds:Play("CardUnveil")
			var69_upvw.Content.Front.Container.Visible = true
			var69_upvw.Content.Front.Stats.Visible = true
			Util_upvr.Thread.LoopFor(0.5, function(arg1_8) -- Line 154
				--[[ Upvalues[2]:
					[1]: var69_upvw (read and write)
					[2]: Util_upvr (copied, readonly)
				]]
				var69_upvw.Content.Front.UIGradient.Transparency = Util_upvr.ValueConvertor:GetNumberSequenceFromPercentage(1 - arg1_8, 0.1)
			end).Ended:Wait()
			Util_upvr.Sounds:Play("CardAward")
			Util_upvr.Input.Actions.Click.Activated:Wait()
			arg2.Stars.Visible = true
			any_new_result1_upvr:GiveTask(function() -- Line 162
				--[[ Upvalues[1]:
					[1]: arg2 (readonly)
				]]
				arg2.Stars.Visible = false
			end)
			any_new_result1_upvr:Destroy()
			if next(tbl_2_upvr) then
				task.spawn(function() -- Line 168
					--[[ Upvalues[3]:
						[1]: var3_upvw (copied, read and write)
						[2]: module_upvr (copied, readonly)
						[3]: tbl_2_upvr (copied, readonly)
					]]
					var3_upvw = false
					module_upvr:SyncCards(unpack(table.remove(tbl_2_upvr, 1)))
				end)
				-- KONSTANTWARNING: GOTO [580] #415
			end
			var3_upvw = false
			Util_upvr.Windows.State:RemoveState(11)
			task.wait(1)
			if next(tbl_2_upvr) then
				task.spawn(function() -- Line 180
					--[[ Upvalues[3]:
						[1]: var3_upvw (copied, read and write)
						[2]: module_upvr (copied, readonly)
						[3]: tbl_2_upvr (copied, readonly)
					]]
					var3_upvw = false
					module_upvr:SyncCards(unpack(table.remove(tbl_2_upvr, 1)))
				end)
			else
				var3_upvw = false
				Util_upvr.Windows.State:RemoveState(11)
			end
			-- KONSTANTWARNING: GOTO [40] #32
		end
	else
		CardBlur_upvr = tbl_2_upvr
		local tbl_3 = {}
		tbl_3[1] = arg2
		tbl_3[2] = arg3
		CardBlur_upvr[#tbl_2_upvr + 1] = tbl_3
	end
end
Util_upvr.PackAnimation = module_upvr
return module_upvr