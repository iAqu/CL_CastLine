-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local ShrineFusionFlags = require(ReplicatedStorage.Shared.Flags.ShrineFusionFlags)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Kit = require(script.Parent.Kit)
local ShrinePadPets = require(ReplicatedStorage.Client.ShrinePadPets)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = table.freeze({
    Bed = 113629321829237,
    Appear = 115818434760382,
    SealCrack = 83193566956039,
    Roar = 122225901664901,
    SealShatter = 88421070361458,
    WaterReveal = 87535168837444,
    WhaleCall = 105930615352693,
    Splash = 83099379619955,
    Charge = 119987445263999,
    Collapse = 70767570204111,
    EggBurst = 131661095169691,
    EggLand = 140086252907114
})
local v2 = table.freeze({
    LionRoar = "rbxassetid://76209207390777"
})
local v3 = table.freeze({
    Sparkle = "rbxasset://textures/particles/sparkles_main.dds",
    Shockwave = "rbxassetid://109600784699514",
    Ripple = "rbxassetid://16511598488",
    Water = "rbxassetid://71203942292797",
    Flare = "rbxassetid://105427977618886",
    Shard = "rbxassetid://140284431017219",
    Petal = "rbxassetid://101360855375102",
    Sunburst = "rbxassetid://85665154415342",
    Energy = "rbxassetid://85003420967228",
    Vortex = "rbxassetid://87418254231660",
    Smoke = "rbxassetid://11917388916"
})
local v4 = table.freeze({
    Appear = 0,
    Crack = 1.4,
    Halt = 2.4,
    Roar = 3.25,
    Shatter = 4.2,
    Reveal = 4.5,
    WhaleCall = 5.6,
    Dive = 6.2,
    Splash = 7.6,
    Fuse = 8.2,
    Collapse = 12.6
})
local v5 = table.freeze({
    Burst = 0.12,
    Apex = 1.05,
    Split = 1.55,
    Land = 2.4,
    Present = 2.8,
    Handoff = 3.6,
    Caught = 4.5,
    Done = 5.4
})
local v6 = Color3.fromRGB(255, 204, 72)
local v7 = Color3.fromRGB(255, 150, 40)
local v8 = Color3.fromRGB(92, 226, 255)
local v9 = Color3.fromRGB(164, 110, 255)
local v10 = Color3.new(1, 1, 1)
local t1 = {}
local t2
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local v13 = Random.new()

local function ritualSeconds(p1) -- line: 102
    -- upvalues: ShrineFusionFlags (copy)
    return ShrineFusionFlags.ShrineRitualSeconds:Get()[p1] or ShrineFusionFlags.RitualSeconds:Get()
end

local function container(p2) -- line: 106
    -- upvalues: Workspace (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "EnchantedFusion"
    Folder.Parent = p2 or Workspace:FindFirstChild("Transient") or Workspace

    return Folder
end

local function objectValue(p3, p4) -- line: 113
    local v14 = p3:FindFirstChild(p4)

    return if v14 and v14:IsA("ObjectValue") then v14.Value else nil
end

local function partsOf(p5) -- line: 118
    local t7 = {}

    if p5 then
        if p5:IsA("BasePart") then
            table.insert(t7, p5)
        end

        for _, descendant in p5:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(t7, descendant)
            end
        end
    end

    return t7
end

local function sound(p6, p7, p8, p9, p10) -- line: 133
    -- upvalues: Kit (copy), v1 (copy)
    local v15 = Kit.Sound(v1[p7], p8 or p6.Center, p9, p10)

    if v15 then
        p6.Sounds[v15] = true
    end

    return v15
end

local function fadeOut(p11, p12) -- line: 147
    -- upvalues: TweenService (copy)
    if p11 and p11.Parent then
        local tween = TweenService:Create(p11, TweenInfo.new(p12, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Volume = 0
        })

        tween.Completed:Once(function() -- line: 156
            -- upvalues: p11 (copy)
            p11:Stop()
        end)
        tween:Play()
    end
end

local function startBed(p13) -- line: 162
    -- upvalues: Workspace (copy), v1 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if p13.Participant and CurrentCamera then
        local Sound = Instance.new("Sound")

        Sound.Name = "EnchantedFusionBed"
        Sound.SoundId = ("rbxassetid://%*"):format(v1.Bed)
        Sound.Volume = 0.85
        Sound.TimePosition = math.max(Workspace:GetServerTimeNow() - p13.StartAt, 0)
        Sound.Parent = CurrentCamera
        Sound.Ended:Once(function() -- line: 173
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
        Sound:Play()
        p13.Bed = Sound
    end
end

local function kick(p14, p15) -- line: 180
    -- upvalues: Kit (copy), Shake (copy)
    p14.ShakePower = math.max(p14.ShakePower, p15)

    if not p14.Participant and not Kit.ReducedMotion() then
        Shake.Play({
            Seconds = p15 * 0.4 + 0.5,
            Magnitude = p15,
            Range = {
                Near = 30,
                Far = 140,
                Center = p14.Center
            }
        })
    end
end

local function emitterHost(p16, p17, p18) -- line: 191
    -- upvalues: Kit (copy)
    local v17 = Kit.Part({
        Name = "EmitterHost",
        Transparency = 1,
        Size = p18 or Vector3.new(0.2, 0.2, 0.2),
        CFrame = p17
    })

    v17.Parent = p16.Container

    return v17
end

local function burst(p19, p20, p21, p22, p23) -- line: 202
    -- upvalues: Kit (copy)
    local v18 = CFrame.new(p20)
    local v19 = Kit.Part({
        Name = "EmitterHost",
        Transparency = 1,
        Size = p23 or Vector3.new(0.2, 0.2, 0.2),
        CFrame = v18
    })

    v19.Parent = p19.Container
    Kit.Emitter(v19, p21):Emit(p22)
    task.delay(4, function() -- line: 212
        -- upvalues: v19 (copy)
        v19:Destroy()
    end)
end

local function flatWave(p24, p25, p26, p27, p28) -- line: 217
    -- upvalues: v3 (copy), burst (copy)
    burst(p24, p25, {
        ZOffset = 2,
        Texture = v3.Shockwave,
        Color = ColorSequence.new(p26),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Lifetime = NumberRange.new(p28),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p27 * 0.08),
            NumberSequenceKeypoint.new(1, p27)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.6, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 1)
end

local function sparkleBurst(p29, p30, p31, p32, p33) -- line: 238
    -- upvalues: v3 (copy), v10 (copy), burst (copy)
    burst(p29, p30, {
        Drag = 3,
        Acceleration = Vector3.new(0, 4, 0),
        ZOffset = 1,
        Texture = v3.Sparkle,
        Color = ColorSequence.new(v10, p31),
        SpreadAngle = Vector2.new(180, 180),
        Speed = NumberRange.new(p33 * 0.4, p33),
        Lifetime = NumberRange.new(0.8, 1.6),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0)
        })
    }, p32)
end

local function glowFlare(p34, p35, p36, p37) -- line: 255
    -- upvalues: v3 (copy), burst (copy)
    burst(p34, p35, {
        ZOffset = 3,
        Texture = v3.Flare,
        Color = ColorSequence.new(p36),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.45),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, p37 * 0.3),
            NumberSequenceKeypoint.new(0.25, p37),
            NumberSequenceKeypoint.new(1, p37 * 1.2)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 1)
end

local function rigTemplate(p38) -- line: 274
    -- upvalues: ReplicatedStorage (copy)
    local FusionShrineRigs = ReplicatedStorage.Assets.Models:FindFirstChild("FusionShrineRigs")

    return if FusionShrineRigs and p38 then FusionShrineRigs:FindFirstChild(p38) else nil
end

local function boneNamed(p39, p40) -- line: 279
    local v20 = p39:FindFirstChild(p40, true)

    return if v20 and v20:IsA("Bone") then v20 else nil
end

local function mouthRig(p41) -- line: 284
    local v21 = p41:FindFirstChild("Head1", true)

    if not (v21 and v21:IsA("Bone")) then
        v21 = nil
    end

    local v22 = p41:FindFirstChild("MouthBottom1", true)

    if not (v22 and v22:IsA("Bone")) then
        v22 = nil
    end

    local v23 = p41:FindFirstChild("Nose1", true)

    if not (v23 and v23:IsA("Bone")) then
        v23 = nil
    end

    if not (v21 and v22 and v23) then
        return nil
    end

    local Scale = p41:GetScale()
    local LookVector = p41:GetPivot().LookVector
    local v25 = math.max((v23.WorldPosition - v22.WorldPosition):Dot(LookVector), 0)
    local v26 = v22.WorldPosition + LookVector * v25 * 0.95

    return {
        Head = v21,
        Jaw = v22,
        Nose = v23,
        Tip = v22.TransformedWorldCFrame:PointToObjectSpace(v26) / Scale,
        Forward = v21.TransformedWorldCFrame:VectorToObjectSpace(LookVector)
    }
end

local function loadRoar(p42) -- line: 304
    -- upvalues: v2 (copy)
    local v27 = p42:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = if v27 then v27:FindFirstChildOfClass("Animator") else nil

    if not Animator then
        return nil
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = v2.LionRoar

    local function v28() -- line: 312
        -- upvalues: Animator (copy), Animation (copy)
        return Animator:LoadAnimation(Animation)
    end

    local ok, result = pcall(v28)

    if not ok or not result then
        return nil
    end

    result.Looped = false
    result.Priority = Enum.AnimationPriority.Action4

    return result
end

local function homeFrame(p43, p44) -- line: 323
    -- upvalues: Kit (copy)
    return CFrame.lookAt(p43, p43 + Kit.Flat(p44))
end

local function footOf(p45) -- line: 327
    local BoundingBox, BoundingBox2 = p45:GetBoundingBox()

    return p45:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y / 2)
end

local function groundDrop(p46, p47) -- line: 332
    -- upvalues: Players (copy), Workspace (copy)
    local t8 = {
        p46.Container,
        p46.Shrine
    }
    local Transient = Workspace:FindFirstChild("Transient")

    if Transient then
        table.insert(t8, Transient)
    end

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t8, player.Character)
        end
    end

    local v29 = RaycastParams.new()

    v29.FilterType = Enum.RaycastFilterType.Exclude
    v29.FilterDescendantsInstances = t8
    v29.RespectCanCollide = true

    local v31 = Workspace:Raycast(p47.Position + p47.LookVector * 7 + Vector3.new(0, 4, 0), Vector3.new(-0, -30, -0, -0), v29)

    if not v31 then
        return 0
    end

    return (math.clamp(v31.Position.Y - p47.Position.Y, -12, 2))
end

local function buildSeatPets(p48) -- line: 355
    -- upvalues: ReplicatedStorage (copy), Assets (copy), Kit (copy), ShrinePadPets (copy), mouthRig (copy), loadRoar (copy), groundDrop (copy)
    local v33 = p48.Recipe or {}

    for v34, v35 in p48.Seats do
        for _, v36 in p48.Kind.Sides do
            local v37 = v35[v36]
            local v38 = v33[v36]

            if v37 and v38 then
                local v39 = v36 == "Lion"
                local v40 = if v39 then 12 else 21
                local PetModel = Kit.PetModel
                local v41

                if v39 then
                    local FusionShrineRigs = ReplicatedStorage.Assets.Models:FindFirstChild("FusionShrineRigs")

                    if FusionShrineRigs then
                        v41 = FusionShrineRigs:FindFirstChild(v38)
                    end
                end

                local v42 = PetModel(v38, v40, v41)

                if v42 then
                    local v43 = (Assets.Directory[v38] or {}).Animations or {}

                    v42.Parent = p48.Container

                    local t9 = {
                        Grow = 0,
                        Kind = v36,
                        Model = v42,
                        Home = ShrinePadPets.Home(p48.Kind, v36, v37, p48.Center),
                        Placed = ShrinePadPets.Size(p48.Kind, v36) / v40
                    }
                    local BoundingBox, BoundingBox2 = v42:GetBoundingBox()

                    t9.Foot = v42:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y / 2)
                    t9.Real = v39 == (v34 == 2)
                    t9.Index = v34

                    if v39 then
                        t9.Height = 10.2
                        t9.Drop = groundDrop(p48, t9.Home)
                        t9.Track = Kit.PlayAnimation(v42, v43.Idle, 1)
                        t9.Walk = Kit.PlayAnimation(v42, v43.Walk, 1.15)
                        t9.Roar = loadRoar(v42)
                        t9.Mouth = mouthRig(v42)
                    else
                        t9.Track = Kit.PlayAnimation(v42, v43.Walk or v43.Idle, 1)
                    end

                    table.insert(p48.Pets, t9)
                end
            end
        end
    end
end

