-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Copies = require(ReplicatedStorage.UserGenerated.Observability.Copies)
local Relevance = require(ReplicatedStorage.UserGenerated.Observability.Relevance)
local Sequences = require(ReplicatedStorage.UserGenerated.Observability.Sequences)
local Styles = require(ReplicatedStorage.UserGenerated.Observability.Styles)
local Op, ValueType = Observability.Op, Observability.ValueType
local ShownBy = Relevance.ShownBy

local function v1() -- line: 81
    return workspace[nil]
end

local function v2() -- line: 83
    return debug.info(2, "f")
end

local _, v3 = xpcall(v1, v2)
local v4 = v3

if type(v3) ~= "function" then
    v4 = function(p1, p2) -- line: 87
        return p1[p2]
    end
end

local t1 = {
    Image = true,
    ImageTransparency = true
}
local t2 = {
    [ValueType.ColorSequence] = 250,
    [ValueType.NumberSequence] = 250
}
local t3 = {
    BackgroundTransparency = true,
    TextTransparency = true,
    TextStrokeTransparency = true,
    ImageTransparency = true,
    GroupTransparency = true,
    Transparency = true,
    BackgroundColor3 = true,
    TextColor3 = true,
    ImageColor3 = true,
    Color = true,
    Visible = true
}
local t4 = {
    [ValueType.Float32] = true,
    [ValueType.Float64] = true,
    [ValueType.UDim] = true,
    [ValueType.UDim2] = true,
    [ValueType.Vector2] = true,
    [ValueType.Vector3] = true,
    [ValueType.Color3] = true,
    [ValueType.Rect] = true,
    [ValueType.NumberRange] = true,
    [ValueType.ColorSequence] = true,
    [ValueType.NumberSequence] = true
}
local t5 = {
    TextLabel = true,
    TextButton = true
}

local function readProp(p3, p4, p5) -- line: 157
    -- upvalues: Styles (copy), v4 (ref), t5 (copy)
    if p5 ~= "Text" or not t5[p4] then
        return Styles.Read(p3, p5)
    end

    local v5 = v4

    return pcall(v5, p3, "LocalizedText")
end

local function isExcluded(p6) -- line: 182
    local PVInstance = p6:IsA("PVInstance")

    if not PVInstance then
        PVInstance = p6:FindFirstAncestorWhichIsA("PVInstance") ~= nil or p6:FindFirstAncestorWhichIsA("ViewportFrame") ~= nil
    end

    return PVInstance
end

local function isWorldGui(p7) -- line: 188
    return p7:IsA("BillboardGui") or p7:IsA("SurfaceGui")
end

local t6 = {}

t6.__index = t6

function t6.new(p8, p9, p10) -- line: 197
    -- upvalues: Players (copy), Codec (copy), t6 (copy)
    local v6 = setmetatable({
        PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui"),
        Registry = p8,
        RecordPlayerGui = p9,
        WorldGuis = p10,
        Stream = p8.Stream,
        ValueScratch = Codec.newWriter(256),
        Clock = p8.Clock,
        ClassIndex = p8.ClassIndex,
        UnknownClassId = p8.UnknownClassId,
        ClassProps = p8.ClassProps,
        ClassPropsByName = p8.ClassPropsByName,
        ClassPolled = p8.ClassPolled,
        PropTypes = p8.PropTypes,
        Ids = p8.Ids,
        ById = p8.ById,
        ParentIds = p8.ParentIds,
        Signals = setmetatable({}, {
            __mode = "k"
        }),
        Kids = setmetatable({}, {
            __mode = "k"
        }),
        Pending = {},
        PendingTime = {},
        PolledValues = setmetatable({}, {
            __mode = "k"
        }),
        Polling = setmetatable({}, {
            __mode = "k"
        }),
        PollNext = setmetatable({}, {
            __mode = "k"
        }),
        PollGap = setmetatable({}, {
            __mode = "k"
        }),
        PollSeen = setmetatable({}, {
            __mode = "k"
        }),
        PollHeld = setmetatable({}, {
            __mode = "k"
        }),
        Held = setmetatable({}, {
            __mode = "k"
        }),
        LastSent = setmetatable({}, {
            __mode = "k"
        }),
        Animating = setmetatable({}, {
            __mode = "k"
        }),
        SeqStates = setmetatable({}, {
            __mode = "k"
        }),
        SeqHolders = setmetatable({}, {
            __mode = "v"
        }),
        SentUDim2 = setmetatable({}, {
            __mode = "k"
        }),
        Defaults = p8.Defaults,
        DeferredParent = setmetatable({}, {
            __mode = "k"
        }),
        DeferredKids = setmetatable({}, {
            __mode = "k"
        }),
        DeferredSignals = setmetatable({}, {
            __mode = "k"
        }),
        WaitingRefs = setmetatable({}, {
            __mode = "k"
        }),
        OnChanged = setmetatable({}, {
            __mode = "k"
        }),
        StyledChecks = setmetatable({}, {
            __mode = "k"
        }),
        RicherRoots = setmetatable({}, {
            __mode = "k"
        }),
        RicherSignals = setmetatable({}, {
            __mode = "k"
        }),
        RicherQueued = setmetatable({}, {
            __mode = "k"
        }),
        DirtyStructure = {},
        DirtyName = {},
        DirtyProps = {},
        DirtyFirst = {},
        RecheckSubtree = {},
        RecheckChildren = {},
        Memo = nil,
        Connections = {},
        Destroyed = false
    }, t6)
    local t54 = {}

    for _, v7 in p8.ClassProps do
        for _, v8 in v7 do
            t54[v8.Id] = v8
        end
    end

    v6.PropEntries = t54
    p8:AddResolver(function(p11, p12) -- line: 296
        -- upvalues: v6 (copy)
        return v6:_track(p11, p12)
    end)
    p8:OnUntracked(function(p13) -- line: 300
        -- upvalues: v6 (copy)
        local v9 = v6.Kids[p13]

        if v9 then
            for v10 in v9 do
                v6:_untrackTree(v10, p13)
            end
        end

        v6:_undeferKids(p13)
    end)

    return v6
end

