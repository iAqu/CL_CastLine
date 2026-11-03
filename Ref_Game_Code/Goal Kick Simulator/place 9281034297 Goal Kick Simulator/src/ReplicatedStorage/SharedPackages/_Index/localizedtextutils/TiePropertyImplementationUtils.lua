-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:24:57
-- Luau version 6, Types version 3
-- Time taken: 0.000513 seconds

return {
	changeToClassIfNeeded = function(arg1, arg2, arg3) -- Line 7, Named "changeToClassIfNeeded"
		local any_GetMemberName_result1 = arg1:GetMemberName()
		arg2:SetAttribute(any_GetMemberName_result1, nil)
		local SOME = arg2:FindFirstChild(any_GetMemberName_result1)
		if SOME then
			if SOME.ClassName == arg3 then
				return SOME
			end
			SOME:Destroy()
		end
		local any = Instance.new(arg3)
		any.Archivable = false
		any.Name = any_GetMemberName_result1
		return any
	end;
}