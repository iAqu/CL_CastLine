-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:44
-- Luau version 6, Types version 3
-- Time taken: 0.000636 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("DialogEntityTypes")
function module.getTalkerFromLocalizedContext(arg1) -- Line 11
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	for _, v in pairs(arg1) do
		if v.type == var2_upvr.TALKER_ENTITY then
			return v
		end
	end
	return nil
end
return module