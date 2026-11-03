-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:26
-- Luau version 6, Types version 3
-- Time taken: 0.004144 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module_upvr = {}
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module_upvr.Binder(arg1) -- Line 6
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr_2 = Util_upvr.Maid.new()
	local var10_upvw
	local function LoadPlayer(arg1_2) -- Line 10, Named "SelectPlayer"
		--[[ Upvalues[4]:
			[1]: any_new_result1_upvr_2 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: var10_upvw (read and write)
		]]
		local var22
		if any_new_result1_upvr_2.SelectMaid then return end
		any_new_result1_upvr_2.SelectionHighlight = nil
		local any_new_result1_upvr = Util_upvr.Maid.new()
		any_new_result1_upvr_2.SelectMaid = any_new_result1_upvr
		var22 = "PlayerPick"
		Util_upvr.Windows:SwitchWindow(var22, nil, 2)
		var22 = Util_upvr
		local any_new_result1_upvr_3 = var22.Signal.new()
		local var18_upvw
		var22 = arg1.Container.Select.MouseButton1Click
		var22 = var22:Connect(function() -- Line 21
			--[[ Upvalues[2]:
				[1]: var18_upvw (read and write)
				[2]: any_new_result1_upvr (readonly)
			]]
			var18_upvw = true
			any_new_result1_upvr.OnClose = nil
			any_new_result1_upvr:Destroy()
		end)
		any_new_result1_upvr.OnSelect = var22
		var22 = arg1.Close.MouseButton1Click
		var22 = var22:Connect(function() -- Line 26
			--[[ Upvalues[1]:
				[1]: any_new_result1_upvr (readonly)
			]]
			any_new_result1_upvr.OnClose = nil
			any_new_result1_upvr:Destroy()
		end)
		any_new_result1_upvr.OnClosePressed = var22
		var22 = arg1:GetPropertyChangedSignal("Visible")
		var22 = var22:Connect(function() -- Line 30
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: any_new_result1_upvr (readonly)
			]]
			if arg1.Visible then
			else
				any_new_result1_upvr.OnClose = nil
				any_new_result1_upvr:Destroy()
			end
		end)
		any_new_result1_upvr.OnSelectClosed = var22
		function var22() -- Line 35
			--[[ Upvalues[2]:
				[1]: any_new_result1_upvr_3 (readonly)
				[2]: arg1 (copied, readonly)
			]]
			any_new_result1_upvr_3:Fire()
			arg1.Visible = false
		end
		any_new_result1_upvr.OnClose = var22
		var22 = any_new_result1_upvr_3:Wait
		var22()
		var22 = Util_upvr.Windows.State:RemoveState
		var22(2)
		local function INLINED() -- Internal function, doesn't exist in bytecode
			var22 = var10_upvw
			return var22
		end
		if not var18_upvw or not INLINED() then
			var22 = nil
		end
		any_new_result1_upvr_2.SelectMaid = nil
		var10_upvw = nil
		for _, v in pairs(arg1.Container.Content:GetChildren()) do
			if v:IsA("ImageButton") then
				v.UIStroke.Color = Color3.fromRGB(181, 181, 181)
			end
		end
		return var22
	end
	module_upvr.SelectPlayer = LoadPlayer
	function LoadPlayer(arg1_3) -- Line 55
		--[[ Upvalues[5]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: any_new_result1_upvr_2 (readonly)
			[5]: var10_upvw (read and write)
		]]
		local var27
		if arg1_3 == LocalPlayer_upvr then
		else
			local any_new_result1 = Util_upvr.Maid.new()
			local clone_upvr = arg1.Container.Content.PlayerFrame:Clone()
			local function INLINED_2() -- Internal function, doesn't exist in bytecode
				var27 = " (@"..arg1_3.Name..')'
				return var27
			end
			if arg1_3.Name == arg1_3.DisplayName or not INLINED_2() then
				var27 = ""
			end
			clone_upvr.PlayerName.Text = arg1_3.DisplayName..var27
			clone_upvr.Visible = true
			any_new_result1.OnClick = clone_upvr.MouseButton1Down:Connect(function() -- Line 61
				--[[ Upvalues[5]:
					[1]: any_new_result1_upvr_2 (copied, readonly)
					[2]: var10_upvw (copied, read and write)
					[3]: arg1_3 (readonly)
					[4]: arg1 (copied, readonly)
					[5]: clone_upvr (readonly)
				]]
				local var35
				if var35 then
					local function INLINED_3() -- Internal function, doesn't exist in bytecode
						var35 = arg1_3
						return var35
					end
					if var10_upvw == arg1_3 or not INLINED_3() then
						var35 = nil
					end
					var10_upvw = var35
					var35 = pairs(arg1.Container.Content:GetChildren())
					for _, v_3 in pairs(arg1.Container.Content:GetChildren()) do
						local var39
						if v_3:IsA("ImageButton") then
							local function INLINED_4() -- Internal function, doesn't exist in bytecode
								var39 = Color3.fromRGB(181, 181, 181)
								return var39
							end
							if var10_upvw and v_3 == clone_upvr or not INLINED_4() then
								var39 = Color3.fromRGB(60, 230, 255)
							end
							v_3.UIStroke.Color = var39
						end
					end
				end
			end)
			clone_upvr.Parent = arg1.Container.Content
			any_new_result1.Frame = clone_upvr
			any_new_result1_upvr_2[arg1_3] = any_new_result1
		end
	end
	local var26 = LoadPlayer
	for _, v_2 in pairs(Util_upvr.Players:GetPlayers()) do
		var26(v_2)
	end
	any_new_result1_upvr_2.OnPlayerAdded = Util_upvr.Players.PlayerAdded:Connect(var26)
	any_new_result1_upvr_2.OnPlayerRemoved = Util_upvr.Players.PlayerRemoving:Connect(function(arg1_4) -- Line 79
		--[[ Upvalues[1]:
			[1]: any_new_result1_upvr_2 (readonly)
		]]
		any_new_result1_upvr_2[arg1_4] = nil
	end)
	return any_new_result1_upvr_2
end
Util_upvr.PlayerPick = module_upvr
return module_upvr