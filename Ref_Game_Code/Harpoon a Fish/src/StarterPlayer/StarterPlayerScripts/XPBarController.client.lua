-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {}
local LevelCurve = require((ReplicatedStorage:WaitForChild("Modules")):WaitForChild("LevelCurve"))
local LevelRewards = require(ReplicatedStorage.Modules:WaitForChild("LevelRewards"))
local Loc = require(ReplicatedStorage.Modules:WaitForChild("Loc"))

local function pctNum(p1) -- line: 50
    -- upvalues: LevelRewards (copy)
    return (LevelRewards.Percent(p1):gsub("%%$", ""))
end

local function columns(p2) -- line: 52
    local n1 = 0

    for _, v1 in utf8.codes(p2) do
        n1 += if v1 >= 4352 and v1 <= 4607 or v1 >= 11904 and v1 <= 42191 or v1 >= 44032 and v1 <= 55203 or v1 >= 63744 and v1 <= 64255 or v1 >= 65280 and v1 <= 65376 then 2 else 1
    end

    return n1
end

local LocalPlayer = Players.LocalPlayer
local XPLaneGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("XPLaneGui")
local XPLane = XPLaneGui:WaitForChild("XPLane")
local XPBar = XPLane:WaitForChild("XPBar")
local FillClip = XPBar:WaitForChild("FillClip")
local Fill = FillClip:WaitForChild("Fill")
local Star = XPBar:WaitForChild("Star")
local Level = Star:WaitForChild("Level")
local Pop = Star:WaitForChild("Pop")
local Pop2 = XPBar:WaitForChild("Pop")
local Flash = XPBar:WaitForChild("Flash")
local Glow = XPBar:WaitForChild("Glow")
local t2 = {
    FLICK_PEAK = 0.174,
    FLICK_CROSS = 0.111,
    BUMP = 2.5,
    GAIN_RISE = 0.9,
    GAIN_TIME = 0.7,
    GAIN_POP = 1.2,
    FLICK = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    GAIN_POP_TIME = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}
local t3 = {
    BIG_JUMP = 50,
    STARS = { 6, 28 },
    SPARKS = { 5, 26 },
    STAR_SIZE = { 0.55, 1 },
    SPARK_SIZE = { 0.16, 0.3 },
    REACH = { 1.8, 4.2 },
    LIFE = { 0.55, 0.9 },
    POP = { 1.45, 2.6 },
    POP_TIME = { 0.35, 0.5 },
    BAR_POP = { 1.06, 1.15 },
    RING = { 2.6, 6.5 },
    RING_TIME = { 0.4, 0.6 },
    GLOW = { 2.2, 4 }
}

local function lerp(p3, p4) -- line: 103
    return p3[1] + (p3[2] - p3[1]) * p4
end

local function jumpSize(p5) -- line: 104
    -- upvalues: t3 (copy)
    if p5 <= 1 then
        return 0
    end

    return (math.clamp(math.log(p5) / math.log(t3.BIG_JUMP), 0, 1))
end

local Image = Star.Image
local v4 = Color3.fromRGB(255, 214, 80)
local Scale = Star.Position.Y.Scale
local NumberValue = Instance.new("NumberValue")
local NumberValue2 = Instance.new("NumberValue")

NumberValue2.Value = 1

local function pose() -- line: 116
    -- upvalues: FillClip (copy), Fill (copy), Star (copy), Pop (copy), t2 (copy), Scale (copy), NumberValue (copy), NumberValue2 (copy)
    local Value = NumberValue.Value
    local v5 = math.clamp(Value, 0, 1)

    FillClip.Visible = v5 > 0.001
    FillClip.Size = UDim2.fromScale(math.max(v5, 0.001), 1)
    Fill.Size = UDim2.fromScale(1 / math.max(v5, 0.001), 1)
    Star.Position = UDim2.fromScale(v5, Scale)

    local v6, v7

    if Value < 0 then
        local v8 = -Value

        if v8 then
            v6 = v8
            v7 = true
        elseif Value > 1 then
            local v9 = Value - 1

            if v9 then
                v6 = v9
                v7 = true
            else
                v7 = false
            end
        else
            v7 = false
        end
    elseif Value > 1 then
        local v10 = Value - 1

        if v10 then
            v6 = v10
            v7 = true
        else
            v7 = false
        end
    else
        v7 = false
    end

    if not v7 then
        v6 = 0
    end

    Pop.Scale = NumberValue2.Value * (1 + t2.BUMP * v6)
end

NumberValue.Changed:Connect(pose)
NumberValue2.Changed:Connect(pose)

local function flick(p6, p7) -- line: 129
    -- upvalues: TweenService (copy), NumberValue (copy)
    local tween = TweenService:Create(NumberValue, p7, {
        Value = p6
    })

    tween:Play()
    tween.Completed:Wait()
end

local v11 = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v12 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function flashGold(p8) -- line: 139
    -- upvalues: TweenService (copy), Flash (copy), Glow (copy), t3 (copy), v11 (copy), v12 (copy)
    Flash.ImageTransparency = 0.05
    TweenService:Create(Flash, v11, {
        ImageTransparency = 1
    }):Play()
    Glow.Size = UDim2.fromScale(1, 1)
    Glow.ImageTransparency = 0.35 - 0.2 * p8

    local t4 = {
        ImageTransparency = 1
    }
    local fromScale = UDim2.fromScale
    local v13 = 1.12 + 0.15 * p8
    local GLOW = t3.GLOW

    t4.Size = fromScale(v13, GLOW[1] + (GLOW[2] - GLOW[1]) * p8)
    TweenService:Create(Glow, v12, t4):Play()
end

