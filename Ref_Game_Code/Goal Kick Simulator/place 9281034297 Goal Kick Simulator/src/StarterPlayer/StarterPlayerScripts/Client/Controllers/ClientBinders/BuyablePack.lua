-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:06
-- Luau version 6, Types version 3
-- Time taken: 0.005414 seconds

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
	local RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
	local function _() -- Line 12, Named "IsClose"
		--[[ Upvalues[2]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local Character_2 = LocalPlayer_upvr.Character
		if Character_2 then
			Character_2 = LocalPlayer_upvr.Character:GetPivot().Position
		end
		if not Character_2 then return end
		local var9 = Character_2 - arg1:GetPivot().Position
		if var9.Magnitude >= 32 then
			var9 = false
		else
			var9 = true
		end
		return var9
	end
	local function Load_upvr(arg1_2) -- Line 20, Named "Load"
		--[[ Upvalues[6]:
			[1]: any_new_result1_upvr (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: RequiredZone_upvw (read and write)
			[4]: arg1 (readonly)
			[5]: any_GetLink_result1_upvr (readonly)
			[6]: LocalPlayer_upvr (copied, readonly)
		]]
		any_new_result1_upvr.CheckProximity = Util_upvr.Thread.Every(0.35, function() -- Line 21
			--[[ Upvalues[7]:
				[1]: RequiredZone_upvw (copied, read and write)
				[2]: arg1 (copied, readonly)
				[3]: any_GetLink_result1_upvr (copied, readonly)
				[4]: any_new_result1_upvr (copied, readonly)
				[5]: LocalPlayer_upvr (copied, readonly)
				[6]: Util_upvr (copied, readonly)
				[7]: arg1_2 (readonly)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
			local var15
			if RequiredZone_upvw then
				var15 = any_GetLink_result1_upvr.Zones
				if not var15[RequiredZone_upvw] then
					var15 = any_new_result1_upvr
					if var15.TweenBack then
						var15 = nil
						any_new_result1_upvr.TweenBack = var15
					end
					return
				end
			end
			var15 = LocalPlayer_upvr.Character
			if var15 then
				var15 = LocalPlayer_upvr.Character:GetPivot().Position
			end
			if not var15 then
			elseif (var15 - arg1:GetPivot().Position).Magnitude >= 32 then
			else
			end
			if true then
				if any_new_result1_upvr.TweenBack then
				else
					Util_upvr.Sounds:Play("ChestPopInfo")
					arg1_2.Chances:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
					arg1_2.Chances.Visible = true
					function any_new_result1_upvr.TweenBack() -- Line 34
						--[[ Upvalues[1]:
							[1]: arg1_2 (copied, readonly)
						]]
						arg1_2.Chances:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, function() -- Line 35
							--[[ Upvalues[1]:
								[1]: arg1_2 (copied, readonly)
							]]
							arg1_2.Chances.Visible = false
						end)
					end
				end
			end
			if any_new_result1_upvr.TweenBack then
				any_new_result1_upvr.TweenBack = nil
			end
		end)
		if arg1_2.Parent ~= LocalPlayer_upvr.PlayerGui then
			arg1_2.Parent = LocalPlayer_upvr.PlayerGui
			local tbl = {
				Name = "BGUIRedirect";
			}
			tbl.Value = arg1_2
			tbl.Parent = arg1
			local any_Create_result1_upvr = Util_upvr.Create("ObjectValue", tbl)
			function any_new_result1_upvr.Reset() -- Line 50
				--[[ Upvalues[3]:
					[1]: arg1_2 (readonly)
					[2]: arg1 (copied, readonly)
					[3]: any_Create_result1_upvr (readonly)
				]]
				arg1_2.Parent = arg1
				any_Create_result1_upvr:Destroy()
			end
		end
		any_Create_result1_upvr = any_new_result1_upvr
		any_Create_result1_upvr.BGUIRedirectLoaded = nil
		any_Create_result1_upvr = any_new_result1_upvr
		any_Create_result1_upvr.BGUIRedirectSyncObject = nil
		any_Create_result1_upvr = any_new_result1_upvr
		any_Create_result1_upvr.BGUILoaded = nil
		any_Create_result1_upvr = any_new_result1_upvr
		any_Create_result1_upvr.BGUISyncObject = nil
	end
	local any_Sync_result1_4 = Util_upvr.Streamer:Sync(arg1, "BGUI")
	any_new_result1_upvr.BGUISyncObject = any_Sync_result1_4
	any_new_result1_upvr.BGUILoaded = any_Sync_result1_4.Loaded:Connect(Load_upvr)
	local any_Sync_result1_3 = Util_upvr.Streamer:Sync(arg1, "BGUIRedirect")
	any_new_result1_upvr.BGUIRedirectSyncObject = any_Sync_result1_3
	any_new_result1_upvr.BGUIRedirectLoaded = any_Sync_result1_3.Loaded:Connect(function(arg1_3) -- Line 70
		--[[ Upvalues[1]:
			[1]: Load_upvr (readonly)
		]]
		Load_upvr(arg1_3.Value)
	end)
	local ProximityPrompt_upvr = Instance.new("ProximityPrompt")
	ProximityPrompt_upvr.KeyboardKeyCode = Enum.KeyCode.E
	ProximityPrompt_upvr.GamepadKeyCode = Enum.KeyCode.ButtonX
	ProximityPrompt_upvr.RequiresLineOfSight = false
	ProximityPrompt_upvr.ActionText = ""
	ProximityPrompt_upvr.MaxActivationDistance = 32
	local any_Sync_result1_2 = Util_upvr.Streamer:Sync(arg1, "Interactable")
	any_new_result1_upvr:GiveTask(any_Sync_result1_2)
	any_new_result1_upvr:GiveTask(any_Sync_result1_2.Loaded:Connect(function(arg1_4) -- Line 86
		--[[ Upvalues[1]:
			[1]: ProximityPrompt_upvr (readonly)
		]]
		ProximityPrompt_upvr.Parent = arg1_4
	end))
	any_new_result1_upvr.PromptPurchase = ProximityPrompt_upvr.Triggered:Connect(function() -- Line 90
		--[[ Upvalues[4]:
			[1]: RequiredZone_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
		if RequiredZone_upvw then
			if not any_GetLink_result1_upvr.Zones[RequiredZone_upvw] then
				Util_upvr.AwardDisplay:ShowAwardItem("Error", 1, "You must have \""..RequiredZone_upvw.."\" unlocked to purchase this.")
				return
			end
		end
		Util_upvr.PromptPurchase:Request(arg1.Name, arg1:GetAttribute("Price") or 1000000, function(arg1_5) -- Line 99
			--[[ Upvalues[2]:
				[1]: Util_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
			]]
			if arg1_5 and Util_upvr.Network:Invoke("PromptPurchasePack", arg1) then
				return true
			end
		end, "rbxassetid://9552021047")
	end)
	any_new_result1_upvr.Prompt = ProximityPrompt_upvr
	local any_Sync_result1 = Util_upvr.Streamer:Sync(arg1, "PriceSG")
	any_new_result1_upvr:GiveTask(any_Sync_result1)
	any_new_result1_upvr:GiveTask(any_Sync_result1.Loaded:Connect(function(arg1_6) -- Line 111
		--[[ Upvalues[5]:
			[1]: RequiredZone_upvw (read and write)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: arg1 (readonly)
			[5]: any_new_result1_upvr (readonly)
		]]
		local function UpdatePrice() -- Line 112
			--[[ Upvalues[5]:
				[1]: RequiredZone_upvw (copied, read and write)
				[2]: any_GetLink_result1_upvr (copied, readonly)
				[3]: arg1_6 (readonly)
				[4]: Util_upvr (copied, readonly)
				[5]: arg1 (copied, readonly)
			]]
			if RequiredZone_upvw and not any_GetLink_result1_upvr.Zones[RequiredZone_upvw] then
				arg1_6.Display.AmountText.Text = "???"
			else
				arg1_6.Display.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("Price") or 1000000)
			end
		end
		if RequiredZone_upvw and not any_GetLink_result1_upvr.Zones[RequiredZone_upvw] then
			arg1_6.Display.AmountText.Text = "???"
		else
			arg1_6.Display.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("Price") or 1000000)
		end
		if RequiredZone_upvw then
			any_new_result1_upvr.OnZoneChanged = any_GetLink_result1_upvr.Zones.Changed:On(RequiredZone_upvw, UpdatePrice)
		end
		any_new_result1_upvr.PriceChanged = arg1:GetAttributeChangedSignal("Price"):Connect(UpdatePrice)
	end))
	return any_new_result1_upvr
end
return module