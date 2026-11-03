-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:55
-- Luau version 6, Types version 3
-- Time taken: 0.000605 seconds

return {
	createResource = function(arg1) -- Line 7, Named "createResource"
		local var2
		if type(arg1) ~= "table" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "Bad data")
		var2 = arg1.name
		assert(var2, "Bad data.name")
		var2 = arg1.robloxName
		assert(var2, "Bad data.robloxName")
		return arg1
	end;
}