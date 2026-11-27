-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")

game:GetService("RunService")

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local CosmicEvent = require(Shared.Data.CosmicEvent)
local FishModels = require(Shared.FishModels)
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local ScreenFx = require(script.Parent.ScreenFx)
local MoveLock = require(script.Parent.MoveLock)
local Pad = require(script.Parent.Pad)
local BuffHud = require(script.Parent.BuffHud)
local t1 = {
    Watching = false,
    Fired = {},
    MyBet = nil,
    BetResult = nil
}
local LocalPlayer = Players.LocalPlayer
local CurrentCamera, fromRGB, new = workspace.CurrentCamera, Color3.fromRGB, Vector3.new
local Neon = Enum.Material.Neon
local v1 = Font.fromEnum(Enum.Font.LuckiestGuy)
local BATTLE, ARENA = CosmicEvent.BATTLE, CosmicEvent.ARENA
local v2 = fromRGB(190, 120, 255)
local v3 = fromRGB(90, 30, 190)
local v4 = fromRGB(255, 226, 120)
local v5 = fromRGB(230, 150, 30)
local v6 = fromRGB(255, 255, 255)
local v7 = 0.12 * (BATTLE.CLASH - BATTLE.FACE)
local v8, gui
local t2 = {}
local v9 = true
local n1 = 0
local n2 = 0

local function clamp01(p1) -- line: 54
    return (math.clamp(p1, 0, 1))
end

local function smooth(p2) -- line: 57
    local v10 = math.clamp(p2, 0, 1)

    return v10 * v10 * (3 - v10 * 2)
end

local function smoother(p3) -- line: 61
    local v11 = math.clamp(p3, 0, 1)

    return v11 * v11 * v11 * (v11 * (v11 * 6 - 15) + 10)
end

local function easeIn(p4) -- line: 65
    local v12 = math.clamp(p4, 0, 1)

    return v12 * v12 * v12
end

local function easeOut(p5) -- line: 69
    local v13 = 1 - math.clamp(p5, 0, 1)

    return 1 - v13 * v13 * v13
end

local function seg(p6, p7, p8) -- line: 73
    return (math.clamp((p6 - p7) / (p8 - p7), 0, 1))
end

local function hermite(p9, p10, p11, p12, p13) -- line: 76
    local v15 = p13 * p13
    local v16 = p13 * p13 * p13

    return (v16 * 2 - v15 * 3 + 1) * p9 + (v16 - v15 * 2 + p13) * p10 + (v16 * -2 + v15 * 3) * p11 + (v16 - v15) * p12, (v15 * 6 - p13 * 6) * p9 + (v15 * 3 - p13 * 4 + 1) * p10 + (v15 * -6 + p13 * 6) * p11 + (v15 * 3 - p13 * 2) * p12
end

local function part(p14) -- line: 82
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part:SetAttribute("NoStuds", true)

    for v17, v18 in pairs(p14) do
        Part[v17] = v18
    end

    return Part
end

local function stretch(p15, p16, p17, p18) -- line: 97
    -- upvalues: new (copy)
    p15.Size = new(math.max((p17 - p16).Magnitude, 0.1), p18, p18)
    p15.CFrame = CFrame.lookAt((p16 + p17) / 2, p17) * CFrame.Angles(0, 1.5707963267948966, 0)
end

local function frame(p19, p20) -- line: 104
    -- upvalues: ARENA (copy)
    return ARENA + CFrame.Angles(0, p19, 0):VectorToWorldSpace(p20)
end

local function F(p21) -- line: 107
    -- upvalues: ARENA (copy), v7 (copy)
    return ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace(p21)
end

local function thetaAt(p22) -- line: 110
    -- upvalues: BATTLE (copy)
    return 0.12 * (math.clamp(p22, BATTLE.FACE, BATTLE.CLASH) - BATTLE.FACE)
end

local function khaosLocal(p23) -- line: 116
    -- upvalues: new (copy), BATTLE (copy), hermite (copy)
    local v22 = new(0, math.sin(p23 * 1.3) * 3, 0)

    if p23 < BATTLE.CLASH then
        return Vector3.new(-58, 0, 0) + v22
    end

    if p23 < 43 then
        local v25 = math.clamp(math.clamp((p23 - 42) / 1, 0, 1), 0, 1)

        return (Vector3.new(-58, 0, 0)):Lerp(Vector3.new(-72, 2, 0), v25 * v25 * (3 - v25 * 2))
    end

    if p23 < 45 then
        local v28 = math.clamp(math.clamp((p23 - 43) / 2, 0, 1), 0, 1)

        return (Vector3.new(-72, 2, 0)):Lerp(Vector3.new(-40, 0, 0), v28 * v28 * v28)
    end

    if p23 < 50 then
        local v31 = 1 - math.clamp(math.clamp((p23 - 45) / 5, 0, 1), 0, 1)
        local v32 = 1 - v31 * v31 * v31

        return (Vector3.new(-40, 0, 0)):Lerp(Vector3.new(-58, 0, 0), v32) + Vector3.new(-14, 10, 0) * math.sin(v32 * 3.141592653589793)
    end

    if p23 < 62 then
        local v39 = Vector3.new(-58, 0, 0) + new(0, math.sin(p23 * 3.1) * 4, math.sin(p23 * 2.3) * 9)

        for i = 0, 5 do
            local v40 = i * 1.5 + 51.5

            if v40 < p23 then
                v39 += Vector3.new(-7, 2, 0) * math.exp(-(p23 - v40) * 4)
            end
        end

        local v44 = math.clamp(math.clamp((p23 - 59.6) / 2.3999999999999986, 0, 1), 0, 1)

        return v39 + Vector3.new(-8, -6, 0) * (v44 * v44 * (3 - v44 * 2))
    end

    if p23 < 63 then
        local v47 = math.clamp(math.clamp((p23 - 62) / 1, 0, 1), 0, 1)

        return (Vector3.new(-66, -6, 0)):Lerp(Vector3.new(-58, 0, 0), v47 * v47 * (3 - v47 * 2))
    end

    if p23 < 78 then
        local v48 = if p23 > 75 then new(math.sin(p23 * 40) * 0.8, math.sin(p23 * 37) * 0.8, 0) else new()

        return Vector3.new(-58, 0, 0) + v22 + v48
    end

    if p23 < 80.5 then
        local v55 = math.clamp(math.clamp((p23 - 78) / 2.5, 0, 1), 0, 1)

        return (Vector3.new(-58, 0, 0)):Lerp(Vector3.new(-58, -76, 0), v55 * v55 * v55)
    end

    if p23 < 84 then
        return Vector3.new(-58, -76, 0) + new(0, math.sin(p23 * 6) * 1.2, 0)
    end

    if p23 < 87 then
        local v60 = math.clamp(math.clamp((p23 - 84) / 3, 0, 1), 0, 1)

        return (Vector3.new(-58, -76, 0)):Lerp(Vector3.new(-95, 0, 0), v60 * v60 * v60 * (v60 * (v60 * 6 - 15) + 10))
    end

    if p23 < 100 then
        local v63 = math.clamp(math.clamp((p23 - 88) / 11, 0, 1), 0, 1)
        local v64 = v63 * v63 * (3 - v63 * 2) * 1.6 + 0.6

        return Vector3.new(-95, 0, 0) + new(math.sin(p23 * 31) * v64, math.sin(p23 * 27) * v64, 0)
    end

    if p23 < 101.5 then
        local v71 = math.clamp(math.clamp((p23 - 100) / 1.5, 0, 1), 0, 1)

        return (Vector3.new(-95, 0, 0)):Lerp(Vector3.new(-122, 5, 0), v71 * v71 * (3 - v71 * 2))
    end

    if p23 < 103 then
        local v74 = math.clamp(math.clamp((p23 - 101.5) / 1.5, 0, 1), 0, 1)

        return (Vector3.new(-122, 5, 0)):Lerp(Vector3.new(122, 9, 0), v74 * v74 * v74)
    end

    if p23 < 106 then
        local v77 = math.clamp(math.clamp((p23 - 103) / 3, 0, 1), 0, 1)

        return (hermite(Vector3.new(122, 9, 0), Vector3.new(120, 0, 0), Vector3.new(0, 6, 0), Vector3.new(-60, 0, 60), v77 * v77 * v77 * (v77 * (v77 * 6 - 15) + 10)))
    end

    return Vector3.new(0, 6, 0) + new(math.sin(p23 * 0.7) * 4, math.sin(p23 * 1.1) * 3, 0)
end

local function seraphLocal(p24) -- line: 166
    -- upvalues: new (copy), BATTLE (copy)
    if p24 < BATTLE.ARRIVE or p24 >= 103 then
        return nil
    end

    local v84 = new(0, math.sin(p24 * 1.1 + 1) * 3, 0)

    if p24 < BATTLE.CLASH then
        return Vector3.new(58, 6, 0) + v84
    end

    if p24 < 43 then
        local v87 = math.clamp(math.clamp((p24 - 42) / 1, 0, 1), 0, 1)

        return (Vector3.new(58, 6, 0)):Lerp(Vector3.new(72, 8, 0), v87 * v87 * (3 - v87 * 2))
    end

    if p24 < 45 then
        local v90 = math.clamp(math.clamp((p24 - 43) / 2, 0, 1), 0, 1)

        return (Vector3.new(72, 8, 0)):Lerp(Vector3.new(38, 6, 0), v90 * v90 * v90)
    end

    if p24 < 50 then
        local v93 = 1 - math.clamp(math.clamp((p24 - 45) / 5, 0, 1), 0, 1)
        local v94 = 1 - v93 * v93 * v93

        return (Vector3.new(38, 6, 0)):Lerp(Vector3.new(58, 6, 0), v94) + Vector3.new(14, 8, 0) * math.sin(v94 * 3.141592653589793)
    end

    if p24 < 52 then
        local v99 = math.clamp(math.clamp((p24 - 50) / 2, 0, 1), 0, 1)

        return (Vector3.new(58, 6, 0)):Lerp(Vector3.new(52, 22, 0), v99 * v99 * (3 - v99 * 2))
    end

    if p24 < 62 then
        return Vector3.new(52, 22, 0) + v84
    end

    if p24 < 63 then
        local v102 = math.clamp(math.clamp((p24 - 62) / 1, 0, 1), 0, 1)

        return (Vector3.new(52, 22, 0)):Lerp(Vector3.new(58, 10, 0), v102 * v102 * (3 - v102 * 2))
    end

    if p24 < 72 then
        local v103 = Vector3.new(58, 10, 0) + v84

        if p24 > 69.6 then
            v103 += Vector3.new(9, 3, 0) * math.exp(-(p24 - 69.6) * 3)
        end

        return v103
    end

    if p24 < 75 then
        local v107 = math.clamp(math.clamp((p24 - 72) / 3, 0, 1), 0, 1)

        return (Vector3.new(58, 10, 0)):Lerp(Vector3.new(40, 70, 0), v107 * v107 * v107 * (v107 * (v107 * 6 - 15) + 10))
    end

    if p24 < 84 then
        return Vector3.new(40, 70, 0) + v84
    end

    if p24 < 87 then
        local v110 = math.clamp(math.clamp((p24 - 84) / 3, 0, 1), 0, 1)

        return (Vector3.new(40, 70, 0)):Lerp(Vector3.new(95, 10, 0), v110 * v110 * v110 * (v110 * (v110 * 6 - 15) + 10))
    end

    if p24 < 99 then
        local v113 = math.clamp(math.clamp((p24 - 88) / 11, 0, 1), 0, 1)
        local v114 = v113 * v113 * (3 - v113 * 2) * 1.4 + 0.6

        return Vector3.new(95, 10, 0) + new(math.sin(p24 * 29) * v114, math.sin(p24 * 33) * v114, 0)
    end

    if p24 < 100 then
        local v121 = 1 - math.clamp(math.clamp((p24 - 99) / 1, 0, 1), 0, 1)

        return (Vector3.new(95, 10, 0)):Lerp(Vector3.new(102, 12, 0), 1 - v121 * v121 * v121)
    end

    return Vector3.new(102, 12, 0) + new(0, math.sin(p24 * 2) * 2, 0)
