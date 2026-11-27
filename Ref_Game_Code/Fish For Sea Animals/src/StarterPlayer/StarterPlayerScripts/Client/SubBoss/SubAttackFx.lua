-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SubArena = require(ReplicatedStorage.Shared.SubArena)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(255, 50, 60)
local v2 = Color3.fromRGB(120, 230, 255)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.fromRGB(70, 66, 72)
local Folder, v5
local t2 = {}
local t3 = {}

local function now() -- line: 33
    return workspace:GetServerTimeNow()
end

local function part(p1) -- line: 37
    -- upvalues: Folder (ref)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    Part.TopSurface = Smooth
    Part.BottomSurface = Smooth2

    for v6, v7 in p1 do
        Part[v6] = v7
    end

    Part.Parent = Folder

    return Part
end

local function tween(p2, p3, p4) -- line: 49
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p2, TweenInfo.new(p3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p4)

    tween:Play()

    return tween
end

local function burst(p5, p6, p7) -- line: 55
    -- upvalues: Debris (copy), part (copy)
    local v8 = part({
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        CFrame = CFrame.new(p5)
    })
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v9, v10 in p7 do
        ParticleEmitter[v9] = v10
    end

    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = v8
    ParticleEmitter:Emit(p6)
    Debris:AddItem(v8, 3)
end

local function bubbles(p8, p9, p10) -- line: 67
    -- upvalues: burst (copy)
    burst(p8, p9, {
        LightEmission = 0.4,
        Acceleration = Vector3.new(0, 10, 0),
        Drag = 2,
        Color = ColorSequence.new(Color3.fromRGB(220, 240, 255)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(1, 2.2)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1, 2),
        Speed = NumberRange.new(p10 * 0.4, p10),
        SpreadAngle = Vector2.new(180, 180)
    })
end

local function silt(p11, p12, p13) -- line: 81
    -- upvalues: burst (copy)
    burst(p11, p12, {
        Drag = 2.5,
        Color = ColorSequence.new(Color3.fromRGB(60, 72, 96)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p13 * 0.4),
            NumberSequenceKeypoint.new(1, p13)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.5, 2.6),
        Speed = NumberRange.new(8, 22),
        SpreadAngle = Vector2.new(80, 80),
        EmissionDirection = Enum.NormalId.Top,
        Rotation = NumberRange.new(0, 360)
    })
end

local function shake(p14, p15, p16) -- line: 95
    -- upvalues: Settings (copy), LocalPlayer (copy)
    local v11 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local v12 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not (v11 and v12 and Settings.get("Shake")) then
        return
    end

    local v14 = p15 * math.clamp(1 - (v12.Position - p14).Magnitude / p16, 0, 1)

    if not (v14 < 0.05) then
        task.spawn(function() -- line: 105
            -- upvalues: v14 (copy), v11 (copy)
            for i = 1, 10 do
                v11.CameraOffset = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 2 * v14 * (1 - i / 11)
                task.wait(0.03)
            end

            v11.CameraOffset = Vector3.new(0, 0, 0)
        end)
    end
end

local function call(p17, p18) -- line: 114
    -- upvalues: v1 (copy), v5 (ref)
    if v5 then
        local v18 = v5

        v18({
            {
                p17,
                p18 or v1,
                64
            }
        }, 1.4)
    end
end

local function run(p19) -- line: 120
    -- upvalues: t2 (copy)
    table.insert(t2, {
        step = p19
    })
end

