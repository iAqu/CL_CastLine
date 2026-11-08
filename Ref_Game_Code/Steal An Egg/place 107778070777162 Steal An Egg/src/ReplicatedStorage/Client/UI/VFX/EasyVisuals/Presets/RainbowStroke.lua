-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function rainbowOutlineDrift(p1) -- line: 5
    -- upvalues: Layers (copy)
    local v1 = Layers.Edge(p1.Host, p1.Width)
    local v2 = Layers.Paint(v1.outline, {
        Palette = "Rainbow",
        Drift = -p1.Drift
    })

    return Layers.Result({ v2, v1 })
end

return rainbowOutlineDrift