end

function t1.Poses(p25, p26) -- line: 208
    -- upvalues: CosmicEvent (copy), new (copy), BATTLE (copy), ARENA (copy), v7 (copy), hermite (copy), khaosLocal (copy), seraphLocal (copy)
    local v124 = p25.battleAt - p25.start
    local v125 = 0.12 * (math.clamp(p26, BATTLE.FACE, BATTLE.CLASH) - BATTLE.FACE)
    local v126 = seraphLocal(p26)
    local v127

    if v126 then
        if p26 < BATTLE.FACE then
            local ARRIVE, FACE = BATTLE.ARRIVE, BATTLE.FACE
            local v130 = math.clamp(math.clamp((p26 - ARRIVE) / (FACE - ARRIVE), 0, 1), 0, 1)
            local v131 = v130 * v130 * v130 * (v130 * (v130 * 6 - 15) + 10)

            v127 = hermite(CosmicEvent.RIFT, Vector3.new(0, -260, 220), ARENA + CFrame.Angles(0, 0, 0):VectorToWorldSpace((Vector3.new(58, 6, 0))), Vector3.new(-60, -40, 0), v131)
        else
            v127 = if p26 < BATTLE.CLASH then ARENA + CFrame.Angles(0, v125, 0):VectorToWorldSpace(v126) else ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace(v126)
        end
    end

    if p26 < 3 then
        local v132 = p25.api.huntPose(v124 + p26)

        return v132, if v127 then CFrame.lookAt(v127, v132.Position) else nil, 1
    end

    local v133, v134

    if p26 < BATTLE.FACE then
        local v135 = p25.api.huntPose(v124 + 3)
        local FACE = BATTLE.FACE
        local v138 = math.clamp(math.clamp((p26 - 3) / (FACE - 3), 0, 1), 0, 1)
        local v139 = v138 * v138 * v138 * (v138 * (v138 * 6 - 15) + 10)
        local v140

        v133, v140 = hermite(v135.Position, v135.LookVector * 60, ARENA + CFrame.Angles(0, 0, 0):VectorToWorldSpace((Vector3.new(-58, 0, 0))), Vector3.new(0, 70, 0), v139)

        if v140.Magnitude > 1 then
            v134 = v140.Unit
        end
    elseif p26 < BATTLE.CLASH then
        local v141 = khaosLocal(p26)

        v134 = nil
        v133 = ARENA + CFrame.Angles(0, v125, 0):VectorToWorldSpace(v141)
    else
        if not (p26 < BATTLE.ASCEND) then
            local ASCEND = BATTLE.ASCEND
            local v142 = BATTLE.LEN - 1
            local v145 = math.clamp(math.clamp((p26 - ASCEND) / (v142 - ASCEND), 0, 1), 0, 1)
            local v146 = v145 * v145 * v145 * (v145 * (v145 * 6 - 15) + 10)
            local v147 = khaosLocal(BATTLE.ASCEND)
            local v151 = (ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace(v147)):Lerp(CosmicEvent.GIANT_POS, v146) + new(0, math.sin(v146 * 3.141592653589793) * 40, 0)
            local v152 = (Vector3.new(0, 0, 1)):Lerp(Vector3.new(0, -0.08, -1), v146)

            return CFrame.lookAt(v151, v151 + v152), nil, 1 + (CosmicEvent.GIANT_SCALE - 1) * v146
        end

        local v153 = khaosLocal(p26)

        v133 = ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace(v153)

        if p26 >= 101.5 and p26 < 103 then
            v134 = ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(1, 0, 0))) - ARENA
        elseif p26 >= 103 and p26 < 106 then
            local v154 = khaosLocal(p26 + 0.05)
            local v155 = ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace(v154)

            v134 = if (v155 - v133).Magnitude > 0.01 then (v155 - v133).Unit else nil
        else
            v134 = if p26 >= 106 then Vector3.new(0, 0, 1) else nil
        end
    end

    local v156

    if v134 then
        v156 = v134
    else
        local v157 = (v127 or ARENA) - v133

        v156 = if v157.Magnitude > 0.01 then v157.Unit else Vector3.new(1, 0, 0)
    end

    local v158 = CFrame.lookAt(v133, v133 + v156)

    if p26 >= 78 and p26 < 87 then
        v158 *= CFrame.Angles(math.sin(math.clamp((p26 - 78) / 9, 0, 1) * 3.141592653589793) * -0.25, 0, math.sin(math.clamp((p26 - 78) / 9, 0, 1) * 3.141592653589793) * 0.3)
    end

    return v158, if v127 then CFrame.lookAt(v127, v133) else nil, 1
end

function t1.KhaosPose(p27, p28) -- line: 274
    -- upvalues: t1 (copy)
    local v164, _, v165 = t1.Poses(p27, p28)

    return v164, v165
end

local function flash(p29, p30, p31, p32, p33, p34) -- line: 280
    -- upvalues: Debris (copy), TweenService (copy), new (copy), Neon (copy), part (copy)
    local v166 = part({
        Name = "Flash",
        Transparency = 0.05,
        Shape = Enum.PartType.Ball,
        Size = new(p32, p32, p32),
        Material = Neon,
        Color = p31
    })

    v166.Position = p30
    v166.Parent = p29
    TweenService:Create(v166, TweenInfo.new(p34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = new(p33, p33, p33)
    }):Play()
    Debris:AddItem(v166, p34 + 0.1)
end

local function ring(p35, p36, p37, p38, p39, p40, p41) -- line: 289
    -- upvalues: Debris (copy), TweenService (copy), new (copy), Neon (copy), part (copy)
    local v167 = part({
        Name = "Ring",
        Transparency = 0.1,
        Shape = Enum.PartType.Cylinder,
        Size = new(1.2, p39, p39),
        Material = Neon,
        Color = p38
    })

    v167.CFrame = CFrame.lookAt(p36, p36 + p37) * CFrame.Angles(0, 1.5707963267948966, 0)
    v167.Parent = p35
    TweenService:Create(v167, TweenInfo.new(p41, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = new(1.2, p40, p40)
    }):Play()
    Debris:AddItem(v167, p41 + 0.1)
end

local function sparks(p42, p43, p44, p45, p46, p47) -- line: 297
    -- upvalues: Debris (copy), v6 (copy), part (copy)
    local v168 = part({
        Name = "Sparks",
        Size = Vector3.new(4, 4, 4),
        Transparency = 1
    })

    v168.Position = p43

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v6, p44)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p47 or 3),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1.2)
    ParticleEmitter.Speed = NumberRange.new(p46 * 0.4, p46)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 2.5
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = v168
    v168.Parent = p42
    ParticleEmitter:Emit(p45)
    Debris:AddItem(v168, 1.6)
end

local function shake(p48, p49, p50) -- line: 316
    local fight = p48.fight

    fight.shake = math.max(fight.shake, p49)
    fight.shakeUntil = math.max(fight.shakeUntil, os.clock() + p50)
    fight.shakeTime = p50
end

local function impact(p51, p52, p53, p54) -- line: 323
    -- upvalues: CurrentCamera (copy), v6 (copy), flash (copy), ring (copy), sparks (copy)
    local folder = p51.fight.folder

    flash(folder, p52, v6, p54 * 6, p54 * 46, 0.45)
    flash(folder, p52, p53, p54 * 10, p54 * 80, 0.7)
    ring(folder, p52, (CurrentCamera.CFrame.Position - p52).Unit, p53, p54 * 10, p54 * 150, 0.6)
    sparks(folder, p52, p53, math.floor(p54 * 30), p54 * 60, p54 * 3)

    local v171 = p54 * 1.2
    local v172 = p54 * 0.3 + 0.5
    local fight = p51.fight

    fight.shake = math.max(fight.shake, v171)
    fight.shakeUntil = math.max(fight.shakeUntil, os.clock() + v172)
    fight.shakeTime = v172
end

local function sfx(p55, p56) -- line: 333
    -- upvalues: v8 (ref)
    v8.sound(p55, p56)
end

local function loadSeraphion(p57) -- line: 338
    -- upvalues: CosmicEvent (copy), FishModels (copy), fromRGB (copy), v4 (copy), v6 (copy), part (copy)
    task.spawn(function() -- line: 339
        -- upvalues: p57 (copy), CosmicEvent (copy), FishModels (copy), fromRGB (copy), v4 (copy), v6 (copy), part (copy)
        local Get = FishModels.Get
        local ok, result = pcall(Get, "seraphion", 1, 1, 90)

        if ok and result then
            if p57.fight then
                local _, BoundingBox = result:GetBoundingBox()

                result:ScaleTo(result:GetScale() * CosmicEvent.SERAPHION_LENGTH / math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z, 1))

                for _, descendant in ipairs(result:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false
                        descendant.CanQuery = false
                        descendant.CanTouch = false
                    end
                end

                local BoundingBox2, BoundingBox3 = result:GetBoundingBox()
                local v175 = result:GetPivot():ToObjectSpace(BoundingBox2)
                local v176 = part({
                    Name = "Aura",
                    Transparency = 1,
                    Size = BoundingBox3 * 0.6
                })

                v176.CFrame = BoundingBox2

                local PointLight = Instance.new("PointLight")

                PointLight.Color = fromRGB(255, 220, 140)
                PointLight.Range = 60
                PointLight.Brightness = 3
                PointLight.Shadows = false
                PointLight.Parent = v176

                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                ParticleEmitter.Color = ColorSequence.new(v6, v4)
                ParticleEmitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 2.4),
                    NumberSequenceKeypoint.new(1, 0)
                })
                ParticleEmitter.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(1, 1)
                })
                ParticleEmitter.LightEmission = 1
                ParticleEmitter.Lifetime = NumberRange.new(1.2, 2.4)
                ParticleEmitter.Speed = NumberRange.new(0.5, 3)
                ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
                ParticleEmitter.Acceleration = Vector3.new(0, -3, 0)
                ParticleEmitter.Rate = 60
                ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
                ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
                ParticleEmitter.LockedToPart = false
                ParticleEmitter.Parent = v176
                v176.Parent = result
                result.Name = "Seraphion"
                result:PivotTo(CFrame.new(0, -500, 0))
                result.Parent = p57.fight.folder
                p57.fight.seraphOffset = v175
                p57.fight.seraph = result
            else
                result:Destroy()
            end
        end
    end)
end