local function popStar(p9) -- line: 147
    -- upvalues: TweenService (copy), Pop2 (copy), t3 (copy), NumberValue2 (copy), flashGold (copy)
    flashGold(p9)

    local new = TweenInfo.new
    local POP_TIME = t3.POP_TIME
    local v14 = new(POP_TIME[1] + (POP_TIME[2] - POP_TIME[1]) * p9, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local POP = t3.POP

    NumberValue2.Value = POP[1] + (POP[2] - POP[1]) * p9
    TweenService:Create(NumberValue2, v14, {
        Value = 1
    }):Play()

    local BAR_POP = t3.BAR_POP

    Pop2.Scale = BAR_POP[1] + (BAR_POP[2] - BAR_POP[1]) * p9
    TweenService:Create(Pop2, v14, {
        Scale = 1
    }):Play()
end

local function throwPiece(p10, p11, p12, p13, p14) -- line: 157
    -- upvalues: TweenService (copy), XPBar (copy), t3 (copy), Image (copy), v4 (copy)
    local ImageLabel, ImageLabel2, STAR_SIZE

    if p11 then
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel2 = ImageLabel
        ImageLabel.Image = Image
        ImageLabel.BackgroundTransparency = 1
        STAR_SIZE = t3.STAR_SIZE or t3.SPARK_SIZE
    else
        ImageLabel = Instance.new("Frame")
        ImageLabel2 = ImageLabel
        ImageLabel.BackgroundColor3 = math.random() < 0.5 and Color3.new(1, 1, 1) or v4
        ImageLabel.BorderSizePixel = 0

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = ImageLabel
        STAR_SIZE = t3.SPARK_SIZE
    end

    local v15 = (STAR_SIZE[1] + (STAR_SIZE[2] - STAR_SIZE[1]) * p10) * (0.7 + 0.6 * math.random())
    local v16 = UDim2.fromScale(v15 / p14, v15)

    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(v16.X.Scale * 0.3, v15 * 0.3)
    ImageLabel.Position = UDim2.fromScale(p12, p13)
    ImageLabel.Rotation = math.random(-40, 40)
    ImageLabel.ZIndex = 4
    ImageLabel.Parent = XPBar

    local v18 = math.rad((math.random(-25, 205)))
    local REACH = t3.REACH
    local v19 = (REACH[1] + (REACH[2] - REACH[1]) * p10) * (0.6 + 0.6 * math.random()) * (if p11 then 1 else 1.25)
    local LIFE = t3.LIFE
    local v20 = (LIFE[1] + (LIFE[2] - LIFE[1]) * p10) * (0.8 + 0.4 * math.random())
    local v21 = UDim2.fromScale(p12 + math.cos(v18) * v19 / p14, p13 - math.sin(v18) * v19)

    TweenService:Create(ImageLabel, TweenInfo.new(v20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = v21,
        Rotation = ImageLabel.Rotation + math.random(-220, 220)
    }):Play()
    TweenService:Create(ImageLabel, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = v16
    }):Play()
    TweenService:Create(ImageLabel, TweenInfo.new(v20 - 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.12), p11 and {
        ImageTransparency = 1,
        Size = UDim2.fromScale(0, 0)
    } or {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0, 0)
    }):Play()
    task.delay(v20, function() -- line: 191
        -- upvalues: ImageLabel2 (ref)
        ImageLabel2:Destroy()
    end)
end

