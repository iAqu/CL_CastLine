-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:20:51
-- Luau version 6, Types version 3
-- Time taken: 0.000349 seconds

if game:GetService("RunService"):IsClient() then
	return {}
end
return {
	SetCollision = function(arg1, arg2, arg3) -- Line 4, Named "SetCollision"
		arg2.CollisionGroup = arg3
	end;
}