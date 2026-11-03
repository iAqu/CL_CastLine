-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:22
-- Luau version 6, Types version 3
-- Time taken: 0.000434 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("DialogStyleUtils")
function module.pushTheme(arg1, arg2) -- Line 11
	--[[ Upvalues[1]:
		[1]: var2_upvr (readonly)
	]]
	table.insert(arg1, 1, var2_upvr.createPushStyle({
		font = arg2:GetFont("font");
		textColor3 = arg2:ObserveColor("text");
	}))
end
return module