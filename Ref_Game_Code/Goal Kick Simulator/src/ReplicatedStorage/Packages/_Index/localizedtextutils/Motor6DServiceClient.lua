-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:30
-- Luau version 6, Types version 3
-- Time taken: 0.000491 seconds

local module = {
	ServiceName = "Motor6DServiceClient";
}
local any_load_result1_upvr = require(script.Parent.loader).load(script)
function module.Init(arg1, arg2) -- Line 10
	--[[ Upvalues[1]:
		[1]: any_load_result1_upvr (readonly)
	]]
	assert(not arg1._serviceBag, "Already initialized")
	arg1._serviceBag = assert(arg2, "No serviceBag")
	arg1._serviceBag:GetService(any_load_result1_upvr("Motor6DBindersClient"))
end
return module