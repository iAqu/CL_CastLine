-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:22:24
-- Luau version 6, Types version 3
-- Time taken: 0.001269 seconds

local any_load_result1 = require(script.Parent.loader).load(script)
local module = {}
local var1_result1_upvr_2 = any_load_result1("Maid")
local var1_result1_upvr = any_load_result1("DialogTemplatesClient")
local any_load_result1_result1_upvr = any_load_result1("SoundUtils")
local var1_result1_upvr_3 = any_load_result1("HapticFeedbackUtils")
local UserInputService_upvr = game:GetService("UserInputService")
function module.setupFeedback(arg1, arg2) -- Line 16
	--[[ Upvalues[5]:
		[1]: var1_result1_upvr_2 (readonly)
		[2]: var1_result1_upvr (readonly)
		[3]: any_load_result1_result1_upvr (readonly)
		[4]: var1_result1_upvr_3 (readonly)
		[5]: UserInputService_upvr (readonly)
	]]
	assert(arg1, "No serviceBag")
	assert(arg2, "Bad buttonModel")
	local any_new_result1 = var1_result1_upvr_2.new()
	local service_upvr = arg1:GetService(var1_result1_upvr)
	any_new_result1:GiveTask(arg2.IsSelected.Changed:Connect(function() -- Line 24
		--[[ Upvalues[5]:
			[1]: arg2 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: service_upvr (readonly)
			[4]: var1_result1_upvr_3 (copied, readonly)
			[5]: UserInputService_upvr (copied, readonly)
		]]
		if arg2.InteractionEnabled.Value and arg2.IsSelected.Value then
			any_load_result1_result1_upvr.playTemplate(service_upvr, "SinglePlopTemplate")
			var1_result1_upvr_3.smallVibrate(UserInputService_upvr:GetLastInputType(), nil, 0.25)
		end
	end))
	any_new_result1:GiveTask(arg2.IsMouseOrTouchOver.Changed:Connect(function() -- Line 31
		--[[ Upvalues[3]:
			[1]: arg2 (readonly)
			[2]: any_load_result1_result1_upvr (copied, readonly)
			[3]: service_upvr (readonly)
		]]
		if arg2.InteractionEnabled.Value then
			any_load_result1_result1_upvr.playTemplate(service_upvr, "SinglePlopTemplate")
		end
	end))
	return any_new_result1
end
return module