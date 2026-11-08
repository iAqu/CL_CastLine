-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local t1 = {}
local t2 = {}
local t3 = {}

t3.__index = t3

local function slideSeconds(p1) -- line: 40
    local SlideSeconds = p1:GetAttribute("SlideSeconds")

    if typeof(SlideSeconds) == "number" then
        return SlideSeconds
    end

    return 0.3
end

local function enterInfo(p2) -- line: 45
    local new = TweenInfo.new
    local SlideSeconds = p2:GetAttribute("SlideSeconds")

    if typeof(SlideSeconds) ~= "number" then
        SlideSeconds = 0.3
    end

    return new(SlideSeconds, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function exitInfo(p3) -- line: 49
    local new = TweenInfo.new
    local SlideSeconds = p3:GetAttribute("SlideSeconds")

    if typeof(SlideSeconds) ~= "number" then
        SlideSeconds = 0.3
    end

    return new(SlideSeconds * 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
end

local function stop(p4) -- line: 53
    if p4.tween ~= nil then
        p4.tween:Cancel()
        p4.tween = nil
    end
end

local function offscreenDistance(p5, p6) -- line: 65
    local LayerCollector = p5.frame:FindFirstAncestorWhichIsA("LayerCollector")

    assert(LayerCollector ~= nil, (("%* must live under a ScreenGui to slide"):format((p5.frame:GetFullName()))))

    local v3 = p5.frame.Position.X.Offset - p5.home.X.Offset
    local v4 = p5.frame.AbsolutePosition.X - v3

    return math.max(LayerCollector.AbsoluteSize.X - v4, 0) + p6
end

local function awayPosition(p7, p8) -- line: 73
    -- upvalues: offscreenDistance (copy)
    return p7.home + UDim2.fromOffset(offscreenDistance(p7, p8), 0)
end

local function play(p9, p10, p11) -- line: 77
    -- upvalues: TweenService (copy)
    if p9.tween ~= nil then
        p9.tween:Cancel()
        p9.tween = nil
    end

    local tween = TweenService:Create(p9.frame, p11, {
        Position = p10
    })

    p9.tween = tween
    tween:Play()

    return tween
end

function t3.EscortFramesOf(p12) -- line: 87
    local t4 = {}

    for _, v6 in p12 do
        local Parent = v6.Parent

        if Parent ~= nil and Parent:IsA("GuiObject") and table.find(t4, Parent) == nil then
            table.insert(t4, Parent)
        end
    end

    return t4
end

function t3.new(p13, p14, p15) -- line: 98
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    local v7 = setmetatable({
        _open = nil,
        _generation = 0,
        _root = p13,
        _panel = {
            tween = nil,
            frame = p14,
            home = p14.Position
        },
        _escorts = {}
    }, t3)

    for _, v8 in p15 do
        local v9 = t1[v8]

        if v9 == nil then
            v9 = {
                tween = nil,
                frame = v8,
                home = v8.Position
            }
            t1[v8] = v9
            t2[v8] = 0
        end

        table.insert(v7._escorts, v9)
    end

    return v7
end

function t3.IsOpen(p16) -- line: 121
    return p16._open == true
end

function t3.SetOpen(p17, p18, p19) -- line: 125
    -- upvalues: TweenService (copy), t2 (copy), offscreenDistance (copy)
    if p17._open == p18 then
        return
    end

    p17._open = p18
    p17._generation += 1

    local _generation = p17._generation
    local frame = p17._panel.frame

    for _, v10 in p17._escorts do
        local v11 = t2[v10.frame]
        local v12 = if p18 then v11 + 1 else math.max(v11 - 1, 0)

        t2[v10.frame] = v12

        local v14 = v12 > 0

        if p19 then
            if v10.tween ~= nil then
                v10.tween:Cancel()
                v10.tween = nil
            end

            local frame = v10.frame

            if v14 then
                frame.Position = v10.home + UDim2.fromOffset(offscreenDistance(v10, 12), 0)
            else
                frame.Position = v10.home
            end
        elseif v14 then
            local v15 = v10.home + UDim2.fromOffset(offscreenDistance(v10, 12), 0)
            local new = TweenInfo.new
            local SlideSeconds = frame:GetAttribute("SlideSeconds")

            if typeof(SlideSeconds) ~= "number" then
                SlideSeconds = 0.3
            end

            local v16 = new(SlideSeconds * 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

            if v10.tween ~= nil then
                v10.tween:Cancel()
                v10.tween = nil
            end

            local tween = TweenService:Create(v10.frame, v16, {
                Position = v15
            })

            v10.tween = tween
            tween:Play()
        else
            local home = v10.home
            local new = TweenInfo.new
            local SlideSeconds = frame:GetAttribute("SlideSeconds")

            if typeof(SlideSeconds) ~= "number" then
                SlideSeconds = 0.3
            end

            local v17 = new(SlideSeconds, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            if v10.tween ~= nil then
                v10.tween:Cancel()
                v10.tween = nil
            end

            local tween = TweenService:Create(v10.frame, v17, {
                Position = home
            })

            v10.tween = tween
            tween:Play()
        end
    end

    local _panel = p17._panel
    local v18 = frame.AbsoluteSize.X * 0.3 + 12

    if p18 then
        local v19 = not p17._root.Enabled

        p17._root.Enabled = true

        if p19 then
            if _panel.tween ~= nil then
                _panel.tween:Cancel()
                _panel.tween = nil
            end

            _panel.frame.Position = _panel.home
        else
            if v19 then
                _panel.frame.Position = _panel.home + UDim2.fromOffset(offscreenDistance(_panel, v18), 0)
            end

            local home = _panel.home
            local new = TweenInfo.new
            local SlideSeconds = frame:GetAttribute("SlideSeconds")

            if typeof(SlideSeconds) ~= "number" then
                SlideSeconds = 0.3
            end

            local v20 = new(SlideSeconds, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            if _panel.tween ~= nil then
                _panel.tween:Cancel()
                _panel.tween = nil
            end

            local tween = TweenService:Create(_panel.frame, v20, {
                Position = home
            })

            _panel.tween = tween
            tween:Play()
        end
    elseif p19 then
        if _panel.tween ~= nil then
            _panel.tween:Cancel()
            _panel.tween = nil
        end

        _panel.frame.Position = _panel.home
        p17._root.Enabled = false
    else
        local v21 = _panel.home + UDim2.fromOffset(offscreenDistance(_panel, v18), 0)
        local new = TweenInfo.new
        local SlideSeconds = frame:GetAttribute("SlideSeconds")

        if typeof(SlideSeconds) ~= "number" then
            SlideSeconds = 0.3
        end

        local v22 = new(SlideSeconds * 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        if _panel.tween ~= nil then
            _panel.tween:Cancel()
            _panel.tween = nil
        end

        local tween = TweenService:Create(_panel.frame, v22, {
            Position = v21
        })

        _panel.tween = tween
        tween:Play()
        tween.Completed:Once(function(p20) -- line: 171
            -- upvalues: p17 (copy), _generation (copy), _panel (copy)
            if p17._generation ~= _generation or p20 ~= Enum.PlaybackState.Completed then
                return
            end

            _panel.tween = nil
            p17._root.Enabled = false
            _panel.frame.Position = _panel.home
        end)
    end
end

return t3
