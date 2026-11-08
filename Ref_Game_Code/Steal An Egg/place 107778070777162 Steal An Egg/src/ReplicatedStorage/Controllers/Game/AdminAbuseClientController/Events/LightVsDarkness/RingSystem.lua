-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BulkPartMotion = require(ReplicatedStorage.Client.BulkPartMotion)
local FallenPowerUp = require(ReplicatedStorage.Data.FallenPowerUp)
local LightVsDarkness = require(ReplicatedStorage.Data.LightVsDarkness)
local LightVsDarknessEventFlags = require(ReplicatedStorage.Shared.Flags.LightVsDarknessEventFlags)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local UISystem = require(script.Parent.UISystem)
local LightVsDarknessSounds = ReplicatedStorage.Assets.Sounds:WaitForChild("LightVsDarknessSounds")
local v1 = Color3.fromRGB(255, 214, 89)
local v4 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.35),
    NumberSequenceKeypoint.new(0.7, 0.6),
    NumberSequenceKeypoint.new(1, 1)
})
local v5 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local Quad = Enum.EasingStyle.Quad
local InOut = Enum.EasingDirection.InOut
local v6 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local LocalPlayer = Players.LocalPlayer
local v7, v8
local v9 = {}
local t1 = {}
local t2 = {}
local Folder, v10
local t3 = {}
local n1 = 0
local n2 = 0
local n3 = 0
local v11 = false
local n4 = 0
local Transient = Workspace:WaitForChild("Transient")
local RingCollect = ReplicatedStorage.Assets.Particles:WaitForChild("LightVsDarknessVFX"):WaitForChild("RingCollect")

assert(RingCollect:IsA("Attachment"), "LightVsDarknessVFX.RingCollect must be an Attachment")

local t4 = {}
local v12
local n5 = 0
local n6 = 0

local function bucketOf(p1) -- line: 139
    return (math.floor(p1 / 100))
end

local function ringsFolder() -- line: 143
    -- upvalues: Workspace (copy), v7 (ref), Folder (ref)
    local Folder2 = Folder

    if Folder2 then
        return Folder2
    end

    local Folder3 = Instance.new("Folder")

    Folder3.Name = "LightVsDarknessRings"
    Folder3.Parent = Workspace
    v7.AssetTrove:Add(Folder3)
    v7.AssetTrove:Add(function() -- line: 152
        -- upvalues: Folder (ref)
        Folder = nil
    end)
    Folder = Folder3

    return Folder3
end

local function stopLoop(p2) -- line: 159
    -- upvalues: t3 (copy)
    local v14 = t3[p2]

    if v14 then
        t3[p2] = nil
        v14:Stop()
    end
end

local function forgetRing(p3) -- line: 168
    -- upvalues: t2 (copy), t3 (copy)
    local v15 = t2[p3.Zone]

    if v15 then
        v15.Rings[p3.Id] = nil

        local v16 = v15.Buckets[p3.Bucket]

        if v16 then
            v16[p3] = nil
        end
    end

    local v17 = t3[p3]

    if v17 then
        t3[p3] = nil
        v17:Stop()
    end
end

local function destroyRing(p4) -- line: 180
    -- upvalues: t2 (copy), t3 (copy)
    local v18 = t2[p4.Zone]

    if v18 then
        v18.Rings[p4.Id] = nil

        local v19 = v18.Buckets[p4.Bucket]

        if v19 then
            v19[p4] = nil
        end
    end

    local v20 = t3[p4]

    if v20 then
        t3[p4] = nil
        v20:Stop()
    end

    p4.Handle:Destroy()
    p4.Part:Destroy()
end

local function stopRingVfx(p5) -- line: 188
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") then
            descendant.Enabled = false
        end
    end
end

local function burstEmitters(p6) -- line: 199
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")

            local function fire() -- line: 207
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount > 0 then
                    descendant:Emit((math.max(1, (math.floor(EmitCount + 0.5)))))
                end

                if type(EmitDuration) == "number" and EmitDuration > 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 213
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end

            if type(EmitDelay) == "number" and EmitDelay > 0 then
                task.delay(EmitDelay, fire)
            else
                fire()
            end
        end
    end
