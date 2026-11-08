-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local Butterflies = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Butterflies")
local t1 = {}
local Folder
local t2 = {}
local t3 = {}
local n1 = 0
local t4 = {}

local function trackSpeed(p1, p2) -- line: 69
    return p1.Tier.FlapSpeed / 15 * p2
end

local function getFolder() -- line: 77
    -- upvalues: Workspace (copy), Folder (ref)
    if Folder and Folder.Parent then
        return Folder
    end

    local Folder2 = Instance.new("Folder")

    Folder2.Name = "ButterflyBloomSwarm"
    Folder2.Parent = Workspace
    Folder = Folder2

    return Folder2
end

local function setAlpha(p3, p4) -- line: 88
    p3.Alpha = p4

    for v1, v2 in p3.Fadeables do
        local v3 = 1 - (1 - p3.Opacity[v1]) * p4

        if v2:IsA("Decal") then
        end

        v2.Transparency = v3
    end
end

local function build(p5) -- line: 101
    -- upvalues: Workspace (copy), ButterflyCatalog (copy), Butterflies (copy), Folder (ref), t4 (copy), setAlpha (copy)
    local v4 = Butterflies:FindFirstChild(p5.Tier)
    local v5, clone, PrimaryPart, t5, t6, t7, t8, t9, t10, Animator

    if v4 ~= nil and v4:IsA("Model") and v4.PrimaryPart ~= nil then
        v5 = ButterflyCatalog.Get(p5.Tier)
        clone = v4:Clone()
        clone:ScaleTo(v4:GetScale() * v5.Scale)
        PrimaryPart = clone.PrimaryPart
        t5 = {}
        t6 = {}
        t7 = {}
        t8 = {}
        t9 = {}
        t10 = {}

        local AnimationController = clone:FindFirstChildOfClass("AnimationController")

        if AnimationController then
            Animator = AnimationController:FindFirstChildOfClass("Animator")
        end

        for _, descendant in clone:GetDescendants() do
            if not Animator or not descendant:IsA("BasePart") or descendant == PrimaryPart then
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                    descendant.CastShadow = false

                    local v8 = PrimaryPart.CFrame:ToObjectSpace(descendant.CFrame)

                    table.insert(t5, descendant)
                    table.insert(t6, v8)

                    if descendant:GetAttribute("Wing") == true then
                        table.insert(t7, CFrame.new(0, v8.Y, 0))
                        table.insert(t8, v8.X >= 0 and 1 or -1)
                    else
                        table.insert(t7, CFrame.identity)
                        table.insert(t8, 0)
                    end

                    if descendant.Transparency < 1 then
                        table.insert(t9, descendant)
                        table.insert(t10, descendant.Transparency)
                    end
                elseif descendant:IsA("Decal") then
                    table.insert(t9, descendant)
                    table.insert(t10, descendant.Transparency)
                end
            else
                descendant.Anchored = false
                descendant.Massless = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
                descendant.CastShadow = false

                if descendant.Transparency < 1 then
                    table.insert(t9, descendant)
                    table.insert(t10, descendant.Transparency)
                end
            end
        end

        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v10 = ButterflyCatalog.PositionAt(p5, ServerTimeNow)
        local t11 = {
            Heading = Vector3.new(0, 0, -1),
            HoldUntil = 0,
            Leaving = false,
            Alpha = 0,
            Playing = nil,
            PlayingSpeed = 0,
            Tracked = false,
            SteppedAt = 0,
            PinnedUntil = 0,
            PinPosition = nil,
            Flight = p5,
            Tier = v5,
            Model = clone,
            Body = PrimaryPart,
            Parts = t5,
            Rest = t6,
            Hinge = t7,
            Side = t8,
            Fadeables = t9,
            Opacity = t10,
            Position = v10,
            FlapPhase = p5.Seed % 628 / 100,
            Animator = Animator,
            Tracks = {}
        }

        setAlpha(t11, 0)
        clone:PivotTo(CFrame.new(v10))

        local Folder2

        if not (Folder and Folder.Parent) then
            Folder2 = Instance.new("Folder")
            Folder2.Name = "ButterflyBloomSwarm"
            Folder2.Parent = Workspace
            Folder = Folder2
        else
            Folder2 = Folder
        end

        clone.Parent = Folder2

        if Animator then
            for v11, v12 in ButterflyCatalog.TierAnimations[p5.Tier] or ButterflyCatalog.Animations do
                local Animation = Instance.new("Animation")

                Animation.AnimationId = v12

                local track = Animator:LoadAnimation(Animation)

                track.Looped = true
                t11.Tracks[v11] = track
            end

            t4.PlayTrack(t11, "Fly", 1)
        end

        return t11
    end

    warn((("[ButterflyBloom] Assets.Models.Butterflies.%* needs a PrimaryPart"):format(p5.Tier)))

    return nil
