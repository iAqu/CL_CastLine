-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Layers = require(script.Parent.Parent.Layers)

local function matrixOutline(p1) -- line: 10
    -- upvalues: Layers (copy)
    local Host = p1.Host
    local v1 = Layers.Paint(Host, {
        Palette = "Matrix",
        Rotation = 90,
        Drift = p1.Drift
    })
    local v2 = Layers.Edge(Host, p1.Width)
    local v3 = Layers.Paint(v2.outline, {
        Palette = "Matrix",
        Rotation = 90,
        PhaseGoal = 0.5
    })

    task.delay(0.1, function() -- line: 27
        -- upvalues: p1 (copy), v3 (copy)
        v3:Drift(p1.Drift, 1)
    end)

    return Layers.Result({ v1, v3, v2 })
end

return matrixOutline
