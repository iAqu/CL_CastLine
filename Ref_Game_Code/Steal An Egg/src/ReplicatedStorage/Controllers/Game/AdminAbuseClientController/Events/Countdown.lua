-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Shake = require(ReplicatedStorage.Client.Shake)
local v1 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(255, 82, 82)
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local v4 = Random.new()
local t1, connection, v5

local function playNamedSound(p1) -- line: 85
    -- upvalues: ReplicatedStorage (copy), Audio (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Sounds = Assets and Assets:FindFirstChild("Sounds")
    local v6 = Sounds and Sounds:FindFirstChild(p1)

    if v6 == nil or not v6:IsA("Sound") then
        warn((("[Countdown] Missing ReplicatedStorage.Assets.Sounds.%*; the countdown continues without it"):format(p1)))
    else
        Audio.Play(v6, script)
    end
end

local function resolveNotificationLane() -- line: 96
    -- upvalues: PlayerGui (copy)
    local Notifications = PlayerGui:FindFirstChild("Notifications")
    local Banner = if Notifications == nil then nil else Notifications:FindFirstChild("Banner")

    return if Banner ~= nil and Banner:IsA("Frame") then Banner else nil
end

local function resolveEndsAt() -- line: 102
    -- upvalues: Workspace (copy), v5 (ref)
    local AdminAbuseCountdownEndsAt = Workspace:GetAttribute("AdminAbuseCountdownEndsAt")

    if type(AdminAbuseCountdownEndsAt) == "number" then
        return AdminAbuseCountdownEndsAt
    end

    return v5
end

local function formatClock(p2) -- line: 110
    local v7 = math.ceil(p2)
    local v8 = v7 // 3600
    local v9 = v7 % 3600 // 60
    local v10 = v7 % 60

    if v8 > 0 then
        return string.format("%d:%02d:%02d", v8, v9, v10)
    end

    if v7 < 60 then
        return (tostring(v7))
    end

    return string.format("%02d:%02d", v9, v10)
end

local function setText(p3, p4) -- line: 124
    p3.TimeLabel.Text = p4

    if p3.ShadowLabel ~= nil then
        p3.ShadowLabel.Text = p4
    end
end

local function syncTitle(p5) -- line: 132
    -- upvalues: Workspace (copy)
    local AdminAbuseCountdownTitle = Workspace:GetAttribute("AdminAbuseCountdownTitle")

    if type(AdminAbuseCountdownTitle) == "string" and p5.TitleLabel.Text ~= AdminAbuseCountdownTitle then
        p5.TitleLabel.Text = AdminAbuseCountdownTitle
    end
end

local function punch(p6, p7) -- line: 139
    -- upvalues: TweenService (copy)
    local Punch = p6.Punch

    if Punch == nil then
        return
    end

    if p6.PunchTween ~= nil then
        p6.PunchTween:Cancel()
    end

    Punch.Scale = p7

    local tween = TweenService:Create(Punch, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    })

    p6.PunchTween = tween
    tween:Play()
    p6.ShakeUntil = os.clock() + 0.18
end

local function playTick(p8) -- line: 155
    -- upvalues: Audio (copy)
    local v12 = 1 - math.clamp(p8 / 10, 0, 1)

    Audio.Play("rbxassetid://125937767292519", script, {
        Volume = 0.7,
        PlaybackSpeed = v12 * 0.85 + 0.85
    })
end

local function teardown() -- line: 163
    -- upvalues: t1 (ref), connection (ref)
    if connection ~= nil then
        connection:Disconnect()
        connection = nil
    end

    local t2 = t1

    t1 = nil

    if t2 ~= nil then
        t2.Gui:Destroy()
    end
end

