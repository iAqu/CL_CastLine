-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local Signal = require(ReplicatedStorage.Packages.Signal)
local StaffEntryHotkey = require(ReplicatedStorage.Client.StaffEntryHotkey)
local F8 = Enum.KeyCode.F8
local KeyboardEnabled, TouchEnabled = UserInputService.KeyboardEnabled, UserInputService.TouchEnabled
local v1 = KeyboardEnabled and not TouchEnabled
local v2 = TouchEnabled and not KeyboardEnabled
local t1 = {
    Changed = Signal.new()
}
local v3 = false
local v4 = false

local function isToggleHonoured() -- line: 23
    -- upvalues: v3 (ref), v1 (copy)
    return v1 and v3
end

local function canShowPanel() -- line: 25
    -- upvalues: Environment (copy), StaffEntryHotkey (copy), v3 (ref), v4 (ref), v2 (copy), v1 (copy)
    if StaffEntryHotkey.IsHidden() then
        return false
    end

    local v5 = v4

    if not v5 then
        v5 = Environment.IsDevPlace()

        if not v5 then
            v5 = Environment.IsTestPlace()

            if not v5 then
                v5 = v2

                if not v2 then
                    v5 = v1 and v3
                end
            end
        end
    end

    return v5
end

local function onInputBegan(p1, p2) -- line: 36
    -- upvalues: Environment (copy), StaffEntryHotkey (copy), F8 (copy), t1 (copy), v3 (ref), v4 (ref), v2 (copy), v1 (copy)
    if not v1 or p2 or p1.KeyCode ~= F8 then
        return
    end

    v3 = not v3

    local Changed = t1.Changed
    local v6

    if StaffEntryHotkey.IsHidden() then
        v6 = false
    else
        v6 = v4

        if not v6 then
            v6 = Environment.IsDevPlace()

            if not v6 then
                v6 = Environment.IsTestPlace()

                if not v6 then
                    v6 = v2

                    if not v2 then
                        v6 = v1 and v3
                    end
                end
            end
        end
    end

    Changed:Fire(v6)
end

function t1.CanShowPanel() -- line: 44
    -- upvalues: Environment (copy), StaffEntryHotkey (copy), v3 (ref), v4 (ref), v2 (copy), v1 (copy)
    if StaffEntryHotkey.IsHidden() then
        return false
    end

    local v7 = v4

    if not v7 then
        v7 = Environment.IsDevPlace()

        if not v7 then
            v7 = Environment.IsTestPlace()

            if not v7 then
                v7 = v2

                if not v2 then
                    v7 = v1 and v3
                end
            end
        end
    end

    return v7
end

function t1.SetAdminStatus(p3) -- line: 46
    -- upvalues: Environment (copy), StaffEntryHotkey (copy), t1 (copy), v3 (ref), v4 (ref), v2 (copy), v1 (copy)
    if v4 == p3 then
        return
    end

    v4 = p3

    local Changed = t1.Changed
    local v8

    if StaffEntryHotkey.IsHidden() then
        v8 = false
    else
        v8 = v4

        if not v8 then
            v8 = Environment.IsDevPlace()

            if not v8 then
                v8 = Environment.IsTestPlace()

                if not v8 then
                    v8 = v2

                    if not v2 then
                        v8 = v1 and v3
                    end
                end
            end
        end
    end

    Changed:Fire(v8)
end

UserInputService.InputBegan:Connect(onInputBegan)
StaffEntryHotkey.Changed:Connect(function() -- line: 55
    -- upvalues: Environment (copy), StaffEntryHotkey (copy), t1 (copy), v3 (ref), v4 (ref), v2 (copy), v1 (copy)
    local Changed = t1.Changed
    local v9

    if StaffEntryHotkey.IsHidden() then
        v9 = false
    else
        v9 = v4

        if not v9 then
            v9 = Environment.IsDevPlace()

            if not v9 then
                v9 = Environment.IsTestPlace()

                if not v9 then
                    v9 = v2

                    if not v2 then
                        v9 = v1 and v3
                    end
                end
            end
        end
    end

    Changed:Fire(v9)
end)

return t1
