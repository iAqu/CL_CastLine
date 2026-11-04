-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:20
-- Luau version 6, Types version 3
-- Time taken: 0.000359 seconds

local module = {}
local TranslationHelper_upvr = require(game.ReplicatedStorage.Tool.TranslationHelper)
local Parent_upvr = script.Parent
function module.SetText() -- Line 6
	--[[ Upvalues[2]:
		[1]: TranslationHelper_upvr (readonly)
		[2]: Parent_upvr (readonly)
	]]
	TranslationHelper_upvr.SetText(Parent_upvr, Parent_upvr.Name)
end
return module