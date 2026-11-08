-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}

t1.__index = t1

local function visible(p1) -- line: 14
    local ScreenGui = p1:FindFirstAncestorWhichIsA("ScreenGui")

    if ScreenGui ~= nil and ScreenGui.Enabled then
        local v1 = p1

        while not v1:IsA("GuiObject") or v1.Visible do
            v1 = v1.Parent

            if v1 == ScreenGui then
                return true
            end
        end
    end

    return false
end

local function pointerPosition() -- line: 29
    -- upvalues: GuiService (copy), UserInputService (copy)
    local GuiInset = GuiService:GetGuiInset()

    return UserInputService:GetMouseLocation() - GuiInset
end

local function inside(p2, p3) -- line: 34
    local AbsolutePosition = p2.AbsolutePosition
    local v2 = AbsolutePosition + p2.AbsoluteSize

    if p3.X >= AbsolutePosition.X and p3.Y >= AbsolutePosition.Y and p3.X <= v2.X then
        return p3.Y <= v2.Y
    end

    return false
end

function t1.new(p4) -- line: 43
    -- upvalues: GuiService (copy), UserInputService (copy), Trove (copy), t1 (copy)
    local v3 = Trove.new()
    local v4 = setmetatable({
        Entries = {},
        Trove = v3,
        PressTrove = v3:Extend()
    }, t1)

    v3:Connect(UserInputService.InputBegan, function(p5) -- line: 51
        -- upvalues: v4 (copy), GuiService (copy)
        if p5.KeyCode ~= Enum.KeyCode.ButtonL2 then
            return
        end

        local SelectedObject = GuiService.SelectedObject
        local v5 = v4.Entries[SelectedObject]
        local v6 = v5 and v5.GetTool()

        if v4:_canFavorite(SelectedObject, v5, v6) then
            v4:Cancel()
            v5.OnFavorite(v6)
        end
    end)
    v3:Connect(UserInputService.InputEnded, function(p6) -- line: 65
        -- upvalues: v4 (copy)
        local Press = v4.Press

        if Press and p6.UserInputType == Enum.UserInputType.MouseButton2 then
            local v7 = p6.UserInputState ~= Enum.UserInputState.Cancel and v4:_valid(Press)

            v4:Cancel()

            if v7 then
                Press.Entry.OnFavorite(Press.Tool)
            end
        end
    end)
    v3:Connect(UserInputService.WindowFocusReleased, function() -- line: 80
        -- upvalues: v4 (copy)
        v4:Cancel()
    end)
    v3:Connect(GuiService.MenuOpened, function() -- line: 83
        -- upvalues: v4 (copy)
        v4:Cancel()
    end)

    if p4 then
        v3:Connect(p4.Destroying, function() -- line: 87
            -- upvalues: v4 (copy)
            v4:Destroy()
        end)
    end

    return v4
end

function t1._canFavorite(p7, p8, p9, p10) -- line: 94
    -- upvalues: visible (copy)
    local v8

    if p9 ~= nil then
        if p7.Entries[p8] == p9 then
            v8 = visible(p8)

            if v8 then
                v8 = p9.GetTool() == p10 and p9.CanFavorite(p10)
            end
        else
            v8 = false
        end
    else
        v8 = false
    end

    return v8
end

function t1._valid(p11, p12) -- line: 102
    -- upvalues: GuiService (copy), UserInputService (copy)
    if not p11:_canFavorite(p12.Button, p12.Entry, p12.Tool) then
        return false
    end

    local GuiInset = GuiService:GetGuiInset()
    local v9 = UserInputService:GetMouseLocation() - GuiInset
    local Button = p12.Button
    local AbsolutePosition = Button.AbsolutePosition
    local v10 = AbsolutePosition + Button.AbsoluteSize

    return v9.X >= AbsolutePosition.X and v9.Y >= AbsolutePosition.Y and v9.X <= v10.X and v9.Y <= v10.Y and (v9 - p12.Position).Magnitude <= 8
end

function t1._begin(p13, p14, p15) -- line: 111
    -- upvalues: GuiService (copy), RunService (copy), UserInputService (copy)
    p13:Cancel()

    local v11 = p13.Entries[p14]

    if not v11 then
        return
    end

    local t3 = {
        Button = p14,
        Entry = v11,
        Tool = v11.GetTool()
    }
    local GuiInset = GuiService:GetGuiInset()

    t3.Position = UserInputService:GetMouseLocation() - GuiInset

    if p13:_valid(t3) then
        p13.Press = t3
        p13.PressTrove:Connect(RunService.Heartbeat, function() -- line: 127
            -- upvalues: p13 (copy), p15 (copy), t3 (copy)
            if p15.UserInputState == Enum.UserInputState.Cancel or not p13:_valid(t3) then
                p13:Cancel()
            end
        end)
    end
end

function t1.Register(p16, p17, p18) -- line: 137
    p16:Unregister(p17)

    local v12 = table.clone(p18)

    v12.Trove = p16.Trove:Extend()
    p16.Entries[p17] = v12
    v12.Trove:Connect(p17.InputBegan, function(p19) -- line: 142
        -- upvalues: p16 (copy), p17 (copy)
        if p19.UserInputType == Enum.UserInputType.MouseButton2 then
            p16:_begin(p17, p19)
        end
    end)
    v12.Trove:Connect(p17.Destroying, function() -- line: 147
        -- upvalues: p16 (copy), p17 (copy)
        p16:Unregister(p17)
    end)
end

function t1.Unregister(p20, p21) -- line: 152
    local v13 = p20.Entries[p21]

    if not v13 then
        return
    end

    if p20.Press and p20.Press.Button == p21 then
        p20:Cancel()
    end

    p20.Entries[p21] = nil
    p20.Trove:Remove(v13.Trove)
end

function t1.Cancel(p22) -- line: 164
    p22.Press = nil
    p22.PressTrove:Clean()
end

function t1.Destroy(p23) -- line: 169
    p23:Cancel()
    p23.Trove:Destroy()
    table.clear(p23.Entries)
end

return t1
