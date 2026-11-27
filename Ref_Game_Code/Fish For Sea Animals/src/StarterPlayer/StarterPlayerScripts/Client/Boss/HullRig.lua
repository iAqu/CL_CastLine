-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t2 = {
    Leg1L = 0,
    Leg2R = 0,
    Leg3L = 0,
    Leg1R = 3.141592653589793,
    Leg2L = 3.141592653589793,
    Leg3R = 3.141592653589793
}
local t1 = {}

function t1.new(p1) -- line: 24
    -- upvalues: t2 (copy)
    local Pivot = p1:GetPivot()
    local t3 = {}

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v1 = Pivot:ToObjectSpace(descendant.CFrame)
            local v2 = descendant.Name:gsub("^Hullbreaker_", "")
            local Position = v1.Position
            local v3 = v2:match("^(Leg%d[LR])$")
            local v4 = "body"

            if v3 then
                v4 = "leg"
                Position = v1.Position + Vector3.new(0, descendant.Size.Y * 0.42, 0)
            elseif v2:match("^Claw[LR]$") then
                v4 = "claw"
                Position = v1.Position - Vector3.new(0, 0, descendant.Size.Z * 0.42)
            elseif v2 == "Jaw" then
                v4 = "jaw"
                Position = v1.Position + Vector3.new(0, descendant.Size.Y * 0.4, -descendant.Size.Z * 0.45)
            elseif v2 == "Propeller" then
                v4 = "prop"
            end

            table.insert(t3, {
                part = descendant,
                rel = v1,
                kind = v4,
                hinge = Position,
                side = v1.Position.X >= 0 and 1 or -1,
                phase = if v3 then t2[v3] + (tonumber(v3:sub(4, 4)) or 1) * 0.35 else 0
            })
        end
    end

    return {
        model = p1,
        pieces = t3,
        parts = {},
        cframes = {}
    }
end

local function about(p2, p3) -- line: 60
    return CFrame.new(p2) * p3 * CFrame.new(-p2)
end

function t1.pose(p4, p5, p6, p7) -- line: 65
    p7 = p7 or {}

    local v10 = p7.walk or 0
    local v11 = p7.speed or 1.2
    local v12 = p7.open or 0
    local v13 = p7.raise or 0
    local v14 = p7.jaw or 0
    local v15 = p7.limp or 0

    if p7.snap then
        local v16 = p6 * 1.3 % 1

        if v16 < 0.7 then
            v12 += v16 * 0.3
        else
            v12 *= 1 - (v16 - 0.7) / 0.3
        end
    end

    local parts, cframes = p4.parts, p4.cframes

    table.clear(parts)
    table.clear(cframes)

    for _, v17 in p4.pieces do
        local identity = CFrame.identity

        if v17.kind == "leg" then
            local v18 = p6 * v11 * 3.141592653589793 * 2 + v17.phase
            local v19 = math.sin(v18) * 0.55 * v10
            local v21 = math.max(0, (math.cos(v18))) * 0.35 * v10
            local v23 = v15 * (math.sin(p6 * 23 + v17.phase * 3) * 0.08 + 0.9)
            local hinge = v17.hinge
            local v24 = CFrame.Angles(v19, 0, v17.side * (v21 + v23))

            identity = CFrame.new(hinge) * v24 * CFrame.new(-hinge)
        elseif v17.kind == "claw" then
            local v25 = v17.side * (v12 * 0.45 - 0.05)
            local v28 = -v13 * 0.75 + v15 * 0.35 + math.sin(p6 * 2.1 + v17.side) * 0.04
            local hinge = v17.hinge
            local v29 = CFrame.Angles(v28, v25, 0)

            identity = CFrame.new(hinge) * v29 * CFrame.new(-hinge)
        elseif v17.kind == "jaw" then
            local hinge = v17.hinge
            local v30 = CFrame.Angles(v14 * 0.55 + v15 * 0.25, 0, 0)

            identity = CFrame.new(hinge) * v30 * CFrame.new(-hinge)
        elseif v17.kind == "prop" then
            local v31 = p6 * (p7.prop or 0.4) * 3.141592653589793 * 2
            local relPosition = v17.rel.Position
            local v32 = CFrame.Angles(0, 0, v31)

            identity = CFrame.new(relPosition) * v32 * CFrame.new(-relPosition)
        end

        table.insert(parts, v17.part)
        table.insert(cframes, p5 * identity * v17.rel)
    end

    workspace:BulkMoveTo(parts, cframes, Enum.BulkMoveMode.FireCFrameChanged)
end

function t1.clone(p8) -- line: 103
    local Assets = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
    local Bosses = Assets and Assets:FindFirstChild("Bosses")
    local Hullbreaker = Bosses and Bosses:FindFirstChild("Hullbreaker")

    if not Hullbreaker then
        return nil
    end

    local clone = Hullbreaker:Clone()

    clone:ScaleTo(p8)

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
        end
    end

    return clone
end

return t1
