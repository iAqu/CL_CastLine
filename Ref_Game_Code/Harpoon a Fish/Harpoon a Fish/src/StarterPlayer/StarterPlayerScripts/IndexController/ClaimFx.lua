-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KeyConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("KeyConfig"))
local RarityStyle = require(ReplicatedStorage.Modules:WaitForChild("RarityStyle"))
local ButtonHover = require(ReplicatedStorage.Modules:WaitForChild("ButtonHover"))
local t2 = {
    SLOT_POP = 1.32,
    SLOT_UP = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SLOT_SETTLE = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ICON_KICK = 18,
    ICON_SETTLE = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    FLASH = 0.1,
    FLASH_TIME = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    STARS = 2,
    SPARKS = 5,
    STAR_SIZE = { 0.32, 0.5 },
    SPARK_SIZE = { 0.09, 0.15 },
    REACH = { 0.7, 1.3 },
    LIFE = { 0.45, 0.7 },
    RING = { 0.7, 1.9 },
    RING_TIME = 0.4,
    KEY_W = 1.45,
    KEY_H = 0.6,
    KEY_OUT = 0.62,
    KEY_TWIST = 22,
    KEY_SPRING = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    KEY_HOLD = 0.12,
    KEY_RISE = 0.55,
    KEY_FLOAT = 0.45,
    WORDS_STROKE = 0.06,
    WORDS_MAX = 2,
    PITCH = { 0.95, 1.4 },
    THUMP = 1.035,
    THUMP_TIME = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    RUNG_STARS = 12,
    RUNG_SPARKS = 18,
    RUNG_SCALE = 2.4,
    RUNG_SLOW = 2.2,
    RUNG_TO = Vector2.new(-1.5, 1.35)
}
local t3 = {
    card = {
        id = "rbxassetid://137392628136734",
        volume = 0.5
    },
    burst = {
        id = "rbxassetid://76357092271646",
        volume = 0.6
    },
    level = {
        id = "rbxassetid://2789427964",
        volume = 0.5
    }
}
local v1 = Color3.fromRGB(255, 214, 80)
local v2 = Color3.new(1, 1, 1)
local v3 = Font.new("rbxasset://fonts/families/FredokaOne.json")
local v4, v5
local v6 = Random.new()
local n1 = 1
local t4 = {}
local t1 = {}