function t6._inDomain(p14, p15) -- line: 314
    if p15:IsDescendantOf(p14.PlayerGui) then
        local RecordPlayerGui = p14.RecordPlayerGui

        if not RecordPlayerGui then
            return RecordPlayerGui
        end

        local PVInstance = p15:IsA("PVInstance")

        if not PVInstance then
            PVInstance = p15:FindFirstAncestorWhichIsA("PVInstance") ~= nil or p15:FindFirstAncestorWhichIsA("ViewportFrame") ~= nil
        end

        return not PVInstance
    end

    if not p14.WorldGuis then
        return false
    end

    local v11 = if p15:IsA("BillboardGui") or p15:IsA("SurfaceGui") then p15 else p15:FindFirstAncestorWhichIsA("LayerCollector")

    return v11 ~= nil and (v11:IsA("BillboardGui") or v11:IsA("SurfaceGui")) and not p15:IsA("PVInstance") and v11:IsDescendantOf(workspace) and p15:FindFirstAncestorWhichIsA("ViewportFrame") == nil
end

local function kidsOf(p16, p17) -- line: 329
    local v12 = p16.Kids[p17]

    if not v12 then
        v12 = setmetatable({}, {
            __mode = "k"
        })
        p16.Kids[p17] = v12
    end

    return v12
end

function t6._watchChildren(p18, p19, p20) -- line: 339
    local function mark(p21) -- line: 340
        -- upvalues: p18 (copy)
        p18.DirtyStructure[p21] = p18.Clock()
    end

    table.insert(p20, p19.ChildAdded:Connect(mark))
    table.insert(p20, p19.ChildRemoved:Connect(mark))
end

function t6._queueChildren(p22, p23, p24) -- line: 349
    local Children = p23:GetChildren()
    local Pending, PendingTime = p22.Pending, p22.PendingTime

    for i = #Children, 1, -1 do
        table.insert(Pending, Children[i])
        table.insert(PendingTime, p24)
    end
end

function t6._drain(p25, p26) -- line: 360
    -- upvalues: Relevance (copy)
    local Pending, PendingTime = p25.Pending, p25.PendingTime

    if #Pending == 0 then
        return true
    end

    local v14 = p25.Memo == nil

    if v14 then
        p25.Memo = Relevance.NewMemo()
    end

    local v15

    while true do
        if #Pending > 0 then
            if not (p26 and p26 <= os.clock()) then
                p25:_track(table.remove(Pending), (table.remove(PendingTime)))
                continue
            end

            v15 = false
        else
            v15 = true
        end

        break
    end

    if v14 then
        p25.Memo = nil
    end

    return v15
end

function t6._parentId(p27, p28, p29) -- line: 386
    -- upvalues: v4 (ref)
    local Parent = v4(p28, "Parent")

    if Parent == p27.PlayerGui then
        return 0
    end

    return if Parent ~= nil then p27.Ids[Parent] or p27.Registry:Resolve(Parent, p29) else nil
end

function t6._track(p30, p31, p32) -- line: 401
    -- upvalues: Observability (copy), Codec (copy), Copies (copy), Relevance (copy), Sequences (copy), Styles (copy), ValueType (copy), ShownBy (copy), v4 (ref), t1 (copy), t5 (copy), kidsOf (copy)
    local v16 = p30.Ids[p31]

    if v16 then
        return v16
    end

    local ClassName = v4(p31, "ClassName")

    if ClassName == "StyleLink" then
        local Parent = v4(p31, "Parent")

        if Parent and p30.Signals[Parent] and v4(Parent, "ClassName") == "TextLabel" then
            p30:_refreshRicher(Parent)
        end

        return nil
    end

    if not p30.ClassProps[ClassName] and not p30.ClassPolled[ClassName] and ClassName ~= "Folder" or Observability.IsAudio(p31) or not p30:_inDomain(p31) then
        return nil
    end

    local v17 = p30:_parentId(p31, p32)

    if v17 == nil then
        return nil
    end

    local Parent = v4(p31, "Parent")

    if p30.Registry:MatchFilter(p31, Parent) then
        p30:_watchFiltered(p31)

        return nil
    end

    p30:_markRicher(p31, false)

    local Memo = p30.Memo
    local v18 = Relevance.IsHidden(p31, p30.PlayerGui, Memo)

    if v18 and Relevance.SubtreeHidden(p31, p30.PlayerGui) then
        local v19 = p30.DeferredSignals[p31] ~= nil

        if p30.DeferredParent[p31] ~= Parent or v19 ~= Relevance.HidesSubtree(p31) then
            p30:_undefer(p31)
            p30:_defer(p31, Parent)
        end

        return nil
    end

    p30:_undefer(p31)
    p30.Registry:ResolveRefs(p31, ClassName, p32)

    if p30.Ids[p31] then
        return p30.Ids[p31]
    end

    local v20 = p30.Registry:Allocate(p31, v17)

    kidsOf(p30, Parent)[p31] = true

    local v21 = p30.Registry:AddTime(p32)
    local v22 = p30.WaitingRefs[p31]

    if v22 then
        p30.WaitingRefs[p31] = nil

        for v23, v24 in v22 do
            if p30.Ids[v23] then
                for v25 in v24 do
                    p30:_markDirty(v23, v25, v21)
                end
            end
        end
    end

    local v26 = p30.Registry:DefaultsFor(ClassName)
    local v27 = if v18 then nil else Relevance.Suppressed(p31, Memo)
    local W = p30.Stream.W
    local v28, v29 = p30.Registry.Copies:WriteHead(W, v20, v17, p30.ClassIndex[ClassName] or p30.UnknownClassId, v4(p31, "Name"), not v18)
    local Ids = p30.Ids
    local v30 = p30.ClassProps[ClassName]
    local v31 = p30.ClassPolled[ClassName]
    local len = W.len

    W:u16(0)

    local v32, v33

    if v30 then
        local n1 = 0

        v32 = 0

        local v34

        for _, v35 in v30 do
            local Name = v35.Name

            if not v18 or ShownBy[Name] then
                if v27 and v27[Name] then
                    v34 = v34 or {}
                    v34[v35.Id] = true
                else
                    local LocalizedText, LocalizedText2

                    if Name == "Text" and t5[ClassName] then
                        local v38 = v4

                        LocalizedText, LocalizedText2 = pcall(v38, p31, "LocalizedText")
                    else
                        LocalizedText, LocalizedText2 = Styles.Read(p31, Name)
                    end

                    if LocalizedText then
                        if Sequences.Types[v35.Type] then
                            p30:_setSequence(p31, v35.Id, Sequences.keypoints(v35.Type, LocalizedText2), v21)
                        end

                        local v39 = if v35.Type == ValueType.Ref then Copies.refValue(if typeof(LocalizedText2) == "Instance" then Ids[LocalizedText2] else nil, v20) else LocalizedText2

                        if v35.Type == ValueType.Ref and typeof(LocalizedText2) == "Instance" and not Ids[LocalizedText2] then
                            p30:_waitRef(LocalizedText2, p31, v35.Id)
                        end

                        if Copies.differs(v28, v29, v26, v35.Id, LocalizedText2, v39) then
                            Codec.varuint(W, v35.Id)
                            Codec.writeValue(W, v35.Type, LocalizedText2)
                            n1 += 1
                        end
                    end
                end
            end

            v32 = n1
            v33 = v34
        end
    else
        v32 = 0
    end

    if v31 then
        local t57 = {}

        for _, v40 in v31 do
            local v41, v42 = Styles.Read(p31, v40.Name)

            if v41 then
                t57[v40.Id] = v42

                if Copies.differs(v28, v29, v26, v40.Id, v42, v42) then
                    Codec.varuint(W, v40.Id)
                    Codec.writeValue(W, v40.Type, v42)
                    v32 += 1
                end
            end
        end

        p30.PolledValues[p31] = t57

        if not v18 and (not v27 or not v27.IsLoaded) then
            p30:_armPoll(p31)
        else
            p30.PollHeld[p31] = true
        end
    end

    W:patchU16(len, v32)
    p30.Stream:EndRecord()

    if v18 then
        p30.Held[p31] = true
    elseif v33 then
        p30.Held[p31] = v33
    end

    local v43 = Relevance.IsLayout(p31)

    if v43 and p31.Parent then
        p30.RecheckChildren[p31.Parent] = v21
    end

    local v44 = p30.ClassPropsByName[ClassName]
    local v45 = (p31:IsA("BillboardGui") or p31:IsA("SurfaceGui")) and not p31:IsDescendantOf(p30.PlayerGui)
    local t58 = {}

    p30.Signals[p31] = t58

    if ClassName ~= "ViewportFrame" then
        p30:_watchChildren(p31, t58)
        p30:_queueChildren(p31, v21)
    end

    local function changed(p33) -- line: 565
        -- upvalues: p30 (copy), p31 (copy), v31 (copy), v43 (copy), v44 (copy), v45 (copy), ShownBy (copy), t1 (copy)
        if p33 == "Name" then
            p30.DirtyName[p31] = p30.Clock()

            if p30.Registry.FilterAny then
                p30.DirtyStructure[p31] = p30.Clock()
            end

            p30:_renamedRicher(p31)
        elseif p33 ~= "Parent" or not v45 then
            if v44 then
                local v46 = if p33 == "LocalizedText" then "Text" else p33
                local v47 = v44[v46]

                if v47 and not ShownBy[v46] and p30.Held[p31] == true then
                    if v31 and t1[v46] and not p30.Polling[p31] then
                        p30.PollHeld[p31] = true
                    end
                elseif v47 then
                    local v48 = p30.Clock()
                    local v49 = p30.DirtyProps[p31]

                    if not v49 then
                        v49 = {}
                        p30.DirtyProps[p31] = v49
                    end

                    v49[v47] = v48

                    local v50 = p30.DirtyFirst[p31]

                    if not v50 then
                        v50 = {}
                        p30.DirtyFirst[p31] = v50
                    end

                    if v50[v47] == nil then
                        v50[v47] = v48
                    end

                    if v31 and t1[v46] then
                        p30:_armPoll(p31)
                    end

                    if ShownBy[v46] then
                        p30.RecheckSubtree[p31] = v48
                    elseif v43 and v46 == "SortOrder" and p31.Parent then
                        p30.RecheckChildren[p31.Parent] = v48
                    end
                end
            end
        else
            p30.DirtyStructure[p31] = p30.Clock()
        end
    end

    table.insert(t58, p31.Changed:Connect(changed))
    p30.OnChanged[p31] = changed
    p30:_watchStyled(p31, ClassName, true)

    return v20
