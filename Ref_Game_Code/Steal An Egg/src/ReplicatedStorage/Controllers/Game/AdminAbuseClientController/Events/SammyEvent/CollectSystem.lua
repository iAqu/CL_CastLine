-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BulkPartMotion = require(ReplicatedStorage.Client.BulkPartMotion)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SammyEvent = require(ReplicatedStorage.Data.SammyEvent)
local SammyEventFlags = require(ReplicatedStorage.Shared.Flags.SammyEventFlags)

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
local v6 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local LocalPlayer = Players.LocalPlayer
local v7, v8
local v9 = {}
local t1 = {}
local t2 = {}
local Folder, v10
local n1 = 0
local n2 = 0
local n3 = 0
local v11 = false
local n4 = 0
local Transient = Workspace:WaitForChild("Transient")
local RingCollect = ReplicatedStorage.Assets.Particles:WaitForChild("LightVsDarknessVFX"):WaitForChild("RingCollect")

assert(RingCollect:IsA("Attachment"), "LightVsDarknessVFX.RingCollect must be an Attachment")

local t3 = {}
local DischargePulse = ReplicatedStorage.Assets:WaitForChild("SammyEventVisuals"):WaitForChild("DischargePulse")

assert(DischargePulse:IsA("BasePart"), "SammyEventVisuals.DischargePulse must be a BasePart")

local SeparationLine = Workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("SeparationLine")

assert(SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

local v12 = false
local v13 = RaycastParams.new()

v13.FilterType = Enum.RaycastFilterType.Include
v13.RespectCanCollide = true

local function bucketOf(p1) -- line: 150
    return (math.floor(p1 / 100))
end

local function pickupsFolder() -- line: 154
    -- upvalues: Workspace (copy), v7 (ref), Folder (ref)
    local Folder2 = Folder

    if Folder2 then
        return Folder2
    end

    local Folder3 = Instance.new("Folder")

    Folder3.Name = "SammyEmpPickups"
    Folder3.Parent = Workspace
    v7.AssetTrove:Add(Folder3)
    v7.AssetTrove:Add(function() -- line: 163
        -- upvalues: Folder (ref)
        Folder = nil
    end)
    Folder = Folder3

    return Folder3
end

local function forgetPickup(p2) -- line: 171
    -- upvalues: t2 (copy)
    local v15 = t2[p2.Zone]

    if not v15 then
        return
    end

    v15.Pickups[p2.Id] = nil

    local v16 = v15.Buckets[p2.Bucket]

    if v16 then
        v16[p2] = nil
    end
end

local function destroyPickup(p3) -- line: 182
    -- upvalues: t2 (copy)
    local v17 = t2[p3.Zone]

    if v17 then
        v17.Pickups[p3.Id] = nil

        local v18 = v17.Buckets[p3.Bucket]

        if v18 then
            v18[p3] = nil
        end
    end

    p3.Handle:Destroy()
    p3.Part:Destroy()
end

local function stopPickupVfx(p4) -- line: 190
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") then
            descendant.Enabled = false
        end
    end
end

local function burstEmitters(p5) -- line: 201
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")

            local function fire() -- line: 209
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount > 0 then
                    descendant:Emit((math.max(1, (math.floor(EmitCount + 0.5)))))
                end

                if type(EmitDuration) == "number" and EmitDuration > 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 215
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

local function playCollectVfx(p6) -- line: 230
    -- upvalues: Debris (copy), Transient (copy), RingCollect (copy), burstEmitters (copy)
    local Part = Instance.new("Part")

    Part.Name = "RingCollect"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p6)

    local clone = RingCollect:Clone()

    clone.Parent = Part
    Part.Parent = Transient
    burstEmitters(clone)
    Debris:AddItem(Part, 2)
end

local function fadePickup(p7) -- line: 249
    -- upvalues: Debris (copy), TweenService (copy), v6 (copy), t2 (copy), stopPickupVfx (copy)
    local v21 = t2[p7.Zone]

    if v21 then
        v21.Pickups[p7.Id] = nil

        local v22 = v21.Buckets[p7.Bucket]

        if v22 then
            v22[p7] = nil
        end
    end

    p7.Handle:Destroy()

    local Part = p7.Part

    if Part.Parent == nil then
        return
    end

    stopPickupVfx(Part)
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