local function fadeOut(p9) -- line: 176
    -- upvalues: TweenService (copy), v1 (copy), t1 (ref), connection (ref)
    if t1 ~= p9 then
        return
    end

    t1 = nil

    if connection ~= nil then
        connection:Disconnect()
        connection = nil
    end

    for _, v13 in {
            p9.TimeLabel,
            p9.TitleLabel
        } do
        TweenService:Create(v13, v1, {
            TextTransparency = 1
        }):Play()

        local UIStroke = v13:FindFirstChildOfClass("UIStroke")

        if UIStroke ~= nil then
            TweenService:Create(UIStroke, v1, {
                Transparency = 1
            }):Play()
        end
    end

    if p9.ShadowLabel ~= nil then
        TweenService:Create(p9.ShadowLabel, v1, {
            TextTransparency = 1
        }):Play()
    end

    task.delay(0.6, function() -- line: 197
        -- upvalues: p9 (copy)
        p9.Gui:Destroy()
    end)
end

local function applyPosition(p10, p11) -- line: 203
    local Lane = p10.Lane

    if Lane ~= nil then
        local Y = Lane.AbsolutePosition.Y
        local v14 = Y
        local v15 = false

        for _, child in Lane:GetChildren() do
            if child:IsA("GuiObject") and child.Visible then
                local v16 = child.AbsolutePosition.Y + child.AbsoluteSize.Y

                if v14 < v16 then
                    v14 = v16
                end

                v15 = true
            end
        end

        if v15 then
            Y = v14 + p10.LaneGap
        end

        local RestY = p10.RestY

        if RestY ~= nil then
            local v17 = if RestY < Y then 18 else 5

            Y = RestY + (Y - RestY) * math.min(p11 * v17, 1)
        end

        p10.RestY = Y

        local LoweredPosition = p10.LoweredPosition

        p10.BasePosition = UDim2.new(LoweredPosition.X.Scale, LoweredPosition.X.Offset, 0, Y - p10.Gui.AbsolutePosition.Y)
    else
        p10.BasePosition = p10.LoweredPosition
    end
end

local function applyShake(p12) -- line: 241
    -- upvalues: v4 (copy)
    local Holder = p12.Holder

    if os.clock() < p12.ShakeUntil then
        Holder.Position = p12.BasePosition + UDim2.fromOffset(v4:NextInteger(-6, 6), v4:NextInteger(-6, 6))
    elseif Holder.Position ~= p12.BasePosition then
        Holder.Position = p12.BasePosition
    end
end

local function applyScale(p13, p14, p15) -- line: 254
    p13.Scale = p13.Scale + (p14 - p13.Scale) * math.min(p15 * 5, 1)

    local BaseSize = p13.BaseSize

    p13.Holder.Size = UDim2.fromScale(BaseSize.X.Scale * p13.Scale, BaseSize.Y.Scale * p13.Scale)
end

local function startFinale(p16) -- line: 260
    -- upvalues: Shake (copy), playNamedSound (copy), punch (copy), fadeOut (copy)
    p16.FinaleAt = os.clock()
    p16.TimeLabel.Text = "0"

    if p16.ShadowLabel ~= nil then
        p16.ShadowLabel.Text = "0"
    end

    p16.TimeLabel.TextColor3 = p16.UrgentColor
    punch(p16, 1.45)
    playNamedSound("CinematicBoom")
    Shake.Play({
        Seconds = 0.35,
        Magnitude = 0.35
    })
    task.delay(1.4, function() -- line: 267
        -- upvalues: p16 (copy), fadeOut (copy)
        fadeOut(p16)
    end)
end