local function buildPets(p49) -- line: 398
    -- upvalues: ReplicatedStorage (copy), Assets (copy), Kit (copy), v8 (copy), v9 (copy), mouthRig (copy), loadRoar (copy), buildSeatPets (copy)
    local Center = p49.Center

    p49.Pets = {}

    local v44 = p49.Recipe or {}

    if p49.Seats then
        buildSeatPets(p49)
    end

    local v45 = if p49.Seats then {} else p49.Kind.Sides

    for v46, v47 in v45 do
        local v48 = p49.Pads[v47]
        local v49 = v48.Position + Vector3.new(0, 1, 0) * (v48.Size.Y / 2)
        local v50 = Kit.Flat(Center - v49)
        local PetModel = Kit.PetModel
        local Lion, Lion2 = v44.Lion, v44.Lion
        local FusionShrineRigs = ReplicatedStorage.Assets.Models:FindFirstChild("FusionShrineRigs")
        local v51 = PetModel(Lion, 12, if FusionShrineRigs and Lion2 then FusionShrineRigs:FindFirstChild(Lion2) else nil)
        local v52 = (Assets.Directory[v44.Lion] or {}).Animations or {}

        if v51 then
            local v53 = v49 + p49.Side * 12 - v50 * 2

            v51.Parent = p49.Container

            local Pets = p49.Pets
            local t10 = {
                Kind = "Lion",
                Height = 10.2,
                Grow = 0,
                Model = v51
            }
            local v54 = Center - v53

            t10.Home = CFrame.lookAt(v53, v53 + Kit.Flat(v54))
            t10.Real = v47 == "Lion"
            t10.Index = v46
            t10.Track = Kit.PlayAnimation(v51, v52.Idle, 1)
            t10.Walk = Kit.PlayAnimation(v51, v52.Walk, 1.15)
            t10.Roar = loadRoar(v51)
            t10.Mouth = mouthRig(v51)
            table.insert(Pets, t10)
        end

        local v55 = Kit.PetModel(v44.Whale, 21)

        if v55 then
            for _, descendant in v55:GetDescendants() do
                if descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end

            local v56 = v49 - p49.Side * 9 + v50 * 3 + Vector3.new(0, 17, 0)

            v55.Parent = p49.Container

            local v57 = (Assets.Directory[v44.Whale] or {}).Animations or {}
            local Pets = p49.Pets
            local t11 = {
                Kind = "Whale",
                Grow = 0,
                Model = v55
            }
            local v58 = p49.Side:Cross((Vector3.new(0, 1, 0))) * (if v46 == 1 then 1 else -1)

            t11.Home = CFrame.lookAt(v56, v56 + Kit.Flat(v58))
            t11.Real = v47 == "Whale"
            t11.Index = v46
            t11.Track = Kit.PlayAnimation(v55, v57.Walk or v57.Idle, 1)
            table.insert(Pets, t11)
        end
    end

    for _, v59 in p49.Pets do
        if v59.Walk then
            v59.Walk:Stop(0)
        end

        v59.Model:ScaleTo(v59.Model:GetScale() * 0.02)
        v59.Scale = v59.Model:GetScale() / 0.02
        v59.Model:PivotTo(v59.Home)

        if v59.Kind == "Whale" then
            local v60 = Kit.Part({
                Name = "WhaleWake",
                Transparency = 1,
                Size = Vector3.new(0.2, 0.2, 0.2)
            })
            local Attachment = Instance.new("Attachment")

            Attachment.Position = Vector3.new(-1.4, 0, 0)
            Attachment.Parent = v60

            local Attachment2 = Instance.new("Attachment")

            Attachment2.Position = Vector3.new(1.4, 0, 0)
            Attachment2.Parent = v60

            local Trail = Instance.new("Trail")

            Trail.Attachment0 = Attachment
            Trail.Attachment1 = Attachment2
            Trail.Color = ColorSequence.new(v8, v9)
            Trail.Transparency = NumberSequence.new(0.45, 1)
            Trail.WidthScale = NumberSequence.new(1, 0.2)
            Trail.Lifetime = 0.45
            Trail.MinLength = 0.2
            Trail.LightEmission = 0.8
            Trail.LightInfluence = 0
            Trail.FaceCamera = false
            Trail.Enabled = false
            Trail.Parent = v60
            v60.Parent = p49.Container
            v59.Wake = v60
            v59.Trail = Trail
        end
    end
end

local function mouthOf(p50) -- line: 487
    local Pivot = p50.Model:GetPivot()

    return Pivot.Position + Pivot.LookVector * 5.04 + Vector3.new(0, 1, 0) * ((p50.Height or 6) * 0.42)
end

local function liveMouth(p51) -- line: 492
    -- upvalues: Kit (copy)
    local Mouth = p51.Mouth
    local LookVector = p51.Model:GetPivot().LookVector

    if Mouth and Mouth.Head.Parent then
        local v61 = Mouth.Jaw.TransformedWorldCFrame:PointToWorldSpace(Mouth.Tip * p51.Model:GetScale())
        local v62 = (Mouth.Nose.TransformedWorldCFrame.Position + v61) / 2
        local v63 = Mouth.Head.TransformedWorldCFrame:VectorToWorldSpace(Mouth.Forward) + Kit.Flat(LookVector) * 0.6

        if v63.Magnitude < 0.001 then
            v63 = LookVector
        end

        return CFrame.lookAt(v62, v62 + v63.Unit)
    end

    local Pivot = p51.Model:GetPivot()
    local v64 = Pivot.Position + Pivot.LookVector * 5.04 + Vector3.new(0, 1, 0) * ((p51.Height or 6) * 0.42)

    return CFrame.lookAt(v64, v64 + LookVector)
end

local function overWater(p52, p53) -- line: 510
    -- upvalues: Kit (copy)
    local Water = p52:FindFirstChild("Water")
    local Value = if not (Water and Water:IsA("ObjectValue")) then nil else Water.Value

    if Value and Value:IsA("BasePart") then
        local v65 = math.max(Value.Size.X, Value.Size.Z) / 2 + 12
        local t12 = {}

        for _, v66 in p53 do
            if Kit.Flat(v66.Position - Value.Position).Magnitude <= v65 then
                table.insert(t12, v66)
            end
        end

        return t12
    end

    return p53
end

local function sealPartsOf(p54) -- line: 525
    -- upvalues: partsOf (copy), overWater (copy)
    local SealCore = p54:FindFirstChild("SealCore")
    local v67 = overWater(p54, (partsOf(if not (SealCore and SealCore:IsA("ObjectValue")) then nil else SealCore.Value)))
    local t13 = {}
    local Seal = p54:FindFirstChild("Seal")
    local Value2 = if not (Seal and Seal:IsA("ObjectValue")) then nil else Seal.Value

    for _, v68 in overWater(p54, (partsOf(Value2))) do
        if not table.find(v67, v68) then
            table.insert(t13, v68)
        end
    end

    return t13, v67
end

local function setCleared(p55, p56) -- line: 536
    -- upvalues: Kit (copy), self (copy), self2 (copy), sealPartsOf (copy)
    if not (p56 or self[p55]) then
        return
    end

    self[p55] = if p56 then true else nil

    local v70, v71 = sealPartsOf(p55)

    for _, v72 in { v70, v71 } do
        for _, v73 in v72 do
            if p56 then
                if not self2[v73] then
                    self2[v73] = {
                        v73.CanCollide,
                        v73.CanQuery,
                        v73.CanTouch
                    }
                    Kit.Hide(v73)
                    v73.CanCollide = false
                    v73.CanQuery = false
                    v73.CanTouch = false
                end
            else
                Kit.Show(v73)

                local v74 = self2[v73]

                if v74 then
                    self2[v73] = nil
                    v73.CanCollide = v74[1]
                    v73.CanQuery = v74[2]
                    v73.CanTouch = v74[3]
                end
            end
        end
    end
end

local function buildSeal(p57) -- line: 566
    -- upvalues: v6 (copy), self (copy), sealPartsOf (copy)
    local Shrine = p57.Shrine

    if self[Shrine] then
        return
    end

    local v75, v76 = sealPartsOf(Shrine)

    p57.SealParts = v75
    p57.CoreParts = v76

    local Water = Shrine:FindFirstChild("Water")
    local Value = if not (Water and Water:IsA("ObjectValue")) then nil else Water.Value

    if Value and Value:IsA("BasePart") then
        p57.Water = Value
        p57.WaterSaved = {
            Color = Value.Color,
            Transparency = Value.Transparency,
            Material = Value.Material,
            Reflectance = Value.Reflectance
        }
    end

    local t14 = {}

    for _, v77 in { "Seal", "SealCore" } do
        local v78 = Shrine:FindFirstChild(v77)
        local Value = if v78 and v78:IsA("ObjectValue") then v78.Value else nil

        if Value then
            local Highlight = Instance.new("Highlight")

            Highlight.Adornee = Value
            Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            Highlight.FillColor = v6
            Highlight.OutlineColor = Color3.fromRGB(255, 240, 190)
            Highlight.FillTransparency = 1
            Highlight.OutlineTransparency = 1
            Highlight.Parent = p57.Container
            table.insert(t14, Highlight)
        end
    end

    p57.Highlights = t14
end

local function restoreWater(p58) -- line: 600
    local Water, WaterSaved = p58.Water, p58.WaterSaved

    if not (Water and WaterSaved) then
        return
    end

    Water.Color = WaterSaved.Color
    Water.Transparency = WaterSaved.Transparency
    Water.Material = WaterSaved.Material
    Water.Reflectance = WaterSaved.Reflectance
end

local function restoreSeal(p59) -- line: 610
    -- upvalues: Kit (copy), self (copy)
    if self[p59.Shrine] then
        return
    end

    for _, v79 in p59.SealParts do
        Kit.Show(v79)
    end

    for _, v80 in p59.CoreParts do
        Kit.Show(v80)
    end
end

local function shatter(p60) -- line: 622
    -- upvalues: Flash (copy), Kit (copy), v3 (copy), v6 (copy), v10 (copy), v13 (copy), kick (copy), flatWave (copy), sparkleBurst (copy), glowFlare (copy)
    local Center = p60.Center

    p60.Fragments = {}

    for _, v81 in {
            p60.SealParts,
            p60.CoreParts
        } do
        for _, v82 in v81 do
            local clone = v82:Clone()

            for _, child in clone:GetChildren() do
                if not child:IsA("SurfaceAppearance") and not child:IsA("Decal") and not child:IsA("Texture") then
                    child:Destroy()
                end
            end

            clone.Anchored = true
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CanTouch = false
            clone.Locked = true
            clone.Parent = p60.Container

            local v85 = Kit.Flat(v82.Position - Center + Vector3.new(v13:NextNumber(-1, 1), 0, v13:NextNumber(-1, 1)))

            table.insert(p60.Fragments, {
                Part = clone,
                Origin = v82.CFrame,
                Transparency = v82.Transparency,
                Out = v85,
                Axis = v85:Cross((Vector3.new(0, 1, 0))).Unit,
                Spin = v13:NextNumber(0.35, 0.75) * (v13:NextNumber() < 0.5 and -1 or 1),
                Reach = if v81 == p60.CoreParts then 0 else v13:NextNumber(34, 46),
                Lift = if v81 == p60.CoreParts then 9 else v13:NextNumber(5, 11),
                Core = v81 == p60.CoreParts
            })
            Kit.Hide(v82)
        end
    end

    for _, v86 in p60.Highlights do
        v86.FillTransparency = 1
        v86.OutlineTransparency = 1
    end

    p60.Debris = {}

    local t16 = {
        Color3.fromRGB(122, 78, 44),
        Color3.fromRGB(96, 64, 40),
        Color3.fromRGB(150, 104, 60),
        Color3.fromRGB(84, 120, 44)
    }

    for _ = 1, 26 do
        local v87 = v13:NextNumber(0, 6.283185307179586)
        local v88 = v13:NextNumber(2, 30)
        local v91 = Center + Vector3.new(math.cos(v87) * v88, 1, math.sin(v87) * v88)
        local v94 = Kit.Part({
            Name = "SealChunk",
            Size = Vector3.new(v13:NextNumber(0.8, 2.2), v13:NextNumber(0.6, 1.4), v13:NextNumber(2, 5)),
            Material = Enum.Material.Wood,
            Color = t16[v13:NextInteger(1, #t16)],
            CFrame = CFrame.new(v91) * CFrame.Angles(v13:NextNumber(0, 6), v13:NextNumber(0, 6), 0)
        })

        v94.Parent = p60.Container

        local v95 = Kit.Flat(v91 - Center)

        table.insert(p60.Debris, {
            Age = 0,
            Part = v94,
            Velocity = v95 * v13:NextNumber(14, 34) + Vector3.new(0, 1, 0) * v13:NextNumber(26, 48),
            Spin = Vector3.new(v13:NextNumber(-9, 9), v13:NextNumber(-9, 9), v13:NextNumber(-9, 9)),
            Life = v13:NextNumber(1.4, 2.2)
        })
    end

    local v98 = CFrame.new(Center + Vector3.new(0, 1.5, 0))
    local v99 = Kit.Part({
        Name = "EmitterHost",
        Transparency = 1,
        Size = Vector3.new(50, 0.4, 50),
        CFrame = v98
    })

    v99.Parent = p60.Container
    Kit.Emitter(v99, {
        LightEmission = 0.3,
        Acceleration = Vector3.new(0, -60, 0),
        Texture = v3.Shard,
        Color = ColorSequence.new(Color3.fromRGB(150, 100, 56), Color3.fromRGB(255, 214, 120)),
        Shape = Enum.ParticleEmitterShape.Box,
        EmissionDirection = Enum.NormalId.Top,
        SpreadAngle = Vector2.new(40, 40),
        Speed = NumberRange.new(24, 48),
        Lifetime = NumberRange.new(0.9, 1.6),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-360, 360),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.4),
            NumberSequenceKeypoint.new(1, 0.4)
        })
    }):Emit(70)
    Kit.Emitter(v99, {
        Drag = 1.5,
        Acceleration = Vector3.new(0, -6, 0),
        Texture = v3.Petal,
        Color = ColorSequence.new(Color3.fromRGB(120, 210, 90), Color3.fromRGB(255, 220, 110)),
        Shape = Enum.ParticleEmitterShape.Box,
        EmissionDirection = Enum.NormalId.Top,
        SpreadAngle = Vector2.new(70, 70),
        Speed = NumberRange.new(12, 30),
        Lifetime = NumberRange.new(2, 3.4),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-120, 120),
        Size = NumberSequence.new(0.9)
    }):Emit(60)
    task.delay(4, function() -- line: 730
        -- upvalues: v99 (copy)
        v99:Destroy()
    end)
    flatWave(p60, Center + Vector3.new(0, 0.6, 0), v6, 120, 0.8)
    flatWave(p60, Center + Vector3.new(0, 0.8, 0), v10, 70, 0.5)
    glowFlare(p60, Center + Vector3.new(0, 4, 0), Color3.fromRGB(255, 236, 170), 46)
    sparkleBurst(p60, Center + Vector3.new(0, 3, 0), v6, 90, 60)

    if p60.Participant then
        local Play = Flash.Play
        local t19 = {
            Attack = 0.04,
            Decay = 0.45,
            Opacity = 0.55,
            Tint = Color3.fromRGB(255, 236, 190)
        }

        pcall(Play, t19)
    end

    kick(p60, 1.6)
