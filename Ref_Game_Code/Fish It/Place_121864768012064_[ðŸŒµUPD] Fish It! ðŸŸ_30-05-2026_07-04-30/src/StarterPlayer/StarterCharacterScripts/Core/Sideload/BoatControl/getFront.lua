-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
return function() --[[ getFront | Line: 4 | Upvalues: UserInputService (copy) ]]
	for v1, v2 in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
		if v2.KeyCode == Enum.KeyCode.ButtonR2 and v2.UserInputState == Enum.UserInputState.Begin then
			return true
		end
	end
	return false
end