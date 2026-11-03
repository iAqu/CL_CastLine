-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:49
-- Luau version 6, Types version 3
-- Time taken: 0.015551 seconds

local TweenService_upvr = game:GetService("TweenService")
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr.SwitchWindow(arg1, arg2, arg3, arg4) -- Line 10
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: TweenService_upvr (readonly)
	]]
	local var4_upvw
	if typeof(arg2) == "string" and arg1.Object then
		var4_upvw = arg1.Object:FindFirstChild(var4_upvw, true)
	end
	if Util_upvr.FocusFrame then
		Util_upvr.FocusFrame:Clear()
	end
	return arg1.State:AddState(arg4 or 1, true, function() -- Line 20
		--[[ Upvalues[4]:
			[1]: var4_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: TweenService_upvr (copied, readonly)
			[4]: arg3 (readonly)
		]]
		local var21
		if var21 ~= nil then
			var21 = arg1.CurrentWindow
			if var21 == var4_upvw then
				var21 = arg1
				var21.CurrentWindow = nil
				var21 = nil
				var4_upvw = var21
			end
		end
		var21 = arg1
		var21.CurrentWindow = var4_upvw
		var21 = pairs(arg1.Windows)
		local pairs_result1_upvr, pairs_result2, pairs_result3_10 = pairs(arg1.Windows)
		for i, v in pairs_result1_upvr, pairs_result2, pairs_result3_10 do
			local var25
			if v ~= var4_upvw then
				var25 = false
			else
				var25 = true
			end
			v.Visible = var25
		end
		pairs_result1_upvr = var4_upvw
		if pairs_result1_upvr then
			pairs_result1_upvr = TweenService_upvr
			v = arg1
			i = v.Object
			i = TweenInfo.new
			v = 0.1
			i = i(v)
			v = {}
			var25 = UDim2.new(1, 0, 0.5, 0)
			v.Position = var25
			var25 = Vector2.new(1, 0.5)
			v.AnchorPoint = var25
			pairs_result1_upvr = pairs_result1_upvr:Create(i.Side, i, v):Play
			pairs_result1_upvr()
		else
			pairs_result1_upvr = TweenService_upvr
			v = arg1
			i = v.Object
			i = TweenInfo.new
			v = 0.1
			i = i(v)
			v = {}
			var25 = UDim2.new(1, 12, 0.5, 0)
			v.Position = var25
			var25 = Vector2.new(0, 0.5)
			v.AnchorPoint = var25
			pairs_result1_upvr = pairs_result1_upvr:Create(i.Side, i, v):Play
			pairs_result1_upvr()
		end
		pairs_result1_upvr = arg3
		if pairs_result1_upvr then
			pairs_result1_upvr = arg3()
		end
		pairs_result2 = var4_upvw
		local var27 = pairs_result2
		if var27 then
			function var27() -- Line 43
				--[[ Upvalues[3]:
					[1]: arg1 (copied, readonly)
					[2]: var4_upvw (copied, read and write)
					[3]: pairs_result1_upvr (readonly)
				]]
				arg1.CurrentWindow = nil
				var4_upvw.Visible = false
				if pairs_result1_upvr then
					pairs_result1_upvr()
				end
			end
		end
		return var27
	end)
end
function module_upvr.AddState(arg1, arg2, arg3) -- Line 53
	arg1.State:AddState(arg2 or 1, false, arg3)
end
function module_upvr.CloseNotification(arg1, arg2) -- Line 59
	arg1.State:RemoveState(arg2)
