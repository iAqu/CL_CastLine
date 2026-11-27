-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Effects)
local Skip = require(script.Parent.Skip)
local LuckPreludes = require(script.Parent.LuckPreludes)
local t1 = {
    FIRST = 7
}
local v1 = Color3.new(1, 1, 1)
local v2 = Random.new()
local t2 = {}

local function hush(p1) -- line: 38
    -- upvalues: SoundService (copy), UIUtil (copy)
    local t3 = {}

    for _, descendant in SoundService:GetDescendants() do
        if descendant:IsA("Sound") and descendant.IsPlaying and descendant.Volume > 0 then
            t3[descendant] = descendant.Volume
            UIUtil.tween(descendant, p1, {
                Volume = descendant.Volume * 0.08
            })
        end
    end

    return function() -- line: 46
        -- upvalues: t3 (copy), UIUtil (copy)
        for v3, v4 in t3 do
            if v3.Parent then
                UIUtil.tween(v3, 0.6, {
                    Volume = v4
                })
            end
        end
    end
end

local function crack(p2) -- line: 56
    -- upvalues: UIUtil (copy), v1 (copy), v2 (copy)
    local t4 = {}

    for i = 1, 11 do
        local v5 = i / 11 * 360 + v2:NextNumber(-12, 12)
        local v6 = Vector2.zero

        for j = 1, 3 do
            local v7 = v2:NextNumber(0.09, 0.2)
            local v9 = math.rad(v5 + v2:NextNumber(-25, 25))
            local v10 = v6 + Vector2.new(math.cos(v9), (math.sin(v9))) * v7
            local v11 = (v6 + v10) / 2
            local Frame = Instance.new("Frame")

            Frame.Name = "Crack"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v1
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
            Frame:SetAttribute("Mid", v11)
            Frame.Size = UDim2.new(0, 0, 0, 3 - j * 0.6)
            Frame:SetAttribute("Length", (v10 - v6).Magnitude)

            local v12 = v10.Y - v6.Y
            local v13 = v10.X - v6.X

            v6 = v10
            Frame.Rotation = math.deg((math.atan2(v12, v13)))
            Frame.ZIndex = 9

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = Color3.fromRGB(20, 15, 35)
            UIStroke.Thickness = 1.5
            UIStroke.Parent = Frame
            Frame.Parent = p2
            table.insert(t4, Frame)
        end
    end

    local Y = p2.AbsoluteSize.Y

    for _, v15 in t4 do
        local Mid = v15:GetAttribute("Mid")

        v15.Position = UDim2.new(0.5, Mid.X * Y, 0.5, Mid.Y * Y)
        UIUtil.tween(v15, 0.12, {
            Size = UDim2.fromOffset(v15:GetAttribute("Length") * Y, v15.Size.Y.Offset)
        })
    end

    return t4
end

