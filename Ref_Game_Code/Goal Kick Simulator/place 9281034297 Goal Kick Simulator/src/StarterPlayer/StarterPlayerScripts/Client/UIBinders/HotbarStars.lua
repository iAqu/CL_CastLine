-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:13
-- Luau version 6, Types version 3
-- Time taken: 0.013811 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
Util_upvr.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
local tbl_2_upvr = {}
function module_upvr.Start(arg1) -- Line 13
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: tbl_2_upvr (readonly)
	]]
	Util_upvr.Input.Actions.InventoryKey.Activated:Connect(function(arg1_2) -- Line 14
		--[[ Upvalues[2]:
			[1]: module_upvr (copied, readonly)
			[2]: tbl_2_upvr (copied, readonly)
		]]
		if module_upvr.EquipDisabled then
		else
			for _, v_4 in pairs(tbl_2_upvr) do
				if v_4.Order == arg1_2.Value then
					v_4:ToggleEquip()
					return
				end
			end
		end
	end)
end
local tbl_upvr = {
	[Enum.KeyCode.One] = 1;
	[Enum.KeyCode.Two] = 2;
	[Enum.KeyCode.Three] = 3;
	[Enum.KeyCode.Four] = 4;
	[Enum.KeyCode.Five] = 5;
	[Enum.KeyCode.Six] = 6;
	[Enum.KeyCode.Seven] = 7;
	[Enum.KeyCode.Eight] = 8;
	[Enum.KeyCode.Nine] = 9;
	[Enum.KeyCode.Zero] = 0;
}
Util_upvr.UserInputService.InputBegan:Connect(function(arg1, arg2) -- Line 39
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
	]]
	if arg2 then
	else
		if arg1.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local var14 = tbl_upvr[arg1.KeyCode]
		if not var14 then return end
		for _, v_5 in pairs(tbl_2_upvr) do
			if v_5.Order == var14 then
				v_5:ToggleEquip()
			end
		end
	end
