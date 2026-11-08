-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")

game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local Audio = require(ReplicatedStorage.Shared.Audio)
local ShrineFusionFlags = require(ReplicatedStorage.Shared.Flags.ShrineFusionFlags)
local Kit = require(script.Parent.Kit)
local ShrinePadPets = require(ReplicatedStorage.Client.ShrinePadPets)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = table.freeze({
    Sparkle = "rbxasset://textures/particles/sparkles_main.dds",
    Shockwave = "rbxassetid://109600784699514",
    Flare = "rbxassetid://105427977618886",
    Shard = "rbxassetid://140284431017219",
    Energy = "rbxassetid://85003420967228",
    Smoke = "rbxassetid://11917388916",
    Glow = "rbxassetid://119472448303122",
    Spark = "rbxassetid://102994739118592",
    Fire = "rbxassetid://86657672959540",
    Flame = "rbxassetid://16860419961",
    Swirl = "rbxassetid://127031165095122",
    TetherCore = "rbxassetid://118222722924836",
    TetherGlow = "rbxassetid://13530570401",
    TetherFlow = "rbxassetid://13526801263",
    EggVeins = "rbxassetid://96731066947230",
    Lantern = "rbxassetid://116399120112092"
})
local v2 = table.freeze({
    Pulse = 0.3,
    Crack = 0.9,
    Tear = 1.45,
    EyeOpen = 2.6,
    Gaze = 3.4,
    Link = 4.2,
    Lock = 4.25,
    PetLift = 4.6,
    Build = 4.9,
    PairOrbit = 5.3,
    Rattle = 5.6,
    Lift = 6.5,
    GroupOrbit = 7.3,
    Squint = 7.7,
    Dissolve = 9,
    Blink = 10.4,
    Merge = 11.8,
    Narrow = 12.4,
    Return = 12.9,
    Close = 13.7,
    Implode = 14.15,
    Flash = 14.45,
    Condense = 14.55,
    Egg = 15.3
})
local v3 = table.freeze({
    Split = 0.45,
    Land = 1.35,
    Handoff = 2.1,
    Caught = 2.9,
    Done = 3.7
})
local v4 = table.freeze({ 3.62, 5.45, 6.05, 8.35, 10.4, 11.3 })
local v5 = table.freeze({
    Vector2.new(-1, 0.15),
    Vector2.new(0.85, -0.35),
    Vector2.new(-0.25, 0.7),
    Vector2.new(1, 0.25),
    Vector2.new(-0.8, -0.5),
    Vector2.new(0.3, -0.75),
    Vector2.new(-0.55, 0.45)
})
local v6 = table.freeze({
    Open = { 0, 0 },
    Narrow = { -22, 15 },
    Closed = { -64, 42 },
    Flare = { 12, -9 }
})
local v7 = table.freeze({
    Fish = "Ghost Fish",
    Pumpkin = "Voidseer Pumpkin",
    Fused = "Cursed Fish"
})
local v8 = Color3.fromRGB(150, 232, 255)
local v9 = Color3.fromRGB(222, 250, 255)
local v10 = Color3.fromRGB(156, 76, 255)
local v11 = Color3.fromRGB(214, 162, 255)
local v12 = Color3.fromRGB(70, 20, 150)
local v13 = Color3.fromRGB(236, 224, 255)
local v14 = Color3.fromRGB(176, 112, 255)
local v15 = Color3.new(1, 1, 1)
local v16 = Color3.fromRGB(255, 70, 225)
local v17 = Color3.fromRGB(255, 184, 56)
local v18 = Color3.fromRGB(58, 20, 104)
local v19 = Color3.fromRGB(232, 230, 246)
local v20 = Color3.fromRGB(196, 140, 255)
local v21 = Color3.fromRGB(214, 190, 255)
local v22 = Color3.fromRGB(240, 228, 255)
local v23 = table.freeze({
    ["Zombified Halloween Sabertooth"] = table.freeze({
        Shell = "Cube.179",
        Bone = "Cube.182",
        Gold = "Icosphere.004"
    })
})
local v24 = table.freeze({
    ["rbxassetid://129580486379843"] = true
})
local v25 = table.freeze({
    SwirlCore = 0.5,
    SwirlMain = 0.4,
    Halo = 0.6,
    EyeGlow = 0.7
})
local v26 = table.freeze({
    VoidDisc = true,
    SwirlBack = true,
    SwirlMain = true,
    SwirlCore = true,
    Halo = true
})
local v27 = table.freeze({
    candles = 12,
    potions = 4,
    books = 22
})
local v28 = table.freeze({ "PropRattle", "PropRattle2", "PropRattle3", "PropRattle4" })
local t1 = {}
local t2 = nil
local v29 = Random.new()
local result

task.spawn(function() -- line: 148
    -- upvalues: ReplicatedStorage (copy), result (ref)
    local Shared = ReplicatedStorage:FindFirstChild("Shared")
    local Util = if Shared then Shared:FindFirstChild("Util") else nil

    if Util then
        local v30 = Util:WaitForChild("VoidFusionSounds", 30)

        if v30 and v30:IsA("ModuleScript") then
            local _require = require
            local ok, result2 = pcall(_require, v30)

            if ok and type(result2) == "table" then
                result = result2
            end
        end
    end
end)

local function preload() -- line: 163
    -- upvalues: ContentProvider (copy), v1 (copy)
    local function v31() -- line: 164
        -- upvalues: ContentProvider (copy), v1 (copy)
        ContentProvider:PreloadAsync({
            v1.Glow,
            v1.EggVeins,
            v1.Lantern,
            v1.Flame,
            v1.Swirl
        })
    end

    pcall(v31)
end

task.spawn(preload)

local function sounds() -- line: 177
    -- upvalues: ReplicatedStorage (copy), result (ref)
    if result then
        return result
    end

    local Util = ReplicatedStorage.Shared:FindFirstChild("Util")
    local VoidFusionSounds = if Util then Util:FindFirstChild("VoidFusionSounds") else nil

    if VoidFusionSounds and VoidFusionSounds:IsA("ModuleScript") then
        local _require = require
        local ok, result2 = pcall(_require, VoidFusionSounds)

        if ok and type(result2) == "table" then
            result = result2

            return result2
        end
    end

    return {}
end

local function assetNumber(p1) -- line: 193
    if type(p1) == "number" then
        return p1
    end

    return if type(p1) == "string" then tonumber(string.match(p1, "%d+")) else nil
end

local function ritualSeconds(p2) -- line: 202
    -- upvalues: ShrineFusionFlags (copy)
    return ShrineFusionFlags.ShrineRitualSeconds:Get()[p2] or ShrineFusionFlags.RitualSeconds:Get()
end

local function voidAssets() -- line: 206
    -- upvalues: ReplicatedStorage (copy)
    local FusionShrine = ReplicatedStorage.Assets:FindFirstChild("FusionShrine")

    return if FusionShrine then FusionShrine:FindFirstChild("Void") else nil
end

local function container(p3) -- line: 211
    -- upvalues: Workspace (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "VoidFusion"
    Folder.Parent = p3 or Workspace:FindFirstChild("Transient") or Workspace

    return Folder
end

local function partsOf(p4) -- line: 218
    local t3 = {}

    if p4 then
        if p4:IsA("BasePart") then
            table.insert(t3, p4)
        end

        for _, descendant in p4:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(t3, descendant)
            end
        end
    end

    return t3
end

local function boundsOf(p5) -- line: 233
    if p5:IsA("Model") then
        return p5:GetBoundingBox()
    end

    if p5:IsA("BasePart") then
        return p5.CFrame, p5.Size
    end

    return CFrame.identity, (Vector3.new(0, 0, 0))
end

local function corners(p6) -- line: 242
    local v32 = Vector3.new(1, 1, 1) * 1e999
    local v33 = Vector3.new(-1, -1, -1, -0) * 1e999

    for _, v34 in p6 do
        local v35 = v34.Size / 2
        local v36 = v32
        local v37 = v33

        for _, v38 in { -1, 1 } do
            local v39 = v36
            local v40 = v37

            for _, v41 in { -1, 1 } do
                for _, v44 in { -1, 1 } do
                    local v48 = v34.CFrame:PointToWorldSpace((Vector3.new(v35.X * v38, v35.Y * v41, v35.Z * v44)))

                    v39 = v39:Min(v48)
                    v40 = v40:Max(v48)
                end

                v37 = v40
                v36 = v39
            end

            v33 = v37
            v32 = v36
        end
    end

    return v32, v33
end

local function cubic(p7, p8, p9, p10, p11) -- line: 261
    local v49 = 1 - p11

    return p7 * (v49 * v49 * v49) + p8 * (v49 * 3 * v49 * p11) + p9 * (v49 * 3 * p11 * p11) + p10 * (p11 * p11 * p11)
end

local function axisFrame(p12, p13) -- line: 266
    local v50 = if p13.Magnitude > 0.001 then p13.Unit else Vector3.new(0, 1, 0)
    local Unit = v50:Cross(if math.abs((v50:Dot((Vector3.new(0, 1, 0))))) > 0.98 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0)).Unit
    local Unit2 = Unit:Cross(v50).Unit

    return CFrame.fromMatrix(p12, v50, Unit2, Unit)
end

local function rotateFlat(p14, p15) -- line: 274
    return CFrame.fromAxisAngle(Vector3.new(0, 1, 0), p15):VectorToWorldSpace(p14)
end

local function scaleSequence(p16, p17) -- line: 278
    local t4 = {}

    for _, v52 in p16.Keypoints do
        table.insert(t4, NumberSequenceKeypoint.new(v52.Time, v52.Value * p17, v52.Envelope * p17))
    end

    return NumberSequence.new(t4)
end

local function scaleTree(p18, p19) -- line: 286
    -- upvalues: scaleSequence (copy)
    for _, descendant in p18:GetDescendants() do
        if descendant:IsA("Attachment") then
            descendant.Position *= p19
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Size = scaleSequence(descendant.Size, p19)
            descendant.Speed = NumberRange.new(descendant.Speed.Min * p19, descendant.Speed.Max * p19)
            descendant.Acceleration *= p19
            descendant.ZOffset *= p19
        elseif descendant:IsA("Beam") then
            descendant.Width0 *= p19
            descendant.Width1 *= p19
        end
    end
end

local function holders(p20, p21) -- line: 302
    local t5 = {}

    for _, descendant in p20:GetDescendants() do
        if (descendant:IsA("Attachment") or descendant:IsA("BasePart")) and descendant:GetAttribute("Phase") == p21 then
            table.insert(t5, descendant)
        end
    end

    return t5
end

local function burstPhase(p22, p23) -- line: 315
    -- upvalues: holders (copy)
    for _, v55 in holders(p22, p23) do
        for _, child in v55:GetChildren() do
            if child:IsA("ParticleEmitter") then
                child:Emit(child:GetAttribute("EmitCount") or 1)
            end
        end
    end
end

local function hitOf(p24) -- line: 325
    -- upvalues: sounds (copy)
    local v56 = sounds()[p24]

    if type(v56) ~= "table" then
        return 0
    end

    return tonumber(v56.Hit) or 0
end

local function sound(p25, p26, p27, p28, p29) -- line: 330
    -- upvalues: Audio (copy), sounds (copy)
    local v57 = sounds()[p26]

    if type(v57) ~= "table" then
        return nil
    end

    local Id = v57.Id

    if type(Id) ~= "number" then
        Id = if type(Id) == "string" then tonumber(string.match(Id, "%d+")) else nil
    end

    if not Id then
        return nil
    end

    local Play = Audio.Play

    p27 = p27 or p25.Center

    local t6 = {
        MaxDistance = 260,
        Volume = (tonumber(v57.Volume) or 1) * (p28 or 1),
        PlaybackSpeed = p29 or 1,
        Looped = v57.Looped == true
    }
    local ok, result = pcall(Play, Id, p27, t6)

    if not ok or typeof(result) ~= "Instance" then
        return nil
    end

    p25.Sounds[result] = true

    return result
end

local function fadeOut(p30, p31) -- line: 352
    -- upvalues: TweenService (copy)
    if p30 and p30.Parent then
        local tween = TweenService:Create(p30, TweenInfo.new(p31, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Volume = 0
        })

        tween.Completed:Once(function() -- line: 361
            -- upvalues: p30 (copy)
            p30:Stop()
        end)
        tween:Play()
    end
end

local function loop(p32, p33, p34, p35) -- line: 367
    -- upvalues: sound (copy)
    if not p32.Loops[p33] then
        p32.Loops[p33] = sound(p32, p33, p34, p35) or false
    end
end

local function stopLoop(p36, p37, p38) -- line: 374
    -- upvalues: fadeOut (copy)
    local v59 = p36.Loops[p37]

    if v59 then
        fadeOut(v59, p38)
    end
end

local function startBed(p39) -- line: 381
    -- upvalues: Workspace (copy), sounds (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Bed = sounds().Bed
    local Id

    if type(Bed) == "table" then
        Id = Bed.Id

        if type(Id) ~= "number" then
            Id = if type(Id) == "string" then tonumber(string.match(Id, "%d+")) else nil
        end
    end

    if p39.Participant and CurrentCamera and Id and not p39.Bed then
        local Sound = Instance.new("Sound")

        Sound.Name = "VoidFusionBed"
        Sound.SoundId = ("rbxassetid://%*"):format(Id)
        Sound.Volume = tonumber(Bed.Volume) or 0.8
        Sound.TimePosition = math.max(Workspace:GetServerTimeNow() - p39.StartAt, 0)
        Sound.Parent = CurrentCamera
        Sound.Ended:Once(function() -- line: 394
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
        Sound:Play()
        p39.Bed = Sound
    end
end

local function kick(p40, p41) -- line: 401
    -- upvalues: Kit (copy), Shake (copy)
    p40.ShakePower = math.max(p40.ShakePower, p41)

    if not p40.Participant and not Kit.ReducedMotion() then
        Shake.Play({
            Seconds = p41 * 0.4 + 0.5,
            Magnitude = p41,
            Range = {
                Near = 30,
                Far = 140,
                Center = p40.Center
            }
        })
    end
end

local function host(p42, p43, p44, p45) -- line: 412
    -- upvalues: Kit (copy)
    local v61 = Kit.Part({
        Transparency = 1,
        Name = p45 or "VoidHost",
        Size = p44 or Vector3.new(0.2, 0.2, 0.2),
        CFrame = p43
    })

    v61.Parent = p42.Container

    return v61
end

local function burst(p46, p47, p48, p49, p50) -- line: 423
    -- upvalues: Kit (copy)
    local v62 = CFrame.new(p47)
    local v63 = Kit.Part({
        Name = "VoidBurst",
        Transparency = 1,
        Size = p50 or Vector3.new(0.2, 0.2, 0.2),
        CFrame = v62
    })

    v63.Parent = p46.Container
    Kit.Emitter(v63, p48):Emit(p49)
    task.delay(4, function() -- line: 433
        -- upvalues: v63 (copy)
        v63:Destroy()
    end)
end

local function flatWave(p51, p52, p53, p54, p55) -- line: 438
    -- upvalues: v1 (copy), burst (copy)
    burst(p51, p52, {
        ZOffset = 1,
        Texture = v1.Shockwave,
        Color = ColorSequence.new(p53),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Lifetime = NumberRange.new(p55),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p54 * 0.08),
            NumberSequenceKeypoint.new(1, p54)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.6, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 1)
end

local function faceWave(p56, p57, p58, p59, p60) -- line: 459
    -- upvalues: v1 (copy), burst (copy)
    burst(p56, p57, {
        ZOffset = 4,
        Texture = v1.Shockwave,
        Color = ColorSequence.new(p58),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(p60),
        Rotation = NumberRange.new(0, 360),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p59 * 0.1),
            NumberSequenceKeypoint.new(1, p59)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(0.5, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 1)
end

local function sparkleBurst(p61, p62, p63, p64, p65) -- line: 479
    -- upvalues: v1 (copy), v15 (copy), burst (copy)
    burst(p61, p62, {
        Drag = 3,
        ZOffset = 1,
        Texture = v1.Spark,
        Color = ColorSequence.new(v15, p63),
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(p65 * 0.4, p65),
        Lifetime = NumberRange.new(0.5, 1.1),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.15, 1.1),
            NumberSequenceKeypoint.new(1, 0)
        })
    }, p64)
end

local function glowFlare(p66, p67, p68, p69, p70) -- line: 497
    -- upvalues: v1 (copy), burst (copy)
    burst(p66, p67, {
        ZOffset = 3,
        Texture = v1.Flare,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new(p68),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(p70 or 0.45),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p69 * 0.3),
            NumberSequenceKeypoint.new(0.25, p69),
            NumberSequenceKeypoint.new(1, p69 * 1.15)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 1)
end

local function shardBurst(p71, p72, p73, p74, p75) -- line: 518
    -- upvalues: v1 (copy), burst (copy)
    burst(p71, p72, {
        LightEmission = 0.6,
        Drag = 2.6,
        Acceleration = Vector3.new(0, -14, 0),
        ZOffset = 1,
        Texture = v1.Shard,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new(p73),
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(p75 * 0.5, p75),
        Lifetime = NumberRange.new(0.9, 1.6),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-260, 260),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(0.8, 0.7),
            NumberSequenceKeypoint.new(1, 0)
        })
    }, p74)
end

local function sideColor(p76, p77) -- line: 541
    -- upvalues: v8 (copy), v9 (copy), v10 (copy), v11 (copy)
    if p77 == p76.Kind.Sides[1] then
        return v8, v9
    end

    return v10, v11
end

local function geometry(p78) -- line: 548
    -- upvalues: Workspace (copy), partsOf (copy), corners (copy)
    local Center = p78.Center
    local building = if p78.Interior then p78.Interior:FindFirstChild("building") else nil
    local v64 = RaycastParams.new()

    if building then
        v64.FilterType = Enum.RaycastFilterType.Include
        v64.FilterDescendantsInstances = { building }
    else
        v64.FilterType = Enum.RaycastFilterType.Exclude
        v64.FilterDescendantsInstances = {
            p78.Container,
            p78.Shrine
        }
    end

    local v65 = Workspace:Raycast(Center, Vector3.new(-0, -80, -0, -0), v64)
    local v66 = Workspace:Raycast(Center, Vector3.new(0, 80, 0), v64)

    if v65 then
        p78.Floor = v65.Position.Y
    else
        p78.Floor = Center.Y - 14
    end

    if v66 then
        p78.Ceiling = v66.Position.Y
    else
        p78.Ceiling = Center.Y + 16
    end

    local v67 = if building then building:FindFirstChild("fusion room") else nil
    local v68 = partsOf(if v67 then v67:FindFirstChild("floors") else nil)

    if #v68 > 0 then
        local v69, v70 = corners(v68)

        p78.Low = Vector3.new(v69.X + 2.5, p78.Floor, v69.Z + 2.5)
        p78.High = Vector3.new(v70.X - 2.5, p78.Ceiling, v70.Z - 2.5)
    else
        p78.Low = Vector3.new(Center.X - 40, p78.Floor, Center.Z - 40)
        p78.High = Vector3.new(Center.X + 40, p78.Ceiling, Center.Z + 40)
    end

    p78.WallReach = math.max(math.min(Center.X - p78.Low.X, p78.High.X - Center.X, Center.Z - p78.Low.Z, p78.High.Z - Center.Z), 10)
    p78.RiftSize = math.clamp(math.min(p78.Ceiling - Center.Y, Center.Y - p78.Floor) * 1.25, 10, 19)
end

local function inside(p79, p80, p81) -- line: 585
    if p80.X > p79.Low.X + p81 and p80.X < p79.High.X - p81 and p80.Z > p79.Low.Z + p81 then
        return p80.Z < p79.High.Z - p81
    end

    return false
end

local function clampRoom(p82, p83) -- line: 592
    return (Vector3.new(math.clamp(p83.X, p82.Low.X + 1, p82.High.X - 1), math.clamp(p83.Y, p82.Floor + 1.6, p82.Ceiling - 1.6), (math.clamp(p83.Z, p82.Low.Z + 1, p82.High.Z - 1))))
end