function t1.shatter(p3, p4, p5) -- line: 97
    -- upvalues: UIUtil (copy), v1 (copy), v2 (copy)
    for _, v16 in p4 or {} do
        v16:Destroy()
    end

    for _ = 1, 22 do
        local Frame = Instance.new("Frame")

        Frame.Name = "Shard"
        Frame.BorderSizePixel = 0

        if v2:NextNumber() < 0.5 then
            Frame.BackgroundColor3 = v1
        else
            Frame.BackgroundColor3 = p5
        end

        Frame.BackgroundTransparency = 0.15
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)

        local v17 = v2:NextNumber(0.05, 0.14)

        Frame.Size = UDim2.fromScale(v17, v17 * v2:NextNumber(0.4, 1.6))
        Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY

        local v18 = v2:NextNumber(0.1, 0.9)
        local v19 = v2:NextNumber(0.1, 0.9)

        Frame.Position = UDim2.fromScale(v18, v19)
        Frame.Rotation = v2:NextNumber(0, 360)
        Frame.ZIndex = 9

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(20, 15, 35)
        UIStroke.Thickness = 2
        UIStroke.Parent = Frame
        Frame.Parent = p3

        local v20 = Vector2.new(v18 - 0.5, v19 - 0.5).Unit * v2:NextNumber(0.4, 0.8)
        local v21 = v2:NextNumber(0.6, 1)

        UIUtil.tween(Frame, v21, {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(v18 + v20.X, v19 + v20.Y + 0.5),
            Rotation = Frame.Rotation + v2:NextNumber(-300, 300)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        UIUtil.tween(UIStroke, v21, {
            Transparency = 1
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(v21 + 0.05, Frame.Destroy, Frame)
    end
end

function t1.prelude(p6, p7, p8, p9, p10, p11, p12) -- line: 130
    -- upvalues: Lighting (copy), RunService (copy), Config (copy), UIUtil (copy), Effects (copy), Skip (copy), LuckPreludes (copy), t1 (copy), v1 (copy), t2 (copy), hush (copy), crack (copy)
    if p6 < t1.FIRST then
        return nil
    end

    local CurrentCamera = workspace.CurrentCamera
    local CastPace = Config.CastPace
    local v22 = Config.LuckStages[p6]
    local v23 = (2.6 + 0.3 * (p6 - t1.FIRST)) * CastPace

    Skip.start(p7, t2[p6] == true)

    local v24 = hush(0.5)
    local t5 = {
        p7.BarTop,
        p7.BarBottom
    }
    local t6 = {
        p7.BarTop.Size,
        p7.BarBottom.Size
    }

    p7.ScreenInsets = Enum.ScreenInsets.None

    for _, v25 in t5 do
        UIUtil.tween(v25, 0.5, {
            Size = UDim2.fromScale(1, 0.14)
        })
    end

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Name = "LuckHush"
    ColorCorrectionEffect.Parent = Lighting
    UIUtil.tween(ColorCorrectionEffect, 0.6, {
        Saturation = -0.75,
        Brightness = -0.12,
        Contrast = 0.2
    })

    local v26 = UIUtil.sound("LuckSwell", 0, 1, v23 + 2)

    if v26 then
        v26:Stop()
    end

    local v27
    local v28 = LuckPreludes.make(p6, {
        gui = p7,
        surface = p8,
        fx = p9,
        rarity = p10,
        scene = p11,
        title = p12,
        def = v22,
        grade = ColorCorrectionEffect,
        total = v23,
        pace = CastPace,
        base = CurrentCamera.CFrame,
        look = p8 + Vector3.new(0, 0.5, 0),
        crack = function() -- crack | line: 174
            -- upvalues: p7 (copy), v27 (ref), UIUtil (copy), crack (copy)
            if not v27 then
                v27 = crack(p7)
                UIUtil.sound("LuckShatter", 0.7, 1.2)
            end
        end
    })
    local FieldOfView = CurrentCamera.FieldOfView
    local elapsed = os.clock()
    local v29 = false

    while true do
        local v30 = os.clock() - elapsed
        local v32 = math.min(v30 / v23, 1)

        if v32 >= 0.88 and not v29 then
            v28.silence()
            p12.Parent.Visible = false
            UIUtil.tween(ColorCorrectionEffect, 0.25 * CastPace, {
                Brightness = -0.55,
                Saturation = -0.75,
                Contrast = 0.2,
                TintColor = v1
            })

            if p6 >= 11 and not v27 then
                v27 = crack(p7)
                UIUtil.sound("LuckShatter", 0.7, 1.2)
            end

            v29 = true
        end

        local v33, v34 = v28.step(v30, v32, v29)

        if v26 and not v26.IsPlaying and v26.TimeLength > 0 and v23 - v26.TimeLength <= v30 then
            v26.TimePosition = math.max(0, v26.TimeLength - (v23 - v30))
            v26.Volume = 0.8
            v26:Play()
        end

        CurrentCamera.CFrame = if v29 then Effects.shake(v33, 0.05) else v33
        CurrentCamera.FieldOfView = math.clamp(FieldOfView + v34, 20, 100)

        if v32 >= 1 or Skip.requested() then
            break
        end

        RunService.Heartbeat:Wait()
    end

    if not Skip.requested() then
        t2[p6] = true
    end

    Skip.stop()
    v28.cleanup()

    if v26 then
        task.delay(0.6, function() -- line: 219
            -- upvalues: v26 (copy), UIUtil (copy)
            if v26.Parent then
                UIUtil.tween(v26, 0.4, {
                    Volume = 0
                })
            end
        end)
    end

    p12.Parent.Visible = false
    v24()
    ColorCorrectionEffect:Destroy()

    for v37, v38 in t5 do
        UIUtil.tween(v38, 0.25, {
            Size = t6[v37]
        })
    end

    CurrentCamera.FieldOfView = FieldOfView

    return v27
end

function t1.clock(p13) -- line: 237
    -- upvalues: t1 (copy)
    if p13 < t1.FIRST then
        return function(p14) -- line: 239
            return p14
        end
    end

    local n1 = 0
    local n2 = 0

    return function(p15) -- line: 244
        -- upvalues: n1 (ref), n2 (ref)
        local v40 = math.max(0, p15 - n1)

        n1 = p15

        local v41 = if p15 < 0.7 then 0.22 else math.min(1, (p15 - 0.7) * 0.78 / 0.6 + 0.22)
        local v43 = n2

        n2 = v43 + v40 * v41

        return n2
    end
end

function t1.slowBlur(p16) -- line: 254
    -- upvalues: Lighting (copy), UIUtil (copy), t1 (copy)
    if p16 < t1.FIRST then
        return
    end

    local BlurEffect = Instance.new("BlurEffect")

    BlurEffect.Name = "LuckSlowMo"
    BlurEffect.Size = 10
    BlurEffect.Parent = Lighting
    task.delay(0.7, function() -- line: 262
        -- upvalues: BlurEffect (copy), UIUtil (copy)
        UIUtil.tween(BlurEffect, 0.6, {
            Size = 0
        })
        task.delay(0.65, BlurEffect.Destroy, BlurEffect)
    end)
    UIUtil.sound("Whoosh", 0.7, 0.5)
end

return t1
