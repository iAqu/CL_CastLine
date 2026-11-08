-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function ghostWash(p1) -- line: 7
    -- upvalues: Layers (copy)
    local v1 = Layers.Paint(p1.Host, {
        Palette = "Ghost",
        Alpha = Layers.AlphaStops("Ghost"),
        Drift = p1.Drift,
        AlphaDrift = p1.Drift * 0.9
    })

    return Layers.Result({ v1 })
end

return ghostWash
