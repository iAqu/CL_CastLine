-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Copies = require(ReplicatedStorage.UserGenerated.Observability.Copies)
local Motion = require(ReplicatedStorage.UserGenerated.Observability.Motion)

require(ReplicatedStorage.UserGenerated.Observability.Registry)

local Sequences = require(ReplicatedStorage.UserGenerated.Observability.Sequences)
local Op, ValueType, RootId, AssemblyRootProperty = Observability.Op, Observability.ValueType, Observability.RootId, Observability.AssemblyRootProperty
local SurfaceIdProperty, SurfaceIdAttribute, BakedTag, BakedIdAttribute = Observability.SurfaceIdProperty, Observability.SurfaceIdAttribute, Observability.BakedTag, Observability.BakedIdAttribute
local BakedOriginAttribute, UnbakedTag, UnbakedAttribute, BakeIdProperty = Observability.BakedOriginAttribute, Observability.UnbakedTag, Observability.UnbakedAttribute, Observability.BakeIdProperty
local PivotProperty, EmissionScaleProperty = Observability.PivotProperty, Observability.EmissionScaleProperty

local function v1() -- line: 126
    return workspace[nil]
end

local function v2() -- line: 128
    return debug.info(2, "f")
end

local v3

v3, v1 = xpcall(v1, v2)

local v4 = v1

if type(v1) ~= "function" then
    v4 = function(p1, p2) -- line: 132
        return p1[p2]
    end
end

local t1 = {
    Color = true,
    MeshId = true,
    TextureID = true
}
local t2 = {
    [ValueType.Float32] = true,
    [ValueType.Vector3] = true,
    [ValueType.Color3] = true,
    [ValueType.CFrame] = true
}
local t3 = {
    CFrame = true,
    Position = true,
    Orientation = true,
    Rotation = true
}
local t4 = {
    "Part0",
    "Part1",
    "C0",
    "C1",
    "Enabled"
}
local t5 = {
    RigidConstraint = true,
    AnimationConstraint = true
}
local t6 = {
    Beam = true,
    Shirt = true,
    Pants = true,
    SpecialMesh = true,
    BlockMesh = true,
    CylinderMesh = true,
    FileMesh = true,
    Decal = true,
    Texture = true,
    SurfaceAppearance = true
}
local t7 = {
    Color = true,
    Transparency = true,
    LocalTransparencyModifier = true
}
local t8 = {
    [Enum.CameraType.Scriptable] = true,
    [Enum.CameraType.Fixed] = true,
    [Enum.CameraType.Watch] = true
}
local v5 = Enum.RenderPriority.Camera.Value + 1
local t9 = {
    CFrame = true,
    Position = true,
    Orientation = true,
    Axis = true,
    SecondaryAxis = true
}

local function sequenceKey(p3, p4, p5) -- line: 266
    -- upvalues: Sequences (copy)
    return (("%*:%*"):format(p3, (Sequences.key(Sequences.keypoints(p4, p5)))))
end

local function writeEncoded(p6, p7) -- line: 271
    local v6 = #p7

    p6:_ensure(v6)
    buffer.writestring(p6.buf, p6.len, p7)
    p6.len += v6
end

local function predicts(p8, p9, p10) -- line: 278
    -- upvalues: Motion (copy)
    if p9 < p8.T then
        return false
    end

    local v7 = Motion.at(p8.Base, p8.W, p8.V, p8.A, (p9 - p8.T) / 1000)

    return not Motion.apart(v7, p10, 0.2, 0.02)
end

local function newPollQueue() -- line: 289
    return {
        Cursor = 1,
        Set = setmetatable({}, {
            __mode = "k"
        }),
        List = {}
    }
end

local function newWatch() -- line: 304
    return {
        Connections = {},
        Kids = {},
        Names = {}
    }
end

local function cframeMoved(p11, p12) -- line: 311
    if (p11.Position - p12.Position).Magnitude > 0.02 then
        return true
    end

    local XVector = p11.XVector
    local XVector2 = p12.XVector
    local YVector = p11.YVector
    local YVector2 = p12.YVector

    if math.abs(XVector.X - XVector2.X) > 0.003 or math.abs(XVector.Y - XVector2.Y) > 0.003 or math.abs(XVector.Z - XVector2.Z) > 0.003 or math.abs(YVector.X - YVector2.X) > 0.003 or math.abs(YVector.Y - YVector2.Y) > 0.003 then
        return true
    end

    return math.abs(YVector.Z - YVector2.Z) > 0.003
end

local function rotationMoved(p13, p14) -- line: 325
    -- upvalues: cframeMoved (copy)
    return (cframeMoved(p13.Rotation, p14.Rotation))
end

local function subjectPart(p15) -- line: 330
    if not p15 then
        return nil
    end

    if p15:IsA("Humanoid") then
        return p15.RootPart
    end

    if p15:IsA("BasePart") then
        return p15
    end

    return if p15:IsA("Model") then p15.PrimaryPart else nil
end

local function isWorldGui(p16) -- line: 346
    return p16:IsA("BillboardGui") or p16:IsA("SurfaceGui")
end

local function inPlayerCharacter(p17) -- line: 350
    -- upvalues: Players (copy)
    local Parent = p17.Parent

    while true do
        if not Parent or Parent == workspace then
            return false
        end

        if not (Parent:IsA("Model") and Players:GetPlayerFromCharacter(Parent)) then
            Parent = Parent.Parent
            continue
        end

        break
    end

    return true
end

local function hasLocalTransparency(p18) -- line: 361
    return p18:IsA("BasePart") or p18:IsA("Decal")
end

local function particleHost(p19) -- line: 367
    local Parent = p19.Parent

    while Parent and Parent:IsA("Attachment") do
        Parent = Parent.Parent
    end

    return if Parent and Parent:IsA("BasePart") and not Parent:IsA("Terrain") then Parent else nil
end

local function bakedId(p20) -- line: 375
    -- upvalues: CollectionService (copy), BakedTag (copy), BakedIdAttribute (copy)
    if not p20:IsA("Model") and not p20:IsA("Folder") and not p20:IsA("Configuration") or not CollectionService:HasTag(p20, BakedTag) then
        return nil
    end

    local Attribute = p20:GetAttribute(BakedIdAttribute)

    return if type(Attribute) == "string" and Attribute ~= "" then Attribute else nil
end

local function bakedPivot(p21) -- line: 384
    -- upvalues: BakedOriginAttribute (copy)
    local Attribute = p21:GetAttribute(BakedOriginAttribute)
    local Pivot = p21:GetPivot()

    if typeof(Attribute) == "CFrame" then
        return Pivot * Attribute:Inverse()
    end

    return Pivot
end

local function seedKind(p22) -- line: 391
    -- upvalues: t5 (copy), t6 (copy), bakedId (copy)
    if p22:IsA("BasePart") then
        return if not p22:IsA("Terrain") then "part" else nil
    end

    if p22:IsA("Bone") then
        return "visual"
    end

    local ClassName = p22.ClassName

    if p22:IsA("JointInstance") or p22:IsA("WeldConstraint") or t5[ClassName] then
        return "joint"
    end

    if t6[ClassName] then
        return "visual"
    end

    if p22:IsA("BillboardGui") or p22:IsA("SurfaceGui") then
        return "gui"
    end

    return if bakedId(p22) then "baked" else nil
end

local t13 = {}

t13.__index = t13

function t13.new(p23, p24, p25, p26, p27) -- line: 421
    -- upvalues: RunService (copy), Codec (copy), t7 (copy), v5 (copy), newPollQueue (copy), t13 (copy)
    local v14 = p23:FilterRoot(workspace)
    local v15 = setmetatable({
        Registry = p23,
        Stream = p23.Stream,
        Clock = p23.Clock,
        TrackGui = p24,
        WatchAnimator = p25,
        MaxInstances = p26,
        BakeModels = p27 == true,
        Filtered = v14 ~= nil,
        Scoped = v14 ~= nil and v14.Include,
        Count = 0,
        Watches = {},
        CharacterScopes = {},
        PinSignals = {},
        Ids = p23.Ids,
        Kinds = setmetatable({}, {
            __mode = "k"
        }),
        Signals = setmetatable({}, {
            __mode = "k"
        }),
        AttachSignals = setmetatable({}, {
            __mode = "k"
        }),
        Kids = setmetatable({}, {
            __mode = "k"
        }),
        Roots = setmetatable({}, {
            __mode = "k"
        }),
        RootOf = setmetatable({}, {
            __mode = "k"
        }),
        JointParts = setmetatable({}, {
            __mode = "k"
        }),
        TerrainDriven = setmetatable({}, {
            __mode = "k"
        }),
        Held = setmetatable({}, {
            __mode = "k"
        }),
        InCharacter = setmetatable({}, {
            __mode = "k"
        }),
        Baked = setmetatable({}, {
            __mode = "k"
        }),
        BakedMemo = {},
        Unbaked = {},
        Particles = {},
        ParticleHosts = {},
        EmissionScale = nil,
        EmissionScaleDirty = false,
        LastCFrame = setmetatable({}, {
            __mode = "k"
        }),
        LastSent = setmetatable({}, {
            __mode = "k"
        }),
        SentCFrames = setmetatable({}, {
            __mode = "k"
        }),
        Motions = setmetatable({}, {
            __mode = "k"
        }),
        Samples = setmetatable({}, {
            __mode = "k"
        }),
        Candidates = setmetatable({}, {
            __mode = "k"
        }),
        Untrusted = setmetatable({}, {
            __mode = "k"
        }),
        Sampled = {},
        WorldPoll = newPollQueue(),
        PlayerPolls = {},
        PolledBy = setmetatable({}, {
            __mode = "k"
        }),
        SeqStates = setmetatable({}, {
            __mode = "k"
        }),
        SeqHolders = setmetatable({}, {
            __mode = "v"
        }),
        Groups = nil,
        GroupOrder = {},
        GroupedProps = {},
        ValueScratch = Codec.newWriter(256),
        Pending = {},
        DirtyStructure = {},
        DirtyName = {},
        DirtyProps = {},
        RootCheck = {},
        AnchorCheck = {},
        CameraSample = nil,
        LastCamera = nil,
        LastFov = 0,
        Follow = nil,
        LastCameraTime = (-1e999),
        Connections = {},
        Destroyed = false
    }, t13)

    v15.ByName = p23.ClassPropsByName

    for _, v16 in p23.ClassProps do
        for _, v17 in v16 do
            if t7[v17.Name] then
                v15.GroupedProps[v17.Id] = true
            end
        end
    end

    p23:AddResolver(function(p28, p29) -- line: 541
        -- upvalues: v15 (copy)
        return v15:_track(p28, p29)
    end)
    RunService:BindToRenderStep("UGReplayCameraSample", v5, function() -- line: 544
        -- upvalues: v15 (copy)
        v15.CameraSample = v15:_sampleCamera()
    end)

    return v15
end

function t13._propId(p30, p31, p32) -- line: 550
    local v18 = p30.ByName[p31]

    return v18 and v18[p32]
