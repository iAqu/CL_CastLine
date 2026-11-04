-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:27
-- Luau version 6, Types version 3
-- Time taken: 0.000350 seconds

local module = {}
local showLocalUI_upvr = game.ReplicatedStorage.ServerMsg.showLocalUI
function module.UpdateUI(arg1, arg2, arg3) -- Line 5
	--[[ Upvalues[1]:
		[1]: showLocalUI_upvr (readonly)
	]]
	showLocalUI_upvr:FireClient(arg1, arg2, arg3)
end
return module