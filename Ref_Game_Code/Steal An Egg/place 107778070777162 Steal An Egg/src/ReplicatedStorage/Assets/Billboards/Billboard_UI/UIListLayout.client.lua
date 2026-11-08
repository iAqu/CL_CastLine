-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GamepadService = game:GetService("GamepadService")
local UserInputService = game:GetService("UserInputService")

if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled or UserInputService.MouseEnabled then
    return
end

local Parent = script.Parent

local function updateGamepad() -- line: 16
    -- upvalues: GamepadService (copy), Parent (copy)
    if #Parent:GetChildren() == 2 then
        GamepadService:DisableGamepadCursor()
    else
        GamepadService:EnableGamepadCursor((Parent:FindFirstChildWhichIsA("Frame")))
    end
end

Parent.ChildAdded:Connect(function() -- line: 26
    -- upvalues: GamepadService (copy), Parent (copy)
    if #Parent:GetChildren() == 2 then
        GamepadService:DisableGamepadCursor()
    else
        GamepadService:EnableGamepadCursor((Parent:FindFirstChildWhichIsA("Frame")))
    end
end)
Parent.ChildRemoved:Connect(function() -- line: 28
    -- upvalues: GamepadService (copy), Parent (copy)
    if #Parent:GetChildren() == 2 then
        GamepadService:DisableGamepadCursor()
    else
        GamepadService:EnableGamepadCursor((Parent:FindFirstChildWhichIsA("Frame")))
    end
end)