end

local function playCollectVfx(p7) -- line: 228
    -- upvalues: Debris (copy), Transient (copy), RingCollect (copy), burstEmitters (copy)
    local Part = Instance.new("Part")

    Part.Name = "RingCollect"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p7)

    local clone = RingCollect:Clone()

    clone.Parent = Part
    Part.Parent = Transient
    burstEmitters(clone)
    Debris:AddItem(Part, 2)
end

local function fadeRing(p8) -- line: 247
    -- upvalues: Debris (copy), TweenService (copy), v6 (copy), t2 (copy), t3 (copy), stopRingVfx (copy)
    local v23 = t2[p8.Zone]

    if v23 then
        v23.Rings[p8.Id] = nil

        local v24 = v23.Buckets[p8.Bucket]

        if v24 then
            v24[p8] = nil
        end
    end

    local v25 = t3[p8]

    if v25 then
        t3[p8] = nil
        v25:Stop()
    end

    p8.Handle:Destroy()

    local Part = p8.Part

    if Part.Parent == nil then
        return
    end

    stopRingVfx(Part)
    TweenService:Create(Part, v6, {
        Transparency = 1,
        CFrame = Part.CFrame + Vector3.new(0, 5, 0)
    }):Play()

    for _, descendant in Part:GetDescendants() do
        if descendant:IsA("BasePart") then
            TweenService:Create(descendant, v6, {
                Transparency = 1
            }):Play()
        end
    end

    Debris:AddItem(Part, 0.2)
end

local function fadeLoosePart(p9) -- line: 269
    -- upvalues: Debris (copy), TweenService (copy), v6 (copy)
    TweenService:Create(p9, v6, {
        Transparency = 1,
        CFrame = p9.CFrame + Vector3.new(0, 5, 0)
    }):Play()

    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("BasePart") then
            TweenService:Create(descendant, v6, {
                Transparency = 1
            }):Play()
        end
    end

    Debris:AddItem(p9, 0.2)
end

local function pullRing(p10, p11, p12) -- line: 284
    -- upvalues: LightVsDarkness (copy), v1 (copy), v4 (copy), t2 (copy), t3 (copy), t4 (copy), stopRingVfx (copy)
    local v26 = t2[p10.Zone]

    if v26 then
        v26.Rings[p10.Id] = nil

        local v27 = v26.Buckets[p10.Bucket]

        if v27 then
            v27[p10] = nil
        end
    end

    local v28 = t3[p10]

    if v28 then
        t3[p10] = nil
        v28:Stop()
    end

    p10.Handle:Destroy()

    local Part = p10.Part

    if Part.Parent == nil then
        return
    end

    stopRingVfx(Part)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Parent = p11

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.FaceCamera = true
    Beam.Width0 = math.max(LightVsDarkness.RARITIES[p10.Ring.Rarity].Radius * 0.5, 0.8)
    Beam.Width1 = 0.25
    Beam.Color = ColorSequence.new(v1)
    Beam.Transparency = v4
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Parent = Part
    t4[Part] = {
        Fading = false,
        Part = Part,
        From = Part.Position,
        StartedAt = os.clock(),
        Target = p11,
        Phase = p10.Phase,
        Rarity = p10.Ring.Rarity,
        Mine = p12,
        Beam = Beam,
        TargetAttachment = Attachment2
    }
end

local function dropPullBeam(p13) -- line: 321
    local Beam = p13.Beam

    if Beam then
        p13.Beam = nil
        Beam:Destroy()
    end

    local TargetAttachment = p13.TargetAttachment

    if TargetAttachment then
        p13.TargetAttachment = nil
        TargetAttachment:Destroy()
    end
end

