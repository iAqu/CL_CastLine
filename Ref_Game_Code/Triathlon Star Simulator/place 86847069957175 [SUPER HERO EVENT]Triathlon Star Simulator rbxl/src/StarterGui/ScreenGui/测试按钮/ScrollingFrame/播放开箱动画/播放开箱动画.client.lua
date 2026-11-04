-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:26:44
-- Luau version 6, Types version 3
-- Time taken: 0.000491 seconds

local HatchEffect_upvr = require(game:GetService("ReplicatedStorage").Tool.HatchEffect)
script.Parent.MouseButton1Click:Connect(function() -- Line 9
	--[[ Upvalues[1]:
		[1]: HatchEffect_upvr (readonly)
	]]
	HatchEffect_upvr.ShowItemEffect({script.Parent.Parent.Parent["背包系统"]["道具ID"].Text})
end)