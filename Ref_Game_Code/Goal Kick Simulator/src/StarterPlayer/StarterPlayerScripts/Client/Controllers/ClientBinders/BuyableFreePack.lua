-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:10
-- Luau version 6, Types version 3
-- Time taken: 0.006124 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 6
	--[[ Upvalues[2]:
		[1]: Util_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local function Load_upvr(arg1_2) -- Line 11, Named "Load"
		--[[ Upvalues[5]:
			[1]: any_new_result1_upvr (readonly)
			[2]: LocalPlayer_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: Util_upvr (copied, readonly)
			[5]: any_GetLink_result1_upvr (readonly)
		]]
		any_new_result1_upvr.SyncRedirect = nil
		any_new_result1_upvr.SyncRedirectTracker = nil
		any_new_result1_upvr.SyncBGUI = nil
		any_new_result1_upvr.SyncBGUITracker = nil
		local function _() -- Line 18, Named "IsClose"
			--[[ Upvalues[2]:
				[1]: LocalPlayer_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
			]]
			local Character_3 = LocalPlayer_upvr.Character
			if Character_3 then
				Character_3 = LocalPlayer_upvr.Character:GetPivot().Position
			end
			if not Character_3 then return end
			local var8 = Character_3 - arg1:GetPivot().Position
			if var8.Magnitude >= 32 then
				var8 = false
			else
				var8 = true
			end
			return var8
		end
		local ProximityPrompt_upvr = Instance.new("ProximityPrompt")
		ProximityPrompt_upvr.KeyboardKeyCode = Enum.KeyCode.E
		ProximityPrompt_upvr.GamepadKeyCode = Enum.KeyCode.ButtonX
		ProximityPrompt_upvr.RequiresLineOfSight = false
		ProximityPrompt_upvr.ActionText = ""
		ProximityPrompt_upvr.MaxActivationDistance = 32
		local any_Sync_result1_3 = Util_upvr.Streamer:Sync(arg1, "Interactable")
		any_new_result1_upvr:GiveTask(any_Sync_result1_3)
		any_new_result1_upvr:GiveTask(any_Sync_result1_3.Loaded:Connect(function(arg1_3) -- Line 36
			--[[ Upvalues[1]:
				[1]: ProximityPrompt_upvr (readonly)
			]]
			ProximityPrompt_upvr.Parent = arg1_3
		end))
		local RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
		any_new_result1_upvr.PromptPurchase = ProximityPrompt_upvr.Triggered:Connect(function() -- Line 43
			--[[ Upvalues[4]:
				[1]: RequiredZone_upvw (read and write)
				[2]: arg1 (copied, readonly)
				[3]: any_GetLink_result1_upvr (copied, readonly)
				[4]: Util_upvr (copied, readonly)
			]]
			RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
			if RequiredZone_upvw and not any_GetLink_result1_upvr.Zones[RequiredZone_upvw] then
				Util_upvr.AwardDisplay:ShowAwardItem("Error", 1, "You must have \""..RequiredZone_upvw.."\" unlocked to unlock this.")
			else
				if Util_upvr.Network:Invoke("PromptPurchaseFreePack", arg1) then
					Util_upvr.Sounds:Play("MoneyGainedSuccess")
					return
				end
				Util_upvr.Sounds:Play("BuyFailed")
			end
		end)
		any_new_result1_upvr.Prompt = ProximityPrompt_upvr
		any_new_result1_upvr.CheckProximity = Util_upvr.Thread.Every(0.35, function() -- Line 59
			--[[ Upvalues[7]:
				[1]: RequiredZone_upvw (read and write)
				[2]: arg1 (copied, readonly)
				[3]: any_GetLink_result1_upvr (copied, readonly)
				[4]: any_new_result1_upvr (copied, readonly)
				[5]: LocalPlayer_upvr (copied, readonly)
				[6]: Util_upvr (copied, readonly)
				[7]: arg1_2 (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 35 start (CF ANALYSIS FAILED)
			RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
			local var19
			if var19 then
				var19 = any_GetLink_result1_upvr.Zones[RequiredZone_upvw]
				if not var19 then
					var19 = any_new_result1_upvr.TweenBack
					if var19 then
						var19 = any_new_result1_upvr
						var19.TweenBack = nil
					end
					return
				end
			end
			local Character_2 = LocalPlayer_upvr.Character
			if Character_2 then
				Character_2 = LocalPlayer_upvr.Character:GetPivot().Position
			end
			if not Character_2 then
				var19 = nil
				-- KONSTANTWARNING: GOTO [52] #41
			end
			-- KONSTANTERROR: [0] 1. Error Block 35 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [38] 31. Error Block 36 start (CF ANALYSIS FAILED)
			if (Character_2 - arg1:GetPivot().Position).Magnitude >= 32 then
				var19 = false
			else
				var19 = true
			end
			if var19 then
				var19 = any_new_result1_upvr.TweenBack
				if var19 then
				else
					var19 = Util_upvr.Sounds:Play
					var19("ChestPopInfo")
					var19 = arg1_2.Chances:TweenSize
					var19(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
					var19 = arg1_2.Chances
					var19.Visible = true
					var19 = any_new_result1_upvr
					function var19.TweenBack() -- Line 72
						--[[ Upvalues[1]:
							[1]: arg1_2 (copied, readonly)
						]]
						arg1_2.Chances:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, function() -- Line 73
							--[[ Upvalues[1]:
								[1]: arg1_2 (copied, readonly)
							]]
							arg1_2.Chances.Visible = false
						end)
					end
				end
			end
			var19 = any_new_result1_upvr.TweenBack
			if var19 then
				var19 = any_new_result1_upvr
				var19.TweenBack = nil
			end
			-- KONSTANTERROR: [38] 31. Error Block 36 end (CF ANALYSIS FAILED)
		end)
		any_new_result1_upvr.OnDailyChanged = Util_upvr.Thread.Every(1, function() -- Line 82
			--[[ Upvalues[5]:
				[1]: RequiredZone_upvw (read and write)
				[2]: any_GetLink_result1_upvr (copied, readonly)
				[3]: arg1_2 (readonly)
				[4]: ProximityPrompt_upvr (readonly)
				[5]: Util_upvr (copied, readonly)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			local var25
			if var25 then
				var25 = any_GetLink_result1_upvr.Zones[RequiredZone_upvw]
				if not var25 then
					var25 = arg1_2.Buyable
					var25.Text = "LOCKED"
					return
				end
			end
			local function INLINED_2() -- Internal function, doesn't exist in bytecode
				var25 = any_GetLink_result1_upvr.DailyPack + 43200 - os.time()
				return var25
			end
			if not any_GetLink_result1_upvr.DailyPack or not INLINED_2() then
				var25 = -1
			end
			if 0 < var25 then
				ProximityPrompt_upvr.Enabled = false
			else
				ProximityPrompt_upvr.Enabled = true
			end
			if 0 >= var25 or not Util_upvr.ValueConvertor:FormatTime(var25) then
			end
			arg1_2.Buyable.Text = "FREE"
		end)
		arg1_2.Parent = LocalPlayer_upvr.PlayerGui
		local tbl = {
			Name = "BGUIRedirect";
		}
		tbl.Value = arg1_2
		tbl.Parent = arg1
		local any_Create_result1_upvr = Util_upvr.Create("ObjectValue", tbl)
		function any_new_result1_upvr.Reset() -- Line 102
			--[[ Upvalues[3]:
				[1]: arg1_2 (readonly)
				[2]: arg1 (copied, readonly)
				[3]: any_Create_result1_upvr (readonly)
			]]
			arg1_2.Parent = arg1
			any_Create_result1_upvr:Destroy()
		end
		return any_new_result1_upvr
	end
	local any_Sync_result1 = Util_upvr.Streamer:Sync(arg1, "BGUIRedirect")
	any_new_result1_upvr.SyncRedirect = any_Sync_result1
	any_new_result1_upvr.SyncRedirectTracker = any_Sync_result1.Loaded:Connect(function(arg1_4) -- Line 110
		--[[ Upvalues[1]:
			[1]: Load_upvr (readonly)
		]]
		Load_upvr(arg1_4.Value)
	end)
	local any_Sync_result1_2 = Util_upvr.Streamer:Sync(arg1, "BGUI")
	any_new_result1_upvr.SyncBGUI = any_Sync_result1_2
	any_new_result1_upvr.SyncBGUITracker = any_Sync_result1_2.Loaded:Connect(Load_upvr)
end
return module