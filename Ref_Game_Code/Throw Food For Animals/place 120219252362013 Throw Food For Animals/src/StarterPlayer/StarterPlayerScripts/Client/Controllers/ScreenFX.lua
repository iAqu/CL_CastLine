-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIScaler = require(script.Parent.UIScaler)
local t1 = {}
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "ScreenFX"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ScreenInsets = Enum.ScreenInsets.None
ScreenGui.ClipToDeviceSafeArea = false
ScreenGui:SetAttribute("UIScaleIgnore", true)
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 200
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Name = "Tint"
Frame.Size = UDim2.fromScale(1, 1)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.ZIndex = 1
Frame.Parent = ScreenGui

local Frame2 = Instance.new("Frame")

Frame2.Name = "Vignette"
Frame2.Size = UDim2.fromScale(1, 1)
Frame2.BackgroundTransparency = 1
Frame2.ClipsDescendants = true
Frame2.ZIndex = 2
Frame2.Parent = ScreenGui

local t2 = {}
local n1 = 0
local v1 = Color3.new(0, 0, 0)
local v2 = v1
local v3
local n2 = 0
local connection

for i = 1, 26 do
    local Frame = Instance.new("Frame")

    Frame.Name = "Ring" .. i
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 2

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v1
    UIStroke.Transparency = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame
    Frame.Parent = Frame2
    t2[i] = {
        Frame = Frame,
        Stroke = UIStroke
    }
end

local function layoutRings() -- line: 92
    -- upvalues: ScreenGui (copy), t2 (copy)
    local AbsoluteSize = ScreenGui.AbsoluteSize
    local v4 = math.max(AbsoluteSize.Y, 100)
    local v5 = math.max(AbsoluteSize.X, 100)
    local v6 = v4 * 1.05
    local v8 = (math.sqrt(v5 * v5 + v4 * v4) * 1.15 - v6) / 26

    for v9, v10 in ipairs(t2) do
        local v11 = v6 + v8 * (v9 - 0.5)

        v10.Frame.Size = UDim2.fromOffset(v11, v11)
        v10.Stroke.Thickness = v8 * 1.9
    end
end

local function ringColor(p1) -- line: 107
    -- upvalues: v2 (ref), v3 (ref), n2 (ref)
    local v12 = v3

    if not v12 then
        return v2
    end

    local v13 = (p1 - 1) / 25

    if not v12.Rainbow then
        return (v12.Inner or v2):Lerp(v12.Outer or v2, v13)
    end

    local Rainbow = v12.Rainbow
    local v14 = #Rainbow
    local v15 = (v13 * v14 * (v12.Bands or 1) + n2) % v14
    local v16 = math.floor(v15) + 1
    local v17 = v16 % v14 + 1

    return Rainbow[v16]:Lerp(Rainbow[v17], v15 - math.floor(v15))
end

local function applyVignette() -- line: 123
    -- upvalues: t2 (copy), n1 (ref), ringColor (copy)
    for v18, v19 in ipairs(t2) do
        local v21 = n1
        local v20 = v21 * (v18 / 26) ^ 1.5

        v19.Stroke.Transparency = 1 - math.clamp(v20 * 0.6, 0, 1)
        v19.Stroke.Color = ringColor(v18)
    end
end

local function stopVignetteAnimation() -- line: 132
    -- upvalues: connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutRings)
layoutRings()

local Frame3 = Instance.new("Frame")

Frame3.Name = "TopBar"
Frame3.Size = UDim2.new(1.2, 0, 0.11, 0)
Frame3.Position = UDim2.new(-0.1, 0, -0.11, 0)
Frame3.BackgroundColor3 = Color3.new(0, 0, 0)
Frame3.BorderSizePixel = 0
Frame3.ZIndex = 3
Frame3.Parent = ScreenGui

local clone = Frame3:Clone()

clone.Name = "BottomBar"
clone.AnchorPoint = Vector2.new(0, 1)
clone.Position = UDim2.new(-0.1, 0, 1.11, 0)
clone.Parent = ScreenGui

local Frame4 = Instance.new("Frame")

Frame4.Name = "Fade"
Frame4.Size = UDim2.fromScale(1, 1)
Frame4.BackgroundColor3 = Color3.new(0, 0, 0)
Frame4.BackgroundTransparency = 1
Frame4.BorderSizePixel = 0
Frame4.ZIndex = 10
Frame4.Parent = ScreenGui

local v23

local function tweenFade(p2, p3, p4) -- line: 170
    -- upvalues: TweenService (copy), Frame4 (copy), v23 (ref)
    if v23 then
        v23:Cancel()
    end

    v23 = TweenService:Create(Frame4, TweenInfo.new(p3, p4 or Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        BackgroundTransparency = 1 - p2
    })
    v23:Play()

    return v23
end

function t1.FadeOut(p5, p6) -- line: 179
    -- upvalues: Frame4 (copy), tweenFade (copy)
    Frame4.BackgroundColor3 = p5 or Color3.new(0, 0, 0)
    tweenFade(1, p6 or 0.3).Completed:Wait()
end

function t1.FadeIn(p7) -- line: 185
    -- upvalues: tweenFade (copy)
    tweenFade(0, p7 or 0.35).Completed:Wait()
end

function t1.Cover(p8) -- line: 191
    -- upvalues: Frame4 (copy), v23 (ref)
    if v23 then
        v23:Cancel()
    end

    Frame4.BackgroundColor3 = p8 or Color3.new(0, 0, 0)
    Frame4.BackgroundTransparency = 0
