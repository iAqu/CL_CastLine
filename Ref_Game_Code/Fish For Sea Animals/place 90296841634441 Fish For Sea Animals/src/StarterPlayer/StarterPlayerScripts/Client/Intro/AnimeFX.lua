-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local RarityText = require(script.Parent.Parent.UI.RarityText)
local Actors = require(script.Parent.Actors)
local Director = require(script.Parent.Director)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(18, 18, 26)
local COMIC = Actors.COMIC
local t2 = {
    Brightness = 0.02,
    Contrast = 0.14,
    Saturation = 0.18,
    TintColor = Color3.fromRGB(255, 244, 230)
}
local ScreenGui, v3, v4, v5, ColorCorrectionEffect
local t3 = {}
local v6 = false
local t4 = {}
local t1 = {}

function t1.init() -- line: 37
    -- upvalues: Lighting (copy), RunService (copy), Kit (copy), LocalPlayer (copy), v1 (copy), t2 (copy), ScreenGui (ref), v3 (ref), v4 (ref), v5 (ref), ColorCorrectionEffect (ref), t3 (copy), v6 (ref), t4 (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "IntroFX"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 950
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v5 = Kit.frame(ScreenGui, {
        Name = "FocusLines",
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 2,
        Size = UDim2.fromScale(1, 1)
    })

    for i = 1, 64 do
        local v7 = Kit.frame(v5, {
            Name = "Line" .. i,
            BackgroundColor3 = v1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.5)
        })
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(0.8, 0.2),
            NumberSequenceKeypoint.new(1, 0)
        })
        UIGradient.Parent = v7
    end

    for _, v8 in { 0, 1 } do
        t3[v8] = Kit.frame(ScreenGui, {
            ZIndex = 5,
            BackgroundColor3 = Color3.new(0, 0, 0),
            AnchorPoint = Vector2.new(0, v8),
            Position = UDim2.fromScale(0, v8),
            Size = UDim2.fromScale(1, 0)
        })
    end

    v4 = Kit.frame(ScreenGui, {
        Name = "Flash",
        BackgroundTransparency = 1,
        ZIndex = 8,
        BackgroundColor3 = v1,
        Size = UDim2.fromScale(1, 1)
    })
    v3 = Kit.frame(ScreenGui, {
        Name = "Cover",
        ZIndex = 10,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.fromScale(1, 1)
    })
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Name = "IntroGrade"

    for v9, v10 in t2 do
        ColorCorrectionEffect[v9] = v10
    end

    ColorCorrectionEffect.Parent = Lighting

    local n1 = 0

    table.insert(t4, RunService.RenderStepped:Connect(function(p1) -- line: 72
        -- upvalues: n1 (ref), v5 (ref), v6 (ref)
        if not v6 then
            return
        end

        n1 += p1

        if not (n1 < 0.08333333333333333) then
            n1 = 0

            local v12 = workspace.CurrentCamera.ViewportSize.Magnitude * 0.62

            for _, child in v5:GetChildren() do
                child.Rotation = math.random() * 360
                child.Size = UDim2.fromOffset(math.random(1, 3) * math.random(1, 4), v12 * (0.85 + math.random() * 0.3))
            end
        end
    end))
end

function t1.cover(p2, p3) -- line: 91
    -- upvalues: UIUtil (copy), v3 (ref)
    UIUtil.tween(v3, p3 or 0.5, {
        BackgroundTransparency = p2 and 0 or 1
    }, Enum.EasingStyle.Sine)
    task.wait(p3 or 0.5)
    v3.BackgroundTransparency = p2 and 0 or 1
end

function t1.black() -- line: 98
    -- upvalues: v3 (ref)
    v3.BackgroundTransparency = 0
end

function t1.letterbox(p4) -- line: 102
    -- upvalues: UIUtil (copy), t3 (copy)
    for _, v16 in t3 do
        UIUtil.tween(v16, 0.6, {
            Size = UDim2.fromScale(1, p4 and 0.12 or 0)
        }, Enum.EasingStyle.Quint)
    end
end