end

function t13._kidsOf(p33, p34) -- line: 555
    local v19 = p33.Kids[p34]

    if not v19 then
        v19 = setmetatable({}, {
            __mode = "k"
        })
        p33.Kids[p34] = v19
    end

    return v19
end

function t13._markProp(p35, p36, p37) -- line: 564
    local v20 = p35.DirtyProps[p36]

    if not v20 then
        v20 = {}
        p35.DirtyProps[p36] = v20
    end

    v20[p37] = p35.Clock()
end

function t13._isRecordedRoot(p38, p39, p40) -- line: 574
    if p40 == p39 then
        return true
    end

    if p38.TerrainDriven[p39] == nil or p40 == nil then
        return false
    end

    return (p40:IsA("Terrain"))
end

local function terrainDrivenPart(p41, p42, p43) -- line: 579
    if not p41:IsA("Motor6D") then
        return nil
    end

    if not (p42 and p42:IsA("Terrain")) then
        local Terrain = if p43 then p43:IsA("Terrain") else nil

        return if p43 and Terrain then p42 else nil
    end

    return if p43 and not p43:IsA("Terrain") then p43 else nil
end

function t13._setJointParts(p44, p45, p46, p47) -- line: 592
    -- upvalues: terrainDrivenPart (copy)
    local v21 = p44.JointParts[p45]
    local TerrainDriven = p44.TerrainDriven
    local v22 = v21 and terrainDrivenPart(p45, v21[1], v21[2])

    if v22 then
        local v23 = (TerrainDriven[v22] or 1) - 1

        if not (v23 > 0) then
            v23 = nil
        end

        TerrainDriven[v22] = v23
    end

    local v24 = terrainDrivenPart(p45, p46, p47)

    if v24 then
        TerrainDriven[v24] = (TerrainDriven[v24] or 0) + 1
    end

    p44.JointParts[p45] = { p46, p47 }
end

local function attachmentOf(p48, p49) -- line: 607
    -- upvalues: v4 (ref)
    local v25 = v4(p48, p49)

    return if v25 and v25:IsA("Attachment") then v25 else nil
end

local function attachmentEnd(p50) -- line: 613
    -- upvalues: v4 (ref)
    if p50 then
        local v26 = v4(p50, "Parent")

        if v26 and v26:IsA("BasePart") then
            return v26, v4(p50, "CFrame")
        end
    end

    return nil, CFrame.identity
end

local function readAttachmentJoint(p51, p52) -- line: 622
    -- upvalues: v4 (ref)
    if p52 == "Enabled" then
        return true, v4(p51, "Enabled") and (not p51:IsA("AnimationConstraint") or v4(p51, "IsKinematic"))
    end

    local v27 = if p52 == "Part0" or p52 == "C0" then "Attachment0" else "Attachment1"
    local v28 = v4(p51, v27)

    if not (v28 and v28:IsA("Attachment")) then
        v28 = nil
    end

    local v29 = v28 and v4(v28, "Parent")
    local v30

    if v28 and v29 and v29:IsA("BasePart") then
        v30 = v4(v28, "CFrame")
    else
        v29 = nil
        v30 = CFrame.identity
    end

    if p52 == "Part0" or p52 == "Part1" then
        return true, v29
    end

    return true, v30
end

function t13._jointEnds(p53, p54) -- line: 631
    -- upvalues: v4 (ref)
    if p53.Kinds[p54] ~= "constraint" then
        return v4(p54, "Part0"), v4(p54, "Part1")
    end

    local Attachment0 = v4(p54, "Attachment0")

    if not (Attachment0 and Attachment0:IsA("Attachment")) then
        Attachment0 = nil
    end

    local v31 = Attachment0 and v4(Attachment0, "Parent")

    if Attachment0 and v31 and v31:IsA("BasePart") then
        v4(Attachment0, "CFrame")
    else
        local _ = CFrame.identity

        v31 = nil
    end

    local Attachment1 = v4(p54, "Attachment1")

    if not (Attachment1 and Attachment1:IsA("Attachment")) then
        Attachment1 = nil
    end

    if Attachment1 then
        local v32 = v4(Attachment1, "Parent")

        if v32 and v32:IsA("BasePart") then
            v4(Attachment1, "CFrame")

            return v31, v32
        end
    end

    local _ = CFrame.identity

    return v31, nil
end

function t13._read(p55, p56, p57) -- line: 641
    -- upvalues: AssemblyRootProperty (copy), SurfaceIdProperty (copy), SurfaceIdAttribute (copy), BakedOriginAttribute (copy), BakeIdProperty (copy), PivotProperty (copy), v4 (ref), bakedId (copy), readAttachmentJoint (copy)
    if p57 == AssemblyRootProperty then
        local v33 = v4
        local AssemblyRootPart, AssemblyRootPart2 = pcall(v33, p56, "AssemblyRootPart")

        return true, AssemblyRootPart and p55:_isRecordedRoot(p56, AssemblyRootPart2)
    end

    if p55.Kinds[p56] == "constraint" then
        return readAttachmentJoint(p56, p57)
    end

    if p57 == SurfaceIdProperty then
        local Attribute = p56:GetAttribute(SurfaceIdAttribute)

        return type(Attribute) == "string", Attribute
    end

    if p55.Kinds[p56] == "baked" then
        if p57 == BakeIdProperty then
            local v34 = bakedId(p56)

            return v34 ~= nil, v34
        end

        if p57 == PivotProperty then
            local Model = p56:IsA("Model")

            if not p56:IsA("Model") then
                return Model, nil
            end

            local Attribute = p56:GetAttribute(BakedOriginAttribute)
            local Pivot = p56:GetPivot()

            if typeof(Attribute) == "CFrame" then
                return Model, Pivot * Attribute:Inverse()
            end

            return Model, Pivot
        end
    end

    if p57 ~= "C0" or not p56:IsA("WeldConstraint") then
        if p57 == "LocalTransparencyModifier" and not p55.InCharacter[p56] and p55.Kinds[p56] ~= "particle" then
            return false, nil
        end

        local v35 = v4

        return pcall(v35, p56, p57)
    end

    local Part0, Part1 = p56.Part0, p56.Part1

    if not Part0 or not Part1 then
        return true, CFrame.identity
    end

    return true, Part0.CFrame:ToObjectSpace(Part1.CFrame)
end

function t13._updateInCharacter(p58, p59) -- line: 677
    -- upvalues: v4 (ref), inPlayerCharacter (copy)
    if not (p59:IsA("BasePart") or p59:IsA("Decal")) then
        return
    end

    local v36 = inPlayerCharacter(p59)

    if v36 and not p58.InCharacter[p59] and p58.Ids[p59] then
        local LocalTransparencyModifier = p58:_propId(v4(p59, "ClassName"), "LocalTransparencyModifier")

        if LocalTransparencyModifier then
            p58:_markProp(p59, LocalTransparencyModifier)
        end
    end

    local InCharacter = p58.InCharacter

    if v36 then
        InCharacter[p59] = true
    else
        InCharacter[p59] = nil
    end
end

function t13._parentIdOf(p60, p61, p62, p63) -- line: 691
    -- upvalues: Lighting (copy), RootId (copy)
    if p62 == nil then
        return nil
    end

    if p62 == workspace then
        return RootId.Workspace
    end

    if p62 == Lighting then
        return if p61:IsA("Sky") then RootId.Lighting else nil
    end

    if p62:IsA("Terrain") then
        return RootId.Workspace
    end

    if not p60:_inBaked(p62) then
        return p60.Ids[p62] or p60.Registry:Resolve(p62, p63)
    end

    return if p60:_isUnbaked(p61) then RootId.Workspace else nil
end

function t13._inDomain(_, p65) -- line: 711
    -- upvalues: Lighting (copy), v4 (ref)
    if p65:IsA("Sky") then
        return v4(p65, "Parent") == Lighting
    end

    local v37, v38

    if not p65:IsDescendantOf(workspace) or p65:IsA("Terrain") then
        v38 = true
    else
        v37 = p65:IsA("BillboardGui") or p65:IsA("SurfaceGui")
        v38 = false
    end

    if v38 or v37 then
        return false
    end

    if p65:FindFirstAncestorWhichIsA("LayerCollector") == nil then
        return p65:FindFirstAncestorWhichIsA("ViewportFrame") == nil
    end

    return false
end

function t13._isBakedRoot(p66, p67) -- line: 724
    -- upvalues: bakedId (copy)
    if p66.Baked[p67] then
        return true
    end

    if p66.Ids[p67] == nil then
        return bakedId(p67) ~= nil
    end

    return false
end

function t13._isUnbaked(p68, p69) -- line: 731
    -- upvalues: UnbakedAttribute (copy)
    return p68.Unbaked[p69] ~= nil and p69:GetAttribute(UnbakedAttribute) == true
end

function t13._inBaked(p70, p71) -- line: 738
    -- upvalues: v4 (ref)
    if not p70.BakeModels or p71 == nil or p71 == workspace then
        return false
    end

    local BakedMemo = p70.BakedMemo
    local v39 = BakedMemo[p71]

    if v39 ~= nil then
        return v39
    end

    local v40 = not p70:_isUnbaked(p71) and (p70:_isBakedRoot(p71) or p70:_inBaked(v4(p71, "Parent")))

    BakedMemo[p71] = v40

    return v40
end

function t13._hiddenByBake(p72, p73, p74) -- line: 754
    return p72:_inBaked(p74) and not p72:_isUnbaked(p73)
end

