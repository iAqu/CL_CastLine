-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:29:13
-- Luau version 6, Types version 3
-- Time taken: 0.000445 seconds

local 刷新UI_upvr = require(script.Parent["刷新UI"])
game:GetService("ReplicatedStorage").LocalMsg.teleHatch.Event:Connect(function(arg1) -- Line 6
	--[[ Upvalues[1]:
		[1]: 刷新UI_upvr (readonly)
	]]
	刷新UI_upvr.TeleHatch(arg1)
end)