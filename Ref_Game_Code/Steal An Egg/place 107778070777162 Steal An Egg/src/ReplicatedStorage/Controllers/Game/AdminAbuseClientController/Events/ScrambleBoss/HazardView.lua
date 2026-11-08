-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ScrambleBossHazards = require(ReplicatedStorage.Shared.Util.ScrambleBossHazards)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Kit = require(script.Parent.Kit)
local Vfx = require(script.Parent.Vfx)
local v1 = Color3.fromRGB(255, 40, 40)
local v2 = Color3.fromRGB(110, 255, 70)
local t1 = {
    Missile = 2.2,
    Puddle = 3
}
local t2 = {
    Floor = true,
    Mech = true,
    LeaveTeleport = true,
    BossSpawn = true,
    PlayerSpawn = true,
    Center = true,
    HubBlocker = true
}
local LocalPlayer = Players.LocalPlayer

local function now() -- line: 88
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function segmentRing(p1, p2, p3, p4) -- line: 92
    -- upvalues: Kit (copy)
    local t3 = {}

    for i = 1, p2 do
        t3[i] = Kit.Part({
            Name = "Segment",
            Size = Vector3.new(1, 1, 1),
            Color = p3,
            Transparency = p4,
            Parent = p1
        })
    end

    return t3
end

local function placeRing(p5, p6, p7, p8, p9) -- line: 112
    local v3 = #p5
    local v4 = 6.283185307179586 * math.max(p7, 0.5) / v3 * 1.08

    for v5, v6 in p5 do
        local v7 = v5 / v3 * 3.141592653589793 * 2
        local v10 = Vector3.new(math.cos(v7), 0, (math.sin(v7))) * p7

        v6.Size = Vector3.new(p8, p9, v4)
        v6.CFrame = CFrame.lookAt(p6 + v10, p6 + v10 + Vector3.new(-math.sin(v7), 0, (math.cos(v7)))) * CFrame.new(0, p9 / 2, 0)
    end
end

local function disc(p10, p11, p12, p13, p14) -- line: 132
    -- upvalues: Kit (copy)
    return Kit.Part({
        Name = "Disc",
        Shape = Enum.PartType.Cylinder,
        Color = p13,
        Transparency = p14,
        Size = Vector3.new(0.2, p12 * 2, p12 * 2),
        CFrame = CFrame.new(p11) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = p10
    })
end

local function triangle(p15, p16, p17, p18, p19) -- line: 150
    local v17 = p17 - p16
    local v18 = p18 - p16
    local v19 = p18 - p17
    local v20 = v17:Dot(v17)
    local v21 = v18:Dot(v18)
    local v22 = v19:Dot(v19)
    local v24, v25
    local v23 = p17

    if not (v21 < v20 and v22 < v20) then
        if v22 < v21 and v20 < v21 then
            v24 = p17
            v23 = p16
        else
            v24 = p16
        end

        v25 = p18
    else
        v24 = p18
        v25 = p16
    end

    local v26 = v23 - v24
    local v27 = v25 - v24
    local v28 = v25 - v23
    local Unit = v27:Cross(v26).Unit
    local Unit2 = v28:Cross(Unit).Unit
    local Unit3 = v28.Unit
    local v30 = math.abs((v26:Dot(Unit2)))
    local t5 = {}

    for i = 1, 2 do
        local WedgePart = Instance.new("WedgePart")

        WedgePart.Anchored = true
        WedgePart.CanCollide = false
        WedgePart.CanQuery = false
        WedgePart.CanTouch = false
        WedgePart.CastShadow = false
        WedgePart.Material = Enum.Material.Neon
        WedgePart.Color = p19
        WedgePart.Transparency = 0.6

        if i == 1 then
            WedgePart.Size = Vector3.new(0.2, v30, (math.abs((v26:Dot(Unit3)))))
            WedgePart.CFrame = CFrame.fromMatrix((v24 + v23) / 2, Unit, Unit2, Unit3)
        else
            WedgePart.Size = Vector3.new(0.2, v30, (math.abs((v27:Dot(Unit3)))))
            WedgePart.CFrame = CFrame.fromMatrix((v24 + v25) / 2, -Unit, Unit2, -Unit3)
        end

        WedgePart.Parent = p15
        table.insert(t5, WedgePart)
    end

    return t5
