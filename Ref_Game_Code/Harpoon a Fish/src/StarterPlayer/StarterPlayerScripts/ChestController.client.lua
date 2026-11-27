-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChestConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ChestConfig"))
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Plots = workspace:WaitForChild("Plots")
local t1 = {
    HEIGHT = 1.9,
    TALL = 1.6,
    TITLE = 0.38,
    FROM = 0.4,
    IN_TIME = 0.2,
    OUT_TIME = 0.12,
    ABOVE = 1.3,
    EVERY = 0.1,
    STROKE = Color3.fromRGB(5, 54, 94),
    FADE = Color3.fromRGB(205, 241, 254),
    FONT = Font.new("rbxasset://fonts/families/FredokaOne.json")
}
local _ = {
    TRANS = 0.15,
    LIGHT = 2.5
}
local _ = {
    id = "rbxassetid://76357092271646",
    volume = 0.6
}

local function ease(p1, p2, p3) -- line: 48
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p3, 0, 1), p1, p2)
end

local function spring(p4) -- line: 53
    -- upvalues: ChestConfig (copy)
    if p4 <= 0 then
        return 0
    end

    local SPRING_FREQ, SPRING_DAMP = ChestConfig.TEASE.SPRING_FREQ, ChestConfig.TEASE.SPRING_DAMP
    local v2 = SPRING_FREQ * math.sqrt(1 - SPRING_DAMP * SPRING_DAMP)

    return 1 - math.exp(-SPRING_DAMP * SPRING_FREQ * p4) * (math.cos(v2 * p4) + SPRING_DAMP * SPRING_FREQ / v2 * math.sin(v2 * p4))
end

local function jolt(p5, p6) -- line: 61
    -- upvalues: ChestConfig (copy)
    if p5 <= 0 then
        return 0
    end

    return p6 * math.exp(-ChestConfig.TEASE.DECAY * p5) * math.sin(ChestConfig.TEASE.FREQ * p5)
end

local t2 = {}

local function ownerOf(p7) -- line: 68
    -- upvalues: Players (copy)
    local Parent = p7.Parent
    local OwnerUserId = Parent and Parent:GetAttribute("OwnerUserId")
    local PlayerByUserId, v12

    if not OwnerUserId or OwnerUserId == 0 then
        v12 = false
    else
        local PlayerByUserId2 = Players:GetPlayerByUserId(OwnerUserId)

        if PlayerByUserId2 then
            PlayerByUserId = PlayerByUserId2
            v12 = true
        else
            v12 = false
        end
    end

    if not v12 then
        PlayerByUserId = nil
    end

    return PlayerByUserId
end

local function topOf(p8) -- line: 74
    local BoundingBox, BoundingBox2 = p8:GetBoundingBox()

    return BoundingBox.Position.Y + BoundingBox2.Y / 2
end

local function makeIcon(p9, p10) -- line: 80
    local Part = Instance.new("Part")

    Part.Name = "ChestRewardIcon"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.Position = p9

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(0, 0)
    BillboardGui.LightInfluence = 0
    BillboardGui.Parent = Part

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = p10.image
    ImageLabel.ImageRectOffset = Vector2.new(p10.rect[1], p10.rect[2])
    ImageLabel.ImageRectSize = Vector2.new(p10.rect[3] - p10.rect[1], p10.rect[4] - p10.rect[2])
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Parent = BillboardGui
    Part.Parent = workspace

    return Part, BillboardGui
end

