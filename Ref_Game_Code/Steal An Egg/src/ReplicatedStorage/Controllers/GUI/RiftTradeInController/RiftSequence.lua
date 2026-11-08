-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local RiftTradeIn = ReplicatedStorage.Assets.VFX.RiftTradeIn
local Sounds = ReplicatedStorage.Assets.Sounds
local t1 = {
    -74, 10, 66
}
local t2 = {
    11.2, 10.2, 12
}
local t3 = {
    -3.2, 3.6, 0.2
}
local v1 = Color3.fromRGB(214, 168, 255)
local v2 = Color3.fromRGB(196, 130, 255)
local t4 = {}
local v3 = false

local function soundOf(p1) -- line: 56
    -- upvalues: Sounds (copy)
    local v4 = Sounds:FindFirstChild(p1) or Sounds:FindFirstChild(p1, true)

    if v4 == nil then
        return nil
    end

    if v4:IsA("Sound") then
        return v4
    end

    return v4:FindFirstChildWhichIsA("Sound")
end

local function cue(p2, p3, p4, p5) -- line: 67
    -- upvalues: Audio (copy), Sounds (copy)
    local v5 = Sounds:FindFirstChild(p2) or Sounds:FindFirstChild(p2, true)

    if v5 ~= nil and not v5:IsA("Sound") then
        v5 = v5:FindFirstChildWhichIsA("Sound")
    end

    if v5 then
        Audio.Play(v5, p3, {
            Volume = p4,
            PlaybackSpeed = p5
        })
    end
end

local function debris() -- line: 74
    -- upvalues: Workspace (copy)
    return (Workspace:WaitForChild("Transient"))
end

local function driveNumber(p6, p7, p8, p9, p10) -- line: 78
    -- upvalues: TweenService (copy)
    local NumberValue = Instance.new("NumberValue")

    NumberValue.Value = p7
    p6:Add(NumberValue)
    p6:Connect(NumberValue.Changed, p10)
    p10(p7)
    TweenService:Create(NumberValue, p9, {
        Value = p8
    }):Play()

    return NumberValue
end

local function isPortalFace(p11) -- line: 88
    return p11.Name:find("VoidPortal_Plane", 1, true) ~= nil and p11.Size.Y > p11.Size.Z
end

local function heartOf(p12) -- line: 92
    local v6 = Vector3.new(0, 0, 0)
    local n1 = 0

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name:find("VoidPortal_Plane", 1, true) ~= nil and descendant.Size.Y > descendant.Size.Z then
            v6 += descendant.Position
            n1 += 1
        end
    end

    return if n1 > 0 then v6 / n1 else nil
end

local function flatDiscBottom(p13) -- line: 107
    local v7

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name:find("VoidPortal_Plane", 1, true) ~= nil and (descendant.Name:find("VoidPortal_Plane", 1, true) == nil or not (descendant.Size.Y > descendant.Size.Z)) then
            local v8 = descendant.Position.Y - descendant.Size.Y * 0.5

            if v7 == nil or v8 < v7 then
                v7 = v8
            end
        end
    end

    return v7
end

local function normalizeGhost(p14) -- line: 120
    p14.PrimaryPart = nil

    local BoundingBox, BoundingBox2 = p14:GetBoundingBox()

    p14.WorldPivot = BoundingBox

    local v9 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)
    local v10 = if v9 > 0.01 then math.clamp(6.5 / v9, 0.05, 6) else 1

    p14:ScaleTo(v10)

    local _, BoundingBox3 = p14:GetBoundingBox()

    return v10, BoundingBox3.Y * 0.5
end

local function freeze(p15) -- line: 131
    if p15:IsA("BasePart") then
        p15.Anchored = true
        p15.CanCollide = false
        p15.CanQuery = false
        p15.CanTouch = false
    end

    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end
end