function t13._track(p75, p76, p77) -- line: 760
    -- upvalues: Observability (copy), Codec (copy), Copies (copy), Sequences (copy), ValueType (copy), AssemblyRootProperty (copy), PivotProperty (copy), v4 (ref), t1 (copy), t5 (copy), t6 (copy), inPlayerCharacter (copy), bakedId (copy)
    local v41 = p75.Ids[p76]

    if v41 then
        return v41
    end

    if p75.Count >= p75.MaxInstances or not p75:_inDomain(p76) or Observability.IsAudio(p76) then
        return nil
    end

    local ParticleEmitter = p76:IsA("ParticleEmitter")

    if ParticleEmitter and not p75.Particles[p76] then
        return nil
    end

    local Registry = p75.Registry
    local Parent = v4(p76, "Parent")

    if p75:_hiddenByBake(p76, Parent) then
        return nil
    end

    local v42 = p75:_parentIdOf(p76, Parent, p77)

    if v42 == nil then
        return nil
    end

    if Registry:MatchFilter(p76, Parent) then
        p75:_watchFiltered(p76)

        return nil
    end

    local ClassName = v4(p76, "ClassName")
    local v43 = Registry.ClassProps[ClassName]
    local v44 = if not v43 or not (#v43 > 0) then "primitive"
        elseif p75.BakeModels and bakedId(p76) then "baked"
        elseif p76:IsA("BasePart") then "part"
        elseif p76:IsA("WeldConstraint") then "weld"
        elseif p76:IsA("JointInstance") then "joint"
        elseif t5[ClassName] then "constraint"
        elseif ParticleEmitter then "particle"
        elseif t6[ClassName] or p76:IsA("Attachment") then "visual"
        elseif p76:IsA("Sky") then "sky"
        else "primitive"
    local v45 = v44 == "primitive"
    local v46

    if not v45 then
        Registry:ResolveRefs(p76, ClassName, p77)

        if v44 == "constraint" then
            for _, v47 in { "Attachment0", "Attachment1" } do
                local v48 = v4(p76, v47)

                if not (v48 and v48:IsA("Attachment")) then
                    v48 = nil
                end

                local v49

                if v48 then
                    v49 = v4(v48, "Parent")

                    if v49 and v49:IsA("BasePart") then
                        v4(v48, "CFrame")
                    else
                        local _ = CFrame.identity

                        v49 = nil
                    end
                else
                    local _ = CFrame.identity
                end

                if v49 then
                    Registry:Resolve(v49, p77)
                end
            end
        end

        v46 = p75.Ids[p76]
    end

    if (v45 or v46) and not v45 then
        return p75.Ids[p76]
    end

    if v45 then
        v43 = nil
    end

    local v50 = Registry:Allocate(p76, v42)

    p75.Count += 1
    p75.Kinds[p76] = v44

    if v43 and (p76:IsA("BasePart") or p76:IsA("Decal")) and inPlayerCharacter(p76) then
        p75.InCharacter[p76] = true
    end

    if Parent then
        p75:_kidsOf(Parent)[p76] = true
    end

    local v51 = Registry:AddTime(p77)
    local v52 = if not v43 or v44 == "baked" then nil else Registry:DefaultsFor(ClassName)
    local v53 = v44 == "part" and v4(p76, "Transparency") >= 1
    local t59 = {}
    local t60 = {}

    if v43 then
        local Ids = p75.Ids

        for _, v54 in v43 do
            local Name = v54.Name

            if not v53 or not t1[Name] then
                local v58, v59 = p75:_read(p76, Name)

                if v58 then
                    if Name == AssemblyRootProperty then
                        p75.Roots[p76] = v59
                    elseif Name == "CFrame" and v44 == "part" or Name == PivotProperty and v44 == "baked" then
                        p75.LastCFrame[p76] = v59
                    end

                    local v60 = if v54.Type == ValueType.Ref then Copies.refValue(if typeof(v59) == "Instance" then Ids[v59] else nil, v50) else v59

                    table.insert(t59, {
                        Prop = v54,
                        Value = v59,
                        Stored = v60
                    })
                    t60[v54.Id] = v60
                end
            end
        end
    end

    local W = p75.Stream.W
    local v61, v62 = Registry.Copies:WriteHead(W, v50, v42, v43 and Registry.ClassIndex[ClassName] or Registry.UnknownClassId, v4(p76, "Name"), true, t60)
    local len = W.len

    W:u16(0)

    local v63

    if v43 then
        local t63 = {}

        v63 = 0

        for _, v64 in t59 do
            local Prop, Value = v64.Prop, v64.Value

            if Prop.Name ~= AssemblyRootProperty or Value or v61 then
                if Copies.differs(v61, v62, v52, Prop.Id, Value, v64.Stored) then
                    Codec.varuint(W, Prop.Id)
                    Codec.writeValue(W, Prop.Type, Value)
                    t63[Prop.Id] = v51
                    v63 += 1
                end

                if Sequences.Types[Prop.Type] then
                    local Id, Id2, Type = Prop.Id, Prop.Id, Prop.Type

                    p75:_setSequence(p76, Id, ("%*:%*"):format(Id2, (Sequences.key(Sequences.keypoints(Type, Value)))), v51)
                end
            elseif v62 then
                v62[Prop.Id] = false
            end
        end

        p75.LastSent[p76] = t63

        if v53 then
            p75.Held[p76] = true
        end
    else
        v63 = 0
    end

    W:patchU16(len, v63)
    p75.Stream:EndRecord()
    p75:_connect(p76, v44, ClassName)

    if v44 == "baked" then
        p75.Baked[p76] = true
        p75.BakedMemo[p76] = true
    elseif v44 == "part" then
        local v65 = v4
        local AssemblyRootPart, AssemblyRootPart2 = pcall(v65, p76, "AssemblyRootPart")

        if AssemblyRootPart and AssemblyRootPart2 then
            p75.RootOf[p76] = AssemblyRootPart2
        end

        if p75.Roots[p76] then
            p75:_updatePolling(p76)

            return v50
        end
    elseif v44 == "joint" or v44 == "weld" or v44 == "constraint" then
        local v66, v67 = p75:_jointEnds(p76)

        p75:_setJointParts(p76, v66, v67)
        p75:_checkRoots(v66, v67, v51)
    end

    return v50
end

function t13._connect(p78, p79, p80, p81) -- line: 933
    -- upvalues: v4 (ref), t3 (copy), t4 (copy), t9 (copy)
    local t64 = {}

    p78.Signals[p79] = t64

    local function structure() -- line: 936
        -- upvalues: p78 (copy), p79 (copy)
        p78.DirtyStructure[p79] = p78.Clock()
    end

    local function rename() -- line: 939
        -- upvalues: p78 (copy), p79 (copy)
        p78.DirtyName[p79] = p78.Clock()

        if p78.Registry.FilterAny then
            p78.DirtyStructure[p79] = p78.Clock()
        end
    end

    if p80 == "primitive" or p80 == "baked" then
        table.insert(t64, p79:GetPropertyChangedSignal("Parent"):Connect(structure))
        table.insert(t64, p79:GetPropertyChangedSignal("Name"):Connect(rename))
    elseif p80 == "joint" or p80 == "weld" then
        table.insert(t64, p79:GetPropertyChangedSignal("Parent"):Connect(structure))
        table.insert(t64, p79:GetPropertyChangedSignal("Name"):Connect(rename))

        for _, v68 in t4 do
            local v69 = p78:_propId(p81, v68)

            if v69 then
                if p80 == "weld" then
                    if v68 ~= "C0" and v68 ~= "C1" then
                        table.insert(t64, p79:GetPropertyChangedSignal(v68):Connect(function() -- line: 961
                            -- upvalues: p78 (copy), p79 (copy), v69 (copy)
                            p78:_markProp(p79, v69)
                        end))
                    end
                else
                    table.insert(t64, p79:GetPropertyChangedSignal(v68):Connect(function() -- line: 961
                        -- upvalues: p78 (copy), p79 (copy), v69 (copy)
                        p78:_markProp(p79, v69)
                    end))
                end
            end
        end
    elseif p80 == "constraint" then
        table.insert(t64, p79:GetPropertyChangedSignal("Parent"):Connect(structure))
        table.insert(t64, p79:GetPropertyChangedSignal("Name"):Connect(rename))

        local t65 = {}

        for _, v72 in t4 do
            local v73 = p78:_propId(p81, v72)

            if v73 then
                table.insert(t65, v73)
            end
        end

        local function changed() -- line: 978
            -- upvalues: p78 (copy), p79 (copy), t65 (copy)
            for _, v74 in t65 do
                p78:_markProp(p79, v74)
            end
        end

        local function bindAttachments() -- line: 983
            -- upvalues: p78 (copy), p79 (copy), changed (copy), v4 (ref)
            local v75 = p78.AttachSignals[p79]

            if v75 then
                for _, v76 in v75 do
                    v76:Disconnect()
                end
            end

            local t66 = {}

            for _, v77 in { "Attachment0", "Attachment1" } do
                local v78 = v4(p79, v77)

                if not (v78 and v78:IsA("Attachment")) then
                    v78 = nil
                end

                if v78 then
                    table.insert(t66, v78:GetPropertyChangedSignal("CFrame"):Connect(changed))
                    table.insert(t66, v78:GetPropertyChangedSignal("Parent"):Connect(changed))
                end
            end

            p78.AttachSignals[p79] = t66
        end

        bindAttachments()

        for _, v79 in { "Attachment0", "Attachment1" } do
            table.insert(t64, p79:GetPropertyChangedSignal(v79):Connect(function() -- line: 1004
                -- upvalues: p78 (copy), p79 (copy), t65 (copy), bindAttachments (copy)
                bindAttachments()

                for _, v81 in t65 do
                    p78:_markProp(p79, v81)
                end
            end))
        end

        table.insert(t64, p79:GetPropertyChangedSignal("Enabled"):Connect(changed))

        if p79:IsA("AnimationConstraint") then
            table.insert(t64, p79:GetPropertyChangedSignal("IsKinematic"):Connect(changed))
        end
    else
        local v82 = p78.ByName[p81] or {}
        local CFrame = v82.CFrame

        if p79:IsA("Bone") then
            table.insert(t64, p79:GetPropertyChangedSignal("Parent"):Connect(structure))
            table.insert(t64, p79:GetPropertyChangedSignal("Name"):Connect(rename))

            if CFrame then
                table.insert(t64, p79:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 1025
                    -- upvalues: p78 (copy), p79 (copy), CFrame (copy)
                    p78:_markProp(p79, CFrame)
                end))
            end
        else
            table.insert(t64, p79.Changed:Connect(function(p82) -- line: 1034
                -- upvalues: p78 (copy), p79 (copy), p80 (copy), v82 (copy), CFrame (copy), t3 (copy), t9 (copy)
                if p82 == "Parent" then
                    p78.DirtyStructure[p79] = p78.Clock()
                elseif p82 == "Name" then
                    p78.DirtyName[p79] = p78.Clock()

                    if p78.Registry.FilterAny then
                        p78.DirtyStructure[p79] = p78.Clock()
                    end
                elseif p80 ~= "part" or not t3[p82] then
                    if p80 == "part" and p82 == "Anchored" then
                        p78.AnchorCheck[p79] = true
                    elseif CFrame and t9[p82] and p79:IsA("Attachment") then
                        p78:_markProp(p79, CFrame)
                    else
                        local v85 = v82[p82]

                        if v85 then
                            p78:_markProp(p79, v85)
                        end
                    end
                elseif CFrame and p78.Roots[p79] then
                    p78:_markProp(p79, CFrame)
                end
            end))
        end
    end
end

local function setPolled(p83, p84, p85) -- line: 1057
    if not p85 or p83.Set[p84] then
        if not p85 then
            p83.Set[p84] = nil
        end
    else
        p83.Set[p84] = true
        table.insert(p83.List, p84)
    end
end

function t13._updatePolling(p86, p87) -- line: 1068
    -- upvalues: v4 (ref)
    local v86 = p86.Roots[p87] == true and p86.Ids[p87] ~= nil and (p86.TerrainDriven[p87] ~= nil or not v4(p87, "Anchored"))
    local v87 = if v86 then p86:_characterPlayer(p87) else nil

    p86:_setPlayerPolled(p87, v87)

    local WorldPoll = p86.WorldPoll
    local v88 = v86 and v87 == nil

    if not v88 or WorldPoll.Set[p87] then
        if not v88 then
            WorldPoll.Set[p87] = nil
        end
    else
        WorldPoll.Set[p87] = true
        table.insert(WorldPoll.List, p87)
    end
