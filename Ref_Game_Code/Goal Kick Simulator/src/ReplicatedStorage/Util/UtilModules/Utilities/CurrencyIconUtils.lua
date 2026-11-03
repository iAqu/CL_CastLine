-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:33
-- Luau version 6, Types version 3
-- Time taken: 0.000492 seconds

return {
	getIcon = function(arg1) -- Line 4, Named "getIcon"
		local Util = require(game:GetService("ReplicatedStorage").Util)
		local var3 = Util.Icons[arg1]
		if not var3 then
			var3 = Util.Icons.default_missing
		end
		return var3
	end;
}