end

function t1.Flash(p9, p10, p11) -- line: 197
    -- upvalues: TweenService (copy), ScreenGui (copy)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = p9 or Color3.new(1, 1, 1)
    Frame.BackgroundTransparency = 1 - (p10 or 0.8)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 9
    Frame.Parent = ScreenGui

    local tween = TweenService:Create(Frame, TweenInfo.new(p11 or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })

    tween:Play()
    tween.Completed:Once(function() -- line: 207
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

function t1.SetTint(p12, p13, p14) -- line: 210
    -- upvalues: TweenService (copy), Frame (copy)
    Frame.BackgroundColor3 = p12 or Color3.new(0, 0, 0)
    TweenService:Create(Frame, TweenInfo.new(p14 or 0.3), {
        BackgroundTransparency = 1 - (p13 or 0)
    }):Play()
end

function t1.SetVignetteStyle(p15) -- line: 217
    -- upvalues: RunService (copy), v3 (ref), n2 (ref), connection (ref), applyVignette (copy)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    v3 = p15
    n2 = 0

    if p15 and p15.Rainbow then
        local v25 = p15.Speed or 1

        connection = RunService.RenderStepped:Connect(function(p16) -- line: 223
            -- upvalues: p15 (copy), v25 (copy), n2 (ref), applyVignette (copy)
            n2 = (n2 + p16 * v25) % #p15.Rainbow
            applyVignette()
        end)
    end

    applyVignette()
end

local v27

function t1.SetVignette(p17, p18, p19) -- line: 232
    -- upvalues: TweenService (copy), t1 (copy), n1 (ref), v2 (ref), v3 (ref), applyVignette (copy), v27 (ref)
    if p19 then
        v2 = p19

        if v3 then
            t1.SetVignetteStyle(nil)
        end
    end

    if v27 then
        v27:Cancel()
    end

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Value = n1
    v27 = TweenService:Create(NumberValue, TweenInfo.new(p18 or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Value = p17
    })

    local connection = NumberValue.Changed:Connect(function(p20) -- line: 241
        -- upvalues: n1 (ref), applyVignette (copy)
        n1 = p20
        applyVignette()
    end)

    v27:Play()
    v27.Completed:Once(function() -- line: 246
        -- upvalues: NumberValue (copy), connection (copy)
        connection:Disconnect()
        NumberValue:Destroy()
    end)
end

function t1.PulseVignette(p21, p22, p23) -- line: 252
    -- upvalues: t1 (copy), n1 (ref)
    local v28 = n1

    t1.SetVignette(p21, (p22 or 0.4) * 0.25, p23)
    task.delay((p22 or 0.4) * 0.25, function() -- line: 255
        -- upvalues: p22 (copy), p23 (copy), v28 (copy), t1 (copy)
        t1.SetVignette(v28, (p22 or 0.4) * 0.75, p23)
    end)
end

function t1.ShowBars(p24) -- line: 260
    -- upvalues: TweenService (copy), Frame3 (copy), clone (copy)
    local v29 = TweenInfo.new(p24 or 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    TweenService:Create(Frame3, v29, {
        Position = UDim2.new(-0.1, 0, 0, 0)
    }):Play()
    TweenService:Create(clone, v29, {
        Position = UDim2.new(-0.1, 0, 1, 0)
    }):Play()
end

function t1.HideBars(p25) -- line: 266
    -- upvalues: TweenService (copy), Frame3 (copy), clone (copy)
    local v30 = TweenInfo.new(p25 or 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

    TweenService:Create(Frame3, v30, {
        Position = UDim2.new(-0.1, 0, -0.11, 0)
    }):Play()
    TweenService:Create(clone, v30, {
        Position = UDim2.new(-0.1, 0, 1.11, 0)
    }):Play()
end

function t1.Ring(p26, p27, p28) -- line: 273
    -- upvalues: TweenService (copy), UIScaler (copy), ScreenGui (copy)
    local Frame = Instance.new("Frame")

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(p28 or 40, p28 or 40)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 8

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p26 or Color3.new(1, 1, 1)
    UIStroke.Thickness = 10 * UIScaler.Factor()
    UIStroke.Transparency = 0.1
    UIStroke.Parent = Frame
    Frame.Parent = ScreenGui

    local v31 = math.max(ScreenGui.AbsoluteSize.X, ScreenGui.AbsoluteSize.Y) * 1.6
    local v32 = TweenInfo.new(p27 or 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    TweenService:Create(Frame, v32, {
        Size = UDim2.fromOffset(v31, v31)
    }):Play()
    TweenService:Create(UIStroke, v32, {
        Transparency = 1,
        Thickness = 2 * UIScaler.Factor()
    }):Play()
    task.delay(p27 or 0.6, function() -- line: 293
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

function t1.Reset() -- line: 297
    -- upvalues: t1 (copy), Frame (copy), n1 (ref), Frame3 (copy), clone (copy), Frame4 (copy), v23 (ref)
    if v23 then
        v23:Cancel()
    end

    Frame4.BackgroundTransparency = 1
    Frame.BackgroundTransparency = 1
    n1 = 0
    t1.SetVignetteStyle(nil)
    Frame3.Position = UDim2.new(-0.1, 0, -0.11, 0)
    clone.Position = UDim2.new(-0.1, 0, 1.11, 0)
end

function t1.GetGui() -- line: 307
    -- upvalues: ScreenGui (copy)
    return ScreenGui
end

return t1
