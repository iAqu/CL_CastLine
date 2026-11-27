-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(60, 72, 100)
local ScreenGui, v2, v3, v4
local t2 = {}
local t3 = {}
local n1 = 1
local v5 = false

local function usingGamepad() -- line: 34
    -- upvalues: UserInputService (copy)
    return UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
end

local function answered() -- line: 38
    -- upvalues: Config (copy), LocalPlayer (copy)
    return LocalPlayer:GetAttribute("SurveyDone") == Config.Survey.Id
end

local function send() -- line: 42
    -- upvalues: Config (copy), Remotes (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), v4 (ref), t2 (copy), t3 (copy), n1 (ref), v5 (ref)
    v5 = true
    v4.Text = "Sending..."

    for _, v6 in t2 do
        v6.Visible = false
    end

    local InvokeServer = Remotes.SendSurvey.InvokeServer
    local SendSurvey = Remotes.SendSurvey
    local v7, v8, v9 = pcall(InvokeServer, SendSurvey, t3)

    v5 = false

    if v7 and v8 then
        UIUtil.toast(v9 or "", "success")
        t1.close()

        return
    end

    local toast = UIUtil.toast

    if not v7 or not v9 then
        v9 = "Couldn't send it, try again in a moment!"
    end

    toast(v9, "error")

    if LocalPlayer:GetAttribute("SurveyDone") == Config.Survey.Id then
        t1.close()
    else
        n1 = 1
        t1.show()
    end
end

function t1.show() -- line: 65
    -- upvalues: GuiService (copy), UserInputService (copy), Config (copy), Kit (copy), t1 (copy), v1 (copy), v2 (ref), v3 (ref), v4 (ref), t2 (copy), t3 (copy), n1 (ref), v5 (ref), send (copy)
    local Questions = Config.Survey.Questions
    local v10 = Questions[n1]

    v3.Text = ("Question %* of %*"):format(n1, #Questions)
    v4.Text = v10.Text

    for _, v13 in t2 do
        v13:Destroy()
    end

    table.clear(t2)

    for v14, v15 in v10.Answers do
        local button = Kit.button
        local v16 = v2

        table.insert(t2, (button(v16, v15, v1, {
            Name = "Answer" .. v14,
            Position = UDim2.fromOffset(26, 290 + (v14 - 1) * 90),
            Size = UDim2.new(1, -52, 0, 76)
        }, function() -- line: 79
            -- upvalues: Questions (copy), v14 (copy), t1 (copy), t3 (copy), n1 (ref), v5 (ref), send (copy)
            local v18 = v5

            if not v18 then
                v18 = n1 > #Questions
            end

            if v18 then
                return
            end

            t3[n1] = v14
            n1 += 1

            if n1 > #Questions then
                task.spawn(send)
            else
                t1.show()
            end
        end)))
    end

    if UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil and t2[1] then
        GuiService.SelectedObject = t2[1]
    end
end

local function build() -- line: 98
    -- upvalues: Config (copy), Kit (copy), Style (copy), LocalPlayer (copy), t1 (copy), ScreenGui (ref), v2 (ref), v3 (ref), v4 (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Survey"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 6
    ScreenGui.Enabled = false
    v2 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(820, 710),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })
    Kit.corner(v2, 24)
    Kit.stroke(v2, 6)
    Style.gradient(v2, ColorSequence.new(Style.NAVY, Style.DEEP))
    Kit.studs(v2, 0.75, 44, 24)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v2

    local v21 = Kit.frame(v2, {
        Name = "Header",
        ZIndex = 2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 118)
    })

    Kit.corner(v21, 22)
    Kit.stroke(v21, 5)
    Style.gradient(v21, ColorSequence.new(Style.ABYSS, Style.OCEAN), 0)
    Kit.studs(v21, 0.5, 48, 22)
    Style.bubble(v21, "📋", {
        ZIndex = 3,
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.fromOffset(98, 98)
    })

    local v22 = Kit.text(v21, "SURVEY", {
        ZIndex = 3,
        StrokeThickness = 6,
        Position = UDim2.fromOffset(126, 10),
        Size = UDim2.fromOffset(500, 62),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Style.gradient(v22, ColorSequence.new(Color3.new(1, 1, 1), Style.YELLOW))
    Style.text(v21, "Help us pick what's next!", {
        ZIndex = 3,
        Position = UDim2.fromOffset(128, 72),
        Size = UDim2.fromOffset(440, 34),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Kit.button(v21, "X", Color3.fromRGB(235, 70, 70), {
        Name = "Close",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(86, 86)
    }, function() -- line: 152
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end).Label.ZIndex = 4
    v3 = Kit.text(v2, "", {
        Name = "Progress",
        Position = UDim2.fromOffset(26, 136),
        Size = UDim2.new(1, -52, 0, 36),
        TextColor3 = Style.SAND
    })
    v4 = Kit.text(v2, "", {
        Name = "Question",
        StrokeThickness = 5,
        Position = UDim2.fromOffset(26, 180),
        Size = UDim2.new(1, -52, 0, 90)
    })

    local Survey = Config.Survey

    Style.text(v2, ("🎁 Finish it for <font color=\"#FFE25A\">2x %*</font> (%* min)!"):format(Survey.RewardStat, Survey.RewardSeconds // 60), {
        Name = "Reward",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -16),
        Size = UDim2.new(1, -52, 0, 34)
    })

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

function t1.isOpen() -- line: 179
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.open() -- line: 183
    -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy), t1 (copy), ScreenGui (ref), t3 (copy), n1 (ref)
    if t1.isOpen() then
        return
    end

    if LocalPlayer:GetAttribute("SurveyDone") == Config.Survey.Id then
        UIUtil.toast("You've already answered this one, thanks!", "info")
    else
        n1 = 1
        table.clear(t3)
        t1.show()
        UIUtil.openPanel(ScreenGui)
    end
end

function t1.close() -- line: 197
    -- upvalues: GuiService (copy), UIUtil (copy), ScreenGui (ref)
    local SelectedObject = GuiService.SelectedObject

    if SelectedObject and SelectedObject:IsDescendantOf(ScreenGui) then
        GuiService.SelectedObject = nil
    end

    UIUtil.closePanel(ScreenGui)
end

function t1.init() -- line: 205
    -- upvalues: build (copy)
    build()
end

return t1
