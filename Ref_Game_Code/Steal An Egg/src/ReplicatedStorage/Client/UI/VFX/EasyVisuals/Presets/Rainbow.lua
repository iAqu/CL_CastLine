-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function rainbowWash(p1) -- line: 7
    -- upvalues: Layers (copy)
    local v1 = Layers.Paint(p1.Host, {
        Palette = "Rainbow",
        Rotation = 0,
        Drift = p1.Drift
    })

    return Layers.Result({ v1 })
end

return rainbowWash