end

function t6._watchStyled(p34, p35, p36, p37) -- line: 627
    -- upvalues: Styles (copy), v4 (ref), t5 (copy)
    local v51 = p34.StyledChecks[p35]

    if v51 then
        return v51
    end

    local v52 = Styles.Affected[p35]
    local v53 = p34.OnChanged[p35]
    local v54 = p34.Signals[p35]

    if not (v52 and v53 and v54) then
        return nil
    end

    local t59 = {}

    if p37 then
        for v55 in v52 do
            local LocalizedText, LocalizedText2

            if v55 == "Text" and t5[p36] then
                local v56 = v4

                LocalizedText, LocalizedText2 = pcall(v56, p35, "LocalizedText")
            else
                LocalizedText, LocalizedText2 = Styles.Read(p35, v55)
            end

            if LocalizedText then
                t59[v55] = LocalizedText2
            end
        end
    end

    local function check() -- line: 647
        -- upvalues: p35 (copy), p36 (copy), v52 (copy), v53 (copy), t59 (copy), Styles (copy), v4 (ref), t5 (copy)
        for v57 in v52 do
            local LocalizedText, LocalizedText2

            if v57 == "Text" and t5[p36] then
                local v58 = v4

                LocalizedText, LocalizedText2 = pcall(v58, p35, "LocalizedText")
            else
                LocalizedText, LocalizedText2 = Styles.Read(p35, v57)
            end

            if LocalizedText and LocalizedText2 ~= t59[v57] then
                t59[v57] = LocalizedText2
                v53(v57)
            end
        end
    end

    p34.StyledChecks[p35] = check
    table.insert(v54, p35.StyledPropertiesChanged:Connect(function() -- line: 659
        -- upvalues: p34 (copy), p35 (copy), check (copy)
        p34:_markRicher(p35, false)
        check()
    end))

    return check
end

function t6._richerRoot(p38, p39) -- line: 669
    -- upvalues: v4 (ref)
    local RicherRoots = p38.RicherRoots

    if next(RicherRoots) ~= nil then
        local v60 = v4(p39, "Parent")

        for i = 1, 3 do
            if v60 == nil then
                return nil, nil
            end

            local v61 = RicherRoots[v60]

            if v61 then
                if v61.Depth < i then
                    return nil, nil
                end

                return v60, v61
            end

            v60 = v4(v60, "Parent")
        end
    end

    return nil, nil
end

function t6._markRicher(p40, p41, p42) -- line: 693
    -- upvalues: Styles (copy)
    local v62, v63 = p40:_richerRoot(p41)

    if v62 and Styles.MarkRicher(p41, v62, v63, p40.ClassPropsByName) and p42 then
        p40:_restyle(p41)
    end
end

function t6._restyle(p43, p44) -- line: 702
    -- upvalues: v4 (ref)
    local v64 = p43:_watchStyled(p44, v4(p44, "ClassName"), false)

    if v64 then
        v64()
    end