local function spawnPhase(p16, p17, p18, p19, p20) -- line: 148
    -- upvalues: Workspace (copy), RiftTradeIn (copy), heartOf (copy), flatDiscBottom (copy), freeze (copy)
    local clone = RiftTradeIn:FindFirstChild(p17):Clone()

    freeze(clone)
    clone:PivotTo(p18)

    local v12 = heartOf(clone)

    if v12 then
        clone:PivotTo(clone:GetPivot() + (p19 - v12))
    end

    if p20 then
        local v13 = flatDiscBottom(clone)

        if v13 then
            local v15 = math.clamp(p20 - v13, -4, 4)

            clone:PivotTo(clone:GetPivot() + Vector3.new(0, v15, 0))
        end
    end

    clone.Parent = Workspace:WaitForChild("Transient")
    p16:Add(clone)

    return clone
end

local function setRiftShown(p21, p22, p23) -- line: 168
    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p22 and 0 or 1
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") then
            if p22 then
                if p23[descendant] ~= nil then
                    descendant.Enabled = p23[descendant]
                else
                    descendant.Enabled = true
                end
            else
                descendant.Enabled = false
            end
        end
    end
end

local function ghostFor(p24) -- line: 182
    -- upvalues: ItemDisplay (copy), v1 (copy)
    local function v16() -- line: 183
        -- upvalues: p24 (copy), ItemDisplay (copy)
        return ItemDisplay.CreateActiveModel(nil, p24, true)
    end

    local ok, result = pcall(v16)

    if ok and result then
        return result
    end

    local Model = Instance.new("Model")
    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Ball
    Part.Size = Vector3.new(2.4, 2.4, 2.4)
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Anchored = true
    Part.CanCollide = false
    Part.Parent = Model
    Model.PrimaryPart = Part

    return Model
end

local function neonSurge(_, p26) -- line: 202
    -- upvalues: TweenService (copy), v1 (copy)
    for _, descendant in p26:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Material == Enum.Material.Neon then
            local Color = descendant.Color

            TweenService:Create(descendant, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Color = v1
            }):Play()
            task.delay(0.22, function() -- line: 207
                -- upvalues: descendant (copy), Color (copy), TweenService (copy)
                if descendant.Parent then
                    TweenService:Create(descendant, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Color = Color
                    }):Play()
                end
            end)
        end
    end
end

local function bezier(p27, p28, p29, p30) -- line: 216
    return p27:Lerp(p28, p30):Lerp(p28:Lerp(p29, p30), p30)
end

local function groundBurst(p31, p32) -- line: 222
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), VFX (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Particles = Assets and Assets:FindFirstChild("Particles")
    local BigHitGroundAttach = Particles and Particles:FindFirstChild("BigHitGroundAttach")

    if BigHitGroundAttach == nil then
        return
    end

    local Part = Instance.new("Part")

    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p32)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Parent = Workspace:WaitForChild("Transient")
    p31:Add(Part)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local clone = BigHitGroundAttach:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Parent = Attachment
        end
    end

    if clone:IsA("ParticleEmitter") then
        clone.Parent = Attachment
    else
        clone:Destroy()
    end

    VFX.EmitTree(Part, true)
end

function t4.IsPlaying() -- line: 256
    -- upvalues: v3 (ref)
    return v3
end