local function buildRift(p58) -- line: 392
    -- upvalues: CosmicEvent (copy), fromRGB (copy), new (copy), Neon (copy), v5 (copy), part (copy)
    local v177 = Random.new(p58.seed + 11)
    local Folder = Instance.new("Folder")

    Folder.Name = "Rift"

    local t3 = {}

    for i = 1, 9 do
        local v178 = i / 9 * 3.141592653589793 * 2 + v177:NextNumber(-0.25, 0.25)
        local v181 = new(math.cos(v178), math.sin(v178) * 0.8, 0)
        local v182 = CosmicEvent.RIFT

        for j = 1, v177:NextInteger(5, 8) do
            local v183 = v177:NextNumber(22, 40)
            local v186 = v182 + (v181 + new(v177:NextNumber(-0.5, 0.5), v177:NextNumber(-0.5, 0.5), 0)).Unit * v183
            local v187 = math.max(8 - j * 0.8, 3)
            local v189 = part({
                Name = "Crack",
                Transparency = 1,
                Size = new(v187, v187, (v186 - v182).Magnitude + v187 * 0.5),
                Material = Neon,
                Color = fromRGB(255, 236, 170)
            })

            v189.CFrame = CFrame.lookAt((v182 + v186) / 2, v186)
            v182 = v186
            v189.Parent = Folder
            table.insert(t3, {
                part = v189,
                order = j + v177:NextNumber(0, 0.6)
            })
        end
    end

    local v190 = part({
        Name = "Tear",
        Size = Vector3.new(2, 4, 4),
        Transparency = 1,
        Shape = Enum.PartType.Cylinder,
        Material = Neon,
        Color = fromRGB(255, 248, 220)
    })

    v190.CFrame = CFrame.new(CosmicEvent.RIFT) * CFrame.Angles(0, 1.5707963267948966, 0)
    v190.Parent = Folder

    local v191 = part({
        Name = "Halo",
        Size = Vector3.new(1, 8, 8),
        Transparency = 1,
        Shape = Enum.PartType.Cylinder,
        Material = Neon,
        Color = v5
    })

    v191.CFrame = v190.CFrame * CFrame.new(-1, 0, 0)
    v191.Parent = Folder
    Folder.Parent = p58.fight.folder

    return {
        segs = t3,
        tear = v190,
        halo = v191
    }
end

local function setRift(p59, p60, p61) -- line: 423
    -- upvalues: new (copy)
    local v192 = p60 * 9

    for _, v193 in ipairs(p59.segs) do
        local v194 = if p60 > 0 and v193.order <= v192 then math.max(0, math.noise(p61 * 7, v193.order)) * 0.3 + 0.05 else 1

        if v193.part.Transparency ~= v194 then
            v193.part.Transparency = v194
        end
    end

    local v196 = p60 * 120 + 6

    p59.tear.Size = new(2, v196 * 0.75, v196)
    p59.tear.Transparency = p60 > 0.01 and 0.05 or 1
    p59.halo.Size = new(1, v196 * 0.95 + math.sin(p61 * 3) * 6, v196 * 1.25 + math.sin(p61 * 3) * 6)
    p59.halo.Transparency = p60 > 0.01 and 0.45 or 1
end

local function fishPicture(p62, p63, p64) -- line: 440
    -- upvalues: FishModels (copy), UIKit (copy)
    local v204 = UIKit.frame(p62, {
        Name = "Picture",
        Transparency = 1,
        ZIndex = 32,
        Size = UDim2.fromOffset(300, 220)
    })

    local function v205() -- line: 442
        -- upvalues: p63 (copy), p64 (copy), v204 (copy), FishModels (copy)
        local v206 = FishModels.Picture(v204, p63, 1, false)

        if v206 and p64 then
            v206.Rotation = 0
        end
    end

    pcall(v205)

    return v204
end

