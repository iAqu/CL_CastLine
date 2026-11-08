-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Checksum = require(ReplicatedStorage.Shared.Utils.Checksum)
local Log = require(ReplicatedStorage.Packages.Log)
local Shuffle = require(ReplicatedStorage.Shared.Utils.Numeric).Shuffle
local TreadmillMediaCatalog = require(ReplicatedStorage.Data.TreadmillMediaCatalog)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)

require(script.Parent.Types.Interface)

local t1 = {
    "Funny",
    "Brainrot",
    "Satisfying",
    "Funny",
    "Satisfying",
    "WeirdOrHorror",
    "Funny",
    "Brainrot",
    "Satisfying",
    "Funny",
    "Music"
}
local v1 = #t1
local v2 = Log.new()
local t2 = {}
local PathSeed = Checksum.PathSeed

local function createEmptyBucketIndices() -- line: 54
    return {
        Brainrot = {},
        Funny = {},
        Satisfying = {},
        WeirdOrHorror = {},
        Music = {}
    }
end

local function normalizeFeedIndex(p1) -- line: 64
    return (math.max(0, (math.floor(p1))))
end

local function normalizeReleaseVersion(p2) -- line: 68
    return (math.max(0, (math.floor(p2))))
end

local function normalizeSeed(p3, p4) -- line: 72
    -- upvalues: PathSeed (copy)
    if p3 > 0 then
        return (math.floor(p3))
    end

    return PathSeed("TreadmillMediaFeed", p4)
end

local function bucketForFeedIndex(p5) -- line: 79
    -- upvalues: t1 (copy), v1 (copy)
    return t1[(p5 - 1) % v1 + 1] or t1[1]
end

local function createBucketOrder(p6, p7, p8, p9) -- line: 84
    -- upvalues: Shuffle (copy), PathSeed (copy)
    return Shuffle(table.clone(p6), (Random.new(PathSeed(p9, p7, p8))))
end

local function createBucketOrders(p10, p11, p12) -- line: 95
    -- upvalues: Shuffle (copy), PathSeed (copy)
    local Brainrot = p10.Brainrot
    local t3 = {}

    t3.Brainrot = Shuffle(table.clone(Brainrot), (Random.new(PathSeed(p12, p11, "Brainrot"))))

    local Funny = p10.Funny

    t3.Funny = Shuffle(table.clone(Funny), (Random.new(PathSeed(p12, p11, "Funny"))))

    local Satisfying = p10.Satisfying

    t3.Satisfying = Shuffle(table.clone(Satisfying), (Random.new(PathSeed(p12, p11, "Satisfying"))))

    local WeirdOrHorror = p10.WeirdOrHorror

    t3.WeirdOrHorror = Shuffle(table.clone(WeirdOrHorror), (Random.new(PathSeed(p12, p11, "WeirdOrHorror"))))

    local Music = p10.Music

    t3.Music = Shuffle(table.clone(Music), (Random.new(PathSeed(p12, p11, "Music"))))

    return t3
end

local function takeNextFromBucket(p13, p14, p15) -- line: 134
    local v18 = p14[p15]
    local v19 = p13[p15][v18]

    if v19 == nil then
        return nil
    end

    p14[p15] = v18 + 1

    return v19
end

local function takeNextFromFallbackBucket(p16, p17, p18, p19) -- line: 148
    if p19 == p18 then
        return nil
    end

    local v20 = p17[p19]
    local v21 = p16[p19][v20]

    if v21 == nil then
        return nil
    end

    p17[p19] = v20 + 1

    return v21
end

