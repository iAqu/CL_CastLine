-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:57
-- Luau version 6, Types version 3
-- Time taken: 0.000714 seconds

return {
	bind = function(arg1, arg2) -- Line 15, Named "bind"
		local var2
		if type(arg1) ~= "table" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "'self' must be a table")
		if type(arg2) ~= "function" then
			var2 = false
		else
			var2 = true
		end
		assert(var2, "'func' must be a function")
		return function(...) -- Line 19
			--[[ Upvalues[2]:
				[1]: arg2 (readonly)
				[2]: arg1 (readonly)
			]]
			return arg2(arg1, ...)
		end
	end;
}