-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ScrambleBossHazards = require(ReplicatedStorage.Shared.Util.ScrambleBossHazards)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Kit = require(script.Parent.Kit)
local Vfx = require(script.Parent.Vfx)
local MemberAttribute = PumpkinBossState.MemberAttribute
local PhaseOne = Vfx.PhaseOne
local t1 = {
    Charge = Vfx.PhaseOne,
    Shadow = PhaseOne
}
local t2 = {
    [Vfx.PhaseOne] = "BruteBombImpact",
    [Vfx.PhaseTwo] = "KingBarrageImpact"
}
local LocalPlayer = Players.LocalPlayer
local n1 = 0

local function now() -- line: 96
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function segmentRing(p1, p2, p3, p4) -- line: 100
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

local function placeRing(p5, p6, p7, p8, p9) -- line: 119
    local v1 = #p5
    local v2 = 6.283185307179586 * math.max(p7, 0.5) / v1 * 1.08

    for v3, v4 in p5 do
        local v5 = v3 / v1 * 3.141592653589793 * 2
        local v8 = Vector3.new(math.cos(v5), 0, (math.sin(v5))) * p7

        v4.Size = Vector3.new(p8, p9, v2)
        v4.CFrame = CFrame.lookAt(p6 + v8, p6 + v8 + Vector3.new(-math.sin(v5), 0, (math.cos(v5)))) * CFrame.new(0, p9 / 2, 0)
    end
end

local function setAll(p10, p11) -- line: 139
    for _, v13 in p10 do
        v13.Transparency = p11
    end
end

local function disc(p12, p13, p14, p15, p16) -- line: 145
    -- upvalues: Kit (copy)
    return Kit.Part({
        Name = "Disc",
        Shape = Enum.PartType.Cylinder,
        Color = p15,
        Transparency = p16,
        Size = Vector3.new(0.2, p14 * 2, p14 * 2),
        CFrame = CFrame.new(p13) * CFrame.Angles(0, 0, 1.5707963267948966),
        Parent = p12
    })
end

local function sizeDisc(p17, p18) -- line: 163
    p17.Size = Vector3.new(0.2, p18 * 2, p18 * 2)
end

local function triangle(p19, p20, p21, p22, p23) -- line: 167
    local v18 = p21 - p20
    local v19 = p22 - p20
    local v20 = p22 - p21
    local v21 = v18:Dot(v18)
    local v22 = v19:Dot(v19)
    local v23 = v20:Dot(v20)
    local v25, v26
    local v24 = p21

    if not (v22 < v21 and v23 < v21) then
        if v23 < v22 and v21 < v22 then
            v25 = p21
            v24 = p20
        else
            v25 = p20
        end

        v26 = p22
    else
        v25 = p22
        v26 = p20
    end

    local v27 = v24 - v25
    local v28 = v26 - v25
    local v29 = v26 - v24
    local Unit = v28:Cross(v27).Unit
    local Unit2 = v29:Cross(Unit).Unit
    local Unit3 = v29.Unit
    local v31 = math.abs((v27:Dot(Unit2)))
    local t5 = {}

    for i = 1, 2 do
        local WedgePart = Instance.new("WedgePart")

        WedgePart.Anchored = true
        WedgePart.CanCollide = false
        WedgePart.CanQuery = false
        WedgePart.CanTouch = false
        WedgePart.CastShadow = false
        WedgePart.Material = Enum.Material.Neon
        WedgePart.Color = p23
        WedgePart.Transparency = 0.6

        if i == 1 then
            WedgePart.Size = Vector3.new(0.2, v31, (math.abs((v27:Dot(Unit3)))))
            WedgePart.CFrame = CFrame.fromMatrix((v25 + v24) / 2, Unit, Unit2, Unit3)
        else
            WedgePart.Size = Vector3.new(0.2, v31, (math.abs((v28:Dot(Unit3)))))
            WedgePart.CFrame = CFrame.fromMatrix((v25 + v26) / 2, -Unit, Unit2, -Unit3)
        end

        WedgePart.Parent = p19
        table.insert(t5, WedgePart)
    end

    return t5
end

local function bombTemplate() -- line: 211
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")
    local PumpkinBoss = HalloweenDimension and HalloweenDimension:FindFirstChild("PumpkinBoss")
    local PumpkinCannonball = PumpkinBoss and PumpkinBoss:FindFirstChild("PumpkinCannonball")

    return if PumpkinCannonball and PumpkinCannonball:IsA("Model") then PumpkinCannonball else nil
end

