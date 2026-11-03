-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:30
-- Luau version 6, Types version 3
-- Time taken: 0.000961 seconds

local module = {
	ServiceName = "HumanoidTrackerService";
}
local var2_upvr = require(script.Parent.loader).load(script)("HumanoidTracker")
local Players_upvr = game:GetService("Players")
function module.Init(arg1) -- Line 14
	--[[ Upvalues[2]:
		[1]: var2_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	assert(not arg1._humanoidTracker, "Already initialized")
	arg1._humanoidTracker = var2_upvr.new(Players_upvr.LocalPlayer)
end
function module.GetHumanoidTracker(arg1) -- Line 20
	assert(arg1._humanoidTracker, "Not initialized")
	return arg1._humanoidTracker
end
return module