end

local function buildFusionField(p61) -- line: 746
    -- upvalues: Kit (copy), v3 (copy), v6 (copy), v8 (copy), v10 (copy), v13 (copy), liveMouth (copy)
    local Center = p61.Center
    local v100 = CFrame.new(Center + Vector3.new(0, 0.25, 0))
    local v101 = Kit.Part({
        Name = "EmitterHost",
        Transparency = 1,
        Size = Vector3.new(80, 0.2, 80),
        CFrame = v100
    })

    v101.Parent = p61.Container
    p61.Ripples = Kit.Emitter(v101, {
        Texture = v3.Ripple,
        Color = ColorSequence.new(v8, v10),
        Shape = Enum.ParticleEmitterShape.Box,
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Lifetime = NumberRange.new(1.2, 2),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 7)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    p61.Motes = Kit.Emitter(v101, {
        Acceleration = Vector3.new(0, 5, 0),
        Texture = v3.Sparkle,
        Color = ColorSequence.new(v8, v6),
        Shape = Enum.ParticleEmitterShape.Box,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(2, 6),
        Lifetime = NumberRange.new(2, 3.5),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 0)
        })
    })

    local v102 = Kit.Part({
        Name = "PondLight",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = CFrame.new(Center + Vector3.new(0, 3, 0))
    })

    v102.Parent = p61.Container

    local PointLight = Instance.new("PointLight")

    PointLight.Range = 60
    PointLight.Brightness = 0
    PointLight.Color = v8
    PointLight.Shadows = false
    PointLight.Parent = v102
    p61.Light = PointLight

    local v103 = Kit.Part({
        Name = "FusionCore",
        Size = Vector3.new(0.1, 0.1, 0.1),
        Transparency = 1,
        Shape = Enum.PartType.Ball,
        Material = Enum.Material.Neon,
        Color = v6,
        CFrame = CFrame.new(Center + Vector3.new(0, 3, 0))
    })

    v103.Parent = p61.Container
    p61.Core = v103

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, -2.5, 0)
    Attachment.Parent = v103
    p61.CoreAttachment = Attachment
    p61.Orbs = {}

    for i = 1, 44 do
        local v104 = i % 2 == 0
        local v105 = Kit.Part({
            Name = "EssenceMote",
            Transparency = 1,
            Shape = Enum.PartType.Ball,
            Material = Enum.Material.Neon,
            Color = if v104 then v6 else v8,
            Size = Vector3.new(1, 1, 1) * v13:NextNumber(0.35, 0.8),
            CFrame = CFrame.new(Center)
        })

        v105.Parent = p61.Container
        table.insert(p61.Orbs, {
            Part = v105,
            Phase = v13:NextNumber(0, 6.283185307179586),
            Radius = v13:NextNumber(5, 27),
            Height = v13:NextNumber(-6, 4),
            Speed = v13:NextNumber(0.8, 1.4) * (v104 and 1 or -1)
        })
    end

    p61.Rings = {}

    for v106, v107 in { 9, 16, 24 } do
        local v108 = if v106 == 2 then v8 else v6
        local v109 = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v108),
            ColorSequenceKeypoint.new(0.5, v108:Lerp(v10, 0.55)),
            ColorSequenceKeypoint.new(1, v108)
        })
        local v110 = Kit.Ring(p61.Container, v108, 1.1, 20)

        v110:Style({
            TextureLength = 9,
            Texture = v3.Energy,
            TextureMode = Enum.TextureMode.Wrap,
            TextureSpeed = if v106 % 2 == 0 then -1.4 else 1.1 + v106 * 0.2,
            Color = v109
        })
        v110:Set(CFrame.new(Center + Vector3.new(0, 0.3, 0)), v107, 1)

        local v111 = Kit.Ring(p61.Container, v108, 2.4, 20)

        v111:Style({
            Color = ColorSequence.new(v108)
        })
        v111:Set(CFrame.new(Center + Vector3.new(0, 0.25, 0)), v107, 1)
        table.insert(p61.Rings, {
            Ring = v110,
            Halo = v111,
            Radius = v107,
            Phase = v106 * 1.3
        })
    end

    local v112, v113 = CFrame.new(Center + Vector3.new(0, 0.35, 0))
    local v114 = Kit.Part({
        Name = "EmitterHost",
        Transparency = 1,
        Size = v113 or Vector3.new(0.2, 0.2, 0.2),
        CFrame = v112
    })

    v114.Parent = p61.Container
    p61.RingPulse = Kit.Emitter(v114, {
        ZOffset = 1,
        Texture = v3.Shockwave,
        Color = ColorSequence.new(v6:Lerp(v10, 0.3), v8),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Lifetime = NumberRange.new(2.4),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(1, 58)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    p61.RingImplode = Kit.Emitter(v114, {
        ZOffset = 1,
        Texture = v3.Shockwave,
        Color = ColorSequence.new(v10, v6),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Lifetime = NumberRange.new(0.9),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 50),
            NumberSequenceKeypoint.new(1, 2)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.35),
            NumberSequenceKeypoint.new(1, 0.9)
        })
    })
    p61.CoreVortex = Kit.Emitter(v103, {
        LockedToPart = true,
        ZOffset = 1,
        Texture = v3.Vortex,
        Color = ColorSequence.new(v6, v8),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.9, 1.2),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(160, 260),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 5)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    p61.CoreGlow = Kit.Emitter(v103, {
        LockedToPart = true,
        ZOffset = 2,
        Texture = v3.Flare,
        Color = ColorSequence.new(Color3.fromRGB(255, 236, 170), v8),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(0.5),
        Size = NumberSequence.new(5),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    p61.CoreSparks = Kit.Emitter(v103, {
        Texture = v3.Sparkle,
        Color = ColorSequence.new(v10, v6),
        Shape = Enum.ParticleEmitterShape.Sphere,
        ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
        ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward,
        Speed = NumberRange.new(8, 14),
        Lifetime = NumberRange.new(0.4, 0.6),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 0)
        })
    })
    p61.Streams = {}

    for _, v115 in p61.Pets do
        if v115.Kind == "Lion" and v115.Model.PrimaryPart then
            local Attachment2 = Instance.new("Attachment")

            Attachment2.Parent = v115.Model.PrimaryPart
            Attachment2.WorldPosition = liveMouth(v115).Position

            local t24 = {}

            for j = 1, 2 do
                local Beam = Instance.new("Beam")

                Beam.Attachment0 = Attachment2
                Beam.Attachment1 = Attachment

                if j == 1 then
                    Beam.Texture = v3.Energy
                else
                    Beam.Texture = v3.Water
                end

                Beam.TextureMode = Enum.TextureMode.Wrap
                Beam.TextureLength = j == 1 and 7 or 11
                Beam.TextureSpeed = j == 1 and 2.4 or 1.3
                Beam.Color = ColorSequence.new(v6, if j == 1 then v8 else v10)
                Beam.LightEmission = 1
                Beam.LightInfluence = 0
                Beam.FaceCamera = true
                Beam.Segments = 24
                Beam.Transparency = NumberSequence.new(1)
                Beam.Parent = v115.Model.PrimaryPart
                t24[j] = Beam
            end

            local t25 = {}

            for k = 1, 10 do
                local v117 = if k % 2 == 0 then v6 else v8
                local v118 = Kit.Part({
                    Name = "EssenceComet",
                    Size = Vector3.new(0.45, 0.45, 0.45),
                    Transparency = 1,
                    Shape = Enum.PartType.Ball,
                    Material = Enum.Material.Neon,
                    Color = v117,
                    CFrame = CFrame.new(Center)
                })
                local Attachment = Instance.new("Attachment")

                Attachment.Position = Vector3.new(0, 0.3, 0)
                Attachment.Parent = v118

                local Attachment2 = Instance.new("Attachment")

                Attachment2.Position = Vector3.new(0, -0.3, 0)
                Attachment2.Parent = v118

                local Trail = Instance.new("Trail")

                Trail.Attachment0 = Attachment
                Trail.Attachment1 = Attachment2
                Trail.Color = ColorSequence.new(v117, v10)
                Trail.Transparency = NumberSequence.new(0.15, 1)
                Trail.WidthScale = NumberSequence.new(1, 0)
                Trail.Lifetime = 0.3
                Trail.LightEmission = 1
                Trail.LightInfluence = 0
                Trail.FaceCamera = true
                Trail.Enabled = false
                Trail.Parent = v118
                v118.Parent = p61.Container
                t25[k] = {
                    Part = v118,
                    Trail = Trail,
                    Offset = (k - 1) / 10,
                    Side = v13:NextNumber(-1, 1),
                    Lift = v13:NextNumber(2, 7)
                }
            end

            table.insert(p61.Streams, {
                Ribbons = t24,
                Comets = t25,
                Mouth = Attachment2,
                Pet = v115
            })
        end
    end
end

local function roarWaves(p62) -- line: 1007
    -- upvalues: Kit (copy), v3 (copy), v6 (copy), v7 (copy), glowFlare (copy), liveMouth (copy)
    for _, v119 in p62.Pets do
        if v119.Kind == "Lion" then
            local v120 = liveMouth(v119)
            local v121 = Kit.Part({
                Name = "EmitterHost",
                Transparency = 1,
                Size = Vector3.new(0.2, 0.2, 0.2),
                CFrame = v120
            })

            v121.Parent = p62.Container
            v119.RoarHost = v121

            local v122 = Kit.Emitter(v121, {
                Rate = 9,
                Enabled = true,
                ZOffset = 2,
                Texture = v3.Shockwave,
                Color = ColorSequence.new(Color3.fromRGB(255, 232, 150), v6),
                Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
                EmissionDirection = Enum.NormalId.Front,
                Speed = NumberRange.new(52),
                Lifetime = NumberRange.new(0.95),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 3),
                    NumberSequenceKeypoint.new(1, 17)
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.05),
                    NumberSequenceKeypoint.new(0.7, 0.4),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
            local v123 = Kit.Emitter(v121, {
                Drag = 1,
                Rate = 70,
                Enabled = true,
                Texture = v3.Sparkle,
                Color = ColorSequence.new(v6, v7),
                EmissionDirection = Enum.NormalId.Front,
                SpreadAngle = Vector2.new(22, 22),
                Speed = NumberRange.new(30, 60),
                Lifetime = NumberRange.new(0.6, 1.1),
                Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.8),
                    NumberSequenceKeypoint.new(1, 0)
                })
            })

            glowFlare(p62, v120.Position, v6, 12)
            task.delay(1.15 * p62.Scale, function() -- line: 1049
                -- upvalues: v119 (copy), v121 (copy), v122 (copy), v123 (copy)
                v122.Enabled = false
                v123.Enabled = false
                v119.RoarHost = nil
                task.delay(1.5, function() -- line: 1053
                    -- upvalues: v121 (copy)
                    v121:Destroy()
                end)
            end)
        end
    end
