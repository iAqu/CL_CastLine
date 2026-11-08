-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local v1 = Color3.fromRGB(255, 120, 40)
local v2 = Color3.fromRGB(255, 50, 50)
local t1 = {}

local function tween(p1, p2, p3, p4) -- line: 49
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p2, p4 or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p3)

    tween:Play()

    return tween
end

local function cloneGui(p5) -- line: 66
    -- upvalues: Players (copy), StarterGui (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local v3 = PlayerGui:FindFirstChild(p5)

    if v3 ~= nil and v3:IsA("ScreenGui") then
        return v3
    end

    local v4 = StarterGui:FindFirstChild(p5)

    if v4 == nil or not v4:IsA("ScreenGui") then
        warn((("[TrexRun] StarterGui.%* is missing"):format(p5)))

        return nil
    end

    local clone = v4:Clone()

    clone.Parent = PlayerGui

    return clone
end

local function pop(p6) -- line: 88
    -- upvalues: GuiService (copy), TweenService (copy)
    local UIScale = p6:FindFirstChildOfClass("UIScale")

    if UIScale == nil or GuiService.ReducedMotionEnabled then
        return
    end

    UIScale.Scale = 1.25

    local t2 = {
        Scale = 1
    }
    local Back = Enum.EasingStyle.Back

    TweenService:Create(UIScale, TweenInfo.new(0.35, Back or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t2):Play()
end

function t1.Mount() -- line: 101
    -- upvalues: cloneGui (copy)
    local TrexRunUI = cloneGui("TrexRunUI")
    local TrexRunOverlay = cloneGui("TrexRunOverlay")
    local TrexRunCinematic = cloneGui("TrexRunCinematic")

    if TrexRunUI == nil or TrexRunOverlay == nil or TrexRunCinematic == nil then
        return nil
    end

    local Objective = TrexRunUI:FindFirstChild("Objective")
    local BarHolder = Objective:FindFirstChild("BarHolder")
    local Bar = BarHolder:FindFirstChild("BarBG"):FindFirstChild("Bar")
    local t3 = {
        BarAlpha = -1,
        BarText = "",
        TitleText = "",
        Shown = false,
        Danger = 0,
        FlashUntil = 0,
        Clock = 0,
        Gui = TrexRunUI,
        Overlay = TrexRunOverlay,
        Cinematic = TrexRunCinematic,
        Card = Objective,
        Title = Objective:FindFirstChild("Title"),
        Bar = Bar,
        BarLabel = BarHolder:FindFirstChild("TextLabel"),
        BarHeight = Bar.Size.Y.Scale,
        Vignette = TrexRunOverlay:FindFirstChild("Vignette"),
        Top = TrexRunCinematic:FindFirstChild("Top"),
        Bottom = TrexRunCinematic:FindFirstChild("Bottom"),
        ShownPosition = Objective.Position
    }

    Objective.Position = UDim2.fromScale(Objective.Position.X.Scale, -0.2)
    t3.Vignette.ImageTransparency = 1
    t3.Top.Position = UDim2.fromScale(0, -0.11)
    t3.Bottom.Position = UDim2.fromScale(0, 1)
    TrexRunUI.Enabled = true
    TrexRunOverlay.Enabled = true
    TrexRunCinematic.Enabled = true

    return t3
end

function t1.SetBoardShown(p7, p8) -- line: 147
    -- upvalues: TweenService (copy)
    if p7.Shown == p8 then
        return
    end

    p7.Shown = p8

    local Card = p7.Card
    local v6 = if p8 then 0.45 else 0.25
    local t4 = {}
    local v7

    if p8 then
        t4.Position = p7.ShownPosition
        v7 = Enum.EasingStyle.Back
    else
        t4.Position = UDim2.fromScale(p7.ShownPosition.X.Scale, -0.2)
        v7 = Enum.EasingStyle.Quad
    end

    TweenService:Create(Card, TweenInfo.new(v6, v7 or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t4):Play()
end

function t1.SetObjective(p9, p10) -- line: 161
    -- upvalues: pop (copy)
    if p9.TitleText == p10 then
        return
    end

    p9.TitleText = p10
    p9.Title.Text = p10
    pop(p9.Title)
end

function t1.SetProgress(p11, p12, p13) -- line: 171
    local v8 = math.clamp(p12, 0, 1)

    if math.abs(v8 - p11.BarAlpha) > 0.001 then
        p11.BarAlpha = v8
        p11.Bar.Size = UDim2.fromScale(v8, p11.BarHeight)
    end

    if p13 ~= p11.BarText then
        p11.BarText = p13
        p11.BarLabel.Text = p13
    end
end

function t1.Letterbox(p14, p15) -- line: 185
    -- upvalues: TweenService (copy)
    local Top = p14.Top
    local t5 = {
        Position = if p15 then UDim2.fromScale(0, 0) else UDim2.fromScale(0, -0.11)
    }

    TweenService:Create(Top, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t5):Play()

    local Bottom = p14.Bottom
    local t6 = {
        Position = if p15 then UDim2.fromScale(0, 0.89) else UDim2.fromScale(0, 1)
    }

    TweenService:Create(Bottom, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t6):Play()
end

function t1.Flash(p16) -- line: 196
    p16.FlashUntil = os.clock() + 0.6
end

function t1.SetDanger(p17, p18) -- line: 200
    p17.Danger = p18
end

function t1.Update(p19, p20) -- line: 204
    -- upvalues: GuiService (copy), v1 (copy), v2 (copy)
    p19.Clock += p20

    local v11 = math.clamp((p19.FlashUntil - os.clock()) / 0.6, 0, 1)

    if v11 > 0 then
        p19.Vignette.ImageColor3 = v2
        p19.Vignette.ImageTransparency = 1 - v11 * 0.9
    elseif p19.Danger <= 0 then
        if p19.Vignette.ImageTransparency ~= 1 then
            p19.Vignette.ImageTransparency = 1
        end
    else
        local v12 = if GuiService.ReducedMotionEnabled then 0.5 else (math.sin(p19.Clock * 3.141592653589793 * 2 * (p19.Danger * 2 + 1.5)) + 1) * 0.5

        p19.Vignette.ImageColor3 = v1
        p19.Vignette.ImageTransparency = 1 - p19.Danger * (v12 * 0.35 + 0.45)
    end
end

function t1.Unmount(p21) -- line: 231
    -- upvalues: TweenService (copy), t1 (copy)
    t1.SetBoardShown(p21, false)

    local Vignette = p21.Vignette
    local t7 = {
        ImageTransparency = 1
    }

    TweenService:Create(Vignette, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), t7):Play()
    t1.Letterbox(p21, false)
    task.delay(0.6, function() -- line: 236
        -- upvalues: p21 (copy)
        p21.Gui:Destroy()
        p21.Overlay:Destroy()
        p21.Cinematic:Destroy()
    end)
end

return table.freeze(t1)
