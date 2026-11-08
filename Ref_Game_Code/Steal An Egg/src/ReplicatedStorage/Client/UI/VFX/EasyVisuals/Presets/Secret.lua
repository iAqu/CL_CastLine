-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function secretOutline(p1) -- line: 8
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = Layers.Paint(Host, {
        Palette = "Zebra",
        Rotation = 90,
        Drift = p1.Drift
    })
    local v2, v3

    if Layers.AcceptsEdge(Host) then
        v3 = Layers.Edge(Host, p1.Width)
        v2 = Layers.Paint(v3.outline, {
            Palette = "Zebra",
            StartPhase = 0.5,
            Rotation = 90,
            PhaseGoal = 0.5,
            Drift = p1.Drift
        })
    end

    return Layers.Result({ v1, v2, v3 })
end

return secretOutline