end

local function splash(p63, p64) -- line: 1061
    -- upvalues: v3 (copy), v8 (copy), v10 (copy), burst (copy), flatWave (copy), sparkleBurst (copy)
    burst(p63, p64, {
        LightEmission = 0.6,
        Acceleration = Vector3.new(0, -70, 0),
        Texture = v3.Water,
        Color = ColorSequence.new(v10, v8),
        EmissionDirection = Enum.NormalId.Top,
        SpreadAngle = Vector2.new(28, 28),
        Speed = NumberRange.new(34, 62),
        Lifetime = NumberRange.new(0.9, 1.5),
        Rotation = NumberRange.new(0, 360),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2.2),
            NumberSequenceKeypoint.new(1, 4.5)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 46)
    flatWave(p63, p64 + Vector3.new(0, 0.3, 0), v8, 44, 0.9)
    sparkleBurst(p63, p64 + Vector3.new(0, 2, 0), v8, 40, 36)
end

local function lionRise(p65, p66) -- line: 1085
    -- upvalues: Kit (copy)
    return Kit.Window(p66, 0.05 + p65.Index * 0.15, 1.1 + p65.Index * 0.15)
end

local function lionWalk(p67) -- line: 1089
    -- upvalues: Kit (copy)
    return Kit.Ease(Kit.Window(p67, 1.35, 2.45), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
end

local function whaleArrive(p68) -- line: 1093
    local v125 = 0.2 + p68.Index * 0.35

    return v125, v125 + 3.2
end

local function petFrame(p69, p70, p71) -- line: 1098
    -- upvalues: Kit (copy), v4 (copy)
    local Home = p70.Home

    if p70.Kind == "Lion" then
        local v126 = Kit.Ease(Kit.Window(p71, 1.35, 2.45), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local v127 = Home + Home.LookVector * (v126 * 7)

        if p70.Drop then
            v127 += Vector3.new(0, 1, 0) * (p70.Drop * Kit.Smooth(Kit.Window(v126, 0.35, 0.8)))
        end

        local v128 = Kit.Window(p71, v4.Fuse, v4.Fuse + 0.6)
        local v130 = math.sin(p71 * 6) * 0.15 * v128
        local v131 = Kit.Ease(Kit.Window(p71, 0.05 + p70.Index * 0.15, 1.1 + p70.Index * 0.15), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local v132 = if p70.Placed then 0 else -(1 - v131) * (p70.Height or 12) * 0.9

        if p70.Roar then
            return (v127 + Vector3.new(0, 1, 0) * (v132 + v130)) * CFrame.Angles(-0.08 * v128, 0, 0)
        end

        local v133 = Kit.Smooth(Kit.Window(p71, v4.Crack, v4.Roar))
        local v134 = Kit.Window(p71, v4.Roar, v4.Roar + 0.45)
        local v135 = Kit.Smooth(Kit.Window(p71, v4.Roar + 1.3, v4.Shatter + 0.5))
        local v136 = Kit.BackOut(v134) * (1 - v135)
        local v137 = -0.12 * v133 * (1 - v134) + 0.44 * v136
        local v138 = 1.9 * v136 - 0.5 * v133 * (1 - v134)

        return (v127 + v127.LookVector * (1.4 * v136) + Vector3.new(0, 1, 0) * (v132 + v138 + v130)) * CFrame.Angles(v137 - 0.08 * v128, 0, 0)
    end

    local v140 = math.sin(p71 * 1.7 + p70.Index) * 0.9

    if p70.Placed and p71 < v4.Dive then
        return Home + Vector3.new(0, 1, 0) * (v140 * Kit.Smooth(Kit.Window(p71, 0, 1.2)))
    end

    if p71 < v4.Dive then
        local v141 = 0.2 + p70.Index * 0.35
        local v142 = v141 + 3.2
        local v143 = Home + Vector3.new(0, 1, 0) * v140

        if v142 + 0.8 <= p71 then
            return v143
        end

        local v144 = Home.Position + Kit.Flat(Home.Position - p69.Center) * 60 + Vector3.new(0, 38, 0)
        local v145 = (v144 + Home.Position) / 2 + Vector3.new(0, 14, 0) + Home.LookVector * -18
        local v146 = Kit.Ease(Kit.Window(p71, v141, v142), Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local v147 = Kit.Bezier(v144, v145, Home.Position, v146)
        local v149 = Kit.Bezier(v144, v145, Home.Position, (math.min(v146 + 0.03, 1))) - v147

        return (if v149.Magnitude > 0.001 then CFrame.lookAt(v147, v147 + v149.Unit) else CFrame.new(v147) * Home.Rotation):Lerp(v143, (Kit.Smooth(Kit.Window(p71, v142 - 0.5, v142 + 0.8))))
    end

    local v150 = p69.Center + Kit.Flat(Home.Position - p69.Center) * 9 - Vector3.new(0, 3, 0)

    if p71 < v4.Splash then
        local v151 = Kit.Window(p71, v4.Dive, v4.Splash)
        local v152 = Kit.Ease(v151, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v153 = (Home.Position + v150) / 2 + Vector3.new(0, 16, 0)
        local v154 = Home.Position + Vector3.new(0, 1, 0) * v140
        local v155 = Kit.Bezier(v154, v153, v150, v152)
        local v156 = (v153 - v154) * (1 - v152) + (v150 - v153) * v152

        if v156.Magnitude < 0.001 then
            v156 = v150 - Home.Position
        end

        local v157 = CFrame.lookAt(v155, v155 + v156.Unit)

        p70.DiveRotation = v157.Rotation

        return v157
    end

    local v158 = p71 - v4.Splash
    local v161 = math.atan2(v150.Z - p69.Center.Z, v150.X - p69.Center.X)
    local v162 = Kit.Smooth(Kit.Window(p71, v4.Collapse, 15))

    local function swimAt(p72) -- line: 1163
        -- upvalues: p69 (copy), v161 (copy), v162 (copy), Kit (copy)
        local v164 = Kit.Smooth((math.min(p72 / 1.6, 1)))
        local v168 = v161 + (p72 * 1.1 + (1 - math.exp(p72 * -1.5)) * 0.6 + p72 * 0.18 * p72)
        local v169 = Kit.Lerp(Kit.Lerp(9, 15, v164), 6, v162)
        local v170 = Kit.Lerp(Kit.Lerp(3, 7.5, v164), 4, v162)

        return p69.Center + Vector3.new(math.cos(v168) * v169, -v170 + math.sin(p72 * 3) * 0.6 * v164, math.sin(v168) * v169)
    end

    local v176 = swimAt(v158)
    local v177 = CFrame.lookAt(v176, (swimAt(v158 + 0.06)))
    local v179 = Kit.Smooth((math.min(v158 / 0.55, 1)))

    if v179 >= 1 or not p70.DiveRotation then
        return v177
    end

    return (CFrame.new(v176) * p70.DiveRotation):Lerp(v177, v179)
end

local function petScale(p73, p74, p75) -- line: 1185
    -- upvalues: Kit (copy), v4 (copy), lionRise (copy)
    local v180

    if p74.Placed then
        v180 = Kit.Lerp(p74.Placed, 1, Kit.Smooth(Kit.Window(p75, 0.25, 1.5)))
    elseif p74.Kind == "Lion" then
        v180 = Kit.Lerp(0.35, 1, Kit.Smooth(lionRise(p74, p75)))
    else
        local v181 = 0.2 + p74.Index * 0.35
        local _ = v181 + 3.2

        v180 = Kit.Lerp(0.15, 1, Kit.Smooth(Kit.Window(p75, v181, v181 + 1.4)))
    end

    local v182 = if p74.Kind == "Lion" then math.max(0, 1 - math.abs(p75 - v4.Roar - 0.15) / 0.35) * 0.08 + 1 else 1
    local v185 = 1 - Kit.Smooth(Kit.Window(p75, v4.Collapse + 0.6, v4.Collapse + 1.6))

    if p73.PayoffAt then
        v185 = 0
    end

    return (math.max(v180 * v182 * v185, 0.02))
end

local function stepPets(p76, p77) -- line: 1205
    -- upvalues: v4 (copy), v6 (copy), v8 (copy), sparkleBurst (copy), liveMouth (copy), petFrame (copy), petScale (copy)
    for _, v187 in p76.Pets do
        if v187.Model.Parent then
            local v188 = petScale(p76, v187, p77)

            if math.abs(v188 - v187.Grow) > 0.001 then
                v187.Grow = v188
                v187.Model:ScaleTo((math.max(v187.Scale * v188, 0.01)))
            end

            local v191 = petFrame(p76, v187, p77)

            if v187.Foot then
                v191 += Vector3.new(0, 1, 0) * (v187.Foot * v188)
            end

            v187.Model:PivotTo(v191)

            if v187.RoarHost then
                v187.RoarHost.CFrame = liveMouth(v187)
            end

            if v187.Wake then
                v187.Wake.CFrame = v191

                local v192 = 0.2 + v187.Index * 0.35 + 3.2
                local Trail = v187.Trail
                local v193

                if p77 < v192 + 0.4 then
                    v193 = not v187.Placed

                    if not v193 then
                        v193 = v4.Dive + 0.15 <= p77 and p77 < v4.Collapse + 0.6
                    end
                else
                    v193 = v4.Dive + 0.15 <= p77 and p77 < v4.Collapse + 0.6
                end

                Trail.Enabled = v193
            end

            if v188 <= 0.03 and v4.Collapse < p77 and not v187.Dissolved then
                v187.Dissolved = true
                sparkleBurst(p76, v187.Model:GetPivot().Position, if v187.Kind == "Lion" then v6 else v8, 30, 18)
                v187.Model.Parent = nil
            end
        end
    end
end

local function stepSeal(p78, p79, p80) -- line: 1243
    -- upvalues: Kit (copy), v4 (copy), v6 (copy), v10 (copy), sparkleBurst (copy), glowFlare (copy)
    local v195 = Kit.Window(p79, v4.Crack, v4.Shatter)

    if p78.Fragments then
        local v196 = p79 - v4.Shatter

        for _, v197 in p78.Fragments do
            local Part = v197.Part

            if v197.Core then
                local v199 = Kit.Smooth((math.min(v196 / 0.5, 1)))

                Part.CFrame = v197.Origin + Vector3.new(0, 1, 0) * v197.Lift * v199
                Part.Transparency = Kit.Lerp(v197.Transparency, 1, Kit.Window(v196, 0.25, 0.6))

                if v196 > 0.35 and not v197.Popped then
                    v197.Popped = true
                    sparkleBurst(p78, Part.Position, v6, 50, 40)
                    glowFlare(p78, Part.Position, v10, 18)
                end
            else
                local v201 = Kit.Ease(math.min(v196 / 1.6, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
                local v204 = math.sin(3.141592653589793 * math.min(v196 / 0.9, 1)) * v197.Lift
                local v206 = math.max(v196 - 0.9, 0) ^ 2 * 9
                local v207 = CFrame.fromAxisAngle(v197.Axis, v197.Spin * v201)

                Part.CFrame = CFrame.new(v197.Origin.Position + v197.Out * v197.Reach * v201 + Vector3.new(0, 1, 0) * (v204 - v206)) * v207 * v197.Origin.Rotation
                Part.Transparency = Kit.Lerp(v197.Transparency, 1, Kit.Window(v196, 0.7, 1.8))
            end
        end

        for _, v208 in p78.Debris do
            if v208.Part.Parent then
                v208.Age += p80
                v208.Velocity -= Vector3.new(0, 80, 0) * p80
                v208.Part.CFrame = (v208.Part.CFrame + v208.Velocity * p80) * CFrame.Angles(v208.Spin.X * p80, v208.Spin.Y * p80, v208.Spin.Z * p80)
                v208.Part.Transparency = Kit.Window(v208.Age, v208.Life - 0.5, v208.Life)

                if v208.Age > v208.Life then
                    v208.Part:Destroy()
                end
            end
        end
    else
        for _, v209 in p78.Highlights do
            v209.FillTransparency = 1 - v195 * ((math.sin(p79 * (10 + 26 * v195)) * 0.5 + 0.5) * 0.25 + 0.35)
            v209.OutlineTransparency = 1 - v195 * 0.9
        end
    end
end

local function stepWater(p81, p82) -- line: 1291
    -- upvalues: Kit (copy), v4 (copy), v5 (copy), v6 (copy), v8 (copy), v9 (copy)
    local Water, WaterSaved = p81.Water, p81.WaterSaved
    local v211 = Kit.Smooth(Kit.Window(p82, v4.Shatter, v4.Reveal + 1.2))
    local v212 = Kit.Window(p82, v4.Fuse, v4.Collapse + 1.4)

    if Water and WaterSaved and v211 > 0 then
        local v214 = math.sin(p82 * (2 + 9 * v212)) * 0.5 + 0.5
        local v215 = v8:Lerp(v9, 0.35 * v212 * v214):Lerp(Color3.fromRGB(255, 236, 170), 0.4 * v212 * v212)

        Water.Material = Enum.Material.Glass
        Water.Color = WaterSaved.Color:Lerp(v215, v211)
        Water.Transparency = Kit.Lerp(WaterSaved.Transparency, 0.3, v211)
        Water.Reflectance = Kit.Lerp(WaterSaved.Reflectance, 0.15, v211)
    end

    if p81.Light then
        p81.Light.Brightness = v211 * 1 + v212 * 2.2
        p81.Light.Color = v8:Lerp(v6, v212 * 0.6)
        p81.Light.Range = 50 + 20 * v212
    end

    if p81.Ripples then
        local v216 = if p81.P then 1 - Kit.Window(p81.P, v5.Present, v5.Done - 0.5) else 1

        p81.Ripples.Rate = v211 * (6 + 30 * v212) * v216

        local Ripples = p81.Ripples

        if v211 > 0 then
            Ripples.Enabled = v216 > 0
        else
            Ripples.Enabled = false
        end

        p81.Motes.Rate = v211 * (4 + 50 * v212) * v216

        local Motes = p81.Motes

        if v211 > 0 then
            Motes.Enabled = v216 > 0
        else
            Motes.Enabled = false
        end
    end
end

local function stepFusion(p83, p84) -- line: 1320
    -- upvalues: Kit (copy), v4 (copy), v6 (copy), v8 (copy), v10 (copy), liveMouth (copy)
    local Center = p83.Center
    local v217 = Kit.Window(p84, v4.Fuse, v4.Fuse + 1.2)
    local v218 = Kit.Smooth(Kit.Window(p84, v4.Collapse, 15))
    local v219 = p83.PayoffAt ~= nil

    for _, v220 in p83.Orbs do
        if v219 then
            v220.Part.Transparency = 1
        else
            local v221 = v220.Phase + p84 * v220.Speed * (1 + 3 * v218)
            local v222 = v220.Radius * (1 - 0.88 * v218) * (0.6 + 0.4 * v217)
            local v225 = v220.Height * (1 - v218) + 3 * v218 + math.sin(p84 * 2 + v220.Phase) * 0.5

            v220.Part.CFrame = CFrame.new(Center + Vector3.new(math.cos(v221) * v222, v225, math.sin(v221) * v222))
            v220.Part.Transparency = 1 - v217 * 0.9
        end
    end

    for _, v228 in p83.Rings do
        local v230 = math.sin(p84 * 2.4 + v228.Phase) * 0.05 + 1
        local v232 = math.max(v228.Radius * v230 * (1 - 0.9 * v218), 0.2)
        local v234 = math.sin(p84 * 5 + v228.Phase * 2) * 0.15 + 0.85
        local v235 = Vector3.new(0, 1, 0) * (0.3 + v218 * 2)

        v228.Ring:Set(CFrame.new(Center + v235), v232, if v219 then 1 else 1 - v217 * 0.7 * v234, 1.1 + 0.5 * v218)
        v228.Halo:Set(CFrame.new(Center + v235 - Vector3.new(0, 0.05, 0)), v232, if v219 then 1 else 1 - v217 * 0.14 * v234, 2.4 + 1.6 * v218)
    end

    local RingPulse = p83.RingPulse

    if v219 then
        RingPulse.Rate = 0
    else
        RingPulse.Rate = v217 * (1 - v218) * 1.4
    end

    p83.RingPulse.Enabled = p83.RingPulse.Rate > 0.05

    local RingImplode = p83.RingImplode

    if v219 then
        RingImplode.Rate = 0
    else
        RingImplode.Rate = v218 * 3.5
    end

    p83.RingImplode.Enabled = p83.RingImplode.Rate > 0.05

    local v237 = math.max(p84 - v4.Fuse, 0)
    local v238 = Kit.Ease(v237 / 3.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local v239 = if v237 < 3.4 then v237 * 0.22 + v237 ^ 3 * 1.08 / 34.67999999999999 else (v237 - 3.4) * 1.3 + 1.972
    local v240 = 0.2 + 0.8 * v238
    local CorePosition = p83.Core.Position

    for _, v241 in p83.Streams do
        local v242, v243

        if v241.Pet.Model.Parent ~= nil and not v219 then
            v243 = v217 * (1 - Kit.Window(p84, v4.Collapse + 0.6, v4.Collapse + 1.4))
            v242 = liveMouth(v241.Pet).Position
            v241.Mouth.WorldCFrame = CFrame.lookAt(v242, CorePosition)
        else
            v242 = Center
            v243 = 0
        end

        for v244, v245 in v241.Ribbons do
            local v246 = v243 * (0.2 + 0.8 * v238)
            local v247 = v246 * (if v244 == 1 then 0.55 else 0.75)
            local v249 = math.sin(p84 * 9 + v244) * 0.15 + 0.85

            v245.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.15, 1 - v247),
                NumberSequenceKeypoint.new(0.85, 1 - v247),
                NumberSequenceKeypoint.new(1, 1)
            })
            v245.Width0 = (v244 == 1 and 1.6 or 0.7) * v246 * v249
            v245.Width1 = (v244 == 1 and 3.2 or 1.4) * v246 * v249
            v245.TextureSpeed = (v244 == 1 and 2.4 or 1.3) * (0.15 + 0.85 * v238)
            v245.CurveSize0 = math.sin(p84 * 2.2 + v241.Pet.Index + v244) * 7 * v243
            v245.CurveSize1 = math.cos(p84 * 1.7 + v244) * 5 * v243
        end

        local v252 = CorePosition - v242
        local v253 = v252:Cross((Vector3.new(0, 1, 0)))
        local v254 = if v253.Magnitude > 0.001 then v253.Unit else Vector3.new(1, 0, 0)

        for _, v255 in v241.Comets do
            local v256 = (v239 + v255.Offset) % 1
            local v257 = v255.Last ~= nil and v256 < v255.Last

            v255.Last = v256

            if v243 < 0.05 or v240 < v255.Offset then
                v255.Part.Transparency = 1
                v255.Trail.Enabled = false
            else
                local v258 = v242 + v252 * 0.5 + v254 * v255.Side * 6 + Vector3.new(0, 1, 0) * v255.Lift
                local v260 = math.sin(3.141592653589793 * v256)

                v255.Part.CFrame = CFrame.new(Kit.Bezier(v242, v258, CorePosition, v256))
                v255.Part.Transparency = 1 - v243 * v260
                v255.Part.Size = Vector3.new(1, 1, 1) * (v260 * 0.45 + 0.3)
                v255.Trail.Enabled = not v257
            end
        end
    end

    local Core = p83.Core

    if v219 then
        p83.CoreVortex.Enabled = false
        p83.CoreGlow.Enabled = false
        p83.CoreSparks.Enabled = false
    else
        local v261 = Kit.Window(p84, v4.Fuse + 0.6, 15)
        local v263 = math.sin(p84 * (12 + 30 * v218)) * 0.12 + 1
        local v264 = (0.6 + 2.2 * v261 * v261 + 2.4 * v218) * v263

        Core.Size = Vector3.new(1, 1, 1) * v264
        Core.Transparency = 1 - math.min(v261 * 1.6, 1) * 0.55
        p83.CoreVortex.Rate = 4 + 16 * v261
        p83.CoreVortex.Enabled = v261 > 0.02
        p83.CoreVortex.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v264 * 1.6),
            NumberSequenceKeypoint.new(1, v264 * 3.6)
        })
        p83.CoreGlow.Rate = 6 + 10 * v261
        p83.CoreGlow.Enabled = v261 > 0.02
        p83.CoreGlow.Size = NumberSequence.new(v264 * 3)
        p83.CoreSparks.Rate = 20 + 90 * v218
        p83.CoreSparks.Enabled = v261 > 0.1
        Core.Color = v6:Lerp(v8, math.sin(p84 * 5) * 0.5 + 0.5):Lerp(v10, v218 * 0.85)
        Core.CFrame = CFrame.new(Center + Vector3.new(0, 1, 0) * (2 + v218))
    end
end

local function beats(p85, p86) -- line: 1444
    -- upvalues: Kit (copy), v1 (copy), v3 (copy), v4 (copy), v6 (copy), v8 (copy), kick (copy), burst (copy), flatWave (copy), sparkleBurst (copy), shatter (copy), buildFusionField (copy), roarWaves (copy), splash (copy)
    local Fired = p85.Fired

    local function once(p87, p88) -- line: 1446
        -- upvalues: p86 (copy), Fired (copy)
        if Fired[p87] or p86 < p88 then
            return false
        end

        Fired[p87] = true

        return true
    end

    if not (Fired.Appear or p86 < 0.1) then
        Fired.Appear = true

        local Center = p85.Center
        local v267 = Kit.Sound(v1.Appear, Center or p85.Center, 1.2, nil)

        if v267 then
            p85.Sounds[v267] = true
        end

        for _, v268 in p85.Pets do
            if v268.Kind == "Lion" then
                local v269 = 0.05 + v268.Index * 0.15

                task.delay(v269 * p85.Scale, function() -- line: 1460
                    -- upvalues: p85 (copy), v268 (copy), v3 (copy), v6 (copy), v8 (copy), burst (copy), flatWave (copy), sparkleBurst (copy)
                    local v271, burst2, v272, t27, new, v273, v274

                    if p85.Dead then
                        v274 = true
                    elseif v268.Model.Parent then
                        v271 = v268.Home.Position - Vector3.new(0, 1, 0) * (v268.Height or 12) * 0.35
                        flatWave(p85, v271, v6, 26, 1.2)
                        sparkleBurst(p85, v271, v6, 36, 16)
                        burst2 = burst
                        v272 = p85
                        t27 = {
                            Drag = 2,
                            Texture = v3.Petal
                        }
                        new = ColorSequence.new
                        v273 = if v268.Kind == "Lion" then v6 else v8
                        v274 = false
                    else
                        v274 = true
                    end

                    if v274 then
                        return
                    end

                    t27.Color = new(v273)
                    t27.SpreadAngle = Vector2.new(180, 180)
                    t27.Speed = NumberRange.new(8, 18)
                    t27.Lifetime = NumberRange.new(1, 1.8)
                    t27.Rotation = NumberRange.new(0, 360)
                    t27.RotSpeed = NumberRange.new(-180, 180)
                    t27.Size = NumberSequence.new(0.8)
                    burst2(v272, v271, t27, 24)
                end)
            end
        end
    end

    if not (Fired.Walk or p86 < 1.35) then
        Fired.Walk = true

        for _, v275 in p85.Pets do
            if v275.Walk and v275.Track then
                v275.Walk:Play(0.25, 1, 1.15)
                v275.Track:Stop(0.25)
            end
        end
    end

    local Halt = v4.Halt

    if not (Fired.Halt or p86 < Halt) then
        Fired.Halt = true

        for _, v276 in p85.Pets do
            if v276.Walk and v276.Track then
                v276.Walk:Stop(0.25)
                v276.Track:Play(0.25)
            end

            if v276.Roar then
                v276.Roar:Play(0.2, 1, 1 / p85.Scale)
                v276.Roar.TimePosition = math.max(p86 - v4.Halt, 0)
            end
        end
    end

    local Crack = v4.Crack

    if not (Fired.Crack or p86 < Crack) then
        Fired.Crack = true

        local Center = p85.Center
        local v278 = Kit.Sound(v1.SealCrack, Center or p85.Center, 1.3, nil)

        if v278 then
            p85.Sounds[v278] = true
        end

        kick(p85, 0.35)
    end

    local Roar = v4.Roar

    if not (Fired.Roar or p86 < Roar) then
        Fired.Roar = true

        for _, v279 in p85.Pets do
            if v279.Kind == "Lion" then
                local HomePosition = v279.Home.Position
                local v280 = if v279.Real then 1 else 0.92
                local v281 = Kit.Sound(v1.Roar, HomePosition or p85.Center, 1.5, v280)

                if v281 then
                    p85.Sounds[v281] = true
                end
            end
        end

        roarWaves(p85)
        kick(p85, 1.1)
        p85.FovKick = 1
    end

    local Shatter = v4.Shatter

    if not (Fired.Shatter or p86 < Shatter) then
        Fired.Shatter = true

        local Center = p85.Center
        local v282 = Kit.Sound(v1.SealShatter, Center or p85.Center, 1.6, nil)

        if v282 then
            p85.Sounds[v282] = true
        end

        shatter(p85)
    end

    local Reveal = v4.Reveal

    if not (Fired.Reveal or p86 < Reveal) then
        Fired.Reveal = true

        local Center = p85.Center
        local v283 = Kit.Sound(v1.WaterReveal, Center or p85.Center, 1.2, nil)

        if v283 then
            p85.Sounds[v283] = true
        end

        buildFusionField(p85)
    end

    local WhaleCall = v4.WhaleCall

    if not (Fired.WhaleCall or p86 < WhaleCall) then
        Fired.WhaleCall = true

        for _, v284 in p85.Pets do
            if v284.Kind == "Whale" and v284.Real then
                local HomePosition = v284.Home.Position
                local v285 = Kit.Sound(v1.WhaleCall, HomePosition or p85.Center, 1.3, nil)

                if v285 then
                    p85.Sounds[v285] = true
                end
            end
        end
    end

    local Splash = v4.Splash

    if not (Fired.Splash or p86 < Splash) then
        Fired.Splash = true

        local Center = p85.Center
        local v286 = Kit.Sound(v1.Splash, Center or p85.Center, 1.5, nil)

        if v286 then
            p85.Sounds[v286] = true
        end

        for _, v287 in p85.Pets do
            if v287.Kind == "Whale" then
                splash(p85, p85.Center + Kit.Flat(v287.Home.Position - p85.Center) * 9)
            end
        end

        kick(p85, 2.2)
        p85.FovKick = math.max(p85.FovKick, 0.7)
    end

    local Fuse = v4.Fuse

    if not (Fired.Fuse or p86 < Fuse) then
        Fired.Fuse = true

        local Center = p85.Center
        local v288 = Kit.Sound(v1.Charge, Center or p85.Center, 1.1, nil)

        if v288 then
            p85.Sounds[v288] = true
        end

        p85.ChargeSound = v288
    end

    local v289 = v4.Collapse + 1.3

    if not (Fired.Collapse or p86 < v289) then
        Fired.Collapse = true

        local Center = p85.Center
        local v290 = Kit.Sound(v1.Collapse, Center or p85.Center, 1.4, nil)

        if v290 then
            p85.Sounds[v290] = true
        end
    end

    if not (v4.Collapse <= p86) then
        return
    end

    p85.ShakePower = math.max(p85.ShakePower, 0.25 + 0.5 * Kit.Window(p86, v4.Collapse, 15))
end

local function regrow(p89, p90) -- line: 1553
    -- upvalues: Kit (copy)
    if p89.Fragments then
        for _, v292 in p89.Fragments do
            if v292.Core then
                v292.Part.CFrame = v292.Origin
                v292.Part.Transparency = Kit.Lerp(1, v292.Transparency, Kit.Window(p90, 0.7, 1))
            else
                local v293 = 1 - Kit.Ease(p90, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

                v292.Part.CFrame = v292.Origin + v292.Out * v292.Reach * v293 - Vector3.new(0, 3, 0) * v293
                v292.Part.Transparency = Kit.Lerp(1, v292.Transparency, Kit.Window(p90, 0, 0.6))
            end
        end

        local Water, WaterSaved = p89.Water, p89.WaterSaved

        if Water and WaterSaved then
            Water.Color = Water.Color:Lerp(WaterSaved.Color, p90)
            Water.Transparency = Kit.Lerp(Water.Transparency, WaterSaved.Transparency, p90)
            Water.Reflectance = Kit.Lerp(Water.Reflectance, WaterSaved.Reflectance, p90)
        end

        if p89.Light then
            p89.Light.Brightness *= 1 - p90
        end
    end
end

local function makeEggs(p91) -- line: 1582
    -- upvalues: Kit (copy), v6 (copy), v8 (copy), v10 (copy)
    p91.Eggs = {}

    local Seats = p91.Seats

    for i = 1, if Seats then #Seats else #p91.Kind.Sides do
        local v294 = p91.Kind.Sides[i] or p91.Kind.Sides[1]
        local v295 = if Seats then Seats[i] else nil
        local v296 = if v295 then v295.Lion or v295.Whale else p91.Pads[v294]
        local v297 = v296.Position + Vector3.new(0, 1, 0) * (v296.Size.Y / 2)
        local v298 = v297 + Kit.Flat(p91.Center - v297) * 7
        local v299 = Kit.EggModel(p91.Fused, 5.4, if i == 1 then v8 else v6)
        local _, BoundingBox = v299:GetBoundingBox()

        v299:ScaleTo(v299:GetScale() * 0.25)
        v299.Parent = p91.Container

        local v300 = Kit.Part({
            Name = "EggGlow",
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2)
        })

        v300.Parent = p91.Container

        local Attachment = Instance.new("Attachment")

        Attachment.Position = Vector3.new(0, 1.2, 0)
        Attachment.Parent = v300

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Position = Vector3.new(0, -1.2, 0)
        Attachment2.Parent = v300

        local Trail = Instance.new("Trail")

        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment2
        Trail.Color = ColorSequence.new(if i == 1 then v8 else v6, v10)
        Trail.Transparency = NumberSequence.new(0.1, 1)
        Trail.Lifetime = 0.5
        Trail.LightEmission = 1
        Trail.LightInfluence = 0
        Trail.FaceCamera = true
        Trail.Parent = v300

        local PointLight = Instance.new("PointLight")

        if i == 1 then
            PointLight.Color = v8
        else
            PointLight.Color = v6
        end

        PointLight.Range = 14
        PointLight.Brightness = 3
        PointLight.Parent = v300

        local Eggs = p91.Eggs
        local t28 = {
            Model = v299,
            Full = v299:GetScale() * 4,
            Host = v300,
            Trail = Trail,
            Side = v294,
            Index = i,
            Land = v298 + Vector3.new(0, 1, 0) * (BoundingBox.Y / 2)
        }

        if v295 then
            t28.Character = v295.Character
            t28.Guard = p91.Guards[i]
        else
            t28.Character = p91.Characters[v294]
            t28.Guard = p91.Guards[v294]
        end

        table.insert(Eggs, t28)
    end
end

local function stepEggs(p92, p93) -- line: 1632
    -- upvalues: Kit (copy), v1 (copy), v5 (copy), v6 (copy), v8 (copy), v10 (copy), kick (copy), flatWave (copy), sparkleBurst (copy), glowFlare (copy)
    local Center = p92.Center
    local v301 = Center + Vector3.new(0, 24, 0)

    for _, v302 in p92.Eggs do
        local Model = v302.Model

        if Model.Parent then
            local v303 = if v302.Index == 1 then 0 else 3.141592653589793
            local v304 = p93 * 9
            local v305 = Kit.BackOut(Kit.Window(p93, v5.Burst, v5.Apex))
            local v307 = v302.Full * math.max(0.25 + 0.75 * v305, 0.05)

            if p93 < v5.Apex then
                local v308 = Kit.Ease(Kit.Window(p93, v5.Burst, v5.Apex), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                local v309 = 2.2 * v308
                local v310 = v303 + p93 * 10
                local v314 = Center:Lerp(v301, v308) + Vector3.new(math.cos(v310) * v309, 0, math.sin(v310) * v309)

                if math.abs(Model:GetScale() - v307) > 1E-04 then
                    Model:ScaleTo((math.max(v307, 0.01)))
                end

                local v316 = if v5.Land <= p93 and p93 < v5.Handoff then math.sin(p93 * 16) * 0.12 * math.exp(-(p93 - v5.Land) * 1.5) else 0

                Model:PivotTo(CFrame.new(v314) * CFrame.Angles(v316, v304, v316 * 0.5))
                v302.Host.CFrame = CFrame.new(v314)
                v302.Position = v314
            elseif p93 < v5.Split then
                local v320 = v303 + v5.Apex * 10 + (p93 - v5.Apex) * 4
                local v321 = math.cos(v320) * 2.2
                local v323 = math.sin(p93 * 4) * 0.4
                local v324 = math.sin(v320) * 2.2
                local v325 = v301 + Vector3.new(v321, v323, v324)

                v304 = v5.Apex * 9 + (p93 - v5.Apex) * 3

                if math.abs(Model:GetScale() - v307) > 1E-04 then
                    Model:ScaleTo((math.max(v307, 0.01)))
                end

                local v327 = if v5.Land <= p93 and p93 < v5.Handoff then math.sin(p93 * 16) * 0.12 * math.exp(-(p93 - v5.Land) * 1.5) else 0

                Model:PivotTo(CFrame.new(v325) * CFrame.Angles(v327, v304, v327 * 0.5))
                v302.Host.CFrame = CFrame.new(v325)
                v302.Position = v325
            elseif p93 < v5.Land then
                local v331 = Kit.Window(p93, v5.Split, v5.Land)
                local v334 = v301 + Vector3.new(math.cos(v303) * 2.2, 0, math.sin(v303) * 2.2)
                local v335 = (v334 + v302.Land) / 2 + Vector3.new(0, 14, 0)
                local v336 = Kit.Bezier(v334, v335, v302.Land, Kit.Ease(v331, Enum.EasingStyle.Sine, Enum.EasingDirection.In))

                v304 = v5.Apex * 9 + v331 * 3.141592653589793 * 3

                if math.abs(Model:GetScale() - v307) > 1E-04 then
                    Model:ScaleTo((math.max(v307, 0.01)))
                end

                local v338 = if v5.Land <= p93 and p93 < v5.Handoff then math.sin(p93 * 16) * 0.12 * math.exp(-(p93 - v5.Land) * 1.5) else 0

                Model:PivotTo(CFrame.new(v336) * CFrame.Angles(v338, v304, v338 * 0.5))
                v302.Host.CFrame = CFrame.new(v336)
                v302.Position = v336
            elseif p93 < v5.Handoff then
                local v342 = p93 - v5.Land
                local v348 = math.abs((math.sin(math.min(v342 / 0.45, 1) * 3.141592653589793))) * 1.4 * math.exp(-v342 * 2)
                local v349 = v302.Land + Vector3.new(0, 1, 0) * v348

                if not v302.Landed then
                    v302.Landed = true
                    v302.Trail.Enabled = false

                    local Land = v302.Land
                    local v350 = Kit.Sound(v1.EggLand, Land or p92.Center, 1.2, nil)

                    if v350 then
                        p92.Sounds[v350] = true
                    end

                    flatWave(p92, v302.Land - Vector3.new(0, 2, 0), if v302.Index == 1 then v8 else v6, 22, 0.6)
                    sparkleBurst(p92, v302.Land, if v302.Index == 1 then v8 else v6, 40, 20)
                    kick(p92, 0.4)
                end

                if not v302.Character and v5.Caught < p93 then
                    sparkleBurst(p92, v302.Land, v6, 30, 14)
                    Model.Parent = nil
                    v302.Host.Parent = nil
                    continue
                end

                v304 = 0

                if math.abs(Model:GetScale() - v307) > 1E-04 then
                    Model:ScaleTo((math.max(v307, 0.01)))
                end

                local v355 = if v5.Land <= p93 and p93 < v5.Handoff then math.sin(p93 * 16) * 0.12 * math.exp(-(p93 - v5.Land) * 1.5) else 0

                Model:PivotTo(CFrame.new(v349) * CFrame.Angles(v355, v304, v355 * 0.5))
                v302.Host.CFrame = CFrame.new(v349)
                v302.Position = v349
            elseif v302.Character then
                local v359 = Kit.Window(p93, v5.Handoff, v5.Caught)
                local v360 = Kit.RootOf(v302.Character)
                local v361 = if v360 then v360.Position + Vector3.new(0, 1.5, 0) else v302.Land
                local v362 = (v302.Land + v361) / 2 + Vector3.new(0, 7, 0)
                local v363 = Kit.Bezier(v302.Land, v362, v361, v359 * v359)

                v304 = v359 * 3.141592653589793 * 4
                v307 *= 1 - Kit.Window(v359, 0.6, 1) * 0.95
                v302.Trail.Enabled = true

                if v359 >= 1 then
                    if v302.Guard then
                        v302.Guard:Reveal()
                    end

                    sparkleBurst(p92, v361, v6, 50, 22)
                    glowFlare(p92, v361, v10, 10)
                    Model.Parent = nil
                    v302.Host.Parent = nil
                else
                    if math.abs(Model:GetScale() - v307) > 1E-04 then
                        Model:ScaleTo((math.max(v307, 0.01)))
                    end

                    local v365 = if v5.Land <= p93 and p93 < v5.Handoff then math.sin(p93 * 16) * 0.12 * math.exp(-(p93 - v5.Land) * 1.5) else 0

                    Model:PivotTo(CFrame.new(v363) * CFrame.Angles(v365, v304, v365 * 0.5))
                    v302.Host.CFrame = CFrame.new(v363)
                    v302.Position = v363
                end
            else
                local v369 = p93 - v5.Land
                local v375 = math.abs((math.sin(math.min(v369 / 0.45, 1) * 3.141592653589793))) * 1.4 * math.exp(-v369 * 2)
                local v376 = v302.Land + Vector3.new(0, 1, 0) * v375

                if not v302.Landed then
                    v302.Landed = true
                    v302.Trail.Enabled = false

                    local Land = v302.Land
                    local v377 = Kit.Sound(v1.EggLand, Land or p92.Center, 1.2, nil)

                    if v377 then
                        p92.Sounds[v377] = true
                    end

                    flatWave(p92, v302.Land - Vector3.new(0, 2, 0), if v302.Index == 1 then v8 else v6, 22, 0.6)
                    sparkleBurst(p92, v302.Land, if v302.Index == 1 then v8 else v6, 40, 20)
                    kick(p92, 0.4)
                end

                if v302.Character then
                    v304 = 0

                    if math.abs(Model:GetScale() - v307) > 1E-04 then
                        Model:ScaleTo((math.max(v307, 0.01)))
                    end

                    local v382 = if v5.Land <= p93 and p93 < v5.Handoff then math.sin(p93 * 16) * 0.12 * math.exp(-(p93 - v5.Land) * 1.5) else 0

                    Model:PivotTo(CFrame.new(v376) * CFrame.Angles(v382, v304, v382 * 0.5))
                    v302.Host.CFrame = CFrame.new(v376)
                    v302.Position = v376
                elseif v5.Caught < p93 then
                    sparkleBurst(p92, v302.Land, v6, 30, 14)
                    Model.Parent = nil
                    v302.Host.Parent = nil
                else
                    v304 = 0

                    if math.abs(Model:GetScale() - v307) > 1E-04 then
                        Model:ScaleTo((math.max(v307, 0.01)))
                    end

                    local v387 = if v5.Land <= p93 and p93 < v5.Handoff then math.sin(p93 * 16) * 0.12 * math.exp(-(p93 - v5.Land) * 1.5) else 0

                    Model:PivotTo(CFrame.new(v376) * CFrame.Angles(v387, v304, v387 * 0.5))
                    v302.Host.CFrame = CFrame.new(v376)
                    v302.Position = v376
                end
            end
        end
    end
end

local function payoffBurst(p94) -- line: 1724
    -- upvalues: Flash (copy), Kit (copy), v1 (copy), v3 (copy), v6 (copy), v8 (copy), v10 (copy), fadeOut (copy), kick (copy), burst (copy), flatWave (copy), sparkleBurst (copy), glowFlare (copy)
    local Center = p94.Center
    local v391 = Kit.Sound(v1.EggBurst, Center or p94.Center, 1.7, nil)

    if v391 then
        p94.Sounds[v391] = true
    end

    fadeOut(p94.ChargeSound, 0.45)

    if p94.Participant then
        local Play = Flash.Play
        local t29 = {
            Attack = 0.03,
            Decay = 0.6,
            Opacity = 0.9,
            Tint = v10
        }

        pcall(Play, t29)
    end

    kick(p94, 2)
    p94.FovKick = 1.3

    local v392 = Kit.Part({
        Name = "GeyserBase",
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        CFrame = CFrame.new(Center)
    })

    v392.Parent = p94.Container

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = v392

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, 0.2, 0)
    Attachment2.Parent = v392

    local t30 = {}

    for v393, v394 in {
            {
                Width = 13,
                Speed = -4,
                Length = 10,
                Texture = v3.Energy,
                Color = ColorSequence.new(v8, v10)
            },
            {
                Width = 7,
                Speed = -6,
                Length = 14,
                Texture = v3.Water,
                Color = ColorSequence.new(v10, v8)
            }
        } do
        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2
        Beam.Texture = v394.Texture
        Beam.TextureMode = Enum.TextureMode.Wrap
        Beam.TextureLength = v394.Length
        Beam.TextureSpeed = v394.Speed
        Beam.Color = v394.Color
        Beam.LightEmission = 1
        Beam.LightInfluence = 0
        Beam.FaceCamera = true
        Beam.Segments = 10
        Beam.Width0 = v394.Width
        Beam.Width1 = v394.Width * 0.55
        Beam.Transparency = NumberSequence.new(1)
        Beam.Parent = v392
        t30[v393] = {
            Beam = Beam,
            Width = v394.Width,
            Floor = v393 == 1 and 0.25 or 0.1
        }
    end

    p94.Geyser = {
        Top = Attachment2,
        Pillars = t30,
        Column = Kit.Emitter(v392, {
            LightEmission = 0.6,
            Acceleration = Vector3.new(0, -60, 0),
            Rate = 180,
            Enabled = true,
            Texture = v3.Water,
            Color = ColorSequence.new(v10, v8),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(6, 6),
            Speed = NumberRange.new(70, 110),
            Lifetime = NumberRange.new(1, 1.5),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-90, 90),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 3),
                NumberSequenceKeypoint.new(1, 9)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 1)
            })
        }),
        Mist = Kit.Emitter(v392, {
            LightEmission = 0.4,
            Drag = 2,
            Acceleration = Vector3.new(0, -6, 0),
            Rate = 70,
            Enabled = true,
            Texture = v3.Smoke,
            Color = ColorSequence.new(v10, v8),
            EmissionDirection = Enum.NormalId.Top,
            SpreadAngle = Vector2.new(85, 85),
            Speed = NumberRange.new(18, 34),
            Lifetime = NumberRange.new(1.4, 2.2),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-40, 40),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 6),
                NumberSequenceKeypoint.new(1, 15)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.55),
                NumberSequenceKeypoint.new(1, 1)
            })
        })
    }
    burst(p94, Center, {
        LightEmission = 0.7,
        Acceleration = Vector3.new(0, -75, 0),
        Texture = v3.Water,
        Color = ColorSequence.new(v10, v8),
        EmissionDirection = Enum.NormalId.Top,
        SpreadAngle = Vector2.new(22, 22),
        Speed = NumberRange.new(55, 95),
        Lifetime = NumberRange.new(1.2, 2),
        Rotation = NumberRange.new(0, 360),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(1, 6)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 90)
    burst(p94, Center + Vector3.new(0, 4, 0), {
        ZOffset = 4,
        Texture = v3.Sunburst,
        Color = ColorSequence.new(Color3.fromRGB(255, 240, 200)),
        Speed = NumberRange.new(0),
        Lifetime = NumberRange.new(1.2),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-40, 40),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 10),
            NumberSequenceKeypoint.new(1, 42)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, 2)
    flatWave(p94, Center + Vector3.new(0, 0.4, 0), v8, 130, 1)
    flatWave(p94, Center + Vector3.new(0, 0.6, 0), v6, 90, 0.7)
    glowFlare(p94, Center + Vector3.new(0, 5, 0), v10, 60)
    sparkleBurst(p94, Center + Vector3.new(0, 6, 0), v6, 120, 70)
    sparkleBurst(p94, Center + Vector3.new(0, 6, 0), v8, 80, 55)

    for _, v395 in p94.Pets do
        if v395.Model.Parent then
            sparkleBurst(p94, v395.Model:GetPivot().Position, v6, 20, 14)
            v395.Model.Parent = nil
        end
    end

    if p94.Core then
        p94.Core.Transparency = 1
    end