local function takeNextPatternMedia(p20, p21, p22) -- line: 160
    local v22 = p21[p22]
    local v23 = p20[p22][v22]

    if v23 ~= nil then
        p21[p22] = v22 + 1
    end

    local v24

    if v23 then
        v24 = v23
    else
        local v25

        if p22 ~= "Brainrot" then
            local Brainrot = p21.Brainrot

            v25 = p20.Brainrot[Brainrot]

            if v25 ~= nil then
                p21.Brainrot = Brainrot + 1
            end
        end

        if v25 then
            v24 = v25
        else
            local v26

            if p22 ~= "Funny" then
                local Funny = p21.Funny

                v26 = p20.Funny[Funny]

                if v26 ~= nil then
                    p21.Funny = Funny + 1
                end
            end

            if v26 then
                v24 = v26
            else
                local v27

                if p22 ~= "Satisfying" then
                    local Satisfying = p21.Satisfying

                    v27 = p20.Satisfying[Satisfying]

                    if v27 ~= nil then
                        p21.Satisfying = Satisfying + 1
                    end
                end

                if v27 then
                    v24 = v27
                else
                    local v28

                    if p22 ~= "WeirdOrHorror" then
                        local WeirdOrHorror = p21.WeirdOrHorror

                        v28 = p20.WeirdOrHorror[WeirdOrHorror]

                        if v28 ~= nil then
                            p21.WeirdOrHorror = WeirdOrHorror + 1
                        end
                    end

                    if v28 then
                        v24 = v28
                    elseif p22 ~= "Music" then
                        local Music = p21.Music

                        v24 = p20.Music[Music]

                        if v24 ~= nil then
                            p21.Music = Music + 1
                        end
                    end
                end
            end
        end
    end

    assert(v24 ~= nil, "Expected unseen treadmill media while sequence is incomplete")

    return v24
end

local function generatePatternOrder(p23, p24, p25, p26, p27) -- line: 185
    -- upvalues: t1 (copy), v1 (copy), createBucketOrders (copy), takeNextPatternMedia (copy)
    local v30 = createBucketOrders(p23, p25, p26)
    local t4 = {
        Brainrot = 1,
        Funny = 1,
        Satisfying = 1,
        WeirdOrHorror = 1,
        Music = 1
    }
    local v31 = table.create(p24)

    for i = 1, p24 do
        v31[i] = takeNextPatternMedia(v30, t4, t1[(p27 + i - 1 - 1) % v1 + 1] or t1[1])
    end

    return v31
end

local function generateFullPass(p28, p29) -- line: 209
    -- upvalues: PathSeed (copy), generatePatternOrder (copy)
    local v34 = PathSeed("TreadmillMediaPass", p28.Seed, p29)
    local v35 = p29 * p28.TotalMediaCount + 1

    return (generatePatternOrder(p28.BucketIndices, p28.TotalMediaCount, v34, "TreadmillMediaPassBucket", v35))
end

local function resolveFullMediaIndex(p30, p31) -- line: 224
    -- upvalues: PathSeed (copy), generatePatternOrder (copy)
    local v37 = math.floor((p31 - 1) / p30.TotalMediaCount)

    if p30.CachedPassNumber ~= v37 then
        local v38 = PathSeed("TreadmillMediaPass", p30.Seed, v37)
        local v39 = v37 * p30.TotalMediaCount + 1

        p30.CachedPassOrder = generatePatternOrder(p30.BucketIndices, p30.TotalMediaCount, v38, "TreadmillMediaPassBucket", v39)
        p30.CachedPassNumber = v37
    end

    local v40 = (p31 - 1) % p30.TotalMediaCount + 1

    return p30.CachedPassOrder[v40]
end

local function exportState(p32) -- line: 237
    return {
        AlgorithmVersion = 5,
        Seed = p32.Seed,
        CurrentIndex = p32.CurrentIndex,
        HasSwappedRight = p32.HasSwappedRight,
        ReleaseTrackingInitialized = p32.ReleaseTrackingInitialized,
        FullFeedReleaseVersion = p32.FullFeedReleaseVersion,
        CompletedReleaseVersion = p32.CompletedReleaseVersion,
        PendingReleaseVersion = p32.PendingReleaseVersion,
        PendingCurrentMediaKey = p32.PendingCurrentMediaKey,
        SeenPendingMediaKeys = table.clone(p32.SeenPendingMediaKeys)
    }
