-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function wrapperWash(p1) -- line: 5
    -- upvalues: Layers (copy)
    local v1 = Layers.Paint(p1.Host, {
        Palette = p1.Color,
        Drift = p1.Drift
    })

    Layers.Replay(v1, p1.Chain)

    return Layers.Result({ v1 })
end

return wrapperWash
