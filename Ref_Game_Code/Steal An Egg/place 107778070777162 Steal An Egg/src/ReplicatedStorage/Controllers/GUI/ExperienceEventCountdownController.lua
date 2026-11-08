-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local EventBoardView = require(ReplicatedStorage.Shared.Modules.EventBoardView)
local Log = require(ReplicatedStorage.Packages.Log)
local v1 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(255, 82, 82)
local v4 = Log.new()
local v5 = Random.new()
local EventCountdownGui, CinematicRiser, v6, t1, connection

local function now() -- line: 67
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function remainingSeconds() -- line: 71
    -- upvalues: Workspace (copy), v6 (ref)
    local v7 = v6

    return if v7 ~= nil then v7.StartsAt - Workspace:GetServerTimeNow() else nil
end

local function inShowWindow(p1) -- line: 76
    if p1 ~= nil and p1 > 0 then
        return p1 <= 3600
    end

    return false
end

local function nextPollSeconds(p2, p3) -- line: 80
    if p2 == nil then
        return 3600
    end

    if p2.StartsAt - p3 > 3600 then
        return 1800
    end

    return 300
end

local function formatClock(p4) -- line: 90
    local v8 = math.ceil(p4)
    local v9 = v8 // 3600
    local v10 = v8 % 3600 // 60
    local v11 = v8 % 60

    if v9 > 0 then
        return string.format("%d:%02d:%02d", v9, v10, v11)
    end

    if v8 < 60 then
        return (tostring(v8))
    end

    return string.format("%02d:%02d", v10, v11)
end

local function setText(p5, p6) -- line: 104
    p5.TimeLabel.Text = p6

    if p5.ShadowLabel ~= nil then
        p5.ShadowLabel.Text = p6
    end
end

local function punch(p7, p8) -- line: 111
    -- upvalues: TweenService (copy)
    local Punch = p7.Punch

    if Punch == nil then
        return
    end

    if p7.PunchTween ~= nil then
        p7.PunchTween:Cancel()
    end

    Punch.Scale = p8

    local tween = TweenService:Create(Punch, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    })

    p7.PunchTween = tween
    tween:Play()
    p7.ShakeUntil = os.clock() + 0.18
end

local function playTick(p9) -- line: 131
    -- upvalues: Audio (copy)
    local v13 = 1 - math.clamp(p9 / 10, 0, 1)

    Audio.Play("rbxassetid://125937767292519", script, {
        Volume = 0.7,
        PlaybackSpeed = v13 * 0.85 + 0.85
    })
end

local function fadeOut(p10) -- line: 139
    -- upvalues: TweenService (copy), v1 (copy), t1 (ref), connection (ref)
    if t1 ~= p10 then
        return
    end

    t1 = nil

    if connection ~= nil then
        connection:Disconnect()
        connection = nil
    end

    local t2 = {
        p10.TimeLabel,
        p10.TitleLabel
    }

    if p10.ShadowLabel ~= nil then
        table.insert(t2, p10.ShadowLabel)
    end

    for _, v14 in t2 do
        TweenService:Create(v14, v1, {
            TextTransparency = 1
        }):Play()

        local UIStroke = v14:FindFirstChildOfClass("UIStroke")

        if UIStroke ~= nil then
            TweenService:Create(UIStroke, v1, {
                Transparency = 1
            }):Play()
        end
    end

    task.delay(0.6, function() -- line: 161
        -- upvalues: p10 (copy)
        p10.Gui:Destroy()
    end)
end

local function applyShake(p11) -- line: 166
    -- upvalues: Workspace (copy), v5 (copy)
    local Holder = p11.Holder

    if os.clock() < p11.ShakeUntil then
        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera ~= nil then
            local ViewportSize = CurrentCamera.ViewportSize

            Holder.Position = p11.BasePosition + UDim2.fromScale(v5:NextInteger(-6, 6) / ViewportSize.X, v5:NextInteger(-6, 6) / ViewportSize.Y)
        end
    elseif Holder.Position ~= p11.BasePosition then
        Holder.Position = p11.BasePosition
    end
end