end

local function statesEqual(p33, p34) -- line: 254
    if p33.Seed ~= p34.Seed
        or p33.CurrentIndex ~= p34.CurrentIndex
        or p33.AlgorithmVersion ~= p34.AlgorithmVersion
        or p33.HasSwappedRight ~= p34.HasSwappedRight
        or p33.ReleaseTrackingInitialized ~= p34.ReleaseTrackingInitialized
        or p33.FullFeedReleaseVersion ~= p34.FullFeedReleaseVersion
        or p33.CompletedReleaseVersion ~= p34.CompletedReleaseVersion
        or p33.PendingReleaseVersion ~= p34.PendingReleaseVersion
        or p33.PendingCurrentMediaKey ~= p34.PendingCurrentMediaKey then
        return false
    end

    for v41, v42 in pairs(p33.SeenPendingMediaKeys) do
        if v42 ~= p34.SeenPendingMediaKeys[v41] then
            return false
        end
    end

    for v43, v44 in pairs(p34.SeenPendingMediaKeys) do
        if v44 ~= p33.SeenPendingMediaKeys[v43] then
            return false
        end
    end

    return true
end

local function rebuildFullFeedCatalog(p35, p36) -- line: 285
    -- upvalues: createEmptyBucketIndices (copy)
    local v45 = createEmptyBucketIndices()
    local n1 = 0

    for v46, v47 in ipairs(p35.MediaEntries) do
        if v47.ReleaseVersion <= p36 then
            table.insert(v45[v47.BucketType], v46)
            n1 += 1
        end
    end

    assert(n1 > 0, (("Treadmill full feed release %* must not be empty"):format(p36)))
    p35.BucketIndices = v45
    p35.TotalMediaCount = n1
    p35.CachedPassNumber = nil
    p35.CachedPassOrder = {}
end

local function buildDeltaOrder(p37) -- line: 304
    -- upvalues: TreadmillMediaIdentity (copy), PathSeed (copy), createEmptyBucketIndices (copy), generatePatternOrder (copy)
    local v51 = createEmptyBucketIndices()
    local t5 = {}
    local n2 = 0

    for v52, v53 in ipairs(p37.MediaEntries) do
        if v53.ReleaseVersion > p37.CompletedReleaseVersion and v53.ReleaseVersion <= p37.PendingReleaseVersion then
            t5[TreadmillMediaIdentity.GetMediaKey(v53)] = v52
            table.insert(v51[v53.BucketType], v52)
            n2 += 1
        end
    end

    p37.DeltaMediaIndexByKey = t5
    p37.DeltaPosition = 0
    p37.DeltaCurrentMediaIndex = nil

    if n2 == 0 then
        p37.DeltaOrder = {}
    else
        p37.DeltaOrder = generatePatternOrder(v51, n2, PathSeed("TreadmillMediaDelta", p37.Seed, p37.PendingReleaseVersion), "TreadmillMediaDeltaBucket", 1)

        local PendingCurrentMediaKey = p37.PendingCurrentMediaKey

        if PendingCurrentMediaKey ~= nil then
            local v56 = t5[PendingCurrentMediaKey]

            if v56 ~= nil then
                p37.DeltaCurrentMediaIndex = v56

                for v57, v58 in ipairs(p37.DeltaOrder) do
                    if v58 == v56 then
                        p37.DeltaPosition = v57

                        return
                    end
                end
            else
                p37.PendingCurrentMediaKey = nil
            end
        end
    end
end

