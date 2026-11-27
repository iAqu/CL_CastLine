-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Settings = require(script.Parent.Settings)
local UIUtil = require(script.Parent.UIUtil)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Color3.fromRGB(20, 20, 30)
local v2 = Color3.fromRGB(255, 214, 60)
local v3 = Color3.fromRGB(255, 248, 190)
local v4 = Color3.fromRGB(255, 150, 40)
local v5 = Color3.new(1, 1, 1)
local ScreenGui
local t2 = nil
local FieldOfView
local n1 = 0
local v6 = Random.new()

local function easeOutBack(p1, p2) -- line: 45
    p2 = p2 or 1.7

    local v8 = p1 - 1

    return 1 + (p2 + 1) * v8 * v8 * v8 + p2 * v8 * v8
end

local function zoomAt(p3) -- line: 53
    if p3 < 0.07 then
        local v9 = p3 / 0.07

        return v9 * 4 * v9
    end

    if p3 < 0.3 then
        return (1 - (1 - math.min((p3 - 0.07) / 0.1, 1)) ^ 3) * -20 + 4
    end

    if p3 < 0.95 then
        local v11 = (p3 - 0.3) / 0.6499999999999999

        return math.exp(v11 * -6) * -16 * math.cos(v11 * 3.141592653589793 * 1.6)
    end

    return 0
end

local function cameraPunch() -- line: 71
    -- upvalues: RunService (copy), Settings (copy), FieldOfView (ref), v6 (copy), zoomAt (copy)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera.CameraType ~= Enum.CameraType.Custom or not Settings.get("Shake") then
        return
    end

    if FieldOfView then
        RunService:UnbindFromRenderStep("LevelUpPunch")
    else
        FieldOfView = CurrentCamera.FieldOfView
    end

    local FieldOfView2 = FieldOfView
    local elapsed = os.clock()

    RunService:BindToRenderStep("LevelUpPunch", Enum.RenderPriority.Camera.Value + 1, function() -- line: 84
        -- upvalues: CurrentCamera (copy), FieldOfView2 (copy), elapsed (copy), RunService (copy), FieldOfView (ref), v6 (copy), zoomAt (copy)
        local v16 = os.clock() - elapsed
        local v17, v18

        if v16 >= 0.95 then
            v18 = true
        elseif CurrentCamera.CameraType == Enum.CameraType.Custom then
            CurrentCamera.FieldOfView = FieldOfView2 + zoomAt(v16)
            v17 = if v16 > 0.07 then math.max(0, 1 - (v16 - 0.07) / 0.35) * 0.012 else 0
            v18 = false
        else
            v18 = true
        end

        if not v18 then
            if v17 > 0 then
                CurrentCamera.CFrame *= CFrame.Angles(v6:NextNumber(-1, 1) * v17, v6:NextNumber(-1, 1) * v17, v6:NextNumber(-1, 1) * v17 * 0.5)
            end
        else
            CurrentCamera.FieldOfView = FieldOfView2
            FieldOfView = nil
            RunService:UnbindFromRenderStep("LevelUpPunch")
        end
    end)
end

local function jingle() -- line: 101
    -- upvalues: UIUtil (copy)
    UIUtil.sound("LevelUp", 0.8)
end