local function applyScale(p12, p13, p14) -- line: 184
    p12.Scale = p12.Scale + (p13 - p12.Scale) * math.min(p14 * 5, 1)

    local BaseSize = p12.BaseSize

    p12.Holder.Size = UDim2.fromScale(BaseSize.X.Scale * p12.Scale, BaseSize.Y.Scale * p12.Scale)
end

local function step(p15) -- line: 191
    -- upvalues: Workspace (copy), Audio (copy), CinematicRiser (ref), v6 (ref), t1 (ref), formatClock (copy), punch (copy), fadeOut (copy), applyShake (copy)
    local t3 = t1

    if t3 == nil then
        return
    end

    local v17 = v6
    local v18 = if v17 == nil then nil else v17.StartsAt - Workspace:GetServerTimeNow()
    local v19 = v6

    if v18 == nil or not (v18 > 0) or not (v18 <= 3600) or v19 == nil or v18 == nil then
        fadeOut(t3)

        return
    elseif t3.TitleLabel.Text ~= v19.Title then
        t3.TitleLabel.Text = v19.Title
    end

    local v21 = math.ceil(v18)

    if v18 > 10 then
        local v22 = formatClock(v18)

        t3.TimeLabel.Text = v22

        if t3.ShadowLabel ~= nil then
            t3.ShadowLabel.Text = v22
        end

        t3.TimeLabel.TextColor3 = t3.CalmColor
        t3.Scale = t3.Scale + (0.55 - t3.Scale) * math.min(p15 * 5, 1)

        local BaseSize = t3.BaseSize

        t3.Holder.Size = UDim2.fromScale(BaseSize.X.Scale * t3.Scale, BaseSize.Y.Scale * t3.Scale)
    else
        if not t3.RiserPlayed then
            t3.RiserPlayed = true
            Audio.Play(CinematicRiser, script)
        end

        local v26 = 1 - math.clamp(v18 / 10, 0, 1)

        t3.TimeLabel.TextColor3 = t3.CalmColor:Lerp(t3.UrgentColor, v26)

        local v27 = if v18 > 6 then tostring(v21) else string.format("%.1f", v18)

        t3.TimeLabel.Text = v27

        if t3.ShadowLabel ~= nil then
            t3.ShadowLabel.Text = v27
        end

        if v21 ~= t3.LastWholeSecond then
            punch(t3, t3.PunchScale)

            local v29 = 1 - math.clamp(v21 / 10, 0, 1)

            Audio.Play("rbxassetid://125937767292519", script, {
                Volume = 0.7,
                PlaybackSpeed = v29 * 0.85 + 0.85
            })
        end

        t3.Scale = t3.Scale + (1 - t3.Scale) * math.min(p15 * 5, 1)

        local BaseSize = t3.BaseSize

        t3.Holder.Size = UDim2.fromScale(BaseSize.X.Scale * t3.Scale, BaseSize.Y.Scale * t3.Scale)
    end

    t3.LastWholeSecond = v21
    applyShake(t3)
end