end

local t6 = {}

t6.__index = t6

function t6.new(p20, p21) -- line: 199
    -- upvalues: RunService (copy), Kit (copy), t6 (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "ScrambleHazards"
    Folder.Parent = Kit.Debris()
    p20:Add(Folder)

    local v35 = setmetatable({
        Views = {},
        Folder = Folder,
        Arena = p21,
        Handles = {},
        SoundAt = {}
    }, t6)

    p20:Connect(RunService.RenderStepped, function() -- line: 213
        -- upvalues: v35 (copy)
        v35:Step()
    end)
    p20:Add(function() -- line: 216
        -- upvalues: v35 (copy)
        for v36 in v35.Handles do
            v36:Stop()
        end

        table.clear(v35.Handles)
    end)

    return v35
end

function t6.Hold(p22, p23, p24, p25, p26) -- line: 226
    -- upvalues: Vfx (copy)
    local v37 = Vfx.Hold(p23, p24, p25, nil, p26)

    if v37 then
        p22.Handles[v37] = true
    end

    return v37
end

function t6.SoundOnce(p27, p28, p29, p30, p31) -- line: 241
    -- upvalues: Kit (copy)
    local elapsed = os.clock()

    if not (elapsed - (p27.SoundAt[p28] or (-1e999)) < p31) then
        p27.SoundAt[p28] = elapsed
        Kit.Sound(p28, p29, p30)
    end
end

function t6.Release(p32, p33) -- line: 257
    if p33 and p32.Handles[p33] then
        p32.Handles[p33] = nil
        p33:Stop()
    end
end

function t6.BeamCore(p34, p35, p36) -- line: 264
    if p34.CoreMech ~= p35 then
        p34.CoreMech = p35
        p34.Cores = {}
    end

    local v38 = p34.Cores[p36]

    if v38 and v38.Capsule:IsDescendantOf(p35) then
        return v38
    end

    local descendant, descendant2

    for _, descendant3 in p35:GetDescendants() do
        if descendant3:IsA("Bone") then
            if descendant3.Name == "Capsule3." .. p36 then
                descendant = descendant3
            elseif descendant3.Name == "SideArmPivot5." .. p36 then
                descendant2 = descendant3
            end
        end
    end

    if descendant == nil or descendant2 == nil then
        return nil
    end

    local t8 = {
        Capsule = descendant,
        Base = descendant2
    }

    p34.Cores[p36] = t8

    return t8
end

function t6.Muzzle(p37, p38) -- line: 296
    local Mech = p37.Arena:FindFirstChild("Mech")
    local v39 = p38.Side or "R"
    local v40 = Mech and p37:BeamCore(Mech, v39)

    if v40 then
        local TransformedWorldCFrame = v40.Capsule.TransformedWorldCFrame
        local Magnitude = (TransformedWorldCFrame.Position - v40.Base.TransformedWorldCFrame.Position).Magnitude

        return TransformedWorldCFrame.Position + TransformedWorldCFrame.YVector * Magnitude
    end

    local v41 = Mech and Mech:FindFirstChild("Claw" .. v39)
    local Muzzle = v41 and v41:FindFirstChild("Muzzle")

    if not (Muzzle and Muzzle:IsA("Attachment")) then
        return p38.From
    end

    return Muzzle.WorldPosition
end

function t6.BeamHeading(p39, p40, p41, p42) -- line: 316
    -- upvalues: ScrambleBossHazards (copy), Kit (copy)
    local v42 = ScrambleBossHazards.BeamHeading(p40, p41)
    local Mech = p39.Arena:FindFirstChild("Mech")

    Mech = Mech and Mech:IsA("Model") and Mech.PrimaryPart

    if Mech == nil or p42 == nil then
        return v42
    end

    local v43 = Kit.Flat(p42 - Mech.Position)

    if v43.Magnitude < 4 or v43.Unit:Dot(v42) < 0.8660254037844387 then
        return v42
    end

    return v43.Unit
end

local function stretchLane(p43, p44, p45) -- line: 337
    for _, descendant in p43:GetDescendants() do
        if descendant:IsA("Attachment") then
            if math.abs(descendant.Position.Z) > 1 then
                local Position = descendant.Position

                descendant.Position = Vector3.new(Position.X * p45, Position.Y, math.sign(Position.Z) * p44 / 2)
            elseif descendant:IsA("Beam") then
                descendant.Width0 *= p45
                descendant.Width1 *= p45
            end
        elseif descendant:IsA("Beam") then
            descendant.Width0 *= p45
            descendant.Width1 *= p45
        end
    end
end

local function sweepEnds(p46) -- line: 350
    local t9 = {}

    for _, descendant in p46:GetDescendants() do
        if descendant:IsA("Attachment") and descendant.Position.Z < -1 then
            table.insert(t9, descendant)
        end
    end

    return t9
end

local function taperFromHand(p47) -- line: 361
    for _, descendant in p47:GetDescendants() do
        if descendant:IsA("Beam") then
            descendant.Width0 = math.min(descendant.Width0, descendant.Width1) * 0.2
        end
    end
end

local function stretchSweep(p48, p49) -- line: 369
    for _, v46 in p48 do
        v46.Position = Vector3.new(v46.Position.X, v46.Position.Y, -p49)
    end
end

local function aimedSpec(p50) -- line: 375
    if p50.Spec.Kind ~= "Beam" or p50.Heading == nil then
        return p50.Spec
    end

    local v48 = table.clone(p50.Spec)

    v48.Direction = p50.Heading
    v48.Angle = 0

    return v48
end

local function coverParams(p51) -- line: 387
    -- upvalues: t2 (copy)
    local t10 = {}

    for _, child in p51:GetChildren() do
        if not t2[child.Name] and child:FindFirstChildOfClass("Humanoid") == nil then
            table.insert(t10, child)
        end
    end

    local v49 = RaycastParams.new()

    v49.FilterType = Enum.RaycastFilterType.Include
    v49.FilterDescendantsInstances = t10
    v49.RespectCanCollide = true

    return v49
end

local function beamReach(p52, p53, p54) -- line: 403
    -- upvalues: Workspace (copy)
    local v50 = p52.Spec.Length or 150

    if p52.CoverParams ~= nil then
        local v53 = Workspace:Raycast(Vector3.new(p53.X, p52.FloorY + 2.5, p53.Z), p54 * v50, p52.CoverParams)

        if v53 then
            return v53.Distance
        end
    end

    return v50
end

local function beamTouches(p55, p56) -- line: 415
    -- upvalues: ScrambleBossHazards (copy), Kit (copy)
    local Muzzle, Tip = p55.Muzzle, p55.Tip

    if p55.Spec.Kind ~= "Beam" or Muzzle == nil or Tip == nil then
        return true
    end

    local v54 = Kit.Flat(Tip - Muzzle)
    local Magnitude = v54.Magnitude

    if Magnitude < 0.001 then
        return false
    end

    local v55 = Kit.Flat(p56 - Muzzle):Dot(v54 / Magnitude)

    if -ScrambleBossHazards.BodyRadius <= v55 then
        return v55 <= Magnitude + ScrambleBossHazards.BodyRadius
    end

    return false
end

local function covered(p57, p58) -- line: 432
    -- upvalues: Workspace (copy)
    if p57.CoverParams == nil then
        return false
    end

    local v56 = p57.FloorY + 2.5
    local v57 = p57.Muzzle or p57.Spec.Origin
    local v58 = Vector3.new(v57.X, v56, v57.Z)

    return Workspace:Raycast(v58, Vector3.new(p58.X, v56, p58.Z) - v58, p57.CoverParams) ~= nil
end

function t6.Add(p59, p60) -- line: 445
    -- upvalues: ScrambleBossHazards (copy), Kit (copy), Vfx (copy), v1 (copy), v2 (copy), t1 (copy), segmentRing (copy), placeRing (copy), disc (copy), triangle (copy), stretchLane (copy), coverParams (copy)
    local v60 = (p59.Arena:GetAttribute("FloorY") or p60.Origin.Y) + 0.15
    local Folder = Instance.new("Folder")

    Folder.Name = ("Hazard%*"):format(p60.Id)
    Folder.Parent = p59.Folder

    local t11 = {
        Reported = false,
        Struck = false,
        Spec = p60,
        Folder = Folder,
        Parts = {},
        FloorY = v60
    }
    local v61 = Vector3.new(p60.Origin.X, v60, p60.Origin.Z)

    if p60.Kind == "Ring" then
        t11.Parts.Telegraph = segmentRing(Folder, 24, v1, 0.35)
        t11.Parts.Warn = disc(Folder, v61, 6, v1, 0.5)
        t11.Parts.Ring = segmentRing(Folder, 44, v2, 0.05)

        for _, v62 in t11.Parts.Ring do
            v62.Transparency = 1
        end
    elseif p60.Kind == "Beam" then
        if p60.Cover then
            t11.CoverParams = coverParams(p59.Arena)
        end
    elseif p60.Kind == "Strike" then
        t11.Parts.Fill = disc(Folder, v61, 0.5, v1, 0.45)
        t11.Parts.Edge = segmentRing(Folder, 20, v1, 0.2)
        placeRing(t11.Parts.Edge, v61, p60.Radius or 10, 0.6, 0.3)
    elseif p60.Kind == "Cone" and p60.Style == "Bite" then
        local Unit = Kit.Flat(p60.Direction or Vector3.new(0, 0, 1)).Unit
        local v63 = Vfx.CrocScale(p59.Arena)
        local CrocBite = Vfx.Template("CrocBite")
        local RootOffset = CrocBite and CrocBite:GetAttribute("RootOffset")
        local v64 = if typeof(RootOffset) == "Vector3" then RootOffset * v63 else Vector3.new(0, 0, 0)
        local v65 = p59:Hold("CrocBite", CFrame.lookAt(v61, v61 + Unit) * CFrame.new(v64), v63, true)

        if v65 then
            Vfx.Pulse(v65.Root, p60.Warn + ScrambleBossHazards.ActiveSeconds(p60) + 0.2)
            t11.Parts.Indicator = v65
        end
    elseif p60.Kind == "Cone" then
        local Unit = Kit.Flat(p60.Direction or Vector3.new(0, 0, 1)).Unit
        local v66 = p60.Radius or 30
        local v68 = math.rad((p60.Angle or 60) / 2)
        local v71 = math.max(5, (math.ceil((p60.Angle or 60) / 20)))
        local t12 = {}

        for i = 0, v71 - 1 do
            local v72 = -v68 + i / v71 * v68 * 2
            local v73 = -v68 + (i + 1) / v71 * v68 * 2
            local v74 = v61 + CFrame.Angles(0, v72, 0) * Unit * v66
            local v75 = v61 + CFrame.Angles(0, v73, 0) * Unit * v66

            for _, v76 in triangle(Folder, v61, v74, v75, v1) do
                table.insert(t12, v76)
            end
        end

        t11.Parts.Cone = t12
    elseif p60.Kind == "Missile" or p60.Kind == "Puddle" then
        t11.Parts.Fill = disc(Folder, v61, 0.5, v1, 0.45)
        t11.Parts.Edge = segmentRing(Folder, 20, v1, 0.2)
        placeRing(t11.Parts.Edge, v61, p60.Radius or 10, 0.6, 0.3)
        t11.Parts.Orb = p59:Hold("ToxicOrb", CFrame.new(p60.From or v61), t1[p60.Kind])
        p59:SoundOnce(p60.Kind == "Missile" and "RapidMissileFire" or "ToxicOrbs", p60.From or v61, 1, 0.5)
    elseif p60.Kind == "Grab" then
        t11.Parts.Fill = disc(Folder, v61, p60.Radius or 14, v1, 0.6)
        t11.Parts.Edge = segmentRing(Folder, 24, v1, 0.1)
        placeRing(t11.Parts.Edge, v61, p60.Radius or 14, 1, 0.5)
        t11.Parts.Closer = segmentRing(Folder, 24, v1, 0.3)
    elseif p60.Kind == "Lane" then
        local Unit = Kit.Flat(p60.Direction or Vector3.new(0, 0, 1)).Unit
        local v79 = p60.Length or 100
        local v80 = v61 + Unit * v79 / 2
        local SpiderLane = p59:Hold("SpiderLane", CFrame.lookAt(v80, v80 + Unit))

        if SpiderLane then
            stretchLane(SpiderLane.Root, v79, (p60.Width or 40) / 32)
            t11.Parts.Indicator = SpiderLane
        end
    elseif p60.Kind == "Pillars" then
        local t13 = {}
        local t14 = {}

        for _, v81 in p60.Points or {} do
            local v82 = Vector3.new(v81.X, t11.FloorY, v81.Z)

            table.insert(t13, disc(Folder, v82, p60.Radius or 10, v1, 0.5))

            local LaserPillar = p59:Hold("LaserPillar", Vfx.Frame("LaserPillar", v82))

            if LaserPillar then
                local Beam = LaserPillar.Root:FindFirstChild("Beam")

                if Beam then
                    Vfx.Toggle(Beam, false)
                end

                table.insert(t14, {
                    Handle = LaserPillar,
                    Beam = Beam
                })
            end
        end

        t11.Parts.Fills = t13
        t11.Parts.Pillars = t14
    elseif p60.Kind == "Sweep" then
        t11.Parts.Edge = segmentRing(Folder, 32, v1, 0.25)
        placeRing(t11.Parts.Edge, v61, p60.Radius or 40, 1.2, 0.4)
        t11.Parts.Fill = disc(Folder, v61, p60.Radius or 40, v1, 0.8)
    end

    p59.Views[p60.Id] = t11
    task.delay(p60.Warn + ScrambleBossHazards.ActiveSeconds(p60) + 1.2, function() -- line: 553
        -- upvalues: p59 (copy), p60 (copy), Folder (copy), t11 (copy)
        p59.Views[p60.Id] = nil

        for _, v84 in t11.Parts do
            if type(v84) == "table" and v84.Stop then
                p59:Release(v84)
            end
        end

        for _, v85 in t11.Parts.Pillars or {} do
            p59:Release(v85.Handle)
        end

        Folder:Destroy()
    end)
end

function t6.CheckBallContact(p61, p62) -- line: 567
    -- upvalues: ScrambleBossHazards (copy), Remotes (copy), Kit (copy), LocalPlayer (copy)
    local Arena = p61.Arena

    if Arena:GetAttribute("Phase") == "Ball" and Arena:GetAttribute("BallTarget") == LocalPlayer.UserId and not Arena:GetAttribute("BallStunned") then
        local Ball = Arena:FindFirstChild("Ball")
        local v86 = Ball and Ball.PrimaryPart

        if v86 ~= nil and not (os.clock() - (p61.LastContact or 0) < 0.3) and v86.Size.Y / 2 + ScrambleBossHazards.BodyRadius >= Kit.Flat(p62.Position - v86.Position).Magnitude then
            p61.LastContact = os.clock()
            Remotes.ScrambleBoss.HazardHit:FireServer(-1)
        end
    end
end

function t6.Step(p63) -- line: 590
    -- upvalues: Workspace (copy), ScrambleBossHazards (copy), Remotes (copy), Kit (copy), Vfx (copy), LocalPlayer (copy), placeRing (copy), sweepEnds (copy), taperFromHand (copy), beamTouches (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local Character = LocalPlayer.Character
    local v87 = Character

    if Character then
        v87 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    local v88 = Character ~= nil and Character.FloorMaterial == Enum.Material.Air
    local v89 = LocalPlayer:GetAttribute("InScrambleArena") == true

    if v89 and v87 and Character and Character.Health > 0 then
        p63:CheckBallContact(v87)
    end

    for v90, v91 in p63.Views do
        local Spec = v91.Spec
        local v92 = ServerTimeNow - Spec.At
        local Orb = Spec.Warn
        local v94 = math.clamp(1 + v92 / math.max(Orb, 0.01), 0, 1)
        local v96
        local v93 = Vector3.new(Spec.Origin.X, v91.FloorY, Spec.Origin.Z)
        local v95 = ScrambleBossHazards.ActiveSeconds(Spec)

        v96 = v92 >= 0 and v92 <= v95

        local v98, v99, new
        local v100 = ServerTimeNow * 18
        local v97 = math.sin(v100) * 0.5 + 0.5

        if Spec.Kind == "Ring" then
            if v92 < 0 then
                placeRing(v91.Parts.Telegraph, v93, v94 * 10 + 6, 0.8, 0.3)

                for _, v101 in v91.Parts.Telegraph do
                    v101.Transparency = v97 * 0.4 + 0.2
                end
            else
                for _, v102 in v91.Parts.Telegraph do
                    v102.Transparency = 1
                end

                v91.Parts.Warn.Transparency = 1
                Orb = ScrambleBossHazards.RingRadius(Spec, v92)
                v98 = if v96 then 0.05 else 1
                placeRing(v91.Parts.Ring, v93, Orb, Spec.Width or 2, 2.4)

                for _, v103 in v91.Parts.Ring do
                    v103.Transparency = v98
                end
            end
        else
            local v104, Z, LaserSweep, X, v105

            if Spec.Kind == "Beam" then
                Orb = p63:Muzzle(Spec)
                v98 = p63:BeamHeading(Spec, v92, Orb)
                v91.Heading = v98
                v100 = Orb or v93 + v98 * 10 + Vector3.new(0, 1.5, 0)
                LaserSweep = v100.X
                new = v91.FloorY + 1.5
                v104 = v100.Z
                v99 = Vector3.new(LaserSweep, new, v104)
                v104 = v91.Spec.Length or 150

                if v91.CoverParams ~= nil then
                    local X = v100.X
                    local v106 = v91.FloorY + 2.5

                    Z = v100.Z
                    v105 = Vector3.new(X, v106, Z)
                    X = Workspace:Raycast(v105, v98 * v104, v91.CoverParams)

                    if X then
                        v104 = X.Distance
                    end
                end

                Orb = v99 + v98 * v104
                v91.Muzzle = v100
                v91.Tip = Orb
                v99 = Orb - v100

                if v96 and v91.Parts.Sweep == nil and not v91.Struck then
                    v91.Struck = true
                    LaserSweep = p63:Hold("LaserSweep", Vfx.Frame("LaserSweep", v100, v99))

                    if LaserSweep then
                        taperFromHand(LaserSweep.Root)
                        v91.Parts.SweepEnds = sweepEnds(LaserSweep.Root)
                        v91.Parts.Sweep = LaserSweep
                    end

                    Kit.Sound("LaserBeam", v100, 1.2)
                    Kit.ShakeFrom(v100, 3, 200)
                end

                if v91.Parts.Sweep then
                    v91.Parts.Sweep:Move(Vfx.Frame("LaserSweep", v100, v99))
                    LaserSweep = v91.Parts.SweepEnds
                    new = v99.Magnitude

                    for _, v107 in LaserSweep do
                        X = v107.Position.X
                        v107.Position = Vector3.new(X, v107.Position.Y, -new)
                    end
                end

                if v96 and v89 and v87 and (v91.NextRumble or 0) <= ServerTimeNow then
                    v91.NextRumble = ServerTimeNow + 0.16
                    v99 = Kit.Flat(v87.Position - v93)

                    if v99:Dot(v98) > 0 then
                        new = v99:Dot(v98:Cross((Vector3.new(0, 1, 0))))
                        LaserSweep = math.abs(new)
                    else
                        LaserSweep = v99.Magnitude
                    end

                    v104 = 1 - LaserSweep / 45
                    new = math.clamp(v104, 0, 1)
                    Kit.Shake(new * 2.4 + 0.7, 18, 0.3)
                end

                if v95 < v92 and not v91.Ended then
                    v91.Ended = true
                    p63:Release(v91.Parts.Sweep)
                end
            elseif Spec.Kind == "Strike" then
                if v92 < 0 then
                    v98 = (Spec.Radius or 10) * v94
                    Orb = math.max(v98, 0.5)
                    v98 = v91.Parts.Fill
                    LaserSweep = Orb * 2
                    new = Orb * 2
                    v98.Size = Vector3.new(0.2, LaserSweep, new)
                    v91.Parts.Fill.Transparency = 0.55 - v94 * 0.25
                elseif not v91.Struck then
                    v91.Struck = true
                    v91.Parts.Fill.Transparency = 1

                    for _, v109 in v91.Parts.Edge do
                        v109.Transparency = 1
                    end

                    Kit.Sound("Strike", v93, 0.6, 0.9 + math.random() * 0.2)
                end
            elseif Spec.Kind == "Missile" or Spec.Kind == "Puddle" then
                Orb = v91.Parts.Orb

                if v92 < 0 then
                    v100 = (Spec.Radius or 10) * v94
                    v98 = math.max(v100, 0.5)
                    v100 = v91.Parts.Fill
                    new = v98 * 2
                    v104 = v98 * 2
                    v100.Size = Vector3.new(0.2, new, v104)
                    v91.Parts.Fill.Transparency = 0.55 - v94 * 0.25
                    v98 = Spec.From or v93
                    v99 = (v98 - v93).Magnitude * 0.35
                    v100 = math.max(v99, 25)

                    if Orb then
                        new = CFrame.new
                        v105 = v98:Lerp(v93, v94)
                        X = v94 * 3.141592653589793
                        Z = math.sin(X) * v100
                        Orb:Move(new(v105 + Vector3.new(0, Z, 0)))
                    end
                else
                    v98 = v91.Struck

                    if not v98 then
                        v91.Struck = true
                        p63:Release(Orb)
                        v91.Parts.Fill.Transparency = 1

                        for _, v110 in v91.Parts.Edge do
                            v110.Transparency = 1
                        end

                        v98 = Spec.Radius or 10
                        Vfx.Burst("ToxicSplat", CFrame.new(v93), v98 / 6.5)

                        if Spec.Kind == "Missile" then
                            Kit.Sound("Strike", v93, 0.5, 1.1 + math.random() * 0.2)
                            Kit.ShakeFrom(v93, 2, 90)
                        else
                            p63:SoundOnce("ToxicPuddles", v93, 1, 0.35)
                            v91.Parts.Pool = p63:Hold("ToxicPuddle", CFrame.new(v93), v98 / 6)
                        end
                    end
                end

                if Spec.Kind == "Puddle" and v91.Parts.Pool and v95 - 2 <= v92 then
                    p63:Release(v91.Parts.Pool)
                    v91.Parts.Pool = nil
                end
            elseif Spec.Kind == "Grab" then
                Orb = v91.Parts.Fill

                if v92 < 0 then
                    Orb.Transparency = v97 * 0.3 + 0.35
                else
                    Orb.Transparency = 1
                end

                for _, v111 in v91.Parts.Edge do
                    v111.Transparency = v92 < 0 and 0.05 or 1
                end

                Orb = (Spec.Radius or 14) * ((1 - v94) * 1.6 + 1)
                placeRing(v91.Parts.Closer, v93, Orb, 0.8, 0.4)

                for _, v112 in v91.Parts.Closer do
                    v112.Transparency = v92 < 0 and 0.25 or 1
                end
            elseif Spec.Kind == "Lane" then
                if v95 < v92 and v91.Parts.Indicator then
                    p63:Release(v91.Parts.Indicator)
                    v91.Parts.Indicator = nil
                end
            elseif Spec.Kind == "Pillars" then
                for _, v113 in v91.Parts.Fills do
                    if v92 < 0 then
                        v113.Transparency = 0.6 - v94 * 0.3 + v97 * 0.1
                    else
                        v113.Transparency = 1
                    end
                end

                if v92 >= 0 and not v91.Struck then
                    v91.Struck = true

                    for _, v114 in v91.Parts.Pillars do
                        if v114.Beam then
                            Vfx.Toggle(v114.Beam, true)
                        end
                    end

                    Kit.Sound("VerticalLasers", nil, 1)
                    Kit.Shake(2, 20, 0.6)
                end

                if v95 < v92 and not v91.Ended then
                    v91.Ended = true

                    for _, v115 in v91.Parts.Pillars do
                        p63:Release(v115.Handle)
                    end
                end
            elseif Spec.Kind ~= "Cone" then
                Orb = Spec.Kind

                if Orb == "Cone" then
                    for _, v116 in v91.Parts.Cone do
                        if v92 < 0 then
                            v116.Transparency = v97 * 0.2 + 0.62
                        else
                            v105 = 0.62 + v92 * 4
                            v116.Transparency = math.min(1, v105)
                        end
                    end
                else
                    Orb = Spec.Kind

                    if Orb == "Sweep" then
                        Orb = v91.Parts.Fill

                        if v92 < 0 then
                            Orb.Transparency = 0.85 - v94 * 0.25
                        else
                            Orb.Transparency = 1
                        end

                        for _, v117 in v91.Parts.Edge do
                            if v92 < 0 then
                                v117.Transparency = v97 * 0.4 + 0.1
                            else
                                v117.Transparency = 1
                            end
                        end
                    end
                end
            elseif Spec.Style == "Bite" then
                if v95 < v92 and v91.Parts.Indicator then
                    p63:Release(v91.Parts.Indicator)
                    v91.Parts.Indicator = nil
                end
            elseif Spec.Kind == "Cone" then
                for _, v118 in v91.Parts.Cone do
                    if v92 < 0 then
                        v118.Transparency = v97 * 0.2 + 0.62
                    else
                        v105 = 0.62 + v92 * 4
                        v118.Transparency = math.min(1, v105)
                    end
                end
            else
                Orb = Spec.Kind

                if Orb == "Sweep" then
                    Orb = v91.Parts.Fill

                    if v92 < 0 then
                        Orb.Transparency = 0.85 - v94 * 0.25
                    else
                        Orb.Transparency = 1
                    end

                    for _, v119 in v91.Parts.Edge do
                        if v92 < 0 then
                            v119.Transparency = v97 * 0.4 + 0.1
                        else
                            v119.Transparency = 1
                        end
                    end
                end
            end
        end

        if v96 and v89 then
            if v91.Reported then
                if Spec.Tick ~= nil and (v91.NextReport or 0) <= ServerTimeNow and v87 ~= nil and Character ~= nil then
                    Orb = Character.Health

                    if Orb > 0 then
                        Orb = ScrambleBossHazards.Contains

                        if v91.Spec.Kind ~= "Beam" or v91.Heading == nil then
                            v98 = v91.Spec
                        else
                            v98 = table.clone(v91.Spec)
                            v98.Direction = v91.Heading
                            v98.Angle = 0
                        end

                        Orb = Orb(v98, v92, v87.Position, v88, 0)

                        if Orb then
                            Orb = beamTouches(v91, v87.Position)

                            if Orb then
                                v98 = v87.Position
                                v100 = v91.CoverParams

                                if v100 ~= nil then
                                    v95 = v91.FloorY + 2.5
                                    v93 = v91.Muzzle or v91.Spec.Origin
                                    v99 = v93.X
                                    new = v93.Z
                                    v100 = Vector3.new(v99, v95, new)
                                    v99 = v98.X
                                    new = v98.Z
                                    Orb = Workspace:Raycast(v100, Vector3.new(v99, v95, new) - v100, v91.CoverParams) ~= nil
                                else
                                    Orb = false
                                end

                                if not Orb then
                                    v91.Reported = true
                                    v91.NextReport = ServerTimeNow + (Spec.Tick or 0)
                                    Remotes.ScrambleBoss.HazardHit:FireServer(v90)
                                    Kit.Shake(3, 16, 0.5)
                                end
                            end
                        end
                    end
                end
            elseif v87 ~= nil and Character ~= nil then
                Orb = Character.Health

                if Orb > 0 then
                    Orb = ScrambleBossHazards.Contains

                    if v91.Spec.Kind ~= "Beam" or v91.Heading == nil then
                        v98 = v91.Spec
                    else
                        v98 = table.clone(v91.Spec)
                        v98.Direction = v91.Heading
                        v98.Angle = 0
                    end

                    Orb = Orb(v98, v92, v87.Position, v88, 0)

                    if Orb then
                        Orb = beamTouches(v91, v87.Position)

                        if Orb then
                            v98 = v87.Position
                            v100 = v91.CoverParams

                            if v100 ~= nil then
                                v95 = v91.FloorY + 2.5
                                v93 = v91.Muzzle or v91.Spec.Origin
                                v99 = v93.X
                                new = v93.Z
                                v100 = Vector3.new(v99, v95, new)
                                v99 = v98.X
                                new = v98.Z
                                Orb = Workspace:Raycast(v100, Vector3.new(v99, v95, new) - v100, v91.CoverParams) ~= nil
                            else
                                Orb = false
                            end

                            if not Orb then
                                v91.Reported = true
                                v91.NextReport = ServerTimeNow + (Spec.Tick or 0)
                                Remotes.ScrambleBoss.HazardHit:FireServer(v90)
                                Kit.Shake(3, 16, 0.5)
                            end
                        end
                    end
                end
            end
        end
    end
end

return t6
