-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local Copies = require(ReplicatedStorage.UserGenerated.Observability.Copies)
local Op, ValueType = Observability.Op, Observability.ValueType

local function v1() -- line: 39
    return workspace[nil]
end

local function v2() -- line: 41
    return debug.info(2, "f")
end

local _, v3 = xpcall(v1, v2)
local v4 = v3

if type(v3) ~= "function" then
    v4 = function(p1, p2) -- line: 45
        return p1[p2]
    end
end

local v5 = table.freeze({
    Marked = false,
    Include = true,
    Children = table.freeze({})
})

local function newFilterNode(p3) -- line: 59
    return {
        Marked = false,
        Children = {},
        Include = p3
    }
end

local function buildFilter(p4) -- line: 64
    if p4.FilterType ~= "Include" and p4.FilterType ~= "Exclude" then
        return nil
    end

    local v6 = p4.FilterType == "Include"
    local t1 = {
        Marked = false,
        Children = {},
        Include = v6
    }

    for _, v7 in p4.Filter do
        if type(v7) == "string" then
            local v8 = t1

            for match in string.gmatch(v7, "[^%.]+") do
                local v9 = v8.Children[match]

                if v9 then
                    v8 = v9
                else
                    local t2 = {
                        Marked = false,
                        Children = {},
                        Include = v6
                    }

                    v8.Children[match] = t2
                    v8 = t2
                end
            end

            if v8 ~= t1 then
                v8.Marked = true
            end
        end
    end

    return if v6 or next(t1.Children) ~= nil then t1 else nil
end

local t3 = {}

t3.__index = t3
t3.BuildFilter = buildFilter

