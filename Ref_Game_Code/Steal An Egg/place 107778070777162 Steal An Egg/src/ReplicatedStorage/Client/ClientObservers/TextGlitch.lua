-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObserveUITag = require(ReplicatedStorage.Client.ObserveUITag)

require(ReplicatedStorage.Packages.Trove)

local v1 = Color3.fromRGB(255, 242, 255)
local v2 = Color3.fromRGB(217, 166, 255)
local v3 = Color3.fromRGB(168, 85, 247)
local t1 = {
    Chromatic = {
        BurstIntervalMin = 1.2,
        BurstIntervalMax = 3.5,
        BurstDurationMin = 0.12,
        BurstDurationMax = 0.35,
        TickSeconds = 0.03,
        JitterX = 4,
        JitterY = 3,
        RotationJitter = 2,
        ScrambleChance = 0.65,
        MaxScrambledChars = 2,
        GhostName = "GlitchGhost",
        GhostOffset = 3,
        GhostTransparency = 0.25,
        MinimumZIndex = 2,
        FlickerChance = 0.12,
        StrokeFlashChance = 0.5,
        Tears = false,
        GlitchChars = {
            "#",
            "%",
            "&",
            "$",
            "@",
            "/",
            "\\",
            "0",
            "1",
            "7",
            "X",
            "?",
            "▓",
            "▒",
            "░"
        },
        GhostColors = {
            Color3.fromRGB(255, 0, 110),
            Color3.fromRGB(0, 225, 255)
        },
        StrokeFlashColors = {
            Color3.fromRGB(0, 229, 255),
            Color3.fromRGB(255, 238, 0),
            Color3.fromRGB(255, 0, 128)
        }
    },
    Rift = {
        BurstIntervalMin = 1.4,
        BurstIntervalMax = 4,
        BurstDurationMin = 0.14,
        BurstDurationMax = 0.4,
        TickSeconds = 0.03,
        JitterX = 4,
        JitterY = 3,
        RotationJitter = 2,
        ScrambleChance = 0.6,
        MaxScrambledChars = 2,
        GhostName = "RiftGhost",
        GhostOffset = 3,
        GhostTransparency = 0.3,
        MinimumZIndex = 3,
        FlickerChance = 0.1,
        StrokeFlashChance = 0.5,
        Tears = true,
        GlitchChars = {
            "◢",
            "◣",
            "◤",
            "◥",
            "▲",
            "▼",
            "◆",
            "▓",
            "▒",
            "░",
            "/",
            "\\",
            "X",
            "#",
            "%"
        },
        GhostColors = {
            Color3.fromRGB(240, 183, 255),
            Color3.fromRGB(191, 200, 255)
        },
        StrokeFlashColors = { v2, v3, v1 }
    }
}

local function CloneBareLabel(p1, p2) -- line: 139
    local clone = p1:Clone()

    clone:ClearAllChildren()

    for _, v4 in clone:GetTags() do
        clone:RemoveTag(v4)
    end

    clone.Name = p2
    clone.BackgroundTransparency = 1

    return clone
end

local function SplitCharacters(p3) -- line: 150
    if p3 == "" then
        return {}
    end

    return string.split(p3, "")
end