function t1.flash(p5, p6) -- line: 108
    -- upvalues: UIUtil (copy), v1 (copy), v4 (ref)
    v4.BackgroundColor3 = p5 or v1
    v4.BackgroundTransparency = 0
    UIUtil.tween(v4, p6 or 0.35, {
        BackgroundTransparency = 1
    })
end

function t1.speedLines(p7, p8) -- line: 114
    -- upvalues: v1 (copy), v5 (ref), v6 (ref)
    v6 = p7
    v5.Visible = p7

    for _, child in v5:GetChildren() do
        child.BackgroundColor3 = p8 or v1
    end
end

function t1.grade(p9, p10) -- line: 123
    -- upvalues: UIUtil (copy), t2 (copy), ColorCorrectionEffect (ref)
    UIUtil.tween(ColorCorrectionEffect, p10 or 0.3, p9 or t2, Enum.EasingStyle.Sine)
end

function t1.impact(p11, p12, p13) -- line: 129
    -- upvalues: Lighting (copy), UIUtil (copy), Director (copy), v1 (copy), v4 (ref)
    p12 = p12 or 0.12
    Director.hitstop(p12)

    if not p13 then
        UIUtil.sound("AnimeImpact", 1)
    end

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Saturation = -1
    ColorCorrectionEffect.Contrast = 3
    ColorCorrectionEffect.Brightness = 0.25

    if p11 == "red" then
        ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 40, 40)
    end

    ColorCorrectionEffect.Parent = Lighting
    v4.BackgroundColor3 = v1
    v4.BackgroundTransparency = 0
    task.delay(0.03333333333333333, function() -- line: 143
        -- upvalues: ColorCorrectionEffect (copy), v4 (ref)
        v4.BackgroundTransparency = 1
        ColorCorrectionEffect.Brightness = -0.2
        ColorCorrectionEffect.Contrast = 4
    end)
    task.delay(p12, function() -- line: 147
        -- upvalues: ColorCorrectionEffect (copy)
        ColorCorrectionEffect:Destroy()
    end)
end

local function slam(p14, p15, p16) -- line: 152
    -- upvalues: UIUtil (copy)
    local UIScale = Instance.new("UIScale")

    UIScale.Scale = p15
    UIScale.Parent = p14
    UIUtil.tween(UIScale, p16, {
        Scale = 1
    }, Enum.EasingStyle.Back)

    return UIScale
end

local function gradient(p17, p18, p19) -- line: 160
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(p18, p19)
    UIGradient.Parent = p17
end

function t1.sfx(p20, p21) -- line: 181
    -- upvalues: RunService (copy), Kit (copy), UIUtil (copy), v1 (copy), v2 (copy), COMIC (copy), ScreenGui (ref), slam (copy)
    p21 = p21 or {}

    local v20 = p21.x or 0.5
    local v21 = p21.y or 0.3

    if p21.world then
        local CurrentCamera = workspace.CurrentCamera
        local v22 = CurrentCamera:WorldToViewportPoint(p21.world)

        v20 = v22.X / CurrentCamera.ViewportSize.X
        v21 = v22.Y / CurrentCamera.ViewportSize.Y
    end

    local v23 = p21.color or Color3.fromRGB(255, 230, 80)
    local v24 = Kit.text(ScreenGui, p20, {
        StrokeThickness = 7,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(v20, v21),
        Size = UDim2.fromScale(0.9, p21.size or 0.16),
        TextColor3 = v1,
        FontFace = COMIC,
        Rotation = p21.rotation or math.random(-8, 8)
    })

    v24.UIStroke.Color = v2
    v24.UIStroke.LineJoinMode = Enum.LineJoinMode.Miter

    local v25 = p21.color2 or v23:Lerp(Color3.fromRGB(255, 120, 30), 0.6)
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(v23, v25)
    UIGradient.Parent = v24
    slam(v24, 2.6, 0.2)

    local Position = v24.Position
    local elapsed = os.clock()
    local v26 = p21.shake or 7
    local connection = RunService.RenderStepped:Connect(function() -- line: 207
        -- upvalues: v24 (copy), Position (copy), elapsed (copy), v26 (copy)
        local v28 = math.max(0, 1 - (os.clock() - elapsed) * 3) * v26 + 1

        v24.Position = Position + UDim2.fromOffset(math.random(-1, 1) * v28, math.random(-1, 1) * v28)
    end)

    task.delay(p21.time or 1.2, function() -- line: 211
        -- upvalues: v24 (copy), connection (copy), UIUtil (copy)
        connection:Disconnect()

        local UIScale = v24:FindFirstChildOfClass("UIScale")

        if UIScale then
            UIUtil.tween(UIScale, 0.15, {
                Scale = 1.3
            })
        end

        UIUtil.tween(v24, 0.15, {
            TextTransparency = 1
        })
        UIUtil.tween(v24.UIStroke, 0.15, {
            Transparency = 1
        })
        task.wait(0.15)
        v24:Destroy()
    end)

    return v24
