-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:30:49
-- Luau version 6, Types version 3
-- Time taken: 0.000603 seconds

local module = {}
local ProximityPromptService_upvr = game:GetService("ProximityPromptService")
local Util_upvr = require(game:GetService("ReplicatedStorage").Util)
function module.Start(arg1) -- Line 7
	--[[ Upvalues[2]:
		[1]: ProximityPromptService_upvr (readonly)
		[2]: Util_upvr (readonly)
	]]
	ProximityPromptService_upvr.PromptShown:Connect(function(arg1_2) -- Line 8
		--[[ Upvalues[1]:
			[1]: Util_upvr (copied, readonly)
		]]
		if arg1_2.Style == Enum.ProximityPromptStyle.Default then
		else
			local any_GetAsset_result1 = Util_upvr.Assets:GetAsset("UI", "ProximityPrompt")
			any_GetAsset_result1.Adornee = arg1_2.Parent
			any_GetAsset_result1.Parent = Util_upvr.PlayerGui
		end
	end)
end
return module