local function shockRing(p15, p16, p17, p18, p19, p20) -- line: 195
    -- upvalues: TweenService (copy), XPBar (copy), Star (copy), t3 (copy), v4 (copy)
    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(p16, p17)
    Frame.Size = UDim2.fromScale(p19 * 0.6 / p18, p19 * 0.6)
    Frame.ZIndex = 4

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v4
    UIStroke.Thickness = math.max(2, Star.AbsoluteSize.Y * (0.12 + 0.06 * p15))
    UIStroke.Transparency = 0.1
    UIStroke.Parent = Frame
    Frame.Parent = XPBar

    local RING = t3.RING
    local v25 = (RING[1] + (RING[2] - RING[1]) * p15) * p19
    local new = TweenInfo.new
    local RING_TIME = t3.RING_TIME
    local v26 = new(RING_TIME[1] + (RING_TIME[2] - RING_TIME[1]) * p15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, p20 or 0)

    TweenService:Create(Frame, v26, {
        Size = UDim2.fromScale(v25 / p18, v25)
    }):Play()
    TweenService:Create(UIStroke, v26, {
        Thickness = 0,
        Transparency = 1
    }):Play()
    task.delay(v26.Time + v26.DelayTime, function() -- line: 215
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

local function burst(p21) -- line: 220
    -- upvalues: XPBar (copy), Star (copy), t3 (copy), Scale (copy), NumberValue (copy), throwPiece (copy), shockRing (copy)
    local AbsoluteSize = XPBar.AbsoluteSize

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return
    end

    local v27 = AbsoluteSize.X / AbsoluteSize.Y
    local v28 = math.clamp(NumberValue.Value, 0, 1)
    local v29 = Star.AbsoluteSize.Y / AbsoluteSize.Y
    local STARS = t3.STARS

    for _ = 1, math.round(STARS[1] + (STARS[2] - STARS[1]) * p21) do
        throwPiece(p21, true, v28, Scale, v27)
    end

    local SPARKS = t3.SPARKS

    for _ = 1, math.round(SPARKS[1] + (SPARKS[2] - SPARKS[1]) * p21) do
        throwPiece(p21, false, v28, Scale, v27)
    end

    shockRing(p21, v28, Scale, v27, v29, 0)

    if p21 > 0.35 then
        shockRing(p21, v28, Scale, v27, v29 * 0.8, 0.09)
    end
end

local Sound = Instance.new("Sound")

Sound.Name = "XPGainSound"
Sound.SoundId = "rbxassetid://109044565945764"
Sound.Volume = 0.25
task.spawn(function() -- line: 239
    -- upvalues: ContentProvider (copy), Sound (copy)
    ContentProvider:PreloadAsync({
        Sound
    })
end)

local Sound2 = Instance.new("Sound")

Sound2.Name = "XPLevelSound"
Sound2.SoundId = "rbxassetid://2789427964"
Sound2.Volume = 0.5
task.spawn(function() -- line: 245
    -- upvalues: ContentProvider (copy), Sound2 (copy)
    ContentProvider:PreloadAsync({
        Sound2
    })
end)

local function playOnce(p22) -- line: 246
    -- upvalues: SoundService (copy)
    local clone = p22:Clone()

    clone.Parent = SoundService
    clone.Ended:Once(function() -- line: 249
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
    clone:Play()
    task.delay(5, function() -- line: 251
        -- upvalues: clone (copy)
        if clone.Parent then
            clone:Destroy()
        end
    end)
end

local function playGain(p23) -- line: 254
    -- upvalues: Sound (copy), playOnce (copy)
    Sound.PlaybackSpeed = math.clamp(p23 or 0, 0, 1) * 0.1 + 1
    playOnce(Sound)
end

local PassPerks = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PassPerks"))

local function floatGain(p24, p25, p26) -- line: 264
    -- upvalues: TweenService (copy), Loc (copy), LocalPlayer (copy), XPBar (copy), Star (copy), Level (copy), t2 (copy), Sound (copy), playOnce (copy), PassPerks (copy)
    if not p26 then
        Sound.PlaybackSpeed = math.clamp(p25 or 0, 0, 1) * 0.1 + 1
        playOnce(Sound)
    end

    local v34 = LocalPlayer:GetAttribute("XPGainMul") or 1
    local clone = Level:Clone()

    clone.Name = "Gain"
    clone.AutoLocalize = false
    clone.Text = Loc.F("xp.gain", "+{n} XP", {
        n = tostring(v34 > 1 and math.floor(p24 / v34 + 0.5) or p24)
    })
    clone.AnchorPoint = Vector2.new(0.5, 1)
    clone.Size = UDim2.fromScale(3.2, 0.7)
    clone.Position = UDim2.fromScale(Star.Position.X.Scale, 0)
    clone.ZIndex = 7
    clone.Parent = XPBar

    local v37 = TweenInfo.new(t2.GAIN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    TweenService:Create(clone, v37, {
        TextTransparency = 1,
        Position = UDim2.fromScale(Star.Position.X.Scale, -t2.GAIN_RISE)
    }):Play()

    local UIStroke = clone:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        TweenService:Create(UIStroke, v37, {
            Transparency = 1
        }):Play()
    end

    if v34 > 1 then
        local clone2 = Level:Clone()

        clone2.Name = "Mult"

        for _, child in ipairs(clone2:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end

        clone2.Text = "(x" .. string.format("%.1f", v34):gsub("%.0$", "") .. ")"
        clone2.TextXAlignment = Enum.TextXAlignment.Left
        clone2.AnchorPoint = Vector2.new(0, 0.5)
        clone2.Size = UDim2.fromScale(1, 1)
        clone2.ZIndex = 8

        local v38 = clone2:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

        v38.Color = PassPerks.VIP_GRADIENT
        v38.Rotation = 90
        v38.Parent = clone2

        local UIStroke = clone2:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = PassPerks.VIP_STROKE
        end

        local function place() -- line: 294
            -- upvalues: clone (copy), clone2 (copy)
            local X = clone.AbsoluteSize.X
            local v39 = X > 0 and clone.TextBounds.X / X / 2 or 0.2

            clone2.Position = UDim2.fromScale(0.5 + v39 + 0.03, 0.5)
        end

        local X = clone.AbsoluteSize.X
        local v40 = X > 0 and clone.TextBounds.X / X / 2 or 0.2

        clone2.Position = UDim2.fromScale(0.5 + v40 + 0.03, 0.5)
        clone:GetPropertyChangedSignal("TextBounds"):Connect(place)
        clone2.Parent = clone
        TweenService:Create(clone2, v37, {
            TextTransparency = 1
        }):Play()

        if UIStroke then
            TweenService:Create(UIStroke, v37, {
                Transparency = 1
            }):Play()
        end
    end

    task.delay(t2.GAIN_TIME, function() -- line: 305
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
end

local v41

local function truth() -- line: 310
    -- upvalues: LocalPlayer (copy)
    local XPNeed = LocalPlayer:GetAttribute("XPNeed")
    local XP = LocalPlayer:GetAttribute("XP")
    local Level = LocalPlayer:GetAttribute("Level")

    return if type(XPNeed) == "number" and type(XP) == "number" and type(Level) == "number" and not (XPNeed <= 0) then {
        xp = XP,
        need = XPNeed,
        level = Level
    } else nil
end

local function gainBetween(p27, p28, p29, p30) -- line: 318
    -- upvalues: LevelCurve (copy)
    local v42 = p30 - p28

    for i = p27, p29 - 1 do
        v42 += LevelCurve.Need(i)
    end

    return v42
end

local function nudgeStar() -- line: 325
    -- upvalues: TweenService (copy), t2 (copy), NumberValue2 (copy)
    NumberValue2.Value = t2.GAIN_POP
    TweenService:Create(NumberValue2, t2.GAIN_POP_TIME, {
        Value = 1
    }):Play()
end

local t6 = {
    OUT = 1,
    TWIST = 22,
    HOLD = 0.08,
    RISE = 1.1,
    FLOAT = 0.42,
    LEAN = 0.18,
    SIZE = UDim2.fromScale(1.5, 1),
    SPRING = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}
local t7 = {
    ColorSequence.new(Color3.fromRGB(255, 245, 200), Color3.fromRGB(255, 190, 30)),
    Color3.fromRGB(90, 50, 0)
}

t1[1] = 1

local KeyConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("KeyConfig"))
local _ = {
    HEIGHT = 1.3,
    GAP = 0.03,
    CHAR = 0.55
}

local function rewardLabel(p31) -- line: 361
    -- upvalues: LocalPlayer (copy), Level (copy), t7 (copy)
    local XPGui = LocalPlayer.PlayerGui:FindFirstChild("XPGui")
    local v43 = XPGui and XPGui:FindFirstChild("Profile", true)

    v43 = v43 and v43:FindFirstChild(if p31 == "Luck" then "LuckBoost" else "MoneyBoost")

    local clone = (v43 or Level):Clone()

    for _, child in ipairs(clone:GetChildren()) do
        if child:IsA("UIScale") then
            child:Destroy()
        end
    end

    if p31 == "Key" then
        local v44 = clone:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

        v44.Color = t7[1]
        v44.Rotation = 90
        v44.Parent = clone

        local UIStroke = clone:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = t7[2]
        end
    end

    return clone
end

local function springOut(p32, p33, p34, p35, p36) -- line: 378
    -- upvalues: TweenService (copy), XPBar (copy), Star (copy), Scale (copy), t6 (copy)
    local Scale2 = Star.Position.X.Scale

    p32.AnchorPoint = Vector2.new(0.5, 0.5)
    p32.Position = UDim2.fromScale(Scale2, Scale)
    p32.Rotation = p35 * t6.TWIST
    p32.ZIndex = 8

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0
    UIScale.Parent = p32
    p32.Parent = XPBar
    TweenService:Create(UIScale, t6.SPRING, {
        Scale = 1
    }):Play()
    TweenService:Create(p32, t6.SPRING, {
        Rotation = 0,
        Position = UDim2.fromScale(p33, p34)
    }):Play()
    task.delay(t6.SPRING.Time + t6.HOLD, function() -- line: 391
        -- upvalues: p32 (copy), p33 (copy), p34 (copy), p36 (copy), TweenService (copy), t6 (copy)
        if p32.Parent then
            local v45 = TweenInfo.new(t6.FLOAT, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local t8 = {
                Position = UDim2.fromScale(p33, p34 - t6.RISE)
            }

            for v46, v47 in pairs(p36) do
                t8[v46] = v47
            end

            TweenService:Create(p32, v45, t8):Play()

            for _, descendant in ipairs(p32:GetDescendants()) do
                if descendant:IsA("UIStroke") then
                    TweenService:Create(descendant, v45, {
                        Transparency = 1
                    }):Play()
                elseif descendant:IsA("TextLabel") then
                    TweenService:Create(descendant, v45, {
                        TextTransparency = 1
                    }):Play()
                end
            end

            task.delay(t6.FLOAT, function() -- line: 401
                -- upvalues: p32 (copy)
                p32:Destroy()
            end)
        end
    end)
end

local function popRewards(p37, p38) -- line: 405
    -- upvalues: LevelRewards (copy), Loc (copy), columns (copy), XPBar (copy), Star (copy), Scale (copy), t6 (copy), t1 (copy), KeyConfig (copy), rewardLabel (copy), springOut (copy)
    local t9 = {
        Money = 0,
        Luck = 0,
        Key = 0
    }

    for i = p37 + 1, p38 do
        local v48 = LevelRewards.At(i)

        if v48 then
            t9[v48.kind] += v48.amount
        end
    end

    local t10 = {}
    local t11 = {}

    for i = LevelRewards.MilestonesUpTo(p37) + 1, LevelRewards.MilestonesUpTo(p38) do
        local _, v49 = LevelRewards.Milestone(i)

        if not t10[v49] then
            t10[v49] = 0
            t11[#t11 + 1] = v49
        end

        t10[v49] += 1
    end

    local t12 = {}

    if t9.Money > 0 then
        t12[#t12 + 1] = {
            "Money",
            Loc.F("xp.money", "+{p}% Money", {
                p = LevelRewards.Percent(t9.Money):gsub("%%$", "")
            })
        }
    end

    if t9.Luck > 0 then
        t12[#t12 + 1] = {
            "Luck",
            Loc.F("xp.mutation_luck", "+{p}% Mutation luck", {
                p = LevelRewards.Percent(t9.Luck):gsub("%%$", "")
            })
        }
    end

    if t9.Key > 0 then
        local v52 = #t12 + 1
        local v53

        if t9.Key > 1 then
            v53 = Loc.F("xp.gold_keys", "+{n} Gold keys", {
                n = tostring(t9.Key)
            })

            if not v53 then
                v53 = Loc.F("xp.gold_key", "+{n} Gold key", {
                    n = tostring(t9.Key)
                })
            end
        else
            v53 = Loc.F("xp.gold_key", "+{n} Gold key", {
                n = tostring(t9.Key)
            })
        end

        t12[v52] = {
            "Key",
            v53
        }
    end

    local Scale2 = Star.Position.X.Scale
    local AbsoluteSize = XPBar.AbsoluteSize
    local v54 = AbsoluteSize.Y > 0 and AbsoluteSize.X / AbsoluteSize.Y or 8

    if #t12 > 0 then
        t1[1] = -t1[1]
    end

    local n2 = 0

    for v55, v56 in ipairs(t12) do
        local v57 = rewardLabel(v56[1])

        v57.Name = "Reward"
        v57.AutoLocalize = false
        v57.Text = v56[2]
        v57.TextXAlignment = Enum.TextXAlignment.Center
        v57.TextScaled = true
        v57.Size = t6.SIZE
        n2 = math.max(n2, columns(v56[2]) * 0.55 * t6.SIZE.Y.Scale / v54 / 2)

        local v59 = Scale - t6.OUT - (v55 - 1) * t6.SIZE.Y.Scale

        springOut(v57, Scale2 + t1[1] * t6.LEAN, v59, t1[1], {
            TextTransparency = 1
        })
    end

    if #t11 == 0 then
        return
    end

    local v60

    if #t12 > 0 then
        v60 = -t1[1]
    else
        t1[1] = -t1[1]
        v60 = t1[1]
    end

    local v61 = 1.3 / v54
    local v63 = Scale2 + v60 * (math.max(0, #t12 > 0 and n2 - t6.LEAN or -t6.LEAN) + 0.03 + v61 / 2)

    for v64, v65 in ipairs(t11) do
        local v66 = KeyConfig.KEYS[v65]

        if v66 then
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "RewardKey"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Image = v66.image
            ImageLabel.ImageRectOffset = Vector2.new(v66.rect[1], v66.rect[2])
            ImageLabel.ImageRectSize = Vector2.new(v66.rect[3] - v66.rect[1], v66.rect[4] - v66.rect[2])
            ImageLabel.ScaleType = Enum.ScaleType.Fit
            ImageLabel.Size = UDim2.fromScale(v61, 1.3)

            if t10[v65] > 1 then
                local Key = rewardLabel("Key")

                Key.Name = "Count"
                Key.Text = "x" .. t10[v65]
                Key.TextScaled = true
                Key.TextXAlignment = Enum.TextXAlignment.Center
                Key.AnchorPoint = Vector2.new(0.5, 0)
                Key.Position = UDim2.fromScale(0.5, 0.8)
                Key.Size = UDim2.fromScale(1.4, 0.45)
                Key.Rotation = 0
                Key.ZIndex = 9
                Key.Parent = ImageLabel
            end

            springOut(ImageLabel, v63, Scale - t6.OUT - (v64 - 1) * 1.3, v60, {
                ImageTransparency = 1
            })
        end
    end
end

local function levelUp(p39, p40) -- line: 487
    -- upvalues: Level (copy), t3 (copy), popStar (copy), burst (copy), Sound2 (copy), playOnce (copy)
    local v68 = p40 - p39
    local v69 = if v68 <= 1 then 0 else math.clamp(math.log(v68) / math.log(t3.BIG_JUMP), 0, 1)

    burst(v69)
    Level.Text = tostring(p40)
    popStar(v69)
    playOnce(Sound2)
end

local t19 = {
    GAP = 0.075,
    MIN_GAP = 0.055,
    MAX_TIME = 3.2,
    POP = 1.4,
    BAR_POP = 1.04,
    FLASH = 0.35,
    DUST = 4,
    DUST_SIZE = 0.15,
    RUSH = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    POP_TIME = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    FLASH_TIME = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

local function hammerPop() -- line: 516
    -- upvalues: TweenService (copy), XPBar (copy), Pop2 (copy), Flash (copy), NumberValue2 (copy), throwPiece (copy), Sound2 (copy), playOnce (copy), t19 (copy)
    NumberValue2.Value = t19.POP
    TweenService:Create(NumberValue2, t19.POP_TIME, {
        Value = 1
    }):Play()
    Pop2.Scale = t19.BAR_POP
    TweenService:Create(Pop2, t19.POP_TIME, {
        Scale = 1
    }):Play()
    Flash.ImageTransparency = t19.FLASH
    TweenService:Create(Flash, t19.FLASH_TIME, {
        ImageTransparency = 1
    }):Play()

    local AbsoluteSize = XPBar.AbsoluteSize

    if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
        for i = 1, t19.DUST do
            throwPiece(t19.DUST_SIZE, i == 1, math.random(), 0.5, AbsoluteSize.X / AbsoluteSize.Y)
        end
    end

    playOnce(Sound2)
end

local function hammerLevels(p41, p42) -- line: 532
    -- upvalues: TweenService (copy), Level (copy), t3 (copy), NumberValue (copy), popStar (copy), burst (copy), Sound2 (copy), playOnce (copy), popRewards (copy), t19 (copy), hammerPop (copy)
    local v72 = p42 - p41
    local v74 = math.clamp(t19.MAX_TIME / v72, t19.MIN_GAP, t19.GAP)
    local v77 = math.min(v72, (math.floor(t19.MAX_TIME / v74)))
    local tween = TweenService:Create(NumberValue, t19.RUSH, {
        Value = 1
    })

    tween:Play()
    tween.Completed:Wait()

    local elapsed = os.clock()

    for i = 1, v77 do
        local v78 = elapsed + (i - 1) * v74

        while os.clock() < v78 do
            task.wait()
        end

        local v80 = p41 + math.floor((i - 1) * v72 / v77)
        local v81 = i < v77
        local v82 = if v81 then p41 + math.floor(i * v72 / v77) else nil
        local v84 = if not v81 or not v82 then p42 else v82

        if i < v77 then
            Level.Text = tostring(v84)
            hammerPop()
        else
            local v85 = p42 - p41
            local v86 = if v85 <= 1 then 0 else math.clamp(math.log(v85) / math.log(t3.BIG_JUMP), 0, 1)

            burst(v86)
            Level.Text = tostring(p42)
            popStar(v86)
            playOnce(Sound2)
        end

        popRewards(v80, v84)
    end
end

local function backToStart(p43) -- line: 559
    -- upvalues: TweenService (copy), t2 (copy), NumberValue (copy), v41 (ref), truth (copy)
    local tween = TweenService:Create(NumberValue, t2.FLICK, {
        Value = 0
    })

    tween:Play()
    task.wait(t2.FLICK_CROSS)

    if p43 then
        p43()
    end

    task.wait(t2.FLICK_PEAK - t2.FLICK_CROSS)

    local v89 = truth()

    if v89 and (v89.level ~= v41.level or v89.xp ~= v41.xp) then
        tween:Cancel()

        return true
    end

    if tween.PlaybackState == Enum.PlaybackState.Playing then
        tween.Completed:Wait()
    end

    return false
end

local v90 = false
local v91

local function catchUp() -- line: 576
    -- upvalues: TweenService (copy), LevelCurve (copy), Level (copy), t2 (copy), t3 (copy), NumberValue (copy), NumberValue2 (copy), pose (copy), popStar (copy), burst (copy), Sound2 (copy), playOnce (copy), floatGain (copy), v41 (ref), truth (copy), popRewards (copy), hammerLevels (copy), backToStart (copy), v90 (ref), v91 (ref)
    if not v90 then
        v90 = true

        local v92 = false

        while true do
            local v93 = truth()

            if v93 then
                if v41 then
                    if v93.level ~= v41.level or v93.xp ~= v41.xp then
                        local v94 = v93.level .. ":" .. v93.xp

                        if v94 ~= v91 then
                            v91 = v94

                            local level, xp = v41.level, v41.xp
                            local level2 = v93.level
                            local v95 = v93.xp - xp

                            for i = level, level2 - 1 do
                                v95 += LevelCurve.Need(i)
                            end

                            if v95 > 0 then
                                floatGain(v95, if v93.level > v41.level then 1 else v93.xp / v93.need, v93.level - v41.level >= 2)
                            end
                        end

                        if v93.level - v41.level >= 2 then
                            local level = v41.level

                            v41 = {
                                xp = 0,
                                need = LevelCurve.Need(v93.level),
                                level = v93.level
                            }
                            hammerLevels(level, v93.level)
                            v92 = backToStart()
                        elseif v93.level > v41.level then
                            local tween = TweenService:Create(NumberValue, t2.FLICK, {
                                Value = 1
                            })

                            tween:Play()
                            task.wait(t2.FLICK_PEAK)
                            tween:Cancel()

                            local level = v41.level

                            v41 = {
                                xp = 0,
                                need = LevelCurve.Need(v93.level),
                                level = v93.level
                            }
                            v92 = backToStart(function() -- line: 614
                                -- upvalues: v93 (copy), level (copy), Level (copy), t3 (copy), popStar (copy), burst (copy), Sound2 (copy), playOnce (copy), popRewards (copy)
                                local level2 = v93.level
                                local v97 = level2 - level
                                local v98 = if v97 <= 1 then 0 else math.clamp(math.log(v97) / math.log(t3.BIG_JUMP), 0, 1)

                                burst(v98)
                                Level.Text = tostring(level2)
                                popStar(v98)
                                playOnce(Sound2)
                                popRewards(level, v93.level)
                            end)
                        else
                            local v101 = v93.level == v41.level and v93.xp > v41.xp

                            v41 = v93

                            if v101 and not v92 then
                                NumberValue2.Value = t2.GAIN_POP
                                TweenService:Create(NumberValue2, t2.GAIN_POP_TIME, {
                                    Value = 1
                                }):Play()
                            end

                            local v102 = v93.xp / v93.need
                            local tween = TweenService:Create(NumberValue, t2.FLICK, {
                                Value = v102
                            })

                            tween:Play()
                            v92 = false
                            tween.Completed:Wait()
                        end

                        continue
                    end
                else
                    v41 = v93
                    Level.Text = tostring(v93.level)
                    NumberValue.Value = v93.xp / v93.need
                    pose()
                end
            end

            break
        end

        v90 = false
    end
end

local v103
local v104 = false
local v105, v106, v107, v108, v109
local n3 = 0
local v110 = false
local v111 = false

local function changed() -- line: 638
    -- upvalues: LocalPlayer (copy), v41 (ref), truth (copy), v90 (ref), catchUp (copy), v103 (ref), v104 (ref), v105 (ref), v106 (ref), v107 (ref), v108 (ref), v109 (ref), v111 (ref)
    if not v111 then
        v111 = true
        task.delay(0.15, function() -- line: 641
            -- upvalues: LocalPlayer (copy), v41 (ref), truth (copy), v90 (ref), catchUp (copy), v103 (ref), v104 (ref), v105 (ref), v106 (ref), v107 (ref), v108 (ref), v109 (ref), v111 (ref)
            local elapsed = os.clock()

            while LocalPlayer:GetAttribute("CatchCardInFlight") and os.clock() - elapsed < 5 do
                task.wait(0.03)
            end

            v111 = false

            local v112 = truth()

            if v41 and v112 and (v112.level ~= v41.level or v112.xp ~= v41.xp) and not v103 and v105 then
                v105()
                task.wait(v107())
            end

            if v41 and v112 and (v112.level ~= v41.level or v112.xp ~= v41.xp) and v103 and v108 then
                task.wait(v108())
            end

            task.spawn(function() -- line: 657
                -- upvalues: v90 (ref), catchUp (copy), v103 (ref), v104 (ref), v106 (ref), v109 (ref)
                catchUp()

                if v104 and not v90 and v106 then
                    v106()
                end

                if v103 and not v90 and v109 then
                    v109()
                end
            end)
        end)
    end
end

for _, v113 in ipairs({ "XP", "XPNeed", "Level" }) do
    LocalPlayer:GetAttributeChangedSignal(v113):Connect(changed)
end

if not v111 then
    v111 = true
    task.delay(0.15, function() -- line: 641
        -- upvalues: LocalPlayer (copy), v41 (ref), truth (copy), v90 (ref), catchUp (copy), v103 (ref), v104 (ref), v105 (ref), v106 (ref), v107 (ref), v108 (ref), v109 (ref), v111 (ref)
        local elapsed = os.clock()

        while LocalPlayer:GetAttribute("CatchCardInFlight") and os.clock() - elapsed < 5 do
            task.wait(0.03)
        end

        v111 = false

        local v114 = truth()

        if v41 and v114 and (v114.level ~= v41.level or v114.xp ~= v41.xp) and not v103 and v105 then
            v105()
            task.wait(v107())
        end

        if v41 and v114 and (v114.level ~= v41.level or v114.xp ~= v41.xp) and v103 and v108 then
            task.wait(v108())
        end

        task.spawn(function() -- line: 657
            -- upvalues: v90 (ref), catchUp (copy), v103 (ref), v104 (ref), v106 (ref), v109 (ref)
            catchUp()

            if v104 and not v90 and v106 then
                v106()
            end

            if v103 and not v90 and v109 then
                v109()
            end
        end)
    end)
end

local v115 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v116 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local v117

local function refreshShown() -- line: 673
    -- upvalues: TweenService (copy), LocalPlayer (copy), XPLane (copy), Pop2 (copy), v103 (ref), v109 (ref), n3 (ref), v110 (ref), v115 (copy), v116 (copy), v117 (ref)
    local v118 = LocalPlayer:GetAttribute("HudSlot") == "Bag"

    if v118 ~= v103 then
        v103 = v118

        if v118 then
            if v117 then
                v117(true)
            end

            v110 = false
            XPLane.Visible = true
            Pop2.Scale = 0.3
            TweenService:Create(Pop2, v115, {
                Scale = 1
            }):Play()

            if v109 then
                v109()
            end
        else
            n3 += 1

            local tween = TweenService:Create(Pop2, v116, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 688
                -- upvalues: XPLane (copy), v103 (ref)
                if not v103 then
                    XPLane.Visible = false
                end
            end)
            tween:Play()
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("HudSlot"):Connect(refreshShown)
XPLane.Visible = false
v103 = false
refreshShown()

local Size, XPBarPosition = XPBar.Size, XPBar.Position
local v119 = Star.Size.Y.Scale / 2
local DiveGui

local function promptBox() -- line: 712
    -- upvalues: DiveGui (ref)
    if not DiveGui then
        return nil
    end

    local Leave = DiveGui:FindFirstChild("Leave")
    local SpaceHint = DiveGui:FindFirstChild("SpaceHint")

    if Leave and Leave.Visible then
        return Leave.AbsolutePosition.X, Leave.AbsolutePosition.Y, Leave.AbsolutePosition.Y + Leave.AbsoluteSize.Y
    end

    if SpaceHint and SpaceHint.Visible then
        local n4 = 1e999
        local n5 = 1e999
        local n6 = (-1e999)

        for _, descendant in ipairs(SpaceHint:GetDescendants()) do
            if descendant:IsA("GuiObject") and descendant.Visible then
                local X = descendant.AbsolutePosition.X

                if descendant:IsA("TextLabel") then
                    X += (descendant.AbsoluteSize.X - descendant.TextBounds.X) / 2
                end

                n4 = math.min(n4, X)
                n5 = math.min(n5, descendant.AbsolutePosition.Y)
                n6 = math.max(n6, descendant.AbsolutePosition.Y + descendant.AbsoluteSize.Y)
            end
        end

        if n4 < 1e999 then
            return n4, n5, n6
        end
    end

    local PadSeat = DiveGui:FindFirstChild("PadSeat")

    if PadSeat and PadSeat.Visible then
        local n7 = 1e999
        local n8 = 1e999
        local n9 = (-1e999)

        for _, child in ipairs(PadSeat:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                n7 = math.min(n7, child.AbsolutePosition.X)
                n8 = math.min(n8, child.AbsolutePosition.Y)
                n9 = math.max(n9, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
            end
        end

        if n7 < 1e999 then
            return n7, n8, n9
        end
    end

    return nil
end

local function fitBar() -- line: 747
    -- upvalues: XPLaneGui (copy), XPLane (copy), XPBar (copy), v103 (ref), Size (copy), XPBarPosition (copy), v119 (copy), promptBox (copy)
    local v122 = 1

    if v103 then
        local v123, v124, v125 = promptBox()
        local AbsoluteSize, AbsolutePosition = XPLane.AbsoluteSize, XPLane.AbsolutePosition

        if v123 and AbsoluteSize.X > 0 then
            local v126 = AbsolutePosition.X + XPBarPosition.X.Scale * AbsoluteSize.X
            local v127 = Size.Y.Scale * AbsoluteSize.Y
            local v128 = Size.X.Scale * AbsoluteSize.X + v119 * v127
            local v129 = AbsolutePosition.Y + XPBarPosition.Y.Scale * AbsoluteSize.Y
            local v130 = v119 * v127

            v122 = if v124 < v129 + v130 and v129 - v130 < v125 then math.clamp((v123 - 0.015 * XPLaneGui.AbsoluteSize.X - v126) / v128, 0.45, 1) else 1
        end
    end

    XPBar.Size = UDim2.new(Size.X.Scale * v122, Size.X.Offset, Size.Y.Scale * v122, Size.Y.Offset)
end

XPLane:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitBar)
XPLane:GetPropertyChangedSignal("AbsolutePosition"):Connect(fitBar)
LocalPlayer:GetAttributeChangedSignal("HudSlot"):Connect(function() -- line: 769
    -- upvalues: fitBar (copy)
    task.defer(fitBar)
end)
task.spawn(function() -- line: 770
    -- upvalues: LocalPlayer (copy), DiveGui (ref), fitBar (copy)
    DiveGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DiveGui")

    for _, v132 in ipairs({ "Leave", "SpaceHint" }) do
        local v133 = DiveGui:WaitForChild(v132)

        v133:GetPropertyChangedSignal("Visible"):Connect(fitBar)
        v133:GetPropertyChangedSignal("AbsolutePosition"):Connect(fitBar)
        v133:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitBar)
    end

    local v134 = DiveGui:WaitForChild("PadSeat", 10)

    if v134 then
        for _, child in ipairs(v134:GetChildren()) do
            if child:IsA("GuiObject") then
                child:GetPropertyChangedSignal("Visible"):Connect(fitBar)
                child:GetPropertyChangedSignal("AbsolutePosition"):Connect(fitBar)
            end
        end
    end

    fitBar()
end)

local t20 = {
    GAP = 0.02,
    NO_HOTBAR_Y = 0.93,
    HOLD = 0.9,
    PEEK_MAX = 3,
    FADE_IN = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    FADE_OUT = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
}
local XPLanePosition = XPLane.Position
local UIStroke = Level:FindFirstChildOfClass("UIStroke")
local n10 = 0
local n11 = 0
local t21 = {}

local function stopFades() -- line: 813
    -- upvalues: t21 (copy)
    for _, v135 in ipairs(t21) do
        v135:Cancel()
    end

    table.clear(t21)
end

local function fadeTo(p44, p45) -- line: 817
    -- upvalues: TweenService (copy), XPBar (copy), Fill (copy), Star (copy), Level (copy), UIStroke (copy), t21 (copy)
    for _, v136 in ipairs(t21) do
        v136:Cancel()
    end

    table.clear(t21)

    for _, v137 in ipairs({ XPBar, Fill, Star }) do
        t21[#t21 + 1] = TweenService:Create(v137, p45, {
            ImageTransparency = p44
        })
    end

    t21[#t21 + 1] = TweenService:Create(Level, p45, {
        TextTransparency = p44
    })

    if UIStroke then
        t21[#t21 + 1] = TweenService:Create(UIStroke, p45, {
            Transparency = p44
        })
    end

    for _, v138 in ipairs(t21) do
        v138:Play()
    end
end

local function setFade(p46) -- line: 824
    -- upvalues: XPBar (copy), Fill (copy), Star (copy), Level (copy), UIStroke (copy), t21 (copy)
    for _, v139 in ipairs(t21) do
        v139:Cancel()
    end

    table.clear(t21)
    XPBar.ImageTransparency = p46
    Fill.ImageTransparency = p46
    Star.ImageTransparency = p46
    Level.TextTransparency = p46

    if UIStroke then
        UIStroke.Transparency = p46
    end
end

local function hotbarTop() -- line: 830
    -- upvalues: LocalPlayer (copy), XPLaneGui (copy)
    local BackpackGui = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")
    local Enabled = BackpackGui and BackpackGui.Enabled and BackpackGui:FindFirstChild("Backpack") and BackpackGui.Backpack:FindFirstChild("Hotbar")

    if Enabled then
        for _, child in ipairs(Enabled:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                return Enabled.AbsolutePosition.Y - XPLaneGui.AbsolutePosition.Y
            end
        end
    end

    return nil
end

local function placeOnLand() -- line: 840
    -- upvalues: XPLaneGui (copy), XPLane (copy), XPBar (copy), Star (copy), t20 (copy), hotbarTop (copy)
    local AbsoluteSize = XPLaneGui.AbsoluteSize

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return
    end

    local v142 = math.max(XPBar.AbsolutePosition.Y + XPBar.AbsoluteSize.Y, Star.AbsolutePosition.Y + Star.AbsoluteSize.Y) - XPLaneGui.AbsolutePosition.Y
    local v143 = XPBar.AbsolutePosition.X + XPBar.AbsoluteSize.X / 2 - XPLaneGui.AbsolutePosition.X
    local v144 = hotbarTop()
    local v145 = v144 and v144 - t20.GAP * AbsoluteSize.Y or t20.NO_HOTBAR_Y * AbsoluteSize.Y
    local XPLanePosition = XPLane.Position

    XPLane.Position = UDim2.new(XPLanePosition.X.Scale + (AbsoluteSize.X / 2 - v143) / AbsoluteSize.X, XPLanePosition.X.Offset, XPLanePosition.Y.Scale + (v145 - v142) / AbsoluteSize.Y, XPLanePosition.Y.Offset)
end

v117 = function(p47) -- line: 850
    -- upvalues: LocalPlayer (copy), XPLane (copy), XPBar (copy), Fill (copy), Star (copy), Level (copy), v103 (ref), v104 (ref), t20 (copy), XPLanePosition (copy), UIStroke (copy), n10 (ref), t21 (copy), fadeTo (copy)
    if not (v104 or p47) then
        return
    end

    v104 = false
    n10 += 1

    local v146 = n10

    local function home() -- line: 855
        -- upvalues: LocalPlayer (copy), XPLane (copy), XPBar (copy), Fill (copy), Star (copy), Level (copy), v103 (ref), XPLanePosition (copy), UIStroke (copy), t21 (copy)
        if not v103 then
            XPLane.Visible = false
        end

        XPLane.Position = XPLanePosition

        for _, v147 in ipairs(t21) do
            v147:Cancel()
        end

        table.clear(t21)
        XPBar.ImageTransparency = 0
        Fill.ImageTransparency = 0
        Star.ImageTransparency = 0
        Level.TextTransparency = 0

        if UIStroke then
            UIStroke.Transparency = 0
        end

        LocalPlayer:SetAttribute("XPBarOnLand", nil)
    end

    if not p47 then
        fadeTo(1, t20.FADE_OUT)
        task.delay(t20.FADE_OUT.Time, function() -- line: 863
            -- upvalues: v146 (copy), LocalPlayer (copy), XPLane (copy), XPBar (copy), Fill (copy), Star (copy), Level (copy), v103 (ref), v104 (ref), XPLanePosition (copy), UIStroke (copy), n10 (ref), t21 (copy)
            if v146 ~= n10 or v104 then
                return
            elseif not v103 then
                XPLane.Visible = false
            end

            XPLane.Position = XPLanePosition

            for _, v149 in ipairs(t21) do
                v149:Cancel()
            end

            table.clear(t21)
            XPBar.ImageTransparency = 0
            Fill.ImageTransparency = 0
            Star.ImageTransparency = 0
            Level.TextTransparency = 0

            if UIStroke then
                UIStroke.Transparency = 0
            end

            LocalPlayer:SetAttribute("XPBarOnLand", nil)
        end)

        return
    end

    if not v103 then
        XPLane.Visible = false
    end

    XPLane.Position = XPLanePosition

    for _, v150 in ipairs(t21) do
        v150:Cancel()
    end

    table.clear(t21)
    XPBar.ImageTransparency = 0
    Fill.ImageTransparency = 0
    Star.ImageTransparency = 0
    Level.TextTransparency = 0

    if UIStroke then
        UIStroke.Transparency = 0
    end

    LocalPlayer:SetAttribute("XPBarOnLand", nil)
end

v105 = function() -- line: 867
    -- upvalues: RunService (copy), LocalPlayer (copy), XPLane (copy), XPBar (copy), Fill (copy), Star (copy), Level (copy), Pop2 (copy), v90 (ref), v103 (ref), v104 (ref), v117 (ref), t20 (copy), XPLanePosition (copy), UIStroke (copy), n10 (ref), n11 (ref), t21 (copy), fadeTo (copy), placeOnLand (copy)
    if v103 then
        return
    end

    n10 += 1

    local v151 = n10

    if not v104 then
        v104 = true
        LocalPlayer:SetAttribute("XPBarOnLand", true)

        for _, v152 in ipairs(t21) do
            v152:Cancel()
        end

        table.clear(t21)
        XPBar.ImageTransparency = 1
        Fill.ImageTransparency = 1
        Star.ImageTransparency = 1
        Level.TextTransparency = 1

        if UIStroke then
            UIStroke.Transparency = 1
        end

        Pop2.Scale = 1
        XPLane.Position = XPLanePosition
        XPLane.Visible = true
        RunService.RenderStepped:Wait()

        if v151 ~= n10 or not v104 then
            return
        end

        placeOnLand()
        fadeTo(0, t20.FADE_IN)
        n11 = os.clock()
    end

    task.delay(t20.PEEK_MAX, function() -- line: 886
        -- upvalues: v151 (copy), v90 (ref), v117 (ref), n10 (ref)
        if v151 == n10 and not v90 then
            v117()
        end
    end)
end

v106 = function() -- line: 890
    -- upvalues: v90 (ref), v117 (ref), t20 (copy), n10 (ref)
    n10 += 1

    local v153 = n10

    task.delay(t20.HOLD, function() -- line: 893
        -- upvalues: v153 (copy), v90 (ref), v117 (ref), n10 (ref)
        if v153 == n10 and not v90 then
            v117()
        end
    end)
end

v107 = function() -- line: 897
    -- upvalues: t20 (copy), n11 (ref)
    return (math.max(0, t20.FADE_IN.Time - (os.clock() - n11)))
end

LocalPlayer:GetAttributeChangedSignal("XPPeek"):Connect(function() -- line: 900
    -- upvalues: LocalPlayer (copy), v105 (ref)
    if LocalPlayer:GetAttribute("XPPeek") then
        v105()
    end
end)

v109 = function() -- line: 910
    -- upvalues: v90 (ref), v103 (ref), n3 (ref), v110 (ref), t20 (copy), fadeTo (copy)
    n3 += 1

    local v155 = n3

    task.delay(2.5, function() -- line: 913
        -- upvalues: v155 (copy), v90 (ref), v103 (ref), n3 (ref), v110 (ref), t20 (copy), fadeTo (copy)
        if v155 == n3 and v103 and not v90 then
            v110 = true
            fadeTo(1, t20.FADE_OUT)
        end
    end)
end

v108 = function() -- line: 920
    -- upvalues: n3 (ref), v110 (ref), t20 (copy), fadeTo (copy)
    n3 += 1

    if not v110 then
        return 0
    end

    v110 = false
    fadeTo(0, t20.FADE_IN)

    return t20.FADE_IN.Time
end
