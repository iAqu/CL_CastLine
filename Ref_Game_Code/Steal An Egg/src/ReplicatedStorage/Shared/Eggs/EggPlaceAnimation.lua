-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local EggActionMovement = require(script.Parent.EggActionMovement)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local v1 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.12, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
local v6 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v7 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v8 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1 = {
    Color3.fromRGB(101, 67, 33),
    Color3.fromRGB(92, 60, 28),
    Color3.fromRGB(110, 75, 40),
    Color3.fromRGB(85, 55, 25)
}
local t2 = {}

function t2.CreateDirtChunk(p1, p2, p3) -- line: 45
    -- upvalues: Debris (copy), TweenService (copy), t (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), t1 (copy)
    t.strict(t.Instance)(p1)
    t.strict(t.Vector3)(p2)
    t.strict(t.number)(p3)

    local Part = Instance.new("Part")
    local v9 = math.random(25, 45) / 100 * p3

    Part.Size = Vector3.new(v9, v9 * 0.7, v9)
    Part.Color = t1[math.random(1, #t1)]
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CastShadow = false
    Part.Transparency = 0
    Part.Position = p2 + Vector3.new(0, 0.05, 0)
    Part.Orientation = Vector3.new(math.random(-30, 30), math.random(-180, 180), math.random(-30, 30))
    Part.Parent = p1

    local v14 = math.rad((math.random(0, 360)))
    local v15 = math.random(30, 60) / 100 * p3
    local v16 = math.cos(v14) * v15
    local v17 = math.sin(v14) * v15
    local v21 = p2 + Vector3.new(v16 * 0.6, math.random(50, 90) / 100 * p3, v17 * 0.6)
    local v23 = p2 + Vector3.new(v16, p3 * 0.02, v17)
    local v25 = v23 + Vector3.new(0, p3 * -0.01, 0)
    local tween = TweenService:Create(Part, v4, {
        Position = v21,
        Orientation = Part.Orientation + Vector3.new(math.random(-45, 45), math.random(-90, 90), math.random(-45, 45))
    })

    tween:Play()
    tween.Completed:Once(function() -- line: 82
        -- upvalues: Part (copy), v9 (copy), v23 (copy), v25 (copy), Debris (copy), TweenService (copy), v5 (copy), v6 (copy), v7 (copy)
        local tween = TweenService:Create(Part, v5, {
            Position = v23,
            Size = Vector3.new(v9 * 1.1, v9 * 0.5, v9 * 1.1)
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 88
            -- upvalues: Part (copy), v9 (copy), v25 (copy), Debris (copy), TweenService (copy), v6 (copy), v7 (copy)
            local tween = TweenService:Create(Part, v6, {
                Position = v25,
                Size = Vector3.new(v9, v9 * 0.65, v9)
            })

            tween:Play()
            tween.Completed:Once(function() -- line: 94
                -- upvalues: Part (copy), Debris (copy), TweenService (copy), v7 (copy)
                task.delay(0.15, function() -- line: 95
                    -- upvalues: Part (copy), Debris (copy), TweenService (copy), v7 (copy)
                    TweenService:Create(Part, v7, {
                        Transparency = 1
                    }):Play()
                    Debris:AddItem(Part, v7.Time)
                end)
            end)
        end)
    end)
end

function t2.PlaySfx(p4) -- line: 106
    -- upvalues: Debris (copy), t (copy)
    t.strict(t.Instance)(p4)

    local Sound = Instance.new("Sound")

    Sound.SoundId = "rbxassetid://74146265484496"
    Sound.PlaybackSpeed = 1 + math.random(-10, 10) / 100
    Sound.Parent = p4
    Sound:Play()
    Sound.Ended:Once(function() -- line: 114
        -- upvalues: Sound (copy)
        Sound:Destroy()
    end)
    Debris:AddItem(Sound, 5)
end

function t2.SpawnDirtChunks(p5, p6, p7) -- line: 118
    -- upvalues: t (copy), t2 (copy)
    t.strict(t.Instance)(p5)
    t.strict(t.Vector3)(p6)
    t.strict(t.number)(p7)

    local v32 = math.random(6, 10)

    t2.CreateDirtChunk(p5, p6, p7)

    for i = 2, v32 do
        task.delay((i - 1) * 0.015, function() -- line: 132
            -- upvalues: p5 (copy), p6 (copy), p7 (copy), t2 (copy)
            t2.CreateDirtChunk(p5, p6, p7)
        end)
    end
end

function t2.CreateDirtDecal(p8, p9, p10) -- line: 137
    -- upvalues: Debris (copy), TweenService (copy), t (copy), v1 (copy), v2 (copy)
    t.strict(t.Instance)(p8)
    t.strict(t.Vector3)(p9)
    t.strict(t.number)(p10)

    local v33 = p10 * 0.1
    local v34 = p10 * 0.8
    local v35 = p10 * 1.6
    local v36 = p10 * 1.4000000000000001
    local Part = Instance.new("Part")

    Part.Name = "EggPlaceDirtDecal"
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(v33, v34, v34)
    Part.Color = Color3.fromRGB(101, 67, 33)
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Position = p9 - Vector3.new(0, 0.01, 0)
    Part.Orientation = Vector3.new(0, math.random(-180, 180), 90)
    Part.Parent = p8
    TweenService:Create(Part, v1, {
        Transparency = 0,
        Size = Vector3.new(v33, v35, v35)
    }):Play()
    task.delay(math.random(7, 11), function() -- line: 167
        -- upvalues: v33 (copy), v36 (copy), Part (copy), Debris (copy), TweenService (copy), v2 (copy)
        TweenService:Create(Part, v2, {
            Transparency = 1,
            Size = Vector3.new(v33, v36, v36)
        }):Play()
        Debris:AddItem(Part, v2.Time)
    end)
end

function t2.CreateImpactRing(p11, p12, p13) -- line: 176
    -- upvalues: Debris (copy), TweenService (copy), t (copy), v8 (copy)
    t.strict(t.Instance)(p11)
    t.strict(t.Vector3)(p12)
    t.strict(t.number)(p13)

    local Part = Instance.new("Part")

    Part.Name = "EggPlaceImpactRing"
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(p13 * 0.05, p13 * 0.3, p13 * 0.3)
    Part.Color = Color3.fromRGB(139, 90, 43)
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CastShadow = false
    Part.Transparency = 0.3
    Part.Position = p12 + Vector3.new(0, 0.02, 0)
    Part.Orientation = Vector3.new(0, 0, 90)
    Part.Parent = p11
    TweenService:Create(Part, v8, {
        Transparency = 1,
        Size = Vector3.new(p13 * 0.05, p13 * 1.8, p13 * 1.8)
    }):Play()
    Debris:AddItem(Part, 0.35)
end

function t2.Play(p14, p15, p16) -- line: 205
    -- upvalues: TweenService (copy), EggActionMovement (copy), Trove (copy), t (copy), v3 (copy), t2 (copy)
    t.strict(t.instanceIsA("Model"))(p14)
    t.strict(t.CFrame)(p15)
    t.strict(t.Instance)(p16)

    local PrimaryPart = p14.PrimaryPart

    t.strict(t.instanceIsA("BasePart"))(PrimaryPart)

    local v45 = math.max(math.min(PrimaryPart.Size.X, PrimaryPart.Size.Y, PrimaryPart.Size.Z), 0.1)
    local Position = p15.Position
    local v46 = p15.Position.Y + PrimaryPart.Size.Y * 0.1
    local v47 = false
    local v49 = p15 + Vector3.new(0, PrimaryPart.Size.Y * 2, 0)
    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = v49
    EggActionMovement.SetPivot(p14, v49)

    local v50 = Trove.new()

    v50:Add(CFrameValue)

    local function startImpactEffects() -- line: 226
        -- upvalues: p16 (copy), v45 (copy), Position (copy), v47 (ref), t2 (copy)
        if v47 then
            return
        end

        v47 = true
        t2.PlaySfx(p16)
        t2.SpawnDirtChunks(p16, Position, v45)
        t2.CreateDirtDecal(p16, Position, v45)
        t2.CreateImpactRing(p16, Position, v45)
    end

    v50:Add(CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 238
        -- upvalues: p14 (copy), v46 (copy), CFrameValue (copy), startImpactEffects (copy), EggActionMovement (copy)
        EggActionMovement.SetPivot(p14, CFrameValue.Value)

        if CFrameValue.Value.Position.Y <= v46 then
            startImpactEffects()
        end
    end))

    local tween = TweenService:Create(CFrameValue, v3, {
        Value = p15
    })

    tween:Play()
    tween.Completed:Once(function() -- line: 249
        -- upvalues: p14 (copy), p15 (copy), v50 (copy), startImpactEffects (copy), EggActionMovement (copy)
        EggActionMovement.SetPivot(p14, p15)
        startImpactEffects()
        v50:Destroy()
    end)
end

return t2
