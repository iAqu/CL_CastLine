-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function bubblegumOutline(p1) -- line: 11
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = Layers.Paint(Host, {
        Palette = "Bubblegum",
        Rotation = -90,
        Drift = p1.Drift
    })
    local v2 = Layers.Edge(Host, p1.Width)
    local v3 = Layers.Paint(v2.outline, {
        Palette = "Bubblegum",
        Rotation = -45,
        Drift = p1.Drift * 0.9
    })
    local v4 = Layers.Breathe(v2, p1.Width, p1.Width * 3, p1.Drift, 0.055)

    return Layers.Result({ v1, v3, v2 }, { v4 })
end

return bubblegumOutline