local function bombModel(p24, p25) -- line: 219
    -- upvalues: bombTemplate (copy)
    local v36 = bombTemplate()

    if not v36 then
        return nil
    end

    local clone = v36:Clone()

    clone:ScaleTo(clone:GetScale() * 1.8)

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
        end
    end

    clone:PivotTo(CFrame.new(p25))
    clone.Parent = p24

    return clone
end

local function fitIndicator(p26, p27, p28) -- line: 243
    local t6 = {}
    local n2 = 0
    local n3 = 0

    for _, descendant in p26:GetDescendants() do
        if descendant:IsA("Attachment") then
            table.insert(t6, descendant)
            n2 = math.max(n2, (math.abs(descendant.Position.X)))
            n3 = math.max(n3, (math.abs(descendant.Position.Z)))
        end
    end

    local v39 = if n2 > 0 then p27 / (n2 * 2) else 1
    local v40 = if n3 > 0 then p28 / (n3 * 2) else 1

    for _, descendant in p26:GetDescendants() do
        if descendant:IsA("Beam") and descendant.Attachment0 and descendant.Attachment1 then
            local v41 = descendant.Attachment1.Position - descendant.Attachment0.Position
            local v43 = if math.abs(v41.X) > math.abs(v41.Y) then v40 else v39

            descendant.Width0 *= v43
            descendant.Width1 *= v43
        end
    end

    for _, v44 in t6 do
        local Position = v44.Position

        v44.Position = Vector3.new(Position.X * v39, Position.Y, Position.Z * v40)
    end
end

local function laneIndicator(p29, p30, p31, p32) -- line: 270
    -- upvalues: Vfx (copy), t1 (copy), fitIndicator (copy)
    local v47 = t1[p29.Style or ""]
    local v48 = v47 and Vfx.Template(v47, { "PumpkinCharge", "ChargeIndicator" })

    if v48 == nil then
        return nil
    end

    local v49 = Vfx.Place(v48, CFrame.fromMatrix(p31, p32, (Vector3.new(0, 1, 0))))

    fitIndicator(v49, p29.Length or 100, p29.Width or 20)
    v49.Parent = p30

    return v49
end

local function bombCarrier(p33, p34, p35) -- line: 288
    -- upvalues: Vfx (copy)
    local v50 = Vfx.Template(p33, { "PumpkinThrow", "Pumpkin" })

    if v50 == nil then
        return nil
    end

    local v51 = Vfx.Place(v50, CFrame.new(p35), 1.2)

    v51.Parent = p34

    return Vfx.Hold(v51)
end

local function fireSound(p36, p37, p38) -- line: 300
    -- upvalues: Kit (copy), n1 (ref)
    if not (n1 >= 6) and p36.Parent ~= nil then
        local v52 = Kit.Loop("FireLoop", p37, p36)

        if v52 ~= nil then
            n1 += 1

            local v53 = false

            local function release() -- line: 312
                -- upvalues: v53 (ref), n1 (ref)
                if not v53 then
                    v53 = true
                    n1 -= 1
                end
            end

            v52.Destroying:Once(release)
            task.delay(math.max(p38 - 0.4, 0), function() -- line: 319
                -- upvalues: v52 (copy), v53 (ref), Kit (copy), n1 (ref)
                if v52.Parent then
                    Kit.FadeOut(v52, 0.8)
                end

                if not v53 then
                    v53 = true
                    n1 -= 1
                end
            end)
        end
    end
end

local function puddleFire(p39, p40, p41, p42) -- line: 327
    -- upvalues: ScrambleBossHazards (copy), Vfx (copy), fireSound (copy)
    local v55 = ScrambleBossHazards.ActiveSeconds(p39) + math.min(p41, 0)
    local v56 = if v55 > 0 then Vfx.Template(Vfx.PhaseOne, { "PumpkinCharge", "ChargeRun" }) else nil

    if v56 == nil then
        return
    end

    local v57 = (p39.Radius or 10) * 1.7724538509055159 * 0.85
    local v58 = Vector3.new(1, 0, 0) * v57 / 2

    task.delay(math.max(p41, 0), function() -- line: 343
        -- upvalues: p40 (copy), p42 (copy), v55 (copy), v56 (copy), v57 (copy), v58 (copy), Vfx (copy), fireSound (copy)
        local v59 = Vfx.Strip(v56, CFrame.new(p40), 1, {
            Particles = 1,
            Density = Vfx.FireDensity * 0.35
        })

        for _, descendant in v59.Root:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local Lifetime = descendant.Lifetime

                descendant.Lifetime = NumberRange.new(math.min(Lifetime.Min, 1), (math.min(Lifetime.Max, 1)))
            end
        end

        v59:Span(p40 - v58, p40 + v58, v57)
        fireSound(p42, p40, v55)
        task.delay(v55, function() -- line: 359
            -- upvalues: v59 (copy)
            v59:Stop()
        end)
    end)
