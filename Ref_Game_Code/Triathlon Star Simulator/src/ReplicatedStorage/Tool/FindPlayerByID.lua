-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:24:20
-- Luau version 6, Types version 3
-- Time taken: 0.000502 seconds

return {
	getPlayerByID = function(arg1) -- Line 7, Named "getPlayerByID"
		if not arg1 then
			return nil
		end
		for _, v in pairs(game.Players:GetChildren()) do
			if v.UserId == arg1 then
				return v
			end
		end
		return nil
	end;
}