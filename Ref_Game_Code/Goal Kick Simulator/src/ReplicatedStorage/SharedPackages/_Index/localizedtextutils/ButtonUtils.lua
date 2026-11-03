-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:08
-- Luau version 6, Types version 3
-- Time taken: 0.000345 seconds

return {
	getMouseOverColor = function(arg1, arg2) -- Line 14, Named "getMouseOverColor"
		local Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3 = Color3.toHSV(arg1)
		return Color3.fromHSV(Color3_toHSV_result1, Color3_toHSV_result2, Color3_toHSV_result3 - 0.05 * (arg2 or 1))
	end;
}