local function stepPulls(p14) -- line: 334
    -- upvalues: TweenService (copy), FallenPowerUp (copy), UISystem (copy), v6 (copy), t4 (copy), playCollectVfx (copy), fadeLoosePart (copy)
    for v30, v31 in t4 do
        local Target = v31.Target

        if v30.Parent ~= nil then
            if Target.Parent ~= nil then
                local v32 = (p14 - v31.StartedAt) / FallenPowerUp.MagnetPullSeconds

                if v32 >= 1 then
                    t4[v30] = nil

                    local Beam = v31.Beam

                    if Beam then
                        v31.Beam = nil
                        Beam:Destroy()
                    end

                    local TargetAttachment = v31.TargetAttachment

                    if TargetAttachment then
                        v31.TargetAttachment = nil
                        TargetAttachment:Destroy()
                    end

                    playCollectVfx(v30.Position)

                    if v31.Mine then
                        UISystem.RingArrived(v31.Rarity, v30.Position)
                    end

                    v30:Destroy()
                else
                    local v33 = v32 * v32
                    local v37 = v31.From:Lerp(Target.Position, v33) + Vector3.new(0, math.sin(v32 * 3.141592653589793) * 1.5, 0)

                    v30.CFrame = CFrame.new(v37) * CFrame.Angles(0, p14 * FallenPowerUp.MagnetPullSpinSpeed + v31.Phase, 1.5707963267948966)

                    if v32 > 0.7 and not v31.Fading then
                        v31.Fading = true

                        for _, descendant in v30:GetDescendants() do
                            if descendant:IsA("BasePart") then
                                TweenService:Create(descendant, v6, {
                                    Transparency = 1
                                }):Play()
                            end
                        end

                        TweenService:Create(v30, v6, {
                            Transparency = 1
                        }):Play()
                    end
                end
            else
                t4[v30] = nil

                local Beam = v31.Beam

                if Beam then
                    v31.Beam = nil
                    Beam:Destroy()
                end

                local TargetAttachment = v31.TargetAttachment

                if TargetAttachment then
                    v31.TargetAttachment = nil
                    TargetAttachment:Destroy()
                end

                playCollectVfx(v30.Position)
                fadeLoosePart(v30)
            end
        else
            t4[v30] = nil

            local Beam = v31.Beam

            if Beam then
                v31.Beam = nil
                Beam:Destroy()
            end

            local TargetAttachment = v31.TargetAttachment

            if TargetAttachment then
                v31.TargetAttachment = nil
                TargetAttachment:Destroy()
            end
        end
    end
end

