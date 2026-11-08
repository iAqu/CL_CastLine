-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

game:GetService("StarterGui")

local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local GUI = require(ReplicatedStorage.Client.GUI)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)

require(ReplicatedStorage.Packages.Trove)

local v1 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2
local v3 = nil
local v4 = false

local function gui() -- line: 41
    -- upvalues: GUI (copy), v2 (ref)
    local v5 = v2

    if v5 then
        return v5
    end

    local v6 = GUI.BeanstalkEventUI()

    v2 = v6

    return v6
end

local function formatElapsed(p1) -- line: 51
    local v8 = math.max(math.floor(p1), 0)
    local v9 = v8 // 3600
    local v10 = v8 // 60 % 60

    if v9 > 0 then
        return string.format("%d:%02d:%02d", v9, v10, v8 % 60)
    end

    return string.format("%d:%02d", v10, v8 % 60)
end

local function placeTimer(p2) -- line: 61
    -- upvalues: v3 (ref)
    local Y = p2.AbsoluteSize.Y
    local Y2 = p2.AbsolutePosition.Y
    local v11 = Y * 0.01
    local Hearts = p2.WhaleProgress.Hearts

    for _, v12 in {
            p2.CurrentTask,
            p2.CatchFireFlies,
            p2.WaterBeanstalk,
            p2.WhaleProgress,
            Hearts,
            p2.Prompt
        } do
        local v13 = v12:IsA("TextLabel") and v12.Text == ""
        local Visible = v12.Visible and (v12 ~= Hearts or p2.WhaleProgress.Visible)

        if Visible and not v13 then
            v11 = math.max(v11, v12.AbsolutePosition.Y + v12.AbsoluteSize.Y - Y2 + Y * 0.01)
        end
    end

    local v15 = v3

    if v15 and v15.Parent and v15.Visible then
        local v17 = math.clamp(Y * 0.045, 30, 44)

        v15.Size = UDim2.fromOffset(v17 * 2 + 8, v17)
        v15.Position = UDim2.new(0.5, 0, 0, v11)
        v15.Hearts.Heart.Size = UDim2.new(0, v17, 1, 0)

        for _, child in v15.Hearts:GetChildren() do
            if child:IsA("ImageLabel") then
                child.Size = UDim2.new(0, v17, 1, 0)
            end
        end

        v11 += v17 + Y * 0.01
    end

    local v18 = UDim2.new(0.5, 0, 0, v11)

    if p2.Timer.Position ~= v18 then
        p2.Timer.Position = v18
    end
end

local function showTimer(p3) -- line: 104
    -- upvalues: Players (copy), Workspace (copy), BeanstalkEvent (copy), v4 (ref), placeTimer (copy)
    local Attribute = Players.LocalPlayer:GetAttribute(BeanstalkEvent.StartedAtAttribute)
    local Timer = p3.Timer

    if typeof(Attribute) == "number" then
        Timer.Visible = not v4
    else
        Timer.Visible = false
    end

    local Attribute2

    if typeof(Attribute) ~= "number" or v4 then
        return
    else
        placeTimer(p3)
        Attribute2 = Players.LocalPlayer:GetAttribute(BeanstalkEvent.FinishedAtAttribute)

        if typeof(Attribute2) ~= "number" then
            Attribute2 = Workspace:GetServerTimeNow()
        end
    end

    local v22 = math.max(math.floor(Attribute2 - Attribute), 0)
    local v23 = v22 // 3600
    local v24 = v22 // 60 % 60
    local v25 = if v23 > 0 then string.format("%d:%02d:%02d", v23, v24, v22 % 60) else string.format("%d:%02d", v24, v22 % 60)

    if p3.Timer.Text ~= v25 then
        p3.Timer.Text = v25
    end
end

local function hideCards(p4) -- line: 119
    p4.CatchFireFlies.Visible = false
    p4.WaterBeanstalk.Visible = false
    p4.WhaleProgress.Visible = false
end

