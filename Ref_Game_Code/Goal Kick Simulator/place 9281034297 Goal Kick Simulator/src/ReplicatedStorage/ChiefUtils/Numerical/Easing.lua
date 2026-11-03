-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:16
-- Luau version 6, Types version 3
-- Time taken: 0.000528 seconds

return {
	SinEnd = function(arg1) -- Line 7, Named "SinEnd"
		return math.sin(arg1 * (math.pi/2))
	end;
	SinStart = function(arg1) -- Line 11, Named "SinStart"
		return 1 - math.cos(arg1 * (math.pi/2))
	end;
	SinBoth = function(arg1) -- Line 15, Named "SinBoth"
		return 0.5 - math.cos(arg1 * math.pi) * 0.5
	end;
}