local function show() -- line: 237
    -- upvalues: Players (copy), RunService (copy), v2 (copy), v3 (copy), EventCountdownGui (ref), t1 (ref), connection (ref), step (copy)
    if t1 ~= nil then
        return
    end

    local clone = EventCountdownGui:Clone()

    clone.Name = "EventCountdownGuiActive"
    clone.Enabled = true

    local Holder = clone:FindFirstChild("Holder")

    assert(Holder ~= nil and Holder:IsA("Frame"), "EventCountdownGui needs a Holder Frame")

    local Time = Holder:FindFirstChild("Time")
    local Title = Holder:FindFirstChild("Title")

    assert(Time ~= nil and Time:IsA("TextLabel"), "EventCountdownGui.Holder needs a Time TextLabel")
    assert(Title ~= nil and Title:IsA("TextLabel"), "EventCountdownGui.Holder needs a Title TextLabel")

    local Shadow = Holder:FindFirstChild("Shadow")
    local Punch = Holder:FindFirstChild("Punch")
    local CalmColor = Holder:GetAttribute("CalmColor")
    local UrgentColor = Holder:GetAttribute("UrgentColor")
    local t4 = {
        Scale = 0.55,
        ShakeUntil = 0,
        LastWholeSecond = nil,
        RiserPlayed = false,
        PunchTween = nil,
        Gui = clone,
        Holder = Holder,
        TimeLabel = Time,
        TitleLabel = Title,
        ShadowLabel = if Shadow == nil or not Shadow:IsA("TextLabel") then nil else Shadow,
        Punch = if Punch == nil or not Punch:IsA("UIScale") then nil else Punch,
        BaseSize = Holder.Size,
        BasePosition = Holder.Position,
        CalmColor = if typeof(CalmColor) ~= "Color3" then v2 else CalmColor,
        UrgentColor = if typeof(UrgentColor) ~= "Color3" then v3 else UrgentColor,
        PunchScale = tonumber(Holder:GetAttribute("PunchScale")) or 1.3
    }

    t4.TimeLabel.Text = ""

    if t4.ShadowLabel ~= nil then
        t4.ShadowLabel.Text = ""
    end

    t4.TitleLabel.Text = ""
    t1 = t4
    clone.Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if connection == nil then
        connection = RunService.RenderStepped:Connect(step)
    end
end

local function fetchUpcoming() -- line: 292
    -- upvalues: SocialService (copy), EventBoardView (copy), v4 (copy), v6 (ref), now (copy)
    local GetUpcomingExperienceEventsAsync = SocialService.GetUpcomingExperienceEventsAsync
    local ok, result = pcall(GetUpcomingExperienceEventsAsync, SocialService)

    if ok then
        v6 = EventBoardView.Pick(result, now())
    else
        v4:AtWarning():Log((("[ExperienceEventCountdown] failed to fetch experience events: %*"):format(result)))
    end
end

return {
    Start = function() -- Start | line: 304
        -- upvalues: Players (copy), ReplicatedStorage (copy), SocialService (copy), Workspace (copy), EventBoardView (copy), v4 (copy), EventCountdownGui (ref), CinematicRiser (ref), v6 (ref), t1 (ref), now (copy), show (copy)
        local EventCountdownGui2 = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("EventCountdownGui")

        assert(EventCountdownGui2:IsA("ScreenGui"), "EventCountdownGui must be a ScreenGui")
        EventCountdownGui = EventCountdownGui2

        local CinematicRiser2 = ReplicatedStorage.Assets.Sounds:FindFirstChild("CinematicRiser")

        assert(CinematicRiser2 ~= nil and CinematicRiser2:IsA("Sound"), "Missing ReplicatedStorage.Assets.Sounds.CinematicRiser")
        CinematicRiser = CinematicRiser2
        task.spawn(function() -- line: 316
            -- upvalues: SocialService (copy), Workspace (copy), EventBoardView (copy), v4 (copy), v6 (ref), now (copy)
            task.wait(Random.new():NextNumber(1, 120))

            while true do
                local GetUpcomingExperienceEventsAsync = SocialService.GetUpcomingExperienceEventsAsync
                local ok, result = pcall(GetUpcomingExperienceEventsAsync, SocialService)

                if ok then
                    v6 = EventBoardView.Pick(result, now())
                else
                    v4:AtWarning():Log((("[ExperienceEventCountdown] failed to fetch experience events: %*"):format(result)))
                end

                local wait = task.wait
                local v36 = v6
                local ServerTimeNow = Workspace:GetServerTimeNow()

                wait(if v36 == nil then 3600 elseif v36.StartsAt - ServerTimeNow > 3600 then 1800 else 300)
            end
        end)
        task.spawn(function() -- line: 324
            -- upvalues: Workspace (copy), v6 (ref), t1 (ref), show (copy)
            while true do
                if t1 ~= nil then
                    task.wait(1)
                    continue
                end

                local v37 = v6
                local v38 = if v37 == nil then nil else v37.StartsAt - Workspace:GetServerTimeNow()

                if v38 ~= nil and v38 > 0 and v38 <= 3600 then
                    show()
                end

                task.wait(1)
            end
        end)
    end
}
