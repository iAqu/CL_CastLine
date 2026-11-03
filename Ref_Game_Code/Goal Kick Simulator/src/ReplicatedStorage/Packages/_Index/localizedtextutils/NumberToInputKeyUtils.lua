-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:23:34
-- Luau version 6, Types version 3
-- Time taken: 0.000706 seconds

local module_upvr = {{Enum.KeyCode.One, Enum.KeyCode.KeypadOne}, {Enum.KeyCode.Two, Enum.KeyCode.KeypadTwo}, {Enum.KeyCode.Three, Enum.KeyCode.KeypadThree}, {Enum.KeyCode.Four, Enum.KeyCode.KeypadFour}, {Enum.KeyCode.Five, Enum.KeyCode.KeypadFive}, {Enum.KeyCode.Six, Enum.KeyCode.KeypadSix}, {Enum.KeyCode.Seven, Enum.KeyCode.KeypadSeven}, {Enum.KeyCode.Eight, Enum.KeyCode.KeypadEight}, {Enum.KeyCode.Nine, Enum.KeyCode.KeypadNine}}
return {
	getInputsForNumber = function(arg1) -- Line 26, Named "getInputsForNumber"
		--[[ Upvalues[1]:
			[1]: module_upvr (readonly)
		]]
		return module_upvr[arg1]
	end;
}