local function ScrambleText(p4) -- line: 157
    local BaseCharacters = p4.BaseCharacters
    local v5 = #BaseCharacters

    if v5 == 0 then
        return p4.BaseText
    end

    local v6 = table.clone(BaseCharacters)
    local Style, Random = p4.Style, p4.Random

    for _ = 1, Random:NextInteger(1, Style.MaxScrambledChars) do
        local v7 = Random:NextInteger(1, v5)

        if v6[v7] ~= " " then
            v6[v7] = Style.GlitchChars[Random:NextInteger(1, #Style.GlitchChars)]
        end
    end

    return table.concat(v6)
end

local function CreateGhosts(p5, p6) -- line: 175
    -- upvalues: CloneBareLabel (copy)
    local Label, Style = p5.Label, p5.Style

    for _, v8 in Style.GhostColors do
        local v9 = CloneBareLabel(Label, Style.GhostName)

        p6:Add(v9)
        v9.TextColor3 = v8
        v9.TextTransparency = 1
        v9.ZIndex = Label.ZIndex - 1
        v9.Parent = Label.Parent
        table.insert(p5.Ghosts, v9)
    end
end

local function CreateTear(p7, p8) -- line: 189
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), CloneBareLabel (copy)
    local Label = p7.Label
    local LabelParent, ZIndex = Label.Parent, Label.ZIndex
    local Frame = Instance.new("Frame")

    p8:Add(Frame)
    Frame.Name = "RiftTearTop"
    Frame.BackgroundTransparency = 1
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Label.AnchorPoint
    Frame.ZIndex = ZIndex
    Frame.Visible = false
    Frame.Parent = LabelParent

    local clone = Frame:Clone()

    p8:Add(clone)
    clone.Name = "RiftTearBottom"
    clone.Parent = LabelParent

    local Stroke = p7.Stroke
    local RiftTearTopText = CloneBareLabel(Label, "RiftTearTopText")
    local RiftTearBottomText = CloneBareLabel(Label, "RiftTearBottomText")

    for _, v10 in { RiftTearTopText, RiftTearBottomText } do
        if Stroke ~= nil then
            Stroke:Clone().Parent = v10
        end

        v10.AnchorPoint = Vector2.zero
        v10.ZIndex = ZIndex
    end

    RiftTearTopText.Position = UDim2.fromScale(0, 0)
    RiftTearTopText.Parent = Frame
    RiftTearBottomText.Parent = clone

    local Frame2 = Instance.new("Frame")

    p8:Add(Frame2)
    Frame2.Name = "RiftSeamGlow"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v3
    Frame2.BackgroundTransparency = 0.72
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.ZIndex = ZIndex + 1
    Frame2.Visible = false

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = Frame2
    Frame2.Parent = LabelParent

    local clone2 = Frame2:Clone()

    p8:Add(clone2)
    clone2.Name = "RiftSeamCore"
    clone2.BackgroundColor3 = v1
    clone2.BackgroundTransparency = 0.05
    clone2.ZIndex = ZIndex + 2
    clone2.Parent = LabelParent

    local v11 = table.create(7)

    for i = 1, 7 do
        local Frame = Instance.new("Frame")

        p8:Add(Frame)
        Frame.Name = "RiftShard"
        Frame.BorderSizePixel = 0

        if i % 2 == 0 then
            Frame.BackgroundColor3 = v2
        else
            Frame.BackgroundColor3 = v1
        end

        Frame.BackgroundTransparency = 1
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.ZIndex = ZIndex + 2

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 1)
        UICorner.Parent = Frame
        Frame.Parent = LabelParent
        table.insert(v11, Frame)
    end

    return {
        TopClip = Frame,
        BottomClip = clone,
        TopText = RiftTearTopText,
        BottomText = RiftTearBottomText,
        SeamGlow = Frame2,
        SeamCore = clone2,
        Shards = v11,
        BottomBase = UDim2.new(),
        SeamPosition = UDim2.new(),
        LabelWidth = UDim.new(),
        GlowColor = v3
    }
end

local function SetGhostTransparency(p9, p10) -- line: 282
    for _, v12 in p9.Ghosts do
        v12.TextTransparency = p10
    end
end

local function MoveGhosts(p11, p12, p13, p14, p15) -- line: 288
    local Style = p11.Style

    for v13, v14 in p11.Ghosts do
        local v15 = if v13 == 1 then 1 else -1

        v14.Text = p14
        v14.Rotation = p15
        v14.Position = p11.BasePosition + UDim2.fromOffset(p12 + v15 * Style.GhostOffset, p13 + v15 * math.ceil(Style.GhostOffset / 2))
    end
end

local function PrepareTear(p16, p17, p18) -- line: 303
    local Label = p16.Label
    local Size = Label.Size
    local BasePosition = p16.BasePosition
    local v18 = 1 - p18
    local v19 = UDim2.new(0, 0, Size.Y.Scale * p18, Size.Y.Offset * p18)
    local v20 = BasePosition + UDim2.new(Size.X.Scale * 0.5, Size.X.Offset * 0.5, 0, 0) + v19

    p17.TopClip.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * p18, Size.Y.Offset * p18)
    p17.TopText.Size = UDim2.fromScale(1, 1 / p18)
    p17.BottomClip.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * v18, Size.Y.Offset * v18)
    p17.BottomText.Size = UDim2.fromScale(1, 1 / v18)
    p17.BottomText.Position = UDim2.fromScale(0, -p18 / v18)
    p17.BottomBase = BasePosition + v19
    p17.SeamPosition = v20
    p17.LabelWidth = Size.X
    p17.SeamGlow.Position = v20
    p17.SeamGlow.Size = UDim2.new(Size.X.Scale * 1.1, Size.X.Offset * 1.1, 0, 10)
    p17.SeamCore.Position = v20
    Label.TextTransparency = 1
    p17.TopClip.Visible = true
    p17.BottomClip.Visible = true
    p17.SeamGlow.Visible = true
    p17.SeamCore.Visible = true
end

local function MoveTear(p19, p20, p21, p22, p23, p24) -- line: 333
    p20.TopClip.Position = p19.BasePosition + UDim2.fromOffset(p21, -p22)
    p20.TopClip.Rotation = p24
    p20.TopText.Text = p23
    p20.BottomClip.Position = p20.BottomBase + UDim2.fromOffset(-p21, p22)
    p20.BottomClip.Rotation = p24
    p20.BottomText.Text = p23
