-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function fireOutline(p1) -- line: 9
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = Layers.Paint(Host, {
        Palette = "Fire",
        Rotation = -75,
        Drift = p1.Drift
    })
    local v2 = Layers.Turn(v1, v1.gradient, 0, p1.Drift)
    local v3 = Layers.Edge(Host, p1.Width)
    local v4 = Layers.Paint(v3.outline, {
        Palette = "Fire",
        Rotation = 75,
        Drift = -p1.Drift
    })

    return Layers.Result({ v1, v4, v3 }, { v2 })
end

return fireOutline