function t3.new(p5, p6, p7) -- line: 100
    -- upvalues: Observability (copy), Codec (copy), Copies (copy), ValueType (copy), t3 (copy)
    local t4 = {}

    for v10, v11 in p5.Classes do
        t4[v11] = v10 - 1
    end

    local t5 = {}
    local t6 = {}
    local t7 = {}
    local t8 = {}

    for v12, v13 in p5.ClassProps do
        local t9 = {}
        local t10 = {}
        local t11 = {}
        local t12 = {}

        for _, v14 in v13 do
            local v15 = p5.Props[v14 + 1]

            if v15 then
                local t13 = {
                    Id = v14,
                    Name = v15.Name,
                    Type = v15.Type
                }

                if Observability.PolledProperties[v15.Name] then
                    table.insert(t11, t13)
                else
                    table.insert(t9, t13)
                    t10[v15.Name] = v14
                end

                if v15.Type == ValueType.Ref then
                    table.insert(t12, t13)
                end
            end
        end

        t5[v12] = t9
        t6[v12] = t10

        if #t11 > 0 then
            t7[v12] = t11
        end

        if #t12 > 0 then
            t8[v12] = t12
        end
    end

    local t14 = {}

    for v16, v17 in p5.Props do
        t14[v16 - 1] = v17.Type
    end

    local v18 = setmetatable({
        AddFloor = 0,
        FilterAny = false,
        Stream = p6,
        Clock = p7,
        NextId = Observability.FirstInstanceId,
        ClassIndex = t4,
        UnknownClassId = #p5.Classes,
        ClassProps = t5,
        ClassPropsByName = t6,
        ClassPolled = t7,
        ClassRefs = t8,
        PropTypes = t14,
        Ids = setmetatable({}, {
            __mode = "k"
        }),
        ById = setmetatable({}, {
            __mode = "v"
        }),
        ParentIds = setmetatable({}, {
            __mode = "k"
        }),
        Defaults = {},
        Copies = Copies.new(#p5.Classes),
        Resolvers = {},
        UntrackHandlers = {},
        FilterRoots = {},
        FilterNodes = setmetatable({}, {
            __mode = "k"
        }),
        FilteredSignals = setmetatable({}, {
            __mode = "k"
        }),
        Pins = {},
        PinCounts = setmetatable({}, {
            __mode = "k"
        }),
        StandIns = {}
    }, t3)

    Codec.setRefLookup(function(p8) -- line: 182
        -- upvalues: v18 (copy)
        return v18.Ids[p8]
    end)

    return v18
end

function t3.SetFilter(p9, p10, p11) -- line: 189
    -- upvalues: v5 (copy), buildFilter (copy)
    local v19 = buildFilter(p11)

    p9.FilterRoots[p10] = v19

    if v19 then
        p9.FilterAny = true
    end

    local Terrain = if p10 == workspace then workspace:FindFirstChildOfClass("Terrain") else nil

    if not (Terrain and v19) then
        return
    end

    local Terrain2 = v19.Children.Terrain

    if Terrain2 ~= nil then
        if Terrain2.Marked then
            local FilterRoots = p9.FilterRoots

            if v19.Include then
                FilterRoots[Terrain] = nil
            else
                FilterRoots[Terrain] = v5
            end
        else
            p9.FilterRoots[Terrain] = Terrain2
        end
    else
        local FilterRoots = p9.FilterRoots

        if v19.Include then
            FilterRoots[Terrain] = v5
        else
            FilterRoots[Terrain] = nil
        end
    end
end

function t3.FilterRoot(p12, p13) -- line: 210
    return p12.FilterRoots[p13]
end

function t3.MatchFilter(p14, p15, p16) -- line: 217
    -- upvalues: v4 (ref), v5 (copy)
    if not p14.FilterAny then
        return false, false
    end

    local v20 = p16 and (p14.FilterRoots[p16] or p14.FilterNodes[p16])
    local v21, v22

    if v20 then
        v21 = v20.Children[v4(p15, "Name")]

        if v20.Include then
            if v21 ~= nil then
                if v21.Marked then
                    v21 = nil
                end

                v22 = false
            else
                v22 = true
                v21 = nil
            end
        elseif v21 then
            if v21.Marked then
                v22 = true
                v21 = nil
            else
                v22 = false
            end
        else
            v22 = false
            v21 = nil
        end
    else
        v22 = false
    end

    if p14.Pins[p15] then
        v22 = false
        v21 = nil
    elseif v22 and p14.PinCounts[p15] then
        v22 = false
        v21 = v5
    end

    local v23 = p14.FilterNodes[p15] ~= v21

    p14.FilterNodes[p15] = v21

    return v22, v23
end

function t3.WatchFiltered(p17, p18, p19) -- line: 250
    if p17.FilteredSignals[p18] then
        return
    end

    p17.FilteredSignals[p18] = p18:GetPropertyChangedSignal("Name"):Connect(function() -- line: 254
        -- upvalues: p17 (copy), p18 (copy), p19 (copy)
        local v24 = p17.FilteredSignals[p18]

        if v24 then
            v24:Disconnect()
            p17.FilteredSignals[p18] = nil
        end

        p19()
    end)
end

function t3.Rematch(p20, p21, p22, p23, p24) -- line: 267
    local v25, v26 = p20:MatchFilter(p21, p22)

    if v25 then
        return true
    end

    if v26 then
        local t28 = {
            p21
        }

        while #t28 > 0 do
            local v27 = table.remove(t28)
            local v28 = p23[v27]

            if v28 then
                for v29 in v28 do
                    local v30, v31 = p20:MatchFilter(v29, v27)

                    if v30 then
                        table.insert(p24, v29)
                    elseif v31 then
                        table.insert(t28, v29)
                    end
                end
            end
        end
    end

    return false
end

local function unpinChain(p25, p26) -- line: 298
    local PinCounts = p25.PinCounts

    for _, v32 in p26 do
        local v33 = (PinCounts[v32] or 1) - 1

        if not (v33 > 0) then
            v33 = nil
        end

        PinCounts[v32] = v33
    end
end

function t3.Pin(p27, p28) -- line: 308
    local v34 = p27.Pins[p28]

    if v34 then
        local PinCounts = p27.PinCounts

        for _, v35 in v34 do
            local v36 = (PinCounts[v35] or 1) - 1

            if not (v36 > 0) then
                v36 = nil
            end

            PinCounts[v35] = v36
        end
    end

    local t29 = {}
    local PinCounts = p27.PinCounts
    local Parent = p28.Parent

    while Parent and Parent ~= workspace do
        if Parent == game then
            break
        end

        table.insert(t29, Parent)
        PinCounts[Parent] = (PinCounts[Parent] or 0) + 1
        Parent = Parent.Parent
    end

    p27.Pins[p28] = t29

    local v37 = table.clone(t29)

    table.insert(v37, p28)

    if v34 then
        table.move(v34, 1, #v34, #v37 + 1, v37)
    end

    return v37
end

function t3.Unpin(p29, p30) -- line: 331
    local v38 = p29.Pins[p30]

    if not v38 then
        return {}
    end

    local PinCounts = p29.PinCounts

    for _, v39 in v38 do
        local v40 = (PinCounts[v39] or 1) - 1

        if not (v40 > 0) then
            v40 = nil
        end

        PinCounts[v39] = v40
    end

    p29.Pins[p30] = nil

    local v41 = table.clone(v38)

    table.insert(v41, p30)

    return v41
end

function t3.AddResolver(p31, p32) -- line: 343
    table.insert(p31.Resolvers, p32)
end

function t3.OnUntracked(p33, p34) -- line: 349
    table.insert(p33.UntrackHandlers, p34)
end

function t3.NotifyUntracked(p35, p36) -- line: 353
    for _, v42 in p35.UntrackHandlers do
        v42(p36)
    end
end

function t3.Resolve(p37, p38, p39) -- line: 360
    local v43 = p37.Ids[p38]

    if v43 then
        return v43
    end

    for _, v44 in p37.Resolvers do
        local v45 = v44(p38, p39)

        if v45 then
            return v45
        end
    end

    return nil
end

function t3.ResolveRefs(p40, p41, p42, p43) -- line: 376
    -- upvalues: v4 (ref)
    local v46 = p40.ClassRefs[p42]

    if v46 then
        for _, v47 in v46 do
            local v48 = v4
            local Name = v47.Name
            local ok, result = pcall(v48, p41, Name)

            if ok and typeof(result) == "Instance" then
                p40:Resolve(result, p43)
            end
        end
    end
end

function t3.Allocate(p44, p45, p46) -- line: 389
    local NextId = p44.NextId

    p44.NextId += 1
    p44.Ids[p45] = NextId
    p44.ById[NextId] = p45
    p44.ParentIds[p45] = p46

    return NextId
end

function t3.Free(p47, p48) -- line: 398
    local v49 = p47.Ids[p48]

    if v49 then
        p47.ById[v49] = nil
        p47.Copies:Forget(v49)
    end

    p47.Ids[p48] = nil
    p47.ParentIds[p48] = nil
end

function t3.StandIn(p49, p50) -- line: 411
    -- upvalues: Observability (copy)
    local Workspace = Observability.RootId.Workspace

    if p50 == workspace then
        return Workspace
    end

    local v50 = p49.StandIns[p50]

    if v50 then
        return v50
    end

    local v51 = p49:Allocate(p50, Workspace)

    p49:AddTime(p49.Clock())

    local W = p49.Stream.W

    p49.Copies:WriteHead(W, v51, Workspace, p49.UnknownClassId, p50.Name, false)
    W:u16(0)
    p49.Stream:EndRecord()
    p49.StandIns[p50] = v51

    return v51
end

function t3.AddTime(p51, p52) -- line: 432
    local v53 = math.max(p52 or p51.Clock(), p51.AddFloor)

    p51.AddFloor = v53
    p51.Stream:Time(v53)

    return v53
end

function t3.DefaultsFor(p53, p54) -- line: 440
    -- upvalues: Codec (copy), Op (copy), ValueType (copy), v4 (ref)
    local v54 = p53.Defaults[p54]

    if v54 ~= nil then
        return v54 or nil
    end

    local v55 = p53.ClassIndex[p54]
    local v56 = p53.ClassProps[p54]
    local v57 = p53.ClassPolled[p54]
    local new = Instance.new
    local ok, result = pcall(new, p54)

    if ok and v55 and (v56 or v57) then
        local t30 = {}
        local W = p53.Stream.W

        W:u8(Op.Defaults)
        Codec.varuint(W, v55)

        local len = W.len

        W:u16(0)

        local t31 = {
            v56 or {},
            v57 or {}
        }
        local n1 = 0

        for _, v60 in t31 do
            for _, v62 in v60 do
                local v63 = v4
                local Name = v62.Name
                local ok, result2 = pcall(v63, result, Name)

                if ok and v62.Type ~= ValueType.Ref then
                    t30[v62.Id] = result2
                    Codec.varuint(W, v62.Id)
                    Codec.writeValue(W, v62.Type, result2)
                    n1 += 1
                end
            end
        end

        W:patchU16(len, n1)
        p53.Stream:EndRecord()
        result:Destroy()
        p53.Defaults[p54] = t30

        return t30
    end

    if ok then
        result:Destroy()
    end

    p53.Defaults[p54] = false

    return nil
end

function t3.Destroy(p55) -- line: 483
    -- upvalues: Codec (copy)
    table.clear(p55.Ids)
    table.clear(p55.ById)
    table.clear(p55.ParentIds)
    table.clear(p55.Resolvers)
    table.clear(p55.UntrackHandlers)

    for _, v64 in p55.FilteredSignals do
        v64:Disconnect()
    end

    table.clear(p55.FilteredSignals)
    table.clear(p55.FilterNodes)
    table.clear(p55.FilterRoots)
    table.clear(p55.Pins)
    table.clear(p55.PinCounts)
    table.clear(p55.StandIns)
    Codec.setRefLookup(function() -- line: 498
        return nil
    end)
end

return t3
