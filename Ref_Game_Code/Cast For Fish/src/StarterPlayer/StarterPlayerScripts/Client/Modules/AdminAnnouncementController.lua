-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local n1 = 0
local v1 = utf8.char(57344)
local v2 = TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)

local function escapeRichText(p1) -- line: 22
    return (tostring(p1 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"))
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AdminAnnouncementGui = PlayerGui:WaitForChild("AdminAnnouncementGui")
local AnnouncementStack = AdminAnnouncementGui:WaitForChild("AnnouncementStack")
local AnnouncementTemplate = AnnouncementStack:WaitForChild("AnnouncementTemplate")

local function getViewportSize() -- line: 36
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.ViewportSize
    end

    return (Vector2.new(1280, 720))
end

local function isCompactViewport(p2) -- line: 41
    if p2.X < 760 then
        return true
    end

    return p2.Y < 520
end

local function getAnnouncementY() -- line: 47
    -- upvalues: Workspace (copy), PlayerGui (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v4 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    local v5 = v4.X < 760 or v4.Y < 520
    local v6 = if v5 then math.clamp(math.floor(v4.Y * 0.22), 78, 120) else math.min(180, (math.max(130, v4.Y - 260)))
    local t3 = {
        { "EventHUD", "Banner" },
        { "ServerLuck", "Pill" },
        { "HUD", "TipBubble" }
    }
    local n2 = 0

    for _, v11 in ipairs(t3) do
        local v12 = PlayerGui:FindFirstChild(v11[1])

        if v12 and v12:IsA("LayerCollector") and v12.Enabled then
            local v13 = v12:FindFirstChild(v11[2], true)

            if v13 and v13:IsA("GuiObject") and v13.Visible then
                n2 = math.max(n2, v13.AbsolutePosition.Y + v13.AbsoluteSize.Y)
            end
        end
    end

    if n2 > 0 then
        v6 = math.max(v6, n2 + 18)
    end

    local v16 = if v5 then 74 else 130

    return (math.clamp(v6, v16, (math.max(v16, v4.Y - (if v5 then 150 else 260)))))
end

local function playGlobalMessageSound() -- line: 74
    -- upvalues: SoundService (copy)
    local GlobalMessage = SoundService:FindFirstChild("GlobalMessage")

    if GlobalMessage and GlobalMessage:IsA("Sound") then
        local Sfx = SoundService:FindFirstChild("Sfx")

        if Sfx and Sfx:IsA("SoundGroup") and GlobalMessage.SoundGroup ~= Sfx then
            GlobalMessage.SoundGroup = Sfx
        end

        GlobalMessage.TimePosition = 0
        GlobalMessage:Play()
    end
end

local function removeRecord(p3) -- line: 87
    -- upvalues: t2 (copy)
    for v19, v20 in ipairs(t2) do
        if v20 == p3 then
            table.remove(t2, v19)

            return
        end
    end
end

local function dismiss(p4, p5, p6) -- line: 96
    -- upvalues: TweenService (copy), removeRecord (copy)
    if p4.dismissed then
        return
    end

    p4.dismissed = true

    for _, v21 in ipairs(p4.accentTweens or {}) do
        v21:Cancel()
    end

    if not p6 then
        removeRecord(p4)
    end

    local item = p4.item

    if item and item.Parent then
        if p5 then
            item:Destroy()
        else
            local MotionScale = item:FindFirstChild("MotionScale")
            local tween = TweenService:Create(item, TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                GroupTransparency = 1
            })

            if MotionScale and MotionScale:IsA("UIScale") then
                TweenService:Create(MotionScale, TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                    Scale = 0.97
                }):Play()
            end

            tween:Play()
            tween.Completed:Wait()

            if item.Parent then
                item:Destroy()
            end
        end
    end
end

local function startRainbow(p7) -- line: 138
    -- upvalues: TweenService (copy), v2 (copy)
    local t4 = {}

    for _, v22 in ipairs(p7) do
        local RainbowGradient = v22:FindFirstChild("RainbowGradient")

        if RainbowGradient and RainbowGradient:IsA("UIGradient") then
            RainbowGradient.Enabled = true
            RainbowGradient.Offset = Vector2.new(-0.5, 0)

            local tween = TweenService:Create(RainbowGradient, v2, {
                Offset = Vector2.new(0.5, 0)
            })

            table.insert(t4, tween)
            tween:Play()
        end
    end

    return t4
end

local function fitLabels(p8, p9, p10, p11, p12, p13) -- line: 155
    -- upvalues: TextService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v23 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    local v24 = v23.X < 760 or v23.Y < 520
    local v25 = if v24 then 0.86 elseif v23.X < 900 then 0.9 else 0.82
    local v28 = math.clamp(math.floor(v23.X * v25), 260, 1100)
    local v29 = math.min(p10.TextSize, p11.TextSize)
    local v30 = if v24 then 16 elseif v23.X < 900 then 18 else 24
    local UIListLayout = p9:FindFirstChildOfClass("UIListLayout")

    p10.LayoutOrder = 1
    p11.LayoutOrder = 2
    p10.TextXAlignment = Enum.TextXAlignment.Center
    p10.TextYAlignment = Enum.TextYAlignment.Center
    p11.TextXAlignment = Enum.TextXAlignment.Center
    p11.TextYAlignment = Enum.TextYAlignment.Center

    if v24 then
        local v31 = math.clamp(v29, v30, 20)
        local v32 = v31 + 8
        local TextSize = TextService:GetTextSize(p13, v31, p11.Font, Vector2.new(v28, 1000))
        local v33 = v31 * 3 + 12
        local v36 = math.clamp(math.ceil(TextSize.Y) + 6, v31 + 8, v33)
        local v37 = v32 + v36 + 4

        if UIListLayout then
            UIListLayout.FillDirection = Enum.FillDirection.Vertical
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout.Padding = UDim.new(0, 2)
        end

        p9.Size = UDim2.fromOffset(v28, v37)
        p10.TextSize = v31
        p10.AutomaticSize = Enum.AutomaticSize.None
        p10.Size = UDim2.fromOffset(v28, v32)
        p10.TextWrapped = false
        p10.TextTruncate = Enum.TextTruncate.AtEnd
        p11.TextSize = v31
        p11.AutomaticSize = Enum.AutomaticSize.None
        p11.Size = UDim2.fromOffset(v28, v36)
        p11.TextWrapped = true
        p11.TextTruncate = Enum.TextTruncate.AtEnd
        p8.Size = UDim2.new(1, 0, 0, v37 + 8)

        local FadeCard = p8:FindFirstChild("FadeCard")

        if FadeCard and FadeCard:IsA("GuiObject") then
            FadeCard.Size = UDim2.fromOffset(v28 + 20, v37 + 4)
        end
    else
        if UIListLayout then
            UIListLayout.FillDirection = Enum.FillDirection.Horizontal
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout.Padding = UDim.new(0, 8)
        end

        local function measure(p14, p15, p16) -- line: 216
            -- upvalues: TextService (copy)
            return TextService:GetTextSize(p15, p16, p14.Font, Vector2.new(10000, 60)).X
        end

        local X = TextService:GetTextSize(p12, v29, p10.Font, Vector2.new(10000, 60)).X
        local X2 = TextService:GetTextSize(p13, v29, p11.Font, Vector2.new(10000, 60)).X
        local v38 = X + X2 + 8

        if v28 < v38 then
            v29 = math.max(v30, (math.floor(v29 * v28 / v38)))
            X = TextService:GetTextSize(p12, v29, p10.Font, Vector2.new(10000, 60)).X
            X2 = TextService:GetTextSize(p13, v29, p11.Font, Vector2.new(10000, 60)).X
        end

        p10.TextSize = v29
        p11.TextSize = v29

        local v41, v42

        if X + X2 + 8 <= v28 then
            v41 = math.ceil(X)
            v42 = math.ceil(X2)
        else
            v41 = math.min(X, (math.floor(v28 * 0.34)))
            v42 = math.max(120, v28 - v41 - 8)
        end

        p10.AutomaticSize = Enum.AutomaticSize.None
        p10.Size = UDim2.fromOffset(v41, 52)
        p10.TextTruncate = Enum.TextTruncate.AtEnd
        p11.AutomaticSize = Enum.AutomaticSize.None
        p11.Size = UDim2.fromOffset(v42, 52)
        p11.TextTruncate = Enum.TextTruncate.AtEnd
    end
end

local function showAnnouncement(p17, p18, p19, p20) -- line: 260
    -- upvalues: TweenService (copy), Workspace (copy), t2 (copy), n1 (ref), v1 (copy), AnnouncementStack (copy), AnnouncementTemplate (copy), getAnnouncementY (copy), playGlobalMessageSound (copy), dismiss (copy), startRainbow (copy), fitLabels (copy)
    local v47 = tostring(p17 or "Admin")
    local v49 = tostring(p18 or "")
    local v51 = tostring(p19 or "")

    if v49 == "" then
        return
    end

    AnnouncementStack.Position = UDim2.new(0.5, 0, 0, (getAnnouncementY()))
    n1 += 1

    local clone = AnnouncementTemplate:Clone()

    clone.Name = "Announcement"
    clone.LayoutOrder = n1
    clone.GroupTransparency = 1
    clone.Visible = true

    local Line = clone:WaitForChild("Line")
    local Sender = Line:WaitForChild("Sender")
    local Body = Line:WaitForChild("Body")
    local MotionScale = clone:WaitForChild("MotionScale")
    local v53 = tostring(v47 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")
    local v54 = v47 .. v1 .. ":"

    Sender.Text = string.format("<font color=\"#FF4F87\">%s%s:</font>", v53, v1)
    Body.Text = v49

    if v51 == "Rainbow" then
        Sender.Text = v54
        Sender.TextColor3 = Color3.new(1, 1, 1)
        Body.TextColor3 = Color3.new(1, 1, 1)
    end

    fitLabels(clone, Line, Sender, Body, v54, v49)
    MotionScale.Scale = 0.96
    clone.Parent = AnnouncementStack

    local t5 = {
        dismissed = false,
        item = clone,
        accentTweens = {}
    }

    if v51 == "Rainbow" then
        t5.accentTweens = startRainbow({ Sender, Body })
    end

    table.insert(t2, t5)

    local CurrentCamera = Workspace.CurrentCamera
    local v55 = if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1280, 720)
    local v56 = v55.X < 760 or v55.Y < 520
    local v57 = if v56 then 2 else 4

    while v57 < #t2 do
        local v58 = table.remove(t2, 1)

        task.spawn(dismiss, v58, v56, true)
    end

    if p20 ~= false then
        playGlobalMessageSound()
    end

    TweenService:Create(MotionScale, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
    TweenService:Create(clone, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        GroupTransparency = 0
    }):Play()
    task.delay(4.5, function() -- line: 333
        -- upvalues: t5 (copy), dismiss (copy)
        dismiss(t5, false)
    end)
end

function t1.Show(p21, p22, p23, p24) -- line: 338
    -- upvalues: showAnnouncement (copy)
    showAnnouncement(p21, p22, p23, p24)
end

function t1.Initialize(_) -- line: 342
    -- upvalues: ReplicatedStorage (copy), AdminAnnouncementGui (copy), AnnouncementStack (copy), AnnouncementTemplate (copy), showAnnouncement (copy)
    if AdminAnnouncementGui:GetAttribute("AdminAnnouncementBound") then
        return
    end

    AdminAnnouncementGui:SetAttribute("AdminAnnouncementBound", true)
    AnnouncementStack.Visible = true
    AnnouncementTemplate.Visible = false
    AnnouncementTemplate.GroupTransparency = 1
    task.spawn(function() -- line: 352
        -- upvalues: ReplicatedStorage (copy), showAnnouncement (copy)
        local v59 = ReplicatedStorage:WaitForChild("Remotes", 60)
        local v60 = v59 and v59:WaitForChild("AdminAnnouncement", 60)

        if v60 and v60:IsA("RemoteEvent") then
            v60.OnClientEvent:Connect(function(p26, _, p28, p29, p30) -- line: 356
                -- upvalues: showAnnouncement (copy)
                showAnnouncement(p26, p28, p29, p30)
            end)
        else
            warn("[AdminAnnouncementController] AdminAnnouncement remote not found.")
        end
    end)
end

return t1