local function flatAngle(p84, p85) -- line: 600
    return (math.atan2(p85:Dot(p84.Side), (p85:Dot(p84.Across))))
end

local function planOrbits(p86) -- line: 604
    local v98 = #p86.Pets

    if v98 == 0 then
        return
    end

    local t7 = {}
    local v99 = Vector3.new(0, 0, 0)

    for _, v100 in p86.Pets do
        v99 += v100.Home.Position
        t7[v100.Side] = t7[v100.Side] or {}
        table.insert(t7[v100.Side], v100)
    end

    p86.PetHub = v99 / v98
    p86.PetOrbit = math.clamp(p86.RowSpan * 0.32, 8, 16)

    for v103, v104 in t7 do
        local v105 = Vector3.new(0, 0, 0)

        for _, v106 in v104 do
            v105 += v106.Home.Position
        end

        local v107 = v105 / #v104

        for _, v108 in v104 do
            local v109 = v108.Home.Position - v107
            local Magnitude = Vector3.new(v109.X, 0, v109.Z).Magnitude

            if Magnitude < 0.5 then
                v109 = p86.Across
                v107 = v108.Home.Position - p86.Across * 1.6
                Magnitude = 1.6
            end

            v108.PairMid = v107
            v108.PairRadius = Magnitude
            v108.PairAngle = math.atan2(v109:Dot(p86.Side), (v109:Dot(p86.Across)))
            v108.Spin = v103 == p86.Kind.Sides[1] and 1 or -1
        end
    end

    for _, v112 in p86.Pets do
        v112.GroupAngle = 3.141592653589793 - (v112.Order - 1) * (6.283185307179586 / v98)
    end
end

local function petOrbit(p87, p88, p89) -- line: 643
    -- upvalues: Kit (copy), v2 (copy)
    local HomePosition = p88.Home.Position

    if not p88.PairMid then
        return HomePosition, 0
    end

    local v113 = Kit.Smooth(Kit.Window(p89, v2.PetLift, v2.PetLift + 1.3))
    local v114 = Kit.Smooth(Kit.Window(p89, v2.PairOrbit, v2.PairOrbit + 1.2))
    local v115 = Kit.Smooth(Kit.Window(p89, v2.GroupOrbit, v2.GroupOrbit + 1.4))
    local v116 = Kit.Smooth(Kit.Window(p89, v2.GroupOrbit, v2.Dissolve + 1.2))
    local v119 = p88.Spin * 1.1 * math.max(p89 - v2.PairOrbit, 0) ^ 1.45
    local v120 = p88.PairAngle + v119
    local v121 = p88.PairMid + (p87.Across * math.cos(v120) + p87.Side * math.sin(v120)) * (p88.PairRadius * (1 - 0.2 * v114))
    local v123 = math.max(p89 - v2.GroupOrbit, 0) ^ 1.5 * 1.2
    local v124 = p88.GroupAngle + v123
    local v125 = p87.PetHub:Lerp(p87.Center, 0.25 * v116) + (p87.Across * math.cos(v124) + p87.Side * math.sin(v124) * 0.6) * (p87.PetOrbit * (0.8 + 0.3 * v116))
    local v126 = HomePosition:Lerp(v121, v114):Lerp(v125, v115)
    local v127 = HomePosition.Y + 3.2 * v113 + 1.6 * v114 + v115 * (2 + 5 * v116)
    local v128 = v119 * v114 * (1 - v115) + v123 * v115
    local v129 = Vector3.new(v126.X, v127, v126.Z)

    return Vector3.new(math.clamp(v129.X, p87.Low.X + 1, p87.High.X - 1), math.clamp(v129.Y, p87.Floor + 1.6, p87.Ceiling - 1.6), (math.clamp(v129.Z, p87.Low.Z + 1, p87.High.Z - 1))), v128
end

local function buildPets(p90) -- line: 669
    -- upvalues: Assets (copy), Kit (copy), ShrinePadPets (copy), v1 (copy), v2 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v15 (copy), v29 (copy), partsOf (copy), planOrbits (copy)
    p90.Pets = {}

    local Recipe = p90.Recipe
    local t8 = {}

    if p90.Seats then
        for v139, v140 in p90.Seats do
            for _, v141 in p90.Kind.Sides do
                if v140[v141] then
                    table.insert(t8, {
                        Side = v141,
                        Pad = v140[v141],
                        Seat = v139
                    })
                end
            end
        end
    else
        for v142, v143 in p90.Kind.Sides do
            local v144 = p90.Pads[v143]

            if v144 then
                table.insert(t8, {
                    Side = v143,
                    Pad = v144,
                    Seat = v142
                })
            end
        end
    end

    table.sort(t8, function(p91, p92) -- line: 689
        -- upvalues: p90 (copy)
        return (p91.Pad.Position - p90.Row):Dot(p90.Across) < (p92.Pad.Position - p90.Row):Dot(p90.Across)
    end)

    for v145, v146 in t8 do
        local v147 = Recipe[v146.Side]
        local v148 = ShrinePadPets.Size(p90.Kind, v146.Side)
        local v149 = if v147 then Kit.PetModel(v147, v148, ShrinePadPets.Template(v147)) else nil

        if v149 then
            local v150 = (Assets.Directory[v147] or {}).Animations or {}
            local v151 = ShrinePadPets.Home(p90.Kind, v146.Side, v146.Pad, p90.Row)

            v149:PivotTo(v151)
            v149.Parent = p90.Container

            local v152, v153

            if v146.Side == p90.Kind.Sides[1] then
                v152 = v8
                v153 = v9
            else
                v152 = v10
                v153 = v11
            end

            local _, BoundingBox = v149:GetBoundingBox()
            local t11 = {
                Side = v146.Side,
                Model = v149,
                Home = v151,
                Pad = v146.Pad,
                Top = v146.Pad.Position + Vector3.new(0, 1, 0) * (v146.Pad.Size.Y / 2),
                Seat = v146.Seat,
                Order = v145,
                Color = v152,
                Hot = v153,
                Base = v149:GetScale(),
                Height = BoundingBox.Y,
                Track = Kit.PlayAnimation(v149, v150.Idle or v150.Walk, 1),
                Parts = partsOf(v149),
                Fx = {},
                DissolveAt = v2.Dissolve + (v145 - 1) * 0.42,
                Bob = v29:NextNumber(0, 6.283185307179586)
            }

            for _, descendant in v149:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    table.insert(t11.Fx, descendant)
                elseif descendant:IsA("Beam") then
                    table.insert(t11.Fx, descendant)
                elseif descendant:IsA("Trail") then
                    table.insert(t11.Fx, descendant)
                elseif descendant:IsA("Light") then
                    table.insert(t11.Fx, descendant)
                end
            end

            local Highlight = Instance.new("Highlight")

            Highlight.Adornee = v149
            Highlight.FillColor = v153
            Highlight.OutlineColor = v15
            Highlight.FillTransparency = 1
            Highlight.OutlineTransparency = 1
            Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            Highlight.Parent = p90.Container
            t11.Highlight = Highlight

            local v154 = CFrame.new(v151.Position + Vector3.new(0, 1, 0) * BoundingBox.Y * 0.45)
            local v155 = Kit.Part({
                Name = "PetCore",
                Transparency = 1,
                Size = Vector3.new(0.2, 0.2, 0.2),
                CFrame = v154
            })

            v155.Parent = p90.Container
            t11.Core = v155
            t11.Energy = Kit.Emitter(v155, {
                ZOffset = 1,
                Texture = v1.Energy,
                FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
                FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
                Color = ColorSequence.new(v153, v152),
                SpreadAngle = Vector2.new(180, 180),
                Speed = NumberRange.new(2, 6),
                Lifetime = NumberRange.new(0.6, 1),
                Rotation = NumberRange.new(0, 360),
                RotSpeed = NumberRange.new(-120, 120),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1.6),
                    NumberSequenceKeypoint.new(1, 0.2)
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.2),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
            t11.Motes = Kit.Emitter(v155, {
                Texture = v1.Spark,
                Orientation = Enum.ParticleOrientation.VelocityParallel,
                Color = ColorSequence.new(v15, v153),
                SpreadAngle = Vector2.new(180, 180),
                Speed = NumberRange.new(4, 9),
                Lifetime = NumberRange.new(0.4, 0.8),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.2, 0.6),
                    NumberSequenceKeypoint.new(1, 0)
                })
            })

            local PointLight = Instance.new("PointLight")

            PointLight.Color = v152
            PointLight.Range = 12
            PointLight.Brightness = 0
            PointLight.Shadows = false
            PointLight.Parent = v155
            t11.Glow = PointLight
            table.insert(p90.Pets, t11)
            p90.RowSpan = math.max(p90.RowSpan, math.abs(((t11.Top - p90.Row):Dot(p90.Across))) * 2)
        end
    end

    planOrbits(p90)
end

local function buildPads(p93) -- line: 795
    -- upvalues: Kit (copy), v1 (copy)
    p93.PadFx = {}

    for _, v158 in p93.Pets do
        local Top = v158.Top
        local v159 = CFrame.new(Top + Vector3.new(0, 0.3, 0))
        local v160 = Kit.Part({
            Name = "PadFlare",
            Transparency = 1,
            Size = Vector3.new(5, 0.2, 5),
            CFrame = v159
        })

        v160.Parent = p93.Container

        local PointLight = Instance.new("PointLight")

        PointLight.Color = v158.Color
        PointLight.Range = 14
        PointLight.Brightness = 0
        PointLight.Shadows = false
        PointLight.Parent = v160

        local v161 = Kit.Emitter(v160, {
            Texture = v1.Glow,
            Color = ColorSequence.new(v158.Hot, v158.Color),
            EmissionDirection = Enum.NormalId.Top,
            Speed = NumberRange.new(3, 7),
            Lifetime = NumberRange.new(0.8, 1.4),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.9),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Shape = Enum.ParticleEmitterShape.Disc,
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
        })
        local v162 = Kit.Emitter(v160, {
            ZOffset = 0.5,
            Texture = v1.Shockwave,
            Color = ColorSequence.new(v158.Color),
            Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
            EmissionDirection = Enum.NormalId.Top,
            Speed = NumberRange.new(0.01),
            Lifetime = NumberRange.new(1.2),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 4),
                NumberSequenceKeypoint.new(1, 9)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.3, 0.55),
                NumberSequenceKeypoint.new(1, 1)
            })
        })

        table.insert(p93.PadFx, {
            Pet = v158,
            Part = v160,
            Light = PointLight,
            Column = v161,
            Runes = v162
        })
    end
end