function t1.Init(p1, p2) -- line: 76
    -- upvalues: ContentProvider (copy), t3 (copy), v4 (ref), v5 (ref), t4 (copy)
    v4 = v4 or p1
    v5 = v5 or p2

    if not next(t4) then
        for v7, v8 in pairs(t3) do
            local Sound = Instance.new("Sound")

            Sound.Name = "IndexClaim_" .. v7
            Sound.SoundId = v8.id
            Sound.Volume = v8.volume
            t4[v7] = Sound
        end

        task.spawn(function() -- line: 87
            -- upvalues: ContentProvider (copy), t4 (copy)
            local t5 = {}

            for _, v9 in pairs(t4) do
                t5[#t5 + 1] = v9
            end

            local PreloadAsync = ContentProvider.PreloadAsync

            pcall(PreloadAsync, ContentProvider, t5)
        end)
    end
end

local function play(p3, p4) -- line: 94
    -- upvalues: SoundService (copy), t4 (copy)
    local v10 = t4[p3]

    if not v10 then
        return
    end

    local clone = v10:Clone()

    clone.PlaybackSpeed = p4 or 1
    clone.Parent = SoundService
    clone.Ended:Once(function() -- line: 100
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
    clone:Play()
    task.delay(5, function() -- line: 102
        -- upvalues: clone (copy)
        if clone.Parent then
            clone:Destroy()
        end
    end)
end

local function range(p5) -- line: 105
    -- upvalues: v6 (copy)
    return v6:NextNumber(p5[1], p5[2])
end

local function layerFor(p6) -- line: 108
    -- upvalues: v4 (ref)
    local ScreenGui = p6:FindFirstAncestorOfClass("ScreenGui")

    return ScreenGui and ScreenGui:FindFirstChild("Fx") or v4
end

local function centreOf(p7) -- line: 114
    -- upvalues: v4 (ref)
    return p7.AbsolutePosition + p7.AbsoluteSize / 2 - v4.AbsolutePosition
end

local function at(p8) -- line: 119
    -- upvalues: v4 (ref)
    local AbsoluteSize = v4.AbsoluteSize

    return UDim2.fromScale(p8.X / AbsoluteSize.X, p8.Y / AbsoluteSize.Y)
end

local function size(p9, p10) -- line: 123
    -- upvalues: v4 (ref)
    local AbsoluteSize = v4.AbsoluteSize

    return UDim2.fromScale(p9 / AbsoluteSize.X, p10 / AbsoluteSize.Y)
end

local function visible(p11) -- line: 129
    -- upvalues: v2 (copy)
    return select(3, p11:ToHSV()) < 0.15 and v2 or p11
end

local function throw(p12, p13, p14, p15, p16) -- line: 134
    -- upvalues: TweenService (copy), t2 (copy), v1 (copy), v2 (copy), v4 (ref), v5 (ref), v6 (copy)
    p16 = p16 or 1

    local ImageLabel, ImageLabel2, STAR_SIZE

    if p14 then
        ImageLabel = Instance.new("ImageLabel")
        ImageLabel2 = ImageLabel
        ImageLabel.Image = v5
        ImageLabel.ImageColor3 = v6:NextNumber() < 0.5 and v2 or v1
        ImageLabel.BackgroundTransparency = 1
        STAR_SIZE = t2.STAR_SIZE or t2.SPARK_SIZE
    else
        ImageLabel = Instance.new("Frame")
        ImageLabel2 = ImageLabel

        local v12 = v6:NextNumber()
        local v13 = if v12 < 0.4 and v2 then v2 elseif v12 < 0.7 and v1 then v1 else p15

        ImageLabel.BackgroundColor3 = v13
        ImageLabel.BorderSizePixel = 0

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = ImageLabel
        STAR_SIZE = t2.SPARK_SIZE
    end

    local v14 = p13 * v6:NextNumber(STAR_SIZE[1], STAR_SIZE[2]) * p16

    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)

    local v15 = v14 * 0.3
    local v16 = v14 * 0.3
    local AbsoluteSize = v4.AbsoluteSize

    ImageLabel.Size = UDim2.fromScale(v15 / AbsoluteSize.X, v16 / AbsoluteSize.Y)

    local AbsoluteSize2 = v4.AbsoluteSize

    ImageLabel.Position = UDim2.fromScale(p12.X / AbsoluteSize2.X, p12.Y / AbsoluteSize2.Y)
    ImageLabel.Rotation = v6:NextInteger(-40, 40)
    ImageLabel.ZIndex = 22
    ImageLabel.Parent = v4

    local v17 = v6:NextNumber(0, 6.283185307179586)
    local REACH = t2.REACH
    local v18 = p13 * v6:NextNumber(REACH[1], REACH[2]) * p16 * (if p14 then 1 else 1.25)
    local LIFE = t2.LIFE
    local v19 = v6:NextNumber(LIFE[1], LIFE[2])
    local v20 = TweenInfo.new(v19, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local v21 = p12 + Vector2.new(math.cos(v17), (math.sin(v17))) * v18
    local AbsoluteSize3 = v4.AbsoluteSize

    TweenService:Create(ImageLabel, v20, {
        Position = UDim2.fromScale(v21.X / AbsoluteSize3.X, v21.Y / AbsoluteSize3.Y),
        Rotation = ImageLabel.Rotation + v6:NextInteger(-220, 220)
    }):Play()

    local v22 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local AbsoluteSize4 = v4.AbsoluteSize

    TweenService:Create(ImageLabel, v22, {
        Size = UDim2.fromScale(v14 / AbsoluteSize4.X, v14 / AbsoluteSize4.Y)
    }):Play()

    local v23 = TweenInfo.new(v19 - 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.12)
    local t8

    if p14 then
        t8 = {
            ImageTransparency = 1
        }

        local AbsoluteSize = v4.AbsoluteSize

        t8.Size = UDim2.fromScale(0 / AbsoluteSize.X, 0 / AbsoluteSize.Y)
    end

    if not p14 or not t8 then
        t8 = {
            BackgroundTransparency = 1
        }

        local AbsoluteSize = v4.AbsoluteSize

        t8.Size = UDim2.fromScale(0 / AbsoluteSize.X, 0 / AbsoluteSize.Y)
    end

    TweenService:Create(ImageLabel, v23, t8):Play()
    task.delay(v19, function() -- line: 167
        -- upvalues: ImageLabel2 (ref)
        ImageLabel2:Destroy()
    end)
end

local function ring(p17, p18, p19, p20, p21) -- line: 171
    -- upvalues: TweenService (copy), t2 (copy), v4 (ref)
    p21 = p21 or 1

    local Frame = Instance.new("Frame")

    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)

    local AbsoluteSize = v4.AbsoluteSize

    Frame.Position = UDim2.fromScale(p17.X / AbsoluteSize.X, p17.Y / AbsoluteSize.Y)

    local v25 = p18 * t2.RING[1] * p21
    local v26 = p18 * t2.RING[2] * p21
    local AbsoluteSize2 = v4.AbsoluteSize

    Frame.Size = UDim2.fromScale(v25 / AbsoluteSize2.X, v25 / AbsoluteSize2.Y)
    Frame.ZIndex = 21

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p19
    UIStroke.Thickness = math.max(2, p18 * 0.09 * p21)
    UIStroke.Transparency = 0.05
    UIStroke.Parent = Frame
    Frame.Parent = v4

    local v28 = TweenInfo.new(t2.RING_TIME, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, p20 or 0)
    local AbsoluteSize3 = v4.AbsoluteSize

    TweenService:Create(Frame, v28, {
        Size = UDim2.fromScale(v26 / AbsoluteSize3.X, v26 / AbsoluteSize3.Y)
    }):Play()
    TweenService:Create(UIStroke, v28, {
        Thickness = 0,
        Transparency = 1
    }):Play()
    task.delay(v28.Time + v28.DelayTime, function() -- line: 192
        -- upvalues: Frame (copy)
        Frame:Destroy()
    end)
end

local function itemOut(p22, p23, p24, p25, p26, p27, p28, p29, p30, p31) -- line: 198
    -- upvalues: TweenService (copy), t2 (copy), v2 (copy), v3 (copy), v4 (ref), n1 (ref)
    local v29 = p27
    local v30 = p28

    p27 = p27 or 1
    v29 = p27
    p28 = p28 or 1
    v30 = p28
    n1 = -n1

    local v33 = p23 * t2.KEY_W * p27
    local v34 = p23 * t2.KEY_H * p27
    local v37 = v33 * 0.47 * math.clamp(utf8.len(p30 or "+1") / 2, 1, t2.WORDS_MAX)
    local v38 = v37 + v33 * 0.53
    local Frame = Instance.new("Frame")

    Frame.Name = "KeyPop"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)

    local AbsoluteSize = v4.AbsoluteSize

    Frame.Size = UDim2.fromScale(v38 / AbsoluteSize.X, v34 / AbsoluteSize.Y)

    local AbsoluteSize2 = v4.AbsoluteSize

    Frame.Position = UDim2.fromScale(p22.X / AbsoluteSize2.X, p22.Y / AbsoluteSize2.Y)

    local v39

    if p31 then
        v39 = 0
    else
        local v40 = n1

        v39 = v40 * t2.KEY_TWIST
    end

    Frame.Rotation = v39
    Frame.ZIndex = 23

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0
    UIScale.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(1, 0.5)
    TextLabel.Position = UDim2.fromScale(v37 / v38, 0.5)
    TextLabel.Size = UDim2.fromScale(v37 / v38, 0.85)
    TextLabel.FontFace = v3
    TextLabel.Text = p30 or "+1"
    TextLabel.TextScaled = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel.TextColor3 = v2
    TextLabel.AutoLocalize = false
    TextLabel.ZIndex = 24

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p26
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke.Thickness = t2.WORDS_STROKE
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.Parent = TextLabel
    TextLabel.Parent = Frame

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.Position = UDim2.fromScale((v37 + v33 * 0.03) / v38, 0.5)
    ImageLabel.Size = UDim2.fromScale(v33 * 0.5 / v38, 1.15)
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Image = p24

    if p25 then
        ImageLabel.ImageRectOffset = Vector2.new(p25[1], p25[2])
        ImageLabel.ImageRectSize = Vector2.new(p25[3] - p25[1], p25[4] - p25[2])
    end

    ImageLabel.ZIndex = 24
    ImageLabel.Parent = Frame
    Frame.Parent = v4

    local v41 = p29 or p22 - Vector2.new(0, p23 * t2.KEY_OUT * p27)

    TweenService:Create(UIScale, t2.KEY_SPRING, {
        Scale = 1
    }):Play()

    local KEY_SPRING = t2.KEY_SPRING
    local t10 = {
        Rotation = 0
    }
    local AbsoluteSize3 = v4.AbsoluteSize

    t10.Position = UDim2.fromScale(v41.X / AbsoluteSize3.X, v41.Y / AbsoluteSize3.Y)
    TweenService:Create(Frame, KEY_SPRING, t10):Play()
    task.delay(t2.KEY_SPRING.Time + t2.KEY_HOLD * p28, function() -- line: 255
        -- upvalues: v29 (ref), v30 (ref), p23 (copy), Frame (copy), TextLabel (copy), UIStroke (copy), ImageLabel (copy), v41 (copy), TweenService (copy), t2 (copy), v4 (ref)
        if Frame.Parent then
            local v42 = TweenInfo.new(t2.KEY_FLOAT * v30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v43 = v41 - Vector2.new(0, p23 * t2.KEY_RISE * v29)
            local AbsoluteSize = v4.AbsoluteSize

            TweenService:Create(Frame, v42, {
                Position = UDim2.fromScale(v43.X / AbsoluteSize.X, v43.Y / AbsoluteSize.Y)
            }):Play()
            TweenService:Create(TextLabel, v42, {
                TextTransparency = 1
            }):Play()
            TweenService:Create(UIStroke, v42, {
                Transparency = 1
            }):Play()
            TweenService:Create(ImageLabel, v42, {
                ImageTransparency = 1
            }):Play()
            task.delay(v42.Time, function() -- line: 262
                -- upvalues: Frame (copy)
                Frame:Destroy()
            end)
        end
    end)
end

local function keyOut(p32, p33, p34, p35, p36, p37) -- line: 269
    -- upvalues: KeyConfig (copy), itemOut (copy)
    if type(p34) == "table" then
        if p34.image then
            itemOut(p32, p33, p34.image, nil, p35, p36, nil, nil, p34.text, p37)
        end
    else
        local v44 = KeyConfig.KEYS[p34]

        if v44 then
            itemOut(p32, p33, v44.image, v44.rect, p35, p36)
        end
    end
end

function t1.Pop(p38, p39, p40, p41, p42, p43) -- line: 281
    -- upvalues: TweenService (copy), RarityStyle (copy), ButtonHover (copy), t2 (copy), v2 (copy), v4 (ref), n1 (ref), play (copy), throw (copy), ring (copy), keyOut (copy)
    local ScreenGui = p38:FindFirstAncestorOfClass("ScreenGui")

    v4 = ScreenGui and ScreenGui:FindFirstChild("Fx") or v4

    if not (v4 and p38.Parent) then
        return
    end

    local v45 = select(3, p40:ToHSV()) < 0.15 and v2 or p40
    local X = p38.AbsoluteSize.X
    local v46 = p38.AbsolutePosition + p38.AbsoluteSize / 2 - v4.AbsolutePosition
    local HoverScale = p38:FindFirstChild("HoverScale")

    if HoverScale then
        local tween = TweenService:Create(HoverScale, t2.SLOT_UP, {
            Scale = t2.SLOT_POP
        })

        tween.Completed:Once(function() -- line: 291
            -- upvalues: p38 (copy), HoverScale (copy), TweenService (copy), ButtonHover (copy), t2 (copy)
            TweenService:Create(HoverScale, t2.SLOT_SETTLE, {
                Scale = ButtonHover.Rest(p38)
            }):Play()
        end)
        tween:Play()
    end

    if p39 and not p43 then
        local v47 = n1

        p39.Rotation = v47 * t2.ICON_KICK
        TweenService:Create(p39, t2.ICON_SETTLE, {
            Rotation = 0
        }):Play()
    end

    local UICorner = p38:FindFirstChildOfClass("UICorner")

    if UICorner then
        local Frame = Instance.new("Frame")

        Frame.Name = "ClaimFlash"
        Frame.BackgroundColor3 = v2
        Frame.BackgroundTransparency = t2.FLASH
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.ZIndex = 9
        UICorner:Clone().Parent = Frame
        Frame.Parent = p38
        TweenService:Create(Frame, t2.FLASH_TIME, {
            BackgroundTransparency = 1
        }):Play()
        task.delay(t2.FLASH_TIME.Time, function() -- line: 312
            -- upvalues: Frame (copy)
            Frame:Destroy()
        end)
    end

    for _ = 1, t2.STARS do
        throw(v46, X, true, v45)
    end

    for _ = 1, t2.SPARKS do
        throw(v46, X, false, v45)
    end

    ring(v46, X, v45)
    keyOut(v46, X, p41, RarityStyle.StrokeOf(v45), nil, p43)
    play("card", t2.PITCH[1] + (t2.PITCH[2] - t2.PITCH[1]) * math.clamp(p42 or 0, 0, 1))
end

function t1.Thump(p44) -- line: 323
    -- upvalues: TweenService (copy), t2 (copy), play (copy)
    if p44 then
        p44.Scale = t2.THUMP
        TweenService:Create(p44, t2.THUMP_TIME, {
            Scale = 1
        }):Play()
    end

    play("burst")
end

function t1.Rung(p45, p46, p47) -- line: 332
    -- upvalues: RarityStyle (copy), t2 (copy), v1 (copy), v2 (copy), v4 (ref), play (copy), throw (copy), ring (copy), itemOut (copy)
    local ScreenGui = p45:FindFirstAncestorOfClass("ScreenGui")

    v4 = ScreenGui and ScreenGui:FindFirstChild("Fx") or v4

    if not (v4 and p45.Parent) then
        return
    end

    local v51 = p47 or v1

    v51 = select(3, v51:ToHSV()) < 0.15 and v2 or v51

    local Y = p45.AbsoluteSize.Y
    local v52 = p45.AbsolutePosition + p45.AbsoluteSize / 2 - v4.AbsolutePosition

    for _ = 1, t2.RUNG_STARS do
        throw(v52, Y, true, v51, 1.8)
    end

    for _ = 1, t2.RUNG_SPARKS do
        throw(v52, Y, false, v51, 1.8)
    end

    ring(v52, Y, v51, 0, 2.2)
    ring(v52, Y, v2, 0.1, 1.6)

    if p46 then
        itemOut(v52, Y, p46, nil, RarityStyle.StrokeOf(v51), t2.RUNG_SCALE, t2.RUNG_SLOW, v52 + t2.RUNG_TO * Y)
    end

    play("burst")
    play("level")
end

return t1