local function step(p17) -- line: 270
    -- upvalues: Workspace (copy), Audio (copy), t1 (ref), connection (ref), v5 (ref), playNamedSound (copy), formatClock (copy), punch (copy), fadeOut (copy), applyPosition (copy), applyShake (copy), startFinale (copy)
    local t3 = t1

    if t3 ~= nil then
        if t3.Gui.Parent ~= nil then
            local AdminAbuseCountdownTitle = Workspace:GetAttribute("AdminAbuseCountdownTitle")

            if type(AdminAbuseCountdownTitle) == "string" and t3.TitleLabel.Text ~= AdminAbuseCountdownTitle then
                t3.TitleLabel.Text = AdminAbuseCountdownTitle
            end

            if t3.FinaleAt ~= nil then
                t3.Scale = t3.Scale + (1 - t3.Scale) * math.min(p17 * 5, 1)

                local BaseSize = t3.BaseSize

                t3.Holder.Size = UDim2.fromScale(BaseSize.X.Scale * t3.Scale, BaseSize.Y.Scale * t3.Scale)
                applyPosition(t3, p17)
                applyShake(t3)
            else
                local AdminAbuseCountdownEndsAt = Workspace:GetAttribute("AdminAbuseCountdownEndsAt")

                if type(AdminAbuseCountdownEndsAt) ~= "number" then
                    AdminAbuseCountdownEndsAt = v5
                end

                if AdminAbuseCountdownEndsAt ~= nil then
                    local v22 = AdminAbuseCountdownEndsAt - Workspace:GetServerTimeNow()

                    if v22 <= 0 then
                        startFinale(t3)
                    else
                        local v23 = math.ceil(v22)

                        if v22 > 10 then
                            local v24 = formatClock(v22)

                            t3.TimeLabel.Text = v24

                            if t3.ShadowLabel ~= nil then
                                t3.ShadowLabel.Text = v24
                            end

                            t3.TimeLabel.TextColor3 = t3.CalmColor
                            t3.Scale = t3.Scale + (0.55 - t3.Scale) * math.min(p17 * 5, 1)

                            local BaseSize = t3.BaseSize

                            t3.Holder.Size = UDim2.fromScale(BaseSize.X.Scale * t3.Scale, BaseSize.Y.Scale * t3.Scale)
                        else
                            if not t3.RiserPlayed then
                                t3.RiserPlayed = true
                                playNamedSound("CinematicRiser")
                            end

                            local v28 = 1 - math.clamp(v22 / 10, 0, 1)

                            t3.TimeLabel.TextColor3 = t3.CalmColor:Lerp(t3.UrgentColor, v28)

                            local v29 = if v22 > 6 then tostring(v23) else string.format("%.1f", v22)

                            t3.TimeLabel.Text = v29

                            if t3.ShadowLabel ~= nil then
                                t3.ShadowLabel.Text = v29
                            end

                            if v23 ~= t3.LastWholeSecond then
                                punch(t3, t3.PunchScale)

                                local v31 = 1 - math.clamp(v23 / 10, 0, 1)

                                Audio.Play("rbxassetid://125937767292519", script, {
                                    Volume = 0.7,
                                    PlaybackSpeed = v31 * 0.85 + 0.85
                                })
                            end

                            t3.Scale = t3.Scale + (1 - t3.Scale) * math.min(p17 * 5, 1)

                            local BaseSize = t3.BaseSize

                            t3.Holder.Size = UDim2.fromScale(BaseSize.X.Scale * t3.Scale, BaseSize.Y.Scale * t3.Scale)
                        end

                        t3.LastWholeSecond = v23
                        applyPosition(t3, p17)
                        applyShake(t3)
                    end
                else
                    fadeOut(t3)
                end
            end
        else
            if connection ~= nil then
                connection:Disconnect()
                connection = nil
            end

            local t4 = t1

            t1 = nil

            if t4 ~= nil then
                t4.Gui:Destroy()
            end
        end
    end
end

