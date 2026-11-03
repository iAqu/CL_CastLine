-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:13
-- Luau version 6, Types version 3
-- Time taken: 0.001951 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1_upvr = Util_upvr.Maid.new()
	local ProximityPrompt_upvr = Instance.new("ProximityPrompt")
	ProximityPrompt_upvr.KeyboardKeyCode = Enum.KeyCode.E
	ProximityPrompt_upvr.GamepadKeyCode = Enum.KeyCode.ButtonX
	ProximityPrompt_upvr.ActionText = ""
	local any_Sync_result1_2 = Util_upvr.Streamer:Sync(arg1, "Attachment")
	any_new_result1_upvr:GiveTask(any_Sync_result1_2)
	any_new_result1_upvr:GiveTask(any_Sync_result1_2.Loaded:Connect(function(arg1_2) -- Line 18
		--[[ Upvalues[1]:
			[1]: ProximityPrompt_upvr (readonly)
		]]
		ProximityPrompt_upvr.Parent = arg1_2
	end))
	local tbl_upvr = {
		Sound = "windowswitch";
		Text = "You need "..(arg1:GetAttribute("RequiredRebirth") or 0).." Rebirths!";
	}
	any_new_result1_upvr.PromptPurchase = ProximityPrompt_upvr.Triggered:Connect(function() -- Line 28
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: tbl_upvr (readonly)
		]]
		Util_upvr.Windows:PromptNotification(tbl_upvr)
	end)
	arg1.CanCollide = true
	function any_new_result1_upvr.CancelCanCollide() -- Line 33
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.CanCollide = false
	end
	any_new_result1_upvr.Prompt = ProximityPrompt_upvr
	local any_Sync_result1 = Util_upvr.Streamer:Sync(arg1, "SurfaceGui")
	any_new_result1_upvr:GiveTask(any_Sync_result1)
	local Parent_upvr = arg1.Parent
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	any_new_result1_upvr:GiveTask(any_Sync_result1.Loaded:Connect(function(arg1_3) -- Line 43
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: Parent_upvr (readonly)
			[4]: any_GetLink_result1_upvr (readonly)
			[5]: any_new_result1_upvr (readonly)
		]]
		arg1_3.Frame.AwardDisplayFrame.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("RequiredRebirth") or 1000000).."+ Rebirths!"
		local UpdatePrice
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			UpdatePrice = Util_upvr.ReplicatedStorage
			return UpdatePrice
		end
		if (arg1:GetAttribute("RequiredRebirth") or 1000000) > any_GetLink_result1_upvr.Rebirth or not INLINED_2() then
			UpdatePrice = Parent_upvr
		end
		arg1.Parent = UpdatePrice
		UpdatePrice = "Rebirth"
		any_new_result1_upvr.ZonesUpdate = any_GetLink_result1_upvr.Changed:On(UpdatePrice, function(arg1_4) -- Line 44, Named "UpdatePurchased"
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: Parent_upvr (copied, readonly)
			]]
			local var15
			local function INLINED() -- Internal function, doesn't exist in bytecode
				var15 = Util_upvr.ReplicatedStorage
				return var15
			end
			if (arg1:GetAttribute("RequiredRebirth") or 1000000) > arg1_4 or not INLINED() then
				var15 = Parent_upvr
			end
			arg1.Parent = var15
		end)
		UpdatePrice = "Price"
		function UpdatePrice() -- Line 49
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_3 (readonly)
				[3]: Util_upvr (copied, readonly)
			]]
			arg1_3.Frame.AwardDisplayFrame.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("RequiredRebirth") or 1000000).."+ Rebirths!"
		end
		any_new_result1_upvr.PriceUpdate = arg1:GetAttributeChangedSignal(UpdatePrice):Connect(UpdatePrice)
	end))
	return any_new_result1_upvr
end
return module