local function buildScreens() -- line: 451
    -- upvalues: UserInputService (copy), CosmicEvent (copy), UIKit (copy), Pad (copy), fromRGB (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v8 (ref), gui (ref), t2 (copy), v9 (ref), fishPicture (copy)
    local v207 = UIKit.frame(gui, {
        Name = "Versus",
        Transparency = 1,
        ZIndex = 30,
        Size = UDim2.fromScale(1, 1)
    })

    v207.Visible = false

    local v208 = UIKit.frame(v207, {
        Name = "Left",
        ZIndex = 30,
        GradientRotation = 0,
        Size = UDim2.new(0.5, 0, 0, 300),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = v2,
        Color2 = fromRGB(40, 10, 90)
    })
    local v209 = UIKit.frame(v207, {
        Name = "Right",
        ZIndex = 30,
        GradientRotation = 0,
        Size = UDim2.new(0.5, 0, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Color = fromRGB(110, 70, 10),
        Color2 = v4
    })
    local v210 = fishPicture(v208, "khaos", false)

    v210.Position = UDim2.new(1, -330, 0.5, 0)
    v210.AnchorPoint = Vector2.new(0, 0.5)

    local v211 = fishPicture(v209, "seraphion", true)

    v211.Position = UDim2.new(0, 30, 0.5, 0)
    v211.AnchorPoint = Vector2.new(0, 0.5)

    local v212 = UIKit.text(v208, {
        Name = "Name",
        Text = "KHAOS",
        TextSize = 120,
        Stroke = 8,
        ZIndex = 33,
        Size = UDim2.new(1, -380, 1, 0),
        Position = UDim2.fromOffset(40, 0),
        XAlign = Enum.TextXAlignment.Left
    })

    v212.FontFace = v1
    UIKit.gradient(v212, fromRGB(255, 255, 255), fromRGB(200, 150, 255))

    local v213 = UIKit.text(v209, {
        Name = "Name",
        Text = "SERAPHION",
        TextSize = 104,
        Stroke = 8,
        ZIndex = 33,
        Size = UDim2.new(1, -380, 1, 0),
        Position = UDim2.new(1, -40, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right
    })

    v213.FontFace = v1
    UIKit.gradient(v213, fromRGB(255, 255, 255), fromRGB(255, 214, 110))

    local v214 = UIKit.text(v207, {
        Name = "VS",
        Text = "VS",
        TextSize = 200,
        Stroke = 12,
        ZIndex = 36,
        Size = UDim2.fromOffset(400, 220),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    v214.FontFace = v1
    UIKit.gradient(v214, fromRGB(255, 255, 255), fromRGB(255, 120, 120))
    t2.vs = {
        root = v207,
        left = v208,
        right = v209,
        text = v214
    }

    local v215 = UIKit.frame(gui, {
        Name = "FightBars",
        Transparency = 1,
        ZIndex = 20,
        Size = UDim2.fromOffset(1240, 92),
        Position = UDim2.new(0.5, 0, 0, 14),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    v215.Visible = false

    local function bar(p65, p66, p67, p68) -- line: 477
        -- upvalues: v215 (copy), UIKit (copy), fromRGB (copy), v1 (copy)
        local v216 = UIKit.frame(v215, {
            Corner = 12,
            Stroke = 5,
            ZIndex = 20,
            Name = p66,
            Size = UDim2.fromOffset(540, 40),
            Position = UDim2.new(0.5, p65 * 70, 0, 44),
            AnchorPoint = Vector2.new(p65 < 0 and 1 or 0, 0),
            Color = fromRGB(16, 12, 30)
        })
        local v217 = UIKit.frame(v216, {
            Name = "Fill",
            Corner = 12,
            ZIndex = 21,
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(p65 < 0 and 1 or 0, 0),
            AnchorPoint = Vector2.new(p65 < 0 and 1 or 0, 0),
            Color = p67,
            Color2 = p68
        })
        local v218 = UIKit.frame(v216, {
            Name = "Ghost",
            Transparency = 0.35,
            Corner = 12,
            ZIndex = 20,
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(p65 < 0 and 1 or 0, 0),
            AnchorPoint = Vector2.new(p65 < 0 and 1 or 0, 0),
            Color = fromRGB(255, 255, 255)
        })
        local v219 = UIKit.text(v215, {
            TextSize = 40,
            Stroke = 5,
            ZIndex = 22,
            Name = p66 .. "Name",
            Text = p66,
            Size = UDim2.fromOffset(540, 42),
            Position = UDim2.new(0.5, p65 * 70, 0, 0),
            AnchorPoint = Vector2.new(p65 < 0 and 1 or 0, 0),
            XAlign = if p65 < 0 then Enum.TextXAlignment.Right else Enum.TextXAlignment.Left
        })

        v219.FontFace = v1
        UIKit.gradient(v219, fromRGB(255, 255, 255), p67)

        return {
            fill = v217,
            ghost = v218,
            holder = v216
        }
    end

    local v220 = bar(-1, "KHAOS", v2, v3)
    local v221 = bar(1, "SERAPHION", v4, v5)
    local v222 = UIKit.text(v215, {
        Name = "VS",
        Text = "VS",
        TextSize = 54,
        Stroke = 6,
        ZIndex = 23,
        Size = UDim2.fromOffset(120, 70),
        Position = UDim2.new(0.5, 0, 0, 22),
        AnchorPoint = Vector2.new(0.5, 0)
    })

    v222.FontFace = v1
    UIKit.gradient(v222, fromRGB(255, 255, 255), fromRGB(255, 120, 120))
    t2.bars = {
        kShown = 100,
        sShown = 100,
        root = v215,
        k = v220,
        s = v221
    }

    local v223 = UIKit.frame(gui, {
        Name = "BetPanel",
        Corner = 26,
        Stroke = 6,
        ZIndex = 24,
        Size = UDim2.fromOffset(940, 300),
        Position = UDim2.new(0.5, 0, 1, -24),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = fromRGB(40, 24, 80),
        Color2 = fromRGB(14, 8, 34)
    })

    UIKit.dress(v223, 26, fromRGB(220, 190, 255), 24)
    v223.Visible = false

    local v224 = UIKit.text(v223, {
        Name = "Title",
        Text = "WHO WILL WIN?  PLACE YOUR BET!",
        TextSize = 46,
        Stroke = 5,
        ZIndex = 26,
        Size = UDim2.new(1, -40, 0, 54),
        Position = UDim2.fromOffset(20, 10)
    })

    v224.FontFace = v1
    UIKit.gradient(v224, fromRGB(255, 255, 255), fromRGB(255, 220, 140))

    local BET_PRIZE = CosmicEvent.BET_PRIZE

    UIKit.text(v223, {
        Name = "Prize",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 26,
        Text = ("Bet right to win %d Lucky Casts + a Cosmic Potion!"):format(BET_PRIZE.lucky),
        Size = UDim2.new(1, -40, 0, 28),
        Position = UDim2.fromOffset(20, 64),
        Color = fromRGB(220, 210, 255)
    })

    local function betButton(p69, p70, p71, p72, p73) -- line: 502
        -- upvalues: v223 (copy), UIKit (copy), fromRGB (copy), v1 (copy), v8 (ref)
        local v225, v226 = UIKit.button(v223, {
            Corner = 22,
            Stroke = 6,
            TextStroke = 5,
            ZIndex = 26,
            Name = p70,
            Text = p71,
            Size = UDim2.fromOffset(420, 104),
            Position = UDim2.new(0.5, p69 * 12, 0, 102),
            AnchorPoint = Vector2.new(p69 < 0 and 1 or 0, 0),
            Color = p72,
            Color2 = p73,
            OnClick = function() -- OnClick | line: 503
                -- upvalues: p70 (copy), v8 (ref)
                if v8 and v8.remote then
                    v8.remote:FireServer("bet", p70)
                end
            end
        })

        v226.FontFace = v1
        v226.TextSize = 50

        local v227 = UIKit.text(v225, {
            Name = "Mine",
            Text = "YOUR BET",
            TextSize = 22,
            Stroke = 4,
            ZIndex = 29,
            Size = UDim2.fromOffset(160, 28),
            Position = UDim2.new(0.5, 0, 0, -16),
            AnchorPoint = Vector2.new(0.5, 0),
            Color = fromRGB(255, 240, 150)
        })

        v227.Visible = false

        return v225, v227
    end

    local v228, v229 = betButton(-1, "khaos", "KHAOS", v2, v3)
    local v230, v231 = betButton(1, "seraphion", "SERAPHION", v4, v5)
    local v232 = UIKit.frame(v223, {
        Name = "Split",
        Corner = 13,
        Stroke = 4,
        ZIndex = 26,
        Size = UDim2.fromOffset(852, 26),
        Position = UDim2.new(0.5, 0, 0, 220),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = v5
    })

    t2.bet = {
        open = false,
        root = v223,
        k = v228,
        s = v230,
        kTag = v229,
        sTag = v231,
        splitK = UIKit.frame(v232, {
            Name = "Khaos",
            Corner = 13,
            ZIndex = 27,
            Size = UDim2.fromScale(0.5, 1),
            Color = v2,
            Color2 = v3
        }),
        kPct = UIKit.text(v232, {
            Name = "KPct",
            Text = "",
            TextSize = 22,
            Stroke = 3,
            ZIndex = 28,
            Size = UDim2.fromOffset(300, 26),
            Position = UDim2.fromOffset(12, 0),
            XAlign = Enum.TextXAlignment.Left
        }),
        sPct = UIKit.text(v232, {
            Name = "SPct",
            Text = "",
            TextSize = 22,
            Stroke = 3,
            ZIndex = 28,
            Size = UDim2.fromOffset(300, 26),
            Position = UDim2.new(1, -12, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            XAlign = Enum.TextXAlignment.Right
        }),
        countdown = UIKit.text(v223, {
            Name = "Countdown",
            Text = "",
            TextSize = 26,
            Stroke = 3,
            ZIndex = 26,
            Size = UDim2.new(1, -40, 0, 30),
            Position = UDim2.fromOffset(20, 254),
            Color = fromRGB(255, 230, 150)
        })
    }

    local v237 = UIKit.frame(gui, {
        Name = "BetResult",
        Corner = 24,
        Stroke = 6,
        ZIndex = 34,
        Size = UDim2.fromOffset(820, 150),
        Position = UDim2.new(0.5, 0, 0.68, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(40, 24, 80),
        Color2 = fromRGB(14, 8, 34)
    })

    UIKit.dress(v237, 24, fromRGB(220, 190, 255), 34)
    v237.Visible = false

    local v238 = UIKit.text(v237, {
        Name = "Big",
        Text = "",
        TextSize = 56,
        Stroke = 6,
        ZIndex = 36,
        Size = UDim2.new(1, -40, 0, 66),
        Position = UDim2.fromOffset(20, 14)
    })

    v238.FontFace = v1

    local v239 = UIKit.text(v237, {
        Name = "Small",
        Text = "",
        TextSize = 28,
        Stroke = 3,
        ZIndex = 36,
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.fromOffset(20, 84),
        Color = fromRGB(220, 210, 255)
    })

    v239.TextWrapped = true
    t2.result = {
        root = v237,
        big = v238,
        small = v239
    }

    local v240, v241 = UIKit.button(gui, {
        Name = "FightCamera",
        Text = "FREE CAMERA",
        Corner = 33,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 26,
        Size = UDim2.fromOffset(250, 66),
        Position = UDim2.new(1, -30, 1, -30),
        AnchorPoint = Vector2.new(1, 1),
        Color = fromRGB(70, 76, 110),
        Color2 = fromRGB(34, 36, 60),
        OnClick = function() -- OnClick | line: 535
            -- upvalues: v9 (ref)
            v9 = not v9
        end
    })

    v240.Visible = false
    Pad.IconBeside(v241, Enum.KeyCode.ButtonY, 34)
    t2.cam = {
        root = v240,
        label = v241
    }
    UserInputService.InputBegan:Connect(function(p74) -- line: 542
        -- upvalues: UIKit (copy), t2 (copy), v9 (ref)
        if p74.KeyCode == Enum.KeyCode.ButtonY and t2.cam.root.Visible then
            v9 = not v9
            UIKit.sound("Click")
        end
    end)
end

local function refreshBets() -- line: 550
    -- upvalues: t1 (copy), fromRGB (copy), t2 (copy), n1 (ref), n2 (ref)
    local v242 = n1 + n2
    local v243 = if v242 > 0 then n1 / v242 else 0.5

    t2.bet.splitK.Size = UDim2.fromScale(math.clamp(v243, 0.02, 0.98), 1)

    local kPct = t2.bet.kPct

    if v242 > 0 then
        kPct.Text = ("KHAOS %d%%"):format((math.floor(v243 * 100 + 0.5)))
    else
        kPct.Text = "KHAOS"
    end

    local sPct = t2.bet.sPct

    if v242 > 0 then
        sPct.Text = ("%d%% SERAPHION"):format((math.floor((1 - v243) * 100 + 0.5)))
    else
        sPct.Text = "SERAPHION"
    end

    t2.bet.kTag.Visible = t1.MyBet == "khaos"
    t2.bet.sTag.Visible = t1.MyBet == "seraphion"

    local UIStroke = t2.bet.k:FindFirstChildOfClass("UIStroke")
    local UIStroke2 = t2.bet.s:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        if t1.MyBet == "khaos" then
            UIStroke.Color = fromRGB(255, 245, 170)
        else
            UIStroke.Color = fromRGB(14, 14, 22)
        end

        UIStroke.Thickness = t1.MyBet == "khaos" and 9 or 6
    end

    if not UIStroke2 then
        return
    end

    if t1.MyBet == "seraphion" then
        UIStroke2.Color = fromRGB(255, 245, 170)
    else
        UIStroke2.Color = fromRGB(14, 14, 22)
    end

    UIStroke2.Thickness = t1.MyBet == "seraphion" and 9 or 6
end

function t1.OnBets(p75, p76) -- line: 570
    -- upvalues: t2 (copy), n1 (ref), n2 (ref), refreshBets (copy)
    local v246 = tonumber(p75) or 0
    local v247 = tonumber(p76) or 0

    n1 = v246
    n2 = v247

    if t2.bet then
        refreshBets()
    end
end

function t1.OnMyBet(p77) -- line: 577
    -- upvalues: UIKit (copy), t1 (copy), t2 (copy), refreshBets (copy)
    t1.MyBet = p77

    if t2.bet then
        refreshBets()
        UIKit.pop(if p77 == "khaos" then t2.bet.k else t2.bet.s, 1.12)
    end
end

function t1.OnResult(p78, p79) -- line: 585
    -- upvalues: UIKit (copy), t1 (copy), fromRGB (copy), v6 (copy), v8 (ref), t2 (copy)
    t1.BetResult = p78

    local v248, v249

    if p78 == "none" then
        v249 = true
    elseif t2.result then
        v248 = p78 == "won"
        v249 = false
    else
        v249 = true
    end

    if v249 then
        return
    end

    t2.result.big.Text = v248 and "YOU WON THE BET!" or "SERAPHION LOST..."

    local v250 = t2.result.big:FindFirstChildOfClass("UIGradient") or UIKit.gradient(t2.result.big, v6, v6)

    if v248 then
        v250.Color = ColorSequence.new(fromRGB(255, 250, 170), fromRGB(255, 190, 60))
    else
        v250.Color = ColorSequence.new(fromRGB(230, 220, 255), fromRGB(160, 150, 200))
    end

    local small = t2.result.small

    if not v248 or type(p79) ~= "table" then
        small.Text = "Your bet was on Seraphion. Better luck next time!"
    else
        small.Text = ("+%d Lucky Casts and a Cosmic Potion: x2 everything for %d:%02d"):format(p79.lucky or 0, math.floor((p79.seconds or 0) / 60), (p79.seconds or 0) % 60)
    end

    t2.result.root.Visible = true
    UIKit.pop(t2.result.root, 0.6)

    local v253 = v248 and "ToastGold" or "ToastError"

    v8.sound(v253, nil)

    if v248 then
        v8.sound("Coins", nil)
    end

    task.delay(5, function() -- line: 603
        -- upvalues: UIKit (copy), t2 (copy)
        if t2.result.root.Visible then
            UIKit.tween(UIKit.scaleOf(t2.result.root), 0.2, {
                Scale = 0
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.22, function() -- line: 606
                -- upvalues: t2 (copy)
                t2.result.root.Visible = false
            end)
        end
    end)
end

function t1.Reset() -- line: 615
    -- upvalues: t1 (copy), t2 (copy), v9 (ref), n1 (ref), n2 (ref), refreshBets (copy)
    t1.Fired = {}
    t1.MyBet = nil
    t1.BetResult = nil
    n1 = 0
    n2 = 0
    v9 = true

    if t2.bet then
        refreshBets()
    end
end

function t1.Begin(p80, p81) -- line: 626
    -- upvalues: CosmicEvent (copy), FishModels (copy), fromRGB (copy), v4 (copy), v6 (copy), v8 (ref), gui (ref), t2 (copy), part (copy), buildRift (copy), buildScreens (copy), refreshBets (copy)
    v8 = p81
    gui = p81.gui

    if not t2.vs then
        buildScreens()
    end

    refreshBets()

    local Folder = Instance.new("Folder")

    Folder.Name = "CosmicBattle"
    Folder.Parent = p80.folder
    p80.fight = {
        shake = 0,
        shakeUntil = 0,
        shakeTime = 1,
        seraph = nil,
        rift = nil,
        watching = false,
        shards = nil,
        folder = Folder,
        fired = {},
        projectiles = {}
    }
    p80.fight.rift = buildRift(p80)
    task.spawn(function() -- line: 339
        -- upvalues: p80 (copy), CosmicEvent (copy), FishModels (copy), fromRGB (copy), v4 (copy), v6 (copy), part (copy)
        local Get = FishModels.Get
        local ok, result = pcall(Get, "seraphion", 1, 1, 90)

        if ok and result then
            if p80.fight then
                local _, BoundingBox = result:GetBoundingBox()

                result:ScaleTo(result:GetScale() * CosmicEvent.SERAPHION_LENGTH / math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z, 1))

                for _, descendant in ipairs(result:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false
                        descendant.CanQuery = false
                        descendant.CanTouch = false
                    end
                end

                local BoundingBox2, BoundingBox3 = result:GetBoundingBox()
                local v255 = result:GetPivot():ToObjectSpace(BoundingBox2)
                local v256 = part({
                    Name = "Aura",
                    Transparency = 1,
                    Size = BoundingBox3 * 0.6
                })

                v256.CFrame = BoundingBox2

                local PointLight = Instance.new("PointLight")

                PointLight.Color = fromRGB(255, 220, 140)
                PointLight.Range = 60
                PointLight.Brightness = 3
                PointLight.Shadows = false
                PointLight.Parent = v256

                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                ParticleEmitter.Color = ColorSequence.new(v6, v4)
                ParticleEmitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 2.4),
                    NumberSequenceKeypoint.new(1, 0)
                })
                ParticleEmitter.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(1, 1)
                })
                ParticleEmitter.LightEmission = 1
                ParticleEmitter.Lifetime = NumberRange.new(1.2, 2.4)
                ParticleEmitter.Speed = NumberRange.new(0.5, 3)
                ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
                ParticleEmitter.Acceleration = Vector3.new(0, -3, 0)
                ParticleEmitter.Rate = 60
                ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
                ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
                ParticleEmitter.LockedToPart = false
                ParticleEmitter.Parent = v256
                v256.Parent = result
                result.Name = "Seraphion"
                result:PivotTo(CFrame.new(0, -500, 0))
                result.Parent = p80.fight.folder
                p80.fight.seraphOffset = v255
                p80.fight.seraph = result
            else
                result:Destroy()
            end
        end
    end)
end

local function stopWatching(p82) -- line: 641
    -- upvalues: HUD (copy), MoveLock (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy)
    local fight = p82.fight

    if not (fight and fight.watching) then
        return
    end

    fight.watching = false
    t1.Watching = false

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    CurrentCamera.CameraType = Enum.CameraType.Custom

    if Humanoid then
        CurrentCamera.CameraSubject = Humanoid
    end

    CurrentCamera.FieldOfView = 70
    MoveLock.Free("battle")

    if HUD.GetMode() == "cutscene" then
        HUD.SetMode("normal")
    end
end

function t1.Finish(p83) -- line: 660
    -- upvalues: Pad (copy), t2 (copy), stopWatching (copy)
    if p83.fight then
        stopWatching(p83)
        p83.fight.folder:Destroy()
        p83.fight = nil
    end

    if t2.vs then
        t2.vs.root.Visible = false
        t2.bars.root.Visible = false
        t2.bet.root.Visible = false
        t2.cam.root.Visible = false
        Pad.Deselect(t2.bet.root)
    end
end

local function shot(_, p85, p86, p87) -- line: 677
    -- upvalues: CosmicEvent (copy), new (copy), BATTLE (copy), ARENA (copy), v7 (copy)
    local Position = p86.Position
    local v257 = if p87 then p87.Position else ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(60, 10, 0)))

    if p85 < BATTLE.ARRIVE then
        local v259 = math.clamp(p85 / BATTLE.ARRIVE, 0, 1)
        local v260 = v259 * v259 * (3 - v259 * 2)

        return CFrame.lookAt((Vector3.new(0, 95, 360)):Lerp(Vector3.new(0, 115, 300), v260), CosmicEvent.RIFT), 70 - v260 * 6
    end

    if p85 < BATTLE.FACE then
        return CFrame.lookAt(Vector3.new(110, 135, 320), v257:Lerp(Position, 0.25)), 66
    end

    if p85 < BATTLE.BET_OPEN then
        local v261 = 0.12 * (math.clamp(p85, BATTLE.FACE, BATTLE.CLASH) - BATTLE.FACE)

        return CFrame.lookAt(ARENA + CFrame.Angles(0, v261, 0):VectorToWorldSpace((Vector3.new(0, 30, 235))), ARENA), 64
    end

    if p85 < BATTLE.CLASH then
        local v262 = 0.12 * (math.clamp(p85, BATTLE.FACE, BATTLE.CLASH) - BATTLE.FACE) + 0.5 + 0.015 * (p85 - BATTLE.BET_OPEN)

        return CFrame.lookAt(ARENA + CFrame.Angles(0, v262, 0):VectorToWorldSpace((Vector3.new(0, 28, 220))), ARENA + Vector3.new(0, -8, 0)), 66
    end

    if p85 < 50 then
        local v263 = if p85 > 45 then math.exp(-(p85 - 45) * 3) * 10 else 0

        return CFrame.lookAt(ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(0, 12, 165))), ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(0, 0, 0)))), 70 - v263
    end

    if p85 < 62 then
        local Unit = (Position - v257).Unit
        local v265 = Unit:Cross((Vector3.new(0, 1, 0)))

        return CFrame.lookAt(v257 - Unit * 125 + Vector3.new(0, 32, 0) + v265 * 60, Position:Lerp(v257, 0.3)), 62
    end

    if p85 < 72 then
        local Unit = (v257 - Position).Unit
        local v266 = Unit:Cross((Vector3.new(0, 1, 0)))

        return CFrame.lookAt(Position - Unit * 135 + Vector3.new(0, 32, 0) - v266 * 60, v257:Lerp(Position, 0.3)), 64
    end

    if p85 < 84 then
        return CFrame.lookAt(ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(-10, -30, 210))), ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(-20, 10, 0)))), 76
    end

    if p85 < 100 then
        local v269 = math.clamp(math.clamp((p85 - 87) / 12, 0, 1), 0, 1)
        local v270 = v269 * v269 * (3 - v269 * 2)
        local v271 = Position:Lerp(v257, 0.5)
        local lookAt = CFrame.lookAt
        local v274 = new(v270 * -30, 18, 250 - v270 * 50)

        return lookAt(ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace(v274), v271), 68
    end

    if p85 < 103 then
        local lookAt = CFrame.lookAt
        local v275 = ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(-10, 30, 250)))
        local v278 = math.clamp(math.clamp((p85 - 101.5) / 1.5, 0, 1), 0, 1)

        return lookAt(v275, Position:Lerp(v257, v278 * v278 * (3 - v278 * 2))), 72
    end

    if p85 < BATTLE.WIN then
        return CFrame.lookAt(ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(40, 20, 200))), ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(40, 6, 0)))), 74
    end

    if p85 < BATTLE.ASCEND then
        return CFrame.lookAt(Position + p86.LookVector * 140 + Vector3.new(0, 16, 0), Position), 66
    end

    return CFrame.lookAt(Vector3.new(40, 24, 390), Position), 74