local function flash() -- line: 105
    -- upvalues: UIUtil (copy), v3 (copy), ScreenGui (ref)
    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = v3
    Frame.BackgroundTransparency = 0.45
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 1
    Frame.Parent = ScreenGui
    UIUtil.tween(Frame, 0.35, {
        BackgroundTransparency = 1
    }, Enum.EasingStyle.Quad)
    task.delay(0.4, function() -- line: 114
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

local function starBurst(p4, p5, p6, p7) -- line: 121
    -- upvalues: RunService (copy), Config (copy), v2 (copy), v4 (copy), v5 (copy), v6 (copy)
    for i = 1, p6 do
        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        TextLabel.Position = UDim2.fromOffset(p5.X, p5.Y)

        local v20 = v6:NextNumber(26, 46)

        TextLabel.Size = UDim2.fromOffset(v20, v20)
        TextLabel.Text = "★"
        TextLabel.TextScaled = true
        TextLabel.FontFace = Config.Font

        if i % 3 == 0 then
            TextLabel.TextColor3 = v5
        else
            TextLabel.TextColor3 = v2
        end

        TextLabel.ZIndex = 6

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 2
        UIStroke.Color = v4
        UIStroke.Parent = TextLabel
        TextLabel.Parent = p4

        local v21 = i / p6 * 3.141592653589793 * 2 + v6:NextNumber(-0.25, 0.25)
        local v22 = p7 * v6:NextNumber(0.7, 1.15)
        local v23 = v6:NextNumber(-540, 540)
        local v24 = v6:NextNumber(0.55, 0.8)
        local elapsed = os.clock()
        local connection = nil

        connection = RunService.RenderStepped:Connect(function() -- line: 145
            -- upvalues: p5 (copy), TextLabel (copy), v20 (copy), v21 (copy), v22 (copy), v23 (copy), v24 (copy), elapsed (copy), connection (ref)
            local v25 = os.clock() - elapsed
            local v26 = v25 / v24

            if v26 >= 1 then
                connection:Disconnect()
                TextLabel:Destroy()
            else
                local v28 = 1 - (1 - math.min(v26 * 1.6, 1)) ^ 3
                local v29 = p5.X + math.cos(v21) * v22 * v28
                local v30 = p5.Y + math.sin(v21) * v22 * v28 + 260 * v25 * v25

                TextLabel.Position = UDim2.fromOffset(v29, v30)
                TextLabel.Rotation = v23 * v25

                local v31 = if v26 < 0.15 then v26 / 0.15 else 1 - (v26 - 0.15) / 0.85

                TextLabel.Size = UDim2.fromOffset(v20 * v31, v20 * v31)
            end
        end)
    end
end

local function worldBurst() -- line: 165
    -- upvalues: UIUtil (copy), LocalPlayer (copy), v2 (copy), v3 (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local Part = Instance.new("Part")

    Part.Name = "LevelUpFx"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(2, 2, 2)
    Part.CFrame = HumanoidRootPart.CFrame
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v3, v2)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new(0, 0.2)
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 0.9)
    ParticleEmitter.Speed = NumberRange.new(14, 24)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 4
    ParticleEmitter.Acceleration = Vector3.new(0, 6, 0)
    ParticleEmitter.RotSpeed = NumberRange.new(-200, 200)
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(45)

    local v32 = HumanoidRootPart.Position - Vector3.new(0, 2.8, 0)
    local Part2 = Instance.new("Part")

    Part2.Name = "LevelUpRing"
    Part2.Shape = Enum.PartType.Cylinder
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v2
    Part2.Transparency = 0.15
    Part2.Size = Vector3.new(0.2, 2, 2)
    Part2.CFrame = CFrame.new(v32) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2.Parent = workspace
    UIUtil.tween(Part2, 0.5, {
        Size = Vector3.new(0.2, 22, 22),
        Transparency = 1
    }, Enum.EasingStyle.Quad)
    task.delay(1.2, function() -- line: 213
        -- upvalues: Part (copy), Part2 (copy)
        Part:Destroy()
        Part2:Destroy()
    end)
end

local function makeLabel(p8, p9, p10) -- line: 219
    -- upvalues: Config (copy), v1 (copy), v5 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.FontFace = Config.Font
    TextLabel.TextScaled = true
    TextLabel.Text = p9
    TextLabel.TextColor3 = v5
    TextLabel.Size = UDim2.fromOffset(p10 * 7, p10)
    TextLabel.ZIndex = 8

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = math.max(3, p10 / 14)
    UIStroke.Color = v1
    UIStroke.Parent = TextLabel
    TextLabel.Parent = p8

    return TextLabel
end

local function subtitle(p11, p12, p13) -- line: 238
    -- upvalues: Format (copy), t1 (copy)
    return ("%*Level %*"):format(if p12 > 1 then ("+%* LEVELS · "):format((Format.short(p12))) else "", (t1.levelText(p11))) .. (if p13 > 0 then (" · +%* 💪"):format((Format.short(p13))) else "")
end

