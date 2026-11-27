-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animals = require(ReplicatedStorage.Shared.Animals)
local Config = require(ReplicatedStorage.Shared.Config)
local AuraKit = require(script.Parent.AuraKit)
local Vfx = require(script.Parent.Vfx)
local t1 = {}
local v1 = Config.RarityByName.Celestial.Index - 1
local t2 = {}

for _, v2 in { "AuraDefsSky", "AuraDefsCrystal", "AuraDefsDeep", "AuraDefsAtlantis", "AuraDefsStorm", "AuraDefsRift", "AuraDefsDeepSea" } do
    for v3, v4 in require(script.Parent:WaitForChild(v2)) do
        t2[v3] = v4
    end
end

local v5 = Random.new()

local function volume(p1) -- line: 37
    return p1.Size.X * p1.Size.Y * p1.Size.Z
end

local function pickBits(p2) -- line: 44
    local t3 = {}

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 0.9 then
            table.insert(t3, descendant)
        end
    end

    table.sort(t3, function(p3, p4) -- line: 51
        return p3.Size.X * p3.Size.Y * p3.Size.Z > p4.Size.X * p4.Size.Y * p4.Size.Z
    end)

    local v7 = table.move(t3, 1, math.min(#t3, 40), 1, {})
    local t4 = {}

    if #v7 == 0 then
        return t4, {}
    end

    table.insert(t4, (table.remove(v7, 1)))

    while #t4 < 10 and #v7 > 0 do
        local n1 = 1
        local n2 = -1

        for v9, v10 in v7 do
            local n3 = 1e999

            for _, v11 in t4 do
                n3 = math.min(n3, (v10.Position - v11.Position).Magnitude)
            end

            local v12 = n3 * (v10.Size.X * v10.Size.Y * v10.Size.Z) ^ 0.3333333333333333

            if n2 < v12 then
                n2 = v12
                n1 = v9
            end
        end

        table.insert(t4, (table.remove(v7, n1)))
    end

    local t5 = {}
    local n4 = 0

    for v14, v15 in t4 do
        t5[v14] = (v15.Size.X * v15.Size.Y * v15.Size.Z) ^ 0.6666666666666666
        n4 += t5[v14]
    end

    for v16 in t5 do
        t5[v16] /= n4
    end

    return t4, t5
end

function t1.has(p5) -- line: 86
    -- upvalues: t2 (copy)
    return t2[p5] ~= nil
end

function t1.make(p6, p7, p8) -- line: 92
    -- upvalues: Animals (copy), AuraKit (copy), Vfx (copy), v1 (copy), t2 (copy), pickBits (copy)
    local v17 = p6.Look and Animals.get(p6.Look) or p6
    local v18 = t2[v17.Id]

    if not v18 then
        return nil
    end

    local v20 = math.max(1, v17.RarityIndex - v1)
    local v21 = p8 * 0.45
    local v22 = p8 * 0.45
    local v23 = p8 * 0.8

    if p7 then
        local _, BoundingBox = p7:GetBoundingBox()

        v21 = BoundingBox.X
        v22 = BoundingBox.Y
        v23 = BoundingBox.Z
    end

    local v24 = Vfx.holder(CFrame.identity, (Vector3.new(v21, v22, v23)))
    local t6 = {
        placed = false,
        active = true,
        facing = Vector3.new(0, 0, -1),
        root = v24,
        movers = {},
        tickers = {},
        parts = { v24 },
        emitters = {}
    }
    local t7 = {
        v24
    }
    local t8 = {
        1
    }
    local v25 = t7
    local v26 = t8

    if p7 then
        v25, v26 = pickBits(p7)

        if not (#v25 > 0) then
            v26 = t8
            v25 = t7
        end
    end

    v18({
        aura = t6,
        body = v24,
        center = AuraKit.attach(v24, Vector3.new(0, 0, 0), "Center"),
        top = AuraKit.attach(v24, Vector3.new(0, v22 / 2, 0), "Top"),
        feet = AuraKit.attach(v24, Vector3.new(0, -v22 / 2 + 0.1, 0), "Feet"),
        bits = v25,
        shares = v26,
        size = p8,
        width = v21,
        height = v22,
        length = v23,
        k = (math.min(v20, 10) - 1) * 0.08 + 0.8,
        power = v20
    })

    return t6
end

function t1.move(p9, p10, p11, p12) -- line: 145
    -- upvalues: v5 (copy)
    if p12 then
        local v29 = p12 * Vector3.new(1, 0, 1)

        if v29.Magnitude > 0.001 then
            p9.facing = v29.Unit
        end
    end

    local v30 = CFrame.lookAlong(p10, p9.facing)

    p9.root.CFrame = v30

    for _, v31 in p9.movers do
        v31.update(v31.part, v30, p11)
    end

    if p9.active then
        for _, v32 in p9.tickers do
            if v32.nextAt < 0 then
                v32.nextAt = p11 + v32.period * v5:NextNumber(0.2, 1)
            elseif v32.nextAt <= p11 then
                v32.nextAt = p11 + v32.period * (1 + v32.jitter * v5:NextNumber(-1, 1))
                v32.fire(v30, p11)
            end
        end
    end

    if not p9.placed then
        p9.placed = true

        for _, v33 in p9.parts do
            for _, descendant in v33:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    descendant:Clear()
                end
            end
        end
    end
end

function t1.setActive(p13, p14) -- line: 181
    if p13.active == p14 then
        return
    end

    p13.active = p14

    local function set(p15) -- line: 186
        -- upvalues: p14 (copy)
        if p15:IsA("ParticleEmitter") or p15:IsA("Light") then
            p15.Enabled = p14
        end
    end

    for _, v34 in p13.parts do
        for _, descendant in v34:GetDescendants() do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Light") then
                descendant.Enabled = p14
            end
        end
    end

    for _, v35 in p13.emitters do
        if v35:IsA("ParticleEmitter") or v35:IsA("Light") then
            v35.Enabled = p14
        end
    end
end

function t1.destroy(p16) -- line: 201
    for _, v36 in p16.parts do
        v36:Destroy()
    end

    for _, v37 in p16.emitters do
        v37:Destroy()
    end
end

return t1