local function completeDelta(p38) -- line: 348
    -- upvalues: rebuildFullFeedCatalog (copy)
    p38.CompletedReleaseVersion = p38.PendingReleaseVersion
    p38.PendingReleaseVersion = 0
    p38.PendingCurrentMediaKey = nil
    p38.SeenPendingMediaKeys = {}
    p38.DeltaOrder = {}
    p38.DeltaMediaIndexByKey = {}
    p38.DeltaCurrentMediaIndex = nil
    p38.DeltaPosition = 0
    p38.CurrentIndex = 0
    p38.FullFeedReleaseVersion = p38.CurrentReleaseVersion
    rebuildFullFeedCatalog(p38, p38.FullFeedReleaseVersion)
end

local function takeNextDeltaMedia(p39) -- line: 362
    -- upvalues: TreadmillMediaIdentity (copy)
    local v59 = #p39.DeltaOrder
    local v60 = p39.DeltaPosition + 1

    if p39.DeltaCurrentMediaIndex == nil then
        v60 = 0

        for v61, v62 in ipairs(p39.DeltaOrder) do
            local v63 = TreadmillMediaIdentity.GetMediaKey(p39.MediaEntries[v62])

            if not p39.SeenPendingMediaKeys[v63] then
                v60 = v61
                break
            end

            v60 = 0
        end
    end

    if v60 < 1 or v59 < v60 then
        return nil
    end

    local v64 = p39.DeltaOrder[v60]
    local v65 = TreadmillMediaIdentity.GetMediaKey(p39.MediaEntries[v64])

    p39.DeltaPosition = v60
    p39.DeltaCurrentMediaIndex = v64
    p39.PendingCurrentMediaKey = v65
    p39.SeenPendingMediaKeys[v65] = true

    return v64
end

local function takePreviousDeltaMedia(p40) -- line: 388
    -- upvalues: TreadmillMediaIdentity (copy)
    for i = p40.DeltaPosition - 1, 1, -1 do
        local v66 = p40.DeltaOrder[i]
        local v67 = TreadmillMediaIdentity.GetMediaKey(p40.MediaEntries[v66])

        if p40.SeenPendingMediaKeys[v67] then
            p40.DeltaPosition = i
            p40.DeltaCurrentMediaIndex = v66
            p40.PendingCurrentMediaKey = v67

            return v66
        end
    end

    return nil
end

local function startDelta(p41) -- line: 402
    -- upvalues: buildDeltaOrder (copy), completeDelta (copy), takeNextDeltaMedia (copy)
    p41.PendingReleaseVersion = p41.CurrentReleaseVersion
    p41.PendingCurrentMediaKey = nil
    p41.SeenPendingMediaKeys = {}
    buildDeltaOrder(p41)

    local v68 = takeNextDeltaMedia(p41)

    if v68 == nil then
        completeDelta(p41)
    end

    return v68
end

local function takeNextFullMedia(p42) -- line: 414
    -- upvalues: PathSeed (copy), generatePatternOrder (copy)
    p42.CurrentIndex += 1

    if p42.FullFeedReleaseVersion == p42.CurrentReleaseVersion and p42.CurrentIndex >= p42.TotalMediaCount then
        p42.CompletedReleaseVersion = math.max(p42.CompletedReleaseVersion, p42.FullFeedReleaseVersion)
    end

    local CurrentIndex = p42.CurrentIndex
    local v70 = math.floor((CurrentIndex - 1) / p42.TotalMediaCount)

    if p42.CachedPassNumber ~= v70 then
        local v71 = PathSeed("TreadmillMediaPass", p42.Seed, v70)
        local v72 = v70 * p42.TotalMediaCount + 1

        p42.CachedPassOrder = generatePatternOrder(p42.BucketIndices, p42.TotalMediaCount, v71, "TreadmillMediaPassBucket", v72)
        p42.CachedPassNumber = v70
    end

    local v73 = (CurrentIndex - 1) % p42.TotalMediaCount + 1

    return p42.CachedPassOrder[v73]
end

