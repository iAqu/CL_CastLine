-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local RarityDisplay = require(script.Parent:WaitForChild("RarityDisplay"))

local function glowOf(p1) -- line: 15
    if select(3, p1:ToHSV()) < 0.15 then
        return Color3.fromRGB(235, 235, 255)
    end

    return nil
end

function t1.Glows(p2) -- line: 19
    return (if select(3, p2:ToHSV()) < 0.15 then Color3.fromRGB(235, 235, 255) else nil) ~= nil
end

function t1.GradientOf(p3) -- line: 23
    local v1, v2, v3 = p3:ToHSV()

    if select(3, p3:ToHSV()) < 0.15 and Color3.fromRGB(235, 235, 255) then
        return ColorSequence.new(Color3.new(1, 1, 1))
    end

    if v2 < 0.15 then
        return ColorSequence.new(p3)
    end

    local v4, v5

    if v1 > 0.09 and v1 < 0.19 then
        v4 = Color3.fromHSV(v1 - 0.012, 1, 0.86)
        v5 = Color3.fromHSV(v1 + 0.01, 0.78, 1)
    elseif not (v1 > 0.5 and v1 < 0.72) then
        v4 = Color3.fromHSV((v1 - 0.035) % 1, math.min(1, v2 * 1.15), v3 * 0.78)
        v5 = Color3.fromHSV((v1 + 0.02) % 1, math.min(v2, 0.85), (math.min(1, v3 * 1.3)))
    else
        v4 = Color3.fromHSV(v1 + 0.03, 1, 0.8)
        v5 = Color3.fromHSV(v1 - 0.015, 0.8, 1)
    end

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, v4),
        ColorSequenceKeypoint.new(0.5, v5),
        ColorSequenceKeypoint.new(1, v4)
    })
end

function t1.StrokeOf(p4) -- line: 47
    local v11 = if select(3, p4:ToHSV()) < 0.15 then Color3.fromRGB(235, 235, 255) else nil

    if v11 then
        return v11
    end

    local v12, v13 = p4:ToHSV()

    if v13 < 0.15 then
        return Color3.fromRGB(30, 30, 30)
    end

    if not (v12 > 0.09 and v12 < 0.19) then
        return Color3.fromHSV(v12, math.max(v13, 0.9), 0.42)
    end

    return Color3.fromHSV(v12 - 0.02, 1, 0.42)
end

function t1.Apply(p5, p6) -- line: 57
    -- upvalues: t1 (copy)
    if not (if select(3, p6:ToHSV()) < 0.15 then Color3.fromRGB(235, 235, 255) else nil) or not p6 then
        p5.TextColor3 = Color3.new(1, 1, 1)
    else
        p5.TextColor3 = p6
    end

    local Grad = p5:FindFirstChild("Grad")

    if Grad then
        Grad.Color = t1.GradientOf(p6)
    end

    local UIStroke = p5:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = t1.StrokeOf(p6)
    end

    t1.Track(p5, p6)
end

local t2 = {
    PERIOD = 2,
    BREATHE = 2.1,
    FLICKER = 0.45,
    COLOR = Color3.fromRGB(106, 27, 216),
    BRIGHT = Color3.fromRGB(226, 196, 255),
    GLOW = Color3.fromRGB(42, 0, 79),
    GLOW_HI = Color3.fromRGB(120, 40, 210)
}

t1.SHIMMER = t2

local t3 = {
    COLOR = RarityDisplay.Celestial.color,
    BRIGHT = Color3.fromRGB(255, 252, 235),
    GLOW = Color3.fromRGB(92, 50, 0),
    GLOW_HI = Color3.fromRGB(235, 170, 40),
    PERIOD = t2.PERIOD,
    BREATHE = t2.BREATHE,
    FLICKER = t2.FLICKER
}
local t4 = {
    COLOR = Color3.fromRGB(36, 86, 214),
    BRIGHT = Color3.fromRGB(175, 232, 255),
    GLOW = Color3.fromRGB(2, 10, 40),
    GLOW_HI = Color3.fromRGB(28, 90, 200),
    PERIOD = t2.PERIOD,
    BREATHE = t2.BREATHE,
    FLICKER = t2.FLICKER
}

t1.TITAN = t4

local t5 = {
    COLOR = Color3.fromRGB(120, 6, 18),
    BRIGHT = Color3.fromRGB(255, 110, 70),
    GLOW = Color3.fromRGB(20, 0, 2),
    GLOW_HI = Color3.fromRGB(170, 15, 20),
    PERIOD = t2.PERIOD,
    BREATHE = t2.BREATHE,
    FLICKER = t2.FLICKER
}

t1.APEX = t5

local t6 = {
    COLOR = Color3.fromRGB(196, 16, 30),
    BRIGHT = Color3.fromRGB(255, 214, 170),
    GLOW = Color3.fromRGB(48, 0, 6),
    GLOW_HI = Color3.fromRGB(215, 40, 25),
    PERIOD = t2.PERIOD,
    BREATHE = t2.BREATHE,
    FLICKER = t2.FLICKER
}

t1.RED = t6

local t7 = {
    COLOR = Color3.fromRGB(26, 110, 48),
    BRIGHT = Color3.fromRGB(190, 255, 195),
    GLOW = Color3.fromRGB(2, 24, 8),
    GLOW_HI = Color3.fromRGB(30, 130, 58),
    PERIOD = t2.PERIOD,
    BREATHE = t2.BREATHE,
    FLICKER = t2.FLICKER
}

t1.JURASSIC_TITAN = t7

