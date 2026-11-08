-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function shineOutlineSpin(p1) -- line: 8
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = p1.Color or Layers.HostColor(Host)
    local v2 = Layers.Edge(Host, p1.Width)
    local v3 = Layers.Paint(v2.outline, {
        Palette = Layers.ShinePalette(v1, 0.6)
    })
    local v4 = Layers.Turn(v3, v2.outline, 0.75, p1.Drift)

    return Layers.Result({ v3, v2 }, { v4 })
end

return shineOutlineSpin
