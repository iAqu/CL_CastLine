-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Depths = require(script.Parent.Depths)
local Double = require(script.Parent.Double)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Hands = require(script.Parent.Hands)
local Kit = require(script.Parent.Kit)
local Overlay = require(script.Parent.Overlay)
local Score = require(script.Parent.Score)
local SewerCave = require(ReplicatedStorage.Shared.Util.SewerCave)
local Splash = require(script.Parent.Splash)
local Stage = require(script.Parent.Stage)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = CFrame.new(6200, 30000, 20900)
local v2 = Color3.fromRGB(215, 250, 245)
local v3 = Color3.fromRGB(70, 176, 138)
local v4 = Color3.fromRGB(8, 52, 46)
local v5 = Color3.fromRGB(170, 255, 236)
local v6 = table.freeze({
    ["1"] = 90,
    ["2"] = 70,
    ["3"] = 55
})
local v7 = table.freeze({
    ["1"] = 360,
    ["2"] = 300,
    ["3"] = 240
})
local v8 = table.freeze({
    ["1"] = -6,
    ["2"] = -3,
    ["3"] = 0
})
local Looks = Kit.Looks
local v9 = false
local t1
local t2 = {}

local function eyeOf(p1) -- line: 125
    local Whirlpool = p1.Context.Whirlpool

    if Whirlpool == nil or Whirlpool.Parent == nil then
        return p1.Root.Position - Vector3.new(0, 4, 0), nil
    end

    return Whirlpool:GetBoundingBox().Position, Whirlpool
end

local function surfaceBelow(p2, p3, p4) -- line: 134
    -- upvalues: Workspace (copy)
    local v10 = RaycastParams.new()

    v10.FilterType = Enum.RaycastFilterType.Exclude
    v10.FilterDescendantsInstances = {
        p2.Character,
        p2.Folder
    }
    v10.RespectCanCollide = false

    local v11 = Workspace:Raycast(Vector3.new(p3.X, p4, p3.Z), Vector3.new(0, -80, 0), v10)

    if v11 then
        return v11.Position.Y
    end

    return p3.Y
end

local function cloneRings(p5, p6, p7) -- line: 143
    local t3 = {}

    if p6 ~= nil then
        local v12 = CFrame.new(p7)

        for _, v13 in { "1", "2", "3" } do
            local v14 = p6:FindFirstChild(v13)

            if v14 ~= nil then
                for _, descendant in v14:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        local Archivable = descendant.Archivable

                        descendant.Archivable = true

                        local clone = descendant:Clone()

                        descendant.Archivable = Archivable

                        for _, child in clone:GetChildren() do
                            if child:IsA("LuaSourceContainer") then
                                child:Destroy()
                            end
                        end

                        clone.Anchored = true
                        clone.CanCollide = false
                        clone.CanQuery = false
                        clone.CanTouch = false
                        clone.Parent = p5.Folder
                        p5.Scenery:Add(clone)
                        descendant.LocalTransparencyModifier = 1
                        p5.Scenery:Add(function() -- line: 174
                            -- upvalues: descendant (copy)
                            descendant.LocalTransparencyModifier = 0
                        end)
                        table.insert(t3, {
                            Angle = 0,
                            Part = clone,
                            Original = descendant,
                            Offset = v12:ToObjectSpace(descendant.CFrame),
                            Folder = v13
                        })
                    end
                end
            end
        end
    end

    return t3
end

local function stepRings(p8, p9, p10, p11) -- line: 189
    -- upvalues: v6 (copy), v7 (copy), v8 (copy)
    local State = p8.State
    local Rings, Eye = State.Rings, State.Eye

    for _, v15 in Rings do
        local v16 = v6[v15.Folder] or 60
        local v17 = v7[v15.Folder] or 240

        v15.Angle = v15.Angle + math.rad((math.lerp(v16, v17, p10))) * p9

        local v19 = (v8[v15.Folder] or 0) * p11

        v15.Part.CFrame = CFrame.new(Eye + Vector3.new(0, v19, 0)) * CFrame.Angles(0, v15.Angle, 0) * v15.Offset
        v15.Original.LocalTransparencyModifier = 1
    end
end

local function dropRings(p12) -- line: 205
    local State = p12.State

    for _, v20 in State.Rings do
        v20.Part:Destroy()
        v20.Original.LocalTransparencyModifier = 0
    end

    State.Rings = {}
end

local function footTrail(p13) -- line: 214
    -- upvalues: Kit (copy)
    local t5 = {}
    local Double = p13.Double

    if Double ~= nil then
        for _, v21 in { "LeftFoot", "RightFoot", "Left Leg", "Right Leg" } do
            local v22 = Double.Model:FindFirstChild(v21)

            if v22 ~= nil and v22:IsA("BasePart") then
                local Attachment = Instance.new("Attachment")

                Attachment.Position = Vector3.new(-0.5, -v22.Size.Y / 2, 0)
                Attachment.Parent = v22

                local Attachment2 = Instance.new("Attachment")

                Attachment2.Position = Vector3.new(0.5, -v22.Size.Y / 2, 0)
                Attachment2.Parent = v22

                local Trail = Instance.new("Trail")

                Trail.Attachment0 = Attachment
                Trail.Attachment1 = Attachment2
                Trail.Lifetime = 0.35
                Trail.MinLength = 0.05
                Trail.FaceCamera = true
                Trail.LightEmission = 0.4
                Trail.Color = ColorSequence.new(Kit.Foam)
                Trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.15),
                    NumberSequenceKeypoint.new(1, 1)
                })
                Trail.WidthScale = NumberSequence.new(1, 0)
                Trail.Parent = v22
                table.insert(t5, Trail)
            end
        end
    end

    return t5
end

local function limb(p14, p15) -- line: 250
    local Double = p14.Double

    if Double ~= nil then
        for _, v25 in p15 do
            local v26 = Double.Model:FindFirstChild(v25)

            if v26 ~= nil and v26:IsA("BasePart") then
                return v26
            end
        end
    end

    return nil
end

local function gripFrame(p16, p17, p18) -- line: 264
    local v27 = p16 - p17

    if v27.Magnitude < 0.01 then
        v27 = Vector3.new(0, 1, 0)
    end

    local Unit = v27.Unit
    local v28 = p18 - p16
    local v29 = v28 - Unit * v28:Dot(Unit)

    if v29.Magnitude < 0.01 then
        v29 = if math.abs(Unit.Y) < 0.9 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)
    end

    return CFrame.lookAt(p16, p16 + v29.Unit, Unit)
end

local function setLook(p19, p20, p21, p22) -- line: 278
    -- upvalues: Kit (copy)
    Kit.Mix(p19.Grade.Look, p20, p21, p22)
end

local function cameraIgnore(p23) -- line: 282
    local t6 = {
        p23.Character,
        p23.Folder
    }
    local Whirlpool = p23.Context.Whirlpool

    if Whirlpool then
        table.insert(t6, Whirlpool)
    end

    return t6
end

local function heartbeat(p24, p25, p26) -- line: 291
    -- upvalues: Score (copy)
    local State = p24.State

    if State.NextBeat <= p25 then
        State.NextBeat = p25 + p26
        State.LubAt = p25
        Score.Play(p24.Score, "Thump", 0.3, 0.55)
        Score.Play(p24.Score, "Blub", 0.22, p24.Score.Random:NextNumber(0.95, 1.2))
        p24.Trove:Add(task.delay(0.16, function() -- line: 298
            -- upvalues: p24 (copy), Score (copy)
            Score.Play(p24.Score, "Thump", 0.17, 0.64)
        end))
    end

    return (math.exp(-(p25 - State.LubAt) * 9))
end