end

local function destroy(p6) -- line: 203
    p6.Model:Destroy()
end

function t4.Add(p7) -- line: 211
    -- upvalues: t1 (copy), build (copy)
    local v13 = t1[p7.Id]

    if v13 then
        v13.Flight = p7

        return v13
    end

    local v14 = build(p7)

    if v14 then
        t1[p7.Id] = v14
    end

    return v14
end

function t4.Update(p8) -- line: 224
    -- upvalues: t1 (copy), t4 (copy)
    local v15 = t1[p8.Id]

    if v15 ~= nil then
        v15.Flight = p8
        v15.HoldUntil = 0
    else
        t4.Add(p8)
    end
end

function t4.Get(p9) -- line: 234
    -- upvalues: t1 (copy)
    return t1[p9]
end

function t4.PlayTrack(p10, p11, p12) -- line: 238
    local v16 = p10.Tracks[p11]

    if v16 ~= nil then
        local v17 = p10.Tier.FlapSpeed / 15 * p12

        if p10.Playing == p11 then
            if p10.PlayingSpeed ~= v17 then
                p10.PlayingSpeed = v17
                v16:AdjustSpeed(v17)
            end
        else
            local v18 = if p10.Playing then p10.Tracks[p10.Playing] else nil

            if v18 then
                v18:Stop(0.15)
            end

            p10.Playing = p11
            p10.PlayingSpeed = v17
            v16:Play(0.15, 1, v17)
        end
    end
end

function t4.Pin(p13, p14, p15) -- line: 260
    -- upvalues: t1 (copy), t4 (copy)
    local v19 = t1[p13]

    if v19 == nil then
        return
    end

    v19.PinPosition = p14
    v19.PinnedUntil = os.clock() + p15
    v19.Position = p14
    t4.PlayTrack(v19, "Struggle", 1)
end

function t4.Hold(p16, p17) -- line: 271
    -- upvalues: t1 (copy)
    local v20 = t1[p16]

    if v20 then
        v20.HoldUntil = os.clock() + p17
    end
end

function t4.Take(p18) -- line: 278
    -- upvalues: t1 (copy)
    local v21 = t1[p18]

    if v21 == nil then
        return nil
    end

    t1[p18] = nil
    v21.Leaving = true

    return v21
end

function t4.Release(p19, p20) -- line: 288
    -- upvalues: setAlpha (copy)
    local v22 = p20 or 0.7
    local elapsed = os.clock()
    local Alpha = p19.Alpha

    task.spawn(function() -- line: 292
        -- upvalues: p19 (copy), v22 (copy), elapsed (copy), Alpha (copy), setAlpha (copy)
        while p19.Model.Parent do
            local v24 = math.clamp((os.clock() - elapsed) / v22, 0, 1)

            setAlpha(p19, Alpha * (1 - v24))

            if v24 >= 1 then
                break
            end

            task.wait()
        end

        p19.Model:Destroy()
    end)
end

function t4.Remove(p21) -- line: 305
    -- upvalues: t4 (copy)
    local v25 = t4.Take(p21)

    if v25 then
        t4.Release(v25)
    end
end

function t4.Clear(p22) -- line: 312
    -- upvalues: t1 (copy), t4 (copy)
    for v26 in t1 do
        local v27 = t4.Take(v26)

        if v27 then
            if p22 then
                v27.Model:Destroy()
            else
                t4.Release(v27)
            end
        end
    end
end

function t4.Count() -- line: 325
    -- upvalues: t1 (copy)
    local n2 = 0

    for _ in t1 do
        n2 += 1
    end

    return n2
end

function t4.Each() -- line: 333
    -- upvalues: t1 (copy)
    return t1
end