end

local t7 = {}

t7.__index = t7

function t7.new(p43, p44) -- line: 368
    -- upvalues: RunService (copy), Kit (copy), t7 (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "PumpkinHazards"
    Folder.Parent = Kit.Debris()
    p43:Add(Folder)

    local v63 = setmetatable({
        Views = {},
        Folder = Folder,
        Arena = p44
    }, t7)

    p43:Connect(RunService.RenderStepped, function() -- line: 380
        -- upvalues: v63 (copy)
        v63:Step()
    end)

    return v63
end

function t7.Add(p45, p46) -- line: 387
    -- upvalues: Workspace (copy), ScrambleBossHazards (copy), PumpkinBossState (copy), Kit (copy), Vfx (copy), segmentRing (copy), placeRing (copy), disc (copy), triangle (copy), bombModel (copy), laneIndicator (copy), bombCarrier (copy), puddleFire (copy)
    local v64 = (p45.Arena:GetAttribute(PumpkinBossState.Attributes.FloorY) or p46.Origin.Y) + 0.15
    local v65 = v64 + 1
    local Folder = Instance.new("Folder")

    Folder.Name = ("Hazard%*"):format(p46.Id)
    Folder.Parent = p45.Folder

    local v66 = Kit.StyleColor(p46.Style)
    local t9 = {
        Reported = false,
        Struck = false,
        Spec = p46,
        Folder = Folder,
        Parts = {},
        Color = v66,
        Floor = v64,
        FloorY = v65
    }
    local v67 = Vector3.new(p46.Origin.X, v65, p46.Origin.Z)
    local v68 = Vector3.new(p46.Origin.X, v64, p46.Origin.Z)
    local v69 = p46.At - Workspace:GetServerTimeNow()

    if p46.Kind == "Ring" then
        t9.Parts.Warn = disc(Folder, v67, 6, v66, 0.5)
        t9.Parts.Ring = segmentRing(Folder, 44, v66, 1)
    elseif p46.Kind == "Puddle" and p46.Style == "Fire" then
        puddleFire(p46, v68, v69, Folder)
    elseif p46.Kind ~= "Strike" and p46.Kind ~= "Missile" and p46.Kind ~= "Puddle" then
        if p46.Kind == "Cone" then
            local Unit = Kit.Flat(p46.Direction or Vector3.new(0, 0, 1)).Unit
            local v70 = p46.Radius or 30
            local v72 = math.rad((p46.Angle or 60) / 2)
            local v75 = math.max(3, (math.ceil((p46.Angle or 60) / 20)))
            local t10 = {}

            for i = 0, v75 - 1 do
                local v76 = -v72 + i / v75 * v72 * 2
                local v77 = -v72 + (i + 1) / v75 * v72 * 2
                local v78 = v67 + CFrame.Angles(0, v76, 0) * Unit * v70
                local v79 = v67 + CFrame.Angles(0, v77, 0) * Unit * v70

                for _, v80 in triangle(Folder, v67, v78, v79, v66) do
                    table.insert(t10, v80)
                end
            end

            t9.Parts.Cone = t10
        elseif p46.Kind == "Lane" then
            local Unit = Kit.Flat(p46.Direction or Vector3.new(0, 0, 1)).Unit
            local v81 = p46.Length or 100
            local v82 = v67 + Unit * v81 / 2

            t9.Indicator = if v69 > 0 then laneIndicator(p46, Folder, v82, Unit) else nil

            local Parts = t9.Parts

            if p46.Tick ~= nil or t9.Indicator ~= nil then
                Parts.Lane = nil
            else
                Parts.Lane = Kit.Part({
                    Name = "Lane",
                    Transparency = 0.6,
                    Color = v66,
                    Size = Vector3.new(p46.Width or 20, 0.2, v81),
                    CFrame = CFrame.lookAt(v82, v82 + Unit),
                    Parent = Folder
                })
            end
        else
            t9.Parts.Fill = disc(Folder, v67, p46.Radius or 10, v66, 0.5)
        end
    else
        t9.Parts.Fill = disc(Folder, v67, 0.5, v66, 0.45)
        t9.Parts.Edge = segmentRing(Folder, 20, v66, 0.2)
        placeRing(t9.Parts.Edge, v67, p46.Radius or 10, 0.6, 0.3)

        if p46.Kind == "Strike" and p46.Style == "Vine" and v69 > 0 then
            local v84 = (p46.Radius or 14) / 14

            Vfx.Play(Vfx.PhaseTwo, { "Vines", "Emit" }, CFrame.new(v68), v84, v69)
            task.delay(math.max(v69 - 0.4, 0), function() -- line: 424
                -- upvalues: Folder (copy), v68 (copy), Kit (copy)
                if Folder.Parent and Kit.Claim("VineSummon", 4, 0.5) then
                    Kit.Sound("VineSummon", v68)
                end
            end)
        end

        if p46.Kind == "Missile" then
            local v86

            if p46.Style == "Bomb" then
                v86 = bombModel(Folder, p46.From or v68)

                local v87 = Vfx.PhaseOf(p45.Arena)

                if v69 > 0 then
                    local v88 = (p46.Radius or 12) / 12 * 1.2

                    Vfx.Play(v87, { "PumpkinThrow", "Explosion" }, CFrame.new(v68), v88, v69)
                end

                t9.Carrier = bombCarrier(v87, Folder, p46.From or v68)
            end

            t9.Parts.Orb = v86 or Kit.Part({
                Name = "Orb",
                Size = Vector3.new(3, 3, 3),
                Shape = Enum.PartType.Ball,
                Color = v66,
                CFrame = CFrame.new(p46.From or v68),
                Parent = Folder
            })
        end
    end

    p45.Views[p46.Id] = t9
    task.delay(p46.Warn + ScrambleBossHazards.ActiveSeconds(p46) + 1.2, function() -- line: 499
        -- upvalues: p45 (copy), p46 (copy), Folder (copy)
        p45.Views[p46.Id] = nil
        Folder:Destroy()
    end)
end

function t7.Step(p47) -- line: 505
    -- upvalues: Workspace (copy), ScrambleBossHazards (copy), Remotes (copy), Kit (copy), Vfx (copy), MemberAttribute (copy), t2 (copy), LocalPlayer (copy), placeRing (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local Character = LocalPlayer.Character
    local v89 = Character

    if Character then
        v89 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    local v90 = Character ~= nil and Character.FloorMaterial == Enum.Material.Air
    local v91 = LocalPlayer:GetAttribute(MemberAttribute) == true

    for v92, v93 in p47.Views do
        local Spec = v93.Spec
        local v94 = ServerTimeNow - Spec.At
        local v95 = Spec.Warn
        local v97 = math.clamp(1 + v94 / math.max(v95, 0.01), 0, 1)
        local v98 = Spec.Origin.X
        local v99 = v93.Floor
        local Orb = Spec.Origin.Z
        local v96 = Vector3.new(v98, v99, Orb)

        v98 = ScrambleBossHazards.ActiveSeconds(Spec)
        v99 = v94 >= 0 and v94 <= v98

        local v100 = ServerTimeNow * 18

        v98 = math.sin(v100) * 0.5 + 0.5

        if Spec.Kind == "Ring" then
            if v94 < 0 then
                v93.Parts.Warn.Transparency = v98 * 0.4 + 0.3
                Orb = v93.Parts.Warn
                v95 = v97 * 10 + 6
                Orb.Size = Vector3.new(0.2, v95 * 2, v95 * 2)
            else
                v93.Parts.Warn.Transparency = 1
                placeRing(v93.Parts.Ring, v96, ScrambleBossHazards.RingRadius(Spec, v94), Spec.Width or 2, 2.4)
                Orb = v93.Parts.Ring
                v95 = if v99 then 0.05 else 1

                for _, v103 in Orb do
                    v103.Transparency = v95
                end
            end
        elseif Spec.Kind == "Strike" or Spec.Kind == "Missile" then
            if v94 < 0 then
                Orb = v93.Parts.Fill
                v100 = (Spec.Radius or 10) * v97
                v95 = math.max(v100, 0.5)

                local v104 = v95 * 2

                Orb.Size = Vector3.new(0.2, v104, v95 * 2)
                v93.Parts.Fill.Transparency = 0.55 - v97 * 0.25
                Orb = v93.Parts.Orb

                if Orb then
                    v95 = Spec.From or v96

                    local v106 = Kit.Flat(v95 - v96).Magnitude
                    local Angles

                    if v106 < 1 then
                        v100 = v95:Lerp(v96, v97 * v97)
                    else
                        v104 = (v95 - v96).Magnitude * 0.35
                        v106 = math.max(v104, 25)
                        v104 = v95:Lerp(v96, v97)
                        Angles = math.sin(v97 * 3.141592653589793) * v106
                        v100 = v104 + Vector3.new(0, Angles, 0)
                    end

                    v95 = v97 * 5
                    Orb:PivotTo(CFrame.new(v100) * CFrame.Angles(v95, v95 * 0.6, 0))
                    v95 = v93.Carrier

                    if v95 then
                        v104 = v100 - (v93.CarrierAt or v100)
                        Angles = if v104.Magnitude > 0.001 then CFrame.lookAt(v100, v100 + v104) else CFrame.new(v100) * v95.Root.CFrame.Rotation
                        v95:Move(Angles)
                        v93.CarrierAt = v100
                    end
                end
            else
                Orb = v93.Struck

                if not Orb then
                    v93.Struck = true
                    v93.Parts.Fill.Transparency = 1

                    for _, v108 in v93.Parts.Edge do
                        v108.Transparency = 1
                    end

                    if v93.Parts.Orb then
                        v93.Parts.Orb:Destroy()
                        v93.Parts.Orb = nil
                    end

                    if v93.Carrier then
                        v93.Carrier:Stop()
                        v93.Carrier = nil
                    end

                    if Spec.Style ~= "Bomb" then
                        Kit.Burst(v96, Spec.Radius or 10, v93.Color, 0.35)
                    end

                    Orb = if Spec.Style == "Bomb" then t2[Vfx.PhaseOf(p47.Arena)] elseif Spec.Style == nil or Spec.Style == "Vine" then nil else "Strike"

                    if Orb and Kit.Claim(Orb, 3, 0.25) then
                        Kit.Sound(Orb, v96, 1, 0.95 + math.random() * 0.1)
                    end
                end
            end
        elseif Spec.Kind == "Puddle" and v93.Parts.Fill then
            if v94 < 0 then
                Orb = v93.Parts.Fill
                v100 = (Spec.Radius or 10) * v97
                v95 = math.max(v100, 0.5)
                Orb.Size = Vector3.new(0.2, v95 * 2, v95 * 2)
                v93.Parts.Fill.Transparency = 0.7 - v97 * 0.2
            elseif v99 then
                Orb = v93.Parts.Fill
                v95 = Spec.Radius or 10
                Orb.Size = Vector3.new(0.2, v95 * 2, v95 * 2)
                v93.Parts.Fill.Transparency = v98 * 0.15 + 0.35
            else
                v93.Parts.Fill.Transparency = 1

                for _, v113 in v93.Parts.Edge do
                    v113.Transparency = 1
                end
            end
        else
            Orb = Spec.Kind

            if Orb == "Cone" then
                for _, v114 in v93.Parts.Cone do
                    if v94 < 0 then
                        v114.Transparency = v98 * 0.2 + 0.62
                    else
                        v114.Transparency = math.min(1, 0.62 + v94 * 4)
                    end
                end
            else
                Orb = Spec.Kind

                if Orb == "Lane" then
                    Orb = v93.Parts.Lane

                    if v93.Indicator and v94 >= 0 then
                        v93.Indicator:Destroy()
                        v93.Indicator = nil
                    end

                    if Orb ~= nil then
                        if v94 < 0 then
                            Orb.Transparency = 0.6
                        elseif v99 then
                            Orb.Transparency = 0.4
                        else
                            Orb.Transparency = 1
                        end
                    end
                end
            end
        end

        if v99 and v91 then
            if v93.Reported then
                if Spec.Tick ~= nil and (v93.NextReport or 0) <= ServerTimeNow and v89 ~= nil and Character ~= nil and Character.Health > 0 and (not v90 or Spec.Jumpable ~= true) and ScrambleBossHazards.Contains(Spec, v94, v89.Position, v90, 0) then
                    v93.Reported = true
                    v93.NextReport = ServerTimeNow + (Spec.Tick or 0)
                    Remotes.PumpkinBoss.HazardHit:FireServer(v92)

                    if Spec.Damage > 0 then
                        Kit.Shake(3, 16, 0.5)
                    end
                end
            elseif v89 ~= nil and Character ~= nil and Character.Health > 0 and (not v90 or Spec.Jumpable ~= true) and ScrambleBossHazards.Contains(Spec, v94, v89.Position, v90, 0) then
                v93.Reported = true
                v93.NextReport = ServerTimeNow + (Spec.Tick or 0)
                Remotes.PumpkinBoss.HazardHit:FireServer(v92)

                if Spec.Damage > 0 then
                    Kit.Shake(3, 16, 0.5)
                end
            end
        end
    end
end

return t7
