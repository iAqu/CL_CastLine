-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:58
-- Luau version 6, Types version 3
-- Time taken: 0.000444 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local any_load_result1_upvr_result1_upvr_2 = any_load_result1_upvr("AnimationProvider")
local any_load_result1_upvr_result1_upvr = any_load_result1_upvr("Binder")
return any_load_result1_upvr("BinderProvider").new(function(arg1, arg2) -- Line 11
	--[[ Upvalues[3]:
		[1]: any_load_result1_upvr_result1_upvr_2 (readonly)
		[2]: any_load_result1_upvr_result1_upvr (readonly)
		[3]: any_load_result1_upvr (readonly)
	]]
	arg2:GetService(any_load_result1_upvr_result1_upvr_2)
	arg1:Add(any_load_result1_upvr_result1_upvr.new("HumanoidEmotePlayer", any_load_result1_upvr("HumanoidEmotePlayerClient"), arg2))
end)