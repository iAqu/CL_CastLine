-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:35
-- Luau version 6, Types version 3
-- Time taken: 0.000337 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("String")
function module.sanitize(arg1) -- Line 11
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	return var2_upvr.trim(arg1)
end
return module