return {
    Start = function(p5) -- Start | line: 129
        -- upvalues: RunService (copy), GUI (copy), HiddenUIHandler (copy), v2 (ref), v4 (ref), showTimer (copy)
        local v26 = v2

        if not v26 then
            v26 = GUI.BeanstalkEventUI()
            v2 = v26
        end

        local function refresh() -- line: 131
            -- upvalues: v26 (ref), HiddenUIHandler (copy)
            v26.Enabled = not HiddenUIHandler.IsHidden()
        end

        v26.Enabled = not HiddenUIHandler.IsHidden()
        p5:Connect(HiddenUIHandler.Changed, refresh)
        p5:Connect(RunService.Heartbeat, function() -- line: 136
            -- upvalues: v26 (ref), showTimer (copy)
            showTimer(v26)
        end)
        p5:Add(function() -- line: 139
            -- upvalues: v26 (ref), v4 (ref)
            v4 = false
            v26.Enabled = false
            v26.Timer.Visible = false
            v26.CurrentTask.Text = ""
            v26.CurrentTask.Visible = true
            v26.CatchFireFlies.Visible = false
            v26.WaterBeanstalk.Visible = false
            v26.WhaleProgress.Visible = false
            v26.Prompt.Visible = false
        end)
    end,
    Finish = function() -- Finish | line: 151
        -- upvalues: GUI (copy), v2 (ref), v4 (ref)
        local v27 = v2

        if not v27 then
            v27 = GUI.BeanstalkEventUI()
            v2 = v27
        end

        v4 = true
        v27.CurrentTask.Visible = false
        v27.Timer.Visible = false
    end,
    SetTask = function(p6) -- SetTask | line: 159
        -- upvalues: GUI (copy), v2 (ref)
        local v28 = v2

        if not v28 then
            v28 = GUI.BeanstalkEventUI()
            v2 = v28
        end

        v28.CatchFireFlies.Visible = false
        v28.WaterBeanstalk.Visible = false
        v28.WhaleProgress.Visible = false
        v28.CurrentTask.Visible = true
        v28.CurrentTask.Text = p6
    end,
    SetProgress = function(p7, p8, p9) -- SetProgress | line: 167
        -- upvalues: TweenService (copy), GUI (copy), v1 (copy), v2 (ref)
        local v29 = v2

        if not v29 then
            v29 = GUI.BeanstalkEventUI()
            v2 = v29
        end

        local v30 = if p7 == "CatchFireFlies" then v29.CatchFireFlies else v29.WaterBeanstalk

        v29.CurrentTask.Visible = false
        v29.CatchFireFlies.Visible = false
        v29.WaterBeanstalk.Visible = false
        v29.WhaleProgress.Visible = false
        v30.Visible = true
        v30.BarHolder.TextLabel.Text = ("%*/%*"):format(p8, p9)

        local Bar = v30.BarHolder.BarBG.Bar
        local Y = Bar.Size.Y

        TweenService:Create(Bar, v1, {
            Size = UDim2.new(p8 / p9, 0, Y.Scale, Y.Offset)
        }):Play()
    end,
    SetFlightProgress = function(p10) -- SetFlightProgress | line: 184
        -- upvalues: GUI (copy), v2 (ref)
        local v31 = v2

        if not v31 then
            v31 = GUI.BeanstalkEventUI()
            v2 = v31
        end

        local WhaleProgress = v31.WhaleProgress

        v31.CurrentTask.Visible = false
        v31.CatchFireFlies.Visible = false
        v31.WaterBeanstalk.Visible = false
        v31.WhaleProgress.Visible = false
        WhaleProgress.Visible = true

        local v32 = math.clamp(p10, 0, 1)
        local BarBG = WhaleProgress.BarHolder.BarBG
        local Bar = BarBG.Bar

        Bar.Size = UDim2.new(v32, 0, Bar.Size.Y.Scale, Bar.Size.Y.Offset)

        local X = WhaleProgress.AbsoluteSize.X

        if not (X > 0) then
            return
        end

        local v33 = BarBG.AbsolutePosition.X + BarBG.AbsoluteSize.X * v32
        local Whale = WhaleProgress.Whale

        Whale.Position = UDim2.new((v33 - WhaleProgress.AbsolutePosition.X) / X, 0, Whale.Position.Y.Scale, Whale.Position.Y.Offset)
    end,
    ShowSlideHearts = function(p11) -- ShowSlideHearts | line: 207
        -- upvalues: GUI (copy), v2 (ref), v3 (ref), placeTimer (copy)
        local v34 = v2

        if not v34 then
            v34 = GUI.BeanstalkEventUI()
            v2 = v34
        end

        local v35 = p11:Add(Instance.new("Frame"))

        v35.Name = "SlideHearts"
        v35.BackgroundTransparency = 1
        v35.AnchorPoint = Vector2.new(0.5, 0)
        v35.Size = UDim2.fromOffset(88, 40)
        v35.Position = UDim2.new(0.5, 0, 0.2, 0)

        for _, v36 in { "Hearts", "HeartsFx" } do
            local clone = v34.WhaleProgress[v36]:Clone()

            clone.AnchorPoint = Vector2.zero
            clone.Position = UDim2.fromScale(0, 0)
            clone.Size = UDim2.fromScale(1, 1)
            clone.Parent = v35
        end

        v35.Hearts.UIListLayout.Padding = UDim.new(0, 8)
        v35.Hearts.Heart.Size = UDim2.new(0, 40, 1, 0)
        v35.Parent = v34
        v3 = v35
        p11:Add(function() -- line: 226
            -- upvalues: v35 (copy), v3 (ref)
            if v3 == v35 then
                v3 = nil
            end
        end)
        placeTimer(v34)

        return v35
    end,
    SetPrompt = function(p12) -- SetPrompt | line: 235
        -- upvalues: GUI (copy), v2 (ref)
        local v37 = v2

        if not v37 then
            v37 = GUI.BeanstalkEventUI()
            v2 = v37
        end

        local Prompt = v37.Prompt

        Prompt.Visible = p12 ~= nil
        Prompt.Text = p12 or ""
    end
}
