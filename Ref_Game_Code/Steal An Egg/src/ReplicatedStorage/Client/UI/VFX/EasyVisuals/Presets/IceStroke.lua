-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function iceOutline(p1) -- line: 9
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = Layers.Paint(Host, {
        Palette = "Ice",
        Rotation = -65,
        Drift = p1.Drift
    })
    local v2 = Layers.Edge(Host, p1.Width)
    local v3 = Layers.Paint(v2.outline, {
        Palette = "Ice",
        Rotation = -61,
        Drift = p1.Drift * 0.23
    })

    return Layers.Result({ v1, v3, v2 })
end

return iceOutline
