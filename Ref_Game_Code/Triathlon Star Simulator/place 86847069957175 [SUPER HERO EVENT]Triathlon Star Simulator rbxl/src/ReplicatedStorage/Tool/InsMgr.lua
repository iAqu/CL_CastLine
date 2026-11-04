-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:22:30
-- Luau version 6, Types version 3
-- Time taken: 0.000866 seconds

return {
	GetIns = function(arg1, arg2, arg3) -- Line 4, Named "GetIns"
		local SOME = arg3:FindFirstChild(tostring(arg1))
		if not SOME then
			SOME = Instance.new(arg2, arg3)
			SOME.Name = arg1
		end
		return SOME
	end;
}