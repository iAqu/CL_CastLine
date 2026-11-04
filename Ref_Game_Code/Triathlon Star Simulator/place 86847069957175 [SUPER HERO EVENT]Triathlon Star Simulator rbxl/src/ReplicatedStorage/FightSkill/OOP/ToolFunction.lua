-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:25:45
-- Luau version 6, Types version 3
-- Time taken: 0.000430 seconds

return {
	Call = function(arg1, arg2, ...) -- Line 3, Named "Call"
		if arg1 ~= nil and arg2 ~= nil and arg1[arg2] ~= nil and type(arg1[arg2]) == "function" then
			arg1[arg2](...)
		end
	end;
}