end

local function stepGeyser(p95, p96) -- line: 1881
    -- upvalues: Kit (copy), v5 (copy)
    local Geyser = p95.Geyser

    if not Geyser then
        return
    end

    local v396 = Kit.Ease(Kit.Window(p96, v5.Burst, v5.Burst + 0.35), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local v397 = Kit.Smooth(Kit.Window(p96, v5.Burst + 0.7, v5.Split + 0.6))
    local v398 = 46 * v396 * (1 - 0.35 * v397)

    Geyser.Top.Position = Vector3.new(0, math.max(v398, 0.2), 0)

    for _, v400 in Geyser.Pillars do
        local v401 = Kit.Lerp(v400.Floor, 1, v397)

        v400.Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v401),
            NumberSequenceKeypoint.new(0.7, v401 + (1 - v401) * 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })

        local v403 = math.sin(p96 * 30) * 0.06 + 1

        v400.Beam.Width0 = v400.Width * v403 * (1 - 0.4 * v397)
        v400.Beam.Width1 = v400.Width * 0.55 * v403 * (1 - 0.4 * v397)
    end

    Geyser.Column.Rate = 180 * (1 - v397)
    Geyser.Column.Enabled = v397 < 1
    Geyser.Mist.Rate = 70 * (1 - v397)
    Geyser.Mist.Enabled = v397 < 1
