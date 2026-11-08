-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function ghostOutline(p1) -- line: 8
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local Ghost = Layers.AlphaStops("Ghost")
    local v1 = Layers.Paint(Host, {
        Palette = "Ghost",
        Alpha = Ghost,
        Drift = p1.Drift,
        AlphaDrift = p1.Drift * 0.9
    })
    local v2 = Layers.Edge(Host, p1.Width)
    local v3 = Layers.Paint(v2.outline, {
        Palette = "Ghost",
        Alpha = Ghost,
        Drift = -p1.Drift * 0.9,
        AlphaDrift = -p1.Drift * 0.9
    })

    return Layers.Result({ v1, v3, v2 })
end

return ghostOutline
