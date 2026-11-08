-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local t = require(ReplicatedStorage.Packages.t)
local Heartbeat = RunService.Heartbeat
local ScaledSize = Enum.StrokeSizingMode.ScaledSize
local v1 = Color3.new(1, 1, 1)
local t1 = {
    TextLabel = true,
    TextBox = true,
    TextButton = true
}
local t2 = {}

t2.__index = t2

local v2 = t.strict(t.union(t.instanceIsA("GuiObject"), t.instanceIsA("UIStroke")))
local v3 = t.strict(t.number)
local v4 = t.strict(t.Color3)

local function track(p1) -- line: 49
    return {
        response = 1,
        now = p1,
        goal = p1
    }
end

local function aim(p2, p3, p4) -- line: 53
    p2.goal = p3
    p2.response = math.clamp(p4, 0, 1)
end

local function stepNumber(p5, p6) -- line: 58
    p5.now += (p5.goal - p5.now) * p5.response * p6

    return p5.now
end

local function stepColor(p7, p8) -- line: 63
    p7.now = p7.now:Lerp(p7.goal, p7.response * p8)

    return p7.now
end

local function borrowOutline(p9) -- line: 68
    local UIStroke = p9:FindFirstChildWhichIsA("UIStroke")

    if UIStroke then
        return UIStroke
    end

    return Instance.new("UIStroke")
end

local function release(p10) -- line: 76
    p10.driver:Disconnect()

    if p10.outline then
        p10.outline:Destroy()
        p10.outline = nil
    end
end

local function advance(p11, p12) -- line: 85
    -- upvalues: ScaledSize (copy)
    local outline, tint = p11.outline, p11.tint

    tint.now = tint.now:Lerp(tint.goal, tint.response * p12)
    outline.Color = tint.now

    local alpha = p11.alpha

    alpha.now += (alpha.goal - alpha.now) * alpha.response * p12
    outline.Transparency = alpha.now

    local width = p11.width

    width.now += (width.goal - width.now) * width.response * p12

    local now = width.now

    if outline.StrokeSizingMode ~= ScaledSize then
        outline.Thickness = now
    end
end

function t2.new(p13, p14, p15, p16) -- line: 97
    -- upvalues: Heartbeat (copy), ScaledSize (copy), v1 (copy), t1 (copy), t2 (copy), v2 (copy), v3 (copy), v4 (copy)
    v2(p13)
    v3(p14)

    if p15 then
        v4(p15)
    end

    if p16 then
        v3(p16)
    end

    local t3 = {
        driver = nil,
        isPaused = false,
        host = p13,
        outline = p13:FindFirstChildWhichIsA("UIStroke") or Instance.new("UIStroke"),
        isTextHost = t1[p13.ClassName] == true
    }

    p15 = p15 or v1
    t3.tint = {
        response = 1,
        now = p15,
        goal = p15
    }
    p16 = p16 or 0
    t3.alpha = {
        response = 1,
        now = p16,
        goal = p16
    }
    t3.width = {
        response = 1,
        now = p14,
        goal = p14
    }

    local v7 = setmetatable(t3, t2)

    v7.outline.Parent = v7.host
    v7.driver = Heartbeat:Connect(function(p17) -- line: 128
        -- upvalues: v7 (copy), ScaledSize (copy)
        debug.profilebegin("EasyVisuals/outline")

        if v7.isPaused then
            return
        end

        if not v7.host or v7.host.Parent == nil then
            v7.driver:Disconnect()

            if v7.outline then
                v7.outline:Destroy()
                v7.outline = nil
            end
        else
            local outline, tint = v7.outline, v7.tint

            tint.now = tint.now:Lerp(tint.goal, tint.response * p17)
            outline.Color = tint.now

            local alpha = v7.alpha

            alpha.now += (alpha.goal - alpha.now) * alpha.response * p17
            outline.Transparency = alpha.now

            local width = v7.width

            width.now += (width.goal - width.now) * width.response * p17

            local now = width.now

            if outline.StrokeSizingMode ~= ScaledSize then
                outline.Thickness = now
            end

            debug.profileend()
        end
    end)

    return v7
end

function t2.Destroy(p18) -- line: 148
    p18.driver:Disconnect()

    if p18.outline then
        p18.outline:Destroy()
        p18.outline = nil
    end
end

function t2.Suspend(p19) -- line: 150
    p19.isPaused = true
end

function t2.Wake(p20) -- line: 152
    p20.isPaused = false
end

function t2.EaseWidth(p21, p22, p23) -- line: 154
    -- upvalues: v3 (copy)
    v3(p22)
    v3(p23)

    local width = p21.width

    width.goal = p22
    width.response = math.clamp(p23, 0, 1)
end

function t2.EaseAlpha(p24, p25, p26) -- line: 160
    -- upvalues: v3 (copy)
    v3(p25)
    v3(p26)

    local alpha = p24.alpha

    alpha.goal = p25
    alpha.response = math.clamp(p26, 0, 1)
end

function t2.EaseTint(p27, p28, p29) -- line: 166
    -- upvalues: v3 (copy), v4 (copy)
    v4(p28)
    v3(p29)

    local tint = p27.tint

    tint.goal = p28
    tint.response = math.clamp(p29, 0, 1)
end

return table.freeze(t2)
