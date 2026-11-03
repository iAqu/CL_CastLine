-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:28:51
-- Luau version 6, Types version 3
-- Time taken: 0.000396 seconds

return {
	getForHumanoid = function(arg1, arg2) -- Line 7, Named "getForHumanoid"
		local class_Animator = arg2:FindFirstChildOfClass("Animator")
		if not class_Animator then
			return nil
		end
		return arg1:Get(class_Animator)
	end;
}