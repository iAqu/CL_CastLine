-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Gradient = require(script.Parent.Gradient)
local GradientTemplates = require(script.Parent.GradientTemplates)
local Stroke = require(script.Parent.Stroke)
local Heartbeat = RunService.Heartbeat
local v1 = Color3.fromRGB(255, 255, 255)
local t1 = {
    0, 0.5, 1
}
local t2 = {
    TextButton = "BackgroundColor3",
    TextLabel = "TextColor3",
    ImageLabel = "ImageColor3",
    ImageButton = "ImageColor3",
    Frame = "BackgroundColor3",
    ScrollingFrame = "BackgroundColor3",
    ViewportFrame = "BackgroundColor3"
}
local t3 = {
    {
        field = "StartPhase",
        apply = function(p1, p2) -- apply | line: 59
            p1.phase.now = p2
        end
    },
    {
        field = "Rotation",
        apply = function(p3, p4) -- apply | line: 60
            p3:SetRotation(p4, 1)
        end
    },
    {
        field = "Spin",
        apply = function(p5, p6) -- apply | line: 61
            p5:Spin(p6, 1)
        end
    },
    {
        field = "PhaseGoal",
        apply = function(p7, p8) -- apply | line: 62
            p7:PhaseTo(p8, 1)
        end
    },
    {
        field = "Drift",
        apply = function(p9, p10) -- apply | line: 63
            p9:Drift(p10, 1)
        end
    },
    {
        field = "AlphaDrift",
        apply = function(p11, p12) -- apply | line: 64
            p11:AlphaDrift(p12, 1)
        end
    }
}
local v2 = table.freeze({})
local t4 = {}

local function paletteOf(p13) -- line: 71
    -- upvalues: GradientTemplates (copy)
    local Palette = p13.Palette

    if typeof(Palette) == "string" then
        return GradientTemplates[Palette].Color
    end

    return Palette
end

function t4.Paint(p14, p15) -- line: 76
    -- upvalues: Gradient (copy), GradientTemplates (copy), t3 (copy)
    local new = Gradient.new
    local Palette = p15.Palette

    if typeof(Palette) == "string" then
        Palette = GradientTemplates[Palette].Color
    end

    local v3 = new(p14, Palette, p15.Alpha or 0)

    for _, v4 in t3 do
        local v5 = p15[v4.field]

        if v5 then
            v4.apply(v3, v5)
        end
    end

    return v3
end

function t4.Edge(p16, p17) -- line: 89
    -- upvalues: Stroke (copy)
    return Stroke.new(p16, p17)
end

function t4.AcceptsEdge(p18) -- line: 95
    return not (p18:IsA("ImageLabel") and p18.BackgroundTransparency == 1)
end

function t4.AlphaStops(p19) -- line: 99
    -- upvalues: GradientTemplates (copy)
    return GradientTemplates[p19].Transparency
end

function t4.HostColor(p20) -- line: 105
    -- upvalues: v1 (copy), t2 (copy)
    return p20[t2[p20.ClassName]] or v1
end

function t4.FlatPalette(p21) -- line: 109
    -- upvalues: t1 (copy)
    local v6 = table.create(#t1)

    for v7, v8 in t1 do
        v6[v7] = ColorSequenceKeypoint.new(v8, p21)
    end

    return ColorSequence.new(v6)
end

function t4.ShinePalette(p22, p23) -- line: 117
    -- upvalues: v1 (copy)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, p22),
        ColorSequenceKeypoint.new(0.5, p22:Lerp(v1, p23)),
        ColorSequenceKeypoint.new(1, p22)
    })
end

function t4.Turn(p24, p25, p26, p27) -- line: 125
    -- upvalues: Heartbeat (copy)
    local connection

    connection = Heartbeat:Connect(function(p28) -- line: 134
        -- upvalues: p24 (copy), p25 (copy), p26 (ref), p27 (copy), connection (ref)
        if p25.Parent == nil then
            connection:Disconnect()
        end

        p26 += p27 * p28
        p24:SetRotation(p26, 1)
    end)

    return connection
end

function t4.Breathe(p29, p30, p31, p32, p33) -- line: 149
    -- upvalues: Heartbeat (copy)
    local connection

    connection = Heartbeat:Connect(function() -- line: 158
        -- upvalues: p29 (copy), p30 (copy), p31 (copy), p32 (copy), p33 (copy), connection (ref)
        if not p29.outline or p29.outline.Parent == nil then
            connection:Disconnect()
        else
            p29:EaseWidth(p30 * (p31 * math.sin(tick() * p32) + 1), p33)
        end
    end)

    return connection
end

function t4.Replay(p34, p35) -- line: 172
    -- upvalues: v2 (copy)
    local v13 = if typeof(p35) == "table" then p35 else v2

    for _, v14 in v13 do
        local v15 = p34[v14.Function]

        if typeof(v15) == "function" and typeof(v14.Package) == "table" then
            v15(p34, table.unpack(v14.Package))
        end
    end
end

function t4.Result(p36, p37) -- line: 183
    return {
        Effects = p36,
        Connections = p37
    }
end

return table.freeze(t4)