local function eyePlug(p94, p95) -- line: 851
    -- upvalues: Kit (copy)
    local v163 = p94.EyeNow or CFrame.lookAt(p94.Center, p94.Center + p94.Side)
    local v164 = p94.EyeK or 1
    local v165 = (p94.EyeWidth or p94.RiftSize * 0.6) * v164
    local v167 = math.max(#p94.Pets, 1)
    local v168 = if v167 > 1 then (p95.Order - 1) / (v167 - 1) else 0.5
    local v170 = math.rad((Kit.Lerp(-152, -28, v168)))
    local v173 = Vector3.new(math.cos(v170), math.sin(v170), 0)

    return v163:PointToWorldSpace(v173 * v165 * 0.2 + Vector3.new(0, 0, v165 * 0.06)), v163:VectorToWorldSpace(-v173 * 0.45 + Vector3.new(0, 0, 0.9)).Unit
end

local function tetherFrames(p96, p97, p98) -- line: 864
    -- upvalues: axisFrame (copy), eyePlug (copy)
    local v176, v177 = eyePlug(p96, p97)
    local Magnitude = (v176 - p98).Magnitude

    return axisFrame(p98, Vector3.new(0, 1, 0) + p96.Side * 0.15), axisFrame(v176, v177), Magnitude * 0.5, Magnitude * 0.42
end

local function makeBeam(p99, p100, p101, p102) -- line: 873
    local Beam = Instance.new("Beam")

    Beam.Attachment0 = p100
    Beam.Attachment1 = p101
    Beam.Texture = p102.Texture
    Beam.TextureMode = Enum.TextureMode.Wrap
    Beam.TextureLength = p102.Length
    Beam.TextureSpeed = p102.Speed
    Beam.Color = p102.Color
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.Brightness = p102.Brightness or 1
    Beam.FaceCamera = true
    Beam.Segments = 32
    Beam.Width0 = 0
    Beam.Width1 = 0
    Beam.Transparency = p102.Transparency
    Beam.ZOffset = p102.ZOffset or 0
    Beam.Enabled = false
    Beam.Parent = p99

    return Beam
end

local function buildTethers(p103) -- line: 896
    -- upvalues: Kit (copy), v1 (copy), v2 (copy), v10 (copy), v11 (copy), v15 (copy), makeBeam (copy)
    p103.Tethers = {}

    local v178 = CFrame.new(p103.Center)
    local v179 = Kit.Part({
        Name = "TetherHeart",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = v178
    })

    v179.Parent = p103.Container

    for _, v180 in p103.Pets do
        local CorePosition = v180.Core.Position
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = v180.Core

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Parent = v179

        local v181 = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(0.12, 0.05),
            NumberSequenceKeypoint.new(1, 0.1)
        })
        local v182 = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(0.15, 0.45),
            NumberSequenceKeypoint.new(0.85, 0.45),
            NumberSequenceKeypoint.new(1, 0.85)
        })
        local t13 = {
            Pet = v180,
            A0 = Attachment,
            A1 = Attachment2,
            Beams = {
                {
                    Width = 4.8,
                    Beam = makeBeam(v179, Attachment, Attachment2, {
                        Length = 9,
                        Speed = 0.9,
                        Brightness = 1.6,
                        ZOffset = -0.2,
                        Texture = v1.TetherGlow,
                        Color = ColorSequence.new(v180.Color, v10),
                        Transparency = v182
                    })
                },
                {
                    Width = 1.9,
                    Beam = makeBeam(v179, Attachment, Attachment2, {
                        Length = 6,
                        Speed = 1.8,
                        Brightness = 1.6,
                        Texture = v1.TetherCore,
                        Color = ColorSequence.new(v180.Hot, v11),
                        Transparency = v181
                    })
                },
                {
                    Width = 2.8,
                    Beam = makeBeam(v179, Attachment, Attachment2, {
                        Length = 11,
                        Speed = 2.6,
                        Brightness = 1.2,
                        ZOffset = 0.2,
                        Texture = v1.TetherFlow,
                        Color = ColorSequence.new(v180.Color, v180.Hot),
                        Transparency = v181
                    })
                }
            },
            Pulses = {},
            LinkAt = v2.Link + (v180.Order - 1) * 0.08
        }
        local v183 = CFrame.new(p103.Center)
        local v184 = Kit.Part({
            Name = "TetherPlug",
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2),
            CFrame = v183
        })

        v184.Parent = p103.Container
        t13.Plug = v184
        t13.PlugGlow = Kit.Emitter(v184, {
            LockedToPart = true,
            Rate = 26,
            ZOffset = 1.2,
            Texture = v1.Flare,
            FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
            FlipbookMode = Enum.ParticleFlipbookMode.Loop,
            Color = ColorSequence.new(v180.Hot, v180.Color),
            Speed = NumberRange.new(0),
            Lifetime = NumberRange.new(0.2),
            Rotation = NumberRange.new(0, 360),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2.6),
                NumberSequenceKeypoint.new(1, 1.6)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 1)
            })
        })
        t13.PlugSparks = Kit.Emitter(v184, {
            Drag = 4,
            Rate = 18,
            ZOffset = 1,
            Texture = v1.Spark,
            Orientation = Enum.ParticleOrientation.VelocityParallel,
            Color = ColorSequence.new(v15, v180.Hot),
            SpreadAngle = Vector2.new(70, 70),
            EmissionDirection = Enum.NormalId.Back,
            Speed = NumberRange.new(5, 10),
            Lifetime = NumberRange.new(0.25, 0.45),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.2, 0.55),
                NumberSequenceKeypoint.new(1, 0)
            })
        })

        for i = 1, 3 do
            local v185 = CFrame.new(CorePosition)
            local v186 = Kit.Part({
                Name = "TetherPulse",
                Transparency = 1,
                Size = Vector3.new(0.2, 0.2, 0.2),
                CFrame = v185
            })

            v186.Parent = p103.Container
            Kit.Emitter(v186, {
                LockedToPart = true,
                Rate = 30,
                ZOffset = 1,
                Texture = v1.Flare,
                FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
                FlipbookMode = Enum.ParticleFlipbookMode.Loop,
                Color = ColorSequence.new(v180.Hot),
                Speed = NumberRange.new(0),
                Lifetime = NumberRange.new(0.18),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1.8),
                    NumberSequenceKeypoint.new(1, 1.2)
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
            table.insert(t13.Pulses, {
                Part = v186,
                Offset = (i - 1) / 3
            })
        end

        table.insert(p103.Tethers, t13)
    end

    p103.TetherHeart = v179
end

local function gatherProps(p104) -- line: 1027
    -- upvalues: v2 (copy), v27 (copy), v29 (copy), partsOf (copy)
    p104.Props = {}

    local decoration = if p104.Interior then p104.Interior:FindFirstChild("decoration") else nil

    if not decoration then
        return
    end

    local Center = p104.Center
    local t15 = {}

    for v187, v188 in v27 do
        local v189 = decoration:FindFirstChild(v187)

        if v189 then
            local t16 = {}

            for _, child in v189:GetChildren() do
                local v190 = partsOf(child)

                if #v190 ~= 0 and not (#v190 > 12) then
                    local BoundingBox, BoundingBox2

                    if child:IsA("Model") then
                        BoundingBox, BoundingBox2 = child:GetBoundingBox()
                    elseif child:IsA("BasePart") then
                        BoundingBox = child.CFrame
                        BoundingBox2 = child.Size
                    else
                        BoundingBox = CFrame.identity
                        BoundingBox2 = Vector3.new(0, 0, 0)
                    end

                    local BoundingBoxPosition = BoundingBox.Position

                    if not (BoundingBox2.Magnitude > 9) and BoundingBoxPosition.X > p104.Low.X + 1 and BoundingBoxPosition.X < p104.High.X - 1 and BoundingBoxPosition.Z > p104.Low.Z + 1 and BoundingBoxPosition.Z < p104.High.Z - 1 and not (BoundingBoxPosition.Y > p104.Ceiling - 4) and not (BoundingBoxPosition.Y < p104.Floor - 3) then
                        table.insert(t16, {
                            Item = child,
                            Parts = v190,
                            Frame = BoundingBox,
                            Size = BoundingBox2,
                            Slam = v187 == "books"
                        })
                    end
                end
            end

            table.sort(t16, function(p105, p106) -- line: 1064
                -- upvalues: Center (copy)
                return (p105.Frame.Position - Center).Magnitude < (p106.Frame.Position - Center).Magnitude
            end)

            for i = 1, math.min(v188, #t16) do
                table.insert(t15, t16[i])
            end
        end
    end

    local v193 = Center - p104.Side * 4

    p104.OrbitHub = v193

    local n1 = 0
    local n2 = 0

    for _, v194 in p104.Pets do
        local v195 = v194.Top - v193

        n1 = math.max(n1, (math.abs((v195:Dot(p104.Across)))))
        n2 = math.max(n2, (math.abs((v195:Dot(p104.Side)))))
    end

    local function reach(p107) -- line: 1079
        -- upvalues: p104 (copy), v193 (copy)
        local n3 = 1e999

        for _, v200 in { "X", "Z" } do
            local v201 = p107[v200]

            if math.abs(v201) > 0.001 then
                n3 = math.min(n3, ((if v201 > 0 then p104.High[v200] else p104.Low[v200]) - v193[v200]) / v201)
            end
        end

        return n3
    end

    local v207 = math.max(math.min(reach(p104.Across), (reach(-p104.Across))) - 4, n1 + 10)
    local v211 = math.clamp(math.min(reach(p104.Side) - 4, reach(-p104.Side) - 6), 12, 18)
    local v214 = math.min(n1 + 8, v207 - 2)
    local v217 = math.max(p104.PadTop + 6, p104.Floor + 5)
    local v220 = math.max(p104.Ceiling - 4, v217 + 2)

    table.sort(t15, function(p108, p109) -- line: 1097
        -- upvalues: Center (copy)
        return (p108.Frame.Position - Center).Magnitude < (p109.Frame.Position - Center).Magnitude
    end)

    for v221, v222 in t15 do
        local Frame = v222.Frame
        local t18 = {}

        for _, v223 in v222.Parts do
            table.insert(t18, {
                Part = v223,
                CFrame = v223.CFrame,
                Rel = Frame:ToObjectSpace(v223.CFrame),
                Anchored = v223.Anchored,
                CanCollide = v223.CanCollide,
                Transparency = v223.Transparency
            })
        end

        local v224 = Frame.Position - v193
        local v225 = math.max(v222.Size.X, v222.Size.Y, v222.Size.Z)
        local v226 = v29:NextNumber(v214, v207 - v225 * 0.5)
        local v228 = v29:NextNumber(math.min(10, v211 - 2), v211 - v225 * 0.5)

        table.insert(p104.Props, {
            Item = v222.Item,
            Parts = t18,
            Home = Frame,
            HomeRot = Frame.Rotation,
            Extent = v225,
            Slam = v222.Slam,
            Angle = math.atan2(v224:Dot(p104.Side) / v228, v224:Dot(p104.Across) / v226),
            RadiusX = v226,
            RadiusZ = v228,
            Height = v29:NextNumber(v217, v220 - v225 * 0.5),
            Tilt = v29:NextNumber(1.2, 3.2),
            Phase = v29:NextNumber(0, 6.283185307179586),
            Axis = v29:NextUnitVector(),
            SpinRate = v29:NextNumber(1.4, 3.4) * (v222.Slam and 1 or 0.55),
            Seed = v29:NextNumber(0, 1000),
            RattleAt = v2.Rattle + v29:NextNumber(0, 0.8),
            LiftAt = v2.Lift + v221 * 0.035 + v29:NextNumber(0, 0.3),
            LiftSeconds = v29:NextNumber(1.3, 1.8),
            ReturnAt = v2.Return + v29:NextNumber(0, 0.9),
            ReturnSeconds = v29:NextNumber(1.6, 2.1),
            Rot = CFrame.identity,
            Pose = Frame
        })
    end
end

local function freeProps(p110) -- line: 1147
    for _, v231 in p110.Props do
        for _, v232 in v231.Parts do
            local Part = v232.Part

            if Part.Parent then
                Part.Anchored = true
                Part.CanCollide = false
            end
        end
    end

    p110.PropsFree = true
end

local function restoreProps(p111) -- line: 1160
    -- upvalues: Workspace (copy)
    if not p111.Props or p111.PropsRestored then
        return
    end

    p111.PropsRestored = true

    local t21 = {}
    local t22 = {}

    for _, v233 in p111.Props do
        for _, v234 in v233.Parts do
            if v234.Part.Parent then
                table.insert(t21, v234.Part)
                table.insert(t22, v234.CFrame)
            end
        end
    end

    if #t21 > 0 then
        Workspace:BulkMoveTo(t21, t22, Enum.BulkMoveMode.FireCFrameChanged)
    end

    for _, v235 in p111.Props do
        for _, v236 in v235.Parts do
            local Part = v236.Part

            if Part.Parent then
                Part.CFrame = v236.CFrame
                Part.Anchored = v236.Anchored
                Part.CanCollide = v236.CanCollide
                Part.Transparency = v236.Transparency

                if not v236.Anchored then
                    Part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    Part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end

local function gatherLights(p112) -- line: 1194
    -- upvalues: v1 (copy), v24 (copy), v29 (copy)
    p112.Lights = {}
    p112.SquareDust = {}

    if p112.Interior then
        for _, descendant in p112.Interior:GetDescendants() do
            if descendant:IsA("ParticleEmitter") and v24[descendant.Texture] then
                table.insert(p112.SquareDust, {
                    Emitter = descendant,
                    Texture = descendant.Texture
                })
                descendant.Texture = v1.Glow
                descendant:Clear()
            elseif descendant:IsA("Light") and not descendant:IsDescendantOf(p112.Shrine) then
                local Parent = descendant.Parent
                local v237 = if not Parent then nil
                    elseif Parent:IsA("BasePart") then Parent.Position
                    elseif Parent:IsA("Attachment") then Parent.WorldPosition
                    else nil

                if v237 and v237.X > p112.Low.X + -4 and v237.X < p112.High.X - -4 and v237.Z > p112.Low.Z + -4 and v237.Z < p112.High.Z - -4 and v237.Y < p112.Ceiling + 6 then
                    table.insert(p112.Lights, {
                        Light = descendant,
                        Brightness = descendant.Brightness,
                        Color = descendant.Color,
                        Seed = v29:NextNumber(0, 1000)
                    })
                end
            end
        end
    end
end

local function restoreLights(p113) -- line: 1226
    for _, v238 in p113.Lights or {} do
        if v238.Light.Parent then
            v238.Light.Brightness = v238.Brightness
            v238.Light.Color = v238.Color
        end
    end

    for _, v239 in p113.SquareDust or {} do
        if v239.Emitter.Parent then
            v239.Emitter.Texture = v239.Texture
        end
    end

    p113.SquareDust = {}
end

local function buildRoom(p114) -- line: 1241
    -- upvalues: Workspace (copy), Kit (copy), v1 (copy), v8 (copy), v11 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

        ColorCorrectionEffect.Name = "VoidFusionGrade"
        ColorCorrectionEffect.Parent = CurrentCamera
        p114.Trove:Add(ColorCorrectionEffect)
        p114.Grade = ColorCorrectionEffect
    end

    local Low, High = p114.Low, p114.High
    local v242 = Vector3.new(High.X - Low.X, 0.4, High.Z - Low.Z)
    local v243 = CFrame.new((Low.X + High.X) / 2, p114.Floor + 0.6, (Low.Z + High.Z) / 2)
    local v244 = Kit.Part({
        Name = "RoomMotes",
        Transparency = 1,
        Size = v242 or Vector3.new(0.2, 0.2, 0.2),
        CFrame = v243
    })

    v244.Parent = p114.Container
    p114.Motes = Kit.Emitter(v244, {
        Acceleration = Vector3.new(0, 0.6, 0),
        Texture = v1.Glow,
        Color = ColorSequence.new(v11, v8),
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(1.5, 4),
        Lifetime = NumberRange.new(3, 5),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.2, 0.45),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
end

local function buildRift(p115) -- line: 1277
    -- upvalues: ReplicatedStorage (copy), Kit (copy), v1 (copy), v6 (copy), v9 (copy), v10 (copy), v11 (copy), v15 (copy), v25 (copy), v26 (copy), scaleSequence (copy), scaleTree (copy)
    local FusionShrine = ReplicatedStorage.Assets:FindFirstChild("FusionShrine")
    local Void = if FusionShrine then FusionShrine:FindFirstChild("Void") else nil
    local RiftSize = p115.RiftSize
    local v245 = CFrame.lookAt(p115.Center, p115.Center + p115.Side)

    p115.Steady = {}
    p115.RiftDiscs = {}
    p115.MergeDim = {}
    p115.VortexGlow = {}

    local Rift = if Void then Void:FindFirstChild("Rift") else nil

    if Rift and Rift:IsA("Model") then
        local clone = Rift:Clone()

        scaleTree(clone, RiftSize / 170)
        clone:PivotTo(v245)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            elseif descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false

                if v26[descendant.Name] then
                    table.insert(p115.RiftDiscs, {
                        Emitter = descendant,
                        Size = descendant.Size
                    })
                end

                if descendant.Name == "Pinch" then
                    descendant.Color = ColorSequence.new(v11, v10)
                    descendant.Size = scaleSequence(descendant.Size, 0.55)
                elseif descendant.Name == "EyeGlow" then
                    descendant.Color = ColorSequence.new(v10)
                end

                local v246 = v25[descendant.Name]

                if not v246 then
                    v246 = if descendant.Name == "Bolt" then 0.5 else nil
                end

                if v246 then
                    table.insert(p115.MergeDim, {
                        Emitter = descendant,
                        Dim = v246,
                        Transparency = descendant.Transparency,
                        LightEmission = descendant.LightEmission,
                        Brightness = descendant.Brightness
                    })
                end
            end
        end

        clone.Parent = p115.Container
        p115.Rift = clone
        p115.RiftFacing = v245

        local v247 = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")

        if v247 then
            local PointLight = Instance.new("PointLight")

            PointLight.Color = v10
            PointLight.Range = RiftSize * 2.4
            PointLight.Brightness = 0
            PointLight.Shadows = false
            PointLight.Parent = v247
            p115.RiftLight = PointLight
        end
    end

    local Vortex = if Void then Void:FindFirstChild("Vortex") else nil

    if Vortex and Vortex:IsA("BasePart") then
        local clone = Vortex:Clone()

        scaleTree(clone, RiftSize / 24)
        clone.CFrame = v245 * CFrame.new(0, 0, 0.2)
        clone.Parent = p115.Container
        p115.Vortex = clone

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
                descendant.Brightness = math.min(descendant.Brightness, 3)
                table.insert(p115.RiftDiscs, {
                    Emitter = descendant,
                    Size = descendant.Size
                })
                table.insert(p115.VortexGlow, {
                    Emitter = descendant,
                    Brightness = descendant.Brightness
                })
            end
        end
    end

    local Eye = if Void then Void:FindFirstChild("Eye") else nil

    if Eye and Eye:IsA("Model") then
        local clone = Eye:Clone()
        local _, BoundingBox = clone:GetBoundingBox()
        local v248 = RiftSize * 0.6

        p115.EyeScale = v248 / math.max(BoundingBox.X, 0.1)
        p115.EyeWidth = v248
        clone:ScaleTo(p115.EyeScale)

        local v249 = p115.Center + p115.Side * (RiftSize * 0.04)

        p115.EyeFrame = CFrame.lookAt(v249, v249 + p115.Side)
        clone:PivotTo(p115.EyeFrame)

        local Sclera = clone:FindFirstChild("Sclera")

        clone:ScaleTo(p115.EyeScale * 0.05)
        clone:PivotTo(p115.EyeFrame)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 1
            end
        end

        clone.Parent = p115.Container

        local PointLight = Instance.new("PointLight")

        PointLight.Color = v11
        PointLight.Range = RiftSize * 0.9
        PointLight.Brightness = 0
        PointLight.Shadows = false
        PointLight.Parent = Sclera or clone:FindFirstChildWhichIsA("BasePart")
        p115.Eye = {
            Shown = false,
            Scale = 0.05,
            Model = clone,
            Upper = clone:FindFirstChild("UpperLid"),
            Lower = clone:FindFirstChild("LowerLid"),
            Pupil = clone:FindFirstChild("Pupil"),
            Sclera = Sclera,
            ScleraColor = if not (Sclera and Sclera:IsA("BasePart")) then v10 else Sclera.Color,
            Light = PointLight,
            Angles = {
                v6.Closed[1],
                v6.Closed[2]
            },
            Look = Vector2.zero
        }
        p115.EyeNow = p115.EyeFrame
    end

    local v250 = CFrame.new(p115.Center)
    local v251 = Kit.Part({
        Name = "RiftTear",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = v250
    })

    v251.Parent = p115.Container

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v251

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Parent = v251

    local t30 = {}

    for v252, v253 in {
            {
                Width = 2.4,
                Texture = v1.TetherGlow,
                Color = ColorSequence.new(v10, v11)
            },
            {
                Width = 0.9,
                Texture = v1.TetherCore,
                Color = ColorSequence.new(v15, v9)
            }
        } do
        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2
        Beam.Texture = v253.Texture
        Beam.TextureMode = Enum.TextureMode.Stretch
        Beam.TextureSpeed = 1.5
        Beam.Color = v253.Color
        Beam.LightEmission = 1
        Beam.LightInfluence = 0
        Beam.Brightness = v252 == 2 and 4 or 2
        Beam.FaceCamera = true
        Beam.Segments = 12
        Beam.Width0 = 0
        Beam.Width1 = 0
        Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.1),
            NumberSequenceKeypoint.new(0.7, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
        Beam.Enabled = false
        Beam.Parent = v251
        table.insert(t30, {
            Beam = Beam,
            Width = v253.Width
        })
    end

    p115.Tear = {
        Part = v251,
        Bottom = Attachment,
        Top = Attachment2,
        Beams = t30
    }
end

local function setLoop(p116, p117, p118, p119, p120) -- line: 1437
    -- upvalues: holders (copy)
    if not p117 then
        return
    end

    for _, v254 in holders(p117, p118) do
        for _, descendant in v254:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                if descendant.Rate > 0 and descendant.Rate < 4 then
                    descendant.Enabled = false

                    if p119 then
                        if not p116.Steady[descendant] then
                            descendant:Emit(1)
                            p116.Steady[descendant] = {
                                Interval = 1 / descendant.Rate,
                                Next = os.clock() + 1 / descendant.Rate
                            }
                        end
                    else
                        p116.Steady[descendant] = nil
                    end
                else
                    descendant.Enabled = p119
                end

                if p120 then
                    descendant:Clear()
                end
            end
        end
    end
end

local function setVortex(p121, p122, p123) -- line: 1464
    local Vortex = p121.Vortex

    if Vortex then
        for _, descendant in Vortex:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = p122 and not string.find(descendant.Name, "tech_vortex", 1, true)

                if p123 then
                    descendant:Clear()
                end
            end
        end
    end
end

local function stepSteady(p124, p125) -- line: 1479
    local elapsed = os.clock()

    for v255, v256 in p124.Steady do
        if v255.Parent then
            if v256.Next <= elapsed then
                v255:Emit(1)

                local v257 = v256.Interval / math.max(p125, 0.2)

                if v257 < elapsed - v256.Next then
                    v256.Next = elapsed + v257
                else
                    v256.Next += v257
                end
            end
        else
            p124.Steady[v255] = nil
        end
    end
end

local function buildOrb(p126) -- line: 1494
    -- upvalues: Kit (copy), v1 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy)
    local RiftSize = p126.RiftSize
    local v258 = p126.Center + p126.Side * (RiftSize * 0.2)
    local v259 = CFrame.lookAt(v258, v258 + p126.Side)
    local v260 = Kit.Part({
        Name = "VoidOrb",
        Transparency = 1,
        Size = Vector3.new(1, 1, 1),
        CFrame = v259
    })

    v260.Parent = p126.Container

    local function emit(p127) -- line: 1498
        -- upvalues: v260 (copy), Kit (copy)
        local v261 = Kit.Emitter(v260, p127)

        v261.Enabled = false

        return v261
    end

    local t32 = {
        Size = 0,
        Part = v260
    }
    local t33 = {
        LightEmission = 0.75,
        LockedToPart = true,
        Rate = 26,
        ZOffset = 3,
        Texture = v1.Flare,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        Color = ColorSequence.new(v11, v10),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.3),
        Rotation = NumberRange.new(0, 360),
        Size = NumberSequence.new(1),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v262 = Kit.Emitter(v260, t33)

    v262.Enabled = false
    t32.Core = v262

    local t34 = {
        LightEmission = 0.6,
        LockedToPart = true,
        Rate = 22,
        ZOffset = 3.4,
        Texture = v1.Flare,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        Color = ColorSequence.new(v8, v9),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.25),
        Rotation = NumberRange.new(0, 360),
        Size = NumberSequence.new(1),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v263 = Kit.Emitter(v260, t34)

    v263.Enabled = false
    t32.Bone = v263

    local t35 = {
        LightEmission = 0.8,
        LockedToPart = true,
        Rate = 6,
        ZOffset = 2.6,
        Texture = v1.Swirl,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        Color = ColorSequence.new(v11, v8),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.9),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-260, -200),
        Size = NumberSequence.new(1),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.25, 0.25),
            NumberSequenceKeypoint.new(0.75, 0.25),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v264 = Kit.Emitter(v260, t35)

    v264.Enabled = false
    t32.Swirl = v264

    local t36 = {
        Rate = 45,
        ZOffset = 2,
        Texture = v1.Spark,
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        Color = ColorSequence.new(v9, v11),
        Shape = Enum.ParticleEmitterShape.Sphere,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
        ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward,
        Speed = NumberRange.new(16, 26),
        Lifetime = NumberRange.new(0.25, 0.4),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.3, 0.9),
            NumberSequenceKeypoint.new(1, 0)
        })
    }
    local v265 = Kit.Emitter(v260, t36)

    v265.Enabled = false
    t32.Inward = v265

    local t37 = {
        Rate = 14,
        ZOffset = 2.2,
        Texture = v1.Fire,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new(v11, v12),
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(1, 3),
        Lifetime = NumberRange.new(0.5, 0.7),
        Rotation = NumberRange.new(0, 360),
        Size = NumberSequence.new(1),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v266 = Kit.Emitter(v260, t37)

    v266.Enabled = false
    t32.Flames = v266

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v11
    PointLight.Range = RiftSize * 1.6
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = v260
    t32.Light = PointLight
    p126.Orb = t32
end

local function setOrbSize(p128, p129) -- line: 1605
    local Orb = p128.Orb

    if not Orb then
        return
    end

    local v267 = p129 > 0.05

    for _, v268 in { "Core", "Bone", "Swirl", "Inward", "Flames" } do
        Orb[v268].Enabled = v267
    end

    if not v267 then
        Orb.Light.Brightness = 0

        return
    end

    local v270 = math.sin(os.clock() * 22) * 0.08 + 1

    Orb.Core.Size = NumberSequence.new(p129 * 2.3 * v270)
    Orb.Bone.Size = NumberSequence.new(p129 * 1.1 * v270)
    Orb.Swirl.Size = NumberSequence.new(p129 * 2.8)
    Orb.Flames.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p129 * 0.6),
        NumberSequenceKeypoint.new(1, p129 * 1.1)
    })
    Orb.Part.Size = Vector3.new(1, 1, 1) * math.max(p129 * 2.6, 0.5)
    Orb.Light.Brightness = p129 * 0.45 + 1.5
end

local function makeWisp(p130, p131, p132) -- line: 1630
    -- upvalues: Kit (copy), v1 (copy), v29 (copy)
    local v272 = CFrame.new(p132)
    local v273 = Kit.Part({
        Name = "VoidWisp",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = v272
    })

    v273.Parent = p130.Container

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 0.35, 0)
    Attachment.Parent = v273

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, -0.35, 0)
    Attachment2.Parent = v273

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.Color = ColorSequence.new(p131.Hot, p131.Color)
    Trail.Texture = v1.Glow
    Trail.TextureMode = Enum.TextureMode.Stretch
    Trail.Transparency = NumberSequence.new(0.1, 1)
    Trail.WidthScale = NumberSequence.new(1, 0.1)
    Trail.Lifetime = 0.32
    Trail.MinLength = 0.05
    Trail.LightEmission = 1
    Trail.LightInfluence = 0
    Trail.FaceCamera = true
    Trail.Parent = v273
    Kit.Emitter(v273, {
        LockedToPart = true,
        Rate = 30,
        Enabled = true,
        ZOffset = 1.5,
        Texture = v1.Flare,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        Color = ColorSequence.new(p131.Hot),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.16),
        Size = NumberSequence.new(1.3),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(1, 1)
        })
    })

    local Center = p130.Center
    local v274 = p130.Across * v29:NextNumber(-7, 7)
    local v275 = v29:NextNumber(0, 6.283185307179586)

    table.insert(p130.Wisps, {
        Part = v273,
        Trail = Trail,
        From = p132,
        Control = p132:Lerp(Center, 0.5) + Vector3.new(0, 1, 0) * v29:NextNumber(4, 8) + v274,
        Born = p130.T,
        Travel = v29:NextNumber(0.75, 1.15),
        Angle = v275,
        Radius = p130.RiftSize * v29:NextNumber(0.26, 0.4),
        Spin = p131.Side == p130.Kind.Sides[1] and 1 or -1,
        Tilt = v29:NextNumber(-0.5, 0.5),
        Rate = v29:NextNumber(0.85, 1.2)
    })
end