local function playOpen(p11) -- line: 103
    -- upvalues: Players (copy), RunService (copy), TweenService (copy), ChestConfig (copy), LocalPlayer (copy), ease (copy), spring (copy), t2 (copy), makeIcon (copy)
    local v13 = t2[p11]
    local Lid = p11:FindFirstChild("Lid")
    local Base = p11:FindFirstChild("Base")
    local Glow = p11:FindFirstChild("Glow")
    local Light, v14

    if not v13 or v13.playing then
        v14 = true
    elseif Lid and Base then
        v13.playing = true
        Light = Glow and Glow:FindFirstChild("Light")
        v14 = false
    else
        v14 = true
    end

    if v14 then
        return
    end

    local t3 = {}

    if Glow then
        for _, child in ipairs(Glow:GetChildren()) do
            if child:IsA("ParticleEmitter") then
                t3[#t3 + 1] = child
            end
        end
    end

    local function sound(p12) -- line: 113
        -- upvalues: Base (copy)
        local v15 = Base:FindFirstChild(p12)

        if v15 then
            v15:Play()
        end
    end

    v13.teasing = false
    p11:PivotTo(v13.rest)

    local rest, lidRel = v13.rest, v13.lidRel
    local Parent = p11.Parent
    local OwnerUserId = Parent and Parent:GetAttribute("OwnerUserId")
    local PlayerByUserId, v16

    if not OwnerUserId or OwnerUserId == 0 then
        v16 = false
    else
        local PlayerByUserId2 = Players:GetPlayerByUserId(OwnerUserId)

        if PlayerByUserId2 then
            PlayerByUserId = PlayerByUserId2
            v16 = true
        else
            v16 = false
        end
    end

    if not v16 then
        PlayerByUserId = nil
    end

    local Position = if Glow then Glow.Position else nil

    if not Glow or not Position then
        Position = Base.Position
    end

    local X = Position.X
    local BoundingBox, BoundingBox2 = p11:GetBoundingBox()
    local v18 = Vector3.new(X, BoundingBox.Position.Y + BoundingBox2.Y / 2 + ChestConfig.RISE, Position.Z)
    local v19, v20
    local v21 = false
    local v22 = false
    local t4 = {}

    t4[1] = nil

    local elapsed = os.clock()
    local OpenSound = Base:FindFirstChild("OpenSound")

    if OpenSound then
        OpenSound:Play()
    end

    local BurstSound = Base:FindFirstChild("BurstSound")

    if BurstSound then
        BurstSound:Play()
    end

    if Light then
        Light.Enabled = true
    end

    for _, v23 in ipairs(t3) do
        v23.Enabled = true
    end

    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 132
        -- upvalues: p11 (copy), v13 (copy), Lid (copy), Base (copy), Glow (copy), t3 (copy), rest (copy), lidRel (copy), Position (ref), v18 (copy), v19 (ref), v20 (ref), v21 (ref), v22 (ref), t4 (copy), elapsed (copy), connection (ref), Light (ref), PlayerByUserId (ref), TweenService (copy), ChestConfig (copy), LocalPlayer (copy), ease (copy), spring (copy), makeIcon (copy)
        local v24 = os.clock() - elapsed
        local v25

        if v24 < ChestConfig.FLY_AT then
            v25 = ChestConfig.OPEN_ANGLE * spring(v24)
        else
            local OPEN_ANGLE = ChestConfig.OPEN_ANGLE
            local Quad = Enum.EasingStyle.Quad
            local In = Enum.EasingDirection.In

            v25 = OPEN_ANGLE * (1 - TweenService:GetValue(math.clamp((v24 - ChestConfig.FLY_AT) / ChestConfig.CLOSE_TIME, 0, 1), Quad, In))
        end

        local v27 = ChestConfig.TEASE.KICK_MAX * ChestConfig.TEASE.ROCK
        local v28 = if v24 <= 0 then 0 else v27 * math.exp(-ChestConfig.TEASE.DECAY * v24) * math.sin(ChestConfig.TEASE.FREQ * v24)
        local v32 = v24 - ChestConfig.FLY_AT - ChestConfig.CLOSE_TIME
        local v33 = ChestConfig.TEASE.KICK_MIN * ChestConfig.TEASE.ROCK
        local v38 = v28 + (if v32 <= 0 then 0 else v33 * math.exp(-ChestConfig.TEASE.DECAY * v32) * math.sin(ChestConfig.TEASE.FREQ * v32))
        local v39 = rest * CFrame.Angles(0, 0, (math.rad(v38)))

        if p11.Parent then
            p11:PivotTo(v39)
        end

        if Lid.Parent then
            Lid:PivotTo(v39 * lidRel * CFrame.Angles(math.rad(v25), 0, 0))
        end

        local v40

        if v24 < ChestConfig.FLY_AT then
            local Quad = Enum.EasingStyle.Quad
            local Out = Enum.EasingDirection.Out

            v40 = TweenService:GetValue(math.clamp(v24 / ChestConfig.OPEN_TIME, 0, 1), Quad, Out)
        else
            local Quad = Enum.EasingStyle.Quad
            local Out = Enum.EasingDirection.Out

            v40 = 1 - TweenService:GetValue(math.clamp((v24 - ChestConfig.FLY_AT) / ChestConfig.CLOSE_TIME, 0, 1), Quad, Out)
        end

        if Glow then
            Glow.Transparency = 1 - 0.85 * v40
        end

        if Light then
            Light.Brightness = 2.5 * v40
        end

        if not v21 and ChestConfig.POP_AT <= v24 then
            v21 = true

            local PopSound = Base:FindFirstChild("PopSound")

            if PopSound then
                PopSound:Play()
            end

            v19, v20 = makeIcon(Position, ChestConfig.BY_ID[p11:GetAttribute("Reward")] or ChestConfig.BY_ID.XP)
        end

        if v19 and v24 < ChestConfig.FLY_AT then
            local v43 = (v24 - ChestConfig.POP_AT) / ChestConfig.RISE_TIME
            local Back = Enum.EasingStyle.Back
            local Out = Enum.EasingDirection.Out
            local Value = TweenService:GetValue(math.clamp(v43, 0, 1), Back, Out)
            local v44 = v43 >= 1 and math.sin((v24 - ChestConfig.POP_AT - ChestConfig.RISE_TIME) * 5) * 0.15 or 0

            v19.Position = Position:Lerp(v18, (math.min(Value, 1.15))) + Vector3.new(0, v44, 0)

            local ICON_SIZE = ChestConfig.ICON_SIZE
            local Back2 = Enum.EasingStyle.Back
            local Out2 = Enum.EasingDirection.Out
            local v47 = ICON_SIZE * TweenService:GetValue(math.clamp(v43, 0, 1), Back2, Out2)

            v20.Size = UDim2.fromScale(v47, v47)
        end

        if not v22 and ChestConfig.FLY_AT <= v24 then
            v22 = true

            local CloseSound = Base:FindFirstChild("CloseSound")

            if CloseSound then
                CloseSound:Play()
            end

            for _, v49 in ipairs(t3) do
                v49.Enabled = false
            end

            if v19 then
                t4[1] = v19.Position
            end

            local v50 = ChestConfig.BY_ID[p11:GetAttribute("Reward")]

            if PlayerByUserId == LocalPlayer and v50 and v50.xp then
                LocalPlayer:SetAttribute("XPPeek", os.clock())
            end
        end

        if v19 and ChestConfig.FLY_AT <= v24 then
            local v52 = math.clamp((v24 - ChestConfig.FLY_AT) / ChestConfig.FLY_TIME, 0, 1)
            local v53 = PlayerByUserId and PlayerByUserId.Character
            local HumanoidRootPart = v53 and v53:FindFirstChild("HumanoidRootPart")
            local Position = HumanoidRootPart and HumanoidRootPart.Position or t4[1] + Vector3.new(0, 12, 0)

            v19.Position = t4[1]:Lerp(Position, ease(Enum.EasingStyle.Quad, Enum.EasingDirection.In, v52))

            local ICON_SIZE = ChestConfig.ICON_SIZE
            local Quad = Enum.EasingStyle.Quad
            local In = Enum.EasingDirection.In
            local v55 = ICON_SIZE * (1 - 0.7 * TweenService:GetValue(math.clamp(v52, 0, 1), Quad, In))

            v20.Size = UDim2.fromScale(v55, v55)

            if v52 >= 1 then
                v19:Destroy()
                v19 = nil
            end
        end

        if not (math.max(ChestConfig.TOTAL, ChestConfig.FLY_AT + ChestConfig.CLOSE_TIME) <= v24) or v19 then
            return
        else
            connection:Disconnect()

            if p11.Parent then
                p11:PivotTo(rest)
            end
        end

        if Lid.Parent then
            Lid:PivotTo(rest * lidRel)
        end

        if Glow then
            Glow.Transparency = 1
        end

        if Light then
            Light.Brightness = 0
            Light.Enabled = false
        end

        v13.playing = false
    end)