local function wallRing(p20, p21, p22, p23, p24, p25) -- line: 125
    -- upvalues: part (copy)
    local t7 = {}

    for _ = 1, p25 do
        table.insert(t7, (part({
            Name = "RingSlab",
            Size = Vector3.new(1, p22, 1),
            Color = p23,
            Transparency = p24
        })))
    end

    return function(p26) -- set | line: 130
        -- upvalues: p20 (copy), p21 (copy), p22 (copy), p25 (copy), t7 (copy)
        local v21 = 6.283185307179586 * p26 / p25 * 1.08

        for v22, v23 in t7 do
            local v24 = (v22 - 0.5) / p25 * 3.141592653589793 * 2
            local v27 = Vector3.new(p20.X + math.cos(v24) * p26, p21, p20.Z + math.sin(v24) * p26)

            v23.Size = Vector3.new(math.max(v21, 0.5), p22, 0.8)
            v23.CFrame = CFrame.lookAt(v27, (Vector3.new(p20.X, p21, p20.Z)))
        end
    end, function() -- remove | line: 139
        -- upvalues: t7 (copy)
        for _, v29 in t7 do
            v29:Destroy()
        end
    end, t7
end

local function disc(p27, p28, p29, p30) -- line: 148
    -- upvalues: part (copy)
    return (part({
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.4, p28 * 2, p28 * 2),
        CFrame = CFrame.new(p27) * CFrame.Angles(0, 0, 1.5707963267948966),
        Color = p29,
        Transparency = p30
    }))
end