end

local function finish(p97) -- line: 1911
    -- upvalues: t2 (ref), fadeOut (copy), setCleared (copy), restoreSeal (copy)
    if p97.Dead then
        return
    end

    p97.Dead = true

    if t2 == p97 then
        t2 = nil
    end

    for v404 in p97.Sounds do
        if v404.Parent and v404.Looped then
            fadeOut(v404, 0.6)
        end
    end

    fadeOut(p97.ChargeSound, 0.6)

    local Bed = p97.Bed

    if Bed and Bed.Parent then
        fadeOut(Bed, p97.PayoffAt and 2.2 or 0.8)
        task.delay(3, function() -- line: 1928
            -- upvalues: Bed (copy)
            Bed:Destroy()
        end)
    end

    for _, v406 in p97.Guards do
        v406:Reveal()
    end

    if not (p97.PayoffAt and p97.Participant) then
        restoreSeal(p97)
    else
        setCleared(p97.Shrine, true)
    end

    local Water, WaterSaved = p97.Water, p97.WaterSaved

    if Water and WaterSaved then
        Water.Color = WaterSaved.Color
        Water.Transparency = WaterSaved.Transparency
        Water.Material = WaterSaved.Material
        Water.Reflectance = WaterSaved.Reflectance
    end

    p97.Trove:Destroy()
