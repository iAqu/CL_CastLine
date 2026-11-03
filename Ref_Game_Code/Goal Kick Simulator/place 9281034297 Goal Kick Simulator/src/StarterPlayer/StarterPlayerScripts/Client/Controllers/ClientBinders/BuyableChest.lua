-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:04
-- Luau version 6, Types version 3
-- Time taken: 0.006142 seconds

local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
local module = {}
local tbl_2_upvr = {}
Util_upvr.ChestStands = tbl_2_upvr
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module.Binder(arg1) -- Line 9
	--[[ Upvalues[3]:
		[1]: Util_upvr (readonly)
		[2]: tbl_2_upvr (readonly)
		[3]: LocalPlayer_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	local BGUI_upvw = arg1:FindFirstChild("BGUI")
	tbl_2_upvr[arg1.Name] = arg1
	any_new_result1_upvr:GiveTask(function() -- Line 16
		--[[ Upvalues[2]:
			[1]: tbl_2_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		tbl_2_upvr[arg1.Name] = nil
	end)
	if not BGUI_upvw then
		local BGUIRedirect = arg1:FindFirstChild("BGUIRedirect")
		if BGUIRedirect then
			BGUI_upvw = BGUIRedirect.Value
		else
			return
		end
	end
	local function _() -- Line 29, Named "IsClose"
		--[[ Upvalues[2]:
			[1]: LocalPlayer_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local Character = LocalPlayer_upvr.Character
		if Character then
			Character = LocalPlayer_upvr.Character:GetPivot().Position
		end
		if not Character then return end
		local var12 = Character - arg1:GetPivot().Position
		if var12.Magnitude >= 32 then
			var12 = false
		else
			var12 = true
		end
		return var12
	end
	local ProximityPrompt_upvr = Instance.new("ProximityPrompt")
	ProximityPrompt_upvr.KeyboardKeyCode = Enum.KeyCode.E
	ProximityPrompt_upvr.GamepadKeyCode = Enum.KeyCode.ButtonX
	ProximityPrompt_upvr.RequiresLineOfSight = false
	ProximityPrompt_upvr.ActionText = ""
	ProximityPrompt_upvr.MaxActivationDistance = 32
	local any_Sync_result1 = Util_upvr.Streamer:Sync(arg1, "ChestInteractable")
	any_new_result1_upvr:GiveTask(any_Sync_result1)
	any_new_result1_upvr:GiveTask(any_Sync_result1.Loaded:Connect(function(arg1_2) -- Line 48
		--[[ Upvalues[1]:
			[1]: ProximityPrompt_upvr (readonly)
		]]
		ProximityPrompt_upvr.Parent = arg1_2
	end))
	local RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
	local any_Sync_result1_2 = Util_upvr.Streamer:Sync(arg1, "PriceSG")
	any_new_result1_upvr:GiveTask(any_Sync_result1_2)
	any_new_result1_upvr:GiveTask(any_Sync_result1_2.Loaded:Connect(function(arg1_3) -- Line 57
		--[[ Upvalues[5]:
			[1]: RequiredZone_upvw (read and write)
			[2]: any_GetLink_result1_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
			[4]: arg1 (readonly)
			[5]: any_new_result1_upvr (readonly)
		]]
		local function UpdatePrice() -- Line 58
			--[[ Upvalues[5]:
				[1]: RequiredZone_upvw (copied, read and write)
				[2]: any_GetLink_result1_upvr (copied, readonly)
				[3]: arg1_3 (readonly)
				[4]: Util_upvr (copied, readonly)
				[5]: arg1 (copied, readonly)
			]]
			if RequiredZone_upvw and not any_GetLink_result1_upvr.Zones[RequiredZone_upvw] then
				arg1_3.Display.AmountText.Text = "???"
			else
				arg1_3.Display.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("Price") or 1000000)
			end
		end
		if RequiredZone_upvw and not any_GetLink_result1_upvr.Zones[RequiredZone_upvw] then
			arg1_3.Display.AmountText.Text = "???"
		else
			arg1_3.Display.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("Price") or 1000000)
		end
		if RequiredZone_upvw then
			any_new_result1_upvr.OnZoneChanged = any_GetLink_result1_upvr.Zones.Changed:On(RequiredZone_upvw, UpdatePrice)
		end
		any_new_result1_upvr.PriceChanged = arg1:GetAttributeChangedSignal("Price"):Connect(UpdatePrice)
	end))
	any_new_result1_upvr.PromptPurchase = ProximityPrompt_upvr.Triggered:Connect(function() -- Line 73
		--[[ Upvalues[4]:
			[1]: RequiredZone_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
		if RequiredZone_upvw and not any_GetLink_result1_upvr.Zones[RequiredZone_upvw] then
			Util_upvr.AwardDisplay:ShowAwardItem("Error", 1, "You must have \""..RequiredZone_upvw.."\" unlocked to purchase this.")
		else
			Util_upvr.PromptPurchase:Request(arg1.Name, arg1:GetAttribute("Price") or 1000000, function(arg1_4) -- Line 86
				--[[ Upvalues[2]:
					[1]: Util_upvr (copied, readonly)
					[2]: arg1 (copied, readonly)
				]]
				if arg1_4 and Util_upvr.Network:Invoke("PromptPurchaseChest", arg1) then
					return true
				end
			end, Util_upvr.CurrencyIconUtils.getIcon(arg1:GetAttribute("CurrencyType") or "Money"))
			return
		end
	end)
	any_new_result1_upvr.Prompt = ProximityPrompt_upvr
	any_new_result1_upvr.CheckProximity = Util_upvr.Thread.Every(0.35, function() -- Line 102
		--[[ Upvalues[7]:
			[1]: RequiredZone_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: any_new_result1_upvr (readonly)
			[5]: LocalPlayer_upvr (copied, readonly)
			[6]: Util_upvr (copied, readonly)
			[7]: BGUI_upvw (read and write)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		RequiredZone_upvw = arg1:GetAttribute("RequiredZone")
		local var26
		if RequiredZone_upvw then
			var26 = any_GetLink_result1_upvr.Zones
			if not var26[RequiredZone_upvw] then
				var26 = any_new_result1_upvr
				if var26.TweenBack then
					var26 = nil
					any_new_result1_upvr.TweenBack = var26
				end
				return
			end
		end
		var26 = LocalPlayer_upvr.Character
		if var26 then
			var26 = LocalPlayer_upvr.Character:GetPivot().Position
		end
		if not var26 then
		elseif (var26 - arg1:GetPivot().Position).Magnitude >= 32 then
		else
		end
		if true then
			if any_new_result1_upvr.TweenBack then
			else
				Util_upvr.Sounds:Play("ChestPopInfo")
				BGUI_upvw.Chances:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
				BGUI_upvw.Chances.Visible = true
				function any_new_result1_upvr.TweenBack() -- Line 115
					--[[ Upvalues[1]:
						[1]: BGUI_upvw (copied, read and write)
					]]
					BGUI_upvw.Chances:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true, function() -- Line 116
						--[[ Upvalues[1]:
							[1]: BGUI_upvw (copied, read and write)
						]]
						BGUI_upvw.Chances.Visible = false
					end)
				end
			end
		end
		if any_new_result1_upvr.TweenBack then
			any_new_result1_upvr.TweenBack = nil
		end
	end)
	BGUI_upvw.Parent = LocalPlayer_upvr.PlayerGui
	local tbl = {
		Name = "BGUIRedirect";
		Value = BGUI_upvw;
	}
	tbl.Parent = arg1
	local any_Create_result1_upvr = Util_upvr.Create("ObjectValue", tbl)
	function any_new_result1_upvr.Reset() -- Line 131
		--[[ Upvalues[3]:
			[1]: BGUI_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_Create_result1_upvr (readonly)
		]]
		BGUI_upvw.Parent = arg1
		any_Create_result1_upvr:Destroy()
	end
	return any_new_result1_upvr
end
return module