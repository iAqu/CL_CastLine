-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local FocusState = script.Parent:WaitForChild("FocusState")
UserInputService.WindowFocused:Connect(function() --[[ Line: 24 | Upvalues: FocusState (copy) ]]
	FocusState:FireServer(true)
end)
UserInputService.WindowFocusReleased:Connect(function() --[[ Line: 27 | Upvalues: FocusState (copy) ]]
	FocusState:FireServer(false)
end)