local function show() -- line: 330
    -- upvalues: RunService (copy), Workspace (copy), v2 (copy), v3 (copy), PlayerGui (copy), t1 (ref), connection (ref), step (copy)
    if t1 ~= nil then
        return
    end

    local v36 = PlayerGui:WaitForChild("CountdownGui", 10)

    if v36 == nil or not v36:IsA("ScreenGui") then
        warn("[Countdown] Missing StarterGui.CountdownGui; the countdown has no display")
    elseif t1 == nil then
        local clone = v36:Clone()

        clone.Name = "CountdownGuiActive"
        clone.Enabled = true

        local Holder = clone:FindFirstChild("Holder")
        local Time = if Holder == nil then nil else Holder:FindFirstChild("Time")
        local Title, v37, v38

        if Holder ~= nil then
            if not Holder:IsA("Frame") or Time == nil then
                v38 = true
            elseif Time:IsA("TextLabel") then
                Title = Holder:FindFirstChild("Title")
                v37 = Title ~= nil and Title:IsA("TextLabel")
                v38 = false
            else
                v38 = true
            end
        else
            v38 = true
        end

        if not v38 then
            assert(v37, "CountdownGui.Holder needs a Title TextLabel")

            local Shadow = Holder:FindFirstChild("Shadow")
            local Punch = Holder:FindFirstChild("Punch")
            local CalmColor = Holder:GetAttribute("CalmColor")
            local UrgentColor = Holder:GetAttribute("UrgentColor")
            local t5 = {
                RestY = nil,
                Scale = 0.55,
                ShakeUntil = 0,
                LastWholeSecond = nil,
                RiserPlayed = false,
                FinaleAt = nil,
                PunchTween = nil,
                Gui = clone,
                Holder = Holder,
                TimeLabel = Time,
                TitleLabel = Title,
                ShadowLabel = if Shadow == nil or not Shadow:IsA("TextLabel") then nil else Shadow,
                Punch = if Punch == nil or not Punch:IsA("UIScale") then nil else Punch,
                BaseSize = Holder.Size,
                BasePosition = Holder.Position,
                LoweredPosition = Holder.Position,
                LaneGap = tonumber(Holder:GetAttribute("LaneGapPixels")) or 8
            }
            local Notifications = PlayerGui:FindFirstChild("Notifications")
            local Banner = if Notifications == nil then nil else Notifications:FindFirstChild("Banner")

            t5.Lane = if Banner == nil or not Banner:IsA("Frame") then nil else Banner
            t5.CalmColor = if typeof(CalmColor) ~= "Color3" then v2 else CalmColor
            t5.UrgentColor = if typeof(UrgentColor) ~= "Color3" then v3 else UrgentColor
            t5.PunchScale = tonumber(Holder:GetAttribute("PunchScale")) or 1.3
            t5.TimeLabel.Text = ""

            if t5.ShadowLabel ~= nil then
                t5.ShadowLabel.Text = ""
            end

            t5.TitleLabel.Text = ""

            local AdminAbuseCountdownTitle = Workspace:GetAttribute("AdminAbuseCountdownTitle")

            if type(AdminAbuseCountdownTitle) == "string" and t5.TitleLabel.Text ~= AdminAbuseCountdownTitle then
                t5.TitleLabel.Text = AdminAbuseCountdownTitle
            end

            t1 = t5
            clone.Parent = PlayerGui

            if connection == nil then
                connection = RunService.RenderStepped:Connect(step)
            end
        else
            warn("[Countdown] CountdownGui needs Holder and Holder.Time; the countdown has no display")
            clone:Destroy()
        end
    end
end

local t6 = {
    StartEvent = function(_, p19, _) -- StartEvent | line: 399
        -- upvalues: Workspace (copy), v5 (ref), show (copy)
        v5 = Workspace:GetServerTimeNow() + p19
        show()
    end,
    StopEvent = function(_) -- StopEvent | line: 404
        -- upvalues: t1 (ref), v5 (ref), fadeOut (copy)
        v5 = nil

        local t7 = t1

        if t7 ~= nil and t7.FinaleAt == nil then
            fadeOut(t7)
        end
    end
}

local function onEndsAtChanged() -- line: 412
    -- upvalues: Workspace (copy), t1 (ref), fadeOut (copy), show (copy)
    if type(Workspace:GetAttribute("AdminAbuseCountdownEndsAt")) == "number" then
        show()
    else
        local t8 = t1

        if t8 ~= nil and t8.FinaleAt == nil then
            fadeOut(t8)
        end
    end
end

Workspace:GetAttributeChangedSignal("AdminAbuseCountdownEndsAt"):Connect(onEndsAtChanged)

if type(Workspace:GetAttribute("AdminAbuseCountdownEndsAt")) == "number" then
    show()
else
    local t9 = t1

    if t9 ~= nil and t9.FinaleAt == nil then
        fadeOut(t9)
    end
end

return t6
