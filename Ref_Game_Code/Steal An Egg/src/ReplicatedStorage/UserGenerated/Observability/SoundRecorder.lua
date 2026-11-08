-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Op, ValueType, RootId = Observability.Op, Observability.ValueType, Observability.RootId

local function v1() -- line: 61
    return workspace[nil]
end

local function v2() -- line: 63
    return debug.info(2, "f")
end

local _, v3 = xpcall(v1, v2)
local v4 = v3

if type(v3) ~= "function" then
    v4 = function(p1, p2) -- line: 67
        return p1[p2]
    end
end

local WorldCFrameProperty, OnCameraProperty, DistanceAttenuationProperty, AngleAttenuationProperty = Observability.WorldCFrameProperty, Observability.OnCameraProperty, Observability.DistanceAttenuationProperty, Observability.AngleAttenuationProperty
local MasterVolumeProperty = Observability.MasterVolumeProperty
local t1 = {
    CoreGui = true,
    CorePackages = true
}
local t2 = {
    AudioPlayer = "IsPlaying",
    AudioTextToSpeech = "IsPlaying",
    AudioWindSynthesizer = "Enabled"
}
local t3 = {
    Sound = true,
    AudioEmitter = true,
    AudioListener = true
}

local function isPositionSource(p3) -- line: 153
    return p3 ~= nil and (p3:IsA("BasePart") or p3:IsA("Attachment"))
end

local function worldCFrameOf(p4) -- line: 159
    if p4 == nil then
        return nil
    end

    if p4 == workspace then
        return CFrame.identity
    end

    if p4:IsA("BasePart") then
        return p4.CFrame
    end

    if p4:IsA("Attachment") then
        return p4.WorldCFrame
    end

    if p4:IsA("Camera") then
        return p4.CFrame
    end

    if p4:IsA("PVInstance") then
        return p4:GetPivot()
    end

    return nil
end

