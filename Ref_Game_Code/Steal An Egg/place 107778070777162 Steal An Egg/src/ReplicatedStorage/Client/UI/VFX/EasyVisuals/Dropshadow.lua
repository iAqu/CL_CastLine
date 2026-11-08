-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local t = require(ReplicatedStorage.Packages.t)
local Heartbeat = RunService.Heartbeat
local v1 = Color3.new()
local v2 = UDim2.new(1, 0, 1, 0)
local v3 = Vector2.new(-4, 4)
local v4 = Vector2.new()
local t1 = {
    TextLabel = true,
    TextBox = true,
    TextButton = true
}
local t2 = {}

t2.__index = t2

local v5 = t.strict(t.union(t.instanceIsA("GuiObject"), t.instanceIsA("UIStroke")))
local v6 = t.strict(t.number)
local v7 = t.strict(t.Color3)
local v8 = t.strict(t.Vector2)

local function aim(p1, p2, p3) -- line: 53
    p1.goal = p2
    p1.response = math.clamp(p3, 0, 1)
end

local function stepLerpable(p4) -- line: 60
    p4.now = p4.now:Lerp(p4.goal, p4.response)

    return p4.now
end

local function stepNumber(p5) -- line: 65
    p5.now += (p5.goal - p5.now) * p5.response

    return p5.now
end

local function asPlacement(p6) -- line: 70
    return UDim2.new(0, p6.X, 0, p6.Y)
end

local function release(p7) -- line: 72
    p7.driver:Disconnect()

    if p7.shadow then
        p7.shadow:Destroy()
        p7.shadow = nil
    end
end

local function advance(p8) -- line: 81
    local tint = p8.tint

    tint.now = tint.now:Lerp(tint.goal, tint.response)

    local now = tint.now
    local offset = p8.offset

    offset.now = offset.now:Lerp(offset.goal, offset.response)

    local now2 = offset.now
    local v9 = UDim2.new(0, now2.X, 0, now2.Y)
    local alpha = p8.alpha

    alpha.now += (alpha.goal - alpha.now) * alpha.response

    local now3 = alpha.now
    local shadow = p8.shadow

    shadow.Position = v9

    if p8.isTextHost then
        shadow.Text = p8.host.Text
        shadow.TextTransparency = now3
        shadow.TextColor3 = now
    end

    shadow.ZIndex = p8.host.ZIndex - 1
end

function t2.new(p9, p10, p11, p12) -- line: 99
    -- upvalues: Heartbeat (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), t1 (copy), t2 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), advance (copy)
    v5(p9)

    if p10 then
        v7(p10)
    end

    if p11 then
        v6(p11)
    end

    if p12 then
        v8(p12)
    end

    local v10 = setmetatable({
        driver = nil,
        isPaused = false,
        host = p9,
        shadow = p9:Clone(),
        isTextHost = t1[p9.ClassName] == true,
        tint = {
            response = 1,
            now = p10 or v1,
            goal = p10 or v1
        },
        alpha = {
            response = 1,
            now = p11 or 0,
            goal = p11 or 0
        },
        offset = {
            response = 1,
            now = p12 or v3,
            goal = p12 or v4
        }
    }, t2)
    local shadow = v10.shadow

    shadow.Size = v2
    shadow:ClearAllChildren()

    local now = v10.offset.now

    shadow.Position = UDim2.new(0, now.X, 0, now.Y)

    if v10.isTextHost then
        shadow.TextColor3 = v10.tint.now
    end

    shadow.Parent = v10.host
    v10.driver = Heartbeat:Connect(function() -- line: 145
        -- upvalues: v10 (copy), advance (copy)
        debug.profilebegin("EasyVisuals/shadow")

        if not v10.isPaused then
            if not v10.host or v10.host.Parent == nil then
                v10.driver:Disconnect()

                if v10.shadow then
                    v10.shadow:Destroy()
                    v10.shadow = nil
                end
            else
                advance(v10)
                debug.profileend()
            end
        end
    end)

    return v10
end

function t2.Destroy(p13) -- line: 165
    p13.driver:Disconnect()

    if p13.shadow then
        p13.shadow:Destroy()
        p13.shadow = nil
    end
end

function t2.Suspend(p14) -- line: 167
    p14.isPaused = true
end

function t2.Wake(p15) -- line: 169
    p15.isPaused = false
end

function t2.EaseOffset(p16, p17, p18) -- line: 171
    -- upvalues: v6 (copy), v8 (copy)
    v8(p17)
    v6(p18)

    local offset = p16.offset

    offset.goal = p17
    offset.response = math.clamp(p18, 0, 1)
end

function t2.EaseAlpha(p19, p20, p21) -- line: 177
    -- upvalues: v6 (copy)
    v6(p20)
    v6(p21)

    local alpha = p19.alpha

    alpha.goal = p20
    alpha.response = math.clamp(p21, 0, 1)
end

function t2.EaseTint(p22, p23, p24) -- line: 183
    -- upvalues: v6 (copy), v7 (copy)
    v7(p23)
    v6(p24)

    local tint = p22.tint

    tint.goal = p23
    tint.response = math.clamp(p24, 0, 1)
end

return table.freeze(t2)
