-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:36
-- Luau version 6, Types version 3
-- Time taken: 0.000390 seconds

local module = {}
local SystemBUFF_upvr = require(game:GetService("ServerStorage").System.SystemBUFF)
function module.Use(arg1, arg2) -- Line 4
	--[[ Upvalues[1]:
		[1]: SystemBUFF_upvr (readonly)
	]]
	SystemBUFF_upvr.AddBUFF(arg1, arg2[1], arg2[2])
	return true
end
return module