local function wispOrbit(p133, p134, p135) -- line: 1687
    local v276 = p134.Radius * (1 - p135 * 0.82)
    local v277 = CFrame.fromAxisAngle(p133.Across, p134.Tilt)
    local v278 = v277:VectorToWorldSpace(p133.Across)
    local v279 = v277:VectorToWorldSpace((Vector3.new(0, 1, 0)))

    return p133.Center + (v278 * math.cos(p134.Angle) + v279 * math.sin(p134.Angle)) * v276 + p133.Side * (p133.RiftSize * 0.2 + math.sin(p134.Angle * 2) * 0.5)
end

local function stepWisps(p136, p137, p138) -- line: 1697
    -- upvalues: Kit (copy), v2 (copy), wispOrbit (copy)
    local v284 = Kit.Smooth(Kit.Window(p137, v2.Merge, v2.Implode))
    local v285 = 2.4 + 8 * v284

    for i = #p136.Wisps, 1, -1 do
        local v286 = p136.Wisps[i]

        if v286.Part.Parent then
            v286.Angle += v286.Spin * v285 * v286.Rate * p138

            local v287 = wispOrbit(p136, v286, v284)
            local v288 = Kit.Window(p137, v286.Born, v286.Born + v286.Travel)

            if v288 < 1 then
                local v289 = Kit.Ease(v288, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

                v287 = Kit.Bezier(v286.From, v286.Control, v287, v289)
            end

            local v290 = v2.Implode <= p137
            local v291, v292

            if v290 then
                local v293 = Kit.Window(p137, v2.Implode, v2.Implode + 0.28)

                v291 = v287:Lerp(p136.Center, Kit.Ease(v293, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
                v292 = v293 >= 1
            end

            if not v290 or not v292 then
                local v294 = if v290 then v291 else v287

                v286.Part.CFrame = CFrame.new(v294)
            else
                v286.Part:Destroy()
                table.remove(p136.Wisps, i)
            end

            continue
        end

        table.remove(p136.Wisps, i)
    end
end

local function lidAngles(_, p140) -- line: 1732
    -- upvalues: Kit (copy), v2 (copy), v4 (copy), v6 (copy)
    local Open, Flare, Narrow, Closed = v6.Open, v6.Flare, v6.Narrow, v6.Closed

    if p140 < v2.EyeOpen then
        return Closed[1], Closed[2]
    end

    local v295 = Kit.Ease(Kit.Window(p140, v2.EyeOpen, v2.EyeOpen + 0.24), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local v296 = Kit.Smooth(Kit.Window(p140, v2.EyeOpen + 0.3, v2.EyeOpen + 0.9))
    local v297 = Kit.Lerp(Kit.Lerp(Closed[1], Flare[1], v295), Open[1], v296)
    local v298 = Kit.Lerp(Kit.Lerp(Closed[2], Flare[2], v295), Open[2], v296)
    local v304 = math.max(math.sin(3.141592653589793 * Kit.Window(p140, v2.Lock, v2.Lock + 0.5)) * 0.35, math.sin(3.141592653589793 * Kit.Window(p140, v2.Squint, v2.Dissolve)) * 0.55, Kit.Smooth(Kit.Window(p140, v2.Narrow, v2.Narrow + 0.5)))
    local v305 = Kit.Lerp(v297, Narrow[1], v304)
    local v306 = Kit.Lerp(v298, Narrow[2], v304)
    local n4 = 0

    for _, v307 in v4 do
        n4 = math.max(n4, (math.sin(3.141592653589793 * Kit.Window(p140, v307, v307 + 0.2))))
    end

    local v310 = Kit.Lerp(v305, Closed[1], n4)
    local v311 = Kit.Lerp(v306, Closed[2], n4)
    local v312 = Kit.Ease(Kit.Window(p140, v2.Close, v2.Implode), Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    return Kit.Lerp(v310, Closed[1], v312), Kit.Lerp(v311, Closed[2], v312)
end

local function glance(p141, p142, p143, p144) -- line: 1765
    -- upvalues: v5 (copy)
    local v315 = v5[math.floor((p142 - p143) / p144) % #v5 + 1]

    return p141.Center + p141.Side * 20 + p141.Across * (16 * v315.X) + Vector3.new(0, 1, 0) * (6 * v315.Y - 3)
end

local function rowGaze(p145, p146) -- line: 1774
    -- upvalues: v2 (copy)
    local v317 = math.sin((p146 - v2.Lock) * 0.8) * p145.RowSpan * 0.45

    return p145.Row + p145.Across * v317 + Vector3.new(0, 2, 0)
end

local function gazeTarget(p147, p148) -- line: 1779
    -- upvalues: Workspace (copy), Kit (copy), v2 (copy), v5 (copy)
    if p148 < v2.Lock then
        local v320 = v5[math.floor((p148 - v2.EyeOpen) / 0.36) % #v5 + 1]

        return p147.Center + p147.Side * 20 + p147.Across * (16 * v320.X) + Vector3.new(0, 1, 0) * (6 * v320.Y - 3)
    end

    if p148 < v2.Lift then
        local v322 = math.sin((p148 - v2.Lock) * 0.8) * p147.RowSpan * 0.45

        return p147.Row + p147.Across * v322 + Vector3.new(0, 2, 0)
    end

    if p148 < v2.Dissolve - 0.3 then
        local v325 = v5[math.floor((p148 - v2.Lift) / 0.5) % #v5 + 1]

        return p147.Center + p147.Side * 20 + p147.Across * (16 * v325.X) + Vector3.new(0, 1, 0) * (6 * v325.Y - 3)
    end

    if p148 < v2.Merge then
        local v327 = math.sin((p148 - v2.Lock) * 0.8) * p147.RowSpan * 0.45

        return p147.Row + p147.Across * v327 + Vector3.new(0, 2, 0)
    end

    local v328 = Vector3.new(0, 0, 0)
    local n5 = 0

    for _, v329 in p147.Seats or {} do
        local v330 = Kit.RootOf(v329.Character)

        if v330 then
            v328 += v330.Position + Vector3.new(0, 2, 0)
            n5 += 1
        end
    end

    if n5 ~= 0 then
        return v328 / n5
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.CFrame.Position
    end

    return p147.Center + p147.Side * 20
end

local function gazeRate(p149) -- line: 1807
    -- upvalues: v2 (copy)
    if p149 < v2.Lock then
        return 18
    end

    if p149 < v2.Lock + 0.35 then
        return 22
    end

    if not (v2.Lift <= p149 and p149 < v2.Dissolve - 0.3) then
        return 7
    end

    return 14
end

local function stepEye(p150, p151, p152) -- line: 1820
    -- upvalues: Kit (copy), v2 (copy), v11 (copy), lidAngles (copy), gazeTarget (copy)
    local Eye = p150.Eye

    if Eye and Eye.Model.Parent then
        local v332 = math.max(Kit.Ease(Kit.Window(p151, v2.Tear + 0.2, v2.Tear + 0.8), Enum.EasingStyle.Back, Enum.EasingDirection.Out) * (1 - Kit.Ease(Kit.Window(p151, v2.Close + 0.15, v2.Implode + 0.05), Enum.EasingStyle.Quad, Enum.EasingDirection.In)), 0)
        local v333 = v332 > 0.02

        if v333 ~= Eye.Shown then
            Eye.Shown = v333

            for _, descendant in Eye.Model:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = v333 and 0 or 1
                end
            end
        end

        local Light = Eye.Light

        if not v333 then
            Light.Brightness = 0

            return
        end

        Light.Brightness = (0.6 + 1.4 * Kit.Window(p151, v2.EyeOpen, v2.EyeOpen + 0.3)) * v332

        local v334 = p150.EyeScale * math.max(v332, 0.05)

        if math.abs(Eye.Model:GetScale() - v334) > 1E-04 then
            Eye.Model:ScaleTo(v334)
        end

        local v336 = Eye.Model:GetScale() / p150.EyeScale
        local v338 = math.sin(p151 * 9) * 0.03 + 1
        local v340 = p150.EyeFrame * CFrame.new(0, math.sin(p151 * 1.6) * 0.12, 0)

        p150.EyeNow = v340
        p150.EyeK = v336
        Eye.Model:PivotTo(v340)

        local v341, v342 = lidAngles(p150, p151)
        local Angles, Angles2 = Eye.Angles, Eye.Angles

        Angles[1] = v341
        Angles2[2] = v342

        if Eye.Upper then
            Eye.Upper:PivotTo(v340 * CFrame.Angles(math.rad(v341), 0, 0))
        end

        if Eye.Lower then
            Eye.Lower:PivotTo(v340 * CFrame.Angles(math.rad(v342), 0, 0))
        end

        local v343 = v340:PointToObjectSpace((gazeTarget(p150, p151)))
        local v347 = math.clamp(math.atan2(-v343.X, -v343.Z), -0.4537856055185257, 0.4537856055185257)
        local v351 = math.clamp(math.atan2(v343.Y, (math.sqrt(v343.X ^ 2 + v343.Z ^ 2))), -0.2792526803190927, 0.2792526803190927)
        local v353 = 1 - math.exp(-p152 * (if p151 < v2.Lock then 18
            elseif p151 < v2.Lock + 0.35 then 22
            elseif not (v2.Lift <= p151 and p151 < v2.Dissolve - 0.3) then 7
            else 14))

        Eye.Look = Eye.Look:Lerp(Vector2.new(v351, v347), v353)

        if Eye.Pupil then
            Eye.Pupil:PivotTo(v340 * CFrame.Angles(Eye.Look.X, Eye.Look.Y, 0))
        end

        if Eye.Sclera then
            local v354 = Kit.Window(p151, v2.EyeOpen, v2.EyeOpen + 0.25) * (1 - Kit.Window(p151, v2.EyeOpen + 0.3, v2.EyeOpen + 1.2))
            local v356 = math.sin(3.141592653589793 * Kit.Window(p151, v2.Lock, v2.Lock + 0.6))

            Eye.Sclera.Color = Eye.ScleraColor:Lerp(v11, (math.clamp(math.max(v354, v356) * 0.6 + (v338 - 1) * 2, 0, 1)))
        end
    end
end

local function stepRift(p153, p154) -- line: 1892
    -- upvalues: Kit (copy), v2 (copy), scaleSequence (copy)
    local v358 = Kit.Ease(Kit.Window(p154, v2.Tear, v2.Tear + 0.9), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local v359 = Kit.Smooth(Kit.Window(p154, v2.Merge, v2.Implode))
    local v360 = Kit.Window(p154, v2.Implode, v2.Implode + 0.3)
    local v361 = v358 * (1 + 0.12 * v359) * (1 - Kit.Ease(v360, Enum.EasingStyle.Quad, Enum.EasingDirection.In))

    if v2.Tear <= p154 and v360 < 1 and (not p153.RiftGrow or math.abs(p153.RiftGrow - v361) > 0.004) then
        p153.RiftGrow = v361

        for _, v364 in p153.RiftDiscs do
            v364.Emitter.Size = scaleSequence(v364.Size, (math.max(v361, 0.02)))
        end
    end

    local v365 = Kit.Smooth(Kit.Window(p154, v2.Merge - 0.4, v2.Merge + 0.6))
    local Hush = p153.Hush
    local v366 = if Hush then math.abs(p153.Hush - v365) > 0.02 else nil

    if not Hush or v366 then
        p153.Hush = v365

        for _, v368 in p153.MergeDim do
            v368.Emitter.Brightness = v368.Brightness * Kit.Lerp(1, v368.Dim, v365)
            v368.Emitter.LightEmission = v368.LightEmission * Kit.Lerp(1, v368.Dim, v365)
        end

        for _, v369 in p153.VortexGlow do
            v369.Emitter.Brightness = v369.Brightness * Kit.Lerp(1, 0.55, v365)
        end
    end

    if p153.RiftLight then
        local v370 = 1 + 0.18 * math.noise(p154 * 7, 3.1)

        p153.RiftLight.Brightness = (v358 * 2.4 + v359 * 1.8) * (1 - v360) * v370
    end

    local Tear = p153.Tear

    if not Tear then
        return
    end

    local v371 = Kit.Ease(Kit.Window(p154, v2.Crack, v2.Tear), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v372 = Kit.Window(p154, v2.Tear, v2.Tear + 0.45)
    local v373 = v371 > 0 and v372 < 1
    local v374 = p153.RiftSize * (0.12 + 0.38 * v371 + 0.2 * v372)

    Tear.Bottom.WorldPosition = p153.Center - Vector3.new(0, 1, 0) * v374
    Tear.Top.WorldPosition = p153.Center + Vector3.new(0, 1, 0) * v374

    for _, v375 in Tear.Beams do
        v375.Beam.Enabled = v373

        local v376 = v375.Width * (v371 * (1 - v372) + v372 * 3.5 * (1 - v372))
        local v377 = 1 + 0.25 * math.noise(p154 * 30, v375.Width)

        v375.Beam.Width0 = v376 * v377
        v375.Beam.Width1 = v376 * v377
    end
end

local function energy(p155) -- line: 1948
    -- upvalues: Kit (copy), v2 (copy)
    return Kit.Smooth(Kit.Window(p155, v2.Link, v2.Lift)) * 0.6 + Kit.Smooth(Kit.Window(p155, v2.Lift, v2.Dissolve)) * 0.4
end

local function stepTethers(p156, p157) -- line: 1953
    -- upvalues: Kit (copy), v2 (copy), axisFrame (copy), sparkleBurst (copy), glowFlare (copy), eyePlug (copy)
    local v378 = Kit.Smooth(Kit.Window(p157, v2.Link, v2.Lift)) * 0.6 + Kit.Smooth(Kit.Window(p157, v2.Lift, v2.Dissolve)) * 0.4

    for _, v379 in p156.Tethers do
        local Pet = v379.Pet
        local v380 = Kit.Ease(Kit.Window(p157, v379.LinkAt, v379.LinkAt + 0.38), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local v381 = Pet.Gone or not Pet.Model.Parent
        local v382 = if Pet.RetractAt then Kit.Window(p157, Pet.RetractAt, Pet.RetractAt + 0.35) else 0
        local v383 = v380 > 0 and v382 < 1
        local CorePosition = Pet.Core.Position
        local v384, v385 = eyePlug(p156, Pet)
        local Magnitude = (v384 - CorePosition).Magnitude
        local v386 = axisFrame(CorePosition, Vector3.new(0, 1, 0) + p156.Side * 0.15)
        local v387 = axisFrame(v384, v385)
        local v388 = Magnitude * 0.5
        local v389 = Magnitude * 0.42
        local Position = v386.Position
        local Position2 = v387.Position
        local v390 = Position + v386.XVector * v388
        local v391 = Position2 - v387.XVector * v389
        local v392 = 1 - v380
        local v393 = Position * (v392 * v392 * v392) + v390 * (v392 * 3 * v392 * v380) + v391 * (v392 * 3 * v380 * v380) + Position2 * (v380 * v380 * v380)
        local v394 = Kit.Ease(v382, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v395 = 1 - v394
        local v396 = Position * (v395 * v395 * v395) + v390 * (v395 * 3 * v395 * v394) + v391 * (v395 * 3 * v394 * v394) + Position2 * (v394 * v394 * v394)

        v379.A0.WorldCFrame = axisFrame(v396, v386.XVector)
        v379.A1.WorldCFrame = axisFrame(v393, v387.XVector)

        local v398 = math.max(v380 - v382, 0)
        local v401 = math.max(math.sin((p157 - v379.LinkAt) * 5.2), 0) * 0.35 * v378 + 1
        local v402 = if Pet.DissolveAt then Kit.Window(p157, Pet.DissolveAt, Pet.DissolveAt + 0.4) else 0

        for _, v403 in v379.Beams do
            local Beam = v403.Beam

            Beam.Enabled = v383 and not v381

            local v404 = v403.Width * (v378 * 0.75 + 0.55 + 0.6 * v402) * v401

            Beam.Width0 = v404 * (1 - v382)
            Beam.Width1 = v404 * 0.6 * v398
            Beam.CurveSize0 = v388 * v398
            Beam.CurveSize1 = v389 * v398
            Beam.TextureSpeed = (v403.Width > 4 and 0.9 or 2.2) * (1 + 2.5 * v402)
        end

        local v405 = v383 and not v381 and v380 > 0.92

        v379.Plug.CFrame = CFrame.lookAt(Position2, Position2 + v387.XVector)
        v379.PlugGlow.Enabled = v405
        v379.PlugSparks.Enabled = v405

        if v405 then
            local v406 = (v378 * 0.5 + 0.8 + 0.4 * v402) * v401

            v379.PlugGlow.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2.6 * v406),
                NumberSequenceKeypoint.new(1, 1.6 * v406)
            })
            v379.PlugSparks.Rate = v378 * 30 + 14 + 30 * v402
        end

        if v380 >= 1 and not v379.Plugged then
            v379.Plugged = true
            glowFlare(p156, Position2, Pet.Hot, 6, 0.4)
            sparkleBurst(p156, Position2, Pet.Hot, 16, 14)
        end

        for _, v407 in v379.Pulses do
            local v408 = ((p157 - v379.LinkAt) * (v378 * 0.9 + 0.55 + v402) + v407.Offset) % 1
            local v409 = v383

            if v383 then
                v409 = not v381

                if v409 then
                    v409 = v380 >= 1 and v382 < v408
                end
            end

            local Part = v407.Part
            local new = CFrame.new
            local v410 = 1 - v408

            Part.CFrame = new(Position * (v410 * v410 * v410) + v390 * (v410 * 3 * v410 * v408) + v391 * (v410 * 3 * v408 * v408) + Position2 * (v408 * v408 * v408))

            local ParticleEmitter = v407.Part:FindFirstChildOfClass("ParticleEmitter")

            if ParticleEmitter then
                ParticleEmitter.Enabled = v409
            end
        end
    end
end

local function fadePet(p158, p159) -- line: 2021
    if not (p158.Faded and math.abs(p158.Faded - p159) < 0.01) then
        p158.Faded = p159

        for _, v413 in p158.Parts do
            v413.LocalTransparencyModifier = p159
        end
    end
end

local function stepPets(p160, p161) -- line: 2031
    -- upvalues: Kit (copy), v2 (copy), v29 (copy), sound (copy), sparkleBurst (copy), glowFlare (copy), petOrbit (copy), makeWisp (copy)
    local elapsed = os.clock()

    for _, v414 in p160.Pets do
        if not v414.Gone then
            local Model = v414.Model
            local v415 = v2.Pulse + (v414.Order - 1) * 0.18
            local v416 = Kit.Window(p161, v415, v415 + 0.45)
            local v418 = 1 + math.sin(3.141592653589793 * v416) * 0.16 * (1 - v416 * 0.3)
            local v420 = math.sin(elapsed * 1.7 + v414.Bob) * 0.45
            local v421 = Kit.Window(p161, v414.DissolveAt, v414.DissolveAt + 1.9)
            local v422 = Kit.Ease(v421, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local v423, v424 = petOrbit(p160, v414, p161)
            local v425 = if p160.EyeNow then p160.EyeNow.Position else p160.Center
            local v430 = Vector3.new(math.noise(p161 * 18, v414.Order), math.noise(p161 * 18, v414.Order + 9.1), math.noise(p161 * 18, v414.Order + 3.7)) * 0.35 * Kit.Window(v421, 0, 0.3)
            local v431 = v424 + v422 * v422 * 3.141592653589793 * 1.4
            local v432 = (v423 + Vector3.new(0, 1, 0) * v420):Lerp(v425, 0.92 * v422 ^ 1.6) + v430

            Model:PivotTo(CFrame.new(v432) * v414.Home.Rotation * CFrame.Angles(0, v431, 0))

            local v433 = v414.Base * v418 * (1 - 0.78 * v422)

            if math.abs(Model:GetScale() - v433) > 0.001 then
                Model:ScaleTo((math.max(v433, 0.01)))
            end

            v414.Core.CFrame = CFrame.new(v432 + Vector3.new(0, 1, 0) * v414.Height * 0.45 * (1 - 0.6 * v422))

            local v435 = Kit.Window(v421, 0, 0.3)

            v414.Highlight.FillTransparency = 1 - 0.8 * v435 * (1 - Kit.Window(v421, 0.75, 1))
            v414.Highlight.OutlineTransparency = 1 - 0.9 * v435 * (1 - Kit.Window(v421, 0.6, 0.95))

            local v436 = Kit.Window(v421, 0.35, 0.95)

            if not v414.Faded or not (math.abs(v414.Faded - v436) < 0.01) then
                v414.Faded = v436

                for _, v439 in v414.Parts do
                    v439.LocalTransparencyModifier = v436
                end
            end

            local v442 = math.sin(3.141592653589793 * math.clamp(v421 * 1.15, 0, 1))
            local Energy = v414.Energy

            if v421 > 0 then
                Energy.Enabled = v421 < 1
            else
                Energy.Enabled = false
            end

            v414.Energy.Rate = v442 * 70
            v414.Energy.Acceleration = (p160.Center - v432).Unit * 75

            local Motes = v414.Motes

            if v421 > 0 then
                Motes.Enabled = v421 < 0.95
            else
                Motes.Enabled = false
            end

            v414.Motes.Rate = v442 * 60
            v414.Glow.Brightness = math.sin(3.141592653589793 * v416) * 1.5 + v442 * 3.2

            if v421 > 0 and not v414.FxOff then
                v414.FxOff = true

                for _, v444 in v414.Fx do
                    v444.Enabled = false
                end

                sound(p160, "Dissolve", v432, 0.8, 0.94 + v414.Order * 0.03)
                sparkleBurst(p160, v432, v414.Hot, 30, 16)
                glowFlare(p160, v432 + Vector3.new(0, 1, 0) * v414.Height * 0.3, v414.Hot, v414.Height * 1.4, 0.5)
                v414.NextWisp = 0
            end

            if v421 > 0 and v421 < 0.85 and v414.NextWisp and v414.NextWisp < 7 and v414.NextWisp / 7 * 0.85 <= v421 then
                v414.NextWisp += 1

                local _, BoundingBox = Model:GetBoundingBox()

                makeWisp(p160, v414, v432 + Vector3.new(v29:NextNumber(-0.5, 0.5) * BoundingBox.X, v29:NextNumber(0, 0.8) * BoundingBox.Y, v29:NextNumber(-0.5, 0.5) * BoundingBox.Z))
            end

            if v421 >= 0.82 and not v414.RetractAt then
                v414.RetractAt = p161
            end

            if v421 >= 1 then
                v414.Gone = true
                Model.Parent = nil
                v414.Energy.Enabled = false
                v414.Motes.Enabled = false
                v414.Highlight.Enabled = false
                v414.Glow.Brightness = 0
            end
        end
    end
end

local function stepPads(p162, p163) -- line: 2111
    -- upvalues: Kit (copy), v2 (copy)
    local v448 = Kit.Smooth(Kit.Window(p163, v2.Link, v2.Lift)) * 0.6 + Kit.Smooth(Kit.Window(p163, v2.Lift, v2.Dissolve)) * 0.4

    for _, v449 in p162.PadFx do
        local Pet = v449.Pet
        local v450 = v2.Pulse + (Pet.Order - 1) * 0.18
        local v452 = math.sin(3.141592653589793 * Kit.Window(p163, v450, v450 + 0.5))
        local v453 = 1 - Kit.Window(p163, Pet.DissolveAt + 1.2, Pet.DissolveAt + 2.2)
        local v454 = 1 + 0.15 * math.noise(p163 * 6, Pet.Order * 2.3)

        v449.Light.Brightness = (v452 * 2.6 + 0.6 + v448 * 1.6) * v453 * v454

        local Column = v449.Column

        if v450 <= p163 then
            Column.Enabled = v453 > 0.05
        else
            Column.Enabled = false
        end

        v449.Column.Rate = (v448 * 24 + 6) * v453

        local Runes = v449.Runes

        if v2.Link <= p163 then
            Runes.Enabled = v453 > 0.05
        else
            Runes.Enabled = false
        end

        v449.Runes.Rate = v448 * 1.4 + 0.9
    end
end

local function orbitPoint(p164, p165, p166) -- line: 2127
    -- upvalues: Kit (copy), v2 (copy)
    local v455 = 1 - 0.12 * Kit.Smooth(Kit.Window(p166, v2.Merge, v2.Return))
    local v457 = p164.OrbitHub + p164.Across * (math.cos(p165.Angle) * p165.RadiusX * v455) + p164.Side * (math.sin(p165.Angle) * p165.RadiusZ * v455)
    local v461 = p165.Height + math.sin(p165.Angle * 2 + p165.Phase) * p165.Tilt + math.sin(p166 * 1.7 + p165.Phase) * 0.5
    local v462 = Vector3.new(v457.X, v461, v457.Z)

    return (Vector3.new(math.clamp(v462.X, p164.Low.X + 1, p164.High.X - 1), math.clamp(v462.Y, p164.Floor + 1.6, p164.Ceiling - 1.6), (math.clamp(v462.Z, p164.Low.Z + 1, p164.High.Z - 1))))
end

local function stepProps(p167, p168, p169) -- line: 2139
    -- upvalues: Workspace (copy), Kit (copy), v1 (copy), v2 (copy), v28 (copy), v29 (copy), sound (copy), burst (copy), freeProps (copy), orbitPoint (copy)
    if #p167.Props == 0 then
        return
    end

    if not p167.PropsFree and v2.Rattle <= p168 then
        freeProps(p167)
    end

    if p167.PropsFree then
        local v472 = Kit.Smooth(Kit.Window(p168, v2.Merge, v2.Return))
        local v473 = (Kit.Smooth(Kit.Window(p168, v2.Link, v2.Lift)) * 0.6 + Kit.Smooth(Kit.Window(p168, v2.Lift, v2.Dissolve)) * 0.4) * 0.45 + 0.35 + 0.55 * v472
        local t39 = {}
        local t40 = {}

        for _, v474 in p167.Props do
            if not v474.Landed then
                local Home = v474.Home

                if p168 < v474.RattleAt then
                    v474.Pose = Home

                    for _, v475 in v474.Parts do
                        if v475.Part.Parent then
                            table.insert(t39, v475.Part)
                            table.insert(t40, Home * v475.Rel)
                        end
                    end
                elseif p168 < v474.LiftAt then
                    local v477 = Kit.Window(p168, v474.RattleAt, v474.LiftAt)
                    local Seed = v474.Seed
                    local v479 = math.max(math.noise(p168 * 14, Seed), 0) * 0.35 * v477
                    local v480 = Home * CFrame.new(0, v479, 0) * CFrame.Angles(math.noise(p168 * 12, Seed + 1) * 0.15707963267948966 * v477, math.noise(p168 * 12, Seed + 2) * 0.10471975511965978 * v477, math.noise(p168 * 12, Seed + 3) * 0.15707963267948966 * v477)

                    if not v474.Rattled and v477 > 0.3 then
                        v474.Rattled = true
                        p167.RattleCount += 1

                        if p167.RattleCount <= 4 then
                            sound(p167, v28[p167.RattleCount], Home.Position, 0.8, v29:NextNumber(0.9, 1.12))
                        end
                    end

                    v474.Pose = v480

                    for _, v481 in v474.Parts do
                        if v481.Part.Parent then
                            table.insert(t39, v481.Part)
                            table.insert(t40, v480 * v481.Rel)
                        end
                    end
                else
                    local v483 = v474.LiftAt + v474.LiftSeconds
                    local v484 = Kit.Window(p168, v474.LiftAt, v483)
                    local v485 = Kit.Smooth(v484)

                    v474.Angle += v473 * p169 * v485
                    v474.Rot *= CFrame.fromAxisAngle(v474.Axis, v474.SpinRate * p169 * v485 * (1 + v472))

                    local v486 = orbitPoint(p167, v474, p168)
                    local v487 = Home.Rotation * v474.Rot

                    if v484 < 1 then
                        local v488 = Kit.Ease(v484, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                        v486 = Kit.Bezier(Home.Position, Home.Position + Vector3.new(0, 1, 0) * (5 + v474.Extent), v486, v488)
                    end

                    if v474.ReturnAt <= p168 then
                        if not v474.From then
                            v474.From = v486
                            v474.FromRot = v487
                        end

                        local v489 = Kit.Window(p168, v474.ReturnAt, v474.ReturnAt + v474.ReturnSeconds)
                        local v490 = Home.Position + Vector3.new(0, 1, 0) * (if v474.Slam then 3.2 else 1)

                        if v489 < 0.78 then
                            local v491 = Kit.Ease(v489 / 0.78, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                            local v492 = (v474.From + v490) / 2 + Vector3.new(0, 3, 0)

                            v486 = Kit.Bezier(v486, v492, v490, v491)
                            v487 = v474.FromRot:Lerp(Home.Rotation, Kit.Smooth(v489 / 0.78))
                        else
                            local v493 = (v489 - 0.78) / 0.22
                            local v494 = if v474.Slam then v493 * v493 else Kit.Ease(v493, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

                            v486 = v490:Lerp(Home.Position, v494)
                            v487 = Home.Rotation
                        end

                        if v489 >= 1 then
                            v474.Landed = true

                            for _, v495 in v474.Parts do
                                if v495.Part.Parent then
                                    table.insert(t39, v495.Part)
                                    table.insert(t40, v495.CFrame)
                                end
                            end

                            p167.LandCount += 1

                            if v474.Slam or p167.LandCount % 3 == 0 then
                                burst(p167, Home.Position - Vector3.new(0, 0.2, 0), {
                                    LightEmission = 0,
                                    Drag = 3,
                                    Texture = v1.Smoke,
                                    FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
                                    FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
                                    Color = ColorSequence.new(Color3.fromRGB(150, 128, 170)),
                                    EmissionDirection = Enum.NormalId.Top,
                                    SpreadAngle = Vector2.new(80, 80),
                                    Speed = NumberRange.new(2, 5),
                                    Lifetime = NumberRange.new(0.5, 0.9),
                                    Rotation = NumberRange.new(0, 360),
                                    Size = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 0.6),
                                        NumberSequenceKeypoint.new(1, 2.2)
                                    }),
                                    Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 0.55),
                                        NumberSequenceKeypoint.new(1, 1)
                                    })
                                }, 6)
                            end

                            if p167.LandCount == 1 or p167.LandCount == 7 or p167.LandCount == 15 then
                                sound(p167, "PropsLand", Home.Position, 0.9, v29:NextNumber(0.92, 1.08))
                            end
                        else
                            Home = CFrame.new(v486) * v487
                            v474.Pose = Home

                            for _, v497 in v474.Parts do
                                if v497.Part.Parent then
                                    table.insert(t39, v497.Part)
                                    table.insert(t40, Home * v497.Rel)
                                end
                            end
                        end
                    else
                        Home = CFrame.new(v486) * v487
                        v474.Pose = Home

                        for _, v499 in v474.Parts do
                            if v499.Part.Parent then
                                table.insert(t39, v499.Part)
                                table.insert(t40, Home * v499.Rel)
                            end
                        end
                    end
                end
            end
        end

        if #t39 > 0 then
            Workspace:BulkMoveTo(t39, t40, Enum.BulkMoveMode.FireCFrameChanged)
        end
    end
end

local function dimAmount(p170) -- line: 2277
    -- upvalues: Kit (copy), v2 (copy)
    return Kit.Smooth(Kit.Window(p170, v2.Crack - 0.3, v2.EyeOpen + 0.4)) * (1 - 0.75 * Kit.Smooth(Kit.Window(p170, v2.Flash + 0.2, v2.Egg + 2.4)))
end

local function stepLights(p171, p172) -- line: 2283
    -- upvalues: Kit (copy), v2 (copy), v13 (copy), v14 (copy), v15 (copy), v20 (copy), v21 (copy), v22 (copy), dimAmount (copy)
    local v501 = dimAmount(p172)
    local v502 = if p172 < v2.Flash then 0 elseif p172 < v2.Flash + 0.06 then (p172 - v2.Flash) / 0.06 else math.exp(-(p172 - v2.Flash - 0.06) / 0.12)
    local v504 = Kit.Smooth(Kit.Window(p172, v2.Merge - 0.3, v2.Narrow)) * (1 - Kit.Smooth(Kit.Window(p172, v2.Egg - 0.3, v2.Egg + 0.8)))
    local v507 = math.max(math.sin(3.141592653589793 * Kit.Window(p172, v2.Crack, v2.EyeOpen + 0.4)), Kit.Window(p172, v2.Build, v2.Rattle)) * (1 - Kit.Window(p172, v2.Egg, v2.Egg + 1))

    for _, v508 in p171.Lights do
        local Light = v508.Light

        if Light.Parent then
            local v511 = 1 - v507 * 0.55 * math.max(math.noise(p172 * 9, v508.Seed), 0) * 1.6

            Light.Brightness = v508.Brightness * Kit.Lerp(1, 0.32, v501) * math.max(v511, 0.15) * (1 + 0.9 * v502)
            Light.Color = v508.Color:Lerp(v14, (math.max(v501 * 0.75, v502)))
        end
    end

    local v513 = if p171.ImpactAt then p172 - p171.ImpactAt else -1
    local v514 = if v513 < 0 then 0 elseif v513 < 0.05 then 1 else math.exp(-(v513 - 0.05) / 0.1)
    local Grade = p171.Grade

    if Grade then
        Grade.TintColor = v15:Lerp(v13, v501):Lerp(v21, v504):Lerp(v20, v502):Lerp(v22, v514)
        Grade.Brightness = v501 * -0.06 - 0.06 * v504 + 0.08 * v502 + v514 * 0.12
        Grade.Contrast = v501 * 0.1 + 0.14 * v504 + 0.2 * v502 + v514 * 0.5
        Grade.Saturation = v501 * 0.1 + 0.15 * v504 + 0.25 * v502 - v514 * 0.45
    end

    if p171.Motes then
        p171.Motes.Enabled = v501 > 0.02
        p171.Motes.Rate = v501 * 40
    end
end

local function tintPart(p173, p174, p175, p176) -- line: 2328
    -- upvalues: v8 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Adornee = p174
    Highlight.FillColor = p175
    Highlight.FillTransparency = p176
    Highlight.OutlineColor = v8
    Highlight.OutlineTransparency = 0.35
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Parent = p173
end

local function voidSkin(p177, p178) -- line: 2339
    -- upvalues: v1 (copy), v8 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), partsOf (copy)
    for _, descendant in p177:GetDescendants() do
        if descendant:IsA("SurfaceAppearance") then
            descendant:Destroy()
        elseif descendant:IsA("Decal") then
            descendant:Destroy()
        elseif descendant:IsA("Texture") then
            descendant:Destroy()
        end
    end

    for _, v516 in partsOf(p177) do
        if not (v516.Transparency >= 0.99) then
            v516.Reflectance = 0

            if v516.Name == p178.Shell then
                v516.Color = v18
                v516.Material = Enum.Material.SmoothPlastic

                if v516:IsA("MeshPart") then
                    v516.TextureID = v1.EggVeins
                end

                local Highlight = Instance.new("Highlight")

                Highlight.Adornee = v516
                Highlight.FillColor = v16
                Highlight.FillTransparency = 0.8
                Highlight.OutlineColor = v8
                Highlight.OutlineTransparency = 0.35
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight.Parent = p177
            elseif v516.Name == p178.Gold then
                v516.Color = v17
                v516.Material = Enum.Material.Foil

                local Highlight = Instance.new("Highlight")

                Highlight.Adornee = v516
                Highlight.FillColor = v17
                Highlight.FillTransparency = 0.35
                Highlight.OutlineColor = v8
                Highlight.OutlineTransparency = 0.35
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight.Parent = p177
            else
                v516.Color = v19
                v516.Material = Enum.Material.SmoothPlastic

                local Highlight = Instance.new("Highlight")

                Highlight.Adornee = v516
                Highlight.FillColor = v19
                Highlight.FillTransparency = 0.3
                Highlight.OutlineColor = v8
                Highlight.OutlineTransparency = 0.35
                Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                Highlight.Parent = p177
            end
        end
    end
end

local function makeEgg(p179, p180) -- line: 2369
    -- upvalues: Kit (copy), v10 (copy), v23 (copy), voidSkin (copy)
    local v517 = Kit.EggModel(p179.Fused, p180 or 6, v10)
    local v518 = v23[p179.Fused]

    if v518 then
        voidSkin(v517, v518)
    end

    v517.Parent = p179.Container

    return v517
end

local function buildEgg(p181) -- line: 2379
    -- upvalues: Kit (copy), v1 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v15 (copy), v17 (copy), v23 (copy), v29 (copy), voidSkin (copy)
    local v519 = Kit.EggModel(p181.Fused, 8, v10)
    local v520 = v23[p181.Fused]

    if v520 then
        voidSkin(v519, v520)
    end

    v519.Parent = p181.Container

    local Scale = v519:GetScale()

    v519:ScaleTo(Scale * 0.02)

    local v521 = CFrame.new(p181.Center)
    local v522 = Kit.Part({
        Name = "EggDressing",
        Transparency = 1,
        Size = Vector3.new(12, 0.4, 12),
        CFrame = v521
    })

    v522.Parent = p181.Container

    local function emit(p182, p183) -- line: 2386
        -- upvalues: v522 (copy), Kit (copy)
        local v523 = Kit.Emitter(p183 or v522, p182)

        v523.Enabled = false

        return v523
    end

    local v524 = CFrame.new(p181.Center)
    local v525 = Kit.Part({
        Name = "EggBackdrop",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = v524
    })

    v525.Parent = p181.Container

    local t42 = {}

    for i = 1, 4 do
        local v527 = math.rad((i - 1) * 100 + -150 + (if i > 2 then 20 else 0))
        local Side = p181.Side
        local v528 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v527):VectorToWorldSpace(Side) * 8 * 0.95 + Vector3.new(0, 1, 0) * (if i % 2 == 0 then 1.6 else -0.4)
        local v529 = CFrame.new(p181.Center + v528)
        local v530 = Kit.Part({
            Name = "EggLantern",
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2),
            CFrame = v529
        })

        v530.Parent = p181.Container

        local t43 = {
            Part = v530,
            Offset = v528
        }
        local t44 = {
            LightEmission = 0.8,
            Brightness = 2,
            Rate = 26,
            ZOffset = 0.3,
            Texture = v1.Flame,
            FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
            FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
            Color = ColorSequence.new(if i % 2 == 0 then v9 else v11, v10),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(12, 12),
            Speed = NumberRange.new(4, 6),
            Lifetime = NumberRange.new(0.5, 0.75),
            Rotation = NumberRange.new(-8, 8),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.6),
                NumberSequenceKeypoint.new(1, 2.6)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.7, 0.35),
                NumberSequenceKeypoint.new(1, 1)
            })
        }
        local v531 = Kit.Emitter(v530 or v522, t44)

        v531.Enabled = false
        t43.Fire = v531

        local t45 = {
            LightEmission = 0.7,
            Rate = 0.9,
            ZOffset = 0.5,
            Texture = v1.Lantern,
            Color = ColorSequence.new(if i % 2 == 0 then v9 else v15),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(20, 20),
            Speed = NumberRange.new(0.8, 1.6),
            Lifetime = NumberRange.new(1.6, 2.2),
            Rotation = NumberRange.new(-12, 12),
            RotSpeed = NumberRange.new(-14, 14),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.2, 2.4),
                NumberSequenceKeypoint.new(1, 2.9)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.1),
                NumberSequenceKeypoint.new(0.75, 0.25),
                NumberSequenceKeypoint.new(1, 1)
            })
        }
        local v532 = Kit.Emitter(v530 or v522, t45)

        v532.Enabled = false
        t43.Emitter = v532
        table.insert(t42, t43)
    end

    local t46 = {
        Part = v522,
        Back = v525,
        Lanterns = t42
    }
    local t47 = {
        LightEmission = 0.55,
        LockedToPart = true,
        Rate = 2.5,
        ZOffset = -3,
        Texture = v1.Swirl,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        Color = ColorSequence.new(v10, v12),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(1.6),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-70, -40),
        Size = NumberSequence.new(24),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.2),
            NumberSequenceKeypoint.new(0.7, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v533 = Kit.Emitter(v525 or v522, t47)

    v533.Enabled = false
    t46.Backdrop = v533

    local t48 = {
        LightEmission = 0.6,
        LockedToPart = true,
        Rate = 2,
        ZOffset = -4,
        Texture = v1.Glow,
        Color = ColorSequence.new(v10),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(1.2),
        Size = NumberSequence.new(27.2),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.4, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v534 = Kit.Emitter(v525 or v522, t48)

    v534.Enabled = false
    t46.BackGlow = v534

    local t49 = {
        Drag = 1,
        Rate = 80,
        LightEmission = 0.8,
        Brightness = 2,
        ZOffset = -0.5,
        Texture = v1.Flame,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v11),
            ColorSequenceKeypoint.new(0.5, v10),
            ColorSequenceKeypoint.new(1, v12)
        }),
        Shape = Enum.ParticleEmitterShape.Disc,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(7, 11),
        Lifetime = NumberRange.new(0.6, 0.9),
        Rotation = NumberRange.new(-10, 10),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(1, 5)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v535 = Kit.Emitter(v522, t49)

    v535.Enabled = false
    t46.Flames = v535

    local t50 = {
        Drag = 1,
        Rate = 40,
        LightEmission = 0.8,
        Brightness = 2,
        ZOffset = -0.4,
        Texture = v1.Flame,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new(v9, v8),
        Shape = Enum.ParticleEmitterShape.Disc,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(6, 9),
        Lifetime = NumberRange.new(0.5, 0.75),
        Rotation = NumberRange.new(-10, 10),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.8),
            NumberSequenceKeypoint.new(1, 3.2)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v536 = Kit.Emitter(v522, t50)

    v536.Enabled = false
    t46.BoneFlames = v536

    local t51 = {
        LightEmission = 0.5,
        Rate = 10,
        Texture = v1.Shard,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new(v11, v8),
        Shape = Enum.ParticleEmitterShape.Sphere,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
        Speed = NumberRange.new(0.6, 1.6),
        Lifetime = NumberRange.new(1.4, 2.2),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-90, 90),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.2, 1.1),
            NumberSequenceKeypoint.new(0.8, 0.8),
            NumberSequenceKeypoint.new(1, 0)
        })
    }
    local v537 = Kit.Emitter(v522, t51)

    v537.Enabled = false
    t46.Shards = v537

    local t52 = {
        Rate = 16,
        ZOffset = 1,
        Texture = v1.Sparkle,
        Color = ColorSequence.new(v15, v11),
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(1, 3),
        Lifetime = NumberRange.new(0.6, 1.2),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 0)
        })
    }
    local v538 = Kit.Emitter(v522, t52)

    v538.Enabled = false
    t46.Shimmer = v538

    local t53 = {
        Rate = 120,
        ZOffset = 1,
        Texture = v1.Spark,
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        Color = ColorSequence.new(v9, v11),
        Shape = Enum.ParticleEmitterShape.Sphere,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
        ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward,
        Speed = NumberRange.new(18, 30),
        Lifetime = NumberRange.new(0.3, 0.45),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.3, 1.2),
            NumberSequenceKeypoint.new(1, 0)
        })
    }
    local v539 = Kit.Emitter(v522, t53)

    v539.Enabled = false
    t46.Condense = v539

    local v540 = CFrame.new(p181.Center)
    local v541 = Kit.Part({
        Name = "EggCore",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = v540
    })

    v541.Parent = p181.Container
    t46.Core = v541

    local v542 = CFrame.new(p181.Center)
    local v543 = Kit.Part({
        Name = "EggEmbers",
        Transparency = 1,
        Size = Vector3.new(7.2, 7.2, 7.2),
        CFrame = v542
    })

    v543.Parent = p181.Container
    t46.EmberHost = v543

    local t54 = {
        LockedToPart = true,
        Rate = 50,
        ZOffset = 2,
        Texture = v1.Glow,
        Color = ColorSequence.new(v15, v11),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.12),
        Size = NumberSequence.new(1),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 0.6)
        })
    }
    local v544 = Kit.Emitter(v541 or v522, t54)

    v544.Enabled = false
    t46.CoreGlow = v544

    local t55 = {
        LightEmission = 0.7,
        LockedToPart = true,
        Rate = 9,
        ZOffset = 1.5,
        Texture = v1.Swirl,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.Loop,
        FlipbookFramerate = NumberRange.new(24),
        Color = ColorSequence.new(v11, v10),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.45),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(300, 420),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 15.2),
            NumberSequenceKeypoint.new(1, 0.4)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.35, 0.3),
            NumberSequenceKeypoint.new(1, 0.9)
        })
    }
    local v545 = Kit.Emitter(v541 or v522, t55)

    v545.Enabled = false
    t46.SwirlIn = v545

    local t56 = {
        Acceleration = Vector3.new(0, 3.5, 0),
        Drag = 0.6,
        Rate = 26,
        ZOffset = 1,
        Texture = v1.Glow,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v17),
            ColorSequenceKeypoint.new(0.4, v11),
            ColorSequenceKeypoint.new(1, v10)
        }),
        Shape = Enum.ParticleEmitterShape.Sphere,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(0.6, 2.4),
        Lifetime = NumberRange.new(1.4, 2.4),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.15, 0.4),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.7, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local EmberHost = t46.EmberHost
    local v546 = Kit.Emitter(EmberHost or v522, t56)

    v546.Enabled = false
    t46.Embers = v546

    local t57 = {}

    for i = 1, 10 do
        local v547 = CFrame.new(p181.Center)
        local v548 = Kit.Part({
            Name = "EggSpiral",
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2),
            CFrame = v547
        })

        v548.Parent = p181.Container

        local Attachment = Instance.new("Attachment")

        Attachment.Position = Vector3.new(0, 0.3, 0)
        Attachment.Parent = v548

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Position = Vector3.new(0, -0.3, 0)
        Attachment2.Parent = v548

        local v549 = if i % 2 == 0 then v9 else v11
        local Trail = Instance.new("Trail")

        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment2
        Trail.Texture = v1.Glow
        Trail.TextureMode = Enum.TextureMode.Stretch
        Trail.Color = ColorSequence.new(v549, v10)
        Trail.Transparency = NumberSequence.new(0.1, 1)
        Trail.WidthScale = NumberSequence.new(1, 0.2)
        Trail.Lifetime = 0.22
        Trail.MinLength = 0.05
        Trail.LightEmission = 1
        Trail.LightInfluence = 0
        Trail.FaceCamera = true
        Trail.Enabled = false
        Trail.Parent = v548

        local t58 = {
            Part = v548,
            Trail = Trail,
            Angle = (i - 1) / 10 * 3.141592653589793 * 2,
            Reach = v29:NextNumber(0.85, 1.15),
            Lag = v29:NextNumber(0, 0.12)
        }
        local t59 = {
            LockedToPart = true,
            Rate = 30,
            ZOffset = 1.5,
            Texture = v1.Flare,
            FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
            FlipbookMode = Enum.ParticleFlipbookMode.Loop,
            Color = ColorSequence.new(v549),
            Speed = NumberRange.new(0),
            Lifetime = NumberRange.new(0.14),
            Size = NumberSequence.new(1.4),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(1, 1)
            })
        }
        local v550 = Kit.Emitter(v548 or v522, t59)

        v550.Enabled = false
        t58.Glint = v550
        table.insert(t57, t58)
    end

    t46.Spiral = t57

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v11
    PointLight.Range = 20
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = v522
    t46.Light = PointLight

    local PointLight2 = Instance.new("PointLight")

    PointLight2.Color = v8
    PointLight2.Range = 14
    PointLight2.Brightness = 0
    PointLight2.Shadows = false
    PointLight2.Parent = v525
    t46.Rim = PointLight2
    p181.Egg = {
        Model = v519,
        Full = Scale,
        Dressing = t46
    }