end

local function FlareSeam(p25, p26) -- line: 342
    -- upvalues: v2 (copy), v3 (copy)
    local v21 = if p26 > 0.5 then v2 else v3

    p25.SeamGlow.BackgroundTransparency = (1 - p26) * 0.25 + 0.6

    if v21 ~= p25.GlowColor then
        p25.GlowColor = v21
        p25.SeamGlow.BackgroundColor3 = v21
    end

    local LabelWidth = p25.LabelWidth

    p25.SeamCore.Size = UDim2.new(LabelWidth.Scale * (p26 * 0.3 + 0.75), LabelWidth.Offset, 0, 2)
end

local function ShowShards(p27, p28, p29) -- line: 353
    local SeamPosition = p28.SeamPosition

    for v22, v23 in p28.Shards do
        local v24 = v22 * 7919 % 97 / 97
        local v25 = if v22 % 2 == 0 then 1 else -1
        local v26 = p27.Random:NextInteger(3, 9)

        v23.Size = UDim2.fromOffset(v26, v26)
        v23.Rotation = v24 * 360 + p29 * 180 * v25
        v23.Position = SeamPosition + UDim2.fromOffset((v24 - 0.5) * 2 * 34 * p29, v25 * 22 * p29 * (v24 * 0.6 + 0.4))
        v23.BackgroundTransparency = math.clamp(p29, 0, 1)
    end
end

local function HideTear(p30) -- line: 371
    p30.TopClip.Visible = false
    p30.BottomClip.Visible = false
    p30.SeamGlow.Visible = false
    p30.SeamCore.Visible = false

    for _, v27 in p30.Shards do
        v27.BackgroundTransparency = 1
    end
end

local function RestoreLabel(p31) -- line: 381
    local Label, Stroke, Gradient = p31.Label, p31.Stroke, p31.Gradient

    Label.Text = p31.BaseText
    Label.Position = p31.BasePosition
    Label.Rotation = p31.BaseRotation
    Label.TextTransparency = p31.BaseTransparency

    if Stroke ~= nil then
        Stroke.Color = p31.BaseStrokeColor
    end

    if Gradient ~= nil then
        Gradient.Offset = p31.BaseGradientOffset
    end
end

local function AdoptCaption(p32) -- line: 398
    local Text = p32.Label.Text

    if Text == p32.BaseText then
        return
    end

    p32.BaseText = Text

    if Text == "" then
        p32.BaseCharacters = {}
    else
        p32.BaseCharacters = string.split(Text, "")
    end
end

