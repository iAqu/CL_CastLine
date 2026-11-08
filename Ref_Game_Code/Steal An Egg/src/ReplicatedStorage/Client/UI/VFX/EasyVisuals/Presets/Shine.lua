-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function shineWash(p1) -- line: 9
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = p1.Color or Layers.HostColor(Host)
    local v2 = Layers.Paint(Host, {
        Rotation = 60,
        Palette = Layers.ShinePalette(v1, 0.417505),
        Drift = p1.Drift * 0.6
    })

    return Layers.Result({ v2 })
end

return shineWash