local function banner(p14, p15, p16) -- line: 246
    -- upvalues: RunService (copy), UIUtil (copy), v2 (copy), v3 (copy), v4 (copy), ScreenGui (ref), makeLabel (copy), subtitle (copy)
    local v34 = UIUtil.scale or 1
    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.3)
    Frame.Size = UDim2.fromOffset(0, 0)
    Frame.Parent = ScreenGui

    local v35 = makeLabel(Frame, "LEVEL UP!", 120 * v34)
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v3),
        ColorSequenceKeypoint.new(0.55, v2),
        ColorSequenceKeypoint.new(1, v4)
    })
    UIGradient.Rotation = 90
    UIGradient.Parent = v35

    local v36 = makeLabel(Frame, subtitle(p14, p15, p16), 48 * v34)

    v36.Position = UDim2.fromOffset(0, 92 * v34)
    v36.Visible = false

    local Offset = v35.Size.X.Offset
    local Offset2 = v35.Size.Y.Offset
    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 267
        -- upvalues: v34 (copy), Frame (copy), v35 (copy), v36 (copy), Offset (copy), Offset2 (copy), elapsed (copy), connection (ref), UIUtil (copy)
        local v37 = os.clock() - elapsed
        local v38, v39, v40

        if v37 < 0.07 then
            v38 = 0
            v39 = 0
            v40 = 0
        elseif v37 < 0.17 then
            local v41 = (v37 - 0.07) / 0.1

            v38 = 0.6 * v41
            v39 = 1.35 * v41
            v40 = 0
        elseif v37 < 0.26 then
            local v42 = (v37 - 0.17) / 0.09

            v38 = 0.6 + 0.65 * v42
            v39 = 1.35 + -0.5700000000000001 * v42
            v40 = 0
        elseif v37 < 0.5 then
            local v43 = (v37 - 0.26) / 0.24 - 1
            local v44 = 1 + 3.2 * v43 * v43 * v43 + 2.2 * v43 * v43

            v38 = v44 * -0.25 + 1.25
            v39 = v44 * 0.21999999999999997 + 0.78
            v40 = 0
        elseif v37 < 1.4500000000000002 then
            local v46 = math.sin((v37 - 0.5) * 6) * 0.025

            v38 = 1 - v46
            v39 = v46 + 1
            v40 = 0
        elseif v37 < 1.6 then
            local v47 = (v37 - 1.4500000000000002) / 0.15

            v38 = 1 + 0.15 * v47
            v39 = 1 - 0.2 * v47
            v40 = 0
        else
            local v48 = (v37 - 1.6) / 0.22

            if v48 >= 1 then
                connection:Disconnect()
                Frame:Destroy()

                return
            end

            v38 = 1.15 - 0.55 * v48
            v39 = 0.8 + 0.7 * v48
            v40 = -160 * v34 * v48 * v48
            v35.TextTransparency = v48
            v36.TextTransparency = v48

            local UIStroke = v35.UIStroke
            local UIStroke2 = v36.UIStroke

            UIStroke.Transparency = v48
            UIStroke2.Transparency = v48
        end

        v35.Size = UDim2.fromOffset(Offset * v38, Offset2 * v39)
        v35.Position = UDim2.fromOffset(0, v40)
        v35.Rotation = if v37 < 0.5 then math.sin(v37 * 40) * 6 * math.max(0, 1 - v37 / 0.5) else 0

        if v37 >= 0.2 and not v36.Visible then
            v36.Visible = true
            UIUtil.pop(v36, 0.4)
        end

        v36.Position = UDim2.fromOffset(0, 92 * v34 + v40)
    end)

    return function() -- line: 309
        -- upvalues: Frame (copy), connection (ref)
        connection:Disconnect()
        Frame:Destroy()
    end
end

function t1.levelText(p17) -- line: 315
    -- upvalues: Format (copy)
    if p17 < 1E+06 then
        return (tostring(p17))
    end

    return (Format.short(p17))
end

function t1.play(p18, p19, p20, p21) -- line: 320
    -- upvalues: UIUtil (copy), ScreenGui (ref), t2 (ref), n1 (ref), cameraPunch (copy), flash (copy), starBurst (copy), worldBurst (copy), banner (copy)
    local elapsed = os.clock()
    local v53 = p21 or 0
    local v54 = p19

    if t2 then
        v54 = p19 + t2.gained
        v53 += t2.strength
        t2.remove()
    end

    local v55 = elapsed - n1 < 0.12

    n1 = elapsed

    local v56 = banner(p18, v54, v53)
    local t3

    t3 = {
        gained = v54,
        strength = v53,
        remove = function() -- remove | line: 337
            -- upvalues: v56 (copy), t3 (ref), t2 (ref)
            v56()

            if t2 == t3 then
                t2 = nil
            end
        end
    }
    t2 = t3
    task.delay(1.9000000000000001, function() -- line: 345
        -- upvalues: t3 (ref), t2 (ref)
        if t2 == t3 then
            t2 = nil
        end
    end)

    if v55 then
        return
    end

    UIUtil.sound("LevelUp", 0.8)
    cameraPunch()
    task.delay(0.07, function() -- line: 355
        -- upvalues: p20 (copy), UIUtil (copy), ScreenGui (ref), flash (copy), starBurst (copy), worldBurst (copy)
        flash()

        local v57 = UIUtil.scale or 1
        local ViewportSize = workspace.CurrentCamera.ViewportSize

        starBurst(ScreenGui, Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.3), 14, 260 * v57)

        local v58 = p20 and p20:FindFirstAncestorWhichIsA("ScreenGui")

        if p20 and v58 and p20.Visible and p20.Parent and p20.Parent.Visible then
            starBurst(v58, p20.AbsolutePosition + p20.AbsoluteSize / 2 - v58.AbsolutePosition, 8, 140 * v57)
        end

        worldBurst()
    end)
end

function t1.init() -- line: 370
    -- upvalues: LocalPlayer (copy), ScreenGui (ref)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LevelUpFx"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 40
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

return t1
