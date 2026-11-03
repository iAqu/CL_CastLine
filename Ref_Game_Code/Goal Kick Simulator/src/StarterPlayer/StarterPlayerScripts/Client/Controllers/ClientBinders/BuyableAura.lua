-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:12
-- Luau version 6, Types version 3
-- Time taken: 0.003094 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink()
	local ProximityPrompt_upvr = Instance.new("ProximityPrompt")
	ProximityPrompt_upvr.KeyboardKeyCode = Enum.KeyCode.E
	ProximityPrompt_upvr.GamepadKeyCode = Enum.KeyCode.ButtonX
	ProximityPrompt_upvr.RequiresLineOfSight = false
	ProximityPrompt_upvr.ActionText = ""
	ProximityPrompt_upvr.MaxActivationDistance = 20
	local RequiredRebirth_upvw = arg1:GetAttribute("RequiredRebirth")
	local any_SyncPrimaryPart_result1 = Util_upvr.Streamer:SyncPrimaryPart(arg1)
	any_new_result1_upvr:GiveTask(any_SyncPrimaryPart_result1)
	any_new_result1_upvr:GiveTask(any_SyncPrimaryPart_result1.Loaded:Connect(function(arg1_2) -- Line 22
		--[[ Upvalues[6]:
			[1]: ProximityPrompt_upvr (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: any_new_result1_upvr (readonly)
			[5]: RequiredRebirth_upvw (read and write)
			[6]: any_GetLink_result1_upvr (readonly)
		]]
		ProximityPrompt_upvr.Parent = arg1_2
		local any_GetAsset_result1_upvr = Util_upvr.Assets:GetAsset("Trails", arg1.Name)
		if any_GetAsset_result1_upvr then
			any_GetAsset_result1_upvr:PivotTo(arg1_2:GetPivot() * CFrame.new(0, 1 + arg1_2.Size.Y / 2 + any_GetAsset_result1_upvr.Size.Y / 2, 0))
			any_GetAsset_result1_upvr.Anchored = true
			any_new_result1_upvr.Object = any_GetAsset_result1_upvr
		end
		local function UpdatePrice(arg1_3) -- Line 33
			--[[ Upvalues[4]:
				[1]: RequiredRebirth_upvw (copied, read and write)
				[2]: arg1 (copied, readonly)
				[3]: any_GetAsset_result1_upvr (readonly)
				[4]: Util_upvr (copied, readonly)
			]]
			RequiredRebirth_upvw = arg1:GetAttribute("RequiredRebirth")
			if RequiredRebirth_upvw and arg1_3 < RequiredRebirth_upvw then
				arg1.PriceSG.Display.AmountText.Text = "???"
				any_GetAsset_result1_upvr.Parent = nil
			else
				any_GetAsset_result1_upvr.Parent = arg1
				arg1.PriceSG.Display.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("Price") or 1000000)
				arg1.PriceSG.Multi.AmountText.Text = '+'..Util_upvr.ValueConvertor:ShrinkNumber(math.ceil(((any_GetAsset_result1_upvr:GetAttribute("Multi") or 1) - 1) * 100 - 0.5))..'%'
			end
		end
		UpdatePrice(any_GetLink_result1_upvr.Rebirth)
		any_new_result1_upvr.RequiredRebirthChanged = arg1:GetAttributeChangedSignal("RequiredRebirth"):Connect(UpdatePrice)
		any_new_result1_upvr.RebirthChanged = any_GetLink_result1_upvr.Changed:On("Rebirth", UpdatePrice)
	end))
	any_new_result1_upvr.PromptPurchase = ProximityPrompt_upvr.Triggered:Connect(function() -- Line 50
		--[[ Upvalues[4]:
			[1]: RequiredRebirth_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: any_GetLink_result1_upvr (readonly)
			[4]: Util_upvr (copied, readonly)
		]]
		RequiredRebirth_upvw = arg1:GetAttribute("RequiredRebirth")
		local var15
		if RequiredRebirth_upvw then
			var15 = any_GetLink_result1_upvr
			var15 = RequiredRebirth_upvw
			if var15.Rebirth < var15 then
				var15 = Util_upvr
				var15.AwardDisplay:ShowAwardItem("Error", 1, "You must have "..Util_upvr.ValueConvertor:ShrinkNumber(RequiredRebirth_upvw).." Rebirths to purchase this.")
				return
			end
		end
		var15 = Util_upvr
		local any_SelectBall_result1_upvr_2 = var15.BallPick:SelectBall()
		var15 = any_SelectBall_result1_upvr_2
		if var15 then
			var15 = any_GetLink_result1_upvr.Inventory[any_SelectBall_result1_upvr_2]
		end
		if var15 then
			Util_upvr.PromptPurchase:Request("Apply \""..arg1.Name.."\" on "..var15.Name, arg1:GetAttribute("Price") or 1000000, function(arg1_5) -- Line 62
				--[[ Upvalues[3]:
					[1]: Util_upvr (copied, readonly)
					[2]: any_SelectBall_result1_upvr_2 (readonly)
					[3]: arg1 (copied, readonly)
				]]
				if arg1_5 and Util_upvr.Network:Invoke("EquipTrail", any_SelectBall_result1_upvr_2, arg1) then
					return true
				end
			end, "rbxassetid://9552021047")
		end
	end)
	any_new_result1_upvr.Prompt = ProximityPrompt_upvr
	return any_new_result1_upvr
end
return module