end

local function stepEgg(p184, p185) -- line: 2738
    -- upvalues: Kit (copy), v2 (copy), v3 (copy)
    local Egg = p184.Egg

    if not Egg or p184.PayoffAt and p184.P and p184.P >= v3.Split then
        return
    end

    local Dressing = Egg.Dressing
    local v551 = Kit.Window(p185, v2.Condense, v2.Egg)
    local v552 = v551 > 0 and v551 < 1

    Dressing.Condense.Enabled = v552
    Dressing.Part.Size = Vector3.new(12, 0.4, 12) * (1 + 1.6 * (1 - v551))

    local v553 = Kit.Window(p185, v2.Egg - 0.12, v2.Egg)
    local v556 = (0.8 + 4.6 * v551 * v551) * (1 - 0.8 * v553) + math.sin(p185 * 40) * 0.6 * v551

    Dressing.CoreGlow.Enabled = v552

    if v552 then
        Dressing.CoreGlow.Size = NumberSequence.new((math.max(v556, 0.3)))
    end

    Dressing.SwirlIn.Enabled = v552 and v551 < 0.9

    for _, v557 in Dressing.Spiral do
        local v559 = math.clamp((v551 - v557.Lag) / (1 - v557.Lag), 0, 1)
        local v560 = v552 and v559 > 0 and v559 < 1

        v557.Trail.Enabled = v560
        v557.Glint.Enabled = v560

        if v560 then
            local v561 = 13.6 * v557.Reach * (1 - v559) ^ 1.3
            local v562 = v557.Angle + v559 * 3.141592653589793 * 3.2

            v557.Part.CFrame = CFrame.new(p184.Center + p184.Across * (math.cos(v562) * v561) + Vector3.new(0, 1, 0) * (math.sin(v562) * v561 * 0.8) + p184.Side * (math.sin(v562 * 2) * v561 * 0.25))
        end
    end

    local v565 = p185 - v2.Egg
    local v566 = if v565 <= 0 then 0 elseif v565 > 1.4 then 1 else 1 - math.exp(-7 * v565) * math.cos(14 * v565)
    local v570 = if p184.PayoffAt then math.sin(3.141592653589793 * Kit.Window(os.clock() - p184.PayoffAt, 0, v3.Split)) * 0.18 + 1 else 1
    local v572 = Egg.Full * math.max(v566, 0.02) * v570
    local Model = Egg.Model

    if v566 <= 0 then
        Model.Parent = nil
    else
        if Model.Parent ~= p184.Container then
            Model.Parent = p184.Container
        end

        if math.abs(Model:GetScale() - v572) > 1E-04 then
            Model:ScaleTo(v572)
        end

        local v575 = math.sin(p185 * 2.1) * 0.35
        local v576 = p184.Center + Vector3.new(0, 1, 0) * v575
        local v577 = (p185 - v2.Egg) * 0.9

        Model:PivotTo(CFrame.new(v576) * CFrame.Angles(0, v577, math.sin(p185 * 1.3) * 0.06))
        Egg.Position = v576

        local v580 = v576 - Vector3.new(0, 4, 0)

        Dressing.Part.CFrame = CFrame.new(v580)
        Dressing.EmberHost.CFrame = CFrame.new(v576)
        Dressing.Back.CFrame = CFrame.lookAt(p184.Center - p184.Side * 5 + Vector3.new(0, 0.5, 0), p184.Center + p184.Side * 10)

        for _, v581 in Dressing.Lanterns do
            v581.Part.CFrame = CFrame.new(p184.Center + v581.Offset + Vector3.new(0, 1, 0) * v575 * 0.5)
            v581.Emitter.Enabled = v566 > 0.5
            v581.Fire.Enabled = v566 > 0.3
        end

        Dressing.Flames.Enabled = v566 > 0.2
        Dressing.BoneFlames.Enabled = v566 > 0.2
        Dressing.Shards.Enabled = v566 > 0.4
        Dressing.Shimmer.Enabled = v566 > 0.4
        Dressing.Embers.Enabled = v565 > 0.05
        Dressing.Backdrop.Enabled = v566 > 0.1
        Dressing.BackGlow.Enabled = v566 > 0.1

        local v583 = math.exp(-math.max(v565, 0) / 0.35)

        Dressing.Light.Brightness = v566 * 2.2 + math.sin(p185 * 5) * 0.5 + v583 * 5
        Dressing.Rim.Brightness = v566 * 2.4 + v583 * 2
    end