end
local tbl_4_upvr = {}
function module_upvr.PromptNotification(arg1, arg2) -- Line 63
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: tbl_4_upvr (readonly)
	]]
	local var29_upvr = arg2.Priority or 5
	local any_AddState_result1 = arg1.State:AddState(var29_upvr, false, function() -- Line 65
		--[[ Upvalues[5]:
			[1]: arg2 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: tbl_4_upvr (copied, readonly)
			[5]: var29_upvr (readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		if arg2.Sound then
			Util_upvr.Sounds:Play(arg2.Sound)
		end
		local any_new_result1_upvr_2 = Util_upvr.Maid.new()
		arg1.Object.Windows.Notification.Visible = true
		arg1.Object.Windows.Notification.Container.Title.Text = arg2.Text
		arg1.Object.Windows.Notification.Container.Polar.Option1.Visible = false
		arg1.Object.Windows.Notification.Container.Polar.Option2.Visible = false
		local tbl_6 = {
			Option1 = arg2.Text1 or "Ok!";
		}
		local Text2 = arg2.Text2
		if not Text2 then
			Text2 = arg2.Option2 and "No!"
		end
		tbl_6.Option2 = Text2
		for i_2_upvr, v_2 in pairs(tbl_6) do
			arg1.Object.Windows.Notification.Container.Polar[i_2_upvr].TitleText.Text = v_2
			arg1.Object.Windows.Notification.Container.Polar[i_2_upvr].Visible = true
			any_new_result1_upvr_2:GiveTask(arg1.Object.Windows.Notification.Container.Polar[i_2_upvr].MouseButton1Up:Connect(function() -- Line 78
				--[[ Upvalues[3]:
					[1]: any_new_result1_upvr_2 (readonly)
					[2]: arg2 (copied, readonly)
					[3]: i_2_upvr (readonly)
				]]
				any_new_result1_upvr_2:Destroy()
				local var46 = arg2[i_2_upvr]
				if var46 then
					var46()
				end
			end))
			local var47
		end
		var47:GiveTask(function() -- Line 86
			--[[ Upvalues[3]:
				[1]: tbl_4_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: var29_upvr (copied, readonly)
			]]
			if not next(tbl_4_upvr) then
				arg1.Object.Windows.Notification.Visible = false
			end
			arg1.State:RemoveState(var29_upvr)
		end)
		return var47
	end)
	if any_AddState_result1 then
		local var51_upvw
		var51_upvw = any_AddState_result1.Finished:Connect(function() -- Line 95
			--[[ Upvalues[3]:
				[1]: tbl_4_upvr (copied, readonly)
				[2]: arg1 (readonly)
				[3]: var51_upvw (read and write)
			]]
			local var52 = false
			if 0 < #tbl_4_upvr then
				var52 = table.remove(tbl_4_upvr, 1)
			end
			if var52 then
				arg1:PromptNotification(var52)
			end
			var51_upvw:Disconnect()
		end)
	else
		tbl_4_upvr[#tbl_4_upvr + 1] = arg2
	end
end
Util_upvr.Network.Events.PromptNotification = function(...) -- Line 107
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local packed_upvr = table.pack(...)
	task.spawn(function() -- Line 109
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: packed_upvr (readonly)
		]]
		while not Util_upvr.Windows do
			warn("[Util.Network.Events.PromptNotification] - Waiting for windows to populate")
			task.wait(0.1)
		end
		Util_upvr.Windows:PromptNotification(table.unpack(packed_upvr, 1, packed_upvr.n))
	end)
end
local tbl_2 = {}
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function tbl_2.Create(arg1, arg2) -- Line 121
	--[[ Upvalues[4]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
		[4]: TweenService_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	arg1.State = Util_upvr.State.new()
	arg1.Object = arg2
	arg1.Maid = any_new_result1_upvr
	Util_upvr.Windows = arg1
	setmetatable(arg1, module_upvr)
	local Container_upvr = arg2.Side.Buttons.Highlight.Container
	arg1.Windows = {}
	for _, v_3 in pairs(arg2.Windows:GetChildren()) do
		if v_3:IsA("GuiObject") then
			arg1.Windows[v_3.Name] = v_3
		end
	end
	local tbl_5_upvr = {}
	local function LookForButtons(arg1_3) -- Line 143
		--[[ Upvalues[3]:
			[1]: arg2 (readonly)
			[2]: tbl_5_upvr (readonly)
			[3]: Container_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local pairs_result1_3, pairs_result2_2, pairs_result3_4 = pairs(arg1_3:GetChildren())
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [76] 57. Error Block 23 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [76] 57. Error Block 23 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [7] 6. Error Block 2 start (CF ANALYSIS FAILED)
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [76.6]
		-- KONSTANTERROR: [7] 6. Error Block 2 end (CF ANALYSIS FAILED)
	end
	LookForButtons(arg2.Side.Buttons)
	LookForButtons(Container_upvr)
	for i_4, v_4 in pairs({
		UpgradeTeleport = "Upgrades";
		RebirthTeleport = "Rebirth";
	}) do
		local SOME_upvr = arg2.Side.Buttons:FindFirstChild(i_4)
		if SOME_upvr then
			local SOME = Util_upvr.ReplicatedStorage.ButtonTeleporters:FindFirstChild(v_4)
			if SOME then
				local Position_upvr_2 = SOME:GetPivot().Position
				SOME_upvr.MouseButton1Click:Connect(function() -- Line 183
					--[[ Upvalues[2]:
						[1]: LocalPlayer_upvr (copied, readonly)
						[2]: Position_upvr_2 (readonly)
					]]
					LocalPlayer_upvr.Character:PivotTo(CFrame.new(Position_upvr_2, Position_upvr_2 + LocalPlayer_upvr.Character:GetPivot().LookVector))
				end)
				local WorldArea_upvr = SOME:GetAttribute("WorldArea")
				if WorldArea_upvr then
					Util_upvr.Thread.Every(1, function() -- Line 188
						--[[ Upvalues[3]:
							[1]: Util_upvr (copied, readonly)
							[2]: SOME_upvr (readonly)
							[3]: WorldArea_upvr (readonly)
						]]
						local any_GetCurrentZone_result1 = Util_upvr.ClientZone:GetCurrentZone()
						if any_GetCurrentZone_result1 then
							if Util_upvr.ClientZone:GetCurrentZone().Name ~= WorldArea_upvr then
								any_GetCurrentZone_result1 = false
							else
								any_GetCurrentZone_result1 = true
							end
						end
						SOME_upvr.Visible = any_GetCurrentZone_result1
					end)
				end
			end
		end
	end
	for i_5_upvr, v_5_upvr in pairs(tbl_5_upvr) do
		Position_upvr_2 = i_5_upvr.MouseButton1Click
		Position_upvr_2 = Position_upvr_2:Connect(function() -- Line 199
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: v_5_upvr (readonly)
				[3]: i_5_upvr (readonly)
			]]
			if arg1.CurrentWindow ~= v_5_upvr then
				arg1:SwitchWindow(v_5_upvr, function() -- Line 201
					--[[ Upvalues[1]:
						[1]: i_5_upvr (copied, readonly)
					]]
					i_5_upvr:SetAttribute("UI_ButtonColor", Color3.fromRGB(63, 193, 201))
					return function() -- Line 203
						--[[ Upvalues[1]:
							[1]: i_5_upvr (copied, readonly)
						]]
						i_5_upvr:SetAttribute("UI_ButtonColor")
					end
				end)
			else
				arg1:SwitchWindow()
			end
		end)
		SOME_upvr = any_new_result1_upvr:GiveTask
		SOME_upvr(Position_upvr_2)
	end
	for _, _ in pairs(arg1.Windows) do
		Position_upvr_2 = "Close"
		SOME_upvr = _:FindFirstChild(Position_upvr_2)
		local var169 = SOME_upvr
		if var169 then
			WorldArea_upvr = var169.MouseButton1Click
			WorldArea_upvr = WorldArea_upvr:Connect(function() -- Line 216
				--[[ Upvalues[1]:
					[1]: arg1 (readonly)
				]]
				arg1:SwitchWindow()
			end)
			any_new_result1_upvr:GiveTask(WorldArea_upvr)
		end
	end
	for _, v_7_upvr in pairs(arg1.Windows) do
		WorldArea_upvr = Util_upvr.Maid
		Position_upvr_2 = WorldArea_upvr.new()
		function WorldArea_upvr() -- Line 227, Named "CheckOpen"
			--[[ Upvalues[5]:
				[1]: v_7_upvr (readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: any_new_result1_upvr (readonly)
				[4]: Position_upvr_2 (readonly)
				[5]: TweenService_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [15] 12. Error Block 3 start (CF ANALYSIS FAILED)
			any_new_result1_upvr.OpenMaid = Position_upvr_2
			local BlurEffect_upvr = Instance.new("BlurEffect")
			BlurEffect_upvr.Size = 0
			BlurEffect_upvr.Parent = Util_upvr.Lighting
			TweenService_upvr:Create(BlurEffect_upvr, TweenInfo.new(0.5), {
				Size = 32;
			}):Play()
			function Position_upvr_2.Blur() -- Line 237
				--[[ Upvalues[2]:
					[1]: TweenService_upvr (copied, readonly)
					[2]: BlurEffect_upvr (readonly)
				]]
				TweenService_upvr:Create(BlurEffect_upvr, TweenInfo.new(0.3), {
					Size = 0;
				}):Play()
				task.delay(0.3, function() -- Line 240
					--[[ Upvalues[1]:
						[1]: BlurEffect_upvr (copied, readonly)
					]]
					BlurEffect_upvr:Destroy()
				end)
			end
			local Offset_upvr = v_7_upvr.Position.Y.Offset
			v_7_upvr:TweenPosition(UDim2.new(v_7_upvr.Position.X.Scale, v_7_upvr.Position.X.Offset, v_7_upvr.Position.Y.Scale, Offset_upvr - 30), Enum.EasingDirection.Out, nil, 0.075, false, function() -- Line 245
				--[[ Upvalues[2]:
					[1]: v_7_upvr (copied, readonly)
					[2]: Offset_upvr (readonly)
				]]
				v_7_upvr:TweenPosition(UDim2.new(v_7_upvr.Position.X.Scale, v_7_upvr.Position.X.Offset, v_7_upvr.Position.Y.Scale, Offset_upvr), Enum.EasingDirection.In, nil, 0.1, true)
			end)
			do
				return
			end
			-- KONSTANTERROR: [15] 12. Error Block 3 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [98] 70. Error Block 4 start (CF ANALYSIS FAILED)
			Offset_upvr = Util_upvr
			BlurEffect_upvr = Offset_upvr.Sounds:Play
			BlurEffect_upvr("windowclose")
			BlurEffect_upvr = any_new_result1_upvr
			Offset_upvr = nil
			BlurEffect_upvr.OpenMaid = Offset_upvr
			-- KONSTANTERROR: [98] 70. Error Block 4 end (CF ANALYSIS FAILED)
		end
		local var174_upvr = WorldArea_upvr
		any_new_result1_upvr:GiveTask(v_7_upvr:GetPropertyChangedSignal("Visible"):Connect(function() -- Line 254
			--[[ Upvalues[1]:
				[1]: var174_upvr (readonly)
			]]
			var174_upvr()
		end))
		any_new_result1_upvr.Open = var174_upvr()
	end
	arg2.Enabled = true
	return any_new_result1_upvr
end
module_upvr.Binder = tbl_2
return module_upvr