end

function t6._markRicherBelow(p45, p46, p47, p48, p49) -- line: 710
    -- upvalues: Styles (copy)
    local v65 = p45.Kids[p46]

    if v65 then
        for v66 in v65 do
            if Styles.MarkRicher(v66, p47, p48, p45.ClassPropsByName) then
                p45:_restyle(v66)
            end

            if p49 > 1 then
                p45:_markRicherBelow(v66, p47, p48, p49 - 1)
            end
        end
    end
end

function t6._renamedRicher(p50, p51) -- line: 727
    local v67, v68 = p50:_richerRoot(p51)

    if v67 then
        p50:_markRicher(p51, true)
        p50:_markRicherBelow(p51, v67, v68, 2)
    end
end

function t6._refreshRicher(p52, p53) -- line: 739
    -- upvalues: Styles (copy)
    local v69 = p52.RicherSignals[p53]

    if v69 then
        for _, v70 in v69 do
            v70:Disconnect()
        end
    end

    local t60 = {}

    p52.RicherSignals[p53] = t60

    local function again() -- line: 748
        -- upvalues: p52 (copy), p53 (copy)
        p52:_queueRicher(p53)
    end

    local StyleLink = p53:FindFirstChildWhichIsA("StyleLink")
    local v71

    if StyleLink then
        table.insert(t60, StyleLink:GetPropertyChangedSignal("StyleSheet"):Connect(again))
        table.insert(t60, StyleLink.AncestryChanged:Connect(again))

        local StyleSheet2 = StyleLink.StyleSheet

        if StyleSheet2 then
            table.insert(t60, StyleSheet2.DescendantAdded:Connect(again))
        end

        local v72

        v71, v72 = Styles.Richer(StyleLink)

        for _, v73 in v72 do
            table.insert(t60, v73:GetPropertyChangedSignal("Selector"):Connect(again))
        end
    end

    p52.RicherRoots[p53] = v71

    if v71 then
        p52:_markRicherBelow(p53, p53, v71, v71.Depth)
    end
end

function t6._queueRicher(p54, p55) -- line: 774
    if p54.RicherQueued[p55] then
        return
    end

    p54.RicherQueued[p55] = true
    task.defer(function() -- line: 779
        -- upvalues: p54 (copy), p55 (copy)
        p54.RicherQueued[p55] = nil

        if not p54.Destroyed and p54.Signals[p55] then
            p54:_refreshRicher(p55)
        end
    end)
end

function t6._stopRicher(p56, p57) -- line: 787
    p56.RicherRoots[p57] = nil
    p56.RicherQueued[p57] = nil

    local v74 = p56.RicherSignals[p57]

    if v74 then
        for _, v75 in v74 do
            v75:Disconnect()
        end

        p56.RicherSignals[p57] = nil
    end
end

function t6._watchFiltered(p58, p59) -- line: 800
    p58.Registry:WatchFiltered(p59, function() -- line: 801
        -- upvalues: p58 (copy), p59 (copy)
        if not p58.Destroyed then
            p58.DirtyStructure[p59] = p58.Clock()
        end
    end)
end

function t6._defer(p60, p61, p62) -- line: 811
    -- upvalues: Relevance (copy), Styles (copy)
    p60.DeferredParent[p61] = p62

    local v76 = p60.DeferredKids[p62]

    if not v76 then
        v76 = setmetatable({}, {
            __mode = "k"
        })
        p60.DeferredKids[p62] = v76
    end

    v76[p61] = true

    if not Relevance.HidesSubtree(p61) then
        return
    end

    local function retry() -- line: 822
        -- upvalues: p60 (copy), p61 (copy)
        if not p60.Destroyed then
            p60.DirtyStructure[p61] = p60.Clock()
        end
    end

    local t63 = {}
    local v77 = Styles.Affected[p61]

    for _, v78 in Relevance.ShownByOf(p61) do
        table.insert(t63, p61:GetPropertyChangedSignal(v78):Connect(retry))

        if v77 and v77[v78] then
            local StyledPropertiesChanged = p61.StyledPropertiesChanged

            v77 = nil
            table.insert(t63, StyledPropertiesChanged:Connect(retry))
        end
    end

    p60.DeferredSignals[p61] = t63
end

function t6._undefer(p63, p64) -- line: 839
    local v79 = p63.DeferredParent[p64]

    if v79 == nil then
        return
    end

    p63.DeferredParent[p64] = nil

    local v80 = p63.DeferredKids[v79]

    if v80 then
        v80[p64] = nil
    end

    local v81 = p63.DeferredSignals[p64]

    if v81 then
        for _, v82 in v81 do
            v82:Disconnect()
        end

        p63.DeferredSignals[p64] = nil
    end
end

function t6._undeferKids(p65, p66) -- line: 858
    local v83 = p65.DeferredKids[p66]

    if v83 then
        for v84 in v83 do
            p65:_undefer(v84)
        end

        p65.DeferredKids[p66] = nil
    end
end

function t6._waitRef(p67, p68, p69, p70) -- line: 869
    local v85 = p67.WaitingRefs[p68]

    if not v85 then
        v85 = setmetatable({}, {
            __mode = "k"
        })
        p67.WaitingRefs[p68] = v85
    end

    local v86 = v85[p69]

    if not v86 then
        v86 = {}
        v85[p69] = v86
    end

    v86[p70] = true
end

function t6._markDirty(p71, p72, p73, p74) -- line: 883
    local v87 = p71.DirtyProps[p72]

    if not v87 then
        v87 = {}
        p71.DirtyProps[p72] = v87
    end

    v87[p73] = p74
end

function t6._armPoll(p75, p76) -- line: 893
    p75.Polling[p76] = os.clock() + 0.5
    p75.PollNext[p76] = nil
    p75.PollGap[p76] = nil
    p75.PollSeen[p76] = nil
    p75.PollHeld[p76] = nil
end

function t6._stopPoll(p77, p78) -- line: 901
    p77.Polling[p78] = nil
    p77.PollNext[p78] = nil
    p77.PollGap[p78] = nil
    p77.PollSeen[p78] = nil
end