local function buildRing(p15, p16, p17, p18) -- line: 378
    -- upvalues: BulkPartMotion (copy), LightVsDarkness (copy), n6 (ref), ringsFolder (copy)
    local v38 = LightVsDarkness.RARITIES[p18.Rarity]
    local clone = LightVsDarkness.Template(p18.Rarity):Clone()

    clone.Name = v38.Id
    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    clone.CFrame = CFrame.new(p18.X, p18.Y - n6, p18.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
    clone.Parent = ringsFolder()

    local t5 = {
        Pending = false,
        Part = clone,
        Handle = BulkPartMotion.Register(clone),
        Ring = p18,
        Zone = p15,
        Id = p17,
        Bucket = math.floor(p18.X / 100),
        Phase = p17 % 7
    }

    p16.Rings[p17] = t5

    local v40 = p16.Buckets[t5.Bucket]

    if v40 == nil then
        v40 = {}
        p16.Buckets[t5.Bucket] = v40
    end

    v40[t5] = true
end

local function destroyZone(p19) -- line: 416
    -- upvalues: t2 (copy), t3 (copy)
    local v41 = t2[p19]

    if v41 ~= nil then
        t2[p19] = nil

        for _, v42 in v41.Rings do
            local v43 = t2[v42.Zone]

            if v43 then
                v43.Rings[v42.Id] = nil

                local v44 = v43.Buckets[v42.Bucket]

                if v44 then
                    v44[v42] = nil
                end
            end

            local v45 = t3[v42]

            if v45 then
                t3[v42] = nil
                v45:Stop()
            end

            v42.Handle:Destroy()
            v42.Part:Destroy()
        end
    end
end

local function clearRings() -- line: 433
    -- upvalues: v8 (ref), v9 (ref), t1 (ref), t2 (copy), v10 (ref), t3 (copy), v11 (ref), n4 (ref), v12 (ref), n5 (ref), n6 (ref)
    n4 += 1
    v11 = false

    for v46 in t2 do
        local v47 = t2[v46]

        if v47 ~= nil then
            t2[v46] = nil

            for _, v48 in v47.Rings do
                local v49 = t2[v48.Zone]

                if v49 then
                    v49.Rings[v48.Id] = nil

                    local v50 = v49.Buckets[v48.Bucket]

                    if v50 then
                        v50[v48] = nil
                    end
                end

                local v51 = t3[v48]

                if v51 then
                    t3[v48] = nil
                    v51:Stop()
                end

                v48.Handle:Destroy()
                v48.Part:Destroy()
            end
        end
    end

    for v52 in t3 do
        local v53 = t3[v52]

        if v53 then
            t3[v52] = nil
            v53:Stop()
        end
    end

    v8 = nil
    v9 = {}
    t1 = {}
    v10 = nil
    v12 = nil
    n5 = 0
    n6 = 0
end

local function spawnPoint() -- line: 450
    -- upvalues: Workspace (copy)
    local SpawnLocation = Workspace:FindFirstChild("SpawnLocation")

    assert(SpawnLocation and SpawnLocation:IsA("BasePart"), "Workspace.SpawnLocation must be a BasePart")

    return SpawnLocation.Position
end

local function fadeOutWave() -- line: 459
    -- upvalues: Workspace (copy), v8 (ref), v9 (ref), t1 (ref), t2 (copy), v10 (ref), v11 (ref), n4 (ref), v12 (ref), fadeRing (copy), clearRings (copy)
    local t6 = {}

    for _, v55 in t2 do
        for _, v56 in v55.Rings do
            table.insert(t6, v56)
        end
    end

    v8 = nil
    v9 = {}
    t1 = {}
    v10 = nil
    v12 = nil

    if #t6 == 0 then
        clearRings()
    else
        local SpawnLocation = Workspace:FindFirstChild("SpawnLocation")

        assert(SpawnLocation and SpawnLocation:IsA("BasePart"), "Workspace.SpawnLocation must be a BasePart")

        local SpawnLocationPosition = SpawnLocation.Position

        table.sort(t6, function(p20, p21) -- line: 477
            -- upvalues: SpawnLocationPosition (copy)
            local v58 = Vector3.new(p20.Ring.X, p20.Ring.Y, p20.Ring.Z)
            local v59 = Vector3.new(p21.Ring.X, p21.Ring.Y, p21.Ring.Z)

            return (v58 - SpawnLocationPosition).Magnitude > (v59 - SpawnLocationPosition).Magnitude
        end)
        n4 += 1
        v11 = true

        local v60 = n4

        for v61, v62 in t6 do
            task.delay((v61 - 1) / #t6 * 5, function() -- line: 487
                -- upvalues: v60 (copy), v62 (copy), n4 (ref), fadeRing (copy)
                if n4 == v60 then
                    fadeRing(v62)
                end
            end)
        end

        task.delay(5.2, function() -- line: 493
            -- upvalues: v60 (copy), n4 (ref), clearRings (copy)
            if n4 == v60 then
                clearRings()
            end
        end)
    end
end

local function retireBuilt(p22) -- line: 500
    -- upvalues: Debris (copy), TweenService (copy), v5 (copy), t2 (copy), t3 (copy), v11 (ref), n4 (ref), stopRingVfx (copy)
    n4 += 1
    v11 = false

    for v63, v64 in t2 do
        t2[v63] = nil

        for _, v65 in v64.Rings do
            local v66 = t3[v65]

            if v66 then
                t3[v65] = nil
                v66:Stop()
            end

            v65.Handle:Destroy()

            local Part = v65.Part

            if Part.Parent ~= nil then
                stopRingVfx(Part)
                TweenService:Create(Part, v5, {
                    Transparency = 1,
                    CFrame = Part.CFrame + Vector3.new(0, p22 * 16, 0)
                }):Play()

                for _, descendant in Part:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        TweenService:Create(descendant, v5, {
                            Transparency = 1
                        }):Play()
                    end
                end

                Debris:AddItem(Part, 0.45)
            end
        end
    end

    for v68 in t3 do
        local v69 = t3[v68]

        if v69 then
            t3[v68] = nil
            v69:Stop()
        end
    end
end

local function updateRenderLift(p23) -- line: 529
    -- upvalues: TweenService (copy), LightVsDarknessEventFlags (copy), Quad (copy), InOut (copy), n5 (ref), n6 (ref)
    if n5 <= 0 then
        n6 = 0
    else
        local v70 = (p23 - n5) / 1.5

        if v70 >= 1 then
            n5 = 0
            n6 = 0
        else
            n6 = LightVsDarknessEventFlags.FlyHeightStuds:Get() * (1 - TweenService:GetValue(math.max(v70, 0), Quad, InOut))
        end
    end
end

local function adoptWave(p24, p25, p26, p27) -- line: 544
    -- upvalues: TweenService (copy), LightVsDarknessEventFlags (copy), Quad (copy), InOut (copy), v8 (ref), v9 (ref), t1 (ref), v10 (ref), v12 (ref), n5 (ref), n6 (ref), retireBuilt (copy)
    local v71 = v12

    retireBuilt(not (v71 == "Sky" and p25 == "Ground") and 1 or -1)
    v8 = p24
    v9 = p26
    t1 = {}
    v10 = nil
    v12 = p25
    n5 = if p25 ~= "Sky" or v71 ~= "Ground" then 0 else os.clock()

    local elapsed = os.clock()

    if n5 <= 0 then
        n6 = 0
    else
        local v73 = (elapsed - n5) / 1.5

        if v73 >= 1 then
            n5 = 0
            n6 = 0
        else
            n6 = LightVsDarknessEventFlags.FlyHeightStuds:Get() * (1 - TweenService:GetValue(math.max(v73, 0), Quad, InOut))
        end
    end

    if p27 then
        for v74, v75 in p27 do
            local t8 = {}

            for _, v76 in v75 do
                t8[v76] = true
            end

            local t9 = t1

            t9[v74] = t8
        end
    end
end

local function syncZones(p28) -- line: 566
    -- upvalues: LightVsDarkness (copy), v9 (ref), t2 (copy), v10 (ref), t3 (copy)
    local v77 = LightVsDarkness.ZoneIndexAt(p28.Position)

    if v77 == v10 then
        return
    end

    v10 = v77

    for v78 in t2 do
        if math.abs(v78 - v77) > 3 then
            local v80 = t2[v78]

            if v80 ~= nil then
                t2[v78] = nil

                for _, v81 in v80.Rings do
                    local v82 = t2[v81.Zone]

                    if v82 then
                        v82.Rings[v81.Id] = nil

                        local v83 = v82.Buckets[v81.Bucket]

                        if v83 then
                            v83[v81] = nil
                        end
                    end

                    local v84 = t3[v81]

                    if v84 then
                        t3[v81] = nil
                        v84:Stop()
                    end

                    v81.Handle:Destroy()
                    v81.Part:Destroy()
                end
            end
        end
    end

    for i = v77 - 3, v77 + 3 do
        local v85 = v9[i]

        if v85 ~= nil and t2[i] == nil then
            t2[i] = {
                NextId = 1,
                Source = LightVsDarkness.DecodeRings(v85),
                Rings = {},
                Buckets = {}
            }
        end
    end
end

local function continueBuilds() -- line: 591
    -- upvalues: t1 (ref), t2 (copy), buildRing (copy)
    local n7 = 400

    for v86, v87 in t2 do
        local v88 = t1[v86]

        while n7 > 0 and v87.NextId <= #v87.Source do
            local NextId = v87.NextId

            v87.NextId = NextId + 1

            if v88 == nil or not v88[NextId] then
                buildRing(v86, v87, NextId, v87.Source[NextId])
                n7 -= 1
            end
        end

        if n7 <= 0 then
            return
        end
    end
end

local function spin(p29, p30) -- line: 609
    -- upvalues: LightVsDarkness (copy), t2 (copy), n3 (ref), n6 (ref)
    for _, v89 in t2 do
        for v90, v91 in v89.Buckets do
            local v93 = math.abs((v90 + 0.5) * 100 - p29.Position.X)

            if not (v93 > 800) and (not (v93 > 250) or (n3 + v90) % 4 == 0) then
                for v96 in v91 do
                    local Ring = v96.Ring
                    local SpinSpeed = LightVsDarkness.RARITIES[Ring.Rarity].SpinSpeed
                    local Handle = v96.Handle
                    local new = CFrame.new
                    local X, Y = Ring.X, Ring.Y
                    local v97 = n6

                    Handle:SetCFrame(new(X, Y - v97, Ring.Z) * CFrame.Angles(0, p30 * SpinSpeed + v96.Phase, 1.5707963267948966))
                end
            end
        end
    end
end

local function nearbyBuilt(p31, p32) -- line: 632
    -- upvalues: t2 (copy)
    local t10 = {}
    local v99 = math.floor(p31.Position.X / 100)

    for _, v100 in t2 do
        for i = v99 - 1, v99 + 1 do
            local v101 = v100.Buckets[i]

            if v101 ~= nil then
                for v102 in v101 do
                    local Ring = v102.Ring

                    if (Vector3.new(Ring.X, Ring.Y, Ring.Z) - p31.Position).Magnitude <= p32 then
                        table.insert(t10, v102)
                    end
                end
            end
        end
    end

    return t10
end

local function playCollectSound(p33, _) -- line: 653
    -- upvalues: LightVsDarkness (copy), LightVsDarknessSounds (copy), n1 (ref), n2 (ref)
    local elapsed = os.clock()

    if elapsed - n2 > 1.5 then
        n1 = 0
    end

    n1 += 1
    n2 = elapsed

    local v104 = math.min(n1 - 1, 12)
    local v106 = LightVsDarknessSounds:FindFirstChild((("Collect%*Ring"):format(LightVsDarkness.RARITIES[p33].Id)))

    if not v106 then
        return
    end

    local clone = v106:Clone()

    clone.Parent = v106.Parent
    clone.PlayOnRemove = true
    clone.PlaybackSpeed = v104 * 0.06 + 1
    task.defer(function() -- line: 671
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
end

local function collect(p35, _) -- line: 677
    -- upvalues: Workspace (copy), FallenPowerUp (copy), LightVsDarkness (copy), LightVsDarknessEventFlags (copy), Remotes (copy), LocalPlayer (copy), v8 (ref), pullRing (copy), nearbyBuilt (copy), playCollectSound (copy)
    local v107 = v8

    if v107 ~= nil and type(LocalPlayer:GetAttribute("LvdTeam")) == "string" then
        local v108 = LightVsDarknessEventFlags.CollectRadiusPadding:Get()
        local v109 = LightVsDarknessEventFlags.MagnetRadiusStuds:Get() * (if FallenPowerUp.IsActive(LocalPlayer, "Magnet", Workspace:GetServerTimeNow()) then 1 else 0.25)

        for _, v110 in nearbyBuilt(p35, (math.max(40, v109))) do
            if not v110.Pending then
                local Ring = v110.Ring
                local v111 = LightVsDarkness.RARITIES[Ring.Rarity].Radius + v108
                local Magnitude = (Vector3.new(Ring.X, Ring.Y, Ring.Z) - p35.Position).Magnitude

                if not (v111 < Magnitude) or not (v109 < Magnitude) then
                    v110.Pending = true
                    Remotes.LightVsDarkness.AskCollectRing:FireServer(v107, v110.Zone, v110.Id)
                    playCollectSound(v110.Ring.Rarity, p35)
                    pullRing(v110, p35, true)
                end
            end
        end
    end
end

local function playSound(p37, p38, p39) -- line: 712
    -- upvalues: Audio (copy), LightVsDarknessSounds (copy)
    local v112 = LightVsDarknessSounds:FindFirstChild(p37)

    assert(v112 and v112:IsA("Sound"), (("LightVsDarknessSounds.%* must be a Sound"):format(p37)))

    local v115 = if p39 then table.clone(p39) else {}

    v115.Volume = v115.Volume or v112.Volume
    v115.MaxDistance = v115.MaxDistance or v112.RollOffMaxDistance
    v115.SoundGroup = v115.SoundGroup or "SFX"

    return Audio.Play(v112, p38, v115)
end

local function updateNearby(p40) -- line: 724
    -- upvalues: LightVsDarkness (copy), t3 (copy), nearbyBuilt (copy), playSound (copy)
    local t11 = {}

    for _, v116 in nearbyBuilt(p40, 40) do
        if v116.Ring.Rarity > 1 and not v116.Pending then
            table.insert(t11, v116)
        end
    end

    table.sort(t11, function(p41, p42) -- line: 731
        -- upvalues: p40 (copy)
        local Ring = p41.Ring
        local Ring2 = p42.Ring

        return (Vector3.new(Ring.X, Ring.Y, Ring.Z) - p40.Position).Magnitude < (Vector3.new(Ring2.X, Ring2.Y, Ring2.Z) - p40.Position).Magnitude
    end)

    local t12 = {}

    for i = 1, math.min(#t11, 3) do
        t12[t11[i]] = true
    end

    for v118 in t3 do
        if not t12[v118] then
            local v119 = t3[v118]

            if v119 then
                t3[v118] = nil
                v119:Stop()
            end
        end
    end

    for v120 in t12 do
        if t3[v120] == nil then
            local v122 = playSound(("Nearby%*RingLooped"):format(LightVsDarkness.RARITIES[v120.Ring.Rarity].Id), v120.Part, {
                Looped = true
            })

            if v122 then
                t3[v120] = v122
            end
        end
    end
end

local function onRingCollected(p43, p44, p45, p46) -- line: 756
    -- upvalues: Players (copy), Player (copy), v8 (ref), t1 (ref), t2 (copy), playCollectVfx (copy), fadeRing (copy), pullRing (copy)
    if p43 ~= v8 then
        return
    end

    local v123 = t1[p44]

    if v123 == nil then
        v123 = {}
        t1[p44] = v123
    end

    v123[p45] = true

    local v124 = t2[p44]
    local v125 = if v124 then v124.Rings[p45] else nil

    if not v125 then
        return
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p46)
    local v126 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)

    if v126 ~= nil and v126:IsA("BasePart") then
        pullRing(v125, v126, false)
    else
        playCollectVfx((Vector3.new(v125.Ring.X, v125.Ring.Y, v125.Ring.Z)))
        fadeRing(v125)
    end
end

local function onRingRespawned(p47, p48, p49) -- line: 784
    -- upvalues: v8 (ref), t1 (ref), t2 (copy), buildRing (copy)
    if p47 ~= v8 then
        return
    end

    local v127 = t1[p48]

    if v127 then
        v127[p49] = nil
    end

    local v128 = t2[p48]

    if v128 and v128.Rings[p49] == nil and p49 < v128.NextId then
        buildRing(p48, v128, p49, v128.Source[p49])
    end
end

local function step() -- line: 798
    -- upvalues: TweenService (copy), LightVsDarknessEventFlags (copy), Player (copy), Quad (copy), InOut (copy), LocalPlayer (copy), v8 (ref), n3 (ref), v11 (ref), n5 (ref), n6 (ref), stepPulls (copy), syncZones (copy), continueBuilds (copy), spin (copy), collect (copy), updateNearby (copy)
    stepPulls(os.clock())

    if v8 ~= nil or v11 then
        local v129 = Player.FindPrimaryPart(LocalPlayer)

        if v129 ~= nil then
            n3 += 1

            local elapsed = os.clock()

            if n5 <= 0 then
                n6 = 0
            else
                local v130 = (elapsed - n5) / 1.5

                if v130 >= 1 then
                    n5 = 0
                    n6 = 0
                else
                    n6 = LightVsDarknessEventFlags.FlyHeightStuds:Get() * (1 - TweenService:GetValue(math.max(v130, 0), Quad, InOut))
                end
            end

            spin(v129, elapsed)

            if v8 ~= nil then
                syncZones(v129)
                continueBuilds()
                collect(v129, elapsed)

                if n3 % 10 == 0 then
                    updateNearby(v129)
                end
            end
        end
    end
end

local function start() -- line: 824
    -- upvalues: RunService (copy), TweenService (copy), LightVsDarknessEventFlags (copy), Remotes (copy), Quad (copy), InOut (copy), v7 (ref), v8 (ref), v9 (ref), t1 (ref), v10 (ref), n1 (ref), t4 (copy), v12 (ref), n5 (ref), n6 (ref), clearRings (copy), fadeOutWave (copy), retireBuilt (copy), adoptWave (copy), onRingCollected (copy), onRingRespawned (copy), step (copy)
    local AssetTrove = v7.AssetTrove

    clearRings()
    AssetTrove:Connect(Remotes.LightVsDarkness.RingsSpawned.OnClientEvent, function(p50, p51, p52) -- line: 827
        -- upvalues: TweenService (copy), LightVsDarknessEventFlags (copy), Quad (copy), InOut (copy), v8 (ref), v9 (ref), t1 (ref), v10 (ref), v12 (ref), n5 (ref), n6 (ref), retireBuilt (copy)
        local v131 = v12

        retireBuilt(not (v131 == "Sky" and p51 == "Ground") and 1 or -1)
        v8 = p50
        v9 = p52
        t1 = {}
        v10 = nil
        v12 = p51
        n5 = if p51 ~= "Sky" or v131 ~= "Ground" then 0 else os.clock()

        local elapsed = os.clock()

        if n5 <= 0 then
            n6 = 0
        else
            local v133 = (elapsed - n5) / 1.5

            if v133 >= 1 then
                n5 = 0
                n6 = 0
            else
                n6 = LightVsDarknessEventFlags.FlyHeightStuds:Get() * (1 - TweenService:GetValue(math.max(v133, 0), Quad, InOut))
            end
        end
    end)
    AssetTrove:Connect(Remotes.LightVsDarkness.RingsCleared.OnClientEvent, function(p53) -- line: 830
        -- upvalues: v8 (ref), fadeOutWave (copy)
        if p53 == v8 then
            fadeOutWave()
        end
    end)
    AssetTrove:Connect(Remotes.LightVsDarkness.RingCollected.OnClientEvent, onRingCollected)
    AssetTrove:Connect(Remotes.LightVsDarkness.RingRespawned.OnClientEvent, onRingRespawned)
    AssetTrove:Connect(RunService.Heartbeat, step)
    AssetTrove:Add(function() -- line: 838
        -- upvalues: n1 (ref), t4 (copy), clearRings (copy)
        clearRings()

        for _, v134 in t4 do
            local Beam = v134.Beam

            if Beam then
                v134.Beam = nil
                Beam:Destroy()
            end

            local TargetAttachment = v134.TargetAttachment

            if TargetAttachment then
                v134.TargetAttachment = nil
                TargetAttachment:Destroy()
            end
        end

        table.clear(t4)
        n1 = 0
    end)
    AssetTrove:Add(task.spawn(function() -- line: 848
        -- upvalues: Remotes (copy), v7 (ref), v8 (ref), adoptWave (copy)
        local v135, v136, v137, v138 = Remotes.LightVsDarkness.FetchRings:InvokeServer()

        if type(v135) == "number" and v7.IsEventActive() and v8 == nil then
            adoptWave(v135, v136, v137, v138)
        end
    end))
end

return function(p54) -- line: 858
    -- upvalues: v7 (ref), clearRings (copy), start (copy)
    v7 = p54

    return {
        Start = start,
        Clear = clearRings
    }
end
