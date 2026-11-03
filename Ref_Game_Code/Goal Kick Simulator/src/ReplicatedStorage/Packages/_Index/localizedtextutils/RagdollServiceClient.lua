-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:04
-- Luau version 6, Types version 3
-- Time taken: 0.001117 seconds

local any_load_result1_upvr = require(script.Parent.loader).load(script)
local var1_result1_upvr_2 = any_load_result1_upvr("RagdollServiceConstants")
local Players_upvr = game:GetService("Players")
local module = {
	ServiceName = "RagdollServiceClient";
	Init = function(arg1, arg2) -- Line 20, Named "Init"
		--[[ Upvalues[1]:
			[1]: any_load_result1_upvr (readonly)
		]]
		assert(not arg1._serviceBag, "Already initialized")
		arg1._serviceBag = assert(arg2, "No serviceBag")
		arg1._serviceBag:GetService(any_load_result1_upvr("Motor6DServiceClient"))
		arg1._serviceBag:GetService(any_load_result1_upvr("RagdollBindersClient"))
		arg1._screenShakeEnabled = true
	end;
	SetScreenShakeEnabled = function(arg1, arg2) -- Line 37, Named "SetScreenShakeEnabled"
		--[[ Upvalues[2]:
			[1]: Players_upvr (readonly)
			[2]: var1_result1_upvr_2 (readonly)
		]]
		local var5
		if type(arg2) ~= "boolean" then
			var5 = false
		else
			var5 = true
		end
		assert(var5, "Bad value")
		var5 = Players_upvr
		var5.LocalPlayer:SetAttribute(var1_result1_upvr_2.SCREEN_SHAKE_ENABLED_ATTRIBUTE)
	end;
}
local var1_result1_upvr = any_load_result1_upvr("AttributeUtils")
function module.GetScreenShakeEnabled(arg1) -- Line 47
	--[[ Upvalues[3]:
		[1]: var1_result1_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: var1_result1_upvr_2 (readonly)
	]]
	assert(arg1._serviceBag, "Not initialized")
	return var1_result1_upvr.getAttribute(Players_upvr.LocalPlayer, var1_result1_upvr_2.SCREEN_SHAKE_ENABLED_ATTRIBUTE, true)
end
return module