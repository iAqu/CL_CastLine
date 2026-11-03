-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:50
-- Luau version 6, Types version 3
-- Time taken: 0.000429 seconds

local var1 = require(script.Parent.loader).load(script)("TieDefinition")
return var1.new("Area", {
	HumanoidEntered = var1.Types.SIGNAL;
	HumanoidExited = var1.Types.SIGNAL;
	PlayerEntered = var1.Types.SIGNAL;
	PlayerExited = var1.Types.SIGNAL;
	GetPlayerList = var1.Types.METHOD;
	GetHumanoidList = var1.Types.METHOD;
	ObservePlayerInAreaBrio = var1.Types.METHOD;
	ObservePlayersBrio = var1.Types.METHOD;
	ObserveHumanoidsBrio = var1.Types.METHOD;
	HumanoidCount = 0;
	PlayerCount = 0;
})