function t6._untrack(p79, p80) -- line: 908
    p79.Registry:Free(p80)
    p79:_undeferKids(p80)
    p79.DirtyProps[p80] = nil
    p79.DirtyFirst[p80] = nil
    p79.DirtyName[p80] = nil
    p79.PolledValues[p80] = nil
    p79:_stopPoll(p80)
    p79.PollHeld[p80] = nil
    p79.Held[p80] = nil
    p79.LastSent[p80] = nil
    p79.Animating[p80] = nil
    p79.SentUDim2[p80] = nil
    p79.OnChanged[p80] = nil
    p79.StyledChecks[p80] = nil
    p79:_stopRicher(p80)

    local v88 = p79.SeqStates[p80]

    if v88 then
        for _, v89 in v88 do
            if p79.SeqHolders[v89.Key] == p80 then
                p79.SeqHolders[v89.Key] = nil
            end
        end

        p79.SeqStates[p80] = nil
    end

    local v90 = p79.Signals[p80]

    if v90 then
        for _, v91 in v90 do
            v91:Disconnect()
        end

        p79.Signals[p80] = nil
    end
end

function t6._untrackTree(p81, p82, p83) -- line: 944
    if p83 then
        local v92 = p81.Kids[p83]

        if v92 then
            v92[p82] = nil
        end
    end

    local t66 = {
        p82
    }

    while #t66 > 0 do
        local v93 = table.remove(t66)
        local v94 = p81.Kids[v93]

        if v94 then
            for v95 in v94 do
                table.insert(t66, v95)
            end

            p81.Kids[v93] = nil
        end

        p81:_untrack(v93)
    end
end

function t6._setSequence(p84, p85, p86, p87, p88) -- line: 965
    -- upvalues: Sequences (copy)
    local v96 = p84.SeqStates[p85]

    if not v96 then
        v96 = {}
        p84.SeqStates[p85] = v96
    end

    local v97 = v96[p86]

    if v97 and p84.SeqHolders[v97.Key] == p85 then
        p84.SeqHolders[v97.Key] = nil
    end

    local v98 = ("%*:%*"):format(p86, (Sequences.key(p87)))

    v96[p86] = {
        Keypoints = p87,
        Key = v98,
        Time = p88
    }
    p84.SeqHolders[v98] = p85
end

function t6._writeSequence(p89, p90) -- line: 983
    -- upvalues: Codec (copy), Sequences (copy), Op (copy)
    local Inst, Id, PropId, Type = p90.Inst, p90.Id, p90.PropId, p90.Type
    local T = p90.T
    local v99 = Sequences.keypoints(Type, p90.Value)
    local v100 = if p90.LerpMs then math.clamp(math.round(p90.LerpMs / 10), 1, 255) else 0
    local Stream = p89.Stream

    Stream:Time(T)

    local W = Stream.W
    local v103 = p89.SeqStates[Inst]
    local v104 = v103 and v103[PropId]
    local v105, v106

    if v104 then
        v105, v106 = Sequences.findShift(v104.Keypoints, v99, Type)
    end

    if not v105 or not v106 then
        local v107 = p89.SeqHolders[("%*:%*"):format(PropId, (Sequences.key(v99)))]
        local v108 = v107 and v107 ~= Inst and p89.Ids[v107]
        local v109 = v108 and p89.SeqStates[v107]
        local v110 = v109 and v109[PropId]

        if v108 and v110 and v110.Time <= T then
            Sequences.writeCopy(W, Id, PropId, v100, v108)
            Stream:EndRecord()
            p89:_setSequence(Inst, PropId, v110.Keypoints, T)
        else
            if p90.LerpMs then
                W:u8(Op.PropLerp)
                Codec.varuint(W, Id)
                Codec.varuint(W, PropId)
                W:u8(v100)
            else
                W:u8(Op.Prop)
                Codec.varuint(W, Id)
                Codec.varuint(W, PropId)
            end

            Codec.writeValue(W, Type, p90.Value)
            Stream:EndRecord()
            p89:_setSequence(Inst, PropId, v99, T)
        end
    else
        Sequences.writeShift(W, Id, PropId, v100, Type, v105, v106)
        Stream:EndRecord()
        p89:_setSequence(Inst, PropId, v106, T)
    end
end

function t6._layoutMoved(p91, p92, p93, p94) -- line: 1032
    -- upvalues: Relevance (copy)
    if not Relevance.IsLayout(p92) then
        return
    end

    local v111 = p93 and p91.ById[p93]

    if v111 then
        p91.RecheckChildren[v111] = p94
    end

    if p92.Parent then
        p91.RecheckChildren[p92.Parent] = p94
    end
end

function t6.IdOf(p95, p96) -- line: 1045
    return if p96 ~= nil then p95.Ids[p96] or p95:_track(p96) else nil
end

function t6.StartWorld(p97) -- line: 1055
    -- upvalues: v4 (ref)
    p97.WorldGuis = true

    local v112 = p97.Clock()
    local ClassRefs = p97.Registry.ClassRefs

    for v113 in p97.Signals do
        local v114 = ClassRefs[v4(v113, "ClassName")]

        if v114 then
            for _, v115 in v114 do
                local v116 = v4
                local Name = v115.Name
                local ok, result = pcall(v116, v113, Name)

                if ok and typeof(result) == "Instance" and not p97.Ids[result] then
                    local v117 = p97.DirtyProps[v113]

                    if not v117 then
                        v117 = {}
                        p97.DirtyProps[v113] = v117
                    end

                    v117[v115.Id] = v112
                end
            end
        end
    end
end

function t6.Snapshot(p98) -- line: 1082
    if p98.RecordPlayerGui then
        local PlayerGui = p98.PlayerGui

        p98:_watchChildren(PlayerGui, p98.Connections)
        p98:_queueChildren(PlayerGui, p98.Clock())

        repeat
            if p98:_drain(os.clock() + 0.002) then
                return
            end

            task.wait()
        until p98.Destroyed
    end
end

