-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function chromeOutline(p1) -- line: 9
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = Layers.Paint(Host, {
        Palette = "Chrome",
        Rotation = -90,
        Drift = p1.Drift
    })
    local v2, v3

    if Layers.AcceptsEdge(Host) then
        v3 = Layers.Edge(Host, p1.Width)
        v2 = Layers.Paint(v3.outline, {
            Palette = "Chrome",
            Rotation = -89,
            Drift = p1.Drift * 0.58
        })
    end

    return Layers.Result({ v1, v2, v3 })
end

return chromeOutline