local function caveTargets(p27) -- line: 305
    -- upvalues: Stage (copy)
    local SurfacePosition = p27.Context.Surface.Position
    local v31 = Stage.CaveFlange()
    local v32, v33

    if v31 ~= nil then
        local v34

        v32, v34 = Stage.Axis(v31)

        if v32.Y > 0 then
            v32 = -v32
        end

        v33 = v31.Position + v32 * (v34 / 2)
    else
        v33 = SurfacePosition + Vector3.new(0, 30, 0)
        v32 = Vector3.new(-0, -1, -0, -0)
    end

    return v33, SurfacePosition, v32
end

local function ballistic(p28, p29, p30, p31) -- line: 322
    local v37 = Vector3.new(p29.X - p28.X, 0, p29.Z - p28.Z)
    local v38 = (p29.Y - p28.Y + p30 * 70 * p30) / p30
    local v39 = math.clamp(p31, 0, p30)

    return p28 + v37 * (v39 / p30) + Vector3.new(0, v38 * v39 - v39 * 70 * v39, 0)
end

local function funnel(p32, p33, p34) -- line: 333
    -- upvalues: Double (copy), Hands (copy), Kit (copy), Overlay (copy), Score (copy), Splash (copy), Looks (copy), stepRings (copy), limb (copy), gripFrame (copy)
    local State, Double2 = p32.State, p32.Double
    local Eye = State.Eye
    local v42 = Kit.Span(p33, 0.2, 1.7)
    local v43 = Kit.Ease(v42, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v44 = State.Angle0 + 15.707963267948966 * v43
    local v45 = math.lerp(State.Radius0, 4, Kit.Ease(v42, Enum.EasingStyle.Sine, Enum.EasingDirection.In))
    local v46 = Kit.Span(p33, 1.7, 1.82)
    local v47 = Kit.Ease(Kit.Span(p33, 1.9, 2.06), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v48 = State.Feet0 - 5 * Kit.Smooth(v42) - 8 * v47
    local v51 = Eye + Vector3.new(math.cos(v44) * v45, 0, -math.sin(v44) * v45)
    local v52 = Vector3.new(v51.X, v48, v51.Z)
    local v53 = Kit.FlatUnit(Eye - v52, (Vector3.new(0, 0, 1)))
    local v56 = Vector3.new(-math.sin(v44), 0, -math.cos(v44))
    local v58 = math.rad((math.lerp(20, 70, v42))) * (1 - v46 * 0.85)

    if p33 < 0.2 then
        v58 = p33 * 0.3490658503988659 / 0.2
    end

    local Unit = (Vector3.new(0, 1, 0) * math.cos(v58) + v53 * math.sin(v58)).Unit
    local Unit2 = (v56 - Unit * v56:Dot(Unit)).Unit

    if v46 > 0 then
        Unit2 = Unit2:Lerp(v53, v46).Unit
    end

    if p33 < 0.2 then
        Unit2 = State.Look0:Lerp(Unit2, Kit.Smooth(p33 / 0.2)).Unit
    end

    local v59 = v52 + Unit * (if Double2 then Double2.Stance else 3)

    if Double2 ~= nil then
        local v61 = math.clamp(p33 / 0.2, 0, 1)
        local v62 = Double.Blend(Double.Poses.Rest, Double.Poses.Trip, v61)

        if p33 >= 0.2 then
            v62 = Double.Blend(Double.Poses.Trip, Double.Poses.Surf, (math.clamp((p33 - 0.2) / 0.3, 0, 1)))
        end

        if p33 >= 1.2999999999999998 then
            v62 = Double.Blend(Double.Poses.Surf, Double.Poses.Flail, Kit.Span(p33, 1.2999999999999998, 1.7))
        end

        local t7

        if p33 >= 1.2999999999999998 and p33 < 1.7 then
            local v65 = math.sin(p33 * 38) * 22

            t7 = {
                LShoulder = Vector3.new(v65, 0, 0)
            }
            t7.RShoulder = Vector3.new(-v65, 0, 0)
        end

        if v46 > 0 then
            v62 = Double.Blend(Double.Poses.Flail, Double.Poses.Teeter, v46)

            local v68 = math.sin(p33 * 40) * 40

            t7 = {
                LShoulder = Vector3.new(v68, 0, 0)
            }
            t7.RShoulder = Vector3.new(-v68, 0, 0)

            local v71 = math.sin(p33 * 60) * 0.10471975511965978 * (1 - v46)

            Unit2 = (CFrame.fromAxisAngle(Unit, v71) * Unit2).Unit
        end

        if p33 >= 1.82 then
            t7 = nil
            v62 = Double.Blend(Double.Poses.Teeter, Double.Poses.Grabbed, (math.clamp((p33 - 1.82) / 0.1, 0, 1)))
        end

        Double.Pose(Double2, v62, t7)
        Double.Place(Double2, CFrame.lookAt(v59, v59 + Unit2, Unit))
    end

    State.DoublePos = v59

    local v74 = math.floor((v44 - State.Angle0) / 6.283185307179586)

    if State.Laps < v74 and p33 < 1.7 then
        State.Laps = v74
        Score.Play(p32.Score, "Swoosh", 0.55, (math.lerp(0.8, 1.6, v42)))
        Splash.Small(p32.Splash, v52)
    end

    stepRings(p32, p34, math.max(Kit.Smooth(v42) * (1 - 0.2 * v46), 0), Kit.Smooth(v42))
    Score.Level(p32.Score, "Pour", 0.5 * v42, 0.6 + 0.2 * v42)
    State.EyeLight.Brightness = 4 * Kit.Smooth(v42) + 6 * Kit.Span(p33, 1.82, 2.06)
    State.EyeLight.Range = 18 + 22 * Kit.Span(p33, 1.82, 2.06)

    if p33 < 1.7 then
        local Clear, MoonTeal = Looks.Clear, Looks.MoonTeal
        local v77 = Kit.Smooth(p33 / 0.5)

        Kit.Mix(p32.Grade.Look, Clear, MoonTeal, v77)
    elseif p33 >= 1.98 then
        local MoonTeal, Under = Looks.MoonTeal, Looks.Under
        local v78 = Kit.Span(p33, 1.98, 2.06)

        Kit.Mix(p32.Grade.Look, MoonTeal, Under, v78)
        Overlay.Vignette(p32.Overlay, 0.6 * Kit.Span(p33, 1.98, 2.06))

        if not State.Dunked then
            State.Dunked = true
            Splash.Small(p32.Splash, v59)
        end
    end

    local Crew = State.Crew
    local v79, v80, v81, v82, v83

    if p33 >= 1.82 and Crew ~= nil then
        v79 = Kit.Ease((p33 - 1.82) / 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        v80 = limb(p32, { "LeftFoot", "Left Leg" })
        v81 = limb(p32, { "RightFoot", "Right Leg" })
        v82 = limb(p32, { "UpperTorso", "Torso" })
        v83 = Double2 and Double2.Root.Position or v59

        local Position = v80 and v80.Position or v83
        local Position2 = v81 and v81.Position or v83
        local v84, v85

        if v82 then
            v84 = v82.Position + v82.CFrame.LookVector * -0.9 + v82.CFrame.RightVector * -0.6 or v83
            v85 = v82.Position + v82.CFrame.LookVector * -0.9 + v82.CFrame.RightVector * 0.6 or v83
        else
            v85 = v83
            v84 = v83
        end

        local t8 = {
            Position,
            Position2,
            v84,
            v85
        }

        for v86, v87 in Crew.Hands do
            local v88 = t8[v86]
            local v89 = (v86 - 1) * 3.141592653589793 / 2 + 0.6
            local v92 = Eye + Vector3.new(math.cos(v89) * 3, -9, math.sin(v89) * 3)
            local v93 = v92:Lerp(v88, v79)

            if not v87.Visible then
                Hands.Visible(v87, true)
                Hands.Puff(v87, 6)
            end

            if p33 >= 1.9000000000000001 and v87.Shown ~= "Grab" then
                Hands.Show(v87, "Grab")
            end

            Hands.Place(v87, gripFrame(v93, v92, v83))
        end

        Crew.LightPart.CFrame = CFrame.new(v83)
        Crew.Light.Brightness = 3

        if not State.Grabbed and p33 >= 1.9000000000000001 then
            State.Grabbed = true
            Score.Play(p32.Score, "Pad", 0.55)
            Score.Play(p32.Score, "Giggle", 0.35, 0.9)

            if Double2 then
                Double2.Glow.FillTransparency = 0.7
                Double2.Glow.OutlineTransparency = 0.3
            end

            if not p32.Calm and p32.OwnsCamera then
                State.ShakeUntil = p33 + 0.15
            end
        end
    end

    if p32.OwnsCamera then
        local Camera = p32.Camera
        local v94 = v59:Lerp(Eye, 0.3)
        local v98 = Vector3.new(v94.X, math.max(v94.Y + 1, State.Feet0 + 2.5), v94.Z)
        local StartCamera, Back = State.StartCamera, State.Back
        local v99 = (v44 - State.Angle0) * 0.3
        local v100 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v99) * Back
        local v101 = math.lerp(22, 16, v42)
        local v102 = math.lerp(0.8726646259971648, 1.2217304763960306, Kit.Smooth(v46))
        local t9 = {
            p32.Character,
            p32.Folder
        }
        local Whirlpool = p32.Context.Whirlpool

        if Whirlpool then
            table.insert(t9, Whirlpool)
        end

        local v103 = Kit.Orbit(v98, v100, v102, v101, t9)
        local v106 = (State.CraneAt or v103):Lerp(v103, 1 - math.exp(p34 * -9))

        State.CraneAt = v106

        local v107 = Kit.Smooth(p33 / 0.55)
        local v108 = StartCamera.Position:Lerp(v106, v107)
        local v109 = (StartCamera.Position + StartCamera.LookVector * 12):Lerp(v98, Kit.Smooth(p33 / 0.35))

        if p33 >= 1.7 then
            v109 = v109:Lerp(Eye, Kit.Smooth(v46) * 0.5)
        end

        if p33 >= 1.9 then
            v109 = v109:Lerp(v59, v47)
        end

        local v110 = Kit.Clamp(v98, v108, t9)
        local v111 = CFrame.lookAt(v110, v109)
        local ShakeUntil = State.ShakeUntil

        if ShakeUntil ~= nil and p33 < ShakeUntil then
            local v112 = 0.25 * (ShakeUntil - p33) / 0.15

            v111 += Vector3.new(p32.Score.Random:NextNumber(-v112, v112), p32.Score.Random:NextNumber(-v112, v112), p32.Score.Random:NextNumber(-v112, v112))
        end

        Camera.CFrame = v111

        local v118 = math.lerp(math.lerp(p32.FieldOfView, 84, Kit.Smooth(v42)), 76, (Kit.Smooth(v46)))

        Camera.FieldOfView = if p33 >= 1.9 then math.lerp(76, 56, v47) else v118

        local Depth = p32.Grade.Depth

        if p33 > 0.3 then
            Depth.Enabled = p33 < 1.7
        else
            Depth.Enabled = false
        end

        Depth.FocusDistance = (v110 - v59).Magnitude

        local v119 = Kit.Span(p33, 1.1, 1.7)
        local v120 = if p33 >= 1.7 then State.StreakClock else p33

        State.StreakClock = v120

        local v121 = Kit.Projected(Camera, Eye)
        local Streaks = Overlay.Streaks
        local Overlay2 = p32.Overlay

        if not (p33 < 1.82) then
            v119 = 0
        end

        Streaks(Overlay2, v121, v119, v120)
    end
end

local function dragDepth(p35) -- line: 533
    if p35 <= 0.8 then
        local v122 = p35 / 0.8

        return 80 - v122 * 100 * v122, v122 * 200 / 0.8
    end

    local v124 = math.exp(-(p35 - 0.8) * 6.944444444444445)

    return -20 - (1 - v124) * 36, v124 * 250
end

local function followY(p36, p37, p38, p39) -- line: 542
    local v125 = p36.CamY or p37
    local v128 = v125 + (p37 - v125) * (1 - math.exp(-p38 * p39))

    p36.CamY = v128

    return v128
end

local function facingYaw(p40) -- line: 549
    return (math.atan2(-math.cos(p40), -math.sin(p40)))
end

local function enterDepths(p41) -- line: 553
    -- upvalues: Depths (copy), Flash (copy), Hands (copy), Kit (copy), Overlay (copy), Score (copy), Stage (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), Looks (copy), dropRings (copy)
    local State = p41.State
    local Depths2 = State.Depths

    Stage.Phase(p41, "Plunge")
    dropRings(p41)

    for _, v131 in State.Trails or {} do
        v131.Enabled = false
        v131:Clear()
    end

    Overlay.Streaks(p41.Overlay, Vector2.new(0.5, 0.5), 0, 0)
    p41.Grade.Depth.Enabled = false
    Flash.Play({
        Attack = 0.02,
        Decay = 0.18,
        Opacity = 0.55,
        Tint = v2
    })
    Stage.Scriptable(p41)
    Stage.Arrive(p41)
    Score.Under(p41.Score, true, 0.05)
    Score.Stop(p41.Score, "Pour")
    Score.Play(p41.Score, "ScoopShort", 0.6, 0.55)
    Score.Loop(p41.Score, "Drone", 0.45)
    Score.Loop(p41.Score, "Bubbles", 0.22)
    State.NextBeat = 0.15
    State.LubAt = -10
    State.Chase = p41.Score.Random:NextNumber(0, 6.283185307179586)
    State.Roll = 0
    State.Giggled = false
    State.DragY = 80
    State.DragV = 0
    State.CamY = 86.5
    State.DeepLook = table.clone(Looks.Drowned)
    Depths.Follow(Depths2, 80)
    Depths.Tighten(Depths2, 1)
    Depths.Rush(Depths2, 0, Depths2.Origin * Vector3.new(0, 80, 0))
    Depths2.Breath:Emit(40)
    Depths2.Motes:Emit(40)
    Depths.Fog(Depths2, 1)
    Depths2.Model.Parent = p41.Folder

    local Double = p41.Double

    if Double then
        Double.Glow.FillTransparency = 1
        Double.Glow.OutlineTransparency = 1

        local v132 = p41.Trove:Add(Instance.new("PointLight"))

        v132.Name = Kit.Name
        v132.Color = v5
        v132.Range = 12
        v132.Brightness = 2.6
        v132.Shadows = false
        v132.Parent = Double.Root
        State.Rim = v132
    end

    local Crew = State.Crew

    if Crew == nil then
        return
    end

    Crew.Outline.OutlineColor = v4
    Crew.Outline.OutlineTransparency = 0.7
    Crew.Light.Brightness = 0.5

    for _, v133 in Crew.Hands do
        for _, v134 in v133.Pieces do
            if v134.Part.Material == Enum.Material.Neon then
                v134.Part.Color = v3
                v134.Part.Material = Enum.Material.SmoothPlastic
            end
        end
    end

    for v135, v136 in Crew.Hands do
        if v135 > 2 then
            Hands.Visible(v136, false)
        else
            Hands.Show(v136, "Wave")
            v136.Wisps.Rate = 8
        end
    end
end

local function placePlunge(p42, p43, p44, p45, p46) -- line: 625
    -- upvalues: Double (copy), Hands (copy), limb (copy), gripFrame (copy)
    local State = p42.State
    local Origin = State.Depths.Origin
    local v137 = p46 * 2.5
    local v141 = Origin * CFrame.new(math.sin(p43 * 2.1) * v137, p44, math.cos(p43 * 1.7) * v137)
    local Double2 = p42.Double
    local v145 = CFrame.Angles(math.sin(p43 * 5) * 0.17453292519943295 * p46, 0, math.sin(p43 * 3.7) * 0.17453292519943295 * 0.8 * p46)
    local v146 = v141 * CFrame.Angles(0, p45, 0) * CFrame.Angles(0.8726646259971648, 0, 0) * v145

    if Double2 then
        local v148 = math.sin(p43 * 15) * 34
        local v150 = math.sin(p43 * 11) * 30
        local v152 = math.sin(p43 * 8) * 22

        Double.Pose(Double2, Double.Poses.Grabbed, {
            LShoulder = Vector3.new(v150, 0, v152),
            RShoulder = Vector3.new(-v150, 0, -v152),
            LElbow = Vector3.new(math.max(v150, 0), 0, 0),
            RElbow = Vector3.new(math.max(-v150, 0), 0, 0),
            LHip = Vector3.new(v148, 0, 0),
            RHip = Vector3.new(-v148, 0, 0),
            LKnee = Vector3.new(-math.max(v148, 0), 0, 0),
            RKnee = Vector3.new(-math.max(-v148, 0), 0, 0)
        })
        Double.Place(Double2, v146)
    end

    local Crew = State.Crew

    if Crew ~= nil then
        local v162 = limb(p42, { "LeftFoot", "Left Leg" })
        local v163 = limb(p42, { "RightFoot", "Right Leg" })
        local v164 = limb(p42, { "LeftLowerLeg", "Left Leg" })
        local v165 = limb(p42, { "RightLowerLeg", "Right Leg" })
        local Position = v141.Position
        local v166 = Position - Vector3.new(0, 6, 0)
        local v167 = v162 and v162.Position or Position
        local Position2 = v163 and v163.Position or Position
        local Position3 = v164 and v164.Position or Position
        local Position4 = if v165 then v165.Position else nil

        if v165 and Position4 then
            Position = Position4
        end

        local t11 = {
            v167,
            Position2,
            Position3,
            Position
        }

        for v168, v169 in Crew.Hands do
            if v169.Shown == "Wave" and v169.Visible then
                local v170 = p45 + (if v168 == 1 then 1 else -1) * 1.1 + 3.141592653589793
                local v173 = v166 + Vector3.new(math.cos(v170) * 4.5, 0, math.sin(v170) * 4.5)

                Hands.Place(v169, gripFrame(t11[v168], v173, p42.Camera.CFrame.Position))
            end
        end

        Crew.LightPart.CFrame = v141
    end

    State.DoublePos = v141.Position
end

local function plunge(p47, p48, p49) -- line: 680
    -- upvalues: Depths (copy), Kit (copy), Overlay (copy), Score (copy), Stage (copy), Looks (copy), heartbeat (copy), placePlunge (copy)
    local State = p47.State
    local Depths2 = State.Depths
    local Origin = Depths2.Origin
    local v174 = Kit.Ease(p48 / 0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local v177 = math.lerp(0.6, 0.42, (math.clamp(p48 / 2, 0, 1)))
    local v178 = if p47.Calm then 0 else heartbeat(p47, p48, v177)
    local v179, v180

    if p48 <= 0.8 then
        local v181 = p48 / 0.8

        v179 = 80 - v181 * 100 * v181
        v180 = v181 * 200 / 0.8
    else
        local v183 = math.exp(-(p48 - 0.8) * 6.944444444444445)

        v179 = -20 - (1 - v183) * 36
        v180 = v183 * 250
    end

    local v184 = v179 - v178 * 1.6
    local v186 = math.clamp((80 - v184) / 136, 0, 1)
    local v187 = Kit.Smooth(p48 / 0.6)

    Depths.Follow(Depths2, v184)
    Depths.Step(Depths2, Stage.Elapsed(p47), p49, (math.lerp(1, 2.2, v187)))
    Depths.Light(Depths2, (math.lerp(0.5, 1.6, v186)))
    Depths.Tighten(Depths2, (math.lerp(1, 0.55, Kit.Smooth(Kit.Span(p48, 0.7, 1.2)))))
    Depths.Rush(Depths2, v174, Origin * Vector3.new(0, v184, 0))
    State.DragY = v184
    State.DragV = v180
    State.Chase += p49 * 0.9599310885968813 * (0.5 + 0.5 * v174)

    local Chase = State.Chase

    placePlunge(p47, p48, v184, math.atan2(-math.cos(Chase), -math.sin(Chase)), 1)

    local DeepLook = State.DeepLook

    Kit.Mix(DeepLook, Looks.Drowned, Looks.Deep, v186)

    local Under = Looks.Under

    Kit.Mix(p47.Grade.Look, Under, DeepLook, v174)
    Kit.Apply(p47.Grade, v178)
    p47.Grade.Blur.Size += v178 * 4 + 2 * v187
    State.Pulse = v178
    Overlay.Caustic(p47.Overlay, v174 * (1 - v186 * 0.6), p48)
    Overlay.Vignette(p47.Overlay, math.max(0.5 * v174, 0.6 * (1 - v174)) + v186 * 0.25)

    if not State.Giggled and p48 > 0.55 then
        State.Giggled = true
        Score.Play(p47.Score, "Giggle", 0.4, 1.05)
    end

    if p47.OwnsCamera then
        local v192 = Kit.Smooth(p48 / 1.2)
        local v193 = math.lerp(11, 9.5, v192)
        local v194 = math.lerp(6.5, 5, v192) + v178 * 2.2

        State.ChaseRadius = v193
        State.ChaseHeight = v194

        local v195 = v184 + v194
        local v196 = State.CamY or v195
        local v199 = v196 + (v195 - v196) * (1 - math.exp(p49 * -14))

        State.CamY = v199

        local v201 = math.min(v199, v184 + v194 + 2.5)

        State.CamY = v201

        local v204 = Origin * Vector3.new(math.cos(Chase) * v193, v201, math.sin(Chase) * v193)
        local v206 = Origin * Vector3.new(0, v184 - 7, 0)
        local v207 = 0.22 * v187
        local v211 = Vector3.new(math.noise(p48 * 7, 0.3) * v207, math.noise(p48 * 7, 1.7) * v207, math.noise(p48 * 7, 3.1) * v207)

        State.Roll = math.clamp(State.Roll + p49 * 0.3490658503988659 * v174, -0.5235987755982988, 0.5235987755982988)

        local v214 = math.sin(p48 * 0.9) * 0.08726646259971647 + State.Roll * 0.6

        p47.Camera.CFrame = CFrame.lookAt(v204 + v211, v206) * CFrame.Angles(0, 0, v214)

        local v217 = math.lerp(56, math.lerp(70, 84, Kit.Smooth(p48 / 0.6)), v174) + v178 * 3

        p47.Camera.FieldOfView = v217
        State.PlungeFov = v217
    end
end

local function gulp(p50, p51, p52) -- line: 744
    -- upvalues: Depths (copy), Hands (copy), Kit (copy), Overlay (copy), Score (copy), Stage (copy), Looks (copy), placePlunge (copy)
    local State = p50.State
    local Depths2 = State.Depths
    local Origin = Depths2.Origin
    local v219 = math.clamp(p51 / 0.6, 0, 1)
    local GulpFrom, GulpSpeed, GulpAccel = State.GulpFrom, State.GulpSpeed, State.GulpAccel
    local v220 = math.min(p51, 0.6)
    local v221 = GulpFrom - GulpSpeed * v220 - GulpAccel * v220 * v220

    Depths.Follow(Depths2, v221)
    Depths.Step(Depths2, Stage.Elapsed(p50), p52, 2.6)
    Depths.Light(Depths2, (math.lerp(1.6, 0.8, v219)))
    Depths.Tighten(Depths2, 0.45)
    Depths.Rush(Depths2, 1, Origin * Vector3.new(0, v221, 0))
    State.Chase += p52 * 1.5358897417550101

    local Chase = State.Chase

    placePlunge(p50, p51, v221, math.atan2(-math.cos(Chase), -math.sin(Chase)), 1 - v219)

    local Crew = State.Crew

    if Crew ~= nil and not State.LetGo and State.EnteredAt ~= nil then
        State.LetGo = true
        Crew.Light.Brightness = 0

        for _, v224 in Crew.Hands do
            v224.Wisps.Rate = 0

            if v224.Visible then
                Hands.Puff(v224, 4)
            end

            Hands.Visible(v224, false)
        end
    end

    local DeepLook = State.DeepLook

    if v219 < 0.35 then
        local Throat = Looks.Throat
        local v225 = v219 / 0.35

        Kit.Mix(p50.Grade.Look, DeepLook, Throat, v225)
    else
        local Throat, Gullet = Looks.Throat, Looks.Gullet
        local v226 = Kit.Smooth((v219 - 0.35) / 0.65)

        Kit.Mix(p50.Grade.Look, Throat, Gullet, v226)
    end

    Depths.Exit(Depths2, Kit.Smooth(Kit.Span(v219, 0.25, 1)))

    local Rim = State.Rim

    if Rim ~= nil then
        Rim.Brightness = (v219 * 0.6 + 1) * 2.6
    end

    Kit.Apply(p50.Grade, 0)

    local EnteredAt = State.EnteredAt

    if EnteredAt ~= nil then
        local Blur = p50.Grade.Blur

        Blur.Size = Blur.Size + math.exp(-(p51 - EnteredAt) * 14) * 12
    end

    Overlay.Caustic(p50.Overlay, (1 - v219) * 0.4, p51)
    Overlay.Vignette(p50.Overlay, v219 * 0.2 + 0.75)

    if not State.Hushed and p51 >= 0.44999999999999996 then
        State.Hushed = true
        Score.StopAll(p50.Score)
    end

    local v228 = Kit.Smooth(v219 / 0.55)
    local v230 = math.lerp(State.ChaseRadius or 9.5, 2.5, v228)
    local v232 = v221 + math.lerp(State.ChaseHeight or 5, 4.4, v228)
    local v233 = State.CamY or v232
    local v236 = v233 + (v232 - v233) * (1 - math.exp(p52 * -22))

    State.CamY = v236

    if EnteredAt == nil and v236 < Depths2.Floor + 1 then
        State.EnteredAt = p51
        Score.Play(p50.Score, "Clank", 0.6)

        if not p50.Calm and p50.OwnsCamera then
            State.GulpShake = p51 + 0.15
        end

        EnteredAt = p51
    end

    if p50.OwnsCamera then
        local v239 = Origin * Vector3.new(math.cos(Chase) * v230, v236, math.sin(Chase) * v230)
        local v241 = CFrame.lookAt(v239, Origin * Vector3.new(0, v221 - 20, 0))
        local GulpShake = State.GulpShake

        if GulpShake ~= nil and p51 < GulpShake then
            local v242 = 0.35 * (GulpShake - p51) / 0.15

            v241 += Vector3.new(p50.Score.Random:NextNumber(-v242, v242), p50.Score.Random:NextNumber(-v242, v242), p50.Score.Random:NextNumber(-v242, v242))
        end

        p50.Camera.CFrame = v241 * CFrame.Angles(0, 0, State.Roll * 0.6)

        local v246 = if EnteredAt == nil then 0 else math.exp(-(p51 - EnteredAt) * 10) * 6

        p50.Camera.FieldOfView = math.lerp(State.PlungeFov or 84, 100, Kit.Ease(v219, Enum.EasingStyle.Quad, Enum.EasingDirection.In)) + v246
    end
end

local function startGulp(p53) -- line: 831
    local State = p53.State
    local Depths, DragY, DragV = State.Depths, State.DragY, State.DragV
    local v250 = math.max(DragY - (Depths.Floor - 78), 10)

    State.GulpFrom = DragY
    State.GulpSpeed = DragV
    State.GulpAccel = math.max((v250 - DragV * 0.6) / 0.36, DragV * -0.6 / 1.2)
    State.EnteredAt = nil
end

local function enterCave(p54) -- line: 846
    -- upvalues: Kit (copy), Overlay (copy), Score (copy), Splash (copy), Stage (copy)
    local State = p54.State

    Stage.Phase(p54, "Cough")

    for _, v253 in State.Trails or {} do
        v253:Clear()
        v253.Enabled = true
    end

    State.Depths.Model.Parent = nil

    local Crew = State.Crew

    if Crew ~= nil then
        Crew.Model.Parent = nil
    end

    local SurfacePosition = p54.Context.Surface.Position
    local v254 = Stage.CaveFlange()
    local v255, v256

    if v254 ~= nil then
        local v257

        v255, v257 = Stage.Axis(v254)

        if v255.Y > 0 then
            v255 = -v255
        end

        v256 = v254.Position + v255 * (v257 / 2)
    else
        v256 = SurfacePosition + Vector3.new(0, 30, 0)
        v255 = Vector3.new(-0, -1, -0, -0)
    end

    State.Mouth = v256
    State.SplashAt = SurfacePosition
    State.Aim = v255

    local RootPosition = p54.Root.Position
    local v258 = (v256 + SurfacePosition + RootPosition) / 3
    local v259 = Kit.FlatUnit(RootPosition - v256, (Vector3.new(1, 0, 0)))
    local v261 = Vector3.new(v259.Z, 0, -v259.X)
    local t12 = {
        p54.Character,
        p54.Folder
    }
    local v262 = v258 + v261 * 36 + Vector3.new(0, -4, 0)
    local v263 = v258 - v261 * 36 + Vector3.new(0, -4, 0)

    if not (Kit.Clearance(v258, v262, t12) >= Kit.Clearance(v258, v263, t12)) then
        v262 = v263
    end

    State.BirthCamera = Kit.Clamp(v258, v262, t12)
    State.BirthAim = v256 * 0.3 + SurfacePosition * 0.4 + RootPosition * 0.3 + Vector3.new(0, 3, 0)
    Overlay.Caustic(p54.Overlay, 0, 0)
    Overlay.Vignette(p54.Overlay, 0)
    Overlay.Streaks(p54.Overlay, Vector2.new(0.5, 0.5), 0, 0)
    Score.Under(p54.Score, false, 0.05)
    Score.Echo(p54.Score, true)
    Score.Play(p54.Score, "Whoosh", 0.6, 1.1)
    Score.Play(p54.Score, "Pop", 0.75, 0.85)
    Splash.Crown(p54.Splash, CFrame.lookAt(v256, v256 + v255))

    local Double = p54.Double

    if Double then
        Double.Glow.FillTransparency = 0.88
        Double.Glow.OutlineTransparency = 0.2
    end

    local Rim = State.Rim

    if Rim ~= nil then
        Rim.Enabled = false
    end
end

local function cough(p55, p56, _) -- line: 896
    -- upvalues: Double (copy), Kit (copy), Splash (copy), Looks (copy)
    local State = p55.State
    local Mouth, SplashAt = State.Mouth, State.SplashAt
    local Double2 = p55.Double
    local v266 = Vector3.new(SplashAt.X - Mouth.X, 0, SplashAt.Z - Mouth.Z)
    local v267 = (SplashAt.Y - Mouth.Y + 21.175) / 0.55
    local v268 = math.clamp(p56, 0, 0.55)
    local v271 = Mouth + v266 * (v268 / 0.55) + Vector3.new(0, v267 * v268 - v268 * 70 * v268, 0)

    if Double2 then
        local v272 = Kit.Smooth(p56 / 0.55)

        Double2.Glow.FillTransparency = math.lerp(0.88, 1, v272)
        Double2.Glow.OutlineTransparency = math.lerp(0.2, 1, v272)
        Double.Pose(Double2, Double.Poses.Cannonball)

        local v273 = CFrame.Angles(-p56 * 9.42477796076938, 0, 0)
        local v274 = Kit.FlatUnit(SplashAt - Mouth, (Vector3.new(0, 0, 1)))

        Double.Place(Double2, CFrame.lookAt(v271, v271 + v274) * v273)
    end

    local v275 = Kit.Ease(p56 / 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    if p56 > 0.35 then
        v275 = math.max(1 - (p56 - 0.35) / 0.2, 0)
    end

    Splash.Jet(p55.Splash, Mouth, Mouth + (SplashAt - Mouth).Unit * 14, v275)

    if p56 < 0.3 then
        local GreenGlow, Afterglow = Looks.GreenGlow, Looks.Afterglow
        local v277 = p56 / 0.3

        Kit.Mix(p55.Grade.Look, GreenGlow, Afterglow, v277)
    else
        local Afterglow, Clear = Looks.Afterglow, Looks.Clear
        local v278 = Kit.Smooth((p56 - 0.3) / 1.2)

        Kit.Mix(p55.Grade.Look, Afterglow, Clear, v278)
    end

    Kit.Apply(p55.Grade, 0)

    if p55.OwnsCamera then
        local BirthCamera, BirthAim = State.BirthCamera, State.BirthAim
        local v279 = Kit.Smooth(p56 / 0.55)
        local v280 = BirthAim:Lerp(v271, 0.2 * v279)
        local v281 = BirthCamera:Lerp(BirthAim, 0.06 * v279)
        local v282 = 0.10471975511965978 * (1 - Kit.Smooth(p56 / 0.3))

        p55.Camera.CFrame = CFrame.lookAt(v281, v280) * CFrame.Angles(0, 0, v282)
        p55.Camera.FieldOfView = 74
        State.Push = v281
        State.AimAt = v280
    end
end

local function impact(p58) -- line: 937
    -- upvalues: Double (copy), Overlay (copy), Score (copy), Splash (copy), Stage (copy)
    local State = p58.State

    Stage.Phase(p58, "Splash")

    local SplashAt = State.SplashAt

    Splash.Jet(p58.Splash, SplashAt, SplashAt, 0)
    Splash.Big(p58.Splash, SplashAt)
    Score.Play(p58.Score, "Crash", 0.7)
    Score.Play(p58.Score, "Boom", 0.4)
    Score.Play(p58.Score, "ScoopLong", 0.5, 0.9)
    Overlay.Drops(p58.Overlay, p58.Scenery, p58.Low and 3 or 5)

    local Double2 = p58.Double

    if Double2 then
        Double.Visible(Double2, false)
    end
end

local function toss(p59, p60, _) -- line: 953
    -- upvalues: Double (copy), Kit (copy), Splash (copy), Stage (copy), Looks (copy)
    local State = p59.State
    local SplashAt = State.SplashAt
    local Double2 = p59.Double
    local _CFrame = p59.Root.CFrame
    local v283 = if Double2 then Double2.Stance else 3
    local CFramePosition = _CFrame.Position
    local v284 = SplashAt - Vector3.new(0, 1, 0)
    local v285 = p60 - 0.12
    local v287 = math.clamp(v285 / 0.55, 0, 1)

    if Double2 and v285 >= 0 then
        if not State.Surfaced then
            State.Surfaced = true
            Double.Visible(Double2, true)
            Splash.Small(p59.Splash, SplashAt)
        end

        local v289 = math.max(CFramePosition.Y - v284.Y, 0) + 8
        local v292 = v284:Lerp(CFramePosition, v287) + Vector3.new(0, v289 * 4 * v287 * (1 - v287), 0)
        local v293 = Kit.FlatUnit(_CFrame.LookVector, (Vector3.new(0, 0, 1)))
        local v294 = CFrame.Angles(6.283185307179586 * Kit.Ease(v287, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 0, 0)
        local v295 = Double.Blend(Double.Poses.Cannonball, Double.Poses.Squash, Kit.Span(v287, 0.6, 1))

        Double.Pose(Double2, v295)

        local v297 = Vector3.new(0, v283 * (1 - v287), 0)

        Double.Place(Double2, CFrame.lookAt(v292 + v297, v292 + v297 + v293) * v294)
    end

    local Afterglow, Clear = Looks.Afterglow, Looks.Clear
    local v298 = Kit.Smooth((Stage.Elapsed(p59) - State.CaveAt - 0.3) / 1.2)

    Kit.Mix(p59.Grade.Look, Afterglow, Clear, v298)
    Kit.Apply(p59.Grade, 0)

    if p59.OwnsCamera then
        local BirthCamera = State.BirthCamera

        if Double2 and v285 >= 0 then
            SplashAt = Double2.Root.Position
        end

        local v299 = State.Push or BirthCamera
        local v300 = State.AimAt or SplashAt
        local v302 = Kit.Smooth((math.clamp(p60 / 0.67, 0, 1)))
        local v303 = v300:Lerp(SplashAt:Lerp(CFramePosition, 0.5), 0.45 * v302)
        local v304 = Kit.Clamp(CFramePosition, v299:Lerp(CFramePosition, 0.4 * v302), {
            p59.Character,
            p59.Folder
        })

        p59.Camera.CFrame = CFrame.lookAt(v304, v303)
    end
end

local function land(p62) -- line: 1003
    -- upvalues: Overlay (copy), Score (copy), Splash (copy), Stage (copy), v9 (ref)
    local State = p62.State

    Stage.Phase(p62, "Settle")
    Stage.Swap(p62)

    local v305 = p62.Root.Position - Vector3.new(0, 2.5, 0)

    Splash.Land(p62.Splash, v305)
    Score.Play(p62.Score, "ScoopShort", 0.45, 1.2)
    Score.Play(p62.Score, "Gasp", 0.6)
    p62.Trove:Add(task.delay(0.6, function() -- line: 1011
        -- upvalues: p62 (copy), Score (copy)
        Score.Play(p62.Score, "Drip", 0.5)
    end))

    local Head = p62.Character:FindFirstChild("Head")

    if Head ~= nil and Head:IsA("BasePart") then
        Splash.Drips(p62.ScoreTrove, Head, 2.5)
    end

    State.SettleFrom = p62.Camera.CFrame
    State.SettleFov = p62.Camera.FieldOfView
    State.SettleTo = Stage.Landing(p62, p62.Zoom)

    if v9 then
        return
    end

    v9 = true
    p62.Trove:Add(task.delay(0.2, function() -- line: 1023
        -- upvalues: p62 (copy), Overlay (copy), Score (copy)
        if not p62.Done then
            Overlay.Card(p62.Overlay, p62.ScoreTrove, "SECRET FISHING AREA", 1)
            Score.Play(p62.Score, "Shimmer", 0.5)
        end
    end))
end

local function settle(p63, p64) -- line: 1033
    -- upvalues: Kit (copy), Stage (copy), Looks (copy)
    local State = p63.State
    local v307 = math.clamp(p64 / 0.9, 0, 1)
    local Afterglow, Clear = Looks.Afterglow, Looks.Clear
    local v308 = Kit.Smooth((Stage.Elapsed(p63) - State.CaveAt - 0.3) / 1.2)

    Kit.Mix(p63.Grade.Look, Afterglow, Clear, v308)
    Kit.Apply(p63.Grade, 0)
    State.SettleTo = Stage.Landing(p63, p63.Zoom)

    if v307 >= 1 then
        Stage.HandBack(p63, State.SettleTo)
    elseif p63.OwnsCamera then
        local SettleFrom, SettleTo = State.SettleFrom, State.SettleTo
        local v309 = Kit.Ease(v307, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        p63.Camera.CFrame = Stage.SwingFrame(p63, SettleFrom, SettleTo, (math.clamp(v309, 0, 1.05)))
        p63.Camera.FieldOfView = math.lerp(State.SettleFov or 70, p63.FieldOfView, Kit.Smooth(v307))
    end
end

local function calm(p65, p66, p67) -- line: 1058
    -- upvalues: Double (copy), Hands (copy), Kit (copy), Overlay (copy), Score (copy), Splash (copy), Stage (copy), Looks (copy), v9 (ref), stepRings (copy), dropRings (copy), gripFrame (copy)
    local State = p65.State
    local Eye = State.Eye
    local Double2, Camera = p65.Double, p65.Camera

    if p65.Phase == "Calm" then
        local v311 = Kit.Smooth(p66 / 1.1)
        local v312 = p66 * 1.3962634015954636

        if Double2 then
            local DoubleStart = State.DoubleStart
            local v314 = CFrame.new(DoubleStart.Position - Vector3.new(0, 5 * v311, 0)) * DoubleStart.Rotation * CFrame.Angles(0, v312, 0)

            Double.Pose(Double2, Double.Blend(Double.Poses.Rest, Double.Poses.Grabbed, v311))
            Double.Place(Double2, v314)
        end

        local Crew = State.Crew
        local v315, v316

        if Crew ~= nil and p66 > 0.3 then
            v315 = Kit.Smooth((p66 - 0.3) / 0.6)
            v316 = Double2 and Double2.Root.Position or Eye

            for v317, v318 in Crew.Hands do
                if not v318.Visible then
                    Hands.Visible(v318, true)
                    Hands.Show(v318, "Reach")
                end

                local v319 = (v317 - 1) * 3.141592653589793 / 2 + 0.6
                local v322 = v316 + Vector3.new(math.cos(v319) * 3, -8, math.sin(v319) * 3)
                local v325 = v316 + Vector3.new(math.cos(v319) * 1.2, -1.5, math.sin(v319) * 1.2)

                Hands.Place(v318, gripFrame(v322:Lerp(v325, v315), v322, v316))
            end
        end

        stepRings(p65, p67, 0.15, 0)
        Overlay.Waterline(p65.Overlay, Kit.Smooth((p66 - 0.4) / 0.8))

        local v326 = Kit.Projected(Camera, Eye)

        Overlay.Iris(p65.Overlay, v326, 1 - Kit.Smooth((p66 - 1.2) / 0.6))

        local Clear, Haze = Looks.Clear, Looks.Haze
        local v327 = Kit.Smooth(p66 / 1)

        Kit.Mix(p65.Grade.Look, Clear, Haze, v327)
        Kit.Apply(p65.Grade, 0)

        if p65.OwnsCamera then
            Camera.FieldOfView = p65.FieldOfView - 6 * Kit.Smooth(p66)
        end

        if p66 >= 1.8 then
            Stage.Phase(p65, "CalmHold")
            dropRings(p65)
            Stage.Scriptable(p65)
            Stage.Arrive(p65)

            if Double2 then
                Double.Visible(Double2, false)
            end

            if Crew ~= nil then
                Crew.Model.Parent = nil
            end

            Score.Loop(p65.Score, "Drone", 0.25)
        end
    elseif p65.Phase == "CalmHold" then
        Overlay.Iris(p65.Overlay, Vector2.new(0.5, 0.5), 0)

        if p65.ArriveState == "Failed" then
            Stage.Phase(p65, "CalmBack")
            State.Failed = true
        else
            if not State.Dripped and p66 > 0.4 then
                State.Dripped = true
                Score.Play(p65.Score, "Drip", 0.5)
            end

            if p66 >= 0.6 and Stage.Settled(p65) or Stage.Elapsed(p65) > 8 then
                Stage.Phase(p65, "CalmBack")
                Stage.Swap(p65)
                Score.Stop(p65.Score, "Drone")

                if p65.ArriveState == "Arrived" then
                    Overlay.Drops(p65.Overlay, p65.Scenery, 3)

                    local Head = p65.Character:FindFirstChild("Head")

                    if Head ~= nil and Head:IsA("BasePart") then
                        Splash.Drips(p65.ScoreTrove, Head, 2.5)
                    end

                    Score.Play(p65.Score, "Gasp", 0.5)

                    if not v9 then
                        v9 = true
                        Overlay.Card(p65.Overlay, p65.ScoreTrove, "SECRET FISHING AREA", 1)
                        Score.Play(p65.Score, "Shimmer", 0.5)
                    end
                end
            end
        end
    else
        local v329 = math.clamp(p66 / 1, 0, 1)

        if p65.OwnsCamera then
            local v330 = Stage.Landing(p65, p65.Zoom)

            Camera.CFrame = v330
            Camera.FieldOfView = p65.FieldOfView
            State.Landing = v330
        end

        local v331 = Kit.Projected(Camera, p65.Root.Position)

        Overlay.Iris(p65.Overlay, v331, Kit.Smooth(v329))
        Overlay.Waterline(p65.Overlay, 1 - Kit.Smooth(v329 * 1.4))

        local Haze, Clear = Looks.Haze, Looks.Clear
        local v332 = Kit.Smooth(v329)

        Kit.Mix(p65.Grade.Look, Haze, Clear, v332)
        Kit.Apply(p65.Grade, 0)

        if v329 >= 1 then
            if State.Failed then
                Stage.Finish(p65, false)
            else
                Stage.HandBack(p65, State.Landing or Stage.Landing(p65, p65.Zoom))
            end
        end
    end
end

local function step(p68, p69) -- line: 1166
    -- upvalues: Double (copy), Kit (copy), Overlay (copy), Score (copy), SewerCave (copy), Stage (copy), funnel (copy), enterDepths (copy), plunge (copy), gulp (copy), enterCave (copy), cough (copy), impact (copy), toss (copy), land (copy), settle (copy), calm (copy)
    local State = p68.State
    local v333 = Stage.Since(p68)

    if p68.Calm then
        calm(p68, v333, p69)
    elseif p68.Phase == "Funnel" then
        if p68.ArriveState == "Idle" then
            funnel(p68, v333, p69)
            Kit.Apply(p68.Grade, 0)

            if v333 >= 2.06 then
                enterDepths(p68)
                plunge(p68, 0, p69)
            end
        end
    elseif p68.Phase == "Plunge" then
        if p68.ArriveState == "Failed" then
            Stage.Bail(p68)
        else
            plunge(p68, v333, p69)

            local v334

            if v333 >= 0.8 then
                v334 = Stage.Settled(p68)

                if v334 then
                    v334 = SewerCave.Marker(SewerCave.Markers.Spawn) ~= nil and Stage.CaveFlange() ~= nil
                end
            else
                v334 = false
            end

            if v334 then
                local State = p68.State
                local Depths, DragY, DragV = State.Depths, State.DragY, State.DragV
                local v336 = math.max(DragY - (Depths.Floor - 78), 10)

                State.GulpFrom = DragY
                State.GulpSpeed = DragV
                State.GulpAccel = math.max((v336 - DragV * 0.6) / 0.36, DragV * -0.6 / 1.2)
                State.EnteredAt = nil
                Stage.Phase(p68, "Gulp")
                Score.Loop(p68.Score, "Hole", 0.5, 0.7)
            elseif Stage.Elapsed(p68) > 8.06 then
                State.GaveUp = true
                Stage.Phase(p68, "CalmHold")
                p68.Calm = true
                Overlay.Iris(p68.Overlay, Vector2.new(0.5, 0.5), 0)
                Overlay.Streaks(p68.Overlay, Vector2.new(0.5, 0.5), 0, 0)
                Score.StopAll(p68.Score)
                Score.Under(p68.Score, false, 0.2)
                State.Depths.Model.Parent = nil

                local Crew = State.Crew

                if Crew ~= nil then
                    Crew.Model.Parent = nil
                end

                if p68.Double then
                    Double.Visible(p68.Double, false)
                end
            end
        end
    elseif p68.Phase == "Gulp" then
        gulp(p68, v333, p69)

        if v333 >= 0.6 then
            State.CaveAt = Stage.Elapsed(p68)
            enterCave(p68)
            cough(p68, 0, p69)
        end
    elseif p68.Phase == "Cough" then
        cough(p68, v333, p69)

        if v333 >= 0.55 then
            impact(p68)
            toss(p68, 0, p69)
        end
    elseif p68.Phase == "Splash" then
        toss(p68, v333, p69)

        if v333 >= 0.67 then
            land(p68)
            settle(p68, 0)
        end
    elseif p68.Phase == "Settle" then
        settle(p68, v333)
    end
end

local function finishPrepare(p70, p71) -- line: 1249
    -- upvalues: Depths (copy), Hands (copy), Kit (copy), v1 (copy), t1 (ref), footTrail (copy)
    local State, Double = p70.State, p70.Double

    if Double then
        State.DoubleStart = Double.Root.CFrame
        State.Trails = footTrail(p70)
    end

    local v339 = Kit.Part({
        Name = "Eye",
        Size = Vector3.new(0.2, 0.2, 0.2),
        Transparency = 1
    })

    v339.CFrame = CFrame.new(p71 + Vector3.new(0, 4, 0))
    v339.Parent = p70.Folder

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Kit.Teal
    PointLight.Range = 18
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = v339
    State.EyeLight = PointLight
    State.Crew = Hands.Build(p70.Scenery, p70.Folder, 4, 6)

    if p70.Calm then
        return
    end

    local t13 = t1

    t1 = nil

    if t13 ~= nil and t13.Depths.Model.Parent ~= nil then
        p70.Scenery:Add(t13.Trove)
        State.Depths = t13.Depths
    else
        if t13 ~= nil then
            t13.Trove:Destroy()
        end

        State.Depths = Depths.Build(p70.Scenery, p70.Folder, v1, p70.Low)
    end
end

local function prepare(p72) -- line: 1282
    -- upvalues: Kit (copy), surfaceBelow (copy), cloneRings (copy), finishPrepare (copy)
    local State = p72.State
    local Whirlpool = p72.Context.Whirlpool
    local v340

    if Whirlpool == nil or Whirlpool.Parent == nil then
        v340 = p72.Root.Position - Vector3.new(0, 4, 0)
        Whirlpool = nil
    else
        v340 = Whirlpool:GetBoundingBox().Position
    end

    State.Eye = v340
    State.Rings = cloneRings(p72, Whirlpool, v340)

    local Root, Double = p72.Root, p72.Double
    local v341 = Kit.Flat(Root.Position - v340)

    State.Laps = 0

    if Whirlpool ~= nil and v341.Magnitude > 40 then
        local v342 = Kit.FlatUnit(v341, (Vector3.new(1, 0, 0)))
        local v343 = v340 + v342 * 14

        State.FarStart = true
        State.Radius0 = 14
        State.Angle0 = math.atan2(-v342.Z, v342.X)
        State.Look0 = -v342
        State.Feet0 = surfaceBelow(p72, v343, v340.Y + 30)
        State.StartCamera = CFrame.lookAt(Vector3.new(v343.X, State.Feet0, v343.Z) + v342 * 15 + Vector3.new(0, 8, 0), v340)
        State.Back = v342

        return finishPrepare(p72, v340)
    end

    State.Radius0 = math.clamp(v341.Magnitude, 4.5, 26)
    State.Look0 = Kit.FlatUnit(Root.CFrame.LookVector, (Vector3.new(0, 0, 1)))
    State.Angle0 = math.atan2(-v341.Z, v341.X)
    State.Feet0 = Root.Position.Y - (if Double then Double.Stance else 3)
    State.StartCamera = p72.Camera.CFrame
    State.Back = Kit.FlatUnit(p72.Camera.CFrame.Position - Root.Position, -Root.CFrame.LookVector)
    finishPrepare(p72, v340)
end

function t2.Run(p73) -- line: 1319
    -- upvalues: Flash (copy), Score (copy), Splash (copy), Stage (copy), step (copy), prepare (copy)
    local v346 = Stage.Begin("Enter", p73)

    if v346 == nil or not Stage.Prepare(v346, prepare) then
        return Stage.Fallback(p73)
    end

    Stage.Phase(v346, v346.Calm and "Calm" or "Funnel")

    if not v346.Calm then
        Stage.Scriptable(v346)
    end

    if v346.State.FarStart and v346.OwnsCamera then
        Stage.Scriptable(v346)
        v346.Camera.CFrame = v346.State.StartCamera
        Flash.Play({
            Attack = 0.01,
            Decay = 0.3,
            Opacity = 1,
            Tint = Color3.fromRGB(215, 255, 245)
        })
    end

    Score.Duck(v346.Score, true, 0.3)
    Score.Play(v346.Score, "Splash", 0.6, 0.8)
    Score.Play(v346.Score, "Gulp", 0.55)

    if not v346.Calm then
        Score.Rise(v346.Score, 1.85, 0.32)
        Score.Loop(v346.Score, "Pour", 0, 0.6)

        local v347 = v346.Root.Position - Vector3.new(0, 2.5, 0)

        Splash.Small(v346.Splash, v347)
    end

    Stage.Bind(v346, step)

    return Stage.Wait(v346)
end

function t2.Warm() -- line: 1349
    -- upvalues: Score (copy)
    Score.Warm()
end

function t2.Prewarm() -- line: 1353
    -- upvalues: Workspace (copy), Depths (copy), Kit (copy), Stage (copy), Trove (copy), v1 (copy), t1 (ref)
    if t1 ~= nil or Stage.Active() ~= nil then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        local v348 = Trove.new()
        local v349 = v348:Add(Instance.new("Folder"))

        v349.Name = "SewerDrainWarm"
        v349.Parent = CurrentCamera

        local Build = Depths.Build
        local LowQuality = Kit.LowQuality
        local ok, result = pcall(Build, v348, v349, v1, LowQuality())

        if ok then
            t1 = {
                Trove = v348,
                Depths = result
            }
        else
            v348:Destroy()
        end
    end
end

function t2.Release() -- line: 1373
    -- upvalues: t1 (ref)
    local t14 = t1

    t1 = nil

    if t14 ~= nil then
        t14.Trove:Destroy()
    end
end

function t2.Visited() -- line: 1381
    -- upvalues: SewerCave (copy), LocalPlayer (copy), v9 (ref)
    return v9 or LocalPlayer:GetAttribute(SewerCave.Attributes.Inside) == true
end

return table.freeze(t2)