local function fadeLoosePart(p8) -- line: 271
    -- upvalues: Debris (copy), TweenService (copy), v6 (copy)
    TweenService:Create(p8, v6, {
        Transparency = 1,
        CFrame = p8.CFrame + Vector3.new(0, 5, 0)
    }):Play()

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("BasePart") then
            TweenService:Create(descendant, v6, {
                Transparency = 1
            }):Play()
        end
    end

    Debris:AddItem(p8, 0.2)
end

local function pullPickup(p9, p10, p11) -- line: 286
    -- upvalues: SammyEvent (copy), v1 (copy), v4 (copy), t2 (copy), t3 (copy), stopPickupVfx (copy)
    local v23 = t2[p9.Zone]

    if v23 then
        v23.Pickups[p9.Id] = nil

        local v24 = v23.Buckets[p9.Bucket]

        if v24 then
            v24[p9] = nil
        end
    end

    p9.Handle:Destroy()

    local Part = p9.Part

    if Part.Parent == nil then
        return
    end

    stopPickupVfx(Part)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Parent = p10

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.FaceCamera = true
    Beam.Width0 = math.max(SammyEvent.PickupRadius * 0.5, 0.8)
    Beam.Width1 = 0.25
    Beam.Color = ColorSequence.new(v1)
    Beam.Transparency = v4
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Parent = Part
    t3[Part] = {
        Fading = false,
        Part = Part,
        From = Part.Position,
        StartedAt = os.clock(),
        Target = p10,
        Phase = p9.Phase,
        Mine = p11,
        Beam = Beam,
        TargetAttachment = Attachment2
    }
end

local function dropPullBeam(p12) -- line: 322
    local Beam = p12.Beam

    if Beam then
        p12.Beam = nil
        Beam:Destroy()
    end

    local TargetAttachment = p12.TargetAttachment

    if TargetAttachment then
        p12.TargetAttachment = nil
        TargetAttachment:Destroy()
    end
end

local function stepPulls(p13) -- line: 335
    -- upvalues: TweenService (copy), UISystem (copy), v6 (copy), t3 (copy), playCollectVfx (copy), fadeLoosePart (copy)
    for v26, v27 in t3 do
        local Target = v27.Target

        if v26.Parent ~= nil then
            if Target.Parent ~= nil then
                local v28 = (p13 - v27.StartedAt) / 0.35

                if v28 >= 1 then
                    t3[v26] = nil

                    local Beam = v27.Beam

                    if Beam then
                        v27.Beam = nil
                        Beam:Destroy()
                    end

                    local TargetAttachment = v27.TargetAttachment

                    if TargetAttachment then
                        v27.TargetAttachment = nil
                        TargetAttachment:Destroy()
                    end

                    playCollectVfx(v26.Position)

                    if v27.Mine then
                        UISystem.PickupArrived(v26.Position)
                    end

                    v26:Destroy()
                else
                    local v29 = v28 * v28
                    local v33 = v27.From:Lerp(Target.Position, v29) + Vector3.new(0, math.sin(v28 * 3.141592653589793) * 1.5, 0)

                    v26.CFrame = CFrame.new(v33) * CFrame.Angles(0, p13 * 12 + v27.Phase, 1.5707963267948966)

                    if v28 > 0.7 and not v27.Fading then
                        v27.Fading = true

                        for _, descendant in v26:GetDescendants() do
                            if descendant:IsA("BasePart") then
                                TweenService:Create(descendant, v6, {
                                    Transparency = 1
                                }):Play()
                            end
                        end

                        TweenService:Create(v26, v6, {
                            Transparency = 1
                        }):Play()
                    end
                end
            else
                t3[v26] = nil

                local Beam = v27.Beam

                if Beam then
                    v27.Beam = nil
                    Beam:Destroy()
                end

                local TargetAttachment = v27.TargetAttachment

                if TargetAttachment then
                    v27.TargetAttachment = nil
                    TargetAttachment:Destroy()
                end

                playCollectVfx(v26.Position)
                fadeLoosePart(v26)
            end
        else
            t3[v26] = nil

            local Beam = v27.Beam

            if Beam then
                v27.Beam = nil
                Beam:Destroy()
            end

            local TargetAttachment = v27.TargetAttachment

            if TargetAttachment then
                v27.TargetAttachment = nil
                TargetAttachment:Destroy()
            end
        end
    end
