-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:36
-- Luau version 6, Types version 3
-- Time taken: 0.000689 seconds

return {
	getHumanoid = function(arg1) -- Line 13, Named "getHumanoid"
		local var2 = arg1
		while var2 do
			local class_Humanoid = var2:FindFirstChildOfClass("Humanoid")
			if class_Humanoid then
				return class_Humanoid
			end
		end
		return nil
	end;
	forceUnseatHumanoid = function(arg1) -- Line 32, Named "forceUnseatHumanoid"
		if arg1.SeatPart then
			local SeatWeld = arg1.SeatPart:FindFirstChild("SeatWeld")
			if SeatWeld then
				SeatWeld:Destroy()
			end
			arg1.SeatPart:Sit(nil)
		end
		arg1.Sit = false
	end;
}