function t4.Play(p33, p34) -- line: 260
    -- upvalues: Players (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), Flash (copy), Shake (copy), Trove (copy), VFX (copy), RiftTradeIn (copy), Sounds (copy), t1 (copy), t2 (copy), t3 (copy), v2 (copy), v3 (ref), driveNumber (copy), heartOf (copy), flatDiscBottom (copy), normalizeGhost (copy), freeze (copy), spawnPhase (copy), setRiftShown (copy), ghostFor (copy), neonSurge (copy), bezier (copy), groundBurst (copy)
    if v3 then
        p34()
    else
        v3 = true
        task.spawn(function() -- line: 267
            -- upvalues: p33 (copy), p34 (copy), Players (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), Flash (copy), Shake (copy), Trove (copy), VFX (copy), RiftTradeIn (copy), Sounds (copy), t1 (copy), t2 (copy), t3 (copy), v2 (copy), v3 (ref), driveNumber (copy), heartOf (copy), flatDiscBottom (copy), normalizeGhost (copy), freeze (copy), spawnPhase (copy), setRiftShown (copy), ghostFor (copy), neonSurge (copy), bezier (copy), groundBurst (copy)
            local v17 = false

            local function deliver() -- line: 269
                -- upvalues: v17 (ref), p34 (copy)
                if not v17 then
                    v17 = true
                    task.spawn(p34)
                end
            end

            local v18 = Trove.new()
            local World = Workspace:FindFirstChild("World") and Workspace.World:FindFirstChild("Machines") and (Workspace.World.Machines:FindFirstChild("OldRiftMachine") or Workspace.World.Machines:FindFirstChild("RiftMachine"))

            if World then
                World = World:FindFirstChild("Rift")

                if World and World:IsA("Model") then
                    local World2 = World

                    local function v19() -- line: 287
                        -- upvalues: v17 (ref), v18 (copy), World2 (copy), p33 (copy), p34 (copy), Players (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), Flash (copy), Shake (copy), VFX (copy), RiftTradeIn (copy), Sounds (copy), t1 (copy), t2 (copy), t3 (copy), v2 (copy), driveNumber (copy), heartOf (copy), flatDiscBottom (copy), normalizeGhost (copy), freeze (copy), spawnPhase (copy), setRiftShown (copy), ghostFor (copy), neonSurge (copy), bezier (copy), groundBurst (copy)
                        local Pivot = World2:GetPivot()
                        local v20 = heartOf(World2) or Pivot:PointToWorldSpace((Vector3.new(0, 10.04, 0)))
                        local v21 = flatDiscBottom(World2)
                        local v22 = if v21 then v21 + 0.04 else nil

                        v21 = Pivot.LookVector * Vector3.new(1, 0, 1)

                        local v23 = if v21.Magnitude > 0.05 then v21.Unit else Vector3.new(0, 0, 1)
                        local t5 = {}

                        for _, descendant in World2:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") then
                                t5[descendant] = descendant.Enabled
                            end
                        end

                        setRiftShown(World2, false, t5)
                        v18:Add(function() -- line: 302
                            -- upvalues: t5 (copy), World2 (copy), setRiftShown (copy)
                            setRiftShown(World2, true, t5)
                        end)

                        local v24 = spawnPhase(v18, "Phase1", Pivot, v20, v22)

                        VFX.EmitTree(v24, true)
                        Shake.Play({
                            Seconds = 0.7,
                            Magnitude = 1.6
                        })

                        local v25 = Sounds:FindFirstChild("ImpactBoom") or Sounds:FindFirstChild("ImpactBoom", true)

                        if v25 ~= nil and not v25:IsA("Sound") then
                            v25 = v25:FindFirstChildWhichIsA("Sound")
                        end

                        if v25 then
                            Audio.Play(v25, v20, {
                                Volume = 0.9,
                                PlaybackSpeed = 0.75
                            })
                        end

                        v25 = Sounds:FindFirstChild("CinematicRiser") or Sounds:FindFirstChild("CinematicRiser", true)

                        if v25 ~= nil and not v25:IsA("Sound") then
                            v25 = v25:FindFirstChildWhichIsA("Sound")
                        end

                        if v25 then
                            Audio.Play(v25, v20, {
                                Volume = 0.6,
                                PlaybackSpeed = nil
                            })
                        end

                        local v26 = RaycastParams.new()

                        v26.FilterType = Enum.RaycastFilterType.Exclude
                        v25 = {
                            Workspace:WaitForChild("Transient"),
                            World2
                        }

                        local Character = Players.LocalPlayer.Character

                        if Character then
                            table.insert(v25, Character)
                        end

                        v26.FilterDescendantsInstances = v25

                        local t6 = {}

                        v25 = #p33

                        local v27, v28, v29, v30, lookAt, X, v31, X2, v32

                        for v33, v34 in p33 do
                            if v25 <= #t1 then
                                v27 = t1[v33]
                                v30 = t2[v33]
                                v32 = t3[v33]
                            else
                                v27 = (v33 - 1) * (160 / (v25 - 1)) + -80
                                v30 = v33 % 3 * 0.7 + 8.4
                                v32 = v33 * 2 % 5 + -2
                            end

                            v27 = v20 + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v27))) * v23 * v30 + Vector3.new(0, v32, 0)
                            v31 = v27.X
                            X = v20.Y + 14
                            v28 = Workspace:Raycast(Vector3.new(v31, X, v27.Z), Vector3.new(0, -80, 0), v26)
                            v32 = if v28 then v28.Position.Y else v20.Y - 6
                            v28 = ghostFor(v34)
                            v29, lookAt = normalizeGhost(v28)
                            v30 = v32 + lookAt + 0.2
                            lookAt = CFrame.lookAt
                            X = v27.X
                            X2 = v27.Z
                            v31 = Vector3.new(X, v30, X2)
                            lookAt = lookAt(v31, (Vector3.new(v20.X, v30, v20.Z)))
                            v31 = CFrame.lookAt
                            X2 = v20.X
                            v31 = v31(v27, (Vector3.new(X2, v27.Y, v20.Z)))
                            v28:PivotTo(lookAt)
                            v28.Parent = Workspace:WaitForChild("Transient")
                            v18:Add(v28)
                            table.insert(t6, {
                                fx = nil,
                                state = "ground",
                                model = v28,
                                hover = v31,
                                bobPhase = v33 * 2.3,
                                baseScale = v29
                            })
                        end

                        task.wait(0.55)

                        local v35 = spawnPhase(v18, "Phase2", Pivot, v20, v22)

                        Flash.Play({
                            Attack = 0.06,
                            Decay = 0.22,
                            Opacity = 0.45,
                            Tint = v2
                        })
                        v24:Destroy()

                        local v36 = v35

                        VFX.EmitTree(v35, true)
                        v25 = heartOf(v35) or v20
                        v35 = v35:FindFirstChildWhichIsA("BasePart", true)

                        local v37

                        if v35 then
                            v37 = Instance.new("Attachment")
                            v37.Parent = v35
                            v37.WorldPosition = v25
                        end

                        for v38, v39 in t6 do
                            local clone = RiftTradeIn:FindFirstChild("PetFX"):Clone()

                            freeze(clone)
                            clone.CFrame = v39.model:GetPivot()
                            clone.Parent = Workspace:WaitForChild("Transient")
                            v18:Add(clone)
                            v39.fx = clone

                            for _, descendant in clone:GetDescendants() do
                                if descendant:IsA("Beam") then
                                    if descendant.Attachment1 == nil then
                                        X = Instance.new("Attachment")
                                        X.Parent = clone
                                        descendant.Attachment1 = X
                                    end

                                    if v37 then
                                        descendant.Attachment0 = v37
                                    end
                                end
                            end

                            v32 = task.delay
                            v28 = v38 * 0.08
                            v32(v28, function() -- line: 386
                                -- upvalues: clone (copy), VFX (copy)
                                if clone.Parent then
                                    VFX.EmitTree(clone, true)
                                end
                            end)
                        end

                        v18:Connect(RunService.Heartbeat, function() -- line: 393
                            -- upvalues: t6 (copy)
                            for _, v40 in t6 do
                                if v40.state == "hover" and v40.model.Parent then
                                    local v41 = os.clock() * 2.4 + v40.bobPhase
                                    local v43 = v40.hover * CFrame.new(math.cos(v41 * 0.7) * 0.18, math.sin(v41) * 0.45, 0)

                                    v40.model:PivotTo(v43)

                                    if v40.fx and v40.fx.Parent then
                                        v40.fx.CFrame = v43
                                    end
                                end
                            end
                        end)

                        for v44, v45 in t6 do
                            v32 = task.delay
                            v28 = (v44 - 1) * 0.28
                            v32(v28, function() -- line: 407
                                -- upvalues: v44 (copy), v45 (copy), v18 (copy), Audio (copy), Sounds (copy), driveNumber (copy)
                                local model = v45.model

                                if model.Parent then
                                    local Pivot = model:GetPivot()
                                    local hoverPosition = v45.hover.Position
                                    local v46 = v44 * 0.06 + 1.1
                                    local v47 = Sounds:FindFirstChild("MechaShake") or Sounds:FindFirstChild("MechaShake", true)

                                    if v47 ~= nil and not v47:IsA("Sound") then
                                        v47 = v47:FindFirstChildWhichIsA("Sound")
                                    end

                                    if v47 then
                                        Audio.Play(v47, hoverPosition, {
                                            Volume = 0.35,
                                            PlaybackSpeed = v46
                                        })
                                    end

                                    driveNumber(v18, 0, 1, TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.Out), function(p35) -- line: 414
                                        -- upvalues: model (copy), Pivot (copy), v45 (copy)
                                        if model.Parent and v45.state == "ground" then
                                            local v49 = Pivot:Lerp(v45.hover, p35)

                                            model:PivotTo(v49)

                                            if v45.fx and v45.fx.Parent then
                                                v45.fx.CFrame = v49
                                            end
                                        end
                                    end)
                                    task.delay(0.9, function() -- line: 423
                                        -- upvalues: v45 (copy)
                                        if v45.state == "ground" then
                                            v45.state = "hover"
                                        end
                                    end)
                                end
                            end)
                        end

                        task.wait((#t6 - 1) * 0.28 + 0.9 + 1.15)

                        for v50, v51 in t6 do
                            v32 = task.delay
                            v28 = (v50 - 1) * 0.7
                            v32(v28, function() -- line: 434
                                -- upvalues: v36 (ref), v50 (copy), v51 (copy), v20 (copy), v18 (copy), TweenService (copy), Audio (copy), VFX (copy), Sounds (copy), driveNumber (copy), bezier (copy)
                                local model = v51.model

                                if model.Parent then
                                    v51.state = "pulling"

                                    local Pivot = model:GetPivot()
                                    local v52 = Pivot.Position:Lerp(v20, 0.45) + Vector3.new(0, 1.6, 0)

                                    if v51.fx then
                                        for _, descendant in v51.fx:GetDescendants() do
                                            if descendant:IsA("Beam") then
                                                TweenService:Create(descendant, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                                    Width0 = descendant.Width0 * 0.25,
                                                    Width1 = descendant.Width1 * 0.25
                                                }):Play()
                                            end
                                        end
                                    end

                                    driveNumber(v18, 0, 1, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p36) -- line: 449
                                        -- upvalues: model (copy), Pivot (copy), v52 (copy), v51 (copy), v20 (copy), bezier (copy)
                                        if model.Parent then
                                            local v54 = CFrame.new(bezier(Pivot.Position, v52, v20, p36)) * Pivot.Rotation

                                            model:PivotTo(v54)
                                            model:ScaleTo(v51.baseScale * math.max(1 - p36 * 0.7, 0.3))

                                            if v51.fx and v51.fx.Parent then
                                                v51.fx.CFrame = v54
                                            end
                                        end
                                    end)
                                    task.delay(0.85, function() -- line: 459
                                        -- upvalues: model (copy), v36 (ref), v50 (copy), v51 (copy), v20 (copy), Audio (copy), VFX (copy), Sounds (copy)
                                        local v56 = v50 * 0.12 + 0.9
                                        local v57 = Sounds:FindFirstChild("ImpactBoom") or Sounds:FindFirstChild("ImpactBoom", true)

                                        if v57 ~= nil and not v57:IsA("Sound") then
                                            v57 = v57:FindFirstChildWhichIsA("Sound")
                                        end

                                        if v57 then
                                            Audio.Play(v57, v20, {
                                                Volume = 0.7,
                                                PlaybackSpeed = v56
                                            })
                                        end

                                        if v36.Parent then
                                            VFX.EmitTree(v36, 6)
                                        end

                                        if v51.fx then
                                            v51.fx:Destroy()
                                        end

                                        model:Destroy()
                                    end)
                                end
                            end)
                        end

                        task.wait((#t6 - 1) * 0.7 + 0.85 + 0.35)

                        local Enabled = spawnPhase(v18, "Phase3", Pivot, v20, v22)

                        Flash.Play({
                            Attack = 0.08,
                            Decay = 0.3,
                            Opacity = 0.55,
                            Tint = v2
                        })
                        v36:Destroy()
                        v36 = Enabled
                        VFX.EmitTree(v36, true)
                        v37 = Sounds:FindFirstChild("CinematicRiser") or Sounds:FindFirstChild("CinematicRiser", true)

                        if v37 ~= nil and not v37:IsA("Sound") then
                            v37 = v37:FindFirstChildWhichIsA("Sound")
                        end

                        if v37 then
                            Audio.Play(v37, v20, {
                                Volume = 0.85,
                                PlaybackSpeed = 1.05
                            })
                        end

                        Shake.Play({
                            Seconds = 0.4,
                            Magnitude = 2.8
                        })
                        driveNumber(v18, 1, 1.12, TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p37) -- line: 481
                            -- upvalues: v36 (ref)
                            if v36.Parent then
                                v36:ScaleTo(p37)
                            end
                        end)
                        task.delay(1.54, function() -- line: 486
                            -- upvalues: v36 (ref), v18 (copy), VFX (copy), neonSurge (copy)
                            if v36.Parent then
                                neonSurge(v18, v36)
                                VFX.EmitTree(v36, true)
                            end
                        end)
                        task.wait(2.8)
                        Flash.Play({
                            Attack = 0.1,
                            Decay = 0.55,
                            Opacity = 0.9,
                            Tint = Color3.new(1, 1, 1)
                        })
                        Shake.Play({
                            Seconds = 1,
                            Magnitude = 2
                        })

                        local CinematicBoom = Sounds:FindFirstChild("CinematicBoom") or Sounds:FindFirstChild("CinematicBoom", true)

                        if CinematicBoom ~= nil and not CinematicBoom:IsA("Sound") then
                            CinematicBoom = CinematicBoom:FindFirstChildWhichIsA("Sound")
                        end

                        if CinematicBoom then
                            Audio.Play(CinematicBoom, v20, {
                                Volume = 1,
                                PlaybackSpeed = nil
                            })
                        end

                        v37 = spawnPhase(v18, "Phase4", Pivot, v20, v22)

                        local v58 = heartOf(v37) or v20

                        CinematicBoom = v37:FindFirstChild("EggSpawn", true)

                        if CinematicBoom then
                            v27 = Instance.new("Part")
                            v27.Size = Vector3.new(1, 1, 1)
                            v27.CFrame = CFrame.new(v58)
                            v27.Anchored = true
                            v27.CanCollide = false
                            v27.CanQuery = false
                            v27.CanTouch = false
                            v27.CastShadow = false
                            v27.Transparency = 1
                            v27.Parent = Workspace:WaitForChild("Transient")
                            v18:Add(v27)
                            CinematicBoom.Parent = v27

                            if CinematicBoom:IsA("Attachment") then
                                CinematicBoom.CFrame = CFrame.identity
                            end
                        else
                            v27 = nil
                        end

                        VFX.EmitTree(v37, true)

                        for v59, v60 in t5 do
                            if v59:IsA("ParticleEmitter") and v59.Parent then
                                v59.Enabled = v60
                            end
                        end

                        task.wait(0.3)

                        local clone = RiftTradeIn:FindFirstChild("Egg"):Clone()

                        freeze(clone)
                        clone.Parent = Workspace:WaitForChild("Transient")
                        v18:Add(clone)

                        local v61 = nil

                        v30 = nil

                        for _, descendant in clone:GetDescendants() do
                            if descendant:IsA("BasePart") and descendant.Transparency < 0.95 then
                                X = descendant.Size * 0.5
                                v61 = if v61 then v61:Min(descendant.Position - X) else descendant.Position - X
                                v30 = if v30 then v30:Max(descendant.Position + X) else descendant.Position + X
                            end
                        end

                        if v61 and v30 then
                            clone.WorldPivot = CFrame.new((v61 + v30) * 0.5)
                            v32 = (v30.Y - v61.Y) * 0.5
                        else
                            v32 = 2.4
                        end

                        v61 = Sounds:FindFirstChild("MechaHatch") or Sounds:FindFirstChild("MechaHatch", true)

                        if v61 ~= nil and not v61:IsA("Sound") then
                            v61 = v61:FindFirstChildWhichIsA("Sound")
                        end

                        if v61 then
                            Audio.Play(v61, v58, {
                                Volume = 0.9,
                                PlaybackSpeed = 1.1
                            })
                        end

                        if v27 then
                            VFX.EmitTree(v27, true)
                        end

                        v36:Destroy()
                        v36 = v37

                        local Heartbeat = Players.LocalPlayer.Character

                        v37 = Heartbeat and Heartbeat:FindFirstChild("HumanoidRootPart")
                        Heartbeat = if v37 then (v37.Position - v58) * Vector3.new(1, 0, 1) else v23

                        if Heartbeat.Magnitude > 0.05 then
                            v23 = Heartbeat.Unit
                        end

                        v28 = math.clamp(Heartbeat.Magnitude * 0.7, 8, 14)
                        v29 = v58.X + v23.X * v28
                        lookAt = v58.Y + 6
                        v31 = v58.Z + v23.Z * v28

                        local v62 = Vector3.new(v29, lookAt, v31)
                        local v63 = Workspace:Raycast(v62, Vector3.new(0, -90, 0), v26)

                        if v63 then
                            v26 = v63.Position
                        else
                            lookAt = v62.X
                            v31 = Pivot.Position.Y + 2.6
                            X = v62.Z
                            v26 = Vector3.new(lookAt, v31, X)
                        end

                        local v64 = v26 + Vector3.new(0, v32, 0)

                        clone:PivotTo(CFrame.new(v58))
                        clone:ScaleTo(0.45)
                        v32 = math.max(v58.Y, v64.Y) + 5

                        local v65 = Vector3.new(v58.X + v23.X * v28 * 0.55, v32 * 2 - (v58.Y + v64.Y) * 0.5, v58.Z + v23.Z * v28 * 0.55)

                        v29 = (Vector3.new(0, 1, 0)):Cross(v23)

                        local v66 = if v29.Magnitude > 0.001 then v29.Unit else Vector3.new(1, 0, 0)

                        driveNumber(v18, 0, 1, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), function(p38) -- line: 580
                            -- upvalues: v58 (copy), clone (copy), v64 (copy), v65 (copy), v66 (copy), bezier (copy)
                            if clone.Parent then
                                local v67 = 1 - (1 - p38) * (1 - p38)

                                clone:PivotTo(CFrame.new(bezier(v58, v65, v64, v67)) * CFrame.fromAxisAngle(v66, 12.566370614359172 * v67))
                                clone:ScaleTo((math.min(0.45 + 0.55 * p38 * 2, 1)))
                            end
                        end)
                        task.wait(0.9)

                        if clone.Parent then
                            clone:ScaleTo(1)
                            clone:PivotTo(CFrame.new(v64))
                        end

                        v23 = Sounds:FindFirstChild("ChestLanding") or Sounds:FindFirstChild("ChestLanding", true)

                        if v23 ~= nil and not v23:IsA("Sound") then
                            v23 = v23:FindFirstChildWhichIsA("Sound")
                        end

                        if v23 then
                            Audio.Play(v23, v64, {
                                Volume = 1,
                                PlaybackSpeed = nil
                            })
                        end

                        groundBurst(v18, v26)
                        Shake.Play({
                            Seconds = 1,
                            Magnitude = 0.5
                        })
                        Flash.Play({
                            Attack = 0.05,
                            Decay = 0.2,
                            Opacity = 0.4,
                            Tint = v2
                        })
                        driveNumber(v18, 0, 1, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), function(p39) -- line: 598
                            -- upvalues: clone (copy), v64 (copy)
                            if clone.Parent then
                                local v69 = 1 - p39
                                local v71 = math.sin(p39 * 3.141592653589793) * v69 * 1.4
                                local v73 = math.sin(p39 * 3.141592653589793 * 4) * v69 * 0.20943951023931956

                                clone:PivotTo(CFrame.new(v64 + Vector3.new(0, v71, 0)) * CFrame.Angles(0, 0, v73))
                            end
                        end)
                        task.wait(0.4)

                        if clone.Parent then
                            clone:PivotTo(CFrame.new(v64))
                        end

                        task.wait(0.3)

                        local Position = clone:GetPivot().Position

                        driveNumber(v18, 0, 1, TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), function(p40) -- line: 613
                            -- upvalues: clone (copy), Position (copy), Players (copy)
                            if clone.Parent then
                                local Character = Players.LocalPlayer.Character
                                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                local v74 = if HumanoidRootPart then HumanoidRootPart.Position + Vector3.new(0, 1.5, 0) else Position
                                local v75 = (Position + v74) * 0.5
                                local Magnitude = ((Position - v74) * Vector3.new(1, 0, 1)).Magnitude
                                local v77 = Vector3.new(v75.X, math.max(Position.Y, v74.Y) + Magnitude * 0.5 + 2.5, v75.Z)
                                local v78 = p40 * p40
                                local v79 = Position:Lerp(v77, v78):Lerp(v77:Lerp(v74, v78), v78)
                                local v80 = Vector3.new(v74.X, v79.Y, v74.Z)

                                clone:PivotTo(if (v79 - v80).Magnitude < 0.001 then CFrame.new(v79) else CFrame.lookAt(v79, v80))

                                local v83 = math.clamp((p40 - 0.55) / 0.45, 0, 1)

                                clone:ScaleTo((math.max(1 - v83 * v83 * v83, 0.01)))
                            end
                        end)
                        task.wait(0.6)
                        v21 = Players.LocalPlayer.Character
                        Pivot = v21 and v21:FindFirstChild("HumanoidRootPart")
                        v21 = if Pivot then Pivot.Position + Vector3.new(0, 1, 0) else Position
                        lookAt = RiftTradeIn:FindFirstChild("Aura"):Clone()
                        freeze(lookAt)
                        lookAt:PivotTo(CFrame.new(v21))
                        lookAt.Parent = Workspace:WaitForChild("Transient")
                        v18:Add(lookAt)

                        for _, descendant in lookAt:GetDescendants() do
                            if descendant:IsA("BasePart") then
                                descendant.LocalTransparencyModifier = 1
                            end
                        end

                        VFX.EmitTree(lookAt, true)
                        v31 = Sounds:FindFirstChild("MechaShake") or Sounds:FindFirstChild("MechaShake", true)

                        if v31 ~= nil and not v31:IsA("Sound") then
                            v31 = v31:FindFirstChildWhichIsA("Sound")
                        end

                        if v31 then
                            Audio.Play(v31, v21, {
                                Volume = 0.5,
                                PlaybackSpeed = 1.35
                            })
                        end

                        if not v17 then
                            v17 = true
                            task.spawn(p34)
                        end

                        task.wait(0.9)

                        for _, descendant in v36:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = false
                            elseif descendant:IsA("BasePart") then
                                TweenService:Create(descendant, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                                    LocalTransparencyModifier = 1
                                }):Play()
                            end
                        end

                        for _, descendant in lookAt:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                descendant.Enabled = false
                            end
                        end

                        for _, descendant in World2:GetDescendants() do
                            if descendant:IsA("BasePart") then
                                TweenService:Create(descendant, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                                    LocalTransparencyModifier = 0
                                }):Play()
                            end
                        end

                        task.delay(0.66, function() -- line: 669
                            -- upvalues: t5 (copy)
                            for v85, v86 in t5 do
                                if (v85:IsA("Beam") or v85:IsA("Light")) and v85.Parent then
                                    v85.Enabled = v86
                                end
                            end
                        end)
                        task.wait(2.5)
                    end

                    local ok, result = pcall(v19)

                    v18:Clean()

                    if not ok then
                        warn((("Rift sequence failed: %*"):format(result)))
                    end
                end
            end

            if not v17 then
                v17 = true
                task.spawn(p34)
            end

            v3 = false
        end)
    end
end

return table.freeze(t4)