end

local function buildPickup(p14, p15, p16, p17) -- line: 379
    -- upvalues: BulkPartMotion (copy), SammyEvent (copy), pickupsFolder (copy)
    local clone = SammyEvent.PickupTemplate():Clone()

    clone.Name = "EmpCharge"
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

    clone.CFrame = CFrame.new(p17.X, p17.Y, p17.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
    clone.Parent = pickupsFolder()

    local t4 = {
        Pending = false,
        Part = clone,
        Handle = BulkPartMotion.Register(clone),
        Pickup = p17,
        Zone = p14,
        Id = p16,
        Bucket = math.floor(p17.X / 100),
        Phase = p16 % 7
    }

    p15.Pickups[p16] = t4

    local v35 = p15.Buckets[t4.Bucket]

    if v35 == nil then
        v35 = {}
        p15.Buckets[t4.Bucket] = v35
    end

    v35[t4] = true
end

local function destroyZone(p18) -- line: 416
    -- upvalues: t2 (copy)
    local v36 = t2[p18]

    if v36 ~= nil then
        t2[p18] = nil

        for _, v37 in v36.Pickups do
            local v38 = t2[v37.Zone]

            if v38 then
                v38.Pickups[v37.Id] = nil

                local v39 = v38.Buckets[v37.Bucket]

                if v39 then
                    v39[v37] = nil
                end
            end

            v37.Handle:Destroy()
            v37.Part:Destroy()
        end
    end
end

local function clearPickups() -- line: 433
    -- upvalues: v8 (ref), v9 (ref), t1 (ref), t2 (copy), v10 (ref), v11 (ref), n4 (ref)
    n4 += 1
    v11 = false

    for v40 in t2 do
        local v41 = t2[v40]

        if v41 ~= nil then
            t2[v40] = nil

            for _, v42 in v41.Pickups do
                local v43 = t2[v42.Zone]

                if v43 then
                    v43.Pickups[v42.Id] = nil

                    local v44 = v43.Buckets[v42.Bucket]

                    if v44 then
                        v44[v42] = nil
                    end
                end

                v42.Handle:Destroy()
                v42.Part:Destroy()
            end
        end
    end

    v8 = nil
    v9 = {}
    t1 = {}
    v10 = nil
end

local function spawnPoint() -- line: 444
    -- upvalues: Workspace (copy)
    local SpawnLocation = Workspace:FindFirstChild("SpawnLocation")

    assert(SpawnLocation and SpawnLocation:IsA("BasePart"), "Workspace.SpawnLocation must be a BasePart")

    return SpawnLocation.Position
end

local function fadeOutWave() -- line: 453
    -- upvalues: Workspace (copy), v8 (ref), v9 (ref), t1 (ref), t2 (copy), v10 (ref), v11 (ref), n4 (ref), fadePickup (copy), clearPickups (copy)
    local t5 = {}

    for _, v46 in t2 do
        for _, v47 in v46.Pickups do
            table.insert(t5, v47)
        end
    end

    v8 = nil
    v9 = {}
    t1 = {}
    v10 = nil

    if #t5 == 0 then
        clearPickups()
    else
        local SpawnLocation = Workspace:FindFirstChild("SpawnLocation")

        assert(SpawnLocation and SpawnLocation:IsA("BasePart"), "Workspace.SpawnLocation must be a BasePart")

        local SpawnLocationPosition = SpawnLocation.Position

        table.sort(t5, function(p19, p20) -- line: 470
            -- upvalues: SpawnLocationPosition (copy)
            local v49 = Vector3.new(p19.Pickup.X, p19.Pickup.Y, p19.Pickup.Z)
            local v50 = Vector3.new(p20.Pickup.X, p20.Pickup.Y, p20.Pickup.Z)

            return (v49 - SpawnLocationPosition).Magnitude > (v50 - SpawnLocationPosition).Magnitude
        end)
        n4 += 1
        v11 = true

        local v51 = n4

        for v52, v53 in t5 do
            task.delay((v52 - 1) / #t5 * 5, function() -- line: 480
                -- upvalues: v51 (copy), v53 (copy), n4 (ref), fadePickup (copy)
                if n4 == v51 then
                    fadePickup(v53)
                end
            end)
        end

        task.delay(5.2, function() -- line: 486
            -- upvalues: v51 (copy), n4 (ref), clearPickups (copy)
            if n4 == v51 then
                clearPickups()
            end
        end)
    end
end

local function retireBuilt() -- line: 495
    -- upvalues: Debris (copy), TweenService (copy), v5 (copy), t2 (copy), v11 (ref), n4 (ref), stopPickupVfx (copy)
    n4 += 1
    v11 = false

    for v54, v55 in t2 do
        t2[v54] = nil

        for _, v56 in v55.Pickups do
            v56.Handle:Destroy()

            local Part = v56.Part

            if Part.Parent ~= nil then
                stopPickupVfx(Part)
                TweenService:Create(Part, v5, {
                    Transparency = 1,
                    CFrame = Part.CFrame + Vector3.new(0, 16, 0)
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
end

local function adoptWave(p21, p22, p23) -- line: 520
    -- upvalues: v8 (ref), v9 (ref), t1 (ref), v10 (ref), retireBuilt (copy)
    retireBuilt()
    v8 = p21
    v9 = p22
    t1 = {}
    v10 = nil

    if p23 then
        for v57, v58 in p23 do
            local t6 = {}

            for _, v59 in v58 do
                t6[v59] = true
            end

            local t7 = t1

            t7[v57] = t6
        end
    end
end

local function syncZones(p24) -- line: 538
    -- upvalues: SammyEvent (copy), v9 (ref), t2 (copy), v10 (ref)
    local v60 = SammyEvent.ZoneIndexAt(p24.Position)

    if v60 == v10 then
        return
    end

    v10 = v60

    for v61 in t2 do
        if math.abs(v61 - v60) > 3 then
            local v63 = t2[v61]

            if v63 ~= nil then
                t2[v61] = nil

                for _, v64 in v63.Pickups do
                    local v65 = t2[v64.Zone]

                    if v65 then
                        v65.Pickups[v64.Id] = nil

                        local v66 = v65.Buckets[v64.Bucket]

                        if v66 then
                            v66[v64] = nil
                        end
                    end

                    v64.Handle:Destroy()
                    v64.Part:Destroy()
                end
            end
        end
    end

    for i = v60 - 3, v60 + 3 do
        local v67 = v9[i]

        if v67 ~= nil and t2[i] == nil then
            t2[i] = {
                NextId = 1,
                Source = SammyEvent.DecodePickups(v67),
                Pickups = {},
                Buckets = {}
            }
        end
    end
end

local function continueBuilds() -- line: 563
    -- upvalues: t1 (ref), t2 (copy), buildPickup (copy)
    local n5 = 400

    for v68, v69 in t2 do
        local v70 = t1[v68]

        while n5 > 0 and v69.NextId <= #v69.Source do
            local NextId = v69.NextId

            v69.NextId = NextId + 1

            if v70 == nil or not v70[NextId] then
                buildPickup(v68, v69, NextId, v69.Source[NextId])
                n5 -= 1
            end
        end

        if n5 <= 0 then
            return
        end
    end
end

local function spin(p25, p26) -- line: 581
    -- upvalues: SammyEvent (copy), t2 (copy), n3 (ref)
    local SpinSpeed = SammyEvent.SpinSpeed

    for _, v71 in t2 do
        for v72, v73 in v71.Buckets do
            local v75 = math.abs((v72 + 0.5) * 100 - p25.Position.X)

            if not (v75 > 800) and (not (v75 > 250) or (n3 + v72) % 4 == 0) then
                for v77 in v73 do
                    local Pickup = v77.Pickup

                    v77.Handle:SetCFrame(CFrame.new(Pickup.X, Pickup.Y, Pickup.Z) * CFrame.Angles(0, p26 * SpinSpeed + v77.Phase, 1.5707963267948966))
                end
            end
        end
    end
end

local function nearbyBuilt(p27, p28) -- line: 604
    -- upvalues: t2 (copy)
    local t8 = {}
    local v79 = math.floor(p27.Position.X / 100)

    for _, v80 in t2 do
        for i = v79 - 1, v79 + 1 do
            local v81 = v80.Buckets[i]

            if v81 ~= nil then
                for v82 in v81 do
                    local Pickup = v82.Pickup

                    if (Vector3.new(Pickup.X, Pickup.Y, Pickup.Z) - p27.Position).Magnitude <= p28 then
                        table.insert(t8, v82)
                    end
                end
            end
        end
    end

    return t8
end

local function playCollectSound() -- line: 625
    -- upvalues: LightVsDarknessSounds (copy), n1 (ref), n2 (ref)
    local elapsed = os.clock()

    if elapsed - n2 > 1.5 then
        n1 = 0
    end

    n1 += 1
    n2 = elapsed

    local v84 = math.min(n1 - 1, 12)
    local CollectNormalRing = LightVsDarknessSounds:FindFirstChild("CollectNormalRing")

    assert(CollectNormalRing and CollectNormalRing:IsA("Sound"), "LightVsDarknessSounds.CollectNormalRing must be a Sound")

    local clone = CollectNormalRing:Clone()

    clone.Parent = CollectNormalRing.Parent
    clone.PlayOnRemove = true
    clone.PlaybackSpeed = v84 * 0.06 + 1
    task.defer(function() -- line: 639
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
end

local function collect(p29) -- line: 644
    -- upvalues: Remotes (copy), SammyEvent (copy), SammyEventFlags (copy), v8 (ref), pullPickup (copy), nearbyBuilt (copy), playCollectSound (copy)
    local v86 = v8

    if v86 == nil then
        return
    end

    local v87 = SammyEvent.PickupRadius + SammyEventFlags.CollectRadiusPadding:Get()
    local v88 = SammyEventFlags.MagnetRadiusStuds:Get()

    for _, v89 in nearbyBuilt(p29, (math.max(v87, v88))) do
        if not v89.Pending then
            local Pickup = v89.Pickup
            local Magnitude = (Vector3.new(Pickup.X, Pickup.Y, Pickup.Z) - p29.Position).Magnitude

            if not (v87 < Magnitude) or not (v88 < Magnitude) then
                v89.Pending = true
                Remotes.SammyEvent.AskCollectPickup:FireServer(v86, v89.Zone, v89.Id)
                playCollectSound()
                pullPickup(v89, p29, true)
            end
        end
    end
end

local function onPickupCollected(p30, p31, p32, p33) -- line: 671
    -- upvalues: Players (copy), Player (copy), v8 (ref), t1 (ref), t2 (copy), playCollectVfx (copy), fadePickup (copy), pullPickup (copy)
    if p30 ~= v8 then
        return
    end

    local v90 = t1[p31]

    if v90 == nil then
        v90 = {}
        t1[p31] = v90
    end

    v90[p32] = true

    local v91 = t2[p31]
    local v92 = if v91 then v91.Pickups[p32] else nil

    if not v92 then
        return
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p33)
    local v93 = if PlayerByUserId == nil then nil else Player.FindRootPart(PlayerByUserId)

    if v93 ~= nil and v93:IsA("BasePart") then
        pullPickup(v92, v93, false)
    else
        playCollectVfx((Vector3.new(v92.Pickup.X, v92.Pickup.Y, v92.Pickup.Z)))
        fadePickup(v92)
    end
end

local function onPickupRespawned(p34, p35, p36) -- line: 699
    -- upvalues: v8 (ref), t1 (ref), t2 (copy), buildPickup (copy)
    if p34 ~= v8 then
        return
    end

    local v94 = t1[p35]

    if v94 then
        v94[p36] = nil
    end

    local v95 = t2[p35]

    if v95 and v95.Pickups[p36] == nil and p36 < v95.NextId then
        buildPickup(p35, v95, p36, v95.Source[p36])
    end
end

local function step() -- line: 713
    -- upvalues: Player (copy), LocalPlayer (copy), v8 (ref), n3 (ref), v11 (ref), stepPulls (copy), syncZones (copy), continueBuilds (copy), spin (copy), collect (copy)
    stepPulls(os.clock())

    if v8 ~= nil or v11 then
        local v96 = Player.FindPrimaryPart(LocalPlayer)

        if v96 ~= nil then
            n3 += 1
            spin(v96, (os.clock()))

            if v8 ~= nil then
                syncZones(v96)
                continueBuilds()
                collect(v96)
            end
        end
    end
end

local function dischargeGround(p37) -- line: 734
    -- upvalues: Workspace (copy), v13 (copy)
    local v97 = Workspace:Raycast(p37 + Vector3.new(0, 60, 0), Vector3.new(0, -200, 0), v13)

    return if v97 ~= nil then v97.Position.Y else nil
end

local function sweepDischarge(p38, p39, p40) -- line: 745
    -- upvalues: RunService (copy), Workspace (copy), SammyEvent (copy), Transient (copy), DischargePulse (copy), v13 (copy)
    local v98 = SammyEvent.Zones()
    local Bounds = v98[1].Bounds
    local Bounds2 = v98[#v98].Bounds
    local v99 = if p40 < 0 then Bounds.Position.X - Bounds.Size.X * 0.5 else Bounds2.Position.X + Bounds2.Size.X * 0.5
    local Rotation = DischargePulse.CFrame.Rotation
    local X = p39.X
    local v100 = X
    local Y = p39.Y
    local v101 = Y
    local Z = p39.Z
    local v102 = Z
    local v103 = p38:Add(DischargePulse:Clone())

    v103.CFrame = CFrame.new(X, Y, Z) * Rotation
    v103.Parent = Transient

    local v104

    v104 = p38:Add(RunService.Heartbeat:Connect(function(p41) -- line: 760
        -- upvalues: p38 (copy), p40 (copy), v98 (copy), Rotation (copy), v100 (ref), v101 (ref), v102 (ref), v103 (copy), v104 (ref), v99 (copy), Workspace (copy), SammyEvent (copy), v13 (copy)
        v100 += p40 * 350 * p41

        if (v99 - v100) * p40 <= 0 then
            p38:Remove(v103)
            p38:Remove(v104)
        else
            local Bounds = v98[SammyEvent.ZoneIndexAt((Vector3.new(v100, v101, v102)))].Bounds
            local v110 = v100
            local v112 = Workspace:Raycast(Vector3.new(v110, Bounds.Position.Y, Bounds.Position.Z) + Vector3.new(0, 60, 0), Vector3.new(0, -200, 0), v13)
            local v113 = (if v112 == nil then nil else v112.Position.Y) or Bounds.Position.Y
            local v115 = math.min(1, p41 * 10)

            v101 += (v113 - v101) * v115
            v102 += (Bounds.Position.Z - v102) * v115
            v103.CFrame = CFrame.new(v100, v101, v102) * Rotation
        end
    end))
end

local function discharge(p42) -- line: 776
    -- upvalues: Debris (copy), Workspace (copy), GuardAreaGeometry (copy), Player (copy), LocalPlayer (copy), Transient (copy), DischargePulse (copy), SeparationLine (copy), v13 (copy), sweepDischarge (copy)
    local v118 = Player.FindRootPart(LocalPlayer)

    if v118 ~= nil and v118:IsA("BasePart") then
        local clone = DischargePulse:Clone()

        clone.CFrame = CFrame.new(v118.Position) * DischargePulse.CFrame.Rotation
        clone.Parent = Transient
        Debris:AddItem(clone, 1)

        if not GuardAreaGeometry.IsPastLine(SeparationLine, v118.Position) then
            return
        end

        script.DischargeSFX:Play()

        local t10 = {
            Workspace.World.Build,
            Workspace.Terrain
        }
        local SABMap = Workspace:FindFirstChild("SABMap")

        if SABMap ~= nil then
            table.insert(t10, SABMap)
        end

        v13.FilterDescendantsInstances = t10
        sweepDischarge(p42, v118.Position, -1)
        sweepDischarge(p42, v118.Position, 1)
    end
end

local function start() -- line: 802
    -- upvalues: RunService (copy), Workspace (copy), Remotes (copy), SammyEvent (copy), v7 (ref), v8 (ref), v9 (ref), t1 (ref), v10 (ref), n1 (ref), t3 (copy), v12 (ref), clearPickups (copy), fadeOutWave (copy), retireBuilt (copy), adoptWave (copy), onPickupCollected (copy), onPickupRespawned (copy), step (copy), discharge (copy)
    local AssetTrove = v7.AssetTrove

    clearPickups()
    AssetTrove:Connect(Remotes.SammyEvent.PickupsSpawned.OnClientEvent, function(p43, p44) -- line: 805
        -- upvalues: v8 (ref), v9 (ref), t1 (ref), v10 (ref), retireBuilt (copy)
        retireBuilt()
        v8 = p43
        v9 = p44
        t1 = {}
        v10 = nil
    end)
    AssetTrove:Connect(Remotes.SammyEvent.PickupsCleared.OnClientEvent, function(p45) -- line: 808
        -- upvalues: v8 (ref), fadeOutWave (copy)
        if p45 == v8 then
            fadeOutWave()
        end
    end)
    AssetTrove:Connect(Remotes.SammyEvent.PickupCollected.OnClientEvent, onPickupCollected)
    AssetTrove:Connect(Remotes.SammyEvent.PickupRespawned.OnClientEvent, onPickupRespawned)

    local SammyEmpCharge = Workspace:GetAttribute("SammyEmpCharge")

    v12 = type(SammyEmpCharge) == "number" and SammyEmpCharge < SammyEvent.ChargeMax
    AssetTrove:Connect(Workspace:GetAttributeChangedSignal("SammyEmpCharge"), function() -- line: 818
        -- upvalues: AssetTrove (copy), Workspace (copy), SammyEvent (copy), v12 (ref), discharge (copy)
        local SammyEmpCharge = Workspace:GetAttribute("SammyEmpCharge")

        if type(SammyEmpCharge) == "number" then
            if SammyEmpCharge < SammyEvent.ChargeMax then
                v12 = true
            elseif v12 then
                v12 = false
                discharge(AssetTrove)
            end
        end
    end)
    AssetTrove:Connect(RunService.Heartbeat, step)
    AssetTrove:Add(function() -- line: 831
        -- upvalues: n1 (ref), t3 (copy), clearPickups (copy)
        clearPickups()

        for _, v119 in t3 do
            local Beam = v119.Beam

            if Beam then
                v119.Beam = nil
                Beam:Destroy()
            end

            local TargetAttachment = v119.TargetAttachment

            if TargetAttachment then
                v119.TargetAttachment = nil
                TargetAttachment:Destroy()
            end
        end

        table.clear(t3)
        n1 = 0
    end)
    AssetTrove:Add(task.spawn(function() -- line: 841
        -- upvalues: Remotes (copy), v7 (ref), v8 (ref), adoptWave (copy)
        local v120, v121, v122 = Remotes.SammyEvent.FetchPickups:InvokeServer()

        if type(v120) == "number" and v7.IsEventActive() and v8 == nil then
            adoptWave(v120, v121, v122)
        end
    end))
end

return function(p46) -- line: 851
    -- upvalues: v7 (ref), clearPickups (copy), start (copy)
    v7 = p46

    return {
        Start = start,
        Clear = clearPickups
    }
end