local function serializeCurve(p5) -- line: 178
    if type(p5) ~= "table" then
        return ""
    end

    local t4 = {}

    for v5 in p5 do
        if type(v5) == "number" then
            table.insert(t4, v5)
        end
    end

    table.sort(t4)

    local v6 = table.create(#t4)

    for v7, v8 in t4 do
        v6[v7] = string.format("%.4g:%.4g", v8, p5[v8])
    end

    return table.concat(v6, ",")
end

local function cframeMoved(p6, p7) -- line: 196
    if (p6.Position - p7.Position).Magnitude > 0.05 or (p6.XVector - p7.XVector).Magnitude > 0.003 then
        return true
    end

    return (p6.YVector - p7.YVector).Magnitude > 0.003
end

local function differs(p8, p9, p10) -- line: 204
    -- upvalues: ValueType (copy)
    if p9 == nil or p10 == nil then
        return p9 ~= p10
    end

    if p8 == ValueType.Float32 or p8 == ValueType.Float64 then
        return math.abs(p10 - p9) > math.max(1, (math.abs(p9))) * 0.001
    end

    if p8 ~= ValueType.CFrame then
        return p9 ~= p10
    end

    if (p9.Position - p10.Position).Magnitude > 0.05 or (p9.XVector - p10.XVector).Magnitude > 0.003 then
        return true
    end

    return (p9.YVector - p10.YVector).Magnitude > 0.003
end

local t5 = {}

t5.__index = t5

function t5.new(p11) -- line: 219
    -- upvalues: t5 (copy)
    local v12 = setmetatable({
        Registry = nil,
        Destroyed = false,
        Walked = false,
        GraphDirty = true,
        GraphTime = (-1e999),
        MasterVolumeReadable = true,
        Clock = p11,
        Connections = {},
        WalkQueue = {},
        Seen = setmetatable({}, {
            __mode = "k"
        }),
        SoundSignals = setmetatable({}, {
            __mode = "k"
        }),
        RemovalWatched = setmetatable({}, {
            __mode = "k"
        }),
        Candidates = {},
        Ghosts = {},
        GraphSources = {},
        Wires = {},
        Listeners = {},
        ActiveSources = {},
        Graph = {},
        Wanted = {},
        Nodes = {}
    }, t5)

    for _, child in game:GetChildren() do
        v12:_watchService(child)
    end

    table.insert(v12.Connections, game.ChildAdded:Connect(function(p12) -- line: 262
        -- upvalues: v12 (copy)
        v12:_watchService(p12)
    end))

    return v12
end

function t5._watchService(p13, p14) -- line: 269
    -- upvalues: Players (copy), SoundService (copy), v4 (ref), t1 (copy)
    local v14 = v4
    local ClassName, ClassName2 = pcall(v14, p14, "ClassName")

    if not ClassName or t1[ClassName2] then
        return
    end

    local function v15() -- line: 274
        -- upvalues: p13 (copy), p14 (copy)
        return p14.DescendantAdded:Connect(function(p15) -- line: 275
            -- upvalues: p13 (copy)
            p13:_see(p15)
        end)
    end

    local ok, result = pcall(v15)

    if not ok then
        return
    end

    table.insert(p13.Connections, result)

    if p14 == SoundService or p14 == Players then
        table.insert(p13.WalkQueue, p14)
    else
        table.insert(p13.WalkQueue, 1, p14)
    end
end

function t5._see(p16, p17) -- line: 293
    -- upvalues: v4 (ref), t2 (copy)
    if p16.Destroyed or p16.Seen[p17] then
        return
    end

    local v16 = v4
    local ClassName, ClassName2 = pcall(v16, p17, "ClassName")

    if ClassName then
        if ClassName2 == "Sound" then
            p16.Seen[p17] = true
            p16:_watchSound(p17)
        else
            local v17 = t2[ClassName2]

            if v17 then
                p16.Seen[p17] = true
                p16.GraphSources[p17] = v17
                p16.GraphDirty = true
            elseif ClassName2 == "Wire" then
                p16.Seen[p17] = true
                p16.Wires[p17] = true
                p16.GraphDirty = true
            elseif ClassName2 == "AudioListener" then
                p16.Seen[p17] = true
                p16.Listeners[p17] = true
                p16.GraphDirty = true
            end
        end
    end
end

function t5._watchSound(p18, p19) -- line: 322
    local function maybePlaying() -- line: 323
        -- upvalues: p18 (copy), p19 (copy)
        p18.Candidates[p19] = true
    end

    local t13 = {
        p19.Played:Connect(maybePlaying),
        p19.Changed:Connect(function(p20) -- line: 328
            -- upvalues: p18 (copy), p19 (copy)
            if p20 == "Playing" then
                p18.Candidates[p19] = true
            elseif p20 == "PlayOnRemove" then
                p18:_watchRemoval(p19)
            end
        end)
    }

    p18.SoundSignals[p19] = t13

    if p19.IsPlaying or p19.Playing then
        p18.Candidates[p19] = true
    end

    if p19.PlayOnRemove then
        p18:_watchRemoval(p19)
    end
end

function t5._watchRemoval(p21, p22) -- line: 348
    -- upvalues: worldCFrameOf (copy)
    local v18 = p21.SoundSignals[p22]

    if not v18 or p21.RemovalWatched[p22] then
        return
    end

    p21.RemovalWatched[p22] = true

    local function removed(p23) -- line: 354
        -- upvalues: p21 (copy), p22 (copy)
        local Ghosts, v19, t14, v20, v21

        if not p22.PlayOnRemove or p21.Ghosts[p22] or p22.SoundId == "" then
            return
        else
            local TimeLength, TimePosition = p22.TimeLength, p22.TimePosition
            local v23 = math.max(p22.PlaybackSpeed, 0.01)

            Ghosts = p21.Ghosts
            v19 = p22
            t14 = {
                CFrame = p23,
                Position = TimePosition
            }
            v20 = p21.Clock()
            v21 = if TimeLength > 0 then math.max(0, TimeLength - TimePosition) / v23 * 1000 else 10000
        end

        t14.EndsAt = v20 + v21
        Ghosts[v19] = t14
    end

    table.insert(v18, p22.Destroying:Connect(function() -- line: 369
        -- upvalues: p22 (copy), removed (copy), worldCFrameOf (copy)
        local Parent = p22.Parent

        removed(if Parent ~= nil and (Parent:IsA("BasePart") or Parent:IsA("Attachment")) then worldCFrameOf(p22.Parent) else nil)
    end))
    table.insert(v18, p22.AncestryChanged:Connect(function() -- line: 375
        -- upvalues: p22 (copy), removed (copy)
        if not p22:IsDescendantOf(game) then
            removed(nil)
        end
    end))
end

function t5._walk(p24, p25) -- line: 384
    local WalkQueue = p24.WalkQueue

    while #WalkQueue > 0 and os.clock() < p25 do
        local v28 = table.remove(WalkQueue)

        p24:_see(v28)

        local GetChildren = v28.GetChildren
        local ok, result = pcall(GetChildren, v28)

        if ok then
            table.move(result, 1, #result, #WalkQueue + 1, WalkQueue)
        end
    end
end

function t5.Bind(p26, p27) -- line: 397
    p26.Registry = p27
    table.clear(p26.Nodes)
    p26.GraphDirty = true
    p26.Enabled = p27.ClassProps.Sound ~= nil
end

function t5._soundAudible(_, p29) -- line: 408
    return p29.IsPlaying and p29:IsDescendantOf(game)
end

function t5._traceGraph(p30) -- line: 414
    -- upvalues: Players (copy), v4 (ref)
    local LocalPlayer = Players.LocalPlayer
    local t15 = {}

    for _, v29 in {
            p30.Wires,
            p30.Listeners
        } do
        for v30 in v29 do
            if not v30:IsDescendantOf(game) then
                v29[v30] = nil
                p30.Seen[v30] = nil
            end
        end
    end

    for v31 in p30.Wires do
        local v32 = v4
        local SourceInstance, SourceInstance2 = pcall(v32, v31, "SourceInstance")
        local TargetInstance, TargetInstance2 = pcall(v32, v31, "TargetInstance")

        if SourceInstance and TargetInstance and SourceInstance2 and TargetInstance2 then
            local v33 = t15[SourceInstance2]

            if not v33 then
                v33 = {}
                t15[SourceInstance2] = v33
            end

            table.insert(v33, v31)
        end
    end

    local t16 = {}

    for v34 in p30.Listeners do
        local v35 = v4
        local AudioInteractionGroup, AudioInteractionGroup2 = pcall(v35, v34, "AudioInteractionGroup")

        if AudioInteractionGroup then
            local v36 = t16[AudioInteractionGroup2]

            if not v36 then
                v36 = {}
                t16[AudioInteractionGroup2] = v36
            end

            table.insert(v36, v34)
        end
    end

    local function nextOf(p31) -- line: 450
        -- upvalues: t15 (copy), t16 (copy), v4 (ref)
        local t17 = {}

        for _, v37 in t15[p31] or {} do
            local v38 = v4

            table.insert(t17, v38(v37, "TargetInstance"))
        end

        if v4(p31, "ClassName") == "AudioEmitter" then
            local v39 = v4
            local AudioInteractionGroup, AudioInteractionGroup2 = pcall(v39, p31, "AudioInteractionGroup")
            local v40

            if AudioInteractionGroup then
                v40 = t16[AudioInteractionGroup2]
                v40 = v40 or {}
            else
                v40 = {}
            end

            for _, v41 in v40 do
                table.insert(t17, v41)
            end
        end

        return t17
    end

    local t18 = {}
    local t19 = {}

    for v42 in p30.ActiveSources do
        table.insert(t19, v42)
    end

    while #t19 > 0 do
        local v43 = table.remove(t19)

        if not t18[v43] then
            local v44 = nextOf(v43)

            t18[v43] = v44

            for _, v45 in v44 do
                if not t18[v45] then
                    table.insert(t19, v45)
                end
            end
        end
    end

    local t20 = {}

    for v46 in t18 do
        if v4(v46, "ClassName") == "AudioDeviceOutput" then
            local v47 = v4
            local Player, Player2 = pcall(v47, v46, "Player")

            if Player and (Player2 == nil or Player2 == LocalPlayer) then
                t20[v46] = true
            end
        end
    end

    local v48 = true

    while v48 do
        v48 = false

        for v49, v50 in t18 do
            if not t20[v49] then
                for _, v51 in v50 do
                    if t20[v51] then
                        v48 = true
                        t20[v49] = true
                        break
                    end
                end
            end
        end
    end

    local t21 = {}

    for v52 in t20 do
        t21[v52] = true

        for _, v53 in t15[v52] or {} do
            if t20[v4(v53, "TargetInstance")] then
                t21[v53] = true
            end
        end
    end

    p30.Graph = t21
end

function t5._serviceId(p32, p33) -- line: 524
    -- upvalues: SoundService (copy), RootId (copy)
    if p33 == nil or p33 == workspace then
        return RootId.Workspace
    end

    if p33 ~= SoundService then
        return p32.Registry:StandIn(p33)
    end

    return p32:_ensure(SoundService) or RootId.Workspace
end

function t5._containerOf(p34, p35) -- line: 536
    -- upvalues: SoundService (copy), Observability (copy), RootId (copy)
    if p35 == nil then
        return RootId.Workspace, nil, nil
    end

    local v54 = p34.Nodes[p35]

    if v54 then
        return v54.Id, nil, v54
    end

    if p35 == SoundService then
        return p34:_serviceId(SoundService), nil, nil
    end

    local v55 = Observability.IsAudio(p35)
    local v56 = if not v55 then p34.Registry:Resolve(p35) else nil

    if not v55 and v56 then
        return v56, p35, nil
    end

    local v57 = p35

    while v57.Parent and v57.Parent ~= game do
        v57 = v57.Parent
    end

    if v57.Parent ~= game then
        v57 = nil
    end

    return p34:_serviceId(v57), nil, nil
end

function t5._placement(p36, p37, p38) -- line: 561
    -- upvalues: SoundService (copy), RootId (copy), v4 (ref), t3 (copy)
    local Parent = v4(p37, "Parent")

    if p37 == SoundService then
        return RootId.Workspace, nil, nil, "none"
    end

    local v58 = p36.Ghosts[p37]

    if v58 then
        local Workspace = RootId.Workspace

        if v58.CFrame then
            return Workspace, nil, nil, "world"
        end

        return Workspace, nil, nil, "none"
    end

    if p38 == "SoundGroup" and Parent and Parent:IsA("SoundGroup") then
        local v59 = p36.Nodes[Parent] or p36:_ensureNode(Parent)

        if v59 then
            return v59.Id, nil, v59, "none"
        end
    end

    if t3[p38] then
        if p38 ~= "Sound" and Parent and Parent == workspace.CurrentCamera then
            local v60, v61, v62 = p36:_containerOf(Parent)

            return v60, v61, v62, "camera"
        end

        local v63 = Parent ~= nil and (Parent:IsA("BasePart") or Parent:IsA("Attachment"))

        if not v63 then
            v63 = p38 ~= "Sound" and Parent ~= nil and Parent:IsA("PVInstance")
        end

        if v63 then
            if Parent == Parent and Parent ~= nil and (Parent:IsA("BasePart") or Parent:IsA("Attachment")) then
                local v64 = p36.Registry:Resolve(Parent)

                if v64 then
                    return v64, Parent, nil, "parent"
                end
            end

            local v65, v66, v67 = p36:_containerOf(Parent)

            return v65, v66, v67, "world"
        end

        local v68, v69, v70 = p36:_containerOf(Parent)

        return v68, v69, v70, "none"
    end

    local v71, v72, v73 = p36:_containerOf(Parent)

    return v71, v72, v73, "none"
end

local function contentUri(p39) -- line: 605
    -- upvalues: v4 (ref)
    local v74 = v4
    local AudioContent, AudioContent2 = pcall(v74, p39, "AudioContent")

    if AudioContent and typeof(AudioContent2) == "Content" then
        local Uri = AudioContent2.Uri

        if type(Uri) == "string" then
            return Uri
        end
    end

    return ""
end

function t5._read(p40, p41, p42) -- line: 615
    -- upvalues: SoundService (copy), v4 (ref), WorldCFrameProperty (copy), OnCameraProperty (copy), DistanceAttenuationProperty (copy), AngleAttenuationProperty (copy), MasterVolumeProperty (copy), worldCFrameOf (copy), serializeCurve (copy)
    local Inst = p41.Inst
    local v75 = p40.Ghosts[Inst]

    if p42 == WorldCFrameProperty then
        if p41.Mode ~= "world" then
            return false, nil
        end

        if v75 then
            return v75.CFrame ~= nil, v75.CFrame
        end

        local v76 = worldCFrameOf(v4(Inst, "Parent"))

        return v76 ~= nil, v76
    end

    if p42 == OnCameraProperty then
        return p41.Mode == "camera", true
    end

    if p42 == DistanceAttenuationProperty or p42 == AngleAttenuationProperty then
        local function v77() -- line: 630
            -- upvalues: p42 (copy), Inst (copy), DistanceAttenuationProperty (copy)
            if p42 == DistanceAttenuationProperty then
                return (Inst:GetDistanceAttenuation())
            end

            return (Inst:GetAngleAttenuation())
        end

        local ok, result = pcall(v77)

        if not ok then
            result = nil
        end

        return ok, serializeCurve(result)
    end

    if p42 == MasterVolumeProperty then
        if not p40.MasterVolumeReadable then
            return false, nil
        end

        local function v78() -- line: 640
            return UserSettings():GetService("UserGameSettings").MasterVolume
        end

        local ok, result = pcall(v78)

        p40.MasterVolumeReadable = ok

        return ok, result
    end

    if Inst == SoundService and (p42 == "ListenerType" or p42 == "ListenerCFrame") then
        local Listener, Listener2 = SoundService:GetListener()

        if p42 == "ListenerType" then
            return true, Listener
        end

        if Listener == Enum.ListenerType.CFrame then
            return typeof(Listener2) == "CFrame", Listener2
        end

        local v79, v80

        if Listener ~= Enum.ListenerType.Camera and typeof(Listener2) == "Instance" then
            v79 = worldCFrameOf(Listener2)
            v80 = v79 ~= nil

            return v80, v79
        end

        return false, nil
    end

    local v81 = v4
    local ok, result = pcall(v81, Inst, p42)

    if ok and (p42 == "SoundId" or p42 == "Asset") and result == "" then
        local v82 = v4
        local AudioContent, AudioContent2 = pcall(v82, Inst, "AudioContent")

        if AudioContent and typeof(AudioContent2) == "Content" then
            local Uri = AudioContent2.Uri

            if type(Uri) == "string" then
                return ok, Uri
            end

            return ok, ""
        end

        result = ""
    end

    return ok, result
end

function t5._stored(p43, p44, p45) -- line: 668
    -- upvalues: ValueType (copy)
    if p44 ~= ValueType.Ref then
        return p45
    end

    return if typeof(p45) == "Instance" then p43.Registry.Ids[p45] else nil
end

function t5._writeProp(p46, p47, p48, p49, p50, p51) -- line: 675
    -- upvalues: Codec (copy), Op (copy)
    local Stream = p46.Registry.Stream

    Stream:Time(p50)

    local W = Stream.W

    if p51 then
        W:u8(Op.PropLerp)
        Codec.varuint(W, p47.Id)
        Codec.varuint(W, p48.Id)
        W:u8((math.clamp(math.round(p51 / 10), 1, 255)))
    else
        W:u8(Op.Prop)
        Codec.varuint(W, p47.Id)
        Codec.varuint(W, p48.Id)
    end

    Codec.writeValue(W, p48.Type, p49)
    Stream:EndRecord()
end

function t5._ensureNode(p52, p53) -- line: 695
    local v85 = p52.Nodes[p53]

    if v85 then
        return v85
    end

    return if p52.Wanted[p53] then p52:_ensure(p53) and p52.Nodes[p53] else nil
end

function t5._ensure(p54, p55) -- line: 708
    -- upvalues: Codec (copy), v4 (ref)
    local v86 = p54.Nodes[p55]

    if v86 then
        return v86.Id
    end

    local Registry = p54.Registry
    local ClassName = v4(p55, "ClassName")
    local v87 = Registry.ClassIndex[ClassName]
    local v88 = Registry.ClassProps[ClassName]

    if v87 == nil or v88 == nil then
        return nil
    end

    if ClassName == "Sound" then
        local SoundGroup = v4(p55, "SoundGroup")

        if SoundGroup then
            p54:_ensureNode(SoundGroup)
        end
    elseif ClassName == "Wire" then
        for _, v89 in { "SourceInstance", "TargetInstance" } do
            local v90 = v4(p55, v89)

            if v90 then
                p54:_ensureNode(v90)
            end
        end
    end

    local v91, v92, v93, v94

    if p55:IsA("SoundEffect") then
        v91 = p54:_ensureNode(v4(p55, "Parent"))

        if not v91 then
            return nil
        end

        v92 = v91.Id
        v93 = nil
        v94 = "none"
    else
        v92, v93, v91, v94 = p54:_placement(p55, ClassName)
    end

    if p54.Nodes[p55] then
        return p54.Nodes[p55].Id
    end

    local v95 = p54.Clock()
    local v96 = Registry:Allocate(p55, v92)
    local v97 = Registry:AddTime(v95)
    local t22 = {
        Position = 0,
        Speed = 0,
        Inst = p55,
        ClassName = ClassName,
        Id = v96,
        ParentId = v92,
        ParentInst = v93,
        ParentNode = v91,
        Children = {},
        Mode = v94,
        Values = {},
        PollTime = v97,
        CurveTime = v97,
        PositionTime = v97,
        WantedAt = v95
    }

    if v91 then
        v91.Children[t22] = true
    end

    p54.Nodes[p55] = t22

    local v98 = Registry:DefaultsFor(ClassName) or {}
    local W = Registry.Stream.W

    Registry.Copies:WriteHead(W, v96, v92, v87, v4(p55, "Name"), false)

    local len = W.len

    W:u16(0)

    local v99 = p54.Ghosts[p55]
    local n1 = 0

    for _, v100 in v88 do
        local Name = v100.Name
        local v101, v102 = p54:_read(t22, Name)

        if v101 then
            if Name == "TimePosition" then
                local v103 = v4
                local PlaybackSpeed, PlaybackSpeed2 = pcall(v103, p55, "PlaybackSpeed")

                t22.Speed = if not PlaybackSpeed or type(PlaybackSpeed2) ~= "number" then 1 else PlaybackSpeed2

                if v99 then
                    v102 = v99.Position
                end

                v102 += (v97 - v95) / 1000 * t22.Speed
                t22.Position = v102
                t22.PositionTime = v97
            end

            local v104 = p54:_stored(v100.Type, v102)

            t22.Values[Name] = v104

            if Name == "TimePosition" or v104 ~= nil and v98[v100.Id] ~= v102 then
                Codec.varuint(W, v100.Id)
                Codec.writeValue(W, v100.Type, v102)
                n1 += 1
            end
        end
    end

    W:patchU16(len, n1)
    Registry.Stream:EndRecord()

    return v96
end

function t5._forget(p56, p57) -- line: 813
    for v105 in p57.Children do
        p56:_forget(v105)
    end

    if p57.ParentNode then
        p57.ParentNode.Children[p57] = nil
    end

    p56.Nodes[p57.Inst] = nil
    p56.Registry:Free(p57.Inst)
end

function t5._remove(p58, p59, p60) -- line: 824
    -- upvalues: Codec (copy), Op (copy)
    local Stream = p58.Registry.Stream

    Stream:Time((math.max(p60, p59.PollTime)))

    local W = Stream.W

    W:u8(Op.Remove)
    Codec.varuint(W, p59.Id)
    Stream:EndRecord()
    p58:_forget(p59)
end

function t5._drifted(_, p62, p63, p64) -- line: 835
    -- upvalues: v4 (ref)
    local Inst = p62.Inst
    local v106 = p63 - (p62.Position + (p64 - p62.PositionTime) / 1000 * p62.Speed)
    local v107 = v4
    local TimeLength, TimeLength2 = pcall(v107, Inst, "TimeLength")
    local v108 = if p62.ClassName == "Sound" then "Looped" else "Looping"
    local ok, result = pcall(v107, Inst, v108)
    local v109

    if not TimeLength or not ok or not result or not (TimeLength2 > 0) then
        v109 = v106

        return math.abs(v109) > 0.05
    end

    local LoopRegion, LoopRegion2 = pcall(v107, Inst, "LoopRegion")
    local v110 = p62.ClassName ~= "Sound" or v4(Inst, "PlaybackRegionsEnabled")

    if LoopRegion and v110 and typeof(LoopRegion2) == "NumberRange" and LoopRegion2.Max > LoopRegion2.Min then
        TimeLength2 = math.min(LoopRegion2.Max, TimeLength2) - LoopRegion2.Min
    end

    v109 = if TimeLength2 > 0 then (v106 + TimeLength2 / 2) % TimeLength2 - TimeLength2 / 2 else v106

    return math.abs(v109) > 0.05
end

function t5._poll(p65, p66, p67) -- line: 855
    -- upvalues: ValueType (copy), v4 (ref), DistanceAttenuationProperty (copy), AngleAttenuationProperty (copy), differs (copy)
    local v111 = p65.Registry.ClassProps[p66.ClassName]
    local v112 = p67 - p66.PollTime

    if not (v112 > 0 and v112 <= 300) then
        v112 = nil
    end

    local v113 = p65.Ghosts[p66.Inst] ~= nil
    local v114 = p67 - p66.CurveTime >= 500

    if v114 then
        p66.CurveTime = p67
    end

    local v115 = false

    for _, v116 in v111 do
        local Name = v116.Name

        if Name ~= "TimePosition" then
            if v113 then
                if Name == "Volume" then
                    local v117 = Name == DistanceAttenuationProperty
                    local v118 = if not v117 then Name == AngleAttenuationProperty else nil

                    if v117 and v114 or not v117 and not v118 or not v117 and v114 then
                        local v119, v120 = p65:_read(p66, Name)

                        if v119 then
                            local v121 = p65:_stored(v116.Type, v120)

                            if differs(v116.Type, p66.Values[Name], v121) then
                                p66.Values[Name] = v121

                                if v116.Type == ValueType.Ref and v120 ~= nil and v121 == nil then
                                    v120 = nil
                                end

                                if Name == "PlaybackSpeed" or Name == "Looped" or Name == "Looping" then
                                    v115 = true
                                end

                                p65:_writeProp(p66, v116, v120, p67, if v116.Type == ValueType.Float32 or v116.Type == ValueType.CFrame then v112 else nil)
                            end
                        end
                    end
                end
            elseif Name ~= DistanceAttenuationProperty and Name ~= AngleAttenuationProperty or v114 then
                local v128, v129 = p65:_read(p66, Name)

                if v128 then
                    local v130 = p65:_stored(v116.Type, v129)

                    if differs(v116.Type, p66.Values[Name], v130) then
                        p66.Values[Name] = v130

                        if v116.Type == ValueType.Ref and v129 ~= nil and v130 == nil then
                            v129 = nil
                        end

                        if Name == "PlaybackSpeed" or Name == "Looped" or Name == "Looping" then
                            v115 = true
                        end

                        p65:_writeProp(p66, v116, v129, p67, if v116.Type == ValueType.Float32 or v116.Type == ValueType.CFrame then v112 else nil)
                    end
                end
            end
        end
    end

    local v131 = v4
    local Inst = p66.Inst
    local TimePosition, TimePosition2 = pcall(v131, Inst, "TimePosition")

    if TimePosition and not v113 and type(TimePosition2) == "number" then
        if v115 or p65:_drifted(p66, TimePosition2, p67) then
            for _, v132 in v111 do
                if v132.Name == "TimePosition" then
                    p65:_writeProp(p66, v132, TimePosition2, p67)
                    break
                end
            end

            p66.Position = TimePosition2
            p66.PositionTime = p67
        end

        local v133 = v4
        local Inst = p66.Inst
        local PlaybackSpeed, PlaybackSpeed2 = pcall(v133, Inst, "PlaybackSpeed")

        if PlaybackSpeed and math.abs(PlaybackSpeed2 - p66.Speed) > 0.001 then
            p66.Position = TimePosition2
            p66.PositionTime = p67
            p66.Speed = PlaybackSpeed2
        end
    end

    p66.PollTime = p67
end

function t5._collect(p68, p69) -- line: 917
    -- upvalues: SoundService (copy), v4 (ref)
    local t23 = {}

    p68.Wanted = t23
    t23[SoundService] = true

    local function wantGroupChain(p70) -- line: 922
        -- upvalues: t23 (copy)
        while p70 and p70:IsA("SoundGroup") do
            if t23[p70] then
                break
            end

            t23[p70] = true

            for _, child in p70:GetChildren() do
                if child:IsA("SoundEffect") then
                    t23[child] = true
                end
            end

            p70 = p70.Parent
        end
    end

    local function wantSound(p71) -- line: 933
        -- upvalues: t23 (copy), wantGroupChain (copy)
        t23[p71] = true

        for _, child in p71:GetChildren() do
            if child:IsA("SoundEffect") then
                t23[child] = true
            end
        end

        wantGroupChain(p71.SoundGroup)
    end

    for v136 in p68.Candidates do
        if p68:_soundAudible(v136) then
            wantSound(v136)
        elseif not v136.Playing then
            p68.Candidates[v136] = nil
        end
    end

    for v137, v138 in p68.Ghosts do
        if v138.EndsAt <= p69 then
            p68.Ghosts[v137] = nil
        else
            wantSound(v137)
        end
    end

    local ActiveSources = p68.ActiveSources

    for v139, v140 in p68.GraphSources do
        if v139:IsDescendantOf(game) then
            local v141 = v4
            local ok, result = pcall(v141, v139, v140)
            local v142 = ok and result == true

            if v142 ~= (ActiveSources[v139] == true) then
                if v142 then
                    ActiveSources[v139] = true
                else
                    ActiveSources[v139] = nil
                end

                p68.GraphDirty = true
            end
        else
            p68.GraphSources[v139] = nil
            p68.Seen[v139] = nil
        end
    end

    for v143 in ActiveSources do
        if p68.GraphSources[v143] == nil then
            ActiveSources[v143] = nil
            p68.GraphDirty = true
        end
    end

    if p68.GraphDirty or p69 - p68.GraphTime >= 1000 then
        p68.GraphDirty = false
        p68.GraphTime = p69

        if next(ActiveSources) or next(p68.Graph) then
            p68:_traceGraph()
        end
    end

    for v144 in p68.Graph do
        t23[v144] = true
    end
end

function t5.Flush(p72) -- line: 993
    -- upvalues: SoundService (copy)
    local v145, elapsed, v146, v147

    if p72.Destroyed then
        v147 = true
    elseif p72.Registry and p72.Enabled then
        v145 = p72.Clock()
        elapsed = os.clock()
        v146 = if p72.Walked then 5E-04 else 0.002
        v147 = false
    else
        v147 = true
    end

    if v147 then
        return
    end

    p72:_walk(elapsed + v146)

    if #p72.WalkQueue == 0 then
        p72.Walked = true
    end

    p72:_collect(v145)

    local Wanted = p72.Wanted
    local Ids = p72.Registry.Ids

    for v148, v149 in table.clone(p72.Nodes) do
        if p72.Nodes[v148] == v149 then
            if v149.ParentInst ~= nil and Ids[v149.ParentInst] ~= v149.ParentId or v149.ParentNode ~= nil and p72.Nodes[v149.ParentNode.Inst] ~= v149.ParentNode then
                p72:_forget(v149)
            else
                local v150 = Wanted[v148] ~= nil

                if v150 then
                    v149.WantedAt = v145
                elseif p72.GraphSources[v148] == nil and v148 ~= SoundService and v149.ClassName ~= "Sound" then
                    v150 = v145 - v149.WantedAt < 3000 and v148:IsDescendantOf(game)
                end

                if v150 then
                    if not v148:IsA("SoundEffect") and v148 ~= SoundService and not p72.Ghosts[v148] then
                        local v151, _, _, v152 = p72:_placement(v148, v149.ClassName)

                        if v151 ~= v149.ParentId or v152 ~= v149.Mode then
                            p72:_remove(v149, v145)
                        end
                    end
                else
                    p72:_remove(v149, v145)
                end
            end
        end
    end

    for v153 in Wanted do
        local v154 = p72.Nodes[v153]

        if v154 then
            p72:_poll(v154, v145)
        elseif v153 ~= SoundService or p72.Nodes[SoundService] == nil then
            p72:_ensure(v153)
        end
    end

    for v155, v156 in p72.Nodes do
        if not Wanted[v155] and v156.PollTime < v145 then
            p72:_poll(v156, v145)
        end
    end
end

function t5.Destroy(p73) -- line: 1054
    p73.Destroyed = true

    for _, v157 in p73.Connections do
        v157:Disconnect()
    end

    table.clear(p73.Connections)

    for _, v158 in p73.SoundSignals do
        for _, v159 in v158 do
            v159:Disconnect()
        end
    end

    table.clear(p73.SoundSignals)
    table.clear(p73.Nodes)
    table.clear(p73.Candidates)
    table.clear(p73.Ghosts)
end

return t5
