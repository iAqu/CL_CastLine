-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function lavaWash(p1) -- line: 5
    -- upvalues: Layers (copy)
    local v1 = Layers.Paint(p1.Host, {
        Palette = "Lava",
        Drift = p1.Drift
    })

    return Layers.Result({ v1 })
end

return lavaWash
