-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:59
-- Luau version 6, Types version 3
-- Time taken: 0.002967 seconds

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
	local any_Sync_result1 = Util_upvr.Streamer:Sync(arg1, "Attachment")
	any_new_result1_upvr:GiveTask(any_Sync_result1)
	any_new_result1_upvr:GiveTask(any_Sync_result1.Loaded:Connect(function(arg1_2) -- Line 18
		--[[ Upvalues[1]:
			[1]: ProximityPrompt_upvr (readonly)
		]]
		ProximityPrompt_upvr.Parent = arg1_2
	end))
	any_new_result1_upvr.PromptPurchase = ProximityPrompt_upvr.Triggered:Connect(function() -- Line 23
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: ProximityPrompt_upvr (readonly)
			[3]: Util_upvr (copied, readonly)
		]]
		ProximityPrompt_upvr.Enabled = false
		Util_upvr.PromptPurchase:Request(arg1.Name, arg1:GetAttribute("Price") or 1000000, function(arg1_3) -- Line 30
			--[[ Upvalues[3]:
				[1]: ProximityPrompt_upvr (copied, readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
			]]
			ProximityPrompt_upvr.Enabled = true
			if arg1_3 and Util_upvr.Network:Invoke("UnlockArea", arg1) then
				return true
			end
		end, Util_upvr.CurrencyIconUtils.getIcon(arg1:GetAttribute("CurrencyType") or "Money"))
	end)
	any_new_result1_upvr.Prompt = ProximityPrompt_upvr
	arg1.CanCollide = true
	local Parent_upvr = arg1.Parent
	any_new_result1_upvr:GiveTask(function() -- Line 43
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Parent_upvr (readonly)
		]]
		arg1.Parent = Parent_upvr
	end)
	local any_Sync_result1_2 = Util_upvr.Streamer:Sync(arg1, "SurfaceGui")
	any_new_result1_upvr:GiveTask(any_Sync_result1_2)
	local any_GetLink_result1_upvr = Util_upvr.Link:GetLink("PlayerData")
	any_new_result1_upvr:GiveTask(any_Sync_result1_2.Loaded:Connect(function(arg1_4) -- Line 49
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: Util_upvr (copied, readonly)
			[3]: Parent_upvr (readonly)
			[4]: any_GetLink_result1_upvr (readonly)
			[5]: any_new_result1_upvr (readonly)
		]]
		arg1_4.Frame.AwardDisplayFrame.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("Price") or 1000000)
		local var16
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var16 = Util_upvr.ReplicatedStorage.BinderWorkspace
			return var16
		end
		if not any_GetLink_result1_upvr.Zones[arg1.Name] or not INLINED_2() then
			var16 = Parent_upvr
		end
		arg1.Parent = var16
		var16 = arg1
		any_new_result1_upvr.AncesterChanged = var16.AncestryChanged:Connect(function() -- Line 59
			--[[ Upvalues[4]:
				[1]: any_GetLink_result1_upvr (copied, readonly)
				[2]: arg1 (copied, readonly)
				[3]: Util_upvr (copied, readonly)
				[4]: Parent_upvr (copied, readonly)
			]]
			local var18
			local function INLINED_3() -- Internal function, doesn't exist in bytecode
				var18 = Util_upvr.ReplicatedStorage.BinderWorkspace
				return var18
			end
			if not any_GetLink_result1_upvr.Zones[arg1.Name] or not INLINED_3() then
				var18 = Parent_upvr
			end
			arg1.Parent = var18
		end)
		var16 = any_GetLink_result1_upvr.Zones
		any_new_result1_upvr.ZonesUpdate = var16.Changed:On(arg1.Name, function(arg1_5) -- Line 50, Named "UpdatePurchased"
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: Util_upvr (copied, readonly)
				[3]: Parent_upvr (copied, readonly)
			]]
			local var15
			local function INLINED() -- Internal function, doesn't exist in bytecode
				var15 = Util_upvr.ReplicatedStorage.BinderWorkspace
				return var15
			end
			if not arg1_5 or not INLINED() then
				var15 = Parent_upvr
			end
			arg1.Parent = var15
		end)
		any_new_result1_upvr.PriceUpdate = arg1:GetAttributeChangedSignal("Price"):Connect(function() -- Line 53, Named "UpdatePrice"
			--[[ Upvalues[3]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_4 (readonly)
				[3]: Util_upvr (copied, readonly)
			]]
			arg1_4.Frame.AwardDisplayFrame.AmountText.Text = Util_upvr.ValueConvertor:ShrinkNumber(arg1:GetAttribute("Price") or 1000000)
		end)
	end))
	return any_new_result1_upvr
end
return module