-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Zones = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Zones"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Banner = PlayerGui:WaitForChild("ZoneBannerGui"):WaitForChild("Banner")
local ZoneName = Banner:WaitForChild("ZoneName")
local UIGradient = ZoneName:WaitForChild("UIGradient")
local UIStroke = ZoneName:WaitForChild("UIStroke")
local Glint = Banner:WaitForChild("Glint")
local UIGradient2 = Glint:WaitForChild("UIGradient")

local function look(p1, p2) -- line: 35
    return {
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, p1:Lerp(Color3.new(1, 1, 1), 0.55)),
            ColorSequenceKeypoint.new(1, p1)
        }),
        p2
    }
end

local t1 = {}

for v1, v2 in ipairs(Zones.COLORS) do
    t1[v1] = look(v2[1], v2[2])
end

local t2 = {
    DROP = 0.022,
    GLINT_AT = 0.18,
    HOLD = 1.8,
    RISE = 0.016,
    SETTLE = 0.15,
    IN = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    GLINT = TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    OUT = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    SNAP = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
}
local BannerPosition = Banner.Position

local function at(p3) -- line: 54
    -- upvalues: BannerPosition (copy)
    return UDim2.new(BannerPosition.X.Scale, BannerPosition.X.Offset, BannerPosition.Y.Scale + p3, BannerPosition.Y.Offset)
end

Banner.Visible = false
Banner.GroupTransparency = 1

local n1 = 0
local v3 = false
local t3 = {}

local function stopTweens() -- line: 61
    -- upvalues: t3 (copy)
    for _, v4 in ipairs(t3) do
        v4:Cancel()
    end

    table.clear(t3)
end