end

function t13._setPlayerPolled(p88, p89, p90) -- line: 1078
    -- upvalues: newPollQueue (copy)
    local v89 = p88.PolledBy[p89]

    if v89 == p90 then
        return
    end

    if v89 then
        local v90 = p88.PlayerPolls[v89]

        if v90 then
            v90.Queue.Set[p89] = nil
        end
    end

    p88.PolledBy[p89] = p90

    if not p90 then
        return
    end

    local v91 = p88.PlayerPolls[p90]

    if not v91 then
        v91 = {
            Queue = newPollQueue(),
            Next = os.clock()
        }
        p88.PlayerPolls[p90] = v91
    end

    local Queue = v91.Queue

    if not Queue.Set[p89] then
        Queue.Set[p89] = true
        table.insert(Queue.List, p89)
    end
end

function t13._checkRoots(p91, p92, p93, p94) -- line: 1102
    local RootCheck = p91.RootCheck

    for _, v92 in { p92, p93 } do
        if v92 and v92:IsA("BasePart") then
            RootCheck[v92] = p94

            local v93 = p91.RootOf[v92]

            if v93 then
                RootCheck[v93] = p94
            end
        end
    end
end

function t13._writeProp(p95, p96, p97, p98, p99, p100, p101) -- line: 1118
    -- upvalues: Codec (copy), Op (copy), ValueType (copy), t2 (copy)
    local v94 = p95.LastSent[p96]

    if not v94 then
        v94 = {}
        p95.LastSent[p96] = v94
    end

    local v95 = p95.Registry.PropTypes[p98]
    local v96 = v94[p98]
    local v97 = v95 == ValueType.CFrame and typeof(p99) == "CFrame"
    local v98, v99

    if v97 then
        v99 = if v96 and p100 < v96 then v96 else p100

        if p95.Kinds[p96] ~= "part" or p95:_isCharacterPart(p96) then
            v98 = false
        else
            local v100

            v100, v98 = p95:_writeMotion(p96, p97, p98, p99, v99)

            if v100 then
                return
            end
        end
    else
        v99 = p100
        v98 = false
    end

    local Prop = Op.Prop
    local v101, v102, v103, v104, v105, v106, v107, v108, v109, v110, v111, v112

    if v97 then
        local v113, v114, v115, v116 = Codec.quantizeRotation(p99)
        local Position = p99.Position
        local v117 = p95.SentCFrames[p96]

        if not v117 then
            v117 = {}
            p95.SentCFrames[p96] = v117
        end

        local v118 = v117[p98]
        local Position2, v119, v120, v121, v122, v123, v124, v125, v126, v127, v128, v129, v130, v131

        if v118 then
            Position2 = v118.Position
            v119 = Codec.positionSteps(Position2.X, Position.X)
            v120 = Codec.positionSteps(Position2.Y, Position.Y)
            v121 = Codec.positionSteps(Position2.Z, Position.Z)

            local MaxPositionSteps = Codec.MaxPositionSteps

            if math.abs(v119) <= MaxPositionSteps and math.abs(v120) <= MaxPositionSteps and math.abs(v121) <= MaxPositionSteps then
                v122 = v118.K == v113 and v118.A == v114 and v118.B == v115 and v118.C == v116

                if v119 == 0 and v120 == 0 and v121 == 0 and v122 and not v98 then
                    if p101 then
                        v94[p98] = v99
                    end

                    return
                end

                v124 = Op.CFrameDelta
                v128 = v118.K
                v129 = v118.A
                v130 = v118.B
                v131 = v118.C
                v125 = v119
                v126 = v120
                v127 = v121
                v123 = Vector3.new(Codec.stepPosition(Position2.X, v119), Codec.stepPosition(Position2.Y, v120), Codec.stepPosition(Position2.Z, v121))
            else
                v123 = Position
                v124 = Prop
                v125 = v119
                v126 = v120
                v127 = v121
                v128 = 0
                v129 = 0
                v130 = 0
                v131 = 0
            end
        else
            v123 = Position
            v124 = Prop
            v125 = 0
            v126 = 0
            v127 = 0
            v128 = 0
            v129 = 0
            v130 = 0
            v131 = 0
        end

        v112 = v131

        if v118 then
            v118.Position = v123
            v118.K = v113
            v118.A = v114
            v118.B = v115
            v118.C = v116
        else
            v117[p98] = {
                Position = v123,
                K = v113,
                A = v114,
                B = v115,
                C = v116
            }
        end

        v101 = v124
        v102 = v113
        v103 = v114
        v104 = v115
        v105 = v116
        v106 = v125
        v107 = v126
        v108 = v127
        v109 = v128
        v110 = v129
        v111 = v130
    else
        v101 = Prop
        v102 = 0
        v103 = 0
        v104 = 0
        v105 = 0
        v106 = 0
        v107 = 0
        v108 = 0
        v109 = 0
        v110 = 0
        v111 = 0
        v112 = 0
    end

    local v134 = if t2[v95] and (p101 or v95 ~= ValueType.CFrame) and v96 and v99 - v96 <= 300 and v96 < v99 then v99 - v96 else nil

    v94[p98] = v99

    if v95 == ValueType.Ref and typeof(p99) == "Instance" then
        p95.Registry:Resolve(p99, v99)
    end

    local v135 = if v134 then math.clamp(math.round(v134 / 10), 1, 255) else 0

    if not v97 then
        p95:_writeValue(p96, p97, p98, v95, p99, v99, v135)

        return
    end

    local Stream = p95.Stream

    Stream:Time(v99)

    local W = Stream.W

    if v101 == Op.CFrameDelta then
        W:u8(v101)
        Codec.varuint(W, p97)
        Codec.varuint(W, p98)
        W:u8(v135)
        Codec.cframeDelta(W, v106, v107, v108, v109, v110, v111, v112, v102, v103, v104, v105)
    else
        if v134 then
            W:u8(Op.PropLerp)
            Codec.varuint(W, p97)
            Codec.varuint(W, p98)
            W:u8(v135)
        else
            W:u8(Op.Prop)
            Codec.varuint(W, p97)
            Codec.varuint(W, p98)
        end

        Codec.position(W, p99)
        Codec.rotation(W, v102, v103, v104, v105)
    end

    Stream:EndRecord()
end

function t13._setSequence(p102, p103, p104, p105, p106) -- line: 1229
    local v138 = p102.SeqStates[p103]

    if not v138 then
        v138 = {}
        p102.SeqStates[p103] = v138
    end

    local v139 = v138[p104]

    if v139 and p102.SeqHolders[v139.Key] == p103 then
        p102.SeqHolders[v139.Key] = nil
    end

    v138[p104] = {
        Key = p105,
        Time = p106
    }
    p102.SeqHolders[p105] = p103
end

function t13._writeValue(p107, p108, p109, p110, p111, p112, p113, p114) -- line: 1245
    -- upvalues: Codec (copy)
    local ValueScratch = p107.ValueScratch

    ValueScratch.len = 0
    Codec.writeValue(ValueScratch, p111, p112)

    local v140 = buffer.readstring(ValueScratch.buf, 0, ValueScratch.len)
    local Groups = p107.Groups

    if not (Groups and p107.GroupedProps[p110]) then
        p107:_writeSingle(p108, p109, p110, p111, p112, p113, p114, v140)
    else
        local v141 = ("%*:%*:%*:%*"):format(p110, p114, math.floor(p113), v140)
        local v142 = Groups[v141]

        if v142 then
            table.insert(v142.Members, {
                Inst = p108,
                Id = p109
            })
        else
            local t68 = {
                PropId = p110,
                Type = p111,
                Value = p112,
                T = p113,
                LerpUnits = p114,
                Encoded = v140,
                Members = {
                    {
                        Inst = p108,
                        Id = p109
                    }
                }
            }

            Groups[v141] = t68
            table.insert(p107.GroupOrder, t68)
        end
    end
end

function t13._writeSingle(p115, p116, p117, p118, p119, p120, p121, p122, p123) -- line: 1285
    -- upvalues: Codec (copy), Sequences (copy), Op (copy)
    local Stream = p115.Stream

    Stream:Time(p121)

    local W = Stream.W
    local v143 = if Sequences.Types[p119] then ("%*:%*"):format(p118, (Sequences.key(Sequences.keypoints(p119, p120)))) else nil

    if v143 then
        local v144 = p115.SeqHolders[v143]
        local v145 = v144 and v144 ~= p116 and p115.Ids[v144]
        local v146 = v145 and p115.SeqStates[v144]
        local v147 = v146 and v146[p118]

        if v145 and v147 and v147.Time <= p121 then
            Sequences.writeCopy(W, p117, p118, p122, v145)
            Stream:EndRecord()
            p115:_setSequence(p116, p118, v143, p121)

            return
        end
    end

    if p122 > 0 then
        W:u8(Op.PropLerp)
        Codec.varuint(W, p117)
        Codec.varuint(W, p118)
        W:u8(p122)
    else
        W:u8(Op.Prop)
        Codec.varuint(W, p117)
        Codec.varuint(W, p118)
    end

    local v148 = #p123

    W:_ensure(v148)
    buffer.writestring(W.buf, W.len, p123)
    W.len += v148
    Stream:EndRecord()

    if v143 then
        p115:_setSequence(p116, p118, v143, p121)
    end
end