end)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module_upvr.Binder(arg1) -- Line 51
	--[[ Upvalues[4]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: tbl_2_upvr (readonly)
		[4]: module_upvr (readonly)
	]]
	local any_new_result1_upvr_5 = Util_upvr.Maid.new()
	any_new_result1_upvr_5.Active = true
	task.spawn(function() -- Line 55
		--[[ Upvalues[6]:
			[1]: Util_upvr (copied, readonly)
			[2]: any_new_result1_upvr_5 (readonly)
			[3]: LocalPlayer_upvr (copied, readonly)
			[4]: tbl_2_upvr (copied, readonly)
			[5]: arg1 (readonly)
			[6]: module_upvr (copied, readonly)
		]]
		repeat
			task.wait()
		until Util_upvr.Windows and not any_new_result1_upvr_5.Active
		if not any_new_result1_upvr_5.Active then return end
		local Stars_upvr = LocalPlayer_upvr.PlayerGui:WaitForChild("Windows").Side.Buttons.Highlight.Container.Stars
		local any_GetRawLink_result1_upvr = Util_upvr.Link:GetRawLink()
		local function UpdateStarButton() -- Line 64
			--[[ Upvalues[3]:
				[1]: Stars_upvr (readonly)
				[2]: any_GetRawLink_result1_upvr (readonly)
				[3]: Util_upvr (copied, readonly)
			]]
			local var25
			if next(any_GetRawLink_result1_upvr.Stars) then
				var25 = true
			else
				var25 = false
			end
			Stars_upvr.Visible = var25
			var25 = any_GetRawLink_result1_upvr.Stars
			if not next(var25) then
				var25 = Util_upvr.Windows
				if var25.CurrentWindow then
					var25 = Util_upvr.Windows.CurrentWindow
					if var25.Name == "Stars" then
						var25 = Util_upvr
						var25.Windows:SwitchWindow()
					end
				end
			end
		end
		any_new_result1_upvr_5.StarsChanged = Util_upvr.Link:GetLink().Stars.Changed:Connect(UpdateStarButton)
		UpdateStarButton()
		local Target_upvr = LocalPlayer_upvr.PlayerGui:WaitForChild("Target")
		local function CreateTool_upvr(arg1_3) -- Line 73, Named "CreateTool"
			--[[ Upvalues[7]:
				[1]: tbl_2_upvr (copied, readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: LocalPlayer_upvr (copied, readonly)
				[4]: arg1 (copied, readonly)
				[5]: module_upvr (copied, readonly)
				[6]: Target_upvr (readonly)
				[7]: any_new_result1_upvr_5 (copied, readonly)
			]]
			local var70
			if tbl_2_upvr[arg1_3] then
			else
				local any_GetAsset_result1_upvr = Util_upvr.Assets:GetAsset("UI", "HotbarTool")
				local any_new_result1_upvr_3 = Util_upvr.Maid.new()
				local Value_upvr = arg1_3:WaitForChild("NPCModel").Value
				local tbl_3 = {
					Parent = Value_upvr;
					Enabled = false;
				}
				var70 = 255
				tbl_3.FillColor = Color3.fromRGB(76, 178, var70)
				local tbl_4_upvr = {}
				local any_Create_result1_upvr = Util_upvr.Create("Highlight", tbl_3)
				local StarInstruction_upvr = Value_upvr:WaitForChild("StarInstruction")
				function tbl_4_upvr.CheckSelected(arg1_8) -- Line 87
					--[[ Upvalues[8]:
						[1]: arg1_3 (readonly)
						[2]: LocalPlayer_upvr (copied, readonly)
						[3]: any_GetAsset_result1_upvr (readonly)
						[4]: any_Create_result1_upvr (readonly)
						[5]: StarInstruction_upvr (readonly)
						[6]: any_new_result1_upvr_3 (readonly)
						[7]: Util_upvr (copied, readonly)
						[8]: Value_upvr (readonly)
					]]
					-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [2] 3. Error Block 2 start (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [2] 3. Error Block 2 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [20] 17. Error Block 26 start (CF ANALYSIS FAILED)
					if LocalPlayer_upvr.Character then
						if arg1_3:IsDescendantOf(LocalPlayer_upvr.Character) then
							-- KONSTANTERROR: [32] 26. Error Block 21 start (CF ANALYSIS FAILED)
							if arg1_3:IsDescendantOf(LocalPlayer_upvr.Backpack) then
								any_GetAsset_result1_upvr.Sel.Visible = false
								any_GetAsset_result1_upvr.Num.Visible = true
								any_Create_result1_upvr.Enabled = false
								StarInstruction_upvr.Enabled = false
								any_new_result1_upvr_3.TrackStarPerformance = nil
								arg1_8.Equipped = nil
								return
							end
							any_GetAsset_result1_upvr.Sel.Visible = true
							any_GetAsset_result1_upvr.Num.Visible = false
							arg1_8.Equipped = true
							any_Create_result1_upvr.Enabled = true
							StarInstruction_upvr.Enabled = true
							local any_new_result1_upvr_4 = Util_upvr.Maid.new()
							any_new_result1_upvr_4.Tracking = Value_upvr.ChildAdded:Connect(function(arg1_9) -- Line 106, Named "CheckFrame"
								--[[ Upvalues[1]:
									[1]: any_new_result1_upvr_4 (readonly)
								]]
								if arg1_9.Name == "StarPerformance" then
									arg1_9.Enabled = true
									function any_new_result1_upvr_4.Unview() -- Line 109
										--[[ Upvalues[1]:
											[1]: arg1_9 (readonly)
										]]
										arg1_9.Enabled = false
									end
								end
							end)
							any_new_result1_upvr_4.Untrack = Value_upvr.ChildRemoved:Connect(function(arg1_10) -- Line 115
								--[[ Upvalues[1]:
									[1]: any_new_result1_upvr_4 (readonly)
								]]
								if any_new_result1_upvr_4.Unview and arg1_10.Name == "StarPerformance" then
									any_new_result1_upvr_4.Unview = nil
								end
							end)
							for _, v_6_upvr in pairs(Value_upvr:GetChildren()) do
								if v_6_upvr.Name == "StarPerformance" then
									v_6_upvr.Enabled = true
									function any_new_result1_upvr_4.Unview() -- Line 109
										--[[ Upvalues[1]:
											[1]: v_6_upvr (readonly)
										]]
										v_6_upvr.Enabled = false
									end
								end
							end
							any_new_result1_upvr_3.TrackStarPerformance = any_new_result1_upvr_4
							do
								return
							end
							-- KONSTANTERROR: [32] 26. Error Block 21 end (CF ANALYSIS FAILED)
						end
					end
					-- KONSTANTERROR: [20] 17. Error Block 26 end (CF ANALYSIS FAILED)
					-- KONSTANTERROR: [143] 104. Error Block 16 start (CF ANALYSIS FAILED)
					any_new_result1_upvr_4 = any_new_result1_upvr_3:Destroy
					any_new_result1_upvr_4()
					do
						return
					end
					-- KONSTANTERROR: [143] 104. Error Block 16 end (CF ANALYSIS FAILED)
				end
				function tbl_4_upvr.Destroy() -- Line 130
					--[[ Upvalues[1]:
						[1]: any_new_result1_upvr_3 (readonly)
					]]
					any_new_result1_upvr_3:Destroy()
				end
				function tbl_4_upvr.Equip() -- Line 133
					--[[ Upvalues[2]:
						[1]: LocalPlayer_upvr (copied, readonly)
						[2]: arg1_3 (readonly)
					]]
					local Character_3 = LocalPlayer_upvr.Character
					if Character_3 then
						Character_3 = LocalPlayer_upvr.Character:FindFirstChildOfClass("Humanoid")
					end
					if Character_3 then
						Character_3:EquipTool(arg1_3)
					end
				end
				function tbl_4_upvr.Unequip() -- Line 139
					--[[ Upvalues[1]:
						[1]: LocalPlayer_upvr (copied, readonly)
					]]
					local Character_4 = LocalPlayer_upvr.Character
					if Character_4 then
						Character_4 = LocalPlayer_upvr.Character:FindFirstChildOfClass("Humanoid")
					end
					if Character_4 then
						Character_4:UnequipTools()
					end
				end
				function tbl_4_upvr.ToggleEquip(arg1_11) -- Line 145
					if arg1_11.Equipped then
						arg1_11:Unequip()
					else
						arg1_11:Equip()
					end
				end
				tbl_4_upvr.Frame = any_GetAsset_result1_upvr
				any_GetAsset_result1_upvr.Parent = arg1
				var70 = arg1_3.AncestryChanged
				var70 = var70:Connect(function() -- Line 161
					--[[ Upvalues[1]:
						[1]: tbl_4_upvr (readonly)
					]]
					tbl_4_upvr:CheckSelected()
				end)
				any_new_result1_upvr_3:GiveTask(var70)
				any_new_result1_upvr_3:GiveTask(arg1_3:GetPropertyChangedSignal("TextureId"):Connect(function() -- Line 165, Named "UpdateIcon"
					--[[ Upvalues[2]:
						[1]: any_GetAsset_result1_upvr (readonly)
						[2]: arg1_3 (readonly)
					]]
					any_GetAsset_result1_upvr.ItemIcon.Image = arg1_3.TextureId
				end))
				var70 = arg1_3.TextureId
				any_GetAsset_result1_upvr.ItemIcon.Image = var70
				any_new_result1_upvr_3:GiveTask(any_GetAsset_result1_upvr.MouseButton1Down:Connect(function() -- Line 171
					--[[ Upvalues[1]:
						[1]: module_upvr (copied, readonly)
					]]
					if module_upvr.EquipDisabled then return end
				end))
				any_new_result1_upvr_3:GiveTask(any_GetAsset_result1_upvr.MouseButton1Up:Connect(function() -- Line 174
					--[[ Upvalues[3]:
						[1]: any_new_result1_upvr_3 (readonly)
						[2]: module_upvr (copied, readonly)
						[3]: tbl_4_upvr (readonly)
					]]
					if not any_new_result1_upvr_3.Moving then
						if module_upvr.EquipDisabled then
						else
							any_new_result1_upvr_3.MovingTrigger = nil
							tbl_4_upvr:ToggleEquip()
						end
					end
					any_new_result1_upvr_3.Moving = nil
				end))
				any_new_result1_upvr_3:GiveTask(any_GetAsset_result1_upvr:GetPropertyChangedSignal("LayoutOrder"):Connect(function() -- Line 157, Named "updateOrder"
					--[[ Upvalues[2]:
						[1]: any_GetAsset_result1_upvr (readonly)
						[2]: tbl_4_upvr (readonly)
					]]
					any_GetAsset_result1_upvr.Num.Text = any_GetAsset_result1_upvr.LayoutOrder
					tbl_4_upvr.Order = any_GetAsset_result1_upvr.LayoutOrder
				end))
				any_new_result1_upvr_3:GiveTask(function() -- Line 184
					--[[ Upvalues[3]:
						[1]: tbl_2_upvr (copied, readonly)
						[2]: arg1_3 (readonly)
						[3]: Target_upvr (copied, readonly)
					]]
					tbl_2_upvr[arg1_3] = nil
					local var97 = 1
					for i_7, v_7 in pairs(tbl_2_upvr) do
						v_7.Frame.LayoutOrder = var97
						var97 += 1
					end
					if Target_upvr:FindFirstChild("Hotbar") then
						i_7 = Target_upvr
						i_7 = " Stars"
						i_7.Hotbar.PlaceStar.Amount.Text = (var97 - 1)..i_7
						local Hotbar_2 = Target_upvr.Hotbar
						if 1 >= var97 then
							Hotbar_2 = false
						else
							Hotbar_2 = true
						end
						Hotbar_2.PlaceStar.Visible = Hotbar_2
					end
				end)
				var70 = any_GetAsset_result1_upvr.TotalValue.Title
				var70.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.ceil(arg1_3:GetAttribute("TotalValue") or 0))
				var70 = any_new_result1_upvr_3:GiveTask
				var70(arg1_3:GetAttributeChangedSignal("TotalValue"):Connect(function() -- Line 197, Named "UpdateTotalValue"
					--[[ Upvalues[3]:
						[1]: any_GetAsset_result1_upvr (readonly)
						[2]: Util_upvr (copied, readonly)
						[3]: arg1_3 (readonly)
					]]
					any_GetAsset_result1_upvr.TotalValue.Title.Text = Util_upvr.ValueConvertor:ShrinkNumber(math.ceil(arg1_3:GetAttribute("TotalValue") or 0))
				end))
				var70 = 1
				for _, v_8 in pairs(tbl_2_upvr) do
					var70 += 1
					v_8.Frame.LayoutOrder = var70
				end
				Target_upvr.Hotbar.PlaceStar.Amount.Text = var70.." Stars"
				Target_upvr.Hotbar.PlaceStar.Visible = true
				any_new_result1_upvr_3:GiveTask(any_GetAsset_result1_upvr)
				any_new_result1_upvr_5:GiveTask(tbl_4_upvr)
				if not arg1_3.Parent then
					if not arg1_3:IsDescendantOf(LocalPlayer_upvr.Character) then
						if not arg1_3:IsDescendantOf(LocalPlayer_upvr.Backpack) then
							any_new_result1_upvr_5:Destroy()
							return nil
						end
					end
				end
				tbl_2_upvr[arg1_3] = tbl_4_upvr
				tbl_4_upvr:CheckSelected()
				any_GetAsset_result1_upvr.Num.Text = any_GetAsset_result1_upvr.LayoutOrder
				tbl_4_upvr.Order = any_GetAsset_result1_upvr.LayoutOrder
			end
		end
		local function OnToolAdded_upvr(arg1_12) -- Line 222, Named "OnToolAdded"
			--[[ Upvalues[1]:
				[1]: CreateTool_upvr (readonly)
			]]
			if arg1_12:IsA("Tool") then
				CreateTool_upvr(arg1_12)
			end
		end
		Util_upvr.PlayerMaids.Client.CharacterAdded:Connect(function() -- Line 228
			--[[ Upvalues[5]:
				[1]: tbl_2_upvr (copied, readonly)
				[2]: LocalPlayer_upvr (copied, readonly)
				[3]: CreateTool_upvr (readonly)
				[4]: any_new_result1_upvr_5 (copied, readonly)
				[5]: OnToolAdded_upvr (readonly)
			]]
			for i, v in pairs(tbl_2_upvr) do
				v:Destroy()
				tbl_2_upvr[i] = nil
			end
			for _, v_2 in pairs({LocalPlayer_upvr.Backpack, LocalPlayer_upvr.Character}) do
				for _, v_3 in pairs(v_2:GetChildren()) do
					if v_3:IsA("Tool") then
						CreateTool_upvr(v_3)
					end
				end
			end
			any_new_result1_upvr_5.DetectOnAdd = LocalPlayer_upvr.Backpack.ChildAdded:Connect(OnToolAdded_upvr)
		end)
		return any_new_result1_upvr_5
	end)
end
return module_upvr