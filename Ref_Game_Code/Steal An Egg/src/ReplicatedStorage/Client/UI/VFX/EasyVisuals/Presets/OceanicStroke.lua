-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function oceanicOutline(p1) -- line: 8
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = Layers.Paint(Host, {
        Palette = "Oceanic",
        Rotation = -75,
        Spin = 0.1,
        Drift = p1.Drift
    })
    local v2 = Layers.Edge(Host, p1.Width)
    local v3 = Layers.Paint(v2.outline, {
        Palette = "Oceanic",
        Drift = -p1.Drift
    })

    return Layers.Result({ v1, v3, v2 })
end

return oceanicOutline