local function RunBurst(p33) -- line: 406
    -- upvalues: ScrambleText (copy), MoveGhosts (copy), PrepareTear (copy), MoveTear (copy), FlareSeam (copy), ShowShards (copy)
    local Label, Style, Random, Tear = p33.Label, p33.Style, p33.Random, p33.Tear
    local Stroke, Gradient = p33.Stroke, p33.Gradient
    local v28 = Random:NextNumber(Style.BurstDurationMin, Style.BurstDurationMax)
    local v29 = Random:NextNumber(0.38, 0.62)
    local Text = p33.Label.Text

    if Text ~= p33.BaseText then
        p33.BaseText = Text

        if Text == "" then
            p33.BaseCharacters = {}
        else
            p33.BaseCharacters = string.split(Text, "")
        end
    end

    p33.IsBursting = true

    if Tear ~= nil then
        PrepareTear(p33, Tear, v29)
    end

    local GhostTransparency = Style.GhostTransparency
    local n1 = 0

    for _, v30 in p33.Ghosts do
        v30.TextTransparency = GhostTransparency
    end

    while n1 < v28 do
        if p33.IsRunning then
            local v32 = math.clamp(n1 / v28, 0, 1)
            local v33 = Random:NextInteger(-Style.JitterX, Style.JitterX)
            local v34 = Random:NextInteger(-Style.JitterY, Style.JitterY)
            local v35 = p33.BaseRotation + Random:NextNumber(-Style.RotationJitter, Style.RotationJitter)
            local v36 = if Random:NextNumber() < Style.ScrambleChance then ScrambleText(p33) else p33.BaseText

            Label.Position = p33.BasePosition + UDim2.fromOffset(v33, v34)
            Label.Rotation = v35
            Label.Text = v36

            if Tear ~= nil then
                MoveTear(p33, Tear, Random:NextInteger(3, 12), Random:NextInteger(0, 5), v36, v35)
                FlareSeam(Tear, Random:NextNumber())
            elseif Random:NextNumber() < Style.FlickerChance then
                Label.TextTransparency = 1
            else
                Label.TextTransparency = p33.BaseTransparency
            end

            if Stroke ~= nil then
                if Random:NextNumber() < Style.StrokeFlashChance then
                    Stroke.Color = Style.StrokeFlashColors[Random:NextInteger(1, #Style.StrokeFlashColors)]
                else
                    Stroke.Color = p33.BaseStrokeColor
                end
            end

            if Gradient ~= nil then
                Gradient.Offset = Vector2.new(Random:NextNumber(-0.5, 0.5), 0)
            end

            MoveGhosts(p33, v33, v34, v36, v35)

            if Tear ~= nil then
                ShowShards(p33, Tear, v32)
            end

            n1 += task.wait(Style.TickSeconds)
            continue
        end

        return
    end

    if p33.IsRunning then
        local Label, Stroke, Gradient = p33.Label, p33.Stroke, p33.Gradient

        Label.Text = p33.BaseText
        Label.Position = p33.BasePosition
        Label.Rotation = p33.BaseRotation
        Label.TextTransparency = p33.BaseTransparency

        if Stroke ~= nil then
            Stroke.Color = p33.BaseStrokeColor
        end

        if Gradient ~= nil then
            Gradient.Offset = p33.BaseGradientOffset
        end

        for _, v39 in p33.Ghosts do
            v39.TextTransparency = 1
        end

        if Tear ~= nil then
            Tear.TopClip.Visible = false
            Tear.BottomClip.Visible = false
            Tear.SeamGlow.Visible = false
            Tear.SeamCore.Visible = false

            for _, v40 in Tear.Shards do
                v40.BackgroundTransparency = 1
            end
        end

        p33.IsBursting = false
    end
end

local function StartGlitch(p34, p35) -- line: 474
    -- upvalues: t1 (copy), CreateGhosts (copy), CreateTear (copy), RunBurst (copy)
    local GlitchStyle = p34:GetAttribute("GlitchStyle")
    local v42 = t1[if type(GlitchStyle) == "string" then GlitchStyle else "Chromatic"]

    if v42 ~= nil then
        local UIStroke = p34:FindFirstChildOfClass("UIStroke")
        local UIGradient = p34:FindFirstChildOfClass("UIGradient")
        local ZIndex = p34.ZIndex

        p34.ZIndex = math.max(ZIndex, v42.MinimumZIndex)

        local t2 = {
            Tear = nil,
            IsBursting = false,
            IsRunning = true,
            Label = p34,
            Style = v42,
            Random = Random.new(),
            BaseText = p34.Text
        }
        local Text = p34.Text

        t2.BaseCharacters = if Text == "" then {} else string.split(Text, "")
        t2.BasePosition = p34.Position
        t2.BaseRotation = p34.Rotation
        t2.BaseTransparency = p34.TextTransparency
        t2.Stroke = UIStroke
        t2.BaseStrokeColor = if UIStroke == nil then Color3.new() else UIStroke.Color
        t2.Gradient = UIGradient
        t2.BaseGradientOffset = if UIGradient == nil then Vector2.zero else UIGradient.Offset
        t2.Ghosts = {}
        p35:Add(function() -- line: 505
            -- upvalues: p34 (copy), ZIndex (copy), t2 (copy)
            t2.IsRunning = false

            if t2.IsBursting then
                local Label, Stroke, Gradient = t2.Label, t2.Stroke, t2.Gradient

                Label.Text = t2.BaseText
                Label.Position = t2.BasePosition
                Label.Rotation = t2.BaseRotation
                Label.TextTransparency = t2.BaseTransparency

                if Stroke ~= nil then
                    Stroke.Color = t2.BaseStrokeColor
                end

                if Gradient ~= nil then
                    Gradient.Offset = t2.BaseGradientOffset
                end
            end

            p34.ZIndex = ZIndex
        end)

        if v42.Tears then
            t2.Tear = CreateTear(t2, p35)
        end

        CreateGhosts(t2, p35)
        task.spawn(function() -- line: 518
            -- upvalues: v42 (copy), t2 (copy), RunBurst (copy)
            while true do
                if t2.IsRunning then
                    task.wait(t2.Random:NextNumber(v42.BurstIntervalMin, v42.BurstIntervalMax))

                    if t2.IsRunning then
                        RunBurst(t2)
                        continue
                    end
                end

                break
            end
        end)
    else
        warn((("%* has an unknown GlitchStyle %*"):format(p34:GetFullName(), GlitchStyle)))
    end
end

ObserveUITag("TextGlitch", function(p36, p37) -- PlayGlitch | line: 529
    -- upvalues: StartGlitch (copy)
    if p36:IsA("TextLabel") then
        StartGlitch(p36, p37)
    else
        warn((("TextGlitch tag on %* needs a TextLabel"):format((p36:GetFullName()))))
    end
end)

return nil