end

local BillboardGui = Instance.new("BillboardGui")

BillboardGui.Name = "ChestTimer"
BillboardGui.Size = UDim2.fromScale(t1.HEIGHT * 3.2, t1.HEIGHT * t1.TALL)
BillboardGui.LightInfluence = 0
BillboardGui.Enabled = false
BillboardGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")

Frame.Name = "Card"
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.fromScale(0.5, 0.5)
Frame.Size = UDim2.fromScale(1, 1)
Frame.BackgroundTransparency = 1
Frame.Parent = BillboardGui

local UIScale = Instance.new("UIScale")

UIScale.Parent = Frame

local t5 = {}

local function line(p13, p14, p15, p16) -- line: 227
    -- upvalues: t1 (copy), Frame (copy), t5 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p13
    TextLabel.Position = UDim2.fromScale(0, p15)
    TextLabel.Size = UDim2.fromScale(1, p16)
    TextLabel.BackgroundTransparency = 1
    TextLabel.FontFace = t1.FONT
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Text = p14

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t1.STROKE
    UIStroke.Thickness = 0.09
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.Parent = TextLabel

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.4, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, t1.FADE)
    })
    UIGradient.Parent = TextLabel
    TextLabel.Parent = Frame
    t5[#t5 + 1] = {
        label = TextLabel,
        stroke = UIStroke
    }

    return TextLabel
