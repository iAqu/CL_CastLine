-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GUI = require(ReplicatedStorage.Client.GUI)
local Player = require(ReplicatedStorage.Shared.Player)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
local t1 = {
    popFromScale = 0.7,
    pulseSeconds = 0.25,
    pulsePeak = 1.06,
    popInfo = TweenInfo.new(0.28, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    pulseOutInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    pulseInInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
}
local t2 = {
    fadeDelay = 0.5,
    clearDelay = 0.35,
    icon = "rbxassetid://78137530993637",
    sink = Vector3.new(0, -1, 0),
    growInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    riseInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    fadeInfo = TweenInfo.new(0.3),
    baseTint = Color3.fromRGB(178, 233, 255),
    tintLadder = {
        {
            from = 100,
            isInclusive = true,
            tint = Color3.fromRGB(255, 0, 0)
        },
        {
            from = 25,
            isInclusive = true,
            tint = Color3.fromRGB(255, 67, 199)
        },
        {
            from = 9,
            isInclusive = true,
            tint = Color3.fromRGB(0, 255, 255)
        },
        {
            from = 1,
            isInclusive = false,
            tint = Color3.fromRGB(255, 238, 0)
        }
    }
}
local t3 = {
    seconds = 0.85,
    fadeStart = 0.72,
    startScale = 0.72,
    scaleWave = 0.18,
    touchDivisor = 2.5,
    launchXFraction = 0.25,
    cloneName = "SpeedGainPopup",
    spawnSoundId = nil,
    landingSoundId = nil,
    playbackSpeed = 1,
    lift = NumberRange.new(100, 150),
    bend = NumberRange.new(90, 120)
}
local t4 = {
    TextLabel = "TextTransparency",
    ImageLabel = "ImageTransparency",
    UIStroke = "Transparency"
}
local t5 = {}
local LocalPlayer = Players.LocalPlayer
local v1 = Random.new()
local t6 = {}

local function build(p1, p2, p3) -- line: 72
    local v2 = Instance.new(p1)

    for v3, v4 in p2 do
        v2[v3] = v4
    end

    v2.Parent = p3

    return v2
end

local function scaleFor(p4) -- line: 81
    local v5 = p4:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

    v5.Parent = p4

    return v5
end

local function headlineScale(p5) -- line: 87
    local Parent = p5.Parent
    local v6, v7

    if Parent ~= nil then
        if Parent:IsA("GuiObject") then
            v6 = Parent:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
            v7 = false
        else
            v7 = true
        end
    else
        v7 = true
    end

    if v7 then
        return nil
    end

    v6.Parent = Parent

    return v6
end

local function popHeadline(p6) -- line: 92
    -- upvalues: TweenService (copy), t1 (copy)
    local Parent = p6.Parent
    local v8, v9

    if Parent ~= nil then
        if Parent:IsA("GuiObject") then
            v8 = Parent:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
            v9 = false
        else
            v9 = true
        end
    else
        v9 = true
    end

    if v9 then
        v8 = nil
    else
        v8.Parent = Parent
    end

    if v8 ~= nil then
        v8.Scale = t1.popFromScale
        TweenService:Create(v8, t1.popInfo, {
            Scale = 1
        }):Play()
    end
end

local function paintAlpha(p7, p8) -- line: 100
    -- upvalues: t4 (copy)
    for _, descendant in p7:GetDescendants() do
        local v10 = t4[descendant.ClassName]

        if v10 ~= nil then
            descendant[v10] = p8
        end
    end
end

local function ladderTint(p9) -- line: 109
    -- upvalues: t2 (copy)
    for _, v11 in t2.tintLadder do
        if v11.isInclusive and v11.from <= p9 or v11.from < p9 then
            return v11.tint
        end
    end

    return t2.baseTint
end

local function spread(p10, p11) -- line: 118
    -- upvalues: v1 (copy)
    return v1:NextNumber(p10.Min * p11, p10.Max * p11)
end

local function arcSampler(p12, p13) -- line: 122
    -- upvalues: UserInputService (copy), t3 (copy), v1 (copy)
    local v12 = if UserInputService.TouchEnabled then 1 / t3.touchDivisor else 1
    local bend = t3.bend
    local v13 = v1:NextNumber(bend.Min * v12, bend.Max * v12) * (if p13.X >= p12.X then -1 else 1)
    local lift = t3.lift
    local v14 = v1:NextNumber(lift.Min * v12, lift.Max * v12)
    local v15 = (p12 + p13) * 0.5 + Vector2.new(v13, -v14)

    return function(p14) -- line: 128
        -- upvalues: p12 (copy), p13 (copy), v15 (copy)
        local v16 = 1 - p14

        return p12 * (v16 * v16) + v15 * (v16 * 2 * p14) + p13 * (p14 * p14)
    end
end

local function raiseBadge(p15, p16, p17, p18, p19) -- line: 134
    -- upvalues: TweenService (copy), GUI (copy), Player (copy), t2 (copy), LocalPlayer (copy), v1 (copy), popHeadline (copy), ladderTint (copy)
    local v17 = Player.FindRootPart(LocalPlayer)

    if v17 == nil then
        return
    end

    local t7 = {
        AlwaysOnTop = true,
        Name = "PlusOne",
        StudsOffset = Vector3.new(0, 1, 0),
        Adornee = v17,
        Size = UDim2.new(4.5, 0, 1.5, 0)
    }
    local v18 = GUI.PlayerGui()
    local BillboardGui = Instance.new("BillboardGui")

    for v19, v20 in t7 do
        BillboardGui[v19] = v20
    end

    BillboardGui.Parent = v18

    local t8 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0)
    }
    local Frame = Instance.new("Frame")

    for v21, v22 in t8 do
        Frame[v21] = v22
    end

    Frame.Parent = BillboardGui

    local t9 = {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.05, 0),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }
    local UIListLayout = Instance.new("UIListLayout")

    for v23, v24 in t9 do
        UIListLayout[v23] = v24
    end

    UIListLayout.Parent = Frame

    local t10 = {
        BackgroundTransparency = 1,
        Image = t2.icon,
        Size = UDim2.new(0.3, 0, 0.8, 0)
    }
    local ImageLabel = Instance.new("ImageLabel")

    for v25, v26 in t10 do
        ImageLabel[v25] = v26
    end

    ImageLabel.Parent = Frame

    local t11 = {
        AspectRatio = 1
    }
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    for v27, v28 in t11 do
        UIAspectRatioConstraint[v27] = v28
    end

    UIAspectRatioConstraint.Parent = ImageLabel

    local t12 = {
        BackgroundTransparency = 1,
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        Size = UDim2.new(0.6, 0, 0.9, 0),
        Text = p16,
        TextColor3 = p18 or ladderTint(p17 or 1)
    }
    local TextLabel = Instance.new("TextLabel")

    for v29, v30 in t12 do
        TextLabel[v29] = v30
    end

    TextLabel.Parent = Frame

    local t13 = {
        Thickness = 2
    }
    local UIStroke = Instance.new("UIStroke")

    for v31, v32 in t13 do
        UIStroke[v31] = v32
    end

    UIStroke.Parent = TextLabel

    local v35 = Vector3.new(v1:NextInteger(-4, 4), v1:NextInteger(3, 5), v1:NextInteger(-2, 2))

    TweenService:Create(Frame, t2.growInfo, {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
    TweenService:Create(BillboardGui, t2.riseInfo, {
        StudsOffset = v35
    }):Play()

    if p19 ~= nil then
        p19()
    end

    task.delay(t2.fadeDelay, function() -- line: 194
        -- upvalues: p15 (copy), BillboardGui (copy), ImageLabel (copy), TextLabel (copy), UIStroke (copy), v35 (copy), TweenService (copy), t2 (copy), popHeadline (copy)
        for _, v36 in {
                {
                    TextLabel,
                    {
                        TextTransparency = 1
                    }
                },
                {
                    ImageLabel,
                    {
                        ImageTransparency = 1
                    }
                },
                {
                    UIStroke,
                    {
                        Transparency = 1
                    }
                },
                {
                    BillboardGui,
                    {
                        StudsOffset = v35 + t2.sink
                    }
                }
            } do
            TweenService:Create(v36[1], t2.fadeInfo, v36[2]):Play()
        end

        task.delay(t2.clearDelay, function() -- line: 205
            -- upvalues: p15 (copy), BillboardGui (copy), popHeadline (copy)
            popHeadline(p15)
            BillboardGui:Destroy()
        end)
    end)
end

local function flyToHeadline(p20, p21, p22, p23, p24) -- line: 212
    -- upvalues: RunService (copy), Audio (copy), GUI (copy), t3 (copy), t4 (copy), popHeadline (copy), arcSampler (copy)
    local function finish() -- line: 219
        -- upvalues: p24 (copy)
        if p24 ~= nil then
            p24()
        end
    end

    local CurrentCamera = workspace.CurrentCamera

    if not (p21 <= 0) and CurrentCamera ~= nil then
        local v37 = GUI.SpeedGainAnimation()

        assert(v37:IsA("ScreenGui"), "speed gain host is not a ScreenGui")

        local Frame = v37.Frame

        assert(Frame:IsA("Frame"), "speed gain host is missing its Frame template")

        local clone = Frame:Clone()

        clone.Name = t3.cloneName
        clone.Visible = true
        clone.AnchorPoint = Vector2.new(0.5, 0.5)

        local CurrentBoost = clone.CurrentBoost

        assert(CurrentBoost:IsA("TextLabel"), "speed gain template has no CurrentBoost label")

        local v38 = CurrentBoost:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

        v38.Parent = CurrentBoost
        CurrentBoost.Text = p22
        v38.Scale = t3.startScale

        local ViewportSize = CurrentCamera.ViewportSize
        local v39 = p23 or Vector2.new(ViewportSize.X * t3.launchXFraction, ViewportSize.Y)
        local v40 = arcSampler(v39, p20.AbsolutePosition + p20.AbsoluteSize * 0.5)

        clone.Position = UDim2.fromOffset(v39.X, v39.Y)
        clone.Parent = v37

        for _, descendant in clone:GetDescendants() do
            local v41 = t4[descendant.ClassName]

            if v41 ~= nil then
                descendant[v41] = 0
            end
        end

        if t3.spawnSoundId then
            Audio.Play(t3.spawnSoundId, script, {
                PlaybackSpeed = t3.playbackSpeed
            })
        end

        local elapsed = os.clock()
        local n1 = 0

        while n1 < 1 and clone.Parent ~= nil do
            n1 = math.min((os.clock() - elapsed) / t3.seconds, 1)

            local v43 = v40(n1)

            clone.Position = UDim2.fromOffset(v43.X, v43.Y)
            v38.Scale = t3.startScale + math.sin(n1 * 3.141592653589793) * t3.scaleWave

            local v46 = math.clamp((n1 - t3.fadeStart) / (1 - t3.fadeStart), 0, 1)

            for _, descendant in clone:GetDescendants() do
                local v47 = t4[descendant.ClassName]

                if v47 ~= nil then
                    descendant[v47] = v46
                end
            end

            RunService.RenderStepped:Wait()
        end

        if clone.Parent ~= nil then
            if t3.landingSoundId then
                Audio.Play(t3.landingSoundId, script)
            end

            popHeadline(p20)
            clone:Destroy()
        end
    end

    if p24 ~= nil then
        p24()
    end
end

function t5.PlayWalk(p25, p26, p27, p28) -- line: 285
    -- upvalues: t5 (copy)
    t5.ShowGainBadge(p25, p26, p27, p28)
end

function t5.ShowGainBadge(p29, p30, p31, p32) -- line: 294
    -- upvalues: TreadmillUtil (copy), raiseBadge (copy)
    if p30 <= 0 then
        if p32 ~= nil then
            p32()
        end
    else
        raiseBadge(p29, "+" .. TreadmillUtil.FormatSpeedPower((math.round(p30))), p30, p31, p32)
    end
end

function t5.Play(p33, p34, p35, p36) -- line: 311
    -- upvalues: TreadmillUtil (copy), flyToHeadline (copy)
    flyToHeadline(p33, p34, "+" .. TreadmillUtil.FormatSpeedPower(p34) .. " Speed", p35, p36)
end

function t5.SetHeadlinePulsing(p37, p38) -- line: 321
    -- upvalues: TweenService (copy), t1 (copy), t6 (copy)
    local Parent = p37.Parent
    local v50, v51

    if Parent ~= nil then
        if Parent:IsA("GuiObject") then
            v50 = Parent:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
            v51 = false
        else
            v51 = true
        end
    else
        v51 = true
    end

    if v51 then
        v50 = nil
    else
        v50.Parent = Parent
    end

    if v50 ~= nil then
        local v52 = t6[v50]

        if v52 == nil or v52.isActive ~= p38 then
            local v53 = (if v52 then v52.token else 0) + 1

            t6[v50] = {
                isActive = p38,
                token = v53
            }

            if p38 then
                local spawn = task.spawn
                local v54 = v50

                spawn(function() -- line: 340
                    -- upvalues: v53 (copy), v54 (copy), TweenService (copy), t1 (copy), t6 (copy)
                    local function isStillOurs() -- line: 341
                        -- upvalues: v53 (copy), v54 (copy), t6 (copy)
                        local v55 = t6[v54]

                        if v55 ~= nil and v55.token == v53 then
                            return (v54:IsDescendantOf(game))
                        end

                        return false
                    end

                    local t14 = {
                        {
                            info = t1.pulseOutInfo,
                            scale = t1.pulsePeak
                        },
                        {
                            scale = 1,
                            info = t1.pulseInInfo
                        }
                    }

                    while true do
                        local v56 = t6[v54]

                        if v56 ~= nil and v56.token == v53 and v54:IsDescendantOf(game) then
                            for _, v57 in t14 do
                                local v58 = t6[v54]

                                if v58 == nil or v58.token ~= v53 or not v54:IsDescendantOf(game) then
                                    return
                                end

                                TweenService:Create(v54, v57.info, {
                                    Scale = v57.scale
                                }):Play()
                                task.wait(t1.pulseSeconds)
                            end

                            continue
                        end

                        return
                    end
                end)
            else
                TweenService:Create(v50, t1.pulseInInfo, {
                    Scale = 1
                }):Play()
            end
        end
    end
end

function t5.HideSource() -- line: 363
    -- upvalues: GUI (copy)
    local v59 = GUI.SpeedGainAnimation()

    assert(v59:IsA("ScreenGui"), "speed gain host is not a ScreenGui")

    local Frame = v59.Frame

    assert(Frame:IsA("Frame"), "speed gain host is missing its Frame template")
    Frame.Visible = false
end

return t5
