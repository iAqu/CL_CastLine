-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:31:01
-- Luau version 6, Types version 3
-- Time taken: 0.000868 seconds

local module = {}
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Binder(arg1) -- Line 5
	--[[ Upvalues[1]:
		[1]: Util_upvr (readonly)
	]]
	local any_new_result1 = Util_upvr.Maid.new()
	local ProximityPrompt = Instance.new("ProximityPrompt")
	ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
	ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
	ProximityPrompt.RequiresLineOfSight = false
	ProximityPrompt.ActionText = ""
	ProximityPrompt.MaxActivationDistance = 32
	ProximityPrompt.Parent = arg1
	repeat
		task.wait()
	until Util_upvr.Windows
	local CannonTargets_upvr = Util_upvr.Windows.Object.Windows:FindFirstChild("CannonTargets")
	any_new_result1.PromptPurchase = ProximityPrompt.Triggered:Connect(function() -- Line 20
		--[[ Upvalues[2]:
			[1]: Util_upvr (copied, readonly)
			[2]: CannonTargets_upvr (readonly)
		]]
		Util_upvr.Windows:SwitchWindow(CannonTargets_upvr)
	end)
	any_new_result1.Prompt = ProximityPrompt
	return any_new_result1
end
return module