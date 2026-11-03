-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
return function() --[[ GetThumbstick | Line: 4 | Upvalues: UserInputService (copy) ]]
	local v2 = 0
	local v3 = 0
	for i, v in ipairs((UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1))) do
		if v.KeyCode == Enum.KeyCode.Thumbstick1 then
			v2 = v.Position.X
			v3 = v.Position.Y
			if math.abs(v2) < 0.1 then
				v2 = 0
			end
			if math.abs(v3) < 0.1 then
				return v2, 0
			end
			break
		end
	end
	return v2, v3
end