function t2.IsReleaseTrackingStateCurrent(p43) -- line: 430
    if not (p43.Seed > 0) or p43.AlgorithmVersion ~= 5 or p43.HasSwappedRight == nil then
        return false
    end

    return p43.ReleaseTrackingInitialized
end

function t2.ResolveReleaseTrackingState(p44, p45, p46) -- line: 439
    -- upvalues: TreadmillMediaCatalog (copy), t2 (copy), PathSeed (copy)
    if t2.IsReleaseTrackingStateCurrent(p44) then
        return p44
    end

    local v75 = math.max(0, (math.floor(p44.CurrentIndex)))
    local v76 = p44.Seed > 0 and p44.AlgorithmVersion == 5
    local v77 = if not (v76 and TreadmillMediaCatalog.BASELINE_MEDIA_COUNT <= v75) then 0 else TreadmillMediaCatalog.BASELINE_RELEASE_VERSION
    local t6 = {
        AlgorithmVersion = 5,
        ReleaseTrackingInitialized = true,
        PendingReleaseVersion = 0,
        PendingCurrentMediaKey = nil
    }
    local v78 = if v76 then p44.Seed else 0

    t6.Seed = if v78 > 0 then math.floor(v78) else PathSeed("TreadmillMediaFeed", p45)
    t6.CurrentIndex = if not (v77 > 0) then 0 else v75
    t6.HasSwappedRight = p46
    t6.FullFeedReleaseVersion = if v77 > 0 then TreadmillMediaCatalog.BASELINE_RELEASE_VERSION else TreadmillMediaCatalog.CURRENT_RELEASE_VERSION
    t6.CompletedReleaseVersion = v77
    t6.SeenPendingMediaKeys = {}

    return t6
end

