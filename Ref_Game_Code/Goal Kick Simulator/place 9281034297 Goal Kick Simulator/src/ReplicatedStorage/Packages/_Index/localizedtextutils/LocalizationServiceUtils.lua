-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:32
-- Luau version 6, Types version 3
-- Time taken: 0.001555 seconds

local module = {}
local var2_upvr = require(script.Parent.loader).load(script)("Promise")
local LocalizationService_upvr = game:GetService("LocalizationService")
local RunService_upvr = game:GetService("RunService")
function module.promiseTranslator(arg1) -- Line 15
	--[[ Upvalues[3]:
		[1]: var2_upvr (readonly)
		[2]: LocalizationService_upvr (readonly)
		[3]: RunService_upvr (readonly)
	]]
	local function var5(arg1_2, arg2) -- Line 16
		--[[ Upvalues[2]:
			[1]: LocalizationService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		local var6_upvw
		local pcall_result1, pcall_result2 = pcall(function() -- Line 18
			--[[ Upvalues[3]:
				[1]: var6_upvw (read and write)
				[2]: LocalizationService_upvr (copied, readonly)
				[3]: arg1 (copied, readonly)
			]]
			var6_upvw = LocalizationService_upvr:GetTranslatorForPlayerAsync(arg1)
		end)
		if not pcall_result1 then
			arg2(pcall_result2 or "Failed to GetTranslatorForPlayerAsync")
			do
				return
			end
			local var10
		end
		if var6_upvw then
			if typeof(var6_upvw) ~= "Instance" then
				var10 = false
			else
				var10 = true
			end
			assert(var10, "Bad translator")
			var10 = var6_upvw
			arg1_2(var10)
		else
			arg2("Translator was not returned")
		end
	end
	local any_spawn_result1_upvr = var2_upvr.spawn(var5)
	var5 = 20
	local var12_upvw = var5
	if RunService_upvr:IsStudio() then
		var12_upvw = 0.5
	end
	task.delay(var12_upvw, function() -- Line 43
		--[[ Upvalues[2]:
			[1]: any_spawn_result1_upvr (readonly)
			[2]: var12_upvw (read and write)
		]]
		if not any_spawn_result1_upvr:IsPending() then
		else
			any_spawn_result1_upvr:Reject("GetTranslatorForPlayerAsync is still pending after %f, using local table":format(var12_upvw))
		end
	end)
	return any_spawn_result1_upvr:Catch(function(arg1_3) -- Line 52
		--[[ Upvalues[2]:
			[1]: LocalizationService_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		if arg1_3 ~= "Publishing the game is required to use GetTranslatorForPlayerAsync API." then
			warn("[LocalizationServiceUtils.promiseTranslator] - %s":format(tostring(arg1_3)))
		end
		return LocalizationService_upvr:GetTranslatorForPlayer(arg1)
	end)
end
return module