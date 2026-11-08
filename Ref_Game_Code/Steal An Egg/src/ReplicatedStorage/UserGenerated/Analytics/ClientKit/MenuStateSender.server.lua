-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local MenuState = script.Parent:WaitForChild("MenuState")

GuiService.MenuOpened:Connect(function() -- line: 24
    -- upvalues: MenuState (copy)
    MenuState:FireServer(true)
end)
GuiService.MenuClosed:Connect(function() -- line: 27
    -- upvalues: MenuState (copy)
    MenuState:FireServer(false)
end)