end

line("Title", "Reward in:", 0, t1.TITLE)

local v59 = line("Time", "", t1.TITLE, 1 - t1.TITLE)

BillboardGui.Parent = PlayerGui

local v60 = TweenInfo.new(t1.IN_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v61 = TweenInfo.new(t1.IN_TIME * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v62 = TweenInfo.new(t1.OUT_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v63 = false
local t6 = {}
local v64 = Vector3.new(0, 0, 0)
local v65 = Vector3.new(0, 0, 0)

local function show(p17) -- line: 261
    -- upvalues: TweenService (copy), t1 (copy), BillboardGui (copy), UIScale (copy), t5 (copy), v60 (copy), v61 (copy), v62 (copy), v63 (ref), t6 (copy), v64 (ref), v65 (ref)
    if p17 == v63 then
        return
    end

    v63 = p17

    for _, v66 in ipairs(t6) do
        v66:Cancel()
    end

    table.clear(t6)

    local function fade(p18, p19) -- line: 266
        -- upvalues: TweenService (copy), t5 (copy), t6 (copy)
        for _, v67 in ipairs(t5) do
            t6[#t6 + 1] = TweenService:Create(v67.label, p19, {
                TextTransparency = p18
            })
            t6[#t6 + 1] = TweenService:Create(v67.stroke, p19, {
                Transparency = p18
            })
        end
    end

    if p17 then
        UIScale.Scale = t1.FROM

        for _, v68 in ipairs(t5) do
            v68.label.TextTransparency = 1
            v68.stroke.Transparency = 1
        end

        BillboardGui.StudsOffsetWorldSpace = v65
        BillboardGui.Enabled = true
        t6[#t6 + 1] = TweenService:Create(UIScale, v60, {
            Scale = 1
        })
        t6[#t6 + 1] = TweenService:Create(BillboardGui, v60, {
            StudsOffsetWorldSpace = v64
        })
        fade(0, v61)
    else
        local tween = TweenService:Create(UIScale, v62, {
            Scale = 0
        })

        tween.Completed:Once(function(p20) -- line: 282
            -- upvalues: BillboardGui (copy), v63 (ref)
            if p20 == Enum.PlaybackState.Completed and not v63 then
                BillboardGui.Enabled = false
            end
        end)
        t6[#t6 + 1] = tween
        t6[#t6 + 1] = TweenService:Create(BillboardGui, v62, {
            StudsOffsetWorldSpace = v65
        })
        fade(1, v62)
    end

    for _, v69 in ipairs(t6) do
        v69:Play()
    end