end

local function step(p98, p99) -- line: 1944
    -- upvalues: Workspace (copy), Kit (copy), v5 (copy), stepPets (copy), stepSeal (copy), stepWater (copy), stepFusion (copy), beats (copy), regrow (copy), stepEggs (copy), payoffBurst (copy), stepGeyser (copy), finish (copy)
    if p98.Dead then
        return
    end

    local v407 = (Workspace:GetServerTimeNow() - p98.StartAt) / p98.Scale

    if p98.PayoffAt then
        v407 = math.max(v407, 15)
    end

    p98.T = v407
    p98.ShakePower = p98.ShakePower * math.exp(-p99 * 3.2)
    p98.FovKick = p98.FovKick * math.exp(-p99 * 4)
    beats(p98, v407)
    stepPets(p98, v407)
    stepSeal(p98, v407, p99)
    stepWater(p98, v407)

    if p98.Core then
        stepFusion(p98, v407)
    end

    local PayoffAt = p98.PayoffAt

    if not PayoffAt then
        return
    end

    local v410 = os.clock() - PayoffAt

    p98.P = v410

    if not p98.Burst and v5.Burst <= v410 then
        p98.Burst = true
        payoffBurst(p98)
    end

    if p98.Core and not p98.Burst then
        p98.Core.Size = Vector3.new(1, 1, 1) * math.max(p98.Core.Size.X * (1 - p99 * 18), 0.3)
    end

    stepGeyser(p98, v410)
    stepEggs(p98, v410)

    if v5.Present <= v410 then
        regrow(p98, Kit.Window(v410, v5.Present, v5.Done - 0.3))
    end

    if v5.Handoff <= v410 and p98.OnDone then
        local OnDone = p98.OnDone

        p98.OnDone = nil
        task.spawn(OnDone)
    end

    if v5.Done <= v410 then
        finish(p98)
    end
end

local function catmull(p100, p101, p102, p103, p104) -- line: 1990
    local v412 = p104 * p104
    local v413 = p104 * p104 * p104

    return (p101 * 2 + (p102 - p100) * p104 + (p100 * 2 - p101 * 5 + p102 * 4 - p103) * v412 + (p101 * 3 - p100 - p102 * 3 + p103) * v413) * 0.5
end

local function around(p105, p106) -- line: 2001
    return CFrame.fromAxisAngle(Vector3.new(0, 1, 0), p106):VectorToWorldSpace(p105.Side)
end

local function whaleFocus(p107) -- line: 2005
    local v414 = Vector3.new(0, 0, 0)
    local n1 = 0

    for _, v415 in p107.Pets do
        if v415.Kind == "Whale" and v415.Model.Parent then
            v414 += v415.Model:GetPivot().Position
            n1 += 1
        end
    end

    if n1 > 0 then
        return v414 / n1
    end

    return p107.Center
end