function t6.Flush(p99) -- line: 1098
    -- upvalues: Codec (copy), Relevance (copy), Sequences (copy), Styles (copy), Op (copy), ValueType (copy), ShownBy (copy), v4 (ref), t2 (copy), t3 (copy), t4 (copy), t5 (copy), kidsOf (copy)
    local Stream = p99.Stream
    local W = Stream.W
    local Ids, PlayerGui = p99.Ids, p99.PlayerGui
    local v118 = p99.Clock()
    local v119 = Relevance.NewMemo()

    p99.Memo = v119

    local DirtyStructure = p99.DirtyStructure

    p99.DirtyStructure = {}

    local v120 = {}
    local t67 = {}
    local Signals, Registry = p99.Signals, p99.Registry
    local t68 = {}
    local DeferredParent = p99.DeferredParent
    local PropTypes, ClassProps, LastSent

    for v121 in DirtyStructure do
        LastSent = DeferredParent[v121]

        local v122 = false
        local v123 = false

        if LastSent and LastSent ~= v4(v121, "Parent") then
            p99:_undefer(v121)
        end

        LastSent = Ids[v121]

        if LastSent and Signals[v121] then
            ClassProps = v4(v121, "Parent")

            if ClassProps ~= nil then
                if ClassProps == PlayerGui or Ids[ClassProps] then
                    v123 = true
                else
                    v122 = true
                end
            else
                v122 = true
            end
        end

        if v123 then
            if p99:_inDomain(v121) then
                if Registry.FilterAny then
                    PropTypes = {}

                    if Registry:Rematch(v121, ClassProps, p99.Kids, PropTypes) then
                        table.insert(PropTypes, v121)
                    end

                    for _, v124 in PropTypes do
                        t68[v124] = DirtyStructure[v121]
                    end
                end
            else
                v122 = true
            end
        end

        if v122 then
            v120[LastSent] = true
            table.insert(t67, v121)
        end
    end

    for v125 in t68 do
        v120[Ids[v125]] = true
        table.insert(t67, v125)
        p99:_watchFiltered(v125)
    end

    local PolledValues

    for _, v126 in t67 do
        DeferredParent = Ids[v126]

        if DeferredParent then
            Registry = p99.ParentIds[v126]
            LastSent = DirtyStructure[v126] or t68[v126]

            if not v120[Registry] then
                Stream:Time(LastSent)
                W = Stream.W
                W:u8(Op.Remove)
                Codec.varuint(W, DeferredParent)
                Stream:EndRecord()
            end

            p99:_layoutMoved(v126, Registry, LastSent)
            PolledValues = if Registry == 0 then PlayerGui else p99.ById[Registry]
            p99:_untrackTree(v126, PolledValues)
        end
    end

    local v127 = {}

    for v128 in DirtyStructure do
        local v129 = false

        if not Ids[v128] or Signals[v128] then
            v129 = true
        end

        if v129 and p99:_inDomain(v128) then
            table.insert(v127, v128)
        end
    end

    table.sort(v127, function(p100, p101) -- line: 1173
        -- upvalues: DirtyStructure (copy)
        return DirtyStructure[p100] < DirtyStructure[p101]
    end)
    Signals = os.clock() + 0.002
    p99:_drain(Signals)

    local t69 = {}
    local DirtyFirst, AddFloor

    for _, v130 in v127 do
        v120 = DirtyStructure[v130]
        LastSent = Ids[v130]

        if LastSent then
            ClassProps = p99:_parentId(v130, v120)
            p99:_drain(Signals)
            PropTypes = p99.ParentIds[v130]

            if ClassProps ~= nil and ClassProps ~= PropTypes then
                p99.ParentIds[v130] = ClassProps
                DirtyFirst = if PropTypes == 0 then PlayerGui else p99.ById[PropTypes]
                PolledValues = DirtyFirst and p99.Kids[DirtyFirst]

                if PolledValues then
                    PolledValues[v130] = nil
                end

                kidsOf(p99, v4(v130, "Parent"))[v130] = true
                AddFloor = p99.Registry.AddFloor
                Stream:Time((math.max(v120, AddFloor)))
                W = Stream.W
                W:u8(Op.Reparent)
                Codec.varuint(W, LastSent)
                Codec.varuint(W, ClassProps)
                Stream:EndRecord()
                p99.RecheckSubtree[v130] = v120
                p99:_layoutMoved(v130, PropTypes, v120)
            end
        else
            if p99:_track(v130, v120) then
                t69[v130] = true
            end

            p99:_drain(Signals)
        end
    end

    v127 = p99.DirtyName
    p99.DirtyName = {}

    for v131, v132 in v127 do
        Signals = Ids[v131]

        if Signals and not t69[v131] then
            Stream:Time(v132)
            W = Stream.W
            W:u8(Op.Rename)
            Codec.varuint(W, Signals)
            Codec.str(W, v131.Name)
            Stream:EndRecord()
        end
    end

    local Held, PollHeld, PollSeen = p99.Held, p99.PollHeld, p99.PollSeen
    local t70 = {}

    local function recheck(p102, p103) -- line: 1232
        -- upvalues: p99 (copy), Ids (copy), Held (copy), PollHeld (copy), PollSeen (copy), t70 (copy)
        if PollHeld[p102] then
            p99:_armPoll(p102)
        else
            PollSeen[p102] = nil
        end

        if not (Held[p102] and Ids[p102]) then
            return
        end

        if not p99.DirtyProps[p102] then
            p99.DirtyProps[p102] = {}
        end

        t70[p102] = math.max(t70[p102] or 0, p103)
    end

    local Animating = p99.Kids

    LastSent = p99.DeferredKids
    ClassProps = p99.Pending
    PropTypes = p99.PendingTime

    local DirtyFirst2 = {}

    PolledValues = p99.RecheckSubtree
    p99.RecheckSubtree = {}

    local ValueScratch, v134

    for v135, v136 in PolledValues do
        ValueScratch = v4(v135, "Parent")

        if ValueScratch then
            table.insert(DirtyFirst2, v135)

            while #DirtyFirst2 > 0 do
                ValueScratch = table.remove(DirtyFirst2)
                recheck(ValueScratch, v136)

                if not Relevance.HidesSubtree(ValueScratch) then
                    v134 = Animating[ValueScratch]

                    if v134 then
                        for v137 in v134 do
                            table.insert(DirtyFirst2, v137)
                        end
                    end

                    v134 = LastSent[ValueScratch]

                    if v134 then
                        for v138 in v134 do
                            table.insert(ClassProps, v138)
                            table.insert(PropTypes, v136)
                        end
                    end
                end
            end
        end
    end

    PolledValues = p99.RecheckChildren
    p99.RecheckChildren = {}

    for v139, v140 in PolledValues do
        for _, child in v139:GetChildren() do
            recheck(child, v140)
        end
    end

    PolledValues = p99.DirtyProps
    p99.DirtyProps = {}
    DirtyFirst2 = p99.DirtyFirst
    p99.DirtyFirst = {}
    PropTypes = p99.PropTypes
    ClassProps = p99.ClassProps
    LastSent = p99.LastSent
    Animating = p99.Animating

    local SentUDim2, PropEntries = p99.SentUDim2, p99.PropEntries
    local v141 = {}
    local v142 = {}
    local v143 = {}
    local v144 = {}

    ValueScratch = p99.ValueScratch

    local v145, ClassName, v146, v147, v148

    for v149, v150 in PolledValues do
        v145 = Ids[v149]

        local v151 = false
        local v152 = false
        local v153, v154, v155, v156, v157, v158, v159, v160, v161

        if v145 and not t69[v149] then
            ClassName = v4(v149, "ClassName")
            v146 = ClassProps[ClassName]

            if v146 then
                v153 = Held[v149]
                v160 = v153 == true
                v148 = if type(v153) == "table" then v153 else nil
                v147 = Relevance.IsHidden(v149, PlayerGui, v119)

                if not v147 then
                    v161 = Relevance.Suppressed(v149, v119)
                end

                v154 = p99.Defaults[ClassName] or nil
                v155 = DirtyFirst2[v149]
                v156 = Animating[v149]
                v157 = t70[v149]

                if not v157 then
                    v159 = v157

                    for _, v162 in v150 do
                        v158 = v159 or 0
                        v159 = math.max(v158, v162)
                        v157 = v159
                    end
                end

                v151 = true
            end
        end

        local v163, v164

        if v151 then
            if v153 ~= nil then
                v163 = v146
            else
                v163 = v141
                table.clear(v141)

                for v165 in v150 do
                    v164 = PropEntries[v165]
                    table.insert(v141, v164)
                end
            end

            v152 = true
        end

        if v152 then
            local v166 = v148
            local v167 = v156
            local v168, v169

            for _, v170 in v163 do
                local Id, Name = v170.Id, v170.Name

                v158 = v150[Id]

                local v171 = false
                local v172 = false
                local v173 = false
                local v174 = false
                local v175 = false
                local v176 = false
                local v177 = false
                local v178 = false

                v169 = v158 ~= nil
                v164 = if v160 then not ShownBy[Name] else v166 ~= nil and v166[Id] == true

                if v169 or v164 then
                    v171 = true
                end

                if v171 then
                    if not v147 or ShownBy[Name] then
                        v172 = true
                    else
                        v173 = true
                    end
                end

                if v172 then
                    if v161 and v161[Name] then
                        v173 = true
                    else
                        v174 = true
                    end
                end

                local v179, v180

                if v174 then
                    v179 = t2[v170.Type]
                    v180 = v179 and LastSent[v149]

                    if v169 and v180 and v180[Id] and v118 - v180[Id] < v179 then
                        v168 = v168 or {}
                        v168[Id] = true
                    else
                        v175 = true
                    end
                end

                local LocalizedText, ok

                if v175 then
                    if Name == "Text" and t5[ClassName] then
                        LocalizedText = v4
                        ok, LocalizedText = pcall(LocalizedText, v149, "LocalizedText")
                    else
                        ok, LocalizedText = Styles.Read(v149, Name)
                    end

                    if ok then
                        if v166 then
                            v166[Id] = nil
                        end

                        if not v160 or v169 or not v154 or v154[Id] ~= LocalizedText then
                            v176 = true
                        end
                    end
                end

                local v181, v182

                if v176 then
                    v181 = v158 or v118

                    local v183

                    if v164 then
                        v183 = v157 or v118
                        v181 = math.max(v181, v183)
                    end

                    local v184

                    if v169 and not v164 and t4[v170.Type] then
                        ok = v167 and v167[Id]
                        v184 = v155 and v155[Id]

                        if ok and v181 - ok <= 300 + (v179 or 0) then
                            v182 = v181 - ok
                        elseif v184 and v184 < v181 then
                            v182 = v181 - v184 + 16.666666666666668
                        end
                    end

                    if Sequences.Types[v170.Type] then
                        v183 = {
                            Inst = v149,
                            Id = v145,
                            PropId = Id,
                            Type = v170.Type,
                            Value = LocalizedText,
                            LerpMs = v182,
                            T = v181,
                            Index = #v142 + 1
                        }
                        table.insert(v142, v183)
                    else
                        if v170.Type == ValueType.Ref and typeof(LocalizedText) == "Instance" and not p99.Registry:Resolve(LocalizedText, v181) then
                            p99:_waitRef(LocalizedText, v149, Id)
                        end

                        if v170.Type == ValueType.UDim2 then
                            v169 = SentUDim2[v149]

                            if typeof(LocalizedText) == "UDim2" then
                                ok = v169 and v169[Id]
                                v164 = if ok then Codec.udim2Mask(ok, LocalizedText) else 15

                                if not v169 then
                                    v169 = {}
                                    SentUDim2[v149] = v169
                                end

                                v169[Id] = LocalizedText
                            else
                                if v169 then
                                    v169[Id] = nil
                                end

                                v164 = 15
                            end
                        else
                            v164 = 15
                        end

                        if v182 then
                            v183 = v182 / 10
                            v184 = math.round(v183)
                            ok = math.clamp(v184, 1, 255)
                        else
                            ok = 0
                        end

                        if v164 ~= 15 or not t3[Name] or v170.Type == ValueType.UDim2 then
                            if v164 ~= 0 then
                                Stream:Time(v181)
                                W = Stream.W

                                if v164 == 15 then
                                    if v182 then
                                        W:u8(Op.PropLerp)
                                        Codec.varuint(W, v145)
                                        Codec.varuint(W, Id)
                                        W:u8(ok)
                                    else
                                        W:u8(Op.Prop)
                                        Codec.varuint(W, v145)
                                        Codec.varuint(W, Id)
                                    end

                                    Codec.writeValue(W, PropTypes[Id], LocalizedText)
                                else
                                    W:u8(Op.UDim2Part)
                                    Codec.varuint(W, v145)
                                    Codec.varuint(W, Id)
                                    W:u8(ok)
                                    Codec.udim2Part(W, v164, LocalizedText)
                                end

                                Stream:EndRecord()
                            end
                        else
                            ValueScratch.len = 0
                            Codec.writeValue(ValueScratch, PropTypes[Id], LocalizedText)
                            v184 = buffer.readstring(ValueScratch.buf, 0, ValueScratch.len)
                            v183 = ("%*:%*:%*:%*"):format(Id, ok, math.floor(v181), v184)

                            local v185 = v143[v183]

                            if v185 then
                                table.insert(v185.Ids, v145)
                            else
                                local t71 = {
                                    PropId = Id,
                                    LerpUnits = ok,
                                    T = v181,
                                    Encoded = v184,
                                    Ids = { v145 }
                                }

                                v143[v183] = t71
                                table.insert(v144, t71)
                            end
                        end
                    end

                    v177 = true
                end

                if v177 then
                    if v182 then
                        v167 = v167 or {}
                        v167[Id] = v181
                        Animating[v149] = v167
                    elseif v167 then
                        v167[Id] = nil
                    end

                    if v179 then
                        ok = v180 or {}
                        ok[Id] = v118
                        LastSent[v149] = ok
                    end
                end

                if v173 and not (v160 and v147) then
                    v178 = true
                end

                if v178 then
                    v166 = v166 or {}
                    v166[Id] = true
                end
            end

            if not v160 or not v147 then
                if not v166 or not next(v166) then
                    v166 = nil
                end

                Held[v149] = v166
            end

            if v168 then
                local v186 = p99.DirtyProps[v149]

                if not v186 then
                    v186 = {}
                    p99.DirtyProps[v149] = v186
                end

                v159 = p99.DirtyFirst[v149]

                if not v159 then
                    v159 = {}
                    p99.DirtyFirst[v149] = v159
                end

                for v187 in v168 do
                    v169 = v186[v187] or 0
                    v164 = v150[v187]
                    v186[v187] = math.max(v169, v164)

                    local v188 = v155 and v155[v187]

                    if v188 then
                        v169 = v159[v187] or v188
                        v159[v187] = math.min(v169, v188)
                    end
                end
            end
        end
    end

    for _, v189 in v144 do
        ValueScratch = v189.Ids
        Stream:Time(v189.T)
        W = Stream.W

        if #ValueScratch == 1 then
            v146 = if v189.LerpUnits > 0 then Op.PropLerp else Op.Prop
            W:u8(v146)
            Codec.varuint(W, ValueScratch[1])
            Codec.varuint(W, v189.PropId)

            if v189.LerpUnits > 0 then
                W:u8(v189.LerpUnits)
            end
        else
            table.sort(ValueScratch)
            W:u8(Op.PropMany)
            Codec.varuint(W, v189.PropId)
            W:u8(v189.LerpUnits)
            v143 = 0
            Codec.varuint(W, #ValueScratch)

            for _, v190 in ValueScratch do
                Codec.varuint(W, v190 - v143)
                v143 = v190
            end
        end

        ValueScratch = v189.Encoded
        W:_ensure(#ValueScratch)
        buffer.writestring(W.buf, W.len, ValueScratch)
        W.len += #ValueScratch
        Stream:EndRecord()
    end

    table.sort(v142, function(p104, p105) -- line: 1539
        if p104.T == p105.T then
            return p104.Index < p105.Index
        end

        return p104.T < p105.T
    end)

    for _, v191 in v142 do
        p99:_writeSequence(v191)
    end

    v144 = p99.Polling
    v142 = p99.PollNext
    v141 = p99.PollGap
    PropEntries = p99.PollSeen
    PolledValues = p99.PolledValues
    DirtyFirst2 = p99.ClassPolled
    v134 = os.clock()
    Stream:Time(v118)

    for v192, v193 in v144 do
        LastSent = v142[v192]

        local v194 = false
        local v195 = false
        local v196 = false
        local v197 = false

        if not LastSent or not (v134 < LastSent) then
            v194 = true
        end

        local v198

        if v194 then
            LastSent = Ids[v192]
            Animating = PolledValues[v192]
            SentUDim2 = DirtyFirst2[v4(v192, "ClassName")]

            if LastSent and Animating and SentUDim2 then
                v198 = v134 < v193
                v118 = false

                for _, v199 in SentUDim2 do
                    v148, v147 = Styles.Read(v192, v199.Name)

                    if v148 then
                        if v147 ~= Animating[v199.Id] then
                            Animating[v199.Id] = v147
                            W = Stream.W
                            W:u8(Op.Prop)
                            Codec.varuint(W, LastSent)
                            Codec.varuint(W, v199.Id)
                            Codec.writeValue(W, PropTypes[v199.Id], v147)
                            Stream:EndRecord()
                        end

                        if not v147 then
                            v118 = true
                        end
                    end
                end

                if v118 then
                    LastSent = PropEntries[v192]

                    if not LastSent or LastSent <= v134 then
                        v196 = true
                    else
                        v197 = true
                    end
                elseif not v198 then
                    p99:_stopPoll(v192)
                end
            else
                v195 = true
            end
        end

        if v196 then
            if Relevance.PolledUnseen(v192, PlayerGui, v119) then
                p99:_stopPoll(v192)
                p99.PollHeld[v192] = true
            else
                v197 = true
                PropEntries[v192] = v134 + 5
            end
        end

        if v197 and not v198 then
            ClassName = (v141[v192] or 0.05) * 2
            v145 = math.min(ClassName, 1)
            v141[v192] = v145
            v142[v192] = v134 + v145 * (0.75 + math.random() * 0.5)
        end

        if v195 then
            p99:_stopPoll(v192)
        end
    end

    p99.Memo = nil
end

function t6.Destroy(p106) -- line: 1618
    p106.Destroyed = true

    for _, v200 in p106.Connections do
        v200:Disconnect()
    end

    table.clear(p106.Connections)

    for _, v201 in p106.Signals do
        for _, v202 in v201 do
            v202:Disconnect()
        end
    end

    table.clear(p106.Signals)

    for _, v203 in p106.DeferredSignals do
        for _, v204 in v203 do
            v204:Disconnect()
        end
    end

    table.clear(p106.DeferredSignals)

    for _, v205 in p106.RicherSignals do
        for _, v206 in v205 do
            v206:Disconnect()
        end
    end

    table.clear(p106.RicherSignals)
    table.clear(p106.RicherRoots)
    table.clear(p106.RicherQueued)
    table.clear(p106.OnChanged)
    table.clear(p106.StyledChecks)
    table.clear(p106.DeferredParent)
    table.clear(p106.DeferredKids)
    table.clear(p106.WaitingRefs)
    table.clear(p106.Kids)
    table.clear(p106.Pending)
    table.clear(p106.PendingTime)
    table.clear(p106.Ids)
    table.clear(p106.ById)
    table.clear(p106.ParentIds)
    table.clear(p106.PolledValues)
    table.clear(p106.Polling)
    table.clear(p106.PollNext)
    table.clear(p106.PollGap)
    table.clear(p106.PollSeen)
    table.clear(p106.PollHeld)
    table.clear(p106.Held)
    table.clear(p106.LastSent)
    table.clear(p106.Animating)
    table.clear(p106.SeqStates)
    table.clear(p106.SeqHolders)
    table.clear(p106.SentUDim2)
    p106.DirtyStructure = {}
    p106.DirtyName = {}
    p106.DirtyProps = {}
    p106.DirtyFirst = {}
    p106.RecheckSubtree = {}
    p106.RecheckChildren = {}
end

return t6
