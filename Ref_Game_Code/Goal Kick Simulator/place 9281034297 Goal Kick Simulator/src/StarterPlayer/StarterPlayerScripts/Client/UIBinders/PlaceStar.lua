-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:12
-- Luau version 6, Types version 3
-- Time taken: 0.002292 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local TweenService_upvr = game:GetService("TweenService")
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 7
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: TweenService_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_Create_result1_upvr = TweenService_upvr:Create(arg1.Hotbar, TweenInfo.new(0.35), {
		Position = UDim2.new(0.5, 0, 0.965, -75);
	})
	local any_Create_result1_upvr_4 = TweenService_upvr:Create(arg1.Units, TweenInfo.new(0.35), {
		AnchorPoint = Vector2.new(0.5, 1);
		Position = UDim2.new(0.5, 0, 1, -5);
	})
	local any_Create_result1_upvr_2 = TweenService_upvr:Create(arg1.Units, TweenInfo.new(0.35), {
		AnchorPoint = Vector2.new(0.5, 0);
		Position = UDim2.new(0.5, 0, 1.1, 10);
	})
	local any_Create_result1_upvr_3 = TweenService_upvr:Create(arg1.Hotbar, TweenInfo.new(0.35), {
		AnchorPoint = Vector2.new(0.5, 1);
		Position = UDim2.new(0.5, 0, 1, -5);
	})
	local function ActivatePlacement_upvr() -- Line 27, Named "ActivatePlacement"
		--[[ Upvalues[7]:
			[1]: any_new_result1_upvr (readonly)
			[2]: arg1 (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: any_Create_result1_upvr (readonly)
			[5]: any_Create_result1_upvr_4 (readonly)
			[6]: any_Create_result1_upvr_2 (readonly)
			[7]: any_Create_result1_upvr_3 (readonly)
		]]
		if any_new_result1_upvr.PlacementMode then
		else
			arg1.Hotbar.Kick.Visible = false
			arg1.Hotbar.PlaceStar.PlaceStar.TextLabel.Text = "CLOSE"
			local any_new_result1 = Util_upvr.Maid.new()
			any_Create_result1_upvr:Play()
			any_Create_result1_upvr_4:Play()
			any_new_result1:GiveTask(function() -- Line 34
				--[[ Upvalues[3]:
					[1]: arg1 (copied, readonly)
					[2]: any_Create_result1_upvr_2 (copied, readonly)
					[3]: any_Create_result1_upvr_3 (copied, readonly)
				]]
				arg1.Hotbar.Kick.Visible = true
				arg1.Hotbar.PlaceStar.PlaceStar.TextLabel.Text = "PLACE"
				any_Create_result1_upvr_2:Play()
				any_Create_result1_upvr_3:Play()
			end)
			any_new_result1_upvr.PlacementMode = any_new_result1
		end
	end
	local function OnToolAdded_upvr(arg1_2) -- Line 43, Named "OnToolAdded"
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: LocalPlayer_upvr (copied, readonly)
			[4]: ActivatePlacement_upvr (readonly)
		]]
		if not arg1_2:IsA("Tool") then
		else
			any_new_result1_upvr[arg1_2] = arg1_2.AncestryChanged:Connect(function() -- Line 45
				--[[ Upvalues[4]:
					[1]: any_new_result1_upvr (copied, readonly)
					[2]: Util_upvr (copied, readonly)
					[3]: LocalPlayer_upvr (copied, readonly)
					[4]: ActivatePlacement_upvr (copied, readonly)
				]]
				any_new_result1_upvr.CheckState = Util_upvr.Thread.Delay(0.1, function() -- Line 46
					--[[ Upvalues[3]:
						[1]: LocalPlayer_upvr (copied, readonly)
						[2]: ActivatePlacement_upvr (copied, readonly)
						[3]: any_new_result1_upvr (copied, readonly)
					]]
					if LocalPlayer_upvr.Character:FindFirstChildOfClass("Tool") then
						ActivatePlacement_upvr()
					else
						any_new_result1_upvr.PlacementMode = nil
					end
				end)
			end)
		end
	end
	Util_upvr.PlayerMaids.Client.CharacterAdded:Connect(function(arg1_3, arg2) -- Line 55
		--[[ Upvalues[2]:
			[1]: OnToolAdded_upvr (readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
		]]
		arg2.OnToolAdded = arg1_3.ChildAdded:Connect(OnToolAdded_upvr)
		arg2.OnBackPackToolAdded = LocalPlayer_upvr.Backpack.ChildAdded:Connect(OnToolAdded_upvr)
	end)
	Util_upvr.Input.Actions.PlaceStar.Activated:Connect(function(arg1_4, arg2) -- Line 60
		--[[ Upvalues[2]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: any_new_result1_upvr (readonly)
		]]
		if arg2 then
		else
			if LocalPlayer_upvr.Character:FindFirstChildOfClass("Tool") then
				LocalPlayer_upvr.Character.Humanoid:UnequipTools()
				any_new_result1_upvr.PlacementMode = nil
				return
			end
			local class_Tool = LocalPlayer_upvr.Backpack:FindFirstChildOfClass("Tool")
			if not class_Tool then return end
			LocalPlayer_upvr.Character.Humanoid:EquipTool(class_Tool)
		end
	end)
	return any_new_result1_upvr
end
return module