function t4.Pose(p23, p24, p25, p26, p27) -- line: 337
    for v28, v29 in p23.Parts do
        local v30 = p23.Rest[v28]
        local v31 = p23.Hinge[v28]
        local v32 = if p23.Side[v28] == 0 then p24 * v30 else p24 * v31 * CFrame.Angles(0, 0, p25 * p23.Side[v28]) * v31:Inverse() * v30

        table.insert(p26, v29)
        table.insert(p27, v32)
    end
end

function t4.Step(p28, p29) -- line: 359
    -- upvalues: Workspace (copy), ButterflyCatalog (copy), t1 (copy), t2 (copy), t3 (copy), n1 (ref), t4 (copy), setAlpha (copy)
    table.clear(t2)
    table.clear(t3)
    n1 += 1

    local CurrentCamera = Workspace.CurrentCamera
    local Position = if CurrentCamera then CurrentCamera.CFrame.Position else nil

    for v33, v34 in t1 do
        local Flight = v34.Flight

        if v34.Alpha < 1 then
            local v36 = math.clamp((p28 - Flight.Born) / 0.6, 0, 1)

            if Flight.FleeAt > Flight.Born then
                v36 = 1
            end

            setAlpha(v34, (math.max(v34.Alpha, v36)))
        end

        if not Position or (n1 + v33) % 3 == 0 or not ((v34.Position - Position).Magnitude > 250) then
            local v54 = p29 < v34.PinnedUntil

            if not v54 and v34.PinPosition then
                Flight.FleeFrom = v34.PinPosition
                v34.PinPosition = nil
            end

            local v55 = v54 or p29 < v34.HoldUntil

            if v54 then
                v34.Position = v34.PinPosition
                v34.Tracked = false
            elseif v55 then
                v34.Tracked = false
            else
                local v56 = ButterflyCatalog.PositionAt(Flight, p28)
                local v57 = p28 - v34.SteppedAt

                if v34.Tracked and v57 > 0 then
                    local v58 = v56 - v34.Position
                    local v59 = Vector3.new(v58.X, 0, v58.Z)

                    if v59.Magnitude > v57 * 0.05 then
                        v34.Heading = v34.Heading:Lerp(v59.Unit, 0.2)
                    end
                end

                v34.Position = v56
                v34.Tracked = true
            end

            v34.SteppedAt = p28

            if v34.Animator and not v54 then
                local v60 = p28 < Flight.FleeAt + Flight.FleeSeconds
                local v61 = not v60

                v61 = v61 and math.sin(p29 * 0.45 + v34.FlapPhase) > 0.8
                t4.PlayTrack(v34, if v61 then "Glide" else "Fly", if v60 then 1.6 elseif v55 then 0.25 else 1)
            end

            local v63 = if v55 then 0.25 else 1
            local v66 = math.rad(math.sin(p29 * (v34.Tier.FlapSpeed * v63) + v34.FlapPhase) * 52 + 14)
            local Unit = if v34.Heading.Magnitude > 0 then v34.Heading.Unit else Vector3.new(0, 0, -1)
            local v69 = math.rad(math.sin(p29 * 1.7 + v34.FlapPhase) * 10)
            local v70 = CFrame.lookAt(v34.Position, v34.Position + Unit) * CFrame.Angles(-0.20943951023931956, 0, v69)

            t4.Pose(v34, v70, v66, t2, t3)
        end
    end

    if #t2 > 0 then
        Workspace:BulkMoveTo(t2, t3, Enum.BulkMoveMode.FireCFrameChanged)
    end
end

function t4.Nearest(p30, p31, p32) -- line: 436
    -- upvalues: t1 (copy)
    local v71 = Vector3.new(p31.X, 0, p31.Z)
    local v72 = if v71.Magnitude > 0 then v71.Unit else Vector3.new(0, 0, -1)
    local n3 = 1e999
    local v73

    for _, v74 in t1 do
        if not (v74.Alpha < 0.5) then
            local v75 = v74.Position - p30
            local Magnitude = v75.Magnitude

            if not (p32 < Magnitude) then
                local v76 = Vector3.new(v75.X, 0, v75.Z)
                local v77 = Magnitude - (if v76.Magnitude > 0 then v72:Dot(v76.Unit) else 1) * 5

                if v77 < n3 then
                    n3 = v77
                    v73 = v74
                end
            end
        end
    end

    return v73
end

function t4.Tween(p33, p34, p35, p36) -- line: 461
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p33, TweenInfo.new(p34, p36 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p35)

    tween:Play()

    return tween
end

return t4
