-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local FocusState = script.Parent:WaitForChild("FocusState")

UserInputService.WindowFocused:Connect(function() -- line: 24
    -- upvalues: FocusState (copy)
    FocusState:FireServer(true)
end)
UserInputService.WindowFocusReleased:Connect(function() -- line: 27
    -- upvalues: FocusState (copy)
    FocusState:FireServer(false)
end)
