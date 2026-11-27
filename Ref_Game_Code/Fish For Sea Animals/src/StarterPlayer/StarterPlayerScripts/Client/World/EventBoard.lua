-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local Config = require(ReplicatedStorage.Shared.Config)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local Showcase = require(script.Parent.Showcase)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local t1 = {}
local v1 = Color3.fromRGB(22, 22, 30)
local LocalPlayer = Players.LocalPlayer

local function v2() -- line: 22
    return false
end

function t1.setBusyCheck(p1) -- line: 26
    -- upvalues: v2 (ref)
    v2 = p1
end

local function tutorialDone() -- line: 30
    -- upvalues: Config (copy), LocalPlayer (copy)
    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    return Tutorial ~= nil and Config.TutorialDone <= Tutorial
end

local Left = Enum.TextXAlignment.Left

local function countdown(p2) -- line: 37
    local v3 = p2 // 86400
    local v4 = p2 % 86400 // 3600
    local v5 = p2 % 3600 // 60
    local v6 = p2 % 60

    if v3 > 0 then
        return string.format("%dd %dh %02dm", v3, v4, v5)
    end

    return string.format("%dh %02dm %02ds", v4, v5, v6)
end

local function page(p3) -- line: 48
    -- upvalues: Config (copy), Kit (copy), Style (copy), v1 (copy), Left (copy)
    local v7 = Kit.frame(p3, {
        Name = "Event",
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.fromScale(1, 1)
    })

    Style.gradient(v7, Style.tint(Style.ABYSS), 60)
    Kit.studs(v7, 0.55, 30)

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 10
    UIStroke.Color = v1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = v7
    Style.tag(v7, "📅 EVENT", Style.CORAL, {
        Rotation = -4,
        Position = UDim2.fromOffset(14, 12),
        Size = UDim2.fromOffset(170, 48)
    })
    Style.tag(v7, "NEXT WEEK", Style.GOLD, {
        Rotation = 4,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 12),
        Size = UDim2.fromOffset(190, 48)
    })

    local v8 = Style.text(v7, "🌋 " .. Config.Event.Title, {
        StrokeThickness = 6,
        ZIndex = 2,
        Position = UDim2.fromOffset(22, 66),
        Size = UDim2.new(1, -44, 0, 72),
        TextXAlignment = Left
    })

    Style.gradient(v8, Style.RAINBOW, 0)

    for v9, v10 in Config.Event.Lines do
        Style.text(v7, v10, {
            ZIndex = 2,
            Position = UDim2.fromOffset(22, 140 + (v9 - 1) * 38),
            Size = UDim2.new(1, -44, 0, 34),
            TextXAlignment = Left,
            TextColor3 = if v9 == 1 then Color3.new(1, 1, 1) else Style.SAND
        })
    end

    local v11 = Style.text(v7, "", {
        Name = "Timer",
        StrokeThickness = 5,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 22, 1, -16),
        Size = UDim2.new(1, -44, 0, 66),
        TextXAlignment = Left
    })

    Style.gradient(v11, ColorSequence.new(Color3.new(1, 1, 1), Style.MINT))

    return v11
end