end

local t11 = {
    BATTLE.ARRIVE,
    BATTLE.FACE,
    BATTLE.BET_OPEN,
    BATTLE.CLASH,
    50, 62, 72, 84, 100, 103,
    BATTLE.WIN,
    BATTLE.ASCEND
}

local function filmed(p88, p89, p90, p91) -- line: 722
    -- upvalues: shot (copy), t11 (copy)
    local v279, v280 = shot(p88, p89, p90, p91)

    for _, v281 in ipairs(t11) do
        if v281 <= p89 and p89 < v281 + 0.6 then
            local v282, v283 = shot(p88, v281 - 0.001, p90, p91)
            local v285 = math.clamp((p89 - v281) / 0.6, 0, 1)
            local v286 = v285 * v285 * v285 * (v285 * (v285 * 6 - 15) + 10)

            return v282:Lerp(v279, v286), v283 + (v280 - v283) * v286
        end
    end

    return v279, v280
end

local function once(p92, p93, p94, p95, p96) -- line: 737
    -- upvalues: t1 (copy)
    if not (p95 <= p94) or p92.fight.fired[p93] then
        return
    end

    p92.fight.fired[p93] = true

    if p94 - p95 < 1.5 then
        t1.Fired[p93] = true

        local ok, result = pcall(p96)

        if not ok then
            warn("[CosmicBattle] " .. p93 .. ": " .. tostring(result))
        end
    end
end

local function projectile(p97, p98, p99, p100, p101, p102, p103) -- line: 750
    table.insert(p97.fight.projectiles, {
        part = nil,
        kind = p98,
        from = p99,
        to = p100,
        t0 = p101,
        travel = p102,
        onHit = p103
    })
end

local function stepProjectiles(p104, p105) -- line: 754
    -- upvalues: fromRGB (copy), new (copy), Neon (copy), v2 (copy), v4 (copy), v6 (copy), part (copy)
    local fight = p104.fight

    for i = #fight.projectiles, 1, -1 do
        local v287 = fight.projectiles[i]
        local v288 = (p105 - v287.t0) / v287.travel

        if v288 >= 1 then
            if v287.part then
                v287.part:Destroy()
            end

            table.remove(fight.projectiles, i)

            if v288 < 2 then
                local onHit, to = v287.onHit, v287.to

                pcall(onHit, to())
            end
        elseif v288 >= 0 then
            if not v287.part then
                if v287.kind == "lance" then
                    v287.part = part({
                        Name = "Lance",
                        Size = Vector3.new(2.6, 2.6, 30),
                        Material = Neon,
                        Color = fromRGB(255, 244, 200)
                    })
                else
                    v287.part = part({
                        Name = "Orb",
                        Size = Vector3.new(10, 10, 10),
                        Shape = Enum.PartType.Ball,
                        Material = Neon,
                        Color = fromRGB(160, 80, 255)
                    })
                end

                local PointLight = Instance.new("PointLight")

                if v287.kind == "lance" then
                    PointLight.Color = v4
                else
                    PointLight.Color = v2
                end

                PointLight.Range = 30
                PointLight.Brightness = 3
                PointLight.Shadows = false
                PointLight.Parent = v287.part

                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                ParticleEmitter.Color = ColorSequence.new(v6, if v287.kind == "lance" then v4 else v2)
                ParticleEmitter.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 2.2),
                    NumberSequenceKeypoint.new(1, 0)
                })
                ParticleEmitter.LightEmission = 1
                ParticleEmitter.Lifetime = NumberRange.new(0.3, 0.6)
                ParticleEmitter.Speed = NumberRange.new(0, 2)
                ParticleEmitter.Rate = 90
                ParticleEmitter.LockedToPart = false
                ParticleEmitter.Parent = v287.part
                v287.part.Parent = fight.folder
            end

            local v290 = v287.from()
            local v291 = v287.to()
            local v292

            if v287.kind == "lance" then
                v292 = v288
            else
                local v293 = math.clamp(v288, 0, 1)

                v292 = v293 * v293 * (3 - v293 * 2)
            end

            local v294 = v290:Lerp(v291, v292)

            if v287.kind == "orb" then
                v294 += new(0, math.sin(v288 * 3.141592653589793) * 14, 0)
            end

            v287.part.CFrame = CFrame.lookAt(v294, v291)
        end
    end
end

local function cardIt(p106, p107, p108, p109, p110, p111) -- line: 802
    -- upvalues: v8 (ref)
    v8.card(p106, p107, p108, p109, p110, p111)
end

local function mouthOf(p112, p113) -- line: 806
    -- upvalues: CosmicEvent (copy)
    return p112.Position + p112.LookVector * (CosmicEvent.KHAOS_LENGTH * p113 * 0.45)
end

