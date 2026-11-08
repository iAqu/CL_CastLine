-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Log = require(ReplicatedStorage.Packages.Log)
local Signal = require(ReplicatedStorage.Packages.Signal)
local t1 = {
    [Enum.PreferredInput.Gamepad] = "Console",
    [Enum.PreferredInput.KeyboardAndMouse] = "Desktop",
    [Enum.PreferredInput.Touch] = "Mobile"
}
local t2 = {
    Changed = Signal.new()
}
local v1 = Log.new()

local function detect() -- line: 33
    -- upvalues: UserInputService (copy), t1 (copy)
    return t1[UserInputService.PreferredInput] or "Desktop"
end

local v2 = t1[UserInputService.PreferredInput] or "Desktop"

function t2.Platform() -- line: 39
    -- upvalues: v2 (ref)
    return v2
end

function t2.IsConsole() -- line: 43
    -- upvalues: v2 (ref)
    return v2 == "Console"
end

function t2.IsDesktop() -- line: 47
    -- upvalues: v2 (ref)
    return v2 == "Desktop"
end

function t2.IsMobile() -- line: 51
    -- upvalues: v2 (ref)
    return v2 == "Mobile"
end

function t2.Observe(p1) -- line: 57
    -- upvalues: t2 (copy), v2 (ref)
    local connection = t2.Changed:Connect(p1)

    p1(v2)

    return function() -- line: 60
        -- upvalues: connection (copy)
        connection:Disconnect()
    end
end

local function announce(p2) -- line: 65
    -- upvalues: v1 (copy)
    v1:AtInfo():Log((("client now presents as %*"):format(p2)))
end

local function reconcile() -- line: 69
    -- upvalues: UserInputService (copy), t1 (copy), t2 (copy), v1 (copy), v2 (ref)
    local v3 = t1[UserInputService.PreferredInput] or "Desktop"

    if v3 == v2 then
        return
    end

    v2 = v3
    t2.Changed:Fire(v3)
    v1:AtInfo():Log((("client now presents as %*"):format(v3)))
end

UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(reconcile)

local v4 = v2

v1:AtInfo():Log((("client now presents as %*"):format(v4)))

return table.freeze(t2)
