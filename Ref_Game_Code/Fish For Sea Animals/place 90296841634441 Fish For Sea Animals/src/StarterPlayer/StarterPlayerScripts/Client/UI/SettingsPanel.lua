-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameSettings = require(ReplicatedStorage.Shared.GameSettings)
local UIUtil = require(script.Parent.UIUtil)
local Settings = require(script.Parent.Settings)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = #GameSettings.List * 104 + 170 - 12 + 10
local v2 = Color3.fromRGB(120, 128, 145)
local ScreenGui

local function row(p1, p2, p3) -- line: 25
    -- upvalues: UIUtil (copy), Settings (copy), Kit (copy), Style (copy), v2 (copy)
    local v3 = Style.card(p1, Style.OCEAN, {
        Name = p3.Key,
        Position = UDim2.fromOffset(0, (p2 - 1) * 104),
        Size = UDim2.new(1, 0, 0, 92)
    })

    Style.text(v3, p3.Name, {
        Name = "Title",
        ZIndex = 2,
        StrokeThickness = 4,
        Position = UDim2.fromOffset(22, 10),
        Size = UDim2.new(1, -230, 0, 40),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Style.text(v3, p3.Detail, {
        Name = "Detail",
        ZIndex = 2,
        Position = UDim2.fromOffset(22, 52),
        Size = UDim2.new(1, -230, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(200, 210, 230)
    })

    local v4 = Kit.button(v3, "", Style.BUY, {
        Name = "Switch",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(170, 62)
    }, function() -- line: 54
        -- upvalues: p3 (copy), UIUtil (copy), Settings (copy)
        Settings.set(p3.Key, not Settings.get(p3.Key))
        UIUtil.sound("Click", 0.6)
    end)

    v4.Label.ZIndex = 4
    Settings.onChanged(p3.Key, function(p4) -- line: 59
        -- upvalues: v4 (copy), UIUtil (copy), Style (copy), v2 (copy)
        v4.BackgroundColor3 = if p4 then Style.BUY else v2
        v4.Label.Text = p4 and "ON" or "OFF"
        UIUtil.pop(v4, 1.08)
    end)
end

local function build() -- line: 66
    -- upvalues: GameSettings (copy), Kit (copy), Style (copy), LocalPlayer (copy), t1 (copy), v1 (copy), ScreenGui (ref), row (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SettingsPanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 6
    ScreenGui.Enabled = false

    local v6 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(780, v1),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })

    Kit.corner(v6, 24)
    Kit.stroke(v6, 6)
    Style.gradient(v6, ColorSequence.new(Style.NAVY, Style.DEEP))
    Kit.studs(v6, 0.75, 44, 24)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v6

    local v7 = Kit.frame(v6, {
        Name = "Header",
        ZIndex = 2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 118)
    })

    Kit.corner(v7, 22)
    Kit.stroke(v7, 5)
    Style.gradient(v7, ColorSequence.new(Style.TEAL, Style.OCEAN), 0)
    Kit.studs(v7, 0.5, 48, 22)
    Style.bubble(v7, "⚙️", {
        ZIndex = 3,
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.fromOffset(98, 98)
    })

    local v8 = Kit.text(v7, "SETTINGS", {
        ZIndex = 3,
        StrokeThickness = 6,
        Position = UDim2.fromOffset(126, 24),
        Size = UDim2.fromOffset(460, 70),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Style.gradient(v8, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))
    Kit.button(v7, "X", Color3.fromRGB(235, 70, 70), {
        Name = "Close",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(86, 86)
    }, function() -- line: 114
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end).Label.ZIndex = 4

    local v9 = Kit.frame(v6, {
        Name = "Body",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(26, 150),
        Size = UDim2.new(1, -52, 1, -170)
    })

    for v10, v11 in GameSettings.List do
        row(v9, v10, v11)
    end

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

function t1.isOpen() -- line: 131
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.open() -- line: 135
    -- upvalues: UIUtil (copy), t1 (copy), ScreenGui (ref)
    if not t1.isOpen() then
        UIUtil.openPanel(ScreenGui)
    end
end

function t1.close() -- line: 141
    -- upvalues: UIUtil (copy), ScreenGui (ref)
    UIUtil.closePanel(ScreenGui)
end

function t1.init() -- line: 145
    -- upvalues: build (copy)
    build()
end

return t1
