-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Effects)
local CastFlight = require(script.Parent.CastFlight)
local Skip = require(script.Parent.Skip)
local Lure = require(script.Parent.Lure)
local t1 = {}
local v1 = Random.new()
local v2 = Color3.new(1, 1, 1)

local function shake(p1, p2) -- line: 36
    -- upvalues: Effects (copy)
    return Effects.shake(p1, p2)
end

local function startPoint(p3) -- line: 43
    -- upvalues: Canyon (copy), v1 (copy)
    local v3 = Vector2.new(p3.X, -p3.Z)
    local v4 = Canyon.biomeAt(v3.Y)
    local v5 = Canyon.starts[v4] + 6
    local v6 = Canyon.starts[v4] + Canyon.lengths[v4] - 6
    local v8 = math.clamp(v3.Y + v1:NextNumber(-45, 45), v5, v6)
    local v9 = v1:NextNumber(-40, 40)
    local t2 = {
        Vector2.new(-40, v8),
        Vector2.new(40, v8),
        Vector2.new(v9, v5),
        Vector2.new(v9, v6),
        Vector2.new(-40, v5),
        Vector2.new(40, v5),
        Vector2.new(-40, v6),
        Vector2.new(40, v6)
    }
    local t3 = {}
    local v10 = t2[1]
    local n1 = 0

    for _, v11 in t2 do
        local Magnitude = (v11 - v3).Magnitude

        if Magnitude >= 22 then
            table.insert(t3, v11)
        end

        if n1 < Magnitude then
            n1 = Magnitude
            v10 = v11
        end
    end

    if #t3 > 0 then
        v10 = t3[v1:NextInteger(1, #t3)]
    end

    local v12 = v10 - v3

    if v12.Magnitude > 75 then
        v12 = v12.Unit * 75
    end

    return v3 + v12
end

local function surfaceFromBelow(p4, p5, p6, p7) -- line: 81
    -- upvalues: Canyon (copy), Effects (copy), v2 (copy)
    for i = Canyon.biomeAt(p4), Canyon.biomeAt(p5) do
        for _, v13 in Canyon.pieces(i) do
            if v13.s1 >= p4 - 20 and v13.s0 <= p5 + 20 then
                local v16 = Vector3.new(0, v13.y0 - 0.06, -v13.s0)
                local v19 = Vector3.new(0, v13.y1 - 0.06, -v13.s1)

                Effects.part({
                    Name = "Surface",
                    Transparency = 0.25,
                    Size = Vector3.new(96, 0.2, (v19 - v16).Magnitude + 0.3),
                    CFrame = CFrame.lookAt((v16 + v19) / 2, v19),
                    Color = p6:Lerp(v2, 0.55),
                    Material = Enum.Material.Glass,
                    Parent = p7
                })
            end
        end
    end
end

local function lightShafts(p8, p9, p10) -- line: 102
    -- upvalues: Canyon (copy), Effects (copy), v1 (copy), v2 (copy)
    local t5 = {}

    for i = 1, 6 do
        local v22 = p8 + Vector3.new(v1:NextNumber(-22, 22), 0, v1:NextNumber(-30, 30))
        local v25 = Vector3.new(v22.X, Canyon.surface((math.max(-v22.Z, 0))), v22.Z)

        table.insert(t5, {
            part = Effects.part({
                Name = "Shaft",
                Transparency = 0.93,
                Size = Vector3.new(v1:NextNumber(1.2, 2.6), 9, 0.05),
                Color = p9:Lerp(v2, 0.8),
                Material = Enum.Material.Neon,
                Parent = p10
            }),
            top = v25,
            phase = i * 1.7
        })
    end

    return function(p11) -- line: 117
        -- upvalues: t5 (copy)
        for _, v27 in t5 do
            local v30 = math.rad(math.sin(p11 * 0.6 + v27.phase) * 6 + 18)

            v27.part.CFrame = CFrame.new(v27.top) * CFrame.Angles(0, 0.5235987755982988, 0) * CFrame.Angles(0, 0, v30) * CFrame.new(0, -4.5, 0)
            v27.part.Transparency = math.sin(p11 * 1.3 + v27.phase) * 0.04 + 0.9
        end
    end
end

function t1.run(p12, _, p14) -- line: 128
    -- upvalues: Players (copy), RunService (copy), Config (copy), Canyon (copy), UIUtil (copy), Effects (copy), CastFlight (copy), Skip (copy), Lure (copy), v1 (copy), v2 (copy), startPoint (copy), surfaceFromBelow (copy), lightShafts (copy)
    if p12.settling then
        p12.settling:Cancel()
    end

    if Skip.requested() then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    local CastPace = Config.CastPace
    local landing, color = p12.landing, p12.color
    local v32 = -landing.Z
    local Folder = Instance.new("Folder")

    Folder.Name = "FishPOV"
    Folder.Parent = workspace

    local v33 = landing - Vector3.new(0, 2.6, 0)
    local v34 = Effects.part({
        Name = "Hook",
        Size = Vector3.new(0.32, 0.32, 0.32),
        Shape = Enum.PartType.Ball,
        Color = Color3.fromRGB(190, 190, 200),
        Material = Enum.Material.Metal,
        Position = v33,
        Parent = Folder
    })
    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v34

    local clone = p12.line:Clone()

    clone.Attachment0 = p12.bobber.Line
    clone.Attachment1 = Attachment
    clone.Parent = v34

    local v35 = Config.BaitByKey[Players.LocalPlayer:GetAttribute("Bait") or ""]
    local v36, v37
    local v38 = {}
    local v39 = Vector3.new(0, 0, 0)

    if v35 then
        local v40, v41 = Lure.build(v35)

        v37 = v40
        v38 = v41
        v40:PivotTo(CFrame.new())
        v40:ScaleTo(0.4)

        local Eyelet = v40:FindFirstChild("Eyelet")

        v39 = v40.PrimaryPart.CFrame:PointToObjectSpace(Eyelet.Tie.WorldPosition)
        clone.Attachment1 = Eyelet.Tie
        v34.Transparency = 1

        local PointLight = Instance.new("PointLight")

        PointLight.Color = v35.Color
        PointLight.Range = 5
        PointLight.Brightness = 1.2
        PointLight.Parent = v40.PrimaryPart
        v40.Parent = Folder
    else
        v36 = Effects.part({
            Name = "Worm",
            Size = Vector3.new(0.22, 0.75, 0.22),
            Color = Color3.fromRGB(255, 120, 150),
            Parent = Folder
        })
    end

    local v42 = Vector3.new(1, 0, 0)

    local function wiggle(p15, p16) -- line: 173
        -- upvalues: v33 (copy), v34 (copy), v36 (ref), v37 (ref), v38 (ref), v39 (ref), v42 (ref), Lure (copy)
        v34.Position = v33 + Vector3.new(math.sin(p15 * 3.1) * 0.12 + p16 * 0.35, math.sin(p15 * 2.3) * 0.06, 0)

        if v37 then
            local v56 = CFrame.lookAt(Vector3.new(0, 0, 0), v42) * CFrame.Angles(math.rad(math.sin(p15 * 2.7) * 8 + 18 + p16 * 25), math.rad(math.sin(p15 * 1.9) * 20), (math.rad(math.sin(p15 * 3.3) * 6)))
            local v57 = v37

            v57:PivotTo(v56 + (v34.Position - v56:VectorToWorldSpace(v39)))
            Lure.cycle(v38, p15)
        elseif v36 then
            local v58 = v36

            v58.CFrame = CFrame.new(v34.Position - Vector3.new(0, 0.42, 0)) * CFrame.Angles(0, 0, (math.rad(math.sin(p15 * 5) * 18 + 20 + p16 * 30)))
        end
    end

    wiggle(0, 0)

    local v62 = startPoint(landing)
    local v63 = Vector2.new(landing.X, v32)
    local Magnitude, Unit = (v63 - v62).Magnitude, (v63 - v62).Unit

    v42 = Vector3.new(Unit.Y, 0, Unit.X)

    local v64 = v63 - Unit * 1.7
    local v65 = Vector2.new(-Unit.Y, Unit.X) * Magnitude * v1:NextNumber(0.18, 0.4) * (if v1:NextNumber() < 0.5 then -1 else 1)
    local v66 = (v62 + v64) / 2 + v65

    local function along(p17) -- line: 198
        -- upvalues: v62 (copy), v64 (copy), v66 (copy)
        local v67 = 1 - p17
        local v68 = v62 * (v67 * v67) + v66 * (p17 * 2 * v67) + v64 * (p17 * p17)

        return Vector2.new(math.clamp(v68.X, -44, 44), v68.Y)
    end

    local function inWater(p18, p19) -- line: 204
        -- upvalues: Canyon (copy)
        local v69 = math.max(p18.Y, 0)
        local v70 = Canyon.surface(v69)

        return (Vector3.new(p18.X, v70 - math.clamp(p19, 0.9, 7.2), -v69))
    end

    surfaceFromBelow(math.min(v62.Y, v32), math.max(v62.Y, v32), color, Folder)

    local v76 = lightShafts(Vector3.new((v62.X + landing.X) / 2, 0, -(v62.Y + v32) / 2), color, Folder)
    local v77 = Effects.part({
        Name = "Bubbler",
        Size = Vector3.new(6, 4, 1),
        Transparency = 1,
        Parent = Folder
    })
    local v78 = Effects.emitter(v77, {
        LightEmission = 0.2,
        Rate = 30,
        Color = ColorSequence.new(v2),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(1, 0.28)
        }),
        Transparency = NumberSequence.new(0.35, 1),
        Lifetime = NumberRange.new(0.6, 1.2),
        Speed = NumberRange.new(2, 5),
        EmissionDirection = Enum.NormalId.Top
    })

    Effects.emitter(v77, {
        LightEmission = 0.4,
        Rate = 40,
        Color = ColorSequence.new(color:Lerp(v2, 0.7)),
        Size = NumberSequence.new(0.06),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.5, 2.5),
        Speed = NumberRange.new(0.2, 0.6),
        SpreadAngle = Vector2.new(180, 180)
    }).Shape = Enum.ParticleEmitterShape.Box

    local v79 = Effects.underwaterLook(color)

    local function finish() -- line: 238
        -- upvalues: Folder (copy), v79 (copy)
        v79()
        Folder:Destroy()
    end

    UIUtil.sound("Splash", 0.5, 0.6)
    UIUtil.sound("Bubbles", 0.6)

    local v80 = UIUtil.sound("BubbleSwell", 0, 1, 30)

    if v80 then
        v80.Looped = true
        UIUtil.tween(v80, 0.6, {
            Volume = 0.75
        })
    end

    Effects.flash(p14, color:Lerp(v2, 0.3), 0.35)

    local v81 = 5.1 * (0.65 + 0.35 * Magnitude / 75) * CastPace
    local elapsed = os.clock()
    local _CFrame = CurrentCamera.CFrame

    CurrentCamera.FieldOfView = 92

    local n2 = 0
    local n3 = 0

    while not Skip.requested() do
        local v82 = os.clock() - elapsed
        local v84 = math.min(v82 / v81, 1)
        local v85 = 1 - (1 - v84) ^ 2.2
        local v87 = math.sin(v82 / CastPace * 7) * (1 - v84) * 0.7
        local v88 = v85 * v85 * (3 - v85 * 2) * -1.5000000000000004 + 4.4
        local v89 = 1 - v85
        local v90 = v62 * (v89 * v89) + v66 * (v85 * 2 * v89) + v64 * (v85 * v85)
        local v91 = Vector2.new(math.clamp(v90.X, -44, 44), v90.Y)
        local v93 = math.min(v85 + 0.08, 1)
        local v94 = 1 - v93
        local v95 = v62 * (v94 * v94) + v66 * (v93 * 2 * v94) + v64 * (v93 * v93)
        local v96 = Vector2.new(math.clamp(v95.X, -44, 44), v95.Y)
        local v97 = v96 - v91
        local v98 = v91 + (if v97.Magnitude > 0.001 then Vector2.new(-v97.Y, v97.X).Unit * v87 else Vector2.zero)
        local v99 = math.max(v98.Y, 0)
        local v100 = Canyon.surface(v99)
        local v103 = Vector3.new(v98.X, v100 - math.clamp(v88, 0.9, 7.2), -v99)
        local v104 = math.max(v96.Y, 0)
        local v105 = Canyon.surface(v104)
        local v110 = Vector3.new(v96.X, v105 - math.clamp(v88, 0.9, 7.2), -v104):Lerp(v33, (math.clamp((v84 - 0.45) / 0.4, 0, 1)))

        if (v110 - v103).Magnitude < 0.1 then
            v110 = v33
        end

        local v112 = CFrame.Angles(0, 0, math.sin(v82 / CastPace * 7) * 0.08726646259971647 * (1 - v84))

        _CFrame = CFrame.lookAt(v103, v110) * v112
        CurrentCamera.CFrame = _CFrame
        CurrentCamera.FieldOfView = 92 - v85 * 18
        v77.CFrame = _CFrame * CFrame.new(0, -1.5, -4)
        v78.Rate = (1 - v84) * 30 + 4
        v76(v82)
        wiggle(v82, 0)

        if v82 - n2 > 0.55 - v84 * 0.25 then
            n2 = v82
            n3 += 1
            UIUtil.sound("Tick", v84 * 0.12 + 0.08, n3 * 0.02 + 0.5)
        end

        if v84 >= 1 then
            break
        end

        RunService.Heartbeat:Wait()
    end

    if Skip.requested() then
        if v80 then
            v80:Destroy()
        end

        v79()
        Folder:Destroy()
        CurrentCamera.CFrame = CastFlight.fightView(landing)
    else
        for i = 1, 2 do
            local elapsed2 = os.clock()

            UIUtil.sound("Tick", 0.3, i * 0.15 + 1.1)
            UIUtil.sound("Bubbles", 0.25, 1.4)

            while os.clock() - elapsed2 < 0.48 * CastPace and not Skip.requested() do
                local v113 = (os.clock() - elapsed2) / (0.48 * CastPace)
                local v115 = math.sin(v113 * 3.141592653589793) * (i * 0.25 + 0.5)

                CurrentCamera.CFrame = _CFrame * CFrame.new(0, 0, -v115)
                wiggle(os.clock() - elapsed, (math.sin(v113 * 3.141592653589793)))
                v76(os.clock() - elapsed)
                RunService.Heartbeat:Wait()
            end

            CurrentCamera.CFrame = _CFrame
            task.wait(0.18 * CastPace)
        end

        UIUtil.sound("Splash", 0.9, 0.7)
        UIUtil.sound("Bite", 0.4, 1.1)
        Effects.flash(p14, v2, 0.5, 0.3)

        if v80 then
            UIUtil.tween(v80, 0.5, {
                Volume = 0
            })
            task.delay(0.5, function() -- line: 327
                -- upvalues: v80 (copy)
                v80:Destroy()
            end)
        end

        local elapsed2 = os.clock()

        while os.clock() - elapsed2 < 0.25 * CastPace and not Skip.requested() do
            local v118 = (os.clock() - elapsed2) / (0.25 * CastPace)
            local v120 = _CFrame * CFrame.new(0, 0, math.min(v118 * 3, 1) * -1.4)
            local v121 = 0.35 * (1 - v118)

            CurrentCamera.CFrame = Effects.shake(v120, v121)
            CurrentCamera.FieldOfView = 74 - math.min(v118 * 3, 1) * 10
            RunService.Heartbeat:Wait()
        end

        v79()
        Folder:Destroy()
        CurrentCamera.CFrame = CastFlight.fightView(landing)
        CurrentCamera.FieldOfView = 62
    end
end

return t1
