-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function greenOutlineSpin(p1) -- line: 7
    -- upvalues: Layers (copy)
    local v1 = Layers.Edge(p1.Host, p1.Width)
    local v2 = Layers.Paint(v1.outline, {
        Palette = "Green",
        Alpha = Layers.AlphaStops("Green")
    })
    local v3 = Layers.Turn(v2, v1.outline, 5, p1.Drift)

    return Layers.Result({ v2, v1 }, { v3 })
end

return greenOutlineSpin