end

local function myChest() -- line: 292
    -- upvalues: LocalPlayer (copy), Plots (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child:FindFirstChild("Chest")
        end
    end

    return nil
end

task.spawn(function() -- line: 299
    -- upvalues: t1 (copy), BillboardGui (copy), v59 (copy), v63 (ref), v64 (ref), v65 (ref), show (copy), myChest (copy)
    while true do
        task.wait(t1.EVERY)

        local v70 = myChest()
        local EndsAt = v70 and v70:GetAttribute("EndsAt")

        if type(EndsAt) == "number" and v70:FindFirstChild("Base") then
            local v73 = math.max(0, (math.ceil(EndsAt - workspace:GetServerTimeNow())))

            v59.Text = string.format("%d:%02d", v73 // 60, v73 % 60)

            if BillboardGui.Adornee ~= v70.Base then
                BillboardGui.Adornee = v70.Base

                local BoundingBox, BoundingBox2 = v70:GetBoundingBox()
                local v74 = BoundingBox.Position.Y + BoundingBox2.Y / 2 - v70.Base.Position.Y

                v64 = Vector3.new(0, v74 + t1.ABOVE + t1.HEIGHT * t1.TALL / 2, 0)
                v65 = Vector3.new(0, v74, 0)

                if not v63 then
                    BillboardGui.StudsOffsetWorldSpace = v65
                end
            end

            show(true)
            continue
        end

        show(false)
    end
end)

local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local TEASE = ChestConfig.TEASE
local t7 = {}

for v76, v77 in pairs({
        knock1 = TEASE.KNOCK_1,
        knock2 = TEASE.KNOCK_2,
        knock3 = TEASE.KNOCK_3
    }) do
    local Sound = Instance.new("Sound")

    Sound.SoundId = v77
    Sound.RollOffMinDistance = 10
    Sound.RollOffMaxDistance = 90
    Sound.Parent = SoundService
    t7[v76] = Sound
end

task.spawn(function() -- line: 335
    -- upvalues: t7 (copy)
    local function v78() -- line: 336
        -- upvalues: t7 (copy)
        local t8 = {}

        for _, v79 in pairs(t7) do
            t8[#t8 + 1] = v79
        end

        game:GetService("ContentProvider"):PreloadAsync(t8)
    end

    pcall(v78)
end)

local function oneShot(p21, p22, p23, p24) -- line: 342
    -- upvalues: Debris (copy)
    local clone = p21:Clone()

    clone.Volume = p22
    clone.PlaybackSpeed = p23 or 1
    clone.Parent = p24
    clone:Play()
    Debris:AddItem(clone, 6)
end

local function holdJolt(p25, p26) -- line: 352
    if p25 <= 0 or p25 >= 0.725 then
        return 0
    end

    if p25 < 0.1 then
        local v80 = p25 / 0.1

        return p26 * 1.15 * (v80 * v80 * (3 - 2 * v80))
    end

    if p25 < 0.5 then
        local v81 = (p25 - 0.1) / 0.4

        return p26 * (1.15 - 0.15 * (v81 * v81 * (3 - 2 * v81))) * (1 + math.sin(30 * p25) * 0.05 * (1 - v81))
    end

    if p25 < 0.7 then
        local v84 = (p25 - 0.5) / 0.2

        return p26 * (1 - 0.2 * (v84 * v84 * (3 - 2 * v84)))
    end

    local v85 = (p25 - 0.7) / 0.025

    return p26 * 0.8 * (1 - v85 * v85)
end

local function buildKnocks(p27, p28) -- line: 370
    -- upvalues: TEASE (copy)
    local v86 = p27 - TEASE.WINDOW
    local v87 = p27 - TEASE.BREATH - 0.45
    local t9 = {}
    local v88 = math.max(v86, p28) + math.random() * 0.3

    while v88 < v87 do
        local v89 = (v88 - v86) / (v87 - v86)
        local v90 = math.random()
        local v91 = 0.15 + 0.2 * v89

        t9[#t9 + 1] = {
            played = false,
            t = v88,
            kind = if v90 < v91 then 3 elseif not (v90 < v91 + (1 - v91) * 0.4 and v88 < v87 - 0.5) then 1 else 2,
            vol = TEASE.VOL[1] + (TEASE.VOL[2] - TEASE.VOL[1]) * v89,
            glints = math.floor(TEASE.GLINTS[1] + (TEASE.GLINTS[2] - TEASE.GLINTS[1]) * v89 + 0.5),
            kick = TEASE.KICK_MIN + (TEASE.KICK_MAX - TEASE.KICK_MIN) * v89,
            side = math.random() < 0.5 and -1 or 1,
            pitch = 0.9 + math.random() * 0.25
        }
        v88 += math.max((TEASE.GAP[1] + (TEASE.GAP[2] - TEASE.GAP[1]) * v89 ^ TEASE.GAP_CURVE) * (0.75 + math.random() * 0.5), 0.3)
    end

    return t9
end

RunService.RenderStepped:Connect(function() -- line: 392
    -- upvalues: ChestConfig (copy), t2 (copy), Debris (copy), TEASE (copy), t7 (copy), holdJolt (copy), buildKnocks (copy)
    local v95

    for v96, v97 in pairs(t2) do
        local EndsAt = v96:GetAttribute("EndsAt")
        local Base = v96:FindFirstChild("Base")
        local Lid = v96:FindFirstChild("Lid")

        if not v97.playing and Base and Lid then
            v95 = v95 or workspace:GetServerTimeNow()

            local v98 = type(EndsAt) == "number" and EndsAt - v95 or 1e999

            if v98 <= TEASE.WINDOW and v98 > 0 then
                if v97.knocksFor ~= EndsAt then
                    v97.knocksFor = EndsAt
                    v97.knocks = buildKnocks(EndsAt, v95)
                end

                local n1 = 0
                local n2 = 0

                for _, v99 in ipairs(v97.knocks) do
                    if not v99.played and v99.t <= v95 then
                        v99.played = true

                        if v95 < v99.t + 0.3 then
                            local knock3 = v99.kind == 3 and t7.knock3 or v99.kind == 2 and t7.knock2 or t7.knock1
                            local vol, pitch = v99.vol, v99.pitch
                            local clone = knock3:Clone()

                            clone.Volume = vol
                            clone.PlaybackSpeed = pitch or 1
                            clone.Parent = Base
                            clone:Play()
                            Debris:AddItem(clone, 6)

                            local v100 = v96:FindFirstChild("Glow") and v96.Glow:FindFirstChild("Glints")

                            if v100 then
                                v100:Emit(v99.kind == 3 and v99.glints * 2 or v99.glints)
                            end
                        end
                    end

                    local v101 = v95 - v99.t
                    local v102

                    if v101 <= 0 or v101 >= 1 then
                        v102 = 0
                    elseif v99.kind == 2 then
                        v102 = holdJolt(v101 * v99.pitch, v99.kick)
                    elseif v99.kind == 3 then
                        local v103 = v99.kick * TEASE.HARD

                        v102 = if v101 <= 0 then 0 else v103 * math.exp(-ChestConfig.TEASE.DECAY * v101) * math.sin(ChestConfig.TEASE.FREQ * v101)
                    else
                        local kick = v99.kick

                        v102 = if v101 <= 0 then 0 else kick * math.exp(-ChestConfig.TEASE.DECAY * v101) * math.sin(ChestConfig.TEASE.FREQ * v101)
                    end

                    n1 += v102
                    n2 += v99.side * v102 * TEASE.ROCK
                end

                local v110 = n1 ~= 0 or n2 ~= 0

                if v110 or v97.moved then
                    local v111 = v97.rest * CFrame.Angles(0, 0, (math.rad(n2)))

                    v96:PivotTo(v111)
                    Lid:PivotTo(v111 * v97.lidRel * CFrame.Angles(math.rad((math.max(n1, 0))), 0, 0))

                    local Glow = v96:FindFirstChild("Glow")

                    if Glow then
                        local v115 = math.clamp(n1 / TEASE.CRACK_FULL, 0, 1)

                        Glow.Transparency = 1 - 0.85 * v115

                        local Light = Glow:FindFirstChild("Light")

                        if Light then
                            Light.Enabled = v115 > 0
                            Light.Brightness = 2.5 * TEASE.CRACK_LIGHT * v115
                        end
                    end
                end

                v97.moved = v110
                v97.teasing = true
            elseif v97.teasing then
                v97.teasing = false
                v96:PivotTo(v97.rest)
                Lid:PivotTo(v97.rest * v97.lidRel)

                local Glow = v96:FindFirstChild("Glow")

                if Glow then
                    Glow.Transparency = 1

                    local Light = Glow:FindFirstChild("Light")

                    if Light then
                        Light.Enabled = false
                        Light.Brightness = 0
                    end
                end
            end
        end
    end
end)

local function register(p29) -- line: 466
    -- upvalues: t2 (copy), playOpen (copy)
    if not t2[p29] and p29:IsA("Model") and p29.Name == "Chest" then
        local v116 = p29:WaitForChild("Lid", 10)

        if not v116 then
            return
        end

        local Pivot = p29:GetPivot()

        t2[p29] = {
            playing = false,
            teasing = false,
            rest = Pivot,
            lidRel = Pivot:Inverse() * v116:GetPivot()
        }

        local Base = p29:FindFirstChild("Base")

        if Base and not Base:FindFirstChild("BurstSound") then
            local Sound = Instance.new("Sound")

            Sound.Name = "BurstSound"
            Sound.SoundId = "rbxassetid://76357092271646"
            Sound.Volume = 0.6

            local OpenSound = Base:FindFirstChild("OpenSound")

            if OpenSound and OpenSound:IsA("Sound") then
                local RollOffMinDistance, RollOffMaxDistance = OpenSound.RollOffMinDistance, OpenSound.RollOffMaxDistance

                Sound.RollOffMinDistance = RollOffMinDistance
                Sound.RollOffMaxDistance = RollOffMaxDistance
            end

            Sound.Parent = Base
        end

        p29:GetAttributeChangedSignal("OpenedAt"):Connect(function() -- line: 481
            -- upvalues: p29 (copy), playOpen (copy)
            playOpen(p29)
        end)
    end
end

local function watchPlot(p30) -- line: 486
    -- upvalues: register (copy)
    local Chest = p30:FindFirstChild("Chest")

    if Chest then
        task.spawn(register, Chest)
    end

    p30.ChildAdded:Connect(function(p31) -- line: 489
        -- upvalues: register (copy)
        task.spawn(register, p31)
    end)
end

for _, child in ipairs(Plots:GetChildren()) do
    watchPlot(child)
end

Plots.ChildAdded:Connect(watchPlot)
