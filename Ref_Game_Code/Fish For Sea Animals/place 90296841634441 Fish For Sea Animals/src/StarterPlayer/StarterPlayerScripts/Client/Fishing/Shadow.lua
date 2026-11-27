-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local CastFlight = require(script.Parent.CastFlight)
local Effects = require(script.Parent.Effects)
local t2 = {
    "ParticleEmitter",
    "Light",
    "Beam",
    "Trail",
    "Fire",
    "Smoke",
    "Sparkles",
    "LayerCollector",
    "Highlight"
}
local t1 = {}

function t1.new(p1, p2, p3, p4, p5) -- line: 30
    -- upvalues: AnimalModel (copy), CastFlight (copy), Effects (copy), t2 (copy)
    local v1 = AnimalModel.clone(p1, p2, p4)

    if not v1 then
        return nil
    end

    for _, descendant in v1:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CastShadow = false
        end

        for _, v2 in t2 do
            if descendant:IsA(v2) then
                descendant:Destroy()
                break
            end
        end
    end

    v1.Parent = workspace

    local v3 = AnimalModel.rig(v1)

    v3.rainbow = nil

    local v6 = math.clamp(math.sqrt(5 / p2), 0.4, 1.7)

    v3.tempo = v6
    v3.sweep = math.clamp((p2 / 5) ^ 0.25, 1, 1.6)

    local _, BoundingBox = v1:GetBoundingBox()
    local v8 = v3.byRole.Jaw or v3.byRole.Head
    local v9 = if v8 then Vector3.new((v8.min.X + v8.max.X) / 2, (v8.min.Y + v8.max.Y) / 2, v8.max.Z * 0.95) else Vector3.new(0, 0, BoundingBox.Z / 2 * 0.95)
    local v15 = math.clamp((p2 / 6) ^ 0.6, 1, 12)
    local v16 = Effects.part({
        Name = "Hook",
        Shape = Enum.PartType.Ball,
        Size = Vector3.new(0.36, 0.36, 0.36) * v15,
        Color = Color3.fromRGB(190, 190, 200),
        Material = Enum.Material.Metal,
        Parent = workspace
    })
    local v17 = Effects.part({
        Name = "Worm",
        Size = Vector3.new(0.24, 0.8, 0.24) * v15,
        Color = Color3.fromRGB(255, 120, 150),
        Parent = v16
    })
    local v18

    if p5 and p5:FindFirstChild("Line") then
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = v16
        v18 = CastFlight.attachLine(p5.Line, Attachment)

        local v19 = v15 * 0.05
        local v20 = v15 * 0.05

        v18.Width0 = v19
        v18.Width1 = v20
    end

    return {
        depth = nil,
        lastNow = nil,
        lastCenter = nil,
        fled = nil,
        fleeTurn = nil,
        model = v1,
        rig = v3,
        hook = v16,
        worm = v17,
        baitLine = v18,
        baitScale = v15,
        mouth = v9,
        half = BoundingBox.Z / 2,
        deep = BoundingBox.Y / 2 + BoundingBox.Z * 0.13 * math.min(1, 8 / p2) + 1.8,
        size = p2,
        side = p3,
        tempo = v6,
        flip = math.random() < 0.5 and -1 or 1
    }
end

local function placeBait(p6, p7, p8) -- line: 95
    local v24 = p7 * CFrame.new(p6.mouth)
    local v26 = math.sin(p8 * 9) * 0.25

    p6.hook.CFrame = v24
    p6.worm.CFrame = v24 * CFrame.new(0, -0.25 * p6.baitScale, 0.2 * p6.baitScale) * CFrame.Angles(-0.6108652381980153, 0, v26)
end

function t1.update(p9, p10, p11, p12, p13, p14, p15, p16, p17) -- line: 105
    -- upvalues: AnimalModel (copy), t1 (copy), placeBait (copy)
    if p9.model.Parent then
        local size, tempo = p9.size, p9.tempo
        local v28 = math.clamp(p10 - (p9.lastNow or p10), 0, 0.1)

        p9.lastNow = p10

        local v30 = math.min(1, 8 / size)
        local v31 = if p16 == "won" then 1 else math.clamp(p13, 0, 1)
        local v32 = 1 - v31

        if p16 == "lost" then
            if p17 >= 0.9 then
                t1.destroy(p9)
            else
                if p9.baitLine then
                    p9.baitLine.Enabled = false
                end

                local v37 = CFrame.Angles(0, if p9.side > 0 then 0 else 3.141592653589793, 0) * CFrame.Angles(0, math.rad(180 + p9.flip * 30), 0) * CFrame.Angles(math.rad(v30 * 25), 0, 0)
                local v38 = -v37.LookVector
                local fled = p9.fled

                if not fled then
                    fled = p9.lastCenter

                    if not fled then
                        fled = Vector3.new(p12.X, p11 - p9.deep, p12.Z)
                    end
                end

                p9.fled = fled

                local v44 = p9.fled + v38 * 16 * math.max(1, size / 10) * p17 + Vector3.new(0, p17 * -3, 0)
                local v45 = CFrame.new(v44) * v37

                AnimalModel.pose(p9.rig, v45, p10, 1)
                placeBait(p9, v45, p10)
            end
        else
            local v46 = p9.deep * v32 ^ 1.5 + p15 * 0.6 * v32 - p14 * 0.35 * (1 - v31 * 0.5)

            p9.depth = if p9.depth then p9.depth + (v46 - p9.depth) * (1 - math.exp(-v28 * 7 * tempo)) else v46

            local v49 = (p15 + 0.6) * (1 - v31 * 0.5)
            local v53 = math.rad(p9.flip * (p15 * 25 + 35) + math.sin(p10 * (p15 * 3 + 2.2) * tempo) * 18 * v49)
            local v55 = math.rad((v31 ^ 1.5 * -25 + -15 + p15 * 25 * v32) * v30)
            local v56 = if p16 == "won" then 1 else p15 * 0.3 + 0.7
            local v57 = CFrame.Angles(0, if p9.side > 0 then 0 else 3.141592653589793, 0) * CFrame.Angles(0, v53, 0) * CFrame.Angles(v55, 0, 0)
            local v61 = math.sin(p10 * 1.4 * tempo + p9.flip) * math.min(size * 0.08, 3) * v32
            local v62 = v57:VectorToWorldSpace(p9.mouth)
            local v66 = Vector3.new(p12.X + v61 - v62.X, p11 - p9.depth, p12.Z - v62.Z)

            p9.lastCenter = v66

            local v67 = CFrame.new(v66) * v57

            AnimalModel.pose(p9.rig, v67, p10, v56)
            placeBait(p9, v67, p10)
        end
    end
end

function t1.destroy(p18) -- line: 162
    if not (p18 and p18.model) then
        return
    end

    p18.model:Destroy()
    p18.hook:Destroy()

    if p18.baitLine then
        p18.baitLine:Destroy()
    end
end

return t1
