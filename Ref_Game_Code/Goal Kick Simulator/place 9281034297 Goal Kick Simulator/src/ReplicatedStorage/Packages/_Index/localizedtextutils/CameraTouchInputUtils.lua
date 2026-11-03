-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:21:06
-- Luau version 6, Types version 3
-- Time taken: 0.000757 seconds

return {
	adjustTouchSensitivity = function(arg1, arg2, arg3) -- Line 28, Named "adjustTouchSensitivity"
		local var2
		if 0.5235987755982988 < arg1 and arg3.Y < 0 then
			var2 = 2.1 - (1 - (1 - (arg1 - 0.5235987755982988) / 0.8726646259971648) ^ 3) * 1.6
		elseif arg1 < -0.2617993877991494 and 0 < arg3.Y then
			var2 = 2.1 - (1 - (1 - (arg1 - -0.2617993877991494) / -1.1344640137963142) ^ 3) * 1.6
		end
		return Vector2.new(arg2.X, arg2.Y * var2)
	end;
}