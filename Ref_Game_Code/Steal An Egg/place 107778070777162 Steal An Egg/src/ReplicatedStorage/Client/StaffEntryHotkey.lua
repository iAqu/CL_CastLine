-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Signal = require(ReplicatedStorage.Packages.Signal)
local RightBracket = Enum.KeyCode.RightBracket
local t1 = {
    Changed = Signal.new()
}
local v1 = false

local function onInputBegan(p1, p2) -- line: 15
    -- upvalues: UserInputService (copy), RightBracket (copy), t1 (copy), v1 (ref)
    if p2 or UserInputService:GetFocusedTextBox() or p1.KeyCode ~= RightBracket then
        return
    end

    v1 = not v1
    t1.Changed:Fire(v1)
end

function t1.IsHidden() -- line: 26
    -- upvalues: v1 (ref)
    return v1
end

UserInputService.InputBegan:Connect(onInputBegan)

return t1