end

function t1.counter(p22) -- line: 226
    -- upvalues: Kit (copy), v2 (copy), COMIC (copy), ScreenGui (ref)
    local v29 = Kit.text(ScreenGui, "", {
        StrokeThickness = 6,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, p22),
        Size = UDim2.fromScale(0.6, 0.13),
        FontFace = COMIC
    })

    v29.UIStroke.Color = v2

    return v29
end

function t1.deadpan(p23, p24) -- line: 233
    -- upvalues: Kit (copy), UIUtil (copy), ScreenGui (ref)
    local v30 = Kit.text(ScreenGui, p23, {
        StrokeThickness = 3,
        ZIndex = 6,
        TextTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.86),
        Size = UDim2.fromScale(0.7, 0.055),
        TextColor3 = Color3.fromRGB(235, 235, 240)
    })

    v30.UIStroke.Transparency = 1
    UIUtil.tween(v30, 0.25, {
        TextTransparency = 0
    })
    UIUtil.tween(v30.UIStroke, 0.25, {
        Transparency = 0
    })
    task.delay(p24, function() -- line: 238
        -- upvalues: v30 (copy), UIUtil (copy)
        UIUtil.tween(v30, 0.25, {
            TextTransparency = 1
        })
        UIUtil.tween(v30.UIStroke, 0.25, {
            Transparency = 1
        })
        task.wait(0.25)
        v30:Destroy()
    end)
end

function t1.logo() -- line: 247
    -- upvalues: Kit (copy), UIUtil (copy), v1 (copy), ScreenGui (ref)
    local v31 = Kit.frame(ScreenGui, {
        BackgroundTransparency = 1,
        ZIndex = 11,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.47),
        Size = UDim2.fromScale(0.6, 0.16)
    })
    local v32 = Kit.text(v31, "RUSTY STUDIO", {
        StrokeThickness = 0,
        ZIndex = 11,
        TextTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        TextColor3 = Color3.fromRGB(235, 140, 80)
    })

    v32.UIStroke.Enabled = false

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 140, 80)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 140, 80)),
        ColorSequenceKeypoint.new(0.5, v1),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(235, 140, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 140, 80))
    })
    UIGradient.Offset = Vector2.new(-1, 0)
    UIGradient.Parent = v32

    local v33 = Kit.text(ScreenGui, "presents", {
        StrokeThickness = 0,
        ZIndex = 11,
        TextTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.57),
        Size = UDim2.fromScale(0.3, 0.05),
        TextColor3 = Color3.fromRGB(200, 200, 210)
    })

    v33.UIStroke.Enabled = false

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 1.15
    UIScale.Parent = v31
    UIUtil.sound("Whoosh", 0.6, 0.8)
    UIUtil.tween(v32, 0.8, {
        TextTransparency = 0
    }, Enum.EasingStyle.Sine)
    UIUtil.tween(UIScale, 2.4, {
        Scale = 1
    }, Enum.EasingStyle.Quint)
    task.wait(0.5)
    UIUtil.sound("Reveal", 0.5, 1.2)
    UIUtil.tween(UIGradient, 0.9, {
        Offset = Vector2.new(1, 0)
    }, Enum.EasingStyle.Sine)
    task.wait(0.4)
    UIUtil.tween(v33, 0.5, {
        TextTransparency = 0
    })
    task.wait(0.8)
    UIUtil.tween(v32, 0.4, {
        TextTransparency = 1
    })
    UIUtil.tween(v33, 0.4, {
        TextTransparency = 1
    })
    task.wait(0.5)
    v31:Destroy()
    v33:Destroy()