end

local function flameBurst(p186, p187, p188, p189, p190) -- line: 2824
    -- upvalues: v1 (copy), v10 (copy), v12 (copy), burst (copy)
    burst(p186, p187, {
        LightEmission = 0.85,
        Brightness = 2,
        Drag = 3.5,
        Acceleration = Vector3.new(0, 6, 0),
        ZOffset = 2,
        Texture = v1.Flame,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, p188),
            ColorSequenceKeypoint.new(0.5, v10),
            ColorSequenceKeypoint.new(1, v12)
        }),
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(p190 * 0.5, p190),
        Lifetime = NumberRange.new(0.55, 0.85),
        Rotation = NumberRange.new(-20, 20),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.8),
            NumberSequenceKeypoint.new(1, 4.4)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.6, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, p189)
end

local function floorDust(p191, p192, p193) -- line: 2855
    -- upvalues: Kit (copy), v1 (copy), v11 (copy), v12 (copy)
    for i = 1, p193 do
        local v586 = (i - 1) / p193 * 3.141592653589793 * 2
        local v587 = p191.Across * math.cos(v586) + p191.Side * math.sin(v586)
        local v588 = CFrame.lookAt(p192 + v587 * 2, p192 + v587 * 3)
        local v589 = Kit.Part({
            Name = "VoidDust",
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2),
            CFrame = v588
        })

        v589.Parent = p191.Container
        Kit.Emitter(v589, {
            LightEmission = 0.4,
            Drag = 3,
            Texture = v1.Smoke,
            FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
            FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
            Color = ColorSequence.new(v11, v12),
            EmissionDirection = Enum.NormalId.Front,
            SpreadAngle = Vector2.new(12, 6),
            Speed = NumberRange.new(16, 24),
            Lifetime = NumberRange.new(0.7, 1),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-60, 60),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2),
                NumberSequenceKeypoint.new(1, 5)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.35),
                NumberSequenceKeypoint.new(1, 1)
            })
        }):Emit(2)
        task.delay(3, function() -- line: 2883
            -- upvalues: v589 (copy)
            v589:Destroy()
        end)
    end
end

local function eggBorn(p194) -- line: 2889
    -- upvalues: v1 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v15 (copy), v17 (copy), v22 (copy), sound (copy), kick (copy), burst (copy), flatWave (copy), faceWave (copy), sparkleBurst (copy), glowFlare (copy), shardBurst (copy), flameBurst (copy), floorDust (copy)
    local Center = p194.Center

    p194.ImpactAt = p194.T
    sound(p194, "Boom", Center, 1)
    kick(p194, 1.8)
    p194.FovKick = math.max(p194.FovKick, 1.3)

    local v591 = Vector3.new(Center.X, p194.Floor + 0.3, Center.Z)
    local v593 = Vector3.new(Center.X, p194.PadTop + 0.3, Center.Z)

    flatWave(p194, v591, v11, 60, 0.9)
    flatWave(p194, v591, v8, 38, 0.6)
    floorDust(p194, v591, 14)
    flatWave(p194, v593, v10, 44, 0.75)
    flatWave(p194, Center - Vector3.new(0, 4, 0), v10, 34, 0.8)
    faceWave(p194, Center, v22, 30, 0.35)
    faceWave(p194, Center, v11, 22, 0.55)
    glowFlare(p194, Center, v15, 14, 0.3)
    glowFlare(p194, Center, v11, 20, 1.1)
    sparkleBurst(p194, Center, v8, 50, 34)
    sparkleBurst(p194, Center, v11, 60, 38)
    shardBurst(p194, Center, v11, 26, 32)
    shardBurst(p194, Center, v8, 16, 28)
    flameBurst(p194, Center, v11, 18, 22)
    flameBurst(p194, Center, v9, 10, 18)
    burst(p194, Center, {
        LightEmission = 0.7,
        Drag = 2.8,
        Acceleration = Vector3.new(0, 4, 0),
        ZOffset = 2.5,
        Texture = v1.Lantern,
        Color = ColorSequence.new(v15),
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(10, 15),
        Lifetime = NumberRange.new(1, 1.4),
        Rotation = NumberRange.new(-15, 15),
        RotSpeed = NumberRange.new(-40, 40),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.15, 3),
            NumberSequenceKeypoint.new(1, 2.2)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.7, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 6)
    burst(p194, Center, {
        Drag = 2,
        Acceleration = Vector3.new(0, 3, 0),
        ZOffset = 1,
        Texture = v1.Glow,
        Color = ColorSequence.new(v17, v11),
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(8, 20),
        Lifetime = NumberRange.new(1.2, 2.2),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 0)
        })
    }, 60)

    if not p194.Loops.Shimmer then
        p194.Loops.Shimmer = sound(p194, "Shimmer", Center, 0.9) or false
    end
end

local function implode(p195) -- line: 2952
    -- upvalues: v11 (copy), burstPhase (copy), fadeOut (copy), kick (copy), sparkleBurst (copy), setLoop (copy)
    local Center = p195.Center
    local Swirl = p195.Loops.Swirl

    if Swirl then
        fadeOut(Swirl, 0.35)
    end

    local Hum = p195.Loops.Hum

    if Hum then
        fadeOut(Hum, 0.6)
    end

    if p195.Rift then
        setLoop(p195, p195.Rift, "Loop", false, true)
        burstPhase(p195.Rift, "Close")
    end

    local Vortex = p195.Vortex

    if Vortex then
        for _, descendant in Vortex:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
                descendant:Clear()
            end
        end
    end

    kick(p195, 0.9)
    sparkleBurst(p195, Center, v11, 40, 20)
end

local function flashBeat(p196) -- line: 2965
    -- upvalues: v8 (copy), v10 (copy), v11 (copy), kick (copy), flatWave (copy), faceWave (copy), sparkleBurst (copy), glowFlare (copy)
    local Center = p196.Center

    kick(p196, 1.6)
    p196.FovKick = math.max(p196.FovKick, 1)
    faceWave(p196, Center, v11, p196.RiftSize * 3.2, 0.55)
    faceWave(p196, Center, v10, p196.RiftSize * 2, 0.4)
    flatWave(p196, Center, v10, p196.RiftSize * 5, 0.8)
    glowFlare(p196, Center, v11, p196.RiftSize * 0.9, 0.25)
    sparkleBurst(p196, Center, v8, 26, 34)
    sparkleBurst(p196, Center, v11, 34, 38)
end

local function tearOpen(p197) -- line: 2977
    -- upvalues: v8 (copy), v11 (copy), burstPhase (copy), sound (copy), kick (copy), faceWave (copy), sparkleBurst (copy), setLoop (copy)
    local Center = p197.Center

    if p197.Rift then
        burstPhase(p197.Rift, "Burst")
        setLoop(p197, p197.Rift, "Loop", true)
    end

    local Vortex = p197.Vortex

    if Vortex then
        for _, descendant in Vortex:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = not string.find(descendant.Name, "tech_vortex", 1, true)
            end
        end
    end

    kick(p197, 1)
    p197.FovKick = math.max(p197.FovKick, 0.9)
    faceWave(p197, Center, v11, p197.RiftSize * 2.4, 0.6)
    sparkleBurst(p197, Center, v11, 50, 34)
    sparkleBurst(p197, Center, v8, 30, 28)

    if not p197.Loops.Swirl then
        p197.Loops.Swirl = sound(p197, "Swirl", Center, 0.8) or false
    end
end

