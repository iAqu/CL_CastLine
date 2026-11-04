-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:57
-- Luau version 6, Types version 3
-- Time taken: 0.000782 seconds

return {
	IsItemAutoDeleteOn = function(arg1, arg2) -- Line 7, Named "IsItemAutoDeleteOn"
		if not arg2 then return end
		local AutoDelete = arg1:FindFirstChild("AutoDelete")
		if AutoDelete then
			local SOME = AutoDelete:FindFirstChild(tostring(arg2))
			if SOME then
				if SOME.Value == 1 then
					return true
				end
				return false
			end
		end
		return false
	end;
}