function t13._flushGroups(p124) -- line: 1330
    -- upvalues: Codec (copy), Sequences (copy), Op (copy)
    p124.Groups = nil

    local GroupOrder = p124.GroupOrder

    p124.GroupOrder = {}

    local Stream = p124.Stream

    for _, v149 in GroupOrder do
        local Members, PropId, Type, T = v149.Members, v149.PropId, v149.Type, v149.T

        if #Members == 1 then
            local v150 = Members[1]

            p124:_writeSingle(v150.Inst, v150.Id, PropId, Type, v149.Value, T, v149.LerpUnits, v149.Encoded)
        else
            table.sort(Members, function(p125, p126) -- line: 1343
                return p125.Id < p126.Id
            end)
            Stream:Time(T)

            local W = Stream.W

            W:u8(Op.PropMany)
            Codec.varuint(W, PropId)
            W:u8(v149.LerpUnits)
            Codec.varuint(W, #Members)

            local n1 = 0

            for _, v151 in Members do
                Codec.varuint(W, v151.Id - n1)
                n1 = v151.Id
            end

            local Encoded = v149.Encoded
            local v152 = #Encoded

            W:_ensure(v152)
            buffer.writestring(W.buf, W.len, Encoded)
            W.len += v152
            Stream:EndRecord()

            if Sequences.Types[Type] then
                local Value = v149.Value
                local v153 = ("%*:%*"):format(PropId, (Sequences.key(Sequences.keypoints(Type, Value))))

                for _, v154 in Members do
                    p124:_setSequence(v154.Inst, PropId, v153, T)
                end
            end
        end
    end
end

function t13._writeMotion(p127, p128, p129, p130, p131, p132) -- line: 1372
    -- upvalues: Codec (copy), Motion (copy)
    p127.Sampled[p128] = true

    local v155 = p127.Samples[p128]
    local v156, v157, v158, v159

    if v155 then
        v157 = v155.T
        v156 = v155.CFrame
        v159 = v155.BeforeT
        v158 = v155.Before

        local T, CFrame = v155.T, v155.CFrame

        v155.BeforeT = T
        v155.Before = CFrame
        v155.T = p132
        v155.CFrame = p131
    else
        v157 = v155
        v156 = v155
        v159 = v155
        v158 = v155
        p127.Samples[p128] = {
            T = p132,
            CFrame = p131
        }
    end

    local v160 = p127.Motions[p128]
    local v161 = false

    if v160 then
        if not (p132 < v160.T) then
            local v162 = Motion.at(v160.Base, v160.W, v160.V, v160.A, (p132 - v160.T) / 1000)

            if not Motion.apart(v162, p131, 0.2, 0.02) then
                v160.Hits += 1

                return true, false
            end
        end

        p127.Motions[p128] = nil

        if v160.Hits == 0 then
            p127.Untrusted[p128] = true
        end

        v161 = true
    end

    local v163, v164

    if v156 and v157 and not (p132 <= v157) and not (p132 - v157 > 250) then
        v163, v164 = Motion.between(v156, p131, (p132 - v157) / 1000)

        if v163.Magnitude < 0.002 then
            v163 = Vector3.new(0, 0, 0)
        end

        if not (v164.Magnitude < 0.02) or v163 ~= Vector3.new(0, 0, 0) then
            local v166
            local v165 = v164

            if v163 == Vector3.new(0, 0, 0) and v158 and v159 and v159 < v157 and v157 - v159 <= 250 then
                v165, v166 = Motion.accelerating(v158.Position, v156.Position, p131.Position, v159 / 1000, v157 / 1000, p132 / 1000)

                if not (v166.Magnitude >= 0.05) then
                    v165 = v164
                    v166 = Vector3.new(0, 0, 0)
                end
            else
                v166 = Vector3.new(0, 0, 0)
            end

            local t69 = {
                Hits = 0,
                PropId = p130,
                T = p132,
                Base = p131,
                W = v163,
                V = v165,
                A = v166
            }

            if p127.Untrusted[p128] then
                local v167 = p127.Candidates[p128]

                p127.Candidates[p128] = t69

                local v168 = false

                if v167 then
                    local v169

                    if p132 < v167.T then
                        v169 = false
                    else
                        local v170 = Motion.at(v167.Base, v167.W, v167.V, v167.A, (p132 - v167.T) / 1000)

                        v169 = not Motion.apart(v170, p131, 0.2, 0.02)
                    end

                    v168 = not not v169
                end

                if not v168 then
                    return false, v161
                end

                p127.Untrusted[p128] = nil
                p127.Candidates[p128] = nil
            end

            p127.Motions[p128] = t69

            local v171, v172, v173, v174 = Codec.quantizeRotation(p131)
            local v175 = p127.SentCFrames[p128]

            if not v175 then
                v175 = {}
                p127.SentCFrames[p128] = v175
            end

            local v176 = v175[p130]
            local v177 = v176 ~= nil and v176.K == v171 and v176.A == v172 and v176.B == v173 and v176.C == v174

            v175[p130] = {
                Position = p131.Position,
                K = v171,
                A = v172,
                B = v173,
                C = v174
            }

            local Stream = p127.Stream

            Stream:Time(p132)
            Motion.write(Stream.W, p129, p130, p131, v163, v165, v166, v177)
            Stream:EndRecord()

            local v178 = p127.LastSent[p128]

            if v178 then
                v178[p130] = p132
            end

            return true, v161
        end

        p127.Candidates[p128] = nil

        return false, v161
    end

    p127.Candidates[p128] = nil

    return false, v161
end

function t13._checkMotions(p133) -- line: 1469
    -- upvalues: v4 (ref)
    local v179 = p133.Clock()
    local t70 = {}

    for v180 in p133.Motions do
        if not p133.Sampled[v180] then
            table.insert(t70, v180)
        end
    end

    for _, v181 in t70 do
        local v182 = p133.Motions[v181]
        local v183 = p133.Ids[v181]

        if v183 then
            local CFrame = v4(v181, "CFrame")

            p133.LastCFrame[v181] = CFrame
            p133:_writeProp(v181, v183, v182.PropId, CFrame, v179)
        else
            p133.Motions[v181] = nil
        end
    end

    table.clear(p133.Sampled)
end

function t13._isCharacterPart(p134, p135) -- line: 1493
    return p134:_characterPlayer(p135) ~= nil
end

function t13._characterPlayer(_, p137) -- line: 1498
    -- upvalues: Players (copy), v4 (ref)
    local Parent = v4(p137, "Parent")

    return if Parent then Players:GetPlayerFromCharacter(Parent) else nil
end

function t13._untrack(p138, p139) -- line: 1503
    local v184 = p138.Kinds[p139]

    if v184 == "joint" or v184 == "weld" or v184 == "constraint" then
        local v185 = p138.JointParts[p139]

        if v185 then
            p138:_checkRoots(v185[1], v185[2], p138.Clock())
        end

        p138:_setJointParts(p139, nil, nil)
    end

    if p138.Ids[p139] then
        p138.Count -= 1
    end

    p138.Registry:Free(p139)
    p138.Registry:NotifyUntracked(p139)
    p138.Kinds[p139] = nil
    p138.Roots[p139] = nil
    p138.RootOf[p139] = nil
    p138.JointParts[p139] = nil
    p138.Held[p139] = nil
    p138.InCharacter[p139] = nil
    p138.Baked[p139] = nil
    p138.BakedMemo[p139] = nil
    p138.LastCFrame[p139] = nil
    p138.LastSent[p139] = nil
    p138.SeqStates[p139] = nil
    p138.SentCFrames[p139] = nil
    p138.Motions[p139] = nil
    p138.Samples[p139] = nil
    p138.Candidates[p139] = nil
    p138.Untrusted[p139] = nil
    p138.WorldPoll.Set[p139] = nil
    p138:_setPlayerPolled(p139, nil)
    p138.DirtyProps[p139] = nil
    p138.DirtyName[p139] = nil

    for _, v186 in {
            p138.Signals,
            p138.AttachSignals
        } do
        local v187 = v186[p139]

        if v187 then
            for _, v188 in v187 do
                v188:Disconnect()
            end

            v186[p139] = nil
        end
    end
end

function t13._untrackTree(p140, p141, p142) -- line: 1550
    if p142 then
        local v189 = p140.Kids[p142]

        if v189 then
            v189[p141] = nil
        end
    end

    local t71 = {
        p141
    }

    while #t71 > 0 do
        local v190 = table.remove(t71)
        local v191 = p140.Kids[v190]

        if v191 then
            for v192 in v191 do
                table.insert(t71, v192)
            end

            p140.Kids[v190] = nil
        end

        p140:_untrack(v190)
    end
end

function t13._watchFiltered(p143, p144) -- line: 1573
    -- upvalues: seedKind (copy)
    p143.Registry:WatchFiltered(p144, function() -- line: 1574
        -- upvalues: p143 (copy), p144 (copy), seedKind (copy)
        if p143.Destroyed then
            return
        end

        local v193 = p143.Clock()

        p143.DirtyStructure[p144] = v193

        for _, descendant in p144:GetDescendants() do
            if seedKind(descendant) then
                p143.DirtyStructure[descendant] = v193
            end
        end
    end)
end

function t13._discover(p145, p146, p147) -- line: 1588
    -- upvalues: v4 (ref), seedKind (copy)
    local v194 = seedKind(p146)

    if v194 == "gui" then
        if not p145:_inBaked(v4(p146, "Parent")) then
            p145.TrackGui(p146)
        end
    else
        if v194 == "baked" and not p145.BakeModels then
            return
        end

        local v195 = if not v194 then p145.Particles[p146] else nil

        if v194 or v195 then
            p145:_track(p146, p147)
        end
    end
end

function t13._mark(p148, p149) -- line: 1602
    -- upvalues: v4 (ref), seedKind (copy)
    local Animator = p149:IsA("Animator")

    if (Animator or seedKind(p149)) and not p148:_hiddenByBake(p149, v4(p149, "Parent")) then
        if Animator then
            p148.WatchAnimator(p149)
        else
            p148.DirtyStructure[p149] = p148.Clock()
        end
    end
end

function t13._walk(p150, p151) -- line: 1616
    -- upvalues: v4 (ref)
    local Registry, Pending = p150.Registry, p150.Pending

    while true do
        if not (#Pending > 0) then
            return true
        end

        if p151 <= os.clock() then
            break
        end

        local v196 = table.remove(Pending)
        local Parent = v4(v196, "Parent")

        if Parent ~= nil then
            if Registry:MatchFilter(v196, Parent) then
                p150:_watchFiltered(v196)
            else
                p150:_discover(v196, p150.Clock())

                if v196:IsA("Animator") then
                    p150.WatchAnimator(v196)
                end

                if not (v196:IsA("BillboardGui") or v196:IsA("SurfaceGui")) and not p150:_inBaked(v196) then
                    for _, child in v196:GetChildren() do
                        table.insert(Pending, child)
                    end
                end
            end
        end
    end

    return false
end

function t13._scope(p152, p153) -- line: 1650
    -- upvalues: newWatch (copy)
    local v197 = newWatch()

    if p152.Scoped then
        table.insert(v197.Connections, p153.DescendantAdded:Connect(function(p154) -- line: 1655
            -- upvalues: p152 (copy)
            p152:_mark(p154)
        end))
    end

    table.insert(p152.Pending, p153)

    return v197
end

local function closeWatch(p155, p156, p157) -- line: 1664
    -- upvalues: closeWatch (copy)
    local v199 = p156[p157]

    if not v199 then
        return
    end

    p156[p157] = nil

    for _, v200 in v199.Connections do
        v200:Disconnect()
    end

    for _, v201 in v199.Names do
        v201:Disconnect()
    end

    for v202 in v199.Kids do
        closeWatch(p155, p155.Watches, v202)
    end
end

function t13._watchPath(p158, p159, p160) -- line: 1685
    -- upvalues: v4 (ref), newWatch (copy), closeWatch (copy)
    if next(p160.Children) == nil then
        return
    end

    local v203 = newWatch()

    p158.Watches[p159] = v203

    local function check(p161) -- line: 1691
        -- upvalues: p158 (copy), p160 (copy), v203 (copy), v4 (ref), closeWatch (copy)
        if v203.Kids[p161] then
            v203.Kids[p161] = nil
            closeWatch(p158, p158.Watches, p161)
        end

        local v204 = p160.Children[v4(p161, "Name")]

        if v204 == nil or p158.Destroyed then
            return
        end

        v203.Kids[p161] = true

        if v204.Marked then
            p158.Watches[p161] = p158:_scope(p161)
        else
            p158:_watchPath(p161, v204)
        end
    end

    local function added(p162) -- line: 1707
        -- upvalues: v203 (copy), check (copy)
        if v203.Names[p162] then
            return
        end

        v203.Names[p162] = p162:GetPropertyChangedSignal("Name"):Connect(function() -- line: 1711
            -- upvalues: p162 (copy), check (copy)
            check(p162)
        end)
        check(p162)
    end

    table.insert(v203.Connections, p159.ChildAdded:Connect(added))
    table.insert(v203.Connections, p159.ChildRemoved:Connect(function(p163) -- line: 1719
        -- upvalues: p158 (copy), v203 (copy), closeWatch (copy)
        local v206 = v203.Names[p163]

        if v206 then
            v206:Disconnect()
            v203.Names[p163] = nil
        end

        if v203.Kids[p163] then
            v203.Kids[p163] = nil
            closeWatch(p158, p158.Watches, p163)
        end
    end))

    for _, child in p159:GetChildren() do
        added(child)
    end
end

function t13._markAll(p164, p165) -- line: 1736
    local v207 = p164.Clock()

    for _, v208 in p165 do
        p164.DirtyStructure[v208] = v207
    end
end

function t13._pin(p166, p167) -- line: 1744
    if not p166.PinSignals[p167] then
        p166.PinSignals[p167] = p167.AncestryChanged:Connect(function() -- line: 1746
            -- upvalues: p166 (copy), p167 (copy)
            if p166.Registry.Pins[p167] then
                p166:_markAll(p166.Registry:Pin(p167))
            end
        end)
    end

    p166:_markAll(p166.Registry:Pin(p167))
end

function t13._unpin(p168, p169) -- line: 1755
    local v209 = p168.PinSignals[p169]

    if v209 then
        v209:Disconnect()
        p168.PinSignals[p169] = nil
    end

    p168:_markAll(p168.Registry:Unpin(p169))
end

function t13._characterAdded(p170, p171) -- line: 1764
    if not p170.Destroyed then
        p170:TrackCharacter(p171)

        if p170.Filtered and not p170.CharacterScopes[p171] then
            p170:_pin(p171)
            p170.CharacterScopes[p171] = p170:_scope(p171)
        end
    end
end

function t13._characterRemoving(p172, p173) -- line: 1776
    -- upvalues: closeWatch (copy)
    if p172.CharacterScopes[p173] then
        closeWatch(p172, p172.CharacterScopes, p173)
        p172:_unpin(p173)
    end
end

function t13._watchPlayers(p174) -- line: 1783
    -- upvalues: Players (copy)
    local function watch(p175) -- line: 1784
        -- upvalues: p174 (copy)
        table.insert(p174.Connections, p175.CharacterAdded:Connect(function(p176) -- line: 1787
            -- upvalues: p174 (copy)
            p174:_characterAdded(p176)
        end))
        table.insert(p174.Connections, p175.CharacterRemoving:Connect(function(p177) -- line: 1793
            -- upvalues: p174 (copy)
            p174:_characterRemoving(p177)
        end))

        if p175.Character then
            p174:_characterAdded(p175.Character)
        end
    end

    table.insert(p174.Connections, Players.PlayerAdded:Connect(watch))
    table.insert(p174.Connections, Players.PlayerRemoving:Connect(function(p178) -- line: 1804
        -- upvalues: p174 (copy)
        p174.PlayerPolls[p178] = nil
    end))

    for _, player in Players:GetPlayers() do
        watch(player)
    end
end

function t13._watchBaked(p179) -- line: 1815
    -- upvalues: CollectionService (copy), BakedTag (copy), bakedId (copy)
    table.insert(p179.Connections, CollectionService:GetInstanceAddedSignal(BakedTag):Connect(function(p180) -- line: 1818
        -- upvalues: p179 (copy), bakedId (copy)
        if bakedId(p180) then
            p179:_pin(p180)
        end
    end))
    table.insert(p179.Connections, CollectionService:GetInstanceRemovedSignal(BakedTag):Connect(function(p181) -- line: 1826
        -- upvalues: p179 (copy)
        if p179.PinSignals[p181] then
            p179:_unpin(p181)
        end
    end))

    for _, v215 in CollectionService:GetTagged(BakedTag) do
        if bakedId(v215) then
            p179:_pin(v215)
            table.insert(p179.Pending, v215)
        end
    end
end

function t13._watchUnbaked(p182) -- line: 1842
    -- upvalues: CollectionService (copy), UnbakedTag (copy), closeWatch (copy)
    local function added(p183) -- line: 1843
        -- upvalues: p182 (copy)
        if not p182.Unbaked[p183] and not p182.Destroyed then
            local v216 = p182:_scope(p183)

            p182.Unbaked[p183] = v216
            table.insert(v216.Connections, p183.AncestryChanged:Connect(function() -- line: 1851
                -- upvalues: p183 (copy), p182 (copy)
                table.insert(p182.Pending, p183)
            end))
            table.clear(p182.BakedMemo)

            if p182.Filtered then
                p182:_pin(p183)
            end
        end
    end

    table.insert(p182.Connections, CollectionService:GetInstanceAddedSignal(UnbakedTag):Connect(added))
    table.insert(p182.Connections, CollectionService:GetInstanceRemovedSignal(UnbakedTag):Connect(function(p184) -- line: 1863
        -- upvalues: p182 (copy), closeWatch (copy)
        if p182.Unbaked[p184] then
            closeWatch(p182, p182.Unbaked, p184)
            table.clear(p182.BakedMemo)

            if p182.PinSignals[p184] then
                p182:_unpin(p184)
            end

            p182.DirtyStructure[p184] = p182.Clock()
        end
    end))

    for _, v219 in CollectionService:GetTagged(UnbakedTag) do
        added(v219)
    end
end

function t13._holdParticleHost(p185, p186) -- line: 1882
    local v220 = p185.ParticleHosts[p186]

    if v220 then
        v220.Count += 1
    else
        local t72 = {
            Watch = nil,
            Count = 1
        }

        p185.ParticleHosts[p186] = t72

        if p185.Filtered then
            p185:_pin(p186)
            t72.Watch = p185:_scope(p186)
        end
    end
end

function t13._releaseParticleHost(p187, p188) -- line: 1896
    local v221 = p187.ParticleHosts[p188]

    if v221 then
        v221.Count -= 1

        if not (v221.Count > 0) then
            p187.ParticleHosts[p188] = nil

            if v221.Watch then
                for _, v222 in v221.Watch.Connections do
                    v222:Disconnect()
                end
            end

            if p187.PinSignals[p188] and not p187.CharacterScopes[p188] and not p187.Baked[p188] and not p187.Unbaked[p188] then
                p187:_unpin(p188)
            end
        end
    end
end

function t13.AddParticle(p189, p190) -- line: 1920
    -- upvalues: particleHost (copy)
    if p189.Destroyed or p189:_inBaked(p190) then
        return
    end

    local v223 = particleHost(p190) or p190
    local v224 = p189.Particles[p190]

    if v224 == v223 then
        return
    end

    p189.Particles[p190] = v223
    p189:_holdParticleHost(v223)

    if v224 then
        p189:_releaseParticleHost(v224)
    end

    p189.DirtyStructure[p190] = p189.Clock()
end

function t13.SetEmissionScale(p191, p192) -- line: 1939
    if p192 ~= p191.EmissionScale then
        p191.EmissionScale = p192
        p191.EmissionScaleDirty = true
    end
end

function t13._flushEmissionScale(p193) -- line: 1946
    -- upvalues: Codec (copy), Op (copy), RootId (copy), EmissionScaleProperty (copy)
    local EmissionScale = p193.EmissionScale
    local v225 = p193:_propId("Workspace", EmissionScaleProperty)

    if not (p193.EmissionScaleDirty and EmissionScale and v225) then
        return
    end

    p193.EmissionScaleDirty = false

    local Stream = p193.Stream

    Stream:Time(p193.Clock())

    local W = Stream.W

    W:u8(Op.Prop)
    Codec.varuint(W, RootId.Workspace)
    Codec.varuint(W, v225)
    W:f32(EmissionScale)
    Stream:EndRecord()
end

function t13.RemoveParticle(p194, p195) -- line: 1964
    local v226 = p194.Particles[p195]

    if not v226 then
        return
    end

    p194.Particles[p195] = nil
    p194:_releaseParticleHost(v226)
    p194.DirtyStructure[p195] = p194.Clock()
end

function t13.WriteEmit(p196, p197, p198, p199) -- line: 1976
    -- upvalues: Codec (copy), Op (copy)
    if p196.Destroyed or not p196:_inDomain(p197) then
        return false
    end

    local Registry = p196.Registry
    local NextId = Registry.NextId
    local t73 = {}
    local v227

    if p196:_inBaked(p197) then
        local v228 = p197

        while v228 and v228 ~= workspace do
            if p196:_isBakedRoot(v228) then
                break
            end

            table.insert(t73, 1, v228.Name)
            v228 = v228.Parent
        end

        if v228 == nil or v228 == workspace then
            return false
        end

        v227 = p196.Ids[v228] or p196:_track(v228, p199)
    else
        p196:AddParticle(p197)
        v227 = p196.Ids[p197] or p196:_track(p197, p199)
    end

    if not v227 then
        return false
    end

    local v229 = if NextId <= v227 then math.max(p199, Registry.AddFloor) else p199
    local Stream = p196.Stream

    Stream:Time(v229)

    local W = Stream.W

    W:u8(Op.Emit)
    Codec.varuint(W, v227)
    Codec.varuint(W, p198)
    Codec.varuint(W, #t73)

    for _, v230 in t73 do
        Codec.str(W, v230)
    end

    Stream:EndRecord()

    return true
end

function t13.Snapshot(p200) -- line: 2023
    -- upvalues: Lighting (copy)
    if p200.Scoped then
        local v231 = p200.Registry:FilterRoot(workspace)

        if v231 then
            p200:_watchPath(workspace, v231)
        end
    else
        table.insert(p200.Connections, workspace.DescendantAdded:Connect(function(p201) -- line: 2032
            -- upvalues: p200 (copy)
            p200:_mark(p201)
        end))

        for _, child in workspace:GetChildren() do
            table.insert(p200.Pending, child)
        end
    end

    p200:_watchPlayers()

    if p200.BakeModels then
        p200:_watchUnbaked()
    end

    if p200.Filtered and p200.BakeModels then
        p200:_watchBaked()
    end

    local function markSky(p202) -- line: 2048
        -- upvalues: p200 (copy)
        if p202:IsA("Sky") then
            p200.DirtyStructure[p202] = p200.Clock()
        end
    end

    table.insert(p200.Connections, Lighting.ChildAdded:Connect(markSky))
    table.insert(p200.Connections, Lighting.ChildRemoved:Connect(markSky))

    local v233 = p200.Clock()

    for _, child in Lighting:GetChildren() do
        if child:IsA("Sky") then
            p200:_track(child, v233)
        end
    end

    repeat
        if p200:_walk(os.clock() + 0.002) then
            return
        end

        task.wait()
    until p200.Destroyed
end

function t13._flushStructure(p203) -- line: 2071
    -- upvalues: Codec (copy), Op (copy), v4 (ref)
    local Stream, Ids, DirtyStructure = p203.Stream, p203.Ids, p203.DirtyStructure

    p203.DirtyStructure = {}

    local Registry = p203.Registry
    local t74 = {}
    local t75 = {}
    local t76 = {}
    local t77 = {}

    for v234 in DirtyStructure do
        local v235 = Ids[v234]

        if v235 and p203.Signals[v234] then
            local Parent = v4(v234, "Parent")

            if Parent ~= nil then
                if not p203:_inDomain(v234) or p203:_hiddenByBake(v234, Parent) then
                    t74[v235] = true
                    table.insert(t75, v234)
                elseif p203.Kinds[v234] ~= "particle" or p203.Particles[v234] then
                    if Registry.FilterAny then
                        local t79 = {}

                        if Registry:Rematch(v234, Parent, p203.Kids, t79) then
                            table.insert(t79, v234)
                        end

                        for _, v237 in t79 do
                            t77[v237] = DirtyStructure[v234]
                        end
                    end

                    if not t77[v234] then
                        table.insert(t76, v234)
                    end
                else
                    t74[v235] = true
                    table.insert(t75, v234)
                end
            else
                t74[v235] = true
                table.insert(t75, v234)
            end
        end
    end

    for v238 in t77 do
        t74[Ids[v238]] = true
        table.insert(t75, v238)
        p203:_watchFiltered(v238)
    end

    for _, v239 in t75 do
        local v240 = Ids[v239]

        if v240 then
            local v241 = p203.Registry.ParentIds[v239]

            if not t74[v241] then
                Stream:Time(DirtyStructure[v239] or t77[v239])

                local W = Stream.W

                W:u8(Op.Remove)
                Codec.varuint(W, v240)
                Stream:EndRecord()
            end

            p203:_untrackTree(v239, p203.Registry.ById[v241])
        end
    end

    for _, v242 in t76 do
        local v243 = Ids[v242]

        if v243 then
            local v244 = DirtyStructure[v242]
            local Parent = v4(v242, "Parent")
            local v245 = p203:_parentIdOf(v242, Parent, v244)
            local v246 = p203.Registry.ParentIds[v242]

            if v245 ~= nil then
                if v245 ~= v246 then
                    p203.Registry.ParentIds[v242] = v245

                    local v247 = p203.Registry.ById[v246]
                    local v248 = v247 and p203.Kids[v247]

                    if v248 then
                        v248[v242] = nil
                    end

                    p203:_kidsOf(Parent)[v242] = true
                    Stream:Time((math.max(v244, p203.Registry.AddFloor)))

                    local W = Stream.W

                    W:u8(Op.Reparent)
                    Codec.varuint(W, v243)
                    Codec.varuint(W, v245)
                    Stream:EndRecord()
                    p203:_updateInCharacter(v242)

                    if p203.Roots[v242] then
                        p203:_updatePolling(v242)
                    end
                end
            else
                Stream:Time(v244)

                local W = Stream.W

                W:u8(Op.Remove)
                Codec.varuint(W, v243)
                Stream:EndRecord()
                p203:_untrackTree(v242, p203.Registry.ById[v246])
            end
        end
    end

    local t80 = {}

    for v249 in DirtyStructure do
        if not Ids[v249] then
            table.insert(t80, v249)
        end
    end

    table.sort(t80, function(p204, p205) -- line: 2180
        -- upvalues: DirtyStructure (copy)
        return DirtyStructure[p204] < DirtyStructure[p205]
    end)

    local v250 = os.clock() + 0.0015

    for v251, v252 in t80 do
        if v250 <= os.clock() then
            local DirtyStructure2 = p203.DirtyStructure

            for i = v251, #t80 do
                local v253 = t80[i]

                if DirtyStructure2[v253] == nil then
                    DirtyStructure2[v253] = DirtyStructure[v253]
                end
            end

            break
        end

        if v4(v252, "Parent") ~= nil then
            p203:_discover(v252, DirtyStructure[v252])
        end
    end
end

function t13._flushRoots(p206) -- line: 2201
    -- upvalues: AssemblyRootProperty (copy), v4 (ref)
    local RootCheck = p206.RootCheck

    p206.RootCheck = {}

    local Ids = p206.Ids

    while next(RootCheck) do
        local t81 = {}

        for v254, v255 in RootCheck do
            local v256 = Ids[v254]

            if v256 and p206.Kinds[v254] == "part" then
                local v257 = v4
                local AssemblyRootPart, AssemblyRootPart2 = pcall(v257, v254, "AssemblyRootPart")

                if AssemblyRootPart then
                    if AssemblyRootPart2 then
                        if AssemblyRootPart2 ~= v254 and p206.RootOf[v254] ~= AssemblyRootPart2 and not RootCheck[AssemblyRootPart2] then
                            t81[AssemblyRootPart2] = v255
                        end

                        p206.RootOf[v254] = AssemblyRootPart2
                    end

                    local v258 = p206:_isRecordedRoot(v254, AssemblyRootPart2)

                    if v258 ~= (p206.Roots[v254] == true) then
                        p206.Roots[v254] = v258

                        local ClassName = v4(v254, "ClassName")
                        local v259 = p206:_propId(ClassName, AssemblyRootProperty)

                        if v259 then
                            p206:_writeProp(v254, v256, v259, v258, v255)
                        end

                        if v258 then
                            local CFrame = p206:_propId(ClassName, "CFrame")
                            local CFrame2 = v4(v254, "CFrame")

                            if CFrame and p206.LastCFrame[v254] ~= CFrame2 then
                                p206.LastCFrame[v254] = CFrame2
                                p206:_writeProp(v254, v256, CFrame, CFrame2, v255)
                            end
                        end

                        p206:_updatePolling(v254)
                    end
                end
            end
        end

        RootCheck = t81
    end
end

function t13._flushProps(p207) -- line: 2247
    -- upvalues: AssemblyRootProperty (copy), v4 (ref), t1 (copy)
    local Ids, DirtyProps = p207.Ids, p207.DirtyProps

    p207.DirtyProps = {}
    p207.Groups = {}

    local ClassProps = p207.Registry.ClassProps

    for v260 in p207.AnchorCheck do
        if Ids[v260] and p207.Roots[v260] then
            p207:_updatePolling(v260)
        end
    end

    table.clear(p207.AnchorCheck)

    for v261, v262 in DirtyProps do
        local v263 = Ids[v261]
        local v264 = p207.Kinds[v261]

        if v263 and v264 then
            local ClassName = v4(v261, "ClassName")
            local v265 = p207.Held[v261]
            local v266 = ClassProps[ClassName]

            if v266 then
                local v267

                if v264 == "part" then
                    v267 = p207.ByName[ClassName] and v262[p207.ByName[ClassName].Transparency]

                    if v267 then
                        local v268 = v4(v261, "Transparency") >= 1

                        if v265 then
                            if v268 then
                                v265 = true
                                v267 = nil
                                p207.Held[v261] = true
                            else
                                v265 = nil
                                p207.Held[v261] = nil
                            end
                        else
                            if v268 then
                                v265 = true
                                p207.Held[v261] = true
                            end

                            v267 = nil
                        end
                    else
                        v267 = nil
                    end
                end

                local v269 = false

                for _, v270 in v266 do
                    local Id, Name = v270.Id, v270.Name
                    local v271 = v262[Id]

                    if v271 or v267 and t1[Name] then
                        local v272 = v271 or v267

                        if (not v265 or not t1[Name]) and Name ~= AssemblyRootProperty and (v264 ~= "weld" or Name ~= "C0") then
                            local v275, v276 = p207:_read(v261, Name)

                            if v275 then
                                if v264 == "part" and Name == "CFrame" then
                                    if p207.Roots[v261] and p207.LastCFrame[v261] ~= v276 then
                                        p207.LastCFrame[v261] = v276

                                        if (v264 == "joint" or v264 == "weld" or v264 == "constraint") and (Name == "Part0" or Name == "Part1" or Name == "Enabled") then
                                            v269 = true
                                        end

                                        p207:_writeProp(v261, v263, Id, v276, v272)
                                    end
                                else
                                    if (v264 == "joint" or v264 == "weld" or v264 == "constraint") and (Name == "Part0" or Name == "Part1" or Name == "Enabled") then
                                        v269 = true
                                    end

                                    p207:_writeProp(v261, v263, Id, v276, v272)
                                end
                            end
                        end
                    end
                end

                if v269 then
                    local v277 = p207.Clock()
                    local v278 = p207.JointParts[v261]

                    if v278 then
                        p207:_checkRoots(v278[1], v278[2], v277)
                    end

                    local v279, v280 = p207:_jointEnds(v261)

                    p207:_setJointParts(v261, v279, v280)
                    p207:_checkRoots(v279, v280, v277)

                    if v264 == "weld" then
                        local C0 = p207:_propId(ClassName, "C0")
                        local C0_2, C0_3 = p207:_read(v261, "C0")

                        if C0 and C0_2 then
                            p207:_writeProp(v261, v263, C0, C0_3, v277)
                        end
                    end
                end
            end
        end
    end

    p207:_flushGroups()
end

function t13._flushNames(p208) -- line: 2344
    -- upvalues: Codec (copy), Op (copy)
    local DirtyName = p208.DirtyName

    p208.DirtyName = {}

    local Stream = p208.Stream

    for v281, v282 in DirtyName do
        local v283 = p208.Ids[v281]

        if v283 and p208.Signals[v281] then
            Stream:Time(v282)

            local W = Stream.W

            W:u8(Op.Rename)
            Codec.varuint(W, v283)
            Codec.str(W, v281.Name)
            Stream:EndRecord()
        end
    end
end

function t13._poll(p209, p210) -- line: 2362
    -- upvalues: v4 (ref), cframeMoved (copy)
    local List, Set = p210.List, p210.Set
    local v284 = #List

    if v284 == 0 then
        return
    end

    local Ids = p209.Ids
    local v285 = os.clock() + 0.001
    local v286 = p210.Cursor
    local v287 = p209.Clock()
    local n2 = 0
    local v288

    while true do
        if n2 < math.min(v284, 400) then
            if not (os.clock() < v285) then
                v288 = v286
                break
            end

            local v289 = if #List < v286 then 1 else v286
            local v290 = List[v289]

            n2 += 1

            local v291, v292

            if v290 then
                local v293 = Ids[v290]

                if Set[v290] and v293 then
                    v291 = v289 + 1

                    local CFrame = v4(v290, "CFrame")
                    local v294 = p209.LastCFrame[v290]

                    if not v294 or cframeMoved(v294, CFrame) then
                        p209.LastCFrame[v290] = CFrame

                        local v296 = v4
                        local CFrame2 = p209:_propId(v296(v290, "ClassName"), "CFrame")

                        if CFrame2 then
                            p209:_writeProp(v290, v293, CFrame2, CFrame, v287, true)
                        end
                    end

                    v292 = false
                else
                    List[v289] = List[#List]
                    List[#List] = nil

                    if #List == 0 then
                        v288 = v289
                        v292 = true
                    else
                        v291 = v289
                        v292 = false
                    end
                end
            else
                List[v289] = List[#List]
                List[#List] = nil

                if #List == 0 then
                    v288 = v289
                    v292 = true
                else
                    v291 = v289
                    v292 = false
                end
            end

            if v292 then
                break
            end

            v286 = v291
            continue
        end

        v288 = v286
        break
    end

    p210.Cursor = v288
end

function t13._followedRoot(p211, p212) -- line: 2406
    -- upvalues: v4 (ref), t8 (copy)
    if t8[p212.CameraType] then
        return nil
    end

    local CameraSubject = p212.CameraSubject

    if CameraSubject then
        if CameraSubject:IsA("Humanoid") then
            CameraSubject = CameraSubject.RootPart
        elseif not CameraSubject:IsA("BasePart") then
            CameraSubject = if CameraSubject:IsA("Model") then CameraSubject.PrimaryPart else nil
        end
    else
        CameraSubject = nil
    end

    if CameraSubject then
        if not p211.Roots[CameraSubject] then
            CameraSubject = v4(CameraSubject, "AssemblyRootPart")
        end

        if CameraSubject and p211.Ids[CameraSubject] and p211.Roots[CameraSubject] then
            return CameraSubject
        end
    end

    return nil
end

function t13._sampleCamera(p213) -- line: 2418
    -- upvalues: v4 (ref)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return nil
    end

    local v297 = p213:_followedRoot(CurrentCamera)

    return {
        CFrame = CurrentCamera.CFrame,
        Fov = CurrentCamera.FieldOfView,
        Focus = CurrentCamera.Focus.Position,
        Root = v297,
        RootPosition = if v297 then v4(v297, "Position") else Vector3.new(0, 0, 0)
    }
end

function t13._lerpUnits(p214, p215, p216) -- line: 2433
    local v298 = p215 - p214.LastCameraTime

    if not (p216 and v298 > 0 and v298 <= 300) then
        return 0
    end

    return (math.clamp(math.round(v298 / 10), 1, 255))
end

function t13._flushCamera(p217) -- line: 2440
    -- upvalues: Codec (copy), Op (copy), cframeMoved (copy)
    local v301 = p217.CameraSample or p217:_sampleCamera()

    if not v301 then
        return
    end

    local Root = v301.Root

    if Root and p217.Ids[Root] and p217.Roots[Root] then
        p217:_flushFollow(v301, Root)
    else
        local CFrame, Fov = v301.CFrame, v301.Fov
        local LastCamera = p217.LastCamera

        if LastCamera and not cframeMoved(LastCamera, CFrame) and math.abs(Fov - p217.LastFov) < 0.05 then
            return
        end

        local v303 = p217.Clock()
        local v304 = p217:_lerpUnits(v303, LastCamera ~= nil)

        p217.LastCamera = CFrame
        p217.LastFov = Fov
        p217.Follow = nil
        p217.LastCameraTime = v303

        local Stream = p217.Stream

        Stream:Time(v303)

        local W = Stream.W

        W:u8(Op.Camera)
        W:u8(v304)
        Codec.cframe(W, CFrame)
        W:f32(Fov)
        Stream:EndRecord()
    end
end

function t13._flushFollow(p218, p219, p220) -- line: 2473
    -- upvalues: Codec (copy), Op (copy), cframeMoved (copy)
    local CFrame, Fov = p219.CFrame, p219.Fov
    local v305 = CFrame.Position - p219.RootPosition
    local v306 = p219.Focus - p219.RootPosition
    local Follow = p218.Follow
    local Rotation = CFrame.Rotation
    local v307, v308, Rotation2

    if Follow and Follow.Root == p220 then
        local Rotation3 = Follow.Rotation
        local Rotation4, v309

        if cframeMoved(Rotation3.Rotation, Rotation.Rotation) then
            Rotation4 = Rotation
            v309 = bit32.bor(0, 4)
        else
            v309 = 0
            Rotation4 = Follow.Rotation
        end

        local v310, v311

        if (Follow.Focus + Rotation4 * Follow.Offset - v305).Magnitude > 0.02 then
            local v312, v313

            if (v306 - Follow.Focus).Magnitude > 0.02 then
                v313 = v306
                v312 = bit32.bor(v309, 1)
            else
                v312 = v309
                v313 = Follow.Focus
            end

            v311 = v313
            v310 = bit32.bor(v312, 2)
        else
            v310 = v309
            v311 = v306
        end

        v307 = if math.abs(Fov - Follow.Fov) >= 0.05 then bit32.bor(v310, 8) else v310

        if v307 == 0 then
            return
        end

        Rotation2 = Rotation4
        v308 = v311
    else
        Rotation2 = Rotation
        v308 = v306
        v307 = 15
    end

    local v315 = if bit32.btest(v307, 2) then Rotation2:VectorToObjectSpace(v305 - v308) else Follow.Offset
    local v316 = p218.Clock()
    local v317 = p218:_lerpUnits(v316, Follow ~= nil and Follow.Root == p220)

    p218.Follow = {
        Root = p220,
        Focus = v308,
        Offset = v315,
        Rotation = Rotation2,
        Fov = if bit32.btest(v307, 8) then Fov else Follow.Fov
    }
    p218.LastCamera = nil
    p218.LastCameraTime = v316

    local Stream = p218.Stream

    Stream:Time(v316)

    local W = Stream.W

    W:u8(Op.CameraFollow)
    W:u8(v317)
    Codec.varuint(W, p218.Ids[p220])
    W:u8(v307)

    if bit32.btest(v307, 1) then
        W:f32(v308.X)
        W:f32(v308.Y)
        W:f32(v308.Z)
    end

    if bit32.btest(v307, 2) then
        W:f32(v315.X)
        W:f32(v315.Y)
        W:f32(v315.Z)
    end

    if bit32.btest(v307, 4) then
        Codec.rotation(W, Codec.quantizeRotation(Rotation2))
    end

    if bit32.btest(v307, 8) then
        W:f32(Fov)
    end

    Stream:EndRecord()
end

function t13.TrackCharacter(p221, p222) -- line: 2546
    for _, descendant in p222:GetDescendants() do
        if p221.Ids[descendant] and p221.Kinds[descendant] then
            p221:_updateInCharacter(descendant)

            if p221.Roots[descendant] then
                p221:_updatePolling(descendant)
            end
        end
    end
end

function t13.WriteCamera(p223) -- line: 2558
    p223.LastCamera = nil
    p223.Follow = nil
    p223.LastCameraTime = (-1e999)
    p223.CameraSample = nil
    p223:_flushCamera()
end

function t13._pollBaked(p224) -- line: 2568
    -- upvalues: BakedOriginAttribute (copy), PivotProperty (copy), v4 (ref), cframeMoved (copy)
    local v318 = p224.Clock()

    for v319 in p224.Baked do
        local v320 = p224.Ids[v319]

        if v320 and v319:IsA("Model") then
            local Attribute = v319:GetAttribute(BakedOriginAttribute)
            local Pivot = v319:GetPivot()

            if typeof(Attribute) == "CFrame" then
                Pivot *= Attribute:Inverse()
            end

            local v321 = p224.LastCFrame[v319]

            if not v321 or cframeMoved(v321, Pivot) then
                p224.LastCFrame[v319] = Pivot

                local v324 = v4
                local v325 = p224:_propId(v324(v319, "ClassName"), PivotProperty)

                if v325 then
                    p224:_writeProp(v319, v320, v325, Pivot, v318, true)
                end
            end
        end
    end
end

function t13.Flush(p225) -- line: 2589
    table.clear(p225.BakedMemo)
    p225:_flushStructure()
    p225:_walk(os.clock() + 0.001)
    p225:_flushNames()
    p225:_flushRoots()
    p225:_flushProps()
    p225:_flushRoots()
    p225:_pollBaked()
    p225:_poll(p225.WorldPoll)
    p225:_checkMotions()
    p225:_flushCamera()
    p225:_flushEmissionScale()
end

function t13.PollPlayers(p226) -- line: 2609
    -- upvalues: Observability (copy)
    local elapsed = os.clock()
    local v326 = elapsed + Observability.DefaultCaptureInterval

    for v327, v328 in p226.PlayerPolls do
        if next(v328.Queue.Set) ~= nil then
            if v328.Next <= elapsed then
                local v329 = Observability.CaptureIntervalOf(v327)

                v328.Next += v329

                if v328.Next <= elapsed then
                    v328.Next = elapsed + v329
                end

                p226:_poll(v328.Queue)
            end

            v326 = math.min(v326, v328.Next)
        end
    end

    return v326
end

function t13.Destroy(p227) -- line: 2630
    -- upvalues: RunService (copy), newPollQueue (copy), closeWatch (copy)
    p227.Destroyed = true
    RunService:UnbindFromRenderStep("UGReplayCameraSample")
    p227.CameraSample = nil
    p227.Follow = nil

    for _, v330 in p227.Connections do
        v330:Disconnect()
    end

    table.clear(p227.Connections)

    for _, v331 in {
            p227.Signals,
            p227.AttachSignals
        } do
        for _, v332 in v331 do
            for _, v333 in v332 do
                v333:Disconnect()
            end
        end

        table.clear(v331)
    end

    for _, v334 in {
            p227.Watches,
            p227.CharacterScopes,
            p227.Unbaked
        } do
        for v335 in v334 do
            closeWatch(p227, v334, v335)
        end
    end

    for _, v336 in p227.ParticleHosts do
        if v336.Watch then
            for _, v337 in v336.Watch.Connections do
                v337:Disconnect()
            end
        end
    end

    table.clear(p227.ParticleHosts)
    table.clear(p227.Particles)

    for _, v338 in p227.PinSignals do
        v338:Disconnect()
    end

    table.clear(p227.PinSignals)
    table.clear(p227.Kids)
    table.clear(p227.Kinds)
    table.clear(p227.Roots)
    table.clear(p227.RootOf)
    table.clear(p227.JointParts)
    table.clear(p227.TerrainDriven)
    table.clear(p227.Held)
    table.clear(p227.InCharacter)
    table.clear(p227.Baked)
    table.clear(p227.BakedMemo)
    table.clear(p227.LastCFrame)
    table.clear(p227.SentCFrames)
    table.clear(p227.LastSent)
    table.clear(p227.SeqStates)
    table.clear(p227.SeqHolders)
    p227.WorldPoll = newPollQueue()
    table.clear(p227.PlayerPolls)
    table.clear(p227.PolledBy)
    table.clear(p227.Pending)
    p227.DirtyStructure = {}
    p227.DirtyName = {}
    p227.DirtyProps = {}
    p227.RootCheck = {}
end

return t13