local function beats(p198, p199) -- line: 2992
    -- upvalues: Kit (copy), v2 (copy), v11 (copy), v16 (copy), sounds (copy), sound (copy), fadeOut (copy), kick (copy), flatWave (copy), faceWave (copy), sparkleBurst (copy), glowFlare (copy), eggBorn (copy), implode (copy), flashBeat (copy), tearOpen (copy)
    local Fired = p198.Fired

    local function once(p200, p201) -- line: 2994
        -- upvalues: p199 (copy), Fired (copy)
        if Fired[p200] or p199 < p201 then
            return false
        end

        Fired[p200] = true

        return true
    end

    for _, v594 in p198.Pets do
        local v595 = v2.Pulse + (v594.Order - 1) * 0.18
        local v596 = "Pulse" .. v594.Order

        if not (Fired[v596] or p199 < v595) then
            Fired[v596] = true
            sound(p198, "Place", v594.Top, 0.75, 0.95 + v594.Order * 0.04)
            flatWave(p198, v594.Top + Vector3.new(0, 0.2, 0), v594.Color, 14, 0.7)
            sparkleBurst(p198, v594.Top + Vector3.new(0, 1, 0) * v594.Height * 0.5, v594.Hot, 18, 12)
        end
    end

    local Lock = v2.Lock

    if not (Fired.Gaze or p199 < Lock) then
        Fired.Gaze = true
        kick(p198, 0.3)
        p198.FovKick = math.max(p198.FovKick, 0.35)

        local v597 = (p198.EyeNow or CFrame.new(p198.Center)).Position + p198.Side * (p198.RiftSize * 0.05)

        glowFlare(p198, v597, v16, p198.RiftSize * 0.45, 0.35)
        faceWave(p198, v597, v11, p198.RiftSize * 1.4, 0.45)
    end

    local Link = v2.Link

    if not (Fired.Link or p199 < Link) then
        Fired.Link = true
        sound(p198, "Link", p198.Center, 1)
        kick(p198, 0.35)

        for _, v598 in p198.Pets do
            glowFlare(p198, v598.Core.Position, v598.Hot, 6, 0.35)
        end
    end

    local Build = v2.Build

    if not (Fired.Build or p199 < Build) then
        Fired.Build = true

        local Center = p198.Center

        if not p198.Loops.Hum then
            p198.Loops.Hum = sound(p198, "Hum", Center, 0.9) or false
        end
    end

    local Rattle = v2.Rattle

    if not (Fired.Rattle or p199 < Rattle) then
        Fired.Rattle = true

        local Center = p198.Center

        if not p198.Loops.Rumble then
            p198.Loops.Rumble = sound(p198, "Rumble", Center, 0.9) or false
        end
    end

    if v2.Rattle <= p199 and p199 < v2.Return + 2.6 then
        local v599 = Kit.Window(p199, v2.Rattle, v2.Lift + 1) * (1 - Kit.Window(p199, v2.Return + 1.6, v2.Return + 2.6))

        p198.ShakePower = math.max(p198.ShakePower, 0.16 * v599)
    end

    local Crack = v2.Crack

    if not (Fired.Crack or p199 < Crack) then
        Fired.Crack = true
        glowFlare(p198, p198.Center, v11, 5, 0.6)
    end

    local Tear = v2.Tear
    local RiftOpen = sounds().RiftOpen
    local v602 = Tear - (type(RiftOpen) == "table" and tonumber(RiftOpen.Hit) or 0)

    if not (Fired.RiftOpenSfx or p199 < v602) then
        Fired.RiftOpenSfx = true
        sound(p198, "RiftOpen", p198.Center, 1)
    end

    local Tear2 = v2.Tear

    if not (Fired.Tear or p199 < Tear2) then
        Fired.Tear = true
        tearOpen(p198)
    end

    local EyeOpen = v2.EyeOpen
    local EyeOpen2 = sounds().EyeOpen
    local v604 = EyeOpen - (type(EyeOpen2) == "table" and tonumber(EyeOpen2.Hit) or 0)

    if not (Fired.EyeOpenSfx or p199 < v604) then
        Fired.EyeOpenSfx = true
        sound(p198, "EyeOpen", p198.Center, 1)
    end

    local EyeOpen3 = v2.EyeOpen

    if not (Fired.EyeOpen or p199 < EyeOpen3) then
        Fired.EyeOpen = true
        kick(p198, 0.45)

        if p198.Eye then
            glowFlare(p198, p198.Center + p198.Side * 0.6, v11, p198.RiftSize * 0.7, 0.5)
        end
    end

    if v2.Dissolve <= p199 and p199 < v2.Merge then
        p198.ShakePower = math.max(p198.ShakePower, 0.2)
    end

    local Merge = v2.Merge

    if not (Fired.Merge or p199 < Merge) then
        Fired.Merge = true

        if p198.Vortex then
            for _, descendant in p198.Vortex:GetDescendants() do
                if descendant:IsA("ParticleEmitter") and string.find(descendant.Name, "tech_vortex", 1, true) then
                    descendant.Enabled = true
                end
            end
        end
    end

    if v2.Merge <= p199 and p199 < v2.Implode then
        p198.ShakePower = math.max(p198.ShakePower, 0.2 + 0.5 * Kit.Window(p199, v2.Merge, v2.Implode))
    end

    local Egg = v2.Egg
    local Riser = sounds().Riser
    local v607 = Egg - (type(Riser) == "table" and tonumber(Riser.Hit) or 0)

    if not (Fired.Riser or p199 < v607) then
        Fired.Riser = true
        sound(p198, "Riser", p198.Center, 1)
    end

    local Implode = v2.Implode
    local Implode2 = sounds().Implode
    local v609 = Implode - (type(Implode2) == "table" and tonumber(Implode2.Hit) or 0)

    if not (Fired.ImplodeSfx or p199 < v609) then
        Fired.ImplodeSfx = true
        sound(p198, "Implode", p198.Center, 1)
    end

    local v610 = v2.Return + 2.4

    if not (Fired.Return or p199 < v610) then
        Fired.Return = true

        local Rumble = p198.Loops.Rumble

        if Rumble then
            fadeOut(Rumble, 1.2)
        end
    end

    local Implode3 = v2.Implode

    if not (Fired.Implode or p199 < Implode3) then
        Fired.Implode = true
        implode(p198)
    end

    local Flash = v2.Flash

    if not (Fired.Flash or p199 < Flash) then
        Fired.Flash = true
        flashBeat(p198)
    end

    local Egg2 = v2.Egg

    if not (Fired.Egg or p199 < Egg2) then
        Fired.Egg = true
        eggBorn(p198)
    end
end

local function finish(p202) -- line: 3097
    -- upvalues: t2 (ref), fadeOut (copy), restoreProps (copy), restoreLights (copy)
    if p202.Dead then
        return
    end

    p202.Dead = true

    if t2 == p202 then
        t2 = nil
    end

    restoreProps(p202)
    restoreLights(p202)

    for v611 in p202.Sounds do
        if v611.Parent and v611.Looped then
            fadeOut(v611, 0.6)
        end
    end

    local Bed = p202.Bed

    if Bed and Bed.Parent then
        fadeOut(Bed, p202.PayoffAt and 2.2 or 0.8)
        task.delay(3, function() -- line: 3115
            -- upvalues: Bed (copy)
            Bed:Destroy()
        end)
    end

    for _, v613 in p202.Guards do
        v613:Reveal()
    end

    p202.Trove:Destroy()
end

local function landing(p203, p204) -- line: 3125
    -- upvalues: Workspace (copy)
    local v614 = Vector3.new(p204.X, p203.PadTop, p204.Z) + p203.Side * 7
    local v615 = Workspace:Raycast(v614 + Vector3.new(0, 6, 0), Vector3.new(-0, -40, -0, -0), p203.FloorParams)

    if v615 then
        return v615.Position
    end

    return v614
end

local function makeEggs(p205) -- line: 3131
    -- upvalues: Workspace (copy), Kit (copy), v1 (copy), v9 (copy), v10 (copy), v11 (copy), v23 (copy), voidSkin (copy)
    p205.Eggs = {}

    local Seats = p205.Seats
    local v617 = math.max(if Seats then #Seats else #p205.Kind.Sides, 2)
    local t60 = {}

    for i = 1, v617 do
        local v618 = if Seats then Seats[i] else nil
        local t61 = {}

        for _, v619 in p205.Kind.Sides do
            local v620 = if v618 then v618[v619] else p205.Pads[v619]

            if v620 then
                table.insert(t61, v620)
            end
        end

        local v621 = Vector3.new(0, 0, 0)

        for _, v622 in t61 do
            v621 += v622.Position + Vector3.new(0, 1, 0) * (v622.Size.Y / 2)
        end

        local v623 = if #t61 > 0 then v621 / #t61 else p205.Row
        local v624 = Vector3.new(v623.X, p205.PadTop, v623.Z) + p205.Side * 7
        local v625 = Workspace:Raycast(v624 + Vector3.new(0, 6, 0), Vector3.new(-0, -40, -0, -0), p205.FloorParams)

        if v625 then
            v624 = v625.Position
        end

        local v626 = if v618 then v618.Character else p205.Characters[p205.Kind.Sides[i]]

        if v626 and t60[v626] then
            v626 = nil
        end

        if v626 then
            t60[v626] = true
        end

        local v627 = Kit.EggModel(p205.Fused, 6, v10)
        local v628 = v23[p205.Fused]

        if v628 then
            voidSkin(v627, v628)
        end

        v627.Parent = p205.Container

        local _, BoundingBox = v627:GetBoundingBox()

        v627.Parent = nil

        local v629 = CFrame.new(p205.Center)
        local v630 = Kit.Part({
            Name = "EggTrail",
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2),
            CFrame = v629
        })

        v630.Parent = p205.Container

        local Attachment = Instance.new("Attachment")

        Attachment.Position = Vector3.new(0, 0.7, 0)
        Attachment.Parent = v630

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Position = Vector3.new(0, -0.7, 0)
        Attachment2.Parent = v630

        local Trail = Instance.new("Trail")

        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment2
        Trail.Texture = v1.Glow
        Trail.TextureMode = Enum.TextureMode.Stretch
        Trail.Color = ColorSequence.new(if i == 1 then v9 else v11, v10)
        Trail.Transparency = NumberSequence.new(0.25, 1)
        Trail.WidthScale = NumberSequence.new(1, 0.3)
        Trail.Lifetime = 0.35
        Trail.LightEmission = 1
        Trail.LightInfluence = 0
        Trail.FaceCamera = true
        Trail.Enabled = false
        Trail.Parent = v630

        local PointLight = Instance.new("PointLight")

        PointLight.Color = v11
        PointLight.Range = 12
        PointLight.Brightness = 2.5
        PointLight.Shadows = false
        PointLight.Parent = v630
        table.insert(p205.Eggs, {
            Model = v627,
            Full = v627:GetScale(),
            Glow = v630,
            Trail = Trail,
            Index = i,
            Land = v624 + Vector3.new(0, 1, 0) * (BoundingBox.Y / 2 + 0.2),
            Lift = BoundingBox.Y / 2 + 0.2,
            Character = v626,
            Guard = p205.Guards[i]
        })
    end

    local v631 = false

    for v632, v633 in p205.Eggs do
        for j = v632 + 1, #p205.Eggs do
            local Land = p205.Eggs[j].Land

            if Vector3.new(v633.Land.X - Land.X, 0, v633.Land.Z - Land.Z).Magnitude < 6 then
                v631 = true
            end
        end
    end

    if not v631 then
        return
    end

    local v636 = #p205.Eggs
    local v638 = math.max(p205.RowSpan * 0.34, 10)

    for v639, v640 in p205.Eggs do
        local v641 = p205.Row + p205.Across * ((v639 - (v636 + 1) / 2) * v638)
        local v642 = Vector3.new(v641.X, p205.PadTop, v641.Z) + p205.Side * 7
        local v643 = Workspace:Raycast(v642 + Vector3.new(0, 6, 0), Vector3.new(-0, -40, -0, -0), p205.FloorParams)

        if v643 then
            v642 = v643.Position
        end

        v640.Land = v642 + Vector3.new(0, 1, 0) * v640.Lift
    end
end

local function stepPayoff(p206) -- line: 3221
    -- upvalues: Kit (copy), v3 (copy), v8 (copy), v10 (copy), v11 (copy), v15 (copy), sound (copy), fadeOut (copy), kick (copy), flatWave (copy), faceWave (copy), sparkleBurst (copy), glowFlare (copy), finish (copy)
    local v644 = os.clock() - p206.PayoffAt

    p206.P = v644

    local Center, Egg = p206.Center, p206.Egg

    if not p206.Split and v3.Split <= v644 then
        p206.Split = true
        sound(p206, "Reward", Center, 1)

        local Shimmer = p206.Loops.Shimmer

        if Shimmer then
            fadeOut(Shimmer, 1.5)
        end

        if Egg then
            Egg.Model.Parent = nil

            for _, v645 in {
                    "Flames",
                    "BoneFlames",
                    "Shards",
                    "Shimmer",
                    "Condense",
                    "Backdrop",
                    "BackGlow",
                    "Embers",
                    "CoreGlow",
                    "SwirlIn"
                } do
                Egg.Dressing[v645].Enabled = false
            end

            for _, v646 in Egg.Dressing.Lanterns do
                v646.Emitter.Enabled = false
                v646.Fire.Enabled = false
            end

            Egg.Dressing.Light.Brightness = 0
            Egg.Dressing.Rim.Brightness = 0
        end

        faceWave(p206, Center, v11, 22, 0.5)
        sparkleBurst(p206, Center, v11, 50, 28)
        sparkleBurst(p206, Center, v8, 30, 22)
        kick(p206, 0.7)
        p206.FovKick = math.max(p206.FovKick, 0.6)
    end

    for _, v647 in p206.Eggs do
        local Model = v647.Model

        if not v647.Done and not (v644 < v3.Split) then
            local Full = v647.Full

            if v644 < v3.Land then
                local v648 = Kit.Window(v644, v3.Split, v3.Land)
                local v649 = (Center + v647.Land) / 2 + Vector3.new(0, 9, 0)
                local v650 = Kit.Bezier(Center, v649, v647.Land, Kit.Ease(v648, Enum.EasingStyle.Sine, Enum.EasingDirection.In))
                local v651 = v648 * 3.141592653589793 * 3

                Full *= 0.6 + 0.4 * Kit.Smooth(v648)
                v647.Trail.Enabled = true
                Model.Parent = p206.Container

                if math.abs(Model:GetScale() - Full) > 1E-04 then
                    Model:ScaleTo((math.max(Full, 0.01)))
                end

                Model:PivotTo(CFrame.new(v650) * CFrame.Angles(0, v651, 0))
                v647.Glow.CFrame = CFrame.new(v650)
                v647.Position = v650
            elseif v644 < v3.Handoff then
                local v653 = v644 - v3.Land
                local v659 = math.abs((math.sin(math.min(v653 / 0.42, 1) * 3.141592653589793))) * 1.3 * math.exp(-v653 * 2)
                local v660 = v647.Land + Vector3.new(0, 1, 0) * v659

                if not v647.Landed then
                    v647.Landed = true
                    v647.Trail.Enabled = false
                    sound(p206, "PropsLand", v647.Land, 0.6, 1.25)
                    flatWave(p206, v647.Land - Vector3.new(0, 2.7, 0), if v647.Index == 1 then v8 else v10, 18, 0.6)
                    sparkleBurst(p206, v647.Land, v11, 30, 16)
                    kick(p206, 0.35)
                end

                if not v647.Character and v3.Done - 0.2 < v644 then
                    sparkleBurst(p206, v647.Land, v11, 24, 12)
                    Model.Parent = nil
                    v647.Glow.Parent = nil
                    v647.Done = true
                    continue
                end

                local n6 = 0

                Model.Parent = p206.Container

                if math.abs(Model:GetScale() - Full) > 1E-04 then
                    Model:ScaleTo((math.max(Full, 0.01)))
                end

                Model:PivotTo(CFrame.new(v660) * CFrame.Angles(0, n6, 0))
                v647.Glow.CFrame = CFrame.new(v660)
                v647.Position = v660
            elseif v647.Character then
                local v664 = Kit.Window(v644, v3.Handoff, v3.Caught)
                local v665 = Kit.RootOf(v647.Character)
                local v666 = if v665 then v665.Position + Vector3.new(0, 1.5, 0) else v647.Land
                local v667 = (v647.Land + v666) / 2 + Vector3.new(0, 7, 0)
                local v668 = Kit.Bezier(v647.Land, v667, v666, v664 * v664)
                local v669 = v664 * 3.141592653589793 * 4

                Full *= 1 - Kit.Window(v664, 0.6, 1) * 0.95
                v647.Trail.Enabled = true

                if v664 >= 1 then
                    if v647.Guard then
                        v647.Guard:Reveal()
                    end

                    sparkleBurst(p206, v666, v11, 40, 20)
                    glowFlare(p206, v666, v15, 8, 0.4)
                    Model.Parent = nil
                    v647.Glow.Parent = nil
                    v647.Done = true
                else
                    Model.Parent = p206.Container

                    if math.abs(Model:GetScale() - Full) > 1E-04 then
                        Model:ScaleTo((math.max(Full, 0.01)))
                    end

                    Model:PivotTo(CFrame.new(v668) * CFrame.Angles(0, v669, 0))
                    v647.Glow.CFrame = CFrame.new(v668)
                    v647.Position = v668
                end
            else
                local v671 = v644 - v3.Land
                local v677 = math.abs((math.sin(math.min(v671 / 0.42, 1) * 3.141592653589793))) * 1.3 * math.exp(-v671 * 2)
                local v678 = v647.Land + Vector3.new(0, 1, 0) * v677

                if not v647.Landed then
                    v647.Landed = true
                    v647.Trail.Enabled = false
                    sound(p206, "PropsLand", v647.Land, 0.6, 1.25)
                    flatWave(p206, v647.Land - Vector3.new(0, 2.7, 0), if v647.Index == 1 then v8 else v10, 18, 0.6)
                    sparkleBurst(p206, v647.Land, v11, 30, 16)
                    kick(p206, 0.35)
                end

                if v647.Character then
                    local n7 = 0

                    Model.Parent = p206.Container

                    if math.abs(Model:GetScale() - Full) > 1E-04 then
                        Model:ScaleTo((math.max(Full, 0.01)))
                    end

                    Model:PivotTo(CFrame.new(v678) * CFrame.Angles(0, n7, 0))
                    v647.Glow.CFrame = CFrame.new(v678)
                    v647.Position = v678
                elseif v3.Done - 0.2 < v644 then
                    sparkleBurst(p206, v647.Land, v11, 24, 12)
                    Model.Parent = nil
                    v647.Glow.Parent = nil
                    v647.Done = true
                else
                    local n8 = 0

                    Model.Parent = p206.Container

                    if math.abs(Model:GetScale() - Full) > 1E-04 then
                        Model:ScaleTo((math.max(Full, 0.01)))
                    end

                    Model:PivotTo(CFrame.new(v678) * CFrame.Angles(0, n8, 0))
                    v647.Glow.CFrame = CFrame.new(v678)
                    v647.Position = v678
                end
            end
        end
    end

    if v3.Handoff <= v644 and p206.OnDone then
        local OnDone = p206.OnDone

        p206.OnDone = nil
        task.spawn(OnDone)
    end

    if v3.Done <= v644 then
        finish(p206)
    end
end

