-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)
local t1 = {
    { 0, 0 },
    { 0.25, 1 },
    { 0.5, 1 },
    { 0.75, 1 },
    { 1, 0 }
}
local v4 = (function(p1) -- bandAlpha | line: 10
    local v1 = table.create(#p1)

    for v2, v3 in p1 do
        v1[v2] = NumberSequenceKeypoint.new(v3[1], v3[2])
    end

    return NumberSequence.new(v1)
end)(t1)

local function waveOutline(p2) -- line: 20
    -- upvalues: Layers (copy), v4 (copy)
    local Color = p2.Color
    local v5 = Layers.Edge(p2.Host, p2.Width)
    local v6 = Layers.Paint(v5.outline, {
        Palette = Layers.FlatPalette(Color),
        Alpha = v4,
        Drift = p2.Drift,
        AlphaDrift = p2.Drift * 0.9
    })

    return Layers.Result({ v6, v5 })
end

return waveOutline