local function prompt(p4) -- line: 70
    -- upvalues: Config (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "JoinPrompt"
    Attachment.Position = Vector3.new(0, -p4.Size.Y / 2 + 1, 0)
    Attachment.Parent = p4

    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.ObjectText = Config.Event.Title
    ProximityPrompt.HoldDuration = 0
    ProximityPrompt.MaxActivationDistance = 12
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Parent = Attachment

    return ProximityPrompt
end

local function rsvpStatus() -- line: 84
    -- upvalues: SocialService (copy), Config (copy)
    local EventId = Config.Event.EventId

    if EventId ~= "" then
        local GetEventRsvpStatusAsync = SocialService.GetEventRsvpStatusAsync
        local ok, result = pcall(GetEventRsvpStatusAsync, SocialService, EventId)

        if ok then
            return result
        end
    end

    return nil
end

local function build() -- line: 93
    -- upvalues: SocialService (copy), Config (copy), Style (copy), Showcase (copy), UIUtil (copy), LocalPlayer (copy), v2 (ref), page (copy), prompt (copy)
    local v13 = workspace:WaitForChild("EventBoard", 15)
    local v14 = v13 and v13:WaitForChild("Board", 5)

    if not v14 or not v14:IsA("BasePart") then
        warn("workspace.EventBoard.Board is missing, so there's no event board")

        return
    end

    local v15, v16 = Showcase.board(v14)
    local t3 = {}
    local v17 = prompt(v14)
    local v18 = false

    local function showJoin() -- line: 104
        -- upvalues: v17 (copy), v18 (ref)
        v17.ActionText = v18 and "✅ Joined" or "🔔 Join Event"
    end

    local v19 = false

    local function onJoin() -- line: 108
        -- upvalues: v17 (copy), v18 (ref), v19 (ref), SocialService (copy), Config (copy), UIUtil (copy)
        if Config.Event.EventId == "" then
            UIUtil.toast("Sign-ups for this event open soon!", "info")
        elseif v18 then
            UIUtil.toast("You're already in! Roblox will remind you when it starts.", "info")
        elseif not v19 then
            v19 = true

            local PromptRsvpToEventAsync = SocialService.PromptRsvpToEventAsync
            local EventId = Config.Event.EventId
            local ok, result = pcall(PromptRsvpToEventAsync, SocialService, EventId)

            v19 = false

            if ok and result == Enum.RsvpStatus.Going then
                v18 = true
                v17.ActionText = v18 and "✅ Joined" or "🔔 Join Event"
                UIUtil.toast("You're in! See you at the event 🎉", "success")
            elseif not ok then
                warn("Event RSVP failed: " .. tostring(result))
            end
        end
    end

    v17.Triggered:Connect(onJoin)

    for _, v21 in v16 do
        table.insert(t3, (page(v21)))
    end

    v17.ActionText = v18 and "✅ Joined" or "🔔 Join Event"
    task.spawn(function() -- line: 136
        -- upvalues: v17 (copy), v18 (ref), SocialService (copy), Config (copy)
        local EventId = Config.Event.EventId
        local result

        if EventId ~= "" then
            local GetEventRsvpStatusAsync = SocialService.GetEventRsvpStatusAsync
            local ok

            ok, result = pcall(GetEventRsvpStatusAsync, SocialService, EventId)

            if not ok then
                result = nil
            end
        end

        v18 = result == Enum.RsvpStatus.Going
        v17.ActionText = v18 and "✅ Joined" or "🔔 Join Event"
    end)
    task.spawn(function() -- line: 141
        -- upvalues: onJoin (copy), SocialService (copy), Config (copy), LocalPlayer (copy), v2 (ref)
        while true do
            local Tutorial = LocalPlayer:GetAttribute("Tutorial")

            if Tutorial ~= nil and Config.TutorialDone <= Tutorial then
                break
            end

            task.wait(1)
        end

        task.wait(360)

        while v2() do
            task.wait(1)
        end

        if Config.Event.EventId ~= "" and Config.Event.StartsAt > os.time() then
            local EventId = Config.Event.EventId
            local result

            if EventId ~= "" then
                local GetEventRsvpStatusAsync = SocialService.GetEventRsvpStatusAsync
                local ok

                ok, result = pcall(GetEventRsvpStatusAsync, SocialService, EventId)

                if not ok then
                    result = nil
                end
            end

            if result == Enum.RsvpStatus.None then
                onJoin()
            end
        end
    end)
    v15.Color = ColorSequence.new(Color3.new(1, 1, 1), Style.ABYSS)
    task.spawn(function() -- line: 154
        -- upvalues: v14 (copy), v15 (copy), t3 (copy), v17 (copy), Config (copy)
        while v14.Parent do
            local v23 = Config.Event.StartsAt - os.time()
            local v24

            if v23 > 0 then
                local v25 = v23 // 86400
                local v26 = v23 % 86400 // 3600
                local v27 = v23 % 3600 // 60
                local v28 = v23 % 60

                v24 = "Starts in " .. (if v25 > 0 then string.format("%dd %dh %02dm", v25, v26, v27) else string.format("%dh %02dm %02ds", v26, v27, v28))
            else
                v24 = "🔴 LIVE NOW!"
            end

            for _, v29 in t3 do
                v29.Text = v24
            end

            v17.Enabled = v23 > 0

            if os.time() % 6 == 0 then
                v15:Emit(18)
            end

            task.wait(1)
        end
    end)
end

function t1.init() -- line: 171
    -- upvalues: build (copy)
    task.spawn(build)
end

return t1
