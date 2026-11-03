-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:05
-- Luau version 6, Types version 3
-- Time taken: 0.001928 seconds

return function(arg1, arg2) -- Line 24
	assert(arg1, "Bad _require function")
	local var12 = true
	if type(arg2) ~= "string" then
		var12 = true
		if type(arg2) ~= "number" then
			var12 = false
			if typeof(arg2) == "Instance" then
				var12 = arg2:IsA("ModuleScript")
			end
		end
	end
	assert(var12, "Bad module identifier")
	local var13_upvw
	local pcall_result1_3, _ = pcall(function() -- Line 32
		--[[ Upvalues[3]:
			[1]: var13_upvw (read and write)
			[2]: arg1 (readonly)
			[3]: arg2 (readonly)
		]]
		var13_upvw = arg1(arg2)
	end)
	if not pcall_result1_3 then
		return nil
	end
	return var13_upvw
end