end

function t1.skipButton(p25) -- line: 285
    -- upvalues: UserInputService (copy), Kit (copy), UIUtil (copy), ScreenGui (ref)
    local v34 = Kit.button(ScreenGui, "SKIP ⏩", Color3.fromRGB(40, 44, 60), {
        Name = "Skip",
        ZIndex = 20,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -24, 1, -24),
        Size = UDim2.fromScale(0.13, 0.075)
    }, p25)
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 2.6
    UIAspectRatioConstraint.Parent = v34

    local UISizeConstraint = Instance.new("UISizeConstraint")

    UISizeConstraint.MinSize = Vector2.new(110, 42)
    UISizeConstraint.MaxSize = Vector2.new(190, 73)
    UISizeConstraint.Parent = v34

    for _, descendant in v34:GetDescendants() do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex = 21
        end
    end

    local Label = v34:FindFirstChild("Label")

    local function relabel(p26) -- line: 306
        -- upvalues: Label (copy)
        Label.Text = p26.Name:find("^Gamepad") and "SKIP (X)" or "SKIP ⏩"
    end

    Label.Text = UserInputService:GetLastInputType().Name:find("^Gamepad") and "SKIP (X)" or "SKIP ⏩"

    local t8 = {
        UserInputService.LastInputTypeChanged:Connect(relabel),
        UserInputService.InputBegan:Connect(function(p27) -- line: 312
            -- upvalues: p25 (copy), UIUtil (copy)
            if p27.KeyCode == Enum.KeyCode.ButtonX then
                UIUtil.sound("Click", 0.5)
                p25()
            end
        end)
    }

    v34.Destroying:Connect(function() -- line: 319
        -- upvalues: t8 (copy)
        for _, v35 in t8 do
            v35:Disconnect()
        end
    end)

    return v34
end

function t1.banner(p28, p29, p30, p31) -- line: 328
    -- upvalues: Config (copy), Kit (copy), RarityText (copy), ScreenGui (ref), slam (copy)
    local v36 = Config.RarityByName[p28]
    local v37 = Kit.frame(ScreenGui, {
        BackgroundTransparency = 1,
        ZIndex = 6,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, p31 or 0.13),
        Size = UDim2.fromScale(0.7, 0.2)
    })
    local v38 = Kit.text(v37, string.upper(p28), {
        StrokeThickness = 6,
        ZIndex = 6,
        Size = UDim2.fromScale(1, 0.38)
    })

    if v36 then
        RarityText.apply(v38, v36)
    else
        v38.TextColor3 = Color3.fromRGB(150, 150, 150)
    end

    Kit.text(v37, p29, {
        StrokeThickness = 5,
        ZIndex = 6,
        Position = UDim2.fromScale(0, 0.4),
        Size = UDim2.fromScale(1, 0.34)
    })
    Kit.text(v37, p30, {
        StrokeThickness = 4,
        ZIndex = 6,
        Position = UDim2.fromScale(0, 0.76),
        Size = UDim2.fromScale(1, 0.22),
        TextColor3 = Color3.fromRGB(255, 226, 90)
    })
    slam(v37, 1.8, 0.3)

    return v37
end

function t1.cleanup() -- line: 343
    -- upvalues: ScreenGui (ref), ColorCorrectionEffect (ref), v6 (ref), t4 (copy)
    for _, v39 in t4 do
        v39:Disconnect()
    end

    table.clear(t4)
    v6 = false

    if ColorCorrectionEffect then
        ColorCorrectionEffect:Destroy()
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end
end

return t1