local function play(p4, p5, p6) -- line: 65
    -- upvalues: TweenService (copy), t3 (copy)
    local tween = TweenService:Create(p4, p5, p6)

    t3[#t3 + 1] = tween
    tween:Play()

    return tween
end

local function arrive(p7, p8) -- line: 72
    -- upvalues: TweenService (copy), Zones (copy), Banner (copy), ZoneName (copy), UIGradient (copy), UIStroke (copy), Glint (copy), UIGradient2 (copy), t1 (copy), t2 (copy), BannerPosition (copy), n1 (ref), v3 (ref), t3 (copy)
    for _, v5 in ipairs(t3) do
        v5:Cancel()
    end

    table.clear(t3)

    local v6 = t1[p7] or t1[1]

    ZoneName.Text = string.upper(Zones.NAMES[p7] or "")
    Glint.Text = ZoneName.Text

    local v7 = v6[1]
    local v8 = v6[2]

    UIGradient.Color = v7
    UIStroke.Color = v8
    UIGradient2.Offset = Vector2.new(-1, 0)

    local v9 = -t2.DROP

    Banner.Position = UDim2.new(BannerPosition.X.Scale, BannerPosition.X.Offset, BannerPosition.Y.Scale + v9, BannerPosition.Y.Offset)
    Banner.GroupTransparency = 1
    Banner.Visible = true
    v3 = true

    local tween = TweenService:Create(Banner, t2.IN, {
        GroupTransparency = 0,
        Position = BannerPosition
    })

    t3[#t3 + 1] = tween
    tween:Play()
    task.delay(t2.GLINT_AT, function() -- line: 84
        -- upvalues: p8 (copy), TweenService (copy), UIGradient2 (copy), t2 (copy), n1 (ref), t3 (copy)
        if n1 ~= p8 then
            return
        end

        local tween = TweenService:Create(UIGradient2, t2.GLINT, {
            Offset = Vector2.new(1, 0)
        })

        t3[#t3 + 1] = tween
        tween:Play()
    end)
    task.delay(t2.IN.Time + t2.HOLD, function() -- line: 87
        -- upvalues: p8 (copy), TweenService (copy), Banner (copy), t2 (copy), BannerPosition (copy), n1 (ref), v3 (ref), t3 (copy)
        if n1 ~= p8 then
            return
        end

        for _, v10 in ipairs(t3) do
            v10:Cancel()
        end

        table.clear(t3)

        local OUT = t2.OUT
        local t6 = {
            GroupTransparency = 1
        }
        local v11 = -t2.RISE

        t6.Position = UDim2.new(BannerPosition.X.Scale, BannerPosition.X.Offset, BannerPosition.Y.Scale + v11, BannerPosition.Y.Offset)

        local tween = TweenService:Create(Banner, OUT, t6)

        t3[#t3 + 1] = tween
        tween:Play()
        tween.Completed:Once(function(p9) -- line: 90
            -- upvalues: p8 (copy), Banner (copy), n1 (ref), v3 (ref)
            if p9 == Enum.PlaybackState.Completed and n1 == p8 then
                Banner.Visible = false
                v3 = false
            end
        end)
    end)
end

local function leaveFast(p10, p11) -- line: 100
    -- upvalues: TweenService (copy), Banner (copy), t2 (copy), BannerPosition (copy), n1 (ref), v3 (ref), t3 (copy)
    for _, v12 in ipairs(t3) do
        v12:Cancel()
    end

    table.clear(t3)

    local SNAP = t2.SNAP
    local t7 = {
        GroupTransparency = 1
    }
    local v13 = -t2.RISE

    t7.Position = UDim2.new(BannerPosition.X.Scale, BannerPosition.X.Offset, BannerPosition.Y.Scale + v13, BannerPosition.Y.Offset)

    local tween = TweenService:Create(Banner, SNAP, t7)

    t3[#t3 + 1] = tween
    tween:Play()
    tween.Completed:Once(function(p12) -- line: 102
        -- upvalues: p10 (copy), p11 (copy), Banner (copy), n1 (ref), v3 (ref)
        if p12 ~= Enum.PlaybackState.Completed or n1 ~= p10 then
            return
        end

        Banner.Visible = false
        v3 = false

        if p11 then
            p11()
        end
    end)
end

local function tutorialBannerUp() -- line: 121
    -- upvalues: PlayerGui (copy)
    local TutorialGui = PlayerGui:FindFirstChild("TutorialGui")
    local Banner = TutorialGui and TutorialGui:FindFirstChild("Banner")

    return Banner ~= nil and Banner.Visible
end

local v14, v15, v16
local n2 = 0

RunService.RenderStepped:Connect(function() -- line: 131
    -- upvalues: Zones (copy), PlayerGui (copy), t2 (copy), n1 (ref), v3 (ref), arrive (copy), leaveFast (copy), v14 (ref), v15 (ref), v16 (ref), n2 (ref)
    if v14 and v14.Parent then
        local v17 = Zones.At(v14:GetPivot().Position.Y)

        if v17 ~= v16 then
            local elapsed = os.clock()

            v16 = v17
            n2 = elapsed
        end

        if v17 ~= v15 and not (os.clock() - n2 < t2.SETTLE) then
            local TutorialGui = PlayerGui:FindFirstChild("TutorialGui")
            local Banner = TutorialGui and TutorialGui:FindFirstChild("Banner")

            if Banner == nil or not Banner.Visible then
                v15 = v17
                n1 += 1

                local v18 = n1

                if v3 then
                    leaveFast(v18, function() -- line: 114
                        -- upvalues: v17 (copy), v18 (copy), arrive (copy)
                        arrive(v17, v18)
                    end)
                else
                    arrive(v17, v18)
                end
            end
        end
    end
end)
Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function(p13) -- line: 140
    -- upvalues: v14 (ref), v15 (ref), v16 (ref)
    v14 = if game:GetService("Players").LocalPlayer:GetAttribute("TitanRiding") then nil else p13
    v15 = nil
    v16 = nil
end)
game:GetService("Players").LocalPlayer:GetAttributeChangedSignal("TitanRiding"):Connect(function() -- line: 146
    -- upvalues: n1 (ref), v3 (ref), t3 (copy), leaveFast (copy), v14 (ref), v15 (ref), v16 (ref)
    if not game:GetService("Players").LocalPlayer:GetAttribute("TitanRiding") then
        return
    end

    v14 = nil
    v15 = nil
    v16 = nil
    n1 += 1

    if v3 then
        leaveFast(n1)
    else
        for _, v19 in ipairs(t3) do
            v19:Cancel()
        end

        table.clear(t3)
    end
end)
Remotes:WaitForChild("HarpoonExit").OnClientEvent:Connect(function() -- line: 151
    -- upvalues: n1 (ref), v3 (ref), t3 (copy), leaveFast (copy), v14 (ref), v15 (ref), v16 (ref)
    v14 = nil
    v15 = nil
    v16 = nil
    n1 += 1

    if v3 then
        leaveFast(n1)
    else
        for _, v20 in ipairs(t3) do
            v20:Cancel()
        end

        table.clear(t3)
    end
end)