function t2.CreateRuntime(p47, p48, p49) -- line: 472
    -- upvalues: TreadmillMediaCatalog (copy), TreadmillMediaIdentity (copy), v2 (copy), PathSeed (copy), createEmptyBucketIndices (copy), rebuildFullFeedCatalog (copy), buildDeltaOrder (copy)
    assert(#p47 > 0, "Treadmill media catalog must not be empty")

    local v80 = createEmptyBucketIndices()
    local t7 = {}
    local v81 = TreadmillMediaCatalog.CURRENT_RELEASE_VERSION

    for v82, v83 in ipairs(p47) do
        v81 = math.max(v81, (TreadmillMediaCatalog.ResolveEntryReleaseVersion(v83.ReleaseVersion)))

        local v85 = TreadmillMediaIdentity.GetMediaKey(v83)

        assert(not t7[v85], (("Duplicate treadmill media key \"%*\""):format(v85)))
        t7[v85] = true
        table.insert(v80[v83.BucketType], v82)
    end

    local t8 = {
        CachedPassNumber = nil,
        CompletedReleaseVersion = 0,
        CurrentIndex = 0,
        DeltaCurrentMediaIndex = nil,
        DeltaPosition = 0,
        PendingCurrentMediaKey = nil,
        PendingReleaseVersion = 0,
        ReleaseTrackingInitialized = true,
        BucketIndices = v80,
        CachedPassOrder = {},
        CurrentReleaseVersion = v81,
        DeltaMediaIndexByKey = {},
        DeltaOrder = {},
        FullFeedReleaseVersion = v81,
        HasSwappedRight = p48.HasSwappedRight == true,
        MediaEntries = p47
    }
    local Seed = p48.Seed

    t8.Seed = if Seed > 0 then math.floor(Seed) else PathSeed("TreadmillMediaFeed", p49)
    t8.SeenPendingMediaKeys = {}
    t8.TotalMediaCount = #p47

    if p48.AlgorithmVersion == 5 then
        t8.CurrentIndex = math.max(0, (math.floor(p48.CurrentIndex)))

        if p48.ReleaseTrackingInitialized then
            t8.FullFeedReleaseVersion = math.max(0, (math.floor(p48.FullFeedReleaseVersion)))
            t8.CompletedReleaseVersion = math.min(math.max(0, (math.floor(p48.CompletedReleaseVersion))), v81)
            t8.PendingReleaseVersion = math.max(0, (math.floor(p48.PendingReleaseVersion)))
            t8.PendingCurrentMediaKey = p48.PendingCurrentMediaKey
            t8.SeenPendingMediaKeys = table.clone(p48.SeenPendingMediaKeys)
        end

        if t8.CompletedReleaseVersion == 0 and t8.FullFeedReleaseVersion ~= v81 then
            t8.CurrentIndex = 0
            t8.FullFeedReleaseVersion = v81
            t8.PendingReleaseVersion = 0
            t8.PendingCurrentMediaKey = nil
            t8.SeenPendingMediaKeys = {}
        end

        if t8.CompletedReleaseVersion > 0 and t8.FullFeedReleaseVersion == 0 then
            t8.FullFeedReleaseVersion = t8.CompletedReleaseVersion
        end

        if t8.PendingReleaseVersion <= t8.CompletedReleaseVersion or v81 < t8.PendingReleaseVersion then
            t8.PendingReleaseVersion = 0
            t8.PendingCurrentMediaKey = nil
            t8.SeenPendingMediaKeys = {}
        else
            buildDeltaOrder(t8)
        end
    else
        v2:AtTrace():Log("Resetting treadmill media feed state for algorithm version change")
    end

    rebuildFullFeedCatalog(t8, t8.FullFeedReleaseVersion)

    return t8
end

function t2.Next(p50) -- line: 558
    -- upvalues: PathSeed (copy), generatePatternOrder (copy), exportState (copy), completeDelta (copy), takeNextDeltaMedia (copy), startDelta (copy)
    p50.HasSwappedRight = true

    if p50.PendingReleaseVersion > p50.CompletedReleaseVersion then
        local v94 = takeNextDeltaMedia(p50)

        if v94 ~= nil then
            return v94, (exportState(p50))
        end

        completeDelta(p50)
    end

    if p50.CompletedReleaseVersion > 0 and p50.CompletedReleaseVersion < p50.CurrentReleaseVersion then
        local v95 = startDelta(p50)

        if v95 ~= nil then
            return v95, (exportState(p50))
        end
    end

    p50.CurrentIndex += 1

    if p50.FullFeedReleaseVersion == p50.CurrentReleaseVersion and p50.CurrentIndex >= p50.TotalMediaCount then
        p50.CompletedReleaseVersion = math.max(p50.CompletedReleaseVersion, p50.FullFeedReleaseVersion)
    end

    local CurrentIndex = p50.CurrentIndex
    local v97 = math.floor((CurrentIndex - 1) / p50.TotalMediaCount)

    if p50.CachedPassNumber ~= v97 then
        local v98 = PathSeed("TreadmillMediaPass", p50.Seed, v97)
        local v99 = v97 * p50.TotalMediaCount + 1

        p50.CachedPassOrder = generatePatternOrder(p50.BucketIndices, p50.TotalMediaCount, v98, "TreadmillMediaPassBucket", v99)
        p50.CachedPassNumber = v97
    end

    local v100 = (CurrentIndex - 1) % p50.TotalMediaCount + 1

    return p50.CachedPassOrder[v100], (exportState(p50))
end

function t2.Current(p51) -- line: 583
    -- upvalues: PathSeed (copy), generatePatternOrder (copy), exportState (copy), completeDelta (copy), takeNextDeltaMedia (copy)
    if p51.PendingReleaseVersion > p51.CompletedReleaseVersion then
        local DeltaCurrentMediaIndex = p51.DeltaCurrentMediaIndex

        if DeltaCurrentMediaIndex ~= nil then
            return DeltaCurrentMediaIndex, (exportState(p51))
        end

        local v101 = takeNextDeltaMedia(p51)

        if v101 ~= nil then
            return v101, (exportState(p51))
        end

        completeDelta(p51)
    end

    local v102 = math.max(p51.CurrentIndex, 1)

    p51.CurrentIndex = v102

    local v104 = math.floor((v102 - 1) / p51.TotalMediaCount)

    if p51.CachedPassNumber ~= v104 then
        local v105 = PathSeed("TreadmillMediaPass", p51.Seed, v104)
        local v106 = v104 * p51.TotalMediaCount + 1

        p51.CachedPassOrder = generatePatternOrder(p51.BucketIndices, p51.TotalMediaCount, v105, "TreadmillMediaPassBucket", v106)
        p51.CachedPassNumber = v104
    end

    local v107 = (v102 - 1) % p51.TotalMediaCount + 1

    return p51.CachedPassOrder[v107], (exportState(p51))
end

function t2.Previous(p52) -- line: 603
    -- upvalues: PathSeed (copy), generatePatternOrder (copy), exportState (copy), takePreviousDeltaMedia (copy)
    if p52.PendingReleaseVersion > p52.CompletedReleaseVersion then
        local DeltaCurrentMediaIndex = p52.DeltaCurrentMediaIndex

        assert(DeltaCurrentMediaIndex ~= nil, "Pending treadmill media delta must have a current media entry")

        local v109 = takePreviousDeltaMedia(p52)

        if v109 == nil then
            return DeltaCurrentMediaIndex, exportState(p52), false
        end

        return v109, exportState(p52), true
    end

    local v111 = math.max(p52.CurrentIndex - 1, 1)
    local v112 = v111 ~= p52.CurrentIndex

    p52.CurrentIndex = v111

    local v114 = math.floor((v111 - 1) / p52.TotalMediaCount)

    if p52.CachedPassNumber ~= v114 then
        local v115 = PathSeed("TreadmillMediaPass", p52.Seed, v114)
        local v116 = v114 * p52.TotalMediaCount + 1

        p52.CachedPassOrder = generatePatternOrder(p52.BucketIndices, p52.TotalMediaCount, v115, "TreadmillMediaPassBucket", v116)
        p52.CachedPassNumber = v114
    end

    local v117 = (v111 - 1) % p52.TotalMediaCount + 1

    return p52.CachedPassOrder[v117], exportState(p52), v112
end

function t2.ExportState(p53) -- line: 625
    -- upvalues: exportState (copy)
    return (exportState(p53))
end

function t2.StatesEqual(p54, p55) -- line: 631
    -- upvalues: statesEqual (copy)
    return (statesEqual(p54, p55))
end

function t2.IsLegalTransition(p56, p57, p58, p59) -- line: 638
    -- upvalues: t2 (copy), statesEqual (copy)
    if statesEqual(p57, p58) then
        return true
    end

    local v118 = t2.CreateRuntime(p56, p57, p59)
    local _, v119 = t2.Current(v118)

    if statesEqual(v119, p58) then
        return true
    end

    if p57.PendingReleaseVersion > p57.CompletedReleaseVersion then
        local v120 = t2.CreateRuntime(p56, p57, p59)
        local _, v121, v122 = t2.Previous(v120)

        if v122 and statesEqual(v121, p58) then
            return true
        end

        local v123 = t2.CreateRuntime(p56, p57, p59)
        local _, v124 = t2.Next(v123)

        return (statesEqual(v124, p58))
    end

    local v125 = t2.CreateRuntime(p56, p57, p59)
    local v126

    if p57.PendingReleaseVersion == 0 and p58.PendingReleaseVersion == 0 and p58.CurrentIndex < p57.CurrentIndex then
        local v127, v128

        v127, v126, v128 = t2.Previous(v125)

        if not v128 then
            return false
        end

        return (statesEqual(v126, p58))
    end

    local v129

    v129, v126 = t2.Next(v125)

    return (statesEqual(v126, p58))
end

return t2