function t1.Step(p114, p115, p116, p117) -- line: 811
    -- upvalues: Debris (copy), TweenService (copy), CosmicEvent (copy), FishModels (copy), UIKit (copy), HUD (copy), ScreenFx (copy), MoveLock (copy), Pad (copy), BuffHud (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), fromRGB (copy), new (copy), Neon (copy), BATTLE (copy), ARENA (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (ref), t2 (copy), v9 (ref), part (copy), flash (copy), ring (copy), sparks (copy), impact (copy), setRift (copy), refreshBets (copy), stopWatching (copy), filmed (copy), once (copy), stepProjectiles (copy)
    local fight = p114.fight

    if not fight then
        return
    end

    local elapsed = os.clock()
    local v297 = p115 >= 0 and p115 < BATTLE.LEN and p116 < 0
    local v298 = t1.Poses
    local v299 = BATTLE.LEN
    local v300, v301

    v298, v300, v301 = v298(p114, (math.clamp(p115, 0, v299)))

    if fight.seraph then
        if not v297 or not v300 then
            fight.seraph:PivotTo(CFrame.new(0, -500, 0))
        else
            fight.seraph:PivotTo(v300 * fight.seraphOffset:Inverse())

            local Animate = FishModels.Animate

            v299 = fight.seraph
            pcall(Animate, v299, elapsed, 6, 0.4)
        end
    end

    local v302, v303, v304, v305, v306

    if v297 then
        v299 = BATTLE.ARRIVE
        v304 = (p115 - 0) / (v299 - 0)
        v305 = math.clamp(v304, 0, 1)
        v304 = math.clamp(v305, 0, 1)

        local v307 = v304 * v304 * (3 - v304 * 2)
        local v308

        if p115 > 75 and p115 < 84 then
            v308 = (p115 - 75) / 3
            v306 = math.clamp(v308, 0, 1)
            v306 = math.clamp(v306, 0, 1)
            v299 = v306 * v306 * (3 - v306 * 2) * 0.25
            v306 = (p115 - 80) / 4
            v302 = math.clamp(v306, 0, 1)
            v302 = math.clamp(v302, 0, 1)
            v307 = v299 * (1 - v302 * v302 * (3 - v302 * 2)) + 1
        end

        v305 = (p115 - 104.6) / 0.7000000000000028
        v308 = math.clamp(v305, 0, 1)
        v308 = math.clamp(v308, 0, 1)
        v303 = v307 * (1 - v308 * v308 * (3 - v308 * 2))
    else
        v303 = 0
    end

    setRift(fight.rift, v303, p115)
    stepProjectiles(p114, p115)

    local v309, v310, v311, v312

    if v297 then
        local Position = v298.Position

        if v300 then
            v312 = v300.Position
        end

        local folder = fight.folder

        once(p114, "crack", p115, 0, function() -- line: 845
            -- upvalues: fromRGB (copy), v4 (copy), v8 (ref)
            v8.sound("DeepRumble", 0.7)
            v8.sound("OmenHit", 0.7)

            local v313 = fromRGB(255, 245, 210)

            v8.card("THE SKY IS SPLITTING...", v313, v4, 64, 2.4, 0.3)
        end)
        once(p114, "crack2", p115, 1.6, function() -- line: 850
            -- upvalues: p114 (copy), v8 (ref)
            v8.sound("GlassBoom", 0.8)

            local fight = p114.fight

            fight.shake = math.max(fight.shake, 0.6)
            fight.shakeUntil = math.max(fight.shakeUntil, os.clock() + 1.2)
            fight.shakeTime = 1.2
        end)
        once(p114, "crack3", p115, 3, function() -- line: 854
            -- upvalues: v8 (ref)
            v8.sound("EggCrack", 0.5)
            v8.sound("Riser", nil)
        end)
        v302 = BATTLE.ARRIVE
        once(p114, "arrive", p115, v302, function() -- line: 858
            -- upvalues: p114 (copy), folder (copy), CosmicEvent (copy), ScreenFx (copy), v6 (copy), v8 (ref), flash (copy)
            ScreenFx.Fade(1, 0.04, Color3.fromRGB(255, 246, 220))
            task.delay(0.1, ScreenFx.Fade, 0, 1.1)
            v8.sound("StingChoir", nil)
            v8.sound("SubBoom", nil)
            flash(folder, CosmicEvent.RIFT, v6, 20, 260, 0.9)

            local fight = p114.fight

            fight.shake = math.max(fight.shake, 1.4)
            fight.shakeUntil = math.max(fight.shakeUntil, os.clock() + 1)
            fight.shakeTime = 1
        end)
        once(p114, "arriveCard", p115, BATTLE.ARRIVE + 0.6, function() -- line: 866
            -- upvalues: fromRGB (copy), v4 (copy), v8 (ref)
            local v316 = fromRGB(255, 255, 255)

            v8.card("SERAPHION HAS AWAKENED", v316, v4, 92, 2.4, 0.3)
        end)
        once(p114, "rise", p115, 6.2, function() -- line: 869
            -- upvalues: Position (copy), new (copy), v8 (ref)
            v8.sound("DeepRoar", 0.8)
            v8.splash(new(Position.X, v8.level(), Position.Z), true)
        end)
        v302 = BATTLE.VS
        once(p114, "vs", p115, v302, function() -- line: 874
            -- upvalues: p114 (copy), UIKit (copy), v8 (ref), t2 (copy)
            v8.sound("SonicBoom", nil)
            v8.sound("StingHit", nil)

            local vs = t2.vs

            vs.root.Visible = true
            vs.left.Position = UDim2.new(-0.5, 0, 0.5, 0)
            vs.right.Position = UDim2.new(1, 0, 0.5, 0)
            UIKit.tween(vs.left, 0.32, {
                Position = UDim2.new(0, 0, 0.5, 0)
            }, Enum.EasingStyle.Back)
            UIKit.tween(vs.right, 0.32, {
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, Enum.EasingStyle.Back)

            local v318 = UIKit.scaleOf(vs.text)

            v318.Scale = 3
            vs.text.TextTransparency = 1
            task.delay(0.3, function() -- line: 886
                -- upvalues: vs (copy), v318 (copy), p114 (copy), UIKit (copy), v8 (ref)
                UIKit.tween(v318, 0.25, {
                    Scale = 1
                }, Enum.EasingStyle.Back)
                UIKit.tween(vs.text, 0.12, {
                    TextTransparency = 0
                })
                v8.sound("SubBoom", nil)

                local fight = p114.fight

                fight.shake = math.max(fight.shake, 1)
                fight.shakeUntil = math.max(fight.shakeUntil, os.clock() + 0.4)
                fight.shakeTime = 0.4
            end)
            task.delay(3.1, function() -- line: 892
                -- upvalues: vs (copy), UIKit (copy)
                UIKit.tween(vs.left, 0.25, {
                    Position = UDim2.new(-0.5, 0, 0.5, 0)
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                UIKit.tween(vs.right, 0.25, {
                    Position = UDim2.new(1, 0, 0.5, 0)
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                UIKit.tween(vs.text, 0.2, {
                    TextTransparency = 1
                })
                task.delay(0.3, function() -- line: 896
                    -- upvalues: vs (copy)
                    vs.root.Visible = false
                end)
            end)
        end)
        once(p114, "betOpen", p115, BATTLE.BET_OPEN, function() -- line: 902
            -- upvalues: v8 (ref)
            v8.sound("DrumRoll", nil)
        end)
        v304 = BATTLE.BET_OPEN <= p115 and p115 < BATTLE.BET_CLOSE

        if v304 ~= t2.bet.open then
            t2.bet.open = v304
            t2.bet.root.Visible = v304

            if v304 then
                refreshBets()
                UIKit.pop(t2.bet.root, 0.6)
                Pad.Select(t2.bet.k)
            else
                Pad.Deselect(t2.bet.root)
            end
        end

        if v304 then
            v306 = BATTLE.BET_CLOSE - p115
            v305 = math.max(0, v306)
            t2.bet.countdown.Text = ("Bets close in %d"):format((math.ceil(v305))) .. (t1.MyBet and "   -   you can still change your bet" or "")
        end

        once(p114, "fight", p115, BATTLE.CLASH, function() -- line: 922
            -- upvalues: fromRGB (copy), v8 (ref)
            v8.sound("StingHit", nil)
            v8.sound("Braam", nil)

            local v320 = fromRGB(255, 255, 255)
            local v321 = fromRGB(255, 120, 120)

            v8.card("FIGHT!", v320, v321, 140, 1.2, 0.3)
        end)

        local v322 = v312

        once(p114, "clash", p115, 45, function() -- line: 927
            -- upvalues: p114 (copy), Position (copy), v322 (copy), ScreenFx (copy), fromRGB (copy), v6 (copy), v8 (ref), impact (copy)
            impact(p114, Position:Lerp(v322 or Position, 0.5), fromRGB(255, 210, 255), 2.2)
            v8.sound("SubBoom", nil)
            v8.sound("GlassBoom", 0.7)
            ScreenFx.Fade(1, 0.03, v6)
            task.delay(0.06, ScreenFx.Fade, 0, 0.5)
        end)

        local v323

        for i = 0, 5 do
            local v324 = i * 1.5 + 51

            v323 = "lance" .. i
            once(p114, v323, p115, v324, function() -- line: 937
                -- upvalues: p114 (copy), v324 (copy), t1 (copy), ARENA (copy), v4 (copy), v8 (ref), impact (copy)
                v8.sound("Zap", 1.3)

                local function v325() -- line: 939
                    -- upvalues: p114 (copy), v324 (copy), t1 (copy), ARENA (copy)
                    local _, v326 = t1.Poses(p114, v324)

                    if v326 then
                        return v326.Position
                    end

                    return ARENA
                end

                local function v327() -- line: 942
                    -- upvalues: p114 (copy), v324 (copy), t1 (copy)
                    return t1.Poses(p114, v324 + 0.5).Position
                end

                local function v328(p118) -- line: 944
                    -- upvalues: p114 (copy), v4 (copy), v8 (ref), impact (copy)
                    impact(p114, p118, v4, 1)
                    v8.sound("SubBoom", 1.2)
                end

                table.insert(p114.fight.projectiles, {
                    kind = "lance",
                    travel = 0.5,
                    part = nil,
                    from = v325,
                    to = v327,
                    t0 = v324,
                    onHit = v328
                })
            end)
        end

        once(p114, "shield", p115, 62.5, function() -- line: 951
            -- upvalues: fight (copy), folder (copy), fromRGB (copy), v8 (ref), part (copy)
            v8.sound("StingSweep", nil)
            v8.sound("WindChime", nil)
            fight.shield = part({
                Name = "Shield",
                Size = Vector3.new(2, 2, 2),
                Shape = Enum.PartType.Ball,
                Material = Enum.Material.ForceField,
                Color = fromRGB(255, 220, 120)
            })
            fight.shield.Parent = folder
        end)

        local v329

        for i = 0, 7 do
            local v330 = i * 0.75 + 63

            v329 = "orb" .. i
            once(p114, v329, p115, v330, function() -- line: 959
                -- upvalues: p114 (copy), fight (copy), i (copy), v330 (copy), CosmicEvent (copy), t1 (copy), fromRGB (copy), ARENA (copy), v2 (copy), v6 (copy), v8 (ref), impact (copy)
                local v331 = i * 0.05 + 0.9

                v8.sound("DeepWhoosh", v331)

                local function v332() -- line: 961
                    -- upvalues: p114 (copy), v330 (copy), CosmicEvent (copy), t1 (copy)
                    local v333 = t1.Poses(p114, v330)

                    return v333.Position + v333.LookVector * (CosmicEvent.KHAOS_LENGTH * 1 * 0.45)
                end

                local function v334() -- line: 963
                    -- upvalues: p114 (copy), i (copy), v330 (copy), t1 (copy), ARENA (copy)
                    local v335, v336 = t1.Poses(p114, v330 + 0.7)
                    local v337 = if v336 then v336.Position else ARENA

                    if i < 7 then
                        return v337 + (v335.Position - v337).Unit * 40
                    end

                    return v337
                end

                local function v338(p119) -- line: 970
                    -- upvalues: p114 (copy), fight (copy), i (copy), fromRGB (copy), v2 (copy), v6 (copy), impact (copy)
                    impact(p114, p119, v2, i < 7 and 0.8 or 1.4)

                    if fight.shield then
                        fight.shield.Color = v6
                        task.delay(0.08, function() -- line: 974
                            -- upvalues: fight (copy), fromRGB (copy)
                            if fight.shield then
                                fight.shield.Color = fromRGB(255, 220, 120)
                            end
                        end)
                    end
                end

                table.insert(p114.fight.projectiles, {
                    kind = "orb",
                    travel = 0.7,
                    part = nil,
                    from = v332,
                    to = v334,
                    t0 = v330,
                    onHit = v338
                })
            end)
        end

        once(p114, "shieldBreak", p115, 69.2, function() -- line: 983
            -- upvalues: fight (copy), folder (copy), Debris (copy), TweenService (copy), v4 (copy), v8 (ref), sparks (copy)
            v8.sound("GlassBoom", nil)

            if fight.shield then
                local shield = fight.shield

                fight.shield = nil
                TweenService:Create(shield, TweenInfo.new(0.3), {
                    Transparency = 1,
                    Size = shield.Size * 1.5
                }):Play()
                Debris:AddItem(shield, 0.35)
                sparks(folder, shield.Position, v4, 60, 70, 4)
            end
        end)

        local countdown, pillar, v339

        if fight.shield and v312 then
            v306 = (p115 - 62.5) / 0.6000000000000014
            v309 = math.clamp(v306, 0, 1)
            v309 = math.clamp(v309, 0, 1)
            v305 = v309 * v309 * (3 - v309 * 2)
            countdown = fight.shield
            pillar = v305 * 84
            v339 = elapsed * 9
            countdown.Size = Vector3.new(1, 1, 1) * (pillar + math.sin(v339) * 2)
            fight.shield.Position = v312
        end

        once(p114, "pillarCharge", p115, 75, function() -- line: 999
            -- upvalues: fight (copy), folder (copy), Neon (copy), v4 (copy), v8 (ref), part (copy)
            v8.sound("TensionRiser", nil)
            v8.sound("StingChoir", 0.9)
            fight.target = part({
                Name = "PillarMark",
                Size = Vector3.new(1, 90, 90),
                Transparency = 0.4,
                Shape = Enum.PartType.Cylinder,
                Material = Neon,
                Color = v4
            })
            fight.target.Parent = folder
        end)

        local v340

        if fight.target then
            countdown = (p115 - 75) / 3
            v306 = math.clamp(countdown, 0, 1)
            fight.target.CFrame = CFrame.new(Position + Vector3.new(0, 40, 0)) * CFrame.Angles(0, elapsed, 1.5707963267948966)
            countdown = fight.target
            v340 = 110 - v306 * 70
            pillar = 110 - v306 * 70
            countdown.Size = new(1, v340, pillar)
            countdown = fight.target
            v323 = elapsed * 10
            pillar = math.sin(v323)
            countdown.Transparency = math.abs(pillar) * 0.3 + 0.25
        end

        once(p114, "pillar", p115, 78, function() -- line: 1011
            -- upvalues: p114 (copy), fight (copy), Position (copy), folder (copy), ScreenFx (copy), fromRGB (copy), Neon (copy), v4 (copy), v5 (copy), v8 (ref), part (copy), sparks (copy)
            if fight.target then
                fight.target:Destroy()
                fight.target = nil
            end

            v8.sound("Thunder", nil)
            v8.sound("SubBoom", nil)
            v8.sound("BraamCosmic", nil)
            ScreenFx.Fade(1, 0.03, Color3.fromRGB(255, 244, 210))
            task.delay(0.08, ScreenFx.Fade, 0, 0.8)
            fight.pillar = part({
                Name = "Pillar",
                Size = Vector3.new(600, 70, 70),
                Transparency = 0.05,
                Shape = Enum.PartType.Cylinder,
                Material = Neon,
                Color = fromRGB(255, 240, 190)
            })
            fight.pillarGlow = part({
                Name = "PillarGlow",
                Size = Vector3.new(600, 120, 120),
                Transparency = 0.6,
                Shape = Enum.PartType.Cylinder,
                Material = Neon,
                Color = v5
            })
            fight.pillar.Parent = folder
            fight.pillarGlow.Parent = folder

            local fight2 = p114.fight

            fight2.shake = math.max(fight2.shake, 2.4)
            fight2.shakeUntil = math.max(fight2.shakeUntil, os.clock() + 1.6)
            fight2.shakeTime = 1.6
            sparks(folder, Position, v4, 80, 90, 5)
        end)

        if fight.pillar then
            v306 = (p115 - 80.5) / 2.5
            v309 = math.clamp(v306, 0, 1)
            v309 = math.clamp(v309, 0, 1)
            v305 = v309 * v309 * (3 - v309 * 2)
            countdown = Position.Y + 500
            v309 = Position.Y - 30
            v340 = v8.level() - 6
            v306 = math.min(v309, v340)
            v309 = countdown - v306
            v340 = CFrame.new(Position.X, (countdown + v306) / 2, Position.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
            fight.pillar.CFrame = v340
            fight.pillarGlow.CFrame = v340
            v323 = elapsed * 40
            v340 = math.sin(v323) * 4
            pillar = fight.pillar
            v339 = (v340 + 64) * (1 - v305 * 0.7)
            pillar.Size = new(v309, v339, (v340 + 64) * (1 - v305 * 0.7))
            pillar = fight.pillarGlow
            v339 = (118 - v340) * (1 - v305 * 0.5)
            pillar.Size = new(v309, v339, (118 - v340) * (1 - v305 * 0.5))
            fight.pillar.Transparency = v305 * 0.95 + 0.05
            fight.pillarGlow.Transparency = v305 * 0.4 + 0.6

            if p115 > 83.2 then
                fight.pillar:Destroy()
                fight.pillarGlow:Destroy()
                fight.pillar = nil
                fight.pillarGlow = nil
            end
        end

        once(p114, "slam", p115, 80.4, function() -- line: 1048
            -- upvalues: p114 (copy), Position (copy), new (copy), v8 (ref)
            v8.splash(new(Position.X, v8.level(), Position.Z), true)

            local fight = p114.fight

            fight.shake = math.max(fight.shake, 2)
            fight.shakeUntil = math.max(fight.shakeUntil, os.clock() + 0.8)
            fight.shakeTime = 0.8
        end)
        once(p114, "faltering", p115, 81, function() -- line: 1052
            -- upvalues: fromRGB (copy), v8 (ref)
            local v345 = fromRGB(255, 230, 255)
            local v346 = fromRGB(190, 120, 255)

            v8.card("KHAOS IS FALTERING!", v345, v346, 76, 2.2, 0.3)
        end)
        once(p114, "getUp", p115, 84.3, function() -- line: 1056
            -- upvalues: Position (copy), new (copy), v8 (ref)
            v8.sound("DeepRoar", 0.75)
            v8.splash(new(Position.X, v8.level(), Position.Z), false)
        end)
        once(p114, "beams", p115, 87, function() -- line: 1060
            -- upvalues: fight (copy), folder (copy), fromRGB (copy), Neon (copy), v3 (copy), v5 (copy), v6 (copy), v8 (ref), part (copy)
            v8.sound("Zap", 0.5)
            v8.sound("NoiseBuild", nil)
            v8.sound("Heartbeat", nil)

            local v348 = fromRGB(255, 255, 255)
            local v349 = fromRGB(255, 180, 255)

            v8.card("BEAM CLASH!", v348, v349, 84, 1.6, 0.3)
            fight.kBeam = part({
                Name = "KhaosBeam",
                Size = Vector3.new(1, 12, 12),
                Shape = Enum.PartType.Cylinder,
                Material = Neon,
                Color = fromRGB(210, 160, 255)
            })
            fight.kBeamGlow = part({
                Name = "KhaosBeamGlow",
                Size = Vector3.new(1, 24, 24),
                Transparency = 0.5,
                Shape = Enum.PartType.Cylinder,
                Material = Neon,
                Color = v3
            })
            fight.sBeam = part({
                Name = "SeraphBeam",
                Size = Vector3.new(1, 12, 12),
                Shape = Enum.PartType.Cylinder,
                Material = Neon,
                Color = fromRGB(255, 245, 210)
            })
            fight.sBeamGlow = part({
                Name = "SeraphBeamGlow",
                Size = Vector3.new(1, 24, 24),
                Transparency = 0.5,
                Shape = Enum.PartType.Cylinder,
                Material = Neon,
                Color = v5
            })
            fight.clash = part({
                Name = "Clash",
                Size = Vector3.new(30, 30, 30),
                Shape = Enum.PartType.Ball,
                Material = Neon,
                Color = v6
            })

            for _, v350 in ipairs({
                    fight.kBeam,
                    fight.kBeamGlow,
                    fight.sBeam,
                    fight.sBeamGlow,
                    fight.clash
                }) do
                v350.Parent = folder
            end

            fight.clashAt = 0
        end)

        local Unit, v351

        if fight.kBeam and v312 then
            if p115 < 93 then
                v340 = (p115 - 87) / 6
                pillar = math.clamp(v340, 0, 1)
                pillar = math.clamp(pillar, 0, 1)
                v310 = 0.5 - pillar * pillar * (3 - pillar * 2) * 0.24
            elseif p115 < 94 then
                v309 = elapsed * 30
                v310 = math.sin(v309) * 0.01 + 0.26
            else
                v340 = (p115 - 94) / 5
                pillar = math.clamp(v340, 0, 1)
                pillar = math.clamp(pillar, 0, 1)
                v310 = pillar * pillar * pillar * 0.74 + 0.26
            end

            countdown = v298.Position + v298.LookVector * (CosmicEvent.KHAOS_LENGTH * v301 * 0.45)
            v306 = v312 + (countdown - v312).Unit * 30
            v309 = countdown:Lerp(v306, v310)
            v323 = elapsed * 50
            v310 = math.sin(v323) * 0.15 + 1
            v340 = if p115 > 94 then 1.4 else 1
            pillar = fight.kBeam
            v323 = v310 * 12 * v340
            v339 = (v309 - countdown).Magnitude
            v329 = math.max(v339, 0.1)
            pillar.Size = new(v329, v323, v323)
            pillar.CFrame = CFrame.lookAt((countdown + v309) / 2, v309) * CFrame.Angles(0, 1.5707963267948966, 0)
            pillar = fight.kBeamGlow
            v323 = v310 * 26 * v340
            v339 = (v309 - countdown).Magnitude
            v329 = math.max(v339, 0.1)
            pillar.Size = new(v329, v323, v323)
            pillar.CFrame = CFrame.lookAt((countdown + v309) / 2, v309) * CFrame.Angles(0, 1.5707963267948966, 0)

            if p115 < 99 then
                pillar = fight.sBeam
                v323 = v310 * 12
                v339 = (v309 - v306).Magnitude
                v329 = math.max(v339, 0.1)
                pillar.Size = new(v329, v323, v323)
                pillar.CFrame = CFrame.lookAt((v306 + v309) / 2, v309) * CFrame.Angles(0, 1.5707963267948966, 0)
                pillar = fight.sBeamGlow
                v323 = v310 * 26
                v339 = (v309 - v306).Magnitude
                v329 = math.max(v339, 0.1)
                pillar.Size = new(v329, v323, v323)
                pillar.CFrame = CFrame.lookAt((v306 + v309) / 2, v309) * CFrame.Angles(0, 1.5707963267948966, 0)
            else
                pillar = fight.sBeam
                v323 = fight.sBeamGlow
                pillar.Transparency = 1
                v323.Transparency = 1
            end

            fight.clash.Position = v309
            pillar = fight.clash
            pillar.Size = Vector3.new(1, 1, 1) * (math.sin(elapsed * 37) * 6 + 24)
            pillar = fight.clash
            v339 = elapsed * 20

            if math.sin(v339) > 0 then
                pillar.Color = v6
            else
                pillar.Color = fromRGB(255, 220, 255)
            end

            if elapsed - fight.clashAt > 0.35 then
                fight.clashAt = elapsed
                Unit = (v306 - countdown).Unit
                v351 = if p115 > 94 then v2 else v4
                ring(folder, v309, Unit, v351, 20, 110, 0.4)
                Unit = if p115 > 94 then v2 else v4
                sparks(folder, v309, Unit, 14, 60, 3)
            end

            v323 = fight.shake
            fight.shake = math.max(v323, 0.35)
            v323 = fight.shakeUntil
            v329 = os.clock() + 0.1
            fight.shakeUntil = math.max(v323, v329)
        end

        once(p114, "turn", p115, 94, function() -- line: 1109
            -- upvalues: fromRGB (copy), v8 (ref)
            v8.sound("DeepRoar", 0.85)
            v8.sound("Braam", nil)

            local v353 = fromRGB(255, 255, 255)
            local v354 = fromRGB(170, 90, 255)

            v8.card("KHAOS FIGHTS BACK!", v353, v354, 88, 2.2, 0.3)
        end)
        once(p114, "beamHit", p115, 99, function() -- line: 1114
            -- upvalues: p114 (copy), v322 (copy), v2 (copy), v8 (ref), impact (copy)
            if v322 then
                impact(p114, v322, v2, 2)
            end

            v8.sound("SubBoom", nil)
            v8.sound("GlassBoom", 0.8)
        end)

        if fight.kBeam and p115 > 99.6 then
            for _, v355 in ipairs({
                    fight.kBeam,
                    fight.kBeamGlow,
                    fight.sBeam,
                    fight.sBeamGlow,
                    fight.clash
                }) do
                v355:Destroy()
            end

            fight.kBeam = nil
        end

        once(p114, "dash", p115, 101.5, function() -- line: 1128
            -- upvalues: v8 (ref)
            v8.sound("SonicBoom", nil)
            v8.sound("DeepWhoosh", 0.7)
        end)
        once(p114, "shatter", p115, 103, function() -- line: 1132
            -- upvalues: p114 (copy), fight (copy), elapsed (copy), folder (copy), ScreenFx (copy), fromRGB (copy), new (copy), Neon (copy), ARENA (copy), v4 (copy), v6 (copy), v7 (copy), v8 (ref), part (copy), flash (copy), sparks (copy), impact (copy)
            local v356 = if fight.seraph then fight.seraph:GetBoundingBox().Position else ARENA + CFrame.Angles(0, v7, 0):VectorToWorldSpace((Vector3.new(102, 12, 0)))

            ScreenFx.Fade(1, 0.03, v6)
            task.delay(0.12, ScreenFx.Fade, 0, 1.2)
            impact(p114, v356, v6, 3.5)
            flash(folder, v356, v4, 30, 320, 1.2)
            v8.sound("SubBoom", nil)
            v8.sound("GlassBoom", nil)
            v8.sound("EggBurst", 0.7)

            local v357 = Random.new(p114.seed + 3)

            fight.shards = {}

            for i = 1, 46 do
                local v358 = v357:NextNumber(2, 7)
                local v361 = part({
                    Name = "Shard",
                    Transparency = 0.05,
                    Size = new(v358, v358 * v357:NextNumber(0.6, 1.8), v358 * 0.6),
                    Material = if i % 3 == 0 then Enum.Material.Glass else Neon,
                    Color = if i % 2 == 0 then fromRGB(255, 244, 210) else v4
                })

                v361.CFrame = CFrame.new(v356 + new(v357:NextNumber(-12, 12), v357:NextNumber(-12, 12), v357:NextNumber(-12, 12)))
                v361.Parent = folder
                table.insert(fight.shards, {
                    part = v361,
                    vel = new(v357:NextNumber(-1, 1), v357:NextNumber(-0.3, 1.2), v357:NextNumber(-1, 1)).Unit * v357:NextNumber(30, 90),
                    spin = new(v357:NextNumber(-6, 6), v357:NextNumber(-6, 6), v357:NextNumber(-6, 6)),
                    born = elapsed
                })
            end

            sparks(folder, v356, v4, 140, 120, 6)
        end)
        once(p114, "seal", p115, 104.8, function() -- line: 1153
            -- upvalues: folder (copy), CosmicEvent (copy), v6 (copy), v8 (ref), flash (copy)
            flash(folder, CosmicEvent.RIFT, v6, 40, 200, 0.6)
            v8.sound("ReverseSwell", nil)
        end)
        v340 = BATTLE.WIN
        once(p114, "win", p115, v340, function() -- line: 1157
            -- upvalues: p114 (copy), fromRGB (copy), v8 (ref)
            v8.sound("DeepRoar", 0.7)
            v8.sound("StingChoir", 0.8)
            v8.sound("SubBoom", nil)

            local v368 = fromRGB(255, 255, 255)
            local v369 = fromRGB(170, 90, 255)

            v8.card("KHAOS WINS!", v368, v369, 150, 3, 0.32)

            local fight = p114.fight

            fight.shake = math.max(fight.shake, 1.2)
            fight.shakeUntil = math.max(fight.shakeUntil, os.clock() + 1)
            fight.shakeTime = 1
        end)
        once(p114, "ascend", p115, BATTLE.ASCEND + 0.5, function() -- line: 1164
            -- upvalues: fromRGB (copy), v8 (ref)
            v8.sound("DeepRoar", 0.6)
            v8.sound("Riser", nil)

            local v371 = fromRGB(240, 225, 255)
            local v372 = fromRGB(150, 100, 255)

            v8.card("KHAOS ASCENDS...", v371, v372, 80, 2.6, 0.3)
        end)
        once(p114, "storm", p115, BATTLE.LEN - 5, function() -- line: 1169
            -- upvalues: fromRGB (copy), v8 (ref)
            v8.sound("BraamCosmic", nil)

            local v373 = fromRGB(220, 235, 255)
            local v374 = fromRGB(150, 110, 255)

            v8.card("THE COSMIC STORM", v373, v374, 96, 2.8, 0.3)
        end)
        once(p114, "stormHelp", p115, BATTLE.LEN - 2.4, function() -- line: 1173
            -- upvalues: fromRGB (copy), v8 (ref)
            local v375 = fromRGB(255, 250, 200)
            local v376 = fromRGB(255, 190, 90)

            v8.card("Khaos's beams can turn your fish COSMIC x300!", v375, v376, 48, 3.4, 0.42)
        end)

        if fight.shards then
            v306 = #fight.shards

            for i = v306, 1, -1 do
                v309 = fight.shards[i]
                v340 = elapsed - v309.born

                if v340 > 3 then
                    v309.part:Destroy()
                    table.remove(fight.shards, i)
                else
                    v311 = v309.vel
                    Unit = p117 * -60
                    v309.vel = v311 + new(0, Unit, 0)
                    v311 = v309.vel
                    Unit = p117 * 0.8
                    v309.vel = v311 * (1 - math.min(Unit, 0.5))
                    v309.part.CFrame = (v309.part.CFrame + v309.vel * p117) * CFrame.Angles(v309.spin.X * p117, v309.spin.Y * p117, v309.spin.Z * p117)
                    v311 = v309.part
                    v329 = (v340 - 1.8) / 1.2
                    v311.Transparency = math.clamp(v329, 0.05, 1)
                end
            end
        end

        v310 = BATTLE.BET_OPEN <= p115 and p115 < BATTLE.WIN + 1.5
        t2.bars.root.Visible = v310

        if v310 then
            countdown, v306 = CosmicEvent.Health(p115)
            v309 = t2.bars
            v309.k.fill.Size = UDim2.fromScale(countdown / 100, 1)
            v309.s.fill.Size = UDim2.fromScale(v306 / 100, 1)
            v340 = v309.kShown
            v323 = countdown - v309.kShown
            v351 = -p117 * 3
            v309.kShown = v340 + v323 * (1 - math.exp(v351))
            v340 = v309.sShown
            v323 = v306 - v309.sShown
            v351 = -p117 * 3
            v309.sShown = v340 + v323 * (1 - math.exp(v351))
            v340 = v309.k.ghost
            v311 = UDim2.fromScale
            v351 = v309.kShown
            v340.Size = v311(math.max(countdown, v351) / 100, 1)
            v340 = v309.s.ghost
            v311 = UDim2.fromScale
            v351 = v309.sShown
            v340.Size = v311(math.max(v306, v351) / 100, 1)
        end
    else
        t2.bars.root.Visible = false

        if t2.bet.open then
            t2.bet.open = false
            t2.bet.root.Visible = false
            Pad.Deselect(t2.bet.root)
        end
    end

    v301 = HUD.GetMode() == "normal" or fight.watching and HUD.GetMode() == "cutscene"
    v312 = v297 and v9 and v301 and not LocalPlayer:GetAttribute("InAquarium") and not UIKit.anyWindowOpen()
    v299 = t2.cam.root

    local v377, v378

    if v297 then
        if v301 then
            v378 = false
        else
            v304 = fight.watching

            if v304 then
                v378 = false
            else
                v377 = v304
                v378 = true
            end
        end
    else
        v377 = v297
        v378 = true
    end

    if not v378 then
        v377 = not LocalPlayer:GetAttribute("InAquarium")
    end

    v299.Visible = v377
    t2.cam.label.Text = v9 and "FREE CAMERA" or "WATCH THE FIGHT"

    if not v312 or fight.watching then
        if not v312 and fight.watching then
            stopWatching(p114)
        end
    else
        fight.watching = true
        t1.Watching = true
        MoveLock.Hold("battle")
        HUD.SetMode("cutscene")
    end

    if fight.watching then
        local v379, v380 = filmed(p114, p115, v298, v300)
        local v381

        if os.clock() < fight.shakeUntil then
            v310 = fight.shake
            v309 = fight.shakeUntil - os.clock()
            v311 = fight.shakeTime
            v306 = v309 / math.max(v311, 0.1)
            v381 = v310 * math.clamp(v306, 0, 1)
        else
            v381 = 0
            fight.shake = 0
        end

        v301 = math.noise(elapsed * 18, 1.7) * v381
        v297 = math.noise(elapsed * 18, 4.1) * v381
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = v379 * CFrame.new(v301 * 2.2, v297 * 2.2, 0) * CFrame.Angles(0, 0, v301 * 0.03)
        CurrentCamera.FieldOfView = v380
    end

    BuffHud.BannerUp = BuffHud.BannerUp or t2.bars.root.Visible
end

return t1