local function clawSnap(p31) -- line: 160
    -- upvalues: Debris (copy), TweenService (copy), UIUtil (copy), v1 (copy), v3 (copy), t2 (copy), part (copy), bubbles (copy), shake (copy), call (copy)
    local At, Radius, HitAt = p31.At, p31.Radius, p31.HitAt

    if typeof(At) ~= "Vector3" then
        return
    end

    call("MOVE!")
    UIUtil.sound("BossGrowl", 0.6, 0.9)

    local v32 = part({
        Transparency = 0.82,
        Shape = Enum.PartType.Ball,
        Size = Vector3.new(1, 1, 1) * Radius * 2,
        CFrame = CFrame.new(At),
        Color = v1
    })
    local v33 = part({
        Transparency = 0.9,
        Shape = Enum.PartType.Ball,
        Size = Vector3.new(1, 1, 1) * Radius * 2,
        CFrame = CFrame.new(At),
        Color = v3
    })
    local ServerTimeNow = workspace:GetServerTimeNow()

    table.insert(t2, {
        step = function(p32) -- line: 170
            -- upvalues: At (copy), Radius (copy), HitAt (copy), v32 (copy), v33 (copy), ServerTimeNow (copy), Debris (copy), TweenService (copy), UIUtil (copy), v3 (copy), bubbles (copy), shake (copy)
            local v37 = math.clamp((HitAt - p32) / math.max(HitAt - ServerTimeNow, 0.1), 0, 1)

            v33.Size = Vector3.new(1, 1, 1) * Radius * 2 * v37
            v32.Transparency = 0.82 - (math.sin(os.clock() * 18) + 1) * 0.05

            if p32 < HitAt then
                return true
            end

            v33:Destroy()
            v32.Color = v3
            v32.Transparency = 0.4

            local t10 = {
                Transparency = 1,
                Size = Vector3.new(1, 1, 1) * Radius * 2.6
            }

            TweenService:Create(v32, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
            Debris:AddItem(v32, 0.4)
            bubbles(At, 30, 30)
            UIUtil.sound("MetalClang", 0.9, 0.7)
            UIUtil.sound("Bite", 0.8, 0.7)
            shake(At, 0.8, 120)

            return false
        end
    })
end

local function anchor() -- line: 193
    -- upvalues: v4 (copy), Folder (ref), part (copy)
    local Model = Instance.new("Model")

    Model.Name = "Anchor"

    local function add(p33, p34) -- line: 196
        -- upvalues: Model (copy), v4 (copy), part (copy)
        local v39 = part(p33)

        v39.Material = Enum.Material.Metal
        v39.Color = v4
        v39.Parent = Model
        v39:SetAttribute("Rel", p34)

        return v39
    end

    local t11 = {
        Size = Vector3.new(2.4, 26, 2.4)
    }
    local v40 = CFrame.new(0, 13, 0)
    local v41 = part(t11)

    v41.Material = Enum.Material.Metal
    v41.Color = v4
    v41.Parent = Model
    v41:SetAttribute("Rel", v40)

    local t12 = {
        Size = Vector3.new(14, 2, 2)
    }
    local v42 = CFrame.new(0, 22, 0)
    local v43 = part(t12)

    v43.Material = Enum.Material.Metal
    v43.Color = v4
    v43.Parent = Model
    v43:SetAttribute("Rel", v42)

    local t13 = {
        Size = Vector3.new(1.4, 6, 6),
        Shape = Enum.PartType.Cylinder
    }
    local v44 = CFrame.new(0, 28, 0)
    local v45 = part(t13)

    v45.Material = Enum.Material.Metal
    v45.Color = v4
    v45.Parent = Model
    v45:SetAttribute("Rel", v44)

    for i = -1, 1, 2 do
        local t14 = {
            Size = Vector3.new(10, 2.2, 2.2)
        }
        local v46 = CFrame.new(i * 4.5, 2.5, 0) * CFrame.Angles(0, 0, i * 0.5235987755982988)
        local v47 = part(t14)

        v47.Material = Enum.Material.Metal
        v47.Color = v4
        v47.Parent = Model
        v47:SetAttribute("Rel", v46)

        local t15 = {
            Size = Vector3.new(4, 4, 2.4)
        }
        local v48 = CFrame.new(i * 9, 5.5, 0) * CFrame.Angles(0, 0, i * 0.7853981633974483)
        local v49 = part(t15)

        v49.Material = Enum.Material.Metal
        v49.Color = v4
        v49.Parent = Model
        v49:SetAttribute("Rel", v48)
    end

    Model.Parent = Folder

    return Model
end

local function placeModel(p35, p36) -- line: 215
    local t16 = {}
    local t17 = {}

    for _, child in p35:GetChildren() do
        if child:IsA("BasePart") then
            table.insert(t16, child)
            table.insert(t17, p36 * child:GetAttribute("Rel"))
        end
    end

    workspace:BulkMoveTo(t16, t17, Enum.BulkMoveMode.FireCFrameChanged)
end

local function anchors(p37) -- line: 226
    -- upvalues: SubArena (copy), UIUtil (copy), v1 (copy), t2 (copy), part (copy), bubbles (copy), silt (copy), shake (copy), call (copy), disc (copy), anchor (copy), placeModel (copy)
    local v51 = p37.Radius or 20

    if type(p37.Spots) ~= "table" then
        return
    end

    call("ANCHORS! MOVE!")
    UIUtil.sound("Rumble", 0.6, 0.7)

    for _, v52 in p37.Spots do
        local At, HitAt = v52.At, v52.HitAt

        if typeof(At) == "Vector3" then
            local v54 = Vector3.new(At.X, SubArena.FLOOR_Y + 0.3, At.Z)
            local v55 = disc(v54, v51, v1, 0.55)
            local v58 = part({
                Transparency = 0.9,
                Shape = Enum.PartType.Cylinder,
                Size = Vector3.new(170, v51 * 2, v51 * 2),
                CFrame = CFrame.new(v54 + Vector3.new(0, 85, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
                Color = v1
            })
            local v59 = anchor()
            local v60 = SubArena.FLOOR_Y + 220
            local v61 = math.random() * 3.141592653589793 * 2

            placeModel(v59, CFrame.new(At.X, v60, At.Z))

            local v62 = false

            table.insert(t2, {
                step = function(p38) -- line: 247
                    -- upvalues: At (copy), HitAt (copy), v54 (copy), v55 (copy), v58 (copy), v59 (copy), v60 (copy), v61 (copy), v62 (ref), SubArena (copy), UIUtil (copy), bubbles (copy), silt (copy), shake (copy), placeModel (copy)
                    local v64 = math.clamp(1 - (HitAt - p38) / 0.55, 0, 1)

                    v55.Transparency = 0.55 - (math.sin(os.clock() * 14) + 1) * 0.12

                    local v66 = v60 + (SubArena.FLOOR_Y - 4 - v60) * (v64 * v64)

                    placeModel(v59, CFrame.new(At.X, v66, At.Z) * CFrame.Angles(0, v61, 0))

                    if p38 < HitAt then
                        return true
                    end

                    if not v62 then
                        v62 = true
                        v55:Destroy()
                        v58:Destroy()
                        silt(v54, 26, 14)
                        bubbles(v54 + Vector3.new(0, 6, 0), 16, 20)
                        UIUtil.sound("SubBoom", 0.5, 0.7 + math.random() * 0.2)
                        shake(v54, 0.9, 90)
                        task.delay(1.8, function() -- line: 264
                            -- upvalues: v59 (copy)
                            v59:Destroy()
                        end)
                    end

                    return false
                end
            })
        end
    end
end

local function charge(p39) -- line: 275
    -- upvalues: Debris (copy), TweenService (copy), SubArena (copy), UIUtil (copy), v1 (copy), v3 (copy), t2 (copy), part (copy), shake (copy), call (copy)
    local From, Dir, Length, Width = p39.From, p39.Dir, p39.Length, p39.Width
    local Top, HitAt = p39.Top, p39.HitAt

    if typeof(From) ~= "Vector3" or typeof(Dir) ~= "Vector3" then
        return
    end

    call("CLIMB OVER IT!")
    UIUtil.sound("BossGrowl", 0.8, 0.6)
    UIUtil.sound("Rumble", 0.7, 0.5)

    local v67 = Top - SubArena.FLOOR_Y
    local v68 = Vector3.new(From.X, SubArena.FLOOR_Y, From.Z) + Dir * (Length / 2)
    local v69 = CFrame.lookAt(v68, v68 + Dir)
    local v70 = part({
        Transparency = 0.88,
        Size = Vector3.new(Width, v67, Length),
        CFrame = v69 * CFrame.new(0, v67 / 2, 0),
        Color = v1
    })
    local v71 = part({
        Transparency = 0.5,
        Size = Vector3.new(Width, 0.4, Length),
        CFrame = v69 * CFrame.new(0, 0.3, 0),
        Color = v1
    })
    local v72 = part({
        Transparency = 0.75,
        Size = Vector3.new(Width, 0.3, Length),
        CFrame = v69 * CFrame.new(0, v67, 0),
        Color = v3
    })
    local v73 = false

    table.insert(t2, {
        step = function(p40) -- line: 290
            -- upvalues: p39 (copy), From (copy), Length (copy), HitAt (copy), v70 (copy), v71 (copy), v72 (copy), v73 (ref), Debris (copy), TweenService (copy), UIUtil (copy), shake (copy)
            v71.Transparency = 0.5 - (math.sin(os.clock() * 16) + 1) * 0.12

            if p40 < HitAt then
                return true
            end

            if not v73 then
                v73 = true
                UIUtil.sound("BossRoar", 1, 0.7, 8)
                UIUtil.sound("Whoosh", 0.9, 0.5)
                shake(From, 1, 200)

                for _, v75 in { v70, v71, v72 } do
                    local v76 = Length / (p39.Speed or 170)
                    local t21 = {
                        Transparency = 1
                    }

                    TweenService:Create(v75, TweenInfo.new(v76, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t21):Play()
                    Debris:AddItem(v75, Length / (p39.Speed or 170) + 0.2)
                end
            end

            return false
        end
    })
end

local function sonar(p41) -- line: 311
    -- upvalues: Debris (copy), TweenService (copy), SubArena (copy), UIUtil (copy), v1 (copy), v2 (copy), t2 (copy), shake (copy), call (copy), wallRing (copy), disc (copy)
    local Center = p41.Center
    local v77 = p41.Speed or 95
    local v78 = p41.Band or 9
    local v79 = p41.MaxR or 500

    if not (typeof(Center) == "Vector3" and type(p41.Rings) == "table") then
        return
    end

    call("CHANGE DEPTH!", v2)
    UIUtil.sound("BossFirstRoar", 0.9, 0.9, 10)

    for _, v82 in p41.Rings do
        local Y, StartAt = v82.Y, v82.StartAt
        local v83 = disc(Vector3.new(Center.X, Y, Center.Z), SubArena.RADIUS + 60, v1, 0.93)
        local v84, v85, v86 = wallRing(Center, Y, v78 * 2, v2, 0.35, 56)

        v84(4)

        local ServerTimeNow = workspace:GetServerTimeNow()
        local v87 = false

        table.insert(t2, {
            step = function(p42) -- line: 326
                -- upvalues: Center (copy), v77 (copy), v79 (copy), StartAt (copy), v83 (copy), v84 (copy), v85 (copy), v86 (copy), ServerTimeNow (copy), v87 (ref), Debris (copy), TweenService (copy), UIUtil (copy), shake (copy)
                local v88 = (p42 - StartAt) * v77

                if v88 <= 0 then
                    local v92 = math.clamp((p42 - ServerTimeNow) / math.max(StartAt - ServerTimeNow, 0.1), 0, 1)

                    v84(v92 * 12 + 10)

                    for _, v93 in v86 do
                        v93.Transparency = 0.45 - v92 * 0.3
                    end
                else
                    if not v87 then
                        v87 = true
                        UIUtil.sound("SubBoom", 0.6, 0.5)
                        UIUtil.sound("Luck9", 0.35, 0.8)
                        shake(Center, 0.6, 300)

                        local t23 = {
                            Transparency = 1
                        }

                        TweenService:Create(v83, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t23):Play()
                        Debris:AddItem(v83, 1.1)
                    end

                    if v79 <= v88 then
                        v85()

                        return false
                    end

                    v84(v88)

                    local v94 = v88 / v79

                    for _, v95 in v86 do
                        v95.Transparency = 0.25 + v94 * 0.6
                    end
                end

                return true
            end
        })
    end
end

local function vortex(p43) -- line: 360
    -- upvalues: SubArena (copy), UIUtil (copy), v1 (copy), v2 (copy), t2 (copy), t3 (copy), part (copy), call (copy), disc (copy)
    local Center, Radius, Core, Pull = p43.Center, p43.Radius, p43.Core, p43.Pull
    local StartAt, Duration, Top = p43.StartAt, p43.Duration, p43.Top

    if typeof(Center) ~= "Vector3" then
        return
    end

    call("DRIVE AWAY!")
    table.insert(t3, {
        center = Center,
        radius = Radius,
        pull = Pull,
        from = StartAt,
        to = StartAt + Duration
    })

    local v96 = Vector3.new(Center.X, SubArena.FLOOR_Y, Center.Z)
    local v97 = Top - SubArena.FLOOR_Y
    local v101 = part({
        Transparency = 0.8,
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(v97, Core * 2, Core * 2),
        CFrame = CFrame.new(v96 + Vector3.new(0, v97 / 2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
        Color = v1
    })
    local v102 = disc(v96 + Vector3.new(0, 0.3, 0), Radius, v2, 0.85)
    local t26 = {}

    for i = 1, 18 do
        table.insert(t26, {
            p = part({
                Size = Vector3.new(0.6, 0.6, 14),
                Transparency = 0.5,
                Color = Color3.fromRGB(200, 240, 255)
            }),
            a = i / 18 * 3.141592653589793 * 2,
            r = Radius * (i % 6 / 6 * 0.7 + 0.3),
            y = SubArena.FLOOR_Y + 8 + i % 5 * (v97 / 5)
        })
    end

    local v103

    table.insert(t2, {
        step = function(p44) -- line: 378
            -- upvalues: Center (copy), Radius (copy), Core (copy), StartAt (copy), Duration (copy), v101 (copy), v102 (copy), t26 (copy), v103 (ref), UIUtil (copy)
            local v104 = StartAt <= p44
            local v105 = 0.3

            if v104 then
                if not v103 then
                    v103 = UIUtil.sound("BubbleSwell", 0.7, 0.6, Duration + 1)
                    UIUtil.sound("Rumble", 0.8, 0.8)
                end

                v105 = 1
            end

            for _, v106 in t26 do
                v106.a = v106.a + (60 / math.max(v106.r, 10) + 0.9) * v105 * 0.016666666666666666
                v106.r -= v105 * 22 * 0.016666666666666666

                if v106.r < Core * 0.6 then
                    v106.r = Radius
                end

                local v109 = Vector3.new(Center.X + math.cos(v106.a) * v106.r, v106.y, Center.Z + math.sin(v106.a) * v106.r)
                local v112 = Vector3.new(-math.sin(v106.a), 0, (math.cos(v106.a)))

                v106.p.CFrame = CFrame.lookAt(v109, v109 + v112)
                v106.p.Transparency = v104 and 0.35 or 0.75
            end

            v101.Transparency = 0.8 - (math.sin(os.clock() * 12) + 1) * 0.06

            if p44 < StartAt + Duration then
                return true
            end

            v101:Destroy()
            v102:Destroy()

            for _, v114 in t26 do
                v114.p:Destroy()
            end

            return false
        end
    })
end

function t1.pull(p45) -- line: 410
    -- upvalues: t3 (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v115 = #t3
    local v116 = Vector3.new(0, 0, 0)

    for i = v115, 1, -1 do
        local v117 = t3[i]

        if v117.to < ServerTimeNow then
            table.remove(t3, i)
        elseif v117.from <= ServerTimeNow then
            local v120 = Vector3.new(v117.center.X - p45.X, 0, v117.center.Z - p45.Z)
            local Magnitude = v120.Magnitude

            if Magnitude < v117.radius and Magnitude > 0.01 then
                local Unit = v120.Unit
                local v121 = v117.pull * (0.35 + 0.65 * (1 - Magnitude / v117.radius))
                local v123 = Vector3.new(-Unit.Z, 0, Unit.X)

                v116 += Unit * v121 + v123 * v121 * 0.5
            end
        end
    end

    return v116
end

local t29 = {
    ClawSnap = clawSnap,
    Anchors = anchors,
    Charge = charge,
    Sonar = sonar,
    Vortex = vortex
}

function t1.warn(p46) -- line: 433
    -- upvalues: Folder (ref), t29 (copy)
    if type(p46) ~= "table" or not Folder then
        return
    end

    local v124 = t29[p46.Kind]

    if v124 then
        v124(p46)
    end
end

function t1.start(p47) -- line: 443
    -- upvalues: t1 (copy), Folder (ref), v5 (ref)
    t1.clear()
    v5 = p47

    local Folder2 = Instance.new("Folder")

    Folder2.Name = "SubBossFx"
    Folder2.Parent = workspace
    Folder = Folder2
end

function t1.clear() -- line: 452
    -- upvalues: Folder (ref), t2 (copy), t3 (copy)
    table.clear(t2)
    table.clear(t3)

    if Folder then
        Folder:Destroy()
        Folder = nil
    end
end

function t1.init() -- line: 461
    -- upvalues: RunService (copy), t2 (copy)
    RunService.RenderStepped:Connect(function() -- line: 462
        -- upvalues: t2 (copy)
        if #t2 == 0 then
            return
        end

        local ServerTimeNow = workspace:GetServerTimeNow()

        for i = #t2, 1, -1 do
            local step = t2[i].step
            local ok, result = pcall(step, ServerTimeNow)

            if not ok or not result then
                table.remove(t2, i)
            end
        end
    end)
end

return t1