local function step(p207, p208) -- line: 3348
    -- upvalues: Workspace (copy), Kit (copy), v2 (copy), stepSteady (copy), setOrbSize (copy), stepWisps (copy), stepEye (copy), stepRift (copy), stepTethers (copy), stepPets (copy), stepPads (copy), stepProps (copy), stepLights (copy), stepEgg (copy), beats (copy), finish (copy), stepPayoff (copy)
    if not p207.Dead then
        if p207.Shrine:IsDescendantOf(Workspace) then
            local v683 = (Workspace:GetServerTimeNow() - p207.StartAt) / p207.Scale

            if p207.PayoffAt then
                v683 = math.max(v683, 18)
            end

            local v684 = p208 / p207.Scale

            p207.T = v683
            p207.ShakePower = p207.ShakePower * math.exp(-p208 * 3.2)
            p207.FovKick = p207.FovKick * math.exp(-p208 * 4)
            beats(p207, v683)
            stepPads(p207, v683)
            stepRift(p207, v683)
            stepEye(p207, v683, p208)
            stepPets(p207, v683)
            stepTethers(p207, v683)
            stepProps(p207, v683, v684)
            stepLights(p207, v683)
            stepWisps(p207, v683, v684)
            stepSteady(p207, 1 + 0.8 * Kit.Window(v683, v2.Merge, v2.Implode))

            local v687 = Kit.Ease(Kit.Window(v683, v2.Merge - 0.2, v2.Implode - 0.25), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local v688 = Kit.Ease(Kit.Window(v683, v2.Implode - 0.1, v2.Implode + 0.3), Enum.EasingStyle.Back, Enum.EasingDirection.In)

            setOrbSize(p207, p207.RiftSize * 0.16 * v687 * (1 - v688))
            stepEgg(p207, v683)

            if p207.PayoffAt then
                stepPayoff(p207)
            end
        else
            finish(p207)
        end
    end
end

local function cameraKeys(p209) -- line: 3392
    -- upvalues: v2 (copy)
    local Center, Row, Side, Across = p209.Center, p209.Row, p209.Side, p209.Across
    local RiftSize = p209.RiftSize

    local function orbit(p210, p211, p212) -- line: 3395
        -- upvalues: Center (copy), Side (copy)
        return Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), p210):VectorToWorldSpace(Side) * p211 + Vector3.new(0, 1, 0) * p212
    end

    local v690 = math.max(p209.Floor + 2.2 - Row.Y, -6)
    local v693 = math.max(p209.PadTop + 2.5 - Center.Y, -RiftSize * 0.45)
    local v694 = RiftSize * 1.35
    local v697 = math.min(5, (math.max(Center.Y - p209.PadTop - 1.5, 2)))
    local t63 = {
        T = -1,
        Fov = 58,
        At = Row + Side * 48 + Vector3.new(0, 16, 0),
        Look = Row:Lerp(Center, 0.3)
    }
    local t64 = {
        T = 0,
        Fov = 58,
        At = Row + Side * 46 + Vector3.new(0, 15, 0),
        Look = Row:Lerp(Center, 0.3)
    }
    local t65 = {
        Fov = 58,
        T = v2.Crack,
        At = Row + Side * 42 + Vector3.new(0, 12, 0),
        Look = Row:Lerp(Center, 0.55)
    }
    local t66 = {
        Fov = 56,
        T = v2.Tear + 0.6,
        At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.3):VectorToWorldSpace(Side) * (RiftSize * 1.9) + Vector3.new(0, 1, 0) * (v693 * 0.35),
        Look = Center
    }
    local t67 = {
        Fov = 44,
        T = v2.EyeOpen + 0.3,
        At = Center + Side * v694 - Vector3.new(0, 1.2, 0),
        Look = Center
    }
    local t68 = {
        Fov = 42,
        T = v2.Gaze + 0.6,
        At = Center + Side * (v694 * 0.9) + Across * 0.8 - Vector3.new(0, 1, 0),
        Look = Center - Vector3.new(0, 0.4, 0)
    }
    local t69 = {
        Fov = 58,
        T = v2.Link + 0.7,
        At = Row + Side * 32 + Across * 5 + Vector3.new(0, 9, 0),
        Look = Row:Lerp(Center, 0.62)
    }
    local t70 = {
        Fov = 56,
        T = v2.Build + 1,
        At = Row + Side * 25 - Across * 7 + Vector3.new(0, 6, 0),
        Look = Row:Lerp(Center, 0.7)
    }
    local t71 = {
        Fov = 62,
        T = v2.Lift + 0.4,
        At = Row + Side * 21 - Across * 11 + Vector3.new(0, 1, 0) * v690,
        Look = Center + Vector3.new(0, 1, 0)
    }
    local t72 = {
        Fov = 56,
        T = v2.Squint + 0.3
    }
    local v698 = RiftSize * 1.25
    local v699 = v693 * 0.5

    t72.At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.55):VectorToWorldSpace(Side) * v698 + Vector3.new(0, 1, 0) * v699
    t72.Look = Center

    local t73 = {
        Fov = 60,
        T = v2.Dissolve + 0.9,
        At = Row + Side * 36 + Vector3.new(0, 9, 0),
        Look = Row:Lerp(Center, 0.55)
    }
    local t74 = {
        Fov = 58,
        T = v2.Dissolve + 2.6,
        At = Row + Side * 31 + Across * 15 + Vector3.new(0, 7, 0),
        Look = Row:Lerp(Center, 0.6)
    }
    local t75 = {
        Fov = 56,
        T = v2.Merge + 0.6
    }
    local v700 = RiftSize * 1.55

    t75.At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.45):VectorToWorldSpace(Side) * v700 + Vector3.new(0, 2, 0)
    t75.Look = Center

    local t76 = {
        Fov = 54,
        T = v2.Close
    }
    local v701 = RiftSize * 1.45

    t76.At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.6):VectorToWorldSpace(Side) * v701 + Vector3.new(0, 2, 0)
    t76.Look = Center

    local t77 = {
        Fov = 55,
        T = v2.Implode
    }
    local v702 = RiftSize * 1.45

    t77.At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.5):VectorToWorldSpace(Side) * v702 + Vector3.new(0, 1.5, 0)
    t77.Look = Center

    return {
        t63,
        t64,
        t65,
        t66,
        t67,
        t68,
        t69,
        t70,
        t71,
        t72,
        t73,
        t74,
        t75,
        t76,
        t77,
        {
            Fov = 60,
            T = v2.Condense + 0.35,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.38):VectorToWorldSpace(Side) * 31.42857142857143 - Vector3.new(0, 1, 0) * (v697 * 0.4),
            Look = Center - Vector3.new(0, 3, 0)
        },
        {
            Fov = 52,
            T = v2.Egg + 1,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.3):VectorToWorldSpace(Side) * 15.428571428571429 - Vector3.new(0, 1, 0) * v697,
            Look = Center + Vector3.new(0, 0.6, 0)
        },
        {
            Fov = 50,
            T = v2.Egg + 2.5,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.12):VectorToWorldSpace(Side) * 14.285714285714285 - Vector3.new(0, 1, 0) * v697,
            Look = Center + Vector3.new(0, 0.8, 0)
        },
        {
            Fov = 49,
            T = v2.Egg + 5.5,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.02):VectorToWorldSpace(Side) * 13.857142857142856 - Vector3.new(0, 1, 0) * v697,
            Look = Center + Vector3.new(0, 1, 0)
        }
    }
end

local function hermite(p213, p214) -- line: 3466
    -- upvalues: Kit (copy)
    local v703 = #p213

    if p214 <= p213[2].T then
        return p213[2].At, p213[2].Look, p213[2].Fov
    end

    if p213[v703].T <= p214 then
        return p213[v703].At, p213[v703].Look, p213[v703].Fov
    end

    local n9 = 2

    while n9 < v703 - 1 and p213[n9 + 1].T < p214 do
        n9 += 1
    end

    local v704 = p213[n9 - 1]
    local v705 = p213[n9]
    local v706 = p213[n9 + 1]
    local v708 = p213[math.min(n9 + 2, v703)]
    local v709 = v706.T - v705.T
    local v710 = Kit.Clamp01((p214 - v705.T) / v709)
    local v711 = v710 * v710
    local v712 = v710 * v710 * v710
    local v713 = 2 * v712 - 3 * v711 + 1
    local v714 = v712 - 2 * v711 + v710
    local v715 = -2 * v712 + 3 * v711
    local v716 = v712 - v711

    local function tangent(p215, p216) -- line: 3489
        return (math.max(p216.T - p215.T, 0.001))
    end

    local function blend(p217) -- line: 3492
        -- upvalues: v704 (copy), v705 (copy), v706 (copy), v708 (copy), v709 (copy), v713 (copy), v714 (copy), v715 (copy), v716 (copy)
        local v720 = (v706[p217] - v704[p217]) / math.max(v706.T - v704.T, 0.001) * v709 * 0.85
        local v723 = (v708[p217] - v705[p217]) / math.max(v708.T - v705.T, 0.001) * v709 * 0.85

        return v705[p217] * v713 + v720 * v714 + v706[p217] * v715 + v723 * v716
    end

    return blend("At"), blend("Look"), Kit.Lerp(v705.Fov, v706.Fov, Kit.Smooth(v710))
end

local function payoffPath(p218, p219) -- line: 3500
    -- upvalues: Kit (copy), v3 (copy)
    local Center, PayoffFrom = p218.Center, p218.PayoffFrom
    local v724 = Kit.Smooth(Kit.Window(p219, 0, v3.Land))
    local v725 = PayoffFrom:Lerp(Center + p218.Side * (p218.RiftSize * 1.9) + Vector3.new(0, 5, 0), v724)
    local v726 = Center:Lerp(p218.Row + Vector3.new(0, 2, 0), v724 * 0.6)
    local v727 = Kit.Lerp(50, 60, v724)
    local v728 = p218.Eggs or {}
    local v729 = p218.MyEgg or v728[1]

    if v729 then
        local Land = v729.Land
        local v730

        if #v728 >= 2 then
            local v731 = Vector3.new(0, 0, 0)

            for _, v732 in v728 do
                v731 += v732.Land
            end

            Land = v731 / #v728
            v730 = 0

            for _, v733 in v728 do
                v730 = math.max(v730, (v733.Land - Land).Magnitude)
            end
        else
            v730 = 0
        end

        local v734 = Kit.Smooth(Kit.Window(p219, v3.Split + 0.3, v3.Land + 0.3))
        local v735 = Land + p218.Side * (v730 * 0.6 + 17) + Vector3.new(0, 1, 0) * (v730 * 0.2 + 7) + Kit.Flat(Center - Land) * 3

        if v729.Position then
            Land = v729.Position:Lerp(Land, if v730 > 0 then 0.7 else 0.4)
        end

        v725 = v725:Lerp(v735, v734)
        v726 = v726:Lerp(Land, v734)
        v727 = Kit.Lerp(v727, 56, v734)
    end

    return v725, v726, v727
end

function t1.Camera(_, p221) -- line: 3538
    -- upvalues: Workspace (copy), Kit (copy), t2 (ref), hermite (copy), payoffPath (copy)
    local t78 = t2
    local CurrentCamera, v736

    if not t78 or t78.Dead then
        v736 = true
    elseif t78.Participant and t78.T then
        CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera and CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
            t78.CameraTakebacks += 1
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
        end

        v736 = false
    else
        v736 = true
    end

    if v736 then
        return nil, nil
    end

    local v737, v738, v739

    if t78.PayoffAt then
        if not t78.PayoffFrom then
            if t78.Cam then
                t78.PayoffFrom = t78.Cam.At
            else
                t78.PayoffFrom = t78.Center + t78.Side * 20
            end
        end

        v737, v738, v739 = payoffPath(t78, t78.P or 0)
    else
        v737, v738, v739 = hermite(t78.CamKeys, t78.T)
    end

    local v749 = Vector3.new(math.clamp(v737.X, t78.Low.X + 1, t78.High.X - 1), math.clamp(v737.Y, t78.Floor + 1.6, t78.Ceiling - 1.6), (math.clamp(v737.Z, t78.Low.Z + 1, t78.High.Z - 1)))
    local Cam = t78.Cam

    if not Cam then
        Cam = if CurrentCamera then {
            At = CurrentCamera.CFrame.Position,
            Look = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 24,
            Fov = CurrentCamera.FieldOfView
        } else {
            At = v749,
            Look = v738,
            Fov = v739
        }
        t78.Cam = Cam
    end

    local v751 = 1 - math.exp(-p221 * 6)

    Cam.At = Cam.At:Lerp(v749, v751)
    Cam.Look = Cam.Look:Lerp(v738, v751)
    Cam.Fov = Kit.Lerp(Cam.Fov, v739, v751)

    local v752 = Kit.ReducedMotion()
    local v753 = if v752 then 0 else t78.ShakePower
    local elapsed = os.clock()
    local v754 = CFrame.lookAt(Cam.At, Cam.Look)
    local v755 = (v754.RightVector * math.noise(elapsed * 17, 1.3) + v754.UpVector * math.noise(elapsed * 17, 7.9)) * v753 * 0.5
    local v756 = (v754.RightVector * math.noise(elapsed * 11, 4.1) + v754.UpVector * math.noise(elapsed * 11, 2.6)) * v753 * 0.35
    local v757 = CFrame.lookAt(Cam.At + v755, Cam.Look + v756)
    local v758 = if v752 then 0 else t78.FovKick * 9

    return v757, (math.clamp(Cam.Fov + v758, 30, 90))
end

function t1.IsPlaying() -- line: 3598
    -- upvalues: t2 (ref)
    return t2 ~= nil
end

function t1.ActiveShrine() -- line: 3602
    -- upvalues: t2 (ref)
    return if t2 then t2.Shrine else nil
end

function t1.IsResolving() -- line: 3606
    -- upvalues: t2 (ref)
    return t2 ~= nil and t2.PayoffAt ~= nil
end

function t1.FlightFocus() -- line: 3610
    return nil
end

local function localNear(p222) -- line: 3614
    -- upvalues: Kit (copy)
    local v760 = Kit.RootOf(Kit.LocalPlayerCharacter())

    return v760 ~= nil and (v760.Position - p222).Magnitude <= 170
end

function t1.Begin(p223) -- line: 3619
    -- upvalues: RunService (copy), Workspace (copy), ShrineFusionFlags (copy), Kit (copy), Trove (copy), v7 (copy), t2 (ref), startBed (copy), geometry (copy), buildPets (copy), buildPads (copy), buildTethers (copy), gatherProps (copy), gatherLights (copy), buildRoom (copy), buildRift (copy), buildOrb (copy), buildEgg (copy), finish (copy), step (copy), cameraKeys (copy)
    if t2 and t2.Shrine == p223.Shrine and not t2.Dead then
        if p223.Participant and not t2.Participant then
            t2.Participant = true
            t2.Gui = p223.Gui
            startBed(t2)
        end

        return true
    end

    if t2 then
        finish(t2)
    end

    local Shrine = p223.Shrine
    local RitualCenter = Shrine:FindFirstChild("RitualCenter")

    if RitualCenter and RitualCenter:IsA("BasePart") then
        if p223.Participant ~= true then
            local RitualCenterPosition = RitualCenter.Position
            local v761 = Kit.RootOf(Kit.LocalPlayerCharacter())

            if v761 == nil or not ((v761.Position - RitualCenterPosition).Magnitude <= 170) then
                return false
            end
        end

        local Id = p223.Kind.Id
        local v762 = ShrineFusionFlags.ShrineRitualSeconds:Get()[Id] or ShrineFusionFlags.RitualSeconds:Get()
        local Recipe = p223.Recipe or ShrineFusionFlags.Recipes:Get()[p223.Tier] or v7
        local t81 = {
            ShakePower = 0,
            FovKick = 0,
            RattleCount = 0,
            LandCount = 0,
            CameraTakebacks = 0,
            Trove = Trove.new(),
            Shrine = Shrine,
            Interior = Shrine.Parent,
            Kind = p223.Kind,
            Pads = p223.Pads,
            Seats = if type(p223.Seats) ~= "table" or not (#p223.Seats > 0) then nil else p223.Seats,
            Characters = p223.Characters or {},
            Tier = p223.Tier,
            Recipe = Recipe,
            Fused = p223.FusedCategory or Recipe.Fused or v7.Fused,
            Participant = p223.Participant == true,
            Gui = p223.Gui,
            Center = RitualCenter.Position,
            Side = Kit.Flat(RitualCenter.CFrame.LookVector),
            StartAt = p223.EndsAt - v762,
            EndsAt = p223.EndsAt,
            Scale = v762 / 18,
            Fired = {},
            Sounds = {},
            Loops = {},
            Guards = {},
            Wisps = {},
            Steady = {},
            RiftDiscs = {}
        }

        t81.Across = t81.Side:Cross((Vector3.new(0, 1, 0)))

        local v763 = Vector3.new(0, 0, 0)
        local n11 = 0
        local n12 = (-1e999)

        if t81.Seats then
            local v764 = Vector3.new(0, 0, 0)
            local n13 = 0
            local n14 = (-1e999)

            for _, v765 in t81.Seats do
                for _, v769 in t81.Kind.Sides do
                    local v770 = v765[v769]

                    if typeof(v770) == "Instance" and v770:IsA("BasePart") then
                        local v771 = v770.Position + Vector3.new(0, 1, 0) * (v770.Size.Y / 2)

                        v764 = v763 + v771
                        v763 = v764
                        n13 = n11 + 1
                        n11 = n13
                        n14 = math.max(n12, v771.Y)
                        n12 = n14
                    end
                end
            end
        else
            for _, v772 in t81.Pads do
                if typeof(v772) == "Instance" and v772:IsA("BasePart") then
                    local v773 = v772.Position + Vector3.new(0, 1, 0) * (v772.Size.Y / 2)

                    v763 += v773
                    n11 += 1
                    n12 = math.max(n12, v773.Y)
                end
            end
        end

        t81.Row = if n11 > 0 then v763 / n11 else t81.Center - Vector3.new(0, 10, 0)
        t81.RowSpan = 12
        t81.PadTop = if n11 > 0 then n12 else t81.Center.Y - 10

        local Parent = p223.Parent
        local Folder = Instance.new("Folder")

        Folder.Name = "VoidFusion"
        Folder.Parent = Parent or Workspace:FindFirstChild("Transient") or Workspace
        t81.Container = Folder
        t81.Trove:Add(t81.Container)
        geometry(t81)
        t81.FloorParams = RaycastParams.new()

        local building = if t81.Interior then t81.Interior:FindFirstChild("building") else nil

        if building then
            t81.FloorParams.FilterType = Enum.RaycastFilterType.Include
            t81.FloorParams.FilterDescendantsInstances = { building }
        end

        if t81.Seats then
            for v776, v777 in t81.Seats do
                t81.Guards[v776] = Kit.ToolGuard(v777.Character)
            end
        else
            for v778, v779 in t81.Kind.Sides do
                t81.Guards[v778] = Kit.ToolGuard(t81.Characters[v779])
            end
        end

        t81.T = (Workspace:GetServerTimeNow() - t81.StartAt) / t81.Scale
        t2 = t81

        local function v780() -- line: 3719
            -- upvalues: t81 (copy), startBed (copy), buildPets (copy), buildPads (copy), buildTethers (copy), gatherProps (copy), gatherLights (copy), buildRoom (copy), buildRift (copy), buildOrb (copy), buildEgg (copy), cameraKeys (copy)
            startBed(t81)
            buildPets(t81)
            buildPads(t81)
            buildTethers(t81)
            gatherProps(t81)
            gatherLights(t81)
            buildRoom(t81)
            buildRift(t81)
            buildOrb(t81)
            buildEgg(t81)
            t81.CamKeys = cameraKeys(t81)
        end

        local ok, result = pcall(v780)

        if not ok then
            warn("[VoidRitual] build failed:", result)
            finish(t81)

            return false
        end

        local v781 = Kit.LocalPlayerCharacter()
        local Humanoid = if v781 then v781:FindFirstChildOfClass("Humanoid") else nil

        if Humanoid then
            t81.Trove:Connect(Humanoid.Died, function() -- line: 3740
                -- upvalues: t81 (copy), t2 (ref), finish (copy)
                if t2 == t81 then
                    finish(t81)
                end
            end)
        end

        t81.Trove:Connect(RunService.RenderStepped, function(p224) -- line: 3746
            -- upvalues: t81 (copy), finish (copy), step (copy)
            local ok, result = pcall(step, t81, p224)

            if not ok then
                warn("[VoidRitual] step failed:", result)
                finish(t81)
            end
        end)

        return true
    end

    warn("[VoidRitual] shrine needs a RitualCenter part:", Shrine:GetFullName())

    return false
end

function t1.Payoff(p225) -- line: 3756
    -- upvalues: Kit (copy), t2 (ref), makeEggs (copy)
    local t82 = t2

    if not t82 or t82.Dead then
        return false
    end

    if t82.PayoffAt then
        t82.OnDone = t82.OnDone or p225
    else
        t82.PayoffAt = os.clock()
        t82.OnDone = p225

        local v782 = Kit.LocalPlayerCharacter()

        makeEggs(t82)

        for _, v783 in t82.Eggs do
            if v782 and v783.Character == v782 then
                t82.MyEgg = v783
            end
        end
    end

    return true
end

function t1.Cancel() -- line: 3777
    -- upvalues: t2 (ref), finish (copy)
    if t2 then
        finish(t2)
    end
end

return table.freeze(t1)
