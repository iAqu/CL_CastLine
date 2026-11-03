-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:29:03
-- Luau version 6, Types version 3
-- Time taken: 0.000524 seconds

return {
	getDampenedAngleClamp = function(arg1, arg2, arg3) -- Line 8, Named "getDampenedAngleClamp"
		local var3_upvw = arg3 or arg2
		return function(arg1_2) -- Line 10
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: arg2 (readonly)
				[3]: var3_upvw (read and write)
			]]
			local var4 = arg1 - arg2
			if math.abs(arg1_2) <= var4 then
				return arg1_2
			end
			return math.sign(arg1_2) * (var4 + (1 - 0.5 ^ ((math.abs(arg1_2) - var4) / var3_upvw)) * arg2)
		end
	end;
}