local function pathKeys(p108) -- line: 2016
    -- upvalues: Kit (copy), whaleFocus (copy)
    local Center, HeroLion = p108.Center, p108.HeroLion
    local v416 = if HeroLion then HeroLion.Home.Position + HeroLion.Home.LookVector * 7 + Vector3.new(0, 1, 0) * (HeroLion.Drop or 0) else Center + p108.Side * 40
    local v417 = Kit.Flat(Center - v416)
    local v418 = v417:Cross((Vector3.new(0, 1, 0)))

    if v418:Dot(p108.Side) < 0 then
        v418 = -v418
    end

    local v419

    if HeroLion then
        local Pivot = HeroLion.Model:GetPivot()

        v419 = Pivot.Position + Pivot.LookVector * 5.04 + Vector3.new(0, 1, 0) * ((HeroLion.Height or 6) * 0.42)
    else
        v419 = v416 + Vector3.new(0, 6, 0)
    end

    local v420 = whaleFocus(p108)

    return {
        {
            T = -1,
            Fov = 62,
            At = Center + p108.Side * 70 + Vector3.new(0, 36, 0),
            Look = Center + Vector3.new(0, 2, 0)
        },
        {
            T = 0,
            Fov = 62,
            At = Center + p108.Side * 64 + Vector3.new(0, 32, 0),
            Look = Center + Vector3.new(0, 2, 0)
        },
        {
            T = 1.7,
            Fov = 60,
            At = v416 + v418 * 32 - v417 * 4 + Vector3.new(0, 13, 0),
            Look = v416 + Vector3.new(0, 5, 0)
        },
        {
            T = 3.3,
            Fov = 56,
            At = v416 + v418 * 23 + v417 * 11 + Vector3.new(0, 5, 0),
            Look = v419 - Vector3.new(0, 2, 0)
        },
        {
            T = 4.4,
            Fov = 58,
            At = v416 + v418 * 26 + v417 * 24 + Vector3.new(0, 12, 0),
            Look = v419:Lerp(Center, 0.65)
        },
        {
            T = 5.4,
            Fov = 64,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.25):VectorToWorldSpace(p108.Side) * 34 + Vector3.new(0, 46, 0),
            Look = Center
        },
        {
            T = 6.8,
            Fov = 66,
            At = Center + p108.Side * 50 + Vector3.new(0, 22, 0),
            Look = v420:Lerp(Center, 0.3)
        },
        {
            T = 8.2,
            Fov = 60,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.1):VectorToWorldSpace(p108.Side) * 47 + Vector3.new(0, 16, 0),
            Look = Center
        },
        {
            T = 10.4,
            Fov = 56,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.5):VectorToWorldSpace(p108.Side) * 43 + Vector3.new(0, 15, 0),
            Look = Center
        },
        {
            T = 12.6,
            Fov = 52,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 0.85):VectorToWorldSpace(p108.Side) * 37 + Vector3.new(0, 12, 0),
            Look = Center + Vector3.new(0, 1, 0)
        },
        {
            T = 15,
            Fov = 45,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 1.05):VectorToWorldSpace(p108.Side) * 25 + Vector3.new(0, 7, 0),
            Look = Center + Vector3.new(0, 2.5, 0)
        },
        {
            T = 17,
            Fov = 44,
            At = Center + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), 1.15):VectorToWorldSpace(p108.Side) * 22 + Vector3.new(0, 6, 0),
            Look = Center + Vector3.new(0, 3, 0)
        }
    }
end

local function samplePath(p109, p110) -- line: 2065
    -- upvalues: Kit (copy), pathKeys (copy)
    local v421 = pathKeys(p109)
    local n2 = 2

    while n2 < #v421 - 2 and v421[n2 + 1].T < p110 do
        n2 += 1
    end

    local v422 = v421[n2 - 1]
    local v423 = v421[n2]
    local v424 = v421[n2 + 1]
    local v425 = v421[n2 + 2]
    local v426 = Kit.Clamp01((p110 - v423.T) / (v424.T - v423.T))
    local v427 = Kit.Smooth(v426) * 0.35 + v426 * 0.65
    local At = v422.At
    local At2 = v423.At
    local At3 = v424.At
    local At4 = v425.At
    local v428 = v427 * v427
    local v429 = v427 * v427 * v427
    local v430 = (At2 * 2 + (At3 - At) * v427 + (At * 2 - At2 * 5 + At3 * 4 - At4) * v428 + (At2 * 3 - At - At3 * 3 + At4) * v429) * 0.5
    local Look = v422.Look
    local Look2 = v423.Look
    local Look3 = v424.Look
    local Look4 = v425.Look
    local v431 = v427 * v427
    local v432 = v427 * v427 * v427

    return v430, (Look2 * 2 + (Look3 - Look) * v427 + (Look * 2 - Look2 * 5 + Look3 * 4 - Look4) * v431 + (Look2 * 3 - Look - Look3 * 3 + Look4) * v432) * 0.5, Kit.Lerp(v423.Fov, v424.Fov, Kit.Smooth(v426))
end

local function payoffPath(p111, p112) -- line: 2079
    -- upvalues: Kit (copy), v5 (copy)
    local Center, PayoffFrom = p111.Center, p111.PayoffFrom
    local v433 = Kit.Smooth(Kit.Window(p112, 0, v5.Apex))
    local v434 = PayoffFrom + Kit.Flat(PayoffFrom - Center) * 10 * v433 + Vector3.new(0, 3, 0) * v433
    local v435 = (Center + Vector3.new(0, 3, 0)):Lerp(Center + Vector3.new(0, 20, 0), Kit.Smooth(Kit.Window(p112, v5.Burst, v5.Apex)))
    local v436 = Kit.Lerp(46, 60, v433)
    local MyEgg = p111.MyEgg
    local v437, v438, v439

    if MyEgg then
        local Land = MyEgg.Land
        local v440 = Kit.Smooth(Kit.Window(p112, v5.Apex - 0.2, v5.Land + 0.2))
        local v441 = Land + Kit.Flat(Center - Land) * 7 + p111.Side * 24 + Vector3.new(0, 11, 0)

        if MyEgg.Position then
            Land = MyEgg.Position:Lerp(Land, 0.35)
        end

        v437 = v434:Lerp(v441, v440)
        v438 = v435:Lerp(Land, v440)
        v439 = Kit.Lerp(v436, 58, v440)
    else
        v439 = v436
        v438 = v435
        v437 = v434
    end

    return v437, v438, v439
end

function t1.Camera(_, p114) -- line: 2102
    -- upvalues: Kit (copy), t2 (ref), samplePath (copy), payoffPath (copy)
    local t32 = t2
    local v442, v443, v444, v445

    if not t32 or t32.Dead then
        v445 = true
    elseif t32.Participant and t32.T then
        if t32.PayoffAt then
            if not t32.PayoffFrom then
                if t32.Cam then
                    t32.PayoffFrom = t32.Cam.At
                else
                    t32.PayoffFrom = t32.Center + t32.Side * 30
                end
            end

            v442, v443, v444 = payoffPath(t32, t32.P or 0)
        else
            v442, v443, v444 = samplePath(t32, t32.T)
        end

        v445 = false
    else
        v445 = true
    end

    if v445 then
        return nil, nil
    end

    local Cam = t32.Cam

    if not Cam then
        Cam = {
            At = v442,
            Look = v443,
            Fov = v444
        }
        t32.Cam = Cam
    end

    local v447 = 1 - math.exp(-p114 * 4.5)

    Cam.At = Cam.At:Lerp(v442, v447)
    Cam.Look = Cam.Look:Lerp(v443, v447)
    Cam.Fov = Kit.Lerp(Cam.Fov, v444, v447)

    local v448 = Kit.ReducedMotion()
    local v449 = if v448 then 0 else t32.ShakePower
    local elapsed = os.clock()
    local v453 = Vector3.new(math.noise(elapsed * 20, 1.3), math.noise(elapsed * 20, 7.9), math.noise(elapsed * 20, 4.1)) * v449
    local v454 = math.noise(elapsed * 13, 9.4) * 0.05585053606381855 * v449
    local v455 = CFrame.lookAt(Cam.At + v453, Cam.Look) * CFrame.Angles(0, 0, v454)
    local v456 = if v448 then 0 else t32.FovKick * 12

    return v455, (math.clamp(Cam.Fov + v456, 30, 90))
end

function t1.IsPlaying() -- line: 2141
    -- upvalues: t2 (ref)
    return t2 ~= nil
end

function t1.ActiveShrine() -- line: 2145
    -- upvalues: t2 (ref)
    return if t2 then t2.Shrine else nil
end

function t1.IsResolving() -- line: 2149
    -- upvalues: t2 (ref)
    return t2 ~= nil and t2.PayoffAt ~= nil
end

function t1.FlightFocus() -- line: 2153
    return nil
end

function t1.Begin(p115) -- line: 2157
    -- upvalues: RunService (copy), Workspace (copy), ShrineFusionFlags (copy), Kit (copy), Trove (copy), t2 (ref), startBed (copy), buildPets (copy), buildSeal (copy), finish (copy), step (copy)
    if t2 and t2.Shrine == p115.Shrine and not t2.Dead then
        if p115.Participant and not t2.Participant then
            t2.Participant = true
            t2.Gui = p115.Gui
        end

        return true
    end

    if t2 then
        finish(t2)
    end

    local Shrine = p115.Shrine
    local Pond = Shrine:FindFirstChild("Pond")

    if Pond and Pond:IsA("BasePart") then
        local Id = p115.Kind.Id
        local v458 = ShrineFusionFlags.ShrineRitualSeconds:Get()[Id] or ShrineFusionFlags.RitualSeconds:Get()
        local t34 = {
            ShakePower = 0,
            FovKick = 0,
            Trove = Trove.new(),
            Shrine = Shrine,
            Kind = p115.Kind,
            Pads = p115.Pads,
            Seats = if type(p115.Seats) ~= "table" or not (#p115.Seats > 0) then nil else p115.Seats,
            Characters = p115.Characters or {},
            Tier = p115.Tier,
            Recipe = p115.Recipe or ShrineFusionFlags.Recipes:Get()[p115.Tier],
            Fused = p115.FusedCategory,
            Participant = p115.Participant == true,
            Gui = p115.Gui,
            Center = Pond.Position + Vector3.new(0, 1, 0) * (Pond.Size.Y / 2),
            Side = Kit.Flat(Pond.CFrame.LookVector),
            StartAt = p115.EndsAt - v458,
            EndsAt = p115.EndsAt,
            Scale = v458 / 15,
            Fired = {},
            Sounds = {},
            Guards = {},
            Highlights = {},
            SealParts = {},
            CoreParts = {}
        }

        t34.Fused = t34.Fused or t34.Recipe and t34.Recipe.Fused

        local Parent = p115.Parent
        local Folder = Instance.new("Folder")

        Folder.Name = "EnchantedFusion"
        Folder.Parent = Parent or Workspace:FindFirstChild("Transient") or Workspace
        t34.Container = Folder
        t34.Trove:Add(t34.Container)

        if t34.Seats then
            for v459, v460 in t34.Seats do
                t34.Guards[v459] = Kit.ToolGuard(v460.Character)
            end
        else
            for v461, v462 in t34.Characters do
                t34.Guards[v461] = Kit.ToolGuard(v462)
            end
        end

        t2 = t34
        startBed(t34)
        buildSeal(t34)
        buildPets(t34)

        for _, v463 in t34.Pets do
            if v463.Kind == "Lion" and v463.Real then
                t34.HeroLion = v463
            end
        end

        t34.HeroLion = t34.HeroLion or t34.Pets[1]
        t34.Trove:Connect(RunService.RenderStepped, function(p116) -- line: 2225
            -- upvalues: t34 (copy), finish (copy), step (copy)
            local ok, result = pcall(step, t34, p116)

            if not ok then
                warn("[EnchantedPond] step failed:", result)
                finish(t34)
            end
        end)

        return true
    end

    warn("[EnchantedPond] shrine needs a Pond part:", Shrine:GetFullName())

    return false
end

function t1.Payoff(p117) -- line: 2235
    -- upvalues: Kit (copy), t2 (ref), makeEggs (copy)
    local t35 = t2

    if not t35 or t35.Dead then
        return false
    end

    if t35.PayoffAt then
        t35.OnDone = t35.OnDone or p117
    else
        t35.PayoffAt = os.clock()
        t35.OnDone = p117

        local v464 = Kit.LocalPlayerCharacter()

        makeEggs(t35)

        for _, v465 in t35.Eggs do
            if v464 and v465.Character == v464 then
                t35.MyEgg = v465
            end
        end
    end

    return true
end

function t1.Settle(p118, p119) -- line: 2256
    -- upvalues: t2 (ref), setCleared (copy)
    if not t2 or t2.Shrine ~= p118 then
        setCleared(p118, p119)
    end
end

function t1.Cancel() -- line: 2263
    -- upvalues: t2 (ref), finish (copy)
    if t2 then
        finish(t2)
    end
end

return table.freeze(t1)
