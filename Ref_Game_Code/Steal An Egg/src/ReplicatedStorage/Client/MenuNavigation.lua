-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Signal = require(ReplicatedStorage.Packages.Signal)
local t1 = {
    Changed = Signal.new(),
    CursorChanged = Signal.new(),
    SaveFailed = Signal.new(),
    CursorFailed = Signal.new(),
    SwitchKey = Enum.KeyCode.ButtonR3
}
local v1 = Preferences.IsOn("VirtualCursor")
local v2 = false
local v3 = false
local n1 = 0
local v4, v5
local t2 = {}
local n2 = 0
local v6 = true
local t3 = {}

function t1.IsSuspended() -- line: 41
    -- upvalues: GuiService (copy), UserInputService (copy), PlatformController (copy), v6 (ref), t3 (copy)
    return not PlatformController.IsConsole()
        or not UserInputService.GamepadEnabled
        or UserInputService.VREnabled
        or GuiService.MenuIsOpen
        or not v6
        or next(t3) ~= nil
end

function t1.PrefersCursor() -- line: 50
    -- upvalues: v1 (ref)
    return v1
end

function t1.IsCursorActive() -- line: 53
    -- upvalues: v4 (ref)
    return v4 ~= nil
end

function t1.Release() -- line: 57
    -- upvalues: GamepadService (copy), t1 (copy), v4 (ref)
    if v4 == nil then
        return
    end

    v4 = nil

    local function v7() -- line: 62
        -- upvalues: GamepadService (copy)
        GamepadService:DisableGamepadCursor()
    end

    local ok, result = pcall(v7)

    if not ok then
        warn((("Could not release menu cursor: %*"):format(result)))
    end

    t1.CursorChanged:Fire(false)
end

function t1.SetContext(p1, p2) -- line: 71
    -- upvalues: GamepadService (copy), t1 (copy), v1 (ref), v4 (ref), v5 (ref)
    if p1 ~= nil and v1 and not t1.IsSuspended() then
        if p1 == v4 then
            return true
        end

        if p1 ~= v5 then
            t1.Release()

            local function v8() -- line: 85
                -- upvalues: p2 (copy), GamepadService (copy)
                GamepadService:EnableGamepadCursor(p2)
            end

            local ok, result = pcall(v8)

            if ok then
                v5 = nil
                v4 = p1
                t1.CursorChanged:Fire(true)

                return true
            end

            v5 = p1
            t1.CursorFailed:Fire()
            warn((("Could not enable menu cursor: %*"):format(result)))
        end

        return false
    end

    t1.Release()
    v5 = nil

    return false
end

function t1.SetPreference(p3) -- line: 102
    -- upvalues: Preferences (copy), t1 (copy), v1 (ref), v2 (ref), v3 (ref), n1 (ref), v5 (ref)
    if v1 == p3 and not v2 and not v3 then
        return
    end

    v1 = p3
    v3 = true
    n1 += 1
    v5 = nil

    if not p3 then
        t1.Release()
    end

    t1.Changed:Fire()

    if not v2 then
        v2 = true
        task.spawn(function() -- line: 118
            -- upvalues: Preferences (copy), t1 (copy), v1 (ref), v2 (ref), v3 (ref), n1 (ref)
            local v9

            repeat
                local v10 = n1
                local v11 = v1

                v9 = Preferences.Set("VirtualCursor", v11)
            until v10 == n1

            v2 = false
            v3 = not v9

            if not v9 then
                t1.SaveFailed:Fire()
            end
        end)
    end
end

function t1.Toggle() -- line: 134
    -- upvalues: t1 (copy), v1 (ref)
    t1.SetPreference(not v1)
end

function t1.Suspend(p4, p5) -- line: 138
    -- upvalues: t1 (copy), t3 (copy)
    if t3[p4] == true == p5 then
        return
    end

    t3[p4] = if p5 then true else nil

    if p5 then
        t1.Release()
    end

    t1.Changed:Fire()
end

function t1.SetOverride(p6, p7, p8, p9, p10, p11, p12) -- line: 149
    -- upvalues: t1 (copy), t2 (copy), n2 (ref)
    if p7 ~= nil then
        n2 += 1
        t2[p6] = {
            Root = p7,
            Initial = p8,
            Back = p9,
            Priority = p10 or 0,
            Modal = p11 == true,
            BackInButtons = p12 == true,
            Order = n2
        }
    else
        t2[p6] = nil
    end

    t1.Changed:Fire()
end

local function visible(p13) -- line: 175
    local LayerCollector = p13:FindFirstAncestorWhichIsA("LayerCollector")

    if LayerCollector ~= nil and LayerCollector.Enabled then
        local v13 = p13

        while not v13:IsA("GuiObject") or v13.Visible do
            v13 = v13.Parent

            if v13 == LayerCollector then
                return true
            end
        end
    end

    return false
end

function t1.TopOverride() -- line: 190
    -- upvalues: t2 (copy), visible (copy)
    local v14

    for _, v15 in t2 do
        if v15.Root.Parent and visible(v15.Root) and (v14 == nil or v15.Priority > v14.Priority or v15.Priority == v14.Priority and v15.Order > v14.Order) then
            v14 = v15
        end
    end

    return v14
end

Preferences.Observe("VirtualCursor", function(p14) -- line: 209
    -- upvalues: t1 (copy), v1 (ref), v2 (ref), v3 (ref), v5 (ref)
    if p14 == v1 or v2 or v3 then
        return
    end

    v1 = p14
    v5 = nil
    t1.Changed:Fire()
end)

local function refresh() -- line: 218
    -- upvalues: t1 (copy)
    if t1.IsSuspended() then
        t1.Release()
    end

    t1.Changed:Fire()
end

PlatformController.Changed:Connect(refresh)
GuiService.MenuOpened:Connect(refresh)
GuiService.MenuClosed:Connect(refresh)
UserInputService.GamepadConnected:Connect(refresh)
UserInputService.GamepadDisconnected:Connect(refresh)
UserInputService.WindowFocusReleased:Connect(function() -- line: 229
    -- upvalues: t1 (copy), v6 (ref)
    v6 = false

    if t1.IsSuspended() then
        t1.Release()
    end

    t1.Changed:Fire()
end)
UserInputService.WindowFocused:Connect(function() -- line: 233
    -- upvalues: t1 (copy), v6 (ref)
    v6 = true

    if t1.IsSuspended() then
        t1.Release()
    end

    t1.Changed:Fire()
end)

local function v16() -- line: 240
    -- upvalues: GamepadService (copy), t1 (copy), v4 (ref)
    GamepadService:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(function() -- line: 242
        -- upvalues: GamepadService (copy), t1 (copy), v4 (ref)
        local function v17() -- line: 243
            -- upvalues: GamepadService (copy)
            return GamepadService.GamepadCursorEnabled
        end

        local ok, result = pcall(v17)

        if not ok or result or v4 == nil then
            return
        end

        v4 = nil
        t1.CursorChanged:Fire(false)
        t1.Changed:Fire()
    end)
end

pcall(v16)

return t1