for _, v14 in ipairs({ t2, t3, t4, t6, t5, t7 }) do
    v14.seq = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v14.COLOR),
        ColorSequenceKeypoint.new(0.38, v14.COLOR),
        ColorSequenceKeypoint.new(0.5, v14.BRIGHT),
        ColorSequenceKeypoint.new(0.62, v14.COLOR),
        ColorSequenceKeypoint.new(1, v14.COLOR)
    })
    v14.flickSeq = NumberSequence.new(v14.FLICKER)
end

local function shimmerOf(p7) -- line: 144
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy)
    if p7 == t2.COLOR then
        return t2
    end

    if p7 == t3.COLOR then
        return t3
    end

    if p7 == t4.COLOR then
        return t4
    end

    if p7 == t6.COLOR then
        return t6
    end

    if p7 == t5.COLOR then
        return t5
    end

    return if p7 == t7.COLOR then t7 else nil
end

local v15 = NumberSequence.new(0)
local t8 = {}
local n1 = 0
local v16

local function step() -- line: 157
    -- upvalues: v15 (copy), t8 (copy)
    local elapsed = os.clock()

    for _, v17 in pairs(t8) do
        local cfg = v17.cfg
        local v18 = (elapsed + v17.seed) / cfg.PERIOD % 1

        v17.grad.Offset = Vector2.new(-1.3 + 2.6 * v18, 0)

        if v17.stroke then
            v17.stroke.Color = cfg.GLOW:Lerp(cfg.GLOW_HI, (math.sin((elapsed + v17.seed) * cfg.BREATHE) + 1) / 4)
        end

        local v23 = math.sin((elapsed + v17.seed) * 13.7) + math.sin((elapsed + v17.seed) * 7.3) > 1.7

        if v23 ~= v17.flick then
            v17.flick = v23
            v17.grad.Transparency = v23 and cfg.flickSeq or v15
        end
    end
end

local function drop(p8) -- line: 174
    -- upvalues: v15 (copy), t8 (copy), n1 (ref), v16 (ref)
    local v24 = t8[p8]

    if not v24 then
        return
    end

    t8[p8] = nil
    n1 -= 1
    v24.grad.Offset = Vector2.zero
    v24.grad.Transparency = v15

    if v24.gone then
        v24.gone:Disconnect()
    end

    if n1 == 0 and v16 then
        v16:Disconnect()
        v16 = nil
    end
end

function t1.IsShimmer(p9) -- line: 185
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy)
    local t9

    if p9 == t2.COLOR then
        t9 = t2
    elseif p9 == t3.COLOR then
        t9 = t3
    elseif p9 == t4.COLOR then
        t9 = t4
    elseif p9 == t6.COLOR then
        t9 = t6
    elseif p9 == t5.COLOR then
        t9 = t5
    elseif p9 == t7.COLOR then
        t9 = t7
    end

    return t9 ~= nil
end

function t1.Track(p10, p11) -- line: 189
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), v15 (copy), t8 (copy), n1 (ref), v16 (ref), step (copy)
    local v25

    if p11 then
        if p11 == t2.COLOR then
            v25 = t2
        elseif p11 == t3.COLOR then
            v25 = t3
        elseif p11 == t4.COLOR then
            v25 = t4
        elseif p11 == t6.COLOR then
            v25 = t6
        elseif p11 == t5.COLOR then
            v25 = t5
        elseif p11 == t7.COLOR then
            v25 = t7
        end
    else
        v25 = p11
    end

    if v25 then
        if not t8[p10] or t8[p10].cfg ~= v25 then
            local v26 = t8[p10]

            if v26 then
                t8[p10] = nil
                n1 -= 1
                v26.grad.Offset = Vector2.zero
                v26.grad.Transparency = v15

                if v26.gone then
                    v26.gone:Disconnect()
                end

                if n1 == 0 and v16 then
                    v16:Disconnect()
                    v16 = nil
                end
            end

            if game:GetService("RunService"):IsClient() then
                local Grad = p10:FindFirstChild("Grad")

                if not Grad then
                    Grad = Instance.new("UIGradient")
                    Grad.Name = "Grad"
                    Grad.Parent = p10
                end

                Grad.Color = v25.seq
                p10.TextColor3 = Color3.new(1, 1, 1)

                local UIStroke = p10:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v25.GLOW
                end

                t8[p10] = {
                    flick = false,
                    cfg = v25,
                    grad = Grad,
                    stroke = UIStroke,
                    seed = math.random() * 0.4
                }
                t8[p10].gone = p10.Destroying:Connect(function() -- line: 206
                    -- upvalues: p10 (copy), v15 (copy), t8 (copy), n1 (ref), v16 (ref)
                    local v28 = t8[p10]

                    if not v28 then
                        return
                    end

                    t8[p10] = nil
                    n1 -= 1
                    v28.grad.Offset = Vector2.zero
                    v28.grad.Transparency = v15

                    if v28.gone then
                        v28.gone:Disconnect()
                    end

                    if n1 == 0 and v16 then
                        v16:Disconnect()
                        v16 = nil
                    end
                end)
                n1 += 1
                v16 = v16 or game:GetService("RunService").RenderStepped:Connect(step)
            end
        end
    else
        local v29 = t8[p10]

        if v29 then
            t8[p10] = nil
            n1 -= 1
            v29.grad.Offset = Vector2.zero
            v29.grad.Transparency = v15

            if v29.gone then
                v29.gone:Disconnect()
            end

            if n1 == 0 and v16 then
                v16:Disconnect()
                v16 = nil
            end
        end
    end
end

return t1
