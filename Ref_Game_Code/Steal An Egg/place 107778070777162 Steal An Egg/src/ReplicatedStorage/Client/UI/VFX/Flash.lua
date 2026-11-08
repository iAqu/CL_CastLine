-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local OverlayRoot = require(script.Parent.OverlayRoot)
local t1 = {
    Attack = 0.5,
    Decay = 0.9,
    Opacity = 1,
    Tint = Color3.new(1, 1, 1)
}
local t2 = {
    style = Enum.EasingStyle.Quint,
    direction = Enum.EasingDirection.Out
}
local t3 = {
    style = Enum.EasingStyle.Cubic,
    direction = Enum.EasingDirection.InOut
}
local t4 = {}
local v1, connection

local function attach(p1) -- line: 48
    -- upvalues: OverlayRoot (copy), v1 (ref)
    local v2 = v1

    if not (v2 and v2.Parent) then
        task.spawn(function() -- line: 54
            -- upvalues: p1 (copy), OverlayRoot (copy), v1 (ref)
            local v3 = OverlayRoot()

            v1 = v3
            p1.Parent = v3
        end)
    else
        p1.Parent = v2
    end
end

local function sheetFor(p2) -- line: 61
    -- upvalues: OverlayRoot (copy), t4 (copy), v1 (ref)
    local v4 = p2:ToHex()
    local v5 = t4[v4]

    if v5 then
        return v5
    end

    local Frame = Instance.new("Frame")

    Frame.Name = ("Wash_%*"):format(v4)
    Frame.ZIndex = 500
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = p2
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Visible = false

    local t5 = {
        startedAt = 0,
        keys = nil,
        frame = Frame
    }

    t4[v4] = t5
    Frame.Destroying:Connect(function() -- line: 79
        -- upvalues: v4 (copy), t5 (copy), t4 (copy)
        if t4[v4] == t5 then
            t4[v4] = nil
        end
    end)

    local v6 = v1

    if not (v6 and v6.Parent) then
        task.spawn(function() -- line: 54
            -- upvalues: Frame (copy), OverlayRoot (copy), v1 (ref)
            local v7 = OverlayRoot()

            v1 = v7
            Frame.Parent = v7
        end)
    else
        Frame.Parent = v6
    end

    return t5
end

local function envelope(p3, p4) -- line: 88
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    local v8 = p4.Attack or t1.Attack
    local v9 = p4.Decay or t1.Decay
    local v11 = math.clamp(p4.Opacity or t1.Opacity, 0, 1)

    return {
        {
            at = 0,
            level = p3,
            style = t2.style,
            direction = t2.direction
        },
        {
            at = v8,
            level = v11,
            style = t2.style,
            direction = t2.direction
        },
        {
            level = 0,
            at = v8 + v9,
            style = t3.style,
            direction = t3.direction
        }
    }
end

local function levelAt(p5, p6) -- line: 100
    -- upvalues: TweenService (copy)
    for i = 2, #p5 do
        local v12 = p5[i]

        if p6 < v12.at then
            local v13 = p5[i - 1]
            local v14 = v12.at - v13.at
            local Value = TweenService:GetValue(if v14 > 0 then (p6 - v13.at) / v14 else 1, v12.style, v12.direction)

            return v13.level + (v12.level - v13.level) * Value, false
        end
    end

    return p5[#p5].level, true
end

local function step() -- line: 114
    -- upvalues: t4 (copy), connection (ref), levelAt (copy)
    local elapsed = os.clock()
    local v16 = false

    for _, v17 in t4 do
        local keys = v17.keys

        if keys ~= nil then
            local v18, v19 = levelAt(keys, elapsed - v17.startedAt)

            v17.frame.BackgroundTransparency = 1 - v18

            if v19 then
                v17.keys = nil
                v17.frame.Visible = false
            else
                v16 = true
            end
        end
    end

    if v16 or not connection then
        return
    end

    connection:Disconnect()
    connection = nil
end

local t6 = {
    Play = function(p7) -- Play | line: 139
        -- upvalues: RunService (copy), t1 (copy), connection (ref), sheetFor (copy), envelope (copy), step (copy)
        local v20 = sheetFor(p7.Tint or t1.Tint)

        v20.keys = envelope(1 - v20.frame.BackgroundTransparency, p7)
        v20.startedAt = os.clock()
        v20.frame.Visible = true

        if connection == nil then
            connection = RunService.Heartbeat:Connect(step)
        end

        step()
    end
}

return table.freeze(t6)
