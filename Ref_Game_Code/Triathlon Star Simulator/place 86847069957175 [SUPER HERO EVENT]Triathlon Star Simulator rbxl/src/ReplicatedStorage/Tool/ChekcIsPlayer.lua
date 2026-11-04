-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:23:35
-- Luau version 6, Types version 3
-- Time taken: 0.000779 seconds

return {
	IsOwner = function(arg1, arg2) -- Line 6, Named "IsOwner"
		if not arg1 then
		else
			local any_GetPlayerFromCharacter_result1_2 = game.Players:GetPlayerFromCharacter(arg1)
			if not any_GetPlayerFromCharacter_result1_2 then return end
			if any_GetPlayerFromCharacter_result1_2.UserId == arg2 then
				return any_GetPlayerFromCharacter_result1_2
			end
			if arg2 == 0 or arg2 == nil then
				return any_GetPlayerFromCharacter_result1_2
			end
		end
	end;
	IsPlayer = function(arg1, arg2) -- Line 28, Named "IsPlayer"
		if not arg1 then return end
		if arg1.Name ~= "HumanoidRootPart" then return end
		if not arg1.Parent then return end
		local any_GetPlayerFromCharacter_result1 = game.Players:GetPlayerFromCharacter(arg1.Parent)
		if not any_GetPlayerFromCharacter_result1 then return end
		return any_GetPlayerFromCharacter_result1
	end;
}